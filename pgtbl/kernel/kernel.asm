
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
    80000016:	115050ef          	jal	ra,8000592a <start>

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
    8000005e:	2b6080e7          	jalr	694(ra) # 80006310 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	356080e7          	jalr	854(ra) # 800063c4 <release>
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
    8000008e:	d4a080e7          	jalr	-694(ra) # 80005dd4 <panic>

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
    800000f8:	18c080e7          	jalr	396(ra) # 80006280 <initlock>
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
    80000130:	1e4080e7          	jalr	484(ra) # 80006310 <acquire>
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
    80000148:	280080e7          	jalr	640(ra) # 800063c4 <release>

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
    80000172:	256080e7          	jalr	598(ra) # 800063c4 <release>
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
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	ca0080e7          	jalr	-864(ra) # 80000fc6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00009717          	auipc	a4,0x9
    80000332:	cd270713          	addi	a4,a4,-814 # 80009000 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	c84080e7          	jalr	-892(ra) # 80000fc6 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	aca080e7          	jalr	-1334(ra) # 80005e1e <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	994080e7          	jalr	-1644(ra) # 80001cf8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	f94080e7          	jalr	-108(ra) # 80005300 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	242080e7          	jalr	578(ra) # 800015b6 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	96a080e7          	jalr	-1686(ra) # 80005ce6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	c7a080e7          	jalr	-902(ra) # 80005ffe <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	a8a080e7          	jalr	-1398(ra) # 80005e1e <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	a7a080e7          	jalr	-1414(ra) # 80005e1e <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a6a080e7          	jalr	-1430(ra) # 80005e1e <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	322080e7          	jalr	802(ra) # 800006e6 <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	b44080e7          	jalr	-1212(ra) # 80000f18 <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	8f4080e7          	jalr	-1804(ra) # 80001cd0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	914080e7          	jalr	-1772(ra) # 80001cf8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	efe080e7          	jalr	-258(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f0c080e7          	jalr	-244(ra) # 80005300 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	0ca080e7          	jalr	202(ra) # 800024c6 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	75a080e7          	jalr	1882(ra) # 80002b5e <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	704080e7          	jalr	1796(ra) # 80003b10 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	00e080e7          	jalr	14(ra) # 80005422 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	f64080e7          	jalr	-156(ra) # 80001380 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00009717          	auipc	a4,0x9
    8000042e:	bcf72b23          	sw	a5,-1066(a4) # 80009000 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043a:	00009797          	auipc	a5,0x9
    8000043e:	bce7b783          	ld	a5,-1074(a5) # 80009008 <kernel_pagetable>
    80000442:	83b1                	srli	a5,a5,0xc
    80000444:	577d                	li	a4,-1
    80000446:	177e                	slli	a4,a4,0x3f
    80000448:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000044e:	12000073          	sfence.vma
  sfence_vma();
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret

0000000080000458 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000458:	7139                	addi	sp,sp,-64
    8000045a:	fc06                	sd	ra,56(sp)
    8000045c:	f822                	sd	s0,48(sp)
    8000045e:	f426                	sd	s1,40(sp)
    80000460:	f04a                	sd	s2,32(sp)
    80000462:	ec4e                	sd	s3,24(sp)
    80000464:	e852                	sd	s4,16(sp)
    80000466:	e456                	sd	s5,8(sp)
    80000468:	e05a                	sd	s6,0(sp)
    8000046a:	0080                	addi	s0,sp,64
    8000046c:	84aa                	mv	s1,a0
    8000046e:	89ae                	mv	s3,a1
    80000470:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000472:	57fd                	li	a5,-1
    80000474:	83e9                	srli	a5,a5,0x1a
    80000476:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000478:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047a:	04b7f263          	bgeu	a5,a1,800004be <walk+0x66>
    panic("walk");
    8000047e:	00008517          	auipc	a0,0x8
    80000482:	bd250513          	addi	a0,a0,-1070 # 80008050 <etext+0x50>
    80000486:	00006097          	auipc	ra,0x6
    8000048a:	94e080e7          	jalr	-1714(ra) # 80005dd4 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048e:	060a8663          	beqz	s5,800004fa <walk+0xa2>
    80000492:	00000097          	auipc	ra,0x0
    80000496:	c86080e7          	jalr	-890(ra) # 80000118 <kalloc>
    8000049a:	84aa                	mv	s1,a0
    8000049c:	c529                	beqz	a0,800004e6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049e:	6605                	lui	a2,0x1
    800004a0:	4581                	li	a1,0
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	cd6080e7          	jalr	-810(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004aa:	00c4d793          	srli	a5,s1,0xc
    800004ae:	07aa                	slli	a5,a5,0xa
    800004b0:	0017e793          	ori	a5,a5,1
    800004b4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b8:	3a5d                	addiw	s4,s4,-9
    800004ba:	036a0063          	beq	s4,s6,800004da <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004be:	0149d933          	srl	s2,s3,s4
    800004c2:	1ff97913          	andi	s2,s2,511
    800004c6:	090e                	slli	s2,s2,0x3
    800004c8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ca:	00093483          	ld	s1,0(s2)
    800004ce:	0014f793          	andi	a5,s1,1
    800004d2:	dfd5                	beqz	a5,8000048e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d4:	80a9                	srli	s1,s1,0xa
    800004d6:	04b2                	slli	s1,s1,0xc
    800004d8:	b7c5                	j	800004b8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004da:	00c9d513          	srli	a0,s3,0xc
    800004de:	1ff57513          	andi	a0,a0,511
    800004e2:	050e                	slli	a0,a0,0x3
    800004e4:	9526                	add	a0,a0,s1
}
    800004e6:	70e2                	ld	ra,56(sp)
    800004e8:	7442                	ld	s0,48(sp)
    800004ea:	74a2                	ld	s1,40(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	69e2                	ld	s3,24(sp)
    800004f0:	6a42                	ld	s4,16(sp)
    800004f2:	6aa2                	ld	s5,8(sp)
    800004f4:	6b02                	ld	s6,0(sp)
    800004f6:	6121                	addi	sp,sp,64
    800004f8:	8082                	ret
        return 0;
    800004fa:	4501                	li	a0,0
    800004fc:	b7ed                	j	800004e6 <walk+0x8e>

00000000800004fe <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fe:	57fd                	li	a5,-1
    80000500:	83e9                	srli	a5,a5,0x1a
    80000502:	00b7f463          	bgeu	a5,a1,8000050a <walkaddr+0xc>
    return 0;
    80000506:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000508:	8082                	ret
{
    8000050a:	1141                	addi	sp,sp,-16
    8000050c:	e406                	sd	ra,8(sp)
    8000050e:	e022                	sd	s0,0(sp)
    80000510:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000512:	4601                	li	a2,0
    80000514:	00000097          	auipc	ra,0x0
    80000518:	f44080e7          	jalr	-188(ra) # 80000458 <walk>
  if(pte == 0)
    8000051c:	c105                	beqz	a0,8000053c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000520:	0117f693          	andi	a3,a5,17
    80000524:	4745                	li	a4,17
    return 0;
    80000526:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000528:	00e68663          	beq	a3,a4,80000534 <walkaddr+0x36>
}
    8000052c:	60a2                	ld	ra,8(sp)
    8000052e:	6402                	ld	s0,0(sp)
    80000530:	0141                	addi	sp,sp,16
    80000532:	8082                	ret
  pa = PTE2PA(*pte);
    80000534:	00a7d513          	srli	a0,a5,0xa
    80000538:	0532                	slli	a0,a0,0xc
  return pa;
    8000053a:	bfcd                	j	8000052c <walkaddr+0x2e>
    return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	b7fd                	j	8000052c <walkaddr+0x2e>

0000000080000540 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000540:	715d                	addi	sp,sp,-80
    80000542:	e486                	sd	ra,72(sp)
    80000544:	e0a2                	sd	s0,64(sp)
    80000546:	fc26                	sd	s1,56(sp)
    80000548:	f84a                	sd	s2,48(sp)
    8000054a:	f44e                	sd	s3,40(sp)
    8000054c:	f052                	sd	s4,32(sp)
    8000054e:	ec56                	sd	s5,24(sp)
    80000550:	e85a                	sd	s6,16(sp)
    80000552:	e45e                	sd	s7,8(sp)
    80000554:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000556:	c639                	beqz	a2,800005a4 <mappages+0x64>
    80000558:	8aaa                	mv	s5,a0
    8000055a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055c:	77fd                	lui	a5,0xfffff
    8000055e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000562:	15fd                	addi	a1,a1,-1
    80000564:	00c589b3          	add	s3,a1,a2
    80000568:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000056c:	8952                	mv	s2,s4
    8000056e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000572:	6b85                	lui	s7,0x1
    80000574:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000578:	4605                	li	a2,1
    8000057a:	85ca                	mv	a1,s2
    8000057c:	8556                	mv	a0,s5
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	eda080e7          	jalr	-294(ra) # 80000458 <walk>
    80000586:	cd1d                	beqz	a0,800005c4 <mappages+0x84>
    if(*pte & PTE_V)
    80000588:	611c                	ld	a5,0(a0)
    8000058a:	8b85                	andi	a5,a5,1
    8000058c:	e785                	bnez	a5,800005b4 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000058e:	80b1                	srli	s1,s1,0xc
    80000590:	04aa                	slli	s1,s1,0xa
    80000592:	0164e4b3          	or	s1,s1,s6
    80000596:	0014e493          	ori	s1,s1,1
    8000059a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059c:	05390063          	beq	s2,s3,800005dc <mappages+0x9c>
    a += PGSIZE;
    800005a0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a2:	bfc9                	j	80000574 <mappages+0x34>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00006097          	auipc	ra,0x6
    800005b0:	828080e7          	jalr	-2008(ra) # 80005dd4 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00006097          	auipc	ra,0x6
    800005c0:	818080e7          	jalr	-2024(ra) # 80005dd4 <panic>
      return -1;
    800005c4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c6:	60a6                	ld	ra,72(sp)
    800005c8:	6406                	ld	s0,64(sp)
    800005ca:	74e2                	ld	s1,56(sp)
    800005cc:	7942                	ld	s2,48(sp)
    800005ce:	79a2                	ld	s3,40(sp)
    800005d0:	7a02                	ld	s4,32(sp)
    800005d2:	6ae2                	ld	s5,24(sp)
    800005d4:	6b42                	ld	s6,16(sp)
    800005d6:	6ba2                	ld	s7,8(sp)
    800005d8:	6161                	addi	sp,sp,80
    800005da:	8082                	ret
  return 0;
    800005dc:	4501                	li	a0,0
    800005de:	b7e5                	j	800005c6 <mappages+0x86>

00000000800005e0 <kvmmap>:
{
    800005e0:	1141                	addi	sp,sp,-16
    800005e2:	e406                	sd	ra,8(sp)
    800005e4:	e022                	sd	s0,0(sp)
    800005e6:	0800                	addi	s0,sp,16
    800005e8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ea:	86b2                	mv	a3,a2
    800005ec:	863e                	mv	a2,a5
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	f52080e7          	jalr	-174(ra) # 80000540 <mappages>
    800005f6:	e509                	bnez	a0,80000600 <kvmmap+0x20>
}
    800005f8:	60a2                	ld	ra,8(sp)
    800005fa:	6402                	ld	s0,0(sp)
    800005fc:	0141                	addi	sp,sp,16
    800005fe:	8082                	ret
    panic("kvmmap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a7850513          	addi	a0,a0,-1416 # 80008078 <etext+0x78>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	7cc080e7          	jalr	1996(ra) # 80005dd4 <panic>

0000000080000610 <kvmmake>:
{
    80000610:	1101                	addi	sp,sp,-32
    80000612:	ec06                	sd	ra,24(sp)
    80000614:	e822                	sd	s0,16(sp)
    80000616:	e426                	sd	s1,8(sp)
    80000618:	e04a                	sd	s2,0(sp)
    8000061a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	afc080e7          	jalr	-1284(ra) # 80000118 <kalloc>
    80000624:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000626:	6605                	lui	a2,0x1
    80000628:	4581                	li	a1,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	b4e080e7          	jalr	-1202(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000632:	4719                	li	a4,6
    80000634:	6685                	lui	a3,0x1
    80000636:	10000637          	lui	a2,0x10000
    8000063a:	100005b7          	lui	a1,0x10000
    8000063e:	8526                	mv	a0,s1
    80000640:	00000097          	auipc	ra,0x0
    80000644:	fa0080e7          	jalr	-96(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000648:	4719                	li	a4,6
    8000064a:	6685                	lui	a3,0x1
    8000064c:	10001637          	lui	a2,0x10001
    80000650:	100015b7          	lui	a1,0x10001
    80000654:	8526                	mv	a0,s1
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f8a080e7          	jalr	-118(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000065e:	4719                	li	a4,6
    80000660:	004006b7          	lui	a3,0x400
    80000664:	0c000637          	lui	a2,0xc000
    80000668:	0c0005b7          	lui	a1,0xc000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	f72080e7          	jalr	-142(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000676:	00008917          	auipc	s2,0x8
    8000067a:	98a90913          	addi	s2,s2,-1654 # 80008000 <etext>
    8000067e:	4729                	li	a4,10
    80000680:	80008697          	auipc	a3,0x80008
    80000684:	98068693          	addi	a3,a3,-1664 # 8000 <_entry-0x7fff8000>
    80000688:	4605                	li	a2,1
    8000068a:	067e                	slli	a2,a2,0x1f
    8000068c:	85b2                	mv	a1,a2
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f50080e7          	jalr	-176(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000698:	4719                	li	a4,6
    8000069a:	46c5                	li	a3,17
    8000069c:	06ee                	slli	a3,a3,0x1b
    8000069e:	412686b3          	sub	a3,a3,s2
    800006a2:	864a                	mv	a2,s2
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f38080e7          	jalr	-200(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b0:	4729                	li	a4,10
    800006b2:	6685                	lui	a3,0x1
    800006b4:	00007617          	auipc	a2,0x7
    800006b8:	94c60613          	addi	a2,a2,-1716 # 80007000 <_trampoline>
    800006bc:	040005b7          	lui	a1,0x4000
    800006c0:	15fd                	addi	a1,a1,-1
    800006c2:	05b2                	slli	a1,a1,0xc
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f1a080e7          	jalr	-230(ra) # 800005e0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	7b4080e7          	jalr	1972(ra) # 80000e84 <proc_mapstacks>
}
    800006d8:	8526                	mv	a0,s1
    800006da:	60e2                	ld	ra,24(sp)
    800006dc:	6442                	ld	s0,16(sp)
    800006de:	64a2                	ld	s1,8(sp)
    800006e0:	6902                	ld	s2,0(sp)
    800006e2:	6105                	addi	sp,sp,32
    800006e4:	8082                	ret

00000000800006e6 <kvminit>:
{
    800006e6:	1141                	addi	sp,sp,-16
    800006e8:	e406                	sd	ra,8(sp)
    800006ea:	e022                	sd	s0,0(sp)
    800006ec:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f22080e7          	jalr	-222(ra) # 80000610 <kvmmake>
    800006f6:	00009797          	auipc	a5,0x9
    800006fa:	90a7b923          	sd	a0,-1774(a5) # 80009008 <kernel_pagetable>
}
    800006fe:	60a2                	ld	ra,8(sp)
    80000700:	6402                	ld	s0,0(sp)
    80000702:	0141                	addi	sp,sp,16
    80000704:	8082                	ret

0000000080000706 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000706:	715d                	addi	sp,sp,-80
    80000708:	e486                	sd	ra,72(sp)
    8000070a:	e0a2                	sd	s0,64(sp)
    8000070c:	fc26                	sd	s1,56(sp)
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071c:	03459793          	slli	a5,a1,0x34
    80000720:	e795                	bnez	a5,8000074c <uvmunmap+0x46>
    80000722:	8a2a                	mv	s4,a0
    80000724:	892e                	mv	s2,a1
    80000726:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	0632                	slli	a2,a2,0xc
    8000072a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	6b05                	lui	s6,0x1
    80000732:	0735e263          	bltu	a1,s3,80000796 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	74e2                	ld	s1,56(sp)
    8000073c:	7942                	ld	s2,48(sp)
    8000073e:	79a2                	ld	s3,40(sp)
    80000740:	7a02                	ld	s4,32(sp)
    80000742:	6ae2                	ld	s5,24(sp)
    80000744:	6b42                	ld	s6,16(sp)
    80000746:	6ba2                	ld	s7,8(sp)
    80000748:	6161                	addi	sp,sp,80
    8000074a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074c:	00008517          	auipc	a0,0x8
    80000750:	93450513          	addi	a0,a0,-1740 # 80008080 <etext+0x80>
    80000754:	00005097          	auipc	ra,0x5
    80000758:	680080e7          	jalr	1664(ra) # 80005dd4 <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	93c50513          	addi	a0,a0,-1732 # 80008098 <etext+0x98>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	670080e7          	jalr	1648(ra) # 80005dd4 <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	93c50513          	addi	a0,a0,-1732 # 800080a8 <etext+0xa8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	660080e7          	jalr	1632(ra) # 80005dd4 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	650080e7          	jalr	1616(ra) # 80005dd4 <panic>
    *pte = 0;
    8000078c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000790:	995a                	add	s2,s2,s6
    80000792:	fb3972e3          	bgeu	s2,s3,80000736 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000796:	4601                	li	a2,0
    80000798:	85ca                	mv	a1,s2
    8000079a:	8552                	mv	a0,s4
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	cbc080e7          	jalr	-836(ra) # 80000458 <walk>
    800007a4:	84aa                	mv	s1,a0
    800007a6:	d95d                	beqz	a0,8000075c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007a8:	6108                	ld	a0,0(a0)
    800007aa:	00157793          	andi	a5,a0,1
    800007ae:	dfdd                	beqz	a5,8000076c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b0:	3ff57793          	andi	a5,a0,1023
    800007b4:	fd7784e3          	beq	a5,s7,8000077c <uvmunmap+0x76>
    if(do_free){
    800007b8:	fc0a8ae3          	beqz	s5,8000078c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    800007c8:	b7d1                	j	8000078c <uvmunmap+0x86>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	944080e7          	jalr	-1724(ra) # 80000118 <kalloc>
    800007dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007de:	c519                	beqz	a0,800007ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e0:	6605                	lui	a2,0x1
    800007e2:	4581                	li	a1,0
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	994080e7          	jalr	-1644(ra) # 80000178 <memset>
  return pagetable;
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f8:	7179                	addi	sp,sp,-48
    800007fa:	f406                	sd	ra,40(sp)
    800007fc:	f022                	sd	s0,32(sp)
    800007fe:	ec26                	sd	s1,24(sp)
    80000800:	e84a                	sd	s2,16(sp)
    80000802:	e44e                	sd	s3,8(sp)
    80000804:	e052                	sd	s4,0(sp)
    80000806:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000808:	6785                	lui	a5,0x1
    8000080a:	04f67863          	bgeu	a2,a5,8000085a <uvminit+0x62>
    8000080e:	8a2a                	mv	s4,a0
    80000810:	89ae                	mv	s3,a1
    80000812:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	904080e7          	jalr	-1788(ra) # 80000118 <kalloc>
    8000081c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082a:	4779                	li	a4,30
    8000082c:	86ca                	mv	a3,s2
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	8552                	mv	a0,s4
    80000834:	00000097          	auipc	ra,0x0
    80000838:	d0c080e7          	jalr	-756(ra) # 80000540 <mappages>
  memmove(mem, src, sz);
    8000083c:	8626                	mv	a2,s1
    8000083e:	85ce                	mv	a1,s3
    80000840:	854a                	mv	a0,s2
    80000842:	00000097          	auipc	ra,0x0
    80000846:	992080e7          	jalr	-1646(ra) # 800001d4 <memmove>
}
    8000084a:	70a2                	ld	ra,40(sp)
    8000084c:	7402                	ld	s0,32(sp)
    8000084e:	64e2                	ld	s1,24(sp)
    80000850:	6942                	ld	s2,16(sp)
    80000852:	69a2                	ld	s3,8(sp)
    80000854:	6a02                	ld	s4,0(sp)
    80000856:	6145                	addi	sp,sp,48
    80000858:	8082                	ret
    panic("inituvm: more than a page");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	87e50513          	addi	a0,a0,-1922 # 800080d8 <etext+0xd8>
    80000862:	00005097          	auipc	ra,0x5
    80000866:	572080e7          	jalr	1394(ra) # 80005dd4 <panic>

000000008000086a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000874:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000876:	00b67d63          	bgeu	a2,a1,80000890 <uvmdealloc+0x26>
    8000087a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087c:	6785                	lui	a5,0x1
    8000087e:	17fd                	addi	a5,a5,-1
    80000880:	00f60733          	add	a4,a2,a5
    80000884:	767d                	lui	a2,0xfffff
    80000886:	8f71                	and	a4,a4,a2
    80000888:	97ae                	add	a5,a5,a1
    8000088a:	8ff1                	and	a5,a5,a2
    8000088c:	00f76863          	bltu	a4,a5,8000089c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000890:	8526                	mv	a0,s1
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089c:	8f99                	sub	a5,a5,a4
    8000089e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a0:	4685                	li	a3,1
    800008a2:	0007861b          	sext.w	a2,a5
    800008a6:	85ba                	mv	a1,a4
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	e5e080e7          	jalr	-418(ra) # 80000706 <uvmunmap>
    800008b0:	b7c5                	j	80000890 <uvmdealloc+0x26>

00000000800008b2 <uvmalloc>:
  if(newsz < oldsz)
    800008b2:	0ab66163          	bltu	a2,a1,80000954 <uvmalloc+0xa2>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f063          	bgeu	s3,a2,80000958 <uvmalloc+0xa6>
    800008dc:	894e                	mv	s2,s3
    mem = kalloc();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	83a080e7          	jalr	-1990(ra) # 80000118 <kalloc>
    800008e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e8:	c51d                	beqz	a0,80000916 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	88a080e7          	jalr	-1910(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f6:	4779                	li	a4,30
    800008f8:	86a6                	mv	a3,s1
    800008fa:	6605                	lui	a2,0x1
    800008fc:	85ca                	mv	a1,s2
    800008fe:	8556                	mv	a0,s5
    80000900:	00000097          	auipc	ra,0x0
    80000904:	c40080e7          	jalr	-960(ra) # 80000540 <mappages>
    80000908:	e905                	bnez	a0,80000938 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	6785                	lui	a5,0x1
    8000090c:	993e                	add	s2,s2,a5
    8000090e:	fd4968e3          	bltu	s2,s4,800008de <uvmalloc+0x2c>
  return newsz;
    80000912:	8552                	mv	a0,s4
    80000914:	a809                	j	80000926 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4e080e7          	jalr	-178(ra) # 8000086a <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	70e2                	ld	ra,56(sp)
    80000928:	7442                	ld	s0,48(sp)
    8000092a:	74a2                	ld	s1,40(sp)
    8000092c:	7902                	ld	s2,32(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f22080e7          	jalr	-222(ra) # 8000086a <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfd1                	j	80000926 <uvmalloc+0x74>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7f1                	j	80000926 <uvmalloc+0x74>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a821                	j	8000098e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097a:	0532                	slli	a0,a0,0xc
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	fe0080e7          	jalr	-32(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000984:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000988:	04a1                	addi	s1,s1,8
    8000098a:	03248163          	beq	s1,s2,800009ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000990:	00f57793          	andi	a5,a0,15
    80000994:	ff3782e3          	beq	a5,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000998:	8905                	andi	a0,a0,1
    8000099a:	d57d                	beqz	a0,80000988 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099c:	00007517          	auipc	a0,0x7
    800009a0:	75c50513          	addi	a0,a0,1884 # 800080f8 <etext+0xf8>
    800009a4:	00005097          	auipc	ra,0x5
    800009a8:	430080e7          	jalr	1072(ra) # 80005dd4 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ac:	8552                	mv	a0,s4
    800009ae:	fffff097          	auipc	ra,0xfffff
    800009b2:	66e080e7          	jalr	1646(ra) # 8000001c <kfree>
}
    800009b6:	70a2                	ld	ra,40(sp)
    800009b8:	7402                	ld	s0,32(sp)
    800009ba:	64e2                	ld	s1,24(sp)
    800009bc:	6942                	ld	s2,16(sp)
    800009be:	69a2                	ld	s3,8(sp)
    800009c0:	6a02                	ld	s4,0(sp)
    800009c2:	6145                	addi	sp,sp,48
    800009c4:	8082                	ret

00000000800009c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
    800009d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d2:	e999                	bnez	a1,800009e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f86080e7          	jalr	-122(ra) # 8000095c <freewalk>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e8:	6605                	lui	a2,0x1
    800009ea:	167d                	addi	a2,a2,-1
    800009ec:	962e                	add	a2,a2,a1
    800009ee:	4685                	li	a3,1
    800009f0:	8231                	srli	a2,a2,0xc
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	d12080e7          	jalr	-750(ra) # 80000706 <uvmunmap>
    800009fc:	bfe1                	j	800009d4 <uvmfree+0xe>

00000000800009fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fe:	c679                	beqz	a2,80000acc <uvmcopy+0xce>
{
    80000a00:	715d                	addi	sp,sp,-80
    80000a02:	e486                	sd	ra,72(sp)
    80000a04:	e0a2                	sd	s0,64(sp)
    80000a06:	fc26                	sd	s1,56(sp)
    80000a08:	f84a                	sd	s2,48(sp)
    80000a0a:	f44e                	sd	s3,40(sp)
    80000a0c:	f052                	sd	s4,32(sp)
    80000a0e:	ec56                	sd	s5,24(sp)
    80000a10:	e85a                	sd	s6,16(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	0880                	addi	s0,sp,80
    80000a16:	8b2a                	mv	s6,a0
    80000a18:	8aae                	mv	s5,a1
    80000a1a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a1e:	4601                	li	a2,0
    80000a20:	85ce                	mv	a1,s3
    80000a22:	855a                	mv	a0,s6
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	a34080e7          	jalr	-1484(ra) # 80000458 <walk>
    80000a2c:	c531                	beqz	a0,80000a78 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a2e:	6118                	ld	a4,0(a0)
    80000a30:	00177793          	andi	a5,a4,1
    80000a34:	cbb1                	beqz	a5,80000a88 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a36:	00a75593          	srli	a1,a4,0xa
    80000a3a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	6d6080e7          	jalr	1750(ra) # 80000118 <kalloc>
    80000a4a:	892a                	mv	s2,a0
    80000a4c:	c939                	beqz	a0,80000aa2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	85de                	mv	a1,s7
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	782080e7          	jalr	1922(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5a:	8726                	mv	a4,s1
    80000a5c:	86ca                	mv	a3,s2
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85ce                	mv	a1,s3
    80000a62:	8556                	mv	a0,s5
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	adc080e7          	jalr	-1316(ra) # 80000540 <mappages>
    80000a6c:	e515                	bnez	a0,80000a98 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	99be                	add	s3,s3,a5
    80000a72:	fb49e6e3          	bltu	s3,s4,80000a1e <uvmcopy+0x20>
    80000a76:	a081                	j	80000ab6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	69050513          	addi	a0,a0,1680 # 80008108 <etext+0x108>
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	354080e7          	jalr	852(ra) # 80005dd4 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6a050513          	addi	a0,a0,1696 # 80008128 <etext+0x128>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	344080e7          	jalr	836(ra) # 80005dd4 <panic>
      kfree(mem);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c9d613          	srli	a2,s3,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c5a080e7          	jalr	-934(ra) # 80000706 <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret

0000000080000ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad8:	4601                	li	a2,0
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	97e080e7          	jalr	-1666(ra) # 80000458 <walk>
  if(pte == 0)
    80000ae2:	c901                	beqz	a0,80000af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae4:	611c                	ld	a5,0(a0)
    80000ae6:	9bbd                	andi	a5,a5,-17
    80000ae8:	e11c                	sd	a5,0(a0)
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret
    panic("uvmclear");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	65650513          	addi	a0,a0,1622 # 80008148 <etext+0x148>
    80000afa:	00005097          	auipc	ra,0x5
    80000afe:	2da080e7          	jalr	730(ra) # 80005dd4 <panic>

0000000080000b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b02:	c6bd                	beqz	a3,80000b70 <copyout+0x6e>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	e062                	sd	s8,0(sp)
    80000b1a:	0880                	addi	s0,sp,80
    80000b1c:	8b2a                	mv	s6,a0
    80000b1e:	8c2e                	mv	s8,a1
    80000b20:	8a32                	mv	s4,a2
    80000b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b26:	6a85                	lui	s5,0x1
    80000b28:	a015                	j	80000b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2a:	9562                	add	a0,a0,s8
    80000b2c:	0004861b          	sext.w	a2,s1
    80000b30:	85d2                	mv	a1,s4
    80000b32:	41250533          	sub	a0,a0,s2
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	69e080e7          	jalr	1694(ra) # 800001d4 <memmove>

    len -= n;
    80000b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b48:	02098263          	beqz	s3,80000b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b50:	85ca                	mv	a1,s2
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	9aa080e7          	jalr	-1622(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000b5c:	cd01                	beqz	a0,80000b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5e:	418904b3          	sub	s1,s2,s8
    80000b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b64:	fc99f3e3          	bgeu	s3,s1,80000b2a <copyout+0x28>
    80000b68:	84ce                	mv	s1,s3
    80000b6a:	b7c1                	j	80000b2a <copyout+0x28>
  }
  return 0;
    80000b6c:	4501                	li	a0,0
    80000b6e:	a021                	j	80000b76 <copyout+0x74>
    80000b70:	4501                	li	a0,0
}
    80000b72:	8082                	ret
      return -1;
    80000b74:	557d                	li	a0,-1
}
    80000b76:	60a6                	ld	ra,72(sp)
    80000b78:	6406                	ld	s0,64(sp)
    80000b7a:	74e2                	ld	s1,56(sp)
    80000b7c:	7942                	ld	s2,48(sp)
    80000b7e:	79a2                	ld	s3,40(sp)
    80000b80:	7a02                	ld	s4,32(sp)
    80000b82:	6ae2                	ld	s5,24(sp)
    80000b84:	6b42                	ld	s6,16(sp)
    80000b86:	6ba2                	ld	s7,8(sp)
    80000b88:	6c02                	ld	s8,0(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret

0000000080000b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8e:	caa5                	beqz	a3,80000bfe <copyin+0x70>
{
    80000b90:	715d                	addi	sp,sp,-80
    80000b92:	e486                	sd	ra,72(sp)
    80000b94:	e0a2                	sd	s0,64(sp)
    80000b96:	fc26                	sd	s1,56(sp)
    80000b98:	f84a                	sd	s2,48(sp)
    80000b9a:	f44e                	sd	s3,40(sp)
    80000b9c:	f052                	sd	s4,32(sp)
    80000b9e:	ec56                	sd	s5,24(sp)
    80000ba0:	e85a                	sd	s6,16(sp)
    80000ba2:	e45e                	sd	s7,8(sp)
    80000ba4:	e062                	sd	s8,0(sp)
    80000ba6:	0880                	addi	s0,sp,80
    80000ba8:	8b2a                	mv	s6,a0
    80000baa:	8a2e                	mv	s4,a1
    80000bac:	8c32                	mv	s8,a2
    80000bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb2:	6a85                	lui	s5,0x1
    80000bb4:	a01d                	j	80000bda <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb6:	018505b3          	add	a1,a0,s8
    80000bba:	0004861b          	sext.w	a2,s1
    80000bbe:	412585b3          	sub	a1,a1,s2
    80000bc2:	8552                	mv	a0,s4
    80000bc4:	fffff097          	auipc	ra,0xfffff
    80000bc8:	610080e7          	jalr	1552(ra) # 800001d4 <memmove>

    len -= n;
    80000bcc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd6:	02098263          	beqz	s3,80000bfa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bde:	85ca                	mv	a1,s2
    80000be0:	855a                	mv	a0,s6
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	91c080e7          	jalr	-1764(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000bea:	cd01                	beqz	a0,80000c02 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bec:	418904b3          	sub	s1,s2,s8
    80000bf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf2:	fc99f2e3          	bgeu	s3,s1,80000bb6 <copyin+0x28>
    80000bf6:	84ce                	mv	s1,s3
    80000bf8:	bf7d                	j	80000bb6 <copyin+0x28>
  }
  return 0;
    80000bfa:	4501                	li	a0,0
    80000bfc:	a021                	j	80000c04 <copyin+0x76>
    80000bfe:	4501                	li	a0,0
}
    80000c00:	8082                	ret
      return -1;
    80000c02:	557d                	li	a0,-1
}
    80000c04:	60a6                	ld	ra,72(sp)
    80000c06:	6406                	ld	s0,64(sp)
    80000c08:	74e2                	ld	s1,56(sp)
    80000c0a:	7942                	ld	s2,48(sp)
    80000c0c:	79a2                	ld	s3,40(sp)
    80000c0e:	7a02                	ld	s4,32(sp)
    80000c10:	6ae2                	ld	s5,24(sp)
    80000c12:	6b42                	ld	s6,16(sp)
    80000c14:	6ba2                	ld	s7,8(sp)
    80000c16:	6c02                	ld	s8,0(sp)
    80000c18:	6161                	addi	sp,sp,80
    80000c1a:	8082                	ret

0000000080000c1c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c1c:	c6c5                	beqz	a3,80000cc4 <copyinstr+0xa8>
{
    80000c1e:	715d                	addi	sp,sp,-80
    80000c20:	e486                	sd	ra,72(sp)
    80000c22:	e0a2                	sd	s0,64(sp)
    80000c24:	fc26                	sd	s1,56(sp)
    80000c26:	f84a                	sd	s2,48(sp)
    80000c28:	f44e                	sd	s3,40(sp)
    80000c2a:	f052                	sd	s4,32(sp)
    80000c2c:	ec56                	sd	s5,24(sp)
    80000c2e:	e85a                	sd	s6,16(sp)
    80000c30:	e45e                	sd	s7,8(sp)
    80000c32:	0880                	addi	s0,sp,80
    80000c34:	8a2a                	mv	s4,a0
    80000c36:	8b2e                	mv	s6,a1
    80000c38:	8bb2                	mv	s7,a2
    80000c3a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3e:	6985                	lui	s3,0x1
    80000c40:	a035                	j	80000c6c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c42:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c46:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c48:	0017b793          	seqz	a5,a5
    80000c4c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c50:	60a6                	ld	ra,72(sp)
    80000c52:	6406                	ld	s0,64(sp)
    80000c54:	74e2                	ld	s1,56(sp)
    80000c56:	7942                	ld	s2,48(sp)
    80000c58:	79a2                	ld	s3,40(sp)
    80000c5a:	7a02                	ld	s4,32(sp)
    80000c5c:	6ae2                	ld	s5,24(sp)
    80000c5e:	6b42                	ld	s6,16(sp)
    80000c60:	6ba2                	ld	s7,8(sp)
    80000c62:	6161                	addi	sp,sp,80
    80000c64:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c66:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6a:	c8a9                	beqz	s1,80000cbc <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c6c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c70:	85ca                	mv	a1,s2
    80000c72:	8552                	mv	a0,s4
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	88a080e7          	jalr	-1910(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000c7c:	c131                	beqz	a0,80000cc0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c7e:	41790833          	sub	a6,s2,s7
    80000c82:	984e                	add	a6,a6,s3
    if(n > max)
    80000c84:	0104f363          	bgeu	s1,a6,80000c8a <copyinstr+0x6e>
    80000c88:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8a:	955e                	add	a0,a0,s7
    80000c8c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c90:	fc080be3          	beqz	a6,80000c66 <copyinstr+0x4a>
    80000c94:	985a                	add	a6,a6,s6
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	14fd                	addi	s1,s1,-1
    80000c9e:	9b26                	add	s6,s6,s1
    80000ca0:	00f60733          	add	a4,a2,a5
    80000ca4:	00074703          	lbu	a4,0(a4)
    80000ca8:	df49                	beqz	a4,80000c42 <copyinstr+0x26>
        *dst = *p;
    80000caa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cae:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	ff0796e3          	bne	a5,a6,80000ca0 <copyinstr+0x84>
      dst++;
    80000cb8:	8b42                	mv	s6,a6
    80000cba:	b775                	j	80000c66 <copyinstr+0x4a>
    80000cbc:	4781                	li	a5,0
    80000cbe:	b769                	j	80000c48 <copyinstr+0x2c>
      return -1;
    80000cc0:	557d                	li	a0,-1
    80000cc2:	b779                	j	80000c50 <copyinstr+0x34>
  int got_null = 0;
    80000cc4:	4781                	li	a5,0
  if(got_null){
    80000cc6:	0017b793          	seqz	a5,a5
    80000cca:	40f00533          	neg	a0,a5
}
    80000cce:	8082                	ret

0000000080000cd0 <vmprintchild>:

void vmprintchild(pagetable_t pagetable, int depth)
{
    80000cd0:	7159                	addi	sp,sp,-112
    80000cd2:	f486                	sd	ra,104(sp)
    80000cd4:	f0a2                	sd	s0,96(sp)
    80000cd6:	eca6                	sd	s1,88(sp)
    80000cd8:	e8ca                	sd	s2,80(sp)
    80000cda:	e4ce                	sd	s3,72(sp)
    80000cdc:	e0d2                	sd	s4,64(sp)
    80000cde:	fc56                	sd	s5,56(sp)
    80000ce0:	f85a                	sd	s6,48(sp)
    80000ce2:	f45e                	sd	s7,40(sp)
    80000ce4:	f062                	sd	s8,32(sp)
    80000ce6:	ec66                	sd	s9,24(sp)
    80000ce8:	e86a                	sd	s10,16(sp)
    80000cea:	e46e                	sd	s11,8(sp)
    80000cec:	1880                	addi	s0,sp,112
    80000cee:	89ae                	mv	s3,a1
    for(int i=0;i<512;i++)
    80000cf0:	8aaa                	mv	s5,a0
    80000cf2:	4a01                	li	s4,0
    {
      pte_t pte = pagetable[i];
      if(pte & PTE_V && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000cf4:	4c85                	li	s9,1
              printf("..");
            else
              printf(" ..");
        }
        uint64 pa = PTE2PA(pte);
        printf("%d: pte %p pa %p\n",i,pte,pa);
    80000cf6:	00007d17          	auipc	s10,0x7
    80000cfa:	472d0d13          	addi	s10,s10,1138 # 80008168 <etext+0x168>
              printf(" ..");
    80000cfe:	00007b17          	auipc	s6,0x7
    80000d02:	462b0b13          	addi	s6,s6,1122 # 80008160 <etext+0x160>
              printf("..");
    80000d06:	00007b97          	auipc	s7,0x7
    80000d0a:	452b8b93          	addi	s7,s7,1106 # 80008158 <etext+0x158>
        vmprintchild((pagetable_t)child,depth+1);
    80000d0e:	00158d9b          	addiw	s11,a1,1
    for(int i=0;i<512;i++)
    80000d12:	20000c13          	li	s8,512
    80000d16:	a059                	j	80000d9c <vmprintchild+0xcc>
        for(int j=0;j<depth;j++)
    80000d18:	03305363          	blez	s3,80000d3e <vmprintchild+0x6e>
    80000d1c:	4481                	li	s1,0
    80000d1e:	a809                	j	80000d30 <vmprintchild+0x60>
              printf("..");
    80000d20:	855e                	mv	a0,s7
    80000d22:	00005097          	auipc	ra,0x5
    80000d26:	0fc080e7          	jalr	252(ra) # 80005e1e <printf>
        for(int j=0;j<depth;j++)
    80000d2a:	2485                	addiw	s1,s1,1
    80000d2c:	00998963          	beq	s3,s1,80000d3e <vmprintchild+0x6e>
            if(j==0)
    80000d30:	d8e5                	beqz	s1,80000d20 <vmprintchild+0x50>
              printf(" ..");
    80000d32:	855a                	mv	a0,s6
    80000d34:	00005097          	auipc	ra,0x5
    80000d38:	0ea080e7          	jalr	234(ra) # 80005e1e <printf>
    80000d3c:	b7fd                	j	80000d2a <vmprintchild+0x5a>
        uint64 child = PTE2PA(pte);
    80000d3e:	00a95493          	srli	s1,s2,0xa
    80000d42:	04b2                	slli	s1,s1,0xc
        printf("%d: pte %p pa %p\n",i,pte,child);
    80000d44:	86a6                	mv	a3,s1
    80000d46:	864a                	mv	a2,s2
    80000d48:	85d2                	mv	a1,s4
    80000d4a:	856a                	mv	a0,s10
    80000d4c:	00005097          	auipc	ra,0x5
    80000d50:	0d2080e7          	jalr	210(ra) # 80005e1e <printf>
        vmprintchild((pagetable_t)child,depth+1);
    80000d54:	85ee                	mv	a1,s11
    80000d56:	8526                	mv	a0,s1
    80000d58:	00000097          	auipc	ra,0x0
    80000d5c:	f78080e7          	jalr	-136(ra) # 80000cd0 <vmprintchild>
    80000d60:	a815                	j	80000d94 <vmprintchild+0xc4>
              printf(" ..");
    80000d62:	855a                	mv	a0,s6
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	0ba080e7          	jalr	186(ra) # 80005e1e <printf>
        for(int j=0;j<depth;j++)
    80000d6c:	2485                	addiw	s1,s1,1
    80000d6e:	00998963          	beq	s3,s1,80000d80 <vmprintchild+0xb0>
            if(j==0)
    80000d72:	f8e5                	bnez	s1,80000d62 <vmprintchild+0x92>
              printf("..");
    80000d74:	855e                	mv	a0,s7
    80000d76:	00005097          	auipc	ra,0x5
    80000d7a:	0a8080e7          	jalr	168(ra) # 80005e1e <printf>
    80000d7e:	b7fd                	j	80000d6c <vmprintchild+0x9c>
        uint64 pa = PTE2PA(pte);
    80000d80:	00a95693          	srli	a3,s2,0xa
        printf("%d: pte %p pa %p\n",i,pte,pa);
    80000d84:	06b2                	slli	a3,a3,0xc
    80000d86:	864a                	mv	a2,s2
    80000d88:	85d2                	mv	a1,s4
    80000d8a:	856a                	mv	a0,s10
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	092080e7          	jalr	146(ra) # 80005e1e <printf>
    for(int i=0;i<512;i++)
    80000d94:	2a05                	addiw	s4,s4,1
    80000d96:	0aa1                	addi	s5,s5,8
    80000d98:	018a0f63          	beq	s4,s8,80000db6 <vmprintchild+0xe6>
      pte_t pte = pagetable[i];
    80000d9c:	000ab903          	ld	s2,0(s5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
      if(pte & PTE_V && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000da0:	00f97793          	andi	a5,s2,15
    80000da4:	f7978ae3          	beq	a5,s9,80000d18 <vmprintchild+0x48>
      else if(pte & PTE_V)
    80000da8:	00197793          	andi	a5,s2,1
    80000dac:	d7e5                	beqz	a5,80000d94 <vmprintchild+0xc4>
        for(int j=0;j<depth;j++)
    80000dae:	fd3059e3          	blez	s3,80000d80 <vmprintchild+0xb0>
    80000db2:	4481                	li	s1,0
    80000db4:	bf7d                	j	80000d72 <vmprintchild+0xa2>
      }
    }
}
    80000db6:	70a6                	ld	ra,104(sp)
    80000db8:	7406                	ld	s0,96(sp)
    80000dba:	64e6                	ld	s1,88(sp)
    80000dbc:	6946                	ld	s2,80(sp)
    80000dbe:	69a6                	ld	s3,72(sp)
    80000dc0:	6a06                	ld	s4,64(sp)
    80000dc2:	7ae2                	ld	s5,56(sp)
    80000dc4:	7b42                	ld	s6,48(sp)
    80000dc6:	7ba2                	ld	s7,40(sp)
    80000dc8:	7c02                	ld	s8,32(sp)
    80000dca:	6ce2                	ld	s9,24(sp)
    80000dcc:	6d42                	ld	s10,16(sp)
    80000dce:	6da2                	ld	s11,8(sp)
    80000dd0:	6165                	addi	sp,sp,112
    80000dd2:	8082                	ret

0000000080000dd4 <vmprint>:

void vmprint(pagetable_t pagetable)
{
    80000dd4:	1101                	addi	sp,sp,-32
    80000dd6:	ec06                	sd	ra,24(sp)
    80000dd8:	e822                	sd	s0,16(sp)
    80000dda:	e426                	sd	s1,8(sp)
    80000ddc:	1000                	addi	s0,sp,32
    80000dde:	84aa                	mv	s1,a0
    printf("page table %p\n",pagetable);
    80000de0:	85aa                	mv	a1,a0
    80000de2:	00007517          	auipc	a0,0x7
    80000de6:	39e50513          	addi	a0,a0,926 # 80008180 <etext+0x180>
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	034080e7          	jalr	52(ra) # 80005e1e <printf>
    vmprintchild(pagetable,1);
    80000df2:	4585                	li	a1,1
    80000df4:	8526                	mv	a0,s1
    80000df6:	00000097          	auipc	ra,0x0
    80000dfa:	eda080e7          	jalr	-294(ra) # 80000cd0 <vmprintchild>
}
    80000dfe:	60e2                	ld	ra,24(sp)
    80000e00:	6442                	ld	s0,16(sp)
    80000e02:	64a2                	ld	s1,8(sp)
    80000e04:	6105                	addi	sp,sp,32
    80000e06:	8082                	ret

0000000080000e08 <access_check>:

uint64 access_check(pagetable_t pagetable,int pgcount,uint64 va)
{
    80000e08:	715d                	addi	sp,sp,-80
    80000e0a:	e486                	sd	ra,72(sp)
    80000e0c:	e0a2                	sd	s0,64(sp)
    80000e0e:	fc26                	sd	s1,56(sp)
    80000e10:	f84a                	sd	s2,48(sp)
    80000e12:	f44e                	sd	s3,40(sp)
    80000e14:	f052                	sd	s4,32(sp)
    80000e16:	ec56                	sd	s5,24(sp)
    80000e18:	e85a                	sd	s6,16(sp)
    80000e1a:	e45e                	sd	s7,8(sp)
    80000e1c:	e062                	sd	s8,0(sp)
    80000e1e:	0880                	addi	s0,sp,80
    uint64 bitmask = 0;
    for(int i=0;i<pgcount;i++,va+=PGSIZE)
    80000e20:	04b05463          	blez	a1,80000e68 <access_check+0x60>
    80000e24:	8a2a                	mv	s4,a0
    80000e26:	89ae                	mv	s3,a1
    80000e28:	8932                	mv	s2,a2
    80000e2a:	4481                	li	s1,0
    uint64 bitmask = 0;
    80000e2c:	4b81                	li	s7,0
    {
        pagetable_t pgt = pagetable;
        pte_t* pte = walk(pgt,va,0);
        if (*pte & PTE_V && *pte & PTE_A)
    80000e2e:	04100b13          	li	s6,65
		    {
		    	bitmask |= (1L << i);
    80000e32:	4c05                	li	s8,1
    for(int i=0;i<pgcount;i++,va+=PGSIZE)
    80000e34:	6a85                	lui	s5,0x1
    80000e36:	a029                	j	80000e40 <access_check+0x38>
    80000e38:	2485                	addiw	s1,s1,1
    80000e3a:	9956                	add	s2,s2,s5
    80000e3c:	02998763          	beq	s3,s1,80000e6a <access_check+0x62>
        pte_t* pte = walk(pgt,va,0);
    80000e40:	4601                	li	a2,0
    80000e42:	85ca                	mv	a1,s2
    80000e44:	8552                	mv	a0,s4
    80000e46:	fffff097          	auipc	ra,0xfffff
    80000e4a:	612080e7          	jalr	1554(ra) # 80000458 <walk>
        if (*pte & PTE_V && *pte & PTE_A)
    80000e4e:	611c                	ld	a5,0(a0)
    80000e50:	0417f713          	andi	a4,a5,65
    80000e54:	ff6712e3          	bne	a4,s6,80000e38 <access_check+0x30>
		    	bitmask |= (1L << i);
    80000e58:	009c1733          	sll	a4,s8,s1
    80000e5c:	00ebebb3          	or	s7,s7,a4
		    	*pte &= ~(PTE_A);
    80000e60:	fbf7f793          	andi	a5,a5,-65
    80000e64:	e11c                	sd	a5,0(a0)
    80000e66:	bfc9                	j	80000e38 <access_check+0x30>
    uint64 bitmask = 0;
    80000e68:	4b81                	li	s7,0
		    }
    }
    return bitmask;
    80000e6a:	855e                	mv	a0,s7
    80000e6c:	60a6                	ld	ra,72(sp)
    80000e6e:	6406                	ld	s0,64(sp)
    80000e70:	74e2                	ld	s1,56(sp)
    80000e72:	7942                	ld	s2,48(sp)
    80000e74:	79a2                	ld	s3,40(sp)
    80000e76:	7a02                	ld	s4,32(sp)
    80000e78:	6ae2                	ld	s5,24(sp)
    80000e7a:	6b42                	ld	s6,16(sp)
    80000e7c:	6ba2                	ld	s7,8(sp)
    80000e7e:	6c02                	ld	s8,0(sp)
    80000e80:	6161                	addi	sp,sp,80
    80000e82:	8082                	ret

0000000080000e84 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e84:	7139                	addi	sp,sp,-64
    80000e86:	fc06                	sd	ra,56(sp)
    80000e88:	f822                	sd	s0,48(sp)
    80000e8a:	f426                	sd	s1,40(sp)
    80000e8c:	f04a                	sd	s2,32(sp)
    80000e8e:	ec4e                	sd	s3,24(sp)
    80000e90:	e852                	sd	s4,16(sp)
    80000e92:	e456                	sd	s5,8(sp)
    80000e94:	e05a                	sd	s6,0(sp)
    80000e96:	0080                	addi	s0,sp,64
    80000e98:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9a:	00008497          	auipc	s1,0x8
    80000e9e:	5e648493          	addi	s1,s1,1510 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ea2:	8b26                	mv	s6,s1
    80000ea4:	00007a97          	auipc	s5,0x7
    80000ea8:	15ca8a93          	addi	s5,s5,348 # 80008000 <etext>
    80000eac:	01000937          	lui	s2,0x1000
    80000eb0:	197d                	addi	s2,s2,-1
    80000eb2:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb4:	0000ea17          	auipc	s4,0xe
    80000eb8:	3cca0a13          	addi	s4,s4,972 # 8000f280 <tickslock>
    char *pa = kalloc();
    80000ebc:	fffff097          	auipc	ra,0xfffff
    80000ec0:	25c080e7          	jalr	604(ra) # 80000118 <kalloc>
    80000ec4:	862a                	mv	a2,a0
    if(pa == 0)
    80000ec6:	c129                	beqz	a0,80000f08 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000ec8:	416485b3          	sub	a1,s1,s6
    80000ecc:	858d                	srai	a1,a1,0x3
    80000ece:	000ab783          	ld	a5,0(s5)
    80000ed2:	02f585b3          	mul	a1,a1,a5
    80000ed6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eda:	4719                	li	a4,6
    80000edc:	6685                	lui	a3,0x1
    80000ede:	40b905b3          	sub	a1,s2,a1
    80000ee2:	854e                	mv	a0,s3
    80000ee4:	fffff097          	auipc	ra,0xfffff
    80000ee8:	6fc080e7          	jalr	1788(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eec:	17848493          	addi	s1,s1,376
    80000ef0:	fd4496e3          	bne	s1,s4,80000ebc <proc_mapstacks+0x38>
  }
}
    80000ef4:	70e2                	ld	ra,56(sp)
    80000ef6:	7442                	ld	s0,48(sp)
    80000ef8:	74a2                	ld	s1,40(sp)
    80000efa:	7902                	ld	s2,32(sp)
    80000efc:	69e2                	ld	s3,24(sp)
    80000efe:	6a42                	ld	s4,16(sp)
    80000f00:	6aa2                	ld	s5,8(sp)
    80000f02:	6b02                	ld	s6,0(sp)
    80000f04:	6121                	addi	sp,sp,64
    80000f06:	8082                	ret
      panic("kalloc");
    80000f08:	00007517          	auipc	a0,0x7
    80000f0c:	28850513          	addi	a0,a0,648 # 80008190 <etext+0x190>
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	ec4080e7          	jalr	-316(ra) # 80005dd4 <panic>

0000000080000f18 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f18:	7139                	addi	sp,sp,-64
    80000f1a:	fc06                	sd	ra,56(sp)
    80000f1c:	f822                	sd	s0,48(sp)
    80000f1e:	f426                	sd	s1,40(sp)
    80000f20:	f04a                	sd	s2,32(sp)
    80000f22:	ec4e                	sd	s3,24(sp)
    80000f24:	e852                	sd	s4,16(sp)
    80000f26:	e456                	sd	s5,8(sp)
    80000f28:	e05a                	sd	s6,0(sp)
    80000f2a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f2c:	00007597          	auipc	a1,0x7
    80000f30:	26c58593          	addi	a1,a1,620 # 80008198 <etext+0x198>
    80000f34:	00008517          	auipc	a0,0x8
    80000f38:	11c50513          	addi	a0,a0,284 # 80009050 <pid_lock>
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	344080e7          	jalr	836(ra) # 80006280 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f44:	00007597          	auipc	a1,0x7
    80000f48:	25c58593          	addi	a1,a1,604 # 800081a0 <etext+0x1a0>
    80000f4c:	00008517          	auipc	a0,0x8
    80000f50:	11c50513          	addi	a0,a0,284 # 80009068 <wait_lock>
    80000f54:	00005097          	auipc	ra,0x5
    80000f58:	32c080e7          	jalr	812(ra) # 80006280 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5c:	00008497          	auipc	s1,0x8
    80000f60:	52448493          	addi	s1,s1,1316 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000f64:	00007b17          	auipc	s6,0x7
    80000f68:	24cb0b13          	addi	s6,s6,588 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000f6c:	8aa6                	mv	s5,s1
    80000f6e:	00007a17          	auipc	s4,0x7
    80000f72:	092a0a13          	addi	s4,s4,146 # 80008000 <etext>
    80000f76:	01000937          	lui	s2,0x1000
    80000f7a:	197d                	addi	s2,s2,-1
    80000f7c:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7e:	0000e997          	auipc	s3,0xe
    80000f82:	30298993          	addi	s3,s3,770 # 8000f280 <tickslock>
      initlock(&p->lock, "proc");
    80000f86:	85da                	mv	a1,s6
    80000f88:	8526                	mv	a0,s1
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	2f6080e7          	jalr	758(ra) # 80006280 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f92:	415487b3          	sub	a5,s1,s5
    80000f96:	878d                	srai	a5,a5,0x3
    80000f98:	000a3703          	ld	a4,0(s4)
    80000f9c:	02e787b3          	mul	a5,a5,a4
    80000fa0:	00d7979b          	slliw	a5,a5,0xd
    80000fa4:	40f907b3          	sub	a5,s2,a5
    80000fa8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000faa:	17848493          	addi	s1,s1,376
    80000fae:	fd349ce3          	bne	s1,s3,80000f86 <procinit+0x6e>
  }
}
    80000fb2:	70e2                	ld	ra,56(sp)
    80000fb4:	7442                	ld	s0,48(sp)
    80000fb6:	74a2                	ld	s1,40(sp)
    80000fb8:	7902                	ld	s2,32(sp)
    80000fba:	69e2                	ld	s3,24(sp)
    80000fbc:	6a42                	ld	s4,16(sp)
    80000fbe:	6aa2                	ld	s5,8(sp)
    80000fc0:	6b02                	ld	s6,0(sp)
    80000fc2:	6121                	addi	sp,sp,64
    80000fc4:	8082                	ret

0000000080000fc6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fcc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fce:	2501                	sext.w	a0,a0
    80000fd0:	6422                	ld	s0,8(sp)
    80000fd2:	0141                	addi	sp,sp,16
    80000fd4:	8082                	ret

0000000080000fd6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fd6:	1141                	addi	sp,sp,-16
    80000fd8:	e422                	sd	s0,8(sp)
    80000fda:	0800                	addi	s0,sp,16
    80000fdc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fde:	2781                	sext.w	a5,a5
    80000fe0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fe2:	00008517          	auipc	a0,0x8
    80000fe6:	09e50513          	addi	a0,a0,158 # 80009080 <cpus>
    80000fea:	953e                	add	a0,a0,a5
    80000fec:	6422                	ld	s0,8(sp)
    80000fee:	0141                	addi	sp,sp,16
    80000ff0:	8082                	ret

0000000080000ff2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	1000                	addi	s0,sp,32
  push_off();
    80000ffc:	00005097          	auipc	ra,0x5
    80001000:	2c8080e7          	jalr	712(ra) # 800062c4 <push_off>
    80001004:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001006:	2781                	sext.w	a5,a5
    80001008:	079e                	slli	a5,a5,0x7
    8000100a:	00008717          	auipc	a4,0x8
    8000100e:	04670713          	addi	a4,a4,70 # 80009050 <pid_lock>
    80001012:	97ba                	add	a5,a5,a4
    80001014:	7b84                	ld	s1,48(a5)
  pop_off();
    80001016:	00005097          	auipc	ra,0x5
    8000101a:	34e080e7          	jalr	846(ra) # 80006364 <pop_off>
  return p;
}
    8000101e:	8526                	mv	a0,s1
    80001020:	60e2                	ld	ra,24(sp)
    80001022:	6442                	ld	s0,16(sp)
    80001024:	64a2                	ld	s1,8(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret

000000008000102a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000102a:	1141                	addi	sp,sp,-16
    8000102c:	e406                	sd	ra,8(sp)
    8000102e:	e022                	sd	s0,0(sp)
    80001030:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001032:	00000097          	auipc	ra,0x0
    80001036:	fc0080e7          	jalr	-64(ra) # 80000ff2 <myproc>
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	38a080e7          	jalr	906(ra) # 800063c4 <release>

  if (first) {
    80001042:	00008797          	auipc	a5,0x8
    80001046:	84e7a783          	lw	a5,-1970(a5) # 80008890 <first.1>
    8000104a:	eb89                	bnez	a5,8000105c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000104c:	00001097          	auipc	ra,0x1
    80001050:	cc4080e7          	jalr	-828(ra) # 80001d10 <usertrapret>
}
    80001054:	60a2                	ld	ra,8(sp)
    80001056:	6402                	ld	s0,0(sp)
    80001058:	0141                	addi	sp,sp,16
    8000105a:	8082                	ret
    first = 0;
    8000105c:	00008797          	auipc	a5,0x8
    80001060:	8207aa23          	sw	zero,-1996(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80001064:	4505                	li	a0,1
    80001066:	00002097          	auipc	ra,0x2
    8000106a:	a78080e7          	jalr	-1416(ra) # 80002ade <fsinit>
    8000106e:	bff9                	j	8000104c <forkret+0x22>

0000000080001070 <allocpid>:
allocpid() {
    80001070:	1101                	addi	sp,sp,-32
    80001072:	ec06                	sd	ra,24(sp)
    80001074:	e822                	sd	s0,16(sp)
    80001076:	e426                	sd	s1,8(sp)
    80001078:	e04a                	sd	s2,0(sp)
    8000107a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000107c:	00008917          	auipc	s2,0x8
    80001080:	fd490913          	addi	s2,s2,-44 # 80009050 <pid_lock>
    80001084:	854a                	mv	a0,s2
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	28a080e7          	jalr	650(ra) # 80006310 <acquire>
  pid = nextpid;
    8000108e:	00008797          	auipc	a5,0x8
    80001092:	80678793          	addi	a5,a5,-2042 # 80008894 <nextpid>
    80001096:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001098:	0014871b          	addiw	a4,s1,1
    8000109c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000109e:	854a                	mv	a0,s2
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	324080e7          	jalr	804(ra) # 800063c4 <release>
}
    800010a8:	8526                	mv	a0,s1
    800010aa:	60e2                	ld	ra,24(sp)
    800010ac:	6442                	ld	s0,16(sp)
    800010ae:	64a2                	ld	s1,8(sp)
    800010b0:	6902                	ld	s2,0(sp)
    800010b2:	6105                	addi	sp,sp,32
    800010b4:	8082                	ret

00000000800010b6 <proc_pagetable>:
{
    800010b6:	1101                	addi	sp,sp,-32
    800010b8:	ec06                	sd	ra,24(sp)
    800010ba:	e822                	sd	s0,16(sp)
    800010bc:	e426                	sd	s1,8(sp)
    800010be:	e04a                	sd	s2,0(sp)
    800010c0:	1000                	addi	s0,sp,32
    800010c2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	706080e7          	jalr	1798(ra) # 800007ca <uvmcreate>
    800010cc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010ce:	cd39                	beqz	a0,8000112c <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010d0:	4729                	li	a4,10
    800010d2:	00006697          	auipc	a3,0x6
    800010d6:	f2e68693          	addi	a3,a3,-210 # 80007000 <_trampoline>
    800010da:	6605                	lui	a2,0x1
    800010dc:	040005b7          	lui	a1,0x4000
    800010e0:	15fd                	addi	a1,a1,-1
    800010e2:	05b2                	slli	a1,a1,0xc
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	45c080e7          	jalr	1116(ra) # 80000540 <mappages>
    800010ec:	04054763          	bltz	a0,8000113a <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010f0:	4719                	li	a4,6
    800010f2:	05893683          	ld	a3,88(s2)
    800010f6:	6605                	lui	a2,0x1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	43e080e7          	jalr	1086(ra) # 80000540 <mappages>
    8000110a:	04054063          	bltz	a0,8000114a <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    8000110e:	4749                	li	a4,18
    80001110:	17093683          	ld	a3,368(s2)
    80001114:	6605                	lui	a2,0x1
    80001116:	040005b7          	lui	a1,0x4000
    8000111a:	15f5                	addi	a1,a1,-3
    8000111c:	05b2                	slli	a1,a1,0xc
    8000111e:	8526                	mv	a0,s1
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	420080e7          	jalr	1056(ra) # 80000540 <mappages>
    80001128:	04054463          	bltz	a0,80001170 <proc_pagetable+0xba>
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    uvmfree(pagetable, 0);
    8000113a:	4581                	li	a1,0
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	888080e7          	jalr	-1912(ra) # 800009c6 <uvmfree>
    return 0;
    80001146:	4481                	li	s1,0
    80001148:	b7d5                	j	8000112c <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000114a:	4681                	li	a3,0
    8000114c:	4605                	li	a2,1
    8000114e:	040005b7          	lui	a1,0x4000
    80001152:	15fd                	addi	a1,a1,-1
    80001154:	05b2                	slli	a1,a1,0xc
    80001156:	8526                	mv	a0,s1
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	5ae080e7          	jalr	1454(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    80001160:	4581                	li	a1,0
    80001162:	8526                	mv	a0,s1
    80001164:	00000097          	auipc	ra,0x0
    80001168:	862080e7          	jalr	-1950(ra) # 800009c6 <uvmfree>
    return 0;
    8000116c:	4481                	li	s1,0
    8000116e:	bf7d                	j	8000112c <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001170:	4681                	li	a3,0
    80001172:	4605                	li	a2,1
    80001174:	040005b7          	lui	a1,0x4000
    80001178:	15fd                	addi	a1,a1,-1
    8000117a:	05b2                	slli	a1,a1,0xc
    8000117c:	8526                	mv	a0,s1
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	588080e7          	jalr	1416(ra) # 80000706 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001186:	4681                	li	a3,0
    80001188:	4605                	li	a2,1
    8000118a:	020005b7          	lui	a1,0x2000
    8000118e:	15fd                	addi	a1,a1,-1
    80001190:	05b6                	slli	a1,a1,0xd
    80001192:	8526                	mv	a0,s1
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	572080e7          	jalr	1394(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    8000119c:	4581                	li	a1,0
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	826080e7          	jalr	-2010(ra) # 800009c6 <uvmfree>
    return 0;
    800011a8:	4481                	li	s1,0
    800011aa:	b749                	j	8000112c <proc_pagetable+0x76>

00000000800011ac <proc_freepagetable>:
{
    800011ac:	7179                	addi	sp,sp,-48
    800011ae:	f406                	sd	ra,40(sp)
    800011b0:	f022                	sd	s0,32(sp)
    800011b2:	ec26                	sd	s1,24(sp)
    800011b4:	e84a                	sd	s2,16(sp)
    800011b6:	e44e                	sd	s3,8(sp)
    800011b8:	1800                	addi	s0,sp,48
    800011ba:	84aa                	mv	s1,a0
    800011bc:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011be:	4681                	li	a3,0
    800011c0:	4605                	li	a2,1
    800011c2:	04000937          	lui	s2,0x4000
    800011c6:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800011ca:	05b2                	slli	a1,a1,0xc
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	53a080e7          	jalr	1338(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011d4:	4681                	li	a3,0
    800011d6:	4605                	li	a2,1
    800011d8:	020005b7          	lui	a1,0x2000
    800011dc:	15fd                	addi	a1,a1,-1
    800011de:	05b6                	slli	a1,a1,0xd
    800011e0:	8526                	mv	a0,s1
    800011e2:	fffff097          	auipc	ra,0xfffff
    800011e6:	524080e7          	jalr	1316(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011ea:	4681                	li	a3,0
    800011ec:	4605                	li	a2,1
    800011ee:	1975                	addi	s2,s2,-3
    800011f0:	00c91593          	slli	a1,s2,0xc
    800011f4:	8526                	mv	a0,s1
    800011f6:	fffff097          	auipc	ra,0xfffff
    800011fa:	510080e7          	jalr	1296(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    800011fe:	85ce                	mv	a1,s3
    80001200:	8526                	mv	a0,s1
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	7c4080e7          	jalr	1988(ra) # 800009c6 <uvmfree>
}
    8000120a:	70a2                	ld	ra,40(sp)
    8000120c:	7402                	ld	s0,32(sp)
    8000120e:	64e2                	ld	s1,24(sp)
    80001210:	6942                	ld	s2,16(sp)
    80001212:	69a2                	ld	s3,8(sp)
    80001214:	6145                	addi	sp,sp,48
    80001216:	8082                	ret

0000000080001218 <freeproc>:
{
    80001218:	1101                	addi	sp,sp,-32
    8000121a:	ec06                	sd	ra,24(sp)
    8000121c:	e822                	sd	s0,16(sp)
    8000121e:	e426                	sd	s1,8(sp)
    80001220:	1000                	addi	s0,sp,32
    80001222:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001224:	6d28                	ld	a0,88(a0)
    80001226:	c509                	beqz	a0,80001230 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	df4080e7          	jalr	-524(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001230:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001234:	68a8                	ld	a0,80(s1)
    80001236:	c511                	beqz	a0,80001242 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001238:	64ac                	ld	a1,72(s1)
    8000123a:	00000097          	auipc	ra,0x0
    8000123e:	f72080e7          	jalr	-142(ra) # 800011ac <proc_freepagetable>
  if(p->ucall)
    80001242:	1704b503          	ld	a0,368(s1)
    80001246:	c509                	beqz	a0,80001250 <freeproc+0x38>
    kfree((void*)p->ucall);
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	dd4080e7          	jalr	-556(ra) # 8000001c <kfree>
  p->ucall = 0;
    80001250:	1604b823          	sd	zero,368(s1)
  p->pagetable = 0;
    80001254:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001258:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000125c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001260:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001264:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001268:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000126c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001270:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001274:	0004ac23          	sw	zero,24(s1)
}
    80001278:	60e2                	ld	ra,24(sp)
    8000127a:	6442                	ld	s0,16(sp)
    8000127c:	64a2                	ld	s1,8(sp)
    8000127e:	6105                	addi	sp,sp,32
    80001280:	8082                	ret

0000000080001282 <allocproc>:
{
    80001282:	1101                	addi	sp,sp,-32
    80001284:	ec06                	sd	ra,24(sp)
    80001286:	e822                	sd	s0,16(sp)
    80001288:	e426                	sd	s1,8(sp)
    8000128a:	e04a                	sd	s2,0(sp)
    8000128c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000128e:	00008497          	auipc	s1,0x8
    80001292:	1f248493          	addi	s1,s1,498 # 80009480 <proc>
    80001296:	0000e917          	auipc	s2,0xe
    8000129a:	fea90913          	addi	s2,s2,-22 # 8000f280 <tickslock>
    acquire(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	070080e7          	jalr	112(ra) # 80006310 <acquire>
    if(p->state == UNUSED) {
    800012a8:	4c9c                	lw	a5,24(s1)
    800012aa:	cf81                	beqz	a5,800012c2 <allocproc+0x40>
      release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	116080e7          	jalr	278(ra) # 800063c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012b6:	17848493          	addi	s1,s1,376
    800012ba:	ff2492e3          	bne	s1,s2,8000129e <allocproc+0x1c>
  return 0;
    800012be:	4481                	li	s1,0
    800012c0:	a0ad                	j	8000132a <allocproc+0xa8>
  p->pid = allocpid();
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	dae080e7          	jalr	-594(ra) # 80001070 <allocpid>
    800012ca:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012cc:	4785                	li	a5,1
    800012ce:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	e48080e7          	jalr	-440(ra) # 80000118 <kalloc>
    800012d8:	892a                	mv	s2,a0
    800012da:	eca8                	sd	a0,88(s1)
    800012dc:	cd31                	beqz	a0,80001338 <allocproc+0xb6>
  if((p->ucall = (struct usyscall*)kalloc())==0)
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	e3a080e7          	jalr	-454(ra) # 80000118 <kalloc>
    800012e6:	892a                	mv	s2,a0
    800012e8:	16a4b823          	sd	a0,368(s1)
    800012ec:	c135                	beqz	a0,80001350 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    800012ee:	8526                	mv	a0,s1
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	dc6080e7          	jalr	-570(ra) # 800010b6 <proc_pagetable>
    800012f8:	892a                	mv	s2,a0
    800012fa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012fc:	c535                	beqz	a0,80001368 <allocproc+0xe6>
  memset(&p->context, 0, sizeof(p->context));
    800012fe:	07000613          	li	a2,112
    80001302:	4581                	li	a1,0
    80001304:	06048513          	addi	a0,s1,96
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	e70080e7          	jalr	-400(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001310:	00000797          	auipc	a5,0x0
    80001314:	d1a78793          	addi	a5,a5,-742 # 8000102a <forkret>
    80001318:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000131a:	60bc                	ld	a5,64(s1)
    8000131c:	6705                	lui	a4,0x1
    8000131e:	97ba                	add	a5,a5,a4
    80001320:	f4bc                	sd	a5,104(s1)
  p->ucall->pid = p->pid;
    80001322:	1704b783          	ld	a5,368(s1)
    80001326:	5898                	lw	a4,48(s1)
    80001328:	c398                	sw	a4,0(a5)
}
    8000132a:	8526                	mv	a0,s1
    8000132c:	60e2                	ld	ra,24(sp)
    8000132e:	6442                	ld	s0,16(sp)
    80001330:	64a2                	ld	s1,8(sp)
    80001332:	6902                	ld	s2,0(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret
    freeproc(p);
    80001338:	8526                	mv	a0,s1
    8000133a:	00000097          	auipc	ra,0x0
    8000133e:	ede080e7          	jalr	-290(ra) # 80001218 <freeproc>
    release(&p->lock);
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	080080e7          	jalr	128(ra) # 800063c4 <release>
    return 0;
    8000134c:	84ca                	mv	s1,s2
    8000134e:	bff1                	j	8000132a <allocproc+0xa8>
    freeproc(p);
    80001350:	8526                	mv	a0,s1
    80001352:	00000097          	auipc	ra,0x0
    80001356:	ec6080e7          	jalr	-314(ra) # 80001218 <freeproc>
    release(&p->lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	068080e7          	jalr	104(ra) # 800063c4 <release>
    return 0;
    80001364:	84ca                	mv	s1,s2
    80001366:	b7d1                	j	8000132a <allocproc+0xa8>
    freeproc(p);
    80001368:	8526                	mv	a0,s1
    8000136a:	00000097          	auipc	ra,0x0
    8000136e:	eae080e7          	jalr	-338(ra) # 80001218 <freeproc>
    release(&p->lock);
    80001372:	8526                	mv	a0,s1
    80001374:	00005097          	auipc	ra,0x5
    80001378:	050080e7          	jalr	80(ra) # 800063c4 <release>
    return 0;
    8000137c:	84ca                	mv	s1,s2
    8000137e:	b775                	j	8000132a <allocproc+0xa8>

0000000080001380 <userinit>:
{
    80001380:	1101                	addi	sp,sp,-32
    80001382:	ec06                	sd	ra,24(sp)
    80001384:	e822                	sd	s0,16(sp)
    80001386:	e426                	sd	s1,8(sp)
    80001388:	1000                	addi	s0,sp,32
  p = allocproc();
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	ef8080e7          	jalr	-264(ra) # 80001282 <allocproc>
    80001392:	84aa                	mv	s1,a0
  initproc = p;
    80001394:	00008797          	auipc	a5,0x8
    80001398:	c6a7be23          	sd	a0,-900(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000139c:	03400613          	li	a2,52
    800013a0:	00007597          	auipc	a1,0x7
    800013a4:	50058593          	addi	a1,a1,1280 # 800088a0 <initcode>
    800013a8:	6928                	ld	a0,80(a0)
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	44e080e7          	jalr	1102(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    800013b2:	6785                	lui	a5,0x1
    800013b4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013b6:	6cb8                	ld	a4,88(s1)
    800013b8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013bc:	6cb8                	ld	a4,88(s1)
    800013be:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013c0:	4641                	li	a2,16
    800013c2:	00007597          	auipc	a1,0x7
    800013c6:	df658593          	addi	a1,a1,-522 # 800081b8 <etext+0x1b8>
    800013ca:	15848513          	addi	a0,s1,344
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	ef4080e7          	jalr	-268(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800013d6:	00007517          	auipc	a0,0x7
    800013da:	df250513          	addi	a0,a0,-526 # 800081c8 <etext+0x1c8>
    800013de:	00002097          	auipc	ra,0x2
    800013e2:	12e080e7          	jalr	302(ra) # 8000350c <namei>
    800013e6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013ea:	478d                	li	a5,3
    800013ec:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013ee:	8526                	mv	a0,s1
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	fd4080e7          	jalr	-44(ra) # 800063c4 <release>
}
    800013f8:	60e2                	ld	ra,24(sp)
    800013fa:	6442                	ld	s0,16(sp)
    800013fc:	64a2                	ld	s1,8(sp)
    800013fe:	6105                	addi	sp,sp,32
    80001400:	8082                	ret

0000000080001402 <growproc>:
{
    80001402:	1101                	addi	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	e04a                	sd	s2,0(sp)
    8000140c:	1000                	addi	s0,sp,32
    8000140e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001410:	00000097          	auipc	ra,0x0
    80001414:	be2080e7          	jalr	-1054(ra) # 80000ff2 <myproc>
    80001418:	892a                	mv	s2,a0
  sz = p->sz;
    8000141a:	652c                	ld	a1,72(a0)
    8000141c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001420:	00904f63          	bgtz	s1,8000143e <growproc+0x3c>
  } else if(n < 0){
    80001424:	0204cc63          	bltz	s1,8000145c <growproc+0x5a>
  p->sz = sz;
    80001428:	1602                	slli	a2,a2,0x20
    8000142a:	9201                	srli	a2,a2,0x20
    8000142c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001430:	4501                	li	a0,0
}
    80001432:	60e2                	ld	ra,24(sp)
    80001434:	6442                	ld	s0,16(sp)
    80001436:	64a2                	ld	s1,8(sp)
    80001438:	6902                	ld	s2,0(sp)
    8000143a:	6105                	addi	sp,sp,32
    8000143c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000143e:	9e25                	addw	a2,a2,s1
    80001440:	1602                	slli	a2,a2,0x20
    80001442:	9201                	srli	a2,a2,0x20
    80001444:	1582                	slli	a1,a1,0x20
    80001446:	9181                	srli	a1,a1,0x20
    80001448:	6928                	ld	a0,80(a0)
    8000144a:	fffff097          	auipc	ra,0xfffff
    8000144e:	468080e7          	jalr	1128(ra) # 800008b2 <uvmalloc>
    80001452:	0005061b          	sext.w	a2,a0
    80001456:	fa69                	bnez	a2,80001428 <growproc+0x26>
      return -1;
    80001458:	557d                	li	a0,-1
    8000145a:	bfe1                	j	80001432 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000145c:	9e25                	addw	a2,a2,s1
    8000145e:	1602                	slli	a2,a2,0x20
    80001460:	9201                	srli	a2,a2,0x20
    80001462:	1582                	slli	a1,a1,0x20
    80001464:	9181                	srli	a1,a1,0x20
    80001466:	6928                	ld	a0,80(a0)
    80001468:	fffff097          	auipc	ra,0xfffff
    8000146c:	402080e7          	jalr	1026(ra) # 8000086a <uvmdealloc>
    80001470:	0005061b          	sext.w	a2,a0
    80001474:	bf55                	j	80001428 <growproc+0x26>

0000000080001476 <fork>:
{
    80001476:	7139                	addi	sp,sp,-64
    80001478:	fc06                	sd	ra,56(sp)
    8000147a:	f822                	sd	s0,48(sp)
    8000147c:	f426                	sd	s1,40(sp)
    8000147e:	f04a                	sd	s2,32(sp)
    80001480:	ec4e                	sd	s3,24(sp)
    80001482:	e852                	sd	s4,16(sp)
    80001484:	e456                	sd	s5,8(sp)
    80001486:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001488:	00000097          	auipc	ra,0x0
    8000148c:	b6a080e7          	jalr	-1174(ra) # 80000ff2 <myproc>
    80001490:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001492:	00000097          	auipc	ra,0x0
    80001496:	df0080e7          	jalr	-528(ra) # 80001282 <allocproc>
    8000149a:	10050c63          	beqz	a0,800015b2 <fork+0x13c>
    8000149e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800014a0:	048ab603          	ld	a2,72(s5)
    800014a4:	692c                	ld	a1,80(a0)
    800014a6:	050ab503          	ld	a0,80(s5)
    800014aa:	fffff097          	auipc	ra,0xfffff
    800014ae:	554080e7          	jalr	1364(ra) # 800009fe <uvmcopy>
    800014b2:	04054863          	bltz	a0,80001502 <fork+0x8c>
  np->sz = p->sz;
    800014b6:	048ab783          	ld	a5,72(s5)
    800014ba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014be:	058ab683          	ld	a3,88(s5)
    800014c2:	87b6                	mv	a5,a3
    800014c4:	058a3703          	ld	a4,88(s4)
    800014c8:	12068693          	addi	a3,a3,288
    800014cc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014d0:	6788                	ld	a0,8(a5)
    800014d2:	6b8c                	ld	a1,16(a5)
    800014d4:	6f90                	ld	a2,24(a5)
    800014d6:	01073023          	sd	a6,0(a4)
    800014da:	e708                	sd	a0,8(a4)
    800014dc:	eb0c                	sd	a1,16(a4)
    800014de:	ef10                	sd	a2,24(a4)
    800014e0:	02078793          	addi	a5,a5,32
    800014e4:	02070713          	addi	a4,a4,32
    800014e8:	fed792e3          	bne	a5,a3,800014cc <fork+0x56>
  np->trapframe->a0 = 0;
    800014ec:	058a3783          	ld	a5,88(s4)
    800014f0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014f4:	0d0a8493          	addi	s1,s5,208
    800014f8:	0d0a0913          	addi	s2,s4,208
    800014fc:	150a8993          	addi	s3,s5,336
    80001500:	a00d                	j	80001522 <fork+0xac>
    freeproc(np);
    80001502:	8552                	mv	a0,s4
    80001504:	00000097          	auipc	ra,0x0
    80001508:	d14080e7          	jalr	-748(ra) # 80001218 <freeproc>
    release(&np->lock);
    8000150c:	8552                	mv	a0,s4
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	eb6080e7          	jalr	-330(ra) # 800063c4 <release>
    return -1;
    80001516:	597d                	li	s2,-1
    80001518:	a059                	j	8000159e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000151a:	04a1                	addi	s1,s1,8
    8000151c:	0921                	addi	s2,s2,8
    8000151e:	01348b63          	beq	s1,s3,80001534 <fork+0xbe>
    if(p->ofile[i])
    80001522:	6088                	ld	a0,0(s1)
    80001524:	d97d                	beqz	a0,8000151a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001526:	00002097          	auipc	ra,0x2
    8000152a:	67c080e7          	jalr	1660(ra) # 80003ba2 <filedup>
    8000152e:	00a93023          	sd	a0,0(s2)
    80001532:	b7e5                	j	8000151a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001534:	150ab503          	ld	a0,336(s5)
    80001538:	00001097          	auipc	ra,0x1
    8000153c:	7e0080e7          	jalr	2016(ra) # 80002d18 <idup>
    80001540:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001544:	4641                	li	a2,16
    80001546:	158a8593          	addi	a1,s5,344
    8000154a:	158a0513          	addi	a0,s4,344
    8000154e:	fffff097          	auipc	ra,0xfffff
    80001552:	d74080e7          	jalr	-652(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001556:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000155a:	8552                	mv	a0,s4
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	e68080e7          	jalr	-408(ra) # 800063c4 <release>
  acquire(&wait_lock);
    80001564:	00008497          	auipc	s1,0x8
    80001568:	b0448493          	addi	s1,s1,-1276 # 80009068 <wait_lock>
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	da2080e7          	jalr	-606(ra) # 80006310 <acquire>
  np->parent = p;
    80001576:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000157a:	8526                	mv	a0,s1
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	e48080e7          	jalr	-440(ra) # 800063c4 <release>
  acquire(&np->lock);
    80001584:	8552                	mv	a0,s4
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	d8a080e7          	jalr	-630(ra) # 80006310 <acquire>
  np->state = RUNNABLE;
    8000158e:	478d                	li	a5,3
    80001590:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001594:	8552                	mv	a0,s4
    80001596:	00005097          	auipc	ra,0x5
    8000159a:	e2e080e7          	jalr	-466(ra) # 800063c4 <release>
}
    8000159e:	854a                	mv	a0,s2
    800015a0:	70e2                	ld	ra,56(sp)
    800015a2:	7442                	ld	s0,48(sp)
    800015a4:	74a2                	ld	s1,40(sp)
    800015a6:	7902                	ld	s2,32(sp)
    800015a8:	69e2                	ld	s3,24(sp)
    800015aa:	6a42                	ld	s4,16(sp)
    800015ac:	6aa2                	ld	s5,8(sp)
    800015ae:	6121                	addi	sp,sp,64
    800015b0:	8082                	ret
    return -1;
    800015b2:	597d                	li	s2,-1
    800015b4:	b7ed                	j	8000159e <fork+0x128>

00000000800015b6 <scheduler>:
{
    800015b6:	7139                	addi	sp,sp,-64
    800015b8:	fc06                	sd	ra,56(sp)
    800015ba:	f822                	sd	s0,48(sp)
    800015bc:	f426                	sd	s1,40(sp)
    800015be:	f04a                	sd	s2,32(sp)
    800015c0:	ec4e                	sd	s3,24(sp)
    800015c2:	e852                	sd	s4,16(sp)
    800015c4:	e456                	sd	s5,8(sp)
    800015c6:	e05a                	sd	s6,0(sp)
    800015c8:	0080                	addi	s0,sp,64
    800015ca:	8792                	mv	a5,tp
  int id = r_tp();
    800015cc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015ce:	00779a93          	slli	s5,a5,0x7
    800015d2:	00008717          	auipc	a4,0x8
    800015d6:	a7e70713          	addi	a4,a4,-1410 # 80009050 <pid_lock>
    800015da:	9756                	add	a4,a4,s5
    800015dc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015e0:	00008717          	auipc	a4,0x8
    800015e4:	aa870713          	addi	a4,a4,-1368 # 80009088 <cpus+0x8>
    800015e8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015ea:	498d                	li	s3,3
        p->state = RUNNING;
    800015ec:	4b11                	li	s6,4
        c->proc = p;
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	00008a17          	auipc	s4,0x8
    800015f4:	a60a0a13          	addi	s4,s4,-1440 # 80009050 <pid_lock>
    800015f8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015fa:	0000e917          	auipc	s2,0xe
    800015fe:	c8690913          	addi	s2,s2,-890 # 8000f280 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001602:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001606:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000160a:	10079073          	csrw	sstatus,a5
    8000160e:	00008497          	auipc	s1,0x8
    80001612:	e7248493          	addi	s1,s1,-398 # 80009480 <proc>
    80001616:	a811                	j	8000162a <scheduler+0x74>
      release(&p->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	daa080e7          	jalr	-598(ra) # 800063c4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001622:	17848493          	addi	s1,s1,376
    80001626:	fd248ee3          	beq	s1,s2,80001602 <scheduler+0x4c>
      acquire(&p->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	ce4080e7          	jalr	-796(ra) # 80006310 <acquire>
      if(p->state == RUNNABLE) {
    80001634:	4c9c                	lw	a5,24(s1)
    80001636:	ff3791e3          	bne	a5,s3,80001618 <scheduler+0x62>
        p->state = RUNNING;
    8000163a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000163e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001642:	06048593          	addi	a1,s1,96
    80001646:	8556                	mv	a0,s5
    80001648:	00000097          	auipc	ra,0x0
    8000164c:	61e080e7          	jalr	1566(ra) # 80001c66 <swtch>
        c->proc = 0;
    80001650:	020a3823          	sd	zero,48(s4)
    80001654:	b7d1                	j	80001618 <scheduler+0x62>

0000000080001656 <sched>:
{
    80001656:	7179                	addi	sp,sp,-48
    80001658:	f406                	sd	ra,40(sp)
    8000165a:	f022                	sd	s0,32(sp)
    8000165c:	ec26                	sd	s1,24(sp)
    8000165e:	e84a                	sd	s2,16(sp)
    80001660:	e44e                	sd	s3,8(sp)
    80001662:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001664:	00000097          	auipc	ra,0x0
    80001668:	98e080e7          	jalr	-1650(ra) # 80000ff2 <myproc>
    8000166c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	c28080e7          	jalr	-984(ra) # 80006296 <holding>
    80001676:	c93d                	beqz	a0,800016ec <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001678:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000167a:	2781                	sext.w	a5,a5
    8000167c:	079e                	slli	a5,a5,0x7
    8000167e:	00008717          	auipc	a4,0x8
    80001682:	9d270713          	addi	a4,a4,-1582 # 80009050 <pid_lock>
    80001686:	97ba                	add	a5,a5,a4
    80001688:	0a87a703          	lw	a4,168(a5)
    8000168c:	4785                	li	a5,1
    8000168e:	06f71763          	bne	a4,a5,800016fc <sched+0xa6>
  if(p->state == RUNNING)
    80001692:	4c98                	lw	a4,24(s1)
    80001694:	4791                	li	a5,4
    80001696:	06f70b63          	beq	a4,a5,8000170c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000169a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000169e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800016a0:	efb5                	bnez	a5,8000171c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016a2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016a4:	00008917          	auipc	s2,0x8
    800016a8:	9ac90913          	addi	s2,s2,-1620 # 80009050 <pid_lock>
    800016ac:	2781                	sext.w	a5,a5
    800016ae:	079e                	slli	a5,a5,0x7
    800016b0:	97ca                	add	a5,a5,s2
    800016b2:	0ac7a983          	lw	s3,172(a5)
    800016b6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016b8:	2781                	sext.w	a5,a5
    800016ba:	079e                	slli	a5,a5,0x7
    800016bc:	00008597          	auipc	a1,0x8
    800016c0:	9cc58593          	addi	a1,a1,-1588 # 80009088 <cpus+0x8>
    800016c4:	95be                	add	a1,a1,a5
    800016c6:	06048513          	addi	a0,s1,96
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	59c080e7          	jalr	1436(ra) # 80001c66 <swtch>
    800016d2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016d4:	2781                	sext.w	a5,a5
    800016d6:	079e                	slli	a5,a5,0x7
    800016d8:	97ca                	add	a5,a5,s2
    800016da:	0b37a623          	sw	s3,172(a5)
}
    800016de:	70a2                	ld	ra,40(sp)
    800016e0:	7402                	ld	s0,32(sp)
    800016e2:	64e2                	ld	s1,24(sp)
    800016e4:	6942                	ld	s2,16(sp)
    800016e6:	69a2                	ld	s3,8(sp)
    800016e8:	6145                	addi	sp,sp,48
    800016ea:	8082                	ret
    panic("sched p->lock");
    800016ec:	00007517          	auipc	a0,0x7
    800016f0:	ae450513          	addi	a0,a0,-1308 # 800081d0 <etext+0x1d0>
    800016f4:	00004097          	auipc	ra,0x4
    800016f8:	6e0080e7          	jalr	1760(ra) # 80005dd4 <panic>
    panic("sched locks");
    800016fc:	00007517          	auipc	a0,0x7
    80001700:	ae450513          	addi	a0,a0,-1308 # 800081e0 <etext+0x1e0>
    80001704:	00004097          	auipc	ra,0x4
    80001708:	6d0080e7          	jalr	1744(ra) # 80005dd4 <panic>
    panic("sched running");
    8000170c:	00007517          	auipc	a0,0x7
    80001710:	ae450513          	addi	a0,a0,-1308 # 800081f0 <etext+0x1f0>
    80001714:	00004097          	auipc	ra,0x4
    80001718:	6c0080e7          	jalr	1728(ra) # 80005dd4 <panic>
    panic("sched interruptible");
    8000171c:	00007517          	auipc	a0,0x7
    80001720:	ae450513          	addi	a0,a0,-1308 # 80008200 <etext+0x200>
    80001724:	00004097          	auipc	ra,0x4
    80001728:	6b0080e7          	jalr	1712(ra) # 80005dd4 <panic>

000000008000172c <yield>:
{
    8000172c:	1101                	addi	sp,sp,-32
    8000172e:	ec06                	sd	ra,24(sp)
    80001730:	e822                	sd	s0,16(sp)
    80001732:	e426                	sd	s1,8(sp)
    80001734:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	8bc080e7          	jalr	-1860(ra) # 80000ff2 <myproc>
    8000173e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001740:	00005097          	auipc	ra,0x5
    80001744:	bd0080e7          	jalr	-1072(ra) # 80006310 <acquire>
  p->state = RUNNABLE;
    80001748:	478d                	li	a5,3
    8000174a:	cc9c                	sw	a5,24(s1)
  sched();
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	f0a080e7          	jalr	-246(ra) # 80001656 <sched>
  release(&p->lock);
    80001754:	8526                	mv	a0,s1
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	c6e080e7          	jalr	-914(ra) # 800063c4 <release>
}
    8000175e:	60e2                	ld	ra,24(sp)
    80001760:	6442                	ld	s0,16(sp)
    80001762:	64a2                	ld	s1,8(sp)
    80001764:	6105                	addi	sp,sp,32
    80001766:	8082                	ret

0000000080001768 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001768:	7179                	addi	sp,sp,-48
    8000176a:	f406                	sd	ra,40(sp)
    8000176c:	f022                	sd	s0,32(sp)
    8000176e:	ec26                	sd	s1,24(sp)
    80001770:	e84a                	sd	s2,16(sp)
    80001772:	e44e                	sd	s3,8(sp)
    80001774:	1800                	addi	s0,sp,48
    80001776:	89aa                	mv	s3,a0
    80001778:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000177a:	00000097          	auipc	ra,0x0
    8000177e:	878080e7          	jalr	-1928(ra) # 80000ff2 <myproc>
    80001782:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001784:	00005097          	auipc	ra,0x5
    80001788:	b8c080e7          	jalr	-1140(ra) # 80006310 <acquire>
  release(lk);
    8000178c:	854a                	mv	a0,s2
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	c36080e7          	jalr	-970(ra) # 800063c4 <release>

  // Go to sleep.
  p->chan = chan;
    80001796:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000179a:	4789                	li	a5,2
    8000179c:	cc9c                	sw	a5,24(s1)

  sched();
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	eb8080e7          	jalr	-328(ra) # 80001656 <sched>

  // Tidy up.
  p->chan = 0;
    800017a6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	c18080e7          	jalr	-1000(ra) # 800063c4 <release>
  acquire(lk);
    800017b4:	854a                	mv	a0,s2
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	b5a080e7          	jalr	-1190(ra) # 80006310 <acquire>
}
    800017be:	70a2                	ld	ra,40(sp)
    800017c0:	7402                	ld	s0,32(sp)
    800017c2:	64e2                	ld	s1,24(sp)
    800017c4:	6942                	ld	s2,16(sp)
    800017c6:	69a2                	ld	s3,8(sp)
    800017c8:	6145                	addi	sp,sp,48
    800017ca:	8082                	ret

00000000800017cc <wait>:
{
    800017cc:	715d                	addi	sp,sp,-80
    800017ce:	e486                	sd	ra,72(sp)
    800017d0:	e0a2                	sd	s0,64(sp)
    800017d2:	fc26                	sd	s1,56(sp)
    800017d4:	f84a                	sd	s2,48(sp)
    800017d6:	f44e                	sd	s3,40(sp)
    800017d8:	f052                	sd	s4,32(sp)
    800017da:	ec56                	sd	s5,24(sp)
    800017dc:	e85a                	sd	s6,16(sp)
    800017de:	e45e                	sd	s7,8(sp)
    800017e0:	e062                	sd	s8,0(sp)
    800017e2:	0880                	addi	s0,sp,80
    800017e4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	80c080e7          	jalr	-2036(ra) # 80000ff2 <myproc>
    800017ee:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f0:	00008517          	auipc	a0,0x8
    800017f4:	87850513          	addi	a0,a0,-1928 # 80009068 <wait_lock>
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	b18080e7          	jalr	-1256(ra) # 80006310 <acquire>
    havekids = 0;
    80001800:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001802:	4a15                	li	s4,5
        havekids = 1;
    80001804:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001806:	0000e997          	auipc	s3,0xe
    8000180a:	a7a98993          	addi	s3,s3,-1414 # 8000f280 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000180e:	00008c17          	auipc	s8,0x8
    80001812:	85ac0c13          	addi	s8,s8,-1958 # 80009068 <wait_lock>
    havekids = 0;
    80001816:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001818:	00008497          	auipc	s1,0x8
    8000181c:	c6848493          	addi	s1,s1,-920 # 80009480 <proc>
    80001820:	a0bd                	j	8000188e <wait+0xc2>
          pid = np->pid;
    80001822:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001826:	000b0e63          	beqz	s6,80001842 <wait+0x76>
    8000182a:	4691                	li	a3,4
    8000182c:	02c48613          	addi	a2,s1,44
    80001830:	85da                	mv	a1,s6
    80001832:	05093503          	ld	a0,80(s2)
    80001836:	fffff097          	auipc	ra,0xfffff
    8000183a:	2cc080e7          	jalr	716(ra) # 80000b02 <copyout>
    8000183e:	02054563          	bltz	a0,80001868 <wait+0x9c>
          freeproc(np);
    80001842:	8526                	mv	a0,s1
    80001844:	00000097          	auipc	ra,0x0
    80001848:	9d4080e7          	jalr	-1580(ra) # 80001218 <freeproc>
          release(&np->lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	b76080e7          	jalr	-1162(ra) # 800063c4 <release>
          release(&wait_lock);
    80001856:	00008517          	auipc	a0,0x8
    8000185a:	81250513          	addi	a0,a0,-2030 # 80009068 <wait_lock>
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	b66080e7          	jalr	-1178(ra) # 800063c4 <release>
          return pid;
    80001866:	a09d                	j	800018cc <wait+0x100>
            release(&np->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	b5a080e7          	jalr	-1190(ra) # 800063c4 <release>
            release(&wait_lock);
    80001872:	00007517          	auipc	a0,0x7
    80001876:	7f650513          	addi	a0,a0,2038 # 80009068 <wait_lock>
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	b4a080e7          	jalr	-1206(ra) # 800063c4 <release>
            return -1;
    80001882:	59fd                	li	s3,-1
    80001884:	a0a1                	j	800018cc <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001886:	17848493          	addi	s1,s1,376
    8000188a:	03348463          	beq	s1,s3,800018b2 <wait+0xe6>
      if(np->parent == p){
    8000188e:	7c9c                	ld	a5,56(s1)
    80001890:	ff279be3          	bne	a5,s2,80001886 <wait+0xba>
        acquire(&np->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a7a080e7          	jalr	-1414(ra) # 80006310 <acquire>
        if(np->state == ZOMBIE){
    8000189e:	4c9c                	lw	a5,24(s1)
    800018a0:	f94781e3          	beq	a5,s4,80001822 <wait+0x56>
        release(&np->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	b1e080e7          	jalr	-1250(ra) # 800063c4 <release>
        havekids = 1;
    800018ae:	8756                	mv	a4,s5
    800018b0:	bfd9                	j	80001886 <wait+0xba>
    if(!havekids || p->killed){
    800018b2:	c701                	beqz	a4,800018ba <wait+0xee>
    800018b4:	02892783          	lw	a5,40(s2)
    800018b8:	c79d                	beqz	a5,800018e6 <wait+0x11a>
      release(&wait_lock);
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	7ae50513          	addi	a0,a0,1966 # 80009068 <wait_lock>
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	b02080e7          	jalr	-1278(ra) # 800063c4 <release>
      return -1;
    800018ca:	59fd                	li	s3,-1
}
    800018cc:	854e                	mv	a0,s3
    800018ce:	60a6                	ld	ra,72(sp)
    800018d0:	6406                	ld	s0,64(sp)
    800018d2:	74e2                	ld	s1,56(sp)
    800018d4:	7942                	ld	s2,48(sp)
    800018d6:	79a2                	ld	s3,40(sp)
    800018d8:	7a02                	ld	s4,32(sp)
    800018da:	6ae2                	ld	s5,24(sp)
    800018dc:	6b42                	ld	s6,16(sp)
    800018de:	6ba2                	ld	s7,8(sp)
    800018e0:	6c02                	ld	s8,0(sp)
    800018e2:	6161                	addi	sp,sp,80
    800018e4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018e6:	85e2                	mv	a1,s8
    800018e8:	854a                	mv	a0,s2
    800018ea:	00000097          	auipc	ra,0x0
    800018ee:	e7e080e7          	jalr	-386(ra) # 80001768 <sleep>
    havekids = 0;
    800018f2:	b715                	j	80001816 <wait+0x4a>

00000000800018f4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018f4:	7139                	addi	sp,sp,-64
    800018f6:	fc06                	sd	ra,56(sp)
    800018f8:	f822                	sd	s0,48(sp)
    800018fa:	f426                	sd	s1,40(sp)
    800018fc:	f04a                	sd	s2,32(sp)
    800018fe:	ec4e                	sd	s3,24(sp)
    80001900:	e852                	sd	s4,16(sp)
    80001902:	e456                	sd	s5,8(sp)
    80001904:	0080                	addi	s0,sp,64
    80001906:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001908:	00008497          	auipc	s1,0x8
    8000190c:	b7848493          	addi	s1,s1,-1160 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001910:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001912:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001914:	0000e917          	auipc	s2,0xe
    80001918:	96c90913          	addi	s2,s2,-1684 # 8000f280 <tickslock>
    8000191c:	a811                	j	80001930 <wakeup+0x3c>
      }
      release(&p->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	00005097          	auipc	ra,0x5
    80001924:	aa4080e7          	jalr	-1372(ra) # 800063c4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001928:	17848493          	addi	s1,s1,376
    8000192c:	03248663          	beq	s1,s2,80001958 <wakeup+0x64>
    if(p != myproc()){
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	6c2080e7          	jalr	1730(ra) # 80000ff2 <myproc>
    80001938:	fea488e3          	beq	s1,a0,80001928 <wakeup+0x34>
      acquire(&p->lock);
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	9d2080e7          	jalr	-1582(ra) # 80006310 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001946:	4c9c                	lw	a5,24(s1)
    80001948:	fd379be3          	bne	a5,s3,8000191e <wakeup+0x2a>
    8000194c:	709c                	ld	a5,32(s1)
    8000194e:	fd4798e3          	bne	a5,s4,8000191e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001952:	0154ac23          	sw	s5,24(s1)
    80001956:	b7e1                	j	8000191e <wakeup+0x2a>
    }
  }
}
    80001958:	70e2                	ld	ra,56(sp)
    8000195a:	7442                	ld	s0,48(sp)
    8000195c:	74a2                	ld	s1,40(sp)
    8000195e:	7902                	ld	s2,32(sp)
    80001960:	69e2                	ld	s3,24(sp)
    80001962:	6a42                	ld	s4,16(sp)
    80001964:	6aa2                	ld	s5,8(sp)
    80001966:	6121                	addi	sp,sp,64
    80001968:	8082                	ret

000000008000196a <reparent>:
{
    8000196a:	7179                	addi	sp,sp,-48
    8000196c:	f406                	sd	ra,40(sp)
    8000196e:	f022                	sd	s0,32(sp)
    80001970:	ec26                	sd	s1,24(sp)
    80001972:	e84a                	sd	s2,16(sp)
    80001974:	e44e                	sd	s3,8(sp)
    80001976:	e052                	sd	s4,0(sp)
    80001978:	1800                	addi	s0,sp,48
    8000197a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000197c:	00008497          	auipc	s1,0x8
    80001980:	b0448493          	addi	s1,s1,-1276 # 80009480 <proc>
      pp->parent = initproc;
    80001984:	00007a17          	auipc	s4,0x7
    80001988:	68ca0a13          	addi	s4,s4,1676 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000198c:	0000e997          	auipc	s3,0xe
    80001990:	8f498993          	addi	s3,s3,-1804 # 8000f280 <tickslock>
    80001994:	a029                	j	8000199e <reparent+0x34>
    80001996:	17848493          	addi	s1,s1,376
    8000199a:	01348d63          	beq	s1,s3,800019b4 <reparent+0x4a>
    if(pp->parent == p){
    8000199e:	7c9c                	ld	a5,56(s1)
    800019a0:	ff279be3          	bne	a5,s2,80001996 <reparent+0x2c>
      pp->parent = initproc;
    800019a4:	000a3503          	ld	a0,0(s4)
    800019a8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800019aa:	00000097          	auipc	ra,0x0
    800019ae:	f4a080e7          	jalr	-182(ra) # 800018f4 <wakeup>
    800019b2:	b7d5                	j	80001996 <reparent+0x2c>
}
    800019b4:	70a2                	ld	ra,40(sp)
    800019b6:	7402                	ld	s0,32(sp)
    800019b8:	64e2                	ld	s1,24(sp)
    800019ba:	6942                	ld	s2,16(sp)
    800019bc:	69a2                	ld	s3,8(sp)
    800019be:	6a02                	ld	s4,0(sp)
    800019c0:	6145                	addi	sp,sp,48
    800019c2:	8082                	ret

00000000800019c4 <exit>:
{
    800019c4:	7179                	addi	sp,sp,-48
    800019c6:	f406                	sd	ra,40(sp)
    800019c8:	f022                	sd	s0,32(sp)
    800019ca:	ec26                	sd	s1,24(sp)
    800019cc:	e84a                	sd	s2,16(sp)
    800019ce:	e44e                	sd	s3,8(sp)
    800019d0:	e052                	sd	s4,0(sp)
    800019d2:	1800                	addi	s0,sp,48
    800019d4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	61c080e7          	jalr	1564(ra) # 80000ff2 <myproc>
    800019de:	89aa                	mv	s3,a0
  if(p == initproc)
    800019e0:	00007797          	auipc	a5,0x7
    800019e4:	6307b783          	ld	a5,1584(a5) # 80009010 <initproc>
    800019e8:	0d050493          	addi	s1,a0,208
    800019ec:	15050913          	addi	s2,a0,336
    800019f0:	02a79363          	bne	a5,a0,80001a16 <exit+0x52>
    panic("init exiting");
    800019f4:	00007517          	auipc	a0,0x7
    800019f8:	82450513          	addi	a0,a0,-2012 # 80008218 <etext+0x218>
    800019fc:	00004097          	auipc	ra,0x4
    80001a00:	3d8080e7          	jalr	984(ra) # 80005dd4 <panic>
      fileclose(f);
    80001a04:	00002097          	auipc	ra,0x2
    80001a08:	1f0080e7          	jalr	496(ra) # 80003bf4 <fileclose>
      p->ofile[fd] = 0;
    80001a0c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a10:	04a1                	addi	s1,s1,8
    80001a12:	01248563          	beq	s1,s2,80001a1c <exit+0x58>
    if(p->ofile[fd]){
    80001a16:	6088                	ld	a0,0(s1)
    80001a18:	f575                	bnez	a0,80001a04 <exit+0x40>
    80001a1a:	bfdd                	j	80001a10 <exit+0x4c>
  begin_op();
    80001a1c:	00002097          	auipc	ra,0x2
    80001a20:	d0c080e7          	jalr	-756(ra) # 80003728 <begin_op>
  iput(p->cwd);
    80001a24:	1509b503          	ld	a0,336(s3)
    80001a28:	00001097          	auipc	ra,0x1
    80001a2c:	4e8080e7          	jalr	1256(ra) # 80002f10 <iput>
  end_op();
    80001a30:	00002097          	auipc	ra,0x2
    80001a34:	d78080e7          	jalr	-648(ra) # 800037a8 <end_op>
  p->cwd = 0;
    80001a38:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a3c:	00007497          	auipc	s1,0x7
    80001a40:	62c48493          	addi	s1,s1,1580 # 80009068 <wait_lock>
    80001a44:	8526                	mv	a0,s1
    80001a46:	00005097          	auipc	ra,0x5
    80001a4a:	8ca080e7          	jalr	-1846(ra) # 80006310 <acquire>
  reparent(p);
    80001a4e:	854e                	mv	a0,s3
    80001a50:	00000097          	auipc	ra,0x0
    80001a54:	f1a080e7          	jalr	-230(ra) # 8000196a <reparent>
  wakeup(p->parent);
    80001a58:	0389b503          	ld	a0,56(s3)
    80001a5c:	00000097          	auipc	ra,0x0
    80001a60:	e98080e7          	jalr	-360(ra) # 800018f4 <wakeup>
  acquire(&p->lock);
    80001a64:	854e                	mv	a0,s3
    80001a66:	00005097          	auipc	ra,0x5
    80001a6a:	8aa080e7          	jalr	-1878(ra) # 80006310 <acquire>
  p->xstate = status;
    80001a6e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a72:	4795                	li	a5,5
    80001a74:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	94a080e7          	jalr	-1718(ra) # 800063c4 <release>
  sched();
    80001a82:	00000097          	auipc	ra,0x0
    80001a86:	bd4080e7          	jalr	-1068(ra) # 80001656 <sched>
  panic("zombie exit");
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	79e50513          	addi	a0,a0,1950 # 80008228 <etext+0x228>
    80001a92:	00004097          	auipc	ra,0x4
    80001a96:	342080e7          	jalr	834(ra) # 80005dd4 <panic>

0000000080001a9a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a9a:	7179                	addi	sp,sp,-48
    80001a9c:	f406                	sd	ra,40(sp)
    80001a9e:	f022                	sd	s0,32(sp)
    80001aa0:	ec26                	sd	s1,24(sp)
    80001aa2:	e84a                	sd	s2,16(sp)
    80001aa4:	e44e                	sd	s3,8(sp)
    80001aa6:	1800                	addi	s0,sp,48
    80001aa8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	00008497          	auipc	s1,0x8
    80001aae:	9d648493          	addi	s1,s1,-1578 # 80009480 <proc>
    80001ab2:	0000d997          	auipc	s3,0xd
    80001ab6:	7ce98993          	addi	s3,s3,1998 # 8000f280 <tickslock>
    acquire(&p->lock);
    80001aba:	8526                	mv	a0,s1
    80001abc:	00005097          	auipc	ra,0x5
    80001ac0:	854080e7          	jalr	-1964(ra) # 80006310 <acquire>
    if(p->pid == pid){
    80001ac4:	589c                	lw	a5,48(s1)
    80001ac6:	01278d63          	beq	a5,s2,80001ae0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001aca:	8526                	mv	a0,s1
    80001acc:	00005097          	auipc	ra,0x5
    80001ad0:	8f8080e7          	jalr	-1800(ra) # 800063c4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad4:	17848493          	addi	s1,s1,376
    80001ad8:	ff3491e3          	bne	s1,s3,80001aba <kill+0x20>
  }
  return -1;
    80001adc:	557d                	li	a0,-1
    80001ade:	a829                	j	80001af8 <kill+0x5e>
      p->killed = 1;
    80001ae0:	4785                	li	a5,1
    80001ae2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ae4:	4c98                	lw	a4,24(s1)
    80001ae6:	4789                	li	a5,2
    80001ae8:	00f70f63          	beq	a4,a5,80001b06 <kill+0x6c>
      release(&p->lock);
    80001aec:	8526                	mv	a0,s1
    80001aee:	00005097          	auipc	ra,0x5
    80001af2:	8d6080e7          	jalr	-1834(ra) # 800063c4 <release>
      return 0;
    80001af6:	4501                	li	a0,0
}
    80001af8:	70a2                	ld	ra,40(sp)
    80001afa:	7402                	ld	s0,32(sp)
    80001afc:	64e2                	ld	s1,24(sp)
    80001afe:	6942                	ld	s2,16(sp)
    80001b00:	69a2                	ld	s3,8(sp)
    80001b02:	6145                	addi	sp,sp,48
    80001b04:	8082                	ret
        p->state = RUNNABLE;
    80001b06:	478d                	li	a5,3
    80001b08:	cc9c                	sw	a5,24(s1)
    80001b0a:	b7cd                	j	80001aec <kill+0x52>

0000000080001b0c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b0c:	7179                	addi	sp,sp,-48
    80001b0e:	f406                	sd	ra,40(sp)
    80001b10:	f022                	sd	s0,32(sp)
    80001b12:	ec26                	sd	s1,24(sp)
    80001b14:	e84a                	sd	s2,16(sp)
    80001b16:	e44e                	sd	s3,8(sp)
    80001b18:	e052                	sd	s4,0(sp)
    80001b1a:	1800                	addi	s0,sp,48
    80001b1c:	84aa                	mv	s1,a0
    80001b1e:	892e                	mv	s2,a1
    80001b20:	89b2                	mv	s3,a2
    80001b22:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	4ce080e7          	jalr	1230(ra) # 80000ff2 <myproc>
  if(user_dst){
    80001b2c:	c08d                	beqz	s1,80001b4e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b2e:	86d2                	mv	a3,s4
    80001b30:	864e                	mv	a2,s3
    80001b32:	85ca                	mv	a1,s2
    80001b34:	6928                	ld	a0,80(a0)
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	fcc080e7          	jalr	-52(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b3e:	70a2                	ld	ra,40(sp)
    80001b40:	7402                	ld	s0,32(sp)
    80001b42:	64e2                	ld	s1,24(sp)
    80001b44:	6942                	ld	s2,16(sp)
    80001b46:	69a2                	ld	s3,8(sp)
    80001b48:	6a02                	ld	s4,0(sp)
    80001b4a:	6145                	addi	sp,sp,48
    80001b4c:	8082                	ret
    memmove((char *)dst, src, len);
    80001b4e:	000a061b          	sext.w	a2,s4
    80001b52:	85ce                	mv	a1,s3
    80001b54:	854a                	mv	a0,s2
    80001b56:	ffffe097          	auipc	ra,0xffffe
    80001b5a:	67e080e7          	jalr	1662(ra) # 800001d4 <memmove>
    return 0;
    80001b5e:	8526                	mv	a0,s1
    80001b60:	bff9                	j	80001b3e <either_copyout+0x32>

0000000080001b62 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b62:	7179                	addi	sp,sp,-48
    80001b64:	f406                	sd	ra,40(sp)
    80001b66:	f022                	sd	s0,32(sp)
    80001b68:	ec26                	sd	s1,24(sp)
    80001b6a:	e84a                	sd	s2,16(sp)
    80001b6c:	e44e                	sd	s3,8(sp)
    80001b6e:	e052                	sd	s4,0(sp)
    80001b70:	1800                	addi	s0,sp,48
    80001b72:	892a                	mv	s2,a0
    80001b74:	84ae                	mv	s1,a1
    80001b76:	89b2                	mv	s3,a2
    80001b78:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	478080e7          	jalr	1144(ra) # 80000ff2 <myproc>
  if(user_src){
    80001b82:	c08d                	beqz	s1,80001ba4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b84:	86d2                	mv	a3,s4
    80001b86:	864e                	mv	a2,s3
    80001b88:	85ca                	mv	a1,s2
    80001b8a:	6928                	ld	a0,80(a0)
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	002080e7          	jalr	2(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b94:	70a2                	ld	ra,40(sp)
    80001b96:	7402                	ld	s0,32(sp)
    80001b98:	64e2                	ld	s1,24(sp)
    80001b9a:	6942                	ld	s2,16(sp)
    80001b9c:	69a2                	ld	s3,8(sp)
    80001b9e:	6a02                	ld	s4,0(sp)
    80001ba0:	6145                	addi	sp,sp,48
    80001ba2:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ba4:	000a061b          	sext.w	a2,s4
    80001ba8:	85ce                	mv	a1,s3
    80001baa:	854a                	mv	a0,s2
    80001bac:	ffffe097          	auipc	ra,0xffffe
    80001bb0:	628080e7          	jalr	1576(ra) # 800001d4 <memmove>
    return 0;
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	bff9                	j	80001b94 <either_copyin+0x32>

0000000080001bb8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bb8:	715d                	addi	sp,sp,-80
    80001bba:	e486                	sd	ra,72(sp)
    80001bbc:	e0a2                	sd	s0,64(sp)
    80001bbe:	fc26                	sd	s1,56(sp)
    80001bc0:	f84a                	sd	s2,48(sp)
    80001bc2:	f44e                	sd	s3,40(sp)
    80001bc4:	f052                	sd	s4,32(sp)
    80001bc6:	ec56                	sd	s5,24(sp)
    80001bc8:	e85a                	sd	s6,16(sp)
    80001bca:	e45e                	sd	s7,8(sp)
    80001bcc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bce:	00006517          	auipc	a0,0x6
    80001bd2:	47a50513          	addi	a0,a0,1146 # 80008048 <etext+0x48>
    80001bd6:	00004097          	auipc	ra,0x4
    80001bda:	248080e7          	jalr	584(ra) # 80005e1e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bde:	00008497          	auipc	s1,0x8
    80001be2:	9fa48493          	addi	s1,s1,-1542 # 800095d8 <proc+0x158>
    80001be6:	0000d917          	auipc	s2,0xd
    80001bea:	7f290913          	addi	s2,s2,2034 # 8000f3d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bee:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bf0:	00006997          	auipc	s3,0x6
    80001bf4:	64898993          	addi	s3,s3,1608 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001bf8:	00006a97          	auipc	s5,0x6
    80001bfc:	648a8a93          	addi	s5,s5,1608 # 80008240 <etext+0x240>
    printf("\n");
    80001c00:	00006a17          	auipc	s4,0x6
    80001c04:	448a0a13          	addi	s4,s4,1096 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c08:	00006b97          	auipc	s7,0x6
    80001c0c:	670b8b93          	addi	s7,s7,1648 # 80008278 <states.0>
    80001c10:	a00d                	j	80001c32 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c12:	ed86a583          	lw	a1,-296(a3)
    80001c16:	8556                	mv	a0,s5
    80001c18:	00004097          	auipc	ra,0x4
    80001c1c:	206080e7          	jalr	518(ra) # 80005e1e <printf>
    printf("\n");
    80001c20:	8552                	mv	a0,s4
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	1fc080e7          	jalr	508(ra) # 80005e1e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c2a:	17848493          	addi	s1,s1,376
    80001c2e:	03248163          	beq	s1,s2,80001c50 <procdump+0x98>
    if(p->state == UNUSED)
    80001c32:	86a6                	mv	a3,s1
    80001c34:	ec04a783          	lw	a5,-320(s1)
    80001c38:	dbed                	beqz	a5,80001c2a <procdump+0x72>
      state = "???";
    80001c3a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c3c:	fcfb6be3          	bltu	s6,a5,80001c12 <procdump+0x5a>
    80001c40:	1782                	slli	a5,a5,0x20
    80001c42:	9381                	srli	a5,a5,0x20
    80001c44:	078e                	slli	a5,a5,0x3
    80001c46:	97de                	add	a5,a5,s7
    80001c48:	6390                	ld	a2,0(a5)
    80001c4a:	f661                	bnez	a2,80001c12 <procdump+0x5a>
      state = "???";
    80001c4c:	864e                	mv	a2,s3
    80001c4e:	b7d1                	j	80001c12 <procdump+0x5a>
  }
}
    80001c50:	60a6                	ld	ra,72(sp)
    80001c52:	6406                	ld	s0,64(sp)
    80001c54:	74e2                	ld	s1,56(sp)
    80001c56:	7942                	ld	s2,48(sp)
    80001c58:	79a2                	ld	s3,40(sp)
    80001c5a:	7a02                	ld	s4,32(sp)
    80001c5c:	6ae2                	ld	s5,24(sp)
    80001c5e:	6b42                	ld	s6,16(sp)
    80001c60:	6ba2                	ld	s7,8(sp)
    80001c62:	6161                	addi	sp,sp,80
    80001c64:	8082                	ret

0000000080001c66 <swtch>:
    80001c66:	00153023          	sd	ra,0(a0)
    80001c6a:	00253423          	sd	sp,8(a0)
    80001c6e:	e900                	sd	s0,16(a0)
    80001c70:	ed04                	sd	s1,24(a0)
    80001c72:	03253023          	sd	s2,32(a0)
    80001c76:	03353423          	sd	s3,40(a0)
    80001c7a:	03453823          	sd	s4,48(a0)
    80001c7e:	03553c23          	sd	s5,56(a0)
    80001c82:	05653023          	sd	s6,64(a0)
    80001c86:	05753423          	sd	s7,72(a0)
    80001c8a:	05853823          	sd	s8,80(a0)
    80001c8e:	05953c23          	sd	s9,88(a0)
    80001c92:	07a53023          	sd	s10,96(a0)
    80001c96:	07b53423          	sd	s11,104(a0)
    80001c9a:	0005b083          	ld	ra,0(a1)
    80001c9e:	0085b103          	ld	sp,8(a1)
    80001ca2:	6980                	ld	s0,16(a1)
    80001ca4:	6d84                	ld	s1,24(a1)
    80001ca6:	0205b903          	ld	s2,32(a1)
    80001caa:	0285b983          	ld	s3,40(a1)
    80001cae:	0305ba03          	ld	s4,48(a1)
    80001cb2:	0385ba83          	ld	s5,56(a1)
    80001cb6:	0405bb03          	ld	s6,64(a1)
    80001cba:	0485bb83          	ld	s7,72(a1)
    80001cbe:	0505bc03          	ld	s8,80(a1)
    80001cc2:	0585bc83          	ld	s9,88(a1)
    80001cc6:	0605bd03          	ld	s10,96(a1)
    80001cca:	0685bd83          	ld	s11,104(a1)
    80001cce:	8082                	ret

0000000080001cd0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cd0:	1141                	addi	sp,sp,-16
    80001cd2:	e406                	sd	ra,8(sp)
    80001cd4:	e022                	sd	s0,0(sp)
    80001cd6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cd8:	00006597          	auipc	a1,0x6
    80001cdc:	5d058593          	addi	a1,a1,1488 # 800082a8 <states.0+0x30>
    80001ce0:	0000d517          	auipc	a0,0xd
    80001ce4:	5a050513          	addi	a0,a0,1440 # 8000f280 <tickslock>
    80001ce8:	00004097          	auipc	ra,0x4
    80001cec:	598080e7          	jalr	1432(ra) # 80006280 <initlock>
}
    80001cf0:	60a2                	ld	ra,8(sp)
    80001cf2:	6402                	ld	s0,0(sp)
    80001cf4:	0141                	addi	sp,sp,16
    80001cf6:	8082                	ret

0000000080001cf8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cf8:	1141                	addi	sp,sp,-16
    80001cfa:	e422                	sd	s0,8(sp)
    80001cfc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cfe:	00003797          	auipc	a5,0x3
    80001d02:	53278793          	addi	a5,a5,1330 # 80005230 <kernelvec>
    80001d06:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d0a:	6422                	ld	s0,8(sp)
    80001d0c:	0141                	addi	sp,sp,16
    80001d0e:	8082                	ret

0000000080001d10 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d10:	1141                	addi	sp,sp,-16
    80001d12:	e406                	sd	ra,8(sp)
    80001d14:	e022                	sd	s0,0(sp)
    80001d16:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	2da080e7          	jalr	730(ra) # 80000ff2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d24:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d2a:	00005617          	auipc	a2,0x5
    80001d2e:	2d660613          	addi	a2,a2,726 # 80007000 <_trampoline>
    80001d32:	00005697          	auipc	a3,0x5
    80001d36:	2ce68693          	addi	a3,a3,718 # 80007000 <_trampoline>
    80001d3a:	8e91                	sub	a3,a3,a2
    80001d3c:	040007b7          	lui	a5,0x4000
    80001d40:	17fd                	addi	a5,a5,-1
    80001d42:	07b2                	slli	a5,a5,0xc
    80001d44:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d46:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d4c:	180026f3          	csrr	a3,satp
    80001d50:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d52:	6d38                	ld	a4,88(a0)
    80001d54:	6134                	ld	a3,64(a0)
    80001d56:	6585                	lui	a1,0x1
    80001d58:	96ae                	add	a3,a3,a1
    80001d5a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d5c:	6d38                	ld	a4,88(a0)
    80001d5e:	00000697          	auipc	a3,0x0
    80001d62:	13868693          	addi	a3,a3,312 # 80001e96 <usertrap>
    80001d66:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d68:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d6a:	8692                	mv	a3,tp
    80001d6c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d72:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d76:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d80:	6f18                	ld	a4,24(a4)
    80001d82:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d86:	692c                	ld	a1,80(a0)
    80001d88:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d8a:	00005717          	auipc	a4,0x5
    80001d8e:	30670713          	addi	a4,a4,774 # 80007090 <userret>
    80001d92:	8f11                	sub	a4,a4,a2
    80001d94:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d96:	577d                	li	a4,-1
    80001d98:	177e                	slli	a4,a4,0x3f
    80001d9a:	8dd9                	or	a1,a1,a4
    80001d9c:	02000537          	lui	a0,0x2000
    80001da0:	157d                	addi	a0,a0,-1
    80001da2:	0536                	slli	a0,a0,0xd
    80001da4:	9782                	jalr	a5
}
    80001da6:	60a2                	ld	ra,8(sp)
    80001da8:	6402                	ld	s0,0(sp)
    80001daa:	0141                	addi	sp,sp,16
    80001dac:	8082                	ret

0000000080001dae <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dae:	1101                	addi	sp,sp,-32
    80001db0:	ec06                	sd	ra,24(sp)
    80001db2:	e822                	sd	s0,16(sp)
    80001db4:	e426                	sd	s1,8(sp)
    80001db6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001db8:	0000d497          	auipc	s1,0xd
    80001dbc:	4c848493          	addi	s1,s1,1224 # 8000f280 <tickslock>
    80001dc0:	8526                	mv	a0,s1
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	54e080e7          	jalr	1358(ra) # 80006310 <acquire>
  ticks++;
    80001dca:	00007517          	auipc	a0,0x7
    80001dce:	24e50513          	addi	a0,a0,590 # 80009018 <ticks>
    80001dd2:	411c                	lw	a5,0(a0)
    80001dd4:	2785                	addiw	a5,a5,1
    80001dd6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	b1c080e7          	jalr	-1252(ra) # 800018f4 <wakeup>
  release(&tickslock);
    80001de0:	8526                	mv	a0,s1
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	5e2080e7          	jalr	1506(ra) # 800063c4 <release>
}
    80001dea:	60e2                	ld	ra,24(sp)
    80001dec:	6442                	ld	s0,16(sp)
    80001dee:	64a2                	ld	s1,8(sp)
    80001df0:	6105                	addi	sp,sp,32
    80001df2:	8082                	ret

0000000080001df4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfe:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e02:	00074d63          	bltz	a4,80001e1c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e06:	57fd                	li	a5,-1
    80001e08:	17fe                	slli	a5,a5,0x3f
    80001e0a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e0c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e0e:	06f70363          	beq	a4,a5,80001e74 <devintr+0x80>
  }
}
    80001e12:	60e2                	ld	ra,24(sp)
    80001e14:	6442                	ld	s0,16(sp)
    80001e16:	64a2                	ld	s1,8(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret
     (scause & 0xff) == 9){
    80001e1c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e20:	46a5                	li	a3,9
    80001e22:	fed792e3          	bne	a5,a3,80001e06 <devintr+0x12>
    int irq = plic_claim();
    80001e26:	00003097          	auipc	ra,0x3
    80001e2a:	512080e7          	jalr	1298(ra) # 80005338 <plic_claim>
    80001e2e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e30:	47a9                	li	a5,10
    80001e32:	02f50763          	beq	a0,a5,80001e60 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e36:	4785                	li	a5,1
    80001e38:	02f50963          	beq	a0,a5,80001e6a <devintr+0x76>
    return 1;
    80001e3c:	4505                	li	a0,1
    } else if(irq){
    80001e3e:	d8f1                	beqz	s1,80001e12 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e40:	85a6                	mv	a1,s1
    80001e42:	00006517          	auipc	a0,0x6
    80001e46:	46e50513          	addi	a0,a0,1134 # 800082b0 <states.0+0x38>
    80001e4a:	00004097          	auipc	ra,0x4
    80001e4e:	fd4080e7          	jalr	-44(ra) # 80005e1e <printf>
      plic_complete(irq);
    80001e52:	8526                	mv	a0,s1
    80001e54:	00003097          	auipc	ra,0x3
    80001e58:	508080e7          	jalr	1288(ra) # 8000535c <plic_complete>
    return 1;
    80001e5c:	4505                	li	a0,1
    80001e5e:	bf55                	j	80001e12 <devintr+0x1e>
      uartintr();
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	3d0080e7          	jalr	976(ra) # 80006230 <uartintr>
    80001e68:	b7ed                	j	80001e52 <devintr+0x5e>
      virtio_disk_intr();
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	984080e7          	jalr	-1660(ra) # 800057ee <virtio_disk_intr>
    80001e72:	b7c5                	j	80001e52 <devintr+0x5e>
    if(cpuid() == 0){
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	152080e7          	jalr	338(ra) # 80000fc6 <cpuid>
    80001e7c:	c901                	beqz	a0,80001e8c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e7e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e84:	14479073          	csrw	sip,a5
    return 2;
    80001e88:	4509                	li	a0,2
    80001e8a:	b761                	j	80001e12 <devintr+0x1e>
      clockintr();
    80001e8c:	00000097          	auipc	ra,0x0
    80001e90:	f22080e7          	jalr	-222(ra) # 80001dae <clockintr>
    80001e94:	b7ed                	j	80001e7e <devintr+0x8a>

0000000080001e96 <usertrap>:
{
    80001e96:	1101                	addi	sp,sp,-32
    80001e98:	ec06                	sd	ra,24(sp)
    80001e9a:	e822                	sd	s0,16(sp)
    80001e9c:	e426                	sd	s1,8(sp)
    80001e9e:	e04a                	sd	s2,0(sp)
    80001ea0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ea6:	1007f793          	andi	a5,a5,256
    80001eaa:	e3ad                	bnez	a5,80001f0c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001eac:	00003797          	auipc	a5,0x3
    80001eb0:	38478793          	addi	a5,a5,900 # 80005230 <kernelvec>
    80001eb4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	13a080e7          	jalr	314(ra) # 80000ff2 <myproc>
    80001ec0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ec2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec4:	14102773          	csrr	a4,sepc
    80001ec8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eca:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ece:	47a1                	li	a5,8
    80001ed0:	04f71c63          	bne	a4,a5,80001f28 <usertrap+0x92>
    if(p->killed)
    80001ed4:	551c                	lw	a5,40(a0)
    80001ed6:	e3b9                	bnez	a5,80001f1c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001ed8:	6cb8                	ld	a4,88(s1)
    80001eda:	6f1c                	ld	a5,24(a4)
    80001edc:	0791                	addi	a5,a5,4
    80001ede:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ee4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ee8:	10079073          	csrw	sstatus,a5
    syscall();
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	2e0080e7          	jalr	736(ra) # 800021cc <syscall>
  if(p->killed)
    80001ef4:	549c                	lw	a5,40(s1)
    80001ef6:	ebc1                	bnez	a5,80001f86 <usertrap+0xf0>
  usertrapret();
    80001ef8:	00000097          	auipc	ra,0x0
    80001efc:	e18080e7          	jalr	-488(ra) # 80001d10 <usertrapret>
}
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	64a2                	ld	s1,8(sp)
    80001f06:	6902                	ld	s2,0(sp)
    80001f08:	6105                	addi	sp,sp,32
    80001f0a:	8082                	ret
    panic("usertrap: not from user mode");
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	3c450513          	addi	a0,a0,964 # 800082d0 <states.0+0x58>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	ec0080e7          	jalr	-320(ra) # 80005dd4 <panic>
      exit(-1);
    80001f1c:	557d                	li	a0,-1
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	aa6080e7          	jalr	-1370(ra) # 800019c4 <exit>
    80001f26:	bf4d                	j	80001ed8 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	ecc080e7          	jalr	-308(ra) # 80001df4 <devintr>
    80001f30:	892a                	mv	s2,a0
    80001f32:	c501                	beqz	a0,80001f3a <usertrap+0xa4>
  if(p->killed)
    80001f34:	549c                	lw	a5,40(s1)
    80001f36:	c3a1                	beqz	a5,80001f76 <usertrap+0xe0>
    80001f38:	a815                	j	80001f6c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f3e:	5890                	lw	a2,48(s1)
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	3b050513          	addi	a0,a0,944 # 800082f0 <states.0+0x78>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	ed6080e7          	jalr	-298(ra) # 80005e1e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f50:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f54:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f58:	00006517          	auipc	a0,0x6
    80001f5c:	3c850513          	addi	a0,a0,968 # 80008320 <states.0+0xa8>
    80001f60:	00004097          	auipc	ra,0x4
    80001f64:	ebe080e7          	jalr	-322(ra) # 80005e1e <printf>
    p->killed = 1;
    80001f68:	4785                	li	a5,1
    80001f6a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f6c:	557d                	li	a0,-1
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	a56080e7          	jalr	-1450(ra) # 800019c4 <exit>
  if(which_dev == 2)
    80001f76:	4789                	li	a5,2
    80001f78:	f8f910e3          	bne	s2,a5,80001ef8 <usertrap+0x62>
    yield();
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	7b0080e7          	jalr	1968(ra) # 8000172c <yield>
    80001f84:	bf95                	j	80001ef8 <usertrap+0x62>
  int which_dev = 0;
    80001f86:	4901                	li	s2,0
    80001f88:	b7d5                	j	80001f6c <usertrap+0xd6>

0000000080001f8a <kerneltrap>:
{
    80001f8a:	7179                	addi	sp,sp,-48
    80001f8c:	f406                	sd	ra,40(sp)
    80001f8e:	f022                	sd	s0,32(sp)
    80001f90:	ec26                	sd	s1,24(sp)
    80001f92:	e84a                	sd	s2,16(sp)
    80001f94:	e44e                	sd	s3,8(sp)
    80001f96:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f98:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f9c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fa0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fa4:	1004f793          	andi	a5,s1,256
    80001fa8:	cb85                	beqz	a5,80001fd8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001faa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fb0:	ef85                	bnez	a5,80001fe8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	e42080e7          	jalr	-446(ra) # 80001df4 <devintr>
    80001fba:	cd1d                	beqz	a0,80001ff8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fbc:	4789                	li	a5,2
    80001fbe:	06f50a63          	beq	a0,a5,80002032 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fc2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fc6:	10049073          	csrw	sstatus,s1
}
    80001fca:	70a2                	ld	ra,40(sp)
    80001fcc:	7402                	ld	s0,32(sp)
    80001fce:	64e2                	ld	s1,24(sp)
    80001fd0:	6942                	ld	s2,16(sp)
    80001fd2:	69a2                	ld	s3,8(sp)
    80001fd4:	6145                	addi	sp,sp,48
    80001fd6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	36850513          	addi	a0,a0,872 # 80008340 <states.0+0xc8>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	df4080e7          	jalr	-524(ra) # 80005dd4 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	38050513          	addi	a0,a0,896 # 80008368 <states.0+0xf0>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	de4080e7          	jalr	-540(ra) # 80005dd4 <panic>
    printf("scause %p\n", scause);
    80001ff8:	85ce                	mv	a1,s3
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	38e50513          	addi	a0,a0,910 # 80008388 <states.0+0x110>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	e1c080e7          	jalr	-484(ra) # 80005e1e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000200a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000200e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002012:	00006517          	auipc	a0,0x6
    80002016:	38650513          	addi	a0,a0,902 # 80008398 <states.0+0x120>
    8000201a:	00004097          	auipc	ra,0x4
    8000201e:	e04080e7          	jalr	-508(ra) # 80005e1e <printf>
    panic("kerneltrap");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	38e50513          	addi	a0,a0,910 # 800083b0 <states.0+0x138>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	daa080e7          	jalr	-598(ra) # 80005dd4 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	fc0080e7          	jalr	-64(ra) # 80000ff2 <myproc>
    8000203a:	d541                	beqz	a0,80001fc2 <kerneltrap+0x38>
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	fb6080e7          	jalr	-74(ra) # 80000ff2 <myproc>
    80002044:	4d18                	lw	a4,24(a0)
    80002046:	4791                	li	a5,4
    80002048:	f6f71de3          	bne	a4,a5,80001fc2 <kerneltrap+0x38>
    yield();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	6e0080e7          	jalr	1760(ra) # 8000172c <yield>
    80002054:	b7bd                	j	80001fc2 <kerneltrap+0x38>

0000000080002056 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002056:	1101                	addi	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	e426                	sd	s1,8(sp)
    8000205e:	1000                	addi	s0,sp,32
    80002060:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	f90080e7          	jalr	-112(ra) # 80000ff2 <myproc>
  switch (n) {
    8000206a:	4795                	li	a5,5
    8000206c:	0497e163          	bltu	a5,s1,800020ae <argraw+0x58>
    80002070:	048a                	slli	s1,s1,0x2
    80002072:	00006717          	auipc	a4,0x6
    80002076:	37670713          	addi	a4,a4,886 # 800083e8 <states.0+0x170>
    8000207a:	94ba                	add	s1,s1,a4
    8000207c:	409c                	lw	a5,0(s1)
    8000207e:	97ba                	add	a5,a5,a4
    80002080:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002082:	6d3c                	ld	a5,88(a0)
    80002084:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	64a2                	ld	s1,8(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret
    return p->trapframe->a1;
    80002090:	6d3c                	ld	a5,88(a0)
    80002092:	7fa8                	ld	a0,120(a5)
    80002094:	bfcd                	j	80002086 <argraw+0x30>
    return p->trapframe->a2;
    80002096:	6d3c                	ld	a5,88(a0)
    80002098:	63c8                	ld	a0,128(a5)
    8000209a:	b7f5                	j	80002086 <argraw+0x30>
    return p->trapframe->a3;
    8000209c:	6d3c                	ld	a5,88(a0)
    8000209e:	67c8                	ld	a0,136(a5)
    800020a0:	b7dd                	j	80002086 <argraw+0x30>
    return p->trapframe->a4;
    800020a2:	6d3c                	ld	a5,88(a0)
    800020a4:	6bc8                	ld	a0,144(a5)
    800020a6:	b7c5                	j	80002086 <argraw+0x30>
    return p->trapframe->a5;
    800020a8:	6d3c                	ld	a5,88(a0)
    800020aa:	6fc8                	ld	a0,152(a5)
    800020ac:	bfe9                	j	80002086 <argraw+0x30>
  panic("argraw");
    800020ae:	00006517          	auipc	a0,0x6
    800020b2:	31250513          	addi	a0,a0,786 # 800083c0 <states.0+0x148>
    800020b6:	00004097          	auipc	ra,0x4
    800020ba:	d1e080e7          	jalr	-738(ra) # 80005dd4 <panic>

00000000800020be <fetchaddr>:
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	e04a                	sd	s2,0(sp)
    800020c8:	1000                	addi	s0,sp,32
    800020ca:	84aa                	mv	s1,a0
    800020cc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	f24080e7          	jalr	-220(ra) # 80000ff2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020d6:	653c                	ld	a5,72(a0)
    800020d8:	02f4f863          	bgeu	s1,a5,80002108 <fetchaddr+0x4a>
    800020dc:	00848713          	addi	a4,s1,8
    800020e0:	02e7e663          	bltu	a5,a4,8000210c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020e4:	46a1                	li	a3,8
    800020e6:	8626                	mv	a2,s1
    800020e8:	85ca                	mv	a1,s2
    800020ea:	6928                	ld	a0,80(a0)
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	aa2080e7          	jalr	-1374(ra) # 80000b8e <copyin>
    800020f4:	00a03533          	snez	a0,a0
    800020f8:	40a00533          	neg	a0,a0
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6902                	ld	s2,0(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret
    return -1;
    80002108:	557d                	li	a0,-1
    8000210a:	bfcd                	j	800020fc <fetchaddr+0x3e>
    8000210c:	557d                	li	a0,-1
    8000210e:	b7fd                	j	800020fc <fetchaddr+0x3e>

0000000080002110 <fetchstr>:
{
    80002110:	7179                	addi	sp,sp,-48
    80002112:	f406                	sd	ra,40(sp)
    80002114:	f022                	sd	s0,32(sp)
    80002116:	ec26                	sd	s1,24(sp)
    80002118:	e84a                	sd	s2,16(sp)
    8000211a:	e44e                	sd	s3,8(sp)
    8000211c:	1800                	addi	s0,sp,48
    8000211e:	892a                	mv	s2,a0
    80002120:	84ae                	mv	s1,a1
    80002122:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	ece080e7          	jalr	-306(ra) # 80000ff2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000212c:	86ce                	mv	a3,s3
    8000212e:	864a                	mv	a2,s2
    80002130:	85a6                	mv	a1,s1
    80002132:	6928                	ld	a0,80(a0)
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	ae8080e7          	jalr	-1304(ra) # 80000c1c <copyinstr>
  if(err < 0)
    8000213c:	00054763          	bltz	a0,8000214a <fetchstr+0x3a>
  return strlen(buf);
    80002140:	8526                	mv	a0,s1
    80002142:	ffffe097          	auipc	ra,0xffffe
    80002146:	1b2080e7          	jalr	434(ra) # 800002f4 <strlen>
}
    8000214a:	70a2                	ld	ra,40(sp)
    8000214c:	7402                	ld	s0,32(sp)
    8000214e:	64e2                	ld	s1,24(sp)
    80002150:	6942                	ld	s2,16(sp)
    80002152:	69a2                	ld	s3,8(sp)
    80002154:	6145                	addi	sp,sp,48
    80002156:	8082                	ret

0000000080002158 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	e426                	sd	s1,8(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002164:	00000097          	auipc	ra,0x0
    80002168:	ef2080e7          	jalr	-270(ra) # 80002056 <argraw>
    8000216c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000216e:	4501                	li	a0,0
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000217a:	1101                	addi	sp,sp,-32
    8000217c:	ec06                	sd	ra,24(sp)
    8000217e:	e822                	sd	s0,16(sp)
    80002180:	e426                	sd	s1,8(sp)
    80002182:	1000                	addi	s0,sp,32
    80002184:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	ed0080e7          	jalr	-304(ra) # 80002056 <argraw>
    8000218e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002190:	4501                	li	a0,0
    80002192:	60e2                	ld	ra,24(sp)
    80002194:	6442                	ld	s0,16(sp)
    80002196:	64a2                	ld	s1,8(sp)
    80002198:	6105                	addi	sp,sp,32
    8000219a:	8082                	ret

000000008000219c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000219c:	1101                	addi	sp,sp,-32
    8000219e:	ec06                	sd	ra,24(sp)
    800021a0:	e822                	sd	s0,16(sp)
    800021a2:	e426                	sd	s1,8(sp)
    800021a4:	e04a                	sd	s2,0(sp)
    800021a6:	1000                	addi	s0,sp,32
    800021a8:	84ae                	mv	s1,a1
    800021aa:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	eaa080e7          	jalr	-342(ra) # 80002056 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021b4:	864a                	mv	a2,s2
    800021b6:	85a6                	mv	a1,s1
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	f58080e7          	jalr	-168(ra) # 80002110 <fetchstr>
}
    800021c0:	60e2                	ld	ra,24(sp)
    800021c2:	6442                	ld	s0,16(sp)
    800021c4:	64a2                	ld	s1,8(sp)
    800021c6:	6902                	ld	s2,0(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret

00000000800021cc <syscall>:



void
syscall(void)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	e04a                	sd	s2,0(sp)
    800021d6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	e1a080e7          	jalr	-486(ra) # 80000ff2 <myproc>
    800021e0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021e2:	05853903          	ld	s2,88(a0)
    800021e6:	0a893783          	ld	a5,168(s2)
    800021ea:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021ee:	37fd                	addiw	a5,a5,-1
    800021f0:	4775                	li	a4,29
    800021f2:	00f76f63          	bltu	a4,a5,80002210 <syscall+0x44>
    800021f6:	00369713          	slli	a4,a3,0x3
    800021fa:	00006797          	auipc	a5,0x6
    800021fe:	20678793          	addi	a5,a5,518 # 80008400 <syscalls>
    80002202:	97ba                	add	a5,a5,a4
    80002204:	639c                	ld	a5,0(a5)
    80002206:	c789                	beqz	a5,80002210 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002208:	9782                	jalr	a5
    8000220a:	06a93823          	sd	a0,112(s2)
    8000220e:	a839                	j	8000222c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002210:	15848613          	addi	a2,s1,344
    80002214:	588c                	lw	a1,48(s1)
    80002216:	00006517          	auipc	a0,0x6
    8000221a:	1b250513          	addi	a0,a0,434 # 800083c8 <states.0+0x150>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	c00080e7          	jalr	-1024(ra) # 80005e1e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002226:	6cbc                	ld	a5,88(s1)
    80002228:	577d                	li	a4,-1
    8000222a:	fbb8                	sd	a4,112(a5)
  }
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6902                	ld	s2,0(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002238:	1101                	addi	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002240:	fec40593          	addi	a1,s0,-20
    80002244:	4501                	li	a0,0
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	f12080e7          	jalr	-238(ra) # 80002158 <argint>
    return -1;
    8000224e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002250:	00054963          	bltz	a0,80002262 <sys_exit+0x2a>
  exit(n);
    80002254:	fec42503          	lw	a0,-20(s0)
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	76c080e7          	jalr	1900(ra) # 800019c4 <exit>
  return 0;  // not reached
    80002260:	4781                	li	a5,0
}
    80002262:	853e                	mv	a0,a5
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	6105                	addi	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000226c:	1141                	addi	sp,sp,-16
    8000226e:	e406                	sd	ra,8(sp)
    80002270:	e022                	sd	s0,0(sp)
    80002272:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	d7e080e7          	jalr	-642(ra) # 80000ff2 <myproc>
}
    8000227c:	5908                	lw	a0,48(a0)
    8000227e:	60a2                	ld	ra,8(sp)
    80002280:	6402                	ld	s0,0(sp)
    80002282:	0141                	addi	sp,sp,16
    80002284:	8082                	ret

0000000080002286 <sys_fork>:

uint64
sys_fork(void)
{
    80002286:	1141                	addi	sp,sp,-16
    80002288:	e406                	sd	ra,8(sp)
    8000228a:	e022                	sd	s0,0(sp)
    8000228c:	0800                	addi	s0,sp,16
  return fork();
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	1e8080e7          	jalr	488(ra) # 80001476 <fork>
}
    80002296:	60a2                	ld	ra,8(sp)
    80002298:	6402                	ld	s0,0(sp)
    8000229a:	0141                	addi	sp,sp,16
    8000229c:	8082                	ret

000000008000229e <sys_wait>:

uint64
sys_wait(void)
{
    8000229e:	1101                	addi	sp,sp,-32
    800022a0:	ec06                	sd	ra,24(sp)
    800022a2:	e822                	sd	s0,16(sp)
    800022a4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022a6:	fe840593          	addi	a1,s0,-24
    800022aa:	4501                	li	a0,0
    800022ac:	00000097          	auipc	ra,0x0
    800022b0:	ece080e7          	jalr	-306(ra) # 8000217a <argaddr>
    800022b4:	87aa                	mv	a5,a0
    return -1;
    800022b6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022b8:	0007c863          	bltz	a5,800022c8 <sys_wait+0x2a>
  return wait(p);
    800022bc:	fe843503          	ld	a0,-24(s0)
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	50c080e7          	jalr	1292(ra) # 800017cc <wait>
}
    800022c8:	60e2                	ld	ra,24(sp)
    800022ca:	6442                	ld	s0,16(sp)
    800022cc:	6105                	addi	sp,sp,32
    800022ce:	8082                	ret

00000000800022d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022d0:	7179                	addi	sp,sp,-48
    800022d2:	f406                	sd	ra,40(sp)
    800022d4:	f022                	sd	s0,32(sp)
    800022d6:	ec26                	sd	s1,24(sp)
    800022d8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022da:	fdc40593          	addi	a1,s0,-36
    800022de:	4501                	li	a0,0
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	e78080e7          	jalr	-392(ra) # 80002158 <argint>
    return -1;
    800022e8:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800022ea:	00054f63          	bltz	a0,80002308 <sys_sbrk+0x38>
  
  addr = myproc()->sz;
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	d04080e7          	jalr	-764(ra) # 80000ff2 <myproc>
    800022f6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022f8:	fdc42503          	lw	a0,-36(s0)
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	106080e7          	jalr	262(ra) # 80001402 <growproc>
    80002304:	00054863          	bltz	a0,80002314 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002308:	8526                	mv	a0,s1
    8000230a:	70a2                	ld	ra,40(sp)
    8000230c:	7402                	ld	s0,32(sp)
    8000230e:	64e2                	ld	s1,24(sp)
    80002310:	6145                	addi	sp,sp,48
    80002312:	8082                	ret
    return -1;
    80002314:	54fd                	li	s1,-1
    80002316:	bfcd                	j	80002308 <sys_sbrk+0x38>

0000000080002318 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002318:	7139                	addi	sp,sp,-64
    8000231a:	fc06                	sd	ra,56(sp)
    8000231c:	f822                	sd	s0,48(sp)
    8000231e:	f426                	sd	s1,40(sp)
    80002320:	f04a                	sd	s2,32(sp)
    80002322:	ec4e                	sd	s3,24(sp)
    80002324:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002326:	fcc40593          	addi	a1,s0,-52
    8000232a:	4501                	li	a0,0
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	e2c080e7          	jalr	-468(ra) # 80002158 <argint>
    return -1;
    80002334:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002336:	06054563          	bltz	a0,800023a0 <sys_sleep+0x88>
  acquire(&tickslock);
    8000233a:	0000d517          	auipc	a0,0xd
    8000233e:	f4650513          	addi	a0,a0,-186 # 8000f280 <tickslock>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	fce080e7          	jalr	-50(ra) # 80006310 <acquire>
  ticks0 = ticks;
    8000234a:	00007917          	auipc	s2,0x7
    8000234e:	cce92903          	lw	s2,-818(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002352:	fcc42783          	lw	a5,-52(s0)
    80002356:	cf85                	beqz	a5,8000238e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002358:	0000d997          	auipc	s3,0xd
    8000235c:	f2898993          	addi	s3,s3,-216 # 8000f280 <tickslock>
    80002360:	00007497          	auipc	s1,0x7
    80002364:	cb848493          	addi	s1,s1,-840 # 80009018 <ticks>
    if(myproc()->killed){
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	c8a080e7          	jalr	-886(ra) # 80000ff2 <myproc>
    80002370:	551c                	lw	a5,40(a0)
    80002372:	ef9d                	bnez	a5,800023b0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002374:	85ce                	mv	a1,s3
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	3f0080e7          	jalr	1008(ra) # 80001768 <sleep>
  while(ticks - ticks0 < n){
    80002380:	409c                	lw	a5,0(s1)
    80002382:	412787bb          	subw	a5,a5,s2
    80002386:	fcc42703          	lw	a4,-52(s0)
    8000238a:	fce7efe3          	bltu	a5,a4,80002368 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000238e:	0000d517          	auipc	a0,0xd
    80002392:	ef250513          	addi	a0,a0,-270 # 8000f280 <tickslock>
    80002396:	00004097          	auipc	ra,0x4
    8000239a:	02e080e7          	jalr	46(ra) # 800063c4 <release>
  return 0;
    8000239e:	4781                	li	a5,0
}
    800023a0:	853e                	mv	a0,a5
    800023a2:	70e2                	ld	ra,56(sp)
    800023a4:	7442                	ld	s0,48(sp)
    800023a6:	74a2                	ld	s1,40(sp)
    800023a8:	7902                	ld	s2,32(sp)
    800023aa:	69e2                	ld	s3,24(sp)
    800023ac:	6121                	addi	sp,sp,64
    800023ae:	8082                	ret
      release(&tickslock);
    800023b0:	0000d517          	auipc	a0,0xd
    800023b4:	ed050513          	addi	a0,a0,-304 # 8000f280 <tickslock>
    800023b8:	00004097          	auipc	ra,0x4
    800023bc:	00c080e7          	jalr	12(ra) # 800063c4 <release>
      return -1;
    800023c0:	57fd                	li	a5,-1
    800023c2:	bff9                	j	800023a0 <sys_sleep+0x88>

00000000800023c4 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800023c4:	7139                	addi	sp,sp,-64
    800023c6:	fc06                	sd	ra,56(sp)
    800023c8:	f822                	sd	s0,48(sp)
    800023ca:	f426                	sd	s1,40(sp)
    800023cc:	0080                	addi	s0,sp,64
  // lab pgtbl: your code here.
    uint64 pgaddr;
  int pgcount;
  uint64 bufaddr;
  if(argaddr(0,&pgaddr)<0||argint(1,&pgcount)<0||argaddr(2,&bufaddr)<0)
    800023ce:	fd840593          	addi	a1,s0,-40
    800023d2:	4501                	li	a0,0
    800023d4:	00000097          	auipc	ra,0x0
    800023d8:	da6080e7          	jalr	-602(ra) # 8000217a <argaddr>
    800023dc:	06054563          	bltz	a0,80002446 <sys_pgaccess+0x82>
    800023e0:	fd440593          	addi	a1,s0,-44
    800023e4:	4505                	li	a0,1
    800023e6:	00000097          	auipc	ra,0x0
    800023ea:	d72080e7          	jalr	-654(ra) # 80002158 <argint>
    800023ee:	04054e63          	bltz	a0,8000244a <sys_pgaccess+0x86>
    800023f2:	fc840593          	addi	a1,s0,-56
    800023f6:	4509                	li	a0,2
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	d82080e7          	jalr	-638(ra) # 8000217a <argaddr>
    80002400:	04054763          	bltz	a0,8000244e <sys_pgaccess+0x8a>
      return -1;
  struct proc* pr = myproc();
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	bee080e7          	jalr	-1042(ra) # 80000ff2 <myproc>
    8000240c:	84aa                	mv	s1,a0
  uint64 bitmask  = access_check(pr->pagetable,pgcount,pgaddr);
    8000240e:	fd843603          	ld	a2,-40(s0)
    80002412:	fd442583          	lw	a1,-44(s0)
    80002416:	6928                	ld	a0,80(a0)
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	9f0080e7          	jalr	-1552(ra) # 80000e08 <access_check>
    80002420:	fca43023          	sd	a0,-64(s0)
  if(copyout(pr->pagetable,bufaddr,(char*)&bitmask,sizeof(uint64))<0)
    80002424:	46a1                	li	a3,8
    80002426:	fc040613          	addi	a2,s0,-64
    8000242a:	fc843583          	ld	a1,-56(s0)
    8000242e:	68a8                	ld	a0,80(s1)
    80002430:	ffffe097          	auipc	ra,0xffffe
    80002434:	6d2080e7          	jalr	1746(ra) # 80000b02 <copyout>
    80002438:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
  return 0;
}
    8000243c:	70e2                	ld	ra,56(sp)
    8000243e:	7442                	ld	s0,48(sp)
    80002440:	74a2                	ld	s1,40(sp)
    80002442:	6121                	addi	sp,sp,64
    80002444:	8082                	ret
      return -1;
    80002446:	557d                	li	a0,-1
    80002448:	bfd5                	j	8000243c <sys_pgaccess+0x78>
    8000244a:	557d                	li	a0,-1
    8000244c:	bfc5                	j	8000243c <sys_pgaccess+0x78>
    8000244e:	557d                	li	a0,-1
    80002450:	b7f5                	j	8000243c <sys_pgaccess+0x78>

0000000080002452 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002452:	1101                	addi	sp,sp,-32
    80002454:	ec06                	sd	ra,24(sp)
    80002456:	e822                	sd	s0,16(sp)
    80002458:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000245a:	fec40593          	addi	a1,s0,-20
    8000245e:	4501                	li	a0,0
    80002460:	00000097          	auipc	ra,0x0
    80002464:	cf8080e7          	jalr	-776(ra) # 80002158 <argint>
    80002468:	87aa                	mv	a5,a0
    return -1;
    8000246a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000246c:	0007c863          	bltz	a5,8000247c <sys_kill+0x2a>
  return kill(pid);
    80002470:	fec42503          	lw	a0,-20(s0)
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	626080e7          	jalr	1574(ra) # 80001a9a <kill>
}
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret

0000000080002484 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002484:	1101                	addi	sp,sp,-32
    80002486:	ec06                	sd	ra,24(sp)
    80002488:	e822                	sd	s0,16(sp)
    8000248a:	e426                	sd	s1,8(sp)
    8000248c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000248e:	0000d517          	auipc	a0,0xd
    80002492:	df250513          	addi	a0,a0,-526 # 8000f280 <tickslock>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	e7a080e7          	jalr	-390(ra) # 80006310 <acquire>
  xticks = ticks;
    8000249e:	00007497          	auipc	s1,0x7
    800024a2:	b7a4a483          	lw	s1,-1158(s1) # 80009018 <ticks>
  release(&tickslock);
    800024a6:	0000d517          	auipc	a0,0xd
    800024aa:	dda50513          	addi	a0,a0,-550 # 8000f280 <tickslock>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	f16080e7          	jalr	-234(ra) # 800063c4 <release>
  return xticks;
}
    800024b6:	02049513          	slli	a0,s1,0x20
    800024ba:	9101                	srli	a0,a0,0x20
    800024bc:	60e2                	ld	ra,24(sp)
    800024be:	6442                	ld	s0,16(sp)
    800024c0:	64a2                	ld	s1,8(sp)
    800024c2:	6105                	addi	sp,sp,32
    800024c4:	8082                	ret

00000000800024c6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024c6:	7179                	addi	sp,sp,-48
    800024c8:	f406                	sd	ra,40(sp)
    800024ca:	f022                	sd	s0,32(sp)
    800024cc:	ec26                	sd	s1,24(sp)
    800024ce:	e84a                	sd	s2,16(sp)
    800024d0:	e44e                	sd	s3,8(sp)
    800024d2:	e052                	sd	s4,0(sp)
    800024d4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024d6:	00006597          	auipc	a1,0x6
    800024da:	02258593          	addi	a1,a1,34 # 800084f8 <syscalls+0xf8>
    800024de:	0000d517          	auipc	a0,0xd
    800024e2:	dba50513          	addi	a0,a0,-582 # 8000f298 <bcache>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	d9a080e7          	jalr	-614(ra) # 80006280 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024ee:	00015797          	auipc	a5,0x15
    800024f2:	daa78793          	addi	a5,a5,-598 # 80017298 <bcache+0x8000>
    800024f6:	00015717          	auipc	a4,0x15
    800024fa:	00a70713          	addi	a4,a4,10 # 80017500 <bcache+0x8268>
    800024fe:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002502:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002506:	0000d497          	auipc	s1,0xd
    8000250a:	daa48493          	addi	s1,s1,-598 # 8000f2b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000250e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002510:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002512:	00006a17          	auipc	s4,0x6
    80002516:	feea0a13          	addi	s4,s4,-18 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    8000251a:	2b893783          	ld	a5,696(s2)
    8000251e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002520:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002524:	85d2                	mv	a1,s4
    80002526:	01048513          	addi	a0,s1,16
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	4bc080e7          	jalr	1212(ra) # 800039e6 <initsleeplock>
    bcache.head.next->prev = b;
    80002532:	2b893783          	ld	a5,696(s2)
    80002536:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002538:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000253c:	45848493          	addi	s1,s1,1112
    80002540:	fd349de3          	bne	s1,s3,8000251a <binit+0x54>
  }
}
    80002544:	70a2                	ld	ra,40(sp)
    80002546:	7402                	ld	s0,32(sp)
    80002548:	64e2                	ld	s1,24(sp)
    8000254a:	6942                	ld	s2,16(sp)
    8000254c:	69a2                	ld	s3,8(sp)
    8000254e:	6a02                	ld	s4,0(sp)
    80002550:	6145                	addi	sp,sp,48
    80002552:	8082                	ret

0000000080002554 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002554:	7179                	addi	sp,sp,-48
    80002556:	f406                	sd	ra,40(sp)
    80002558:	f022                	sd	s0,32(sp)
    8000255a:	ec26                	sd	s1,24(sp)
    8000255c:	e84a                	sd	s2,16(sp)
    8000255e:	e44e                	sd	s3,8(sp)
    80002560:	1800                	addi	s0,sp,48
    80002562:	892a                	mv	s2,a0
    80002564:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002566:	0000d517          	auipc	a0,0xd
    8000256a:	d3250513          	addi	a0,a0,-718 # 8000f298 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	da2080e7          	jalr	-606(ra) # 80006310 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002576:	00015497          	auipc	s1,0x15
    8000257a:	fda4b483          	ld	s1,-38(s1) # 80017550 <bcache+0x82b8>
    8000257e:	00015797          	auipc	a5,0x15
    80002582:	f8278793          	addi	a5,a5,-126 # 80017500 <bcache+0x8268>
    80002586:	02f48f63          	beq	s1,a5,800025c4 <bread+0x70>
    8000258a:	873e                	mv	a4,a5
    8000258c:	a021                	j	80002594 <bread+0x40>
    8000258e:	68a4                	ld	s1,80(s1)
    80002590:	02e48a63          	beq	s1,a4,800025c4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002594:	449c                	lw	a5,8(s1)
    80002596:	ff279ce3          	bne	a5,s2,8000258e <bread+0x3a>
    8000259a:	44dc                	lw	a5,12(s1)
    8000259c:	ff3799e3          	bne	a5,s3,8000258e <bread+0x3a>
      b->refcnt++;
    800025a0:	40bc                	lw	a5,64(s1)
    800025a2:	2785                	addiw	a5,a5,1
    800025a4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	cf250513          	addi	a0,a0,-782 # 8000f298 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	e16080e7          	jalr	-490(ra) # 800063c4 <release>
      acquiresleep(&b->lock);
    800025b6:	01048513          	addi	a0,s1,16
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	466080e7          	jalr	1126(ra) # 80003a20 <acquiresleep>
      return b;
    800025c2:	a8b9                	j	80002620 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c4:	00015497          	auipc	s1,0x15
    800025c8:	f844b483          	ld	s1,-124(s1) # 80017548 <bcache+0x82b0>
    800025cc:	00015797          	auipc	a5,0x15
    800025d0:	f3478793          	addi	a5,a5,-204 # 80017500 <bcache+0x8268>
    800025d4:	00f48863          	beq	s1,a5,800025e4 <bread+0x90>
    800025d8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025da:	40bc                	lw	a5,64(s1)
    800025dc:	cf81                	beqz	a5,800025f4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025de:	64a4                	ld	s1,72(s1)
    800025e0:	fee49de3          	bne	s1,a4,800025da <bread+0x86>
  panic("bget: no buffers");
    800025e4:	00006517          	auipc	a0,0x6
    800025e8:	f2450513          	addi	a0,a0,-220 # 80008508 <syscalls+0x108>
    800025ec:	00003097          	auipc	ra,0x3
    800025f0:	7e8080e7          	jalr	2024(ra) # 80005dd4 <panic>
      b->dev = dev;
    800025f4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025f8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025fc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002600:	4785                	li	a5,1
    80002602:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002604:	0000d517          	auipc	a0,0xd
    80002608:	c9450513          	addi	a0,a0,-876 # 8000f298 <bcache>
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	db8080e7          	jalr	-584(ra) # 800063c4 <release>
      acquiresleep(&b->lock);
    80002614:	01048513          	addi	a0,s1,16
    80002618:	00001097          	auipc	ra,0x1
    8000261c:	408080e7          	jalr	1032(ra) # 80003a20 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002620:	409c                	lw	a5,0(s1)
    80002622:	cb89                	beqz	a5,80002634 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002624:	8526                	mv	a0,s1
    80002626:	70a2                	ld	ra,40(sp)
    80002628:	7402                	ld	s0,32(sp)
    8000262a:	64e2                	ld	s1,24(sp)
    8000262c:	6942                	ld	s2,16(sp)
    8000262e:	69a2                	ld	s3,8(sp)
    80002630:	6145                	addi	sp,sp,48
    80002632:	8082                	ret
    virtio_disk_rw(b, 0);
    80002634:	4581                	li	a1,0
    80002636:	8526                	mv	a0,s1
    80002638:	00003097          	auipc	ra,0x3
    8000263c:	f2e080e7          	jalr	-210(ra) # 80005566 <virtio_disk_rw>
    b->valid = 1;
    80002640:	4785                	li	a5,1
    80002642:	c09c                	sw	a5,0(s1)
  return b;
    80002644:	b7c5                	j	80002624 <bread+0xd0>

0000000080002646 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
    80002650:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002652:	0541                	addi	a0,a0,16
    80002654:	00001097          	auipc	ra,0x1
    80002658:	466080e7          	jalr	1126(ra) # 80003aba <holdingsleep>
    8000265c:	cd01                	beqz	a0,80002674 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000265e:	4585                	li	a1,1
    80002660:	8526                	mv	a0,s1
    80002662:	00003097          	auipc	ra,0x3
    80002666:	f04080e7          	jalr	-252(ra) # 80005566 <virtio_disk_rw>
}
    8000266a:	60e2                	ld	ra,24(sp)
    8000266c:	6442                	ld	s0,16(sp)
    8000266e:	64a2                	ld	s1,8(sp)
    80002670:	6105                	addi	sp,sp,32
    80002672:	8082                	ret
    panic("bwrite");
    80002674:	00006517          	auipc	a0,0x6
    80002678:	eac50513          	addi	a0,a0,-340 # 80008520 <syscalls+0x120>
    8000267c:	00003097          	auipc	ra,0x3
    80002680:	758080e7          	jalr	1880(ra) # 80005dd4 <panic>

0000000080002684 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002684:	1101                	addi	sp,sp,-32
    80002686:	ec06                	sd	ra,24(sp)
    80002688:	e822                	sd	s0,16(sp)
    8000268a:	e426                	sd	s1,8(sp)
    8000268c:	e04a                	sd	s2,0(sp)
    8000268e:	1000                	addi	s0,sp,32
    80002690:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002692:	01050913          	addi	s2,a0,16
    80002696:	854a                	mv	a0,s2
    80002698:	00001097          	auipc	ra,0x1
    8000269c:	422080e7          	jalr	1058(ra) # 80003aba <holdingsleep>
    800026a0:	c92d                	beqz	a0,80002712 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026a2:	854a                	mv	a0,s2
    800026a4:	00001097          	auipc	ra,0x1
    800026a8:	3d2080e7          	jalr	978(ra) # 80003a76 <releasesleep>

  acquire(&bcache.lock);
    800026ac:	0000d517          	auipc	a0,0xd
    800026b0:	bec50513          	addi	a0,a0,-1044 # 8000f298 <bcache>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	c5c080e7          	jalr	-932(ra) # 80006310 <acquire>
  b->refcnt--;
    800026bc:	40bc                	lw	a5,64(s1)
    800026be:	37fd                	addiw	a5,a5,-1
    800026c0:	0007871b          	sext.w	a4,a5
    800026c4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026c6:	eb05                	bnez	a4,800026f6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026c8:	68bc                	ld	a5,80(s1)
    800026ca:	64b8                	ld	a4,72(s1)
    800026cc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026ce:	64bc                	ld	a5,72(s1)
    800026d0:	68b8                	ld	a4,80(s1)
    800026d2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026d4:	00015797          	auipc	a5,0x15
    800026d8:	bc478793          	addi	a5,a5,-1084 # 80017298 <bcache+0x8000>
    800026dc:	2b87b703          	ld	a4,696(a5)
    800026e0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026e2:	00015717          	auipc	a4,0x15
    800026e6:	e1e70713          	addi	a4,a4,-482 # 80017500 <bcache+0x8268>
    800026ea:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026ec:	2b87b703          	ld	a4,696(a5)
    800026f0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026f2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026f6:	0000d517          	auipc	a0,0xd
    800026fa:	ba250513          	addi	a0,a0,-1118 # 8000f298 <bcache>
    800026fe:	00004097          	auipc	ra,0x4
    80002702:	cc6080e7          	jalr	-826(ra) # 800063c4 <release>
}
    80002706:	60e2                	ld	ra,24(sp)
    80002708:	6442                	ld	s0,16(sp)
    8000270a:	64a2                	ld	s1,8(sp)
    8000270c:	6902                	ld	s2,0(sp)
    8000270e:	6105                	addi	sp,sp,32
    80002710:	8082                	ret
    panic("brelse");
    80002712:	00006517          	auipc	a0,0x6
    80002716:	e1650513          	addi	a0,a0,-490 # 80008528 <syscalls+0x128>
    8000271a:	00003097          	auipc	ra,0x3
    8000271e:	6ba080e7          	jalr	1722(ra) # 80005dd4 <panic>

0000000080002722 <bpin>:

void
bpin(struct buf *b) {
    80002722:	1101                	addi	sp,sp,-32
    80002724:	ec06                	sd	ra,24(sp)
    80002726:	e822                	sd	s0,16(sp)
    80002728:	e426                	sd	s1,8(sp)
    8000272a:	1000                	addi	s0,sp,32
    8000272c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000272e:	0000d517          	auipc	a0,0xd
    80002732:	b6a50513          	addi	a0,a0,-1174 # 8000f298 <bcache>
    80002736:	00004097          	auipc	ra,0x4
    8000273a:	bda080e7          	jalr	-1062(ra) # 80006310 <acquire>
  b->refcnt++;
    8000273e:	40bc                	lw	a5,64(s1)
    80002740:	2785                	addiw	a5,a5,1
    80002742:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002744:	0000d517          	auipc	a0,0xd
    80002748:	b5450513          	addi	a0,a0,-1196 # 8000f298 <bcache>
    8000274c:	00004097          	auipc	ra,0x4
    80002750:	c78080e7          	jalr	-904(ra) # 800063c4 <release>
}
    80002754:	60e2                	ld	ra,24(sp)
    80002756:	6442                	ld	s0,16(sp)
    80002758:	64a2                	ld	s1,8(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret

000000008000275e <bunpin>:

void
bunpin(struct buf *b) {
    8000275e:	1101                	addi	sp,sp,-32
    80002760:	ec06                	sd	ra,24(sp)
    80002762:	e822                	sd	s0,16(sp)
    80002764:	e426                	sd	s1,8(sp)
    80002766:	1000                	addi	s0,sp,32
    80002768:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000276a:	0000d517          	auipc	a0,0xd
    8000276e:	b2e50513          	addi	a0,a0,-1234 # 8000f298 <bcache>
    80002772:	00004097          	auipc	ra,0x4
    80002776:	b9e080e7          	jalr	-1122(ra) # 80006310 <acquire>
  b->refcnt--;
    8000277a:	40bc                	lw	a5,64(s1)
    8000277c:	37fd                	addiw	a5,a5,-1
    8000277e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002780:	0000d517          	auipc	a0,0xd
    80002784:	b1850513          	addi	a0,a0,-1256 # 8000f298 <bcache>
    80002788:	00004097          	auipc	ra,0x4
    8000278c:	c3c080e7          	jalr	-964(ra) # 800063c4 <release>
}
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6105                	addi	sp,sp,32
    80002798:	8082                	ret

000000008000279a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000279a:	1101                	addi	sp,sp,-32
    8000279c:	ec06                	sd	ra,24(sp)
    8000279e:	e822                	sd	s0,16(sp)
    800027a0:	e426                	sd	s1,8(sp)
    800027a2:	e04a                	sd	s2,0(sp)
    800027a4:	1000                	addi	s0,sp,32
    800027a6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027a8:	00d5d59b          	srliw	a1,a1,0xd
    800027ac:	00015797          	auipc	a5,0x15
    800027b0:	1c87a783          	lw	a5,456(a5) # 80017974 <sb+0x1c>
    800027b4:	9dbd                	addw	a1,a1,a5
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	d9e080e7          	jalr	-610(ra) # 80002554 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027be:	0074f713          	andi	a4,s1,7
    800027c2:	4785                	li	a5,1
    800027c4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027c8:	14ce                	slli	s1,s1,0x33
    800027ca:	90d9                	srli	s1,s1,0x36
    800027cc:	00950733          	add	a4,a0,s1
    800027d0:	05874703          	lbu	a4,88(a4)
    800027d4:	00e7f6b3          	and	a3,a5,a4
    800027d8:	c69d                	beqz	a3,80002806 <bfree+0x6c>
    800027da:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027dc:	94aa                	add	s1,s1,a0
    800027de:	fff7c793          	not	a5,a5
    800027e2:	8ff9                	and	a5,a5,a4
    800027e4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027e8:	00001097          	auipc	ra,0x1
    800027ec:	118080e7          	jalr	280(ra) # 80003900 <log_write>
  brelse(bp);
    800027f0:	854a                	mv	a0,s2
    800027f2:	00000097          	auipc	ra,0x0
    800027f6:	e92080e7          	jalr	-366(ra) # 80002684 <brelse>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6902                	ld	s2,0(sp)
    80002802:	6105                	addi	sp,sp,32
    80002804:	8082                	ret
    panic("freeing free block");
    80002806:	00006517          	auipc	a0,0x6
    8000280a:	d2a50513          	addi	a0,a0,-726 # 80008530 <syscalls+0x130>
    8000280e:	00003097          	auipc	ra,0x3
    80002812:	5c6080e7          	jalr	1478(ra) # 80005dd4 <panic>

0000000080002816 <balloc>:
{
    80002816:	711d                	addi	sp,sp,-96
    80002818:	ec86                	sd	ra,88(sp)
    8000281a:	e8a2                	sd	s0,80(sp)
    8000281c:	e4a6                	sd	s1,72(sp)
    8000281e:	e0ca                	sd	s2,64(sp)
    80002820:	fc4e                	sd	s3,56(sp)
    80002822:	f852                	sd	s4,48(sp)
    80002824:	f456                	sd	s5,40(sp)
    80002826:	f05a                	sd	s6,32(sp)
    80002828:	ec5e                	sd	s7,24(sp)
    8000282a:	e862                	sd	s8,16(sp)
    8000282c:	e466                	sd	s9,8(sp)
    8000282e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002830:	00015797          	auipc	a5,0x15
    80002834:	12c7a783          	lw	a5,300(a5) # 8001795c <sb+0x4>
    80002838:	cbd1                	beqz	a5,800028cc <balloc+0xb6>
    8000283a:	8baa                	mv	s7,a0
    8000283c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000283e:	00015b17          	auipc	s6,0x15
    80002842:	11ab0b13          	addi	s6,s6,282 # 80017958 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002846:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002848:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000284c:	6c89                	lui	s9,0x2
    8000284e:	a831                	j	8000286a <balloc+0x54>
    brelse(bp);
    80002850:	854a                	mv	a0,s2
    80002852:	00000097          	auipc	ra,0x0
    80002856:	e32080e7          	jalr	-462(ra) # 80002684 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000285a:	015c87bb          	addw	a5,s9,s5
    8000285e:	00078a9b          	sext.w	s5,a5
    80002862:	004b2703          	lw	a4,4(s6)
    80002866:	06eaf363          	bgeu	s5,a4,800028cc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000286a:	41fad79b          	sraiw	a5,s5,0x1f
    8000286e:	0137d79b          	srliw	a5,a5,0x13
    80002872:	015787bb          	addw	a5,a5,s5
    80002876:	40d7d79b          	sraiw	a5,a5,0xd
    8000287a:	01cb2583          	lw	a1,28(s6)
    8000287e:	9dbd                	addw	a1,a1,a5
    80002880:	855e                	mv	a0,s7
    80002882:	00000097          	auipc	ra,0x0
    80002886:	cd2080e7          	jalr	-814(ra) # 80002554 <bread>
    8000288a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288c:	004b2503          	lw	a0,4(s6)
    80002890:	000a849b          	sext.w	s1,s5
    80002894:	8662                	mv	a2,s8
    80002896:	faa4fde3          	bgeu	s1,a0,80002850 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000289a:	41f6579b          	sraiw	a5,a2,0x1f
    8000289e:	01d7d69b          	srliw	a3,a5,0x1d
    800028a2:	00c6873b          	addw	a4,a3,a2
    800028a6:	00777793          	andi	a5,a4,7
    800028aa:	9f95                	subw	a5,a5,a3
    800028ac:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028b0:	4037571b          	sraiw	a4,a4,0x3
    800028b4:	00e906b3          	add	a3,s2,a4
    800028b8:	0586c683          	lbu	a3,88(a3)
    800028bc:	00d7f5b3          	and	a1,a5,a3
    800028c0:	cd91                	beqz	a1,800028dc <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028c2:	2605                	addiw	a2,a2,1
    800028c4:	2485                	addiw	s1,s1,1
    800028c6:	fd4618e3          	bne	a2,s4,80002896 <balloc+0x80>
    800028ca:	b759                	j	80002850 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028cc:	00006517          	auipc	a0,0x6
    800028d0:	c7c50513          	addi	a0,a0,-900 # 80008548 <syscalls+0x148>
    800028d4:	00003097          	auipc	ra,0x3
    800028d8:	500080e7          	jalr	1280(ra) # 80005dd4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028dc:	974a                	add	a4,a4,s2
    800028de:	8fd5                	or	a5,a5,a3
    800028e0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028e4:	854a                	mv	a0,s2
    800028e6:	00001097          	auipc	ra,0x1
    800028ea:	01a080e7          	jalr	26(ra) # 80003900 <log_write>
        brelse(bp);
    800028ee:	854a                	mv	a0,s2
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	d94080e7          	jalr	-620(ra) # 80002684 <brelse>
  bp = bread(dev, bno);
    800028f8:	85a6                	mv	a1,s1
    800028fa:	855e                	mv	a0,s7
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	c58080e7          	jalr	-936(ra) # 80002554 <bread>
    80002904:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002906:	40000613          	li	a2,1024
    8000290a:	4581                	li	a1,0
    8000290c:	05850513          	addi	a0,a0,88
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	868080e7          	jalr	-1944(ra) # 80000178 <memset>
  log_write(bp);
    80002918:	854a                	mv	a0,s2
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	fe6080e7          	jalr	-26(ra) # 80003900 <log_write>
  brelse(bp);
    80002922:	854a                	mv	a0,s2
    80002924:	00000097          	auipc	ra,0x0
    80002928:	d60080e7          	jalr	-672(ra) # 80002684 <brelse>
}
    8000292c:	8526                	mv	a0,s1
    8000292e:	60e6                	ld	ra,88(sp)
    80002930:	6446                	ld	s0,80(sp)
    80002932:	64a6                	ld	s1,72(sp)
    80002934:	6906                	ld	s2,64(sp)
    80002936:	79e2                	ld	s3,56(sp)
    80002938:	7a42                	ld	s4,48(sp)
    8000293a:	7aa2                	ld	s5,40(sp)
    8000293c:	7b02                	ld	s6,32(sp)
    8000293e:	6be2                	ld	s7,24(sp)
    80002940:	6c42                	ld	s8,16(sp)
    80002942:	6ca2                	ld	s9,8(sp)
    80002944:	6125                	addi	sp,sp,96
    80002946:	8082                	ret

0000000080002948 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000295a:	47ad                	li	a5,11
    8000295c:	04b7fe63          	bgeu	a5,a1,800029b8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002960:	ff45849b          	addiw	s1,a1,-12
    80002964:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002968:	0ff00793          	li	a5,255
    8000296c:	0ae7e363          	bltu	a5,a4,80002a12 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002970:	08052583          	lw	a1,128(a0)
    80002974:	c5ad                	beqz	a1,800029de <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002976:	00092503          	lw	a0,0(s2)
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	bda080e7          	jalr	-1062(ra) # 80002554 <bread>
    80002982:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002984:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002988:	02049593          	slli	a1,s1,0x20
    8000298c:	9181                	srli	a1,a1,0x20
    8000298e:	058a                	slli	a1,a1,0x2
    80002990:	00b784b3          	add	s1,a5,a1
    80002994:	0004a983          	lw	s3,0(s1)
    80002998:	04098d63          	beqz	s3,800029f2 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000299c:	8552                	mv	a0,s4
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	ce6080e7          	jalr	-794(ra) # 80002684 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029a6:	854e                	mv	a0,s3
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6a02                	ld	s4,0(sp)
    800029b4:	6145                	addi	sp,sp,48
    800029b6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029b8:	02059493          	slli	s1,a1,0x20
    800029bc:	9081                	srli	s1,s1,0x20
    800029be:	048a                	slli	s1,s1,0x2
    800029c0:	94aa                	add	s1,s1,a0
    800029c2:	0504a983          	lw	s3,80(s1)
    800029c6:	fe0990e3          	bnez	s3,800029a6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029ca:	4108                	lw	a0,0(a0)
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	e4a080e7          	jalr	-438(ra) # 80002816 <balloc>
    800029d4:	0005099b          	sext.w	s3,a0
    800029d8:	0534a823          	sw	s3,80(s1)
    800029dc:	b7e9                	j	800029a6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029de:	4108                	lw	a0,0(a0)
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	e36080e7          	jalr	-458(ra) # 80002816 <balloc>
    800029e8:	0005059b          	sext.w	a1,a0
    800029ec:	08b92023          	sw	a1,128(s2)
    800029f0:	b759                	j	80002976 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029f2:	00092503          	lw	a0,0(s2)
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	e20080e7          	jalr	-480(ra) # 80002816 <balloc>
    800029fe:	0005099b          	sext.w	s3,a0
    80002a02:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a06:	8552                	mv	a0,s4
    80002a08:	00001097          	auipc	ra,0x1
    80002a0c:	ef8080e7          	jalr	-264(ra) # 80003900 <log_write>
    80002a10:	b771                	j	8000299c <bmap+0x54>
  panic("bmap: out of range");
    80002a12:	00006517          	auipc	a0,0x6
    80002a16:	b4e50513          	addi	a0,a0,-1202 # 80008560 <syscalls+0x160>
    80002a1a:	00003097          	auipc	ra,0x3
    80002a1e:	3ba080e7          	jalr	954(ra) # 80005dd4 <panic>

0000000080002a22 <iget>:
{
    80002a22:	7179                	addi	sp,sp,-48
    80002a24:	f406                	sd	ra,40(sp)
    80002a26:	f022                	sd	s0,32(sp)
    80002a28:	ec26                	sd	s1,24(sp)
    80002a2a:	e84a                	sd	s2,16(sp)
    80002a2c:	e44e                	sd	s3,8(sp)
    80002a2e:	e052                	sd	s4,0(sp)
    80002a30:	1800                	addi	s0,sp,48
    80002a32:	89aa                	mv	s3,a0
    80002a34:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a36:	00015517          	auipc	a0,0x15
    80002a3a:	f4250513          	addi	a0,a0,-190 # 80017978 <itable>
    80002a3e:	00004097          	auipc	ra,0x4
    80002a42:	8d2080e7          	jalr	-1838(ra) # 80006310 <acquire>
  empty = 0;
    80002a46:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a48:	00015497          	auipc	s1,0x15
    80002a4c:	f4848493          	addi	s1,s1,-184 # 80017990 <itable+0x18>
    80002a50:	00017697          	auipc	a3,0x17
    80002a54:	9d068693          	addi	a3,a3,-1584 # 80019420 <log>
    80002a58:	a039                	j	80002a66 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a5a:	02090b63          	beqz	s2,80002a90 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5e:	08848493          	addi	s1,s1,136
    80002a62:	02d48a63          	beq	s1,a3,80002a96 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a66:	449c                	lw	a5,8(s1)
    80002a68:	fef059e3          	blez	a5,80002a5a <iget+0x38>
    80002a6c:	4098                	lw	a4,0(s1)
    80002a6e:	ff3716e3          	bne	a4,s3,80002a5a <iget+0x38>
    80002a72:	40d8                	lw	a4,4(s1)
    80002a74:	ff4713e3          	bne	a4,s4,80002a5a <iget+0x38>
      ip->ref++;
    80002a78:	2785                	addiw	a5,a5,1
    80002a7a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a7c:	00015517          	auipc	a0,0x15
    80002a80:	efc50513          	addi	a0,a0,-260 # 80017978 <itable>
    80002a84:	00004097          	auipc	ra,0x4
    80002a88:	940080e7          	jalr	-1728(ra) # 800063c4 <release>
      return ip;
    80002a8c:	8926                	mv	s2,s1
    80002a8e:	a03d                	j	80002abc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a90:	f7f9                	bnez	a5,80002a5e <iget+0x3c>
    80002a92:	8926                	mv	s2,s1
    80002a94:	b7e9                	j	80002a5e <iget+0x3c>
  if(empty == 0)
    80002a96:	02090c63          	beqz	s2,80002ace <iget+0xac>
  ip->dev = dev;
    80002a9a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a9e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aa2:	4785                	li	a5,1
    80002aa4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aa8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002aac:	00015517          	auipc	a0,0x15
    80002ab0:	ecc50513          	addi	a0,a0,-308 # 80017978 <itable>
    80002ab4:	00004097          	auipc	ra,0x4
    80002ab8:	910080e7          	jalr	-1776(ra) # 800063c4 <release>
}
    80002abc:	854a                	mv	a0,s2
    80002abe:	70a2                	ld	ra,40(sp)
    80002ac0:	7402                	ld	s0,32(sp)
    80002ac2:	64e2                	ld	s1,24(sp)
    80002ac4:	6942                	ld	s2,16(sp)
    80002ac6:	69a2                	ld	s3,8(sp)
    80002ac8:	6a02                	ld	s4,0(sp)
    80002aca:	6145                	addi	sp,sp,48
    80002acc:	8082                	ret
    panic("iget: no inodes");
    80002ace:	00006517          	auipc	a0,0x6
    80002ad2:	aaa50513          	addi	a0,a0,-1366 # 80008578 <syscalls+0x178>
    80002ad6:	00003097          	auipc	ra,0x3
    80002ada:	2fe080e7          	jalr	766(ra) # 80005dd4 <panic>

0000000080002ade <fsinit>:
fsinit(int dev) {
    80002ade:	7179                	addi	sp,sp,-48
    80002ae0:	f406                	sd	ra,40(sp)
    80002ae2:	f022                	sd	s0,32(sp)
    80002ae4:	ec26                	sd	s1,24(sp)
    80002ae6:	e84a                	sd	s2,16(sp)
    80002ae8:	e44e                	sd	s3,8(sp)
    80002aea:	1800                	addi	s0,sp,48
    80002aec:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aee:	4585                	li	a1,1
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	a64080e7          	jalr	-1436(ra) # 80002554 <bread>
    80002af8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002afa:	00015997          	auipc	s3,0x15
    80002afe:	e5e98993          	addi	s3,s3,-418 # 80017958 <sb>
    80002b02:	02000613          	li	a2,32
    80002b06:	05850593          	addi	a1,a0,88
    80002b0a:	854e                	mv	a0,s3
    80002b0c:	ffffd097          	auipc	ra,0xffffd
    80002b10:	6c8080e7          	jalr	1736(ra) # 800001d4 <memmove>
  brelse(bp);
    80002b14:	8526                	mv	a0,s1
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	b6e080e7          	jalr	-1170(ra) # 80002684 <brelse>
  if(sb.magic != FSMAGIC)
    80002b1e:	0009a703          	lw	a4,0(s3)
    80002b22:	102037b7          	lui	a5,0x10203
    80002b26:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b2a:	02f71263          	bne	a4,a5,80002b4e <fsinit+0x70>
  initlog(dev, &sb);
    80002b2e:	00015597          	auipc	a1,0x15
    80002b32:	e2a58593          	addi	a1,a1,-470 # 80017958 <sb>
    80002b36:	854a                	mv	a0,s2
    80002b38:	00001097          	auipc	ra,0x1
    80002b3c:	b4c080e7          	jalr	-1204(ra) # 80003684 <initlog>
}
    80002b40:	70a2                	ld	ra,40(sp)
    80002b42:	7402                	ld	s0,32(sp)
    80002b44:	64e2                	ld	s1,24(sp)
    80002b46:	6942                	ld	s2,16(sp)
    80002b48:	69a2                	ld	s3,8(sp)
    80002b4a:	6145                	addi	sp,sp,48
    80002b4c:	8082                	ret
    panic("invalid file system");
    80002b4e:	00006517          	auipc	a0,0x6
    80002b52:	a3a50513          	addi	a0,a0,-1478 # 80008588 <syscalls+0x188>
    80002b56:	00003097          	auipc	ra,0x3
    80002b5a:	27e080e7          	jalr	638(ra) # 80005dd4 <panic>

0000000080002b5e <iinit>:
{
    80002b5e:	7179                	addi	sp,sp,-48
    80002b60:	f406                	sd	ra,40(sp)
    80002b62:	f022                	sd	s0,32(sp)
    80002b64:	ec26                	sd	s1,24(sp)
    80002b66:	e84a                	sd	s2,16(sp)
    80002b68:	e44e                	sd	s3,8(sp)
    80002b6a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b6c:	00006597          	auipc	a1,0x6
    80002b70:	a3458593          	addi	a1,a1,-1484 # 800085a0 <syscalls+0x1a0>
    80002b74:	00015517          	auipc	a0,0x15
    80002b78:	e0450513          	addi	a0,a0,-508 # 80017978 <itable>
    80002b7c:	00003097          	auipc	ra,0x3
    80002b80:	704080e7          	jalr	1796(ra) # 80006280 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b84:	00015497          	auipc	s1,0x15
    80002b88:	e1c48493          	addi	s1,s1,-484 # 800179a0 <itable+0x28>
    80002b8c:	00017997          	auipc	s3,0x17
    80002b90:	8a498993          	addi	s3,s3,-1884 # 80019430 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b94:	00006917          	auipc	s2,0x6
    80002b98:	a1490913          	addi	s2,s2,-1516 # 800085a8 <syscalls+0x1a8>
    80002b9c:	85ca                	mv	a1,s2
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	00001097          	auipc	ra,0x1
    80002ba4:	e46080e7          	jalr	-442(ra) # 800039e6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ba8:	08848493          	addi	s1,s1,136
    80002bac:	ff3498e3          	bne	s1,s3,80002b9c <iinit+0x3e>
}
    80002bb0:	70a2                	ld	ra,40(sp)
    80002bb2:	7402                	ld	s0,32(sp)
    80002bb4:	64e2                	ld	s1,24(sp)
    80002bb6:	6942                	ld	s2,16(sp)
    80002bb8:	69a2                	ld	s3,8(sp)
    80002bba:	6145                	addi	sp,sp,48
    80002bbc:	8082                	ret

0000000080002bbe <ialloc>:
{
    80002bbe:	715d                	addi	sp,sp,-80
    80002bc0:	e486                	sd	ra,72(sp)
    80002bc2:	e0a2                	sd	s0,64(sp)
    80002bc4:	fc26                	sd	s1,56(sp)
    80002bc6:	f84a                	sd	s2,48(sp)
    80002bc8:	f44e                	sd	s3,40(sp)
    80002bca:	f052                	sd	s4,32(sp)
    80002bcc:	ec56                	sd	s5,24(sp)
    80002bce:	e85a                	sd	s6,16(sp)
    80002bd0:	e45e                	sd	s7,8(sp)
    80002bd2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd4:	00015717          	auipc	a4,0x15
    80002bd8:	d9072703          	lw	a4,-624(a4) # 80017964 <sb+0xc>
    80002bdc:	4785                	li	a5,1
    80002bde:	04e7fa63          	bgeu	a5,a4,80002c32 <ialloc+0x74>
    80002be2:	8aaa                	mv	s5,a0
    80002be4:	8bae                	mv	s7,a1
    80002be6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002be8:	00015a17          	auipc	s4,0x15
    80002bec:	d70a0a13          	addi	s4,s4,-656 # 80017958 <sb>
    80002bf0:	00048b1b          	sext.w	s6,s1
    80002bf4:	0044d793          	srli	a5,s1,0x4
    80002bf8:	018a2583          	lw	a1,24(s4)
    80002bfc:	9dbd                	addw	a1,a1,a5
    80002bfe:	8556                	mv	a0,s5
    80002c00:	00000097          	auipc	ra,0x0
    80002c04:	954080e7          	jalr	-1708(ra) # 80002554 <bread>
    80002c08:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c0a:	05850993          	addi	s3,a0,88
    80002c0e:	00f4f793          	andi	a5,s1,15
    80002c12:	079a                	slli	a5,a5,0x6
    80002c14:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c16:	00099783          	lh	a5,0(s3)
    80002c1a:	c785                	beqz	a5,80002c42 <ialloc+0x84>
    brelse(bp);
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	a68080e7          	jalr	-1432(ra) # 80002684 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c24:	0485                	addi	s1,s1,1
    80002c26:	00ca2703          	lw	a4,12(s4)
    80002c2a:	0004879b          	sext.w	a5,s1
    80002c2e:	fce7e1e3          	bltu	a5,a4,80002bf0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c32:	00006517          	auipc	a0,0x6
    80002c36:	97e50513          	addi	a0,a0,-1666 # 800085b0 <syscalls+0x1b0>
    80002c3a:	00003097          	auipc	ra,0x3
    80002c3e:	19a080e7          	jalr	410(ra) # 80005dd4 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c42:	04000613          	li	a2,64
    80002c46:	4581                	li	a1,0
    80002c48:	854e                	mv	a0,s3
    80002c4a:	ffffd097          	auipc	ra,0xffffd
    80002c4e:	52e080e7          	jalr	1326(ra) # 80000178 <memset>
      dip->type = type;
    80002c52:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c56:	854a                	mv	a0,s2
    80002c58:	00001097          	auipc	ra,0x1
    80002c5c:	ca8080e7          	jalr	-856(ra) # 80003900 <log_write>
      brelse(bp);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	a22080e7          	jalr	-1502(ra) # 80002684 <brelse>
      return iget(dev, inum);
    80002c6a:	85da                	mv	a1,s6
    80002c6c:	8556                	mv	a0,s5
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	db4080e7          	jalr	-588(ra) # 80002a22 <iget>
}
    80002c76:	60a6                	ld	ra,72(sp)
    80002c78:	6406                	ld	s0,64(sp)
    80002c7a:	74e2                	ld	s1,56(sp)
    80002c7c:	7942                	ld	s2,48(sp)
    80002c7e:	79a2                	ld	s3,40(sp)
    80002c80:	7a02                	ld	s4,32(sp)
    80002c82:	6ae2                	ld	s5,24(sp)
    80002c84:	6b42                	ld	s6,16(sp)
    80002c86:	6ba2                	ld	s7,8(sp)
    80002c88:	6161                	addi	sp,sp,80
    80002c8a:	8082                	ret

0000000080002c8c <iupdate>:
{
    80002c8c:	1101                	addi	sp,sp,-32
    80002c8e:	ec06                	sd	ra,24(sp)
    80002c90:	e822                	sd	s0,16(sp)
    80002c92:	e426                	sd	s1,8(sp)
    80002c94:	e04a                	sd	s2,0(sp)
    80002c96:	1000                	addi	s0,sp,32
    80002c98:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9a:	415c                	lw	a5,4(a0)
    80002c9c:	0047d79b          	srliw	a5,a5,0x4
    80002ca0:	00015597          	auipc	a1,0x15
    80002ca4:	cd05a583          	lw	a1,-816(a1) # 80017970 <sb+0x18>
    80002ca8:	9dbd                	addw	a1,a1,a5
    80002caa:	4108                	lw	a0,0(a0)
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	8a8080e7          	jalr	-1880(ra) # 80002554 <bread>
    80002cb4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cb6:	05850793          	addi	a5,a0,88
    80002cba:	40c8                	lw	a0,4(s1)
    80002cbc:	893d                	andi	a0,a0,15
    80002cbe:	051a                	slli	a0,a0,0x6
    80002cc0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cc2:	04449703          	lh	a4,68(s1)
    80002cc6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cca:	04649703          	lh	a4,70(s1)
    80002cce:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cd2:	04849703          	lh	a4,72(s1)
    80002cd6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cda:	04a49703          	lh	a4,74(s1)
    80002cde:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ce2:	44f8                	lw	a4,76(s1)
    80002ce4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ce6:	03400613          	li	a2,52
    80002cea:	05048593          	addi	a1,s1,80
    80002cee:	0531                	addi	a0,a0,12
    80002cf0:	ffffd097          	auipc	ra,0xffffd
    80002cf4:	4e4080e7          	jalr	1252(ra) # 800001d4 <memmove>
  log_write(bp);
    80002cf8:	854a                	mv	a0,s2
    80002cfa:	00001097          	auipc	ra,0x1
    80002cfe:	c06080e7          	jalr	-1018(ra) # 80003900 <log_write>
  brelse(bp);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	980080e7          	jalr	-1664(ra) # 80002684 <brelse>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <idup>:
{
    80002d18:	1101                	addi	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	e426                	sd	s1,8(sp)
    80002d20:	1000                	addi	s0,sp,32
    80002d22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d24:	00015517          	auipc	a0,0x15
    80002d28:	c5450513          	addi	a0,a0,-940 # 80017978 <itable>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	5e4080e7          	jalr	1508(ra) # 80006310 <acquire>
  ip->ref++;
    80002d34:	449c                	lw	a5,8(s1)
    80002d36:	2785                	addiw	a5,a5,1
    80002d38:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d3a:	00015517          	auipc	a0,0x15
    80002d3e:	c3e50513          	addi	a0,a0,-962 # 80017978 <itable>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	682080e7          	jalr	1666(ra) # 800063c4 <release>
}
    80002d4a:	8526                	mv	a0,s1
    80002d4c:	60e2                	ld	ra,24(sp)
    80002d4e:	6442                	ld	s0,16(sp)
    80002d50:	64a2                	ld	s1,8(sp)
    80002d52:	6105                	addi	sp,sp,32
    80002d54:	8082                	ret

0000000080002d56 <ilock>:
{
    80002d56:	1101                	addi	sp,sp,-32
    80002d58:	ec06                	sd	ra,24(sp)
    80002d5a:	e822                	sd	s0,16(sp)
    80002d5c:	e426                	sd	s1,8(sp)
    80002d5e:	e04a                	sd	s2,0(sp)
    80002d60:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d62:	c115                	beqz	a0,80002d86 <ilock+0x30>
    80002d64:	84aa                	mv	s1,a0
    80002d66:	451c                	lw	a5,8(a0)
    80002d68:	00f05f63          	blez	a5,80002d86 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d6c:	0541                	addi	a0,a0,16
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	cb2080e7          	jalr	-846(ra) # 80003a20 <acquiresleep>
  if(ip->valid == 0){
    80002d76:	40bc                	lw	a5,64(s1)
    80002d78:	cf99                	beqz	a5,80002d96 <ilock+0x40>
}
    80002d7a:	60e2                	ld	ra,24(sp)
    80002d7c:	6442                	ld	s0,16(sp)
    80002d7e:	64a2                	ld	s1,8(sp)
    80002d80:	6902                	ld	s2,0(sp)
    80002d82:	6105                	addi	sp,sp,32
    80002d84:	8082                	ret
    panic("ilock");
    80002d86:	00006517          	auipc	a0,0x6
    80002d8a:	84250513          	addi	a0,a0,-1982 # 800085c8 <syscalls+0x1c8>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	046080e7          	jalr	70(ra) # 80005dd4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d96:	40dc                	lw	a5,4(s1)
    80002d98:	0047d79b          	srliw	a5,a5,0x4
    80002d9c:	00015597          	auipc	a1,0x15
    80002da0:	bd45a583          	lw	a1,-1068(a1) # 80017970 <sb+0x18>
    80002da4:	9dbd                	addw	a1,a1,a5
    80002da6:	4088                	lw	a0,0(s1)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	7ac080e7          	jalr	1964(ra) # 80002554 <bread>
    80002db0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db2:	05850593          	addi	a1,a0,88
    80002db6:	40dc                	lw	a5,4(s1)
    80002db8:	8bbd                	andi	a5,a5,15
    80002dba:	079a                	slli	a5,a5,0x6
    80002dbc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dbe:	00059783          	lh	a5,0(a1)
    80002dc2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dc6:	00259783          	lh	a5,2(a1)
    80002dca:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dce:	00459783          	lh	a5,4(a1)
    80002dd2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dd6:	00659783          	lh	a5,6(a1)
    80002dda:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002dde:	459c                	lw	a5,8(a1)
    80002de0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de2:	03400613          	li	a2,52
    80002de6:	05b1                	addi	a1,a1,12
    80002de8:	05048513          	addi	a0,s1,80
    80002dec:	ffffd097          	auipc	ra,0xffffd
    80002df0:	3e8080e7          	jalr	1000(ra) # 800001d4 <memmove>
    brelse(bp);
    80002df4:	854a                	mv	a0,s2
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	88e080e7          	jalr	-1906(ra) # 80002684 <brelse>
    ip->valid = 1;
    80002dfe:	4785                	li	a5,1
    80002e00:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e02:	04449783          	lh	a5,68(s1)
    80002e06:	fbb5                	bnez	a5,80002d7a <ilock+0x24>
      panic("ilock: no type");
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	7c850513          	addi	a0,a0,1992 # 800085d0 <syscalls+0x1d0>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	fc4080e7          	jalr	-60(ra) # 80005dd4 <panic>

0000000080002e18 <iunlock>:
{
    80002e18:	1101                	addi	sp,sp,-32
    80002e1a:	ec06                	sd	ra,24(sp)
    80002e1c:	e822                	sd	s0,16(sp)
    80002e1e:	e426                	sd	s1,8(sp)
    80002e20:	e04a                	sd	s2,0(sp)
    80002e22:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e24:	c905                	beqz	a0,80002e54 <iunlock+0x3c>
    80002e26:	84aa                	mv	s1,a0
    80002e28:	01050913          	addi	s2,a0,16
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	00001097          	auipc	ra,0x1
    80002e32:	c8c080e7          	jalr	-884(ra) # 80003aba <holdingsleep>
    80002e36:	cd19                	beqz	a0,80002e54 <iunlock+0x3c>
    80002e38:	449c                	lw	a5,8(s1)
    80002e3a:	00f05d63          	blez	a5,80002e54 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e3e:	854a                	mv	a0,s2
    80002e40:	00001097          	auipc	ra,0x1
    80002e44:	c36080e7          	jalr	-970(ra) # 80003a76 <releasesleep>
}
    80002e48:	60e2                	ld	ra,24(sp)
    80002e4a:	6442                	ld	s0,16(sp)
    80002e4c:	64a2                	ld	s1,8(sp)
    80002e4e:	6902                	ld	s2,0(sp)
    80002e50:	6105                	addi	sp,sp,32
    80002e52:	8082                	ret
    panic("iunlock");
    80002e54:	00005517          	auipc	a0,0x5
    80002e58:	78c50513          	addi	a0,a0,1932 # 800085e0 <syscalls+0x1e0>
    80002e5c:	00003097          	auipc	ra,0x3
    80002e60:	f78080e7          	jalr	-136(ra) # 80005dd4 <panic>

0000000080002e64 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	e44e                	sd	s3,8(sp)
    80002e70:	e052                	sd	s4,0(sp)
    80002e72:	1800                	addi	s0,sp,48
    80002e74:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e76:	05050493          	addi	s1,a0,80
    80002e7a:	08050913          	addi	s2,a0,128
    80002e7e:	a021                	j	80002e86 <itrunc+0x22>
    80002e80:	0491                	addi	s1,s1,4
    80002e82:	01248d63          	beq	s1,s2,80002e9c <itrunc+0x38>
    if(ip->addrs[i]){
    80002e86:	408c                	lw	a1,0(s1)
    80002e88:	dde5                	beqz	a1,80002e80 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e8a:	0009a503          	lw	a0,0(s3)
    80002e8e:	00000097          	auipc	ra,0x0
    80002e92:	90c080e7          	jalr	-1780(ra) # 8000279a <bfree>
      ip->addrs[i] = 0;
    80002e96:	0004a023          	sw	zero,0(s1)
    80002e9a:	b7dd                	j	80002e80 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e9c:	0809a583          	lw	a1,128(s3)
    80002ea0:	e185                	bnez	a1,80002ec0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ea6:	854e                	mv	a0,s3
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	de4080e7          	jalr	-540(ra) # 80002c8c <iupdate>
}
    80002eb0:	70a2                	ld	ra,40(sp)
    80002eb2:	7402                	ld	s0,32(sp)
    80002eb4:	64e2                	ld	s1,24(sp)
    80002eb6:	6942                	ld	s2,16(sp)
    80002eb8:	69a2                	ld	s3,8(sp)
    80002eba:	6a02                	ld	s4,0(sp)
    80002ebc:	6145                	addi	sp,sp,48
    80002ebe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec0:	0009a503          	lw	a0,0(s3)
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	690080e7          	jalr	1680(ra) # 80002554 <bread>
    80002ecc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ece:	05850493          	addi	s1,a0,88
    80002ed2:	45850913          	addi	s2,a0,1112
    80002ed6:	a021                	j	80002ede <itrunc+0x7a>
    80002ed8:	0491                	addi	s1,s1,4
    80002eda:	01248b63          	beq	s1,s2,80002ef0 <itrunc+0x8c>
      if(a[j])
    80002ede:	408c                	lw	a1,0(s1)
    80002ee0:	dde5                	beqz	a1,80002ed8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ee2:	0009a503          	lw	a0,0(s3)
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	8b4080e7          	jalr	-1868(ra) # 8000279a <bfree>
    80002eee:	b7ed                	j	80002ed8 <itrunc+0x74>
    brelse(bp);
    80002ef0:	8552                	mv	a0,s4
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	792080e7          	jalr	1938(ra) # 80002684 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002efa:	0809a583          	lw	a1,128(s3)
    80002efe:	0009a503          	lw	a0,0(s3)
    80002f02:	00000097          	auipc	ra,0x0
    80002f06:	898080e7          	jalr	-1896(ra) # 8000279a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f0a:	0809a023          	sw	zero,128(s3)
    80002f0e:	bf51                	j	80002ea2 <itrunc+0x3e>

0000000080002f10 <iput>:
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	e04a                	sd	s2,0(sp)
    80002f1a:	1000                	addi	s0,sp,32
    80002f1c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f1e:	00015517          	auipc	a0,0x15
    80002f22:	a5a50513          	addi	a0,a0,-1446 # 80017978 <itable>
    80002f26:	00003097          	auipc	ra,0x3
    80002f2a:	3ea080e7          	jalr	1002(ra) # 80006310 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2e:	4498                	lw	a4,8(s1)
    80002f30:	4785                	li	a5,1
    80002f32:	02f70363          	beq	a4,a5,80002f58 <iput+0x48>
  ip->ref--;
    80002f36:	449c                	lw	a5,8(s1)
    80002f38:	37fd                	addiw	a5,a5,-1
    80002f3a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f3c:	00015517          	auipc	a0,0x15
    80002f40:	a3c50513          	addi	a0,a0,-1476 # 80017978 <itable>
    80002f44:	00003097          	auipc	ra,0x3
    80002f48:	480080e7          	jalr	1152(ra) # 800063c4 <release>
}
    80002f4c:	60e2                	ld	ra,24(sp)
    80002f4e:	6442                	ld	s0,16(sp)
    80002f50:	64a2                	ld	s1,8(sp)
    80002f52:	6902                	ld	s2,0(sp)
    80002f54:	6105                	addi	sp,sp,32
    80002f56:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f58:	40bc                	lw	a5,64(s1)
    80002f5a:	dff1                	beqz	a5,80002f36 <iput+0x26>
    80002f5c:	04a49783          	lh	a5,74(s1)
    80002f60:	fbf9                	bnez	a5,80002f36 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f62:	01048913          	addi	s2,s1,16
    80002f66:	854a                	mv	a0,s2
    80002f68:	00001097          	auipc	ra,0x1
    80002f6c:	ab8080e7          	jalr	-1352(ra) # 80003a20 <acquiresleep>
    release(&itable.lock);
    80002f70:	00015517          	auipc	a0,0x15
    80002f74:	a0850513          	addi	a0,a0,-1528 # 80017978 <itable>
    80002f78:	00003097          	auipc	ra,0x3
    80002f7c:	44c080e7          	jalr	1100(ra) # 800063c4 <release>
    itrunc(ip);
    80002f80:	8526                	mv	a0,s1
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	ee2080e7          	jalr	-286(ra) # 80002e64 <itrunc>
    ip->type = 0;
    80002f8a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f8e:	8526                	mv	a0,s1
    80002f90:	00000097          	auipc	ra,0x0
    80002f94:	cfc080e7          	jalr	-772(ra) # 80002c8c <iupdate>
    ip->valid = 0;
    80002f98:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	00001097          	auipc	ra,0x1
    80002fa2:	ad8080e7          	jalr	-1320(ra) # 80003a76 <releasesleep>
    acquire(&itable.lock);
    80002fa6:	00015517          	auipc	a0,0x15
    80002faa:	9d250513          	addi	a0,a0,-1582 # 80017978 <itable>
    80002fae:	00003097          	auipc	ra,0x3
    80002fb2:	362080e7          	jalr	866(ra) # 80006310 <acquire>
    80002fb6:	b741                	j	80002f36 <iput+0x26>

0000000080002fb8 <iunlockput>:
{
    80002fb8:	1101                	addi	sp,sp,-32
    80002fba:	ec06                	sd	ra,24(sp)
    80002fbc:	e822                	sd	s0,16(sp)
    80002fbe:	e426                	sd	s1,8(sp)
    80002fc0:	1000                	addi	s0,sp,32
    80002fc2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	e54080e7          	jalr	-428(ra) # 80002e18 <iunlock>
  iput(ip);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	f42080e7          	jalr	-190(ra) # 80002f10 <iput>
}
    80002fd6:	60e2                	ld	ra,24(sp)
    80002fd8:	6442                	ld	s0,16(sp)
    80002fda:	64a2                	ld	s1,8(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret

0000000080002fe0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe0:	1141                	addi	sp,sp,-16
    80002fe2:	e422                	sd	s0,8(sp)
    80002fe4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fe6:	411c                	lw	a5,0(a0)
    80002fe8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fea:	415c                	lw	a5,4(a0)
    80002fec:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fee:	04451783          	lh	a5,68(a0)
    80002ff2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ff6:	04a51783          	lh	a5,74(a0)
    80002ffa:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ffe:	04c56783          	lwu	a5,76(a0)
    80003002:	e99c                	sd	a5,16(a1)
}
    80003004:	6422                	ld	s0,8(sp)
    80003006:	0141                	addi	sp,sp,16
    80003008:	8082                	ret

000000008000300a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000300a:	457c                	lw	a5,76(a0)
    8000300c:	0ed7e963          	bltu	a5,a3,800030fe <readi+0xf4>
{
    80003010:	7159                	addi	sp,sp,-112
    80003012:	f486                	sd	ra,104(sp)
    80003014:	f0a2                	sd	s0,96(sp)
    80003016:	eca6                	sd	s1,88(sp)
    80003018:	e8ca                	sd	s2,80(sp)
    8000301a:	e4ce                	sd	s3,72(sp)
    8000301c:	e0d2                	sd	s4,64(sp)
    8000301e:	fc56                	sd	s5,56(sp)
    80003020:	f85a                	sd	s6,48(sp)
    80003022:	f45e                	sd	s7,40(sp)
    80003024:	f062                	sd	s8,32(sp)
    80003026:	ec66                	sd	s9,24(sp)
    80003028:	e86a                	sd	s10,16(sp)
    8000302a:	e46e                	sd	s11,8(sp)
    8000302c:	1880                	addi	s0,sp,112
    8000302e:	8baa                	mv	s7,a0
    80003030:	8c2e                	mv	s8,a1
    80003032:	8ab2                	mv	s5,a2
    80003034:	84b6                	mv	s1,a3
    80003036:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003038:	9f35                	addw	a4,a4,a3
    return 0;
    8000303a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000303c:	0ad76063          	bltu	a4,a3,800030dc <readi+0xd2>
  if(off + n > ip->size)
    80003040:	00e7f463          	bgeu	a5,a4,80003048 <readi+0x3e>
    n = ip->size - off;
    80003044:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003048:	0a0b0963          	beqz	s6,800030fa <readi+0xf0>
    8000304c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000304e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003052:	5cfd                	li	s9,-1
    80003054:	a82d                	j	8000308e <readi+0x84>
    80003056:	020a1d93          	slli	s11,s4,0x20
    8000305a:	020ddd93          	srli	s11,s11,0x20
    8000305e:	05890793          	addi	a5,s2,88
    80003062:	86ee                	mv	a3,s11
    80003064:	963e                	add	a2,a2,a5
    80003066:	85d6                	mv	a1,s5
    80003068:	8562                	mv	a0,s8
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	aa2080e7          	jalr	-1374(ra) # 80001b0c <either_copyout>
    80003072:	05950d63          	beq	a0,s9,800030cc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003076:	854a                	mv	a0,s2
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	60c080e7          	jalr	1548(ra) # 80002684 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003080:	013a09bb          	addw	s3,s4,s3
    80003084:	009a04bb          	addw	s1,s4,s1
    80003088:	9aee                	add	s5,s5,s11
    8000308a:	0569f763          	bgeu	s3,s6,800030d8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000308e:	000ba903          	lw	s2,0(s7)
    80003092:	00a4d59b          	srliw	a1,s1,0xa
    80003096:	855e                	mv	a0,s7
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	8b0080e7          	jalr	-1872(ra) # 80002948 <bmap>
    800030a0:	0005059b          	sext.w	a1,a0
    800030a4:	854a                	mv	a0,s2
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	4ae080e7          	jalr	1198(ra) # 80002554 <bread>
    800030ae:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b0:	3ff4f613          	andi	a2,s1,1023
    800030b4:	40cd07bb          	subw	a5,s10,a2
    800030b8:	413b073b          	subw	a4,s6,s3
    800030bc:	8a3e                	mv	s4,a5
    800030be:	2781                	sext.w	a5,a5
    800030c0:	0007069b          	sext.w	a3,a4
    800030c4:	f8f6f9e3          	bgeu	a3,a5,80003056 <readi+0x4c>
    800030c8:	8a3a                	mv	s4,a4
    800030ca:	b771                	j	80003056 <readi+0x4c>
      brelse(bp);
    800030cc:	854a                	mv	a0,s2
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	5b6080e7          	jalr	1462(ra) # 80002684 <brelse>
      tot = -1;
    800030d6:	59fd                	li	s3,-1
  }
  return tot;
    800030d8:	0009851b          	sext.w	a0,s3
}
    800030dc:	70a6                	ld	ra,104(sp)
    800030de:	7406                	ld	s0,96(sp)
    800030e0:	64e6                	ld	s1,88(sp)
    800030e2:	6946                	ld	s2,80(sp)
    800030e4:	69a6                	ld	s3,72(sp)
    800030e6:	6a06                	ld	s4,64(sp)
    800030e8:	7ae2                	ld	s5,56(sp)
    800030ea:	7b42                	ld	s6,48(sp)
    800030ec:	7ba2                	ld	s7,40(sp)
    800030ee:	7c02                	ld	s8,32(sp)
    800030f0:	6ce2                	ld	s9,24(sp)
    800030f2:	6d42                	ld	s10,16(sp)
    800030f4:	6da2                	ld	s11,8(sp)
    800030f6:	6165                	addi	sp,sp,112
    800030f8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030fa:	89da                	mv	s3,s6
    800030fc:	bff1                	j	800030d8 <readi+0xce>
    return 0;
    800030fe:	4501                	li	a0,0
}
    80003100:	8082                	ret

0000000080003102 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003102:	457c                	lw	a5,76(a0)
    80003104:	10d7e863          	bltu	a5,a3,80003214 <writei+0x112>
{
    80003108:	7159                	addi	sp,sp,-112
    8000310a:	f486                	sd	ra,104(sp)
    8000310c:	f0a2                	sd	s0,96(sp)
    8000310e:	eca6                	sd	s1,88(sp)
    80003110:	e8ca                	sd	s2,80(sp)
    80003112:	e4ce                	sd	s3,72(sp)
    80003114:	e0d2                	sd	s4,64(sp)
    80003116:	fc56                	sd	s5,56(sp)
    80003118:	f85a                	sd	s6,48(sp)
    8000311a:	f45e                	sd	s7,40(sp)
    8000311c:	f062                	sd	s8,32(sp)
    8000311e:	ec66                	sd	s9,24(sp)
    80003120:	e86a                	sd	s10,16(sp)
    80003122:	e46e                	sd	s11,8(sp)
    80003124:	1880                	addi	s0,sp,112
    80003126:	8b2a                	mv	s6,a0
    80003128:	8c2e                	mv	s8,a1
    8000312a:	8ab2                	mv	s5,a2
    8000312c:	8936                	mv	s2,a3
    8000312e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003130:	00e687bb          	addw	a5,a3,a4
    80003134:	0ed7e263          	bltu	a5,a3,80003218 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003138:	00043737          	lui	a4,0x43
    8000313c:	0ef76063          	bltu	a4,a5,8000321c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003140:	0c0b8863          	beqz	s7,80003210 <writei+0x10e>
    80003144:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003146:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000314a:	5cfd                	li	s9,-1
    8000314c:	a091                	j	80003190 <writei+0x8e>
    8000314e:	02099d93          	slli	s11,s3,0x20
    80003152:	020ddd93          	srli	s11,s11,0x20
    80003156:	05848793          	addi	a5,s1,88
    8000315a:	86ee                	mv	a3,s11
    8000315c:	8656                	mv	a2,s5
    8000315e:	85e2                	mv	a1,s8
    80003160:	953e                	add	a0,a0,a5
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	a00080e7          	jalr	-1536(ra) # 80001b62 <either_copyin>
    8000316a:	07950263          	beq	a0,s9,800031ce <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000316e:	8526                	mv	a0,s1
    80003170:	00000097          	auipc	ra,0x0
    80003174:	790080e7          	jalr	1936(ra) # 80003900 <log_write>
    brelse(bp);
    80003178:	8526                	mv	a0,s1
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	50a080e7          	jalr	1290(ra) # 80002684 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003182:	01498a3b          	addw	s4,s3,s4
    80003186:	0129893b          	addw	s2,s3,s2
    8000318a:	9aee                	add	s5,s5,s11
    8000318c:	057a7663          	bgeu	s4,s7,800031d8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003190:	000b2483          	lw	s1,0(s6)
    80003194:	00a9559b          	srliw	a1,s2,0xa
    80003198:	855a                	mv	a0,s6
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	7ae080e7          	jalr	1966(ra) # 80002948 <bmap>
    800031a2:	0005059b          	sext.w	a1,a0
    800031a6:	8526                	mv	a0,s1
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	3ac080e7          	jalr	940(ra) # 80002554 <bread>
    800031b0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b2:	3ff97513          	andi	a0,s2,1023
    800031b6:	40ad07bb          	subw	a5,s10,a0
    800031ba:	414b873b          	subw	a4,s7,s4
    800031be:	89be                	mv	s3,a5
    800031c0:	2781                	sext.w	a5,a5
    800031c2:	0007069b          	sext.w	a3,a4
    800031c6:	f8f6f4e3          	bgeu	a3,a5,8000314e <writei+0x4c>
    800031ca:	89ba                	mv	s3,a4
    800031cc:	b749                	j	8000314e <writei+0x4c>
      brelse(bp);
    800031ce:	8526                	mv	a0,s1
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	4b4080e7          	jalr	1204(ra) # 80002684 <brelse>
  }

  if(off > ip->size)
    800031d8:	04cb2783          	lw	a5,76(s6)
    800031dc:	0127f463          	bgeu	a5,s2,800031e4 <writei+0xe2>
    ip->size = off;
    800031e0:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031e4:	855a                	mv	a0,s6
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	aa6080e7          	jalr	-1370(ra) # 80002c8c <iupdate>

  return tot;
    800031ee:	000a051b          	sext.w	a0,s4
}
    800031f2:	70a6                	ld	ra,104(sp)
    800031f4:	7406                	ld	s0,96(sp)
    800031f6:	64e6                	ld	s1,88(sp)
    800031f8:	6946                	ld	s2,80(sp)
    800031fa:	69a6                	ld	s3,72(sp)
    800031fc:	6a06                	ld	s4,64(sp)
    800031fe:	7ae2                	ld	s5,56(sp)
    80003200:	7b42                	ld	s6,48(sp)
    80003202:	7ba2                	ld	s7,40(sp)
    80003204:	7c02                	ld	s8,32(sp)
    80003206:	6ce2                	ld	s9,24(sp)
    80003208:	6d42                	ld	s10,16(sp)
    8000320a:	6da2                	ld	s11,8(sp)
    8000320c:	6165                	addi	sp,sp,112
    8000320e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003210:	8a5e                	mv	s4,s7
    80003212:	bfc9                	j	800031e4 <writei+0xe2>
    return -1;
    80003214:	557d                	li	a0,-1
}
    80003216:	8082                	ret
    return -1;
    80003218:	557d                	li	a0,-1
    8000321a:	bfe1                	j	800031f2 <writei+0xf0>
    return -1;
    8000321c:	557d                	li	a0,-1
    8000321e:	bfd1                	j	800031f2 <writei+0xf0>

0000000080003220 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003220:	1141                	addi	sp,sp,-16
    80003222:	e406                	sd	ra,8(sp)
    80003224:	e022                	sd	s0,0(sp)
    80003226:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003228:	4639                	li	a2,14
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	01e080e7          	jalr	30(ra) # 80000248 <strncmp>
}
    80003232:	60a2                	ld	ra,8(sp)
    80003234:	6402                	ld	s0,0(sp)
    80003236:	0141                	addi	sp,sp,16
    80003238:	8082                	ret

000000008000323a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000323a:	7139                	addi	sp,sp,-64
    8000323c:	fc06                	sd	ra,56(sp)
    8000323e:	f822                	sd	s0,48(sp)
    80003240:	f426                	sd	s1,40(sp)
    80003242:	f04a                	sd	s2,32(sp)
    80003244:	ec4e                	sd	s3,24(sp)
    80003246:	e852                	sd	s4,16(sp)
    80003248:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000324a:	04451703          	lh	a4,68(a0)
    8000324e:	4785                	li	a5,1
    80003250:	00f71a63          	bne	a4,a5,80003264 <dirlookup+0x2a>
    80003254:	892a                	mv	s2,a0
    80003256:	89ae                	mv	s3,a1
    80003258:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325a:	457c                	lw	a5,76(a0)
    8000325c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000325e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003260:	e79d                	bnez	a5,8000328e <dirlookup+0x54>
    80003262:	a8a5                	j	800032da <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003264:	00005517          	auipc	a0,0x5
    80003268:	38450513          	addi	a0,a0,900 # 800085e8 <syscalls+0x1e8>
    8000326c:	00003097          	auipc	ra,0x3
    80003270:	b68080e7          	jalr	-1176(ra) # 80005dd4 <panic>
      panic("dirlookup read");
    80003274:	00005517          	auipc	a0,0x5
    80003278:	38c50513          	addi	a0,a0,908 # 80008600 <syscalls+0x200>
    8000327c:	00003097          	auipc	ra,0x3
    80003280:	b58080e7          	jalr	-1192(ra) # 80005dd4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	24c1                	addiw	s1,s1,16
    80003286:	04c92783          	lw	a5,76(s2)
    8000328a:	04f4f763          	bgeu	s1,a5,800032d8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328e:	4741                	li	a4,16
    80003290:	86a6                	mv	a3,s1
    80003292:	fc040613          	addi	a2,s0,-64
    80003296:	4581                	li	a1,0
    80003298:	854a                	mv	a0,s2
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	d70080e7          	jalr	-656(ra) # 8000300a <readi>
    800032a2:	47c1                	li	a5,16
    800032a4:	fcf518e3          	bne	a0,a5,80003274 <dirlookup+0x3a>
    if(de.inum == 0)
    800032a8:	fc045783          	lhu	a5,-64(s0)
    800032ac:	dfe1                	beqz	a5,80003284 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032ae:	fc240593          	addi	a1,s0,-62
    800032b2:	854e                	mv	a0,s3
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	f6c080e7          	jalr	-148(ra) # 80003220 <namecmp>
    800032bc:	f561                	bnez	a0,80003284 <dirlookup+0x4a>
      if(poff)
    800032be:	000a0463          	beqz	s4,800032c6 <dirlookup+0x8c>
        *poff = off;
    800032c2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032c6:	fc045583          	lhu	a1,-64(s0)
    800032ca:	00092503          	lw	a0,0(s2)
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	754080e7          	jalr	1876(ra) # 80002a22 <iget>
    800032d6:	a011                	j	800032da <dirlookup+0xa0>
  return 0;
    800032d8:	4501                	li	a0,0
}
    800032da:	70e2                	ld	ra,56(sp)
    800032dc:	7442                	ld	s0,48(sp)
    800032de:	74a2                	ld	s1,40(sp)
    800032e0:	7902                	ld	s2,32(sp)
    800032e2:	69e2                	ld	s3,24(sp)
    800032e4:	6a42                	ld	s4,16(sp)
    800032e6:	6121                	addi	sp,sp,64
    800032e8:	8082                	ret

00000000800032ea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032ea:	711d                	addi	sp,sp,-96
    800032ec:	ec86                	sd	ra,88(sp)
    800032ee:	e8a2                	sd	s0,80(sp)
    800032f0:	e4a6                	sd	s1,72(sp)
    800032f2:	e0ca                	sd	s2,64(sp)
    800032f4:	fc4e                	sd	s3,56(sp)
    800032f6:	f852                	sd	s4,48(sp)
    800032f8:	f456                	sd	s5,40(sp)
    800032fa:	f05a                	sd	s6,32(sp)
    800032fc:	ec5e                	sd	s7,24(sp)
    800032fe:	e862                	sd	s8,16(sp)
    80003300:	e466                	sd	s9,8(sp)
    80003302:	1080                	addi	s0,sp,96
    80003304:	84aa                	mv	s1,a0
    80003306:	8aae                	mv	s5,a1
    80003308:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000330a:	00054703          	lbu	a4,0(a0)
    8000330e:	02f00793          	li	a5,47
    80003312:	02f70363          	beq	a4,a5,80003338 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	cdc080e7          	jalr	-804(ra) # 80000ff2 <myproc>
    8000331e:	15053503          	ld	a0,336(a0)
    80003322:	00000097          	auipc	ra,0x0
    80003326:	9f6080e7          	jalr	-1546(ra) # 80002d18 <idup>
    8000332a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000332c:	02f00913          	li	s2,47
  len = path - s;
    80003330:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003332:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003334:	4b85                	li	s7,1
    80003336:	a865                	j	800033ee <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003338:	4585                	li	a1,1
    8000333a:	4505                	li	a0,1
    8000333c:	fffff097          	auipc	ra,0xfffff
    80003340:	6e6080e7          	jalr	1766(ra) # 80002a22 <iget>
    80003344:	89aa                	mv	s3,a0
    80003346:	b7dd                	j	8000332c <namex+0x42>
      iunlockput(ip);
    80003348:	854e                	mv	a0,s3
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	c6e080e7          	jalr	-914(ra) # 80002fb8 <iunlockput>
      return 0;
    80003352:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003354:	854e                	mv	a0,s3
    80003356:	60e6                	ld	ra,88(sp)
    80003358:	6446                	ld	s0,80(sp)
    8000335a:	64a6                	ld	s1,72(sp)
    8000335c:	6906                	ld	s2,64(sp)
    8000335e:	79e2                	ld	s3,56(sp)
    80003360:	7a42                	ld	s4,48(sp)
    80003362:	7aa2                	ld	s5,40(sp)
    80003364:	7b02                	ld	s6,32(sp)
    80003366:	6be2                	ld	s7,24(sp)
    80003368:	6c42                	ld	s8,16(sp)
    8000336a:	6ca2                	ld	s9,8(sp)
    8000336c:	6125                	addi	sp,sp,96
    8000336e:	8082                	ret
      iunlock(ip);
    80003370:	854e                	mv	a0,s3
    80003372:	00000097          	auipc	ra,0x0
    80003376:	aa6080e7          	jalr	-1370(ra) # 80002e18 <iunlock>
      return ip;
    8000337a:	bfe9                	j	80003354 <namex+0x6a>
      iunlockput(ip);
    8000337c:	854e                	mv	a0,s3
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	c3a080e7          	jalr	-966(ra) # 80002fb8 <iunlockput>
      return 0;
    80003386:	89e6                	mv	s3,s9
    80003388:	b7f1                	j	80003354 <namex+0x6a>
  len = path - s;
    8000338a:	40b48633          	sub	a2,s1,a1
    8000338e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003392:	099c5463          	bge	s8,s9,8000341a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003396:	4639                	li	a2,14
    80003398:	8552                	mv	a0,s4
    8000339a:	ffffd097          	auipc	ra,0xffffd
    8000339e:	e3a080e7          	jalr	-454(ra) # 800001d4 <memmove>
  while(*path == '/')
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	01279763          	bne	a5,s2,800033b4 <namex+0xca>
    path++;
    800033aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	ff278de3          	beq	a5,s2,800033aa <namex+0xc0>
    ilock(ip);
    800033b4:	854e                	mv	a0,s3
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	9a0080e7          	jalr	-1632(ra) # 80002d56 <ilock>
    if(ip->type != T_DIR){
    800033be:	04499783          	lh	a5,68(s3)
    800033c2:	f97793e3          	bne	a5,s7,80003348 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033c6:	000a8563          	beqz	s5,800033d0 <namex+0xe6>
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	d3cd                	beqz	a5,80003370 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033d0:	865a                	mv	a2,s6
    800033d2:	85d2                	mv	a1,s4
    800033d4:	854e                	mv	a0,s3
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	e64080e7          	jalr	-412(ra) # 8000323a <dirlookup>
    800033de:	8caa                	mv	s9,a0
    800033e0:	dd51                	beqz	a0,8000337c <namex+0x92>
    iunlockput(ip);
    800033e2:	854e                	mv	a0,s3
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	bd4080e7          	jalr	-1068(ra) # 80002fb8 <iunlockput>
    ip = next;
    800033ec:	89e6                	mv	s3,s9
  while(*path == '/')
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	05279763          	bne	a5,s2,80003440 <namex+0x156>
    path++;
    800033f6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033f8:	0004c783          	lbu	a5,0(s1)
    800033fc:	ff278de3          	beq	a5,s2,800033f6 <namex+0x10c>
  if(*path == 0)
    80003400:	c79d                	beqz	a5,8000342e <namex+0x144>
    path++;
    80003402:	85a6                	mv	a1,s1
  len = path - s;
    80003404:	8cda                	mv	s9,s6
    80003406:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003408:	01278963          	beq	a5,s2,8000341a <namex+0x130>
    8000340c:	dfbd                	beqz	a5,8000338a <namex+0xa0>
    path++;
    8000340e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003410:	0004c783          	lbu	a5,0(s1)
    80003414:	ff279ce3          	bne	a5,s2,8000340c <namex+0x122>
    80003418:	bf8d                	j	8000338a <namex+0xa0>
    memmove(name, s, len);
    8000341a:	2601                	sext.w	a2,a2
    8000341c:	8552                	mv	a0,s4
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	db6080e7          	jalr	-586(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003426:	9cd2                	add	s9,s9,s4
    80003428:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000342c:	bf9d                	j	800033a2 <namex+0xb8>
  if(nameiparent){
    8000342e:	f20a83e3          	beqz	s5,80003354 <namex+0x6a>
    iput(ip);
    80003432:	854e                	mv	a0,s3
    80003434:	00000097          	auipc	ra,0x0
    80003438:	adc080e7          	jalr	-1316(ra) # 80002f10 <iput>
    return 0;
    8000343c:	4981                	li	s3,0
    8000343e:	bf19                	j	80003354 <namex+0x6a>
  if(*path == 0)
    80003440:	d7fd                	beqz	a5,8000342e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	85a6                	mv	a1,s1
    80003448:	b7d1                	j	8000340c <namex+0x122>

000000008000344a <dirlink>:
{
    8000344a:	7139                	addi	sp,sp,-64
    8000344c:	fc06                	sd	ra,56(sp)
    8000344e:	f822                	sd	s0,48(sp)
    80003450:	f426                	sd	s1,40(sp)
    80003452:	f04a                	sd	s2,32(sp)
    80003454:	ec4e                	sd	s3,24(sp)
    80003456:	e852                	sd	s4,16(sp)
    80003458:	0080                	addi	s0,sp,64
    8000345a:	892a                	mv	s2,a0
    8000345c:	8a2e                	mv	s4,a1
    8000345e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003460:	4601                	li	a2,0
    80003462:	00000097          	auipc	ra,0x0
    80003466:	dd8080e7          	jalr	-552(ra) # 8000323a <dirlookup>
    8000346a:	e93d                	bnez	a0,800034e0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000346c:	04c92483          	lw	s1,76(s2)
    80003470:	c49d                	beqz	s1,8000349e <dirlink+0x54>
    80003472:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003474:	4741                	li	a4,16
    80003476:	86a6                	mv	a3,s1
    80003478:	fc040613          	addi	a2,s0,-64
    8000347c:	4581                	li	a1,0
    8000347e:	854a                	mv	a0,s2
    80003480:	00000097          	auipc	ra,0x0
    80003484:	b8a080e7          	jalr	-1142(ra) # 8000300a <readi>
    80003488:	47c1                	li	a5,16
    8000348a:	06f51163          	bne	a0,a5,800034ec <dirlink+0xa2>
    if(de.inum == 0)
    8000348e:	fc045783          	lhu	a5,-64(s0)
    80003492:	c791                	beqz	a5,8000349e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003494:	24c1                	addiw	s1,s1,16
    80003496:	04c92783          	lw	a5,76(s2)
    8000349a:	fcf4ede3          	bltu	s1,a5,80003474 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000349e:	4639                	li	a2,14
    800034a0:	85d2                	mv	a1,s4
    800034a2:	fc240513          	addi	a0,s0,-62
    800034a6:	ffffd097          	auipc	ra,0xffffd
    800034aa:	dde080e7          	jalr	-546(ra) # 80000284 <strncpy>
  de.inum = inum;
    800034ae:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b2:	4741                	li	a4,16
    800034b4:	86a6                	mv	a3,s1
    800034b6:	fc040613          	addi	a2,s0,-64
    800034ba:	4581                	li	a1,0
    800034bc:	854a                	mv	a0,s2
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	c44080e7          	jalr	-956(ra) # 80003102 <writei>
    800034c6:	872a                	mv	a4,a0
    800034c8:	47c1                	li	a5,16
  return 0;
    800034ca:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034cc:	02f71863          	bne	a4,a5,800034fc <dirlink+0xb2>
}
    800034d0:	70e2                	ld	ra,56(sp)
    800034d2:	7442                	ld	s0,48(sp)
    800034d4:	74a2                	ld	s1,40(sp)
    800034d6:	7902                	ld	s2,32(sp)
    800034d8:	69e2                	ld	s3,24(sp)
    800034da:	6a42                	ld	s4,16(sp)
    800034dc:	6121                	addi	sp,sp,64
    800034de:	8082                	ret
    iput(ip);
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	a30080e7          	jalr	-1488(ra) # 80002f10 <iput>
    return -1;
    800034e8:	557d                	li	a0,-1
    800034ea:	b7dd                	j	800034d0 <dirlink+0x86>
      panic("dirlink read");
    800034ec:	00005517          	auipc	a0,0x5
    800034f0:	12450513          	addi	a0,a0,292 # 80008610 <syscalls+0x210>
    800034f4:	00003097          	auipc	ra,0x3
    800034f8:	8e0080e7          	jalr	-1824(ra) # 80005dd4 <panic>
    panic("dirlink");
    800034fc:	00005517          	auipc	a0,0x5
    80003500:	21c50513          	addi	a0,a0,540 # 80008718 <syscalls+0x318>
    80003504:	00003097          	auipc	ra,0x3
    80003508:	8d0080e7          	jalr	-1840(ra) # 80005dd4 <panic>

000000008000350c <namei>:

struct inode*
namei(char *path)
{
    8000350c:	1101                	addi	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003514:	fe040613          	addi	a2,s0,-32
    80003518:	4581                	li	a1,0
    8000351a:	00000097          	auipc	ra,0x0
    8000351e:	dd0080e7          	jalr	-560(ra) # 800032ea <namex>
}
    80003522:	60e2                	ld	ra,24(sp)
    80003524:	6442                	ld	s0,16(sp)
    80003526:	6105                	addi	sp,sp,32
    80003528:	8082                	ret

000000008000352a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000352a:	1141                	addi	sp,sp,-16
    8000352c:	e406                	sd	ra,8(sp)
    8000352e:	e022                	sd	s0,0(sp)
    80003530:	0800                	addi	s0,sp,16
    80003532:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003534:	4585                	li	a1,1
    80003536:	00000097          	auipc	ra,0x0
    8000353a:	db4080e7          	jalr	-588(ra) # 800032ea <namex>
}
    8000353e:	60a2                	ld	ra,8(sp)
    80003540:	6402                	ld	s0,0(sp)
    80003542:	0141                	addi	sp,sp,16
    80003544:	8082                	ret

0000000080003546 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003546:	1101                	addi	sp,sp,-32
    80003548:	ec06                	sd	ra,24(sp)
    8000354a:	e822                	sd	s0,16(sp)
    8000354c:	e426                	sd	s1,8(sp)
    8000354e:	e04a                	sd	s2,0(sp)
    80003550:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003552:	00016917          	auipc	s2,0x16
    80003556:	ece90913          	addi	s2,s2,-306 # 80019420 <log>
    8000355a:	01892583          	lw	a1,24(s2)
    8000355e:	02892503          	lw	a0,40(s2)
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	ff2080e7          	jalr	-14(ra) # 80002554 <bread>
    8000356a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000356c:	02c92683          	lw	a3,44(s2)
    80003570:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003572:	02d05763          	blez	a3,800035a0 <write_head+0x5a>
    80003576:	00016797          	auipc	a5,0x16
    8000357a:	eda78793          	addi	a5,a5,-294 # 80019450 <log+0x30>
    8000357e:	05c50713          	addi	a4,a0,92
    80003582:	36fd                	addiw	a3,a3,-1
    80003584:	1682                	slli	a3,a3,0x20
    80003586:	9281                	srli	a3,a3,0x20
    80003588:	068a                	slli	a3,a3,0x2
    8000358a:	00016617          	auipc	a2,0x16
    8000358e:	eca60613          	addi	a2,a2,-310 # 80019454 <log+0x34>
    80003592:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003594:	4390                	lw	a2,0(a5)
    80003596:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003598:	0791                	addi	a5,a5,4
    8000359a:	0711                	addi	a4,a4,4
    8000359c:	fed79ce3          	bne	a5,a3,80003594 <write_head+0x4e>
  }
  bwrite(buf);
    800035a0:	8526                	mv	a0,s1
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	0a4080e7          	jalr	164(ra) # 80002646 <bwrite>
  brelse(buf);
    800035aa:	8526                	mv	a0,s1
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	0d8080e7          	jalr	216(ra) # 80002684 <brelse>
}
    800035b4:	60e2                	ld	ra,24(sp)
    800035b6:	6442                	ld	s0,16(sp)
    800035b8:	64a2                	ld	s1,8(sp)
    800035ba:	6902                	ld	s2,0(sp)
    800035bc:	6105                	addi	sp,sp,32
    800035be:	8082                	ret

00000000800035c0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c0:	00016797          	auipc	a5,0x16
    800035c4:	e8c7a783          	lw	a5,-372(a5) # 8001944c <log+0x2c>
    800035c8:	0af05d63          	blez	a5,80003682 <install_trans+0xc2>
{
    800035cc:	7139                	addi	sp,sp,-64
    800035ce:	fc06                	sd	ra,56(sp)
    800035d0:	f822                	sd	s0,48(sp)
    800035d2:	f426                	sd	s1,40(sp)
    800035d4:	f04a                	sd	s2,32(sp)
    800035d6:	ec4e                	sd	s3,24(sp)
    800035d8:	e852                	sd	s4,16(sp)
    800035da:	e456                	sd	s5,8(sp)
    800035dc:	e05a                	sd	s6,0(sp)
    800035de:	0080                	addi	s0,sp,64
    800035e0:	8b2a                	mv	s6,a0
    800035e2:	00016a97          	auipc	s5,0x16
    800035e6:	e6ea8a93          	addi	s5,s5,-402 # 80019450 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ea:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035ec:	00016997          	auipc	s3,0x16
    800035f0:	e3498993          	addi	s3,s3,-460 # 80019420 <log>
    800035f4:	a00d                	j	80003616 <install_trans+0x56>
    brelse(lbuf);
    800035f6:	854a                	mv	a0,s2
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	08c080e7          	jalr	140(ra) # 80002684 <brelse>
    brelse(dbuf);
    80003600:	8526                	mv	a0,s1
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	082080e7          	jalr	130(ra) # 80002684 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360a:	2a05                	addiw	s4,s4,1
    8000360c:	0a91                	addi	s5,s5,4
    8000360e:	02c9a783          	lw	a5,44(s3)
    80003612:	04fa5e63          	bge	s4,a5,8000366e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003616:	0189a583          	lw	a1,24(s3)
    8000361a:	014585bb          	addw	a1,a1,s4
    8000361e:	2585                	addiw	a1,a1,1
    80003620:	0289a503          	lw	a0,40(s3)
    80003624:	fffff097          	auipc	ra,0xfffff
    80003628:	f30080e7          	jalr	-208(ra) # 80002554 <bread>
    8000362c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000362e:	000aa583          	lw	a1,0(s5)
    80003632:	0289a503          	lw	a0,40(s3)
    80003636:	fffff097          	auipc	ra,0xfffff
    8000363a:	f1e080e7          	jalr	-226(ra) # 80002554 <bread>
    8000363e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003640:	40000613          	li	a2,1024
    80003644:	05890593          	addi	a1,s2,88
    80003648:	05850513          	addi	a0,a0,88
    8000364c:	ffffd097          	auipc	ra,0xffffd
    80003650:	b88080e7          	jalr	-1144(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003654:	8526                	mv	a0,s1
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	ff0080e7          	jalr	-16(ra) # 80002646 <bwrite>
    if(recovering == 0)
    8000365e:	f80b1ce3          	bnez	s6,800035f6 <install_trans+0x36>
      bunpin(dbuf);
    80003662:	8526                	mv	a0,s1
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	0fa080e7          	jalr	250(ra) # 8000275e <bunpin>
    8000366c:	b769                	j	800035f6 <install_trans+0x36>
}
    8000366e:	70e2                	ld	ra,56(sp)
    80003670:	7442                	ld	s0,48(sp)
    80003672:	74a2                	ld	s1,40(sp)
    80003674:	7902                	ld	s2,32(sp)
    80003676:	69e2                	ld	s3,24(sp)
    80003678:	6a42                	ld	s4,16(sp)
    8000367a:	6aa2                	ld	s5,8(sp)
    8000367c:	6b02                	ld	s6,0(sp)
    8000367e:	6121                	addi	sp,sp,64
    80003680:	8082                	ret
    80003682:	8082                	ret

0000000080003684 <initlog>:
{
    80003684:	7179                	addi	sp,sp,-48
    80003686:	f406                	sd	ra,40(sp)
    80003688:	f022                	sd	s0,32(sp)
    8000368a:	ec26                	sd	s1,24(sp)
    8000368c:	e84a                	sd	s2,16(sp)
    8000368e:	e44e                	sd	s3,8(sp)
    80003690:	1800                	addi	s0,sp,48
    80003692:	892a                	mv	s2,a0
    80003694:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003696:	00016497          	auipc	s1,0x16
    8000369a:	d8a48493          	addi	s1,s1,-630 # 80019420 <log>
    8000369e:	00005597          	auipc	a1,0x5
    800036a2:	f8258593          	addi	a1,a1,-126 # 80008620 <syscalls+0x220>
    800036a6:	8526                	mv	a0,s1
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	bd8080e7          	jalr	-1064(ra) # 80006280 <initlock>
  log.start = sb->logstart;
    800036b0:	0149a583          	lw	a1,20(s3)
    800036b4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036b6:	0109a783          	lw	a5,16(s3)
    800036ba:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036bc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036c0:	854a                	mv	a0,s2
    800036c2:	fffff097          	auipc	ra,0xfffff
    800036c6:	e92080e7          	jalr	-366(ra) # 80002554 <bread>
  log.lh.n = lh->n;
    800036ca:	4d34                	lw	a3,88(a0)
    800036cc:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036ce:	02d05563          	blez	a3,800036f8 <initlog+0x74>
    800036d2:	05c50793          	addi	a5,a0,92
    800036d6:	00016717          	auipc	a4,0x16
    800036da:	d7a70713          	addi	a4,a4,-646 # 80019450 <log+0x30>
    800036de:	36fd                	addiw	a3,a3,-1
    800036e0:	1682                	slli	a3,a3,0x20
    800036e2:	9281                	srli	a3,a3,0x20
    800036e4:	068a                	slli	a3,a3,0x2
    800036e6:	06050613          	addi	a2,a0,96
    800036ea:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036ec:	4390                	lw	a2,0(a5)
    800036ee:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036f0:	0791                	addi	a5,a5,4
    800036f2:	0711                	addi	a4,a4,4
    800036f4:	fed79ce3          	bne	a5,a3,800036ec <initlog+0x68>
  brelse(buf);
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	f8c080e7          	jalr	-116(ra) # 80002684 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003700:	4505                	li	a0,1
    80003702:	00000097          	auipc	ra,0x0
    80003706:	ebe080e7          	jalr	-322(ra) # 800035c0 <install_trans>
  log.lh.n = 0;
    8000370a:	00016797          	auipc	a5,0x16
    8000370e:	d407a123          	sw	zero,-702(a5) # 8001944c <log+0x2c>
  write_head(); // clear the log
    80003712:	00000097          	auipc	ra,0x0
    80003716:	e34080e7          	jalr	-460(ra) # 80003546 <write_head>
}
    8000371a:	70a2                	ld	ra,40(sp)
    8000371c:	7402                	ld	s0,32(sp)
    8000371e:	64e2                	ld	s1,24(sp)
    80003720:	6942                	ld	s2,16(sp)
    80003722:	69a2                	ld	s3,8(sp)
    80003724:	6145                	addi	sp,sp,48
    80003726:	8082                	ret

0000000080003728 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003728:	1101                	addi	sp,sp,-32
    8000372a:	ec06                	sd	ra,24(sp)
    8000372c:	e822                	sd	s0,16(sp)
    8000372e:	e426                	sd	s1,8(sp)
    80003730:	e04a                	sd	s2,0(sp)
    80003732:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003734:	00016517          	auipc	a0,0x16
    80003738:	cec50513          	addi	a0,a0,-788 # 80019420 <log>
    8000373c:	00003097          	auipc	ra,0x3
    80003740:	bd4080e7          	jalr	-1068(ra) # 80006310 <acquire>
  while(1){
    if(log.committing){
    80003744:	00016497          	auipc	s1,0x16
    80003748:	cdc48493          	addi	s1,s1,-804 # 80019420 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000374c:	4979                	li	s2,30
    8000374e:	a039                	j	8000375c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003750:	85a6                	mv	a1,s1
    80003752:	8526                	mv	a0,s1
    80003754:	ffffe097          	auipc	ra,0xffffe
    80003758:	014080e7          	jalr	20(ra) # 80001768 <sleep>
    if(log.committing){
    8000375c:	50dc                	lw	a5,36(s1)
    8000375e:	fbed                	bnez	a5,80003750 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003760:	509c                	lw	a5,32(s1)
    80003762:	0017871b          	addiw	a4,a5,1
    80003766:	0007069b          	sext.w	a3,a4
    8000376a:	0027179b          	slliw	a5,a4,0x2
    8000376e:	9fb9                	addw	a5,a5,a4
    80003770:	0017979b          	slliw	a5,a5,0x1
    80003774:	54d8                	lw	a4,44(s1)
    80003776:	9fb9                	addw	a5,a5,a4
    80003778:	00f95963          	bge	s2,a5,8000378a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000377c:	85a6                	mv	a1,s1
    8000377e:	8526                	mv	a0,s1
    80003780:	ffffe097          	auipc	ra,0xffffe
    80003784:	fe8080e7          	jalr	-24(ra) # 80001768 <sleep>
    80003788:	bfd1                	j	8000375c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000378a:	00016517          	auipc	a0,0x16
    8000378e:	c9650513          	addi	a0,a0,-874 # 80019420 <log>
    80003792:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003794:	00003097          	auipc	ra,0x3
    80003798:	c30080e7          	jalr	-976(ra) # 800063c4 <release>
      break;
    }
  }
}
    8000379c:	60e2                	ld	ra,24(sp)
    8000379e:	6442                	ld	s0,16(sp)
    800037a0:	64a2                	ld	s1,8(sp)
    800037a2:	6902                	ld	s2,0(sp)
    800037a4:	6105                	addi	sp,sp,32
    800037a6:	8082                	ret

00000000800037a8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037a8:	7139                	addi	sp,sp,-64
    800037aa:	fc06                	sd	ra,56(sp)
    800037ac:	f822                	sd	s0,48(sp)
    800037ae:	f426                	sd	s1,40(sp)
    800037b0:	f04a                	sd	s2,32(sp)
    800037b2:	ec4e                	sd	s3,24(sp)
    800037b4:	e852                	sd	s4,16(sp)
    800037b6:	e456                	sd	s5,8(sp)
    800037b8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037ba:	00016497          	auipc	s1,0x16
    800037be:	c6648493          	addi	s1,s1,-922 # 80019420 <log>
    800037c2:	8526                	mv	a0,s1
    800037c4:	00003097          	auipc	ra,0x3
    800037c8:	b4c080e7          	jalr	-1204(ra) # 80006310 <acquire>
  log.outstanding -= 1;
    800037cc:	509c                	lw	a5,32(s1)
    800037ce:	37fd                	addiw	a5,a5,-1
    800037d0:	0007891b          	sext.w	s2,a5
    800037d4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037d6:	50dc                	lw	a5,36(s1)
    800037d8:	e7b9                	bnez	a5,80003826 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037da:	04091e63          	bnez	s2,80003836 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037de:	00016497          	auipc	s1,0x16
    800037e2:	c4248493          	addi	s1,s1,-958 # 80019420 <log>
    800037e6:	4785                	li	a5,1
    800037e8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037ea:	8526                	mv	a0,s1
    800037ec:	00003097          	auipc	ra,0x3
    800037f0:	bd8080e7          	jalr	-1064(ra) # 800063c4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037f4:	54dc                	lw	a5,44(s1)
    800037f6:	06f04763          	bgtz	a5,80003864 <end_op+0xbc>
    acquire(&log.lock);
    800037fa:	00016497          	auipc	s1,0x16
    800037fe:	c2648493          	addi	s1,s1,-986 # 80019420 <log>
    80003802:	8526                	mv	a0,s1
    80003804:	00003097          	auipc	ra,0x3
    80003808:	b0c080e7          	jalr	-1268(ra) # 80006310 <acquire>
    log.committing = 0;
    8000380c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003810:	8526                	mv	a0,s1
    80003812:	ffffe097          	auipc	ra,0xffffe
    80003816:	0e2080e7          	jalr	226(ra) # 800018f4 <wakeup>
    release(&log.lock);
    8000381a:	8526                	mv	a0,s1
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	ba8080e7          	jalr	-1112(ra) # 800063c4 <release>
}
    80003824:	a03d                	j	80003852 <end_op+0xaa>
    panic("log.committing");
    80003826:	00005517          	auipc	a0,0x5
    8000382a:	e0250513          	addi	a0,a0,-510 # 80008628 <syscalls+0x228>
    8000382e:	00002097          	auipc	ra,0x2
    80003832:	5a6080e7          	jalr	1446(ra) # 80005dd4 <panic>
    wakeup(&log);
    80003836:	00016497          	auipc	s1,0x16
    8000383a:	bea48493          	addi	s1,s1,-1046 # 80019420 <log>
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	0b4080e7          	jalr	180(ra) # 800018f4 <wakeup>
  release(&log.lock);
    80003848:	8526                	mv	a0,s1
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	b7a080e7          	jalr	-1158(ra) # 800063c4 <release>
}
    80003852:	70e2                	ld	ra,56(sp)
    80003854:	7442                	ld	s0,48(sp)
    80003856:	74a2                	ld	s1,40(sp)
    80003858:	7902                	ld	s2,32(sp)
    8000385a:	69e2                	ld	s3,24(sp)
    8000385c:	6a42                	ld	s4,16(sp)
    8000385e:	6aa2                	ld	s5,8(sp)
    80003860:	6121                	addi	sp,sp,64
    80003862:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003864:	00016a97          	auipc	s5,0x16
    80003868:	beca8a93          	addi	s5,s5,-1044 # 80019450 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000386c:	00016a17          	auipc	s4,0x16
    80003870:	bb4a0a13          	addi	s4,s4,-1100 # 80019420 <log>
    80003874:	018a2583          	lw	a1,24(s4)
    80003878:	012585bb          	addw	a1,a1,s2
    8000387c:	2585                	addiw	a1,a1,1
    8000387e:	028a2503          	lw	a0,40(s4)
    80003882:	fffff097          	auipc	ra,0xfffff
    80003886:	cd2080e7          	jalr	-814(ra) # 80002554 <bread>
    8000388a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000388c:	000aa583          	lw	a1,0(s5)
    80003890:	028a2503          	lw	a0,40(s4)
    80003894:	fffff097          	auipc	ra,0xfffff
    80003898:	cc0080e7          	jalr	-832(ra) # 80002554 <bread>
    8000389c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000389e:	40000613          	li	a2,1024
    800038a2:	05850593          	addi	a1,a0,88
    800038a6:	05848513          	addi	a0,s1,88
    800038aa:	ffffd097          	auipc	ra,0xffffd
    800038ae:	92a080e7          	jalr	-1750(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800038b2:	8526                	mv	a0,s1
    800038b4:	fffff097          	auipc	ra,0xfffff
    800038b8:	d92080e7          	jalr	-622(ra) # 80002646 <bwrite>
    brelse(from);
    800038bc:	854e                	mv	a0,s3
    800038be:	fffff097          	auipc	ra,0xfffff
    800038c2:	dc6080e7          	jalr	-570(ra) # 80002684 <brelse>
    brelse(to);
    800038c6:	8526                	mv	a0,s1
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	dbc080e7          	jalr	-580(ra) # 80002684 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038d0:	2905                	addiw	s2,s2,1
    800038d2:	0a91                	addi	s5,s5,4
    800038d4:	02ca2783          	lw	a5,44(s4)
    800038d8:	f8f94ee3          	blt	s2,a5,80003874 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038dc:	00000097          	auipc	ra,0x0
    800038e0:	c6a080e7          	jalr	-918(ra) # 80003546 <write_head>
    install_trans(0); // Now install writes to home locations
    800038e4:	4501                	li	a0,0
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	cda080e7          	jalr	-806(ra) # 800035c0 <install_trans>
    log.lh.n = 0;
    800038ee:	00016797          	auipc	a5,0x16
    800038f2:	b407af23          	sw	zero,-1186(a5) # 8001944c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038f6:	00000097          	auipc	ra,0x0
    800038fa:	c50080e7          	jalr	-944(ra) # 80003546 <write_head>
    800038fe:	bdf5                	j	800037fa <end_op+0x52>

0000000080003900 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	e04a                	sd	s2,0(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000390e:	00016917          	auipc	s2,0x16
    80003912:	b1290913          	addi	s2,s2,-1262 # 80019420 <log>
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	9f8080e7          	jalr	-1544(ra) # 80006310 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003920:	02c92603          	lw	a2,44(s2)
    80003924:	47f5                	li	a5,29
    80003926:	06c7c563          	blt	a5,a2,80003990 <log_write+0x90>
    8000392a:	00016797          	auipc	a5,0x16
    8000392e:	b127a783          	lw	a5,-1262(a5) # 8001943c <log+0x1c>
    80003932:	37fd                	addiw	a5,a5,-1
    80003934:	04f65e63          	bge	a2,a5,80003990 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003938:	00016797          	auipc	a5,0x16
    8000393c:	b087a783          	lw	a5,-1272(a5) # 80019440 <log+0x20>
    80003940:	06f05063          	blez	a5,800039a0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003944:	4781                	li	a5,0
    80003946:	06c05563          	blez	a2,800039b0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000394a:	44cc                	lw	a1,12(s1)
    8000394c:	00016717          	auipc	a4,0x16
    80003950:	b0470713          	addi	a4,a4,-1276 # 80019450 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003954:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003956:	4314                	lw	a3,0(a4)
    80003958:	04b68c63          	beq	a3,a1,800039b0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	0711                	addi	a4,a4,4
    80003960:	fef61be3          	bne	a2,a5,80003956 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003964:	0621                	addi	a2,a2,8
    80003966:	060a                	slli	a2,a2,0x2
    80003968:	00016797          	auipc	a5,0x16
    8000396c:	ab878793          	addi	a5,a5,-1352 # 80019420 <log>
    80003970:	963e                	add	a2,a2,a5
    80003972:	44dc                	lw	a5,12(s1)
    80003974:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003976:	8526                	mv	a0,s1
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	daa080e7          	jalr	-598(ra) # 80002722 <bpin>
    log.lh.n++;
    80003980:	00016717          	auipc	a4,0x16
    80003984:	aa070713          	addi	a4,a4,-1376 # 80019420 <log>
    80003988:	575c                	lw	a5,44(a4)
    8000398a:	2785                	addiw	a5,a5,1
    8000398c:	d75c                	sw	a5,44(a4)
    8000398e:	a835                	j	800039ca <log_write+0xca>
    panic("too big a transaction");
    80003990:	00005517          	auipc	a0,0x5
    80003994:	ca850513          	addi	a0,a0,-856 # 80008638 <syscalls+0x238>
    80003998:	00002097          	auipc	ra,0x2
    8000399c:	43c080e7          	jalr	1084(ra) # 80005dd4 <panic>
    panic("log_write outside of trans");
    800039a0:	00005517          	auipc	a0,0x5
    800039a4:	cb050513          	addi	a0,a0,-848 # 80008650 <syscalls+0x250>
    800039a8:	00002097          	auipc	ra,0x2
    800039ac:	42c080e7          	jalr	1068(ra) # 80005dd4 <panic>
  log.lh.block[i] = b->blockno;
    800039b0:	00878713          	addi	a4,a5,8
    800039b4:	00271693          	slli	a3,a4,0x2
    800039b8:	00016717          	auipc	a4,0x16
    800039bc:	a6870713          	addi	a4,a4,-1432 # 80019420 <log>
    800039c0:	9736                	add	a4,a4,a3
    800039c2:	44d4                	lw	a3,12(s1)
    800039c4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039c6:	faf608e3          	beq	a2,a5,80003976 <log_write+0x76>
  }
  release(&log.lock);
    800039ca:	00016517          	auipc	a0,0x16
    800039ce:	a5650513          	addi	a0,a0,-1450 # 80019420 <log>
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	9f2080e7          	jalr	-1550(ra) # 800063c4 <release>
}
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6902                	ld	s2,0(sp)
    800039e2:	6105                	addi	sp,sp,32
    800039e4:	8082                	ret

00000000800039e6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039e6:	1101                	addi	sp,sp,-32
    800039e8:	ec06                	sd	ra,24(sp)
    800039ea:	e822                	sd	s0,16(sp)
    800039ec:	e426                	sd	s1,8(sp)
    800039ee:	e04a                	sd	s2,0(sp)
    800039f0:	1000                	addi	s0,sp,32
    800039f2:	84aa                	mv	s1,a0
    800039f4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039f6:	00005597          	auipc	a1,0x5
    800039fa:	c7a58593          	addi	a1,a1,-902 # 80008670 <syscalls+0x270>
    800039fe:	0521                	addi	a0,a0,8
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	880080e7          	jalr	-1920(ra) # 80006280 <initlock>
  lk->name = name;
    80003a08:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a0c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a10:	0204a423          	sw	zero,40(s1)
}
    80003a14:	60e2                	ld	ra,24(sp)
    80003a16:	6442                	ld	s0,16(sp)
    80003a18:	64a2                	ld	s1,8(sp)
    80003a1a:	6902                	ld	s2,0(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a20:	1101                	addi	sp,sp,-32
    80003a22:	ec06                	sd	ra,24(sp)
    80003a24:	e822                	sd	s0,16(sp)
    80003a26:	e426                	sd	s1,8(sp)
    80003a28:	e04a                	sd	s2,0(sp)
    80003a2a:	1000                	addi	s0,sp,32
    80003a2c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a2e:	00850913          	addi	s2,a0,8
    80003a32:	854a                	mv	a0,s2
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	8dc080e7          	jalr	-1828(ra) # 80006310 <acquire>
  while (lk->locked) {
    80003a3c:	409c                	lw	a5,0(s1)
    80003a3e:	cb89                	beqz	a5,80003a50 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a40:	85ca                	mv	a1,s2
    80003a42:	8526                	mv	a0,s1
    80003a44:	ffffe097          	auipc	ra,0xffffe
    80003a48:	d24080e7          	jalr	-732(ra) # 80001768 <sleep>
  while (lk->locked) {
    80003a4c:	409c                	lw	a5,0(s1)
    80003a4e:	fbed                	bnez	a5,80003a40 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a50:	4785                	li	a5,1
    80003a52:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a54:	ffffd097          	auipc	ra,0xffffd
    80003a58:	59e080e7          	jalr	1438(ra) # 80000ff2 <myproc>
    80003a5c:	591c                	lw	a5,48(a0)
    80003a5e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	962080e7          	jalr	-1694(ra) # 800063c4 <release>
}
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6902                	ld	s2,0(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a76:	1101                	addi	sp,sp,-32
    80003a78:	ec06                	sd	ra,24(sp)
    80003a7a:	e822                	sd	s0,16(sp)
    80003a7c:	e426                	sd	s1,8(sp)
    80003a7e:	e04a                	sd	s2,0(sp)
    80003a80:	1000                	addi	s0,sp,32
    80003a82:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a84:	00850913          	addi	s2,a0,8
    80003a88:	854a                	mv	a0,s2
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	886080e7          	jalr	-1914(ra) # 80006310 <acquire>
  lk->locked = 0;
    80003a92:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a96:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a9a:	8526                	mv	a0,s1
    80003a9c:	ffffe097          	auipc	ra,0xffffe
    80003aa0:	e58080e7          	jalr	-424(ra) # 800018f4 <wakeup>
  release(&lk->lk);
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	00003097          	auipc	ra,0x3
    80003aaa:	91e080e7          	jalr	-1762(ra) # 800063c4 <release>
}
    80003aae:	60e2                	ld	ra,24(sp)
    80003ab0:	6442                	ld	s0,16(sp)
    80003ab2:	64a2                	ld	s1,8(sp)
    80003ab4:	6902                	ld	s2,0(sp)
    80003ab6:	6105                	addi	sp,sp,32
    80003ab8:	8082                	ret

0000000080003aba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aba:	7179                	addi	sp,sp,-48
    80003abc:	f406                	sd	ra,40(sp)
    80003abe:	f022                	sd	s0,32(sp)
    80003ac0:	ec26                	sd	s1,24(sp)
    80003ac2:	e84a                	sd	s2,16(sp)
    80003ac4:	e44e                	sd	s3,8(sp)
    80003ac6:	1800                	addi	s0,sp,48
    80003ac8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aca:	00850913          	addi	s2,a0,8
    80003ace:	854a                	mv	a0,s2
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	840080e7          	jalr	-1984(ra) # 80006310 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ad8:	409c                	lw	a5,0(s1)
    80003ada:	ef99                	bnez	a5,80003af8 <holdingsleep+0x3e>
    80003adc:	4481                	li	s1,0
  release(&lk->lk);
    80003ade:	854a                	mv	a0,s2
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	8e4080e7          	jalr	-1820(ra) # 800063c4 <release>
  return r;
}
    80003ae8:	8526                	mv	a0,s1
    80003aea:	70a2                	ld	ra,40(sp)
    80003aec:	7402                	ld	s0,32(sp)
    80003aee:	64e2                	ld	s1,24(sp)
    80003af0:	6942                	ld	s2,16(sp)
    80003af2:	69a2                	ld	s3,8(sp)
    80003af4:	6145                	addi	sp,sp,48
    80003af6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003af8:	0284a983          	lw	s3,40(s1)
    80003afc:	ffffd097          	auipc	ra,0xffffd
    80003b00:	4f6080e7          	jalr	1270(ra) # 80000ff2 <myproc>
    80003b04:	5904                	lw	s1,48(a0)
    80003b06:	413484b3          	sub	s1,s1,s3
    80003b0a:	0014b493          	seqz	s1,s1
    80003b0e:	bfc1                	j	80003ade <holdingsleep+0x24>

0000000080003b10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b10:	1141                	addi	sp,sp,-16
    80003b12:	e406                	sd	ra,8(sp)
    80003b14:	e022                	sd	s0,0(sp)
    80003b16:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b18:	00005597          	auipc	a1,0x5
    80003b1c:	b6858593          	addi	a1,a1,-1176 # 80008680 <syscalls+0x280>
    80003b20:	00016517          	auipc	a0,0x16
    80003b24:	a4850513          	addi	a0,a0,-1464 # 80019568 <ftable>
    80003b28:	00002097          	auipc	ra,0x2
    80003b2c:	758080e7          	jalr	1880(ra) # 80006280 <initlock>
}
    80003b30:	60a2                	ld	ra,8(sp)
    80003b32:	6402                	ld	s0,0(sp)
    80003b34:	0141                	addi	sp,sp,16
    80003b36:	8082                	ret

0000000080003b38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b38:	1101                	addi	sp,sp,-32
    80003b3a:	ec06                	sd	ra,24(sp)
    80003b3c:	e822                	sd	s0,16(sp)
    80003b3e:	e426                	sd	s1,8(sp)
    80003b40:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b42:	00016517          	auipc	a0,0x16
    80003b46:	a2650513          	addi	a0,a0,-1498 # 80019568 <ftable>
    80003b4a:	00002097          	auipc	ra,0x2
    80003b4e:	7c6080e7          	jalr	1990(ra) # 80006310 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b52:	00016497          	auipc	s1,0x16
    80003b56:	a2e48493          	addi	s1,s1,-1490 # 80019580 <ftable+0x18>
    80003b5a:	00017717          	auipc	a4,0x17
    80003b5e:	9c670713          	addi	a4,a4,-1594 # 8001a520 <ftable+0xfb8>
    if(f->ref == 0){
    80003b62:	40dc                	lw	a5,4(s1)
    80003b64:	cf99                	beqz	a5,80003b82 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b66:	02848493          	addi	s1,s1,40
    80003b6a:	fee49ce3          	bne	s1,a4,80003b62 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b6e:	00016517          	auipc	a0,0x16
    80003b72:	9fa50513          	addi	a0,a0,-1542 # 80019568 <ftable>
    80003b76:	00003097          	auipc	ra,0x3
    80003b7a:	84e080e7          	jalr	-1970(ra) # 800063c4 <release>
  return 0;
    80003b7e:	4481                	li	s1,0
    80003b80:	a819                	j	80003b96 <filealloc+0x5e>
      f->ref = 1;
    80003b82:	4785                	li	a5,1
    80003b84:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b86:	00016517          	auipc	a0,0x16
    80003b8a:	9e250513          	addi	a0,a0,-1566 # 80019568 <ftable>
    80003b8e:	00003097          	auipc	ra,0x3
    80003b92:	836080e7          	jalr	-1994(ra) # 800063c4 <release>
}
    80003b96:	8526                	mv	a0,s1
    80003b98:	60e2                	ld	ra,24(sp)
    80003b9a:	6442                	ld	s0,16(sp)
    80003b9c:	64a2                	ld	s1,8(sp)
    80003b9e:	6105                	addi	sp,sp,32
    80003ba0:	8082                	ret

0000000080003ba2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ba2:	1101                	addi	sp,sp,-32
    80003ba4:	ec06                	sd	ra,24(sp)
    80003ba6:	e822                	sd	s0,16(sp)
    80003ba8:	e426                	sd	s1,8(sp)
    80003baa:	1000                	addi	s0,sp,32
    80003bac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bae:	00016517          	auipc	a0,0x16
    80003bb2:	9ba50513          	addi	a0,a0,-1606 # 80019568 <ftable>
    80003bb6:	00002097          	auipc	ra,0x2
    80003bba:	75a080e7          	jalr	1882(ra) # 80006310 <acquire>
  if(f->ref < 1)
    80003bbe:	40dc                	lw	a5,4(s1)
    80003bc0:	02f05263          	blez	a5,80003be4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bc4:	2785                	addiw	a5,a5,1
    80003bc6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bc8:	00016517          	auipc	a0,0x16
    80003bcc:	9a050513          	addi	a0,a0,-1632 # 80019568 <ftable>
    80003bd0:	00002097          	auipc	ra,0x2
    80003bd4:	7f4080e7          	jalr	2036(ra) # 800063c4 <release>
  return f;
}
    80003bd8:	8526                	mv	a0,s1
    80003bda:	60e2                	ld	ra,24(sp)
    80003bdc:	6442                	ld	s0,16(sp)
    80003bde:	64a2                	ld	s1,8(sp)
    80003be0:	6105                	addi	sp,sp,32
    80003be2:	8082                	ret
    panic("filedup");
    80003be4:	00005517          	auipc	a0,0x5
    80003be8:	aa450513          	addi	a0,a0,-1372 # 80008688 <syscalls+0x288>
    80003bec:	00002097          	auipc	ra,0x2
    80003bf0:	1e8080e7          	jalr	488(ra) # 80005dd4 <panic>

0000000080003bf4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bf4:	7139                	addi	sp,sp,-64
    80003bf6:	fc06                	sd	ra,56(sp)
    80003bf8:	f822                	sd	s0,48(sp)
    80003bfa:	f426                	sd	s1,40(sp)
    80003bfc:	f04a                	sd	s2,32(sp)
    80003bfe:	ec4e                	sd	s3,24(sp)
    80003c00:	e852                	sd	s4,16(sp)
    80003c02:	e456                	sd	s5,8(sp)
    80003c04:	0080                	addi	s0,sp,64
    80003c06:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c08:	00016517          	auipc	a0,0x16
    80003c0c:	96050513          	addi	a0,a0,-1696 # 80019568 <ftable>
    80003c10:	00002097          	auipc	ra,0x2
    80003c14:	700080e7          	jalr	1792(ra) # 80006310 <acquire>
  if(f->ref < 1)
    80003c18:	40dc                	lw	a5,4(s1)
    80003c1a:	06f05163          	blez	a5,80003c7c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c1e:	37fd                	addiw	a5,a5,-1
    80003c20:	0007871b          	sext.w	a4,a5
    80003c24:	c0dc                	sw	a5,4(s1)
    80003c26:	06e04363          	bgtz	a4,80003c8c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c2a:	0004a903          	lw	s2,0(s1)
    80003c2e:	0094ca83          	lbu	s5,9(s1)
    80003c32:	0104ba03          	ld	s4,16(s1)
    80003c36:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c3a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c3e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c42:	00016517          	auipc	a0,0x16
    80003c46:	92650513          	addi	a0,a0,-1754 # 80019568 <ftable>
    80003c4a:	00002097          	auipc	ra,0x2
    80003c4e:	77a080e7          	jalr	1914(ra) # 800063c4 <release>

  if(ff.type == FD_PIPE){
    80003c52:	4785                	li	a5,1
    80003c54:	04f90d63          	beq	s2,a5,80003cae <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c58:	3979                	addiw	s2,s2,-2
    80003c5a:	4785                	li	a5,1
    80003c5c:	0527e063          	bltu	a5,s2,80003c9c <fileclose+0xa8>
    begin_op();
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	ac8080e7          	jalr	-1336(ra) # 80003728 <begin_op>
    iput(ff.ip);
    80003c68:	854e                	mv	a0,s3
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	2a6080e7          	jalr	678(ra) # 80002f10 <iput>
    end_op();
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	b36080e7          	jalr	-1226(ra) # 800037a8 <end_op>
    80003c7a:	a00d                	j	80003c9c <fileclose+0xa8>
    panic("fileclose");
    80003c7c:	00005517          	auipc	a0,0x5
    80003c80:	a1450513          	addi	a0,a0,-1516 # 80008690 <syscalls+0x290>
    80003c84:	00002097          	auipc	ra,0x2
    80003c88:	150080e7          	jalr	336(ra) # 80005dd4 <panic>
    release(&ftable.lock);
    80003c8c:	00016517          	auipc	a0,0x16
    80003c90:	8dc50513          	addi	a0,a0,-1828 # 80019568 <ftable>
    80003c94:	00002097          	auipc	ra,0x2
    80003c98:	730080e7          	jalr	1840(ra) # 800063c4 <release>
  }
}
    80003c9c:	70e2                	ld	ra,56(sp)
    80003c9e:	7442                	ld	s0,48(sp)
    80003ca0:	74a2                	ld	s1,40(sp)
    80003ca2:	7902                	ld	s2,32(sp)
    80003ca4:	69e2                	ld	s3,24(sp)
    80003ca6:	6a42                	ld	s4,16(sp)
    80003ca8:	6aa2                	ld	s5,8(sp)
    80003caa:	6121                	addi	sp,sp,64
    80003cac:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cae:	85d6                	mv	a1,s5
    80003cb0:	8552                	mv	a0,s4
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	34c080e7          	jalr	844(ra) # 80003ffe <pipeclose>
    80003cba:	b7cd                	j	80003c9c <fileclose+0xa8>

0000000080003cbc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cbc:	715d                	addi	sp,sp,-80
    80003cbe:	e486                	sd	ra,72(sp)
    80003cc0:	e0a2                	sd	s0,64(sp)
    80003cc2:	fc26                	sd	s1,56(sp)
    80003cc4:	f84a                	sd	s2,48(sp)
    80003cc6:	f44e                	sd	s3,40(sp)
    80003cc8:	0880                	addi	s0,sp,80
    80003cca:	84aa                	mv	s1,a0
    80003ccc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cce:	ffffd097          	auipc	ra,0xffffd
    80003cd2:	324080e7          	jalr	804(ra) # 80000ff2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cd6:	409c                	lw	a5,0(s1)
    80003cd8:	37f9                	addiw	a5,a5,-2
    80003cda:	4705                	li	a4,1
    80003cdc:	04f76763          	bltu	a4,a5,80003d2a <filestat+0x6e>
    80003ce0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ce2:	6c88                	ld	a0,24(s1)
    80003ce4:	fffff097          	auipc	ra,0xfffff
    80003ce8:	072080e7          	jalr	114(ra) # 80002d56 <ilock>
    stati(f->ip, &st);
    80003cec:	fb840593          	addi	a1,s0,-72
    80003cf0:	6c88                	ld	a0,24(s1)
    80003cf2:	fffff097          	auipc	ra,0xfffff
    80003cf6:	2ee080e7          	jalr	750(ra) # 80002fe0 <stati>
    iunlock(f->ip);
    80003cfa:	6c88                	ld	a0,24(s1)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	11c080e7          	jalr	284(ra) # 80002e18 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d04:	46e1                	li	a3,24
    80003d06:	fb840613          	addi	a2,s0,-72
    80003d0a:	85ce                	mv	a1,s3
    80003d0c:	05093503          	ld	a0,80(s2)
    80003d10:	ffffd097          	auipc	ra,0xffffd
    80003d14:	df2080e7          	jalr	-526(ra) # 80000b02 <copyout>
    80003d18:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d1c:	60a6                	ld	ra,72(sp)
    80003d1e:	6406                	ld	s0,64(sp)
    80003d20:	74e2                	ld	s1,56(sp)
    80003d22:	7942                	ld	s2,48(sp)
    80003d24:	79a2                	ld	s3,40(sp)
    80003d26:	6161                	addi	sp,sp,80
    80003d28:	8082                	ret
  return -1;
    80003d2a:	557d                	li	a0,-1
    80003d2c:	bfc5                	j	80003d1c <filestat+0x60>

0000000080003d2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d2e:	7179                	addi	sp,sp,-48
    80003d30:	f406                	sd	ra,40(sp)
    80003d32:	f022                	sd	s0,32(sp)
    80003d34:	ec26                	sd	s1,24(sp)
    80003d36:	e84a                	sd	s2,16(sp)
    80003d38:	e44e                	sd	s3,8(sp)
    80003d3a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d3c:	00854783          	lbu	a5,8(a0)
    80003d40:	c3d5                	beqz	a5,80003de4 <fileread+0xb6>
    80003d42:	84aa                	mv	s1,a0
    80003d44:	89ae                	mv	s3,a1
    80003d46:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d48:	411c                	lw	a5,0(a0)
    80003d4a:	4705                	li	a4,1
    80003d4c:	04e78963          	beq	a5,a4,80003d9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d50:	470d                	li	a4,3
    80003d52:	04e78d63          	beq	a5,a4,80003dac <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d56:	4709                	li	a4,2
    80003d58:	06e79e63          	bne	a5,a4,80003dd4 <fileread+0xa6>
    ilock(f->ip);
    80003d5c:	6d08                	ld	a0,24(a0)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	ff8080e7          	jalr	-8(ra) # 80002d56 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d66:	874a                	mv	a4,s2
    80003d68:	5094                	lw	a3,32(s1)
    80003d6a:	864e                	mv	a2,s3
    80003d6c:	4585                	li	a1,1
    80003d6e:	6c88                	ld	a0,24(s1)
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	29a080e7          	jalr	666(ra) # 8000300a <readi>
    80003d78:	892a                	mv	s2,a0
    80003d7a:	00a05563          	blez	a0,80003d84 <fileread+0x56>
      f->off += r;
    80003d7e:	509c                	lw	a5,32(s1)
    80003d80:	9fa9                	addw	a5,a5,a0
    80003d82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d84:	6c88                	ld	a0,24(s1)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	092080e7          	jalr	146(ra) # 80002e18 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d8e:	854a                	mv	a0,s2
    80003d90:	70a2                	ld	ra,40(sp)
    80003d92:	7402                	ld	s0,32(sp)
    80003d94:	64e2                	ld	s1,24(sp)
    80003d96:	6942                	ld	s2,16(sp)
    80003d98:	69a2                	ld	s3,8(sp)
    80003d9a:	6145                	addi	sp,sp,48
    80003d9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d9e:	6908                	ld	a0,16(a0)
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	3c0080e7          	jalr	960(ra) # 80004160 <piperead>
    80003da8:	892a                	mv	s2,a0
    80003daa:	b7d5                	j	80003d8e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dac:	02451783          	lh	a5,36(a0)
    80003db0:	03079693          	slli	a3,a5,0x30
    80003db4:	92c1                	srli	a3,a3,0x30
    80003db6:	4725                	li	a4,9
    80003db8:	02d76863          	bltu	a4,a3,80003de8 <fileread+0xba>
    80003dbc:	0792                	slli	a5,a5,0x4
    80003dbe:	00015717          	auipc	a4,0x15
    80003dc2:	70a70713          	addi	a4,a4,1802 # 800194c8 <devsw>
    80003dc6:	97ba                	add	a5,a5,a4
    80003dc8:	639c                	ld	a5,0(a5)
    80003dca:	c38d                	beqz	a5,80003dec <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dcc:	4505                	li	a0,1
    80003dce:	9782                	jalr	a5
    80003dd0:	892a                	mv	s2,a0
    80003dd2:	bf75                	j	80003d8e <fileread+0x60>
    panic("fileread");
    80003dd4:	00005517          	auipc	a0,0x5
    80003dd8:	8cc50513          	addi	a0,a0,-1844 # 800086a0 <syscalls+0x2a0>
    80003ddc:	00002097          	auipc	ra,0x2
    80003de0:	ff8080e7          	jalr	-8(ra) # 80005dd4 <panic>
    return -1;
    80003de4:	597d                	li	s2,-1
    80003de6:	b765                	j	80003d8e <fileread+0x60>
      return -1;
    80003de8:	597d                	li	s2,-1
    80003dea:	b755                	j	80003d8e <fileread+0x60>
    80003dec:	597d                	li	s2,-1
    80003dee:	b745                	j	80003d8e <fileread+0x60>

0000000080003df0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003df0:	715d                	addi	sp,sp,-80
    80003df2:	e486                	sd	ra,72(sp)
    80003df4:	e0a2                	sd	s0,64(sp)
    80003df6:	fc26                	sd	s1,56(sp)
    80003df8:	f84a                	sd	s2,48(sp)
    80003dfa:	f44e                	sd	s3,40(sp)
    80003dfc:	f052                	sd	s4,32(sp)
    80003dfe:	ec56                	sd	s5,24(sp)
    80003e00:	e85a                	sd	s6,16(sp)
    80003e02:	e45e                	sd	s7,8(sp)
    80003e04:	e062                	sd	s8,0(sp)
    80003e06:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e08:	00954783          	lbu	a5,9(a0)
    80003e0c:	10078663          	beqz	a5,80003f18 <filewrite+0x128>
    80003e10:	892a                	mv	s2,a0
    80003e12:	8aae                	mv	s5,a1
    80003e14:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e16:	411c                	lw	a5,0(a0)
    80003e18:	4705                	li	a4,1
    80003e1a:	02e78263          	beq	a5,a4,80003e3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e1e:	470d                	li	a4,3
    80003e20:	02e78663          	beq	a5,a4,80003e4c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e24:	4709                	li	a4,2
    80003e26:	0ee79163          	bne	a5,a4,80003f08 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e2a:	0ac05d63          	blez	a2,80003ee4 <filewrite+0xf4>
    int i = 0;
    80003e2e:	4981                	li	s3,0
    80003e30:	6b05                	lui	s6,0x1
    80003e32:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e36:	6b85                	lui	s7,0x1
    80003e38:	c00b8b9b          	addiw	s7,s7,-1024
    80003e3c:	a861                	j	80003ed4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e3e:	6908                	ld	a0,16(a0)
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	22e080e7          	jalr	558(ra) # 8000406e <pipewrite>
    80003e48:	8a2a                	mv	s4,a0
    80003e4a:	a045                	j	80003eea <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e4c:	02451783          	lh	a5,36(a0)
    80003e50:	03079693          	slli	a3,a5,0x30
    80003e54:	92c1                	srli	a3,a3,0x30
    80003e56:	4725                	li	a4,9
    80003e58:	0cd76263          	bltu	a4,a3,80003f1c <filewrite+0x12c>
    80003e5c:	0792                	slli	a5,a5,0x4
    80003e5e:	00015717          	auipc	a4,0x15
    80003e62:	66a70713          	addi	a4,a4,1642 # 800194c8 <devsw>
    80003e66:	97ba                	add	a5,a5,a4
    80003e68:	679c                	ld	a5,8(a5)
    80003e6a:	cbdd                	beqz	a5,80003f20 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e6c:	4505                	li	a0,1
    80003e6e:	9782                	jalr	a5
    80003e70:	8a2a                	mv	s4,a0
    80003e72:	a8a5                	j	80003eea <filewrite+0xfa>
    80003e74:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	8b0080e7          	jalr	-1872(ra) # 80003728 <begin_op>
      ilock(f->ip);
    80003e80:	01893503          	ld	a0,24(s2)
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	ed2080e7          	jalr	-302(ra) # 80002d56 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e8c:	8762                	mv	a4,s8
    80003e8e:	02092683          	lw	a3,32(s2)
    80003e92:	01598633          	add	a2,s3,s5
    80003e96:	4585                	li	a1,1
    80003e98:	01893503          	ld	a0,24(s2)
    80003e9c:	fffff097          	auipc	ra,0xfffff
    80003ea0:	266080e7          	jalr	614(ra) # 80003102 <writei>
    80003ea4:	84aa                	mv	s1,a0
    80003ea6:	00a05763          	blez	a0,80003eb4 <filewrite+0xc4>
        f->off += r;
    80003eaa:	02092783          	lw	a5,32(s2)
    80003eae:	9fa9                	addw	a5,a5,a0
    80003eb0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003eb4:	01893503          	ld	a0,24(s2)
    80003eb8:	fffff097          	auipc	ra,0xfffff
    80003ebc:	f60080e7          	jalr	-160(ra) # 80002e18 <iunlock>
      end_op();
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	8e8080e7          	jalr	-1816(ra) # 800037a8 <end_op>

      if(r != n1){
    80003ec8:	009c1f63          	bne	s8,s1,80003ee6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ecc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ed0:	0149db63          	bge	s3,s4,80003ee6 <filewrite+0xf6>
      int n1 = n - i;
    80003ed4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ed8:	84be                	mv	s1,a5
    80003eda:	2781                	sext.w	a5,a5
    80003edc:	f8fb5ce3          	bge	s6,a5,80003e74 <filewrite+0x84>
    80003ee0:	84de                	mv	s1,s7
    80003ee2:	bf49                	j	80003e74 <filewrite+0x84>
    int i = 0;
    80003ee4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ee6:	013a1f63          	bne	s4,s3,80003f04 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eea:	8552                	mv	a0,s4
    80003eec:	60a6                	ld	ra,72(sp)
    80003eee:	6406                	ld	s0,64(sp)
    80003ef0:	74e2                	ld	s1,56(sp)
    80003ef2:	7942                	ld	s2,48(sp)
    80003ef4:	79a2                	ld	s3,40(sp)
    80003ef6:	7a02                	ld	s4,32(sp)
    80003ef8:	6ae2                	ld	s5,24(sp)
    80003efa:	6b42                	ld	s6,16(sp)
    80003efc:	6ba2                	ld	s7,8(sp)
    80003efe:	6c02                	ld	s8,0(sp)
    80003f00:	6161                	addi	sp,sp,80
    80003f02:	8082                	ret
    ret = (i == n ? n : -1);
    80003f04:	5a7d                	li	s4,-1
    80003f06:	b7d5                	j	80003eea <filewrite+0xfa>
    panic("filewrite");
    80003f08:	00004517          	auipc	a0,0x4
    80003f0c:	7a850513          	addi	a0,a0,1960 # 800086b0 <syscalls+0x2b0>
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	ec4080e7          	jalr	-316(ra) # 80005dd4 <panic>
    return -1;
    80003f18:	5a7d                	li	s4,-1
    80003f1a:	bfc1                	j	80003eea <filewrite+0xfa>
      return -1;
    80003f1c:	5a7d                	li	s4,-1
    80003f1e:	b7f1                	j	80003eea <filewrite+0xfa>
    80003f20:	5a7d                	li	s4,-1
    80003f22:	b7e1                	j	80003eea <filewrite+0xfa>

0000000080003f24 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f24:	7179                	addi	sp,sp,-48
    80003f26:	f406                	sd	ra,40(sp)
    80003f28:	f022                	sd	s0,32(sp)
    80003f2a:	ec26                	sd	s1,24(sp)
    80003f2c:	e84a                	sd	s2,16(sp)
    80003f2e:	e44e                	sd	s3,8(sp)
    80003f30:	e052                	sd	s4,0(sp)
    80003f32:	1800                	addi	s0,sp,48
    80003f34:	84aa                	mv	s1,a0
    80003f36:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f38:	0005b023          	sd	zero,0(a1)
    80003f3c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	bf8080e7          	jalr	-1032(ra) # 80003b38 <filealloc>
    80003f48:	e088                	sd	a0,0(s1)
    80003f4a:	c551                	beqz	a0,80003fd6 <pipealloc+0xb2>
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	bec080e7          	jalr	-1044(ra) # 80003b38 <filealloc>
    80003f54:	00aa3023          	sd	a0,0(s4)
    80003f58:	c92d                	beqz	a0,80003fca <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f5a:	ffffc097          	auipc	ra,0xffffc
    80003f5e:	1be080e7          	jalr	446(ra) # 80000118 <kalloc>
    80003f62:	892a                	mv	s2,a0
    80003f64:	c125                	beqz	a0,80003fc4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f66:	4985                	li	s3,1
    80003f68:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f6c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f70:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f74:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f78:	00004597          	auipc	a1,0x4
    80003f7c:	74858593          	addi	a1,a1,1864 # 800086c0 <syscalls+0x2c0>
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	300080e7          	jalr	768(ra) # 80006280 <initlock>
  (*f0)->type = FD_PIPE;
    80003f88:	609c                	ld	a5,0(s1)
    80003f8a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f8e:	609c                	ld	a5,0(s1)
    80003f90:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f94:	609c                	ld	a5,0(s1)
    80003f96:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f9a:	609c                	ld	a5,0(s1)
    80003f9c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fa0:	000a3783          	ld	a5,0(s4)
    80003fa4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fa8:	000a3783          	ld	a5,0(s4)
    80003fac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fb0:	000a3783          	ld	a5,0(s4)
    80003fb4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fb8:	000a3783          	ld	a5,0(s4)
    80003fbc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fc0:	4501                	li	a0,0
    80003fc2:	a025                	j	80003fea <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fc4:	6088                	ld	a0,0(s1)
    80003fc6:	e501                	bnez	a0,80003fce <pipealloc+0xaa>
    80003fc8:	a039                	j	80003fd6 <pipealloc+0xb2>
    80003fca:	6088                	ld	a0,0(s1)
    80003fcc:	c51d                	beqz	a0,80003ffa <pipealloc+0xd6>
    fileclose(*f0);
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	c26080e7          	jalr	-986(ra) # 80003bf4 <fileclose>
  if(*f1)
    80003fd6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fda:	557d                	li	a0,-1
  if(*f1)
    80003fdc:	c799                	beqz	a5,80003fea <pipealloc+0xc6>
    fileclose(*f1);
    80003fde:	853e                	mv	a0,a5
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	c14080e7          	jalr	-1004(ra) # 80003bf4 <fileclose>
  return -1;
    80003fe8:	557d                	li	a0,-1
}
    80003fea:	70a2                	ld	ra,40(sp)
    80003fec:	7402                	ld	s0,32(sp)
    80003fee:	64e2                	ld	s1,24(sp)
    80003ff0:	6942                	ld	s2,16(sp)
    80003ff2:	69a2                	ld	s3,8(sp)
    80003ff4:	6a02                	ld	s4,0(sp)
    80003ff6:	6145                	addi	sp,sp,48
    80003ff8:	8082                	ret
  return -1;
    80003ffa:	557d                	li	a0,-1
    80003ffc:	b7fd                	j	80003fea <pipealloc+0xc6>

0000000080003ffe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ffe:	1101                	addi	sp,sp,-32
    80004000:	ec06                	sd	ra,24(sp)
    80004002:	e822                	sd	s0,16(sp)
    80004004:	e426                	sd	s1,8(sp)
    80004006:	e04a                	sd	s2,0(sp)
    80004008:	1000                	addi	s0,sp,32
    8000400a:	84aa                	mv	s1,a0
    8000400c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	302080e7          	jalr	770(ra) # 80006310 <acquire>
  if(writable){
    80004016:	02090d63          	beqz	s2,80004050 <pipeclose+0x52>
    pi->writeopen = 0;
    8000401a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000401e:	21848513          	addi	a0,s1,536
    80004022:	ffffe097          	auipc	ra,0xffffe
    80004026:	8d2080e7          	jalr	-1838(ra) # 800018f4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000402a:	2204b783          	ld	a5,544(s1)
    8000402e:	eb95                	bnez	a5,80004062 <pipeclose+0x64>
    release(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	392080e7          	jalr	914(ra) # 800063c4 <release>
    kfree((char*)pi);
    8000403a:	8526                	mv	a0,s1
    8000403c:	ffffc097          	auipc	ra,0xffffc
    80004040:	fe0080e7          	jalr	-32(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004044:	60e2                	ld	ra,24(sp)
    80004046:	6442                	ld	s0,16(sp)
    80004048:	64a2                	ld	s1,8(sp)
    8000404a:	6902                	ld	s2,0(sp)
    8000404c:	6105                	addi	sp,sp,32
    8000404e:	8082                	ret
    pi->readopen = 0;
    80004050:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004054:	21c48513          	addi	a0,s1,540
    80004058:	ffffe097          	auipc	ra,0xffffe
    8000405c:	89c080e7          	jalr	-1892(ra) # 800018f4 <wakeup>
    80004060:	b7e9                	j	8000402a <pipeclose+0x2c>
    release(&pi->lock);
    80004062:	8526                	mv	a0,s1
    80004064:	00002097          	auipc	ra,0x2
    80004068:	360080e7          	jalr	864(ra) # 800063c4 <release>
}
    8000406c:	bfe1                	j	80004044 <pipeclose+0x46>

000000008000406e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000406e:	711d                	addi	sp,sp,-96
    80004070:	ec86                	sd	ra,88(sp)
    80004072:	e8a2                	sd	s0,80(sp)
    80004074:	e4a6                	sd	s1,72(sp)
    80004076:	e0ca                	sd	s2,64(sp)
    80004078:	fc4e                	sd	s3,56(sp)
    8000407a:	f852                	sd	s4,48(sp)
    8000407c:	f456                	sd	s5,40(sp)
    8000407e:	f05a                	sd	s6,32(sp)
    80004080:	ec5e                	sd	s7,24(sp)
    80004082:	e862                	sd	s8,16(sp)
    80004084:	1080                	addi	s0,sp,96
    80004086:	84aa                	mv	s1,a0
    80004088:	8aae                	mv	s5,a1
    8000408a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	f66080e7          	jalr	-154(ra) # 80000ff2 <myproc>
    80004094:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	278080e7          	jalr	632(ra) # 80006310 <acquire>
  while(i < n){
    800040a0:	0b405363          	blez	s4,80004146 <pipewrite+0xd8>
  int i = 0;
    800040a4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040a6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040a8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040ac:	21c48b93          	addi	s7,s1,540
    800040b0:	a089                	j	800040f2 <pipewrite+0x84>
      release(&pi->lock);
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	310080e7          	jalr	784(ra) # 800063c4 <release>
      return -1;
    800040bc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040be:	854a                	mv	a0,s2
    800040c0:	60e6                	ld	ra,88(sp)
    800040c2:	6446                	ld	s0,80(sp)
    800040c4:	64a6                	ld	s1,72(sp)
    800040c6:	6906                	ld	s2,64(sp)
    800040c8:	79e2                	ld	s3,56(sp)
    800040ca:	7a42                	ld	s4,48(sp)
    800040cc:	7aa2                	ld	s5,40(sp)
    800040ce:	7b02                	ld	s6,32(sp)
    800040d0:	6be2                	ld	s7,24(sp)
    800040d2:	6c42                	ld	s8,16(sp)
    800040d4:	6125                	addi	sp,sp,96
    800040d6:	8082                	ret
      wakeup(&pi->nread);
    800040d8:	8562                	mv	a0,s8
    800040da:	ffffe097          	auipc	ra,0xffffe
    800040de:	81a080e7          	jalr	-2022(ra) # 800018f4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040e2:	85a6                	mv	a1,s1
    800040e4:	855e                	mv	a0,s7
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	682080e7          	jalr	1666(ra) # 80001768 <sleep>
  while(i < n){
    800040ee:	05495d63          	bge	s2,s4,80004148 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040f2:	2204a783          	lw	a5,544(s1)
    800040f6:	dfd5                	beqz	a5,800040b2 <pipewrite+0x44>
    800040f8:	0289a783          	lw	a5,40(s3)
    800040fc:	fbdd                	bnez	a5,800040b2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040fe:	2184a783          	lw	a5,536(s1)
    80004102:	21c4a703          	lw	a4,540(s1)
    80004106:	2007879b          	addiw	a5,a5,512
    8000410a:	fcf707e3          	beq	a4,a5,800040d8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000410e:	4685                	li	a3,1
    80004110:	01590633          	add	a2,s2,s5
    80004114:	faf40593          	addi	a1,s0,-81
    80004118:	0509b503          	ld	a0,80(s3)
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	a72080e7          	jalr	-1422(ra) # 80000b8e <copyin>
    80004124:	03650263          	beq	a0,s6,80004148 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004128:	21c4a783          	lw	a5,540(s1)
    8000412c:	0017871b          	addiw	a4,a5,1
    80004130:	20e4ae23          	sw	a4,540(s1)
    80004134:	1ff7f793          	andi	a5,a5,511
    80004138:	97a6                	add	a5,a5,s1
    8000413a:	faf44703          	lbu	a4,-81(s0)
    8000413e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004142:	2905                	addiw	s2,s2,1
    80004144:	b76d                	j	800040ee <pipewrite+0x80>
  int i = 0;
    80004146:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004148:	21848513          	addi	a0,s1,536
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	7a8080e7          	jalr	1960(ra) # 800018f4 <wakeup>
  release(&pi->lock);
    80004154:	8526                	mv	a0,s1
    80004156:	00002097          	auipc	ra,0x2
    8000415a:	26e080e7          	jalr	622(ra) # 800063c4 <release>
  return i;
    8000415e:	b785                	j	800040be <pipewrite+0x50>

0000000080004160 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004160:	715d                	addi	sp,sp,-80
    80004162:	e486                	sd	ra,72(sp)
    80004164:	e0a2                	sd	s0,64(sp)
    80004166:	fc26                	sd	s1,56(sp)
    80004168:	f84a                	sd	s2,48(sp)
    8000416a:	f44e                	sd	s3,40(sp)
    8000416c:	f052                	sd	s4,32(sp)
    8000416e:	ec56                	sd	s5,24(sp)
    80004170:	e85a                	sd	s6,16(sp)
    80004172:	0880                	addi	s0,sp,80
    80004174:	84aa                	mv	s1,a0
    80004176:	892e                	mv	s2,a1
    80004178:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	e78080e7          	jalr	-392(ra) # 80000ff2 <myproc>
    80004182:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004184:	8526                	mv	a0,s1
    80004186:	00002097          	auipc	ra,0x2
    8000418a:	18a080e7          	jalr	394(ra) # 80006310 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000418e:	2184a703          	lw	a4,536(s1)
    80004192:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004196:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000419a:	02f71463          	bne	a4,a5,800041c2 <piperead+0x62>
    8000419e:	2244a783          	lw	a5,548(s1)
    800041a2:	c385                	beqz	a5,800041c2 <piperead+0x62>
    if(pr->killed){
    800041a4:	028a2783          	lw	a5,40(s4)
    800041a8:	ebc1                	bnez	a5,80004238 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041aa:	85a6                	mv	a1,s1
    800041ac:	854e                	mv	a0,s3
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	5ba080e7          	jalr	1466(ra) # 80001768 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b6:	2184a703          	lw	a4,536(s1)
    800041ba:	21c4a783          	lw	a5,540(s1)
    800041be:	fef700e3          	beq	a4,a5,8000419e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c6:	05505363          	blez	s5,8000420c <piperead+0xac>
    if(pi->nread == pi->nwrite)
    800041ca:	2184a783          	lw	a5,536(s1)
    800041ce:	21c4a703          	lw	a4,540(s1)
    800041d2:	02f70d63          	beq	a4,a5,8000420c <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041d6:	0017871b          	addiw	a4,a5,1
    800041da:	20e4ac23          	sw	a4,536(s1)
    800041de:	1ff7f793          	andi	a5,a5,511
    800041e2:	97a6                	add	a5,a5,s1
    800041e4:	0187c783          	lbu	a5,24(a5)
    800041e8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ec:	4685                	li	a3,1
    800041ee:	fbf40613          	addi	a2,s0,-65
    800041f2:	85ca                	mv	a1,s2
    800041f4:	050a3503          	ld	a0,80(s4)
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	90a080e7          	jalr	-1782(ra) # 80000b02 <copyout>
    80004200:	01650663          	beq	a0,s6,8000420c <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004204:	2985                	addiw	s3,s3,1
    80004206:	0905                	addi	s2,s2,1
    80004208:	fd3a91e3          	bne	s5,s3,800041ca <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000420c:	21c48513          	addi	a0,s1,540
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	6e4080e7          	jalr	1764(ra) # 800018f4 <wakeup>
  release(&pi->lock);
    80004218:	8526                	mv	a0,s1
    8000421a:	00002097          	auipc	ra,0x2
    8000421e:	1aa080e7          	jalr	426(ra) # 800063c4 <release>
  return i;
}
    80004222:	854e                	mv	a0,s3
    80004224:	60a6                	ld	ra,72(sp)
    80004226:	6406                	ld	s0,64(sp)
    80004228:	74e2                	ld	s1,56(sp)
    8000422a:	7942                	ld	s2,48(sp)
    8000422c:	79a2                	ld	s3,40(sp)
    8000422e:	7a02                	ld	s4,32(sp)
    80004230:	6ae2                	ld	s5,24(sp)
    80004232:	6b42                	ld	s6,16(sp)
    80004234:	6161                	addi	sp,sp,80
    80004236:	8082                	ret
      release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	18a080e7          	jalr	394(ra) # 800063c4 <release>
      return -1;
    80004242:	59fd                	li	s3,-1
    80004244:	bff9                	j	80004222 <piperead+0xc2>

0000000080004246 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004246:	de010113          	addi	sp,sp,-544
    8000424a:	20113c23          	sd	ra,536(sp)
    8000424e:	20813823          	sd	s0,528(sp)
    80004252:	20913423          	sd	s1,520(sp)
    80004256:	21213023          	sd	s2,512(sp)
    8000425a:	ffce                	sd	s3,504(sp)
    8000425c:	fbd2                	sd	s4,496(sp)
    8000425e:	f7d6                	sd	s5,488(sp)
    80004260:	f3da                	sd	s6,480(sp)
    80004262:	efde                	sd	s7,472(sp)
    80004264:	ebe2                	sd	s8,464(sp)
    80004266:	e7e6                	sd	s9,456(sp)
    80004268:	e3ea                	sd	s10,448(sp)
    8000426a:	ff6e                	sd	s11,440(sp)
    8000426c:	1400                	addi	s0,sp,544
    8000426e:	892a                	mv	s2,a0
    80004270:	dea43423          	sd	a0,-536(s0)
    80004274:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	d7a080e7          	jalr	-646(ra) # 80000ff2 <myproc>
    80004280:	84aa                	mv	s1,a0

  begin_op();
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	4a6080e7          	jalr	1190(ra) # 80003728 <begin_op>

  if((ip = namei(path)) == 0){
    8000428a:	854a                	mv	a0,s2
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	280080e7          	jalr	640(ra) # 8000350c <namei>
    80004294:	c93d                	beqz	a0,8000430a <exec+0xc4>
    80004296:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	abe080e7          	jalr	-1346(ra) # 80002d56 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042a0:	04000713          	li	a4,64
    800042a4:	4681                	li	a3,0
    800042a6:	e5040613          	addi	a2,s0,-432
    800042aa:	4581                	li	a1,0
    800042ac:	8556                	mv	a0,s5
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	d5c080e7          	jalr	-676(ra) # 8000300a <readi>
    800042b6:	04000793          	li	a5,64
    800042ba:	00f51a63          	bne	a0,a5,800042ce <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042be:	e5042703          	lw	a4,-432(s0)
    800042c2:	464c47b7          	lui	a5,0x464c4
    800042c6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ca:	04f70663          	beq	a4,a5,80004316 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042ce:	8556                	mv	a0,s5
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	ce8080e7          	jalr	-792(ra) # 80002fb8 <iunlockput>
    end_op();
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	4d0080e7          	jalr	1232(ra) # 800037a8 <end_op>
  }
  return -1;
    800042e0:	557d                	li	a0,-1
}
    800042e2:	21813083          	ld	ra,536(sp)
    800042e6:	21013403          	ld	s0,528(sp)
    800042ea:	20813483          	ld	s1,520(sp)
    800042ee:	20013903          	ld	s2,512(sp)
    800042f2:	79fe                	ld	s3,504(sp)
    800042f4:	7a5e                	ld	s4,496(sp)
    800042f6:	7abe                	ld	s5,488(sp)
    800042f8:	7b1e                	ld	s6,480(sp)
    800042fa:	6bfe                	ld	s7,472(sp)
    800042fc:	6c5e                	ld	s8,464(sp)
    800042fe:	6cbe                	ld	s9,456(sp)
    80004300:	6d1e                	ld	s10,448(sp)
    80004302:	7dfa                	ld	s11,440(sp)
    80004304:	22010113          	addi	sp,sp,544
    80004308:	8082                	ret
    end_op();
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	49e080e7          	jalr	1182(ra) # 800037a8 <end_op>
    return -1;
    80004312:	557d                	li	a0,-1
    80004314:	b7f9                	j	800042e2 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004316:	8526                	mv	a0,s1
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	d9e080e7          	jalr	-610(ra) # 800010b6 <proc_pagetable>
    80004320:	8b2a                	mv	s6,a0
    80004322:	d555                	beqz	a0,800042ce <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004324:	e7042783          	lw	a5,-400(s0)
    80004328:	e8845703          	lhu	a4,-376(s0)
    8000432c:	c735                	beqz	a4,80004398 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000432e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004330:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004334:	6a05                	lui	s4,0x1
    80004336:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000433a:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000433e:	6d85                	lui	s11,0x1
    80004340:	7d7d                	lui	s10,0xfffff
    80004342:	a4b1                	j	8000458e <exec+0x348>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004344:	00004517          	auipc	a0,0x4
    80004348:	38450513          	addi	a0,a0,900 # 800086c8 <syscalls+0x2c8>
    8000434c:	00002097          	auipc	ra,0x2
    80004350:	a88080e7          	jalr	-1400(ra) # 80005dd4 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004354:	874a                	mv	a4,s2
    80004356:	009c86bb          	addw	a3,s9,s1
    8000435a:	4581                	li	a1,0
    8000435c:	8556                	mv	a0,s5
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	cac080e7          	jalr	-852(ra) # 8000300a <readi>
    80004366:	2501                	sext.w	a0,a0
    80004368:	1ca91363          	bne	s2,a0,8000452e <exec+0x2e8>
  for(i = 0; i < sz; i += PGSIZE){
    8000436c:	009d84bb          	addw	s1,s11,s1
    80004370:	013d09bb          	addw	s3,s10,s3
    80004374:	1f74fd63          	bgeu	s1,s7,8000456e <exec+0x328>
    pa = walkaddr(pagetable, va + i);
    80004378:	02049593          	slli	a1,s1,0x20
    8000437c:	9181                	srli	a1,a1,0x20
    8000437e:	95e2                	add	a1,a1,s8
    80004380:	855a                	mv	a0,s6
    80004382:	ffffc097          	auipc	ra,0xffffc
    80004386:	17c080e7          	jalr	380(ra) # 800004fe <walkaddr>
    8000438a:	862a                	mv	a2,a0
    if(pa == 0)
    8000438c:	dd45                	beqz	a0,80004344 <exec+0xfe>
      n = PGSIZE;
    8000438e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004390:	fd49f2e3          	bgeu	s3,s4,80004354 <exec+0x10e>
      n = sz - i;
    80004394:	894e                	mv	s2,s3
    80004396:	bf7d                	j	80004354 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004398:	4481                	li	s1,0
  iunlockput(ip);
    8000439a:	8556                	mv	a0,s5
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	c1c080e7          	jalr	-996(ra) # 80002fb8 <iunlockput>
  end_op();
    800043a4:	fffff097          	auipc	ra,0xfffff
    800043a8:	404080e7          	jalr	1028(ra) # 800037a8 <end_op>
  p = myproc();
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	c46080e7          	jalr	-954(ra) # 80000ff2 <myproc>
    800043b4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800043b6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043ba:	6785                	lui	a5,0x1
    800043bc:	17fd                	addi	a5,a5,-1
    800043be:	94be                	add	s1,s1,a5
    800043c0:	77fd                	lui	a5,0xfffff
    800043c2:	8fe5                	and	a5,a5,s1
    800043c4:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043c8:	6609                	lui	a2,0x2
    800043ca:	963e                	add	a2,a2,a5
    800043cc:	85be                	mv	a1,a5
    800043ce:	855a                	mv	a0,s6
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	4e2080e7          	jalr	1250(ra) # 800008b2 <uvmalloc>
    800043d8:	8c2a                	mv	s8,a0
  ip = 0;
    800043da:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043dc:	14050963          	beqz	a0,8000452e <exec+0x2e8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043e0:	75f9                	lui	a1,0xffffe
    800043e2:	95aa                	add	a1,a1,a0
    800043e4:	855a                	mv	a0,s6
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	6ea080e7          	jalr	1770(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ee:	7afd                	lui	s5,0xfffff
    800043f0:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043f2:	df043783          	ld	a5,-528(s0)
    800043f6:	6388                	ld	a0,0(a5)
    800043f8:	c925                	beqz	a0,80004468 <exec+0x222>
    800043fa:	e9040993          	addi	s3,s0,-368
    800043fe:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004402:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004404:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	eee080e7          	jalr	-274(ra) # 800002f4 <strlen>
    8000440e:	0015079b          	addiw	a5,a0,1
    80004412:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004416:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000441a:	13596e63          	bltu	s2,s5,80004556 <exec+0x310>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000441e:	df043d83          	ld	s11,-528(s0)
    80004422:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004426:	8552                	mv	a0,s4
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	ecc080e7          	jalr	-308(ra) # 800002f4 <strlen>
    80004430:	0015069b          	addiw	a3,a0,1
    80004434:	8652                	mv	a2,s4
    80004436:	85ca                	mv	a1,s2
    80004438:	855a                	mv	a0,s6
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	6c8080e7          	jalr	1736(ra) # 80000b02 <copyout>
    80004442:	10054e63          	bltz	a0,8000455e <exec+0x318>
    ustack[argc] = sp;
    80004446:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000444a:	0485                	addi	s1,s1,1
    8000444c:	008d8793          	addi	a5,s11,8
    80004450:	def43823          	sd	a5,-528(s0)
    80004454:	008db503          	ld	a0,8(s11)
    80004458:	c911                	beqz	a0,8000446c <exec+0x226>
    if(argc >= MAXARG)
    8000445a:	09a1                	addi	s3,s3,8
    8000445c:	fb3c95e3          	bne	s9,s3,80004406 <exec+0x1c0>
  sz = sz1;
    80004460:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004464:	4a81                	li	s5,0
    80004466:	a0e1                	j	8000452e <exec+0x2e8>
  sp = sz;
    80004468:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000446a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000446c:	00349793          	slli	a5,s1,0x3
    80004470:	f9040713          	addi	a4,s0,-112
    80004474:	97ba                	add	a5,a5,a4
    80004476:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    8000447a:	00148693          	addi	a3,s1,1
    8000447e:	068e                	slli	a3,a3,0x3
    80004480:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004484:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004488:	01597663          	bgeu	s2,s5,80004494 <exec+0x24e>
  sz = sz1;
    8000448c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004490:	4a81                	li	s5,0
    80004492:	a871                	j	8000452e <exec+0x2e8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004494:	e9040613          	addi	a2,s0,-368
    80004498:	85ca                	mv	a1,s2
    8000449a:	855a                	mv	a0,s6
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	666080e7          	jalr	1638(ra) # 80000b02 <copyout>
    800044a4:	0c054163          	bltz	a0,80004566 <exec+0x320>
  p->trapframe->a1 = sp;
    800044a8:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800044ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044b0:	de843783          	ld	a5,-536(s0)
    800044b4:	0007c703          	lbu	a4,0(a5)
    800044b8:	cf11                	beqz	a4,800044d4 <exec+0x28e>
    800044ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044bc:	02f00693          	li	a3,47
    800044c0:	a039                	j	800044ce <exec+0x288>
      last = s+1;
    800044c2:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044c6:	0785                	addi	a5,a5,1
    800044c8:	fff7c703          	lbu	a4,-1(a5)
    800044cc:	c701                	beqz	a4,800044d4 <exec+0x28e>
    if(*s == '/')
    800044ce:	fed71ce3          	bne	a4,a3,800044c6 <exec+0x280>
    800044d2:	bfc5                	j	800044c2 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800044d4:	4641                	li	a2,16
    800044d6:	de843583          	ld	a1,-536(s0)
    800044da:	158b8513          	addi	a0,s7,344
    800044de:	ffffc097          	auipc	ra,0xffffc
    800044e2:	de4080e7          	jalr	-540(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800044e6:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800044ea:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044ee:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044f2:	058bb783          	ld	a5,88(s7)
    800044f6:	e6843703          	ld	a4,-408(s0)
    800044fa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044fc:	058bb783          	ld	a5,88(s7)
    80004500:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004504:	85ea                	mv	a1,s10
    80004506:	ffffd097          	auipc	ra,0xffffd
    8000450a:	ca6080e7          	jalr	-858(ra) # 800011ac <proc_freepagetable>
  if(p->pid == 1)
    8000450e:	030ba703          	lw	a4,48(s7)
    80004512:	4785                	li	a5,1
    80004514:	00f70563          	beq	a4,a5,8000451e <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004518:	0004851b          	sext.w	a0,s1
    8000451c:	b3d9                	j	800042e2 <exec+0x9c>
      vmprint(pagetable);
    8000451e:	855a                	mv	a0,s6
    80004520:	ffffd097          	auipc	ra,0xffffd
    80004524:	8b4080e7          	jalr	-1868(ra) # 80000dd4 <vmprint>
    80004528:	bfc5                	j	80004518 <exec+0x2d2>
    8000452a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000452e:	df843583          	ld	a1,-520(s0)
    80004532:	855a                	mv	a0,s6
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	c78080e7          	jalr	-904(ra) # 800011ac <proc_freepagetable>
  if(ip){
    8000453c:	d80a99e3          	bnez	s5,800042ce <exec+0x88>
  return -1;
    80004540:	557d                	li	a0,-1
    80004542:	b345                	j	800042e2 <exec+0x9c>
    80004544:	de943c23          	sd	s1,-520(s0)
    80004548:	b7dd                	j	8000452e <exec+0x2e8>
    8000454a:	de943c23          	sd	s1,-520(s0)
    8000454e:	b7c5                	j	8000452e <exec+0x2e8>
    80004550:	de943c23          	sd	s1,-520(s0)
    80004554:	bfe9                	j	8000452e <exec+0x2e8>
  sz = sz1;
    80004556:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000455a:	4a81                	li	s5,0
    8000455c:	bfc9                	j	8000452e <exec+0x2e8>
  sz = sz1;
    8000455e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004562:	4a81                	li	s5,0
    80004564:	b7e9                	j	8000452e <exec+0x2e8>
  sz = sz1;
    80004566:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000456a:	4a81                	li	s5,0
    8000456c:	b7c9                	j	8000452e <exec+0x2e8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000456e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004572:	e0843783          	ld	a5,-504(s0)
    80004576:	0017869b          	addiw	a3,a5,1
    8000457a:	e0d43423          	sd	a3,-504(s0)
    8000457e:	e0043783          	ld	a5,-512(s0)
    80004582:	0387879b          	addiw	a5,a5,56
    80004586:	e8845703          	lhu	a4,-376(s0)
    8000458a:	e0e6d8e3          	bge	a3,a4,8000439a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000458e:	2781                	sext.w	a5,a5
    80004590:	e0f43023          	sd	a5,-512(s0)
    80004594:	03800713          	li	a4,56
    80004598:	86be                	mv	a3,a5
    8000459a:	e1840613          	addi	a2,s0,-488
    8000459e:	4581                	li	a1,0
    800045a0:	8556                	mv	a0,s5
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	a68080e7          	jalr	-1432(ra) # 8000300a <readi>
    800045aa:	03800793          	li	a5,56
    800045ae:	f6f51ee3          	bne	a0,a5,8000452a <exec+0x2e4>
    if(ph.type != ELF_PROG_LOAD)
    800045b2:	e1842783          	lw	a5,-488(s0)
    800045b6:	4705                	li	a4,1
    800045b8:	fae79de3          	bne	a5,a4,80004572 <exec+0x32c>
    if(ph.memsz < ph.filesz)
    800045bc:	e4043603          	ld	a2,-448(s0)
    800045c0:	e3843783          	ld	a5,-456(s0)
    800045c4:	f8f660e3          	bltu	a2,a5,80004544 <exec+0x2fe>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045c8:	e2843783          	ld	a5,-472(s0)
    800045cc:	963e                	add	a2,a2,a5
    800045ce:	f6f66ee3          	bltu	a2,a5,8000454a <exec+0x304>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045d2:	85a6                	mv	a1,s1
    800045d4:	855a                	mv	a0,s6
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	2dc080e7          	jalr	732(ra) # 800008b2 <uvmalloc>
    800045de:	dea43c23          	sd	a0,-520(s0)
    800045e2:	d53d                	beqz	a0,80004550 <exec+0x30a>
    if((ph.vaddr % PGSIZE) != 0)
    800045e4:	e2843c03          	ld	s8,-472(s0)
    800045e8:	de043783          	ld	a5,-544(s0)
    800045ec:	00fc77b3          	and	a5,s8,a5
    800045f0:	ff9d                	bnez	a5,8000452e <exec+0x2e8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045f2:	e2042c83          	lw	s9,-480(s0)
    800045f6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045fa:	f60b8ae3          	beqz	s7,8000456e <exec+0x328>
    800045fe:	89de                	mv	s3,s7
    80004600:	4481                	li	s1,0
    80004602:	bb9d                	j	80004378 <exec+0x132>

0000000080004604 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004604:	7179                	addi	sp,sp,-48
    80004606:	f406                	sd	ra,40(sp)
    80004608:	f022                	sd	s0,32(sp)
    8000460a:	ec26                	sd	s1,24(sp)
    8000460c:	e84a                	sd	s2,16(sp)
    8000460e:	1800                	addi	s0,sp,48
    80004610:	892e                	mv	s2,a1
    80004612:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004614:	fdc40593          	addi	a1,s0,-36
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	b40080e7          	jalr	-1216(ra) # 80002158 <argint>
    80004620:	04054063          	bltz	a0,80004660 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004624:	fdc42703          	lw	a4,-36(s0)
    80004628:	47bd                	li	a5,15
    8000462a:	02e7ed63          	bltu	a5,a4,80004664 <argfd+0x60>
    8000462e:	ffffd097          	auipc	ra,0xffffd
    80004632:	9c4080e7          	jalr	-1596(ra) # 80000ff2 <myproc>
    80004636:	fdc42703          	lw	a4,-36(s0)
    8000463a:	01a70793          	addi	a5,a4,26
    8000463e:	078e                	slli	a5,a5,0x3
    80004640:	953e                	add	a0,a0,a5
    80004642:	611c                	ld	a5,0(a0)
    80004644:	c395                	beqz	a5,80004668 <argfd+0x64>
    return -1;
  if(pfd)
    80004646:	00090463          	beqz	s2,8000464e <argfd+0x4a>
    *pfd = fd;
    8000464a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000464e:	4501                	li	a0,0
  if(pf)
    80004650:	c091                	beqz	s1,80004654 <argfd+0x50>
    *pf = f;
    80004652:	e09c                	sd	a5,0(s1)
}
    80004654:	70a2                	ld	ra,40(sp)
    80004656:	7402                	ld	s0,32(sp)
    80004658:	64e2                	ld	s1,24(sp)
    8000465a:	6942                	ld	s2,16(sp)
    8000465c:	6145                	addi	sp,sp,48
    8000465e:	8082                	ret
    return -1;
    80004660:	557d                	li	a0,-1
    80004662:	bfcd                	j	80004654 <argfd+0x50>
    return -1;
    80004664:	557d                	li	a0,-1
    80004666:	b7fd                	j	80004654 <argfd+0x50>
    80004668:	557d                	li	a0,-1
    8000466a:	b7ed                	j	80004654 <argfd+0x50>

000000008000466c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000466c:	1101                	addi	sp,sp,-32
    8000466e:	ec06                	sd	ra,24(sp)
    80004670:	e822                	sd	s0,16(sp)
    80004672:	e426                	sd	s1,8(sp)
    80004674:	1000                	addi	s0,sp,32
    80004676:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004678:	ffffd097          	auipc	ra,0xffffd
    8000467c:	97a080e7          	jalr	-1670(ra) # 80000ff2 <myproc>
    80004680:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004682:	0d050793          	addi	a5,a0,208
    80004686:	4501                	li	a0,0
    80004688:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000468a:	6398                	ld	a4,0(a5)
    8000468c:	cb19                	beqz	a4,800046a2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000468e:	2505                	addiw	a0,a0,1
    80004690:	07a1                	addi	a5,a5,8
    80004692:	fed51ce3          	bne	a0,a3,8000468a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004696:	557d                	li	a0,-1
}
    80004698:	60e2                	ld	ra,24(sp)
    8000469a:	6442                	ld	s0,16(sp)
    8000469c:	64a2                	ld	s1,8(sp)
    8000469e:	6105                	addi	sp,sp,32
    800046a0:	8082                	ret
      p->ofile[fd] = f;
    800046a2:	01a50793          	addi	a5,a0,26
    800046a6:	078e                	slli	a5,a5,0x3
    800046a8:	963e                	add	a2,a2,a5
    800046aa:	e204                	sd	s1,0(a2)
      return fd;
    800046ac:	b7f5                	j	80004698 <fdalloc+0x2c>

00000000800046ae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ae:	715d                	addi	sp,sp,-80
    800046b0:	e486                	sd	ra,72(sp)
    800046b2:	e0a2                	sd	s0,64(sp)
    800046b4:	fc26                	sd	s1,56(sp)
    800046b6:	f84a                	sd	s2,48(sp)
    800046b8:	f44e                	sd	s3,40(sp)
    800046ba:	f052                	sd	s4,32(sp)
    800046bc:	ec56                	sd	s5,24(sp)
    800046be:	0880                	addi	s0,sp,80
    800046c0:	89ae                	mv	s3,a1
    800046c2:	8ab2                	mv	s5,a2
    800046c4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046c6:	fb040593          	addi	a1,s0,-80
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	e60080e7          	jalr	-416(ra) # 8000352a <nameiparent>
    800046d2:	892a                	mv	s2,a0
    800046d4:	12050e63          	beqz	a0,80004810 <create+0x162>
    return 0;

  ilock(dp);
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	67e080e7          	jalr	1662(ra) # 80002d56 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046e0:	4601                	li	a2,0
    800046e2:	fb040593          	addi	a1,s0,-80
    800046e6:	854a                	mv	a0,s2
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	b52080e7          	jalr	-1198(ra) # 8000323a <dirlookup>
    800046f0:	84aa                	mv	s1,a0
    800046f2:	c921                	beqz	a0,80004742 <create+0x94>
    iunlockput(dp);
    800046f4:	854a                	mv	a0,s2
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	8c2080e7          	jalr	-1854(ra) # 80002fb8 <iunlockput>
    ilock(ip);
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	656080e7          	jalr	1622(ra) # 80002d56 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004708:	2981                	sext.w	s3,s3
    8000470a:	4789                	li	a5,2
    8000470c:	02f99463          	bne	s3,a5,80004734 <create+0x86>
    80004710:	0444d783          	lhu	a5,68(s1)
    80004714:	37f9                	addiw	a5,a5,-2
    80004716:	17c2                	slli	a5,a5,0x30
    80004718:	93c1                	srli	a5,a5,0x30
    8000471a:	4705                	li	a4,1
    8000471c:	00f76c63          	bltu	a4,a5,80004734 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004720:	8526                	mv	a0,s1
    80004722:	60a6                	ld	ra,72(sp)
    80004724:	6406                	ld	s0,64(sp)
    80004726:	74e2                	ld	s1,56(sp)
    80004728:	7942                	ld	s2,48(sp)
    8000472a:	79a2                	ld	s3,40(sp)
    8000472c:	7a02                	ld	s4,32(sp)
    8000472e:	6ae2                	ld	s5,24(sp)
    80004730:	6161                	addi	sp,sp,80
    80004732:	8082                	ret
    iunlockput(ip);
    80004734:	8526                	mv	a0,s1
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	882080e7          	jalr	-1918(ra) # 80002fb8 <iunlockput>
    return 0;
    8000473e:	4481                	li	s1,0
    80004740:	b7c5                	j	80004720 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004742:	85ce                	mv	a1,s3
    80004744:	00092503          	lw	a0,0(s2)
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	476080e7          	jalr	1142(ra) # 80002bbe <ialloc>
    80004750:	84aa                	mv	s1,a0
    80004752:	c521                	beqz	a0,8000479a <create+0xec>
  ilock(ip);
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	602080e7          	jalr	1538(ra) # 80002d56 <ilock>
  ip->major = major;
    8000475c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004760:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004764:	4a05                	li	s4,1
    80004766:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000476a:	8526                	mv	a0,s1
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	520080e7          	jalr	1312(ra) # 80002c8c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004774:	2981                	sext.w	s3,s3
    80004776:	03498a63          	beq	s3,s4,800047aa <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000477a:	40d0                	lw	a2,4(s1)
    8000477c:	fb040593          	addi	a1,s0,-80
    80004780:	854a                	mv	a0,s2
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	cc8080e7          	jalr	-824(ra) # 8000344a <dirlink>
    8000478a:	06054b63          	bltz	a0,80004800 <create+0x152>
  iunlockput(dp);
    8000478e:	854a                	mv	a0,s2
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	828080e7          	jalr	-2008(ra) # 80002fb8 <iunlockput>
  return ip;
    80004798:	b761                	j	80004720 <create+0x72>
    panic("create: ialloc");
    8000479a:	00004517          	auipc	a0,0x4
    8000479e:	f4e50513          	addi	a0,a0,-178 # 800086e8 <syscalls+0x2e8>
    800047a2:	00001097          	auipc	ra,0x1
    800047a6:	632080e7          	jalr	1586(ra) # 80005dd4 <panic>
    dp->nlink++;  // for ".."
    800047aa:	04a95783          	lhu	a5,74(s2)
    800047ae:	2785                	addiw	a5,a5,1
    800047b0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047b4:	854a                	mv	a0,s2
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	4d6080e7          	jalr	1238(ra) # 80002c8c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047be:	40d0                	lw	a2,4(s1)
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	f3858593          	addi	a1,a1,-200 # 800086f8 <syscalls+0x2f8>
    800047c8:	8526                	mv	a0,s1
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	c80080e7          	jalr	-896(ra) # 8000344a <dirlink>
    800047d2:	00054f63          	bltz	a0,800047f0 <create+0x142>
    800047d6:	00492603          	lw	a2,4(s2)
    800047da:	00004597          	auipc	a1,0x4
    800047de:	97e58593          	addi	a1,a1,-1666 # 80008158 <etext+0x158>
    800047e2:	8526                	mv	a0,s1
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	c66080e7          	jalr	-922(ra) # 8000344a <dirlink>
    800047ec:	f80557e3          	bgez	a0,8000477a <create+0xcc>
      panic("create dots");
    800047f0:	00004517          	auipc	a0,0x4
    800047f4:	f1050513          	addi	a0,a0,-240 # 80008700 <syscalls+0x300>
    800047f8:	00001097          	auipc	ra,0x1
    800047fc:	5dc080e7          	jalr	1500(ra) # 80005dd4 <panic>
    panic("create: dirlink");
    80004800:	00004517          	auipc	a0,0x4
    80004804:	f1050513          	addi	a0,a0,-240 # 80008710 <syscalls+0x310>
    80004808:	00001097          	auipc	ra,0x1
    8000480c:	5cc080e7          	jalr	1484(ra) # 80005dd4 <panic>
    return 0;
    80004810:	84aa                	mv	s1,a0
    80004812:	b739                	j	80004720 <create+0x72>

0000000080004814 <sys_dup>:
{
    80004814:	7179                	addi	sp,sp,-48
    80004816:	f406                	sd	ra,40(sp)
    80004818:	f022                	sd	s0,32(sp)
    8000481a:	ec26                	sd	s1,24(sp)
    8000481c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000481e:	fd840613          	addi	a2,s0,-40
    80004822:	4581                	li	a1,0
    80004824:	4501                	li	a0,0
    80004826:	00000097          	auipc	ra,0x0
    8000482a:	dde080e7          	jalr	-546(ra) # 80004604 <argfd>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004830:	02054363          	bltz	a0,80004856 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004834:	fd843503          	ld	a0,-40(s0)
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	e34080e7          	jalr	-460(ra) # 8000466c <fdalloc>
    80004840:	84aa                	mv	s1,a0
    return -1;
    80004842:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004844:	00054963          	bltz	a0,80004856 <sys_dup+0x42>
  filedup(f);
    80004848:	fd843503          	ld	a0,-40(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	356080e7          	jalr	854(ra) # 80003ba2 <filedup>
  return fd;
    80004854:	87a6                	mv	a5,s1
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	64e2                	ld	s1,24(sp)
    8000485e:	6145                	addi	sp,sp,48
    80004860:	8082                	ret

0000000080004862 <sys_read>:
{
    80004862:	7179                	addi	sp,sp,-48
    80004864:	f406                	sd	ra,40(sp)
    80004866:	f022                	sd	s0,32(sp)
    80004868:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	fe840613          	addi	a2,s0,-24
    8000486e:	4581                	li	a1,0
    80004870:	4501                	li	a0,0
    80004872:	00000097          	auipc	ra,0x0
    80004876:	d92080e7          	jalr	-622(ra) # 80004604 <argfd>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	04054163          	bltz	a0,800048be <sys_read+0x5c>
    80004880:	fe440593          	addi	a1,s0,-28
    80004884:	4509                	li	a0,2
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	8d2080e7          	jalr	-1838(ra) # 80002158 <argint>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004890:	02054763          	bltz	a0,800048be <sys_read+0x5c>
    80004894:	fd840593          	addi	a1,s0,-40
    80004898:	4505                	li	a0,1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	8e0080e7          	jalr	-1824(ra) # 8000217a <argaddr>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a4:	00054d63          	bltz	a0,800048be <sys_read+0x5c>
  return fileread(f, p, n);
    800048a8:	fe442603          	lw	a2,-28(s0)
    800048ac:	fd843583          	ld	a1,-40(s0)
    800048b0:	fe843503          	ld	a0,-24(s0)
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	47a080e7          	jalr	1146(ra) # 80003d2e <fileread>
    800048bc:	87aa                	mv	a5,a0
}
    800048be:	853e                	mv	a0,a5
    800048c0:	70a2                	ld	ra,40(sp)
    800048c2:	7402                	ld	s0,32(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret

00000000800048c8 <sys_write>:
{
    800048c8:	7179                	addi	sp,sp,-48
    800048ca:	f406                	sd	ra,40(sp)
    800048cc:	f022                	sd	s0,32(sp)
    800048ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	fe840613          	addi	a2,s0,-24
    800048d4:	4581                	li	a1,0
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	d2c080e7          	jalr	-724(ra) # 80004604 <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e2:	04054163          	bltz	a0,80004924 <sys_write+0x5c>
    800048e6:	fe440593          	addi	a1,s0,-28
    800048ea:	4509                	li	a0,2
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	86c080e7          	jalr	-1940(ra) # 80002158 <argint>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f6:	02054763          	bltz	a0,80004924 <sys_write+0x5c>
    800048fa:	fd840593          	addi	a1,s0,-40
    800048fe:	4505                	li	a0,1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	87a080e7          	jalr	-1926(ra) # 8000217a <argaddr>
    return -1;
    80004908:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000490a:	00054d63          	bltz	a0,80004924 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000490e:	fe442603          	lw	a2,-28(s0)
    80004912:	fd843583          	ld	a1,-40(s0)
    80004916:	fe843503          	ld	a0,-24(s0)
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	4d6080e7          	jalr	1238(ra) # 80003df0 <filewrite>
    80004922:	87aa                	mv	a5,a0
}
    80004924:	853e                	mv	a0,a5
    80004926:	70a2                	ld	ra,40(sp)
    80004928:	7402                	ld	s0,32(sp)
    8000492a:	6145                	addi	sp,sp,48
    8000492c:	8082                	ret

000000008000492e <sys_close>:
{
    8000492e:	1101                	addi	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004936:	fe040613          	addi	a2,s0,-32
    8000493a:	fec40593          	addi	a1,s0,-20
    8000493e:	4501                	li	a0,0
    80004940:	00000097          	auipc	ra,0x0
    80004944:	cc4080e7          	jalr	-828(ra) # 80004604 <argfd>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000494a:	02054463          	bltz	a0,80004972 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000494e:	ffffc097          	auipc	ra,0xffffc
    80004952:	6a4080e7          	jalr	1700(ra) # 80000ff2 <myproc>
    80004956:	fec42783          	lw	a5,-20(s0)
    8000495a:	07e9                	addi	a5,a5,26
    8000495c:	078e                	slli	a5,a5,0x3
    8000495e:	97aa                	add	a5,a5,a0
    80004960:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004964:	fe043503          	ld	a0,-32(s0)
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	28c080e7          	jalr	652(ra) # 80003bf4 <fileclose>
  return 0;
    80004970:	4781                	li	a5,0
}
    80004972:	853e                	mv	a0,a5
    80004974:	60e2                	ld	ra,24(sp)
    80004976:	6442                	ld	s0,16(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <sys_fstat>:
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004984:	fe840613          	addi	a2,s0,-24
    80004988:	4581                	li	a1,0
    8000498a:	4501                	li	a0,0
    8000498c:	00000097          	auipc	ra,0x0
    80004990:	c78080e7          	jalr	-904(ra) # 80004604 <argfd>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004996:	02054563          	bltz	a0,800049c0 <sys_fstat+0x44>
    8000499a:	fe040593          	addi	a1,s0,-32
    8000499e:	4505                	li	a0,1
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	7da080e7          	jalr	2010(ra) # 8000217a <argaddr>
    return -1;
    800049a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049aa:	00054b63          	bltz	a0,800049c0 <sys_fstat+0x44>
  return filestat(f, st);
    800049ae:	fe043583          	ld	a1,-32(s0)
    800049b2:	fe843503          	ld	a0,-24(s0)
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	306080e7          	jalr	774(ra) # 80003cbc <filestat>
    800049be:	87aa                	mv	a5,a0
}
    800049c0:	853e                	mv	a0,a5
    800049c2:	60e2                	ld	ra,24(sp)
    800049c4:	6442                	ld	s0,16(sp)
    800049c6:	6105                	addi	sp,sp,32
    800049c8:	8082                	ret

00000000800049ca <sys_link>:
{
    800049ca:	7169                	addi	sp,sp,-304
    800049cc:	f606                	sd	ra,296(sp)
    800049ce:	f222                	sd	s0,288(sp)
    800049d0:	ee26                	sd	s1,280(sp)
    800049d2:	ea4a                	sd	s2,272(sp)
    800049d4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d6:	08000613          	li	a2,128
    800049da:	ed040593          	addi	a1,s0,-304
    800049de:	4501                	li	a0,0
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	7bc080e7          	jalr	1980(ra) # 8000219c <argstr>
    return -1;
    800049e8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ea:	10054e63          	bltz	a0,80004b06 <sys_link+0x13c>
    800049ee:	08000613          	li	a2,128
    800049f2:	f5040593          	addi	a1,s0,-176
    800049f6:	4505                	li	a0,1
    800049f8:	ffffd097          	auipc	ra,0xffffd
    800049fc:	7a4080e7          	jalr	1956(ra) # 8000219c <argstr>
    return -1;
    80004a00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a02:	10054263          	bltz	a0,80004b06 <sys_link+0x13c>
  begin_op();
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	d22080e7          	jalr	-734(ra) # 80003728 <begin_op>
  if((ip = namei(old)) == 0){
    80004a0e:	ed040513          	addi	a0,s0,-304
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	afa080e7          	jalr	-1286(ra) # 8000350c <namei>
    80004a1a:	84aa                	mv	s1,a0
    80004a1c:	c551                	beqz	a0,80004aa8 <sys_link+0xde>
  ilock(ip);
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	338080e7          	jalr	824(ra) # 80002d56 <ilock>
  if(ip->type == T_DIR){
    80004a26:	04449703          	lh	a4,68(s1)
    80004a2a:	4785                	li	a5,1
    80004a2c:	08f70463          	beq	a4,a5,80004ab4 <sys_link+0xea>
  ip->nlink++;
    80004a30:	04a4d783          	lhu	a5,74(s1)
    80004a34:	2785                	addiw	a5,a5,1
    80004a36:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	250080e7          	jalr	592(ra) # 80002c8c <iupdate>
  iunlock(ip);
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	3d2080e7          	jalr	978(ra) # 80002e18 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a4e:	fd040593          	addi	a1,s0,-48
    80004a52:	f5040513          	addi	a0,s0,-176
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	ad4080e7          	jalr	-1324(ra) # 8000352a <nameiparent>
    80004a5e:	892a                	mv	s2,a0
    80004a60:	c935                	beqz	a0,80004ad4 <sys_link+0x10a>
  ilock(dp);
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	2f4080e7          	jalr	756(ra) # 80002d56 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a6a:	00092703          	lw	a4,0(s2)
    80004a6e:	409c                	lw	a5,0(s1)
    80004a70:	04f71d63          	bne	a4,a5,80004aca <sys_link+0x100>
    80004a74:	40d0                	lw	a2,4(s1)
    80004a76:	fd040593          	addi	a1,s0,-48
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	9ce080e7          	jalr	-1586(ra) # 8000344a <dirlink>
    80004a84:	04054363          	bltz	a0,80004aca <sys_link+0x100>
  iunlockput(dp);
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	52e080e7          	jalr	1326(ra) # 80002fb8 <iunlockput>
  iput(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	47c080e7          	jalr	1148(ra) # 80002f10 <iput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	d0c080e7          	jalr	-756(ra) # 800037a8 <end_op>
  return 0;
    80004aa4:	4781                	li	a5,0
    80004aa6:	a085                	j	80004b06 <sys_link+0x13c>
    end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	d00080e7          	jalr	-768(ra) # 800037a8 <end_op>
    return -1;
    80004ab0:	57fd                	li	a5,-1
    80004ab2:	a891                	j	80004b06 <sys_link+0x13c>
    iunlockput(ip);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	502080e7          	jalr	1282(ra) # 80002fb8 <iunlockput>
    end_op();
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	cea080e7          	jalr	-790(ra) # 800037a8 <end_op>
    return -1;
    80004ac6:	57fd                	li	a5,-1
    80004ac8:	a83d                	j	80004b06 <sys_link+0x13c>
    iunlockput(dp);
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	4ec080e7          	jalr	1260(ra) # 80002fb8 <iunlockput>
  ilock(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	280080e7          	jalr	640(ra) # 80002d56 <ilock>
  ip->nlink--;
    80004ade:	04a4d783          	lhu	a5,74(s1)
    80004ae2:	37fd                	addiw	a5,a5,-1
    80004ae4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	1a2080e7          	jalr	418(ra) # 80002c8c <iupdate>
  iunlockput(ip);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	4c4080e7          	jalr	1220(ra) # 80002fb8 <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	cac080e7          	jalr	-852(ra) # 800037a8 <end_op>
  return -1;
    80004b04:	57fd                	li	a5,-1
}
    80004b06:	853e                	mv	a0,a5
    80004b08:	70b2                	ld	ra,296(sp)
    80004b0a:	7412                	ld	s0,288(sp)
    80004b0c:	64f2                	ld	s1,280(sp)
    80004b0e:	6952                	ld	s2,272(sp)
    80004b10:	6155                	addi	sp,sp,304
    80004b12:	8082                	ret

0000000080004b14 <sys_unlink>:
{
    80004b14:	7151                	addi	sp,sp,-240
    80004b16:	f586                	sd	ra,232(sp)
    80004b18:	f1a2                	sd	s0,224(sp)
    80004b1a:	eda6                	sd	s1,216(sp)
    80004b1c:	e9ca                	sd	s2,208(sp)
    80004b1e:	e5ce                	sd	s3,200(sp)
    80004b20:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b22:	08000613          	li	a2,128
    80004b26:	f3040593          	addi	a1,s0,-208
    80004b2a:	4501                	li	a0,0
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	670080e7          	jalr	1648(ra) # 8000219c <argstr>
    80004b34:	18054163          	bltz	a0,80004cb6 <sys_unlink+0x1a2>
  begin_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	bf0080e7          	jalr	-1040(ra) # 80003728 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b40:	fb040593          	addi	a1,s0,-80
    80004b44:	f3040513          	addi	a0,s0,-208
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	9e2080e7          	jalr	-1566(ra) # 8000352a <nameiparent>
    80004b50:	84aa                	mv	s1,a0
    80004b52:	c979                	beqz	a0,80004c28 <sys_unlink+0x114>
  ilock(dp);
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	202080e7          	jalr	514(ra) # 80002d56 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b5c:	00004597          	auipc	a1,0x4
    80004b60:	b9c58593          	addi	a1,a1,-1124 # 800086f8 <syscalls+0x2f8>
    80004b64:	fb040513          	addi	a0,s0,-80
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	6b8080e7          	jalr	1720(ra) # 80003220 <namecmp>
    80004b70:	14050a63          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
    80004b74:	00003597          	auipc	a1,0x3
    80004b78:	5e458593          	addi	a1,a1,1508 # 80008158 <etext+0x158>
    80004b7c:	fb040513          	addi	a0,s0,-80
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	6a0080e7          	jalr	1696(ra) # 80003220 <namecmp>
    80004b88:	12050e63          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b8c:	f2c40613          	addi	a2,s0,-212
    80004b90:	fb040593          	addi	a1,s0,-80
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	6a4080e7          	jalr	1700(ra) # 8000323a <dirlookup>
    80004b9e:	892a                	mv	s2,a0
    80004ba0:	12050263          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
  ilock(ip);
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	1b2080e7          	jalr	434(ra) # 80002d56 <ilock>
  if(ip->nlink < 1)
    80004bac:	04a91783          	lh	a5,74(s2)
    80004bb0:	08f05263          	blez	a5,80004c34 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bb4:	04491703          	lh	a4,68(s2)
    80004bb8:	4785                	li	a5,1
    80004bba:	08f70563          	beq	a4,a5,80004c44 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bbe:	4641                	li	a2,16
    80004bc0:	4581                	li	a1,0
    80004bc2:	fc040513          	addi	a0,s0,-64
    80004bc6:	ffffb097          	auipc	ra,0xffffb
    80004bca:	5b2080e7          	jalr	1458(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bce:	4741                	li	a4,16
    80004bd0:	f2c42683          	lw	a3,-212(s0)
    80004bd4:	fc040613          	addi	a2,s0,-64
    80004bd8:	4581                	li	a1,0
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	526080e7          	jalr	1318(ra) # 80003102 <writei>
    80004be4:	47c1                	li	a5,16
    80004be6:	0af51563          	bne	a0,a5,80004c90 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bea:	04491703          	lh	a4,68(s2)
    80004bee:	4785                	li	a5,1
    80004bf0:	0af70863          	beq	a4,a5,80004ca0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	3c2080e7          	jalr	962(ra) # 80002fb8 <iunlockput>
  ip->nlink--;
    80004bfe:	04a95783          	lhu	a5,74(s2)
    80004c02:	37fd                	addiw	a5,a5,-1
    80004c04:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c08:	854a                	mv	a0,s2
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	082080e7          	jalr	130(ra) # 80002c8c <iupdate>
  iunlockput(ip);
    80004c12:	854a                	mv	a0,s2
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	3a4080e7          	jalr	932(ra) # 80002fb8 <iunlockput>
  end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	b8c080e7          	jalr	-1140(ra) # 800037a8 <end_op>
  return 0;
    80004c24:	4501                	li	a0,0
    80004c26:	a84d                	j	80004cd8 <sys_unlink+0x1c4>
    end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	b80080e7          	jalr	-1152(ra) # 800037a8 <end_op>
    return -1;
    80004c30:	557d                	li	a0,-1
    80004c32:	a05d                	j	80004cd8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c34:	00004517          	auipc	a0,0x4
    80004c38:	aec50513          	addi	a0,a0,-1300 # 80008720 <syscalls+0x320>
    80004c3c:	00001097          	auipc	ra,0x1
    80004c40:	198080e7          	jalr	408(ra) # 80005dd4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c44:	04c92703          	lw	a4,76(s2)
    80004c48:	02000793          	li	a5,32
    80004c4c:	f6e7f9e3          	bgeu	a5,a4,80004bbe <sys_unlink+0xaa>
    80004c50:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c54:	4741                	li	a4,16
    80004c56:	86ce                	mv	a3,s3
    80004c58:	f1840613          	addi	a2,s0,-232
    80004c5c:	4581                	li	a1,0
    80004c5e:	854a                	mv	a0,s2
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	3aa080e7          	jalr	938(ra) # 8000300a <readi>
    80004c68:	47c1                	li	a5,16
    80004c6a:	00f51b63          	bne	a0,a5,80004c80 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c6e:	f1845783          	lhu	a5,-232(s0)
    80004c72:	e7a1                	bnez	a5,80004cba <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c74:	29c1                	addiw	s3,s3,16
    80004c76:	04c92783          	lw	a5,76(s2)
    80004c7a:	fcf9ede3          	bltu	s3,a5,80004c54 <sys_unlink+0x140>
    80004c7e:	b781                	j	80004bbe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c80:	00004517          	auipc	a0,0x4
    80004c84:	ab850513          	addi	a0,a0,-1352 # 80008738 <syscalls+0x338>
    80004c88:	00001097          	auipc	ra,0x1
    80004c8c:	14c080e7          	jalr	332(ra) # 80005dd4 <panic>
    panic("unlink: writei");
    80004c90:	00004517          	auipc	a0,0x4
    80004c94:	ac050513          	addi	a0,a0,-1344 # 80008750 <syscalls+0x350>
    80004c98:	00001097          	auipc	ra,0x1
    80004c9c:	13c080e7          	jalr	316(ra) # 80005dd4 <panic>
    dp->nlink--;
    80004ca0:	04a4d783          	lhu	a5,74(s1)
    80004ca4:	37fd                	addiw	a5,a5,-1
    80004ca6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004caa:	8526                	mv	a0,s1
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	fe0080e7          	jalr	-32(ra) # 80002c8c <iupdate>
    80004cb4:	b781                	j	80004bf4 <sys_unlink+0xe0>
    return -1;
    80004cb6:	557d                	li	a0,-1
    80004cb8:	a005                	j	80004cd8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cba:	854a                	mv	a0,s2
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	2fc080e7          	jalr	764(ra) # 80002fb8 <iunlockput>
  iunlockput(dp);
    80004cc4:	8526                	mv	a0,s1
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	2f2080e7          	jalr	754(ra) # 80002fb8 <iunlockput>
  end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	ada080e7          	jalr	-1318(ra) # 800037a8 <end_op>
  return -1;
    80004cd6:	557d                	li	a0,-1
}
    80004cd8:	70ae                	ld	ra,232(sp)
    80004cda:	740e                	ld	s0,224(sp)
    80004cdc:	64ee                	ld	s1,216(sp)
    80004cde:	694e                	ld	s2,208(sp)
    80004ce0:	69ae                	ld	s3,200(sp)
    80004ce2:	616d                	addi	sp,sp,240
    80004ce4:	8082                	ret

0000000080004ce6 <sys_open>:

uint64
sys_open(void)
{
    80004ce6:	7131                	addi	sp,sp,-192
    80004ce8:	fd06                	sd	ra,184(sp)
    80004cea:	f922                	sd	s0,176(sp)
    80004cec:	f526                	sd	s1,168(sp)
    80004cee:	f14a                	sd	s2,160(sp)
    80004cf0:	ed4e                	sd	s3,152(sp)
    80004cf2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cf4:	08000613          	li	a2,128
    80004cf8:	f5040593          	addi	a1,s0,-176
    80004cfc:	4501                	li	a0,0
    80004cfe:	ffffd097          	auipc	ra,0xffffd
    80004d02:	49e080e7          	jalr	1182(ra) # 8000219c <argstr>
    return -1;
    80004d06:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d08:	0c054163          	bltz	a0,80004dca <sys_open+0xe4>
    80004d0c:	f4c40593          	addi	a1,s0,-180
    80004d10:	4505                	li	a0,1
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	446080e7          	jalr	1094(ra) # 80002158 <argint>
    80004d1a:	0a054863          	bltz	a0,80004dca <sys_open+0xe4>

  begin_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	a0a080e7          	jalr	-1526(ra) # 80003728 <begin_op>

  if(omode & O_CREATE){
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	2007f793          	andi	a5,a5,512
    80004d2e:	cbdd                	beqz	a5,80004de4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d30:	4681                	li	a3,0
    80004d32:	4601                	li	a2,0
    80004d34:	4589                	li	a1,2
    80004d36:	f5040513          	addi	a0,s0,-176
    80004d3a:	00000097          	auipc	ra,0x0
    80004d3e:	974080e7          	jalr	-1676(ra) # 800046ae <create>
    80004d42:	892a                	mv	s2,a0
    if(ip == 0){
    80004d44:	c959                	beqz	a0,80004dda <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d46:	04491703          	lh	a4,68(s2)
    80004d4a:	478d                	li	a5,3
    80004d4c:	00f71763          	bne	a4,a5,80004d5a <sys_open+0x74>
    80004d50:	04695703          	lhu	a4,70(s2)
    80004d54:	47a5                	li	a5,9
    80004d56:	0ce7ec63          	bltu	a5,a4,80004e2e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	dde080e7          	jalr	-546(ra) # 80003b38 <filealloc>
    80004d62:	89aa                	mv	s3,a0
    80004d64:	10050263          	beqz	a0,80004e68 <sys_open+0x182>
    80004d68:	00000097          	auipc	ra,0x0
    80004d6c:	904080e7          	jalr	-1788(ra) # 8000466c <fdalloc>
    80004d70:	84aa                	mv	s1,a0
    80004d72:	0e054663          	bltz	a0,80004e5e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d76:	04491703          	lh	a4,68(s2)
    80004d7a:	478d                	li	a5,3
    80004d7c:	0cf70463          	beq	a4,a5,80004e44 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d80:	4789                	li	a5,2
    80004d82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d8a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d8e:	f4c42783          	lw	a5,-180(s0)
    80004d92:	0017c713          	xori	a4,a5,1
    80004d96:	8b05                	andi	a4,a4,1
    80004d98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d9c:	0037f713          	andi	a4,a5,3
    80004da0:	00e03733          	snez	a4,a4
    80004da4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004da8:	4007f793          	andi	a5,a5,1024
    80004dac:	c791                	beqz	a5,80004db8 <sys_open+0xd2>
    80004dae:	04491703          	lh	a4,68(s2)
    80004db2:	4789                	li	a5,2
    80004db4:	08f70f63          	beq	a4,a5,80004e52 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	05e080e7          	jalr	94(ra) # 80002e18 <iunlock>
  end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	9e6080e7          	jalr	-1562(ra) # 800037a8 <end_op>

  return fd;
}
    80004dca:	8526                	mv	a0,s1
    80004dcc:	70ea                	ld	ra,184(sp)
    80004dce:	744a                	ld	s0,176(sp)
    80004dd0:	74aa                	ld	s1,168(sp)
    80004dd2:	790a                	ld	s2,160(sp)
    80004dd4:	69ea                	ld	s3,152(sp)
    80004dd6:	6129                	addi	sp,sp,192
    80004dd8:	8082                	ret
      end_op();
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	9ce080e7          	jalr	-1586(ra) # 800037a8 <end_op>
      return -1;
    80004de2:	b7e5                	j	80004dca <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004de4:	f5040513          	addi	a0,s0,-176
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	724080e7          	jalr	1828(ra) # 8000350c <namei>
    80004df0:	892a                	mv	s2,a0
    80004df2:	c905                	beqz	a0,80004e22 <sys_open+0x13c>
    ilock(ip);
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	f62080e7          	jalr	-158(ra) # 80002d56 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dfc:	04491703          	lh	a4,68(s2)
    80004e00:	4785                	li	a5,1
    80004e02:	f4f712e3          	bne	a4,a5,80004d46 <sys_open+0x60>
    80004e06:	f4c42783          	lw	a5,-180(s0)
    80004e0a:	dba1                	beqz	a5,80004d5a <sys_open+0x74>
      iunlockput(ip);
    80004e0c:	854a                	mv	a0,s2
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	1aa080e7          	jalr	426(ra) # 80002fb8 <iunlockput>
      end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	992080e7          	jalr	-1646(ra) # 800037a8 <end_op>
      return -1;
    80004e1e:	54fd                	li	s1,-1
    80004e20:	b76d                	j	80004dca <sys_open+0xe4>
      end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	986080e7          	jalr	-1658(ra) # 800037a8 <end_op>
      return -1;
    80004e2a:	54fd                	li	s1,-1
    80004e2c:	bf79                	j	80004dca <sys_open+0xe4>
    iunlockput(ip);
    80004e2e:	854a                	mv	a0,s2
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	188080e7          	jalr	392(ra) # 80002fb8 <iunlockput>
    end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	970080e7          	jalr	-1680(ra) # 800037a8 <end_op>
    return -1;
    80004e40:	54fd                	li	s1,-1
    80004e42:	b761                	j	80004dca <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e44:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e48:	04691783          	lh	a5,70(s2)
    80004e4c:	02f99223          	sh	a5,36(s3)
    80004e50:	bf2d                	j	80004d8a <sys_open+0xa4>
    itrunc(ip);
    80004e52:	854a                	mv	a0,s2
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	010080e7          	jalr	16(ra) # 80002e64 <itrunc>
    80004e5c:	bfb1                	j	80004db8 <sys_open+0xd2>
      fileclose(f);
    80004e5e:	854e                	mv	a0,s3
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	d94080e7          	jalr	-620(ra) # 80003bf4 <fileclose>
    iunlockput(ip);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	14e080e7          	jalr	334(ra) # 80002fb8 <iunlockput>
    end_op();
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	936080e7          	jalr	-1738(ra) # 800037a8 <end_op>
    return -1;
    80004e7a:	54fd                	li	s1,-1
    80004e7c:	b7b9                	j	80004dca <sys_open+0xe4>

0000000080004e7e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e7e:	7175                	addi	sp,sp,-144
    80004e80:	e506                	sd	ra,136(sp)
    80004e82:	e122                	sd	s0,128(sp)
    80004e84:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	8a2080e7          	jalr	-1886(ra) # 80003728 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e8e:	08000613          	li	a2,128
    80004e92:	f7040593          	addi	a1,s0,-144
    80004e96:	4501                	li	a0,0
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	304080e7          	jalr	772(ra) # 8000219c <argstr>
    80004ea0:	02054963          	bltz	a0,80004ed2 <sys_mkdir+0x54>
    80004ea4:	4681                	li	a3,0
    80004ea6:	4601                	li	a2,0
    80004ea8:	4585                	li	a1,1
    80004eaa:	f7040513          	addi	a0,s0,-144
    80004eae:	00000097          	auipc	ra,0x0
    80004eb2:	800080e7          	jalr	-2048(ra) # 800046ae <create>
    80004eb6:	cd11                	beqz	a0,80004ed2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	100080e7          	jalr	256(ra) # 80002fb8 <iunlockput>
  end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	8e8080e7          	jalr	-1816(ra) # 800037a8 <end_op>
  return 0;
    80004ec8:	4501                	li	a0,0
}
    80004eca:	60aa                	ld	ra,136(sp)
    80004ecc:	640a                	ld	s0,128(sp)
    80004ece:	6149                	addi	sp,sp,144
    80004ed0:	8082                	ret
    end_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	8d6080e7          	jalr	-1834(ra) # 800037a8 <end_op>
    return -1;
    80004eda:	557d                	li	a0,-1
    80004edc:	b7fd                	j	80004eca <sys_mkdir+0x4c>

0000000080004ede <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ede:	7135                	addi	sp,sp,-160
    80004ee0:	ed06                	sd	ra,152(sp)
    80004ee2:	e922                	sd	s0,144(sp)
    80004ee4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	842080e7          	jalr	-1982(ra) # 80003728 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eee:	08000613          	li	a2,128
    80004ef2:	f7040593          	addi	a1,s0,-144
    80004ef6:	4501                	li	a0,0
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	2a4080e7          	jalr	676(ra) # 8000219c <argstr>
    80004f00:	04054a63          	bltz	a0,80004f54 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f04:	f6c40593          	addi	a1,s0,-148
    80004f08:	4505                	li	a0,1
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	24e080e7          	jalr	590(ra) # 80002158 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f12:	04054163          	bltz	a0,80004f54 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f16:	f6840593          	addi	a1,s0,-152
    80004f1a:	4509                	li	a0,2
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	23c080e7          	jalr	572(ra) # 80002158 <argint>
     argint(1, &major) < 0 ||
    80004f24:	02054863          	bltz	a0,80004f54 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f28:	f6841683          	lh	a3,-152(s0)
    80004f2c:	f6c41603          	lh	a2,-148(s0)
    80004f30:	458d                	li	a1,3
    80004f32:	f7040513          	addi	a0,s0,-144
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	778080e7          	jalr	1912(ra) # 800046ae <create>
     argint(2, &minor) < 0 ||
    80004f3e:	c919                	beqz	a0,80004f54 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	078080e7          	jalr	120(ra) # 80002fb8 <iunlockput>
  end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	860080e7          	jalr	-1952(ra) # 800037a8 <end_op>
  return 0;
    80004f50:	4501                	li	a0,0
    80004f52:	a031                	j	80004f5e <sys_mknod+0x80>
    end_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	854080e7          	jalr	-1964(ra) # 800037a8 <end_op>
    return -1;
    80004f5c:	557d                	li	a0,-1
}
    80004f5e:	60ea                	ld	ra,152(sp)
    80004f60:	644a                	ld	s0,144(sp)
    80004f62:	610d                	addi	sp,sp,160
    80004f64:	8082                	ret

0000000080004f66 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f66:	7135                	addi	sp,sp,-160
    80004f68:	ed06                	sd	ra,152(sp)
    80004f6a:	e922                	sd	s0,144(sp)
    80004f6c:	e526                	sd	s1,136(sp)
    80004f6e:	e14a                	sd	s2,128(sp)
    80004f70:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	080080e7          	jalr	128(ra) # 80000ff2 <myproc>
    80004f7a:	892a                	mv	s2,a0
  
  begin_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	7ac080e7          	jalr	1964(ra) # 80003728 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f84:	08000613          	li	a2,128
    80004f88:	f6040593          	addi	a1,s0,-160
    80004f8c:	4501                	li	a0,0
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	20e080e7          	jalr	526(ra) # 8000219c <argstr>
    80004f96:	04054b63          	bltz	a0,80004fec <sys_chdir+0x86>
    80004f9a:	f6040513          	addi	a0,s0,-160
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	56e080e7          	jalr	1390(ra) # 8000350c <namei>
    80004fa6:	84aa                	mv	s1,a0
    80004fa8:	c131                	beqz	a0,80004fec <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	dac080e7          	jalr	-596(ra) # 80002d56 <ilock>
  if(ip->type != T_DIR){
    80004fb2:	04449703          	lh	a4,68(s1)
    80004fb6:	4785                	li	a5,1
    80004fb8:	04f71063          	bne	a4,a5,80004ff8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	e5a080e7          	jalr	-422(ra) # 80002e18 <iunlock>
  iput(p->cwd);
    80004fc6:	15093503          	ld	a0,336(s2)
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	f46080e7          	jalr	-186(ra) # 80002f10 <iput>
  end_op();
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	7d6080e7          	jalr	2006(ra) # 800037a8 <end_op>
  p->cwd = ip;
    80004fda:	14993823          	sd	s1,336(s2)
  return 0;
    80004fde:	4501                	li	a0,0
}
    80004fe0:	60ea                	ld	ra,152(sp)
    80004fe2:	644a                	ld	s0,144(sp)
    80004fe4:	64aa                	ld	s1,136(sp)
    80004fe6:	690a                	ld	s2,128(sp)
    80004fe8:	610d                	addi	sp,sp,160
    80004fea:	8082                	ret
    end_op();
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	7bc080e7          	jalr	1980(ra) # 800037a8 <end_op>
    return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	b7ed                	j	80004fe0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	fbe080e7          	jalr	-66(ra) # 80002fb8 <iunlockput>
    end_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	7a6080e7          	jalr	1958(ra) # 800037a8 <end_op>
    return -1;
    8000500a:	557d                	li	a0,-1
    8000500c:	bfd1                	j	80004fe0 <sys_chdir+0x7a>

000000008000500e <sys_exec>:

uint64
sys_exec(void)
{
    8000500e:	7145                	addi	sp,sp,-464
    80005010:	e786                	sd	ra,456(sp)
    80005012:	e3a2                	sd	s0,448(sp)
    80005014:	ff26                	sd	s1,440(sp)
    80005016:	fb4a                	sd	s2,432(sp)
    80005018:	f74e                	sd	s3,424(sp)
    8000501a:	f352                	sd	s4,416(sp)
    8000501c:	ef56                	sd	s5,408(sp)
    8000501e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005020:	08000613          	li	a2,128
    80005024:	f4040593          	addi	a1,s0,-192
    80005028:	4501                	li	a0,0
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	172080e7          	jalr	370(ra) # 8000219c <argstr>
    return -1;
    80005032:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005034:	0c054a63          	bltz	a0,80005108 <sys_exec+0xfa>
    80005038:	e3840593          	addi	a1,s0,-456
    8000503c:	4505                	li	a0,1
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	13c080e7          	jalr	316(ra) # 8000217a <argaddr>
    80005046:	0c054163          	bltz	a0,80005108 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000504a:	10000613          	li	a2,256
    8000504e:	4581                	li	a1,0
    80005050:	e4040513          	addi	a0,s0,-448
    80005054:	ffffb097          	auipc	ra,0xffffb
    80005058:	124080e7          	jalr	292(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000505c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005060:	89a6                	mv	s3,s1
    80005062:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005064:	02000a13          	li	s4,32
    80005068:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000506c:	00391793          	slli	a5,s2,0x3
    80005070:	e3040593          	addi	a1,s0,-464
    80005074:	e3843503          	ld	a0,-456(s0)
    80005078:	953e                	add	a0,a0,a5
    8000507a:	ffffd097          	auipc	ra,0xffffd
    8000507e:	044080e7          	jalr	68(ra) # 800020be <fetchaddr>
    80005082:	02054a63          	bltz	a0,800050b6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005086:	e3043783          	ld	a5,-464(s0)
    8000508a:	c3b9                	beqz	a5,800050d0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000508c:	ffffb097          	auipc	ra,0xffffb
    80005090:	08c080e7          	jalr	140(ra) # 80000118 <kalloc>
    80005094:	85aa                	mv	a1,a0
    80005096:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000509a:	cd11                	beqz	a0,800050b6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000509c:	6605                	lui	a2,0x1
    8000509e:	e3043503          	ld	a0,-464(s0)
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	06e080e7          	jalr	110(ra) # 80002110 <fetchstr>
    800050aa:	00054663          	bltz	a0,800050b6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050ae:	0905                	addi	s2,s2,1
    800050b0:	09a1                	addi	s3,s3,8
    800050b2:	fb491be3          	bne	s2,s4,80005068 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b6:	10048913          	addi	s2,s1,256
    800050ba:	6088                	ld	a0,0(s1)
    800050bc:	c529                	beqz	a0,80005106 <sys_exec+0xf8>
    kfree(argv[i]);
    800050be:	ffffb097          	auipc	ra,0xffffb
    800050c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c6:	04a1                	addi	s1,s1,8
    800050c8:	ff2499e3          	bne	s1,s2,800050ba <sys_exec+0xac>
  return -1;
    800050cc:	597d                	li	s2,-1
    800050ce:	a82d                	j	80005108 <sys_exec+0xfa>
      argv[i] = 0;
    800050d0:	0a8e                	slli	s5,s5,0x3
    800050d2:	fc040793          	addi	a5,s0,-64
    800050d6:	9abe                	add	s5,s5,a5
    800050d8:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    800050dc:	e4040593          	addi	a1,s0,-448
    800050e0:	f4040513          	addi	a0,s0,-192
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	162080e7          	jalr	354(ra) # 80004246 <exec>
    800050ec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	10048993          	addi	s3,s1,256
    800050f2:	6088                	ld	a0,0(s1)
    800050f4:	c911                	beqz	a0,80005108 <sys_exec+0xfa>
    kfree(argv[i]);
    800050f6:	ffffb097          	auipc	ra,0xffffb
    800050fa:	f26080e7          	jalr	-218(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fe:	04a1                	addi	s1,s1,8
    80005100:	ff3499e3          	bne	s1,s3,800050f2 <sys_exec+0xe4>
    80005104:	a011                	j	80005108 <sys_exec+0xfa>
  return -1;
    80005106:	597d                	li	s2,-1
}
    80005108:	854a                	mv	a0,s2
    8000510a:	60be                	ld	ra,456(sp)
    8000510c:	641e                	ld	s0,448(sp)
    8000510e:	74fa                	ld	s1,440(sp)
    80005110:	795a                	ld	s2,432(sp)
    80005112:	79ba                	ld	s3,424(sp)
    80005114:	7a1a                	ld	s4,416(sp)
    80005116:	6afa                	ld	s5,408(sp)
    80005118:	6179                	addi	sp,sp,464
    8000511a:	8082                	ret

000000008000511c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000511c:	7139                	addi	sp,sp,-64
    8000511e:	fc06                	sd	ra,56(sp)
    80005120:	f822                	sd	s0,48(sp)
    80005122:	f426                	sd	s1,40(sp)
    80005124:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	ecc080e7          	jalr	-308(ra) # 80000ff2 <myproc>
    8000512e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005130:	fd840593          	addi	a1,s0,-40
    80005134:	4501                	li	a0,0
    80005136:	ffffd097          	auipc	ra,0xffffd
    8000513a:	044080e7          	jalr	68(ra) # 8000217a <argaddr>
    return -1;
    8000513e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005140:	0e054063          	bltz	a0,80005220 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005144:	fc840593          	addi	a1,s0,-56
    80005148:	fd040513          	addi	a0,s0,-48
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	dd8080e7          	jalr	-552(ra) # 80003f24 <pipealloc>
    return -1;
    80005154:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005156:	0c054563          	bltz	a0,80005220 <sys_pipe+0x104>
  fd0 = -1;
    8000515a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000515e:	fd043503          	ld	a0,-48(s0)
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	50a080e7          	jalr	1290(ra) # 8000466c <fdalloc>
    8000516a:	fca42223          	sw	a0,-60(s0)
    8000516e:	08054c63          	bltz	a0,80005206 <sys_pipe+0xea>
    80005172:	fc843503          	ld	a0,-56(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	4f6080e7          	jalr	1270(ra) # 8000466c <fdalloc>
    8000517e:	fca42023          	sw	a0,-64(s0)
    80005182:	06054863          	bltz	a0,800051f2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005186:	4691                	li	a3,4
    80005188:	fc440613          	addi	a2,s0,-60
    8000518c:	fd843583          	ld	a1,-40(s0)
    80005190:	68a8                	ld	a0,80(s1)
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	970080e7          	jalr	-1680(ra) # 80000b02 <copyout>
    8000519a:	02054063          	bltz	a0,800051ba <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000519e:	4691                	li	a3,4
    800051a0:	fc040613          	addi	a2,s0,-64
    800051a4:	fd843583          	ld	a1,-40(s0)
    800051a8:	0591                	addi	a1,a1,4
    800051aa:	68a8                	ld	a0,80(s1)
    800051ac:	ffffc097          	auipc	ra,0xffffc
    800051b0:	956080e7          	jalr	-1706(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051b4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b6:	06055563          	bgez	a0,80005220 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051ba:	fc442783          	lw	a5,-60(s0)
    800051be:	07e9                	addi	a5,a5,26
    800051c0:	078e                	slli	a5,a5,0x3
    800051c2:	97a6                	add	a5,a5,s1
    800051c4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051c8:	fc042503          	lw	a0,-64(s0)
    800051cc:	0569                	addi	a0,a0,26
    800051ce:	050e                	slli	a0,a0,0x3
    800051d0:	9526                	add	a0,a0,s1
    800051d2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051d6:	fd043503          	ld	a0,-48(s0)
    800051da:	fffff097          	auipc	ra,0xfffff
    800051de:	a1a080e7          	jalr	-1510(ra) # 80003bf4 <fileclose>
    fileclose(wf);
    800051e2:	fc843503          	ld	a0,-56(s0)
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	a0e080e7          	jalr	-1522(ra) # 80003bf4 <fileclose>
    return -1;
    800051ee:	57fd                	li	a5,-1
    800051f0:	a805                	j	80005220 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051f2:	fc442783          	lw	a5,-60(s0)
    800051f6:	0007c863          	bltz	a5,80005206 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051fa:	01a78513          	addi	a0,a5,26
    800051fe:	050e                	slli	a0,a0,0x3
    80005200:	9526                	add	a0,a0,s1
    80005202:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005206:	fd043503          	ld	a0,-48(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	9ea080e7          	jalr	-1558(ra) # 80003bf4 <fileclose>
    fileclose(wf);
    80005212:	fc843503          	ld	a0,-56(s0)
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	9de080e7          	jalr	-1570(ra) # 80003bf4 <fileclose>
    return -1;
    8000521e:	57fd                	li	a5,-1
}
    80005220:	853e                	mv	a0,a5
    80005222:	70e2                	ld	ra,56(sp)
    80005224:	7442                	ld	s0,48(sp)
    80005226:	74a2                	ld	s1,40(sp)
    80005228:	6121                	addi	sp,sp,64
    8000522a:	8082                	ret
    8000522c:	0000                	unimp
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	addi	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	d1bfc0ef          	jal	ra,80001f8a <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	c3d8                	sw	a4,4(a5)
}
    800052fa:	6422                	ld	s0,8(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plicinithart>:

void
plicinithart(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	cbe080e7          	jalr	-834(ra) # 80000fc6 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005310:	0085171b          	slliw	a4,a0,0x8
    80005314:	0c0027b7          	lui	a5,0xc002
    80005318:	97ba                	add	a5,a5,a4
    8000531a:	40200713          	li	a4,1026
    8000531e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005322:	00d5151b          	slliw	a0,a0,0xd
    80005326:	0c2017b7          	lui	a5,0xc201
    8000532a:	953e                	add	a0,a0,a5
    8000532c:	00052023          	sw	zero,0(a0)
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	ffffc097          	auipc	ra,0xffffc
    80005344:	c86080e7          	jalr	-890(ra) # 80000fc6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005348:	00d5179b          	slliw	a5,a0,0xd
    8000534c:	0c201537          	lui	a0,0xc201
    80005350:	953e                	add	a0,a0,a5
  return irq;
}
    80005352:	4148                	lw	a0,4(a0)
    80005354:	60a2                	ld	ra,8(sp)
    80005356:	6402                	ld	s0,0(sp)
    80005358:	0141                	addi	sp,sp,16
    8000535a:	8082                	ret

000000008000535c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	e426                	sd	s1,8(sp)
    80005364:	1000                	addi	s0,sp,32
    80005366:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	c5e080e7          	jalr	-930(ra) # 80000fc6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005370:	00d5151b          	slliw	a0,a0,0xd
    80005374:	0c2017b7          	lui	a5,0xc201
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	c3c4                	sw	s1,4(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret

0000000080005386 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005386:	1141                	addi	sp,sp,-16
    80005388:	e406                	sd	ra,8(sp)
    8000538a:	e022                	sd	s0,0(sp)
    8000538c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000538e:	479d                	li	a5,7
    80005390:	06a7c963          	blt	a5,a0,80005402 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005394:	00016797          	auipc	a5,0x16
    80005398:	c6c78793          	addi	a5,a5,-916 # 8001b000 <disk>
    8000539c:	00a78733          	add	a4,a5,a0
    800053a0:	6789                	lui	a5,0x2
    800053a2:	97ba                	add	a5,a5,a4
    800053a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053a8:	e7ad                	bnez	a5,80005412 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053aa:	00451793          	slli	a5,a0,0x4
    800053ae:	00018717          	auipc	a4,0x18
    800053b2:	c5270713          	addi	a4,a4,-942 # 8001d000 <disk+0x2000>
    800053b6:	6314                	ld	a3,0(a4)
    800053b8:	96be                	add	a3,a3,a5
    800053ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053be:	6314                	ld	a3,0(a4)
    800053c0:	96be                	add	a3,a3,a5
    800053c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053c6:	6314                	ld	a3,0(a4)
    800053c8:	96be                	add	a3,a3,a5
    800053ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053ce:	6318                	ld	a4,0(a4)
    800053d0:	97ba                	add	a5,a5,a4
    800053d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053d6:	00016797          	auipc	a5,0x16
    800053da:	c2a78793          	addi	a5,a5,-982 # 8001b000 <disk>
    800053de:	97aa                	add	a5,a5,a0
    800053e0:	6509                	lui	a0,0x2
    800053e2:	953e                	add	a0,a0,a5
    800053e4:	4785                	li	a5,1
    800053e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053ea:	00018517          	auipc	a0,0x18
    800053ee:	c2e50513          	addi	a0,a0,-978 # 8001d018 <disk+0x2018>
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	502080e7          	jalr	1282(ra) # 800018f4 <wakeup>
}
    800053fa:	60a2                	ld	ra,8(sp)
    800053fc:	6402                	ld	s0,0(sp)
    800053fe:	0141                	addi	sp,sp,16
    80005400:	8082                	ret
    panic("free_desc 1");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	35e50513          	addi	a0,a0,862 # 80008760 <syscalls+0x360>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	9ca080e7          	jalr	-1590(ra) # 80005dd4 <panic>
    panic("free_desc 2");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	35e50513          	addi	a0,a0,862 # 80008770 <syscalls+0x370>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	9ba080e7          	jalr	-1606(ra) # 80005dd4 <panic>

0000000080005422 <virtio_disk_init>:
{
    80005422:	1101                	addi	sp,sp,-32
    80005424:	ec06                	sd	ra,24(sp)
    80005426:	e822                	sd	s0,16(sp)
    80005428:	e426                	sd	s1,8(sp)
    8000542a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000542c:	00003597          	auipc	a1,0x3
    80005430:	35458593          	addi	a1,a1,852 # 80008780 <syscalls+0x380>
    80005434:	00018517          	auipc	a0,0x18
    80005438:	cf450513          	addi	a0,a0,-780 # 8001d128 <disk+0x2128>
    8000543c:	00001097          	auipc	ra,0x1
    80005440:	e44080e7          	jalr	-444(ra) # 80006280 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	4398                	lw	a4,0(a5)
    8000544a:	2701                	sext.w	a4,a4
    8000544c:	747277b7          	lui	a5,0x74727
    80005450:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005454:	0ef71163          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005458:	100017b7          	lui	a5,0x10001
    8000545c:	43dc                	lw	a5,4(a5)
    8000545e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005460:	4705                	li	a4,1
    80005462:	0ce79a63          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	479c                	lw	a5,8(a5)
    8000546c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000546e:	4709                	li	a4,2
    80005470:	0ce79363          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	47d8                	lw	a4,12(a5)
    8000547a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000547c:	554d47b7          	lui	a5,0x554d4
    80005480:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005484:	0af71963          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	4705                	li	a4,1
    8000548e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	470d                	li	a4,3
    80005492:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005494:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005496:	c7ffe737          	lui	a4,0xc7ffe
    8000549a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000549e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054a0:	2701                	sext.w	a4,a4
    800054a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a4:	472d                	li	a4,11
    800054a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	473d                	li	a4,15
    800054aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054ac:	6705                	lui	a4,0x1
    800054ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054b4:	5bdc                	lw	a5,52(a5)
    800054b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054b8:	c7d9                	beqz	a5,80005546 <virtio_disk_init+0x124>
  if(max < NUM)
    800054ba:	471d                	li	a4,7
    800054bc:	08f77d63          	bgeu	a4,a5,80005556 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054c0:	100014b7          	lui	s1,0x10001
    800054c4:	47a1                	li	a5,8
    800054c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054c8:	6609                	lui	a2,0x2
    800054ca:	4581                	li	a1,0
    800054cc:	00016517          	auipc	a0,0x16
    800054d0:	b3450513          	addi	a0,a0,-1228 # 8001b000 <disk>
    800054d4:	ffffb097          	auipc	ra,0xffffb
    800054d8:	ca4080e7          	jalr	-860(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054dc:	00016717          	auipc	a4,0x16
    800054e0:	b2470713          	addi	a4,a4,-1244 # 8001b000 <disk>
    800054e4:	00c75793          	srli	a5,a4,0xc
    800054e8:	2781                	sext.w	a5,a5
    800054ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054ec:	00018797          	auipc	a5,0x18
    800054f0:	b1478793          	addi	a5,a5,-1260 # 8001d000 <disk+0x2000>
    800054f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054f6:	00016717          	auipc	a4,0x16
    800054fa:	b8a70713          	addi	a4,a4,-1142 # 8001b080 <disk+0x80>
    800054fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005500:	00017717          	auipc	a4,0x17
    80005504:	b0070713          	addi	a4,a4,-1280 # 8001c000 <disk+0x1000>
    80005508:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000550a:	4705                	li	a4,1
    8000550c:	00e78c23          	sb	a4,24(a5)
    80005510:	00e78ca3          	sb	a4,25(a5)
    80005514:	00e78d23          	sb	a4,26(a5)
    80005518:	00e78da3          	sb	a4,27(a5)
    8000551c:	00e78e23          	sb	a4,28(a5)
    80005520:	00e78ea3          	sb	a4,29(a5)
    80005524:	00e78f23          	sb	a4,30(a5)
    80005528:	00e78fa3          	sb	a4,31(a5)
}
    8000552c:	60e2                	ld	ra,24(sp)
    8000552e:	6442                	ld	s0,16(sp)
    80005530:	64a2                	ld	s1,8(sp)
    80005532:	6105                	addi	sp,sp,32
    80005534:	8082                	ret
    panic("could not find virtio disk");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	25a50513          	addi	a0,a0,602 # 80008790 <syscalls+0x390>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	896080e7          	jalr	-1898(ra) # 80005dd4 <panic>
    panic("virtio disk has no queue 0");
    80005546:	00003517          	auipc	a0,0x3
    8000554a:	26a50513          	addi	a0,a0,618 # 800087b0 <syscalls+0x3b0>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	886080e7          	jalr	-1914(ra) # 80005dd4 <panic>
    panic("virtio disk max queue too short");
    80005556:	00003517          	auipc	a0,0x3
    8000555a:	27a50513          	addi	a0,a0,634 # 800087d0 <syscalls+0x3d0>
    8000555e:	00001097          	auipc	ra,0x1
    80005562:	876080e7          	jalr	-1930(ra) # 80005dd4 <panic>

0000000080005566 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005566:	7119                	addi	sp,sp,-128
    80005568:	fc86                	sd	ra,120(sp)
    8000556a:	f8a2                	sd	s0,112(sp)
    8000556c:	f4a6                	sd	s1,104(sp)
    8000556e:	f0ca                	sd	s2,96(sp)
    80005570:	ecce                	sd	s3,88(sp)
    80005572:	e8d2                	sd	s4,80(sp)
    80005574:	e4d6                	sd	s5,72(sp)
    80005576:	e0da                	sd	s6,64(sp)
    80005578:	fc5e                	sd	s7,56(sp)
    8000557a:	f862                	sd	s8,48(sp)
    8000557c:	f466                	sd	s9,40(sp)
    8000557e:	f06a                	sd	s10,32(sp)
    80005580:	ec6e                	sd	s11,24(sp)
    80005582:	0100                	addi	s0,sp,128
    80005584:	8aaa                	mv	s5,a0
    80005586:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005588:	00c52c83          	lw	s9,12(a0)
    8000558c:	001c9c9b          	slliw	s9,s9,0x1
    80005590:	1c82                	slli	s9,s9,0x20
    80005592:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005596:	00018517          	auipc	a0,0x18
    8000559a:	b9250513          	addi	a0,a0,-1134 # 8001d128 <disk+0x2128>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	d72080e7          	jalr	-654(ra) # 80006310 <acquire>
  for(int i = 0; i < 3; i++){
    800055a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055aa:	00016c17          	auipc	s8,0x16
    800055ae:	a56c0c13          	addi	s8,s8,-1450 # 8001b000 <disk>
    800055b2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800055b4:	4b0d                	li	s6,3
    800055b6:	a0ad                	j	80005620 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800055b8:	00fc0733          	add	a4,s8,a5
    800055bc:	975e                	add	a4,a4,s7
    800055be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055c4:	0207c563          	bltz	a5,800055ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055c8:	2905                	addiw	s2,s2,1
    800055ca:	0611                	addi	a2,a2,4
    800055cc:	19690d63          	beq	s2,s6,80005766 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800055d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055d2:	00018717          	auipc	a4,0x18
    800055d6:	a4670713          	addi	a4,a4,-1466 # 8001d018 <disk+0x2018>
    800055da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055dc:	00074683          	lbu	a3,0(a4)
    800055e0:	fee1                	bnez	a3,800055b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055e2:	2785                	addiw	a5,a5,1
    800055e4:	0705                	addi	a4,a4,1
    800055e6:	fe979be3          	bne	a5,s1,800055dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ea:	57fd                	li	a5,-1
    800055ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055ee:	01205d63          	blez	s2,80005608 <virtio_disk_rw+0xa2>
    800055f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055f4:	000a2503          	lw	a0,0(s4)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	d8e080e7          	jalr	-626(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	2d85                	addiw	s11,s11,1
    80005602:	0a11                	addi	s4,s4,4
    80005604:	ffb918e3          	bne	s2,s11,800055f4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005608:	00018597          	auipc	a1,0x18
    8000560c:	b2058593          	addi	a1,a1,-1248 # 8001d128 <disk+0x2128>
    80005610:	00018517          	auipc	a0,0x18
    80005614:	a0850513          	addi	a0,a0,-1528 # 8001d018 <disk+0x2018>
    80005618:	ffffc097          	auipc	ra,0xffffc
    8000561c:	150080e7          	jalr	336(ra) # 80001768 <sleep>
  for(int i = 0; i < 3; i++){
    80005620:	f8040a13          	addi	s4,s0,-128
{
    80005624:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005626:	894e                	mv	s2,s3
    80005628:	b765                	j	800055d0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000562a:	00018697          	auipc	a3,0x18
    8000562e:	9d66b683          	ld	a3,-1578(a3) # 8001d000 <disk+0x2000>
    80005632:	96ba                	add	a3,a3,a4
    80005634:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005638:	00016817          	auipc	a6,0x16
    8000563c:	9c880813          	addi	a6,a6,-1592 # 8001b000 <disk>
    80005640:	00018697          	auipc	a3,0x18
    80005644:	9c068693          	addi	a3,a3,-1600 # 8001d000 <disk+0x2000>
    80005648:	6290                	ld	a2,0(a3)
    8000564a:	963a                	add	a2,a2,a4
    8000564c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005650:	0015e593          	ori	a1,a1,1
    80005654:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005658:	f8842603          	lw	a2,-120(s0)
    8000565c:	628c                	ld	a1,0(a3)
    8000565e:	972e                	add	a4,a4,a1
    80005660:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005664:	20050593          	addi	a1,a0,512
    80005668:	0592                	slli	a1,a1,0x4
    8000566a:	95c2                	add	a1,a1,a6
    8000566c:	577d                	li	a4,-1
    8000566e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005672:	00461713          	slli	a4,a2,0x4
    80005676:	6290                	ld	a2,0(a3)
    80005678:	963a                	add	a2,a2,a4
    8000567a:	03078793          	addi	a5,a5,48
    8000567e:	97c2                	add	a5,a5,a6
    80005680:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005682:	629c                	ld	a5,0(a3)
    80005684:	97ba                	add	a5,a5,a4
    80005686:	4605                	li	a2,1
    80005688:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000568a:	629c                	ld	a5,0(a3)
    8000568c:	97ba                	add	a5,a5,a4
    8000568e:	4809                	li	a6,2
    80005690:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005694:	629c                	ld	a5,0(a3)
    80005696:	973e                	add	a4,a4,a5
    80005698:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000569c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800056a0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056a4:	6698                	ld	a4,8(a3)
    800056a6:	00275783          	lhu	a5,2(a4)
    800056aa:	8b9d                	andi	a5,a5,7
    800056ac:	0786                	slli	a5,a5,0x1
    800056ae:	97ba                	add	a5,a5,a4
    800056b0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800056b4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056b8:	6698                	ld	a4,8(a3)
    800056ba:	00275783          	lhu	a5,2(a4)
    800056be:	2785                	addiw	a5,a5,1
    800056c0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056c4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056c8:	100017b7          	lui	a5,0x10001
    800056cc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056d0:	004aa783          	lw	a5,4(s5)
    800056d4:	02c79163          	bne	a5,a2,800056f6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056d8:	00018917          	auipc	s2,0x18
    800056dc:	a5090913          	addi	s2,s2,-1456 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056e0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056e2:	85ca                	mv	a1,s2
    800056e4:	8556                	mv	a0,s5
    800056e6:	ffffc097          	auipc	ra,0xffffc
    800056ea:	082080e7          	jalr	130(ra) # 80001768 <sleep>
  while(b->disk == 1) {
    800056ee:	004aa783          	lw	a5,4(s5)
    800056f2:	fe9788e3          	beq	a5,s1,800056e2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056f6:	f8042903          	lw	s2,-128(s0)
    800056fa:	20090793          	addi	a5,s2,512
    800056fe:	00479713          	slli	a4,a5,0x4
    80005702:	00016797          	auipc	a5,0x16
    80005706:	8fe78793          	addi	a5,a5,-1794 # 8001b000 <disk>
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005710:	00018997          	auipc	s3,0x18
    80005714:	8f098993          	addi	s3,s3,-1808 # 8001d000 <disk+0x2000>
    80005718:	00491713          	slli	a4,s2,0x4
    8000571c:	0009b783          	ld	a5,0(s3)
    80005720:	97ba                	add	a5,a5,a4
    80005722:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005726:	854a                	mv	a0,s2
    80005728:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000572c:	00000097          	auipc	ra,0x0
    80005730:	c5a080e7          	jalr	-934(ra) # 80005386 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005734:	8885                	andi	s1,s1,1
    80005736:	f0ed                	bnez	s1,80005718 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005738:	00018517          	auipc	a0,0x18
    8000573c:	9f050513          	addi	a0,a0,-1552 # 8001d128 <disk+0x2128>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	c84080e7          	jalr	-892(ra) # 800063c4 <release>
}
    80005748:	70e6                	ld	ra,120(sp)
    8000574a:	7446                	ld	s0,112(sp)
    8000574c:	74a6                	ld	s1,104(sp)
    8000574e:	7906                	ld	s2,96(sp)
    80005750:	69e6                	ld	s3,88(sp)
    80005752:	6a46                	ld	s4,80(sp)
    80005754:	6aa6                	ld	s5,72(sp)
    80005756:	6b06                	ld	s6,64(sp)
    80005758:	7be2                	ld	s7,56(sp)
    8000575a:	7c42                	ld	s8,48(sp)
    8000575c:	7ca2                	ld	s9,40(sp)
    8000575e:	7d02                	ld	s10,32(sp)
    80005760:	6de2                	ld	s11,24(sp)
    80005762:	6109                	addi	sp,sp,128
    80005764:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005766:	f8042503          	lw	a0,-128(s0)
    8000576a:	20050793          	addi	a5,a0,512
    8000576e:	0792                	slli	a5,a5,0x4
  if(write)
    80005770:	00016817          	auipc	a6,0x16
    80005774:	89080813          	addi	a6,a6,-1904 # 8001b000 <disk>
    80005778:	00f80733          	add	a4,a6,a5
    8000577c:	01a036b3          	snez	a3,s10
    80005780:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005784:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005788:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000578c:	7679                	lui	a2,0xffffe
    8000578e:	963e                	add	a2,a2,a5
    80005790:	00018697          	auipc	a3,0x18
    80005794:	87068693          	addi	a3,a3,-1936 # 8001d000 <disk+0x2000>
    80005798:	6298                	ld	a4,0(a3)
    8000579a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000579c:	0a878593          	addi	a1,a5,168
    800057a0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057a2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057a4:	6298                	ld	a4,0(a3)
    800057a6:	9732                	add	a4,a4,a2
    800057a8:	45c1                	li	a1,16
    800057aa:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057ac:	6298                	ld	a4,0(a3)
    800057ae:	9732                	add	a4,a4,a2
    800057b0:	4585                	li	a1,1
    800057b2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057b6:	f8442703          	lw	a4,-124(s0)
    800057ba:	628c                	ld	a1,0(a3)
    800057bc:	962e                	add	a2,a2,a1
    800057be:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800057c2:	0712                	slli	a4,a4,0x4
    800057c4:	6290                	ld	a2,0(a3)
    800057c6:	963a                	add	a2,a2,a4
    800057c8:	058a8593          	addi	a1,s5,88
    800057cc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057ce:	6294                	ld	a3,0(a3)
    800057d0:	96ba                	add	a3,a3,a4
    800057d2:	40000613          	li	a2,1024
    800057d6:	c690                	sw	a2,8(a3)
  if(write)
    800057d8:	e40d19e3          	bnez	s10,8000562a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057dc:	00018697          	auipc	a3,0x18
    800057e0:	8246b683          	ld	a3,-2012(a3) # 8001d000 <disk+0x2000>
    800057e4:	96ba                	add	a3,a3,a4
    800057e6:	4609                	li	a2,2
    800057e8:	00c69623          	sh	a2,12(a3)
    800057ec:	b5b1                	j	80005638 <virtio_disk_rw+0xd2>

00000000800057ee <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057ee:	1101                	addi	sp,sp,-32
    800057f0:	ec06                	sd	ra,24(sp)
    800057f2:	e822                	sd	s0,16(sp)
    800057f4:	e426                	sd	s1,8(sp)
    800057f6:	e04a                	sd	s2,0(sp)
    800057f8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057fa:	00018517          	auipc	a0,0x18
    800057fe:	92e50513          	addi	a0,a0,-1746 # 8001d128 <disk+0x2128>
    80005802:	00001097          	auipc	ra,0x1
    80005806:	b0e080e7          	jalr	-1266(ra) # 80006310 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000580a:	10001737          	lui	a4,0x10001
    8000580e:	533c                	lw	a5,96(a4)
    80005810:	8b8d                	andi	a5,a5,3
    80005812:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005814:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005818:	00017797          	auipc	a5,0x17
    8000581c:	7e878793          	addi	a5,a5,2024 # 8001d000 <disk+0x2000>
    80005820:	6b94                	ld	a3,16(a5)
    80005822:	0207d703          	lhu	a4,32(a5)
    80005826:	0026d783          	lhu	a5,2(a3)
    8000582a:	06f70163          	beq	a4,a5,8000588c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000582e:	00015917          	auipc	s2,0x15
    80005832:	7d290913          	addi	s2,s2,2002 # 8001b000 <disk>
    80005836:	00017497          	auipc	s1,0x17
    8000583a:	7ca48493          	addi	s1,s1,1994 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000583e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005842:	6898                	ld	a4,16(s1)
    80005844:	0204d783          	lhu	a5,32(s1)
    80005848:	8b9d                	andi	a5,a5,7
    8000584a:	078e                	slli	a5,a5,0x3
    8000584c:	97ba                	add	a5,a5,a4
    8000584e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005850:	20078713          	addi	a4,a5,512
    80005854:	0712                	slli	a4,a4,0x4
    80005856:	974a                	add	a4,a4,s2
    80005858:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000585c:	e731                	bnez	a4,800058a8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000585e:	20078793          	addi	a5,a5,512
    80005862:	0792                	slli	a5,a5,0x4
    80005864:	97ca                	add	a5,a5,s2
    80005866:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005868:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000586c:	ffffc097          	auipc	ra,0xffffc
    80005870:	088080e7          	jalr	136(ra) # 800018f4 <wakeup>

    disk.used_idx += 1;
    80005874:	0204d783          	lhu	a5,32(s1)
    80005878:	2785                	addiw	a5,a5,1
    8000587a:	17c2                	slli	a5,a5,0x30
    8000587c:	93c1                	srli	a5,a5,0x30
    8000587e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005882:	6898                	ld	a4,16(s1)
    80005884:	00275703          	lhu	a4,2(a4)
    80005888:	faf71be3          	bne	a4,a5,8000583e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000588c:	00018517          	auipc	a0,0x18
    80005890:	89c50513          	addi	a0,a0,-1892 # 8001d128 <disk+0x2128>
    80005894:	00001097          	auipc	ra,0x1
    80005898:	b30080e7          	jalr	-1232(ra) # 800063c4 <release>
}
    8000589c:	60e2                	ld	ra,24(sp)
    8000589e:	6442                	ld	s0,16(sp)
    800058a0:	64a2                	ld	s1,8(sp)
    800058a2:	6902                	ld	s2,0(sp)
    800058a4:	6105                	addi	sp,sp,32
    800058a6:	8082                	ret
      panic("virtio_disk_intr status");
    800058a8:	00003517          	auipc	a0,0x3
    800058ac:	f4850513          	addi	a0,a0,-184 # 800087f0 <syscalls+0x3f0>
    800058b0:	00000097          	auipc	ra,0x0
    800058b4:	524080e7          	jalr	1316(ra) # 80005dd4 <panic>

00000000800058b8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058b8:	1141                	addi	sp,sp,-16
    800058ba:	e422                	sd	s0,8(sp)
    800058bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058be:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058c2:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058c6:	0037979b          	slliw	a5,a5,0x3
    800058ca:	02004737          	lui	a4,0x2004
    800058ce:	97ba                	add	a5,a5,a4
    800058d0:	0200c737          	lui	a4,0x200c
    800058d4:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058d8:	000f4637          	lui	a2,0xf4
    800058dc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058e0:	95b2                	add	a1,a1,a2
    800058e2:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058e4:	00269713          	slli	a4,a3,0x2
    800058e8:	9736                	add	a4,a4,a3
    800058ea:	00371693          	slli	a3,a4,0x3
    800058ee:	00018717          	auipc	a4,0x18
    800058f2:	71270713          	addi	a4,a4,1810 # 8001e000 <timer_scratch>
    800058f6:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058f8:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058fa:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058fc:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005900:	00000797          	auipc	a5,0x0
    80005904:	9c078793          	addi	a5,a5,-1600 # 800052c0 <timervec>
    80005908:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000590c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005910:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005914:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005918:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000591c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005920:	30479073          	csrw	mie,a5
}
    80005924:	6422                	ld	s0,8(sp)
    80005926:	0141                	addi	sp,sp,16
    80005928:	8082                	ret

000000008000592a <start>:
{
    8000592a:	1141                	addi	sp,sp,-16
    8000592c:	e406                	sd	ra,8(sp)
    8000592e:	e022                	sd	s0,0(sp)
    80005930:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005932:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005936:	7779                	lui	a4,0xffffe
    80005938:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000593c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000593e:	6705                	lui	a4,0x1
    80005940:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005944:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005946:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000594a:	ffffb797          	auipc	a5,0xffffb
    8000594e:	9d478793          	addi	a5,a5,-1580 # 8000031e <main>
    80005952:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005956:	4781                	li	a5,0
    80005958:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000595c:	67c1                	lui	a5,0x10
    8000595e:	17fd                	addi	a5,a5,-1
    80005960:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005964:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005968:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000596c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005970:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005974:	57fd                	li	a5,-1
    80005976:	83a9                	srli	a5,a5,0xa
    80005978:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000597c:	47bd                	li	a5,15
    8000597e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005982:	00000097          	auipc	ra,0x0
    80005986:	f36080e7          	jalr	-202(ra) # 800058b8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000598a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000598e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005990:	823e                	mv	tp,a5
  asm volatile("mret");
    80005992:	30200073          	mret
}
    80005996:	60a2                	ld	ra,8(sp)
    80005998:	6402                	ld	s0,0(sp)
    8000599a:	0141                	addi	sp,sp,16
    8000599c:	8082                	ret

000000008000599e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000599e:	715d                	addi	sp,sp,-80
    800059a0:	e486                	sd	ra,72(sp)
    800059a2:	e0a2                	sd	s0,64(sp)
    800059a4:	fc26                	sd	s1,56(sp)
    800059a6:	f84a                	sd	s2,48(sp)
    800059a8:	f44e                	sd	s3,40(sp)
    800059aa:	f052                	sd	s4,32(sp)
    800059ac:	ec56                	sd	s5,24(sp)
    800059ae:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059b0:	04c05663          	blez	a2,800059fc <consolewrite+0x5e>
    800059b4:	8a2a                	mv	s4,a0
    800059b6:	84ae                	mv	s1,a1
    800059b8:	89b2                	mv	s3,a2
    800059ba:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059bc:	5afd                	li	s5,-1
    800059be:	4685                	li	a3,1
    800059c0:	8626                	mv	a2,s1
    800059c2:	85d2                	mv	a1,s4
    800059c4:	fbf40513          	addi	a0,s0,-65
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	19a080e7          	jalr	410(ra) # 80001b62 <either_copyin>
    800059d0:	01550c63          	beq	a0,s5,800059e8 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059d4:	fbf44503          	lbu	a0,-65(s0)
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	77a080e7          	jalr	1914(ra) # 80006152 <uartputc>
  for(i = 0; i < n; i++){
    800059e0:	2905                	addiw	s2,s2,1
    800059e2:	0485                	addi	s1,s1,1
    800059e4:	fd299de3          	bne	s3,s2,800059be <consolewrite+0x20>
  }

  return i;
}
    800059e8:	854a                	mv	a0,s2
    800059ea:	60a6                	ld	ra,72(sp)
    800059ec:	6406                	ld	s0,64(sp)
    800059ee:	74e2                	ld	s1,56(sp)
    800059f0:	7942                	ld	s2,48(sp)
    800059f2:	79a2                	ld	s3,40(sp)
    800059f4:	7a02                	ld	s4,32(sp)
    800059f6:	6ae2                	ld	s5,24(sp)
    800059f8:	6161                	addi	sp,sp,80
    800059fa:	8082                	ret
  for(i = 0; i < n; i++){
    800059fc:	4901                	li	s2,0
    800059fe:	b7ed                	j	800059e8 <consolewrite+0x4a>

0000000080005a00 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a00:	7159                	addi	sp,sp,-112
    80005a02:	f486                	sd	ra,104(sp)
    80005a04:	f0a2                	sd	s0,96(sp)
    80005a06:	eca6                	sd	s1,88(sp)
    80005a08:	e8ca                	sd	s2,80(sp)
    80005a0a:	e4ce                	sd	s3,72(sp)
    80005a0c:	e0d2                	sd	s4,64(sp)
    80005a0e:	fc56                	sd	s5,56(sp)
    80005a10:	f85a                	sd	s6,48(sp)
    80005a12:	f45e                	sd	s7,40(sp)
    80005a14:	f062                	sd	s8,32(sp)
    80005a16:	ec66                	sd	s9,24(sp)
    80005a18:	e86a                	sd	s10,16(sp)
    80005a1a:	1880                	addi	s0,sp,112
    80005a1c:	8aaa                	mv	s5,a0
    80005a1e:	8a2e                	mv	s4,a1
    80005a20:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a22:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a26:	00020517          	auipc	a0,0x20
    80005a2a:	71a50513          	addi	a0,a0,1818 # 80026140 <cons>
    80005a2e:	00001097          	auipc	ra,0x1
    80005a32:	8e2080e7          	jalr	-1822(ra) # 80006310 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a36:	00020497          	auipc	s1,0x20
    80005a3a:	70a48493          	addi	s1,s1,1802 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a3e:	00020917          	auipc	s2,0x20
    80005a42:	79a90913          	addi	s2,s2,1946 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a46:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a48:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a4a:	4ca9                	li	s9,10
  while(n > 0){
    80005a4c:	07305863          	blez	s3,80005abc <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a50:	0984a783          	lw	a5,152(s1)
    80005a54:	09c4a703          	lw	a4,156(s1)
    80005a58:	02f71463          	bne	a4,a5,80005a80 <consoleread+0x80>
      if(myproc()->killed){
    80005a5c:	ffffb097          	auipc	ra,0xffffb
    80005a60:	596080e7          	jalr	1430(ra) # 80000ff2 <myproc>
    80005a64:	551c                	lw	a5,40(a0)
    80005a66:	e7b5                	bnez	a5,80005ad2 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a68:	85a6                	mv	a1,s1
    80005a6a:	854a                	mv	a0,s2
    80005a6c:	ffffc097          	auipc	ra,0xffffc
    80005a70:	cfc080e7          	jalr	-772(ra) # 80001768 <sleep>
    while(cons.r == cons.w){
    80005a74:	0984a783          	lw	a5,152(s1)
    80005a78:	09c4a703          	lw	a4,156(s1)
    80005a7c:	fef700e3          	beq	a4,a5,80005a5c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a80:	0017871b          	addiw	a4,a5,1
    80005a84:	08e4ac23          	sw	a4,152(s1)
    80005a88:	07f7f713          	andi	a4,a5,127
    80005a8c:	9726                	add	a4,a4,s1
    80005a8e:	01874703          	lbu	a4,24(a4)
    80005a92:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a96:	077d0563          	beq	s10,s7,80005b00 <consoleread+0x100>
    cbuf = c;
    80005a9a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a9e:	4685                	li	a3,1
    80005aa0:	f9f40613          	addi	a2,s0,-97
    80005aa4:	85d2                	mv	a1,s4
    80005aa6:	8556                	mv	a0,s5
    80005aa8:	ffffc097          	auipc	ra,0xffffc
    80005aac:	064080e7          	jalr	100(ra) # 80001b0c <either_copyout>
    80005ab0:	01850663          	beq	a0,s8,80005abc <consoleread+0xbc>
    dst++;
    80005ab4:	0a05                	addi	s4,s4,1
    --n;
    80005ab6:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005ab8:	f99d1ae3          	bne	s10,s9,80005a4c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005abc:	00020517          	auipc	a0,0x20
    80005ac0:	68450513          	addi	a0,a0,1668 # 80026140 <cons>
    80005ac4:	00001097          	auipc	ra,0x1
    80005ac8:	900080e7          	jalr	-1792(ra) # 800063c4 <release>

  return target - n;
    80005acc:	413b053b          	subw	a0,s6,s3
    80005ad0:	a811                	j	80005ae4 <consoleread+0xe4>
        release(&cons.lock);
    80005ad2:	00020517          	auipc	a0,0x20
    80005ad6:	66e50513          	addi	a0,a0,1646 # 80026140 <cons>
    80005ada:	00001097          	auipc	ra,0x1
    80005ade:	8ea080e7          	jalr	-1814(ra) # 800063c4 <release>
        return -1;
    80005ae2:	557d                	li	a0,-1
}
    80005ae4:	70a6                	ld	ra,104(sp)
    80005ae6:	7406                	ld	s0,96(sp)
    80005ae8:	64e6                	ld	s1,88(sp)
    80005aea:	6946                	ld	s2,80(sp)
    80005aec:	69a6                	ld	s3,72(sp)
    80005aee:	6a06                	ld	s4,64(sp)
    80005af0:	7ae2                	ld	s5,56(sp)
    80005af2:	7b42                	ld	s6,48(sp)
    80005af4:	7ba2                	ld	s7,40(sp)
    80005af6:	7c02                	ld	s8,32(sp)
    80005af8:	6ce2                	ld	s9,24(sp)
    80005afa:	6d42                	ld	s10,16(sp)
    80005afc:	6165                	addi	sp,sp,112
    80005afe:	8082                	ret
      if(n < target){
    80005b00:	0009871b          	sext.w	a4,s3
    80005b04:	fb677ce3          	bgeu	a4,s6,80005abc <consoleread+0xbc>
        cons.r--;
    80005b08:	00020717          	auipc	a4,0x20
    80005b0c:	6cf72823          	sw	a5,1744(a4) # 800261d8 <cons+0x98>
    80005b10:	b775                	j	80005abc <consoleread+0xbc>

0000000080005b12 <consputc>:
{
    80005b12:	1141                	addi	sp,sp,-16
    80005b14:	e406                	sd	ra,8(sp)
    80005b16:	e022                	sd	s0,0(sp)
    80005b18:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b1a:	10000793          	li	a5,256
    80005b1e:	00f50a63          	beq	a0,a5,80005b32 <consputc+0x20>
    uartputc_sync(c);
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	55e080e7          	jalr	1374(ra) # 80006080 <uartputc_sync>
}
    80005b2a:	60a2                	ld	ra,8(sp)
    80005b2c:	6402                	ld	s0,0(sp)
    80005b2e:	0141                	addi	sp,sp,16
    80005b30:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b32:	4521                	li	a0,8
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	54c080e7          	jalr	1356(ra) # 80006080 <uartputc_sync>
    80005b3c:	02000513          	li	a0,32
    80005b40:	00000097          	auipc	ra,0x0
    80005b44:	540080e7          	jalr	1344(ra) # 80006080 <uartputc_sync>
    80005b48:	4521                	li	a0,8
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	536080e7          	jalr	1334(ra) # 80006080 <uartputc_sync>
    80005b52:	bfe1                	j	80005b2a <consputc+0x18>

0000000080005b54 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b54:	1101                	addi	sp,sp,-32
    80005b56:	ec06                	sd	ra,24(sp)
    80005b58:	e822                	sd	s0,16(sp)
    80005b5a:	e426                	sd	s1,8(sp)
    80005b5c:	e04a                	sd	s2,0(sp)
    80005b5e:	1000                	addi	s0,sp,32
    80005b60:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b62:	00020517          	auipc	a0,0x20
    80005b66:	5de50513          	addi	a0,a0,1502 # 80026140 <cons>
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	7a6080e7          	jalr	1958(ra) # 80006310 <acquire>

  switch(c){
    80005b72:	47d5                	li	a5,21
    80005b74:	0af48663          	beq	s1,a5,80005c20 <consoleintr+0xcc>
    80005b78:	0297ca63          	blt	a5,s1,80005bac <consoleintr+0x58>
    80005b7c:	47a1                	li	a5,8
    80005b7e:	0ef48763          	beq	s1,a5,80005c6c <consoleintr+0x118>
    80005b82:	47c1                	li	a5,16
    80005b84:	10f49a63          	bne	s1,a5,80005c98 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b88:	ffffc097          	auipc	ra,0xffffc
    80005b8c:	030080e7          	jalr	48(ra) # 80001bb8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b90:	00020517          	auipc	a0,0x20
    80005b94:	5b050513          	addi	a0,a0,1456 # 80026140 <cons>
    80005b98:	00001097          	auipc	ra,0x1
    80005b9c:	82c080e7          	jalr	-2004(ra) # 800063c4 <release>
}
    80005ba0:	60e2                	ld	ra,24(sp)
    80005ba2:	6442                	ld	s0,16(sp)
    80005ba4:	64a2                	ld	s1,8(sp)
    80005ba6:	6902                	ld	s2,0(sp)
    80005ba8:	6105                	addi	sp,sp,32
    80005baa:	8082                	ret
  switch(c){
    80005bac:	07f00793          	li	a5,127
    80005bb0:	0af48e63          	beq	s1,a5,80005c6c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bb4:	00020717          	auipc	a4,0x20
    80005bb8:	58c70713          	addi	a4,a4,1420 # 80026140 <cons>
    80005bbc:	0a072783          	lw	a5,160(a4)
    80005bc0:	09872703          	lw	a4,152(a4)
    80005bc4:	9f99                	subw	a5,a5,a4
    80005bc6:	07f00713          	li	a4,127
    80005bca:	fcf763e3          	bltu	a4,a5,80005b90 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bce:	47b5                	li	a5,13
    80005bd0:	0cf48763          	beq	s1,a5,80005c9e <consoleintr+0x14a>
      consputc(c);
    80005bd4:	8526                	mv	a0,s1
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	f3c080e7          	jalr	-196(ra) # 80005b12 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bde:	00020797          	auipc	a5,0x20
    80005be2:	56278793          	addi	a5,a5,1378 # 80026140 <cons>
    80005be6:	0a07a703          	lw	a4,160(a5)
    80005bea:	0017069b          	addiw	a3,a4,1
    80005bee:	0006861b          	sext.w	a2,a3
    80005bf2:	0ad7a023          	sw	a3,160(a5)
    80005bf6:	07f77713          	andi	a4,a4,127
    80005bfa:	97ba                	add	a5,a5,a4
    80005bfc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c00:	47a9                	li	a5,10
    80005c02:	0cf48563          	beq	s1,a5,80005ccc <consoleintr+0x178>
    80005c06:	4791                	li	a5,4
    80005c08:	0cf48263          	beq	s1,a5,80005ccc <consoleintr+0x178>
    80005c0c:	00020797          	auipc	a5,0x20
    80005c10:	5cc7a783          	lw	a5,1484(a5) # 800261d8 <cons+0x98>
    80005c14:	0807879b          	addiw	a5,a5,128
    80005c18:	f6f61ce3          	bne	a2,a5,80005b90 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c1c:	863e                	mv	a2,a5
    80005c1e:	a07d                	j	80005ccc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c20:	00020717          	auipc	a4,0x20
    80005c24:	52070713          	addi	a4,a4,1312 # 80026140 <cons>
    80005c28:	0a072783          	lw	a5,160(a4)
    80005c2c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c30:	00020497          	auipc	s1,0x20
    80005c34:	51048493          	addi	s1,s1,1296 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c38:	4929                	li	s2,10
    80005c3a:	f4f70be3          	beq	a4,a5,80005b90 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c3e:	37fd                	addiw	a5,a5,-1
    80005c40:	07f7f713          	andi	a4,a5,127
    80005c44:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c46:	01874703          	lbu	a4,24(a4)
    80005c4a:	f52703e3          	beq	a4,s2,80005b90 <consoleintr+0x3c>
      cons.e--;
    80005c4e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c52:	10000513          	li	a0,256
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	ebc080e7          	jalr	-324(ra) # 80005b12 <consputc>
    while(cons.e != cons.w &&
    80005c5e:	0a04a783          	lw	a5,160(s1)
    80005c62:	09c4a703          	lw	a4,156(s1)
    80005c66:	fcf71ce3          	bne	a4,a5,80005c3e <consoleintr+0xea>
    80005c6a:	b71d                	j	80005b90 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c6c:	00020717          	auipc	a4,0x20
    80005c70:	4d470713          	addi	a4,a4,1236 # 80026140 <cons>
    80005c74:	0a072783          	lw	a5,160(a4)
    80005c78:	09c72703          	lw	a4,156(a4)
    80005c7c:	f0f70ae3          	beq	a4,a5,80005b90 <consoleintr+0x3c>
      cons.e--;
    80005c80:	37fd                	addiw	a5,a5,-1
    80005c82:	00020717          	auipc	a4,0x20
    80005c86:	54f72f23          	sw	a5,1374(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c8a:	10000513          	li	a0,256
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	e84080e7          	jalr	-380(ra) # 80005b12 <consputc>
    80005c96:	bded                	j	80005b90 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c98:	ee048ce3          	beqz	s1,80005b90 <consoleintr+0x3c>
    80005c9c:	bf21                	j	80005bb4 <consoleintr+0x60>
      consputc(c);
    80005c9e:	4529                	li	a0,10
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	e72080e7          	jalr	-398(ra) # 80005b12 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ca8:	00020797          	auipc	a5,0x20
    80005cac:	49878793          	addi	a5,a5,1176 # 80026140 <cons>
    80005cb0:	0a07a703          	lw	a4,160(a5)
    80005cb4:	0017069b          	addiw	a3,a4,1
    80005cb8:	0006861b          	sext.w	a2,a3
    80005cbc:	0ad7a023          	sw	a3,160(a5)
    80005cc0:	07f77713          	andi	a4,a4,127
    80005cc4:	97ba                	add	a5,a5,a4
    80005cc6:	4729                	li	a4,10
    80005cc8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ccc:	00020797          	auipc	a5,0x20
    80005cd0:	50c7a823          	sw	a2,1296(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cd4:	00020517          	auipc	a0,0x20
    80005cd8:	50450513          	addi	a0,a0,1284 # 800261d8 <cons+0x98>
    80005cdc:	ffffc097          	auipc	ra,0xffffc
    80005ce0:	c18080e7          	jalr	-1000(ra) # 800018f4 <wakeup>
    80005ce4:	b575                	j	80005b90 <consoleintr+0x3c>

0000000080005ce6 <consoleinit>:

void
consoleinit(void)
{
    80005ce6:	1141                	addi	sp,sp,-16
    80005ce8:	e406                	sd	ra,8(sp)
    80005cea:	e022                	sd	s0,0(sp)
    80005cec:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cee:	00003597          	auipc	a1,0x3
    80005cf2:	b1a58593          	addi	a1,a1,-1254 # 80008808 <syscalls+0x408>
    80005cf6:	00020517          	auipc	a0,0x20
    80005cfa:	44a50513          	addi	a0,a0,1098 # 80026140 <cons>
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	582080e7          	jalr	1410(ra) # 80006280 <initlock>

  uartinit();
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	32a080e7          	jalr	810(ra) # 80006030 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d0e:	00013797          	auipc	a5,0x13
    80005d12:	7ba78793          	addi	a5,a5,1978 # 800194c8 <devsw>
    80005d16:	00000717          	auipc	a4,0x0
    80005d1a:	cea70713          	addi	a4,a4,-790 # 80005a00 <consoleread>
    80005d1e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d20:	00000717          	auipc	a4,0x0
    80005d24:	c7e70713          	addi	a4,a4,-898 # 8000599e <consolewrite>
    80005d28:	ef98                	sd	a4,24(a5)
}
    80005d2a:	60a2                	ld	ra,8(sp)
    80005d2c:	6402                	ld	s0,0(sp)
    80005d2e:	0141                	addi	sp,sp,16
    80005d30:	8082                	ret

0000000080005d32 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d32:	7179                	addi	sp,sp,-48
    80005d34:	f406                	sd	ra,40(sp)
    80005d36:	f022                	sd	s0,32(sp)
    80005d38:	ec26                	sd	s1,24(sp)
    80005d3a:	e84a                	sd	s2,16(sp)
    80005d3c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d3e:	c219                	beqz	a2,80005d44 <printint+0x12>
    80005d40:	08054663          	bltz	a0,80005dcc <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d44:	2501                	sext.w	a0,a0
    80005d46:	4881                	li	a7,0
    80005d48:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d4c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d4e:	2581                	sext.w	a1,a1
    80005d50:	00003617          	auipc	a2,0x3
    80005d54:	ae860613          	addi	a2,a2,-1304 # 80008838 <digits>
    80005d58:	883a                	mv	a6,a4
    80005d5a:	2705                	addiw	a4,a4,1
    80005d5c:	02b577bb          	remuw	a5,a0,a1
    80005d60:	1782                	slli	a5,a5,0x20
    80005d62:	9381                	srli	a5,a5,0x20
    80005d64:	97b2                	add	a5,a5,a2
    80005d66:	0007c783          	lbu	a5,0(a5)
    80005d6a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d6e:	0005079b          	sext.w	a5,a0
    80005d72:	02b5553b          	divuw	a0,a0,a1
    80005d76:	0685                	addi	a3,a3,1
    80005d78:	feb7f0e3          	bgeu	a5,a1,80005d58 <printint+0x26>

  if(sign)
    80005d7c:	00088b63          	beqz	a7,80005d92 <printint+0x60>
    buf[i++] = '-';
    80005d80:	fe040793          	addi	a5,s0,-32
    80005d84:	973e                	add	a4,a4,a5
    80005d86:	02d00793          	li	a5,45
    80005d8a:	fef70823          	sb	a5,-16(a4)
    80005d8e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d92:	02e05763          	blez	a4,80005dc0 <printint+0x8e>
    80005d96:	fd040793          	addi	a5,s0,-48
    80005d9a:	00e784b3          	add	s1,a5,a4
    80005d9e:	fff78913          	addi	s2,a5,-1
    80005da2:	993a                	add	s2,s2,a4
    80005da4:	377d                	addiw	a4,a4,-1
    80005da6:	1702                	slli	a4,a4,0x20
    80005da8:	9301                	srli	a4,a4,0x20
    80005daa:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dae:	fff4c503          	lbu	a0,-1(s1)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	d60080e7          	jalr	-672(ra) # 80005b12 <consputc>
  while(--i >= 0)
    80005dba:	14fd                	addi	s1,s1,-1
    80005dbc:	ff2499e3          	bne	s1,s2,80005dae <printint+0x7c>
}
    80005dc0:	70a2                	ld	ra,40(sp)
    80005dc2:	7402                	ld	s0,32(sp)
    80005dc4:	64e2                	ld	s1,24(sp)
    80005dc6:	6942                	ld	s2,16(sp)
    80005dc8:	6145                	addi	sp,sp,48
    80005dca:	8082                	ret
    x = -xx;
    80005dcc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dd0:	4885                	li	a7,1
    x = -xx;
    80005dd2:	bf9d                	j	80005d48 <printint+0x16>

0000000080005dd4 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dd4:	1101                	addi	sp,sp,-32
    80005dd6:	ec06                	sd	ra,24(sp)
    80005dd8:	e822                	sd	s0,16(sp)
    80005dda:	e426                	sd	s1,8(sp)
    80005ddc:	1000                	addi	s0,sp,32
    80005dde:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005de0:	00020797          	auipc	a5,0x20
    80005de4:	4207a023          	sw	zero,1056(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	a2850513          	addi	a0,a0,-1496 # 80008810 <syscalls+0x410>
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	02e080e7          	jalr	46(ra) # 80005e1e <printf>
  printf(s);
    80005df8:	8526                	mv	a0,s1
    80005dfa:	00000097          	auipc	ra,0x0
    80005dfe:	024080e7          	jalr	36(ra) # 80005e1e <printf>
  printf("\n");
    80005e02:	00002517          	auipc	a0,0x2
    80005e06:	24650513          	addi	a0,a0,582 # 80008048 <etext+0x48>
    80005e0a:	00000097          	auipc	ra,0x0
    80005e0e:	014080e7          	jalr	20(ra) # 80005e1e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e12:	4785                	li	a5,1
    80005e14:	00003717          	auipc	a4,0x3
    80005e18:	20f72423          	sw	a5,520(a4) # 8000901c <panicked>
  for(;;)
    80005e1c:	a001                	j	80005e1c <panic+0x48>

0000000080005e1e <printf>:
{
    80005e1e:	7131                	addi	sp,sp,-192
    80005e20:	fc86                	sd	ra,120(sp)
    80005e22:	f8a2                	sd	s0,112(sp)
    80005e24:	f4a6                	sd	s1,104(sp)
    80005e26:	f0ca                	sd	s2,96(sp)
    80005e28:	ecce                	sd	s3,88(sp)
    80005e2a:	e8d2                	sd	s4,80(sp)
    80005e2c:	e4d6                	sd	s5,72(sp)
    80005e2e:	e0da                	sd	s6,64(sp)
    80005e30:	fc5e                	sd	s7,56(sp)
    80005e32:	f862                	sd	s8,48(sp)
    80005e34:	f466                	sd	s9,40(sp)
    80005e36:	f06a                	sd	s10,32(sp)
    80005e38:	ec6e                	sd	s11,24(sp)
    80005e3a:	0100                	addi	s0,sp,128
    80005e3c:	8a2a                	mv	s4,a0
    80005e3e:	e40c                	sd	a1,8(s0)
    80005e40:	e810                	sd	a2,16(s0)
    80005e42:	ec14                	sd	a3,24(s0)
    80005e44:	f018                	sd	a4,32(s0)
    80005e46:	f41c                	sd	a5,40(s0)
    80005e48:	03043823          	sd	a6,48(s0)
    80005e4c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e50:	00020d97          	auipc	s11,0x20
    80005e54:	3b0dad83          	lw	s11,944(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e58:	020d9b63          	bnez	s11,80005e8e <printf+0x70>
  if (fmt == 0)
    80005e5c:	040a0263          	beqz	s4,80005ea0 <printf+0x82>
  va_start(ap, fmt);
    80005e60:	00840793          	addi	a5,s0,8
    80005e64:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e68:	000a4503          	lbu	a0,0(s4)
    80005e6c:	14050f63          	beqz	a0,80005fca <printf+0x1ac>
    80005e70:	4981                	li	s3,0
    if(c != '%'){
    80005e72:	02500a93          	li	s5,37
    switch(c){
    80005e76:	07000b93          	li	s7,112
  consputc('x');
    80005e7a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e7c:	00003b17          	auipc	s6,0x3
    80005e80:	9bcb0b13          	addi	s6,s6,-1604 # 80008838 <digits>
    switch(c){
    80005e84:	07300c93          	li	s9,115
    80005e88:	06400c13          	li	s8,100
    80005e8c:	a82d                	j	80005ec6 <printf+0xa8>
    acquire(&pr.lock);
    80005e8e:	00020517          	auipc	a0,0x20
    80005e92:	35a50513          	addi	a0,a0,858 # 800261e8 <pr>
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	47a080e7          	jalr	1146(ra) # 80006310 <acquire>
    80005e9e:	bf7d                	j	80005e5c <printf+0x3e>
    panic("null fmt");
    80005ea0:	00003517          	auipc	a0,0x3
    80005ea4:	98050513          	addi	a0,a0,-1664 # 80008820 <syscalls+0x420>
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	f2c080e7          	jalr	-212(ra) # 80005dd4 <panic>
      consputc(c);
    80005eb0:	00000097          	auipc	ra,0x0
    80005eb4:	c62080e7          	jalr	-926(ra) # 80005b12 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb8:	2985                	addiw	s3,s3,1
    80005eba:	013a07b3          	add	a5,s4,s3
    80005ebe:	0007c503          	lbu	a0,0(a5)
    80005ec2:	10050463          	beqz	a0,80005fca <printf+0x1ac>
    if(c != '%'){
    80005ec6:	ff5515e3          	bne	a0,s5,80005eb0 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eca:	2985                	addiw	s3,s3,1
    80005ecc:	013a07b3          	add	a5,s4,s3
    80005ed0:	0007c783          	lbu	a5,0(a5)
    80005ed4:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ed8:	cbed                	beqz	a5,80005fca <printf+0x1ac>
    switch(c){
    80005eda:	05778a63          	beq	a5,s7,80005f2e <printf+0x110>
    80005ede:	02fbf663          	bgeu	s7,a5,80005f0a <printf+0xec>
    80005ee2:	09978863          	beq	a5,s9,80005f72 <printf+0x154>
    80005ee6:	07800713          	li	a4,120
    80005eea:	0ce79563          	bne	a5,a4,80005fb4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eee:	f8843783          	ld	a5,-120(s0)
    80005ef2:	00878713          	addi	a4,a5,8
    80005ef6:	f8e43423          	sd	a4,-120(s0)
    80005efa:	4605                	li	a2,1
    80005efc:	85ea                	mv	a1,s10
    80005efe:	4388                	lw	a0,0(a5)
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	e32080e7          	jalr	-462(ra) # 80005d32 <printint>
      break;
    80005f08:	bf45                	j	80005eb8 <printf+0x9a>
    switch(c){
    80005f0a:	09578f63          	beq	a5,s5,80005fa8 <printf+0x18a>
    80005f0e:	0b879363          	bne	a5,s8,80005fb4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f12:	f8843783          	ld	a5,-120(s0)
    80005f16:	00878713          	addi	a4,a5,8
    80005f1a:	f8e43423          	sd	a4,-120(s0)
    80005f1e:	4605                	li	a2,1
    80005f20:	45a9                	li	a1,10
    80005f22:	4388                	lw	a0,0(a5)
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	e0e080e7          	jalr	-498(ra) # 80005d32 <printint>
      break;
    80005f2c:	b771                	j	80005eb8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f2e:	f8843783          	ld	a5,-120(s0)
    80005f32:	00878713          	addi	a4,a5,8
    80005f36:	f8e43423          	sd	a4,-120(s0)
    80005f3a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f3e:	03000513          	li	a0,48
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bd0080e7          	jalr	-1072(ra) # 80005b12 <consputc>
  consputc('x');
    80005f4a:	07800513          	li	a0,120
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	bc4080e7          	jalr	-1084(ra) # 80005b12 <consputc>
    80005f56:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f58:	03c95793          	srli	a5,s2,0x3c
    80005f5c:	97da                	add	a5,a5,s6
    80005f5e:	0007c503          	lbu	a0,0(a5)
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	bb0080e7          	jalr	-1104(ra) # 80005b12 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f6a:	0912                	slli	s2,s2,0x4
    80005f6c:	34fd                	addiw	s1,s1,-1
    80005f6e:	f4ed                	bnez	s1,80005f58 <printf+0x13a>
    80005f70:	b7a1                	j	80005eb8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f72:	f8843783          	ld	a5,-120(s0)
    80005f76:	00878713          	addi	a4,a5,8
    80005f7a:	f8e43423          	sd	a4,-120(s0)
    80005f7e:	6384                	ld	s1,0(a5)
    80005f80:	cc89                	beqz	s1,80005f9a <printf+0x17c>
      for(; *s; s++)
    80005f82:	0004c503          	lbu	a0,0(s1)
    80005f86:	d90d                	beqz	a0,80005eb8 <printf+0x9a>
        consputc(*s);
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	b8a080e7          	jalr	-1142(ra) # 80005b12 <consputc>
      for(; *s; s++)
    80005f90:	0485                	addi	s1,s1,1
    80005f92:	0004c503          	lbu	a0,0(s1)
    80005f96:	f96d                	bnez	a0,80005f88 <printf+0x16a>
    80005f98:	b705                	j	80005eb8 <printf+0x9a>
        s = "(null)";
    80005f9a:	00003497          	auipc	s1,0x3
    80005f9e:	87e48493          	addi	s1,s1,-1922 # 80008818 <syscalls+0x418>
      for(; *s; s++)
    80005fa2:	02800513          	li	a0,40
    80005fa6:	b7cd                	j	80005f88 <printf+0x16a>
      consputc('%');
    80005fa8:	8556                	mv	a0,s5
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	b68080e7          	jalr	-1176(ra) # 80005b12 <consputc>
      break;
    80005fb2:	b719                	j	80005eb8 <printf+0x9a>
      consputc('%');
    80005fb4:	8556                	mv	a0,s5
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	b5c080e7          	jalr	-1188(ra) # 80005b12 <consputc>
      consputc(c);
    80005fbe:	8526                	mv	a0,s1
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	b52080e7          	jalr	-1198(ra) # 80005b12 <consputc>
      break;
    80005fc8:	bdc5                	j	80005eb8 <printf+0x9a>
  if(locking)
    80005fca:	020d9163          	bnez	s11,80005fec <printf+0x1ce>
}
    80005fce:	70e6                	ld	ra,120(sp)
    80005fd0:	7446                	ld	s0,112(sp)
    80005fd2:	74a6                	ld	s1,104(sp)
    80005fd4:	7906                	ld	s2,96(sp)
    80005fd6:	69e6                	ld	s3,88(sp)
    80005fd8:	6a46                	ld	s4,80(sp)
    80005fda:	6aa6                	ld	s5,72(sp)
    80005fdc:	6b06                	ld	s6,64(sp)
    80005fde:	7be2                	ld	s7,56(sp)
    80005fe0:	7c42                	ld	s8,48(sp)
    80005fe2:	7ca2                	ld	s9,40(sp)
    80005fe4:	7d02                	ld	s10,32(sp)
    80005fe6:	6de2                	ld	s11,24(sp)
    80005fe8:	6129                	addi	sp,sp,192
    80005fea:	8082                	ret
    release(&pr.lock);
    80005fec:	00020517          	auipc	a0,0x20
    80005ff0:	1fc50513          	addi	a0,a0,508 # 800261e8 <pr>
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	3d0080e7          	jalr	976(ra) # 800063c4 <release>
}
    80005ffc:	bfc9                	j	80005fce <printf+0x1b0>

0000000080005ffe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ffe:	1101                	addi	sp,sp,-32
    80006000:	ec06                	sd	ra,24(sp)
    80006002:	e822                	sd	s0,16(sp)
    80006004:	e426                	sd	s1,8(sp)
    80006006:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006008:	00020497          	auipc	s1,0x20
    8000600c:	1e048493          	addi	s1,s1,480 # 800261e8 <pr>
    80006010:	00003597          	auipc	a1,0x3
    80006014:	82058593          	addi	a1,a1,-2016 # 80008830 <syscalls+0x430>
    80006018:	8526                	mv	a0,s1
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	266080e7          	jalr	614(ra) # 80006280 <initlock>
  pr.locking = 1;
    80006022:	4785                	li	a5,1
    80006024:	cc9c                	sw	a5,24(s1)
}
    80006026:	60e2                	ld	ra,24(sp)
    80006028:	6442                	ld	s0,16(sp)
    8000602a:	64a2                	ld	s1,8(sp)
    8000602c:	6105                	addi	sp,sp,32
    8000602e:	8082                	ret

0000000080006030 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006030:	1141                	addi	sp,sp,-16
    80006032:	e406                	sd	ra,8(sp)
    80006034:	e022                	sd	s0,0(sp)
    80006036:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006038:	100007b7          	lui	a5,0x10000
    8000603c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006040:	f8000713          	li	a4,-128
    80006044:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006048:	470d                	li	a4,3
    8000604a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000604e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006052:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006056:	469d                	li	a3,7
    80006058:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000605c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006060:	00002597          	auipc	a1,0x2
    80006064:	7f058593          	addi	a1,a1,2032 # 80008850 <digits+0x18>
    80006068:	00020517          	auipc	a0,0x20
    8000606c:	1a050513          	addi	a0,a0,416 # 80026208 <uart_tx_lock>
    80006070:	00000097          	auipc	ra,0x0
    80006074:	210080e7          	jalr	528(ra) # 80006280 <initlock>
}
    80006078:	60a2                	ld	ra,8(sp)
    8000607a:	6402                	ld	s0,0(sp)
    8000607c:	0141                	addi	sp,sp,16
    8000607e:	8082                	ret

0000000080006080 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006080:	1101                	addi	sp,sp,-32
    80006082:	ec06                	sd	ra,24(sp)
    80006084:	e822                	sd	s0,16(sp)
    80006086:	e426                	sd	s1,8(sp)
    80006088:	1000                	addi	s0,sp,32
    8000608a:	84aa                	mv	s1,a0
  push_off();
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	238080e7          	jalr	568(ra) # 800062c4 <push_off>

  if(panicked){
    80006094:	00003797          	auipc	a5,0x3
    80006098:	f887a783          	lw	a5,-120(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609c:	10000737          	lui	a4,0x10000
  if(panicked){
    800060a0:	c391                	beqz	a5,800060a4 <uartputc_sync+0x24>
    for(;;)
    800060a2:	a001                	j	800060a2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060a4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060a8:	0207f793          	andi	a5,a5,32
    800060ac:	dfe5                	beqz	a5,800060a4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ae:	0ff4f513          	andi	a0,s1,255
    800060b2:	100007b7          	lui	a5,0x10000
    800060b6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060ba:	00000097          	auipc	ra,0x0
    800060be:	2aa080e7          	jalr	682(ra) # 80006364 <pop_off>
}
    800060c2:	60e2                	ld	ra,24(sp)
    800060c4:	6442                	ld	s0,16(sp)
    800060c6:	64a2                	ld	s1,8(sp)
    800060c8:	6105                	addi	sp,sp,32
    800060ca:	8082                	ret

00000000800060cc <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060cc:	00003797          	auipc	a5,0x3
    800060d0:	f547b783          	ld	a5,-172(a5) # 80009020 <uart_tx_r>
    800060d4:	00003717          	auipc	a4,0x3
    800060d8:	f5473703          	ld	a4,-172(a4) # 80009028 <uart_tx_w>
    800060dc:	06f70a63          	beq	a4,a5,80006150 <uartstart+0x84>
{
    800060e0:	7139                	addi	sp,sp,-64
    800060e2:	fc06                	sd	ra,56(sp)
    800060e4:	f822                	sd	s0,48(sp)
    800060e6:	f426                	sd	s1,40(sp)
    800060e8:	f04a                	sd	s2,32(sp)
    800060ea:	ec4e                	sd	s3,24(sp)
    800060ec:	e852                	sd	s4,16(sp)
    800060ee:	e456                	sd	s5,8(sp)
    800060f0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f2:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f6:	00020a17          	auipc	s4,0x20
    800060fa:	112a0a13          	addi	s4,s4,274 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060fe:	00003497          	auipc	s1,0x3
    80006102:	f2248493          	addi	s1,s1,-222 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006106:	00003997          	auipc	s3,0x3
    8000610a:	f2298993          	addi	s3,s3,-222 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006112:	02077713          	andi	a4,a4,32
    80006116:	c705                	beqz	a4,8000613e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006118:	01f7f713          	andi	a4,a5,31
    8000611c:	9752                	add	a4,a4,s4
    8000611e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006122:	0785                	addi	a5,a5,1
    80006124:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006126:	8526                	mv	a0,s1
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	7cc080e7          	jalr	1996(ra) # 800018f4 <wakeup>
    
    WriteReg(THR, c);
    80006130:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006134:	609c                	ld	a5,0(s1)
    80006136:	0009b703          	ld	a4,0(s3)
    8000613a:	fcf71ae3          	bne	a4,a5,8000610e <uartstart+0x42>
  }
}
    8000613e:	70e2                	ld	ra,56(sp)
    80006140:	7442                	ld	s0,48(sp)
    80006142:	74a2                	ld	s1,40(sp)
    80006144:	7902                	ld	s2,32(sp)
    80006146:	69e2                	ld	s3,24(sp)
    80006148:	6a42                	ld	s4,16(sp)
    8000614a:	6aa2                	ld	s5,8(sp)
    8000614c:	6121                	addi	sp,sp,64
    8000614e:	8082                	ret
    80006150:	8082                	ret

0000000080006152 <uartputc>:
{
    80006152:	7179                	addi	sp,sp,-48
    80006154:	f406                	sd	ra,40(sp)
    80006156:	f022                	sd	s0,32(sp)
    80006158:	ec26                	sd	s1,24(sp)
    8000615a:	e84a                	sd	s2,16(sp)
    8000615c:	e44e                	sd	s3,8(sp)
    8000615e:	e052                	sd	s4,0(sp)
    80006160:	1800                	addi	s0,sp,48
    80006162:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006164:	00020517          	auipc	a0,0x20
    80006168:	0a450513          	addi	a0,a0,164 # 80026208 <uart_tx_lock>
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	1a4080e7          	jalr	420(ra) # 80006310 <acquire>
  if(panicked){
    80006174:	00003797          	auipc	a5,0x3
    80006178:	ea87a783          	lw	a5,-344(a5) # 8000901c <panicked>
    8000617c:	c391                	beqz	a5,80006180 <uartputc+0x2e>
    for(;;)
    8000617e:	a001                	j	8000617e <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006180:	00003717          	auipc	a4,0x3
    80006184:	ea873703          	ld	a4,-344(a4) # 80009028 <uart_tx_w>
    80006188:	00003797          	auipc	a5,0x3
    8000618c:	e987b783          	ld	a5,-360(a5) # 80009020 <uart_tx_r>
    80006190:	02078793          	addi	a5,a5,32
    80006194:	02e79b63          	bne	a5,a4,800061ca <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006198:	00020997          	auipc	s3,0x20
    8000619c:	07098993          	addi	s3,s3,112 # 80026208 <uart_tx_lock>
    800061a0:	00003497          	auipc	s1,0x3
    800061a4:	e8048493          	addi	s1,s1,-384 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a8:	00003917          	auipc	s2,0x3
    800061ac:	e8090913          	addi	s2,s2,-384 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b0:	85ce                	mv	a1,s3
    800061b2:	8526                	mv	a0,s1
    800061b4:	ffffb097          	auipc	ra,0xffffb
    800061b8:	5b4080e7          	jalr	1460(ra) # 80001768 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061bc:	00093703          	ld	a4,0(s2)
    800061c0:	609c                	ld	a5,0(s1)
    800061c2:	02078793          	addi	a5,a5,32
    800061c6:	fee785e3          	beq	a5,a4,800061b0 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061ca:	00020497          	auipc	s1,0x20
    800061ce:	03e48493          	addi	s1,s1,62 # 80026208 <uart_tx_lock>
    800061d2:	01f77793          	andi	a5,a4,31
    800061d6:	97a6                	add	a5,a5,s1
    800061d8:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061dc:	0705                	addi	a4,a4,1
    800061de:	00003797          	auipc	a5,0x3
    800061e2:	e4e7b523          	sd	a4,-438(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	ee6080e7          	jalr	-282(ra) # 800060cc <uartstart>
      release(&uart_tx_lock);
    800061ee:	8526                	mv	a0,s1
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	1d4080e7          	jalr	468(ra) # 800063c4 <release>
}
    800061f8:	70a2                	ld	ra,40(sp)
    800061fa:	7402                	ld	s0,32(sp)
    800061fc:	64e2                	ld	s1,24(sp)
    800061fe:	6942                	ld	s2,16(sp)
    80006200:	69a2                	ld	s3,8(sp)
    80006202:	6a02                	ld	s4,0(sp)
    80006204:	6145                	addi	sp,sp,48
    80006206:	8082                	ret

0000000080006208 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006208:	1141                	addi	sp,sp,-16
    8000620a:	e422                	sd	s0,8(sp)
    8000620c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000620e:	100007b7          	lui	a5,0x10000
    80006212:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006216:	8b85                	andi	a5,a5,1
    80006218:	cb91                	beqz	a5,8000622c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000621a:	100007b7          	lui	a5,0x10000
    8000621e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006222:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006226:	6422                	ld	s0,8(sp)
    80006228:	0141                	addi	sp,sp,16
    8000622a:	8082                	ret
    return -1;
    8000622c:	557d                	li	a0,-1
    8000622e:	bfe5                	j	80006226 <uartgetc+0x1e>

0000000080006230 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006230:	1101                	addi	sp,sp,-32
    80006232:	ec06                	sd	ra,24(sp)
    80006234:	e822                	sd	s0,16(sp)
    80006236:	e426                	sd	s1,8(sp)
    80006238:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000623a:	54fd                	li	s1,-1
    8000623c:	a029                	j	80006246 <uartintr+0x16>
      break;
    consoleintr(c);
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	916080e7          	jalr	-1770(ra) # 80005b54 <consoleintr>
    int c = uartgetc();
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	fc2080e7          	jalr	-62(ra) # 80006208 <uartgetc>
    if(c == -1)
    8000624e:	fe9518e3          	bne	a0,s1,8000623e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006252:	00020497          	auipc	s1,0x20
    80006256:	fb648493          	addi	s1,s1,-74 # 80026208 <uart_tx_lock>
    8000625a:	8526                	mv	a0,s1
    8000625c:	00000097          	auipc	ra,0x0
    80006260:	0b4080e7          	jalr	180(ra) # 80006310 <acquire>
  uartstart();
    80006264:	00000097          	auipc	ra,0x0
    80006268:	e68080e7          	jalr	-408(ra) # 800060cc <uartstart>
  release(&uart_tx_lock);
    8000626c:	8526                	mv	a0,s1
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	156080e7          	jalr	342(ra) # 800063c4 <release>
}
    80006276:	60e2                	ld	ra,24(sp)
    80006278:	6442                	ld	s0,16(sp)
    8000627a:	64a2                	ld	s1,8(sp)
    8000627c:	6105                	addi	sp,sp,32
    8000627e:	8082                	ret

0000000080006280 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006280:	1141                	addi	sp,sp,-16
    80006282:	e422                	sd	s0,8(sp)
    80006284:	0800                	addi	s0,sp,16
  lk->name = name;
    80006286:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006288:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628c:	00053823          	sd	zero,16(a0)
}
    80006290:	6422                	ld	s0,8(sp)
    80006292:	0141                	addi	sp,sp,16
    80006294:	8082                	ret

0000000080006296 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006296:	411c                	lw	a5,0(a0)
    80006298:	e399                	bnez	a5,8000629e <holding+0x8>
    8000629a:	4501                	li	a0,0
  return r;
}
    8000629c:	8082                	ret
{
    8000629e:	1101                	addi	sp,sp,-32
    800062a0:	ec06                	sd	ra,24(sp)
    800062a2:	e822                	sd	s0,16(sp)
    800062a4:	e426                	sd	s1,8(sp)
    800062a6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062a8:	6904                	ld	s1,16(a0)
    800062aa:	ffffb097          	auipc	ra,0xffffb
    800062ae:	d2c080e7          	jalr	-724(ra) # 80000fd6 <mycpu>
    800062b2:	40a48533          	sub	a0,s1,a0
    800062b6:	00153513          	seqz	a0,a0
}
    800062ba:	60e2                	ld	ra,24(sp)
    800062bc:	6442                	ld	s0,16(sp)
    800062be:	64a2                	ld	s1,8(sp)
    800062c0:	6105                	addi	sp,sp,32
    800062c2:	8082                	ret

00000000800062c4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c4:	1101                	addi	sp,sp,-32
    800062c6:	ec06                	sd	ra,24(sp)
    800062c8:	e822                	sd	s0,16(sp)
    800062ca:	e426                	sd	s1,8(sp)
    800062cc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ce:	100024f3          	csrr	s1,sstatus
    800062d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062d8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062dc:	ffffb097          	auipc	ra,0xffffb
    800062e0:	cfa080e7          	jalr	-774(ra) # 80000fd6 <mycpu>
    800062e4:	5d3c                	lw	a5,120(a0)
    800062e6:	cf89                	beqz	a5,80006300 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	cee080e7          	jalr	-786(ra) # 80000fd6 <mycpu>
    800062f0:	5d3c                	lw	a5,120(a0)
    800062f2:	2785                	addiw	a5,a5,1
    800062f4:	dd3c                	sw	a5,120(a0)
}
    800062f6:	60e2                	ld	ra,24(sp)
    800062f8:	6442                	ld	s0,16(sp)
    800062fa:	64a2                	ld	s1,8(sp)
    800062fc:	6105                	addi	sp,sp,32
    800062fe:	8082                	ret
    mycpu()->intena = old;
    80006300:	ffffb097          	auipc	ra,0xffffb
    80006304:	cd6080e7          	jalr	-810(ra) # 80000fd6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006308:	8085                	srli	s1,s1,0x1
    8000630a:	8885                	andi	s1,s1,1
    8000630c:	dd64                	sw	s1,124(a0)
    8000630e:	bfe9                	j	800062e8 <push_off+0x24>

0000000080006310 <acquire>:
{
    80006310:	1101                	addi	sp,sp,-32
    80006312:	ec06                	sd	ra,24(sp)
    80006314:	e822                	sd	s0,16(sp)
    80006316:	e426                	sd	s1,8(sp)
    80006318:	1000                	addi	s0,sp,32
    8000631a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	fa8080e7          	jalr	-88(ra) # 800062c4 <push_off>
  if(holding(lk))
    80006324:	8526                	mv	a0,s1
    80006326:	00000097          	auipc	ra,0x0
    8000632a:	f70080e7          	jalr	-144(ra) # 80006296 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000632e:	4705                	li	a4,1
  if(holding(lk))
    80006330:	e115                	bnez	a0,80006354 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006332:	87ba                	mv	a5,a4
    80006334:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006338:	2781                	sext.w	a5,a5
    8000633a:	ffe5                	bnez	a5,80006332 <acquire+0x22>
  __sync_synchronize();
    8000633c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006340:	ffffb097          	auipc	ra,0xffffb
    80006344:	c96080e7          	jalr	-874(ra) # 80000fd6 <mycpu>
    80006348:	e888                	sd	a0,16(s1)
}
    8000634a:	60e2                	ld	ra,24(sp)
    8000634c:	6442                	ld	s0,16(sp)
    8000634e:	64a2                	ld	s1,8(sp)
    80006350:	6105                	addi	sp,sp,32
    80006352:	8082                	ret
    panic("acquire");
    80006354:	00002517          	auipc	a0,0x2
    80006358:	50450513          	addi	a0,a0,1284 # 80008858 <digits+0x20>
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	a78080e7          	jalr	-1416(ra) # 80005dd4 <panic>

0000000080006364 <pop_off>:

void
pop_off(void)
{
    80006364:	1141                	addi	sp,sp,-16
    80006366:	e406                	sd	ra,8(sp)
    80006368:	e022                	sd	s0,0(sp)
    8000636a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	c6a080e7          	jalr	-918(ra) # 80000fd6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006374:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006378:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000637a:	e78d                	bnez	a5,800063a4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637c:	5d3c                	lw	a5,120(a0)
    8000637e:	02f05b63          	blez	a5,800063b4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006382:	37fd                	addiw	a5,a5,-1
    80006384:	0007871b          	sext.w	a4,a5
    80006388:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000638a:	eb09                	bnez	a4,8000639c <pop_off+0x38>
    8000638c:	5d7c                	lw	a5,124(a0)
    8000638e:	c799                	beqz	a5,8000639c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006390:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006394:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006398:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639c:	60a2                	ld	ra,8(sp)
    8000639e:	6402                	ld	s0,0(sp)
    800063a0:	0141                	addi	sp,sp,16
    800063a2:	8082                	ret
    panic("pop_off - interruptible");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	4bc50513          	addi	a0,a0,1212 # 80008860 <digits+0x28>
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	a28080e7          	jalr	-1496(ra) # 80005dd4 <panic>
    panic("pop_off");
    800063b4:	00002517          	auipc	a0,0x2
    800063b8:	4c450513          	addi	a0,a0,1220 # 80008878 <digits+0x40>
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	a18080e7          	jalr	-1512(ra) # 80005dd4 <panic>

00000000800063c4 <release>:
{
    800063c4:	1101                	addi	sp,sp,-32
    800063c6:	ec06                	sd	ra,24(sp)
    800063c8:	e822                	sd	s0,16(sp)
    800063ca:	e426                	sd	s1,8(sp)
    800063cc:	1000                	addi	s0,sp,32
    800063ce:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	ec6080e7          	jalr	-314(ra) # 80006296 <holding>
    800063d8:	c115                	beqz	a0,800063fc <release+0x38>
  lk->cpu = 0;
    800063da:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063de:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e2:	0f50000f          	fence	iorw,ow
    800063e6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ea:	00000097          	auipc	ra,0x0
    800063ee:	f7a080e7          	jalr	-134(ra) # 80006364 <pop_off>
}
    800063f2:	60e2                	ld	ra,24(sp)
    800063f4:	6442                	ld	s0,16(sp)
    800063f6:	64a2                	ld	s1,8(sp)
    800063f8:	6105                	addi	sp,sp,32
    800063fa:	8082                	ret
    panic("release");
    800063fc:	00002517          	auipc	a0,0x2
    80006400:	48450513          	addi	a0,a0,1156 # 80008880 <digits+0x48>
    80006404:	00000097          	auipc	ra,0x0
    80006408:	9d0080e7          	jalr	-1584(ra) # 80005dd4 <panic>
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
