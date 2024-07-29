
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	93013103          	ld	sp,-1744(sp) # 80008930 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	3c7050ef          	jal	ra,80005bdc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	272080e7          	jalr	626(ra) # 800002c0 <memset>

  r = (struct run*)pa;

  // 确保在获取CPU ID时不被中断
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	51e080e7          	jalr	1310(ra) # 80006574 <push_off>
  // 获取当前CPU的id
  int cpu = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	f16080e7          	jalr	-234(ra) # 80000f74 <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	5c8080e7          	jalr	1480(ra) # 80006630 <pop_off>

  acquire(&kmem[cpu].lock);
    80000070:	00009a97          	auipc	s5,0x9
    80000074:	fc0a8a93          	addi	s5,s5,-64 # 80009030 <kmem>
    80000078:	001a1993          	slli	s3,s4,0x1
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	0912                	slli	s2,s2,0x4
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	53a080e7          	jalr	1338(ra) # 800065c0 <acquire>
  // 将释放的内存块加入当前CPU的空闲链表
  r->next = kmem[cpu].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  // 更新空闲链表头指针
  kmem[cpu].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmem[cpu].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	5f6080e7          	jalr	1526(ra) # 80006690 <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f5c50513          	addi	a0,a0,-164 # 80008010 <etext+0x10>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	fd0080e7          	jalr	-48(ra) # 8000608c <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	e84a                	sd	s2,16(sp)
    800000ce:	e44e                	sd	s3,8(sp)
    800000d0:	e052                	sd	s4,0(sp)
    800000d2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d4:	6785                	lui	a5,0x1
    800000d6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000da:	94aa                	add	s1,s1,a0
    800000dc:	757d                	lui	a0,0xfffff
    800000de:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3a>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x28>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7139                	addi	sp,sp,-64
    80000110:	fc06                	sd	ra,56(sp)
    80000112:	f822                	sd	s0,48(sp)
    80000114:	f426                	sd	s1,40(sp)
    80000116:	f04a                	sd	s2,32(sp)
    80000118:	ec4e                	sd	s3,24(sp)
    8000011a:	0080                	addi	s0,sp,64
  for (int i = 0; i < NCPU; i++)
    8000011c:	00009917          	auipc	s2,0x9
    80000120:	f1490913          	addi	s2,s2,-236 # 80009030 <kmem>
    80000124:	4481                	li	s1,0
    snprintf(kmem[i].lockname, 8, "kmem_%d", i);
    80000126:	00008997          	auipc	s3,0x8
    8000012a:	ef298993          	addi	s3,s3,-270 # 80008018 <etext+0x18>
    8000012e:	86a6                	mv	a3,s1
    80000130:	864e                	mv	a2,s3
    80000132:	45a1                	li	a1,8
    80000134:	02890513          	addi	a0,s2,40
    80000138:	00006097          	auipc	ra,0x6
    8000013c:	8ba080e7          	jalr	-1862(ra) # 800059f2 <snprintf>
    initlock(&kmem[i].lock, buf);
    80000140:	fc040593          	addi	a1,s0,-64
    80000144:	854a                	mv	a0,s2
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	5f6080e7          	jalr	1526(ra) # 8000673c <initlock>
  for (int i = 0; i < NCPU; i++)
    8000014e:	2485                	addiw	s1,s1,1
    80000150:	03090913          	addi	s2,s2,48
    80000154:	47a1                	li	a5,8
    80000156:	fcf49ce3          	bne	s1,a5,8000012e <kinit+0x20>
  freerange(end, (void*)PHYSTOP);
    8000015a:	45c5                	li	a1,17
    8000015c:	05ee                	slli	a1,a1,0x1b
    8000015e:	0002b517          	auipc	a0,0x2b
    80000162:	0ea50513          	addi	a0,a0,234 # 8002b248 <end>
    80000166:	00000097          	auipc	ra,0x0
    8000016a:	f5e080e7          	jalr	-162(ra) # 800000c4 <freerange>
}
    8000016e:	70e2                	ld	ra,56(sp)
    80000170:	7442                	ld	s0,48(sp)
    80000172:	74a2                	ld	s1,40(sp)
    80000174:	7902                	ld	s2,32(sp)
    80000176:	69e2                	ld	s3,24(sp)
    80000178:	6121                	addi	sp,sp,64
    8000017a:	8082                	ret

000000008000017c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000017c:	7139                	addi	sp,sp,-64
    8000017e:	fc06                	sd	ra,56(sp)
    80000180:	f822                	sd	s0,48(sp)
    80000182:	f426                	sd	s1,40(sp)
    80000184:	f04a                	sd	s2,32(sp)
    80000186:	ec4e                	sd	s3,24(sp)
    80000188:	e852                	sd	s4,16(sp)
    8000018a:	e456                	sd	s5,8(sp)
    8000018c:	e05a                	sd	s6,0(sp)
    8000018e:	0080                	addi	s0,sp,64
  struct run *r;

  push_off();
    80000190:	00006097          	auipc	ra,0x6
    80000194:	3e4080e7          	jalr	996(ra) # 80006574 <push_off>
  int cpu = cpuid();
    80000198:	00001097          	auipc	ra,0x1
    8000019c:	ddc080e7          	jalr	-548(ra) # 80000f74 <cpuid>
    800001a0:	84aa                	mv	s1,a0
  pop_off();
    800001a2:	00006097          	auipc	ra,0x6
    800001a6:	48e080e7          	jalr	1166(ra) # 80006630 <pop_off>

  acquire(&kmem[cpu].lock);
    800001aa:	00149793          	slli	a5,s1,0x1
    800001ae:	97a6                	add	a5,a5,s1
    800001b0:	0792                	slli	a5,a5,0x4
    800001b2:	00009917          	auipc	s2,0x9
    800001b6:	e7e90913          	addi	s2,s2,-386 # 80009030 <kmem>
    800001ba:	993e                	add	s2,s2,a5
    800001bc:	854a                	mv	a0,s2
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	402080e7          	jalr	1026(ra) # 800065c0 <acquire>
  r = kmem[cpu].freelist;
    800001c6:	02093983          	ld	s3,32(s2)
  if(r)
    800001ca:	02098d63          	beqz	s3,80000204 <kalloc+0x88>
    kmem[cpu].freelist = r->next;
    800001ce:	0009b703          	ld	a4,0(s3)
    800001d2:	02e93023          	sd	a4,32(s2)
    }
    r = kmem[cpu].freelist;
    if (r)
      kmem[cpu].freelist = r->next;
  } // end steal page from other CPU
  release(&kmem[cpu].lock);
    800001d6:	854a                	mv	a0,s2
    800001d8:	00006097          	auipc	ra,0x6
    800001dc:	4b8080e7          	jalr	1208(ra) # 80006690 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001e0:	6605                	lui	a2,0x1
    800001e2:	4595                	li	a1,5
    800001e4:	854e                	mv	a0,s3
    800001e6:	00000097          	auipc	ra,0x0
    800001ea:	0da080e7          	jalr	218(ra) # 800002c0 <memset>
  return (void*)r;
}
    800001ee:	854e                	mv	a0,s3
    800001f0:	70e2                	ld	ra,56(sp)
    800001f2:	7442                	ld	s0,48(sp)
    800001f4:	74a2                	ld	s1,40(sp)
    800001f6:	7902                	ld	s2,32(sp)
    800001f8:	69e2                	ld	s3,24(sp)
    800001fa:	6a42                	ld	s4,16(sp)
    800001fc:	6aa2                	ld	s5,8(sp)
    800001fe:	6b02                	ld	s6,0(sp)
    80000200:	6121                	addi	sp,sp,64
    80000202:	8082                	ret
    80000204:	00009a97          	auipc	s5,0x9
    80000208:	e2ca8a93          	addi	s5,s5,-468 # 80009030 <kmem>
    for (int i = 0; i < NCPU; ++i)
    8000020c:	4981                	li	s3,0
    8000020e:	4b21                	li	s6,8
      if (i == cpu) // can't be itself
    80000210:	09348c63          	beq	s1,s3,800002a8 <kalloc+0x12c>
      acquire(&kmem[i].lock);
    80000214:	8a56                	mv	s4,s5
    80000216:	8556                	mv	a0,s5
    80000218:	00006097          	auipc	ra,0x6
    8000021c:	3a8080e7          	jalr	936(ra) # 800065c0 <acquire>
      tmp = kmem[i].freelist;
    80000220:	020ab603          	ld	a2,32(s5)
      if (tmp == 0) {
    80000224:	ce2d                	beqz	a2,8000029e <kalloc+0x122>
      tmp = kmem[i].freelist;
    80000226:	87b2                	mv	a5,a2
    80000228:	40000713          	li	a4,1024
          if (tmp->next)
    8000022c:	86be                	mv	a3,a5
    8000022e:	639c                	ld	a5,0(a5)
    80000230:	c781                	beqz	a5,80000238 <kalloc+0xbc>
        for (int j = 0; j < 1024; j++) {
    80000232:	377d                	addiw	a4,a4,-1
    80000234:	ff65                	bnez	a4,8000022c <kalloc+0xb0>
          if (tmp->next)
    80000236:	86be                	mv	a3,a5
        kmem[cpu].freelist = kmem[i].freelist;
    80000238:	00009717          	auipc	a4,0x9
    8000023c:	df870713          	addi	a4,a4,-520 # 80009030 <kmem>
    80000240:	00149793          	slli	a5,s1,0x1
    80000244:	97a6                	add	a5,a5,s1
    80000246:	0792                	slli	a5,a5,0x4
    80000248:	97ba                	add	a5,a5,a4
    8000024a:	f390                	sd	a2,32(a5)
        kmem[i].freelist = tmp->next;
    8000024c:	6290                	ld	a2,0(a3)
    8000024e:	00199793          	slli	a5,s3,0x1
    80000252:	99be                	add	s3,s3,a5
    80000254:	0992                	slli	s3,s3,0x4
    80000256:	99ba                	add	s3,s3,a4
    80000258:	02c9b023          	sd	a2,32(s3)
        tmp->next = 0;
    8000025c:	0006b023          	sd	zero,0(a3)
        release(&kmem[i].lock);
    80000260:	8552                	mv	a0,s4
    80000262:	00006097          	auipc	ra,0x6
    80000266:	42e080e7          	jalr	1070(ra) # 80006690 <release>
    r = kmem[cpu].freelist;
    8000026a:	00149793          	slli	a5,s1,0x1
    8000026e:	97a6                	add	a5,a5,s1
    80000270:	0792                	slli	a5,a5,0x4
    80000272:	00009717          	auipc	a4,0x9
    80000276:	dbe70713          	addi	a4,a4,-578 # 80009030 <kmem>
    8000027a:	97ba                	add	a5,a5,a4
    8000027c:	0207b983          	ld	s3,32(a5)
    if (r)
    80000280:	02098a63          	beqz	s3,800002b4 <kalloc+0x138>
      kmem[cpu].freelist = r->next;
    80000284:	0009b703          	ld	a4,0(s3)
    80000288:	00149793          	slli	a5,s1,0x1
    8000028c:	94be                	add	s1,s1,a5
    8000028e:	0492                	slli	s1,s1,0x4
    80000290:	00009797          	auipc	a5,0x9
    80000294:	da078793          	addi	a5,a5,-608 # 80009030 <kmem>
    80000298:	94be                	add	s1,s1,a5
    8000029a:	f098                	sd	a4,32(s1)
    8000029c:	bf2d                	j	800001d6 <kalloc+0x5a>
        release(&kmem[i].lock);
    8000029e:	8556                	mv	a0,s5
    800002a0:	00006097          	auipc	ra,0x6
    800002a4:	3f0080e7          	jalr	1008(ra) # 80006690 <release>
    for (int i = 0; i < NCPU; ++i)
    800002a8:	2985                	addiw	s3,s3,1
    800002aa:	030a8a93          	addi	s5,s5,48
    800002ae:	f76991e3          	bne	s3,s6,80000210 <kalloc+0x94>
    800002b2:	bf65                	j	8000026a <kalloc+0xee>
  release(&kmem[cpu].lock);
    800002b4:	854a                	mv	a0,s2
    800002b6:	00006097          	auipc	ra,0x6
    800002ba:	3da080e7          	jalr	986(ra) # 80006690 <release>
  if(r)
    800002be:	bf05                	j	800001ee <kalloc+0x72>

00000000800002c0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002c0:	1141                	addi	sp,sp,-16
    800002c2:	e422                	sd	s0,8(sp)
    800002c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002c6:	ce09                	beqz	a2,800002e0 <memset+0x20>
    800002c8:	87aa                	mv	a5,a0
    800002ca:	fff6071b          	addiw	a4,a2,-1
    800002ce:	1702                	slli	a4,a4,0x20
    800002d0:	9301                	srli	a4,a4,0x20
    800002d2:	0705                	addi	a4,a4,1
    800002d4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800002d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002da:	0785                	addi	a5,a5,1
    800002dc:	fee79de3          	bne	a5,a4,800002d6 <memset+0x16>
  }
  return dst;
}
    800002e0:	6422                	ld	s0,8(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret

00000000800002e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002ec:	ca05                	beqz	a2,8000031c <memcmp+0x36>
    800002ee:	fff6069b          	addiw	a3,a2,-1
    800002f2:	1682                	slli	a3,a3,0x20
    800002f4:	9281                	srli	a3,a3,0x20
    800002f6:	0685                	addi	a3,a3,1
    800002f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	0005c703          	lbu	a4,0(a1)
    80000302:	00e79863          	bne	a5,a4,80000312 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000306:	0505                	addi	a0,a0,1
    80000308:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000030a:	fed518e3          	bne	a0,a3,800002fa <memcmp+0x14>
  }

  return 0;
    8000030e:	4501                	li	a0,0
    80000310:	a019                	j	80000316 <memcmp+0x30>
      return *s1 - *s2;
    80000312:	40e7853b          	subw	a0,a5,a4
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  return 0;
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <memcmp+0x30>

0000000080000320 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e422                	sd	s0,8(sp)
    80000324:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000326:	ca0d                	beqz	a2,80000358 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000328:	00a5f963          	bgeu	a1,a0,8000033a <memmove+0x1a>
    8000032c:	02061693          	slli	a3,a2,0x20
    80000330:	9281                	srli	a3,a3,0x20
    80000332:	00d58733          	add	a4,a1,a3
    80000336:	02e56463          	bltu	a0,a4,8000035e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000033a:	fff6079b          	addiw	a5,a2,-1
    8000033e:	1782                	slli	a5,a5,0x20
    80000340:	9381                	srli	a5,a5,0x20
    80000342:	0785                	addi	a5,a5,1
    80000344:	97ae                	add	a5,a5,a1
    80000346:	872a                	mv	a4,a0
      *d++ = *s++;
    80000348:	0585                	addi	a1,a1,1
    8000034a:	0705                	addi	a4,a4,1
    8000034c:	fff5c683          	lbu	a3,-1(a1)
    80000350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000354:	fef59ae3          	bne	a1,a5,80000348 <memmove+0x28>

  return dst;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	addi	sp,sp,16
    8000035c:	8082                	ret
    d += n;
    8000035e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000360:	fff6079b          	addiw	a5,a2,-1
    80000364:	1782                	slli	a5,a5,0x20
    80000366:	9381                	srli	a5,a5,0x20
    80000368:	fff7c793          	not	a5,a5
    8000036c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000036e:	177d                	addi	a4,a4,-1
    80000370:	16fd                	addi	a3,a3,-1
    80000372:	00074603          	lbu	a2,0(a4)
    80000376:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000037a:	fef71ae3          	bne	a4,a5,8000036e <memmove+0x4e>
    8000037e:	bfe9                	j	80000358 <memmove+0x38>

0000000080000380 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000380:	1141                	addi	sp,sp,-16
    80000382:	e406                	sd	ra,8(sp)
    80000384:	e022                	sd	s0,0(sp)
    80000386:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	f98080e7          	jalr	-104(ra) # 80000320 <memmove>
}
    80000390:	60a2                	ld	ra,8(sp)
    80000392:	6402                	ld	s0,0(sp)
    80000394:	0141                	addi	sp,sp,16
    80000396:	8082                	ret

0000000080000398 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000398:	1141                	addi	sp,sp,-16
    8000039a:	e422                	sd	s0,8(sp)
    8000039c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000039e:	ce11                	beqz	a2,800003ba <strncmp+0x22>
    800003a0:	00054783          	lbu	a5,0(a0)
    800003a4:	cf89                	beqz	a5,800003be <strncmp+0x26>
    800003a6:	0005c703          	lbu	a4,0(a1)
    800003aa:	00f71a63          	bne	a4,a5,800003be <strncmp+0x26>
    n--, p++, q++;
    800003ae:	367d                	addiw	a2,a2,-1
    800003b0:	0505                	addi	a0,a0,1
    800003b2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003b4:	f675                	bnez	a2,800003a0 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003b6:	4501                	li	a0,0
    800003b8:	a809                	j	800003ca <strncmp+0x32>
    800003ba:	4501                	li	a0,0
    800003bc:	a039                	j	800003ca <strncmp+0x32>
  if(n == 0)
    800003be:	ca09                	beqz	a2,800003d0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003c0:	00054503          	lbu	a0,0(a0)
    800003c4:	0005c783          	lbu	a5,0(a1)
    800003c8:	9d1d                	subw	a0,a0,a5
}
    800003ca:	6422                	ld	s0,8(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret
    return 0;
    800003d0:	4501                	li	a0,0
    800003d2:	bfe5                	j	800003ca <strncmp+0x32>

00000000800003d4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003d4:	1141                	addi	sp,sp,-16
    800003d6:	e422                	sd	s0,8(sp)
    800003d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003da:	872a                	mv	a4,a0
    800003dc:	8832                	mv	a6,a2
    800003de:	367d                	addiw	a2,a2,-1
    800003e0:	01005963          	blez	a6,800003f2 <strncpy+0x1e>
    800003e4:	0705                	addi	a4,a4,1
    800003e6:	0005c783          	lbu	a5,0(a1)
    800003ea:	fef70fa3          	sb	a5,-1(a4)
    800003ee:	0585                	addi	a1,a1,1
    800003f0:	f7f5                	bnez	a5,800003dc <strncpy+0x8>
    ;
  while(n-- > 0)
    800003f2:	00c05d63          	blez	a2,8000040c <strncpy+0x38>
    800003f6:	86ba                	mv	a3,a4
    *s++ = 0;
    800003f8:	0685                	addi	a3,a3,1
    800003fa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003fe:	fff6c793          	not	a5,a3
    80000402:	9fb9                	addw	a5,a5,a4
    80000404:	010787bb          	addw	a5,a5,a6
    80000408:	fef048e3          	bgtz	a5,800003f8 <strncpy+0x24>
  return os;
}
    8000040c:	6422                	ld	s0,8(sp)
    8000040e:	0141                	addi	sp,sp,16
    80000410:	8082                	ret

0000000080000412 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000412:	1141                	addi	sp,sp,-16
    80000414:	e422                	sd	s0,8(sp)
    80000416:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000418:	02c05363          	blez	a2,8000043e <safestrcpy+0x2c>
    8000041c:	fff6069b          	addiw	a3,a2,-1
    80000420:	1682                	slli	a3,a3,0x20
    80000422:	9281                	srli	a3,a3,0x20
    80000424:	96ae                	add	a3,a3,a1
    80000426:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000428:	00d58963          	beq	a1,a3,8000043a <safestrcpy+0x28>
    8000042c:	0585                	addi	a1,a1,1
    8000042e:	0785                	addi	a5,a5,1
    80000430:	fff5c703          	lbu	a4,-1(a1)
    80000434:	fee78fa3          	sb	a4,-1(a5)
    80000438:	fb65                	bnez	a4,80000428 <safestrcpy+0x16>
    ;
  *s = 0;
    8000043a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000043e:	6422                	ld	s0,8(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <strlen>:

int
strlen(const char *s)
{
    80000444:	1141                	addi	sp,sp,-16
    80000446:	e422                	sd	s0,8(sp)
    80000448:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000044a:	00054783          	lbu	a5,0(a0)
    8000044e:	cf91                	beqz	a5,8000046a <strlen+0x26>
    80000450:	0505                	addi	a0,a0,1
    80000452:	87aa                	mv	a5,a0
    80000454:	4685                	li	a3,1
    80000456:	9e89                	subw	a3,a3,a0
    80000458:	00f6853b          	addw	a0,a3,a5
    8000045c:	0785                	addi	a5,a5,1
    8000045e:	fff7c703          	lbu	a4,-1(a5)
    80000462:	fb7d                	bnez	a4,80000458 <strlen+0x14>
    ;
  return n;
}
    80000464:	6422                	ld	s0,8(sp)
    80000466:	0141                	addi	sp,sp,16
    80000468:	8082                	ret
  for(n = 0; s[n]; n++)
    8000046a:	4501                	li	a0,0
    8000046c:	bfe5                	j	80000464 <strlen+0x20>

000000008000046e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000046e:	1101                	addi	sp,sp,-32
    80000470:	ec06                	sd	ra,24(sp)
    80000472:	e822                	sd	s0,16(sp)
    80000474:	e426                	sd	s1,8(sp)
    80000476:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000478:	00001097          	auipc	ra,0x1
    8000047c:	afc080e7          	jalr	-1284(ra) # 80000f74 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000480:	00009497          	auipc	s1,0x9
    80000484:	b8048493          	addi	s1,s1,-1152 # 80009000 <started>
  if(cpuid() == 0){
    80000488:	c531                	beqz	a0,800004d4 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000048a:	8526                	mv	a0,s1
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	346080e7          	jalr	838(ra) # 800067d2 <lockfree_read4>
    80000494:	d97d                	beqz	a0,8000048a <main+0x1c>
      ;
    __sync_synchronize();
    80000496:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000049a:	00001097          	auipc	ra,0x1
    8000049e:	ada080e7          	jalr	-1318(ra) # 80000f74 <cpuid>
    800004a2:	85aa                	mv	a1,a0
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	b9450513          	addi	a0,a0,-1132 # 80008038 <etext+0x38>
    800004ac:	00006097          	auipc	ra,0x6
    800004b0:	c2a080e7          	jalr	-982(ra) # 800060d6 <printf>
    kvminithart();    // turn on paging
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	0e0080e7          	jalr	224(ra) # 80000594 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004bc:	00001097          	auipc	ra,0x1
    800004c0:	730080e7          	jalr	1840(ra) # 80001bec <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004c4:	00005097          	auipc	ra,0x5
    800004c8:	d6c080e7          	jalr	-660(ra) # 80005230 <plicinithart>
  }

  scheduler();        
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	fde080e7          	jalr	-34(ra) # 800014aa <scheduler>
    consoleinit();
    800004d4:	00006097          	auipc	ra,0x6
    800004d8:	aca080e7          	jalr	-1334(ra) # 80005f9e <consoleinit>
    statsinit();
    800004dc:	00005097          	auipc	ra,0x5
    800004e0:	43a080e7          	jalr	1082(ra) # 80005916 <statsinit>
    printfinit();
    800004e4:	00006097          	auipc	ra,0x6
    800004e8:	dd8080e7          	jalr	-552(ra) # 800062bc <printfinit>
    printf("\n");
    800004ec:	00008517          	auipc	a0,0x8
    800004f0:	38450513          	addi	a0,a0,900 # 80008870 <digits+0x88>
    800004f4:	00006097          	auipc	ra,0x6
    800004f8:	be2080e7          	jalr	-1054(ra) # 800060d6 <printf>
    printf("xv6 kernel is booting\n");
    800004fc:	00008517          	auipc	a0,0x8
    80000500:	b2450513          	addi	a0,a0,-1244 # 80008020 <etext+0x20>
    80000504:	00006097          	auipc	ra,0x6
    80000508:	bd2080e7          	jalr	-1070(ra) # 800060d6 <printf>
    printf("\n");
    8000050c:	00008517          	auipc	a0,0x8
    80000510:	36450513          	addi	a0,a0,868 # 80008870 <digits+0x88>
    80000514:	00006097          	auipc	ra,0x6
    80000518:	bc2080e7          	jalr	-1086(ra) # 800060d6 <printf>
    kinit();         // physical page allocator
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	bf2080e7          	jalr	-1038(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    80000524:	00000097          	auipc	ra,0x0
    80000528:	322080e7          	jalr	802(ra) # 80000846 <kvminit>
    kvminithart();   // turn on paging
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	068080e7          	jalr	104(ra) # 80000594 <kvminithart>
    procinit();      // process table
    80000534:	00001097          	auipc	ra,0x1
    80000538:	990080e7          	jalr	-1648(ra) # 80000ec4 <procinit>
    trapinit();      // trap vectors
    8000053c:	00001097          	auipc	ra,0x1
    80000540:	688080e7          	jalr	1672(ra) # 80001bc4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000544:	00001097          	auipc	ra,0x1
    80000548:	6a8080e7          	jalr	1704(ra) # 80001bec <trapinithart>
    plicinit();      // set up interrupt controller
    8000054c:	00005097          	auipc	ra,0x5
    80000550:	cce080e7          	jalr	-818(ra) # 8000521a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000554:	00005097          	auipc	ra,0x5
    80000558:	cdc080e7          	jalr	-804(ra) # 80005230 <plicinithart>
    binit();         // buffer cache
    8000055c:	00002097          	auipc	ra,0x2
    80000560:	dd2080e7          	jalr	-558(ra) # 8000232e <binit>
    iinit();         // inode table
    80000564:	00002097          	auipc	ra,0x2
    80000568:	53a080e7          	jalr	1338(ra) # 80002a9e <iinit>
    fileinit();      // file table
    8000056c:	00003097          	auipc	ra,0x3
    80000570:	4e4080e7          	jalr	1252(ra) # 80003a50 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000574:	00005097          	auipc	ra,0x5
    80000578:	dde080e7          	jalr	-546(ra) # 80005352 <virtio_disk_init>
    userinit();      // first user process
    8000057c:	00001097          	auipc	ra,0x1
    80000580:	cfc080e7          	jalr	-772(ra) # 80001278 <userinit>
    __sync_synchronize();
    80000584:	0ff0000f          	fence
    started = 1;
    80000588:	4785                	li	a5,1
    8000058a:	00009717          	auipc	a4,0x9
    8000058e:	a6f72b23          	sw	a5,-1418(a4) # 80009000 <started>
    80000592:	bf2d                	j	800004cc <main+0x5e>

0000000080000594 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000594:	1141                	addi	sp,sp,-16
    80000596:	e422                	sd	s0,8(sp)
    80000598:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000059a:	00009797          	auipc	a5,0x9
    8000059e:	a6e7b783          	ld	a5,-1426(a5) # 80009008 <kernel_pagetable>
    800005a2:	83b1                	srli	a5,a5,0xc
    800005a4:	577d                	li	a4,-1
    800005a6:	177e                	slli	a4,a4,0x3f
    800005a8:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005aa:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005ae:	12000073          	sfence.vma
  sfence_vma();
}
    800005b2:	6422                	ld	s0,8(sp)
    800005b4:	0141                	addi	sp,sp,16
    800005b6:	8082                	ret

00000000800005b8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005b8:	7139                	addi	sp,sp,-64
    800005ba:	fc06                	sd	ra,56(sp)
    800005bc:	f822                	sd	s0,48(sp)
    800005be:	f426                	sd	s1,40(sp)
    800005c0:	f04a                	sd	s2,32(sp)
    800005c2:	ec4e                	sd	s3,24(sp)
    800005c4:	e852                	sd	s4,16(sp)
    800005c6:	e456                	sd	s5,8(sp)
    800005c8:	e05a                	sd	s6,0(sp)
    800005ca:	0080                	addi	s0,sp,64
    800005cc:	84aa                	mv	s1,a0
    800005ce:	89ae                	mv	s3,a1
    800005d0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005d2:	57fd                	li	a5,-1
    800005d4:	83e9                	srli	a5,a5,0x1a
    800005d6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005d8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005da:	04b7f263          	bgeu	a5,a1,8000061e <walk+0x66>
    panic("walk");
    800005de:	00008517          	auipc	a0,0x8
    800005e2:	a7250513          	addi	a0,a0,-1422 # 80008050 <etext+0x50>
    800005e6:	00006097          	auipc	ra,0x6
    800005ea:	aa6080e7          	jalr	-1370(ra) # 8000608c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005ee:	060a8663          	beqz	s5,8000065a <walk+0xa2>
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	b8a080e7          	jalr	-1142(ra) # 8000017c <kalloc>
    800005fa:	84aa                	mv	s1,a0
    800005fc:	c529                	beqz	a0,80000646 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005fe:	6605                	lui	a2,0x1
    80000600:	4581                	li	a1,0
    80000602:	00000097          	auipc	ra,0x0
    80000606:	cbe080e7          	jalr	-834(ra) # 800002c0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000060a:	00c4d793          	srli	a5,s1,0xc
    8000060e:	07aa                	slli	a5,a5,0xa
    80000610:	0017e793          	ori	a5,a5,1
    80000614:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000618:	3a5d                	addiw	s4,s4,-9
    8000061a:	036a0063          	beq	s4,s6,8000063a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000061e:	0149d933          	srl	s2,s3,s4
    80000622:	1ff97913          	andi	s2,s2,511
    80000626:	090e                	slli	s2,s2,0x3
    80000628:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000062a:	00093483          	ld	s1,0(s2)
    8000062e:	0014f793          	andi	a5,s1,1
    80000632:	dfd5                	beqz	a5,800005ee <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000634:	80a9                	srli	s1,s1,0xa
    80000636:	04b2                	slli	s1,s1,0xc
    80000638:	b7c5                	j	80000618 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000063a:	00c9d513          	srli	a0,s3,0xc
    8000063e:	1ff57513          	andi	a0,a0,511
    80000642:	050e                	slli	a0,a0,0x3
    80000644:	9526                	add	a0,a0,s1
}
    80000646:	70e2                	ld	ra,56(sp)
    80000648:	7442                	ld	s0,48(sp)
    8000064a:	74a2                	ld	s1,40(sp)
    8000064c:	7902                	ld	s2,32(sp)
    8000064e:	69e2                	ld	s3,24(sp)
    80000650:	6a42                	ld	s4,16(sp)
    80000652:	6aa2                	ld	s5,8(sp)
    80000654:	6b02                	ld	s6,0(sp)
    80000656:	6121                	addi	sp,sp,64
    80000658:	8082                	ret
        return 0;
    8000065a:	4501                	li	a0,0
    8000065c:	b7ed                	j	80000646 <walk+0x8e>

000000008000065e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000065e:	57fd                	li	a5,-1
    80000660:	83e9                	srli	a5,a5,0x1a
    80000662:	00b7f463          	bgeu	a5,a1,8000066a <walkaddr+0xc>
    return 0;
    80000666:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000668:	8082                	ret
{
    8000066a:	1141                	addi	sp,sp,-16
    8000066c:	e406                	sd	ra,8(sp)
    8000066e:	e022                	sd	s0,0(sp)
    80000670:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000672:	4601                	li	a2,0
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f44080e7          	jalr	-188(ra) # 800005b8 <walk>
  if(pte == 0)
    8000067c:	c105                	beqz	a0,8000069c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000067e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000680:	0117f693          	andi	a3,a5,17
    80000684:	4745                	li	a4,17
    return 0;
    80000686:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000688:	00e68663          	beq	a3,a4,80000694 <walkaddr+0x36>
}
    8000068c:	60a2                	ld	ra,8(sp)
    8000068e:	6402                	ld	s0,0(sp)
    80000690:	0141                	addi	sp,sp,16
    80000692:	8082                	ret
  pa = PTE2PA(*pte);
    80000694:	00a7d513          	srli	a0,a5,0xa
    80000698:	0532                	slli	a0,a0,0xc
  return pa;
    8000069a:	bfcd                	j	8000068c <walkaddr+0x2e>
    return 0;
    8000069c:	4501                	li	a0,0
    8000069e:	b7fd                	j	8000068c <walkaddr+0x2e>

00000000800006a0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006a0:	715d                	addi	sp,sp,-80
    800006a2:	e486                	sd	ra,72(sp)
    800006a4:	e0a2                	sd	s0,64(sp)
    800006a6:	fc26                	sd	s1,56(sp)
    800006a8:	f84a                	sd	s2,48(sp)
    800006aa:	f44e                	sd	s3,40(sp)
    800006ac:	f052                	sd	s4,32(sp)
    800006ae:	ec56                	sd	s5,24(sp)
    800006b0:	e85a                	sd	s6,16(sp)
    800006b2:	e45e                	sd	s7,8(sp)
    800006b4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006b6:	c205                	beqz	a2,800006d6 <mappages+0x36>
    800006b8:	8aaa                	mv	s5,a0
    800006ba:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006bc:	77fd                	lui	a5,0xfffff
    800006be:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800006c2:	15fd                	addi	a1,a1,-1
    800006c4:	00c589b3          	add	s3,a1,a2
    800006c8:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800006cc:	8952                	mv	s2,s4
    800006ce:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006d2:	6b85                	lui	s7,0x1
    800006d4:	a015                	j	800006f8 <mappages+0x58>
    panic("mappages: size");
    800006d6:	00008517          	auipc	a0,0x8
    800006da:	98250513          	addi	a0,a0,-1662 # 80008058 <etext+0x58>
    800006de:	00006097          	auipc	ra,0x6
    800006e2:	9ae080e7          	jalr	-1618(ra) # 8000608c <panic>
      panic("mappages: remap");
    800006e6:	00008517          	auipc	a0,0x8
    800006ea:	98250513          	addi	a0,a0,-1662 # 80008068 <etext+0x68>
    800006ee:	00006097          	auipc	ra,0x6
    800006f2:	99e080e7          	jalr	-1634(ra) # 8000608c <panic>
    a += PGSIZE;
    800006f6:	995e                	add	s2,s2,s7
  for(;;){
    800006f8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006fc:	4605                	li	a2,1
    800006fe:	85ca                	mv	a1,s2
    80000700:	8556                	mv	a0,s5
    80000702:	00000097          	auipc	ra,0x0
    80000706:	eb6080e7          	jalr	-330(ra) # 800005b8 <walk>
    8000070a:	cd19                	beqz	a0,80000728 <mappages+0x88>
    if(*pte & PTE_V)
    8000070c:	611c                	ld	a5,0(a0)
    8000070e:	8b85                	andi	a5,a5,1
    80000710:	fbf9                	bnez	a5,800006e6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000712:	80b1                	srli	s1,s1,0xc
    80000714:	04aa                	slli	s1,s1,0xa
    80000716:	0164e4b3          	or	s1,s1,s6
    8000071a:	0014e493          	ori	s1,s1,1
    8000071e:	e104                	sd	s1,0(a0)
    if(a == last)
    80000720:	fd391be3          	bne	s2,s3,800006f6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000724:	4501                	li	a0,0
    80000726:	a011                	j	8000072a <mappages+0x8a>
      return -1;
    80000728:	557d                	li	a0,-1
}
    8000072a:	60a6                	ld	ra,72(sp)
    8000072c:	6406                	ld	s0,64(sp)
    8000072e:	74e2                	ld	s1,56(sp)
    80000730:	7942                	ld	s2,48(sp)
    80000732:	79a2                	ld	s3,40(sp)
    80000734:	7a02                	ld	s4,32(sp)
    80000736:	6ae2                	ld	s5,24(sp)
    80000738:	6b42                	ld	s6,16(sp)
    8000073a:	6ba2                	ld	s7,8(sp)
    8000073c:	6161                	addi	sp,sp,80
    8000073e:	8082                	ret

0000000080000740 <kvmmap>:
{
    80000740:	1141                	addi	sp,sp,-16
    80000742:	e406                	sd	ra,8(sp)
    80000744:	e022                	sd	s0,0(sp)
    80000746:	0800                	addi	s0,sp,16
    80000748:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000074a:	86b2                	mv	a3,a2
    8000074c:	863e                	mv	a2,a5
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	f52080e7          	jalr	-174(ra) # 800006a0 <mappages>
    80000756:	e509                	bnez	a0,80000760 <kvmmap+0x20>
}
    80000758:	60a2                	ld	ra,8(sp)
    8000075a:	6402                	ld	s0,0(sp)
    8000075c:	0141                	addi	sp,sp,16
    8000075e:	8082                	ret
    panic("kvmmap");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	91850513          	addi	a0,a0,-1768 # 80008078 <etext+0x78>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	924080e7          	jalr	-1756(ra) # 8000608c <panic>

0000000080000770 <kvmmake>:
{
    80000770:	1101                	addi	sp,sp,-32
    80000772:	ec06                	sd	ra,24(sp)
    80000774:	e822                	sd	s0,16(sp)
    80000776:	e426                	sd	s1,8(sp)
    80000778:	e04a                	sd	s2,0(sp)
    8000077a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	a00080e7          	jalr	-1536(ra) # 8000017c <kalloc>
    80000784:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	b36080e7          	jalr	-1226(ra) # 800002c0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000792:	4719                	li	a4,6
    80000794:	6685                	lui	a3,0x1
    80000796:	10000637          	lui	a2,0x10000
    8000079a:	100005b7          	lui	a1,0x10000
    8000079e:	8526                	mv	a0,s1
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	fa0080e7          	jalr	-96(ra) # 80000740 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007a8:	4719                	li	a4,6
    800007aa:	6685                	lui	a3,0x1
    800007ac:	10001637          	lui	a2,0x10001
    800007b0:	100015b7          	lui	a1,0x10001
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	f8a080e7          	jalr	-118(ra) # 80000740 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007be:	4719                	li	a4,6
    800007c0:	004006b7          	lui	a3,0x400
    800007c4:	0c000637          	lui	a2,0xc000
    800007c8:	0c0005b7          	lui	a1,0xc000
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f72080e7          	jalr	-142(ra) # 80000740 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007d6:	00008917          	auipc	s2,0x8
    800007da:	82a90913          	addi	s2,s2,-2006 # 80008000 <etext>
    800007de:	4729                	li	a4,10
    800007e0:	80008697          	auipc	a3,0x80008
    800007e4:	82068693          	addi	a3,a3,-2016 # 8000 <_entry-0x7fff8000>
    800007e8:	4605                	li	a2,1
    800007ea:	067e                	slli	a2,a2,0x1f
    800007ec:	85b2                	mv	a1,a2
    800007ee:	8526                	mv	a0,s1
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	f50080e7          	jalr	-176(ra) # 80000740 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007f8:	4719                	li	a4,6
    800007fa:	46c5                	li	a3,17
    800007fc:	06ee                	slli	a3,a3,0x1b
    800007fe:	412686b3          	sub	a3,a3,s2
    80000802:	864a                	mv	a2,s2
    80000804:	85ca                	mv	a1,s2
    80000806:	8526                	mv	a0,s1
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	f38080e7          	jalr	-200(ra) # 80000740 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000810:	4729                	li	a4,10
    80000812:	6685                	lui	a3,0x1
    80000814:	00006617          	auipc	a2,0x6
    80000818:	7ec60613          	addi	a2,a2,2028 # 80007000 <_trampoline>
    8000081c:	040005b7          	lui	a1,0x4000
    80000820:	15fd                	addi	a1,a1,-1
    80000822:	05b2                	slli	a1,a1,0xc
    80000824:	8526                	mv	a0,s1
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	f1a080e7          	jalr	-230(ra) # 80000740 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000082e:	8526                	mv	a0,s1
    80000830:	00000097          	auipc	ra,0x0
    80000834:	5fe080e7          	jalr	1534(ra) # 80000e2e <proc_mapstacks>
}
    80000838:	8526                	mv	a0,s1
    8000083a:	60e2                	ld	ra,24(sp)
    8000083c:	6442                	ld	s0,16(sp)
    8000083e:	64a2                	ld	s1,8(sp)
    80000840:	6902                	ld	s2,0(sp)
    80000842:	6105                	addi	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <kvminit>:
{
    80000846:	1141                	addi	sp,sp,-16
    80000848:	e406                	sd	ra,8(sp)
    8000084a:	e022                	sd	s0,0(sp)
    8000084c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	f22080e7          	jalr	-222(ra) # 80000770 <kvmmake>
    80000856:	00008797          	auipc	a5,0x8
    8000085a:	7aa7b923          	sd	a0,1970(a5) # 80009008 <kernel_pagetable>
}
    8000085e:	60a2                	ld	ra,8(sp)
    80000860:	6402                	ld	s0,0(sp)
    80000862:	0141                	addi	sp,sp,16
    80000864:	8082                	ret

0000000080000866 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000866:	715d                	addi	sp,sp,-80
    80000868:	e486                	sd	ra,72(sp)
    8000086a:	e0a2                	sd	s0,64(sp)
    8000086c:	fc26                	sd	s1,56(sp)
    8000086e:	f84a                	sd	s2,48(sp)
    80000870:	f44e                	sd	s3,40(sp)
    80000872:	f052                	sd	s4,32(sp)
    80000874:	ec56                	sd	s5,24(sp)
    80000876:	e85a                	sd	s6,16(sp)
    80000878:	e45e                	sd	s7,8(sp)
    8000087a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000087c:	03459793          	slli	a5,a1,0x34
    80000880:	e795                	bnez	a5,800008ac <uvmunmap+0x46>
    80000882:	8a2a                	mv	s4,a0
    80000884:	892e                	mv	s2,a1
    80000886:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000888:	0632                	slli	a2,a2,0xc
    8000088a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000088e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000890:	6b05                	lui	s6,0x1
    80000892:	0735e863          	bltu	a1,s3,80000902 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000896:	60a6                	ld	ra,72(sp)
    80000898:	6406                	ld	s0,64(sp)
    8000089a:	74e2                	ld	s1,56(sp)
    8000089c:	7942                	ld	s2,48(sp)
    8000089e:	79a2                	ld	s3,40(sp)
    800008a0:	7a02                	ld	s4,32(sp)
    800008a2:	6ae2                	ld	s5,24(sp)
    800008a4:	6b42                	ld	s6,16(sp)
    800008a6:	6ba2                	ld	s7,8(sp)
    800008a8:	6161                	addi	sp,sp,80
    800008aa:	8082                	ret
    panic("uvmunmap: not aligned");
    800008ac:	00007517          	auipc	a0,0x7
    800008b0:	7d450513          	addi	a0,a0,2004 # 80008080 <etext+0x80>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	7d8080e7          	jalr	2008(ra) # 8000608c <panic>
      panic("uvmunmap: walk");
    800008bc:	00007517          	auipc	a0,0x7
    800008c0:	7dc50513          	addi	a0,a0,2012 # 80008098 <etext+0x98>
    800008c4:	00005097          	auipc	ra,0x5
    800008c8:	7c8080e7          	jalr	1992(ra) # 8000608c <panic>
      panic("uvmunmap: not mapped");
    800008cc:	00007517          	auipc	a0,0x7
    800008d0:	7dc50513          	addi	a0,a0,2012 # 800080a8 <etext+0xa8>
    800008d4:	00005097          	auipc	ra,0x5
    800008d8:	7b8080e7          	jalr	1976(ra) # 8000608c <panic>
      panic("uvmunmap: not a leaf");
    800008dc:	00007517          	auipc	a0,0x7
    800008e0:	7e450513          	addi	a0,a0,2020 # 800080c0 <etext+0xc0>
    800008e4:	00005097          	auipc	ra,0x5
    800008e8:	7a8080e7          	jalr	1960(ra) # 8000608c <panic>
      uint64 pa = PTE2PA(*pte);
    800008ec:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008ee:	0532                	slli	a0,a0,0xc
    800008f0:	fffff097          	auipc	ra,0xfffff
    800008f4:	72c080e7          	jalr	1836(ra) # 8000001c <kfree>
    *pte = 0;
    800008f8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008fc:	995a                	add	s2,s2,s6
    800008fe:	f9397ce3          	bgeu	s2,s3,80000896 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000902:	4601                	li	a2,0
    80000904:	85ca                	mv	a1,s2
    80000906:	8552                	mv	a0,s4
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	cb0080e7          	jalr	-848(ra) # 800005b8 <walk>
    80000910:	84aa                	mv	s1,a0
    80000912:	d54d                	beqz	a0,800008bc <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000914:	6108                	ld	a0,0(a0)
    80000916:	00157793          	andi	a5,a0,1
    8000091a:	dbcd                	beqz	a5,800008cc <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000091c:	3ff57793          	andi	a5,a0,1023
    80000920:	fb778ee3          	beq	a5,s7,800008dc <uvmunmap+0x76>
    if(do_free){
    80000924:	fc0a8ae3          	beqz	s5,800008f8 <uvmunmap+0x92>
    80000928:	b7d1                	j	800008ec <uvmunmap+0x86>

000000008000092a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000092a:	1101                	addi	sp,sp,-32
    8000092c:	ec06                	sd	ra,24(sp)
    8000092e:	e822                	sd	s0,16(sp)
    80000930:	e426                	sd	s1,8(sp)
    80000932:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000934:	00000097          	auipc	ra,0x0
    80000938:	848080e7          	jalr	-1976(ra) # 8000017c <kalloc>
    8000093c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000093e:	c519                	beqz	a0,8000094c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000940:	6605                	lui	a2,0x1
    80000942:	4581                	li	a1,0
    80000944:	00000097          	auipc	ra,0x0
    80000948:	97c080e7          	jalr	-1668(ra) # 800002c0 <memset>
  return pagetable;
}
    8000094c:	8526                	mv	a0,s1
    8000094e:	60e2                	ld	ra,24(sp)
    80000950:	6442                	ld	s0,16(sp)
    80000952:	64a2                	ld	s1,8(sp)
    80000954:	6105                	addi	sp,sp,32
    80000956:	8082                	ret

0000000080000958 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000958:	7179                	addi	sp,sp,-48
    8000095a:	f406                	sd	ra,40(sp)
    8000095c:	f022                	sd	s0,32(sp)
    8000095e:	ec26                	sd	s1,24(sp)
    80000960:	e84a                	sd	s2,16(sp)
    80000962:	e44e                	sd	s3,8(sp)
    80000964:	e052                	sd	s4,0(sp)
    80000966:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000968:	6785                	lui	a5,0x1
    8000096a:	04f67863          	bgeu	a2,a5,800009ba <uvminit+0x62>
    8000096e:	8a2a                	mv	s4,a0
    80000970:	89ae                	mv	s3,a1
    80000972:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000974:	00000097          	auipc	ra,0x0
    80000978:	808080e7          	jalr	-2040(ra) # 8000017c <kalloc>
    8000097c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000097e:	6605                	lui	a2,0x1
    80000980:	4581                	li	a1,0
    80000982:	00000097          	auipc	ra,0x0
    80000986:	93e080e7          	jalr	-1730(ra) # 800002c0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000098a:	4779                	li	a4,30
    8000098c:	86ca                	mv	a3,s2
    8000098e:	6605                	lui	a2,0x1
    80000990:	4581                	li	a1,0
    80000992:	8552                	mv	a0,s4
    80000994:	00000097          	auipc	ra,0x0
    80000998:	d0c080e7          	jalr	-756(ra) # 800006a0 <mappages>
  memmove(mem, src, sz);
    8000099c:	8626                	mv	a2,s1
    8000099e:	85ce                	mv	a1,s3
    800009a0:	854a                	mv	a0,s2
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	97e080e7          	jalr	-1666(ra) # 80000320 <memmove>
}
    800009aa:	70a2                	ld	ra,40(sp)
    800009ac:	7402                	ld	s0,32(sp)
    800009ae:	64e2                	ld	s1,24(sp)
    800009b0:	6942                	ld	s2,16(sp)
    800009b2:	69a2                	ld	s3,8(sp)
    800009b4:	6a02                	ld	s4,0(sp)
    800009b6:	6145                	addi	sp,sp,48
    800009b8:	8082                	ret
    panic("inituvm: more than a page");
    800009ba:	00007517          	auipc	a0,0x7
    800009be:	71e50513          	addi	a0,a0,1822 # 800080d8 <etext+0xd8>
    800009c2:	00005097          	auipc	ra,0x5
    800009c6:	6ca080e7          	jalr	1738(ra) # 8000608c <panic>

00000000800009ca <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009d4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009d6:	00b67d63          	bgeu	a2,a1,800009f0 <uvmdealloc+0x26>
    800009da:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009dc:	6785                	lui	a5,0x1
    800009de:	17fd                	addi	a5,a5,-1
    800009e0:	00f60733          	add	a4,a2,a5
    800009e4:	767d                	lui	a2,0xfffff
    800009e6:	8f71                	and	a4,a4,a2
    800009e8:	97ae                	add	a5,a5,a1
    800009ea:	8ff1                	and	a5,a5,a2
    800009ec:	00f76863          	bltu	a4,a5,800009fc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009f0:	8526                	mv	a0,s1
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009fc:	8f99                	sub	a5,a5,a4
    800009fe:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a00:	4685                	li	a3,1
    80000a02:	0007861b          	sext.w	a2,a5
    80000a06:	85ba                	mv	a1,a4
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	e5e080e7          	jalr	-418(ra) # 80000866 <uvmunmap>
    80000a10:	b7c5                	j	800009f0 <uvmdealloc+0x26>

0000000080000a12 <uvmalloc>:
  if(newsz < oldsz)
    80000a12:	0ab66163          	bltu	a2,a1,80000ab4 <uvmalloc+0xa2>
{
    80000a16:	7139                	addi	sp,sp,-64
    80000a18:	fc06                	sd	ra,56(sp)
    80000a1a:	f822                	sd	s0,48(sp)
    80000a1c:	f426                	sd	s1,40(sp)
    80000a1e:	f04a                	sd	s2,32(sp)
    80000a20:	ec4e                	sd	s3,24(sp)
    80000a22:	e852                	sd	s4,16(sp)
    80000a24:	e456                	sd	s5,8(sp)
    80000a26:	0080                	addi	s0,sp,64
    80000a28:	8aaa                	mv	s5,a0
    80000a2a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a2c:	6985                	lui	s3,0x1
    80000a2e:	19fd                	addi	s3,s3,-1
    80000a30:	95ce                	add	a1,a1,s3
    80000a32:	79fd                	lui	s3,0xfffff
    80000a34:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a38:	08c9f063          	bgeu	s3,a2,80000ab8 <uvmalloc+0xa6>
    80000a3c:	894e                	mv	s2,s3
    mem = kalloc();
    80000a3e:	fffff097          	auipc	ra,0xfffff
    80000a42:	73e080e7          	jalr	1854(ra) # 8000017c <kalloc>
    80000a46:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a48:	c51d                	beqz	a0,80000a76 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a4a:	6605                	lui	a2,0x1
    80000a4c:	4581                	li	a1,0
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	872080e7          	jalr	-1934(ra) # 800002c0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a56:	4779                	li	a4,30
    80000a58:	86a6                	mv	a3,s1
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85ca                	mv	a1,s2
    80000a5e:	8556                	mv	a0,s5
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	c40080e7          	jalr	-960(ra) # 800006a0 <mappages>
    80000a68:	e905                	bnez	a0,80000a98 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	993e                	add	s2,s2,a5
    80000a6e:	fd4968e3          	bltu	s2,s4,80000a3e <uvmalloc+0x2c>
  return newsz;
    80000a72:	8552                	mv	a0,s4
    80000a74:	a809                	j	80000a86 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a76:	864e                	mv	a2,s3
    80000a78:	85ca                	mv	a1,s2
    80000a7a:	8556                	mv	a0,s5
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	f4e080e7          	jalr	-178(ra) # 800009ca <uvmdealloc>
      return 0;
    80000a84:	4501                	li	a0,0
}
    80000a86:	70e2                	ld	ra,56(sp)
    80000a88:	7442                	ld	s0,48(sp)
    80000a8a:	74a2                	ld	s1,40(sp)
    80000a8c:	7902                	ld	s2,32(sp)
    80000a8e:	69e2                	ld	s3,24(sp)
    80000a90:	6a42                	ld	s4,16(sp)
    80000a92:	6aa2                	ld	s5,8(sp)
    80000a94:	6121                	addi	sp,sp,64
    80000a96:	8082                	ret
      kfree(mem);
    80000a98:	8526                	mv	a0,s1
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000aa2:	864e                	mv	a2,s3
    80000aa4:	85ca                	mv	a1,s2
    80000aa6:	8556                	mv	a0,s5
    80000aa8:	00000097          	auipc	ra,0x0
    80000aac:	f22080e7          	jalr	-222(ra) # 800009ca <uvmdealloc>
      return 0;
    80000ab0:	4501                	li	a0,0
    80000ab2:	bfd1                	j	80000a86 <uvmalloc+0x74>
    return oldsz;
    80000ab4:	852e                	mv	a0,a1
}
    80000ab6:	8082                	ret
  return newsz;
    80000ab8:	8532                	mv	a0,a2
    80000aba:	b7f1                	j	80000a86 <uvmalloc+0x74>

0000000080000abc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000abc:	7179                	addi	sp,sp,-48
    80000abe:	f406                	sd	ra,40(sp)
    80000ac0:	f022                	sd	s0,32(sp)
    80000ac2:	ec26                	sd	s1,24(sp)
    80000ac4:	e84a                	sd	s2,16(sp)
    80000ac6:	e44e                	sd	s3,8(sp)
    80000ac8:	e052                	sd	s4,0(sp)
    80000aca:	1800                	addi	s0,sp,48
    80000acc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000ace:	84aa                	mv	s1,a0
    80000ad0:	6905                	lui	s2,0x1
    80000ad2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ad4:	4985                	li	s3,1
    80000ad6:	a821                	j	80000aee <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ad8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000ada:	0532                	slli	a0,a0,0xc
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	fe0080e7          	jalr	-32(ra) # 80000abc <freewalk>
      pagetable[i] = 0;
    80000ae4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000ae8:	04a1                	addi	s1,s1,8
    80000aea:	03248163          	beq	s1,s2,80000b0c <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000aee:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000af0:	00f57793          	andi	a5,a0,15
    80000af4:	ff3782e3          	beq	a5,s3,80000ad8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000af8:	8905                	andi	a0,a0,1
    80000afa:	d57d                	beqz	a0,80000ae8 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	5fc50513          	addi	a0,a0,1532 # 800080f8 <etext+0xf8>
    80000b04:	00005097          	auipc	ra,0x5
    80000b08:	588080e7          	jalr	1416(ra) # 8000608c <panic>
    }
  }
  kfree((void*)pagetable);
    80000b0c:	8552                	mv	a0,s4
    80000b0e:	fffff097          	auipc	ra,0xfffff
    80000b12:	50e080e7          	jalr	1294(ra) # 8000001c <kfree>
}
    80000b16:	70a2                	ld	ra,40(sp)
    80000b18:	7402                	ld	s0,32(sp)
    80000b1a:	64e2                	ld	s1,24(sp)
    80000b1c:	6942                	ld	s2,16(sp)
    80000b1e:	69a2                	ld	s3,8(sp)
    80000b20:	6a02                	ld	s4,0(sp)
    80000b22:	6145                	addi	sp,sp,48
    80000b24:	8082                	ret

0000000080000b26 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
    80000b30:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b32:	e999                	bnez	a1,80000b48 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b34:	8526                	mv	a0,s1
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	f86080e7          	jalr	-122(ra) # 80000abc <freewalk>
}
    80000b3e:	60e2                	ld	ra,24(sp)
    80000b40:	6442                	ld	s0,16(sp)
    80000b42:	64a2                	ld	s1,8(sp)
    80000b44:	6105                	addi	sp,sp,32
    80000b46:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b48:	6605                	lui	a2,0x1
    80000b4a:	167d                	addi	a2,a2,-1
    80000b4c:	962e                	add	a2,a2,a1
    80000b4e:	4685                	li	a3,1
    80000b50:	8231                	srli	a2,a2,0xc
    80000b52:	4581                	li	a1,0
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	d12080e7          	jalr	-750(ra) # 80000866 <uvmunmap>
    80000b5c:	bfe1                	j	80000b34 <uvmfree+0xe>

0000000080000b5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b5e:	c679                	beqz	a2,80000c2c <uvmcopy+0xce>
{
    80000b60:	715d                	addi	sp,sp,-80
    80000b62:	e486                	sd	ra,72(sp)
    80000b64:	e0a2                	sd	s0,64(sp)
    80000b66:	fc26                	sd	s1,56(sp)
    80000b68:	f84a                	sd	s2,48(sp)
    80000b6a:	f44e                	sd	s3,40(sp)
    80000b6c:	f052                	sd	s4,32(sp)
    80000b6e:	ec56                	sd	s5,24(sp)
    80000b70:	e85a                	sd	s6,16(sp)
    80000b72:	e45e                	sd	s7,8(sp)
    80000b74:	0880                	addi	s0,sp,80
    80000b76:	8b2a                	mv	s6,a0
    80000b78:	8aae                	mv	s5,a1
    80000b7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b7e:	4601                	li	a2,0
    80000b80:	85ce                	mv	a1,s3
    80000b82:	855a                	mv	a0,s6
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	a34080e7          	jalr	-1484(ra) # 800005b8 <walk>
    80000b8c:	c531                	beqz	a0,80000bd8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b8e:	6118                	ld	a4,0(a0)
    80000b90:	00177793          	andi	a5,a4,1
    80000b94:	cbb1                	beqz	a5,80000be8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b96:	00a75593          	srli	a1,a4,0xa
    80000b9a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b9e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ba2:	fffff097          	auipc	ra,0xfffff
    80000ba6:	5da080e7          	jalr	1498(ra) # 8000017c <kalloc>
    80000baa:	892a                	mv	s2,a0
    80000bac:	c939                	beqz	a0,80000c02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000bae:	6605                	lui	a2,0x1
    80000bb0:	85de                	mv	a1,s7
    80000bb2:	fffff097          	auipc	ra,0xfffff
    80000bb6:	76e080e7          	jalr	1902(ra) # 80000320 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000bba:	8726                	mv	a4,s1
    80000bbc:	86ca                	mv	a3,s2
    80000bbe:	6605                	lui	a2,0x1
    80000bc0:	85ce                	mv	a1,s3
    80000bc2:	8556                	mv	a0,s5
    80000bc4:	00000097          	auipc	ra,0x0
    80000bc8:	adc080e7          	jalr	-1316(ra) # 800006a0 <mappages>
    80000bcc:	e515                	bnez	a0,80000bf8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000bce:	6785                	lui	a5,0x1
    80000bd0:	99be                	add	s3,s3,a5
    80000bd2:	fb49e6e3          	bltu	s3,s4,80000b7e <uvmcopy+0x20>
    80000bd6:	a081                	j	80000c16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000bd8:	00007517          	auipc	a0,0x7
    80000bdc:	53050513          	addi	a0,a0,1328 # 80008108 <etext+0x108>
    80000be0:	00005097          	auipc	ra,0x5
    80000be4:	4ac080e7          	jalr	1196(ra) # 8000608c <panic>
      panic("uvmcopy: page not present");
    80000be8:	00007517          	auipc	a0,0x7
    80000bec:	54050513          	addi	a0,a0,1344 # 80008128 <etext+0x128>
    80000bf0:	00005097          	auipc	ra,0x5
    80000bf4:	49c080e7          	jalr	1180(ra) # 8000608c <panic>
      kfree(mem);
    80000bf8:	854a                	mv	a0,s2
    80000bfa:	fffff097          	auipc	ra,0xfffff
    80000bfe:	422080e7          	jalr	1058(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c02:	4685                	li	a3,1
    80000c04:	00c9d613          	srli	a2,s3,0xc
    80000c08:	4581                	li	a1,0
    80000c0a:	8556                	mv	a0,s5
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	c5a080e7          	jalr	-934(ra) # 80000866 <uvmunmap>
  return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6161                	addi	sp,sp,80
    80000c2a:	8082                	ret
  return 0;
    80000c2c:	4501                	li	a0,0
}
    80000c2e:	8082                	ret

0000000080000c30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c30:	1141                	addi	sp,sp,-16
    80000c32:	e406                	sd	ra,8(sp)
    80000c34:	e022                	sd	s0,0(sp)
    80000c36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c38:	4601                	li	a2,0
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	97e080e7          	jalr	-1666(ra) # 800005b8 <walk>
  if(pte == 0)
    80000c42:	c901                	beqz	a0,80000c52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c44:	611c                	ld	a5,0(a0)
    80000c46:	9bbd                	andi	a5,a5,-17
    80000c48:	e11c                	sd	a5,0(a0)
}
    80000c4a:	60a2                	ld	ra,8(sp)
    80000c4c:	6402                	ld	s0,0(sp)
    80000c4e:	0141                	addi	sp,sp,16
    80000c50:	8082                	ret
    panic("uvmclear");
    80000c52:	00007517          	auipc	a0,0x7
    80000c56:	4f650513          	addi	a0,a0,1270 # 80008148 <etext+0x148>
    80000c5a:	00005097          	auipc	ra,0x5
    80000c5e:	432080e7          	jalr	1074(ra) # 8000608c <panic>

0000000080000c62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c62:	c6bd                	beqz	a3,80000cd0 <copyout+0x6e>
{
    80000c64:	715d                	addi	sp,sp,-80
    80000c66:	e486                	sd	ra,72(sp)
    80000c68:	e0a2                	sd	s0,64(sp)
    80000c6a:	fc26                	sd	s1,56(sp)
    80000c6c:	f84a                	sd	s2,48(sp)
    80000c6e:	f44e                	sd	s3,40(sp)
    80000c70:	f052                	sd	s4,32(sp)
    80000c72:	ec56                	sd	s5,24(sp)
    80000c74:	e85a                	sd	s6,16(sp)
    80000c76:	e45e                	sd	s7,8(sp)
    80000c78:	e062                	sd	s8,0(sp)
    80000c7a:	0880                	addi	s0,sp,80
    80000c7c:	8b2a                	mv	s6,a0
    80000c7e:	8c2e                	mv	s8,a1
    80000c80:	8a32                	mv	s4,a2
    80000c82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c86:	6a85                	lui	s5,0x1
    80000c88:	a015                	j	80000cac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c8a:	9562                	add	a0,a0,s8
    80000c8c:	0004861b          	sext.w	a2,s1
    80000c90:	85d2                	mv	a1,s4
    80000c92:	41250533          	sub	a0,a0,s2
    80000c96:	fffff097          	auipc	ra,0xfffff
    80000c9a:	68a080e7          	jalr	1674(ra) # 80000320 <memmove>

    len -= n;
    80000c9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ca2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ca4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ca8:	02098263          	beqz	s3,80000ccc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000cac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cb0:	85ca                	mv	a1,s2
    80000cb2:	855a                	mv	a0,s6
    80000cb4:	00000097          	auipc	ra,0x0
    80000cb8:	9aa080e7          	jalr	-1622(ra) # 8000065e <walkaddr>
    if(pa0 == 0)
    80000cbc:	cd01                	beqz	a0,80000cd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000cbe:	418904b3          	sub	s1,s2,s8
    80000cc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cc4:	fc99f3e3          	bgeu	s3,s1,80000c8a <copyout+0x28>
    80000cc8:	84ce                	mv	s1,s3
    80000cca:	b7c1                	j	80000c8a <copyout+0x28>
  }
  return 0;
    80000ccc:	4501                	li	a0,0
    80000cce:	a021                	j	80000cd6 <copyout+0x74>
    80000cd0:	4501                	li	a0,0
}
    80000cd2:	8082                	ret
      return -1;
    80000cd4:	557d                	li	a0,-1
}
    80000cd6:	60a6                	ld	ra,72(sp)
    80000cd8:	6406                	ld	s0,64(sp)
    80000cda:	74e2                	ld	s1,56(sp)
    80000cdc:	7942                	ld	s2,48(sp)
    80000cde:	79a2                	ld	s3,40(sp)
    80000ce0:	7a02                	ld	s4,32(sp)
    80000ce2:	6ae2                	ld	s5,24(sp)
    80000ce4:	6b42                	ld	s6,16(sp)
    80000ce6:	6ba2                	ld	s7,8(sp)
    80000ce8:	6c02                	ld	s8,0(sp)
    80000cea:	6161                	addi	sp,sp,80
    80000cec:	8082                	ret

0000000080000cee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cee:	c6bd                	beqz	a3,80000d5c <copyin+0x6e>
{
    80000cf0:	715d                	addi	sp,sp,-80
    80000cf2:	e486                	sd	ra,72(sp)
    80000cf4:	e0a2                	sd	s0,64(sp)
    80000cf6:	fc26                	sd	s1,56(sp)
    80000cf8:	f84a                	sd	s2,48(sp)
    80000cfa:	f44e                	sd	s3,40(sp)
    80000cfc:	f052                	sd	s4,32(sp)
    80000cfe:	ec56                	sd	s5,24(sp)
    80000d00:	e85a                	sd	s6,16(sp)
    80000d02:	e45e                	sd	s7,8(sp)
    80000d04:	e062                	sd	s8,0(sp)
    80000d06:	0880                	addi	s0,sp,80
    80000d08:	8b2a                	mv	s6,a0
    80000d0a:	8a2e                	mv	s4,a1
    80000d0c:	8c32                	mv	s8,a2
    80000d0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d12:	6a85                	lui	s5,0x1
    80000d14:	a015                	j	80000d38 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d16:	9562                	add	a0,a0,s8
    80000d18:	0004861b          	sext.w	a2,s1
    80000d1c:	412505b3          	sub	a1,a0,s2
    80000d20:	8552                	mv	a0,s4
    80000d22:	fffff097          	auipc	ra,0xfffff
    80000d26:	5fe080e7          	jalr	1534(ra) # 80000320 <memmove>

    len -= n;
    80000d2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d34:	02098263          	beqz	s3,80000d58 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d3c:	85ca                	mv	a1,s2
    80000d3e:	855a                	mv	a0,s6
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	91e080e7          	jalr	-1762(ra) # 8000065e <walkaddr>
    if(pa0 == 0)
    80000d48:	cd01                	beqz	a0,80000d60 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d4a:	418904b3          	sub	s1,s2,s8
    80000d4e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d50:	fc99f3e3          	bgeu	s3,s1,80000d16 <copyin+0x28>
    80000d54:	84ce                	mv	s1,s3
    80000d56:	b7c1                	j	80000d16 <copyin+0x28>
  }
  return 0;
    80000d58:	4501                	li	a0,0
    80000d5a:	a021                	j	80000d62 <copyin+0x74>
    80000d5c:	4501                	li	a0,0
}
    80000d5e:	8082                	ret
      return -1;
    80000d60:	557d                	li	a0,-1
}
    80000d62:	60a6                	ld	ra,72(sp)
    80000d64:	6406                	ld	s0,64(sp)
    80000d66:	74e2                	ld	s1,56(sp)
    80000d68:	7942                	ld	s2,48(sp)
    80000d6a:	79a2                	ld	s3,40(sp)
    80000d6c:	7a02                	ld	s4,32(sp)
    80000d6e:	6ae2                	ld	s5,24(sp)
    80000d70:	6b42                	ld	s6,16(sp)
    80000d72:	6ba2                	ld	s7,8(sp)
    80000d74:	6c02                	ld	s8,0(sp)
    80000d76:	6161                	addi	sp,sp,80
    80000d78:	8082                	ret

0000000080000d7a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d7a:	c6c5                	beqz	a3,80000e22 <copyinstr+0xa8>
{
    80000d7c:	715d                	addi	sp,sp,-80
    80000d7e:	e486                	sd	ra,72(sp)
    80000d80:	e0a2                	sd	s0,64(sp)
    80000d82:	fc26                	sd	s1,56(sp)
    80000d84:	f84a                	sd	s2,48(sp)
    80000d86:	f44e                	sd	s3,40(sp)
    80000d88:	f052                	sd	s4,32(sp)
    80000d8a:	ec56                	sd	s5,24(sp)
    80000d8c:	e85a                	sd	s6,16(sp)
    80000d8e:	e45e                	sd	s7,8(sp)
    80000d90:	0880                	addi	s0,sp,80
    80000d92:	8a2a                	mv	s4,a0
    80000d94:	8b2e                	mv	s6,a1
    80000d96:	8bb2                	mv	s7,a2
    80000d98:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d9a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d9c:	6985                	lui	s3,0x1
    80000d9e:	a035                	j	80000dca <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000da0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000da4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000da6:	0017b793          	seqz	a5,a5
    80000daa:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dae:	60a6                	ld	ra,72(sp)
    80000db0:	6406                	ld	s0,64(sp)
    80000db2:	74e2                	ld	s1,56(sp)
    80000db4:	7942                	ld	s2,48(sp)
    80000db6:	79a2                	ld	s3,40(sp)
    80000db8:	7a02                	ld	s4,32(sp)
    80000dba:	6ae2                	ld	s5,24(sp)
    80000dbc:	6b42                	ld	s6,16(sp)
    80000dbe:	6ba2                	ld	s7,8(sp)
    80000dc0:	6161                	addi	sp,sp,80
    80000dc2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dc4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dc8:	c8a9                	beqz	s1,80000e1a <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dca:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dce:	85ca                	mv	a1,s2
    80000dd0:	8552                	mv	a0,s4
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	88c080e7          	jalr	-1908(ra) # 8000065e <walkaddr>
    if(pa0 == 0)
    80000dda:	c131                	beqz	a0,80000e1e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ddc:	41790833          	sub	a6,s2,s7
    80000de0:	984e                	add	a6,a6,s3
    if(n > max)
    80000de2:	0104f363          	bgeu	s1,a6,80000de8 <copyinstr+0x6e>
    80000de6:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000de8:	955e                	add	a0,a0,s7
    80000dea:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000dee:	fc080be3          	beqz	a6,80000dc4 <copyinstr+0x4a>
    80000df2:	985a                	add	a6,a6,s6
    80000df4:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000df6:	41650633          	sub	a2,a0,s6
    80000dfa:	14fd                	addi	s1,s1,-1
    80000dfc:	9b26                	add	s6,s6,s1
    80000dfe:	00f60733          	add	a4,a2,a5
    80000e02:	00074703          	lbu	a4,0(a4)
    80000e06:	df49                	beqz	a4,80000da0 <copyinstr+0x26>
        *dst = *p;
    80000e08:	00e78023          	sb	a4,0(a5)
      --max;
    80000e0c:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e10:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e12:	ff0796e3          	bne	a5,a6,80000dfe <copyinstr+0x84>
      dst++;
    80000e16:	8b42                	mv	s6,a6
    80000e18:	b775                	j	80000dc4 <copyinstr+0x4a>
    80000e1a:	4781                	li	a5,0
    80000e1c:	b769                	j	80000da6 <copyinstr+0x2c>
      return -1;
    80000e1e:	557d                	li	a0,-1
    80000e20:	b779                	j	80000dae <copyinstr+0x34>
  int got_null = 0;
    80000e22:	4781                	li	a5,0
  if(got_null){
    80000e24:	0017b793          	seqz	a5,a5
    80000e28:	40f00533          	neg	a0,a5
}
    80000e2c:	8082                	ret

0000000080000e2e <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e2e:	7139                	addi	sp,sp,-64
    80000e30:	fc06                	sd	ra,56(sp)
    80000e32:	f822                	sd	s0,48(sp)
    80000e34:	f426                	sd	s1,40(sp)
    80000e36:	f04a                	sd	s2,32(sp)
    80000e38:	ec4e                	sd	s3,24(sp)
    80000e3a:	e852                	sd	s4,16(sp)
    80000e3c:	e456                	sd	s5,8(sp)
    80000e3e:	e05a                	sd	s6,0(sp)
    80000e40:	0080                	addi	s0,sp,64
    80000e42:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e44:	00008497          	auipc	s1,0x8
    80000e48:	7ac48493          	addi	s1,s1,1964 # 800095f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e4c:	8b26                	mv	s6,s1
    80000e4e:	00007a97          	auipc	s5,0x7
    80000e52:	1b2a8a93          	addi	s5,s5,434 # 80008000 <etext>
    80000e56:	04000937          	lui	s2,0x4000
    80000e5a:	197d                	addi	s2,s2,-1
    80000e5c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5e:	0000ea17          	auipc	s4,0xe
    80000e62:	392a0a13          	addi	s4,s4,914 # 8000f1f0 <tickslock>
    char *pa = kalloc();
    80000e66:	fffff097          	auipc	ra,0xfffff
    80000e6a:	316080e7          	jalr	790(ra) # 8000017c <kalloc>
    80000e6e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e70:	c131                	beqz	a0,80000eb4 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e72:	416485b3          	sub	a1,s1,s6
    80000e76:	8591                	srai	a1,a1,0x4
    80000e78:	000ab783          	ld	a5,0(s5)
    80000e7c:	02f585b3          	mul	a1,a1,a5
    80000e80:	2585                	addiw	a1,a1,1
    80000e82:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e86:	4719                	li	a4,6
    80000e88:	6685                	lui	a3,0x1
    80000e8a:	40b905b3          	sub	a1,s2,a1
    80000e8e:	854e                	mv	a0,s3
    80000e90:	00000097          	auipc	ra,0x0
    80000e94:	8b0080e7          	jalr	-1872(ra) # 80000740 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e98:	17048493          	addi	s1,s1,368
    80000e9c:	fd4495e3          	bne	s1,s4,80000e66 <proc_mapstacks+0x38>
  }
}
    80000ea0:	70e2                	ld	ra,56(sp)
    80000ea2:	7442                	ld	s0,48(sp)
    80000ea4:	74a2                	ld	s1,40(sp)
    80000ea6:	7902                	ld	s2,32(sp)
    80000ea8:	69e2                	ld	s3,24(sp)
    80000eaa:	6a42                	ld	s4,16(sp)
    80000eac:	6aa2                	ld	s5,8(sp)
    80000eae:	6b02                	ld	s6,0(sp)
    80000eb0:	6121                	addi	sp,sp,64
    80000eb2:	8082                	ret
      panic("kalloc");
    80000eb4:	00007517          	auipc	a0,0x7
    80000eb8:	2a450513          	addi	a0,a0,676 # 80008158 <etext+0x158>
    80000ebc:	00005097          	auipc	ra,0x5
    80000ec0:	1d0080e7          	jalr	464(ra) # 8000608c <panic>

0000000080000ec4 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ec4:	7139                	addi	sp,sp,-64
    80000ec6:	fc06                	sd	ra,56(sp)
    80000ec8:	f822                	sd	s0,48(sp)
    80000eca:	f426                	sd	s1,40(sp)
    80000ecc:	f04a                	sd	s2,32(sp)
    80000ece:	ec4e                	sd	s3,24(sp)
    80000ed0:	e852                	sd	s4,16(sp)
    80000ed2:	e456                	sd	s5,8(sp)
    80000ed4:	e05a                	sd	s6,0(sp)
    80000ed6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ed8:	00007597          	auipc	a1,0x7
    80000edc:	28858593          	addi	a1,a1,648 # 80008160 <etext+0x160>
    80000ee0:	00008517          	auipc	a0,0x8
    80000ee4:	2d050513          	addi	a0,a0,720 # 800091b0 <pid_lock>
    80000ee8:	00006097          	auipc	ra,0x6
    80000eec:	854080e7          	jalr	-1964(ra) # 8000673c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ef0:	00007597          	auipc	a1,0x7
    80000ef4:	27858593          	addi	a1,a1,632 # 80008168 <etext+0x168>
    80000ef8:	00008517          	auipc	a0,0x8
    80000efc:	2d850513          	addi	a0,a0,728 # 800091d0 <wait_lock>
    80000f00:	00006097          	auipc	ra,0x6
    80000f04:	83c080e7          	jalr	-1988(ra) # 8000673c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f08:	00008497          	auipc	s1,0x8
    80000f0c:	6e848493          	addi	s1,s1,1768 # 800095f0 <proc>
      initlock(&p->lock, "proc");
    80000f10:	00007b17          	auipc	s6,0x7
    80000f14:	268b0b13          	addi	s6,s6,616 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000f18:	8aa6                	mv	s5,s1
    80000f1a:	00007a17          	auipc	s4,0x7
    80000f1e:	0e6a0a13          	addi	s4,s4,230 # 80008000 <etext>
    80000f22:	04000937          	lui	s2,0x4000
    80000f26:	197d                	addi	s2,s2,-1
    80000f28:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	0000e997          	auipc	s3,0xe
    80000f2e:	2c698993          	addi	s3,s3,710 # 8000f1f0 <tickslock>
      initlock(&p->lock, "proc");
    80000f32:	85da                	mv	a1,s6
    80000f34:	8526                	mv	a0,s1
    80000f36:	00006097          	auipc	ra,0x6
    80000f3a:	806080e7          	jalr	-2042(ra) # 8000673c <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f3e:	415487b3          	sub	a5,s1,s5
    80000f42:	8791                	srai	a5,a5,0x4
    80000f44:	000a3703          	ld	a4,0(s4)
    80000f48:	02e787b3          	mul	a5,a5,a4
    80000f4c:	2785                	addiw	a5,a5,1
    80000f4e:	00d7979b          	slliw	a5,a5,0xd
    80000f52:	40f907b3          	sub	a5,s2,a5
    80000f56:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f58:	17048493          	addi	s1,s1,368
    80000f5c:	fd349be3          	bne	s1,s3,80000f32 <procinit+0x6e>
  }
}
    80000f60:	70e2                	ld	ra,56(sp)
    80000f62:	7442                	ld	s0,48(sp)
    80000f64:	74a2                	ld	s1,40(sp)
    80000f66:	7902                	ld	s2,32(sp)
    80000f68:	69e2                	ld	s3,24(sp)
    80000f6a:	6a42                	ld	s4,16(sp)
    80000f6c:	6aa2                	ld	s5,8(sp)
    80000f6e:	6b02                	ld	s6,0(sp)
    80000f70:	6121                	addi	sp,sp,64
    80000f72:	8082                	ret

0000000080000f74 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f74:	1141                	addi	sp,sp,-16
    80000f76:	e422                	sd	s0,8(sp)
    80000f78:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f7a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f7c:	2501                	sext.w	a0,a0
    80000f7e:	6422                	ld	s0,8(sp)
    80000f80:	0141                	addi	sp,sp,16
    80000f82:	8082                	ret

0000000080000f84 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f84:	1141                	addi	sp,sp,-16
    80000f86:	e422                	sd	s0,8(sp)
    80000f88:	0800                	addi	s0,sp,16
    80000f8a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f8c:	2781                	sext.w	a5,a5
    80000f8e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f90:	00008517          	auipc	a0,0x8
    80000f94:	26050513          	addi	a0,a0,608 # 800091f0 <cpus>
    80000f98:	953e                	add	a0,a0,a5
    80000f9a:	6422                	ld	s0,8(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret

0000000080000fa0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fa0:	1101                	addi	sp,sp,-32
    80000fa2:	ec06                	sd	ra,24(sp)
    80000fa4:	e822                	sd	s0,16(sp)
    80000fa6:	e426                	sd	s1,8(sp)
    80000fa8:	1000                	addi	s0,sp,32
  push_off();
    80000faa:	00005097          	auipc	ra,0x5
    80000fae:	5ca080e7          	jalr	1482(ra) # 80006574 <push_off>
    80000fb2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fb4:	2781                	sext.w	a5,a5
    80000fb6:	079e                	slli	a5,a5,0x7
    80000fb8:	00008717          	auipc	a4,0x8
    80000fbc:	1f870713          	addi	a4,a4,504 # 800091b0 <pid_lock>
    80000fc0:	97ba                	add	a5,a5,a4
    80000fc2:	63a4                	ld	s1,64(a5)
  pop_off();
    80000fc4:	00005097          	auipc	ra,0x5
    80000fc8:	66c080e7          	jalr	1644(ra) # 80006630 <pop_off>
  return p;
}
    80000fcc:	8526                	mv	a0,s1
    80000fce:	60e2                	ld	ra,24(sp)
    80000fd0:	6442                	ld	s0,16(sp)
    80000fd2:	64a2                	ld	s1,8(sp)
    80000fd4:	6105                	addi	sp,sp,32
    80000fd6:	8082                	ret

0000000080000fd8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fd8:	1141                	addi	sp,sp,-16
    80000fda:	e406                	sd	ra,8(sp)
    80000fdc:	e022                	sd	s0,0(sp)
    80000fde:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	fc0080e7          	jalr	-64(ra) # 80000fa0 <myproc>
    80000fe8:	00005097          	auipc	ra,0x5
    80000fec:	6a8080e7          	jalr	1704(ra) # 80006690 <release>

  if (first) {
    80000ff0:	00008797          	auipc	a5,0x8
    80000ff4:	8f07a783          	lw	a5,-1808(a5) # 800088e0 <first.1688>
    80000ff8:	eb89                	bnez	a5,8000100a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ffa:	00001097          	auipc	ra,0x1
    80000ffe:	c0a080e7          	jalr	-1014(ra) # 80001c04 <usertrapret>
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
    first = 0;
    8000100a:	00008797          	auipc	a5,0x8
    8000100e:	8c07ab23          	sw	zero,-1834(a5) # 800088e0 <first.1688>
    fsinit(ROOTDEV);
    80001012:	4505                	li	a0,1
    80001014:	00002097          	auipc	ra,0x2
    80001018:	a0a080e7          	jalr	-1526(ra) # 80002a1e <fsinit>
    8000101c:	bff9                	j	80000ffa <forkret+0x22>

000000008000101e <allocpid>:
allocpid() {
    8000101e:	1101                	addi	sp,sp,-32
    80001020:	ec06                	sd	ra,24(sp)
    80001022:	e822                	sd	s0,16(sp)
    80001024:	e426                	sd	s1,8(sp)
    80001026:	e04a                	sd	s2,0(sp)
    80001028:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000102a:	00008917          	auipc	s2,0x8
    8000102e:	18690913          	addi	s2,s2,390 # 800091b0 <pid_lock>
    80001032:	854a                	mv	a0,s2
    80001034:	00005097          	auipc	ra,0x5
    80001038:	58c080e7          	jalr	1420(ra) # 800065c0 <acquire>
  pid = nextpid;
    8000103c:	00008797          	auipc	a5,0x8
    80001040:	8a878793          	addi	a5,a5,-1880 # 800088e4 <nextpid>
    80001044:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001046:	0014871b          	addiw	a4,s1,1
    8000104a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000104c:	854a                	mv	a0,s2
    8000104e:	00005097          	auipc	ra,0x5
    80001052:	642080e7          	jalr	1602(ra) # 80006690 <release>
}
    80001056:	8526                	mv	a0,s1
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6902                	ld	s2,0(sp)
    80001060:	6105                	addi	sp,sp,32
    80001062:	8082                	ret

0000000080001064 <proc_pagetable>:
{
    80001064:	1101                	addi	sp,sp,-32
    80001066:	ec06                	sd	ra,24(sp)
    80001068:	e822                	sd	s0,16(sp)
    8000106a:	e426                	sd	s1,8(sp)
    8000106c:	e04a                	sd	s2,0(sp)
    8000106e:	1000                	addi	s0,sp,32
    80001070:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001072:	00000097          	auipc	ra,0x0
    80001076:	8b8080e7          	jalr	-1864(ra) # 8000092a <uvmcreate>
    8000107a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000107c:	c121                	beqz	a0,800010bc <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000107e:	4729                	li	a4,10
    80001080:	00006697          	auipc	a3,0x6
    80001084:	f8068693          	addi	a3,a3,-128 # 80007000 <_trampoline>
    80001088:	6605                	lui	a2,0x1
    8000108a:	040005b7          	lui	a1,0x4000
    8000108e:	15fd                	addi	a1,a1,-1
    80001090:	05b2                	slli	a1,a1,0xc
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	60e080e7          	jalr	1550(ra) # 800006a0 <mappages>
    8000109a:	02054863          	bltz	a0,800010ca <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000109e:	4719                	li	a4,6
    800010a0:	06093683          	ld	a3,96(s2)
    800010a4:	6605                	lui	a2,0x1
    800010a6:	020005b7          	lui	a1,0x2000
    800010aa:	15fd                	addi	a1,a1,-1
    800010ac:	05b6                	slli	a1,a1,0xd
    800010ae:	8526                	mv	a0,s1
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	5f0080e7          	jalr	1520(ra) # 800006a0 <mappages>
    800010b8:	02054163          	bltz	a0,800010da <proc_pagetable+0x76>
}
    800010bc:	8526                	mv	a0,s1
    800010be:	60e2                	ld	ra,24(sp)
    800010c0:	6442                	ld	s0,16(sp)
    800010c2:	64a2                	ld	s1,8(sp)
    800010c4:	6902                	ld	s2,0(sp)
    800010c6:	6105                	addi	sp,sp,32
    800010c8:	8082                	ret
    uvmfree(pagetable, 0);
    800010ca:	4581                	li	a1,0
    800010cc:	8526                	mv	a0,s1
    800010ce:	00000097          	auipc	ra,0x0
    800010d2:	a58080e7          	jalr	-1448(ra) # 80000b26 <uvmfree>
    return 0;
    800010d6:	4481                	li	s1,0
    800010d8:	b7d5                	j	800010bc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010da:	4681                	li	a3,0
    800010dc:	4605                	li	a2,1
    800010de:	040005b7          	lui	a1,0x4000
    800010e2:	15fd                	addi	a1,a1,-1
    800010e4:	05b2                	slli	a1,a1,0xc
    800010e6:	8526                	mv	a0,s1
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	77e080e7          	jalr	1918(ra) # 80000866 <uvmunmap>
    uvmfree(pagetable, 0);
    800010f0:	4581                	li	a1,0
    800010f2:	8526                	mv	a0,s1
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	a32080e7          	jalr	-1486(ra) # 80000b26 <uvmfree>
    return 0;
    800010fc:	4481                	li	s1,0
    800010fe:	bf7d                	j	800010bc <proc_pagetable+0x58>

0000000080001100 <proc_freepagetable>:
{
    80001100:	1101                	addi	sp,sp,-32
    80001102:	ec06                	sd	ra,24(sp)
    80001104:	e822                	sd	s0,16(sp)
    80001106:	e426                	sd	s1,8(sp)
    80001108:	e04a                	sd	s2,0(sp)
    8000110a:	1000                	addi	s0,sp,32
    8000110c:	84aa                	mv	s1,a0
    8000110e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001110:	4681                	li	a3,0
    80001112:	4605                	li	a2,1
    80001114:	040005b7          	lui	a1,0x4000
    80001118:	15fd                	addi	a1,a1,-1
    8000111a:	05b2                	slli	a1,a1,0xc
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	74a080e7          	jalr	1866(ra) # 80000866 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001124:	4681                	li	a3,0
    80001126:	4605                	li	a2,1
    80001128:	020005b7          	lui	a1,0x2000
    8000112c:	15fd                	addi	a1,a1,-1
    8000112e:	05b6                	slli	a1,a1,0xd
    80001130:	8526                	mv	a0,s1
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	734080e7          	jalr	1844(ra) # 80000866 <uvmunmap>
  uvmfree(pagetable, sz);
    8000113a:	85ca                	mv	a1,s2
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	9e8080e7          	jalr	-1560(ra) # 80000b26 <uvmfree>
}
    80001146:	60e2                	ld	ra,24(sp)
    80001148:	6442                	ld	s0,16(sp)
    8000114a:	64a2                	ld	s1,8(sp)
    8000114c:	6902                	ld	s2,0(sp)
    8000114e:	6105                	addi	sp,sp,32
    80001150:	8082                	ret

0000000080001152 <freeproc>:
{
    80001152:	1101                	addi	sp,sp,-32
    80001154:	ec06                	sd	ra,24(sp)
    80001156:	e822                	sd	s0,16(sp)
    80001158:	e426                	sd	s1,8(sp)
    8000115a:	1000                	addi	s0,sp,32
    8000115c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000115e:	7128                	ld	a0,96(a0)
    80001160:	c509                	beqz	a0,8000116a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	eba080e7          	jalr	-326(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000116a:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000116e:	6ca8                	ld	a0,88(s1)
    80001170:	c511                	beqz	a0,8000117c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001172:	68ac                	ld	a1,80(s1)
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f8c080e7          	jalr	-116(ra) # 80001100 <proc_freepagetable>
  p->pagetable = 0;
    8000117c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001180:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001184:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001188:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000118c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001190:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001194:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001198:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000119c:	0204a023          	sw	zero,32(s1)
}
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6105                	addi	sp,sp,32
    800011a8:	8082                	ret

00000000800011aa <allocproc>:
{
    800011aa:	1101                	addi	sp,sp,-32
    800011ac:	ec06                	sd	ra,24(sp)
    800011ae:	e822                	sd	s0,16(sp)
    800011b0:	e426                	sd	s1,8(sp)
    800011b2:	e04a                	sd	s2,0(sp)
    800011b4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011b6:	00008497          	auipc	s1,0x8
    800011ba:	43a48493          	addi	s1,s1,1082 # 800095f0 <proc>
    800011be:	0000e917          	auipc	s2,0xe
    800011c2:	03290913          	addi	s2,s2,50 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	00005097          	auipc	ra,0x5
    800011cc:	3f8080e7          	jalr	1016(ra) # 800065c0 <acquire>
    if(p->state == UNUSED) {
    800011d0:	509c                	lw	a5,32(s1)
    800011d2:	cf81                	beqz	a5,800011ea <allocproc+0x40>
      release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	4ba080e7          	jalr	1210(ra) # 80006690 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	17048493          	addi	s1,s1,368
    800011e2:	ff2492e3          	bne	s1,s2,800011c6 <allocproc+0x1c>
  return 0;
    800011e6:	4481                	li	s1,0
    800011e8:	a889                	j	8000123a <allocproc+0x90>
  p->pid = allocpid();
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	e34080e7          	jalr	-460(ra) # 8000101e <allocpid>
    800011f2:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011f4:	4785                	li	a5,1
    800011f6:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	f84080e7          	jalr	-124(ra) # 8000017c <kalloc>
    80001200:	892a                	mv	s2,a0
    80001202:	f0a8                	sd	a0,96(s1)
    80001204:	c131                	beqz	a0,80001248 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001206:	8526                	mv	a0,s1
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	e5c080e7          	jalr	-420(ra) # 80001064 <proc_pagetable>
    80001210:	892a                	mv	s2,a0
    80001212:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001214:	c531                	beqz	a0,80001260 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001216:	07000613          	li	a2,112
    8000121a:	4581                	li	a1,0
    8000121c:	06848513          	addi	a0,s1,104
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	0a0080e7          	jalr	160(ra) # 800002c0 <memset>
  p->context.ra = (uint64)forkret;
    80001228:	00000797          	auipc	a5,0x0
    8000122c:	db078793          	addi	a5,a5,-592 # 80000fd8 <forkret>
    80001230:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001232:	64bc                	ld	a5,72(s1)
    80001234:	6705                	lui	a4,0x1
    80001236:	97ba                	add	a5,a5,a4
    80001238:	f8bc                	sd	a5,112(s1)
}
    8000123a:	8526                	mv	a0,s1
    8000123c:	60e2                	ld	ra,24(sp)
    8000123e:	6442                	ld	s0,16(sp)
    80001240:	64a2                	ld	s1,8(sp)
    80001242:	6902                	ld	s2,0(sp)
    80001244:	6105                	addi	sp,sp,32
    80001246:	8082                	ret
    freeproc(p);
    80001248:	8526                	mv	a0,s1
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f08080e7          	jalr	-248(ra) # 80001152 <freeproc>
    release(&p->lock);
    80001252:	8526                	mv	a0,s1
    80001254:	00005097          	auipc	ra,0x5
    80001258:	43c080e7          	jalr	1084(ra) # 80006690 <release>
    return 0;
    8000125c:	84ca                	mv	s1,s2
    8000125e:	bff1                	j	8000123a <allocproc+0x90>
    freeproc(p);
    80001260:	8526                	mv	a0,s1
    80001262:	00000097          	auipc	ra,0x0
    80001266:	ef0080e7          	jalr	-272(ra) # 80001152 <freeproc>
    release(&p->lock);
    8000126a:	8526                	mv	a0,s1
    8000126c:	00005097          	auipc	ra,0x5
    80001270:	424080e7          	jalr	1060(ra) # 80006690 <release>
    return 0;
    80001274:	84ca                	mv	s1,s2
    80001276:	b7d1                	j	8000123a <allocproc+0x90>

0000000080001278 <userinit>:
{
    80001278:	1101                	addi	sp,sp,-32
    8000127a:	ec06                	sd	ra,24(sp)
    8000127c:	e822                	sd	s0,16(sp)
    8000127e:	e426                	sd	s1,8(sp)
    80001280:	1000                	addi	s0,sp,32
  p = allocproc();
    80001282:	00000097          	auipc	ra,0x0
    80001286:	f28080e7          	jalr	-216(ra) # 800011aa <allocproc>
    8000128a:	84aa                	mv	s1,a0
  initproc = p;
    8000128c:	00008797          	auipc	a5,0x8
    80001290:	d8a7b223          	sd	a0,-636(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001294:	03400613          	li	a2,52
    80001298:	00007597          	auipc	a1,0x7
    8000129c:	65858593          	addi	a1,a1,1624 # 800088f0 <initcode>
    800012a0:	6d28                	ld	a0,88(a0)
    800012a2:	fffff097          	auipc	ra,0xfffff
    800012a6:	6b6080e7          	jalr	1718(ra) # 80000958 <uvminit>
  p->sz = PGSIZE;
    800012aa:	6785                	lui	a5,0x1
    800012ac:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012ae:	70b8                	ld	a4,96(s1)
    800012b0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012b4:	70b8                	ld	a4,96(s1)
    800012b6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012b8:	4641                	li	a2,16
    800012ba:	00007597          	auipc	a1,0x7
    800012be:	ec658593          	addi	a1,a1,-314 # 80008180 <etext+0x180>
    800012c2:	16048513          	addi	a0,s1,352
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	14c080e7          	jalr	332(ra) # 80000412 <safestrcpy>
  p->cwd = namei("/");
    800012ce:	00007517          	auipc	a0,0x7
    800012d2:	ec250513          	addi	a0,a0,-318 # 80008190 <etext+0x190>
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	176080e7          	jalr	374(ra) # 8000344c <namei>
    800012de:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012e2:	478d                	li	a5,3
    800012e4:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012e6:	8526                	mv	a0,s1
    800012e8:	00005097          	auipc	ra,0x5
    800012ec:	3a8080e7          	jalr	936(ra) # 80006690 <release>
}
    800012f0:	60e2                	ld	ra,24(sp)
    800012f2:	6442                	ld	s0,16(sp)
    800012f4:	64a2                	ld	s1,8(sp)
    800012f6:	6105                	addi	sp,sp,32
    800012f8:	8082                	ret

00000000800012fa <growproc>:
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	e04a                	sd	s2,0(sp)
    80001304:	1000                	addi	s0,sp,32
    80001306:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001308:	00000097          	auipc	ra,0x0
    8000130c:	c98080e7          	jalr	-872(ra) # 80000fa0 <myproc>
    80001310:	892a                	mv	s2,a0
  sz = p->sz;
    80001312:	692c                	ld	a1,80(a0)
    80001314:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001318:	00904f63          	bgtz	s1,80001336 <growproc+0x3c>
  } else if(n < 0){
    8000131c:	0204cc63          	bltz	s1,80001354 <growproc+0x5a>
  p->sz = sz;
    80001320:	1602                	slli	a2,a2,0x20
    80001322:	9201                	srli	a2,a2,0x20
    80001324:	04c93823          	sd	a2,80(s2)
  return 0;
    80001328:	4501                	li	a0,0
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6902                	ld	s2,0(sp)
    80001332:	6105                	addi	sp,sp,32
    80001334:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001336:	9e25                	addw	a2,a2,s1
    80001338:	1602                	slli	a2,a2,0x20
    8000133a:	9201                	srli	a2,a2,0x20
    8000133c:	1582                	slli	a1,a1,0x20
    8000133e:	9181                	srli	a1,a1,0x20
    80001340:	6d28                	ld	a0,88(a0)
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	6d0080e7          	jalr	1744(ra) # 80000a12 <uvmalloc>
    8000134a:	0005061b          	sext.w	a2,a0
    8000134e:	fa69                	bnez	a2,80001320 <growproc+0x26>
      return -1;
    80001350:	557d                	li	a0,-1
    80001352:	bfe1                	j	8000132a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001354:	9e25                	addw	a2,a2,s1
    80001356:	1602                	slli	a2,a2,0x20
    80001358:	9201                	srli	a2,a2,0x20
    8000135a:	1582                	slli	a1,a1,0x20
    8000135c:	9181                	srli	a1,a1,0x20
    8000135e:	6d28                	ld	a0,88(a0)
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	66a080e7          	jalr	1642(ra) # 800009ca <uvmdealloc>
    80001368:	0005061b          	sext.w	a2,a0
    8000136c:	bf55                	j	80001320 <growproc+0x26>

000000008000136e <fork>:
{
    8000136e:	7179                	addi	sp,sp,-48
    80001370:	f406                	sd	ra,40(sp)
    80001372:	f022                	sd	s0,32(sp)
    80001374:	ec26                	sd	s1,24(sp)
    80001376:	e84a                	sd	s2,16(sp)
    80001378:	e44e                	sd	s3,8(sp)
    8000137a:	e052                	sd	s4,0(sp)
    8000137c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	c22080e7          	jalr	-990(ra) # 80000fa0 <myproc>
    80001386:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	e22080e7          	jalr	-478(ra) # 800011aa <allocproc>
    80001390:	10050b63          	beqz	a0,800014a6 <fork+0x138>
    80001394:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001396:	05093603          	ld	a2,80(s2)
    8000139a:	6d2c                	ld	a1,88(a0)
    8000139c:	05893503          	ld	a0,88(s2)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	7be080e7          	jalr	1982(ra) # 80000b5e <uvmcopy>
    800013a8:	04054663          	bltz	a0,800013f4 <fork+0x86>
  np->sz = p->sz;
    800013ac:	05093783          	ld	a5,80(s2)
    800013b0:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800013b4:	06093683          	ld	a3,96(s2)
    800013b8:	87b6                	mv	a5,a3
    800013ba:	0609b703          	ld	a4,96(s3)
    800013be:	12068693          	addi	a3,a3,288
    800013c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013c6:	6788                	ld	a0,8(a5)
    800013c8:	6b8c                	ld	a1,16(a5)
    800013ca:	6f90                	ld	a2,24(a5)
    800013cc:	01073023          	sd	a6,0(a4)
    800013d0:	e708                	sd	a0,8(a4)
    800013d2:	eb0c                	sd	a1,16(a4)
    800013d4:	ef10                	sd	a2,24(a4)
    800013d6:	02078793          	addi	a5,a5,32
    800013da:	02070713          	addi	a4,a4,32
    800013de:	fed792e3          	bne	a5,a3,800013c2 <fork+0x54>
  np->trapframe->a0 = 0;
    800013e2:	0609b783          	ld	a5,96(s3)
    800013e6:	0607b823          	sd	zero,112(a5)
    800013ea:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    800013ee:	15800a13          	li	s4,344
    800013f2:	a03d                	j	80001420 <fork+0xb2>
    freeproc(np);
    800013f4:	854e                	mv	a0,s3
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	d5c080e7          	jalr	-676(ra) # 80001152 <freeproc>
    release(&np->lock);
    800013fe:	854e                	mv	a0,s3
    80001400:	00005097          	auipc	ra,0x5
    80001404:	290080e7          	jalr	656(ra) # 80006690 <release>
    return -1;
    80001408:	5a7d                	li	s4,-1
    8000140a:	a069                	j	80001494 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000140c:	00002097          	auipc	ra,0x2
    80001410:	6d6080e7          	jalr	1750(ra) # 80003ae2 <filedup>
    80001414:	009987b3          	add	a5,s3,s1
    80001418:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000141a:	04a1                	addi	s1,s1,8
    8000141c:	01448763          	beq	s1,s4,8000142a <fork+0xbc>
    if(p->ofile[i])
    80001420:	009907b3          	add	a5,s2,s1
    80001424:	6388                	ld	a0,0(a5)
    80001426:	f17d                	bnez	a0,8000140c <fork+0x9e>
    80001428:	bfcd                	j	8000141a <fork+0xac>
  np->cwd = idup(p->cwd);
    8000142a:	15893503          	ld	a0,344(s2)
    8000142e:	00002097          	auipc	ra,0x2
    80001432:	82a080e7          	jalr	-2006(ra) # 80002c58 <idup>
    80001436:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000143a:	4641                	li	a2,16
    8000143c:	16090593          	addi	a1,s2,352
    80001440:	16098513          	addi	a0,s3,352
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	fce080e7          	jalr	-50(ra) # 80000412 <safestrcpy>
  pid = np->pid;
    8000144c:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001450:	854e                	mv	a0,s3
    80001452:	00005097          	auipc	ra,0x5
    80001456:	23e080e7          	jalr	574(ra) # 80006690 <release>
  acquire(&wait_lock);
    8000145a:	00008497          	auipc	s1,0x8
    8000145e:	d7648493          	addi	s1,s1,-650 # 800091d0 <wait_lock>
    80001462:	8526                	mv	a0,s1
    80001464:	00005097          	auipc	ra,0x5
    80001468:	15c080e7          	jalr	348(ra) # 800065c0 <acquire>
  np->parent = p;
    8000146c:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001470:	8526                	mv	a0,s1
    80001472:	00005097          	auipc	ra,0x5
    80001476:	21e080e7          	jalr	542(ra) # 80006690 <release>
  acquire(&np->lock);
    8000147a:	854e                	mv	a0,s3
    8000147c:	00005097          	auipc	ra,0x5
    80001480:	144080e7          	jalr	324(ra) # 800065c0 <acquire>
  np->state = RUNNABLE;
    80001484:	478d                	li	a5,3
    80001486:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    8000148a:	854e                	mv	a0,s3
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	204080e7          	jalr	516(ra) # 80006690 <release>
}
    80001494:	8552                	mv	a0,s4
    80001496:	70a2                	ld	ra,40(sp)
    80001498:	7402                	ld	s0,32(sp)
    8000149a:	64e2                	ld	s1,24(sp)
    8000149c:	6942                	ld	s2,16(sp)
    8000149e:	69a2                	ld	s3,8(sp)
    800014a0:	6a02                	ld	s4,0(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret
    return -1;
    800014a6:	5a7d                	li	s4,-1
    800014a8:	b7f5                	j	80001494 <fork+0x126>

00000000800014aa <scheduler>:
{
    800014aa:	7139                	addi	sp,sp,-64
    800014ac:	fc06                	sd	ra,56(sp)
    800014ae:	f822                	sd	s0,48(sp)
    800014b0:	f426                	sd	s1,40(sp)
    800014b2:	f04a                	sd	s2,32(sp)
    800014b4:	ec4e                	sd	s3,24(sp)
    800014b6:	e852                	sd	s4,16(sp)
    800014b8:	e456                	sd	s5,8(sp)
    800014ba:	e05a                	sd	s6,0(sp)
    800014bc:	0080                	addi	s0,sp,64
    800014be:	8792                	mv	a5,tp
  int id = r_tp();
    800014c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c2:	00779a93          	slli	s5,a5,0x7
    800014c6:	00008717          	auipc	a4,0x8
    800014ca:	cea70713          	addi	a4,a4,-790 # 800091b0 <pid_lock>
    800014ce:	9756                	add	a4,a4,s5
    800014d0:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800014d4:	00008717          	auipc	a4,0x8
    800014d8:	d2470713          	addi	a4,a4,-732 # 800091f8 <cpus+0x8>
    800014dc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014de:	498d                	li	s3,3
        p->state = RUNNING;
    800014e0:	4b11                	li	s6,4
        c->proc = p;
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	00008a17          	auipc	s4,0x8
    800014e8:	ccca0a13          	addi	s4,s4,-820 # 800091b0 <pid_lock>
    800014ec:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ee:	0000e917          	auipc	s2,0xe
    800014f2:	d0290913          	addi	s2,s2,-766 # 8000f1f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014fe:	10079073          	csrw	sstatus,a5
    80001502:	00008497          	auipc	s1,0x8
    80001506:	0ee48493          	addi	s1,s1,238 # 800095f0 <proc>
    8000150a:	a03d                	j	80001538 <scheduler+0x8e>
        p->state = RUNNING;
    8000150c:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001510:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001514:	06848593          	addi	a1,s1,104
    80001518:	8556                	mv	a0,s5
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	640080e7          	jalr	1600(ra) # 80001b5a <swtch>
        c->proc = 0;
    80001522:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	168080e7          	jalr	360(ra) # 80006690 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001530:	17048493          	addi	s1,s1,368
    80001534:	fd2481e3          	beq	s1,s2,800014f6 <scheduler+0x4c>
      acquire(&p->lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	086080e7          	jalr	134(ra) # 800065c0 <acquire>
      if(p->state == RUNNABLE) {
    80001542:	509c                	lw	a5,32(s1)
    80001544:	ff3791e3          	bne	a5,s3,80001526 <scheduler+0x7c>
    80001548:	b7d1                	j	8000150c <scheduler+0x62>

000000008000154a <sched>:
{
    8000154a:	7179                	addi	sp,sp,-48
    8000154c:	f406                	sd	ra,40(sp)
    8000154e:	f022                	sd	s0,32(sp)
    80001550:	ec26                	sd	s1,24(sp)
    80001552:	e84a                	sd	s2,16(sp)
    80001554:	e44e                	sd	s3,8(sp)
    80001556:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	a48080e7          	jalr	-1464(ra) # 80000fa0 <myproc>
    80001560:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001562:	00005097          	auipc	ra,0x5
    80001566:	fe4080e7          	jalr	-28(ra) # 80006546 <holding>
    8000156a:	c93d                	beqz	a0,800015e0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000156c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000156e:	2781                	sext.w	a5,a5
    80001570:	079e                	slli	a5,a5,0x7
    80001572:	00008717          	auipc	a4,0x8
    80001576:	c3e70713          	addi	a4,a4,-962 # 800091b0 <pid_lock>
    8000157a:	97ba                	add	a5,a5,a4
    8000157c:	0b87a703          	lw	a4,184(a5)
    80001580:	4785                	li	a5,1
    80001582:	06f71763          	bne	a4,a5,800015f0 <sched+0xa6>
  if(p->state == RUNNING)
    80001586:	5098                	lw	a4,32(s1)
    80001588:	4791                	li	a5,4
    8000158a:	06f70b63          	beq	a4,a5,80001600 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000158e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001592:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001594:	efb5                	bnez	a5,80001610 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001596:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001598:	00008917          	auipc	s2,0x8
    8000159c:	c1890913          	addi	s2,s2,-1000 # 800091b0 <pid_lock>
    800015a0:	2781                	sext.w	a5,a5
    800015a2:	079e                	slli	a5,a5,0x7
    800015a4:	97ca                	add	a5,a5,s2
    800015a6:	0bc7a983          	lw	s3,188(a5)
    800015aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ac:	2781                	sext.w	a5,a5
    800015ae:	079e                	slli	a5,a5,0x7
    800015b0:	00008597          	auipc	a1,0x8
    800015b4:	c4858593          	addi	a1,a1,-952 # 800091f8 <cpus+0x8>
    800015b8:	95be                	add	a1,a1,a5
    800015ba:	06848513          	addi	a0,s1,104
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	59c080e7          	jalr	1436(ra) # 80001b5a <swtch>
    800015c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015c8:	2781                	sext.w	a5,a5
    800015ca:	079e                	slli	a5,a5,0x7
    800015cc:	97ca                	add	a5,a5,s2
    800015ce:	0b37ae23          	sw	s3,188(a5)
}
    800015d2:	70a2                	ld	ra,40(sp)
    800015d4:	7402                	ld	s0,32(sp)
    800015d6:	64e2                	ld	s1,24(sp)
    800015d8:	6942                	ld	s2,16(sp)
    800015da:	69a2                	ld	s3,8(sp)
    800015dc:	6145                	addi	sp,sp,48
    800015de:	8082                	ret
    panic("sched p->lock");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bb850513          	addi	a0,a0,-1096 # 80008198 <etext+0x198>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	aa4080e7          	jalr	-1372(ra) # 8000608c <panic>
    panic("sched locks");
    800015f0:	00007517          	auipc	a0,0x7
    800015f4:	bb850513          	addi	a0,a0,-1096 # 800081a8 <etext+0x1a8>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	a94080e7          	jalr	-1388(ra) # 8000608c <panic>
    panic("sched running");
    80001600:	00007517          	auipc	a0,0x7
    80001604:	bb850513          	addi	a0,a0,-1096 # 800081b8 <etext+0x1b8>
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	a84080e7          	jalr	-1404(ra) # 8000608c <panic>
    panic("sched interruptible");
    80001610:	00007517          	auipc	a0,0x7
    80001614:	bb850513          	addi	a0,a0,-1096 # 800081c8 <etext+0x1c8>
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	a74080e7          	jalr	-1420(ra) # 8000608c <panic>

0000000080001620 <yield>:
{
    80001620:	1101                	addi	sp,sp,-32
    80001622:	ec06                	sd	ra,24(sp)
    80001624:	e822                	sd	s0,16(sp)
    80001626:	e426                	sd	s1,8(sp)
    80001628:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	976080e7          	jalr	-1674(ra) # 80000fa0 <myproc>
    80001632:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001634:	00005097          	auipc	ra,0x5
    80001638:	f8c080e7          	jalr	-116(ra) # 800065c0 <acquire>
  p->state = RUNNABLE;
    8000163c:	478d                	li	a5,3
    8000163e:	d09c                	sw	a5,32(s1)
  sched();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	f0a080e7          	jalr	-246(ra) # 8000154a <sched>
  release(&p->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	046080e7          	jalr	70(ra) # 80006690 <release>
}
    80001652:	60e2                	ld	ra,24(sp)
    80001654:	6442                	ld	s0,16(sp)
    80001656:	64a2                	ld	s1,8(sp)
    80001658:	6105                	addi	sp,sp,32
    8000165a:	8082                	ret

000000008000165c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000165c:	7179                	addi	sp,sp,-48
    8000165e:	f406                	sd	ra,40(sp)
    80001660:	f022                	sd	s0,32(sp)
    80001662:	ec26                	sd	s1,24(sp)
    80001664:	e84a                	sd	s2,16(sp)
    80001666:	e44e                	sd	s3,8(sp)
    80001668:	1800                	addi	s0,sp,48
    8000166a:	89aa                	mv	s3,a0
    8000166c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	932080e7          	jalr	-1742(ra) # 80000fa0 <myproc>
    80001676:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	f48080e7          	jalr	-184(ra) # 800065c0 <acquire>
  release(lk);
    80001680:	854a                	mv	a0,s2
    80001682:	00005097          	auipc	ra,0x5
    80001686:	00e080e7          	jalr	14(ra) # 80006690 <release>

  // Go to sleep.
  p->chan = chan;
    8000168a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000168e:	4789                	li	a5,2
    80001690:	d09c                	sw	a5,32(s1)

  sched();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	eb8080e7          	jalr	-328(ra) # 8000154a <sched>

  // Tidy up.
  p->chan = 0;
    8000169a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	ff0080e7          	jalr	-16(ra) # 80006690 <release>
  acquire(lk);
    800016a8:	854a                	mv	a0,s2
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	f16080e7          	jalr	-234(ra) # 800065c0 <acquire>
}
    800016b2:	70a2                	ld	ra,40(sp)
    800016b4:	7402                	ld	s0,32(sp)
    800016b6:	64e2                	ld	s1,24(sp)
    800016b8:	6942                	ld	s2,16(sp)
    800016ba:	69a2                	ld	s3,8(sp)
    800016bc:	6145                	addi	sp,sp,48
    800016be:	8082                	ret

00000000800016c0 <wait>:
{
    800016c0:	715d                	addi	sp,sp,-80
    800016c2:	e486                	sd	ra,72(sp)
    800016c4:	e0a2                	sd	s0,64(sp)
    800016c6:	fc26                	sd	s1,56(sp)
    800016c8:	f84a                	sd	s2,48(sp)
    800016ca:	f44e                	sd	s3,40(sp)
    800016cc:	f052                	sd	s4,32(sp)
    800016ce:	ec56                	sd	s5,24(sp)
    800016d0:	e85a                	sd	s6,16(sp)
    800016d2:	e45e                	sd	s7,8(sp)
    800016d4:	e062                	sd	s8,0(sp)
    800016d6:	0880                	addi	s0,sp,80
    800016d8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016da:	00000097          	auipc	ra,0x0
    800016de:	8c6080e7          	jalr	-1850(ra) # 80000fa0 <myproc>
    800016e2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016e4:	00008517          	auipc	a0,0x8
    800016e8:	aec50513          	addi	a0,a0,-1300 # 800091d0 <wait_lock>
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	ed4080e7          	jalr	-300(ra) # 800065c0 <acquire>
    havekids = 0;
    800016f4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016f6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016f8:	0000e997          	auipc	s3,0xe
    800016fc:	af898993          	addi	s3,s3,-1288 # 8000f1f0 <tickslock>
        havekids = 1;
    80001700:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001702:	00008c17          	auipc	s8,0x8
    80001706:	acec0c13          	addi	s8,s8,-1330 # 800091d0 <wait_lock>
    havekids = 0;
    8000170a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000170c:	00008497          	auipc	s1,0x8
    80001710:	ee448493          	addi	s1,s1,-284 # 800095f0 <proc>
    80001714:	a0bd                	j	80001782 <wait+0xc2>
          pid = np->pid;
    80001716:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000171a:	000b0e63          	beqz	s6,80001736 <wait+0x76>
    8000171e:	4691                	li	a3,4
    80001720:	03448613          	addi	a2,s1,52
    80001724:	85da                	mv	a1,s6
    80001726:	05893503          	ld	a0,88(s2)
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	538080e7          	jalr	1336(ra) # 80000c62 <copyout>
    80001732:	02054563          	bltz	a0,8000175c <wait+0x9c>
          freeproc(np);
    80001736:	8526                	mv	a0,s1
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	a1a080e7          	jalr	-1510(ra) # 80001152 <freeproc>
          release(&np->lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	f4e080e7          	jalr	-178(ra) # 80006690 <release>
          release(&wait_lock);
    8000174a:	00008517          	auipc	a0,0x8
    8000174e:	a8650513          	addi	a0,a0,-1402 # 800091d0 <wait_lock>
    80001752:	00005097          	auipc	ra,0x5
    80001756:	f3e080e7          	jalr	-194(ra) # 80006690 <release>
          return pid;
    8000175a:	a09d                	j	800017c0 <wait+0x100>
            release(&np->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	f32080e7          	jalr	-206(ra) # 80006690 <release>
            release(&wait_lock);
    80001766:	00008517          	auipc	a0,0x8
    8000176a:	a6a50513          	addi	a0,a0,-1430 # 800091d0 <wait_lock>
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	f22080e7          	jalr	-222(ra) # 80006690 <release>
            return -1;
    80001776:	59fd                	li	s3,-1
    80001778:	a0a1                	j	800017c0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000177a:	17048493          	addi	s1,s1,368
    8000177e:	03348463          	beq	s1,s3,800017a6 <wait+0xe6>
      if(np->parent == p){
    80001782:	60bc                	ld	a5,64(s1)
    80001784:	ff279be3          	bne	a5,s2,8000177a <wait+0xba>
        acquire(&np->lock);
    80001788:	8526                	mv	a0,s1
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	e36080e7          	jalr	-458(ra) # 800065c0 <acquire>
        if(np->state == ZOMBIE){
    80001792:	509c                	lw	a5,32(s1)
    80001794:	f94781e3          	beq	a5,s4,80001716 <wait+0x56>
        release(&np->lock);
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	ef6080e7          	jalr	-266(ra) # 80006690 <release>
        havekids = 1;
    800017a2:	8756                	mv	a4,s5
    800017a4:	bfd9                	j	8000177a <wait+0xba>
    if(!havekids || p->killed){
    800017a6:	c701                	beqz	a4,800017ae <wait+0xee>
    800017a8:	03092783          	lw	a5,48(s2)
    800017ac:	c79d                	beqz	a5,800017da <wait+0x11a>
      release(&wait_lock);
    800017ae:	00008517          	auipc	a0,0x8
    800017b2:	a2250513          	addi	a0,a0,-1502 # 800091d0 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	eda080e7          	jalr	-294(ra) # 80006690 <release>
      return -1;
    800017be:	59fd                	li	s3,-1
}
    800017c0:	854e                	mv	a0,s3
    800017c2:	60a6                	ld	ra,72(sp)
    800017c4:	6406                	ld	s0,64(sp)
    800017c6:	74e2                	ld	s1,56(sp)
    800017c8:	7942                	ld	s2,48(sp)
    800017ca:	79a2                	ld	s3,40(sp)
    800017cc:	7a02                	ld	s4,32(sp)
    800017ce:	6ae2                	ld	s5,24(sp)
    800017d0:	6b42                	ld	s6,16(sp)
    800017d2:	6ba2                	ld	s7,8(sp)
    800017d4:	6c02                	ld	s8,0(sp)
    800017d6:	6161                	addi	sp,sp,80
    800017d8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017da:	85e2                	mv	a1,s8
    800017dc:	854a                	mv	a0,s2
    800017de:	00000097          	auipc	ra,0x0
    800017e2:	e7e080e7          	jalr	-386(ra) # 8000165c <sleep>
    havekids = 0;
    800017e6:	b715                	j	8000170a <wait+0x4a>

00000000800017e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017e8:	7139                	addi	sp,sp,-64
    800017ea:	fc06                	sd	ra,56(sp)
    800017ec:	f822                	sd	s0,48(sp)
    800017ee:	f426                	sd	s1,40(sp)
    800017f0:	f04a                	sd	s2,32(sp)
    800017f2:	ec4e                	sd	s3,24(sp)
    800017f4:	e852                	sd	s4,16(sp)
    800017f6:	e456                	sd	s5,8(sp)
    800017f8:	0080                	addi	s0,sp,64
    800017fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017fc:	00008497          	auipc	s1,0x8
    80001800:	df448493          	addi	s1,s1,-524 # 800095f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001804:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001806:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001808:	0000e917          	auipc	s2,0xe
    8000180c:	9e890913          	addi	s2,s2,-1560 # 8000f1f0 <tickslock>
    80001810:	a821                	j	80001828 <wakeup+0x40>
        p->state = RUNNABLE;
    80001812:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	e78080e7          	jalr	-392(ra) # 80006690 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001820:	17048493          	addi	s1,s1,368
    80001824:	03248463          	beq	s1,s2,8000184c <wakeup+0x64>
    if(p != myproc()){
    80001828:	fffff097          	auipc	ra,0xfffff
    8000182c:	778080e7          	jalr	1912(ra) # 80000fa0 <myproc>
    80001830:	fea488e3          	beq	s1,a0,80001820 <wakeup+0x38>
      acquire(&p->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	d8a080e7          	jalr	-630(ra) # 800065c0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000183e:	509c                	lw	a5,32(s1)
    80001840:	fd379be3          	bne	a5,s3,80001816 <wakeup+0x2e>
    80001844:	749c                	ld	a5,40(s1)
    80001846:	fd4798e3          	bne	a5,s4,80001816 <wakeup+0x2e>
    8000184a:	b7e1                	j	80001812 <wakeup+0x2a>
    }
  }
}
    8000184c:	70e2                	ld	ra,56(sp)
    8000184e:	7442                	ld	s0,48(sp)
    80001850:	74a2                	ld	s1,40(sp)
    80001852:	7902                	ld	s2,32(sp)
    80001854:	69e2                	ld	s3,24(sp)
    80001856:	6a42                	ld	s4,16(sp)
    80001858:	6aa2                	ld	s5,8(sp)
    8000185a:	6121                	addi	sp,sp,64
    8000185c:	8082                	ret

000000008000185e <reparent>:
{
    8000185e:	7179                	addi	sp,sp,-48
    80001860:	f406                	sd	ra,40(sp)
    80001862:	f022                	sd	s0,32(sp)
    80001864:	ec26                	sd	s1,24(sp)
    80001866:	e84a                	sd	s2,16(sp)
    80001868:	e44e                	sd	s3,8(sp)
    8000186a:	e052                	sd	s4,0(sp)
    8000186c:	1800                	addi	s0,sp,48
    8000186e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001870:	00008497          	auipc	s1,0x8
    80001874:	d8048493          	addi	s1,s1,-640 # 800095f0 <proc>
      pp->parent = initproc;
    80001878:	00007a17          	auipc	s4,0x7
    8000187c:	798a0a13          	addi	s4,s4,1944 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001880:	0000e997          	auipc	s3,0xe
    80001884:	97098993          	addi	s3,s3,-1680 # 8000f1f0 <tickslock>
    80001888:	a029                	j	80001892 <reparent+0x34>
    8000188a:	17048493          	addi	s1,s1,368
    8000188e:	01348d63          	beq	s1,s3,800018a8 <reparent+0x4a>
    if(pp->parent == p){
    80001892:	60bc                	ld	a5,64(s1)
    80001894:	ff279be3          	bne	a5,s2,8000188a <reparent+0x2c>
      pp->parent = initproc;
    80001898:	000a3503          	ld	a0,0(s4)
    8000189c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000189e:	00000097          	auipc	ra,0x0
    800018a2:	f4a080e7          	jalr	-182(ra) # 800017e8 <wakeup>
    800018a6:	b7d5                	j	8000188a <reparent+0x2c>
}
    800018a8:	70a2                	ld	ra,40(sp)
    800018aa:	7402                	ld	s0,32(sp)
    800018ac:	64e2                	ld	s1,24(sp)
    800018ae:	6942                	ld	s2,16(sp)
    800018b0:	69a2                	ld	s3,8(sp)
    800018b2:	6a02                	ld	s4,0(sp)
    800018b4:	6145                	addi	sp,sp,48
    800018b6:	8082                	ret

00000000800018b8 <exit>:
{
    800018b8:	7179                	addi	sp,sp,-48
    800018ba:	f406                	sd	ra,40(sp)
    800018bc:	f022                	sd	s0,32(sp)
    800018be:	ec26                	sd	s1,24(sp)
    800018c0:	e84a                	sd	s2,16(sp)
    800018c2:	e44e                	sd	s3,8(sp)
    800018c4:	e052                	sd	s4,0(sp)
    800018c6:	1800                	addi	s0,sp,48
    800018c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	6d6080e7          	jalr	1750(ra) # 80000fa0 <myproc>
    800018d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800018d4:	00007797          	auipc	a5,0x7
    800018d8:	73c7b783          	ld	a5,1852(a5) # 80009010 <initproc>
    800018dc:	0d850493          	addi	s1,a0,216
    800018e0:	15850913          	addi	s2,a0,344
    800018e4:	02a79363          	bne	a5,a0,8000190a <exit+0x52>
    panic("init exiting");
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	8f850513          	addi	a0,a0,-1800 # 800081e0 <etext+0x1e0>
    800018f0:	00004097          	auipc	ra,0x4
    800018f4:	79c080e7          	jalr	1948(ra) # 8000608c <panic>
      fileclose(f);
    800018f8:	00002097          	auipc	ra,0x2
    800018fc:	23c080e7          	jalr	572(ra) # 80003b34 <fileclose>
      p->ofile[fd] = 0;
    80001900:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001904:	04a1                	addi	s1,s1,8
    80001906:	01248563          	beq	s1,s2,80001910 <exit+0x58>
    if(p->ofile[fd]){
    8000190a:	6088                	ld	a0,0(s1)
    8000190c:	f575                	bnez	a0,800018f8 <exit+0x40>
    8000190e:	bfdd                	j	80001904 <exit+0x4c>
  begin_op();
    80001910:	00002097          	auipc	ra,0x2
    80001914:	d58080e7          	jalr	-680(ra) # 80003668 <begin_op>
  iput(p->cwd);
    80001918:	1589b503          	ld	a0,344(s3)
    8000191c:	00001097          	auipc	ra,0x1
    80001920:	534080e7          	jalr	1332(ra) # 80002e50 <iput>
  end_op();
    80001924:	00002097          	auipc	ra,0x2
    80001928:	dc4080e7          	jalr	-572(ra) # 800036e8 <end_op>
  p->cwd = 0;
    8000192c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001930:	00008497          	auipc	s1,0x8
    80001934:	8a048493          	addi	s1,s1,-1888 # 800091d0 <wait_lock>
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	c86080e7          	jalr	-890(ra) # 800065c0 <acquire>
  reparent(p);
    80001942:	854e                	mv	a0,s3
    80001944:	00000097          	auipc	ra,0x0
    80001948:	f1a080e7          	jalr	-230(ra) # 8000185e <reparent>
  wakeup(p->parent);
    8000194c:	0409b503          	ld	a0,64(s3)
    80001950:	00000097          	auipc	ra,0x0
    80001954:	e98080e7          	jalr	-360(ra) # 800017e8 <wakeup>
  acquire(&p->lock);
    80001958:	854e                	mv	a0,s3
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	c66080e7          	jalr	-922(ra) # 800065c0 <acquire>
  p->xstate = status;
    80001962:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001966:	4795                	li	a5,5
    80001968:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000196c:	8526                	mv	a0,s1
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	d22080e7          	jalr	-734(ra) # 80006690 <release>
  sched();
    80001976:	00000097          	auipc	ra,0x0
    8000197a:	bd4080e7          	jalr	-1068(ra) # 8000154a <sched>
  panic("zombie exit");
    8000197e:	00007517          	auipc	a0,0x7
    80001982:	87250513          	addi	a0,a0,-1934 # 800081f0 <etext+0x1f0>
    80001986:	00004097          	auipc	ra,0x4
    8000198a:	706080e7          	jalr	1798(ra) # 8000608c <panic>

000000008000198e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000198e:	7179                	addi	sp,sp,-48
    80001990:	f406                	sd	ra,40(sp)
    80001992:	f022                	sd	s0,32(sp)
    80001994:	ec26                	sd	s1,24(sp)
    80001996:	e84a                	sd	s2,16(sp)
    80001998:	e44e                	sd	s3,8(sp)
    8000199a:	1800                	addi	s0,sp,48
    8000199c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000199e:	00008497          	auipc	s1,0x8
    800019a2:	c5248493          	addi	s1,s1,-942 # 800095f0 <proc>
    800019a6:	0000e997          	auipc	s3,0xe
    800019aa:	84a98993          	addi	s3,s3,-1974 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    800019ae:	8526                	mv	a0,s1
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	c10080e7          	jalr	-1008(ra) # 800065c0 <acquire>
    if(p->pid == pid){
    800019b8:	5c9c                	lw	a5,56(s1)
    800019ba:	01278d63          	beq	a5,s2,800019d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019be:	8526                	mv	a0,s1
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	cd0080e7          	jalr	-816(ra) # 80006690 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c8:	17048493          	addi	s1,s1,368
    800019cc:	ff3491e3          	bne	s1,s3,800019ae <kill+0x20>
  }
  return -1;
    800019d0:	557d                	li	a0,-1
    800019d2:	a829                	j	800019ec <kill+0x5e>
      p->killed = 1;
    800019d4:	4785                	li	a5,1
    800019d6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800019d8:	5098                	lw	a4,32(s1)
    800019da:	4789                	li	a5,2
    800019dc:	00f70f63          	beq	a4,a5,800019fa <kill+0x6c>
      release(&p->lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	cae080e7          	jalr	-850(ra) # 80006690 <release>
      return 0;
    800019ea:	4501                	li	a0,0
}
    800019ec:	70a2                	ld	ra,40(sp)
    800019ee:	7402                	ld	s0,32(sp)
    800019f0:	64e2                	ld	s1,24(sp)
    800019f2:	6942                	ld	s2,16(sp)
    800019f4:	69a2                	ld	s3,8(sp)
    800019f6:	6145                	addi	sp,sp,48
    800019f8:	8082                	ret
        p->state = RUNNABLE;
    800019fa:	478d                	li	a5,3
    800019fc:	d09c                	sw	a5,32(s1)
    800019fe:	b7cd                	j	800019e0 <kill+0x52>

0000000080001a00 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a00:	7179                	addi	sp,sp,-48
    80001a02:	f406                	sd	ra,40(sp)
    80001a04:	f022                	sd	s0,32(sp)
    80001a06:	ec26                	sd	s1,24(sp)
    80001a08:	e84a                	sd	s2,16(sp)
    80001a0a:	e44e                	sd	s3,8(sp)
    80001a0c:	e052                	sd	s4,0(sp)
    80001a0e:	1800                	addi	s0,sp,48
    80001a10:	84aa                	mv	s1,a0
    80001a12:	892e                	mv	s2,a1
    80001a14:	89b2                	mv	s3,a2
    80001a16:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a18:	fffff097          	auipc	ra,0xfffff
    80001a1c:	588080e7          	jalr	1416(ra) # 80000fa0 <myproc>
  if(user_dst){
    80001a20:	c08d                	beqz	s1,80001a42 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a22:	86d2                	mv	a3,s4
    80001a24:	864e                	mv	a2,s3
    80001a26:	85ca                	mv	a1,s2
    80001a28:	6d28                	ld	a0,88(a0)
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	238080e7          	jalr	568(ra) # 80000c62 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a32:	70a2                	ld	ra,40(sp)
    80001a34:	7402                	ld	s0,32(sp)
    80001a36:	64e2                	ld	s1,24(sp)
    80001a38:	6942                	ld	s2,16(sp)
    80001a3a:	69a2                	ld	s3,8(sp)
    80001a3c:	6a02                	ld	s4,0(sp)
    80001a3e:	6145                	addi	sp,sp,48
    80001a40:	8082                	ret
    memmove((char *)dst, src, len);
    80001a42:	000a061b          	sext.w	a2,s4
    80001a46:	85ce                	mv	a1,s3
    80001a48:	854a                	mv	a0,s2
    80001a4a:	fffff097          	auipc	ra,0xfffff
    80001a4e:	8d6080e7          	jalr	-1834(ra) # 80000320 <memmove>
    return 0;
    80001a52:	8526                	mv	a0,s1
    80001a54:	bff9                	j	80001a32 <either_copyout+0x32>

0000000080001a56 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a56:	7179                	addi	sp,sp,-48
    80001a58:	f406                	sd	ra,40(sp)
    80001a5a:	f022                	sd	s0,32(sp)
    80001a5c:	ec26                	sd	s1,24(sp)
    80001a5e:	e84a                	sd	s2,16(sp)
    80001a60:	e44e                	sd	s3,8(sp)
    80001a62:	e052                	sd	s4,0(sp)
    80001a64:	1800                	addi	s0,sp,48
    80001a66:	892a                	mv	s2,a0
    80001a68:	84ae                	mv	s1,a1
    80001a6a:	89b2                	mv	s3,a2
    80001a6c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	532080e7          	jalr	1330(ra) # 80000fa0 <myproc>
  if(user_src){
    80001a76:	c08d                	beqz	s1,80001a98 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a78:	86d2                	mv	a3,s4
    80001a7a:	864e                	mv	a2,s3
    80001a7c:	85ca                	mv	a1,s2
    80001a7e:	6d28                	ld	a0,88(a0)
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	26e080e7          	jalr	622(ra) # 80000cee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a88:	70a2                	ld	ra,40(sp)
    80001a8a:	7402                	ld	s0,32(sp)
    80001a8c:	64e2                	ld	s1,24(sp)
    80001a8e:	6942                	ld	s2,16(sp)
    80001a90:	69a2                	ld	s3,8(sp)
    80001a92:	6a02                	ld	s4,0(sp)
    80001a94:	6145                	addi	sp,sp,48
    80001a96:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a98:	000a061b          	sext.w	a2,s4
    80001a9c:	85ce                	mv	a1,s3
    80001a9e:	854a                	mv	a0,s2
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	880080e7          	jalr	-1920(ra) # 80000320 <memmove>
    return 0;
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	bff9                	j	80001a88 <either_copyin+0x32>

0000000080001aac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aac:	715d                	addi	sp,sp,-80
    80001aae:	e486                	sd	ra,72(sp)
    80001ab0:	e0a2                	sd	s0,64(sp)
    80001ab2:	fc26                	sd	s1,56(sp)
    80001ab4:	f84a                	sd	s2,48(sp)
    80001ab6:	f44e                	sd	s3,40(sp)
    80001ab8:	f052                	sd	s4,32(sp)
    80001aba:	ec56                	sd	s5,24(sp)
    80001abc:	e85a                	sd	s6,16(sp)
    80001abe:	e45e                	sd	s7,8(sp)
    80001ac0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac2:	00007517          	auipc	a0,0x7
    80001ac6:	dae50513          	addi	a0,a0,-594 # 80008870 <digits+0x88>
    80001aca:	00004097          	auipc	ra,0x4
    80001ace:	60c080e7          	jalr	1548(ra) # 800060d6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad2:	00008497          	auipc	s1,0x8
    80001ad6:	c7e48493          	addi	s1,s1,-898 # 80009750 <proc+0x160>
    80001ada:	0000e917          	auipc	s2,0xe
    80001ade:	87690913          	addi	s2,s2,-1930 # 8000f350 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ae4:	00006997          	auipc	s3,0x6
    80001ae8:	71c98993          	addi	s3,s3,1820 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001aec:	00006a97          	auipc	s5,0x6
    80001af0:	71ca8a93          	addi	s5,s5,1820 # 80008208 <etext+0x208>
    printf("\n");
    80001af4:	00007a17          	auipc	s4,0x7
    80001af8:	d7ca0a13          	addi	s4,s4,-644 # 80008870 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001afc:	00006b97          	auipc	s7,0x6
    80001b00:	744b8b93          	addi	s7,s7,1860 # 80008240 <states.1725>
    80001b04:	a00d                	j	80001b26 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b06:	ed86a583          	lw	a1,-296(a3)
    80001b0a:	8556                	mv	a0,s5
    80001b0c:	00004097          	auipc	ra,0x4
    80001b10:	5ca080e7          	jalr	1482(ra) # 800060d6 <printf>
    printf("\n");
    80001b14:	8552                	mv	a0,s4
    80001b16:	00004097          	auipc	ra,0x4
    80001b1a:	5c0080e7          	jalr	1472(ra) # 800060d6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b1e:	17048493          	addi	s1,s1,368
    80001b22:	03248163          	beq	s1,s2,80001b44 <procdump+0x98>
    if(p->state == UNUSED)
    80001b26:	86a6                	mv	a3,s1
    80001b28:	ec04a783          	lw	a5,-320(s1)
    80001b2c:	dbed                	beqz	a5,80001b1e <procdump+0x72>
      state = "???";
    80001b2e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b30:	fcfb6be3          	bltu	s6,a5,80001b06 <procdump+0x5a>
    80001b34:	1782                	slli	a5,a5,0x20
    80001b36:	9381                	srli	a5,a5,0x20
    80001b38:	078e                	slli	a5,a5,0x3
    80001b3a:	97de                	add	a5,a5,s7
    80001b3c:	6390                	ld	a2,0(a5)
    80001b3e:	f661                	bnez	a2,80001b06 <procdump+0x5a>
      state = "???";
    80001b40:	864e                	mv	a2,s3
    80001b42:	b7d1                	j	80001b06 <procdump+0x5a>
  }
}
    80001b44:	60a6                	ld	ra,72(sp)
    80001b46:	6406                	ld	s0,64(sp)
    80001b48:	74e2                	ld	s1,56(sp)
    80001b4a:	7942                	ld	s2,48(sp)
    80001b4c:	79a2                	ld	s3,40(sp)
    80001b4e:	7a02                	ld	s4,32(sp)
    80001b50:	6ae2                	ld	s5,24(sp)
    80001b52:	6b42                	ld	s6,16(sp)
    80001b54:	6ba2                	ld	s7,8(sp)
    80001b56:	6161                	addi	sp,sp,80
    80001b58:	8082                	ret

0000000080001b5a <swtch>:
    80001b5a:	00153023          	sd	ra,0(a0)
    80001b5e:	00253423          	sd	sp,8(a0)
    80001b62:	e900                	sd	s0,16(a0)
    80001b64:	ed04                	sd	s1,24(a0)
    80001b66:	03253023          	sd	s2,32(a0)
    80001b6a:	03353423          	sd	s3,40(a0)
    80001b6e:	03453823          	sd	s4,48(a0)
    80001b72:	03553c23          	sd	s5,56(a0)
    80001b76:	05653023          	sd	s6,64(a0)
    80001b7a:	05753423          	sd	s7,72(a0)
    80001b7e:	05853823          	sd	s8,80(a0)
    80001b82:	05953c23          	sd	s9,88(a0)
    80001b86:	07a53023          	sd	s10,96(a0)
    80001b8a:	07b53423          	sd	s11,104(a0)
    80001b8e:	0005b083          	ld	ra,0(a1)
    80001b92:	0085b103          	ld	sp,8(a1)
    80001b96:	6980                	ld	s0,16(a1)
    80001b98:	6d84                	ld	s1,24(a1)
    80001b9a:	0205b903          	ld	s2,32(a1)
    80001b9e:	0285b983          	ld	s3,40(a1)
    80001ba2:	0305ba03          	ld	s4,48(a1)
    80001ba6:	0385ba83          	ld	s5,56(a1)
    80001baa:	0405bb03          	ld	s6,64(a1)
    80001bae:	0485bb83          	ld	s7,72(a1)
    80001bb2:	0505bc03          	ld	s8,80(a1)
    80001bb6:	0585bc83          	ld	s9,88(a1)
    80001bba:	0605bd03          	ld	s10,96(a1)
    80001bbe:	0685bd83          	ld	s11,104(a1)
    80001bc2:	8082                	ret

0000000080001bc4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bc4:	1141                	addi	sp,sp,-16
    80001bc6:	e406                	sd	ra,8(sp)
    80001bc8:	e022                	sd	s0,0(sp)
    80001bca:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bcc:	00006597          	auipc	a1,0x6
    80001bd0:	6a458593          	addi	a1,a1,1700 # 80008270 <states.1725+0x30>
    80001bd4:	0000d517          	auipc	a0,0xd
    80001bd8:	61c50513          	addi	a0,a0,1564 # 8000f1f0 <tickslock>
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	b60080e7          	jalr	-1184(ra) # 8000673c <initlock>
}
    80001be4:	60a2                	ld	ra,8(sp)
    80001be6:	6402                	ld	s0,0(sp)
    80001be8:	0141                	addi	sp,sp,16
    80001bea:	8082                	ret

0000000080001bec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bec:	1141                	addi	sp,sp,-16
    80001bee:	e422                	sd	s0,8(sp)
    80001bf0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf2:	00003797          	auipc	a5,0x3
    80001bf6:	56e78793          	addi	a5,a5,1390 # 80005160 <kernelvec>
    80001bfa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bfe:	6422                	ld	s0,8(sp)
    80001c00:	0141                	addi	sp,sp,16
    80001c02:	8082                	ret

0000000080001c04 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c04:	1141                	addi	sp,sp,-16
    80001c06:	e406                	sd	ra,8(sp)
    80001c08:	e022                	sd	s0,0(sp)
    80001c0a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	394080e7          	jalr	916(ra) # 80000fa0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c1a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c1e:	00005617          	auipc	a2,0x5
    80001c22:	3e260613          	addi	a2,a2,994 # 80007000 <_trampoline>
    80001c26:	00005697          	auipc	a3,0x5
    80001c2a:	3da68693          	addi	a3,a3,986 # 80007000 <_trampoline>
    80001c2e:	8e91                	sub	a3,a3,a2
    80001c30:	040007b7          	lui	a5,0x4000
    80001c34:	17fd                	addi	a5,a5,-1
    80001c36:	07b2                	slli	a5,a5,0xc
    80001c38:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c3a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c3e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c40:	180026f3          	csrr	a3,satp
    80001c44:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c46:	7138                	ld	a4,96(a0)
    80001c48:	6534                	ld	a3,72(a0)
    80001c4a:	6585                	lui	a1,0x1
    80001c4c:	96ae                	add	a3,a3,a1
    80001c4e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c50:	7138                	ld	a4,96(a0)
    80001c52:	00000697          	auipc	a3,0x0
    80001c56:	13868693          	addi	a3,a3,312 # 80001d8a <usertrap>
    80001c5a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c5c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c5e:	8692                	mv	a3,tp
    80001c60:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c62:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c66:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c6a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c6e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c72:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c74:	6f18                	ld	a4,24(a4)
    80001c76:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c7a:	6d2c                	ld	a1,88(a0)
    80001c7c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c7e:	00005717          	auipc	a4,0x5
    80001c82:	41270713          	addi	a4,a4,1042 # 80007090 <userret>
    80001c86:	8f11                	sub	a4,a4,a2
    80001c88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c8a:	577d                	li	a4,-1
    80001c8c:	177e                	slli	a4,a4,0x3f
    80001c8e:	8dd9                	or	a1,a1,a4
    80001c90:	02000537          	lui	a0,0x2000
    80001c94:	157d                	addi	a0,a0,-1
    80001c96:	0536                	slli	a0,a0,0xd
    80001c98:	9782                	jalr	a5
}
    80001c9a:	60a2                	ld	ra,8(sp)
    80001c9c:	6402                	ld	s0,0(sp)
    80001c9e:	0141                	addi	sp,sp,16
    80001ca0:	8082                	ret

0000000080001ca2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cac:	0000d497          	auipc	s1,0xd
    80001cb0:	54448493          	addi	s1,s1,1348 # 8000f1f0 <tickslock>
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	00005097          	auipc	ra,0x5
    80001cba:	90a080e7          	jalr	-1782(ra) # 800065c0 <acquire>
  ticks++;
    80001cbe:	00007517          	auipc	a0,0x7
    80001cc2:	35a50513          	addi	a0,a0,858 # 80009018 <ticks>
    80001cc6:	411c                	lw	a5,0(a0)
    80001cc8:	2785                	addiw	a5,a5,1
    80001cca:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	b1c080e7          	jalr	-1252(ra) # 800017e8 <wakeup>
  release(&tickslock);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	00005097          	auipc	ra,0x5
    80001cda:	9ba080e7          	jalr	-1606(ra) # 80006690 <release>
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret

0000000080001ce8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ce8:	1101                	addi	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	e426                	sd	s1,8(sp)
    80001cf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cf6:	00074d63          	bltz	a4,80001d10 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cfa:	57fd                	li	a5,-1
    80001cfc:	17fe                	slli	a5,a5,0x3f
    80001cfe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d00:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d02:	06f70363          	beq	a4,a5,80001d68 <devintr+0x80>
  }
}
    80001d06:	60e2                	ld	ra,24(sp)
    80001d08:	6442                	ld	s0,16(sp)
    80001d0a:	64a2                	ld	s1,8(sp)
    80001d0c:	6105                	addi	sp,sp,32
    80001d0e:	8082                	ret
     (scause & 0xff) == 9){
    80001d10:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d14:	46a5                	li	a3,9
    80001d16:	fed792e3          	bne	a5,a3,80001cfa <devintr+0x12>
    int irq = plic_claim();
    80001d1a:	00003097          	auipc	ra,0x3
    80001d1e:	54e080e7          	jalr	1358(ra) # 80005268 <plic_claim>
    80001d22:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d24:	47a9                	li	a5,10
    80001d26:	02f50763          	beq	a0,a5,80001d54 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d2a:	4785                	li	a5,1
    80001d2c:	02f50963          	beq	a0,a5,80001d5e <devintr+0x76>
    return 1;
    80001d30:	4505                	li	a0,1
    } else if(irq){
    80001d32:	d8f1                	beqz	s1,80001d06 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d34:	85a6                	mv	a1,s1
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	54250513          	addi	a0,a0,1346 # 80008278 <states.1725+0x38>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	398080e7          	jalr	920(ra) # 800060d6 <printf>
      plic_complete(irq);
    80001d46:	8526                	mv	a0,s1
    80001d48:	00003097          	auipc	ra,0x3
    80001d4c:	544080e7          	jalr	1348(ra) # 8000528c <plic_complete>
    return 1;
    80001d50:	4505                	li	a0,1
    80001d52:	bf55                	j	80001d06 <devintr+0x1e>
      uartintr();
    80001d54:	00004097          	auipc	ra,0x4
    80001d58:	7a2080e7          	jalr	1954(ra) # 800064f6 <uartintr>
    80001d5c:	b7ed                	j	80001d46 <devintr+0x5e>
      virtio_disk_intr();
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	a0e080e7          	jalr	-1522(ra) # 8000576c <virtio_disk_intr>
    80001d66:	b7c5                	j	80001d46 <devintr+0x5e>
    if(cpuid() == 0){
    80001d68:	fffff097          	auipc	ra,0xfffff
    80001d6c:	20c080e7          	jalr	524(ra) # 80000f74 <cpuid>
    80001d70:	c901                	beqz	a0,80001d80 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d72:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d78:	14479073          	csrw	sip,a5
    return 2;
    80001d7c:	4509                	li	a0,2
    80001d7e:	b761                	j	80001d06 <devintr+0x1e>
      clockintr();
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	f22080e7          	jalr	-222(ra) # 80001ca2 <clockintr>
    80001d88:	b7ed                	j	80001d72 <devintr+0x8a>

0000000080001d8a <usertrap>:
{
    80001d8a:	1101                	addi	sp,sp,-32
    80001d8c:	ec06                	sd	ra,24(sp)
    80001d8e:	e822                	sd	s0,16(sp)
    80001d90:	e426                	sd	s1,8(sp)
    80001d92:	e04a                	sd	s2,0(sp)
    80001d94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d9a:	1007f793          	andi	a5,a5,256
    80001d9e:	e3ad                	bnez	a5,80001e00 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001da0:	00003797          	auipc	a5,0x3
    80001da4:	3c078793          	addi	a5,a5,960 # 80005160 <kernelvec>
    80001da8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	1f4080e7          	jalr	500(ra) # 80000fa0 <myproc>
    80001db4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001db6:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db8:	14102773          	csrr	a4,sepc
    80001dbc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dc2:	47a1                	li	a5,8
    80001dc4:	04f71c63          	bne	a4,a5,80001e1c <usertrap+0x92>
    if(p->killed)
    80001dc8:	591c                	lw	a5,48(a0)
    80001dca:	e3b9                	bnez	a5,80001e10 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001dcc:	70b8                	ld	a4,96(s1)
    80001dce:	6f1c                	ld	a5,24(a4)
    80001dd0:	0791                	addi	a5,a5,4
    80001dd2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dd8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ddc:	10079073          	csrw	sstatus,a5
    syscall();
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	2e0080e7          	jalr	736(ra) # 800020c0 <syscall>
  if(p->killed)
    80001de8:	589c                	lw	a5,48(s1)
    80001dea:	ebc1                	bnez	a5,80001e7a <usertrap+0xf0>
  usertrapret();
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	e18080e7          	jalr	-488(ra) # 80001c04 <usertrapret>
}
    80001df4:	60e2                	ld	ra,24(sp)
    80001df6:	6442                	ld	s0,16(sp)
    80001df8:	64a2                	ld	s1,8(sp)
    80001dfa:	6902                	ld	s2,0(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret
    panic("usertrap: not from user mode");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	49850513          	addi	a0,a0,1176 # 80008298 <states.1725+0x58>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	284080e7          	jalr	644(ra) # 8000608c <panic>
      exit(-1);
    80001e10:	557d                	li	a0,-1
    80001e12:	00000097          	auipc	ra,0x0
    80001e16:	aa6080e7          	jalr	-1370(ra) # 800018b8 <exit>
    80001e1a:	bf4d                	j	80001dcc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e1c:	00000097          	auipc	ra,0x0
    80001e20:	ecc080e7          	jalr	-308(ra) # 80001ce8 <devintr>
    80001e24:	892a                	mv	s2,a0
    80001e26:	c501                	beqz	a0,80001e2e <usertrap+0xa4>
  if(p->killed)
    80001e28:	589c                	lw	a5,48(s1)
    80001e2a:	c3a1                	beqz	a5,80001e6a <usertrap+0xe0>
    80001e2c:	a815                	j	80001e60 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e32:	5c90                	lw	a2,56(s1)
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	48450513          	addi	a0,a0,1156 # 800082b8 <states.1725+0x78>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	29a080e7          	jalr	666(ra) # 800060d6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e44:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e48:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	49c50513          	addi	a0,a0,1180 # 800082e8 <states.1725+0xa8>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	282080e7          	jalr	642(ra) # 800060d6 <printf>
    p->killed = 1;
    80001e5c:	4785                	li	a5,1
    80001e5e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e60:	557d                	li	a0,-1
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	a56080e7          	jalr	-1450(ra) # 800018b8 <exit>
  if(which_dev == 2)
    80001e6a:	4789                	li	a5,2
    80001e6c:	f8f910e3          	bne	s2,a5,80001dec <usertrap+0x62>
    yield();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	7b0080e7          	jalr	1968(ra) # 80001620 <yield>
    80001e78:	bf95                	j	80001dec <usertrap+0x62>
  int which_dev = 0;
    80001e7a:	4901                	li	s2,0
    80001e7c:	b7d5                	j	80001e60 <usertrap+0xd6>

0000000080001e7e <kerneltrap>:
{
    80001e7e:	7179                	addi	sp,sp,-48
    80001e80:	f406                	sd	ra,40(sp)
    80001e82:	f022                	sd	s0,32(sp)
    80001e84:	ec26                	sd	s1,24(sp)
    80001e86:	e84a                	sd	s2,16(sp)
    80001e88:	e44e                	sd	s3,8(sp)
    80001e8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e94:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e98:	1004f793          	andi	a5,s1,256
    80001e9c:	cb85                	beqz	a5,80001ecc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ea2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ea4:	ef85                	bnez	a5,80001edc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	e42080e7          	jalr	-446(ra) # 80001ce8 <devintr>
    80001eae:	cd1d                	beqz	a0,80001eec <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eb0:	4789                	li	a5,2
    80001eb2:	06f50a63          	beq	a0,a5,80001f26 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eb6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eba:	10049073          	csrw	sstatus,s1
}
    80001ebe:	70a2                	ld	ra,40(sp)
    80001ec0:	7402                	ld	s0,32(sp)
    80001ec2:	64e2                	ld	s1,24(sp)
    80001ec4:	6942                	ld	s2,16(sp)
    80001ec6:	69a2                	ld	s3,8(sp)
    80001ec8:	6145                	addi	sp,sp,48
    80001eca:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ecc:	00006517          	auipc	a0,0x6
    80001ed0:	43c50513          	addi	a0,a0,1084 # 80008308 <states.1725+0xc8>
    80001ed4:	00004097          	auipc	ra,0x4
    80001ed8:	1b8080e7          	jalr	440(ra) # 8000608c <panic>
    panic("kerneltrap: interrupts enabled");
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	45450513          	addi	a0,a0,1108 # 80008330 <states.1725+0xf0>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	1a8080e7          	jalr	424(ra) # 8000608c <panic>
    printf("scause %p\n", scause);
    80001eec:	85ce                	mv	a1,s3
    80001eee:	00006517          	auipc	a0,0x6
    80001ef2:	46250513          	addi	a0,a0,1122 # 80008350 <states.1725+0x110>
    80001ef6:	00004097          	auipc	ra,0x4
    80001efa:	1e0080e7          	jalr	480(ra) # 800060d6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001efe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f02:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f06:	00006517          	auipc	a0,0x6
    80001f0a:	45a50513          	addi	a0,a0,1114 # 80008360 <states.1725+0x120>
    80001f0e:	00004097          	auipc	ra,0x4
    80001f12:	1c8080e7          	jalr	456(ra) # 800060d6 <printf>
    panic("kerneltrap");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	46250513          	addi	a0,a0,1122 # 80008378 <states.1725+0x138>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	16e080e7          	jalr	366(ra) # 8000608c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	07a080e7          	jalr	122(ra) # 80000fa0 <myproc>
    80001f2e:	d541                	beqz	a0,80001eb6 <kerneltrap+0x38>
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	070080e7          	jalr	112(ra) # 80000fa0 <myproc>
    80001f38:	5118                	lw	a4,32(a0)
    80001f3a:	4791                	li	a5,4
    80001f3c:	f6f71de3          	bne	a4,a5,80001eb6 <kerneltrap+0x38>
    yield();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	6e0080e7          	jalr	1760(ra) # 80001620 <yield>
    80001f48:	b7bd                	j	80001eb6 <kerneltrap+0x38>

0000000080001f4a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f4a:	1101                	addi	sp,sp,-32
    80001f4c:	ec06                	sd	ra,24(sp)
    80001f4e:	e822                	sd	s0,16(sp)
    80001f50:	e426                	sd	s1,8(sp)
    80001f52:	1000                	addi	s0,sp,32
    80001f54:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	04a080e7          	jalr	74(ra) # 80000fa0 <myproc>
  switch (n) {
    80001f5e:	4795                	li	a5,5
    80001f60:	0497e163          	bltu	a5,s1,80001fa2 <argraw+0x58>
    80001f64:	048a                	slli	s1,s1,0x2
    80001f66:	00006717          	auipc	a4,0x6
    80001f6a:	44a70713          	addi	a4,a4,1098 # 800083b0 <states.1725+0x170>
    80001f6e:	94ba                	add	s1,s1,a4
    80001f70:	409c                	lw	a5,0(s1)
    80001f72:	97ba                	add	a5,a5,a4
    80001f74:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f76:	713c                	ld	a5,96(a0)
    80001f78:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f7a:	60e2                	ld	ra,24(sp)
    80001f7c:	6442                	ld	s0,16(sp)
    80001f7e:	64a2                	ld	s1,8(sp)
    80001f80:	6105                	addi	sp,sp,32
    80001f82:	8082                	ret
    return p->trapframe->a1;
    80001f84:	713c                	ld	a5,96(a0)
    80001f86:	7fa8                	ld	a0,120(a5)
    80001f88:	bfcd                	j	80001f7a <argraw+0x30>
    return p->trapframe->a2;
    80001f8a:	713c                	ld	a5,96(a0)
    80001f8c:	63c8                	ld	a0,128(a5)
    80001f8e:	b7f5                	j	80001f7a <argraw+0x30>
    return p->trapframe->a3;
    80001f90:	713c                	ld	a5,96(a0)
    80001f92:	67c8                	ld	a0,136(a5)
    80001f94:	b7dd                	j	80001f7a <argraw+0x30>
    return p->trapframe->a4;
    80001f96:	713c                	ld	a5,96(a0)
    80001f98:	6bc8                	ld	a0,144(a5)
    80001f9a:	b7c5                	j	80001f7a <argraw+0x30>
    return p->trapframe->a5;
    80001f9c:	713c                	ld	a5,96(a0)
    80001f9e:	6fc8                	ld	a0,152(a5)
    80001fa0:	bfe9                	j	80001f7a <argraw+0x30>
  panic("argraw");
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	3e650513          	addi	a0,a0,998 # 80008388 <states.1725+0x148>
    80001faa:	00004097          	auipc	ra,0x4
    80001fae:	0e2080e7          	jalr	226(ra) # 8000608c <panic>

0000000080001fb2 <fetchaddr>:
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	e04a                	sd	s2,0(sp)
    80001fbc:	1000                	addi	s0,sp,32
    80001fbe:	84aa                	mv	s1,a0
    80001fc0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	fde080e7          	jalr	-34(ra) # 80000fa0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fca:	693c                	ld	a5,80(a0)
    80001fcc:	02f4f863          	bgeu	s1,a5,80001ffc <fetchaddr+0x4a>
    80001fd0:	00848713          	addi	a4,s1,8
    80001fd4:	02e7e663          	bltu	a5,a4,80002000 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fd8:	46a1                	li	a3,8
    80001fda:	8626                	mv	a2,s1
    80001fdc:	85ca                	mv	a1,s2
    80001fde:	6d28                	ld	a0,88(a0)
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	d0e080e7          	jalr	-754(ra) # 80000cee <copyin>
    80001fe8:	00a03533          	snez	a0,a0
    80001fec:	40a00533          	neg	a0,a0
}
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6902                	ld	s2,0(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret
    return -1;
    80001ffc:	557d                	li	a0,-1
    80001ffe:	bfcd                	j	80001ff0 <fetchaddr+0x3e>
    80002000:	557d                	li	a0,-1
    80002002:	b7fd                	j	80001ff0 <fetchaddr+0x3e>

0000000080002004 <fetchstr>:
{
    80002004:	7179                	addi	sp,sp,-48
    80002006:	f406                	sd	ra,40(sp)
    80002008:	f022                	sd	s0,32(sp)
    8000200a:	ec26                	sd	s1,24(sp)
    8000200c:	e84a                	sd	s2,16(sp)
    8000200e:	e44e                	sd	s3,8(sp)
    80002010:	1800                	addi	s0,sp,48
    80002012:	892a                	mv	s2,a0
    80002014:	84ae                	mv	s1,a1
    80002016:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	f88080e7          	jalr	-120(ra) # 80000fa0 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002020:	86ce                	mv	a3,s3
    80002022:	864a                	mv	a2,s2
    80002024:	85a6                	mv	a1,s1
    80002026:	6d28                	ld	a0,88(a0)
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	d52080e7          	jalr	-686(ra) # 80000d7a <copyinstr>
  if(err < 0)
    80002030:	00054763          	bltz	a0,8000203e <fetchstr+0x3a>
  return strlen(buf);
    80002034:	8526                	mv	a0,s1
    80002036:	ffffe097          	auipc	ra,0xffffe
    8000203a:	40e080e7          	jalr	1038(ra) # 80000444 <strlen>
}
    8000203e:	70a2                	ld	ra,40(sp)
    80002040:	7402                	ld	s0,32(sp)
    80002042:	64e2                	ld	s1,24(sp)
    80002044:	6942                	ld	s2,16(sp)
    80002046:	69a2                	ld	s3,8(sp)
    80002048:	6145                	addi	sp,sp,48
    8000204a:	8082                	ret

000000008000204c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000204c:	1101                	addi	sp,sp,-32
    8000204e:	ec06                	sd	ra,24(sp)
    80002050:	e822                	sd	s0,16(sp)
    80002052:	e426                	sd	s1,8(sp)
    80002054:	1000                	addi	s0,sp,32
    80002056:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	ef2080e7          	jalr	-270(ra) # 80001f4a <argraw>
    80002060:	c088                	sw	a0,0(s1)
  return 0;
}
    80002062:	4501                	li	a0,0
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6105                	addi	sp,sp,32
    8000206c:	8082                	ret

000000008000206e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000206e:	1101                	addi	sp,sp,-32
    80002070:	ec06                	sd	ra,24(sp)
    80002072:	e822                	sd	s0,16(sp)
    80002074:	e426                	sd	s1,8(sp)
    80002076:	1000                	addi	s0,sp,32
    80002078:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	ed0080e7          	jalr	-304(ra) # 80001f4a <argraw>
    80002082:	e088                	sd	a0,0(s1)
  return 0;
}
    80002084:	4501                	li	a0,0
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	64a2                	ld	s1,8(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret

0000000080002090 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002090:	1101                	addi	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	e426                	sd	s1,8(sp)
    80002098:	e04a                	sd	s2,0(sp)
    8000209a:	1000                	addi	s0,sp,32
    8000209c:	84ae                	mv	s1,a1
    8000209e:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020a0:	00000097          	auipc	ra,0x0
    800020a4:	eaa080e7          	jalr	-342(ra) # 80001f4a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020a8:	864a                	mv	a2,s2
    800020aa:	85a6                	mv	a1,s1
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	f58080e7          	jalr	-168(ra) # 80002004 <fetchstr>
}
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6902                	ld	s2,0(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret

00000000800020c0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	e04a                	sd	s2,0(sp)
    800020ca:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	ed4080e7          	jalr	-300(ra) # 80000fa0 <myproc>
    800020d4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d6:	06053903          	ld	s2,96(a0)
    800020da:	0a893783          	ld	a5,168(s2)
    800020de:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020e2:	37fd                	addiw	a5,a5,-1
    800020e4:	4751                	li	a4,20
    800020e6:	00f76f63          	bltu	a4,a5,80002104 <syscall+0x44>
    800020ea:	00369713          	slli	a4,a3,0x3
    800020ee:	00006797          	auipc	a5,0x6
    800020f2:	2da78793          	addi	a5,a5,730 # 800083c8 <syscalls>
    800020f6:	97ba                	add	a5,a5,a4
    800020f8:	639c                	ld	a5,0(a5)
    800020fa:	c789                	beqz	a5,80002104 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020fc:	9782                	jalr	a5
    800020fe:	06a93823          	sd	a0,112(s2)
    80002102:	a839                	j	80002120 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002104:	16048613          	addi	a2,s1,352
    80002108:	5c8c                	lw	a1,56(s1)
    8000210a:	00006517          	auipc	a0,0x6
    8000210e:	28650513          	addi	a0,a0,646 # 80008390 <states.1725+0x150>
    80002112:	00004097          	auipc	ra,0x4
    80002116:	fc4080e7          	jalr	-60(ra) # 800060d6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000211a:	70bc                	ld	a5,96(s1)
    8000211c:	577d                	li	a4,-1
    8000211e:	fbb8                	sd	a4,112(a5)
  }
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	64a2                	ld	s1,8(sp)
    80002126:	6902                	ld	s2,0(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002134:	fec40593          	addi	a1,s0,-20
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	f12080e7          	jalr	-238(ra) # 8000204c <argint>
    return -1;
    80002142:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002144:	00054963          	bltz	a0,80002156 <sys_exit+0x2a>
  exit(n);
    80002148:	fec42503          	lw	a0,-20(s0)
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	76c080e7          	jalr	1900(ra) # 800018b8 <exit>
  return 0;  // not reached
    80002154:	4781                	li	a5,0
}
    80002156:	853e                	mv	a0,a5
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret

0000000080002160 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002160:	1141                	addi	sp,sp,-16
    80002162:	e406                	sd	ra,8(sp)
    80002164:	e022                	sd	s0,0(sp)
    80002166:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	e38080e7          	jalr	-456(ra) # 80000fa0 <myproc>
}
    80002170:	5d08                	lw	a0,56(a0)
    80002172:	60a2                	ld	ra,8(sp)
    80002174:	6402                	ld	s0,0(sp)
    80002176:	0141                	addi	sp,sp,16
    80002178:	8082                	ret

000000008000217a <sys_fork>:

uint64
sys_fork(void)
{
    8000217a:	1141                	addi	sp,sp,-16
    8000217c:	e406                	sd	ra,8(sp)
    8000217e:	e022                	sd	s0,0(sp)
    80002180:	0800                	addi	s0,sp,16
  return fork();
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	1ec080e7          	jalr	492(ra) # 8000136e <fork>
}
    8000218a:	60a2                	ld	ra,8(sp)
    8000218c:	6402                	ld	s0,0(sp)
    8000218e:	0141                	addi	sp,sp,16
    80002190:	8082                	ret

0000000080002192 <sys_wait>:

uint64
sys_wait(void)
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000219a:	fe840593          	addi	a1,s0,-24
    8000219e:	4501                	li	a0,0
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	ece080e7          	jalr	-306(ra) # 8000206e <argaddr>
    800021a8:	87aa                	mv	a5,a0
    return -1;
    800021aa:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ac:	0007c863          	bltz	a5,800021bc <sys_wait+0x2a>
  return wait(p);
    800021b0:	fe843503          	ld	a0,-24(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	50c080e7          	jalr	1292(ra) # 800016c0 <wait>
}
    800021bc:	60e2                	ld	ra,24(sp)
    800021be:	6442                	ld	s0,16(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021c4:	7179                	addi	sp,sp,-48
    800021c6:	f406                	sd	ra,40(sp)
    800021c8:	f022                	sd	s0,32(sp)
    800021ca:	ec26                	sd	s1,24(sp)
    800021cc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021ce:	fdc40593          	addi	a1,s0,-36
    800021d2:	4501                	li	a0,0
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	e78080e7          	jalr	-392(ra) # 8000204c <argint>
    800021dc:	87aa                	mv	a5,a0
    return -1;
    800021de:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021e0:	0207c063          	bltz	a5,80002200 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	dbc080e7          	jalr	-580(ra) # 80000fa0 <myproc>
    800021ec:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021ee:	fdc42503          	lw	a0,-36(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	108080e7          	jalr	264(ra) # 800012fa <growproc>
    800021fa:	00054863          	bltz	a0,8000220a <sys_sbrk+0x46>
    return -1;
  return addr;
    800021fe:	8526                	mv	a0,s1
}
    80002200:	70a2                	ld	ra,40(sp)
    80002202:	7402                	ld	s0,32(sp)
    80002204:	64e2                	ld	s1,24(sp)
    80002206:	6145                	addi	sp,sp,48
    80002208:	8082                	ret
    return -1;
    8000220a:	557d                	li	a0,-1
    8000220c:	bfd5                	j	80002200 <sys_sbrk+0x3c>

000000008000220e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220e:	7139                	addi	sp,sp,-64
    80002210:	fc06                	sd	ra,56(sp)
    80002212:	f822                	sd	s0,48(sp)
    80002214:	f426                	sd	s1,40(sp)
    80002216:	f04a                	sd	s2,32(sp)
    80002218:	ec4e                	sd	s3,24(sp)
    8000221a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000221c:	fcc40593          	addi	a1,s0,-52
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	e2a080e7          	jalr	-470(ra) # 8000204c <argint>
    return -1;
    8000222a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000222c:	06054563          	bltz	a0,80002296 <sys_sleep+0x88>
  acquire(&tickslock);
    80002230:	0000d517          	auipc	a0,0xd
    80002234:	fc050513          	addi	a0,a0,-64 # 8000f1f0 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	388080e7          	jalr	904(ra) # 800065c0 <acquire>
  ticks0 = ticks;
    80002240:	00007917          	auipc	s2,0x7
    80002244:	dd892903          	lw	s2,-552(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002248:	fcc42783          	lw	a5,-52(s0)
    8000224c:	cf85                	beqz	a5,80002284 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224e:	0000d997          	auipc	s3,0xd
    80002252:	fa298993          	addi	s3,s3,-94 # 8000f1f0 <tickslock>
    80002256:	00007497          	auipc	s1,0x7
    8000225a:	dc248493          	addi	s1,s1,-574 # 80009018 <ticks>
    if(myproc()->killed){
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	d42080e7          	jalr	-702(ra) # 80000fa0 <myproc>
    80002266:	591c                	lw	a5,48(a0)
    80002268:	ef9d                	bnez	a5,800022a6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000226a:	85ce                	mv	a1,s3
    8000226c:	8526                	mv	a0,s1
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	3ee080e7          	jalr	1006(ra) # 8000165c <sleep>
  while(ticks - ticks0 < n){
    80002276:	409c                	lw	a5,0(s1)
    80002278:	412787bb          	subw	a5,a5,s2
    8000227c:	fcc42703          	lw	a4,-52(s0)
    80002280:	fce7efe3          	bltu	a5,a4,8000225e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	f6c50513          	addi	a0,a0,-148 # 8000f1f0 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	404080e7          	jalr	1028(ra) # 80006690 <release>
  return 0;
    80002294:	4781                	li	a5,0
}
    80002296:	853e                	mv	a0,a5
    80002298:	70e2                	ld	ra,56(sp)
    8000229a:	7442                	ld	s0,48(sp)
    8000229c:	74a2                	ld	s1,40(sp)
    8000229e:	7902                	ld	s2,32(sp)
    800022a0:	69e2                	ld	s3,24(sp)
    800022a2:	6121                	addi	sp,sp,64
    800022a4:	8082                	ret
      release(&tickslock);
    800022a6:	0000d517          	auipc	a0,0xd
    800022aa:	f4a50513          	addi	a0,a0,-182 # 8000f1f0 <tickslock>
    800022ae:	00004097          	auipc	ra,0x4
    800022b2:	3e2080e7          	jalr	994(ra) # 80006690 <release>
      return -1;
    800022b6:	57fd                	li	a5,-1
    800022b8:	bff9                	j	80002296 <sys_sleep+0x88>

00000000800022ba <sys_kill>:

uint64
sys_kill(void)
{
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022c2:	fec40593          	addi	a1,s0,-20
    800022c6:	4501                	li	a0,0
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	d84080e7          	jalr	-636(ra) # 8000204c <argint>
    800022d0:	87aa                	mv	a5,a0
    return -1;
    800022d2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022d4:	0007c863          	bltz	a5,800022e4 <sys_kill+0x2a>
  return kill(pid);
    800022d8:	fec42503          	lw	a0,-20(s0)
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	6b2080e7          	jalr	1714(ra) # 8000198e <kill>
}
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ec:	1101                	addi	sp,sp,-32
    800022ee:	ec06                	sd	ra,24(sp)
    800022f0:	e822                	sd	s0,16(sp)
    800022f2:	e426                	sd	s1,8(sp)
    800022f4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022f6:	0000d517          	auipc	a0,0xd
    800022fa:	efa50513          	addi	a0,a0,-262 # 8000f1f0 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	2c2080e7          	jalr	706(ra) # 800065c0 <acquire>
  xticks = ticks;
    80002306:	00007497          	auipc	s1,0x7
    8000230a:	d124a483          	lw	s1,-750(s1) # 80009018 <ticks>
  release(&tickslock);
    8000230e:	0000d517          	auipc	a0,0xd
    80002312:	ee250513          	addi	a0,a0,-286 # 8000f1f0 <tickslock>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	37a080e7          	jalr	890(ra) # 80006690 <release>
  return xticks;
}
    8000231e:	02049513          	slli	a0,s1,0x20
    80002322:	9101                	srli	a0,a0,0x20
    80002324:	60e2                	ld	ra,24(sp)
    80002326:	6442                	ld	s0,16(sp)
    80002328:	64a2                	ld	s1,8(sp)
    8000232a:	6105                	addi	sp,sp,32
    8000232c:	8082                	ret

000000008000232e <binit>:
  b->head.next = &b->head;
}

void
binit(void)
{
    8000232e:	7179                	addi	sp,sp,-48
    80002330:	f406                	sd	ra,40(sp)
    80002332:	f022                	sd	s0,32(sp)
    80002334:	ec26                	sd	s1,24(sp)
    80002336:	e84a                	sd	s2,16(sp)
    80002338:	e44e                	sd	s3,8(sp)
    8000233a:	1800                	addi	s0,sp,48
  for (int i = 0; i < NBUF; ++i) {
    8000233c:	0000d497          	auipc	s1,0xd
    80002340:	eec48493          	addi	s1,s1,-276 # 8000f228 <bcache+0x18>
    80002344:	00015997          	auipc	s3,0x15
    80002348:	31498993          	addi	s3,s3,788 # 80017658 <bcache+0x8448>
    initsleeplock(&bcache.buf[i].lock, "buffer");
    8000234c:	00006917          	auipc	s2,0x6
    80002350:	12c90913          	addi	s2,s2,300 # 80008478 <syscalls+0xb0>
    80002354:	85ca                	mv	a1,s2
    80002356:	8526                	mv	a0,s1
    80002358:	00001097          	auipc	ra,0x1
    8000235c:	5ce080e7          	jalr	1486(ra) # 80003926 <initsleeplock>
  for (int i = 0; i < NBUF; ++i) {
    80002360:	46848493          	addi	s1,s1,1128
    80002364:	ff3498e3          	bne	s1,s3,80002354 <binit+0x26>
    80002368:	00015497          	auipc	s1,0x15
    8000236c:	2d848493          	addi	s1,s1,728 # 80017640 <bcache+0x8430>
    80002370:	0000d917          	auipc	s2,0xd
    80002374:	ea090913          	addi	s2,s2,-352 # 8000f210 <bcache>
    80002378:	67b1                	lui	a5,0xc
    8000237a:	f1878793          	addi	a5,a5,-232 # bf18 <_entry-0x7fff40e8>
    8000237e:	993e                	add	s2,s2,a5
  initlock(&b->lock, "bcache.bucket");
    80002380:	00006997          	auipc	s3,0x6
    80002384:	10098993          	addi	s3,s3,256 # 80008480 <syscalls+0xb8>
    80002388:	85ce                	mv	a1,s3
    8000238a:	8526                	mv	a0,s1
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	3b0080e7          	jalr	944(ra) # 8000673c <initlock>
  b->head.prev = &b->head;
    80002394:	02048793          	addi	a5,s1,32
    80002398:	fcbc                	sd	a5,120(s1)
  b->head.next = &b->head;
    8000239a:	e0dc                	sd	a5,128(s1)
  }
  for (int i = 0; i < NBUCKET; ++i) {
    8000239c:	48848493          	addi	s1,s1,1160
    800023a0:	ff2494e3          	bne	s1,s2,80002388 <binit+0x5a>
    initbucket(&bcache.bucket[i]);
  }
}
    800023a4:	70a2                	ld	ra,40(sp)
    800023a6:	7402                	ld	s0,32(sp)
    800023a8:	64e2                	ld	s1,24(sp)
    800023aa:	6942                	ld	s2,16(sp)
    800023ac:	69a2                	ld	s3,8(sp)
    800023ae:	6145                	addi	sp,sp,48
    800023b0:	8082                	ret

00000000800023b2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023b2:	715d                	addi	sp,sp,-80
    800023b4:	e486                	sd	ra,72(sp)
    800023b6:	e0a2                	sd	s0,64(sp)
    800023b8:	fc26                	sd	s1,56(sp)
    800023ba:	f84a                	sd	s2,48(sp)
    800023bc:	f44e                	sd	s3,40(sp)
    800023be:	f052                	sd	s4,32(sp)
    800023c0:	ec56                	sd	s5,24(sp)
    800023c2:	e85a                	sd	s6,16(sp)
    800023c4:	e45e                	sd	s7,8(sp)
    800023c6:	e062                	sd	s8,0(sp)
    800023c8:	0880                	addi	s0,sp,80
    800023ca:	8baa                	mv	s7,a0
    800023cc:	8b2e                	mv	s6,a1
  return key % NBUCKET;
    800023ce:	4ab5                	li	s5,13
    800023d0:	0355fabb          	remuw	s5,a1,s5
  acquire(&bucket->lock);
    800023d4:	020a9493          	slli	s1,s5,0x20
    800023d8:	9081                	srli	s1,s1,0x20
    800023da:	48800793          	li	a5,1160
    800023de:	02f484b3          	mul	s1,s1,a5
    800023e2:	6a21                	lui	s4,0x8
    800023e4:	430a0993          	addi	s3,s4,1072 # 8430 <_entry-0x7fff7bd0>
    800023e8:	99a6                	add	s3,s3,s1
    800023ea:	0000dc17          	auipc	s8,0xd
    800023ee:	e26c0c13          	addi	s8,s8,-474 # 8000f210 <bcache>
    800023f2:	99e2                	add	s3,s3,s8
    800023f4:	854e                	mv	a0,s3
    800023f6:	00004097          	auipc	ra,0x4
    800023fa:	1ca080e7          	jalr	458(ra) # 800065c0 <acquire>
  for (struct buf *buf = bucket->head.next; buf != &bucket->head;
    800023fe:	009c07b3          	add	a5,s8,s1
    80002402:	97d2                	add	a5,a5,s4
    80002404:	4b07b903          	ld	s2,1200(a5)
    80002408:	450a0a13          	addi	s4,s4,1104
    8000240c:	94d2                	add	s1,s1,s4
    8000240e:	94e2                	add	s1,s1,s8
    80002410:	00991e63          	bne	s2,s1,8000242c <bread+0x7a>
  for (int i = 0; i < NBUF; ++i) {
    80002414:	0000d797          	auipc	a5,0xd
    80002418:	dfc78793          	addi	a5,a5,-516 # 8000f210 <bcache>
    8000241c:	4501                	li	a0,0
        !__atomic_test_and_set(&bcache.buf[i].used, __ATOMIC_ACQUIRE)) {
    8000241e:	4885                	li	a7,1
  for (int i = 0; i < NBUF; ++i) {
    80002420:	4879                	li	a6,30
    80002422:	a099                	j	80002468 <bread+0xb6>
       buf = buf->next) {
    80002424:	06093903          	ld	s2,96(s2)
  for (struct buf *buf = bucket->head.next; buf != &bucket->head;
    80002428:	fe9906e3          	beq	s2,s1,80002414 <bread+0x62>
    if(buf->dev == dev && buf->blockno == blockno){
    8000242c:	00c92783          	lw	a5,12(s2)
    80002430:	ff779ae3          	bne	a5,s7,80002424 <bread+0x72>
    80002434:	01092783          	lw	a5,16(s2)
    80002438:	ff6796e3          	bne	a5,s6,80002424 <bread+0x72>
      buf->refcnt++;
    8000243c:	05092783          	lw	a5,80(s2)
    80002440:	2785                	addiw	a5,a5,1
    80002442:	04f92823          	sw	a5,80(s2)
      release(&bucket->lock);
    80002446:	854e                	mv	a0,s3
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	248080e7          	jalr	584(ra) # 80006690 <release>
      acquiresleep(&buf->lock);
    80002450:	01890513          	addi	a0,s2,24
    80002454:	00001097          	auipc	ra,0x1
    80002458:	50c080e7          	jalr	1292(ra) # 80003960 <acquiresleep>
      return buf;
    8000245c:	a849                	j	800024ee <bread+0x13c>
  for (int i = 0; i < NBUF; ++i) {
    8000245e:	2505                	addiw	a0,a0,1
    80002460:	46878793          	addi	a5,a5,1128
    80002464:	0b050563          	beq	a0,a6,8000250e <bread+0x15c>
    if (!bcache.buf[i].used &&
    80002468:	893e                	mv	s2,a5
    8000246a:	0007c703          	lbu	a4,0(a5)
    8000246e:	fb65                	bnez	a4,8000245e <bread+0xac>
        !__atomic_test_and_set(&bcache.buf[i].used, __ATOMIC_ACQUIRE)) {
    80002470:	ffc7f693          	andi	a3,a5,-4
    80002474:	0037f713          	andi	a4,a5,3
    80002478:	0037161b          	slliw	a2,a4,0x3
    8000247c:	00c895bb          	sllw	a1,a7,a2
    80002480:	44b6a72f          	amoor.w.aq	a4,a1,(a3)
    80002484:	00c7573b          	srlw	a4,a4,a2
    80002488:	0ff77713          	andi	a4,a4,255
    if (!bcache.buf[i].used &&
    8000248c:	fb69                	bnez	a4,8000245e <bread+0xac>
      buf->dev = dev;
    8000248e:	0000dc17          	auipc	s8,0xd
    80002492:	d82c0c13          	addi	s8,s8,-638 # 8000f210 <bcache>
    80002496:	46800a13          	li	s4,1128
    8000249a:	03450a33          	mul	s4,a0,s4
    8000249e:	014c07b3          	add	a5,s8,s4
    800024a2:	0177a623          	sw	s7,12(a5)
      buf->blockno = blockno;
    800024a6:	0167a823          	sw	s6,16(a5)
      buf->valid = 0;
    800024aa:	0007a223          	sw	zero,4(a5)
      buf->refcnt = 1;
    800024ae:	4705                	li	a4,1
    800024b0:	cbb8                	sw	a4,80(a5)
      buf->next = bucket->head.next;
    800024b2:	1a82                	slli	s5,s5,0x20
    800024b4:	020ada93          	srli	s5,s5,0x20
    800024b8:	48800713          	li	a4,1160
    800024bc:	02ea8ab3          	mul	s5,s5,a4
    800024c0:	9ae2                	add	s5,s5,s8
    800024c2:	6721                	lui	a4,0x8
    800024c4:	9aba                	add	s5,s5,a4
    800024c6:	4b0ab703          	ld	a4,1200(s5)
    800024ca:	f3b8                	sd	a4,96(a5)
      buf->prev = &bucket->head;
    800024cc:	efa4                	sd	s1,88(a5)
      bucket->head.next->prev = buf;
    800024ce:	05273c23          	sd	s2,88(a4) # 8058 <_entry-0x7fff7fa8>
      bucket->head.next = buf;
    800024d2:	4b2ab823          	sd	s2,1200(s5)
      release(&bucket->lock);
    800024d6:	854e                	mv	a0,s3
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	1b8080e7          	jalr	440(ra) # 80006690 <release>
      acquiresleep(&buf->lock);
    800024e0:	018a0513          	addi	a0,s4,24
    800024e4:	9562                	add	a0,a0,s8
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	47a080e7          	jalr	1146(ra) # 80003960 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ee:	00492783          	lw	a5,4(s2)
    800024f2:	c795                	beqz	a5,8000251e <bread+0x16c>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024f4:	854a                	mv	a0,s2
    800024f6:	60a6                	ld	ra,72(sp)
    800024f8:	6406                	ld	s0,64(sp)
    800024fa:	74e2                	ld	s1,56(sp)
    800024fc:	7942                	ld	s2,48(sp)
    800024fe:	79a2                	ld	s3,40(sp)
    80002500:	7a02                	ld	s4,32(sp)
    80002502:	6ae2                	ld	s5,24(sp)
    80002504:	6b42                	ld	s6,16(sp)
    80002506:	6ba2                	ld	s7,8(sp)
    80002508:	6c02                	ld	s8,0(sp)
    8000250a:	6161                	addi	sp,sp,80
    8000250c:	8082                	ret
  panic("bget: no buffers");
    8000250e:	00006517          	auipc	a0,0x6
    80002512:	f8250513          	addi	a0,a0,-126 # 80008490 <syscalls+0xc8>
    80002516:	00004097          	auipc	ra,0x4
    8000251a:	b76080e7          	jalr	-1162(ra) # 8000608c <panic>
    virtio_disk_rw(b, 0);
    8000251e:	4581                	li	a1,0
    80002520:	854a                	mv	a0,s2
    80002522:	00003097          	auipc	ra,0x3
    80002526:	f74080e7          	jalr	-140(ra) # 80005496 <virtio_disk_rw>
    b->valid = 1;
    8000252a:	4785                	li	a5,1
    8000252c:	00f92223          	sw	a5,4(s2)
  return b;
    80002530:	b7d1                	j	800024f4 <bread+0x142>

0000000080002532 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002532:	1101                	addi	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	e426                	sd	s1,8(sp)
    8000253a:	1000                	addi	s0,sp,32
    8000253c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000253e:	0561                	addi	a0,a0,24
    80002540:	00001097          	auipc	ra,0x1
    80002544:	4ba080e7          	jalr	1210(ra) # 800039fa <holdingsleep>
    80002548:	cd01                	beqz	a0,80002560 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000254a:	4585                	li	a1,1
    8000254c:	8526                	mv	a0,s1
    8000254e:	00003097          	auipc	ra,0x3
    80002552:	f48080e7          	jalr	-184(ra) # 80005496 <virtio_disk_rw>
}
    80002556:	60e2                	ld	ra,24(sp)
    80002558:	6442                	ld	s0,16(sp)
    8000255a:	64a2                	ld	s1,8(sp)
    8000255c:	6105                	addi	sp,sp,32
    8000255e:	8082                	ret
    panic("bwrite");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	f4850513          	addi	a0,a0,-184 # 800084a8 <syscalls+0xe0>
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	b24080e7          	jalr	-1244(ra) # 8000608c <panic>

0000000080002570 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002570:	1101                	addi	sp,sp,-32
    80002572:	ec06                	sd	ra,24(sp)
    80002574:	e822                	sd	s0,16(sp)
    80002576:	e426                	sd	s1,8(sp)
    80002578:	e04a                	sd	s2,0(sp)
    8000257a:	1000                	addi	s0,sp,32
    8000257c:	892a                	mv	s2,a0
  if(!holdingsleep(&b->lock))
    8000257e:	01850493          	addi	s1,a0,24
    80002582:	8526                	mv	a0,s1
    80002584:	00001097          	auipc	ra,0x1
    80002588:	476080e7          	jalr	1142(ra) # 800039fa <holdingsleep>
    8000258c:	c135                	beqz	a0,800025f0 <brelse+0x80>
    panic("brelse");

  releasesleep(&b->lock);
    8000258e:	8526                	mv	a0,s1
    80002590:	00001097          	auipc	ra,0x1
    80002594:	426080e7          	jalr	1062(ra) # 800039b6 <releasesleep>
  return key % NBUCKET;
    80002598:	01092483          	lw	s1,16(s2)
    8000259c:	47b5                	li	a5,13
    8000259e:	02f4f4bb          	remuw	s1,s1,a5

  uint v = hash_v(b->blockno);
  struct bucket* bucket = &bcache.bucket[v];
  acquire(&bucket->lock);
    800025a2:	1482                	slli	s1,s1,0x20
    800025a4:	9081                	srli	s1,s1,0x20
    800025a6:	48800793          	li	a5,1160
    800025aa:	02f484b3          	mul	s1,s1,a5
    800025ae:	67a1                	lui	a5,0x8
    800025b0:	43078793          	addi	a5,a5,1072 # 8430 <_entry-0x7fff7bd0>
    800025b4:	94be                	add	s1,s1,a5
    800025b6:	0000d797          	auipc	a5,0xd
    800025ba:	c5a78793          	addi	a5,a5,-934 # 8000f210 <bcache>
    800025be:	94be                	add	s1,s1,a5
    800025c0:	8526                	mv	a0,s1
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	ffe080e7          	jalr	-2(ra) # 800065c0 <acquire>

  b->refcnt--;
    800025ca:	05092783          	lw	a5,80(s2)
    800025ce:	37fd                	addiw	a5,a5,-1
    800025d0:	0007871b          	sext.w	a4,a5
    800025d4:	04f92823          	sw	a5,80(s2)
  if (b->refcnt == 0) {
    800025d8:	c705                	beqz	a4,80002600 <brelse+0x90>
    b->next->prev = b->prev;
    b->prev->next = b->next;
    __atomic_clear(&b->used, __ATOMIC_RELEASE);
  }
  
  release(&bucket->lock);
    800025da:	8526                	mv	a0,s1
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	0b4080e7          	jalr	180(ra) # 80006690 <release>
}
    800025e4:	60e2                	ld	ra,24(sp)
    800025e6:	6442                	ld	s0,16(sp)
    800025e8:	64a2                	ld	s1,8(sp)
    800025ea:	6902                	ld	s2,0(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret
    panic("brelse");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	ec050513          	addi	a0,a0,-320 # 800084b0 <syscalls+0xe8>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	a94080e7          	jalr	-1388(ra) # 8000608c <panic>
    b->next->prev = b->prev;
    80002600:	06093783          	ld	a5,96(s2)
    80002604:	05893703          	ld	a4,88(s2)
    80002608:	efb8                	sd	a4,88(a5)
    b->prev->next = b->next;
    8000260a:	05893783          	ld	a5,88(s2)
    8000260e:	06093703          	ld	a4,96(s2)
    80002612:	f3b8                	sd	a4,96(a5)
    __atomic_clear(&b->used, __ATOMIC_RELEASE);
    80002614:	0ff0000f          	fence
    80002618:	00090023          	sb	zero,0(s2)
    8000261c:	bf7d                	j	800025da <brelse+0x6a>

000000008000261e <bpin>:
// 增加缓冲区的引用计数
void
bpin(struct buf *b) {
    8000261e:	1101                	addi	sp,sp,-32
    80002620:	ec06                	sd	ra,24(sp)
    80002622:	e822                	sd	s0,16(sp)
    80002624:	e426                	sd	s1,8(sp)
    80002626:	e04a                	sd	s2,0(sp)
    80002628:	1000                	addi	s0,sp,32
    8000262a:	892a                	mv	s2,a0
  return key % NBUCKET;
    8000262c:	4904                	lw	s1,16(a0)
    8000262e:	47b5                	li	a5,13
    80002630:	02f4f4bb          	remuw	s1,s1,a5
  uint v = hash_v(b->blockno);
  struct bucket* bucket = &bcache.bucket[v];
  acquire(&bucket->lock);
    80002634:	1482                	slli	s1,s1,0x20
    80002636:	9081                	srli	s1,s1,0x20
    80002638:	48800793          	li	a5,1160
    8000263c:	02f484b3          	mul	s1,s1,a5
    80002640:	67a1                	lui	a5,0x8
    80002642:	43078793          	addi	a5,a5,1072 # 8430 <_entry-0x7fff7bd0>
    80002646:	94be                	add	s1,s1,a5
    80002648:	0000d797          	auipc	a5,0xd
    8000264c:	bc878793          	addi	a5,a5,-1080 # 8000f210 <bcache>
    80002650:	94be                	add	s1,s1,a5
    80002652:	8526                	mv	a0,s1
    80002654:	00004097          	auipc	ra,0x4
    80002658:	f6c080e7          	jalr	-148(ra) # 800065c0 <acquire>
  b->refcnt++;
    8000265c:	05092783          	lw	a5,80(s2)
    80002660:	2785                	addiw	a5,a5,1
    80002662:	04f92823          	sw	a5,80(s2)
  release(&bucket->lock);
    80002666:	8526                	mv	a0,s1
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	028080e7          	jalr	40(ra) # 80006690 <release>
}
    80002670:	60e2                	ld	ra,24(sp)
    80002672:	6442                	ld	s0,16(sp)
    80002674:	64a2                	ld	s1,8(sp)
    80002676:	6902                	ld	s2,0(sp)
    80002678:	6105                	addi	sp,sp,32
    8000267a:	8082                	ret

000000008000267c <bunpin>:
// 减少缓冲区的引用计数
void
bunpin(struct buf *b) {
    8000267c:	1101                	addi	sp,sp,-32
    8000267e:	ec06                	sd	ra,24(sp)
    80002680:	e822                	sd	s0,16(sp)
    80002682:	e426                	sd	s1,8(sp)
    80002684:	e04a                	sd	s2,0(sp)
    80002686:	1000                	addi	s0,sp,32
    80002688:	892a                	mv	s2,a0
  return key % NBUCKET;
    8000268a:	4904                	lw	s1,16(a0)
    8000268c:	47b5                	li	a5,13
    8000268e:	02f4f4bb          	remuw	s1,s1,a5
  uint v = hash_v(b->blockno);
  struct bucket* bucket = &bcache.bucket[v];
  acquire(&bucket->lock);
    80002692:	1482                	slli	s1,s1,0x20
    80002694:	9081                	srli	s1,s1,0x20
    80002696:	48800793          	li	a5,1160
    8000269a:	02f484b3          	mul	s1,s1,a5
    8000269e:	67a1                	lui	a5,0x8
    800026a0:	43078793          	addi	a5,a5,1072 # 8430 <_entry-0x7fff7bd0>
    800026a4:	94be                	add	s1,s1,a5
    800026a6:	0000d797          	auipc	a5,0xd
    800026aa:	b6a78793          	addi	a5,a5,-1174 # 8000f210 <bcache>
    800026ae:	94be                	add	s1,s1,a5
    800026b0:	8526                	mv	a0,s1
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	f0e080e7          	jalr	-242(ra) # 800065c0 <acquire>
  b->refcnt--;
    800026ba:	05092783          	lw	a5,80(s2)
    800026be:	37fd                	addiw	a5,a5,-1
    800026c0:	04f92823          	sw	a5,80(s2)
  release(&bucket->lock);
    800026c4:	8526                	mv	a0,s1
    800026c6:	00004097          	auipc	ra,0x4
    800026ca:	fca080e7          	jalr	-54(ra) # 80006690 <release>
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6902                	ld	s2,0(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	e04a                	sd	s2,0(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026e8:	00d5d59b          	srliw	a1,a1,0xd
    800026ec:	00019797          	auipc	a5,0x19
    800026f0:	a587a783          	lw	a5,-1448(a5) # 8001b144 <sb+0x1c>
    800026f4:	9dbd                	addw	a1,a1,a5
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	cbc080e7          	jalr	-836(ra) # 800023b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026fe:	0074f713          	andi	a4,s1,7
    80002702:	4785                	li	a5,1
    80002704:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002708:	14ce                	slli	s1,s1,0x33
    8000270a:	90d9                	srli	s1,s1,0x36
    8000270c:	00950733          	add	a4,a0,s1
    80002710:	06874703          	lbu	a4,104(a4)
    80002714:	00e7f6b3          	and	a3,a5,a4
    80002718:	c69d                	beqz	a3,80002746 <bfree+0x6c>
    8000271a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000271c:	94aa                	add	s1,s1,a0
    8000271e:	fff7c793          	not	a5,a5
    80002722:	8ff9                	and	a5,a5,a4
    80002724:	06f48423          	sb	a5,104(s1)
  log_write(bp);
    80002728:	00001097          	auipc	ra,0x1
    8000272c:	118080e7          	jalr	280(ra) # 80003840 <log_write>
  brelse(bp);
    80002730:	854a                	mv	a0,s2
    80002732:	00000097          	auipc	ra,0x0
    80002736:	e3e080e7          	jalr	-450(ra) # 80002570 <brelse>
}
    8000273a:	60e2                	ld	ra,24(sp)
    8000273c:	6442                	ld	s0,16(sp)
    8000273e:	64a2                	ld	s1,8(sp)
    80002740:	6902                	ld	s2,0(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret
    panic("freeing free block");
    80002746:	00006517          	auipc	a0,0x6
    8000274a:	d7250513          	addi	a0,a0,-654 # 800084b8 <syscalls+0xf0>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	93e080e7          	jalr	-1730(ra) # 8000608c <panic>

0000000080002756 <balloc>:
{
    80002756:	711d                	addi	sp,sp,-96
    80002758:	ec86                	sd	ra,88(sp)
    8000275a:	e8a2                	sd	s0,80(sp)
    8000275c:	e4a6                	sd	s1,72(sp)
    8000275e:	e0ca                	sd	s2,64(sp)
    80002760:	fc4e                	sd	s3,56(sp)
    80002762:	f852                	sd	s4,48(sp)
    80002764:	f456                	sd	s5,40(sp)
    80002766:	f05a                	sd	s6,32(sp)
    80002768:	ec5e                	sd	s7,24(sp)
    8000276a:	e862                	sd	s8,16(sp)
    8000276c:	e466                	sd	s9,8(sp)
    8000276e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002770:	00019797          	auipc	a5,0x19
    80002774:	9bc7a783          	lw	a5,-1604(a5) # 8001b12c <sb+0x4>
    80002778:	cbd1                	beqz	a5,8000280c <balloc+0xb6>
    8000277a:	8baa                	mv	s7,a0
    8000277c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000277e:	00019b17          	auipc	s6,0x19
    80002782:	9aab0b13          	addi	s6,s6,-1622 # 8001b128 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002786:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002788:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000278c:	6c89                	lui	s9,0x2
    8000278e:	a831                	j	800027aa <balloc+0x54>
    brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	dde080e7          	jalr	-546(ra) # 80002570 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000279a:	015c87bb          	addw	a5,s9,s5
    8000279e:	00078a9b          	sext.w	s5,a5
    800027a2:	004b2703          	lw	a4,4(s6)
    800027a6:	06eaf363          	bgeu	s5,a4,8000280c <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027aa:	41fad79b          	sraiw	a5,s5,0x1f
    800027ae:	0137d79b          	srliw	a5,a5,0x13
    800027b2:	015787bb          	addw	a5,a5,s5
    800027b6:	40d7d79b          	sraiw	a5,a5,0xd
    800027ba:	01cb2583          	lw	a1,28(s6)
    800027be:	9dbd                	addw	a1,a1,a5
    800027c0:	855e                	mv	a0,s7
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	bf0080e7          	jalr	-1040(ra) # 800023b2 <bread>
    800027ca:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027cc:	004b2503          	lw	a0,4(s6)
    800027d0:	000a849b          	sext.w	s1,s5
    800027d4:	8662                	mv	a2,s8
    800027d6:	faa4fde3          	bgeu	s1,a0,80002790 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027da:	41f6579b          	sraiw	a5,a2,0x1f
    800027de:	01d7d69b          	srliw	a3,a5,0x1d
    800027e2:	00c6873b          	addw	a4,a3,a2
    800027e6:	00777793          	andi	a5,a4,7
    800027ea:	9f95                	subw	a5,a5,a3
    800027ec:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027f0:	4037571b          	sraiw	a4,a4,0x3
    800027f4:	00e906b3          	add	a3,s2,a4
    800027f8:	0686c683          	lbu	a3,104(a3)
    800027fc:	00d7f5b3          	and	a1,a5,a3
    80002800:	cd91                	beqz	a1,8000281c <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002802:	2605                	addiw	a2,a2,1
    80002804:	2485                	addiw	s1,s1,1
    80002806:	fd4618e3          	bne	a2,s4,800027d6 <balloc+0x80>
    8000280a:	b759                	j	80002790 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000280c:	00006517          	auipc	a0,0x6
    80002810:	cc450513          	addi	a0,a0,-828 # 800084d0 <syscalls+0x108>
    80002814:	00004097          	auipc	ra,0x4
    80002818:	878080e7          	jalr	-1928(ra) # 8000608c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000281c:	974a                	add	a4,a4,s2
    8000281e:	8fd5                	or	a5,a5,a3
    80002820:	06f70423          	sb	a5,104(a4)
        log_write(bp);
    80002824:	854a                	mv	a0,s2
    80002826:	00001097          	auipc	ra,0x1
    8000282a:	01a080e7          	jalr	26(ra) # 80003840 <log_write>
        brelse(bp);
    8000282e:	854a                	mv	a0,s2
    80002830:	00000097          	auipc	ra,0x0
    80002834:	d40080e7          	jalr	-704(ra) # 80002570 <brelse>
  bp = bread(dev, bno);
    80002838:	85a6                	mv	a1,s1
    8000283a:	855e                	mv	a0,s7
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	b76080e7          	jalr	-1162(ra) # 800023b2 <bread>
    80002844:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002846:	40000613          	li	a2,1024
    8000284a:	4581                	li	a1,0
    8000284c:	06850513          	addi	a0,a0,104
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	a70080e7          	jalr	-1424(ra) # 800002c0 <memset>
  log_write(bp);
    80002858:	854a                	mv	a0,s2
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	fe6080e7          	jalr	-26(ra) # 80003840 <log_write>
  brelse(bp);
    80002862:	854a                	mv	a0,s2
    80002864:	00000097          	auipc	ra,0x0
    80002868:	d0c080e7          	jalr	-756(ra) # 80002570 <brelse>
}
    8000286c:	8526                	mv	a0,s1
    8000286e:	60e6                	ld	ra,88(sp)
    80002870:	6446                	ld	s0,80(sp)
    80002872:	64a6                	ld	s1,72(sp)
    80002874:	6906                	ld	s2,64(sp)
    80002876:	79e2                	ld	s3,56(sp)
    80002878:	7a42                	ld	s4,48(sp)
    8000287a:	7aa2                	ld	s5,40(sp)
    8000287c:	7b02                	ld	s6,32(sp)
    8000287e:	6be2                	ld	s7,24(sp)
    80002880:	6c42                	ld	s8,16(sp)
    80002882:	6ca2                	ld	s9,8(sp)
    80002884:	6125                	addi	sp,sp,96
    80002886:	8082                	ret

0000000080002888 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	e052                	sd	s4,0(sp)
    80002896:	1800                	addi	s0,sp,48
    80002898:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000289a:	47ad                	li	a5,11
    8000289c:	04b7fe63          	bgeu	a5,a1,800028f8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028a0:	ff45849b          	addiw	s1,a1,-12
    800028a4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028a8:	0ff00793          	li	a5,255
    800028ac:	0ae7e363          	bltu	a5,a4,80002952 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028b0:	08852583          	lw	a1,136(a0)
    800028b4:	c5ad                	beqz	a1,8000291e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028b6:	00092503          	lw	a0,0(s2)
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	af8080e7          	jalr	-1288(ra) # 800023b2 <bread>
    800028c2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028c4:	06850793          	addi	a5,a0,104
    if((addr = a[bn]) == 0){
    800028c8:	02049593          	slli	a1,s1,0x20
    800028cc:	9181                	srli	a1,a1,0x20
    800028ce:	058a                	slli	a1,a1,0x2
    800028d0:	00b784b3          	add	s1,a5,a1
    800028d4:	0004a983          	lw	s3,0(s1)
    800028d8:	04098d63          	beqz	s3,80002932 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028dc:	8552                	mv	a0,s4
    800028de:	00000097          	auipc	ra,0x0
    800028e2:	c92080e7          	jalr	-878(ra) # 80002570 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028e6:	854e                	mv	a0,s3
    800028e8:	70a2                	ld	ra,40(sp)
    800028ea:	7402                	ld	s0,32(sp)
    800028ec:	64e2                	ld	s1,24(sp)
    800028ee:	6942                	ld	s2,16(sp)
    800028f0:	69a2                	ld	s3,8(sp)
    800028f2:	6a02                	ld	s4,0(sp)
    800028f4:	6145                	addi	sp,sp,48
    800028f6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028f8:	02059493          	slli	s1,a1,0x20
    800028fc:	9081                	srli	s1,s1,0x20
    800028fe:	048a                	slli	s1,s1,0x2
    80002900:	94aa                	add	s1,s1,a0
    80002902:	0584a983          	lw	s3,88(s1)
    80002906:	fe0990e3          	bnez	s3,800028e6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000290a:	4108                	lw	a0,0(a0)
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	e4a080e7          	jalr	-438(ra) # 80002756 <balloc>
    80002914:	0005099b          	sext.w	s3,a0
    80002918:	0534ac23          	sw	s3,88(s1)
    8000291c:	b7e9                	j	800028e6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000291e:	4108                	lw	a0,0(a0)
    80002920:	00000097          	auipc	ra,0x0
    80002924:	e36080e7          	jalr	-458(ra) # 80002756 <balloc>
    80002928:	0005059b          	sext.w	a1,a0
    8000292c:	08b92423          	sw	a1,136(s2)
    80002930:	b759                	j	800028b6 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002932:	00092503          	lw	a0,0(s2)
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	e20080e7          	jalr	-480(ra) # 80002756 <balloc>
    8000293e:	0005099b          	sext.w	s3,a0
    80002942:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002946:	8552                	mv	a0,s4
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	ef8080e7          	jalr	-264(ra) # 80003840 <log_write>
    80002950:	b771                	j	800028dc <bmap+0x54>
  panic("bmap: out of range");
    80002952:	00006517          	auipc	a0,0x6
    80002956:	b9650513          	addi	a0,a0,-1130 # 800084e8 <syscalls+0x120>
    8000295a:	00003097          	auipc	ra,0x3
    8000295e:	732080e7          	jalr	1842(ra) # 8000608c <panic>

0000000080002962 <iget>:
{
    80002962:	7179                	addi	sp,sp,-48
    80002964:	f406                	sd	ra,40(sp)
    80002966:	f022                	sd	s0,32(sp)
    80002968:	ec26                	sd	s1,24(sp)
    8000296a:	e84a                	sd	s2,16(sp)
    8000296c:	e44e                	sd	s3,8(sp)
    8000296e:	e052                	sd	s4,0(sp)
    80002970:	1800                	addi	s0,sp,48
    80002972:	89aa                	mv	s3,a0
    80002974:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002976:	00018517          	auipc	a0,0x18
    8000297a:	7d250513          	addi	a0,a0,2002 # 8001b148 <itable>
    8000297e:	00004097          	auipc	ra,0x4
    80002982:	c42080e7          	jalr	-958(ra) # 800065c0 <acquire>
  empty = 0;
    80002986:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002988:	00018497          	auipc	s1,0x18
    8000298c:	7e048493          	addi	s1,s1,2016 # 8001b168 <itable+0x20>
    80002990:	0001a697          	auipc	a3,0x1a
    80002994:	3f868693          	addi	a3,a3,1016 # 8001cd88 <log>
    80002998:	a039                	j	800029a6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000299a:	02090b63          	beqz	s2,800029d0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299e:	09048493          	addi	s1,s1,144
    800029a2:	02d48a63          	beq	s1,a3,800029d6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029a6:	449c                	lw	a5,8(s1)
    800029a8:	fef059e3          	blez	a5,8000299a <iget+0x38>
    800029ac:	4098                	lw	a4,0(s1)
    800029ae:	ff3716e3          	bne	a4,s3,8000299a <iget+0x38>
    800029b2:	40d8                	lw	a4,4(s1)
    800029b4:	ff4713e3          	bne	a4,s4,8000299a <iget+0x38>
      ip->ref++;
    800029b8:	2785                	addiw	a5,a5,1
    800029ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029bc:	00018517          	auipc	a0,0x18
    800029c0:	78c50513          	addi	a0,a0,1932 # 8001b148 <itable>
    800029c4:	00004097          	auipc	ra,0x4
    800029c8:	ccc080e7          	jalr	-820(ra) # 80006690 <release>
      return ip;
    800029cc:	8926                	mv	s2,s1
    800029ce:	a03d                	j	800029fc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d0:	f7f9                	bnez	a5,8000299e <iget+0x3c>
    800029d2:	8926                	mv	s2,s1
    800029d4:	b7e9                	j	8000299e <iget+0x3c>
  if(empty == 0)
    800029d6:	02090c63          	beqz	s2,80002a0e <iget+0xac>
  ip->dev = dev;
    800029da:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029de:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029e2:	4785                	li	a5,1
    800029e4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029e8:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    800029ec:	00018517          	auipc	a0,0x18
    800029f0:	75c50513          	addi	a0,a0,1884 # 8001b148 <itable>
    800029f4:	00004097          	auipc	ra,0x4
    800029f8:	c9c080e7          	jalr	-868(ra) # 80006690 <release>
}
    800029fc:	854a                	mv	a0,s2
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
    panic("iget: no inodes");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	af250513          	addi	a0,a0,-1294 # 80008500 <syscalls+0x138>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	676080e7          	jalr	1654(ra) # 8000608c <panic>

0000000080002a1e <fsinit>:
fsinit(int dev) {
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	addi	s0,sp,48
    80002a2c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a2e:	4585                	li	a1,1
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	982080e7          	jalr	-1662(ra) # 800023b2 <bread>
    80002a38:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a3a:	00018997          	auipc	s3,0x18
    80002a3e:	6ee98993          	addi	s3,s3,1774 # 8001b128 <sb>
    80002a42:	02000613          	li	a2,32
    80002a46:	06850593          	addi	a1,a0,104
    80002a4a:	854e                	mv	a0,s3
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	8d4080e7          	jalr	-1836(ra) # 80000320 <memmove>
  brelse(bp);
    80002a54:	8526                	mv	a0,s1
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	b1a080e7          	jalr	-1254(ra) # 80002570 <brelse>
  if(sb.magic != FSMAGIC)
    80002a5e:	0009a703          	lw	a4,0(s3)
    80002a62:	102037b7          	lui	a5,0x10203
    80002a66:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a6a:	02f71263          	bne	a4,a5,80002a8e <fsinit+0x70>
  initlog(dev, &sb);
    80002a6e:	00018597          	auipc	a1,0x18
    80002a72:	6ba58593          	addi	a1,a1,1722 # 8001b128 <sb>
    80002a76:	854a                	mv	a0,s2
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	b4c080e7          	jalr	-1204(ra) # 800035c4 <initlog>
}
    80002a80:	70a2                	ld	ra,40(sp)
    80002a82:	7402                	ld	s0,32(sp)
    80002a84:	64e2                	ld	s1,24(sp)
    80002a86:	6942                	ld	s2,16(sp)
    80002a88:	69a2                	ld	s3,8(sp)
    80002a8a:	6145                	addi	sp,sp,48
    80002a8c:	8082                	ret
    panic("invalid file system");
    80002a8e:	00006517          	auipc	a0,0x6
    80002a92:	a8250513          	addi	a0,a0,-1406 # 80008510 <syscalls+0x148>
    80002a96:	00003097          	auipc	ra,0x3
    80002a9a:	5f6080e7          	jalr	1526(ra) # 8000608c <panic>

0000000080002a9e <iinit>:
{
    80002a9e:	7179                	addi	sp,sp,-48
    80002aa0:	f406                	sd	ra,40(sp)
    80002aa2:	f022                	sd	s0,32(sp)
    80002aa4:	ec26                	sd	s1,24(sp)
    80002aa6:	e84a                	sd	s2,16(sp)
    80002aa8:	e44e                	sd	s3,8(sp)
    80002aaa:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aac:	00006597          	auipc	a1,0x6
    80002ab0:	a7c58593          	addi	a1,a1,-1412 # 80008528 <syscalls+0x160>
    80002ab4:	00018517          	auipc	a0,0x18
    80002ab8:	69450513          	addi	a0,a0,1684 # 8001b148 <itable>
    80002abc:	00004097          	auipc	ra,0x4
    80002ac0:	c80080e7          	jalr	-896(ra) # 8000673c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ac4:	00018497          	auipc	s1,0x18
    80002ac8:	6b448493          	addi	s1,s1,1716 # 8001b178 <itable+0x30>
    80002acc:	0001a997          	auipc	s3,0x1a
    80002ad0:	2cc98993          	addi	s3,s3,716 # 8001cd98 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ad4:	00006917          	auipc	s2,0x6
    80002ad8:	a5c90913          	addi	s2,s2,-1444 # 80008530 <syscalls+0x168>
    80002adc:	85ca                	mv	a1,s2
    80002ade:	8526                	mv	a0,s1
    80002ae0:	00001097          	auipc	ra,0x1
    80002ae4:	e46080e7          	jalr	-442(ra) # 80003926 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ae8:	09048493          	addi	s1,s1,144
    80002aec:	ff3498e3          	bne	s1,s3,80002adc <iinit+0x3e>
}
    80002af0:	70a2                	ld	ra,40(sp)
    80002af2:	7402                	ld	s0,32(sp)
    80002af4:	64e2                	ld	s1,24(sp)
    80002af6:	6942                	ld	s2,16(sp)
    80002af8:	69a2                	ld	s3,8(sp)
    80002afa:	6145                	addi	sp,sp,48
    80002afc:	8082                	ret

0000000080002afe <ialloc>:
{
    80002afe:	715d                	addi	sp,sp,-80
    80002b00:	e486                	sd	ra,72(sp)
    80002b02:	e0a2                	sd	s0,64(sp)
    80002b04:	fc26                	sd	s1,56(sp)
    80002b06:	f84a                	sd	s2,48(sp)
    80002b08:	f44e                	sd	s3,40(sp)
    80002b0a:	f052                	sd	s4,32(sp)
    80002b0c:	ec56                	sd	s5,24(sp)
    80002b0e:	e85a                	sd	s6,16(sp)
    80002b10:	e45e                	sd	s7,8(sp)
    80002b12:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b14:	00018717          	auipc	a4,0x18
    80002b18:	62072703          	lw	a4,1568(a4) # 8001b134 <sb+0xc>
    80002b1c:	4785                	li	a5,1
    80002b1e:	04e7fa63          	bgeu	a5,a4,80002b72 <ialloc+0x74>
    80002b22:	8aaa                	mv	s5,a0
    80002b24:	8bae                	mv	s7,a1
    80002b26:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b28:	00018a17          	auipc	s4,0x18
    80002b2c:	600a0a13          	addi	s4,s4,1536 # 8001b128 <sb>
    80002b30:	00048b1b          	sext.w	s6,s1
    80002b34:	0044d593          	srli	a1,s1,0x4
    80002b38:	018a2783          	lw	a5,24(s4)
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	8556                	mv	a0,s5
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	872080e7          	jalr	-1934(ra) # 800023b2 <bread>
    80002b48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b4a:	06850993          	addi	s3,a0,104
    80002b4e:	00f4f793          	andi	a5,s1,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b56:	00099783          	lh	a5,0(s3)
    80002b5a:	c785                	beqz	a5,80002b82 <ialloc+0x84>
    brelse(bp);
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	a14080e7          	jalr	-1516(ra) # 80002570 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b64:	0485                	addi	s1,s1,1
    80002b66:	00ca2703          	lw	a4,12(s4)
    80002b6a:	0004879b          	sext.w	a5,s1
    80002b6e:	fce7e1e3          	bltu	a5,a4,80002b30 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	9c650513          	addi	a0,a0,-1594 # 80008538 <syscalls+0x170>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	512080e7          	jalr	1298(ra) # 8000608c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b82:	04000613          	li	a2,64
    80002b86:	4581                	li	a1,0
    80002b88:	854e                	mv	a0,s3
    80002b8a:	ffffd097          	auipc	ra,0xffffd
    80002b8e:	736080e7          	jalr	1846(ra) # 800002c0 <memset>
      dip->type = type;
    80002b92:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b96:	854a                	mv	a0,s2
    80002b98:	00001097          	auipc	ra,0x1
    80002b9c:	ca8080e7          	jalr	-856(ra) # 80003840 <log_write>
      brelse(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00000097          	auipc	ra,0x0
    80002ba6:	9ce080e7          	jalr	-1586(ra) # 80002570 <brelse>
      return iget(dev, inum);
    80002baa:	85da                	mv	a1,s6
    80002bac:	8556                	mv	a0,s5
    80002bae:	00000097          	auipc	ra,0x0
    80002bb2:	db4080e7          	jalr	-588(ra) # 80002962 <iget>
}
    80002bb6:	60a6                	ld	ra,72(sp)
    80002bb8:	6406                	ld	s0,64(sp)
    80002bba:	74e2                	ld	s1,56(sp)
    80002bbc:	7942                	ld	s2,48(sp)
    80002bbe:	79a2                	ld	s3,40(sp)
    80002bc0:	7a02                	ld	s4,32(sp)
    80002bc2:	6ae2                	ld	s5,24(sp)
    80002bc4:	6b42                	ld	s6,16(sp)
    80002bc6:	6ba2                	ld	s7,8(sp)
    80002bc8:	6161                	addi	sp,sp,80
    80002bca:	8082                	ret

0000000080002bcc <iupdate>:
{
    80002bcc:	1101                	addi	sp,sp,-32
    80002bce:	ec06                	sd	ra,24(sp)
    80002bd0:	e822                	sd	s0,16(sp)
    80002bd2:	e426                	sd	s1,8(sp)
    80002bd4:	e04a                	sd	s2,0(sp)
    80002bd6:	1000                	addi	s0,sp,32
    80002bd8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bda:	415c                	lw	a5,4(a0)
    80002bdc:	0047d79b          	srliw	a5,a5,0x4
    80002be0:	00018597          	auipc	a1,0x18
    80002be4:	5605a583          	lw	a1,1376(a1) # 8001b140 <sb+0x18>
    80002be8:	9dbd                	addw	a1,a1,a5
    80002bea:	4108                	lw	a0,0(a0)
    80002bec:	fffff097          	auipc	ra,0xfffff
    80002bf0:	7c6080e7          	jalr	1990(ra) # 800023b2 <bread>
    80002bf4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf6:	06850793          	addi	a5,a0,104
    80002bfa:	40c8                	lw	a0,4(s1)
    80002bfc:	893d                	andi	a0,a0,15
    80002bfe:	051a                	slli	a0,a0,0x6
    80002c00:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c02:	04c49703          	lh	a4,76(s1)
    80002c06:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c0a:	04e49703          	lh	a4,78(s1)
    80002c0e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c12:	05049703          	lh	a4,80(s1)
    80002c16:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c1a:	05249703          	lh	a4,82(s1)
    80002c1e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c22:	48f8                	lw	a4,84(s1)
    80002c24:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c26:	03400613          	li	a2,52
    80002c2a:	05848593          	addi	a1,s1,88
    80002c2e:	0531                	addi	a0,a0,12
    80002c30:	ffffd097          	auipc	ra,0xffffd
    80002c34:	6f0080e7          	jalr	1776(ra) # 80000320 <memmove>
  log_write(bp);
    80002c38:	854a                	mv	a0,s2
    80002c3a:	00001097          	auipc	ra,0x1
    80002c3e:	c06080e7          	jalr	-1018(ra) # 80003840 <log_write>
  brelse(bp);
    80002c42:	854a                	mv	a0,s2
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	92c080e7          	jalr	-1748(ra) # 80002570 <brelse>
}
    80002c4c:	60e2                	ld	ra,24(sp)
    80002c4e:	6442                	ld	s0,16(sp)
    80002c50:	64a2                	ld	s1,8(sp)
    80002c52:	6902                	ld	s2,0(sp)
    80002c54:	6105                	addi	sp,sp,32
    80002c56:	8082                	ret

0000000080002c58 <idup>:
{
    80002c58:	1101                	addi	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	1000                	addi	s0,sp,32
    80002c62:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c64:	00018517          	auipc	a0,0x18
    80002c68:	4e450513          	addi	a0,a0,1252 # 8001b148 <itable>
    80002c6c:	00004097          	auipc	ra,0x4
    80002c70:	954080e7          	jalr	-1708(ra) # 800065c0 <acquire>
  ip->ref++;
    80002c74:	449c                	lw	a5,8(s1)
    80002c76:	2785                	addiw	a5,a5,1
    80002c78:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c7a:	00018517          	auipc	a0,0x18
    80002c7e:	4ce50513          	addi	a0,a0,1230 # 8001b148 <itable>
    80002c82:	00004097          	auipc	ra,0x4
    80002c86:	a0e080e7          	jalr	-1522(ra) # 80006690 <release>
}
    80002c8a:	8526                	mv	a0,s1
    80002c8c:	60e2                	ld	ra,24(sp)
    80002c8e:	6442                	ld	s0,16(sp)
    80002c90:	64a2                	ld	s1,8(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret

0000000080002c96 <ilock>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ca2:	c115                	beqz	a0,80002cc6 <ilock+0x30>
    80002ca4:	84aa                	mv	s1,a0
    80002ca6:	451c                	lw	a5,8(a0)
    80002ca8:	00f05f63          	blez	a5,80002cc6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cac:	0541                	addi	a0,a0,16
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	cb2080e7          	jalr	-846(ra) # 80003960 <acquiresleep>
  if(ip->valid == 0){
    80002cb6:	44bc                	lw	a5,72(s1)
    80002cb8:	cf99                	beqz	a5,80002cd6 <ilock+0x40>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	64a2                	ld	s1,8(sp)
    80002cc0:	6902                	ld	s2,0(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret
    panic("ilock");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	88a50513          	addi	a0,a0,-1910 # 80008550 <syscalls+0x188>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	3be080e7          	jalr	958(ra) # 8000608c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cd6:	40dc                	lw	a5,4(s1)
    80002cd8:	0047d79b          	srliw	a5,a5,0x4
    80002cdc:	00018597          	auipc	a1,0x18
    80002ce0:	4645a583          	lw	a1,1124(a1) # 8001b140 <sb+0x18>
    80002ce4:	9dbd                	addw	a1,a1,a5
    80002ce6:	4088                	lw	a0,0(s1)
    80002ce8:	fffff097          	auipc	ra,0xfffff
    80002cec:	6ca080e7          	jalr	1738(ra) # 800023b2 <bread>
    80002cf0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cf2:	06850593          	addi	a1,a0,104
    80002cf6:	40dc                	lw	a5,4(s1)
    80002cf8:	8bbd                	andi	a5,a5,15
    80002cfa:	079a                	slli	a5,a5,0x6
    80002cfc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cfe:	00059783          	lh	a5,0(a1)
    80002d02:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002d06:	00259783          	lh	a5,2(a1)
    80002d0a:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002d0e:	00459783          	lh	a5,4(a1)
    80002d12:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002d16:	00659783          	lh	a5,6(a1)
    80002d1a:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002d1e:	459c                	lw	a5,8(a1)
    80002d20:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d22:	03400613          	li	a2,52
    80002d26:	05b1                	addi	a1,a1,12
    80002d28:	05848513          	addi	a0,s1,88
    80002d2c:	ffffd097          	auipc	ra,0xffffd
    80002d30:	5f4080e7          	jalr	1524(ra) # 80000320 <memmove>
    brelse(bp);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	83a080e7          	jalr	-1990(ra) # 80002570 <brelse>
    ip->valid = 1;
    80002d3e:	4785                	li	a5,1
    80002d40:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002d42:	04c49783          	lh	a5,76(s1)
    80002d46:	fbb5                	bnez	a5,80002cba <ilock+0x24>
      panic("ilock: no type");
    80002d48:	00006517          	auipc	a0,0x6
    80002d4c:	81050513          	addi	a0,a0,-2032 # 80008558 <syscalls+0x190>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	33c080e7          	jalr	828(ra) # 8000608c <panic>

0000000080002d58 <iunlock>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	e04a                	sd	s2,0(sp)
    80002d62:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d64:	c905                	beqz	a0,80002d94 <iunlock+0x3c>
    80002d66:	84aa                	mv	s1,a0
    80002d68:	01050913          	addi	s2,a0,16
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	c8c080e7          	jalr	-884(ra) # 800039fa <holdingsleep>
    80002d76:	cd19                	beqz	a0,80002d94 <iunlock+0x3c>
    80002d78:	449c                	lw	a5,8(s1)
    80002d7a:	00f05d63          	blez	a5,80002d94 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	c36080e7          	jalr	-970(ra) # 800039b6 <releasesleep>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6902                	ld	s2,0(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
    panic("iunlock");
    80002d94:	00005517          	auipc	a0,0x5
    80002d98:	7d450513          	addi	a0,a0,2004 # 80008568 <syscalls+0x1a0>
    80002d9c:	00003097          	auipc	ra,0x3
    80002da0:	2f0080e7          	jalr	752(ra) # 8000608c <panic>

0000000080002da4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002da4:	7179                	addi	sp,sp,-48
    80002da6:	f406                	sd	ra,40(sp)
    80002da8:	f022                	sd	s0,32(sp)
    80002daa:	ec26                	sd	s1,24(sp)
    80002dac:	e84a                	sd	s2,16(sp)
    80002dae:	e44e                	sd	s3,8(sp)
    80002db0:	e052                	sd	s4,0(sp)
    80002db2:	1800                	addi	s0,sp,48
    80002db4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002db6:	05850493          	addi	s1,a0,88
    80002dba:	08850913          	addi	s2,a0,136
    80002dbe:	a021                	j	80002dc6 <itrunc+0x22>
    80002dc0:	0491                	addi	s1,s1,4
    80002dc2:	01248d63          	beq	s1,s2,80002ddc <itrunc+0x38>
    if(ip->addrs[i]){
    80002dc6:	408c                	lw	a1,0(s1)
    80002dc8:	dde5                	beqz	a1,80002dc0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dca:	0009a503          	lw	a0,0(s3)
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	90c080e7          	jalr	-1780(ra) # 800026da <bfree>
      ip->addrs[i] = 0;
    80002dd6:	0004a023          	sw	zero,0(s1)
    80002dda:	b7dd                	j	80002dc0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ddc:	0889a583          	lw	a1,136(s3)
    80002de0:	e185                	bnez	a1,80002e00 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002de2:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002de6:	854e                	mv	a0,s3
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	de4080e7          	jalr	-540(ra) # 80002bcc <iupdate>
}
    80002df0:	70a2                	ld	ra,40(sp)
    80002df2:	7402                	ld	s0,32(sp)
    80002df4:	64e2                	ld	s1,24(sp)
    80002df6:	6942                	ld	s2,16(sp)
    80002df8:	69a2                	ld	s3,8(sp)
    80002dfa:	6a02                	ld	s4,0(sp)
    80002dfc:	6145                	addi	sp,sp,48
    80002dfe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e00:	0009a503          	lw	a0,0(s3)
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	5ae080e7          	jalr	1454(ra) # 800023b2 <bread>
    80002e0c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e0e:	06850493          	addi	s1,a0,104
    80002e12:	46850913          	addi	s2,a0,1128
    80002e16:	a811                	j	80002e2a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e18:	0009a503          	lw	a0,0(s3)
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	8be080e7          	jalr	-1858(ra) # 800026da <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e24:	0491                	addi	s1,s1,4
    80002e26:	01248563          	beq	s1,s2,80002e30 <itrunc+0x8c>
      if(a[j])
    80002e2a:	408c                	lw	a1,0(s1)
    80002e2c:	dde5                	beqz	a1,80002e24 <itrunc+0x80>
    80002e2e:	b7ed                	j	80002e18 <itrunc+0x74>
    brelse(bp);
    80002e30:	8552                	mv	a0,s4
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	73e080e7          	jalr	1854(ra) # 80002570 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e3a:	0889a583          	lw	a1,136(s3)
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	898080e7          	jalr	-1896(ra) # 800026da <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e4a:	0809a423          	sw	zero,136(s3)
    80002e4e:	bf51                	j	80002de2 <itrunc+0x3e>

0000000080002e50 <iput>:
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
    80002e5c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e5e:	00018517          	auipc	a0,0x18
    80002e62:	2ea50513          	addi	a0,a0,746 # 8001b148 <itable>
    80002e66:	00003097          	auipc	ra,0x3
    80002e6a:	75a080e7          	jalr	1882(ra) # 800065c0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6e:	4498                	lw	a4,8(s1)
    80002e70:	4785                	li	a5,1
    80002e72:	02f70363          	beq	a4,a5,80002e98 <iput+0x48>
  ip->ref--;
    80002e76:	449c                	lw	a5,8(s1)
    80002e78:	37fd                	addiw	a5,a5,-1
    80002e7a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e7c:	00018517          	auipc	a0,0x18
    80002e80:	2cc50513          	addi	a0,a0,716 # 8001b148 <itable>
    80002e84:	00004097          	auipc	ra,0x4
    80002e88:	80c080e7          	jalr	-2036(ra) # 80006690 <release>
}
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6902                	ld	s2,0(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e98:	44bc                	lw	a5,72(s1)
    80002e9a:	dff1                	beqz	a5,80002e76 <iput+0x26>
    80002e9c:	05249783          	lh	a5,82(s1)
    80002ea0:	fbf9                	bnez	a5,80002e76 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ea2:	01048913          	addi	s2,s1,16
    80002ea6:	854a                	mv	a0,s2
    80002ea8:	00001097          	auipc	ra,0x1
    80002eac:	ab8080e7          	jalr	-1352(ra) # 80003960 <acquiresleep>
    release(&itable.lock);
    80002eb0:	00018517          	auipc	a0,0x18
    80002eb4:	29850513          	addi	a0,a0,664 # 8001b148 <itable>
    80002eb8:	00003097          	auipc	ra,0x3
    80002ebc:	7d8080e7          	jalr	2008(ra) # 80006690 <release>
    itrunc(ip);
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	ee2080e7          	jalr	-286(ra) # 80002da4 <itrunc>
    ip->type = 0;
    80002eca:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002ece:	8526                	mv	a0,s1
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	cfc080e7          	jalr	-772(ra) # 80002bcc <iupdate>
    ip->valid = 0;
    80002ed8:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002edc:	854a                	mv	a0,s2
    80002ede:	00001097          	auipc	ra,0x1
    80002ee2:	ad8080e7          	jalr	-1320(ra) # 800039b6 <releasesleep>
    acquire(&itable.lock);
    80002ee6:	00018517          	auipc	a0,0x18
    80002eea:	26250513          	addi	a0,a0,610 # 8001b148 <itable>
    80002eee:	00003097          	auipc	ra,0x3
    80002ef2:	6d2080e7          	jalr	1746(ra) # 800065c0 <acquire>
    80002ef6:	b741                	j	80002e76 <iput+0x26>

0000000080002ef8 <iunlockput>:
{
    80002ef8:	1101                	addi	sp,sp,-32
    80002efa:	ec06                	sd	ra,24(sp)
    80002efc:	e822                	sd	s0,16(sp)
    80002efe:	e426                	sd	s1,8(sp)
    80002f00:	1000                	addi	s0,sp,32
    80002f02:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	e54080e7          	jalr	-428(ra) # 80002d58 <iunlock>
  iput(ip);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	f42080e7          	jalr	-190(ra) # 80002e50 <iput>
}
    80002f16:	60e2                	ld	ra,24(sp)
    80002f18:	6442                	ld	s0,16(sp)
    80002f1a:	64a2                	ld	s1,8(sp)
    80002f1c:	6105                	addi	sp,sp,32
    80002f1e:	8082                	ret

0000000080002f20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f20:	1141                	addi	sp,sp,-16
    80002f22:	e422                	sd	s0,8(sp)
    80002f24:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f26:	411c                	lw	a5,0(a0)
    80002f28:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f2a:	415c                	lw	a5,4(a0)
    80002f2c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f2e:	04c51783          	lh	a5,76(a0)
    80002f32:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f36:	05251783          	lh	a5,82(a0)
    80002f3a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f3e:	05456783          	lwu	a5,84(a0)
    80002f42:	e99c                	sd	a5,16(a1)
}
    80002f44:	6422                	ld	s0,8(sp)
    80002f46:	0141                	addi	sp,sp,16
    80002f48:	8082                	ret

0000000080002f4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4a:	497c                	lw	a5,84(a0)
    80002f4c:	0ed7e963          	bltu	a5,a3,8000303e <readi+0xf4>
{
    80002f50:	7159                	addi	sp,sp,-112
    80002f52:	f486                	sd	ra,104(sp)
    80002f54:	f0a2                	sd	s0,96(sp)
    80002f56:	eca6                	sd	s1,88(sp)
    80002f58:	e8ca                	sd	s2,80(sp)
    80002f5a:	e4ce                	sd	s3,72(sp)
    80002f5c:	e0d2                	sd	s4,64(sp)
    80002f5e:	fc56                	sd	s5,56(sp)
    80002f60:	f85a                	sd	s6,48(sp)
    80002f62:	f45e                	sd	s7,40(sp)
    80002f64:	f062                	sd	s8,32(sp)
    80002f66:	ec66                	sd	s9,24(sp)
    80002f68:	e86a                	sd	s10,16(sp)
    80002f6a:	e46e                	sd	s11,8(sp)
    80002f6c:	1880                	addi	s0,sp,112
    80002f6e:	8baa                	mv	s7,a0
    80002f70:	8c2e                	mv	s8,a1
    80002f72:	8ab2                	mv	s5,a2
    80002f74:	84b6                	mv	s1,a3
    80002f76:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f78:	9f35                	addw	a4,a4,a3
    return 0;
    80002f7a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f7c:	0ad76063          	bltu	a4,a3,8000301c <readi+0xd2>
  if(off + n > ip->size)
    80002f80:	00e7f463          	bgeu	a5,a4,80002f88 <readi+0x3e>
    n = ip->size - off;
    80002f84:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f88:	0a0b0963          	beqz	s6,8000303a <readi+0xf0>
    80002f8c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f92:	5cfd                	li	s9,-1
    80002f94:	a82d                	j	80002fce <readi+0x84>
    80002f96:	020a1d93          	slli	s11,s4,0x20
    80002f9a:	020ddd93          	srli	s11,s11,0x20
    80002f9e:	06890613          	addi	a2,s2,104
    80002fa2:	86ee                	mv	a3,s11
    80002fa4:	963a                	add	a2,a2,a4
    80002fa6:	85d6                	mv	a1,s5
    80002fa8:	8562                	mv	a0,s8
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	a56080e7          	jalr	-1450(ra) # 80001a00 <either_copyout>
    80002fb2:	05950d63          	beq	a0,s9,8000300c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	5b8080e7          	jalr	1464(ra) # 80002570 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc0:	013a09bb          	addw	s3,s4,s3
    80002fc4:	009a04bb          	addw	s1,s4,s1
    80002fc8:	9aee                	add	s5,s5,s11
    80002fca:	0569f763          	bgeu	s3,s6,80003018 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fce:	000ba903          	lw	s2,0(s7)
    80002fd2:	00a4d59b          	srliw	a1,s1,0xa
    80002fd6:	855e                	mv	a0,s7
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	8b0080e7          	jalr	-1872(ra) # 80002888 <bmap>
    80002fe0:	0005059b          	sext.w	a1,a0
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	3cc080e7          	jalr	972(ra) # 800023b2 <bread>
    80002fee:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff0:	3ff4f713          	andi	a4,s1,1023
    80002ff4:	40ed07bb          	subw	a5,s10,a4
    80002ff8:	413b06bb          	subw	a3,s6,s3
    80002ffc:	8a3e                	mv	s4,a5
    80002ffe:	2781                	sext.w	a5,a5
    80003000:	0006861b          	sext.w	a2,a3
    80003004:	f8f679e3          	bgeu	a2,a5,80002f96 <readi+0x4c>
    80003008:	8a36                	mv	s4,a3
    8000300a:	b771                	j	80002f96 <readi+0x4c>
      brelse(bp);
    8000300c:	854a                	mv	a0,s2
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	562080e7          	jalr	1378(ra) # 80002570 <brelse>
      tot = -1;
    80003016:	59fd                	li	s3,-1
  }
  return tot;
    80003018:	0009851b          	sext.w	a0,s3
}
    8000301c:	70a6                	ld	ra,104(sp)
    8000301e:	7406                	ld	s0,96(sp)
    80003020:	64e6                	ld	s1,88(sp)
    80003022:	6946                	ld	s2,80(sp)
    80003024:	69a6                	ld	s3,72(sp)
    80003026:	6a06                	ld	s4,64(sp)
    80003028:	7ae2                	ld	s5,56(sp)
    8000302a:	7b42                	ld	s6,48(sp)
    8000302c:	7ba2                	ld	s7,40(sp)
    8000302e:	7c02                	ld	s8,32(sp)
    80003030:	6ce2                	ld	s9,24(sp)
    80003032:	6d42                	ld	s10,16(sp)
    80003034:	6da2                	ld	s11,8(sp)
    80003036:	6165                	addi	sp,sp,112
    80003038:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000303a:	89da                	mv	s3,s6
    8000303c:	bff1                	j	80003018 <readi+0xce>
    return 0;
    8000303e:	4501                	li	a0,0
}
    80003040:	8082                	ret

0000000080003042 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003042:	497c                	lw	a5,84(a0)
    80003044:	10d7e863          	bltu	a5,a3,80003154 <writei+0x112>
{
    80003048:	7159                	addi	sp,sp,-112
    8000304a:	f486                	sd	ra,104(sp)
    8000304c:	f0a2                	sd	s0,96(sp)
    8000304e:	eca6                	sd	s1,88(sp)
    80003050:	e8ca                	sd	s2,80(sp)
    80003052:	e4ce                	sd	s3,72(sp)
    80003054:	e0d2                	sd	s4,64(sp)
    80003056:	fc56                	sd	s5,56(sp)
    80003058:	f85a                	sd	s6,48(sp)
    8000305a:	f45e                	sd	s7,40(sp)
    8000305c:	f062                	sd	s8,32(sp)
    8000305e:	ec66                	sd	s9,24(sp)
    80003060:	e86a                	sd	s10,16(sp)
    80003062:	e46e                	sd	s11,8(sp)
    80003064:	1880                	addi	s0,sp,112
    80003066:	8b2a                	mv	s6,a0
    80003068:	8c2e                	mv	s8,a1
    8000306a:	8ab2                	mv	s5,a2
    8000306c:	8936                	mv	s2,a3
    8000306e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003070:	00e687bb          	addw	a5,a3,a4
    80003074:	0ed7e263          	bltu	a5,a3,80003158 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003078:	00043737          	lui	a4,0x43
    8000307c:	0ef76063          	bltu	a4,a5,8000315c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003080:	0c0b8863          	beqz	s7,80003150 <writei+0x10e>
    80003084:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000308a:	5cfd                	li	s9,-1
    8000308c:	a091                	j	800030d0 <writei+0x8e>
    8000308e:	02099d93          	slli	s11,s3,0x20
    80003092:	020ddd93          	srli	s11,s11,0x20
    80003096:	06848513          	addi	a0,s1,104
    8000309a:	86ee                	mv	a3,s11
    8000309c:	8656                	mv	a2,s5
    8000309e:	85e2                	mv	a1,s8
    800030a0:	953a                	add	a0,a0,a4
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	9b4080e7          	jalr	-1612(ra) # 80001a56 <either_copyin>
    800030aa:	07950263          	beq	a0,s9,8000310e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ae:	8526                	mv	a0,s1
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	790080e7          	jalr	1936(ra) # 80003840 <log_write>
    brelse(bp);
    800030b8:	8526                	mv	a0,s1
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	4b6080e7          	jalr	1206(ra) # 80002570 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c2:	01498a3b          	addw	s4,s3,s4
    800030c6:	0129893b          	addw	s2,s3,s2
    800030ca:	9aee                	add	s5,s5,s11
    800030cc:	057a7663          	bgeu	s4,s7,80003118 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030d0:	000b2483          	lw	s1,0(s6)
    800030d4:	00a9559b          	srliw	a1,s2,0xa
    800030d8:	855a                	mv	a0,s6
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	7ae080e7          	jalr	1966(ra) # 80002888 <bmap>
    800030e2:	0005059b          	sext.w	a1,a0
    800030e6:	8526                	mv	a0,s1
    800030e8:	fffff097          	auipc	ra,0xfffff
    800030ec:	2ca080e7          	jalr	714(ra) # 800023b2 <bread>
    800030f0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f2:	3ff97713          	andi	a4,s2,1023
    800030f6:	40ed07bb          	subw	a5,s10,a4
    800030fa:	414b86bb          	subw	a3,s7,s4
    800030fe:	89be                	mv	s3,a5
    80003100:	2781                	sext.w	a5,a5
    80003102:	0006861b          	sext.w	a2,a3
    80003106:	f8f674e3          	bgeu	a2,a5,8000308e <writei+0x4c>
    8000310a:	89b6                	mv	s3,a3
    8000310c:	b749                	j	8000308e <writei+0x4c>
      brelse(bp);
    8000310e:	8526                	mv	a0,s1
    80003110:	fffff097          	auipc	ra,0xfffff
    80003114:	460080e7          	jalr	1120(ra) # 80002570 <brelse>
  }

  if(off > ip->size)
    80003118:	054b2783          	lw	a5,84(s6)
    8000311c:	0127f463          	bgeu	a5,s2,80003124 <writei+0xe2>
    ip->size = off;
    80003120:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003124:	855a                	mv	a0,s6
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	aa6080e7          	jalr	-1370(ra) # 80002bcc <iupdate>

  return tot;
    8000312e:	000a051b          	sext.w	a0,s4
}
    80003132:	70a6                	ld	ra,104(sp)
    80003134:	7406                	ld	s0,96(sp)
    80003136:	64e6                	ld	s1,88(sp)
    80003138:	6946                	ld	s2,80(sp)
    8000313a:	69a6                	ld	s3,72(sp)
    8000313c:	6a06                	ld	s4,64(sp)
    8000313e:	7ae2                	ld	s5,56(sp)
    80003140:	7b42                	ld	s6,48(sp)
    80003142:	7ba2                	ld	s7,40(sp)
    80003144:	7c02                	ld	s8,32(sp)
    80003146:	6ce2                	ld	s9,24(sp)
    80003148:	6d42                	ld	s10,16(sp)
    8000314a:	6da2                	ld	s11,8(sp)
    8000314c:	6165                	addi	sp,sp,112
    8000314e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003150:	8a5e                	mv	s4,s7
    80003152:	bfc9                	j	80003124 <writei+0xe2>
    return -1;
    80003154:	557d                	li	a0,-1
}
    80003156:	8082                	ret
    return -1;
    80003158:	557d                	li	a0,-1
    8000315a:	bfe1                	j	80003132 <writei+0xf0>
    return -1;
    8000315c:	557d                	li	a0,-1
    8000315e:	bfd1                	j	80003132 <writei+0xf0>

0000000080003160 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003160:	1141                	addi	sp,sp,-16
    80003162:	e406                	sd	ra,8(sp)
    80003164:	e022                	sd	s0,0(sp)
    80003166:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003168:	4639                	li	a2,14
    8000316a:	ffffd097          	auipc	ra,0xffffd
    8000316e:	22e080e7          	jalr	558(ra) # 80000398 <strncmp>
}
    80003172:	60a2                	ld	ra,8(sp)
    80003174:	6402                	ld	s0,0(sp)
    80003176:	0141                	addi	sp,sp,16
    80003178:	8082                	ret

000000008000317a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000317a:	7139                	addi	sp,sp,-64
    8000317c:	fc06                	sd	ra,56(sp)
    8000317e:	f822                	sd	s0,48(sp)
    80003180:	f426                	sd	s1,40(sp)
    80003182:	f04a                	sd	s2,32(sp)
    80003184:	ec4e                	sd	s3,24(sp)
    80003186:	e852                	sd	s4,16(sp)
    80003188:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000318a:	04c51703          	lh	a4,76(a0)
    8000318e:	4785                	li	a5,1
    80003190:	00f71a63          	bne	a4,a5,800031a4 <dirlookup+0x2a>
    80003194:	892a                	mv	s2,a0
    80003196:	89ae                	mv	s3,a1
    80003198:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000319a:	497c                	lw	a5,84(a0)
    8000319c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000319e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a0:	e79d                	bnez	a5,800031ce <dirlookup+0x54>
    800031a2:	a8a5                	j	8000321a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031a4:	00005517          	auipc	a0,0x5
    800031a8:	3cc50513          	addi	a0,a0,972 # 80008570 <syscalls+0x1a8>
    800031ac:	00003097          	auipc	ra,0x3
    800031b0:	ee0080e7          	jalr	-288(ra) # 8000608c <panic>
      panic("dirlookup read");
    800031b4:	00005517          	auipc	a0,0x5
    800031b8:	3d450513          	addi	a0,a0,980 # 80008588 <syscalls+0x1c0>
    800031bc:	00003097          	auipc	ra,0x3
    800031c0:	ed0080e7          	jalr	-304(ra) # 8000608c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c4:	24c1                	addiw	s1,s1,16
    800031c6:	05492783          	lw	a5,84(s2)
    800031ca:	04f4f763          	bgeu	s1,a5,80003218 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ce:	4741                	li	a4,16
    800031d0:	86a6                	mv	a3,s1
    800031d2:	fc040613          	addi	a2,s0,-64
    800031d6:	4581                	li	a1,0
    800031d8:	854a                	mv	a0,s2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	d70080e7          	jalr	-656(ra) # 80002f4a <readi>
    800031e2:	47c1                	li	a5,16
    800031e4:	fcf518e3          	bne	a0,a5,800031b4 <dirlookup+0x3a>
    if(de.inum == 0)
    800031e8:	fc045783          	lhu	a5,-64(s0)
    800031ec:	dfe1                	beqz	a5,800031c4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031ee:	fc240593          	addi	a1,s0,-62
    800031f2:	854e                	mv	a0,s3
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	f6c080e7          	jalr	-148(ra) # 80003160 <namecmp>
    800031fc:	f561                	bnez	a0,800031c4 <dirlookup+0x4a>
      if(poff)
    800031fe:	000a0463          	beqz	s4,80003206 <dirlookup+0x8c>
        *poff = off;
    80003202:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003206:	fc045583          	lhu	a1,-64(s0)
    8000320a:	00092503          	lw	a0,0(s2)
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	754080e7          	jalr	1876(ra) # 80002962 <iget>
    80003216:	a011                	j	8000321a <dirlookup+0xa0>
  return 0;
    80003218:	4501                	li	a0,0
}
    8000321a:	70e2                	ld	ra,56(sp)
    8000321c:	7442                	ld	s0,48(sp)
    8000321e:	74a2                	ld	s1,40(sp)
    80003220:	7902                	ld	s2,32(sp)
    80003222:	69e2                	ld	s3,24(sp)
    80003224:	6a42                	ld	s4,16(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret

000000008000322a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000322a:	711d                	addi	sp,sp,-96
    8000322c:	ec86                	sd	ra,88(sp)
    8000322e:	e8a2                	sd	s0,80(sp)
    80003230:	e4a6                	sd	s1,72(sp)
    80003232:	e0ca                	sd	s2,64(sp)
    80003234:	fc4e                	sd	s3,56(sp)
    80003236:	f852                	sd	s4,48(sp)
    80003238:	f456                	sd	s5,40(sp)
    8000323a:	f05a                	sd	s6,32(sp)
    8000323c:	ec5e                	sd	s7,24(sp)
    8000323e:	e862                	sd	s8,16(sp)
    80003240:	e466                	sd	s9,8(sp)
    80003242:	1080                	addi	s0,sp,96
    80003244:	84aa                	mv	s1,a0
    80003246:	8b2e                	mv	s6,a1
    80003248:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000324a:	00054703          	lbu	a4,0(a0)
    8000324e:	02f00793          	li	a5,47
    80003252:	02f70363          	beq	a4,a5,80003278 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003256:	ffffe097          	auipc	ra,0xffffe
    8000325a:	d4a080e7          	jalr	-694(ra) # 80000fa0 <myproc>
    8000325e:	15853503          	ld	a0,344(a0)
    80003262:	00000097          	auipc	ra,0x0
    80003266:	9f6080e7          	jalr	-1546(ra) # 80002c58 <idup>
    8000326a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000326c:	02f00913          	li	s2,47
  len = path - s;
    80003270:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003272:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003274:	4c05                	li	s8,1
    80003276:	a865                	j	8000332e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003278:	4585                	li	a1,1
    8000327a:	4505                	li	a0,1
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	6e6080e7          	jalr	1766(ra) # 80002962 <iget>
    80003284:	89aa                	mv	s3,a0
    80003286:	b7dd                	j	8000326c <namex+0x42>
      iunlockput(ip);
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	c6e080e7          	jalr	-914(ra) # 80002ef8 <iunlockput>
      return 0;
    80003292:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003294:	854e                	mv	a0,s3
    80003296:	60e6                	ld	ra,88(sp)
    80003298:	6446                	ld	s0,80(sp)
    8000329a:	64a6                	ld	s1,72(sp)
    8000329c:	6906                	ld	s2,64(sp)
    8000329e:	79e2                	ld	s3,56(sp)
    800032a0:	7a42                	ld	s4,48(sp)
    800032a2:	7aa2                	ld	s5,40(sp)
    800032a4:	7b02                	ld	s6,32(sp)
    800032a6:	6be2                	ld	s7,24(sp)
    800032a8:	6c42                	ld	s8,16(sp)
    800032aa:	6ca2                	ld	s9,8(sp)
    800032ac:	6125                	addi	sp,sp,96
    800032ae:	8082                	ret
      iunlock(ip);
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	aa6080e7          	jalr	-1370(ra) # 80002d58 <iunlock>
      return ip;
    800032ba:	bfe9                	j	80003294 <namex+0x6a>
      iunlockput(ip);
    800032bc:	854e                	mv	a0,s3
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	c3a080e7          	jalr	-966(ra) # 80002ef8 <iunlockput>
      return 0;
    800032c6:	89d2                	mv	s3,s4
    800032c8:	b7f1                	j	80003294 <namex+0x6a>
  len = path - s;
    800032ca:	40b48633          	sub	a2,s1,a1
    800032ce:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032d2:	094cd463          	bge	s9,s4,8000335a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032d6:	4639                	li	a2,14
    800032d8:	8556                	mv	a0,s5
    800032da:	ffffd097          	auipc	ra,0xffffd
    800032de:	046080e7          	jalr	70(ra) # 80000320 <memmove>
  while(*path == '/')
    800032e2:	0004c783          	lbu	a5,0(s1)
    800032e6:	01279763          	bne	a5,s2,800032f4 <namex+0xca>
    path++;
    800032ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ec:	0004c783          	lbu	a5,0(s1)
    800032f0:	ff278de3          	beq	a5,s2,800032ea <namex+0xc0>
    ilock(ip);
    800032f4:	854e                	mv	a0,s3
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	9a0080e7          	jalr	-1632(ra) # 80002c96 <ilock>
    if(ip->type != T_DIR){
    800032fe:	04c99783          	lh	a5,76(s3)
    80003302:	f98793e3          	bne	a5,s8,80003288 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003306:	000b0563          	beqz	s6,80003310 <namex+0xe6>
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	d3cd                	beqz	a5,800032b0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003310:	865e                	mv	a2,s7
    80003312:	85d6                	mv	a1,s5
    80003314:	854e                	mv	a0,s3
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	e64080e7          	jalr	-412(ra) # 8000317a <dirlookup>
    8000331e:	8a2a                	mv	s4,a0
    80003320:	dd51                	beqz	a0,800032bc <namex+0x92>
    iunlockput(ip);
    80003322:	854e                	mv	a0,s3
    80003324:	00000097          	auipc	ra,0x0
    80003328:	bd4080e7          	jalr	-1068(ra) # 80002ef8 <iunlockput>
    ip = next;
    8000332c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	05279763          	bne	a5,s2,80003380 <namex+0x156>
    path++;
    80003336:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003338:	0004c783          	lbu	a5,0(s1)
    8000333c:	ff278de3          	beq	a5,s2,80003336 <namex+0x10c>
  if(*path == 0)
    80003340:	c79d                	beqz	a5,8000336e <namex+0x144>
    path++;
    80003342:	85a6                	mv	a1,s1
  len = path - s;
    80003344:	8a5e                	mv	s4,s7
    80003346:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003348:	01278963          	beq	a5,s2,8000335a <namex+0x130>
    8000334c:	dfbd                	beqz	a5,800032ca <namex+0xa0>
    path++;
    8000334e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003350:	0004c783          	lbu	a5,0(s1)
    80003354:	ff279ce3          	bne	a5,s2,8000334c <namex+0x122>
    80003358:	bf8d                	j	800032ca <namex+0xa0>
    memmove(name, s, len);
    8000335a:	2601                	sext.w	a2,a2
    8000335c:	8556                	mv	a0,s5
    8000335e:	ffffd097          	auipc	ra,0xffffd
    80003362:	fc2080e7          	jalr	-62(ra) # 80000320 <memmove>
    name[len] = 0;
    80003366:	9a56                	add	s4,s4,s5
    80003368:	000a0023          	sb	zero,0(s4)
    8000336c:	bf9d                	j	800032e2 <namex+0xb8>
  if(nameiparent){
    8000336e:	f20b03e3          	beqz	s6,80003294 <namex+0x6a>
    iput(ip);
    80003372:	854e                	mv	a0,s3
    80003374:	00000097          	auipc	ra,0x0
    80003378:	adc080e7          	jalr	-1316(ra) # 80002e50 <iput>
    return 0;
    8000337c:	4981                	li	s3,0
    8000337e:	bf19                	j	80003294 <namex+0x6a>
  if(*path == 0)
    80003380:	d7fd                	beqz	a5,8000336e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003382:	0004c783          	lbu	a5,0(s1)
    80003386:	85a6                	mv	a1,s1
    80003388:	b7d1                	j	8000334c <namex+0x122>

000000008000338a <dirlink>:
{
    8000338a:	7139                	addi	sp,sp,-64
    8000338c:	fc06                	sd	ra,56(sp)
    8000338e:	f822                	sd	s0,48(sp)
    80003390:	f426                	sd	s1,40(sp)
    80003392:	f04a                	sd	s2,32(sp)
    80003394:	ec4e                	sd	s3,24(sp)
    80003396:	e852                	sd	s4,16(sp)
    80003398:	0080                	addi	s0,sp,64
    8000339a:	892a                	mv	s2,a0
    8000339c:	8a2e                	mv	s4,a1
    8000339e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033a0:	4601                	li	a2,0
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	dd8080e7          	jalr	-552(ra) # 8000317a <dirlookup>
    800033aa:	e93d                	bnez	a0,80003420 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ac:	05492483          	lw	s1,84(s2)
    800033b0:	c49d                	beqz	s1,800033de <dirlink+0x54>
    800033b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b4:	4741                	li	a4,16
    800033b6:	86a6                	mv	a3,s1
    800033b8:	fc040613          	addi	a2,s0,-64
    800033bc:	4581                	li	a1,0
    800033be:	854a                	mv	a0,s2
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	b8a080e7          	jalr	-1142(ra) # 80002f4a <readi>
    800033c8:	47c1                	li	a5,16
    800033ca:	06f51163          	bne	a0,a5,8000342c <dirlink+0xa2>
    if(de.inum == 0)
    800033ce:	fc045783          	lhu	a5,-64(s0)
    800033d2:	c791                	beqz	a5,800033de <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d4:	24c1                	addiw	s1,s1,16
    800033d6:	05492783          	lw	a5,84(s2)
    800033da:	fcf4ede3          	bltu	s1,a5,800033b4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033de:	4639                	li	a2,14
    800033e0:	85d2                	mv	a1,s4
    800033e2:	fc240513          	addi	a0,s0,-62
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	fee080e7          	jalr	-18(ra) # 800003d4 <strncpy>
  de.inum = inum;
    800033ee:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f2:	4741                	li	a4,16
    800033f4:	86a6                	mv	a3,s1
    800033f6:	fc040613          	addi	a2,s0,-64
    800033fa:	4581                	li	a1,0
    800033fc:	854a                	mv	a0,s2
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	c44080e7          	jalr	-956(ra) # 80003042 <writei>
    80003406:	872a                	mv	a4,a0
    80003408:	47c1                	li	a5,16
  return 0;
    8000340a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000340c:	02f71863          	bne	a4,a5,8000343c <dirlink+0xb2>
}
    80003410:	70e2                	ld	ra,56(sp)
    80003412:	7442                	ld	s0,48(sp)
    80003414:	74a2                	ld	s1,40(sp)
    80003416:	7902                	ld	s2,32(sp)
    80003418:	69e2                	ld	s3,24(sp)
    8000341a:	6a42                	ld	s4,16(sp)
    8000341c:	6121                	addi	sp,sp,64
    8000341e:	8082                	ret
    iput(ip);
    80003420:	00000097          	auipc	ra,0x0
    80003424:	a30080e7          	jalr	-1488(ra) # 80002e50 <iput>
    return -1;
    80003428:	557d                	li	a0,-1
    8000342a:	b7dd                	j	80003410 <dirlink+0x86>
      panic("dirlink read");
    8000342c:	00005517          	auipc	a0,0x5
    80003430:	16c50513          	addi	a0,a0,364 # 80008598 <syscalls+0x1d0>
    80003434:	00003097          	auipc	ra,0x3
    80003438:	c58080e7          	jalr	-936(ra) # 8000608c <panic>
    panic("dirlink");
    8000343c:	00005517          	auipc	a0,0x5
    80003440:	26c50513          	addi	a0,a0,620 # 800086a8 <syscalls+0x2e0>
    80003444:	00003097          	auipc	ra,0x3
    80003448:	c48080e7          	jalr	-952(ra) # 8000608c <panic>

000000008000344c <namei>:

struct inode*
namei(char *path)
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003454:	fe040613          	addi	a2,s0,-32
    80003458:	4581                	li	a1,0
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	dd0080e7          	jalr	-560(ra) # 8000322a <namex>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	6105                	addi	sp,sp,32
    80003468:	8082                	ret

000000008000346a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000346a:	1141                	addi	sp,sp,-16
    8000346c:	e406                	sd	ra,8(sp)
    8000346e:	e022                	sd	s0,0(sp)
    80003470:	0800                	addi	s0,sp,16
    80003472:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003474:	4585                	li	a1,1
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	db4080e7          	jalr	-588(ra) # 8000322a <namex>
}
    8000347e:	60a2                	ld	ra,8(sp)
    80003480:	6402                	ld	s0,0(sp)
    80003482:	0141                	addi	sp,sp,16
    80003484:	8082                	ret

0000000080003486 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003486:	1101                	addi	sp,sp,-32
    80003488:	ec06                	sd	ra,24(sp)
    8000348a:	e822                	sd	s0,16(sp)
    8000348c:	e426                	sd	s1,8(sp)
    8000348e:	e04a                	sd	s2,0(sp)
    80003490:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003492:	0001a917          	auipc	s2,0x1a
    80003496:	8f690913          	addi	s2,s2,-1802 # 8001cd88 <log>
    8000349a:	02092583          	lw	a1,32(s2)
    8000349e:	03092503          	lw	a0,48(s2)
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	f10080e7          	jalr	-240(ra) # 800023b2 <bread>
    800034aa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ac:	03492683          	lw	a3,52(s2)
    800034b0:	d534                	sw	a3,104(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034b2:	02d05763          	blez	a3,800034e0 <write_head+0x5a>
    800034b6:	0001a797          	auipc	a5,0x1a
    800034ba:	90a78793          	addi	a5,a5,-1782 # 8001cdc0 <log+0x38>
    800034be:	06c50713          	addi	a4,a0,108
    800034c2:	36fd                	addiw	a3,a3,-1
    800034c4:	1682                	slli	a3,a3,0x20
    800034c6:	9281                	srli	a3,a3,0x20
    800034c8:	068a                	slli	a3,a3,0x2
    800034ca:	0001a617          	auipc	a2,0x1a
    800034ce:	8fa60613          	addi	a2,a2,-1798 # 8001cdc4 <log+0x3c>
    800034d2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034d4:	4390                	lw	a2,0(a5)
    800034d6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d8:	0791                	addi	a5,a5,4
    800034da:	0711                	addi	a4,a4,4
    800034dc:	fed79ce3          	bne	a5,a3,800034d4 <write_head+0x4e>
  }
  bwrite(buf);
    800034e0:	8526                	mv	a0,s1
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	050080e7          	jalr	80(ra) # 80002532 <bwrite>
  brelse(buf);
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	084080e7          	jalr	132(ra) # 80002570 <brelse>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6902                	ld	s2,0(sp)
    800034fc:	6105                	addi	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003500:	0001a797          	auipc	a5,0x1a
    80003504:	8bc7a783          	lw	a5,-1860(a5) # 8001cdbc <log+0x34>
    80003508:	0af05d63          	blez	a5,800035c2 <install_trans+0xc2>
{
    8000350c:	7139                	addi	sp,sp,-64
    8000350e:	fc06                	sd	ra,56(sp)
    80003510:	f822                	sd	s0,48(sp)
    80003512:	f426                	sd	s1,40(sp)
    80003514:	f04a                	sd	s2,32(sp)
    80003516:	ec4e                	sd	s3,24(sp)
    80003518:	e852                	sd	s4,16(sp)
    8000351a:	e456                	sd	s5,8(sp)
    8000351c:	e05a                	sd	s6,0(sp)
    8000351e:	0080                	addi	s0,sp,64
    80003520:	8b2a                	mv	s6,a0
    80003522:	0001aa97          	auipc	s5,0x1a
    80003526:	89ea8a93          	addi	s5,s5,-1890 # 8001cdc0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000352c:	0001a997          	auipc	s3,0x1a
    80003530:	85c98993          	addi	s3,s3,-1956 # 8001cd88 <log>
    80003534:	a035                	j	80003560 <install_trans+0x60>
      bunpin(dbuf);
    80003536:	8526                	mv	a0,s1
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	144080e7          	jalr	324(ra) # 8000267c <bunpin>
    brelse(lbuf);
    80003540:	854a                	mv	a0,s2
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	02e080e7          	jalr	46(ra) # 80002570 <brelse>
    brelse(dbuf);
    8000354a:	8526                	mv	a0,s1
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	024080e7          	jalr	36(ra) # 80002570 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003554:	2a05                	addiw	s4,s4,1
    80003556:	0a91                	addi	s5,s5,4
    80003558:	0349a783          	lw	a5,52(s3)
    8000355c:	04fa5963          	bge	s4,a5,800035ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003560:	0209a583          	lw	a1,32(s3)
    80003564:	014585bb          	addw	a1,a1,s4
    80003568:	2585                	addiw	a1,a1,1
    8000356a:	0309a503          	lw	a0,48(s3)
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	e44080e7          	jalr	-444(ra) # 800023b2 <bread>
    80003576:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003578:	000aa583          	lw	a1,0(s5)
    8000357c:	0309a503          	lw	a0,48(s3)
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	e32080e7          	jalr	-462(ra) # 800023b2 <bread>
    80003588:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000358a:	40000613          	li	a2,1024
    8000358e:	06890593          	addi	a1,s2,104
    80003592:	06850513          	addi	a0,a0,104
    80003596:	ffffd097          	auipc	ra,0xffffd
    8000359a:	d8a080e7          	jalr	-630(ra) # 80000320 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000359e:	8526                	mv	a0,s1
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	f92080e7          	jalr	-110(ra) # 80002532 <bwrite>
    if(recovering == 0)
    800035a8:	f80b1ce3          	bnez	s6,80003540 <install_trans+0x40>
    800035ac:	b769                	j	80003536 <install_trans+0x36>
}
    800035ae:	70e2                	ld	ra,56(sp)
    800035b0:	7442                	ld	s0,48(sp)
    800035b2:	74a2                	ld	s1,40(sp)
    800035b4:	7902                	ld	s2,32(sp)
    800035b6:	69e2                	ld	s3,24(sp)
    800035b8:	6a42                	ld	s4,16(sp)
    800035ba:	6aa2                	ld	s5,8(sp)
    800035bc:	6b02                	ld	s6,0(sp)
    800035be:	6121                	addi	sp,sp,64
    800035c0:	8082                	ret
    800035c2:	8082                	ret

00000000800035c4 <initlog>:
{
    800035c4:	7179                	addi	sp,sp,-48
    800035c6:	f406                	sd	ra,40(sp)
    800035c8:	f022                	sd	s0,32(sp)
    800035ca:	ec26                	sd	s1,24(sp)
    800035cc:	e84a                	sd	s2,16(sp)
    800035ce:	e44e                	sd	s3,8(sp)
    800035d0:	1800                	addi	s0,sp,48
    800035d2:	892a                	mv	s2,a0
    800035d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035d6:	00019497          	auipc	s1,0x19
    800035da:	7b248493          	addi	s1,s1,1970 # 8001cd88 <log>
    800035de:	00005597          	auipc	a1,0x5
    800035e2:	fca58593          	addi	a1,a1,-54 # 800085a8 <syscalls+0x1e0>
    800035e6:	8526                	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	154080e7          	jalr	340(ra) # 8000673c <initlock>
  log.start = sb->logstart;
    800035f0:	0149a583          	lw	a1,20(s3)
    800035f4:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800035f6:	0109a783          	lw	a5,16(s3)
    800035fa:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800035fc:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003600:	854a                	mv	a0,s2
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	db0080e7          	jalr	-592(ra) # 800023b2 <bread>
  log.lh.n = lh->n;
    8000360a:	553c                	lw	a5,104(a0)
    8000360c:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000360e:	02f05563          	blez	a5,80003638 <initlog+0x74>
    80003612:	06c50713          	addi	a4,a0,108
    80003616:	00019697          	auipc	a3,0x19
    8000361a:	7aa68693          	addi	a3,a3,1962 # 8001cdc0 <log+0x38>
    8000361e:	37fd                	addiw	a5,a5,-1
    80003620:	1782                	slli	a5,a5,0x20
    80003622:	9381                	srli	a5,a5,0x20
    80003624:	078a                	slli	a5,a5,0x2
    80003626:	07050613          	addi	a2,a0,112
    8000362a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000362c:	4310                	lw	a2,0(a4)
    8000362e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003630:	0711                	addi	a4,a4,4
    80003632:	0691                	addi	a3,a3,4
    80003634:	fef71ce3          	bne	a4,a5,8000362c <initlog+0x68>
  brelse(buf);
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	f38080e7          	jalr	-200(ra) # 80002570 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003640:	4505                	li	a0,1
    80003642:	00000097          	auipc	ra,0x0
    80003646:	ebe080e7          	jalr	-322(ra) # 80003500 <install_trans>
  log.lh.n = 0;
    8000364a:	00019797          	auipc	a5,0x19
    8000364e:	7607a923          	sw	zero,1906(a5) # 8001cdbc <log+0x34>
  write_head(); // clear the log
    80003652:	00000097          	auipc	ra,0x0
    80003656:	e34080e7          	jalr	-460(ra) # 80003486 <write_head>
}
    8000365a:	70a2                	ld	ra,40(sp)
    8000365c:	7402                	ld	s0,32(sp)
    8000365e:	64e2                	ld	s1,24(sp)
    80003660:	6942                	ld	s2,16(sp)
    80003662:	69a2                	ld	s3,8(sp)
    80003664:	6145                	addi	sp,sp,48
    80003666:	8082                	ret

0000000080003668 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003668:	1101                	addi	sp,sp,-32
    8000366a:	ec06                	sd	ra,24(sp)
    8000366c:	e822                	sd	s0,16(sp)
    8000366e:	e426                	sd	s1,8(sp)
    80003670:	e04a                	sd	s2,0(sp)
    80003672:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003674:	00019517          	auipc	a0,0x19
    80003678:	71450513          	addi	a0,a0,1812 # 8001cd88 <log>
    8000367c:	00003097          	auipc	ra,0x3
    80003680:	f44080e7          	jalr	-188(ra) # 800065c0 <acquire>
  while(1){
    if(log.committing){
    80003684:	00019497          	auipc	s1,0x19
    80003688:	70448493          	addi	s1,s1,1796 # 8001cd88 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368c:	4979                	li	s2,30
    8000368e:	a039                	j	8000369c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003690:	85a6                	mv	a1,s1
    80003692:	8526                	mv	a0,s1
    80003694:	ffffe097          	auipc	ra,0xffffe
    80003698:	fc8080e7          	jalr	-56(ra) # 8000165c <sleep>
    if(log.committing){
    8000369c:	54dc                	lw	a5,44(s1)
    8000369e:	fbed                	bnez	a5,80003690 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a0:	549c                	lw	a5,40(s1)
    800036a2:	0017871b          	addiw	a4,a5,1
    800036a6:	0007069b          	sext.w	a3,a4
    800036aa:	0027179b          	slliw	a5,a4,0x2
    800036ae:	9fb9                	addw	a5,a5,a4
    800036b0:	0017979b          	slliw	a5,a5,0x1
    800036b4:	58d8                	lw	a4,52(s1)
    800036b6:	9fb9                	addw	a5,a5,a4
    800036b8:	00f95963          	bge	s2,a5,800036ca <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036bc:	85a6                	mv	a1,s1
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	f9c080e7          	jalr	-100(ra) # 8000165c <sleep>
    800036c8:	bfd1                	j	8000369c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ca:	00019517          	auipc	a0,0x19
    800036ce:	6be50513          	addi	a0,a0,1726 # 8001cd88 <log>
    800036d2:	d514                	sw	a3,40(a0)
      release(&log.lock);
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	fbc080e7          	jalr	-68(ra) # 80006690 <release>
      break;
    }
  }
}
    800036dc:	60e2                	ld	ra,24(sp)
    800036de:	6442                	ld	s0,16(sp)
    800036e0:	64a2                	ld	s1,8(sp)
    800036e2:	6902                	ld	s2,0(sp)
    800036e4:	6105                	addi	sp,sp,32
    800036e6:	8082                	ret

00000000800036e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036e8:	7139                	addi	sp,sp,-64
    800036ea:	fc06                	sd	ra,56(sp)
    800036ec:	f822                	sd	s0,48(sp)
    800036ee:	f426                	sd	s1,40(sp)
    800036f0:	f04a                	sd	s2,32(sp)
    800036f2:	ec4e                	sd	s3,24(sp)
    800036f4:	e852                	sd	s4,16(sp)
    800036f6:	e456                	sd	s5,8(sp)
    800036f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036fa:	00019497          	auipc	s1,0x19
    800036fe:	68e48493          	addi	s1,s1,1678 # 8001cd88 <log>
    80003702:	8526                	mv	a0,s1
    80003704:	00003097          	auipc	ra,0x3
    80003708:	ebc080e7          	jalr	-324(ra) # 800065c0 <acquire>
  log.outstanding -= 1;
    8000370c:	549c                	lw	a5,40(s1)
    8000370e:	37fd                	addiw	a5,a5,-1
    80003710:	0007891b          	sext.w	s2,a5
    80003714:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003716:	54dc                	lw	a5,44(s1)
    80003718:	efb9                	bnez	a5,80003776 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000371a:	06091663          	bnez	s2,80003786 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000371e:	00019497          	auipc	s1,0x19
    80003722:	66a48493          	addi	s1,s1,1642 # 8001cd88 <log>
    80003726:	4785                	li	a5,1
    80003728:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000372a:	8526                	mv	a0,s1
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	f64080e7          	jalr	-156(ra) # 80006690 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003734:	58dc                	lw	a5,52(s1)
    80003736:	06f04763          	bgtz	a5,800037a4 <end_op+0xbc>
    acquire(&log.lock);
    8000373a:	00019497          	auipc	s1,0x19
    8000373e:	64e48493          	addi	s1,s1,1614 # 8001cd88 <log>
    80003742:	8526                	mv	a0,s1
    80003744:	00003097          	auipc	ra,0x3
    80003748:	e7c080e7          	jalr	-388(ra) # 800065c0 <acquire>
    log.committing = 0;
    8000374c:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003750:	8526                	mv	a0,s1
    80003752:	ffffe097          	auipc	ra,0xffffe
    80003756:	096080e7          	jalr	150(ra) # 800017e8 <wakeup>
    release(&log.lock);
    8000375a:	8526                	mv	a0,s1
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	f34080e7          	jalr	-204(ra) # 80006690 <release>
}
    80003764:	70e2                	ld	ra,56(sp)
    80003766:	7442                	ld	s0,48(sp)
    80003768:	74a2                	ld	s1,40(sp)
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	6121                	addi	sp,sp,64
    80003774:	8082                	ret
    panic("log.committing");
    80003776:	00005517          	auipc	a0,0x5
    8000377a:	e3a50513          	addi	a0,a0,-454 # 800085b0 <syscalls+0x1e8>
    8000377e:	00003097          	auipc	ra,0x3
    80003782:	90e080e7          	jalr	-1778(ra) # 8000608c <panic>
    wakeup(&log);
    80003786:	00019497          	auipc	s1,0x19
    8000378a:	60248493          	addi	s1,s1,1538 # 8001cd88 <log>
    8000378e:	8526                	mv	a0,s1
    80003790:	ffffe097          	auipc	ra,0xffffe
    80003794:	058080e7          	jalr	88(ra) # 800017e8 <wakeup>
  release(&log.lock);
    80003798:	8526                	mv	a0,s1
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	ef6080e7          	jalr	-266(ra) # 80006690 <release>
  if(do_commit){
    800037a2:	b7c9                	j	80003764 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a4:	00019a97          	auipc	s5,0x19
    800037a8:	61ca8a93          	addi	s5,s5,1564 # 8001cdc0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037ac:	00019a17          	auipc	s4,0x19
    800037b0:	5dca0a13          	addi	s4,s4,1500 # 8001cd88 <log>
    800037b4:	020a2583          	lw	a1,32(s4)
    800037b8:	012585bb          	addw	a1,a1,s2
    800037bc:	2585                	addiw	a1,a1,1
    800037be:	030a2503          	lw	a0,48(s4)
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	bf0080e7          	jalr	-1040(ra) # 800023b2 <bread>
    800037ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037cc:	000aa583          	lw	a1,0(s5)
    800037d0:	030a2503          	lw	a0,48(s4)
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	bde080e7          	jalr	-1058(ra) # 800023b2 <bread>
    800037dc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037de:	40000613          	li	a2,1024
    800037e2:	06850593          	addi	a1,a0,104
    800037e6:	06848513          	addi	a0,s1,104
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	b36080e7          	jalr	-1226(ra) # 80000320 <memmove>
    bwrite(to);  // write the log
    800037f2:	8526                	mv	a0,s1
    800037f4:	fffff097          	auipc	ra,0xfffff
    800037f8:	d3e080e7          	jalr	-706(ra) # 80002532 <bwrite>
    brelse(from);
    800037fc:	854e                	mv	a0,s3
    800037fe:	fffff097          	auipc	ra,0xfffff
    80003802:	d72080e7          	jalr	-654(ra) # 80002570 <brelse>
    brelse(to);
    80003806:	8526                	mv	a0,s1
    80003808:	fffff097          	auipc	ra,0xfffff
    8000380c:	d68080e7          	jalr	-664(ra) # 80002570 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003810:	2905                	addiw	s2,s2,1
    80003812:	0a91                	addi	s5,s5,4
    80003814:	034a2783          	lw	a5,52(s4)
    80003818:	f8f94ee3          	blt	s2,a5,800037b4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	c6a080e7          	jalr	-918(ra) # 80003486 <write_head>
    install_trans(0); // Now install writes to home locations
    80003824:	4501                	li	a0,0
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	cda080e7          	jalr	-806(ra) # 80003500 <install_trans>
    log.lh.n = 0;
    8000382e:	00019797          	auipc	a5,0x19
    80003832:	5807a723          	sw	zero,1422(a5) # 8001cdbc <log+0x34>
    write_head();    // Erase the transaction from the log
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	c50080e7          	jalr	-944(ra) # 80003486 <write_head>
    8000383e:	bdf5                	j	8000373a <end_op+0x52>

0000000080003840 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003840:	1101                	addi	sp,sp,-32
    80003842:	ec06                	sd	ra,24(sp)
    80003844:	e822                	sd	s0,16(sp)
    80003846:	e426                	sd	s1,8(sp)
    80003848:	e04a                	sd	s2,0(sp)
    8000384a:	1000                	addi	s0,sp,32
    8000384c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000384e:	00019917          	auipc	s2,0x19
    80003852:	53a90913          	addi	s2,s2,1338 # 8001cd88 <log>
    80003856:	854a                	mv	a0,s2
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	d68080e7          	jalr	-664(ra) # 800065c0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003860:	03492603          	lw	a2,52(s2)
    80003864:	47f5                	li	a5,29
    80003866:	06c7c563          	blt	a5,a2,800038d0 <log_write+0x90>
    8000386a:	00019797          	auipc	a5,0x19
    8000386e:	5427a783          	lw	a5,1346(a5) # 8001cdac <log+0x24>
    80003872:	37fd                	addiw	a5,a5,-1
    80003874:	04f65e63          	bge	a2,a5,800038d0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003878:	00019797          	auipc	a5,0x19
    8000387c:	5387a783          	lw	a5,1336(a5) # 8001cdb0 <log+0x28>
    80003880:	06f05063          	blez	a5,800038e0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003884:	4781                	li	a5,0
    80003886:	06c05563          	blez	a2,800038f0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000388a:	488c                	lw	a1,16(s1)
    8000388c:	00019717          	auipc	a4,0x19
    80003890:	53470713          	addi	a4,a4,1332 # 8001cdc0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003894:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003896:	4314                	lw	a3,0(a4)
    80003898:	04b68c63          	beq	a3,a1,800038f0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000389c:	2785                	addiw	a5,a5,1
    8000389e:	0711                	addi	a4,a4,4
    800038a0:	fef61be3          	bne	a2,a5,80003896 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038a4:	0631                	addi	a2,a2,12
    800038a6:	060a                	slli	a2,a2,0x2
    800038a8:	00019797          	auipc	a5,0x19
    800038ac:	4e078793          	addi	a5,a5,1248 # 8001cd88 <log>
    800038b0:	963e                	add	a2,a2,a5
    800038b2:	489c                	lw	a5,16(s1)
    800038b4:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038b6:	8526                	mv	a0,s1
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	d66080e7          	jalr	-666(ra) # 8000261e <bpin>
    log.lh.n++;
    800038c0:	00019717          	auipc	a4,0x19
    800038c4:	4c870713          	addi	a4,a4,1224 # 8001cd88 <log>
    800038c8:	5b5c                	lw	a5,52(a4)
    800038ca:	2785                	addiw	a5,a5,1
    800038cc:	db5c                	sw	a5,52(a4)
    800038ce:	a835                	j	8000390a <log_write+0xca>
    panic("too big a transaction");
    800038d0:	00005517          	auipc	a0,0x5
    800038d4:	cf050513          	addi	a0,a0,-784 # 800085c0 <syscalls+0x1f8>
    800038d8:	00002097          	auipc	ra,0x2
    800038dc:	7b4080e7          	jalr	1972(ra) # 8000608c <panic>
    panic("log_write outside of trans");
    800038e0:	00005517          	auipc	a0,0x5
    800038e4:	cf850513          	addi	a0,a0,-776 # 800085d8 <syscalls+0x210>
    800038e8:	00002097          	auipc	ra,0x2
    800038ec:	7a4080e7          	jalr	1956(ra) # 8000608c <panic>
  log.lh.block[i] = b->blockno;
    800038f0:	00c78713          	addi	a4,a5,12
    800038f4:	00271693          	slli	a3,a4,0x2
    800038f8:	00019717          	auipc	a4,0x19
    800038fc:	49070713          	addi	a4,a4,1168 # 8001cd88 <log>
    80003900:	9736                	add	a4,a4,a3
    80003902:	4894                	lw	a3,16(s1)
    80003904:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003906:	faf608e3          	beq	a2,a5,800038b6 <log_write+0x76>
  }
  release(&log.lock);
    8000390a:	00019517          	auipc	a0,0x19
    8000390e:	47e50513          	addi	a0,a0,1150 # 8001cd88 <log>
    80003912:	00003097          	auipc	ra,0x3
    80003916:	d7e080e7          	jalr	-642(ra) # 80006690 <release>
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003926:	1101                	addi	sp,sp,-32
    80003928:	ec06                	sd	ra,24(sp)
    8000392a:	e822                	sd	s0,16(sp)
    8000392c:	e426                	sd	s1,8(sp)
    8000392e:	e04a                	sd	s2,0(sp)
    80003930:	1000                	addi	s0,sp,32
    80003932:	84aa                	mv	s1,a0
    80003934:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003936:	00005597          	auipc	a1,0x5
    8000393a:	cc258593          	addi	a1,a1,-830 # 800085f8 <syscalls+0x230>
    8000393e:	0521                	addi	a0,a0,8
    80003940:	00003097          	auipc	ra,0x3
    80003944:	dfc080e7          	jalr	-516(ra) # 8000673c <initlock>
  lk->name = name;
    80003948:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    8000394c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003950:	0204a823          	sw	zero,48(s1)
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003960:	1101                	addi	sp,sp,-32
    80003962:	ec06                	sd	ra,24(sp)
    80003964:	e822                	sd	s0,16(sp)
    80003966:	e426                	sd	s1,8(sp)
    80003968:	e04a                	sd	s2,0(sp)
    8000396a:	1000                	addi	s0,sp,32
    8000396c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000396e:	00850913          	addi	s2,a0,8
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	c4c080e7          	jalr	-948(ra) # 800065c0 <acquire>
  while (lk->locked) {
    8000397c:	409c                	lw	a5,0(s1)
    8000397e:	cb89                	beqz	a5,80003990 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003980:	85ca                	mv	a1,s2
    80003982:	8526                	mv	a0,s1
    80003984:	ffffe097          	auipc	ra,0xffffe
    80003988:	cd8080e7          	jalr	-808(ra) # 8000165c <sleep>
  while (lk->locked) {
    8000398c:	409c                	lw	a5,0(s1)
    8000398e:	fbed                	bnez	a5,80003980 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003990:	4785                	li	a5,1
    80003992:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	60c080e7          	jalr	1548(ra) # 80000fa0 <myproc>
    8000399c:	5d1c                	lw	a5,56(a0)
    8000399e:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    800039a0:	854a                	mv	a0,s2
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	cee080e7          	jalr	-786(ra) # 80006690 <release>
}
    800039aa:	60e2                	ld	ra,24(sp)
    800039ac:	6442                	ld	s0,16(sp)
    800039ae:	64a2                	ld	s1,8(sp)
    800039b0:	6902                	ld	s2,0(sp)
    800039b2:	6105                	addi	sp,sp,32
    800039b4:	8082                	ret

00000000800039b6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	e04a                	sd	s2,0(sp)
    800039c0:	1000                	addi	s0,sp,32
    800039c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c4:	00850913          	addi	s2,a0,8
    800039c8:	854a                	mv	a0,s2
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	bf6080e7          	jalr	-1034(ra) # 800065c0 <acquire>
  lk->locked = 0;
    800039d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d6:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffe097          	auipc	ra,0xffffe
    800039e0:	e0c080e7          	jalr	-500(ra) # 800017e8 <wakeup>
  release(&lk->lk);
    800039e4:	854a                	mv	a0,s2
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	caa080e7          	jalr	-854(ra) # 80006690 <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039fa:	7179                	addi	sp,sp,-48
    800039fc:	f406                	sd	ra,40(sp)
    800039fe:	f022                	sd	s0,32(sp)
    80003a00:	ec26                	sd	s1,24(sp)
    80003a02:	e84a                	sd	s2,16(sp)
    80003a04:	e44e                	sd	s3,8(sp)
    80003a06:	1800                	addi	s0,sp,48
    80003a08:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a0a:	00850913          	addi	s2,a0,8
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	bb0080e7          	jalr	-1104(ra) # 800065c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	ef99                	bnez	a5,80003a38 <holdingsleep+0x3e>
    80003a1c:	4481                	li	s1,0
  release(&lk->lk);
    80003a1e:	854a                	mv	a0,s2
    80003a20:	00003097          	auipc	ra,0x3
    80003a24:	c70080e7          	jalr	-912(ra) # 80006690 <release>
  return r;
}
    80003a28:	8526                	mv	a0,s1
    80003a2a:	70a2                	ld	ra,40(sp)
    80003a2c:	7402                	ld	s0,32(sp)
    80003a2e:	64e2                	ld	s1,24(sp)
    80003a30:	6942                	ld	s2,16(sp)
    80003a32:	69a2                	ld	s3,8(sp)
    80003a34:	6145                	addi	sp,sp,48
    80003a36:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a38:	0304a983          	lw	s3,48(s1)
    80003a3c:	ffffd097          	auipc	ra,0xffffd
    80003a40:	564080e7          	jalr	1380(ra) # 80000fa0 <myproc>
    80003a44:	5d04                	lw	s1,56(a0)
    80003a46:	413484b3          	sub	s1,s1,s3
    80003a4a:	0014b493          	seqz	s1,s1
    80003a4e:	bfc1                	j	80003a1e <holdingsleep+0x24>

0000000080003a50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a50:	1141                	addi	sp,sp,-16
    80003a52:	e406                	sd	ra,8(sp)
    80003a54:	e022                	sd	s0,0(sp)
    80003a56:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a58:	00005597          	auipc	a1,0x5
    80003a5c:	bb058593          	addi	a1,a1,-1104 # 80008608 <syscalls+0x240>
    80003a60:	00019517          	auipc	a0,0x19
    80003a64:	47850513          	addi	a0,a0,1144 # 8001ced8 <ftable>
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	cd4080e7          	jalr	-812(ra) # 8000673c <initlock>
}
    80003a70:	60a2                	ld	ra,8(sp)
    80003a72:	6402                	ld	s0,0(sp)
    80003a74:	0141                	addi	sp,sp,16
    80003a76:	8082                	ret

0000000080003a78 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	e426                	sd	s1,8(sp)
    80003a80:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a82:	00019517          	auipc	a0,0x19
    80003a86:	45650513          	addi	a0,a0,1110 # 8001ced8 <ftable>
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	b36080e7          	jalr	-1226(ra) # 800065c0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a92:	00019497          	auipc	s1,0x19
    80003a96:	46648493          	addi	s1,s1,1126 # 8001cef8 <ftable+0x20>
    80003a9a:	0001a717          	auipc	a4,0x1a
    80003a9e:	3fe70713          	addi	a4,a4,1022 # 8001de98 <ftable+0xfc0>
    if(f->ref == 0){
    80003aa2:	40dc                	lw	a5,4(s1)
    80003aa4:	cf99                	beqz	a5,80003ac2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa6:	02848493          	addi	s1,s1,40
    80003aaa:	fee49ce3          	bne	s1,a4,80003aa2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aae:	00019517          	auipc	a0,0x19
    80003ab2:	42a50513          	addi	a0,a0,1066 # 8001ced8 <ftable>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	bda080e7          	jalr	-1062(ra) # 80006690 <release>
  return 0;
    80003abe:	4481                	li	s1,0
    80003ac0:	a819                	j	80003ad6 <filealloc+0x5e>
      f->ref = 1;
    80003ac2:	4785                	li	a5,1
    80003ac4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ac6:	00019517          	auipc	a0,0x19
    80003aca:	41250513          	addi	a0,a0,1042 # 8001ced8 <ftable>
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	bc2080e7          	jalr	-1086(ra) # 80006690 <release>
}
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	60e2                	ld	ra,24(sp)
    80003ada:	6442                	ld	s0,16(sp)
    80003adc:	64a2                	ld	s1,8(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ae2:	1101                	addi	sp,sp,-32
    80003ae4:	ec06                	sd	ra,24(sp)
    80003ae6:	e822                	sd	s0,16(sp)
    80003ae8:	e426                	sd	s1,8(sp)
    80003aea:	1000                	addi	s0,sp,32
    80003aec:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aee:	00019517          	auipc	a0,0x19
    80003af2:	3ea50513          	addi	a0,a0,1002 # 8001ced8 <ftable>
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	aca080e7          	jalr	-1334(ra) # 800065c0 <acquire>
  if(f->ref < 1)
    80003afe:	40dc                	lw	a5,4(s1)
    80003b00:	02f05263          	blez	a5,80003b24 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b04:	2785                	addiw	a5,a5,1
    80003b06:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b08:	00019517          	auipc	a0,0x19
    80003b0c:	3d050513          	addi	a0,a0,976 # 8001ced8 <ftable>
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	b80080e7          	jalr	-1152(ra) # 80006690 <release>
  return f;
}
    80003b18:	8526                	mv	a0,s1
    80003b1a:	60e2                	ld	ra,24(sp)
    80003b1c:	6442                	ld	s0,16(sp)
    80003b1e:	64a2                	ld	s1,8(sp)
    80003b20:	6105                	addi	sp,sp,32
    80003b22:	8082                	ret
    panic("filedup");
    80003b24:	00005517          	auipc	a0,0x5
    80003b28:	aec50513          	addi	a0,a0,-1300 # 80008610 <syscalls+0x248>
    80003b2c:	00002097          	auipc	ra,0x2
    80003b30:	560080e7          	jalr	1376(ra) # 8000608c <panic>

0000000080003b34 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b34:	7139                	addi	sp,sp,-64
    80003b36:	fc06                	sd	ra,56(sp)
    80003b38:	f822                	sd	s0,48(sp)
    80003b3a:	f426                	sd	s1,40(sp)
    80003b3c:	f04a                	sd	s2,32(sp)
    80003b3e:	ec4e                	sd	s3,24(sp)
    80003b40:	e852                	sd	s4,16(sp)
    80003b42:	e456                	sd	s5,8(sp)
    80003b44:	0080                	addi	s0,sp,64
    80003b46:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b48:	00019517          	auipc	a0,0x19
    80003b4c:	39050513          	addi	a0,a0,912 # 8001ced8 <ftable>
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	a70080e7          	jalr	-1424(ra) # 800065c0 <acquire>
  if(f->ref < 1)
    80003b58:	40dc                	lw	a5,4(s1)
    80003b5a:	06f05163          	blez	a5,80003bbc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b5e:	37fd                	addiw	a5,a5,-1
    80003b60:	0007871b          	sext.w	a4,a5
    80003b64:	c0dc                	sw	a5,4(s1)
    80003b66:	06e04363          	bgtz	a4,80003bcc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b6a:	0004a903          	lw	s2,0(s1)
    80003b6e:	0094ca83          	lbu	s5,9(s1)
    80003b72:	0104ba03          	ld	s4,16(s1)
    80003b76:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b7a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b7e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b82:	00019517          	auipc	a0,0x19
    80003b86:	35650513          	addi	a0,a0,854 # 8001ced8 <ftable>
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	b06080e7          	jalr	-1274(ra) # 80006690 <release>

  if(ff.type == FD_PIPE){
    80003b92:	4785                	li	a5,1
    80003b94:	04f90d63          	beq	s2,a5,80003bee <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b98:	3979                	addiw	s2,s2,-2
    80003b9a:	4785                	li	a5,1
    80003b9c:	0527e063          	bltu	a5,s2,80003bdc <fileclose+0xa8>
    begin_op();
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	ac8080e7          	jalr	-1336(ra) # 80003668 <begin_op>
    iput(ff.ip);
    80003ba8:	854e                	mv	a0,s3
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	2a6080e7          	jalr	678(ra) # 80002e50 <iput>
    end_op();
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	b36080e7          	jalr	-1226(ra) # 800036e8 <end_op>
    80003bba:	a00d                	j	80003bdc <fileclose+0xa8>
    panic("fileclose");
    80003bbc:	00005517          	auipc	a0,0x5
    80003bc0:	a5c50513          	addi	a0,a0,-1444 # 80008618 <syscalls+0x250>
    80003bc4:	00002097          	auipc	ra,0x2
    80003bc8:	4c8080e7          	jalr	1224(ra) # 8000608c <panic>
    release(&ftable.lock);
    80003bcc:	00019517          	auipc	a0,0x19
    80003bd0:	30c50513          	addi	a0,a0,780 # 8001ced8 <ftable>
    80003bd4:	00003097          	auipc	ra,0x3
    80003bd8:	abc080e7          	jalr	-1348(ra) # 80006690 <release>
  }
}
    80003bdc:	70e2                	ld	ra,56(sp)
    80003bde:	7442                	ld	s0,48(sp)
    80003be0:	74a2                	ld	s1,40(sp)
    80003be2:	7902                	ld	s2,32(sp)
    80003be4:	69e2                	ld	s3,24(sp)
    80003be6:	6a42                	ld	s4,16(sp)
    80003be8:	6aa2                	ld	s5,8(sp)
    80003bea:	6121                	addi	sp,sp,64
    80003bec:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bee:	85d6                	mv	a1,s5
    80003bf0:	8552                	mv	a0,s4
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	34c080e7          	jalr	844(ra) # 80003f3e <pipeclose>
    80003bfa:	b7cd                	j	80003bdc <fileclose+0xa8>

0000000080003bfc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bfc:	715d                	addi	sp,sp,-80
    80003bfe:	e486                	sd	ra,72(sp)
    80003c00:	e0a2                	sd	s0,64(sp)
    80003c02:	fc26                	sd	s1,56(sp)
    80003c04:	f84a                	sd	s2,48(sp)
    80003c06:	f44e                	sd	s3,40(sp)
    80003c08:	0880                	addi	s0,sp,80
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	392080e7          	jalr	914(ra) # 80000fa0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c16:	409c                	lw	a5,0(s1)
    80003c18:	37f9                	addiw	a5,a5,-2
    80003c1a:	4705                	li	a4,1
    80003c1c:	04f76763          	bltu	a4,a5,80003c6a <filestat+0x6e>
    80003c20:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c22:	6c88                	ld	a0,24(s1)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	072080e7          	jalr	114(ra) # 80002c96 <ilock>
    stati(f->ip, &st);
    80003c2c:	fb840593          	addi	a1,s0,-72
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	2ee080e7          	jalr	750(ra) # 80002f20 <stati>
    iunlock(f->ip);
    80003c3a:	6c88                	ld	a0,24(s1)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	11c080e7          	jalr	284(ra) # 80002d58 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c44:	46e1                	li	a3,24
    80003c46:	fb840613          	addi	a2,s0,-72
    80003c4a:	85ce                	mv	a1,s3
    80003c4c:	05893503          	ld	a0,88(s2)
    80003c50:	ffffd097          	auipc	ra,0xffffd
    80003c54:	012080e7          	jalr	18(ra) # 80000c62 <copyout>
    80003c58:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c5c:	60a6                	ld	ra,72(sp)
    80003c5e:	6406                	ld	s0,64(sp)
    80003c60:	74e2                	ld	s1,56(sp)
    80003c62:	7942                	ld	s2,48(sp)
    80003c64:	79a2                	ld	s3,40(sp)
    80003c66:	6161                	addi	sp,sp,80
    80003c68:	8082                	ret
  return -1;
    80003c6a:	557d                	li	a0,-1
    80003c6c:	bfc5                	j	80003c5c <filestat+0x60>

0000000080003c6e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c6e:	7179                	addi	sp,sp,-48
    80003c70:	f406                	sd	ra,40(sp)
    80003c72:	f022                	sd	s0,32(sp)
    80003c74:	ec26                	sd	s1,24(sp)
    80003c76:	e84a                	sd	s2,16(sp)
    80003c78:	e44e                	sd	s3,8(sp)
    80003c7a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c7c:	00854783          	lbu	a5,8(a0)
    80003c80:	c3d5                	beqz	a5,80003d24 <fileread+0xb6>
    80003c82:	84aa                	mv	s1,a0
    80003c84:	89ae                	mv	s3,a1
    80003c86:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c88:	411c                	lw	a5,0(a0)
    80003c8a:	4705                	li	a4,1
    80003c8c:	04e78963          	beq	a5,a4,80003cde <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c90:	470d                	li	a4,3
    80003c92:	04e78d63          	beq	a5,a4,80003cec <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c96:	4709                	li	a4,2
    80003c98:	06e79e63          	bne	a5,a4,80003d14 <fileread+0xa6>
    ilock(f->ip);
    80003c9c:	6d08                	ld	a0,24(a0)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	ff8080e7          	jalr	-8(ra) # 80002c96 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ca6:	874a                	mv	a4,s2
    80003ca8:	5094                	lw	a3,32(s1)
    80003caa:	864e                	mv	a2,s3
    80003cac:	4585                	li	a1,1
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	29a080e7          	jalr	666(ra) # 80002f4a <readi>
    80003cb8:	892a                	mv	s2,a0
    80003cba:	00a05563          	blez	a0,80003cc4 <fileread+0x56>
      f->off += r;
    80003cbe:	509c                	lw	a5,32(s1)
    80003cc0:	9fa9                	addw	a5,a5,a0
    80003cc2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cc4:	6c88                	ld	a0,24(s1)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	092080e7          	jalr	146(ra) # 80002d58 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cce:	854a                	mv	a0,s2
    80003cd0:	70a2                	ld	ra,40(sp)
    80003cd2:	7402                	ld	s0,32(sp)
    80003cd4:	64e2                	ld	s1,24(sp)
    80003cd6:	6942                	ld	s2,16(sp)
    80003cd8:	69a2                	ld	s3,8(sp)
    80003cda:	6145                	addi	sp,sp,48
    80003cdc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cde:	6908                	ld	a0,16(a0)
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	3d2080e7          	jalr	978(ra) # 800040b2 <piperead>
    80003ce8:	892a                	mv	s2,a0
    80003cea:	b7d5                	j	80003cce <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cec:	02451783          	lh	a5,36(a0)
    80003cf0:	03079693          	slli	a3,a5,0x30
    80003cf4:	92c1                	srli	a3,a3,0x30
    80003cf6:	4725                	li	a4,9
    80003cf8:	02d76863          	bltu	a4,a3,80003d28 <fileread+0xba>
    80003cfc:	0792                	slli	a5,a5,0x4
    80003cfe:	00019717          	auipc	a4,0x19
    80003d02:	13a70713          	addi	a4,a4,314 # 8001ce38 <devsw>
    80003d06:	97ba                	add	a5,a5,a4
    80003d08:	639c                	ld	a5,0(a5)
    80003d0a:	c38d                	beqz	a5,80003d2c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d0c:	4505                	li	a0,1
    80003d0e:	9782                	jalr	a5
    80003d10:	892a                	mv	s2,a0
    80003d12:	bf75                	j	80003cce <fileread+0x60>
    panic("fileread");
    80003d14:	00005517          	auipc	a0,0x5
    80003d18:	91450513          	addi	a0,a0,-1772 # 80008628 <syscalls+0x260>
    80003d1c:	00002097          	auipc	ra,0x2
    80003d20:	370080e7          	jalr	880(ra) # 8000608c <panic>
    return -1;
    80003d24:	597d                	li	s2,-1
    80003d26:	b765                	j	80003cce <fileread+0x60>
      return -1;
    80003d28:	597d                	li	s2,-1
    80003d2a:	b755                	j	80003cce <fileread+0x60>
    80003d2c:	597d                	li	s2,-1
    80003d2e:	b745                	j	80003cce <fileread+0x60>

0000000080003d30 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d30:	715d                	addi	sp,sp,-80
    80003d32:	e486                	sd	ra,72(sp)
    80003d34:	e0a2                	sd	s0,64(sp)
    80003d36:	fc26                	sd	s1,56(sp)
    80003d38:	f84a                	sd	s2,48(sp)
    80003d3a:	f44e                	sd	s3,40(sp)
    80003d3c:	f052                	sd	s4,32(sp)
    80003d3e:	ec56                	sd	s5,24(sp)
    80003d40:	e85a                	sd	s6,16(sp)
    80003d42:	e45e                	sd	s7,8(sp)
    80003d44:	e062                	sd	s8,0(sp)
    80003d46:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d48:	00954783          	lbu	a5,9(a0)
    80003d4c:	10078663          	beqz	a5,80003e58 <filewrite+0x128>
    80003d50:	892a                	mv	s2,a0
    80003d52:	8aae                	mv	s5,a1
    80003d54:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d56:	411c                	lw	a5,0(a0)
    80003d58:	4705                	li	a4,1
    80003d5a:	02e78263          	beq	a5,a4,80003d7e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5e:	470d                	li	a4,3
    80003d60:	02e78663          	beq	a5,a4,80003d8c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d64:	4709                	li	a4,2
    80003d66:	0ee79163          	bne	a5,a4,80003e48 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d6a:	0ac05d63          	blez	a2,80003e24 <filewrite+0xf4>
    int i = 0;
    80003d6e:	4981                	li	s3,0
    80003d70:	6b05                	lui	s6,0x1
    80003d72:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d76:	6b85                	lui	s7,0x1
    80003d78:	c00b8b9b          	addiw	s7,s7,-1024
    80003d7c:	a861                	j	80003e14 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d7e:	6908                	ld	a0,16(a0)
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	238080e7          	jalr	568(ra) # 80003fb8 <pipewrite>
    80003d88:	8a2a                	mv	s4,a0
    80003d8a:	a045                	j	80003e2a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d8c:	02451783          	lh	a5,36(a0)
    80003d90:	03079693          	slli	a3,a5,0x30
    80003d94:	92c1                	srli	a3,a3,0x30
    80003d96:	4725                	li	a4,9
    80003d98:	0cd76263          	bltu	a4,a3,80003e5c <filewrite+0x12c>
    80003d9c:	0792                	slli	a5,a5,0x4
    80003d9e:	00019717          	auipc	a4,0x19
    80003da2:	09a70713          	addi	a4,a4,154 # 8001ce38 <devsw>
    80003da6:	97ba                	add	a5,a5,a4
    80003da8:	679c                	ld	a5,8(a5)
    80003daa:	cbdd                	beqz	a5,80003e60 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dac:	4505                	li	a0,1
    80003dae:	9782                	jalr	a5
    80003db0:	8a2a                	mv	s4,a0
    80003db2:	a8a5                	j	80003e2a <filewrite+0xfa>
    80003db4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	8b0080e7          	jalr	-1872(ra) # 80003668 <begin_op>
      ilock(f->ip);
    80003dc0:	01893503          	ld	a0,24(s2)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	ed2080e7          	jalr	-302(ra) # 80002c96 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dcc:	8762                	mv	a4,s8
    80003dce:	02092683          	lw	a3,32(s2)
    80003dd2:	01598633          	add	a2,s3,s5
    80003dd6:	4585                	li	a1,1
    80003dd8:	01893503          	ld	a0,24(s2)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	266080e7          	jalr	614(ra) # 80003042 <writei>
    80003de4:	84aa                	mv	s1,a0
    80003de6:	00a05763          	blez	a0,80003df4 <filewrite+0xc4>
        f->off += r;
    80003dea:	02092783          	lw	a5,32(s2)
    80003dee:	9fa9                	addw	a5,a5,a0
    80003df0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003df4:	01893503          	ld	a0,24(s2)
    80003df8:	fffff097          	auipc	ra,0xfffff
    80003dfc:	f60080e7          	jalr	-160(ra) # 80002d58 <iunlock>
      end_op();
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	8e8080e7          	jalr	-1816(ra) # 800036e8 <end_op>

      if(r != n1){
    80003e08:	009c1f63          	bne	s8,s1,80003e26 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e0c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e10:	0149db63          	bge	s3,s4,80003e26 <filewrite+0xf6>
      int n1 = n - i;
    80003e14:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e18:	84be                	mv	s1,a5
    80003e1a:	2781                	sext.w	a5,a5
    80003e1c:	f8fb5ce3          	bge	s6,a5,80003db4 <filewrite+0x84>
    80003e20:	84de                	mv	s1,s7
    80003e22:	bf49                	j	80003db4 <filewrite+0x84>
    int i = 0;
    80003e24:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e26:	013a1f63          	bne	s4,s3,80003e44 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	60a6                	ld	ra,72(sp)
    80003e2e:	6406                	ld	s0,64(sp)
    80003e30:	74e2                	ld	s1,56(sp)
    80003e32:	7942                	ld	s2,48(sp)
    80003e34:	79a2                	ld	s3,40(sp)
    80003e36:	7a02                	ld	s4,32(sp)
    80003e38:	6ae2                	ld	s5,24(sp)
    80003e3a:	6b42                	ld	s6,16(sp)
    80003e3c:	6ba2                	ld	s7,8(sp)
    80003e3e:	6c02                	ld	s8,0(sp)
    80003e40:	6161                	addi	sp,sp,80
    80003e42:	8082                	ret
    ret = (i == n ? n : -1);
    80003e44:	5a7d                	li	s4,-1
    80003e46:	b7d5                	j	80003e2a <filewrite+0xfa>
    panic("filewrite");
    80003e48:	00004517          	auipc	a0,0x4
    80003e4c:	7f050513          	addi	a0,a0,2032 # 80008638 <syscalls+0x270>
    80003e50:	00002097          	auipc	ra,0x2
    80003e54:	23c080e7          	jalr	572(ra) # 8000608c <panic>
    return -1;
    80003e58:	5a7d                	li	s4,-1
    80003e5a:	bfc1                	j	80003e2a <filewrite+0xfa>
      return -1;
    80003e5c:	5a7d                	li	s4,-1
    80003e5e:	b7f1                	j	80003e2a <filewrite+0xfa>
    80003e60:	5a7d                	li	s4,-1
    80003e62:	b7e1                	j	80003e2a <filewrite+0xfa>

0000000080003e64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e64:	7179                	addi	sp,sp,-48
    80003e66:	f406                	sd	ra,40(sp)
    80003e68:	f022                	sd	s0,32(sp)
    80003e6a:	ec26                	sd	s1,24(sp)
    80003e6c:	e84a                	sd	s2,16(sp)
    80003e6e:	e44e                	sd	s3,8(sp)
    80003e70:	e052                	sd	s4,0(sp)
    80003e72:	1800                	addi	s0,sp,48
    80003e74:	84aa                	mv	s1,a0
    80003e76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e78:	0005b023          	sd	zero,0(a1)
    80003e7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	bf8080e7          	jalr	-1032(ra) # 80003a78 <filealloc>
    80003e88:	e088                	sd	a0,0(s1)
    80003e8a:	c551                	beqz	a0,80003f16 <pipealloc+0xb2>
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	bec080e7          	jalr	-1044(ra) # 80003a78 <filealloc>
    80003e94:	00aa3023          	sd	a0,0(s4)
    80003e98:	c92d                	beqz	a0,80003f0a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e9a:	ffffc097          	auipc	ra,0xffffc
    80003e9e:	2e2080e7          	jalr	738(ra) # 8000017c <kalloc>
    80003ea2:	892a                	mv	s2,a0
    80003ea4:	c125                	beqz	a0,80003f04 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ea6:	4985                	li	s3,1
    80003ea8:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003eac:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003eb0:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003eb4:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003eb8:	00004597          	auipc	a1,0x4
    80003ebc:	79058593          	addi	a1,a1,1936 # 80008648 <syscalls+0x280>
    80003ec0:	00003097          	auipc	ra,0x3
    80003ec4:	87c080e7          	jalr	-1924(ra) # 8000673c <initlock>
  (*f0)->type = FD_PIPE;
    80003ec8:	609c                	ld	a5,0(s1)
    80003eca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ece:	609c                	ld	a5,0(s1)
    80003ed0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ed4:	609c                	ld	a5,0(s1)
    80003ed6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eda:	609c                	ld	a5,0(s1)
    80003edc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ee0:	000a3783          	ld	a5,0(s4)
    80003ee4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ee8:	000a3783          	ld	a5,0(s4)
    80003eec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ef0:	000a3783          	ld	a5,0(s4)
    80003ef4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ef8:	000a3783          	ld	a5,0(s4)
    80003efc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f00:	4501                	li	a0,0
    80003f02:	a025                	j	80003f2a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f04:	6088                	ld	a0,0(s1)
    80003f06:	e501                	bnez	a0,80003f0e <pipealloc+0xaa>
    80003f08:	a039                	j	80003f16 <pipealloc+0xb2>
    80003f0a:	6088                	ld	a0,0(s1)
    80003f0c:	c51d                	beqz	a0,80003f3a <pipealloc+0xd6>
    fileclose(*f0);
    80003f0e:	00000097          	auipc	ra,0x0
    80003f12:	c26080e7          	jalr	-986(ra) # 80003b34 <fileclose>
  if(*f1)
    80003f16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f1a:	557d                	li	a0,-1
  if(*f1)
    80003f1c:	c799                	beqz	a5,80003f2a <pipealloc+0xc6>
    fileclose(*f1);
    80003f1e:	853e                	mv	a0,a5
    80003f20:	00000097          	auipc	ra,0x0
    80003f24:	c14080e7          	jalr	-1004(ra) # 80003b34 <fileclose>
  return -1;
    80003f28:	557d                	li	a0,-1
}
    80003f2a:	70a2                	ld	ra,40(sp)
    80003f2c:	7402                	ld	s0,32(sp)
    80003f2e:	64e2                	ld	s1,24(sp)
    80003f30:	6942                	ld	s2,16(sp)
    80003f32:	69a2                	ld	s3,8(sp)
    80003f34:	6a02                	ld	s4,0(sp)
    80003f36:	6145                	addi	sp,sp,48
    80003f38:	8082                	ret
  return -1;
    80003f3a:	557d                	li	a0,-1
    80003f3c:	b7fd                	j	80003f2a <pipealloc+0xc6>

0000000080003f3e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f3e:	1101                	addi	sp,sp,-32
    80003f40:	ec06                	sd	ra,24(sp)
    80003f42:	e822                	sd	s0,16(sp)
    80003f44:	e426                	sd	s1,8(sp)
    80003f46:	e04a                	sd	s2,0(sp)
    80003f48:	1000                	addi	s0,sp,32
    80003f4a:	84aa                	mv	s1,a0
    80003f4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	672080e7          	jalr	1650(ra) # 800065c0 <acquire>
  if(writable){
    80003f56:	04090263          	beqz	s2,80003f9a <pipeclose+0x5c>
    pi->writeopen = 0;
    80003f5a:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80003f5e:	22048513          	addi	a0,s1,544
    80003f62:	ffffe097          	auipc	ra,0xffffe
    80003f66:	886080e7          	jalr	-1914(ra) # 800017e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f6a:	2284b783          	ld	a5,552(s1)
    80003f6e:	ef9d                	bnez	a5,80003fac <pipeclose+0x6e>
    release(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	71e080e7          	jalr	1822(ra) # 80006690 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	00002097          	auipc	ra,0x2
    80003f80:	75c080e7          	jalr	1884(ra) # 800066d8 <freelock>
#endif    
    kfree((char*)pi);
    80003f84:	8526                	mv	a0,s1
    80003f86:	ffffc097          	auipc	ra,0xffffc
    80003f8a:	096080e7          	jalr	150(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f8e:	60e2                	ld	ra,24(sp)
    80003f90:	6442                	ld	s0,16(sp)
    80003f92:	64a2                	ld	s1,8(sp)
    80003f94:	6902                	ld	s2,0(sp)
    80003f96:	6105                	addi	sp,sp,32
    80003f98:	8082                	ret
    pi->readopen = 0;
    80003f9a:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80003f9e:	22448513          	addi	a0,s1,548
    80003fa2:	ffffe097          	auipc	ra,0xffffe
    80003fa6:	846080e7          	jalr	-1978(ra) # 800017e8 <wakeup>
    80003faa:	b7c1                	j	80003f6a <pipeclose+0x2c>
    release(&pi->lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	00002097          	auipc	ra,0x2
    80003fb2:	6e2080e7          	jalr	1762(ra) # 80006690 <release>
}
    80003fb6:	bfe1                	j	80003f8e <pipeclose+0x50>

0000000080003fb8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fb8:	7159                	addi	sp,sp,-112
    80003fba:	f486                	sd	ra,104(sp)
    80003fbc:	f0a2                	sd	s0,96(sp)
    80003fbe:	eca6                	sd	s1,88(sp)
    80003fc0:	e8ca                	sd	s2,80(sp)
    80003fc2:	e4ce                	sd	s3,72(sp)
    80003fc4:	e0d2                	sd	s4,64(sp)
    80003fc6:	fc56                	sd	s5,56(sp)
    80003fc8:	f85a                	sd	s6,48(sp)
    80003fca:	f45e                	sd	s7,40(sp)
    80003fcc:	f062                	sd	s8,32(sp)
    80003fce:	ec66                	sd	s9,24(sp)
    80003fd0:	1880                	addi	s0,sp,112
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	8aae                	mv	s5,a1
    80003fd6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	fc8080e7          	jalr	-56(ra) # 80000fa0 <myproc>
    80003fe0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00002097          	auipc	ra,0x2
    80003fe8:	5dc080e7          	jalr	1500(ra) # 800065c0 <acquire>
  while(i < n){
    80003fec:	0d405163          	blez	s4,800040ae <pipewrite+0xf6>
    80003ff0:	8ba6                	mv	s7,s1
  int i = 0;
    80003ff2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ff6:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80003ffa:	22448c13          	addi	s8,s1,548
    80003ffe:	a08d                	j	80004060 <pipewrite+0xa8>
      release(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	68e080e7          	jalr	1678(ra) # 80006690 <release>
      return -1;
    8000400a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000400c:	854a                	mv	a0,s2
    8000400e:	70a6                	ld	ra,104(sp)
    80004010:	7406                	ld	s0,96(sp)
    80004012:	64e6                	ld	s1,88(sp)
    80004014:	6946                	ld	s2,80(sp)
    80004016:	69a6                	ld	s3,72(sp)
    80004018:	6a06                	ld	s4,64(sp)
    8000401a:	7ae2                	ld	s5,56(sp)
    8000401c:	7b42                	ld	s6,48(sp)
    8000401e:	7ba2                	ld	s7,40(sp)
    80004020:	7c02                	ld	s8,32(sp)
    80004022:	6ce2                	ld	s9,24(sp)
    80004024:	6165                	addi	sp,sp,112
    80004026:	8082                	ret
      wakeup(&pi->nread);
    80004028:	8566                	mv	a0,s9
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	7be080e7          	jalr	1982(ra) # 800017e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004032:	85de                	mv	a1,s7
    80004034:	8562                	mv	a0,s8
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	626080e7          	jalr	1574(ra) # 8000165c <sleep>
    8000403e:	a839                	j	8000405c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004040:	2244a783          	lw	a5,548(s1)
    80004044:	0017871b          	addiw	a4,a5,1
    80004048:	22e4a223          	sw	a4,548(s1)
    8000404c:	1ff7f793          	andi	a5,a5,511
    80004050:	97a6                	add	a5,a5,s1
    80004052:	f9f44703          	lbu	a4,-97(s0)
    80004056:	02e78023          	sb	a4,32(a5)
      i++;
    8000405a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000405c:	03495d63          	bge	s2,s4,80004096 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004060:	2284a783          	lw	a5,552(s1)
    80004064:	dfd1                	beqz	a5,80004000 <pipewrite+0x48>
    80004066:	0309a783          	lw	a5,48(s3)
    8000406a:	fbd9                	bnez	a5,80004000 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000406c:	2204a783          	lw	a5,544(s1)
    80004070:	2244a703          	lw	a4,548(s1)
    80004074:	2007879b          	addiw	a5,a5,512
    80004078:	faf708e3          	beq	a4,a5,80004028 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000407c:	4685                	li	a3,1
    8000407e:	01590633          	add	a2,s2,s5
    80004082:	f9f40593          	addi	a1,s0,-97
    80004086:	0589b503          	ld	a0,88(s3)
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	c64080e7          	jalr	-924(ra) # 80000cee <copyin>
    80004092:	fb6517e3          	bne	a0,s6,80004040 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004096:	22048513          	addi	a0,s1,544
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	74e080e7          	jalr	1870(ra) # 800017e8 <wakeup>
  release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	5ec080e7          	jalr	1516(ra) # 80006690 <release>
  return i;
    800040ac:	b785                	j	8000400c <pipewrite+0x54>
  int i = 0;
    800040ae:	4901                	li	s2,0
    800040b0:	b7dd                	j	80004096 <pipewrite+0xde>

00000000800040b2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040b2:	715d                	addi	sp,sp,-80
    800040b4:	e486                	sd	ra,72(sp)
    800040b6:	e0a2                	sd	s0,64(sp)
    800040b8:	fc26                	sd	s1,56(sp)
    800040ba:	f84a                	sd	s2,48(sp)
    800040bc:	f44e                	sd	s3,40(sp)
    800040be:	f052                	sd	s4,32(sp)
    800040c0:	ec56                	sd	s5,24(sp)
    800040c2:	e85a                	sd	s6,16(sp)
    800040c4:	0880                	addi	s0,sp,80
    800040c6:	84aa                	mv	s1,a0
    800040c8:	892e                	mv	s2,a1
    800040ca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	ed4080e7          	jalr	-300(ra) # 80000fa0 <myproc>
    800040d4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040d6:	8b26                	mv	s6,s1
    800040d8:	8526                	mv	a0,s1
    800040da:	00002097          	auipc	ra,0x2
    800040de:	4e6080e7          	jalr	1254(ra) # 800065c0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e2:	2204a703          	lw	a4,544(s1)
    800040e6:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ea:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ee:	02f71463          	bne	a4,a5,80004116 <piperead+0x64>
    800040f2:	22c4a783          	lw	a5,556(s1)
    800040f6:	c385                	beqz	a5,80004116 <piperead+0x64>
    if(pr->killed){
    800040f8:	030a2783          	lw	a5,48(s4)
    800040fc:	ebc1                	bnez	a5,8000418c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040fe:	85da                	mv	a1,s6
    80004100:	854e                	mv	a0,s3
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	55a080e7          	jalr	1370(ra) # 8000165c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000410a:	2204a703          	lw	a4,544(s1)
    8000410e:	2244a783          	lw	a5,548(s1)
    80004112:	fef700e3          	beq	a4,a5,800040f2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004116:	09505263          	blez	s5,8000419a <piperead+0xe8>
    8000411a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000411c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000411e:	2204a783          	lw	a5,544(s1)
    80004122:	2244a703          	lw	a4,548(s1)
    80004126:	02f70d63          	beq	a4,a5,80004160 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000412a:	0017871b          	addiw	a4,a5,1
    8000412e:	22e4a023          	sw	a4,544(s1)
    80004132:	1ff7f793          	andi	a5,a5,511
    80004136:	97a6                	add	a5,a5,s1
    80004138:	0207c783          	lbu	a5,32(a5)
    8000413c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004140:	4685                	li	a3,1
    80004142:	fbf40613          	addi	a2,s0,-65
    80004146:	85ca                	mv	a1,s2
    80004148:	058a3503          	ld	a0,88(s4)
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	b16080e7          	jalr	-1258(ra) # 80000c62 <copyout>
    80004154:	01650663          	beq	a0,s6,80004160 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004158:	2985                	addiw	s3,s3,1
    8000415a:	0905                	addi	s2,s2,1
    8000415c:	fd3a91e3          	bne	s5,s3,8000411e <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004160:	22448513          	addi	a0,s1,548
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	684080e7          	jalr	1668(ra) # 800017e8 <wakeup>
  release(&pi->lock);
    8000416c:	8526                	mv	a0,s1
    8000416e:	00002097          	auipc	ra,0x2
    80004172:	522080e7          	jalr	1314(ra) # 80006690 <release>
  return i;
}
    80004176:	854e                	mv	a0,s3
    80004178:	60a6                	ld	ra,72(sp)
    8000417a:	6406                	ld	s0,64(sp)
    8000417c:	74e2                	ld	s1,56(sp)
    8000417e:	7942                	ld	s2,48(sp)
    80004180:	79a2                	ld	s3,40(sp)
    80004182:	7a02                	ld	s4,32(sp)
    80004184:	6ae2                	ld	s5,24(sp)
    80004186:	6b42                	ld	s6,16(sp)
    80004188:	6161                	addi	sp,sp,80
    8000418a:	8082                	ret
      release(&pi->lock);
    8000418c:	8526                	mv	a0,s1
    8000418e:	00002097          	auipc	ra,0x2
    80004192:	502080e7          	jalr	1282(ra) # 80006690 <release>
      return -1;
    80004196:	59fd                	li	s3,-1
    80004198:	bff9                	j	80004176 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419a:	4981                	li	s3,0
    8000419c:	b7d1                	j	80004160 <piperead+0xae>

000000008000419e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000419e:	df010113          	addi	sp,sp,-528
    800041a2:	20113423          	sd	ra,520(sp)
    800041a6:	20813023          	sd	s0,512(sp)
    800041aa:	ffa6                	sd	s1,504(sp)
    800041ac:	fbca                	sd	s2,496(sp)
    800041ae:	f7ce                	sd	s3,488(sp)
    800041b0:	f3d2                	sd	s4,480(sp)
    800041b2:	efd6                	sd	s5,472(sp)
    800041b4:	ebda                	sd	s6,464(sp)
    800041b6:	e7de                	sd	s7,456(sp)
    800041b8:	e3e2                	sd	s8,448(sp)
    800041ba:	ff66                	sd	s9,440(sp)
    800041bc:	fb6a                	sd	s10,432(sp)
    800041be:	f76e                	sd	s11,424(sp)
    800041c0:	0c00                	addi	s0,sp,528
    800041c2:	84aa                	mv	s1,a0
    800041c4:	dea43c23          	sd	a0,-520(s0)
    800041c8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	dd4080e7          	jalr	-556(ra) # 80000fa0 <myproc>
    800041d4:	892a                	mv	s2,a0

  begin_op();
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	492080e7          	jalr	1170(ra) # 80003668 <begin_op>

  if((ip = namei(path)) == 0){
    800041de:	8526                	mv	a0,s1
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	26c080e7          	jalr	620(ra) # 8000344c <namei>
    800041e8:	c92d                	beqz	a0,8000425a <exec+0xbc>
    800041ea:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	aaa080e7          	jalr	-1366(ra) # 80002c96 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041f4:	04000713          	li	a4,64
    800041f8:	4681                	li	a3,0
    800041fa:	e5040613          	addi	a2,s0,-432
    800041fe:	4581                	li	a1,0
    80004200:	8526                	mv	a0,s1
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	d48080e7          	jalr	-696(ra) # 80002f4a <readi>
    8000420a:	04000793          	li	a5,64
    8000420e:	00f51a63          	bne	a0,a5,80004222 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004212:	e5042703          	lw	a4,-432(s0)
    80004216:	464c47b7          	lui	a5,0x464c4
    8000421a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000421e:	04f70463          	beq	a4,a5,80004266 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004222:	8526                	mv	a0,s1
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	cd4080e7          	jalr	-812(ra) # 80002ef8 <iunlockput>
    end_op();
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	4bc080e7          	jalr	1212(ra) # 800036e8 <end_op>
  }
  return -1;
    80004234:	557d                	li	a0,-1
}
    80004236:	20813083          	ld	ra,520(sp)
    8000423a:	20013403          	ld	s0,512(sp)
    8000423e:	74fe                	ld	s1,504(sp)
    80004240:	795e                	ld	s2,496(sp)
    80004242:	79be                	ld	s3,488(sp)
    80004244:	7a1e                	ld	s4,480(sp)
    80004246:	6afe                	ld	s5,472(sp)
    80004248:	6b5e                	ld	s6,464(sp)
    8000424a:	6bbe                	ld	s7,456(sp)
    8000424c:	6c1e                	ld	s8,448(sp)
    8000424e:	7cfa                	ld	s9,440(sp)
    80004250:	7d5a                	ld	s10,432(sp)
    80004252:	7dba                	ld	s11,424(sp)
    80004254:	21010113          	addi	sp,sp,528
    80004258:	8082                	ret
    end_op();
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	48e080e7          	jalr	1166(ra) # 800036e8 <end_op>
    return -1;
    80004262:	557d                	li	a0,-1
    80004264:	bfc9                	j	80004236 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004266:	854a                	mv	a0,s2
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	dfc080e7          	jalr	-516(ra) # 80001064 <proc_pagetable>
    80004270:	8baa                	mv	s7,a0
    80004272:	d945                	beqz	a0,80004222 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004274:	e7042983          	lw	s3,-400(s0)
    80004278:	e8845783          	lhu	a5,-376(s0)
    8000427c:	c7ad                	beqz	a5,800042e6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004280:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004282:	6c85                	lui	s9,0x1
    80004284:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004288:	def43823          	sd	a5,-528(s0)
    8000428c:	a42d                	j	800044b6 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000428e:	00004517          	auipc	a0,0x4
    80004292:	3c250513          	addi	a0,a0,962 # 80008650 <syscalls+0x288>
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	df6080e7          	jalr	-522(ra) # 8000608c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000429e:	8756                	mv	a4,s5
    800042a0:	012d86bb          	addw	a3,s11,s2
    800042a4:	4581                	li	a1,0
    800042a6:	8526                	mv	a0,s1
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	ca2080e7          	jalr	-862(ra) # 80002f4a <readi>
    800042b0:	2501                	sext.w	a0,a0
    800042b2:	1aaa9963          	bne	s5,a0,80004464 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042b6:	6785                	lui	a5,0x1
    800042b8:	0127893b          	addw	s2,a5,s2
    800042bc:	77fd                	lui	a5,0xfffff
    800042be:	01478a3b          	addw	s4,a5,s4
    800042c2:	1f897163          	bgeu	s2,s8,800044a4 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042c6:	02091593          	slli	a1,s2,0x20
    800042ca:	9181                	srli	a1,a1,0x20
    800042cc:	95ea                	add	a1,a1,s10
    800042ce:	855e                	mv	a0,s7
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	38e080e7          	jalr	910(ra) # 8000065e <walkaddr>
    800042d8:	862a                	mv	a2,a0
    if(pa == 0)
    800042da:	d955                	beqz	a0,8000428e <exec+0xf0>
      n = PGSIZE;
    800042dc:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042de:	fd9a70e3          	bgeu	s4,s9,8000429e <exec+0x100>
      n = sz - i;
    800042e2:	8ad2                	mv	s5,s4
    800042e4:	bf6d                	j	8000429e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e6:	4901                	li	s2,0
  iunlockput(ip);
    800042e8:	8526                	mv	a0,s1
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	c0e080e7          	jalr	-1010(ra) # 80002ef8 <iunlockput>
  end_op();
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	3f6080e7          	jalr	1014(ra) # 800036e8 <end_op>
  p = myproc();
    800042fa:	ffffd097          	auipc	ra,0xffffd
    800042fe:	ca6080e7          	jalr	-858(ra) # 80000fa0 <myproc>
    80004302:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004304:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004308:	6785                	lui	a5,0x1
    8000430a:	17fd                	addi	a5,a5,-1
    8000430c:	993e                	add	s2,s2,a5
    8000430e:	757d                	lui	a0,0xfffff
    80004310:	00a977b3          	and	a5,s2,a0
    80004314:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004318:	6609                	lui	a2,0x2
    8000431a:	963e                	add	a2,a2,a5
    8000431c:	85be                	mv	a1,a5
    8000431e:	855e                	mv	a0,s7
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	6f2080e7          	jalr	1778(ra) # 80000a12 <uvmalloc>
    80004328:	8b2a                	mv	s6,a0
  ip = 0;
    8000432a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000432c:	12050c63          	beqz	a0,80004464 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004330:	75f9                	lui	a1,0xffffe
    80004332:	95aa                	add	a1,a1,a0
    80004334:	855e                	mv	a0,s7
    80004336:	ffffd097          	auipc	ra,0xffffd
    8000433a:	8fa080e7          	jalr	-1798(ra) # 80000c30 <uvmclear>
  stackbase = sp - PGSIZE;
    8000433e:	7c7d                	lui	s8,0xfffff
    80004340:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004342:	e0043783          	ld	a5,-512(s0)
    80004346:	6388                	ld	a0,0(a5)
    80004348:	c535                	beqz	a0,800043b4 <exec+0x216>
    8000434a:	e9040993          	addi	s3,s0,-368
    8000434e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004352:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	0f0080e7          	jalr	240(ra) # 80000444 <strlen>
    8000435c:	2505                	addiw	a0,a0,1
    8000435e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004362:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004366:	13896363          	bltu	s2,s8,8000448c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000436a:	e0043d83          	ld	s11,-512(s0)
    8000436e:	000dba03          	ld	s4,0(s11)
    80004372:	8552                	mv	a0,s4
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	0d0080e7          	jalr	208(ra) # 80000444 <strlen>
    8000437c:	0015069b          	addiw	a3,a0,1
    80004380:	8652                	mv	a2,s4
    80004382:	85ca                	mv	a1,s2
    80004384:	855e                	mv	a0,s7
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	8dc080e7          	jalr	-1828(ra) # 80000c62 <copyout>
    8000438e:	10054363          	bltz	a0,80004494 <exec+0x2f6>
    ustack[argc] = sp;
    80004392:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004396:	0485                	addi	s1,s1,1
    80004398:	008d8793          	addi	a5,s11,8
    8000439c:	e0f43023          	sd	a5,-512(s0)
    800043a0:	008db503          	ld	a0,8(s11)
    800043a4:	c911                	beqz	a0,800043b8 <exec+0x21a>
    if(argc >= MAXARG)
    800043a6:	09a1                	addi	s3,s3,8
    800043a8:	fb3c96e3          	bne	s9,s3,80004354 <exec+0x1b6>
  sz = sz1;
    800043ac:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b0:	4481                	li	s1,0
    800043b2:	a84d                	j	80004464 <exec+0x2c6>
  sp = sz;
    800043b4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b6:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b8:	00349793          	slli	a5,s1,0x3
    800043bc:	f9040713          	addi	a4,s0,-112
    800043c0:	97ba                	add	a5,a5,a4
    800043c2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043c6:	00148693          	addi	a3,s1,1
    800043ca:	068e                	slli	a3,a3,0x3
    800043cc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043d0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043d4:	01897663          	bgeu	s2,s8,800043e0 <exec+0x242>
  sz = sz1;
    800043d8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043dc:	4481                	li	s1,0
    800043de:	a059                	j	80004464 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043e0:	e9040613          	addi	a2,s0,-368
    800043e4:	85ca                	mv	a1,s2
    800043e6:	855e                	mv	a0,s7
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	87a080e7          	jalr	-1926(ra) # 80000c62 <copyout>
    800043f0:	0a054663          	bltz	a0,8000449c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043f4:	060ab783          	ld	a5,96(s5)
    800043f8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043fc:	df843783          	ld	a5,-520(s0)
    80004400:	0007c703          	lbu	a4,0(a5)
    80004404:	cf11                	beqz	a4,80004420 <exec+0x282>
    80004406:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004408:	02f00693          	li	a3,47
    8000440c:	a039                	j	8000441a <exec+0x27c>
      last = s+1;
    8000440e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004412:	0785                	addi	a5,a5,1
    80004414:	fff7c703          	lbu	a4,-1(a5)
    80004418:	c701                	beqz	a4,80004420 <exec+0x282>
    if(*s == '/')
    8000441a:	fed71ce3          	bne	a4,a3,80004412 <exec+0x274>
    8000441e:	bfc5                	j	8000440e <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004420:	4641                	li	a2,16
    80004422:	df843583          	ld	a1,-520(s0)
    80004426:	160a8513          	addi	a0,s5,352
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	fe8080e7          	jalr	-24(ra) # 80000412 <safestrcpy>
  oldpagetable = p->pagetable;
    80004432:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004436:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    8000443a:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000443e:	060ab783          	ld	a5,96(s5)
    80004442:	e6843703          	ld	a4,-408(s0)
    80004446:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004448:	060ab783          	ld	a5,96(s5)
    8000444c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004450:	85ea                	mv	a1,s10
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	cae080e7          	jalr	-850(ra) # 80001100 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000445a:	0004851b          	sext.w	a0,s1
    8000445e:	bbe1                	j	80004236 <exec+0x98>
    80004460:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004464:	e0843583          	ld	a1,-504(s0)
    80004468:	855e                	mv	a0,s7
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	c96080e7          	jalr	-874(ra) # 80001100 <proc_freepagetable>
  if(ip){
    80004472:	da0498e3          	bnez	s1,80004222 <exec+0x84>
  return -1;
    80004476:	557d                	li	a0,-1
    80004478:	bb7d                	j	80004236 <exec+0x98>
    8000447a:	e1243423          	sd	s2,-504(s0)
    8000447e:	b7dd                	j	80004464 <exec+0x2c6>
    80004480:	e1243423          	sd	s2,-504(s0)
    80004484:	b7c5                	j	80004464 <exec+0x2c6>
    80004486:	e1243423          	sd	s2,-504(s0)
    8000448a:	bfe9                	j	80004464 <exec+0x2c6>
  sz = sz1;
    8000448c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004490:	4481                	li	s1,0
    80004492:	bfc9                	j	80004464 <exec+0x2c6>
  sz = sz1;
    80004494:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004498:	4481                	li	s1,0
    8000449a:	b7e9                	j	80004464 <exec+0x2c6>
  sz = sz1;
    8000449c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a0:	4481                	li	s1,0
    800044a2:	b7c9                	j	80004464 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044a4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044a8:	2b05                	addiw	s6,s6,1
    800044aa:	0389899b          	addiw	s3,s3,56
    800044ae:	e8845783          	lhu	a5,-376(s0)
    800044b2:	e2fb5be3          	bge	s6,a5,800042e8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044b6:	2981                	sext.w	s3,s3
    800044b8:	03800713          	li	a4,56
    800044bc:	86ce                	mv	a3,s3
    800044be:	e1840613          	addi	a2,s0,-488
    800044c2:	4581                	li	a1,0
    800044c4:	8526                	mv	a0,s1
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	a84080e7          	jalr	-1404(ra) # 80002f4a <readi>
    800044ce:	03800793          	li	a5,56
    800044d2:	f8f517e3          	bne	a0,a5,80004460 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044d6:	e1842783          	lw	a5,-488(s0)
    800044da:	4705                	li	a4,1
    800044dc:	fce796e3          	bne	a5,a4,800044a8 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044e0:	e4043603          	ld	a2,-448(s0)
    800044e4:	e3843783          	ld	a5,-456(s0)
    800044e8:	f8f669e3          	bltu	a2,a5,8000447a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044ec:	e2843783          	ld	a5,-472(s0)
    800044f0:	963e                	add	a2,a2,a5
    800044f2:	f8f667e3          	bltu	a2,a5,80004480 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044f6:	85ca                	mv	a1,s2
    800044f8:	855e                	mv	a0,s7
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	518080e7          	jalr	1304(ra) # 80000a12 <uvmalloc>
    80004502:	e0a43423          	sd	a0,-504(s0)
    80004506:	d141                	beqz	a0,80004486 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004508:	e2843d03          	ld	s10,-472(s0)
    8000450c:	df043783          	ld	a5,-528(s0)
    80004510:	00fd77b3          	and	a5,s10,a5
    80004514:	fba1                	bnez	a5,80004464 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004516:	e2042d83          	lw	s11,-480(s0)
    8000451a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000451e:	f80c03e3          	beqz	s8,800044a4 <exec+0x306>
    80004522:	8a62                	mv	s4,s8
    80004524:	4901                	li	s2,0
    80004526:	b345                	j	800042c6 <exec+0x128>

0000000080004528 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004528:	7179                	addi	sp,sp,-48
    8000452a:	f406                	sd	ra,40(sp)
    8000452c:	f022                	sd	s0,32(sp)
    8000452e:	ec26                	sd	s1,24(sp)
    80004530:	e84a                	sd	s2,16(sp)
    80004532:	1800                	addi	s0,sp,48
    80004534:	892e                	mv	s2,a1
    80004536:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004538:	fdc40593          	addi	a1,s0,-36
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	b10080e7          	jalr	-1264(ra) # 8000204c <argint>
    80004544:	04054063          	bltz	a0,80004584 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004548:	fdc42703          	lw	a4,-36(s0)
    8000454c:	47bd                	li	a5,15
    8000454e:	02e7ed63          	bltu	a5,a4,80004588 <argfd+0x60>
    80004552:	ffffd097          	auipc	ra,0xffffd
    80004556:	a4e080e7          	jalr	-1458(ra) # 80000fa0 <myproc>
    8000455a:	fdc42703          	lw	a4,-36(s0)
    8000455e:	01a70793          	addi	a5,a4,26
    80004562:	078e                	slli	a5,a5,0x3
    80004564:	953e                	add	a0,a0,a5
    80004566:	651c                	ld	a5,8(a0)
    80004568:	c395                	beqz	a5,8000458c <argfd+0x64>
    return -1;
  if(pfd)
    8000456a:	00090463          	beqz	s2,80004572 <argfd+0x4a>
    *pfd = fd;
    8000456e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004572:	4501                	li	a0,0
  if(pf)
    80004574:	c091                	beqz	s1,80004578 <argfd+0x50>
    *pf = f;
    80004576:	e09c                	sd	a5,0(s1)
}
    80004578:	70a2                	ld	ra,40(sp)
    8000457a:	7402                	ld	s0,32(sp)
    8000457c:	64e2                	ld	s1,24(sp)
    8000457e:	6942                	ld	s2,16(sp)
    80004580:	6145                	addi	sp,sp,48
    80004582:	8082                	ret
    return -1;
    80004584:	557d                	li	a0,-1
    80004586:	bfcd                	j	80004578 <argfd+0x50>
    return -1;
    80004588:	557d                	li	a0,-1
    8000458a:	b7fd                	j	80004578 <argfd+0x50>
    8000458c:	557d                	li	a0,-1
    8000458e:	b7ed                	j	80004578 <argfd+0x50>

0000000080004590 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004590:	1101                	addi	sp,sp,-32
    80004592:	ec06                	sd	ra,24(sp)
    80004594:	e822                	sd	s0,16(sp)
    80004596:	e426                	sd	s1,8(sp)
    80004598:	1000                	addi	s0,sp,32
    8000459a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	a04080e7          	jalr	-1532(ra) # 80000fa0 <myproc>
    800045a4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045a6:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    800045aa:	4501                	li	a0,0
    800045ac:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ae:	6398                	ld	a4,0(a5)
    800045b0:	cb19                	beqz	a4,800045c6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b2:	2505                	addiw	a0,a0,1
    800045b4:	07a1                	addi	a5,a5,8
    800045b6:	fed51ce3          	bne	a0,a3,800045ae <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045ba:	557d                	li	a0,-1
}
    800045bc:	60e2                	ld	ra,24(sp)
    800045be:	6442                	ld	s0,16(sp)
    800045c0:	64a2                	ld	s1,8(sp)
    800045c2:	6105                	addi	sp,sp,32
    800045c4:	8082                	ret
      p->ofile[fd] = f;
    800045c6:	01a50793          	addi	a5,a0,26
    800045ca:	078e                	slli	a5,a5,0x3
    800045cc:	963e                	add	a2,a2,a5
    800045ce:	e604                	sd	s1,8(a2)
      return fd;
    800045d0:	b7f5                	j	800045bc <fdalloc+0x2c>

00000000800045d2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d2:	715d                	addi	sp,sp,-80
    800045d4:	e486                	sd	ra,72(sp)
    800045d6:	e0a2                	sd	s0,64(sp)
    800045d8:	fc26                	sd	s1,56(sp)
    800045da:	f84a                	sd	s2,48(sp)
    800045dc:	f44e                	sd	s3,40(sp)
    800045de:	f052                	sd	s4,32(sp)
    800045e0:	ec56                	sd	s5,24(sp)
    800045e2:	0880                	addi	s0,sp,80
    800045e4:	89ae                	mv	s3,a1
    800045e6:	8ab2                	mv	s5,a2
    800045e8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	e7c080e7          	jalr	-388(ra) # 8000346a <nameiparent>
    800045f6:	892a                	mv	s2,a0
    800045f8:	12050f63          	beqz	a0,80004736 <create+0x164>
    return 0;

  ilock(dp);
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	69a080e7          	jalr	1690(ra) # 80002c96 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004604:	4601                	li	a2,0
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	854a                	mv	a0,s2
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	b6e080e7          	jalr	-1170(ra) # 8000317a <dirlookup>
    80004614:	84aa                	mv	s1,a0
    80004616:	c921                	beqz	a0,80004666 <create+0x94>
    iunlockput(dp);
    80004618:	854a                	mv	a0,s2
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	8de080e7          	jalr	-1826(ra) # 80002ef8 <iunlockput>
    ilock(ip);
    80004622:	8526                	mv	a0,s1
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	672080e7          	jalr	1650(ra) # 80002c96 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000462c:	2981                	sext.w	s3,s3
    8000462e:	4789                	li	a5,2
    80004630:	02f99463          	bne	s3,a5,80004658 <create+0x86>
    80004634:	04c4d783          	lhu	a5,76(s1)
    80004638:	37f9                	addiw	a5,a5,-2
    8000463a:	17c2                	slli	a5,a5,0x30
    8000463c:	93c1                	srli	a5,a5,0x30
    8000463e:	4705                	li	a4,1
    80004640:	00f76c63          	bltu	a4,a5,80004658 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004644:	8526                	mv	a0,s1
    80004646:	60a6                	ld	ra,72(sp)
    80004648:	6406                	ld	s0,64(sp)
    8000464a:	74e2                	ld	s1,56(sp)
    8000464c:	7942                	ld	s2,48(sp)
    8000464e:	79a2                	ld	s3,40(sp)
    80004650:	7a02                	ld	s4,32(sp)
    80004652:	6ae2                	ld	s5,24(sp)
    80004654:	6161                	addi	sp,sp,80
    80004656:	8082                	ret
    iunlockput(ip);
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	89e080e7          	jalr	-1890(ra) # 80002ef8 <iunlockput>
    return 0;
    80004662:	4481                	li	s1,0
    80004664:	b7c5                	j	80004644 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004666:	85ce                	mv	a1,s3
    80004668:	00092503          	lw	a0,0(s2)
    8000466c:	ffffe097          	auipc	ra,0xffffe
    80004670:	492080e7          	jalr	1170(ra) # 80002afe <ialloc>
    80004674:	84aa                	mv	s1,a0
    80004676:	c529                	beqz	a0,800046c0 <create+0xee>
  ilock(ip);
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	61e080e7          	jalr	1566(ra) # 80002c96 <ilock>
  ip->major = major;
    80004680:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80004684:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    80004688:	4785                	li	a5,1
    8000468a:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    8000468e:	8526                	mv	a0,s1
    80004690:	ffffe097          	auipc	ra,0xffffe
    80004694:	53c080e7          	jalr	1340(ra) # 80002bcc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004698:	2981                	sext.w	s3,s3
    8000469a:	4785                	li	a5,1
    8000469c:	02f98a63          	beq	s3,a5,800046d0 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a0:	40d0                	lw	a2,4(s1)
    800046a2:	fb040593          	addi	a1,s0,-80
    800046a6:	854a                	mv	a0,s2
    800046a8:	fffff097          	auipc	ra,0xfffff
    800046ac:	ce2080e7          	jalr	-798(ra) # 8000338a <dirlink>
    800046b0:	06054b63          	bltz	a0,80004726 <create+0x154>
  iunlockput(dp);
    800046b4:	854a                	mv	a0,s2
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	842080e7          	jalr	-1982(ra) # 80002ef8 <iunlockput>
  return ip;
    800046be:	b759                	j	80004644 <create+0x72>
    panic("create: ialloc");
    800046c0:	00004517          	auipc	a0,0x4
    800046c4:	fb050513          	addi	a0,a0,-80 # 80008670 <syscalls+0x2a8>
    800046c8:	00002097          	auipc	ra,0x2
    800046cc:	9c4080e7          	jalr	-1596(ra) # 8000608c <panic>
    dp->nlink++;  // for ".."
    800046d0:	05295783          	lhu	a5,82(s2)
    800046d4:	2785                	addiw	a5,a5,1
    800046d6:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800046da:	854a                	mv	a0,s2
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	4f0080e7          	jalr	1264(ra) # 80002bcc <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046e4:	40d0                	lw	a2,4(s1)
    800046e6:	00004597          	auipc	a1,0x4
    800046ea:	f9a58593          	addi	a1,a1,-102 # 80008680 <syscalls+0x2b8>
    800046ee:	8526                	mv	a0,s1
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	c9a080e7          	jalr	-870(ra) # 8000338a <dirlink>
    800046f8:	00054f63          	bltz	a0,80004716 <create+0x144>
    800046fc:	00492603          	lw	a2,4(s2)
    80004700:	00004597          	auipc	a1,0x4
    80004704:	f8858593          	addi	a1,a1,-120 # 80008688 <syscalls+0x2c0>
    80004708:	8526                	mv	a0,s1
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	c80080e7          	jalr	-896(ra) # 8000338a <dirlink>
    80004712:	f80557e3          	bgez	a0,800046a0 <create+0xce>
      panic("create dots");
    80004716:	00004517          	auipc	a0,0x4
    8000471a:	f7a50513          	addi	a0,a0,-134 # 80008690 <syscalls+0x2c8>
    8000471e:	00002097          	auipc	ra,0x2
    80004722:	96e080e7          	jalr	-1682(ra) # 8000608c <panic>
    panic("create: dirlink");
    80004726:	00004517          	auipc	a0,0x4
    8000472a:	f7a50513          	addi	a0,a0,-134 # 800086a0 <syscalls+0x2d8>
    8000472e:	00002097          	auipc	ra,0x2
    80004732:	95e080e7          	jalr	-1698(ra) # 8000608c <panic>
    return 0;
    80004736:	84aa                	mv	s1,a0
    80004738:	b731                	j	80004644 <create+0x72>

000000008000473a <sys_dup>:
{
    8000473a:	7179                	addi	sp,sp,-48
    8000473c:	f406                	sd	ra,40(sp)
    8000473e:	f022                	sd	s0,32(sp)
    80004740:	ec26                	sd	s1,24(sp)
    80004742:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004744:	fd840613          	addi	a2,s0,-40
    80004748:	4581                	li	a1,0
    8000474a:	4501                	li	a0,0
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	ddc080e7          	jalr	-548(ra) # 80004528 <argfd>
    return -1;
    80004754:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004756:	02054363          	bltz	a0,8000477c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000475a:	fd843503          	ld	a0,-40(s0)
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	e32080e7          	jalr	-462(ra) # 80004590 <fdalloc>
    80004766:	84aa                	mv	s1,a0
    return -1;
    80004768:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000476a:	00054963          	bltz	a0,8000477c <sys_dup+0x42>
  filedup(f);
    8000476e:	fd843503          	ld	a0,-40(s0)
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	370080e7          	jalr	880(ra) # 80003ae2 <filedup>
  return fd;
    8000477a:	87a6                	mv	a5,s1
}
    8000477c:	853e                	mv	a0,a5
    8000477e:	70a2                	ld	ra,40(sp)
    80004780:	7402                	ld	s0,32(sp)
    80004782:	64e2                	ld	s1,24(sp)
    80004784:	6145                	addi	sp,sp,48
    80004786:	8082                	ret

0000000080004788 <sys_read>:
{
    80004788:	7179                	addi	sp,sp,-48
    8000478a:	f406                	sd	ra,40(sp)
    8000478c:	f022                	sd	s0,32(sp)
    8000478e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004790:	fe840613          	addi	a2,s0,-24
    80004794:	4581                	li	a1,0
    80004796:	4501                	li	a0,0
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	d90080e7          	jalr	-624(ra) # 80004528 <argfd>
    return -1;
    800047a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a2:	04054163          	bltz	a0,800047e4 <sys_read+0x5c>
    800047a6:	fe440593          	addi	a1,s0,-28
    800047aa:	4509                	li	a0,2
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	8a0080e7          	jalr	-1888(ra) # 8000204c <argint>
    return -1;
    800047b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b6:	02054763          	bltz	a0,800047e4 <sys_read+0x5c>
    800047ba:	fd840593          	addi	a1,s0,-40
    800047be:	4505                	li	a0,1
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	8ae080e7          	jalr	-1874(ra) # 8000206e <argaddr>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ca:	00054d63          	bltz	a0,800047e4 <sys_read+0x5c>
  return fileread(f, p, n);
    800047ce:	fe442603          	lw	a2,-28(s0)
    800047d2:	fd843583          	ld	a1,-40(s0)
    800047d6:	fe843503          	ld	a0,-24(s0)
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	494080e7          	jalr	1172(ra) # 80003c6e <fileread>
    800047e2:	87aa                	mv	a5,a0
}
    800047e4:	853e                	mv	a0,a5
    800047e6:	70a2                	ld	ra,40(sp)
    800047e8:	7402                	ld	s0,32(sp)
    800047ea:	6145                	addi	sp,sp,48
    800047ec:	8082                	ret

00000000800047ee <sys_write>:
{
    800047ee:	7179                	addi	sp,sp,-48
    800047f0:	f406                	sd	ra,40(sp)
    800047f2:	f022                	sd	s0,32(sp)
    800047f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f6:	fe840613          	addi	a2,s0,-24
    800047fa:	4581                	li	a1,0
    800047fc:	4501                	li	a0,0
    800047fe:	00000097          	auipc	ra,0x0
    80004802:	d2a080e7          	jalr	-726(ra) # 80004528 <argfd>
    return -1;
    80004806:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004808:	04054163          	bltz	a0,8000484a <sys_write+0x5c>
    8000480c:	fe440593          	addi	a1,s0,-28
    80004810:	4509                	li	a0,2
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	83a080e7          	jalr	-1990(ra) # 8000204c <argint>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481c:	02054763          	bltz	a0,8000484a <sys_write+0x5c>
    80004820:	fd840593          	addi	a1,s0,-40
    80004824:	4505                	li	a0,1
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	848080e7          	jalr	-1976(ra) # 8000206e <argaddr>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004830:	00054d63          	bltz	a0,8000484a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004834:	fe442603          	lw	a2,-28(s0)
    80004838:	fd843583          	ld	a1,-40(s0)
    8000483c:	fe843503          	ld	a0,-24(s0)
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	4f0080e7          	jalr	1264(ra) # 80003d30 <filewrite>
    80004848:	87aa                	mv	a5,a0
}
    8000484a:	853e                	mv	a0,a5
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	6145                	addi	sp,sp,48
    80004852:	8082                	ret

0000000080004854 <sys_close>:
{
    80004854:	1101                	addi	sp,sp,-32
    80004856:	ec06                	sd	ra,24(sp)
    80004858:	e822                	sd	s0,16(sp)
    8000485a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000485c:	fe040613          	addi	a2,s0,-32
    80004860:	fec40593          	addi	a1,s0,-20
    80004864:	4501                	li	a0,0
    80004866:	00000097          	auipc	ra,0x0
    8000486a:	cc2080e7          	jalr	-830(ra) # 80004528 <argfd>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004870:	02054463          	bltz	a0,80004898 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	72c080e7          	jalr	1836(ra) # 80000fa0 <myproc>
    8000487c:	fec42783          	lw	a5,-20(s0)
    80004880:	07e9                	addi	a5,a5,26
    80004882:	078e                	slli	a5,a5,0x3
    80004884:	97aa                	add	a5,a5,a0
    80004886:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000488a:	fe043503          	ld	a0,-32(s0)
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	2a6080e7          	jalr	678(ra) # 80003b34 <fileclose>
  return 0;
    80004896:	4781                	li	a5,0
}
    80004898:	853e                	mv	a0,a5
    8000489a:	60e2                	ld	ra,24(sp)
    8000489c:	6442                	ld	s0,16(sp)
    8000489e:	6105                	addi	sp,sp,32
    800048a0:	8082                	ret

00000000800048a2 <sys_fstat>:
{
    800048a2:	1101                	addi	sp,sp,-32
    800048a4:	ec06                	sd	ra,24(sp)
    800048a6:	e822                	sd	s0,16(sp)
    800048a8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048aa:	fe840613          	addi	a2,s0,-24
    800048ae:	4581                	li	a1,0
    800048b0:	4501                	li	a0,0
    800048b2:	00000097          	auipc	ra,0x0
    800048b6:	c76080e7          	jalr	-906(ra) # 80004528 <argfd>
    return -1;
    800048ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048bc:	02054563          	bltz	a0,800048e6 <sys_fstat+0x44>
    800048c0:	fe040593          	addi	a1,s0,-32
    800048c4:	4505                	li	a0,1
    800048c6:	ffffd097          	auipc	ra,0xffffd
    800048ca:	7a8080e7          	jalr	1960(ra) # 8000206e <argaddr>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d0:	00054b63          	bltz	a0,800048e6 <sys_fstat+0x44>
  return filestat(f, st);
    800048d4:	fe043583          	ld	a1,-32(s0)
    800048d8:	fe843503          	ld	a0,-24(s0)
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	320080e7          	jalr	800(ra) # 80003bfc <filestat>
    800048e4:	87aa                	mv	a5,a0
}
    800048e6:	853e                	mv	a0,a5
    800048e8:	60e2                	ld	ra,24(sp)
    800048ea:	6442                	ld	s0,16(sp)
    800048ec:	6105                	addi	sp,sp,32
    800048ee:	8082                	ret

00000000800048f0 <sys_link>:
{
    800048f0:	7169                	addi	sp,sp,-304
    800048f2:	f606                	sd	ra,296(sp)
    800048f4:	f222                	sd	s0,288(sp)
    800048f6:	ee26                	sd	s1,280(sp)
    800048f8:	ea4a                	sd	s2,272(sp)
    800048fa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fc:	08000613          	li	a2,128
    80004900:	ed040593          	addi	a1,s0,-304
    80004904:	4501                	li	a0,0
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	78a080e7          	jalr	1930(ra) # 80002090 <argstr>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004910:	10054e63          	bltz	a0,80004a2c <sys_link+0x13c>
    80004914:	08000613          	li	a2,128
    80004918:	f5040593          	addi	a1,s0,-176
    8000491c:	4505                	li	a0,1
    8000491e:	ffffd097          	auipc	ra,0xffffd
    80004922:	772080e7          	jalr	1906(ra) # 80002090 <argstr>
    return -1;
    80004926:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004928:	10054263          	bltz	a0,80004a2c <sys_link+0x13c>
  begin_op();
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	d3c080e7          	jalr	-708(ra) # 80003668 <begin_op>
  if((ip = namei(old)) == 0){
    80004934:	ed040513          	addi	a0,s0,-304
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	b14080e7          	jalr	-1260(ra) # 8000344c <namei>
    80004940:	84aa                	mv	s1,a0
    80004942:	c551                	beqz	a0,800049ce <sys_link+0xde>
  ilock(ip);
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	352080e7          	jalr	850(ra) # 80002c96 <ilock>
  if(ip->type == T_DIR){
    8000494c:	04c49703          	lh	a4,76(s1)
    80004950:	4785                	li	a5,1
    80004952:	08f70463          	beq	a4,a5,800049da <sys_link+0xea>
  ip->nlink++;
    80004956:	0524d783          	lhu	a5,82(s1)
    8000495a:	2785                	addiw	a5,a5,1
    8000495c:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	26a080e7          	jalr	618(ra) # 80002bcc <iupdate>
  iunlock(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	3ec080e7          	jalr	1004(ra) # 80002d58 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004974:	fd040593          	addi	a1,s0,-48
    80004978:	f5040513          	addi	a0,s0,-176
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	aee080e7          	jalr	-1298(ra) # 8000346a <nameiparent>
    80004984:	892a                	mv	s2,a0
    80004986:	c935                	beqz	a0,800049fa <sys_link+0x10a>
  ilock(dp);
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	30e080e7          	jalr	782(ra) # 80002c96 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004990:	00092703          	lw	a4,0(s2)
    80004994:	409c                	lw	a5,0(s1)
    80004996:	04f71d63          	bne	a4,a5,800049f0 <sys_link+0x100>
    8000499a:	40d0                	lw	a2,4(s1)
    8000499c:	fd040593          	addi	a1,s0,-48
    800049a0:	854a                	mv	a0,s2
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	9e8080e7          	jalr	-1560(ra) # 8000338a <dirlink>
    800049aa:	04054363          	bltz	a0,800049f0 <sys_link+0x100>
  iunlockput(dp);
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	548080e7          	jalr	1352(ra) # 80002ef8 <iunlockput>
  iput(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	496080e7          	jalr	1174(ra) # 80002e50 <iput>
  end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	d26080e7          	jalr	-730(ra) # 800036e8 <end_op>
  return 0;
    800049ca:	4781                	li	a5,0
    800049cc:	a085                	j	80004a2c <sys_link+0x13c>
    end_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	d1a080e7          	jalr	-742(ra) # 800036e8 <end_op>
    return -1;
    800049d6:	57fd                	li	a5,-1
    800049d8:	a891                	j	80004a2c <sys_link+0x13c>
    iunlockput(ip);
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	51c080e7          	jalr	1308(ra) # 80002ef8 <iunlockput>
    end_op();
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	d04080e7          	jalr	-764(ra) # 800036e8 <end_op>
    return -1;
    800049ec:	57fd                	li	a5,-1
    800049ee:	a83d                	j	80004a2c <sys_link+0x13c>
    iunlockput(dp);
    800049f0:	854a                	mv	a0,s2
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	506080e7          	jalr	1286(ra) # 80002ef8 <iunlockput>
  ilock(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	29a080e7          	jalr	666(ra) # 80002c96 <ilock>
  ip->nlink--;
    80004a04:	0524d783          	lhu	a5,82(s1)
    80004a08:	37fd                	addiw	a5,a5,-1
    80004a0a:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	1bc080e7          	jalr	444(ra) # 80002bcc <iupdate>
  iunlockput(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	4de080e7          	jalr	1246(ra) # 80002ef8 <iunlockput>
  end_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	cc6080e7          	jalr	-826(ra) # 800036e8 <end_op>
  return -1;
    80004a2a:	57fd                	li	a5,-1
}
    80004a2c:	853e                	mv	a0,a5
    80004a2e:	70b2                	ld	ra,296(sp)
    80004a30:	7412                	ld	s0,288(sp)
    80004a32:	64f2                	ld	s1,280(sp)
    80004a34:	6952                	ld	s2,272(sp)
    80004a36:	6155                	addi	sp,sp,304
    80004a38:	8082                	ret

0000000080004a3a <sys_unlink>:
{
    80004a3a:	7151                	addi	sp,sp,-240
    80004a3c:	f586                	sd	ra,232(sp)
    80004a3e:	f1a2                	sd	s0,224(sp)
    80004a40:	eda6                	sd	s1,216(sp)
    80004a42:	e9ca                	sd	s2,208(sp)
    80004a44:	e5ce                	sd	s3,200(sp)
    80004a46:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a48:	08000613          	li	a2,128
    80004a4c:	f3040593          	addi	a1,s0,-208
    80004a50:	4501                	li	a0,0
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	63e080e7          	jalr	1598(ra) # 80002090 <argstr>
    80004a5a:	18054163          	bltz	a0,80004bdc <sys_unlink+0x1a2>
  begin_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	c0a080e7          	jalr	-1014(ra) # 80003668 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a66:	fb040593          	addi	a1,s0,-80
    80004a6a:	f3040513          	addi	a0,s0,-208
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	9fc080e7          	jalr	-1540(ra) # 8000346a <nameiparent>
    80004a76:	84aa                	mv	s1,a0
    80004a78:	c979                	beqz	a0,80004b4e <sys_unlink+0x114>
  ilock(dp);
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	21c080e7          	jalr	540(ra) # 80002c96 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a82:	00004597          	auipc	a1,0x4
    80004a86:	bfe58593          	addi	a1,a1,-1026 # 80008680 <syscalls+0x2b8>
    80004a8a:	fb040513          	addi	a0,s0,-80
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	6d2080e7          	jalr	1746(ra) # 80003160 <namecmp>
    80004a96:	14050a63          	beqz	a0,80004bea <sys_unlink+0x1b0>
    80004a9a:	00004597          	auipc	a1,0x4
    80004a9e:	bee58593          	addi	a1,a1,-1042 # 80008688 <syscalls+0x2c0>
    80004aa2:	fb040513          	addi	a0,s0,-80
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	6ba080e7          	jalr	1722(ra) # 80003160 <namecmp>
    80004aae:	12050e63          	beqz	a0,80004bea <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ab2:	f2c40613          	addi	a2,s0,-212
    80004ab6:	fb040593          	addi	a1,s0,-80
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	6be080e7          	jalr	1726(ra) # 8000317a <dirlookup>
    80004ac4:	892a                	mv	s2,a0
    80004ac6:	12050263          	beqz	a0,80004bea <sys_unlink+0x1b0>
  ilock(ip);
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	1cc080e7          	jalr	460(ra) # 80002c96 <ilock>
  if(ip->nlink < 1)
    80004ad2:	05291783          	lh	a5,82(s2)
    80004ad6:	08f05263          	blez	a5,80004b5a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ada:	04c91703          	lh	a4,76(s2)
    80004ade:	4785                	li	a5,1
    80004ae0:	08f70563          	beq	a4,a5,80004b6a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ae4:	4641                	li	a2,16
    80004ae6:	4581                	li	a1,0
    80004ae8:	fc040513          	addi	a0,s0,-64
    80004aec:	ffffb097          	auipc	ra,0xffffb
    80004af0:	7d4080e7          	jalr	2004(ra) # 800002c0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af4:	4741                	li	a4,16
    80004af6:	f2c42683          	lw	a3,-212(s0)
    80004afa:	fc040613          	addi	a2,s0,-64
    80004afe:	4581                	li	a1,0
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	540080e7          	jalr	1344(ra) # 80003042 <writei>
    80004b0a:	47c1                	li	a5,16
    80004b0c:	0af51563          	bne	a0,a5,80004bb6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b10:	04c91703          	lh	a4,76(s2)
    80004b14:	4785                	li	a5,1
    80004b16:	0af70863          	beq	a4,a5,80004bc6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	3dc080e7          	jalr	988(ra) # 80002ef8 <iunlockput>
  ip->nlink--;
    80004b24:	05295783          	lhu	a5,82(s2)
    80004b28:	37fd                	addiw	a5,a5,-1
    80004b2a:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	09c080e7          	jalr	156(ra) # 80002bcc <iupdate>
  iunlockput(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	3be080e7          	jalr	958(ra) # 80002ef8 <iunlockput>
  end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	ba6080e7          	jalr	-1114(ra) # 800036e8 <end_op>
  return 0;
    80004b4a:	4501                	li	a0,0
    80004b4c:	a84d                	j	80004bfe <sys_unlink+0x1c4>
    end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	b9a080e7          	jalr	-1126(ra) # 800036e8 <end_op>
    return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	a05d                	j	80004bfe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b5a:	00004517          	auipc	a0,0x4
    80004b5e:	b5650513          	addi	a0,a0,-1194 # 800086b0 <syscalls+0x2e8>
    80004b62:	00001097          	auipc	ra,0x1
    80004b66:	52a080e7          	jalr	1322(ra) # 8000608c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b6a:	05492703          	lw	a4,84(s2)
    80004b6e:	02000793          	li	a5,32
    80004b72:	f6e7f9e3          	bgeu	a5,a4,80004ae4 <sys_unlink+0xaa>
    80004b76:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	86ce                	mv	a3,s3
    80004b7e:	f1840613          	addi	a2,s0,-232
    80004b82:	4581                	li	a1,0
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	3c4080e7          	jalr	964(ra) # 80002f4a <readi>
    80004b8e:	47c1                	li	a5,16
    80004b90:	00f51b63          	bne	a0,a5,80004ba6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b94:	f1845783          	lhu	a5,-232(s0)
    80004b98:	e7a1                	bnez	a5,80004be0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9a:	29c1                	addiw	s3,s3,16
    80004b9c:	05492783          	lw	a5,84(s2)
    80004ba0:	fcf9ede3          	bltu	s3,a5,80004b7a <sys_unlink+0x140>
    80004ba4:	b781                	j	80004ae4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ba6:	00004517          	auipc	a0,0x4
    80004baa:	b2250513          	addi	a0,a0,-1246 # 800086c8 <syscalls+0x300>
    80004bae:	00001097          	auipc	ra,0x1
    80004bb2:	4de080e7          	jalr	1246(ra) # 8000608c <panic>
    panic("unlink: writei");
    80004bb6:	00004517          	auipc	a0,0x4
    80004bba:	b2a50513          	addi	a0,a0,-1238 # 800086e0 <syscalls+0x318>
    80004bbe:	00001097          	auipc	ra,0x1
    80004bc2:	4ce080e7          	jalr	1230(ra) # 8000608c <panic>
    dp->nlink--;
    80004bc6:	0524d783          	lhu	a5,82(s1)
    80004bca:	37fd                	addiw	a5,a5,-1
    80004bcc:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	ffa080e7          	jalr	-6(ra) # 80002bcc <iupdate>
    80004bda:	b781                	j	80004b1a <sys_unlink+0xe0>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a005                	j	80004bfe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004be0:	854a                	mv	a0,s2
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	316080e7          	jalr	790(ra) # 80002ef8 <iunlockput>
  iunlockput(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	30c080e7          	jalr	780(ra) # 80002ef8 <iunlockput>
  end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	af4080e7          	jalr	-1292(ra) # 800036e8 <end_op>
  return -1;
    80004bfc:	557d                	li	a0,-1
}
    80004bfe:	70ae                	ld	ra,232(sp)
    80004c00:	740e                	ld	s0,224(sp)
    80004c02:	64ee                	ld	s1,216(sp)
    80004c04:	694e                	ld	s2,208(sp)
    80004c06:	69ae                	ld	s3,200(sp)
    80004c08:	616d                	addi	sp,sp,240
    80004c0a:	8082                	ret

0000000080004c0c <sys_open>:

uint64
sys_open(void)
{
    80004c0c:	7131                	addi	sp,sp,-192
    80004c0e:	fd06                	sd	ra,184(sp)
    80004c10:	f922                	sd	s0,176(sp)
    80004c12:	f526                	sd	s1,168(sp)
    80004c14:	f14a                	sd	s2,160(sp)
    80004c16:	ed4e                	sd	s3,152(sp)
    80004c18:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c1a:	08000613          	li	a2,128
    80004c1e:	f5040593          	addi	a1,s0,-176
    80004c22:	4501                	li	a0,0
    80004c24:	ffffd097          	auipc	ra,0xffffd
    80004c28:	46c080e7          	jalr	1132(ra) # 80002090 <argstr>
    return -1;
    80004c2c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c2e:	0c054163          	bltz	a0,80004cf0 <sys_open+0xe4>
    80004c32:	f4c40593          	addi	a1,s0,-180
    80004c36:	4505                	li	a0,1
    80004c38:	ffffd097          	auipc	ra,0xffffd
    80004c3c:	414080e7          	jalr	1044(ra) # 8000204c <argint>
    80004c40:	0a054863          	bltz	a0,80004cf0 <sys_open+0xe4>

  begin_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	a24080e7          	jalr	-1500(ra) # 80003668 <begin_op>

  if(omode & O_CREATE){
    80004c4c:	f4c42783          	lw	a5,-180(s0)
    80004c50:	2007f793          	andi	a5,a5,512
    80004c54:	cbdd                	beqz	a5,80004d0a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c56:	4681                	li	a3,0
    80004c58:	4601                	li	a2,0
    80004c5a:	4589                	li	a1,2
    80004c5c:	f5040513          	addi	a0,s0,-176
    80004c60:	00000097          	auipc	ra,0x0
    80004c64:	972080e7          	jalr	-1678(ra) # 800045d2 <create>
    80004c68:	892a                	mv	s2,a0
    if(ip == 0){
    80004c6a:	c959                	beqz	a0,80004d00 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c6c:	04c91703          	lh	a4,76(s2)
    80004c70:	478d                	li	a5,3
    80004c72:	00f71763          	bne	a4,a5,80004c80 <sys_open+0x74>
    80004c76:	04e95703          	lhu	a4,78(s2)
    80004c7a:	47a5                	li	a5,9
    80004c7c:	0ce7ec63          	bltu	a5,a4,80004d54 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	df8080e7          	jalr	-520(ra) # 80003a78 <filealloc>
    80004c88:	89aa                	mv	s3,a0
    80004c8a:	10050263          	beqz	a0,80004d8e <sys_open+0x182>
    80004c8e:	00000097          	auipc	ra,0x0
    80004c92:	902080e7          	jalr	-1790(ra) # 80004590 <fdalloc>
    80004c96:	84aa                	mv	s1,a0
    80004c98:	0e054663          	bltz	a0,80004d84 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c9c:	04c91703          	lh	a4,76(s2)
    80004ca0:	478d                	li	a5,3
    80004ca2:	0cf70463          	beq	a4,a5,80004d6a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca6:	4789                	li	a5,2
    80004ca8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cac:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb0:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cb4:	f4c42783          	lw	a5,-180(s0)
    80004cb8:	0017c713          	xori	a4,a5,1
    80004cbc:	8b05                	andi	a4,a4,1
    80004cbe:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc2:	0037f713          	andi	a4,a5,3
    80004cc6:	00e03733          	snez	a4,a4
    80004cca:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cce:	4007f793          	andi	a5,a5,1024
    80004cd2:	c791                	beqz	a5,80004cde <sys_open+0xd2>
    80004cd4:	04c91703          	lh	a4,76(s2)
    80004cd8:	4789                	li	a5,2
    80004cda:	08f70f63          	beq	a4,a5,80004d78 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cde:	854a                	mv	a0,s2
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	078080e7          	jalr	120(ra) # 80002d58 <iunlock>
  end_op();
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	a00080e7          	jalr	-1536(ra) # 800036e8 <end_op>

  return fd;
}
    80004cf0:	8526                	mv	a0,s1
    80004cf2:	70ea                	ld	ra,184(sp)
    80004cf4:	744a                	ld	s0,176(sp)
    80004cf6:	74aa                	ld	s1,168(sp)
    80004cf8:	790a                	ld	s2,160(sp)
    80004cfa:	69ea                	ld	s3,152(sp)
    80004cfc:	6129                	addi	sp,sp,192
    80004cfe:	8082                	ret
      end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	9e8080e7          	jalr	-1560(ra) # 800036e8 <end_op>
      return -1;
    80004d08:	b7e5                	j	80004cf0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d0a:	f5040513          	addi	a0,s0,-176
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	73e080e7          	jalr	1854(ra) # 8000344c <namei>
    80004d16:	892a                	mv	s2,a0
    80004d18:	c905                	beqz	a0,80004d48 <sys_open+0x13c>
    ilock(ip);
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	f7c080e7          	jalr	-132(ra) # 80002c96 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d22:	04c91703          	lh	a4,76(s2)
    80004d26:	4785                	li	a5,1
    80004d28:	f4f712e3          	bne	a4,a5,80004c6c <sys_open+0x60>
    80004d2c:	f4c42783          	lw	a5,-180(s0)
    80004d30:	dba1                	beqz	a5,80004c80 <sys_open+0x74>
      iunlockput(ip);
    80004d32:	854a                	mv	a0,s2
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	1c4080e7          	jalr	452(ra) # 80002ef8 <iunlockput>
      end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	9ac080e7          	jalr	-1620(ra) # 800036e8 <end_op>
      return -1;
    80004d44:	54fd                	li	s1,-1
    80004d46:	b76d                	j	80004cf0 <sys_open+0xe4>
      end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	9a0080e7          	jalr	-1632(ra) # 800036e8 <end_op>
      return -1;
    80004d50:	54fd                	li	s1,-1
    80004d52:	bf79                	j	80004cf0 <sys_open+0xe4>
    iunlockput(ip);
    80004d54:	854a                	mv	a0,s2
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	1a2080e7          	jalr	418(ra) # 80002ef8 <iunlockput>
    end_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	98a080e7          	jalr	-1654(ra) # 800036e8 <end_op>
    return -1;
    80004d66:	54fd                	li	s1,-1
    80004d68:	b761                	j	80004cf0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d6a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d6e:	04e91783          	lh	a5,78(s2)
    80004d72:	02f99223          	sh	a5,36(s3)
    80004d76:	bf2d                	j	80004cb0 <sys_open+0xa4>
    itrunc(ip);
    80004d78:	854a                	mv	a0,s2
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	02a080e7          	jalr	42(ra) # 80002da4 <itrunc>
    80004d82:	bfb1                	j	80004cde <sys_open+0xd2>
      fileclose(f);
    80004d84:	854e                	mv	a0,s3
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	dae080e7          	jalr	-594(ra) # 80003b34 <fileclose>
    iunlockput(ip);
    80004d8e:	854a                	mv	a0,s2
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	168080e7          	jalr	360(ra) # 80002ef8 <iunlockput>
    end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	950080e7          	jalr	-1712(ra) # 800036e8 <end_op>
    return -1;
    80004da0:	54fd                	li	s1,-1
    80004da2:	b7b9                	j	80004cf0 <sys_open+0xe4>

0000000080004da4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004da4:	7175                	addi	sp,sp,-144
    80004da6:	e506                	sd	ra,136(sp)
    80004da8:	e122                	sd	s0,128(sp)
    80004daa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	8bc080e7          	jalr	-1860(ra) # 80003668 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004db4:	08000613          	li	a2,128
    80004db8:	f7040593          	addi	a1,s0,-144
    80004dbc:	4501                	li	a0,0
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	2d2080e7          	jalr	722(ra) # 80002090 <argstr>
    80004dc6:	02054963          	bltz	a0,80004df8 <sys_mkdir+0x54>
    80004dca:	4681                	li	a3,0
    80004dcc:	4601                	li	a2,0
    80004dce:	4585                	li	a1,1
    80004dd0:	f7040513          	addi	a0,s0,-144
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	7fe080e7          	jalr	2046(ra) # 800045d2 <create>
    80004ddc:	cd11                	beqz	a0,80004df8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	11a080e7          	jalr	282(ra) # 80002ef8 <iunlockput>
  end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	902080e7          	jalr	-1790(ra) # 800036e8 <end_op>
  return 0;
    80004dee:	4501                	li	a0,0
}
    80004df0:	60aa                	ld	ra,136(sp)
    80004df2:	640a                	ld	s0,128(sp)
    80004df4:	6149                	addi	sp,sp,144
    80004df6:	8082                	ret
    end_op();
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	8f0080e7          	jalr	-1808(ra) # 800036e8 <end_op>
    return -1;
    80004e00:	557d                	li	a0,-1
    80004e02:	b7fd                	j	80004df0 <sys_mkdir+0x4c>

0000000080004e04 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e04:	7135                	addi	sp,sp,-160
    80004e06:	ed06                	sd	ra,152(sp)
    80004e08:	e922                	sd	s0,144(sp)
    80004e0a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	85c080e7          	jalr	-1956(ra) # 80003668 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e14:	08000613          	li	a2,128
    80004e18:	f7040593          	addi	a1,s0,-144
    80004e1c:	4501                	li	a0,0
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	272080e7          	jalr	626(ra) # 80002090 <argstr>
    80004e26:	04054a63          	bltz	a0,80004e7a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e2a:	f6c40593          	addi	a1,s0,-148
    80004e2e:	4505                	li	a0,1
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	21c080e7          	jalr	540(ra) # 8000204c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e38:	04054163          	bltz	a0,80004e7a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e3c:	f6840593          	addi	a1,s0,-152
    80004e40:	4509                	li	a0,2
    80004e42:	ffffd097          	auipc	ra,0xffffd
    80004e46:	20a080e7          	jalr	522(ra) # 8000204c <argint>
     argint(1, &major) < 0 ||
    80004e4a:	02054863          	bltz	a0,80004e7a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e4e:	f6841683          	lh	a3,-152(s0)
    80004e52:	f6c41603          	lh	a2,-148(s0)
    80004e56:	458d                	li	a1,3
    80004e58:	f7040513          	addi	a0,s0,-144
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	776080e7          	jalr	1910(ra) # 800045d2 <create>
     argint(2, &minor) < 0 ||
    80004e64:	c919                	beqz	a0,80004e7a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	092080e7          	jalr	146(ra) # 80002ef8 <iunlockput>
  end_op();
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	87a080e7          	jalr	-1926(ra) # 800036e8 <end_op>
  return 0;
    80004e76:	4501                	li	a0,0
    80004e78:	a031                	j	80004e84 <sys_mknod+0x80>
    end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	86e080e7          	jalr	-1938(ra) # 800036e8 <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
}
    80004e84:	60ea                	ld	ra,152(sp)
    80004e86:	644a                	ld	s0,144(sp)
    80004e88:	610d                	addi	sp,sp,160
    80004e8a:	8082                	ret

0000000080004e8c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e8c:	7135                	addi	sp,sp,-160
    80004e8e:	ed06                	sd	ra,152(sp)
    80004e90:	e922                	sd	s0,144(sp)
    80004e92:	e526                	sd	s1,136(sp)
    80004e94:	e14a                	sd	s2,128(sp)
    80004e96:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	108080e7          	jalr	264(ra) # 80000fa0 <myproc>
    80004ea0:	892a                	mv	s2,a0
  
  begin_op();
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	7c6080e7          	jalr	1990(ra) # 80003668 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eaa:	08000613          	li	a2,128
    80004eae:	f6040593          	addi	a1,s0,-160
    80004eb2:	4501                	li	a0,0
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	1dc080e7          	jalr	476(ra) # 80002090 <argstr>
    80004ebc:	04054b63          	bltz	a0,80004f12 <sys_chdir+0x86>
    80004ec0:	f6040513          	addi	a0,s0,-160
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	588080e7          	jalr	1416(ra) # 8000344c <namei>
    80004ecc:	84aa                	mv	s1,a0
    80004ece:	c131                	beqz	a0,80004f12 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	dc6080e7          	jalr	-570(ra) # 80002c96 <ilock>
  if(ip->type != T_DIR){
    80004ed8:	04c49703          	lh	a4,76(s1)
    80004edc:	4785                	li	a5,1
    80004ede:	04f71063          	bne	a4,a5,80004f1e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ee2:	8526                	mv	a0,s1
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	e74080e7          	jalr	-396(ra) # 80002d58 <iunlock>
  iput(p->cwd);
    80004eec:	15893503          	ld	a0,344(s2)
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	f60080e7          	jalr	-160(ra) # 80002e50 <iput>
  end_op();
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	7f0080e7          	jalr	2032(ra) # 800036e8 <end_op>
  p->cwd = ip;
    80004f00:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f04:	4501                	li	a0,0
}
    80004f06:	60ea                	ld	ra,152(sp)
    80004f08:	644a                	ld	s0,144(sp)
    80004f0a:	64aa                	ld	s1,136(sp)
    80004f0c:	690a                	ld	s2,128(sp)
    80004f0e:	610d                	addi	sp,sp,160
    80004f10:	8082                	ret
    end_op();
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	7d6080e7          	jalr	2006(ra) # 800036e8 <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	b7ed                	j	80004f06 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	fd8080e7          	jalr	-40(ra) # 80002ef8 <iunlockput>
    end_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	7c0080e7          	jalr	1984(ra) # 800036e8 <end_op>
    return -1;
    80004f30:	557d                	li	a0,-1
    80004f32:	bfd1                	j	80004f06 <sys_chdir+0x7a>

0000000080004f34 <sys_exec>:

uint64
sys_exec(void)
{
    80004f34:	7145                	addi	sp,sp,-464
    80004f36:	e786                	sd	ra,456(sp)
    80004f38:	e3a2                	sd	s0,448(sp)
    80004f3a:	ff26                	sd	s1,440(sp)
    80004f3c:	fb4a                	sd	s2,432(sp)
    80004f3e:	f74e                	sd	s3,424(sp)
    80004f40:	f352                	sd	s4,416(sp)
    80004f42:	ef56                	sd	s5,408(sp)
    80004f44:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f46:	08000613          	li	a2,128
    80004f4a:	f4040593          	addi	a1,s0,-192
    80004f4e:	4501                	li	a0,0
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	140080e7          	jalr	320(ra) # 80002090 <argstr>
    return -1;
    80004f58:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f5a:	0c054a63          	bltz	a0,8000502e <sys_exec+0xfa>
    80004f5e:	e3840593          	addi	a1,s0,-456
    80004f62:	4505                	li	a0,1
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	10a080e7          	jalr	266(ra) # 8000206e <argaddr>
    80004f6c:	0c054163          	bltz	a0,8000502e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f70:	10000613          	li	a2,256
    80004f74:	4581                	li	a1,0
    80004f76:	e4040513          	addi	a0,s0,-448
    80004f7a:	ffffb097          	auipc	ra,0xffffb
    80004f7e:	346080e7          	jalr	838(ra) # 800002c0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f82:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f86:	89a6                	mv	s3,s1
    80004f88:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f8a:	02000a13          	li	s4,32
    80004f8e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f92:	00391513          	slli	a0,s2,0x3
    80004f96:	e3040593          	addi	a1,s0,-464
    80004f9a:	e3843783          	ld	a5,-456(s0)
    80004f9e:	953e                	add	a0,a0,a5
    80004fa0:	ffffd097          	auipc	ra,0xffffd
    80004fa4:	012080e7          	jalr	18(ra) # 80001fb2 <fetchaddr>
    80004fa8:	02054a63          	bltz	a0,80004fdc <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fac:	e3043783          	ld	a5,-464(s0)
    80004fb0:	c3b9                	beqz	a5,80004ff6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fb2:	ffffb097          	auipc	ra,0xffffb
    80004fb6:	1ca080e7          	jalr	458(ra) # 8000017c <kalloc>
    80004fba:	85aa                	mv	a1,a0
    80004fbc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fc0:	cd11                	beqz	a0,80004fdc <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fc2:	6605                	lui	a2,0x1
    80004fc4:	e3043503          	ld	a0,-464(s0)
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	03c080e7          	jalr	60(ra) # 80002004 <fetchstr>
    80004fd0:	00054663          	bltz	a0,80004fdc <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fd4:	0905                	addi	s2,s2,1
    80004fd6:	09a1                	addi	s3,s3,8
    80004fd8:	fb491be3          	bne	s2,s4,80004f8e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fdc:	10048913          	addi	s2,s1,256
    80004fe0:	6088                	ld	a0,0(s1)
    80004fe2:	c529                	beqz	a0,8000502c <sys_exec+0xf8>
    kfree(argv[i]);
    80004fe4:	ffffb097          	auipc	ra,0xffffb
    80004fe8:	038080e7          	jalr	56(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	04a1                	addi	s1,s1,8
    80004fee:	ff2499e3          	bne	s1,s2,80004fe0 <sys_exec+0xac>
  return -1;
    80004ff2:	597d                	li	s2,-1
    80004ff4:	a82d                	j	8000502e <sys_exec+0xfa>
      argv[i] = 0;
    80004ff6:	0a8e                	slli	s5,s5,0x3
    80004ff8:	fc040793          	addi	a5,s0,-64
    80004ffc:	9abe                	add	s5,s5,a5
    80004ffe:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005002:	e4040593          	addi	a1,s0,-448
    80005006:	f4040513          	addi	a0,s0,-192
    8000500a:	fffff097          	auipc	ra,0xfffff
    8000500e:	194080e7          	jalr	404(ra) # 8000419e <exec>
    80005012:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005014:	10048993          	addi	s3,s1,256
    80005018:	6088                	ld	a0,0(s1)
    8000501a:	c911                	beqz	a0,8000502e <sys_exec+0xfa>
    kfree(argv[i]);
    8000501c:	ffffb097          	auipc	ra,0xffffb
    80005020:	000080e7          	jalr	ra # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005024:	04a1                	addi	s1,s1,8
    80005026:	ff3499e3          	bne	s1,s3,80005018 <sys_exec+0xe4>
    8000502a:	a011                	j	8000502e <sys_exec+0xfa>
  return -1;
    8000502c:	597d                	li	s2,-1
}
    8000502e:	854a                	mv	a0,s2
    80005030:	60be                	ld	ra,456(sp)
    80005032:	641e                	ld	s0,448(sp)
    80005034:	74fa                	ld	s1,440(sp)
    80005036:	795a                	ld	s2,432(sp)
    80005038:	79ba                	ld	s3,424(sp)
    8000503a:	7a1a                	ld	s4,416(sp)
    8000503c:	6afa                	ld	s5,408(sp)
    8000503e:	6179                	addi	sp,sp,464
    80005040:	8082                	ret

0000000080005042 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005042:	7139                	addi	sp,sp,-64
    80005044:	fc06                	sd	ra,56(sp)
    80005046:	f822                	sd	s0,48(sp)
    80005048:	f426                	sd	s1,40(sp)
    8000504a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000504c:	ffffc097          	auipc	ra,0xffffc
    80005050:	f54080e7          	jalr	-172(ra) # 80000fa0 <myproc>
    80005054:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005056:	fd840593          	addi	a1,s0,-40
    8000505a:	4501                	li	a0,0
    8000505c:	ffffd097          	auipc	ra,0xffffd
    80005060:	012080e7          	jalr	18(ra) # 8000206e <argaddr>
    return -1;
    80005064:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005066:	0e054063          	bltz	a0,80005146 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000506a:	fc840593          	addi	a1,s0,-56
    8000506e:	fd040513          	addi	a0,s0,-48
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	df2080e7          	jalr	-526(ra) # 80003e64 <pipealloc>
    return -1;
    8000507a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000507c:	0c054563          	bltz	a0,80005146 <sys_pipe+0x104>
  fd0 = -1;
    80005080:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005084:	fd043503          	ld	a0,-48(s0)
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	508080e7          	jalr	1288(ra) # 80004590 <fdalloc>
    80005090:	fca42223          	sw	a0,-60(s0)
    80005094:	08054c63          	bltz	a0,8000512c <sys_pipe+0xea>
    80005098:	fc843503          	ld	a0,-56(s0)
    8000509c:	fffff097          	auipc	ra,0xfffff
    800050a0:	4f4080e7          	jalr	1268(ra) # 80004590 <fdalloc>
    800050a4:	fca42023          	sw	a0,-64(s0)
    800050a8:	06054863          	bltz	a0,80005118 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ac:	4691                	li	a3,4
    800050ae:	fc440613          	addi	a2,s0,-60
    800050b2:	fd843583          	ld	a1,-40(s0)
    800050b6:	6ca8                	ld	a0,88(s1)
    800050b8:	ffffc097          	auipc	ra,0xffffc
    800050bc:	baa080e7          	jalr	-1110(ra) # 80000c62 <copyout>
    800050c0:	02054063          	bltz	a0,800050e0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050c4:	4691                	li	a3,4
    800050c6:	fc040613          	addi	a2,s0,-64
    800050ca:	fd843583          	ld	a1,-40(s0)
    800050ce:	0591                	addi	a1,a1,4
    800050d0:	6ca8                	ld	a0,88(s1)
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	b90080e7          	jalr	-1136(ra) # 80000c62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050da:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050dc:	06055563          	bgez	a0,80005146 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050e0:	fc442783          	lw	a5,-60(s0)
    800050e4:	07e9                	addi	a5,a5,26
    800050e6:	078e                	slli	a5,a5,0x3
    800050e8:	97a6                	add	a5,a5,s1
    800050ea:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800050ee:	fc042503          	lw	a0,-64(s0)
    800050f2:	0569                	addi	a0,a0,26
    800050f4:	050e                	slli	a0,a0,0x3
    800050f6:	9526                	add	a0,a0,s1
    800050f8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800050fc:	fd043503          	ld	a0,-48(s0)
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	a34080e7          	jalr	-1484(ra) # 80003b34 <fileclose>
    fileclose(wf);
    80005108:	fc843503          	ld	a0,-56(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	a28080e7          	jalr	-1496(ra) # 80003b34 <fileclose>
    return -1;
    80005114:	57fd                	li	a5,-1
    80005116:	a805                	j	80005146 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005118:	fc442783          	lw	a5,-60(s0)
    8000511c:	0007c863          	bltz	a5,8000512c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005120:	01a78513          	addi	a0,a5,26
    80005124:	050e                	slli	a0,a0,0x3
    80005126:	9526                	add	a0,a0,s1
    80005128:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000512c:	fd043503          	ld	a0,-48(s0)
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	a04080e7          	jalr	-1532(ra) # 80003b34 <fileclose>
    fileclose(wf);
    80005138:	fc843503          	ld	a0,-56(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	9f8080e7          	jalr	-1544(ra) # 80003b34 <fileclose>
    return -1;
    80005144:	57fd                	li	a5,-1
}
    80005146:	853e                	mv	a0,a5
    80005148:	70e2                	ld	ra,56(sp)
    8000514a:	7442                	ld	s0,48(sp)
    8000514c:	74a2                	ld	s1,40(sp)
    8000514e:	6121                	addi	sp,sp,64
    80005150:	8082                	ret
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	addi	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	cdffc0ef          	jal	ra,80001e7e <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	addi	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	c3d8                	sw	a4,4(a5)
}
    8000522a:	6422                	ld	s0,8(sp)
    8000522c:	0141                	addi	sp,sp,16
    8000522e:	8082                	ret

0000000080005230 <plicinithart>:

void
plicinithart(void)
{
    80005230:	1141                	addi	sp,sp,-16
    80005232:	e406                	sd	ra,8(sp)
    80005234:	e022                	sd	s0,0(sp)
    80005236:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	d3c080e7          	jalr	-708(ra) # 80000f74 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005240:	0085171b          	slliw	a4,a0,0x8
    80005244:	0c0027b7          	lui	a5,0xc002
    80005248:	97ba                	add	a5,a5,a4
    8000524a:	40200713          	li	a4,1026
    8000524e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005252:	00d5151b          	slliw	a0,a0,0xd
    80005256:	0c2017b7          	lui	a5,0xc201
    8000525a:	953e                	add	a0,a0,a5
    8000525c:	00052023          	sw	zero,0(a0)
}
    80005260:	60a2                	ld	ra,8(sp)
    80005262:	6402                	ld	s0,0(sp)
    80005264:	0141                	addi	sp,sp,16
    80005266:	8082                	ret

0000000080005268 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	d04080e7          	jalr	-764(ra) # 80000f74 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005278:	00d5179b          	slliw	a5,a0,0xd
    8000527c:	0c201537          	lui	a0,0xc201
    80005280:	953e                	add	a0,a0,a5
  return irq;
}
    80005282:	4148                	lw	a0,4(a0)
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000528c:	1101                	addi	sp,sp,-32
    8000528e:	ec06                	sd	ra,24(sp)
    80005290:	e822                	sd	s0,16(sp)
    80005292:	e426                	sd	s1,8(sp)
    80005294:	1000                	addi	s0,sp,32
    80005296:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	cdc080e7          	jalr	-804(ra) # 80000f74 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a0:	00d5151b          	slliw	a0,a0,0xd
    800052a4:	0c2017b7          	lui	a5,0xc201
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	c3c4                	sw	s1,4(a5)
}
    800052ac:	60e2                	ld	ra,24(sp)
    800052ae:	6442                	ld	s0,16(sp)
    800052b0:	64a2                	ld	s1,8(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052b6:	1141                	addi	sp,sp,-16
    800052b8:	e406                	sd	ra,8(sp)
    800052ba:	e022                	sd	s0,0(sp)
    800052bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052be:	479d                	li	a5,7
    800052c0:	06a7c963          	blt	a5,a0,80005332 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052c4:	00019797          	auipc	a5,0x19
    800052c8:	d3c78793          	addi	a5,a5,-708 # 8001e000 <disk>
    800052cc:	00a78733          	add	a4,a5,a0
    800052d0:	6789                	lui	a5,0x2
    800052d2:	97ba                	add	a5,a5,a4
    800052d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052d8:	e7ad                	bnez	a5,80005342 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052da:	00451793          	slli	a5,a0,0x4
    800052de:	0001b717          	auipc	a4,0x1b
    800052e2:	d2270713          	addi	a4,a4,-734 # 80020000 <disk+0x2000>
    800052e6:	6314                	ld	a3,0(a4)
    800052e8:	96be                	add	a3,a3,a5
    800052ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ee:	6314                	ld	a3,0(a4)
    800052f0:	96be                	add	a3,a3,a5
    800052f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052f6:	6314                	ld	a3,0(a4)
    800052f8:	96be                	add	a3,a3,a5
    800052fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052fe:	6318                	ld	a4,0(a4)
    80005300:	97ba                	add	a5,a5,a4
    80005302:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005306:	00019797          	auipc	a5,0x19
    8000530a:	cfa78793          	addi	a5,a5,-774 # 8001e000 <disk>
    8000530e:	97aa                	add	a5,a5,a0
    80005310:	6509                	lui	a0,0x2
    80005312:	953e                	add	a0,a0,a5
    80005314:	4785                	li	a5,1
    80005316:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000531a:	0001b517          	auipc	a0,0x1b
    8000531e:	cfe50513          	addi	a0,a0,-770 # 80020018 <disk+0x2018>
    80005322:	ffffc097          	auipc	ra,0xffffc
    80005326:	4c6080e7          	jalr	1222(ra) # 800017e8 <wakeup>
}
    8000532a:	60a2                	ld	ra,8(sp)
    8000532c:	6402                	ld	s0,0(sp)
    8000532e:	0141                	addi	sp,sp,16
    80005330:	8082                	ret
    panic("free_desc 1");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3be50513          	addi	a0,a0,958 # 800086f0 <syscalls+0x328>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	d52080e7          	jalr	-686(ra) # 8000608c <panic>
    panic("free_desc 2");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	3be50513          	addi	a0,a0,958 # 80008700 <syscalls+0x338>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	d42080e7          	jalr	-702(ra) # 8000608c <panic>

0000000080005352 <virtio_disk_init>:
{
    80005352:	1101                	addi	sp,sp,-32
    80005354:	ec06                	sd	ra,24(sp)
    80005356:	e822                	sd	s0,16(sp)
    80005358:	e426                	sd	s1,8(sp)
    8000535a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000535c:	00003597          	auipc	a1,0x3
    80005360:	3b458593          	addi	a1,a1,948 # 80008710 <syscalls+0x348>
    80005364:	0001b517          	auipc	a0,0x1b
    80005368:	dc450513          	addi	a0,a0,-572 # 80020128 <disk+0x2128>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	3d0080e7          	jalr	976(ra) # 8000673c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	4398                	lw	a4,0(a5)
    8000537a:	2701                	sext.w	a4,a4
    8000537c:	747277b7          	lui	a5,0x74727
    80005380:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005384:	0ef71163          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	43dc                	lw	a5,4(a5)
    8000538e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005390:	4705                	li	a4,1
    80005392:	0ce79a63          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005396:	100017b7          	lui	a5,0x10001
    8000539a:	479c                	lw	a5,8(a5)
    8000539c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000539e:	4709                	li	a4,2
    800053a0:	0ce79363          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	47d8                	lw	a4,12(a5)
    800053aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ac:	554d47b7          	lui	a5,0x554d4
    800053b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053b4:	0af71963          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	4705                	li	a4,1
    800053be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c0:	470d                	li	a4,3
    800053c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053c6:	c7ffe737          	lui	a4,0xc7ffe
    800053ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    800053ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053d0:	2701                	sext.w	a4,a4
    800053d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d4:	472d                	li	a4,11
    800053d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d8:	473d                	li	a4,15
    800053da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053dc:	6705                	lui	a4,0x1
    800053de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053e4:	5bdc                	lw	a5,52(a5)
    800053e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053e8:	c7d9                	beqz	a5,80005476 <virtio_disk_init+0x124>
  if(max < NUM)
    800053ea:	471d                	li	a4,7
    800053ec:	08f77d63          	bgeu	a4,a5,80005486 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053f0:	100014b7          	lui	s1,0x10001
    800053f4:	47a1                	li	a5,8
    800053f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053f8:	6609                	lui	a2,0x2
    800053fa:	4581                	li	a1,0
    800053fc:	00019517          	auipc	a0,0x19
    80005400:	c0450513          	addi	a0,a0,-1020 # 8001e000 <disk>
    80005404:	ffffb097          	auipc	ra,0xffffb
    80005408:	ebc080e7          	jalr	-324(ra) # 800002c0 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000540c:	00019717          	auipc	a4,0x19
    80005410:	bf470713          	addi	a4,a4,-1036 # 8001e000 <disk>
    80005414:	00c75793          	srli	a5,a4,0xc
    80005418:	2781                	sext.w	a5,a5
    8000541a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000541c:	0001b797          	auipc	a5,0x1b
    80005420:	be478793          	addi	a5,a5,-1052 # 80020000 <disk+0x2000>
    80005424:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005426:	00019717          	auipc	a4,0x19
    8000542a:	c5a70713          	addi	a4,a4,-934 # 8001e080 <disk+0x80>
    8000542e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005430:	0001a717          	auipc	a4,0x1a
    80005434:	bd070713          	addi	a4,a4,-1072 # 8001f000 <disk+0x1000>
    80005438:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000543a:	4705                	li	a4,1
    8000543c:	00e78c23          	sb	a4,24(a5)
    80005440:	00e78ca3          	sb	a4,25(a5)
    80005444:	00e78d23          	sb	a4,26(a5)
    80005448:	00e78da3          	sb	a4,27(a5)
    8000544c:	00e78e23          	sb	a4,28(a5)
    80005450:	00e78ea3          	sb	a4,29(a5)
    80005454:	00e78f23          	sb	a4,30(a5)
    80005458:	00e78fa3          	sb	a4,31(a5)
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	64a2                	ld	s1,8(sp)
    80005462:	6105                	addi	sp,sp,32
    80005464:	8082                	ret
    panic("could not find virtio disk");
    80005466:	00003517          	auipc	a0,0x3
    8000546a:	2ba50513          	addi	a0,a0,698 # 80008720 <syscalls+0x358>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	c1e080e7          	jalr	-994(ra) # 8000608c <panic>
    panic("virtio disk has no queue 0");
    80005476:	00003517          	auipc	a0,0x3
    8000547a:	2ca50513          	addi	a0,a0,714 # 80008740 <syscalls+0x378>
    8000547e:	00001097          	auipc	ra,0x1
    80005482:	c0e080e7          	jalr	-1010(ra) # 8000608c <panic>
    panic("virtio disk max queue too short");
    80005486:	00003517          	auipc	a0,0x3
    8000548a:	2da50513          	addi	a0,a0,730 # 80008760 <syscalls+0x398>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	bfe080e7          	jalr	-1026(ra) # 8000608c <panic>

0000000080005496 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005496:	7159                	addi	sp,sp,-112
    80005498:	f486                	sd	ra,104(sp)
    8000549a:	f0a2                	sd	s0,96(sp)
    8000549c:	eca6                	sd	s1,88(sp)
    8000549e:	e8ca                	sd	s2,80(sp)
    800054a0:	e4ce                	sd	s3,72(sp)
    800054a2:	e0d2                	sd	s4,64(sp)
    800054a4:	fc56                	sd	s5,56(sp)
    800054a6:	f85a                	sd	s6,48(sp)
    800054a8:	f45e                	sd	s7,40(sp)
    800054aa:	f062                	sd	s8,32(sp)
    800054ac:	ec66                	sd	s9,24(sp)
    800054ae:	e86a                	sd	s10,16(sp)
    800054b0:	1880                	addi	s0,sp,112
    800054b2:	892a                	mv	s2,a0
    800054b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054b6:	01052c83          	lw	s9,16(a0)
    800054ba:	001c9c9b          	slliw	s9,s9,0x1
    800054be:	1c82                	slli	s9,s9,0x20
    800054c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054c4:	0001b517          	auipc	a0,0x1b
    800054c8:	c6450513          	addi	a0,a0,-924 # 80020128 <disk+0x2128>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	0f4080e7          	jalr	244(ra) # 800065c0 <acquire>
  for(int i = 0; i < 3; i++){
    800054d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054d8:	00019b97          	auipc	s7,0x19
    800054dc:	b28b8b93          	addi	s7,s7,-1240 # 8001e000 <disk>
    800054e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054e4:	8a4e                	mv	s4,s3
    800054e6:	a051                	j	8000556a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054e8:	00fb86b3          	add	a3,s7,a5
    800054ec:	96da                	add	a3,a3,s6
    800054ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054f4:	0207c563          	bltz	a5,8000551e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054f8:	2485                	addiw	s1,s1,1
    800054fa:	0711                	addi	a4,a4,4
    800054fc:	25548063          	beq	s1,s5,8000573c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005500:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005502:	0001b697          	auipc	a3,0x1b
    80005506:	b1668693          	addi	a3,a3,-1258 # 80020018 <disk+0x2018>
    8000550a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000550c:	0006c583          	lbu	a1,0(a3)
    80005510:	fde1                	bnez	a1,800054e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005512:	2785                	addiw	a5,a5,1
    80005514:	0685                	addi	a3,a3,1
    80005516:	ff879be3          	bne	a5,s8,8000550c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000551a:	57fd                	li	a5,-1
    8000551c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000551e:	02905a63          	blez	s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005522:	f9042503          	lw	a0,-112(s0)
    80005526:	00000097          	auipc	ra,0x0
    8000552a:	d90080e7          	jalr	-624(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000552e:	4785                	li	a5,1
    80005530:	0297d163          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005534:	f9442503          	lw	a0,-108(s0)
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	d7e080e7          	jalr	-642(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005540:	4789                	li	a5,2
    80005542:	0097d863          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005546:	f9842503          	lw	a0,-104(s0)
    8000554a:	00000097          	auipc	ra,0x0
    8000554e:	d6c080e7          	jalr	-660(ra) # 800052b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005552:	0001b597          	auipc	a1,0x1b
    80005556:	bd658593          	addi	a1,a1,-1066 # 80020128 <disk+0x2128>
    8000555a:	0001b517          	auipc	a0,0x1b
    8000555e:	abe50513          	addi	a0,a0,-1346 # 80020018 <disk+0x2018>
    80005562:	ffffc097          	auipc	ra,0xffffc
    80005566:	0fa080e7          	jalr	250(ra) # 8000165c <sleep>
  for(int i = 0; i < 3; i++){
    8000556a:	f9040713          	addi	a4,s0,-112
    8000556e:	84ce                	mv	s1,s3
    80005570:	bf41                	j	80005500 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005572:	20058713          	addi	a4,a1,512
    80005576:	00471693          	slli	a3,a4,0x4
    8000557a:	00019717          	auipc	a4,0x19
    8000557e:	a8670713          	addi	a4,a4,-1402 # 8001e000 <disk>
    80005582:	9736                	add	a4,a4,a3
    80005584:	4685                	li	a3,1
    80005586:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000558a:	20058713          	addi	a4,a1,512
    8000558e:	00471693          	slli	a3,a4,0x4
    80005592:	00019717          	auipc	a4,0x19
    80005596:	a6e70713          	addi	a4,a4,-1426 # 8001e000 <disk>
    8000559a:	9736                	add	a4,a4,a3
    8000559c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055a4:	7679                	lui	a2,0xffffe
    800055a6:	963e                	add	a2,a2,a5
    800055a8:	0001b697          	auipc	a3,0x1b
    800055ac:	a5868693          	addi	a3,a3,-1448 # 80020000 <disk+0x2000>
    800055b0:	6298                	ld	a4,0(a3)
    800055b2:	9732                	add	a4,a4,a2
    800055b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055b6:	6298                	ld	a4,0(a3)
    800055b8:	9732                	add	a4,a4,a2
    800055ba:	4541                	li	a0,16
    800055bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055be:	6298                	ld	a4,0(a3)
    800055c0:	9732                	add	a4,a4,a2
    800055c2:	4505                	li	a0,1
    800055c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055c8:	f9442703          	lw	a4,-108(s0)
    800055cc:	6288                	ld	a0,0(a3)
    800055ce:	962a                	add	a2,a2,a0
    800055d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055d4:	0712                	slli	a4,a4,0x4
    800055d6:	6290                	ld	a2,0(a3)
    800055d8:	963a                	add	a2,a2,a4
    800055da:	06890513          	addi	a0,s2,104
    800055de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055e0:	6294                	ld	a3,0(a3)
    800055e2:	96ba                	add	a3,a3,a4
    800055e4:	40000613          	li	a2,1024
    800055e8:	c690                	sw	a2,8(a3)
  if(write)
    800055ea:	140d0063          	beqz	s10,8000572a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ee:	0001b697          	auipc	a3,0x1b
    800055f2:	a126b683          	ld	a3,-1518(a3) # 80020000 <disk+0x2000>
    800055f6:	96ba                	add	a3,a3,a4
    800055f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055fc:	00019817          	auipc	a6,0x19
    80005600:	a0480813          	addi	a6,a6,-1532 # 8001e000 <disk>
    80005604:	0001b517          	auipc	a0,0x1b
    80005608:	9fc50513          	addi	a0,a0,-1540 # 80020000 <disk+0x2000>
    8000560c:	6114                	ld	a3,0(a0)
    8000560e:	96ba                	add	a3,a3,a4
    80005610:	00c6d603          	lhu	a2,12(a3)
    80005614:	00166613          	ori	a2,a2,1
    80005618:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000561c:	f9842683          	lw	a3,-104(s0)
    80005620:	6110                	ld	a2,0(a0)
    80005622:	9732                	add	a4,a4,a2
    80005624:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005628:	20058613          	addi	a2,a1,512
    8000562c:	0612                	slli	a2,a2,0x4
    8000562e:	9642                	add	a2,a2,a6
    80005630:	577d                	li	a4,-1
    80005632:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005636:	00469713          	slli	a4,a3,0x4
    8000563a:	6114                	ld	a3,0(a0)
    8000563c:	96ba                	add	a3,a3,a4
    8000563e:	03078793          	addi	a5,a5,48
    80005642:	97c2                	add	a5,a5,a6
    80005644:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005646:	611c                	ld	a5,0(a0)
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	4685                	li	a3,1
    8000564c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000564e:	611c                	ld	a5,0(a0)
    80005650:	97ba                	add	a5,a5,a4
    80005652:	4809                	li	a6,2
    80005654:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005658:	611c                	ld	a5,0(a0)
    8000565a:	973e                	add	a4,a4,a5
    8000565c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005660:	00d92423          	sw	a3,8(s2)
  disk.info[idx[0]].b = b;
    80005664:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005668:	6518                	ld	a4,8(a0)
    8000566a:	00275783          	lhu	a5,2(a4)
    8000566e:	8b9d                	andi	a5,a5,7
    80005670:	0786                	slli	a5,a5,0x1
    80005672:	97ba                	add	a5,a5,a4
    80005674:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005678:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000567c:	6518                	ld	a4,8(a0)
    8000567e:	00275783          	lhu	a5,2(a4)
    80005682:	2785                	addiw	a5,a5,1
    80005684:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005688:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000568c:	100017b7          	lui	a5,0x10001
    80005690:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005694:	00892703          	lw	a4,8(s2)
    80005698:	4785                	li	a5,1
    8000569a:	02f71163          	bne	a4,a5,800056bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000569e:	0001b997          	auipc	s3,0x1b
    800056a2:	a8a98993          	addi	s3,s3,-1398 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800056a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056a8:	85ce                	mv	a1,s3
    800056aa:	854a                	mv	a0,s2
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	fb0080e7          	jalr	-80(ra) # 8000165c <sleep>
  while(b->disk == 1) {
    800056b4:	00892783          	lw	a5,8(s2)
    800056b8:	fe9788e3          	beq	a5,s1,800056a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056bc:	f9042903          	lw	s2,-112(s0)
    800056c0:	20090793          	addi	a5,s2,512
    800056c4:	00479713          	slli	a4,a5,0x4
    800056c8:	00019797          	auipc	a5,0x19
    800056cc:	93878793          	addi	a5,a5,-1736 # 8001e000 <disk>
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056d6:	0001b997          	auipc	s3,0x1b
    800056da:	92a98993          	addi	s3,s3,-1750 # 80020000 <disk+0x2000>
    800056de:	00491713          	slli	a4,s2,0x4
    800056e2:	0009b783          	ld	a5,0(s3)
    800056e6:	97ba                	add	a5,a5,a4
    800056e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ec:	854a                	mv	a0,s2
    800056ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f2:	00000097          	auipc	ra,0x0
    800056f6:	bc4080e7          	jalr	-1084(ra) # 800052b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056fa:	8885                	andi	s1,s1,1
    800056fc:	f0ed                	bnez	s1,800056de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056fe:	0001b517          	auipc	a0,0x1b
    80005702:	a2a50513          	addi	a0,a0,-1494 # 80020128 <disk+0x2128>
    80005706:	00001097          	auipc	ra,0x1
    8000570a:	f8a080e7          	jalr	-118(ra) # 80006690 <release>
}
    8000570e:	70a6                	ld	ra,104(sp)
    80005710:	7406                	ld	s0,96(sp)
    80005712:	64e6                	ld	s1,88(sp)
    80005714:	6946                	ld	s2,80(sp)
    80005716:	69a6                	ld	s3,72(sp)
    80005718:	6a06                	ld	s4,64(sp)
    8000571a:	7ae2                	ld	s5,56(sp)
    8000571c:	7b42                	ld	s6,48(sp)
    8000571e:	7ba2                	ld	s7,40(sp)
    80005720:	7c02                	ld	s8,32(sp)
    80005722:	6ce2                	ld	s9,24(sp)
    80005724:	6d42                	ld	s10,16(sp)
    80005726:	6165                	addi	sp,sp,112
    80005728:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000572a:	0001b697          	auipc	a3,0x1b
    8000572e:	8d66b683          	ld	a3,-1834(a3) # 80020000 <disk+0x2000>
    80005732:	96ba                	add	a3,a3,a4
    80005734:	4609                	li	a2,2
    80005736:	00c69623          	sh	a2,12(a3)
    8000573a:	b5c9                	j	800055fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000573c:	f9042583          	lw	a1,-112(s0)
    80005740:	20058793          	addi	a5,a1,512
    80005744:	0792                	slli	a5,a5,0x4
    80005746:	00019517          	auipc	a0,0x19
    8000574a:	96250513          	addi	a0,a0,-1694 # 8001e0a8 <disk+0xa8>
    8000574e:	953e                	add	a0,a0,a5
  if(write)
    80005750:	e20d11e3          	bnez	s10,80005572 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005754:	20058713          	addi	a4,a1,512
    80005758:	00471693          	slli	a3,a4,0x4
    8000575c:	00019717          	auipc	a4,0x19
    80005760:	8a470713          	addi	a4,a4,-1884 # 8001e000 <disk>
    80005764:	9736                	add	a4,a4,a3
    80005766:	0a072423          	sw	zero,168(a4)
    8000576a:	b505                	j	8000558a <virtio_disk_rw+0xf4>

000000008000576c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000576c:	1101                	addi	sp,sp,-32
    8000576e:	ec06                	sd	ra,24(sp)
    80005770:	e822                	sd	s0,16(sp)
    80005772:	e426                	sd	s1,8(sp)
    80005774:	e04a                	sd	s2,0(sp)
    80005776:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005778:	0001b517          	auipc	a0,0x1b
    8000577c:	9b050513          	addi	a0,a0,-1616 # 80020128 <disk+0x2128>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	e40080e7          	jalr	-448(ra) # 800065c0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005788:	10001737          	lui	a4,0x10001
    8000578c:	533c                	lw	a5,96(a4)
    8000578e:	8b8d                	andi	a5,a5,3
    80005790:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005792:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005796:	0001b797          	auipc	a5,0x1b
    8000579a:	86a78793          	addi	a5,a5,-1942 # 80020000 <disk+0x2000>
    8000579e:	6b94                	ld	a3,16(a5)
    800057a0:	0207d703          	lhu	a4,32(a5)
    800057a4:	0026d783          	lhu	a5,2(a3)
    800057a8:	06f70163          	beq	a4,a5,8000580a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ac:	00019917          	auipc	s2,0x19
    800057b0:	85490913          	addi	s2,s2,-1964 # 8001e000 <disk>
    800057b4:	0001b497          	auipc	s1,0x1b
    800057b8:	84c48493          	addi	s1,s1,-1972 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800057bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c0:	6898                	ld	a4,16(s1)
    800057c2:	0204d783          	lhu	a5,32(s1)
    800057c6:	8b9d                	andi	a5,a5,7
    800057c8:	078e                	slli	a5,a5,0x3
    800057ca:	97ba                	add	a5,a5,a4
    800057cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ce:	20078713          	addi	a4,a5,512
    800057d2:	0712                	slli	a4,a4,0x4
    800057d4:	974a                	add	a4,a4,s2
    800057d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057da:	e731                	bnez	a4,80005826 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057dc:	20078793          	addi	a5,a5,512
    800057e0:	0792                	slli	a5,a5,0x4
    800057e2:	97ca                	add	a5,a5,s2
    800057e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057e6:	00052423          	sw	zero,8(a0)
    wakeup(b);
    800057ea:	ffffc097          	auipc	ra,0xffffc
    800057ee:	ffe080e7          	jalr	-2(ra) # 800017e8 <wakeup>

    disk.used_idx += 1;
    800057f2:	0204d783          	lhu	a5,32(s1)
    800057f6:	2785                	addiw	a5,a5,1
    800057f8:	17c2                	slli	a5,a5,0x30
    800057fa:	93c1                	srli	a5,a5,0x30
    800057fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005800:	6898                	ld	a4,16(s1)
    80005802:	00275703          	lhu	a4,2(a4)
    80005806:	faf71be3          	bne	a4,a5,800057bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000580a:	0001b517          	auipc	a0,0x1b
    8000580e:	91e50513          	addi	a0,a0,-1762 # 80020128 <disk+0x2128>
    80005812:	00001097          	auipc	ra,0x1
    80005816:	e7e080e7          	jalr	-386(ra) # 80006690 <release>
}
    8000581a:	60e2                	ld	ra,24(sp)
    8000581c:	6442                	ld	s0,16(sp)
    8000581e:	64a2                	ld	s1,8(sp)
    80005820:	6902                	ld	s2,0(sp)
    80005822:	6105                	addi	sp,sp,32
    80005824:	8082                	ret
      panic("virtio_disk_intr status");
    80005826:	00003517          	auipc	a0,0x3
    8000582a:	f5a50513          	addi	a0,a0,-166 # 80008780 <syscalls+0x3b8>
    8000582e:	00001097          	auipc	ra,0x1
    80005832:	85e080e7          	jalr	-1954(ra) # 8000608c <panic>

0000000080005836 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005836:	1141                	addi	sp,sp,-16
    80005838:	e422                	sd	s0,8(sp)
    8000583a:	0800                	addi	s0,sp,16
  return -1;
}
    8000583c:	557d                	li	a0,-1
    8000583e:	6422                	ld	s0,8(sp)
    80005840:	0141                	addi	sp,sp,16
    80005842:	8082                	ret

0000000080005844 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005844:	7179                	addi	sp,sp,-48
    80005846:	f406                	sd	ra,40(sp)
    80005848:	f022                	sd	s0,32(sp)
    8000584a:	ec26                	sd	s1,24(sp)
    8000584c:	e84a                	sd	s2,16(sp)
    8000584e:	e44e                	sd	s3,8(sp)
    80005850:	e052                	sd	s4,0(sp)
    80005852:	1800                	addi	s0,sp,48
    80005854:	892a                	mv	s2,a0
    80005856:	89ae                	mv	s3,a1
    80005858:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000585a:	0001b517          	auipc	a0,0x1b
    8000585e:	7a650513          	addi	a0,a0,1958 # 80021000 <stats>
    80005862:	00001097          	auipc	ra,0x1
    80005866:	d5e080e7          	jalr	-674(ra) # 800065c0 <acquire>

  if(stats.sz == 0) {
    8000586a:	0001c797          	auipc	a5,0x1c
    8000586e:	7b67a783          	lw	a5,1974(a5) # 80022020 <stats+0x1020>
    80005872:	cbb5                	beqz	a5,800058e6 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005874:	0001c797          	auipc	a5,0x1c
    80005878:	78c78793          	addi	a5,a5,1932 # 80022000 <stats+0x1000>
    8000587c:	53d8                	lw	a4,36(a5)
    8000587e:	539c                	lw	a5,32(a5)
    80005880:	9f99                	subw	a5,a5,a4
    80005882:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005886:	06d05e63          	blez	a3,80005902 <statsread+0xbe>
    if(m > n)
    8000588a:	8a3e                	mv	s4,a5
    8000588c:	00d4d363          	bge	s1,a3,80005892 <statsread+0x4e>
    80005890:	8a26                	mv	s4,s1
    80005892:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005896:	86a6                	mv	a3,s1
    80005898:	0001b617          	auipc	a2,0x1b
    8000589c:	78860613          	addi	a2,a2,1928 # 80021020 <stats+0x20>
    800058a0:	963a                	add	a2,a2,a4
    800058a2:	85ce                	mv	a1,s3
    800058a4:	854a                	mv	a0,s2
    800058a6:	ffffc097          	auipc	ra,0xffffc
    800058aa:	15a080e7          	jalr	346(ra) # 80001a00 <either_copyout>
    800058ae:	57fd                	li	a5,-1
    800058b0:	00f50a63          	beq	a0,a5,800058c4 <statsread+0x80>
      stats.off += m;
    800058b4:	0001c717          	auipc	a4,0x1c
    800058b8:	74c70713          	addi	a4,a4,1868 # 80022000 <stats+0x1000>
    800058bc:	535c                	lw	a5,36(a4)
    800058be:	014787bb          	addw	a5,a5,s4
    800058c2:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800058c4:	0001b517          	auipc	a0,0x1b
    800058c8:	73c50513          	addi	a0,a0,1852 # 80021000 <stats>
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	dc4080e7          	jalr	-572(ra) # 80006690 <release>
  return m;
}
    800058d4:	8526                	mv	a0,s1
    800058d6:	70a2                	ld	ra,40(sp)
    800058d8:	7402                	ld	s0,32(sp)
    800058da:	64e2                	ld	s1,24(sp)
    800058dc:	6942                	ld	s2,16(sp)
    800058de:	69a2                	ld	s3,8(sp)
    800058e0:	6a02                	ld	s4,0(sp)
    800058e2:	6145                	addi	sp,sp,48
    800058e4:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    800058e6:	6585                	lui	a1,0x1
    800058e8:	0001b517          	auipc	a0,0x1b
    800058ec:	73850513          	addi	a0,a0,1848 # 80021020 <stats+0x20>
    800058f0:	00001097          	auipc	ra,0x1
    800058f4:	f28080e7          	jalr	-216(ra) # 80006818 <statslock>
    800058f8:	0001c797          	auipc	a5,0x1c
    800058fc:	72a7a423          	sw	a0,1832(a5) # 80022020 <stats+0x1020>
    80005900:	bf95                	j	80005874 <statsread+0x30>
    stats.sz = 0;
    80005902:	0001c797          	auipc	a5,0x1c
    80005906:	6fe78793          	addi	a5,a5,1790 # 80022000 <stats+0x1000>
    8000590a:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    8000590e:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005912:	54fd                	li	s1,-1
    80005914:	bf45                	j	800058c4 <statsread+0x80>

0000000080005916 <statsinit>:

void
statsinit(void)
{
    80005916:	1141                	addi	sp,sp,-16
    80005918:	e406                	sd	ra,8(sp)
    8000591a:	e022                	sd	s0,0(sp)
    8000591c:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    8000591e:	00003597          	auipc	a1,0x3
    80005922:	e7a58593          	addi	a1,a1,-390 # 80008798 <syscalls+0x3d0>
    80005926:	0001b517          	auipc	a0,0x1b
    8000592a:	6da50513          	addi	a0,a0,1754 # 80021000 <stats>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	e0e080e7          	jalr	-498(ra) # 8000673c <initlock>

  devsw[STATS].read = statsread;
    80005936:	00017797          	auipc	a5,0x17
    8000593a:	50278793          	addi	a5,a5,1282 # 8001ce38 <devsw>
    8000593e:	00000717          	auipc	a4,0x0
    80005942:	f0670713          	addi	a4,a4,-250 # 80005844 <statsread>
    80005946:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005948:	00000717          	auipc	a4,0x0
    8000594c:	eee70713          	addi	a4,a4,-274 # 80005836 <statswrite>
    80005950:	f798                	sd	a4,40(a5)
}
    80005952:	60a2                	ld	ra,8(sp)
    80005954:	6402                	ld	s0,0(sp)
    80005956:	0141                	addi	sp,sp,16
    80005958:	8082                	ret

000000008000595a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    8000595a:	1101                	addi	sp,sp,-32
    8000595c:	ec22                	sd	s0,24(sp)
    8000595e:	1000                	addi	s0,sp,32
    80005960:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005962:	c299                	beqz	a3,80005968 <sprintint+0xe>
    80005964:	0805c163          	bltz	a1,800059e6 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005968:	2581                	sext.w	a1,a1
    8000596a:	4301                	li	t1,0

  i = 0;
    8000596c:	fe040713          	addi	a4,s0,-32
    80005970:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005972:	2601                	sext.w	a2,a2
    80005974:	00003697          	auipc	a3,0x3
    80005978:	e4468693          	addi	a3,a3,-444 # 800087b8 <digits>
    8000597c:	88aa                	mv	a7,a0
    8000597e:	2505                	addiw	a0,a0,1
    80005980:	02c5f7bb          	remuw	a5,a1,a2
    80005984:	1782                	slli	a5,a5,0x20
    80005986:	9381                	srli	a5,a5,0x20
    80005988:	97b6                	add	a5,a5,a3
    8000598a:	0007c783          	lbu	a5,0(a5)
    8000598e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005992:	0005879b          	sext.w	a5,a1
    80005996:	02c5d5bb          	divuw	a1,a1,a2
    8000599a:	0705                	addi	a4,a4,1
    8000599c:	fec7f0e3          	bgeu	a5,a2,8000597c <sprintint+0x22>

  if(sign)
    800059a0:	00030b63          	beqz	t1,800059b6 <sprintint+0x5c>
    buf[i++] = '-';
    800059a4:	ff040793          	addi	a5,s0,-16
    800059a8:	97aa                	add	a5,a5,a0
    800059aa:	02d00713          	li	a4,45
    800059ae:	fee78823          	sb	a4,-16(a5)
    800059b2:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    800059b6:	02a05c63          	blez	a0,800059ee <sprintint+0x94>
    800059ba:	fe040793          	addi	a5,s0,-32
    800059be:	00a78733          	add	a4,a5,a0
    800059c2:	87c2                	mv	a5,a6
    800059c4:	0805                	addi	a6,a6,1
    800059c6:	fff5061b          	addiw	a2,a0,-1
    800059ca:	1602                	slli	a2,a2,0x20
    800059cc:	9201                	srli	a2,a2,0x20
    800059ce:	9642                	add	a2,a2,a6
  *s = c;
    800059d0:	fff74683          	lbu	a3,-1(a4)
    800059d4:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    800059d8:	177d                	addi	a4,a4,-1
    800059da:	0785                	addi	a5,a5,1
    800059dc:	fec79ae3          	bne	a5,a2,800059d0 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    800059e0:	6462                	ld	s0,24(sp)
    800059e2:	6105                	addi	sp,sp,32
    800059e4:	8082                	ret
    x = -xx;
    800059e6:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    800059ea:	4305                	li	t1,1
    x = -xx;
    800059ec:	b741                	j	8000596c <sprintint+0x12>
  while(--i >= 0)
    800059ee:	4501                	li	a0,0
    800059f0:	bfc5                	j	800059e0 <sprintint+0x86>

00000000800059f2 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    800059f2:	7171                	addi	sp,sp,-176
    800059f4:	fc86                	sd	ra,120(sp)
    800059f6:	f8a2                	sd	s0,112(sp)
    800059f8:	f4a6                	sd	s1,104(sp)
    800059fa:	f0ca                	sd	s2,96(sp)
    800059fc:	ecce                	sd	s3,88(sp)
    800059fe:	e8d2                	sd	s4,80(sp)
    80005a00:	e4d6                	sd	s5,72(sp)
    80005a02:	e0da                	sd	s6,64(sp)
    80005a04:	fc5e                	sd	s7,56(sp)
    80005a06:	f862                	sd	s8,48(sp)
    80005a08:	f466                	sd	s9,40(sp)
    80005a0a:	f06a                	sd	s10,32(sp)
    80005a0c:	ec6e                	sd	s11,24(sp)
    80005a0e:	0100                	addi	s0,sp,128
    80005a10:	e414                	sd	a3,8(s0)
    80005a12:	e818                	sd	a4,16(s0)
    80005a14:	ec1c                	sd	a5,24(s0)
    80005a16:	03043023          	sd	a6,32(s0)
    80005a1a:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005a1e:	ca0d                	beqz	a2,80005a50 <snprintf+0x5e>
    80005a20:	8baa                	mv	s7,a0
    80005a22:	89ae                	mv	s3,a1
    80005a24:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005a26:	00840793          	addi	a5,s0,8
    80005a2a:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005a2e:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005a30:	4901                	li	s2,0
    80005a32:	02b05763          	blez	a1,80005a60 <snprintf+0x6e>
    if(c != '%'){
    80005a36:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005a3a:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005a3e:	02800d93          	li	s11,40
  *s = c;
    80005a42:	02500d13          	li	s10,37
    switch(c){
    80005a46:	07800c93          	li	s9,120
    80005a4a:	06400c13          	li	s8,100
    80005a4e:	a01d                	j	80005a74 <snprintf+0x82>
    panic("null fmt");
    80005a50:	00003517          	auipc	a0,0x3
    80005a54:	d5850513          	addi	a0,a0,-680 # 800087a8 <syscalls+0x3e0>
    80005a58:	00000097          	auipc	ra,0x0
    80005a5c:	634080e7          	jalr	1588(ra) # 8000608c <panic>
  int off = 0;
    80005a60:	4481                	li	s1,0
    80005a62:	a86d                	j	80005b1c <snprintf+0x12a>
  *s = c;
    80005a64:	009b8733          	add	a4,s7,s1
    80005a68:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005a6c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005a6e:	2905                	addiw	s2,s2,1
    80005a70:	0b34d663          	bge	s1,s3,80005b1c <snprintf+0x12a>
    80005a74:	012a07b3          	add	a5,s4,s2
    80005a78:	0007c783          	lbu	a5,0(a5)
    80005a7c:	0007871b          	sext.w	a4,a5
    80005a80:	cfd1                	beqz	a5,80005b1c <snprintf+0x12a>
    if(c != '%'){
    80005a82:	ff5711e3          	bne	a4,s5,80005a64 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005a86:	2905                	addiw	s2,s2,1
    80005a88:	012a07b3          	add	a5,s4,s2
    80005a8c:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005a90:	c7d1                	beqz	a5,80005b1c <snprintf+0x12a>
    switch(c){
    80005a92:	05678c63          	beq	a5,s6,80005aea <snprintf+0xf8>
    80005a96:	02fb6763          	bltu	s6,a5,80005ac4 <snprintf+0xd2>
    80005a9a:	0b578763          	beq	a5,s5,80005b48 <snprintf+0x156>
    80005a9e:	0b879b63          	bne	a5,s8,80005b54 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005aa2:	f8843783          	ld	a5,-120(s0)
    80005aa6:	00878713          	addi	a4,a5,8
    80005aaa:	f8e43423          	sd	a4,-120(s0)
    80005aae:	4685                	li	a3,1
    80005ab0:	4629                	li	a2,10
    80005ab2:	438c                	lw	a1,0(a5)
    80005ab4:	009b8533          	add	a0,s7,s1
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	ea2080e7          	jalr	-350(ra) # 8000595a <sprintint>
    80005ac0:	9ca9                	addw	s1,s1,a0
      break;
    80005ac2:	b775                	j	80005a6e <snprintf+0x7c>
    switch(c){
    80005ac4:	09979863          	bne	a5,s9,80005b54 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005ac8:	f8843783          	ld	a5,-120(s0)
    80005acc:	00878713          	addi	a4,a5,8
    80005ad0:	f8e43423          	sd	a4,-120(s0)
    80005ad4:	4685                	li	a3,1
    80005ad6:	4641                	li	a2,16
    80005ad8:	438c                	lw	a1,0(a5)
    80005ada:	009b8533          	add	a0,s7,s1
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	e7c080e7          	jalr	-388(ra) # 8000595a <sprintint>
    80005ae6:	9ca9                	addw	s1,s1,a0
      break;
    80005ae8:	b759                	j	80005a6e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005aea:	f8843783          	ld	a5,-120(s0)
    80005aee:	00878713          	addi	a4,a5,8
    80005af2:	f8e43423          	sd	a4,-120(s0)
    80005af6:	639c                	ld	a5,0(a5)
    80005af8:	c3b1                	beqz	a5,80005b3c <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005afa:	0007c703          	lbu	a4,0(a5)
    80005afe:	db25                	beqz	a4,80005a6e <snprintf+0x7c>
    80005b00:	0134de63          	bge	s1,s3,80005b1c <snprintf+0x12a>
    80005b04:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005b08:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005b0c:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005b0e:	0785                	addi	a5,a5,1
    80005b10:	0007c703          	lbu	a4,0(a5)
    80005b14:	df29                	beqz	a4,80005a6e <snprintf+0x7c>
    80005b16:	0685                	addi	a3,a3,1
    80005b18:	fe9998e3          	bne	s3,s1,80005b08 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005b1c:	8526                	mv	a0,s1
    80005b1e:	70e6                	ld	ra,120(sp)
    80005b20:	7446                	ld	s0,112(sp)
    80005b22:	74a6                	ld	s1,104(sp)
    80005b24:	7906                	ld	s2,96(sp)
    80005b26:	69e6                	ld	s3,88(sp)
    80005b28:	6a46                	ld	s4,80(sp)
    80005b2a:	6aa6                	ld	s5,72(sp)
    80005b2c:	6b06                	ld	s6,64(sp)
    80005b2e:	7be2                	ld	s7,56(sp)
    80005b30:	7c42                	ld	s8,48(sp)
    80005b32:	7ca2                	ld	s9,40(sp)
    80005b34:	7d02                	ld	s10,32(sp)
    80005b36:	6de2                	ld	s11,24(sp)
    80005b38:	614d                	addi	sp,sp,176
    80005b3a:	8082                	ret
        s = "(null)";
    80005b3c:	00003797          	auipc	a5,0x3
    80005b40:	c6478793          	addi	a5,a5,-924 # 800087a0 <syscalls+0x3d8>
      for(; *s && off < sz; s++)
    80005b44:	876e                	mv	a4,s11
    80005b46:	bf6d                	j	80005b00 <snprintf+0x10e>
  *s = c;
    80005b48:	009b87b3          	add	a5,s7,s1
    80005b4c:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005b50:	2485                	addiw	s1,s1,1
      break;
    80005b52:	bf31                	j	80005a6e <snprintf+0x7c>
  *s = c;
    80005b54:	009b8733          	add	a4,s7,s1
    80005b58:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005b5c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005b60:	975e                	add	a4,a4,s7
    80005b62:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b66:	2489                	addiw	s1,s1,2
      break;
    80005b68:	b719                	j	80005a6e <snprintf+0x7c>

0000000080005b6a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b6a:	1141                	addi	sp,sp,-16
    80005b6c:	e422                	sd	s0,8(sp)
    80005b6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b70:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b74:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b78:	0037979b          	slliw	a5,a5,0x3
    80005b7c:	02004737          	lui	a4,0x2004
    80005b80:	97ba                	add	a5,a5,a4
    80005b82:	0200c737          	lui	a4,0x200c
    80005b86:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005b8a:	000f4637          	lui	a2,0xf4
    80005b8e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b92:	95b2                	add	a1,a1,a2
    80005b94:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b96:	00269713          	slli	a4,a3,0x2
    80005b9a:	9736                	add	a4,a4,a3
    80005b9c:	00371693          	slli	a3,a4,0x3
    80005ba0:	0001c717          	auipc	a4,0x1c
    80005ba4:	49070713          	addi	a4,a4,1168 # 80022030 <timer_scratch>
    80005ba8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005baa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005bac:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005bae:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005bb2:	fffff797          	auipc	a5,0xfffff
    80005bb6:	63e78793          	addi	a5,a5,1598 # 800051f0 <timervec>
    80005bba:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bbe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005bc2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005bc6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005bca:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005bce:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005bd2:	30479073          	csrw	mie,a5
}
    80005bd6:	6422                	ld	s0,8(sp)
    80005bd8:	0141                	addi	sp,sp,16
    80005bda:	8082                	ret

0000000080005bdc <start>:
{
    80005bdc:	1141                	addi	sp,sp,-16
    80005bde:	e406                	sd	ra,8(sp)
    80005be0:	e022                	sd	s0,0(sp)
    80005be2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005be4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005be8:	7779                	lui	a4,0xffffe
    80005bea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005bee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005bf0:	6705                	lui	a4,0x1
    80005bf2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005bf6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005bf8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005bfc:	ffffb797          	auipc	a5,0xffffb
    80005c00:	87278793          	addi	a5,a5,-1934 # 8000046e <main>
    80005c04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c08:	4781                	li	a5,0
    80005c0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c0e:	67c1                	lui	a5,0x10
    80005c10:	17fd                	addi	a5,a5,-1
    80005c12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005c1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c26:	57fd                	li	a5,-1
    80005c28:	83a9                	srli	a5,a5,0xa
    80005c2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c2e:	47bd                	li	a5,15
    80005c30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	f36080e7          	jalr	-202(ra) # 80005b6a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c3c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c40:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c42:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c44:	30200073          	mret
}
    80005c48:	60a2                	ld	ra,8(sp)
    80005c4a:	6402                	ld	s0,0(sp)
    80005c4c:	0141                	addi	sp,sp,16
    80005c4e:	8082                	ret

0000000080005c50 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c50:	715d                	addi	sp,sp,-80
    80005c52:	e486                	sd	ra,72(sp)
    80005c54:	e0a2                	sd	s0,64(sp)
    80005c56:	fc26                	sd	s1,56(sp)
    80005c58:	f84a                	sd	s2,48(sp)
    80005c5a:	f44e                	sd	s3,40(sp)
    80005c5c:	f052                	sd	s4,32(sp)
    80005c5e:	ec56                	sd	s5,24(sp)
    80005c60:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c62:	04c05663          	blez	a2,80005cae <consolewrite+0x5e>
    80005c66:	8a2a                	mv	s4,a0
    80005c68:	84ae                	mv	s1,a1
    80005c6a:	89b2                	mv	s3,a2
    80005c6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c6e:	5afd                	li	s5,-1
    80005c70:	4685                	li	a3,1
    80005c72:	8626                	mv	a2,s1
    80005c74:	85d2                	mv	a1,s4
    80005c76:	fbf40513          	addi	a0,s0,-65
    80005c7a:	ffffc097          	auipc	ra,0xffffc
    80005c7e:	ddc080e7          	jalr	-548(ra) # 80001a56 <either_copyin>
    80005c82:	01550c63          	beq	a0,s5,80005c9a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005c86:	fbf44503          	lbu	a0,-65(s0)
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	78e080e7          	jalr	1934(ra) # 80006418 <uartputc>
  for(i = 0; i < n; i++){
    80005c92:	2905                	addiw	s2,s2,1
    80005c94:	0485                	addi	s1,s1,1
    80005c96:	fd299de3          	bne	s3,s2,80005c70 <consolewrite+0x20>
  }

  return i;
}
    80005c9a:	854a                	mv	a0,s2
    80005c9c:	60a6                	ld	ra,72(sp)
    80005c9e:	6406                	ld	s0,64(sp)
    80005ca0:	74e2                	ld	s1,56(sp)
    80005ca2:	7942                	ld	s2,48(sp)
    80005ca4:	79a2                	ld	s3,40(sp)
    80005ca6:	7a02                	ld	s4,32(sp)
    80005ca8:	6ae2                	ld	s5,24(sp)
    80005caa:	6161                	addi	sp,sp,80
    80005cac:	8082                	ret
  for(i = 0; i < n; i++){
    80005cae:	4901                	li	s2,0
    80005cb0:	b7ed                	j	80005c9a <consolewrite+0x4a>

0000000080005cb2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005cb2:	7119                	addi	sp,sp,-128
    80005cb4:	fc86                	sd	ra,120(sp)
    80005cb6:	f8a2                	sd	s0,112(sp)
    80005cb8:	f4a6                	sd	s1,104(sp)
    80005cba:	f0ca                	sd	s2,96(sp)
    80005cbc:	ecce                	sd	s3,88(sp)
    80005cbe:	e8d2                	sd	s4,80(sp)
    80005cc0:	e4d6                	sd	s5,72(sp)
    80005cc2:	e0da                	sd	s6,64(sp)
    80005cc4:	fc5e                	sd	s7,56(sp)
    80005cc6:	f862                	sd	s8,48(sp)
    80005cc8:	f466                	sd	s9,40(sp)
    80005cca:	f06a                	sd	s10,32(sp)
    80005ccc:	ec6e                	sd	s11,24(sp)
    80005cce:	0100                	addi	s0,sp,128
    80005cd0:	8b2a                	mv	s6,a0
    80005cd2:	8aae                	mv	s5,a1
    80005cd4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005cd6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005cda:	00024517          	auipc	a0,0x24
    80005cde:	49650513          	addi	a0,a0,1174 # 8002a170 <cons>
    80005ce2:	00001097          	auipc	ra,0x1
    80005ce6:	8de080e7          	jalr	-1826(ra) # 800065c0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005cea:	00024497          	auipc	s1,0x24
    80005cee:	48648493          	addi	s1,s1,1158 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005cf2:	89a6                	mv	s3,s1
    80005cf4:	00024917          	auipc	s2,0x24
    80005cf8:	51c90913          	addi	s2,s2,1308 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005cfc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cfe:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d00:	4da9                	li	s11,10
  while(n > 0){
    80005d02:	07405863          	blez	s4,80005d72 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005d06:	0a04a783          	lw	a5,160(s1)
    80005d0a:	0a44a703          	lw	a4,164(s1)
    80005d0e:	02f71463          	bne	a4,a5,80005d36 <consoleread+0x84>
      if(myproc()->killed){
    80005d12:	ffffb097          	auipc	ra,0xffffb
    80005d16:	28e080e7          	jalr	654(ra) # 80000fa0 <myproc>
    80005d1a:	591c                	lw	a5,48(a0)
    80005d1c:	e7b5                	bnez	a5,80005d88 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005d1e:	85ce                	mv	a1,s3
    80005d20:	854a                	mv	a0,s2
    80005d22:	ffffc097          	auipc	ra,0xffffc
    80005d26:	93a080e7          	jalr	-1734(ra) # 8000165c <sleep>
    while(cons.r == cons.w){
    80005d2a:	0a04a783          	lw	a5,160(s1)
    80005d2e:	0a44a703          	lw	a4,164(s1)
    80005d32:	fef700e3          	beq	a4,a5,80005d12 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005d36:	0017871b          	addiw	a4,a5,1
    80005d3a:	0ae4a023          	sw	a4,160(s1)
    80005d3e:	07f7f713          	andi	a4,a5,127
    80005d42:	9726                	add	a4,a4,s1
    80005d44:	02074703          	lbu	a4,32(a4)
    80005d48:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005d4c:	079c0663          	beq	s8,s9,80005db8 <consoleread+0x106>
    cbuf = c;
    80005d50:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d54:	4685                	li	a3,1
    80005d56:	f8f40613          	addi	a2,s0,-113
    80005d5a:	85d6                	mv	a1,s5
    80005d5c:	855a                	mv	a0,s6
    80005d5e:	ffffc097          	auipc	ra,0xffffc
    80005d62:	ca2080e7          	jalr	-862(ra) # 80001a00 <either_copyout>
    80005d66:	01a50663          	beq	a0,s10,80005d72 <consoleread+0xc0>
    dst++;
    80005d6a:	0a85                	addi	s5,s5,1
    --n;
    80005d6c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005d6e:	f9bc1ae3          	bne	s8,s11,80005d02 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005d72:	00024517          	auipc	a0,0x24
    80005d76:	3fe50513          	addi	a0,a0,1022 # 8002a170 <cons>
    80005d7a:	00001097          	auipc	ra,0x1
    80005d7e:	916080e7          	jalr	-1770(ra) # 80006690 <release>

  return target - n;
    80005d82:	414b853b          	subw	a0,s7,s4
    80005d86:	a811                	j	80005d9a <consoleread+0xe8>
        release(&cons.lock);
    80005d88:	00024517          	auipc	a0,0x24
    80005d8c:	3e850513          	addi	a0,a0,1000 # 8002a170 <cons>
    80005d90:	00001097          	auipc	ra,0x1
    80005d94:	900080e7          	jalr	-1792(ra) # 80006690 <release>
        return -1;
    80005d98:	557d                	li	a0,-1
}
    80005d9a:	70e6                	ld	ra,120(sp)
    80005d9c:	7446                	ld	s0,112(sp)
    80005d9e:	74a6                	ld	s1,104(sp)
    80005da0:	7906                	ld	s2,96(sp)
    80005da2:	69e6                	ld	s3,88(sp)
    80005da4:	6a46                	ld	s4,80(sp)
    80005da6:	6aa6                	ld	s5,72(sp)
    80005da8:	6b06                	ld	s6,64(sp)
    80005daa:	7be2                	ld	s7,56(sp)
    80005dac:	7c42                	ld	s8,48(sp)
    80005dae:	7ca2                	ld	s9,40(sp)
    80005db0:	7d02                	ld	s10,32(sp)
    80005db2:	6de2                	ld	s11,24(sp)
    80005db4:	6109                	addi	sp,sp,128
    80005db6:	8082                	ret
      if(n < target){
    80005db8:	000a071b          	sext.w	a4,s4
    80005dbc:	fb777be3          	bgeu	a4,s7,80005d72 <consoleread+0xc0>
        cons.r--;
    80005dc0:	00024717          	auipc	a4,0x24
    80005dc4:	44f72823          	sw	a5,1104(a4) # 8002a210 <cons+0xa0>
    80005dc8:	b76d                	j	80005d72 <consoleread+0xc0>

0000000080005dca <consputc>:
{
    80005dca:	1141                	addi	sp,sp,-16
    80005dcc:	e406                	sd	ra,8(sp)
    80005dce:	e022                	sd	s0,0(sp)
    80005dd0:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005dd2:	10000793          	li	a5,256
    80005dd6:	00f50a63          	beq	a0,a5,80005dea <consputc+0x20>
    uartputc_sync(c);
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	564080e7          	jalr	1380(ra) # 8000633e <uartputc_sync>
}
    80005de2:	60a2                	ld	ra,8(sp)
    80005de4:	6402                	ld	s0,0(sp)
    80005de6:	0141                	addi	sp,sp,16
    80005de8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005dea:	4521                	li	a0,8
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	552080e7          	jalr	1362(ra) # 8000633e <uartputc_sync>
    80005df4:	02000513          	li	a0,32
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	546080e7          	jalr	1350(ra) # 8000633e <uartputc_sync>
    80005e00:	4521                	li	a0,8
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	53c080e7          	jalr	1340(ra) # 8000633e <uartputc_sync>
    80005e0a:	bfe1                	j	80005de2 <consputc+0x18>

0000000080005e0c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e0c:	1101                	addi	sp,sp,-32
    80005e0e:	ec06                	sd	ra,24(sp)
    80005e10:	e822                	sd	s0,16(sp)
    80005e12:	e426                	sd	s1,8(sp)
    80005e14:	e04a                	sd	s2,0(sp)
    80005e16:	1000                	addi	s0,sp,32
    80005e18:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e1a:	00024517          	auipc	a0,0x24
    80005e1e:	35650513          	addi	a0,a0,854 # 8002a170 <cons>
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	79e080e7          	jalr	1950(ra) # 800065c0 <acquire>

  switch(c){
    80005e2a:	47d5                	li	a5,21
    80005e2c:	0af48663          	beq	s1,a5,80005ed8 <consoleintr+0xcc>
    80005e30:	0297ca63          	blt	a5,s1,80005e64 <consoleintr+0x58>
    80005e34:	47a1                	li	a5,8
    80005e36:	0ef48763          	beq	s1,a5,80005f24 <consoleintr+0x118>
    80005e3a:	47c1                	li	a5,16
    80005e3c:	10f49a63          	bne	s1,a5,80005f50 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005e40:	ffffc097          	auipc	ra,0xffffc
    80005e44:	c6c080e7          	jalr	-916(ra) # 80001aac <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e48:	00024517          	auipc	a0,0x24
    80005e4c:	32850513          	addi	a0,a0,808 # 8002a170 <cons>
    80005e50:	00001097          	auipc	ra,0x1
    80005e54:	840080e7          	jalr	-1984(ra) # 80006690 <release>
}
    80005e58:	60e2                	ld	ra,24(sp)
    80005e5a:	6442                	ld	s0,16(sp)
    80005e5c:	64a2                	ld	s1,8(sp)
    80005e5e:	6902                	ld	s2,0(sp)
    80005e60:	6105                	addi	sp,sp,32
    80005e62:	8082                	ret
  switch(c){
    80005e64:	07f00793          	li	a5,127
    80005e68:	0af48e63          	beq	s1,a5,80005f24 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e6c:	00024717          	auipc	a4,0x24
    80005e70:	30470713          	addi	a4,a4,772 # 8002a170 <cons>
    80005e74:	0a872783          	lw	a5,168(a4)
    80005e78:	0a072703          	lw	a4,160(a4)
    80005e7c:	9f99                	subw	a5,a5,a4
    80005e7e:	07f00713          	li	a4,127
    80005e82:	fcf763e3          	bltu	a4,a5,80005e48 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005e86:	47b5                	li	a5,13
    80005e88:	0cf48763          	beq	s1,a5,80005f56 <consoleintr+0x14a>
      consputc(c);
    80005e8c:	8526                	mv	a0,s1
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	f3c080e7          	jalr	-196(ra) # 80005dca <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e96:	00024797          	auipc	a5,0x24
    80005e9a:	2da78793          	addi	a5,a5,730 # 8002a170 <cons>
    80005e9e:	0a87a703          	lw	a4,168(a5)
    80005ea2:	0017069b          	addiw	a3,a4,1
    80005ea6:	0006861b          	sext.w	a2,a3
    80005eaa:	0ad7a423          	sw	a3,168(a5)
    80005eae:	07f77713          	andi	a4,a4,127
    80005eb2:	97ba                	add	a5,a5,a4
    80005eb4:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005eb8:	47a9                	li	a5,10
    80005eba:	0cf48563          	beq	s1,a5,80005f84 <consoleintr+0x178>
    80005ebe:	4791                	li	a5,4
    80005ec0:	0cf48263          	beq	s1,a5,80005f84 <consoleintr+0x178>
    80005ec4:	00024797          	auipc	a5,0x24
    80005ec8:	34c7a783          	lw	a5,844(a5) # 8002a210 <cons+0xa0>
    80005ecc:	0807879b          	addiw	a5,a5,128
    80005ed0:	f6f61ce3          	bne	a2,a5,80005e48 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ed4:	863e                	mv	a2,a5
    80005ed6:	a07d                	j	80005f84 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ed8:	00024717          	auipc	a4,0x24
    80005edc:	29870713          	addi	a4,a4,664 # 8002a170 <cons>
    80005ee0:	0a872783          	lw	a5,168(a4)
    80005ee4:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ee8:	00024497          	auipc	s1,0x24
    80005eec:	28848493          	addi	s1,s1,648 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80005ef0:	4929                	li	s2,10
    80005ef2:	f4f70be3          	beq	a4,a5,80005e48 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ef6:	37fd                	addiw	a5,a5,-1
    80005ef8:	07f7f713          	andi	a4,a5,127
    80005efc:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005efe:	02074703          	lbu	a4,32(a4)
    80005f02:	f52703e3          	beq	a4,s2,80005e48 <consoleintr+0x3c>
      cons.e--;
    80005f06:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005f0a:	10000513          	li	a0,256
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	ebc080e7          	jalr	-324(ra) # 80005dca <consputc>
    while(cons.e != cons.w &&
    80005f16:	0a84a783          	lw	a5,168(s1)
    80005f1a:	0a44a703          	lw	a4,164(s1)
    80005f1e:	fcf71ce3          	bne	a4,a5,80005ef6 <consoleintr+0xea>
    80005f22:	b71d                	j	80005e48 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005f24:	00024717          	auipc	a4,0x24
    80005f28:	24c70713          	addi	a4,a4,588 # 8002a170 <cons>
    80005f2c:	0a872783          	lw	a5,168(a4)
    80005f30:	0a472703          	lw	a4,164(a4)
    80005f34:	f0f70ae3          	beq	a4,a5,80005e48 <consoleintr+0x3c>
      cons.e--;
    80005f38:	37fd                	addiw	a5,a5,-1
    80005f3a:	00024717          	auipc	a4,0x24
    80005f3e:	2cf72f23          	sw	a5,734(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80005f42:	10000513          	li	a0,256
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	e84080e7          	jalr	-380(ra) # 80005dca <consputc>
    80005f4e:	bded                	j	80005e48 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f50:	ee048ce3          	beqz	s1,80005e48 <consoleintr+0x3c>
    80005f54:	bf21                	j	80005e6c <consoleintr+0x60>
      consputc(c);
    80005f56:	4529                	li	a0,10
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	e72080e7          	jalr	-398(ra) # 80005dca <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f60:	00024797          	auipc	a5,0x24
    80005f64:	21078793          	addi	a5,a5,528 # 8002a170 <cons>
    80005f68:	0a87a703          	lw	a4,168(a5)
    80005f6c:	0017069b          	addiw	a3,a4,1
    80005f70:	0006861b          	sext.w	a2,a3
    80005f74:	0ad7a423          	sw	a3,168(a5)
    80005f78:	07f77713          	andi	a4,a4,127
    80005f7c:	97ba                	add	a5,a5,a4
    80005f7e:	4729                	li	a4,10
    80005f80:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80005f84:	00024797          	auipc	a5,0x24
    80005f88:	28c7a823          	sw	a2,656(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80005f8c:	00024517          	auipc	a0,0x24
    80005f90:	28450513          	addi	a0,a0,644 # 8002a210 <cons+0xa0>
    80005f94:	ffffc097          	auipc	ra,0xffffc
    80005f98:	854080e7          	jalr	-1964(ra) # 800017e8 <wakeup>
    80005f9c:	b575                	j	80005e48 <consoleintr+0x3c>

0000000080005f9e <consoleinit>:

void
consoleinit(void)
{
    80005f9e:	1141                	addi	sp,sp,-16
    80005fa0:	e406                	sd	ra,8(sp)
    80005fa2:	e022                	sd	s0,0(sp)
    80005fa4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005fa6:	00003597          	auipc	a1,0x3
    80005faa:	82a58593          	addi	a1,a1,-2006 # 800087d0 <digits+0x18>
    80005fae:	00024517          	auipc	a0,0x24
    80005fb2:	1c250513          	addi	a0,a0,450 # 8002a170 <cons>
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	786080e7          	jalr	1926(ra) # 8000673c <initlock>

  uartinit();
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	330080e7          	jalr	816(ra) # 800062ee <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fc6:	00017797          	auipc	a5,0x17
    80005fca:	e7278793          	addi	a5,a5,-398 # 8001ce38 <devsw>
    80005fce:	00000717          	auipc	a4,0x0
    80005fd2:	ce470713          	addi	a4,a4,-796 # 80005cb2 <consoleread>
    80005fd6:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fd8:	00000717          	auipc	a4,0x0
    80005fdc:	c7870713          	addi	a4,a4,-904 # 80005c50 <consolewrite>
    80005fe0:	ef98                	sd	a4,24(a5)
}
    80005fe2:	60a2                	ld	ra,8(sp)
    80005fe4:	6402                	ld	s0,0(sp)
    80005fe6:	0141                	addi	sp,sp,16
    80005fe8:	8082                	ret

0000000080005fea <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005fea:	7179                	addi	sp,sp,-48
    80005fec:	f406                	sd	ra,40(sp)
    80005fee:	f022                	sd	s0,32(sp)
    80005ff0:	ec26                	sd	s1,24(sp)
    80005ff2:	e84a                	sd	s2,16(sp)
    80005ff4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ff6:	c219                	beqz	a2,80005ffc <printint+0x12>
    80005ff8:	08054663          	bltz	a0,80006084 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ffc:	2501                	sext.w	a0,a0
    80005ffe:	4881                	li	a7,0
    80006000:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006004:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006006:	2581                	sext.w	a1,a1
    80006008:	00002617          	auipc	a2,0x2
    8000600c:	7e060613          	addi	a2,a2,2016 # 800087e8 <digits>
    80006010:	883a                	mv	a6,a4
    80006012:	2705                	addiw	a4,a4,1
    80006014:	02b577bb          	remuw	a5,a0,a1
    80006018:	1782                	slli	a5,a5,0x20
    8000601a:	9381                	srli	a5,a5,0x20
    8000601c:	97b2                	add	a5,a5,a2
    8000601e:	0007c783          	lbu	a5,0(a5)
    80006022:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006026:	0005079b          	sext.w	a5,a0
    8000602a:	02b5553b          	divuw	a0,a0,a1
    8000602e:	0685                	addi	a3,a3,1
    80006030:	feb7f0e3          	bgeu	a5,a1,80006010 <printint+0x26>

  if(sign)
    80006034:	00088b63          	beqz	a7,8000604a <printint+0x60>
    buf[i++] = '-';
    80006038:	fe040793          	addi	a5,s0,-32
    8000603c:	973e                	add	a4,a4,a5
    8000603e:	02d00793          	li	a5,45
    80006042:	fef70823          	sb	a5,-16(a4)
    80006046:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000604a:	02e05763          	blez	a4,80006078 <printint+0x8e>
    8000604e:	fd040793          	addi	a5,s0,-48
    80006052:	00e784b3          	add	s1,a5,a4
    80006056:	fff78913          	addi	s2,a5,-1
    8000605a:	993a                	add	s2,s2,a4
    8000605c:	377d                	addiw	a4,a4,-1
    8000605e:	1702                	slli	a4,a4,0x20
    80006060:	9301                	srli	a4,a4,0x20
    80006062:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006066:	fff4c503          	lbu	a0,-1(s1)
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	d60080e7          	jalr	-672(ra) # 80005dca <consputc>
  while(--i >= 0)
    80006072:	14fd                	addi	s1,s1,-1
    80006074:	ff2499e3          	bne	s1,s2,80006066 <printint+0x7c>
}
    80006078:	70a2                	ld	ra,40(sp)
    8000607a:	7402                	ld	s0,32(sp)
    8000607c:	64e2                	ld	s1,24(sp)
    8000607e:	6942                	ld	s2,16(sp)
    80006080:	6145                	addi	sp,sp,48
    80006082:	8082                	ret
    x = -xx;
    80006084:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006088:	4885                	li	a7,1
    x = -xx;
    8000608a:	bf9d                	j	80006000 <printint+0x16>

000000008000608c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000608c:	1101                	addi	sp,sp,-32
    8000608e:	ec06                	sd	ra,24(sp)
    80006090:	e822                	sd	s0,16(sp)
    80006092:	e426                	sd	s1,8(sp)
    80006094:	1000                	addi	s0,sp,32
    80006096:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006098:	00024797          	auipc	a5,0x24
    8000609c:	1a07a423          	sw	zero,424(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    800060a0:	00002517          	auipc	a0,0x2
    800060a4:	73850513          	addi	a0,a0,1848 # 800087d8 <digits+0x20>
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	02e080e7          	jalr	46(ra) # 800060d6 <printf>
  printf(s);
    800060b0:	8526                	mv	a0,s1
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	024080e7          	jalr	36(ra) # 800060d6 <printf>
  printf("\n");
    800060ba:	00002517          	auipc	a0,0x2
    800060be:	7b650513          	addi	a0,a0,1974 # 80008870 <digits+0x88>
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	014080e7          	jalr	20(ra) # 800060d6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800060ca:	4785                	li	a5,1
    800060cc:	00003717          	auipc	a4,0x3
    800060d0:	f4f72823          	sw	a5,-176(a4) # 8000901c <panicked>
  for(;;)
    800060d4:	a001                	j	800060d4 <panic+0x48>

00000000800060d6 <printf>:
{
    800060d6:	7131                	addi	sp,sp,-192
    800060d8:	fc86                	sd	ra,120(sp)
    800060da:	f8a2                	sd	s0,112(sp)
    800060dc:	f4a6                	sd	s1,104(sp)
    800060de:	f0ca                	sd	s2,96(sp)
    800060e0:	ecce                	sd	s3,88(sp)
    800060e2:	e8d2                	sd	s4,80(sp)
    800060e4:	e4d6                	sd	s5,72(sp)
    800060e6:	e0da                	sd	s6,64(sp)
    800060e8:	fc5e                	sd	s7,56(sp)
    800060ea:	f862                	sd	s8,48(sp)
    800060ec:	f466                	sd	s9,40(sp)
    800060ee:	f06a                	sd	s10,32(sp)
    800060f0:	ec6e                	sd	s11,24(sp)
    800060f2:	0100                	addi	s0,sp,128
    800060f4:	8a2a                	mv	s4,a0
    800060f6:	e40c                	sd	a1,8(s0)
    800060f8:	e810                	sd	a2,16(s0)
    800060fa:	ec14                	sd	a3,24(s0)
    800060fc:	f018                	sd	a4,32(s0)
    800060fe:	f41c                	sd	a5,40(s0)
    80006100:	03043823          	sd	a6,48(s0)
    80006104:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006108:	00024d97          	auipc	s11,0x24
    8000610c:	138dad83          	lw	s11,312(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006110:	020d9b63          	bnez	s11,80006146 <printf+0x70>
  if (fmt == 0)
    80006114:	040a0263          	beqz	s4,80006158 <printf+0x82>
  va_start(ap, fmt);
    80006118:	00840793          	addi	a5,s0,8
    8000611c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006120:	000a4503          	lbu	a0,0(s4)
    80006124:	16050263          	beqz	a0,80006288 <printf+0x1b2>
    80006128:	4481                	li	s1,0
    if(c != '%'){
    8000612a:	02500a93          	li	s5,37
    switch(c){
    8000612e:	07000b13          	li	s6,112
  consputc('x');
    80006132:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006134:	00002b97          	auipc	s7,0x2
    80006138:	6b4b8b93          	addi	s7,s7,1716 # 800087e8 <digits>
    switch(c){
    8000613c:	07300c93          	li	s9,115
    80006140:	06400c13          	li	s8,100
    80006144:	a82d                	j	8000617e <printf+0xa8>
    acquire(&pr.lock);
    80006146:	00024517          	auipc	a0,0x24
    8000614a:	0da50513          	addi	a0,a0,218 # 8002a220 <pr>
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	472080e7          	jalr	1138(ra) # 800065c0 <acquire>
    80006156:	bf7d                	j	80006114 <printf+0x3e>
    panic("null fmt");
    80006158:	00002517          	auipc	a0,0x2
    8000615c:	65050513          	addi	a0,a0,1616 # 800087a8 <syscalls+0x3e0>
    80006160:	00000097          	auipc	ra,0x0
    80006164:	f2c080e7          	jalr	-212(ra) # 8000608c <panic>
      consputc(c);
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	c62080e7          	jalr	-926(ra) # 80005dca <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006170:	2485                	addiw	s1,s1,1
    80006172:	009a07b3          	add	a5,s4,s1
    80006176:	0007c503          	lbu	a0,0(a5)
    8000617a:	10050763          	beqz	a0,80006288 <printf+0x1b2>
    if(c != '%'){
    8000617e:	ff5515e3          	bne	a0,s5,80006168 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006182:	2485                	addiw	s1,s1,1
    80006184:	009a07b3          	add	a5,s4,s1
    80006188:	0007c783          	lbu	a5,0(a5)
    8000618c:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006190:	cfe5                	beqz	a5,80006288 <printf+0x1b2>
    switch(c){
    80006192:	05678a63          	beq	a5,s6,800061e6 <printf+0x110>
    80006196:	02fb7663          	bgeu	s6,a5,800061c2 <printf+0xec>
    8000619a:	09978963          	beq	a5,s9,8000622c <printf+0x156>
    8000619e:	07800713          	li	a4,120
    800061a2:	0ce79863          	bne	a5,a4,80006272 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800061a6:	f8843783          	ld	a5,-120(s0)
    800061aa:	00878713          	addi	a4,a5,8
    800061ae:	f8e43423          	sd	a4,-120(s0)
    800061b2:	4605                	li	a2,1
    800061b4:	85ea                	mv	a1,s10
    800061b6:	4388                	lw	a0,0(a5)
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	e32080e7          	jalr	-462(ra) # 80005fea <printint>
      break;
    800061c0:	bf45                	j	80006170 <printf+0x9a>
    switch(c){
    800061c2:	0b578263          	beq	a5,s5,80006266 <printf+0x190>
    800061c6:	0b879663          	bne	a5,s8,80006272 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800061ca:	f8843783          	ld	a5,-120(s0)
    800061ce:	00878713          	addi	a4,a5,8
    800061d2:	f8e43423          	sd	a4,-120(s0)
    800061d6:	4605                	li	a2,1
    800061d8:	45a9                	li	a1,10
    800061da:	4388                	lw	a0,0(a5)
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	e0e080e7          	jalr	-498(ra) # 80005fea <printint>
      break;
    800061e4:	b771                	j	80006170 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800061e6:	f8843783          	ld	a5,-120(s0)
    800061ea:	00878713          	addi	a4,a5,8
    800061ee:	f8e43423          	sd	a4,-120(s0)
    800061f2:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800061f6:	03000513          	li	a0,48
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	bd0080e7          	jalr	-1072(ra) # 80005dca <consputc>
  consputc('x');
    80006202:	07800513          	li	a0,120
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	bc4080e7          	jalr	-1084(ra) # 80005dca <consputc>
    8000620e:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006210:	03c9d793          	srli	a5,s3,0x3c
    80006214:	97de                	add	a5,a5,s7
    80006216:	0007c503          	lbu	a0,0(a5)
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	bb0080e7          	jalr	-1104(ra) # 80005dca <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006222:	0992                	slli	s3,s3,0x4
    80006224:	397d                	addiw	s2,s2,-1
    80006226:	fe0915e3          	bnez	s2,80006210 <printf+0x13a>
    8000622a:	b799                	j	80006170 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000622c:	f8843783          	ld	a5,-120(s0)
    80006230:	00878713          	addi	a4,a5,8
    80006234:	f8e43423          	sd	a4,-120(s0)
    80006238:	0007b903          	ld	s2,0(a5)
    8000623c:	00090e63          	beqz	s2,80006258 <printf+0x182>
      for(; *s; s++)
    80006240:	00094503          	lbu	a0,0(s2)
    80006244:	d515                	beqz	a0,80006170 <printf+0x9a>
        consputc(*s);
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	b84080e7          	jalr	-1148(ra) # 80005dca <consputc>
      for(; *s; s++)
    8000624e:	0905                	addi	s2,s2,1
    80006250:	00094503          	lbu	a0,0(s2)
    80006254:	f96d                	bnez	a0,80006246 <printf+0x170>
    80006256:	bf29                	j	80006170 <printf+0x9a>
        s = "(null)";
    80006258:	00002917          	auipc	s2,0x2
    8000625c:	54890913          	addi	s2,s2,1352 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80006260:	02800513          	li	a0,40
    80006264:	b7cd                	j	80006246 <printf+0x170>
      consputc('%');
    80006266:	8556                	mv	a0,s5
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	b62080e7          	jalr	-1182(ra) # 80005dca <consputc>
      break;
    80006270:	b701                	j	80006170 <printf+0x9a>
      consputc('%');
    80006272:	8556                	mv	a0,s5
    80006274:	00000097          	auipc	ra,0x0
    80006278:	b56080e7          	jalr	-1194(ra) # 80005dca <consputc>
      consputc(c);
    8000627c:	854a                	mv	a0,s2
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	b4c080e7          	jalr	-1204(ra) # 80005dca <consputc>
      break;
    80006286:	b5ed                	j	80006170 <printf+0x9a>
  if(locking)
    80006288:	020d9163          	bnez	s11,800062aa <printf+0x1d4>
}
    8000628c:	70e6                	ld	ra,120(sp)
    8000628e:	7446                	ld	s0,112(sp)
    80006290:	74a6                	ld	s1,104(sp)
    80006292:	7906                	ld	s2,96(sp)
    80006294:	69e6                	ld	s3,88(sp)
    80006296:	6a46                	ld	s4,80(sp)
    80006298:	6aa6                	ld	s5,72(sp)
    8000629a:	6b06                	ld	s6,64(sp)
    8000629c:	7be2                	ld	s7,56(sp)
    8000629e:	7c42                	ld	s8,48(sp)
    800062a0:	7ca2                	ld	s9,40(sp)
    800062a2:	7d02                	ld	s10,32(sp)
    800062a4:	6de2                	ld	s11,24(sp)
    800062a6:	6129                	addi	sp,sp,192
    800062a8:	8082                	ret
    release(&pr.lock);
    800062aa:	00024517          	auipc	a0,0x24
    800062ae:	f7650513          	addi	a0,a0,-138 # 8002a220 <pr>
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	3de080e7          	jalr	990(ra) # 80006690 <release>
}
    800062ba:	bfc9                	j	8000628c <printf+0x1b6>

00000000800062bc <printfinit>:
    ;
}

void
printfinit(void)
{
    800062bc:	1101                	addi	sp,sp,-32
    800062be:	ec06                	sd	ra,24(sp)
    800062c0:	e822                	sd	s0,16(sp)
    800062c2:	e426                	sd	s1,8(sp)
    800062c4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062c6:	00024497          	auipc	s1,0x24
    800062ca:	f5a48493          	addi	s1,s1,-166 # 8002a220 <pr>
    800062ce:	00002597          	auipc	a1,0x2
    800062d2:	51258593          	addi	a1,a1,1298 # 800087e0 <digits+0x28>
    800062d6:	8526                	mv	a0,s1
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	464080e7          	jalr	1124(ra) # 8000673c <initlock>
  pr.locking = 1;
    800062e0:	4785                	li	a5,1
    800062e2:	d09c                	sw	a5,32(s1)
}
    800062e4:	60e2                	ld	ra,24(sp)
    800062e6:	6442                	ld	s0,16(sp)
    800062e8:	64a2                	ld	s1,8(sp)
    800062ea:	6105                	addi	sp,sp,32
    800062ec:	8082                	ret

00000000800062ee <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062ee:	1141                	addi	sp,sp,-16
    800062f0:	e406                	sd	ra,8(sp)
    800062f2:	e022                	sd	s0,0(sp)
    800062f4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062f6:	100007b7          	lui	a5,0x10000
    800062fa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062fe:	f8000713          	li	a4,-128
    80006302:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006306:	470d                	li	a4,3
    80006308:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000630c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006310:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006314:	469d                	li	a3,7
    80006316:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000631a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000631e:	00002597          	auipc	a1,0x2
    80006322:	4e258593          	addi	a1,a1,1250 # 80008800 <digits+0x18>
    80006326:	00024517          	auipc	a0,0x24
    8000632a:	f2250513          	addi	a0,a0,-222 # 8002a248 <uart_tx_lock>
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	40e080e7          	jalr	1038(ra) # 8000673c <initlock>
}
    80006336:	60a2                	ld	ra,8(sp)
    80006338:	6402                	ld	s0,0(sp)
    8000633a:	0141                	addi	sp,sp,16
    8000633c:	8082                	ret

000000008000633e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000633e:	1101                	addi	sp,sp,-32
    80006340:	ec06                	sd	ra,24(sp)
    80006342:	e822                	sd	s0,16(sp)
    80006344:	e426                	sd	s1,8(sp)
    80006346:	1000                	addi	s0,sp,32
    80006348:	84aa                	mv	s1,a0
  push_off();
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	22a080e7          	jalr	554(ra) # 80006574 <push_off>

  if(panicked){
    80006352:	00003797          	auipc	a5,0x3
    80006356:	cca7a783          	lw	a5,-822(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000635a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000635e:	c391                	beqz	a5,80006362 <uartputc_sync+0x24>
    for(;;)
    80006360:	a001                	j	80006360 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006362:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006366:	0ff7f793          	andi	a5,a5,255
    8000636a:	0207f793          	andi	a5,a5,32
    8000636e:	dbf5                	beqz	a5,80006362 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006370:	0ff4f793          	andi	a5,s1,255
    80006374:	10000737          	lui	a4,0x10000
    80006378:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	2b4080e7          	jalr	692(ra) # 80006630 <pop_off>
}
    80006384:	60e2                	ld	ra,24(sp)
    80006386:	6442                	ld	s0,16(sp)
    80006388:	64a2                	ld	s1,8(sp)
    8000638a:	6105                	addi	sp,sp,32
    8000638c:	8082                	ret

000000008000638e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000638e:	00003717          	auipc	a4,0x3
    80006392:	c9273703          	ld	a4,-878(a4) # 80009020 <uart_tx_r>
    80006396:	00003797          	auipc	a5,0x3
    8000639a:	c927b783          	ld	a5,-878(a5) # 80009028 <uart_tx_w>
    8000639e:	06e78c63          	beq	a5,a4,80006416 <uartstart+0x88>
{
    800063a2:	7139                	addi	sp,sp,-64
    800063a4:	fc06                	sd	ra,56(sp)
    800063a6:	f822                	sd	s0,48(sp)
    800063a8:	f426                	sd	s1,40(sp)
    800063aa:	f04a                	sd	s2,32(sp)
    800063ac:	ec4e                	sd	s3,24(sp)
    800063ae:	e852                	sd	s4,16(sp)
    800063b0:	e456                	sd	s5,8(sp)
    800063b2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063b4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063b8:	00024a17          	auipc	s4,0x24
    800063bc:	e90a0a13          	addi	s4,s4,-368 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    800063c0:	00003497          	auipc	s1,0x3
    800063c4:	c6048493          	addi	s1,s1,-928 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800063c8:	00003997          	auipc	s3,0x3
    800063cc:	c6098993          	addi	s3,s3,-928 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063d0:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800063d4:	0ff7f793          	andi	a5,a5,255
    800063d8:	0207f793          	andi	a5,a5,32
    800063dc:	c785                	beqz	a5,80006404 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063de:	01f77793          	andi	a5,a4,31
    800063e2:	97d2                	add	a5,a5,s4
    800063e4:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    800063e8:	0705                	addi	a4,a4,1
    800063ea:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800063ec:	8526                	mv	a0,s1
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	3fa080e7          	jalr	1018(ra) # 800017e8 <wakeup>
    
    WriteReg(THR, c);
    800063f6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800063fa:	6098                	ld	a4,0(s1)
    800063fc:	0009b783          	ld	a5,0(s3)
    80006400:	fce798e3          	bne	a5,a4,800063d0 <uartstart+0x42>
  }
}
    80006404:	70e2                	ld	ra,56(sp)
    80006406:	7442                	ld	s0,48(sp)
    80006408:	74a2                	ld	s1,40(sp)
    8000640a:	7902                	ld	s2,32(sp)
    8000640c:	69e2                	ld	s3,24(sp)
    8000640e:	6a42                	ld	s4,16(sp)
    80006410:	6aa2                	ld	s5,8(sp)
    80006412:	6121                	addi	sp,sp,64
    80006414:	8082                	ret
    80006416:	8082                	ret

0000000080006418 <uartputc>:
{
    80006418:	7179                	addi	sp,sp,-48
    8000641a:	f406                	sd	ra,40(sp)
    8000641c:	f022                	sd	s0,32(sp)
    8000641e:	ec26                	sd	s1,24(sp)
    80006420:	e84a                	sd	s2,16(sp)
    80006422:	e44e                	sd	s3,8(sp)
    80006424:	e052                	sd	s4,0(sp)
    80006426:	1800                	addi	s0,sp,48
    80006428:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000642a:	00024517          	auipc	a0,0x24
    8000642e:	e1e50513          	addi	a0,a0,-482 # 8002a248 <uart_tx_lock>
    80006432:	00000097          	auipc	ra,0x0
    80006436:	18e080e7          	jalr	398(ra) # 800065c0 <acquire>
  if(panicked){
    8000643a:	00003797          	auipc	a5,0x3
    8000643e:	be27a783          	lw	a5,-1054(a5) # 8000901c <panicked>
    80006442:	c391                	beqz	a5,80006446 <uartputc+0x2e>
    for(;;)
    80006444:	a001                	j	80006444 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006446:	00003797          	auipc	a5,0x3
    8000644a:	be27b783          	ld	a5,-1054(a5) # 80009028 <uart_tx_w>
    8000644e:	00003717          	auipc	a4,0x3
    80006452:	bd273703          	ld	a4,-1070(a4) # 80009020 <uart_tx_r>
    80006456:	02070713          	addi	a4,a4,32
    8000645a:	02f71b63          	bne	a4,a5,80006490 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000645e:	00024a17          	auipc	s4,0x24
    80006462:	deaa0a13          	addi	s4,s4,-534 # 8002a248 <uart_tx_lock>
    80006466:	00003497          	auipc	s1,0x3
    8000646a:	bba48493          	addi	s1,s1,-1094 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000646e:	00003917          	auipc	s2,0x3
    80006472:	bba90913          	addi	s2,s2,-1094 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006476:	85d2                	mv	a1,s4
    80006478:	8526                	mv	a0,s1
    8000647a:	ffffb097          	auipc	ra,0xffffb
    8000647e:	1e2080e7          	jalr	482(ra) # 8000165c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006482:	00093783          	ld	a5,0(s2)
    80006486:	6098                	ld	a4,0(s1)
    80006488:	02070713          	addi	a4,a4,32
    8000648c:	fef705e3          	beq	a4,a5,80006476 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006490:	00024497          	auipc	s1,0x24
    80006494:	db848493          	addi	s1,s1,-584 # 8002a248 <uart_tx_lock>
    80006498:	01f7f713          	andi	a4,a5,31
    8000649c:	9726                	add	a4,a4,s1
    8000649e:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    800064a2:	0785                	addi	a5,a5,1
    800064a4:	00003717          	auipc	a4,0x3
    800064a8:	b8f73223          	sd	a5,-1148(a4) # 80009028 <uart_tx_w>
      uartstart();
    800064ac:	00000097          	auipc	ra,0x0
    800064b0:	ee2080e7          	jalr	-286(ra) # 8000638e <uartstart>
      release(&uart_tx_lock);
    800064b4:	8526                	mv	a0,s1
    800064b6:	00000097          	auipc	ra,0x0
    800064ba:	1da080e7          	jalr	474(ra) # 80006690 <release>
}
    800064be:	70a2                	ld	ra,40(sp)
    800064c0:	7402                	ld	s0,32(sp)
    800064c2:	64e2                	ld	s1,24(sp)
    800064c4:	6942                	ld	s2,16(sp)
    800064c6:	69a2                	ld	s3,8(sp)
    800064c8:	6a02                	ld	s4,0(sp)
    800064ca:	6145                	addi	sp,sp,48
    800064cc:	8082                	ret

00000000800064ce <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064ce:	1141                	addi	sp,sp,-16
    800064d0:	e422                	sd	s0,8(sp)
    800064d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064d4:	100007b7          	lui	a5,0x10000
    800064d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800064dc:	8b85                	andi	a5,a5,1
    800064de:	cb91                	beqz	a5,800064f2 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800064e0:	100007b7          	lui	a5,0x10000
    800064e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800064e8:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800064ec:	6422                	ld	s0,8(sp)
    800064ee:	0141                	addi	sp,sp,16
    800064f0:	8082                	ret
    return -1;
    800064f2:	557d                	li	a0,-1
    800064f4:	bfe5                	j	800064ec <uartgetc+0x1e>

00000000800064f6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800064f6:	1101                	addi	sp,sp,-32
    800064f8:	ec06                	sd	ra,24(sp)
    800064fa:	e822                	sd	s0,16(sp)
    800064fc:	e426                	sd	s1,8(sp)
    800064fe:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006500:	54fd                	li	s1,-1
    int c = uartgetc();
    80006502:	00000097          	auipc	ra,0x0
    80006506:	fcc080e7          	jalr	-52(ra) # 800064ce <uartgetc>
    if(c == -1)
    8000650a:	00950763          	beq	a0,s1,80006518 <uartintr+0x22>
      break;
    consoleintr(c);
    8000650e:	00000097          	auipc	ra,0x0
    80006512:	8fe080e7          	jalr	-1794(ra) # 80005e0c <consoleintr>
  while(1){
    80006516:	b7f5                	j	80006502 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006518:	00024497          	auipc	s1,0x24
    8000651c:	d3048493          	addi	s1,s1,-720 # 8002a248 <uart_tx_lock>
    80006520:	8526                	mv	a0,s1
    80006522:	00000097          	auipc	ra,0x0
    80006526:	09e080e7          	jalr	158(ra) # 800065c0 <acquire>
  uartstart();
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	e64080e7          	jalr	-412(ra) # 8000638e <uartstart>
  release(&uart_tx_lock);
    80006532:	8526                	mv	a0,s1
    80006534:	00000097          	auipc	ra,0x0
    80006538:	15c080e7          	jalr	348(ra) # 80006690 <release>
}
    8000653c:	60e2                	ld	ra,24(sp)
    8000653e:	6442                	ld	s0,16(sp)
    80006540:	64a2                	ld	s1,8(sp)
    80006542:	6105                	addi	sp,sp,32
    80006544:	8082                	ret

0000000080006546 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006546:	411c                	lw	a5,0(a0)
    80006548:	e399                	bnez	a5,8000654e <holding+0x8>
    8000654a:	4501                	li	a0,0
  return r;
}
    8000654c:	8082                	ret
{
    8000654e:	1101                	addi	sp,sp,-32
    80006550:	ec06                	sd	ra,24(sp)
    80006552:	e822                	sd	s0,16(sp)
    80006554:	e426                	sd	s1,8(sp)
    80006556:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006558:	6904                	ld	s1,16(a0)
    8000655a:	ffffb097          	auipc	ra,0xffffb
    8000655e:	a2a080e7          	jalr	-1494(ra) # 80000f84 <mycpu>
    80006562:	40a48533          	sub	a0,s1,a0
    80006566:	00153513          	seqz	a0,a0
}
    8000656a:	60e2                	ld	ra,24(sp)
    8000656c:	6442                	ld	s0,16(sp)
    8000656e:	64a2                	ld	s1,8(sp)
    80006570:	6105                	addi	sp,sp,32
    80006572:	8082                	ret

0000000080006574 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006574:	1101                	addi	sp,sp,-32
    80006576:	ec06                	sd	ra,24(sp)
    80006578:	e822                	sd	s0,16(sp)
    8000657a:	e426                	sd	s1,8(sp)
    8000657c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000657e:	100024f3          	csrr	s1,sstatus
    80006582:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006586:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006588:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000658c:	ffffb097          	auipc	ra,0xffffb
    80006590:	9f8080e7          	jalr	-1544(ra) # 80000f84 <mycpu>
    80006594:	5d3c                	lw	a5,120(a0)
    80006596:	cf89                	beqz	a5,800065b0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006598:	ffffb097          	auipc	ra,0xffffb
    8000659c:	9ec080e7          	jalr	-1556(ra) # 80000f84 <mycpu>
    800065a0:	5d3c                	lw	a5,120(a0)
    800065a2:	2785                	addiw	a5,a5,1
    800065a4:	dd3c                	sw	a5,120(a0)
}
    800065a6:	60e2                	ld	ra,24(sp)
    800065a8:	6442                	ld	s0,16(sp)
    800065aa:	64a2                	ld	s1,8(sp)
    800065ac:	6105                	addi	sp,sp,32
    800065ae:	8082                	ret
    mycpu()->intena = old;
    800065b0:	ffffb097          	auipc	ra,0xffffb
    800065b4:	9d4080e7          	jalr	-1580(ra) # 80000f84 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065b8:	8085                	srli	s1,s1,0x1
    800065ba:	8885                	andi	s1,s1,1
    800065bc:	dd64                	sw	s1,124(a0)
    800065be:	bfe9                	j	80006598 <push_off+0x24>

00000000800065c0 <acquire>:
{
    800065c0:	1101                	addi	sp,sp,-32
    800065c2:	ec06                	sd	ra,24(sp)
    800065c4:	e822                	sd	s0,16(sp)
    800065c6:	e426                	sd	s1,8(sp)
    800065c8:	1000                	addi	s0,sp,32
    800065ca:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065cc:	00000097          	auipc	ra,0x0
    800065d0:	fa8080e7          	jalr	-88(ra) # 80006574 <push_off>
  if(holding(lk))
    800065d4:	8526                	mv	a0,s1
    800065d6:	00000097          	auipc	ra,0x0
    800065da:	f70080e7          	jalr	-144(ra) # 80006546 <holding>
    800065de:	e911                	bnez	a0,800065f2 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800065e0:	4785                	li	a5,1
    800065e2:	01c48713          	addi	a4,s1,28
    800065e6:	0f50000f          	fence	iorw,ow
    800065ea:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800065ee:	4705                	li	a4,1
    800065f0:	a839                	j	8000660e <acquire+0x4e>
    panic("acquire");
    800065f2:	00002517          	auipc	a0,0x2
    800065f6:	21650513          	addi	a0,a0,534 # 80008808 <digits+0x20>
    800065fa:	00000097          	auipc	ra,0x0
    800065fe:	a92080e7          	jalr	-1390(ra) # 8000608c <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006602:	01848793          	addi	a5,s1,24
    80006606:	0f50000f          	fence	iorw,ow
    8000660a:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000660e:	87ba                	mv	a5,a4
    80006610:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006614:	2781                	sext.w	a5,a5
    80006616:	f7f5                	bnez	a5,80006602 <acquire+0x42>
  __sync_synchronize();
    80006618:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000661c:	ffffb097          	auipc	ra,0xffffb
    80006620:	968080e7          	jalr	-1688(ra) # 80000f84 <mycpu>
    80006624:	e888                	sd	a0,16(s1)
}
    80006626:	60e2                	ld	ra,24(sp)
    80006628:	6442                	ld	s0,16(sp)
    8000662a:	64a2                	ld	s1,8(sp)
    8000662c:	6105                	addi	sp,sp,32
    8000662e:	8082                	ret

0000000080006630 <pop_off>:

void
pop_off(void)
{
    80006630:	1141                	addi	sp,sp,-16
    80006632:	e406                	sd	ra,8(sp)
    80006634:	e022                	sd	s0,0(sp)
    80006636:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006638:	ffffb097          	auipc	ra,0xffffb
    8000663c:	94c080e7          	jalr	-1716(ra) # 80000f84 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006640:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006644:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006646:	e78d                	bnez	a5,80006670 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006648:	5d3c                	lw	a5,120(a0)
    8000664a:	02f05b63          	blez	a5,80006680 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000664e:	37fd                	addiw	a5,a5,-1
    80006650:	0007871b          	sext.w	a4,a5
    80006654:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006656:	eb09                	bnez	a4,80006668 <pop_off+0x38>
    80006658:	5d7c                	lw	a5,124(a0)
    8000665a:	c799                	beqz	a5,80006668 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000665c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006660:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006664:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006668:	60a2                	ld	ra,8(sp)
    8000666a:	6402                	ld	s0,0(sp)
    8000666c:	0141                	addi	sp,sp,16
    8000666e:	8082                	ret
    panic("pop_off - interruptible");
    80006670:	00002517          	auipc	a0,0x2
    80006674:	1a050513          	addi	a0,a0,416 # 80008810 <digits+0x28>
    80006678:	00000097          	auipc	ra,0x0
    8000667c:	a14080e7          	jalr	-1516(ra) # 8000608c <panic>
    panic("pop_off");
    80006680:	00002517          	auipc	a0,0x2
    80006684:	1a850513          	addi	a0,a0,424 # 80008828 <digits+0x40>
    80006688:	00000097          	auipc	ra,0x0
    8000668c:	a04080e7          	jalr	-1532(ra) # 8000608c <panic>

0000000080006690 <release>:
{
    80006690:	1101                	addi	sp,sp,-32
    80006692:	ec06                	sd	ra,24(sp)
    80006694:	e822                	sd	s0,16(sp)
    80006696:	e426                	sd	s1,8(sp)
    80006698:	1000                	addi	s0,sp,32
    8000669a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000669c:	00000097          	auipc	ra,0x0
    800066a0:	eaa080e7          	jalr	-342(ra) # 80006546 <holding>
    800066a4:	c115                	beqz	a0,800066c8 <release+0x38>
  lk->cpu = 0;
    800066a6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066aa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800066ae:	0f50000f          	fence	iorw,ow
    800066b2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800066b6:	00000097          	auipc	ra,0x0
    800066ba:	f7a080e7          	jalr	-134(ra) # 80006630 <pop_off>
}
    800066be:	60e2                	ld	ra,24(sp)
    800066c0:	6442                	ld	s0,16(sp)
    800066c2:	64a2                	ld	s1,8(sp)
    800066c4:	6105                	addi	sp,sp,32
    800066c6:	8082                	ret
    panic("release");
    800066c8:	00002517          	auipc	a0,0x2
    800066cc:	16850513          	addi	a0,a0,360 # 80008830 <digits+0x48>
    800066d0:	00000097          	auipc	ra,0x0
    800066d4:	9bc080e7          	jalr	-1604(ra) # 8000608c <panic>

00000000800066d8 <freelock>:
{
    800066d8:	1101                	addi	sp,sp,-32
    800066da:	ec06                	sd	ra,24(sp)
    800066dc:	e822                	sd	s0,16(sp)
    800066de:	e426                	sd	s1,8(sp)
    800066e0:	1000                	addi	s0,sp,32
    800066e2:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800066e4:	00024517          	auipc	a0,0x24
    800066e8:	ba450513          	addi	a0,a0,-1116 # 8002a288 <lock_locks>
    800066ec:	00000097          	auipc	ra,0x0
    800066f0:	ed4080e7          	jalr	-300(ra) # 800065c0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800066f4:	00024717          	auipc	a4,0x24
    800066f8:	bb470713          	addi	a4,a4,-1100 # 8002a2a8 <locks>
    800066fc:	4781                	li	a5,0
    800066fe:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006702:	6314                	ld	a3,0(a4)
    80006704:	00968763          	beq	a3,s1,80006712 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    80006708:	2785                	addiw	a5,a5,1
    8000670a:	0721                	addi	a4,a4,8
    8000670c:	fec79be3          	bne	a5,a2,80006702 <freelock+0x2a>
    80006710:	a809                	j	80006722 <freelock+0x4a>
      locks[i] = 0;
    80006712:	078e                	slli	a5,a5,0x3
    80006714:	00024717          	auipc	a4,0x24
    80006718:	b9470713          	addi	a4,a4,-1132 # 8002a2a8 <locks>
    8000671c:	97ba                	add	a5,a5,a4
    8000671e:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006722:	00024517          	auipc	a0,0x24
    80006726:	b6650513          	addi	a0,a0,-1178 # 8002a288 <lock_locks>
    8000672a:	00000097          	auipc	ra,0x0
    8000672e:	f66080e7          	jalr	-154(ra) # 80006690 <release>
}
    80006732:	60e2                	ld	ra,24(sp)
    80006734:	6442                	ld	s0,16(sp)
    80006736:	64a2                	ld	s1,8(sp)
    80006738:	6105                	addi	sp,sp,32
    8000673a:	8082                	ret

000000008000673c <initlock>:
{
    8000673c:	1101                	addi	sp,sp,-32
    8000673e:	ec06                	sd	ra,24(sp)
    80006740:	e822                	sd	s0,16(sp)
    80006742:	e426                	sd	s1,8(sp)
    80006744:	1000                	addi	s0,sp,32
    80006746:	84aa                	mv	s1,a0
  lk->name = name;
    80006748:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000674a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000674e:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006752:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006756:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000675a:	00024517          	auipc	a0,0x24
    8000675e:	b2e50513          	addi	a0,a0,-1234 # 8002a288 <lock_locks>
    80006762:	00000097          	auipc	ra,0x0
    80006766:	e5e080e7          	jalr	-418(ra) # 800065c0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000676a:	00024717          	auipc	a4,0x24
    8000676e:	b3e70713          	addi	a4,a4,-1218 # 8002a2a8 <locks>
    80006772:	4781                	li	a5,0
    80006774:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    80006778:	6310                	ld	a2,0(a4)
    8000677a:	ce09                	beqz	a2,80006794 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000677c:	2785                	addiw	a5,a5,1
    8000677e:	0721                	addi	a4,a4,8
    80006780:	fed79ce3          	bne	a5,a3,80006778 <initlock+0x3c>
  panic("findslot");
    80006784:	00002517          	auipc	a0,0x2
    80006788:	0b450513          	addi	a0,a0,180 # 80008838 <digits+0x50>
    8000678c:	00000097          	auipc	ra,0x0
    80006790:	900080e7          	jalr	-1792(ra) # 8000608c <panic>
      locks[i] = lk;
    80006794:	078e                	slli	a5,a5,0x3
    80006796:	00024717          	auipc	a4,0x24
    8000679a:	b1270713          	addi	a4,a4,-1262 # 8002a2a8 <locks>
    8000679e:	97ba                	add	a5,a5,a4
    800067a0:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    800067a2:	00024517          	auipc	a0,0x24
    800067a6:	ae650513          	addi	a0,a0,-1306 # 8002a288 <lock_locks>
    800067aa:	00000097          	auipc	ra,0x0
    800067ae:	ee6080e7          	jalr	-282(ra) # 80006690 <release>
}
    800067b2:	60e2                	ld	ra,24(sp)
    800067b4:	6442                	ld	s0,16(sp)
    800067b6:	64a2                	ld	s1,8(sp)
    800067b8:	6105                	addi	sp,sp,32
    800067ba:	8082                	ret

00000000800067bc <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800067bc:	1141                	addi	sp,sp,-16
    800067be:	e422                	sd	s0,8(sp)
    800067c0:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800067c2:	0ff0000f          	fence
    800067c6:	6108                	ld	a0,0(a0)
    800067c8:	0ff0000f          	fence
  return val;
}
    800067cc:	6422                	ld	s0,8(sp)
    800067ce:	0141                	addi	sp,sp,16
    800067d0:	8082                	ret

00000000800067d2 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    800067d2:	1141                	addi	sp,sp,-16
    800067d4:	e422                	sd	s0,8(sp)
    800067d6:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800067d8:	0ff0000f          	fence
    800067dc:	4108                	lw	a0,0(a0)
    800067de:	0ff0000f          	fence
  return val;
}
    800067e2:	2501                	sext.w	a0,a0
    800067e4:	6422                	ld	s0,8(sp)
    800067e6:	0141                	addi	sp,sp,16
    800067e8:	8082                	ret

00000000800067ea <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    800067ea:	4e5c                	lw	a5,28(a2)
    800067ec:	00f04463          	bgtz	a5,800067f4 <snprint_lock+0xa>
  int n = 0;
    800067f0:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800067f2:	8082                	ret
{
    800067f4:	1141                	addi	sp,sp,-16
    800067f6:	e406                	sd	ra,8(sp)
    800067f8:	e022                	sd	s0,0(sp)
    800067fa:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800067fc:	4e18                	lw	a4,24(a2)
    800067fe:	6614                	ld	a3,8(a2)
    80006800:	00002617          	auipc	a2,0x2
    80006804:	04860613          	addi	a2,a2,72 # 80008848 <digits+0x60>
    80006808:	fffff097          	auipc	ra,0xfffff
    8000680c:	1ea080e7          	jalr	490(ra) # 800059f2 <snprintf>
}
    80006810:	60a2                	ld	ra,8(sp)
    80006812:	6402                	ld	s0,0(sp)
    80006814:	0141                	addi	sp,sp,16
    80006816:	8082                	ret

0000000080006818 <statslock>:

int
statslock(char *buf, int sz) {
    80006818:	7159                	addi	sp,sp,-112
    8000681a:	f486                	sd	ra,104(sp)
    8000681c:	f0a2                	sd	s0,96(sp)
    8000681e:	eca6                	sd	s1,88(sp)
    80006820:	e8ca                	sd	s2,80(sp)
    80006822:	e4ce                	sd	s3,72(sp)
    80006824:	e0d2                	sd	s4,64(sp)
    80006826:	fc56                	sd	s5,56(sp)
    80006828:	f85a                	sd	s6,48(sp)
    8000682a:	f45e                	sd	s7,40(sp)
    8000682c:	f062                	sd	s8,32(sp)
    8000682e:	ec66                	sd	s9,24(sp)
    80006830:	e86a                	sd	s10,16(sp)
    80006832:	e46e                	sd	s11,8(sp)
    80006834:	1880                	addi	s0,sp,112
    80006836:	8aaa                	mv	s5,a0
    80006838:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000683a:	00024517          	auipc	a0,0x24
    8000683e:	a4e50513          	addi	a0,a0,-1458 # 8002a288 <lock_locks>
    80006842:	00000097          	auipc	ra,0x0
    80006846:	d7e080e7          	jalr	-642(ra) # 800065c0 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000684a:	00002617          	auipc	a2,0x2
    8000684e:	02e60613          	addi	a2,a2,46 # 80008878 <digits+0x90>
    80006852:	85da                	mv	a1,s6
    80006854:	8556                	mv	a0,s5
    80006856:	fffff097          	auipc	ra,0xfffff
    8000685a:	19c080e7          	jalr	412(ra) # 800059f2 <snprintf>
    8000685e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006860:	00024c97          	auipc	s9,0x24
    80006864:	a48c8c93          	addi	s9,s9,-1464 # 8002a2a8 <locks>
    80006868:	00025c17          	auipc	s8,0x25
    8000686c:	9e0c0c13          	addi	s8,s8,-1568 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006870:	84e6                	mv	s1,s9
  int tot = 0;
    80006872:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006874:	00002b97          	auipc	s7,0x2
    80006878:	024b8b93          	addi	s7,s7,36 # 80008898 <digits+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    8000687c:	00002d17          	auipc	s10,0x2
    80006880:	024d0d13          	addi	s10,s10,36 # 800088a0 <digits+0xb8>
    80006884:	a01d                	j	800068aa <statslock+0x92>
      tot += locks[i]->nts;
    80006886:	0009b603          	ld	a2,0(s3)
    8000688a:	4e1c                	lw	a5,24(a2)
    8000688c:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006890:	412b05bb          	subw	a1,s6,s2
    80006894:	012a8533          	add	a0,s5,s2
    80006898:	00000097          	auipc	ra,0x0
    8000689c:	f52080e7          	jalr	-174(ra) # 800067ea <snprint_lock>
    800068a0:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    800068a4:	04a1                	addi	s1,s1,8
    800068a6:	05848763          	beq	s1,s8,800068f4 <statslock+0xdc>
    if(locks[i] == 0)
    800068aa:	89a6                	mv	s3,s1
    800068ac:	609c                	ld	a5,0(s1)
    800068ae:	c3b9                	beqz	a5,800068f4 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800068b0:	0087bd83          	ld	s11,8(a5)
    800068b4:	855e                	mv	a0,s7
    800068b6:	ffffa097          	auipc	ra,0xffffa
    800068ba:	b8e080e7          	jalr	-1138(ra) # 80000444 <strlen>
    800068be:	0005061b          	sext.w	a2,a0
    800068c2:	85de                	mv	a1,s7
    800068c4:	856e                	mv	a0,s11
    800068c6:	ffffa097          	auipc	ra,0xffffa
    800068ca:	ad2080e7          	jalr	-1326(ra) # 80000398 <strncmp>
    800068ce:	dd45                	beqz	a0,80006886 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800068d0:	609c                	ld	a5,0(s1)
    800068d2:	0087bd83          	ld	s11,8(a5)
    800068d6:	856a                	mv	a0,s10
    800068d8:	ffffa097          	auipc	ra,0xffffa
    800068dc:	b6c080e7          	jalr	-1172(ra) # 80000444 <strlen>
    800068e0:	0005061b          	sext.w	a2,a0
    800068e4:	85ea                	mv	a1,s10
    800068e6:	856e                	mv	a0,s11
    800068e8:	ffffa097          	auipc	ra,0xffffa
    800068ec:	ab0080e7          	jalr	-1360(ra) # 80000398 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800068f0:	f955                	bnez	a0,800068a4 <statslock+0x8c>
    800068f2:	bf51                	j	80006886 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800068f4:	00002617          	auipc	a2,0x2
    800068f8:	fb460613          	addi	a2,a2,-76 # 800088a8 <digits+0xc0>
    800068fc:	412b05bb          	subw	a1,s6,s2
    80006900:	012a8533          	add	a0,s5,s2
    80006904:	fffff097          	auipc	ra,0xfffff
    80006908:	0ee080e7          	jalr	238(ra) # 800059f2 <snprintf>
    8000690c:	012509bb          	addw	s3,a0,s2
    80006910:	4b95                	li	s7,5
  int last = 100000000;
    80006912:	05f5e537          	lui	a0,0x5f5e
    80006916:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    8000691a:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    8000691c:	00024497          	auipc	s1,0x24
    80006920:	98c48493          	addi	s1,s1,-1652 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006924:	1f400913          	li	s2,500
    80006928:	a881                	j	80006978 <statslock+0x160>
    8000692a:	2705                	addiw	a4,a4,1
    8000692c:	06a1                	addi	a3,a3,8
    8000692e:	03270063          	beq	a4,s2,8000694e <statslock+0x136>
      if(locks[i] == 0)
    80006932:	629c                	ld	a5,0(a3)
    80006934:	cf89                	beqz	a5,8000694e <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006936:	4f90                	lw	a2,24(a5)
    80006938:	00359793          	slli	a5,a1,0x3
    8000693c:	97a6                	add	a5,a5,s1
    8000693e:	639c                	ld	a5,0(a5)
    80006940:	4f9c                	lw	a5,24(a5)
    80006942:	fec7d4e3          	bge	a5,a2,8000692a <statslock+0x112>
    80006946:	fea652e3          	bge	a2,a0,8000692a <statslock+0x112>
    8000694a:	85ba                	mv	a1,a4
    8000694c:	bff9                	j	8000692a <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    8000694e:	058e                	slli	a1,a1,0x3
    80006950:	00b48d33          	add	s10,s1,a1
    80006954:	000d3603          	ld	a2,0(s10)
    80006958:	413b05bb          	subw	a1,s6,s3
    8000695c:	013a8533          	add	a0,s5,s3
    80006960:	00000097          	auipc	ra,0x0
    80006964:	e8a080e7          	jalr	-374(ra) # 800067ea <snprint_lock>
    80006968:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    8000696c:	000d3783          	ld	a5,0(s10)
    80006970:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006972:	3bfd                	addiw	s7,s7,-1
    80006974:	000b8663          	beqz	s7,80006980 <statslock+0x168>
  int tot = 0;
    80006978:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    8000697a:	8762                	mv	a4,s8
    int top = 0;
    8000697c:	85e2                	mv	a1,s8
    8000697e:	bf55                	j	80006932 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006980:	86d2                	mv	a3,s4
    80006982:	00002617          	auipc	a2,0x2
    80006986:	f4660613          	addi	a2,a2,-186 # 800088c8 <digits+0xe0>
    8000698a:	413b05bb          	subw	a1,s6,s3
    8000698e:	013a8533          	add	a0,s5,s3
    80006992:	fffff097          	auipc	ra,0xfffff
    80006996:	060080e7          	jalr	96(ra) # 800059f2 <snprintf>
    8000699a:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    8000699e:	00024517          	auipc	a0,0x24
    800069a2:	8ea50513          	addi	a0,a0,-1814 # 8002a288 <lock_locks>
    800069a6:	00000097          	auipc	ra,0x0
    800069aa:	cea080e7          	jalr	-790(ra) # 80006690 <release>
  return n;
}
    800069ae:	854e                	mv	a0,s3
    800069b0:	70a6                	ld	ra,104(sp)
    800069b2:	7406                	ld	s0,96(sp)
    800069b4:	64e6                	ld	s1,88(sp)
    800069b6:	6946                	ld	s2,80(sp)
    800069b8:	69a6                	ld	s3,72(sp)
    800069ba:	6a06                	ld	s4,64(sp)
    800069bc:	7ae2                	ld	s5,56(sp)
    800069be:	7b42                	ld	s6,48(sp)
    800069c0:	7ba2                	ld	s7,40(sp)
    800069c2:	7c02                	ld	s8,32(sp)
    800069c4:	6ce2                	ld	s9,24(sp)
    800069c6:	6d42                	ld	s10,16(sp)
    800069c8:	6da2                	ld	s11,8(sp)
    800069ca:	6165                	addi	sp,sp,112
    800069cc:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
