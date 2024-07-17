
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	754050ef          	jal	ra,8000576a <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	182080e7          	jalr	386(ra) # 800001ca <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0f6080e7          	jalr	246(ra) # 80006150 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	196080e7          	jalr	406(ra) # 80006204 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b8a080e7          	jalr	-1142(ra) # 80005c14 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	fcc080e7          	jalr	-52(ra) # 800060c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	024080e7          	jalr	36(ra) # 80006150 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	0c0080e7          	jalr	192(ra) # 80006204 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	078080e7          	jalr	120(ra) # 800001ca <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	096080e7          	jalr	150(ra) # 80006204 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <freebytes>:

void
freebytes(uint64* dst)
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	e04a                	sd	s2,0(sp)
    80000182:	1000                	addi	s0,sp,32
    80000184:	892a                	mv	s2,a0
  *dst = 0;
    80000186:	00053023          	sd	zero,0(a0)
  struct run* p = kmem.freelist; // 用于遍历
    8000018a:	00009517          	auipc	a0,0x9
    8000018e:	ea650513          	addi	a0,a0,-346 # 80009030 <kmem>
    80000192:	6d04                	ld	s1,24(a0)

  acquire(&kmem.lock);
    80000194:	00006097          	auipc	ra,0x6
    80000198:	fbc080e7          	jalr	-68(ra) # 80006150 <acquire>
  while (p) {
    8000019c:	c889                	beqz	s1,800001ae <freebytes+0x36>
    // 统计空闲页数，乘上页大小 PGSIZE 就是空闲的内存字节数
    *dst += PGSIZE;
    8000019e:	6705                	lui	a4,0x1
    800001a0:	00093783          	ld	a5,0(s2)
    800001a4:	97ba                	add	a5,a5,a4
    800001a6:	00f93023          	sd	a5,0(s2)
    p = p->next;
    800001aa:	6084                	ld	s1,0(s1)
  while (p) {
    800001ac:	f8f5                	bnez	s1,800001a0 <freebytes+0x28>
  }
  release(&kmem.lock);
    800001ae:	00009517          	auipc	a0,0x9
    800001b2:	e8250513          	addi	a0,a0,-382 # 80009030 <kmem>
    800001b6:	00006097          	auipc	ra,0x6
    800001ba:	04e080e7          	jalr	78(ra) # 80006204 <release>
}
    800001be:	60e2                	ld	ra,24(sp)
    800001c0:	6442                	ld	s0,16(sp)
    800001c2:	64a2                	ld	s1,8(sp)
    800001c4:	6902                	ld	s2,0(sp)
    800001c6:	6105                	addi	sp,sp,32
    800001c8:	8082                	ret

00000000800001ca <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001ca:	1141                	addi	sp,sp,-16
    800001cc:	e422                	sd	s0,8(sp)
    800001ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001d0:	ca19                	beqz	a2,800001e6 <memset+0x1c>
    800001d2:	87aa                	mv	a5,a0
    800001d4:	1602                	slli	a2,a2,0x20
    800001d6:	9201                	srli	a2,a2,0x20
    800001d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001e0:	0785                	addi	a5,a5,1
    800001e2:	fee79de3          	bne	a5,a4,800001dc <memset+0x12>
  }
  return dst;
}
    800001e6:	6422                	ld	s0,8(sp)
    800001e8:	0141                	addi	sp,sp,16
    800001ea:	8082                	ret

00000000800001ec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e422                	sd	s0,8(sp)
    800001f0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001f2:	ca05                	beqz	a2,80000222 <memcmp+0x36>
    800001f4:	fff6069b          	addiw	a3,a2,-1
    800001f8:	1682                	slli	a3,a3,0x20
    800001fa:	9281                	srli	a3,a3,0x20
    800001fc:	0685                	addi	a3,a3,1
    800001fe:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000200:	00054783          	lbu	a5,0(a0)
    80000204:	0005c703          	lbu	a4,0(a1)
    80000208:	00e79863          	bne	a5,a4,80000218 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000020c:	0505                	addi	a0,a0,1
    8000020e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000210:	fed518e3          	bne	a0,a3,80000200 <memcmp+0x14>
  }

  return 0;
    80000214:	4501                	li	a0,0
    80000216:	a019                	j	8000021c <memcmp+0x30>
      return *s1 - *s2;
    80000218:	40e7853b          	subw	a0,a5,a4
}
    8000021c:	6422                	ld	s0,8(sp)
    8000021e:	0141                	addi	sp,sp,16
    80000220:	8082                	ret
  return 0;
    80000222:	4501                	li	a0,0
    80000224:	bfe5                	j	8000021c <memcmp+0x30>

0000000080000226 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e422                	sd	s0,8(sp)
    8000022a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000022c:	c205                	beqz	a2,8000024c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022e:	02a5e263          	bltu	a1,a0,80000252 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000232:	1602                	slli	a2,a2,0x20
    80000234:	9201                	srli	a2,a2,0x20
    80000236:	00c587b3          	add	a5,a1,a2
{
    8000023a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000023c:	0585                	addi	a1,a1,1
    8000023e:	0705                	addi	a4,a4,1
    80000240:	fff5c683          	lbu	a3,-1(a1)
    80000244:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
    while(n-- > 0)
    80000248:	fef59ae3          	bne	a1,a5,8000023c <memmove+0x16>

  return dst;
}
    8000024c:	6422                	ld	s0,8(sp)
    8000024e:	0141                	addi	sp,sp,16
    80000250:	8082                	ret
  if(s < d && s + n > d){
    80000252:	02061693          	slli	a3,a2,0x20
    80000256:	9281                	srli	a3,a3,0x20
    80000258:	00d58733          	add	a4,a1,a3
    8000025c:	fce57be3          	bgeu	a0,a4,80000232 <memmove+0xc>
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fee79ae3          	bne	a5,a4,80000270 <memmove+0x4a>
    80000280:	b7f1                	j	8000024c <memmove+0x26>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f9c080e7          	jalr	-100(ra) # 80000226 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	86ba                	mv	a3,a4
    800002f6:	00c05c63          	blez	a2,8000030e <strncpy+0x38>
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	af0080e7          	jalr	-1296(ra) # 80000e68 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad4080e7          	jalr	-1324(ra) # 80000e68 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	8b8080e7          	jalr	-1864(ra) # 80005c5e <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	76c080e7          	jalr	1900(ra) # 80001b22 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	d82080e7          	jalr	-638(ra) # 80005140 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fe4080e7          	jalr	-28(ra) # 800013aa <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	758080e7          	jalr	1880(ra) # 80005b26 <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	a68080e7          	jalr	-1432(ra) # 80005e3e <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	878080e7          	jalr	-1928(ra) # 80005c5e <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	868080e7          	jalr	-1944(ra) # 80005c5e <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	858080e7          	jalr	-1960(ra) # 80005c5e <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	992080e7          	jalr	-1646(ra) # 80000db8 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6cc080e7          	jalr	1740(ra) # 80001afa <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	6ec080e7          	jalr	1772(ra) # 80001b22 <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	cec080e7          	jalr	-788(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	cfa080e7          	jalr	-774(ra) # 80005140 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	ec6080e7          	jalr	-314(ra) # 80002314 <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	556080e7          	jalr	1366(ra) # 800029ac <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	500080e7          	jalr	1280(ra) # 8000395e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	dfc080e7          	jalr	-516(ra) # 80005262 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfe080e7          	jalr	-770(ra) # 8000116c <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	73c080e7          	jalr	1852(ra) # 80005c14 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cd6080e7          	jalr	-810(ra) # 800001ca <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c639                	beqz	a2,800005f6 <mappages+0x64>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ca:	4605                	li	a2,1
    800005cc:	85ca                	mv	a1,s2
    800005ce:	8556                	mv	a0,s5
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	eda080e7          	jalr	-294(ra) # 800004aa <walk>
    800005d8:	cd1d                	beqz	a0,80000616 <mappages+0x84>
    if(*pte & PTE_V)
    800005da:	611c                	ld	a5,0(a0)
    800005dc:	8b85                	andi	a5,a5,1
    800005de:	e785                	bnez	a5,80000606 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e0:	80b1                	srli	s1,s1,0xc
    800005e2:	04aa                	slli	s1,s1,0xa
    800005e4:	0164e4b3          	or	s1,s1,s6
    800005e8:	0014e493          	ori	s1,s1,1
    800005ec:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ee:	05390063          	beq	s2,s3,8000062e <mappages+0x9c>
    a += PGSIZE;
    800005f2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f4:	bfc9                	j	800005c6 <mappages+0x34>
    panic("mappages: size");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a6250513          	addi	a0,a0,-1438 # 80008058 <etext+0x58>
    800005fe:	00005097          	auipc	ra,0x5
    80000602:	616080e7          	jalr	1558(ra) # 80005c14 <panic>
      panic("mappages: remap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a6250513          	addi	a0,a0,-1438 # 80008068 <etext+0x68>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	606080e7          	jalr	1542(ra) # 80005c14 <panic>
      return -1;
    80000616:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000618:	60a6                	ld	ra,72(sp)
    8000061a:	6406                	ld	s0,64(sp)
    8000061c:	74e2                	ld	s1,56(sp)
    8000061e:	7942                	ld	s2,48(sp)
    80000620:	79a2                	ld	s3,40(sp)
    80000622:	7a02                	ld	s4,32(sp)
    80000624:	6ae2                	ld	s5,24(sp)
    80000626:	6b42                	ld	s6,16(sp)
    80000628:	6ba2                	ld	s7,8(sp)
    8000062a:	6161                	addi	sp,sp,80
    8000062c:	8082                	ret
  return 0;
    8000062e:	4501                	li	a0,0
    80000630:	b7e5                	j	80000618 <mappages+0x86>

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	5ba080e7          	jalr	1466(ra) # 80005c14 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b4e080e7          	jalr	-1202(ra) # 800001ca <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	600080e7          	jalr	1536(ra) # 80000d22 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e263          	bltu	a1,s3,800007e8 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	46e080e7          	jalr	1134(ra) # 80005c14 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	45e080e7          	jalr	1118(ra) # 80005c14 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	44e080e7          	jalr	1102(ra) # 80005c14 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	43e080e7          	jalr	1086(ra) # 80005c14 <panic>
    *pte = 0;
    800007de:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007e2:	995a                	add	s2,s2,s6
    800007e4:	fb3972e3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e8:	4601                	li	a2,0
    800007ea:	85ca                	mv	a1,s2
    800007ec:	8552                	mv	a0,s4
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	cbc080e7          	jalr	-836(ra) # 800004aa <walk>
    800007f6:	84aa                	mv	s1,a0
    800007f8:	d95d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007fa:	6108                	ld	a0,0(a0)
    800007fc:	00157793          	andi	a5,a0,1
    80000800:	dfdd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000802:	3ff57793          	andi	a5,a0,1023
    80000806:	fd7784e3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    8000080a:	fc0a8ae3          	beqz	s5,800007de <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000080e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000810:	0532                	slli	a0,a0,0xc
    80000812:	00000097          	auipc	ra,0x0
    80000816:	80a080e7          	jalr	-2038(ra) # 8000001c <kfree>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	994080e7          	jalr	-1644(ra) # 800001ca <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	956080e7          	jalr	-1706(ra) # 800001ca <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	992080e7          	jalr	-1646(ra) # 80000226 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	360080e7          	jalr	864(ra) # 80005c14 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	88a080e7          	jalr	-1910(ra) # 800001ca <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	21e080e7          	jalr	542(ra) # 80005c14 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	782080e7          	jalr	1922(ra) # 80000226 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	142080e7          	jalr	322(ra) # 80005c14 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	132080e7          	jalr	306(ra) # 80005c14 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	0c8080e7          	jalr	200(ra) # 80005c14 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69e080e7          	jalr	1694(ra) # 80000226 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	caa5                	beqz	a3,80000c50 <copyin+0x70>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a01d                	j	80000c2c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	018505b3          	add	a1,a0,s8
    80000c0c:	0004861b          	sext.w	a2,s1
    80000c10:	412585b3          	sub	a1,a1,s2
    80000c14:	8552                	mv	a0,s4
    80000c16:	fffff097          	auipc	ra,0xfffff
    80000c1a:	610080e7          	jalr	1552(ra) # 80000226 <memmove>

    len -= n;
    80000c1e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c22:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c24:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c28:	02098263          	beqz	s3,80000c4c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c2c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c30:	85ca                	mv	a1,s2
    80000c32:	855a                	mv	a0,s6
    80000c34:	00000097          	auipc	ra,0x0
    80000c38:	91c080e7          	jalr	-1764(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3c:	cd01                	beqz	a0,80000c54 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c3e:	418904b3          	sub	s1,s2,s8
    80000c42:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c44:	fc99f2e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c48:	84ce                	mv	s1,s3
    80000c4a:	bf7d                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4c:	4501                	li	a0,0
    80000c4e:	a021                	j	80000c56 <copyin+0x76>
    80000c50:	4501                	li	a0,0
}
    80000c52:	8082                	ret
      return -1;
    80000c54:	557d                	li	a0,-1
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6c02                	ld	s8,0(sp)
    80000c6a:	6161                	addi	sp,sp,80
    80000c6c:	8082                	ret

0000000080000c6e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6e:	c6c5                	beqz	a3,80000d16 <copyinstr+0xa8>
{
    80000c70:	715d                	addi	sp,sp,-80
    80000c72:	e486                	sd	ra,72(sp)
    80000c74:	e0a2                	sd	s0,64(sp)
    80000c76:	fc26                	sd	s1,56(sp)
    80000c78:	f84a                	sd	s2,48(sp)
    80000c7a:	f44e                	sd	s3,40(sp)
    80000c7c:	f052                	sd	s4,32(sp)
    80000c7e:	ec56                	sd	s5,24(sp)
    80000c80:	e85a                	sd	s6,16(sp)
    80000c82:	e45e                	sd	s7,8(sp)
    80000c84:	0880                	addi	s0,sp,80
    80000c86:	8a2a                	mv	s4,a0
    80000c88:	8b2e                	mv	s6,a1
    80000c8a:	8bb2                	mv	s7,a2
    80000c8c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c90:	6985                	lui	s3,0x1
    80000c92:	a035                	j	80000cbe <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c94:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c98:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c9a:	0017b793          	seqz	a5,a5
    80000c9e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca2:	60a6                	ld	ra,72(sp)
    80000ca4:	6406                	ld	s0,64(sp)
    80000ca6:	74e2                	ld	s1,56(sp)
    80000ca8:	7942                	ld	s2,48(sp)
    80000caa:	79a2                	ld	s3,40(sp)
    80000cac:	7a02                	ld	s4,32(sp)
    80000cae:	6ae2                	ld	s5,24(sp)
    80000cb0:	6b42                	ld	s6,16(sp)
    80000cb2:	6ba2                	ld	s7,8(sp)
    80000cb4:	6161                	addi	sp,sp,80
    80000cb6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cbc:	c8a9                	beqz	s1,80000d0e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbe:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc2:	85ca                	mv	a1,s2
    80000cc4:	8552                	mv	a0,s4
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	88a080e7          	jalr	-1910(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000cce:	c131                	beqz	a0,80000d12 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cd0:	41790833          	sub	a6,s2,s7
    80000cd4:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd6:	0104f363          	bgeu	s1,a6,80000cdc <copyinstr+0x6e>
    80000cda:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cdc:	955e                	add	a0,a0,s7
    80000cde:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce2:	fc080be3          	beqz	a6,80000cb8 <copyinstr+0x4a>
    80000ce6:	985a                	add	a6,a6,s6
    80000ce8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cea:	41650633          	sub	a2,a0,s6
    80000cee:	14fd                	addi	s1,s1,-1
    80000cf0:	9b26                	add	s6,s6,s1
    80000cf2:	00f60733          	add	a4,a2,a5
    80000cf6:	00074703          	lbu	a4,0(a4)
    80000cfa:	df49                	beqz	a4,80000c94 <copyinstr+0x26>
        *dst = *p;
    80000cfc:	00e78023          	sb	a4,0(a5)
      --max;
    80000d00:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d04:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d06:	ff0796e3          	bne	a5,a6,80000cf2 <copyinstr+0x84>
      dst++;
    80000d0a:	8b42                	mv	s6,a6
    80000d0c:	b775                	j	80000cb8 <copyinstr+0x4a>
    80000d0e:	4781                	li	a5,0
    80000d10:	b769                	j	80000c9a <copyinstr+0x2c>
      return -1;
    80000d12:	557d                	li	a0,-1
    80000d14:	b779                	j	80000ca2 <copyinstr+0x34>
  int got_null = 0;
    80000d16:	4781                	li	a5,0
  if(got_null){
    80000d18:	0017b793          	seqz	a5,a5
    80000d1c:	40f00533          	neg	a0,a5
}
    80000d20:	8082                	ret

0000000080000d22 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d22:	7139                	addi	sp,sp,-64
    80000d24:	fc06                	sd	ra,56(sp)
    80000d26:	f822                	sd	s0,48(sp)
    80000d28:	f426                	sd	s1,40(sp)
    80000d2a:	f04a                	sd	s2,32(sp)
    80000d2c:	ec4e                	sd	s3,24(sp)
    80000d2e:	e852                	sd	s4,16(sp)
    80000d30:	e456                	sd	s5,8(sp)
    80000d32:	e05a                	sd	s6,0(sp)
    80000d34:	0080                	addi	s0,sp,64
    80000d36:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d38:	00008497          	auipc	s1,0x8
    80000d3c:	74848493          	addi	s1,s1,1864 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d40:	8b26                	mv	s6,s1
    80000d42:	00007a97          	auipc	s5,0x7
    80000d46:	2bea8a93          	addi	s5,s5,702 # 80008000 <etext>
    80000d4a:	04000937          	lui	s2,0x4000
    80000d4e:	197d                	addi	s2,s2,-1
    80000d50:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d52:	0000ea17          	auipc	s4,0xe
    80000d56:	12ea0a13          	addi	s4,s4,302 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d5a:	fffff097          	auipc	ra,0xfffff
    80000d5e:	3be080e7          	jalr	958(ra) # 80000118 <kalloc>
    80000d62:	862a                	mv	a2,a0
    if(pa == 0)
    80000d64:	c131                	beqz	a0,80000da8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d66:	416485b3          	sub	a1,s1,s6
    80000d6a:	858d                	srai	a1,a1,0x3
    80000d6c:	000ab783          	ld	a5,0(s5)
    80000d70:	02f585b3          	mul	a1,a1,a5
    80000d74:	2585                	addiw	a1,a1,1
    80000d76:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d7a:	4719                	li	a4,6
    80000d7c:	6685                	lui	a3,0x1
    80000d7e:	40b905b3          	sub	a1,s2,a1
    80000d82:	854e                	mv	a0,s3
    80000d84:	00000097          	auipc	ra,0x0
    80000d88:	8ae080e7          	jalr	-1874(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	16848493          	addi	s1,s1,360
    80000d90:	fd4495e3          	bne	s1,s4,80000d5a <proc_mapstacks+0x38>
  }
}
    80000d94:	70e2                	ld	ra,56(sp)
    80000d96:	7442                	ld	s0,48(sp)
    80000d98:	74a2                	ld	s1,40(sp)
    80000d9a:	7902                	ld	s2,32(sp)
    80000d9c:	69e2                	ld	s3,24(sp)
    80000d9e:	6a42                	ld	s4,16(sp)
    80000da0:	6aa2                	ld	s5,8(sp)
    80000da2:	6b02                	ld	s6,0(sp)
    80000da4:	6121                	addi	sp,sp,64
    80000da6:	8082                	ret
      panic("kalloc");
    80000da8:	00007517          	auipc	a0,0x7
    80000dac:	3b050513          	addi	a0,a0,944 # 80008158 <etext+0x158>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	e64080e7          	jalr	-412(ra) # 80005c14 <panic>

0000000080000db8 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db8:	7139                	addi	sp,sp,-64
    80000dba:	fc06                	sd	ra,56(sp)
    80000dbc:	f822                	sd	s0,48(sp)
    80000dbe:	f426                	sd	s1,40(sp)
    80000dc0:	f04a                	sd	s2,32(sp)
    80000dc2:	ec4e                	sd	s3,24(sp)
    80000dc4:	e852                	sd	s4,16(sp)
    80000dc6:	e456                	sd	s5,8(sp)
    80000dc8:	e05a                	sd	s6,0(sp)
    80000dca:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dcc:	00007597          	auipc	a1,0x7
    80000dd0:	39458593          	addi	a1,a1,916 # 80008160 <etext+0x160>
    80000dd4:	00008517          	auipc	a0,0x8
    80000dd8:	27c50513          	addi	a0,a0,636 # 80009050 <pid_lock>
    80000ddc:	00005097          	auipc	ra,0x5
    80000de0:	2e4080e7          	jalr	740(ra) # 800060c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de4:	00007597          	auipc	a1,0x7
    80000de8:	38458593          	addi	a1,a1,900 # 80008168 <etext+0x168>
    80000dec:	00008517          	auipc	a0,0x8
    80000df0:	27c50513          	addi	a0,a0,636 # 80009068 <wait_lock>
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	2cc080e7          	jalr	716(ra) # 800060c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	00008497          	auipc	s1,0x8
    80000e00:	68448493          	addi	s1,s1,1668 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e04:	00007b17          	auipc	s6,0x7
    80000e08:	374b0b13          	addi	s6,s6,884 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0c:	8aa6                	mv	s5,s1
    80000e0e:	00007a17          	auipc	s4,0x7
    80000e12:	1f2a0a13          	addi	s4,s4,498 # 80008000 <etext>
    80000e16:	04000937          	lui	s2,0x4000
    80000e1a:	197d                	addi	s2,s2,-1
    80000e1c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1e:	0000e997          	auipc	s3,0xe
    80000e22:	06298993          	addi	s3,s3,98 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e26:	85da                	mv	a1,s6
    80000e28:	8526                	mv	a0,s1
    80000e2a:	00005097          	auipc	ra,0x5
    80000e2e:	296080e7          	jalr	662(ra) # 800060c0 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e32:	415487b3          	sub	a5,s1,s5
    80000e36:	878d                	srai	a5,a5,0x3
    80000e38:	000a3703          	ld	a4,0(s4)
    80000e3c:	02e787b3          	mul	a5,a5,a4
    80000e40:	2785                	addiw	a5,a5,1
    80000e42:	00d7979b          	slliw	a5,a5,0xd
    80000e46:	40f907b3          	sub	a5,s2,a5
    80000e4a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4c:	16848493          	addi	s1,s1,360
    80000e50:	fd349be3          	bne	s1,s3,80000e26 <procinit+0x6e>
  }
}
    80000e54:	70e2                	ld	ra,56(sp)
    80000e56:	7442                	ld	s0,48(sp)
    80000e58:	74a2                	ld	s1,40(sp)
    80000e5a:	7902                	ld	s2,32(sp)
    80000e5c:	69e2                	ld	s3,24(sp)
    80000e5e:	6a42                	ld	s4,16(sp)
    80000e60:	6aa2                	ld	s5,8(sp)
    80000e62:	6b02                	ld	s6,0(sp)
    80000e64:	6121                	addi	sp,sp,64
    80000e66:	8082                	ret

0000000080000e68 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e68:	1141                	addi	sp,sp,-16
    80000e6a:	e422                	sd	s0,8(sp)
    80000e6c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e70:	2501                	sext.w	a0,a0
    80000e72:	6422                	ld	s0,8(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret

0000000080000e78 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e422                	sd	s0,8(sp)
    80000e7c:	0800                	addi	s0,sp,16
    80000e7e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e80:	2781                	sext.w	a5,a5
    80000e82:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e84:	00008517          	auipc	a0,0x8
    80000e88:	1fc50513          	addi	a0,a0,508 # 80009080 <cpus>
    80000e8c:	953e                	add	a0,a0,a5
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e94:	1101                	addi	sp,sp,-32
    80000e96:	ec06                	sd	ra,24(sp)
    80000e98:	e822                	sd	s0,16(sp)
    80000e9a:	e426                	sd	s1,8(sp)
    80000e9c:	1000                	addi	s0,sp,32
  push_off();
    80000e9e:	00005097          	auipc	ra,0x5
    80000ea2:	266080e7          	jalr	614(ra) # 80006104 <push_off>
    80000ea6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea8:	2781                	sext.w	a5,a5
    80000eaa:	079e                	slli	a5,a5,0x7
    80000eac:	00008717          	auipc	a4,0x8
    80000eb0:	1a470713          	addi	a4,a4,420 # 80009050 <pid_lock>
    80000eb4:	97ba                	add	a5,a5,a4
    80000eb6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb8:	00005097          	auipc	ra,0x5
    80000ebc:	2ec080e7          	jalr	748(ra) # 800061a4 <pop_off>
  return p;
}
    80000ec0:	8526                	mv	a0,s1
    80000ec2:	60e2                	ld	ra,24(sp)
    80000ec4:	6442                	ld	s0,16(sp)
    80000ec6:	64a2                	ld	s1,8(sp)
    80000ec8:	6105                	addi	sp,sp,32
    80000eca:	8082                	ret

0000000080000ecc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ecc:	1141                	addi	sp,sp,-16
    80000ece:	e406                	sd	ra,8(sp)
    80000ed0:	e022                	sd	s0,0(sp)
    80000ed2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed4:	00000097          	auipc	ra,0x0
    80000ed8:	fc0080e7          	jalr	-64(ra) # 80000e94 <myproc>
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	328080e7          	jalr	808(ra) # 80006204 <release>

  if (first) {
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	acc7a783          	lw	a5,-1332(a5) # 800089b0 <first.1>
    80000eec:	eb89                	bnez	a5,80000efe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eee:	00001097          	auipc	ra,0x1
    80000ef2:	c4c080e7          	jalr	-948(ra) # 80001b3a <usertrapret>
}
    80000ef6:	60a2                	ld	ra,8(sp)
    80000ef8:	6402                	ld	s0,0(sp)
    80000efa:	0141                	addi	sp,sp,16
    80000efc:	8082                	ret
    first = 0;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	aa07a923          	sw	zero,-1358(a5) # 800089b0 <first.1>
    fsinit(ROOTDEV);
    80000f06:	4505                	li	a0,1
    80000f08:	00002097          	auipc	ra,0x2
    80000f0c:	a24080e7          	jalr	-1500(ra) # 8000292c <fsinit>
    80000f10:	bff9                	j	80000eee <forkret+0x22>

0000000080000f12 <allocpid>:
allocpid() {
    80000f12:	1101                	addi	sp,sp,-32
    80000f14:	ec06                	sd	ra,24(sp)
    80000f16:	e822                	sd	s0,16(sp)
    80000f18:	e426                	sd	s1,8(sp)
    80000f1a:	e04a                	sd	s2,0(sp)
    80000f1c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1e:	00008917          	auipc	s2,0x8
    80000f22:	13290913          	addi	s2,s2,306 # 80009050 <pid_lock>
    80000f26:	854a                	mv	a0,s2
    80000f28:	00005097          	auipc	ra,0x5
    80000f2c:	228080e7          	jalr	552(ra) # 80006150 <acquire>
  pid = nextpid;
    80000f30:	00008797          	auipc	a5,0x8
    80000f34:	a8478793          	addi	a5,a5,-1404 # 800089b4 <nextpid>
    80000f38:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f3a:	0014871b          	addiw	a4,s1,1
    80000f3e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f40:	854a                	mv	a0,s2
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	2c2080e7          	jalr	706(ra) # 80006204 <release>
}
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	60e2                	ld	ra,24(sp)
    80000f4e:	6442                	ld	s0,16(sp)
    80000f50:	64a2                	ld	s1,8(sp)
    80000f52:	6902                	ld	s2,0(sp)
    80000f54:	6105                	addi	sp,sp,32
    80000f56:	8082                	ret

0000000080000f58 <proc_pagetable>:
{
    80000f58:	1101                	addi	sp,sp,-32
    80000f5a:	ec06                	sd	ra,24(sp)
    80000f5c:	e822                	sd	s0,16(sp)
    80000f5e:	e426                	sd	s1,8(sp)
    80000f60:	e04a                	sd	s2,0(sp)
    80000f62:	1000                	addi	s0,sp,32
    80000f64:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f66:	00000097          	auipc	ra,0x0
    80000f6a:	8b6080e7          	jalr	-1866(ra) # 8000081c <uvmcreate>
    80000f6e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f70:	c121                	beqz	a0,80000fb0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f72:	4729                	li	a4,10
    80000f74:	00006697          	auipc	a3,0x6
    80000f78:	08c68693          	addi	a3,a3,140 # 80007000 <_trampoline>
    80000f7c:	6605                	lui	a2,0x1
    80000f7e:	040005b7          	lui	a1,0x4000
    80000f82:	15fd                	addi	a1,a1,-1
    80000f84:	05b2                	slli	a1,a1,0xc
    80000f86:	fffff097          	auipc	ra,0xfffff
    80000f8a:	60c080e7          	jalr	1548(ra) # 80000592 <mappages>
    80000f8e:	02054863          	bltz	a0,80000fbe <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f92:	4719                	li	a4,6
    80000f94:	05893683          	ld	a3,88(s2)
    80000f98:	6605                	lui	a2,0x1
    80000f9a:	020005b7          	lui	a1,0x2000
    80000f9e:	15fd                	addi	a1,a1,-1
    80000fa0:	05b6                	slli	a1,a1,0xd
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	fffff097          	auipc	ra,0xfffff
    80000fa8:	5ee080e7          	jalr	1518(ra) # 80000592 <mappages>
    80000fac:	02054163          	bltz	a0,80000fce <proc_pagetable+0x76>
}
    80000fb0:	8526                	mv	a0,s1
    80000fb2:	60e2                	ld	ra,24(sp)
    80000fb4:	6442                	ld	s0,16(sp)
    80000fb6:	64a2                	ld	s1,8(sp)
    80000fb8:	6902                	ld	s2,0(sp)
    80000fba:	6105                	addi	sp,sp,32
    80000fbc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbe:	4581                	li	a1,0
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	00000097          	auipc	ra,0x0
    80000fc6:	a56080e7          	jalr	-1450(ra) # 80000a18 <uvmfree>
    return 0;
    80000fca:	4481                	li	s1,0
    80000fcc:	b7d5                	j	80000fb0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fce:	4681                	li	a3,0
    80000fd0:	4605                	li	a2,1
    80000fd2:	040005b7          	lui	a1,0x4000
    80000fd6:	15fd                	addi	a1,a1,-1
    80000fd8:	05b2                	slli	a1,a1,0xc
    80000fda:	8526                	mv	a0,s1
    80000fdc:	fffff097          	auipc	ra,0xfffff
    80000fe0:	77c080e7          	jalr	1916(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe4:	4581                	li	a1,0
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	00000097          	auipc	ra,0x0
    80000fec:	a30080e7          	jalr	-1488(ra) # 80000a18 <uvmfree>
    return 0;
    80000ff0:	4481                	li	s1,0
    80000ff2:	bf7d                	j	80000fb0 <proc_pagetable+0x58>

0000000080000ff4 <proc_freepagetable>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	e04a                	sd	s2,0(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
    80001002:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001004:	4681                	li	a3,0
    80001006:	4605                	li	a2,1
    80001008:	040005b7          	lui	a1,0x4000
    8000100c:	15fd                	addi	a1,a1,-1
    8000100e:	05b2                	slli	a1,a1,0xc
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	748080e7          	jalr	1864(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001018:	4681                	li	a3,0
    8000101a:	4605                	li	a2,1
    8000101c:	020005b7          	lui	a1,0x2000
    80001020:	15fd                	addi	a1,a1,-1
    80001022:	05b6                	slli	a1,a1,0xd
    80001024:	8526                	mv	a0,s1
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	732080e7          	jalr	1842(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102e:	85ca                	mv	a1,s2
    80001030:	8526                	mv	a0,s1
    80001032:	00000097          	auipc	ra,0x0
    80001036:	9e6080e7          	jalr	-1562(ra) # 80000a18 <uvmfree>
}
    8000103a:	60e2                	ld	ra,24(sp)
    8000103c:	6442                	ld	s0,16(sp)
    8000103e:	64a2                	ld	s1,8(sp)
    80001040:	6902                	ld	s2,0(sp)
    80001042:	6105                	addi	sp,sp,32
    80001044:	8082                	ret

0000000080001046 <freeproc>:
{
    80001046:	1101                	addi	sp,sp,-32
    80001048:	ec06                	sd	ra,24(sp)
    8000104a:	e822                	sd	s0,16(sp)
    8000104c:	e426                	sd	s1,8(sp)
    8000104e:	1000                	addi	s0,sp,32
    80001050:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001052:	6d28                	ld	a0,88(a0)
    80001054:	c509                	beqz	a0,8000105e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001062:	68a8                	ld	a0,80(s1)
    80001064:	c511                	beqz	a0,80001070 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001066:	64ac                	ld	a1,72(s1)
    80001068:	00000097          	auipc	ra,0x0
    8000106c:	f8c080e7          	jalr	-116(ra) # 80000ff4 <proc_freepagetable>
  p->pagetable = 0;
    80001070:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001074:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001078:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001080:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001084:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001088:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001090:	0004ac23          	sw	zero,24(s1)
}
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6105                	addi	sp,sp,32
    8000109c:	8082                	ret

000000008000109e <allocproc>:
{
    8000109e:	1101                	addi	sp,sp,-32
    800010a0:	ec06                	sd	ra,24(sp)
    800010a2:	e822                	sd	s0,16(sp)
    800010a4:	e426                	sd	s1,8(sp)
    800010a6:	e04a                	sd	s2,0(sp)
    800010a8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010aa:	00008497          	auipc	s1,0x8
    800010ae:	3d648493          	addi	s1,s1,982 # 80009480 <proc>
    800010b2:	0000e917          	auipc	s2,0xe
    800010b6:	dce90913          	addi	s2,s2,-562 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00005097          	auipc	ra,0x5
    800010c0:	094080e7          	jalr	148(ra) # 80006150 <acquire>
    if(p->state == UNUSED) {
    800010c4:	4c9c                	lw	a5,24(s1)
    800010c6:	cf81                	beqz	a5,800010de <allocproc+0x40>
      release(&p->lock);
    800010c8:	8526                	mv	a0,s1
    800010ca:	00005097          	auipc	ra,0x5
    800010ce:	13a080e7          	jalr	314(ra) # 80006204 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d2:	16848493          	addi	s1,s1,360
    800010d6:	ff2492e3          	bne	s1,s2,800010ba <allocproc+0x1c>
  return 0;
    800010da:	4481                	li	s1,0
    800010dc:	a889                	j	8000112e <allocproc+0x90>
  p->pid = allocpid();
    800010de:	00000097          	auipc	ra,0x0
    800010e2:	e34080e7          	jalr	-460(ra) # 80000f12 <allocpid>
    800010e6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e8:	4785                	li	a5,1
    800010ea:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	02c080e7          	jalr	44(ra) # 80000118 <kalloc>
    800010f4:	892a                	mv	s2,a0
    800010f6:	eca8                	sd	a0,88(s1)
    800010f8:	c131                	beqz	a0,8000113c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	e5c080e7          	jalr	-420(ra) # 80000f58 <proc_pagetable>
    80001104:	892a                	mv	s2,a0
    80001106:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001108:	c531                	beqz	a0,80001154 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000110a:	07000613          	li	a2,112
    8000110e:	4581                	li	a1,0
    80001110:	06048513          	addi	a0,s1,96
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	0b6080e7          	jalr	182(ra) # 800001ca <memset>
  p->context.ra = (uint64)forkret;
    8000111c:	00000797          	auipc	a5,0x0
    80001120:	db078793          	addi	a5,a5,-592 # 80000ecc <forkret>
    80001124:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001126:	60bc                	ld	a5,64(s1)
    80001128:	6705                	lui	a4,0x1
    8000112a:	97ba                	add	a5,a5,a4
    8000112c:	f4bc                	sd	a5,104(s1)
}
    8000112e:	8526                	mv	a0,s1
    80001130:	60e2                	ld	ra,24(sp)
    80001132:	6442                	ld	s0,16(sp)
    80001134:	64a2                	ld	s1,8(sp)
    80001136:	6902                	ld	s2,0(sp)
    80001138:	6105                	addi	sp,sp,32
    8000113a:	8082                	ret
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f08080e7          	jalr	-248(ra) # 80001046 <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	0bc080e7          	jalr	188(ra) # 80006204 <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	bff1                	j	8000112e <allocproc+0x90>
    freeproc(p);
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	ef0080e7          	jalr	-272(ra) # 80001046 <freeproc>
    release(&p->lock);
    8000115e:	8526                	mv	a0,s1
    80001160:	00005097          	auipc	ra,0x5
    80001164:	0a4080e7          	jalr	164(ra) # 80006204 <release>
    return 0;
    80001168:	84ca                	mv	s1,s2
    8000116a:	b7d1                	j	8000112e <allocproc+0x90>

000000008000116c <userinit>:
{
    8000116c:	1101                	addi	sp,sp,-32
    8000116e:	ec06                	sd	ra,24(sp)
    80001170:	e822                	sd	s0,16(sp)
    80001172:	e426                	sd	s1,8(sp)
    80001174:	1000                	addi	s0,sp,32
  p = allocproc();
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	f28080e7          	jalr	-216(ra) # 8000109e <allocproc>
    8000117e:	84aa                	mv	s1,a0
  initproc = p;
    80001180:	00008797          	auipc	a5,0x8
    80001184:	e8a7b823          	sd	a0,-368(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001188:	03400613          	li	a2,52
    8000118c:	00008597          	auipc	a1,0x8
    80001190:	83458593          	addi	a1,a1,-1996 # 800089c0 <initcode>
    80001194:	6928                	ld	a0,80(a0)
    80001196:	fffff097          	auipc	ra,0xfffff
    8000119a:	6b4080e7          	jalr	1716(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119e:	6785                	lui	a5,0x1
    800011a0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a2:	6cb8                	ld	a4,88(s1)
    800011a4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a8:	6cb8                	ld	a4,88(s1)
    800011aa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ac:	4641                	li	a2,16
    800011ae:	00007597          	auipc	a1,0x7
    800011b2:	fd258593          	addi	a1,a1,-46 # 80008180 <etext+0x180>
    800011b6:	15848513          	addi	a0,s1,344
    800011ba:	fffff097          	auipc	ra,0xfffff
    800011be:	15a080e7          	jalr	346(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c2:	00007517          	auipc	a0,0x7
    800011c6:	fce50513          	addi	a0,a0,-50 # 80008190 <etext+0x190>
    800011ca:	00002097          	auipc	ra,0x2
    800011ce:	190080e7          	jalr	400(ra) # 8000335a <namei>
    800011d2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d6:	478d                	li	a5,3
    800011d8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	00005097          	auipc	ra,0x5
    800011e0:	028080e7          	jalr	40(ra) # 80006204 <release>
}
    800011e4:	60e2                	ld	ra,24(sp)
    800011e6:	6442                	ld	s0,16(sp)
    800011e8:	64a2                	ld	s1,8(sp)
    800011ea:	6105                	addi	sp,sp,32
    800011ec:	8082                	ret

00000000800011ee <growproc>:
{
    800011ee:	1101                	addi	sp,sp,-32
    800011f0:	ec06                	sd	ra,24(sp)
    800011f2:	e822                	sd	s0,16(sp)
    800011f4:	e426                	sd	s1,8(sp)
    800011f6:	e04a                	sd	s2,0(sp)
    800011f8:	1000                	addi	s0,sp,32
    800011fa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	c98080e7          	jalr	-872(ra) # 80000e94 <myproc>
    80001204:	892a                	mv	s2,a0
  sz = p->sz;
    80001206:	652c                	ld	a1,72(a0)
    80001208:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120c:	00904f63          	bgtz	s1,8000122a <growproc+0x3c>
  } else if(n < 0){
    80001210:	0204cc63          	bltz	s1,80001248 <growproc+0x5a>
  p->sz = sz;
    80001214:	1602                	slli	a2,a2,0x20
    80001216:	9201                	srli	a2,a2,0x20
    80001218:	04c93423          	sd	a2,72(s2)
  return 0;
    8000121c:	4501                	li	a0,0
}
    8000121e:	60e2                	ld	ra,24(sp)
    80001220:	6442                	ld	s0,16(sp)
    80001222:	64a2                	ld	s1,8(sp)
    80001224:	6902                	ld	s2,0(sp)
    80001226:	6105                	addi	sp,sp,32
    80001228:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000122a:	9e25                	addw	a2,a2,s1
    8000122c:	1602                	slli	a2,a2,0x20
    8000122e:	9201                	srli	a2,a2,0x20
    80001230:	1582                	slli	a1,a1,0x20
    80001232:	9181                	srli	a1,a1,0x20
    80001234:	6928                	ld	a0,80(a0)
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	6ce080e7          	jalr	1742(ra) # 80000904 <uvmalloc>
    8000123e:	0005061b          	sext.w	a2,a0
    80001242:	fa69                	bnez	a2,80001214 <growproc+0x26>
      return -1;
    80001244:	557d                	li	a0,-1
    80001246:	bfe1                	j	8000121e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001248:	9e25                	addw	a2,a2,s1
    8000124a:	1602                	slli	a2,a2,0x20
    8000124c:	9201                	srli	a2,a2,0x20
    8000124e:	1582                	slli	a1,a1,0x20
    80001250:	9181                	srli	a1,a1,0x20
    80001252:	6928                	ld	a0,80(a0)
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	668080e7          	jalr	1640(ra) # 800008bc <uvmdealloc>
    8000125c:	0005061b          	sext.w	a2,a0
    80001260:	bf55                	j	80001214 <growproc+0x26>

0000000080001262 <fork>:
{
    80001262:	7139                	addi	sp,sp,-64
    80001264:	fc06                	sd	ra,56(sp)
    80001266:	f822                	sd	s0,48(sp)
    80001268:	f426                	sd	s1,40(sp)
    8000126a:	f04a                	sd	s2,32(sp)
    8000126c:	ec4e                	sd	s3,24(sp)
    8000126e:	e852                	sd	s4,16(sp)
    80001270:	e456                	sd	s5,8(sp)
    80001272:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001274:	00000097          	auipc	ra,0x0
    80001278:	c20080e7          	jalr	-992(ra) # 80000e94 <myproc>
    8000127c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	e20080e7          	jalr	-480(ra) # 8000109e <allocproc>
    80001286:	12050063          	beqz	a0,800013a6 <fork+0x144>
    8000128a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128c:	048ab603          	ld	a2,72(s5)
    80001290:	692c                	ld	a1,80(a0)
    80001292:	050ab503          	ld	a0,80(s5)
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	7ba080e7          	jalr	1978(ra) # 80000a50 <uvmcopy>
    8000129e:	04054863          	bltz	a0,800012ee <fork+0x8c>
  np->sz = p->sz;
    800012a2:	048ab783          	ld	a5,72(s5)
    800012a6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012aa:	058ab683          	ld	a3,88(s5)
    800012ae:	87b6                	mv	a5,a3
    800012b0:	0589b703          	ld	a4,88(s3)
    800012b4:	12068693          	addi	a3,a3,288
    800012b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012bc:	6788                	ld	a0,8(a5)
    800012be:	6b8c                	ld	a1,16(a5)
    800012c0:	6f90                	ld	a2,24(a5)
    800012c2:	01073023          	sd	a6,0(a4)
    800012c6:	e708                	sd	a0,8(a4)
    800012c8:	eb0c                	sd	a1,16(a4)
    800012ca:	ef10                	sd	a2,24(a4)
    800012cc:	02078793          	addi	a5,a5,32
    800012d0:	02070713          	addi	a4,a4,32
    800012d4:	fed792e3          	bne	a5,a3,800012b8 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d8:	0589b783          	ld	a5,88(s3)
    800012dc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e0:	0d0a8493          	addi	s1,s5,208
    800012e4:	0d098913          	addi	s2,s3,208
    800012e8:	150a8a13          	addi	s4,s5,336
    800012ec:	a00d                	j	8000130e <fork+0xac>
    freeproc(np);
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d56080e7          	jalr	-682(ra) # 80001046 <freeproc>
    release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	f0a080e7          	jalr	-246(ra) # 80006204 <release>
    return -1;
    80001302:	597d                	li	s2,-1
    80001304:	a079                	j	80001392 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	0921                	addi	s2,s2,8
    8000130a:	01448b63          	beq	s1,s4,80001320 <fork+0xbe>
    if(p->ofile[i])
    8000130e:	6088                	ld	a0,0(s1)
    80001310:	d97d                	beqz	a0,80001306 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001312:	00002097          	auipc	ra,0x2
    80001316:	6de080e7          	jalr	1758(ra) # 800039f0 <filedup>
    8000131a:	00a93023          	sd	a0,0(s2)
    8000131e:	b7e5                	j	80001306 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001320:	150ab503          	ld	a0,336(s5)
    80001324:	00002097          	auipc	ra,0x2
    80001328:	842080e7          	jalr	-1982(ra) # 80002b66 <idup>
    8000132c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	15898513          	addi	a0,s3,344
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	fda080e7          	jalr	-38(ra) # 80000314 <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001342:	034aa783          	lw	a5,52(s5)
    80001346:	02f9aa23          	sw	a5,52(s3)
  pid = np->pid;
    8000134a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000134e:	854e                	mv	a0,s3
    80001350:	00005097          	auipc	ra,0x5
    80001354:	eb4080e7          	jalr	-332(ra) # 80006204 <release>
  acquire(&wait_lock);
    80001358:	00008497          	auipc	s1,0x8
    8000135c:	d1048493          	addi	s1,s1,-752 # 80009068 <wait_lock>
    80001360:	8526                	mv	a0,s1
    80001362:	00005097          	auipc	ra,0x5
    80001366:	dee080e7          	jalr	-530(ra) # 80006150 <acquire>
  np->parent = p;
    8000136a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	00005097          	auipc	ra,0x5
    80001374:	e94080e7          	jalr	-364(ra) # 80006204 <release>
  acquire(&np->lock);
    80001378:	854e                	mv	a0,s3
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	dd6080e7          	jalr	-554(ra) # 80006150 <acquire>
  np->state = RUNNABLE;
    80001382:	478d                	li	a5,3
    80001384:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001388:	854e                	mv	a0,s3
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	e7a080e7          	jalr	-390(ra) # 80006204 <release>
}
    80001392:	854a                	mv	a0,s2
    80001394:	70e2                	ld	ra,56(sp)
    80001396:	7442                	ld	s0,48(sp)
    80001398:	74a2                	ld	s1,40(sp)
    8000139a:	7902                	ld	s2,32(sp)
    8000139c:	69e2                	ld	s3,24(sp)
    8000139e:	6a42                	ld	s4,16(sp)
    800013a0:	6aa2                	ld	s5,8(sp)
    800013a2:	6121                	addi	sp,sp,64
    800013a4:	8082                	ret
    return -1;
    800013a6:	597d                	li	s2,-1
    800013a8:	b7ed                	j	80001392 <fork+0x130>

00000000800013aa <scheduler>:
{
    800013aa:	7139                	addi	sp,sp,-64
    800013ac:	fc06                	sd	ra,56(sp)
    800013ae:	f822                	sd	s0,48(sp)
    800013b0:	f426                	sd	s1,40(sp)
    800013b2:	f04a                	sd	s2,32(sp)
    800013b4:	ec4e                	sd	s3,24(sp)
    800013b6:	e852                	sd	s4,16(sp)
    800013b8:	e456                	sd	s5,8(sp)
    800013ba:	e05a                	sd	s6,0(sp)
    800013bc:	0080                	addi	s0,sp,64
    800013be:	8792                	mv	a5,tp
  int id = r_tp();
    800013c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c2:	00779a93          	slli	s5,a5,0x7
    800013c6:	00008717          	auipc	a4,0x8
    800013ca:	c8a70713          	addi	a4,a4,-886 # 80009050 <pid_lock>
    800013ce:	9756                	add	a4,a4,s5
    800013d0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d4:	00008717          	auipc	a4,0x8
    800013d8:	cb470713          	addi	a4,a4,-844 # 80009088 <cpus+0x8>
    800013dc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013de:	498d                	li	s3,3
        p->state = RUNNING;
    800013e0:	4b11                	li	s6,4
        c->proc = p;
    800013e2:	079e                	slli	a5,a5,0x7
    800013e4:	00008a17          	auipc	s4,0x8
    800013e8:	c6ca0a13          	addi	s4,s4,-916 # 80009050 <pid_lock>
    800013ec:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	0000e917          	auipc	s2,0xe
    800013f2:	a9290913          	addi	s2,s2,-1390 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fe:	10079073          	csrw	sstatus,a5
    80001402:	00008497          	auipc	s1,0x8
    80001406:	07e48493          	addi	s1,s1,126 # 80009480 <proc>
    8000140a:	a811                	j	8000141e <scheduler+0x74>
      release(&p->lock);
    8000140c:	8526                	mv	a0,s1
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	df6080e7          	jalr	-522(ra) # 80006204 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	16848493          	addi	s1,s1,360
    8000141a:	fd248ee3          	beq	s1,s2,800013f6 <scheduler+0x4c>
      acquire(&p->lock);
    8000141e:	8526                	mv	a0,s1
    80001420:	00005097          	auipc	ra,0x5
    80001424:	d30080e7          	jalr	-720(ra) # 80006150 <acquire>
      if(p->state == RUNNABLE) {
    80001428:	4c9c                	lw	a5,24(s1)
    8000142a:	ff3791e3          	bne	a5,s3,8000140c <scheduler+0x62>
        p->state = RUNNING;
    8000142e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001432:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001436:	06048593          	addi	a1,s1,96
    8000143a:	8556                	mv	a0,s5
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	654080e7          	jalr	1620(ra) # 80001a90 <swtch>
        c->proc = 0;
    80001444:	020a3823          	sd	zero,48(s4)
    80001448:	b7d1                	j	8000140c <scheduler+0x62>

000000008000144a <sched>:
{
    8000144a:	7179                	addi	sp,sp,-48
    8000144c:	f406                	sd	ra,40(sp)
    8000144e:	f022                	sd	s0,32(sp)
    80001450:	ec26                	sd	s1,24(sp)
    80001452:	e84a                	sd	s2,16(sp)
    80001454:	e44e                	sd	s3,8(sp)
    80001456:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	a3c080e7          	jalr	-1476(ra) # 80000e94 <myproc>
    80001460:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001462:	00005097          	auipc	ra,0x5
    80001466:	c74080e7          	jalr	-908(ra) # 800060d6 <holding>
    8000146a:	c93d                	beqz	a0,800014e0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	00008717          	auipc	a4,0x8
    80001476:	bde70713          	addi	a4,a4,-1058 # 80009050 <pid_lock>
    8000147a:	97ba                	add	a5,a5,a4
    8000147c:	0a87a703          	lw	a4,168(a5)
    80001480:	4785                	li	a5,1
    80001482:	06f71763          	bne	a4,a5,800014f0 <sched+0xa6>
  if(p->state == RUNNING)
    80001486:	4c98                	lw	a4,24(s1)
    80001488:	4791                	li	a5,4
    8000148a:	06f70b63          	beq	a4,a5,80001500 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001492:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001494:	efb5                	bnez	a5,80001510 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001496:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001498:	00008917          	auipc	s2,0x8
    8000149c:	bb890913          	addi	s2,s2,-1096 # 80009050 <pid_lock>
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	97ca                	add	a5,a5,s2
    800014a6:	0ac7a983          	lw	s3,172(a5)
    800014aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	00008597          	auipc	a1,0x8
    800014b4:	bd858593          	addi	a1,a1,-1064 # 80009088 <cpus+0x8>
    800014b8:	95be                	add	a1,a1,a5
    800014ba:	06048513          	addi	a0,s1,96
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	5d2080e7          	jalr	1490(ra) # 80001a90 <swtch>
    800014c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0b37a623          	sw	s3,172(a5)
}
    800014d2:	70a2                	ld	ra,40(sp)
    800014d4:	7402                	ld	s0,32(sp)
    800014d6:	64e2                	ld	s1,24(sp)
    800014d8:	6942                	ld	s2,16(sp)
    800014da:	69a2                	ld	s3,8(sp)
    800014dc:	6145                	addi	sp,sp,48
    800014de:	8082                	ret
    panic("sched p->lock");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	cb850513          	addi	a0,a0,-840 # 80008198 <etext+0x198>
    800014e8:	00004097          	auipc	ra,0x4
    800014ec:	72c080e7          	jalr	1836(ra) # 80005c14 <panic>
    panic("sched locks");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	cb850513          	addi	a0,a0,-840 # 800081a8 <etext+0x1a8>
    800014f8:	00004097          	auipc	ra,0x4
    800014fc:	71c080e7          	jalr	1820(ra) # 80005c14 <panic>
    panic("sched running");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	cb850513          	addi	a0,a0,-840 # 800081b8 <etext+0x1b8>
    80001508:	00004097          	auipc	ra,0x4
    8000150c:	70c080e7          	jalr	1804(ra) # 80005c14 <panic>
    panic("sched interruptible");
    80001510:	00007517          	auipc	a0,0x7
    80001514:	cb850513          	addi	a0,a0,-840 # 800081c8 <etext+0x1c8>
    80001518:	00004097          	auipc	ra,0x4
    8000151c:	6fc080e7          	jalr	1788(ra) # 80005c14 <panic>

0000000080001520 <yield>:
{
    80001520:	1101                	addi	sp,sp,-32
    80001522:	ec06                	sd	ra,24(sp)
    80001524:	e822                	sd	s0,16(sp)
    80001526:	e426                	sd	s1,8(sp)
    80001528:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	96a080e7          	jalr	-1686(ra) # 80000e94 <myproc>
    80001532:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001534:	00005097          	auipc	ra,0x5
    80001538:	c1c080e7          	jalr	-996(ra) # 80006150 <acquire>
  p->state = RUNNABLE;
    8000153c:	478d                	li	a5,3
    8000153e:	cc9c                	sw	a5,24(s1)
  sched();
    80001540:	00000097          	auipc	ra,0x0
    80001544:	f0a080e7          	jalr	-246(ra) # 8000144a <sched>
  release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	cba080e7          	jalr	-838(ra) # 80006204 <release>
}
    80001552:	60e2                	ld	ra,24(sp)
    80001554:	6442                	ld	s0,16(sp)
    80001556:	64a2                	ld	s1,8(sp)
    80001558:	6105                	addi	sp,sp,32
    8000155a:	8082                	ret

000000008000155c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155c:	7179                	addi	sp,sp,-48
    8000155e:	f406                	sd	ra,40(sp)
    80001560:	f022                	sd	s0,32(sp)
    80001562:	ec26                	sd	s1,24(sp)
    80001564:	e84a                	sd	s2,16(sp)
    80001566:	e44e                	sd	s3,8(sp)
    80001568:	1800                	addi	s0,sp,48
    8000156a:	89aa                	mv	s3,a0
    8000156c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	926080e7          	jalr	-1754(ra) # 80000e94 <myproc>
    80001576:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	bd8080e7          	jalr	-1064(ra) # 80006150 <acquire>
  release(lk);
    80001580:	854a                	mv	a0,s2
    80001582:	00005097          	auipc	ra,0x5
    80001586:	c82080e7          	jalr	-894(ra) # 80006204 <release>

  // Go to sleep.
  p->chan = chan;
    8000158a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158e:	4789                	li	a5,2
    80001590:	cc9c                	sw	a5,24(s1)

  sched();
    80001592:	00000097          	auipc	ra,0x0
    80001596:	eb8080e7          	jalr	-328(ra) # 8000144a <sched>

  // Tidy up.
  p->chan = 0;
    8000159a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159e:	8526                	mv	a0,s1
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	c64080e7          	jalr	-924(ra) # 80006204 <release>
  acquire(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	ba6080e7          	jalr	-1114(ra) # 80006150 <acquire>
}
    800015b2:	70a2                	ld	ra,40(sp)
    800015b4:	7402                	ld	s0,32(sp)
    800015b6:	64e2                	ld	s1,24(sp)
    800015b8:	6942                	ld	s2,16(sp)
    800015ba:	69a2                	ld	s3,8(sp)
    800015bc:	6145                	addi	sp,sp,48
    800015be:	8082                	ret

00000000800015c0 <wait>:
{
    800015c0:	715d                	addi	sp,sp,-80
    800015c2:	e486                	sd	ra,72(sp)
    800015c4:	e0a2                	sd	s0,64(sp)
    800015c6:	fc26                	sd	s1,56(sp)
    800015c8:	f84a                	sd	s2,48(sp)
    800015ca:	f44e                	sd	s3,40(sp)
    800015cc:	f052                	sd	s4,32(sp)
    800015ce:	ec56                	sd	s5,24(sp)
    800015d0:	e85a                	sd	s6,16(sp)
    800015d2:	e45e                	sd	s7,8(sp)
    800015d4:	e062                	sd	s8,0(sp)
    800015d6:	0880                	addi	s0,sp,80
    800015d8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015da:	00000097          	auipc	ra,0x0
    800015de:	8ba080e7          	jalr	-1862(ra) # 80000e94 <myproc>
    800015e2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e4:	00008517          	auipc	a0,0x8
    800015e8:	a8450513          	addi	a0,a0,-1404 # 80009068 <wait_lock>
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	b64080e7          	jalr	-1180(ra) # 80006150 <acquire>
    havekids = 0;
    800015f4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f6:	4a15                	li	s4,5
        havekids = 1;
    800015f8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015fa:	0000e997          	auipc	s3,0xe
    800015fe:	88698993          	addi	s3,s3,-1914 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001602:	00008c17          	auipc	s8,0x8
    80001606:	a66c0c13          	addi	s8,s8,-1434 # 80009068 <wait_lock>
    havekids = 0;
    8000160a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160c:	00008497          	auipc	s1,0x8
    80001610:	e7448493          	addi	s1,s1,-396 # 80009480 <proc>
    80001614:	a0bd                	j	80001682 <wait+0xc2>
          pid = np->pid;
    80001616:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161a:	000b0e63          	beqz	s6,80001636 <wait+0x76>
    8000161e:	4691                	li	a3,4
    80001620:	02c48613          	addi	a2,s1,44
    80001624:	85da                	mv	a1,s6
    80001626:	05093503          	ld	a0,80(s2)
    8000162a:	fffff097          	auipc	ra,0xfffff
    8000162e:	52a080e7          	jalr	1322(ra) # 80000b54 <copyout>
    80001632:	02054563          	bltz	a0,8000165c <wait+0x9c>
          freeproc(np);
    80001636:	8526                	mv	a0,s1
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	a0e080e7          	jalr	-1522(ra) # 80001046 <freeproc>
          release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	bc2080e7          	jalr	-1086(ra) # 80006204 <release>
          release(&wait_lock);
    8000164a:	00008517          	auipc	a0,0x8
    8000164e:	a1e50513          	addi	a0,a0,-1506 # 80009068 <wait_lock>
    80001652:	00005097          	auipc	ra,0x5
    80001656:	bb2080e7          	jalr	-1102(ra) # 80006204 <release>
          return pid;
    8000165a:	a09d                	j	800016c0 <wait+0x100>
            release(&np->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	ba6080e7          	jalr	-1114(ra) # 80006204 <release>
            release(&wait_lock);
    80001666:	00008517          	auipc	a0,0x8
    8000166a:	a0250513          	addi	a0,a0,-1534 # 80009068 <wait_lock>
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	b96080e7          	jalr	-1130(ra) # 80006204 <release>
            return -1;
    80001676:	59fd                	li	s3,-1
    80001678:	a0a1                	j	800016c0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167a:	16848493          	addi	s1,s1,360
    8000167e:	03348463          	beq	s1,s3,800016a6 <wait+0xe6>
      if(np->parent == p){
    80001682:	7c9c                	ld	a5,56(s1)
    80001684:	ff279be3          	bne	a5,s2,8000167a <wait+0xba>
        acquire(&np->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	ac6080e7          	jalr	-1338(ra) # 80006150 <acquire>
        if(np->state == ZOMBIE){
    80001692:	4c9c                	lw	a5,24(s1)
    80001694:	f94781e3          	beq	a5,s4,80001616 <wait+0x56>
        release(&np->lock);
    80001698:	8526                	mv	a0,s1
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	b6a080e7          	jalr	-1174(ra) # 80006204 <release>
        havekids = 1;
    800016a2:	8756                	mv	a4,s5
    800016a4:	bfd9                	j	8000167a <wait+0xba>
    if(!havekids || p->killed){
    800016a6:	c701                	beqz	a4,800016ae <wait+0xee>
    800016a8:	02892783          	lw	a5,40(s2)
    800016ac:	c79d                	beqz	a5,800016da <wait+0x11a>
      release(&wait_lock);
    800016ae:	00008517          	auipc	a0,0x8
    800016b2:	9ba50513          	addi	a0,a0,-1606 # 80009068 <wait_lock>
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	b4e080e7          	jalr	-1202(ra) # 80006204 <release>
      return -1;
    800016be:	59fd                	li	s3,-1
}
    800016c0:	854e                	mv	a0,s3
    800016c2:	60a6                	ld	ra,72(sp)
    800016c4:	6406                	ld	s0,64(sp)
    800016c6:	74e2                	ld	s1,56(sp)
    800016c8:	7942                	ld	s2,48(sp)
    800016ca:	79a2                	ld	s3,40(sp)
    800016cc:	7a02                	ld	s4,32(sp)
    800016ce:	6ae2                	ld	s5,24(sp)
    800016d0:	6b42                	ld	s6,16(sp)
    800016d2:	6ba2                	ld	s7,8(sp)
    800016d4:	6c02                	ld	s8,0(sp)
    800016d6:	6161                	addi	sp,sp,80
    800016d8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016da:	85e2                	mv	a1,s8
    800016dc:	854a                	mv	a0,s2
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	e7e080e7          	jalr	-386(ra) # 8000155c <sleep>
    havekids = 0;
    800016e6:	b715                	j	8000160a <wait+0x4a>

00000000800016e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e8:	7139                	addi	sp,sp,-64
    800016ea:	fc06                	sd	ra,56(sp)
    800016ec:	f822                	sd	s0,48(sp)
    800016ee:	f426                	sd	s1,40(sp)
    800016f0:	f04a                	sd	s2,32(sp)
    800016f2:	ec4e                	sd	s3,24(sp)
    800016f4:	e852                	sd	s4,16(sp)
    800016f6:	e456                	sd	s5,8(sp)
    800016f8:	0080                	addi	s0,sp,64
    800016fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fc:	00008497          	auipc	s1,0x8
    80001700:	d8448493          	addi	s1,s1,-636 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001704:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001706:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001708:	0000d917          	auipc	s2,0xd
    8000170c:	77890913          	addi	s2,s2,1912 # 8000ee80 <tickslock>
    80001710:	a811                	j	80001724 <wakeup+0x3c>
      }
      release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	af0080e7          	jalr	-1296(ra) # 80006204 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171c:	16848493          	addi	s1,s1,360
    80001720:	03248663          	beq	s1,s2,8000174c <wakeup+0x64>
    if(p != myproc()){
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	770080e7          	jalr	1904(ra) # 80000e94 <myproc>
    8000172c:	fea488e3          	beq	s1,a0,8000171c <wakeup+0x34>
      acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	a1e080e7          	jalr	-1506(ra) # 80006150 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000173a:	4c9c                	lw	a5,24(s1)
    8000173c:	fd379be3          	bne	a5,s3,80001712 <wakeup+0x2a>
    80001740:	709c                	ld	a5,32(s1)
    80001742:	fd4798e3          	bne	a5,s4,80001712 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001746:	0154ac23          	sw	s5,24(s1)
    8000174a:	b7e1                	j	80001712 <wakeup+0x2a>
    }
  }
}
    8000174c:	70e2                	ld	ra,56(sp)
    8000174e:	7442                	ld	s0,48(sp)
    80001750:	74a2                	ld	s1,40(sp)
    80001752:	7902                	ld	s2,32(sp)
    80001754:	69e2                	ld	s3,24(sp)
    80001756:	6a42                	ld	s4,16(sp)
    80001758:	6aa2                	ld	s5,8(sp)
    8000175a:	6121                	addi	sp,sp,64
    8000175c:	8082                	ret

000000008000175e <reparent>:
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	e052                	sd	s4,0(sp)
    8000176c:	1800                	addi	s0,sp,48
    8000176e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001770:	00008497          	auipc	s1,0x8
    80001774:	d1048493          	addi	s1,s1,-752 # 80009480 <proc>
      pp->parent = initproc;
    80001778:	00008a17          	auipc	s4,0x8
    8000177c:	898a0a13          	addi	s4,s4,-1896 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001780:	0000d997          	auipc	s3,0xd
    80001784:	70098993          	addi	s3,s3,1792 # 8000ee80 <tickslock>
    80001788:	a029                	j	80001792 <reparent+0x34>
    8000178a:	16848493          	addi	s1,s1,360
    8000178e:	01348d63          	beq	s1,s3,800017a8 <reparent+0x4a>
    if(pp->parent == p){
    80001792:	7c9c                	ld	a5,56(s1)
    80001794:	ff279be3          	bne	a5,s2,8000178a <reparent+0x2c>
      pp->parent = initproc;
    80001798:	000a3503          	ld	a0,0(s4)
    8000179c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	f4a080e7          	jalr	-182(ra) # 800016e8 <wakeup>
    800017a6:	b7d5                	j	8000178a <reparent+0x2c>
}
    800017a8:	70a2                	ld	ra,40(sp)
    800017aa:	7402                	ld	s0,32(sp)
    800017ac:	64e2                	ld	s1,24(sp)
    800017ae:	6942                	ld	s2,16(sp)
    800017b0:	69a2                	ld	s3,8(sp)
    800017b2:	6a02                	ld	s4,0(sp)
    800017b4:	6145                	addi	sp,sp,48
    800017b6:	8082                	ret

00000000800017b8 <exit>:
{
    800017b8:	7179                	addi	sp,sp,-48
    800017ba:	f406                	sd	ra,40(sp)
    800017bc:	f022                	sd	s0,32(sp)
    800017be:	ec26                	sd	s1,24(sp)
    800017c0:	e84a                	sd	s2,16(sp)
    800017c2:	e44e                	sd	s3,8(sp)
    800017c4:	e052                	sd	s4,0(sp)
    800017c6:	1800                	addi	s0,sp,48
    800017c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ca:	fffff097          	auipc	ra,0xfffff
    800017ce:	6ca080e7          	jalr	1738(ra) # 80000e94 <myproc>
    800017d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d4:	00008797          	auipc	a5,0x8
    800017d8:	83c7b783          	ld	a5,-1988(a5) # 80009010 <initproc>
    800017dc:	0d050493          	addi	s1,a0,208
    800017e0:	15050913          	addi	s2,a0,336
    800017e4:	02a79363          	bne	a5,a0,8000180a <exit+0x52>
    panic("init exiting");
    800017e8:	00007517          	auipc	a0,0x7
    800017ec:	9f850513          	addi	a0,a0,-1544 # 800081e0 <etext+0x1e0>
    800017f0:	00004097          	auipc	ra,0x4
    800017f4:	424080e7          	jalr	1060(ra) # 80005c14 <panic>
      fileclose(f);
    800017f8:	00002097          	auipc	ra,0x2
    800017fc:	24a080e7          	jalr	586(ra) # 80003a42 <fileclose>
      p->ofile[fd] = 0;
    80001800:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001804:	04a1                	addi	s1,s1,8
    80001806:	01248563          	beq	s1,s2,80001810 <exit+0x58>
    if(p->ofile[fd]){
    8000180a:	6088                	ld	a0,0(s1)
    8000180c:	f575                	bnez	a0,800017f8 <exit+0x40>
    8000180e:	bfdd                	j	80001804 <exit+0x4c>
  begin_op();
    80001810:	00002097          	auipc	ra,0x2
    80001814:	d66080e7          	jalr	-666(ra) # 80003576 <begin_op>
  iput(p->cwd);
    80001818:	1509b503          	ld	a0,336(s3)
    8000181c:	00001097          	auipc	ra,0x1
    80001820:	542080e7          	jalr	1346(ra) # 80002d5e <iput>
  end_op();
    80001824:	00002097          	auipc	ra,0x2
    80001828:	dd2080e7          	jalr	-558(ra) # 800035f6 <end_op>
  p->cwd = 0;
    8000182c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001830:	00008497          	auipc	s1,0x8
    80001834:	83848493          	addi	s1,s1,-1992 # 80009068 <wait_lock>
    80001838:	8526                	mv	a0,s1
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	916080e7          	jalr	-1770(ra) # 80006150 <acquire>
  reparent(p);
    80001842:	854e                	mv	a0,s3
    80001844:	00000097          	auipc	ra,0x0
    80001848:	f1a080e7          	jalr	-230(ra) # 8000175e <reparent>
  wakeup(p->parent);
    8000184c:	0389b503          	ld	a0,56(s3)
    80001850:	00000097          	auipc	ra,0x0
    80001854:	e98080e7          	jalr	-360(ra) # 800016e8 <wakeup>
  acquire(&p->lock);
    80001858:	854e                	mv	a0,s3
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	8f6080e7          	jalr	-1802(ra) # 80006150 <acquire>
  p->xstate = status;
    80001862:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001866:	4795                	li	a5,5
    80001868:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186c:	8526                	mv	a0,s1
    8000186e:	00005097          	auipc	ra,0x5
    80001872:	996080e7          	jalr	-1642(ra) # 80006204 <release>
  sched();
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	bd4080e7          	jalr	-1068(ra) # 8000144a <sched>
  panic("zombie exit");
    8000187e:	00007517          	auipc	a0,0x7
    80001882:	97250513          	addi	a0,a0,-1678 # 800081f0 <etext+0x1f0>
    80001886:	00004097          	auipc	ra,0x4
    8000188a:	38e080e7          	jalr	910(ra) # 80005c14 <panic>

000000008000188e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188e:	7179                	addi	sp,sp,-48
    80001890:	f406                	sd	ra,40(sp)
    80001892:	f022                	sd	s0,32(sp)
    80001894:	ec26                	sd	s1,24(sp)
    80001896:	e84a                	sd	s2,16(sp)
    80001898:	e44e                	sd	s3,8(sp)
    8000189a:	1800                	addi	s0,sp,48
    8000189c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189e:	00008497          	auipc	s1,0x8
    800018a2:	be248493          	addi	s1,s1,-1054 # 80009480 <proc>
    800018a6:	0000d997          	auipc	s3,0xd
    800018aa:	5da98993          	addi	s3,s3,1498 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	8a0080e7          	jalr	-1888(ra) # 80006150 <acquire>
    if(p->pid == pid){
    800018b8:	589c                	lw	a5,48(s1)
    800018ba:	01278d63          	beq	a5,s2,800018d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	944080e7          	jalr	-1724(ra) # 80006204 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c8:	16848493          	addi	s1,s1,360
    800018cc:	ff3491e3          	bne	s1,s3,800018ae <kill+0x20>
  }
  return -1;
    800018d0:	557d                	li	a0,-1
    800018d2:	a829                	j	800018ec <kill+0x5e>
      p->killed = 1;
    800018d4:	4785                	li	a5,1
    800018d6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d8:	4c98                	lw	a4,24(s1)
    800018da:	4789                	li	a5,2
    800018dc:	00f70f63          	beq	a4,a5,800018fa <kill+0x6c>
      release(&p->lock);
    800018e0:	8526                	mv	a0,s1
    800018e2:	00005097          	auipc	ra,0x5
    800018e6:	922080e7          	jalr	-1758(ra) # 80006204 <release>
      return 0;
    800018ea:	4501                	li	a0,0
}
    800018ec:	70a2                	ld	ra,40(sp)
    800018ee:	7402                	ld	s0,32(sp)
    800018f0:	64e2                	ld	s1,24(sp)
    800018f2:	6942                	ld	s2,16(sp)
    800018f4:	69a2                	ld	s3,8(sp)
    800018f6:	6145                	addi	sp,sp,48
    800018f8:	8082                	ret
        p->state = RUNNABLE;
    800018fa:	478d                	li	a5,3
    800018fc:	cc9c                	sw	a5,24(s1)
    800018fe:	b7cd                	j	800018e0 <kill+0x52>

0000000080001900 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001900:	7179                	addi	sp,sp,-48
    80001902:	f406                	sd	ra,40(sp)
    80001904:	f022                	sd	s0,32(sp)
    80001906:	ec26                	sd	s1,24(sp)
    80001908:	e84a                	sd	s2,16(sp)
    8000190a:	e44e                	sd	s3,8(sp)
    8000190c:	e052                	sd	s4,0(sp)
    8000190e:	1800                	addi	s0,sp,48
    80001910:	84aa                	mv	s1,a0
    80001912:	892e                	mv	s2,a1
    80001914:	89b2                	mv	s3,a2
    80001916:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	57c080e7          	jalr	1404(ra) # 80000e94 <myproc>
  if(user_dst){
    80001920:	c08d                	beqz	s1,80001942 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001922:	86d2                	mv	a3,s4
    80001924:	864e                	mv	a2,s3
    80001926:	85ca                	mv	a1,s2
    80001928:	6928                	ld	a0,80(a0)
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	22a080e7          	jalr	554(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001932:	70a2                	ld	ra,40(sp)
    80001934:	7402                	ld	s0,32(sp)
    80001936:	64e2                	ld	s1,24(sp)
    80001938:	6942                	ld	s2,16(sp)
    8000193a:	69a2                	ld	s3,8(sp)
    8000193c:	6a02                	ld	s4,0(sp)
    8000193e:	6145                	addi	sp,sp,48
    80001940:	8082                	ret
    memmove((char *)dst, src, len);
    80001942:	000a061b          	sext.w	a2,s4
    80001946:	85ce                	mv	a1,s3
    80001948:	854a                	mv	a0,s2
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	8dc080e7          	jalr	-1828(ra) # 80000226 <memmove>
    return 0;
    80001952:	8526                	mv	a0,s1
    80001954:	bff9                	j	80001932 <either_copyout+0x32>

0000000080001956 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001956:	7179                	addi	sp,sp,-48
    80001958:	f406                	sd	ra,40(sp)
    8000195a:	f022                	sd	s0,32(sp)
    8000195c:	ec26                	sd	s1,24(sp)
    8000195e:	e84a                	sd	s2,16(sp)
    80001960:	e44e                	sd	s3,8(sp)
    80001962:	e052                	sd	s4,0(sp)
    80001964:	1800                	addi	s0,sp,48
    80001966:	892a                	mv	s2,a0
    80001968:	84ae                	mv	s1,a1
    8000196a:	89b2                	mv	s3,a2
    8000196c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	526080e7          	jalr	1318(ra) # 80000e94 <myproc>
  if(user_src){
    80001976:	c08d                	beqz	s1,80001998 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001978:	86d2                	mv	a3,s4
    8000197a:	864e                	mv	a2,s3
    8000197c:	85ca                	mv	a1,s2
    8000197e:	6928                	ld	a0,80(a0)
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	260080e7          	jalr	608(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001988:	70a2                	ld	ra,40(sp)
    8000198a:	7402                	ld	s0,32(sp)
    8000198c:	64e2                	ld	s1,24(sp)
    8000198e:	6942                	ld	s2,16(sp)
    80001990:	69a2                	ld	s3,8(sp)
    80001992:	6a02                	ld	s4,0(sp)
    80001994:	6145                	addi	sp,sp,48
    80001996:	8082                	ret
    memmove(dst, (char*)src, len);
    80001998:	000a061b          	sext.w	a2,s4
    8000199c:	85ce                	mv	a1,s3
    8000199e:	854a                	mv	a0,s2
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	886080e7          	jalr	-1914(ra) # 80000226 <memmove>
    return 0;
    800019a8:	8526                	mv	a0,s1
    800019aa:	bff9                	j	80001988 <either_copyin+0x32>

00000000800019ac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ac:	715d                	addi	sp,sp,-80
    800019ae:	e486                	sd	ra,72(sp)
    800019b0:	e0a2                	sd	s0,64(sp)
    800019b2:	fc26                	sd	s1,56(sp)
    800019b4:	f84a                	sd	s2,48(sp)
    800019b6:	f44e                	sd	s3,40(sp)
    800019b8:	f052                	sd	s4,32(sp)
    800019ba:	ec56                	sd	s5,24(sp)
    800019bc:	e85a                	sd	s6,16(sp)
    800019be:	e45e                	sd	s7,8(sp)
    800019c0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c2:	00006517          	auipc	a0,0x6
    800019c6:	68650513          	addi	a0,a0,1670 # 80008048 <etext+0x48>
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	294080e7          	jalr	660(ra) # 80005c5e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	00008497          	auipc	s1,0x8
    800019d6:	c0648493          	addi	s1,s1,-1018 # 800095d8 <proc+0x158>
    800019da:	0000d917          	auipc	s2,0xd
    800019de:	5fe90913          	addi	s2,s2,1534 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e4:	00007997          	auipc	s3,0x7
    800019e8:	81c98993          	addi	s3,s3,-2020 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ec:	00007a97          	auipc	s5,0x7
    800019f0:	81ca8a93          	addi	s5,s5,-2020 # 80008208 <etext+0x208>
    printf("\n");
    800019f4:	00006a17          	auipc	s4,0x6
    800019f8:	654a0a13          	addi	s4,s4,1620 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fc:	00007b97          	auipc	s7,0x7
    80001a00:	844b8b93          	addi	s7,s7,-1980 # 80008240 <states.0>
    80001a04:	a00d                	j	80001a26 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a06:	ed86a583          	lw	a1,-296(a3)
    80001a0a:	8556                	mv	a0,s5
    80001a0c:	00004097          	auipc	ra,0x4
    80001a10:	252080e7          	jalr	594(ra) # 80005c5e <printf>
    printf("\n");
    80001a14:	8552                	mv	a0,s4
    80001a16:	00004097          	auipc	ra,0x4
    80001a1a:	248080e7          	jalr	584(ra) # 80005c5e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1e:	16848493          	addi	s1,s1,360
    80001a22:	03248163          	beq	s1,s2,80001a44 <procdump+0x98>
    if(p->state == UNUSED)
    80001a26:	86a6                	mv	a3,s1
    80001a28:	ec04a783          	lw	a5,-320(s1)
    80001a2c:	dbed                	beqz	a5,80001a1e <procdump+0x72>
      state = "???";
    80001a2e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a30:	fcfb6be3          	bltu	s6,a5,80001a06 <procdump+0x5a>
    80001a34:	1782                	slli	a5,a5,0x20
    80001a36:	9381                	srli	a5,a5,0x20
    80001a38:	078e                	slli	a5,a5,0x3
    80001a3a:	97de                	add	a5,a5,s7
    80001a3c:	6390                	ld	a2,0(a5)
    80001a3e:	f661                	bnez	a2,80001a06 <procdump+0x5a>
      state = "???";
    80001a40:	864e                	mv	a2,s3
    80001a42:	b7d1                	j	80001a06 <procdump+0x5a>
  }
}
    80001a44:	60a6                	ld	ra,72(sp)
    80001a46:	6406                	ld	s0,64(sp)
    80001a48:	74e2                	ld	s1,56(sp)
    80001a4a:	7942                	ld	s2,48(sp)
    80001a4c:	79a2                	ld	s3,40(sp)
    80001a4e:	7a02                	ld	s4,32(sp)
    80001a50:	6ae2                	ld	s5,24(sp)
    80001a52:	6b42                	ld	s6,16(sp)
    80001a54:	6ba2                	ld	s7,8(sp)
    80001a56:	6161                	addi	sp,sp,80
    80001a58:	8082                	ret

0000000080001a5a <procnum>:

void
procnum(uint64* dst)
{
    80001a5a:	1141                	addi	sp,sp,-16
    80001a5c:	e422                	sd	s0,8(sp)
    80001a5e:	0800                	addi	s0,sp,16
  *dst = 0;
    80001a60:	00053023          	sd	zero,0(a0)
  struct proc* p;
  // 不需要锁进程 proc 结构，因为我们只需要读取进程列表，不需要写
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a64:	00008797          	auipc	a5,0x8
    80001a68:	a1c78793          	addi	a5,a5,-1508 # 80009480 <proc>
    80001a6c:	0000d697          	auipc	a3,0xd
    80001a70:	41468693          	addi	a3,a3,1044 # 8000ee80 <tickslock>
    80001a74:	a029                	j	80001a7e <procnum+0x24>
    80001a76:	16878793          	addi	a5,a5,360
    80001a7a:	00d78863          	beq	a5,a3,80001a8a <procnum+0x30>
    // 不是 UNUSED 的进程位，就是已经分配的
    if (p->state != UNUSED)
    80001a7e:	4f98                	lw	a4,24(a5)
    80001a80:	db7d                	beqz	a4,80001a76 <procnum+0x1c>
      (*dst)++;
    80001a82:	6118                	ld	a4,0(a0)
    80001a84:	0705                	addi	a4,a4,1
    80001a86:	e118                	sd	a4,0(a0)
    80001a88:	b7fd                	j	80001a76 <procnum+0x1c>
  }
}
    80001a8a:	6422                	ld	s0,8(sp)
    80001a8c:	0141                	addi	sp,sp,16
    80001a8e:	8082                	ret

0000000080001a90 <swtch>:
    80001a90:	00153023          	sd	ra,0(a0)
    80001a94:	00253423          	sd	sp,8(a0)
    80001a98:	e900                	sd	s0,16(a0)
    80001a9a:	ed04                	sd	s1,24(a0)
    80001a9c:	03253023          	sd	s2,32(a0)
    80001aa0:	03353423          	sd	s3,40(a0)
    80001aa4:	03453823          	sd	s4,48(a0)
    80001aa8:	03553c23          	sd	s5,56(a0)
    80001aac:	05653023          	sd	s6,64(a0)
    80001ab0:	05753423          	sd	s7,72(a0)
    80001ab4:	05853823          	sd	s8,80(a0)
    80001ab8:	05953c23          	sd	s9,88(a0)
    80001abc:	07a53023          	sd	s10,96(a0)
    80001ac0:	07b53423          	sd	s11,104(a0)
    80001ac4:	0005b083          	ld	ra,0(a1)
    80001ac8:	0085b103          	ld	sp,8(a1)
    80001acc:	6980                	ld	s0,16(a1)
    80001ace:	6d84                	ld	s1,24(a1)
    80001ad0:	0205b903          	ld	s2,32(a1)
    80001ad4:	0285b983          	ld	s3,40(a1)
    80001ad8:	0305ba03          	ld	s4,48(a1)
    80001adc:	0385ba83          	ld	s5,56(a1)
    80001ae0:	0405bb03          	ld	s6,64(a1)
    80001ae4:	0485bb83          	ld	s7,72(a1)
    80001ae8:	0505bc03          	ld	s8,80(a1)
    80001aec:	0585bc83          	ld	s9,88(a1)
    80001af0:	0605bd03          	ld	s10,96(a1)
    80001af4:	0685bd83          	ld	s11,104(a1)
    80001af8:	8082                	ret

0000000080001afa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001afa:	1141                	addi	sp,sp,-16
    80001afc:	e406                	sd	ra,8(sp)
    80001afe:	e022                	sd	s0,0(sp)
    80001b00:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b02:	00006597          	auipc	a1,0x6
    80001b06:	76e58593          	addi	a1,a1,1902 # 80008270 <states.0+0x30>
    80001b0a:	0000d517          	auipc	a0,0xd
    80001b0e:	37650513          	addi	a0,a0,886 # 8000ee80 <tickslock>
    80001b12:	00004097          	auipc	ra,0x4
    80001b16:	5ae080e7          	jalr	1454(ra) # 800060c0 <initlock>
}
    80001b1a:	60a2                	ld	ra,8(sp)
    80001b1c:	6402                	ld	s0,0(sp)
    80001b1e:	0141                	addi	sp,sp,16
    80001b20:	8082                	ret

0000000080001b22 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b22:	1141                	addi	sp,sp,-16
    80001b24:	e422                	sd	s0,8(sp)
    80001b26:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b28:	00003797          	auipc	a5,0x3
    80001b2c:	54878793          	addi	a5,a5,1352 # 80005070 <kernelvec>
    80001b30:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b34:	6422                	ld	s0,8(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e406                	sd	ra,8(sp)
    80001b3e:	e022                	sd	s0,0(sp)
    80001b40:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	352080e7          	jalr	850(ra) # 80000e94 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b50:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b54:	00005617          	auipc	a2,0x5
    80001b58:	4ac60613          	addi	a2,a2,1196 # 80007000 <_trampoline>
    80001b5c:	00005697          	auipc	a3,0x5
    80001b60:	4a468693          	addi	a3,a3,1188 # 80007000 <_trampoline>
    80001b64:	8e91                	sub	a3,a3,a2
    80001b66:	040007b7          	lui	a5,0x4000
    80001b6a:	17fd                	addi	a5,a5,-1
    80001b6c:	07b2                	slli	a5,a5,0xc
    80001b6e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b70:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b74:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b76:	180026f3          	csrr	a3,satp
    80001b7a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b7c:	6d38                	ld	a4,88(a0)
    80001b7e:	6134                	ld	a3,64(a0)
    80001b80:	6585                	lui	a1,0x1
    80001b82:	96ae                	add	a3,a3,a1
    80001b84:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b86:	6d38                	ld	a4,88(a0)
    80001b88:	00000697          	auipc	a3,0x0
    80001b8c:	13868693          	addi	a3,a3,312 # 80001cc0 <usertrap>
    80001b90:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b92:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b94:	8692                	mv	a3,tp
    80001b96:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b98:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b9c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ba0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001baa:	6f18                	ld	a4,24(a4)
    80001bac:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bb0:	692c                	ld	a1,80(a0)
    80001bb2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb4:	00005717          	auipc	a4,0x5
    80001bb8:	4dc70713          	addi	a4,a4,1244 # 80007090 <userret>
    80001bbc:	8f11                	sub	a4,a4,a2
    80001bbe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bc0:	577d                	li	a4,-1
    80001bc2:	177e                	slli	a4,a4,0x3f
    80001bc4:	8dd9                	or	a1,a1,a4
    80001bc6:	02000537          	lui	a0,0x2000
    80001bca:	157d                	addi	a0,a0,-1
    80001bcc:	0536                	slli	a0,a0,0xd
    80001bce:	9782                	jalr	a5
}
    80001bd0:	60a2                	ld	ra,8(sp)
    80001bd2:	6402                	ld	s0,0(sp)
    80001bd4:	0141                	addi	sp,sp,16
    80001bd6:	8082                	ret

0000000080001bd8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd8:	1101                	addi	sp,sp,-32
    80001bda:	ec06                	sd	ra,24(sp)
    80001bdc:	e822                	sd	s0,16(sp)
    80001bde:	e426                	sd	s1,8(sp)
    80001be0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be2:	0000d497          	auipc	s1,0xd
    80001be6:	29e48493          	addi	s1,s1,670 # 8000ee80 <tickslock>
    80001bea:	8526                	mv	a0,s1
    80001bec:	00004097          	auipc	ra,0x4
    80001bf0:	564080e7          	jalr	1380(ra) # 80006150 <acquire>
  ticks++;
    80001bf4:	00007517          	auipc	a0,0x7
    80001bf8:	42450513          	addi	a0,a0,1060 # 80009018 <ticks>
    80001bfc:	411c                	lw	a5,0(a0)
    80001bfe:	2785                	addiw	a5,a5,1
    80001c00:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c02:	00000097          	auipc	ra,0x0
    80001c06:	ae6080e7          	jalr	-1306(ra) # 800016e8 <wakeup>
  release(&tickslock);
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	5f8080e7          	jalr	1528(ra) # 80006204 <release>
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret

0000000080001c1e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c28:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c2c:	00074d63          	bltz	a4,80001c46 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c30:	57fd                	li	a5,-1
    80001c32:	17fe                	slli	a5,a5,0x3f
    80001c34:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c36:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c38:	06f70363          	beq	a4,a5,80001c9e <devintr+0x80>
  }
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret
     (scause & 0xff) == 9){
    80001c46:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c4a:	46a5                	li	a3,9
    80001c4c:	fed792e3          	bne	a5,a3,80001c30 <devintr+0x12>
    int irq = plic_claim();
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	528080e7          	jalr	1320(ra) # 80005178 <plic_claim>
    80001c58:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c5a:	47a9                	li	a5,10
    80001c5c:	02f50763          	beq	a0,a5,80001c8a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c60:	4785                	li	a5,1
    80001c62:	02f50963          	beq	a0,a5,80001c94 <devintr+0x76>
    return 1;
    80001c66:	4505                	li	a0,1
    } else if(irq){
    80001c68:	d8f1                	beqz	s1,80001c3c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c6a:	85a6                	mv	a1,s1
    80001c6c:	00006517          	auipc	a0,0x6
    80001c70:	60c50513          	addi	a0,a0,1548 # 80008278 <states.0+0x38>
    80001c74:	00004097          	auipc	ra,0x4
    80001c78:	fea080e7          	jalr	-22(ra) # 80005c5e <printf>
      plic_complete(irq);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00003097          	auipc	ra,0x3
    80001c82:	51e080e7          	jalr	1310(ra) # 8000519c <plic_complete>
    return 1;
    80001c86:	4505                	li	a0,1
    80001c88:	bf55                	j	80001c3c <devintr+0x1e>
      uartintr();
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	3e6080e7          	jalr	998(ra) # 80006070 <uartintr>
    80001c92:	b7ed                	j	80001c7c <devintr+0x5e>
      virtio_disk_intr();
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	99a080e7          	jalr	-1638(ra) # 8000562e <virtio_disk_intr>
    80001c9c:	b7c5                	j	80001c7c <devintr+0x5e>
    if(cpuid() == 0){
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	1ca080e7          	jalr	458(ra) # 80000e68 <cpuid>
    80001ca6:	c901                	beqz	a0,80001cb6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ca8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cae:	14479073          	csrw	sip,a5
    return 2;
    80001cb2:	4509                	li	a0,2
    80001cb4:	b761                	j	80001c3c <devintr+0x1e>
      clockintr();
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	f22080e7          	jalr	-222(ra) # 80001bd8 <clockintr>
    80001cbe:	b7ed                	j	80001ca8 <devintr+0x8a>

0000000080001cc0 <usertrap>:
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	e426                	sd	s1,8(sp)
    80001cc8:	e04a                	sd	s2,0(sp)
    80001cca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd0:	1007f793          	andi	a5,a5,256
    80001cd4:	e3ad                	bnez	a5,80001d36 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cd6:	00003797          	auipc	a5,0x3
    80001cda:	39a78793          	addi	a5,a5,922 # 80005070 <kernelvec>
    80001cde:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	1b2080e7          	jalr	434(ra) # 80000e94 <myproc>
    80001cea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cee:	14102773          	csrr	a4,sepc
    80001cf2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cf8:	47a1                	li	a5,8
    80001cfa:	04f71c63          	bne	a4,a5,80001d52 <usertrap+0x92>
    if(p->killed)
    80001cfe:	551c                	lw	a5,40(a0)
    80001d00:	e3b9                	bnez	a5,80001d46 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d02:	6cb8                	ld	a4,88(s1)
    80001d04:	6f1c                	ld	a5,24(a4)
    80001d06:	0791                	addi	a5,a5,4
    80001d08:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d12:	10079073          	csrw	sstatus,a5
    syscall();
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	2e0080e7          	jalr	736(ra) # 80001ff6 <syscall>
  if(p->killed)
    80001d1e:	549c                	lw	a5,40(s1)
    80001d20:	ebc1                	bnez	a5,80001db0 <usertrap+0xf0>
  usertrapret();
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	e18080e7          	jalr	-488(ra) # 80001b3a <usertrapret>
}
    80001d2a:	60e2                	ld	ra,24(sp)
    80001d2c:	6442                	ld	s0,16(sp)
    80001d2e:	64a2                	ld	s1,8(sp)
    80001d30:	6902                	ld	s2,0(sp)
    80001d32:	6105                	addi	sp,sp,32
    80001d34:	8082                	ret
    panic("usertrap: not from user mode");
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	56250513          	addi	a0,a0,1378 # 80008298 <states.0+0x58>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	ed6080e7          	jalr	-298(ra) # 80005c14 <panic>
      exit(-1);
    80001d46:	557d                	li	a0,-1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a70080e7          	jalr	-1424(ra) # 800017b8 <exit>
    80001d50:	bf4d                	j	80001d02 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	ecc080e7          	jalr	-308(ra) # 80001c1e <devintr>
    80001d5a:	892a                	mv	s2,a0
    80001d5c:	c501                	beqz	a0,80001d64 <usertrap+0xa4>
  if(p->killed)
    80001d5e:	549c                	lw	a5,40(s1)
    80001d60:	c3a1                	beqz	a5,80001da0 <usertrap+0xe0>
    80001d62:	a815                	j	80001d96 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d64:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d68:	5890                	lw	a2,48(s1)
    80001d6a:	00006517          	auipc	a0,0x6
    80001d6e:	54e50513          	addi	a0,a0,1358 # 800082b8 <states.0+0x78>
    80001d72:	00004097          	auipc	ra,0x4
    80001d76:	eec080e7          	jalr	-276(ra) # 80005c5e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	56650513          	addi	a0,a0,1382 # 800082e8 <states.0+0xa8>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	ed4080e7          	jalr	-300(ra) # 80005c5e <printf>
    p->killed = 1;
    80001d92:	4785                	li	a5,1
    80001d94:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d96:	557d                	li	a0,-1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	a20080e7          	jalr	-1504(ra) # 800017b8 <exit>
  if(which_dev == 2)
    80001da0:	4789                	li	a5,2
    80001da2:	f8f910e3          	bne	s2,a5,80001d22 <usertrap+0x62>
    yield();
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	77a080e7          	jalr	1914(ra) # 80001520 <yield>
    80001dae:	bf95                	j	80001d22 <usertrap+0x62>
  int which_dev = 0;
    80001db0:	4901                	li	s2,0
    80001db2:	b7d5                	j	80001d96 <usertrap+0xd6>

0000000080001db4 <kerneltrap>:
{
    80001db4:	7179                	addi	sp,sp,-48
    80001db6:	f406                	sd	ra,40(sp)
    80001db8:	f022                	sd	s0,32(sp)
    80001dba:	ec26                	sd	s1,24(sp)
    80001dbc:	e84a                	sd	s2,16(sp)
    80001dbe:	e44e                	sd	s3,8(sp)
    80001dc0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dca:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dce:	1004f793          	andi	a5,s1,256
    80001dd2:	cb85                	beqz	a5,80001e02 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dda:	ef85                	bnez	a5,80001e12 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	e42080e7          	jalr	-446(ra) # 80001c1e <devintr>
    80001de4:	cd1d                	beqz	a0,80001e22 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de6:	4789                	li	a5,2
    80001de8:	06f50a63          	beq	a0,a5,80001e5c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df0:	10049073          	csrw	sstatus,s1
}
    80001df4:	70a2                	ld	ra,40(sp)
    80001df6:	7402                	ld	s0,32(sp)
    80001df8:	64e2                	ld	s1,24(sp)
    80001dfa:	6942                	ld	s2,16(sp)
    80001dfc:	69a2                	ld	s3,8(sp)
    80001dfe:	6145                	addi	sp,sp,48
    80001e00:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	50650513          	addi	a0,a0,1286 # 80008308 <states.0+0xc8>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	e0a080e7          	jalr	-502(ra) # 80005c14 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	51e50513          	addi	a0,a0,1310 # 80008330 <states.0+0xf0>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	dfa080e7          	jalr	-518(ra) # 80005c14 <panic>
    printf("scause %p\n", scause);
    80001e22:	85ce                	mv	a1,s3
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	52c50513          	addi	a0,a0,1324 # 80008350 <states.0+0x110>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	e32080e7          	jalr	-462(ra) # 80005c5e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e38:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	52450513          	addi	a0,a0,1316 # 80008360 <states.0+0x120>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	e1a080e7          	jalr	-486(ra) # 80005c5e <printf>
    panic("kerneltrap");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	52c50513          	addi	a0,a0,1324 # 80008378 <states.0+0x138>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	dc0080e7          	jalr	-576(ra) # 80005c14 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	038080e7          	jalr	56(ra) # 80000e94 <myproc>
    80001e64:	d541                	beqz	a0,80001dec <kerneltrap+0x38>
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	02e080e7          	jalr	46(ra) # 80000e94 <myproc>
    80001e6e:	4d18                	lw	a4,24(a0)
    80001e70:	4791                	li	a5,4
    80001e72:	f6f71de3          	bne	a4,a5,80001dec <kerneltrap+0x38>
    yield();
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	6aa080e7          	jalr	1706(ra) # 80001520 <yield>
    80001e7e:	b7bd                	j	80001dec <kerneltrap+0x38>

0000000080001e80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e80:	1101                	addi	sp,sp,-32
    80001e82:	ec06                	sd	ra,24(sp)
    80001e84:	e822                	sd	s0,16(sp)
    80001e86:	e426                	sd	s1,8(sp)
    80001e88:	1000                	addi	s0,sp,32
    80001e8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	008080e7          	jalr	8(ra) # 80000e94 <myproc>
  switch (n) {
    80001e94:	4795                	li	a5,5
    80001e96:	0497e163          	bltu	a5,s1,80001ed8 <argraw+0x58>
    80001e9a:	048a                	slli	s1,s1,0x2
    80001e9c:	00006717          	auipc	a4,0x6
    80001ea0:	5e470713          	addi	a4,a4,1508 # 80008480 <states.0+0x240>
    80001ea4:	94ba                	add	s1,s1,a4
    80001ea6:	409c                	lw	a5,0(s1)
    80001ea8:	97ba                	add	a5,a5,a4
    80001eaa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eb0:	60e2                	ld	ra,24(sp)
    80001eb2:	6442                	ld	s0,16(sp)
    80001eb4:	64a2                	ld	s1,8(sp)
    80001eb6:	6105                	addi	sp,sp,32
    80001eb8:	8082                	ret
    return p->trapframe->a1;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	7fa8                	ld	a0,120(a5)
    80001ebe:	bfcd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a2;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	63c8                	ld	a0,128(a5)
    80001ec4:	b7f5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a3;
    80001ec6:	6d3c                	ld	a5,88(a0)
    80001ec8:	67c8                	ld	a0,136(a5)
    80001eca:	b7dd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a4;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	6bc8                	ld	a0,144(a5)
    80001ed0:	b7c5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a5;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	6fc8                	ld	a0,152(a5)
    80001ed6:	bfe9                	j	80001eb0 <argraw+0x30>
  panic("argraw");
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	4b050513          	addi	a0,a0,1200 # 80008388 <states.0+0x148>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	d34080e7          	jalr	-716(ra) # 80005c14 <panic>

0000000080001ee8 <fetchaddr>:
{
    80001ee8:	1101                	addi	sp,sp,-32
    80001eea:	ec06                	sd	ra,24(sp)
    80001eec:	e822                	sd	s0,16(sp)
    80001eee:	e426                	sd	s1,8(sp)
    80001ef0:	e04a                	sd	s2,0(sp)
    80001ef2:	1000                	addi	s0,sp,32
    80001ef4:	84aa                	mv	s1,a0
    80001ef6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	f9c080e7          	jalr	-100(ra) # 80000e94 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f00:	653c                	ld	a5,72(a0)
    80001f02:	02f4f863          	bgeu	s1,a5,80001f32 <fetchaddr+0x4a>
    80001f06:	00848713          	addi	a4,s1,8
    80001f0a:	02e7e663          	bltu	a5,a4,80001f36 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f0e:	46a1                	li	a3,8
    80001f10:	8626                	mv	a2,s1
    80001f12:	85ca                	mv	a1,s2
    80001f14:	6928                	ld	a0,80(a0)
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	cca080e7          	jalr	-822(ra) # 80000be0 <copyin>
    80001f1e:	00a03533          	snez	a0,a0
    80001f22:	40a00533          	neg	a0,a0
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6902                	ld	s2,0(sp)
    80001f2e:	6105                	addi	sp,sp,32
    80001f30:	8082                	ret
    return -1;
    80001f32:	557d                	li	a0,-1
    80001f34:	bfcd                	j	80001f26 <fetchaddr+0x3e>
    80001f36:	557d                	li	a0,-1
    80001f38:	b7fd                	j	80001f26 <fetchaddr+0x3e>

0000000080001f3a <fetchstr>:
{
    80001f3a:	7179                	addi	sp,sp,-48
    80001f3c:	f406                	sd	ra,40(sp)
    80001f3e:	f022                	sd	s0,32(sp)
    80001f40:	ec26                	sd	s1,24(sp)
    80001f42:	e84a                	sd	s2,16(sp)
    80001f44:	e44e                	sd	s3,8(sp)
    80001f46:	1800                	addi	s0,sp,48
    80001f48:	892a                	mv	s2,a0
    80001f4a:	84ae                	mv	s1,a1
    80001f4c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	f46080e7          	jalr	-186(ra) # 80000e94 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f56:	86ce                	mv	a3,s3
    80001f58:	864a                	mv	a2,s2
    80001f5a:	85a6                	mv	a1,s1
    80001f5c:	6928                	ld	a0,80(a0)
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	d10080e7          	jalr	-752(ra) # 80000c6e <copyinstr>
  if(err < 0)
    80001f66:	00054763          	bltz	a0,80001f74 <fetchstr+0x3a>
  return strlen(buf);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	ffffe097          	auipc	ra,0xffffe
    80001f70:	3da080e7          	jalr	986(ra) # 80000346 <strlen>
}
    80001f74:	70a2                	ld	ra,40(sp)
    80001f76:	7402                	ld	s0,32(sp)
    80001f78:	64e2                	ld	s1,24(sp)
    80001f7a:	6942                	ld	s2,16(sp)
    80001f7c:	69a2                	ld	s3,8(sp)
    80001f7e:	6145                	addi	sp,sp,48
    80001f80:	8082                	ret

0000000080001f82 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	ef2080e7          	jalr	-270(ra) # 80001e80 <argraw>
    80001f96:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f98:	4501                	li	a0,0
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret

0000000080001fa4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	ed0080e7          	jalr	-304(ra) # 80001e80 <argraw>
    80001fb8:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fba:	4501                	li	a0,0
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	e04a                	sd	s2,0(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84ae                	mv	s1,a1
    80001fd4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	eaa080e7          	jalr	-342(ra) # 80001e80 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fde:	864a                	mv	a2,s2
    80001fe0:	85a6                	mv	a1,s1
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f58080e7          	jalr	-168(ra) # 80001f3a <fetchstr>
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret

0000000080001ff6 <syscall>:
[SYS_sysinfo]   sys_sysinfo,
};

void
syscall(void)
{
    80001ff6:	7179                	addi	sp,sp,-48
    80001ff8:	f406                	sd	ra,40(sp)
    80001ffa:	f022                	sd	s0,32(sp)
    80001ffc:	ec26                	sd	s1,24(sp)
    80001ffe:	e84a                	sd	s2,16(sp)
    80002000:	e44e                	sd	s3,8(sp)
    80002002:	1800                	addi	s0,sp,48
  int num;
  struct proc* p = myproc();
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	e90080e7          	jalr	-368(ra) # 80000e94 <myproc>
    8000200c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;  // 系统调用编号，参见书中4.3节
    8000200e:	05853903          	ld	s2,88(a0)
    80002012:	0a893783          	ld	a5,168(s2)
    80002016:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000201a:	37fd                	addiw	a5,a5,-1
    8000201c:	4759                	li	a4,22
    8000201e:	04f76763          	bltu	a4,a5,8000206c <syscall+0x76>
    80002022:	00399713          	slli	a4,s3,0x3
    80002026:	00006797          	auipc	a5,0x6
    8000202a:	47278793          	addi	a5,a5,1138 # 80008498 <syscalls>
    8000202e:	97ba                	add	a5,a5,a4
    80002030:	639c                	ld	a5,0(a5)
    80002032:	cf8d                	beqz	a5,8000206c <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();  // 执行系统调用，然后将返回值存入a0
    80002034:	9782                	jalr	a5
    80002036:	06a93823          	sd	a0,112(s2)

    // 系统调用是否匹配 -- 位运算判断
    //如果我们要追踪read,那么trace_mask的值为32,也就是10000
    //假如当前系统调用号为5,那么1左移五位为: 10000
    //此时相与得到1,说明是我们需要追踪的系统调用,则进行打点记录
    if ((1 << num) & p->trace_mask)
    8000203a:	58dc                	lw	a5,52(s1)
    8000203c:	4137d7bb          	sraw	a5,a5,s3
    80002040:	8b85                	andi	a5,a5,1
    80002042:	c7a1                	beqz	a5,8000208a <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    80002044:	6cb8                	ld	a4,88(s1)
    80002046:	098e                	slli	s3,s3,0x3
    80002048:	00006797          	auipc	a5,0x6
    8000204c:	45078793          	addi	a5,a5,1104 # 80008498 <syscalls>
    80002050:	99be                	add	s3,s3,a5
    80002052:	7b34                	ld	a3,112(a4)
    80002054:	0c09b603          	ld	a2,192(s3)
    80002058:	588c                	lw	a1,48(s1)
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	33650513          	addi	a0,a0,822 # 80008390 <states.0+0x150>
    80002062:	00004097          	auipc	ra,0x4
    80002066:	bfc080e7          	jalr	-1028(ra) # 80005c5e <printf>
    8000206a:	a005                	j	8000208a <syscall+0x94>
  }
  else {
    printf("%d %s: unknown sys call %d\n",
    8000206c:	86ce                	mv	a3,s3
    8000206e:	15848613          	addi	a2,s1,344
    80002072:	588c                	lw	a1,48(s1)
    80002074:	00006517          	auipc	a0,0x6
    80002078:	33450513          	addi	a0,a0,820 # 800083a8 <states.0+0x168>
    8000207c:	00004097          	auipc	ra,0x4
    80002080:	be2080e7          	jalr	-1054(ra) # 80005c5e <printf>
      p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002084:	6cbc                	ld	a5,88(s1)
    80002086:	577d                	li	a4,-1
    80002088:	fbb8                	sd	a4,112(a5)
  }
}
    8000208a:	70a2                	ld	ra,40(sp)
    8000208c:	7402                	ld	s0,32(sp)
    8000208e:	64e2                	ld	s1,24(sp)
    80002090:	6942                	ld	s2,16(sp)
    80002092:	69a2                	ld	s3,8(sp)
    80002094:	6145                	addi	sp,sp,48
    80002096:	8082                	ret

0000000080002098 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020a0:	fec40593          	addi	a1,s0,-20
    800020a4:	4501                	li	a0,0
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	edc080e7          	jalr	-292(ra) # 80001f82 <argint>
    return -1;
    800020ae:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020b0:	00054963          	bltz	a0,800020c2 <sys_exit+0x2a>
  exit(n);
    800020b4:	fec42503          	lw	a0,-20(s0)
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	700080e7          	jalr	1792(ra) # 800017b8 <exit>
  return 0;  // not reached
    800020c0:	4781                	li	a5,0
}
    800020c2:	853e                	mv	a0,a5
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	6105                	addi	sp,sp,32
    800020ca:	8082                	ret

00000000800020cc <sys_getpid>:

uint64
sys_getpid(void)
{
    800020cc:	1141                	addi	sp,sp,-16
    800020ce:	e406                	sd	ra,8(sp)
    800020d0:	e022                	sd	s0,0(sp)
    800020d2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	dc0080e7          	jalr	-576(ra) # 80000e94 <myproc>
}
    800020dc:	5908                	lw	a0,48(a0)
    800020de:	60a2                	ld	ra,8(sp)
    800020e0:	6402                	ld	s0,0(sp)
    800020e2:	0141                	addi	sp,sp,16
    800020e4:	8082                	ret

00000000800020e6 <sys_fork>:

uint64
sys_fork(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
  return fork();
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	174080e7          	jalr	372(ra) # 80001262 <fork>
}
    800020f6:	60a2                	ld	ra,8(sp)
    800020f8:	6402                	ld	s0,0(sp)
    800020fa:	0141                	addi	sp,sp,16
    800020fc:	8082                	ret

00000000800020fe <sys_wait>:

uint64
sys_wait(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002106:	fe840593          	addi	a1,s0,-24
    8000210a:	4501                	li	a0,0
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	e98080e7          	jalr	-360(ra) # 80001fa4 <argaddr>
    80002114:	87aa                	mv	a5,a0
    return -1;
    80002116:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002118:	0007c863          	bltz	a5,80002128 <sys_wait+0x2a>
  return wait(p);
    8000211c:	fe843503          	ld	a0,-24(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	4a0080e7          	jalr	1184(ra) # 800015c0 <wait>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002130:	7179                	addi	sp,sp,-48
    80002132:	f406                	sd	ra,40(sp)
    80002134:	f022                	sd	s0,32(sp)
    80002136:	ec26                	sd	s1,24(sp)
    80002138:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000213a:	fdc40593          	addi	a1,s0,-36
    8000213e:	4501                	li	a0,0
    80002140:	00000097          	auipc	ra,0x0
    80002144:	e42080e7          	jalr	-446(ra) # 80001f82 <argint>
    return -1;
    80002148:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000214a:	00054f63          	bltz	a0,80002168 <sys_sbrk+0x38>
  addr = myproc()->sz;
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	d46080e7          	jalr	-698(ra) # 80000e94 <myproc>
    80002156:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002158:	fdc42503          	lw	a0,-36(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	092080e7          	jalr	146(ra) # 800011ee <growproc>
    80002164:	00054863          	bltz	a0,80002174 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002168:	8526                	mv	a0,s1
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	64e2                	ld	s1,24(sp)
    80002170:	6145                	addi	sp,sp,48
    80002172:	8082                	ret
    return -1;
    80002174:	54fd                	li	s1,-1
    80002176:	bfcd                	j	80002168 <sys_sbrk+0x38>

0000000080002178 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002178:	7139                	addi	sp,sp,-64
    8000217a:	fc06                	sd	ra,56(sp)
    8000217c:	f822                	sd	s0,48(sp)
    8000217e:	f426                	sd	s1,40(sp)
    80002180:	f04a                	sd	s2,32(sp)
    80002182:	ec4e                	sd	s3,24(sp)
    80002184:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002186:	fcc40593          	addi	a1,s0,-52
    8000218a:	4501                	li	a0,0
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	df6080e7          	jalr	-522(ra) # 80001f82 <argint>
    return -1;
    80002194:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002196:	06054563          	bltz	a0,80002200 <sys_sleep+0x88>
  acquire(&tickslock);
    8000219a:	0000d517          	auipc	a0,0xd
    8000219e:	ce650513          	addi	a0,a0,-794 # 8000ee80 <tickslock>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	fae080e7          	jalr	-82(ra) # 80006150 <acquire>
  ticks0 = ticks;
    800021aa:	00007917          	auipc	s2,0x7
    800021ae:	e6e92903          	lw	s2,-402(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021b2:	fcc42783          	lw	a5,-52(s0)
    800021b6:	cf85                	beqz	a5,800021ee <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b8:	0000d997          	auipc	s3,0xd
    800021bc:	cc898993          	addi	s3,s3,-824 # 8000ee80 <tickslock>
    800021c0:	00007497          	auipc	s1,0x7
    800021c4:	e5848493          	addi	s1,s1,-424 # 80009018 <ticks>
    if(myproc()->killed){
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	ccc080e7          	jalr	-820(ra) # 80000e94 <myproc>
    800021d0:	551c                	lw	a5,40(a0)
    800021d2:	ef9d                	bnez	a5,80002210 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021d4:	85ce                	mv	a1,s3
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	384080e7          	jalr	900(ra) # 8000155c <sleep>
  while(ticks - ticks0 < n){
    800021e0:	409c                	lw	a5,0(s1)
    800021e2:	412787bb          	subw	a5,a5,s2
    800021e6:	fcc42703          	lw	a4,-52(s0)
    800021ea:	fce7efe3          	bltu	a5,a4,800021c8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	c9250513          	addi	a0,a0,-878 # 8000ee80 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	00e080e7          	jalr	14(ra) # 80006204 <release>
  return 0;
    800021fe:	4781                	li	a5,0
}
    80002200:	853e                	mv	a0,a5
    80002202:	70e2                	ld	ra,56(sp)
    80002204:	7442                	ld	s0,48(sp)
    80002206:	74a2                	ld	s1,40(sp)
    80002208:	7902                	ld	s2,32(sp)
    8000220a:	69e2                	ld	s3,24(sp)
    8000220c:	6121                	addi	sp,sp,64
    8000220e:	8082                	ret
      release(&tickslock);
    80002210:	0000d517          	auipc	a0,0xd
    80002214:	c7050513          	addi	a0,a0,-912 # 8000ee80 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	fec080e7          	jalr	-20(ra) # 80006204 <release>
      return -1;
    80002220:	57fd                	li	a5,-1
    80002222:	bff9                	j	80002200 <sys_sleep+0x88>

0000000080002224 <sys_kill>:

uint64
sys_kill(void)
{
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000222c:	fec40593          	addi	a1,s0,-20
    80002230:	4501                	li	a0,0
    80002232:	00000097          	auipc	ra,0x0
    80002236:	d50080e7          	jalr	-688(ra) # 80001f82 <argint>
    8000223a:	87aa                	mv	a5,a0
    return -1;
    8000223c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000223e:	0007c863          	bltz	a5,8000224e <sys_kill+0x2a>
  return kill(pid);
    80002242:	fec42503          	lw	a0,-20(s0)
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	648080e7          	jalr	1608(ra) # 8000188e <kill>
}
    8000224e:	60e2                	ld	ra,24(sp)
    80002250:	6442                	ld	s0,16(sp)
    80002252:	6105                	addi	sp,sp,32
    80002254:	8082                	ret

0000000080002256 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002256:	1101                	addi	sp,sp,-32
    80002258:	ec06                	sd	ra,24(sp)
    8000225a:	e822                	sd	s0,16(sp)
    8000225c:	e426                	sd	s1,8(sp)
    8000225e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002260:	0000d517          	auipc	a0,0xd
    80002264:	c2050513          	addi	a0,a0,-992 # 8000ee80 <tickslock>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	ee8080e7          	jalr	-280(ra) # 80006150 <acquire>
  xticks = ticks;
    80002270:	00007497          	auipc	s1,0x7
    80002274:	da84a483          	lw	s1,-600(s1) # 80009018 <ticks>
  release(&tickslock);
    80002278:	0000d517          	auipc	a0,0xd
    8000227c:	c0850513          	addi	a0,a0,-1016 # 8000ee80 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	f84080e7          	jalr	-124(ra) # 80006204 <release>
  return xticks;
}
    80002288:	02049513          	slli	a0,s1,0x20
    8000228c:	9101                	srli	a0,a0,0x20
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002298:	7179                	addi	sp,sp,-48
    8000229a:	f406                	sd	ra,40(sp)
    8000229c:	f022                	sd	s0,32(sp)
    8000229e:	1800                	addi	s0,sp,48
  struct sysinfo info;
  freebytes(&info.freemem);
    800022a0:	fe040513          	addi	a0,s0,-32
    800022a4:	ffffe097          	auipc	ra,0xffffe
    800022a8:	ed4080e7          	jalr	-300(ra) # 80000178 <freebytes>
  procnum(&info.nproc);
    800022ac:	fe840513          	addi	a0,s0,-24
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	7aa080e7          	jalr	1962(ra) # 80001a5a <procnum>

  // a0寄存器作为系统调用的参数寄存器,从中取出存放 sysinfo 结构的用户态缓冲区指针
  uint64 dstaddr;
  argaddr(0, &dstaddr);
    800022b8:	fd840593          	addi	a1,s0,-40
    800022bc:	4501                	li	a0,0
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	ce6080e7          	jalr	-794(ra) # 80001fa4 <argaddr>

  // 使用 copyout，结合当前进程的页表，获得进程传进来的指针（逻辑地址）对应的物理地址
  // 然后将 &sinfo 中的数据复制到该指针所指位置，供用户进程使用。
  if (copyout(myproc()->pagetable, dstaddr, (char*)&info, sizeof info) < 0)
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	bce080e7          	jalr	-1074(ra) # 80000e94 <myproc>
    800022ce:	46c1                	li	a3,16
    800022d0:	fe040613          	addi	a2,s0,-32
    800022d4:	fd843583          	ld	a1,-40(s0)
    800022d8:	6928                	ld	a0,80(a0)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	87a080e7          	jalr	-1926(ra) # 80000b54 <copyout>
    return -1;

  return 0;
}
    800022e2:	957d                	srai	a0,a0,0x3f
    800022e4:	70a2                	ld	ra,40(sp)
    800022e6:	7402                	ld	s0,32(sp)
    800022e8:	6145                	addi	sp,sp,48
    800022ea:	8082                	ret

00000000800022ec <sys_trace>:

uint64
sys_trace(void)
{
    800022ec:	1141                	addi	sp,sp,-16
    800022ee:	e406                	sd	ra,8(sp)
    800022f0:	e022                	sd	s0,0(sp)
    800022f2:	0800                	addi	s0,sp,16
  // 获取系统调用的参数
  argint(0, &(myproc()->trace_mask));
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	ba0080e7          	jalr	-1120(ra) # 80000e94 <myproc>
    800022fc:	03450593          	addi	a1,a0,52
    80002300:	4501                	li	a0,0
    80002302:	00000097          	auipc	ra,0x0
    80002306:	c80080e7          	jalr	-896(ra) # 80001f82 <argint>
  return 0;
}
    8000230a:	4501                	li	a0,0
    8000230c:	60a2                	ld	ra,8(sp)
    8000230e:	6402                	ld	s0,0(sp)
    80002310:	0141                	addi	sp,sp,16
    80002312:	8082                	ret

0000000080002314 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002314:	7179                	addi	sp,sp,-48
    80002316:	f406                	sd	ra,40(sp)
    80002318:	f022                	sd	s0,32(sp)
    8000231a:	ec26                	sd	s1,24(sp)
    8000231c:	e84a                	sd	s2,16(sp)
    8000231e:	e44e                	sd	s3,8(sp)
    80002320:	e052                	sd	s4,0(sp)
    80002322:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002324:	00006597          	auipc	a1,0x6
    80002328:	2f458593          	addi	a1,a1,756 # 80008618 <syscalls_name+0xc0>
    8000232c:	0000d517          	auipc	a0,0xd
    80002330:	b6c50513          	addi	a0,a0,-1172 # 8000ee98 <bcache>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	d8c080e7          	jalr	-628(ra) # 800060c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000233c:	00015797          	auipc	a5,0x15
    80002340:	b5c78793          	addi	a5,a5,-1188 # 80016e98 <bcache+0x8000>
    80002344:	00015717          	auipc	a4,0x15
    80002348:	dbc70713          	addi	a4,a4,-580 # 80017100 <bcache+0x8268>
    8000234c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002350:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002354:	0000d497          	auipc	s1,0xd
    80002358:	b5c48493          	addi	s1,s1,-1188 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000235c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000235e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002360:	00006a17          	auipc	s4,0x6
    80002364:	2c0a0a13          	addi	s4,s4,704 # 80008620 <syscalls_name+0xc8>
    b->next = bcache.head.next;
    80002368:	2b893783          	ld	a5,696(s2)
    8000236c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000236e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002372:	85d2                	mv	a1,s4
    80002374:	01048513          	addi	a0,s1,16
    80002378:	00001097          	auipc	ra,0x1
    8000237c:	4bc080e7          	jalr	1212(ra) # 80003834 <initsleeplock>
    bcache.head.next->prev = b;
    80002380:	2b893783          	ld	a5,696(s2)
    80002384:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002386:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000238a:	45848493          	addi	s1,s1,1112
    8000238e:	fd349de3          	bne	s1,s3,80002368 <binit+0x54>
  }
}
    80002392:	70a2                	ld	ra,40(sp)
    80002394:	7402                	ld	s0,32(sp)
    80002396:	64e2                	ld	s1,24(sp)
    80002398:	6942                	ld	s2,16(sp)
    8000239a:	69a2                	ld	s3,8(sp)
    8000239c:	6a02                	ld	s4,0(sp)
    8000239e:	6145                	addi	sp,sp,48
    800023a0:	8082                	ret

00000000800023a2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023a2:	7179                	addi	sp,sp,-48
    800023a4:	f406                	sd	ra,40(sp)
    800023a6:	f022                	sd	s0,32(sp)
    800023a8:	ec26                	sd	s1,24(sp)
    800023aa:	e84a                	sd	s2,16(sp)
    800023ac:	e44e                	sd	s3,8(sp)
    800023ae:	1800                	addi	s0,sp,48
    800023b0:	892a                	mv	s2,a0
    800023b2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023b4:	0000d517          	auipc	a0,0xd
    800023b8:	ae450513          	addi	a0,a0,-1308 # 8000ee98 <bcache>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	d94080e7          	jalr	-620(ra) # 80006150 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c4:	00015497          	auipc	s1,0x15
    800023c8:	d8c4b483          	ld	s1,-628(s1) # 80017150 <bcache+0x82b8>
    800023cc:	00015797          	auipc	a5,0x15
    800023d0:	d3478793          	addi	a5,a5,-716 # 80017100 <bcache+0x8268>
    800023d4:	02f48f63          	beq	s1,a5,80002412 <bread+0x70>
    800023d8:	873e                	mv	a4,a5
    800023da:	a021                	j	800023e2 <bread+0x40>
    800023dc:	68a4                	ld	s1,80(s1)
    800023de:	02e48a63          	beq	s1,a4,80002412 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023e2:	449c                	lw	a5,8(s1)
    800023e4:	ff279ce3          	bne	a5,s2,800023dc <bread+0x3a>
    800023e8:	44dc                	lw	a5,12(s1)
    800023ea:	ff3799e3          	bne	a5,s3,800023dc <bread+0x3a>
      b->refcnt++;
    800023ee:	40bc                	lw	a5,64(s1)
    800023f0:	2785                	addiw	a5,a5,1
    800023f2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f4:	0000d517          	auipc	a0,0xd
    800023f8:	aa450513          	addi	a0,a0,-1372 # 8000ee98 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	e08080e7          	jalr	-504(ra) # 80006204 <release>
      acquiresleep(&b->lock);
    80002404:	01048513          	addi	a0,s1,16
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	466080e7          	jalr	1126(ra) # 8000386e <acquiresleep>
      return b;
    80002410:	a8b9                	j	8000246e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002412:	00015497          	auipc	s1,0x15
    80002416:	d364b483          	ld	s1,-714(s1) # 80017148 <bcache+0x82b0>
    8000241a:	00015797          	auipc	a5,0x15
    8000241e:	ce678793          	addi	a5,a5,-794 # 80017100 <bcache+0x8268>
    80002422:	00f48863          	beq	s1,a5,80002432 <bread+0x90>
    80002426:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002428:	40bc                	lw	a5,64(s1)
    8000242a:	cf81                	beqz	a5,80002442 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242c:	64a4                	ld	s1,72(s1)
    8000242e:	fee49de3          	bne	s1,a4,80002428 <bread+0x86>
  panic("bget: no buffers");
    80002432:	00006517          	auipc	a0,0x6
    80002436:	1f650513          	addi	a0,a0,502 # 80008628 <syscalls_name+0xd0>
    8000243a:	00003097          	auipc	ra,0x3
    8000243e:	7da080e7          	jalr	2010(ra) # 80005c14 <panic>
      b->dev = dev;
    80002442:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002446:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000244a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000244e:	4785                	li	a5,1
    80002450:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002452:	0000d517          	auipc	a0,0xd
    80002456:	a4650513          	addi	a0,a0,-1466 # 8000ee98 <bcache>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	daa080e7          	jalr	-598(ra) # 80006204 <release>
      acquiresleep(&b->lock);
    80002462:	01048513          	addi	a0,s1,16
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	408080e7          	jalr	1032(ra) # 8000386e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000246e:	409c                	lw	a5,0(s1)
    80002470:	cb89                	beqz	a5,80002482 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002472:	8526                	mv	a0,s1
    80002474:	70a2                	ld	ra,40(sp)
    80002476:	7402                	ld	s0,32(sp)
    80002478:	64e2                	ld	s1,24(sp)
    8000247a:	6942                	ld	s2,16(sp)
    8000247c:	69a2                	ld	s3,8(sp)
    8000247e:	6145                	addi	sp,sp,48
    80002480:	8082                	ret
    virtio_disk_rw(b, 0);
    80002482:	4581                	li	a1,0
    80002484:	8526                	mv	a0,s1
    80002486:	00003097          	auipc	ra,0x3
    8000248a:	f20080e7          	jalr	-224(ra) # 800053a6 <virtio_disk_rw>
    b->valid = 1;
    8000248e:	4785                	li	a5,1
    80002490:	c09c                	sw	a5,0(s1)
  return b;
    80002492:	b7c5                	j	80002472 <bread+0xd0>

0000000080002494 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002494:	1101                	addi	sp,sp,-32
    80002496:	ec06                	sd	ra,24(sp)
    80002498:	e822                	sd	s0,16(sp)
    8000249a:	e426                	sd	s1,8(sp)
    8000249c:	1000                	addi	s0,sp,32
    8000249e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024a0:	0541                	addi	a0,a0,16
    800024a2:	00001097          	auipc	ra,0x1
    800024a6:	466080e7          	jalr	1126(ra) # 80003908 <holdingsleep>
    800024aa:	cd01                	beqz	a0,800024c2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ac:	4585                	li	a1,1
    800024ae:	8526                	mv	a0,s1
    800024b0:	00003097          	auipc	ra,0x3
    800024b4:	ef6080e7          	jalr	-266(ra) # 800053a6 <virtio_disk_rw>
}
    800024b8:	60e2                	ld	ra,24(sp)
    800024ba:	6442                	ld	s0,16(sp)
    800024bc:	64a2                	ld	s1,8(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret
    panic("bwrite");
    800024c2:	00006517          	auipc	a0,0x6
    800024c6:	17e50513          	addi	a0,a0,382 # 80008640 <syscalls_name+0xe8>
    800024ca:	00003097          	auipc	ra,0x3
    800024ce:	74a080e7          	jalr	1866(ra) # 80005c14 <panic>

00000000800024d2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024d2:	1101                	addi	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	e04a                	sd	s2,0(sp)
    800024dc:	1000                	addi	s0,sp,32
    800024de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e0:	01050913          	addi	s2,a0,16
    800024e4:	854a                	mv	a0,s2
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	422080e7          	jalr	1058(ra) # 80003908 <holdingsleep>
    800024ee:	c92d                	beqz	a0,80002560 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024f0:	854a                	mv	a0,s2
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	3d2080e7          	jalr	978(ra) # 800038c4 <releasesleep>

  acquire(&bcache.lock);
    800024fa:	0000d517          	auipc	a0,0xd
    800024fe:	99e50513          	addi	a0,a0,-1634 # 8000ee98 <bcache>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	c4e080e7          	jalr	-946(ra) # 80006150 <acquire>
  b->refcnt--;
    8000250a:	40bc                	lw	a5,64(s1)
    8000250c:	37fd                	addiw	a5,a5,-1
    8000250e:	0007871b          	sext.w	a4,a5
    80002512:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002514:	eb05                	bnez	a4,80002544 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002516:	68bc                	ld	a5,80(s1)
    80002518:	64b8                	ld	a4,72(s1)
    8000251a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000251c:	64bc                	ld	a5,72(s1)
    8000251e:	68b8                	ld	a4,80(s1)
    80002520:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002522:	00015797          	auipc	a5,0x15
    80002526:	97678793          	addi	a5,a5,-1674 # 80016e98 <bcache+0x8000>
    8000252a:	2b87b703          	ld	a4,696(a5)
    8000252e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002530:	00015717          	auipc	a4,0x15
    80002534:	bd070713          	addi	a4,a4,-1072 # 80017100 <bcache+0x8268>
    80002538:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000253a:	2b87b703          	ld	a4,696(a5)
    8000253e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002540:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002544:	0000d517          	auipc	a0,0xd
    80002548:	95450513          	addi	a0,a0,-1708 # 8000ee98 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	cb8080e7          	jalr	-840(ra) # 80006204 <release>
}
    80002554:	60e2                	ld	ra,24(sp)
    80002556:	6442                	ld	s0,16(sp)
    80002558:	64a2                	ld	s1,8(sp)
    8000255a:	6902                	ld	s2,0(sp)
    8000255c:	6105                	addi	sp,sp,32
    8000255e:	8082                	ret
    panic("brelse");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	0e850513          	addi	a0,a0,232 # 80008648 <syscalls_name+0xf0>
    80002568:	00003097          	auipc	ra,0x3
    8000256c:	6ac080e7          	jalr	1708(ra) # 80005c14 <panic>

0000000080002570 <bpin>:

void
bpin(struct buf *b) {
    80002570:	1101                	addi	sp,sp,-32
    80002572:	ec06                	sd	ra,24(sp)
    80002574:	e822                	sd	s0,16(sp)
    80002576:	e426                	sd	s1,8(sp)
    80002578:	1000                	addi	s0,sp,32
    8000257a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	91c50513          	addi	a0,a0,-1764 # 8000ee98 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	bcc080e7          	jalr	-1076(ra) # 80006150 <acquire>
  b->refcnt++;
    8000258c:	40bc                	lw	a5,64(s1)
    8000258e:	2785                	addiw	a5,a5,1
    80002590:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002592:	0000d517          	auipc	a0,0xd
    80002596:	90650513          	addi	a0,a0,-1786 # 8000ee98 <bcache>
    8000259a:	00004097          	auipc	ra,0x4
    8000259e:	c6a080e7          	jalr	-918(ra) # 80006204 <release>
}
    800025a2:	60e2                	ld	ra,24(sp)
    800025a4:	6442                	ld	s0,16(sp)
    800025a6:	64a2                	ld	s1,8(sp)
    800025a8:	6105                	addi	sp,sp,32
    800025aa:	8082                	ret

00000000800025ac <bunpin>:

void
bunpin(struct buf *b) {
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	8e050513          	addi	a0,a0,-1824 # 8000ee98 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	b90080e7          	jalr	-1136(ra) # 80006150 <acquire>
  b->refcnt--;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	37fd                	addiw	a5,a5,-1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	0000d517          	auipc	a0,0xd
    800025d2:	8ca50513          	addi	a0,a0,-1846 # 8000ee98 <bcache>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	c2e080e7          	jalr	-978(ra) # 80006204 <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	e04a                	sd	s2,0(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f6:	00d5d59b          	srliw	a1,a1,0xd
    800025fa:	00015797          	auipc	a5,0x15
    800025fe:	f7a7a783          	lw	a5,-134(a5) # 80017574 <sb+0x1c>
    80002602:	9dbd                	addw	a1,a1,a5
    80002604:	00000097          	auipc	ra,0x0
    80002608:	d9e080e7          	jalr	-610(ra) # 800023a2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000260c:	0074f713          	andi	a4,s1,7
    80002610:	4785                	li	a5,1
    80002612:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002616:	14ce                	slli	s1,s1,0x33
    80002618:	90d9                	srli	s1,s1,0x36
    8000261a:	00950733          	add	a4,a0,s1
    8000261e:	05874703          	lbu	a4,88(a4)
    80002622:	00e7f6b3          	and	a3,a5,a4
    80002626:	c69d                	beqz	a3,80002654 <bfree+0x6c>
    80002628:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000262a:	94aa                	add	s1,s1,a0
    8000262c:	fff7c793          	not	a5,a5
    80002630:	8ff9                	and	a5,a5,a4
    80002632:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002636:	00001097          	auipc	ra,0x1
    8000263a:	118080e7          	jalr	280(ra) # 8000374e <log_write>
  brelse(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00000097          	auipc	ra,0x0
    80002644:	e92080e7          	jalr	-366(ra) # 800024d2 <brelse>
}
    80002648:	60e2                	ld	ra,24(sp)
    8000264a:	6442                	ld	s0,16(sp)
    8000264c:	64a2                	ld	s1,8(sp)
    8000264e:	6902                	ld	s2,0(sp)
    80002650:	6105                	addi	sp,sp,32
    80002652:	8082                	ret
    panic("freeing free block");
    80002654:	00006517          	auipc	a0,0x6
    80002658:	ffc50513          	addi	a0,a0,-4 # 80008650 <syscalls_name+0xf8>
    8000265c:	00003097          	auipc	ra,0x3
    80002660:	5b8080e7          	jalr	1464(ra) # 80005c14 <panic>

0000000080002664 <balloc>:
{
    80002664:	711d                	addi	sp,sp,-96
    80002666:	ec86                	sd	ra,88(sp)
    80002668:	e8a2                	sd	s0,80(sp)
    8000266a:	e4a6                	sd	s1,72(sp)
    8000266c:	e0ca                	sd	s2,64(sp)
    8000266e:	fc4e                	sd	s3,56(sp)
    80002670:	f852                	sd	s4,48(sp)
    80002672:	f456                	sd	s5,40(sp)
    80002674:	f05a                	sd	s6,32(sp)
    80002676:	ec5e                	sd	s7,24(sp)
    80002678:	e862                	sd	s8,16(sp)
    8000267a:	e466                	sd	s9,8(sp)
    8000267c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000267e:	00015797          	auipc	a5,0x15
    80002682:	ede7a783          	lw	a5,-290(a5) # 8001755c <sb+0x4>
    80002686:	cbd1                	beqz	a5,8000271a <balloc+0xb6>
    80002688:	8baa                	mv	s7,a0
    8000268a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000268c:	00015b17          	auipc	s6,0x15
    80002690:	eccb0b13          	addi	s6,s6,-308 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002694:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002696:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002698:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000269a:	6c89                	lui	s9,0x2
    8000269c:	a831                	j	800026b8 <balloc+0x54>
    brelse(bp);
    8000269e:	854a                	mv	a0,s2
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	e32080e7          	jalr	-462(ra) # 800024d2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a8:	015c87bb          	addw	a5,s9,s5
    800026ac:	00078a9b          	sext.w	s5,a5
    800026b0:	004b2703          	lw	a4,4(s6)
    800026b4:	06eaf363          	bgeu	s5,a4,8000271a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026b8:	41fad79b          	sraiw	a5,s5,0x1f
    800026bc:	0137d79b          	srliw	a5,a5,0x13
    800026c0:	015787bb          	addw	a5,a5,s5
    800026c4:	40d7d79b          	sraiw	a5,a5,0xd
    800026c8:	01cb2583          	lw	a1,28(s6)
    800026cc:	9dbd                	addw	a1,a1,a5
    800026ce:	855e                	mv	a0,s7
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	cd2080e7          	jalr	-814(ra) # 800023a2 <bread>
    800026d8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	004b2503          	lw	a0,4(s6)
    800026de:	000a849b          	sext.w	s1,s5
    800026e2:	8662                	mv	a2,s8
    800026e4:	faa4fde3          	bgeu	s1,a0,8000269e <balloc+0x3a>
      m = 1 << (bi % 8);
    800026e8:	41f6579b          	sraiw	a5,a2,0x1f
    800026ec:	01d7d69b          	srliw	a3,a5,0x1d
    800026f0:	00c6873b          	addw	a4,a3,a2
    800026f4:	00777793          	andi	a5,a4,7
    800026f8:	9f95                	subw	a5,a5,a3
    800026fa:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026fe:	4037571b          	sraiw	a4,a4,0x3
    80002702:	00e906b3          	add	a3,s2,a4
    80002706:	0586c683          	lbu	a3,88(a3)
    8000270a:	00d7f5b3          	and	a1,a5,a3
    8000270e:	cd91                	beqz	a1,8000272a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	2605                	addiw	a2,a2,1
    80002712:	2485                	addiw	s1,s1,1
    80002714:	fd4618e3          	bne	a2,s4,800026e4 <balloc+0x80>
    80002718:	b759                	j	8000269e <balloc+0x3a>
  panic("balloc: out of blocks");
    8000271a:	00006517          	auipc	a0,0x6
    8000271e:	f4e50513          	addi	a0,a0,-178 # 80008668 <syscalls_name+0x110>
    80002722:	00003097          	auipc	ra,0x3
    80002726:	4f2080e7          	jalr	1266(ra) # 80005c14 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000272a:	974a                	add	a4,a4,s2
    8000272c:	8fd5                	or	a5,a5,a3
    8000272e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002732:	854a                	mv	a0,s2
    80002734:	00001097          	auipc	ra,0x1
    80002738:	01a080e7          	jalr	26(ra) # 8000374e <log_write>
        brelse(bp);
    8000273c:	854a                	mv	a0,s2
    8000273e:	00000097          	auipc	ra,0x0
    80002742:	d94080e7          	jalr	-620(ra) # 800024d2 <brelse>
  bp = bread(dev, bno);
    80002746:	85a6                	mv	a1,s1
    80002748:	855e                	mv	a0,s7
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	c58080e7          	jalr	-936(ra) # 800023a2 <bread>
    80002752:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002754:	40000613          	li	a2,1024
    80002758:	4581                	li	a1,0
    8000275a:	05850513          	addi	a0,a0,88
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	a6c080e7          	jalr	-1428(ra) # 800001ca <memset>
  log_write(bp);
    80002766:	854a                	mv	a0,s2
    80002768:	00001097          	auipc	ra,0x1
    8000276c:	fe6080e7          	jalr	-26(ra) # 8000374e <log_write>
  brelse(bp);
    80002770:	854a                	mv	a0,s2
    80002772:	00000097          	auipc	ra,0x0
    80002776:	d60080e7          	jalr	-672(ra) # 800024d2 <brelse>
}
    8000277a:	8526                	mv	a0,s1
    8000277c:	60e6                	ld	ra,88(sp)
    8000277e:	6446                	ld	s0,80(sp)
    80002780:	64a6                	ld	s1,72(sp)
    80002782:	6906                	ld	s2,64(sp)
    80002784:	79e2                	ld	s3,56(sp)
    80002786:	7a42                	ld	s4,48(sp)
    80002788:	7aa2                	ld	s5,40(sp)
    8000278a:	7b02                	ld	s6,32(sp)
    8000278c:	6be2                	ld	s7,24(sp)
    8000278e:	6c42                	ld	s8,16(sp)
    80002790:	6ca2                	ld	s9,8(sp)
    80002792:	6125                	addi	sp,sp,96
    80002794:	8082                	ret

0000000080002796 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002796:	7179                	addi	sp,sp,-48
    80002798:	f406                	sd	ra,40(sp)
    8000279a:	f022                	sd	s0,32(sp)
    8000279c:	ec26                	sd	s1,24(sp)
    8000279e:	e84a                	sd	s2,16(sp)
    800027a0:	e44e                	sd	s3,8(sp)
    800027a2:	e052                	sd	s4,0(sp)
    800027a4:	1800                	addi	s0,sp,48
    800027a6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027a8:	47ad                	li	a5,11
    800027aa:	04b7fe63          	bgeu	a5,a1,80002806 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ae:	ff45849b          	addiw	s1,a1,-12
    800027b2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027b6:	0ff00793          	li	a5,255
    800027ba:	0ae7e363          	bltu	a5,a4,80002860 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027be:	08052583          	lw	a1,128(a0)
    800027c2:	c5ad                	beqz	a1,8000282c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027c4:	00092503          	lw	a0,0(s2)
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	bda080e7          	jalr	-1062(ra) # 800023a2 <bread>
    800027d0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027d2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027d6:	02049593          	slli	a1,s1,0x20
    800027da:	9181                	srli	a1,a1,0x20
    800027dc:	058a                	slli	a1,a1,0x2
    800027de:	00b784b3          	add	s1,a5,a1
    800027e2:	0004a983          	lw	s3,0(s1)
    800027e6:	04098d63          	beqz	s3,80002840 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027ea:	8552                	mv	a0,s4
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	ce6080e7          	jalr	-794(ra) # 800024d2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027f4:	854e                	mv	a0,s3
    800027f6:	70a2                	ld	ra,40(sp)
    800027f8:	7402                	ld	s0,32(sp)
    800027fa:	64e2                	ld	s1,24(sp)
    800027fc:	6942                	ld	s2,16(sp)
    800027fe:	69a2                	ld	s3,8(sp)
    80002800:	6a02                	ld	s4,0(sp)
    80002802:	6145                	addi	sp,sp,48
    80002804:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002806:	02059493          	slli	s1,a1,0x20
    8000280a:	9081                	srli	s1,s1,0x20
    8000280c:	048a                	slli	s1,s1,0x2
    8000280e:	94aa                	add	s1,s1,a0
    80002810:	0504a983          	lw	s3,80(s1)
    80002814:	fe0990e3          	bnez	s3,800027f4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002818:	4108                	lw	a0,0(a0)
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	e4a080e7          	jalr	-438(ra) # 80002664 <balloc>
    80002822:	0005099b          	sext.w	s3,a0
    80002826:	0534a823          	sw	s3,80(s1)
    8000282a:	b7e9                	j	800027f4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000282c:	4108                	lw	a0,0(a0)
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	e36080e7          	jalr	-458(ra) # 80002664 <balloc>
    80002836:	0005059b          	sext.w	a1,a0
    8000283a:	08b92023          	sw	a1,128(s2)
    8000283e:	b759                	j	800027c4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002840:	00092503          	lw	a0,0(s2)
    80002844:	00000097          	auipc	ra,0x0
    80002848:	e20080e7          	jalr	-480(ra) # 80002664 <balloc>
    8000284c:	0005099b          	sext.w	s3,a0
    80002850:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002854:	8552                	mv	a0,s4
    80002856:	00001097          	auipc	ra,0x1
    8000285a:	ef8080e7          	jalr	-264(ra) # 8000374e <log_write>
    8000285e:	b771                	j	800027ea <bmap+0x54>
  panic("bmap: out of range");
    80002860:	00006517          	auipc	a0,0x6
    80002864:	e2050513          	addi	a0,a0,-480 # 80008680 <syscalls_name+0x128>
    80002868:	00003097          	auipc	ra,0x3
    8000286c:	3ac080e7          	jalr	940(ra) # 80005c14 <panic>

0000000080002870 <iget>:
{
    80002870:	7179                	addi	sp,sp,-48
    80002872:	f406                	sd	ra,40(sp)
    80002874:	f022                	sd	s0,32(sp)
    80002876:	ec26                	sd	s1,24(sp)
    80002878:	e84a                	sd	s2,16(sp)
    8000287a:	e44e                	sd	s3,8(sp)
    8000287c:	e052                	sd	s4,0(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	89aa                	mv	s3,a0
    80002882:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002884:	00015517          	auipc	a0,0x15
    80002888:	cf450513          	addi	a0,a0,-780 # 80017578 <itable>
    8000288c:	00004097          	auipc	ra,0x4
    80002890:	8c4080e7          	jalr	-1852(ra) # 80006150 <acquire>
  empty = 0;
    80002894:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002896:	00015497          	auipc	s1,0x15
    8000289a:	cfa48493          	addi	s1,s1,-774 # 80017590 <itable+0x18>
    8000289e:	00016697          	auipc	a3,0x16
    800028a2:	78268693          	addi	a3,a3,1922 # 80019020 <log>
    800028a6:	a039                	j	800028b4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a8:	02090b63          	beqz	s2,800028de <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ac:	08848493          	addi	s1,s1,136
    800028b0:	02d48a63          	beq	s1,a3,800028e4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b4:	449c                	lw	a5,8(s1)
    800028b6:	fef059e3          	blez	a5,800028a8 <iget+0x38>
    800028ba:	4098                	lw	a4,0(s1)
    800028bc:	ff3716e3          	bne	a4,s3,800028a8 <iget+0x38>
    800028c0:	40d8                	lw	a4,4(s1)
    800028c2:	ff4713e3          	bne	a4,s4,800028a8 <iget+0x38>
      ip->ref++;
    800028c6:	2785                	addiw	a5,a5,1
    800028c8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ca:	00015517          	auipc	a0,0x15
    800028ce:	cae50513          	addi	a0,a0,-850 # 80017578 <itable>
    800028d2:	00004097          	auipc	ra,0x4
    800028d6:	932080e7          	jalr	-1742(ra) # 80006204 <release>
      return ip;
    800028da:	8926                	mv	s2,s1
    800028dc:	a03d                	j	8000290a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028de:	f7f9                	bnez	a5,800028ac <iget+0x3c>
    800028e0:	8926                	mv	s2,s1
    800028e2:	b7e9                	j	800028ac <iget+0x3c>
  if(empty == 0)
    800028e4:	02090c63          	beqz	s2,8000291c <iget+0xac>
  ip->dev = dev;
    800028e8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028ec:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f0:	4785                	li	a5,1
    800028f2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fa:	00015517          	auipc	a0,0x15
    800028fe:	c7e50513          	addi	a0,a0,-898 # 80017578 <itable>
    80002902:	00004097          	auipc	ra,0x4
    80002906:	902080e7          	jalr	-1790(ra) # 80006204 <release>
}
    8000290a:	854a                	mv	a0,s2
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6a02                	ld	s4,0(sp)
    80002918:	6145                	addi	sp,sp,48
    8000291a:	8082                	ret
    panic("iget: no inodes");
    8000291c:	00006517          	auipc	a0,0x6
    80002920:	d7c50513          	addi	a0,a0,-644 # 80008698 <syscalls_name+0x140>
    80002924:	00003097          	auipc	ra,0x3
    80002928:	2f0080e7          	jalr	752(ra) # 80005c14 <panic>

000000008000292c <fsinit>:
fsinit(int dev) {
    8000292c:	7179                	addi	sp,sp,-48
    8000292e:	f406                	sd	ra,40(sp)
    80002930:	f022                	sd	s0,32(sp)
    80002932:	ec26                	sd	s1,24(sp)
    80002934:	e84a                	sd	s2,16(sp)
    80002936:	e44e                	sd	s3,8(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000293c:	4585                	li	a1,1
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	a64080e7          	jalr	-1436(ra) # 800023a2 <bread>
    80002946:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002948:	00015997          	auipc	s3,0x15
    8000294c:	c1098993          	addi	s3,s3,-1008 # 80017558 <sb>
    80002950:	02000613          	li	a2,32
    80002954:	05850593          	addi	a1,a0,88
    80002958:	854e                	mv	a0,s3
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	8cc080e7          	jalr	-1844(ra) # 80000226 <memmove>
  brelse(bp);
    80002962:	8526                	mv	a0,s1
    80002964:	00000097          	auipc	ra,0x0
    80002968:	b6e080e7          	jalr	-1170(ra) # 800024d2 <brelse>
  if(sb.magic != FSMAGIC)
    8000296c:	0009a703          	lw	a4,0(s3)
    80002970:	102037b7          	lui	a5,0x10203
    80002974:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002978:	02f71263          	bne	a4,a5,8000299c <fsinit+0x70>
  initlog(dev, &sb);
    8000297c:	00015597          	auipc	a1,0x15
    80002980:	bdc58593          	addi	a1,a1,-1060 # 80017558 <sb>
    80002984:	854a                	mv	a0,s2
    80002986:	00001097          	auipc	ra,0x1
    8000298a:	b4c080e7          	jalr	-1204(ra) # 800034d2 <initlog>
}
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	69a2                	ld	s3,8(sp)
    80002998:	6145                	addi	sp,sp,48
    8000299a:	8082                	ret
    panic("invalid file system");
    8000299c:	00006517          	auipc	a0,0x6
    800029a0:	d0c50513          	addi	a0,a0,-756 # 800086a8 <syscalls_name+0x150>
    800029a4:	00003097          	auipc	ra,0x3
    800029a8:	270080e7          	jalr	624(ra) # 80005c14 <panic>

00000000800029ac <iinit>:
{
    800029ac:	7179                	addi	sp,sp,-48
    800029ae:	f406                	sd	ra,40(sp)
    800029b0:	f022                	sd	s0,32(sp)
    800029b2:	ec26                	sd	s1,24(sp)
    800029b4:	e84a                	sd	s2,16(sp)
    800029b6:	e44e                	sd	s3,8(sp)
    800029b8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ba:	00006597          	auipc	a1,0x6
    800029be:	d0658593          	addi	a1,a1,-762 # 800086c0 <syscalls_name+0x168>
    800029c2:	00015517          	auipc	a0,0x15
    800029c6:	bb650513          	addi	a0,a0,-1098 # 80017578 <itable>
    800029ca:	00003097          	auipc	ra,0x3
    800029ce:	6f6080e7          	jalr	1782(ra) # 800060c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d2:	00015497          	auipc	s1,0x15
    800029d6:	bce48493          	addi	s1,s1,-1074 # 800175a0 <itable+0x28>
    800029da:	00016997          	auipc	s3,0x16
    800029de:	65698993          	addi	s3,s3,1622 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e2:	00006917          	auipc	s2,0x6
    800029e6:	ce690913          	addi	s2,s2,-794 # 800086c8 <syscalls_name+0x170>
    800029ea:	85ca                	mv	a1,s2
    800029ec:	8526                	mv	a0,s1
    800029ee:	00001097          	auipc	ra,0x1
    800029f2:	e46080e7          	jalr	-442(ra) # 80003834 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f6:	08848493          	addi	s1,s1,136
    800029fa:	ff3498e3          	bne	s1,s3,800029ea <iinit+0x3e>
}
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret

0000000080002a0c <ialloc>:
{
    80002a0c:	715d                	addi	sp,sp,-80
    80002a0e:	e486                	sd	ra,72(sp)
    80002a10:	e0a2                	sd	s0,64(sp)
    80002a12:	fc26                	sd	s1,56(sp)
    80002a14:	f84a                	sd	s2,48(sp)
    80002a16:	f44e                	sd	s3,40(sp)
    80002a18:	f052                	sd	s4,32(sp)
    80002a1a:	ec56                	sd	s5,24(sp)
    80002a1c:	e85a                	sd	s6,16(sp)
    80002a1e:	e45e                	sd	s7,8(sp)
    80002a20:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a22:	00015717          	auipc	a4,0x15
    80002a26:	b4272703          	lw	a4,-1214(a4) # 80017564 <sb+0xc>
    80002a2a:	4785                	li	a5,1
    80002a2c:	04e7fa63          	bgeu	a5,a4,80002a80 <ialloc+0x74>
    80002a30:	8aaa                	mv	s5,a0
    80002a32:	8bae                	mv	s7,a1
    80002a34:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a36:	00015a17          	auipc	s4,0x15
    80002a3a:	b22a0a13          	addi	s4,s4,-1246 # 80017558 <sb>
    80002a3e:	00048b1b          	sext.w	s6,s1
    80002a42:	0044d793          	srli	a5,s1,0x4
    80002a46:	018a2583          	lw	a1,24(s4)
    80002a4a:	9dbd                	addw	a1,a1,a5
    80002a4c:	8556                	mv	a0,s5
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	954080e7          	jalr	-1708(ra) # 800023a2 <bread>
    80002a56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a58:	05850993          	addi	s3,a0,88
    80002a5c:	00f4f793          	andi	a5,s1,15
    80002a60:	079a                	slli	a5,a5,0x6
    80002a62:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a64:	00099783          	lh	a5,0(s3)
    80002a68:	c785                	beqz	a5,80002a90 <ialloc+0x84>
    brelse(bp);
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	a68080e7          	jalr	-1432(ra) # 800024d2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a72:	0485                	addi	s1,s1,1
    80002a74:	00ca2703          	lw	a4,12(s4)
    80002a78:	0004879b          	sext.w	a5,s1
    80002a7c:	fce7e1e3          	bltu	a5,a4,80002a3e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a80:	00006517          	auipc	a0,0x6
    80002a84:	c5050513          	addi	a0,a0,-944 # 800086d0 <syscalls_name+0x178>
    80002a88:	00003097          	auipc	ra,0x3
    80002a8c:	18c080e7          	jalr	396(ra) # 80005c14 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a90:	04000613          	li	a2,64
    80002a94:	4581                	li	a1,0
    80002a96:	854e                	mv	a0,s3
    80002a98:	ffffd097          	auipc	ra,0xffffd
    80002a9c:	732080e7          	jalr	1842(ra) # 800001ca <memset>
      dip->type = type;
    80002aa0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aa4:	854a                	mv	a0,s2
    80002aa6:	00001097          	auipc	ra,0x1
    80002aaa:	ca8080e7          	jalr	-856(ra) # 8000374e <log_write>
      brelse(bp);
    80002aae:	854a                	mv	a0,s2
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	a22080e7          	jalr	-1502(ra) # 800024d2 <brelse>
      return iget(dev, inum);
    80002ab8:	85da                	mv	a1,s6
    80002aba:	8556                	mv	a0,s5
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	db4080e7          	jalr	-588(ra) # 80002870 <iget>
}
    80002ac4:	60a6                	ld	ra,72(sp)
    80002ac6:	6406                	ld	s0,64(sp)
    80002ac8:	74e2                	ld	s1,56(sp)
    80002aca:	7942                	ld	s2,48(sp)
    80002acc:	79a2                	ld	s3,40(sp)
    80002ace:	7a02                	ld	s4,32(sp)
    80002ad0:	6ae2                	ld	s5,24(sp)
    80002ad2:	6b42                	ld	s6,16(sp)
    80002ad4:	6ba2                	ld	s7,8(sp)
    80002ad6:	6161                	addi	sp,sp,80
    80002ad8:	8082                	ret

0000000080002ada <iupdate>:
{
    80002ada:	1101                	addi	sp,sp,-32
    80002adc:	ec06                	sd	ra,24(sp)
    80002ade:	e822                	sd	s0,16(sp)
    80002ae0:	e426                	sd	s1,8(sp)
    80002ae2:	e04a                	sd	s2,0(sp)
    80002ae4:	1000                	addi	s0,sp,32
    80002ae6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ae8:	415c                	lw	a5,4(a0)
    80002aea:	0047d79b          	srliw	a5,a5,0x4
    80002aee:	00015597          	auipc	a1,0x15
    80002af2:	a825a583          	lw	a1,-1406(a1) # 80017570 <sb+0x18>
    80002af6:	9dbd                	addw	a1,a1,a5
    80002af8:	4108                	lw	a0,0(a0)
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	8a8080e7          	jalr	-1880(ra) # 800023a2 <bread>
    80002b02:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b04:	05850793          	addi	a5,a0,88
    80002b08:	40c8                	lw	a0,4(s1)
    80002b0a:	893d                	andi	a0,a0,15
    80002b0c:	051a                	slli	a0,a0,0x6
    80002b0e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b10:	04449703          	lh	a4,68(s1)
    80002b14:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b18:	04649703          	lh	a4,70(s1)
    80002b1c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b20:	04849703          	lh	a4,72(s1)
    80002b24:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b28:	04a49703          	lh	a4,74(s1)
    80002b2c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b30:	44f8                	lw	a4,76(s1)
    80002b32:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b34:	03400613          	li	a2,52
    80002b38:	05048593          	addi	a1,s1,80
    80002b3c:	0531                	addi	a0,a0,12
    80002b3e:	ffffd097          	auipc	ra,0xffffd
    80002b42:	6e8080e7          	jalr	1768(ra) # 80000226 <memmove>
  log_write(bp);
    80002b46:	854a                	mv	a0,s2
    80002b48:	00001097          	auipc	ra,0x1
    80002b4c:	c06080e7          	jalr	-1018(ra) # 8000374e <log_write>
  brelse(bp);
    80002b50:	854a                	mv	a0,s2
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	980080e7          	jalr	-1664(ra) # 800024d2 <brelse>
}
    80002b5a:	60e2                	ld	ra,24(sp)
    80002b5c:	6442                	ld	s0,16(sp)
    80002b5e:	64a2                	ld	s1,8(sp)
    80002b60:	6902                	ld	s2,0(sp)
    80002b62:	6105                	addi	sp,sp,32
    80002b64:	8082                	ret

0000000080002b66 <idup>:
{
    80002b66:	1101                	addi	sp,sp,-32
    80002b68:	ec06                	sd	ra,24(sp)
    80002b6a:	e822                	sd	s0,16(sp)
    80002b6c:	e426                	sd	s1,8(sp)
    80002b6e:	1000                	addi	s0,sp,32
    80002b70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b72:	00015517          	auipc	a0,0x15
    80002b76:	a0650513          	addi	a0,a0,-1530 # 80017578 <itable>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	5d6080e7          	jalr	1494(ra) # 80006150 <acquire>
  ip->ref++;
    80002b82:	449c                	lw	a5,8(s1)
    80002b84:	2785                	addiw	a5,a5,1
    80002b86:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b88:	00015517          	auipc	a0,0x15
    80002b8c:	9f050513          	addi	a0,a0,-1552 # 80017578 <itable>
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	674080e7          	jalr	1652(ra) # 80006204 <release>
}
    80002b98:	8526                	mv	a0,s1
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6105                	addi	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <ilock>:
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	e04a                	sd	s2,0(sp)
    80002bae:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bb0:	c115                	beqz	a0,80002bd4 <ilock+0x30>
    80002bb2:	84aa                	mv	s1,a0
    80002bb4:	451c                	lw	a5,8(a0)
    80002bb6:	00f05f63          	blez	a5,80002bd4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bba:	0541                	addi	a0,a0,16
    80002bbc:	00001097          	auipc	ra,0x1
    80002bc0:	cb2080e7          	jalr	-846(ra) # 8000386e <acquiresleep>
  if(ip->valid == 0){
    80002bc4:	40bc                	lw	a5,64(s1)
    80002bc6:	cf99                	beqz	a5,80002be4 <ilock+0x40>
}
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6902                	ld	s2,0(sp)
    80002bd0:	6105                	addi	sp,sp,32
    80002bd2:	8082                	ret
    panic("ilock");
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	b1450513          	addi	a0,a0,-1260 # 800086e8 <syscalls_name+0x190>
    80002bdc:	00003097          	auipc	ra,0x3
    80002be0:	038080e7          	jalr	56(ra) # 80005c14 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be4:	40dc                	lw	a5,4(s1)
    80002be6:	0047d79b          	srliw	a5,a5,0x4
    80002bea:	00015597          	auipc	a1,0x15
    80002bee:	9865a583          	lw	a1,-1658(a1) # 80017570 <sb+0x18>
    80002bf2:	9dbd                	addw	a1,a1,a5
    80002bf4:	4088                	lw	a0,0(s1)
    80002bf6:	fffff097          	auipc	ra,0xfffff
    80002bfa:	7ac080e7          	jalr	1964(ra) # 800023a2 <bread>
    80002bfe:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c00:	05850593          	addi	a1,a0,88
    80002c04:	40dc                	lw	a5,4(s1)
    80002c06:	8bbd                	andi	a5,a5,15
    80002c08:	079a                	slli	a5,a5,0x6
    80002c0a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c0c:	00059783          	lh	a5,0(a1)
    80002c10:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c14:	00259783          	lh	a5,2(a1)
    80002c18:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c1c:	00459783          	lh	a5,4(a1)
    80002c20:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c24:	00659783          	lh	a5,6(a1)
    80002c28:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c2c:	459c                	lw	a5,8(a1)
    80002c2e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c30:	03400613          	li	a2,52
    80002c34:	05b1                	addi	a1,a1,12
    80002c36:	05048513          	addi	a0,s1,80
    80002c3a:	ffffd097          	auipc	ra,0xffffd
    80002c3e:	5ec080e7          	jalr	1516(ra) # 80000226 <memmove>
    brelse(bp);
    80002c42:	854a                	mv	a0,s2
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	88e080e7          	jalr	-1906(ra) # 800024d2 <brelse>
    ip->valid = 1;
    80002c4c:	4785                	li	a5,1
    80002c4e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c50:	04449783          	lh	a5,68(s1)
    80002c54:	fbb5                	bnez	a5,80002bc8 <ilock+0x24>
      panic("ilock: no type");
    80002c56:	00006517          	auipc	a0,0x6
    80002c5a:	a9a50513          	addi	a0,a0,-1382 # 800086f0 <syscalls_name+0x198>
    80002c5e:	00003097          	auipc	ra,0x3
    80002c62:	fb6080e7          	jalr	-74(ra) # 80005c14 <panic>

0000000080002c66 <iunlock>:
{
    80002c66:	1101                	addi	sp,sp,-32
    80002c68:	ec06                	sd	ra,24(sp)
    80002c6a:	e822                	sd	s0,16(sp)
    80002c6c:	e426                	sd	s1,8(sp)
    80002c6e:	e04a                	sd	s2,0(sp)
    80002c70:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c72:	c905                	beqz	a0,80002ca2 <iunlock+0x3c>
    80002c74:	84aa                	mv	s1,a0
    80002c76:	01050913          	addi	s2,a0,16
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	c8c080e7          	jalr	-884(ra) # 80003908 <holdingsleep>
    80002c84:	cd19                	beqz	a0,80002ca2 <iunlock+0x3c>
    80002c86:	449c                	lw	a5,8(s1)
    80002c88:	00f05d63          	blez	a5,80002ca2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c8c:	854a                	mv	a0,s2
    80002c8e:	00001097          	auipc	ra,0x1
    80002c92:	c36080e7          	jalr	-970(ra) # 800038c4 <releasesleep>
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	64a2                	ld	s1,8(sp)
    80002c9c:	6902                	ld	s2,0(sp)
    80002c9e:	6105                	addi	sp,sp,32
    80002ca0:	8082                	ret
    panic("iunlock");
    80002ca2:	00006517          	auipc	a0,0x6
    80002ca6:	a5e50513          	addi	a0,a0,-1442 # 80008700 <syscalls_name+0x1a8>
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	f6a080e7          	jalr	-150(ra) # 80005c14 <panic>

0000000080002cb2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb2:	7179                	addi	sp,sp,-48
    80002cb4:	f406                	sd	ra,40(sp)
    80002cb6:	f022                	sd	s0,32(sp)
    80002cb8:	ec26                	sd	s1,24(sp)
    80002cba:	e84a                	sd	s2,16(sp)
    80002cbc:	e44e                	sd	s3,8(sp)
    80002cbe:	e052                	sd	s4,0(sp)
    80002cc0:	1800                	addi	s0,sp,48
    80002cc2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cc4:	05050493          	addi	s1,a0,80
    80002cc8:	08050913          	addi	s2,a0,128
    80002ccc:	a021                	j	80002cd4 <itrunc+0x22>
    80002cce:	0491                	addi	s1,s1,4
    80002cd0:	01248d63          	beq	s1,s2,80002cea <itrunc+0x38>
    if(ip->addrs[i]){
    80002cd4:	408c                	lw	a1,0(s1)
    80002cd6:	dde5                	beqz	a1,80002cce <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cd8:	0009a503          	lw	a0,0(s3)
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	90c080e7          	jalr	-1780(ra) # 800025e8 <bfree>
      ip->addrs[i] = 0;
    80002ce4:	0004a023          	sw	zero,0(s1)
    80002ce8:	b7dd                	j	80002cce <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cea:	0809a583          	lw	a1,128(s3)
    80002cee:	e185                	bnez	a1,80002d0e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cf0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cf4:	854e                	mv	a0,s3
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	de4080e7          	jalr	-540(ra) # 80002ada <iupdate>
}
    80002cfe:	70a2                	ld	ra,40(sp)
    80002d00:	7402                	ld	s0,32(sp)
    80002d02:	64e2                	ld	s1,24(sp)
    80002d04:	6942                	ld	s2,16(sp)
    80002d06:	69a2                	ld	s3,8(sp)
    80002d08:	6a02                	ld	s4,0(sp)
    80002d0a:	6145                	addi	sp,sp,48
    80002d0c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d0e:	0009a503          	lw	a0,0(s3)
    80002d12:	fffff097          	auipc	ra,0xfffff
    80002d16:	690080e7          	jalr	1680(ra) # 800023a2 <bread>
    80002d1a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d1c:	05850493          	addi	s1,a0,88
    80002d20:	45850913          	addi	s2,a0,1112
    80002d24:	a021                	j	80002d2c <itrunc+0x7a>
    80002d26:	0491                	addi	s1,s1,4
    80002d28:	01248b63          	beq	s1,s2,80002d3e <itrunc+0x8c>
      if(a[j])
    80002d2c:	408c                	lw	a1,0(s1)
    80002d2e:	dde5                	beqz	a1,80002d26 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d30:	0009a503          	lw	a0,0(s3)
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	8b4080e7          	jalr	-1868(ra) # 800025e8 <bfree>
    80002d3c:	b7ed                	j	80002d26 <itrunc+0x74>
    brelse(bp);
    80002d3e:	8552                	mv	a0,s4
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	792080e7          	jalr	1938(ra) # 800024d2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d48:	0809a583          	lw	a1,128(s3)
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	898080e7          	jalr	-1896(ra) # 800025e8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d58:	0809a023          	sw	zero,128(s3)
    80002d5c:	bf51                	j	80002cf0 <itrunc+0x3e>

0000000080002d5e <iput>:
{
    80002d5e:	1101                	addi	sp,sp,-32
    80002d60:	ec06                	sd	ra,24(sp)
    80002d62:	e822                	sd	s0,16(sp)
    80002d64:	e426                	sd	s1,8(sp)
    80002d66:	e04a                	sd	s2,0(sp)
    80002d68:	1000                	addi	s0,sp,32
    80002d6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d6c:	00015517          	auipc	a0,0x15
    80002d70:	80c50513          	addi	a0,a0,-2036 # 80017578 <itable>
    80002d74:	00003097          	auipc	ra,0x3
    80002d78:	3dc080e7          	jalr	988(ra) # 80006150 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d7c:	4498                	lw	a4,8(s1)
    80002d7e:	4785                	li	a5,1
    80002d80:	02f70363          	beq	a4,a5,80002da6 <iput+0x48>
  ip->ref--;
    80002d84:	449c                	lw	a5,8(s1)
    80002d86:	37fd                	addiw	a5,a5,-1
    80002d88:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8a:	00014517          	auipc	a0,0x14
    80002d8e:	7ee50513          	addi	a0,a0,2030 # 80017578 <itable>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	472080e7          	jalr	1138(ra) # 80006204 <release>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da6:	40bc                	lw	a5,64(s1)
    80002da8:	dff1                	beqz	a5,80002d84 <iput+0x26>
    80002daa:	04a49783          	lh	a5,74(s1)
    80002dae:	fbf9                	bnez	a5,80002d84 <iput+0x26>
    acquiresleep(&ip->lock);
    80002db0:	01048913          	addi	s2,s1,16
    80002db4:	854a                	mv	a0,s2
    80002db6:	00001097          	auipc	ra,0x1
    80002dba:	ab8080e7          	jalr	-1352(ra) # 8000386e <acquiresleep>
    release(&itable.lock);
    80002dbe:	00014517          	auipc	a0,0x14
    80002dc2:	7ba50513          	addi	a0,a0,1978 # 80017578 <itable>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	43e080e7          	jalr	1086(ra) # 80006204 <release>
    itrunc(ip);
    80002dce:	8526                	mv	a0,s1
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	ee2080e7          	jalr	-286(ra) # 80002cb2 <itrunc>
    ip->type = 0;
    80002dd8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ddc:	8526                	mv	a0,s1
    80002dde:	00000097          	auipc	ra,0x0
    80002de2:	cfc080e7          	jalr	-772(ra) # 80002ada <iupdate>
    ip->valid = 0;
    80002de6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dea:	854a                	mv	a0,s2
    80002dec:	00001097          	auipc	ra,0x1
    80002df0:	ad8080e7          	jalr	-1320(ra) # 800038c4 <releasesleep>
    acquire(&itable.lock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	78450513          	addi	a0,a0,1924 # 80017578 <itable>
    80002dfc:	00003097          	auipc	ra,0x3
    80002e00:	354080e7          	jalr	852(ra) # 80006150 <acquire>
    80002e04:	b741                	j	80002d84 <iput+0x26>

0000000080002e06 <iunlockput>:
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	e54080e7          	jalr	-428(ra) # 80002c66 <iunlock>
  iput(ip);
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	f42080e7          	jalr	-190(ra) # 80002d5e <iput>
}
    80002e24:	60e2                	ld	ra,24(sp)
    80002e26:	6442                	ld	s0,16(sp)
    80002e28:	64a2                	ld	s1,8(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e2e:	1141                	addi	sp,sp,-16
    80002e30:	e422                	sd	s0,8(sp)
    80002e32:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e34:	411c                	lw	a5,0(a0)
    80002e36:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e38:	415c                	lw	a5,4(a0)
    80002e3a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e3c:	04451783          	lh	a5,68(a0)
    80002e40:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e44:	04a51783          	lh	a5,74(a0)
    80002e48:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e4c:	04c56783          	lwu	a5,76(a0)
    80002e50:	e99c                	sd	a5,16(a1)
}
    80002e52:	6422                	ld	s0,8(sp)
    80002e54:	0141                	addi	sp,sp,16
    80002e56:	8082                	ret

0000000080002e58 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e58:	457c                	lw	a5,76(a0)
    80002e5a:	0ed7e963          	bltu	a5,a3,80002f4c <readi+0xf4>
{
    80002e5e:	7159                	addi	sp,sp,-112
    80002e60:	f486                	sd	ra,104(sp)
    80002e62:	f0a2                	sd	s0,96(sp)
    80002e64:	eca6                	sd	s1,88(sp)
    80002e66:	e8ca                	sd	s2,80(sp)
    80002e68:	e4ce                	sd	s3,72(sp)
    80002e6a:	e0d2                	sd	s4,64(sp)
    80002e6c:	fc56                	sd	s5,56(sp)
    80002e6e:	f85a                	sd	s6,48(sp)
    80002e70:	f45e                	sd	s7,40(sp)
    80002e72:	f062                	sd	s8,32(sp)
    80002e74:	ec66                	sd	s9,24(sp)
    80002e76:	e86a                	sd	s10,16(sp)
    80002e78:	e46e                	sd	s11,8(sp)
    80002e7a:	1880                	addi	s0,sp,112
    80002e7c:	8baa                	mv	s7,a0
    80002e7e:	8c2e                	mv	s8,a1
    80002e80:	8ab2                	mv	s5,a2
    80002e82:	84b6                	mv	s1,a3
    80002e84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e86:	9f35                	addw	a4,a4,a3
    return 0;
    80002e88:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e8a:	0ad76063          	bltu	a4,a3,80002f2a <readi+0xd2>
  if(off + n > ip->size)
    80002e8e:	00e7f463          	bgeu	a5,a4,80002e96 <readi+0x3e>
    n = ip->size - off;
    80002e92:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e96:	0a0b0963          	beqz	s6,80002f48 <readi+0xf0>
    80002e9a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e9c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ea0:	5cfd                	li	s9,-1
    80002ea2:	a82d                	j	80002edc <readi+0x84>
    80002ea4:	020a1d93          	slli	s11,s4,0x20
    80002ea8:	020ddd93          	srli	s11,s11,0x20
    80002eac:	05890793          	addi	a5,s2,88
    80002eb0:	86ee                	mv	a3,s11
    80002eb2:	963e                	add	a2,a2,a5
    80002eb4:	85d6                	mv	a1,s5
    80002eb6:	8562                	mv	a0,s8
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	a48080e7          	jalr	-1464(ra) # 80001900 <either_copyout>
    80002ec0:	05950d63          	beq	a0,s9,80002f1a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ec4:	854a                	mv	a0,s2
    80002ec6:	fffff097          	auipc	ra,0xfffff
    80002eca:	60c080e7          	jalr	1548(ra) # 800024d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ece:	013a09bb          	addw	s3,s4,s3
    80002ed2:	009a04bb          	addw	s1,s4,s1
    80002ed6:	9aee                	add	s5,s5,s11
    80002ed8:	0569f763          	bgeu	s3,s6,80002f26 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002edc:	000ba903          	lw	s2,0(s7)
    80002ee0:	00a4d59b          	srliw	a1,s1,0xa
    80002ee4:	855e                	mv	a0,s7
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	8b0080e7          	jalr	-1872(ra) # 80002796 <bmap>
    80002eee:	0005059b          	sext.w	a1,a0
    80002ef2:	854a                	mv	a0,s2
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	4ae080e7          	jalr	1198(ra) # 800023a2 <bread>
    80002efc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002efe:	3ff4f613          	andi	a2,s1,1023
    80002f02:	40cd07bb          	subw	a5,s10,a2
    80002f06:	413b073b          	subw	a4,s6,s3
    80002f0a:	8a3e                	mv	s4,a5
    80002f0c:	2781                	sext.w	a5,a5
    80002f0e:	0007069b          	sext.w	a3,a4
    80002f12:	f8f6f9e3          	bgeu	a3,a5,80002ea4 <readi+0x4c>
    80002f16:	8a3a                	mv	s4,a4
    80002f18:	b771                	j	80002ea4 <readi+0x4c>
      brelse(bp);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	5b6080e7          	jalr	1462(ra) # 800024d2 <brelse>
      tot = -1;
    80002f24:	59fd                	li	s3,-1
  }
  return tot;
    80002f26:	0009851b          	sext.w	a0,s3
}
    80002f2a:	70a6                	ld	ra,104(sp)
    80002f2c:	7406                	ld	s0,96(sp)
    80002f2e:	64e6                	ld	s1,88(sp)
    80002f30:	6946                	ld	s2,80(sp)
    80002f32:	69a6                	ld	s3,72(sp)
    80002f34:	6a06                	ld	s4,64(sp)
    80002f36:	7ae2                	ld	s5,56(sp)
    80002f38:	7b42                	ld	s6,48(sp)
    80002f3a:	7ba2                	ld	s7,40(sp)
    80002f3c:	7c02                	ld	s8,32(sp)
    80002f3e:	6ce2                	ld	s9,24(sp)
    80002f40:	6d42                	ld	s10,16(sp)
    80002f42:	6da2                	ld	s11,8(sp)
    80002f44:	6165                	addi	sp,sp,112
    80002f46:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f48:	89da                	mv	s3,s6
    80002f4a:	bff1                	j	80002f26 <readi+0xce>
    return 0;
    80002f4c:	4501                	li	a0,0
}
    80002f4e:	8082                	ret

0000000080002f50 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f50:	457c                	lw	a5,76(a0)
    80002f52:	10d7e863          	bltu	a5,a3,80003062 <writei+0x112>
{
    80002f56:	7159                	addi	sp,sp,-112
    80002f58:	f486                	sd	ra,104(sp)
    80002f5a:	f0a2                	sd	s0,96(sp)
    80002f5c:	eca6                	sd	s1,88(sp)
    80002f5e:	e8ca                	sd	s2,80(sp)
    80002f60:	e4ce                	sd	s3,72(sp)
    80002f62:	e0d2                	sd	s4,64(sp)
    80002f64:	fc56                	sd	s5,56(sp)
    80002f66:	f85a                	sd	s6,48(sp)
    80002f68:	f45e                	sd	s7,40(sp)
    80002f6a:	f062                	sd	s8,32(sp)
    80002f6c:	ec66                	sd	s9,24(sp)
    80002f6e:	e86a                	sd	s10,16(sp)
    80002f70:	e46e                	sd	s11,8(sp)
    80002f72:	1880                	addi	s0,sp,112
    80002f74:	8b2a                	mv	s6,a0
    80002f76:	8c2e                	mv	s8,a1
    80002f78:	8ab2                	mv	s5,a2
    80002f7a:	8936                	mv	s2,a3
    80002f7c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f7e:	00e687bb          	addw	a5,a3,a4
    80002f82:	0ed7e263          	bltu	a5,a3,80003066 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f86:	00043737          	lui	a4,0x43
    80002f8a:	0ef76063          	bltu	a4,a5,8000306a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8e:	0c0b8863          	beqz	s7,8000305e <writei+0x10e>
    80002f92:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f94:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f98:	5cfd                	li	s9,-1
    80002f9a:	a091                	j	80002fde <writei+0x8e>
    80002f9c:	02099d93          	slli	s11,s3,0x20
    80002fa0:	020ddd93          	srli	s11,s11,0x20
    80002fa4:	05848793          	addi	a5,s1,88
    80002fa8:	86ee                	mv	a3,s11
    80002faa:	8656                	mv	a2,s5
    80002fac:	85e2                	mv	a1,s8
    80002fae:	953e                	add	a0,a0,a5
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	9a6080e7          	jalr	-1626(ra) # 80001956 <either_copyin>
    80002fb8:	07950263          	beq	a0,s9,8000301c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fbc:	8526                	mv	a0,s1
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	790080e7          	jalr	1936(ra) # 8000374e <log_write>
    brelse(bp);
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	50a080e7          	jalr	1290(ra) # 800024d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd0:	01498a3b          	addw	s4,s3,s4
    80002fd4:	0129893b          	addw	s2,s3,s2
    80002fd8:	9aee                	add	s5,s5,s11
    80002fda:	057a7663          	bgeu	s4,s7,80003026 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fde:	000b2483          	lw	s1,0(s6)
    80002fe2:	00a9559b          	srliw	a1,s2,0xa
    80002fe6:	855a                	mv	a0,s6
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	7ae080e7          	jalr	1966(ra) # 80002796 <bmap>
    80002ff0:	0005059b          	sext.w	a1,a0
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	3ac080e7          	jalr	940(ra) # 800023a2 <bread>
    80002ffe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003000:	3ff97513          	andi	a0,s2,1023
    80003004:	40ad07bb          	subw	a5,s10,a0
    80003008:	414b873b          	subw	a4,s7,s4
    8000300c:	89be                	mv	s3,a5
    8000300e:	2781                	sext.w	a5,a5
    80003010:	0007069b          	sext.w	a3,a4
    80003014:	f8f6f4e3          	bgeu	a3,a5,80002f9c <writei+0x4c>
    80003018:	89ba                	mv	s3,a4
    8000301a:	b749                	j	80002f9c <writei+0x4c>
      brelse(bp);
    8000301c:	8526                	mv	a0,s1
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	4b4080e7          	jalr	1204(ra) # 800024d2 <brelse>
  }

  if(off > ip->size)
    80003026:	04cb2783          	lw	a5,76(s6)
    8000302a:	0127f463          	bgeu	a5,s2,80003032 <writei+0xe2>
    ip->size = off;
    8000302e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003032:	855a                	mv	a0,s6
    80003034:	00000097          	auipc	ra,0x0
    80003038:	aa6080e7          	jalr	-1370(ra) # 80002ada <iupdate>

  return tot;
    8000303c:	000a051b          	sext.w	a0,s4
}
    80003040:	70a6                	ld	ra,104(sp)
    80003042:	7406                	ld	s0,96(sp)
    80003044:	64e6                	ld	s1,88(sp)
    80003046:	6946                	ld	s2,80(sp)
    80003048:	69a6                	ld	s3,72(sp)
    8000304a:	6a06                	ld	s4,64(sp)
    8000304c:	7ae2                	ld	s5,56(sp)
    8000304e:	7b42                	ld	s6,48(sp)
    80003050:	7ba2                	ld	s7,40(sp)
    80003052:	7c02                	ld	s8,32(sp)
    80003054:	6ce2                	ld	s9,24(sp)
    80003056:	6d42                	ld	s10,16(sp)
    80003058:	6da2                	ld	s11,8(sp)
    8000305a:	6165                	addi	sp,sp,112
    8000305c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305e:	8a5e                	mv	s4,s7
    80003060:	bfc9                	j	80003032 <writei+0xe2>
    return -1;
    80003062:	557d                	li	a0,-1
}
    80003064:	8082                	ret
    return -1;
    80003066:	557d                	li	a0,-1
    80003068:	bfe1                	j	80003040 <writei+0xf0>
    return -1;
    8000306a:	557d                	li	a0,-1
    8000306c:	bfd1                	j	80003040 <writei+0xf0>

000000008000306e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000306e:	1141                	addi	sp,sp,-16
    80003070:	e406                	sd	ra,8(sp)
    80003072:	e022                	sd	s0,0(sp)
    80003074:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003076:	4639                	li	a2,14
    80003078:	ffffd097          	auipc	ra,0xffffd
    8000307c:	222080e7          	jalr	546(ra) # 8000029a <strncmp>
}
    80003080:	60a2                	ld	ra,8(sp)
    80003082:	6402                	ld	s0,0(sp)
    80003084:	0141                	addi	sp,sp,16
    80003086:	8082                	ret

0000000080003088 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003088:	7139                	addi	sp,sp,-64
    8000308a:	fc06                	sd	ra,56(sp)
    8000308c:	f822                	sd	s0,48(sp)
    8000308e:	f426                	sd	s1,40(sp)
    80003090:	f04a                	sd	s2,32(sp)
    80003092:	ec4e                	sd	s3,24(sp)
    80003094:	e852                	sd	s4,16(sp)
    80003096:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003098:	04451703          	lh	a4,68(a0)
    8000309c:	4785                	li	a5,1
    8000309e:	00f71a63          	bne	a4,a5,800030b2 <dirlookup+0x2a>
    800030a2:	892a                	mv	s2,a0
    800030a4:	89ae                	mv	s3,a1
    800030a6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a8:	457c                	lw	a5,76(a0)
    800030aa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ae:	e79d                	bnez	a5,800030dc <dirlookup+0x54>
    800030b0:	a8a5                	j	80003128 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030b2:	00005517          	auipc	a0,0x5
    800030b6:	65650513          	addi	a0,a0,1622 # 80008708 <syscalls_name+0x1b0>
    800030ba:	00003097          	auipc	ra,0x3
    800030be:	b5a080e7          	jalr	-1190(ra) # 80005c14 <panic>
      panic("dirlookup read");
    800030c2:	00005517          	auipc	a0,0x5
    800030c6:	65e50513          	addi	a0,a0,1630 # 80008720 <syscalls_name+0x1c8>
    800030ca:	00003097          	auipc	ra,0x3
    800030ce:	b4a080e7          	jalr	-1206(ra) # 80005c14 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d2:	24c1                	addiw	s1,s1,16
    800030d4:	04c92783          	lw	a5,76(s2)
    800030d8:	04f4f763          	bgeu	s1,a5,80003126 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030dc:	4741                	li	a4,16
    800030de:	86a6                	mv	a3,s1
    800030e0:	fc040613          	addi	a2,s0,-64
    800030e4:	4581                	li	a1,0
    800030e6:	854a                	mv	a0,s2
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	d70080e7          	jalr	-656(ra) # 80002e58 <readi>
    800030f0:	47c1                	li	a5,16
    800030f2:	fcf518e3          	bne	a0,a5,800030c2 <dirlookup+0x3a>
    if(de.inum == 0)
    800030f6:	fc045783          	lhu	a5,-64(s0)
    800030fa:	dfe1                	beqz	a5,800030d2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030fc:	fc240593          	addi	a1,s0,-62
    80003100:	854e                	mv	a0,s3
    80003102:	00000097          	auipc	ra,0x0
    80003106:	f6c080e7          	jalr	-148(ra) # 8000306e <namecmp>
    8000310a:	f561                	bnez	a0,800030d2 <dirlookup+0x4a>
      if(poff)
    8000310c:	000a0463          	beqz	s4,80003114 <dirlookup+0x8c>
        *poff = off;
    80003110:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003114:	fc045583          	lhu	a1,-64(s0)
    80003118:	00092503          	lw	a0,0(s2)
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	754080e7          	jalr	1876(ra) # 80002870 <iget>
    80003124:	a011                	j	80003128 <dirlookup+0xa0>
  return 0;
    80003126:	4501                	li	a0,0
}
    80003128:	70e2                	ld	ra,56(sp)
    8000312a:	7442                	ld	s0,48(sp)
    8000312c:	74a2                	ld	s1,40(sp)
    8000312e:	7902                	ld	s2,32(sp)
    80003130:	69e2                	ld	s3,24(sp)
    80003132:	6a42                	ld	s4,16(sp)
    80003134:	6121                	addi	sp,sp,64
    80003136:	8082                	ret

0000000080003138 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003138:	711d                	addi	sp,sp,-96
    8000313a:	ec86                	sd	ra,88(sp)
    8000313c:	e8a2                	sd	s0,80(sp)
    8000313e:	e4a6                	sd	s1,72(sp)
    80003140:	e0ca                	sd	s2,64(sp)
    80003142:	fc4e                	sd	s3,56(sp)
    80003144:	f852                	sd	s4,48(sp)
    80003146:	f456                	sd	s5,40(sp)
    80003148:	f05a                	sd	s6,32(sp)
    8000314a:	ec5e                	sd	s7,24(sp)
    8000314c:	e862                	sd	s8,16(sp)
    8000314e:	e466                	sd	s9,8(sp)
    80003150:	1080                	addi	s0,sp,96
    80003152:	84aa                	mv	s1,a0
    80003154:	8aae                	mv	s5,a1
    80003156:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003158:	00054703          	lbu	a4,0(a0)
    8000315c:	02f00793          	li	a5,47
    80003160:	02f70363          	beq	a4,a5,80003186 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003164:	ffffe097          	auipc	ra,0xffffe
    80003168:	d30080e7          	jalr	-720(ra) # 80000e94 <myproc>
    8000316c:	15053503          	ld	a0,336(a0)
    80003170:	00000097          	auipc	ra,0x0
    80003174:	9f6080e7          	jalr	-1546(ra) # 80002b66 <idup>
    80003178:	89aa                	mv	s3,a0
  while(*path == '/')
    8000317a:	02f00913          	li	s2,47
  len = path - s;
    8000317e:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003180:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003182:	4b85                	li	s7,1
    80003184:	a865                	j	8000323c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003186:	4585                	li	a1,1
    80003188:	4505                	li	a0,1
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	6e6080e7          	jalr	1766(ra) # 80002870 <iget>
    80003192:	89aa                	mv	s3,a0
    80003194:	b7dd                	j	8000317a <namex+0x42>
      iunlockput(ip);
    80003196:	854e                	mv	a0,s3
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	c6e080e7          	jalr	-914(ra) # 80002e06 <iunlockput>
      return 0;
    800031a0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031a2:	854e                	mv	a0,s3
    800031a4:	60e6                	ld	ra,88(sp)
    800031a6:	6446                	ld	s0,80(sp)
    800031a8:	64a6                	ld	s1,72(sp)
    800031aa:	6906                	ld	s2,64(sp)
    800031ac:	79e2                	ld	s3,56(sp)
    800031ae:	7a42                	ld	s4,48(sp)
    800031b0:	7aa2                	ld	s5,40(sp)
    800031b2:	7b02                	ld	s6,32(sp)
    800031b4:	6be2                	ld	s7,24(sp)
    800031b6:	6c42                	ld	s8,16(sp)
    800031b8:	6ca2                	ld	s9,8(sp)
    800031ba:	6125                	addi	sp,sp,96
    800031bc:	8082                	ret
      iunlock(ip);
    800031be:	854e                	mv	a0,s3
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	aa6080e7          	jalr	-1370(ra) # 80002c66 <iunlock>
      return ip;
    800031c8:	bfe9                	j	800031a2 <namex+0x6a>
      iunlockput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	c3a080e7          	jalr	-966(ra) # 80002e06 <iunlockput>
      return 0;
    800031d4:	89e6                	mv	s3,s9
    800031d6:	b7f1                	j	800031a2 <namex+0x6a>
  len = path - s;
    800031d8:	40b48633          	sub	a2,s1,a1
    800031dc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031e0:	099c5463          	bge	s8,s9,80003268 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031e4:	4639                	li	a2,14
    800031e6:	8552                	mv	a0,s4
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	03e080e7          	jalr	62(ra) # 80000226 <memmove>
  while(*path == '/')
    800031f0:	0004c783          	lbu	a5,0(s1)
    800031f4:	01279763          	bne	a5,s2,80003202 <namex+0xca>
    path++;
    800031f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031fa:	0004c783          	lbu	a5,0(s1)
    800031fe:	ff278de3          	beq	a5,s2,800031f8 <namex+0xc0>
    ilock(ip);
    80003202:	854e                	mv	a0,s3
    80003204:	00000097          	auipc	ra,0x0
    80003208:	9a0080e7          	jalr	-1632(ra) # 80002ba4 <ilock>
    if(ip->type != T_DIR){
    8000320c:	04499783          	lh	a5,68(s3)
    80003210:	f97793e3          	bne	a5,s7,80003196 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003214:	000a8563          	beqz	s5,8000321e <namex+0xe6>
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	d3cd                	beqz	a5,800031be <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000321e:	865a                	mv	a2,s6
    80003220:	85d2                	mv	a1,s4
    80003222:	854e                	mv	a0,s3
    80003224:	00000097          	auipc	ra,0x0
    80003228:	e64080e7          	jalr	-412(ra) # 80003088 <dirlookup>
    8000322c:	8caa                	mv	s9,a0
    8000322e:	dd51                	beqz	a0,800031ca <namex+0x92>
    iunlockput(ip);
    80003230:	854e                	mv	a0,s3
    80003232:	00000097          	auipc	ra,0x0
    80003236:	bd4080e7          	jalr	-1068(ra) # 80002e06 <iunlockput>
    ip = next;
    8000323a:	89e6                	mv	s3,s9
  while(*path == '/')
    8000323c:	0004c783          	lbu	a5,0(s1)
    80003240:	05279763          	bne	a5,s2,8000328e <namex+0x156>
    path++;
    80003244:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003246:	0004c783          	lbu	a5,0(s1)
    8000324a:	ff278de3          	beq	a5,s2,80003244 <namex+0x10c>
  if(*path == 0)
    8000324e:	c79d                	beqz	a5,8000327c <namex+0x144>
    path++;
    80003250:	85a6                	mv	a1,s1
  len = path - s;
    80003252:	8cda                	mv	s9,s6
    80003254:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003256:	01278963          	beq	a5,s2,80003268 <namex+0x130>
    8000325a:	dfbd                	beqz	a5,800031d8 <namex+0xa0>
    path++;
    8000325c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	ff279ce3          	bne	a5,s2,8000325a <namex+0x122>
    80003266:	bf8d                	j	800031d8 <namex+0xa0>
    memmove(name, s, len);
    80003268:	2601                	sext.w	a2,a2
    8000326a:	8552                	mv	a0,s4
    8000326c:	ffffd097          	auipc	ra,0xffffd
    80003270:	fba080e7          	jalr	-70(ra) # 80000226 <memmove>
    name[len] = 0;
    80003274:	9cd2                	add	s9,s9,s4
    80003276:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000327a:	bf9d                	j	800031f0 <namex+0xb8>
  if(nameiparent){
    8000327c:	f20a83e3          	beqz	s5,800031a2 <namex+0x6a>
    iput(ip);
    80003280:	854e                	mv	a0,s3
    80003282:	00000097          	auipc	ra,0x0
    80003286:	adc080e7          	jalr	-1316(ra) # 80002d5e <iput>
    return 0;
    8000328a:	4981                	li	s3,0
    8000328c:	bf19                	j	800031a2 <namex+0x6a>
  if(*path == 0)
    8000328e:	d7fd                	beqz	a5,8000327c <namex+0x144>
  while(*path != '/' && *path != 0)
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	85a6                	mv	a1,s1
    80003296:	b7d1                	j	8000325a <namex+0x122>

0000000080003298 <dirlink>:
{
    80003298:	7139                	addi	sp,sp,-64
    8000329a:	fc06                	sd	ra,56(sp)
    8000329c:	f822                	sd	s0,48(sp)
    8000329e:	f426                	sd	s1,40(sp)
    800032a0:	f04a                	sd	s2,32(sp)
    800032a2:	ec4e                	sd	s3,24(sp)
    800032a4:	e852                	sd	s4,16(sp)
    800032a6:	0080                	addi	s0,sp,64
    800032a8:	892a                	mv	s2,a0
    800032aa:	8a2e                	mv	s4,a1
    800032ac:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ae:	4601                	li	a2,0
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	dd8080e7          	jalr	-552(ra) # 80003088 <dirlookup>
    800032b8:	e93d                	bnez	a0,8000332e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ba:	04c92483          	lw	s1,76(s2)
    800032be:	c49d                	beqz	s1,800032ec <dirlink+0x54>
    800032c0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c2:	4741                	li	a4,16
    800032c4:	86a6                	mv	a3,s1
    800032c6:	fc040613          	addi	a2,s0,-64
    800032ca:	4581                	li	a1,0
    800032cc:	854a                	mv	a0,s2
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	b8a080e7          	jalr	-1142(ra) # 80002e58 <readi>
    800032d6:	47c1                	li	a5,16
    800032d8:	06f51163          	bne	a0,a5,8000333a <dirlink+0xa2>
    if(de.inum == 0)
    800032dc:	fc045783          	lhu	a5,-64(s0)
    800032e0:	c791                	beqz	a5,800032ec <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e2:	24c1                	addiw	s1,s1,16
    800032e4:	04c92783          	lw	a5,76(s2)
    800032e8:	fcf4ede3          	bltu	s1,a5,800032c2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032ec:	4639                	li	a2,14
    800032ee:	85d2                	mv	a1,s4
    800032f0:	fc240513          	addi	a0,s0,-62
    800032f4:	ffffd097          	auipc	ra,0xffffd
    800032f8:	fe2080e7          	jalr	-30(ra) # 800002d6 <strncpy>
  de.inum = inum;
    800032fc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003300:	4741                	li	a4,16
    80003302:	86a6                	mv	a3,s1
    80003304:	fc040613          	addi	a2,s0,-64
    80003308:	4581                	li	a1,0
    8000330a:	854a                	mv	a0,s2
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	c44080e7          	jalr	-956(ra) # 80002f50 <writei>
    80003314:	872a                	mv	a4,a0
    80003316:	47c1                	li	a5,16
  return 0;
    80003318:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331a:	02f71863          	bne	a4,a5,8000334a <dirlink+0xb2>
}
    8000331e:	70e2                	ld	ra,56(sp)
    80003320:	7442                	ld	s0,48(sp)
    80003322:	74a2                	ld	s1,40(sp)
    80003324:	7902                	ld	s2,32(sp)
    80003326:	69e2                	ld	s3,24(sp)
    80003328:	6a42                	ld	s4,16(sp)
    8000332a:	6121                	addi	sp,sp,64
    8000332c:	8082                	ret
    iput(ip);
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	a30080e7          	jalr	-1488(ra) # 80002d5e <iput>
    return -1;
    80003336:	557d                	li	a0,-1
    80003338:	b7dd                	j	8000331e <dirlink+0x86>
      panic("dirlink read");
    8000333a:	00005517          	auipc	a0,0x5
    8000333e:	3f650513          	addi	a0,a0,1014 # 80008730 <syscalls_name+0x1d8>
    80003342:	00003097          	auipc	ra,0x3
    80003346:	8d2080e7          	jalr	-1838(ra) # 80005c14 <panic>
    panic("dirlink");
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	4ee50513          	addi	a0,a0,1262 # 80008838 <syscalls_name+0x2e0>
    80003352:	00003097          	auipc	ra,0x3
    80003356:	8c2080e7          	jalr	-1854(ra) # 80005c14 <panic>

000000008000335a <namei>:

struct inode*
namei(char *path)
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003362:	fe040613          	addi	a2,s0,-32
    80003366:	4581                	li	a1,0
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	dd0080e7          	jalr	-560(ra) # 80003138 <namex>
}
    80003370:	60e2                	ld	ra,24(sp)
    80003372:	6442                	ld	s0,16(sp)
    80003374:	6105                	addi	sp,sp,32
    80003376:	8082                	ret

0000000080003378 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003378:	1141                	addi	sp,sp,-16
    8000337a:	e406                	sd	ra,8(sp)
    8000337c:	e022                	sd	s0,0(sp)
    8000337e:	0800                	addi	s0,sp,16
    80003380:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003382:	4585                	li	a1,1
    80003384:	00000097          	auipc	ra,0x0
    80003388:	db4080e7          	jalr	-588(ra) # 80003138 <namex>
}
    8000338c:	60a2                	ld	ra,8(sp)
    8000338e:	6402                	ld	s0,0(sp)
    80003390:	0141                	addi	sp,sp,16
    80003392:	8082                	ret

0000000080003394 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003394:	1101                	addi	sp,sp,-32
    80003396:	ec06                	sd	ra,24(sp)
    80003398:	e822                	sd	s0,16(sp)
    8000339a:	e426                	sd	s1,8(sp)
    8000339c:	e04a                	sd	s2,0(sp)
    8000339e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033a0:	00016917          	auipc	s2,0x16
    800033a4:	c8090913          	addi	s2,s2,-896 # 80019020 <log>
    800033a8:	01892583          	lw	a1,24(s2)
    800033ac:	02892503          	lw	a0,40(s2)
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	ff2080e7          	jalr	-14(ra) # 800023a2 <bread>
    800033b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ba:	02c92683          	lw	a3,44(s2)
    800033be:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033c0:	02d05763          	blez	a3,800033ee <write_head+0x5a>
    800033c4:	00016797          	auipc	a5,0x16
    800033c8:	c8c78793          	addi	a5,a5,-884 # 80019050 <log+0x30>
    800033cc:	05c50713          	addi	a4,a0,92
    800033d0:	36fd                	addiw	a3,a3,-1
    800033d2:	1682                	slli	a3,a3,0x20
    800033d4:	9281                	srli	a3,a3,0x20
    800033d6:	068a                	slli	a3,a3,0x2
    800033d8:	00016617          	auipc	a2,0x16
    800033dc:	c7c60613          	addi	a2,a2,-900 # 80019054 <log+0x34>
    800033e0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033e2:	4390                	lw	a2,0(a5)
    800033e4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033e6:	0791                	addi	a5,a5,4
    800033e8:	0711                	addi	a4,a4,4
    800033ea:	fed79ce3          	bne	a5,a3,800033e2 <write_head+0x4e>
  }
  bwrite(buf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	0a4080e7          	jalr	164(ra) # 80002494 <bwrite>
  brelse(buf);
    800033f8:	8526                	mv	a0,s1
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	0d8080e7          	jalr	216(ra) # 800024d2 <brelse>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6902                	ld	s2,0(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret

000000008000340e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340e:	00016797          	auipc	a5,0x16
    80003412:	c3e7a783          	lw	a5,-962(a5) # 8001904c <log+0x2c>
    80003416:	0af05d63          	blez	a5,800034d0 <install_trans+0xc2>
{
    8000341a:	7139                	addi	sp,sp,-64
    8000341c:	fc06                	sd	ra,56(sp)
    8000341e:	f822                	sd	s0,48(sp)
    80003420:	f426                	sd	s1,40(sp)
    80003422:	f04a                	sd	s2,32(sp)
    80003424:	ec4e                	sd	s3,24(sp)
    80003426:	e852                	sd	s4,16(sp)
    80003428:	e456                	sd	s5,8(sp)
    8000342a:	e05a                	sd	s6,0(sp)
    8000342c:	0080                	addi	s0,sp,64
    8000342e:	8b2a                	mv	s6,a0
    80003430:	00016a97          	auipc	s5,0x16
    80003434:	c20a8a93          	addi	s5,s5,-992 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003438:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000343a:	00016997          	auipc	s3,0x16
    8000343e:	be698993          	addi	s3,s3,-1050 # 80019020 <log>
    80003442:	a00d                	j	80003464 <install_trans+0x56>
    brelse(lbuf);
    80003444:	854a                	mv	a0,s2
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	08c080e7          	jalr	140(ra) # 800024d2 <brelse>
    brelse(dbuf);
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	082080e7          	jalr	130(ra) # 800024d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	2a05                	addiw	s4,s4,1
    8000345a:	0a91                	addi	s5,s5,4
    8000345c:	02c9a783          	lw	a5,44(s3)
    80003460:	04fa5e63          	bge	s4,a5,800034bc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003464:	0189a583          	lw	a1,24(s3)
    80003468:	014585bb          	addw	a1,a1,s4
    8000346c:	2585                	addiw	a1,a1,1
    8000346e:	0289a503          	lw	a0,40(s3)
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	f30080e7          	jalr	-208(ra) # 800023a2 <bread>
    8000347a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000347c:	000aa583          	lw	a1,0(s5)
    80003480:	0289a503          	lw	a0,40(s3)
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	f1e080e7          	jalr	-226(ra) # 800023a2 <bread>
    8000348c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000348e:	40000613          	li	a2,1024
    80003492:	05890593          	addi	a1,s2,88
    80003496:	05850513          	addi	a0,a0,88
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	d8c080e7          	jalr	-628(ra) # 80000226 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a2:	8526                	mv	a0,s1
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	ff0080e7          	jalr	-16(ra) # 80002494 <bwrite>
    if(recovering == 0)
    800034ac:	f80b1ce3          	bnez	s6,80003444 <install_trans+0x36>
      bunpin(dbuf);
    800034b0:	8526                	mv	a0,s1
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	0fa080e7          	jalr	250(ra) # 800025ac <bunpin>
    800034ba:	b769                	j	80003444 <install_trans+0x36>
}
    800034bc:	70e2                	ld	ra,56(sp)
    800034be:	7442                	ld	s0,48(sp)
    800034c0:	74a2                	ld	s1,40(sp)
    800034c2:	7902                	ld	s2,32(sp)
    800034c4:	69e2                	ld	s3,24(sp)
    800034c6:	6a42                	ld	s4,16(sp)
    800034c8:	6aa2                	ld	s5,8(sp)
    800034ca:	6b02                	ld	s6,0(sp)
    800034cc:	6121                	addi	sp,sp,64
    800034ce:	8082                	ret
    800034d0:	8082                	ret

00000000800034d2 <initlog>:
{
    800034d2:	7179                	addi	sp,sp,-48
    800034d4:	f406                	sd	ra,40(sp)
    800034d6:	f022                	sd	s0,32(sp)
    800034d8:	ec26                	sd	s1,24(sp)
    800034da:	e84a                	sd	s2,16(sp)
    800034dc:	e44e                	sd	s3,8(sp)
    800034de:	1800                	addi	s0,sp,48
    800034e0:	892a                	mv	s2,a0
    800034e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e4:	00016497          	auipc	s1,0x16
    800034e8:	b3c48493          	addi	s1,s1,-1220 # 80019020 <log>
    800034ec:	00005597          	auipc	a1,0x5
    800034f0:	25458593          	addi	a1,a1,596 # 80008740 <syscalls_name+0x1e8>
    800034f4:	8526                	mv	a0,s1
    800034f6:	00003097          	auipc	ra,0x3
    800034fa:	bca080e7          	jalr	-1078(ra) # 800060c0 <initlock>
  log.start = sb->logstart;
    800034fe:	0149a583          	lw	a1,20(s3)
    80003502:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003504:	0109a783          	lw	a5,16(s3)
    80003508:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000350a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000350e:	854a                	mv	a0,s2
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	e92080e7          	jalr	-366(ra) # 800023a2 <bread>
  log.lh.n = lh->n;
    80003518:	4d34                	lw	a3,88(a0)
    8000351a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000351c:	02d05563          	blez	a3,80003546 <initlog+0x74>
    80003520:	05c50793          	addi	a5,a0,92
    80003524:	00016717          	auipc	a4,0x16
    80003528:	b2c70713          	addi	a4,a4,-1236 # 80019050 <log+0x30>
    8000352c:	36fd                	addiw	a3,a3,-1
    8000352e:	1682                	slli	a3,a3,0x20
    80003530:	9281                	srli	a3,a3,0x20
    80003532:	068a                	slli	a3,a3,0x2
    80003534:	06050613          	addi	a2,a0,96
    80003538:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000353a:	4390                	lw	a2,0(a5)
    8000353c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	0791                	addi	a5,a5,4
    80003540:	0711                	addi	a4,a4,4
    80003542:	fed79ce3          	bne	a5,a3,8000353a <initlog+0x68>
  brelse(buf);
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	f8c080e7          	jalr	-116(ra) # 800024d2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000354e:	4505                	li	a0,1
    80003550:	00000097          	auipc	ra,0x0
    80003554:	ebe080e7          	jalr	-322(ra) # 8000340e <install_trans>
  log.lh.n = 0;
    80003558:	00016797          	auipc	a5,0x16
    8000355c:	ae07aa23          	sw	zero,-1292(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003560:	00000097          	auipc	ra,0x0
    80003564:	e34080e7          	jalr	-460(ra) # 80003394 <write_head>
}
    80003568:	70a2                	ld	ra,40(sp)
    8000356a:	7402                	ld	s0,32(sp)
    8000356c:	64e2                	ld	s1,24(sp)
    8000356e:	6942                	ld	s2,16(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	6145                	addi	sp,sp,48
    80003574:	8082                	ret

0000000080003576 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003576:	1101                	addi	sp,sp,-32
    80003578:	ec06                	sd	ra,24(sp)
    8000357a:	e822                	sd	s0,16(sp)
    8000357c:	e426                	sd	s1,8(sp)
    8000357e:	e04a                	sd	s2,0(sp)
    80003580:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003582:	00016517          	auipc	a0,0x16
    80003586:	a9e50513          	addi	a0,a0,-1378 # 80019020 <log>
    8000358a:	00003097          	auipc	ra,0x3
    8000358e:	bc6080e7          	jalr	-1082(ra) # 80006150 <acquire>
  while(1){
    if(log.committing){
    80003592:	00016497          	auipc	s1,0x16
    80003596:	a8e48493          	addi	s1,s1,-1394 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359a:	4979                	li	s2,30
    8000359c:	a039                	j	800035aa <begin_op+0x34>
      sleep(&log, &log.lock);
    8000359e:	85a6                	mv	a1,s1
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	fba080e7          	jalr	-70(ra) # 8000155c <sleep>
    if(log.committing){
    800035aa:	50dc                	lw	a5,36(s1)
    800035ac:	fbed                	bnez	a5,8000359e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ae:	509c                	lw	a5,32(s1)
    800035b0:	0017871b          	addiw	a4,a5,1
    800035b4:	0007069b          	sext.w	a3,a4
    800035b8:	0027179b          	slliw	a5,a4,0x2
    800035bc:	9fb9                	addw	a5,a5,a4
    800035be:	0017979b          	slliw	a5,a5,0x1
    800035c2:	54d8                	lw	a4,44(s1)
    800035c4:	9fb9                	addw	a5,a5,a4
    800035c6:	00f95963          	bge	s2,a5,800035d8 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ca:	85a6                	mv	a1,s1
    800035cc:	8526                	mv	a0,s1
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	f8e080e7          	jalr	-114(ra) # 8000155c <sleep>
    800035d6:	bfd1                	j	800035aa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035d8:	00016517          	auipc	a0,0x16
    800035dc:	a4850513          	addi	a0,a0,-1464 # 80019020 <log>
    800035e0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	c22080e7          	jalr	-990(ra) # 80006204 <release>
      break;
    }
  }
}
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	64a2                	ld	s1,8(sp)
    800035f0:	6902                	ld	s2,0(sp)
    800035f2:	6105                	addi	sp,sp,32
    800035f4:	8082                	ret

00000000800035f6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035f6:	7139                	addi	sp,sp,-64
    800035f8:	fc06                	sd	ra,56(sp)
    800035fa:	f822                	sd	s0,48(sp)
    800035fc:	f426                	sd	s1,40(sp)
    800035fe:	f04a                	sd	s2,32(sp)
    80003600:	ec4e                	sd	s3,24(sp)
    80003602:	e852                	sd	s4,16(sp)
    80003604:	e456                	sd	s5,8(sp)
    80003606:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003608:	00016497          	auipc	s1,0x16
    8000360c:	a1848493          	addi	s1,s1,-1512 # 80019020 <log>
    80003610:	8526                	mv	a0,s1
    80003612:	00003097          	auipc	ra,0x3
    80003616:	b3e080e7          	jalr	-1218(ra) # 80006150 <acquire>
  log.outstanding -= 1;
    8000361a:	509c                	lw	a5,32(s1)
    8000361c:	37fd                	addiw	a5,a5,-1
    8000361e:	0007891b          	sext.w	s2,a5
    80003622:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003624:	50dc                	lw	a5,36(s1)
    80003626:	e7b9                	bnez	a5,80003674 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003628:	04091e63          	bnez	s2,80003684 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000362c:	00016497          	auipc	s1,0x16
    80003630:	9f448493          	addi	s1,s1,-1548 # 80019020 <log>
    80003634:	4785                	li	a5,1
    80003636:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003638:	8526                	mv	a0,s1
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	bca080e7          	jalr	-1078(ra) # 80006204 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003642:	54dc                	lw	a5,44(s1)
    80003644:	06f04763          	bgtz	a5,800036b2 <end_op+0xbc>
    acquire(&log.lock);
    80003648:	00016497          	auipc	s1,0x16
    8000364c:	9d848493          	addi	s1,s1,-1576 # 80019020 <log>
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	afe080e7          	jalr	-1282(ra) # 80006150 <acquire>
    log.committing = 0;
    8000365a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000365e:	8526                	mv	a0,s1
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	088080e7          	jalr	136(ra) # 800016e8 <wakeup>
    release(&log.lock);
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	b9a080e7          	jalr	-1126(ra) # 80006204 <release>
}
    80003672:	a03d                	j	800036a0 <end_op+0xaa>
    panic("log.committing");
    80003674:	00005517          	auipc	a0,0x5
    80003678:	0d450513          	addi	a0,a0,212 # 80008748 <syscalls_name+0x1f0>
    8000367c:	00002097          	auipc	ra,0x2
    80003680:	598080e7          	jalr	1432(ra) # 80005c14 <panic>
    wakeup(&log);
    80003684:	00016497          	auipc	s1,0x16
    80003688:	99c48493          	addi	s1,s1,-1636 # 80019020 <log>
    8000368c:	8526                	mv	a0,s1
    8000368e:	ffffe097          	auipc	ra,0xffffe
    80003692:	05a080e7          	jalr	90(ra) # 800016e8 <wakeup>
  release(&log.lock);
    80003696:	8526                	mv	a0,s1
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	b6c080e7          	jalr	-1172(ra) # 80006204 <release>
}
    800036a0:	70e2                	ld	ra,56(sp)
    800036a2:	7442                	ld	s0,48(sp)
    800036a4:	74a2                	ld	s1,40(sp)
    800036a6:	7902                	ld	s2,32(sp)
    800036a8:	69e2                	ld	s3,24(sp)
    800036aa:	6a42                	ld	s4,16(sp)
    800036ac:	6aa2                	ld	s5,8(sp)
    800036ae:	6121                	addi	sp,sp,64
    800036b0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b2:	00016a97          	auipc	s5,0x16
    800036b6:	99ea8a93          	addi	s5,s5,-1634 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ba:	00016a17          	auipc	s4,0x16
    800036be:	966a0a13          	addi	s4,s4,-1690 # 80019020 <log>
    800036c2:	018a2583          	lw	a1,24(s4)
    800036c6:	012585bb          	addw	a1,a1,s2
    800036ca:	2585                	addiw	a1,a1,1
    800036cc:	028a2503          	lw	a0,40(s4)
    800036d0:	fffff097          	auipc	ra,0xfffff
    800036d4:	cd2080e7          	jalr	-814(ra) # 800023a2 <bread>
    800036d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036da:	000aa583          	lw	a1,0(s5)
    800036de:	028a2503          	lw	a0,40(s4)
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	cc0080e7          	jalr	-832(ra) # 800023a2 <bread>
    800036ea:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036ec:	40000613          	li	a2,1024
    800036f0:	05850593          	addi	a1,a0,88
    800036f4:	05848513          	addi	a0,s1,88
    800036f8:	ffffd097          	auipc	ra,0xffffd
    800036fc:	b2e080e7          	jalr	-1234(ra) # 80000226 <memmove>
    bwrite(to);  // write the log
    80003700:	8526                	mv	a0,s1
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	d92080e7          	jalr	-622(ra) # 80002494 <bwrite>
    brelse(from);
    8000370a:	854e                	mv	a0,s3
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	dc6080e7          	jalr	-570(ra) # 800024d2 <brelse>
    brelse(to);
    80003714:	8526                	mv	a0,s1
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	dbc080e7          	jalr	-580(ra) # 800024d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371e:	2905                	addiw	s2,s2,1
    80003720:	0a91                	addi	s5,s5,4
    80003722:	02ca2783          	lw	a5,44(s4)
    80003726:	f8f94ee3          	blt	s2,a5,800036c2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	c6a080e7          	jalr	-918(ra) # 80003394 <write_head>
    install_trans(0); // Now install writes to home locations
    80003732:	4501                	li	a0,0
    80003734:	00000097          	auipc	ra,0x0
    80003738:	cda080e7          	jalr	-806(ra) # 8000340e <install_trans>
    log.lh.n = 0;
    8000373c:	00016797          	auipc	a5,0x16
    80003740:	9007a823          	sw	zero,-1776(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003744:	00000097          	auipc	ra,0x0
    80003748:	c50080e7          	jalr	-944(ra) # 80003394 <write_head>
    8000374c:	bdf5                	j	80003648 <end_op+0x52>

000000008000374e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000374e:	1101                	addi	sp,sp,-32
    80003750:	ec06                	sd	ra,24(sp)
    80003752:	e822                	sd	s0,16(sp)
    80003754:	e426                	sd	s1,8(sp)
    80003756:	e04a                	sd	s2,0(sp)
    80003758:	1000                	addi	s0,sp,32
    8000375a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000375c:	00016917          	auipc	s2,0x16
    80003760:	8c490913          	addi	s2,s2,-1852 # 80019020 <log>
    80003764:	854a                	mv	a0,s2
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	9ea080e7          	jalr	-1558(ra) # 80006150 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000376e:	02c92603          	lw	a2,44(s2)
    80003772:	47f5                	li	a5,29
    80003774:	06c7c563          	blt	a5,a2,800037de <log_write+0x90>
    80003778:	00016797          	auipc	a5,0x16
    8000377c:	8c47a783          	lw	a5,-1852(a5) # 8001903c <log+0x1c>
    80003780:	37fd                	addiw	a5,a5,-1
    80003782:	04f65e63          	bge	a2,a5,800037de <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003786:	00016797          	auipc	a5,0x16
    8000378a:	8ba7a783          	lw	a5,-1862(a5) # 80019040 <log+0x20>
    8000378e:	06f05063          	blez	a5,800037ee <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003792:	4781                	li	a5,0
    80003794:	06c05563          	blez	a2,800037fe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003798:	44cc                	lw	a1,12(s1)
    8000379a:	00016717          	auipc	a4,0x16
    8000379e:	8b670713          	addi	a4,a4,-1866 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037a2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a4:	4314                	lw	a3,0(a4)
    800037a6:	04b68c63          	beq	a3,a1,800037fe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037aa:	2785                	addiw	a5,a5,1
    800037ac:	0711                	addi	a4,a4,4
    800037ae:	fef61be3          	bne	a2,a5,800037a4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037b2:	0621                	addi	a2,a2,8
    800037b4:	060a                	slli	a2,a2,0x2
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	86a78793          	addi	a5,a5,-1942 # 80019020 <log>
    800037be:	963e                	add	a2,a2,a5
    800037c0:	44dc                	lw	a5,12(s1)
    800037c2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037c4:	8526                	mv	a0,s1
    800037c6:	fffff097          	auipc	ra,0xfffff
    800037ca:	daa080e7          	jalr	-598(ra) # 80002570 <bpin>
    log.lh.n++;
    800037ce:	00016717          	auipc	a4,0x16
    800037d2:	85270713          	addi	a4,a4,-1966 # 80019020 <log>
    800037d6:	575c                	lw	a5,44(a4)
    800037d8:	2785                	addiw	a5,a5,1
    800037da:	d75c                	sw	a5,44(a4)
    800037dc:	a835                	j	80003818 <log_write+0xca>
    panic("too big a transaction");
    800037de:	00005517          	auipc	a0,0x5
    800037e2:	f7a50513          	addi	a0,a0,-134 # 80008758 <syscalls_name+0x200>
    800037e6:	00002097          	auipc	ra,0x2
    800037ea:	42e080e7          	jalr	1070(ra) # 80005c14 <panic>
    panic("log_write outside of trans");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	f8250513          	addi	a0,a0,-126 # 80008770 <syscalls_name+0x218>
    800037f6:	00002097          	auipc	ra,0x2
    800037fa:	41e080e7          	jalr	1054(ra) # 80005c14 <panic>
  log.lh.block[i] = b->blockno;
    800037fe:	00878713          	addi	a4,a5,8
    80003802:	00271693          	slli	a3,a4,0x2
    80003806:	00016717          	auipc	a4,0x16
    8000380a:	81a70713          	addi	a4,a4,-2022 # 80019020 <log>
    8000380e:	9736                	add	a4,a4,a3
    80003810:	44d4                	lw	a3,12(s1)
    80003812:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003814:	faf608e3          	beq	a2,a5,800037c4 <log_write+0x76>
  }
  release(&log.lock);
    80003818:	00016517          	auipc	a0,0x16
    8000381c:	80850513          	addi	a0,a0,-2040 # 80019020 <log>
    80003820:	00003097          	auipc	ra,0x3
    80003824:	9e4080e7          	jalr	-1564(ra) # 80006204 <release>
}
    80003828:	60e2                	ld	ra,24(sp)
    8000382a:	6442                	ld	s0,16(sp)
    8000382c:	64a2                	ld	s1,8(sp)
    8000382e:	6902                	ld	s2,0(sp)
    80003830:	6105                	addi	sp,sp,32
    80003832:	8082                	ret

0000000080003834 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003834:	1101                	addi	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	addi	s0,sp,32
    80003840:	84aa                	mv	s1,a0
    80003842:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003844:	00005597          	auipc	a1,0x5
    80003848:	f4c58593          	addi	a1,a1,-180 # 80008790 <syscalls_name+0x238>
    8000384c:	0521                	addi	a0,a0,8
    8000384e:	00003097          	auipc	ra,0x3
    80003852:	872080e7          	jalr	-1934(ra) # 800060c0 <initlock>
  lk->name = name;
    80003856:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000385a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000385e:	0204a423          	sw	zero,40(s1)
}
    80003862:	60e2                	ld	ra,24(sp)
    80003864:	6442                	ld	s0,16(sp)
    80003866:	64a2                	ld	s1,8(sp)
    80003868:	6902                	ld	s2,0(sp)
    8000386a:	6105                	addi	sp,sp,32
    8000386c:	8082                	ret

000000008000386e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000386e:	1101                	addi	sp,sp,-32
    80003870:	ec06                	sd	ra,24(sp)
    80003872:	e822                	sd	s0,16(sp)
    80003874:	e426                	sd	s1,8(sp)
    80003876:	e04a                	sd	s2,0(sp)
    80003878:	1000                	addi	s0,sp,32
    8000387a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000387c:	00850913          	addi	s2,a0,8
    80003880:	854a                	mv	a0,s2
    80003882:	00003097          	auipc	ra,0x3
    80003886:	8ce080e7          	jalr	-1842(ra) # 80006150 <acquire>
  while (lk->locked) {
    8000388a:	409c                	lw	a5,0(s1)
    8000388c:	cb89                	beqz	a5,8000389e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000388e:	85ca                	mv	a1,s2
    80003890:	8526                	mv	a0,s1
    80003892:	ffffe097          	auipc	ra,0xffffe
    80003896:	cca080e7          	jalr	-822(ra) # 8000155c <sleep>
  while (lk->locked) {
    8000389a:	409c                	lw	a5,0(s1)
    8000389c:	fbed                	bnez	a5,8000388e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000389e:	4785                	li	a5,1
    800038a0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	5f2080e7          	jalr	1522(ra) # 80000e94 <myproc>
    800038aa:	591c                	lw	a5,48(a0)
    800038ac:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ae:	854a                	mv	a0,s2
    800038b0:	00003097          	auipc	ra,0x3
    800038b4:	954080e7          	jalr	-1708(ra) # 80006204 <release>
}
    800038b8:	60e2                	ld	ra,24(sp)
    800038ba:	6442                	ld	s0,16(sp)
    800038bc:	64a2                	ld	s1,8(sp)
    800038be:	6902                	ld	s2,0(sp)
    800038c0:	6105                	addi	sp,sp,32
    800038c2:	8082                	ret

00000000800038c4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	e426                	sd	s1,8(sp)
    800038cc:	e04a                	sd	s2,0(sp)
    800038ce:	1000                	addi	s0,sp,32
    800038d0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d2:	00850913          	addi	s2,a0,8
    800038d6:	854a                	mv	a0,s2
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	878080e7          	jalr	-1928(ra) # 80006150 <acquire>
  lk->locked = 0;
    800038e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	dfe080e7          	jalr	-514(ra) # 800016e8 <wakeup>
  release(&lk->lk);
    800038f2:	854a                	mv	a0,s2
    800038f4:	00003097          	auipc	ra,0x3
    800038f8:	910080e7          	jalr	-1776(ra) # 80006204 <release>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret

0000000080003908 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003908:	7179                	addi	sp,sp,-48
    8000390a:	f406                	sd	ra,40(sp)
    8000390c:	f022                	sd	s0,32(sp)
    8000390e:	ec26                	sd	s1,24(sp)
    80003910:	e84a                	sd	s2,16(sp)
    80003912:	e44e                	sd	s3,8(sp)
    80003914:	1800                	addi	s0,sp,48
    80003916:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003918:	00850913          	addi	s2,a0,8
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	832080e7          	jalr	-1998(ra) # 80006150 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003926:	409c                	lw	a5,0(s1)
    80003928:	ef99                	bnez	a5,80003946 <holdingsleep+0x3e>
    8000392a:	4481                	li	s1,0
  release(&lk->lk);
    8000392c:	854a                	mv	a0,s2
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	8d6080e7          	jalr	-1834(ra) # 80006204 <release>
  return r;
}
    80003936:	8526                	mv	a0,s1
    80003938:	70a2                	ld	ra,40(sp)
    8000393a:	7402                	ld	s0,32(sp)
    8000393c:	64e2                	ld	s1,24(sp)
    8000393e:	6942                	ld	s2,16(sp)
    80003940:	69a2                	ld	s3,8(sp)
    80003942:	6145                	addi	sp,sp,48
    80003944:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003946:	0284a983          	lw	s3,40(s1)
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	54a080e7          	jalr	1354(ra) # 80000e94 <myproc>
    80003952:	5904                	lw	s1,48(a0)
    80003954:	413484b3          	sub	s1,s1,s3
    80003958:	0014b493          	seqz	s1,s1
    8000395c:	bfc1                	j	8000392c <holdingsleep+0x24>

000000008000395e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000395e:	1141                	addi	sp,sp,-16
    80003960:	e406                	sd	ra,8(sp)
    80003962:	e022                	sd	s0,0(sp)
    80003964:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003966:	00005597          	auipc	a1,0x5
    8000396a:	e3a58593          	addi	a1,a1,-454 # 800087a0 <syscalls_name+0x248>
    8000396e:	00015517          	auipc	a0,0x15
    80003972:	7fa50513          	addi	a0,a0,2042 # 80019168 <ftable>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	74a080e7          	jalr	1866(ra) # 800060c0 <initlock>
}
    8000397e:	60a2                	ld	ra,8(sp)
    80003980:	6402                	ld	s0,0(sp)
    80003982:	0141                	addi	sp,sp,16
    80003984:	8082                	ret

0000000080003986 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003986:	1101                	addi	sp,sp,-32
    80003988:	ec06                	sd	ra,24(sp)
    8000398a:	e822                	sd	s0,16(sp)
    8000398c:	e426                	sd	s1,8(sp)
    8000398e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003990:	00015517          	auipc	a0,0x15
    80003994:	7d850513          	addi	a0,a0,2008 # 80019168 <ftable>
    80003998:	00002097          	auipc	ra,0x2
    8000399c:	7b8080e7          	jalr	1976(ra) # 80006150 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a0:	00015497          	auipc	s1,0x15
    800039a4:	7e048493          	addi	s1,s1,2016 # 80019180 <ftable+0x18>
    800039a8:	00016717          	auipc	a4,0x16
    800039ac:	77870713          	addi	a4,a4,1912 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039b0:	40dc                	lw	a5,4(s1)
    800039b2:	cf99                	beqz	a5,800039d0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b4:	02848493          	addi	s1,s1,40
    800039b8:	fee49ce3          	bne	s1,a4,800039b0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039bc:	00015517          	auipc	a0,0x15
    800039c0:	7ac50513          	addi	a0,a0,1964 # 80019168 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	840080e7          	jalr	-1984(ra) # 80006204 <release>
  return 0;
    800039cc:	4481                	li	s1,0
    800039ce:	a819                	j	800039e4 <filealloc+0x5e>
      f->ref = 1;
    800039d0:	4785                	li	a5,1
    800039d2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039d4:	00015517          	auipc	a0,0x15
    800039d8:	79450513          	addi	a0,a0,1940 # 80019168 <ftable>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	828080e7          	jalr	-2008(ra) # 80006204 <release>
}
    800039e4:	8526                	mv	a0,s1
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	1000                	addi	s0,sp,32
    800039fa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039fc:	00015517          	auipc	a0,0x15
    80003a00:	76c50513          	addi	a0,a0,1900 # 80019168 <ftable>
    80003a04:	00002097          	auipc	ra,0x2
    80003a08:	74c080e7          	jalr	1868(ra) # 80006150 <acquire>
  if(f->ref < 1)
    80003a0c:	40dc                	lw	a5,4(s1)
    80003a0e:	02f05263          	blez	a5,80003a32 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a12:	2785                	addiw	a5,a5,1
    80003a14:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a16:	00015517          	auipc	a0,0x15
    80003a1a:	75250513          	addi	a0,a0,1874 # 80019168 <ftable>
    80003a1e:	00002097          	auipc	ra,0x2
    80003a22:	7e6080e7          	jalr	2022(ra) # 80006204 <release>
  return f;
}
    80003a26:	8526                	mv	a0,s1
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret
    panic("filedup");
    80003a32:	00005517          	auipc	a0,0x5
    80003a36:	d7650513          	addi	a0,a0,-650 # 800087a8 <syscalls_name+0x250>
    80003a3a:	00002097          	auipc	ra,0x2
    80003a3e:	1da080e7          	jalr	474(ra) # 80005c14 <panic>

0000000080003a42 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a42:	7139                	addi	sp,sp,-64
    80003a44:	fc06                	sd	ra,56(sp)
    80003a46:	f822                	sd	s0,48(sp)
    80003a48:	f426                	sd	s1,40(sp)
    80003a4a:	f04a                	sd	s2,32(sp)
    80003a4c:	ec4e                	sd	s3,24(sp)
    80003a4e:	e852                	sd	s4,16(sp)
    80003a50:	e456                	sd	s5,8(sp)
    80003a52:	0080                	addi	s0,sp,64
    80003a54:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a56:	00015517          	auipc	a0,0x15
    80003a5a:	71250513          	addi	a0,a0,1810 # 80019168 <ftable>
    80003a5e:	00002097          	auipc	ra,0x2
    80003a62:	6f2080e7          	jalr	1778(ra) # 80006150 <acquire>
  if(f->ref < 1)
    80003a66:	40dc                	lw	a5,4(s1)
    80003a68:	06f05163          	blez	a5,80003aca <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a6c:	37fd                	addiw	a5,a5,-1
    80003a6e:	0007871b          	sext.w	a4,a5
    80003a72:	c0dc                	sw	a5,4(s1)
    80003a74:	06e04363          	bgtz	a4,80003ada <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a78:	0004a903          	lw	s2,0(s1)
    80003a7c:	0094ca83          	lbu	s5,9(s1)
    80003a80:	0104ba03          	ld	s4,16(s1)
    80003a84:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a88:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a8c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a90:	00015517          	auipc	a0,0x15
    80003a94:	6d850513          	addi	a0,a0,1752 # 80019168 <ftable>
    80003a98:	00002097          	auipc	ra,0x2
    80003a9c:	76c080e7          	jalr	1900(ra) # 80006204 <release>

  if(ff.type == FD_PIPE){
    80003aa0:	4785                	li	a5,1
    80003aa2:	04f90d63          	beq	s2,a5,80003afc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aa6:	3979                	addiw	s2,s2,-2
    80003aa8:	4785                	li	a5,1
    80003aaa:	0527e063          	bltu	a5,s2,80003aea <fileclose+0xa8>
    begin_op();
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	ac8080e7          	jalr	-1336(ra) # 80003576 <begin_op>
    iput(ff.ip);
    80003ab6:	854e                	mv	a0,s3
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	2a6080e7          	jalr	678(ra) # 80002d5e <iput>
    end_op();
    80003ac0:	00000097          	auipc	ra,0x0
    80003ac4:	b36080e7          	jalr	-1226(ra) # 800035f6 <end_op>
    80003ac8:	a00d                	j	80003aea <fileclose+0xa8>
    panic("fileclose");
    80003aca:	00005517          	auipc	a0,0x5
    80003ace:	ce650513          	addi	a0,a0,-794 # 800087b0 <syscalls_name+0x258>
    80003ad2:	00002097          	auipc	ra,0x2
    80003ad6:	142080e7          	jalr	322(ra) # 80005c14 <panic>
    release(&ftable.lock);
    80003ada:	00015517          	auipc	a0,0x15
    80003ade:	68e50513          	addi	a0,a0,1678 # 80019168 <ftable>
    80003ae2:	00002097          	auipc	ra,0x2
    80003ae6:	722080e7          	jalr	1826(ra) # 80006204 <release>
  }
}
    80003aea:	70e2                	ld	ra,56(sp)
    80003aec:	7442                	ld	s0,48(sp)
    80003aee:	74a2                	ld	s1,40(sp)
    80003af0:	7902                	ld	s2,32(sp)
    80003af2:	69e2                	ld	s3,24(sp)
    80003af4:	6a42                	ld	s4,16(sp)
    80003af6:	6aa2                	ld	s5,8(sp)
    80003af8:	6121                	addi	sp,sp,64
    80003afa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003afc:	85d6                	mv	a1,s5
    80003afe:	8552                	mv	a0,s4
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	34c080e7          	jalr	844(ra) # 80003e4c <pipeclose>
    80003b08:	b7cd                	j	80003aea <fileclose+0xa8>

0000000080003b0a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b0a:	715d                	addi	sp,sp,-80
    80003b0c:	e486                	sd	ra,72(sp)
    80003b0e:	e0a2                	sd	s0,64(sp)
    80003b10:	fc26                	sd	s1,56(sp)
    80003b12:	f84a                	sd	s2,48(sp)
    80003b14:	f44e                	sd	s3,40(sp)
    80003b16:	0880                	addi	s0,sp,80
    80003b18:	84aa                	mv	s1,a0
    80003b1a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b1c:	ffffd097          	auipc	ra,0xffffd
    80003b20:	378080e7          	jalr	888(ra) # 80000e94 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b24:	409c                	lw	a5,0(s1)
    80003b26:	37f9                	addiw	a5,a5,-2
    80003b28:	4705                	li	a4,1
    80003b2a:	04f76763          	bltu	a4,a5,80003b78 <filestat+0x6e>
    80003b2e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b30:	6c88                	ld	a0,24(s1)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	072080e7          	jalr	114(ra) # 80002ba4 <ilock>
    stati(f->ip, &st);
    80003b3a:	fb840593          	addi	a1,s0,-72
    80003b3e:	6c88                	ld	a0,24(s1)
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	2ee080e7          	jalr	750(ra) # 80002e2e <stati>
    iunlock(f->ip);
    80003b48:	6c88                	ld	a0,24(s1)
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	11c080e7          	jalr	284(ra) # 80002c66 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b52:	46e1                	li	a3,24
    80003b54:	fb840613          	addi	a2,s0,-72
    80003b58:	85ce                	mv	a1,s3
    80003b5a:	05093503          	ld	a0,80(s2)
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	ff6080e7          	jalr	-10(ra) # 80000b54 <copyout>
    80003b66:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b6a:	60a6                	ld	ra,72(sp)
    80003b6c:	6406                	ld	s0,64(sp)
    80003b6e:	74e2                	ld	s1,56(sp)
    80003b70:	7942                	ld	s2,48(sp)
    80003b72:	79a2                	ld	s3,40(sp)
    80003b74:	6161                	addi	sp,sp,80
    80003b76:	8082                	ret
  return -1;
    80003b78:	557d                	li	a0,-1
    80003b7a:	bfc5                	j	80003b6a <filestat+0x60>

0000000080003b7c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b7c:	7179                	addi	sp,sp,-48
    80003b7e:	f406                	sd	ra,40(sp)
    80003b80:	f022                	sd	s0,32(sp)
    80003b82:	ec26                	sd	s1,24(sp)
    80003b84:	e84a                	sd	s2,16(sp)
    80003b86:	e44e                	sd	s3,8(sp)
    80003b88:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b8a:	00854783          	lbu	a5,8(a0)
    80003b8e:	c3d5                	beqz	a5,80003c32 <fileread+0xb6>
    80003b90:	84aa                	mv	s1,a0
    80003b92:	89ae                	mv	s3,a1
    80003b94:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b96:	411c                	lw	a5,0(a0)
    80003b98:	4705                	li	a4,1
    80003b9a:	04e78963          	beq	a5,a4,80003bec <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9e:	470d                	li	a4,3
    80003ba0:	04e78d63          	beq	a5,a4,80003bfa <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba4:	4709                	li	a4,2
    80003ba6:	06e79e63          	bne	a5,a4,80003c22 <fileread+0xa6>
    ilock(f->ip);
    80003baa:	6d08                	ld	a0,24(a0)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	ff8080e7          	jalr	-8(ra) # 80002ba4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bb4:	874a                	mv	a4,s2
    80003bb6:	5094                	lw	a3,32(s1)
    80003bb8:	864e                	mv	a2,s3
    80003bba:	4585                	li	a1,1
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	29a080e7          	jalr	666(ra) # 80002e58 <readi>
    80003bc6:	892a                	mv	s2,a0
    80003bc8:	00a05563          	blez	a0,80003bd2 <fileread+0x56>
      f->off += r;
    80003bcc:	509c                	lw	a5,32(s1)
    80003bce:	9fa9                	addw	a5,a5,a0
    80003bd0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bd2:	6c88                	ld	a0,24(s1)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	092080e7          	jalr	146(ra) # 80002c66 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bdc:	854a                	mv	a0,s2
    80003bde:	70a2                	ld	ra,40(sp)
    80003be0:	7402                	ld	s0,32(sp)
    80003be2:	64e2                	ld	s1,24(sp)
    80003be4:	6942                	ld	s2,16(sp)
    80003be6:	69a2                	ld	s3,8(sp)
    80003be8:	6145                	addi	sp,sp,48
    80003bea:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bec:	6908                	ld	a0,16(a0)
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	3c0080e7          	jalr	960(ra) # 80003fae <piperead>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	b7d5                	j	80003bdc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bfa:	02451783          	lh	a5,36(a0)
    80003bfe:	03079693          	slli	a3,a5,0x30
    80003c02:	92c1                	srli	a3,a3,0x30
    80003c04:	4725                	li	a4,9
    80003c06:	02d76863          	bltu	a4,a3,80003c36 <fileread+0xba>
    80003c0a:	0792                	slli	a5,a5,0x4
    80003c0c:	00015717          	auipc	a4,0x15
    80003c10:	4bc70713          	addi	a4,a4,1212 # 800190c8 <devsw>
    80003c14:	97ba                	add	a5,a5,a4
    80003c16:	639c                	ld	a5,0(a5)
    80003c18:	c38d                	beqz	a5,80003c3a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c1a:	4505                	li	a0,1
    80003c1c:	9782                	jalr	a5
    80003c1e:	892a                	mv	s2,a0
    80003c20:	bf75                	j	80003bdc <fileread+0x60>
    panic("fileread");
    80003c22:	00005517          	auipc	a0,0x5
    80003c26:	b9e50513          	addi	a0,a0,-1122 # 800087c0 <syscalls_name+0x268>
    80003c2a:	00002097          	auipc	ra,0x2
    80003c2e:	fea080e7          	jalr	-22(ra) # 80005c14 <panic>
    return -1;
    80003c32:	597d                	li	s2,-1
    80003c34:	b765                	j	80003bdc <fileread+0x60>
      return -1;
    80003c36:	597d                	li	s2,-1
    80003c38:	b755                	j	80003bdc <fileread+0x60>
    80003c3a:	597d                	li	s2,-1
    80003c3c:	b745                	j	80003bdc <fileread+0x60>

0000000080003c3e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c3e:	715d                	addi	sp,sp,-80
    80003c40:	e486                	sd	ra,72(sp)
    80003c42:	e0a2                	sd	s0,64(sp)
    80003c44:	fc26                	sd	s1,56(sp)
    80003c46:	f84a                	sd	s2,48(sp)
    80003c48:	f44e                	sd	s3,40(sp)
    80003c4a:	f052                	sd	s4,32(sp)
    80003c4c:	ec56                	sd	s5,24(sp)
    80003c4e:	e85a                	sd	s6,16(sp)
    80003c50:	e45e                	sd	s7,8(sp)
    80003c52:	e062                	sd	s8,0(sp)
    80003c54:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c56:	00954783          	lbu	a5,9(a0)
    80003c5a:	10078663          	beqz	a5,80003d66 <filewrite+0x128>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	8aae                	mv	s5,a1
    80003c62:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c64:	411c                	lw	a5,0(a0)
    80003c66:	4705                	li	a4,1
    80003c68:	02e78263          	beq	a5,a4,80003c8c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c6c:	470d                	li	a4,3
    80003c6e:	02e78663          	beq	a5,a4,80003c9a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c72:	4709                	li	a4,2
    80003c74:	0ee79163          	bne	a5,a4,80003d56 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c78:	0ac05d63          	blez	a2,80003d32 <filewrite+0xf4>
    int i = 0;
    80003c7c:	4981                	li	s3,0
    80003c7e:	6b05                	lui	s6,0x1
    80003c80:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c84:	6b85                	lui	s7,0x1
    80003c86:	c00b8b9b          	addiw	s7,s7,-1024
    80003c8a:	a861                	j	80003d22 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c8c:	6908                	ld	a0,16(a0)
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	22e080e7          	jalr	558(ra) # 80003ebc <pipewrite>
    80003c96:	8a2a                	mv	s4,a0
    80003c98:	a045                	j	80003d38 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c9a:	02451783          	lh	a5,36(a0)
    80003c9e:	03079693          	slli	a3,a5,0x30
    80003ca2:	92c1                	srli	a3,a3,0x30
    80003ca4:	4725                	li	a4,9
    80003ca6:	0cd76263          	bltu	a4,a3,80003d6a <filewrite+0x12c>
    80003caa:	0792                	slli	a5,a5,0x4
    80003cac:	00015717          	auipc	a4,0x15
    80003cb0:	41c70713          	addi	a4,a4,1052 # 800190c8 <devsw>
    80003cb4:	97ba                	add	a5,a5,a4
    80003cb6:	679c                	ld	a5,8(a5)
    80003cb8:	cbdd                	beqz	a5,80003d6e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cba:	4505                	li	a0,1
    80003cbc:	9782                	jalr	a5
    80003cbe:	8a2a                	mv	s4,a0
    80003cc0:	a8a5                	j	80003d38 <filewrite+0xfa>
    80003cc2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	8b0080e7          	jalr	-1872(ra) # 80003576 <begin_op>
      ilock(f->ip);
    80003cce:	01893503          	ld	a0,24(s2)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	ed2080e7          	jalr	-302(ra) # 80002ba4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cda:	8762                	mv	a4,s8
    80003cdc:	02092683          	lw	a3,32(s2)
    80003ce0:	01598633          	add	a2,s3,s5
    80003ce4:	4585                	li	a1,1
    80003ce6:	01893503          	ld	a0,24(s2)
    80003cea:	fffff097          	auipc	ra,0xfffff
    80003cee:	266080e7          	jalr	614(ra) # 80002f50 <writei>
    80003cf2:	84aa                	mv	s1,a0
    80003cf4:	00a05763          	blez	a0,80003d02 <filewrite+0xc4>
        f->off += r;
    80003cf8:	02092783          	lw	a5,32(s2)
    80003cfc:	9fa9                	addw	a5,a5,a0
    80003cfe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d02:	01893503          	ld	a0,24(s2)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	f60080e7          	jalr	-160(ra) # 80002c66 <iunlock>
      end_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	8e8080e7          	jalr	-1816(ra) # 800035f6 <end_op>

      if(r != n1){
    80003d16:	009c1f63          	bne	s8,s1,80003d34 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d1a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d1e:	0149db63          	bge	s3,s4,80003d34 <filewrite+0xf6>
      int n1 = n - i;
    80003d22:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d26:	84be                	mv	s1,a5
    80003d28:	2781                	sext.w	a5,a5
    80003d2a:	f8fb5ce3          	bge	s6,a5,80003cc2 <filewrite+0x84>
    80003d2e:	84de                	mv	s1,s7
    80003d30:	bf49                	j	80003cc2 <filewrite+0x84>
    int i = 0;
    80003d32:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d34:	013a1f63          	bne	s4,s3,80003d52 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d38:	8552                	mv	a0,s4
    80003d3a:	60a6                	ld	ra,72(sp)
    80003d3c:	6406                	ld	s0,64(sp)
    80003d3e:	74e2                	ld	s1,56(sp)
    80003d40:	7942                	ld	s2,48(sp)
    80003d42:	79a2                	ld	s3,40(sp)
    80003d44:	7a02                	ld	s4,32(sp)
    80003d46:	6ae2                	ld	s5,24(sp)
    80003d48:	6b42                	ld	s6,16(sp)
    80003d4a:	6ba2                	ld	s7,8(sp)
    80003d4c:	6c02                	ld	s8,0(sp)
    80003d4e:	6161                	addi	sp,sp,80
    80003d50:	8082                	ret
    ret = (i == n ? n : -1);
    80003d52:	5a7d                	li	s4,-1
    80003d54:	b7d5                	j	80003d38 <filewrite+0xfa>
    panic("filewrite");
    80003d56:	00005517          	auipc	a0,0x5
    80003d5a:	a7a50513          	addi	a0,a0,-1414 # 800087d0 <syscalls_name+0x278>
    80003d5e:	00002097          	auipc	ra,0x2
    80003d62:	eb6080e7          	jalr	-330(ra) # 80005c14 <panic>
    return -1;
    80003d66:	5a7d                	li	s4,-1
    80003d68:	bfc1                	j	80003d38 <filewrite+0xfa>
      return -1;
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	b7f1                	j	80003d38 <filewrite+0xfa>
    80003d6e:	5a7d                	li	s4,-1
    80003d70:	b7e1                	j	80003d38 <filewrite+0xfa>

0000000080003d72 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d72:	7179                	addi	sp,sp,-48
    80003d74:	f406                	sd	ra,40(sp)
    80003d76:	f022                	sd	s0,32(sp)
    80003d78:	ec26                	sd	s1,24(sp)
    80003d7a:	e84a                	sd	s2,16(sp)
    80003d7c:	e44e                	sd	s3,8(sp)
    80003d7e:	e052                	sd	s4,0(sp)
    80003d80:	1800                	addi	s0,sp,48
    80003d82:	84aa                	mv	s1,a0
    80003d84:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d86:	0005b023          	sd	zero,0(a1)
    80003d8a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	bf8080e7          	jalr	-1032(ra) # 80003986 <filealloc>
    80003d96:	e088                	sd	a0,0(s1)
    80003d98:	c551                	beqz	a0,80003e24 <pipealloc+0xb2>
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	bec080e7          	jalr	-1044(ra) # 80003986 <filealloc>
    80003da2:	00aa3023          	sd	a0,0(s4)
    80003da6:	c92d                	beqz	a0,80003e18 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003da8:	ffffc097          	auipc	ra,0xffffc
    80003dac:	370080e7          	jalr	880(ra) # 80000118 <kalloc>
    80003db0:	892a                	mv	s2,a0
    80003db2:	c125                	beqz	a0,80003e12 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db4:	4985                	li	s3,1
    80003db6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dbe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dc2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dc6:	00004597          	auipc	a1,0x4
    80003dca:	61a58593          	addi	a1,a1,1562 # 800083e0 <states.0+0x1a0>
    80003dce:	00002097          	auipc	ra,0x2
    80003dd2:	2f2080e7          	jalr	754(ra) # 800060c0 <initlock>
  (*f0)->type = FD_PIPE;
    80003dd6:	609c                	ld	a5,0(s1)
    80003dd8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ddc:	609c                	ld	a5,0(s1)
    80003dde:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003de2:	609c                	ld	a5,0(s1)
    80003de4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003de8:	609c                	ld	a5,0(s1)
    80003dea:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dee:	000a3783          	ld	a5,0(s4)
    80003df2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003df6:	000a3783          	ld	a5,0(s4)
    80003dfa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dfe:	000a3783          	ld	a5,0(s4)
    80003e02:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e06:	000a3783          	ld	a5,0(s4)
    80003e0a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e0e:	4501                	li	a0,0
    80003e10:	a025                	j	80003e38 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e12:	6088                	ld	a0,0(s1)
    80003e14:	e501                	bnez	a0,80003e1c <pipealloc+0xaa>
    80003e16:	a039                	j	80003e24 <pipealloc+0xb2>
    80003e18:	6088                	ld	a0,0(s1)
    80003e1a:	c51d                	beqz	a0,80003e48 <pipealloc+0xd6>
    fileclose(*f0);
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	c26080e7          	jalr	-986(ra) # 80003a42 <fileclose>
  if(*f1)
    80003e24:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e28:	557d                	li	a0,-1
  if(*f1)
    80003e2a:	c799                	beqz	a5,80003e38 <pipealloc+0xc6>
    fileclose(*f1);
    80003e2c:	853e                	mv	a0,a5
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	c14080e7          	jalr	-1004(ra) # 80003a42 <fileclose>
  return -1;
    80003e36:	557d                	li	a0,-1
}
    80003e38:	70a2                	ld	ra,40(sp)
    80003e3a:	7402                	ld	s0,32(sp)
    80003e3c:	64e2                	ld	s1,24(sp)
    80003e3e:	6942                	ld	s2,16(sp)
    80003e40:	69a2                	ld	s3,8(sp)
    80003e42:	6a02                	ld	s4,0(sp)
    80003e44:	6145                	addi	sp,sp,48
    80003e46:	8082                	ret
  return -1;
    80003e48:	557d                	li	a0,-1
    80003e4a:	b7fd                	j	80003e38 <pipealloc+0xc6>

0000000080003e4c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e4c:	1101                	addi	sp,sp,-32
    80003e4e:	ec06                	sd	ra,24(sp)
    80003e50:	e822                	sd	s0,16(sp)
    80003e52:	e426                	sd	s1,8(sp)
    80003e54:	e04a                	sd	s2,0(sp)
    80003e56:	1000                	addi	s0,sp,32
    80003e58:	84aa                	mv	s1,a0
    80003e5a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e5c:	00002097          	auipc	ra,0x2
    80003e60:	2f4080e7          	jalr	756(ra) # 80006150 <acquire>
  if(writable){
    80003e64:	02090d63          	beqz	s2,80003e9e <pipeclose+0x52>
    pi->writeopen = 0;
    80003e68:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e6c:	21848513          	addi	a0,s1,536
    80003e70:	ffffe097          	auipc	ra,0xffffe
    80003e74:	878080e7          	jalr	-1928(ra) # 800016e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e78:	2204b783          	ld	a5,544(s1)
    80003e7c:	eb95                	bnez	a5,80003eb0 <pipeclose+0x64>
    release(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	384080e7          	jalr	900(ra) # 80006204 <release>
    kfree((char*)pi);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	ffffc097          	auipc	ra,0xffffc
    80003e8e:	192080e7          	jalr	402(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	64a2                	ld	s1,8(sp)
    80003e98:	6902                	ld	s2,0(sp)
    80003e9a:	6105                	addi	sp,sp,32
    80003e9c:	8082                	ret
    pi->readopen = 0;
    80003e9e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ea2:	21c48513          	addi	a0,s1,540
    80003ea6:	ffffe097          	auipc	ra,0xffffe
    80003eaa:	842080e7          	jalr	-1982(ra) # 800016e8 <wakeup>
    80003eae:	b7e9                	j	80003e78 <pipeclose+0x2c>
    release(&pi->lock);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	352080e7          	jalr	850(ra) # 80006204 <release>
}
    80003eba:	bfe1                	j	80003e92 <pipeclose+0x46>

0000000080003ebc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ebc:	711d                	addi	sp,sp,-96
    80003ebe:	ec86                	sd	ra,88(sp)
    80003ec0:	e8a2                	sd	s0,80(sp)
    80003ec2:	e4a6                	sd	s1,72(sp)
    80003ec4:	e0ca                	sd	s2,64(sp)
    80003ec6:	fc4e                	sd	s3,56(sp)
    80003ec8:	f852                	sd	s4,48(sp)
    80003eca:	f456                	sd	s5,40(sp)
    80003ecc:	f05a                	sd	s6,32(sp)
    80003ece:	ec5e                	sd	s7,24(sp)
    80003ed0:	e862                	sd	s8,16(sp)
    80003ed2:	1080                	addi	s0,sp,96
    80003ed4:	84aa                	mv	s1,a0
    80003ed6:	8aae                	mv	s5,a1
    80003ed8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	fba080e7          	jalr	-70(ra) # 80000e94 <myproc>
    80003ee2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	26a080e7          	jalr	618(ra) # 80006150 <acquire>
  while(i < n){
    80003eee:	0b405363          	blez	s4,80003f94 <pipewrite+0xd8>
  int i = 0;
    80003ef2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ef6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003efa:	21c48b93          	addi	s7,s1,540
    80003efe:	a089                	j	80003f40 <pipewrite+0x84>
      release(&pi->lock);
    80003f00:	8526                	mv	a0,s1
    80003f02:	00002097          	auipc	ra,0x2
    80003f06:	302080e7          	jalr	770(ra) # 80006204 <release>
      return -1;
    80003f0a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f0c:	854a                	mv	a0,s2
    80003f0e:	60e6                	ld	ra,88(sp)
    80003f10:	6446                	ld	s0,80(sp)
    80003f12:	64a6                	ld	s1,72(sp)
    80003f14:	6906                	ld	s2,64(sp)
    80003f16:	79e2                	ld	s3,56(sp)
    80003f18:	7a42                	ld	s4,48(sp)
    80003f1a:	7aa2                	ld	s5,40(sp)
    80003f1c:	7b02                	ld	s6,32(sp)
    80003f1e:	6be2                	ld	s7,24(sp)
    80003f20:	6c42                	ld	s8,16(sp)
    80003f22:	6125                	addi	sp,sp,96
    80003f24:	8082                	ret
      wakeup(&pi->nread);
    80003f26:	8562                	mv	a0,s8
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	7c0080e7          	jalr	1984(ra) # 800016e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f30:	85a6                	mv	a1,s1
    80003f32:	855e                	mv	a0,s7
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	628080e7          	jalr	1576(ra) # 8000155c <sleep>
  while(i < n){
    80003f3c:	05495d63          	bge	s2,s4,80003f96 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f40:	2204a783          	lw	a5,544(s1)
    80003f44:	dfd5                	beqz	a5,80003f00 <pipewrite+0x44>
    80003f46:	0289a783          	lw	a5,40(s3)
    80003f4a:	fbdd                	bnez	a5,80003f00 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f4c:	2184a783          	lw	a5,536(s1)
    80003f50:	21c4a703          	lw	a4,540(s1)
    80003f54:	2007879b          	addiw	a5,a5,512
    80003f58:	fcf707e3          	beq	a4,a5,80003f26 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f5c:	4685                	li	a3,1
    80003f5e:	01590633          	add	a2,s2,s5
    80003f62:	faf40593          	addi	a1,s0,-81
    80003f66:	0509b503          	ld	a0,80(s3)
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	c76080e7          	jalr	-906(ra) # 80000be0 <copyin>
    80003f72:	03650263          	beq	a0,s6,80003f96 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f76:	21c4a783          	lw	a5,540(s1)
    80003f7a:	0017871b          	addiw	a4,a5,1
    80003f7e:	20e4ae23          	sw	a4,540(s1)
    80003f82:	1ff7f793          	andi	a5,a5,511
    80003f86:	97a6                	add	a5,a5,s1
    80003f88:	faf44703          	lbu	a4,-81(s0)
    80003f8c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f90:	2905                	addiw	s2,s2,1
    80003f92:	b76d                	j	80003f3c <pipewrite+0x80>
  int i = 0;
    80003f94:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f96:	21848513          	addi	a0,s1,536
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	74e080e7          	jalr	1870(ra) # 800016e8 <wakeup>
  release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	260080e7          	jalr	608(ra) # 80006204 <release>
  return i;
    80003fac:	b785                	j	80003f0c <pipewrite+0x50>

0000000080003fae <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fae:	715d                	addi	sp,sp,-80
    80003fb0:	e486                	sd	ra,72(sp)
    80003fb2:	e0a2                	sd	s0,64(sp)
    80003fb4:	fc26                	sd	s1,56(sp)
    80003fb6:	f84a                	sd	s2,48(sp)
    80003fb8:	f44e                	sd	s3,40(sp)
    80003fba:	f052                	sd	s4,32(sp)
    80003fbc:	ec56                	sd	s5,24(sp)
    80003fbe:	e85a                	sd	s6,16(sp)
    80003fc0:	0880                	addi	s0,sp,80
    80003fc2:	84aa                	mv	s1,a0
    80003fc4:	892e                	mv	s2,a1
    80003fc6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fc8:	ffffd097          	auipc	ra,0xffffd
    80003fcc:	ecc080e7          	jalr	-308(ra) # 80000e94 <myproc>
    80003fd0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	17c080e7          	jalr	380(ra) # 80006150 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fdc:	2184a703          	lw	a4,536(s1)
    80003fe0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe8:	02f71463          	bne	a4,a5,80004010 <piperead+0x62>
    80003fec:	2244a783          	lw	a5,548(s1)
    80003ff0:	c385                	beqz	a5,80004010 <piperead+0x62>
    if(pr->killed){
    80003ff2:	028a2783          	lw	a5,40(s4)
    80003ff6:	ebc1                	bnez	a5,80004086 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff8:	85a6                	mv	a1,s1
    80003ffa:	854e                	mv	a0,s3
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	560080e7          	jalr	1376(ra) # 8000155c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004004:	2184a703          	lw	a4,536(s1)
    80004008:	21c4a783          	lw	a5,540(s1)
    8000400c:	fef700e3          	beq	a4,a5,80003fec <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004010:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004012:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004014:	05505363          	blez	s5,8000405a <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004018:	2184a783          	lw	a5,536(s1)
    8000401c:	21c4a703          	lw	a4,540(s1)
    80004020:	02f70d63          	beq	a4,a5,8000405a <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004024:	0017871b          	addiw	a4,a5,1
    80004028:	20e4ac23          	sw	a4,536(s1)
    8000402c:	1ff7f793          	andi	a5,a5,511
    80004030:	97a6                	add	a5,a5,s1
    80004032:	0187c783          	lbu	a5,24(a5)
    80004036:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403a:	4685                	li	a3,1
    8000403c:	fbf40613          	addi	a2,s0,-65
    80004040:	85ca                	mv	a1,s2
    80004042:	050a3503          	ld	a0,80(s4)
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	b0e080e7          	jalr	-1266(ra) # 80000b54 <copyout>
    8000404e:	01650663          	beq	a0,s6,8000405a <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004052:	2985                	addiw	s3,s3,1
    80004054:	0905                	addi	s2,s2,1
    80004056:	fd3a91e3          	bne	s5,s3,80004018 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000405a:	21c48513          	addi	a0,s1,540
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	68a080e7          	jalr	1674(ra) # 800016e8 <wakeup>
  release(&pi->lock);
    80004066:	8526                	mv	a0,s1
    80004068:	00002097          	auipc	ra,0x2
    8000406c:	19c080e7          	jalr	412(ra) # 80006204 <release>
  return i;
}
    80004070:	854e                	mv	a0,s3
    80004072:	60a6                	ld	ra,72(sp)
    80004074:	6406                	ld	s0,64(sp)
    80004076:	74e2                	ld	s1,56(sp)
    80004078:	7942                	ld	s2,48(sp)
    8000407a:	79a2                	ld	s3,40(sp)
    8000407c:	7a02                	ld	s4,32(sp)
    8000407e:	6ae2                	ld	s5,24(sp)
    80004080:	6b42                	ld	s6,16(sp)
    80004082:	6161                	addi	sp,sp,80
    80004084:	8082                	ret
      release(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	17c080e7          	jalr	380(ra) # 80006204 <release>
      return -1;
    80004090:	59fd                	li	s3,-1
    80004092:	bff9                	j	80004070 <piperead+0xc2>

0000000080004094 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004094:	de010113          	addi	sp,sp,-544
    80004098:	20113c23          	sd	ra,536(sp)
    8000409c:	20813823          	sd	s0,528(sp)
    800040a0:	20913423          	sd	s1,520(sp)
    800040a4:	21213023          	sd	s2,512(sp)
    800040a8:	ffce                	sd	s3,504(sp)
    800040aa:	fbd2                	sd	s4,496(sp)
    800040ac:	f7d6                	sd	s5,488(sp)
    800040ae:	f3da                	sd	s6,480(sp)
    800040b0:	efde                	sd	s7,472(sp)
    800040b2:	ebe2                	sd	s8,464(sp)
    800040b4:	e7e6                	sd	s9,456(sp)
    800040b6:	e3ea                	sd	s10,448(sp)
    800040b8:	ff6e                	sd	s11,440(sp)
    800040ba:	1400                	addi	s0,sp,544
    800040bc:	892a                	mv	s2,a0
    800040be:	dea43423          	sd	a0,-536(s0)
    800040c2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040c6:	ffffd097          	auipc	ra,0xffffd
    800040ca:	dce080e7          	jalr	-562(ra) # 80000e94 <myproc>
    800040ce:	84aa                	mv	s1,a0

  begin_op();
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	4a6080e7          	jalr	1190(ra) # 80003576 <begin_op>

  if((ip = namei(path)) == 0){
    800040d8:	854a                	mv	a0,s2
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	280080e7          	jalr	640(ra) # 8000335a <namei>
    800040e2:	c93d                	beqz	a0,80004158 <exec+0xc4>
    800040e4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040e6:	fffff097          	auipc	ra,0xfffff
    800040ea:	abe080e7          	jalr	-1346(ra) # 80002ba4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ee:	04000713          	li	a4,64
    800040f2:	4681                	li	a3,0
    800040f4:	e5040613          	addi	a2,s0,-432
    800040f8:	4581                	li	a1,0
    800040fa:	8556                	mv	a0,s5
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	d5c080e7          	jalr	-676(ra) # 80002e58 <readi>
    80004104:	04000793          	li	a5,64
    80004108:	00f51a63          	bne	a0,a5,8000411c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000410c:	e5042703          	lw	a4,-432(s0)
    80004110:	464c47b7          	lui	a5,0x464c4
    80004114:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004118:	04f70663          	beq	a4,a5,80004164 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000411c:	8556                	mv	a0,s5
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	ce8080e7          	jalr	-792(ra) # 80002e06 <iunlockput>
    end_op();
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	4d0080e7          	jalr	1232(ra) # 800035f6 <end_op>
  }
  return -1;
    8000412e:	557d                	li	a0,-1
}
    80004130:	21813083          	ld	ra,536(sp)
    80004134:	21013403          	ld	s0,528(sp)
    80004138:	20813483          	ld	s1,520(sp)
    8000413c:	20013903          	ld	s2,512(sp)
    80004140:	79fe                	ld	s3,504(sp)
    80004142:	7a5e                	ld	s4,496(sp)
    80004144:	7abe                	ld	s5,488(sp)
    80004146:	7b1e                	ld	s6,480(sp)
    80004148:	6bfe                	ld	s7,472(sp)
    8000414a:	6c5e                	ld	s8,464(sp)
    8000414c:	6cbe                	ld	s9,456(sp)
    8000414e:	6d1e                	ld	s10,448(sp)
    80004150:	7dfa                	ld	s11,440(sp)
    80004152:	22010113          	addi	sp,sp,544
    80004156:	8082                	ret
    end_op();
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	49e080e7          	jalr	1182(ra) # 800035f6 <end_op>
    return -1;
    80004160:	557d                	li	a0,-1
    80004162:	b7f9                	j	80004130 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004164:	8526                	mv	a0,s1
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	df2080e7          	jalr	-526(ra) # 80000f58 <proc_pagetable>
    8000416e:	8b2a                	mv	s6,a0
    80004170:	d555                	beqz	a0,8000411c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004172:	e7042783          	lw	a5,-400(s0)
    80004176:	e8845703          	lhu	a4,-376(s0)
    8000417a:	c735                	beqz	a4,800041e6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000417c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000417e:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004182:	6a05                	lui	s4,0x1
    80004184:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004188:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000418c:	6d85                	lui	s11,0x1
    8000418e:	7d7d                	lui	s10,0xfffff
    80004190:	ac1d                	j	800043c6 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004192:	00004517          	auipc	a0,0x4
    80004196:	64e50513          	addi	a0,a0,1614 # 800087e0 <syscalls_name+0x288>
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	a7a080e7          	jalr	-1414(ra) # 80005c14 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a2:	874a                	mv	a4,s2
    800041a4:	009c86bb          	addw	a3,s9,s1
    800041a8:	4581                	li	a1,0
    800041aa:	8556                	mv	a0,s5
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	cac080e7          	jalr	-852(ra) # 80002e58 <readi>
    800041b4:	2501                	sext.w	a0,a0
    800041b6:	1aa91863          	bne	s2,a0,80004366 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041ba:	009d84bb          	addw	s1,s11,s1
    800041be:	013d09bb          	addw	s3,s10,s3
    800041c2:	1f74f263          	bgeu	s1,s7,800043a6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041c6:	02049593          	slli	a1,s1,0x20
    800041ca:	9181                	srli	a1,a1,0x20
    800041cc:	95e2                	add	a1,a1,s8
    800041ce:	855a                	mv	a0,s6
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	380080e7          	jalr	896(ra) # 80000550 <walkaddr>
    800041d8:	862a                	mv	a2,a0
    if(pa == 0)
    800041da:	dd45                	beqz	a0,80004192 <exec+0xfe>
      n = PGSIZE;
    800041dc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041de:	fd49f2e3          	bgeu	s3,s4,800041a2 <exec+0x10e>
      n = sz - i;
    800041e2:	894e                	mv	s2,s3
    800041e4:	bf7d                	j	800041a2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041e6:	4481                	li	s1,0
  iunlockput(ip);
    800041e8:	8556                	mv	a0,s5
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	c1c080e7          	jalr	-996(ra) # 80002e06 <iunlockput>
  end_op();
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	404080e7          	jalr	1028(ra) # 800035f6 <end_op>
  p = myproc();
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	c9a080e7          	jalr	-870(ra) # 80000e94 <myproc>
    80004202:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004204:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004208:	6785                	lui	a5,0x1
    8000420a:	17fd                	addi	a5,a5,-1
    8000420c:	94be                	add	s1,s1,a5
    8000420e:	77fd                	lui	a5,0xfffff
    80004210:	8fe5                	and	a5,a5,s1
    80004212:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004216:	6609                	lui	a2,0x2
    80004218:	963e                	add	a2,a2,a5
    8000421a:	85be                	mv	a1,a5
    8000421c:	855a                	mv	a0,s6
    8000421e:	ffffc097          	auipc	ra,0xffffc
    80004222:	6e6080e7          	jalr	1766(ra) # 80000904 <uvmalloc>
    80004226:	8c2a                	mv	s8,a0
  ip = 0;
    80004228:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000422a:	12050e63          	beqz	a0,80004366 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000422e:	75f9                	lui	a1,0xffffe
    80004230:	95aa                	add	a1,a1,a0
    80004232:	855a                	mv	a0,s6
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	8ee080e7          	jalr	-1810(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    8000423c:	7afd                	lui	s5,0xfffff
    8000423e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004240:	df043783          	ld	a5,-528(s0)
    80004244:	6388                	ld	a0,0(a5)
    80004246:	c925                	beqz	a0,800042b6 <exec+0x222>
    80004248:	e9040993          	addi	s3,s0,-368
    8000424c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004250:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004252:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004254:	ffffc097          	auipc	ra,0xffffc
    80004258:	0f2080e7          	jalr	242(ra) # 80000346 <strlen>
    8000425c:	0015079b          	addiw	a5,a0,1
    80004260:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004264:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004268:	13596363          	bltu	s2,s5,8000438e <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000426c:	df043d83          	ld	s11,-528(s0)
    80004270:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004274:	8552                	mv	a0,s4
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	0d0080e7          	jalr	208(ra) # 80000346 <strlen>
    8000427e:	0015069b          	addiw	a3,a0,1
    80004282:	8652                	mv	a2,s4
    80004284:	85ca                	mv	a1,s2
    80004286:	855a                	mv	a0,s6
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	8cc080e7          	jalr	-1844(ra) # 80000b54 <copyout>
    80004290:	10054363          	bltz	a0,80004396 <exec+0x302>
    ustack[argc] = sp;
    80004294:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004298:	0485                	addi	s1,s1,1
    8000429a:	008d8793          	addi	a5,s11,8
    8000429e:	def43823          	sd	a5,-528(s0)
    800042a2:	008db503          	ld	a0,8(s11)
    800042a6:	c911                	beqz	a0,800042ba <exec+0x226>
    if(argc >= MAXARG)
    800042a8:	09a1                	addi	s3,s3,8
    800042aa:	fb3c95e3          	bne	s9,s3,80004254 <exec+0x1c0>
  sz = sz1;
    800042ae:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042b2:	4a81                	li	s5,0
    800042b4:	a84d                	j	80004366 <exec+0x2d2>
  sp = sz;
    800042b6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ba:	00349793          	slli	a5,s1,0x3
    800042be:	f9040713          	addi	a4,s0,-112
    800042c2:	97ba                	add	a5,a5,a4
    800042c4:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    800042c8:	00148693          	addi	a3,s1,1
    800042cc:	068e                	slli	a3,a3,0x3
    800042ce:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042d2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042d6:	01597663          	bgeu	s2,s5,800042e2 <exec+0x24e>
  sz = sz1;
    800042da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042de:	4a81                	li	s5,0
    800042e0:	a059                	j	80004366 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042e2:	e9040613          	addi	a2,s0,-368
    800042e6:	85ca                	mv	a1,s2
    800042e8:	855a                	mv	a0,s6
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	86a080e7          	jalr	-1942(ra) # 80000b54 <copyout>
    800042f2:	0a054663          	bltz	a0,8000439e <exec+0x30a>
  p->trapframe->a1 = sp;
    800042f6:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800042fa:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042fe:	de843783          	ld	a5,-536(s0)
    80004302:	0007c703          	lbu	a4,0(a5)
    80004306:	cf11                	beqz	a4,80004322 <exec+0x28e>
    80004308:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000430a:	02f00693          	li	a3,47
    8000430e:	a039                	j	8000431c <exec+0x288>
      last = s+1;
    80004310:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004314:	0785                	addi	a5,a5,1
    80004316:	fff7c703          	lbu	a4,-1(a5)
    8000431a:	c701                	beqz	a4,80004322 <exec+0x28e>
    if(*s == '/')
    8000431c:	fed71ce3          	bne	a4,a3,80004314 <exec+0x280>
    80004320:	bfc5                	j	80004310 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004322:	4641                	li	a2,16
    80004324:	de843583          	ld	a1,-536(s0)
    80004328:	158b8513          	addi	a0,s7,344
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	fe8080e7          	jalr	-24(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    80004334:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004338:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000433c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004340:	058bb783          	ld	a5,88(s7)
    80004344:	e6843703          	ld	a4,-408(s0)
    80004348:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000434a:	058bb783          	ld	a5,88(s7)
    8000434e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004352:	85ea                	mv	a1,s10
    80004354:	ffffd097          	auipc	ra,0xffffd
    80004358:	ca0080e7          	jalr	-864(ra) # 80000ff4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000435c:	0004851b          	sext.w	a0,s1
    80004360:	bbc1                	j	80004130 <exec+0x9c>
    80004362:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004366:	df843583          	ld	a1,-520(s0)
    8000436a:	855a                	mv	a0,s6
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	c88080e7          	jalr	-888(ra) # 80000ff4 <proc_freepagetable>
  if(ip){
    80004374:	da0a94e3          	bnez	s5,8000411c <exec+0x88>
  return -1;
    80004378:	557d                	li	a0,-1
    8000437a:	bb5d                	j	80004130 <exec+0x9c>
    8000437c:	de943c23          	sd	s1,-520(s0)
    80004380:	b7dd                	j	80004366 <exec+0x2d2>
    80004382:	de943c23          	sd	s1,-520(s0)
    80004386:	b7c5                	j	80004366 <exec+0x2d2>
    80004388:	de943c23          	sd	s1,-520(s0)
    8000438c:	bfe9                	j	80004366 <exec+0x2d2>
  sz = sz1;
    8000438e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004392:	4a81                	li	s5,0
    80004394:	bfc9                	j	80004366 <exec+0x2d2>
  sz = sz1;
    80004396:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000439a:	4a81                	li	s5,0
    8000439c:	b7e9                	j	80004366 <exec+0x2d2>
  sz = sz1;
    8000439e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043a2:	4a81                	li	s5,0
    800043a4:	b7c9                	j	80004366 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a6:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043aa:	e0843783          	ld	a5,-504(s0)
    800043ae:	0017869b          	addiw	a3,a5,1
    800043b2:	e0d43423          	sd	a3,-504(s0)
    800043b6:	e0043783          	ld	a5,-512(s0)
    800043ba:	0387879b          	addiw	a5,a5,56
    800043be:	e8845703          	lhu	a4,-376(s0)
    800043c2:	e2e6d3e3          	bge	a3,a4,800041e8 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043c6:	2781                	sext.w	a5,a5
    800043c8:	e0f43023          	sd	a5,-512(s0)
    800043cc:	03800713          	li	a4,56
    800043d0:	86be                	mv	a3,a5
    800043d2:	e1840613          	addi	a2,s0,-488
    800043d6:	4581                	li	a1,0
    800043d8:	8556                	mv	a0,s5
    800043da:	fffff097          	auipc	ra,0xfffff
    800043de:	a7e080e7          	jalr	-1410(ra) # 80002e58 <readi>
    800043e2:	03800793          	li	a5,56
    800043e6:	f6f51ee3          	bne	a0,a5,80004362 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800043ea:	e1842783          	lw	a5,-488(s0)
    800043ee:	4705                	li	a4,1
    800043f0:	fae79de3          	bne	a5,a4,800043aa <exec+0x316>
    if(ph.memsz < ph.filesz)
    800043f4:	e4043603          	ld	a2,-448(s0)
    800043f8:	e3843783          	ld	a5,-456(s0)
    800043fc:	f8f660e3          	bltu	a2,a5,8000437c <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004400:	e2843783          	ld	a5,-472(s0)
    80004404:	963e                	add	a2,a2,a5
    80004406:	f6f66ee3          	bltu	a2,a5,80004382 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000440a:	85a6                	mv	a1,s1
    8000440c:	855a                	mv	a0,s6
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	4f6080e7          	jalr	1270(ra) # 80000904 <uvmalloc>
    80004416:	dea43c23          	sd	a0,-520(s0)
    8000441a:	d53d                	beqz	a0,80004388 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000441c:	e2843c03          	ld	s8,-472(s0)
    80004420:	de043783          	ld	a5,-544(s0)
    80004424:	00fc77b3          	and	a5,s8,a5
    80004428:	ff9d                	bnez	a5,80004366 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000442a:	e2042c83          	lw	s9,-480(s0)
    8000442e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004432:	f60b8ae3          	beqz	s7,800043a6 <exec+0x312>
    80004436:	89de                	mv	s3,s7
    80004438:	4481                	li	s1,0
    8000443a:	b371                	j	800041c6 <exec+0x132>

000000008000443c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000443c:	7179                	addi	sp,sp,-48
    8000443e:	f406                	sd	ra,40(sp)
    80004440:	f022                	sd	s0,32(sp)
    80004442:	ec26                	sd	s1,24(sp)
    80004444:	e84a                	sd	s2,16(sp)
    80004446:	1800                	addi	s0,sp,48
    80004448:	892e                	mv	s2,a1
    8000444a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000444c:	fdc40593          	addi	a1,s0,-36
    80004450:	ffffe097          	auipc	ra,0xffffe
    80004454:	b32080e7          	jalr	-1230(ra) # 80001f82 <argint>
    80004458:	04054063          	bltz	a0,80004498 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000445c:	fdc42703          	lw	a4,-36(s0)
    80004460:	47bd                	li	a5,15
    80004462:	02e7ed63          	bltu	a5,a4,8000449c <argfd+0x60>
    80004466:	ffffd097          	auipc	ra,0xffffd
    8000446a:	a2e080e7          	jalr	-1490(ra) # 80000e94 <myproc>
    8000446e:	fdc42703          	lw	a4,-36(s0)
    80004472:	01a70793          	addi	a5,a4,26
    80004476:	078e                	slli	a5,a5,0x3
    80004478:	953e                	add	a0,a0,a5
    8000447a:	611c                	ld	a5,0(a0)
    8000447c:	c395                	beqz	a5,800044a0 <argfd+0x64>
    return -1;
  if(pfd)
    8000447e:	00090463          	beqz	s2,80004486 <argfd+0x4a>
    *pfd = fd;
    80004482:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004486:	4501                	li	a0,0
  if(pf)
    80004488:	c091                	beqz	s1,8000448c <argfd+0x50>
    *pf = f;
    8000448a:	e09c                	sd	a5,0(s1)
}
    8000448c:	70a2                	ld	ra,40(sp)
    8000448e:	7402                	ld	s0,32(sp)
    80004490:	64e2                	ld	s1,24(sp)
    80004492:	6942                	ld	s2,16(sp)
    80004494:	6145                	addi	sp,sp,48
    80004496:	8082                	ret
    return -1;
    80004498:	557d                	li	a0,-1
    8000449a:	bfcd                	j	8000448c <argfd+0x50>
    return -1;
    8000449c:	557d                	li	a0,-1
    8000449e:	b7fd                	j	8000448c <argfd+0x50>
    800044a0:	557d                	li	a0,-1
    800044a2:	b7ed                	j	8000448c <argfd+0x50>

00000000800044a4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044a4:	1101                	addi	sp,sp,-32
    800044a6:	ec06                	sd	ra,24(sp)
    800044a8:	e822                	sd	s0,16(sp)
    800044aa:	e426                	sd	s1,8(sp)
    800044ac:	1000                	addi	s0,sp,32
    800044ae:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	9e4080e7          	jalr	-1564(ra) # 80000e94 <myproc>
    800044b8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044ba:	0d050793          	addi	a5,a0,208
    800044be:	4501                	li	a0,0
    800044c0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044c2:	6398                	ld	a4,0(a5)
    800044c4:	cb19                	beqz	a4,800044da <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044c6:	2505                	addiw	a0,a0,1
    800044c8:	07a1                	addi	a5,a5,8
    800044ca:	fed51ce3          	bne	a0,a3,800044c2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ce:	557d                	li	a0,-1
}
    800044d0:	60e2                	ld	ra,24(sp)
    800044d2:	6442                	ld	s0,16(sp)
    800044d4:	64a2                	ld	s1,8(sp)
    800044d6:	6105                	addi	sp,sp,32
    800044d8:	8082                	ret
      p->ofile[fd] = f;
    800044da:	01a50793          	addi	a5,a0,26
    800044de:	078e                	slli	a5,a5,0x3
    800044e0:	963e                	add	a2,a2,a5
    800044e2:	e204                	sd	s1,0(a2)
      return fd;
    800044e4:	b7f5                	j	800044d0 <fdalloc+0x2c>

00000000800044e6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044e6:	715d                	addi	sp,sp,-80
    800044e8:	e486                	sd	ra,72(sp)
    800044ea:	e0a2                	sd	s0,64(sp)
    800044ec:	fc26                	sd	s1,56(sp)
    800044ee:	f84a                	sd	s2,48(sp)
    800044f0:	f44e                	sd	s3,40(sp)
    800044f2:	f052                	sd	s4,32(sp)
    800044f4:	ec56                	sd	s5,24(sp)
    800044f6:	0880                	addi	s0,sp,80
    800044f8:	89ae                	mv	s3,a1
    800044fa:	8ab2                	mv	s5,a2
    800044fc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044fe:	fb040593          	addi	a1,s0,-80
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	e76080e7          	jalr	-394(ra) # 80003378 <nameiparent>
    8000450a:	892a                	mv	s2,a0
    8000450c:	12050e63          	beqz	a0,80004648 <create+0x162>
    return 0;

  ilock(dp);
    80004510:	ffffe097          	auipc	ra,0xffffe
    80004514:	694080e7          	jalr	1684(ra) # 80002ba4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004518:	4601                	li	a2,0
    8000451a:	fb040593          	addi	a1,s0,-80
    8000451e:	854a                	mv	a0,s2
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	b68080e7          	jalr	-1176(ra) # 80003088 <dirlookup>
    80004528:	84aa                	mv	s1,a0
    8000452a:	c921                	beqz	a0,8000457a <create+0x94>
    iunlockput(dp);
    8000452c:	854a                	mv	a0,s2
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	8d8080e7          	jalr	-1832(ra) # 80002e06 <iunlockput>
    ilock(ip);
    80004536:	8526                	mv	a0,s1
    80004538:	ffffe097          	auipc	ra,0xffffe
    8000453c:	66c080e7          	jalr	1644(ra) # 80002ba4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004540:	2981                	sext.w	s3,s3
    80004542:	4789                	li	a5,2
    80004544:	02f99463          	bne	s3,a5,8000456c <create+0x86>
    80004548:	0444d783          	lhu	a5,68(s1)
    8000454c:	37f9                	addiw	a5,a5,-2
    8000454e:	17c2                	slli	a5,a5,0x30
    80004550:	93c1                	srli	a5,a5,0x30
    80004552:	4705                	li	a4,1
    80004554:	00f76c63          	bltu	a4,a5,8000456c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004558:	8526                	mv	a0,s1
    8000455a:	60a6                	ld	ra,72(sp)
    8000455c:	6406                	ld	s0,64(sp)
    8000455e:	74e2                	ld	s1,56(sp)
    80004560:	7942                	ld	s2,48(sp)
    80004562:	79a2                	ld	s3,40(sp)
    80004564:	7a02                	ld	s4,32(sp)
    80004566:	6ae2                	ld	s5,24(sp)
    80004568:	6161                	addi	sp,sp,80
    8000456a:	8082                	ret
    iunlockput(ip);
    8000456c:	8526                	mv	a0,s1
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	898080e7          	jalr	-1896(ra) # 80002e06 <iunlockput>
    return 0;
    80004576:	4481                	li	s1,0
    80004578:	b7c5                	j	80004558 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000457a:	85ce                	mv	a1,s3
    8000457c:	00092503          	lw	a0,0(s2)
    80004580:	ffffe097          	auipc	ra,0xffffe
    80004584:	48c080e7          	jalr	1164(ra) # 80002a0c <ialloc>
    80004588:	84aa                	mv	s1,a0
    8000458a:	c521                	beqz	a0,800045d2 <create+0xec>
  ilock(ip);
    8000458c:	ffffe097          	auipc	ra,0xffffe
    80004590:	618080e7          	jalr	1560(ra) # 80002ba4 <ilock>
  ip->major = major;
    80004594:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004598:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000459c:	4a05                	li	s4,1
    8000459e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045a2:	8526                	mv	a0,s1
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	536080e7          	jalr	1334(ra) # 80002ada <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ac:	2981                	sext.w	s3,s3
    800045ae:	03498a63          	beq	s3,s4,800045e2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045b2:	40d0                	lw	a2,4(s1)
    800045b4:	fb040593          	addi	a1,s0,-80
    800045b8:	854a                	mv	a0,s2
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	cde080e7          	jalr	-802(ra) # 80003298 <dirlink>
    800045c2:	06054b63          	bltz	a0,80004638 <create+0x152>
  iunlockput(dp);
    800045c6:	854a                	mv	a0,s2
    800045c8:	fffff097          	auipc	ra,0xfffff
    800045cc:	83e080e7          	jalr	-1986(ra) # 80002e06 <iunlockput>
  return ip;
    800045d0:	b761                	j	80004558 <create+0x72>
    panic("create: ialloc");
    800045d2:	00004517          	auipc	a0,0x4
    800045d6:	22e50513          	addi	a0,a0,558 # 80008800 <syscalls_name+0x2a8>
    800045da:	00001097          	auipc	ra,0x1
    800045de:	63a080e7          	jalr	1594(ra) # 80005c14 <panic>
    dp->nlink++;  // for ".."
    800045e2:	04a95783          	lhu	a5,74(s2)
    800045e6:	2785                	addiw	a5,a5,1
    800045e8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045ec:	854a                	mv	a0,s2
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	4ec080e7          	jalr	1260(ra) # 80002ada <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045f6:	40d0                	lw	a2,4(s1)
    800045f8:	00004597          	auipc	a1,0x4
    800045fc:	21858593          	addi	a1,a1,536 # 80008810 <syscalls_name+0x2b8>
    80004600:	8526                	mv	a0,s1
    80004602:	fffff097          	auipc	ra,0xfffff
    80004606:	c96080e7          	jalr	-874(ra) # 80003298 <dirlink>
    8000460a:	00054f63          	bltz	a0,80004628 <create+0x142>
    8000460e:	00492603          	lw	a2,4(s2)
    80004612:	00004597          	auipc	a1,0x4
    80004616:	20658593          	addi	a1,a1,518 # 80008818 <syscalls_name+0x2c0>
    8000461a:	8526                	mv	a0,s1
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	c7c080e7          	jalr	-900(ra) # 80003298 <dirlink>
    80004624:	f80557e3          	bgez	a0,800045b2 <create+0xcc>
      panic("create dots");
    80004628:	00004517          	auipc	a0,0x4
    8000462c:	1f850513          	addi	a0,a0,504 # 80008820 <syscalls_name+0x2c8>
    80004630:	00001097          	auipc	ra,0x1
    80004634:	5e4080e7          	jalr	1508(ra) # 80005c14 <panic>
    panic("create: dirlink");
    80004638:	00004517          	auipc	a0,0x4
    8000463c:	1f850513          	addi	a0,a0,504 # 80008830 <syscalls_name+0x2d8>
    80004640:	00001097          	auipc	ra,0x1
    80004644:	5d4080e7          	jalr	1492(ra) # 80005c14 <panic>
    return 0;
    80004648:	84aa                	mv	s1,a0
    8000464a:	b739                	j	80004558 <create+0x72>

000000008000464c <sys_dup>:
{
    8000464c:	7179                	addi	sp,sp,-48
    8000464e:	f406                	sd	ra,40(sp)
    80004650:	f022                	sd	s0,32(sp)
    80004652:	ec26                	sd	s1,24(sp)
    80004654:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004656:	fd840613          	addi	a2,s0,-40
    8000465a:	4581                	li	a1,0
    8000465c:	4501                	li	a0,0
    8000465e:	00000097          	auipc	ra,0x0
    80004662:	dde080e7          	jalr	-546(ra) # 8000443c <argfd>
    return -1;
    80004666:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004668:	02054363          	bltz	a0,8000468e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000466c:	fd843503          	ld	a0,-40(s0)
    80004670:	00000097          	auipc	ra,0x0
    80004674:	e34080e7          	jalr	-460(ra) # 800044a4 <fdalloc>
    80004678:	84aa                	mv	s1,a0
    return -1;
    8000467a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000467c:	00054963          	bltz	a0,8000468e <sys_dup+0x42>
  filedup(f);
    80004680:	fd843503          	ld	a0,-40(s0)
    80004684:	fffff097          	auipc	ra,0xfffff
    80004688:	36c080e7          	jalr	876(ra) # 800039f0 <filedup>
  return fd;
    8000468c:	87a6                	mv	a5,s1
}
    8000468e:	853e                	mv	a0,a5
    80004690:	70a2                	ld	ra,40(sp)
    80004692:	7402                	ld	s0,32(sp)
    80004694:	64e2                	ld	s1,24(sp)
    80004696:	6145                	addi	sp,sp,48
    80004698:	8082                	ret

000000008000469a <sys_read>:
{
    8000469a:	7179                	addi	sp,sp,-48
    8000469c:	f406                	sd	ra,40(sp)
    8000469e:	f022                	sd	s0,32(sp)
    800046a0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a2:	fe840613          	addi	a2,s0,-24
    800046a6:	4581                	li	a1,0
    800046a8:	4501                	li	a0,0
    800046aa:	00000097          	auipc	ra,0x0
    800046ae:	d92080e7          	jalr	-622(ra) # 8000443c <argfd>
    return -1;
    800046b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b4:	04054163          	bltz	a0,800046f6 <sys_read+0x5c>
    800046b8:	fe440593          	addi	a1,s0,-28
    800046bc:	4509                	li	a0,2
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	8c4080e7          	jalr	-1852(ra) # 80001f82 <argint>
    return -1;
    800046c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c8:	02054763          	bltz	a0,800046f6 <sys_read+0x5c>
    800046cc:	fd840593          	addi	a1,s0,-40
    800046d0:	4505                	li	a0,1
    800046d2:	ffffe097          	auipc	ra,0xffffe
    800046d6:	8d2080e7          	jalr	-1838(ra) # 80001fa4 <argaddr>
    return -1;
    800046da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046dc:	00054d63          	bltz	a0,800046f6 <sys_read+0x5c>
  return fileread(f, p, n);
    800046e0:	fe442603          	lw	a2,-28(s0)
    800046e4:	fd843583          	ld	a1,-40(s0)
    800046e8:	fe843503          	ld	a0,-24(s0)
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	490080e7          	jalr	1168(ra) # 80003b7c <fileread>
    800046f4:	87aa                	mv	a5,a0
}
    800046f6:	853e                	mv	a0,a5
    800046f8:	70a2                	ld	ra,40(sp)
    800046fa:	7402                	ld	s0,32(sp)
    800046fc:	6145                	addi	sp,sp,48
    800046fe:	8082                	ret

0000000080004700 <sys_write>:
{
    80004700:	7179                	addi	sp,sp,-48
    80004702:	f406                	sd	ra,40(sp)
    80004704:	f022                	sd	s0,32(sp)
    80004706:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	fe840613          	addi	a2,s0,-24
    8000470c:	4581                	li	a1,0
    8000470e:	4501                	li	a0,0
    80004710:	00000097          	auipc	ra,0x0
    80004714:	d2c080e7          	jalr	-724(ra) # 8000443c <argfd>
    return -1;
    80004718:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471a:	04054163          	bltz	a0,8000475c <sys_write+0x5c>
    8000471e:	fe440593          	addi	a1,s0,-28
    80004722:	4509                	li	a0,2
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	85e080e7          	jalr	-1954(ra) # 80001f82 <argint>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	02054763          	bltz	a0,8000475c <sys_write+0x5c>
    80004732:	fd840593          	addi	a1,s0,-40
    80004736:	4505                	li	a0,1
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	86c080e7          	jalr	-1940(ra) # 80001fa4 <argaddr>
    return -1;
    80004740:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004742:	00054d63          	bltz	a0,8000475c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004746:	fe442603          	lw	a2,-28(s0)
    8000474a:	fd843583          	ld	a1,-40(s0)
    8000474e:	fe843503          	ld	a0,-24(s0)
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	4ec080e7          	jalr	1260(ra) # 80003c3e <filewrite>
    8000475a:	87aa                	mv	a5,a0
}
    8000475c:	853e                	mv	a0,a5
    8000475e:	70a2                	ld	ra,40(sp)
    80004760:	7402                	ld	s0,32(sp)
    80004762:	6145                	addi	sp,sp,48
    80004764:	8082                	ret

0000000080004766 <sys_close>:
{
    80004766:	1101                	addi	sp,sp,-32
    80004768:	ec06                	sd	ra,24(sp)
    8000476a:	e822                	sd	s0,16(sp)
    8000476c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000476e:	fe040613          	addi	a2,s0,-32
    80004772:	fec40593          	addi	a1,s0,-20
    80004776:	4501                	li	a0,0
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	cc4080e7          	jalr	-828(ra) # 8000443c <argfd>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004782:	02054463          	bltz	a0,800047aa <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004786:	ffffc097          	auipc	ra,0xffffc
    8000478a:	70e080e7          	jalr	1806(ra) # 80000e94 <myproc>
    8000478e:	fec42783          	lw	a5,-20(s0)
    80004792:	07e9                	addi	a5,a5,26
    80004794:	078e                	slli	a5,a5,0x3
    80004796:	97aa                	add	a5,a5,a0
    80004798:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000479c:	fe043503          	ld	a0,-32(s0)
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	2a2080e7          	jalr	674(ra) # 80003a42 <fileclose>
  return 0;
    800047a8:	4781                	li	a5,0
}
    800047aa:	853e                	mv	a0,a5
    800047ac:	60e2                	ld	ra,24(sp)
    800047ae:	6442                	ld	s0,16(sp)
    800047b0:	6105                	addi	sp,sp,32
    800047b2:	8082                	ret

00000000800047b4 <sys_fstat>:
{
    800047b4:	1101                	addi	sp,sp,-32
    800047b6:	ec06                	sd	ra,24(sp)
    800047b8:	e822                	sd	s0,16(sp)
    800047ba:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047bc:	fe840613          	addi	a2,s0,-24
    800047c0:	4581                	li	a1,0
    800047c2:	4501                	li	a0,0
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	c78080e7          	jalr	-904(ra) # 8000443c <argfd>
    return -1;
    800047cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ce:	02054563          	bltz	a0,800047f8 <sys_fstat+0x44>
    800047d2:	fe040593          	addi	a1,s0,-32
    800047d6:	4505                	li	a0,1
    800047d8:	ffffd097          	auipc	ra,0xffffd
    800047dc:	7cc080e7          	jalr	1996(ra) # 80001fa4 <argaddr>
    return -1;
    800047e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047e2:	00054b63          	bltz	a0,800047f8 <sys_fstat+0x44>
  return filestat(f, st);
    800047e6:	fe043583          	ld	a1,-32(s0)
    800047ea:	fe843503          	ld	a0,-24(s0)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	31c080e7          	jalr	796(ra) # 80003b0a <filestat>
    800047f6:	87aa                	mv	a5,a0
}
    800047f8:	853e                	mv	a0,a5
    800047fa:	60e2                	ld	ra,24(sp)
    800047fc:	6442                	ld	s0,16(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <sys_link>:
{
    80004802:	7169                	addi	sp,sp,-304
    80004804:	f606                	sd	ra,296(sp)
    80004806:	f222                	sd	s0,288(sp)
    80004808:	ee26                	sd	s1,280(sp)
    8000480a:	ea4a                	sd	s2,272(sp)
    8000480c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000480e:	08000613          	li	a2,128
    80004812:	ed040593          	addi	a1,s0,-304
    80004816:	4501                	li	a0,0
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	7ae080e7          	jalr	1966(ra) # 80001fc6 <argstr>
    return -1;
    80004820:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004822:	10054e63          	bltz	a0,8000493e <sys_link+0x13c>
    80004826:	08000613          	li	a2,128
    8000482a:	f5040593          	addi	a1,s0,-176
    8000482e:	4505                	li	a0,1
    80004830:	ffffd097          	auipc	ra,0xffffd
    80004834:	796080e7          	jalr	1942(ra) # 80001fc6 <argstr>
    return -1;
    80004838:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000483a:	10054263          	bltz	a0,8000493e <sys_link+0x13c>
  begin_op();
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	d38080e7          	jalr	-712(ra) # 80003576 <begin_op>
  if((ip = namei(old)) == 0){
    80004846:	ed040513          	addi	a0,s0,-304
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	b10080e7          	jalr	-1264(ra) # 8000335a <namei>
    80004852:	84aa                	mv	s1,a0
    80004854:	c551                	beqz	a0,800048e0 <sys_link+0xde>
  ilock(ip);
    80004856:	ffffe097          	auipc	ra,0xffffe
    8000485a:	34e080e7          	jalr	846(ra) # 80002ba4 <ilock>
  if(ip->type == T_DIR){
    8000485e:	04449703          	lh	a4,68(s1)
    80004862:	4785                	li	a5,1
    80004864:	08f70463          	beq	a4,a5,800048ec <sys_link+0xea>
  ip->nlink++;
    80004868:	04a4d783          	lhu	a5,74(s1)
    8000486c:	2785                	addiw	a5,a5,1
    8000486e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	266080e7          	jalr	614(ra) # 80002ada <iupdate>
  iunlock(ip);
    8000487c:	8526                	mv	a0,s1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	3e8080e7          	jalr	1000(ra) # 80002c66 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004886:	fd040593          	addi	a1,s0,-48
    8000488a:	f5040513          	addi	a0,s0,-176
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	aea080e7          	jalr	-1302(ra) # 80003378 <nameiparent>
    80004896:	892a                	mv	s2,a0
    80004898:	c935                	beqz	a0,8000490c <sys_link+0x10a>
  ilock(dp);
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	30a080e7          	jalr	778(ra) # 80002ba4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048a2:	00092703          	lw	a4,0(s2)
    800048a6:	409c                	lw	a5,0(s1)
    800048a8:	04f71d63          	bne	a4,a5,80004902 <sys_link+0x100>
    800048ac:	40d0                	lw	a2,4(s1)
    800048ae:	fd040593          	addi	a1,s0,-48
    800048b2:	854a                	mv	a0,s2
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	9e4080e7          	jalr	-1564(ra) # 80003298 <dirlink>
    800048bc:	04054363          	bltz	a0,80004902 <sys_link+0x100>
  iunlockput(dp);
    800048c0:	854a                	mv	a0,s2
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	544080e7          	jalr	1348(ra) # 80002e06 <iunlockput>
  iput(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	492080e7          	jalr	1170(ra) # 80002d5e <iput>
  end_op();
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	d22080e7          	jalr	-734(ra) # 800035f6 <end_op>
  return 0;
    800048dc:	4781                	li	a5,0
    800048de:	a085                	j	8000493e <sys_link+0x13c>
    end_op();
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	d16080e7          	jalr	-746(ra) # 800035f6 <end_op>
    return -1;
    800048e8:	57fd                	li	a5,-1
    800048ea:	a891                	j	8000493e <sys_link+0x13c>
    iunlockput(ip);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	518080e7          	jalr	1304(ra) # 80002e06 <iunlockput>
    end_op();
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	d00080e7          	jalr	-768(ra) # 800035f6 <end_op>
    return -1;
    800048fe:	57fd                	li	a5,-1
    80004900:	a83d                	j	8000493e <sys_link+0x13c>
    iunlockput(dp);
    80004902:	854a                	mv	a0,s2
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	502080e7          	jalr	1282(ra) # 80002e06 <iunlockput>
  ilock(ip);
    8000490c:	8526                	mv	a0,s1
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	296080e7          	jalr	662(ra) # 80002ba4 <ilock>
  ip->nlink--;
    80004916:	04a4d783          	lhu	a5,74(s1)
    8000491a:	37fd                	addiw	a5,a5,-1
    8000491c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	1b8080e7          	jalr	440(ra) # 80002ada <iupdate>
  iunlockput(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	4da080e7          	jalr	1242(ra) # 80002e06 <iunlockput>
  end_op();
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	cc2080e7          	jalr	-830(ra) # 800035f6 <end_op>
  return -1;
    8000493c:	57fd                	li	a5,-1
}
    8000493e:	853e                	mv	a0,a5
    80004940:	70b2                	ld	ra,296(sp)
    80004942:	7412                	ld	s0,288(sp)
    80004944:	64f2                	ld	s1,280(sp)
    80004946:	6952                	ld	s2,272(sp)
    80004948:	6155                	addi	sp,sp,304
    8000494a:	8082                	ret

000000008000494c <sys_unlink>:
{
    8000494c:	7151                	addi	sp,sp,-240
    8000494e:	f586                	sd	ra,232(sp)
    80004950:	f1a2                	sd	s0,224(sp)
    80004952:	eda6                	sd	s1,216(sp)
    80004954:	e9ca                	sd	s2,208(sp)
    80004956:	e5ce                	sd	s3,200(sp)
    80004958:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000495a:	08000613          	li	a2,128
    8000495e:	f3040593          	addi	a1,s0,-208
    80004962:	4501                	li	a0,0
    80004964:	ffffd097          	auipc	ra,0xffffd
    80004968:	662080e7          	jalr	1634(ra) # 80001fc6 <argstr>
    8000496c:	18054163          	bltz	a0,80004aee <sys_unlink+0x1a2>
  begin_op();
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	c06080e7          	jalr	-1018(ra) # 80003576 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004978:	fb040593          	addi	a1,s0,-80
    8000497c:	f3040513          	addi	a0,s0,-208
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	9f8080e7          	jalr	-1544(ra) # 80003378 <nameiparent>
    80004988:	84aa                	mv	s1,a0
    8000498a:	c979                	beqz	a0,80004a60 <sys_unlink+0x114>
  ilock(dp);
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	218080e7          	jalr	536(ra) # 80002ba4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004994:	00004597          	auipc	a1,0x4
    80004998:	e7c58593          	addi	a1,a1,-388 # 80008810 <syscalls_name+0x2b8>
    8000499c:	fb040513          	addi	a0,s0,-80
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	6ce080e7          	jalr	1742(ra) # 8000306e <namecmp>
    800049a8:	14050a63          	beqz	a0,80004afc <sys_unlink+0x1b0>
    800049ac:	00004597          	auipc	a1,0x4
    800049b0:	e6c58593          	addi	a1,a1,-404 # 80008818 <syscalls_name+0x2c0>
    800049b4:	fb040513          	addi	a0,s0,-80
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	6b6080e7          	jalr	1718(ra) # 8000306e <namecmp>
    800049c0:	12050e63          	beqz	a0,80004afc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049c4:	f2c40613          	addi	a2,s0,-212
    800049c8:	fb040593          	addi	a1,s0,-80
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	6ba080e7          	jalr	1722(ra) # 80003088 <dirlookup>
    800049d6:	892a                	mv	s2,a0
    800049d8:	12050263          	beqz	a0,80004afc <sys_unlink+0x1b0>
  ilock(ip);
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	1c8080e7          	jalr	456(ra) # 80002ba4 <ilock>
  if(ip->nlink < 1)
    800049e4:	04a91783          	lh	a5,74(s2)
    800049e8:	08f05263          	blez	a5,80004a6c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049ec:	04491703          	lh	a4,68(s2)
    800049f0:	4785                	li	a5,1
    800049f2:	08f70563          	beq	a4,a5,80004a7c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049f6:	4641                	li	a2,16
    800049f8:	4581                	li	a1,0
    800049fa:	fc040513          	addi	a0,s0,-64
    800049fe:	ffffb097          	auipc	ra,0xffffb
    80004a02:	7cc080e7          	jalr	1996(ra) # 800001ca <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a06:	4741                	li	a4,16
    80004a08:	f2c42683          	lw	a3,-212(s0)
    80004a0c:	fc040613          	addi	a2,s0,-64
    80004a10:	4581                	li	a1,0
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	53c080e7          	jalr	1340(ra) # 80002f50 <writei>
    80004a1c:	47c1                	li	a5,16
    80004a1e:	0af51563          	bne	a0,a5,80004ac8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a22:	04491703          	lh	a4,68(s2)
    80004a26:	4785                	li	a5,1
    80004a28:	0af70863          	beq	a4,a5,80004ad8 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	3d8080e7          	jalr	984(ra) # 80002e06 <iunlockput>
  ip->nlink--;
    80004a36:	04a95783          	lhu	a5,74(s2)
    80004a3a:	37fd                	addiw	a5,a5,-1
    80004a3c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	098080e7          	jalr	152(ra) # 80002ada <iupdate>
  iunlockput(ip);
    80004a4a:	854a                	mv	a0,s2
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	3ba080e7          	jalr	954(ra) # 80002e06 <iunlockput>
  end_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	ba2080e7          	jalr	-1118(ra) # 800035f6 <end_op>
  return 0;
    80004a5c:	4501                	li	a0,0
    80004a5e:	a84d                	j	80004b10 <sys_unlink+0x1c4>
    end_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	b96080e7          	jalr	-1130(ra) # 800035f6 <end_op>
    return -1;
    80004a68:	557d                	li	a0,-1
    80004a6a:	a05d                	j	80004b10 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	dd450513          	addi	a0,a0,-556 # 80008840 <syscalls_name+0x2e8>
    80004a74:	00001097          	auipc	ra,0x1
    80004a78:	1a0080e7          	jalr	416(ra) # 80005c14 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a7c:	04c92703          	lw	a4,76(s2)
    80004a80:	02000793          	li	a5,32
    80004a84:	f6e7f9e3          	bgeu	a5,a4,800049f6 <sys_unlink+0xaa>
    80004a88:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a8c:	4741                	li	a4,16
    80004a8e:	86ce                	mv	a3,s3
    80004a90:	f1840613          	addi	a2,s0,-232
    80004a94:	4581                	li	a1,0
    80004a96:	854a                	mv	a0,s2
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	3c0080e7          	jalr	960(ra) # 80002e58 <readi>
    80004aa0:	47c1                	li	a5,16
    80004aa2:	00f51b63          	bne	a0,a5,80004ab8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aa6:	f1845783          	lhu	a5,-232(s0)
    80004aaa:	e7a1                	bnez	a5,80004af2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aac:	29c1                	addiw	s3,s3,16
    80004aae:	04c92783          	lw	a5,76(s2)
    80004ab2:	fcf9ede3          	bltu	s3,a5,80004a8c <sys_unlink+0x140>
    80004ab6:	b781                	j	800049f6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ab8:	00004517          	auipc	a0,0x4
    80004abc:	da050513          	addi	a0,a0,-608 # 80008858 <syscalls_name+0x300>
    80004ac0:	00001097          	auipc	ra,0x1
    80004ac4:	154080e7          	jalr	340(ra) # 80005c14 <panic>
    panic("unlink: writei");
    80004ac8:	00004517          	auipc	a0,0x4
    80004acc:	da850513          	addi	a0,a0,-600 # 80008870 <syscalls_name+0x318>
    80004ad0:	00001097          	auipc	ra,0x1
    80004ad4:	144080e7          	jalr	324(ra) # 80005c14 <panic>
    dp->nlink--;
    80004ad8:	04a4d783          	lhu	a5,74(s1)
    80004adc:	37fd                	addiw	a5,a5,-1
    80004ade:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	ff6080e7          	jalr	-10(ra) # 80002ada <iupdate>
    80004aec:	b781                	j	80004a2c <sys_unlink+0xe0>
    return -1;
    80004aee:	557d                	li	a0,-1
    80004af0:	a005                	j	80004b10 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004af2:	854a                	mv	a0,s2
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	312080e7          	jalr	786(ra) # 80002e06 <iunlockput>
  iunlockput(dp);
    80004afc:	8526                	mv	a0,s1
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	308080e7          	jalr	776(ra) # 80002e06 <iunlockput>
  end_op();
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	af0080e7          	jalr	-1296(ra) # 800035f6 <end_op>
  return -1;
    80004b0e:	557d                	li	a0,-1
}
    80004b10:	70ae                	ld	ra,232(sp)
    80004b12:	740e                	ld	s0,224(sp)
    80004b14:	64ee                	ld	s1,216(sp)
    80004b16:	694e                	ld	s2,208(sp)
    80004b18:	69ae                	ld	s3,200(sp)
    80004b1a:	616d                	addi	sp,sp,240
    80004b1c:	8082                	ret

0000000080004b1e <sys_open>:

uint64
sys_open(void)
{
    80004b1e:	7131                	addi	sp,sp,-192
    80004b20:	fd06                	sd	ra,184(sp)
    80004b22:	f922                	sd	s0,176(sp)
    80004b24:	f526                	sd	s1,168(sp)
    80004b26:	f14a                	sd	s2,160(sp)
    80004b28:	ed4e                	sd	s3,152(sp)
    80004b2a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b2c:	08000613          	li	a2,128
    80004b30:	f5040593          	addi	a1,s0,-176
    80004b34:	4501                	li	a0,0
    80004b36:	ffffd097          	auipc	ra,0xffffd
    80004b3a:	490080e7          	jalr	1168(ra) # 80001fc6 <argstr>
    return -1;
    80004b3e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b40:	0c054163          	bltz	a0,80004c02 <sys_open+0xe4>
    80004b44:	f4c40593          	addi	a1,s0,-180
    80004b48:	4505                	li	a0,1
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	438080e7          	jalr	1080(ra) # 80001f82 <argint>
    80004b52:	0a054863          	bltz	a0,80004c02 <sys_open+0xe4>

  begin_op();
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	a20080e7          	jalr	-1504(ra) # 80003576 <begin_op>

  if(omode & O_CREATE){
    80004b5e:	f4c42783          	lw	a5,-180(s0)
    80004b62:	2007f793          	andi	a5,a5,512
    80004b66:	cbdd                	beqz	a5,80004c1c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b68:	4681                	li	a3,0
    80004b6a:	4601                	li	a2,0
    80004b6c:	4589                	li	a1,2
    80004b6e:	f5040513          	addi	a0,s0,-176
    80004b72:	00000097          	auipc	ra,0x0
    80004b76:	974080e7          	jalr	-1676(ra) # 800044e6 <create>
    80004b7a:	892a                	mv	s2,a0
    if(ip == 0){
    80004b7c:	c959                	beqz	a0,80004c12 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b7e:	04491703          	lh	a4,68(s2)
    80004b82:	478d                	li	a5,3
    80004b84:	00f71763          	bne	a4,a5,80004b92 <sys_open+0x74>
    80004b88:	04695703          	lhu	a4,70(s2)
    80004b8c:	47a5                	li	a5,9
    80004b8e:	0ce7ec63          	bltu	a5,a4,80004c66 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	df4080e7          	jalr	-524(ra) # 80003986 <filealloc>
    80004b9a:	89aa                	mv	s3,a0
    80004b9c:	10050263          	beqz	a0,80004ca0 <sys_open+0x182>
    80004ba0:	00000097          	auipc	ra,0x0
    80004ba4:	904080e7          	jalr	-1788(ra) # 800044a4 <fdalloc>
    80004ba8:	84aa                	mv	s1,a0
    80004baa:	0e054663          	bltz	a0,80004c96 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bae:	04491703          	lh	a4,68(s2)
    80004bb2:	478d                	li	a5,3
    80004bb4:	0cf70463          	beq	a4,a5,80004c7c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bb8:	4789                	li	a5,2
    80004bba:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bbe:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bc2:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bc6:	f4c42783          	lw	a5,-180(s0)
    80004bca:	0017c713          	xori	a4,a5,1
    80004bce:	8b05                	andi	a4,a4,1
    80004bd0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bd4:	0037f713          	andi	a4,a5,3
    80004bd8:	00e03733          	snez	a4,a4
    80004bdc:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004be0:	4007f793          	andi	a5,a5,1024
    80004be4:	c791                	beqz	a5,80004bf0 <sys_open+0xd2>
    80004be6:	04491703          	lh	a4,68(s2)
    80004bea:	4789                	li	a5,2
    80004bec:	08f70f63          	beq	a4,a5,80004c8a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	074080e7          	jalr	116(ra) # 80002c66 <iunlock>
  end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	9fc080e7          	jalr	-1540(ra) # 800035f6 <end_op>

  return fd;
}
    80004c02:	8526                	mv	a0,s1
    80004c04:	70ea                	ld	ra,184(sp)
    80004c06:	744a                	ld	s0,176(sp)
    80004c08:	74aa                	ld	s1,168(sp)
    80004c0a:	790a                	ld	s2,160(sp)
    80004c0c:	69ea                	ld	s3,152(sp)
    80004c0e:	6129                	addi	sp,sp,192
    80004c10:	8082                	ret
      end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	9e4080e7          	jalr	-1564(ra) # 800035f6 <end_op>
      return -1;
    80004c1a:	b7e5                	j	80004c02 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c1c:	f5040513          	addi	a0,s0,-176
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	73a080e7          	jalr	1850(ra) # 8000335a <namei>
    80004c28:	892a                	mv	s2,a0
    80004c2a:	c905                	beqz	a0,80004c5a <sys_open+0x13c>
    ilock(ip);
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	f78080e7          	jalr	-136(ra) # 80002ba4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c34:	04491703          	lh	a4,68(s2)
    80004c38:	4785                	li	a5,1
    80004c3a:	f4f712e3          	bne	a4,a5,80004b7e <sys_open+0x60>
    80004c3e:	f4c42783          	lw	a5,-180(s0)
    80004c42:	dba1                	beqz	a5,80004b92 <sys_open+0x74>
      iunlockput(ip);
    80004c44:	854a                	mv	a0,s2
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	1c0080e7          	jalr	448(ra) # 80002e06 <iunlockput>
      end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	9a8080e7          	jalr	-1624(ra) # 800035f6 <end_op>
      return -1;
    80004c56:	54fd                	li	s1,-1
    80004c58:	b76d                	j	80004c02 <sys_open+0xe4>
      end_op();
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	99c080e7          	jalr	-1636(ra) # 800035f6 <end_op>
      return -1;
    80004c62:	54fd                	li	s1,-1
    80004c64:	bf79                	j	80004c02 <sys_open+0xe4>
    iunlockput(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	19e080e7          	jalr	414(ra) # 80002e06 <iunlockput>
    end_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	986080e7          	jalr	-1658(ra) # 800035f6 <end_op>
    return -1;
    80004c78:	54fd                	li	s1,-1
    80004c7a:	b761                	j	80004c02 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c7c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c80:	04691783          	lh	a5,70(s2)
    80004c84:	02f99223          	sh	a5,36(s3)
    80004c88:	bf2d                	j	80004bc2 <sys_open+0xa4>
    itrunc(ip);
    80004c8a:	854a                	mv	a0,s2
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	026080e7          	jalr	38(ra) # 80002cb2 <itrunc>
    80004c94:	bfb1                	j	80004bf0 <sys_open+0xd2>
      fileclose(f);
    80004c96:	854e                	mv	a0,s3
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	daa080e7          	jalr	-598(ra) # 80003a42 <fileclose>
    iunlockput(ip);
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	164080e7          	jalr	356(ra) # 80002e06 <iunlockput>
    end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	94c080e7          	jalr	-1716(ra) # 800035f6 <end_op>
    return -1;
    80004cb2:	54fd                	li	s1,-1
    80004cb4:	b7b9                	j	80004c02 <sys_open+0xe4>

0000000080004cb6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cb6:	7175                	addi	sp,sp,-144
    80004cb8:	e506                	sd	ra,136(sp)
    80004cba:	e122                	sd	s0,128(sp)
    80004cbc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	8b8080e7          	jalr	-1864(ra) # 80003576 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cc6:	08000613          	li	a2,128
    80004cca:	f7040593          	addi	a1,s0,-144
    80004cce:	4501                	li	a0,0
    80004cd0:	ffffd097          	auipc	ra,0xffffd
    80004cd4:	2f6080e7          	jalr	758(ra) # 80001fc6 <argstr>
    80004cd8:	02054963          	bltz	a0,80004d0a <sys_mkdir+0x54>
    80004cdc:	4681                	li	a3,0
    80004cde:	4601                	li	a2,0
    80004ce0:	4585                	li	a1,1
    80004ce2:	f7040513          	addi	a0,s0,-144
    80004ce6:	00000097          	auipc	ra,0x0
    80004cea:	800080e7          	jalr	-2048(ra) # 800044e6 <create>
    80004cee:	cd11                	beqz	a0,80004d0a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	116080e7          	jalr	278(ra) # 80002e06 <iunlockput>
  end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	8fe080e7          	jalr	-1794(ra) # 800035f6 <end_op>
  return 0;
    80004d00:	4501                	li	a0,0
}
    80004d02:	60aa                	ld	ra,136(sp)
    80004d04:	640a                	ld	s0,128(sp)
    80004d06:	6149                	addi	sp,sp,144
    80004d08:	8082                	ret
    end_op();
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	8ec080e7          	jalr	-1812(ra) # 800035f6 <end_op>
    return -1;
    80004d12:	557d                	li	a0,-1
    80004d14:	b7fd                	j	80004d02 <sys_mkdir+0x4c>

0000000080004d16 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d16:	7135                	addi	sp,sp,-160
    80004d18:	ed06                	sd	ra,152(sp)
    80004d1a:	e922                	sd	s0,144(sp)
    80004d1c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	858080e7          	jalr	-1960(ra) # 80003576 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d26:	08000613          	li	a2,128
    80004d2a:	f7040593          	addi	a1,s0,-144
    80004d2e:	4501                	li	a0,0
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	296080e7          	jalr	662(ra) # 80001fc6 <argstr>
    80004d38:	04054a63          	bltz	a0,80004d8c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d3c:	f6c40593          	addi	a1,s0,-148
    80004d40:	4505                	li	a0,1
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	240080e7          	jalr	576(ra) # 80001f82 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d4a:	04054163          	bltz	a0,80004d8c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d4e:	f6840593          	addi	a1,s0,-152
    80004d52:	4509                	li	a0,2
    80004d54:	ffffd097          	auipc	ra,0xffffd
    80004d58:	22e080e7          	jalr	558(ra) # 80001f82 <argint>
     argint(1, &major) < 0 ||
    80004d5c:	02054863          	bltz	a0,80004d8c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d60:	f6841683          	lh	a3,-152(s0)
    80004d64:	f6c41603          	lh	a2,-148(s0)
    80004d68:	458d                	li	a1,3
    80004d6a:	f7040513          	addi	a0,s0,-144
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	778080e7          	jalr	1912(ra) # 800044e6 <create>
     argint(2, &minor) < 0 ||
    80004d76:	c919                	beqz	a0,80004d8c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	08e080e7          	jalr	142(ra) # 80002e06 <iunlockput>
  end_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	876080e7          	jalr	-1930(ra) # 800035f6 <end_op>
  return 0;
    80004d88:	4501                	li	a0,0
    80004d8a:	a031                	j	80004d96 <sys_mknod+0x80>
    end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	86a080e7          	jalr	-1942(ra) # 800035f6 <end_op>
    return -1;
    80004d94:	557d                	li	a0,-1
}
    80004d96:	60ea                	ld	ra,152(sp)
    80004d98:	644a                	ld	s0,144(sp)
    80004d9a:	610d                	addi	sp,sp,160
    80004d9c:	8082                	ret

0000000080004d9e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d9e:	7135                	addi	sp,sp,-160
    80004da0:	ed06                	sd	ra,152(sp)
    80004da2:	e922                	sd	s0,144(sp)
    80004da4:	e526                	sd	s1,136(sp)
    80004da6:	e14a                	sd	s2,128(sp)
    80004da8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	0ea080e7          	jalr	234(ra) # 80000e94 <myproc>
    80004db2:	892a                	mv	s2,a0
  
  begin_op();
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	7c2080e7          	jalr	1986(ra) # 80003576 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f6040593          	addi	a1,s0,-160
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	200080e7          	jalr	512(ra) # 80001fc6 <argstr>
    80004dce:	04054b63          	bltz	a0,80004e24 <sys_chdir+0x86>
    80004dd2:	f6040513          	addi	a0,s0,-160
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	584080e7          	jalr	1412(ra) # 8000335a <namei>
    80004dde:	84aa                	mv	s1,a0
    80004de0:	c131                	beqz	a0,80004e24 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	dc2080e7          	jalr	-574(ra) # 80002ba4 <ilock>
  if(ip->type != T_DIR){
    80004dea:	04449703          	lh	a4,68(s1)
    80004dee:	4785                	li	a5,1
    80004df0:	04f71063          	bne	a4,a5,80004e30 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004df4:	8526                	mv	a0,s1
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	e70080e7          	jalr	-400(ra) # 80002c66 <iunlock>
  iput(p->cwd);
    80004dfe:	15093503          	ld	a0,336(s2)
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	f5c080e7          	jalr	-164(ra) # 80002d5e <iput>
  end_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	7ec080e7          	jalr	2028(ra) # 800035f6 <end_op>
  p->cwd = ip;
    80004e12:	14993823          	sd	s1,336(s2)
  return 0;
    80004e16:	4501                	li	a0,0
}
    80004e18:	60ea                	ld	ra,152(sp)
    80004e1a:	644a                	ld	s0,144(sp)
    80004e1c:	64aa                	ld	s1,136(sp)
    80004e1e:	690a                	ld	s2,128(sp)
    80004e20:	610d                	addi	sp,sp,160
    80004e22:	8082                	ret
    end_op();
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	7d2080e7          	jalr	2002(ra) # 800035f6 <end_op>
    return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	b7ed                	j	80004e18 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	fd4080e7          	jalr	-44(ra) # 80002e06 <iunlockput>
    end_op();
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	7bc080e7          	jalr	1980(ra) # 800035f6 <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	bfd1                	j	80004e18 <sys_chdir+0x7a>

0000000080004e46 <sys_exec>:

uint64
sys_exec(void)
{
    80004e46:	7145                	addi	sp,sp,-464
    80004e48:	e786                	sd	ra,456(sp)
    80004e4a:	e3a2                	sd	s0,448(sp)
    80004e4c:	ff26                	sd	s1,440(sp)
    80004e4e:	fb4a                	sd	s2,432(sp)
    80004e50:	f74e                	sd	s3,424(sp)
    80004e52:	f352                	sd	s4,416(sp)
    80004e54:	ef56                	sd	s5,408(sp)
    80004e56:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e58:	08000613          	li	a2,128
    80004e5c:	f4040593          	addi	a1,s0,-192
    80004e60:	4501                	li	a0,0
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	164080e7          	jalr	356(ra) # 80001fc6 <argstr>
    return -1;
    80004e6a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e6c:	0c054a63          	bltz	a0,80004f40 <sys_exec+0xfa>
    80004e70:	e3840593          	addi	a1,s0,-456
    80004e74:	4505                	li	a0,1
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	12e080e7          	jalr	302(ra) # 80001fa4 <argaddr>
    80004e7e:	0c054163          	bltz	a0,80004f40 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e82:	10000613          	li	a2,256
    80004e86:	4581                	li	a1,0
    80004e88:	e4040513          	addi	a0,s0,-448
    80004e8c:	ffffb097          	auipc	ra,0xffffb
    80004e90:	33e080e7          	jalr	830(ra) # 800001ca <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e94:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e98:	89a6                	mv	s3,s1
    80004e9a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e9c:	02000a13          	li	s4,32
    80004ea0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ea4:	00391793          	slli	a5,s2,0x3
    80004ea8:	e3040593          	addi	a1,s0,-464
    80004eac:	e3843503          	ld	a0,-456(s0)
    80004eb0:	953e                	add	a0,a0,a5
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	036080e7          	jalr	54(ra) # 80001ee8 <fetchaddr>
    80004eba:	02054a63          	bltz	a0,80004eee <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ebe:	e3043783          	ld	a5,-464(s0)
    80004ec2:	c3b9                	beqz	a5,80004f08 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ec4:	ffffb097          	auipc	ra,0xffffb
    80004ec8:	254080e7          	jalr	596(ra) # 80000118 <kalloc>
    80004ecc:	85aa                	mv	a1,a0
    80004ece:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ed2:	cd11                	beqz	a0,80004eee <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ed4:	6605                	lui	a2,0x1
    80004ed6:	e3043503          	ld	a0,-464(s0)
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	060080e7          	jalr	96(ra) # 80001f3a <fetchstr>
    80004ee2:	00054663          	bltz	a0,80004eee <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ee6:	0905                	addi	s2,s2,1
    80004ee8:	09a1                	addi	s3,s3,8
    80004eea:	fb491be3          	bne	s2,s4,80004ea0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eee:	10048913          	addi	s2,s1,256
    80004ef2:	6088                	ld	a0,0(s1)
    80004ef4:	c529                	beqz	a0,80004f3e <sys_exec+0xf8>
    kfree(argv[i]);
    80004ef6:	ffffb097          	auipc	ra,0xffffb
    80004efa:	126080e7          	jalr	294(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004efe:	04a1                	addi	s1,s1,8
    80004f00:	ff2499e3          	bne	s1,s2,80004ef2 <sys_exec+0xac>
  return -1;
    80004f04:	597d                	li	s2,-1
    80004f06:	a82d                	j	80004f40 <sys_exec+0xfa>
      argv[i] = 0;
    80004f08:	0a8e                	slli	s5,s5,0x3
    80004f0a:	fc040793          	addi	a5,s0,-64
    80004f0e:	9abe                	add	s5,s5,a5
    80004f10:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80004f14:	e4040593          	addi	a1,s0,-448
    80004f18:	f4040513          	addi	a0,s0,-192
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	178080e7          	jalr	376(ra) # 80004094 <exec>
    80004f24:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f26:	10048993          	addi	s3,s1,256
    80004f2a:	6088                	ld	a0,0(s1)
    80004f2c:	c911                	beqz	a0,80004f40 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f2e:	ffffb097          	auipc	ra,0xffffb
    80004f32:	0ee080e7          	jalr	238(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f36:	04a1                	addi	s1,s1,8
    80004f38:	ff3499e3          	bne	s1,s3,80004f2a <sys_exec+0xe4>
    80004f3c:	a011                	j	80004f40 <sys_exec+0xfa>
  return -1;
    80004f3e:	597d                	li	s2,-1
}
    80004f40:	854a                	mv	a0,s2
    80004f42:	60be                	ld	ra,456(sp)
    80004f44:	641e                	ld	s0,448(sp)
    80004f46:	74fa                	ld	s1,440(sp)
    80004f48:	795a                	ld	s2,432(sp)
    80004f4a:	79ba                	ld	s3,424(sp)
    80004f4c:	7a1a                	ld	s4,416(sp)
    80004f4e:	6afa                	ld	s5,408(sp)
    80004f50:	6179                	addi	sp,sp,464
    80004f52:	8082                	ret

0000000080004f54 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f54:	7139                	addi	sp,sp,-64
    80004f56:	fc06                	sd	ra,56(sp)
    80004f58:	f822                	sd	s0,48(sp)
    80004f5a:	f426                	sd	s1,40(sp)
    80004f5c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f5e:	ffffc097          	auipc	ra,0xffffc
    80004f62:	f36080e7          	jalr	-202(ra) # 80000e94 <myproc>
    80004f66:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f68:	fd840593          	addi	a1,s0,-40
    80004f6c:	4501                	li	a0,0
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	036080e7          	jalr	54(ra) # 80001fa4 <argaddr>
    return -1;
    80004f76:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f78:	0e054063          	bltz	a0,80005058 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f7c:	fc840593          	addi	a1,s0,-56
    80004f80:	fd040513          	addi	a0,s0,-48
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	dee080e7          	jalr	-530(ra) # 80003d72 <pipealloc>
    return -1;
    80004f8c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f8e:	0c054563          	bltz	a0,80005058 <sys_pipe+0x104>
  fd0 = -1;
    80004f92:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f96:	fd043503          	ld	a0,-48(s0)
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	50a080e7          	jalr	1290(ra) # 800044a4 <fdalloc>
    80004fa2:	fca42223          	sw	a0,-60(s0)
    80004fa6:	08054c63          	bltz	a0,8000503e <sys_pipe+0xea>
    80004faa:	fc843503          	ld	a0,-56(s0)
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	4f6080e7          	jalr	1270(ra) # 800044a4 <fdalloc>
    80004fb6:	fca42023          	sw	a0,-64(s0)
    80004fba:	06054863          	bltz	a0,8000502a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fbe:	4691                	li	a3,4
    80004fc0:	fc440613          	addi	a2,s0,-60
    80004fc4:	fd843583          	ld	a1,-40(s0)
    80004fc8:	68a8                	ld	a0,80(s1)
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	b8a080e7          	jalr	-1142(ra) # 80000b54 <copyout>
    80004fd2:	02054063          	bltz	a0,80004ff2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fd6:	4691                	li	a3,4
    80004fd8:	fc040613          	addi	a2,s0,-64
    80004fdc:	fd843583          	ld	a1,-40(s0)
    80004fe0:	0591                	addi	a1,a1,4
    80004fe2:	68a8                	ld	a0,80(s1)
    80004fe4:	ffffc097          	auipc	ra,0xffffc
    80004fe8:	b70080e7          	jalr	-1168(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fec:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fee:	06055563          	bgez	a0,80005058 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ff2:	fc442783          	lw	a5,-60(s0)
    80004ff6:	07e9                	addi	a5,a5,26
    80004ff8:	078e                	slli	a5,a5,0x3
    80004ffa:	97a6                	add	a5,a5,s1
    80004ffc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005000:	fc042503          	lw	a0,-64(s0)
    80005004:	0569                	addi	a0,a0,26
    80005006:	050e                	slli	a0,a0,0x3
    80005008:	9526                	add	a0,a0,s1
    8000500a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000500e:	fd043503          	ld	a0,-48(s0)
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	a30080e7          	jalr	-1488(ra) # 80003a42 <fileclose>
    fileclose(wf);
    8000501a:	fc843503          	ld	a0,-56(s0)
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	a24080e7          	jalr	-1500(ra) # 80003a42 <fileclose>
    return -1;
    80005026:	57fd                	li	a5,-1
    80005028:	a805                	j	80005058 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000502a:	fc442783          	lw	a5,-60(s0)
    8000502e:	0007c863          	bltz	a5,8000503e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005032:	01a78513          	addi	a0,a5,26
    80005036:	050e                	slli	a0,a0,0x3
    80005038:	9526                	add	a0,a0,s1
    8000503a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000503e:	fd043503          	ld	a0,-48(s0)
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	a00080e7          	jalr	-1536(ra) # 80003a42 <fileclose>
    fileclose(wf);
    8000504a:	fc843503          	ld	a0,-56(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	9f4080e7          	jalr	-1548(ra) # 80003a42 <fileclose>
    return -1;
    80005056:	57fd                	li	a5,-1
}
    80005058:	853e                	mv	a0,a5
    8000505a:	70e2                	ld	ra,56(sp)
    8000505c:	7442                	ld	s0,48(sp)
    8000505e:	74a2                	ld	s1,40(sp)
    80005060:	6121                	addi	sp,sp,64
    80005062:	8082                	ret
	...

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	d05fc0ef          	jal	ra,80001db4 <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e422                	sd	s0,8(sp)
    8000512e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005130:	0c0007b7          	lui	a5,0xc000
    80005134:	4705                	li	a4,1
    80005136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005138:	c3d8                	sw	a4,4(a5)
}
    8000513a:	6422                	ld	s0,8(sp)
    8000513c:	0141                	addi	sp,sp,16
    8000513e:	8082                	ret

0000000080005140 <plicinithart>:

void
plicinithart(void)
{
    80005140:	1141                	addi	sp,sp,-16
    80005142:	e406                	sd	ra,8(sp)
    80005144:	e022                	sd	s0,0(sp)
    80005146:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d20080e7          	jalr	-736(ra) # 80000e68 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005150:	0085171b          	slliw	a4,a0,0x8
    80005154:	0c0027b7          	lui	a5,0xc002
    80005158:	97ba                	add	a5,a5,a4
    8000515a:	40200713          	li	a4,1026
    8000515e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005162:	00d5151b          	slliw	a0,a0,0xd
    80005166:	0c2017b7          	lui	a5,0xc201
    8000516a:	953e                	add	a0,a0,a5
    8000516c:	00052023          	sw	zero,0(a0)
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret

0000000080005178 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005178:	1141                	addi	sp,sp,-16
    8000517a:	e406                	sd	ra,8(sp)
    8000517c:	e022                	sd	s0,0(sp)
    8000517e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	ce8080e7          	jalr	-792(ra) # 80000e68 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005188:	00d5179b          	slliw	a5,a0,0xd
    8000518c:	0c201537          	lui	a0,0xc201
    80005190:	953e                	add	a0,a0,a5
  return irq;
}
    80005192:	4148                	lw	a0,4(a0)
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000519c:	1101                	addi	sp,sp,-32
    8000519e:	ec06                	sd	ra,24(sp)
    800051a0:	e822                	sd	s0,16(sp)
    800051a2:	e426                	sd	s1,8(sp)
    800051a4:	1000                	addi	s0,sp,32
    800051a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	cc0080e7          	jalr	-832(ra) # 80000e68 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051b0:	00d5151b          	slliw	a0,a0,0xd
    800051b4:	0c2017b7          	lui	a5,0xc201
    800051b8:	97aa                	add	a5,a5,a0
    800051ba:	c3c4                	sw	s1,4(a5)
}
    800051bc:	60e2                	ld	ra,24(sp)
    800051be:	6442                	ld	s0,16(sp)
    800051c0:	64a2                	ld	s1,8(sp)
    800051c2:	6105                	addi	sp,sp,32
    800051c4:	8082                	ret

00000000800051c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051c6:	1141                	addi	sp,sp,-16
    800051c8:	e406                	sd	ra,8(sp)
    800051ca:	e022                	sd	s0,0(sp)
    800051cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ce:	479d                	li	a5,7
    800051d0:	06a7c963          	blt	a5,a0,80005242 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051d4:	00016797          	auipc	a5,0x16
    800051d8:	e2c78793          	addi	a5,a5,-468 # 8001b000 <disk>
    800051dc:	00a78733          	add	a4,a5,a0
    800051e0:	6789                	lui	a5,0x2
    800051e2:	97ba                	add	a5,a5,a4
    800051e4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051e8:	e7ad                	bnez	a5,80005252 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ea:	00451793          	slli	a5,a0,0x4
    800051ee:	00018717          	auipc	a4,0x18
    800051f2:	e1270713          	addi	a4,a4,-494 # 8001d000 <disk+0x2000>
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051fe:	6314                	ld	a3,0(a4)
    80005200:	96be                	add	a3,a3,a5
    80005202:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005206:	6314                	ld	a3,0(a4)
    80005208:	96be                	add	a3,a3,a5
    8000520a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000520e:	6318                	ld	a4,0(a4)
    80005210:	97ba                	add	a5,a5,a4
    80005212:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005216:	00016797          	auipc	a5,0x16
    8000521a:	dea78793          	addi	a5,a5,-534 # 8001b000 <disk>
    8000521e:	97aa                	add	a5,a5,a0
    80005220:	6509                	lui	a0,0x2
    80005222:	953e                	add	a0,a0,a5
    80005224:	4785                	li	a5,1
    80005226:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000522a:	00018517          	auipc	a0,0x18
    8000522e:	dee50513          	addi	a0,a0,-530 # 8001d018 <disk+0x2018>
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	4b6080e7          	jalr	1206(ra) # 800016e8 <wakeup>
}
    8000523a:	60a2                	ld	ra,8(sp)
    8000523c:	6402                	ld	s0,0(sp)
    8000523e:	0141                	addi	sp,sp,16
    80005240:	8082                	ret
    panic("free_desc 1");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	63e50513          	addi	a0,a0,1598 # 80008880 <syscalls_name+0x328>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	9ca080e7          	jalr	-1590(ra) # 80005c14 <panic>
    panic("free_desc 2");
    80005252:	00003517          	auipc	a0,0x3
    80005256:	63e50513          	addi	a0,a0,1598 # 80008890 <syscalls_name+0x338>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	9ba080e7          	jalr	-1606(ra) # 80005c14 <panic>

0000000080005262 <virtio_disk_init>:
{
    80005262:	1101                	addi	sp,sp,-32
    80005264:	ec06                	sd	ra,24(sp)
    80005266:	e822                	sd	s0,16(sp)
    80005268:	e426                	sd	s1,8(sp)
    8000526a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000526c:	00003597          	auipc	a1,0x3
    80005270:	63458593          	addi	a1,a1,1588 # 800088a0 <syscalls_name+0x348>
    80005274:	00018517          	auipc	a0,0x18
    80005278:	eb450513          	addi	a0,a0,-332 # 8001d128 <disk+0x2128>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	e44080e7          	jalr	-444(ra) # 800060c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005284:	100017b7          	lui	a5,0x10001
    80005288:	4398                	lw	a4,0(a5)
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	747277b7          	lui	a5,0x74727
    80005290:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005294:	0ef71163          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005298:	100017b7          	lui	a5,0x10001
    8000529c:	43dc                	lw	a5,4(a5)
    8000529e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a0:	4705                	li	a4,1
    800052a2:	0ce79a63          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a6:	100017b7          	lui	a5,0x10001
    800052aa:	479c                	lw	a5,8(a5)
    800052ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ae:	4709                	li	a4,2
    800052b0:	0ce79363          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	47d8                	lw	a4,12(a5)
    800052ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052bc:	554d47b7          	lui	a5,0x554d4
    800052c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052c4:	0af71963          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	4705                	li	a4,1
    800052ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	470d                	li	a4,3
    800052d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052d4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052d6:	c7ffe737          	lui	a4,0xc7ffe
    800052da:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052de:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052e0:	2701                	sext.w	a4,a4
    800052e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e4:	472d                	li	a4,11
    800052e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e8:	473d                	li	a4,15
    800052ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052ec:	6705                	lui	a4,0x1
    800052ee:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052f4:	5bdc                	lw	a5,52(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052f8:	c7d9                	beqz	a5,80005386 <virtio_disk_init+0x124>
  if(max < NUM)
    800052fa:	471d                	li	a4,7
    800052fc:	08f77d63          	bgeu	a4,a5,80005396 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005300:	100014b7          	lui	s1,0x10001
    80005304:	47a1                	li	a5,8
    80005306:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005308:	6609                	lui	a2,0x2
    8000530a:	4581                	li	a1,0
    8000530c:	00016517          	auipc	a0,0x16
    80005310:	cf450513          	addi	a0,a0,-780 # 8001b000 <disk>
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	eb6080e7          	jalr	-330(ra) # 800001ca <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000531c:	00016717          	auipc	a4,0x16
    80005320:	ce470713          	addi	a4,a4,-796 # 8001b000 <disk>
    80005324:	00c75793          	srli	a5,a4,0xc
    80005328:	2781                	sext.w	a5,a5
    8000532a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000532c:	00018797          	auipc	a5,0x18
    80005330:	cd478793          	addi	a5,a5,-812 # 8001d000 <disk+0x2000>
    80005334:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005336:	00016717          	auipc	a4,0x16
    8000533a:	d4a70713          	addi	a4,a4,-694 # 8001b080 <disk+0x80>
    8000533e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005340:	00017717          	auipc	a4,0x17
    80005344:	cc070713          	addi	a4,a4,-832 # 8001c000 <disk+0x1000>
    80005348:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000534a:	4705                	li	a4,1
    8000534c:	00e78c23          	sb	a4,24(a5)
    80005350:	00e78ca3          	sb	a4,25(a5)
    80005354:	00e78d23          	sb	a4,26(a5)
    80005358:	00e78da3          	sb	a4,27(a5)
    8000535c:	00e78e23          	sb	a4,28(a5)
    80005360:	00e78ea3          	sb	a4,29(a5)
    80005364:	00e78f23          	sb	a4,30(a5)
    80005368:	00e78fa3          	sb	a4,31(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret
    panic("could not find virtio disk");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	53a50513          	addi	a0,a0,1338 # 800088b0 <syscalls_name+0x358>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	896080e7          	jalr	-1898(ra) # 80005c14 <panic>
    panic("virtio disk has no queue 0");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	54a50513          	addi	a0,a0,1354 # 800088d0 <syscalls_name+0x378>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	886080e7          	jalr	-1914(ra) # 80005c14 <panic>
    panic("virtio disk max queue too short");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	55a50513          	addi	a0,a0,1370 # 800088f0 <syscalls_name+0x398>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	876080e7          	jalr	-1930(ra) # 80005c14 <panic>

00000000800053a6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053a6:	7119                	addi	sp,sp,-128
    800053a8:	fc86                	sd	ra,120(sp)
    800053aa:	f8a2                	sd	s0,112(sp)
    800053ac:	f4a6                	sd	s1,104(sp)
    800053ae:	f0ca                	sd	s2,96(sp)
    800053b0:	ecce                	sd	s3,88(sp)
    800053b2:	e8d2                	sd	s4,80(sp)
    800053b4:	e4d6                	sd	s5,72(sp)
    800053b6:	e0da                	sd	s6,64(sp)
    800053b8:	fc5e                	sd	s7,56(sp)
    800053ba:	f862                	sd	s8,48(sp)
    800053bc:	f466                	sd	s9,40(sp)
    800053be:	f06a                	sd	s10,32(sp)
    800053c0:	ec6e                	sd	s11,24(sp)
    800053c2:	0100                	addi	s0,sp,128
    800053c4:	8aaa                	mv	s5,a0
    800053c6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053c8:	00c52c83          	lw	s9,12(a0)
    800053cc:	001c9c9b          	slliw	s9,s9,0x1
    800053d0:	1c82                	slli	s9,s9,0x20
    800053d2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053d6:	00018517          	auipc	a0,0x18
    800053da:	d5250513          	addi	a0,a0,-686 # 8001d128 <disk+0x2128>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	d72080e7          	jalr	-654(ra) # 80006150 <acquire>
  for(int i = 0; i < 3; i++){
    800053e6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053e8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053ea:	00016c17          	auipc	s8,0x16
    800053ee:	c16c0c13          	addi	s8,s8,-1002 # 8001b000 <disk>
    800053f2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800053f4:	4b0d                	li	s6,3
    800053f6:	a0ad                	j	80005460 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053f8:	00fc0733          	add	a4,s8,a5
    800053fc:	975e                	add	a4,a4,s7
    800053fe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005402:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005404:	0207c563          	bltz	a5,8000542e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005408:	2905                	addiw	s2,s2,1
    8000540a:	0611                	addi	a2,a2,4
    8000540c:	19690d63          	beq	s2,s6,800055a6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005410:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005412:	00018717          	auipc	a4,0x18
    80005416:	c0670713          	addi	a4,a4,-1018 # 8001d018 <disk+0x2018>
    8000541a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000541c:	00074683          	lbu	a3,0(a4)
    80005420:	fee1                	bnez	a3,800053f8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005422:	2785                	addiw	a5,a5,1
    80005424:	0705                	addi	a4,a4,1
    80005426:	fe979be3          	bne	a5,s1,8000541c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000542a:	57fd                	li	a5,-1
    8000542c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000542e:	01205d63          	blez	s2,80005448 <virtio_disk_rw+0xa2>
    80005432:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005434:	000a2503          	lw	a0,0(s4)
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	d8e080e7          	jalr	-626(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    80005440:	2d85                	addiw	s11,s11,1
    80005442:	0a11                	addi	s4,s4,4
    80005444:	ffb918e3          	bne	s2,s11,80005434 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005448:	00018597          	auipc	a1,0x18
    8000544c:	ce058593          	addi	a1,a1,-800 # 8001d128 <disk+0x2128>
    80005450:	00018517          	auipc	a0,0x18
    80005454:	bc850513          	addi	a0,a0,-1080 # 8001d018 <disk+0x2018>
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	104080e7          	jalr	260(ra) # 8000155c <sleep>
  for(int i = 0; i < 3; i++){
    80005460:	f8040a13          	addi	s4,s0,-128
{
    80005464:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005466:	894e                	mv	s2,s3
    80005468:	b765                	j	80005410 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000546a:	00018697          	auipc	a3,0x18
    8000546e:	b966b683          	ld	a3,-1130(a3) # 8001d000 <disk+0x2000>
    80005472:	96ba                	add	a3,a3,a4
    80005474:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005478:	00016817          	auipc	a6,0x16
    8000547c:	b8880813          	addi	a6,a6,-1144 # 8001b000 <disk>
    80005480:	00018697          	auipc	a3,0x18
    80005484:	b8068693          	addi	a3,a3,-1152 # 8001d000 <disk+0x2000>
    80005488:	6290                	ld	a2,0(a3)
    8000548a:	963a                	add	a2,a2,a4
    8000548c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005490:	0015e593          	ori	a1,a1,1
    80005494:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005498:	f8842603          	lw	a2,-120(s0)
    8000549c:	628c                	ld	a1,0(a3)
    8000549e:	972e                	add	a4,a4,a1
    800054a0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054a4:	20050593          	addi	a1,a0,512
    800054a8:	0592                	slli	a1,a1,0x4
    800054aa:	95c2                	add	a1,a1,a6
    800054ac:	577d                	li	a4,-1
    800054ae:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054b2:	00461713          	slli	a4,a2,0x4
    800054b6:	6290                	ld	a2,0(a3)
    800054b8:	963a                	add	a2,a2,a4
    800054ba:	03078793          	addi	a5,a5,48
    800054be:	97c2                	add	a5,a5,a6
    800054c0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054c2:	629c                	ld	a5,0(a3)
    800054c4:	97ba                	add	a5,a5,a4
    800054c6:	4605                	li	a2,1
    800054c8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054ca:	629c                	ld	a5,0(a3)
    800054cc:	97ba                	add	a5,a5,a4
    800054ce:	4809                	li	a6,2
    800054d0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054d4:	629c                	ld	a5,0(a3)
    800054d6:	973e                	add	a4,a4,a5
    800054d8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054dc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054e0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054e4:	6698                	ld	a4,8(a3)
    800054e6:	00275783          	lhu	a5,2(a4)
    800054ea:	8b9d                	andi	a5,a5,7
    800054ec:	0786                	slli	a5,a5,0x1
    800054ee:	97ba                	add	a5,a5,a4
    800054f0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800054f4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054f8:	6698                	ld	a4,8(a3)
    800054fa:	00275783          	lhu	a5,2(a4)
    800054fe:	2785                	addiw	a5,a5,1
    80005500:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005504:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005508:	100017b7          	lui	a5,0x10001
    8000550c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005510:	004aa783          	lw	a5,4(s5)
    80005514:	02c79163          	bne	a5,a2,80005536 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005518:	00018917          	auipc	s2,0x18
    8000551c:	c1090913          	addi	s2,s2,-1008 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005520:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005522:	85ca                	mv	a1,s2
    80005524:	8556                	mv	a0,s5
    80005526:	ffffc097          	auipc	ra,0xffffc
    8000552a:	036080e7          	jalr	54(ra) # 8000155c <sleep>
  while(b->disk == 1) {
    8000552e:	004aa783          	lw	a5,4(s5)
    80005532:	fe9788e3          	beq	a5,s1,80005522 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005536:	f8042903          	lw	s2,-128(s0)
    8000553a:	20090793          	addi	a5,s2,512
    8000553e:	00479713          	slli	a4,a5,0x4
    80005542:	00016797          	auipc	a5,0x16
    80005546:	abe78793          	addi	a5,a5,-1346 # 8001b000 <disk>
    8000554a:	97ba                	add	a5,a5,a4
    8000554c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005550:	00018997          	auipc	s3,0x18
    80005554:	ab098993          	addi	s3,s3,-1360 # 8001d000 <disk+0x2000>
    80005558:	00491713          	slli	a4,s2,0x4
    8000555c:	0009b783          	ld	a5,0(s3)
    80005560:	97ba                	add	a5,a5,a4
    80005562:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005566:	854a                	mv	a0,s2
    80005568:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000556c:	00000097          	auipc	ra,0x0
    80005570:	c5a080e7          	jalr	-934(ra) # 800051c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005574:	8885                	andi	s1,s1,1
    80005576:	f0ed                	bnez	s1,80005558 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005578:	00018517          	auipc	a0,0x18
    8000557c:	bb050513          	addi	a0,a0,-1104 # 8001d128 <disk+0x2128>
    80005580:	00001097          	auipc	ra,0x1
    80005584:	c84080e7          	jalr	-892(ra) # 80006204 <release>
}
    80005588:	70e6                	ld	ra,120(sp)
    8000558a:	7446                	ld	s0,112(sp)
    8000558c:	74a6                	ld	s1,104(sp)
    8000558e:	7906                	ld	s2,96(sp)
    80005590:	69e6                	ld	s3,88(sp)
    80005592:	6a46                	ld	s4,80(sp)
    80005594:	6aa6                	ld	s5,72(sp)
    80005596:	6b06                	ld	s6,64(sp)
    80005598:	7be2                	ld	s7,56(sp)
    8000559a:	7c42                	ld	s8,48(sp)
    8000559c:	7ca2                	ld	s9,40(sp)
    8000559e:	7d02                	ld	s10,32(sp)
    800055a0:	6de2                	ld	s11,24(sp)
    800055a2:	6109                	addi	sp,sp,128
    800055a4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055a6:	f8042503          	lw	a0,-128(s0)
    800055aa:	20050793          	addi	a5,a0,512
    800055ae:	0792                	slli	a5,a5,0x4
  if(write)
    800055b0:	00016817          	auipc	a6,0x16
    800055b4:	a5080813          	addi	a6,a6,-1456 # 8001b000 <disk>
    800055b8:	00f80733          	add	a4,a6,a5
    800055bc:	01a036b3          	snez	a3,s10
    800055c0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055c4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055c8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055cc:	7679                	lui	a2,0xffffe
    800055ce:	963e                	add	a2,a2,a5
    800055d0:	00018697          	auipc	a3,0x18
    800055d4:	a3068693          	addi	a3,a3,-1488 # 8001d000 <disk+0x2000>
    800055d8:	6298                	ld	a4,0(a3)
    800055da:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055dc:	0a878593          	addi	a1,a5,168
    800055e0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055e4:	6298                	ld	a4,0(a3)
    800055e6:	9732                	add	a4,a4,a2
    800055e8:	45c1                	li	a1,16
    800055ea:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ec:	6298                	ld	a4,0(a3)
    800055ee:	9732                	add	a4,a4,a2
    800055f0:	4585                	li	a1,1
    800055f2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055f6:	f8442703          	lw	a4,-124(s0)
    800055fa:	628c                	ld	a1,0(a3)
    800055fc:	962e                	add	a2,a2,a1
    800055fe:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005602:	0712                	slli	a4,a4,0x4
    80005604:	6290                	ld	a2,0(a3)
    80005606:	963a                	add	a2,a2,a4
    80005608:	058a8593          	addi	a1,s5,88
    8000560c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000560e:	6294                	ld	a3,0(a3)
    80005610:	96ba                	add	a3,a3,a4
    80005612:	40000613          	li	a2,1024
    80005616:	c690                	sw	a2,8(a3)
  if(write)
    80005618:	e40d19e3          	bnez	s10,8000546a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000561c:	00018697          	auipc	a3,0x18
    80005620:	9e46b683          	ld	a3,-1564(a3) # 8001d000 <disk+0x2000>
    80005624:	96ba                	add	a3,a3,a4
    80005626:	4609                	li	a2,2
    80005628:	00c69623          	sh	a2,12(a3)
    8000562c:	b5b1                	j	80005478 <virtio_disk_rw+0xd2>

000000008000562e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000562e:	1101                	addi	sp,sp,-32
    80005630:	ec06                	sd	ra,24(sp)
    80005632:	e822                	sd	s0,16(sp)
    80005634:	e426                	sd	s1,8(sp)
    80005636:	e04a                	sd	s2,0(sp)
    80005638:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000563a:	00018517          	auipc	a0,0x18
    8000563e:	aee50513          	addi	a0,a0,-1298 # 8001d128 <disk+0x2128>
    80005642:	00001097          	auipc	ra,0x1
    80005646:	b0e080e7          	jalr	-1266(ra) # 80006150 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000564a:	10001737          	lui	a4,0x10001
    8000564e:	533c                	lw	a5,96(a4)
    80005650:	8b8d                	andi	a5,a5,3
    80005652:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005654:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005658:	00018797          	auipc	a5,0x18
    8000565c:	9a878793          	addi	a5,a5,-1624 # 8001d000 <disk+0x2000>
    80005660:	6b94                	ld	a3,16(a5)
    80005662:	0207d703          	lhu	a4,32(a5)
    80005666:	0026d783          	lhu	a5,2(a3)
    8000566a:	06f70163          	beq	a4,a5,800056cc <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000566e:	00016917          	auipc	s2,0x16
    80005672:	99290913          	addi	s2,s2,-1646 # 8001b000 <disk>
    80005676:	00018497          	auipc	s1,0x18
    8000567a:	98a48493          	addi	s1,s1,-1654 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000567e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005682:	6898                	ld	a4,16(s1)
    80005684:	0204d783          	lhu	a5,32(s1)
    80005688:	8b9d                	andi	a5,a5,7
    8000568a:	078e                	slli	a5,a5,0x3
    8000568c:	97ba                	add	a5,a5,a4
    8000568e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005690:	20078713          	addi	a4,a5,512
    80005694:	0712                	slli	a4,a4,0x4
    80005696:	974a                	add	a4,a4,s2
    80005698:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000569c:	e731                	bnez	a4,800056e8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000569e:	20078793          	addi	a5,a5,512
    800056a2:	0792                	slli	a5,a5,0x4
    800056a4:	97ca                	add	a5,a5,s2
    800056a6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056a8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	03c080e7          	jalr	60(ra) # 800016e8 <wakeup>

    disk.used_idx += 1;
    800056b4:	0204d783          	lhu	a5,32(s1)
    800056b8:	2785                	addiw	a5,a5,1
    800056ba:	17c2                	slli	a5,a5,0x30
    800056bc:	93c1                	srli	a5,a5,0x30
    800056be:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056c2:	6898                	ld	a4,16(s1)
    800056c4:	00275703          	lhu	a4,2(a4)
    800056c8:	faf71be3          	bne	a4,a5,8000567e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056cc:	00018517          	auipc	a0,0x18
    800056d0:	a5c50513          	addi	a0,a0,-1444 # 8001d128 <disk+0x2128>
    800056d4:	00001097          	auipc	ra,0x1
    800056d8:	b30080e7          	jalr	-1232(ra) # 80006204 <release>
}
    800056dc:	60e2                	ld	ra,24(sp)
    800056de:	6442                	ld	s0,16(sp)
    800056e0:	64a2                	ld	s1,8(sp)
    800056e2:	6902                	ld	s2,0(sp)
    800056e4:	6105                	addi	sp,sp,32
    800056e6:	8082                	ret
      panic("virtio_disk_intr status");
    800056e8:	00003517          	auipc	a0,0x3
    800056ec:	22850513          	addi	a0,a0,552 # 80008910 <syscalls_name+0x3b8>
    800056f0:	00000097          	auipc	ra,0x0
    800056f4:	524080e7          	jalr	1316(ra) # 80005c14 <panic>

00000000800056f8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056f8:	1141                	addi	sp,sp,-16
    800056fa:	e422                	sd	s0,8(sp)
    800056fc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056fe:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005702:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005706:	0037979b          	slliw	a5,a5,0x3
    8000570a:	02004737          	lui	a4,0x2004
    8000570e:	97ba                	add	a5,a5,a4
    80005710:	0200c737          	lui	a4,0x200c
    80005714:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005718:	000f4637          	lui	a2,0xf4
    8000571c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005720:	95b2                	add	a1,a1,a2
    80005722:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005724:	00269713          	slli	a4,a3,0x2
    80005728:	9736                	add	a4,a4,a3
    8000572a:	00371693          	slli	a3,a4,0x3
    8000572e:	00019717          	auipc	a4,0x19
    80005732:	8d270713          	addi	a4,a4,-1838 # 8001e000 <timer_scratch>
    80005736:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005738:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000573a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000573c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005740:	00000797          	auipc	a5,0x0
    80005744:	9c078793          	addi	a5,a5,-1600 # 80005100 <timervec>
    80005748:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000574c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005750:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005754:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005758:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000575c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005760:	30479073          	csrw	mie,a5
}
    80005764:	6422                	ld	s0,8(sp)
    80005766:	0141                	addi	sp,sp,16
    80005768:	8082                	ret

000000008000576a <start>:
{
    8000576a:	1141                	addi	sp,sp,-16
    8000576c:	e406                	sd	ra,8(sp)
    8000576e:	e022                	sd	s0,0(sp)
    80005770:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005772:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005776:	7779                	lui	a4,0xffffe
    80005778:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000577c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000577e:	6705                	lui	a4,0x1
    80005780:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005784:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005786:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000578a:	ffffb797          	auipc	a5,0xffffb
    8000578e:	be678793          	addi	a5,a5,-1050 # 80000370 <main>
    80005792:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005796:	4781                	li	a5,0
    80005798:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000579c:	67c1                	lui	a5,0x10
    8000579e:	17fd                	addi	a5,a5,-1
    800057a0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057a4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057a8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ac:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057b0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057b4:	57fd                	li	a5,-1
    800057b6:	83a9                	srli	a5,a5,0xa
    800057b8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057bc:	47bd                	li	a5,15
    800057be:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	f36080e7          	jalr	-202(ra) # 800056f8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057ce:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057d0:	823e                	mv	tp,a5
  asm volatile("mret");
    800057d2:	30200073          	mret
}
    800057d6:	60a2                	ld	ra,8(sp)
    800057d8:	6402                	ld	s0,0(sp)
    800057da:	0141                	addi	sp,sp,16
    800057dc:	8082                	ret

00000000800057de <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057de:	715d                	addi	sp,sp,-80
    800057e0:	e486                	sd	ra,72(sp)
    800057e2:	e0a2                	sd	s0,64(sp)
    800057e4:	fc26                	sd	s1,56(sp)
    800057e6:	f84a                	sd	s2,48(sp)
    800057e8:	f44e                	sd	s3,40(sp)
    800057ea:	f052                	sd	s4,32(sp)
    800057ec:	ec56                	sd	s5,24(sp)
    800057ee:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057f0:	04c05663          	blez	a2,8000583c <consolewrite+0x5e>
    800057f4:	8a2a                	mv	s4,a0
    800057f6:	84ae                	mv	s1,a1
    800057f8:	89b2                	mv	s3,a2
    800057fa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057fc:	5afd                	li	s5,-1
    800057fe:	4685                	li	a3,1
    80005800:	8626                	mv	a2,s1
    80005802:	85d2                	mv	a1,s4
    80005804:	fbf40513          	addi	a0,s0,-65
    80005808:	ffffc097          	auipc	ra,0xffffc
    8000580c:	14e080e7          	jalr	334(ra) # 80001956 <either_copyin>
    80005810:	01550c63          	beq	a0,s5,80005828 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005814:	fbf44503          	lbu	a0,-65(s0)
    80005818:	00000097          	auipc	ra,0x0
    8000581c:	77a080e7          	jalr	1914(ra) # 80005f92 <uartputc>
  for(i = 0; i < n; i++){
    80005820:	2905                	addiw	s2,s2,1
    80005822:	0485                	addi	s1,s1,1
    80005824:	fd299de3          	bne	s3,s2,800057fe <consolewrite+0x20>
  }

  return i;
}
    80005828:	854a                	mv	a0,s2
    8000582a:	60a6                	ld	ra,72(sp)
    8000582c:	6406                	ld	s0,64(sp)
    8000582e:	74e2                	ld	s1,56(sp)
    80005830:	7942                	ld	s2,48(sp)
    80005832:	79a2                	ld	s3,40(sp)
    80005834:	7a02                	ld	s4,32(sp)
    80005836:	6ae2                	ld	s5,24(sp)
    80005838:	6161                	addi	sp,sp,80
    8000583a:	8082                	ret
  for(i = 0; i < n; i++){
    8000583c:	4901                	li	s2,0
    8000583e:	b7ed                	j	80005828 <consolewrite+0x4a>

0000000080005840 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005840:	7159                	addi	sp,sp,-112
    80005842:	f486                	sd	ra,104(sp)
    80005844:	f0a2                	sd	s0,96(sp)
    80005846:	eca6                	sd	s1,88(sp)
    80005848:	e8ca                	sd	s2,80(sp)
    8000584a:	e4ce                	sd	s3,72(sp)
    8000584c:	e0d2                	sd	s4,64(sp)
    8000584e:	fc56                	sd	s5,56(sp)
    80005850:	f85a                	sd	s6,48(sp)
    80005852:	f45e                	sd	s7,40(sp)
    80005854:	f062                	sd	s8,32(sp)
    80005856:	ec66                	sd	s9,24(sp)
    80005858:	e86a                	sd	s10,16(sp)
    8000585a:	1880                	addi	s0,sp,112
    8000585c:	8aaa                	mv	s5,a0
    8000585e:	8a2e                	mv	s4,a1
    80005860:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005862:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005866:	00021517          	auipc	a0,0x21
    8000586a:	8da50513          	addi	a0,a0,-1830 # 80026140 <cons>
    8000586e:	00001097          	auipc	ra,0x1
    80005872:	8e2080e7          	jalr	-1822(ra) # 80006150 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005876:	00021497          	auipc	s1,0x21
    8000587a:	8ca48493          	addi	s1,s1,-1846 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000587e:	00021917          	auipc	s2,0x21
    80005882:	95a90913          	addi	s2,s2,-1702 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005886:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005888:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000588a:	4ca9                	li	s9,10
  while(n > 0){
    8000588c:	07305863          	blez	s3,800058fc <consoleread+0xbc>
    while(cons.r == cons.w){
    80005890:	0984a783          	lw	a5,152(s1)
    80005894:	09c4a703          	lw	a4,156(s1)
    80005898:	02f71463          	bne	a4,a5,800058c0 <consoleread+0x80>
      if(myproc()->killed){
    8000589c:	ffffb097          	auipc	ra,0xffffb
    800058a0:	5f8080e7          	jalr	1528(ra) # 80000e94 <myproc>
    800058a4:	551c                	lw	a5,40(a0)
    800058a6:	e7b5                	bnez	a5,80005912 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058a8:	85a6                	mv	a1,s1
    800058aa:	854a                	mv	a0,s2
    800058ac:	ffffc097          	auipc	ra,0xffffc
    800058b0:	cb0080e7          	jalr	-848(ra) # 8000155c <sleep>
    while(cons.r == cons.w){
    800058b4:	0984a783          	lw	a5,152(s1)
    800058b8:	09c4a703          	lw	a4,156(s1)
    800058bc:	fef700e3          	beq	a4,a5,8000589c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058c0:	0017871b          	addiw	a4,a5,1
    800058c4:	08e4ac23          	sw	a4,152(s1)
    800058c8:	07f7f713          	andi	a4,a5,127
    800058cc:	9726                	add	a4,a4,s1
    800058ce:	01874703          	lbu	a4,24(a4)
    800058d2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058d6:	077d0563          	beq	s10,s7,80005940 <consoleread+0x100>
    cbuf = c;
    800058da:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058de:	4685                	li	a3,1
    800058e0:	f9f40613          	addi	a2,s0,-97
    800058e4:	85d2                	mv	a1,s4
    800058e6:	8556                	mv	a0,s5
    800058e8:	ffffc097          	auipc	ra,0xffffc
    800058ec:	018080e7          	jalr	24(ra) # 80001900 <either_copyout>
    800058f0:	01850663          	beq	a0,s8,800058fc <consoleread+0xbc>
    dst++;
    800058f4:	0a05                	addi	s4,s4,1
    --n;
    800058f6:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058f8:	f99d1ae3          	bne	s10,s9,8000588c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058fc:	00021517          	auipc	a0,0x21
    80005900:	84450513          	addi	a0,a0,-1980 # 80026140 <cons>
    80005904:	00001097          	auipc	ra,0x1
    80005908:	900080e7          	jalr	-1792(ra) # 80006204 <release>

  return target - n;
    8000590c:	413b053b          	subw	a0,s6,s3
    80005910:	a811                	j	80005924 <consoleread+0xe4>
        release(&cons.lock);
    80005912:	00021517          	auipc	a0,0x21
    80005916:	82e50513          	addi	a0,a0,-2002 # 80026140 <cons>
    8000591a:	00001097          	auipc	ra,0x1
    8000591e:	8ea080e7          	jalr	-1814(ra) # 80006204 <release>
        return -1;
    80005922:	557d                	li	a0,-1
}
    80005924:	70a6                	ld	ra,104(sp)
    80005926:	7406                	ld	s0,96(sp)
    80005928:	64e6                	ld	s1,88(sp)
    8000592a:	6946                	ld	s2,80(sp)
    8000592c:	69a6                	ld	s3,72(sp)
    8000592e:	6a06                	ld	s4,64(sp)
    80005930:	7ae2                	ld	s5,56(sp)
    80005932:	7b42                	ld	s6,48(sp)
    80005934:	7ba2                	ld	s7,40(sp)
    80005936:	7c02                	ld	s8,32(sp)
    80005938:	6ce2                	ld	s9,24(sp)
    8000593a:	6d42                	ld	s10,16(sp)
    8000593c:	6165                	addi	sp,sp,112
    8000593e:	8082                	ret
      if(n < target){
    80005940:	0009871b          	sext.w	a4,s3
    80005944:	fb677ce3          	bgeu	a4,s6,800058fc <consoleread+0xbc>
        cons.r--;
    80005948:	00021717          	auipc	a4,0x21
    8000594c:	88f72823          	sw	a5,-1904(a4) # 800261d8 <cons+0x98>
    80005950:	b775                	j	800058fc <consoleread+0xbc>

0000000080005952 <consputc>:
{
    80005952:	1141                	addi	sp,sp,-16
    80005954:	e406                	sd	ra,8(sp)
    80005956:	e022                	sd	s0,0(sp)
    80005958:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000595a:	10000793          	li	a5,256
    8000595e:	00f50a63          	beq	a0,a5,80005972 <consputc+0x20>
    uartputc_sync(c);
    80005962:	00000097          	auipc	ra,0x0
    80005966:	55e080e7          	jalr	1374(ra) # 80005ec0 <uartputc_sync>
}
    8000596a:	60a2                	ld	ra,8(sp)
    8000596c:	6402                	ld	s0,0(sp)
    8000596e:	0141                	addi	sp,sp,16
    80005970:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005972:	4521                	li	a0,8
    80005974:	00000097          	auipc	ra,0x0
    80005978:	54c080e7          	jalr	1356(ra) # 80005ec0 <uartputc_sync>
    8000597c:	02000513          	li	a0,32
    80005980:	00000097          	auipc	ra,0x0
    80005984:	540080e7          	jalr	1344(ra) # 80005ec0 <uartputc_sync>
    80005988:	4521                	li	a0,8
    8000598a:	00000097          	auipc	ra,0x0
    8000598e:	536080e7          	jalr	1334(ra) # 80005ec0 <uartputc_sync>
    80005992:	bfe1                	j	8000596a <consputc+0x18>

0000000080005994 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005994:	1101                	addi	sp,sp,-32
    80005996:	ec06                	sd	ra,24(sp)
    80005998:	e822                	sd	s0,16(sp)
    8000599a:	e426                	sd	s1,8(sp)
    8000599c:	e04a                	sd	s2,0(sp)
    8000599e:	1000                	addi	s0,sp,32
    800059a0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059a2:	00020517          	auipc	a0,0x20
    800059a6:	79e50513          	addi	a0,a0,1950 # 80026140 <cons>
    800059aa:	00000097          	auipc	ra,0x0
    800059ae:	7a6080e7          	jalr	1958(ra) # 80006150 <acquire>

  switch(c){
    800059b2:	47d5                	li	a5,21
    800059b4:	0af48663          	beq	s1,a5,80005a60 <consoleintr+0xcc>
    800059b8:	0297ca63          	blt	a5,s1,800059ec <consoleintr+0x58>
    800059bc:	47a1                	li	a5,8
    800059be:	0ef48763          	beq	s1,a5,80005aac <consoleintr+0x118>
    800059c2:	47c1                	li	a5,16
    800059c4:	10f49a63          	bne	s1,a5,80005ad8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	fe4080e7          	jalr	-28(ra) # 800019ac <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059d0:	00020517          	auipc	a0,0x20
    800059d4:	77050513          	addi	a0,a0,1904 # 80026140 <cons>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	82c080e7          	jalr	-2004(ra) # 80006204 <release>
}
    800059e0:	60e2                	ld	ra,24(sp)
    800059e2:	6442                	ld	s0,16(sp)
    800059e4:	64a2                	ld	s1,8(sp)
    800059e6:	6902                	ld	s2,0(sp)
    800059e8:	6105                	addi	sp,sp,32
    800059ea:	8082                	ret
  switch(c){
    800059ec:	07f00793          	li	a5,127
    800059f0:	0af48e63          	beq	s1,a5,80005aac <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059f4:	00020717          	auipc	a4,0x20
    800059f8:	74c70713          	addi	a4,a4,1868 # 80026140 <cons>
    800059fc:	0a072783          	lw	a5,160(a4)
    80005a00:	09872703          	lw	a4,152(a4)
    80005a04:	9f99                	subw	a5,a5,a4
    80005a06:	07f00713          	li	a4,127
    80005a0a:	fcf763e3          	bltu	a4,a5,800059d0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a0e:	47b5                	li	a5,13
    80005a10:	0cf48763          	beq	s1,a5,80005ade <consoleintr+0x14a>
      consputc(c);
    80005a14:	8526                	mv	a0,s1
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	f3c080e7          	jalr	-196(ra) # 80005952 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a1e:	00020797          	auipc	a5,0x20
    80005a22:	72278793          	addi	a5,a5,1826 # 80026140 <cons>
    80005a26:	0a07a703          	lw	a4,160(a5)
    80005a2a:	0017069b          	addiw	a3,a4,1
    80005a2e:	0006861b          	sext.w	a2,a3
    80005a32:	0ad7a023          	sw	a3,160(a5)
    80005a36:	07f77713          	andi	a4,a4,127
    80005a3a:	97ba                	add	a5,a5,a4
    80005a3c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a40:	47a9                	li	a5,10
    80005a42:	0cf48563          	beq	s1,a5,80005b0c <consoleintr+0x178>
    80005a46:	4791                	li	a5,4
    80005a48:	0cf48263          	beq	s1,a5,80005b0c <consoleintr+0x178>
    80005a4c:	00020797          	auipc	a5,0x20
    80005a50:	78c7a783          	lw	a5,1932(a5) # 800261d8 <cons+0x98>
    80005a54:	0807879b          	addiw	a5,a5,128
    80005a58:	f6f61ce3          	bne	a2,a5,800059d0 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a5c:	863e                	mv	a2,a5
    80005a5e:	a07d                	j	80005b0c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a60:	00020717          	auipc	a4,0x20
    80005a64:	6e070713          	addi	a4,a4,1760 # 80026140 <cons>
    80005a68:	0a072783          	lw	a5,160(a4)
    80005a6c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a70:	00020497          	auipc	s1,0x20
    80005a74:	6d048493          	addi	s1,s1,1744 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a78:	4929                	li	s2,10
    80005a7a:	f4f70be3          	beq	a4,a5,800059d0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a7e:	37fd                	addiw	a5,a5,-1
    80005a80:	07f7f713          	andi	a4,a5,127
    80005a84:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a86:	01874703          	lbu	a4,24(a4)
    80005a8a:	f52703e3          	beq	a4,s2,800059d0 <consoleintr+0x3c>
      cons.e--;
    80005a8e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a92:	10000513          	li	a0,256
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	ebc080e7          	jalr	-324(ra) # 80005952 <consputc>
    while(cons.e != cons.w &&
    80005a9e:	0a04a783          	lw	a5,160(s1)
    80005aa2:	09c4a703          	lw	a4,156(s1)
    80005aa6:	fcf71ce3          	bne	a4,a5,80005a7e <consoleintr+0xea>
    80005aaa:	b71d                	j	800059d0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aac:	00020717          	auipc	a4,0x20
    80005ab0:	69470713          	addi	a4,a4,1684 # 80026140 <cons>
    80005ab4:	0a072783          	lw	a5,160(a4)
    80005ab8:	09c72703          	lw	a4,156(a4)
    80005abc:	f0f70ae3          	beq	a4,a5,800059d0 <consoleintr+0x3c>
      cons.e--;
    80005ac0:	37fd                	addiw	a5,a5,-1
    80005ac2:	00020717          	auipc	a4,0x20
    80005ac6:	70f72f23          	sw	a5,1822(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005aca:	10000513          	li	a0,256
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	e84080e7          	jalr	-380(ra) # 80005952 <consputc>
    80005ad6:	bded                	j	800059d0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ad8:	ee048ce3          	beqz	s1,800059d0 <consoleintr+0x3c>
    80005adc:	bf21                	j	800059f4 <consoleintr+0x60>
      consputc(c);
    80005ade:	4529                	li	a0,10
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	e72080e7          	jalr	-398(ra) # 80005952 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ae8:	00020797          	auipc	a5,0x20
    80005aec:	65878793          	addi	a5,a5,1624 # 80026140 <cons>
    80005af0:	0a07a703          	lw	a4,160(a5)
    80005af4:	0017069b          	addiw	a3,a4,1
    80005af8:	0006861b          	sext.w	a2,a3
    80005afc:	0ad7a023          	sw	a3,160(a5)
    80005b00:	07f77713          	andi	a4,a4,127
    80005b04:	97ba                	add	a5,a5,a4
    80005b06:	4729                	li	a4,10
    80005b08:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b0c:	00020797          	auipc	a5,0x20
    80005b10:	6cc7a823          	sw	a2,1744(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b14:	00020517          	auipc	a0,0x20
    80005b18:	6c450513          	addi	a0,a0,1732 # 800261d8 <cons+0x98>
    80005b1c:	ffffc097          	auipc	ra,0xffffc
    80005b20:	bcc080e7          	jalr	-1076(ra) # 800016e8 <wakeup>
    80005b24:	b575                	j	800059d0 <consoleintr+0x3c>

0000000080005b26 <consoleinit>:

void
consoleinit(void)
{
    80005b26:	1141                	addi	sp,sp,-16
    80005b28:	e406                	sd	ra,8(sp)
    80005b2a:	e022                	sd	s0,0(sp)
    80005b2c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b2e:	00003597          	auipc	a1,0x3
    80005b32:	dfa58593          	addi	a1,a1,-518 # 80008928 <syscalls_name+0x3d0>
    80005b36:	00020517          	auipc	a0,0x20
    80005b3a:	60a50513          	addi	a0,a0,1546 # 80026140 <cons>
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	582080e7          	jalr	1410(ra) # 800060c0 <initlock>

  uartinit();
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	32a080e7          	jalr	810(ra) # 80005e70 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b4e:	00013797          	auipc	a5,0x13
    80005b52:	57a78793          	addi	a5,a5,1402 # 800190c8 <devsw>
    80005b56:	00000717          	auipc	a4,0x0
    80005b5a:	cea70713          	addi	a4,a4,-790 # 80005840 <consoleread>
    80005b5e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b60:	00000717          	auipc	a4,0x0
    80005b64:	c7e70713          	addi	a4,a4,-898 # 800057de <consolewrite>
    80005b68:	ef98                	sd	a4,24(a5)
}
    80005b6a:	60a2                	ld	ra,8(sp)
    80005b6c:	6402                	ld	s0,0(sp)
    80005b6e:	0141                	addi	sp,sp,16
    80005b70:	8082                	ret

0000000080005b72 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b72:	7179                	addi	sp,sp,-48
    80005b74:	f406                	sd	ra,40(sp)
    80005b76:	f022                	sd	s0,32(sp)
    80005b78:	ec26                	sd	s1,24(sp)
    80005b7a:	e84a                	sd	s2,16(sp)
    80005b7c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b7e:	c219                	beqz	a2,80005b84 <printint+0x12>
    80005b80:	08054663          	bltz	a0,80005c0c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b84:	2501                	sext.w	a0,a0
    80005b86:	4881                	li	a7,0
    80005b88:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b8c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b8e:	2581                	sext.w	a1,a1
    80005b90:	00003617          	auipc	a2,0x3
    80005b94:	dc860613          	addi	a2,a2,-568 # 80008958 <digits>
    80005b98:	883a                	mv	a6,a4
    80005b9a:	2705                	addiw	a4,a4,1
    80005b9c:	02b577bb          	remuw	a5,a0,a1
    80005ba0:	1782                	slli	a5,a5,0x20
    80005ba2:	9381                	srli	a5,a5,0x20
    80005ba4:	97b2                	add	a5,a5,a2
    80005ba6:	0007c783          	lbu	a5,0(a5)
    80005baa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bae:	0005079b          	sext.w	a5,a0
    80005bb2:	02b5553b          	divuw	a0,a0,a1
    80005bb6:	0685                	addi	a3,a3,1
    80005bb8:	feb7f0e3          	bgeu	a5,a1,80005b98 <printint+0x26>

  if(sign)
    80005bbc:	00088b63          	beqz	a7,80005bd2 <printint+0x60>
    buf[i++] = '-';
    80005bc0:	fe040793          	addi	a5,s0,-32
    80005bc4:	973e                	add	a4,a4,a5
    80005bc6:	02d00793          	li	a5,45
    80005bca:	fef70823          	sb	a5,-16(a4)
    80005bce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bd2:	02e05763          	blez	a4,80005c00 <printint+0x8e>
    80005bd6:	fd040793          	addi	a5,s0,-48
    80005bda:	00e784b3          	add	s1,a5,a4
    80005bde:	fff78913          	addi	s2,a5,-1
    80005be2:	993a                	add	s2,s2,a4
    80005be4:	377d                	addiw	a4,a4,-1
    80005be6:	1702                	slli	a4,a4,0x20
    80005be8:	9301                	srli	a4,a4,0x20
    80005bea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bee:	fff4c503          	lbu	a0,-1(s1)
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	d60080e7          	jalr	-672(ra) # 80005952 <consputc>
  while(--i >= 0)
    80005bfa:	14fd                	addi	s1,s1,-1
    80005bfc:	ff2499e3          	bne	s1,s2,80005bee <printint+0x7c>
}
    80005c00:	70a2                	ld	ra,40(sp)
    80005c02:	7402                	ld	s0,32(sp)
    80005c04:	64e2                	ld	s1,24(sp)
    80005c06:	6942                	ld	s2,16(sp)
    80005c08:	6145                	addi	sp,sp,48
    80005c0a:	8082                	ret
    x = -xx;
    80005c0c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c10:	4885                	li	a7,1
    x = -xx;
    80005c12:	bf9d                	j	80005b88 <printint+0x16>

0000000080005c14 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c14:	1101                	addi	sp,sp,-32
    80005c16:	ec06                	sd	ra,24(sp)
    80005c18:	e822                	sd	s0,16(sp)
    80005c1a:	e426                	sd	s1,8(sp)
    80005c1c:	1000                	addi	s0,sp,32
    80005c1e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c20:	00020797          	auipc	a5,0x20
    80005c24:	5e07a023          	sw	zero,1504(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c28:	00003517          	auipc	a0,0x3
    80005c2c:	d0850513          	addi	a0,a0,-760 # 80008930 <syscalls_name+0x3d8>
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	02e080e7          	jalr	46(ra) # 80005c5e <printf>
  printf(s);
    80005c38:	8526                	mv	a0,s1
    80005c3a:	00000097          	auipc	ra,0x0
    80005c3e:	024080e7          	jalr	36(ra) # 80005c5e <printf>
  printf("\n");
    80005c42:	00002517          	auipc	a0,0x2
    80005c46:	40650513          	addi	a0,a0,1030 # 80008048 <etext+0x48>
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	014080e7          	jalr	20(ra) # 80005c5e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c52:	4785                	li	a5,1
    80005c54:	00003717          	auipc	a4,0x3
    80005c58:	3cf72423          	sw	a5,968(a4) # 8000901c <panicked>
  for(;;)
    80005c5c:	a001                	j	80005c5c <panic+0x48>

0000000080005c5e <printf>:
{
    80005c5e:	7131                	addi	sp,sp,-192
    80005c60:	fc86                	sd	ra,120(sp)
    80005c62:	f8a2                	sd	s0,112(sp)
    80005c64:	f4a6                	sd	s1,104(sp)
    80005c66:	f0ca                	sd	s2,96(sp)
    80005c68:	ecce                	sd	s3,88(sp)
    80005c6a:	e8d2                	sd	s4,80(sp)
    80005c6c:	e4d6                	sd	s5,72(sp)
    80005c6e:	e0da                	sd	s6,64(sp)
    80005c70:	fc5e                	sd	s7,56(sp)
    80005c72:	f862                	sd	s8,48(sp)
    80005c74:	f466                	sd	s9,40(sp)
    80005c76:	f06a                	sd	s10,32(sp)
    80005c78:	ec6e                	sd	s11,24(sp)
    80005c7a:	0100                	addi	s0,sp,128
    80005c7c:	8a2a                	mv	s4,a0
    80005c7e:	e40c                	sd	a1,8(s0)
    80005c80:	e810                	sd	a2,16(s0)
    80005c82:	ec14                	sd	a3,24(s0)
    80005c84:	f018                	sd	a4,32(s0)
    80005c86:	f41c                	sd	a5,40(s0)
    80005c88:	03043823          	sd	a6,48(s0)
    80005c8c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c90:	00020d97          	auipc	s11,0x20
    80005c94:	570dad83          	lw	s11,1392(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c98:	020d9b63          	bnez	s11,80005cce <printf+0x70>
  if (fmt == 0)
    80005c9c:	040a0263          	beqz	s4,80005ce0 <printf+0x82>
  va_start(ap, fmt);
    80005ca0:	00840793          	addi	a5,s0,8
    80005ca4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ca8:	000a4503          	lbu	a0,0(s4)
    80005cac:	14050f63          	beqz	a0,80005e0a <printf+0x1ac>
    80005cb0:	4981                	li	s3,0
    if(c != '%'){
    80005cb2:	02500a93          	li	s5,37
    switch(c){
    80005cb6:	07000b93          	li	s7,112
  consputc('x');
    80005cba:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cbc:	00003b17          	auipc	s6,0x3
    80005cc0:	c9cb0b13          	addi	s6,s6,-868 # 80008958 <digits>
    switch(c){
    80005cc4:	07300c93          	li	s9,115
    80005cc8:	06400c13          	li	s8,100
    80005ccc:	a82d                	j	80005d06 <printf+0xa8>
    acquire(&pr.lock);
    80005cce:	00020517          	auipc	a0,0x20
    80005cd2:	51a50513          	addi	a0,a0,1306 # 800261e8 <pr>
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	47a080e7          	jalr	1146(ra) # 80006150 <acquire>
    80005cde:	bf7d                	j	80005c9c <printf+0x3e>
    panic("null fmt");
    80005ce0:	00003517          	auipc	a0,0x3
    80005ce4:	c6050513          	addi	a0,a0,-928 # 80008940 <syscalls_name+0x3e8>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	f2c080e7          	jalr	-212(ra) # 80005c14 <panic>
      consputc(c);
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	c62080e7          	jalr	-926(ra) # 80005952 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf8:	2985                	addiw	s3,s3,1
    80005cfa:	013a07b3          	add	a5,s4,s3
    80005cfe:	0007c503          	lbu	a0,0(a5)
    80005d02:	10050463          	beqz	a0,80005e0a <printf+0x1ac>
    if(c != '%'){
    80005d06:	ff5515e3          	bne	a0,s5,80005cf0 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d0a:	2985                	addiw	s3,s3,1
    80005d0c:	013a07b3          	add	a5,s4,s3
    80005d10:	0007c783          	lbu	a5,0(a5)
    80005d14:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d18:	cbed                	beqz	a5,80005e0a <printf+0x1ac>
    switch(c){
    80005d1a:	05778a63          	beq	a5,s7,80005d6e <printf+0x110>
    80005d1e:	02fbf663          	bgeu	s7,a5,80005d4a <printf+0xec>
    80005d22:	09978863          	beq	a5,s9,80005db2 <printf+0x154>
    80005d26:	07800713          	li	a4,120
    80005d2a:	0ce79563          	bne	a5,a4,80005df4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d2e:	f8843783          	ld	a5,-120(s0)
    80005d32:	00878713          	addi	a4,a5,8
    80005d36:	f8e43423          	sd	a4,-120(s0)
    80005d3a:	4605                	li	a2,1
    80005d3c:	85ea                	mv	a1,s10
    80005d3e:	4388                	lw	a0,0(a5)
    80005d40:	00000097          	auipc	ra,0x0
    80005d44:	e32080e7          	jalr	-462(ra) # 80005b72 <printint>
      break;
    80005d48:	bf45                	j	80005cf8 <printf+0x9a>
    switch(c){
    80005d4a:	09578f63          	beq	a5,s5,80005de8 <printf+0x18a>
    80005d4e:	0b879363          	bne	a5,s8,80005df4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d52:	f8843783          	ld	a5,-120(s0)
    80005d56:	00878713          	addi	a4,a5,8
    80005d5a:	f8e43423          	sd	a4,-120(s0)
    80005d5e:	4605                	li	a2,1
    80005d60:	45a9                	li	a1,10
    80005d62:	4388                	lw	a0,0(a5)
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	e0e080e7          	jalr	-498(ra) # 80005b72 <printint>
      break;
    80005d6c:	b771                	j	80005cf8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d6e:	f8843783          	ld	a5,-120(s0)
    80005d72:	00878713          	addi	a4,a5,8
    80005d76:	f8e43423          	sd	a4,-120(s0)
    80005d7a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d7e:	03000513          	li	a0,48
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	bd0080e7          	jalr	-1072(ra) # 80005952 <consputc>
  consputc('x');
    80005d8a:	07800513          	li	a0,120
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	bc4080e7          	jalr	-1084(ra) # 80005952 <consputc>
    80005d96:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d98:	03c95793          	srli	a5,s2,0x3c
    80005d9c:	97da                	add	a5,a5,s6
    80005d9e:	0007c503          	lbu	a0,0(a5)
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	bb0080e7          	jalr	-1104(ra) # 80005952 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005daa:	0912                	slli	s2,s2,0x4
    80005dac:	34fd                	addiw	s1,s1,-1
    80005dae:	f4ed                	bnez	s1,80005d98 <printf+0x13a>
    80005db0:	b7a1                	j	80005cf8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	6384                	ld	s1,0(a5)
    80005dc0:	cc89                	beqz	s1,80005dda <printf+0x17c>
      for(; *s; s++)
    80005dc2:	0004c503          	lbu	a0,0(s1)
    80005dc6:	d90d                	beqz	a0,80005cf8 <printf+0x9a>
        consputc(*s);
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	b8a080e7          	jalr	-1142(ra) # 80005952 <consputc>
      for(; *s; s++)
    80005dd0:	0485                	addi	s1,s1,1
    80005dd2:	0004c503          	lbu	a0,0(s1)
    80005dd6:	f96d                	bnez	a0,80005dc8 <printf+0x16a>
    80005dd8:	b705                	j	80005cf8 <printf+0x9a>
        s = "(null)";
    80005dda:	00003497          	auipc	s1,0x3
    80005dde:	b5e48493          	addi	s1,s1,-1186 # 80008938 <syscalls_name+0x3e0>
      for(; *s; s++)
    80005de2:	02800513          	li	a0,40
    80005de6:	b7cd                	j	80005dc8 <printf+0x16a>
      consputc('%');
    80005de8:	8556                	mv	a0,s5
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	b68080e7          	jalr	-1176(ra) # 80005952 <consputc>
      break;
    80005df2:	b719                	j	80005cf8 <printf+0x9a>
      consputc('%');
    80005df4:	8556                	mv	a0,s5
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	b5c080e7          	jalr	-1188(ra) # 80005952 <consputc>
      consputc(c);
    80005dfe:	8526                	mv	a0,s1
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	b52080e7          	jalr	-1198(ra) # 80005952 <consputc>
      break;
    80005e08:	bdc5                	j	80005cf8 <printf+0x9a>
  if(locking)
    80005e0a:	020d9163          	bnez	s11,80005e2c <printf+0x1ce>
}
    80005e0e:	70e6                	ld	ra,120(sp)
    80005e10:	7446                	ld	s0,112(sp)
    80005e12:	74a6                	ld	s1,104(sp)
    80005e14:	7906                	ld	s2,96(sp)
    80005e16:	69e6                	ld	s3,88(sp)
    80005e18:	6a46                	ld	s4,80(sp)
    80005e1a:	6aa6                	ld	s5,72(sp)
    80005e1c:	6b06                	ld	s6,64(sp)
    80005e1e:	7be2                	ld	s7,56(sp)
    80005e20:	7c42                	ld	s8,48(sp)
    80005e22:	7ca2                	ld	s9,40(sp)
    80005e24:	7d02                	ld	s10,32(sp)
    80005e26:	6de2                	ld	s11,24(sp)
    80005e28:	6129                	addi	sp,sp,192
    80005e2a:	8082                	ret
    release(&pr.lock);
    80005e2c:	00020517          	auipc	a0,0x20
    80005e30:	3bc50513          	addi	a0,a0,956 # 800261e8 <pr>
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	3d0080e7          	jalr	976(ra) # 80006204 <release>
}
    80005e3c:	bfc9                	j	80005e0e <printf+0x1b0>

0000000080005e3e <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e3e:	1101                	addi	sp,sp,-32
    80005e40:	ec06                	sd	ra,24(sp)
    80005e42:	e822                	sd	s0,16(sp)
    80005e44:	e426                	sd	s1,8(sp)
    80005e46:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e48:	00020497          	auipc	s1,0x20
    80005e4c:	3a048493          	addi	s1,s1,928 # 800261e8 <pr>
    80005e50:	00003597          	auipc	a1,0x3
    80005e54:	b0058593          	addi	a1,a1,-1280 # 80008950 <syscalls_name+0x3f8>
    80005e58:	8526                	mv	a0,s1
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	266080e7          	jalr	614(ra) # 800060c0 <initlock>
  pr.locking = 1;
    80005e62:	4785                	li	a5,1
    80005e64:	cc9c                	sw	a5,24(s1)
}
    80005e66:	60e2                	ld	ra,24(sp)
    80005e68:	6442                	ld	s0,16(sp)
    80005e6a:	64a2                	ld	s1,8(sp)
    80005e6c:	6105                	addi	sp,sp,32
    80005e6e:	8082                	ret

0000000080005e70 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e70:	1141                	addi	sp,sp,-16
    80005e72:	e406                	sd	ra,8(sp)
    80005e74:	e022                	sd	s0,0(sp)
    80005e76:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e78:	100007b7          	lui	a5,0x10000
    80005e7c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e80:	f8000713          	li	a4,-128
    80005e84:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e88:	470d                	li	a4,3
    80005e8a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e8e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e92:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e96:	469d                	li	a3,7
    80005e98:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e9c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ea0:	00003597          	auipc	a1,0x3
    80005ea4:	ad058593          	addi	a1,a1,-1328 # 80008970 <digits+0x18>
    80005ea8:	00020517          	auipc	a0,0x20
    80005eac:	36050513          	addi	a0,a0,864 # 80026208 <uart_tx_lock>
    80005eb0:	00000097          	auipc	ra,0x0
    80005eb4:	210080e7          	jalr	528(ra) # 800060c0 <initlock>
}
    80005eb8:	60a2                	ld	ra,8(sp)
    80005eba:	6402                	ld	s0,0(sp)
    80005ebc:	0141                	addi	sp,sp,16
    80005ebe:	8082                	ret

0000000080005ec0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ec0:	1101                	addi	sp,sp,-32
    80005ec2:	ec06                	sd	ra,24(sp)
    80005ec4:	e822                	sd	s0,16(sp)
    80005ec6:	e426                	sd	s1,8(sp)
    80005ec8:	1000                	addi	s0,sp,32
    80005eca:	84aa                	mv	s1,a0
  push_off();
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	238080e7          	jalr	568(ra) # 80006104 <push_off>

  if(panicked){
    80005ed4:	00003797          	auipc	a5,0x3
    80005ed8:	1487a783          	lw	a5,328(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005edc:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ee0:	c391                	beqz	a5,80005ee4 <uartputc_sync+0x24>
    for(;;)
    80005ee2:	a001                	j	80005ee2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ee4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ee8:	0207f793          	andi	a5,a5,32
    80005eec:	dfe5                	beqz	a5,80005ee4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005eee:	0ff4f513          	andi	a0,s1,255
    80005ef2:	100007b7          	lui	a5,0x10000
    80005ef6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	2aa080e7          	jalr	682(ra) # 800061a4 <pop_off>
}
    80005f02:	60e2                	ld	ra,24(sp)
    80005f04:	6442                	ld	s0,16(sp)
    80005f06:	64a2                	ld	s1,8(sp)
    80005f08:	6105                	addi	sp,sp,32
    80005f0a:	8082                	ret

0000000080005f0c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f0c:	00003797          	auipc	a5,0x3
    80005f10:	1147b783          	ld	a5,276(a5) # 80009020 <uart_tx_r>
    80005f14:	00003717          	auipc	a4,0x3
    80005f18:	11473703          	ld	a4,276(a4) # 80009028 <uart_tx_w>
    80005f1c:	06f70a63          	beq	a4,a5,80005f90 <uartstart+0x84>
{
    80005f20:	7139                	addi	sp,sp,-64
    80005f22:	fc06                	sd	ra,56(sp)
    80005f24:	f822                	sd	s0,48(sp)
    80005f26:	f426                	sd	s1,40(sp)
    80005f28:	f04a                	sd	s2,32(sp)
    80005f2a:	ec4e                	sd	s3,24(sp)
    80005f2c:	e852                	sd	s4,16(sp)
    80005f2e:	e456                	sd	s5,8(sp)
    80005f30:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f32:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f36:	00020a17          	auipc	s4,0x20
    80005f3a:	2d2a0a13          	addi	s4,s4,722 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f3e:	00003497          	auipc	s1,0x3
    80005f42:	0e248493          	addi	s1,s1,226 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f46:	00003997          	auipc	s3,0x3
    80005f4a:	0e298993          	addi	s3,s3,226 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f4e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f52:	02077713          	andi	a4,a4,32
    80005f56:	c705                	beqz	a4,80005f7e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f58:	01f7f713          	andi	a4,a5,31
    80005f5c:	9752                	add	a4,a4,s4
    80005f5e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f62:	0785                	addi	a5,a5,1
    80005f64:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f66:	8526                	mv	a0,s1
    80005f68:	ffffb097          	auipc	ra,0xffffb
    80005f6c:	780080e7          	jalr	1920(ra) # 800016e8 <wakeup>
    
    WriteReg(THR, c);
    80005f70:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f74:	609c                	ld	a5,0(s1)
    80005f76:	0009b703          	ld	a4,0(s3)
    80005f7a:	fcf71ae3          	bne	a4,a5,80005f4e <uartstart+0x42>
  }
}
    80005f7e:	70e2                	ld	ra,56(sp)
    80005f80:	7442                	ld	s0,48(sp)
    80005f82:	74a2                	ld	s1,40(sp)
    80005f84:	7902                	ld	s2,32(sp)
    80005f86:	69e2                	ld	s3,24(sp)
    80005f88:	6a42                	ld	s4,16(sp)
    80005f8a:	6aa2                	ld	s5,8(sp)
    80005f8c:	6121                	addi	sp,sp,64
    80005f8e:	8082                	ret
    80005f90:	8082                	ret

0000000080005f92 <uartputc>:
{
    80005f92:	7179                	addi	sp,sp,-48
    80005f94:	f406                	sd	ra,40(sp)
    80005f96:	f022                	sd	s0,32(sp)
    80005f98:	ec26                	sd	s1,24(sp)
    80005f9a:	e84a                	sd	s2,16(sp)
    80005f9c:	e44e                	sd	s3,8(sp)
    80005f9e:	e052                	sd	s4,0(sp)
    80005fa0:	1800                	addi	s0,sp,48
    80005fa2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fa4:	00020517          	auipc	a0,0x20
    80005fa8:	26450513          	addi	a0,a0,612 # 80026208 <uart_tx_lock>
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	1a4080e7          	jalr	420(ra) # 80006150 <acquire>
  if(panicked){
    80005fb4:	00003797          	auipc	a5,0x3
    80005fb8:	0687a783          	lw	a5,104(a5) # 8000901c <panicked>
    80005fbc:	c391                	beqz	a5,80005fc0 <uartputc+0x2e>
    for(;;)
    80005fbe:	a001                	j	80005fbe <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fc0:	00003717          	auipc	a4,0x3
    80005fc4:	06873703          	ld	a4,104(a4) # 80009028 <uart_tx_w>
    80005fc8:	00003797          	auipc	a5,0x3
    80005fcc:	0587b783          	ld	a5,88(a5) # 80009020 <uart_tx_r>
    80005fd0:	02078793          	addi	a5,a5,32
    80005fd4:	02e79b63          	bne	a5,a4,8000600a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005fd8:	00020997          	auipc	s3,0x20
    80005fdc:	23098993          	addi	s3,s3,560 # 80026208 <uart_tx_lock>
    80005fe0:	00003497          	auipc	s1,0x3
    80005fe4:	04048493          	addi	s1,s1,64 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fe8:	00003917          	auipc	s2,0x3
    80005fec:	04090913          	addi	s2,s2,64 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005ff0:	85ce                	mv	a1,s3
    80005ff2:	8526                	mv	a0,s1
    80005ff4:	ffffb097          	auipc	ra,0xffffb
    80005ff8:	568080e7          	jalr	1384(ra) # 8000155c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ffc:	00093703          	ld	a4,0(s2)
    80006000:	609c                	ld	a5,0(s1)
    80006002:	02078793          	addi	a5,a5,32
    80006006:	fee785e3          	beq	a5,a4,80005ff0 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000600a:	00020497          	auipc	s1,0x20
    8000600e:	1fe48493          	addi	s1,s1,510 # 80026208 <uart_tx_lock>
    80006012:	01f77793          	andi	a5,a4,31
    80006016:	97a6                	add	a5,a5,s1
    80006018:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000601c:	0705                	addi	a4,a4,1
    8000601e:	00003797          	auipc	a5,0x3
    80006022:	00e7b523          	sd	a4,10(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	ee6080e7          	jalr	-282(ra) # 80005f0c <uartstart>
      release(&uart_tx_lock);
    8000602e:	8526                	mv	a0,s1
    80006030:	00000097          	auipc	ra,0x0
    80006034:	1d4080e7          	jalr	468(ra) # 80006204 <release>
}
    80006038:	70a2                	ld	ra,40(sp)
    8000603a:	7402                	ld	s0,32(sp)
    8000603c:	64e2                	ld	s1,24(sp)
    8000603e:	6942                	ld	s2,16(sp)
    80006040:	69a2                	ld	s3,8(sp)
    80006042:	6a02                	ld	s4,0(sp)
    80006044:	6145                	addi	sp,sp,48
    80006046:	8082                	ret

0000000080006048 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006048:	1141                	addi	sp,sp,-16
    8000604a:	e422                	sd	s0,8(sp)
    8000604c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000604e:	100007b7          	lui	a5,0x10000
    80006052:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006056:	8b85                	andi	a5,a5,1
    80006058:	cb91                	beqz	a5,8000606c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000605a:	100007b7          	lui	a5,0x10000
    8000605e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006062:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006066:	6422                	ld	s0,8(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret
    return -1;
    8000606c:	557d                	li	a0,-1
    8000606e:	bfe5                	j	80006066 <uartgetc+0x1e>

0000000080006070 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006070:	1101                	addi	sp,sp,-32
    80006072:	ec06                	sd	ra,24(sp)
    80006074:	e822                	sd	s0,16(sp)
    80006076:	e426                	sd	s1,8(sp)
    80006078:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000607a:	54fd                	li	s1,-1
    8000607c:	a029                	j	80006086 <uartintr+0x16>
      break;
    consoleintr(c);
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	916080e7          	jalr	-1770(ra) # 80005994 <consoleintr>
    int c = uartgetc();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	fc2080e7          	jalr	-62(ra) # 80006048 <uartgetc>
    if(c == -1)
    8000608e:	fe9518e3          	bne	a0,s1,8000607e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006092:	00020497          	auipc	s1,0x20
    80006096:	17648493          	addi	s1,s1,374 # 80026208 <uart_tx_lock>
    8000609a:	8526                	mv	a0,s1
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	0b4080e7          	jalr	180(ra) # 80006150 <acquire>
  uartstart();
    800060a4:	00000097          	auipc	ra,0x0
    800060a8:	e68080e7          	jalr	-408(ra) # 80005f0c <uartstart>
  release(&uart_tx_lock);
    800060ac:	8526                	mv	a0,s1
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	156080e7          	jalr	342(ra) # 80006204 <release>
}
    800060b6:	60e2                	ld	ra,24(sp)
    800060b8:	6442                	ld	s0,16(sp)
    800060ba:	64a2                	ld	s1,8(sp)
    800060bc:	6105                	addi	sp,sp,32
    800060be:	8082                	ret

00000000800060c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060c0:	1141                	addi	sp,sp,-16
    800060c2:	e422                	sd	s0,8(sp)
    800060c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800060c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060cc:	00053823          	sd	zero,16(a0)
}
    800060d0:	6422                	ld	s0,8(sp)
    800060d2:	0141                	addi	sp,sp,16
    800060d4:	8082                	ret

00000000800060d6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060d6:	411c                	lw	a5,0(a0)
    800060d8:	e399                	bnez	a5,800060de <holding+0x8>
    800060da:	4501                	li	a0,0
  return r;
}
    800060dc:	8082                	ret
{
    800060de:	1101                	addi	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060e8:	6904                	ld	s1,16(a0)
    800060ea:	ffffb097          	auipc	ra,0xffffb
    800060ee:	d8e080e7          	jalr	-626(ra) # 80000e78 <mycpu>
    800060f2:	40a48533          	sub	a0,s1,a0
    800060f6:	00153513          	seqz	a0,a0
}
    800060fa:	60e2                	ld	ra,24(sp)
    800060fc:	6442                	ld	s0,16(sp)
    800060fe:	64a2                	ld	s1,8(sp)
    80006100:	6105                	addi	sp,sp,32
    80006102:	8082                	ret

0000000080006104 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006104:	1101                	addi	sp,sp,-32
    80006106:	ec06                	sd	ra,24(sp)
    80006108:	e822                	sd	s0,16(sp)
    8000610a:	e426                	sd	s1,8(sp)
    8000610c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000610e:	100024f3          	csrr	s1,sstatus
    80006112:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006116:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006118:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000611c:	ffffb097          	auipc	ra,0xffffb
    80006120:	d5c080e7          	jalr	-676(ra) # 80000e78 <mycpu>
    80006124:	5d3c                	lw	a5,120(a0)
    80006126:	cf89                	beqz	a5,80006140 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	d50080e7          	jalr	-688(ra) # 80000e78 <mycpu>
    80006130:	5d3c                	lw	a5,120(a0)
    80006132:	2785                	addiw	a5,a5,1
    80006134:	dd3c                	sw	a5,120(a0)
}
    80006136:	60e2                	ld	ra,24(sp)
    80006138:	6442                	ld	s0,16(sp)
    8000613a:	64a2                	ld	s1,8(sp)
    8000613c:	6105                	addi	sp,sp,32
    8000613e:	8082                	ret
    mycpu()->intena = old;
    80006140:	ffffb097          	auipc	ra,0xffffb
    80006144:	d38080e7          	jalr	-712(ra) # 80000e78 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006148:	8085                	srli	s1,s1,0x1
    8000614a:	8885                	andi	s1,s1,1
    8000614c:	dd64                	sw	s1,124(a0)
    8000614e:	bfe9                	j	80006128 <push_off+0x24>

0000000080006150 <acquire>:
{
    80006150:	1101                	addi	sp,sp,-32
    80006152:	ec06                	sd	ra,24(sp)
    80006154:	e822                	sd	s0,16(sp)
    80006156:	e426                	sd	s1,8(sp)
    80006158:	1000                	addi	s0,sp,32
    8000615a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	fa8080e7          	jalr	-88(ra) # 80006104 <push_off>
  if(holding(lk))
    80006164:	8526                	mv	a0,s1
    80006166:	00000097          	auipc	ra,0x0
    8000616a:	f70080e7          	jalr	-144(ra) # 800060d6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000616e:	4705                	li	a4,1
  if(holding(lk))
    80006170:	e115                	bnez	a0,80006194 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006172:	87ba                	mv	a5,a4
    80006174:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006178:	2781                	sext.w	a5,a5
    8000617a:	ffe5                	bnez	a5,80006172 <acquire+0x22>
  __sync_synchronize();
    8000617c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	cf8080e7          	jalr	-776(ra) # 80000e78 <mycpu>
    80006188:	e888                	sd	a0,16(s1)
}
    8000618a:	60e2                	ld	ra,24(sp)
    8000618c:	6442                	ld	s0,16(sp)
    8000618e:	64a2                	ld	s1,8(sp)
    80006190:	6105                	addi	sp,sp,32
    80006192:	8082                	ret
    panic("acquire");
    80006194:	00002517          	auipc	a0,0x2
    80006198:	7e450513          	addi	a0,a0,2020 # 80008978 <digits+0x20>
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	a78080e7          	jalr	-1416(ra) # 80005c14 <panic>

00000000800061a4 <pop_off>:

void
pop_off(void)
{
    800061a4:	1141                	addi	sp,sp,-16
    800061a6:	e406                	sd	ra,8(sp)
    800061a8:	e022                	sd	s0,0(sp)
    800061aa:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	ccc080e7          	jalr	-820(ra) # 80000e78 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061b8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061ba:	e78d                	bnez	a5,800061e4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061bc:	5d3c                	lw	a5,120(a0)
    800061be:	02f05b63          	blez	a5,800061f4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061c2:	37fd                	addiw	a5,a5,-1
    800061c4:	0007871b          	sext.w	a4,a5
    800061c8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061ca:	eb09                	bnez	a4,800061dc <pop_off+0x38>
    800061cc:	5d7c                	lw	a5,124(a0)
    800061ce:	c799                	beqz	a5,800061dc <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061d4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061d8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061dc:	60a2                	ld	ra,8(sp)
    800061de:	6402                	ld	s0,0(sp)
    800061e0:	0141                	addi	sp,sp,16
    800061e2:	8082                	ret
    panic("pop_off - interruptible");
    800061e4:	00002517          	auipc	a0,0x2
    800061e8:	79c50513          	addi	a0,a0,1948 # 80008980 <digits+0x28>
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	a28080e7          	jalr	-1496(ra) # 80005c14 <panic>
    panic("pop_off");
    800061f4:	00002517          	auipc	a0,0x2
    800061f8:	7a450513          	addi	a0,a0,1956 # 80008998 <digits+0x40>
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	a18080e7          	jalr	-1512(ra) # 80005c14 <panic>

0000000080006204 <release>:
{
    80006204:	1101                	addi	sp,sp,-32
    80006206:	ec06                	sd	ra,24(sp)
    80006208:	e822                	sd	s0,16(sp)
    8000620a:	e426                	sd	s1,8(sp)
    8000620c:	1000                	addi	s0,sp,32
    8000620e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006210:	00000097          	auipc	ra,0x0
    80006214:	ec6080e7          	jalr	-314(ra) # 800060d6 <holding>
    80006218:	c115                	beqz	a0,8000623c <release+0x38>
  lk->cpu = 0;
    8000621a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000621e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006222:	0f50000f          	fence	iorw,ow
    80006226:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	f7a080e7          	jalr	-134(ra) # 800061a4 <pop_off>
}
    80006232:	60e2                	ld	ra,24(sp)
    80006234:	6442                	ld	s0,16(sp)
    80006236:	64a2                	ld	s1,8(sp)
    80006238:	6105                	addi	sp,sp,32
    8000623a:	8082                	ret
    panic("release");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	76450513          	addi	a0,a0,1892 # 800089a0 <digits+0x48>
    80006244:	00000097          	auipc	ra,0x0
    80006248:	9d0080e7          	jalr	-1584(ra) # 80005c14 <panic>
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
