// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void* pa_start, void* pa_end);

extern char end[]; // first address after kernel.
// defined by kernel.ld.

struct run {
  struct run* next;
};

struct kernelmem
{
  struct spinlock lock;
  struct run* freelist;
} kmem;

struct ref {
  struct spinlock lock;
  int ref;
};

struct ref ref2pages[(PHYSTOP - KERNBASE) / PGSIZE];

void
kinit()
{
  for (int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++)
  {
    initlock(&(ref2pages[i].lock), "page_ref");
  }
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void* pa_start, void* pa_end)
{
  char* p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
  {
    ref2pages[((uint64)p - KERNBASE) / PGSIZE].ref = 1;
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void* pa)
{
  struct run* r;
  // 检查 pa 是否是页对齐的，是否在有效的物理地址范围内
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
  {
    printf("%p,%d\n", pa, krefget((void*)pa));
    panic("kfree");
  }

  // 计算物理页的索引 pg（从内核基地址 KERNBASE 开始）
  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
  acquire(&ref2pages[pg].lock);
  // 如果引用计数已经为零，表示此页已经被释放，调用 panic 函数终止程序
  if (ref2pages[pg].ref == 0)
  {
    release(&ref2pages[pg].lock);
    panic("kfree");
  }
  // 将引用计数减一
  ref2pages[pg].ref--;
  // 如果引用计数不为零，释放引用计数表的锁并返回
  if (ref2pages[pg].ref != 0)
  {
    release(&ref2pages[pg].lock);
    return;
  }
  else
  {
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);

    release(&ref2pages[pg].lock);
  }

}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void*
kalloc(void)
{
  struct run* r;
  // 全局锁
  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r){
    uint64 pg = ((uint64)r - KERNBASE) / PGSIZE;
    // 引用计数表项的锁
    acquire(&ref2pages[pg].lock);
    // 初始化内存引用计数为1
    ref2pages[pg].ref = 1;
    release(&ref2pages[pg].lock);
    kmem.freelist = r->next;
  }

  release(&kmem.lock);

  if (r)
    memset((char*)r, 5, PGSIZE); // fill with junk

  return (void*)r;
}

int krefget(void* pa)
{
  return ref2pages[((uint64)pa - KERNBASE) / PGSIZE].ref;
}

void
krefadd(void* pa)
{
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfrefadd");
  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
  acquire(&ref2pages[pg].lock);
  ref2pages[pg].ref++;
  release(&ref2pages[pg].lock);
}

void
krefdec(void* pa)
{
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfrefdec");
  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
  acquire(&ref2pages[pg].lock);
  ref2pages[pg].ref--;
  release(&ref2pages[pg].lock);
}
