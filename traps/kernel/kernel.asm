
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
    80000016:	774050ef          	jal	ra,8000578a <start>

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
    8000005e:	17a080e7          	jalr	378(ra) # 800061d4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	21a080e7          	jalr	538(ra) # 80006288 <release>
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
    8000008e:	c38080e7          	jalr	-968(ra) # 80005cc2 <panic>

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
    800000f8:	050080e7          	jalr	80(ra) # 80006144 <initlock>
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
    80000130:	0a8080e7          	jalr	168(ra) # 800061d4 <acquire>
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
    80000148:	144080e7          	jalr	324(ra) # 80006288 <release>

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
    80000172:	11a080e7          	jalr	282(ra) # 80006288 <release>
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
    8000032a:	af0080e7          	jalr	-1296(ra) # 80000e16 <cpuid>
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
    80000346:	ad4080e7          	jalr	-1324(ra) # 80000e16 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	9c0080e7          	jalr	-1600(ra) # 80005d14 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	784080e7          	jalr	1924(ra) # 80001ae8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	df4080e7          	jalr	-524(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	032080e7          	jalr	50(ra) # 800013a6 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	7ca080e7          	jalr	1994(ra) # 80005b46 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	8b0080e7          	jalr	-1872(ra) # 80005c34 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	980080e7          	jalr	-1664(ra) # 80005d14 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	970080e7          	jalr	-1680(ra) # 80005d14 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	960080e7          	jalr	-1696(ra) # 80005d14 <printf>
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
    800003d8:	992080e7          	jalr	-1646(ra) # 80000d66 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6e4080e7          	jalr	1764(ra) # 80001ac0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	704080e7          	jalr	1796(ra) # 80001ae8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d5e080e7          	jalr	-674(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d6c080e7          	jalr	-660(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f36080e7          	jalr	-202(ra) # 80002332 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5c6080e7          	jalr	1478(ra) # 800029ca <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	570080e7          	jalr	1392(ra) # 8000397c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e6e080e7          	jalr	-402(ra) # 80005282 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d54080e7          	jalr	-684(ra) # 80001170 <userinit>
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
    8000048a:	83c080e7          	jalr	-1988(ra) # 80005cc2 <panic>
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
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	716080e7          	jalr	1814(ra) # 80005cc2 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	706080e7          	jalr	1798(ra) # 80005cc2 <panic>
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
    8000060c:	6ba080e7          	jalr	1722(ra) # 80005cc2 <panic>

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
    800006d4:	600080e7          	jalr	1536(ra) # 80000cd0 <proc_mapstacks>
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
    80000758:	56e080e7          	jalr	1390(ra) # 80005cc2 <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	93c50513          	addi	a0,a0,-1732 # 80008098 <etext+0x98>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	55e080e7          	jalr	1374(ra) # 80005cc2 <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	93c50513          	addi	a0,a0,-1732 # 800080a8 <etext+0xa8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	54e080e7          	jalr	1358(ra) # 80005cc2 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	53e080e7          	jalr	1342(ra) # 80005cc2 <panic>
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
    80000866:	460080e7          	jalr	1120(ra) # 80005cc2 <panic>

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
    800009a8:	31e080e7          	jalr	798(ra) # 80005cc2 <panic>
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
    80000a84:	242080e7          	jalr	578(ra) # 80005cc2 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6a050513          	addi	a0,a0,1696 # 80008128 <etext+0x128>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	232080e7          	jalr	562(ra) # 80005cc2 <panic>
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
    80000afe:	1c8080e7          	jalr	456(ra) # 80005cc2 <panic>

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

0000000080000cd0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd0:	7139                	addi	sp,sp,-64
    80000cd2:	fc06                	sd	ra,56(sp)
    80000cd4:	f822                	sd	s0,48(sp)
    80000cd6:	f426                	sd	s1,40(sp)
    80000cd8:	f04a                	sd	s2,32(sp)
    80000cda:	ec4e                	sd	s3,24(sp)
    80000cdc:	e852                	sd	s4,16(sp)
    80000cde:	e456                	sd	s5,8(sp)
    80000ce0:	e05a                	sd	s6,0(sp)
    80000ce2:	0080                	addi	s0,sp,64
    80000ce4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00008497          	auipc	s1,0x8
    80000cea:	79a48493          	addi	s1,s1,1946 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cee:	8b26                	mv	s6,s1
    80000cf0:	00007a97          	auipc	s5,0x7
    80000cf4:	310a8a93          	addi	s5,s5,784 # 80008000 <etext>
    80000cf8:	04000937          	lui	s2,0x4000
    80000cfc:	197d                	addi	s2,s2,-1
    80000cfe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d00:	0000ea17          	auipc	s4,0xe
    80000d04:	780a0a13          	addi	s4,s4,1920 # 8000f480 <tickslock>
    char *pa = kalloc();
    80000d08:	fffff097          	auipc	ra,0xfffff
    80000d0c:	410080e7          	jalr	1040(ra) # 80000118 <kalloc>
    80000d10:	862a                	mv	a2,a0
    if(pa == 0)
    80000d12:	c131                	beqz	a0,80000d56 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	416485b3          	sub	a1,s1,s6
    80000d18:	859d                	srai	a1,a1,0x7
    80000d1a:	000ab783          	ld	a5,0(s5)
    80000d1e:	02f585b3          	mul	a1,a1,a5
    80000d22:	2585                	addiw	a1,a1,1
    80000d24:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d28:	4719                	li	a4,6
    80000d2a:	6685                	lui	a3,0x1
    80000d2c:	40b905b3          	sub	a1,s2,a1
    80000d30:	854e                	mv	a0,s3
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	8ae080e7          	jalr	-1874(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	18048493          	addi	s1,s1,384
    80000d3e:	fd4495e3          	bne	s1,s4,80000d08 <proc_mapstacks+0x38>
  }
}
    80000d42:	70e2                	ld	ra,56(sp)
    80000d44:	7442                	ld	s0,48(sp)
    80000d46:	74a2                	ld	s1,40(sp)
    80000d48:	7902                	ld	s2,32(sp)
    80000d4a:	69e2                	ld	s3,24(sp)
    80000d4c:	6a42                	ld	s4,16(sp)
    80000d4e:	6aa2                	ld	s5,8(sp)
    80000d50:	6b02                	ld	s6,0(sp)
    80000d52:	6121                	addi	sp,sp,64
    80000d54:	8082                	ret
      panic("kalloc");
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	40250513          	addi	a0,a0,1026 # 80008158 <etext+0x158>
    80000d5e:	00005097          	auipc	ra,0x5
    80000d62:	f64080e7          	jalr	-156(ra) # 80005cc2 <panic>

0000000080000d66 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d66:	7139                	addi	sp,sp,-64
    80000d68:	fc06                	sd	ra,56(sp)
    80000d6a:	f822                	sd	s0,48(sp)
    80000d6c:	f426                	sd	s1,40(sp)
    80000d6e:	f04a                	sd	s2,32(sp)
    80000d70:	ec4e                	sd	s3,24(sp)
    80000d72:	e852                	sd	s4,16(sp)
    80000d74:	e456                	sd	s5,8(sp)
    80000d76:	e05a                	sd	s6,0(sp)
    80000d78:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3e658593          	addi	a1,a1,998 # 80008160 <etext+0x160>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2ce50513          	addi	a0,a0,718 # 80009050 <pid_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	3ba080e7          	jalr	954(ra) # 80006144 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d92:	00007597          	auipc	a1,0x7
    80000d96:	3d658593          	addi	a1,a1,982 # 80008168 <etext+0x168>
    80000d9a:	00008517          	auipc	a0,0x8
    80000d9e:	2ce50513          	addi	a0,a0,718 # 80009068 <wait_lock>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	3a2080e7          	jalr	930(ra) # 80006144 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	00008497          	auipc	s1,0x8
    80000dae:	6d648493          	addi	s1,s1,1750 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db2:	00007b17          	auipc	s6,0x7
    80000db6:	3c6b0b13          	addi	s6,s6,966 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dba:	8aa6                	mv	s5,s1
    80000dbc:	00007a17          	auipc	s4,0x7
    80000dc0:	244a0a13          	addi	s4,s4,580 # 80008000 <etext>
    80000dc4:	04000937          	lui	s2,0x4000
    80000dc8:	197d                	addi	s2,s2,-1
    80000dca:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dcc:	0000e997          	auipc	s3,0xe
    80000dd0:	6b498993          	addi	s3,s3,1716 # 8000f480 <tickslock>
      initlock(&p->lock, "proc");
    80000dd4:	85da                	mv	a1,s6
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	36c080e7          	jalr	876(ra) # 80006144 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	415487b3          	sub	a5,s1,s5
    80000de4:	879d                	srai	a5,a5,0x7
    80000de6:	000a3703          	ld	a4,0(s4)
    80000dea:	02e787b3          	mul	a5,a5,a4
    80000dee:	2785                	addiw	a5,a5,1
    80000df0:	00d7979b          	slliw	a5,a5,0xd
    80000df4:	40f907b3          	sub	a5,s2,a5
    80000df8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	18048493          	addi	s1,s1,384
    80000dfe:	fd349be3          	bne	s1,s3,80000dd4 <procinit+0x6e>
  }
}
    80000e02:	70e2                	ld	ra,56(sp)
    80000e04:	7442                	ld	s0,48(sp)
    80000e06:	74a2                	ld	s1,40(sp)
    80000e08:	7902                	ld	s2,32(sp)
    80000e0a:	69e2                	ld	s3,24(sp)
    80000e0c:	6a42                	ld	s4,16(sp)
    80000e0e:	6aa2                	ld	s5,8(sp)
    80000e10:	6b02                	ld	s6,0(sp)
    80000e12:	6121                	addi	sp,sp,64
    80000e14:	8082                	ret

0000000080000e16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e1e:	2501                	sext.w	a0,a0
    80000e20:	6422                	ld	s0,8(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret

0000000080000e26 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
    80000e2c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e2e:	2781                	sext.w	a5,a5
    80000e30:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e32:	00008517          	auipc	a0,0x8
    80000e36:	24e50513          	addi	a0,a0,590 # 80009080 <cpus>
    80000e3a:	953e                	add	a0,a0,a5
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	1000                	addi	s0,sp,32
  push_off();
    80000e4c:	00005097          	auipc	ra,0x5
    80000e50:	33c080e7          	jalr	828(ra) # 80006188 <push_off>
    80000e54:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
    80000e5a:	00008717          	auipc	a4,0x8
    80000e5e:	1f670713          	addi	a4,a4,502 # 80009050 <pid_lock>
    80000e62:	97ba                	add	a5,a5,a4
    80000e64:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e66:	00005097          	auipc	ra,0x5
    80000e6a:	3c2080e7          	jalr	962(ra) # 80006228 <pop_off>
  return p;
}
    80000e6e:	8526                	mv	a0,s1
    80000e70:	60e2                	ld	ra,24(sp)
    80000e72:	6442                	ld	s0,16(sp)
    80000e74:	64a2                	ld	s1,8(sp)
    80000e76:	6105                	addi	sp,sp,32
    80000e78:	8082                	ret

0000000080000e7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	fc0080e7          	jalr	-64(ra) # 80000e42 <myproc>
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	3fe080e7          	jalr	1022(ra) # 80006288 <release>

  if (first) {
    80000e92:	00008797          	auipc	a5,0x8
    80000e96:	9ae7a783          	lw	a5,-1618(a5) # 80008840 <first.1>
    80000e9a:	eb89                	bnez	a5,80000eac <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	c64080e7          	jalr	-924(ra) # 80001b00 <usertrapret>
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret
    first = 0;
    80000eac:	00008797          	auipc	a5,0x8
    80000eb0:	9807aa23          	sw	zero,-1644(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000eb4:	4505                	li	a0,1
    80000eb6:	00002097          	auipc	ra,0x2
    80000eba:	a94080e7          	jalr	-1388(ra) # 8000294a <fsinit>
    80000ebe:	bff9                	j	80000e9c <forkret+0x22>

0000000080000ec0 <allocpid>:
allocpid() {
    80000ec0:	1101                	addi	sp,sp,-32
    80000ec2:	ec06                	sd	ra,24(sp)
    80000ec4:	e822                	sd	s0,16(sp)
    80000ec6:	e426                	sd	s1,8(sp)
    80000ec8:	e04a                	sd	s2,0(sp)
    80000eca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ecc:	00008917          	auipc	s2,0x8
    80000ed0:	18490913          	addi	s2,s2,388 # 80009050 <pid_lock>
    80000ed4:	854a                	mv	a0,s2
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	2fe080e7          	jalr	766(ra) # 800061d4 <acquire>
  pid = nextpid;
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	96678793          	addi	a5,a5,-1690 # 80008844 <nextpid>
    80000ee6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee8:	0014871b          	addiw	a4,s1,1
    80000eec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	398080e7          	jalr	920(ra) # 80006288 <release>
}
    80000ef8:	8526                	mv	a0,s1
    80000efa:	60e2                	ld	ra,24(sp)
    80000efc:	6442                	ld	s0,16(sp)
    80000efe:	64a2                	ld	s1,8(sp)
    80000f00:	6902                	ld	s2,0(sp)
    80000f02:	6105                	addi	sp,sp,32
    80000f04:	8082                	ret

0000000080000f06 <proc_pagetable>:
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	e04a                	sd	s2,0(sp)
    80000f10:	1000                	addi	s0,sp,32
    80000f12:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	8b6080e7          	jalr	-1866(ra) # 800007ca <uvmcreate>
    80000f1c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f1e:	c121                	beqz	a0,80000f5e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f20:	4729                	li	a4,10
    80000f22:	00006697          	auipc	a3,0x6
    80000f26:	0de68693          	addi	a3,a3,222 # 80007000 <_trampoline>
    80000f2a:	6605                	lui	a2,0x1
    80000f2c:	040005b7          	lui	a1,0x4000
    80000f30:	15fd                	addi	a1,a1,-1
    80000f32:	05b2                	slli	a1,a1,0xc
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	60c080e7          	jalr	1548(ra) # 80000540 <mappages>
    80000f3c:	02054863          	bltz	a0,80000f6c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f40:	4719                	li	a4,6
    80000f42:	05893683          	ld	a3,88(s2)
    80000f46:	6605                	lui	a2,0x1
    80000f48:	020005b7          	lui	a1,0x2000
    80000f4c:	15fd                	addi	a1,a1,-1
    80000f4e:	05b6                	slli	a1,a1,0xd
    80000f50:	8526                	mv	a0,s1
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	5ee080e7          	jalr	1518(ra) # 80000540 <mappages>
    80000f5a:	02054163          	bltz	a0,80000f7c <proc_pagetable+0x76>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	a56080e7          	jalr	-1450(ra) # 800009c6 <uvmfree>
    return 0;
    80000f78:	4481                	li	s1,0
    80000f7a:	b7d5                	j	80000f5e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7c:	4681                	li	a3,0
    80000f7e:	4605                	li	a2,1
    80000f80:	040005b7          	lui	a1,0x4000
    80000f84:	15fd                	addi	a1,a1,-1
    80000f86:	05b2                	slli	a1,a1,0xc
    80000f88:	8526                	mv	a0,s1
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	77c080e7          	jalr	1916(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a30080e7          	jalr	-1488(ra) # 800009c6 <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	bf7d                	j	80000f5e <proc_pagetable+0x58>

0000000080000fa2 <proc_freepagetable>:
{
    80000fa2:	1101                	addi	sp,sp,-32
    80000fa4:	ec06                	sd	ra,24(sp)
    80000fa6:	e822                	sd	s0,16(sp)
    80000fa8:	e426                	sd	s1,8(sp)
    80000faa:	e04a                	sd	s2,0(sp)
    80000fac:	1000                	addi	s0,sp,32
    80000fae:	84aa                	mv	s1,a0
    80000fb0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	040005b7          	lui	a1,0x4000
    80000fba:	15fd                	addi	a1,a1,-1
    80000fbc:	05b2                	slli	a1,a1,0xc
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	748080e7          	jalr	1864(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	020005b7          	lui	a1,0x2000
    80000fce:	15fd                	addi	a1,a1,-1
    80000fd0:	05b6                	slli	a1,a1,0xd
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	732080e7          	jalr	1842(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fdc:	85ca                	mv	a1,s2
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	9e6080e7          	jalr	-1562(ra) # 800009c6 <uvmfree>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6902                	ld	s2,0(sp)
    80000ff0:	6105                	addi	sp,sp,32
    80000ff2:	8082                	ret

0000000080000ff4 <freeproc>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001000:	6d28                	ld	a0,88(a0)
    80001002:	c509                	beqz	a0,8000100c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	018080e7          	jalr	24(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001010:	68a8                	ld	a0,80(s1)
    80001012:	c511                	beqz	a0,8000101e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001014:	64ac                	ld	a1,72(s1)
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	f8c080e7          	jalr	-116(ra) # 80000fa2 <proc_freepagetable>
  if(p->lasttrap)
    8000101e:	1784b503          	ld	a0,376(s1)
    80001022:	c509                	beqz	a0,8000102c <freeproc+0x38>
    kfree((void*)p->lasttrap);
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	ff8080e7          	jalr	-8(ra) # 8000001c <kfree>
  p->pagetable = 0;
    8000102c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001030:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001034:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001038:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001040:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001044:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001048:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104c:	0004ac23          	sw	zero,24(s1)
  p->interval = 0;
    80001050:	1604a823          	sw	zero,368(s1)
  p->ticks = 0;
    80001054:	1604aa23          	sw	zero,372(s1)
  p->handler = 0;
    80001058:	1604b423          	sd	zero,360(s1)
  p->lasttrap = 0;
    8000105c:	1604bc23          	sd	zero,376(s1)
}
    80001060:	60e2                	ld	ra,24(sp)
    80001062:	6442                	ld	s0,16(sp)
    80001064:	64a2                	ld	s1,8(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret

000000008000106a <allocproc>:
{
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001076:	00008497          	auipc	s1,0x8
    8000107a:	40a48493          	addi	s1,s1,1034 # 80009480 <proc>
    8000107e:	0000e917          	auipc	s2,0xe
    80001082:	40290913          	addi	s2,s2,1026 # 8000f480 <tickslock>
    acquire(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	14c080e7          	jalr	332(ra) # 800061d4 <acquire>
    if(p->state == UNUSED) {
    80001090:	4c9c                	lw	a5,24(s1)
    80001092:	cf81                	beqz	a5,800010aa <allocproc+0x40>
      release(&p->lock);
    80001094:	8526                	mv	a0,s1
    80001096:	00005097          	auipc	ra,0x5
    8000109a:	1f2080e7          	jalr	498(ra) # 80006288 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109e:	18048493          	addi	s1,s1,384
    800010a2:	ff2492e3          	bne	s1,s2,80001086 <allocproc+0x1c>
  return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	a88d                	j	8000111a <allocproc+0xb0>
  p->pid = allocpid();
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	e16080e7          	jalr	-490(ra) # 80000ec0 <allocpid>
    800010b2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b4:	4785                	li	a5,1
    800010b6:	cc9c                	sw	a5,24(s1)
  p->interval = 0;
    800010b8:	1604a823          	sw	zero,368(s1)
  p->ticks = 0;
    800010bc:	1604aa23          	sw	zero,372(s1)
  p->handler = 0;
    800010c0:	1604b423          	sd	zero,360(s1)
  p->lasttrap = 0;
    800010c4:	1604bc23          	sd	zero,376(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	050080e7          	jalr	80(ra) # 80000118 <kalloc>
    800010d0:	892a                	mv	s2,a0
    800010d2:	eca8                	sd	a0,88(s1)
    800010d4:	c931                	beqz	a0,80001128 <allocproc+0xbe>
  if((p->lasttrap = (struct trapframe *)kalloc()) == 0)
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	042080e7          	jalr	66(ra) # 80000118 <kalloc>
    800010de:	892a                	mv	s2,a0
    800010e0:	16a4bc23          	sd	a0,376(s1)
    800010e4:	cd31                	beqz	a0,80001140 <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	e1e080e7          	jalr	-482(ra) # 80000f06 <proc_pagetable>
    800010f0:	892a                	mv	s2,a0
    800010f2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f4:	c135                	beqz	a0,80001158 <allocproc+0xee>
  memset(&p->context, 0, sizeof(p->context));
    800010f6:	07000613          	li	a2,112
    800010fa:	4581                	li	a1,0
    800010fc:	06048513          	addi	a0,s1,96
    80001100:	fffff097          	auipc	ra,0xfffff
    80001104:	078080e7          	jalr	120(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001108:	00000797          	auipc	a5,0x0
    8000110c:	d7278793          	addi	a5,a5,-654 # 80000e7a <forkret>
    80001110:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001112:	60bc                	ld	a5,64(s1)
    80001114:	6705                	lui	a4,0x1
    80001116:	97ba                	add	a5,a5,a4
    80001118:	f4bc                	sd	a5,104(s1)
}
    8000111a:	8526                	mv	a0,s1
    8000111c:	60e2                	ld	ra,24(sp)
    8000111e:	6442                	ld	s0,16(sp)
    80001120:	64a2                	ld	s1,8(sp)
    80001122:	6902                	ld	s2,0(sp)
    80001124:	6105                	addi	sp,sp,32
    80001126:	8082                	ret
    freeproc(p);
    80001128:	8526                	mv	a0,s1
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	eca080e7          	jalr	-310(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    80001132:	8526                	mv	a0,s1
    80001134:	00005097          	auipc	ra,0x5
    80001138:	154080e7          	jalr	340(ra) # 80006288 <release>
    return 0;
    8000113c:	84ca                	mv	s1,s2
    8000113e:	bff1                	j	8000111a <allocproc+0xb0>
    freeproc(p);
    80001140:	8526                	mv	a0,s1
    80001142:	00000097          	auipc	ra,0x0
    80001146:	eb2080e7          	jalr	-334(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00005097          	auipc	ra,0x5
    80001150:	13c080e7          	jalr	316(ra) # 80006288 <release>
    return 0;
    80001154:	84ca                	mv	s1,s2
    80001156:	b7d1                	j	8000111a <allocproc+0xb0>
    freeproc(p);
    80001158:	8526                	mv	a0,s1
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	e9a080e7          	jalr	-358(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    80001162:	8526                	mv	a0,s1
    80001164:	00005097          	auipc	ra,0x5
    80001168:	124080e7          	jalr	292(ra) # 80006288 <release>
    return 0;
    8000116c:	84ca                	mv	s1,s2
    8000116e:	b775                	j	8000111a <allocproc+0xb0>

0000000080001170 <userinit>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	1000                	addi	s0,sp,32
  p = allocproc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	ef0080e7          	jalr	-272(ra) # 8000106a <allocproc>
    80001182:	84aa                	mv	s1,a0
  initproc = p;
    80001184:	00008797          	auipc	a5,0x8
    80001188:	e8a7b623          	sd	a0,-372(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000118c:	03400613          	li	a2,52
    80001190:	00007597          	auipc	a1,0x7
    80001194:	6c058593          	addi	a1,a1,1728 # 80008850 <initcode>
    80001198:	6928                	ld	a0,80(a0)
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	65e080e7          	jalr	1630(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    800011a2:	6785                	lui	a5,0x1
    800011a4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ac:	6cb8                	ld	a4,88(s1)
    800011ae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b0:	4641                	li	a2,16
    800011b2:	00007597          	auipc	a1,0x7
    800011b6:	fce58593          	addi	a1,a1,-50 # 80008180 <etext+0x180>
    800011ba:	15848513          	addi	a0,s1,344
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	104080e7          	jalr	260(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011c6:	00007517          	auipc	a0,0x7
    800011ca:	fca50513          	addi	a0,a0,-54 # 80008190 <etext+0x190>
    800011ce:	00002097          	auipc	ra,0x2
    800011d2:	1aa080e7          	jalr	426(ra) # 80003378 <namei>
    800011d6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011da:	478d                	li	a5,3
    800011dc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	00005097          	auipc	ra,0x5
    800011e4:	0a8080e7          	jalr	168(ra) # 80006288 <release>
}
    800011e8:	60e2                	ld	ra,24(sp)
    800011ea:	6442                	ld	s0,16(sp)
    800011ec:	64a2                	ld	s1,8(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret

00000000800011f2 <growproc>:
{
    800011f2:	1101                	addi	sp,sp,-32
    800011f4:	ec06                	sd	ra,24(sp)
    800011f6:	e822                	sd	s0,16(sp)
    800011f8:	e426                	sd	s1,8(sp)
    800011fa:	e04a                	sd	s2,0(sp)
    800011fc:	1000                	addi	s0,sp,32
    800011fe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001200:	00000097          	auipc	ra,0x0
    80001204:	c42080e7          	jalr	-958(ra) # 80000e42 <myproc>
    80001208:	892a                	mv	s2,a0
  sz = p->sz;
    8000120a:	652c                	ld	a1,72(a0)
    8000120c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001210:	00904f63          	bgtz	s1,8000122e <growproc+0x3c>
  } else if(n < 0){
    80001214:	0204cc63          	bltz	s1,8000124c <growproc+0x5a>
  p->sz = sz;
    80001218:	1602                	slli	a2,a2,0x20
    8000121a:	9201                	srli	a2,a2,0x20
    8000121c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001220:	4501                	li	a0,0
}
    80001222:	60e2                	ld	ra,24(sp)
    80001224:	6442                	ld	s0,16(sp)
    80001226:	64a2                	ld	s1,8(sp)
    80001228:	6902                	ld	s2,0(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000122e:	9e25                	addw	a2,a2,s1
    80001230:	1602                	slli	a2,a2,0x20
    80001232:	9201                	srli	a2,a2,0x20
    80001234:	1582                	slli	a1,a1,0x20
    80001236:	9181                	srli	a1,a1,0x20
    80001238:	6928                	ld	a0,80(a0)
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	678080e7          	jalr	1656(ra) # 800008b2 <uvmalloc>
    80001242:	0005061b          	sext.w	a2,a0
    80001246:	fa69                	bnez	a2,80001218 <growproc+0x26>
      return -1;
    80001248:	557d                	li	a0,-1
    8000124a:	bfe1                	j	80001222 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000124c:	9e25                	addw	a2,a2,s1
    8000124e:	1602                	slli	a2,a2,0x20
    80001250:	9201                	srli	a2,a2,0x20
    80001252:	1582                	slli	a1,a1,0x20
    80001254:	9181                	srli	a1,a1,0x20
    80001256:	6928                	ld	a0,80(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	612080e7          	jalr	1554(ra) # 8000086a <uvmdealloc>
    80001260:	0005061b          	sext.w	a2,a0
    80001264:	bf55                	j	80001218 <growproc+0x26>

0000000080001266 <fork>:
{
    80001266:	7139                	addi	sp,sp,-64
    80001268:	fc06                	sd	ra,56(sp)
    8000126a:	f822                	sd	s0,48(sp)
    8000126c:	f426                	sd	s1,40(sp)
    8000126e:	f04a                	sd	s2,32(sp)
    80001270:	ec4e                	sd	s3,24(sp)
    80001272:	e852                	sd	s4,16(sp)
    80001274:	e456                	sd	s5,8(sp)
    80001276:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	bca080e7          	jalr	-1078(ra) # 80000e42 <myproc>
    80001280:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001282:	00000097          	auipc	ra,0x0
    80001286:	de8080e7          	jalr	-536(ra) # 8000106a <allocproc>
    8000128a:	10050c63          	beqz	a0,800013a2 <fork+0x13c>
    8000128e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001290:	048ab603          	ld	a2,72(s5)
    80001294:	692c                	ld	a1,80(a0)
    80001296:	050ab503          	ld	a0,80(s5)
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	764080e7          	jalr	1892(ra) # 800009fe <uvmcopy>
    800012a2:	04054863          	bltz	a0,800012f2 <fork+0x8c>
  np->sz = p->sz;
    800012a6:	048ab783          	ld	a5,72(s5)
    800012aa:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012ae:	058ab683          	ld	a3,88(s5)
    800012b2:	87b6                	mv	a5,a3
    800012b4:	058a3703          	ld	a4,88(s4)
    800012b8:	12068693          	addi	a3,a3,288
    800012bc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c0:	6788                	ld	a0,8(a5)
    800012c2:	6b8c                	ld	a1,16(a5)
    800012c4:	6f90                	ld	a2,24(a5)
    800012c6:	01073023          	sd	a6,0(a4)
    800012ca:	e708                	sd	a0,8(a4)
    800012cc:	eb0c                	sd	a1,16(a4)
    800012ce:	ef10                	sd	a2,24(a4)
    800012d0:	02078793          	addi	a5,a5,32
    800012d4:	02070713          	addi	a4,a4,32
    800012d8:	fed792e3          	bne	a5,a3,800012bc <fork+0x56>
  np->trapframe->a0 = 0;
    800012dc:	058a3783          	ld	a5,88(s4)
    800012e0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e4:	0d0a8493          	addi	s1,s5,208
    800012e8:	0d0a0913          	addi	s2,s4,208
    800012ec:	150a8993          	addi	s3,s5,336
    800012f0:	a00d                	j	80001312 <fork+0xac>
    freeproc(np);
    800012f2:	8552                	mv	a0,s4
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	d00080e7          	jalr	-768(ra) # 80000ff4 <freeproc>
    release(&np->lock);
    800012fc:	8552                	mv	a0,s4
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	f8a080e7          	jalr	-118(ra) # 80006288 <release>
    return -1;
    80001306:	597d                	li	s2,-1
    80001308:	a059                	j	8000138e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000130a:	04a1                	addi	s1,s1,8
    8000130c:	0921                	addi	s2,s2,8
    8000130e:	01348b63          	beq	s1,s3,80001324 <fork+0xbe>
    if(p->ofile[i])
    80001312:	6088                	ld	a0,0(s1)
    80001314:	d97d                	beqz	a0,8000130a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001316:	00002097          	auipc	ra,0x2
    8000131a:	6f8080e7          	jalr	1784(ra) # 80003a0e <filedup>
    8000131e:	00a93023          	sd	a0,0(s2)
    80001322:	b7e5                	j	8000130a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001324:	150ab503          	ld	a0,336(s5)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	85c080e7          	jalr	-1956(ra) # 80002b84 <idup>
    80001330:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001334:	4641                	li	a2,16
    80001336:	158a8593          	addi	a1,s5,344
    8000133a:	158a0513          	addi	a0,s4,344
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	f84080e7          	jalr	-124(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001346:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000134a:	8552                	mv	a0,s4
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f3c080e7          	jalr	-196(ra) # 80006288 <release>
  acquire(&wait_lock);
    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e76080e7          	jalr	-394(ra) # 800061d4 <acquire>
  np->parent = p;
    80001366:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	f1c080e7          	jalr	-228(ra) # 80006288 <release>
  acquire(&np->lock);
    80001374:	8552                	mv	a0,s4
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e5e080e7          	jalr	-418(ra) # 800061d4 <acquire>
  np->state = RUNNABLE;
    8000137e:	478d                	li	a5,3
    80001380:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001384:	8552                	mv	a0,s4
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	f02080e7          	jalr	-254(ra) # 80006288 <release>
}
    8000138e:	854a                	mv	a0,s2
    80001390:	70e2                	ld	ra,56(sp)
    80001392:	7442                	ld	s0,48(sp)
    80001394:	74a2                	ld	s1,40(sp)
    80001396:	7902                	ld	s2,32(sp)
    80001398:	69e2                	ld	s3,24(sp)
    8000139a:	6a42                	ld	s4,16(sp)
    8000139c:	6aa2                	ld	s5,8(sp)
    8000139e:	6121                	addi	sp,sp,64
    800013a0:	8082                	ret
    return -1;
    800013a2:	597d                	li	s2,-1
    800013a4:	b7ed                	j	8000138e <fork+0x128>

00000000800013a6 <scheduler>:
{
    800013a6:	7139                	addi	sp,sp,-64
    800013a8:	fc06                	sd	ra,56(sp)
    800013aa:	f822                	sd	s0,48(sp)
    800013ac:	f426                	sd	s1,40(sp)
    800013ae:	f04a                	sd	s2,32(sp)
    800013b0:	ec4e                	sd	s3,24(sp)
    800013b2:	e852                	sd	s4,16(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	e05a                	sd	s6,0(sp)
    800013b8:	0080                	addi	s0,sp,64
    800013ba:	8792                	mv	a5,tp
  int id = r_tp();
    800013bc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013be:	00779a93          	slli	s5,a5,0x7
    800013c2:	00008717          	auipc	a4,0x8
    800013c6:	c8e70713          	addi	a4,a4,-882 # 80009050 <pid_lock>
    800013ca:	9756                	add	a4,a4,s5
    800013cc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d0:	00008717          	auipc	a4,0x8
    800013d4:	cb870713          	addi	a4,a4,-840 # 80009088 <cpus+0x8>
    800013d8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013da:	498d                	li	s3,3
        p->state = RUNNING;
    800013dc:	4b11                	li	s6,4
        c->proc = p;
    800013de:	079e                	slli	a5,a5,0x7
    800013e0:	00008a17          	auipc	s4,0x8
    800013e4:	c70a0a13          	addi	s4,s4,-912 # 80009050 <pid_lock>
    800013e8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000e917          	auipc	s2,0xe
    800013ee:	09690913          	addi	s2,s2,150 # 8000f480 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fa:	10079073          	csrw	sstatus,a5
    800013fe:	00008497          	auipc	s1,0x8
    80001402:	08248493          	addi	s1,s1,130 # 80009480 <proc>
    80001406:	a811                	j	8000141a <scheduler+0x74>
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	e7e080e7          	jalr	-386(ra) # 80006288 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	18048493          	addi	s1,s1,384
    80001416:	fd248ee3          	beq	s1,s2,800013f2 <scheduler+0x4c>
      acquire(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	db8080e7          	jalr	-584(ra) # 800061d4 <acquire>
      if(p->state == RUNNABLE) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <scheduler+0x62>
        p->state = RUNNING;
    8000142a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001432:	06048593          	addi	a1,s1,96
    80001436:	8556                	mv	a0,s5
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	61e080e7          	jalr	1566(ra) # 80001a56 <swtch>
        c->proc = 0;
    80001440:	020a3823          	sd	zero,48(s4)
    80001444:	b7d1                	j	80001408 <scheduler+0x62>

0000000080001446 <sched>:
{
    80001446:	7179                	addi	sp,sp,-48
    80001448:	f406                	sd	ra,40(sp)
    8000144a:	f022                	sd	s0,32(sp)
    8000144c:	ec26                	sd	s1,24(sp)
    8000144e:	e84a                	sd	s2,16(sp)
    80001450:	e44e                	sd	s3,8(sp)
    80001452:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001454:	00000097          	auipc	ra,0x0
    80001458:	9ee080e7          	jalr	-1554(ra) # 80000e42 <myproc>
    8000145c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145e:	00005097          	auipc	ra,0x5
    80001462:	cfc080e7          	jalr	-772(ra) # 8000615a <holding>
    80001466:	c93d                	beqz	a0,800014dc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001468:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146a:	2781                	sext.w	a5,a5
    8000146c:	079e                	slli	a5,a5,0x7
    8000146e:	00008717          	auipc	a4,0x8
    80001472:	be270713          	addi	a4,a4,-1054 # 80009050 <pid_lock>
    80001476:	97ba                	add	a5,a5,a4
    80001478:	0a87a703          	lw	a4,168(a5)
    8000147c:	4785                	li	a5,1
    8000147e:	06f71763          	bne	a4,a5,800014ec <sched+0xa6>
  if(p->state == RUNNING)
    80001482:	4c98                	lw	a4,24(s1)
    80001484:	4791                	li	a5,4
    80001486:	06f70b63          	beq	a4,a5,800014fc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001490:	efb5                	bnez	a5,8000150c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001492:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001494:	00008917          	auipc	s2,0x8
    80001498:	bbc90913          	addi	s2,s2,-1092 # 80009050 <pid_lock>
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	97ca                	add	a5,a5,s2
    800014a2:	0ac7a983          	lw	s3,172(a5)
    800014a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	slli	a5,a5,0x7
    800014ac:	00008597          	auipc	a1,0x8
    800014b0:	bdc58593          	addi	a1,a1,-1060 # 80009088 <cpus+0x8>
    800014b4:	95be                	add	a1,a1,a5
    800014b6:	06048513          	addi	a0,s1,96
    800014ba:	00000097          	auipc	ra,0x0
    800014be:	59c080e7          	jalr	1436(ra) # 80001a56 <swtch>
    800014c2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	slli	a5,a5,0x7
    800014c8:	97ca                	add	a5,a5,s2
    800014ca:	0b37a623          	sw	s3,172(a5)
}
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6145                	addi	sp,sp,48
    800014da:	8082                	ret
    panic("sched p->lock");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cbc50513          	addi	a0,a0,-836 # 80008198 <etext+0x198>
    800014e4:	00004097          	auipc	ra,0x4
    800014e8:	7de080e7          	jalr	2014(ra) # 80005cc2 <panic>
    panic("sched locks");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cbc50513          	addi	a0,a0,-836 # 800081a8 <etext+0x1a8>
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	7ce080e7          	jalr	1998(ra) # 80005cc2 <panic>
    panic("sched running");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cbc50513          	addi	a0,a0,-836 # 800081b8 <etext+0x1b8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	7be080e7          	jalr	1982(ra) # 80005cc2 <panic>
    panic("sched interruptible");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cbc50513          	addi	a0,a0,-836 # 800081c8 <etext+0x1c8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	7ae080e7          	jalr	1966(ra) # 80005cc2 <panic>

000000008000151c <yield>:
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	91c080e7          	jalr	-1764(ra) # 80000e42 <myproc>
    8000152e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001530:	00005097          	auipc	ra,0x5
    80001534:	ca4080e7          	jalr	-860(ra) # 800061d4 <acquire>
  p->state = RUNNABLE;
    80001538:	478d                	li	a5,3
    8000153a:	cc9c                	sw	a5,24(s1)
  sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f0a080e7          	jalr	-246(ra) # 80001446 <sched>
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	d42080e7          	jalr	-702(ra) # 80006288 <release>
}
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	addi	sp,sp,32
    80001556:	8082                	ret

0000000080001558 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001558:	7179                	addi	sp,sp,-48
    8000155a:	f406                	sd	ra,40(sp)
    8000155c:	f022                	sd	s0,32(sp)
    8000155e:	ec26                	sd	s1,24(sp)
    80001560:	e84a                	sd	s2,16(sp)
    80001562:	e44e                	sd	s3,8(sp)
    80001564:	1800                	addi	s0,sp,48
    80001566:	89aa                	mv	s3,a0
    80001568:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	8d8080e7          	jalr	-1832(ra) # 80000e42 <myproc>
    80001572:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	c60080e7          	jalr	-928(ra) # 800061d4 <acquire>
  release(lk);
    8000157c:	854a                	mv	a0,s2
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	d0a080e7          	jalr	-758(ra) # 80006288 <release>

  // Go to sleep.
  p->chan = chan;
    80001586:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158a:	4789                	li	a5,2
    8000158c:	cc9c                	sw	a5,24(s1)

  sched();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	eb8080e7          	jalr	-328(ra) # 80001446 <sched>

  // Tidy up.
  p->chan = 0;
    80001596:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	cec080e7          	jalr	-788(ra) # 80006288 <release>
  acquire(lk);
    800015a4:	854a                	mv	a0,s2
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	c2e080e7          	jalr	-978(ra) # 800061d4 <acquire>
}
    800015ae:	70a2                	ld	ra,40(sp)
    800015b0:	7402                	ld	s0,32(sp)
    800015b2:	64e2                	ld	s1,24(sp)
    800015b4:	6942                	ld	s2,16(sp)
    800015b6:	69a2                	ld	s3,8(sp)
    800015b8:	6145                	addi	sp,sp,48
    800015ba:	8082                	ret

00000000800015bc <wait>:
{
    800015bc:	715d                	addi	sp,sp,-80
    800015be:	e486                	sd	ra,72(sp)
    800015c0:	e0a2                	sd	s0,64(sp)
    800015c2:	fc26                	sd	s1,56(sp)
    800015c4:	f84a                	sd	s2,48(sp)
    800015c6:	f44e                	sd	s3,40(sp)
    800015c8:	f052                	sd	s4,32(sp)
    800015ca:	ec56                	sd	s5,24(sp)
    800015cc:	e85a                	sd	s6,16(sp)
    800015ce:	e45e                	sd	s7,8(sp)
    800015d0:	e062                	sd	s8,0(sp)
    800015d2:	0880                	addi	s0,sp,80
    800015d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	86c080e7          	jalr	-1940(ra) # 80000e42 <myproc>
    800015de:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e0:	00008517          	auipc	a0,0x8
    800015e4:	a8850513          	addi	a0,a0,-1400 # 80009068 <wait_lock>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	bec080e7          	jalr	-1044(ra) # 800061d4 <acquire>
    havekids = 0;
    800015f0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f2:	4a15                	li	s4,5
        havekids = 1;
    800015f4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f6:	0000e997          	auipc	s3,0xe
    800015fa:	e8a98993          	addi	s3,s3,-374 # 8000f480 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fe:	00008c17          	auipc	s8,0x8
    80001602:	a6ac0c13          	addi	s8,s8,-1430 # 80009068 <wait_lock>
    havekids = 0;
    80001606:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001608:	00008497          	auipc	s1,0x8
    8000160c:	e7848493          	addi	s1,s1,-392 # 80009480 <proc>
    80001610:	a0bd                	j	8000167e <wait+0xc2>
          pid = np->pid;
    80001612:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001616:	000b0e63          	beqz	s6,80001632 <wait+0x76>
    8000161a:	4691                	li	a3,4
    8000161c:	02c48613          	addi	a2,s1,44
    80001620:	85da                	mv	a1,s6
    80001622:	05093503          	ld	a0,80(s2)
    80001626:	fffff097          	auipc	ra,0xfffff
    8000162a:	4dc080e7          	jalr	1244(ra) # 80000b02 <copyout>
    8000162e:	02054563          	bltz	a0,80001658 <wait+0x9c>
          freeproc(np);
    80001632:	8526                	mv	a0,s1
    80001634:	00000097          	auipc	ra,0x0
    80001638:	9c0080e7          	jalr	-1600(ra) # 80000ff4 <freeproc>
          release(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	c4a080e7          	jalr	-950(ra) # 80006288 <release>
          release(&wait_lock);
    80001646:	00008517          	auipc	a0,0x8
    8000164a:	a2250513          	addi	a0,a0,-1502 # 80009068 <wait_lock>
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	c3a080e7          	jalr	-966(ra) # 80006288 <release>
          return pid;
    80001656:	a09d                	j	800016bc <wait+0x100>
            release(&np->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	c2e080e7          	jalr	-978(ra) # 80006288 <release>
            release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	c1e080e7          	jalr	-994(ra) # 80006288 <release>
            return -1;
    80001672:	59fd                	li	s3,-1
    80001674:	a0a1                	j	800016bc <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001676:	18048493          	addi	s1,s1,384
    8000167a:	03348463          	beq	s1,s3,800016a2 <wait+0xe6>
      if(np->parent == p){
    8000167e:	7c9c                	ld	a5,56(s1)
    80001680:	ff279be3          	bne	a5,s2,80001676 <wait+0xba>
        acquire(&np->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	b4e080e7          	jalr	-1202(ra) # 800061d4 <acquire>
        if(np->state == ZOMBIE){
    8000168e:	4c9c                	lw	a5,24(s1)
    80001690:	f94781e3          	beq	a5,s4,80001612 <wait+0x56>
        release(&np->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	bf2080e7          	jalr	-1038(ra) # 80006288 <release>
        havekids = 1;
    8000169e:	8756                	mv	a4,s5
    800016a0:	bfd9                	j	80001676 <wait+0xba>
    if(!havekids || p->killed){
    800016a2:	c701                	beqz	a4,800016aa <wait+0xee>
    800016a4:	02892783          	lw	a5,40(s2)
    800016a8:	c79d                	beqz	a5,800016d6 <wait+0x11a>
      release(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	9be50513          	addi	a0,a0,-1602 # 80009068 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	bd6080e7          	jalr	-1066(ra) # 80006288 <release>
      return -1;
    800016ba:	59fd                	li	s3,-1
}
    800016bc:	854e                	mv	a0,s3
    800016be:	60a6                	ld	ra,72(sp)
    800016c0:	6406                	ld	s0,64(sp)
    800016c2:	74e2                	ld	s1,56(sp)
    800016c4:	7942                	ld	s2,48(sp)
    800016c6:	79a2                	ld	s3,40(sp)
    800016c8:	7a02                	ld	s4,32(sp)
    800016ca:	6ae2                	ld	s5,24(sp)
    800016cc:	6b42                	ld	s6,16(sp)
    800016ce:	6ba2                	ld	s7,8(sp)
    800016d0:	6c02                	ld	s8,0(sp)
    800016d2:	6161                	addi	sp,sp,80
    800016d4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d6:	85e2                	mv	a1,s8
    800016d8:	854a                	mv	a0,s2
    800016da:	00000097          	auipc	ra,0x0
    800016de:	e7e080e7          	jalr	-386(ra) # 80001558 <sleep>
    havekids = 0;
    800016e2:	b715                	j	80001606 <wait+0x4a>

00000000800016e4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e4:	7139                	addi	sp,sp,-64
    800016e6:	fc06                	sd	ra,56(sp)
    800016e8:	f822                	sd	s0,48(sp)
    800016ea:	f426                	sd	s1,40(sp)
    800016ec:	f04a                	sd	s2,32(sp)
    800016ee:	ec4e                	sd	s3,24(sp)
    800016f0:	e852                	sd	s4,16(sp)
    800016f2:	e456                	sd	s5,8(sp)
    800016f4:	0080                	addi	s0,sp,64
    800016f6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	00008497          	auipc	s1,0x8
    800016fc:	d8848493          	addi	s1,s1,-632 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001700:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001702:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001704:	0000e917          	auipc	s2,0xe
    80001708:	d7c90913          	addi	s2,s2,-644 # 8000f480 <tickslock>
    8000170c:	a811                	j	80001720 <wakeup+0x3c>
      }
      release(&p->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	00005097          	auipc	ra,0x5
    80001714:	b78080e7          	jalr	-1160(ra) # 80006288 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001718:	18048493          	addi	s1,s1,384
    8000171c:	03248663          	beq	s1,s2,80001748 <wakeup+0x64>
    if(p != myproc()){
    80001720:	fffff097          	auipc	ra,0xfffff
    80001724:	722080e7          	jalr	1826(ra) # 80000e42 <myproc>
    80001728:	fea488e3          	beq	s1,a0,80001718 <wakeup+0x34>
      acquire(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	aa6080e7          	jalr	-1370(ra) # 800061d4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001736:	4c9c                	lw	a5,24(s1)
    80001738:	fd379be3          	bne	a5,s3,8000170e <wakeup+0x2a>
    8000173c:	709c                	ld	a5,32(s1)
    8000173e:	fd4798e3          	bne	a5,s4,8000170e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001742:	0154ac23          	sw	s5,24(s1)
    80001746:	b7e1                	j	8000170e <wakeup+0x2a>
    }
  }
}
    80001748:	70e2                	ld	ra,56(sp)
    8000174a:	7442                	ld	s0,48(sp)
    8000174c:	74a2                	ld	s1,40(sp)
    8000174e:	7902                	ld	s2,32(sp)
    80001750:	69e2                	ld	s3,24(sp)
    80001752:	6a42                	ld	s4,16(sp)
    80001754:	6aa2                	ld	s5,8(sp)
    80001756:	6121                	addi	sp,sp,64
    80001758:	8082                	ret

000000008000175a <reparent>:
{
    8000175a:	7179                	addi	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	e052                	sd	s4,0(sp)
    80001768:	1800                	addi	s0,sp,48
    8000176a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176c:	00008497          	auipc	s1,0x8
    80001770:	d1448493          	addi	s1,s1,-748 # 80009480 <proc>
      pp->parent = initproc;
    80001774:	00008a17          	auipc	s4,0x8
    80001778:	89ca0a13          	addi	s4,s4,-1892 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177c:	0000e997          	auipc	s3,0xe
    80001780:	d0498993          	addi	s3,s3,-764 # 8000f480 <tickslock>
    80001784:	a029                	j	8000178e <reparent+0x34>
    80001786:	18048493          	addi	s1,s1,384
    8000178a:	01348d63          	beq	s1,s3,800017a4 <reparent+0x4a>
    if(pp->parent == p){
    8000178e:	7c9c                	ld	a5,56(s1)
    80001790:	ff279be3          	bne	a5,s2,80001786 <reparent+0x2c>
      pp->parent = initproc;
    80001794:	000a3503          	ld	a0,0(s4)
    80001798:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179a:	00000097          	auipc	ra,0x0
    8000179e:	f4a080e7          	jalr	-182(ra) # 800016e4 <wakeup>
    800017a2:	b7d5                	j	80001786 <reparent+0x2c>
}
    800017a4:	70a2                	ld	ra,40(sp)
    800017a6:	7402                	ld	s0,32(sp)
    800017a8:	64e2                	ld	s1,24(sp)
    800017aa:	6942                	ld	s2,16(sp)
    800017ac:	69a2                	ld	s3,8(sp)
    800017ae:	6a02                	ld	s4,0(sp)
    800017b0:	6145                	addi	sp,sp,48
    800017b2:	8082                	ret

00000000800017b4 <exit>:
{
    800017b4:	7179                	addi	sp,sp,-48
    800017b6:	f406                	sd	ra,40(sp)
    800017b8:	f022                	sd	s0,32(sp)
    800017ba:	ec26                	sd	s1,24(sp)
    800017bc:	e84a                	sd	s2,16(sp)
    800017be:	e44e                	sd	s3,8(sp)
    800017c0:	e052                	sd	s4,0(sp)
    800017c2:	1800                	addi	s0,sp,48
    800017c4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	67c080e7          	jalr	1660(ra) # 80000e42 <myproc>
    800017ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d0:	00008797          	auipc	a5,0x8
    800017d4:	8407b783          	ld	a5,-1984(a5) # 80009010 <initproc>
    800017d8:	0d050493          	addi	s1,a0,208
    800017dc:	15050913          	addi	s2,a0,336
    800017e0:	02a79363          	bne	a5,a0,80001806 <exit+0x52>
    panic("init exiting");
    800017e4:	00007517          	auipc	a0,0x7
    800017e8:	9fc50513          	addi	a0,a0,-1540 # 800081e0 <etext+0x1e0>
    800017ec:	00004097          	auipc	ra,0x4
    800017f0:	4d6080e7          	jalr	1238(ra) # 80005cc2 <panic>
      fileclose(f);
    800017f4:	00002097          	auipc	ra,0x2
    800017f8:	26c080e7          	jalr	620(ra) # 80003a60 <fileclose>
      p->ofile[fd] = 0;
    800017fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001800:	04a1                	addi	s1,s1,8
    80001802:	01248563          	beq	s1,s2,8000180c <exit+0x58>
    if(p->ofile[fd]){
    80001806:	6088                	ld	a0,0(s1)
    80001808:	f575                	bnez	a0,800017f4 <exit+0x40>
    8000180a:	bfdd                	j	80001800 <exit+0x4c>
  begin_op();
    8000180c:	00002097          	auipc	ra,0x2
    80001810:	d88080e7          	jalr	-632(ra) # 80003594 <begin_op>
  iput(p->cwd);
    80001814:	1509b503          	ld	a0,336(s3)
    80001818:	00001097          	auipc	ra,0x1
    8000181c:	564080e7          	jalr	1380(ra) # 80002d7c <iput>
  end_op();
    80001820:	00002097          	auipc	ra,0x2
    80001824:	df4080e7          	jalr	-524(ra) # 80003614 <end_op>
  p->cwd = 0;
    80001828:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182c:	00008497          	auipc	s1,0x8
    80001830:	83c48493          	addi	s1,s1,-1988 # 80009068 <wait_lock>
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	99e080e7          	jalr	-1634(ra) # 800061d4 <acquire>
  reparent(p);
    8000183e:	854e                	mv	a0,s3
    80001840:	00000097          	auipc	ra,0x0
    80001844:	f1a080e7          	jalr	-230(ra) # 8000175a <reparent>
  wakeup(p->parent);
    80001848:	0389b503          	ld	a0,56(s3)
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	e98080e7          	jalr	-360(ra) # 800016e4 <wakeup>
  acquire(&p->lock);
    80001854:	854e                	mv	a0,s3
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	97e080e7          	jalr	-1666(ra) # 800061d4 <acquire>
  p->xstate = status;
    8000185e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001862:	4795                	li	a5,5
    80001864:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	a1e080e7          	jalr	-1506(ra) # 80006288 <release>
  sched();
    80001872:	00000097          	auipc	ra,0x0
    80001876:	bd4080e7          	jalr	-1068(ra) # 80001446 <sched>
  panic("zombie exit");
    8000187a:	00007517          	auipc	a0,0x7
    8000187e:	97650513          	addi	a0,a0,-1674 # 800081f0 <etext+0x1f0>
    80001882:	00004097          	auipc	ra,0x4
    80001886:	440080e7          	jalr	1088(ra) # 80005cc2 <panic>

000000008000188a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188a:	7179                	addi	sp,sp,-48
    8000188c:	f406                	sd	ra,40(sp)
    8000188e:	f022                	sd	s0,32(sp)
    80001890:	ec26                	sd	s1,24(sp)
    80001892:	e84a                	sd	s2,16(sp)
    80001894:	e44e                	sd	s3,8(sp)
    80001896:	1800                	addi	s0,sp,48
    80001898:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189a:	00008497          	auipc	s1,0x8
    8000189e:	be648493          	addi	s1,s1,-1050 # 80009480 <proc>
    800018a2:	0000e997          	auipc	s3,0xe
    800018a6:	bde98993          	addi	s3,s3,-1058 # 8000f480 <tickslock>
    acquire(&p->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	928080e7          	jalr	-1752(ra) # 800061d4 <acquire>
    if(p->pid == pid){
    800018b4:	589c                	lw	a5,48(s1)
    800018b6:	01278d63          	beq	a5,s2,800018d0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	9cc080e7          	jalr	-1588(ra) # 80006288 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c4:	18048493          	addi	s1,s1,384
    800018c8:	ff3491e3          	bne	s1,s3,800018aa <kill+0x20>
  }
  return -1;
    800018cc:	557d                	li	a0,-1
    800018ce:	a829                	j	800018e8 <kill+0x5e>
      p->killed = 1;
    800018d0:	4785                	li	a5,1
    800018d2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d4:	4c98                	lw	a4,24(s1)
    800018d6:	4789                	li	a5,2
    800018d8:	00f70f63          	beq	a4,a5,800018f6 <kill+0x6c>
      release(&p->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	9aa080e7          	jalr	-1622(ra) # 80006288 <release>
      return 0;
    800018e6:	4501                	li	a0,0
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret
        p->state = RUNNABLE;
    800018f6:	478d                	li	a5,3
    800018f8:	cc9c                	sw	a5,24(s1)
    800018fa:	b7cd                	j	800018dc <kill+0x52>

00000000800018fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	84aa                	mv	s1,a0
    8000190e:	892e                	mv	s2,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	52e080e7          	jalr	1326(ra) # 80000e42 <myproc>
  if(user_dst){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	1dc080e7          	jalr	476(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove((char *)dst, src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	88e080e7          	jalr	-1906(ra) # 800001d4 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyout+0x32>

0000000080001952 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	892a                	mv	s2,a0
    80001964:	84ae                	mv	s1,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	4d8080e7          	jalr	1240(ra) # 80000e42 <myproc>
  if(user_src){
    80001972:	c08d                	beqz	s1,80001994 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	212080e7          	jalr	530(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
    memmove(dst, (char*)src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	838080e7          	jalr	-1992(ra) # 800001d4 <memmove>
    return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyin+0x32>

00000000800019a8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a8:	715d                	addi	sp,sp,-80
    800019aa:	e486                	sd	ra,72(sp)
    800019ac:	e0a2                	sd	s0,64(sp)
    800019ae:	fc26                	sd	s1,56(sp)
    800019b0:	f84a                	sd	s2,48(sp)
    800019b2:	f44e                	sd	s3,40(sp)
    800019b4:	f052                	sd	s4,32(sp)
    800019b6:	ec56                	sd	s5,24(sp)
    800019b8:	e85a                	sd	s6,16(sp)
    800019ba:	e45e                	sd	s7,8(sp)
    800019bc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019be:	00006517          	auipc	a0,0x6
    800019c2:	68a50513          	addi	a0,a0,1674 # 80008048 <etext+0x48>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	34e080e7          	jalr	846(ra) # 80005d14 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	00008497          	auipc	s1,0x8
    800019d2:	c0a48493          	addi	s1,s1,-1014 # 800095d8 <proc+0x158>
    800019d6:	0000e917          	auipc	s2,0xe
    800019da:	c0290913          	addi	s2,s2,-1022 # 8000f5d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e0:	00007997          	auipc	s3,0x7
    800019e4:	82098993          	addi	s3,s3,-2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	00007a97          	auipc	s5,0x7
    800019ec:	820a8a93          	addi	s5,s5,-2016 # 80008208 <etext+0x208>
    printf("\n");
    800019f0:	00006a17          	auipc	s4,0x6
    800019f4:	658a0a13          	addi	s4,s4,1624 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f8:	00007b97          	auipc	s7,0x7
    800019fc:	848b8b93          	addi	s7,s7,-1976 # 80008240 <states.0>
    80001a00:	a00d                	j	80001a22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a02:	ed86a583          	lw	a1,-296(a3)
    80001a06:	8556                	mv	a0,s5
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	30c080e7          	jalr	780(ra) # 80005d14 <printf>
    printf("\n");
    80001a10:	8552                	mv	a0,s4
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	302080e7          	jalr	770(ra) # 80005d14 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	18048493          	addi	s1,s1,384
    80001a1e:	03248163          	beq	s1,s2,80001a40 <procdump+0x98>
    if(p->state == UNUSED)
    80001a22:	86a6                	mv	a3,s1
    80001a24:	ec04a783          	lw	a5,-320(s1)
    80001a28:	dbed                	beqz	a5,80001a1a <procdump+0x72>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	fcfb6be3          	bltu	s6,a5,80001a02 <procdump+0x5a>
    80001a30:	1782                	slli	a5,a5,0x20
    80001a32:	9381                	srli	a5,a5,0x20
    80001a34:	078e                	slli	a5,a5,0x3
    80001a36:	97de                	add	a5,a5,s7
    80001a38:	6390                	ld	a2,0(a5)
    80001a3a:	f661                	bnez	a2,80001a02 <procdump+0x5a>
      state = "???";
    80001a3c:	864e                	mv	a2,s3
    80001a3e:	b7d1                	j	80001a02 <procdump+0x5a>
  }
}
    80001a40:	60a6                	ld	ra,72(sp)
    80001a42:	6406                	ld	s0,64(sp)
    80001a44:	74e2                	ld	s1,56(sp)
    80001a46:	7942                	ld	s2,48(sp)
    80001a48:	79a2                	ld	s3,40(sp)
    80001a4a:	7a02                	ld	s4,32(sp)
    80001a4c:	6ae2                	ld	s5,24(sp)
    80001a4e:	6b42                	ld	s6,16(sp)
    80001a50:	6ba2                	ld	s7,8(sp)
    80001a52:	6161                	addi	sp,sp,80
    80001a54:	8082                	ret

0000000080001a56 <swtch>:
    80001a56:	00153023          	sd	ra,0(a0)
    80001a5a:	00253423          	sd	sp,8(a0)
    80001a5e:	e900                	sd	s0,16(a0)
    80001a60:	ed04                	sd	s1,24(a0)
    80001a62:	03253023          	sd	s2,32(a0)
    80001a66:	03353423          	sd	s3,40(a0)
    80001a6a:	03453823          	sd	s4,48(a0)
    80001a6e:	03553c23          	sd	s5,56(a0)
    80001a72:	05653023          	sd	s6,64(a0)
    80001a76:	05753423          	sd	s7,72(a0)
    80001a7a:	05853823          	sd	s8,80(a0)
    80001a7e:	05953c23          	sd	s9,88(a0)
    80001a82:	07a53023          	sd	s10,96(a0)
    80001a86:	07b53423          	sd	s11,104(a0)
    80001a8a:	0005b083          	ld	ra,0(a1)
    80001a8e:	0085b103          	ld	sp,8(a1)
    80001a92:	6980                	ld	s0,16(a1)
    80001a94:	6d84                	ld	s1,24(a1)
    80001a96:	0205b903          	ld	s2,32(a1)
    80001a9a:	0285b983          	ld	s3,40(a1)
    80001a9e:	0305ba03          	ld	s4,48(a1)
    80001aa2:	0385ba83          	ld	s5,56(a1)
    80001aa6:	0405bb03          	ld	s6,64(a1)
    80001aaa:	0485bb83          	ld	s7,72(a1)
    80001aae:	0505bc03          	ld	s8,80(a1)
    80001ab2:	0585bc83          	ld	s9,88(a1)
    80001ab6:	0605bd03          	ld	s10,96(a1)
    80001aba:	0685bd83          	ld	s11,104(a1)
    80001abe:	8082                	ret

0000000080001ac0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac0:	1141                	addi	sp,sp,-16
    80001ac2:	e406                	sd	ra,8(sp)
    80001ac4:	e022                	sd	s0,0(sp)
    80001ac6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ac8:	00006597          	auipc	a1,0x6
    80001acc:	7a858593          	addi	a1,a1,1960 # 80008270 <states.0+0x30>
    80001ad0:	0000e517          	auipc	a0,0xe
    80001ad4:	9b050513          	addi	a0,a0,-1616 # 8000f480 <tickslock>
    80001ad8:	00004097          	auipc	ra,0x4
    80001adc:	66c080e7          	jalr	1644(ra) # 80006144 <initlock>
}
    80001ae0:	60a2                	ld	ra,8(sp)
    80001ae2:	6402                	ld	s0,0(sp)
    80001ae4:	0141                	addi	sp,sp,16
    80001ae6:	8082                	ret

0000000080001ae8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ae8:	1141                	addi	sp,sp,-16
    80001aea:	e422                	sd	s0,8(sp)
    80001aec:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aee:	00003797          	auipc	a5,0x3
    80001af2:	5a278793          	addi	a5,a5,1442 # 80005090 <kernelvec>
    80001af6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afa:	6422                	ld	s0,8(sp)
    80001afc:	0141                	addi	sp,sp,16
    80001afe:	8082                	ret

0000000080001b00 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b00:	1141                	addi	sp,sp,-16
    80001b02:	e406                	sd	ra,8(sp)
    80001b04:	e022                	sd	s0,0(sp)
    80001b06:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b08:	fffff097          	auipc	ra,0xfffff
    80001b0c:	33a080e7          	jalr	826(ra) # 80000e42 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b1a:	00005617          	auipc	a2,0x5
    80001b1e:	4e660613          	addi	a2,a2,1254 # 80007000 <_trampoline>
    80001b22:	00005697          	auipc	a3,0x5
    80001b26:	4de68693          	addi	a3,a3,1246 # 80007000 <_trampoline>
    80001b2a:	8e91                	sub	a3,a3,a2
    80001b2c:	040007b7          	lui	a5,0x4000
    80001b30:	17fd                	addi	a5,a5,-1
    80001b32:	07b2                	slli	a5,a5,0xc
    80001b34:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b36:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b3c:	180026f3          	csrr	a3,satp
    80001b40:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b42:	6d38                	ld	a4,88(a0)
    80001b44:	6134                	ld	a3,64(a0)
    80001b46:	6585                	lui	a1,0x1
    80001b48:	96ae                	add	a3,a3,a1
    80001b4a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b4c:	6d38                	ld	a4,88(a0)
    80001b4e:	00000697          	auipc	a3,0x0
    80001b52:	13868693          	addi	a3,a3,312 # 80001c86 <usertrap>
    80001b56:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b58:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5a:	8692                	mv	a3,tp
    80001b5c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b62:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b66:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b6e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b70:	6f18                	ld	a4,24(a4)
    80001b72:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b76:	692c                	ld	a1,80(a0)
    80001b78:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b7a:	00005717          	auipc	a4,0x5
    80001b7e:	51670713          	addi	a4,a4,1302 # 80007090 <userret>
    80001b82:	8f11                	sub	a4,a4,a2
    80001b84:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b86:	577d                	li	a4,-1
    80001b88:	177e                	slli	a4,a4,0x3f
    80001b8a:	8dd9                	or	a1,a1,a4
    80001b8c:	02000537          	lui	a0,0x2000
    80001b90:	157d                	addi	a0,a0,-1
    80001b92:	0536                	slli	a0,a0,0xd
    80001b94:	9782                	jalr	a5
}
    80001b96:	60a2                	ld	ra,8(sp)
    80001b98:	6402                	ld	s0,0(sp)
    80001b9a:	0141                	addi	sp,sp,16
    80001b9c:	8082                	ret

0000000080001b9e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba8:	0000e497          	auipc	s1,0xe
    80001bac:	8d848493          	addi	s1,s1,-1832 # 8000f480 <tickslock>
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	622080e7          	jalr	1570(ra) # 800061d4 <acquire>
  ticks++;
    80001bba:	00007517          	auipc	a0,0x7
    80001bbe:	45e50513          	addi	a0,a0,1118 # 80009018 <ticks>
    80001bc2:	411c                	lw	a5,0(a0)
    80001bc4:	2785                	addiw	a5,a5,1
    80001bc6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	b1c080e7          	jalr	-1252(ra) # 800016e4 <wakeup>
  release(&tickslock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	00004097          	auipc	ra,0x4
    80001bd6:	6b6080e7          	jalr	1718(ra) # 80006288 <release>
}
    80001bda:	60e2                	ld	ra,24(sp)
    80001bdc:	6442                	ld	s0,16(sp)
    80001bde:	64a2                	ld	s1,8(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret

0000000080001be4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be4:	1101                	addi	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bee:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf2:	00074d63          	bltz	a4,80001c0c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf6:	57fd                	li	a5,-1
    80001bf8:	17fe                	slli	a5,a5,0x3f
    80001bfa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfe:	06f70363          	beq	a4,a5,80001c64 <devintr+0x80>
  }
}
    80001c02:	60e2                	ld	ra,24(sp)
    80001c04:	6442                	ld	s0,16(sp)
    80001c06:	64a2                	ld	s1,8(sp)
    80001c08:	6105                	addi	sp,sp,32
    80001c0a:	8082                	ret
     (scause & 0xff) == 9){
    80001c0c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c10:	46a5                	li	a3,9
    80001c12:	fed792e3          	bne	a5,a3,80001bf6 <devintr+0x12>
    int irq = plic_claim();
    80001c16:	00003097          	auipc	ra,0x3
    80001c1a:	582080e7          	jalr	1410(ra) # 80005198 <plic_claim>
    80001c1e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c20:	47a9                	li	a5,10
    80001c22:	02f50763          	beq	a0,a5,80001c50 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c26:	4785                	li	a5,1
    80001c28:	02f50963          	beq	a0,a5,80001c5a <devintr+0x76>
    return 1;
    80001c2c:	4505                	li	a0,1
    } else if(irq){
    80001c2e:	d8f1                	beqz	s1,80001c02 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c30:	85a6                	mv	a1,s1
    80001c32:	00006517          	auipc	a0,0x6
    80001c36:	64650513          	addi	a0,a0,1606 # 80008278 <states.0+0x38>
    80001c3a:	00004097          	auipc	ra,0x4
    80001c3e:	0da080e7          	jalr	218(ra) # 80005d14 <printf>
      plic_complete(irq);
    80001c42:	8526                	mv	a0,s1
    80001c44:	00003097          	auipc	ra,0x3
    80001c48:	578080e7          	jalr	1400(ra) # 800051bc <plic_complete>
    return 1;
    80001c4c:	4505                	li	a0,1
    80001c4e:	bf55                	j	80001c02 <devintr+0x1e>
      uartintr();
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	4a4080e7          	jalr	1188(ra) # 800060f4 <uartintr>
    80001c58:	b7ed                	j	80001c42 <devintr+0x5e>
      virtio_disk_intr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	9f4080e7          	jalr	-1548(ra) # 8000564e <virtio_disk_intr>
    80001c62:	b7c5                	j	80001c42 <devintr+0x5e>
    if(cpuid() == 0){
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	1b2080e7          	jalr	434(ra) # 80000e16 <cpuid>
    80001c6c:	c901                	beqz	a0,80001c7c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c72:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c74:	14479073          	csrw	sip,a5
    return 2;
    80001c78:	4509                	li	a0,2
    80001c7a:	b761                	j	80001c02 <devintr+0x1e>
      clockintr();
    80001c7c:	00000097          	auipc	ra,0x0
    80001c80:	f22080e7          	jalr	-222(ra) # 80001b9e <clockintr>
    80001c84:	b7ed                	j	80001c6e <devintr+0x8a>

0000000080001c86 <usertrap>:
{
    80001c86:	1101                	addi	sp,sp,-32
    80001c88:	ec06                	sd	ra,24(sp)
    80001c8a:	e822                	sd	s0,16(sp)
    80001c8c:	e426                	sd	s1,8(sp)
    80001c8e:	e04a                	sd	s2,0(sp)
    80001c90:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c92:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c96:	1007f793          	andi	a5,a5,256
    80001c9a:	e3ad                	bnez	a5,80001cfc <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9c:	00003797          	auipc	a5,0x3
    80001ca0:	3f478793          	addi	a5,a5,1012 # 80005090 <kernelvec>
    80001ca4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	19a080e7          	jalr	410(ra) # 80000e42 <myproc>
    80001cb0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb4:	14102773          	csrr	a4,sepc
    80001cb8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cba:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbe:	47a1                	li	a5,8
    80001cc0:	04f71c63          	bne	a4,a5,80001d18 <usertrap+0x92>
    if(p->killed)
    80001cc4:	551c                	lw	a5,40(a0)
    80001cc6:	e3b9                	bnez	a5,80001d0c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cc8:	6cb8                	ld	a4,88(s1)
    80001cca:	6f1c                	ld	a5,24(a4)
    80001ccc:	0791                	addi	a5,a5,4
    80001cce:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cd4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd8:	10079073          	csrw	sstatus,a5
    syscall();
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	330080e7          	jalr	816(ra) # 8000200c <syscall>
  if(p->killed)
    80001ce4:	549c                	lw	a5,40(s1)
    80001ce6:	e7cd                	bnez	a5,80001d90 <usertrap+0x10a>
  usertrapret();
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	e18080e7          	jalr	-488(ra) # 80001b00 <usertrapret>
}
    80001cf0:	60e2                	ld	ra,24(sp)
    80001cf2:	6442                	ld	s0,16(sp)
    80001cf4:	64a2                	ld	s1,8(sp)
    80001cf6:	6902                	ld	s2,0(sp)
    80001cf8:	6105                	addi	sp,sp,32
    80001cfa:	8082                	ret
    panic("usertrap: not from user mode");
    80001cfc:	00006517          	auipc	a0,0x6
    80001d00:	59c50513          	addi	a0,a0,1436 # 80008298 <states.0+0x58>
    80001d04:	00004097          	auipc	ra,0x4
    80001d08:	fbe080e7          	jalr	-66(ra) # 80005cc2 <panic>
      exit(-1);
    80001d0c:	557d                	li	a0,-1
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	aa6080e7          	jalr	-1370(ra) # 800017b4 <exit>
    80001d16:	bf4d                	j	80001cc8 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	ecc080e7          	jalr	-308(ra) # 80001be4 <devintr>
    80001d20:	892a                	mv	s2,a0
    80001d22:	c501                	beqz	a0,80001d2a <usertrap+0xa4>
  if(p->killed)
    80001d24:	549c                	lw	a5,40(s1)
    80001d26:	c3a1                	beqz	a5,80001d66 <usertrap+0xe0>
    80001d28:	a815                	j	80001d5c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d2a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d2e:	5890                	lw	a2,48(s1)
    80001d30:	00006517          	auipc	a0,0x6
    80001d34:	58850513          	addi	a0,a0,1416 # 800082b8 <states.0+0x78>
    80001d38:	00004097          	auipc	ra,0x4
    80001d3c:	fdc080e7          	jalr	-36(ra) # 80005d14 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d40:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d44:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d48:	00006517          	auipc	a0,0x6
    80001d4c:	5a050513          	addi	a0,a0,1440 # 800082e8 <states.0+0xa8>
    80001d50:	00004097          	auipc	ra,0x4
    80001d54:	fc4080e7          	jalr	-60(ra) # 80005d14 <printf>
    p->killed = 1;
    80001d58:	4785                	li	a5,1
    80001d5a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d5c:	557d                	li	a0,-1
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	a56080e7          	jalr	-1450(ra) # 800017b4 <exit>
  if(which_dev == 2)
    80001d66:	4789                	li	a5,2
    80001d68:	f8f910e3          	bne	s2,a5,80001ce8 <usertrap+0x62>
    if(p->interval>0)
    80001d6c:	1704a783          	lw	a5,368(s1)
    80001d70:	00f05b63          	blez	a5,80001d86 <usertrap+0x100>
      if(p->ticks==p->interval)
    80001d74:	1744a703          	lw	a4,372(s1)
    80001d78:	00f70e63          	beq	a4,a5,80001d94 <usertrap+0x10e>
      p->ticks++;
    80001d7c:	1744a783          	lw	a5,372(s1)
    80001d80:	2785                	addiw	a5,a5,1
    80001d82:	16f4aa23          	sw	a5,372(s1)
    yield();
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	796080e7          	jalr	1942(ra) # 8000151c <yield>
    80001d8e:	bfa9                	j	80001ce8 <usertrap+0x62>
  int which_dev = 0;
    80001d90:	4901                	li	s2,0
    80001d92:	b7e9                	j	80001d5c <usertrap+0xd6>
        *(p->lasttrap) = *(p->trapframe);
    80001d94:	6cb4                	ld	a3,88(s1)
    80001d96:	87b6                	mv	a5,a3
    80001d98:	1784b703          	ld	a4,376(s1)
    80001d9c:	12068693          	addi	a3,a3,288
    80001da0:	0007b803          	ld	a6,0(a5)
    80001da4:	6788                	ld	a0,8(a5)
    80001da6:	6b8c                	ld	a1,16(a5)
    80001da8:	6f90                	ld	a2,24(a5)
    80001daa:	01073023          	sd	a6,0(a4)
    80001dae:	e708                	sd	a0,8(a4)
    80001db0:	eb0c                	sd	a1,16(a4)
    80001db2:	ef10                	sd	a2,24(a4)
    80001db4:	02078793          	addi	a5,a5,32
    80001db8:	02070713          	addi	a4,a4,32
    80001dbc:	fed792e3          	bne	a5,a3,80001da0 <usertrap+0x11a>
        p->trapframe->epc = (uint64)p->handler;
    80001dc0:	6cbc                	ld	a5,88(s1)
    80001dc2:	1684b703          	ld	a4,360(s1)
    80001dc6:	ef98                	sd	a4,24(a5)
    80001dc8:	bf55                	j	80001d7c <usertrap+0xf6>

0000000080001dca <kerneltrap>:
{
    80001dca:	7179                	addi	sp,sp,-48
    80001dcc:	f406                	sd	ra,40(sp)
    80001dce:	f022                	sd	s0,32(sp)
    80001dd0:	ec26                	sd	s1,24(sp)
    80001dd2:	e84a                	sd	s2,16(sp)
    80001dd4:	e44e                	sd	s3,8(sp)
    80001dd6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ddc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001de4:	1004f793          	andi	a5,s1,256
    80001de8:	cb85                	beqz	a5,80001e18 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dee:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df0:	ef85                	bnez	a5,80001e28 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001df2:	00000097          	auipc	ra,0x0
    80001df6:	df2080e7          	jalr	-526(ra) # 80001be4 <devintr>
    80001dfa:	cd1d                	beqz	a0,80001e38 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dfc:	4789                	li	a5,2
    80001dfe:	06f50a63          	beq	a0,a5,80001e72 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e02:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e06:	10049073          	csrw	sstatus,s1
}
    80001e0a:	70a2                	ld	ra,40(sp)
    80001e0c:	7402                	ld	s0,32(sp)
    80001e0e:	64e2                	ld	s1,24(sp)
    80001e10:	6942                	ld	s2,16(sp)
    80001e12:	69a2                	ld	s3,8(sp)
    80001e14:	6145                	addi	sp,sp,48
    80001e16:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e18:	00006517          	auipc	a0,0x6
    80001e1c:	4f050513          	addi	a0,a0,1264 # 80008308 <states.0+0xc8>
    80001e20:	00004097          	auipc	ra,0x4
    80001e24:	ea2080e7          	jalr	-350(ra) # 80005cc2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	50850513          	addi	a0,a0,1288 # 80008330 <states.0+0xf0>
    80001e30:	00004097          	auipc	ra,0x4
    80001e34:	e92080e7          	jalr	-366(ra) # 80005cc2 <panic>
    printf("scause %p\n", scause);
    80001e38:	85ce                	mv	a1,s3
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	51650513          	addi	a0,a0,1302 # 80008350 <states.0+0x110>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	ed2080e7          	jalr	-302(ra) # 80005d14 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e4e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	50e50513          	addi	a0,a0,1294 # 80008360 <states.0+0x120>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	eba080e7          	jalr	-326(ra) # 80005d14 <printf>
    panic("kerneltrap");
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	51650513          	addi	a0,a0,1302 # 80008378 <states.0+0x138>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	e58080e7          	jalr	-424(ra) # 80005cc2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	fd0080e7          	jalr	-48(ra) # 80000e42 <myproc>
    80001e7a:	d541                	beqz	a0,80001e02 <kerneltrap+0x38>
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	fc6080e7          	jalr	-58(ra) # 80000e42 <myproc>
    80001e84:	4d18                	lw	a4,24(a0)
    80001e86:	4791                	li	a5,4
    80001e88:	f6f71de3          	bne	a4,a5,80001e02 <kerneltrap+0x38>
    yield();
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	690080e7          	jalr	1680(ra) # 8000151c <yield>
    80001e94:	b7bd                	j	80001e02 <kerneltrap+0x38>

0000000080001e96 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e96:	1101                	addi	sp,sp,-32
    80001e98:	ec06                	sd	ra,24(sp)
    80001e9a:	e822                	sd	s0,16(sp)
    80001e9c:	e426                	sd	s1,8(sp)
    80001e9e:	1000                	addi	s0,sp,32
    80001ea0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	fa0080e7          	jalr	-96(ra) # 80000e42 <myproc>
  switch (n) {
    80001eaa:	4795                	li	a5,5
    80001eac:	0497e163          	bltu	a5,s1,80001eee <argraw+0x58>
    80001eb0:	048a                	slli	s1,s1,0x2
    80001eb2:	00006717          	auipc	a4,0x6
    80001eb6:	4fe70713          	addi	a4,a4,1278 # 800083b0 <states.0+0x170>
    80001eba:	94ba                	add	s1,s1,a4
    80001ebc:	409c                	lw	a5,0(s1)
    80001ebe:	97ba                	add	a5,a5,a4
    80001ec0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ec2:	6d3c                	ld	a5,88(a0)
    80001ec4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ec6:	60e2                	ld	ra,24(sp)
    80001ec8:	6442                	ld	s0,16(sp)
    80001eca:	64a2                	ld	s1,8(sp)
    80001ecc:	6105                	addi	sp,sp,32
    80001ece:	8082                	ret
    return p->trapframe->a1;
    80001ed0:	6d3c                	ld	a5,88(a0)
    80001ed2:	7fa8                	ld	a0,120(a5)
    80001ed4:	bfcd                	j	80001ec6 <argraw+0x30>
    return p->trapframe->a2;
    80001ed6:	6d3c                	ld	a5,88(a0)
    80001ed8:	63c8                	ld	a0,128(a5)
    80001eda:	b7f5                	j	80001ec6 <argraw+0x30>
    return p->trapframe->a3;
    80001edc:	6d3c                	ld	a5,88(a0)
    80001ede:	67c8                	ld	a0,136(a5)
    80001ee0:	b7dd                	j	80001ec6 <argraw+0x30>
    return p->trapframe->a4;
    80001ee2:	6d3c                	ld	a5,88(a0)
    80001ee4:	6bc8                	ld	a0,144(a5)
    80001ee6:	b7c5                	j	80001ec6 <argraw+0x30>
    return p->trapframe->a5;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	6fc8                	ld	a0,152(a5)
    80001eec:	bfe9                	j	80001ec6 <argraw+0x30>
  panic("argraw");
    80001eee:	00006517          	auipc	a0,0x6
    80001ef2:	49a50513          	addi	a0,a0,1178 # 80008388 <states.0+0x148>
    80001ef6:	00004097          	auipc	ra,0x4
    80001efa:	dcc080e7          	jalr	-564(ra) # 80005cc2 <panic>

0000000080001efe <fetchaddr>:
{
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	e04a                	sd	s2,0(sp)
    80001f08:	1000                	addi	s0,sp,32
    80001f0a:	84aa                	mv	s1,a0
    80001f0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	f34080e7          	jalr	-204(ra) # 80000e42 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f16:	653c                	ld	a5,72(a0)
    80001f18:	02f4f863          	bgeu	s1,a5,80001f48 <fetchaddr+0x4a>
    80001f1c:	00848713          	addi	a4,s1,8
    80001f20:	02e7e663          	bltu	a5,a4,80001f4c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f24:	46a1                	li	a3,8
    80001f26:	8626                	mv	a2,s1
    80001f28:	85ca                	mv	a1,s2
    80001f2a:	6928                	ld	a0,80(a0)
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	c62080e7          	jalr	-926(ra) # 80000b8e <copyin>
    80001f34:	00a03533          	snez	a0,a0
    80001f38:	40a00533          	neg	a0,a0
}
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6902                	ld	s2,0(sp)
    80001f44:	6105                	addi	sp,sp,32
    80001f46:	8082                	ret
    return -1;
    80001f48:	557d                	li	a0,-1
    80001f4a:	bfcd                	j	80001f3c <fetchaddr+0x3e>
    80001f4c:	557d                	li	a0,-1
    80001f4e:	b7fd                	j	80001f3c <fetchaddr+0x3e>

0000000080001f50 <fetchstr>:
{
    80001f50:	7179                	addi	sp,sp,-48
    80001f52:	f406                	sd	ra,40(sp)
    80001f54:	f022                	sd	s0,32(sp)
    80001f56:	ec26                	sd	s1,24(sp)
    80001f58:	e84a                	sd	s2,16(sp)
    80001f5a:	e44e                	sd	s3,8(sp)
    80001f5c:	1800                	addi	s0,sp,48
    80001f5e:	892a                	mv	s2,a0
    80001f60:	84ae                	mv	s1,a1
    80001f62:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	ede080e7          	jalr	-290(ra) # 80000e42 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f6c:	86ce                	mv	a3,s3
    80001f6e:	864a                	mv	a2,s2
    80001f70:	85a6                	mv	a1,s1
    80001f72:	6928                	ld	a0,80(a0)
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	ca8080e7          	jalr	-856(ra) # 80000c1c <copyinstr>
  if(err < 0)
    80001f7c:	00054763          	bltz	a0,80001f8a <fetchstr+0x3a>
  return strlen(buf);
    80001f80:	8526                	mv	a0,s1
    80001f82:	ffffe097          	auipc	ra,0xffffe
    80001f86:	372080e7          	jalr	882(ra) # 800002f4 <strlen>
}
    80001f8a:	70a2                	ld	ra,40(sp)
    80001f8c:	7402                	ld	s0,32(sp)
    80001f8e:	64e2                	ld	s1,24(sp)
    80001f90:	6942                	ld	s2,16(sp)
    80001f92:	69a2                	ld	s3,8(sp)
    80001f94:	6145                	addi	sp,sp,48
    80001f96:	8082                	ret

0000000080001f98 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	1000                	addi	s0,sp,32
    80001fa2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa4:	00000097          	auipc	ra,0x0
    80001fa8:	ef2080e7          	jalr	-270(ra) # 80001e96 <argraw>
    80001fac:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fae:	4501                	li	a0,0
    80001fb0:	60e2                	ld	ra,24(sp)
    80001fb2:	6442                	ld	s0,16(sp)
    80001fb4:	64a2                	ld	s1,8(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret

0000000080001fba <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fba:	1101                	addi	sp,sp,-32
    80001fbc:	ec06                	sd	ra,24(sp)
    80001fbe:	e822                	sd	s0,16(sp)
    80001fc0:	e426                	sd	s1,8(sp)
    80001fc2:	1000                	addi	s0,sp,32
    80001fc4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	ed0080e7          	jalr	-304(ra) # 80001e96 <argraw>
    80001fce:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fd0:	4501                	li	a0,0
    80001fd2:	60e2                	ld	ra,24(sp)
    80001fd4:	6442                	ld	s0,16(sp)
    80001fd6:	64a2                	ld	s1,8(sp)
    80001fd8:	6105                	addi	sp,sp,32
    80001fda:	8082                	ret

0000000080001fdc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fdc:	1101                	addi	sp,sp,-32
    80001fde:	ec06                	sd	ra,24(sp)
    80001fe0:	e822                	sd	s0,16(sp)
    80001fe2:	e426                	sd	s1,8(sp)
    80001fe4:	e04a                	sd	s2,0(sp)
    80001fe6:	1000                	addi	s0,sp,32
    80001fe8:	84ae                	mv	s1,a1
    80001fea:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	eaa080e7          	jalr	-342(ra) # 80001e96 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ff4:	864a                	mv	a2,s2
    80001ff6:	85a6                	mv	a1,s1
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	f58080e7          	jalr	-168(ra) # 80001f50 <fetchstr>
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6902                	ld	s2,0(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <syscall>:
[SYS_sigreturn] sys_sigreturn
};

void
syscall(void)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	e04a                	sd	s2,0(sp)
    80002016:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	e2a080e7          	jalr	-470(ra) # 80000e42 <myproc>
    80002020:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002022:	05853903          	ld	s2,88(a0)
    80002026:	0a893783          	ld	a5,168(s2)
    8000202a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000202e:	37fd                	addiw	a5,a5,-1
    80002030:	4759                	li	a4,22
    80002032:	00f76f63          	bltu	a4,a5,80002050 <syscall+0x44>
    80002036:	00369713          	slli	a4,a3,0x3
    8000203a:	00006797          	auipc	a5,0x6
    8000203e:	38e78793          	addi	a5,a5,910 # 800083c8 <syscalls>
    80002042:	97ba                	add	a5,a5,a4
    80002044:	639c                	ld	a5,0(a5)
    80002046:	c789                	beqz	a5,80002050 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002048:	9782                	jalr	a5
    8000204a:	06a93823          	sd	a0,112(s2)
    8000204e:	a839                	j	8000206c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002050:	15848613          	addi	a2,s1,344
    80002054:	588c                	lw	a1,48(s1)
    80002056:	00006517          	auipc	a0,0x6
    8000205a:	33a50513          	addi	a0,a0,826 # 80008390 <states.0+0x150>
    8000205e:	00004097          	auipc	ra,0x4
    80002062:	cb6080e7          	jalr	-842(ra) # 80005d14 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002066:	6cbc                	ld	a5,88(s1)
    80002068:	577d                	li	a4,-1
    8000206a:	fbb8                	sd	a4,112(a5)
  }
}
    8000206c:	60e2                	ld	ra,24(sp)
    8000206e:	6442                	ld	s0,16(sp)
    80002070:	64a2                	ld	s1,8(sp)
    80002072:	6902                	ld	s2,0(sp)
    80002074:	6105                	addi	sp,sp,32
    80002076:	8082                	ret

0000000080002078 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002080:	fec40593          	addi	a1,s0,-20
    80002084:	4501                	li	a0,0
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	f12080e7          	jalr	-238(ra) # 80001f98 <argint>
    return -1;
    8000208e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002090:	00054963          	bltz	a0,800020a2 <sys_exit+0x2a>
  exit(n);
    80002094:	fec42503          	lw	a0,-20(s0)
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	71c080e7          	jalr	1820(ra) # 800017b4 <exit>
  return 0;  // not reached
    800020a0:	4781                	li	a5,0
}
    800020a2:	853e                	mv	a0,a5
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <sys_getpid>:

uint64
sys_getpid(void)
{
    800020ac:	1141                	addi	sp,sp,-16
    800020ae:	e406                	sd	ra,8(sp)
    800020b0:	e022                	sd	s0,0(sp)
    800020b2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	d8e080e7          	jalr	-626(ra) # 80000e42 <myproc>
}
    800020bc:	5908                	lw	a0,48(a0)
    800020be:	60a2                	ld	ra,8(sp)
    800020c0:	6402                	ld	s0,0(sp)
    800020c2:	0141                	addi	sp,sp,16
    800020c4:	8082                	ret

00000000800020c6 <sys_fork>:

uint64
sys_fork(void)
{
    800020c6:	1141                	addi	sp,sp,-16
    800020c8:	e406                	sd	ra,8(sp)
    800020ca:	e022                	sd	s0,0(sp)
    800020cc:	0800                	addi	s0,sp,16
  return fork();
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	198080e7          	jalr	408(ra) # 80001266 <fork>
}
    800020d6:	60a2                	ld	ra,8(sp)
    800020d8:	6402                	ld	s0,0(sp)
    800020da:	0141                	addi	sp,sp,16
    800020dc:	8082                	ret

00000000800020de <sys_wait>:

uint64
sys_wait(void)
{
    800020de:	1101                	addi	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020e6:	fe840593          	addi	a1,s0,-24
    800020ea:	4501                	li	a0,0
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	ece080e7          	jalr	-306(ra) # 80001fba <argaddr>
    800020f4:	87aa                	mv	a5,a0
    return -1;
    800020f6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020f8:	0007c863          	bltz	a5,80002108 <sys_wait+0x2a>
  return wait(p);
    800020fc:	fe843503          	ld	a0,-24(s0)
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	4bc080e7          	jalr	1212(ra) # 800015bc <wait>
}
    80002108:	60e2                	ld	ra,24(sp)
    8000210a:	6442                	ld	s0,16(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002110:	7179                	addi	sp,sp,-48
    80002112:	f406                	sd	ra,40(sp)
    80002114:	f022                	sd	s0,32(sp)
    80002116:	ec26                	sd	s1,24(sp)
    80002118:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000211a:	fdc40593          	addi	a1,s0,-36
    8000211e:	4501                	li	a0,0
    80002120:	00000097          	auipc	ra,0x0
    80002124:	e78080e7          	jalr	-392(ra) # 80001f98 <argint>
    return -1;
    80002128:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000212a:	00054f63          	bltz	a0,80002148 <sys_sbrk+0x38>
  addr = myproc()->sz;
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	d14080e7          	jalr	-748(ra) # 80000e42 <myproc>
    80002136:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002138:	fdc42503          	lw	a0,-36(s0)
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	0b6080e7          	jalr	182(ra) # 800011f2 <growproc>
    80002144:	00054863          	bltz	a0,80002154 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002148:	8526                	mv	a0,s1
    8000214a:	70a2                	ld	ra,40(sp)
    8000214c:	7402                	ld	s0,32(sp)
    8000214e:	64e2                	ld	s1,24(sp)
    80002150:	6145                	addi	sp,sp,48
    80002152:	8082                	ret
    return -1;
    80002154:	54fd                	li	s1,-1
    80002156:	bfcd                	j	80002148 <sys_sbrk+0x38>

0000000080002158 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002158:	7139                	addi	sp,sp,-64
    8000215a:	fc06                	sd	ra,56(sp)
    8000215c:	f822                	sd	s0,48(sp)
    8000215e:	f426                	sd	s1,40(sp)
    80002160:	f04a                	sd	s2,32(sp)
    80002162:	ec4e                	sd	s3,24(sp)
    80002164:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002166:	fcc40593          	addi	a1,s0,-52
    8000216a:	4501                	li	a0,0
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	e2c080e7          	jalr	-468(ra) # 80001f98 <argint>
    return -1;
    80002174:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002176:	06054963          	bltz	a0,800021e8 <sys_sleep+0x90>
  acquire(&tickslock);
    8000217a:	0000d517          	auipc	a0,0xd
    8000217e:	30650513          	addi	a0,a0,774 # 8000f480 <tickslock>
    80002182:	00004097          	auipc	ra,0x4
    80002186:	052080e7          	jalr	82(ra) # 800061d4 <acquire>
  ticks0 = ticks;
    8000218a:	00007917          	auipc	s2,0x7
    8000218e:	e8e92903          	lw	s2,-370(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002192:	fcc42783          	lw	a5,-52(s0)
    80002196:	c3a1                	beqz	a5,800021d6 <sys_sleep+0x7e>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    backtrace();
    sleep(&ticks, &tickslock);
    80002198:	0000d997          	auipc	s3,0xd
    8000219c:	2e898993          	addi	s3,s3,744 # 8000f480 <tickslock>
    800021a0:	00007497          	auipc	s1,0x7
    800021a4:	e7848493          	addi	s1,s1,-392 # 80009018 <ticks>
    if(myproc()->killed){
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	c9a080e7          	jalr	-870(ra) # 80000e42 <myproc>
    800021b0:	551c                	lw	a5,40(a0)
    800021b2:	e3b9                	bnez	a5,800021f8 <sys_sleep+0xa0>
    backtrace();
    800021b4:	00004097          	auipc	ra,0x4
    800021b8:	ab2080e7          	jalr	-1358(ra) # 80005c66 <backtrace>
    sleep(&ticks, &tickslock);
    800021bc:	85ce                	mv	a1,s3
    800021be:	8526                	mv	a0,s1
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	398080e7          	jalr	920(ra) # 80001558 <sleep>
  while(ticks - ticks0 < n){
    800021c8:	409c                	lw	a5,0(s1)
    800021ca:	412787bb          	subw	a5,a5,s2
    800021ce:	fcc42703          	lw	a4,-52(s0)
    800021d2:	fce7ebe3          	bltu	a5,a4,800021a8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021d6:	0000d517          	auipc	a0,0xd
    800021da:	2aa50513          	addi	a0,a0,682 # 8000f480 <tickslock>
    800021de:	00004097          	auipc	ra,0x4
    800021e2:	0aa080e7          	jalr	170(ra) # 80006288 <release>
  return 0;
    800021e6:	4781                	li	a5,0
}
    800021e8:	853e                	mv	a0,a5
    800021ea:	70e2                	ld	ra,56(sp)
    800021ec:	7442                	ld	s0,48(sp)
    800021ee:	74a2                	ld	s1,40(sp)
    800021f0:	7902                	ld	s2,32(sp)
    800021f2:	69e2                	ld	s3,24(sp)
    800021f4:	6121                	addi	sp,sp,64
    800021f6:	8082                	ret
      release(&tickslock);
    800021f8:	0000d517          	auipc	a0,0xd
    800021fc:	28850513          	addi	a0,a0,648 # 8000f480 <tickslock>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	088080e7          	jalr	136(ra) # 80006288 <release>
      return -1;
    80002208:	57fd                	li	a5,-1
    8000220a:	bff9                	j	800021e8 <sys_sleep+0x90>

000000008000220c <sys_kill>:

uint64
sys_kill(void)
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002214:	fec40593          	addi	a1,s0,-20
    80002218:	4501                	li	a0,0
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	d7e080e7          	jalr	-642(ra) # 80001f98 <argint>
    80002222:	87aa                	mv	a5,a0
    return -1;
    80002224:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002226:	0007c863          	bltz	a5,80002236 <sys_kill+0x2a>
  return kill(pid);
    8000222a:	fec42503          	lw	a0,-20(s0)
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	65c080e7          	jalr	1628(ra) # 8000188a <kill>
}
    80002236:	60e2                	ld	ra,24(sp)
    80002238:	6442                	ld	s0,16(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000223e:	1101                	addi	sp,sp,-32
    80002240:	ec06                	sd	ra,24(sp)
    80002242:	e822                	sd	s0,16(sp)
    80002244:	e426                	sd	s1,8(sp)
    80002246:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002248:	0000d517          	auipc	a0,0xd
    8000224c:	23850513          	addi	a0,a0,568 # 8000f480 <tickslock>
    80002250:	00004097          	auipc	ra,0x4
    80002254:	f84080e7          	jalr	-124(ra) # 800061d4 <acquire>
  xticks = ticks;
    80002258:	00007497          	auipc	s1,0x7
    8000225c:	dc04a483          	lw	s1,-576(s1) # 80009018 <ticks>
  release(&tickslock);
    80002260:	0000d517          	auipc	a0,0xd
    80002264:	22050513          	addi	a0,a0,544 # 8000f480 <tickslock>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	020080e7          	jalr	32(ra) # 80006288 <release>
  return xticks;
}
    80002270:	02049513          	slli	a0,s1,0x20
    80002274:	9101                	srli	a0,a0,0x20
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	64a2                	ld	s1,8(sp)
    8000227c:	6105                	addi	sp,sp,32
    8000227e:	8082                	ret

0000000080002280 <sys_sigreturn>:

uint64 
sys_sigreturn(void)
{
    80002280:	1141                	addi	sp,sp,-16
    80002282:	e406                	sd	ra,8(sp)
    80002284:	e022                	sd	s0,0(sp)
    80002286:	0800                	addi	s0,sp,16
  struct proc* p = myproc();
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	bba080e7          	jalr	-1094(ra) # 80000e42 <myproc>
	*(p->trapframe) = *(p->lasttrap);
    80002290:	17853683          	ld	a3,376(a0)
    80002294:	87b6                	mv	a5,a3
    80002296:	6d38                	ld	a4,88(a0)
    80002298:	12068693          	addi	a3,a3,288
    8000229c:	0007b883          	ld	a7,0(a5)
    800022a0:	0087b803          	ld	a6,8(a5)
    800022a4:	6b8c                	ld	a1,16(a5)
    800022a6:	6f90                	ld	a2,24(a5)
    800022a8:	01173023          	sd	a7,0(a4)
    800022ac:	01073423          	sd	a6,8(a4)
    800022b0:	eb0c                	sd	a1,16(a4)
    800022b2:	ef10                	sd	a2,24(a4)
    800022b4:	02078793          	addi	a5,a5,32
    800022b8:	02070713          	addi	a4,a4,32
    800022bc:	fed790e3          	bne	a5,a3,8000229c <sys_sigreturn+0x1c>
	//p->mutex = 1;
  p->ticks = 0;
    800022c0:	16052a23          	sw	zero,372(a0)
  return 0;
}
    800022c4:	4501                	li	a0,0
    800022c6:	60a2                	ld	ra,8(sp)
    800022c8:	6402                	ld	s0,0(sp)
    800022ca:	0141                	addi	sp,sp,16
    800022cc:	8082                	ret

00000000800022ce <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    800022ce:	1101                	addi	sp,sp,-32
    800022d0:	ec06                	sd	ra,24(sp)
    800022d2:	e822                	sd	s0,16(sp)
    800022d4:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;
  if(argint(0,&interval)<0||argaddr(1,&handler)<0)
    800022d6:	fec40593          	addi	a1,s0,-20
    800022da:	4501                	li	a0,0
    800022dc:	00000097          	auipc	ra,0x0
    800022e0:	cbc080e7          	jalr	-836(ra) # 80001f98 <argint>
    return -1;
    800022e4:	57fd                	li	a5,-1
  if(argint(0,&interval)<0||argaddr(1,&handler)<0)
    800022e6:	02054f63          	bltz	a0,80002324 <sys_sigalarm+0x56>
    800022ea:	fe040593          	addi	a1,s0,-32
    800022ee:	4505                	li	a0,1
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	cca080e7          	jalr	-822(ra) # 80001fba <argaddr>
    800022f8:	02054b63          	bltz	a0,8000232e <sys_sigalarm+0x60>
  if(interval<=0)
    800022fc:	fec42703          	lw	a4,-20(s0)
    return -1;
    80002300:	57fd                	li	a5,-1
  if(interval<=0)
    80002302:	02e05163          	blez	a4,80002324 <sys_sigalarm+0x56>
  struct proc *p = myproc();
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	b3c080e7          	jalr	-1220(ra) # 80000e42 <myproc>
  p->handler = handler;
    8000230e:	fe043783          	ld	a5,-32(s0)
    80002312:	16f53423          	sd	a5,360(a0)
  p->interval = interval;
    80002316:	fec42783          	lw	a5,-20(s0)
    8000231a:	16f52823          	sw	a5,368(a0)
  p->ticks = 0;
    8000231e:	16052a23          	sw	zero,372(a0)
  return 0;
    80002322:	4781                	li	a5,0
    80002324:	853e                	mv	a0,a5
    80002326:	60e2                	ld	ra,24(sp)
    80002328:	6442                	ld	s0,16(sp)
    8000232a:	6105                	addi	sp,sp,32
    8000232c:	8082                	ret
    return -1;
    8000232e:	57fd                	li	a5,-1
    80002330:	bfd5                	j	80002324 <sys_sigalarm+0x56>

0000000080002332 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002332:	7179                	addi	sp,sp,-48
    80002334:	f406                	sd	ra,40(sp)
    80002336:	f022                	sd	s0,32(sp)
    80002338:	ec26                	sd	s1,24(sp)
    8000233a:	e84a                	sd	s2,16(sp)
    8000233c:	e44e                	sd	s3,8(sp)
    8000233e:	e052                	sd	s4,0(sp)
    80002340:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002342:	00006597          	auipc	a1,0x6
    80002346:	14658593          	addi	a1,a1,326 # 80008488 <syscalls+0xc0>
    8000234a:	0000d517          	auipc	a0,0xd
    8000234e:	14e50513          	addi	a0,a0,334 # 8000f498 <bcache>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	df2080e7          	jalr	-526(ra) # 80006144 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000235a:	00015797          	auipc	a5,0x15
    8000235e:	13e78793          	addi	a5,a5,318 # 80017498 <bcache+0x8000>
    80002362:	00015717          	auipc	a4,0x15
    80002366:	39e70713          	addi	a4,a4,926 # 80017700 <bcache+0x8268>
    8000236a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000236e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002372:	0000d497          	auipc	s1,0xd
    80002376:	13e48493          	addi	s1,s1,318 # 8000f4b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000237a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000237c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000237e:	00006a17          	auipc	s4,0x6
    80002382:	112a0a13          	addi	s4,s4,274 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002386:	2b893783          	ld	a5,696(s2)
    8000238a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000238c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002390:	85d2                	mv	a1,s4
    80002392:	01048513          	addi	a0,s1,16
    80002396:	00001097          	auipc	ra,0x1
    8000239a:	4bc080e7          	jalr	1212(ra) # 80003852 <initsleeplock>
    bcache.head.next->prev = b;
    8000239e:	2b893783          	ld	a5,696(s2)
    800023a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a8:	45848493          	addi	s1,s1,1112
    800023ac:	fd349de3          	bne	s1,s3,80002386 <binit+0x54>
  }
}
    800023b0:	70a2                	ld	ra,40(sp)
    800023b2:	7402                	ld	s0,32(sp)
    800023b4:	64e2                	ld	s1,24(sp)
    800023b6:	6942                	ld	s2,16(sp)
    800023b8:	69a2                	ld	s3,8(sp)
    800023ba:	6a02                	ld	s4,0(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret

00000000800023c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	1800                	addi	s0,sp,48
    800023ce:	892a                	mv	s2,a0
    800023d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023d2:	0000d517          	auipc	a0,0xd
    800023d6:	0c650513          	addi	a0,a0,198 # 8000f498 <bcache>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	dfa080e7          	jalr	-518(ra) # 800061d4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023e2:	00015497          	auipc	s1,0x15
    800023e6:	36e4b483          	ld	s1,878(s1) # 80017750 <bcache+0x82b8>
    800023ea:	00015797          	auipc	a5,0x15
    800023ee:	31678793          	addi	a5,a5,790 # 80017700 <bcache+0x8268>
    800023f2:	02f48f63          	beq	s1,a5,80002430 <bread+0x70>
    800023f6:	873e                	mv	a4,a5
    800023f8:	a021                	j	80002400 <bread+0x40>
    800023fa:	68a4                	ld	s1,80(s1)
    800023fc:	02e48a63          	beq	s1,a4,80002430 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002400:	449c                	lw	a5,8(s1)
    80002402:	ff279ce3          	bne	a5,s2,800023fa <bread+0x3a>
    80002406:	44dc                	lw	a5,12(s1)
    80002408:	ff3799e3          	bne	a5,s3,800023fa <bread+0x3a>
      b->refcnt++;
    8000240c:	40bc                	lw	a5,64(s1)
    8000240e:	2785                	addiw	a5,a5,1
    80002410:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002412:	0000d517          	auipc	a0,0xd
    80002416:	08650513          	addi	a0,a0,134 # 8000f498 <bcache>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	e6e080e7          	jalr	-402(ra) # 80006288 <release>
      acquiresleep(&b->lock);
    80002422:	01048513          	addi	a0,s1,16
    80002426:	00001097          	auipc	ra,0x1
    8000242a:	466080e7          	jalr	1126(ra) # 8000388c <acquiresleep>
      return b;
    8000242e:	a8b9                	j	8000248c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002430:	00015497          	auipc	s1,0x15
    80002434:	3184b483          	ld	s1,792(s1) # 80017748 <bcache+0x82b0>
    80002438:	00015797          	auipc	a5,0x15
    8000243c:	2c878793          	addi	a5,a5,712 # 80017700 <bcache+0x8268>
    80002440:	00f48863          	beq	s1,a5,80002450 <bread+0x90>
    80002444:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	cf81                	beqz	a5,80002460 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244a:	64a4                	ld	s1,72(s1)
    8000244c:	fee49de3          	bne	s1,a4,80002446 <bread+0x86>
  panic("bget: no buffers");
    80002450:	00006517          	auipc	a0,0x6
    80002454:	04850513          	addi	a0,a0,72 # 80008498 <syscalls+0xd0>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	86a080e7          	jalr	-1942(ra) # 80005cc2 <panic>
      b->dev = dev;
    80002460:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002464:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002468:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000246c:	4785                	li	a5,1
    8000246e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002470:	0000d517          	auipc	a0,0xd
    80002474:	02850513          	addi	a0,a0,40 # 8000f498 <bcache>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	e10080e7          	jalr	-496(ra) # 80006288 <release>
      acquiresleep(&b->lock);
    80002480:	01048513          	addi	a0,s1,16
    80002484:	00001097          	auipc	ra,0x1
    80002488:	408080e7          	jalr	1032(ra) # 8000388c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000248c:	409c                	lw	a5,0(s1)
    8000248e:	cb89                	beqz	a5,800024a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002490:	8526                	mv	a0,s1
    80002492:	70a2                	ld	ra,40(sp)
    80002494:	7402                	ld	s0,32(sp)
    80002496:	64e2                	ld	s1,24(sp)
    80002498:	6942                	ld	s2,16(sp)
    8000249a:	69a2                	ld	s3,8(sp)
    8000249c:	6145                	addi	sp,sp,48
    8000249e:	8082                	ret
    virtio_disk_rw(b, 0);
    800024a0:	4581                	li	a1,0
    800024a2:	8526                	mv	a0,s1
    800024a4:	00003097          	auipc	ra,0x3
    800024a8:	f22080e7          	jalr	-222(ra) # 800053c6 <virtio_disk_rw>
    b->valid = 1;
    800024ac:	4785                	li	a5,1
    800024ae:	c09c                	sw	a5,0(s1)
  return b;
    800024b0:	b7c5                	j	80002490 <bread+0xd0>

00000000800024b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	e426                	sd	s1,8(sp)
    800024ba:	1000                	addi	s0,sp,32
    800024bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024be:	0541                	addi	a0,a0,16
    800024c0:	00001097          	auipc	ra,0x1
    800024c4:	466080e7          	jalr	1126(ra) # 80003926 <holdingsleep>
    800024c8:	cd01                	beqz	a0,800024e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ca:	4585                	li	a1,1
    800024cc:	8526                	mv	a0,s1
    800024ce:	00003097          	auipc	ra,0x3
    800024d2:	ef8080e7          	jalr	-264(ra) # 800053c6 <virtio_disk_rw>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret
    panic("bwrite");
    800024e0:	00006517          	auipc	a0,0x6
    800024e4:	fd050513          	addi	a0,a0,-48 # 800084b0 <syscalls+0xe8>
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	7da080e7          	jalr	2010(ra) # 80005cc2 <panic>

00000000800024f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024f0:	1101                	addi	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	e426                	sd	s1,8(sp)
    800024f8:	e04a                	sd	s2,0(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fe:	01050913          	addi	s2,a0,16
    80002502:	854a                	mv	a0,s2
    80002504:	00001097          	auipc	ra,0x1
    80002508:	422080e7          	jalr	1058(ra) # 80003926 <holdingsleep>
    8000250c:	c92d                	beqz	a0,8000257e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000250e:	854a                	mv	a0,s2
    80002510:	00001097          	auipc	ra,0x1
    80002514:	3d2080e7          	jalr	978(ra) # 800038e2 <releasesleep>

  acquire(&bcache.lock);
    80002518:	0000d517          	auipc	a0,0xd
    8000251c:	f8050513          	addi	a0,a0,-128 # 8000f498 <bcache>
    80002520:	00004097          	auipc	ra,0x4
    80002524:	cb4080e7          	jalr	-844(ra) # 800061d4 <acquire>
  b->refcnt--;
    80002528:	40bc                	lw	a5,64(s1)
    8000252a:	37fd                	addiw	a5,a5,-1
    8000252c:	0007871b          	sext.w	a4,a5
    80002530:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002532:	eb05                	bnez	a4,80002562 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002534:	68bc                	ld	a5,80(s1)
    80002536:	64b8                	ld	a4,72(s1)
    80002538:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000253a:	64bc                	ld	a5,72(s1)
    8000253c:	68b8                	ld	a4,80(s1)
    8000253e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002540:	00015797          	auipc	a5,0x15
    80002544:	f5878793          	addi	a5,a5,-168 # 80017498 <bcache+0x8000>
    80002548:	2b87b703          	ld	a4,696(a5)
    8000254c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000254e:	00015717          	auipc	a4,0x15
    80002552:	1b270713          	addi	a4,a4,434 # 80017700 <bcache+0x8268>
    80002556:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002558:	2b87b703          	ld	a4,696(a5)
    8000255c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000255e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002562:	0000d517          	auipc	a0,0xd
    80002566:	f3650513          	addi	a0,a0,-202 # 8000f498 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	d1e080e7          	jalr	-738(ra) # 80006288 <release>
}
    80002572:	60e2                	ld	ra,24(sp)
    80002574:	6442                	ld	s0,16(sp)
    80002576:	64a2                	ld	s1,8(sp)
    80002578:	6902                	ld	s2,0(sp)
    8000257a:	6105                	addi	sp,sp,32
    8000257c:	8082                	ret
    panic("brelse");
    8000257e:	00006517          	auipc	a0,0x6
    80002582:	f3a50513          	addi	a0,a0,-198 # 800084b8 <syscalls+0xf0>
    80002586:	00003097          	auipc	ra,0x3
    8000258a:	73c080e7          	jalr	1852(ra) # 80005cc2 <panic>

000000008000258e <bpin>:

void
bpin(struct buf *b) {
    8000258e:	1101                	addi	sp,sp,-32
    80002590:	ec06                	sd	ra,24(sp)
    80002592:	e822                	sd	s0,16(sp)
    80002594:	e426                	sd	s1,8(sp)
    80002596:	1000                	addi	s0,sp,32
    80002598:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000259a:	0000d517          	auipc	a0,0xd
    8000259e:	efe50513          	addi	a0,a0,-258 # 8000f498 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	c32080e7          	jalr	-974(ra) # 800061d4 <acquire>
  b->refcnt++;
    800025aa:	40bc                	lw	a5,64(s1)
    800025ac:	2785                	addiw	a5,a5,1
    800025ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025b0:	0000d517          	auipc	a0,0xd
    800025b4:	ee850513          	addi	a0,a0,-280 # 8000f498 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	cd0080e7          	jalr	-816(ra) # 80006288 <release>
}
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6105                	addi	sp,sp,32
    800025c8:	8082                	ret

00000000800025ca <bunpin>:

void
bunpin(struct buf *b) {
    800025ca:	1101                	addi	sp,sp,-32
    800025cc:	ec06                	sd	ra,24(sp)
    800025ce:	e822                	sd	s0,16(sp)
    800025d0:	e426                	sd	s1,8(sp)
    800025d2:	1000                	addi	s0,sp,32
    800025d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d6:	0000d517          	auipc	a0,0xd
    800025da:	ec250513          	addi	a0,a0,-318 # 8000f498 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	bf6080e7          	jalr	-1034(ra) # 800061d4 <acquire>
  b->refcnt--;
    800025e6:	40bc                	lw	a5,64(s1)
    800025e8:	37fd                	addiw	a5,a5,-1
    800025ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ec:	0000d517          	auipc	a0,0xd
    800025f0:	eac50513          	addi	a0,a0,-340 # 8000f498 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	c94080e7          	jalr	-876(ra) # 80006288 <release>
}
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6105                	addi	sp,sp,32
    80002604:	8082                	ret

0000000080002606 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	e04a                	sd	s2,0(sp)
    80002610:	1000                	addi	s0,sp,32
    80002612:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002614:	00d5d59b          	srliw	a1,a1,0xd
    80002618:	00015797          	auipc	a5,0x15
    8000261c:	55c7a783          	lw	a5,1372(a5) # 80017b74 <sb+0x1c>
    80002620:	9dbd                	addw	a1,a1,a5
    80002622:	00000097          	auipc	ra,0x0
    80002626:	d9e080e7          	jalr	-610(ra) # 800023c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000262a:	0074f713          	andi	a4,s1,7
    8000262e:	4785                	li	a5,1
    80002630:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002634:	14ce                	slli	s1,s1,0x33
    80002636:	90d9                	srli	s1,s1,0x36
    80002638:	00950733          	add	a4,a0,s1
    8000263c:	05874703          	lbu	a4,88(a4)
    80002640:	00e7f6b3          	and	a3,a5,a4
    80002644:	c69d                	beqz	a3,80002672 <bfree+0x6c>
    80002646:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002648:	94aa                	add	s1,s1,a0
    8000264a:	fff7c793          	not	a5,a5
    8000264e:	8ff9                	and	a5,a5,a4
    80002650:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002654:	00001097          	auipc	ra,0x1
    80002658:	118080e7          	jalr	280(ra) # 8000376c <log_write>
  brelse(bp);
    8000265c:	854a                	mv	a0,s2
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	e92080e7          	jalr	-366(ra) # 800024f0 <brelse>
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	64a2                	ld	s1,8(sp)
    8000266c:	6902                	ld	s2,0(sp)
    8000266e:	6105                	addi	sp,sp,32
    80002670:	8082                	ret
    panic("freeing free block");
    80002672:	00006517          	auipc	a0,0x6
    80002676:	e4e50513          	addi	a0,a0,-434 # 800084c0 <syscalls+0xf8>
    8000267a:	00003097          	auipc	ra,0x3
    8000267e:	648080e7          	jalr	1608(ra) # 80005cc2 <panic>

0000000080002682 <balloc>:
{
    80002682:	711d                	addi	sp,sp,-96
    80002684:	ec86                	sd	ra,88(sp)
    80002686:	e8a2                	sd	s0,80(sp)
    80002688:	e4a6                	sd	s1,72(sp)
    8000268a:	e0ca                	sd	s2,64(sp)
    8000268c:	fc4e                	sd	s3,56(sp)
    8000268e:	f852                	sd	s4,48(sp)
    80002690:	f456                	sd	s5,40(sp)
    80002692:	f05a                	sd	s6,32(sp)
    80002694:	ec5e                	sd	s7,24(sp)
    80002696:	e862                	sd	s8,16(sp)
    80002698:	e466                	sd	s9,8(sp)
    8000269a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000269c:	00015797          	auipc	a5,0x15
    800026a0:	4c07a783          	lw	a5,1216(a5) # 80017b5c <sb+0x4>
    800026a4:	cbd1                	beqz	a5,80002738 <balloc+0xb6>
    800026a6:	8baa                	mv	s7,a0
    800026a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026aa:	00015b17          	auipc	s6,0x15
    800026ae:	4aeb0b13          	addi	s6,s6,1198 # 80017b58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026b4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026b8:	6c89                	lui	s9,0x2
    800026ba:	a831                	j	800026d6 <balloc+0x54>
    brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	e32080e7          	jalr	-462(ra) # 800024f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026c6:	015c87bb          	addw	a5,s9,s5
    800026ca:	00078a9b          	sext.w	s5,a5
    800026ce:	004b2703          	lw	a4,4(s6)
    800026d2:	06eaf363          	bgeu	s5,a4,80002738 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026d6:	41fad79b          	sraiw	a5,s5,0x1f
    800026da:	0137d79b          	srliw	a5,a5,0x13
    800026de:	015787bb          	addw	a5,a5,s5
    800026e2:	40d7d79b          	sraiw	a5,a5,0xd
    800026e6:	01cb2583          	lw	a1,28(s6)
    800026ea:	9dbd                	addw	a1,a1,a5
    800026ec:	855e                	mv	a0,s7
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	cd2080e7          	jalr	-814(ra) # 800023c0 <bread>
    800026f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f8:	004b2503          	lw	a0,4(s6)
    800026fc:	000a849b          	sext.w	s1,s5
    80002700:	8662                	mv	a2,s8
    80002702:	faa4fde3          	bgeu	s1,a0,800026bc <balloc+0x3a>
      m = 1 << (bi % 8);
    80002706:	41f6579b          	sraiw	a5,a2,0x1f
    8000270a:	01d7d69b          	srliw	a3,a5,0x1d
    8000270e:	00c6873b          	addw	a4,a3,a2
    80002712:	00777793          	andi	a5,a4,7
    80002716:	9f95                	subw	a5,a5,a3
    80002718:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000271c:	4037571b          	sraiw	a4,a4,0x3
    80002720:	00e906b3          	add	a3,s2,a4
    80002724:	0586c683          	lbu	a3,88(a3)
    80002728:	00d7f5b3          	and	a1,a5,a3
    8000272c:	cd91                	beqz	a1,80002748 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272e:	2605                	addiw	a2,a2,1
    80002730:	2485                	addiw	s1,s1,1
    80002732:	fd4618e3          	bne	a2,s4,80002702 <balloc+0x80>
    80002736:	b759                	j	800026bc <balloc+0x3a>
  panic("balloc: out of blocks");
    80002738:	00006517          	auipc	a0,0x6
    8000273c:	da050513          	addi	a0,a0,-608 # 800084d8 <syscalls+0x110>
    80002740:	00003097          	auipc	ra,0x3
    80002744:	582080e7          	jalr	1410(ra) # 80005cc2 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002748:	974a                	add	a4,a4,s2
    8000274a:	8fd5                	or	a5,a5,a3
    8000274c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	01a080e7          	jalr	26(ra) # 8000376c <log_write>
        brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	d94080e7          	jalr	-620(ra) # 800024f0 <brelse>
  bp = bread(dev, bno);
    80002764:	85a6                	mv	a1,s1
    80002766:	855e                	mv	a0,s7
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	c58080e7          	jalr	-936(ra) # 800023c0 <bread>
    80002770:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002772:	40000613          	li	a2,1024
    80002776:	4581                	li	a1,0
    80002778:	05850513          	addi	a0,a0,88
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	9fc080e7          	jalr	-1540(ra) # 80000178 <memset>
  log_write(bp);
    80002784:	854a                	mv	a0,s2
    80002786:	00001097          	auipc	ra,0x1
    8000278a:	fe6080e7          	jalr	-26(ra) # 8000376c <log_write>
  brelse(bp);
    8000278e:	854a                	mv	a0,s2
    80002790:	00000097          	auipc	ra,0x0
    80002794:	d60080e7          	jalr	-672(ra) # 800024f0 <brelse>
}
    80002798:	8526                	mv	a0,s1
    8000279a:	60e6                	ld	ra,88(sp)
    8000279c:	6446                	ld	s0,80(sp)
    8000279e:	64a6                	ld	s1,72(sp)
    800027a0:	6906                	ld	s2,64(sp)
    800027a2:	79e2                	ld	s3,56(sp)
    800027a4:	7a42                	ld	s4,48(sp)
    800027a6:	7aa2                	ld	s5,40(sp)
    800027a8:	7b02                	ld	s6,32(sp)
    800027aa:	6be2                	ld	s7,24(sp)
    800027ac:	6c42                	ld	s8,16(sp)
    800027ae:	6ca2                	ld	s9,8(sp)
    800027b0:	6125                	addi	sp,sp,96
    800027b2:	8082                	ret

00000000800027b4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027b4:	7179                	addi	sp,sp,-48
    800027b6:	f406                	sd	ra,40(sp)
    800027b8:	f022                	sd	s0,32(sp)
    800027ba:	ec26                	sd	s1,24(sp)
    800027bc:	e84a                	sd	s2,16(sp)
    800027be:	e44e                	sd	s3,8(sp)
    800027c0:	e052                	sd	s4,0(sp)
    800027c2:	1800                	addi	s0,sp,48
    800027c4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027c6:	47ad                	li	a5,11
    800027c8:	04b7fe63          	bgeu	a5,a1,80002824 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027cc:	ff45849b          	addiw	s1,a1,-12
    800027d0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027d4:	0ff00793          	li	a5,255
    800027d8:	0ae7e363          	bltu	a5,a4,8000287e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027dc:	08052583          	lw	a1,128(a0)
    800027e0:	c5ad                	beqz	a1,8000284a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027e2:	00092503          	lw	a0,0(s2)
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	bda080e7          	jalr	-1062(ra) # 800023c0 <bread>
    800027ee:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027f0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027f4:	02049593          	slli	a1,s1,0x20
    800027f8:	9181                	srli	a1,a1,0x20
    800027fa:	058a                	slli	a1,a1,0x2
    800027fc:	00b784b3          	add	s1,a5,a1
    80002800:	0004a983          	lw	s3,0(s1)
    80002804:	04098d63          	beqz	s3,8000285e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002808:	8552                	mv	a0,s4
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	ce6080e7          	jalr	-794(ra) # 800024f0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002812:	854e                	mv	a0,s3
    80002814:	70a2                	ld	ra,40(sp)
    80002816:	7402                	ld	s0,32(sp)
    80002818:	64e2                	ld	s1,24(sp)
    8000281a:	6942                	ld	s2,16(sp)
    8000281c:	69a2                	ld	s3,8(sp)
    8000281e:	6a02                	ld	s4,0(sp)
    80002820:	6145                	addi	sp,sp,48
    80002822:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002824:	02059493          	slli	s1,a1,0x20
    80002828:	9081                	srli	s1,s1,0x20
    8000282a:	048a                	slli	s1,s1,0x2
    8000282c:	94aa                	add	s1,s1,a0
    8000282e:	0504a983          	lw	s3,80(s1)
    80002832:	fe0990e3          	bnez	s3,80002812 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002836:	4108                	lw	a0,0(a0)
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	e4a080e7          	jalr	-438(ra) # 80002682 <balloc>
    80002840:	0005099b          	sext.w	s3,a0
    80002844:	0534a823          	sw	s3,80(s1)
    80002848:	b7e9                	j	80002812 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000284a:	4108                	lw	a0,0(a0)
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	e36080e7          	jalr	-458(ra) # 80002682 <balloc>
    80002854:	0005059b          	sext.w	a1,a0
    80002858:	08b92023          	sw	a1,128(s2)
    8000285c:	b759                	j	800027e2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000285e:	00092503          	lw	a0,0(s2)
    80002862:	00000097          	auipc	ra,0x0
    80002866:	e20080e7          	jalr	-480(ra) # 80002682 <balloc>
    8000286a:	0005099b          	sext.w	s3,a0
    8000286e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002872:	8552                	mv	a0,s4
    80002874:	00001097          	auipc	ra,0x1
    80002878:	ef8080e7          	jalr	-264(ra) # 8000376c <log_write>
    8000287c:	b771                	j	80002808 <bmap+0x54>
  panic("bmap: out of range");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	c7250513          	addi	a0,a0,-910 # 800084f0 <syscalls+0x128>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	43c080e7          	jalr	1084(ra) # 80005cc2 <panic>

000000008000288e <iget>:
{
    8000288e:	7179                	addi	sp,sp,-48
    80002890:	f406                	sd	ra,40(sp)
    80002892:	f022                	sd	s0,32(sp)
    80002894:	ec26                	sd	s1,24(sp)
    80002896:	e84a                	sd	s2,16(sp)
    80002898:	e44e                	sd	s3,8(sp)
    8000289a:	e052                	sd	s4,0(sp)
    8000289c:	1800                	addi	s0,sp,48
    8000289e:	89aa                	mv	s3,a0
    800028a0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a2:	00015517          	auipc	a0,0x15
    800028a6:	2d650513          	addi	a0,a0,726 # 80017b78 <itable>
    800028aa:	00004097          	auipc	ra,0x4
    800028ae:	92a080e7          	jalr	-1750(ra) # 800061d4 <acquire>
  empty = 0;
    800028b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b4:	00015497          	auipc	s1,0x15
    800028b8:	2dc48493          	addi	s1,s1,732 # 80017b90 <itable+0x18>
    800028bc:	00017697          	auipc	a3,0x17
    800028c0:	d6468693          	addi	a3,a3,-668 # 80019620 <log>
    800028c4:	a039                	j	800028d2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c6:	02090b63          	beqz	s2,800028fc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ca:	08848493          	addi	s1,s1,136
    800028ce:	02d48a63          	beq	s1,a3,80002902 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d2:	449c                	lw	a5,8(s1)
    800028d4:	fef059e3          	blez	a5,800028c6 <iget+0x38>
    800028d8:	4098                	lw	a4,0(s1)
    800028da:	ff3716e3          	bne	a4,s3,800028c6 <iget+0x38>
    800028de:	40d8                	lw	a4,4(s1)
    800028e0:	ff4713e3          	bne	a4,s4,800028c6 <iget+0x38>
      ip->ref++;
    800028e4:	2785                	addiw	a5,a5,1
    800028e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e8:	00015517          	auipc	a0,0x15
    800028ec:	29050513          	addi	a0,a0,656 # 80017b78 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	998080e7          	jalr	-1640(ra) # 80006288 <release>
      return ip;
    800028f8:	8926                	mv	s2,s1
    800028fa:	a03d                	j	80002928 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fc:	f7f9                	bnez	a5,800028ca <iget+0x3c>
    800028fe:	8926                	mv	s2,s1
    80002900:	b7e9                	j	800028ca <iget+0x3c>
  if(empty == 0)
    80002902:	02090c63          	beqz	s2,8000293a <iget+0xac>
  ip->dev = dev;
    80002906:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000290a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000290e:	4785                	li	a5,1
    80002910:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002914:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002918:	00015517          	auipc	a0,0x15
    8000291c:	26050513          	addi	a0,a0,608 # 80017b78 <itable>
    80002920:	00004097          	auipc	ra,0x4
    80002924:	968080e7          	jalr	-1688(ra) # 80006288 <release>
}
    80002928:	854a                	mv	a0,s2
    8000292a:	70a2                	ld	ra,40(sp)
    8000292c:	7402                	ld	s0,32(sp)
    8000292e:	64e2                	ld	s1,24(sp)
    80002930:	6942                	ld	s2,16(sp)
    80002932:	69a2                	ld	s3,8(sp)
    80002934:	6a02                	ld	s4,0(sp)
    80002936:	6145                	addi	sp,sp,48
    80002938:	8082                	ret
    panic("iget: no inodes");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	bce50513          	addi	a0,a0,-1074 # 80008508 <syscalls+0x140>
    80002942:	00003097          	auipc	ra,0x3
    80002946:	380080e7          	jalr	896(ra) # 80005cc2 <panic>

000000008000294a <fsinit>:
fsinit(int dev) {
    8000294a:	7179                	addi	sp,sp,-48
    8000294c:	f406                	sd	ra,40(sp)
    8000294e:	f022                	sd	s0,32(sp)
    80002950:	ec26                	sd	s1,24(sp)
    80002952:	e84a                	sd	s2,16(sp)
    80002954:	e44e                	sd	s3,8(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295a:	4585                	li	a1,1
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	a64080e7          	jalr	-1436(ra) # 800023c0 <bread>
    80002964:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002966:	00015997          	auipc	s3,0x15
    8000296a:	1f298993          	addi	s3,s3,498 # 80017b58 <sb>
    8000296e:	02000613          	li	a2,32
    80002972:	05850593          	addi	a1,a0,88
    80002976:	854e                	mv	a0,s3
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	85c080e7          	jalr	-1956(ra) # 800001d4 <memmove>
  brelse(bp);
    80002980:	8526                	mv	a0,s1
    80002982:	00000097          	auipc	ra,0x0
    80002986:	b6e080e7          	jalr	-1170(ra) # 800024f0 <brelse>
  if(sb.magic != FSMAGIC)
    8000298a:	0009a703          	lw	a4,0(s3)
    8000298e:	102037b7          	lui	a5,0x10203
    80002992:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002996:	02f71263          	bne	a4,a5,800029ba <fsinit+0x70>
  initlog(dev, &sb);
    8000299a:	00015597          	auipc	a1,0x15
    8000299e:	1be58593          	addi	a1,a1,446 # 80017b58 <sb>
    800029a2:	854a                	mv	a0,s2
    800029a4:	00001097          	auipc	ra,0x1
    800029a8:	b4c080e7          	jalr	-1204(ra) # 800034f0 <initlog>
}
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    panic("invalid file system");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	b5e50513          	addi	a0,a0,-1186 # 80008518 <syscalls+0x150>
    800029c2:	00003097          	auipc	ra,0x3
    800029c6:	300080e7          	jalr	768(ra) # 80005cc2 <panic>

00000000800029ca <iinit>:
{
    800029ca:	7179                	addi	sp,sp,-48
    800029cc:	f406                	sd	ra,40(sp)
    800029ce:	f022                	sd	s0,32(sp)
    800029d0:	ec26                	sd	s1,24(sp)
    800029d2:	e84a                	sd	s2,16(sp)
    800029d4:	e44e                	sd	s3,8(sp)
    800029d6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d8:	00006597          	auipc	a1,0x6
    800029dc:	b5858593          	addi	a1,a1,-1192 # 80008530 <syscalls+0x168>
    800029e0:	00015517          	auipc	a0,0x15
    800029e4:	19850513          	addi	a0,a0,408 # 80017b78 <itable>
    800029e8:	00003097          	auipc	ra,0x3
    800029ec:	75c080e7          	jalr	1884(ra) # 80006144 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029f0:	00015497          	auipc	s1,0x15
    800029f4:	1b048493          	addi	s1,s1,432 # 80017ba0 <itable+0x28>
    800029f8:	00017997          	auipc	s3,0x17
    800029fc:	c3898993          	addi	s3,s3,-968 # 80019630 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a00:	00006917          	auipc	s2,0x6
    80002a04:	b3890913          	addi	s2,s2,-1224 # 80008538 <syscalls+0x170>
    80002a08:	85ca                	mv	a1,s2
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	00001097          	auipc	ra,0x1
    80002a10:	e46080e7          	jalr	-442(ra) # 80003852 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a14:	08848493          	addi	s1,s1,136
    80002a18:	ff3498e3          	bne	s1,s3,80002a08 <iinit+0x3e>
}
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret

0000000080002a2a <ialloc>:
{
    80002a2a:	715d                	addi	sp,sp,-80
    80002a2c:	e486                	sd	ra,72(sp)
    80002a2e:	e0a2                	sd	s0,64(sp)
    80002a30:	fc26                	sd	s1,56(sp)
    80002a32:	f84a                	sd	s2,48(sp)
    80002a34:	f44e                	sd	s3,40(sp)
    80002a36:	f052                	sd	s4,32(sp)
    80002a38:	ec56                	sd	s5,24(sp)
    80002a3a:	e85a                	sd	s6,16(sp)
    80002a3c:	e45e                	sd	s7,8(sp)
    80002a3e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a40:	00015717          	auipc	a4,0x15
    80002a44:	12472703          	lw	a4,292(a4) # 80017b64 <sb+0xc>
    80002a48:	4785                	li	a5,1
    80002a4a:	04e7fa63          	bgeu	a5,a4,80002a9e <ialloc+0x74>
    80002a4e:	8aaa                	mv	s5,a0
    80002a50:	8bae                	mv	s7,a1
    80002a52:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a54:	00015a17          	auipc	s4,0x15
    80002a58:	104a0a13          	addi	s4,s4,260 # 80017b58 <sb>
    80002a5c:	00048b1b          	sext.w	s6,s1
    80002a60:	0044d793          	srli	a5,s1,0x4
    80002a64:	018a2583          	lw	a1,24(s4)
    80002a68:	9dbd                	addw	a1,a1,a5
    80002a6a:	8556                	mv	a0,s5
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	954080e7          	jalr	-1708(ra) # 800023c0 <bread>
    80002a74:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a76:	05850993          	addi	s3,a0,88
    80002a7a:	00f4f793          	andi	a5,s1,15
    80002a7e:	079a                	slli	a5,a5,0x6
    80002a80:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a82:	00099783          	lh	a5,0(s3)
    80002a86:	c785                	beqz	a5,80002aae <ialloc+0x84>
    brelse(bp);
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	a68080e7          	jalr	-1432(ra) # 800024f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a90:	0485                	addi	s1,s1,1
    80002a92:	00ca2703          	lw	a4,12(s4)
    80002a96:	0004879b          	sext.w	a5,s1
    80002a9a:	fce7e1e3          	bltu	a5,a4,80002a5c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	aa250513          	addi	a0,a0,-1374 # 80008540 <syscalls+0x178>
    80002aa6:	00003097          	auipc	ra,0x3
    80002aaa:	21c080e7          	jalr	540(ra) # 80005cc2 <panic>
      memset(dip, 0, sizeof(*dip));
    80002aae:	04000613          	li	a2,64
    80002ab2:	4581                	li	a1,0
    80002ab4:	854e                	mv	a0,s3
    80002ab6:	ffffd097          	auipc	ra,0xffffd
    80002aba:	6c2080e7          	jalr	1730(ra) # 80000178 <memset>
      dip->type = type;
    80002abe:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ac2:	854a                	mv	a0,s2
    80002ac4:	00001097          	auipc	ra,0x1
    80002ac8:	ca8080e7          	jalr	-856(ra) # 8000376c <log_write>
      brelse(bp);
    80002acc:	854a                	mv	a0,s2
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	a22080e7          	jalr	-1502(ra) # 800024f0 <brelse>
      return iget(dev, inum);
    80002ad6:	85da                	mv	a1,s6
    80002ad8:	8556                	mv	a0,s5
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	db4080e7          	jalr	-588(ra) # 8000288e <iget>
}
    80002ae2:	60a6                	ld	ra,72(sp)
    80002ae4:	6406                	ld	s0,64(sp)
    80002ae6:	74e2                	ld	s1,56(sp)
    80002ae8:	7942                	ld	s2,48(sp)
    80002aea:	79a2                	ld	s3,40(sp)
    80002aec:	7a02                	ld	s4,32(sp)
    80002aee:	6ae2                	ld	s5,24(sp)
    80002af0:	6b42                	ld	s6,16(sp)
    80002af2:	6ba2                	ld	s7,8(sp)
    80002af4:	6161                	addi	sp,sp,80
    80002af6:	8082                	ret

0000000080002af8 <iupdate>:
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	e04a                	sd	s2,0(sp)
    80002b02:	1000                	addi	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b06:	415c                	lw	a5,4(a0)
    80002b08:	0047d79b          	srliw	a5,a5,0x4
    80002b0c:	00015597          	auipc	a1,0x15
    80002b10:	0645a583          	lw	a1,100(a1) # 80017b70 <sb+0x18>
    80002b14:	9dbd                	addw	a1,a1,a5
    80002b16:	4108                	lw	a0,0(a0)
    80002b18:	00000097          	auipc	ra,0x0
    80002b1c:	8a8080e7          	jalr	-1880(ra) # 800023c0 <bread>
    80002b20:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b22:	05850793          	addi	a5,a0,88
    80002b26:	40c8                	lw	a0,4(s1)
    80002b28:	893d                	andi	a0,a0,15
    80002b2a:	051a                	slli	a0,a0,0x6
    80002b2c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b2e:	04449703          	lh	a4,68(s1)
    80002b32:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b36:	04649703          	lh	a4,70(s1)
    80002b3a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b3e:	04849703          	lh	a4,72(s1)
    80002b42:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b46:	04a49703          	lh	a4,74(s1)
    80002b4a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b4e:	44f8                	lw	a4,76(s1)
    80002b50:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b52:	03400613          	li	a2,52
    80002b56:	05048593          	addi	a1,s1,80
    80002b5a:	0531                	addi	a0,a0,12
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	678080e7          	jalr	1656(ra) # 800001d4 <memmove>
  log_write(bp);
    80002b64:	854a                	mv	a0,s2
    80002b66:	00001097          	auipc	ra,0x1
    80002b6a:	c06080e7          	jalr	-1018(ra) # 8000376c <log_write>
  brelse(bp);
    80002b6e:	854a                	mv	a0,s2
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	980080e7          	jalr	-1664(ra) # 800024f0 <brelse>
}
    80002b78:	60e2                	ld	ra,24(sp)
    80002b7a:	6442                	ld	s0,16(sp)
    80002b7c:	64a2                	ld	s1,8(sp)
    80002b7e:	6902                	ld	s2,0(sp)
    80002b80:	6105                	addi	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <idup>:
{
    80002b84:	1101                	addi	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	1000                	addi	s0,sp,32
    80002b8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b90:	00015517          	auipc	a0,0x15
    80002b94:	fe850513          	addi	a0,a0,-24 # 80017b78 <itable>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	63c080e7          	jalr	1596(ra) # 800061d4 <acquire>
  ip->ref++;
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	2785                	addiw	a5,a5,1
    80002ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba6:	00015517          	auipc	a0,0x15
    80002baa:	fd250513          	addi	a0,a0,-46 # 80017b78 <itable>
    80002bae:	00003097          	auipc	ra,0x3
    80002bb2:	6da080e7          	jalr	1754(ra) # 80006288 <release>
}
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <ilock>:
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	e04a                	sd	s2,0(sp)
    80002bcc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bce:	c115                	beqz	a0,80002bf2 <ilock+0x30>
    80002bd0:	84aa                	mv	s1,a0
    80002bd2:	451c                	lw	a5,8(a0)
    80002bd4:	00f05f63          	blez	a5,80002bf2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bd8:	0541                	addi	a0,a0,16
    80002bda:	00001097          	auipc	ra,0x1
    80002bde:	cb2080e7          	jalr	-846(ra) # 8000388c <acquiresleep>
  if(ip->valid == 0){
    80002be2:	40bc                	lw	a5,64(s1)
    80002be4:	cf99                	beqz	a5,80002c02 <ilock+0x40>
}
    80002be6:	60e2                	ld	ra,24(sp)
    80002be8:	6442                	ld	s0,16(sp)
    80002bea:	64a2                	ld	s1,8(sp)
    80002bec:	6902                	ld	s2,0(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret
    panic("ilock");
    80002bf2:	00006517          	auipc	a0,0x6
    80002bf6:	96650513          	addi	a0,a0,-1690 # 80008558 <syscalls+0x190>
    80002bfa:	00003097          	auipc	ra,0x3
    80002bfe:	0c8080e7          	jalr	200(ra) # 80005cc2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c02:	40dc                	lw	a5,4(s1)
    80002c04:	0047d79b          	srliw	a5,a5,0x4
    80002c08:	00015597          	auipc	a1,0x15
    80002c0c:	f685a583          	lw	a1,-152(a1) # 80017b70 <sb+0x18>
    80002c10:	9dbd                	addw	a1,a1,a5
    80002c12:	4088                	lw	a0,0(s1)
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	7ac080e7          	jalr	1964(ra) # 800023c0 <bread>
    80002c1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1e:	05850593          	addi	a1,a0,88
    80002c22:	40dc                	lw	a5,4(s1)
    80002c24:	8bbd                	andi	a5,a5,15
    80002c26:	079a                	slli	a5,a5,0x6
    80002c28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c2a:	00059783          	lh	a5,0(a1)
    80002c2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c32:	00259783          	lh	a5,2(a1)
    80002c36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c3a:	00459783          	lh	a5,4(a1)
    80002c3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c42:	00659783          	lh	a5,6(a1)
    80002c46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c4a:	459c                	lw	a5,8(a1)
    80002c4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4e:	03400613          	li	a2,52
    80002c52:	05b1                	addi	a1,a1,12
    80002c54:	05048513          	addi	a0,s1,80
    80002c58:	ffffd097          	auipc	ra,0xffffd
    80002c5c:	57c080e7          	jalr	1404(ra) # 800001d4 <memmove>
    brelse(bp);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	88e080e7          	jalr	-1906(ra) # 800024f0 <brelse>
    ip->valid = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6e:	04449783          	lh	a5,68(s1)
    80002c72:	fbb5                	bnez	a5,80002be6 <ilock+0x24>
      panic("ilock: no type");
    80002c74:	00006517          	auipc	a0,0x6
    80002c78:	8ec50513          	addi	a0,a0,-1812 # 80008560 <syscalls+0x198>
    80002c7c:	00003097          	auipc	ra,0x3
    80002c80:	046080e7          	jalr	70(ra) # 80005cc2 <panic>

0000000080002c84 <iunlock>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	e04a                	sd	s2,0(sp)
    80002c8e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c90:	c905                	beqz	a0,80002cc0 <iunlock+0x3c>
    80002c92:	84aa                	mv	s1,a0
    80002c94:	01050913          	addi	s2,a0,16
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	c8c080e7          	jalr	-884(ra) # 80003926 <holdingsleep>
    80002ca2:	cd19                	beqz	a0,80002cc0 <iunlock+0x3c>
    80002ca4:	449c                	lw	a5,8(s1)
    80002ca6:	00f05d63          	blez	a5,80002cc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002caa:	854a                	mv	a0,s2
    80002cac:	00001097          	auipc	ra,0x1
    80002cb0:	c36080e7          	jalr	-970(ra) # 800038e2 <releasesleep>
}
    80002cb4:	60e2                	ld	ra,24(sp)
    80002cb6:	6442                	ld	s0,16(sp)
    80002cb8:	64a2                	ld	s1,8(sp)
    80002cba:	6902                	ld	s2,0(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret
    panic("iunlock");
    80002cc0:	00006517          	auipc	a0,0x6
    80002cc4:	8b050513          	addi	a0,a0,-1872 # 80008570 <syscalls+0x1a8>
    80002cc8:	00003097          	auipc	ra,0x3
    80002ccc:	ffa080e7          	jalr	-6(ra) # 80005cc2 <panic>

0000000080002cd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd0:	7179                	addi	sp,sp,-48
    80002cd2:	f406                	sd	ra,40(sp)
    80002cd4:	f022                	sd	s0,32(sp)
    80002cd6:	ec26                	sd	s1,24(sp)
    80002cd8:	e84a                	sd	s2,16(sp)
    80002cda:	e44e                	sd	s3,8(sp)
    80002cdc:	e052                	sd	s4,0(sp)
    80002cde:	1800                	addi	s0,sp,48
    80002ce0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce2:	05050493          	addi	s1,a0,80
    80002ce6:	08050913          	addi	s2,a0,128
    80002cea:	a021                	j	80002cf2 <itrunc+0x22>
    80002cec:	0491                	addi	s1,s1,4
    80002cee:	01248d63          	beq	s1,s2,80002d08 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cf2:	408c                	lw	a1,0(s1)
    80002cf4:	dde5                	beqz	a1,80002cec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cf6:	0009a503          	lw	a0,0(s3)
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	90c080e7          	jalr	-1780(ra) # 80002606 <bfree>
      ip->addrs[i] = 0;
    80002d02:	0004a023          	sw	zero,0(s1)
    80002d06:	b7dd                	j	80002cec <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d08:	0809a583          	lw	a1,128(s3)
    80002d0c:	e185                	bnez	a1,80002d2c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d0e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d12:	854e                	mv	a0,s3
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	de4080e7          	jalr	-540(ra) # 80002af8 <iupdate>
}
    80002d1c:	70a2                	ld	ra,40(sp)
    80002d1e:	7402                	ld	s0,32(sp)
    80002d20:	64e2                	ld	s1,24(sp)
    80002d22:	6942                	ld	s2,16(sp)
    80002d24:	69a2                	ld	s3,8(sp)
    80002d26:	6a02                	ld	s4,0(sp)
    80002d28:	6145                	addi	sp,sp,48
    80002d2a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d2c:	0009a503          	lw	a0,0(s3)
    80002d30:	fffff097          	auipc	ra,0xfffff
    80002d34:	690080e7          	jalr	1680(ra) # 800023c0 <bread>
    80002d38:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d3a:	05850493          	addi	s1,a0,88
    80002d3e:	45850913          	addi	s2,a0,1112
    80002d42:	a021                	j	80002d4a <itrunc+0x7a>
    80002d44:	0491                	addi	s1,s1,4
    80002d46:	01248b63          	beq	s1,s2,80002d5c <itrunc+0x8c>
      if(a[j])
    80002d4a:	408c                	lw	a1,0(s1)
    80002d4c:	dde5                	beqz	a1,80002d44 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d4e:	0009a503          	lw	a0,0(s3)
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	8b4080e7          	jalr	-1868(ra) # 80002606 <bfree>
    80002d5a:	b7ed                	j	80002d44 <itrunc+0x74>
    brelse(bp);
    80002d5c:	8552                	mv	a0,s4
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	792080e7          	jalr	1938(ra) # 800024f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d66:	0809a583          	lw	a1,128(s3)
    80002d6a:	0009a503          	lw	a0,0(s3)
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	898080e7          	jalr	-1896(ra) # 80002606 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d76:	0809a023          	sw	zero,128(s3)
    80002d7a:	bf51                	j	80002d0e <itrunc+0x3e>

0000000080002d7c <iput>:
{
    80002d7c:	1101                	addi	sp,sp,-32
    80002d7e:	ec06                	sd	ra,24(sp)
    80002d80:	e822                	sd	s0,16(sp)
    80002d82:	e426                	sd	s1,8(sp)
    80002d84:	e04a                	sd	s2,0(sp)
    80002d86:	1000                	addi	s0,sp,32
    80002d88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d8a:	00015517          	auipc	a0,0x15
    80002d8e:	dee50513          	addi	a0,a0,-530 # 80017b78 <itable>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	442080e7          	jalr	1090(ra) # 800061d4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9a:	4498                	lw	a4,8(s1)
    80002d9c:	4785                	li	a5,1
    80002d9e:	02f70363          	beq	a4,a5,80002dc4 <iput+0x48>
  ip->ref--;
    80002da2:	449c                	lw	a5,8(s1)
    80002da4:	37fd                	addiw	a5,a5,-1
    80002da6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002da8:	00015517          	auipc	a0,0x15
    80002dac:	dd050513          	addi	a0,a0,-560 # 80017b78 <itable>
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	4d8080e7          	jalr	1240(ra) # 80006288 <release>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	64a2                	ld	s1,8(sp)
    80002dbe:	6902                	ld	s2,0(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc4:	40bc                	lw	a5,64(s1)
    80002dc6:	dff1                	beqz	a5,80002da2 <iput+0x26>
    80002dc8:	04a49783          	lh	a5,74(s1)
    80002dcc:	fbf9                	bnez	a5,80002da2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dce:	01048913          	addi	s2,s1,16
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	00001097          	auipc	ra,0x1
    80002dd8:	ab8080e7          	jalr	-1352(ra) # 8000388c <acquiresleep>
    release(&itable.lock);
    80002ddc:	00015517          	auipc	a0,0x15
    80002de0:	d9c50513          	addi	a0,a0,-612 # 80017b78 <itable>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	4a4080e7          	jalr	1188(ra) # 80006288 <release>
    itrunc(ip);
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	ee2080e7          	jalr	-286(ra) # 80002cd0 <itrunc>
    ip->type = 0;
    80002df6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dfa:	8526                	mv	a0,s1
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	cfc080e7          	jalr	-772(ra) # 80002af8 <iupdate>
    ip->valid = 0;
    80002e04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e08:	854a                	mv	a0,s2
    80002e0a:	00001097          	auipc	ra,0x1
    80002e0e:	ad8080e7          	jalr	-1320(ra) # 800038e2 <releasesleep>
    acquire(&itable.lock);
    80002e12:	00015517          	auipc	a0,0x15
    80002e16:	d6650513          	addi	a0,a0,-666 # 80017b78 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	3ba080e7          	jalr	954(ra) # 800061d4 <acquire>
    80002e22:	b741                	j	80002da2 <iput+0x26>

0000000080002e24 <iunlockput>:
{
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	e54080e7          	jalr	-428(ra) # 80002c84 <iunlock>
  iput(ip);
    80002e38:	8526                	mv	a0,s1
    80002e3a:	00000097          	auipc	ra,0x0
    80002e3e:	f42080e7          	jalr	-190(ra) # 80002d7c <iput>
}
    80002e42:	60e2                	ld	ra,24(sp)
    80002e44:	6442                	ld	s0,16(sp)
    80002e46:	64a2                	ld	s1,8(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret

0000000080002e4c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e4c:	1141                	addi	sp,sp,-16
    80002e4e:	e422                	sd	s0,8(sp)
    80002e50:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e52:	411c                	lw	a5,0(a0)
    80002e54:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e56:	415c                	lw	a5,4(a0)
    80002e58:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e5a:	04451783          	lh	a5,68(a0)
    80002e5e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e62:	04a51783          	lh	a5,74(a0)
    80002e66:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e6a:	04c56783          	lwu	a5,76(a0)
    80002e6e:	e99c                	sd	a5,16(a1)
}
    80002e70:	6422                	ld	s0,8(sp)
    80002e72:	0141                	addi	sp,sp,16
    80002e74:	8082                	ret

0000000080002e76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e76:	457c                	lw	a5,76(a0)
    80002e78:	0ed7e963          	bltu	a5,a3,80002f6a <readi+0xf4>
{
    80002e7c:	7159                	addi	sp,sp,-112
    80002e7e:	f486                	sd	ra,104(sp)
    80002e80:	f0a2                	sd	s0,96(sp)
    80002e82:	eca6                	sd	s1,88(sp)
    80002e84:	e8ca                	sd	s2,80(sp)
    80002e86:	e4ce                	sd	s3,72(sp)
    80002e88:	e0d2                	sd	s4,64(sp)
    80002e8a:	fc56                	sd	s5,56(sp)
    80002e8c:	f85a                	sd	s6,48(sp)
    80002e8e:	f45e                	sd	s7,40(sp)
    80002e90:	f062                	sd	s8,32(sp)
    80002e92:	ec66                	sd	s9,24(sp)
    80002e94:	e86a                	sd	s10,16(sp)
    80002e96:	e46e                	sd	s11,8(sp)
    80002e98:	1880                	addi	s0,sp,112
    80002e9a:	8baa                	mv	s7,a0
    80002e9c:	8c2e                	mv	s8,a1
    80002e9e:	8ab2                	mv	s5,a2
    80002ea0:	84b6                	mv	s1,a3
    80002ea2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ea4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea8:	0ad76063          	bltu	a4,a3,80002f48 <readi+0xd2>
  if(off + n > ip->size)
    80002eac:	00e7f463          	bgeu	a5,a4,80002eb4 <readi+0x3e>
    n = ip->size - off;
    80002eb0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb4:	0a0b0963          	beqz	s6,80002f66 <readi+0xf0>
    80002eb8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eba:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ebe:	5cfd                	li	s9,-1
    80002ec0:	a82d                	j	80002efa <readi+0x84>
    80002ec2:	020a1d93          	slli	s11,s4,0x20
    80002ec6:	020ddd93          	srli	s11,s11,0x20
    80002eca:	05890793          	addi	a5,s2,88
    80002ece:	86ee                	mv	a3,s11
    80002ed0:	963e                	add	a2,a2,a5
    80002ed2:	85d6                	mv	a1,s5
    80002ed4:	8562                	mv	a0,s8
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	a26080e7          	jalr	-1498(ra) # 800018fc <either_copyout>
    80002ede:	05950d63          	beq	a0,s9,80002f38 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	60c080e7          	jalr	1548(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eec:	013a09bb          	addw	s3,s4,s3
    80002ef0:	009a04bb          	addw	s1,s4,s1
    80002ef4:	9aee                	add	s5,s5,s11
    80002ef6:	0569f763          	bgeu	s3,s6,80002f44 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002efa:	000ba903          	lw	s2,0(s7)
    80002efe:	00a4d59b          	srliw	a1,s1,0xa
    80002f02:	855e                	mv	a0,s7
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	8b0080e7          	jalr	-1872(ra) # 800027b4 <bmap>
    80002f0c:	0005059b          	sext.w	a1,a0
    80002f10:	854a                	mv	a0,s2
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	4ae080e7          	jalr	1198(ra) # 800023c0 <bread>
    80002f1a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1c:	3ff4f613          	andi	a2,s1,1023
    80002f20:	40cd07bb          	subw	a5,s10,a2
    80002f24:	413b073b          	subw	a4,s6,s3
    80002f28:	8a3e                	mv	s4,a5
    80002f2a:	2781                	sext.w	a5,a5
    80002f2c:	0007069b          	sext.w	a3,a4
    80002f30:	f8f6f9e3          	bgeu	a3,a5,80002ec2 <readi+0x4c>
    80002f34:	8a3a                	mv	s4,a4
    80002f36:	b771                	j	80002ec2 <readi+0x4c>
      brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	5b6080e7          	jalr	1462(ra) # 800024f0 <brelse>
      tot = -1;
    80002f42:	59fd                	li	s3,-1
  }
  return tot;
    80002f44:	0009851b          	sext.w	a0,s3
}
    80002f48:	70a6                	ld	ra,104(sp)
    80002f4a:	7406                	ld	s0,96(sp)
    80002f4c:	64e6                	ld	s1,88(sp)
    80002f4e:	6946                	ld	s2,80(sp)
    80002f50:	69a6                	ld	s3,72(sp)
    80002f52:	6a06                	ld	s4,64(sp)
    80002f54:	7ae2                	ld	s5,56(sp)
    80002f56:	7b42                	ld	s6,48(sp)
    80002f58:	7ba2                	ld	s7,40(sp)
    80002f5a:	7c02                	ld	s8,32(sp)
    80002f5c:	6ce2                	ld	s9,24(sp)
    80002f5e:	6d42                	ld	s10,16(sp)
    80002f60:	6da2                	ld	s11,8(sp)
    80002f62:	6165                	addi	sp,sp,112
    80002f64:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f66:	89da                	mv	s3,s6
    80002f68:	bff1                	j	80002f44 <readi+0xce>
    return 0;
    80002f6a:	4501                	li	a0,0
}
    80002f6c:	8082                	ret

0000000080002f6e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f6e:	457c                	lw	a5,76(a0)
    80002f70:	10d7e863          	bltu	a5,a3,80003080 <writei+0x112>
{
    80002f74:	7159                	addi	sp,sp,-112
    80002f76:	f486                	sd	ra,104(sp)
    80002f78:	f0a2                	sd	s0,96(sp)
    80002f7a:	eca6                	sd	s1,88(sp)
    80002f7c:	e8ca                	sd	s2,80(sp)
    80002f7e:	e4ce                	sd	s3,72(sp)
    80002f80:	e0d2                	sd	s4,64(sp)
    80002f82:	fc56                	sd	s5,56(sp)
    80002f84:	f85a                	sd	s6,48(sp)
    80002f86:	f45e                	sd	s7,40(sp)
    80002f88:	f062                	sd	s8,32(sp)
    80002f8a:	ec66                	sd	s9,24(sp)
    80002f8c:	e86a                	sd	s10,16(sp)
    80002f8e:	e46e                	sd	s11,8(sp)
    80002f90:	1880                	addi	s0,sp,112
    80002f92:	8b2a                	mv	s6,a0
    80002f94:	8c2e                	mv	s8,a1
    80002f96:	8ab2                	mv	s5,a2
    80002f98:	8936                	mv	s2,a3
    80002f9a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f9c:	00e687bb          	addw	a5,a3,a4
    80002fa0:	0ed7e263          	bltu	a5,a3,80003084 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa4:	00043737          	lui	a4,0x43
    80002fa8:	0ef76063          	bltu	a4,a5,80003088 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fac:	0c0b8863          	beqz	s7,8000307c <writei+0x10e>
    80002fb0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fb6:	5cfd                	li	s9,-1
    80002fb8:	a091                	j	80002ffc <writei+0x8e>
    80002fba:	02099d93          	slli	s11,s3,0x20
    80002fbe:	020ddd93          	srli	s11,s11,0x20
    80002fc2:	05848793          	addi	a5,s1,88
    80002fc6:	86ee                	mv	a3,s11
    80002fc8:	8656                	mv	a2,s5
    80002fca:	85e2                	mv	a1,s8
    80002fcc:	953e                	add	a0,a0,a5
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	984080e7          	jalr	-1660(ra) # 80001952 <either_copyin>
    80002fd6:	07950263          	beq	a0,s9,8000303a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fda:	8526                	mv	a0,s1
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	790080e7          	jalr	1936(ra) # 8000376c <log_write>
    brelse(bp);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	50a080e7          	jalr	1290(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fee:	01498a3b          	addw	s4,s3,s4
    80002ff2:	0129893b          	addw	s2,s3,s2
    80002ff6:	9aee                	add	s5,s5,s11
    80002ff8:	057a7663          	bgeu	s4,s7,80003044 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ffc:	000b2483          	lw	s1,0(s6)
    80003000:	00a9559b          	srliw	a1,s2,0xa
    80003004:	855a                	mv	a0,s6
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	7ae080e7          	jalr	1966(ra) # 800027b4 <bmap>
    8000300e:	0005059b          	sext.w	a1,a0
    80003012:	8526                	mv	a0,s1
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	3ac080e7          	jalr	940(ra) # 800023c0 <bread>
    8000301c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301e:	3ff97513          	andi	a0,s2,1023
    80003022:	40ad07bb          	subw	a5,s10,a0
    80003026:	414b873b          	subw	a4,s7,s4
    8000302a:	89be                	mv	s3,a5
    8000302c:	2781                	sext.w	a5,a5
    8000302e:	0007069b          	sext.w	a3,a4
    80003032:	f8f6f4e3          	bgeu	a3,a5,80002fba <writei+0x4c>
    80003036:	89ba                	mv	s3,a4
    80003038:	b749                	j	80002fba <writei+0x4c>
      brelse(bp);
    8000303a:	8526                	mv	a0,s1
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	4b4080e7          	jalr	1204(ra) # 800024f0 <brelse>
  }

  if(off > ip->size)
    80003044:	04cb2783          	lw	a5,76(s6)
    80003048:	0127f463          	bgeu	a5,s2,80003050 <writei+0xe2>
    ip->size = off;
    8000304c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003050:	855a                	mv	a0,s6
    80003052:	00000097          	auipc	ra,0x0
    80003056:	aa6080e7          	jalr	-1370(ra) # 80002af8 <iupdate>

  return tot;
    8000305a:	000a051b          	sext.w	a0,s4
}
    8000305e:	70a6                	ld	ra,104(sp)
    80003060:	7406                	ld	s0,96(sp)
    80003062:	64e6                	ld	s1,88(sp)
    80003064:	6946                	ld	s2,80(sp)
    80003066:	69a6                	ld	s3,72(sp)
    80003068:	6a06                	ld	s4,64(sp)
    8000306a:	7ae2                	ld	s5,56(sp)
    8000306c:	7b42                	ld	s6,48(sp)
    8000306e:	7ba2                	ld	s7,40(sp)
    80003070:	7c02                	ld	s8,32(sp)
    80003072:	6ce2                	ld	s9,24(sp)
    80003074:	6d42                	ld	s10,16(sp)
    80003076:	6da2                	ld	s11,8(sp)
    80003078:	6165                	addi	sp,sp,112
    8000307a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000307c:	8a5e                	mv	s4,s7
    8000307e:	bfc9                	j	80003050 <writei+0xe2>
    return -1;
    80003080:	557d                	li	a0,-1
}
    80003082:	8082                	ret
    return -1;
    80003084:	557d                	li	a0,-1
    80003086:	bfe1                	j	8000305e <writei+0xf0>
    return -1;
    80003088:	557d                	li	a0,-1
    8000308a:	bfd1                	j	8000305e <writei+0xf0>

000000008000308c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000308c:	1141                	addi	sp,sp,-16
    8000308e:	e406                	sd	ra,8(sp)
    80003090:	e022                	sd	s0,0(sp)
    80003092:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003094:	4639                	li	a2,14
    80003096:	ffffd097          	auipc	ra,0xffffd
    8000309a:	1b2080e7          	jalr	434(ra) # 80000248 <strncmp>
}
    8000309e:	60a2                	ld	ra,8(sp)
    800030a0:	6402                	ld	s0,0(sp)
    800030a2:	0141                	addi	sp,sp,16
    800030a4:	8082                	ret

00000000800030a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030a6:	7139                	addi	sp,sp,-64
    800030a8:	fc06                	sd	ra,56(sp)
    800030aa:	f822                	sd	s0,48(sp)
    800030ac:	f426                	sd	s1,40(sp)
    800030ae:	f04a                	sd	s2,32(sp)
    800030b0:	ec4e                	sd	s3,24(sp)
    800030b2:	e852                	sd	s4,16(sp)
    800030b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030b6:	04451703          	lh	a4,68(a0)
    800030ba:	4785                	li	a5,1
    800030bc:	00f71a63          	bne	a4,a5,800030d0 <dirlookup+0x2a>
    800030c0:	892a                	mv	s2,a0
    800030c2:	89ae                	mv	s3,a1
    800030c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c6:	457c                	lw	a5,76(a0)
    800030c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030cc:	e79d                	bnez	a5,800030fa <dirlookup+0x54>
    800030ce:	a8a5                	j	80003146 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030d0:	00005517          	auipc	a0,0x5
    800030d4:	4a850513          	addi	a0,a0,1192 # 80008578 <syscalls+0x1b0>
    800030d8:	00003097          	auipc	ra,0x3
    800030dc:	bea080e7          	jalr	-1046(ra) # 80005cc2 <panic>
      panic("dirlookup read");
    800030e0:	00005517          	auipc	a0,0x5
    800030e4:	4b050513          	addi	a0,a0,1200 # 80008590 <syscalls+0x1c8>
    800030e8:	00003097          	auipc	ra,0x3
    800030ec:	bda080e7          	jalr	-1062(ra) # 80005cc2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f0:	24c1                	addiw	s1,s1,16
    800030f2:	04c92783          	lw	a5,76(s2)
    800030f6:	04f4f763          	bgeu	s1,a5,80003144 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030fa:	4741                	li	a4,16
    800030fc:	86a6                	mv	a3,s1
    800030fe:	fc040613          	addi	a2,s0,-64
    80003102:	4581                	li	a1,0
    80003104:	854a                	mv	a0,s2
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	d70080e7          	jalr	-656(ra) # 80002e76 <readi>
    8000310e:	47c1                	li	a5,16
    80003110:	fcf518e3          	bne	a0,a5,800030e0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003114:	fc045783          	lhu	a5,-64(s0)
    80003118:	dfe1                	beqz	a5,800030f0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000311a:	fc240593          	addi	a1,s0,-62
    8000311e:	854e                	mv	a0,s3
    80003120:	00000097          	auipc	ra,0x0
    80003124:	f6c080e7          	jalr	-148(ra) # 8000308c <namecmp>
    80003128:	f561                	bnez	a0,800030f0 <dirlookup+0x4a>
      if(poff)
    8000312a:	000a0463          	beqz	s4,80003132 <dirlookup+0x8c>
        *poff = off;
    8000312e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003132:	fc045583          	lhu	a1,-64(s0)
    80003136:	00092503          	lw	a0,0(s2)
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	754080e7          	jalr	1876(ra) # 8000288e <iget>
    80003142:	a011                	j	80003146 <dirlookup+0xa0>
  return 0;
    80003144:	4501                	li	a0,0
}
    80003146:	70e2                	ld	ra,56(sp)
    80003148:	7442                	ld	s0,48(sp)
    8000314a:	74a2                	ld	s1,40(sp)
    8000314c:	7902                	ld	s2,32(sp)
    8000314e:	69e2                	ld	s3,24(sp)
    80003150:	6a42                	ld	s4,16(sp)
    80003152:	6121                	addi	sp,sp,64
    80003154:	8082                	ret

0000000080003156 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003156:	711d                	addi	sp,sp,-96
    80003158:	ec86                	sd	ra,88(sp)
    8000315a:	e8a2                	sd	s0,80(sp)
    8000315c:	e4a6                	sd	s1,72(sp)
    8000315e:	e0ca                	sd	s2,64(sp)
    80003160:	fc4e                	sd	s3,56(sp)
    80003162:	f852                	sd	s4,48(sp)
    80003164:	f456                	sd	s5,40(sp)
    80003166:	f05a                	sd	s6,32(sp)
    80003168:	ec5e                	sd	s7,24(sp)
    8000316a:	e862                	sd	s8,16(sp)
    8000316c:	e466                	sd	s9,8(sp)
    8000316e:	1080                	addi	s0,sp,96
    80003170:	84aa                	mv	s1,a0
    80003172:	8aae                	mv	s5,a1
    80003174:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003176:	00054703          	lbu	a4,0(a0)
    8000317a:	02f00793          	li	a5,47
    8000317e:	02f70363          	beq	a4,a5,800031a4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003182:	ffffe097          	auipc	ra,0xffffe
    80003186:	cc0080e7          	jalr	-832(ra) # 80000e42 <myproc>
    8000318a:	15053503          	ld	a0,336(a0)
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	9f6080e7          	jalr	-1546(ra) # 80002b84 <idup>
    80003196:	89aa                	mv	s3,a0
  while(*path == '/')
    80003198:	02f00913          	li	s2,47
  len = path - s;
    8000319c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000319e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031a0:	4b85                	li	s7,1
    800031a2:	a865                	j	8000325a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031a4:	4585                	li	a1,1
    800031a6:	4505                	li	a0,1
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	6e6080e7          	jalr	1766(ra) # 8000288e <iget>
    800031b0:	89aa                	mv	s3,a0
    800031b2:	b7dd                	j	80003198 <namex+0x42>
      iunlockput(ip);
    800031b4:	854e                	mv	a0,s3
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	c6e080e7          	jalr	-914(ra) # 80002e24 <iunlockput>
      return 0;
    800031be:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031c0:	854e                	mv	a0,s3
    800031c2:	60e6                	ld	ra,88(sp)
    800031c4:	6446                	ld	s0,80(sp)
    800031c6:	64a6                	ld	s1,72(sp)
    800031c8:	6906                	ld	s2,64(sp)
    800031ca:	79e2                	ld	s3,56(sp)
    800031cc:	7a42                	ld	s4,48(sp)
    800031ce:	7aa2                	ld	s5,40(sp)
    800031d0:	7b02                	ld	s6,32(sp)
    800031d2:	6be2                	ld	s7,24(sp)
    800031d4:	6c42                	ld	s8,16(sp)
    800031d6:	6ca2                	ld	s9,8(sp)
    800031d8:	6125                	addi	sp,sp,96
    800031da:	8082                	ret
      iunlock(ip);
    800031dc:	854e                	mv	a0,s3
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	aa6080e7          	jalr	-1370(ra) # 80002c84 <iunlock>
      return ip;
    800031e6:	bfe9                	j	800031c0 <namex+0x6a>
      iunlockput(ip);
    800031e8:	854e                	mv	a0,s3
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	c3a080e7          	jalr	-966(ra) # 80002e24 <iunlockput>
      return 0;
    800031f2:	89e6                	mv	s3,s9
    800031f4:	b7f1                	j	800031c0 <namex+0x6a>
  len = path - s;
    800031f6:	40b48633          	sub	a2,s1,a1
    800031fa:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031fe:	099c5463          	bge	s8,s9,80003286 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003202:	4639                	li	a2,14
    80003204:	8552                	mv	a0,s4
    80003206:	ffffd097          	auipc	ra,0xffffd
    8000320a:	fce080e7          	jalr	-50(ra) # 800001d4 <memmove>
  while(*path == '/')
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	01279763          	bne	a5,s2,80003220 <namex+0xca>
    path++;
    80003216:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	ff278de3          	beq	a5,s2,80003216 <namex+0xc0>
    ilock(ip);
    80003220:	854e                	mv	a0,s3
    80003222:	00000097          	auipc	ra,0x0
    80003226:	9a0080e7          	jalr	-1632(ra) # 80002bc2 <ilock>
    if(ip->type != T_DIR){
    8000322a:	04499783          	lh	a5,68(s3)
    8000322e:	f97793e3          	bne	a5,s7,800031b4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003232:	000a8563          	beqz	s5,8000323c <namex+0xe6>
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	d3cd                	beqz	a5,800031dc <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000323c:	865a                	mv	a2,s6
    8000323e:	85d2                	mv	a1,s4
    80003240:	854e                	mv	a0,s3
    80003242:	00000097          	auipc	ra,0x0
    80003246:	e64080e7          	jalr	-412(ra) # 800030a6 <dirlookup>
    8000324a:	8caa                	mv	s9,a0
    8000324c:	dd51                	beqz	a0,800031e8 <namex+0x92>
    iunlockput(ip);
    8000324e:	854e                	mv	a0,s3
    80003250:	00000097          	auipc	ra,0x0
    80003254:	bd4080e7          	jalr	-1068(ra) # 80002e24 <iunlockput>
    ip = next;
    80003258:	89e6                	mv	s3,s9
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	05279763          	bne	a5,s2,800032ac <namex+0x156>
    path++;
    80003262:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	ff278de3          	beq	a5,s2,80003262 <namex+0x10c>
  if(*path == 0)
    8000326c:	c79d                	beqz	a5,8000329a <namex+0x144>
    path++;
    8000326e:	85a6                	mv	a1,s1
  len = path - s;
    80003270:	8cda                	mv	s9,s6
    80003272:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003274:	01278963          	beq	a5,s2,80003286 <namex+0x130>
    80003278:	dfbd                	beqz	a5,800031f6 <namex+0xa0>
    path++;
    8000327a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	ff279ce3          	bne	a5,s2,80003278 <namex+0x122>
    80003284:	bf8d                	j	800031f6 <namex+0xa0>
    memmove(name, s, len);
    80003286:	2601                	sext.w	a2,a2
    80003288:	8552                	mv	a0,s4
    8000328a:	ffffd097          	auipc	ra,0xffffd
    8000328e:	f4a080e7          	jalr	-182(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003292:	9cd2                	add	s9,s9,s4
    80003294:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003298:	bf9d                	j	8000320e <namex+0xb8>
  if(nameiparent){
    8000329a:	f20a83e3          	beqz	s5,800031c0 <namex+0x6a>
    iput(ip);
    8000329e:	854e                	mv	a0,s3
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	adc080e7          	jalr	-1316(ra) # 80002d7c <iput>
    return 0;
    800032a8:	4981                	li	s3,0
    800032aa:	bf19                	j	800031c0 <namex+0x6a>
  if(*path == 0)
    800032ac:	d7fd                	beqz	a5,8000329a <namex+0x144>
  while(*path != '/' && *path != 0)
    800032ae:	0004c783          	lbu	a5,0(s1)
    800032b2:	85a6                	mv	a1,s1
    800032b4:	b7d1                	j	80003278 <namex+0x122>

00000000800032b6 <dirlink>:
{
    800032b6:	7139                	addi	sp,sp,-64
    800032b8:	fc06                	sd	ra,56(sp)
    800032ba:	f822                	sd	s0,48(sp)
    800032bc:	f426                	sd	s1,40(sp)
    800032be:	f04a                	sd	s2,32(sp)
    800032c0:	ec4e                	sd	s3,24(sp)
    800032c2:	e852                	sd	s4,16(sp)
    800032c4:	0080                	addi	s0,sp,64
    800032c6:	892a                	mv	s2,a0
    800032c8:	8a2e                	mv	s4,a1
    800032ca:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032cc:	4601                	li	a2,0
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	dd8080e7          	jalr	-552(ra) # 800030a6 <dirlookup>
    800032d6:	e93d                	bnez	a0,8000334c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d8:	04c92483          	lw	s1,76(s2)
    800032dc:	c49d                	beqz	s1,8000330a <dirlink+0x54>
    800032de:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e0:	4741                	li	a4,16
    800032e2:	86a6                	mv	a3,s1
    800032e4:	fc040613          	addi	a2,s0,-64
    800032e8:	4581                	li	a1,0
    800032ea:	854a                	mv	a0,s2
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	b8a080e7          	jalr	-1142(ra) # 80002e76 <readi>
    800032f4:	47c1                	li	a5,16
    800032f6:	06f51163          	bne	a0,a5,80003358 <dirlink+0xa2>
    if(de.inum == 0)
    800032fa:	fc045783          	lhu	a5,-64(s0)
    800032fe:	c791                	beqz	a5,8000330a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003300:	24c1                	addiw	s1,s1,16
    80003302:	04c92783          	lw	a5,76(s2)
    80003306:	fcf4ede3          	bltu	s1,a5,800032e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000330a:	4639                	li	a2,14
    8000330c:	85d2                	mv	a1,s4
    8000330e:	fc240513          	addi	a0,s0,-62
    80003312:	ffffd097          	auipc	ra,0xffffd
    80003316:	f72080e7          	jalr	-142(ra) # 80000284 <strncpy>
  de.inum = inum;
    8000331a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331e:	4741                	li	a4,16
    80003320:	86a6                	mv	a3,s1
    80003322:	fc040613          	addi	a2,s0,-64
    80003326:	4581                	li	a1,0
    80003328:	854a                	mv	a0,s2
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	c44080e7          	jalr	-956(ra) # 80002f6e <writei>
    80003332:	872a                	mv	a4,a0
    80003334:	47c1                	li	a5,16
  return 0;
    80003336:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003338:	02f71863          	bne	a4,a5,80003368 <dirlink+0xb2>
}
    8000333c:	70e2                	ld	ra,56(sp)
    8000333e:	7442                	ld	s0,48(sp)
    80003340:	74a2                	ld	s1,40(sp)
    80003342:	7902                	ld	s2,32(sp)
    80003344:	69e2                	ld	s3,24(sp)
    80003346:	6a42                	ld	s4,16(sp)
    80003348:	6121                	addi	sp,sp,64
    8000334a:	8082                	ret
    iput(ip);
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	a30080e7          	jalr	-1488(ra) # 80002d7c <iput>
    return -1;
    80003354:	557d                	li	a0,-1
    80003356:	b7dd                	j	8000333c <dirlink+0x86>
      panic("dirlink read");
    80003358:	00005517          	auipc	a0,0x5
    8000335c:	24850513          	addi	a0,a0,584 # 800085a0 <syscalls+0x1d8>
    80003360:	00003097          	auipc	ra,0x3
    80003364:	962080e7          	jalr	-1694(ra) # 80005cc2 <panic>
    panic("dirlink");
    80003368:	00005517          	auipc	a0,0x5
    8000336c:	34850513          	addi	a0,a0,840 # 800086b0 <syscalls+0x2e8>
    80003370:	00003097          	auipc	ra,0x3
    80003374:	952080e7          	jalr	-1710(ra) # 80005cc2 <panic>

0000000080003378 <namei>:

struct inode*
namei(char *path)
{
    80003378:	1101                	addi	sp,sp,-32
    8000337a:	ec06                	sd	ra,24(sp)
    8000337c:	e822                	sd	s0,16(sp)
    8000337e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003380:	fe040613          	addi	a2,s0,-32
    80003384:	4581                	li	a1,0
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	dd0080e7          	jalr	-560(ra) # 80003156 <namex>
}
    8000338e:	60e2                	ld	ra,24(sp)
    80003390:	6442                	ld	s0,16(sp)
    80003392:	6105                	addi	sp,sp,32
    80003394:	8082                	ret

0000000080003396 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003396:	1141                	addi	sp,sp,-16
    80003398:	e406                	sd	ra,8(sp)
    8000339a:	e022                	sd	s0,0(sp)
    8000339c:	0800                	addi	s0,sp,16
    8000339e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033a0:	4585                	li	a1,1
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	db4080e7          	jalr	-588(ra) # 80003156 <namex>
}
    800033aa:	60a2                	ld	ra,8(sp)
    800033ac:	6402                	ld	s0,0(sp)
    800033ae:	0141                	addi	sp,sp,16
    800033b0:	8082                	ret

00000000800033b2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	e426                	sd	s1,8(sp)
    800033ba:	e04a                	sd	s2,0(sp)
    800033bc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033be:	00016917          	auipc	s2,0x16
    800033c2:	26290913          	addi	s2,s2,610 # 80019620 <log>
    800033c6:	01892583          	lw	a1,24(s2)
    800033ca:	02892503          	lw	a0,40(s2)
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	ff2080e7          	jalr	-14(ra) # 800023c0 <bread>
    800033d6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033d8:	02c92683          	lw	a3,44(s2)
    800033dc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033de:	02d05763          	blez	a3,8000340c <write_head+0x5a>
    800033e2:	00016797          	auipc	a5,0x16
    800033e6:	26e78793          	addi	a5,a5,622 # 80019650 <log+0x30>
    800033ea:	05c50713          	addi	a4,a0,92
    800033ee:	36fd                	addiw	a3,a3,-1
    800033f0:	1682                	slli	a3,a3,0x20
    800033f2:	9281                	srli	a3,a3,0x20
    800033f4:	068a                	slli	a3,a3,0x2
    800033f6:	00016617          	auipc	a2,0x16
    800033fa:	25e60613          	addi	a2,a2,606 # 80019654 <log+0x34>
    800033fe:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003400:	4390                	lw	a2,0(a5)
    80003402:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003404:	0791                	addi	a5,a5,4
    80003406:	0711                	addi	a4,a4,4
    80003408:	fed79ce3          	bne	a5,a3,80003400 <write_head+0x4e>
  }
  bwrite(buf);
    8000340c:	8526                	mv	a0,s1
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	0a4080e7          	jalr	164(ra) # 800024b2 <bwrite>
  brelse(buf);
    80003416:	8526                	mv	a0,s1
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	0d8080e7          	jalr	216(ra) # 800024f0 <brelse>
}
    80003420:	60e2                	ld	ra,24(sp)
    80003422:	6442                	ld	s0,16(sp)
    80003424:	64a2                	ld	s1,8(sp)
    80003426:	6902                	ld	s2,0(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342c:	00016797          	auipc	a5,0x16
    80003430:	2207a783          	lw	a5,544(a5) # 8001964c <log+0x2c>
    80003434:	0af05d63          	blez	a5,800034ee <install_trans+0xc2>
{
    80003438:	7139                	addi	sp,sp,-64
    8000343a:	fc06                	sd	ra,56(sp)
    8000343c:	f822                	sd	s0,48(sp)
    8000343e:	f426                	sd	s1,40(sp)
    80003440:	f04a                	sd	s2,32(sp)
    80003442:	ec4e                	sd	s3,24(sp)
    80003444:	e852                	sd	s4,16(sp)
    80003446:	e456                	sd	s5,8(sp)
    80003448:	e05a                	sd	s6,0(sp)
    8000344a:	0080                	addi	s0,sp,64
    8000344c:	8b2a                	mv	s6,a0
    8000344e:	00016a97          	auipc	s5,0x16
    80003452:	202a8a93          	addi	s5,s5,514 # 80019650 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003456:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003458:	00016997          	auipc	s3,0x16
    8000345c:	1c898993          	addi	s3,s3,456 # 80019620 <log>
    80003460:	a00d                	j	80003482 <install_trans+0x56>
    brelse(lbuf);
    80003462:	854a                	mv	a0,s2
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	08c080e7          	jalr	140(ra) # 800024f0 <brelse>
    brelse(dbuf);
    8000346c:	8526                	mv	a0,s1
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	082080e7          	jalr	130(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	2a05                	addiw	s4,s4,1
    80003478:	0a91                	addi	s5,s5,4
    8000347a:	02c9a783          	lw	a5,44(s3)
    8000347e:	04fa5e63          	bge	s4,a5,800034da <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003482:	0189a583          	lw	a1,24(s3)
    80003486:	014585bb          	addw	a1,a1,s4
    8000348a:	2585                	addiw	a1,a1,1
    8000348c:	0289a503          	lw	a0,40(s3)
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	f30080e7          	jalr	-208(ra) # 800023c0 <bread>
    80003498:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000349a:	000aa583          	lw	a1,0(s5)
    8000349e:	0289a503          	lw	a0,40(s3)
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	f1e080e7          	jalr	-226(ra) # 800023c0 <bread>
    800034aa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ac:	40000613          	li	a2,1024
    800034b0:	05890593          	addi	a1,s2,88
    800034b4:	05850513          	addi	a0,a0,88
    800034b8:	ffffd097          	auipc	ra,0xffffd
    800034bc:	d1c080e7          	jalr	-740(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c0:	8526                	mv	a0,s1
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	ff0080e7          	jalr	-16(ra) # 800024b2 <bwrite>
    if(recovering == 0)
    800034ca:	f80b1ce3          	bnez	s6,80003462 <install_trans+0x36>
      bunpin(dbuf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	0fa080e7          	jalr	250(ra) # 800025ca <bunpin>
    800034d8:	b769                	j	80003462 <install_trans+0x36>
}
    800034da:	70e2                	ld	ra,56(sp)
    800034dc:	7442                	ld	s0,48(sp)
    800034de:	74a2                	ld	s1,40(sp)
    800034e0:	7902                	ld	s2,32(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	6a42                	ld	s4,16(sp)
    800034e6:	6aa2                	ld	s5,8(sp)
    800034e8:	6b02                	ld	s6,0(sp)
    800034ea:	6121                	addi	sp,sp,64
    800034ec:	8082                	ret
    800034ee:	8082                	ret

00000000800034f0 <initlog>:
{
    800034f0:	7179                	addi	sp,sp,-48
    800034f2:	f406                	sd	ra,40(sp)
    800034f4:	f022                	sd	s0,32(sp)
    800034f6:	ec26                	sd	s1,24(sp)
    800034f8:	e84a                	sd	s2,16(sp)
    800034fa:	e44e                	sd	s3,8(sp)
    800034fc:	1800                	addi	s0,sp,48
    800034fe:	892a                	mv	s2,a0
    80003500:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003502:	00016497          	auipc	s1,0x16
    80003506:	11e48493          	addi	s1,s1,286 # 80019620 <log>
    8000350a:	00005597          	auipc	a1,0x5
    8000350e:	0a658593          	addi	a1,a1,166 # 800085b0 <syscalls+0x1e8>
    80003512:	8526                	mv	a0,s1
    80003514:	00003097          	auipc	ra,0x3
    80003518:	c30080e7          	jalr	-976(ra) # 80006144 <initlock>
  log.start = sb->logstart;
    8000351c:	0149a583          	lw	a1,20(s3)
    80003520:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003522:	0109a783          	lw	a5,16(s3)
    80003526:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003528:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000352c:	854a                	mv	a0,s2
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	e92080e7          	jalr	-366(ra) # 800023c0 <bread>
  log.lh.n = lh->n;
    80003536:	4d34                	lw	a3,88(a0)
    80003538:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000353a:	02d05563          	blez	a3,80003564 <initlog+0x74>
    8000353e:	05c50793          	addi	a5,a0,92
    80003542:	00016717          	auipc	a4,0x16
    80003546:	10e70713          	addi	a4,a4,270 # 80019650 <log+0x30>
    8000354a:	36fd                	addiw	a3,a3,-1
    8000354c:	1682                	slli	a3,a3,0x20
    8000354e:	9281                	srli	a3,a3,0x20
    80003550:	068a                	slli	a3,a3,0x2
    80003552:	06050613          	addi	a2,a0,96
    80003556:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003558:	4390                	lw	a2,0(a5)
    8000355a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	0791                	addi	a5,a5,4
    8000355e:	0711                	addi	a4,a4,4
    80003560:	fed79ce3          	bne	a5,a3,80003558 <initlog+0x68>
  brelse(buf);
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	f8c080e7          	jalr	-116(ra) # 800024f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000356c:	4505                	li	a0,1
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	ebe080e7          	jalr	-322(ra) # 8000342c <install_trans>
  log.lh.n = 0;
    80003576:	00016797          	auipc	a5,0x16
    8000357a:	0c07ab23          	sw	zero,214(a5) # 8001964c <log+0x2c>
  write_head(); // clear the log
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	e34080e7          	jalr	-460(ra) # 800033b2 <write_head>
}
    80003586:	70a2                	ld	ra,40(sp)
    80003588:	7402                	ld	s0,32(sp)
    8000358a:	64e2                	ld	s1,24(sp)
    8000358c:	6942                	ld	s2,16(sp)
    8000358e:	69a2                	ld	s3,8(sp)
    80003590:	6145                	addi	sp,sp,48
    80003592:	8082                	ret

0000000080003594 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003594:	1101                	addi	sp,sp,-32
    80003596:	ec06                	sd	ra,24(sp)
    80003598:	e822                	sd	s0,16(sp)
    8000359a:	e426                	sd	s1,8(sp)
    8000359c:	e04a                	sd	s2,0(sp)
    8000359e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a0:	00016517          	auipc	a0,0x16
    800035a4:	08050513          	addi	a0,a0,128 # 80019620 <log>
    800035a8:	00003097          	auipc	ra,0x3
    800035ac:	c2c080e7          	jalr	-980(ra) # 800061d4 <acquire>
  while(1){
    if(log.committing){
    800035b0:	00016497          	auipc	s1,0x16
    800035b4:	07048493          	addi	s1,s1,112 # 80019620 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b8:	4979                	li	s2,30
    800035ba:	a039                	j	800035c8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035bc:	85a6                	mv	a1,s1
    800035be:	8526                	mv	a0,s1
    800035c0:	ffffe097          	auipc	ra,0xffffe
    800035c4:	f98080e7          	jalr	-104(ra) # 80001558 <sleep>
    if(log.committing){
    800035c8:	50dc                	lw	a5,36(s1)
    800035ca:	fbed                	bnez	a5,800035bc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035cc:	509c                	lw	a5,32(s1)
    800035ce:	0017871b          	addiw	a4,a5,1
    800035d2:	0007069b          	sext.w	a3,a4
    800035d6:	0027179b          	slliw	a5,a4,0x2
    800035da:	9fb9                	addw	a5,a5,a4
    800035dc:	0017979b          	slliw	a5,a5,0x1
    800035e0:	54d8                	lw	a4,44(s1)
    800035e2:	9fb9                	addw	a5,a5,a4
    800035e4:	00f95963          	bge	s2,a5,800035f6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e8:	85a6                	mv	a1,s1
    800035ea:	8526                	mv	a0,s1
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	f6c080e7          	jalr	-148(ra) # 80001558 <sleep>
    800035f4:	bfd1                	j	800035c8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035f6:	00016517          	auipc	a0,0x16
    800035fa:	02a50513          	addi	a0,a0,42 # 80019620 <log>
    800035fe:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003600:	00003097          	auipc	ra,0x3
    80003604:	c88080e7          	jalr	-888(ra) # 80006288 <release>
      break;
    }
  }
}
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6902                	ld	s2,0(sp)
    80003610:	6105                	addi	sp,sp,32
    80003612:	8082                	ret

0000000080003614 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003614:	7139                	addi	sp,sp,-64
    80003616:	fc06                	sd	ra,56(sp)
    80003618:	f822                	sd	s0,48(sp)
    8000361a:	f426                	sd	s1,40(sp)
    8000361c:	f04a                	sd	s2,32(sp)
    8000361e:	ec4e                	sd	s3,24(sp)
    80003620:	e852                	sd	s4,16(sp)
    80003622:	e456                	sd	s5,8(sp)
    80003624:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003626:	00016497          	auipc	s1,0x16
    8000362a:	ffa48493          	addi	s1,s1,-6 # 80019620 <log>
    8000362e:	8526                	mv	a0,s1
    80003630:	00003097          	auipc	ra,0x3
    80003634:	ba4080e7          	jalr	-1116(ra) # 800061d4 <acquire>
  log.outstanding -= 1;
    80003638:	509c                	lw	a5,32(s1)
    8000363a:	37fd                	addiw	a5,a5,-1
    8000363c:	0007891b          	sext.w	s2,a5
    80003640:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003642:	50dc                	lw	a5,36(s1)
    80003644:	e7b9                	bnez	a5,80003692 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003646:	04091e63          	bnez	s2,800036a2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000364a:	00016497          	auipc	s1,0x16
    8000364e:	fd648493          	addi	s1,s1,-42 # 80019620 <log>
    80003652:	4785                	li	a5,1
    80003654:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003656:	8526                	mv	a0,s1
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	c30080e7          	jalr	-976(ra) # 80006288 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003660:	54dc                	lw	a5,44(s1)
    80003662:	06f04763          	bgtz	a5,800036d0 <end_op+0xbc>
    acquire(&log.lock);
    80003666:	00016497          	auipc	s1,0x16
    8000366a:	fba48493          	addi	s1,s1,-70 # 80019620 <log>
    8000366e:	8526                	mv	a0,s1
    80003670:	00003097          	auipc	ra,0x3
    80003674:	b64080e7          	jalr	-1180(ra) # 800061d4 <acquire>
    log.committing = 0;
    80003678:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000367c:	8526                	mv	a0,s1
    8000367e:	ffffe097          	auipc	ra,0xffffe
    80003682:	066080e7          	jalr	102(ra) # 800016e4 <wakeup>
    release(&log.lock);
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	c00080e7          	jalr	-1024(ra) # 80006288 <release>
}
    80003690:	a03d                	j	800036be <end_op+0xaa>
    panic("log.committing");
    80003692:	00005517          	auipc	a0,0x5
    80003696:	f2650513          	addi	a0,a0,-218 # 800085b8 <syscalls+0x1f0>
    8000369a:	00002097          	auipc	ra,0x2
    8000369e:	628080e7          	jalr	1576(ra) # 80005cc2 <panic>
    wakeup(&log);
    800036a2:	00016497          	auipc	s1,0x16
    800036a6:	f7e48493          	addi	s1,s1,-130 # 80019620 <log>
    800036aa:	8526                	mv	a0,s1
    800036ac:	ffffe097          	auipc	ra,0xffffe
    800036b0:	038080e7          	jalr	56(ra) # 800016e4 <wakeup>
  release(&log.lock);
    800036b4:	8526                	mv	a0,s1
    800036b6:	00003097          	auipc	ra,0x3
    800036ba:	bd2080e7          	jalr	-1070(ra) # 80006288 <release>
}
    800036be:	70e2                	ld	ra,56(sp)
    800036c0:	7442                	ld	s0,48(sp)
    800036c2:	74a2                	ld	s1,40(sp)
    800036c4:	7902                	ld	s2,32(sp)
    800036c6:	69e2                	ld	s3,24(sp)
    800036c8:	6a42                	ld	s4,16(sp)
    800036ca:	6aa2                	ld	s5,8(sp)
    800036cc:	6121                	addi	sp,sp,64
    800036ce:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d0:	00016a97          	auipc	s5,0x16
    800036d4:	f80a8a93          	addi	s5,s5,-128 # 80019650 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d8:	00016a17          	auipc	s4,0x16
    800036dc:	f48a0a13          	addi	s4,s4,-184 # 80019620 <log>
    800036e0:	018a2583          	lw	a1,24(s4)
    800036e4:	012585bb          	addw	a1,a1,s2
    800036e8:	2585                	addiw	a1,a1,1
    800036ea:	028a2503          	lw	a0,40(s4)
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	cd2080e7          	jalr	-814(ra) # 800023c0 <bread>
    800036f6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f8:	000aa583          	lw	a1,0(s5)
    800036fc:	028a2503          	lw	a0,40(s4)
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	cc0080e7          	jalr	-832(ra) # 800023c0 <bread>
    80003708:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000370a:	40000613          	li	a2,1024
    8000370e:	05850593          	addi	a1,a0,88
    80003712:	05848513          	addi	a0,s1,88
    80003716:	ffffd097          	auipc	ra,0xffffd
    8000371a:	abe080e7          	jalr	-1346(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    8000371e:	8526                	mv	a0,s1
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	d92080e7          	jalr	-622(ra) # 800024b2 <bwrite>
    brelse(from);
    80003728:	854e                	mv	a0,s3
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	dc6080e7          	jalr	-570(ra) # 800024f0 <brelse>
    brelse(to);
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	dbc080e7          	jalr	-580(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000373c:	2905                	addiw	s2,s2,1
    8000373e:	0a91                	addi	s5,s5,4
    80003740:	02ca2783          	lw	a5,44(s4)
    80003744:	f8f94ee3          	blt	s2,a5,800036e0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	c6a080e7          	jalr	-918(ra) # 800033b2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003750:	4501                	li	a0,0
    80003752:	00000097          	auipc	ra,0x0
    80003756:	cda080e7          	jalr	-806(ra) # 8000342c <install_trans>
    log.lh.n = 0;
    8000375a:	00016797          	auipc	a5,0x16
    8000375e:	ee07a923          	sw	zero,-270(a5) # 8001964c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003762:	00000097          	auipc	ra,0x0
    80003766:	c50080e7          	jalr	-944(ra) # 800033b2 <write_head>
    8000376a:	bdf5                	j	80003666 <end_op+0x52>

000000008000376c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000376c:	1101                	addi	sp,sp,-32
    8000376e:	ec06                	sd	ra,24(sp)
    80003770:	e822                	sd	s0,16(sp)
    80003772:	e426                	sd	s1,8(sp)
    80003774:	e04a                	sd	s2,0(sp)
    80003776:	1000                	addi	s0,sp,32
    80003778:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000377a:	00016917          	auipc	s2,0x16
    8000377e:	ea690913          	addi	s2,s2,-346 # 80019620 <log>
    80003782:	854a                	mv	a0,s2
    80003784:	00003097          	auipc	ra,0x3
    80003788:	a50080e7          	jalr	-1456(ra) # 800061d4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000378c:	02c92603          	lw	a2,44(s2)
    80003790:	47f5                	li	a5,29
    80003792:	06c7c563          	blt	a5,a2,800037fc <log_write+0x90>
    80003796:	00016797          	auipc	a5,0x16
    8000379a:	ea67a783          	lw	a5,-346(a5) # 8001963c <log+0x1c>
    8000379e:	37fd                	addiw	a5,a5,-1
    800037a0:	04f65e63          	bge	a2,a5,800037fc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a4:	00016797          	auipc	a5,0x16
    800037a8:	e9c7a783          	lw	a5,-356(a5) # 80019640 <log+0x20>
    800037ac:	06f05063          	blez	a5,8000380c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b0:	4781                	li	a5,0
    800037b2:	06c05563          	blez	a2,8000381c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b6:	44cc                	lw	a1,12(s1)
    800037b8:	00016717          	auipc	a4,0x16
    800037bc:	e9870713          	addi	a4,a4,-360 # 80019650 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c2:	4314                	lw	a3,0(a4)
    800037c4:	04b68c63          	beq	a3,a1,8000381c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c8:	2785                	addiw	a5,a5,1
    800037ca:	0711                	addi	a4,a4,4
    800037cc:	fef61be3          	bne	a2,a5,800037c2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d0:	0621                	addi	a2,a2,8
    800037d2:	060a                	slli	a2,a2,0x2
    800037d4:	00016797          	auipc	a5,0x16
    800037d8:	e4c78793          	addi	a5,a5,-436 # 80019620 <log>
    800037dc:	963e                	add	a2,a2,a5
    800037de:	44dc                	lw	a5,12(s1)
    800037e0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037e2:	8526                	mv	a0,s1
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	daa080e7          	jalr	-598(ra) # 8000258e <bpin>
    log.lh.n++;
    800037ec:	00016717          	auipc	a4,0x16
    800037f0:	e3470713          	addi	a4,a4,-460 # 80019620 <log>
    800037f4:	575c                	lw	a5,44(a4)
    800037f6:	2785                	addiw	a5,a5,1
    800037f8:	d75c                	sw	a5,44(a4)
    800037fa:	a835                	j	80003836 <log_write+0xca>
    panic("too big a transaction");
    800037fc:	00005517          	auipc	a0,0x5
    80003800:	dcc50513          	addi	a0,a0,-564 # 800085c8 <syscalls+0x200>
    80003804:	00002097          	auipc	ra,0x2
    80003808:	4be080e7          	jalr	1214(ra) # 80005cc2 <panic>
    panic("log_write outside of trans");
    8000380c:	00005517          	auipc	a0,0x5
    80003810:	dd450513          	addi	a0,a0,-556 # 800085e0 <syscalls+0x218>
    80003814:	00002097          	auipc	ra,0x2
    80003818:	4ae080e7          	jalr	1198(ra) # 80005cc2 <panic>
  log.lh.block[i] = b->blockno;
    8000381c:	00878713          	addi	a4,a5,8
    80003820:	00271693          	slli	a3,a4,0x2
    80003824:	00016717          	auipc	a4,0x16
    80003828:	dfc70713          	addi	a4,a4,-516 # 80019620 <log>
    8000382c:	9736                	add	a4,a4,a3
    8000382e:	44d4                	lw	a3,12(s1)
    80003830:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003832:	faf608e3          	beq	a2,a5,800037e2 <log_write+0x76>
  }
  release(&log.lock);
    80003836:	00016517          	auipc	a0,0x16
    8000383a:	dea50513          	addi	a0,a0,-534 # 80019620 <log>
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	a4a080e7          	jalr	-1462(ra) # 80006288 <release>
}
    80003846:	60e2                	ld	ra,24(sp)
    80003848:	6442                	ld	s0,16(sp)
    8000384a:	64a2                	ld	s1,8(sp)
    8000384c:	6902                	ld	s2,0(sp)
    8000384e:	6105                	addi	sp,sp,32
    80003850:	8082                	ret

0000000080003852 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003852:	1101                	addi	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	e04a                	sd	s2,0(sp)
    8000385c:	1000                	addi	s0,sp,32
    8000385e:	84aa                	mv	s1,a0
    80003860:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003862:	00005597          	auipc	a1,0x5
    80003866:	d9e58593          	addi	a1,a1,-610 # 80008600 <syscalls+0x238>
    8000386a:	0521                	addi	a0,a0,8
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	8d8080e7          	jalr	-1832(ra) # 80006144 <initlock>
  lk->name = name;
    80003874:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003878:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387c:	0204a423          	sw	zero,40(s1)
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389a:	00850913          	addi	s2,a0,8
    8000389e:	854a                	mv	a0,s2
    800038a0:	00003097          	auipc	ra,0x3
    800038a4:	934080e7          	jalr	-1740(ra) # 800061d4 <acquire>
  while (lk->locked) {
    800038a8:	409c                	lw	a5,0(s1)
    800038aa:	cb89                	beqz	a5,800038bc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ac:	85ca                	mv	a1,s2
    800038ae:	8526                	mv	a0,s1
    800038b0:	ffffe097          	auipc	ra,0xffffe
    800038b4:	ca8080e7          	jalr	-856(ra) # 80001558 <sleep>
  while (lk->locked) {
    800038b8:	409c                	lw	a5,0(s1)
    800038ba:	fbed                	bnez	a5,800038ac <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038bc:	4785                	li	a5,1
    800038be:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	582080e7          	jalr	1410(ra) # 80000e42 <myproc>
    800038c8:	591c                	lw	a5,48(a0)
    800038ca:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038cc:	854a                	mv	a0,s2
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	9ba080e7          	jalr	-1606(ra) # 80006288 <release>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    800038ec:	1000                	addi	s0,sp,32
    800038ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f0:	00850913          	addi	s2,a0,8
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	8de080e7          	jalr	-1826(ra) # 800061d4 <acquire>
  lk->locked = 0;
    800038fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003902:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003906:	8526                	mv	a0,s1
    80003908:	ffffe097          	auipc	ra,0xffffe
    8000390c:	ddc080e7          	jalr	-548(ra) # 800016e4 <wakeup>
  release(&lk->lk);
    80003910:	854a                	mv	a0,s2
    80003912:	00003097          	auipc	ra,0x3
    80003916:	976080e7          	jalr	-1674(ra) # 80006288 <release>
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003926:	7179                	addi	sp,sp,-48
    80003928:	f406                	sd	ra,40(sp)
    8000392a:	f022                	sd	s0,32(sp)
    8000392c:	ec26                	sd	s1,24(sp)
    8000392e:	e84a                	sd	s2,16(sp)
    80003930:	e44e                	sd	s3,8(sp)
    80003932:	1800                	addi	s0,sp,48
    80003934:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003936:	00850913          	addi	s2,a0,8
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	898080e7          	jalr	-1896(ra) # 800061d4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003944:	409c                	lw	a5,0(s1)
    80003946:	ef99                	bnez	a5,80003964 <holdingsleep+0x3e>
    80003948:	4481                	li	s1,0
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	93c080e7          	jalr	-1732(ra) # 80006288 <release>
  return r;
}
    80003954:	8526                	mv	a0,s1
    80003956:	70a2                	ld	ra,40(sp)
    80003958:	7402                	ld	s0,32(sp)
    8000395a:	64e2                	ld	s1,24(sp)
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	69a2                	ld	s3,8(sp)
    80003960:	6145                	addi	sp,sp,48
    80003962:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003964:	0284a983          	lw	s3,40(s1)
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	4da080e7          	jalr	1242(ra) # 80000e42 <myproc>
    80003970:	5904                	lw	s1,48(a0)
    80003972:	413484b3          	sub	s1,s1,s3
    80003976:	0014b493          	seqz	s1,s1
    8000397a:	bfc1                	j	8000394a <holdingsleep+0x24>

000000008000397c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000397c:	1141                	addi	sp,sp,-16
    8000397e:	e406                	sd	ra,8(sp)
    80003980:	e022                	sd	s0,0(sp)
    80003982:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003984:	00005597          	auipc	a1,0x5
    80003988:	c8c58593          	addi	a1,a1,-884 # 80008610 <syscalls+0x248>
    8000398c:	00016517          	auipc	a0,0x16
    80003990:	ddc50513          	addi	a0,a0,-548 # 80019768 <ftable>
    80003994:	00002097          	auipc	ra,0x2
    80003998:	7b0080e7          	jalr	1968(ra) # 80006144 <initlock>
}
    8000399c:	60a2                	ld	ra,8(sp)
    8000399e:	6402                	ld	s0,0(sp)
    800039a0:	0141                	addi	sp,sp,16
    800039a2:	8082                	ret

00000000800039a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039ae:	00016517          	auipc	a0,0x16
    800039b2:	dba50513          	addi	a0,a0,-582 # 80019768 <ftable>
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	81e080e7          	jalr	-2018(ra) # 800061d4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039be:	00016497          	auipc	s1,0x16
    800039c2:	dc248493          	addi	s1,s1,-574 # 80019780 <ftable+0x18>
    800039c6:	00017717          	auipc	a4,0x17
    800039ca:	d5a70713          	addi	a4,a4,-678 # 8001a720 <ftable+0xfb8>
    if(f->ref == 0){
    800039ce:	40dc                	lw	a5,4(s1)
    800039d0:	cf99                	beqz	a5,800039ee <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d2:	02848493          	addi	s1,s1,40
    800039d6:	fee49ce3          	bne	s1,a4,800039ce <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039da:	00016517          	auipc	a0,0x16
    800039de:	d8e50513          	addi	a0,a0,-626 # 80019768 <ftable>
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	8a6080e7          	jalr	-1882(ra) # 80006288 <release>
  return 0;
    800039ea:	4481                	li	s1,0
    800039ec:	a819                	j	80003a02 <filealloc+0x5e>
      f->ref = 1;
    800039ee:	4785                	li	a5,1
    800039f0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f2:	00016517          	auipc	a0,0x16
    800039f6:	d7650513          	addi	a0,a0,-650 # 80019768 <ftable>
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	88e080e7          	jalr	-1906(ra) # 80006288 <release>
}
    80003a02:	8526                	mv	a0,s1
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	1000                	addi	s0,sp,32
    80003a18:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a1a:	00016517          	auipc	a0,0x16
    80003a1e:	d4e50513          	addi	a0,a0,-690 # 80019768 <ftable>
    80003a22:	00002097          	auipc	ra,0x2
    80003a26:	7b2080e7          	jalr	1970(ra) # 800061d4 <acquire>
  if(f->ref < 1)
    80003a2a:	40dc                	lw	a5,4(s1)
    80003a2c:	02f05263          	blez	a5,80003a50 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a30:	2785                	addiw	a5,a5,1
    80003a32:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a34:	00016517          	auipc	a0,0x16
    80003a38:	d3450513          	addi	a0,a0,-716 # 80019768 <ftable>
    80003a3c:	00003097          	auipc	ra,0x3
    80003a40:	84c080e7          	jalr	-1972(ra) # 80006288 <release>
  return f;
}
    80003a44:	8526                	mv	a0,s1
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6105                	addi	sp,sp,32
    80003a4e:	8082                	ret
    panic("filedup");
    80003a50:	00005517          	auipc	a0,0x5
    80003a54:	bc850513          	addi	a0,a0,-1080 # 80008618 <syscalls+0x250>
    80003a58:	00002097          	auipc	ra,0x2
    80003a5c:	26a080e7          	jalr	618(ra) # 80005cc2 <panic>

0000000080003a60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a60:	7139                	addi	sp,sp,-64
    80003a62:	fc06                	sd	ra,56(sp)
    80003a64:	f822                	sd	s0,48(sp)
    80003a66:	f426                	sd	s1,40(sp)
    80003a68:	f04a                	sd	s2,32(sp)
    80003a6a:	ec4e                	sd	s3,24(sp)
    80003a6c:	e852                	sd	s4,16(sp)
    80003a6e:	e456                	sd	s5,8(sp)
    80003a70:	0080                	addi	s0,sp,64
    80003a72:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a74:	00016517          	auipc	a0,0x16
    80003a78:	cf450513          	addi	a0,a0,-780 # 80019768 <ftable>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	758080e7          	jalr	1880(ra) # 800061d4 <acquire>
  if(f->ref < 1)
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	06f05163          	blez	a5,80003ae8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a8a:	37fd                	addiw	a5,a5,-1
    80003a8c:	0007871b          	sext.w	a4,a5
    80003a90:	c0dc                	sw	a5,4(s1)
    80003a92:	06e04363          	bgtz	a4,80003af8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a96:	0004a903          	lw	s2,0(s1)
    80003a9a:	0094ca83          	lbu	s5,9(s1)
    80003a9e:	0104ba03          	ld	s4,16(s1)
    80003aa2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aaa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aae:	00016517          	auipc	a0,0x16
    80003ab2:	cba50513          	addi	a0,a0,-838 # 80019768 <ftable>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	7d2080e7          	jalr	2002(ra) # 80006288 <release>

  if(ff.type == FD_PIPE){
    80003abe:	4785                	li	a5,1
    80003ac0:	04f90d63          	beq	s2,a5,80003b1a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ac4:	3979                	addiw	s2,s2,-2
    80003ac6:	4785                	li	a5,1
    80003ac8:	0527e063          	bltu	a5,s2,80003b08 <fileclose+0xa8>
    begin_op();
    80003acc:	00000097          	auipc	ra,0x0
    80003ad0:	ac8080e7          	jalr	-1336(ra) # 80003594 <begin_op>
    iput(ff.ip);
    80003ad4:	854e                	mv	a0,s3
    80003ad6:	fffff097          	auipc	ra,0xfffff
    80003ada:	2a6080e7          	jalr	678(ra) # 80002d7c <iput>
    end_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	b36080e7          	jalr	-1226(ra) # 80003614 <end_op>
    80003ae6:	a00d                	j	80003b08 <fileclose+0xa8>
    panic("fileclose");
    80003ae8:	00005517          	auipc	a0,0x5
    80003aec:	b3850513          	addi	a0,a0,-1224 # 80008620 <syscalls+0x258>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	1d2080e7          	jalr	466(ra) # 80005cc2 <panic>
    release(&ftable.lock);
    80003af8:	00016517          	auipc	a0,0x16
    80003afc:	c7050513          	addi	a0,a0,-912 # 80019768 <ftable>
    80003b00:	00002097          	auipc	ra,0x2
    80003b04:	788080e7          	jalr	1928(ra) # 80006288 <release>
  }
}
    80003b08:	70e2                	ld	ra,56(sp)
    80003b0a:	7442                	ld	s0,48(sp)
    80003b0c:	74a2                	ld	s1,40(sp)
    80003b0e:	7902                	ld	s2,32(sp)
    80003b10:	69e2                	ld	s3,24(sp)
    80003b12:	6a42                	ld	s4,16(sp)
    80003b14:	6aa2                	ld	s5,8(sp)
    80003b16:	6121                	addi	sp,sp,64
    80003b18:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b1a:	85d6                	mv	a1,s5
    80003b1c:	8552                	mv	a0,s4
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	34c080e7          	jalr	844(ra) # 80003e6a <pipeclose>
    80003b26:	b7cd                	j	80003b08 <fileclose+0xa8>

0000000080003b28 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b28:	715d                	addi	sp,sp,-80
    80003b2a:	e486                	sd	ra,72(sp)
    80003b2c:	e0a2                	sd	s0,64(sp)
    80003b2e:	fc26                	sd	s1,56(sp)
    80003b30:	f84a                	sd	s2,48(sp)
    80003b32:	f44e                	sd	s3,40(sp)
    80003b34:	0880                	addi	s0,sp,80
    80003b36:	84aa                	mv	s1,a0
    80003b38:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	308080e7          	jalr	776(ra) # 80000e42 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b42:	409c                	lw	a5,0(s1)
    80003b44:	37f9                	addiw	a5,a5,-2
    80003b46:	4705                	li	a4,1
    80003b48:	04f76763          	bltu	a4,a5,80003b96 <filestat+0x6e>
    80003b4c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b4e:	6c88                	ld	a0,24(s1)
    80003b50:	fffff097          	auipc	ra,0xfffff
    80003b54:	072080e7          	jalr	114(ra) # 80002bc2 <ilock>
    stati(f->ip, &st);
    80003b58:	fb840593          	addi	a1,s0,-72
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	2ee080e7          	jalr	750(ra) # 80002e4c <stati>
    iunlock(f->ip);
    80003b66:	6c88                	ld	a0,24(s1)
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	11c080e7          	jalr	284(ra) # 80002c84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b70:	46e1                	li	a3,24
    80003b72:	fb840613          	addi	a2,s0,-72
    80003b76:	85ce                	mv	a1,s3
    80003b78:	05093503          	ld	a0,80(s2)
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	f86080e7          	jalr	-122(ra) # 80000b02 <copyout>
    80003b84:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b88:	60a6                	ld	ra,72(sp)
    80003b8a:	6406                	ld	s0,64(sp)
    80003b8c:	74e2                	ld	s1,56(sp)
    80003b8e:	7942                	ld	s2,48(sp)
    80003b90:	79a2                	ld	s3,40(sp)
    80003b92:	6161                	addi	sp,sp,80
    80003b94:	8082                	ret
  return -1;
    80003b96:	557d                	li	a0,-1
    80003b98:	bfc5                	j	80003b88 <filestat+0x60>

0000000080003b9a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b9a:	7179                	addi	sp,sp,-48
    80003b9c:	f406                	sd	ra,40(sp)
    80003b9e:	f022                	sd	s0,32(sp)
    80003ba0:	ec26                	sd	s1,24(sp)
    80003ba2:	e84a                	sd	s2,16(sp)
    80003ba4:	e44e                	sd	s3,8(sp)
    80003ba6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ba8:	00854783          	lbu	a5,8(a0)
    80003bac:	c3d5                	beqz	a5,80003c50 <fileread+0xb6>
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	89ae                	mv	s3,a1
    80003bb2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bb4:	411c                	lw	a5,0(a0)
    80003bb6:	4705                	li	a4,1
    80003bb8:	04e78963          	beq	a5,a4,80003c0a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bbc:	470d                	li	a4,3
    80003bbe:	04e78d63          	beq	a5,a4,80003c18 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc2:	4709                	li	a4,2
    80003bc4:	06e79e63          	bne	a5,a4,80003c40 <fileread+0xa6>
    ilock(f->ip);
    80003bc8:	6d08                	ld	a0,24(a0)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	ff8080e7          	jalr	-8(ra) # 80002bc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bd2:	874a                	mv	a4,s2
    80003bd4:	5094                	lw	a3,32(s1)
    80003bd6:	864e                	mv	a2,s3
    80003bd8:	4585                	li	a1,1
    80003bda:	6c88                	ld	a0,24(s1)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	29a080e7          	jalr	666(ra) # 80002e76 <readi>
    80003be4:	892a                	mv	s2,a0
    80003be6:	00a05563          	blez	a0,80003bf0 <fileread+0x56>
      f->off += r;
    80003bea:	509c                	lw	a5,32(s1)
    80003bec:	9fa9                	addw	a5,a5,a0
    80003bee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	092080e7          	jalr	146(ra) # 80002c84 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bfa:	854a                	mv	a0,s2
    80003bfc:	70a2                	ld	ra,40(sp)
    80003bfe:	7402                	ld	s0,32(sp)
    80003c00:	64e2                	ld	s1,24(sp)
    80003c02:	6942                	ld	s2,16(sp)
    80003c04:	69a2                	ld	s3,8(sp)
    80003c06:	6145                	addi	sp,sp,48
    80003c08:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c0a:	6908                	ld	a0,16(a0)
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	3c0080e7          	jalr	960(ra) # 80003fcc <piperead>
    80003c14:	892a                	mv	s2,a0
    80003c16:	b7d5                	j	80003bfa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c18:	02451783          	lh	a5,36(a0)
    80003c1c:	03079693          	slli	a3,a5,0x30
    80003c20:	92c1                	srli	a3,a3,0x30
    80003c22:	4725                	li	a4,9
    80003c24:	02d76863          	bltu	a4,a3,80003c54 <fileread+0xba>
    80003c28:	0792                	slli	a5,a5,0x4
    80003c2a:	00016717          	auipc	a4,0x16
    80003c2e:	a9e70713          	addi	a4,a4,-1378 # 800196c8 <devsw>
    80003c32:	97ba                	add	a5,a5,a4
    80003c34:	639c                	ld	a5,0(a5)
    80003c36:	c38d                	beqz	a5,80003c58 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c38:	4505                	li	a0,1
    80003c3a:	9782                	jalr	a5
    80003c3c:	892a                	mv	s2,a0
    80003c3e:	bf75                	j	80003bfa <fileread+0x60>
    panic("fileread");
    80003c40:	00005517          	auipc	a0,0x5
    80003c44:	9f050513          	addi	a0,a0,-1552 # 80008630 <syscalls+0x268>
    80003c48:	00002097          	auipc	ra,0x2
    80003c4c:	07a080e7          	jalr	122(ra) # 80005cc2 <panic>
    return -1;
    80003c50:	597d                	li	s2,-1
    80003c52:	b765                	j	80003bfa <fileread+0x60>
      return -1;
    80003c54:	597d                	li	s2,-1
    80003c56:	b755                	j	80003bfa <fileread+0x60>
    80003c58:	597d                	li	s2,-1
    80003c5a:	b745                	j	80003bfa <fileread+0x60>

0000000080003c5c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c5c:	715d                	addi	sp,sp,-80
    80003c5e:	e486                	sd	ra,72(sp)
    80003c60:	e0a2                	sd	s0,64(sp)
    80003c62:	fc26                	sd	s1,56(sp)
    80003c64:	f84a                	sd	s2,48(sp)
    80003c66:	f44e                	sd	s3,40(sp)
    80003c68:	f052                	sd	s4,32(sp)
    80003c6a:	ec56                	sd	s5,24(sp)
    80003c6c:	e85a                	sd	s6,16(sp)
    80003c6e:	e45e                	sd	s7,8(sp)
    80003c70:	e062                	sd	s8,0(sp)
    80003c72:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c74:	00954783          	lbu	a5,9(a0)
    80003c78:	10078663          	beqz	a5,80003d84 <filewrite+0x128>
    80003c7c:	892a                	mv	s2,a0
    80003c7e:	8aae                	mv	s5,a1
    80003c80:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c82:	411c                	lw	a5,0(a0)
    80003c84:	4705                	li	a4,1
    80003c86:	02e78263          	beq	a5,a4,80003caa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c8a:	470d                	li	a4,3
    80003c8c:	02e78663          	beq	a5,a4,80003cb8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c90:	4709                	li	a4,2
    80003c92:	0ee79163          	bne	a5,a4,80003d74 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c96:	0ac05d63          	blez	a2,80003d50 <filewrite+0xf4>
    int i = 0;
    80003c9a:	4981                	li	s3,0
    80003c9c:	6b05                	lui	s6,0x1
    80003c9e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ca2:	6b85                	lui	s7,0x1
    80003ca4:	c00b8b9b          	addiw	s7,s7,-1024
    80003ca8:	a861                	j	80003d40 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003caa:	6908                	ld	a0,16(a0)
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	22e080e7          	jalr	558(ra) # 80003eda <pipewrite>
    80003cb4:	8a2a                	mv	s4,a0
    80003cb6:	a045                	j	80003d56 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb8:	02451783          	lh	a5,36(a0)
    80003cbc:	03079693          	slli	a3,a5,0x30
    80003cc0:	92c1                	srli	a3,a3,0x30
    80003cc2:	4725                	li	a4,9
    80003cc4:	0cd76263          	bltu	a4,a3,80003d88 <filewrite+0x12c>
    80003cc8:	0792                	slli	a5,a5,0x4
    80003cca:	00016717          	auipc	a4,0x16
    80003cce:	9fe70713          	addi	a4,a4,-1538 # 800196c8 <devsw>
    80003cd2:	97ba                	add	a5,a5,a4
    80003cd4:	679c                	ld	a5,8(a5)
    80003cd6:	cbdd                	beqz	a5,80003d8c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cd8:	4505                	li	a0,1
    80003cda:	9782                	jalr	a5
    80003cdc:	8a2a                	mv	s4,a0
    80003cde:	a8a5                	j	80003d56 <filewrite+0xfa>
    80003ce0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	8b0080e7          	jalr	-1872(ra) # 80003594 <begin_op>
      ilock(f->ip);
    80003cec:	01893503          	ld	a0,24(s2)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	ed2080e7          	jalr	-302(ra) # 80002bc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf8:	8762                	mv	a4,s8
    80003cfa:	02092683          	lw	a3,32(s2)
    80003cfe:	01598633          	add	a2,s3,s5
    80003d02:	4585                	li	a1,1
    80003d04:	01893503          	ld	a0,24(s2)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	266080e7          	jalr	614(ra) # 80002f6e <writei>
    80003d10:	84aa                	mv	s1,a0
    80003d12:	00a05763          	blez	a0,80003d20 <filewrite+0xc4>
        f->off += r;
    80003d16:	02092783          	lw	a5,32(s2)
    80003d1a:	9fa9                	addw	a5,a5,a0
    80003d1c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d20:	01893503          	ld	a0,24(s2)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	f60080e7          	jalr	-160(ra) # 80002c84 <iunlock>
      end_op();
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	8e8080e7          	jalr	-1816(ra) # 80003614 <end_op>

      if(r != n1){
    80003d34:	009c1f63          	bne	s8,s1,80003d52 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d38:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d3c:	0149db63          	bge	s3,s4,80003d52 <filewrite+0xf6>
      int n1 = n - i;
    80003d40:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d44:	84be                	mv	s1,a5
    80003d46:	2781                	sext.w	a5,a5
    80003d48:	f8fb5ce3          	bge	s6,a5,80003ce0 <filewrite+0x84>
    80003d4c:	84de                	mv	s1,s7
    80003d4e:	bf49                	j	80003ce0 <filewrite+0x84>
    int i = 0;
    80003d50:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d52:	013a1f63          	bne	s4,s3,80003d70 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d56:	8552                	mv	a0,s4
    80003d58:	60a6                	ld	ra,72(sp)
    80003d5a:	6406                	ld	s0,64(sp)
    80003d5c:	74e2                	ld	s1,56(sp)
    80003d5e:	7942                	ld	s2,48(sp)
    80003d60:	79a2                	ld	s3,40(sp)
    80003d62:	7a02                	ld	s4,32(sp)
    80003d64:	6ae2                	ld	s5,24(sp)
    80003d66:	6b42                	ld	s6,16(sp)
    80003d68:	6ba2                	ld	s7,8(sp)
    80003d6a:	6c02                	ld	s8,0(sp)
    80003d6c:	6161                	addi	sp,sp,80
    80003d6e:	8082                	ret
    ret = (i == n ? n : -1);
    80003d70:	5a7d                	li	s4,-1
    80003d72:	b7d5                	j	80003d56 <filewrite+0xfa>
    panic("filewrite");
    80003d74:	00005517          	auipc	a0,0x5
    80003d78:	8cc50513          	addi	a0,a0,-1844 # 80008640 <syscalls+0x278>
    80003d7c:	00002097          	auipc	ra,0x2
    80003d80:	f46080e7          	jalr	-186(ra) # 80005cc2 <panic>
    return -1;
    80003d84:	5a7d                	li	s4,-1
    80003d86:	bfc1                	j	80003d56 <filewrite+0xfa>
      return -1;
    80003d88:	5a7d                	li	s4,-1
    80003d8a:	b7f1                	j	80003d56 <filewrite+0xfa>
    80003d8c:	5a7d                	li	s4,-1
    80003d8e:	b7e1                	j	80003d56 <filewrite+0xfa>

0000000080003d90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d90:	7179                	addi	sp,sp,-48
    80003d92:	f406                	sd	ra,40(sp)
    80003d94:	f022                	sd	s0,32(sp)
    80003d96:	ec26                	sd	s1,24(sp)
    80003d98:	e84a                	sd	s2,16(sp)
    80003d9a:	e44e                	sd	s3,8(sp)
    80003d9c:	e052                	sd	s4,0(sp)
    80003d9e:	1800                	addi	s0,sp,48
    80003da0:	84aa                	mv	s1,a0
    80003da2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003da4:	0005b023          	sd	zero,0(a1)
    80003da8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	bf8080e7          	jalr	-1032(ra) # 800039a4 <filealloc>
    80003db4:	e088                	sd	a0,0(s1)
    80003db6:	c551                	beqz	a0,80003e42 <pipealloc+0xb2>
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	bec080e7          	jalr	-1044(ra) # 800039a4 <filealloc>
    80003dc0:	00aa3023          	sd	a0,0(s4)
    80003dc4:	c92d                	beqz	a0,80003e36 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dc6:	ffffc097          	auipc	ra,0xffffc
    80003dca:	352080e7          	jalr	850(ra) # 80000118 <kalloc>
    80003dce:	892a                	mv	s2,a0
    80003dd0:	c125                	beqz	a0,80003e30 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dd2:	4985                	li	s3,1
    80003dd4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ddc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003de4:	00005597          	auipc	a1,0x5
    80003de8:	86c58593          	addi	a1,a1,-1940 # 80008650 <syscalls+0x288>
    80003dec:	00002097          	auipc	ra,0x2
    80003df0:	358080e7          	jalr	856(ra) # 80006144 <initlock>
  (*f0)->type = FD_PIPE;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e0c:	000a3783          	ld	a5,0(s4)
    80003e10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e1c:	000a3783          	ld	a5,0(s4)
    80003e20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e24:	000a3783          	ld	a5,0(s4)
    80003e28:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e2c:	4501                	li	a0,0
    80003e2e:	a025                	j	80003e56 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e30:	6088                	ld	a0,0(s1)
    80003e32:	e501                	bnez	a0,80003e3a <pipealloc+0xaa>
    80003e34:	a039                	j	80003e42 <pipealloc+0xb2>
    80003e36:	6088                	ld	a0,0(s1)
    80003e38:	c51d                	beqz	a0,80003e66 <pipealloc+0xd6>
    fileclose(*f0);
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	c26080e7          	jalr	-986(ra) # 80003a60 <fileclose>
  if(*f1)
    80003e42:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e46:	557d                	li	a0,-1
  if(*f1)
    80003e48:	c799                	beqz	a5,80003e56 <pipealloc+0xc6>
    fileclose(*f1);
    80003e4a:	853e                	mv	a0,a5
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c14080e7          	jalr	-1004(ra) # 80003a60 <fileclose>
  return -1;
    80003e54:	557d                	li	a0,-1
}
    80003e56:	70a2                	ld	ra,40(sp)
    80003e58:	7402                	ld	s0,32(sp)
    80003e5a:	64e2                	ld	s1,24(sp)
    80003e5c:	6942                	ld	s2,16(sp)
    80003e5e:	69a2                	ld	s3,8(sp)
    80003e60:	6a02                	ld	s4,0(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
  return -1;
    80003e66:	557d                	li	a0,-1
    80003e68:	b7fd                	j	80003e56 <pipealloc+0xc6>

0000000080003e6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6a:	1101                	addi	sp,sp,-32
    80003e6c:	ec06                	sd	ra,24(sp)
    80003e6e:	e822                	sd	s0,16(sp)
    80003e70:	e426                	sd	s1,8(sp)
    80003e72:	e04a                	sd	s2,0(sp)
    80003e74:	1000                	addi	s0,sp,32
    80003e76:	84aa                	mv	s1,a0
    80003e78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	35a080e7          	jalr	858(ra) # 800061d4 <acquire>
  if(writable){
    80003e82:	02090d63          	beqz	s2,80003ebc <pipeclose+0x52>
    pi->writeopen = 0;
    80003e86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8a:	21848513          	addi	a0,s1,536
    80003e8e:	ffffe097          	auipc	ra,0xffffe
    80003e92:	856080e7          	jalr	-1962(ra) # 800016e4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e96:	2204b783          	ld	a5,544(s1)
    80003e9a:	eb95                	bnez	a5,80003ece <pipeclose+0x64>
    release(&pi->lock);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00002097          	auipc	ra,0x2
    80003ea2:	3ea080e7          	jalr	1002(ra) # 80006288 <release>
    kfree((char*)pi);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb0:	60e2                	ld	ra,24(sp)
    80003eb2:	6442                	ld	s0,16(sp)
    80003eb4:	64a2                	ld	s1,8(sp)
    80003eb6:	6902                	ld	s2,0(sp)
    80003eb8:	6105                	addi	sp,sp,32
    80003eba:	8082                	ret
    pi->readopen = 0;
    80003ebc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec0:	21c48513          	addi	a0,s1,540
    80003ec4:	ffffe097          	auipc	ra,0xffffe
    80003ec8:	820080e7          	jalr	-2016(ra) # 800016e4 <wakeup>
    80003ecc:	b7e9                	j	80003e96 <pipeclose+0x2c>
    release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	3b8080e7          	jalr	952(ra) # 80006288 <release>
}
    80003ed8:	bfe1                	j	80003eb0 <pipeclose+0x46>

0000000080003eda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eda:	711d                	addi	sp,sp,-96
    80003edc:	ec86                	sd	ra,88(sp)
    80003ede:	e8a2                	sd	s0,80(sp)
    80003ee0:	e4a6                	sd	s1,72(sp)
    80003ee2:	e0ca                	sd	s2,64(sp)
    80003ee4:	fc4e                	sd	s3,56(sp)
    80003ee6:	f852                	sd	s4,48(sp)
    80003ee8:	f456                	sd	s5,40(sp)
    80003eea:	f05a                	sd	s6,32(sp)
    80003eec:	ec5e                	sd	s7,24(sp)
    80003eee:	e862                	sd	s8,16(sp)
    80003ef0:	1080                	addi	s0,sp,96
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	8aae                	mv	s5,a1
    80003ef6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	f4a080e7          	jalr	-182(ra) # 80000e42 <myproc>
    80003f00:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f02:	8526                	mv	a0,s1
    80003f04:	00002097          	auipc	ra,0x2
    80003f08:	2d0080e7          	jalr	720(ra) # 800061d4 <acquire>
  while(i < n){
    80003f0c:	0b405363          	blez	s4,80003fb2 <pipewrite+0xd8>
  int i = 0;
    80003f10:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f12:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f14:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f18:	21c48b93          	addi	s7,s1,540
    80003f1c:	a089                	j	80003f5e <pipewrite+0x84>
      release(&pi->lock);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	00002097          	auipc	ra,0x2
    80003f24:	368080e7          	jalr	872(ra) # 80006288 <release>
      return -1;
    80003f28:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f2a:	854a                	mv	a0,s2
    80003f2c:	60e6                	ld	ra,88(sp)
    80003f2e:	6446                	ld	s0,80(sp)
    80003f30:	64a6                	ld	s1,72(sp)
    80003f32:	6906                	ld	s2,64(sp)
    80003f34:	79e2                	ld	s3,56(sp)
    80003f36:	7a42                	ld	s4,48(sp)
    80003f38:	7aa2                	ld	s5,40(sp)
    80003f3a:	7b02                	ld	s6,32(sp)
    80003f3c:	6be2                	ld	s7,24(sp)
    80003f3e:	6c42                	ld	s8,16(sp)
    80003f40:	6125                	addi	sp,sp,96
    80003f42:	8082                	ret
      wakeup(&pi->nread);
    80003f44:	8562                	mv	a0,s8
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	79e080e7          	jalr	1950(ra) # 800016e4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f4e:	85a6                	mv	a1,s1
    80003f50:	855e                	mv	a0,s7
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	606080e7          	jalr	1542(ra) # 80001558 <sleep>
  while(i < n){
    80003f5a:	05495d63          	bge	s2,s4,80003fb4 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f5e:	2204a783          	lw	a5,544(s1)
    80003f62:	dfd5                	beqz	a5,80003f1e <pipewrite+0x44>
    80003f64:	0289a783          	lw	a5,40(s3)
    80003f68:	fbdd                	bnez	a5,80003f1e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6a:	2184a783          	lw	a5,536(s1)
    80003f6e:	21c4a703          	lw	a4,540(s1)
    80003f72:	2007879b          	addiw	a5,a5,512
    80003f76:	fcf707e3          	beq	a4,a5,80003f44 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	01590633          	add	a2,s2,s5
    80003f80:	faf40593          	addi	a1,s0,-81
    80003f84:	0509b503          	ld	a0,80(s3)
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	c06080e7          	jalr	-1018(ra) # 80000b8e <copyin>
    80003f90:	03650263          	beq	a0,s6,80003fb4 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f94:	21c4a783          	lw	a5,540(s1)
    80003f98:	0017871b          	addiw	a4,a5,1
    80003f9c:	20e4ae23          	sw	a4,540(s1)
    80003fa0:	1ff7f793          	andi	a5,a5,511
    80003fa4:	97a6                	add	a5,a5,s1
    80003fa6:	faf44703          	lbu	a4,-81(s0)
    80003faa:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fae:	2905                	addiw	s2,s2,1
    80003fb0:	b76d                	j	80003f5a <pipewrite+0x80>
  int i = 0;
    80003fb2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fb4:	21848513          	addi	a0,s1,536
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	72c080e7          	jalr	1836(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	2c6080e7          	jalr	710(ra) # 80006288 <release>
  return i;
    80003fca:	b785                	j	80003f2a <pipewrite+0x50>

0000000080003fcc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fcc:	715d                	addi	sp,sp,-80
    80003fce:	e486                	sd	ra,72(sp)
    80003fd0:	e0a2                	sd	s0,64(sp)
    80003fd2:	fc26                	sd	s1,56(sp)
    80003fd4:	f84a                	sd	s2,48(sp)
    80003fd6:	f44e                	sd	s3,40(sp)
    80003fd8:	f052                	sd	s4,32(sp)
    80003fda:	ec56                	sd	s5,24(sp)
    80003fdc:	e85a                	sd	s6,16(sp)
    80003fde:	0880                	addi	s0,sp,80
    80003fe0:	84aa                	mv	s1,a0
    80003fe2:	892e                	mv	s2,a1
    80003fe4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	e5c080e7          	jalr	-420(ra) # 80000e42 <myproc>
    80003fee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	00002097          	auipc	ra,0x2
    80003ff6:	1e2080e7          	jalr	482(ra) # 800061d4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffa:	2184a703          	lw	a4,536(s1)
    80003ffe:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004002:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004006:	02f71463          	bne	a4,a5,8000402e <piperead+0x62>
    8000400a:	2244a783          	lw	a5,548(s1)
    8000400e:	c385                	beqz	a5,8000402e <piperead+0x62>
    if(pr->killed){
    80004010:	028a2783          	lw	a5,40(s4)
    80004014:	ebc1                	bnez	a5,800040a4 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004016:	85a6                	mv	a1,s1
    80004018:	854e                	mv	a0,s3
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	53e080e7          	jalr	1342(ra) # 80001558 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004022:	2184a703          	lw	a4,536(s1)
    80004026:	21c4a783          	lw	a5,540(s1)
    8000402a:	fef700e3          	beq	a4,a5,8000400a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000402e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004030:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004032:	05505363          	blez	s5,80004078 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004036:	2184a783          	lw	a5,536(s1)
    8000403a:	21c4a703          	lw	a4,540(s1)
    8000403e:	02f70d63          	beq	a4,a5,80004078 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004042:	0017871b          	addiw	a4,a5,1
    80004046:	20e4ac23          	sw	a4,536(s1)
    8000404a:	1ff7f793          	andi	a5,a5,511
    8000404e:	97a6                	add	a5,a5,s1
    80004050:	0187c783          	lbu	a5,24(a5)
    80004054:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004058:	4685                	li	a3,1
    8000405a:	fbf40613          	addi	a2,s0,-65
    8000405e:	85ca                	mv	a1,s2
    80004060:	050a3503          	ld	a0,80(s4)
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	a9e080e7          	jalr	-1378(ra) # 80000b02 <copyout>
    8000406c:	01650663          	beq	a0,s6,80004078 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004070:	2985                	addiw	s3,s3,1
    80004072:	0905                	addi	s2,s2,1
    80004074:	fd3a91e3          	bne	s5,s3,80004036 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004078:	21c48513          	addi	a0,s1,540
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	668080e7          	jalr	1640(ra) # 800016e4 <wakeup>
  release(&pi->lock);
    80004084:	8526                	mv	a0,s1
    80004086:	00002097          	auipc	ra,0x2
    8000408a:	202080e7          	jalr	514(ra) # 80006288 <release>
  return i;
}
    8000408e:	854e                	mv	a0,s3
    80004090:	60a6                	ld	ra,72(sp)
    80004092:	6406                	ld	s0,64(sp)
    80004094:	74e2                	ld	s1,56(sp)
    80004096:	7942                	ld	s2,48(sp)
    80004098:	79a2                	ld	s3,40(sp)
    8000409a:	7a02                	ld	s4,32(sp)
    8000409c:	6ae2                	ld	s5,24(sp)
    8000409e:	6b42                	ld	s6,16(sp)
    800040a0:	6161                	addi	sp,sp,80
    800040a2:	8082                	ret
      release(&pi->lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	1e2080e7          	jalr	482(ra) # 80006288 <release>
      return -1;
    800040ae:	59fd                	li	s3,-1
    800040b0:	bff9                	j	8000408e <piperead+0xc2>

00000000800040b2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040b2:	de010113          	addi	sp,sp,-544
    800040b6:	20113c23          	sd	ra,536(sp)
    800040ba:	20813823          	sd	s0,528(sp)
    800040be:	20913423          	sd	s1,520(sp)
    800040c2:	21213023          	sd	s2,512(sp)
    800040c6:	ffce                	sd	s3,504(sp)
    800040c8:	fbd2                	sd	s4,496(sp)
    800040ca:	f7d6                	sd	s5,488(sp)
    800040cc:	f3da                	sd	s6,480(sp)
    800040ce:	efde                	sd	s7,472(sp)
    800040d0:	ebe2                	sd	s8,464(sp)
    800040d2:	e7e6                	sd	s9,456(sp)
    800040d4:	e3ea                	sd	s10,448(sp)
    800040d6:	ff6e                	sd	s11,440(sp)
    800040d8:	1400                	addi	s0,sp,544
    800040da:	892a                	mv	s2,a0
    800040dc:	dea43423          	sd	a0,-536(s0)
    800040e0:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	d5e080e7          	jalr	-674(ra) # 80000e42 <myproc>
    800040ec:	84aa                	mv	s1,a0

  begin_op();
    800040ee:	fffff097          	auipc	ra,0xfffff
    800040f2:	4a6080e7          	jalr	1190(ra) # 80003594 <begin_op>

  if((ip = namei(path)) == 0){
    800040f6:	854a                	mv	a0,s2
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	280080e7          	jalr	640(ra) # 80003378 <namei>
    80004100:	c93d                	beqz	a0,80004176 <exec+0xc4>
    80004102:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004104:	fffff097          	auipc	ra,0xfffff
    80004108:	abe080e7          	jalr	-1346(ra) # 80002bc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000410c:	04000713          	li	a4,64
    80004110:	4681                	li	a3,0
    80004112:	e5040613          	addi	a2,s0,-432
    80004116:	4581                	li	a1,0
    80004118:	8556                	mv	a0,s5
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	d5c080e7          	jalr	-676(ra) # 80002e76 <readi>
    80004122:	04000793          	li	a5,64
    80004126:	00f51a63          	bne	a0,a5,8000413a <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000412a:	e5042703          	lw	a4,-432(s0)
    8000412e:	464c47b7          	lui	a5,0x464c4
    80004132:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004136:	04f70663          	beq	a4,a5,80004182 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000413a:	8556                	mv	a0,s5
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	ce8080e7          	jalr	-792(ra) # 80002e24 <iunlockput>
    end_op();
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	4d0080e7          	jalr	1232(ra) # 80003614 <end_op>
  }
  return -1;
    8000414c:	557d                	li	a0,-1
}
    8000414e:	21813083          	ld	ra,536(sp)
    80004152:	21013403          	ld	s0,528(sp)
    80004156:	20813483          	ld	s1,520(sp)
    8000415a:	20013903          	ld	s2,512(sp)
    8000415e:	79fe                	ld	s3,504(sp)
    80004160:	7a5e                	ld	s4,496(sp)
    80004162:	7abe                	ld	s5,488(sp)
    80004164:	7b1e                	ld	s6,480(sp)
    80004166:	6bfe                	ld	s7,472(sp)
    80004168:	6c5e                	ld	s8,464(sp)
    8000416a:	6cbe                	ld	s9,456(sp)
    8000416c:	6d1e                	ld	s10,448(sp)
    8000416e:	7dfa                	ld	s11,440(sp)
    80004170:	22010113          	addi	sp,sp,544
    80004174:	8082                	ret
    end_op();
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	49e080e7          	jalr	1182(ra) # 80003614 <end_op>
    return -1;
    8000417e:	557d                	li	a0,-1
    80004180:	b7f9                	j	8000414e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004182:	8526                	mv	a0,s1
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	d82080e7          	jalr	-638(ra) # 80000f06 <proc_pagetable>
    8000418c:	8b2a                	mv	s6,a0
    8000418e:	d555                	beqz	a0,8000413a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004190:	e7042783          	lw	a5,-400(s0)
    80004194:	e8845703          	lhu	a4,-376(s0)
    80004198:	c735                	beqz	a4,80004204 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000419a:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000419c:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041a0:	6a05                	lui	s4,0x1
    800041a2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041a6:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041aa:	6d85                	lui	s11,0x1
    800041ac:	7d7d                	lui	s10,0xfffff
    800041ae:	ac1d                	j	800043e4 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041b0:	00004517          	auipc	a0,0x4
    800041b4:	4a850513          	addi	a0,a0,1192 # 80008658 <syscalls+0x290>
    800041b8:	00002097          	auipc	ra,0x2
    800041bc:	b0a080e7          	jalr	-1270(ra) # 80005cc2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c0:	874a                	mv	a4,s2
    800041c2:	009c86bb          	addw	a3,s9,s1
    800041c6:	4581                	li	a1,0
    800041c8:	8556                	mv	a0,s5
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	cac080e7          	jalr	-852(ra) # 80002e76 <readi>
    800041d2:	2501                	sext.w	a0,a0
    800041d4:	1aa91863          	bne	s2,a0,80004384 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041d8:	009d84bb          	addw	s1,s11,s1
    800041dc:	013d09bb          	addw	s3,s10,s3
    800041e0:	1f74f263          	bgeu	s1,s7,800043c4 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041e4:	02049593          	slli	a1,s1,0x20
    800041e8:	9181                	srli	a1,a1,0x20
    800041ea:	95e2                	add	a1,a1,s8
    800041ec:	855a                	mv	a0,s6
    800041ee:	ffffc097          	auipc	ra,0xffffc
    800041f2:	310080e7          	jalr	784(ra) # 800004fe <walkaddr>
    800041f6:	862a                	mv	a2,a0
    if(pa == 0)
    800041f8:	dd45                	beqz	a0,800041b0 <exec+0xfe>
      n = PGSIZE;
    800041fa:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041fc:	fd49f2e3          	bgeu	s3,s4,800041c0 <exec+0x10e>
      n = sz - i;
    80004200:	894e                	mv	s2,s3
    80004202:	bf7d                	j	800041c0 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004204:	4481                	li	s1,0
  iunlockput(ip);
    80004206:	8556                	mv	a0,s5
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	c1c080e7          	jalr	-996(ra) # 80002e24 <iunlockput>
  end_op();
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	404080e7          	jalr	1028(ra) # 80003614 <end_op>
  p = myproc();
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	c2a080e7          	jalr	-982(ra) # 80000e42 <myproc>
    80004220:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004222:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004226:	6785                	lui	a5,0x1
    80004228:	17fd                	addi	a5,a5,-1
    8000422a:	94be                	add	s1,s1,a5
    8000422c:	77fd                	lui	a5,0xfffff
    8000422e:	8fe5                	and	a5,a5,s1
    80004230:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004234:	6609                	lui	a2,0x2
    80004236:	963e                	add	a2,a2,a5
    80004238:	85be                	mv	a1,a5
    8000423a:	855a                	mv	a0,s6
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	676080e7          	jalr	1654(ra) # 800008b2 <uvmalloc>
    80004244:	8c2a                	mv	s8,a0
  ip = 0;
    80004246:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004248:	12050e63          	beqz	a0,80004384 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000424c:	75f9                	lui	a1,0xffffe
    8000424e:	95aa                	add	a1,a1,a0
    80004250:	855a                	mv	a0,s6
    80004252:	ffffd097          	auipc	ra,0xffffd
    80004256:	87e080e7          	jalr	-1922(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000425a:	7afd                	lui	s5,0xfffff
    8000425c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000425e:	df043783          	ld	a5,-528(s0)
    80004262:	6388                	ld	a0,0(a5)
    80004264:	c925                	beqz	a0,800042d4 <exec+0x222>
    80004266:	e9040993          	addi	s3,s0,-368
    8000426a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000426e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004270:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	082080e7          	jalr	130(ra) # 800002f4 <strlen>
    8000427a:	0015079b          	addiw	a5,a0,1
    8000427e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004282:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004286:	13596363          	bltu	s2,s5,800043ac <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000428a:	df043d83          	ld	s11,-528(s0)
    8000428e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004292:	8552                	mv	a0,s4
    80004294:	ffffc097          	auipc	ra,0xffffc
    80004298:	060080e7          	jalr	96(ra) # 800002f4 <strlen>
    8000429c:	0015069b          	addiw	a3,a0,1
    800042a0:	8652                	mv	a2,s4
    800042a2:	85ca                	mv	a1,s2
    800042a4:	855a                	mv	a0,s6
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	85c080e7          	jalr	-1956(ra) # 80000b02 <copyout>
    800042ae:	10054363          	bltz	a0,800043b4 <exec+0x302>
    ustack[argc] = sp;
    800042b2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042b6:	0485                	addi	s1,s1,1
    800042b8:	008d8793          	addi	a5,s11,8
    800042bc:	def43823          	sd	a5,-528(s0)
    800042c0:	008db503          	ld	a0,8(s11)
    800042c4:	c911                	beqz	a0,800042d8 <exec+0x226>
    if(argc >= MAXARG)
    800042c6:	09a1                	addi	s3,s3,8
    800042c8:	fb3c95e3          	bne	s9,s3,80004272 <exec+0x1c0>
  sz = sz1;
    800042cc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d0:	4a81                	li	s5,0
    800042d2:	a84d                	j	80004384 <exec+0x2d2>
  sp = sz;
    800042d4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042d6:	4481                	li	s1,0
  ustack[argc] = 0;
    800042d8:	00349793          	slli	a5,s1,0x3
    800042dc:	f9040713          	addi	a4,s0,-112
    800042e0:	97ba                	add	a5,a5,a4
    800042e2:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd8cc0>
  sp -= (argc+1) * sizeof(uint64);
    800042e6:	00148693          	addi	a3,s1,1
    800042ea:	068e                	slli	a3,a3,0x3
    800042ec:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042f0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042f4:	01597663          	bgeu	s2,s5,80004300 <exec+0x24e>
  sz = sz1;
    800042f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042fc:	4a81                	li	s5,0
    800042fe:	a059                	j	80004384 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004300:	e9040613          	addi	a2,s0,-368
    80004304:	85ca                	mv	a1,s2
    80004306:	855a                	mv	a0,s6
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	7fa080e7          	jalr	2042(ra) # 80000b02 <copyout>
    80004310:	0a054663          	bltz	a0,800043bc <exec+0x30a>
  p->trapframe->a1 = sp;
    80004314:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004318:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000431c:	de843783          	ld	a5,-536(s0)
    80004320:	0007c703          	lbu	a4,0(a5)
    80004324:	cf11                	beqz	a4,80004340 <exec+0x28e>
    80004326:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004328:	02f00693          	li	a3,47
    8000432c:	a039                	j	8000433a <exec+0x288>
      last = s+1;
    8000432e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004332:	0785                	addi	a5,a5,1
    80004334:	fff7c703          	lbu	a4,-1(a5)
    80004338:	c701                	beqz	a4,80004340 <exec+0x28e>
    if(*s == '/')
    8000433a:	fed71ce3          	bne	a4,a3,80004332 <exec+0x280>
    8000433e:	bfc5                	j	8000432e <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004340:	4641                	li	a2,16
    80004342:	de843583          	ld	a1,-536(s0)
    80004346:	158b8513          	addi	a0,s7,344
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	f78080e7          	jalr	-136(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004352:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004356:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000435a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000435e:	058bb783          	ld	a5,88(s7)
    80004362:	e6843703          	ld	a4,-408(s0)
    80004366:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004368:	058bb783          	ld	a5,88(s7)
    8000436c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004370:	85ea                	mv	a1,s10
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	c30080e7          	jalr	-976(ra) # 80000fa2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000437a:	0004851b          	sext.w	a0,s1
    8000437e:	bbc1                	j	8000414e <exec+0x9c>
    80004380:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004384:	df843583          	ld	a1,-520(s0)
    80004388:	855a                	mv	a0,s6
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	c18080e7          	jalr	-1000(ra) # 80000fa2 <proc_freepagetable>
  if(ip){
    80004392:	da0a94e3          	bnez	s5,8000413a <exec+0x88>
  return -1;
    80004396:	557d                	li	a0,-1
    80004398:	bb5d                	j	8000414e <exec+0x9c>
    8000439a:	de943c23          	sd	s1,-520(s0)
    8000439e:	b7dd                	j	80004384 <exec+0x2d2>
    800043a0:	de943c23          	sd	s1,-520(s0)
    800043a4:	b7c5                	j	80004384 <exec+0x2d2>
    800043a6:	de943c23          	sd	s1,-520(s0)
    800043aa:	bfe9                	j	80004384 <exec+0x2d2>
  sz = sz1;
    800043ac:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b0:	4a81                	li	s5,0
    800043b2:	bfc9                	j	80004384 <exec+0x2d2>
  sz = sz1;
    800043b4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b8:	4a81                	li	s5,0
    800043ba:	b7e9                	j	80004384 <exec+0x2d2>
  sz = sz1;
    800043bc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c0:	4a81                	li	s5,0
    800043c2:	b7c9                	j	80004384 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043c4:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c8:	e0843783          	ld	a5,-504(s0)
    800043cc:	0017869b          	addiw	a3,a5,1
    800043d0:	e0d43423          	sd	a3,-504(s0)
    800043d4:	e0043783          	ld	a5,-512(s0)
    800043d8:	0387879b          	addiw	a5,a5,56
    800043dc:	e8845703          	lhu	a4,-376(s0)
    800043e0:	e2e6d3e3          	bge	a3,a4,80004206 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043e4:	2781                	sext.w	a5,a5
    800043e6:	e0f43023          	sd	a5,-512(s0)
    800043ea:	03800713          	li	a4,56
    800043ee:	86be                	mv	a3,a5
    800043f0:	e1840613          	addi	a2,s0,-488
    800043f4:	4581                	li	a1,0
    800043f6:	8556                	mv	a0,s5
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	a7e080e7          	jalr	-1410(ra) # 80002e76 <readi>
    80004400:	03800793          	li	a5,56
    80004404:	f6f51ee3          	bne	a0,a5,80004380 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004408:	e1842783          	lw	a5,-488(s0)
    8000440c:	4705                	li	a4,1
    8000440e:	fae79de3          	bne	a5,a4,800043c8 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004412:	e4043603          	ld	a2,-448(s0)
    80004416:	e3843783          	ld	a5,-456(s0)
    8000441a:	f8f660e3          	bltu	a2,a5,8000439a <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000441e:	e2843783          	ld	a5,-472(s0)
    80004422:	963e                	add	a2,a2,a5
    80004424:	f6f66ee3          	bltu	a2,a5,800043a0 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004428:	85a6                	mv	a1,s1
    8000442a:	855a                	mv	a0,s6
    8000442c:	ffffc097          	auipc	ra,0xffffc
    80004430:	486080e7          	jalr	1158(ra) # 800008b2 <uvmalloc>
    80004434:	dea43c23          	sd	a0,-520(s0)
    80004438:	d53d                	beqz	a0,800043a6 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000443a:	e2843c03          	ld	s8,-472(s0)
    8000443e:	de043783          	ld	a5,-544(s0)
    80004442:	00fc77b3          	and	a5,s8,a5
    80004446:	ff9d                	bnez	a5,80004384 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004448:	e2042c83          	lw	s9,-480(s0)
    8000444c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004450:	f60b8ae3          	beqz	s7,800043c4 <exec+0x312>
    80004454:	89de                	mv	s3,s7
    80004456:	4481                	li	s1,0
    80004458:	b371                	j	800041e4 <exec+0x132>

000000008000445a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000445a:	7179                	addi	sp,sp,-48
    8000445c:	f406                	sd	ra,40(sp)
    8000445e:	f022                	sd	s0,32(sp)
    80004460:	ec26                	sd	s1,24(sp)
    80004462:	e84a                	sd	s2,16(sp)
    80004464:	1800                	addi	s0,sp,48
    80004466:	892e                	mv	s2,a1
    80004468:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000446a:	fdc40593          	addi	a1,s0,-36
    8000446e:	ffffe097          	auipc	ra,0xffffe
    80004472:	b2a080e7          	jalr	-1238(ra) # 80001f98 <argint>
    80004476:	04054063          	bltz	a0,800044b6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000447a:	fdc42703          	lw	a4,-36(s0)
    8000447e:	47bd                	li	a5,15
    80004480:	02e7ed63          	bltu	a5,a4,800044ba <argfd+0x60>
    80004484:	ffffd097          	auipc	ra,0xffffd
    80004488:	9be080e7          	jalr	-1602(ra) # 80000e42 <myproc>
    8000448c:	fdc42703          	lw	a4,-36(s0)
    80004490:	01a70793          	addi	a5,a4,26
    80004494:	078e                	slli	a5,a5,0x3
    80004496:	953e                	add	a0,a0,a5
    80004498:	611c                	ld	a5,0(a0)
    8000449a:	c395                	beqz	a5,800044be <argfd+0x64>
    return -1;
  if(pfd)
    8000449c:	00090463          	beqz	s2,800044a4 <argfd+0x4a>
    *pfd = fd;
    800044a0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044a4:	4501                	li	a0,0
  if(pf)
    800044a6:	c091                	beqz	s1,800044aa <argfd+0x50>
    *pf = f;
    800044a8:	e09c                	sd	a5,0(s1)
}
    800044aa:	70a2                	ld	ra,40(sp)
    800044ac:	7402                	ld	s0,32(sp)
    800044ae:	64e2                	ld	s1,24(sp)
    800044b0:	6942                	ld	s2,16(sp)
    800044b2:	6145                	addi	sp,sp,48
    800044b4:	8082                	ret
    return -1;
    800044b6:	557d                	li	a0,-1
    800044b8:	bfcd                	j	800044aa <argfd+0x50>
    return -1;
    800044ba:	557d                	li	a0,-1
    800044bc:	b7fd                	j	800044aa <argfd+0x50>
    800044be:	557d                	li	a0,-1
    800044c0:	b7ed                	j	800044aa <argfd+0x50>

00000000800044c2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c2:	1101                	addi	sp,sp,-32
    800044c4:	ec06                	sd	ra,24(sp)
    800044c6:	e822                	sd	s0,16(sp)
    800044c8:	e426                	sd	s1,8(sp)
    800044ca:	1000                	addi	s0,sp,32
    800044cc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	974080e7          	jalr	-1676(ra) # 80000e42 <myproc>
    800044d6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044d8:	0d050793          	addi	a5,a0,208
    800044dc:	4501                	li	a0,0
    800044de:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044e0:	6398                	ld	a4,0(a5)
    800044e2:	cb19                	beqz	a4,800044f8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044e4:	2505                	addiw	a0,a0,1
    800044e6:	07a1                	addi	a5,a5,8
    800044e8:	fed51ce3          	bne	a0,a3,800044e0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ec:	557d                	li	a0,-1
}
    800044ee:	60e2                	ld	ra,24(sp)
    800044f0:	6442                	ld	s0,16(sp)
    800044f2:	64a2                	ld	s1,8(sp)
    800044f4:	6105                	addi	sp,sp,32
    800044f6:	8082                	ret
      p->ofile[fd] = f;
    800044f8:	01a50793          	addi	a5,a0,26
    800044fc:	078e                	slli	a5,a5,0x3
    800044fe:	963e                	add	a2,a2,a5
    80004500:	e204                	sd	s1,0(a2)
      return fd;
    80004502:	b7f5                	j	800044ee <fdalloc+0x2c>

0000000080004504 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004504:	715d                	addi	sp,sp,-80
    80004506:	e486                	sd	ra,72(sp)
    80004508:	e0a2                	sd	s0,64(sp)
    8000450a:	fc26                	sd	s1,56(sp)
    8000450c:	f84a                	sd	s2,48(sp)
    8000450e:	f44e                	sd	s3,40(sp)
    80004510:	f052                	sd	s4,32(sp)
    80004512:	ec56                	sd	s5,24(sp)
    80004514:	0880                	addi	s0,sp,80
    80004516:	89ae                	mv	s3,a1
    80004518:	8ab2                	mv	s5,a2
    8000451a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000451c:	fb040593          	addi	a1,s0,-80
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	e76080e7          	jalr	-394(ra) # 80003396 <nameiparent>
    80004528:	892a                	mv	s2,a0
    8000452a:	12050e63          	beqz	a0,80004666 <create+0x162>
    return 0;

  ilock(dp);
    8000452e:	ffffe097          	auipc	ra,0xffffe
    80004532:	694080e7          	jalr	1684(ra) # 80002bc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004536:	4601                	li	a2,0
    80004538:	fb040593          	addi	a1,s0,-80
    8000453c:	854a                	mv	a0,s2
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	b68080e7          	jalr	-1176(ra) # 800030a6 <dirlookup>
    80004546:	84aa                	mv	s1,a0
    80004548:	c921                	beqz	a0,80004598 <create+0x94>
    iunlockput(dp);
    8000454a:	854a                	mv	a0,s2
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	8d8080e7          	jalr	-1832(ra) # 80002e24 <iunlockput>
    ilock(ip);
    80004554:	8526                	mv	a0,s1
    80004556:	ffffe097          	auipc	ra,0xffffe
    8000455a:	66c080e7          	jalr	1644(ra) # 80002bc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000455e:	2981                	sext.w	s3,s3
    80004560:	4789                	li	a5,2
    80004562:	02f99463          	bne	s3,a5,8000458a <create+0x86>
    80004566:	0444d783          	lhu	a5,68(s1)
    8000456a:	37f9                	addiw	a5,a5,-2
    8000456c:	17c2                	slli	a5,a5,0x30
    8000456e:	93c1                	srli	a5,a5,0x30
    80004570:	4705                	li	a4,1
    80004572:	00f76c63          	bltu	a4,a5,8000458a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004576:	8526                	mv	a0,s1
    80004578:	60a6                	ld	ra,72(sp)
    8000457a:	6406                	ld	s0,64(sp)
    8000457c:	74e2                	ld	s1,56(sp)
    8000457e:	7942                	ld	s2,48(sp)
    80004580:	79a2                	ld	s3,40(sp)
    80004582:	7a02                	ld	s4,32(sp)
    80004584:	6ae2                	ld	s5,24(sp)
    80004586:	6161                	addi	sp,sp,80
    80004588:	8082                	ret
    iunlockput(ip);
    8000458a:	8526                	mv	a0,s1
    8000458c:	fffff097          	auipc	ra,0xfffff
    80004590:	898080e7          	jalr	-1896(ra) # 80002e24 <iunlockput>
    return 0;
    80004594:	4481                	li	s1,0
    80004596:	b7c5                	j	80004576 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004598:	85ce                	mv	a1,s3
    8000459a:	00092503          	lw	a0,0(s2)
    8000459e:	ffffe097          	auipc	ra,0xffffe
    800045a2:	48c080e7          	jalr	1164(ra) # 80002a2a <ialloc>
    800045a6:	84aa                	mv	s1,a0
    800045a8:	c521                	beqz	a0,800045f0 <create+0xec>
  ilock(ip);
    800045aa:	ffffe097          	auipc	ra,0xffffe
    800045ae:	618080e7          	jalr	1560(ra) # 80002bc2 <ilock>
  ip->major = major;
    800045b2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045b6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045ba:	4a05                	li	s4,1
    800045bc:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045c0:	8526                	mv	a0,s1
    800045c2:	ffffe097          	auipc	ra,0xffffe
    800045c6:	536080e7          	jalr	1334(ra) # 80002af8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ca:	2981                	sext.w	s3,s3
    800045cc:	03498a63          	beq	s3,s4,80004600 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d0:	40d0                	lw	a2,4(s1)
    800045d2:	fb040593          	addi	a1,s0,-80
    800045d6:	854a                	mv	a0,s2
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	cde080e7          	jalr	-802(ra) # 800032b6 <dirlink>
    800045e0:	06054b63          	bltz	a0,80004656 <create+0x152>
  iunlockput(dp);
    800045e4:	854a                	mv	a0,s2
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	83e080e7          	jalr	-1986(ra) # 80002e24 <iunlockput>
  return ip;
    800045ee:	b761                	j	80004576 <create+0x72>
    panic("create: ialloc");
    800045f0:	00004517          	auipc	a0,0x4
    800045f4:	08850513          	addi	a0,a0,136 # 80008678 <syscalls+0x2b0>
    800045f8:	00001097          	auipc	ra,0x1
    800045fc:	6ca080e7          	jalr	1738(ra) # 80005cc2 <panic>
    dp->nlink++;  // for ".."
    80004600:	04a95783          	lhu	a5,74(s2)
    80004604:	2785                	addiw	a5,a5,1
    80004606:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000460a:	854a                	mv	a0,s2
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	4ec080e7          	jalr	1260(ra) # 80002af8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004614:	40d0                	lw	a2,4(s1)
    80004616:	00004597          	auipc	a1,0x4
    8000461a:	07258593          	addi	a1,a1,114 # 80008688 <syscalls+0x2c0>
    8000461e:	8526                	mv	a0,s1
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	c96080e7          	jalr	-874(ra) # 800032b6 <dirlink>
    80004628:	00054f63          	bltz	a0,80004646 <create+0x142>
    8000462c:	00492603          	lw	a2,4(s2)
    80004630:	00004597          	auipc	a1,0x4
    80004634:	06058593          	addi	a1,a1,96 # 80008690 <syscalls+0x2c8>
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	c7c080e7          	jalr	-900(ra) # 800032b6 <dirlink>
    80004642:	f80557e3          	bgez	a0,800045d0 <create+0xcc>
      panic("create dots");
    80004646:	00004517          	auipc	a0,0x4
    8000464a:	05250513          	addi	a0,a0,82 # 80008698 <syscalls+0x2d0>
    8000464e:	00001097          	auipc	ra,0x1
    80004652:	674080e7          	jalr	1652(ra) # 80005cc2 <panic>
    panic("create: dirlink");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	05250513          	addi	a0,a0,82 # 800086a8 <syscalls+0x2e0>
    8000465e:	00001097          	auipc	ra,0x1
    80004662:	664080e7          	jalr	1636(ra) # 80005cc2 <panic>
    return 0;
    80004666:	84aa                	mv	s1,a0
    80004668:	b739                	j	80004576 <create+0x72>

000000008000466a <sys_dup>:
{
    8000466a:	7179                	addi	sp,sp,-48
    8000466c:	f406                	sd	ra,40(sp)
    8000466e:	f022                	sd	s0,32(sp)
    80004670:	ec26                	sd	s1,24(sp)
    80004672:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004674:	fd840613          	addi	a2,s0,-40
    80004678:	4581                	li	a1,0
    8000467a:	4501                	li	a0,0
    8000467c:	00000097          	auipc	ra,0x0
    80004680:	dde080e7          	jalr	-546(ra) # 8000445a <argfd>
    return -1;
    80004684:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004686:	02054363          	bltz	a0,800046ac <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000468a:	fd843503          	ld	a0,-40(s0)
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	e34080e7          	jalr	-460(ra) # 800044c2 <fdalloc>
    80004696:	84aa                	mv	s1,a0
    return -1;
    80004698:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000469a:	00054963          	bltz	a0,800046ac <sys_dup+0x42>
  filedup(f);
    8000469e:	fd843503          	ld	a0,-40(s0)
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	36c080e7          	jalr	876(ra) # 80003a0e <filedup>
  return fd;
    800046aa:	87a6                	mv	a5,s1
}
    800046ac:	853e                	mv	a0,a5
    800046ae:	70a2                	ld	ra,40(sp)
    800046b0:	7402                	ld	s0,32(sp)
    800046b2:	64e2                	ld	s1,24(sp)
    800046b4:	6145                	addi	sp,sp,48
    800046b6:	8082                	ret

00000000800046b8 <sys_read>:
{
    800046b8:	7179                	addi	sp,sp,-48
    800046ba:	f406                	sd	ra,40(sp)
    800046bc:	f022                	sd	s0,32(sp)
    800046be:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c0:	fe840613          	addi	a2,s0,-24
    800046c4:	4581                	li	a1,0
    800046c6:	4501                	li	a0,0
    800046c8:	00000097          	auipc	ra,0x0
    800046cc:	d92080e7          	jalr	-622(ra) # 8000445a <argfd>
    return -1;
    800046d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	04054163          	bltz	a0,80004714 <sys_read+0x5c>
    800046d6:	fe440593          	addi	a1,s0,-28
    800046da:	4509                	li	a0,2
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	8bc080e7          	jalr	-1860(ra) # 80001f98 <argint>
    return -1;
    800046e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e6:	02054763          	bltz	a0,80004714 <sys_read+0x5c>
    800046ea:	fd840593          	addi	a1,s0,-40
    800046ee:	4505                	li	a0,1
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	8ca080e7          	jalr	-1846(ra) # 80001fba <argaddr>
    return -1;
    800046f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	00054d63          	bltz	a0,80004714 <sys_read+0x5c>
  return fileread(f, p, n);
    800046fe:	fe442603          	lw	a2,-28(s0)
    80004702:	fd843583          	ld	a1,-40(s0)
    80004706:	fe843503          	ld	a0,-24(s0)
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	490080e7          	jalr	1168(ra) # 80003b9a <fileread>
    80004712:	87aa                	mv	a5,a0
}
    80004714:	853e                	mv	a0,a5
    80004716:	70a2                	ld	ra,40(sp)
    80004718:	7402                	ld	s0,32(sp)
    8000471a:	6145                	addi	sp,sp,48
    8000471c:	8082                	ret

000000008000471e <sys_write>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004726:	fe840613          	addi	a2,s0,-24
    8000472a:	4581                	li	a1,0
    8000472c:	4501                	li	a0,0
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	d2c080e7          	jalr	-724(ra) # 8000445a <argfd>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	04054163          	bltz	a0,8000477a <sys_write+0x5c>
    8000473c:	fe440593          	addi	a1,s0,-28
    80004740:	4509                	li	a0,2
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	856080e7          	jalr	-1962(ra) # 80001f98 <argint>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474c:	02054763          	bltz	a0,8000477a <sys_write+0x5c>
    80004750:	fd840593          	addi	a1,s0,-40
    80004754:	4505                	li	a0,1
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	864080e7          	jalr	-1948(ra) # 80001fba <argaddr>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004760:	00054d63          	bltz	a0,8000477a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004764:	fe442603          	lw	a2,-28(s0)
    80004768:	fd843583          	ld	a1,-40(s0)
    8000476c:	fe843503          	ld	a0,-24(s0)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	4ec080e7          	jalr	1260(ra) # 80003c5c <filewrite>
    80004778:	87aa                	mv	a5,a0
}
    8000477a:	853e                	mv	a0,a5
    8000477c:	70a2                	ld	ra,40(sp)
    8000477e:	7402                	ld	s0,32(sp)
    80004780:	6145                	addi	sp,sp,48
    80004782:	8082                	ret

0000000080004784 <sys_close>:
{
    80004784:	1101                	addi	sp,sp,-32
    80004786:	ec06                	sd	ra,24(sp)
    80004788:	e822                	sd	s0,16(sp)
    8000478a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000478c:	fe040613          	addi	a2,s0,-32
    80004790:	fec40593          	addi	a1,s0,-20
    80004794:	4501                	li	a0,0
    80004796:	00000097          	auipc	ra,0x0
    8000479a:	cc4080e7          	jalr	-828(ra) # 8000445a <argfd>
    return -1;
    8000479e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a0:	02054463          	bltz	a0,800047c8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	69e080e7          	jalr	1694(ra) # 80000e42 <myproc>
    800047ac:	fec42783          	lw	a5,-20(s0)
    800047b0:	07e9                	addi	a5,a5,26
    800047b2:	078e                	slli	a5,a5,0x3
    800047b4:	97aa                	add	a5,a5,a0
    800047b6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047ba:	fe043503          	ld	a0,-32(s0)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	2a2080e7          	jalr	674(ra) # 80003a60 <fileclose>
  return 0;
    800047c6:	4781                	li	a5,0
}
    800047c8:	853e                	mv	a0,a5
    800047ca:	60e2                	ld	ra,24(sp)
    800047cc:	6442                	ld	s0,16(sp)
    800047ce:	6105                	addi	sp,sp,32
    800047d0:	8082                	ret

00000000800047d2 <sys_fstat>:
{
    800047d2:	1101                	addi	sp,sp,-32
    800047d4:	ec06                	sd	ra,24(sp)
    800047d6:	e822                	sd	s0,16(sp)
    800047d8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	c78080e7          	jalr	-904(ra) # 8000445a <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ec:	02054563          	bltz	a0,80004816 <sys_fstat+0x44>
    800047f0:	fe040593          	addi	a1,s0,-32
    800047f4:	4505                	li	a0,1
    800047f6:	ffffd097          	auipc	ra,0xffffd
    800047fa:	7c4080e7          	jalr	1988(ra) # 80001fba <argaddr>
    return -1;
    800047fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004800:	00054b63          	bltz	a0,80004816 <sys_fstat+0x44>
  return filestat(f, st);
    80004804:	fe043583          	ld	a1,-32(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	31c080e7          	jalr	796(ra) # 80003b28 <filestat>
    80004814:	87aa                	mv	a5,a0
}
    80004816:	853e                	mv	a0,a5
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	6105                	addi	sp,sp,32
    8000481e:	8082                	ret

0000000080004820 <sys_link>:
{
    80004820:	7169                	addi	sp,sp,-304
    80004822:	f606                	sd	ra,296(sp)
    80004824:	f222                	sd	s0,288(sp)
    80004826:	ee26                	sd	s1,280(sp)
    80004828:	ea4a                	sd	s2,272(sp)
    8000482a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482c:	08000613          	li	a2,128
    80004830:	ed040593          	addi	a1,s0,-304
    80004834:	4501                	li	a0,0
    80004836:	ffffd097          	auipc	ra,0xffffd
    8000483a:	7a6080e7          	jalr	1958(ra) # 80001fdc <argstr>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004840:	10054e63          	bltz	a0,8000495c <sys_link+0x13c>
    80004844:	08000613          	li	a2,128
    80004848:	f5040593          	addi	a1,s0,-176
    8000484c:	4505                	li	a0,1
    8000484e:	ffffd097          	auipc	ra,0xffffd
    80004852:	78e080e7          	jalr	1934(ra) # 80001fdc <argstr>
    return -1;
    80004856:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004858:	10054263          	bltz	a0,8000495c <sys_link+0x13c>
  begin_op();
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	d38080e7          	jalr	-712(ra) # 80003594 <begin_op>
  if((ip = namei(old)) == 0){
    80004864:	ed040513          	addi	a0,s0,-304
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	b10080e7          	jalr	-1264(ra) # 80003378 <namei>
    80004870:	84aa                	mv	s1,a0
    80004872:	c551                	beqz	a0,800048fe <sys_link+0xde>
  ilock(ip);
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	34e080e7          	jalr	846(ra) # 80002bc2 <ilock>
  if(ip->type == T_DIR){
    8000487c:	04449703          	lh	a4,68(s1)
    80004880:	4785                	li	a5,1
    80004882:	08f70463          	beq	a4,a5,8000490a <sys_link+0xea>
  ip->nlink++;
    80004886:	04a4d783          	lhu	a5,74(s1)
    8000488a:	2785                	addiw	a5,a5,1
    8000488c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	266080e7          	jalr	614(ra) # 80002af8 <iupdate>
  iunlock(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	3e8080e7          	jalr	1000(ra) # 80002c84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a4:	fd040593          	addi	a1,s0,-48
    800048a8:	f5040513          	addi	a0,s0,-176
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	aea080e7          	jalr	-1302(ra) # 80003396 <nameiparent>
    800048b4:	892a                	mv	s2,a0
    800048b6:	c935                	beqz	a0,8000492a <sys_link+0x10a>
  ilock(dp);
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	30a080e7          	jalr	778(ra) # 80002bc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c0:	00092703          	lw	a4,0(s2)
    800048c4:	409c                	lw	a5,0(s1)
    800048c6:	04f71d63          	bne	a4,a5,80004920 <sys_link+0x100>
    800048ca:	40d0                	lw	a2,4(s1)
    800048cc:	fd040593          	addi	a1,s0,-48
    800048d0:	854a                	mv	a0,s2
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	9e4080e7          	jalr	-1564(ra) # 800032b6 <dirlink>
    800048da:	04054363          	bltz	a0,80004920 <sys_link+0x100>
  iunlockput(dp);
    800048de:	854a                	mv	a0,s2
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	544080e7          	jalr	1348(ra) # 80002e24 <iunlockput>
  iput(ip);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	492080e7          	jalr	1170(ra) # 80002d7c <iput>
  end_op();
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	d22080e7          	jalr	-734(ra) # 80003614 <end_op>
  return 0;
    800048fa:	4781                	li	a5,0
    800048fc:	a085                	j	8000495c <sys_link+0x13c>
    end_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	d16080e7          	jalr	-746(ra) # 80003614 <end_op>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a891                	j	8000495c <sys_link+0x13c>
    iunlockput(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	518080e7          	jalr	1304(ra) # 80002e24 <iunlockput>
    end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	d00080e7          	jalr	-768(ra) # 80003614 <end_op>
    return -1;
    8000491c:	57fd                	li	a5,-1
    8000491e:	a83d                	j	8000495c <sys_link+0x13c>
    iunlockput(dp);
    80004920:	854a                	mv	a0,s2
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	502080e7          	jalr	1282(ra) # 80002e24 <iunlockput>
  ilock(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	296080e7          	jalr	662(ra) # 80002bc2 <ilock>
  ip->nlink--;
    80004934:	04a4d783          	lhu	a5,74(s1)
    80004938:	37fd                	addiw	a5,a5,-1
    8000493a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493e:	8526                	mv	a0,s1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	1b8080e7          	jalr	440(ra) # 80002af8 <iupdate>
  iunlockput(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	4da080e7          	jalr	1242(ra) # 80002e24 <iunlockput>
  end_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	cc2080e7          	jalr	-830(ra) # 80003614 <end_op>
  return -1;
    8000495a:	57fd                	li	a5,-1
}
    8000495c:	853e                	mv	a0,a5
    8000495e:	70b2                	ld	ra,296(sp)
    80004960:	7412                	ld	s0,288(sp)
    80004962:	64f2                	ld	s1,280(sp)
    80004964:	6952                	ld	s2,272(sp)
    80004966:	6155                	addi	sp,sp,304
    80004968:	8082                	ret

000000008000496a <sys_unlink>:
{
    8000496a:	7151                	addi	sp,sp,-240
    8000496c:	f586                	sd	ra,232(sp)
    8000496e:	f1a2                	sd	s0,224(sp)
    80004970:	eda6                	sd	s1,216(sp)
    80004972:	e9ca                	sd	s2,208(sp)
    80004974:	e5ce                	sd	s3,200(sp)
    80004976:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004978:	08000613          	li	a2,128
    8000497c:	f3040593          	addi	a1,s0,-208
    80004980:	4501                	li	a0,0
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	65a080e7          	jalr	1626(ra) # 80001fdc <argstr>
    8000498a:	18054163          	bltz	a0,80004b0c <sys_unlink+0x1a2>
  begin_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	c06080e7          	jalr	-1018(ra) # 80003594 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004996:	fb040593          	addi	a1,s0,-80
    8000499a:	f3040513          	addi	a0,s0,-208
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	9f8080e7          	jalr	-1544(ra) # 80003396 <nameiparent>
    800049a6:	84aa                	mv	s1,a0
    800049a8:	c979                	beqz	a0,80004a7e <sys_unlink+0x114>
  ilock(dp);
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	218080e7          	jalr	536(ra) # 80002bc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b2:	00004597          	auipc	a1,0x4
    800049b6:	cd658593          	addi	a1,a1,-810 # 80008688 <syscalls+0x2c0>
    800049ba:	fb040513          	addi	a0,s0,-80
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	6ce080e7          	jalr	1742(ra) # 8000308c <namecmp>
    800049c6:	14050a63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
    800049ca:	00004597          	auipc	a1,0x4
    800049ce:	cc658593          	addi	a1,a1,-826 # 80008690 <syscalls+0x2c8>
    800049d2:	fb040513          	addi	a0,s0,-80
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	6b6080e7          	jalr	1718(ra) # 8000308c <namecmp>
    800049de:	12050e63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e2:	f2c40613          	addi	a2,s0,-212
    800049e6:	fb040593          	addi	a1,s0,-80
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	6ba080e7          	jalr	1722(ra) # 800030a6 <dirlookup>
    800049f4:	892a                	mv	s2,a0
    800049f6:	12050263          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  ilock(ip);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	1c8080e7          	jalr	456(ra) # 80002bc2 <ilock>
  if(ip->nlink < 1)
    80004a02:	04a91783          	lh	a5,74(s2)
    80004a06:	08f05263          	blez	a5,80004a8a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a0a:	04491703          	lh	a4,68(s2)
    80004a0e:	4785                	li	a5,1
    80004a10:	08f70563          	beq	a4,a5,80004a9a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a14:	4641                	li	a2,16
    80004a16:	4581                	li	a1,0
    80004a18:	fc040513          	addi	a0,s0,-64
    80004a1c:	ffffb097          	auipc	ra,0xffffb
    80004a20:	75c080e7          	jalr	1884(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a24:	4741                	li	a4,16
    80004a26:	f2c42683          	lw	a3,-212(s0)
    80004a2a:	fc040613          	addi	a2,s0,-64
    80004a2e:	4581                	li	a1,0
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	53c080e7          	jalr	1340(ra) # 80002f6e <writei>
    80004a3a:	47c1                	li	a5,16
    80004a3c:	0af51563          	bne	a0,a5,80004ae6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a40:	04491703          	lh	a4,68(s2)
    80004a44:	4785                	li	a5,1
    80004a46:	0af70863          	beq	a4,a5,80004af6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	3d8080e7          	jalr	984(ra) # 80002e24 <iunlockput>
  ip->nlink--;
    80004a54:	04a95783          	lhu	a5,74(s2)
    80004a58:	37fd                	addiw	a5,a5,-1
    80004a5a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	098080e7          	jalr	152(ra) # 80002af8 <iupdate>
  iunlockput(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3ba080e7          	jalr	954(ra) # 80002e24 <iunlockput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	ba2080e7          	jalr	-1118(ra) # 80003614 <end_op>
  return 0;
    80004a7a:	4501                	li	a0,0
    80004a7c:	a84d                	j	80004b2e <sys_unlink+0x1c4>
    end_op();
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	b96080e7          	jalr	-1130(ra) # 80003614 <end_op>
    return -1;
    80004a86:	557d                	li	a0,-1
    80004a88:	a05d                	j	80004b2e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a8a:	00004517          	auipc	a0,0x4
    80004a8e:	c2e50513          	addi	a0,a0,-978 # 800086b8 <syscalls+0x2f0>
    80004a92:	00001097          	auipc	ra,0x1
    80004a96:	230080e7          	jalr	560(ra) # 80005cc2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9a:	04c92703          	lw	a4,76(s2)
    80004a9e:	02000793          	li	a5,32
    80004aa2:	f6e7f9e3          	bgeu	a5,a4,80004a14 <sys_unlink+0xaa>
    80004aa6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aaa:	4741                	li	a4,16
    80004aac:	86ce                	mv	a3,s3
    80004aae:	f1840613          	addi	a2,s0,-232
    80004ab2:	4581                	li	a1,0
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	3c0080e7          	jalr	960(ra) # 80002e76 <readi>
    80004abe:	47c1                	li	a5,16
    80004ac0:	00f51b63          	bne	a0,a5,80004ad6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ac4:	f1845783          	lhu	a5,-232(s0)
    80004ac8:	e7a1                	bnez	a5,80004b10 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aca:	29c1                	addiw	s3,s3,16
    80004acc:	04c92783          	lw	a5,76(s2)
    80004ad0:	fcf9ede3          	bltu	s3,a5,80004aaa <sys_unlink+0x140>
    80004ad4:	b781                	j	80004a14 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ad6:	00004517          	auipc	a0,0x4
    80004ada:	bfa50513          	addi	a0,a0,-1030 # 800086d0 <syscalls+0x308>
    80004ade:	00001097          	auipc	ra,0x1
    80004ae2:	1e4080e7          	jalr	484(ra) # 80005cc2 <panic>
    panic("unlink: writei");
    80004ae6:	00004517          	auipc	a0,0x4
    80004aea:	c0250513          	addi	a0,a0,-1022 # 800086e8 <syscalls+0x320>
    80004aee:	00001097          	auipc	ra,0x1
    80004af2:	1d4080e7          	jalr	468(ra) # 80005cc2 <panic>
    dp->nlink--;
    80004af6:	04a4d783          	lhu	a5,74(s1)
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	ff6080e7          	jalr	-10(ra) # 80002af8 <iupdate>
    80004b0a:	b781                	j	80004a4a <sys_unlink+0xe0>
    return -1;
    80004b0c:	557d                	li	a0,-1
    80004b0e:	a005                	j	80004b2e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b10:	854a                	mv	a0,s2
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	312080e7          	jalr	786(ra) # 80002e24 <iunlockput>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	308080e7          	jalr	776(ra) # 80002e24 <iunlockput>
  end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	af0080e7          	jalr	-1296(ra) # 80003614 <end_op>
  return -1;
    80004b2c:	557d                	li	a0,-1
}
    80004b2e:	70ae                	ld	ra,232(sp)
    80004b30:	740e                	ld	s0,224(sp)
    80004b32:	64ee                	ld	s1,216(sp)
    80004b34:	694e                	ld	s2,208(sp)
    80004b36:	69ae                	ld	s3,200(sp)
    80004b38:	616d                	addi	sp,sp,240
    80004b3a:	8082                	ret

0000000080004b3c <sys_open>:

uint64
sys_open(void)
{
    80004b3c:	7131                	addi	sp,sp,-192
    80004b3e:	fd06                	sd	ra,184(sp)
    80004b40:	f922                	sd	s0,176(sp)
    80004b42:	f526                	sd	s1,168(sp)
    80004b44:	f14a                	sd	s2,160(sp)
    80004b46:	ed4e                	sd	s3,152(sp)
    80004b48:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b4a:	08000613          	li	a2,128
    80004b4e:	f5040593          	addi	a1,s0,-176
    80004b52:	4501                	li	a0,0
    80004b54:	ffffd097          	auipc	ra,0xffffd
    80004b58:	488080e7          	jalr	1160(ra) # 80001fdc <argstr>
    return -1;
    80004b5c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5e:	0c054163          	bltz	a0,80004c20 <sys_open+0xe4>
    80004b62:	f4c40593          	addi	a1,s0,-180
    80004b66:	4505                	li	a0,1
    80004b68:	ffffd097          	auipc	ra,0xffffd
    80004b6c:	430080e7          	jalr	1072(ra) # 80001f98 <argint>
    80004b70:	0a054863          	bltz	a0,80004c20 <sys_open+0xe4>

  begin_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	a20080e7          	jalr	-1504(ra) # 80003594 <begin_op>

  if(omode & O_CREATE){
    80004b7c:	f4c42783          	lw	a5,-180(s0)
    80004b80:	2007f793          	andi	a5,a5,512
    80004b84:	cbdd                	beqz	a5,80004c3a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b86:	4681                	li	a3,0
    80004b88:	4601                	li	a2,0
    80004b8a:	4589                	li	a1,2
    80004b8c:	f5040513          	addi	a0,s0,-176
    80004b90:	00000097          	auipc	ra,0x0
    80004b94:	974080e7          	jalr	-1676(ra) # 80004504 <create>
    80004b98:	892a                	mv	s2,a0
    if(ip == 0){
    80004b9a:	c959                	beqz	a0,80004c30 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b9c:	04491703          	lh	a4,68(s2)
    80004ba0:	478d                	li	a5,3
    80004ba2:	00f71763          	bne	a4,a5,80004bb0 <sys_open+0x74>
    80004ba6:	04695703          	lhu	a4,70(s2)
    80004baa:	47a5                	li	a5,9
    80004bac:	0ce7ec63          	bltu	a5,a4,80004c84 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	df4080e7          	jalr	-524(ra) # 800039a4 <filealloc>
    80004bb8:	89aa                	mv	s3,a0
    80004bba:	10050263          	beqz	a0,80004cbe <sys_open+0x182>
    80004bbe:	00000097          	auipc	ra,0x0
    80004bc2:	904080e7          	jalr	-1788(ra) # 800044c2 <fdalloc>
    80004bc6:	84aa                	mv	s1,a0
    80004bc8:	0e054663          	bltz	a0,80004cb4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bcc:	04491703          	lh	a4,68(s2)
    80004bd0:	478d                	li	a5,3
    80004bd2:	0cf70463          	beq	a4,a5,80004c9a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bd6:	4789                	li	a5,2
    80004bd8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bdc:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004be0:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004be4:	f4c42783          	lw	a5,-180(s0)
    80004be8:	0017c713          	xori	a4,a5,1
    80004bec:	8b05                	andi	a4,a4,1
    80004bee:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bf2:	0037f713          	andi	a4,a5,3
    80004bf6:	00e03733          	snez	a4,a4
    80004bfa:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bfe:	4007f793          	andi	a5,a5,1024
    80004c02:	c791                	beqz	a5,80004c0e <sys_open+0xd2>
    80004c04:	04491703          	lh	a4,68(s2)
    80004c08:	4789                	li	a5,2
    80004c0a:	08f70f63          	beq	a4,a5,80004ca8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	074080e7          	jalr	116(ra) # 80002c84 <iunlock>
  end_op();
    80004c18:	fffff097          	auipc	ra,0xfffff
    80004c1c:	9fc080e7          	jalr	-1540(ra) # 80003614 <end_op>

  return fd;
}
    80004c20:	8526                	mv	a0,s1
    80004c22:	70ea                	ld	ra,184(sp)
    80004c24:	744a                	ld	s0,176(sp)
    80004c26:	74aa                	ld	s1,168(sp)
    80004c28:	790a                	ld	s2,160(sp)
    80004c2a:	69ea                	ld	s3,152(sp)
    80004c2c:	6129                	addi	sp,sp,192
    80004c2e:	8082                	ret
      end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	9e4080e7          	jalr	-1564(ra) # 80003614 <end_op>
      return -1;
    80004c38:	b7e5                	j	80004c20 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c3a:	f5040513          	addi	a0,s0,-176
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	73a080e7          	jalr	1850(ra) # 80003378 <namei>
    80004c46:	892a                	mv	s2,a0
    80004c48:	c905                	beqz	a0,80004c78 <sys_open+0x13c>
    ilock(ip);
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	f78080e7          	jalr	-136(ra) # 80002bc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c52:	04491703          	lh	a4,68(s2)
    80004c56:	4785                	li	a5,1
    80004c58:	f4f712e3          	bne	a4,a5,80004b9c <sys_open+0x60>
    80004c5c:	f4c42783          	lw	a5,-180(s0)
    80004c60:	dba1                	beqz	a5,80004bb0 <sys_open+0x74>
      iunlockput(ip);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	1c0080e7          	jalr	448(ra) # 80002e24 <iunlockput>
      end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	9a8080e7          	jalr	-1624(ra) # 80003614 <end_op>
      return -1;
    80004c74:	54fd                	li	s1,-1
    80004c76:	b76d                	j	80004c20 <sys_open+0xe4>
      end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	99c080e7          	jalr	-1636(ra) # 80003614 <end_op>
      return -1;
    80004c80:	54fd                	li	s1,-1
    80004c82:	bf79                	j	80004c20 <sys_open+0xe4>
    iunlockput(ip);
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	19e080e7          	jalr	414(ra) # 80002e24 <iunlockput>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	986080e7          	jalr	-1658(ra) # 80003614 <end_op>
    return -1;
    80004c96:	54fd                	li	s1,-1
    80004c98:	b761                	j	80004c20 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c9a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c9e:	04691783          	lh	a5,70(s2)
    80004ca2:	02f99223          	sh	a5,36(s3)
    80004ca6:	bf2d                	j	80004be0 <sys_open+0xa4>
    itrunc(ip);
    80004ca8:	854a                	mv	a0,s2
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	026080e7          	jalr	38(ra) # 80002cd0 <itrunc>
    80004cb2:	bfb1                	j	80004c0e <sys_open+0xd2>
      fileclose(f);
    80004cb4:	854e                	mv	a0,s3
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	daa080e7          	jalr	-598(ra) # 80003a60 <fileclose>
    iunlockput(ip);
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	164080e7          	jalr	356(ra) # 80002e24 <iunlockput>
    end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	94c080e7          	jalr	-1716(ra) # 80003614 <end_op>
    return -1;
    80004cd0:	54fd                	li	s1,-1
    80004cd2:	b7b9                	j	80004c20 <sys_open+0xe4>

0000000080004cd4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cd4:	7175                	addi	sp,sp,-144
    80004cd6:	e506                	sd	ra,136(sp)
    80004cd8:	e122                	sd	s0,128(sp)
    80004cda:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	8b8080e7          	jalr	-1864(ra) # 80003594 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ce4:	08000613          	li	a2,128
    80004ce8:	f7040593          	addi	a1,s0,-144
    80004cec:	4501                	li	a0,0
    80004cee:	ffffd097          	auipc	ra,0xffffd
    80004cf2:	2ee080e7          	jalr	750(ra) # 80001fdc <argstr>
    80004cf6:	02054963          	bltz	a0,80004d28 <sys_mkdir+0x54>
    80004cfa:	4681                	li	a3,0
    80004cfc:	4601                	li	a2,0
    80004cfe:	4585                	li	a1,1
    80004d00:	f7040513          	addi	a0,s0,-144
    80004d04:	00000097          	auipc	ra,0x0
    80004d08:	800080e7          	jalr	-2048(ra) # 80004504 <create>
    80004d0c:	cd11                	beqz	a0,80004d28 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	116080e7          	jalr	278(ra) # 80002e24 <iunlockput>
  end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	8fe080e7          	jalr	-1794(ra) # 80003614 <end_op>
  return 0;
    80004d1e:	4501                	li	a0,0
}
    80004d20:	60aa                	ld	ra,136(sp)
    80004d22:	640a                	ld	s0,128(sp)
    80004d24:	6149                	addi	sp,sp,144
    80004d26:	8082                	ret
    end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	8ec080e7          	jalr	-1812(ra) # 80003614 <end_op>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	b7fd                	j	80004d20 <sys_mkdir+0x4c>

0000000080004d34 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d34:	7135                	addi	sp,sp,-160
    80004d36:	ed06                	sd	ra,152(sp)
    80004d38:	e922                	sd	s0,144(sp)
    80004d3a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	858080e7          	jalr	-1960(ra) # 80003594 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d44:	08000613          	li	a2,128
    80004d48:	f7040593          	addi	a1,s0,-144
    80004d4c:	4501                	li	a0,0
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	28e080e7          	jalr	654(ra) # 80001fdc <argstr>
    80004d56:	04054a63          	bltz	a0,80004daa <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d5a:	f6c40593          	addi	a1,s0,-148
    80004d5e:	4505                	li	a0,1
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	238080e7          	jalr	568(ra) # 80001f98 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d68:	04054163          	bltz	a0,80004daa <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d6c:	f6840593          	addi	a1,s0,-152
    80004d70:	4509                	li	a0,2
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	226080e7          	jalr	550(ra) # 80001f98 <argint>
     argint(1, &major) < 0 ||
    80004d7a:	02054863          	bltz	a0,80004daa <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d7e:	f6841683          	lh	a3,-152(s0)
    80004d82:	f6c41603          	lh	a2,-148(s0)
    80004d86:	458d                	li	a1,3
    80004d88:	f7040513          	addi	a0,s0,-144
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	778080e7          	jalr	1912(ra) # 80004504 <create>
     argint(2, &minor) < 0 ||
    80004d94:	c919                	beqz	a0,80004daa <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	08e080e7          	jalr	142(ra) # 80002e24 <iunlockput>
  end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	876080e7          	jalr	-1930(ra) # 80003614 <end_op>
  return 0;
    80004da6:	4501                	li	a0,0
    80004da8:	a031                	j	80004db4 <sys_mknod+0x80>
    end_op();
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	86a080e7          	jalr	-1942(ra) # 80003614 <end_op>
    return -1;
    80004db2:	557d                	li	a0,-1
}
    80004db4:	60ea                	ld	ra,152(sp)
    80004db6:	644a                	ld	s0,144(sp)
    80004db8:	610d                	addi	sp,sp,160
    80004dba:	8082                	ret

0000000080004dbc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dbc:	7135                	addi	sp,sp,-160
    80004dbe:	ed06                	sd	ra,152(sp)
    80004dc0:	e922                	sd	s0,144(sp)
    80004dc2:	e526                	sd	s1,136(sp)
    80004dc4:	e14a                	sd	s2,128(sp)
    80004dc6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	07a080e7          	jalr	122(ra) # 80000e42 <myproc>
    80004dd0:	892a                	mv	s2,a0
  
  begin_op();
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	7c2080e7          	jalr	1986(ra) # 80003594 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dda:	08000613          	li	a2,128
    80004dde:	f6040593          	addi	a1,s0,-160
    80004de2:	4501                	li	a0,0
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	1f8080e7          	jalr	504(ra) # 80001fdc <argstr>
    80004dec:	04054b63          	bltz	a0,80004e42 <sys_chdir+0x86>
    80004df0:	f6040513          	addi	a0,s0,-160
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	584080e7          	jalr	1412(ra) # 80003378 <namei>
    80004dfc:	84aa                	mv	s1,a0
    80004dfe:	c131                	beqz	a0,80004e42 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	dc2080e7          	jalr	-574(ra) # 80002bc2 <ilock>
  if(ip->type != T_DIR){
    80004e08:	04449703          	lh	a4,68(s1)
    80004e0c:	4785                	li	a5,1
    80004e0e:	04f71063          	bne	a4,a5,80004e4e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e12:	8526                	mv	a0,s1
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	e70080e7          	jalr	-400(ra) # 80002c84 <iunlock>
  iput(p->cwd);
    80004e1c:	15093503          	ld	a0,336(s2)
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	f5c080e7          	jalr	-164(ra) # 80002d7c <iput>
  end_op();
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	7ec080e7          	jalr	2028(ra) # 80003614 <end_op>
  p->cwd = ip;
    80004e30:	14993823          	sd	s1,336(s2)
  return 0;
    80004e34:	4501                	li	a0,0
}
    80004e36:	60ea                	ld	ra,152(sp)
    80004e38:	644a                	ld	s0,144(sp)
    80004e3a:	64aa                	ld	s1,136(sp)
    80004e3c:	690a                	ld	s2,128(sp)
    80004e3e:	610d                	addi	sp,sp,160
    80004e40:	8082                	ret
    end_op();
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	7d2080e7          	jalr	2002(ra) # 80003614 <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	b7ed                	j	80004e36 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e4e:	8526                	mv	a0,s1
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	fd4080e7          	jalr	-44(ra) # 80002e24 <iunlockput>
    end_op();
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	7bc080e7          	jalr	1980(ra) # 80003614 <end_op>
    return -1;
    80004e60:	557d                	li	a0,-1
    80004e62:	bfd1                	j	80004e36 <sys_chdir+0x7a>

0000000080004e64 <sys_exec>:

uint64
sys_exec(void)
{
    80004e64:	7145                	addi	sp,sp,-464
    80004e66:	e786                	sd	ra,456(sp)
    80004e68:	e3a2                	sd	s0,448(sp)
    80004e6a:	ff26                	sd	s1,440(sp)
    80004e6c:	fb4a                	sd	s2,432(sp)
    80004e6e:	f74e                	sd	s3,424(sp)
    80004e70:	f352                	sd	s4,416(sp)
    80004e72:	ef56                	sd	s5,408(sp)
    80004e74:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e76:	08000613          	li	a2,128
    80004e7a:	f4040593          	addi	a1,s0,-192
    80004e7e:	4501                	li	a0,0
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	15c080e7          	jalr	348(ra) # 80001fdc <argstr>
    return -1;
    80004e88:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e8a:	0c054a63          	bltz	a0,80004f5e <sys_exec+0xfa>
    80004e8e:	e3840593          	addi	a1,s0,-456
    80004e92:	4505                	li	a0,1
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	126080e7          	jalr	294(ra) # 80001fba <argaddr>
    80004e9c:	0c054163          	bltz	a0,80004f5e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ea0:	10000613          	li	a2,256
    80004ea4:	4581                	li	a1,0
    80004ea6:	e4040513          	addi	a0,s0,-448
    80004eaa:	ffffb097          	auipc	ra,0xffffb
    80004eae:	2ce080e7          	jalr	718(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eb2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eb6:	89a6                	mv	s3,s1
    80004eb8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eba:	02000a13          	li	s4,32
    80004ebe:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ec2:	00391793          	slli	a5,s2,0x3
    80004ec6:	e3040593          	addi	a1,s0,-464
    80004eca:	e3843503          	ld	a0,-456(s0)
    80004ece:	953e                	add	a0,a0,a5
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	02e080e7          	jalr	46(ra) # 80001efe <fetchaddr>
    80004ed8:	02054a63          	bltz	a0,80004f0c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004edc:	e3043783          	ld	a5,-464(s0)
    80004ee0:	c3b9                	beqz	a5,80004f26 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ee2:	ffffb097          	auipc	ra,0xffffb
    80004ee6:	236080e7          	jalr	566(ra) # 80000118 <kalloc>
    80004eea:	85aa                	mv	a1,a0
    80004eec:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef0:	cd11                	beqz	a0,80004f0c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ef2:	6605                	lui	a2,0x1
    80004ef4:	e3043503          	ld	a0,-464(s0)
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	058080e7          	jalr	88(ra) # 80001f50 <fetchstr>
    80004f00:	00054663          	bltz	a0,80004f0c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f04:	0905                	addi	s2,s2,1
    80004f06:	09a1                	addi	s3,s3,8
    80004f08:	fb491be3          	bne	s2,s4,80004ebe <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0c:	10048913          	addi	s2,s1,256
    80004f10:	6088                	ld	a0,0(s1)
    80004f12:	c529                	beqz	a0,80004f5c <sys_exec+0xf8>
    kfree(argv[i]);
    80004f14:	ffffb097          	auipc	ra,0xffffb
    80004f18:	108080e7          	jalr	264(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1c:	04a1                	addi	s1,s1,8
    80004f1e:	ff2499e3          	bne	s1,s2,80004f10 <sys_exec+0xac>
  return -1;
    80004f22:	597d                	li	s2,-1
    80004f24:	a82d                	j	80004f5e <sys_exec+0xfa>
      argv[i] = 0;
    80004f26:	0a8e                	slli	s5,s5,0x3
    80004f28:	fc040793          	addi	a5,s0,-64
    80004f2c:	9abe                	add	s5,s5,a5
    80004f2e:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8c40>
  int ret = exec(path, argv);
    80004f32:	e4040593          	addi	a1,s0,-448
    80004f36:	f4040513          	addi	a0,s0,-192
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	178080e7          	jalr	376(ra) # 800040b2 <exec>
    80004f42:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f44:	10048993          	addi	s3,s1,256
    80004f48:	6088                	ld	a0,0(s1)
    80004f4a:	c911                	beqz	a0,80004f5e <sys_exec+0xfa>
    kfree(argv[i]);
    80004f4c:	ffffb097          	auipc	ra,0xffffb
    80004f50:	0d0080e7          	jalr	208(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f54:	04a1                	addi	s1,s1,8
    80004f56:	ff3499e3          	bne	s1,s3,80004f48 <sys_exec+0xe4>
    80004f5a:	a011                	j	80004f5e <sys_exec+0xfa>
  return -1;
    80004f5c:	597d                	li	s2,-1
}
    80004f5e:	854a                	mv	a0,s2
    80004f60:	60be                	ld	ra,456(sp)
    80004f62:	641e                	ld	s0,448(sp)
    80004f64:	74fa                	ld	s1,440(sp)
    80004f66:	795a                	ld	s2,432(sp)
    80004f68:	79ba                	ld	s3,424(sp)
    80004f6a:	7a1a                	ld	s4,416(sp)
    80004f6c:	6afa                	ld	s5,408(sp)
    80004f6e:	6179                	addi	sp,sp,464
    80004f70:	8082                	ret

0000000080004f72 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f72:	7139                	addi	sp,sp,-64
    80004f74:	fc06                	sd	ra,56(sp)
    80004f76:	f822                	sd	s0,48(sp)
    80004f78:	f426                	sd	s1,40(sp)
    80004f7a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	ec6080e7          	jalr	-314(ra) # 80000e42 <myproc>
    80004f84:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f86:	fd840593          	addi	a1,s0,-40
    80004f8a:	4501                	li	a0,0
    80004f8c:	ffffd097          	auipc	ra,0xffffd
    80004f90:	02e080e7          	jalr	46(ra) # 80001fba <argaddr>
    return -1;
    80004f94:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f96:	0e054063          	bltz	a0,80005076 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f9a:	fc840593          	addi	a1,s0,-56
    80004f9e:	fd040513          	addi	a0,s0,-48
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	dee080e7          	jalr	-530(ra) # 80003d90 <pipealloc>
    return -1;
    80004faa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fac:	0c054563          	bltz	a0,80005076 <sys_pipe+0x104>
  fd0 = -1;
    80004fb0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fb4:	fd043503          	ld	a0,-48(s0)
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	50a080e7          	jalr	1290(ra) # 800044c2 <fdalloc>
    80004fc0:	fca42223          	sw	a0,-60(s0)
    80004fc4:	08054c63          	bltz	a0,8000505c <sys_pipe+0xea>
    80004fc8:	fc843503          	ld	a0,-56(s0)
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	4f6080e7          	jalr	1270(ra) # 800044c2 <fdalloc>
    80004fd4:	fca42023          	sw	a0,-64(s0)
    80004fd8:	06054863          	bltz	a0,80005048 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fdc:	4691                	li	a3,4
    80004fde:	fc440613          	addi	a2,s0,-60
    80004fe2:	fd843583          	ld	a1,-40(s0)
    80004fe6:	68a8                	ld	a0,80(s1)
    80004fe8:	ffffc097          	auipc	ra,0xffffc
    80004fec:	b1a080e7          	jalr	-1254(ra) # 80000b02 <copyout>
    80004ff0:	02054063          	bltz	a0,80005010 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ff4:	4691                	li	a3,4
    80004ff6:	fc040613          	addi	a2,s0,-64
    80004ffa:	fd843583          	ld	a1,-40(s0)
    80004ffe:	0591                	addi	a1,a1,4
    80005000:	68a8                	ld	a0,80(s1)
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	b00080e7          	jalr	-1280(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000500a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500c:	06055563          	bgez	a0,80005076 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005010:	fc442783          	lw	a5,-60(s0)
    80005014:	07e9                	addi	a5,a5,26
    80005016:	078e                	slli	a5,a5,0x3
    80005018:	97a6                	add	a5,a5,s1
    8000501a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000501e:	fc042503          	lw	a0,-64(s0)
    80005022:	0569                	addi	a0,a0,26
    80005024:	050e                	slli	a0,a0,0x3
    80005026:	9526                	add	a0,a0,s1
    80005028:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000502c:	fd043503          	ld	a0,-48(s0)
    80005030:	fffff097          	auipc	ra,0xfffff
    80005034:	a30080e7          	jalr	-1488(ra) # 80003a60 <fileclose>
    fileclose(wf);
    80005038:	fc843503          	ld	a0,-56(s0)
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	a24080e7          	jalr	-1500(ra) # 80003a60 <fileclose>
    return -1;
    80005044:	57fd                	li	a5,-1
    80005046:	a805                	j	80005076 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005048:	fc442783          	lw	a5,-60(s0)
    8000504c:	0007c863          	bltz	a5,8000505c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005050:	01a78513          	addi	a0,a5,26
    80005054:	050e                	slli	a0,a0,0x3
    80005056:	9526                	add	a0,a0,s1
    80005058:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000505c:	fd043503          	ld	a0,-48(s0)
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	a00080e7          	jalr	-1536(ra) # 80003a60 <fileclose>
    fileclose(wf);
    80005068:	fc843503          	ld	a0,-56(s0)
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	9f4080e7          	jalr	-1548(ra) # 80003a60 <fileclose>
    return -1;
    80005074:	57fd                	li	a5,-1
}
    80005076:	853e                	mv	a0,a5
    80005078:	70e2                	ld	ra,56(sp)
    8000507a:	7442                	ld	s0,48(sp)
    8000507c:	74a2                	ld	s1,40(sp)
    8000507e:	6121                	addi	sp,sp,64
    80005080:	8082                	ret
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	cfbfc0ef          	jal	ra,80001dca <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	addi	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cae080e7          	jalr	-850(ra) # 80000e16 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	slliw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	slliw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	953e                	add	a0,a0,a5
    8000518c:	00052023          	sw	zero,0(a0)
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	addi	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	c76080e7          	jalr	-906(ra) # 80000e16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5179b          	slliw	a5,a0,0xd
    800051ac:	0c201537          	lui	a0,0xc201
    800051b0:	953e                	add	a0,a0,a5
  return irq;
}
    800051b2:	4148                	lw	a0,4(a0)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051bc:	1101                	addi	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	addi	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	c4e080e7          	jalr	-946(ra) # 80000e16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	slliw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e6:	1141                	addi	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	06a7c963          	blt	a5,a0,80005262 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00016797          	auipc	a5,0x16
    800051f8:	e0c78793          	addi	a5,a5,-500 # 8001b000 <disk>
    800051fc:	00a78733          	add	a4,a5,a0
    80005200:	6789                	lui	a5,0x2
    80005202:	97ba                	add	a5,a5,a4
    80005204:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005208:	e7ad                	bnez	a5,80005272 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000520a:	00451793          	slli	a5,a0,0x4
    8000520e:	00018717          	auipc	a4,0x18
    80005212:	df270713          	addi	a4,a4,-526 # 8001d000 <disk+0x2000>
    80005216:	6314                	ld	a3,0(a4)
    80005218:	96be                	add	a3,a3,a5
    8000521a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000521e:	6314                	ld	a3,0(a4)
    80005220:	96be                	add	a3,a3,a5
    80005222:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000522e:	6318                	ld	a4,0(a4)
    80005230:	97ba                	add	a5,a5,a4
    80005232:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005236:	00016797          	auipc	a5,0x16
    8000523a:	dca78793          	addi	a5,a5,-566 # 8001b000 <disk>
    8000523e:	97aa                	add	a5,a5,a0
    80005240:	6509                	lui	a0,0x2
    80005242:	953e                	add	a0,a0,a5
    80005244:	4785                	li	a5,1
    80005246:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000524a:	00018517          	auipc	a0,0x18
    8000524e:	dce50513          	addi	a0,a0,-562 # 8001d018 <disk+0x2018>
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	492080e7          	jalr	1170(ra) # 800016e4 <wakeup>
}
    8000525a:	60a2                	ld	ra,8(sp)
    8000525c:	6402                	ld	s0,0(sp)
    8000525e:	0141                	addi	sp,sp,16
    80005260:	8082                	ret
    panic("free_desc 1");
    80005262:	00003517          	auipc	a0,0x3
    80005266:	49650513          	addi	a0,a0,1174 # 800086f8 <syscalls+0x330>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	a58080e7          	jalr	-1448(ra) # 80005cc2 <panic>
    panic("free_desc 2");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	49650513          	addi	a0,a0,1174 # 80008708 <syscalls+0x340>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	a48080e7          	jalr	-1464(ra) # 80005cc2 <panic>

0000000080005282 <virtio_disk_init>:
{
    80005282:	1101                	addi	sp,sp,-32
    80005284:	ec06                	sd	ra,24(sp)
    80005286:	e822                	sd	s0,16(sp)
    80005288:	e426                	sd	s1,8(sp)
    8000528a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000528c:	00003597          	auipc	a1,0x3
    80005290:	48c58593          	addi	a1,a1,1164 # 80008718 <syscalls+0x350>
    80005294:	00018517          	auipc	a0,0x18
    80005298:	e9450513          	addi	a0,a0,-364 # 8001d128 <disk+0x2128>
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	ea8080e7          	jalr	-344(ra) # 80006144 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	4398                	lw	a4,0(a5)
    800052aa:	2701                	sext.w	a4,a4
    800052ac:	747277b7          	lui	a5,0x74727
    800052b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052b4:	0ef71163          	bne	a4,a5,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	43dc                	lw	a5,4(a5)
    800052be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c0:	4705                	li	a4,1
    800052c2:	0ce79a63          	bne	a5,a4,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	479c                	lw	a5,8(a5)
    800052cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ce:	4709                	li	a4,2
    800052d0:	0ce79363          	bne	a5,a4,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052d4:	100017b7          	lui	a5,0x10001
    800052d8:	47d8                	lw	a4,12(a5)
    800052da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052dc:	554d47b7          	lui	a5,0x554d4
    800052e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052e4:	0af71963          	bne	a4,a5,80005396 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e8:	100017b7          	lui	a5,0x10001
    800052ec:	4705                	li	a4,1
    800052ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f0:	470d                	li	a4,3
    800052f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052f6:	c7ffe737          	lui	a4,0xc7ffe
    800052fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005300:	2701                	sext.w	a4,a4
    80005302:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005304:	472d                	li	a4,11
    80005306:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	473d                	li	a4,15
    8000530a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000530c:	6705                	lui	a4,0x1
    8000530e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005310:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005314:	5bdc                	lw	a5,52(a5)
    80005316:	2781                	sext.w	a5,a5
  if(max == 0)
    80005318:	c7d9                	beqz	a5,800053a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000531a:	471d                	li	a4,7
    8000531c:	08f77d63          	bgeu	a4,a5,800053b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005320:	100014b7          	lui	s1,0x10001
    80005324:	47a1                	li	a5,8
    80005326:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005328:	6609                	lui	a2,0x2
    8000532a:	4581                	li	a1,0
    8000532c:	00016517          	auipc	a0,0x16
    80005330:	cd450513          	addi	a0,a0,-812 # 8001b000 <disk>
    80005334:	ffffb097          	auipc	ra,0xffffb
    80005338:	e44080e7          	jalr	-444(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000533c:	00016717          	auipc	a4,0x16
    80005340:	cc470713          	addi	a4,a4,-828 # 8001b000 <disk>
    80005344:	00c75793          	srli	a5,a4,0xc
    80005348:	2781                	sext.w	a5,a5
    8000534a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000534c:	00018797          	auipc	a5,0x18
    80005350:	cb478793          	addi	a5,a5,-844 # 8001d000 <disk+0x2000>
    80005354:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005356:	00016717          	auipc	a4,0x16
    8000535a:	d2a70713          	addi	a4,a4,-726 # 8001b080 <disk+0x80>
    8000535e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005360:	00017717          	auipc	a4,0x17
    80005364:	ca070713          	addi	a4,a4,-864 # 8001c000 <disk+0x1000>
    80005368:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000536a:	4705                	li	a4,1
    8000536c:	00e78c23          	sb	a4,24(a5)
    80005370:	00e78ca3          	sb	a4,25(a5)
    80005374:	00e78d23          	sb	a4,26(a5)
    80005378:	00e78da3          	sb	a4,27(a5)
    8000537c:	00e78e23          	sb	a4,28(a5)
    80005380:	00e78ea3          	sb	a4,29(a5)
    80005384:	00e78f23          	sb	a4,30(a5)
    80005388:	00e78fa3          	sb	a4,31(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6105                	addi	sp,sp,32
    80005394:	8082                	ret
    panic("could not find virtio disk");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	39250513          	addi	a0,a0,914 # 80008728 <syscalls+0x360>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	924080e7          	jalr	-1756(ra) # 80005cc2 <panic>
    panic("virtio disk has no queue 0");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	3a250513          	addi	a0,a0,930 # 80008748 <syscalls+0x380>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	914080e7          	jalr	-1772(ra) # 80005cc2 <panic>
    panic("virtio disk max queue too short");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	3b250513          	addi	a0,a0,946 # 80008768 <syscalls+0x3a0>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	904080e7          	jalr	-1788(ra) # 80005cc2 <panic>

00000000800053c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053c6:	7119                	addi	sp,sp,-128
    800053c8:	fc86                	sd	ra,120(sp)
    800053ca:	f8a2                	sd	s0,112(sp)
    800053cc:	f4a6                	sd	s1,104(sp)
    800053ce:	f0ca                	sd	s2,96(sp)
    800053d0:	ecce                	sd	s3,88(sp)
    800053d2:	e8d2                	sd	s4,80(sp)
    800053d4:	e4d6                	sd	s5,72(sp)
    800053d6:	e0da                	sd	s6,64(sp)
    800053d8:	fc5e                	sd	s7,56(sp)
    800053da:	f862                	sd	s8,48(sp)
    800053dc:	f466                	sd	s9,40(sp)
    800053de:	f06a                	sd	s10,32(sp)
    800053e0:	ec6e                	sd	s11,24(sp)
    800053e2:	0100                	addi	s0,sp,128
    800053e4:	8aaa                	mv	s5,a0
    800053e6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053e8:	00c52c83          	lw	s9,12(a0)
    800053ec:	001c9c9b          	slliw	s9,s9,0x1
    800053f0:	1c82                	slli	s9,s9,0x20
    800053f2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053f6:	00018517          	auipc	a0,0x18
    800053fa:	d3250513          	addi	a0,a0,-718 # 8001d128 <disk+0x2128>
    800053fe:	00001097          	auipc	ra,0x1
    80005402:	dd6080e7          	jalr	-554(ra) # 800061d4 <acquire>
  for(int i = 0; i < 3; i++){
    80005406:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005408:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000540a:	00016c17          	auipc	s8,0x16
    8000540e:	bf6c0c13          	addi	s8,s8,-1034 # 8001b000 <disk>
    80005412:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005414:	4b0d                	li	s6,3
    80005416:	a0ad                	j	80005480 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005418:	00fc0733          	add	a4,s8,a5
    8000541c:	975e                	add	a4,a4,s7
    8000541e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005422:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005424:	0207c563          	bltz	a5,8000544e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005428:	2905                	addiw	s2,s2,1
    8000542a:	0611                	addi	a2,a2,4
    8000542c:	19690d63          	beq	s2,s6,800055c6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005430:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005432:	00018717          	auipc	a4,0x18
    80005436:	be670713          	addi	a4,a4,-1050 # 8001d018 <disk+0x2018>
    8000543a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000543c:	00074683          	lbu	a3,0(a4)
    80005440:	fee1                	bnez	a3,80005418 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005442:	2785                	addiw	a5,a5,1
    80005444:	0705                	addi	a4,a4,1
    80005446:	fe979be3          	bne	a5,s1,8000543c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000544a:	57fd                	li	a5,-1
    8000544c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000544e:	01205d63          	blez	s2,80005468 <virtio_disk_rw+0xa2>
    80005452:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005454:	000a2503          	lw	a0,0(s4)
    80005458:	00000097          	auipc	ra,0x0
    8000545c:	d8e080e7          	jalr	-626(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005460:	2d85                	addiw	s11,s11,1
    80005462:	0a11                	addi	s4,s4,4
    80005464:	ffb918e3          	bne	s2,s11,80005454 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005468:	00018597          	auipc	a1,0x18
    8000546c:	cc058593          	addi	a1,a1,-832 # 8001d128 <disk+0x2128>
    80005470:	00018517          	auipc	a0,0x18
    80005474:	ba850513          	addi	a0,a0,-1112 # 8001d018 <disk+0x2018>
    80005478:	ffffc097          	auipc	ra,0xffffc
    8000547c:	0e0080e7          	jalr	224(ra) # 80001558 <sleep>
  for(int i = 0; i < 3; i++){
    80005480:	f8040a13          	addi	s4,s0,-128
{
    80005484:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005486:	894e                	mv	s2,s3
    80005488:	b765                	j	80005430 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000548a:	00018697          	auipc	a3,0x18
    8000548e:	b766b683          	ld	a3,-1162(a3) # 8001d000 <disk+0x2000>
    80005492:	96ba                	add	a3,a3,a4
    80005494:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005498:	00016817          	auipc	a6,0x16
    8000549c:	b6880813          	addi	a6,a6,-1176 # 8001b000 <disk>
    800054a0:	00018697          	auipc	a3,0x18
    800054a4:	b6068693          	addi	a3,a3,-1184 # 8001d000 <disk+0x2000>
    800054a8:	6290                	ld	a2,0(a3)
    800054aa:	963a                	add	a2,a2,a4
    800054ac:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800054b0:	0015e593          	ori	a1,a1,1
    800054b4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054b8:	f8842603          	lw	a2,-120(s0)
    800054bc:	628c                	ld	a1,0(a3)
    800054be:	972e                	add	a4,a4,a1
    800054c0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054c4:	20050593          	addi	a1,a0,512
    800054c8:	0592                	slli	a1,a1,0x4
    800054ca:	95c2                	add	a1,a1,a6
    800054cc:	577d                	li	a4,-1
    800054ce:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054d2:	00461713          	slli	a4,a2,0x4
    800054d6:	6290                	ld	a2,0(a3)
    800054d8:	963a                	add	a2,a2,a4
    800054da:	03078793          	addi	a5,a5,48
    800054de:	97c2                	add	a5,a5,a6
    800054e0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054e2:	629c                	ld	a5,0(a3)
    800054e4:	97ba                	add	a5,a5,a4
    800054e6:	4605                	li	a2,1
    800054e8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054ea:	629c                	ld	a5,0(a3)
    800054ec:	97ba                	add	a5,a5,a4
    800054ee:	4809                	li	a6,2
    800054f0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054f4:	629c                	ld	a5,0(a3)
    800054f6:	973e                	add	a4,a4,a5
    800054f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054fc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005500:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005504:	6698                	ld	a4,8(a3)
    80005506:	00275783          	lhu	a5,2(a4)
    8000550a:	8b9d                	andi	a5,a5,7
    8000550c:	0786                	slli	a5,a5,0x1
    8000550e:	97ba                	add	a5,a5,a4
    80005510:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005514:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005518:	6698                	ld	a4,8(a3)
    8000551a:	00275783          	lhu	a5,2(a4)
    8000551e:	2785                	addiw	a5,a5,1
    80005520:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005524:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005530:	004aa783          	lw	a5,4(s5)
    80005534:	02c79163          	bne	a5,a2,80005556 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005538:	00018917          	auipc	s2,0x18
    8000553c:	bf090913          	addi	s2,s2,-1040 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005540:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005542:	85ca                	mv	a1,s2
    80005544:	8556                	mv	a0,s5
    80005546:	ffffc097          	auipc	ra,0xffffc
    8000554a:	012080e7          	jalr	18(ra) # 80001558 <sleep>
  while(b->disk == 1) {
    8000554e:	004aa783          	lw	a5,4(s5)
    80005552:	fe9788e3          	beq	a5,s1,80005542 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005556:	f8042903          	lw	s2,-128(s0)
    8000555a:	20090793          	addi	a5,s2,512
    8000555e:	00479713          	slli	a4,a5,0x4
    80005562:	00016797          	auipc	a5,0x16
    80005566:	a9e78793          	addi	a5,a5,-1378 # 8001b000 <disk>
    8000556a:	97ba                	add	a5,a5,a4
    8000556c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005570:	00018997          	auipc	s3,0x18
    80005574:	a9098993          	addi	s3,s3,-1392 # 8001d000 <disk+0x2000>
    80005578:	00491713          	slli	a4,s2,0x4
    8000557c:	0009b783          	ld	a5,0(s3)
    80005580:	97ba                	add	a5,a5,a4
    80005582:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005586:	854a                	mv	a0,s2
    80005588:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000558c:	00000097          	auipc	ra,0x0
    80005590:	c5a080e7          	jalr	-934(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005594:	8885                	andi	s1,s1,1
    80005596:	f0ed                	bnez	s1,80005578 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005598:	00018517          	auipc	a0,0x18
    8000559c:	b9050513          	addi	a0,a0,-1136 # 8001d128 <disk+0x2128>
    800055a0:	00001097          	auipc	ra,0x1
    800055a4:	ce8080e7          	jalr	-792(ra) # 80006288 <release>
}
    800055a8:	70e6                	ld	ra,120(sp)
    800055aa:	7446                	ld	s0,112(sp)
    800055ac:	74a6                	ld	s1,104(sp)
    800055ae:	7906                	ld	s2,96(sp)
    800055b0:	69e6                	ld	s3,88(sp)
    800055b2:	6a46                	ld	s4,80(sp)
    800055b4:	6aa6                	ld	s5,72(sp)
    800055b6:	6b06                	ld	s6,64(sp)
    800055b8:	7be2                	ld	s7,56(sp)
    800055ba:	7c42                	ld	s8,48(sp)
    800055bc:	7ca2                	ld	s9,40(sp)
    800055be:	7d02                	ld	s10,32(sp)
    800055c0:	6de2                	ld	s11,24(sp)
    800055c2:	6109                	addi	sp,sp,128
    800055c4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c6:	f8042503          	lw	a0,-128(s0)
    800055ca:	20050793          	addi	a5,a0,512
    800055ce:	0792                	slli	a5,a5,0x4
  if(write)
    800055d0:	00016817          	auipc	a6,0x16
    800055d4:	a3080813          	addi	a6,a6,-1488 # 8001b000 <disk>
    800055d8:	00f80733          	add	a4,a6,a5
    800055dc:	01a036b3          	snez	a3,s10
    800055e0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055e4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055e8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ec:	7679                	lui	a2,0xffffe
    800055ee:	963e                	add	a2,a2,a5
    800055f0:	00018697          	auipc	a3,0x18
    800055f4:	a1068693          	addi	a3,a3,-1520 # 8001d000 <disk+0x2000>
    800055f8:	6298                	ld	a4,0(a3)
    800055fa:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055fc:	0a878593          	addi	a1,a5,168
    80005600:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005602:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005604:	6298                	ld	a4,0(a3)
    80005606:	9732                	add	a4,a4,a2
    80005608:	45c1                	li	a1,16
    8000560a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000560c:	6298                	ld	a4,0(a3)
    8000560e:	9732                	add	a4,a4,a2
    80005610:	4585                	li	a1,1
    80005612:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005616:	f8442703          	lw	a4,-124(s0)
    8000561a:	628c                	ld	a1,0(a3)
    8000561c:	962e                	add	a2,a2,a1
    8000561e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005622:	0712                	slli	a4,a4,0x4
    80005624:	6290                	ld	a2,0(a3)
    80005626:	963a                	add	a2,a2,a4
    80005628:	058a8593          	addi	a1,s5,88
    8000562c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000562e:	6294                	ld	a3,0(a3)
    80005630:	96ba                	add	a3,a3,a4
    80005632:	40000613          	li	a2,1024
    80005636:	c690                	sw	a2,8(a3)
  if(write)
    80005638:	e40d19e3          	bnez	s10,8000548a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000563c:	00018697          	auipc	a3,0x18
    80005640:	9c46b683          	ld	a3,-1596(a3) # 8001d000 <disk+0x2000>
    80005644:	96ba                	add	a3,a3,a4
    80005646:	4609                	li	a2,2
    80005648:	00c69623          	sh	a2,12(a3)
    8000564c:	b5b1                	j	80005498 <virtio_disk_rw+0xd2>

000000008000564e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000564e:	1101                	addi	sp,sp,-32
    80005650:	ec06                	sd	ra,24(sp)
    80005652:	e822                	sd	s0,16(sp)
    80005654:	e426                	sd	s1,8(sp)
    80005656:	e04a                	sd	s2,0(sp)
    80005658:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000565a:	00018517          	auipc	a0,0x18
    8000565e:	ace50513          	addi	a0,a0,-1330 # 8001d128 <disk+0x2128>
    80005662:	00001097          	auipc	ra,0x1
    80005666:	b72080e7          	jalr	-1166(ra) # 800061d4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000566a:	10001737          	lui	a4,0x10001
    8000566e:	533c                	lw	a5,96(a4)
    80005670:	8b8d                	andi	a5,a5,3
    80005672:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005674:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005678:	00018797          	auipc	a5,0x18
    8000567c:	98878793          	addi	a5,a5,-1656 # 8001d000 <disk+0x2000>
    80005680:	6b94                	ld	a3,16(a5)
    80005682:	0207d703          	lhu	a4,32(a5)
    80005686:	0026d783          	lhu	a5,2(a3)
    8000568a:	06f70163          	beq	a4,a5,800056ec <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000568e:	00016917          	auipc	s2,0x16
    80005692:	97290913          	addi	s2,s2,-1678 # 8001b000 <disk>
    80005696:	00018497          	auipc	s1,0x18
    8000569a:	96a48493          	addi	s1,s1,-1686 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000569e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056a2:	6898                	ld	a4,16(s1)
    800056a4:	0204d783          	lhu	a5,32(s1)
    800056a8:	8b9d                	andi	a5,a5,7
    800056aa:	078e                	slli	a5,a5,0x3
    800056ac:	97ba                	add	a5,a5,a4
    800056ae:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056b0:	20078713          	addi	a4,a5,512
    800056b4:	0712                	slli	a4,a4,0x4
    800056b6:	974a                	add	a4,a4,s2
    800056b8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056bc:	e731                	bnez	a4,80005708 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056be:	20078793          	addi	a5,a5,512
    800056c2:	0792                	slli	a5,a5,0x4
    800056c4:	97ca                	add	a5,a5,s2
    800056c6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056c8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056cc:	ffffc097          	auipc	ra,0xffffc
    800056d0:	018080e7          	jalr	24(ra) # 800016e4 <wakeup>

    disk.used_idx += 1;
    800056d4:	0204d783          	lhu	a5,32(s1)
    800056d8:	2785                	addiw	a5,a5,1
    800056da:	17c2                	slli	a5,a5,0x30
    800056dc:	93c1                	srli	a5,a5,0x30
    800056de:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056e2:	6898                	ld	a4,16(s1)
    800056e4:	00275703          	lhu	a4,2(a4)
    800056e8:	faf71be3          	bne	a4,a5,8000569e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056ec:	00018517          	auipc	a0,0x18
    800056f0:	a3c50513          	addi	a0,a0,-1476 # 8001d128 <disk+0x2128>
    800056f4:	00001097          	auipc	ra,0x1
    800056f8:	b94080e7          	jalr	-1132(ra) # 80006288 <release>
}
    800056fc:	60e2                	ld	ra,24(sp)
    800056fe:	6442                	ld	s0,16(sp)
    80005700:	64a2                	ld	s1,8(sp)
    80005702:	6902                	ld	s2,0(sp)
    80005704:	6105                	addi	sp,sp,32
    80005706:	8082                	ret
      panic("virtio_disk_intr status");
    80005708:	00003517          	auipc	a0,0x3
    8000570c:	08050513          	addi	a0,a0,128 # 80008788 <syscalls+0x3c0>
    80005710:	00000097          	auipc	ra,0x0
    80005714:	5b2080e7          	jalr	1458(ra) # 80005cc2 <panic>

0000000080005718 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005718:	1141                	addi	sp,sp,-16
    8000571a:	e422                	sd	s0,8(sp)
    8000571c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000571e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005722:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005726:	0037979b          	slliw	a5,a5,0x3
    8000572a:	02004737          	lui	a4,0x2004
    8000572e:	97ba                	add	a5,a5,a4
    80005730:	0200c737          	lui	a4,0x200c
    80005734:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005738:	000f4637          	lui	a2,0xf4
    8000573c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005740:	95b2                	add	a1,a1,a2
    80005742:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005744:	00269713          	slli	a4,a3,0x2
    80005748:	9736                	add	a4,a4,a3
    8000574a:	00371693          	slli	a3,a4,0x3
    8000574e:	00019717          	auipc	a4,0x19
    80005752:	8b270713          	addi	a4,a4,-1870 # 8001e000 <timer_scratch>
    80005756:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005758:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000575a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000575c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005760:	00000797          	auipc	a5,0x0
    80005764:	9c078793          	addi	a5,a5,-1600 # 80005120 <timervec>
    80005768:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000576c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005770:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005774:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005778:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000577c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005780:	30479073          	csrw	mie,a5
}
    80005784:	6422                	ld	s0,8(sp)
    80005786:	0141                	addi	sp,sp,16
    80005788:	8082                	ret

000000008000578a <start>:
{
    8000578a:	1141                	addi	sp,sp,-16
    8000578c:	e406                	sd	ra,8(sp)
    8000578e:	e022                	sd	s0,0(sp)
    80005790:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005792:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005796:	7779                	lui	a4,0xffffe
    80005798:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000579c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000579e:	6705                	lui	a4,0x1
    800057a0:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057a4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057a6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057aa:	ffffb797          	auipc	a5,0xffffb
    800057ae:	b7478793          	addi	a5,a5,-1164 # 8000031e <main>
    800057b2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057b6:	4781                	li	a5,0
    800057b8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057bc:	67c1                	lui	a5,0x10
    800057be:	17fd                	addi	a5,a5,-1
    800057c0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057c4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057c8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057cc:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057d0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057d4:	57fd                	li	a5,-1
    800057d6:	83a9                	srli	a5,a5,0xa
    800057d8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057dc:	47bd                	li	a5,15
    800057de:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057e2:	00000097          	auipc	ra,0x0
    800057e6:	f36080e7          	jalr	-202(ra) # 80005718 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ea:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057ee:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057f0:	823e                	mv	tp,a5
  asm volatile("mret");
    800057f2:	30200073          	mret
}
    800057f6:	60a2                	ld	ra,8(sp)
    800057f8:	6402                	ld	s0,0(sp)
    800057fa:	0141                	addi	sp,sp,16
    800057fc:	8082                	ret

00000000800057fe <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057fe:	715d                	addi	sp,sp,-80
    80005800:	e486                	sd	ra,72(sp)
    80005802:	e0a2                	sd	s0,64(sp)
    80005804:	fc26                	sd	s1,56(sp)
    80005806:	f84a                	sd	s2,48(sp)
    80005808:	f44e                	sd	s3,40(sp)
    8000580a:	f052                	sd	s4,32(sp)
    8000580c:	ec56                	sd	s5,24(sp)
    8000580e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005810:	04c05663          	blez	a2,8000585c <consolewrite+0x5e>
    80005814:	8a2a                	mv	s4,a0
    80005816:	84ae                	mv	s1,a1
    80005818:	89b2                	mv	s3,a2
    8000581a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000581c:	5afd                	li	s5,-1
    8000581e:	4685                	li	a3,1
    80005820:	8626                	mv	a2,s1
    80005822:	85d2                	mv	a1,s4
    80005824:	fbf40513          	addi	a0,s0,-65
    80005828:	ffffc097          	auipc	ra,0xffffc
    8000582c:	12a080e7          	jalr	298(ra) # 80001952 <either_copyin>
    80005830:	01550c63          	beq	a0,s5,80005848 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005834:	fbf44503          	lbu	a0,-65(s0)
    80005838:	00000097          	auipc	ra,0x0
    8000583c:	7de080e7          	jalr	2014(ra) # 80006016 <uartputc>
  for(i = 0; i < n; i++){
    80005840:	2905                	addiw	s2,s2,1
    80005842:	0485                	addi	s1,s1,1
    80005844:	fd299de3          	bne	s3,s2,8000581e <consolewrite+0x20>
  }

  return i;
}
    80005848:	854a                	mv	a0,s2
    8000584a:	60a6                	ld	ra,72(sp)
    8000584c:	6406                	ld	s0,64(sp)
    8000584e:	74e2                	ld	s1,56(sp)
    80005850:	7942                	ld	s2,48(sp)
    80005852:	79a2                	ld	s3,40(sp)
    80005854:	7a02                	ld	s4,32(sp)
    80005856:	6ae2                	ld	s5,24(sp)
    80005858:	6161                	addi	sp,sp,80
    8000585a:	8082                	ret
  for(i = 0; i < n; i++){
    8000585c:	4901                	li	s2,0
    8000585e:	b7ed                	j	80005848 <consolewrite+0x4a>

0000000080005860 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005860:	7159                	addi	sp,sp,-112
    80005862:	f486                	sd	ra,104(sp)
    80005864:	f0a2                	sd	s0,96(sp)
    80005866:	eca6                	sd	s1,88(sp)
    80005868:	e8ca                	sd	s2,80(sp)
    8000586a:	e4ce                	sd	s3,72(sp)
    8000586c:	e0d2                	sd	s4,64(sp)
    8000586e:	fc56                	sd	s5,56(sp)
    80005870:	f85a                	sd	s6,48(sp)
    80005872:	f45e                	sd	s7,40(sp)
    80005874:	f062                	sd	s8,32(sp)
    80005876:	ec66                	sd	s9,24(sp)
    80005878:	e86a                	sd	s10,16(sp)
    8000587a:	1880                	addi	s0,sp,112
    8000587c:	8aaa                	mv	s5,a0
    8000587e:	8a2e                	mv	s4,a1
    80005880:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005882:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005886:	00021517          	auipc	a0,0x21
    8000588a:	8ba50513          	addi	a0,a0,-1862 # 80026140 <cons>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	946080e7          	jalr	-1722(ra) # 800061d4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005896:	00021497          	auipc	s1,0x21
    8000589a:	8aa48493          	addi	s1,s1,-1878 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000589e:	00021917          	auipc	s2,0x21
    800058a2:	93a90913          	addi	s2,s2,-1734 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058a6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058a8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058aa:	4ca9                	li	s9,10
  while(n > 0){
    800058ac:	07305863          	blez	s3,8000591c <consoleread+0xbc>
    while(cons.r == cons.w){
    800058b0:	0984a783          	lw	a5,152(s1)
    800058b4:	09c4a703          	lw	a4,156(s1)
    800058b8:	02f71463          	bne	a4,a5,800058e0 <consoleread+0x80>
      if(myproc()->killed){
    800058bc:	ffffb097          	auipc	ra,0xffffb
    800058c0:	586080e7          	jalr	1414(ra) # 80000e42 <myproc>
    800058c4:	551c                	lw	a5,40(a0)
    800058c6:	e7b5                	bnez	a5,80005932 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058c8:	85a6                	mv	a1,s1
    800058ca:	854a                	mv	a0,s2
    800058cc:	ffffc097          	auipc	ra,0xffffc
    800058d0:	c8c080e7          	jalr	-884(ra) # 80001558 <sleep>
    while(cons.r == cons.w){
    800058d4:	0984a783          	lw	a5,152(s1)
    800058d8:	09c4a703          	lw	a4,156(s1)
    800058dc:	fef700e3          	beq	a4,a5,800058bc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058e0:	0017871b          	addiw	a4,a5,1
    800058e4:	08e4ac23          	sw	a4,152(s1)
    800058e8:	07f7f713          	andi	a4,a5,127
    800058ec:	9726                	add	a4,a4,s1
    800058ee:	01874703          	lbu	a4,24(a4)
    800058f2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058f6:	077d0563          	beq	s10,s7,80005960 <consoleread+0x100>
    cbuf = c;
    800058fa:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058fe:	4685                	li	a3,1
    80005900:	f9f40613          	addi	a2,s0,-97
    80005904:	85d2                	mv	a1,s4
    80005906:	8556                	mv	a0,s5
    80005908:	ffffc097          	auipc	ra,0xffffc
    8000590c:	ff4080e7          	jalr	-12(ra) # 800018fc <either_copyout>
    80005910:	01850663          	beq	a0,s8,8000591c <consoleread+0xbc>
    dst++;
    80005914:	0a05                	addi	s4,s4,1
    --n;
    80005916:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005918:	f99d1ae3          	bne	s10,s9,800058ac <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000591c:	00021517          	auipc	a0,0x21
    80005920:	82450513          	addi	a0,a0,-2012 # 80026140 <cons>
    80005924:	00001097          	auipc	ra,0x1
    80005928:	964080e7          	jalr	-1692(ra) # 80006288 <release>

  return target - n;
    8000592c:	413b053b          	subw	a0,s6,s3
    80005930:	a811                	j	80005944 <consoleread+0xe4>
        release(&cons.lock);
    80005932:	00021517          	auipc	a0,0x21
    80005936:	80e50513          	addi	a0,a0,-2034 # 80026140 <cons>
    8000593a:	00001097          	auipc	ra,0x1
    8000593e:	94e080e7          	jalr	-1714(ra) # 80006288 <release>
        return -1;
    80005942:	557d                	li	a0,-1
}
    80005944:	70a6                	ld	ra,104(sp)
    80005946:	7406                	ld	s0,96(sp)
    80005948:	64e6                	ld	s1,88(sp)
    8000594a:	6946                	ld	s2,80(sp)
    8000594c:	69a6                	ld	s3,72(sp)
    8000594e:	6a06                	ld	s4,64(sp)
    80005950:	7ae2                	ld	s5,56(sp)
    80005952:	7b42                	ld	s6,48(sp)
    80005954:	7ba2                	ld	s7,40(sp)
    80005956:	7c02                	ld	s8,32(sp)
    80005958:	6ce2                	ld	s9,24(sp)
    8000595a:	6d42                	ld	s10,16(sp)
    8000595c:	6165                	addi	sp,sp,112
    8000595e:	8082                	ret
      if(n < target){
    80005960:	0009871b          	sext.w	a4,s3
    80005964:	fb677ce3          	bgeu	a4,s6,8000591c <consoleread+0xbc>
        cons.r--;
    80005968:	00021717          	auipc	a4,0x21
    8000596c:	86f72823          	sw	a5,-1936(a4) # 800261d8 <cons+0x98>
    80005970:	b775                	j	8000591c <consoleread+0xbc>

0000000080005972 <consputc>:
{
    80005972:	1141                	addi	sp,sp,-16
    80005974:	e406                	sd	ra,8(sp)
    80005976:	e022                	sd	s0,0(sp)
    80005978:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000597a:	10000793          	li	a5,256
    8000597e:	00f50a63          	beq	a0,a5,80005992 <consputc+0x20>
    uartputc_sync(c);
    80005982:	00000097          	auipc	ra,0x0
    80005986:	5c2080e7          	jalr	1474(ra) # 80005f44 <uartputc_sync>
}
    8000598a:	60a2                	ld	ra,8(sp)
    8000598c:	6402                	ld	s0,0(sp)
    8000598e:	0141                	addi	sp,sp,16
    80005990:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005992:	4521                	li	a0,8
    80005994:	00000097          	auipc	ra,0x0
    80005998:	5b0080e7          	jalr	1456(ra) # 80005f44 <uartputc_sync>
    8000599c:	02000513          	li	a0,32
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	5a4080e7          	jalr	1444(ra) # 80005f44 <uartputc_sync>
    800059a8:	4521                	li	a0,8
    800059aa:	00000097          	auipc	ra,0x0
    800059ae:	59a080e7          	jalr	1434(ra) # 80005f44 <uartputc_sync>
    800059b2:	bfe1                	j	8000598a <consputc+0x18>

00000000800059b4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059b4:	1101                	addi	sp,sp,-32
    800059b6:	ec06                	sd	ra,24(sp)
    800059b8:	e822                	sd	s0,16(sp)
    800059ba:	e426                	sd	s1,8(sp)
    800059bc:	e04a                	sd	s2,0(sp)
    800059be:	1000                	addi	s0,sp,32
    800059c0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059c2:	00020517          	auipc	a0,0x20
    800059c6:	77e50513          	addi	a0,a0,1918 # 80026140 <cons>
    800059ca:	00001097          	auipc	ra,0x1
    800059ce:	80a080e7          	jalr	-2038(ra) # 800061d4 <acquire>

  switch(c){
    800059d2:	47d5                	li	a5,21
    800059d4:	0af48663          	beq	s1,a5,80005a80 <consoleintr+0xcc>
    800059d8:	0297ca63          	blt	a5,s1,80005a0c <consoleintr+0x58>
    800059dc:	47a1                	li	a5,8
    800059de:	0ef48763          	beq	s1,a5,80005acc <consoleintr+0x118>
    800059e2:	47c1                	li	a5,16
    800059e4:	10f49a63          	bne	s1,a5,80005af8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059e8:	ffffc097          	auipc	ra,0xffffc
    800059ec:	fc0080e7          	jalr	-64(ra) # 800019a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059f0:	00020517          	auipc	a0,0x20
    800059f4:	75050513          	addi	a0,a0,1872 # 80026140 <cons>
    800059f8:	00001097          	auipc	ra,0x1
    800059fc:	890080e7          	jalr	-1904(ra) # 80006288 <release>
}
    80005a00:	60e2                	ld	ra,24(sp)
    80005a02:	6442                	ld	s0,16(sp)
    80005a04:	64a2                	ld	s1,8(sp)
    80005a06:	6902                	ld	s2,0(sp)
    80005a08:	6105                	addi	sp,sp,32
    80005a0a:	8082                	ret
  switch(c){
    80005a0c:	07f00793          	li	a5,127
    80005a10:	0af48e63          	beq	s1,a5,80005acc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a14:	00020717          	auipc	a4,0x20
    80005a18:	72c70713          	addi	a4,a4,1836 # 80026140 <cons>
    80005a1c:	0a072783          	lw	a5,160(a4)
    80005a20:	09872703          	lw	a4,152(a4)
    80005a24:	9f99                	subw	a5,a5,a4
    80005a26:	07f00713          	li	a4,127
    80005a2a:	fcf763e3          	bltu	a4,a5,800059f0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a2e:	47b5                	li	a5,13
    80005a30:	0cf48763          	beq	s1,a5,80005afe <consoleintr+0x14a>
      consputc(c);
    80005a34:	8526                	mv	a0,s1
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	f3c080e7          	jalr	-196(ra) # 80005972 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a3e:	00020797          	auipc	a5,0x20
    80005a42:	70278793          	addi	a5,a5,1794 # 80026140 <cons>
    80005a46:	0a07a703          	lw	a4,160(a5)
    80005a4a:	0017069b          	addiw	a3,a4,1
    80005a4e:	0006861b          	sext.w	a2,a3
    80005a52:	0ad7a023          	sw	a3,160(a5)
    80005a56:	07f77713          	andi	a4,a4,127
    80005a5a:	97ba                	add	a5,a5,a4
    80005a5c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a60:	47a9                	li	a5,10
    80005a62:	0cf48563          	beq	s1,a5,80005b2c <consoleintr+0x178>
    80005a66:	4791                	li	a5,4
    80005a68:	0cf48263          	beq	s1,a5,80005b2c <consoleintr+0x178>
    80005a6c:	00020797          	auipc	a5,0x20
    80005a70:	76c7a783          	lw	a5,1900(a5) # 800261d8 <cons+0x98>
    80005a74:	0807879b          	addiw	a5,a5,128
    80005a78:	f6f61ce3          	bne	a2,a5,800059f0 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a7c:	863e                	mv	a2,a5
    80005a7e:	a07d                	j	80005b2c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a80:	00020717          	auipc	a4,0x20
    80005a84:	6c070713          	addi	a4,a4,1728 # 80026140 <cons>
    80005a88:	0a072783          	lw	a5,160(a4)
    80005a8c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a90:	00020497          	auipc	s1,0x20
    80005a94:	6b048493          	addi	s1,s1,1712 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a98:	4929                	li	s2,10
    80005a9a:	f4f70be3          	beq	a4,a5,800059f0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a9e:	37fd                	addiw	a5,a5,-1
    80005aa0:	07f7f713          	andi	a4,a5,127
    80005aa4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aa6:	01874703          	lbu	a4,24(a4)
    80005aaa:	f52703e3          	beq	a4,s2,800059f0 <consoleintr+0x3c>
      cons.e--;
    80005aae:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ab2:	10000513          	li	a0,256
    80005ab6:	00000097          	auipc	ra,0x0
    80005aba:	ebc080e7          	jalr	-324(ra) # 80005972 <consputc>
    while(cons.e != cons.w &&
    80005abe:	0a04a783          	lw	a5,160(s1)
    80005ac2:	09c4a703          	lw	a4,156(s1)
    80005ac6:	fcf71ce3          	bne	a4,a5,80005a9e <consoleintr+0xea>
    80005aca:	b71d                	j	800059f0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005acc:	00020717          	auipc	a4,0x20
    80005ad0:	67470713          	addi	a4,a4,1652 # 80026140 <cons>
    80005ad4:	0a072783          	lw	a5,160(a4)
    80005ad8:	09c72703          	lw	a4,156(a4)
    80005adc:	f0f70ae3          	beq	a4,a5,800059f0 <consoleintr+0x3c>
      cons.e--;
    80005ae0:	37fd                	addiw	a5,a5,-1
    80005ae2:	00020717          	auipc	a4,0x20
    80005ae6:	6ef72f23          	sw	a5,1790(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005aea:	10000513          	li	a0,256
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	e84080e7          	jalr	-380(ra) # 80005972 <consputc>
    80005af6:	bded                	j	800059f0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005af8:	ee048ce3          	beqz	s1,800059f0 <consoleintr+0x3c>
    80005afc:	bf21                	j	80005a14 <consoleintr+0x60>
      consputc(c);
    80005afe:	4529                	li	a0,10
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	e72080e7          	jalr	-398(ra) # 80005972 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b08:	00020797          	auipc	a5,0x20
    80005b0c:	63878793          	addi	a5,a5,1592 # 80026140 <cons>
    80005b10:	0a07a703          	lw	a4,160(a5)
    80005b14:	0017069b          	addiw	a3,a4,1
    80005b18:	0006861b          	sext.w	a2,a3
    80005b1c:	0ad7a023          	sw	a3,160(a5)
    80005b20:	07f77713          	andi	a4,a4,127
    80005b24:	97ba                	add	a5,a5,a4
    80005b26:	4729                	li	a4,10
    80005b28:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b2c:	00020797          	auipc	a5,0x20
    80005b30:	6ac7a823          	sw	a2,1712(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b34:	00020517          	auipc	a0,0x20
    80005b38:	6a450513          	addi	a0,a0,1700 # 800261d8 <cons+0x98>
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	ba8080e7          	jalr	-1112(ra) # 800016e4 <wakeup>
    80005b44:	b575                	j	800059f0 <consoleintr+0x3c>

0000000080005b46 <consoleinit>:

void
consoleinit(void)
{
    80005b46:	1141                	addi	sp,sp,-16
    80005b48:	e406                	sd	ra,8(sp)
    80005b4a:	e022                	sd	s0,0(sp)
    80005b4c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b4e:	00003597          	auipc	a1,0x3
    80005b52:	c5258593          	addi	a1,a1,-942 # 800087a0 <syscalls+0x3d8>
    80005b56:	00020517          	auipc	a0,0x20
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 80026140 <cons>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	5e6080e7          	jalr	1510(ra) # 80006144 <initlock>

  uartinit();
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	38e080e7          	jalr	910(ra) # 80005ef4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b6e:	00014797          	auipc	a5,0x14
    80005b72:	b5a78793          	addi	a5,a5,-1190 # 800196c8 <devsw>
    80005b76:	00000717          	auipc	a4,0x0
    80005b7a:	cea70713          	addi	a4,a4,-790 # 80005860 <consoleread>
    80005b7e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b80:	00000717          	auipc	a4,0x0
    80005b84:	c7e70713          	addi	a4,a4,-898 # 800057fe <consolewrite>
    80005b88:	ef98                	sd	a4,24(a5)
}
    80005b8a:	60a2                	ld	ra,8(sp)
    80005b8c:	6402                	ld	s0,0(sp)
    80005b8e:	0141                	addi	sp,sp,16
    80005b90:	8082                	ret

0000000080005b92 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b92:	7179                	addi	sp,sp,-48
    80005b94:	f406                	sd	ra,40(sp)
    80005b96:	f022                	sd	s0,32(sp)
    80005b98:	ec26                	sd	s1,24(sp)
    80005b9a:	e84a                	sd	s2,16(sp)
    80005b9c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b9e:	c219                	beqz	a2,80005ba4 <printint+0x12>
    80005ba0:	08054663          	bltz	a0,80005c2c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ba4:	2501                	sext.w	a0,a0
    80005ba6:	4881                	li	a7,0
    80005ba8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bac:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bae:	2581                	sext.w	a1,a1
    80005bb0:	00003617          	auipc	a2,0x3
    80005bb4:	c3860613          	addi	a2,a2,-968 # 800087e8 <digits>
    80005bb8:	883a                	mv	a6,a4
    80005bba:	2705                	addiw	a4,a4,1
    80005bbc:	02b577bb          	remuw	a5,a0,a1
    80005bc0:	1782                	slli	a5,a5,0x20
    80005bc2:	9381                	srli	a5,a5,0x20
    80005bc4:	97b2                	add	a5,a5,a2
    80005bc6:	0007c783          	lbu	a5,0(a5)
    80005bca:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bce:	0005079b          	sext.w	a5,a0
    80005bd2:	02b5553b          	divuw	a0,a0,a1
    80005bd6:	0685                	addi	a3,a3,1
    80005bd8:	feb7f0e3          	bgeu	a5,a1,80005bb8 <printint+0x26>

  if(sign)
    80005bdc:	00088b63          	beqz	a7,80005bf2 <printint+0x60>
    buf[i++] = '-';
    80005be0:	fe040793          	addi	a5,s0,-32
    80005be4:	973e                	add	a4,a4,a5
    80005be6:	02d00793          	li	a5,45
    80005bea:	fef70823          	sb	a5,-16(a4)
    80005bee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bf2:	02e05763          	blez	a4,80005c20 <printint+0x8e>
    80005bf6:	fd040793          	addi	a5,s0,-48
    80005bfa:	00e784b3          	add	s1,a5,a4
    80005bfe:	fff78913          	addi	s2,a5,-1
    80005c02:	993a                	add	s2,s2,a4
    80005c04:	377d                	addiw	a4,a4,-1
    80005c06:	1702                	slli	a4,a4,0x20
    80005c08:	9301                	srli	a4,a4,0x20
    80005c0a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c0e:	fff4c503          	lbu	a0,-1(s1)
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	d60080e7          	jalr	-672(ra) # 80005972 <consputc>
  while(--i >= 0)
    80005c1a:	14fd                	addi	s1,s1,-1
    80005c1c:	ff2499e3          	bne	s1,s2,80005c0e <printint+0x7c>
}
    80005c20:	70a2                	ld	ra,40(sp)
    80005c22:	7402                	ld	s0,32(sp)
    80005c24:	64e2                	ld	s1,24(sp)
    80005c26:	6942                	ld	s2,16(sp)
    80005c28:	6145                	addi	sp,sp,48
    80005c2a:	8082                	ret
    x = -xx;
    80005c2c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c30:	4885                	li	a7,1
    x = -xx;
    80005c32:	bf9d                	j	80005ba8 <printint+0x16>

0000000080005c34 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c34:	1101                	addi	sp,sp,-32
    80005c36:	ec06                	sd	ra,24(sp)
    80005c38:	e822                	sd	s0,16(sp)
    80005c3a:	e426                	sd	s1,8(sp)
    80005c3c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c3e:	00020497          	auipc	s1,0x20
    80005c42:	5aa48493          	addi	s1,s1,1450 # 800261e8 <pr>
    80005c46:	00003597          	auipc	a1,0x3
    80005c4a:	b6258593          	addi	a1,a1,-1182 # 800087a8 <syscalls+0x3e0>
    80005c4e:	8526                	mv	a0,s1
    80005c50:	00000097          	auipc	ra,0x0
    80005c54:	4f4080e7          	jalr	1268(ra) # 80006144 <initlock>
  pr.locking = 1;
    80005c58:	4785                	li	a5,1
    80005c5a:	cc9c                	sw	a5,24(s1)
}
    80005c5c:	60e2                	ld	ra,24(sp)
    80005c5e:	6442                	ld	s0,16(sp)
    80005c60:	64a2                	ld	s1,8(sp)
    80005c62:	6105                	addi	sp,sp,32
    80005c64:	8082                	ret

0000000080005c66 <backtrace>:

void 
backtrace(void)
{
    80005c66:	7179                	addi	sp,sp,-48
    80005c68:	f406                	sd	ra,40(sp)
    80005c6a:	f022                	sd	s0,32(sp)
    80005c6c:	ec26                	sd	s1,24(sp)
    80005c6e:	e84a                	sd	s2,16(sp)
    80005c70:	e44e                	sd	s3,8(sp)
    80005c72:	1800                	addi	s0,sp,48

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005c74:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  printf("backtrace:\n");
    80005c76:	00003517          	auipc	a0,0x3
    80005c7a:	b3a50513          	addi	a0,a0,-1222 # 800087b0 <syscalls+0x3e8>
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	096080e7          	jalr	150(ra) # 80005d14 <printf>
  uint64 top = PGROUNDUP(fp);
    80005c86:	6905                	lui	s2,0x1
    80005c88:	197d                	addi	s2,s2,-1
    80005c8a:	9926                	add	s2,s2,s1
    80005c8c:	77fd                	lui	a5,0xfffff
    80005c8e:	00f97933          	and	s2,s2,a5
  while(fp<top)
    80005c92:	0324f163          	bgeu	s1,s2,80005cb4 <backtrace+0x4e>
  {
    printf("%p\n",*(uint64*)(fp-8));
    80005c96:	00003997          	auipc	s3,0x3
    80005c9a:	b2a98993          	addi	s3,s3,-1238 # 800087c0 <syscalls+0x3f8>
    80005c9e:	ff84b583          	ld	a1,-8(s1)
    80005ca2:	854e                	mv	a0,s3
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	070080e7          	jalr	112(ra) # 80005d14 <printf>
    fp = *(uint64*)(fp-16);
    80005cac:	ff04b483          	ld	s1,-16(s1)
  while(fp<top)
    80005cb0:	ff24e7e3          	bltu	s1,s2,80005c9e <backtrace+0x38>
  }
    80005cb4:	70a2                	ld	ra,40(sp)
    80005cb6:	7402                	ld	s0,32(sp)
    80005cb8:	64e2                	ld	s1,24(sp)
    80005cba:	6942                	ld	s2,16(sp)
    80005cbc:	69a2                	ld	s3,8(sp)
    80005cbe:	6145                	addi	sp,sp,48
    80005cc0:	8082                	ret

0000000080005cc2 <panic>:
{
    80005cc2:	1101                	addi	sp,sp,-32
    80005cc4:	ec06                	sd	ra,24(sp)
    80005cc6:	e822                	sd	s0,16(sp)
    80005cc8:	e426                	sd	s1,8(sp)
    80005cca:	1000                	addi	s0,sp,32
    80005ccc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cce:	00020797          	auipc	a5,0x20
    80005cd2:	5207a923          	sw	zero,1330(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cd6:	00003517          	auipc	a0,0x3
    80005cda:	af250513          	addi	a0,a0,-1294 # 800087c8 <syscalls+0x400>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	036080e7          	jalr	54(ra) # 80005d14 <printf>
  printf(s);
    80005ce6:	8526                	mv	a0,s1
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	02c080e7          	jalr	44(ra) # 80005d14 <printf>
  printf("\n");
    80005cf0:	00002517          	auipc	a0,0x2
    80005cf4:	35850513          	addi	a0,a0,856 # 80008048 <etext+0x48>
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	01c080e7          	jalr	28(ra) # 80005d14 <printf>
  backtrace();
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	f66080e7          	jalr	-154(ra) # 80005c66 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005d08:	4785                	li	a5,1
    80005d0a:	00003717          	auipc	a4,0x3
    80005d0e:	30f72923          	sw	a5,786(a4) # 8000901c <panicked>
  for(;;)
    80005d12:	a001                	j	80005d12 <panic+0x50>

0000000080005d14 <printf>:
{
    80005d14:	7131                	addi	sp,sp,-192
    80005d16:	fc86                	sd	ra,120(sp)
    80005d18:	f8a2                	sd	s0,112(sp)
    80005d1a:	f4a6                	sd	s1,104(sp)
    80005d1c:	f0ca                	sd	s2,96(sp)
    80005d1e:	ecce                	sd	s3,88(sp)
    80005d20:	e8d2                	sd	s4,80(sp)
    80005d22:	e4d6                	sd	s5,72(sp)
    80005d24:	e0da                	sd	s6,64(sp)
    80005d26:	fc5e                	sd	s7,56(sp)
    80005d28:	f862                	sd	s8,48(sp)
    80005d2a:	f466                	sd	s9,40(sp)
    80005d2c:	f06a                	sd	s10,32(sp)
    80005d2e:	ec6e                	sd	s11,24(sp)
    80005d30:	0100                	addi	s0,sp,128
    80005d32:	8a2a                	mv	s4,a0
    80005d34:	e40c                	sd	a1,8(s0)
    80005d36:	e810                	sd	a2,16(s0)
    80005d38:	ec14                	sd	a3,24(s0)
    80005d3a:	f018                	sd	a4,32(s0)
    80005d3c:	f41c                	sd	a5,40(s0)
    80005d3e:	03043823          	sd	a6,48(s0)
    80005d42:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d46:	00020d97          	auipc	s11,0x20
    80005d4a:	4badad83          	lw	s11,1210(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d4e:	020d9b63          	bnez	s11,80005d84 <printf+0x70>
  if (fmt == 0)
    80005d52:	040a0263          	beqz	s4,80005d96 <printf+0x82>
  va_start(ap, fmt);
    80005d56:	00840793          	addi	a5,s0,8
    80005d5a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d5e:	000a4503          	lbu	a0,0(s4)
    80005d62:	14050f63          	beqz	a0,80005ec0 <printf+0x1ac>
    80005d66:	4981                	li	s3,0
    if(c != '%'){
    80005d68:	02500a93          	li	s5,37
    switch(c){
    80005d6c:	07000b93          	li	s7,112
  consputc('x');
    80005d70:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d72:	00003b17          	auipc	s6,0x3
    80005d76:	a76b0b13          	addi	s6,s6,-1418 # 800087e8 <digits>
    switch(c){
    80005d7a:	07300c93          	li	s9,115
    80005d7e:	06400c13          	li	s8,100
    80005d82:	a82d                	j	80005dbc <printf+0xa8>
    acquire(&pr.lock);
    80005d84:	00020517          	auipc	a0,0x20
    80005d88:	46450513          	addi	a0,a0,1124 # 800261e8 <pr>
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	448080e7          	jalr	1096(ra) # 800061d4 <acquire>
    80005d94:	bf7d                	j	80005d52 <printf+0x3e>
    panic("null fmt");
    80005d96:	00003517          	auipc	a0,0x3
    80005d9a:	a4250513          	addi	a0,a0,-1470 # 800087d8 <syscalls+0x410>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	f24080e7          	jalr	-220(ra) # 80005cc2 <panic>
      consputc(c);
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	bcc080e7          	jalr	-1076(ra) # 80005972 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dae:	2985                	addiw	s3,s3,1
    80005db0:	013a07b3          	add	a5,s4,s3
    80005db4:	0007c503          	lbu	a0,0(a5)
    80005db8:	10050463          	beqz	a0,80005ec0 <printf+0x1ac>
    if(c != '%'){
    80005dbc:	ff5515e3          	bne	a0,s5,80005da6 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dc0:	2985                	addiw	s3,s3,1
    80005dc2:	013a07b3          	add	a5,s4,s3
    80005dc6:	0007c783          	lbu	a5,0(a5)
    80005dca:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dce:	cbed                	beqz	a5,80005ec0 <printf+0x1ac>
    switch(c){
    80005dd0:	05778a63          	beq	a5,s7,80005e24 <printf+0x110>
    80005dd4:	02fbf663          	bgeu	s7,a5,80005e00 <printf+0xec>
    80005dd8:	09978863          	beq	a5,s9,80005e68 <printf+0x154>
    80005ddc:	07800713          	li	a4,120
    80005de0:	0ce79563          	bne	a5,a4,80005eaa <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005de4:	f8843783          	ld	a5,-120(s0)
    80005de8:	00878713          	addi	a4,a5,8
    80005dec:	f8e43423          	sd	a4,-120(s0)
    80005df0:	4605                	li	a2,1
    80005df2:	85ea                	mv	a1,s10
    80005df4:	4388                	lw	a0,0(a5)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	d9c080e7          	jalr	-612(ra) # 80005b92 <printint>
      break;
    80005dfe:	bf45                	j	80005dae <printf+0x9a>
    switch(c){
    80005e00:	09578f63          	beq	a5,s5,80005e9e <printf+0x18a>
    80005e04:	0b879363          	bne	a5,s8,80005eaa <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e08:	f8843783          	ld	a5,-120(s0)
    80005e0c:	00878713          	addi	a4,a5,8
    80005e10:	f8e43423          	sd	a4,-120(s0)
    80005e14:	4605                	li	a2,1
    80005e16:	45a9                	li	a1,10
    80005e18:	4388                	lw	a0,0(a5)
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	d78080e7          	jalr	-648(ra) # 80005b92 <printint>
      break;
    80005e22:	b771                	j	80005dae <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e24:	f8843783          	ld	a5,-120(s0)
    80005e28:	00878713          	addi	a4,a5,8
    80005e2c:	f8e43423          	sd	a4,-120(s0)
    80005e30:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e34:	03000513          	li	a0,48
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	b3a080e7          	jalr	-1222(ra) # 80005972 <consputc>
  consputc('x');
    80005e40:	07800513          	li	a0,120
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b2e080e7          	jalr	-1234(ra) # 80005972 <consputc>
    80005e4c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e4e:	03c95793          	srli	a5,s2,0x3c
    80005e52:	97da                	add	a5,a5,s6
    80005e54:	0007c503          	lbu	a0,0(a5)
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	b1a080e7          	jalr	-1254(ra) # 80005972 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e60:	0912                	slli	s2,s2,0x4
    80005e62:	34fd                	addiw	s1,s1,-1
    80005e64:	f4ed                	bnez	s1,80005e4e <printf+0x13a>
    80005e66:	b7a1                	j	80005dae <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e68:	f8843783          	ld	a5,-120(s0)
    80005e6c:	00878713          	addi	a4,a5,8
    80005e70:	f8e43423          	sd	a4,-120(s0)
    80005e74:	6384                	ld	s1,0(a5)
    80005e76:	cc89                	beqz	s1,80005e90 <printf+0x17c>
      for(; *s; s++)
    80005e78:	0004c503          	lbu	a0,0(s1)
    80005e7c:	d90d                	beqz	a0,80005dae <printf+0x9a>
        consputc(*s);
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	af4080e7          	jalr	-1292(ra) # 80005972 <consputc>
      for(; *s; s++)
    80005e86:	0485                	addi	s1,s1,1
    80005e88:	0004c503          	lbu	a0,0(s1)
    80005e8c:	f96d                	bnez	a0,80005e7e <printf+0x16a>
    80005e8e:	b705                	j	80005dae <printf+0x9a>
        s = "(null)";
    80005e90:	00003497          	auipc	s1,0x3
    80005e94:	94048493          	addi	s1,s1,-1728 # 800087d0 <syscalls+0x408>
      for(; *s; s++)
    80005e98:	02800513          	li	a0,40
    80005e9c:	b7cd                	j	80005e7e <printf+0x16a>
      consputc('%');
    80005e9e:	8556                	mv	a0,s5
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	ad2080e7          	jalr	-1326(ra) # 80005972 <consputc>
      break;
    80005ea8:	b719                	j	80005dae <printf+0x9a>
      consputc('%');
    80005eaa:	8556                	mv	a0,s5
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	ac6080e7          	jalr	-1338(ra) # 80005972 <consputc>
      consputc(c);
    80005eb4:	8526                	mv	a0,s1
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	abc080e7          	jalr	-1348(ra) # 80005972 <consputc>
      break;
    80005ebe:	bdc5                	j	80005dae <printf+0x9a>
  if(locking)
    80005ec0:	020d9163          	bnez	s11,80005ee2 <printf+0x1ce>
}
    80005ec4:	70e6                	ld	ra,120(sp)
    80005ec6:	7446                	ld	s0,112(sp)
    80005ec8:	74a6                	ld	s1,104(sp)
    80005eca:	7906                	ld	s2,96(sp)
    80005ecc:	69e6                	ld	s3,88(sp)
    80005ece:	6a46                	ld	s4,80(sp)
    80005ed0:	6aa6                	ld	s5,72(sp)
    80005ed2:	6b06                	ld	s6,64(sp)
    80005ed4:	7be2                	ld	s7,56(sp)
    80005ed6:	7c42                	ld	s8,48(sp)
    80005ed8:	7ca2                	ld	s9,40(sp)
    80005eda:	7d02                	ld	s10,32(sp)
    80005edc:	6de2                	ld	s11,24(sp)
    80005ede:	6129                	addi	sp,sp,192
    80005ee0:	8082                	ret
    release(&pr.lock);
    80005ee2:	00020517          	auipc	a0,0x20
    80005ee6:	30650513          	addi	a0,a0,774 # 800261e8 <pr>
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	39e080e7          	jalr	926(ra) # 80006288 <release>
}
    80005ef2:	bfc9                	j	80005ec4 <printf+0x1b0>

0000000080005ef4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ef4:	1141                	addi	sp,sp,-16
    80005ef6:	e406                	sd	ra,8(sp)
    80005ef8:	e022                	sd	s0,0(sp)
    80005efa:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005efc:	100007b7          	lui	a5,0x10000
    80005f00:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f04:	f8000713          	li	a4,-128
    80005f08:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f0c:	470d                	li	a4,3
    80005f0e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f12:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f16:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f1a:	469d                	li	a3,7
    80005f1c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f20:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f24:	00003597          	auipc	a1,0x3
    80005f28:	8dc58593          	addi	a1,a1,-1828 # 80008800 <digits+0x18>
    80005f2c:	00020517          	auipc	a0,0x20
    80005f30:	2dc50513          	addi	a0,a0,732 # 80026208 <uart_tx_lock>
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	210080e7          	jalr	528(ra) # 80006144 <initlock>
}
    80005f3c:	60a2                	ld	ra,8(sp)
    80005f3e:	6402                	ld	s0,0(sp)
    80005f40:	0141                	addi	sp,sp,16
    80005f42:	8082                	ret

0000000080005f44 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f44:	1101                	addi	sp,sp,-32
    80005f46:	ec06                	sd	ra,24(sp)
    80005f48:	e822                	sd	s0,16(sp)
    80005f4a:	e426                	sd	s1,8(sp)
    80005f4c:	1000                	addi	s0,sp,32
    80005f4e:	84aa                	mv	s1,a0
  push_off();
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	238080e7          	jalr	568(ra) # 80006188 <push_off>

  if(panicked){
    80005f58:	00003797          	auipc	a5,0x3
    80005f5c:	0c47a783          	lw	a5,196(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f60:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f64:	c391                	beqz	a5,80005f68 <uartputc_sync+0x24>
    for(;;)
    80005f66:	a001                	j	80005f66 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f68:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f6c:	0207f793          	andi	a5,a5,32
    80005f70:	dfe5                	beqz	a5,80005f68 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f72:	0ff4f513          	andi	a0,s1,255
    80005f76:	100007b7          	lui	a5,0x10000
    80005f7a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	2aa080e7          	jalr	682(ra) # 80006228 <pop_off>
}
    80005f86:	60e2                	ld	ra,24(sp)
    80005f88:	6442                	ld	s0,16(sp)
    80005f8a:	64a2                	ld	s1,8(sp)
    80005f8c:	6105                	addi	sp,sp,32
    80005f8e:	8082                	ret

0000000080005f90 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f90:	00003797          	auipc	a5,0x3
    80005f94:	0907b783          	ld	a5,144(a5) # 80009020 <uart_tx_r>
    80005f98:	00003717          	auipc	a4,0x3
    80005f9c:	09073703          	ld	a4,144(a4) # 80009028 <uart_tx_w>
    80005fa0:	06f70a63          	beq	a4,a5,80006014 <uartstart+0x84>
{
    80005fa4:	7139                	addi	sp,sp,-64
    80005fa6:	fc06                	sd	ra,56(sp)
    80005fa8:	f822                	sd	s0,48(sp)
    80005faa:	f426                	sd	s1,40(sp)
    80005fac:	f04a                	sd	s2,32(sp)
    80005fae:	ec4e                	sd	s3,24(sp)
    80005fb0:	e852                	sd	s4,16(sp)
    80005fb2:	e456                	sd	s5,8(sp)
    80005fb4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb6:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fba:	00020a17          	auipc	s4,0x20
    80005fbe:	24ea0a13          	addi	s4,s4,590 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fc2:	00003497          	auipc	s1,0x3
    80005fc6:	05e48493          	addi	s1,s1,94 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fca:	00003997          	auipc	s3,0x3
    80005fce:	05e98993          	addi	s3,s3,94 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd2:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fd6:	02077713          	andi	a4,a4,32
    80005fda:	c705                	beqz	a4,80006002 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fdc:	01f7f713          	andi	a4,a5,31
    80005fe0:	9752                	add	a4,a4,s4
    80005fe2:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fe6:	0785                	addi	a5,a5,1
    80005fe8:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fea:	8526                	mv	a0,s1
    80005fec:	ffffb097          	auipc	ra,0xffffb
    80005ff0:	6f8080e7          	jalr	1784(ra) # 800016e4 <wakeup>
    
    WriteReg(THR, c);
    80005ff4:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ff8:	609c                	ld	a5,0(s1)
    80005ffa:	0009b703          	ld	a4,0(s3)
    80005ffe:	fcf71ae3          	bne	a4,a5,80005fd2 <uartstart+0x42>
  }
}
    80006002:	70e2                	ld	ra,56(sp)
    80006004:	7442                	ld	s0,48(sp)
    80006006:	74a2                	ld	s1,40(sp)
    80006008:	7902                	ld	s2,32(sp)
    8000600a:	69e2                	ld	s3,24(sp)
    8000600c:	6a42                	ld	s4,16(sp)
    8000600e:	6aa2                	ld	s5,8(sp)
    80006010:	6121                	addi	sp,sp,64
    80006012:	8082                	ret
    80006014:	8082                	ret

0000000080006016 <uartputc>:
{
    80006016:	7179                	addi	sp,sp,-48
    80006018:	f406                	sd	ra,40(sp)
    8000601a:	f022                	sd	s0,32(sp)
    8000601c:	ec26                	sd	s1,24(sp)
    8000601e:	e84a                	sd	s2,16(sp)
    80006020:	e44e                	sd	s3,8(sp)
    80006022:	e052                	sd	s4,0(sp)
    80006024:	1800                	addi	s0,sp,48
    80006026:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006028:	00020517          	auipc	a0,0x20
    8000602c:	1e050513          	addi	a0,a0,480 # 80026208 <uart_tx_lock>
    80006030:	00000097          	auipc	ra,0x0
    80006034:	1a4080e7          	jalr	420(ra) # 800061d4 <acquire>
  if(panicked){
    80006038:	00003797          	auipc	a5,0x3
    8000603c:	fe47a783          	lw	a5,-28(a5) # 8000901c <panicked>
    80006040:	c391                	beqz	a5,80006044 <uartputc+0x2e>
    for(;;)
    80006042:	a001                	j	80006042 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006044:	00003717          	auipc	a4,0x3
    80006048:	fe473703          	ld	a4,-28(a4) # 80009028 <uart_tx_w>
    8000604c:	00003797          	auipc	a5,0x3
    80006050:	fd47b783          	ld	a5,-44(a5) # 80009020 <uart_tx_r>
    80006054:	02078793          	addi	a5,a5,32
    80006058:	02e79b63          	bne	a5,a4,8000608e <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000605c:	00020997          	auipc	s3,0x20
    80006060:	1ac98993          	addi	s3,s3,428 # 80026208 <uart_tx_lock>
    80006064:	00003497          	auipc	s1,0x3
    80006068:	fbc48493          	addi	s1,s1,-68 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606c:	00003917          	auipc	s2,0x3
    80006070:	fbc90913          	addi	s2,s2,-68 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006074:	85ce                	mv	a1,s3
    80006076:	8526                	mv	a0,s1
    80006078:	ffffb097          	auipc	ra,0xffffb
    8000607c:	4e0080e7          	jalr	1248(ra) # 80001558 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006080:	00093703          	ld	a4,0(s2)
    80006084:	609c                	ld	a5,0(s1)
    80006086:	02078793          	addi	a5,a5,32
    8000608a:	fee785e3          	beq	a5,a4,80006074 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000608e:	00020497          	auipc	s1,0x20
    80006092:	17a48493          	addi	s1,s1,378 # 80026208 <uart_tx_lock>
    80006096:	01f77793          	andi	a5,a4,31
    8000609a:	97a6                	add	a5,a5,s1
    8000609c:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060a0:	0705                	addi	a4,a4,1
    800060a2:	00003797          	auipc	a5,0x3
    800060a6:	f8e7b323          	sd	a4,-122(a5) # 80009028 <uart_tx_w>
      uartstart();
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	ee6080e7          	jalr	-282(ra) # 80005f90 <uartstart>
      release(&uart_tx_lock);
    800060b2:	8526                	mv	a0,s1
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	1d4080e7          	jalr	468(ra) # 80006288 <release>
}
    800060bc:	70a2                	ld	ra,40(sp)
    800060be:	7402                	ld	s0,32(sp)
    800060c0:	64e2                	ld	s1,24(sp)
    800060c2:	6942                	ld	s2,16(sp)
    800060c4:	69a2                	ld	s3,8(sp)
    800060c6:	6a02                	ld	s4,0(sp)
    800060c8:	6145                	addi	sp,sp,48
    800060ca:	8082                	ret

00000000800060cc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060cc:	1141                	addi	sp,sp,-16
    800060ce:	e422                	sd	s0,8(sp)
    800060d0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060d2:	100007b7          	lui	a5,0x10000
    800060d6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060da:	8b85                	andi	a5,a5,1
    800060dc:	cb91                	beqz	a5,800060f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060de:	100007b7          	lui	a5,0x10000
    800060e2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060e6:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060ea:	6422                	ld	s0,8(sp)
    800060ec:	0141                	addi	sp,sp,16
    800060ee:	8082                	ret
    return -1;
    800060f0:	557d                	li	a0,-1
    800060f2:	bfe5                	j	800060ea <uartgetc+0x1e>

00000000800060f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060f4:	1101                	addi	sp,sp,-32
    800060f6:	ec06                	sd	ra,24(sp)
    800060f8:	e822                	sd	s0,16(sp)
    800060fa:	e426                	sd	s1,8(sp)
    800060fc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060fe:	54fd                	li	s1,-1
    80006100:	a029                	j	8000610a <uartintr+0x16>
      break;
    consoleintr(c);
    80006102:	00000097          	auipc	ra,0x0
    80006106:	8b2080e7          	jalr	-1870(ra) # 800059b4 <consoleintr>
    int c = uartgetc();
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	fc2080e7          	jalr	-62(ra) # 800060cc <uartgetc>
    if(c == -1)
    80006112:	fe9518e3          	bne	a0,s1,80006102 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006116:	00020497          	auipc	s1,0x20
    8000611a:	0f248493          	addi	s1,s1,242 # 80026208 <uart_tx_lock>
    8000611e:	8526                	mv	a0,s1
    80006120:	00000097          	auipc	ra,0x0
    80006124:	0b4080e7          	jalr	180(ra) # 800061d4 <acquire>
  uartstart();
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	e68080e7          	jalr	-408(ra) # 80005f90 <uartstart>
  release(&uart_tx_lock);
    80006130:	8526                	mv	a0,s1
    80006132:	00000097          	auipc	ra,0x0
    80006136:	156080e7          	jalr	342(ra) # 80006288 <release>
}
    8000613a:	60e2                	ld	ra,24(sp)
    8000613c:	6442                	ld	s0,16(sp)
    8000613e:	64a2                	ld	s1,8(sp)
    80006140:	6105                	addi	sp,sp,32
    80006142:	8082                	ret

0000000080006144 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006144:	1141                	addi	sp,sp,-16
    80006146:	e422                	sd	s0,8(sp)
    80006148:	0800                	addi	s0,sp,16
  lk->name = name;
    8000614a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000614c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006150:	00053823          	sd	zero,16(a0)
}
    80006154:	6422                	ld	s0,8(sp)
    80006156:	0141                	addi	sp,sp,16
    80006158:	8082                	ret

000000008000615a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000615a:	411c                	lw	a5,0(a0)
    8000615c:	e399                	bnez	a5,80006162 <holding+0x8>
    8000615e:	4501                	li	a0,0
  return r;
}
    80006160:	8082                	ret
{
    80006162:	1101                	addi	sp,sp,-32
    80006164:	ec06                	sd	ra,24(sp)
    80006166:	e822                	sd	s0,16(sp)
    80006168:	e426                	sd	s1,8(sp)
    8000616a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000616c:	6904                	ld	s1,16(a0)
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	cb8080e7          	jalr	-840(ra) # 80000e26 <mycpu>
    80006176:	40a48533          	sub	a0,s1,a0
    8000617a:	00153513          	seqz	a0,a0
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	addi	sp,sp,32
    80006186:	8082                	ret

0000000080006188 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006188:	1101                	addi	sp,sp,-32
    8000618a:	ec06                	sd	ra,24(sp)
    8000618c:	e822                	sd	s0,16(sp)
    8000618e:	e426                	sd	s1,8(sp)
    80006190:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006192:	100024f3          	csrr	s1,sstatus
    80006196:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000619a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000619c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	c86080e7          	jalr	-890(ra) # 80000e26 <mycpu>
    800061a8:	5d3c                	lw	a5,120(a0)
    800061aa:	cf89                	beqz	a5,800061c4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	c7a080e7          	jalr	-902(ra) # 80000e26 <mycpu>
    800061b4:	5d3c                	lw	a5,120(a0)
    800061b6:	2785                	addiw	a5,a5,1
    800061b8:	dd3c                	sw	a5,120(a0)
}
    800061ba:	60e2                	ld	ra,24(sp)
    800061bc:	6442                	ld	s0,16(sp)
    800061be:	64a2                	ld	s1,8(sp)
    800061c0:	6105                	addi	sp,sp,32
    800061c2:	8082                	ret
    mycpu()->intena = old;
    800061c4:	ffffb097          	auipc	ra,0xffffb
    800061c8:	c62080e7          	jalr	-926(ra) # 80000e26 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061cc:	8085                	srli	s1,s1,0x1
    800061ce:	8885                	andi	s1,s1,1
    800061d0:	dd64                	sw	s1,124(a0)
    800061d2:	bfe9                	j	800061ac <push_off+0x24>

00000000800061d4 <acquire>:
{
    800061d4:	1101                	addi	sp,sp,-32
    800061d6:	ec06                	sd	ra,24(sp)
    800061d8:	e822                	sd	s0,16(sp)
    800061da:	e426                	sd	s1,8(sp)
    800061dc:	1000                	addi	s0,sp,32
    800061de:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	fa8080e7          	jalr	-88(ra) # 80006188 <push_off>
  if(holding(lk))
    800061e8:	8526                	mv	a0,s1
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	f70080e7          	jalr	-144(ra) # 8000615a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f2:	4705                	li	a4,1
  if(holding(lk))
    800061f4:	e115                	bnez	a0,80006218 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f6:	87ba                	mv	a5,a4
    800061f8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061fc:	2781                	sext.w	a5,a5
    800061fe:	ffe5                	bnez	a5,800061f6 <acquire+0x22>
  __sync_synchronize();
    80006200:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	c22080e7          	jalr	-990(ra) # 80000e26 <mycpu>
    8000620c:	e888                	sd	a0,16(s1)
}
    8000620e:	60e2                	ld	ra,24(sp)
    80006210:	6442                	ld	s0,16(sp)
    80006212:	64a2                	ld	s1,8(sp)
    80006214:	6105                	addi	sp,sp,32
    80006216:	8082                	ret
    panic("acquire");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	5f050513          	addi	a0,a0,1520 # 80008808 <digits+0x20>
    80006220:	00000097          	auipc	ra,0x0
    80006224:	aa2080e7          	jalr	-1374(ra) # 80005cc2 <panic>

0000000080006228 <pop_off>:

void
pop_off(void)
{
    80006228:	1141                	addi	sp,sp,-16
    8000622a:	e406                	sd	ra,8(sp)
    8000622c:	e022                	sd	s0,0(sp)
    8000622e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006230:	ffffb097          	auipc	ra,0xffffb
    80006234:	bf6080e7          	jalr	-1034(ra) # 80000e26 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006238:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000623c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000623e:	e78d                	bnez	a5,80006268 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006240:	5d3c                	lw	a5,120(a0)
    80006242:	02f05b63          	blez	a5,80006278 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006246:	37fd                	addiw	a5,a5,-1
    80006248:	0007871b          	sext.w	a4,a5
    8000624c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000624e:	eb09                	bnez	a4,80006260 <pop_off+0x38>
    80006250:	5d7c                	lw	a5,124(a0)
    80006252:	c799                	beqz	a5,80006260 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006254:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006258:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000625c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006260:	60a2                	ld	ra,8(sp)
    80006262:	6402                	ld	s0,0(sp)
    80006264:	0141                	addi	sp,sp,16
    80006266:	8082                	ret
    panic("pop_off - interruptible");
    80006268:	00002517          	auipc	a0,0x2
    8000626c:	5a850513          	addi	a0,a0,1448 # 80008810 <digits+0x28>
    80006270:	00000097          	auipc	ra,0x0
    80006274:	a52080e7          	jalr	-1454(ra) # 80005cc2 <panic>
    panic("pop_off");
    80006278:	00002517          	auipc	a0,0x2
    8000627c:	5b050513          	addi	a0,a0,1456 # 80008828 <digits+0x40>
    80006280:	00000097          	auipc	ra,0x0
    80006284:	a42080e7          	jalr	-1470(ra) # 80005cc2 <panic>

0000000080006288 <release>:
{
    80006288:	1101                	addi	sp,sp,-32
    8000628a:	ec06                	sd	ra,24(sp)
    8000628c:	e822                	sd	s0,16(sp)
    8000628e:	e426                	sd	s1,8(sp)
    80006290:	1000                	addi	s0,sp,32
    80006292:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006294:	00000097          	auipc	ra,0x0
    80006298:	ec6080e7          	jalr	-314(ra) # 8000615a <holding>
    8000629c:	c115                	beqz	a0,800062c0 <release+0x38>
  lk->cpu = 0;
    8000629e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062a2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062a6:	0f50000f          	fence	iorw,ow
    800062aa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	f7a080e7          	jalr	-134(ra) # 80006228 <pop_off>
}
    800062b6:	60e2                	ld	ra,24(sp)
    800062b8:	6442                	ld	s0,16(sp)
    800062ba:	64a2                	ld	s1,8(sp)
    800062bc:	6105                	addi	sp,sp,32
    800062be:	8082                	ret
    panic("release");
    800062c0:	00002517          	auipc	a0,0x2
    800062c4:	57050513          	addi	a0,a0,1392 # 80008830 <digits+0x48>
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	9fa080e7          	jalr	-1542(ra) # 80005cc2 <panic>
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
