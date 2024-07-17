
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8f013103          	ld	sp,-1808(sp) # 800088f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	103050ef          	jal	ra,80005918 <start>

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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2b8080e7          	jalr	696(ra) # 80006312 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	358080e7          	jalr	856(ra) # 800063c6 <release>
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
    8000008e:	d3e080e7          	jalr	-706(ra) # 80005dc8 <panic>

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
    800000f8:	18e080e7          	jalr	398(ra) # 80006282 <initlock>
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
    80000130:	1e6080e7          	jalr	486(ra) # 80006312 <acquire>
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
    80000148:	282080e7          	jalr	642(ra) # 800063c6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
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
    80000172:	258080e7          	jalr	600(ra) # 800063c6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	bc4080e7          	jalr	-1084(ra) # 80000ef2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ba8080e7          	jalr	-1112(ra) # 80000ef2 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ab6080e7          	jalr	-1354(ra) # 80005e12 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	954080e7          	jalr	-1708(ra) # 80001cc0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f2c080e7          	jalr	-212(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	164080e7          	jalr	356(ra) # 800014e0 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	956080e7          	jalr	-1706(ra) # 80005cda <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c6c080e7          	jalr	-916(ra) # 80005ff8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a76080e7          	jalr	-1418(ra) # 80005e12 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a66080e7          	jalr	-1434(ra) # 80005e12 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a56080e7          	jalr	-1450(ra) # 80005e12 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	a68080e7          	jalr	-1432(ra) # 80000e44 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	8b4080e7          	jalr	-1868(ra) # 80001c98 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	8d4080e7          	jalr	-1836(ra) # 80001cc0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e96080e7          	jalr	-362(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ea4080e7          	jalr	-348(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	066080e7          	jalr	102(ra) # 8000246a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6f6080e7          	jalr	1782(ra) # 80002b02 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6a0080e7          	jalr	1696(ra) # 80003ab4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fa6080e7          	jalr	-90(ra) # 800053c2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	e8a080e7          	jalr	-374(ra) # 800012ae <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	93a080e7          	jalr	-1734(ra) # 80005dc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	842080e7          	jalr	-1982(ra) # 80005dc8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	832080e7          	jalr	-1998(ra) # 80005dc8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	7b8080e7          	jalr	1976(ra) # 80005dc8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	6d8080e7          	jalr	1752(ra) # 80000db0 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	66c080e7          	jalr	1644(ra) # 80005dc8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	65c080e7          	jalr	1628(ra) # 80005dc8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	64c080e7          	jalr	1612(ra) # 80005dc8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	63c080e7          	jalr	1596(ra) # 80005dc8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	55e080e7          	jalr	1374(ra) # 80005dc8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	41c080e7          	jalr	1052(ra) # 80005dc8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	340080e7          	jalr	832(ra) # 80005dc8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	330080e7          	jalr	816(ra) # 80005dc8 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	2c6080e7          	jalr	710(ra) # 80005dc8 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
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
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <printwalk>:

void
printwalk(pagetable_t pagetable, uint level) {
    80000cd6:	715d                	addi	sp,sp,-80
    80000cd8:	e486                	sd	ra,72(sp)
    80000cda:	e0a2                	sd	s0,64(sp)
    80000cdc:	fc26                	sd	s1,56(sp)
    80000cde:	f84a                	sd	s2,48(sp)
    80000ce0:	f44e                	sd	s3,40(sp)
    80000ce2:	f052                	sd	s4,32(sp)
    80000ce4:	ec56                	sd	s5,24(sp)
    80000ce6:	e85a                	sd	s6,16(sp)
    80000ce8:	e45e                	sd	s7,8(sp)
    80000cea:	e062                	sd	s8,0(sp)
    80000cec:	0880                	addi	s0,sp,80
    80000cee:	89aa                	mv	s3,a0
  char* prefix;
  if (level == 2) prefix = "..";
    80000cf0:	4789                	li	a5,2
    80000cf2:	00007b17          	auipc	s6,0x7
    80000cf6:	466b0b13          	addi	s6,s6,1126 # 80008158 <etext+0x158>
    80000cfa:	00f58d63          	beq	a1,a5,80000d14 <printwalk+0x3e>
  else if (level == 1) prefix = ".. ..";
    80000cfe:	4785                	li	a5,1
    80000d00:	00007b17          	auipc	s6,0x7
    80000d04:	460b0b13          	addi	s6,s6,1120 # 80008160 <etext+0x160>
    80000d08:	00f58663          	beq	a1,a5,80000d14 <printwalk+0x3e>
  else prefix = ".. .. ..";
    80000d0c:	00007b17          	auipc	s6,0x7
    80000d10:	45cb0b13          	addi	s6,s6,1116 # 80008168 <etext+0x168>
  for (int i = 0; i < 512; i++) { // 每个页表有512项
    80000d14:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if (pte & PTE_V) { // 该页表项有效
      uint64 pa = PTE2PA(pte); // 将虚拟地址转换为物理地址
      printf("%s%d: pte %p pa %p\n", prefix, i, pte, pa);
    80000d16:	00007b97          	auipc	s7,0x7
    80000d1a:	462b8b93          	addi	s7,s7,1122 # 80008178 <etext+0x178>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 有下一级页表
        printwalk((pagetable_t)pa, level - 1);
    80000d1e:	fff58c1b          	addiw	s8,a1,-1
  for (int i = 0; i < 512; i++) { // 每个页表有512项
    80000d22:	20000a93          	li	s5,512
    80000d26:	a819                	j	80000d3c <printwalk+0x66>
        printwalk((pagetable_t)pa, level - 1);
    80000d28:	85e2                	mv	a1,s8
    80000d2a:	8552                	mv	a0,s4
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	faa080e7          	jalr	-86(ra) # 80000cd6 <printwalk>
  for (int i = 0; i < 512; i++) { // 每个页表有512项
    80000d34:	2905                	addiw	s2,s2,1
    80000d36:	09a1                	addi	s3,s3,8
    80000d38:	03590663          	beq	s2,s5,80000d64 <printwalk+0x8e>
    pte_t pte = pagetable[i];
    80000d3c:	0009b483          	ld	s1,0(s3) # 1000 <_entry-0x7ffff000>
    if (pte & PTE_V) { // 该页表项有效
    80000d40:	0014f793          	andi	a5,s1,1
    80000d44:	dbe5                	beqz	a5,80000d34 <printwalk+0x5e>
      uint64 pa = PTE2PA(pte); // 将虚拟地址转换为物理地址
    80000d46:	00a4da13          	srli	s4,s1,0xa
    80000d4a:	0a32                	slli	s4,s4,0xc
      printf("%s%d: pte %p pa %p\n", prefix, i, pte, pa);
    80000d4c:	8752                	mv	a4,s4
    80000d4e:	86a6                	mv	a3,s1
    80000d50:	864a                	mv	a2,s2
    80000d52:	85da                	mv	a1,s6
    80000d54:	855e                	mv	a0,s7
    80000d56:	00005097          	auipc	ra,0x5
    80000d5a:	0bc080e7          	jalr	188(ra) # 80005e12 <printf>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 有下一级页表
    80000d5e:	88b9                	andi	s1,s1,14
    80000d60:	f8f1                	bnez	s1,80000d34 <printwalk+0x5e>
    80000d62:	b7d9                	j	80000d28 <printwalk+0x52>
      }
    }
  }
}
    80000d64:	60a6                	ld	ra,72(sp)
    80000d66:	6406                	ld	s0,64(sp)
    80000d68:	74e2                	ld	s1,56(sp)
    80000d6a:	7942                	ld	s2,48(sp)
    80000d6c:	79a2                	ld	s3,40(sp)
    80000d6e:	7a02                	ld	s4,32(sp)
    80000d70:	6ae2                	ld	s5,24(sp)
    80000d72:	6b42                	ld	s6,16(sp)
    80000d74:	6ba2                	ld	s7,8(sp)
    80000d76:	6c02                	ld	s8,0(sp)
    80000d78:	6161                	addi	sp,sp,80
    80000d7a:	8082                	ret

0000000080000d7c <vmprint>:

void
vmprint(pagetable_t pagetable) {
    80000d7c:	1101                	addi	sp,sp,-32
    80000d7e:	ec06                	sd	ra,24(sp)
    80000d80:	e822                	sd	s0,16(sp)
    80000d82:	e426                	sd	s1,8(sp)
    80000d84:	1000                	addi	s0,sp,32
    80000d86:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000d88:	85aa                	mv	a1,a0
    80000d8a:	00007517          	auipc	a0,0x7
    80000d8e:	40650513          	addi	a0,a0,1030 # 80008190 <etext+0x190>
    80000d92:	00005097          	auipc	ra,0x5
    80000d96:	080080e7          	jalr	128(ra) # 80005e12 <printf>
  printwalk(pagetable, 2);
    80000d9a:	4589                	li	a1,2
    80000d9c:	8526                	mv	a0,s1
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	f38080e7          	jalr	-200(ra) # 80000cd6 <printwalk>
}
    80000da6:	60e2                	ld	ra,24(sp)
    80000da8:	6442                	ld	s0,16(sp)
    80000daa:	64a2                	ld	s1,8(sp)
    80000dac:	6105                	addi	sp,sp,32
    80000dae:	8082                	ret

0000000080000db0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000db0:	7139                	addi	sp,sp,-64
    80000db2:	fc06                	sd	ra,56(sp)
    80000db4:	f822                	sd	s0,48(sp)
    80000db6:	f426                	sd	s1,40(sp)
    80000db8:	f04a                	sd	s2,32(sp)
    80000dba:	ec4e                	sd	s3,24(sp)
    80000dbc:	e852                	sd	s4,16(sp)
    80000dbe:	e456                	sd	s5,8(sp)
    80000dc0:	e05a                	sd	s6,0(sp)
    80000dc2:	0080                	addi	s0,sp,64
    80000dc4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	6ba48493          	addi	s1,s1,1722 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dce:	8b26                	mv	s6,s1
    80000dd0:	00007a97          	auipc	s5,0x7
    80000dd4:	230a8a93          	addi	s5,s5,560 # 80008000 <etext>
    80000dd8:	01000937          	lui	s2,0x1000
    80000ddc:	197d                	addi	s2,s2,-1
    80000dde:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de0:	0000ea17          	auipc	s4,0xe
    80000de4:	2a0a0a13          	addi	s4,s4,672 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000de8:	fffff097          	auipc	ra,0xfffff
    80000dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80000df0:	862a                	mv	a2,a0
    if(pa == 0)
    80000df2:	c129                	beqz	a0,80000e34 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	416485b3          	sub	a1,s1,s6
    80000df8:	8591                	srai	a1,a1,0x4
    80000dfa:	000ab783          	ld	a5,0(s5)
    80000dfe:	02f585b3          	mul	a1,a1,a5
    80000e02:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e06:	4719                	li	a4,6
    80000e08:	6685                	lui	a3,0x1
    80000e0a:	40b905b3          	sub	a1,s2,a1
    80000e0e:	854e                	mv	a0,s3
    80000e10:	fffff097          	auipc	ra,0xfffff
    80000e14:	7d8080e7          	jalr	2008(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	17048493          	addi	s1,s1,368
    80000e1c:	fd4496e3          	bne	s1,s4,80000de8 <proc_mapstacks+0x38>
  }
}
    80000e20:	70e2                	ld	ra,56(sp)
    80000e22:	7442                	ld	s0,48(sp)
    80000e24:	74a2                	ld	s1,40(sp)
    80000e26:	7902                	ld	s2,32(sp)
    80000e28:	69e2                	ld	s3,24(sp)
    80000e2a:	6a42                	ld	s4,16(sp)
    80000e2c:	6aa2                	ld	s5,8(sp)
    80000e2e:	6b02                	ld	s6,0(sp)
    80000e30:	6121                	addi	sp,sp,64
    80000e32:	8082                	ret
      panic("kalloc");
    80000e34:	00007517          	auipc	a0,0x7
    80000e38:	36c50513          	addi	a0,a0,876 # 800081a0 <etext+0x1a0>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	f8c080e7          	jalr	-116(ra) # 80005dc8 <panic>

0000000080000e44 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e44:	7139                	addi	sp,sp,-64
    80000e46:	fc06                	sd	ra,56(sp)
    80000e48:	f822                	sd	s0,48(sp)
    80000e4a:	f426                	sd	s1,40(sp)
    80000e4c:	f04a                	sd	s2,32(sp)
    80000e4e:	ec4e                	sd	s3,24(sp)
    80000e50:	e852                	sd	s4,16(sp)
    80000e52:	e456                	sd	s5,8(sp)
    80000e54:	e05a                	sd	s6,0(sp)
    80000e56:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e58:	00007597          	auipc	a1,0x7
    80000e5c:	35058593          	addi	a1,a1,848 # 800081a8 <etext+0x1a8>
    80000e60:	00008517          	auipc	a0,0x8
    80000e64:	1f050513          	addi	a0,a0,496 # 80009050 <pid_lock>
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	41a080e7          	jalr	1050(ra) # 80006282 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e70:	00007597          	auipc	a1,0x7
    80000e74:	34058593          	addi	a1,a1,832 # 800081b0 <etext+0x1b0>
    80000e78:	00008517          	auipc	a0,0x8
    80000e7c:	1f050513          	addi	a0,a0,496 # 80009068 <wait_lock>
    80000e80:	00005097          	auipc	ra,0x5
    80000e84:	402080e7          	jalr	1026(ra) # 80006282 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e88:	00008497          	auipc	s1,0x8
    80000e8c:	5f848493          	addi	s1,s1,1528 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e90:	00007b17          	auipc	s6,0x7
    80000e94:	330b0b13          	addi	s6,s6,816 # 800081c0 <etext+0x1c0>
      p->kstack = KSTACK((int) (p - proc));
    80000e98:	8aa6                	mv	s5,s1
    80000e9a:	00007a17          	auipc	s4,0x7
    80000e9e:	166a0a13          	addi	s4,s4,358 # 80008000 <etext>
    80000ea2:	01000937          	lui	s2,0x1000
    80000ea6:	197d                	addi	s2,s2,-1
    80000ea8:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eaa:	0000e997          	auipc	s3,0xe
    80000eae:	1d698993          	addi	s3,s3,470 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000eb2:	85da                	mv	a1,s6
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	3cc080e7          	jalr	972(ra) # 80006282 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ebe:	415487b3          	sub	a5,s1,s5
    80000ec2:	8791                	srai	a5,a5,0x4
    80000ec4:	000a3703          	ld	a4,0(s4)
    80000ec8:	02e787b3          	mul	a5,a5,a4
    80000ecc:	00d7979b          	slliw	a5,a5,0xd
    80000ed0:	40f907b3          	sub	a5,s2,a5
    80000ed4:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed6:	17048493          	addi	s1,s1,368
    80000eda:	fd349ce3          	bne	s1,s3,80000eb2 <procinit+0x6e>
  }
}
    80000ede:	70e2                	ld	ra,56(sp)
    80000ee0:	7442                	ld	s0,48(sp)
    80000ee2:	74a2                	ld	s1,40(sp)
    80000ee4:	7902                	ld	s2,32(sp)
    80000ee6:	69e2                	ld	s3,24(sp)
    80000ee8:	6a42                	ld	s4,16(sp)
    80000eea:	6aa2                	ld	s5,8(sp)
    80000eec:	6b02                	ld	s6,0(sp)
    80000eee:	6121                	addi	sp,sp,64
    80000ef0:	8082                	ret

0000000080000ef2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ef2:	1141                	addi	sp,sp,-16
    80000ef4:	e422                	sd	s0,8(sp)
    80000ef6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ef8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000efa:	2501                	sext.w	a0,a0
    80000efc:	6422                	ld	s0,8(sp)
    80000efe:	0141                	addi	sp,sp,16
    80000f00:	8082                	ret

0000000080000f02 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f02:	1141                	addi	sp,sp,-16
    80000f04:	e422                	sd	s0,8(sp)
    80000f06:	0800                	addi	s0,sp,16
    80000f08:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f0a:	2781                	sext.w	a5,a5
    80000f0c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f0e:	00008517          	auipc	a0,0x8
    80000f12:	17250513          	addi	a0,a0,370 # 80009080 <cpus>
    80000f16:	953e                	add	a0,a0,a5
    80000f18:	6422                	ld	s0,8(sp)
    80000f1a:	0141                	addi	sp,sp,16
    80000f1c:	8082                	ret

0000000080000f1e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	1000                	addi	s0,sp,32
  push_off();
    80000f28:	00005097          	auipc	ra,0x5
    80000f2c:	39e080e7          	jalr	926(ra) # 800062c6 <push_off>
    80000f30:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f32:	2781                	sext.w	a5,a5
    80000f34:	079e                	slli	a5,a5,0x7
    80000f36:	00008717          	auipc	a4,0x8
    80000f3a:	11a70713          	addi	a4,a4,282 # 80009050 <pid_lock>
    80000f3e:	97ba                	add	a5,a5,a4
    80000f40:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	424080e7          	jalr	1060(ra) # 80006366 <pop_off>
  return p;
}
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	60e2                	ld	ra,24(sp)
    80000f4e:	6442                	ld	s0,16(sp)
    80000f50:	64a2                	ld	s1,8(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f56:	1141                	addi	sp,sp,-16
    80000f58:	e406                	sd	ra,8(sp)
    80000f5a:	e022                	sd	s0,0(sp)
    80000f5c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f5e:	00000097          	auipc	ra,0x0
    80000f62:	fc0080e7          	jalr	-64(ra) # 80000f1e <myproc>
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	460080e7          	jalr	1120(ra) # 800063c6 <release>

  if (first) {
    80000f6e:	00008797          	auipc	a5,0x8
    80000f72:	9327a783          	lw	a5,-1742(a5) # 800088a0 <first.1690>
    80000f76:	eb89                	bnez	a5,80000f88 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	d60080e7          	jalr	-672(ra) # 80001cd8 <usertrapret>
}
    80000f80:	60a2                	ld	ra,8(sp)
    80000f82:	6402                	ld	s0,0(sp)
    80000f84:	0141                	addi	sp,sp,16
    80000f86:	8082                	ret
    first = 0;
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	9007ac23          	sw	zero,-1768(a5) # 800088a0 <first.1690>
    fsinit(ROOTDEV);
    80000f90:	4505                	li	a0,1
    80000f92:	00002097          	auipc	ra,0x2
    80000f96:	af0080e7          	jalr	-1296(ra) # 80002a82 <fsinit>
    80000f9a:	bff9                	j	80000f78 <forkret+0x22>

0000000080000f9c <allocpid>:
allocpid() {
    80000f9c:	1101                	addi	sp,sp,-32
    80000f9e:	ec06                	sd	ra,24(sp)
    80000fa0:	e822                	sd	s0,16(sp)
    80000fa2:	e426                	sd	s1,8(sp)
    80000fa4:	e04a                	sd	s2,0(sp)
    80000fa6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fa8:	00008917          	auipc	s2,0x8
    80000fac:	0a890913          	addi	s2,s2,168 # 80009050 <pid_lock>
    80000fb0:	854a                	mv	a0,s2
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	360080e7          	jalr	864(ra) # 80006312 <acquire>
  pid = nextpid;
    80000fba:	00008797          	auipc	a5,0x8
    80000fbe:	8ea78793          	addi	a5,a5,-1814 # 800088a4 <nextpid>
    80000fc2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fc4:	0014871b          	addiw	a4,s1,1
    80000fc8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fca:	854a                	mv	a0,s2
    80000fcc:	00005097          	auipc	ra,0x5
    80000fd0:	3fa080e7          	jalr	1018(ra) # 800063c6 <release>
}
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	60e2                	ld	ra,24(sp)
    80000fd8:	6442                	ld	s0,16(sp)
    80000fda:	64a2                	ld	s1,8(sp)
    80000fdc:	6902                	ld	s2,0(sp)
    80000fde:	6105                	addi	sp,sp,32
    80000fe0:	8082                	ret

0000000080000fe2 <proc_pagetable>:
{
    80000fe2:	1101                	addi	sp,sp,-32
    80000fe4:	ec06                	sd	ra,24(sp)
    80000fe6:	e822                	sd	s0,16(sp)
    80000fe8:	e426                	sd	s1,8(sp)
    80000fea:	e04a                	sd	s2,0(sp)
    80000fec:	1000                	addi	s0,sp,32
    80000fee:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ff0:	fffff097          	auipc	ra,0xfffff
    80000ff4:	7e2080e7          	jalr	2018(ra) # 800007d2 <uvmcreate>
    80000ff8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ffa:	cd39                	beqz	a0,80001058 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ffc:	4729                	li	a4,10
    80000ffe:	00006697          	auipc	a3,0x6
    80001002:	00268693          	addi	a3,a3,2 # 80007000 <_trampoline>
    80001006:	6605                	lui	a2,0x1
    80001008:	040005b7          	lui	a1,0x4000
    8000100c:	15fd                	addi	a1,a1,-1
    8000100e:	05b2                	slli	a1,a1,0xc
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	538080e7          	jalr	1336(ra) # 80000548 <mappages>
    80001018:	04054763          	bltz	a0,80001066 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000101c:	4719                	li	a4,6
    8000101e:	06093683          	ld	a3,96(s2)
    80001022:	6605                	lui	a2,0x1
    80001024:	020005b7          	lui	a1,0x2000
    80001028:	15fd                	addi	a1,a1,-1
    8000102a:	05b6                	slli	a1,a1,0xd
    8000102c:	8526                	mv	a0,s1
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	51a080e7          	jalr	1306(ra) # 80000548 <mappages>
    80001036:	04054063          	bltz	a0,80001076 <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    8000103a:	4749                	li	a4,18
    8000103c:	01893683          	ld	a3,24(s2)
    80001040:	6605                	lui	a2,0x1
    80001042:	040005b7          	lui	a1,0x4000
    80001046:	15f5                	addi	a1,a1,-3
    80001048:	05b2                	slli	a1,a1,0xc
    8000104a:	8526                	mv	a0,s1
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	4fc080e7          	jalr	1276(ra) # 80000548 <mappages>
    80001054:	04054463          	bltz	a0,8000109c <proc_pagetable+0xba>
}
    80001058:	8526                	mv	a0,s1
    8000105a:	60e2                	ld	ra,24(sp)
    8000105c:	6442                	ld	s0,16(sp)
    8000105e:	64a2                	ld	s1,8(sp)
    80001060:	6902                	ld	s2,0(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret
    uvmfree(pagetable, 0);
    80001066:	4581                	li	a1,0
    80001068:	8526                	mv	a0,s1
    8000106a:	00000097          	auipc	ra,0x0
    8000106e:	964080e7          	jalr	-1692(ra) # 800009ce <uvmfree>
    return 0;
    80001072:	4481                	li	s1,0
    80001074:	b7d5                	j	80001058 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001076:	4681                	li	a3,0
    80001078:	4605                	li	a2,1
    8000107a:	040005b7          	lui	a1,0x4000
    8000107e:	15fd                	addi	a1,a1,-1
    80001080:	05b2                	slli	a1,a1,0xc
    80001082:	8526                	mv	a0,s1
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	68a080e7          	jalr	1674(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    8000108c:	4581                	li	a1,0
    8000108e:	8526                	mv	a0,s1
    80001090:	00000097          	auipc	ra,0x0
    80001094:	93e080e7          	jalr	-1730(ra) # 800009ce <uvmfree>
    return 0;
    80001098:	4481                	li	s1,0
    8000109a:	bf7d                	j	80001058 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109c:	4681                	li	a3,0
    8000109e:	4605                	li	a2,1
    800010a0:	040005b7          	lui	a1,0x4000
    800010a4:	15fd                	addi	a1,a1,-1
    800010a6:	05b2                	slli	a1,a1,0xc
    800010a8:	8526                	mv	a0,s1
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	664080e7          	jalr	1636(ra) # 8000070e <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010b2:	4681                	li	a3,0
    800010b4:	4605                	li	a2,1
    800010b6:	020005b7          	lui	a1,0x2000
    800010ba:	15fd                	addi	a1,a1,-1
    800010bc:	05b6                	slli	a1,a1,0xd
    800010be:	8526                	mv	a0,s1
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	64e080e7          	jalr	1614(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010c8:	4581                	li	a1,0
    800010ca:	8526                	mv	a0,s1
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	902080e7          	jalr	-1790(ra) # 800009ce <uvmfree>
    return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	b749                	j	80001058 <proc_pagetable+0x76>

00000000800010d8 <proc_freepagetable>:
{
    800010d8:	7179                	addi	sp,sp,-48
    800010da:	f406                	sd	ra,40(sp)
    800010dc:	f022                	sd	s0,32(sp)
    800010de:	ec26                	sd	s1,24(sp)
    800010e0:	e84a                	sd	s2,16(sp)
    800010e2:	e44e                	sd	s3,8(sp)
    800010e4:	1800                	addi	s0,sp,48
    800010e6:	84aa                	mv	s1,a0
    800010e8:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ea:	4681                	li	a3,0
    800010ec:	4605                	li	a2,1
    800010ee:	04000937          	lui	s2,0x4000
    800010f2:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010f6:	05b2                	slli	a1,a1,0xc
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	616080e7          	jalr	1558(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001100:	4681                	li	a3,0
    80001102:	4605                	li	a2,1
    80001104:	020005b7          	lui	a1,0x2000
    80001108:	15fd                	addi	a1,a1,-1
    8000110a:	05b6                	slli	a1,a1,0xd
    8000110c:	8526                	mv	a0,s1
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	600080e7          	jalr	1536(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0); // add
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	1975                	addi	s2,s2,-3
    8000111c:	00c91593          	slli	a1,s2,0xc
    80001120:	8526                	mv	a0,s1
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	5ec080e7          	jalr	1516(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    8000112a:	85ce                	mv	a1,s3
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	8a0080e7          	jalr	-1888(ra) # 800009ce <uvmfree>
}
    80001136:	70a2                	ld	ra,40(sp)
    80001138:	7402                	ld	s0,32(sp)
    8000113a:	64e2                	ld	s1,24(sp)
    8000113c:	6942                	ld	s2,16(sp)
    8000113e:	69a2                	ld	s3,8(sp)
    80001140:	6145                	addi	sp,sp,48
    80001142:	8082                	ret

0000000080001144 <freeproc>:
{
    80001144:	1101                	addi	sp,sp,-32
    80001146:	ec06                	sd	ra,24(sp)
    80001148:	e822                	sd	s0,16(sp)
    8000114a:	e426                	sd	s1,8(sp)
    8000114c:	1000                	addi	s0,sp,32
    8000114e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001150:	7128                	ld	a0,96(a0)
    80001152:	c509                	beqz	a0,8000115c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	ec8080e7          	jalr	-312(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000115c:	0604b023          	sd	zero,96(s1)
  if (p->usyscall)
    80001160:	6c88                	ld	a0,24(s1)
    80001162:	c509                	beqz	a0,8000116c <freeproc+0x28>
    kfree((void*)p->usyscall);
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	eb8080e7          	jalr	-328(ra) # 8000001c <kfree>
  p->usyscall = 0;
    8000116c:	0004bc23          	sd	zero,24(s1)
  if(p->pagetable)
    80001170:	6ca8                	ld	a0,88(s1)
    80001172:	c511                	beqz	a0,8000117e <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    80001174:	68ac                	ld	a1,80(s1)
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	f62080e7          	jalr	-158(ra) # 800010d8 <proc_freepagetable>
  p->pagetable = 0;
    8000117e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001182:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001186:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000118a:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000118e:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001192:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001196:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000119a:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000119e:	0204a023          	sw	zero,32(s1)
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <allocproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011b8:	00008497          	auipc	s1,0x8
    800011bc:	2c848493          	addi	s1,s1,712 # 80009480 <proc>
    800011c0:	0000e917          	auipc	s2,0xe
    800011c4:	ec090913          	addi	s2,s2,-320 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011c8:	8526                	mv	a0,s1
    800011ca:	00005097          	auipc	ra,0x5
    800011ce:	148080e7          	jalr	328(ra) # 80006312 <acquire>
    if(p->state == UNUSED) {
    800011d2:	509c                	lw	a5,32(s1)
    800011d4:	cf81                	beqz	a5,800011ec <allocproc+0x40>
      release(&p->lock);
    800011d6:	8526                	mv	a0,s1
    800011d8:	00005097          	auipc	ra,0x5
    800011dc:	1ee080e7          	jalr	494(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e0:	17048493          	addi	s1,s1,368
    800011e4:	ff2492e3          	bne	s1,s2,800011c8 <allocproc+0x1c>
  return 0;
    800011e8:	4481                	li	s1,0
    800011ea:	a0bd                	j	80001258 <allocproc+0xac>
  p->pid = allocpid();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	db0080e7          	jalr	-592(ra) # 80000f9c <allocpid>
    800011f4:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011f6:	4785                	li	a5,1
    800011f8:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	f1e080e7          	jalr	-226(ra) # 80000118 <kalloc>
    80001202:	892a                	mv	s2,a0
    80001204:	f0a8                	sd	a0,96(s1)
    80001206:	c125                	beqz	a0,80001266 <allocproc+0xba>
  if ((p->usyscall = (struct usyscall*)kalloc()) == 0) {
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	f10080e7          	jalr	-240(ra) # 80000118 <kalloc>
    80001210:	892a                	mv	s2,a0
    80001212:	ec88                	sd	a0,24(s1)
    80001214:	c52d                	beqz	a0,8000127e <allocproc+0xd2>
  memmove(p->usyscall, &p->pid, 8);
    80001216:	4621                	li	a2,8
    80001218:	03848593          	addi	a1,s1,56
    8000121c:	fffff097          	auipc	ra,0xfffff
    80001220:	fbc080e7          	jalr	-68(ra) # 800001d8 <memmove>
  p->pagetable = proc_pagetable(p);
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	dbc080e7          	jalr	-580(ra) # 80000fe2 <proc_pagetable>
    8000122e:	892a                	mv	s2,a0
    80001230:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001232:	c135                	beqz	a0,80001296 <allocproc+0xea>
  memset(&p->context, 0, sizeof(p->context));
    80001234:	07000613          	li	a2,112
    80001238:	4581                	li	a1,0
    8000123a:	06848513          	addi	a0,s1,104
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	f3a080e7          	jalr	-198(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001246:	00000797          	auipc	a5,0x0
    8000124a:	d1078793          	addi	a5,a5,-752 # 80000f56 <forkret>
    8000124e:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001250:	64bc                	ld	a5,72(s1)
    80001252:	6705                	lui	a4,0x1
    80001254:	97ba                	add	a5,a5,a4
    80001256:	f8bc                	sd	a5,112(s1)
}
    80001258:	8526                	mv	a0,s1
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6902                	ld	s2,0(sp)
    80001262:	6105                	addi	sp,sp,32
    80001264:	8082                	ret
    freeproc(p);
    80001266:	8526                	mv	a0,s1
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	edc080e7          	jalr	-292(ra) # 80001144 <freeproc>
    release(&p->lock);
    80001270:	8526                	mv	a0,s1
    80001272:	00005097          	auipc	ra,0x5
    80001276:	154080e7          	jalr	340(ra) # 800063c6 <release>
    return 0;
    8000127a:	84ca                	mv	s1,s2
    8000127c:	bff1                	j	80001258 <allocproc+0xac>
    freeproc(p);
    8000127e:	8526                	mv	a0,s1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	ec4080e7          	jalr	-316(ra) # 80001144 <freeproc>
    release(&p->lock);
    80001288:	8526                	mv	a0,s1
    8000128a:	00005097          	auipc	ra,0x5
    8000128e:	13c080e7          	jalr	316(ra) # 800063c6 <release>
    return 0;
    80001292:	84ca                	mv	s1,s2
    80001294:	b7d1                	j	80001258 <allocproc+0xac>
    freeproc(p);
    80001296:	8526                	mv	a0,s1
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	eac080e7          	jalr	-340(ra) # 80001144 <freeproc>
    release(&p->lock);
    800012a0:	8526                	mv	a0,s1
    800012a2:	00005097          	auipc	ra,0x5
    800012a6:	124080e7          	jalr	292(ra) # 800063c6 <release>
    return 0;
    800012aa:	84ca                	mv	s1,s2
    800012ac:	b775                	j	80001258 <allocproc+0xac>

00000000800012ae <userinit>:
{
    800012ae:	1101                	addi	sp,sp,-32
    800012b0:	ec06                	sd	ra,24(sp)
    800012b2:	e822                	sd	s0,16(sp)
    800012b4:	e426                	sd	s1,8(sp)
    800012b6:	1000                	addi	s0,sp,32
  p = allocproc();
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	ef4080e7          	jalr	-268(ra) # 800011ac <allocproc>
    800012c0:	84aa                	mv	s1,a0
  initproc = p;
    800012c2:	00008797          	auipc	a5,0x8
    800012c6:	d4a7b723          	sd	a0,-690(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012ca:	03400613          	li	a2,52
    800012ce:	00007597          	auipc	a1,0x7
    800012d2:	5e258593          	addi	a1,a1,1506 # 800088b0 <initcode>
    800012d6:	6d28                	ld	a0,88(a0)
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	528080e7          	jalr	1320(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    800012e0:	6785                	lui	a5,0x1
    800012e2:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012e4:	70b8                	ld	a4,96(s1)
    800012e6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012ea:	70b8                	ld	a4,96(s1)
    800012ec:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012ee:	4641                	li	a2,16
    800012f0:	00007597          	auipc	a1,0x7
    800012f4:	ed858593          	addi	a1,a1,-296 # 800081c8 <etext+0x1c8>
    800012f8:	16048513          	addi	a0,s1,352
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	fce080e7          	jalr	-50(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001304:	00007517          	auipc	a0,0x7
    80001308:	ed450513          	addi	a0,a0,-300 # 800081d8 <etext+0x1d8>
    8000130c:	00002097          	auipc	ra,0x2
    80001310:	1a4080e7          	jalr	420(ra) # 800034b0 <namei>
    80001314:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001318:	478d                	li	a5,3
    8000131a:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	0a8080e7          	jalr	168(ra) # 800063c6 <release>
}
    80001326:	60e2                	ld	ra,24(sp)
    80001328:	6442                	ld	s0,16(sp)
    8000132a:	64a2                	ld	s1,8(sp)
    8000132c:	6105                	addi	sp,sp,32
    8000132e:	8082                	ret

0000000080001330 <growproc>:
{
    80001330:	1101                	addi	sp,sp,-32
    80001332:	ec06                	sd	ra,24(sp)
    80001334:	e822                	sd	s0,16(sp)
    80001336:	e426                	sd	s1,8(sp)
    80001338:	e04a                	sd	s2,0(sp)
    8000133a:	1000                	addi	s0,sp,32
    8000133c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	be0080e7          	jalr	-1056(ra) # 80000f1e <myproc>
    80001346:	892a                	mv	s2,a0
  sz = p->sz;
    80001348:	692c                	ld	a1,80(a0)
    8000134a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000134e:	00904f63          	bgtz	s1,8000136c <growproc+0x3c>
  } else if(n < 0){
    80001352:	0204cc63          	bltz	s1,8000138a <growproc+0x5a>
  p->sz = sz;
    80001356:	1602                	slli	a2,a2,0x20
    80001358:	9201                	srli	a2,a2,0x20
    8000135a:	04c93823          	sd	a2,80(s2)
  return 0;
    8000135e:	4501                	li	a0,0
}
    80001360:	60e2                	ld	ra,24(sp)
    80001362:	6442                	ld	s0,16(sp)
    80001364:	64a2                	ld	s1,8(sp)
    80001366:	6902                	ld	s2,0(sp)
    80001368:	6105                	addi	sp,sp,32
    8000136a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000136c:	9e25                	addw	a2,a2,s1
    8000136e:	1602                	slli	a2,a2,0x20
    80001370:	9201                	srli	a2,a2,0x20
    80001372:	1582                	slli	a1,a1,0x20
    80001374:	9181                	srli	a1,a1,0x20
    80001376:	6d28                	ld	a0,88(a0)
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	542080e7          	jalr	1346(ra) # 800008ba <uvmalloc>
    80001380:	0005061b          	sext.w	a2,a0
    80001384:	fa69                	bnez	a2,80001356 <growproc+0x26>
      return -1;
    80001386:	557d                	li	a0,-1
    80001388:	bfe1                	j	80001360 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000138a:	9e25                	addw	a2,a2,s1
    8000138c:	1602                	slli	a2,a2,0x20
    8000138e:	9201                	srli	a2,a2,0x20
    80001390:	1582                	slli	a1,a1,0x20
    80001392:	9181                	srli	a1,a1,0x20
    80001394:	6d28                	ld	a0,88(a0)
    80001396:	fffff097          	auipc	ra,0xfffff
    8000139a:	4dc080e7          	jalr	1244(ra) # 80000872 <uvmdealloc>
    8000139e:	0005061b          	sext.w	a2,a0
    800013a2:	bf55                	j	80001356 <growproc+0x26>

00000000800013a4 <fork>:
{
    800013a4:	7179                	addi	sp,sp,-48
    800013a6:	f406                	sd	ra,40(sp)
    800013a8:	f022                	sd	s0,32(sp)
    800013aa:	ec26                	sd	s1,24(sp)
    800013ac:	e84a                	sd	s2,16(sp)
    800013ae:	e44e                	sd	s3,8(sp)
    800013b0:	e052                	sd	s4,0(sp)
    800013b2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	b6a080e7          	jalr	-1174(ra) # 80000f1e <myproc>
    800013bc:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	dee080e7          	jalr	-530(ra) # 800011ac <allocproc>
    800013c6:	10050b63          	beqz	a0,800014dc <fork+0x138>
    800013ca:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013cc:	05093603          	ld	a2,80(s2)
    800013d0:	6d2c                	ld	a1,88(a0)
    800013d2:	05893503          	ld	a0,88(s2)
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	630080e7          	jalr	1584(ra) # 80000a06 <uvmcopy>
    800013de:	04054663          	bltz	a0,8000142a <fork+0x86>
  np->sz = p->sz;
    800013e2:	05093783          	ld	a5,80(s2)
    800013e6:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800013ea:	06093683          	ld	a3,96(s2)
    800013ee:	87b6                	mv	a5,a3
    800013f0:	0609b703          	ld	a4,96(s3)
    800013f4:	12068693          	addi	a3,a3,288
    800013f8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013fc:	6788                	ld	a0,8(a5)
    800013fe:	6b8c                	ld	a1,16(a5)
    80001400:	6f90                	ld	a2,24(a5)
    80001402:	01073023          	sd	a6,0(a4)
    80001406:	e708                	sd	a0,8(a4)
    80001408:	eb0c                	sd	a1,16(a4)
    8000140a:	ef10                	sd	a2,24(a4)
    8000140c:	02078793          	addi	a5,a5,32
    80001410:	02070713          	addi	a4,a4,32
    80001414:	fed792e3          	bne	a5,a3,800013f8 <fork+0x54>
  np->trapframe->a0 = 0;
    80001418:	0609b783          	ld	a5,96(s3)
    8000141c:	0607b823          	sd	zero,112(a5)
    80001420:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001424:	15800a13          	li	s4,344
    80001428:	a03d                	j	80001456 <fork+0xb2>
    freeproc(np);
    8000142a:	854e                	mv	a0,s3
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	d18080e7          	jalr	-744(ra) # 80001144 <freeproc>
    release(&np->lock);
    80001434:	854e                	mv	a0,s3
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	f90080e7          	jalr	-112(ra) # 800063c6 <release>
    return -1;
    8000143e:	5a7d                	li	s4,-1
    80001440:	a069                	j	800014ca <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001442:	00002097          	auipc	ra,0x2
    80001446:	704080e7          	jalr	1796(ra) # 80003b46 <filedup>
    8000144a:	009987b3          	add	a5,s3,s1
    8000144e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001450:	04a1                	addi	s1,s1,8
    80001452:	01448763          	beq	s1,s4,80001460 <fork+0xbc>
    if(p->ofile[i])
    80001456:	009907b3          	add	a5,s2,s1
    8000145a:	6388                	ld	a0,0(a5)
    8000145c:	f17d                	bnez	a0,80001442 <fork+0x9e>
    8000145e:	bfcd                	j	80001450 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001460:	15893503          	ld	a0,344(s2)
    80001464:	00002097          	auipc	ra,0x2
    80001468:	858080e7          	jalr	-1960(ra) # 80002cbc <idup>
    8000146c:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001470:	4641                	li	a2,16
    80001472:	16090593          	addi	a1,s2,352
    80001476:	16098513          	addi	a0,s3,352
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	e50080e7          	jalr	-432(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001482:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001486:	854e                	mv	a0,s3
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	f3e080e7          	jalr	-194(ra) # 800063c6 <release>
  acquire(&wait_lock);
    80001490:	00008497          	auipc	s1,0x8
    80001494:	bd848493          	addi	s1,s1,-1064 # 80009068 <wait_lock>
    80001498:	8526                	mv	a0,s1
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	e78080e7          	jalr	-392(ra) # 80006312 <acquire>
  np->parent = p;
    800014a2:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    800014a6:	8526                	mv	a0,s1
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	f1e080e7          	jalr	-226(ra) # 800063c6 <release>
  acquire(&np->lock);
    800014b0:	854e                	mv	a0,s3
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	e60080e7          	jalr	-416(ra) # 80006312 <acquire>
  np->state = RUNNABLE;
    800014ba:	478d                	li	a5,3
    800014bc:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    800014c0:	854e                	mv	a0,s3
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	f04080e7          	jalr	-252(ra) # 800063c6 <release>
}
    800014ca:	8552                	mv	a0,s4
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6a02                	ld	s4,0(sp)
    800014d8:	6145                	addi	sp,sp,48
    800014da:	8082                	ret
    return -1;
    800014dc:	5a7d                	li	s4,-1
    800014de:	b7f5                	j	800014ca <fork+0x126>

00000000800014e0 <scheduler>:
{
    800014e0:	7139                	addi	sp,sp,-64
    800014e2:	fc06                	sd	ra,56(sp)
    800014e4:	f822                	sd	s0,48(sp)
    800014e6:	f426                	sd	s1,40(sp)
    800014e8:	f04a                	sd	s2,32(sp)
    800014ea:	ec4e                	sd	s3,24(sp)
    800014ec:	e852                	sd	s4,16(sp)
    800014ee:	e456                	sd	s5,8(sp)
    800014f0:	e05a                	sd	s6,0(sp)
    800014f2:	0080                	addi	s0,sp,64
    800014f4:	8792                	mv	a5,tp
  int id = r_tp();
    800014f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014f8:	00779a93          	slli	s5,a5,0x7
    800014fc:	00008717          	auipc	a4,0x8
    80001500:	b5470713          	addi	a4,a4,-1196 # 80009050 <pid_lock>
    80001504:	9756                	add	a4,a4,s5
    80001506:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000150a:	00008717          	auipc	a4,0x8
    8000150e:	b7e70713          	addi	a4,a4,-1154 # 80009088 <cpus+0x8>
    80001512:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001514:	498d                	li	s3,3
        p->state = RUNNING;
    80001516:	4b11                	li	s6,4
        c->proc = p;
    80001518:	079e                	slli	a5,a5,0x7
    8000151a:	00008a17          	auipc	s4,0x8
    8000151e:	b36a0a13          	addi	s4,s4,-1226 # 80009050 <pid_lock>
    80001522:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001524:	0000e917          	auipc	s2,0xe
    80001528:	b5c90913          	addi	s2,s2,-1188 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000152c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001530:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001534:	10079073          	csrw	sstatus,a5
    80001538:	00008497          	auipc	s1,0x8
    8000153c:	f4848493          	addi	s1,s1,-184 # 80009480 <proc>
    80001540:	a03d                	j	8000156e <scheduler+0x8e>
        p->state = RUNNING;
    80001542:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001546:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000154a:	06848593          	addi	a1,s1,104
    8000154e:	8556                	mv	a0,s5
    80001550:	00000097          	auipc	ra,0x0
    80001554:	6de080e7          	jalr	1758(ra) # 80001c2e <swtch>
        c->proc = 0;
    80001558:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	e68080e7          	jalr	-408(ra) # 800063c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001566:	17048493          	addi	s1,s1,368
    8000156a:	fd2481e3          	beq	s1,s2,8000152c <scheduler+0x4c>
      acquire(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	da2080e7          	jalr	-606(ra) # 80006312 <acquire>
      if(p->state == RUNNABLE) {
    80001578:	509c                	lw	a5,32(s1)
    8000157a:	ff3791e3          	bne	a5,s3,8000155c <scheduler+0x7c>
    8000157e:	b7d1                	j	80001542 <scheduler+0x62>

0000000080001580 <sched>:
{
    80001580:	7179                	addi	sp,sp,-48
    80001582:	f406                	sd	ra,40(sp)
    80001584:	f022                	sd	s0,32(sp)
    80001586:	ec26                	sd	s1,24(sp)
    80001588:	e84a                	sd	s2,16(sp)
    8000158a:	e44e                	sd	s3,8(sp)
    8000158c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	990080e7          	jalr	-1648(ra) # 80000f1e <myproc>
    80001596:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	d00080e7          	jalr	-768(ra) # 80006298 <holding>
    800015a0:	c93d                	beqz	a0,80001616 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015a2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015a4:	2781                	sext.w	a5,a5
    800015a6:	079e                	slli	a5,a5,0x7
    800015a8:	00008717          	auipc	a4,0x8
    800015ac:	aa870713          	addi	a4,a4,-1368 # 80009050 <pid_lock>
    800015b0:	97ba                	add	a5,a5,a4
    800015b2:	0a87a703          	lw	a4,168(a5)
    800015b6:	4785                	li	a5,1
    800015b8:	06f71763          	bne	a4,a5,80001626 <sched+0xa6>
  if(p->state == RUNNING)
    800015bc:	5098                	lw	a4,32(s1)
    800015be:	4791                	li	a5,4
    800015c0:	06f70b63          	beq	a4,a5,80001636 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015c8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015ca:	efb5                	bnez	a5,80001646 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015cc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015ce:	00008917          	auipc	s2,0x8
    800015d2:	a8290913          	addi	s2,s2,-1406 # 80009050 <pid_lock>
    800015d6:	2781                	sext.w	a5,a5
    800015d8:	079e                	slli	a5,a5,0x7
    800015da:	97ca                	add	a5,a5,s2
    800015dc:	0ac7a983          	lw	s3,172(a5)
    800015e0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	00008597          	auipc	a1,0x8
    800015ea:	aa258593          	addi	a1,a1,-1374 # 80009088 <cpus+0x8>
    800015ee:	95be                	add	a1,a1,a5
    800015f0:	06848513          	addi	a0,s1,104
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	63a080e7          	jalr	1594(ra) # 80001c2e <swtch>
    800015fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015fe:	2781                	sext.w	a5,a5
    80001600:	079e                	slli	a5,a5,0x7
    80001602:	97ca                	add	a5,a5,s2
    80001604:	0b37a623          	sw	s3,172(a5)
}
    80001608:	70a2                	ld	ra,40(sp)
    8000160a:	7402                	ld	s0,32(sp)
    8000160c:	64e2                	ld	s1,24(sp)
    8000160e:	6942                	ld	s2,16(sp)
    80001610:	69a2                	ld	s3,8(sp)
    80001612:	6145                	addi	sp,sp,48
    80001614:	8082                	ret
    panic("sched p->lock");
    80001616:	00007517          	auipc	a0,0x7
    8000161a:	bca50513          	addi	a0,a0,-1078 # 800081e0 <etext+0x1e0>
    8000161e:	00004097          	auipc	ra,0x4
    80001622:	7aa080e7          	jalr	1962(ra) # 80005dc8 <panic>
    panic("sched locks");
    80001626:	00007517          	auipc	a0,0x7
    8000162a:	bca50513          	addi	a0,a0,-1078 # 800081f0 <etext+0x1f0>
    8000162e:	00004097          	auipc	ra,0x4
    80001632:	79a080e7          	jalr	1946(ra) # 80005dc8 <panic>
    panic("sched running");
    80001636:	00007517          	auipc	a0,0x7
    8000163a:	bca50513          	addi	a0,a0,-1078 # 80008200 <etext+0x200>
    8000163e:	00004097          	auipc	ra,0x4
    80001642:	78a080e7          	jalr	1930(ra) # 80005dc8 <panic>
    panic("sched interruptible");
    80001646:	00007517          	auipc	a0,0x7
    8000164a:	bca50513          	addi	a0,a0,-1078 # 80008210 <etext+0x210>
    8000164e:	00004097          	auipc	ra,0x4
    80001652:	77a080e7          	jalr	1914(ra) # 80005dc8 <panic>

0000000080001656 <yield>:
{
    80001656:	1101                	addi	sp,sp,-32
    80001658:	ec06                	sd	ra,24(sp)
    8000165a:	e822                	sd	s0,16(sp)
    8000165c:	e426                	sd	s1,8(sp)
    8000165e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001660:	00000097          	auipc	ra,0x0
    80001664:	8be080e7          	jalr	-1858(ra) # 80000f1e <myproc>
    80001668:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	ca8080e7          	jalr	-856(ra) # 80006312 <acquire>
  p->state = RUNNABLE;
    80001672:	478d                	li	a5,3
    80001674:	d09c                	sw	a5,32(s1)
  sched();
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	f0a080e7          	jalr	-246(ra) # 80001580 <sched>
  release(&p->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	d46080e7          	jalr	-698(ra) # 800063c6 <release>
}
    80001688:	60e2                	ld	ra,24(sp)
    8000168a:	6442                	ld	s0,16(sp)
    8000168c:	64a2                	ld	s1,8(sp)
    8000168e:	6105                	addi	sp,sp,32
    80001690:	8082                	ret

0000000080001692 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001692:	7179                	addi	sp,sp,-48
    80001694:	f406                	sd	ra,40(sp)
    80001696:	f022                	sd	s0,32(sp)
    80001698:	ec26                	sd	s1,24(sp)
    8000169a:	e84a                	sd	s2,16(sp)
    8000169c:	e44e                	sd	s3,8(sp)
    8000169e:	1800                	addi	s0,sp,48
    800016a0:	89aa                	mv	s3,a0
    800016a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	87a080e7          	jalr	-1926(ra) # 80000f1e <myproc>
    800016ac:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	c64080e7          	jalr	-924(ra) # 80006312 <acquire>
  release(lk);
    800016b6:	854a                	mv	a0,s2
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	d0e080e7          	jalr	-754(ra) # 800063c6 <release>

  // Go to sleep.
  p->chan = chan;
    800016c0:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016c4:	4789                	li	a5,2
    800016c6:	d09c                	sw	a5,32(s1)

  sched();
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	eb8080e7          	jalr	-328(ra) # 80001580 <sched>

  // Tidy up.
  p->chan = 0;
    800016d0:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016d4:	8526                	mv	a0,s1
    800016d6:	00005097          	auipc	ra,0x5
    800016da:	cf0080e7          	jalr	-784(ra) # 800063c6 <release>
  acquire(lk);
    800016de:	854a                	mv	a0,s2
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	c32080e7          	jalr	-974(ra) # 80006312 <acquire>
}
    800016e8:	70a2                	ld	ra,40(sp)
    800016ea:	7402                	ld	s0,32(sp)
    800016ec:	64e2                	ld	s1,24(sp)
    800016ee:	6942                	ld	s2,16(sp)
    800016f0:	69a2                	ld	s3,8(sp)
    800016f2:	6145                	addi	sp,sp,48
    800016f4:	8082                	ret

00000000800016f6 <wait>:
{
    800016f6:	715d                	addi	sp,sp,-80
    800016f8:	e486                	sd	ra,72(sp)
    800016fa:	e0a2                	sd	s0,64(sp)
    800016fc:	fc26                	sd	s1,56(sp)
    800016fe:	f84a                	sd	s2,48(sp)
    80001700:	f44e                	sd	s3,40(sp)
    80001702:	f052                	sd	s4,32(sp)
    80001704:	ec56                	sd	s5,24(sp)
    80001706:	e85a                	sd	s6,16(sp)
    80001708:	e45e                	sd	s7,8(sp)
    8000170a:	e062                	sd	s8,0(sp)
    8000170c:	0880                	addi	s0,sp,80
    8000170e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001710:	00000097          	auipc	ra,0x0
    80001714:	80e080e7          	jalr	-2034(ra) # 80000f1e <myproc>
    80001718:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000171a:	00008517          	auipc	a0,0x8
    8000171e:	94e50513          	addi	a0,a0,-1714 # 80009068 <wait_lock>
    80001722:	00005097          	auipc	ra,0x5
    80001726:	bf0080e7          	jalr	-1040(ra) # 80006312 <acquire>
    havekids = 0;
    8000172a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000172c:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000172e:	0000e997          	auipc	s3,0xe
    80001732:	95298993          	addi	s3,s3,-1710 # 8000f080 <tickslock>
        havekids = 1;
    80001736:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001738:	00008c17          	auipc	s8,0x8
    8000173c:	930c0c13          	addi	s8,s8,-1744 # 80009068 <wait_lock>
    havekids = 0;
    80001740:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001742:	00008497          	auipc	s1,0x8
    80001746:	d3e48493          	addi	s1,s1,-706 # 80009480 <proc>
    8000174a:	a0bd                	j	800017b8 <wait+0xc2>
          pid = np->pid;
    8000174c:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001750:	000b0e63          	beqz	s6,8000176c <wait+0x76>
    80001754:	4691                	li	a3,4
    80001756:	03448613          	addi	a2,s1,52
    8000175a:	85da                	mv	a1,s6
    8000175c:	05893503          	ld	a0,88(s2)
    80001760:	fffff097          	auipc	ra,0xfffff
    80001764:	3aa080e7          	jalr	938(ra) # 80000b0a <copyout>
    80001768:	02054563          	bltz	a0,80001792 <wait+0x9c>
          freeproc(np);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00000097          	auipc	ra,0x0
    80001772:	9d6080e7          	jalr	-1578(ra) # 80001144 <freeproc>
          release(&np->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	c4e080e7          	jalr	-946(ra) # 800063c6 <release>
          release(&wait_lock);
    80001780:	00008517          	auipc	a0,0x8
    80001784:	8e850513          	addi	a0,a0,-1816 # 80009068 <wait_lock>
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	c3e080e7          	jalr	-962(ra) # 800063c6 <release>
          return pid;
    80001790:	a09d                	j	800017f6 <wait+0x100>
            release(&np->lock);
    80001792:	8526                	mv	a0,s1
    80001794:	00005097          	auipc	ra,0x5
    80001798:	c32080e7          	jalr	-974(ra) # 800063c6 <release>
            release(&wait_lock);
    8000179c:	00008517          	auipc	a0,0x8
    800017a0:	8cc50513          	addi	a0,a0,-1844 # 80009068 <wait_lock>
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	c22080e7          	jalr	-990(ra) # 800063c6 <release>
            return -1;
    800017ac:	59fd                	li	s3,-1
    800017ae:	a0a1                	j	800017f6 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017b0:	17048493          	addi	s1,s1,368
    800017b4:	03348463          	beq	s1,s3,800017dc <wait+0xe6>
      if(np->parent == p){
    800017b8:	60bc                	ld	a5,64(s1)
    800017ba:	ff279be3          	bne	a5,s2,800017b0 <wait+0xba>
        acquire(&np->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	b52080e7          	jalr	-1198(ra) # 80006312 <acquire>
        if(np->state == ZOMBIE){
    800017c8:	509c                	lw	a5,32(s1)
    800017ca:	f94781e3          	beq	a5,s4,8000174c <wait+0x56>
        release(&np->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	00005097          	auipc	ra,0x5
    800017d4:	bf6080e7          	jalr	-1034(ra) # 800063c6 <release>
        havekids = 1;
    800017d8:	8756                	mv	a4,s5
    800017da:	bfd9                	j	800017b0 <wait+0xba>
    if(!havekids || p->killed){
    800017dc:	c701                	beqz	a4,800017e4 <wait+0xee>
    800017de:	03092783          	lw	a5,48(s2)
    800017e2:	c79d                	beqz	a5,80001810 <wait+0x11a>
      release(&wait_lock);
    800017e4:	00008517          	auipc	a0,0x8
    800017e8:	88450513          	addi	a0,a0,-1916 # 80009068 <wait_lock>
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	bda080e7          	jalr	-1062(ra) # 800063c6 <release>
      return -1;
    800017f4:	59fd                	li	s3,-1
}
    800017f6:	854e                	mv	a0,s3
    800017f8:	60a6                	ld	ra,72(sp)
    800017fa:	6406                	ld	s0,64(sp)
    800017fc:	74e2                	ld	s1,56(sp)
    800017fe:	7942                	ld	s2,48(sp)
    80001800:	79a2                	ld	s3,40(sp)
    80001802:	7a02                	ld	s4,32(sp)
    80001804:	6ae2                	ld	s5,24(sp)
    80001806:	6b42                	ld	s6,16(sp)
    80001808:	6ba2                	ld	s7,8(sp)
    8000180a:	6c02                	ld	s8,0(sp)
    8000180c:	6161                	addi	sp,sp,80
    8000180e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001810:	85e2                	mv	a1,s8
    80001812:	854a                	mv	a0,s2
    80001814:	00000097          	auipc	ra,0x0
    80001818:	e7e080e7          	jalr	-386(ra) # 80001692 <sleep>
    havekids = 0;
    8000181c:	b715                	j	80001740 <wait+0x4a>

000000008000181e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000181e:	7139                	addi	sp,sp,-64
    80001820:	fc06                	sd	ra,56(sp)
    80001822:	f822                	sd	s0,48(sp)
    80001824:	f426                	sd	s1,40(sp)
    80001826:	f04a                	sd	s2,32(sp)
    80001828:	ec4e                	sd	s3,24(sp)
    8000182a:	e852                	sd	s4,16(sp)
    8000182c:	e456                	sd	s5,8(sp)
    8000182e:	0080                	addi	s0,sp,64
    80001830:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001832:	00008497          	auipc	s1,0x8
    80001836:	c4e48493          	addi	s1,s1,-946 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000183a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000183c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183e:	0000e917          	auipc	s2,0xe
    80001842:	84290913          	addi	s2,s2,-1982 # 8000f080 <tickslock>
    80001846:	a821                	j	8000185e <wakeup+0x40>
        p->state = RUNNABLE;
    80001848:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	b78080e7          	jalr	-1160(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001856:	17048493          	addi	s1,s1,368
    8000185a:	03248463          	beq	s1,s2,80001882 <wakeup+0x64>
    if(p != myproc()){
    8000185e:	fffff097          	auipc	ra,0xfffff
    80001862:	6c0080e7          	jalr	1728(ra) # 80000f1e <myproc>
    80001866:	fea488e3          	beq	s1,a0,80001856 <wakeup+0x38>
      acquire(&p->lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	aa6080e7          	jalr	-1370(ra) # 80006312 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001874:	509c                	lw	a5,32(s1)
    80001876:	fd379be3          	bne	a5,s3,8000184c <wakeup+0x2e>
    8000187a:	749c                	ld	a5,40(s1)
    8000187c:	fd4798e3          	bne	a5,s4,8000184c <wakeup+0x2e>
    80001880:	b7e1                	j	80001848 <wakeup+0x2a>
    }
  }
}
    80001882:	70e2                	ld	ra,56(sp)
    80001884:	7442                	ld	s0,48(sp)
    80001886:	74a2                	ld	s1,40(sp)
    80001888:	7902                	ld	s2,32(sp)
    8000188a:	69e2                	ld	s3,24(sp)
    8000188c:	6a42                	ld	s4,16(sp)
    8000188e:	6aa2                	ld	s5,8(sp)
    80001890:	6121                	addi	sp,sp,64
    80001892:	8082                	ret

0000000080001894 <reparent>:
{
    80001894:	7179                	addi	sp,sp,-48
    80001896:	f406                	sd	ra,40(sp)
    80001898:	f022                	sd	s0,32(sp)
    8000189a:	ec26                	sd	s1,24(sp)
    8000189c:	e84a                	sd	s2,16(sp)
    8000189e:	e44e                	sd	s3,8(sp)
    800018a0:	e052                	sd	s4,0(sp)
    800018a2:	1800                	addi	s0,sp,48
    800018a4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018a6:	00008497          	auipc	s1,0x8
    800018aa:	bda48493          	addi	s1,s1,-1062 # 80009480 <proc>
      pp->parent = initproc;
    800018ae:	00007a17          	auipc	s4,0x7
    800018b2:	762a0a13          	addi	s4,s4,1890 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b6:	0000d997          	auipc	s3,0xd
    800018ba:	7ca98993          	addi	s3,s3,1994 # 8000f080 <tickslock>
    800018be:	a029                	j	800018c8 <reparent+0x34>
    800018c0:	17048493          	addi	s1,s1,368
    800018c4:	01348d63          	beq	s1,s3,800018de <reparent+0x4a>
    if(pp->parent == p){
    800018c8:	60bc                	ld	a5,64(s1)
    800018ca:	ff279be3          	bne	a5,s2,800018c0 <reparent+0x2c>
      pp->parent = initproc;
    800018ce:	000a3503          	ld	a0,0(s4)
    800018d2:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018d4:	00000097          	auipc	ra,0x0
    800018d8:	f4a080e7          	jalr	-182(ra) # 8000181e <wakeup>
    800018dc:	b7d5                	j	800018c0 <reparent+0x2c>
}
    800018de:	70a2                	ld	ra,40(sp)
    800018e0:	7402                	ld	s0,32(sp)
    800018e2:	64e2                	ld	s1,24(sp)
    800018e4:	6942                	ld	s2,16(sp)
    800018e6:	69a2                	ld	s3,8(sp)
    800018e8:	6a02                	ld	s4,0(sp)
    800018ea:	6145                	addi	sp,sp,48
    800018ec:	8082                	ret

00000000800018ee <exit>:
{
    800018ee:	7179                	addi	sp,sp,-48
    800018f0:	f406                	sd	ra,40(sp)
    800018f2:	f022                	sd	s0,32(sp)
    800018f4:	ec26                	sd	s1,24(sp)
    800018f6:	e84a                	sd	s2,16(sp)
    800018f8:	e44e                	sd	s3,8(sp)
    800018fa:	e052                	sd	s4,0(sp)
    800018fc:	1800                	addi	s0,sp,48
    800018fe:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	61e080e7          	jalr	1566(ra) # 80000f1e <myproc>
    80001908:	89aa                	mv	s3,a0
  if(p == initproc)
    8000190a:	00007797          	auipc	a5,0x7
    8000190e:	7067b783          	ld	a5,1798(a5) # 80009010 <initproc>
    80001912:	0d850493          	addi	s1,a0,216
    80001916:	15850913          	addi	s2,a0,344
    8000191a:	02a79363          	bne	a5,a0,80001940 <exit+0x52>
    panic("init exiting");
    8000191e:	00007517          	auipc	a0,0x7
    80001922:	90a50513          	addi	a0,a0,-1782 # 80008228 <etext+0x228>
    80001926:	00004097          	auipc	ra,0x4
    8000192a:	4a2080e7          	jalr	1186(ra) # 80005dc8 <panic>
      fileclose(f);
    8000192e:	00002097          	auipc	ra,0x2
    80001932:	26a080e7          	jalr	618(ra) # 80003b98 <fileclose>
      p->ofile[fd] = 0;
    80001936:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000193a:	04a1                	addi	s1,s1,8
    8000193c:	01248563          	beq	s1,s2,80001946 <exit+0x58>
    if(p->ofile[fd]){
    80001940:	6088                	ld	a0,0(s1)
    80001942:	f575                	bnez	a0,8000192e <exit+0x40>
    80001944:	bfdd                	j	8000193a <exit+0x4c>
  begin_op();
    80001946:	00002097          	auipc	ra,0x2
    8000194a:	d86080e7          	jalr	-634(ra) # 800036cc <begin_op>
  iput(p->cwd);
    8000194e:	1589b503          	ld	a0,344(s3)
    80001952:	00001097          	auipc	ra,0x1
    80001956:	562080e7          	jalr	1378(ra) # 80002eb4 <iput>
  end_op();
    8000195a:	00002097          	auipc	ra,0x2
    8000195e:	df2080e7          	jalr	-526(ra) # 8000374c <end_op>
  p->cwd = 0;
    80001962:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001966:	00007497          	auipc	s1,0x7
    8000196a:	70248493          	addi	s1,s1,1794 # 80009068 <wait_lock>
    8000196e:	8526                	mv	a0,s1
    80001970:	00005097          	auipc	ra,0x5
    80001974:	9a2080e7          	jalr	-1630(ra) # 80006312 <acquire>
  reparent(p);
    80001978:	854e                	mv	a0,s3
    8000197a:	00000097          	auipc	ra,0x0
    8000197e:	f1a080e7          	jalr	-230(ra) # 80001894 <reparent>
  wakeup(p->parent);
    80001982:	0409b503          	ld	a0,64(s3)
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	e98080e7          	jalr	-360(ra) # 8000181e <wakeup>
  acquire(&p->lock);
    8000198e:	854e                	mv	a0,s3
    80001990:	00005097          	auipc	ra,0x5
    80001994:	982080e7          	jalr	-1662(ra) # 80006312 <acquire>
  p->xstate = status;
    80001998:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000199c:	4795                	li	a5,5
    8000199e:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019a2:	8526                	mv	a0,s1
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	a22080e7          	jalr	-1502(ra) # 800063c6 <release>
  sched();
    800019ac:	00000097          	auipc	ra,0x0
    800019b0:	bd4080e7          	jalr	-1068(ra) # 80001580 <sched>
  panic("zombie exit");
    800019b4:	00007517          	auipc	a0,0x7
    800019b8:	88450513          	addi	a0,a0,-1916 # 80008238 <etext+0x238>
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	40c080e7          	jalr	1036(ra) # 80005dc8 <panic>

00000000800019c4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019c4:	7179                	addi	sp,sp,-48
    800019c6:	f406                	sd	ra,40(sp)
    800019c8:	f022                	sd	s0,32(sp)
    800019ca:	ec26                	sd	s1,24(sp)
    800019cc:	e84a                	sd	s2,16(sp)
    800019ce:	e44e                	sd	s3,8(sp)
    800019d0:	1800                	addi	s0,sp,48
    800019d2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00008497          	auipc	s1,0x8
    800019d8:	aac48493          	addi	s1,s1,-1364 # 80009480 <proc>
    800019dc:	0000d997          	auipc	s3,0xd
    800019e0:	6a498993          	addi	s3,s3,1700 # 8000f080 <tickslock>
    acquire(&p->lock);
    800019e4:	8526                	mv	a0,s1
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	92c080e7          	jalr	-1748(ra) # 80006312 <acquire>
    if(p->pid == pid){
    800019ee:	5c9c                	lw	a5,56(s1)
    800019f0:	01278d63          	beq	a5,s2,80001a0a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019f4:	8526                	mv	a0,s1
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	9d0080e7          	jalr	-1584(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fe:	17048493          	addi	s1,s1,368
    80001a02:	ff3491e3          	bne	s1,s3,800019e4 <kill+0x20>
  }
  return -1;
    80001a06:	557d                	li	a0,-1
    80001a08:	a829                	j	80001a22 <kill+0x5e>
      p->killed = 1;
    80001a0a:	4785                	li	a5,1
    80001a0c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a0e:	5098                	lw	a4,32(s1)
    80001a10:	4789                	li	a5,2
    80001a12:	00f70f63          	beq	a4,a5,80001a30 <kill+0x6c>
      release(&p->lock);
    80001a16:	8526                	mv	a0,s1
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	9ae080e7          	jalr	-1618(ra) # 800063c6 <release>
      return 0;
    80001a20:	4501                	li	a0,0
}
    80001a22:	70a2                	ld	ra,40(sp)
    80001a24:	7402                	ld	s0,32(sp)
    80001a26:	64e2                	ld	s1,24(sp)
    80001a28:	6942                	ld	s2,16(sp)
    80001a2a:	69a2                	ld	s3,8(sp)
    80001a2c:	6145                	addi	sp,sp,48
    80001a2e:	8082                	ret
        p->state = RUNNABLE;
    80001a30:	478d                	li	a5,3
    80001a32:	d09c                	sw	a5,32(s1)
    80001a34:	b7cd                	j	80001a16 <kill+0x52>

0000000080001a36 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a36:	7179                	addi	sp,sp,-48
    80001a38:	f406                	sd	ra,40(sp)
    80001a3a:	f022                	sd	s0,32(sp)
    80001a3c:	ec26                	sd	s1,24(sp)
    80001a3e:	e84a                	sd	s2,16(sp)
    80001a40:	e44e                	sd	s3,8(sp)
    80001a42:	e052                	sd	s4,0(sp)
    80001a44:	1800                	addi	s0,sp,48
    80001a46:	84aa                	mv	s1,a0
    80001a48:	892e                	mv	s2,a1
    80001a4a:	89b2                	mv	s3,a2
    80001a4c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	4d0080e7          	jalr	1232(ra) # 80000f1e <myproc>
  if(user_dst){
    80001a56:	c08d                	beqz	s1,80001a78 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a58:	86d2                	mv	a3,s4
    80001a5a:	864e                	mv	a2,s3
    80001a5c:	85ca                	mv	a1,s2
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	0aa080e7          	jalr	170(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a68:	70a2                	ld	ra,40(sp)
    80001a6a:	7402                	ld	s0,32(sp)
    80001a6c:	64e2                	ld	s1,24(sp)
    80001a6e:	6942                	ld	s2,16(sp)
    80001a70:	69a2                	ld	s3,8(sp)
    80001a72:	6a02                	ld	s4,0(sp)
    80001a74:	6145                	addi	sp,sp,48
    80001a76:	8082                	ret
    memmove((char *)dst, src, len);
    80001a78:	000a061b          	sext.w	a2,s4
    80001a7c:	85ce                	mv	a1,s3
    80001a7e:	854a                	mv	a0,s2
    80001a80:	ffffe097          	auipc	ra,0xffffe
    80001a84:	758080e7          	jalr	1880(ra) # 800001d8 <memmove>
    return 0;
    80001a88:	8526                	mv	a0,s1
    80001a8a:	bff9                	j	80001a68 <either_copyout+0x32>

0000000080001a8c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a8c:	7179                	addi	sp,sp,-48
    80001a8e:	f406                	sd	ra,40(sp)
    80001a90:	f022                	sd	s0,32(sp)
    80001a92:	ec26                	sd	s1,24(sp)
    80001a94:	e84a                	sd	s2,16(sp)
    80001a96:	e44e                	sd	s3,8(sp)
    80001a98:	e052                	sd	s4,0(sp)
    80001a9a:	1800                	addi	s0,sp,48
    80001a9c:	892a                	mv	s2,a0
    80001a9e:	84ae                	mv	s1,a1
    80001aa0:	89b2                	mv	s3,a2
    80001aa2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	47a080e7          	jalr	1146(ra) # 80000f1e <myproc>
  if(user_src){
    80001aac:	c08d                	beqz	s1,80001ace <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aae:	86d2                	mv	a3,s4
    80001ab0:	864e                	mv	a2,s3
    80001ab2:	85ca                	mv	a1,s2
    80001ab4:	6d28                	ld	a0,88(a0)
    80001ab6:	fffff097          	auipc	ra,0xfffff
    80001aba:	0e0080e7          	jalr	224(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001abe:	70a2                	ld	ra,40(sp)
    80001ac0:	7402                	ld	s0,32(sp)
    80001ac2:	64e2                	ld	s1,24(sp)
    80001ac4:	6942                	ld	s2,16(sp)
    80001ac6:	69a2                	ld	s3,8(sp)
    80001ac8:	6a02                	ld	s4,0(sp)
    80001aca:	6145                	addi	sp,sp,48
    80001acc:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ace:	000a061b          	sext.w	a2,s4
    80001ad2:	85ce                	mv	a1,s3
    80001ad4:	854a                	mv	a0,s2
    80001ad6:	ffffe097          	auipc	ra,0xffffe
    80001ada:	702080e7          	jalr	1794(ra) # 800001d8 <memmove>
    return 0;
    80001ade:	8526                	mv	a0,s1
    80001ae0:	bff9                	j	80001abe <either_copyin+0x32>

0000000080001ae2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ae2:	715d                	addi	sp,sp,-80
    80001ae4:	e486                	sd	ra,72(sp)
    80001ae6:	e0a2                	sd	s0,64(sp)
    80001ae8:	fc26                	sd	s1,56(sp)
    80001aea:	f84a                	sd	s2,48(sp)
    80001aec:	f44e                	sd	s3,40(sp)
    80001aee:	f052                	sd	s4,32(sp)
    80001af0:	ec56                	sd	s5,24(sp)
    80001af2:	e85a                	sd	s6,16(sp)
    80001af4:	e45e                	sd	s7,8(sp)
    80001af6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001af8:	00006517          	auipc	a0,0x6
    80001afc:	55050513          	addi	a0,a0,1360 # 80008048 <etext+0x48>
    80001b00:	00004097          	auipc	ra,0x4
    80001b04:	312080e7          	jalr	786(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b08:	00008497          	auipc	s1,0x8
    80001b0c:	ad848493          	addi	s1,s1,-1320 # 800095e0 <proc+0x160>
    80001b10:	0000d917          	auipc	s2,0xd
    80001b14:	6d090913          	addi	s2,s2,1744 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b18:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b1a:	00006997          	auipc	s3,0x6
    80001b1e:	72e98993          	addi	s3,s3,1838 # 80008248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001b22:	00006a97          	auipc	s5,0x6
    80001b26:	72ea8a93          	addi	s5,s5,1838 # 80008250 <etext+0x250>
    printf("\n");
    80001b2a:	00006a17          	auipc	s4,0x6
    80001b2e:	51ea0a13          	addi	s4,s4,1310 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b32:	00006b97          	auipc	s7,0x6
    80001b36:	756b8b93          	addi	s7,s7,1878 # 80008288 <states.1727>
    80001b3a:	a00d                	j	80001b5c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b3c:	ed86a583          	lw	a1,-296(a3)
    80001b40:	8556                	mv	a0,s5
    80001b42:	00004097          	auipc	ra,0x4
    80001b46:	2d0080e7          	jalr	720(ra) # 80005e12 <printf>
    printf("\n");
    80001b4a:	8552                	mv	a0,s4
    80001b4c:	00004097          	auipc	ra,0x4
    80001b50:	2c6080e7          	jalr	710(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b54:	17048493          	addi	s1,s1,368
    80001b58:	03248163          	beq	s1,s2,80001b7a <procdump+0x98>
    if(p->state == UNUSED)
    80001b5c:	86a6                	mv	a3,s1
    80001b5e:	ec04a783          	lw	a5,-320(s1)
    80001b62:	dbed                	beqz	a5,80001b54 <procdump+0x72>
      state = "???";
    80001b64:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b66:	fcfb6be3          	bltu	s6,a5,80001b3c <procdump+0x5a>
    80001b6a:	1782                	slli	a5,a5,0x20
    80001b6c:	9381                	srli	a5,a5,0x20
    80001b6e:	078e                	slli	a5,a5,0x3
    80001b70:	97de                	add	a5,a5,s7
    80001b72:	6390                	ld	a2,0(a5)
    80001b74:	f661                	bnez	a2,80001b3c <procdump+0x5a>
      state = "???";
    80001b76:	864e                	mv	a2,s3
    80001b78:	b7d1                	j	80001b3c <procdump+0x5a>
  }
}
    80001b7a:	60a6                	ld	ra,72(sp)
    80001b7c:	6406                	ld	s0,64(sp)
    80001b7e:	74e2                	ld	s1,56(sp)
    80001b80:	7942                	ld	s2,48(sp)
    80001b82:	79a2                	ld	s3,40(sp)
    80001b84:	7a02                	ld	s4,32(sp)
    80001b86:	6ae2                	ld	s5,24(sp)
    80001b88:	6b42                	ld	s6,16(sp)
    80001b8a:	6ba2                	ld	s7,8(sp)
    80001b8c:	6161                	addi	sp,sp,80
    80001b8e:	8082                	ret

0000000080001b90 <pgaccess>:

//新添加的函数
uint64 pgaccess(void* pg, int number, void* store) {
    80001b90:	711d                	addi	sp,sp,-96
    80001b92:	ec86                	sd	ra,88(sp)
    80001b94:	e8a2                	sd	s0,80(sp)
    80001b96:	e4a6                	sd	s1,72(sp)
    80001b98:	e0ca                	sd	s2,64(sp)
    80001b9a:	fc4e                	sd	s3,56(sp)
    80001b9c:	f852                	sd	s4,48(sp)
    80001b9e:	f456                	sd	s5,40(sp)
    80001ba0:	f05a                	sd	s6,32(sp)
    80001ba2:	ec5e                	sd	s7,24(sp)
    80001ba4:	1080                	addi	s0,sp,96
    80001ba6:	84aa                	mv	s1,a0
    80001ba8:	89ae                	mv	s3,a1
    80001baa:	8b32                	mv	s6,a2
  struct proc* p = myproc();
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	372080e7          	jalr	882(ra) # 80000f1e <myproc>
  if (p == 0) {
    80001bb4:	c93d                	beqz	a0,80001c2a <pgaccess+0x9a>
    return 1;
  }
  pagetable_t pagetable = p->pagetable;
    80001bb6:	05853a03          	ld	s4,88(a0)
  int ans = 0;
    80001bba:	fa042623          	sw	zero,-84(s0)
  for (int i = 0; i < number; i++) {
    80001bbe:	05305263          	blez	s3,80001c02 <pgaccess+0x72>
    80001bc2:	4901                	li	s2,0
    pte_t* pte;
    pte = walk(pagetable, ((uint64)pg) + (uint64)PGSIZE * i, 0);
    if (pte != 0 && ((*pte) & PTE_A)) {
      ans |= 1 << i;
    80001bc4:	4b85                	li	s7,1
    80001bc6:	6a85                	lui	s5,0x1
    80001bc8:	a029                	j	80001bd2 <pgaccess+0x42>
  for (int i = 0; i < number; i++) {
    80001bca:	2905                	addiw	s2,s2,1
    80001bcc:	94d6                	add	s1,s1,s5
    80001bce:	03298a63          	beq	s3,s2,80001c02 <pgaccess+0x72>
    pte = walk(pagetable, ((uint64)pg) + (uint64)PGSIZE * i, 0);
    80001bd2:	4601                	li	a2,0
    80001bd4:	85a6                	mv	a1,s1
    80001bd6:	8552                	mv	a0,s4
    80001bd8:	fffff097          	auipc	ra,0xfffff
    80001bdc:	888080e7          	jalr	-1912(ra) # 80000460 <walk>
    if (pte != 0 && ((*pte) & PTE_A)) {
    80001be0:	d56d                	beqz	a0,80001bca <pgaccess+0x3a>
    80001be2:	611c                	ld	a5,0(a0)
    80001be4:	0407f793          	andi	a5,a5,64
    80001be8:	d3ed                	beqz	a5,80001bca <pgaccess+0x3a>
      ans |= 1 << i;
    80001bea:	012b97bb          	sllw	a5,s7,s2
    80001bee:	fac42703          	lw	a4,-84(s0)
    80001bf2:	8fd9                	or	a5,a5,a4
    80001bf4:	faf42623          	sw	a5,-84(s0)
      *pte ^= PTE_A;  // clear PTE_A
    80001bf8:	611c                	ld	a5,0(a0)
    80001bfa:	0407c793          	xori	a5,a5,64
    80001bfe:	e11c                	sd	a5,0(a0)
    80001c00:	b7e9                	j	80001bca <pgaccess+0x3a>
    }
  }
  // copyout
  return copyout(pagetable, (uint64)store, (char*)&ans, sizeof(int));
    80001c02:	4691                	li	a3,4
    80001c04:	fac40613          	addi	a2,s0,-84
    80001c08:	85da                	mv	a1,s6
    80001c0a:	8552                	mv	a0,s4
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	efe080e7          	jalr	-258(ra) # 80000b0a <copyout>
}
    80001c14:	60e6                	ld	ra,88(sp)
    80001c16:	6446                	ld	s0,80(sp)
    80001c18:	64a6                	ld	s1,72(sp)
    80001c1a:	6906                	ld	s2,64(sp)
    80001c1c:	79e2                	ld	s3,56(sp)
    80001c1e:	7a42                	ld	s4,48(sp)
    80001c20:	7aa2                	ld	s5,40(sp)
    80001c22:	7b02                	ld	s6,32(sp)
    80001c24:	6be2                	ld	s7,24(sp)
    80001c26:	6125                	addi	sp,sp,96
    80001c28:	8082                	ret
    return 1;
    80001c2a:	4505                	li	a0,1
    80001c2c:	b7e5                	j	80001c14 <pgaccess+0x84>

0000000080001c2e <swtch>:
    80001c2e:	00153023          	sd	ra,0(a0)
    80001c32:	00253423          	sd	sp,8(a0)
    80001c36:	e900                	sd	s0,16(a0)
    80001c38:	ed04                	sd	s1,24(a0)
    80001c3a:	03253023          	sd	s2,32(a0)
    80001c3e:	03353423          	sd	s3,40(a0)
    80001c42:	03453823          	sd	s4,48(a0)
    80001c46:	03553c23          	sd	s5,56(a0)
    80001c4a:	05653023          	sd	s6,64(a0)
    80001c4e:	05753423          	sd	s7,72(a0)
    80001c52:	05853823          	sd	s8,80(a0)
    80001c56:	05953c23          	sd	s9,88(a0)
    80001c5a:	07a53023          	sd	s10,96(a0)
    80001c5e:	07b53423          	sd	s11,104(a0)
    80001c62:	0005b083          	ld	ra,0(a1)
    80001c66:	0085b103          	ld	sp,8(a1)
    80001c6a:	6980                	ld	s0,16(a1)
    80001c6c:	6d84                	ld	s1,24(a1)
    80001c6e:	0205b903          	ld	s2,32(a1)
    80001c72:	0285b983          	ld	s3,40(a1)
    80001c76:	0305ba03          	ld	s4,48(a1)
    80001c7a:	0385ba83          	ld	s5,56(a1)
    80001c7e:	0405bb03          	ld	s6,64(a1)
    80001c82:	0485bb83          	ld	s7,72(a1)
    80001c86:	0505bc03          	ld	s8,80(a1)
    80001c8a:	0585bc83          	ld	s9,88(a1)
    80001c8e:	0605bd03          	ld	s10,96(a1)
    80001c92:	0685bd83          	ld	s11,104(a1)
    80001c96:	8082                	ret

0000000080001c98 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c98:	1141                	addi	sp,sp,-16
    80001c9a:	e406                	sd	ra,8(sp)
    80001c9c:	e022                	sd	s0,0(sp)
    80001c9e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ca0:	00006597          	auipc	a1,0x6
    80001ca4:	61858593          	addi	a1,a1,1560 # 800082b8 <states.1727+0x30>
    80001ca8:	0000d517          	auipc	a0,0xd
    80001cac:	3d850513          	addi	a0,a0,984 # 8000f080 <tickslock>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	5d2080e7          	jalr	1490(ra) # 80006282 <initlock>
}
    80001cb8:	60a2                	ld	ra,8(sp)
    80001cba:	6402                	ld	s0,0(sp)
    80001cbc:	0141                	addi	sp,sp,16
    80001cbe:	8082                	ret

0000000080001cc0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cc0:	1141                	addi	sp,sp,-16
    80001cc2:	e422                	sd	s0,8(sp)
    80001cc4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc6:	00003797          	auipc	a5,0x3
    80001cca:	50a78793          	addi	a5,a5,1290 # 800051d0 <kernelvec>
    80001cce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cd2:	6422                	ld	s0,8(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e406                	sd	ra,8(sp)
    80001cdc:	e022                	sd	s0,0(sp)
    80001cde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	23e080e7          	jalr	574(ra) # 80000f1e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cf2:	00005617          	auipc	a2,0x5
    80001cf6:	30e60613          	addi	a2,a2,782 # 80007000 <_trampoline>
    80001cfa:	00005697          	auipc	a3,0x5
    80001cfe:	30668693          	addi	a3,a3,774 # 80007000 <_trampoline>
    80001d02:	8e91                	sub	a3,a3,a2
    80001d04:	040007b7          	lui	a5,0x4000
    80001d08:	17fd                	addi	a5,a5,-1
    80001d0a:	07b2                	slli	a5,a5,0xc
    80001d0c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d0e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d12:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d14:	180026f3          	csrr	a3,satp
    80001d18:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d1a:	7138                	ld	a4,96(a0)
    80001d1c:	6534                	ld	a3,72(a0)
    80001d1e:	6585                	lui	a1,0x1
    80001d20:	96ae                	add	a3,a3,a1
    80001d22:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d24:	7138                	ld	a4,96(a0)
    80001d26:	00000697          	auipc	a3,0x0
    80001d2a:	13868693          	addi	a3,a3,312 # 80001e5e <usertrap>
    80001d2e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d30:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d32:	8692                	mv	a3,tp
    80001d34:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d3a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d3e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d46:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d48:	6f18                	ld	a4,24(a4)
    80001d4a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d4e:	6d2c                	ld	a1,88(a0)
    80001d50:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d52:	00005717          	auipc	a4,0x5
    80001d56:	33e70713          	addi	a4,a4,830 # 80007090 <userret>
    80001d5a:	8f11                	sub	a4,a4,a2
    80001d5c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d5e:	577d                	li	a4,-1
    80001d60:	177e                	slli	a4,a4,0x3f
    80001d62:	8dd9                	or	a1,a1,a4
    80001d64:	02000537          	lui	a0,0x2000
    80001d68:	157d                	addi	a0,a0,-1
    80001d6a:	0536                	slli	a0,a0,0xd
    80001d6c:	9782                	jalr	a5
}
    80001d6e:	60a2                	ld	ra,8(sp)
    80001d70:	6402                	ld	s0,0(sp)
    80001d72:	0141                	addi	sp,sp,16
    80001d74:	8082                	ret

0000000080001d76 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d76:	1101                	addi	sp,sp,-32
    80001d78:	ec06                	sd	ra,24(sp)
    80001d7a:	e822                	sd	s0,16(sp)
    80001d7c:	e426                	sd	s1,8(sp)
    80001d7e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d80:	0000d497          	auipc	s1,0xd
    80001d84:	30048493          	addi	s1,s1,768 # 8000f080 <tickslock>
    80001d88:	8526                	mv	a0,s1
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	588080e7          	jalr	1416(ra) # 80006312 <acquire>
  ticks++;
    80001d92:	00007517          	auipc	a0,0x7
    80001d96:	28650513          	addi	a0,a0,646 # 80009018 <ticks>
    80001d9a:	411c                	lw	a5,0(a0)
    80001d9c:	2785                	addiw	a5,a5,1
    80001d9e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	a7e080e7          	jalr	-1410(ra) # 8000181e <wakeup>
  release(&tickslock);
    80001da8:	8526                	mv	a0,s1
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	61c080e7          	jalr	1564(ra) # 800063c6 <release>
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret

0000000080001dbc <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001dbc:	1101                	addi	sp,sp,-32
    80001dbe:	ec06                	sd	ra,24(sp)
    80001dc0:	e822                	sd	s0,16(sp)
    80001dc2:	e426                	sd	s1,8(sp)
    80001dc4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dca:	00074d63          	bltz	a4,80001de4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dce:	57fd                	li	a5,-1
    80001dd0:	17fe                	slli	a5,a5,0x3f
    80001dd2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dd4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dd6:	06f70363          	beq	a4,a5,80001e3c <devintr+0x80>
  }
}
    80001dda:	60e2                	ld	ra,24(sp)
    80001ddc:	6442                	ld	s0,16(sp)
    80001dde:	64a2                	ld	s1,8(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret
     (scause & 0xff) == 9){
    80001de4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001de8:	46a5                	li	a3,9
    80001dea:	fed792e3          	bne	a5,a3,80001dce <devintr+0x12>
    int irq = plic_claim();
    80001dee:	00003097          	auipc	ra,0x3
    80001df2:	4ea080e7          	jalr	1258(ra) # 800052d8 <plic_claim>
    80001df6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001df8:	47a9                	li	a5,10
    80001dfa:	02f50763          	beq	a0,a5,80001e28 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dfe:	4785                	li	a5,1
    80001e00:	02f50963          	beq	a0,a5,80001e32 <devintr+0x76>
    return 1;
    80001e04:	4505                	li	a0,1
    } else if(irq){
    80001e06:	d8f1                	beqz	s1,80001dda <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e08:	85a6                	mv	a1,s1
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	4b650513          	addi	a0,a0,1206 # 800082c0 <states.1727+0x38>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	000080e7          	jalr	ra # 80005e12 <printf>
      plic_complete(irq);
    80001e1a:	8526                	mv	a0,s1
    80001e1c:	00003097          	auipc	ra,0x3
    80001e20:	4e0080e7          	jalr	1248(ra) # 800052fc <plic_complete>
    return 1;
    80001e24:	4505                	li	a0,1
    80001e26:	bf55                	j	80001dda <devintr+0x1e>
      uartintr();
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	40a080e7          	jalr	1034(ra) # 80006232 <uartintr>
    80001e30:	b7ed                	j	80001e1a <devintr+0x5e>
      virtio_disk_intr();
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	9aa080e7          	jalr	-1622(ra) # 800057dc <virtio_disk_intr>
    80001e3a:	b7c5                	j	80001e1a <devintr+0x5e>
    if(cpuid() == 0){
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	0b6080e7          	jalr	182(ra) # 80000ef2 <cpuid>
    80001e44:	c901                	beqz	a0,80001e54 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e46:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e4a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e4c:	14479073          	csrw	sip,a5
    return 2;
    80001e50:	4509                	li	a0,2
    80001e52:	b761                	j	80001dda <devintr+0x1e>
      clockintr();
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	f22080e7          	jalr	-222(ra) # 80001d76 <clockintr>
    80001e5c:	b7ed                	j	80001e46 <devintr+0x8a>

0000000080001e5e <usertrap>:
{
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	e04a                	sd	s2,0(sp)
    80001e68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e6e:	1007f793          	andi	a5,a5,256
    80001e72:	e3ad                	bnez	a5,80001ed4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e74:	00003797          	auipc	a5,0x3
    80001e78:	35c78793          	addi	a5,a5,860 # 800051d0 <kernelvec>
    80001e7c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	09e080e7          	jalr	158(ra) # 80000f1e <myproc>
    80001e88:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e8a:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8c:	14102773          	csrr	a4,sepc
    80001e90:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e92:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e96:	47a1                	li	a5,8
    80001e98:	04f71c63          	bne	a4,a5,80001ef0 <usertrap+0x92>
    if(p->killed)
    80001e9c:	591c                	lw	a5,48(a0)
    80001e9e:	e3b9                	bnez	a5,80001ee4 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001ea0:	70b8                	ld	a4,96(s1)
    80001ea2:	6f1c                	ld	a5,24(a4)
    80001ea4:	0791                	addi	a5,a5,4
    80001ea6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eac:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb0:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	2e0080e7          	jalr	736(ra) # 80002194 <syscall>
  if(p->killed)
    80001ebc:	589c                	lw	a5,48(s1)
    80001ebe:	ebc1                	bnez	a5,80001f4e <usertrap+0xf0>
  usertrapret();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	e18080e7          	jalr	-488(ra) # 80001cd8 <usertrapret>
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6902                	ld	s2,0(sp)
    80001ed0:	6105                	addi	sp,sp,32
    80001ed2:	8082                	ret
    panic("usertrap: not from user mode");
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	40c50513          	addi	a0,a0,1036 # 800082e0 <states.1727+0x58>
    80001edc:	00004097          	auipc	ra,0x4
    80001ee0:	eec080e7          	jalr	-276(ra) # 80005dc8 <panic>
      exit(-1);
    80001ee4:	557d                	li	a0,-1
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	a08080e7          	jalr	-1528(ra) # 800018ee <exit>
    80001eee:	bf4d                	j	80001ea0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	ecc080e7          	jalr	-308(ra) # 80001dbc <devintr>
    80001ef8:	892a                	mv	s2,a0
    80001efa:	c501                	beqz	a0,80001f02 <usertrap+0xa4>
  if(p->killed)
    80001efc:	589c                	lw	a5,48(s1)
    80001efe:	c3a1                	beqz	a5,80001f3e <usertrap+0xe0>
    80001f00:	a815                	j	80001f34 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f02:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f06:	5c90                	lw	a2,56(s1)
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	3f850513          	addi	a0,a0,1016 # 80008300 <states.1727+0x78>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	f02080e7          	jalr	-254(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f1c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	41050513          	addi	a0,a0,1040 # 80008330 <states.1727+0xa8>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	eea080e7          	jalr	-278(ra) # 80005e12 <printf>
    p->killed = 1;
    80001f30:	4785                	li	a5,1
    80001f32:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001f34:	557d                	li	a0,-1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	9b8080e7          	jalr	-1608(ra) # 800018ee <exit>
  if(which_dev == 2)
    80001f3e:	4789                	li	a5,2
    80001f40:	f8f910e3          	bne	s2,a5,80001ec0 <usertrap+0x62>
    yield();
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	712080e7          	jalr	1810(ra) # 80001656 <yield>
    80001f4c:	bf95                	j	80001ec0 <usertrap+0x62>
  int which_dev = 0;
    80001f4e:	4901                	li	s2,0
    80001f50:	b7d5                	j	80001f34 <usertrap+0xd6>

0000000080001f52 <kerneltrap>:
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	ec26                	sd	s1,24(sp)
    80001f5a:	e84a                	sd	s2,16(sp)
    80001f5c:	e44e                	sd	s3,8(sp)
    80001f5e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f60:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f64:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f68:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f6c:	1004f793          	andi	a5,s1,256
    80001f70:	cb85                	beqz	a5,80001fa0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f72:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f76:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f78:	ef85                	bnez	a5,80001fb0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f7a:	00000097          	auipc	ra,0x0
    80001f7e:	e42080e7          	jalr	-446(ra) # 80001dbc <devintr>
    80001f82:	cd1d                	beqz	a0,80001fc0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f84:	4789                	li	a5,2
    80001f86:	06f50a63          	beq	a0,a5,80001ffa <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f8a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8e:	10049073          	csrw	sstatus,s1
}
    80001f92:	70a2                	ld	ra,40(sp)
    80001f94:	7402                	ld	s0,32(sp)
    80001f96:	64e2                	ld	s1,24(sp)
    80001f98:	6942                	ld	s2,16(sp)
    80001f9a:	69a2                	ld	s3,8(sp)
    80001f9c:	6145                	addi	sp,sp,48
    80001f9e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	3b050513          	addi	a0,a0,944 # 80008350 <states.1727+0xc8>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	e20080e7          	jalr	-480(ra) # 80005dc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	3c850513          	addi	a0,a0,968 # 80008378 <states.1727+0xf0>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	e10080e7          	jalr	-496(ra) # 80005dc8 <panic>
    printf("scause %p\n", scause);
    80001fc0:	85ce                	mv	a1,s3
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	3d650513          	addi	a0,a0,982 # 80008398 <states.1727+0x110>
    80001fca:	00004097          	auipc	ra,0x4
    80001fce:	e48080e7          	jalr	-440(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fd6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fda:	00006517          	auipc	a0,0x6
    80001fde:	3ce50513          	addi	a0,a0,974 # 800083a8 <states.1727+0x120>
    80001fe2:	00004097          	auipc	ra,0x4
    80001fe6:	e30080e7          	jalr	-464(ra) # 80005e12 <printf>
    panic("kerneltrap");
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	3d650513          	addi	a0,a0,982 # 800083c0 <states.1727+0x138>
    80001ff2:	00004097          	auipc	ra,0x4
    80001ff6:	dd6080e7          	jalr	-554(ra) # 80005dc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	f24080e7          	jalr	-220(ra) # 80000f1e <myproc>
    80002002:	d541                	beqz	a0,80001f8a <kerneltrap+0x38>
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	f1a080e7          	jalr	-230(ra) # 80000f1e <myproc>
    8000200c:	5118                	lw	a4,32(a0)
    8000200e:	4791                	li	a5,4
    80002010:	f6f71de3          	bne	a4,a5,80001f8a <kerneltrap+0x38>
    yield();
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	642080e7          	jalr	1602(ra) # 80001656 <yield>
    8000201c:	b7bd                	j	80001f8a <kerneltrap+0x38>

000000008000201e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000201e:	1101                	addi	sp,sp,-32
    80002020:	ec06                	sd	ra,24(sp)
    80002022:	e822                	sd	s0,16(sp)
    80002024:	e426                	sd	s1,8(sp)
    80002026:	1000                	addi	s0,sp,32
    80002028:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	ef4080e7          	jalr	-268(ra) # 80000f1e <myproc>
  switch (n) {
    80002032:	4795                	li	a5,5
    80002034:	0497e163          	bltu	a5,s1,80002076 <argraw+0x58>
    80002038:	048a                	slli	s1,s1,0x2
    8000203a:	00006717          	auipc	a4,0x6
    8000203e:	3be70713          	addi	a4,a4,958 # 800083f8 <states.1727+0x170>
    80002042:	94ba                	add	s1,s1,a4
    80002044:	409c                	lw	a5,0(s1)
    80002046:	97ba                	add	a5,a5,a4
    80002048:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000204a:	713c                	ld	a5,96(a0)
    8000204c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret
    return p->trapframe->a1;
    80002058:	713c                	ld	a5,96(a0)
    8000205a:	7fa8                	ld	a0,120(a5)
    8000205c:	bfcd                	j	8000204e <argraw+0x30>
    return p->trapframe->a2;
    8000205e:	713c                	ld	a5,96(a0)
    80002060:	63c8                	ld	a0,128(a5)
    80002062:	b7f5                	j	8000204e <argraw+0x30>
    return p->trapframe->a3;
    80002064:	713c                	ld	a5,96(a0)
    80002066:	67c8                	ld	a0,136(a5)
    80002068:	b7dd                	j	8000204e <argraw+0x30>
    return p->trapframe->a4;
    8000206a:	713c                	ld	a5,96(a0)
    8000206c:	6bc8                	ld	a0,144(a5)
    8000206e:	b7c5                	j	8000204e <argraw+0x30>
    return p->trapframe->a5;
    80002070:	713c                	ld	a5,96(a0)
    80002072:	6fc8                	ld	a0,152(a5)
    80002074:	bfe9                	j	8000204e <argraw+0x30>
  panic("argraw");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	35a50513          	addi	a0,a0,858 # 800083d0 <states.1727+0x148>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	d4a080e7          	jalr	-694(ra) # 80005dc8 <panic>

0000000080002086 <fetchaddr>:
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	e04a                	sd	s2,0(sp)
    80002090:	1000                	addi	s0,sp,32
    80002092:	84aa                	mv	s1,a0
    80002094:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	e88080e7          	jalr	-376(ra) # 80000f1e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000209e:	693c                	ld	a5,80(a0)
    800020a0:	02f4f863          	bgeu	s1,a5,800020d0 <fetchaddr+0x4a>
    800020a4:	00848713          	addi	a4,s1,8
    800020a8:	02e7e663          	bltu	a5,a4,800020d4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020ac:	46a1                	li	a3,8
    800020ae:	8626                	mv	a2,s1
    800020b0:	85ca                	mv	a1,s2
    800020b2:	6d28                	ld	a0,88(a0)
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	ae2080e7          	jalr	-1310(ra) # 80000b96 <copyin>
    800020bc:	00a03533          	snez	a0,a0
    800020c0:	40a00533          	neg	a0,a0
}
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	64a2                	ld	s1,8(sp)
    800020ca:	6902                	ld	s2,0(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret
    return -1;
    800020d0:	557d                	li	a0,-1
    800020d2:	bfcd                	j	800020c4 <fetchaddr+0x3e>
    800020d4:	557d                	li	a0,-1
    800020d6:	b7fd                	j	800020c4 <fetchaddr+0x3e>

00000000800020d8 <fetchstr>:
{
    800020d8:	7179                	addi	sp,sp,-48
    800020da:	f406                	sd	ra,40(sp)
    800020dc:	f022                	sd	s0,32(sp)
    800020de:	ec26                	sd	s1,24(sp)
    800020e0:	e84a                	sd	s2,16(sp)
    800020e2:	e44e                	sd	s3,8(sp)
    800020e4:	1800                	addi	s0,sp,48
    800020e6:	892a                	mv	s2,a0
    800020e8:	84ae                	mv	s1,a1
    800020ea:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	e32080e7          	jalr	-462(ra) # 80000f1e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020f4:	86ce                	mv	a3,s3
    800020f6:	864a                	mv	a2,s2
    800020f8:	85a6                	mv	a1,s1
    800020fa:	6d28                	ld	a0,88(a0)
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	b26080e7          	jalr	-1242(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002104:	00054763          	bltz	a0,80002112 <fetchstr+0x3a>
  return strlen(buf);
    80002108:	8526                	mv	a0,s1
    8000210a:	ffffe097          	auipc	ra,0xffffe
    8000210e:	1f2080e7          	jalr	498(ra) # 800002fc <strlen>
}
    80002112:	70a2                	ld	ra,40(sp)
    80002114:	7402                	ld	s0,32(sp)
    80002116:	64e2                	ld	s1,24(sp)
    80002118:	6942                	ld	s2,16(sp)
    8000211a:	69a2                	ld	s3,8(sp)
    8000211c:	6145                	addi	sp,sp,48
    8000211e:	8082                	ret

0000000080002120 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	1000                	addi	s0,sp,32
    8000212a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000212c:	00000097          	auipc	ra,0x0
    80002130:	ef2080e7          	jalr	-270(ra) # 8000201e <argraw>
    80002134:	c088                	sw	a0,0(s1)
  return 0;
}
    80002136:	4501                	li	a0,0
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	1000                	addi	s0,sp,32
    8000214c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	ed0080e7          	jalr	-304(ra) # 8000201e <argraw>
    80002156:	e088                	sd	a0,0(s1)
  return 0;
}
    80002158:	4501                	li	a0,0
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	e426                	sd	s1,8(sp)
    8000216c:	e04a                	sd	s2,0(sp)
    8000216e:	1000                	addi	s0,sp,32
    80002170:	84ae                	mv	s1,a1
    80002172:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002174:	00000097          	auipc	ra,0x0
    80002178:	eaa080e7          	jalr	-342(ra) # 8000201e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000217c:	864a                	mv	a2,s2
    8000217e:	85a6                	mv	a1,s1
    80002180:	00000097          	auipc	ra,0x0
    80002184:	f58080e7          	jalr	-168(ra) # 800020d8 <fetchstr>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6902                	ld	s2,0(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <syscall>:



void
syscall(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	e04a                	sd	s2,0(sp)
    8000219e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	d7e080e7          	jalr	-642(ra) # 80000f1e <myproc>
    800021a8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021aa:	06053903          	ld	s2,96(a0)
    800021ae:	0a893783          	ld	a5,168(s2)
    800021b2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021b6:	37fd                	addiw	a5,a5,-1
    800021b8:	4775                	li	a4,29
    800021ba:	00f76f63          	bltu	a4,a5,800021d8 <syscall+0x44>
    800021be:	00369713          	slli	a4,a3,0x3
    800021c2:	00006797          	auipc	a5,0x6
    800021c6:	24e78793          	addi	a5,a5,590 # 80008410 <syscalls>
    800021ca:	97ba                	add	a5,a5,a4
    800021cc:	639c                	ld	a5,0(a5)
    800021ce:	c789                	beqz	a5,800021d8 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021d0:	9782                	jalr	a5
    800021d2:	06a93823          	sd	a0,112(s2)
    800021d6:	a839                	j	800021f4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021d8:	16048613          	addi	a2,s1,352
    800021dc:	5c8c                	lw	a1,56(s1)
    800021de:	00006517          	auipc	a0,0x6
    800021e2:	1fa50513          	addi	a0,a0,506 # 800083d8 <states.1727+0x150>
    800021e6:	00004097          	auipc	ra,0x4
    800021ea:	c2c080e7          	jalr	-980(ra) # 80005e12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021ee:	70bc                	ld	a5,96(s1)
    800021f0:	577d                	li	a4,-1
    800021f2:	fbb8                	sd	a4,112(a5)
  }
}
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6902                	ld	s2,0(sp)
    800021fc:	6105                	addi	sp,sp,32
    800021fe:	8082                	ret

0000000080002200 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002200:	1101                	addi	sp,sp,-32
    80002202:	ec06                	sd	ra,24(sp)
    80002204:	e822                	sd	s0,16(sp)
    80002206:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002208:	fec40593          	addi	a1,s0,-20
    8000220c:	4501                	li	a0,0
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	f12080e7          	jalr	-238(ra) # 80002120 <argint>
    return -1;
    80002216:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002218:	00054963          	bltz	a0,8000222a <sys_exit+0x2a>
  exit(n);
    8000221c:	fec42503          	lw	a0,-20(s0)
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	6ce080e7          	jalr	1742(ra) # 800018ee <exit>
  return 0;  // not reached
    80002228:	4781                	li	a5,0
}
    8000222a:	853e                	mv	a0,a5
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret

0000000080002234 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002234:	1141                	addi	sp,sp,-16
    80002236:	e406                	sd	ra,8(sp)
    80002238:	e022                	sd	s0,0(sp)
    8000223a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	ce2080e7          	jalr	-798(ra) # 80000f1e <myproc>
}
    80002244:	5d08                	lw	a0,56(a0)
    80002246:	60a2                	ld	ra,8(sp)
    80002248:	6402                	ld	s0,0(sp)
    8000224a:	0141                	addi	sp,sp,16
    8000224c:	8082                	ret

000000008000224e <sys_fork>:

uint64
sys_fork(void)
{
    8000224e:	1141                	addi	sp,sp,-16
    80002250:	e406                	sd	ra,8(sp)
    80002252:	e022                	sd	s0,0(sp)
    80002254:	0800                	addi	s0,sp,16
  return fork();
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	14e080e7          	jalr	334(ra) # 800013a4 <fork>
}
    8000225e:	60a2                	ld	ra,8(sp)
    80002260:	6402                	ld	s0,0(sp)
    80002262:	0141                	addi	sp,sp,16
    80002264:	8082                	ret

0000000080002266 <sys_wait>:

uint64
sys_wait(void)
{
    80002266:	1101                	addi	sp,sp,-32
    80002268:	ec06                	sd	ra,24(sp)
    8000226a:	e822                	sd	s0,16(sp)
    8000226c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000226e:	fe840593          	addi	a1,s0,-24
    80002272:	4501                	li	a0,0
    80002274:	00000097          	auipc	ra,0x0
    80002278:	ece080e7          	jalr	-306(ra) # 80002142 <argaddr>
    8000227c:	87aa                	mv	a5,a0
    return -1;
    8000227e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002280:	0007c863          	bltz	a5,80002290 <sys_wait+0x2a>
  return wait(p);
    80002284:	fe843503          	ld	a0,-24(s0)
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	46e080e7          	jalr	1134(ra) # 800016f6 <wait>
}
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002298:	7179                	addi	sp,sp,-48
    8000229a:	f406                	sd	ra,40(sp)
    8000229c:	f022                	sd	s0,32(sp)
    8000229e:	ec26                	sd	s1,24(sp)
    800022a0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022a2:	fdc40593          	addi	a1,s0,-36
    800022a6:	4501                	li	a0,0
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	e78080e7          	jalr	-392(ra) # 80002120 <argint>
    800022b0:	87aa                	mv	a5,a0
    return -1;
    800022b2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022b4:	0207c063          	bltz	a5,800022d4 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	c66080e7          	jalr	-922(ra) # 80000f1e <myproc>
    800022c0:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800022c2:	fdc42503          	lw	a0,-36(s0)
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	06a080e7          	jalr	106(ra) # 80001330 <growproc>
    800022ce:	00054863          	bltz	a0,800022de <sys_sbrk+0x46>
    return -1;
  return addr;
    800022d2:	8526                	mv	a0,s1
}
    800022d4:	70a2                	ld	ra,40(sp)
    800022d6:	7402                	ld	s0,32(sp)
    800022d8:	64e2                	ld	s1,24(sp)
    800022da:	6145                	addi	sp,sp,48
    800022dc:	8082                	ret
    return -1;
    800022de:	557d                	li	a0,-1
    800022e0:	bfd5                	j	800022d4 <sys_sbrk+0x3c>

00000000800022e2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022e2:	7139                	addi	sp,sp,-64
    800022e4:	fc06                	sd	ra,56(sp)
    800022e6:	f822                	sd	s0,48(sp)
    800022e8:	f426                	sd	s1,40(sp)
    800022ea:	f04a                	sd	s2,32(sp)
    800022ec:	ec4e                	sd	s3,24(sp)
    800022ee:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    800022f0:	fcc40593          	addi	a1,s0,-52
    800022f4:	4501                	li	a0,0
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	e2a080e7          	jalr	-470(ra) # 80002120 <argint>
    return -1;
    800022fe:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002300:	06054563          	bltz	a0,8000236a <sys_sleep+0x88>
  acquire(&tickslock);
    80002304:	0000d517          	auipc	a0,0xd
    80002308:	d7c50513          	addi	a0,a0,-644 # 8000f080 <tickslock>
    8000230c:	00004097          	auipc	ra,0x4
    80002310:	006080e7          	jalr	6(ra) # 80006312 <acquire>
  ticks0 = ticks;
    80002314:	00007917          	auipc	s2,0x7
    80002318:	d0492903          	lw	s2,-764(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000231c:	fcc42783          	lw	a5,-52(s0)
    80002320:	cf85                	beqz	a5,80002358 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002322:	0000d997          	auipc	s3,0xd
    80002326:	d5e98993          	addi	s3,s3,-674 # 8000f080 <tickslock>
    8000232a:	00007497          	auipc	s1,0x7
    8000232e:	cee48493          	addi	s1,s1,-786 # 80009018 <ticks>
    if(myproc()->killed){
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	bec080e7          	jalr	-1044(ra) # 80000f1e <myproc>
    8000233a:	591c                	lw	a5,48(a0)
    8000233c:	ef9d                	bnez	a5,8000237a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000233e:	85ce                	mv	a1,s3
    80002340:	8526                	mv	a0,s1
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	350080e7          	jalr	848(ra) # 80001692 <sleep>
  while(ticks - ticks0 < n){
    8000234a:	409c                	lw	a5,0(s1)
    8000234c:	412787bb          	subw	a5,a5,s2
    80002350:	fcc42703          	lw	a4,-52(s0)
    80002354:	fce7efe3          	bltu	a5,a4,80002332 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002358:	0000d517          	auipc	a0,0xd
    8000235c:	d2850513          	addi	a0,a0,-728 # 8000f080 <tickslock>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	066080e7          	jalr	102(ra) # 800063c6 <release>
  return 0;
    80002368:	4781                	li	a5,0
}
    8000236a:	853e                	mv	a0,a5
    8000236c:	70e2                	ld	ra,56(sp)
    8000236e:	7442                	ld	s0,48(sp)
    80002370:	74a2                	ld	s1,40(sp)
    80002372:	7902                	ld	s2,32(sp)
    80002374:	69e2                	ld	s3,24(sp)
    80002376:	6121                	addi	sp,sp,64
    80002378:	8082                	ret
      release(&tickslock);
    8000237a:	0000d517          	auipc	a0,0xd
    8000237e:	d0650513          	addi	a0,a0,-762 # 8000f080 <tickslock>
    80002382:	00004097          	auipc	ra,0x4
    80002386:	044080e7          	jalr	68(ra) # 800063c6 <release>
      return -1;
    8000238a:	57fd                	li	a5,-1
    8000238c:	bff9                	j	8000236a <sys_sleep+0x88>

000000008000238e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000238e:	7179                	addi	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	1800                	addi	s0,sp,48
  // lab pgtbl: your code here.
  uint64 buf;
  int number;
  uint64 ans;
  if (argaddr(0, &buf) < 0) return -1;
    80002396:	fe840593          	addi	a1,s0,-24
    8000239a:	4501                	li	a0,0
    8000239c:	00000097          	auipc	ra,0x0
    800023a0:	da6080e7          	jalr	-602(ra) # 80002142 <argaddr>
    800023a4:	04054363          	bltz	a0,800023ea <sys_pgaccess+0x5c>
  if (argint(1, &number) < 0) return -1;
    800023a8:	fe440593          	addi	a1,s0,-28
    800023ac:	4505                	li	a0,1
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	d72080e7          	jalr	-654(ra) # 80002120 <argint>
    800023b6:	02054c63          	bltz	a0,800023ee <sys_pgaccess+0x60>
  if (argaddr(2, &ans) < 0) return -1;
    800023ba:	fd840593          	addi	a1,s0,-40
    800023be:	4509                	li	a0,2
    800023c0:	00000097          	auipc	ra,0x0
    800023c4:	d82080e7          	jalr	-638(ra) # 80002142 <argaddr>
    800023c8:	02054563          	bltz	a0,800023f2 <sys_pgaccess+0x64>
  return pgaccess((void*)buf, number, (void*)ans);
    800023cc:	fd843603          	ld	a2,-40(s0)
    800023d0:	fe442583          	lw	a1,-28(s0)
    800023d4:	fe843503          	ld	a0,-24(s0)
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	7b8080e7          	jalr	1976(ra) # 80001b90 <pgaccess>
    800023e0:	2501                	sext.w	a0,a0
}
    800023e2:	70a2                	ld	ra,40(sp)
    800023e4:	7402                	ld	s0,32(sp)
    800023e6:	6145                	addi	sp,sp,48
    800023e8:	8082                	ret
  if (argaddr(0, &buf) < 0) return -1;
    800023ea:	557d                	li	a0,-1
    800023ec:	bfdd                	j	800023e2 <sys_pgaccess+0x54>
  if (argint(1, &number) < 0) return -1;
    800023ee:	557d                	li	a0,-1
    800023f0:	bfcd                	j	800023e2 <sys_pgaccess+0x54>
  if (argaddr(2, &ans) < 0) return -1;
    800023f2:	557d                	li	a0,-1
    800023f4:	b7fd                	j	800023e2 <sys_pgaccess+0x54>

00000000800023f6 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800023f6:	1101                	addi	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023fe:	fec40593          	addi	a1,s0,-20
    80002402:	4501                	li	a0,0
    80002404:	00000097          	auipc	ra,0x0
    80002408:	d1c080e7          	jalr	-740(ra) # 80002120 <argint>
    8000240c:	87aa                	mv	a5,a0
    return -1;
    8000240e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002410:	0007c863          	bltz	a5,80002420 <sys_kill+0x2a>
  return kill(pid);
    80002414:	fec42503          	lw	a0,-20(s0)
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	5ac080e7          	jalr	1452(ra) # 800019c4 <kill>
}
    80002420:	60e2                	ld	ra,24(sp)
    80002422:	6442                	ld	s0,16(sp)
    80002424:	6105                	addi	sp,sp,32
    80002426:	8082                	ret

0000000080002428 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002432:	0000d517          	auipc	a0,0xd
    80002436:	c4e50513          	addi	a0,a0,-946 # 8000f080 <tickslock>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	ed8080e7          	jalr	-296(ra) # 80006312 <acquire>
  xticks = ticks;
    80002442:	00007497          	auipc	s1,0x7
    80002446:	bd64a483          	lw	s1,-1066(s1) # 80009018 <ticks>
  release(&tickslock);
    8000244a:	0000d517          	auipc	a0,0xd
    8000244e:	c3650513          	addi	a0,a0,-970 # 8000f080 <tickslock>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	f74080e7          	jalr	-140(ra) # 800063c6 <release>
  return xticks;
}
    8000245a:	02049513          	slli	a0,s1,0x20
    8000245e:	9101                	srli	a0,a0,0x20
    80002460:	60e2                	ld	ra,24(sp)
    80002462:	6442                	ld	s0,16(sp)
    80002464:	64a2                	ld	s1,8(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret

000000008000246a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	e052                	sd	s4,0(sp)
    80002478:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000247a:	00006597          	auipc	a1,0x6
    8000247e:	08e58593          	addi	a1,a1,142 # 80008508 <syscalls+0xf8>
    80002482:	0000d517          	auipc	a0,0xd
    80002486:	c1650513          	addi	a0,a0,-1002 # 8000f098 <bcache>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	df8080e7          	jalr	-520(ra) # 80006282 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002492:	00015797          	auipc	a5,0x15
    80002496:	c0678793          	addi	a5,a5,-1018 # 80017098 <bcache+0x8000>
    8000249a:	00015717          	auipc	a4,0x15
    8000249e:	e6670713          	addi	a4,a4,-410 # 80017300 <bcache+0x8268>
    800024a2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024a6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024aa:	0000d497          	auipc	s1,0xd
    800024ae:	c0648493          	addi	s1,s1,-1018 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024b2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024b4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024b6:	00006a17          	auipc	s4,0x6
    800024ba:	05aa0a13          	addi	s4,s4,90 # 80008510 <syscalls+0x100>
    b->next = bcache.head.next;
    800024be:	2b893783          	ld	a5,696(s2)
    800024c2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024c4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024c8:	85d2                	mv	a1,s4
    800024ca:	01048513          	addi	a0,s1,16
    800024ce:	00001097          	auipc	ra,0x1
    800024d2:	4bc080e7          	jalr	1212(ra) # 8000398a <initsleeplock>
    bcache.head.next->prev = b;
    800024d6:	2b893783          	ld	a5,696(s2)
    800024da:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024dc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024e0:	45848493          	addi	s1,s1,1112
    800024e4:	fd349de3          	bne	s1,s3,800024be <binit+0x54>
  }
}
    800024e8:	70a2                	ld	ra,40(sp)
    800024ea:	7402                	ld	s0,32(sp)
    800024ec:	64e2                	ld	s1,24(sp)
    800024ee:	6942                	ld	s2,16(sp)
    800024f0:	69a2                	ld	s3,8(sp)
    800024f2:	6a02                	ld	s4,0(sp)
    800024f4:	6145                	addi	sp,sp,48
    800024f6:	8082                	ret

00000000800024f8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024f8:	7179                	addi	sp,sp,-48
    800024fa:	f406                	sd	ra,40(sp)
    800024fc:	f022                	sd	s0,32(sp)
    800024fe:	ec26                	sd	s1,24(sp)
    80002500:	e84a                	sd	s2,16(sp)
    80002502:	e44e                	sd	s3,8(sp)
    80002504:	1800                	addi	s0,sp,48
    80002506:	89aa                	mv	s3,a0
    80002508:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000250a:	0000d517          	auipc	a0,0xd
    8000250e:	b8e50513          	addi	a0,a0,-1138 # 8000f098 <bcache>
    80002512:	00004097          	auipc	ra,0x4
    80002516:	e00080e7          	jalr	-512(ra) # 80006312 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000251a:	00015497          	auipc	s1,0x15
    8000251e:	e364b483          	ld	s1,-458(s1) # 80017350 <bcache+0x82b8>
    80002522:	00015797          	auipc	a5,0x15
    80002526:	dde78793          	addi	a5,a5,-546 # 80017300 <bcache+0x8268>
    8000252a:	02f48f63          	beq	s1,a5,80002568 <bread+0x70>
    8000252e:	873e                	mv	a4,a5
    80002530:	a021                	j	80002538 <bread+0x40>
    80002532:	68a4                	ld	s1,80(s1)
    80002534:	02e48a63          	beq	s1,a4,80002568 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002538:	449c                	lw	a5,8(s1)
    8000253a:	ff379ce3          	bne	a5,s3,80002532 <bread+0x3a>
    8000253e:	44dc                	lw	a5,12(s1)
    80002540:	ff2799e3          	bne	a5,s2,80002532 <bread+0x3a>
      b->refcnt++;
    80002544:	40bc                	lw	a5,64(s1)
    80002546:	2785                	addiw	a5,a5,1
    80002548:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000254a:	0000d517          	auipc	a0,0xd
    8000254e:	b4e50513          	addi	a0,a0,-1202 # 8000f098 <bcache>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	e74080e7          	jalr	-396(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    8000255a:	01048513          	addi	a0,s1,16
    8000255e:	00001097          	auipc	ra,0x1
    80002562:	466080e7          	jalr	1126(ra) # 800039c4 <acquiresleep>
      return b;
    80002566:	a8b9                	j	800025c4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002568:	00015497          	auipc	s1,0x15
    8000256c:	de04b483          	ld	s1,-544(s1) # 80017348 <bcache+0x82b0>
    80002570:	00015797          	auipc	a5,0x15
    80002574:	d9078793          	addi	a5,a5,-624 # 80017300 <bcache+0x8268>
    80002578:	00f48863          	beq	s1,a5,80002588 <bread+0x90>
    8000257c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000257e:	40bc                	lw	a5,64(s1)
    80002580:	cf81                	beqz	a5,80002598 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002582:	64a4                	ld	s1,72(s1)
    80002584:	fee49de3          	bne	s1,a4,8000257e <bread+0x86>
  panic("bget: no buffers");
    80002588:	00006517          	auipc	a0,0x6
    8000258c:	f9050513          	addi	a0,a0,-112 # 80008518 <syscalls+0x108>
    80002590:	00004097          	auipc	ra,0x4
    80002594:	838080e7          	jalr	-1992(ra) # 80005dc8 <panic>
      b->dev = dev;
    80002598:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000259c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025a0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025a4:	4785                	li	a5,1
    800025a6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a8:	0000d517          	auipc	a0,0xd
    800025ac:	af050513          	addi	a0,a0,-1296 # 8000f098 <bcache>
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	e16080e7          	jalr	-490(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    800025b8:	01048513          	addi	a0,s1,16
    800025bc:	00001097          	auipc	ra,0x1
    800025c0:	408080e7          	jalr	1032(ra) # 800039c4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025c4:	409c                	lw	a5,0(s1)
    800025c6:	cb89                	beqz	a5,800025d8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025c8:	8526                	mv	a0,s1
    800025ca:	70a2                	ld	ra,40(sp)
    800025cc:	7402                	ld	s0,32(sp)
    800025ce:	64e2                	ld	s1,24(sp)
    800025d0:	6942                	ld	s2,16(sp)
    800025d2:	69a2                	ld	s3,8(sp)
    800025d4:	6145                	addi	sp,sp,48
    800025d6:	8082                	ret
    virtio_disk_rw(b, 0);
    800025d8:	4581                	li	a1,0
    800025da:	8526                	mv	a0,s1
    800025dc:	00003097          	auipc	ra,0x3
    800025e0:	f2a080e7          	jalr	-214(ra) # 80005506 <virtio_disk_rw>
    b->valid = 1;
    800025e4:	4785                	li	a5,1
    800025e6:	c09c                	sw	a5,0(s1)
  return b;
    800025e8:	b7c5                	j	800025c8 <bread+0xd0>

00000000800025ea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025ea:	1101                	addi	sp,sp,-32
    800025ec:	ec06                	sd	ra,24(sp)
    800025ee:	e822                	sd	s0,16(sp)
    800025f0:	e426                	sd	s1,8(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025f6:	0541                	addi	a0,a0,16
    800025f8:	00001097          	auipc	ra,0x1
    800025fc:	466080e7          	jalr	1126(ra) # 80003a5e <holdingsleep>
    80002600:	cd01                	beqz	a0,80002618 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002602:	4585                	li	a1,1
    80002604:	8526                	mv	a0,s1
    80002606:	00003097          	auipc	ra,0x3
    8000260a:	f00080e7          	jalr	-256(ra) # 80005506 <virtio_disk_rw>
}
    8000260e:	60e2                	ld	ra,24(sp)
    80002610:	6442                	ld	s0,16(sp)
    80002612:	64a2                	ld	s1,8(sp)
    80002614:	6105                	addi	sp,sp,32
    80002616:	8082                	ret
    panic("bwrite");
    80002618:	00006517          	auipc	a0,0x6
    8000261c:	f1850513          	addi	a0,a0,-232 # 80008530 <syscalls+0x120>
    80002620:	00003097          	auipc	ra,0x3
    80002624:	7a8080e7          	jalr	1960(ra) # 80005dc8 <panic>

0000000080002628 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002628:	1101                	addi	sp,sp,-32
    8000262a:	ec06                	sd	ra,24(sp)
    8000262c:	e822                	sd	s0,16(sp)
    8000262e:	e426                	sd	s1,8(sp)
    80002630:	e04a                	sd	s2,0(sp)
    80002632:	1000                	addi	s0,sp,32
    80002634:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002636:	01050913          	addi	s2,a0,16
    8000263a:	854a                	mv	a0,s2
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	422080e7          	jalr	1058(ra) # 80003a5e <holdingsleep>
    80002644:	c92d                	beqz	a0,800026b6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002646:	854a                	mv	a0,s2
    80002648:	00001097          	auipc	ra,0x1
    8000264c:	3d2080e7          	jalr	978(ra) # 80003a1a <releasesleep>

  acquire(&bcache.lock);
    80002650:	0000d517          	auipc	a0,0xd
    80002654:	a4850513          	addi	a0,a0,-1464 # 8000f098 <bcache>
    80002658:	00004097          	auipc	ra,0x4
    8000265c:	cba080e7          	jalr	-838(ra) # 80006312 <acquire>
  b->refcnt--;
    80002660:	40bc                	lw	a5,64(s1)
    80002662:	37fd                	addiw	a5,a5,-1
    80002664:	0007871b          	sext.w	a4,a5
    80002668:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000266a:	eb05                	bnez	a4,8000269a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000266c:	68bc                	ld	a5,80(s1)
    8000266e:	64b8                	ld	a4,72(s1)
    80002670:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002672:	64bc                	ld	a5,72(s1)
    80002674:	68b8                	ld	a4,80(s1)
    80002676:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002678:	00015797          	auipc	a5,0x15
    8000267c:	a2078793          	addi	a5,a5,-1504 # 80017098 <bcache+0x8000>
    80002680:	2b87b703          	ld	a4,696(a5)
    80002684:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002686:	00015717          	auipc	a4,0x15
    8000268a:	c7a70713          	addi	a4,a4,-902 # 80017300 <bcache+0x8268>
    8000268e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002690:	2b87b703          	ld	a4,696(a5)
    80002694:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002696:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000269a:	0000d517          	auipc	a0,0xd
    8000269e:	9fe50513          	addi	a0,a0,-1538 # 8000f098 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	d24080e7          	jalr	-732(ra) # 800063c6 <release>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6902                	ld	s2,0(sp)
    800026b2:	6105                	addi	sp,sp,32
    800026b4:	8082                	ret
    panic("brelse");
    800026b6:	00006517          	auipc	a0,0x6
    800026ba:	e8250513          	addi	a0,a0,-382 # 80008538 <syscalls+0x128>
    800026be:	00003097          	auipc	ra,0x3
    800026c2:	70a080e7          	jalr	1802(ra) # 80005dc8 <panic>

00000000800026c6 <bpin>:

void
bpin(struct buf *b) {
    800026c6:	1101                	addi	sp,sp,-32
    800026c8:	ec06                	sd	ra,24(sp)
    800026ca:	e822                	sd	s0,16(sp)
    800026cc:	e426                	sd	s1,8(sp)
    800026ce:	1000                	addi	s0,sp,32
    800026d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026d2:	0000d517          	auipc	a0,0xd
    800026d6:	9c650513          	addi	a0,a0,-1594 # 8000f098 <bcache>
    800026da:	00004097          	auipc	ra,0x4
    800026de:	c38080e7          	jalr	-968(ra) # 80006312 <acquire>
  b->refcnt++;
    800026e2:	40bc                	lw	a5,64(s1)
    800026e4:	2785                	addiw	a5,a5,1
    800026e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026e8:	0000d517          	auipc	a0,0xd
    800026ec:	9b050513          	addi	a0,a0,-1616 # 8000f098 <bcache>
    800026f0:	00004097          	auipc	ra,0x4
    800026f4:	cd6080e7          	jalr	-810(ra) # 800063c6 <release>
}
    800026f8:	60e2                	ld	ra,24(sp)
    800026fa:	6442                	ld	s0,16(sp)
    800026fc:	64a2                	ld	s1,8(sp)
    800026fe:	6105                	addi	sp,sp,32
    80002700:	8082                	ret

0000000080002702 <bunpin>:

void
bunpin(struct buf *b) {
    80002702:	1101                	addi	sp,sp,-32
    80002704:	ec06                	sd	ra,24(sp)
    80002706:	e822                	sd	s0,16(sp)
    80002708:	e426                	sd	s1,8(sp)
    8000270a:	1000                	addi	s0,sp,32
    8000270c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000270e:	0000d517          	auipc	a0,0xd
    80002712:	98a50513          	addi	a0,a0,-1654 # 8000f098 <bcache>
    80002716:	00004097          	auipc	ra,0x4
    8000271a:	bfc080e7          	jalr	-1028(ra) # 80006312 <acquire>
  b->refcnt--;
    8000271e:	40bc                	lw	a5,64(s1)
    80002720:	37fd                	addiw	a5,a5,-1
    80002722:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002724:	0000d517          	auipc	a0,0xd
    80002728:	97450513          	addi	a0,a0,-1676 # 8000f098 <bcache>
    8000272c:	00004097          	auipc	ra,0x4
    80002730:	c9a080e7          	jalr	-870(ra) # 800063c6 <release>
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6105                	addi	sp,sp,32
    8000273c:	8082                	ret

000000008000273e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000273e:	1101                	addi	sp,sp,-32
    80002740:	ec06                	sd	ra,24(sp)
    80002742:	e822                	sd	s0,16(sp)
    80002744:	e426                	sd	s1,8(sp)
    80002746:	e04a                	sd	s2,0(sp)
    80002748:	1000                	addi	s0,sp,32
    8000274a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000274c:	00d5d59b          	srliw	a1,a1,0xd
    80002750:	00015797          	auipc	a5,0x15
    80002754:	0247a783          	lw	a5,36(a5) # 80017774 <sb+0x1c>
    80002758:	9dbd                	addw	a1,a1,a5
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	d9e080e7          	jalr	-610(ra) # 800024f8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002762:	0074f713          	andi	a4,s1,7
    80002766:	4785                	li	a5,1
    80002768:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000276c:	14ce                	slli	s1,s1,0x33
    8000276e:	90d9                	srli	s1,s1,0x36
    80002770:	00950733          	add	a4,a0,s1
    80002774:	05874703          	lbu	a4,88(a4)
    80002778:	00e7f6b3          	and	a3,a5,a4
    8000277c:	c69d                	beqz	a3,800027aa <bfree+0x6c>
    8000277e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002780:	94aa                	add	s1,s1,a0
    80002782:	fff7c793          	not	a5,a5
    80002786:	8ff9                	and	a5,a5,a4
    80002788:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	118080e7          	jalr	280(ra) # 800038a4 <log_write>
  brelse(bp);
    80002794:	854a                	mv	a0,s2
    80002796:	00000097          	auipc	ra,0x0
    8000279a:	e92080e7          	jalr	-366(ra) # 80002628 <brelse>
}
    8000279e:	60e2                	ld	ra,24(sp)
    800027a0:	6442                	ld	s0,16(sp)
    800027a2:	64a2                	ld	s1,8(sp)
    800027a4:	6902                	ld	s2,0(sp)
    800027a6:	6105                	addi	sp,sp,32
    800027a8:	8082                	ret
    panic("freeing free block");
    800027aa:	00006517          	auipc	a0,0x6
    800027ae:	d9650513          	addi	a0,a0,-618 # 80008540 <syscalls+0x130>
    800027b2:	00003097          	auipc	ra,0x3
    800027b6:	616080e7          	jalr	1558(ra) # 80005dc8 <panic>

00000000800027ba <balloc>:
{
    800027ba:	711d                	addi	sp,sp,-96
    800027bc:	ec86                	sd	ra,88(sp)
    800027be:	e8a2                	sd	s0,80(sp)
    800027c0:	e4a6                	sd	s1,72(sp)
    800027c2:	e0ca                	sd	s2,64(sp)
    800027c4:	fc4e                	sd	s3,56(sp)
    800027c6:	f852                	sd	s4,48(sp)
    800027c8:	f456                	sd	s5,40(sp)
    800027ca:	f05a                	sd	s6,32(sp)
    800027cc:	ec5e                	sd	s7,24(sp)
    800027ce:	e862                	sd	s8,16(sp)
    800027d0:	e466                	sd	s9,8(sp)
    800027d2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027d4:	00015797          	auipc	a5,0x15
    800027d8:	f887a783          	lw	a5,-120(a5) # 8001775c <sb+0x4>
    800027dc:	cbd1                	beqz	a5,80002870 <balloc+0xb6>
    800027de:	8baa                	mv	s7,a0
    800027e0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027e2:	00015b17          	auipc	s6,0x15
    800027e6:	f76b0b13          	addi	s6,s6,-138 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ea:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027ec:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ee:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027f0:	6c89                	lui	s9,0x2
    800027f2:	a831                	j	8000280e <balloc+0x54>
    brelse(bp);
    800027f4:	854a                	mv	a0,s2
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	e32080e7          	jalr	-462(ra) # 80002628 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027fe:	015c87bb          	addw	a5,s9,s5
    80002802:	00078a9b          	sext.w	s5,a5
    80002806:	004b2703          	lw	a4,4(s6)
    8000280a:	06eaf363          	bgeu	s5,a4,80002870 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000280e:	41fad79b          	sraiw	a5,s5,0x1f
    80002812:	0137d79b          	srliw	a5,a5,0x13
    80002816:	015787bb          	addw	a5,a5,s5
    8000281a:	40d7d79b          	sraiw	a5,a5,0xd
    8000281e:	01cb2583          	lw	a1,28(s6)
    80002822:	9dbd                	addw	a1,a1,a5
    80002824:	855e                	mv	a0,s7
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	cd2080e7          	jalr	-814(ra) # 800024f8 <bread>
    8000282e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002830:	004b2503          	lw	a0,4(s6)
    80002834:	000a849b          	sext.w	s1,s5
    80002838:	8662                	mv	a2,s8
    8000283a:	faa4fde3          	bgeu	s1,a0,800027f4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000283e:	41f6579b          	sraiw	a5,a2,0x1f
    80002842:	01d7d69b          	srliw	a3,a5,0x1d
    80002846:	00c6873b          	addw	a4,a3,a2
    8000284a:	00777793          	andi	a5,a4,7
    8000284e:	9f95                	subw	a5,a5,a3
    80002850:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002854:	4037571b          	sraiw	a4,a4,0x3
    80002858:	00e906b3          	add	a3,s2,a4
    8000285c:	0586c683          	lbu	a3,88(a3)
    80002860:	00d7f5b3          	and	a1,a5,a3
    80002864:	cd91                	beqz	a1,80002880 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002866:	2605                	addiw	a2,a2,1
    80002868:	2485                	addiw	s1,s1,1
    8000286a:	fd4618e3          	bne	a2,s4,8000283a <balloc+0x80>
    8000286e:	b759                	j	800027f4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002870:	00006517          	auipc	a0,0x6
    80002874:	ce850513          	addi	a0,a0,-792 # 80008558 <syscalls+0x148>
    80002878:	00003097          	auipc	ra,0x3
    8000287c:	550080e7          	jalr	1360(ra) # 80005dc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002880:	974a                	add	a4,a4,s2
    80002882:	8fd5                	or	a5,a5,a3
    80002884:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002888:	854a                	mv	a0,s2
    8000288a:	00001097          	auipc	ra,0x1
    8000288e:	01a080e7          	jalr	26(ra) # 800038a4 <log_write>
        brelse(bp);
    80002892:	854a                	mv	a0,s2
    80002894:	00000097          	auipc	ra,0x0
    80002898:	d94080e7          	jalr	-620(ra) # 80002628 <brelse>
  bp = bread(dev, bno);
    8000289c:	85a6                	mv	a1,s1
    8000289e:	855e                	mv	a0,s7
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	c58080e7          	jalr	-936(ra) # 800024f8 <bread>
    800028a8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028aa:	40000613          	li	a2,1024
    800028ae:	4581                	li	a1,0
    800028b0:	05850513          	addi	a0,a0,88
    800028b4:	ffffe097          	auipc	ra,0xffffe
    800028b8:	8c4080e7          	jalr	-1852(ra) # 80000178 <memset>
  log_write(bp);
    800028bc:	854a                	mv	a0,s2
    800028be:	00001097          	auipc	ra,0x1
    800028c2:	fe6080e7          	jalr	-26(ra) # 800038a4 <log_write>
  brelse(bp);
    800028c6:	854a                	mv	a0,s2
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	d60080e7          	jalr	-672(ra) # 80002628 <brelse>
}
    800028d0:	8526                	mv	a0,s1
    800028d2:	60e6                	ld	ra,88(sp)
    800028d4:	6446                	ld	s0,80(sp)
    800028d6:	64a6                	ld	s1,72(sp)
    800028d8:	6906                	ld	s2,64(sp)
    800028da:	79e2                	ld	s3,56(sp)
    800028dc:	7a42                	ld	s4,48(sp)
    800028de:	7aa2                	ld	s5,40(sp)
    800028e0:	7b02                	ld	s6,32(sp)
    800028e2:	6be2                	ld	s7,24(sp)
    800028e4:	6c42                	ld	s8,16(sp)
    800028e6:	6ca2                	ld	s9,8(sp)
    800028e8:	6125                	addi	sp,sp,96
    800028ea:	8082                	ret

00000000800028ec <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028ec:	7179                	addi	sp,sp,-48
    800028ee:	f406                	sd	ra,40(sp)
    800028f0:	f022                	sd	s0,32(sp)
    800028f2:	ec26                	sd	s1,24(sp)
    800028f4:	e84a                	sd	s2,16(sp)
    800028f6:	e44e                	sd	s3,8(sp)
    800028f8:	e052                	sd	s4,0(sp)
    800028fa:	1800                	addi	s0,sp,48
    800028fc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028fe:	47ad                	li	a5,11
    80002900:	04b7fe63          	bgeu	a5,a1,8000295c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002904:	ff45849b          	addiw	s1,a1,-12
    80002908:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000290c:	0ff00793          	li	a5,255
    80002910:	0ae7e363          	bltu	a5,a4,800029b6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002914:	08052583          	lw	a1,128(a0)
    80002918:	c5ad                	beqz	a1,80002982 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000291a:	00092503          	lw	a0,0(s2)
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	bda080e7          	jalr	-1062(ra) # 800024f8 <bread>
    80002926:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002928:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000292c:	02049593          	slli	a1,s1,0x20
    80002930:	9181                	srli	a1,a1,0x20
    80002932:	058a                	slli	a1,a1,0x2
    80002934:	00b784b3          	add	s1,a5,a1
    80002938:	0004a983          	lw	s3,0(s1)
    8000293c:	04098d63          	beqz	s3,80002996 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002940:	8552                	mv	a0,s4
    80002942:	00000097          	auipc	ra,0x0
    80002946:	ce6080e7          	jalr	-794(ra) # 80002628 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000294a:	854e                	mv	a0,s3
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6a02                	ld	s4,0(sp)
    80002958:	6145                	addi	sp,sp,48
    8000295a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000295c:	02059493          	slli	s1,a1,0x20
    80002960:	9081                	srli	s1,s1,0x20
    80002962:	048a                	slli	s1,s1,0x2
    80002964:	94aa                	add	s1,s1,a0
    80002966:	0504a983          	lw	s3,80(s1)
    8000296a:	fe0990e3          	bnez	s3,8000294a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000296e:	4108                	lw	a0,0(a0)
    80002970:	00000097          	auipc	ra,0x0
    80002974:	e4a080e7          	jalr	-438(ra) # 800027ba <balloc>
    80002978:	0005099b          	sext.w	s3,a0
    8000297c:	0534a823          	sw	s3,80(s1)
    80002980:	b7e9                	j	8000294a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002982:	4108                	lw	a0,0(a0)
    80002984:	00000097          	auipc	ra,0x0
    80002988:	e36080e7          	jalr	-458(ra) # 800027ba <balloc>
    8000298c:	0005059b          	sext.w	a1,a0
    80002990:	08b92023          	sw	a1,128(s2)
    80002994:	b759                	j	8000291a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002996:	00092503          	lw	a0,0(s2)
    8000299a:	00000097          	auipc	ra,0x0
    8000299e:	e20080e7          	jalr	-480(ra) # 800027ba <balloc>
    800029a2:	0005099b          	sext.w	s3,a0
    800029a6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029aa:	8552                	mv	a0,s4
    800029ac:	00001097          	auipc	ra,0x1
    800029b0:	ef8080e7          	jalr	-264(ra) # 800038a4 <log_write>
    800029b4:	b771                	j	80002940 <bmap+0x54>
  panic("bmap: out of range");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	bba50513          	addi	a0,a0,-1094 # 80008570 <syscalls+0x160>
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	40a080e7          	jalr	1034(ra) # 80005dc8 <panic>

00000000800029c6 <iget>:
{
    800029c6:	7179                	addi	sp,sp,-48
    800029c8:	f406                	sd	ra,40(sp)
    800029ca:	f022                	sd	s0,32(sp)
    800029cc:	ec26                	sd	s1,24(sp)
    800029ce:	e84a                	sd	s2,16(sp)
    800029d0:	e44e                	sd	s3,8(sp)
    800029d2:	e052                	sd	s4,0(sp)
    800029d4:	1800                	addi	s0,sp,48
    800029d6:	89aa                	mv	s3,a0
    800029d8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029da:	00015517          	auipc	a0,0x15
    800029de:	d9e50513          	addi	a0,a0,-610 # 80017778 <itable>
    800029e2:	00004097          	auipc	ra,0x4
    800029e6:	930080e7          	jalr	-1744(ra) # 80006312 <acquire>
  empty = 0;
    800029ea:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ec:	00015497          	auipc	s1,0x15
    800029f0:	da448493          	addi	s1,s1,-604 # 80017790 <itable+0x18>
    800029f4:	00017697          	auipc	a3,0x17
    800029f8:	82c68693          	addi	a3,a3,-2004 # 80019220 <log>
    800029fc:	a039                	j	80002a0a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029fe:	02090b63          	beqz	s2,80002a34 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a02:	08848493          	addi	s1,s1,136
    80002a06:	02d48a63          	beq	s1,a3,80002a3a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a0a:	449c                	lw	a5,8(s1)
    80002a0c:	fef059e3          	blez	a5,800029fe <iget+0x38>
    80002a10:	4098                	lw	a4,0(s1)
    80002a12:	ff3716e3          	bne	a4,s3,800029fe <iget+0x38>
    80002a16:	40d8                	lw	a4,4(s1)
    80002a18:	ff4713e3          	bne	a4,s4,800029fe <iget+0x38>
      ip->ref++;
    80002a1c:	2785                	addiw	a5,a5,1
    80002a1e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a20:	00015517          	auipc	a0,0x15
    80002a24:	d5850513          	addi	a0,a0,-680 # 80017778 <itable>
    80002a28:	00004097          	auipc	ra,0x4
    80002a2c:	99e080e7          	jalr	-1634(ra) # 800063c6 <release>
      return ip;
    80002a30:	8926                	mv	s2,s1
    80002a32:	a03d                	j	80002a60 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a34:	f7f9                	bnez	a5,80002a02 <iget+0x3c>
    80002a36:	8926                	mv	s2,s1
    80002a38:	b7e9                	j	80002a02 <iget+0x3c>
  if(empty == 0)
    80002a3a:	02090c63          	beqz	s2,80002a72 <iget+0xac>
  ip->dev = dev;
    80002a3e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a42:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a46:	4785                	li	a5,1
    80002a48:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a4c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a50:	00015517          	auipc	a0,0x15
    80002a54:	d2850513          	addi	a0,a0,-728 # 80017778 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	96e080e7          	jalr	-1682(ra) # 800063c6 <release>
}
    80002a60:	854a                	mv	a0,s2
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6a02                	ld	s4,0(sp)
    80002a6e:	6145                	addi	sp,sp,48
    80002a70:	8082                	ret
    panic("iget: no inodes");
    80002a72:	00006517          	auipc	a0,0x6
    80002a76:	b1650513          	addi	a0,a0,-1258 # 80008588 <syscalls+0x178>
    80002a7a:	00003097          	auipc	ra,0x3
    80002a7e:	34e080e7          	jalr	846(ra) # 80005dc8 <panic>

0000000080002a82 <fsinit>:
fsinit(int dev) {
    80002a82:	7179                	addi	sp,sp,-48
    80002a84:	f406                	sd	ra,40(sp)
    80002a86:	f022                	sd	s0,32(sp)
    80002a88:	ec26                	sd	s1,24(sp)
    80002a8a:	e84a                	sd	s2,16(sp)
    80002a8c:	e44e                	sd	s3,8(sp)
    80002a8e:	1800                	addi	s0,sp,48
    80002a90:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a92:	4585                	li	a1,1
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	a64080e7          	jalr	-1436(ra) # 800024f8 <bread>
    80002a9c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a9e:	00015997          	auipc	s3,0x15
    80002aa2:	cba98993          	addi	s3,s3,-838 # 80017758 <sb>
    80002aa6:	02000613          	li	a2,32
    80002aaa:	05850593          	addi	a1,a0,88
    80002aae:	854e                	mv	a0,s3
    80002ab0:	ffffd097          	auipc	ra,0xffffd
    80002ab4:	728080e7          	jalr	1832(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ab8:	8526                	mv	a0,s1
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	b6e080e7          	jalr	-1170(ra) # 80002628 <brelse>
  if(sb.magic != FSMAGIC)
    80002ac2:	0009a703          	lw	a4,0(s3)
    80002ac6:	102037b7          	lui	a5,0x10203
    80002aca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ace:	02f71263          	bne	a4,a5,80002af2 <fsinit+0x70>
  initlog(dev, &sb);
    80002ad2:	00015597          	auipc	a1,0x15
    80002ad6:	c8658593          	addi	a1,a1,-890 # 80017758 <sb>
    80002ada:	854a                	mv	a0,s2
    80002adc:	00001097          	auipc	ra,0x1
    80002ae0:	b4c080e7          	jalr	-1204(ra) # 80003628 <initlog>
}
    80002ae4:	70a2                	ld	ra,40(sp)
    80002ae6:	7402                	ld	s0,32(sp)
    80002ae8:	64e2                	ld	s1,24(sp)
    80002aea:	6942                	ld	s2,16(sp)
    80002aec:	69a2                	ld	s3,8(sp)
    80002aee:	6145                	addi	sp,sp,48
    80002af0:	8082                	ret
    panic("invalid file system");
    80002af2:	00006517          	auipc	a0,0x6
    80002af6:	aa650513          	addi	a0,a0,-1370 # 80008598 <syscalls+0x188>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	2ce080e7          	jalr	718(ra) # 80005dc8 <panic>

0000000080002b02 <iinit>:
{
    80002b02:	7179                	addi	sp,sp,-48
    80002b04:	f406                	sd	ra,40(sp)
    80002b06:	f022                	sd	s0,32(sp)
    80002b08:	ec26                	sd	s1,24(sp)
    80002b0a:	e84a                	sd	s2,16(sp)
    80002b0c:	e44e                	sd	s3,8(sp)
    80002b0e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b10:	00006597          	auipc	a1,0x6
    80002b14:	aa058593          	addi	a1,a1,-1376 # 800085b0 <syscalls+0x1a0>
    80002b18:	00015517          	auipc	a0,0x15
    80002b1c:	c6050513          	addi	a0,a0,-928 # 80017778 <itable>
    80002b20:	00003097          	auipc	ra,0x3
    80002b24:	762080e7          	jalr	1890(ra) # 80006282 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b28:	00015497          	auipc	s1,0x15
    80002b2c:	c7848493          	addi	s1,s1,-904 # 800177a0 <itable+0x28>
    80002b30:	00016997          	auipc	s3,0x16
    80002b34:	70098993          	addi	s3,s3,1792 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b38:	00006917          	auipc	s2,0x6
    80002b3c:	a8090913          	addi	s2,s2,-1408 # 800085b8 <syscalls+0x1a8>
    80002b40:	85ca                	mv	a1,s2
    80002b42:	8526                	mv	a0,s1
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	e46080e7          	jalr	-442(ra) # 8000398a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b4c:	08848493          	addi	s1,s1,136
    80002b50:	ff3498e3          	bne	s1,s3,80002b40 <iinit+0x3e>
}
    80002b54:	70a2                	ld	ra,40(sp)
    80002b56:	7402                	ld	s0,32(sp)
    80002b58:	64e2                	ld	s1,24(sp)
    80002b5a:	6942                	ld	s2,16(sp)
    80002b5c:	69a2                	ld	s3,8(sp)
    80002b5e:	6145                	addi	sp,sp,48
    80002b60:	8082                	ret

0000000080002b62 <ialloc>:
{
    80002b62:	715d                	addi	sp,sp,-80
    80002b64:	e486                	sd	ra,72(sp)
    80002b66:	e0a2                	sd	s0,64(sp)
    80002b68:	fc26                	sd	s1,56(sp)
    80002b6a:	f84a                	sd	s2,48(sp)
    80002b6c:	f44e                	sd	s3,40(sp)
    80002b6e:	f052                	sd	s4,32(sp)
    80002b70:	ec56                	sd	s5,24(sp)
    80002b72:	e85a                	sd	s6,16(sp)
    80002b74:	e45e                	sd	s7,8(sp)
    80002b76:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b78:	00015717          	auipc	a4,0x15
    80002b7c:	bec72703          	lw	a4,-1044(a4) # 80017764 <sb+0xc>
    80002b80:	4785                	li	a5,1
    80002b82:	04e7fa63          	bgeu	a5,a4,80002bd6 <ialloc+0x74>
    80002b86:	8aaa                	mv	s5,a0
    80002b88:	8bae                	mv	s7,a1
    80002b8a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b8c:	00015a17          	auipc	s4,0x15
    80002b90:	bcca0a13          	addi	s4,s4,-1076 # 80017758 <sb>
    80002b94:	00048b1b          	sext.w	s6,s1
    80002b98:	0044d593          	srli	a1,s1,0x4
    80002b9c:	018a2783          	lw	a5,24(s4)
    80002ba0:	9dbd                	addw	a1,a1,a5
    80002ba2:	8556                	mv	a0,s5
    80002ba4:	00000097          	auipc	ra,0x0
    80002ba8:	954080e7          	jalr	-1708(ra) # 800024f8 <bread>
    80002bac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bae:	05850993          	addi	s3,a0,88
    80002bb2:	00f4f793          	andi	a5,s1,15
    80002bb6:	079a                	slli	a5,a5,0x6
    80002bb8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bba:	00099783          	lh	a5,0(s3)
    80002bbe:	c785                	beqz	a5,80002be6 <ialloc+0x84>
    brelse(bp);
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	a68080e7          	jalr	-1432(ra) # 80002628 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bc8:	0485                	addi	s1,s1,1
    80002bca:	00ca2703          	lw	a4,12(s4)
    80002bce:	0004879b          	sext.w	a5,s1
    80002bd2:	fce7e1e3          	bltu	a5,a4,80002b94 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bd6:	00006517          	auipc	a0,0x6
    80002bda:	9ea50513          	addi	a0,a0,-1558 # 800085c0 <syscalls+0x1b0>
    80002bde:	00003097          	auipc	ra,0x3
    80002be2:	1ea080e7          	jalr	490(ra) # 80005dc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002be6:	04000613          	li	a2,64
    80002bea:	4581                	li	a1,0
    80002bec:	854e                	mv	a0,s3
    80002bee:	ffffd097          	auipc	ra,0xffffd
    80002bf2:	58a080e7          	jalr	1418(ra) # 80000178 <memset>
      dip->type = type;
    80002bf6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bfa:	854a                	mv	a0,s2
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	ca8080e7          	jalr	-856(ra) # 800038a4 <log_write>
      brelse(bp);
    80002c04:	854a                	mv	a0,s2
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	a22080e7          	jalr	-1502(ra) # 80002628 <brelse>
      return iget(dev, inum);
    80002c0e:	85da                	mv	a1,s6
    80002c10:	8556                	mv	a0,s5
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	db4080e7          	jalr	-588(ra) # 800029c6 <iget>
}
    80002c1a:	60a6                	ld	ra,72(sp)
    80002c1c:	6406                	ld	s0,64(sp)
    80002c1e:	74e2                	ld	s1,56(sp)
    80002c20:	7942                	ld	s2,48(sp)
    80002c22:	79a2                	ld	s3,40(sp)
    80002c24:	7a02                	ld	s4,32(sp)
    80002c26:	6ae2                	ld	s5,24(sp)
    80002c28:	6b42                	ld	s6,16(sp)
    80002c2a:	6ba2                	ld	s7,8(sp)
    80002c2c:	6161                	addi	sp,sp,80
    80002c2e:	8082                	ret

0000000080002c30 <iupdate>:
{
    80002c30:	1101                	addi	sp,sp,-32
    80002c32:	ec06                	sd	ra,24(sp)
    80002c34:	e822                	sd	s0,16(sp)
    80002c36:	e426                	sd	s1,8(sp)
    80002c38:	e04a                	sd	s2,0(sp)
    80002c3a:	1000                	addi	s0,sp,32
    80002c3c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3e:	415c                	lw	a5,4(a0)
    80002c40:	0047d79b          	srliw	a5,a5,0x4
    80002c44:	00015597          	auipc	a1,0x15
    80002c48:	b2c5a583          	lw	a1,-1236(a1) # 80017770 <sb+0x18>
    80002c4c:	9dbd                	addw	a1,a1,a5
    80002c4e:	4108                	lw	a0,0(a0)
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	8a8080e7          	jalr	-1880(ra) # 800024f8 <bread>
    80002c58:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c5a:	05850793          	addi	a5,a0,88
    80002c5e:	40c8                	lw	a0,4(s1)
    80002c60:	893d                	andi	a0,a0,15
    80002c62:	051a                	slli	a0,a0,0x6
    80002c64:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c66:	04449703          	lh	a4,68(s1)
    80002c6a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c6e:	04649703          	lh	a4,70(s1)
    80002c72:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c76:	04849703          	lh	a4,72(s1)
    80002c7a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c7e:	04a49703          	lh	a4,74(s1)
    80002c82:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c86:	44f8                	lw	a4,76(s1)
    80002c88:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c8a:	03400613          	li	a2,52
    80002c8e:	05048593          	addi	a1,s1,80
    80002c92:	0531                	addi	a0,a0,12
    80002c94:	ffffd097          	auipc	ra,0xffffd
    80002c98:	544080e7          	jalr	1348(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	c06080e7          	jalr	-1018(ra) # 800038a4 <log_write>
  brelse(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	980080e7          	jalr	-1664(ra) # 80002628 <brelse>
}
    80002cb0:	60e2                	ld	ra,24(sp)
    80002cb2:	6442                	ld	s0,16(sp)
    80002cb4:	64a2                	ld	s1,8(sp)
    80002cb6:	6902                	ld	s2,0(sp)
    80002cb8:	6105                	addi	sp,sp,32
    80002cba:	8082                	ret

0000000080002cbc <idup>:
{
    80002cbc:	1101                	addi	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	1000                	addi	s0,sp,32
    80002cc6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cc8:	00015517          	auipc	a0,0x15
    80002ccc:	ab050513          	addi	a0,a0,-1360 # 80017778 <itable>
    80002cd0:	00003097          	auipc	ra,0x3
    80002cd4:	642080e7          	jalr	1602(ra) # 80006312 <acquire>
  ip->ref++;
    80002cd8:	449c                	lw	a5,8(s1)
    80002cda:	2785                	addiw	a5,a5,1
    80002cdc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cde:	00015517          	auipc	a0,0x15
    80002ce2:	a9a50513          	addi	a0,a0,-1382 # 80017778 <itable>
    80002ce6:	00003097          	auipc	ra,0x3
    80002cea:	6e0080e7          	jalr	1760(ra) # 800063c6 <release>
}
    80002cee:	8526                	mv	a0,s1
    80002cf0:	60e2                	ld	ra,24(sp)
    80002cf2:	6442                	ld	s0,16(sp)
    80002cf4:	64a2                	ld	s1,8(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret

0000000080002cfa <ilock>:
{
    80002cfa:	1101                	addi	sp,sp,-32
    80002cfc:	ec06                	sd	ra,24(sp)
    80002cfe:	e822                	sd	s0,16(sp)
    80002d00:	e426                	sd	s1,8(sp)
    80002d02:	e04a                	sd	s2,0(sp)
    80002d04:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d06:	c115                	beqz	a0,80002d2a <ilock+0x30>
    80002d08:	84aa                	mv	s1,a0
    80002d0a:	451c                	lw	a5,8(a0)
    80002d0c:	00f05f63          	blez	a5,80002d2a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d10:	0541                	addi	a0,a0,16
    80002d12:	00001097          	auipc	ra,0x1
    80002d16:	cb2080e7          	jalr	-846(ra) # 800039c4 <acquiresleep>
  if(ip->valid == 0){
    80002d1a:	40bc                	lw	a5,64(s1)
    80002d1c:	cf99                	beqz	a5,80002d3a <ilock+0x40>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6902                	ld	s2,0(sp)
    80002d26:	6105                	addi	sp,sp,32
    80002d28:	8082                	ret
    panic("ilock");
    80002d2a:	00006517          	auipc	a0,0x6
    80002d2e:	8ae50513          	addi	a0,a0,-1874 # 800085d8 <syscalls+0x1c8>
    80002d32:	00003097          	auipc	ra,0x3
    80002d36:	096080e7          	jalr	150(ra) # 80005dc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d3a:	40dc                	lw	a5,4(s1)
    80002d3c:	0047d79b          	srliw	a5,a5,0x4
    80002d40:	00015597          	auipc	a1,0x15
    80002d44:	a305a583          	lw	a1,-1488(a1) # 80017770 <sb+0x18>
    80002d48:	9dbd                	addw	a1,a1,a5
    80002d4a:	4088                	lw	a0,0(s1)
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	7ac080e7          	jalr	1964(ra) # 800024f8 <bread>
    80002d54:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d56:	05850593          	addi	a1,a0,88
    80002d5a:	40dc                	lw	a5,4(s1)
    80002d5c:	8bbd                	andi	a5,a5,15
    80002d5e:	079a                	slli	a5,a5,0x6
    80002d60:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d62:	00059783          	lh	a5,0(a1)
    80002d66:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d6a:	00259783          	lh	a5,2(a1)
    80002d6e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d72:	00459783          	lh	a5,4(a1)
    80002d76:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d7a:	00659783          	lh	a5,6(a1)
    80002d7e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d82:	459c                	lw	a5,8(a1)
    80002d84:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d86:	03400613          	li	a2,52
    80002d8a:	05b1                	addi	a1,a1,12
    80002d8c:	05048513          	addi	a0,s1,80
    80002d90:	ffffd097          	auipc	ra,0xffffd
    80002d94:	448080e7          	jalr	1096(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d98:	854a                	mv	a0,s2
    80002d9a:	00000097          	auipc	ra,0x0
    80002d9e:	88e080e7          	jalr	-1906(ra) # 80002628 <brelse>
    ip->valid = 1;
    80002da2:	4785                	li	a5,1
    80002da4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002da6:	04449783          	lh	a5,68(s1)
    80002daa:	fbb5                	bnez	a5,80002d1e <ilock+0x24>
      panic("ilock: no type");
    80002dac:	00006517          	auipc	a0,0x6
    80002db0:	83450513          	addi	a0,a0,-1996 # 800085e0 <syscalls+0x1d0>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	014080e7          	jalr	20(ra) # 80005dc8 <panic>

0000000080002dbc <iunlock>:
{
    80002dbc:	1101                	addi	sp,sp,-32
    80002dbe:	ec06                	sd	ra,24(sp)
    80002dc0:	e822                	sd	s0,16(sp)
    80002dc2:	e426                	sd	s1,8(sp)
    80002dc4:	e04a                	sd	s2,0(sp)
    80002dc6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dc8:	c905                	beqz	a0,80002df8 <iunlock+0x3c>
    80002dca:	84aa                	mv	s1,a0
    80002dcc:	01050913          	addi	s2,a0,16
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	00001097          	auipc	ra,0x1
    80002dd6:	c8c080e7          	jalr	-884(ra) # 80003a5e <holdingsleep>
    80002dda:	cd19                	beqz	a0,80002df8 <iunlock+0x3c>
    80002ddc:	449c                	lw	a5,8(s1)
    80002dde:	00f05d63          	blez	a5,80002df8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	c36080e7          	jalr	-970(ra) # 80003a1a <releasesleep>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6902                	ld	s2,0(sp)
    80002df4:	6105                	addi	sp,sp,32
    80002df6:	8082                	ret
    panic("iunlock");
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	7f850513          	addi	a0,a0,2040 # 800085f0 <syscalls+0x1e0>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	fc8080e7          	jalr	-56(ra) # 80005dc8 <panic>

0000000080002e08 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e08:	7179                	addi	sp,sp,-48
    80002e0a:	f406                	sd	ra,40(sp)
    80002e0c:	f022                	sd	s0,32(sp)
    80002e0e:	ec26                	sd	s1,24(sp)
    80002e10:	e84a                	sd	s2,16(sp)
    80002e12:	e44e                	sd	s3,8(sp)
    80002e14:	e052                	sd	s4,0(sp)
    80002e16:	1800                	addi	s0,sp,48
    80002e18:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e1a:	05050493          	addi	s1,a0,80
    80002e1e:	08050913          	addi	s2,a0,128
    80002e22:	a021                	j	80002e2a <itrunc+0x22>
    80002e24:	0491                	addi	s1,s1,4
    80002e26:	01248d63          	beq	s1,s2,80002e40 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e2a:	408c                	lw	a1,0(s1)
    80002e2c:	dde5                	beqz	a1,80002e24 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e2e:	0009a503          	lw	a0,0(s3)
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	90c080e7          	jalr	-1780(ra) # 8000273e <bfree>
      ip->addrs[i] = 0;
    80002e3a:	0004a023          	sw	zero,0(s1)
    80002e3e:	b7dd                	j	80002e24 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e40:	0809a583          	lw	a1,128(s3)
    80002e44:	e185                	bnez	a1,80002e64 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e46:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e4a:	854e                	mv	a0,s3
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	de4080e7          	jalr	-540(ra) # 80002c30 <iupdate>
}
    80002e54:	70a2                	ld	ra,40(sp)
    80002e56:	7402                	ld	s0,32(sp)
    80002e58:	64e2                	ld	s1,24(sp)
    80002e5a:	6942                	ld	s2,16(sp)
    80002e5c:	69a2                	ld	s3,8(sp)
    80002e5e:	6a02                	ld	s4,0(sp)
    80002e60:	6145                	addi	sp,sp,48
    80002e62:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e64:	0009a503          	lw	a0,0(s3)
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	690080e7          	jalr	1680(ra) # 800024f8 <bread>
    80002e70:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e72:	05850493          	addi	s1,a0,88
    80002e76:	45850913          	addi	s2,a0,1112
    80002e7a:	a811                	j	80002e8e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e7c:	0009a503          	lw	a0,0(s3)
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	8be080e7          	jalr	-1858(ra) # 8000273e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e88:	0491                	addi	s1,s1,4
    80002e8a:	01248563          	beq	s1,s2,80002e94 <itrunc+0x8c>
      if(a[j])
    80002e8e:	408c                	lw	a1,0(s1)
    80002e90:	dde5                	beqz	a1,80002e88 <itrunc+0x80>
    80002e92:	b7ed                	j	80002e7c <itrunc+0x74>
    brelse(bp);
    80002e94:	8552                	mv	a0,s4
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	792080e7          	jalr	1938(ra) # 80002628 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e9e:	0809a583          	lw	a1,128(s3)
    80002ea2:	0009a503          	lw	a0,0(s3)
    80002ea6:	00000097          	auipc	ra,0x0
    80002eaa:	898080e7          	jalr	-1896(ra) # 8000273e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eae:	0809a023          	sw	zero,128(s3)
    80002eb2:	bf51                	j	80002e46 <itrunc+0x3e>

0000000080002eb4 <iput>:
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	e04a                	sd	s2,0(sp)
    80002ebe:	1000                	addi	s0,sp,32
    80002ec0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ec2:	00015517          	auipc	a0,0x15
    80002ec6:	8b650513          	addi	a0,a0,-1866 # 80017778 <itable>
    80002eca:	00003097          	auipc	ra,0x3
    80002ece:	448080e7          	jalr	1096(ra) # 80006312 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed2:	4498                	lw	a4,8(s1)
    80002ed4:	4785                	li	a5,1
    80002ed6:	02f70363          	beq	a4,a5,80002efc <iput+0x48>
  ip->ref--;
    80002eda:	449c                	lw	a5,8(s1)
    80002edc:	37fd                	addiw	a5,a5,-1
    80002ede:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ee0:	00015517          	auipc	a0,0x15
    80002ee4:	89850513          	addi	a0,a0,-1896 # 80017778 <itable>
    80002ee8:	00003097          	auipc	ra,0x3
    80002eec:	4de080e7          	jalr	1246(ra) # 800063c6 <release>
}
    80002ef0:	60e2                	ld	ra,24(sp)
    80002ef2:	6442                	ld	s0,16(sp)
    80002ef4:	64a2                	ld	s1,8(sp)
    80002ef6:	6902                	ld	s2,0(sp)
    80002ef8:	6105                	addi	sp,sp,32
    80002efa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002efc:	40bc                	lw	a5,64(s1)
    80002efe:	dff1                	beqz	a5,80002eda <iput+0x26>
    80002f00:	04a49783          	lh	a5,74(s1)
    80002f04:	fbf9                	bnez	a5,80002eda <iput+0x26>
    acquiresleep(&ip->lock);
    80002f06:	01048913          	addi	s2,s1,16
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	00001097          	auipc	ra,0x1
    80002f10:	ab8080e7          	jalr	-1352(ra) # 800039c4 <acquiresleep>
    release(&itable.lock);
    80002f14:	00015517          	auipc	a0,0x15
    80002f18:	86450513          	addi	a0,a0,-1948 # 80017778 <itable>
    80002f1c:	00003097          	auipc	ra,0x3
    80002f20:	4aa080e7          	jalr	1194(ra) # 800063c6 <release>
    itrunc(ip);
    80002f24:	8526                	mv	a0,s1
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	ee2080e7          	jalr	-286(ra) # 80002e08 <itrunc>
    ip->type = 0;
    80002f2e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f32:	8526                	mv	a0,s1
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	cfc080e7          	jalr	-772(ra) # 80002c30 <iupdate>
    ip->valid = 0;
    80002f3c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f40:	854a                	mv	a0,s2
    80002f42:	00001097          	auipc	ra,0x1
    80002f46:	ad8080e7          	jalr	-1320(ra) # 80003a1a <releasesleep>
    acquire(&itable.lock);
    80002f4a:	00015517          	auipc	a0,0x15
    80002f4e:	82e50513          	addi	a0,a0,-2002 # 80017778 <itable>
    80002f52:	00003097          	auipc	ra,0x3
    80002f56:	3c0080e7          	jalr	960(ra) # 80006312 <acquire>
    80002f5a:	b741                	j	80002eda <iput+0x26>

0000000080002f5c <iunlockput>:
{
    80002f5c:	1101                	addi	sp,sp,-32
    80002f5e:	ec06                	sd	ra,24(sp)
    80002f60:	e822                	sd	s0,16(sp)
    80002f62:	e426                	sd	s1,8(sp)
    80002f64:	1000                	addi	s0,sp,32
    80002f66:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	e54080e7          	jalr	-428(ra) # 80002dbc <iunlock>
  iput(ip);
    80002f70:	8526                	mv	a0,s1
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	f42080e7          	jalr	-190(ra) # 80002eb4 <iput>
}
    80002f7a:	60e2                	ld	ra,24(sp)
    80002f7c:	6442                	ld	s0,16(sp)
    80002f7e:	64a2                	ld	s1,8(sp)
    80002f80:	6105                	addi	sp,sp,32
    80002f82:	8082                	ret

0000000080002f84 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f84:	1141                	addi	sp,sp,-16
    80002f86:	e422                	sd	s0,8(sp)
    80002f88:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f8a:	411c                	lw	a5,0(a0)
    80002f8c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f8e:	415c                	lw	a5,4(a0)
    80002f90:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f92:	04451783          	lh	a5,68(a0)
    80002f96:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f9a:	04a51783          	lh	a5,74(a0)
    80002f9e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fa2:	04c56783          	lwu	a5,76(a0)
    80002fa6:	e99c                	sd	a5,16(a1)
}
    80002fa8:	6422                	ld	s0,8(sp)
    80002faa:	0141                	addi	sp,sp,16
    80002fac:	8082                	ret

0000000080002fae <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fae:	457c                	lw	a5,76(a0)
    80002fb0:	0ed7e963          	bltu	a5,a3,800030a2 <readi+0xf4>
{
    80002fb4:	7159                	addi	sp,sp,-112
    80002fb6:	f486                	sd	ra,104(sp)
    80002fb8:	f0a2                	sd	s0,96(sp)
    80002fba:	eca6                	sd	s1,88(sp)
    80002fbc:	e8ca                	sd	s2,80(sp)
    80002fbe:	e4ce                	sd	s3,72(sp)
    80002fc0:	e0d2                	sd	s4,64(sp)
    80002fc2:	fc56                	sd	s5,56(sp)
    80002fc4:	f85a                	sd	s6,48(sp)
    80002fc6:	f45e                	sd	s7,40(sp)
    80002fc8:	f062                	sd	s8,32(sp)
    80002fca:	ec66                	sd	s9,24(sp)
    80002fcc:	e86a                	sd	s10,16(sp)
    80002fce:	e46e                	sd	s11,8(sp)
    80002fd0:	1880                	addi	s0,sp,112
    80002fd2:	8baa                	mv	s7,a0
    80002fd4:	8c2e                	mv	s8,a1
    80002fd6:	8ab2                	mv	s5,a2
    80002fd8:	84b6                	mv	s1,a3
    80002fda:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fdc:	9f35                	addw	a4,a4,a3
    return 0;
    80002fde:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fe0:	0ad76063          	bltu	a4,a3,80003080 <readi+0xd2>
  if(off + n > ip->size)
    80002fe4:	00e7f463          	bgeu	a5,a4,80002fec <readi+0x3e>
    n = ip->size - off;
    80002fe8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fec:	0a0b0963          	beqz	s6,8000309e <readi+0xf0>
    80002ff0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ff6:	5cfd                	li	s9,-1
    80002ff8:	a82d                	j	80003032 <readi+0x84>
    80002ffa:	020a1d93          	slli	s11,s4,0x20
    80002ffe:	020ddd93          	srli	s11,s11,0x20
    80003002:	05890613          	addi	a2,s2,88
    80003006:	86ee                	mv	a3,s11
    80003008:	963a                	add	a2,a2,a4
    8000300a:	85d6                	mv	a1,s5
    8000300c:	8562                	mv	a0,s8
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	a28080e7          	jalr	-1496(ra) # 80001a36 <either_copyout>
    80003016:	05950d63          	beq	a0,s9,80003070 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000301a:	854a                	mv	a0,s2
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	60c080e7          	jalr	1548(ra) # 80002628 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003024:	013a09bb          	addw	s3,s4,s3
    80003028:	009a04bb          	addw	s1,s4,s1
    8000302c:	9aee                	add	s5,s5,s11
    8000302e:	0569f763          	bgeu	s3,s6,8000307c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003032:	000ba903          	lw	s2,0(s7)
    80003036:	00a4d59b          	srliw	a1,s1,0xa
    8000303a:	855e                	mv	a0,s7
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	8b0080e7          	jalr	-1872(ra) # 800028ec <bmap>
    80003044:	0005059b          	sext.w	a1,a0
    80003048:	854a                	mv	a0,s2
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	4ae080e7          	jalr	1198(ra) # 800024f8 <bread>
    80003052:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003054:	3ff4f713          	andi	a4,s1,1023
    80003058:	40ed07bb          	subw	a5,s10,a4
    8000305c:	413b06bb          	subw	a3,s6,s3
    80003060:	8a3e                	mv	s4,a5
    80003062:	2781                	sext.w	a5,a5
    80003064:	0006861b          	sext.w	a2,a3
    80003068:	f8f679e3          	bgeu	a2,a5,80002ffa <readi+0x4c>
    8000306c:	8a36                	mv	s4,a3
    8000306e:	b771                	j	80002ffa <readi+0x4c>
      brelse(bp);
    80003070:	854a                	mv	a0,s2
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	5b6080e7          	jalr	1462(ra) # 80002628 <brelse>
      tot = -1;
    8000307a:	59fd                	li	s3,-1
  }
  return tot;
    8000307c:	0009851b          	sext.w	a0,s3
}
    80003080:	70a6                	ld	ra,104(sp)
    80003082:	7406                	ld	s0,96(sp)
    80003084:	64e6                	ld	s1,88(sp)
    80003086:	6946                	ld	s2,80(sp)
    80003088:	69a6                	ld	s3,72(sp)
    8000308a:	6a06                	ld	s4,64(sp)
    8000308c:	7ae2                	ld	s5,56(sp)
    8000308e:	7b42                	ld	s6,48(sp)
    80003090:	7ba2                	ld	s7,40(sp)
    80003092:	7c02                	ld	s8,32(sp)
    80003094:	6ce2                	ld	s9,24(sp)
    80003096:	6d42                	ld	s10,16(sp)
    80003098:	6da2                	ld	s11,8(sp)
    8000309a:	6165                	addi	sp,sp,112
    8000309c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000309e:	89da                	mv	s3,s6
    800030a0:	bff1                	j	8000307c <readi+0xce>
    return 0;
    800030a2:	4501                	li	a0,0
}
    800030a4:	8082                	ret

00000000800030a6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030a6:	457c                	lw	a5,76(a0)
    800030a8:	10d7e863          	bltu	a5,a3,800031b8 <writei+0x112>
{
    800030ac:	7159                	addi	sp,sp,-112
    800030ae:	f486                	sd	ra,104(sp)
    800030b0:	f0a2                	sd	s0,96(sp)
    800030b2:	eca6                	sd	s1,88(sp)
    800030b4:	e8ca                	sd	s2,80(sp)
    800030b6:	e4ce                	sd	s3,72(sp)
    800030b8:	e0d2                	sd	s4,64(sp)
    800030ba:	fc56                	sd	s5,56(sp)
    800030bc:	f85a                	sd	s6,48(sp)
    800030be:	f45e                	sd	s7,40(sp)
    800030c0:	f062                	sd	s8,32(sp)
    800030c2:	ec66                	sd	s9,24(sp)
    800030c4:	e86a                	sd	s10,16(sp)
    800030c6:	e46e                	sd	s11,8(sp)
    800030c8:	1880                	addi	s0,sp,112
    800030ca:	8b2a                	mv	s6,a0
    800030cc:	8c2e                	mv	s8,a1
    800030ce:	8ab2                	mv	s5,a2
    800030d0:	8936                	mv	s2,a3
    800030d2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030d4:	00e687bb          	addw	a5,a3,a4
    800030d8:	0ed7e263          	bltu	a5,a3,800031bc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030dc:	00043737          	lui	a4,0x43
    800030e0:	0ef76063          	bltu	a4,a5,800031c0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e4:	0c0b8863          	beqz	s7,800031b4 <writei+0x10e>
    800030e8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ea:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030ee:	5cfd                	li	s9,-1
    800030f0:	a091                	j	80003134 <writei+0x8e>
    800030f2:	02099d93          	slli	s11,s3,0x20
    800030f6:	020ddd93          	srli	s11,s11,0x20
    800030fa:	05848513          	addi	a0,s1,88
    800030fe:	86ee                	mv	a3,s11
    80003100:	8656                	mv	a2,s5
    80003102:	85e2                	mv	a1,s8
    80003104:	953a                	add	a0,a0,a4
    80003106:	fffff097          	auipc	ra,0xfffff
    8000310a:	986080e7          	jalr	-1658(ra) # 80001a8c <either_copyin>
    8000310e:	07950263          	beq	a0,s9,80003172 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003112:	8526                	mv	a0,s1
    80003114:	00000097          	auipc	ra,0x0
    80003118:	790080e7          	jalr	1936(ra) # 800038a4 <log_write>
    brelse(bp);
    8000311c:	8526                	mv	a0,s1
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	50a080e7          	jalr	1290(ra) # 80002628 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003126:	01498a3b          	addw	s4,s3,s4
    8000312a:	0129893b          	addw	s2,s3,s2
    8000312e:	9aee                	add	s5,s5,s11
    80003130:	057a7663          	bgeu	s4,s7,8000317c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003134:	000b2483          	lw	s1,0(s6)
    80003138:	00a9559b          	srliw	a1,s2,0xa
    8000313c:	855a                	mv	a0,s6
    8000313e:	fffff097          	auipc	ra,0xfffff
    80003142:	7ae080e7          	jalr	1966(ra) # 800028ec <bmap>
    80003146:	0005059b          	sext.w	a1,a0
    8000314a:	8526                	mv	a0,s1
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	3ac080e7          	jalr	940(ra) # 800024f8 <bread>
    80003154:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003156:	3ff97713          	andi	a4,s2,1023
    8000315a:	40ed07bb          	subw	a5,s10,a4
    8000315e:	414b86bb          	subw	a3,s7,s4
    80003162:	89be                	mv	s3,a5
    80003164:	2781                	sext.w	a5,a5
    80003166:	0006861b          	sext.w	a2,a3
    8000316a:	f8f674e3          	bgeu	a2,a5,800030f2 <writei+0x4c>
    8000316e:	89b6                	mv	s3,a3
    80003170:	b749                	j	800030f2 <writei+0x4c>
      brelse(bp);
    80003172:	8526                	mv	a0,s1
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	4b4080e7          	jalr	1204(ra) # 80002628 <brelse>
  }

  if(off > ip->size)
    8000317c:	04cb2783          	lw	a5,76(s6)
    80003180:	0127f463          	bgeu	a5,s2,80003188 <writei+0xe2>
    ip->size = off;
    80003184:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003188:	855a                	mv	a0,s6
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	aa6080e7          	jalr	-1370(ra) # 80002c30 <iupdate>

  return tot;
    80003192:	000a051b          	sext.w	a0,s4
}
    80003196:	70a6                	ld	ra,104(sp)
    80003198:	7406                	ld	s0,96(sp)
    8000319a:	64e6                	ld	s1,88(sp)
    8000319c:	6946                	ld	s2,80(sp)
    8000319e:	69a6                	ld	s3,72(sp)
    800031a0:	6a06                	ld	s4,64(sp)
    800031a2:	7ae2                	ld	s5,56(sp)
    800031a4:	7b42                	ld	s6,48(sp)
    800031a6:	7ba2                	ld	s7,40(sp)
    800031a8:	7c02                	ld	s8,32(sp)
    800031aa:	6ce2                	ld	s9,24(sp)
    800031ac:	6d42                	ld	s10,16(sp)
    800031ae:	6da2                	ld	s11,8(sp)
    800031b0:	6165                	addi	sp,sp,112
    800031b2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b4:	8a5e                	mv	s4,s7
    800031b6:	bfc9                	j	80003188 <writei+0xe2>
    return -1;
    800031b8:	557d                	li	a0,-1
}
    800031ba:	8082                	ret
    return -1;
    800031bc:	557d                	li	a0,-1
    800031be:	bfe1                	j	80003196 <writei+0xf0>
    return -1;
    800031c0:	557d                	li	a0,-1
    800031c2:	bfd1                	j	80003196 <writei+0xf0>

00000000800031c4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031c4:	1141                	addi	sp,sp,-16
    800031c6:	e406                	sd	ra,8(sp)
    800031c8:	e022                	sd	s0,0(sp)
    800031ca:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031cc:	4639                	li	a2,14
    800031ce:	ffffd097          	auipc	ra,0xffffd
    800031d2:	082080e7          	jalr	130(ra) # 80000250 <strncmp>
}
    800031d6:	60a2                	ld	ra,8(sp)
    800031d8:	6402                	ld	s0,0(sp)
    800031da:	0141                	addi	sp,sp,16
    800031dc:	8082                	ret

00000000800031de <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031de:	7139                	addi	sp,sp,-64
    800031e0:	fc06                	sd	ra,56(sp)
    800031e2:	f822                	sd	s0,48(sp)
    800031e4:	f426                	sd	s1,40(sp)
    800031e6:	f04a                	sd	s2,32(sp)
    800031e8:	ec4e                	sd	s3,24(sp)
    800031ea:	e852                	sd	s4,16(sp)
    800031ec:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031ee:	04451703          	lh	a4,68(a0)
    800031f2:	4785                	li	a5,1
    800031f4:	00f71a63          	bne	a4,a5,80003208 <dirlookup+0x2a>
    800031f8:	892a                	mv	s2,a0
    800031fa:	89ae                	mv	s3,a1
    800031fc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031fe:	457c                	lw	a5,76(a0)
    80003200:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003202:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003204:	e79d                	bnez	a5,80003232 <dirlookup+0x54>
    80003206:	a8a5                	j	8000327e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003208:	00005517          	auipc	a0,0x5
    8000320c:	3f050513          	addi	a0,a0,1008 # 800085f8 <syscalls+0x1e8>
    80003210:	00003097          	auipc	ra,0x3
    80003214:	bb8080e7          	jalr	-1096(ra) # 80005dc8 <panic>
      panic("dirlookup read");
    80003218:	00005517          	auipc	a0,0x5
    8000321c:	3f850513          	addi	a0,a0,1016 # 80008610 <syscalls+0x200>
    80003220:	00003097          	auipc	ra,0x3
    80003224:	ba8080e7          	jalr	-1112(ra) # 80005dc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	24c1                	addiw	s1,s1,16
    8000322a:	04c92783          	lw	a5,76(s2)
    8000322e:	04f4f763          	bgeu	s1,a5,8000327c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003232:	4741                	li	a4,16
    80003234:	86a6                	mv	a3,s1
    80003236:	fc040613          	addi	a2,s0,-64
    8000323a:	4581                	li	a1,0
    8000323c:	854a                	mv	a0,s2
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	d70080e7          	jalr	-656(ra) # 80002fae <readi>
    80003246:	47c1                	li	a5,16
    80003248:	fcf518e3          	bne	a0,a5,80003218 <dirlookup+0x3a>
    if(de.inum == 0)
    8000324c:	fc045783          	lhu	a5,-64(s0)
    80003250:	dfe1                	beqz	a5,80003228 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003252:	fc240593          	addi	a1,s0,-62
    80003256:	854e                	mv	a0,s3
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	f6c080e7          	jalr	-148(ra) # 800031c4 <namecmp>
    80003260:	f561                	bnez	a0,80003228 <dirlookup+0x4a>
      if(poff)
    80003262:	000a0463          	beqz	s4,8000326a <dirlookup+0x8c>
        *poff = off;
    80003266:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000326a:	fc045583          	lhu	a1,-64(s0)
    8000326e:	00092503          	lw	a0,0(s2)
    80003272:	fffff097          	auipc	ra,0xfffff
    80003276:	754080e7          	jalr	1876(ra) # 800029c6 <iget>
    8000327a:	a011                	j	8000327e <dirlookup+0xa0>
  return 0;
    8000327c:	4501                	li	a0,0
}
    8000327e:	70e2                	ld	ra,56(sp)
    80003280:	7442                	ld	s0,48(sp)
    80003282:	74a2                	ld	s1,40(sp)
    80003284:	7902                	ld	s2,32(sp)
    80003286:	69e2                	ld	s3,24(sp)
    80003288:	6a42                	ld	s4,16(sp)
    8000328a:	6121                	addi	sp,sp,64
    8000328c:	8082                	ret

000000008000328e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000328e:	711d                	addi	sp,sp,-96
    80003290:	ec86                	sd	ra,88(sp)
    80003292:	e8a2                	sd	s0,80(sp)
    80003294:	e4a6                	sd	s1,72(sp)
    80003296:	e0ca                	sd	s2,64(sp)
    80003298:	fc4e                	sd	s3,56(sp)
    8000329a:	f852                	sd	s4,48(sp)
    8000329c:	f456                	sd	s5,40(sp)
    8000329e:	f05a                	sd	s6,32(sp)
    800032a0:	ec5e                	sd	s7,24(sp)
    800032a2:	e862                	sd	s8,16(sp)
    800032a4:	e466                	sd	s9,8(sp)
    800032a6:	1080                	addi	s0,sp,96
    800032a8:	84aa                	mv	s1,a0
    800032aa:	8b2e                	mv	s6,a1
    800032ac:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032ae:	00054703          	lbu	a4,0(a0)
    800032b2:	02f00793          	li	a5,47
    800032b6:	02f70363          	beq	a4,a5,800032dc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ba:	ffffe097          	auipc	ra,0xffffe
    800032be:	c64080e7          	jalr	-924(ra) # 80000f1e <myproc>
    800032c2:	15853503          	ld	a0,344(a0)
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	9f6080e7          	jalr	-1546(ra) # 80002cbc <idup>
    800032ce:	89aa                	mv	s3,a0
  while(*path == '/')
    800032d0:	02f00913          	li	s2,47
  len = path - s;
    800032d4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032d6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032d8:	4c05                	li	s8,1
    800032da:	a865                	j	80003392 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032dc:	4585                	li	a1,1
    800032de:	4505                	li	a0,1
    800032e0:	fffff097          	auipc	ra,0xfffff
    800032e4:	6e6080e7          	jalr	1766(ra) # 800029c6 <iget>
    800032e8:	89aa                	mv	s3,a0
    800032ea:	b7dd                	j	800032d0 <namex+0x42>
      iunlockput(ip);
    800032ec:	854e                	mv	a0,s3
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	c6e080e7          	jalr	-914(ra) # 80002f5c <iunlockput>
      return 0;
    800032f6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032f8:	854e                	mv	a0,s3
    800032fa:	60e6                	ld	ra,88(sp)
    800032fc:	6446                	ld	s0,80(sp)
    800032fe:	64a6                	ld	s1,72(sp)
    80003300:	6906                	ld	s2,64(sp)
    80003302:	79e2                	ld	s3,56(sp)
    80003304:	7a42                	ld	s4,48(sp)
    80003306:	7aa2                	ld	s5,40(sp)
    80003308:	7b02                	ld	s6,32(sp)
    8000330a:	6be2                	ld	s7,24(sp)
    8000330c:	6c42                	ld	s8,16(sp)
    8000330e:	6ca2                	ld	s9,8(sp)
    80003310:	6125                	addi	sp,sp,96
    80003312:	8082                	ret
      iunlock(ip);
    80003314:	854e                	mv	a0,s3
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	aa6080e7          	jalr	-1370(ra) # 80002dbc <iunlock>
      return ip;
    8000331e:	bfe9                	j	800032f8 <namex+0x6a>
      iunlockput(ip);
    80003320:	854e                	mv	a0,s3
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c3a080e7          	jalr	-966(ra) # 80002f5c <iunlockput>
      return 0;
    8000332a:	89d2                	mv	s3,s4
    8000332c:	b7f1                	j	800032f8 <namex+0x6a>
  len = path - s;
    8000332e:	40b48633          	sub	a2,s1,a1
    80003332:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003336:	094cd463          	bge	s9,s4,800033be <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000333a:	4639                	li	a2,14
    8000333c:	8556                	mv	a0,s5
    8000333e:	ffffd097          	auipc	ra,0xffffd
    80003342:	e9a080e7          	jalr	-358(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003346:	0004c783          	lbu	a5,0(s1)
    8000334a:	01279763          	bne	a5,s2,80003358 <namex+0xca>
    path++;
    8000334e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003350:	0004c783          	lbu	a5,0(s1)
    80003354:	ff278de3          	beq	a5,s2,8000334e <namex+0xc0>
    ilock(ip);
    80003358:	854e                	mv	a0,s3
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	9a0080e7          	jalr	-1632(ra) # 80002cfa <ilock>
    if(ip->type != T_DIR){
    80003362:	04499783          	lh	a5,68(s3)
    80003366:	f98793e3          	bne	a5,s8,800032ec <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000336a:	000b0563          	beqz	s6,80003374 <namex+0xe6>
    8000336e:	0004c783          	lbu	a5,0(s1)
    80003372:	d3cd                	beqz	a5,80003314 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003374:	865e                	mv	a2,s7
    80003376:	85d6                	mv	a1,s5
    80003378:	854e                	mv	a0,s3
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	e64080e7          	jalr	-412(ra) # 800031de <dirlookup>
    80003382:	8a2a                	mv	s4,a0
    80003384:	dd51                	beqz	a0,80003320 <namex+0x92>
    iunlockput(ip);
    80003386:	854e                	mv	a0,s3
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	bd4080e7          	jalr	-1068(ra) # 80002f5c <iunlockput>
    ip = next;
    80003390:	89d2                	mv	s3,s4
  while(*path == '/')
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	05279763          	bne	a5,s2,800033e4 <namex+0x156>
    path++;
    8000339a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000339c:	0004c783          	lbu	a5,0(s1)
    800033a0:	ff278de3          	beq	a5,s2,8000339a <namex+0x10c>
  if(*path == 0)
    800033a4:	c79d                	beqz	a5,800033d2 <namex+0x144>
    path++;
    800033a6:	85a6                	mv	a1,s1
  len = path - s;
    800033a8:	8a5e                	mv	s4,s7
    800033aa:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ac:	01278963          	beq	a5,s2,800033be <namex+0x130>
    800033b0:	dfbd                	beqz	a5,8000332e <namex+0xa0>
    path++;
    800033b2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033b4:	0004c783          	lbu	a5,0(s1)
    800033b8:	ff279ce3          	bne	a5,s2,800033b0 <namex+0x122>
    800033bc:	bf8d                	j	8000332e <namex+0xa0>
    memmove(name, s, len);
    800033be:	2601                	sext.w	a2,a2
    800033c0:	8556                	mv	a0,s5
    800033c2:	ffffd097          	auipc	ra,0xffffd
    800033c6:	e16080e7          	jalr	-490(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033ca:	9a56                	add	s4,s4,s5
    800033cc:	000a0023          	sb	zero,0(s4)
    800033d0:	bf9d                	j	80003346 <namex+0xb8>
  if(nameiparent){
    800033d2:	f20b03e3          	beqz	s6,800032f8 <namex+0x6a>
    iput(ip);
    800033d6:	854e                	mv	a0,s3
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	adc080e7          	jalr	-1316(ra) # 80002eb4 <iput>
    return 0;
    800033e0:	4981                	li	s3,0
    800033e2:	bf19                	j	800032f8 <namex+0x6a>
  if(*path == 0)
    800033e4:	d7fd                	beqz	a5,800033d2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033e6:	0004c783          	lbu	a5,0(s1)
    800033ea:	85a6                	mv	a1,s1
    800033ec:	b7d1                	j	800033b0 <namex+0x122>

00000000800033ee <dirlink>:
{
    800033ee:	7139                	addi	sp,sp,-64
    800033f0:	fc06                	sd	ra,56(sp)
    800033f2:	f822                	sd	s0,48(sp)
    800033f4:	f426                	sd	s1,40(sp)
    800033f6:	f04a                	sd	s2,32(sp)
    800033f8:	ec4e                	sd	s3,24(sp)
    800033fa:	e852                	sd	s4,16(sp)
    800033fc:	0080                	addi	s0,sp,64
    800033fe:	892a                	mv	s2,a0
    80003400:	8a2e                	mv	s4,a1
    80003402:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003404:	4601                	li	a2,0
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	dd8080e7          	jalr	-552(ra) # 800031de <dirlookup>
    8000340e:	e93d                	bnez	a0,80003484 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003410:	04c92483          	lw	s1,76(s2)
    80003414:	c49d                	beqz	s1,80003442 <dirlink+0x54>
    80003416:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003418:	4741                	li	a4,16
    8000341a:	86a6                	mv	a3,s1
    8000341c:	fc040613          	addi	a2,s0,-64
    80003420:	4581                	li	a1,0
    80003422:	854a                	mv	a0,s2
    80003424:	00000097          	auipc	ra,0x0
    80003428:	b8a080e7          	jalr	-1142(ra) # 80002fae <readi>
    8000342c:	47c1                	li	a5,16
    8000342e:	06f51163          	bne	a0,a5,80003490 <dirlink+0xa2>
    if(de.inum == 0)
    80003432:	fc045783          	lhu	a5,-64(s0)
    80003436:	c791                	beqz	a5,80003442 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003438:	24c1                	addiw	s1,s1,16
    8000343a:	04c92783          	lw	a5,76(s2)
    8000343e:	fcf4ede3          	bltu	s1,a5,80003418 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003442:	4639                	li	a2,14
    80003444:	85d2                	mv	a1,s4
    80003446:	fc240513          	addi	a0,s0,-62
    8000344a:	ffffd097          	auipc	ra,0xffffd
    8000344e:	e42080e7          	jalr	-446(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003452:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003456:	4741                	li	a4,16
    80003458:	86a6                	mv	a3,s1
    8000345a:	fc040613          	addi	a2,s0,-64
    8000345e:	4581                	li	a1,0
    80003460:	854a                	mv	a0,s2
    80003462:	00000097          	auipc	ra,0x0
    80003466:	c44080e7          	jalr	-956(ra) # 800030a6 <writei>
    8000346a:	872a                	mv	a4,a0
    8000346c:	47c1                	li	a5,16
  return 0;
    8000346e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003470:	02f71863          	bne	a4,a5,800034a0 <dirlink+0xb2>
}
    80003474:	70e2                	ld	ra,56(sp)
    80003476:	7442                	ld	s0,48(sp)
    80003478:	74a2                	ld	s1,40(sp)
    8000347a:	7902                	ld	s2,32(sp)
    8000347c:	69e2                	ld	s3,24(sp)
    8000347e:	6a42                	ld	s4,16(sp)
    80003480:	6121                	addi	sp,sp,64
    80003482:	8082                	ret
    iput(ip);
    80003484:	00000097          	auipc	ra,0x0
    80003488:	a30080e7          	jalr	-1488(ra) # 80002eb4 <iput>
    return -1;
    8000348c:	557d                	li	a0,-1
    8000348e:	b7dd                	j	80003474 <dirlink+0x86>
      panic("dirlink read");
    80003490:	00005517          	auipc	a0,0x5
    80003494:	19050513          	addi	a0,a0,400 # 80008620 <syscalls+0x210>
    80003498:	00003097          	auipc	ra,0x3
    8000349c:	930080e7          	jalr	-1744(ra) # 80005dc8 <panic>
    panic("dirlink");
    800034a0:	00005517          	auipc	a0,0x5
    800034a4:	28850513          	addi	a0,a0,648 # 80008728 <syscalls+0x318>
    800034a8:	00003097          	auipc	ra,0x3
    800034ac:	920080e7          	jalr	-1760(ra) # 80005dc8 <panic>

00000000800034b0 <namei>:

struct inode*
namei(char *path)
{
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034b8:	fe040613          	addi	a2,s0,-32
    800034bc:	4581                	li	a1,0
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	dd0080e7          	jalr	-560(ra) # 8000328e <namex>
}
    800034c6:	60e2                	ld	ra,24(sp)
    800034c8:	6442                	ld	s0,16(sp)
    800034ca:	6105                	addi	sp,sp,32
    800034cc:	8082                	ret

00000000800034ce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034ce:	1141                	addi	sp,sp,-16
    800034d0:	e406                	sd	ra,8(sp)
    800034d2:	e022                	sd	s0,0(sp)
    800034d4:	0800                	addi	s0,sp,16
    800034d6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034d8:	4585                	li	a1,1
    800034da:	00000097          	auipc	ra,0x0
    800034de:	db4080e7          	jalr	-588(ra) # 8000328e <namex>
}
    800034e2:	60a2                	ld	ra,8(sp)
    800034e4:	6402                	ld	s0,0(sp)
    800034e6:	0141                	addi	sp,sp,16
    800034e8:	8082                	ret

00000000800034ea <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ea:	1101                	addi	sp,sp,-32
    800034ec:	ec06                	sd	ra,24(sp)
    800034ee:	e822                	sd	s0,16(sp)
    800034f0:	e426                	sd	s1,8(sp)
    800034f2:	e04a                	sd	s2,0(sp)
    800034f4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034f6:	00016917          	auipc	s2,0x16
    800034fa:	d2a90913          	addi	s2,s2,-726 # 80019220 <log>
    800034fe:	01892583          	lw	a1,24(s2)
    80003502:	02892503          	lw	a0,40(s2)
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	ff2080e7          	jalr	-14(ra) # 800024f8 <bread>
    8000350e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003510:	02c92683          	lw	a3,44(s2)
    80003514:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003516:	02d05763          	blez	a3,80003544 <write_head+0x5a>
    8000351a:	00016797          	auipc	a5,0x16
    8000351e:	d3678793          	addi	a5,a5,-714 # 80019250 <log+0x30>
    80003522:	05c50713          	addi	a4,a0,92
    80003526:	36fd                	addiw	a3,a3,-1
    80003528:	1682                	slli	a3,a3,0x20
    8000352a:	9281                	srli	a3,a3,0x20
    8000352c:	068a                	slli	a3,a3,0x2
    8000352e:	00016617          	auipc	a2,0x16
    80003532:	d2660613          	addi	a2,a2,-730 # 80019254 <log+0x34>
    80003536:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003538:	4390                	lw	a2,0(a5)
    8000353a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000353c:	0791                	addi	a5,a5,4
    8000353e:	0711                	addi	a4,a4,4
    80003540:	fed79ce3          	bne	a5,a3,80003538 <write_head+0x4e>
  }
  bwrite(buf);
    80003544:	8526                	mv	a0,s1
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	0a4080e7          	jalr	164(ra) # 800025ea <bwrite>
  brelse(buf);
    8000354e:	8526                	mv	a0,s1
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	0d8080e7          	jalr	216(ra) # 80002628 <brelse>
}
    80003558:	60e2                	ld	ra,24(sp)
    8000355a:	6442                	ld	s0,16(sp)
    8000355c:	64a2                	ld	s1,8(sp)
    8000355e:	6902                	ld	s2,0(sp)
    80003560:	6105                	addi	sp,sp,32
    80003562:	8082                	ret

0000000080003564 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003564:	00016797          	auipc	a5,0x16
    80003568:	ce87a783          	lw	a5,-792(a5) # 8001924c <log+0x2c>
    8000356c:	0af05d63          	blez	a5,80003626 <install_trans+0xc2>
{
    80003570:	7139                	addi	sp,sp,-64
    80003572:	fc06                	sd	ra,56(sp)
    80003574:	f822                	sd	s0,48(sp)
    80003576:	f426                	sd	s1,40(sp)
    80003578:	f04a                	sd	s2,32(sp)
    8000357a:	ec4e                	sd	s3,24(sp)
    8000357c:	e852                	sd	s4,16(sp)
    8000357e:	e456                	sd	s5,8(sp)
    80003580:	e05a                	sd	s6,0(sp)
    80003582:	0080                	addi	s0,sp,64
    80003584:	8b2a                	mv	s6,a0
    80003586:	00016a97          	auipc	s5,0x16
    8000358a:	ccaa8a93          	addi	s5,s5,-822 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000358e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003590:	00016997          	auipc	s3,0x16
    80003594:	c9098993          	addi	s3,s3,-880 # 80019220 <log>
    80003598:	a035                	j	800035c4 <install_trans+0x60>
      bunpin(dbuf);
    8000359a:	8526                	mv	a0,s1
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	166080e7          	jalr	358(ra) # 80002702 <bunpin>
    brelse(lbuf);
    800035a4:	854a                	mv	a0,s2
    800035a6:	fffff097          	auipc	ra,0xfffff
    800035aa:	082080e7          	jalr	130(ra) # 80002628 <brelse>
    brelse(dbuf);
    800035ae:	8526                	mv	a0,s1
    800035b0:	fffff097          	auipc	ra,0xfffff
    800035b4:	078080e7          	jalr	120(ra) # 80002628 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b8:	2a05                	addiw	s4,s4,1
    800035ba:	0a91                	addi	s5,s5,4
    800035bc:	02c9a783          	lw	a5,44(s3)
    800035c0:	04fa5963          	bge	s4,a5,80003612 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c4:	0189a583          	lw	a1,24(s3)
    800035c8:	014585bb          	addw	a1,a1,s4
    800035cc:	2585                	addiw	a1,a1,1
    800035ce:	0289a503          	lw	a0,40(s3)
    800035d2:	fffff097          	auipc	ra,0xfffff
    800035d6:	f26080e7          	jalr	-218(ra) # 800024f8 <bread>
    800035da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035dc:	000aa583          	lw	a1,0(s5)
    800035e0:	0289a503          	lw	a0,40(s3)
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	f14080e7          	jalr	-236(ra) # 800024f8 <bread>
    800035ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035ee:	40000613          	li	a2,1024
    800035f2:	05890593          	addi	a1,s2,88
    800035f6:	05850513          	addi	a0,a0,88
    800035fa:	ffffd097          	auipc	ra,0xffffd
    800035fe:	bde080e7          	jalr	-1058(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	fe6080e7          	jalr	-26(ra) # 800025ea <bwrite>
    if(recovering == 0)
    8000360c:	f80b1ce3          	bnez	s6,800035a4 <install_trans+0x40>
    80003610:	b769                	j	8000359a <install_trans+0x36>
}
    80003612:	70e2                	ld	ra,56(sp)
    80003614:	7442                	ld	s0,48(sp)
    80003616:	74a2                	ld	s1,40(sp)
    80003618:	7902                	ld	s2,32(sp)
    8000361a:	69e2                	ld	s3,24(sp)
    8000361c:	6a42                	ld	s4,16(sp)
    8000361e:	6aa2                	ld	s5,8(sp)
    80003620:	6b02                	ld	s6,0(sp)
    80003622:	6121                	addi	sp,sp,64
    80003624:	8082                	ret
    80003626:	8082                	ret

0000000080003628 <initlog>:
{
    80003628:	7179                	addi	sp,sp,-48
    8000362a:	f406                	sd	ra,40(sp)
    8000362c:	f022                	sd	s0,32(sp)
    8000362e:	ec26                	sd	s1,24(sp)
    80003630:	e84a                	sd	s2,16(sp)
    80003632:	e44e                	sd	s3,8(sp)
    80003634:	1800                	addi	s0,sp,48
    80003636:	892a                	mv	s2,a0
    80003638:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000363a:	00016497          	auipc	s1,0x16
    8000363e:	be648493          	addi	s1,s1,-1050 # 80019220 <log>
    80003642:	00005597          	auipc	a1,0x5
    80003646:	fee58593          	addi	a1,a1,-18 # 80008630 <syscalls+0x220>
    8000364a:	8526                	mv	a0,s1
    8000364c:	00003097          	auipc	ra,0x3
    80003650:	c36080e7          	jalr	-970(ra) # 80006282 <initlock>
  log.start = sb->logstart;
    80003654:	0149a583          	lw	a1,20(s3)
    80003658:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000365a:	0109a783          	lw	a5,16(s3)
    8000365e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003660:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003664:	854a                	mv	a0,s2
    80003666:	fffff097          	auipc	ra,0xfffff
    8000366a:	e92080e7          	jalr	-366(ra) # 800024f8 <bread>
  log.lh.n = lh->n;
    8000366e:	4d3c                	lw	a5,88(a0)
    80003670:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003672:	02f05563          	blez	a5,8000369c <initlog+0x74>
    80003676:	05c50713          	addi	a4,a0,92
    8000367a:	00016697          	auipc	a3,0x16
    8000367e:	bd668693          	addi	a3,a3,-1066 # 80019250 <log+0x30>
    80003682:	37fd                	addiw	a5,a5,-1
    80003684:	1782                	slli	a5,a5,0x20
    80003686:	9381                	srli	a5,a5,0x20
    80003688:	078a                	slli	a5,a5,0x2
    8000368a:	06050613          	addi	a2,a0,96
    8000368e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003690:	4310                	lw	a2,0(a4)
    80003692:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003694:	0711                	addi	a4,a4,4
    80003696:	0691                	addi	a3,a3,4
    80003698:	fef71ce3          	bne	a4,a5,80003690 <initlog+0x68>
  brelse(buf);
    8000369c:	fffff097          	auipc	ra,0xfffff
    800036a0:	f8c080e7          	jalr	-116(ra) # 80002628 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036a4:	4505                	li	a0,1
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	ebe080e7          	jalr	-322(ra) # 80003564 <install_trans>
  log.lh.n = 0;
    800036ae:	00016797          	auipc	a5,0x16
    800036b2:	b807af23          	sw	zero,-1122(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036b6:	00000097          	auipc	ra,0x0
    800036ba:	e34080e7          	jalr	-460(ra) # 800034ea <write_head>
}
    800036be:	70a2                	ld	ra,40(sp)
    800036c0:	7402                	ld	s0,32(sp)
    800036c2:	64e2                	ld	s1,24(sp)
    800036c4:	6942                	ld	s2,16(sp)
    800036c6:	69a2                	ld	s3,8(sp)
    800036c8:	6145                	addi	sp,sp,48
    800036ca:	8082                	ret

00000000800036cc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036cc:	1101                	addi	sp,sp,-32
    800036ce:	ec06                	sd	ra,24(sp)
    800036d0:	e822                	sd	s0,16(sp)
    800036d2:	e426                	sd	s1,8(sp)
    800036d4:	e04a                	sd	s2,0(sp)
    800036d6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036d8:	00016517          	auipc	a0,0x16
    800036dc:	b4850513          	addi	a0,a0,-1208 # 80019220 <log>
    800036e0:	00003097          	auipc	ra,0x3
    800036e4:	c32080e7          	jalr	-974(ra) # 80006312 <acquire>
  while(1){
    if(log.committing){
    800036e8:	00016497          	auipc	s1,0x16
    800036ec:	b3848493          	addi	s1,s1,-1224 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f0:	4979                	li	s2,30
    800036f2:	a039                	j	80003700 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036f4:	85a6                	mv	a1,s1
    800036f6:	8526                	mv	a0,s1
    800036f8:	ffffe097          	auipc	ra,0xffffe
    800036fc:	f9a080e7          	jalr	-102(ra) # 80001692 <sleep>
    if(log.committing){
    80003700:	50dc                	lw	a5,36(s1)
    80003702:	fbed                	bnez	a5,800036f4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003704:	509c                	lw	a5,32(s1)
    80003706:	0017871b          	addiw	a4,a5,1
    8000370a:	0007069b          	sext.w	a3,a4
    8000370e:	0027179b          	slliw	a5,a4,0x2
    80003712:	9fb9                	addw	a5,a5,a4
    80003714:	0017979b          	slliw	a5,a5,0x1
    80003718:	54d8                	lw	a4,44(s1)
    8000371a:	9fb9                	addw	a5,a5,a4
    8000371c:	00f95963          	bge	s2,a5,8000372e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003720:	85a6                	mv	a1,s1
    80003722:	8526                	mv	a0,s1
    80003724:	ffffe097          	auipc	ra,0xffffe
    80003728:	f6e080e7          	jalr	-146(ra) # 80001692 <sleep>
    8000372c:	bfd1                	j	80003700 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000372e:	00016517          	auipc	a0,0x16
    80003732:	af250513          	addi	a0,a0,-1294 # 80019220 <log>
    80003736:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003738:	00003097          	auipc	ra,0x3
    8000373c:	c8e080e7          	jalr	-882(ra) # 800063c6 <release>
      break;
    }
  }
}
    80003740:	60e2                	ld	ra,24(sp)
    80003742:	6442                	ld	s0,16(sp)
    80003744:	64a2                	ld	s1,8(sp)
    80003746:	6902                	ld	s2,0(sp)
    80003748:	6105                	addi	sp,sp,32
    8000374a:	8082                	ret

000000008000374c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000374c:	7139                	addi	sp,sp,-64
    8000374e:	fc06                	sd	ra,56(sp)
    80003750:	f822                	sd	s0,48(sp)
    80003752:	f426                	sd	s1,40(sp)
    80003754:	f04a                	sd	s2,32(sp)
    80003756:	ec4e                	sd	s3,24(sp)
    80003758:	e852                	sd	s4,16(sp)
    8000375a:	e456                	sd	s5,8(sp)
    8000375c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000375e:	00016497          	auipc	s1,0x16
    80003762:	ac248493          	addi	s1,s1,-1342 # 80019220 <log>
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	baa080e7          	jalr	-1110(ra) # 80006312 <acquire>
  log.outstanding -= 1;
    80003770:	509c                	lw	a5,32(s1)
    80003772:	37fd                	addiw	a5,a5,-1
    80003774:	0007891b          	sext.w	s2,a5
    80003778:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000377a:	50dc                	lw	a5,36(s1)
    8000377c:	efb9                	bnez	a5,800037da <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000377e:	06091663          	bnez	s2,800037ea <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003782:	00016497          	auipc	s1,0x16
    80003786:	a9e48493          	addi	s1,s1,-1378 # 80019220 <log>
    8000378a:	4785                	li	a5,1
    8000378c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000378e:	8526                	mv	a0,s1
    80003790:	00003097          	auipc	ra,0x3
    80003794:	c36080e7          	jalr	-970(ra) # 800063c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003798:	54dc                	lw	a5,44(s1)
    8000379a:	06f04763          	bgtz	a5,80003808 <end_op+0xbc>
    acquire(&log.lock);
    8000379e:	00016497          	auipc	s1,0x16
    800037a2:	a8248493          	addi	s1,s1,-1406 # 80019220 <log>
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	b6a080e7          	jalr	-1174(ra) # 80006312 <acquire>
    log.committing = 0;
    800037b0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037b4:	8526                	mv	a0,s1
    800037b6:	ffffe097          	auipc	ra,0xffffe
    800037ba:	068080e7          	jalr	104(ra) # 8000181e <wakeup>
    release(&log.lock);
    800037be:	8526                	mv	a0,s1
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	c06080e7          	jalr	-1018(ra) # 800063c6 <release>
}
    800037c8:	70e2                	ld	ra,56(sp)
    800037ca:	7442                	ld	s0,48(sp)
    800037cc:	74a2                	ld	s1,40(sp)
    800037ce:	7902                	ld	s2,32(sp)
    800037d0:	69e2                	ld	s3,24(sp)
    800037d2:	6a42                	ld	s4,16(sp)
    800037d4:	6aa2                	ld	s5,8(sp)
    800037d6:	6121                	addi	sp,sp,64
    800037d8:	8082                	ret
    panic("log.committing");
    800037da:	00005517          	auipc	a0,0x5
    800037de:	e5e50513          	addi	a0,a0,-418 # 80008638 <syscalls+0x228>
    800037e2:	00002097          	auipc	ra,0x2
    800037e6:	5e6080e7          	jalr	1510(ra) # 80005dc8 <panic>
    wakeup(&log);
    800037ea:	00016497          	auipc	s1,0x16
    800037ee:	a3648493          	addi	s1,s1,-1482 # 80019220 <log>
    800037f2:	8526                	mv	a0,s1
    800037f4:	ffffe097          	auipc	ra,0xffffe
    800037f8:	02a080e7          	jalr	42(ra) # 8000181e <wakeup>
  release(&log.lock);
    800037fc:	8526                	mv	a0,s1
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	bc8080e7          	jalr	-1080(ra) # 800063c6 <release>
  if(do_commit){
    80003806:	b7c9                	j	800037c8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003808:	00016a97          	auipc	s5,0x16
    8000380c:	a48a8a93          	addi	s5,s5,-1464 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003810:	00016a17          	auipc	s4,0x16
    80003814:	a10a0a13          	addi	s4,s4,-1520 # 80019220 <log>
    80003818:	018a2583          	lw	a1,24(s4)
    8000381c:	012585bb          	addw	a1,a1,s2
    80003820:	2585                	addiw	a1,a1,1
    80003822:	028a2503          	lw	a0,40(s4)
    80003826:	fffff097          	auipc	ra,0xfffff
    8000382a:	cd2080e7          	jalr	-814(ra) # 800024f8 <bread>
    8000382e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003830:	000aa583          	lw	a1,0(s5)
    80003834:	028a2503          	lw	a0,40(s4)
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	cc0080e7          	jalr	-832(ra) # 800024f8 <bread>
    80003840:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003842:	40000613          	li	a2,1024
    80003846:	05850593          	addi	a1,a0,88
    8000384a:	05848513          	addi	a0,s1,88
    8000384e:	ffffd097          	auipc	ra,0xffffd
    80003852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003856:	8526                	mv	a0,s1
    80003858:	fffff097          	auipc	ra,0xfffff
    8000385c:	d92080e7          	jalr	-622(ra) # 800025ea <bwrite>
    brelse(from);
    80003860:	854e                	mv	a0,s3
    80003862:	fffff097          	auipc	ra,0xfffff
    80003866:	dc6080e7          	jalr	-570(ra) # 80002628 <brelse>
    brelse(to);
    8000386a:	8526                	mv	a0,s1
    8000386c:	fffff097          	auipc	ra,0xfffff
    80003870:	dbc080e7          	jalr	-580(ra) # 80002628 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003874:	2905                	addiw	s2,s2,1
    80003876:	0a91                	addi	s5,s5,4
    80003878:	02ca2783          	lw	a5,44(s4)
    8000387c:	f8f94ee3          	blt	s2,a5,80003818 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003880:	00000097          	auipc	ra,0x0
    80003884:	c6a080e7          	jalr	-918(ra) # 800034ea <write_head>
    install_trans(0); // Now install writes to home locations
    80003888:	4501                	li	a0,0
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	cda080e7          	jalr	-806(ra) # 80003564 <install_trans>
    log.lh.n = 0;
    80003892:	00016797          	auipc	a5,0x16
    80003896:	9a07ad23          	sw	zero,-1606(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	c50080e7          	jalr	-944(ra) # 800034ea <write_head>
    800038a2:	bdf5                	j	8000379e <end_op+0x52>

00000000800038a4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038a4:	1101                	addi	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	e04a                	sd	s2,0(sp)
    800038ae:	1000                	addi	s0,sp,32
    800038b0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038b2:	00016917          	auipc	s2,0x16
    800038b6:	96e90913          	addi	s2,s2,-1682 # 80019220 <log>
    800038ba:	854a                	mv	a0,s2
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	a56080e7          	jalr	-1450(ra) # 80006312 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038c4:	02c92603          	lw	a2,44(s2)
    800038c8:	47f5                	li	a5,29
    800038ca:	06c7c563          	blt	a5,a2,80003934 <log_write+0x90>
    800038ce:	00016797          	auipc	a5,0x16
    800038d2:	96e7a783          	lw	a5,-1682(a5) # 8001923c <log+0x1c>
    800038d6:	37fd                	addiw	a5,a5,-1
    800038d8:	04f65e63          	bge	a2,a5,80003934 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038dc:	00016797          	auipc	a5,0x16
    800038e0:	9647a783          	lw	a5,-1692(a5) # 80019240 <log+0x20>
    800038e4:	06f05063          	blez	a5,80003944 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038e8:	4781                	li	a5,0
    800038ea:	06c05563          	blez	a2,80003954 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ee:	44cc                	lw	a1,12(s1)
    800038f0:	00016717          	auipc	a4,0x16
    800038f4:	96070713          	addi	a4,a4,-1696 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038f8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038fa:	4314                	lw	a3,0(a4)
    800038fc:	04b68c63          	beq	a3,a1,80003954 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003900:	2785                	addiw	a5,a5,1
    80003902:	0711                	addi	a4,a4,4
    80003904:	fef61be3          	bne	a2,a5,800038fa <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003908:	0621                	addi	a2,a2,8
    8000390a:	060a                	slli	a2,a2,0x2
    8000390c:	00016797          	auipc	a5,0x16
    80003910:	91478793          	addi	a5,a5,-1772 # 80019220 <log>
    80003914:	963e                	add	a2,a2,a5
    80003916:	44dc                	lw	a5,12(s1)
    80003918:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000391a:	8526                	mv	a0,s1
    8000391c:	fffff097          	auipc	ra,0xfffff
    80003920:	daa080e7          	jalr	-598(ra) # 800026c6 <bpin>
    log.lh.n++;
    80003924:	00016717          	auipc	a4,0x16
    80003928:	8fc70713          	addi	a4,a4,-1796 # 80019220 <log>
    8000392c:	575c                	lw	a5,44(a4)
    8000392e:	2785                	addiw	a5,a5,1
    80003930:	d75c                	sw	a5,44(a4)
    80003932:	a835                	j	8000396e <log_write+0xca>
    panic("too big a transaction");
    80003934:	00005517          	auipc	a0,0x5
    80003938:	d1450513          	addi	a0,a0,-748 # 80008648 <syscalls+0x238>
    8000393c:	00002097          	auipc	ra,0x2
    80003940:	48c080e7          	jalr	1164(ra) # 80005dc8 <panic>
    panic("log_write outside of trans");
    80003944:	00005517          	auipc	a0,0x5
    80003948:	d1c50513          	addi	a0,a0,-740 # 80008660 <syscalls+0x250>
    8000394c:	00002097          	auipc	ra,0x2
    80003950:	47c080e7          	jalr	1148(ra) # 80005dc8 <panic>
  log.lh.block[i] = b->blockno;
    80003954:	00878713          	addi	a4,a5,8
    80003958:	00271693          	slli	a3,a4,0x2
    8000395c:	00016717          	auipc	a4,0x16
    80003960:	8c470713          	addi	a4,a4,-1852 # 80019220 <log>
    80003964:	9736                	add	a4,a4,a3
    80003966:	44d4                	lw	a3,12(s1)
    80003968:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000396a:	faf608e3          	beq	a2,a5,8000391a <log_write+0x76>
  }
  release(&log.lock);
    8000396e:	00016517          	auipc	a0,0x16
    80003972:	8b250513          	addi	a0,a0,-1870 # 80019220 <log>
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	a50080e7          	jalr	-1456(ra) # 800063c6 <release>
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6902                	ld	s2,0(sp)
    80003986:	6105                	addi	sp,sp,32
    80003988:	8082                	ret

000000008000398a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	e04a                	sd	s2,0(sp)
    80003994:	1000                	addi	s0,sp,32
    80003996:	84aa                	mv	s1,a0
    80003998:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000399a:	00005597          	auipc	a1,0x5
    8000399e:	ce658593          	addi	a1,a1,-794 # 80008680 <syscalls+0x270>
    800039a2:	0521                	addi	a0,a0,8
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	8de080e7          	jalr	-1826(ra) # 80006282 <initlock>
  lk->name = name;
    800039ac:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039b0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b4:	0204a423          	sw	zero,40(s1)
}
    800039b8:	60e2                	ld	ra,24(sp)
    800039ba:	6442                	ld	s0,16(sp)
    800039bc:	64a2                	ld	s1,8(sp)
    800039be:	6902                	ld	s2,0(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	e04a                	sd	s2,0(sp)
    800039ce:	1000                	addi	s0,sp,32
    800039d0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039d2:	00850913          	addi	s2,a0,8
    800039d6:	854a                	mv	a0,s2
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	93a080e7          	jalr	-1734(ra) # 80006312 <acquire>
  while (lk->locked) {
    800039e0:	409c                	lw	a5,0(s1)
    800039e2:	cb89                	beqz	a5,800039f4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039e4:	85ca                	mv	a1,s2
    800039e6:	8526                	mv	a0,s1
    800039e8:	ffffe097          	auipc	ra,0xffffe
    800039ec:	caa080e7          	jalr	-854(ra) # 80001692 <sleep>
  while (lk->locked) {
    800039f0:	409c                	lw	a5,0(s1)
    800039f2:	fbed                	bnez	a5,800039e4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039f4:	4785                	li	a5,1
    800039f6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039f8:	ffffd097          	auipc	ra,0xffffd
    800039fc:	526080e7          	jalr	1318(ra) # 80000f1e <myproc>
    80003a00:	5d1c                	lw	a5,56(a0)
    80003a02:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a04:	854a                	mv	a0,s2
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	9c0080e7          	jalr	-1600(ra) # 800063c6 <release>
}
    80003a0e:	60e2                	ld	ra,24(sp)
    80003a10:	6442                	ld	s0,16(sp)
    80003a12:	64a2                	ld	s1,8(sp)
    80003a14:	6902                	ld	s2,0(sp)
    80003a16:	6105                	addi	sp,sp,32
    80003a18:	8082                	ret

0000000080003a1a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a1a:	1101                	addi	sp,sp,-32
    80003a1c:	ec06                	sd	ra,24(sp)
    80003a1e:	e822                	sd	s0,16(sp)
    80003a20:	e426                	sd	s1,8(sp)
    80003a22:	e04a                	sd	s2,0(sp)
    80003a24:	1000                	addi	s0,sp,32
    80003a26:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a28:	00850913          	addi	s2,a0,8
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	8e4080e7          	jalr	-1820(ra) # 80006312 <acquire>
  lk->locked = 0;
    80003a36:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a3a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	ffffe097          	auipc	ra,0xffffe
    80003a44:	dde080e7          	jalr	-546(ra) # 8000181e <wakeup>
  release(&lk->lk);
    80003a48:	854a                	mv	a0,s2
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	97c080e7          	jalr	-1668(ra) # 800063c6 <release>
}
    80003a52:	60e2                	ld	ra,24(sp)
    80003a54:	6442                	ld	s0,16(sp)
    80003a56:	64a2                	ld	s1,8(sp)
    80003a58:	6902                	ld	s2,0(sp)
    80003a5a:	6105                	addi	sp,sp,32
    80003a5c:	8082                	ret

0000000080003a5e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a5e:	7179                	addi	sp,sp,-48
    80003a60:	f406                	sd	ra,40(sp)
    80003a62:	f022                	sd	s0,32(sp)
    80003a64:	ec26                	sd	s1,24(sp)
    80003a66:	e84a                	sd	s2,16(sp)
    80003a68:	e44e                	sd	s3,8(sp)
    80003a6a:	1800                	addi	s0,sp,48
    80003a6c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a6e:	00850913          	addi	s2,a0,8
    80003a72:	854a                	mv	a0,s2
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	89e080e7          	jalr	-1890(ra) # 80006312 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a7c:	409c                	lw	a5,0(s1)
    80003a7e:	ef99                	bnez	a5,80003a9c <holdingsleep+0x3e>
    80003a80:	4481                	li	s1,0
  release(&lk->lk);
    80003a82:	854a                	mv	a0,s2
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	942080e7          	jalr	-1726(ra) # 800063c6 <release>
  return r;
}
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	70a2                	ld	ra,40(sp)
    80003a90:	7402                	ld	s0,32(sp)
    80003a92:	64e2                	ld	s1,24(sp)
    80003a94:	6942                	ld	s2,16(sp)
    80003a96:	69a2                	ld	s3,8(sp)
    80003a98:	6145                	addi	sp,sp,48
    80003a9a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a9c:	0284a983          	lw	s3,40(s1)
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	47e080e7          	jalr	1150(ra) # 80000f1e <myproc>
    80003aa8:	5d04                	lw	s1,56(a0)
    80003aaa:	413484b3          	sub	s1,s1,s3
    80003aae:	0014b493          	seqz	s1,s1
    80003ab2:	bfc1                	j	80003a82 <holdingsleep+0x24>

0000000080003ab4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ab4:	1141                	addi	sp,sp,-16
    80003ab6:	e406                	sd	ra,8(sp)
    80003ab8:	e022                	sd	s0,0(sp)
    80003aba:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003abc:	00005597          	auipc	a1,0x5
    80003ac0:	bd458593          	addi	a1,a1,-1068 # 80008690 <syscalls+0x280>
    80003ac4:	00016517          	auipc	a0,0x16
    80003ac8:	8a450513          	addi	a0,a0,-1884 # 80019368 <ftable>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	7b6080e7          	jalr	1974(ra) # 80006282 <initlock>
}
    80003ad4:	60a2                	ld	ra,8(sp)
    80003ad6:	6402                	ld	s0,0(sp)
    80003ad8:	0141                	addi	sp,sp,16
    80003ada:	8082                	ret

0000000080003adc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003adc:	1101                	addi	sp,sp,-32
    80003ade:	ec06                	sd	ra,24(sp)
    80003ae0:	e822                	sd	s0,16(sp)
    80003ae2:	e426                	sd	s1,8(sp)
    80003ae4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ae6:	00016517          	auipc	a0,0x16
    80003aea:	88250513          	addi	a0,a0,-1918 # 80019368 <ftable>
    80003aee:	00003097          	auipc	ra,0x3
    80003af2:	824080e7          	jalr	-2012(ra) # 80006312 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003af6:	00016497          	auipc	s1,0x16
    80003afa:	88a48493          	addi	s1,s1,-1910 # 80019380 <ftable+0x18>
    80003afe:	00017717          	auipc	a4,0x17
    80003b02:	82270713          	addi	a4,a4,-2014 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b06:	40dc                	lw	a5,4(s1)
    80003b08:	cf99                	beqz	a5,80003b26 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0a:	02848493          	addi	s1,s1,40
    80003b0e:	fee49ce3          	bne	s1,a4,80003b06 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b12:	00016517          	auipc	a0,0x16
    80003b16:	85650513          	addi	a0,a0,-1962 # 80019368 <ftable>
    80003b1a:	00003097          	auipc	ra,0x3
    80003b1e:	8ac080e7          	jalr	-1876(ra) # 800063c6 <release>
  return 0;
    80003b22:	4481                	li	s1,0
    80003b24:	a819                	j	80003b3a <filealloc+0x5e>
      f->ref = 1;
    80003b26:	4785                	li	a5,1
    80003b28:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b2a:	00016517          	auipc	a0,0x16
    80003b2e:	83e50513          	addi	a0,a0,-1986 # 80019368 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	894080e7          	jalr	-1900(ra) # 800063c6 <release>
}
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	60e2                	ld	ra,24(sp)
    80003b3e:	6442                	ld	s0,16(sp)
    80003b40:	64a2                	ld	s1,8(sp)
    80003b42:	6105                	addi	sp,sp,32
    80003b44:	8082                	ret

0000000080003b46 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b46:	1101                	addi	sp,sp,-32
    80003b48:	ec06                	sd	ra,24(sp)
    80003b4a:	e822                	sd	s0,16(sp)
    80003b4c:	e426                	sd	s1,8(sp)
    80003b4e:	1000                	addi	s0,sp,32
    80003b50:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b52:	00016517          	auipc	a0,0x16
    80003b56:	81650513          	addi	a0,a0,-2026 # 80019368 <ftable>
    80003b5a:	00002097          	auipc	ra,0x2
    80003b5e:	7b8080e7          	jalr	1976(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003b62:	40dc                	lw	a5,4(s1)
    80003b64:	02f05263          	blez	a5,80003b88 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b68:	2785                	addiw	a5,a5,1
    80003b6a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b6c:	00015517          	auipc	a0,0x15
    80003b70:	7fc50513          	addi	a0,a0,2044 # 80019368 <ftable>
    80003b74:	00003097          	auipc	ra,0x3
    80003b78:	852080e7          	jalr	-1966(ra) # 800063c6 <release>
  return f;
}
    80003b7c:	8526                	mv	a0,s1
    80003b7e:	60e2                	ld	ra,24(sp)
    80003b80:	6442                	ld	s0,16(sp)
    80003b82:	64a2                	ld	s1,8(sp)
    80003b84:	6105                	addi	sp,sp,32
    80003b86:	8082                	ret
    panic("filedup");
    80003b88:	00005517          	auipc	a0,0x5
    80003b8c:	b1050513          	addi	a0,a0,-1264 # 80008698 <syscalls+0x288>
    80003b90:	00002097          	auipc	ra,0x2
    80003b94:	238080e7          	jalr	568(ra) # 80005dc8 <panic>

0000000080003b98 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b98:	7139                	addi	sp,sp,-64
    80003b9a:	fc06                	sd	ra,56(sp)
    80003b9c:	f822                	sd	s0,48(sp)
    80003b9e:	f426                	sd	s1,40(sp)
    80003ba0:	f04a                	sd	s2,32(sp)
    80003ba2:	ec4e                	sd	s3,24(sp)
    80003ba4:	e852                	sd	s4,16(sp)
    80003ba6:	e456                	sd	s5,8(sp)
    80003ba8:	0080                	addi	s0,sp,64
    80003baa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bac:	00015517          	auipc	a0,0x15
    80003bb0:	7bc50513          	addi	a0,a0,1980 # 80019368 <ftable>
    80003bb4:	00002097          	auipc	ra,0x2
    80003bb8:	75e080e7          	jalr	1886(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003bbc:	40dc                	lw	a5,4(s1)
    80003bbe:	06f05163          	blez	a5,80003c20 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc2:	37fd                	addiw	a5,a5,-1
    80003bc4:	0007871b          	sext.w	a4,a5
    80003bc8:	c0dc                	sw	a5,4(s1)
    80003bca:	06e04363          	bgtz	a4,80003c30 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bce:	0004a903          	lw	s2,0(s1)
    80003bd2:	0094ca83          	lbu	s5,9(s1)
    80003bd6:	0104ba03          	ld	s4,16(s1)
    80003bda:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bde:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003be2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003be6:	00015517          	auipc	a0,0x15
    80003bea:	78250513          	addi	a0,a0,1922 # 80019368 <ftable>
    80003bee:	00002097          	auipc	ra,0x2
    80003bf2:	7d8080e7          	jalr	2008(ra) # 800063c6 <release>

  if(ff.type == FD_PIPE){
    80003bf6:	4785                	li	a5,1
    80003bf8:	04f90d63          	beq	s2,a5,80003c52 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bfc:	3979                	addiw	s2,s2,-2
    80003bfe:	4785                	li	a5,1
    80003c00:	0527e063          	bltu	a5,s2,80003c40 <fileclose+0xa8>
    begin_op();
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	ac8080e7          	jalr	-1336(ra) # 800036cc <begin_op>
    iput(ff.ip);
    80003c0c:	854e                	mv	a0,s3
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	2a6080e7          	jalr	678(ra) # 80002eb4 <iput>
    end_op();
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	b36080e7          	jalr	-1226(ra) # 8000374c <end_op>
    80003c1e:	a00d                	j	80003c40 <fileclose+0xa8>
    panic("fileclose");
    80003c20:	00005517          	auipc	a0,0x5
    80003c24:	a8050513          	addi	a0,a0,-1408 # 800086a0 <syscalls+0x290>
    80003c28:	00002097          	auipc	ra,0x2
    80003c2c:	1a0080e7          	jalr	416(ra) # 80005dc8 <panic>
    release(&ftable.lock);
    80003c30:	00015517          	auipc	a0,0x15
    80003c34:	73850513          	addi	a0,a0,1848 # 80019368 <ftable>
    80003c38:	00002097          	auipc	ra,0x2
    80003c3c:	78e080e7          	jalr	1934(ra) # 800063c6 <release>
  }
}
    80003c40:	70e2                	ld	ra,56(sp)
    80003c42:	7442                	ld	s0,48(sp)
    80003c44:	74a2                	ld	s1,40(sp)
    80003c46:	7902                	ld	s2,32(sp)
    80003c48:	69e2                	ld	s3,24(sp)
    80003c4a:	6a42                	ld	s4,16(sp)
    80003c4c:	6aa2                	ld	s5,8(sp)
    80003c4e:	6121                	addi	sp,sp,64
    80003c50:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c52:	85d6                	mv	a1,s5
    80003c54:	8552                	mv	a0,s4
    80003c56:	00000097          	auipc	ra,0x0
    80003c5a:	34c080e7          	jalr	844(ra) # 80003fa2 <pipeclose>
    80003c5e:	b7cd                	j	80003c40 <fileclose+0xa8>

0000000080003c60 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c60:	715d                	addi	sp,sp,-80
    80003c62:	e486                	sd	ra,72(sp)
    80003c64:	e0a2                	sd	s0,64(sp)
    80003c66:	fc26                	sd	s1,56(sp)
    80003c68:	f84a                	sd	s2,48(sp)
    80003c6a:	f44e                	sd	s3,40(sp)
    80003c6c:	0880                	addi	s0,sp,80
    80003c6e:	84aa                	mv	s1,a0
    80003c70:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c72:	ffffd097          	auipc	ra,0xffffd
    80003c76:	2ac080e7          	jalr	684(ra) # 80000f1e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c7a:	409c                	lw	a5,0(s1)
    80003c7c:	37f9                	addiw	a5,a5,-2
    80003c7e:	4705                	li	a4,1
    80003c80:	04f76763          	bltu	a4,a5,80003cce <filestat+0x6e>
    80003c84:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c86:	6c88                	ld	a0,24(s1)
    80003c88:	fffff097          	auipc	ra,0xfffff
    80003c8c:	072080e7          	jalr	114(ra) # 80002cfa <ilock>
    stati(f->ip, &st);
    80003c90:	fb840593          	addi	a1,s0,-72
    80003c94:	6c88                	ld	a0,24(s1)
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	2ee080e7          	jalr	750(ra) # 80002f84 <stati>
    iunlock(f->ip);
    80003c9e:	6c88                	ld	a0,24(s1)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	11c080e7          	jalr	284(ra) # 80002dbc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ca8:	46e1                	li	a3,24
    80003caa:	fb840613          	addi	a2,s0,-72
    80003cae:	85ce                	mv	a1,s3
    80003cb0:	05893503          	ld	a0,88(s2)
    80003cb4:	ffffd097          	auipc	ra,0xffffd
    80003cb8:	e56080e7          	jalr	-426(ra) # 80000b0a <copyout>
    80003cbc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cc0:	60a6                	ld	ra,72(sp)
    80003cc2:	6406                	ld	s0,64(sp)
    80003cc4:	74e2                	ld	s1,56(sp)
    80003cc6:	7942                	ld	s2,48(sp)
    80003cc8:	79a2                	ld	s3,40(sp)
    80003cca:	6161                	addi	sp,sp,80
    80003ccc:	8082                	ret
  return -1;
    80003cce:	557d                	li	a0,-1
    80003cd0:	bfc5                	j	80003cc0 <filestat+0x60>

0000000080003cd2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cd2:	7179                	addi	sp,sp,-48
    80003cd4:	f406                	sd	ra,40(sp)
    80003cd6:	f022                	sd	s0,32(sp)
    80003cd8:	ec26                	sd	s1,24(sp)
    80003cda:	e84a                	sd	s2,16(sp)
    80003cdc:	e44e                	sd	s3,8(sp)
    80003cde:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ce0:	00854783          	lbu	a5,8(a0)
    80003ce4:	c3d5                	beqz	a5,80003d88 <fileread+0xb6>
    80003ce6:	84aa                	mv	s1,a0
    80003ce8:	89ae                	mv	s3,a1
    80003cea:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cec:	411c                	lw	a5,0(a0)
    80003cee:	4705                	li	a4,1
    80003cf0:	04e78963          	beq	a5,a4,80003d42 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cf4:	470d                	li	a4,3
    80003cf6:	04e78d63          	beq	a5,a4,80003d50 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cfa:	4709                	li	a4,2
    80003cfc:	06e79e63          	bne	a5,a4,80003d78 <fileread+0xa6>
    ilock(f->ip);
    80003d00:	6d08                	ld	a0,24(a0)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	ff8080e7          	jalr	-8(ra) # 80002cfa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d0a:	874a                	mv	a4,s2
    80003d0c:	5094                	lw	a3,32(s1)
    80003d0e:	864e                	mv	a2,s3
    80003d10:	4585                	li	a1,1
    80003d12:	6c88                	ld	a0,24(s1)
    80003d14:	fffff097          	auipc	ra,0xfffff
    80003d18:	29a080e7          	jalr	666(ra) # 80002fae <readi>
    80003d1c:	892a                	mv	s2,a0
    80003d1e:	00a05563          	blez	a0,80003d28 <fileread+0x56>
      f->off += r;
    80003d22:	509c                	lw	a5,32(s1)
    80003d24:	9fa9                	addw	a5,a5,a0
    80003d26:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d28:	6c88                	ld	a0,24(s1)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	092080e7          	jalr	146(ra) # 80002dbc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d32:	854a                	mv	a0,s2
    80003d34:	70a2                	ld	ra,40(sp)
    80003d36:	7402                	ld	s0,32(sp)
    80003d38:	64e2                	ld	s1,24(sp)
    80003d3a:	6942                	ld	s2,16(sp)
    80003d3c:	69a2                	ld	s3,8(sp)
    80003d3e:	6145                	addi	sp,sp,48
    80003d40:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d42:	6908                	ld	a0,16(a0)
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	3c8080e7          	jalr	968(ra) # 8000410c <piperead>
    80003d4c:	892a                	mv	s2,a0
    80003d4e:	b7d5                	j	80003d32 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d50:	02451783          	lh	a5,36(a0)
    80003d54:	03079693          	slli	a3,a5,0x30
    80003d58:	92c1                	srli	a3,a3,0x30
    80003d5a:	4725                	li	a4,9
    80003d5c:	02d76863          	bltu	a4,a3,80003d8c <fileread+0xba>
    80003d60:	0792                	slli	a5,a5,0x4
    80003d62:	00015717          	auipc	a4,0x15
    80003d66:	56670713          	addi	a4,a4,1382 # 800192c8 <devsw>
    80003d6a:	97ba                	add	a5,a5,a4
    80003d6c:	639c                	ld	a5,0(a5)
    80003d6e:	c38d                	beqz	a5,80003d90 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d70:	4505                	li	a0,1
    80003d72:	9782                	jalr	a5
    80003d74:	892a                	mv	s2,a0
    80003d76:	bf75                	j	80003d32 <fileread+0x60>
    panic("fileread");
    80003d78:	00005517          	auipc	a0,0x5
    80003d7c:	93850513          	addi	a0,a0,-1736 # 800086b0 <syscalls+0x2a0>
    80003d80:	00002097          	auipc	ra,0x2
    80003d84:	048080e7          	jalr	72(ra) # 80005dc8 <panic>
    return -1;
    80003d88:	597d                	li	s2,-1
    80003d8a:	b765                	j	80003d32 <fileread+0x60>
      return -1;
    80003d8c:	597d                	li	s2,-1
    80003d8e:	b755                	j	80003d32 <fileread+0x60>
    80003d90:	597d                	li	s2,-1
    80003d92:	b745                	j	80003d32 <fileread+0x60>

0000000080003d94 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d94:	715d                	addi	sp,sp,-80
    80003d96:	e486                	sd	ra,72(sp)
    80003d98:	e0a2                	sd	s0,64(sp)
    80003d9a:	fc26                	sd	s1,56(sp)
    80003d9c:	f84a                	sd	s2,48(sp)
    80003d9e:	f44e                	sd	s3,40(sp)
    80003da0:	f052                	sd	s4,32(sp)
    80003da2:	ec56                	sd	s5,24(sp)
    80003da4:	e85a                	sd	s6,16(sp)
    80003da6:	e45e                	sd	s7,8(sp)
    80003da8:	e062                	sd	s8,0(sp)
    80003daa:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dac:	00954783          	lbu	a5,9(a0)
    80003db0:	10078663          	beqz	a5,80003ebc <filewrite+0x128>
    80003db4:	892a                	mv	s2,a0
    80003db6:	8aae                	mv	s5,a1
    80003db8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dba:	411c                	lw	a5,0(a0)
    80003dbc:	4705                	li	a4,1
    80003dbe:	02e78263          	beq	a5,a4,80003de2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dc2:	470d                	li	a4,3
    80003dc4:	02e78663          	beq	a5,a4,80003df0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dc8:	4709                	li	a4,2
    80003dca:	0ee79163          	bne	a5,a4,80003eac <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dce:	0ac05d63          	blez	a2,80003e88 <filewrite+0xf4>
    int i = 0;
    80003dd2:	4981                	li	s3,0
    80003dd4:	6b05                	lui	s6,0x1
    80003dd6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dda:	6b85                	lui	s7,0x1
    80003ddc:	c00b8b9b          	addiw	s7,s7,-1024
    80003de0:	a861                	j	80003e78 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003de2:	6908                	ld	a0,16(a0)
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	22e080e7          	jalr	558(ra) # 80004012 <pipewrite>
    80003dec:	8a2a                	mv	s4,a0
    80003dee:	a045                	j	80003e8e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003df0:	02451783          	lh	a5,36(a0)
    80003df4:	03079693          	slli	a3,a5,0x30
    80003df8:	92c1                	srli	a3,a3,0x30
    80003dfa:	4725                	li	a4,9
    80003dfc:	0cd76263          	bltu	a4,a3,80003ec0 <filewrite+0x12c>
    80003e00:	0792                	slli	a5,a5,0x4
    80003e02:	00015717          	auipc	a4,0x15
    80003e06:	4c670713          	addi	a4,a4,1222 # 800192c8 <devsw>
    80003e0a:	97ba                	add	a5,a5,a4
    80003e0c:	679c                	ld	a5,8(a5)
    80003e0e:	cbdd                	beqz	a5,80003ec4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e10:	4505                	li	a0,1
    80003e12:	9782                	jalr	a5
    80003e14:	8a2a                	mv	s4,a0
    80003e16:	a8a5                	j	80003e8e <filewrite+0xfa>
    80003e18:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	8b0080e7          	jalr	-1872(ra) # 800036cc <begin_op>
      ilock(f->ip);
    80003e24:	01893503          	ld	a0,24(s2)
    80003e28:	fffff097          	auipc	ra,0xfffff
    80003e2c:	ed2080e7          	jalr	-302(ra) # 80002cfa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e30:	8762                	mv	a4,s8
    80003e32:	02092683          	lw	a3,32(s2)
    80003e36:	01598633          	add	a2,s3,s5
    80003e3a:	4585                	li	a1,1
    80003e3c:	01893503          	ld	a0,24(s2)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	266080e7          	jalr	614(ra) # 800030a6 <writei>
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	00a05763          	blez	a0,80003e58 <filewrite+0xc4>
        f->off += r;
    80003e4e:	02092783          	lw	a5,32(s2)
    80003e52:	9fa9                	addw	a5,a5,a0
    80003e54:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e58:	01893503          	ld	a0,24(s2)
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	f60080e7          	jalr	-160(ra) # 80002dbc <iunlock>
      end_op();
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	8e8080e7          	jalr	-1816(ra) # 8000374c <end_op>

      if(r != n1){
    80003e6c:	009c1f63          	bne	s8,s1,80003e8a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e70:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e74:	0149db63          	bge	s3,s4,80003e8a <filewrite+0xf6>
      int n1 = n - i;
    80003e78:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e7c:	84be                	mv	s1,a5
    80003e7e:	2781                	sext.w	a5,a5
    80003e80:	f8fb5ce3          	bge	s6,a5,80003e18 <filewrite+0x84>
    80003e84:	84de                	mv	s1,s7
    80003e86:	bf49                	j	80003e18 <filewrite+0x84>
    int i = 0;
    80003e88:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e8a:	013a1f63          	bne	s4,s3,80003ea8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e8e:	8552                	mv	a0,s4
    80003e90:	60a6                	ld	ra,72(sp)
    80003e92:	6406                	ld	s0,64(sp)
    80003e94:	74e2                	ld	s1,56(sp)
    80003e96:	7942                	ld	s2,48(sp)
    80003e98:	79a2                	ld	s3,40(sp)
    80003e9a:	7a02                	ld	s4,32(sp)
    80003e9c:	6ae2                	ld	s5,24(sp)
    80003e9e:	6b42                	ld	s6,16(sp)
    80003ea0:	6ba2                	ld	s7,8(sp)
    80003ea2:	6c02                	ld	s8,0(sp)
    80003ea4:	6161                	addi	sp,sp,80
    80003ea6:	8082                	ret
    ret = (i == n ? n : -1);
    80003ea8:	5a7d                	li	s4,-1
    80003eaa:	b7d5                	j	80003e8e <filewrite+0xfa>
    panic("filewrite");
    80003eac:	00005517          	auipc	a0,0x5
    80003eb0:	81450513          	addi	a0,a0,-2028 # 800086c0 <syscalls+0x2b0>
    80003eb4:	00002097          	auipc	ra,0x2
    80003eb8:	f14080e7          	jalr	-236(ra) # 80005dc8 <panic>
    return -1;
    80003ebc:	5a7d                	li	s4,-1
    80003ebe:	bfc1                	j	80003e8e <filewrite+0xfa>
      return -1;
    80003ec0:	5a7d                	li	s4,-1
    80003ec2:	b7f1                	j	80003e8e <filewrite+0xfa>
    80003ec4:	5a7d                	li	s4,-1
    80003ec6:	b7e1                	j	80003e8e <filewrite+0xfa>

0000000080003ec8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ec8:	7179                	addi	sp,sp,-48
    80003eca:	f406                	sd	ra,40(sp)
    80003ecc:	f022                	sd	s0,32(sp)
    80003ece:	ec26                	sd	s1,24(sp)
    80003ed0:	e84a                	sd	s2,16(sp)
    80003ed2:	e44e                	sd	s3,8(sp)
    80003ed4:	e052                	sd	s4,0(sp)
    80003ed6:	1800                	addi	s0,sp,48
    80003ed8:	84aa                	mv	s1,a0
    80003eda:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003edc:	0005b023          	sd	zero,0(a1)
    80003ee0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	bf8080e7          	jalr	-1032(ra) # 80003adc <filealloc>
    80003eec:	e088                	sd	a0,0(s1)
    80003eee:	c551                	beqz	a0,80003f7a <pipealloc+0xb2>
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	bec080e7          	jalr	-1044(ra) # 80003adc <filealloc>
    80003ef8:	00aa3023          	sd	a0,0(s4)
    80003efc:	c92d                	beqz	a0,80003f6e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003efe:	ffffc097          	auipc	ra,0xffffc
    80003f02:	21a080e7          	jalr	538(ra) # 80000118 <kalloc>
    80003f06:	892a                	mv	s2,a0
    80003f08:	c125                	beqz	a0,80003f68 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f0a:	4985                	li	s3,1
    80003f0c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f10:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f14:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f18:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f1c:	00004597          	auipc	a1,0x4
    80003f20:	7b458593          	addi	a1,a1,1972 # 800086d0 <syscalls+0x2c0>
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	35e080e7          	jalr	862(ra) # 80006282 <initlock>
  (*f0)->type = FD_PIPE;
    80003f2c:	609c                	ld	a5,0(s1)
    80003f2e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f32:	609c                	ld	a5,0(s1)
    80003f34:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f38:	609c                	ld	a5,0(s1)
    80003f3a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f3e:	609c                	ld	a5,0(s1)
    80003f40:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f44:	000a3783          	ld	a5,0(s4)
    80003f48:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f4c:	000a3783          	ld	a5,0(s4)
    80003f50:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f54:	000a3783          	ld	a5,0(s4)
    80003f58:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f5c:	000a3783          	ld	a5,0(s4)
    80003f60:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f64:	4501                	li	a0,0
    80003f66:	a025                	j	80003f8e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f68:	6088                	ld	a0,0(s1)
    80003f6a:	e501                	bnez	a0,80003f72 <pipealloc+0xaa>
    80003f6c:	a039                	j	80003f7a <pipealloc+0xb2>
    80003f6e:	6088                	ld	a0,0(s1)
    80003f70:	c51d                	beqz	a0,80003f9e <pipealloc+0xd6>
    fileclose(*f0);
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	c26080e7          	jalr	-986(ra) # 80003b98 <fileclose>
  if(*f1)
    80003f7a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f7e:	557d                	li	a0,-1
  if(*f1)
    80003f80:	c799                	beqz	a5,80003f8e <pipealloc+0xc6>
    fileclose(*f1);
    80003f82:	853e                	mv	a0,a5
    80003f84:	00000097          	auipc	ra,0x0
    80003f88:	c14080e7          	jalr	-1004(ra) # 80003b98 <fileclose>
  return -1;
    80003f8c:	557d                	li	a0,-1
}
    80003f8e:	70a2                	ld	ra,40(sp)
    80003f90:	7402                	ld	s0,32(sp)
    80003f92:	64e2                	ld	s1,24(sp)
    80003f94:	6942                	ld	s2,16(sp)
    80003f96:	69a2                	ld	s3,8(sp)
    80003f98:	6a02                	ld	s4,0(sp)
    80003f9a:	6145                	addi	sp,sp,48
    80003f9c:	8082                	ret
  return -1;
    80003f9e:	557d                	li	a0,-1
    80003fa0:	b7fd                	j	80003f8e <pipealloc+0xc6>

0000000080003fa2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fa2:	1101                	addi	sp,sp,-32
    80003fa4:	ec06                	sd	ra,24(sp)
    80003fa6:	e822                	sd	s0,16(sp)
    80003fa8:	e426                	sd	s1,8(sp)
    80003faa:	e04a                	sd	s2,0(sp)
    80003fac:	1000                	addi	s0,sp,32
    80003fae:	84aa                	mv	s1,a0
    80003fb0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fb2:	00002097          	auipc	ra,0x2
    80003fb6:	360080e7          	jalr	864(ra) # 80006312 <acquire>
  if(writable){
    80003fba:	02090d63          	beqz	s2,80003ff4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fbe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fc2:	21848513          	addi	a0,s1,536
    80003fc6:	ffffe097          	auipc	ra,0xffffe
    80003fca:	858080e7          	jalr	-1960(ra) # 8000181e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fce:	2204b783          	ld	a5,544(s1)
    80003fd2:	eb95                	bnez	a5,80004006 <pipeclose+0x64>
    release(&pi->lock);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	3f0080e7          	jalr	1008(ra) # 800063c6 <release>
    kfree((char*)pi);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	ffffc097          	auipc	ra,0xffffc
    80003fe4:	03c080e7          	jalr	60(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fe8:	60e2                	ld	ra,24(sp)
    80003fea:	6442                	ld	s0,16(sp)
    80003fec:	64a2                	ld	s1,8(sp)
    80003fee:	6902                	ld	s2,0(sp)
    80003ff0:	6105                	addi	sp,sp,32
    80003ff2:	8082                	ret
    pi->readopen = 0;
    80003ff4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ff8:	21c48513          	addi	a0,s1,540
    80003ffc:	ffffe097          	auipc	ra,0xffffe
    80004000:	822080e7          	jalr	-2014(ra) # 8000181e <wakeup>
    80004004:	b7e9                	j	80003fce <pipeclose+0x2c>
    release(&pi->lock);
    80004006:	8526                	mv	a0,s1
    80004008:	00002097          	auipc	ra,0x2
    8000400c:	3be080e7          	jalr	958(ra) # 800063c6 <release>
}
    80004010:	bfe1                	j	80003fe8 <pipeclose+0x46>

0000000080004012 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004012:	7159                	addi	sp,sp,-112
    80004014:	f486                	sd	ra,104(sp)
    80004016:	f0a2                	sd	s0,96(sp)
    80004018:	eca6                	sd	s1,88(sp)
    8000401a:	e8ca                	sd	s2,80(sp)
    8000401c:	e4ce                	sd	s3,72(sp)
    8000401e:	e0d2                	sd	s4,64(sp)
    80004020:	fc56                	sd	s5,56(sp)
    80004022:	f85a                	sd	s6,48(sp)
    80004024:	f45e                	sd	s7,40(sp)
    80004026:	f062                	sd	s8,32(sp)
    80004028:	ec66                	sd	s9,24(sp)
    8000402a:	1880                	addi	s0,sp,112
    8000402c:	84aa                	mv	s1,a0
    8000402e:	8aae                	mv	s5,a1
    80004030:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	eec080e7          	jalr	-276(ra) # 80000f1e <myproc>
    8000403a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000403c:	8526                	mv	a0,s1
    8000403e:	00002097          	auipc	ra,0x2
    80004042:	2d4080e7          	jalr	724(ra) # 80006312 <acquire>
  while(i < n){
    80004046:	0d405163          	blez	s4,80004108 <pipewrite+0xf6>
    8000404a:	8ba6                	mv	s7,s1
  int i = 0;
    8000404c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000404e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004050:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004054:	21c48c13          	addi	s8,s1,540
    80004058:	a08d                	j	800040ba <pipewrite+0xa8>
      release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	36a080e7          	jalr	874(ra) # 800063c6 <release>
      return -1;
    80004064:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004066:	854a                	mv	a0,s2
    80004068:	70a6                	ld	ra,104(sp)
    8000406a:	7406                	ld	s0,96(sp)
    8000406c:	64e6                	ld	s1,88(sp)
    8000406e:	6946                	ld	s2,80(sp)
    80004070:	69a6                	ld	s3,72(sp)
    80004072:	6a06                	ld	s4,64(sp)
    80004074:	7ae2                	ld	s5,56(sp)
    80004076:	7b42                	ld	s6,48(sp)
    80004078:	7ba2                	ld	s7,40(sp)
    8000407a:	7c02                	ld	s8,32(sp)
    8000407c:	6ce2                	ld	s9,24(sp)
    8000407e:	6165                	addi	sp,sp,112
    80004080:	8082                	ret
      wakeup(&pi->nread);
    80004082:	8566                	mv	a0,s9
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	79a080e7          	jalr	1946(ra) # 8000181e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000408c:	85de                	mv	a1,s7
    8000408e:	8562                	mv	a0,s8
    80004090:	ffffd097          	auipc	ra,0xffffd
    80004094:	602080e7          	jalr	1538(ra) # 80001692 <sleep>
    80004098:	a839                	j	800040b6 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000409a:	21c4a783          	lw	a5,540(s1)
    8000409e:	0017871b          	addiw	a4,a5,1
    800040a2:	20e4ae23          	sw	a4,540(s1)
    800040a6:	1ff7f793          	andi	a5,a5,511
    800040aa:	97a6                	add	a5,a5,s1
    800040ac:	f9f44703          	lbu	a4,-97(s0)
    800040b0:	00e78c23          	sb	a4,24(a5)
      i++;
    800040b4:	2905                	addiw	s2,s2,1
  while(i < n){
    800040b6:	03495d63          	bge	s2,s4,800040f0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040ba:	2204a783          	lw	a5,544(s1)
    800040be:	dfd1                	beqz	a5,8000405a <pipewrite+0x48>
    800040c0:	0309a783          	lw	a5,48(s3)
    800040c4:	fbd9                	bnez	a5,8000405a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040c6:	2184a783          	lw	a5,536(s1)
    800040ca:	21c4a703          	lw	a4,540(s1)
    800040ce:	2007879b          	addiw	a5,a5,512
    800040d2:	faf708e3          	beq	a4,a5,80004082 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040d6:	4685                	li	a3,1
    800040d8:	01590633          	add	a2,s2,s5
    800040dc:	f9f40593          	addi	a1,s0,-97
    800040e0:	0589b503          	ld	a0,88(s3)
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	ab2080e7          	jalr	-1358(ra) # 80000b96 <copyin>
    800040ec:	fb6517e3          	bne	a0,s6,8000409a <pipewrite+0x88>
  wakeup(&pi->nread);
    800040f0:	21848513          	addi	a0,s1,536
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	72a080e7          	jalr	1834(ra) # 8000181e <wakeup>
  release(&pi->lock);
    800040fc:	8526                	mv	a0,s1
    800040fe:	00002097          	auipc	ra,0x2
    80004102:	2c8080e7          	jalr	712(ra) # 800063c6 <release>
  return i;
    80004106:	b785                	j	80004066 <pipewrite+0x54>
  int i = 0;
    80004108:	4901                	li	s2,0
    8000410a:	b7dd                	j	800040f0 <pipewrite+0xde>

000000008000410c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000410c:	715d                	addi	sp,sp,-80
    8000410e:	e486                	sd	ra,72(sp)
    80004110:	e0a2                	sd	s0,64(sp)
    80004112:	fc26                	sd	s1,56(sp)
    80004114:	f84a                	sd	s2,48(sp)
    80004116:	f44e                	sd	s3,40(sp)
    80004118:	f052                	sd	s4,32(sp)
    8000411a:	ec56                	sd	s5,24(sp)
    8000411c:	e85a                	sd	s6,16(sp)
    8000411e:	0880                	addi	s0,sp,80
    80004120:	84aa                	mv	s1,a0
    80004122:	892e                	mv	s2,a1
    80004124:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	df8080e7          	jalr	-520(ra) # 80000f1e <myproc>
    8000412e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004130:	8b26                	mv	s6,s1
    80004132:	8526                	mv	a0,s1
    80004134:	00002097          	auipc	ra,0x2
    80004138:	1de080e7          	jalr	478(ra) # 80006312 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000413c:	2184a703          	lw	a4,536(s1)
    80004140:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004144:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004148:	02f71463          	bne	a4,a5,80004170 <piperead+0x64>
    8000414c:	2244a783          	lw	a5,548(s1)
    80004150:	c385                	beqz	a5,80004170 <piperead+0x64>
    if(pr->killed){
    80004152:	030a2783          	lw	a5,48(s4)
    80004156:	ebc1                	bnez	a5,800041e6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004158:	85da                	mv	a1,s6
    8000415a:	854e                	mv	a0,s3
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	536080e7          	jalr	1334(ra) # 80001692 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004164:	2184a703          	lw	a4,536(s1)
    80004168:	21c4a783          	lw	a5,540(s1)
    8000416c:	fef700e3          	beq	a4,a5,8000414c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004170:	09505263          	blez	s5,800041f4 <piperead+0xe8>
    80004174:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004176:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004178:	2184a783          	lw	a5,536(s1)
    8000417c:	21c4a703          	lw	a4,540(s1)
    80004180:	02f70d63          	beq	a4,a5,800041ba <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004184:	0017871b          	addiw	a4,a5,1
    80004188:	20e4ac23          	sw	a4,536(s1)
    8000418c:	1ff7f793          	andi	a5,a5,511
    80004190:	97a6                	add	a5,a5,s1
    80004192:	0187c783          	lbu	a5,24(a5)
    80004196:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000419a:	4685                	li	a3,1
    8000419c:	fbf40613          	addi	a2,s0,-65
    800041a0:	85ca                	mv	a1,s2
    800041a2:	058a3503          	ld	a0,88(s4)
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	964080e7          	jalr	-1692(ra) # 80000b0a <copyout>
    800041ae:	01650663          	beq	a0,s6,800041ba <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041b2:	2985                	addiw	s3,s3,1
    800041b4:	0905                	addi	s2,s2,1
    800041b6:	fd3a91e3          	bne	s5,s3,80004178 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ba:	21c48513          	addi	a0,s1,540
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	660080e7          	jalr	1632(ra) # 8000181e <wakeup>
  release(&pi->lock);
    800041c6:	8526                	mv	a0,s1
    800041c8:	00002097          	auipc	ra,0x2
    800041cc:	1fe080e7          	jalr	510(ra) # 800063c6 <release>
  return i;
}
    800041d0:	854e                	mv	a0,s3
    800041d2:	60a6                	ld	ra,72(sp)
    800041d4:	6406                	ld	s0,64(sp)
    800041d6:	74e2                	ld	s1,56(sp)
    800041d8:	7942                	ld	s2,48(sp)
    800041da:	79a2                	ld	s3,40(sp)
    800041dc:	7a02                	ld	s4,32(sp)
    800041de:	6ae2                	ld	s5,24(sp)
    800041e0:	6b42                	ld	s6,16(sp)
    800041e2:	6161                	addi	sp,sp,80
    800041e4:	8082                	ret
      release(&pi->lock);
    800041e6:	8526                	mv	a0,s1
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	1de080e7          	jalr	478(ra) # 800063c6 <release>
      return -1;
    800041f0:	59fd                	li	s3,-1
    800041f2:	bff9                	j	800041d0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f4:	4981                	li	s3,0
    800041f6:	b7d1                	j	800041ba <piperead+0xae>

00000000800041f8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041f8:	df010113          	addi	sp,sp,-528
    800041fc:	20113423          	sd	ra,520(sp)
    80004200:	20813023          	sd	s0,512(sp)
    80004204:	ffa6                	sd	s1,504(sp)
    80004206:	fbca                	sd	s2,496(sp)
    80004208:	f7ce                	sd	s3,488(sp)
    8000420a:	f3d2                	sd	s4,480(sp)
    8000420c:	efd6                	sd	s5,472(sp)
    8000420e:	ebda                	sd	s6,464(sp)
    80004210:	e7de                	sd	s7,456(sp)
    80004212:	e3e2                	sd	s8,448(sp)
    80004214:	ff66                	sd	s9,440(sp)
    80004216:	fb6a                	sd	s10,432(sp)
    80004218:	f76e                	sd	s11,424(sp)
    8000421a:	0c00                	addi	s0,sp,528
    8000421c:	84aa                	mv	s1,a0
    8000421e:	dea43c23          	sd	a0,-520(s0)
    80004222:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	cf8080e7          	jalr	-776(ra) # 80000f1e <myproc>
    8000422e:	892a                	mv	s2,a0

  begin_op();
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	49c080e7          	jalr	1180(ra) # 800036cc <begin_op>

  if((ip = namei(path)) == 0){
    80004238:	8526                	mv	a0,s1
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	276080e7          	jalr	630(ra) # 800034b0 <namei>
    80004242:	c92d                	beqz	a0,800042b4 <exec+0xbc>
    80004244:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	ab4080e7          	jalr	-1356(ra) # 80002cfa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000424e:	04000713          	li	a4,64
    80004252:	4681                	li	a3,0
    80004254:	e5040613          	addi	a2,s0,-432
    80004258:	4581                	li	a1,0
    8000425a:	8526                	mv	a0,s1
    8000425c:	fffff097          	auipc	ra,0xfffff
    80004260:	d52080e7          	jalr	-686(ra) # 80002fae <readi>
    80004264:	04000793          	li	a5,64
    80004268:	00f51a63          	bne	a0,a5,8000427c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000426c:	e5042703          	lw	a4,-432(s0)
    80004270:	464c47b7          	lui	a5,0x464c4
    80004274:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004278:	04f70463          	beq	a4,a5,800042c0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000427c:	8526                	mv	a0,s1
    8000427e:	fffff097          	auipc	ra,0xfffff
    80004282:	cde080e7          	jalr	-802(ra) # 80002f5c <iunlockput>
    end_op();
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	4c6080e7          	jalr	1222(ra) # 8000374c <end_op>
  }
  return -1;
    8000428e:	557d                	li	a0,-1
}
    80004290:	20813083          	ld	ra,520(sp)
    80004294:	20013403          	ld	s0,512(sp)
    80004298:	74fe                	ld	s1,504(sp)
    8000429a:	795e                	ld	s2,496(sp)
    8000429c:	79be                	ld	s3,488(sp)
    8000429e:	7a1e                	ld	s4,480(sp)
    800042a0:	6afe                	ld	s5,472(sp)
    800042a2:	6b5e                	ld	s6,464(sp)
    800042a4:	6bbe                	ld	s7,456(sp)
    800042a6:	6c1e                	ld	s8,448(sp)
    800042a8:	7cfa                	ld	s9,440(sp)
    800042aa:	7d5a                	ld	s10,432(sp)
    800042ac:	7dba                	ld	s11,424(sp)
    800042ae:	21010113          	addi	sp,sp,528
    800042b2:	8082                	ret
    end_op();
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	498080e7          	jalr	1176(ra) # 8000374c <end_op>
    return -1;
    800042bc:	557d                	li	a0,-1
    800042be:	bfc9                	j	80004290 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042c0:	854a                	mv	a0,s2
    800042c2:	ffffd097          	auipc	ra,0xffffd
    800042c6:	d20080e7          	jalr	-736(ra) # 80000fe2 <proc_pagetable>
    800042ca:	8baa                	mv	s7,a0
    800042cc:	d945                	beqz	a0,8000427c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ce:	e7042983          	lw	s3,-400(s0)
    800042d2:	e8845783          	lhu	a5,-376(s0)
    800042d6:	c7ad                	beqz	a5,80004340 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042da:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042dc:	6c85                	lui	s9,0x1
    800042de:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042e2:	def43823          	sd	a5,-528(s0)
    800042e6:	a489                	j	80004528 <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042e8:	00004517          	auipc	a0,0x4
    800042ec:	3f050513          	addi	a0,a0,1008 # 800086d8 <syscalls+0x2c8>
    800042f0:	00002097          	auipc	ra,0x2
    800042f4:	ad8080e7          	jalr	-1320(ra) # 80005dc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042f8:	8756                	mv	a4,s5
    800042fa:	012d86bb          	addw	a3,s11,s2
    800042fe:	4581                	li	a1,0
    80004300:	8526                	mv	a0,s1
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	cac080e7          	jalr	-852(ra) # 80002fae <readi>
    8000430a:	2501                	sext.w	a0,a0
    8000430c:	1caa9563          	bne	s5,a0,800044d6 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    80004310:	6785                	lui	a5,0x1
    80004312:	0127893b          	addw	s2,a5,s2
    80004316:	77fd                	lui	a5,0xfffff
    80004318:	01478a3b          	addw	s4,a5,s4
    8000431c:	1f897d63          	bgeu	s2,s8,80004516 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004320:	02091593          	slli	a1,s2,0x20
    80004324:	9181                	srli	a1,a1,0x20
    80004326:	95ea                	add	a1,a1,s10
    80004328:	855e                	mv	a0,s7
    8000432a:	ffffc097          	auipc	ra,0xffffc
    8000432e:	1dc080e7          	jalr	476(ra) # 80000506 <walkaddr>
    80004332:	862a                	mv	a2,a0
    if(pa == 0)
    80004334:	d955                	beqz	a0,800042e8 <exec+0xf0>
      n = PGSIZE;
    80004336:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004338:	fd9a70e3          	bgeu	s4,s9,800042f8 <exec+0x100>
      n = sz - i;
    8000433c:	8ad2                	mv	s5,s4
    8000433e:	bf6d                	j	800042f8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004340:	4901                	li	s2,0
  iunlockput(ip);
    80004342:	8526                	mv	a0,s1
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	c18080e7          	jalr	-1000(ra) # 80002f5c <iunlockput>
  end_op();
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	400080e7          	jalr	1024(ra) # 8000374c <end_op>
  p = myproc();
    80004354:	ffffd097          	auipc	ra,0xffffd
    80004358:	bca080e7          	jalr	-1078(ra) # 80000f1e <myproc>
    8000435c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000435e:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004362:	6785                	lui	a5,0x1
    80004364:	17fd                	addi	a5,a5,-1
    80004366:	993e                	add	s2,s2,a5
    80004368:	757d                	lui	a0,0xfffff
    8000436a:	00a977b3          	and	a5,s2,a0
    8000436e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004372:	6609                	lui	a2,0x2
    80004374:	963e                	add	a2,a2,a5
    80004376:	85be                	mv	a1,a5
    80004378:	855e                	mv	a0,s7
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	540080e7          	jalr	1344(ra) # 800008ba <uvmalloc>
    80004382:	8b2a                	mv	s6,a0
  ip = 0;
    80004384:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004386:	14050863          	beqz	a0,800044d6 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438a:	75f9                	lui	a1,0xffffe
    8000438c:	95aa                	add	a1,a1,a0
    8000438e:	855e                	mv	a0,s7
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	748080e7          	jalr	1864(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004398:	7c7d                	lui	s8,0xfffff
    8000439a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000439c:	e0043783          	ld	a5,-512(s0)
    800043a0:	6388                	ld	a0,0(a5)
    800043a2:	c535                	beqz	a0,8000440e <exec+0x216>
    800043a4:	e9040993          	addi	s3,s0,-368
    800043a8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043ac:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	f4e080e7          	jalr	-178(ra) # 800002fc <strlen>
    800043b6:	2505                	addiw	a0,a0,1
    800043b8:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043bc:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043c0:	13896f63          	bltu	s2,s8,800044fe <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c4:	e0043d83          	ld	s11,-512(s0)
    800043c8:	000dba03          	ld	s4,0(s11)
    800043cc:	8552                	mv	a0,s4
    800043ce:	ffffc097          	auipc	ra,0xffffc
    800043d2:	f2e080e7          	jalr	-210(ra) # 800002fc <strlen>
    800043d6:	0015069b          	addiw	a3,a0,1
    800043da:	8652                	mv	a2,s4
    800043dc:	85ca                	mv	a1,s2
    800043de:	855e                	mv	a0,s7
    800043e0:	ffffc097          	auipc	ra,0xffffc
    800043e4:	72a080e7          	jalr	1834(ra) # 80000b0a <copyout>
    800043e8:	10054f63          	bltz	a0,80004506 <exec+0x30e>
    ustack[argc] = sp;
    800043ec:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f0:	0485                	addi	s1,s1,1
    800043f2:	008d8793          	addi	a5,s11,8
    800043f6:	e0f43023          	sd	a5,-512(s0)
    800043fa:	008db503          	ld	a0,8(s11)
    800043fe:	c911                	beqz	a0,80004412 <exec+0x21a>
    if(argc >= MAXARG)
    80004400:	09a1                	addi	s3,s3,8
    80004402:	fb3c96e3          	bne	s9,s3,800043ae <exec+0x1b6>
  sz = sz1;
    80004406:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440a:	4481                	li	s1,0
    8000440c:	a0e9                	j	800044d6 <exec+0x2de>
  sp = sz;
    8000440e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004410:	4481                	li	s1,0
  ustack[argc] = 0;
    80004412:	00349793          	slli	a5,s1,0x3
    80004416:	f9040713          	addi	a4,s0,-112
    8000441a:	97ba                	add	a5,a5,a4
    8000441c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004420:	00148693          	addi	a3,s1,1
    80004424:	068e                	slli	a3,a3,0x3
    80004426:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000442e:	01897663          	bgeu	s2,s8,8000443a <exec+0x242>
  sz = sz1;
    80004432:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004436:	4481                	li	s1,0
    80004438:	a879                	j	800044d6 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000443a:	e9040613          	addi	a2,s0,-368
    8000443e:	85ca                	mv	a1,s2
    80004440:	855e                	mv	a0,s7
    80004442:	ffffc097          	auipc	ra,0xffffc
    80004446:	6c8080e7          	jalr	1736(ra) # 80000b0a <copyout>
    8000444a:	0c054263          	bltz	a0,8000450e <exec+0x316>
  p->trapframe->a1 = sp;
    8000444e:	060ab783          	ld	a5,96(s5)
    80004452:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004456:	df843783          	ld	a5,-520(s0)
    8000445a:	0007c703          	lbu	a4,0(a5)
    8000445e:	cf11                	beqz	a4,8000447a <exec+0x282>
    80004460:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004462:	02f00693          	li	a3,47
    80004466:	a039                	j	80004474 <exec+0x27c>
      last = s+1;
    80004468:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000446c:	0785                	addi	a5,a5,1
    8000446e:	fff7c703          	lbu	a4,-1(a5)
    80004472:	c701                	beqz	a4,8000447a <exec+0x282>
    if(*s == '/')
    80004474:	fed71ce3          	bne	a4,a3,8000446c <exec+0x274>
    80004478:	bfc5                	j	80004468 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000447a:	4641                	li	a2,16
    8000447c:	df843583          	ld	a1,-520(s0)
    80004480:	160a8513          	addi	a0,s5,352
    80004484:	ffffc097          	auipc	ra,0xffffc
    80004488:	e46080e7          	jalr	-442(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000448c:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004490:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    80004494:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004498:	060ab783          	ld	a5,96(s5)
    8000449c:	e6843703          	ld	a4,-408(s0)
    800044a0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a2:	060ab783          	ld	a5,96(s5)
    800044a6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044aa:	85ea                	mv	a1,s10
    800044ac:	ffffd097          	auipc	ra,0xffffd
    800044b0:	c2c080e7          	jalr	-980(ra) # 800010d8 <proc_freepagetable>
  if (p->pid == 1)
    800044b4:	038aa703          	lw	a4,56(s5)
    800044b8:	4785                	li	a5,1
    800044ba:	00f70563          	beq	a4,a5,800044c4 <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044be:	0004851b          	sext.w	a0,s1
    800044c2:	b3f9                	j	80004290 <exec+0x98>
    vmprint(p->pagetable);
    800044c4:	058ab503          	ld	a0,88(s5)
    800044c8:	ffffd097          	auipc	ra,0xffffd
    800044cc:	8b4080e7          	jalr	-1868(ra) # 80000d7c <vmprint>
    800044d0:	b7fd                	j	800044be <exec+0x2c6>
    800044d2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044d6:	e0843583          	ld	a1,-504(s0)
    800044da:	855e                	mv	a0,s7
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	bfc080e7          	jalr	-1028(ra) # 800010d8 <proc_freepagetable>
  if(ip){
    800044e4:	d8049ce3          	bnez	s1,8000427c <exec+0x84>
  return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	b35d                	j	80004290 <exec+0x98>
    800044ec:	e1243423          	sd	s2,-504(s0)
    800044f0:	b7dd                	j	800044d6 <exec+0x2de>
    800044f2:	e1243423          	sd	s2,-504(s0)
    800044f6:	b7c5                	j	800044d6 <exec+0x2de>
    800044f8:	e1243423          	sd	s2,-504(s0)
    800044fc:	bfe9                	j	800044d6 <exec+0x2de>
  sz = sz1;
    800044fe:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004502:	4481                	li	s1,0
    80004504:	bfc9                	j	800044d6 <exec+0x2de>
  sz = sz1;
    80004506:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000450a:	4481                	li	s1,0
    8000450c:	b7e9                	j	800044d6 <exec+0x2de>
  sz = sz1;
    8000450e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004512:	4481                	li	s1,0
    80004514:	b7c9                	j	800044d6 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004516:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451a:	2b05                	addiw	s6,s6,1
    8000451c:	0389899b          	addiw	s3,s3,56
    80004520:	e8845783          	lhu	a5,-376(s0)
    80004524:	e0fb5fe3          	bge	s6,a5,80004342 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004528:	2981                	sext.w	s3,s3
    8000452a:	03800713          	li	a4,56
    8000452e:	86ce                	mv	a3,s3
    80004530:	e1840613          	addi	a2,s0,-488
    80004534:	4581                	li	a1,0
    80004536:	8526                	mv	a0,s1
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	a76080e7          	jalr	-1418(ra) # 80002fae <readi>
    80004540:	03800793          	li	a5,56
    80004544:	f8f517e3          	bne	a0,a5,800044d2 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    80004548:	e1842783          	lw	a5,-488(s0)
    8000454c:	4705                	li	a4,1
    8000454e:	fce796e3          	bne	a5,a4,8000451a <exec+0x322>
    if(ph.memsz < ph.filesz)
    80004552:	e4043603          	ld	a2,-448(s0)
    80004556:	e3843783          	ld	a5,-456(s0)
    8000455a:	f8f669e3          	bltu	a2,a5,800044ec <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000455e:	e2843783          	ld	a5,-472(s0)
    80004562:	963e                	add	a2,a2,a5
    80004564:	f8f667e3          	bltu	a2,a5,800044f2 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004568:	85ca                	mv	a1,s2
    8000456a:	855e                	mv	a0,s7
    8000456c:	ffffc097          	auipc	ra,0xffffc
    80004570:	34e080e7          	jalr	846(ra) # 800008ba <uvmalloc>
    80004574:	e0a43423          	sd	a0,-504(s0)
    80004578:	d141                	beqz	a0,800044f8 <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    8000457a:	e2843d03          	ld	s10,-472(s0)
    8000457e:	df043783          	ld	a5,-528(s0)
    80004582:	00fd77b3          	and	a5,s10,a5
    80004586:	fba1                	bnez	a5,800044d6 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004588:	e2042d83          	lw	s11,-480(s0)
    8000458c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004590:	f80c03e3          	beqz	s8,80004516 <exec+0x31e>
    80004594:	8a62                	mv	s4,s8
    80004596:	4901                	li	s2,0
    80004598:	b361                	j	80004320 <exec+0x128>

000000008000459a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000459a:	7179                	addi	sp,sp,-48
    8000459c:	f406                	sd	ra,40(sp)
    8000459e:	f022                	sd	s0,32(sp)
    800045a0:	ec26                	sd	s1,24(sp)
    800045a2:	e84a                	sd	s2,16(sp)
    800045a4:	1800                	addi	s0,sp,48
    800045a6:	892e                	mv	s2,a1
    800045a8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045aa:	fdc40593          	addi	a1,s0,-36
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	b72080e7          	jalr	-1166(ra) # 80002120 <argint>
    800045b6:	04054063          	bltz	a0,800045f6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ba:	fdc42703          	lw	a4,-36(s0)
    800045be:	47bd                	li	a5,15
    800045c0:	02e7ed63          	bltu	a5,a4,800045fa <argfd+0x60>
    800045c4:	ffffd097          	auipc	ra,0xffffd
    800045c8:	95a080e7          	jalr	-1702(ra) # 80000f1e <myproc>
    800045cc:	fdc42703          	lw	a4,-36(s0)
    800045d0:	01a70793          	addi	a5,a4,26
    800045d4:	078e                	slli	a5,a5,0x3
    800045d6:	953e                	add	a0,a0,a5
    800045d8:	651c                	ld	a5,8(a0)
    800045da:	c395                	beqz	a5,800045fe <argfd+0x64>
    return -1;
  if(pfd)
    800045dc:	00090463          	beqz	s2,800045e4 <argfd+0x4a>
    *pfd = fd;
    800045e0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e4:	4501                	li	a0,0
  if(pf)
    800045e6:	c091                	beqz	s1,800045ea <argfd+0x50>
    *pf = f;
    800045e8:	e09c                	sd	a5,0(s1)
}
    800045ea:	70a2                	ld	ra,40(sp)
    800045ec:	7402                	ld	s0,32(sp)
    800045ee:	64e2                	ld	s1,24(sp)
    800045f0:	6942                	ld	s2,16(sp)
    800045f2:	6145                	addi	sp,sp,48
    800045f4:	8082                	ret
    return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	bfcd                	j	800045ea <argfd+0x50>
    return -1;
    800045fa:	557d                	li	a0,-1
    800045fc:	b7fd                	j	800045ea <argfd+0x50>
    800045fe:	557d                	li	a0,-1
    80004600:	b7ed                	j	800045ea <argfd+0x50>

0000000080004602 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004602:	1101                	addi	sp,sp,-32
    80004604:	ec06                	sd	ra,24(sp)
    80004606:	e822                	sd	s0,16(sp)
    80004608:	e426                	sd	s1,8(sp)
    8000460a:	1000                	addi	s0,sp,32
    8000460c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	910080e7          	jalr	-1776(ra) # 80000f1e <myproc>
    80004616:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004618:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    8000461c:	4501                	li	a0,0
    8000461e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004620:	6398                	ld	a4,0(a5)
    80004622:	cb19                	beqz	a4,80004638 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004624:	2505                	addiw	a0,a0,1
    80004626:	07a1                	addi	a5,a5,8
    80004628:	fed51ce3          	bne	a0,a3,80004620 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000462c:	557d                	li	a0,-1
}
    8000462e:	60e2                	ld	ra,24(sp)
    80004630:	6442                	ld	s0,16(sp)
    80004632:	64a2                	ld	s1,8(sp)
    80004634:	6105                	addi	sp,sp,32
    80004636:	8082                	ret
      p->ofile[fd] = f;
    80004638:	01a50793          	addi	a5,a0,26
    8000463c:	078e                	slli	a5,a5,0x3
    8000463e:	963e                	add	a2,a2,a5
    80004640:	e604                	sd	s1,8(a2)
      return fd;
    80004642:	b7f5                	j	8000462e <fdalloc+0x2c>

0000000080004644 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004644:	715d                	addi	sp,sp,-80
    80004646:	e486                	sd	ra,72(sp)
    80004648:	e0a2                	sd	s0,64(sp)
    8000464a:	fc26                	sd	s1,56(sp)
    8000464c:	f84a                	sd	s2,48(sp)
    8000464e:	f44e                	sd	s3,40(sp)
    80004650:	f052                	sd	s4,32(sp)
    80004652:	ec56                	sd	s5,24(sp)
    80004654:	0880                	addi	s0,sp,80
    80004656:	89ae                	mv	s3,a1
    80004658:	8ab2                	mv	s5,a2
    8000465a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	e6e080e7          	jalr	-402(ra) # 800034ce <nameiparent>
    80004668:	892a                	mv	s2,a0
    8000466a:	12050f63          	beqz	a0,800047a8 <create+0x164>
    return 0;

  ilock(dp);
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	68c080e7          	jalr	1676(ra) # 80002cfa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004676:	4601                	li	a2,0
    80004678:	fb040593          	addi	a1,s0,-80
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	b60080e7          	jalr	-1184(ra) # 800031de <dirlookup>
    80004686:	84aa                	mv	s1,a0
    80004688:	c921                	beqz	a0,800046d8 <create+0x94>
    iunlockput(dp);
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	8d0080e7          	jalr	-1840(ra) # 80002f5c <iunlockput>
    ilock(ip);
    80004694:	8526                	mv	a0,s1
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	664080e7          	jalr	1636(ra) # 80002cfa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000469e:	2981                	sext.w	s3,s3
    800046a0:	4789                	li	a5,2
    800046a2:	02f99463          	bne	s3,a5,800046ca <create+0x86>
    800046a6:	0444d783          	lhu	a5,68(s1)
    800046aa:	37f9                	addiw	a5,a5,-2
    800046ac:	17c2                	slli	a5,a5,0x30
    800046ae:	93c1                	srli	a5,a5,0x30
    800046b0:	4705                	li	a4,1
    800046b2:	00f76c63          	bltu	a4,a5,800046ca <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b6:	8526                	mv	a0,s1
    800046b8:	60a6                	ld	ra,72(sp)
    800046ba:	6406                	ld	s0,64(sp)
    800046bc:	74e2                	ld	s1,56(sp)
    800046be:	7942                	ld	s2,48(sp)
    800046c0:	79a2                	ld	s3,40(sp)
    800046c2:	7a02                	ld	s4,32(sp)
    800046c4:	6ae2                	ld	s5,24(sp)
    800046c6:	6161                	addi	sp,sp,80
    800046c8:	8082                	ret
    iunlockput(ip);
    800046ca:	8526                	mv	a0,s1
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	890080e7          	jalr	-1904(ra) # 80002f5c <iunlockput>
    return 0;
    800046d4:	4481                	li	s1,0
    800046d6:	b7c5                	j	800046b6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046d8:	85ce                	mv	a1,s3
    800046da:	00092503          	lw	a0,0(s2)
    800046de:	ffffe097          	auipc	ra,0xffffe
    800046e2:	484080e7          	jalr	1156(ra) # 80002b62 <ialloc>
    800046e6:	84aa                	mv	s1,a0
    800046e8:	c529                	beqz	a0,80004732 <create+0xee>
  ilock(ip);
    800046ea:	ffffe097          	auipc	ra,0xffffe
    800046ee:	610080e7          	jalr	1552(ra) # 80002cfa <ilock>
  ip->major = major;
    800046f2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046f6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046fa:	4785                	li	a5,1
    800046fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	52e080e7          	jalr	1326(ra) # 80002c30 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000470a:	2981                	sext.w	s3,s3
    8000470c:	4785                	li	a5,1
    8000470e:	02f98a63          	beq	s3,a5,80004742 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004712:	40d0                	lw	a2,4(s1)
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	854a                	mv	a0,s2
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	cd4080e7          	jalr	-812(ra) # 800033ee <dirlink>
    80004722:	06054b63          	bltz	a0,80004798 <create+0x154>
  iunlockput(dp);
    80004726:	854a                	mv	a0,s2
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	834080e7          	jalr	-1996(ra) # 80002f5c <iunlockput>
  return ip;
    80004730:	b759                	j	800046b6 <create+0x72>
    panic("create: ialloc");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	fc650513          	addi	a0,a0,-58 # 800086f8 <syscalls+0x2e8>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	68e080e7          	jalr	1678(ra) # 80005dc8 <panic>
    dp->nlink++;  // for ".."
    80004742:	04a95783          	lhu	a5,74(s2)
    80004746:	2785                	addiw	a5,a5,1
    80004748:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000474c:	854a                	mv	a0,s2
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	4e2080e7          	jalr	1250(ra) # 80002c30 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004756:	40d0                	lw	a2,4(s1)
    80004758:	00004597          	auipc	a1,0x4
    8000475c:	fb058593          	addi	a1,a1,-80 # 80008708 <syscalls+0x2f8>
    80004760:	8526                	mv	a0,s1
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	c8c080e7          	jalr	-884(ra) # 800033ee <dirlink>
    8000476a:	00054f63          	bltz	a0,80004788 <create+0x144>
    8000476e:	00492603          	lw	a2,4(s2)
    80004772:	00004597          	auipc	a1,0x4
    80004776:	9e658593          	addi	a1,a1,-1562 # 80008158 <etext+0x158>
    8000477a:	8526                	mv	a0,s1
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	c72080e7          	jalr	-910(ra) # 800033ee <dirlink>
    80004784:	f80557e3          	bgez	a0,80004712 <create+0xce>
      panic("create dots");
    80004788:	00004517          	auipc	a0,0x4
    8000478c:	f8850513          	addi	a0,a0,-120 # 80008710 <syscalls+0x300>
    80004790:	00001097          	auipc	ra,0x1
    80004794:	638080e7          	jalr	1592(ra) # 80005dc8 <panic>
    panic("create: dirlink");
    80004798:	00004517          	auipc	a0,0x4
    8000479c:	f8850513          	addi	a0,a0,-120 # 80008720 <syscalls+0x310>
    800047a0:	00001097          	auipc	ra,0x1
    800047a4:	628080e7          	jalr	1576(ra) # 80005dc8 <panic>
    return 0;
    800047a8:	84aa                	mv	s1,a0
    800047aa:	b731                	j	800046b6 <create+0x72>

00000000800047ac <sys_dup>:
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	ec26                	sd	s1,24(sp)
    800047b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b6:	fd840613          	addi	a2,s0,-40
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	ddc080e7          	jalr	-548(ra) # 8000459a <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c8:	02054363          	bltz	a0,800047ee <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047cc:	fd843503          	ld	a0,-40(s0)
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	e32080e7          	jalr	-462(ra) # 80004602 <fdalloc>
    800047d8:	84aa                	mv	s1,a0
    return -1;
    800047da:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047dc:	00054963          	bltz	a0,800047ee <sys_dup+0x42>
  filedup(f);
    800047e0:	fd843503          	ld	a0,-40(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	362080e7          	jalr	866(ra) # 80003b46 <filedup>
  return fd;
    800047ec:	87a6                	mv	a5,s1
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	70a2                	ld	ra,40(sp)
    800047f2:	7402                	ld	s0,32(sp)
    800047f4:	64e2                	ld	s1,24(sp)
    800047f6:	6145                	addi	sp,sp,48
    800047f8:	8082                	ret

00000000800047fa <sys_read>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	d90080e7          	jalr	-624(ra) # 8000459a <argfd>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	04054163          	bltz	a0,80004856 <sys_read+0x5c>
    80004818:	fe440593          	addi	a1,s0,-28
    8000481c:	4509                	li	a0,2
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	902080e7          	jalr	-1790(ra) # 80002120 <argint>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	02054763          	bltz	a0,80004856 <sys_read+0x5c>
    8000482c:	fd840593          	addi	a1,s0,-40
    80004830:	4505                	li	a0,1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	910080e7          	jalr	-1776(ra) # 80002142 <argaddr>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	00054d63          	bltz	a0,80004856 <sys_read+0x5c>
  return fileread(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	486080e7          	jalr	1158(ra) # 80003cd2 <fileread>
    80004854:	87aa                	mv	a5,a0
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	6145                	addi	sp,sp,48
    8000485e:	8082                	ret

0000000080004860 <sys_write>:
{
    80004860:	7179                	addi	sp,sp,-48
    80004862:	f406                	sd	ra,40(sp)
    80004864:	f022                	sd	s0,32(sp)
    80004866:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004868:	fe840613          	addi	a2,s0,-24
    8000486c:	4581                	li	a1,0
    8000486e:	4501                	li	a0,0
    80004870:	00000097          	auipc	ra,0x0
    80004874:	d2a080e7          	jalr	-726(ra) # 8000459a <argfd>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487a:	04054163          	bltz	a0,800048bc <sys_write+0x5c>
    8000487e:	fe440593          	addi	a1,s0,-28
    80004882:	4509                	li	a0,2
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	89c080e7          	jalr	-1892(ra) # 80002120 <argint>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	02054763          	bltz	a0,800048bc <sys_write+0x5c>
    80004892:	fd840593          	addi	a1,s0,-40
    80004896:	4505                	li	a0,1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	8aa080e7          	jalr	-1878(ra) # 80002142 <argaddr>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	00054d63          	bltz	a0,800048bc <sys_write+0x5c>
  return filewrite(f, p, n);
    800048a6:	fe442603          	lw	a2,-28(s0)
    800048aa:	fd843583          	ld	a1,-40(s0)
    800048ae:	fe843503          	ld	a0,-24(s0)
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	4e2080e7          	jalr	1250(ra) # 80003d94 <filewrite>
    800048ba:	87aa                	mv	a5,a0
}
    800048bc:	853e                	mv	a0,a5
    800048be:	70a2                	ld	ra,40(sp)
    800048c0:	7402                	ld	s0,32(sp)
    800048c2:	6145                	addi	sp,sp,48
    800048c4:	8082                	ret

00000000800048c6 <sys_close>:
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ce:	fe040613          	addi	a2,s0,-32
    800048d2:	fec40593          	addi	a1,s0,-20
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	cc2080e7          	jalr	-830(ra) # 8000459a <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e2:	02054463          	bltz	a0,8000490a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048e6:	ffffc097          	auipc	ra,0xffffc
    800048ea:	638080e7          	jalr	1592(ra) # 80000f1e <myproc>
    800048ee:	fec42783          	lw	a5,-20(s0)
    800048f2:	07e9                	addi	a5,a5,26
    800048f4:	078e                	slli	a5,a5,0x3
    800048f6:	97aa                	add	a5,a5,a0
    800048f8:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800048fc:	fe043503          	ld	a0,-32(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	298080e7          	jalr	664(ra) # 80003b98 <fileclose>
  return 0;
    80004908:	4781                	li	a5,0
}
    8000490a:	853e                	mv	a0,a5
    8000490c:	60e2                	ld	ra,24(sp)
    8000490e:	6442                	ld	s0,16(sp)
    80004910:	6105                	addi	sp,sp,32
    80004912:	8082                	ret

0000000080004914 <sys_fstat>:
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491c:	fe840613          	addi	a2,s0,-24
    80004920:	4581                	li	a1,0
    80004922:	4501                	li	a0,0
    80004924:	00000097          	auipc	ra,0x0
    80004928:	c76080e7          	jalr	-906(ra) # 8000459a <argfd>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000492e:	02054563          	bltz	a0,80004958 <sys_fstat+0x44>
    80004932:	fe040593          	addi	a1,s0,-32
    80004936:	4505                	li	a0,1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	80a080e7          	jalr	-2038(ra) # 80002142 <argaddr>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004942:	00054b63          	bltz	a0,80004958 <sys_fstat+0x44>
  return filestat(f, st);
    80004946:	fe043583          	ld	a1,-32(s0)
    8000494a:	fe843503          	ld	a0,-24(s0)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	312080e7          	jalr	786(ra) # 80003c60 <filestat>
    80004956:	87aa                	mv	a5,a0
}
    80004958:	853e                	mv	a0,a5
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	6105                	addi	sp,sp,32
    80004960:	8082                	ret

0000000080004962 <sys_link>:
{
    80004962:	7169                	addi	sp,sp,-304
    80004964:	f606                	sd	ra,296(sp)
    80004966:	f222                	sd	s0,288(sp)
    80004968:	ee26                	sd	s1,280(sp)
    8000496a:	ea4a                	sd	s2,272(sp)
    8000496c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000496e:	08000613          	li	a2,128
    80004972:	ed040593          	addi	a1,s0,-304
    80004976:	4501                	li	a0,0
    80004978:	ffffd097          	auipc	ra,0xffffd
    8000497c:	7ec080e7          	jalr	2028(ra) # 80002164 <argstr>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	10054e63          	bltz	a0,80004a9e <sys_link+0x13c>
    80004986:	08000613          	li	a2,128
    8000498a:	f5040593          	addi	a1,s0,-176
    8000498e:	4505                	li	a0,1
    80004990:	ffffd097          	auipc	ra,0xffffd
    80004994:	7d4080e7          	jalr	2004(ra) # 80002164 <argstr>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499a:	10054263          	bltz	a0,80004a9e <sys_link+0x13c>
  begin_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	d2e080e7          	jalr	-722(ra) # 800036cc <begin_op>
  if((ip = namei(old)) == 0){
    800049a6:	ed040513          	addi	a0,s0,-304
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	b06080e7          	jalr	-1274(ra) # 800034b0 <namei>
    800049b2:	84aa                	mv	s1,a0
    800049b4:	c551                	beqz	a0,80004a40 <sys_link+0xde>
  ilock(ip);
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	344080e7          	jalr	836(ra) # 80002cfa <ilock>
  if(ip->type == T_DIR){
    800049be:	04449703          	lh	a4,68(s1)
    800049c2:	4785                	li	a5,1
    800049c4:	08f70463          	beq	a4,a5,80004a4c <sys_link+0xea>
  ip->nlink++;
    800049c8:	04a4d783          	lhu	a5,74(s1)
    800049cc:	2785                	addiw	a5,a5,1
    800049ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	25c080e7          	jalr	604(ra) # 80002c30 <iupdate>
  iunlock(ip);
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	3de080e7          	jalr	990(ra) # 80002dbc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e6:	fd040593          	addi	a1,s0,-48
    800049ea:	f5040513          	addi	a0,s0,-176
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	ae0080e7          	jalr	-1312(ra) # 800034ce <nameiparent>
    800049f6:	892a                	mv	s2,a0
    800049f8:	c935                	beqz	a0,80004a6c <sys_link+0x10a>
  ilock(dp);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	300080e7          	jalr	768(ra) # 80002cfa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a02:	00092703          	lw	a4,0(s2)
    80004a06:	409c                	lw	a5,0(s1)
    80004a08:	04f71d63          	bne	a4,a5,80004a62 <sys_link+0x100>
    80004a0c:	40d0                	lw	a2,4(s1)
    80004a0e:	fd040593          	addi	a1,s0,-48
    80004a12:	854a                	mv	a0,s2
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	9da080e7          	jalr	-1574(ra) # 800033ee <dirlink>
    80004a1c:	04054363          	bltz	a0,80004a62 <sys_link+0x100>
  iunlockput(dp);
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	53a080e7          	jalr	1338(ra) # 80002f5c <iunlockput>
  iput(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	488080e7          	jalr	1160(ra) # 80002eb4 <iput>
  end_op();
    80004a34:	fffff097          	auipc	ra,0xfffff
    80004a38:	d18080e7          	jalr	-744(ra) # 8000374c <end_op>
  return 0;
    80004a3c:	4781                	li	a5,0
    80004a3e:	a085                	j	80004a9e <sys_link+0x13c>
    end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	d0c080e7          	jalr	-756(ra) # 8000374c <end_op>
    return -1;
    80004a48:	57fd                	li	a5,-1
    80004a4a:	a891                	j	80004a9e <sys_link+0x13c>
    iunlockput(ip);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	50e080e7          	jalr	1294(ra) # 80002f5c <iunlockput>
    end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	cf6080e7          	jalr	-778(ra) # 8000374c <end_op>
    return -1;
    80004a5e:	57fd                	li	a5,-1
    80004a60:	a83d                	j	80004a9e <sys_link+0x13c>
    iunlockput(dp);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	4f8080e7          	jalr	1272(ra) # 80002f5c <iunlockput>
  ilock(ip);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	28c080e7          	jalr	652(ra) # 80002cfa <ilock>
  ip->nlink--;
    80004a76:	04a4d783          	lhu	a5,74(s1)
    80004a7a:	37fd                	addiw	a5,a5,-1
    80004a7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	1ae080e7          	jalr	430(ra) # 80002c30 <iupdate>
  iunlockput(ip);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	4d0080e7          	jalr	1232(ra) # 80002f5c <iunlockput>
  end_op();
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	cb8080e7          	jalr	-840(ra) # 8000374c <end_op>
  return -1;
    80004a9c:	57fd                	li	a5,-1
}
    80004a9e:	853e                	mv	a0,a5
    80004aa0:	70b2                	ld	ra,296(sp)
    80004aa2:	7412                	ld	s0,288(sp)
    80004aa4:	64f2                	ld	s1,280(sp)
    80004aa6:	6952                	ld	s2,272(sp)
    80004aa8:	6155                	addi	sp,sp,304
    80004aaa:	8082                	ret

0000000080004aac <sys_unlink>:
{
    80004aac:	7151                	addi	sp,sp,-240
    80004aae:	f586                	sd	ra,232(sp)
    80004ab0:	f1a2                	sd	s0,224(sp)
    80004ab2:	eda6                	sd	s1,216(sp)
    80004ab4:	e9ca                	sd	s2,208(sp)
    80004ab6:	e5ce                	sd	s3,200(sp)
    80004ab8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aba:	08000613          	li	a2,128
    80004abe:	f3040593          	addi	a1,s0,-208
    80004ac2:	4501                	li	a0,0
    80004ac4:	ffffd097          	auipc	ra,0xffffd
    80004ac8:	6a0080e7          	jalr	1696(ra) # 80002164 <argstr>
    80004acc:	18054163          	bltz	a0,80004c4e <sys_unlink+0x1a2>
  begin_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	bfc080e7          	jalr	-1028(ra) # 800036cc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ad8:	fb040593          	addi	a1,s0,-80
    80004adc:	f3040513          	addi	a0,s0,-208
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	9ee080e7          	jalr	-1554(ra) # 800034ce <nameiparent>
    80004ae8:	84aa                	mv	s1,a0
    80004aea:	c979                	beqz	a0,80004bc0 <sys_unlink+0x114>
  ilock(dp);
    80004aec:	ffffe097          	auipc	ra,0xffffe
    80004af0:	20e080e7          	jalr	526(ra) # 80002cfa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af4:	00004597          	auipc	a1,0x4
    80004af8:	c1458593          	addi	a1,a1,-1004 # 80008708 <syscalls+0x2f8>
    80004afc:	fb040513          	addi	a0,s0,-80
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	6c4080e7          	jalr	1732(ra) # 800031c4 <namecmp>
    80004b08:	14050a63          	beqz	a0,80004c5c <sys_unlink+0x1b0>
    80004b0c:	00003597          	auipc	a1,0x3
    80004b10:	64c58593          	addi	a1,a1,1612 # 80008158 <etext+0x158>
    80004b14:	fb040513          	addi	a0,s0,-80
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	6ac080e7          	jalr	1708(ra) # 800031c4 <namecmp>
    80004b20:	12050e63          	beqz	a0,80004c5c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b24:	f2c40613          	addi	a2,s0,-212
    80004b28:	fb040593          	addi	a1,s0,-80
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	6b0080e7          	jalr	1712(ra) # 800031de <dirlookup>
    80004b36:	892a                	mv	s2,a0
    80004b38:	12050263          	beqz	a0,80004c5c <sys_unlink+0x1b0>
  ilock(ip);
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	1be080e7          	jalr	446(ra) # 80002cfa <ilock>
  if(ip->nlink < 1)
    80004b44:	04a91783          	lh	a5,74(s2)
    80004b48:	08f05263          	blez	a5,80004bcc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b4c:	04491703          	lh	a4,68(s2)
    80004b50:	4785                	li	a5,1
    80004b52:	08f70563          	beq	a4,a5,80004bdc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b56:	4641                	li	a2,16
    80004b58:	4581                	li	a1,0
    80004b5a:	fc040513          	addi	a0,s0,-64
    80004b5e:	ffffb097          	auipc	ra,0xffffb
    80004b62:	61a080e7          	jalr	1562(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b66:	4741                	li	a4,16
    80004b68:	f2c42683          	lw	a3,-212(s0)
    80004b6c:	fc040613          	addi	a2,s0,-64
    80004b70:	4581                	li	a1,0
    80004b72:	8526                	mv	a0,s1
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	532080e7          	jalr	1330(ra) # 800030a6 <writei>
    80004b7c:	47c1                	li	a5,16
    80004b7e:	0af51563          	bne	a0,a5,80004c28 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b82:	04491703          	lh	a4,68(s2)
    80004b86:	4785                	li	a5,1
    80004b88:	0af70863          	beq	a4,a5,80004c38 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	3ce080e7          	jalr	974(ra) # 80002f5c <iunlockput>
  ip->nlink--;
    80004b96:	04a95783          	lhu	a5,74(s2)
    80004b9a:	37fd                	addiw	a5,a5,-1
    80004b9c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	08e080e7          	jalr	142(ra) # 80002c30 <iupdate>
  iunlockput(ip);
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	3b0080e7          	jalr	944(ra) # 80002f5c <iunlockput>
  end_op();
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	b98080e7          	jalr	-1128(ra) # 8000374c <end_op>
  return 0;
    80004bbc:	4501                	li	a0,0
    80004bbe:	a84d                	j	80004c70 <sys_unlink+0x1c4>
    end_op();
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	b8c080e7          	jalr	-1140(ra) # 8000374c <end_op>
    return -1;
    80004bc8:	557d                	li	a0,-1
    80004bca:	a05d                	j	80004c70 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	b6450513          	addi	a0,a0,-1180 # 80008730 <syscalls+0x320>
    80004bd4:	00001097          	auipc	ra,0x1
    80004bd8:	1f4080e7          	jalr	500(ra) # 80005dc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bdc:	04c92703          	lw	a4,76(s2)
    80004be0:	02000793          	li	a5,32
    80004be4:	f6e7f9e3          	bgeu	a5,a4,80004b56 <sys_unlink+0xaa>
    80004be8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bec:	4741                	li	a4,16
    80004bee:	86ce                	mv	a3,s3
    80004bf0:	f1840613          	addi	a2,s0,-232
    80004bf4:	4581                	li	a1,0
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	3b6080e7          	jalr	950(ra) # 80002fae <readi>
    80004c00:	47c1                	li	a5,16
    80004c02:	00f51b63          	bne	a0,a5,80004c18 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c06:	f1845783          	lhu	a5,-232(s0)
    80004c0a:	e7a1                	bnez	a5,80004c52 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0c:	29c1                	addiw	s3,s3,16
    80004c0e:	04c92783          	lw	a5,76(s2)
    80004c12:	fcf9ede3          	bltu	s3,a5,80004bec <sys_unlink+0x140>
    80004c16:	b781                	j	80004b56 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c18:	00004517          	auipc	a0,0x4
    80004c1c:	b3050513          	addi	a0,a0,-1232 # 80008748 <syscalls+0x338>
    80004c20:	00001097          	auipc	ra,0x1
    80004c24:	1a8080e7          	jalr	424(ra) # 80005dc8 <panic>
    panic("unlink: writei");
    80004c28:	00004517          	auipc	a0,0x4
    80004c2c:	b3850513          	addi	a0,a0,-1224 # 80008760 <syscalls+0x350>
    80004c30:	00001097          	auipc	ra,0x1
    80004c34:	198080e7          	jalr	408(ra) # 80005dc8 <panic>
    dp->nlink--;
    80004c38:	04a4d783          	lhu	a5,74(s1)
    80004c3c:	37fd                	addiw	a5,a5,-1
    80004c3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	fec080e7          	jalr	-20(ra) # 80002c30 <iupdate>
    80004c4c:	b781                	j	80004b8c <sys_unlink+0xe0>
    return -1;
    80004c4e:	557d                	li	a0,-1
    80004c50:	a005                	j	80004c70 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c52:	854a                	mv	a0,s2
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	308080e7          	jalr	776(ra) # 80002f5c <iunlockput>
  iunlockput(dp);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	2fe080e7          	jalr	766(ra) # 80002f5c <iunlockput>
  end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	ae6080e7          	jalr	-1306(ra) # 8000374c <end_op>
  return -1;
    80004c6e:	557d                	li	a0,-1
}
    80004c70:	70ae                	ld	ra,232(sp)
    80004c72:	740e                	ld	s0,224(sp)
    80004c74:	64ee                	ld	s1,216(sp)
    80004c76:	694e                	ld	s2,208(sp)
    80004c78:	69ae                	ld	s3,200(sp)
    80004c7a:	616d                	addi	sp,sp,240
    80004c7c:	8082                	ret

0000000080004c7e <sys_open>:

uint64
sys_open(void)
{
    80004c7e:	7131                	addi	sp,sp,-192
    80004c80:	fd06                	sd	ra,184(sp)
    80004c82:	f922                	sd	s0,176(sp)
    80004c84:	f526                	sd	s1,168(sp)
    80004c86:	f14a                	sd	s2,160(sp)
    80004c88:	ed4e                	sd	s3,152(sp)
    80004c8a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c8c:	08000613          	li	a2,128
    80004c90:	f5040593          	addi	a1,s0,-176
    80004c94:	4501                	li	a0,0
    80004c96:	ffffd097          	auipc	ra,0xffffd
    80004c9a:	4ce080e7          	jalr	1230(ra) # 80002164 <argstr>
    return -1;
    80004c9e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca0:	0c054163          	bltz	a0,80004d62 <sys_open+0xe4>
    80004ca4:	f4c40593          	addi	a1,s0,-180
    80004ca8:	4505                	li	a0,1
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	476080e7          	jalr	1142(ra) # 80002120 <argint>
    80004cb2:	0a054863          	bltz	a0,80004d62 <sys_open+0xe4>

  begin_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	a16080e7          	jalr	-1514(ra) # 800036cc <begin_op>

  if(omode & O_CREATE){
    80004cbe:	f4c42783          	lw	a5,-180(s0)
    80004cc2:	2007f793          	andi	a5,a5,512
    80004cc6:	cbdd                	beqz	a5,80004d7c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cc8:	4681                	li	a3,0
    80004cca:	4601                	li	a2,0
    80004ccc:	4589                	li	a1,2
    80004cce:	f5040513          	addi	a0,s0,-176
    80004cd2:	00000097          	auipc	ra,0x0
    80004cd6:	972080e7          	jalr	-1678(ra) # 80004644 <create>
    80004cda:	892a                	mv	s2,a0
    if(ip == 0){
    80004cdc:	c959                	beqz	a0,80004d72 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cde:	04491703          	lh	a4,68(s2)
    80004ce2:	478d                	li	a5,3
    80004ce4:	00f71763          	bne	a4,a5,80004cf2 <sys_open+0x74>
    80004ce8:	04695703          	lhu	a4,70(s2)
    80004cec:	47a5                	li	a5,9
    80004cee:	0ce7ec63          	bltu	a5,a4,80004dc6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	dea080e7          	jalr	-534(ra) # 80003adc <filealloc>
    80004cfa:	89aa                	mv	s3,a0
    80004cfc:	10050263          	beqz	a0,80004e00 <sys_open+0x182>
    80004d00:	00000097          	auipc	ra,0x0
    80004d04:	902080e7          	jalr	-1790(ra) # 80004602 <fdalloc>
    80004d08:	84aa                	mv	s1,a0
    80004d0a:	0e054663          	bltz	a0,80004df6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d0e:	04491703          	lh	a4,68(s2)
    80004d12:	478d                	li	a5,3
    80004d14:	0cf70463          	beq	a4,a5,80004ddc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d18:	4789                	li	a5,2
    80004d1a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d1e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d22:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	0017c713          	xori	a4,a5,1
    80004d2e:	8b05                	andi	a4,a4,1
    80004d30:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d34:	0037f713          	andi	a4,a5,3
    80004d38:	00e03733          	snez	a4,a4
    80004d3c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d40:	4007f793          	andi	a5,a5,1024
    80004d44:	c791                	beqz	a5,80004d50 <sys_open+0xd2>
    80004d46:	04491703          	lh	a4,68(s2)
    80004d4a:	4789                	li	a5,2
    80004d4c:	08f70f63          	beq	a4,a5,80004dea <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d50:	854a                	mv	a0,s2
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	06a080e7          	jalr	106(ra) # 80002dbc <iunlock>
  end_op();
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	9f2080e7          	jalr	-1550(ra) # 8000374c <end_op>

  return fd;
}
    80004d62:	8526                	mv	a0,s1
    80004d64:	70ea                	ld	ra,184(sp)
    80004d66:	744a                	ld	s0,176(sp)
    80004d68:	74aa                	ld	s1,168(sp)
    80004d6a:	790a                	ld	s2,160(sp)
    80004d6c:	69ea                	ld	s3,152(sp)
    80004d6e:	6129                	addi	sp,sp,192
    80004d70:	8082                	ret
      end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	9da080e7          	jalr	-1574(ra) # 8000374c <end_op>
      return -1;
    80004d7a:	b7e5                	j	80004d62 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d7c:	f5040513          	addi	a0,s0,-176
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	730080e7          	jalr	1840(ra) # 800034b0 <namei>
    80004d88:	892a                	mv	s2,a0
    80004d8a:	c905                	beqz	a0,80004dba <sys_open+0x13c>
    ilock(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	f6e080e7          	jalr	-146(ra) # 80002cfa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d94:	04491703          	lh	a4,68(s2)
    80004d98:	4785                	li	a5,1
    80004d9a:	f4f712e3          	bne	a4,a5,80004cde <sys_open+0x60>
    80004d9e:	f4c42783          	lw	a5,-180(s0)
    80004da2:	dba1                	beqz	a5,80004cf2 <sys_open+0x74>
      iunlockput(ip);
    80004da4:	854a                	mv	a0,s2
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	1b6080e7          	jalr	438(ra) # 80002f5c <iunlockput>
      end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	99e080e7          	jalr	-1634(ra) # 8000374c <end_op>
      return -1;
    80004db6:	54fd                	li	s1,-1
    80004db8:	b76d                	j	80004d62 <sys_open+0xe4>
      end_op();
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	992080e7          	jalr	-1646(ra) # 8000374c <end_op>
      return -1;
    80004dc2:	54fd                	li	s1,-1
    80004dc4:	bf79                	j	80004d62 <sys_open+0xe4>
    iunlockput(ip);
    80004dc6:	854a                	mv	a0,s2
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	194080e7          	jalr	404(ra) # 80002f5c <iunlockput>
    end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	97c080e7          	jalr	-1668(ra) # 8000374c <end_op>
    return -1;
    80004dd8:	54fd                	li	s1,-1
    80004dda:	b761                	j	80004d62 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ddc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004de0:	04691783          	lh	a5,70(s2)
    80004de4:	02f99223          	sh	a5,36(s3)
    80004de8:	bf2d                	j	80004d22 <sys_open+0xa4>
    itrunc(ip);
    80004dea:	854a                	mv	a0,s2
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	01c080e7          	jalr	28(ra) # 80002e08 <itrunc>
    80004df4:	bfb1                	j	80004d50 <sys_open+0xd2>
      fileclose(f);
    80004df6:	854e                	mv	a0,s3
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	da0080e7          	jalr	-608(ra) # 80003b98 <fileclose>
    iunlockput(ip);
    80004e00:	854a                	mv	a0,s2
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	15a080e7          	jalr	346(ra) # 80002f5c <iunlockput>
    end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	942080e7          	jalr	-1726(ra) # 8000374c <end_op>
    return -1;
    80004e12:	54fd                	li	s1,-1
    80004e14:	b7b9                	j	80004d62 <sys_open+0xe4>

0000000080004e16 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e16:	7175                	addi	sp,sp,-144
    80004e18:	e506                	sd	ra,136(sp)
    80004e1a:	e122                	sd	s0,128(sp)
    80004e1c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	8ae080e7          	jalr	-1874(ra) # 800036cc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e26:	08000613          	li	a2,128
    80004e2a:	f7040593          	addi	a1,s0,-144
    80004e2e:	4501                	li	a0,0
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	334080e7          	jalr	820(ra) # 80002164 <argstr>
    80004e38:	02054963          	bltz	a0,80004e6a <sys_mkdir+0x54>
    80004e3c:	4681                	li	a3,0
    80004e3e:	4601                	li	a2,0
    80004e40:	4585                	li	a1,1
    80004e42:	f7040513          	addi	a0,s0,-144
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	7fe080e7          	jalr	2046(ra) # 80004644 <create>
    80004e4e:	cd11                	beqz	a0,80004e6a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	10c080e7          	jalr	268(ra) # 80002f5c <iunlockput>
  end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	8f4080e7          	jalr	-1804(ra) # 8000374c <end_op>
  return 0;
    80004e60:	4501                	li	a0,0
}
    80004e62:	60aa                	ld	ra,136(sp)
    80004e64:	640a                	ld	s0,128(sp)
    80004e66:	6149                	addi	sp,sp,144
    80004e68:	8082                	ret
    end_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	8e2080e7          	jalr	-1822(ra) # 8000374c <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b7fd                	j	80004e62 <sys_mkdir+0x4c>

0000000080004e76 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e76:	7135                	addi	sp,sp,-160
    80004e78:	ed06                	sd	ra,152(sp)
    80004e7a:	e922                	sd	s0,144(sp)
    80004e7c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	84e080e7          	jalr	-1970(ra) # 800036cc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e86:	08000613          	li	a2,128
    80004e8a:	f7040593          	addi	a1,s0,-144
    80004e8e:	4501                	li	a0,0
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	2d4080e7          	jalr	724(ra) # 80002164 <argstr>
    80004e98:	04054a63          	bltz	a0,80004eec <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e9c:	f6c40593          	addi	a1,s0,-148
    80004ea0:	4505                	li	a0,1
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	27e080e7          	jalr	638(ra) # 80002120 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eaa:	04054163          	bltz	a0,80004eec <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eae:	f6840593          	addi	a1,s0,-152
    80004eb2:	4509                	li	a0,2
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	26c080e7          	jalr	620(ra) # 80002120 <argint>
     argint(1, &major) < 0 ||
    80004ebc:	02054863          	bltz	a0,80004eec <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ec0:	f6841683          	lh	a3,-152(s0)
    80004ec4:	f6c41603          	lh	a2,-148(s0)
    80004ec8:	458d                	li	a1,3
    80004eca:	f7040513          	addi	a0,s0,-144
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	776080e7          	jalr	1910(ra) # 80004644 <create>
     argint(2, &minor) < 0 ||
    80004ed6:	c919                	beqz	a0,80004eec <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	084080e7          	jalr	132(ra) # 80002f5c <iunlockput>
  end_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	86c080e7          	jalr	-1940(ra) # 8000374c <end_op>
  return 0;
    80004ee8:	4501                	li	a0,0
    80004eea:	a031                	j	80004ef6 <sys_mknod+0x80>
    end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	860080e7          	jalr	-1952(ra) # 8000374c <end_op>
    return -1;
    80004ef4:	557d                	li	a0,-1
}
    80004ef6:	60ea                	ld	ra,152(sp)
    80004ef8:	644a                	ld	s0,144(sp)
    80004efa:	610d                	addi	sp,sp,160
    80004efc:	8082                	ret

0000000080004efe <sys_chdir>:

uint64
sys_chdir(void)
{
    80004efe:	7135                	addi	sp,sp,-160
    80004f00:	ed06                	sd	ra,152(sp)
    80004f02:	e922                	sd	s0,144(sp)
    80004f04:	e526                	sd	s1,136(sp)
    80004f06:	e14a                	sd	s2,128(sp)
    80004f08:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f0a:	ffffc097          	auipc	ra,0xffffc
    80004f0e:	014080e7          	jalr	20(ra) # 80000f1e <myproc>
    80004f12:	892a                	mv	s2,a0
  
  begin_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	7b8080e7          	jalr	1976(ra) # 800036cc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f1c:	08000613          	li	a2,128
    80004f20:	f6040593          	addi	a1,s0,-160
    80004f24:	4501                	li	a0,0
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	23e080e7          	jalr	574(ra) # 80002164 <argstr>
    80004f2e:	04054b63          	bltz	a0,80004f84 <sys_chdir+0x86>
    80004f32:	f6040513          	addi	a0,s0,-160
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	57a080e7          	jalr	1402(ra) # 800034b0 <namei>
    80004f3e:	84aa                	mv	s1,a0
    80004f40:	c131                	beqz	a0,80004f84 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	db8080e7          	jalr	-584(ra) # 80002cfa <ilock>
  if(ip->type != T_DIR){
    80004f4a:	04449703          	lh	a4,68(s1)
    80004f4e:	4785                	li	a5,1
    80004f50:	04f71063          	bne	a4,a5,80004f90 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f54:	8526                	mv	a0,s1
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	e66080e7          	jalr	-410(ra) # 80002dbc <iunlock>
  iput(p->cwd);
    80004f5e:	15893503          	ld	a0,344(s2)
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	f52080e7          	jalr	-174(ra) # 80002eb4 <iput>
  end_op();
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	7e2080e7          	jalr	2018(ra) # 8000374c <end_op>
  p->cwd = ip;
    80004f72:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f76:	4501                	li	a0,0
}
    80004f78:	60ea                	ld	ra,152(sp)
    80004f7a:	644a                	ld	s0,144(sp)
    80004f7c:	64aa                	ld	s1,136(sp)
    80004f7e:	690a                	ld	s2,128(sp)
    80004f80:	610d                	addi	sp,sp,160
    80004f82:	8082                	ret
    end_op();
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	7c8080e7          	jalr	1992(ra) # 8000374c <end_op>
    return -1;
    80004f8c:	557d                	li	a0,-1
    80004f8e:	b7ed                	j	80004f78 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f90:	8526                	mv	a0,s1
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	fca080e7          	jalr	-54(ra) # 80002f5c <iunlockput>
    end_op();
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	7b2080e7          	jalr	1970(ra) # 8000374c <end_op>
    return -1;
    80004fa2:	557d                	li	a0,-1
    80004fa4:	bfd1                	j	80004f78 <sys_chdir+0x7a>

0000000080004fa6 <sys_exec>:

uint64
sys_exec(void)
{
    80004fa6:	7145                	addi	sp,sp,-464
    80004fa8:	e786                	sd	ra,456(sp)
    80004faa:	e3a2                	sd	s0,448(sp)
    80004fac:	ff26                	sd	s1,440(sp)
    80004fae:	fb4a                	sd	s2,432(sp)
    80004fb0:	f74e                	sd	s3,424(sp)
    80004fb2:	f352                	sd	s4,416(sp)
    80004fb4:	ef56                	sd	s5,408(sp)
    80004fb6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fb8:	08000613          	li	a2,128
    80004fbc:	f4040593          	addi	a1,s0,-192
    80004fc0:	4501                	li	a0,0
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	1a2080e7          	jalr	418(ra) # 80002164 <argstr>
    return -1;
    80004fca:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fcc:	0c054a63          	bltz	a0,800050a0 <sys_exec+0xfa>
    80004fd0:	e3840593          	addi	a1,s0,-456
    80004fd4:	4505                	li	a0,1
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	16c080e7          	jalr	364(ra) # 80002142 <argaddr>
    80004fde:	0c054163          	bltz	a0,800050a0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fe2:	10000613          	li	a2,256
    80004fe6:	4581                	li	a1,0
    80004fe8:	e4040513          	addi	a0,s0,-448
    80004fec:	ffffb097          	auipc	ra,0xffffb
    80004ff0:	18c080e7          	jalr	396(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ff4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ff8:	89a6                	mv	s3,s1
    80004ffa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ffc:	02000a13          	li	s4,32
    80005000:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005004:	00391513          	slli	a0,s2,0x3
    80005008:	e3040593          	addi	a1,s0,-464
    8000500c:	e3843783          	ld	a5,-456(s0)
    80005010:	953e                	add	a0,a0,a5
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	074080e7          	jalr	116(ra) # 80002086 <fetchaddr>
    8000501a:	02054a63          	bltz	a0,8000504e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000501e:	e3043783          	ld	a5,-464(s0)
    80005022:	c3b9                	beqz	a5,80005068 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	0f4080e7          	jalr	244(ra) # 80000118 <kalloc>
    8000502c:	85aa                	mv	a1,a0
    8000502e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005032:	cd11                	beqz	a0,8000504e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005034:	6605                	lui	a2,0x1
    80005036:	e3043503          	ld	a0,-464(s0)
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	09e080e7          	jalr	158(ra) # 800020d8 <fetchstr>
    80005042:	00054663          	bltz	a0,8000504e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005046:	0905                	addi	s2,s2,1
    80005048:	09a1                	addi	s3,s3,8
    8000504a:	fb491be3          	bne	s2,s4,80005000 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504e:	10048913          	addi	s2,s1,256
    80005052:	6088                	ld	a0,0(s1)
    80005054:	c529                	beqz	a0,8000509e <sys_exec+0xf8>
    kfree(argv[i]);
    80005056:	ffffb097          	auipc	ra,0xffffb
    8000505a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	04a1                	addi	s1,s1,8
    80005060:	ff2499e3          	bne	s1,s2,80005052 <sys_exec+0xac>
  return -1;
    80005064:	597d                	li	s2,-1
    80005066:	a82d                	j	800050a0 <sys_exec+0xfa>
      argv[i] = 0;
    80005068:	0a8e                	slli	s5,s5,0x3
    8000506a:	fc040793          	addi	a5,s0,-64
    8000506e:	9abe                	add	s5,s5,a5
    80005070:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005074:	e4040593          	addi	a1,s0,-448
    80005078:	f4040513          	addi	a0,s0,-192
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	17c080e7          	jalr	380(ra) # 800041f8 <exec>
    80005084:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005086:	10048993          	addi	s3,s1,256
    8000508a:	6088                	ld	a0,0(s1)
    8000508c:	c911                	beqz	a0,800050a0 <sys_exec+0xfa>
    kfree(argv[i]);
    8000508e:	ffffb097          	auipc	ra,0xffffb
    80005092:	f8e080e7          	jalr	-114(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005096:	04a1                	addi	s1,s1,8
    80005098:	ff3499e3          	bne	s1,s3,8000508a <sys_exec+0xe4>
    8000509c:	a011                	j	800050a0 <sys_exec+0xfa>
  return -1;
    8000509e:	597d                	li	s2,-1
}
    800050a0:	854a                	mv	a0,s2
    800050a2:	60be                	ld	ra,456(sp)
    800050a4:	641e                	ld	s0,448(sp)
    800050a6:	74fa                	ld	s1,440(sp)
    800050a8:	795a                	ld	s2,432(sp)
    800050aa:	79ba                	ld	s3,424(sp)
    800050ac:	7a1a                	ld	s4,416(sp)
    800050ae:	6afa                	ld	s5,408(sp)
    800050b0:	6179                	addi	sp,sp,464
    800050b2:	8082                	ret

00000000800050b4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050b4:	7139                	addi	sp,sp,-64
    800050b6:	fc06                	sd	ra,56(sp)
    800050b8:	f822                	sd	s0,48(sp)
    800050ba:	f426                	sd	s1,40(sp)
    800050bc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	e60080e7          	jalr	-416(ra) # 80000f1e <myproc>
    800050c6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050c8:	fd840593          	addi	a1,s0,-40
    800050cc:	4501                	li	a0,0
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	074080e7          	jalr	116(ra) # 80002142 <argaddr>
    return -1;
    800050d6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050d8:	0e054063          	bltz	a0,800051b8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050dc:	fc840593          	addi	a1,s0,-56
    800050e0:	fd040513          	addi	a0,s0,-48
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	de4080e7          	jalr	-540(ra) # 80003ec8 <pipealloc>
    return -1;
    800050ec:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ee:	0c054563          	bltz	a0,800051b8 <sys_pipe+0x104>
  fd0 = -1;
    800050f2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f6:	fd043503          	ld	a0,-48(s0)
    800050fa:	fffff097          	auipc	ra,0xfffff
    800050fe:	508080e7          	jalr	1288(ra) # 80004602 <fdalloc>
    80005102:	fca42223          	sw	a0,-60(s0)
    80005106:	08054c63          	bltz	a0,8000519e <sys_pipe+0xea>
    8000510a:	fc843503          	ld	a0,-56(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	4f4080e7          	jalr	1268(ra) # 80004602 <fdalloc>
    80005116:	fca42023          	sw	a0,-64(s0)
    8000511a:	06054863          	bltz	a0,8000518a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511e:	4691                	li	a3,4
    80005120:	fc440613          	addi	a2,s0,-60
    80005124:	fd843583          	ld	a1,-40(s0)
    80005128:	6ca8                	ld	a0,88(s1)
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	9e0080e7          	jalr	-1568(ra) # 80000b0a <copyout>
    80005132:	02054063          	bltz	a0,80005152 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005136:	4691                	li	a3,4
    80005138:	fc040613          	addi	a2,s0,-64
    8000513c:	fd843583          	ld	a1,-40(s0)
    80005140:	0591                	addi	a1,a1,4
    80005142:	6ca8                	ld	a0,88(s1)
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	9c6080e7          	jalr	-1594(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000514c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000514e:	06055563          	bgez	a0,800051b8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005152:	fc442783          	lw	a5,-60(s0)
    80005156:	07e9                	addi	a5,a5,26
    80005158:	078e                	slli	a5,a5,0x3
    8000515a:	97a6                	add	a5,a5,s1
    8000515c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005160:	fc042503          	lw	a0,-64(s0)
    80005164:	0569                	addi	a0,a0,26
    80005166:	050e                	slli	a0,a0,0x3
    80005168:	9526                	add	a0,a0,s1
    8000516a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000516e:	fd043503          	ld	a0,-48(s0)
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	a26080e7          	jalr	-1498(ra) # 80003b98 <fileclose>
    fileclose(wf);
    8000517a:	fc843503          	ld	a0,-56(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	a1a080e7          	jalr	-1510(ra) # 80003b98 <fileclose>
    return -1;
    80005186:	57fd                	li	a5,-1
    80005188:	a805                	j	800051b8 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000518a:	fc442783          	lw	a5,-60(s0)
    8000518e:	0007c863          	bltz	a5,8000519e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005192:	01a78513          	addi	a0,a5,26
    80005196:	050e                	slli	a0,a0,0x3
    80005198:	9526                	add	a0,a0,s1
    8000519a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000519e:	fd043503          	ld	a0,-48(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	9f6080e7          	jalr	-1546(ra) # 80003b98 <fileclose>
    fileclose(wf);
    800051aa:	fc843503          	ld	a0,-56(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	9ea080e7          	jalr	-1558(ra) # 80003b98 <fileclose>
    return -1;
    800051b6:	57fd                	li	a5,-1
}
    800051b8:	853e                	mv	a0,a5
    800051ba:	70e2                	ld	ra,56(sp)
    800051bc:	7442                	ld	s0,48(sp)
    800051be:	74a2                	ld	s1,40(sp)
    800051c0:	6121                	addi	sp,sp,64
    800051c2:	8082                	ret
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	d43fc0ef          	jal	ra,80001f52 <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	c4a080e7          	jalr	-950(ra) # 80000ef2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	953e                	add	a0,a0,a5
    800052cc:	00052023          	sw	zero,0(a0)
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	c12080e7          	jalr	-1006(ra) # 80000ef2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5179b          	slliw	a5,a0,0xd
    800052ec:	0c201537          	lui	a0,0xc201
    800052f0:	953e                	add	a0,a0,a5
  return irq;
}
    800052f2:	4148                	lw	a0,4(a0)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	bea080e7          	jalr	-1046(ra) # 80000ef2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	06a7c963          	blt	a5,a0,800053a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	00016797          	auipc	a5,0x16
    80005338:	ccc78793          	addi	a5,a5,-820 # 8001b000 <disk>
    8000533c:	00a78733          	add	a4,a5,a0
    80005340:	6789                	lui	a5,0x2
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005348:	e7ad                	bnez	a5,800053b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534a:	00451793          	slli	a5,a0,0x4
    8000534e:	00018717          	auipc	a4,0x18
    80005352:	cb270713          	addi	a4,a4,-846 # 8001d000 <disk+0x2000>
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000535e:	6314                	ld	a3,0(a4)
    80005360:	96be                	add	a3,a3,a5
    80005362:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000536e:	6318                	ld	a4,0(a4)
    80005370:	97ba                	add	a5,a5,a4
    80005372:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005376:	00016797          	auipc	a5,0x16
    8000537a:	c8a78793          	addi	a5,a5,-886 # 8001b000 <disk>
    8000537e:	97aa                	add	a5,a5,a0
    80005380:	6509                	lui	a0,0x2
    80005382:	953e                	add	a0,a0,a5
    80005384:	4785                	li	a5,1
    80005386:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538a:	00018517          	auipc	a0,0x18
    8000538e:	c8e50513          	addi	a0,a0,-882 # 8001d018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	48c080e7          	jalr	1164(ra) # 8000181e <wakeup>
}
    8000539a:	60a2                	ld	ra,8(sp)
    8000539c:	6402                	ld	s0,0(sp)
    8000539e:	0141                	addi	sp,sp,16
    800053a0:	8082                	ret
    panic("free_desc 1");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	3ce50513          	addi	a0,a0,974 # 80008770 <syscalls+0x360>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a1e080e7          	jalr	-1506(ra) # 80005dc8 <panic>
    panic("free_desc 2");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	3ce50513          	addi	a0,a0,974 # 80008780 <syscalls+0x370>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a0e080e7          	jalr	-1522(ra) # 80005dc8 <panic>

00000000800053c2 <virtio_disk_init>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	e426                	sd	s1,8(sp)
    800053ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	3c458593          	addi	a1,a1,964 # 80008790 <syscalls+0x380>
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	d5450513          	addi	a0,a0,-684 # 8001d128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	ea6080e7          	jalr	-346(ra) # 80006282 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71163          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4705                	li	a4,1
    80005402:	0ce79a63          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000540e:	4709                	li	a4,2
    80005410:	0ce79363          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	47d8                	lw	a4,12(a5)
    8000541a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	554d47b7          	lui	a5,0x554d4
    80005420:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005424:	0af71963          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	4705                	li	a4,1
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005430:	470d                	li	a4,3
    80005432:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005434:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005436:	c7ffe737          	lui	a4,0xc7ffe
    8000543a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000543e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	2701                	sext.w	a4,a4
    80005442:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005444:	472d                	li	a4,11
    80005446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	473d                	li	a4,15
    8000544a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000544c:	6705                	lui	a4,0x1
    8000544e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005450:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005454:	5bdc                	lw	a5,52(a5)
    80005456:	2781                	sext.w	a5,a5
  if(max == 0)
    80005458:	c7d9                	beqz	a5,800054e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000545a:	471d                	li	a4,7
    8000545c:	08f77d63          	bgeu	a4,a5,800054f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005460:	100014b7          	lui	s1,0x10001
    80005464:	47a1                	li	a5,8
    80005466:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005468:	6609                	lui	a2,0x2
    8000546a:	4581                	li	a1,0
    8000546c:	00016517          	auipc	a0,0x16
    80005470:	b9450513          	addi	a0,a0,-1132 # 8001b000 <disk>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d04080e7          	jalr	-764(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000547c:	00016717          	auipc	a4,0x16
    80005480:	b8470713          	addi	a4,a4,-1148 # 8001b000 <disk>
    80005484:	00c75793          	srli	a5,a4,0xc
    80005488:	2781                	sext.w	a5,a5
    8000548a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548c:	00018797          	auipc	a5,0x18
    80005490:	b7478793          	addi	a5,a5,-1164 # 8001d000 <disk+0x2000>
    80005494:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005496:	00016717          	auipc	a4,0x16
    8000549a:	bea70713          	addi	a4,a4,-1046 # 8001b080 <disk+0x80>
    8000549e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054a0:	00017717          	auipc	a4,0x17
    800054a4:	b6070713          	addi	a4,a4,-1184 # 8001c000 <disk+0x1000>
    800054a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054aa:	4705                	li	a4,1
    800054ac:	00e78c23          	sb	a4,24(a5)
    800054b0:	00e78ca3          	sb	a4,25(a5)
    800054b4:	00e78d23          	sb	a4,26(a5)
    800054b8:	00e78da3          	sb	a4,27(a5)
    800054bc:	00e78e23          	sb	a4,28(a5)
    800054c0:	00e78ea3          	sb	a4,29(a5)
    800054c4:	00e78f23          	sb	a4,30(a5)
    800054c8:	00e78fa3          	sb	a4,31(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret
    panic("could not find virtio disk");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	2ca50513          	addi	a0,a0,714 # 800087a0 <syscalls+0x390>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ea080e7          	jalr	-1814(ra) # 80005dc8 <panic>
    panic("virtio disk has no queue 0");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	2da50513          	addi	a0,a0,730 # 800087c0 <syscalls+0x3b0>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8da080e7          	jalr	-1830(ra) # 80005dc8 <panic>
    panic("virtio disk max queue too short");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	2ea50513          	addi	a0,a0,746 # 800087e0 <syscalls+0x3d0>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8ca080e7          	jalr	-1846(ra) # 80005dc8 <panic>

0000000080005506 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005506:	7159                	addi	sp,sp,-112
    80005508:	f486                	sd	ra,104(sp)
    8000550a:	f0a2                	sd	s0,96(sp)
    8000550c:	eca6                	sd	s1,88(sp)
    8000550e:	e8ca                	sd	s2,80(sp)
    80005510:	e4ce                	sd	s3,72(sp)
    80005512:	e0d2                	sd	s4,64(sp)
    80005514:	fc56                	sd	s5,56(sp)
    80005516:	f85a                	sd	s6,48(sp)
    80005518:	f45e                	sd	s7,40(sp)
    8000551a:	f062                	sd	s8,32(sp)
    8000551c:	ec66                	sd	s9,24(sp)
    8000551e:	e86a                	sd	s10,16(sp)
    80005520:	1880                	addi	s0,sp,112
    80005522:	892a                	mv	s2,a0
    80005524:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52c83          	lw	s9,12(a0)
    8000552a:	001c9c9b          	slliw	s9,s9,0x1
    8000552e:	1c82                	slli	s9,s9,0x20
    80005530:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005534:	00018517          	auipc	a0,0x18
    80005538:	bf450513          	addi	a0,a0,-1036 # 8001d128 <disk+0x2128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	dd6080e7          	jalr	-554(ra) # 80006312 <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005548:	00016b97          	auipc	s7,0x16
    8000554c:	ab8b8b93          	addi	s7,s7,-1352 # 8001b000 <disk>
    80005550:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005552:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005554:	8a4e                	mv	s4,s3
    80005556:	a051                	j	800055da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005558:	00fb86b3          	add	a3,s7,a5
    8000555c:	96da                	add	a3,a3,s6
    8000555e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005562:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005564:	0207c563          	bltz	a5,8000558e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005568:	2485                	addiw	s1,s1,1
    8000556a:	0711                	addi	a4,a4,4
    8000556c:	25548063          	beq	s1,s5,800057ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005570:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005572:	00018697          	auipc	a3,0x18
    80005576:	aa668693          	addi	a3,a3,-1370 # 8001d018 <disk+0x2018>
    8000557a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000557c:	0006c583          	lbu	a1,0(a3)
    80005580:	fde1                	bnez	a1,80005558 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005582:	2785                	addiw	a5,a5,1
    80005584:	0685                	addi	a3,a3,1
    80005586:	ff879be3          	bne	a5,s8,8000557c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000558a:	57fd                	li	a5,-1
    8000558c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000558e:	02905a63          	blez	s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005592:	f9042503          	lw	a0,-112(s0)
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	d90080e7          	jalr	-624(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    8000559e:	4785                	li	a5,1
    800055a0:	0297d163          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a4:	f9442503          	lw	a0,-108(s0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	d7e080e7          	jalr	-642(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	4789                	li	a5,2
    800055b2:	0097d863          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b6:	f9842503          	lw	a0,-104(s0)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	d6c080e7          	jalr	-660(ra) # 80005326 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c2:	00018597          	auipc	a1,0x18
    800055c6:	b6658593          	addi	a1,a1,-1178 # 8001d128 <disk+0x2128>
    800055ca:	00018517          	auipc	a0,0x18
    800055ce:	a4e50513          	addi	a0,a0,-1458 # 8001d018 <disk+0x2018>
    800055d2:	ffffc097          	auipc	ra,0xffffc
    800055d6:	0c0080e7          	jalr	192(ra) # 80001692 <sleep>
  for(int i = 0; i < 3; i++){
    800055da:	f9040713          	addi	a4,s0,-112
    800055de:	84ce                	mv	s1,s3
    800055e0:	bf41                	j	80005570 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055e2:	20058713          	addi	a4,a1,512
    800055e6:	00471693          	slli	a3,a4,0x4
    800055ea:	00016717          	auipc	a4,0x16
    800055ee:	a1670713          	addi	a4,a4,-1514 # 8001b000 <disk>
    800055f2:	9736                	add	a4,a4,a3
    800055f4:	4685                	li	a3,1
    800055f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055fa:	20058713          	addi	a4,a1,512
    800055fe:	00471693          	slli	a3,a4,0x4
    80005602:	00016717          	auipc	a4,0x16
    80005606:	9fe70713          	addi	a4,a4,-1538 # 8001b000 <disk>
    8000560a:	9736                	add	a4,a4,a3
    8000560c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005610:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005614:	7679                	lui	a2,0xffffe
    80005616:	963e                	add	a2,a2,a5
    80005618:	00018697          	auipc	a3,0x18
    8000561c:	9e868693          	addi	a3,a3,-1560 # 8001d000 <disk+0x2000>
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	6298                	ld	a4,0(a3)
    80005628:	9732                	add	a4,a4,a2
    8000562a:	4541                	li	a0,16
    8000562c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	4505                	li	a0,1
    80005634:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442703          	lw	a4,-108(s0)
    8000563c:	6288                	ld	a0,0(a3)
    8000563e:	962a                	add	a2,a2,a0
    80005640:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0712                	slli	a4,a4,0x4
    80005646:	6290                	ld	a2,0(a3)
    80005648:	963a                	add	a2,a2,a4
    8000564a:	05890513          	addi	a0,s2,88
    8000564e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6294                	ld	a3,0(a3)
    80005652:	96ba                	add	a3,a3,a4
    80005654:	40000613          	li	a2,1024
    80005658:	c690                	sw	a2,8(a3)
  if(write)
    8000565a:	140d0063          	beqz	s10,8000579a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000565e:	00018697          	auipc	a3,0x18
    80005662:	9a26b683          	ld	a3,-1630(a3) # 8001d000 <disk+0x2000>
    80005666:	96ba                	add	a3,a3,a4
    80005668:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	00016817          	auipc	a6,0x16
    80005670:	99480813          	addi	a6,a6,-1644 # 8001b000 <disk>
    80005674:	00018517          	auipc	a0,0x18
    80005678:	98c50513          	addi	a0,a0,-1652 # 8001d000 <disk+0x2000>
    8000567c:	6114                	ld	a3,0(a0)
    8000567e:	96ba                	add	a3,a3,a4
    80005680:	00c6d603          	lhu	a2,12(a3)
    80005684:	00166613          	ori	a2,a2,1
    80005688:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000568c:	f9842683          	lw	a3,-104(s0)
    80005690:	6110                	ld	a2,0(a0)
    80005692:	9732                	add	a4,a4,a2
    80005694:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005698:	20058613          	addi	a2,a1,512
    8000569c:	0612                	slli	a2,a2,0x4
    8000569e:	9642                	add	a2,a2,a6
    800056a0:	577d                	li	a4,-1
    800056a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056a6:	00469713          	slli	a4,a3,0x4
    800056aa:	6114                	ld	a3,0(a0)
    800056ac:	96ba                	add	a3,a3,a4
    800056ae:	03078793          	addi	a5,a5,48
    800056b2:	97c2                	add	a5,a5,a6
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056b6:	611c                	ld	a5,0(a0)
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	4685                	li	a3,1
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056be:	611c                	ld	a5,0(a0)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4809                	li	a6,2
    800056c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056c8:	611c                	ld	a5,0(a0)
    800056ca:	973e                	add	a4,a4,a5
    800056cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d8:	6518                	ld	a4,8(a0)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	8b9d                	andi	a5,a5,7
    800056e0:	0786                	slli	a5,a5,0x1
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ec:	6518                	ld	a4,8(a0)
    800056ee:	00275783          	lhu	a5,2(a4)
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005704:	00492703          	lw	a4,4(s2)
    80005708:	4785                	li	a5,1
    8000570a:	02f71163          	bne	a4,a5,8000572c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000570e:	00018997          	auipc	s3,0x18
    80005712:	a1a98993          	addi	s3,s3,-1510 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005716:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005718:	85ce                	mv	a1,s3
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	f76080e7          	jalr	-138(ra) # 80001692 <sleep>
  while(b->disk == 1) {
    80005724:	00492783          	lw	a5,4(s2)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	20090793          	addi	a5,s2,512
    80005734:	00479713          	slli	a4,a5,0x4
    80005738:	00016797          	auipc	a5,0x16
    8000573c:	8c878793          	addi	a5,a5,-1848 # 8001b000 <disk>
    80005740:	97ba                	add	a5,a5,a4
    80005742:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005746:	00018997          	auipc	s3,0x18
    8000574a:	8ba98993          	addi	s3,s3,-1862 # 8001d000 <disk+0x2000>
    8000574e:	00491713          	slli	a4,s2,0x4
    80005752:	0009b783          	ld	a5,0(s3)
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575c:	854a                	mv	a0,s2
    8000575e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	bc4080e7          	jalr	-1084(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0ed                	bnez	s1,8000574e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	00018517          	auipc	a0,0x18
    80005772:	9ba50513          	addi	a0,a0,-1606 # 8001d128 <disk+0x2128>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	c50080e7          	jalr	-944(ra) # 800063c6 <release>
}
    8000577e:	70a6                	ld	ra,104(sp)
    80005780:	7406                	ld	s0,96(sp)
    80005782:	64e6                	ld	s1,88(sp)
    80005784:	6946                	ld	s2,80(sp)
    80005786:	69a6                	ld	s3,72(sp)
    80005788:	6a06                	ld	s4,64(sp)
    8000578a:	7ae2                	ld	s5,56(sp)
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	6165                	addi	sp,sp,112
    80005798:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579a:	00018697          	auipc	a3,0x18
    8000579e:	8666b683          	ld	a3,-1946(a3) # 8001d000 <disk+0x2000>
    800057a2:	96ba                	add	a3,a3,a4
    800057a4:	4609                	li	a2,2
    800057a6:	00c69623          	sh	a2,12(a3)
    800057aa:	b5c9                	j	8000566c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ac:	f9042583          	lw	a1,-112(s0)
    800057b0:	20058793          	addi	a5,a1,512
    800057b4:	0792                	slli	a5,a5,0x4
    800057b6:	00016517          	auipc	a0,0x16
    800057ba:	8f250513          	addi	a0,a0,-1806 # 8001b0a8 <disk+0xa8>
    800057be:	953e                	add	a0,a0,a5
  if(write)
    800057c0:	e20d11e3          	bnez	s10,800055e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057c4:	20058713          	addi	a4,a1,512
    800057c8:	00471693          	slli	a3,a4,0x4
    800057cc:	00016717          	auipc	a4,0x16
    800057d0:	83470713          	addi	a4,a4,-1996 # 8001b000 <disk>
    800057d4:	9736                	add	a4,a4,a3
    800057d6:	0a072423          	sw	zero,168(a4)
    800057da:	b505                	j	800055fa <virtio_disk_rw+0xf4>

00000000800057dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	e04a                	sd	s2,0(sp)
    800057e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e8:	00018517          	auipc	a0,0x18
    800057ec:	94050513          	addi	a0,a0,-1728 # 8001d128 <disk+0x2128>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	b22080e7          	jalr	-1246(ra) # 80006312 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f8:	10001737          	lui	a4,0x10001
    800057fc:	533c                	lw	a5,96(a4)
    800057fe:	8b8d                	andi	a5,a5,3
    80005800:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005806:	00017797          	auipc	a5,0x17
    8000580a:	7fa78793          	addi	a5,a5,2042 # 8001d000 <disk+0x2000>
    8000580e:	6b94                	ld	a3,16(a5)
    80005810:	0207d703          	lhu	a4,32(a5)
    80005814:	0026d783          	lhu	a5,2(a3)
    80005818:	06f70163          	beq	a4,a5,8000587a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000581c:	00015917          	auipc	s2,0x15
    80005820:	7e490913          	addi	s2,s2,2020 # 8001b000 <disk>
    80005824:	00017497          	auipc	s1,0x17
    80005828:	7dc48493          	addi	s1,s1,2012 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000582c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005830:	6898                	ld	a4,16(s1)
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	8b9d                	andi	a5,a5,7
    80005838:	078e                	slli	a5,a5,0x3
    8000583a:	97ba                	add	a5,a5,a4
    8000583c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583e:	20078713          	addi	a4,a5,512
    80005842:	0712                	slli	a4,a4,0x4
    80005844:	974a                	add	a4,a4,s2
    80005846:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000584a:	e731                	bnez	a4,80005896 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000584c:	20078793          	addi	a5,a5,512
    80005850:	0792                	slli	a5,a5,0x4
    80005852:	97ca                	add	a5,a5,s2
    80005854:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005856:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	fc4080e7          	jalr	-60(ra) # 8000181e <wakeup>

    disk.used_idx += 1;
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	17c2                	slli	a5,a5,0x30
    8000586a:	93c1                	srli	a5,a5,0x30
    8000586c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005870:	6898                	ld	a4,16(s1)
    80005872:	00275703          	lhu	a4,2(a4)
    80005876:	faf71be3          	bne	a4,a5,8000582c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000587a:	00018517          	auipc	a0,0x18
    8000587e:	8ae50513          	addi	a0,a0,-1874 # 8001d128 <disk+0x2128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	b44080e7          	jalr	-1212(ra) # 800063c6 <release>
}
    8000588a:	60e2                	ld	ra,24(sp)
    8000588c:	6442                	ld	s0,16(sp)
    8000588e:	64a2                	ld	s1,8(sp)
    80005890:	6902                	ld	s2,0(sp)
    80005892:	6105                	addi	sp,sp,32
    80005894:	8082                	ret
      panic("virtio_disk_intr status");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	f6a50513          	addi	a0,a0,-150 # 80008800 <syscalls+0x3f0>
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	52a080e7          	jalr	1322(ra) # 80005dc8 <panic>

00000000800058a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a6:	1141                	addi	sp,sp,-16
    800058a8:	e422                	sd	s0,8(sp)
    800058aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b4:	0037979b          	slliw	a5,a5,0x3
    800058b8:	02004737          	lui	a4,0x2004
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0200c737          	lui	a4,0x200c
    800058c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c6:	000f4637          	lui	a2,0xf4
    800058ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ce:	95b2                	add	a1,a1,a2
    800058d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d2:	00269713          	slli	a4,a3,0x2
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00371693          	slli	a3,a4,0x3
    800058dc:	00018717          	auipc	a4,0x18
    800058e0:	72470713          	addi	a4,a4,1828 # 8001e000 <timer_scratch>
    800058e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ee:	00000797          	auipc	a5,0x0
    800058f2:	97278793          	addi	a5,a5,-1678 # 80005260 <timervec>
    800058f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005902:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005906:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000590e:	30479073          	csrw	mie,a5
}
    80005912:	6422                	ld	s0,8(sp)
    80005914:	0141                	addi	sp,sp,16
    80005916:	8082                	ret

0000000080005918 <start>:
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e406                	sd	ra,8(sp)
    8000591c:	e022                	sd	s0,0(sp)
    8000591e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005920:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005924:	7779                	lui	a4,0xffffe
    80005926:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000592a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000592c:	6705                	lui	a4,0x1
    8000592e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005932:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005934:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005938:	ffffb797          	auipc	a5,0xffffb
    8000593c:	9ee78793          	addi	a5,a5,-1554 # 80000326 <main>
    80005940:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005944:	4781                	li	a5,0
    80005946:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594a:	67c1                	lui	a5,0x10
    8000594c:	17fd                	addi	a5,a5,-1
    8000594e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005952:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005956:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000595e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005962:	57fd                	li	a5,-1
    80005964:	83a9                	srli	a5,a5,0xa
    80005966:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596a:	47bd                	li	a5,15
    8000596c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005970:	00000097          	auipc	ra,0x0
    80005974:	f36080e7          	jalr	-202(ra) # 800058a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005978:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000597c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000597e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005980:	30200073          	mret
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret

000000008000598c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000598c:	715d                	addi	sp,sp,-80
    8000598e:	e486                	sd	ra,72(sp)
    80005990:	e0a2                	sd	s0,64(sp)
    80005992:	fc26                	sd	s1,56(sp)
    80005994:	f84a                	sd	s2,48(sp)
    80005996:	f44e                	sd	s3,40(sp)
    80005998:	f052                	sd	s4,32(sp)
    8000599a:	ec56                	sd	s5,24(sp)
    8000599c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000599e:	04c05663          	blez	a2,800059ea <consolewrite+0x5e>
    800059a2:	8a2a                	mv	s4,a0
    800059a4:	84ae                	mv	s1,a1
    800059a6:	89b2                	mv	s3,a2
    800059a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059aa:	5afd                	li	s5,-1
    800059ac:	4685                	li	a3,1
    800059ae:	8626                	mv	a2,s1
    800059b0:	85d2                	mv	a1,s4
    800059b2:	fbf40513          	addi	a0,s0,-65
    800059b6:	ffffc097          	auipc	ra,0xffffc
    800059ba:	0d6080e7          	jalr	214(ra) # 80001a8c <either_copyin>
    800059be:	01550c63          	beq	a0,s5,800059d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c2:	fbf44503          	lbu	a0,-65(s0)
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	78e080e7          	jalr	1934(ra) # 80006154 <uartputc>
  for(i = 0; i < n; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0485                	addi	s1,s1,1
    800059d2:	fd299de3          	bne	s3,s2,800059ac <consolewrite+0x20>
  }

  return i;
}
    800059d6:	854a                	mv	a0,s2
    800059d8:	60a6                	ld	ra,72(sp)
    800059da:	6406                	ld	s0,64(sp)
    800059dc:	74e2                	ld	s1,56(sp)
    800059de:	7942                	ld	s2,48(sp)
    800059e0:	79a2                	ld	s3,40(sp)
    800059e2:	7a02                	ld	s4,32(sp)
    800059e4:	6ae2                	ld	s5,24(sp)
    800059e6:	6161                	addi	sp,sp,80
    800059e8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ea:	4901                	li	s2,0
    800059ec:	b7ed                	j	800059d6 <consolewrite+0x4a>

00000000800059ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ee:	7119                	addi	sp,sp,-128
    800059f0:	fc86                	sd	ra,120(sp)
    800059f2:	f8a2                	sd	s0,112(sp)
    800059f4:	f4a6                	sd	s1,104(sp)
    800059f6:	f0ca                	sd	s2,96(sp)
    800059f8:	ecce                	sd	s3,88(sp)
    800059fa:	e8d2                	sd	s4,80(sp)
    800059fc:	e4d6                	sd	s5,72(sp)
    800059fe:	e0da                	sd	s6,64(sp)
    80005a00:	fc5e                	sd	s7,56(sp)
    80005a02:	f862                	sd	s8,48(sp)
    80005a04:	f466                	sd	s9,40(sp)
    80005a06:	f06a                	sd	s10,32(sp)
    80005a08:	ec6e                	sd	s11,24(sp)
    80005a0a:	0100                	addi	s0,sp,128
    80005a0c:	8b2a                	mv	s6,a0
    80005a0e:	8aae                	mv	s5,a1
    80005a10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a16:	00020517          	auipc	a0,0x20
    80005a1a:	72a50513          	addi	a0,a0,1834 # 80026140 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	8f4080e7          	jalr	-1804(ra) # 80006312 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a26:	00020497          	auipc	s1,0x20
    80005a2a:	71a48493          	addi	s1,s1,1818 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a2e:	89a6                	mv	s3,s1
    80005a30:	00020917          	auipc	s2,0x20
    80005a34:	7a890913          	addi	s2,s2,1960 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a3c:	4da9                	li	s11,10
  while(n > 0){
    80005a3e:	07405863          	blez	s4,80005aae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71463          	bne	a4,a5,80005a72 <consoleread+0x84>
      if(myproc()->killed){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	4d0080e7          	jalr	1232(ra) # 80000f1e <myproc>
    80005a56:	591c                	lw	a5,48(a0)
    80005a58:	e7b5                	bnez	a5,80005ac4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a5a:	85ce                	mv	a1,s3
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	c34080e7          	jalr	-972(ra) # 80001692 <sleep>
    while(cons.r == cons.w){
    80005a66:	0984a783          	lw	a5,152(s1)
    80005a6a:	09c4a703          	lw	a4,156(s1)
    80005a6e:	fef700e3          	beq	a4,a5,80005a4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a72:	0017871b          	addiw	a4,a5,1
    80005a76:	08e4ac23          	sw	a4,152(s1)
    80005a7a:	07f7f713          	andi	a4,a5,127
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01874703          	lbu	a4,24(a4)
    80005a84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a88:	079c0663          	beq	s8,s9,80005af4 <consoleread+0x106>
    cbuf = c;
    80005a8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a90:	4685                	li	a3,1
    80005a92:	f8f40613          	addi	a2,s0,-113
    80005a96:	85d6                	mv	a1,s5
    80005a98:	855a                	mv	a0,s6
    80005a9a:	ffffc097          	auipc	ra,0xffffc
    80005a9e:	f9c080e7          	jalr	-100(ra) # 80001a36 <either_copyout>
    80005aa2:	01a50663          	beq	a0,s10,80005aae <consoleread+0xc0>
    dst++;
    80005aa6:	0a85                	addi	s5,s5,1
    --n;
    80005aa8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aaa:	f9bc1ae3          	bne	s8,s11,80005a3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aae:	00020517          	auipc	a0,0x20
    80005ab2:	69250513          	addi	a0,a0,1682 # 80026140 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	910080e7          	jalr	-1776(ra) # 800063c6 <release>

  return target - n;
    80005abe:	414b853b          	subw	a0,s7,s4
    80005ac2:	a811                	j	80005ad6 <consoleread+0xe8>
        release(&cons.lock);
    80005ac4:	00020517          	auipc	a0,0x20
    80005ac8:	67c50513          	addi	a0,a0,1660 # 80026140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	8fa080e7          	jalr	-1798(ra) # 800063c6 <release>
        return -1;
    80005ad4:	557d                	li	a0,-1
}
    80005ad6:	70e6                	ld	ra,120(sp)
    80005ad8:	7446                	ld	s0,112(sp)
    80005ada:	74a6                	ld	s1,104(sp)
    80005adc:	7906                	ld	s2,96(sp)
    80005ade:	69e6                	ld	s3,88(sp)
    80005ae0:	6a46                	ld	s4,80(sp)
    80005ae2:	6aa6                	ld	s5,72(sp)
    80005ae4:	6b06                	ld	s6,64(sp)
    80005ae6:	7be2                	ld	s7,56(sp)
    80005ae8:	7c42                	ld	s8,48(sp)
    80005aea:	7ca2                	ld	s9,40(sp)
    80005aec:	7d02                	ld	s10,32(sp)
    80005aee:	6de2                	ld	s11,24(sp)
    80005af0:	6109                	addi	sp,sp,128
    80005af2:	8082                	ret
      if(n < target){
    80005af4:	000a071b          	sext.w	a4,s4
    80005af8:	fb777be3          	bgeu	a4,s7,80005aae <consoleread+0xc0>
        cons.r--;
    80005afc:	00020717          	auipc	a4,0x20
    80005b00:	6cf72e23          	sw	a5,1756(a4) # 800261d8 <cons+0x98>
    80005b04:	b76d                	j	80005aae <consoleread+0xc0>

0000000080005b06 <consputc>:
{
    80005b06:	1141                	addi	sp,sp,-16
    80005b08:	e406                	sd	ra,8(sp)
    80005b0a:	e022                	sd	s0,0(sp)
    80005b0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b0e:	10000793          	li	a5,256
    80005b12:	00f50a63          	beq	a0,a5,80005b26 <consputc+0x20>
    uartputc_sync(c);
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	564080e7          	jalr	1380(ra) # 8000607a <uartputc_sync>
}
    80005b1e:	60a2                	ld	ra,8(sp)
    80005b20:	6402                	ld	s0,0(sp)
    80005b22:	0141                	addi	sp,sp,16
    80005b24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	552080e7          	jalr	1362(ra) # 8000607a <uartputc_sync>
    80005b30:	02000513          	li	a0,32
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	546080e7          	jalr	1350(ra) # 8000607a <uartputc_sync>
    80005b3c:	4521                	li	a0,8
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	53c080e7          	jalr	1340(ra) # 8000607a <uartputc_sync>
    80005b46:	bfe1                	j	80005b1e <consputc+0x18>

0000000080005b48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b48:	1101                	addi	sp,sp,-32
    80005b4a:	ec06                	sd	ra,24(sp)
    80005b4c:	e822                	sd	s0,16(sp)
    80005b4e:	e426                	sd	s1,8(sp)
    80005b50:	e04a                	sd	s2,0(sp)
    80005b52:	1000                	addi	s0,sp,32
    80005b54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b56:	00020517          	auipc	a0,0x20
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 80026140 <cons>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	7b4080e7          	jalr	1972(ra) # 80006312 <acquire>

  switch(c){
    80005b66:	47d5                	li	a5,21
    80005b68:	0af48663          	beq	s1,a5,80005c14 <consoleintr+0xcc>
    80005b6c:	0297ca63          	blt	a5,s1,80005ba0 <consoleintr+0x58>
    80005b70:	47a1                	li	a5,8
    80005b72:	0ef48763          	beq	s1,a5,80005c60 <consoleintr+0x118>
    80005b76:	47c1                	li	a5,16
    80005b78:	10f49a63          	bne	s1,a5,80005c8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	f66080e7          	jalr	-154(ra) # 80001ae2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b84:	00020517          	auipc	a0,0x20
    80005b88:	5bc50513          	addi	a0,a0,1468 # 80026140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	83a080e7          	jalr	-1990(ra) # 800063c6 <release>
}
    80005b94:	60e2                	ld	ra,24(sp)
    80005b96:	6442                	ld	s0,16(sp)
    80005b98:	64a2                	ld	s1,8(sp)
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	6105                	addi	sp,sp,32
    80005b9e:	8082                	ret
  switch(c){
    80005ba0:	07f00793          	li	a5,127
    80005ba4:	0af48e63          	beq	s1,a5,80005c60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ba8:	00020717          	auipc	a4,0x20
    80005bac:	59870713          	addi	a4,a4,1432 # 80026140 <cons>
    80005bb0:	0a072783          	lw	a5,160(a4)
    80005bb4:	09872703          	lw	a4,152(a4)
    80005bb8:	9f99                	subw	a5,a5,a4
    80005bba:	07f00713          	li	a4,127
    80005bbe:	fcf763e3          	bltu	a4,a5,80005b84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bc2:	47b5                	li	a5,13
    80005bc4:	0cf48763          	beq	s1,a5,80005c92 <consoleintr+0x14a>
      consputc(c);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	f3c080e7          	jalr	-196(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd2:	00020797          	auipc	a5,0x20
    80005bd6:	56e78793          	addi	a5,a5,1390 # 80026140 <cons>
    80005bda:	0a07a703          	lw	a4,160(a5)
    80005bde:	0017069b          	addiw	a3,a4,1
    80005be2:	0006861b          	sext.w	a2,a3
    80005be6:	0ad7a023          	sw	a3,160(a5)
    80005bea:	07f77713          	andi	a4,a4,127
    80005bee:	97ba                	add	a5,a5,a4
    80005bf0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bf4:	47a9                	li	a5,10
    80005bf6:	0cf48563          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005bfa:	4791                	li	a5,4
    80005bfc:	0cf48263          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005c00:	00020797          	auipc	a5,0x20
    80005c04:	5d87a783          	lw	a5,1496(a5) # 800261d8 <cons+0x98>
    80005c08:	0807879b          	addiw	a5,a5,128
    80005c0c:	f6f61ce3          	bne	a2,a5,80005b84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c10:	863e                	mv	a2,a5
    80005c12:	a07d                	j	80005cc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c14:	00020717          	auipc	a4,0x20
    80005c18:	52c70713          	addi	a4,a4,1324 # 80026140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c24:	00020497          	auipc	s1,0x20
    80005c28:	51c48493          	addi	s1,s1,1308 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c2c:	4929                	li	s2,10
    80005c2e:	f4f70be3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c32:	37fd                	addiw	a5,a5,-1
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	f52703e3          	beq	a4,s2,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	ebc080e7          	jalr	-324(ra) # 80005b06 <consputc>
    while(cons.e != cons.w &&
    80005c52:	0a04a783          	lw	a5,160(s1)
    80005c56:	09c4a703          	lw	a4,156(s1)
    80005c5a:	fcf71ce3          	bne	a4,a5,80005c32 <consoleintr+0xea>
    80005c5e:	b71d                	j	80005b84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c60:	00020717          	auipc	a4,0x20
    80005c64:	4e070713          	addi	a4,a4,1248 # 80026140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09c72703          	lw	a4,156(a4)
    80005c70:	f0f70ae3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	00020717          	auipc	a4,0x20
    80005c7a:	56f72523          	sw	a5,1386(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c7e:	10000513          	li	a0,256
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	e84080e7          	jalr	-380(ra) # 80005b06 <consputc>
    80005c8a:	bded                	j	80005b84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8c:	ee048ce3          	beqz	s1,80005b84 <consoleintr+0x3c>
    80005c90:	bf21                	j	80005ba8 <consoleintr+0x60>
      consputc(c);
    80005c92:	4529                	li	a0,10
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	e72080e7          	jalr	-398(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c9c:	00020797          	auipc	a5,0x20
    80005ca0:	4a478793          	addi	a5,a5,1188 # 80026140 <cons>
    80005ca4:	0a07a703          	lw	a4,160(a5)
    80005ca8:	0017069b          	addiw	a3,a4,1
    80005cac:	0006861b          	sext.w	a2,a3
    80005cb0:	0ad7a023          	sw	a3,160(a5)
    80005cb4:	07f77713          	andi	a4,a4,127
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	4729                	li	a4,10
    80005cbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cc0:	00020797          	auipc	a5,0x20
    80005cc4:	50c7ae23          	sw	a2,1308(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cc8:	00020517          	auipc	a0,0x20
    80005ccc:	51050513          	addi	a0,a0,1296 # 800261d8 <cons+0x98>
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	b4e080e7          	jalr	-1202(ra) # 8000181e <wakeup>
    80005cd8:	b575                	j	80005b84 <consoleintr+0x3c>

0000000080005cda <consoleinit>:

void
consoleinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	b3658593          	addi	a1,a1,-1226 # 80008818 <syscalls+0x408>
    80005cea:	00020517          	auipc	a0,0x20
    80005cee:	45650513          	addi	a0,a0,1110 # 80026140 <cons>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	590080e7          	jalr	1424(ra) # 80006282 <initlock>

  uartinit();
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	330080e7          	jalr	816(ra) # 8000602a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d02:	00013797          	auipc	a5,0x13
    80005d06:	5c678793          	addi	a5,a5,1478 # 800192c8 <devsw>
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	ce470713          	addi	a4,a4,-796 # 800059ee <consoleread>
    80005d12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	c7870713          	addi	a4,a4,-904 # 8000598c <consolewrite>
    80005d1c:	ef98                	sd	a4,24(a5)
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d26:	7179                	addi	sp,sp,-48
    80005d28:	f406                	sd	ra,40(sp)
    80005d2a:	f022                	sd	s0,32(sp)
    80005d2c:	ec26                	sd	s1,24(sp)
    80005d2e:	e84a                	sd	s2,16(sp)
    80005d30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d32:	c219                	beqz	a2,80005d38 <printint+0x12>
    80005d34:	08054663          	bltz	a0,80005dc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d38:	2501                	sext.w	a0,a0
    80005d3a:	4881                	li	a7,0
    80005d3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d42:	2581                	sext.w	a1,a1
    80005d44:	00003617          	auipc	a2,0x3
    80005d48:	b0460613          	addi	a2,a2,-1276 # 80008848 <digits>
    80005d4c:	883a                	mv	a6,a4
    80005d4e:	2705                	addiw	a4,a4,1
    80005d50:	02b577bb          	remuw	a5,a0,a1
    80005d54:	1782                	slli	a5,a5,0x20
    80005d56:	9381                	srli	a5,a5,0x20
    80005d58:	97b2                	add	a5,a5,a2
    80005d5a:	0007c783          	lbu	a5,0(a5)
    80005d5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d62:	0005079b          	sext.w	a5,a0
    80005d66:	02b5553b          	divuw	a0,a0,a1
    80005d6a:	0685                	addi	a3,a3,1
    80005d6c:	feb7f0e3          	bgeu	a5,a1,80005d4c <printint+0x26>

  if(sign)
    80005d70:	00088b63          	beqz	a7,80005d86 <printint+0x60>
    buf[i++] = '-';
    80005d74:	fe040793          	addi	a5,s0,-32
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	02d00793          	li	a5,45
    80005d7e:	fef70823          	sb	a5,-16(a4)
    80005d82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d86:	02e05763          	blez	a4,80005db4 <printint+0x8e>
    80005d8a:	fd040793          	addi	a5,s0,-48
    80005d8e:	00e784b3          	add	s1,a5,a4
    80005d92:	fff78913          	addi	s2,a5,-1
    80005d96:	993a                	add	s2,s2,a4
    80005d98:	377d                	addiw	a4,a4,-1
    80005d9a:	1702                	slli	a4,a4,0x20
    80005d9c:	9301                	srli	a4,a4,0x20
    80005d9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005da2:	fff4c503          	lbu	a0,-1(s1)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	d60080e7          	jalr	-672(ra) # 80005b06 <consputc>
  while(--i >= 0)
    80005dae:	14fd                	addi	s1,s1,-1
    80005db0:	ff2499e3          	bne	s1,s2,80005da2 <printint+0x7c>
}
    80005db4:	70a2                	ld	ra,40(sp)
    80005db6:	7402                	ld	s0,32(sp)
    80005db8:	64e2                	ld	s1,24(sp)
    80005dba:	6942                	ld	s2,16(sp)
    80005dbc:	6145                	addi	sp,sp,48
    80005dbe:	8082                	ret
    x = -xx;
    80005dc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dc4:	4885                	li	a7,1
    x = -xx;
    80005dc6:	bf9d                	j	80005d3c <printint+0x16>

0000000080005dc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
    80005dd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dd4:	00020797          	auipc	a5,0x20
    80005dd8:	4207a623          	sw	zero,1068(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005ddc:	00003517          	auipc	a0,0x3
    80005de0:	a4450513          	addi	a0,a0,-1468 # 80008820 <syscalls+0x410>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	02e080e7          	jalr	46(ra) # 80005e12 <printf>
  printf(s);
    80005dec:	8526                	mv	a0,s1
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	024080e7          	jalr	36(ra) # 80005e12 <printf>
  printf("\n");
    80005df6:	00002517          	auipc	a0,0x2
    80005dfa:	25250513          	addi	a0,a0,594 # 80008048 <etext+0x48>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e06:	4785                	li	a5,1
    80005e08:	00003717          	auipc	a4,0x3
    80005e0c:	20f72a23          	sw	a5,532(a4) # 8000901c <panicked>
  for(;;)
    80005e10:	a001                	j	80005e10 <panic+0x48>

0000000080005e12 <printf>:
{
    80005e12:	7131                	addi	sp,sp,-192
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	e40c                	sd	a1,8(s0)
    80005e34:	e810                	sd	a2,16(s0)
    80005e36:	ec14                	sd	a3,24(s0)
    80005e38:	f018                	sd	a4,32(s0)
    80005e3a:	f41c                	sd	a5,40(s0)
    80005e3c:	03043823          	sd	a6,48(s0)
    80005e40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e44:	00020d97          	auipc	s11,0x20
    80005e48:	3bcdad83          	lw	s11,956(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e4c:	020d9b63          	bnez	s11,80005e82 <printf+0x70>
  if (fmt == 0)
    80005e50:	040a0263          	beqz	s4,80005e94 <printf+0x82>
  va_start(ap, fmt);
    80005e54:	00840793          	addi	a5,s0,8
    80005e58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	000a4503          	lbu	a0,0(s4)
    80005e60:	16050263          	beqz	a0,80005fc4 <printf+0x1b2>
    80005e64:	4481                	li	s1,0
    if(c != '%'){
    80005e66:	02500a93          	li	s5,37
    switch(c){
    80005e6a:	07000b13          	li	s6,112
  consputc('x');
    80005e6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e70:	00003b97          	auipc	s7,0x3
    80005e74:	9d8b8b93          	addi	s7,s7,-1576 # 80008848 <digits>
    switch(c){
    80005e78:	07300c93          	li	s9,115
    80005e7c:	06400c13          	li	s8,100
    80005e80:	a82d                	j	80005eba <printf+0xa8>
    acquire(&pr.lock);
    80005e82:	00020517          	auipc	a0,0x20
    80005e86:	36650513          	addi	a0,a0,870 # 800261e8 <pr>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	488080e7          	jalr	1160(ra) # 80006312 <acquire>
    80005e92:	bf7d                	j	80005e50 <printf+0x3e>
    panic("null fmt");
    80005e94:	00003517          	auipc	a0,0x3
    80005e98:	99c50513          	addi	a0,a0,-1636 # 80008830 <syscalls+0x420>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	f2c080e7          	jalr	-212(ra) # 80005dc8 <panic>
      consputc(c);
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	c62080e7          	jalr	-926(ra) # 80005b06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	2485                	addiw	s1,s1,1
    80005eae:	009a07b3          	add	a5,s4,s1
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	10050763          	beqz	a0,80005fc4 <printf+0x1b2>
    if(c != '%'){
    80005eba:	ff5515e3          	bne	a0,s5,80005ea4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ebe:	2485                	addiw	s1,s1,1
    80005ec0:	009a07b3          	add	a5,s4,s1
    80005ec4:	0007c783          	lbu	a5,0(a5)
    80005ec8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ecc:	cfe5                	beqz	a5,80005fc4 <printf+0x1b2>
    switch(c){
    80005ece:	05678a63          	beq	a5,s6,80005f22 <printf+0x110>
    80005ed2:	02fb7663          	bgeu	s6,a5,80005efe <printf+0xec>
    80005ed6:	09978963          	beq	a5,s9,80005f68 <printf+0x156>
    80005eda:	07800713          	li	a4,120
    80005ede:	0ce79863          	bne	a5,a4,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	4605                	li	a2,1
    80005ef0:	85ea                	mv	a1,s10
    80005ef2:	4388                	lw	a0,0(a5)
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e32080e7          	jalr	-462(ra) # 80005d26 <printint>
      break;
    80005efc:	bf45                	j	80005eac <printf+0x9a>
    switch(c){
    80005efe:	0b578263          	beq	a5,s5,80005fa2 <printf+0x190>
    80005f02:	0b879663          	bne	a5,s8,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f06:	f8843783          	ld	a5,-120(s0)
    80005f0a:	00878713          	addi	a4,a5,8
    80005f0e:	f8e43423          	sd	a4,-120(s0)
    80005f12:	4605                	li	a2,1
    80005f14:	45a9                	li	a1,10
    80005f16:	4388                	lw	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	e0e080e7          	jalr	-498(ra) # 80005d26 <printint>
      break;
    80005f20:	b771                	j	80005eac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f32:	03000513          	li	a0,48
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bd0080e7          	jalr	-1072(ra) # 80005b06 <consputc>
  consputc('x');
    80005f3e:	07800513          	li	a0,120
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bc4080e7          	jalr	-1084(ra) # 80005b06 <consputc>
    80005f4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4c:	03c9d793          	srli	a5,s3,0x3c
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0007c503          	lbu	a0,0(a5)
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	bb0080e7          	jalr	-1104(ra) # 80005b06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f5e:	0992                	slli	s3,s3,0x4
    80005f60:	397d                	addiw	s2,s2,-1
    80005f62:	fe0915e3          	bnez	s2,80005f4c <printf+0x13a>
    80005f66:	b799                	j	80005eac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
    80005f78:	00090e63          	beqz	s2,80005f94 <printf+0x182>
      for(; *s; s++)
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	d515                	beqz	a0,80005eac <printf+0x9a>
        consputc(*s);
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b84080e7          	jalr	-1148(ra) # 80005b06 <consputc>
      for(; *s; s++)
    80005f8a:	0905                	addi	s2,s2,1
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	f96d                	bnez	a0,80005f82 <printf+0x170>
    80005f92:	bf29                	j	80005eac <printf+0x9a>
        s = "(null)";
    80005f94:	00003917          	auipc	s2,0x3
    80005f98:	89490913          	addi	s2,s2,-1900 # 80008828 <syscalls+0x418>
      for(; *s; s++)
    80005f9c:	02800513          	li	a0,40
    80005fa0:	b7cd                	j	80005f82 <printf+0x170>
      consputc('%');
    80005fa2:	8556                	mv	a0,s5
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b62080e7          	jalr	-1182(ra) # 80005b06 <consputc>
      break;
    80005fac:	b701                	j	80005eac <printf+0x9a>
      consputc('%');
    80005fae:	8556                	mv	a0,s5
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b56080e7          	jalr	-1194(ra) # 80005b06 <consputc>
      consputc(c);
    80005fb8:	854a                	mv	a0,s2
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b4c080e7          	jalr	-1204(ra) # 80005b06 <consputc>
      break;
    80005fc2:	b5ed                	j	80005eac <printf+0x9a>
  if(locking)
    80005fc4:	020d9163          	bnez	s11,80005fe6 <printf+0x1d4>
}
    80005fc8:	70e6                	ld	ra,120(sp)
    80005fca:	7446                	ld	s0,112(sp)
    80005fcc:	74a6                	ld	s1,104(sp)
    80005fce:	7906                	ld	s2,96(sp)
    80005fd0:	69e6                	ld	s3,88(sp)
    80005fd2:	6a46                	ld	s4,80(sp)
    80005fd4:	6aa6                	ld	s5,72(sp)
    80005fd6:	6b06                	ld	s6,64(sp)
    80005fd8:	7be2                	ld	s7,56(sp)
    80005fda:	7c42                	ld	s8,48(sp)
    80005fdc:	7ca2                	ld	s9,40(sp)
    80005fde:	7d02                	ld	s10,32(sp)
    80005fe0:	6de2                	ld	s11,24(sp)
    80005fe2:	6129                	addi	sp,sp,192
    80005fe4:	8082                	ret
    release(&pr.lock);
    80005fe6:	00020517          	auipc	a0,0x20
    80005fea:	20250513          	addi	a0,a0,514 # 800261e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	3d8080e7          	jalr	984(ra) # 800063c6 <release>
}
    80005ff6:	bfc9                	j	80005fc8 <printf+0x1b6>

0000000080005ff8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ff8:	1101                	addi	sp,sp,-32
    80005ffa:	ec06                	sd	ra,24(sp)
    80005ffc:	e822                	sd	s0,16(sp)
    80005ffe:	e426                	sd	s1,8(sp)
    80006000:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006002:	00020497          	auipc	s1,0x20
    80006006:	1e648493          	addi	s1,s1,486 # 800261e8 <pr>
    8000600a:	00003597          	auipc	a1,0x3
    8000600e:	83658593          	addi	a1,a1,-1994 # 80008840 <syscalls+0x430>
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	26e080e7          	jalr	622(ra) # 80006282 <initlock>
  pr.locking = 1;
    8000601c:	4785                	li	a5,1
    8000601e:	cc9c                	sw	a5,24(s1)
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006032:	100007b7          	lui	a5,0x10000
    80006036:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000603a:	f8000713          	li	a4,-128
    8000603e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006042:	470d                	li	a4,3
    80006044:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006048:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000604c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006050:	469d                	li	a3,7
    80006052:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006056:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000605a:	00003597          	auipc	a1,0x3
    8000605e:	80658593          	addi	a1,a1,-2042 # 80008860 <digits+0x18>
    80006062:	00020517          	auipc	a0,0x20
    80006066:	1a650513          	addi	a0,a0,422 # 80026208 <uart_tx_lock>
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	218080e7          	jalr	536(ra) # 80006282 <initlock>
}
    80006072:	60a2                	ld	ra,8(sp)
    80006074:	6402                	ld	s0,0(sp)
    80006076:	0141                	addi	sp,sp,16
    80006078:	8082                	ret

000000008000607a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
    80006084:	84aa                	mv	s1,a0
  push_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	240080e7          	jalr	576(ra) # 800062c6 <push_off>

  if(panicked){
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	f8e7a783          	lw	a5,-114(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006096:	10000737          	lui	a4,0x10000
  if(panicked){
    8000609a:	c391                	beqz	a5,8000609e <uartputc_sync+0x24>
    for(;;)
    8000609c:	a001                	j	8000609c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060a2:	0ff7f793          	andi	a5,a5,255
    800060a6:	0207f793          	andi	a5,a5,32
    800060aa:	dbf5                	beqz	a5,8000609e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ac:	0ff4f793          	andi	a5,s1,255
    800060b0:	10000737          	lui	a4,0x10000
    800060b4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	2ae080e7          	jalr	686(ra) # 80006366 <pop_off>
}
    800060c0:	60e2                	ld	ra,24(sp)
    800060c2:	6442                	ld	s0,16(sp)
    800060c4:	64a2                	ld	s1,8(sp)
    800060c6:	6105                	addi	sp,sp,32
    800060c8:	8082                	ret

00000000800060ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ca:	00003717          	auipc	a4,0x3
    800060ce:	f5673703          	ld	a4,-170(a4) # 80009020 <uart_tx_r>
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	06e78c63          	beq	a5,a4,80006152 <uartstart+0x88>
{
    800060de:	7139                	addi	sp,sp,-64
    800060e0:	fc06                	sd	ra,56(sp)
    800060e2:	f822                	sd	s0,48(sp)
    800060e4:	f426                	sd	s1,40(sp)
    800060e6:	f04a                	sd	s2,32(sp)
    800060e8:	ec4e                	sd	s3,24(sp)
    800060ea:	e852                	sd	s4,16(sp)
    800060ec:	e456                	sd	s5,8(sp)
    800060ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f4:	00020a17          	auipc	s4,0x20
    800060f8:	114a0a13          	addi	s4,s4,276 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060fc:	00003497          	auipc	s1,0x3
    80006100:	f2448493          	addi	s1,s1,-220 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006104:	00003997          	auipc	s3,0x3
    80006108:	f2498993          	addi	s3,s3,-220 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006110:	0ff7f793          	andi	a5,a5,255
    80006114:	0207f793          	andi	a5,a5,32
    80006118:	c785                	beqz	a5,80006140 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611a:	01f77793          	andi	a5,a4,31
    8000611e:	97d2                	add	a5,a5,s4
    80006120:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006124:	0705                	addi	a4,a4,1
    80006126:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	6f4080e7          	jalr	1780(ra) # 8000181e <wakeup>
    
    WriteReg(THR, c);
    80006132:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006136:	6098                	ld	a4,0(s1)
    80006138:	0009b783          	ld	a5,0(s3)
    8000613c:	fce798e3          	bne	a5,a4,8000610c <uartstart+0x42>
  }
}
    80006140:	70e2                	ld	ra,56(sp)
    80006142:	7442                	ld	s0,48(sp)
    80006144:	74a2                	ld	s1,40(sp)
    80006146:	7902                	ld	s2,32(sp)
    80006148:	69e2                	ld	s3,24(sp)
    8000614a:	6a42                	ld	s4,16(sp)
    8000614c:	6aa2                	ld	s5,8(sp)
    8000614e:	6121                	addi	sp,sp,64
    80006150:	8082                	ret
    80006152:	8082                	ret

0000000080006154 <uartputc>:
{
    80006154:	7179                	addi	sp,sp,-48
    80006156:	f406                	sd	ra,40(sp)
    80006158:	f022                	sd	s0,32(sp)
    8000615a:	ec26                	sd	s1,24(sp)
    8000615c:	e84a                	sd	s2,16(sp)
    8000615e:	e44e                	sd	s3,8(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006166:	00020517          	auipc	a0,0x20
    8000616a:	0a250513          	addi	a0,a0,162 # 80026208 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a4080e7          	jalr	420(ra) # 80006312 <acquire>
  if(panicked){
    80006176:	00003797          	auipc	a5,0x3
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000901c <panicked>
    8000617e:	c391                	beqz	a5,80006182 <uartputc+0x2e>
    for(;;)
    80006180:	a001                	j	80006180 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006182:	00003797          	auipc	a5,0x3
    80006186:	ea67b783          	ld	a5,-346(a5) # 80009028 <uart_tx_w>
    8000618a:	00003717          	auipc	a4,0x3
    8000618e:	e9673703          	ld	a4,-362(a4) # 80009020 <uart_tx_r>
    80006192:	02070713          	addi	a4,a4,32
    80006196:	02f71b63          	bne	a4,a5,800061cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619a:	00020a17          	auipc	s4,0x20
    8000619e:	06ea0a13          	addi	s4,s4,110 # 80026208 <uart_tx_lock>
    800061a2:	00003497          	auipc	s1,0x3
    800061a6:	e7e48493          	addi	s1,s1,-386 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061aa:	00003917          	auipc	s2,0x3
    800061ae:	e7e90913          	addi	s2,s2,-386 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b2:	85d2                	mv	a1,s4
    800061b4:	8526                	mv	a0,s1
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	4dc080e7          	jalr	1244(ra) # 80001692 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061be:	00093783          	ld	a5,0(s2)
    800061c2:	6098                	ld	a4,0(s1)
    800061c4:	02070713          	addi	a4,a4,32
    800061c8:	fef705e3          	beq	a4,a5,800061b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061cc:	00020497          	auipc	s1,0x20
    800061d0:	03c48493          	addi	s1,s1,60 # 80026208 <uart_tx_lock>
    800061d4:	01f7f713          	andi	a4,a5,31
    800061d8:	9726                	add	a4,a4,s1
    800061da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061de:	0785                	addi	a5,a5,1
    800061e0:	00003717          	auipc	a4,0x3
    800061e4:	e4f73423          	sd	a5,-440(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	ee2080e7          	jalr	-286(ra) # 800060ca <uartstart>
      release(&uart_tx_lock);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	1d4080e7          	jalr	468(ra) # 800063c6 <release>
}
    800061fa:	70a2                	ld	ra,40(sp)
    800061fc:	7402                	ld	s0,32(sp)
    800061fe:	64e2                	ld	s1,24(sp)
    80006200:	6942                	ld	s2,16(sp)
    80006202:	69a2                	ld	s3,8(sp)
    80006204:	6a02                	ld	s4,0(sp)
    80006206:	6145                	addi	sp,sp,48
    80006208:	8082                	ret

000000008000620a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e422                	sd	s0,8(sp)
    8000620e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006210:	100007b7          	lui	a5,0x10000
    80006214:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006218:	8b85                	andi	a5,a5,1
    8000621a:	cb91                	beqz	a5,8000622e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006224:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006228:	6422                	ld	s0,8(sp)
    8000622a:	0141                	addi	sp,sp,16
    8000622c:	8082                	ret
    return -1;
    8000622e:	557d                	li	a0,-1
    80006230:	bfe5                	j	80006228 <uartgetc+0x1e>

0000000080006232 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000623c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	fcc080e7          	jalr	-52(ra) # 8000620a <uartgetc>
    if(c == -1)
    80006246:	00950763          	beq	a0,s1,80006254 <uartintr+0x22>
      break;
    consoleintr(c);
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	8fe080e7          	jalr	-1794(ra) # 80005b48 <consoleintr>
  while(1){
    80006252:	b7f5                	j	8000623e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006254:	00020497          	auipc	s1,0x20
    80006258:	fb448493          	addi	s1,s1,-76 # 80026208 <uart_tx_lock>
    8000625c:	8526                	mv	a0,s1
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	0b4080e7          	jalr	180(ra) # 80006312 <acquire>
  uartstart();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	e64080e7          	jalr	-412(ra) # 800060ca <uartstart>
  release(&uart_tx_lock);
    8000626e:	8526                	mv	a0,s1
    80006270:	00000097          	auipc	ra,0x0
    80006274:	156080e7          	jalr	342(ra) # 800063c6 <release>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret

0000000080006282 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006282:	1141                	addi	sp,sp,-16
    80006284:	e422                	sd	s0,8(sp)
    80006286:	0800                	addi	s0,sp,16
  lk->name = name;
    80006288:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000628a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628e:	00053823          	sd	zero,16(a0)
}
    80006292:	6422                	ld	s0,8(sp)
    80006294:	0141                	addi	sp,sp,16
    80006296:	8082                	ret

0000000080006298 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006298:	411c                	lw	a5,0(a0)
    8000629a:	e399                	bnez	a5,800062a0 <holding+0x8>
    8000629c:	4501                	li	a0,0
  return r;
}
    8000629e:	8082                	ret
{
    800062a0:	1101                	addi	sp,sp,-32
    800062a2:	ec06                	sd	ra,24(sp)
    800062a4:	e822                	sd	s0,16(sp)
    800062a6:	e426                	sd	s1,8(sp)
    800062a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062aa:	6904                	ld	s1,16(a0)
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	c56080e7          	jalr	-938(ra) # 80000f02 <mycpu>
    800062b4:	40a48533          	sub	a0,s1,a0
    800062b8:	00153513          	seqz	a0,a0
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret

00000000800062c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c6:	1101                	addi	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d0:	100024f3          	csrr	s1,sstatus
    800062d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	c24080e7          	jalr	-988(ra) # 80000f02 <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	cf89                	beqz	a5,80006302 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ea:	ffffb097          	auipc	ra,0xffffb
    800062ee:	c18080e7          	jalr	-1000(ra) # 80000f02 <mycpu>
    800062f2:	5d3c                	lw	a5,120(a0)
    800062f4:	2785                	addiw	a5,a5,1
    800062f6:	dd3c                	sw	a5,120(a0)
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret
    mycpu()->intena = old;
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	c00080e7          	jalr	-1024(ra) # 80000f02 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8085                	srli	s1,s1,0x1
    8000630c:	8885                	andi	s1,s1,1
    8000630e:	dd64                	sw	s1,124(a0)
    80006310:	bfe9                	j	800062ea <push_off+0x24>

0000000080006312 <acquire>:
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
    8000631c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	fa8080e7          	jalr	-88(ra) # 800062c6 <push_off>
  if(holding(lk))
    80006326:	8526                	mv	a0,s1
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	f70080e7          	jalr	-144(ra) # 80006298 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006330:	4705                	li	a4,1
  if(holding(lk))
    80006332:	e115                	bnez	a0,80006356 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006334:	87ba                	mv	a5,a4
    80006336:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000633a:	2781                	sext.w	a5,a5
    8000633c:	ffe5                	bnez	a5,80006334 <acquire+0x22>
  __sync_synchronize();
    8000633e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	bc0080e7          	jalr	-1088(ra) # 80000f02 <mycpu>
    8000634a:	e888                	sd	a0,16(s1)
}
    8000634c:	60e2                	ld	ra,24(sp)
    8000634e:	6442                	ld	s0,16(sp)
    80006350:	64a2                	ld	s1,8(sp)
    80006352:	6105                	addi	sp,sp,32
    80006354:	8082                	ret
    panic("acquire");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	51250513          	addi	a0,a0,1298 # 80008868 <digits+0x20>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	a6a080e7          	jalr	-1430(ra) # 80005dc8 <panic>

0000000080006366 <pop_off>:

void
pop_off(void)
{
    80006366:	1141                	addi	sp,sp,-16
    80006368:	e406                	sd	ra,8(sp)
    8000636a:	e022                	sd	s0,0(sp)
    8000636c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	b94080e7          	jalr	-1132(ra) # 80000f02 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006376:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000637a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000637c:	e78d                	bnez	a5,800063a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637e:	5d3c                	lw	a5,120(a0)
    80006380:	02f05b63          	blez	a5,800063b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006384:	37fd                	addiw	a5,a5,-1
    80006386:	0007871b          	sext.w	a4,a5
    8000638a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000638c:	eb09                	bnez	a4,8000639e <pop_off+0x38>
    8000638e:	5d7c                	lw	a5,124(a0)
    80006390:	c799                	beqz	a5,8000639e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006392:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006396:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639e:	60a2                	ld	ra,8(sp)
    800063a0:	6402                	ld	s0,0(sp)
    800063a2:	0141                	addi	sp,sp,16
    800063a4:	8082                	ret
    panic("pop_off - interruptible");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	4ca50513          	addi	a0,a0,1226 # 80008870 <digits+0x28>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a1a080e7          	jalr	-1510(ra) # 80005dc8 <panic>
    panic("pop_off");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	4d250513          	addi	a0,a0,1234 # 80008888 <digits+0x40>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a0a080e7          	jalr	-1526(ra) # 80005dc8 <panic>

00000000800063c6 <release>:
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
    800063d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	ec6080e7          	jalr	-314(ra) # 80006298 <holding>
    800063da:	c115                	beqz	a0,800063fe <release+0x38>
  lk->cpu = 0;
    800063dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e4:	0f50000f          	fence	iorw,ow
    800063e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	f7a080e7          	jalr	-134(ra) # 80006366 <pop_off>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret
    panic("release");
    800063fe:	00002517          	auipc	a0,0x2
    80006402:	49250513          	addi	a0,a0,1170 # 80008890 <digits+0x48>
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	9c2080e7          	jalr	-1598(ra) # 80005dc8 <panic>
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
