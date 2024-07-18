
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001f117          	auipc	sp,0x1f
    80000004:	48010113          	addi	sp,sp,1152 # 8001f480 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	70a060ef          	jal	ra,80006720 <start>

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
    80000030:	00027797          	auipc	a5,0x27
    80000034:	55078793          	addi	a5,a5,1360 # 80027580 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	00090913          	mv	s2,s2
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	0ac080e7          	jalr	172(ra) # 80007106 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2) # 8000a068 <kmem+0x18>
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	14c080e7          	jalr	332(ra) # 800071ba <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	b40080e7          	jalr	-1216(ra) # 80006bca <panic>

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
    800000e4:	00009597          	auipc	a1,0x9
    800000e8:	f3458593          	addi	a1,a1,-204 # 80009018 <etext+0x18>
    800000ec:	0000a517          	auipc	a0,0xa
    800000f0:	f6450513          	addi	a0,a0,-156 # 8000a050 <kmem>
    800000f4:	00007097          	auipc	ra,0x7
    800000f8:	f82080e7          	jalr	-126(ra) # 80007076 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00027517          	auipc	a0,0x27
    80000104:	48050513          	addi	a0,a0,1152 # 80027580 <end>
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
    80000122:	0000a497          	auipc	s1,0xa
    80000126:	f2e48493          	addi	s1,s1,-210 # 8000a050 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00007097          	auipc	ra,0x7
    80000130:	fda080e7          	jalr	-38(ra) # 80007106 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	0000a517          	auipc	a0,0xa
    8000013e:	f1650513          	addi	a0,a0,-234 # 8000a050 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00007097          	auipc	ra,0x7
    80000148:	076080e7          	jalr	118(ra) # 800071ba <release>

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
    80000166:	0000a517          	auipc	a0,0xa
    8000016a:	eea50513          	addi	a0,a0,-278 # 8000a050 <kmem>
    8000016e:	00007097          	auipc	ra,0x7
    80000172:	04c080e7          	jalr	76(ra) # 800071ba <release>
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
    8000031e:	1101                	addi	sp,sp,-32
    80000320:	ec06                	sd	ra,24(sp)
    80000322:	e822                	sd	s0,16(sp)
    80000324:	e426                	sd	s1,8(sp)
    80000326:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b46080e7          	jalr	-1210(ra) # 80000e6e <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000330:	0000a497          	auipc	s1,0xa
    80000334:	cd048493          	addi	s1,s1,-816 # 8000a000 <started>
  if(cpuid() == 0){
    80000338:	c531                	beqz	a0,80000384 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000033a:	8526                	mv	a0,s1
    8000033c:	00007097          	auipc	ra,0x7
    80000340:	edc080e7          	jalr	-292(ra) # 80007218 <lockfree_read4>
    80000344:	d97d                	beqz	a0,8000033a <main+0x1c>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	b24080e7          	jalr	-1244(ra) # 80000e6e <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00009517          	auipc	a0,0x9
    80000358:	ce450513          	addi	a0,a0,-796 # 80009038 <etext+0x38>
    8000035c:	00007097          	auipc	ra,0x7
    80000360:	8b8080e7          	jalr	-1864(ra) # 80006c14 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0e8080e7          	jalr	232(ra) # 8000044c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	77e080e7          	jalr	1918(ra) # 80001aea <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	de0080e7          	jalr	-544(ra) # 80005154 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	02c080e7          	jalr	44(ra) # 800013a8 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	758080e7          	jalr	1880(ra) # 80006adc <consoleinit>
    printfinit();
    8000038c:	00007097          	auipc	ra,0x7
    80000390:	a68080e7          	jalr	-1432(ra) # 80006df4 <printfinit>
    printf("\n");
    80000394:	00009517          	auipc	a0,0x9
    80000398:	cb450513          	addi	a0,a0,-844 # 80009048 <etext+0x48>
    8000039c:	00007097          	auipc	ra,0x7
    800003a0:	878080e7          	jalr	-1928(ra) # 80006c14 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00009517          	auipc	a0,0x9
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80009020 <etext+0x20>
    800003ac:	00007097          	auipc	ra,0x7
    800003b0:	868080e7          	jalr	-1944(ra) # 80006c14 <printf>
    printf("\n");
    800003b4:	00009517          	auipc	a0,0x9
    800003b8:	c9450513          	addi	a0,a0,-876 # 80009048 <etext+0x48>
    800003bc:	00007097          	auipc	ra,0x7
    800003c0:	858080e7          	jalr	-1960(ra) # 80006c14 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	362080e7          	jalr	866(ra) # 8000072e <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	078080e7          	jalr	120(ra) # 8000044c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9e4080e7          	jalr	-1564(ra) # 80000dc0 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6de080e7          	jalr	1758(ra) # 80001ac2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6fe080e7          	jalr	1790(ra) # 80001aea <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d36080e7          	jalr	-714(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d58080e7          	jalr	-680(ra) # 80005154 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e56080e7          	jalr	-426(ra) # 8000225a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	4e6080e7          	jalr	1254(ra) # 800028f2 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	490080e7          	jalr	1168(ra) # 800038a4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e60080e7          	jalr	-416(ra) # 8000527c <virtio_disk_init>
    pci_init();
    80000424:	00006097          	auipc	ra,0x6
    80000428:	1fe080e7          	jalr	510(ra) # 80006622 <pci_init>
    sockinit();
    8000042c:	00006097          	auipc	ra,0x6
    80000430:	dec080e7          	jalr	-532(ra) # 80006218 <sockinit>
    userinit();      // first user process
    80000434:	00001097          	auipc	ra,0x1
    80000438:	d3e080e7          	jalr	-706(ra) # 80001172 <userinit>
    __sync_synchronize();
    8000043c:	0ff0000f          	fence
    started = 1;
    80000440:	4785                	li	a5,1
    80000442:	0000a717          	auipc	a4,0xa
    80000446:	baf72f23          	sw	a5,-1090(a4) # 8000a000 <started>
    8000044a:	bf0d                	j	8000037c <main+0x5e>

000000008000044c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000044c:	1141                	addi	sp,sp,-16
    8000044e:	e422                	sd	s0,8(sp)
    80000450:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000452:	0000a797          	auipc	a5,0xa
    80000456:	bb67b783          	ld	a5,-1098(a5) # 8000a008 <kernel_pagetable>
    8000045a:	83b1                	srli	a5,a5,0xc
    8000045c:	577d                	li	a4,-1
    8000045e:	177e                	slli	a4,a4,0x3f
    80000460:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000462:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000466:	12000073          	sfence.vma
  sfence_vma();
}
    8000046a:	6422                	ld	s0,8(sp)
    8000046c:	0141                	addi	sp,sp,16
    8000046e:	8082                	ret

0000000080000470 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000470:	7139                	addi	sp,sp,-64
    80000472:	fc06                	sd	ra,56(sp)
    80000474:	f822                	sd	s0,48(sp)
    80000476:	f426                	sd	s1,40(sp)
    80000478:	f04a                	sd	s2,32(sp)
    8000047a:	ec4e                	sd	s3,24(sp)
    8000047c:	e852                	sd	s4,16(sp)
    8000047e:	e456                	sd	s5,8(sp)
    80000480:	e05a                	sd	s6,0(sp)
    80000482:	0080                	addi	s0,sp,64
    80000484:	84aa                	mv	s1,a0
    80000486:	89ae                	mv	s3,a1
    80000488:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000048a:	57fd                	li	a5,-1
    8000048c:	83e9                	srli	a5,a5,0x1a
    8000048e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000490:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000492:	04b7f263          	bgeu	a5,a1,800004d6 <walk+0x66>
    panic("walk");
    80000496:	00009517          	auipc	a0,0x9
    8000049a:	bba50513          	addi	a0,a0,-1094 # 80009050 <etext+0x50>
    8000049e:	00006097          	auipc	ra,0x6
    800004a2:	72c080e7          	jalr	1836(ra) # 80006bca <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004a6:	060a8663          	beqz	s5,80000512 <walk+0xa2>
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	c6e080e7          	jalr	-914(ra) # 80000118 <kalloc>
    800004b2:	84aa                	mv	s1,a0
    800004b4:	c529                	beqz	a0,800004fe <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004b6:	6605                	lui	a2,0x1
    800004b8:	4581                	li	a1,0
    800004ba:	00000097          	auipc	ra,0x0
    800004be:	cbe080e7          	jalr	-834(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004c2:	00c4d793          	srli	a5,s1,0xc
    800004c6:	07aa                	slli	a5,a5,0xa
    800004c8:	0017e793          	ori	a5,a5,1
    800004cc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004d0:	3a5d                	addiw	s4,s4,-9
    800004d2:	036a0063          	beq	s4,s6,800004f2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004d6:	0149d933          	srl	s2,s3,s4
    800004da:	1ff97913          	andi	s2,s2,511
    800004de:	090e                	slli	s2,s2,0x3
    800004e0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004e2:	00093483          	ld	s1,0(s2)
    800004e6:	0014f793          	andi	a5,s1,1
    800004ea:	dfd5                	beqz	a5,800004a6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ec:	80a9                	srli	s1,s1,0xa
    800004ee:	04b2                	slli	s1,s1,0xc
    800004f0:	b7c5                	j	800004d0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004f2:	00c9d513          	srli	a0,s3,0xc
    800004f6:	1ff57513          	andi	a0,a0,511
    800004fa:	050e                	slli	a0,a0,0x3
    800004fc:	9526                	add	a0,a0,s1
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	74a2                	ld	s1,40(sp)
    80000504:	7902                	ld	s2,32(sp)
    80000506:	69e2                	ld	s3,24(sp)
    80000508:	6a42                	ld	s4,16(sp)
    8000050a:	6aa2                	ld	s5,8(sp)
    8000050c:	6b02                	ld	s6,0(sp)
    8000050e:	6121                	addi	sp,sp,64
    80000510:	8082                	ret
        return 0;
    80000512:	4501                	li	a0,0
    80000514:	b7ed                	j	800004fe <walk+0x8e>

0000000080000516 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000516:	57fd                	li	a5,-1
    80000518:	83e9                	srli	a5,a5,0x1a
    8000051a:	00b7f463          	bgeu	a5,a1,80000522 <walkaddr+0xc>
    return 0;
    8000051e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000520:	8082                	ret
{
    80000522:	1141                	addi	sp,sp,-16
    80000524:	e406                	sd	ra,8(sp)
    80000526:	e022                	sd	s0,0(sp)
    80000528:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000052a:	4601                	li	a2,0
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	f44080e7          	jalr	-188(ra) # 80000470 <walk>
  if(pte == 0)
    80000534:	c105                	beqz	a0,80000554 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000536:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000538:	0117f693          	andi	a3,a5,17
    8000053c:	4745                	li	a4,17
    return 0;
    8000053e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000540:	00e68663          	beq	a3,a4,8000054c <walkaddr+0x36>
}
    80000544:	60a2                	ld	ra,8(sp)
    80000546:	6402                	ld	s0,0(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret
  pa = PTE2PA(*pte);
    8000054c:	00a7d513          	srli	a0,a5,0xa
    80000550:	0532                	slli	a0,a0,0xc
  return pa;
    80000552:	bfcd                	j	80000544 <walkaddr+0x2e>
    return 0;
    80000554:	4501                	li	a0,0
    80000556:	b7fd                	j	80000544 <walkaddr+0x2e>

0000000080000558 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000558:	715d                	addi	sp,sp,-80
    8000055a:	e486                	sd	ra,72(sp)
    8000055c:	e0a2                	sd	s0,64(sp)
    8000055e:	fc26                	sd	s1,56(sp)
    80000560:	f84a                	sd	s2,48(sp)
    80000562:	f44e                	sd	s3,40(sp)
    80000564:	f052                	sd	s4,32(sp)
    80000566:	ec56                	sd	s5,24(sp)
    80000568:	e85a                	sd	s6,16(sp)
    8000056a:	e45e                	sd	s7,8(sp)
    8000056c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000056e:	c639                	beqz	a2,800005bc <mappages+0x64>
    80000570:	8aaa                	mv	s5,a0
    80000572:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000574:	77fd                	lui	a5,0xfffff
    80000576:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000057a:	15fd                	addi	a1,a1,-1
    8000057c:	00c589b3          	add	s3,a1,a2
    80000580:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000584:	8952                	mv	s2,s4
    80000586:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000058a:	6b85                	lui	s7,0x1
    8000058c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000590:	4605                	li	a2,1
    80000592:	85ca                	mv	a1,s2
    80000594:	8556                	mv	a0,s5
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	eda080e7          	jalr	-294(ra) # 80000470 <walk>
    8000059e:	cd1d                	beqz	a0,800005dc <mappages+0x84>
    if(*pte & PTE_V)
    800005a0:	611c                	ld	a5,0(a0)
    800005a2:	8b85                	andi	a5,a5,1
    800005a4:	e785                	bnez	a5,800005cc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005a6:	80b1                	srli	s1,s1,0xc
    800005a8:	04aa                	slli	s1,s1,0xa
    800005aa:	0164e4b3          	or	s1,s1,s6
    800005ae:	0014e493          	ori	s1,s1,1
    800005b2:	e104                	sd	s1,0(a0)
    if(a == last)
    800005b4:	05390063          	beq	s2,s3,800005f4 <mappages+0x9c>
    a += PGSIZE;
    800005b8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ba:	bfc9                	j	8000058c <mappages+0x34>
    panic("mappages: size");
    800005bc:	00009517          	auipc	a0,0x9
    800005c0:	a9c50513          	addi	a0,a0,-1380 # 80009058 <etext+0x58>
    800005c4:	00006097          	auipc	ra,0x6
    800005c8:	606080e7          	jalr	1542(ra) # 80006bca <panic>
      panic("mappages: remap");
    800005cc:	00009517          	auipc	a0,0x9
    800005d0:	a9c50513          	addi	a0,a0,-1380 # 80009068 <etext+0x68>
    800005d4:	00006097          	auipc	ra,0x6
    800005d8:	5f6080e7          	jalr	1526(ra) # 80006bca <panic>
      return -1;
    800005dc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005de:	60a6                	ld	ra,72(sp)
    800005e0:	6406                	ld	s0,64(sp)
    800005e2:	74e2                	ld	s1,56(sp)
    800005e4:	7942                	ld	s2,48(sp)
    800005e6:	79a2                	ld	s3,40(sp)
    800005e8:	7a02                	ld	s4,32(sp)
    800005ea:	6ae2                	ld	s5,24(sp)
    800005ec:	6b42                	ld	s6,16(sp)
    800005ee:	6ba2                	ld	s7,8(sp)
    800005f0:	6161                	addi	sp,sp,80
    800005f2:	8082                	ret
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	b7e5                	j	800005de <mappages+0x86>

00000000800005f8 <kvmmap>:
{
    800005f8:	1141                	addi	sp,sp,-16
    800005fa:	e406                	sd	ra,8(sp)
    800005fc:	e022                	sd	s0,0(sp)
    800005fe:	0800                	addi	s0,sp,16
    80000600:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000602:	86b2                	mv	a3,a2
    80000604:	863e                	mv	a2,a5
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	f52080e7          	jalr	-174(ra) # 80000558 <mappages>
    8000060e:	e509                	bnez	a0,80000618 <kvmmap+0x20>
}
    80000610:	60a2                	ld	ra,8(sp)
    80000612:	6402                	ld	s0,0(sp)
    80000614:	0141                	addi	sp,sp,16
    80000616:	8082                	ret
    panic("kvmmap");
    80000618:	00009517          	auipc	a0,0x9
    8000061c:	a6050513          	addi	a0,a0,-1440 # 80009078 <etext+0x78>
    80000620:	00006097          	auipc	ra,0x6
    80000624:	5aa080e7          	jalr	1450(ra) # 80006bca <panic>

0000000080000628 <kvmmake>:
{
    80000628:	1101                	addi	sp,sp,-32
    8000062a:	ec06                	sd	ra,24(sp)
    8000062c:	e822                	sd	s0,16(sp)
    8000062e:	e426                	sd	s1,8(sp)
    80000630:	e04a                	sd	s2,0(sp)
    80000632:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000634:	00000097          	auipc	ra,0x0
    80000638:	ae4080e7          	jalr	-1308(ra) # 80000118 <kalloc>
    8000063c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000063e:	6605                	lui	a2,0x1
    80000640:	4581                	li	a1,0
    80000642:	00000097          	auipc	ra,0x0
    80000646:	b36080e7          	jalr	-1226(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10000637          	lui	a2,0x10000
    80000652:	100005b7          	lui	a1,0x10000
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	fa0080e7          	jalr	-96(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	6685                	lui	a3,0x1
    80000664:	10001637          	lui	a2,0x10001
    80000668:	100015b7          	lui	a1,0x10001
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	f8a080e7          	jalr	-118(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	100006b7          	lui	a3,0x10000
    8000067c:	30000637          	lui	a2,0x30000
    80000680:	300005b7          	lui	a1,0x30000
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f72080e7          	jalr	-142(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	000206b7          	lui	a3,0x20
    80000694:	40000637          	lui	a2,0x40000
    80000698:	400005b7          	lui	a1,0x40000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f5a080e7          	jalr	-166(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a6:	4719                	li	a4,6
    800006a8:	004006b7          	lui	a3,0x400
    800006ac:	0c000637          	lui	a2,0xc000
    800006b0:	0c0005b7          	lui	a1,0xc000
    800006b4:	8526                	mv	a0,s1
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	f42080e7          	jalr	-190(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006be:	00009917          	auipc	s2,0x9
    800006c2:	94290913          	addi	s2,s2,-1726 # 80009000 <etext>
    800006c6:	4729                	li	a4,10
    800006c8:	80009697          	auipc	a3,0x80009
    800006cc:	93868693          	addi	a3,a3,-1736 # 9000 <_entry-0x7fff7000>
    800006d0:	4605                	li	a2,1
    800006d2:	067e                	slli	a2,a2,0x1f
    800006d4:	85b2                	mv	a1,a2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f20080e7          	jalr	-224(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e0:	4719                	li	a4,6
    800006e2:	46c5                	li	a3,17
    800006e4:	06ee                	slli	a3,a3,0x1b
    800006e6:	412686b3          	sub	a3,a3,s2
    800006ea:	864a                	mv	a2,s2
    800006ec:	85ca                	mv	a1,s2
    800006ee:	8526                	mv	a0,s1
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f08080e7          	jalr	-248(ra) # 800005f8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f8:	4729                	li	a4,10
    800006fa:	6685                	lui	a3,0x1
    800006fc:	00008617          	auipc	a2,0x8
    80000700:	90460613          	addi	a2,a2,-1788 # 80008000 <_trampoline>
    80000704:	040005b7          	lui	a1,0x4000
    80000708:	15fd                	addi	a1,a1,-1
    8000070a:	05b2                	slli	a1,a1,0xc
    8000070c:	8526                	mv	a0,s1
    8000070e:	00000097          	auipc	ra,0x0
    80000712:	eea080e7          	jalr	-278(ra) # 800005f8 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	614080e7          	jalr	1556(ra) # 80000d2c <proc_mapstacks>
}
    80000720:	8526                	mv	a0,s1
    80000722:	60e2                	ld	ra,24(sp)
    80000724:	6442                	ld	s0,16(sp)
    80000726:	64a2                	ld	s1,8(sp)
    80000728:	6902                	ld	s2,0(sp)
    8000072a:	6105                	addi	sp,sp,32
    8000072c:	8082                	ret

000000008000072e <kvminit>:
{
    8000072e:	1141                	addi	sp,sp,-16
    80000730:	e406                	sd	ra,8(sp)
    80000732:	e022                	sd	s0,0(sp)
    80000734:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	ef2080e7          	jalr	-270(ra) # 80000628 <kvmmake>
    8000073e:	0000a797          	auipc	a5,0xa
    80000742:	8ca7b523          	sd	a0,-1846(a5) # 8000a008 <kernel_pagetable>
}
    80000746:	60a2                	ld	ra,8(sp)
    80000748:	6402                	ld	s0,0(sp)
    8000074a:	0141                	addi	sp,sp,16
    8000074c:	8082                	ret

000000008000074e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074e:	715d                	addi	sp,sp,-80
    80000750:	e486                	sd	ra,72(sp)
    80000752:	e0a2                	sd	s0,64(sp)
    80000754:	fc26                	sd	s1,56(sp)
    80000756:	f84a                	sd	s2,48(sp)
    80000758:	f44e                	sd	s3,40(sp)
    8000075a:	f052                	sd	s4,32(sp)
    8000075c:	ec56                	sd	s5,24(sp)
    8000075e:	e85a                	sd	s6,16(sp)
    80000760:	e45e                	sd	s7,8(sp)
    80000762:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000764:	03459793          	slli	a5,a1,0x34
    80000768:	e795                	bnez	a5,80000794 <uvmunmap+0x46>
    8000076a:	8a2a                	mv	s4,a0
    8000076c:	892e                	mv	s2,a1
    8000076e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000770:	0632                	slli	a2,a2,0xc
    80000772:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000776:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000778:	6b05                	lui	s6,0x1
    8000077a:	0735eb63          	bltu	a1,s3,800007f0 <uvmunmap+0xa2>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000077e:	60a6                	ld	ra,72(sp)
    80000780:	6406                	ld	s0,64(sp)
    80000782:	74e2                	ld	s1,56(sp)
    80000784:	7942                	ld	s2,48(sp)
    80000786:	79a2                	ld	s3,40(sp)
    80000788:	7a02                	ld	s4,32(sp)
    8000078a:	6ae2                	ld	s5,24(sp)
    8000078c:	6b42                	ld	s6,16(sp)
    8000078e:	6ba2                	ld	s7,8(sp)
    80000790:	6161                	addi	sp,sp,80
    80000792:	8082                	ret
    panic("uvmunmap: not aligned");
    80000794:	00009517          	auipc	a0,0x9
    80000798:	8ec50513          	addi	a0,a0,-1812 # 80009080 <etext+0x80>
    8000079c:	00006097          	auipc	ra,0x6
    800007a0:	42e080e7          	jalr	1070(ra) # 80006bca <panic>
      panic("uvmunmap: walk");
    800007a4:	00009517          	auipc	a0,0x9
    800007a8:	8f450513          	addi	a0,a0,-1804 # 80009098 <etext+0x98>
    800007ac:	00006097          	auipc	ra,0x6
    800007b0:	41e080e7          	jalr	1054(ra) # 80006bca <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007b4:	85ca                	mv	a1,s2
    800007b6:	00009517          	auipc	a0,0x9
    800007ba:	8f250513          	addi	a0,a0,-1806 # 800090a8 <etext+0xa8>
    800007be:	00006097          	auipc	ra,0x6
    800007c2:	456080e7          	jalr	1110(ra) # 80006c14 <printf>
      panic("uvmunmap: not mapped");
    800007c6:	00009517          	auipc	a0,0x9
    800007ca:	8f250513          	addi	a0,a0,-1806 # 800090b8 <etext+0xb8>
    800007ce:	00006097          	auipc	ra,0x6
    800007d2:	3fc080e7          	jalr	1020(ra) # 80006bca <panic>
      panic("uvmunmap: not a leaf");
    800007d6:	00009517          	auipc	a0,0x9
    800007da:	8fa50513          	addi	a0,a0,-1798 # 800090d0 <etext+0xd0>
    800007de:	00006097          	auipc	ra,0x6
    800007e2:	3ec080e7          	jalr	1004(ra) # 80006bca <panic>
    *pte = 0;
    800007e6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ea:	995a                	add	s2,s2,s6
    800007ec:	f93979e3          	bgeu	s2,s3,8000077e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f0:	4601                	li	a2,0
    800007f2:	85ca                	mv	a1,s2
    800007f4:	8552                	mv	a0,s4
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	c7a080e7          	jalr	-902(ra) # 80000470 <walk>
    800007fe:	84aa                	mv	s1,a0
    80000800:	d155                	beqz	a0,800007a4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    80000802:	6110                	ld	a2,0(a0)
    80000804:	00167793          	andi	a5,a2,1
    80000808:	d7d5                	beqz	a5,800007b4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080a:	3ff67793          	andi	a5,a2,1023
    8000080e:	fd7784e3          	beq	a5,s7,800007d6 <uvmunmap+0x88>
    if(do_free){
    80000812:	fc0a8ae3          	beqz	s5,800007e6 <uvmunmap+0x98>
      uint64 pa = PTE2PA(*pte);
    80000816:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000818:	00c61513          	slli	a0,a2,0xc
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	800080e7          	jalr	-2048(ra) # 8000001c <kfree>
    80000824:	b7c9                	j	800007e6 <uvmunmap+0x98>

0000000080000826 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000826:	1101                	addi	sp,sp,-32
    80000828:	ec06                	sd	ra,24(sp)
    8000082a:	e822                	sd	s0,16(sp)
    8000082c:	e426                	sd	s1,8(sp)
    8000082e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000830:	00000097          	auipc	ra,0x0
    80000834:	8e8080e7          	jalr	-1816(ra) # 80000118 <kalloc>
    80000838:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000083a:	c519                	beqz	a0,80000848 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000083c:	6605                	lui	a2,0x1
    8000083e:	4581                	li	a1,0
    80000840:	00000097          	auipc	ra,0x0
    80000844:	938080e7          	jalr	-1736(ra) # 80000178 <memset>
  return pagetable;
}
    80000848:	8526                	mv	a0,s1
    8000084a:	60e2                	ld	ra,24(sp)
    8000084c:	6442                	ld	s0,16(sp)
    8000084e:	64a2                	ld	s1,8(sp)
    80000850:	6105                	addi	sp,sp,32
    80000852:	8082                	ret

0000000080000854 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000854:	7179                	addi	sp,sp,-48
    80000856:	f406                	sd	ra,40(sp)
    80000858:	f022                	sd	s0,32(sp)
    8000085a:	ec26                	sd	s1,24(sp)
    8000085c:	e84a                	sd	s2,16(sp)
    8000085e:	e44e                	sd	s3,8(sp)
    80000860:	e052                	sd	s4,0(sp)
    80000862:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000864:	6785                	lui	a5,0x1
    80000866:	04f67863          	bgeu	a2,a5,800008b6 <uvminit+0x62>
    8000086a:	8a2a                	mv	s4,a0
    8000086c:	89ae                	mv	s3,a1
    8000086e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000870:	00000097          	auipc	ra,0x0
    80000874:	8a8080e7          	jalr	-1880(ra) # 80000118 <kalloc>
    80000878:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000087a:	6605                	lui	a2,0x1
    8000087c:	4581                	li	a1,0
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	8fa080e7          	jalr	-1798(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000886:	4779                	li	a4,30
    80000888:	86ca                	mv	a3,s2
    8000088a:	6605                	lui	a2,0x1
    8000088c:	4581                	li	a1,0
    8000088e:	8552                	mv	a0,s4
    80000890:	00000097          	auipc	ra,0x0
    80000894:	cc8080e7          	jalr	-824(ra) # 80000558 <mappages>
  memmove(mem, src, sz);
    80000898:	8626                	mv	a2,s1
    8000089a:	85ce                	mv	a1,s3
    8000089c:	854a                	mv	a0,s2
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	936080e7          	jalr	-1738(ra) # 800001d4 <memmove>
}
    800008a6:	70a2                	ld	ra,40(sp)
    800008a8:	7402                	ld	s0,32(sp)
    800008aa:	64e2                	ld	s1,24(sp)
    800008ac:	6942                	ld	s2,16(sp)
    800008ae:	69a2                	ld	s3,8(sp)
    800008b0:	6a02                	ld	s4,0(sp)
    800008b2:	6145                	addi	sp,sp,48
    800008b4:	8082                	ret
    panic("inituvm: more than a page");
    800008b6:	00009517          	auipc	a0,0x9
    800008ba:	83250513          	addi	a0,a0,-1998 # 800090e8 <etext+0xe8>
    800008be:	00006097          	auipc	ra,0x6
    800008c2:	30c080e7          	jalr	780(ra) # 80006bca <panic>

00000000800008c6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c6:	1101                	addi	sp,sp,-32
    800008c8:	ec06                	sd	ra,24(sp)
    800008ca:	e822                	sd	s0,16(sp)
    800008cc:	e426                	sd	s1,8(sp)
    800008ce:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d2:	00b67d63          	bgeu	a2,a1,800008ec <uvmdealloc+0x26>
    800008d6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d8:	6785                	lui	a5,0x1
    800008da:	17fd                	addi	a5,a5,-1
    800008dc:	00f60733          	add	a4,a2,a5
    800008e0:	767d                	lui	a2,0xfffff
    800008e2:	8f71                	and	a4,a4,a2
    800008e4:	97ae                	add	a5,a5,a1
    800008e6:	8ff1                	and	a5,a5,a2
    800008e8:	00f76863          	bltu	a4,a5,800008f8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ec:	8526                	mv	a0,s1
    800008ee:	60e2                	ld	ra,24(sp)
    800008f0:	6442                	ld	s0,16(sp)
    800008f2:	64a2                	ld	s1,8(sp)
    800008f4:	6105                	addi	sp,sp,32
    800008f6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f8:	8f99                	sub	a5,a5,a4
    800008fa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008fc:	4685                	li	a3,1
    800008fe:	0007861b          	sext.w	a2,a5
    80000902:	85ba                	mv	a1,a4
    80000904:	00000097          	auipc	ra,0x0
    80000908:	e4a080e7          	jalr	-438(ra) # 8000074e <uvmunmap>
    8000090c:	b7c5                	j	800008ec <uvmdealloc+0x26>

000000008000090e <uvmalloc>:
  if(newsz < oldsz)
    8000090e:	0ab66163          	bltu	a2,a1,800009b0 <uvmalloc+0xa2>
{
    80000912:	7139                	addi	sp,sp,-64
    80000914:	fc06                	sd	ra,56(sp)
    80000916:	f822                	sd	s0,48(sp)
    80000918:	f426                	sd	s1,40(sp)
    8000091a:	f04a                	sd	s2,32(sp)
    8000091c:	ec4e                	sd	s3,24(sp)
    8000091e:	e852                	sd	s4,16(sp)
    80000920:	e456                	sd	s5,8(sp)
    80000922:	0080                	addi	s0,sp,64
    80000924:	8aaa                	mv	s5,a0
    80000926:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000928:	6985                	lui	s3,0x1
    8000092a:	19fd                	addi	s3,s3,-1
    8000092c:	95ce                	add	a1,a1,s3
    8000092e:	79fd                	lui	s3,0xfffff
    80000930:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000934:	08c9f063          	bgeu	s3,a2,800009b4 <uvmalloc+0xa6>
    80000938:	894e                	mv	s2,s3
    mem = kalloc();
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	7de080e7          	jalr	2014(ra) # 80000118 <kalloc>
    80000942:	84aa                	mv	s1,a0
    if(mem == 0){
    80000944:	c51d                	beqz	a0,80000972 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000946:	6605                	lui	a2,0x1
    80000948:	4581                	li	a1,0
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	82e080e7          	jalr	-2002(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000952:	4779                	li	a4,30
    80000954:	86a6                	mv	a3,s1
    80000956:	6605                	lui	a2,0x1
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	bfc080e7          	jalr	-1028(ra) # 80000558 <mappages>
    80000964:	e905                	bnez	a0,80000994 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000966:	6785                	lui	a5,0x1
    80000968:	993e                	add	s2,s2,a5
    8000096a:	fd4968e3          	bltu	s2,s4,8000093a <uvmalloc+0x2c>
  return newsz;
    8000096e:	8552                	mv	a0,s4
    80000970:	a809                	j	80000982 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000972:	864e                	mv	a2,s3
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	f4e080e7          	jalr	-178(ra) # 800008c6 <uvmdealloc>
      return 0;
    80000980:	4501                	li	a0,0
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	74a2                	ld	s1,40(sp)
    80000988:	7902                	ld	s2,32(sp)
    8000098a:	69e2                	ld	s3,24(sp)
    8000098c:	6a42                	ld	s4,16(sp)
    8000098e:	6aa2                	ld	s5,8(sp)
    80000990:	6121                	addi	sp,sp,64
    80000992:	8082                	ret
      kfree(mem);
    80000994:	8526                	mv	a0,s1
    80000996:	fffff097          	auipc	ra,0xfffff
    8000099a:	686080e7          	jalr	1670(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099e:	864e                	mv	a2,s3
    800009a0:	85ca                	mv	a1,s2
    800009a2:	8556                	mv	a0,s5
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	f22080e7          	jalr	-222(ra) # 800008c6 <uvmdealloc>
      return 0;
    800009ac:	4501                	li	a0,0
    800009ae:	bfd1                	j	80000982 <uvmalloc+0x74>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7f1                	j	80000982 <uvmalloc+0x74>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	addi	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	addi	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a821                	j	800009ea <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d6:	0532                	slli	a0,a0,0xc
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	fe0080e7          	jalr	-32(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e4:	04a1                	addi	s1,s1,8
    800009e6:	03248163          	beq	s1,s2,80000a08 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ea:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ec:	00f57793          	andi	a5,a0,15
    800009f0:	ff3782e3          	beq	a5,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f4:	8905                	andi	a0,a0,1
    800009f6:	d57d                	beqz	a0,800009e4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009f8:	00008517          	auipc	a0,0x8
    800009fc:	71050513          	addi	a0,a0,1808 # 80009108 <etext+0x108>
    80000a00:	00006097          	auipc	ra,0x6
    80000a04:	1ca080e7          	jalr	458(ra) # 80006bca <panic>
    }
  }
  kfree((void*)pagetable);
    80000a08:	8552                	mv	a0,s4
    80000a0a:	fffff097          	auipc	ra,0xfffff
    80000a0e:	612080e7          	jalr	1554(ra) # 8000001c <kfree>
}
    80000a12:	70a2                	ld	ra,40(sp)
    80000a14:	7402                	ld	s0,32(sp)
    80000a16:	64e2                	ld	s1,24(sp)
    80000a18:	6942                	ld	s2,16(sp)
    80000a1a:	69a2                	ld	s3,8(sp)
    80000a1c:	6a02                	ld	s4,0(sp)
    80000a1e:	6145                	addi	sp,sp,48
    80000a20:	8082                	ret

0000000080000a22 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a22:	1101                	addi	sp,sp,-32
    80000a24:	ec06                	sd	ra,24(sp)
    80000a26:	e822                	sd	s0,16(sp)
    80000a28:	e426                	sd	s1,8(sp)
    80000a2a:	1000                	addi	s0,sp,32
    80000a2c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a2e:	e999                	bnez	a1,80000a44 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a30:	8526                	mv	a0,s1
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f86080e7          	jalr	-122(ra) # 800009b8 <freewalk>
}
    80000a3a:	60e2                	ld	ra,24(sp)
    80000a3c:	6442                	ld	s0,16(sp)
    80000a3e:	64a2                	ld	s1,8(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a44:	6605                	lui	a2,0x1
    80000a46:	167d                	addi	a2,a2,-1
    80000a48:	962e                	add	a2,a2,a1
    80000a4a:	4685                	li	a3,1
    80000a4c:	8231                	srli	a2,a2,0xc
    80000a4e:	4581                	li	a1,0
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	cfe080e7          	jalr	-770(ra) # 8000074e <uvmunmap>
    80000a58:	bfe1                	j	80000a30 <uvmfree+0xe>

0000000080000a5a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5a:	c679                	beqz	a2,80000b28 <uvmcopy+0xce>
{
    80000a5c:	715d                	addi	sp,sp,-80
    80000a5e:	e486                	sd	ra,72(sp)
    80000a60:	e0a2                	sd	s0,64(sp)
    80000a62:	fc26                	sd	s1,56(sp)
    80000a64:	f84a                	sd	s2,48(sp)
    80000a66:	f44e                	sd	s3,40(sp)
    80000a68:	f052                	sd	s4,32(sp)
    80000a6a:	ec56                	sd	s5,24(sp)
    80000a6c:	e85a                	sd	s6,16(sp)
    80000a6e:	e45e                	sd	s7,8(sp)
    80000a70:	0880                	addi	s0,sp,80
    80000a72:	8b2a                	mv	s6,a0
    80000a74:	8aae                	mv	s5,a1
    80000a76:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a78:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7a:	4601                	li	a2,0
    80000a7c:	85ce                	mv	a1,s3
    80000a7e:	855a                	mv	a0,s6
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	9f0080e7          	jalr	-1552(ra) # 80000470 <walk>
    80000a88:	c531                	beqz	a0,80000ad4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8a:	6118                	ld	a4,0(a0)
    80000a8c:	00177793          	andi	a5,a4,1
    80000a90:	cbb1                	beqz	a5,80000ae4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a92:	00a75593          	srli	a1,a4,0xa
    80000a96:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a9e:	fffff097          	auipc	ra,0xfffff
    80000aa2:	67a080e7          	jalr	1658(ra) # 80000118 <kalloc>
    80000aa6:	892a                	mv	s2,a0
    80000aa8:	c939                	beqz	a0,80000afe <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aaa:	6605                	lui	a2,0x1
    80000aac:	85de                	mv	a1,s7
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	726080e7          	jalr	1830(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab6:	8726                	mv	a4,s1
    80000ab8:	86ca                	mv	a3,s2
    80000aba:	6605                	lui	a2,0x1
    80000abc:	85ce                	mv	a1,s3
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	a98080e7          	jalr	-1384(ra) # 80000558 <mappages>
    80000ac8:	e515                	bnez	a0,80000af4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aca:	6785                	lui	a5,0x1
    80000acc:	99be                	add	s3,s3,a5
    80000ace:	fb49e6e3          	bltu	s3,s4,80000a7a <uvmcopy+0x20>
    80000ad2:	a081                	j	80000b12 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad4:	00008517          	auipc	a0,0x8
    80000ad8:	64450513          	addi	a0,a0,1604 # 80009118 <etext+0x118>
    80000adc:	00006097          	auipc	ra,0x6
    80000ae0:	0ee080e7          	jalr	238(ra) # 80006bca <panic>
      panic("uvmcopy: page not present");
    80000ae4:	00008517          	auipc	a0,0x8
    80000ae8:	65450513          	addi	a0,a0,1620 # 80009138 <etext+0x138>
    80000aec:	00006097          	auipc	ra,0x6
    80000af0:	0de080e7          	jalr	222(ra) # 80006bca <panic>
      kfree(mem);
    80000af4:	854a                	mv	a0,s2
    80000af6:	fffff097          	auipc	ra,0xfffff
    80000afa:	526080e7          	jalr	1318(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000afe:	4685                	li	a3,1
    80000b00:	00c9d613          	srli	a2,s3,0xc
    80000b04:	4581                	li	a1,0
    80000b06:	8556                	mv	a0,s5
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	c46080e7          	jalr	-954(ra) # 8000074e <uvmunmap>
  return -1;
    80000b10:	557d                	li	a0,-1
}
    80000b12:	60a6                	ld	ra,72(sp)
    80000b14:	6406                	ld	s0,64(sp)
    80000b16:	74e2                	ld	s1,56(sp)
    80000b18:	7942                	ld	s2,48(sp)
    80000b1a:	79a2                	ld	s3,40(sp)
    80000b1c:	7a02                	ld	s4,32(sp)
    80000b1e:	6ae2                	ld	s5,24(sp)
    80000b20:	6b42                	ld	s6,16(sp)
    80000b22:	6ba2                	ld	s7,8(sp)
    80000b24:	6161                	addi	sp,sp,80
    80000b26:	8082                	ret
  return 0;
    80000b28:	4501                	li	a0,0
}
    80000b2a:	8082                	ret

0000000080000b2c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2c:	1141                	addi	sp,sp,-16
    80000b2e:	e406                	sd	ra,8(sp)
    80000b30:	e022                	sd	s0,0(sp)
    80000b32:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b34:	4601                	li	a2,0
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	93a080e7          	jalr	-1734(ra) # 80000470 <walk>
  if(pte == 0)
    80000b3e:	c901                	beqz	a0,80000b4e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b40:	611c                	ld	a5,0(a0)
    80000b42:	9bbd                	andi	a5,a5,-17
    80000b44:	e11c                	sd	a5,0(a0)
}
    80000b46:	60a2                	ld	ra,8(sp)
    80000b48:	6402                	ld	s0,0(sp)
    80000b4a:	0141                	addi	sp,sp,16
    80000b4c:	8082                	ret
    panic("uvmclear");
    80000b4e:	00008517          	auipc	a0,0x8
    80000b52:	60a50513          	addi	a0,a0,1546 # 80009158 <etext+0x158>
    80000b56:	00006097          	auipc	ra,0x6
    80000b5a:	074080e7          	jalr	116(ra) # 80006bca <panic>

0000000080000b5e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b5e:	c6bd                	beqz	a3,80000bcc <copyout+0x6e>
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
    80000b74:	e062                	sd	s8,0(sp)
    80000b76:	0880                	addi	s0,sp,80
    80000b78:	8b2a                	mv	s6,a0
    80000b7a:	8c2e                	mv	s8,a1
    80000b7c:	8a32                	mv	s4,a2
    80000b7e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b80:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b82:	6a85                	lui	s5,0x1
    80000b84:	a015                	j	80000ba8 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b86:	9562                	add	a0,a0,s8
    80000b88:	0004861b          	sext.w	a2,s1
    80000b8c:	85d2                	mv	a1,s4
    80000b8e:	41250533          	sub	a0,a0,s2
    80000b92:	fffff097          	auipc	ra,0xfffff
    80000b96:	642080e7          	jalr	1602(ra) # 800001d4 <memmove>

    len -= n;
    80000b9a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b9e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba4:	02098263          	beqz	s3,80000bc8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ba8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bac:	85ca                	mv	a1,s2
    80000bae:	855a                	mv	a0,s6
    80000bb0:	00000097          	auipc	ra,0x0
    80000bb4:	966080e7          	jalr	-1690(ra) # 80000516 <walkaddr>
    if(pa0 == 0)
    80000bb8:	cd01                	beqz	a0,80000bd0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bba:	418904b3          	sub	s1,s2,s8
    80000bbe:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc0:	fc99f3e3          	bgeu	s3,s1,80000b86 <copyout+0x28>
    80000bc4:	84ce                	mv	s1,s3
    80000bc6:	b7c1                	j	80000b86 <copyout+0x28>
  }
  return 0;
    80000bc8:	4501                	li	a0,0
    80000bca:	a021                	j	80000bd2 <copyout+0x74>
    80000bcc:	4501                	li	a0,0
}
    80000bce:	8082                	ret
      return -1;
    80000bd0:	557d                	li	a0,-1
}
    80000bd2:	60a6                	ld	ra,72(sp)
    80000bd4:	6406                	ld	s0,64(sp)
    80000bd6:	74e2                	ld	s1,56(sp)
    80000bd8:	7942                	ld	s2,48(sp)
    80000bda:	79a2                	ld	s3,40(sp)
    80000bdc:	7a02                	ld	s4,32(sp)
    80000bde:	6ae2                	ld	s5,24(sp)
    80000be0:	6b42                	ld	s6,16(sp)
    80000be2:	6ba2                	ld	s7,8(sp)
    80000be4:	6c02                	ld	s8,0(sp)
    80000be6:	6161                	addi	sp,sp,80
    80000be8:	8082                	ret

0000000080000bea <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000bea:	caa5                	beqz	a3,80000c5a <copyin+0x70>
{
    80000bec:	715d                	addi	sp,sp,-80
    80000bee:	e486                	sd	ra,72(sp)
    80000bf0:	e0a2                	sd	s0,64(sp)
    80000bf2:	fc26                	sd	s1,56(sp)
    80000bf4:	f84a                	sd	s2,48(sp)
    80000bf6:	f44e                	sd	s3,40(sp)
    80000bf8:	f052                	sd	s4,32(sp)
    80000bfa:	ec56                	sd	s5,24(sp)
    80000bfc:	e85a                	sd	s6,16(sp)
    80000bfe:	e45e                	sd	s7,8(sp)
    80000c00:	e062                	sd	s8,0(sp)
    80000c02:	0880                	addi	s0,sp,80
    80000c04:	8b2a                	mv	s6,a0
    80000c06:	8a2e                	mv	s4,a1
    80000c08:	8c32                	mv	s8,a2
    80000c0a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c0c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c0e:	6a85                	lui	s5,0x1
    80000c10:	a01d                	j	80000c36 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c12:	018505b3          	add	a1,a0,s8
    80000c16:	0004861b          	sext.w	a2,s1
    80000c1a:	412585b3          	sub	a1,a1,s2
    80000c1e:	8552                	mv	a0,s4
    80000c20:	fffff097          	auipc	ra,0xfffff
    80000c24:	5b4080e7          	jalr	1460(ra) # 800001d4 <memmove>

    len -= n;
    80000c28:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c2c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c2e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c32:	02098263          	beqz	s3,80000c56 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c36:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3a:	85ca                	mv	a1,s2
    80000c3c:	855a                	mv	a0,s6
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	8d8080e7          	jalr	-1832(ra) # 80000516 <walkaddr>
    if(pa0 == 0)
    80000c46:	cd01                	beqz	a0,80000c5e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c48:	418904b3          	sub	s1,s2,s8
    80000c4c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c4e:	fc99f2e3          	bgeu	s3,s1,80000c12 <copyin+0x28>
    80000c52:	84ce                	mv	s1,s3
    80000c54:	bf7d                	j	80000c12 <copyin+0x28>
  }
  return 0;
    80000c56:	4501                	li	a0,0
    80000c58:	a021                	j	80000c60 <copyin+0x76>
    80000c5a:	4501                	li	a0,0
}
    80000c5c:	8082                	ret
      return -1;
    80000c5e:	557d                	li	a0,-1
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6c02                	ld	s8,0(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret

0000000080000c78 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c78:	c6c5                	beqz	a3,80000d20 <copyinstr+0xa8>
{
    80000c7a:	715d                	addi	sp,sp,-80
    80000c7c:	e486                	sd	ra,72(sp)
    80000c7e:	e0a2                	sd	s0,64(sp)
    80000c80:	fc26                	sd	s1,56(sp)
    80000c82:	f84a                	sd	s2,48(sp)
    80000c84:	f44e                	sd	s3,40(sp)
    80000c86:	f052                	sd	s4,32(sp)
    80000c88:	ec56                	sd	s5,24(sp)
    80000c8a:	e85a                	sd	s6,16(sp)
    80000c8c:	e45e                	sd	s7,8(sp)
    80000c8e:	0880                	addi	s0,sp,80
    80000c90:	8a2a                	mv	s4,a0
    80000c92:	8b2e                	mv	s6,a1
    80000c94:	8bb2                	mv	s7,a2
    80000c96:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c98:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9a:	6985                	lui	s3,0x1
    80000c9c:	a035                	j	80000cc8 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c9e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca4:	0017b793          	seqz	a5,a5
    80000ca8:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cac:	60a6                	ld	ra,72(sp)
    80000cae:	6406                	ld	s0,64(sp)
    80000cb0:	74e2                	ld	s1,56(sp)
    80000cb2:	7942                	ld	s2,48(sp)
    80000cb4:	79a2                	ld	s3,40(sp)
    80000cb6:	7a02                	ld	s4,32(sp)
    80000cb8:	6ae2                	ld	s5,24(sp)
    80000cba:	6b42                	ld	s6,16(sp)
    80000cbc:	6ba2                	ld	s7,8(sp)
    80000cbe:	6161                	addi	sp,sp,80
    80000cc0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cc6:	c8a9                	beqz	s1,80000d18 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cc8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ccc:	85ca                	mv	a1,s2
    80000cce:	8552                	mv	a0,s4
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	846080e7          	jalr	-1978(ra) # 80000516 <walkaddr>
    if(pa0 == 0)
    80000cd8:	c131                	beqz	a0,80000d1c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cda:	41790833          	sub	a6,s2,s7
    80000cde:	984e                	add	a6,a6,s3
    if(n > max)
    80000ce0:	0104f363          	bgeu	s1,a6,80000ce6 <copyinstr+0x6e>
    80000ce4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ce6:	955e                	add	a0,a0,s7
    80000ce8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cec:	fc080be3          	beqz	a6,80000cc2 <copyinstr+0x4a>
    80000cf0:	985a                	add	a6,a6,s6
    80000cf2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cf4:	41650633          	sub	a2,a0,s6
    80000cf8:	14fd                	addi	s1,s1,-1
    80000cfa:	9b26                	add	s6,s6,s1
    80000cfc:	00f60733          	add	a4,a2,a5
    80000d00:	00074703          	lbu	a4,0(a4)
    80000d04:	df49                	beqz	a4,80000c9e <copyinstr+0x26>
        *dst = *p;
    80000d06:	00e78023          	sb	a4,0(a5)
      --max;
    80000d0a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d0e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d10:	ff0796e3          	bne	a5,a6,80000cfc <copyinstr+0x84>
      dst++;
    80000d14:	8b42                	mv	s6,a6
    80000d16:	b775                	j	80000cc2 <copyinstr+0x4a>
    80000d18:	4781                	li	a5,0
    80000d1a:	b769                	j	80000ca4 <copyinstr+0x2c>
      return -1;
    80000d1c:	557d                	li	a0,-1
    80000d1e:	b779                	j	80000cac <copyinstr+0x34>
  int got_null = 0;
    80000d20:	4781                	li	a5,0
  if(got_null){
    80000d22:	0017b793          	seqz	a5,a5
    80000d26:	40f00533          	neg	a0,a5
}
    80000d2a:	8082                	ret

0000000080000d2c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d2c:	7139                	addi	sp,sp,-64
    80000d2e:	fc06                	sd	ra,56(sp)
    80000d30:	f822                	sd	s0,48(sp)
    80000d32:	f426                	sd	s1,40(sp)
    80000d34:	f04a                	sd	s2,32(sp)
    80000d36:	ec4e                	sd	s3,24(sp)
    80000d38:	e852                	sd	s4,16(sp)
    80000d3a:	e456                	sd	s5,8(sp)
    80000d3c:	e05a                	sd	s6,0(sp)
    80000d3e:	0080                	addi	s0,sp,64
    80000d40:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d42:	00009497          	auipc	s1,0x9
    80000d46:	75e48493          	addi	s1,s1,1886 # 8000a4a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d4a:	8b26                	mv	s6,s1
    80000d4c:	00008a97          	auipc	s5,0x8
    80000d50:	2b4a8a93          	addi	s5,s5,692 # 80009000 <etext>
    80000d54:	01000937          	lui	s2,0x1000
    80000d58:	197d                	addi	s2,s2,-1
    80000d5a:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5c:	0000fa17          	auipc	s4,0xf
    80000d60:	144a0a13          	addi	s4,s4,324 # 8000fea0 <tickslock>
    char *pa = kalloc();
    80000d64:	fffff097          	auipc	ra,0xfffff
    80000d68:	3b4080e7          	jalr	948(ra) # 80000118 <kalloc>
    80000d6c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d6e:	c129                	beqz	a0,80000db0 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d70:	416485b3          	sub	a1,s1,s6
    80000d74:	858d                	srai	a1,a1,0x3
    80000d76:	000ab783          	ld	a5,0(s5)
    80000d7a:	02f585b3          	mul	a1,a1,a5
    80000d7e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d82:	4719                	li	a4,6
    80000d84:	6685                	lui	a3,0x1
    80000d86:	40b905b3          	sub	a1,s2,a1
    80000d8a:	854e                	mv	a0,s3
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	86c080e7          	jalr	-1940(ra) # 800005f8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d94:	16848493          	addi	s1,s1,360
    80000d98:	fd4496e3          	bne	s1,s4,80000d64 <proc_mapstacks+0x38>
  }
}
    80000d9c:	70e2                	ld	ra,56(sp)
    80000d9e:	7442                	ld	s0,48(sp)
    80000da0:	74a2                	ld	s1,40(sp)
    80000da2:	7902                	ld	s2,32(sp)
    80000da4:	69e2                	ld	s3,24(sp)
    80000da6:	6a42                	ld	s4,16(sp)
    80000da8:	6aa2                	ld	s5,8(sp)
    80000daa:	6b02                	ld	s6,0(sp)
    80000dac:	6121                	addi	sp,sp,64
    80000dae:	8082                	ret
      panic("kalloc");
    80000db0:	00008517          	auipc	a0,0x8
    80000db4:	3b850513          	addi	a0,a0,952 # 80009168 <etext+0x168>
    80000db8:	00006097          	auipc	ra,0x6
    80000dbc:	e12080e7          	jalr	-494(ra) # 80006bca <panic>

0000000080000dc0 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000dc0:	7139                	addi	sp,sp,-64
    80000dc2:	fc06                	sd	ra,56(sp)
    80000dc4:	f822                	sd	s0,48(sp)
    80000dc6:	f426                	sd	s1,40(sp)
    80000dc8:	f04a                	sd	s2,32(sp)
    80000dca:	ec4e                	sd	s3,24(sp)
    80000dcc:	e852                	sd	s4,16(sp)
    80000dce:	e456                	sd	s5,8(sp)
    80000dd0:	e05a                	sd	s6,0(sp)
    80000dd2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd4:	00008597          	auipc	a1,0x8
    80000dd8:	39c58593          	addi	a1,a1,924 # 80009170 <etext+0x170>
    80000ddc:	00009517          	auipc	a0,0x9
    80000de0:	29450513          	addi	a0,a0,660 # 8000a070 <pid_lock>
    80000de4:	00006097          	auipc	ra,0x6
    80000de8:	292080e7          	jalr	658(ra) # 80007076 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dec:	00008597          	auipc	a1,0x8
    80000df0:	38c58593          	addi	a1,a1,908 # 80009178 <etext+0x178>
    80000df4:	00009517          	auipc	a0,0x9
    80000df8:	29450513          	addi	a0,a0,660 # 8000a088 <wait_lock>
    80000dfc:	00006097          	auipc	ra,0x6
    80000e00:	27a080e7          	jalr	634(ra) # 80007076 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e04:	00009497          	auipc	s1,0x9
    80000e08:	69c48493          	addi	s1,s1,1692 # 8000a4a0 <proc>
      initlock(&p->lock, "proc");
    80000e0c:	00008b17          	auipc	s6,0x8
    80000e10:	37cb0b13          	addi	s6,s6,892 # 80009188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000e14:	8aa6                	mv	s5,s1
    80000e16:	00008a17          	auipc	s4,0x8
    80000e1a:	1eaa0a13          	addi	s4,s4,490 # 80009000 <etext>
    80000e1e:	01000937          	lui	s2,0x1000
    80000e22:	197d                	addi	s2,s2,-1
    80000e24:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e26:	0000f997          	auipc	s3,0xf
    80000e2a:	07a98993          	addi	s3,s3,122 # 8000fea0 <tickslock>
      initlock(&p->lock, "proc");
    80000e2e:	85da                	mv	a1,s6
    80000e30:	8526                	mv	a0,s1
    80000e32:	00006097          	auipc	ra,0x6
    80000e36:	244080e7          	jalr	580(ra) # 80007076 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e3a:	415487b3          	sub	a5,s1,s5
    80000e3e:	878d                	srai	a5,a5,0x3
    80000e40:	000a3703          	ld	a4,0(s4)
    80000e44:	02e787b3          	mul	a5,a5,a4
    80000e48:	00d7979b          	slliw	a5,a5,0xd
    80000e4c:	40f907b3          	sub	a5,s2,a5
    80000e50:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	16848493          	addi	s1,s1,360
    80000e56:	fd349ce3          	bne	s1,s3,80000e2e <procinit+0x6e>
  }
}
    80000e5a:	70e2                	ld	ra,56(sp)
    80000e5c:	7442                	ld	s0,48(sp)
    80000e5e:	74a2                	ld	s1,40(sp)
    80000e60:	7902                	ld	s2,32(sp)
    80000e62:	69e2                	ld	s3,24(sp)
    80000e64:	6a42                	ld	s4,16(sp)
    80000e66:	6aa2                	ld	s5,8(sp)
    80000e68:	6b02                	ld	s6,0(sp)
    80000e6a:	6121                	addi	sp,sp,64
    80000e6c:	8082                	ret

0000000080000e6e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e6e:	1141                	addi	sp,sp,-16
    80000e70:	e422                	sd	s0,8(sp)
    80000e72:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e74:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e76:	2501                	sext.w	a0,a0
    80000e78:	6422                	ld	s0,8(sp)
    80000e7a:	0141                	addi	sp,sp,16
    80000e7c:	8082                	ret

0000000080000e7e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e7e:	1141                	addi	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	addi	s0,sp,16
    80000e84:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e86:	2781                	sext.w	a5,a5
    80000e88:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e8a:	00009517          	auipc	a0,0x9
    80000e8e:	21650513          	addi	a0,a0,534 # 8000a0a0 <cpus>
    80000e92:	953e                	add	a0,a0,a5
    80000e94:	6422                	ld	s0,8(sp)
    80000e96:	0141                	addi	sp,sp,16
    80000e98:	8082                	ret

0000000080000e9a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e9a:	1101                	addi	sp,sp,-32
    80000e9c:	ec06                	sd	ra,24(sp)
    80000e9e:	e822                	sd	s0,16(sp)
    80000ea0:	e426                	sd	s1,8(sp)
    80000ea2:	1000                	addi	s0,sp,32
  push_off();
    80000ea4:	00006097          	auipc	ra,0x6
    80000ea8:	216080e7          	jalr	534(ra) # 800070ba <push_off>
    80000eac:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eae:	2781                	sext.w	a5,a5
    80000eb0:	079e                	slli	a5,a5,0x7
    80000eb2:	00009717          	auipc	a4,0x9
    80000eb6:	1be70713          	addi	a4,a4,446 # 8000a070 <pid_lock>
    80000eba:	97ba                	add	a5,a5,a4
    80000ebc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ebe:	00006097          	auipc	ra,0x6
    80000ec2:	29c080e7          	jalr	668(ra) # 8000715a <pop_off>
  return p;
}
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	60e2                	ld	ra,24(sp)
    80000eca:	6442                	ld	s0,16(sp)
    80000ecc:	64a2                	ld	s1,8(sp)
    80000ece:	6105                	addi	sp,sp,32
    80000ed0:	8082                	ret

0000000080000ed2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eda:	00000097          	auipc	ra,0x0
    80000ede:	fc0080e7          	jalr	-64(ra) # 80000e9a <myproc>
    80000ee2:	00006097          	auipc	ra,0x6
    80000ee6:	2d8080e7          	jalr	728(ra) # 800071ba <release>

  if (first) {
    80000eea:	00009797          	auipc	a5,0x9
    80000eee:	9c67a783          	lw	a5,-1594(a5) # 800098b0 <first.1>
    80000ef2:	eb89                	bnez	a5,80000f04 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ef4:	00001097          	auipc	ra,0x1
    80000ef8:	c0e080e7          	jalr	-1010(ra) # 80001b02 <usertrapret>
}
    80000efc:	60a2                	ld	ra,8(sp)
    80000efe:	6402                	ld	s0,0(sp)
    80000f00:	0141                	addi	sp,sp,16
    80000f02:	8082                	ret
    first = 0;
    80000f04:	00009797          	auipc	a5,0x9
    80000f08:	9a07a623          	sw	zero,-1620(a5) # 800098b0 <first.1>
    fsinit(ROOTDEV);
    80000f0c:	4505                	li	a0,1
    80000f0e:	00002097          	auipc	ra,0x2
    80000f12:	964080e7          	jalr	-1692(ra) # 80002872 <fsinit>
    80000f16:	bff9                	j	80000ef4 <forkret+0x22>

0000000080000f18 <allocpid>:
allocpid() {
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f24:	00009917          	auipc	s2,0x9
    80000f28:	14c90913          	addi	s2,s2,332 # 8000a070 <pid_lock>
    80000f2c:	854a                	mv	a0,s2
    80000f2e:	00006097          	auipc	ra,0x6
    80000f32:	1d8080e7          	jalr	472(ra) # 80007106 <acquire>
  pid = nextpid;
    80000f36:	00009797          	auipc	a5,0x9
    80000f3a:	97e78793          	addi	a5,a5,-1666 # 800098b4 <nextpid>
    80000f3e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f40:	0014871b          	addiw	a4,s1,1
    80000f44:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f46:	854a                	mv	a0,s2
    80000f48:	00006097          	auipc	ra,0x6
    80000f4c:	272080e7          	jalr	626(ra) # 800071ba <release>
}
    80000f50:	8526                	mv	a0,s1
    80000f52:	60e2                	ld	ra,24(sp)
    80000f54:	6442                	ld	s0,16(sp)
    80000f56:	64a2                	ld	s1,8(sp)
    80000f58:	6902                	ld	s2,0(sp)
    80000f5a:	6105                	addi	sp,sp,32
    80000f5c:	8082                	ret

0000000080000f5e <proc_pagetable>:
{
    80000f5e:	1101                	addi	sp,sp,-32
    80000f60:	ec06                	sd	ra,24(sp)
    80000f62:	e822                	sd	s0,16(sp)
    80000f64:	e426                	sd	s1,8(sp)
    80000f66:	e04a                	sd	s2,0(sp)
    80000f68:	1000                	addi	s0,sp,32
    80000f6a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	8ba080e7          	jalr	-1862(ra) # 80000826 <uvmcreate>
    80000f74:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f76:	c121                	beqz	a0,80000fb6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f78:	4729                	li	a4,10
    80000f7a:	00007697          	auipc	a3,0x7
    80000f7e:	08668693          	addi	a3,a3,134 # 80008000 <_trampoline>
    80000f82:	6605                	lui	a2,0x1
    80000f84:	040005b7          	lui	a1,0x4000
    80000f88:	15fd                	addi	a1,a1,-1
    80000f8a:	05b2                	slli	a1,a1,0xc
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5cc080e7          	jalr	1484(ra) # 80000558 <mappages>
    80000f94:	02054863          	bltz	a0,80000fc4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f98:	4719                	li	a4,6
    80000f9a:	05893683          	ld	a3,88(s2)
    80000f9e:	6605                	lui	a2,0x1
    80000fa0:	020005b7          	lui	a1,0x2000
    80000fa4:	15fd                	addi	a1,a1,-1
    80000fa6:	05b6                	slli	a1,a1,0xd
    80000fa8:	8526                	mv	a0,s1
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	5ae080e7          	jalr	1454(ra) # 80000558 <mappages>
    80000fb2:	02054163          	bltz	a0,80000fd4 <proc_pagetable+0x76>
}
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	60e2                	ld	ra,24(sp)
    80000fba:	6442                	ld	s0,16(sp)
    80000fbc:	64a2                	ld	s1,8(sp)
    80000fbe:	6902                	ld	s2,0(sp)
    80000fc0:	6105                	addi	sp,sp,32
    80000fc2:	8082                	ret
    uvmfree(pagetable, 0);
    80000fc4:	4581                	li	a1,0
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	a5a080e7          	jalr	-1446(ra) # 80000a22 <uvmfree>
    return 0;
    80000fd0:	4481                	li	s1,0
    80000fd2:	b7d5                	j	80000fb6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd4:	4681                	li	a3,0
    80000fd6:	4605                	li	a2,1
    80000fd8:	040005b7          	lui	a1,0x4000
    80000fdc:	15fd                	addi	a1,a1,-1
    80000fde:	05b2                	slli	a1,a1,0xc
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	76c080e7          	jalr	1900(ra) # 8000074e <uvmunmap>
    uvmfree(pagetable, 0);
    80000fea:	4581                	li	a1,0
    80000fec:	8526                	mv	a0,s1
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	a34080e7          	jalr	-1484(ra) # 80000a22 <uvmfree>
    return 0;
    80000ff6:	4481                	li	s1,0
    80000ff8:	bf7d                	j	80000fb6 <proc_pagetable+0x58>

0000000080000ffa <proc_freepagetable>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	e04a                	sd	s2,0(sp)
    80001004:	1000                	addi	s0,sp,32
    80001006:	84aa                	mv	s1,a0
    80001008:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000100a:	4681                	li	a3,0
    8000100c:	4605                	li	a2,1
    8000100e:	040005b7          	lui	a1,0x4000
    80001012:	15fd                	addi	a1,a1,-1
    80001014:	05b2                	slli	a1,a1,0xc
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	738080e7          	jalr	1848(ra) # 8000074e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000101e:	4681                	li	a3,0
    80001020:	4605                	li	a2,1
    80001022:	020005b7          	lui	a1,0x2000
    80001026:	15fd                	addi	a1,a1,-1
    80001028:	05b6                	slli	a1,a1,0xd
    8000102a:	8526                	mv	a0,s1
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	722080e7          	jalr	1826(ra) # 8000074e <uvmunmap>
  uvmfree(pagetable, sz);
    80001034:	85ca                	mv	a1,s2
    80001036:	8526                	mv	a0,s1
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	9ea080e7          	jalr	-1558(ra) # 80000a22 <uvmfree>
}
    80001040:	60e2                	ld	ra,24(sp)
    80001042:	6442                	ld	s0,16(sp)
    80001044:	64a2                	ld	s1,8(sp)
    80001046:	6902                	ld	s2,0(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret

000000008000104c <freeproc>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	1000                	addi	s0,sp,32
    80001056:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001058:	6d28                	ld	a0,88(a0)
    8000105a:	c509                	beqz	a0,80001064 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000105c:	fffff097          	auipc	ra,0xfffff
    80001060:	fc0080e7          	jalr	-64(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001064:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001068:	68a8                	ld	a0,80(s1)
    8000106a:	c511                	beqz	a0,80001076 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000106c:	64ac                	ld	a1,72(s1)
    8000106e:	00000097          	auipc	ra,0x0
    80001072:	f8c080e7          	jalr	-116(ra) # 80000ffa <proc_freepagetable>
  p->pagetable = 0;
    80001076:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000107a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000107e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001082:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001086:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000108a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000108e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001092:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001096:	0004ac23          	sw	zero,24(s1)
}
    8000109a:	60e2                	ld	ra,24(sp)
    8000109c:	6442                	ld	s0,16(sp)
    8000109e:	64a2                	ld	s1,8(sp)
    800010a0:	6105                	addi	sp,sp,32
    800010a2:	8082                	ret

00000000800010a4 <allocproc>:
{
    800010a4:	1101                	addi	sp,sp,-32
    800010a6:	ec06                	sd	ra,24(sp)
    800010a8:	e822                	sd	s0,16(sp)
    800010aa:	e426                	sd	s1,8(sp)
    800010ac:	e04a                	sd	s2,0(sp)
    800010ae:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b0:	00009497          	auipc	s1,0x9
    800010b4:	3f048493          	addi	s1,s1,1008 # 8000a4a0 <proc>
    800010b8:	0000f917          	auipc	s2,0xf
    800010bc:	de890913          	addi	s2,s2,-536 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00006097          	auipc	ra,0x6
    800010c6:	044080e7          	jalr	68(ra) # 80007106 <acquire>
    if(p->state == UNUSED) {
    800010ca:	4c9c                	lw	a5,24(s1)
    800010cc:	cf81                	beqz	a5,800010e4 <allocproc+0x40>
      release(&p->lock);
    800010ce:	8526                	mv	a0,s1
    800010d0:	00006097          	auipc	ra,0x6
    800010d4:	0ea080e7          	jalr	234(ra) # 800071ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d8:	16848493          	addi	s1,s1,360
    800010dc:	ff2492e3          	bne	s1,s2,800010c0 <allocproc+0x1c>
  return 0;
    800010e0:	4481                	li	s1,0
    800010e2:	a889                	j	80001134 <allocproc+0x90>
  p->pid = allocpid();
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e34080e7          	jalr	-460(ra) # 80000f18 <allocpid>
    800010ec:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ee:	4785                	li	a5,1
    800010f0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	026080e7          	jalr	38(ra) # 80000118 <kalloc>
    800010fa:	892a                	mv	s2,a0
    800010fc:	eca8                	sd	a0,88(s1)
    800010fe:	c131                	beqz	a0,80001142 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	e5c080e7          	jalr	-420(ra) # 80000f5e <proc_pagetable>
    8000110a:	892a                	mv	s2,a0
    8000110c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000110e:	c531                	beqz	a0,8000115a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001110:	07000613          	li	a2,112
    80001114:	4581                	li	a1,0
    80001116:	06048513          	addi	a0,s1,96
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	05e080e7          	jalr	94(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001122:	00000797          	auipc	a5,0x0
    80001126:	db078793          	addi	a5,a5,-592 # 80000ed2 <forkret>
    8000112a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000112c:	60bc                	ld	a5,64(s1)
    8000112e:	6705                	lui	a4,0x1
    80001130:	97ba                	add	a5,a5,a4
    80001132:	f4bc                	sd	a5,104(s1)
}
    80001134:	8526                	mv	a0,s1
    80001136:	60e2                	ld	ra,24(sp)
    80001138:	6442                	ld	s0,16(sp)
    8000113a:	64a2                	ld	s1,8(sp)
    8000113c:	6902                	ld	s2,0(sp)
    8000113e:	6105                	addi	sp,sp,32
    80001140:	8082                	ret
    freeproc(p);
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f08080e7          	jalr	-248(ra) # 8000104c <freeproc>
    release(&p->lock);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00006097          	auipc	ra,0x6
    80001152:	06c080e7          	jalr	108(ra) # 800071ba <release>
    return 0;
    80001156:	84ca                	mv	s1,s2
    80001158:	bff1                	j	80001134 <allocproc+0x90>
    freeproc(p);
    8000115a:	8526                	mv	a0,s1
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	ef0080e7          	jalr	-272(ra) # 8000104c <freeproc>
    release(&p->lock);
    80001164:	8526                	mv	a0,s1
    80001166:	00006097          	auipc	ra,0x6
    8000116a:	054080e7          	jalr	84(ra) # 800071ba <release>
    return 0;
    8000116e:	84ca                	mv	s1,s2
    80001170:	b7d1                	j	80001134 <allocproc+0x90>

0000000080001172 <userinit>:
{
    80001172:	1101                	addi	sp,sp,-32
    80001174:	ec06                	sd	ra,24(sp)
    80001176:	e822                	sd	s0,16(sp)
    80001178:	e426                	sd	s1,8(sp)
    8000117a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	f28080e7          	jalr	-216(ra) # 800010a4 <allocproc>
    80001184:	84aa                	mv	s1,a0
  initproc = p;
    80001186:	00009797          	auipc	a5,0x9
    8000118a:	e8a7b523          	sd	a0,-374(a5) # 8000a010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000118e:	03400613          	li	a2,52
    80001192:	00008597          	auipc	a1,0x8
    80001196:	73e58593          	addi	a1,a1,1854 # 800098d0 <initcode>
    8000119a:	6928                	ld	a0,80(a0)
    8000119c:	fffff097          	auipc	ra,0xfffff
    800011a0:	6b8080e7          	jalr	1720(ra) # 80000854 <uvminit>
  p->sz = PGSIZE;
    800011a4:	6785                	lui	a5,0x1
    800011a6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a8:	6cb8                	ld	a4,88(s1)
    800011aa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ae:	6cb8                	ld	a4,88(s1)
    800011b0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b2:	4641                	li	a2,16
    800011b4:	00008597          	auipc	a1,0x8
    800011b8:	fdc58593          	addi	a1,a1,-36 # 80009190 <etext+0x190>
    800011bc:	15848513          	addi	a0,s1,344
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	102080e7          	jalr	258(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011c8:	00008517          	auipc	a0,0x8
    800011cc:	fd850513          	addi	a0,a0,-40 # 800091a0 <etext+0x1a0>
    800011d0:	00002097          	auipc	ra,0x2
    800011d4:	0d0080e7          	jalr	208(ra) # 800032a0 <namei>
    800011d8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011dc:	478d                	li	a5,3
    800011de:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00006097          	auipc	ra,0x6
    800011e6:	fd8080e7          	jalr	-40(ra) # 800071ba <release>
}
    800011ea:	60e2                	ld	ra,24(sp)
    800011ec:	6442                	ld	s0,16(sp)
    800011ee:	64a2                	ld	s1,8(sp)
    800011f0:	6105                	addi	sp,sp,32
    800011f2:	8082                	ret

00000000800011f4 <growproc>:
{
    800011f4:	1101                	addi	sp,sp,-32
    800011f6:	ec06                	sd	ra,24(sp)
    800011f8:	e822                	sd	s0,16(sp)
    800011fa:	e426                	sd	s1,8(sp)
    800011fc:	e04a                	sd	s2,0(sp)
    800011fe:	1000                	addi	s0,sp,32
    80001200:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001202:	00000097          	auipc	ra,0x0
    80001206:	c98080e7          	jalr	-872(ra) # 80000e9a <myproc>
    8000120a:	892a                	mv	s2,a0
  sz = p->sz;
    8000120c:	652c                	ld	a1,72(a0)
    8000120e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001212:	00904f63          	bgtz	s1,80001230 <growproc+0x3c>
  } else if(n < 0){
    80001216:	0204cc63          	bltz	s1,8000124e <growproc+0x5a>
  p->sz = sz;
    8000121a:	1602                	slli	a2,a2,0x20
    8000121c:	9201                	srli	a2,a2,0x20
    8000121e:	04c93423          	sd	a2,72(s2)
  return 0;
    80001222:	4501                	li	a0,0
}
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6902                	ld	s2,0(sp)
    8000122c:	6105                	addi	sp,sp,32
    8000122e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001230:	9e25                	addw	a2,a2,s1
    80001232:	1602                	slli	a2,a2,0x20
    80001234:	9201                	srli	a2,a2,0x20
    80001236:	1582                	slli	a1,a1,0x20
    80001238:	9181                	srli	a1,a1,0x20
    8000123a:	6928                	ld	a0,80(a0)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	6d2080e7          	jalr	1746(ra) # 8000090e <uvmalloc>
    80001244:	0005061b          	sext.w	a2,a0
    80001248:	fa69                	bnez	a2,8000121a <growproc+0x26>
      return -1;
    8000124a:	557d                	li	a0,-1
    8000124c:	bfe1                	j	80001224 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000124e:	9e25                	addw	a2,a2,s1
    80001250:	1602                	slli	a2,a2,0x20
    80001252:	9201                	srli	a2,a2,0x20
    80001254:	1582                	slli	a1,a1,0x20
    80001256:	9181                	srli	a1,a1,0x20
    80001258:	6928                	ld	a0,80(a0)
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	66c080e7          	jalr	1644(ra) # 800008c6 <uvmdealloc>
    80001262:	0005061b          	sext.w	a2,a0
    80001266:	bf55                	j	8000121a <growproc+0x26>

0000000080001268 <fork>:
{
    80001268:	7139                	addi	sp,sp,-64
    8000126a:	fc06                	sd	ra,56(sp)
    8000126c:	f822                	sd	s0,48(sp)
    8000126e:	f426                	sd	s1,40(sp)
    80001270:	f04a                	sd	s2,32(sp)
    80001272:	ec4e                	sd	s3,24(sp)
    80001274:	e852                	sd	s4,16(sp)
    80001276:	e456                	sd	s5,8(sp)
    80001278:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	c20080e7          	jalr	-992(ra) # 80000e9a <myproc>
    80001282:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001284:	00000097          	auipc	ra,0x0
    80001288:	e20080e7          	jalr	-480(ra) # 800010a4 <allocproc>
    8000128c:	10050c63          	beqz	a0,800013a4 <fork+0x13c>
    80001290:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001292:	048ab603          	ld	a2,72(s5)
    80001296:	692c                	ld	a1,80(a0)
    80001298:	050ab503          	ld	a0,80(s5)
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	7be080e7          	jalr	1982(ra) # 80000a5a <uvmcopy>
    800012a4:	04054863          	bltz	a0,800012f4 <fork+0x8c>
  np->sz = p->sz;
    800012a8:	048ab783          	ld	a5,72(s5)
    800012ac:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012b0:	058ab683          	ld	a3,88(s5)
    800012b4:	87b6                	mv	a5,a3
    800012b6:	058a3703          	ld	a4,88(s4)
    800012ba:	12068693          	addi	a3,a3,288
    800012be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c2:	6788                	ld	a0,8(a5)
    800012c4:	6b8c                	ld	a1,16(a5)
    800012c6:	6f90                	ld	a2,24(a5)
    800012c8:	01073023          	sd	a6,0(a4)
    800012cc:	e708                	sd	a0,8(a4)
    800012ce:	eb0c                	sd	a1,16(a4)
    800012d0:	ef10                	sd	a2,24(a4)
    800012d2:	02078793          	addi	a5,a5,32
    800012d6:	02070713          	addi	a4,a4,32
    800012da:	fed792e3          	bne	a5,a3,800012be <fork+0x56>
  np->trapframe->a0 = 0;
    800012de:	058a3783          	ld	a5,88(s4)
    800012e2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e6:	0d0a8493          	addi	s1,s5,208
    800012ea:	0d0a0913          	addi	s2,s4,208
    800012ee:	150a8993          	addi	s3,s5,336
    800012f2:	a00d                	j	80001314 <fork+0xac>
    freeproc(np);
    800012f4:	8552                	mv	a0,s4
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	d56080e7          	jalr	-682(ra) # 8000104c <freeproc>
    release(&np->lock);
    800012fe:	8552                	mv	a0,s4
    80001300:	00006097          	auipc	ra,0x6
    80001304:	eba080e7          	jalr	-326(ra) # 800071ba <release>
    return -1;
    80001308:	597d                	li	s2,-1
    8000130a:	a059                	j	80001390 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000130c:	04a1                	addi	s1,s1,8
    8000130e:	0921                	addi	s2,s2,8
    80001310:	01348b63          	beq	s1,s3,80001326 <fork+0xbe>
    if(p->ofile[i])
    80001314:	6088                	ld	a0,0(s1)
    80001316:	d97d                	beqz	a0,8000130c <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	61e080e7          	jalr	1566(ra) # 80003936 <filedup>
    80001320:	00a93023          	sd	a0,0(s2)
    80001324:	b7e5                	j	8000130c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001326:	150ab503          	ld	a0,336(s5)
    8000132a:	00001097          	auipc	ra,0x1
    8000132e:	782080e7          	jalr	1922(ra) # 80002aac <idup>
    80001332:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001336:	4641                	li	a2,16
    80001338:	158a8593          	addi	a1,s5,344
    8000133c:	158a0513          	addi	a0,s4,344
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	f82080e7          	jalr	-126(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001348:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000134c:	8552                	mv	a0,s4
    8000134e:	00006097          	auipc	ra,0x6
    80001352:	e6c080e7          	jalr	-404(ra) # 800071ba <release>
  acquire(&wait_lock);
    80001356:	00009497          	auipc	s1,0x9
    8000135a:	d3248493          	addi	s1,s1,-718 # 8000a088 <wait_lock>
    8000135e:	8526                	mv	a0,s1
    80001360:	00006097          	auipc	ra,0x6
    80001364:	da6080e7          	jalr	-602(ra) # 80007106 <acquire>
  np->parent = p;
    80001368:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00006097          	auipc	ra,0x6
    80001372:	e4c080e7          	jalr	-436(ra) # 800071ba <release>
  acquire(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00006097          	auipc	ra,0x6
    8000137c:	d8e080e7          	jalr	-626(ra) # 80007106 <acquire>
  np->state = RUNNABLE;
    80001380:	478d                	li	a5,3
    80001382:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001386:	8552                	mv	a0,s4
    80001388:	00006097          	auipc	ra,0x6
    8000138c:	e32080e7          	jalr	-462(ra) # 800071ba <release>
}
    80001390:	854a                	mv	a0,s2
    80001392:	70e2                	ld	ra,56(sp)
    80001394:	7442                	ld	s0,48(sp)
    80001396:	74a2                	ld	s1,40(sp)
    80001398:	7902                	ld	s2,32(sp)
    8000139a:	69e2                	ld	s3,24(sp)
    8000139c:	6a42                	ld	s4,16(sp)
    8000139e:	6aa2                	ld	s5,8(sp)
    800013a0:	6121                	addi	sp,sp,64
    800013a2:	8082                	ret
    return -1;
    800013a4:	597d                	li	s2,-1
    800013a6:	b7ed                	j	80001390 <fork+0x128>

00000000800013a8 <scheduler>:
{
    800013a8:	7139                	addi	sp,sp,-64
    800013aa:	fc06                	sd	ra,56(sp)
    800013ac:	f822                	sd	s0,48(sp)
    800013ae:	f426                	sd	s1,40(sp)
    800013b0:	f04a                	sd	s2,32(sp)
    800013b2:	ec4e                	sd	s3,24(sp)
    800013b4:	e852                	sd	s4,16(sp)
    800013b6:	e456                	sd	s5,8(sp)
    800013b8:	e05a                	sd	s6,0(sp)
    800013ba:	0080                	addi	s0,sp,64
    800013bc:	8792                	mv	a5,tp
  int id = r_tp();
    800013be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c0:	00779a93          	slli	s5,a5,0x7
    800013c4:	00009717          	auipc	a4,0x9
    800013c8:	cac70713          	addi	a4,a4,-852 # 8000a070 <pid_lock>
    800013cc:	9756                	add	a4,a4,s5
    800013ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d2:	00009717          	auipc	a4,0x9
    800013d6:	cd670713          	addi	a4,a4,-810 # 8000a0a8 <cpus+0x8>
    800013da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013dc:	498d                	li	s3,3
        p->state = RUNNING;
    800013de:	4b11                	li	s6,4
        c->proc = p;
    800013e0:	079e                	slli	a5,a5,0x7
    800013e2:	00009a17          	auipc	s4,0x9
    800013e6:	c8ea0a13          	addi	s4,s4,-882 # 8000a070 <pid_lock>
    800013ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ec:	0000f917          	auipc	s2,0xf
    800013f0:	ab490913          	addi	s2,s2,-1356 # 8000fea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fc:	10079073          	csrw	sstatus,a5
    80001400:	00009497          	auipc	s1,0x9
    80001404:	0a048493          	addi	s1,s1,160 # 8000a4a0 <proc>
    80001408:	a811                	j	8000141c <scheduler+0x74>
      release(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	00006097          	auipc	ra,0x6
    80001410:	dae080e7          	jalr	-594(ra) # 800071ba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001414:	16848493          	addi	s1,s1,360
    80001418:	fd248ee3          	beq	s1,s2,800013f4 <scheduler+0x4c>
      acquire(&p->lock);
    8000141c:	8526                	mv	a0,s1
    8000141e:	00006097          	auipc	ra,0x6
    80001422:	ce8080e7          	jalr	-792(ra) # 80007106 <acquire>
      if(p->state == RUNNABLE) {
    80001426:	4c9c                	lw	a5,24(s1)
    80001428:	ff3791e3          	bne	a5,s3,8000140a <scheduler+0x62>
        p->state = RUNNING;
    8000142c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001430:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001434:	06048593          	addi	a1,s1,96
    80001438:	8556                	mv	a0,s5
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	61e080e7          	jalr	1566(ra) # 80001a58 <swtch>
        c->proc = 0;
    80001442:	020a3823          	sd	zero,48(s4)
    80001446:	b7d1                	j	8000140a <scheduler+0x62>

0000000080001448 <sched>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	a44080e7          	jalr	-1468(ra) # 80000e9a <myproc>
    8000145e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001460:	00006097          	auipc	ra,0x6
    80001464:	c2c080e7          	jalr	-980(ra) # 8000708c <holding>
    80001468:	c93d                	beqz	a0,800014de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	00009717          	auipc	a4,0x9
    80001474:	c0070713          	addi	a4,a4,-1024 # 8000a070 <pid_lock>
    80001478:	97ba                	add	a5,a5,a4
    8000147a:	0a87a703          	lw	a4,168(a5)
    8000147e:	4785                	li	a5,1
    80001480:	06f71763          	bne	a4,a5,800014ee <sched+0xa6>
  if(p->state == RUNNING)
    80001484:	4c98                	lw	a4,24(s1)
    80001486:	4791                	li	a5,4
    80001488:	06f70b63          	beq	a4,a5,800014fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001490:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001492:	efb5                	bnez	a5,8000150e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001496:	00009917          	auipc	s2,0x9
    8000149a:	bda90913          	addi	s2,s2,-1062 # 8000a070 <pid_lock>
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	97ca                	add	a5,a5,s2
    800014a4:	0ac7a983          	lw	s3,172(a5)
    800014a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	00009597          	auipc	a1,0x9
    800014b2:	bfa58593          	addi	a1,a1,-1030 # 8000a0a8 <cpus+0x8>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	06048513          	addi	a0,s1,96
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	59c080e7          	jalr	1436(ra) # 80001a58 <swtch>
    800014c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	97ca                	add	a5,a5,s2
    800014cc:	0b37a623          	sw	s3,172(a5)
}
    800014d0:	70a2                	ld	ra,40(sp)
    800014d2:	7402                	ld	s0,32(sp)
    800014d4:	64e2                	ld	s1,24(sp)
    800014d6:	6942                	ld	s2,16(sp)
    800014d8:	69a2                	ld	s3,8(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    panic("sched p->lock");
    800014de:	00008517          	auipc	a0,0x8
    800014e2:	cca50513          	addi	a0,a0,-822 # 800091a8 <etext+0x1a8>
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	6e4080e7          	jalr	1764(ra) # 80006bca <panic>
    panic("sched locks");
    800014ee:	00008517          	auipc	a0,0x8
    800014f2:	cca50513          	addi	a0,a0,-822 # 800091b8 <etext+0x1b8>
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	6d4080e7          	jalr	1748(ra) # 80006bca <panic>
    panic("sched running");
    800014fe:	00008517          	auipc	a0,0x8
    80001502:	cca50513          	addi	a0,a0,-822 # 800091c8 <etext+0x1c8>
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	6c4080e7          	jalr	1732(ra) # 80006bca <panic>
    panic("sched interruptible");
    8000150e:	00008517          	auipc	a0,0x8
    80001512:	cca50513          	addi	a0,a0,-822 # 800091d8 <etext+0x1d8>
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	6b4080e7          	jalr	1716(ra) # 80006bca <panic>

000000008000151e <yield>:
{
    8000151e:	1101                	addi	sp,sp,-32
    80001520:	ec06                	sd	ra,24(sp)
    80001522:	e822                	sd	s0,16(sp)
    80001524:	e426                	sd	s1,8(sp)
    80001526:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	972080e7          	jalr	-1678(ra) # 80000e9a <myproc>
    80001530:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001532:	00006097          	auipc	ra,0x6
    80001536:	bd4080e7          	jalr	-1068(ra) # 80007106 <acquire>
  p->state = RUNNABLE;
    8000153a:	478d                	li	a5,3
    8000153c:	cc9c                	sw	a5,24(s1)
  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f0a080e7          	jalr	-246(ra) # 80001448 <sched>
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00006097          	auipc	ra,0x6
    8000154c:	c72080e7          	jalr	-910(ra) # 800071ba <release>
}
    80001550:	60e2                	ld	ra,24(sp)
    80001552:	6442                	ld	s0,16(sp)
    80001554:	64a2                	ld	s1,8(sp)
    80001556:	6105                	addi	sp,sp,32
    80001558:	8082                	ret

000000008000155a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	89aa                	mv	s3,a0
    8000156a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	92e080e7          	jalr	-1746(ra) # 80000e9a <myproc>
    80001574:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001576:	00006097          	auipc	ra,0x6
    8000157a:	b90080e7          	jalr	-1136(ra) # 80007106 <acquire>
  release(lk);
    8000157e:	854a                	mv	a0,s2
    80001580:	00006097          	auipc	ra,0x6
    80001584:	c3a080e7          	jalr	-966(ra) # 800071ba <release>

  // Go to sleep.
  p->chan = chan;
    80001588:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158c:	4789                	li	a5,2
    8000158e:	cc9c                	sw	a5,24(s1)

  sched();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	eb8080e7          	jalr	-328(ra) # 80001448 <sched>

  // Tidy up.
  p->chan = 0;
    80001598:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	00006097          	auipc	ra,0x6
    800015a2:	c1c080e7          	jalr	-996(ra) # 800071ba <release>
  acquire(lk);
    800015a6:	854a                	mv	a0,s2
    800015a8:	00006097          	auipc	ra,0x6
    800015ac:	b5e080e7          	jalr	-1186(ra) # 80007106 <acquire>
}
    800015b0:	70a2                	ld	ra,40(sp)
    800015b2:	7402                	ld	s0,32(sp)
    800015b4:	64e2                	ld	s1,24(sp)
    800015b6:	6942                	ld	s2,16(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	6145                	addi	sp,sp,48
    800015bc:	8082                	ret

00000000800015be <wait>:
{
    800015be:	715d                	addi	sp,sp,-80
    800015c0:	e486                	sd	ra,72(sp)
    800015c2:	e0a2                	sd	s0,64(sp)
    800015c4:	fc26                	sd	s1,56(sp)
    800015c6:	f84a                	sd	s2,48(sp)
    800015c8:	f44e                	sd	s3,40(sp)
    800015ca:	f052                	sd	s4,32(sp)
    800015cc:	ec56                	sd	s5,24(sp)
    800015ce:	e85a                	sd	s6,16(sp)
    800015d0:	e45e                	sd	s7,8(sp)
    800015d2:	e062                	sd	s8,0(sp)
    800015d4:	0880                	addi	s0,sp,80
    800015d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	8c2080e7          	jalr	-1854(ra) # 80000e9a <myproc>
    800015e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e2:	00009517          	auipc	a0,0x9
    800015e6:	aa650513          	addi	a0,a0,-1370 # 8000a088 <wait_lock>
    800015ea:	00006097          	auipc	ra,0x6
    800015ee:	b1c080e7          	jalr	-1252(ra) # 80007106 <acquire>
    havekids = 0;
    800015f2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
        havekids = 1;
    800015f6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f8:	0000f997          	auipc	s3,0xf
    800015fc:	8a898993          	addi	s3,s3,-1880 # 8000fea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	00009c17          	auipc	s8,0x9
    80001604:	a88c0c13          	addi	s8,s8,-1400 # 8000a088 <wait_lock>
    havekids = 0;
    80001608:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160a:	00009497          	auipc	s1,0x9
    8000160e:	e9648493          	addi	s1,s1,-362 # 8000a4a0 <proc>
    80001612:	a0bd                	j	80001680 <wait+0xc2>
          pid = np->pid;
    80001614:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001618:	000b0e63          	beqz	s6,80001634 <wait+0x76>
    8000161c:	4691                	li	a3,4
    8000161e:	02c48613          	addi	a2,s1,44
    80001622:	85da                	mv	a1,s6
    80001624:	05093503          	ld	a0,80(s2)
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	536080e7          	jalr	1334(ra) # 80000b5e <copyout>
    80001630:	02054563          	bltz	a0,8000165a <wait+0x9c>
          freeproc(np);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	a16080e7          	jalr	-1514(ra) # 8000104c <freeproc>
          release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00006097          	auipc	ra,0x6
    80001644:	b7a080e7          	jalr	-1158(ra) # 800071ba <release>
          release(&wait_lock);
    80001648:	00009517          	auipc	a0,0x9
    8000164c:	a4050513          	addi	a0,a0,-1472 # 8000a088 <wait_lock>
    80001650:	00006097          	auipc	ra,0x6
    80001654:	b6a080e7          	jalr	-1174(ra) # 800071ba <release>
          return pid;
    80001658:	a09d                	j	800016be <wait+0x100>
            release(&np->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00006097          	auipc	ra,0x6
    80001660:	b5e080e7          	jalr	-1186(ra) # 800071ba <release>
            release(&wait_lock);
    80001664:	00009517          	auipc	a0,0x9
    80001668:	a2450513          	addi	a0,a0,-1500 # 8000a088 <wait_lock>
    8000166c:	00006097          	auipc	ra,0x6
    80001670:	b4e080e7          	jalr	-1202(ra) # 800071ba <release>
            return -1;
    80001674:	59fd                	li	s3,-1
    80001676:	a0a1                	j	800016be <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001678:	16848493          	addi	s1,s1,360
    8000167c:	03348463          	beq	s1,s3,800016a4 <wait+0xe6>
      if(np->parent == p){
    80001680:	7c9c                	ld	a5,56(s1)
    80001682:	ff279be3          	bne	a5,s2,80001678 <wait+0xba>
        acquire(&np->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00006097          	auipc	ra,0x6
    8000168c:	a7e080e7          	jalr	-1410(ra) # 80007106 <acquire>
        if(np->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94781e3          	beq	a5,s4,80001614 <wait+0x56>
        release(&np->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00006097          	auipc	ra,0x6
    8000169c:	b22080e7          	jalr	-1246(ra) # 800071ba <release>
        havekids = 1;
    800016a0:	8756                	mv	a4,s5
    800016a2:	bfd9                	j	80001678 <wait+0xba>
    if(!havekids || p->killed){
    800016a4:	c701                	beqz	a4,800016ac <wait+0xee>
    800016a6:	02892783          	lw	a5,40(s2)
    800016aa:	c79d                	beqz	a5,800016d8 <wait+0x11a>
      release(&wait_lock);
    800016ac:	00009517          	auipc	a0,0x9
    800016b0:	9dc50513          	addi	a0,a0,-1572 # 8000a088 <wait_lock>
    800016b4:	00006097          	auipc	ra,0x6
    800016b8:	b06080e7          	jalr	-1274(ra) # 800071ba <release>
      return -1;
    800016bc:	59fd                	li	s3,-1
}
    800016be:	854e                	mv	a0,s3
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d8:	85e2                	mv	a1,s8
    800016da:	854a                	mv	a0,s2
    800016dc:	00000097          	auipc	ra,0x0
    800016e0:	e7e080e7          	jalr	-386(ra) # 8000155a <sleep>
    havekids = 0;
    800016e4:	b715                	j	80001608 <wait+0x4a>

00000000800016e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e6:	7139                	addi	sp,sp,-64
    800016e8:	fc06                	sd	ra,56(sp)
    800016ea:	f822                	sd	s0,48(sp)
    800016ec:	f426                	sd	s1,40(sp)
    800016ee:	f04a                	sd	s2,32(sp)
    800016f0:	ec4e                	sd	s3,24(sp)
    800016f2:	e852                	sd	s4,16(sp)
    800016f4:	e456                	sd	s5,8(sp)
    800016f6:	0080                	addi	s0,sp,64
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fa:	00009497          	auipc	s1,0x9
    800016fe:	da648493          	addi	s1,s1,-602 # 8000a4a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001702:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001704:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001706:	0000e917          	auipc	s2,0xe
    8000170a:	79a90913          	addi	s2,s2,1946 # 8000fea0 <tickslock>
    8000170e:	a811                	j	80001722 <wakeup+0x3c>
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00006097          	auipc	ra,0x6
    80001716:	aa8080e7          	jalr	-1368(ra) # 800071ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	16848493          	addi	s1,s1,360
    8000171e:	03248663          	beq	s1,s2,8000174a <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	778080e7          	jalr	1912(ra) # 80000e9a <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x34>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00006097          	auipc	ra,0x6
    80001734:	9d6080e7          	jalr	-1578(ra) # 80007106 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2a>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001744:	0154ac23          	sw	s5,24(s1)
    80001748:	b7e1                	j	80001710 <wakeup+0x2a>
    }
  }
}
    8000174a:	70e2                	ld	ra,56(sp)
    8000174c:	7442                	ld	s0,48(sp)
    8000174e:	74a2                	ld	s1,40(sp)
    80001750:	7902                	ld	s2,32(sp)
    80001752:	69e2                	ld	s3,24(sp)
    80001754:	6a42                	ld	s4,16(sp)
    80001756:	6aa2                	ld	s5,8(sp)
    80001758:	6121                	addi	sp,sp,64
    8000175a:	8082                	ret

000000008000175c <reparent>:
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	e052                	sd	s4,0(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176e:	00009497          	auipc	s1,0x9
    80001772:	d3248493          	addi	s1,s1,-718 # 8000a4a0 <proc>
      pp->parent = initproc;
    80001776:	00009a17          	auipc	s4,0x9
    8000177a:	89aa0a13          	addi	s4,s4,-1894 # 8000a010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177e:	0000e997          	auipc	s3,0xe
    80001782:	72298993          	addi	s3,s3,1826 # 8000fea0 <tickslock>
    80001786:	a029                	j	80001790 <reparent+0x34>
    80001788:	16848493          	addi	s1,s1,360
    8000178c:	01348d63          	beq	s1,s3,800017a6 <reparent+0x4a>
    if(pp->parent == p){
    80001790:	7c9c                	ld	a5,56(s1)
    80001792:	ff279be3          	bne	a5,s2,80001788 <reparent+0x2c>
      pp->parent = initproc;
    80001796:	000a3503          	ld	a0,0(s4)
    8000179a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	f4a080e7          	jalr	-182(ra) # 800016e6 <wakeup>
    800017a4:	b7d5                	j	80001788 <reparent+0x2c>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6a02                	ld	s4,0(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret

00000000800017b6 <exit>:
{
    800017b6:	7179                	addi	sp,sp,-48
    800017b8:	f406                	sd	ra,40(sp)
    800017ba:	f022                	sd	s0,32(sp)
    800017bc:	ec26                	sd	s1,24(sp)
    800017be:	e84a                	sd	s2,16(sp)
    800017c0:	e44e                	sd	s3,8(sp)
    800017c2:	e052                	sd	s4,0(sp)
    800017c4:	1800                	addi	s0,sp,48
    800017c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	6d2080e7          	jalr	1746(ra) # 80000e9a <myproc>
    800017d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d2:	00009797          	auipc	a5,0x9
    800017d6:	83e7b783          	ld	a5,-1986(a5) # 8000a010 <initproc>
    800017da:	0d050493          	addi	s1,a0,208
    800017de:	15050913          	addi	s2,a0,336
    800017e2:	02a79363          	bne	a5,a0,80001808 <exit+0x52>
    panic("init exiting");
    800017e6:	00008517          	auipc	a0,0x8
    800017ea:	a0a50513          	addi	a0,a0,-1526 # 800091f0 <etext+0x1f0>
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	3dc080e7          	jalr	988(ra) # 80006bca <panic>
      fileclose(f);
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	192080e7          	jalr	402(ra) # 80003988 <fileclose>
      p->ofile[fd] = 0;
    800017fe:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001802:	04a1                	addi	s1,s1,8
    80001804:	01248563          	beq	s1,s2,8000180e <exit+0x58>
    if(p->ofile[fd]){
    80001808:	6088                	ld	a0,0(s1)
    8000180a:	f575                	bnez	a0,800017f6 <exit+0x40>
    8000180c:	bfdd                	j	80001802 <exit+0x4c>
  begin_op();
    8000180e:	00002097          	auipc	ra,0x2
    80001812:	cae080e7          	jalr	-850(ra) # 800034bc <begin_op>
  iput(p->cwd);
    80001816:	1509b503          	ld	a0,336(s3)
    8000181a:	00001097          	auipc	ra,0x1
    8000181e:	48a080e7          	jalr	1162(ra) # 80002ca4 <iput>
  end_op();
    80001822:	00002097          	auipc	ra,0x2
    80001826:	d1a080e7          	jalr	-742(ra) # 8000353c <end_op>
  p->cwd = 0;
    8000182a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182e:	00009497          	auipc	s1,0x9
    80001832:	85a48493          	addi	s1,s1,-1958 # 8000a088 <wait_lock>
    80001836:	8526                	mv	a0,s1
    80001838:	00006097          	auipc	ra,0x6
    8000183c:	8ce080e7          	jalr	-1842(ra) # 80007106 <acquire>
  reparent(p);
    80001840:	854e                	mv	a0,s3
    80001842:	00000097          	auipc	ra,0x0
    80001846:	f1a080e7          	jalr	-230(ra) # 8000175c <reparent>
  wakeup(p->parent);
    8000184a:	0389b503          	ld	a0,56(s3)
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	e98080e7          	jalr	-360(ra) # 800016e6 <wakeup>
  acquire(&p->lock);
    80001856:	854e                	mv	a0,s3
    80001858:	00006097          	auipc	ra,0x6
    8000185c:	8ae080e7          	jalr	-1874(ra) # 80007106 <acquire>
  p->xstate = status;
    80001860:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001864:	4795                	li	a5,5
    80001866:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00006097          	auipc	ra,0x6
    80001870:	94e080e7          	jalr	-1714(ra) # 800071ba <release>
  sched();
    80001874:	00000097          	auipc	ra,0x0
    80001878:	bd4080e7          	jalr	-1068(ra) # 80001448 <sched>
  panic("zombie exit");
    8000187c:	00008517          	auipc	a0,0x8
    80001880:	98450513          	addi	a0,a0,-1660 # 80009200 <etext+0x200>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	346080e7          	jalr	838(ra) # 80006bca <panic>

000000008000188c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188c:	7179                	addi	sp,sp,-48
    8000188e:	f406                	sd	ra,40(sp)
    80001890:	f022                	sd	s0,32(sp)
    80001892:	ec26                	sd	s1,24(sp)
    80001894:	e84a                	sd	s2,16(sp)
    80001896:	e44e                	sd	s3,8(sp)
    80001898:	1800                	addi	s0,sp,48
    8000189a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189c:	00009497          	auipc	s1,0x9
    800018a0:	c0448493          	addi	s1,s1,-1020 # 8000a4a0 <proc>
    800018a4:	0000e997          	auipc	s3,0xe
    800018a8:	5fc98993          	addi	s3,s3,1532 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00006097          	auipc	ra,0x6
    800018b2:	858080e7          	jalr	-1960(ra) # 80007106 <acquire>
    if(p->pid == pid){
    800018b6:	589c                	lw	a5,48(s1)
    800018b8:	01278d63          	beq	a5,s2,800018d2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018bc:	8526                	mv	a0,s1
    800018be:	00006097          	auipc	ra,0x6
    800018c2:	8fc080e7          	jalr	-1796(ra) # 800071ba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c6:	16848493          	addi	s1,s1,360
    800018ca:	ff3491e3          	bne	s1,s3,800018ac <kill+0x20>
  }
  return -1;
    800018ce:	557d                	li	a0,-1
    800018d0:	a829                	j	800018ea <kill+0x5e>
      p->killed = 1;
    800018d2:	4785                	li	a5,1
    800018d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d6:	4c98                	lw	a4,24(s1)
    800018d8:	4789                	li	a5,2
    800018da:	00f70f63          	beq	a4,a5,800018f8 <kill+0x6c>
      release(&p->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00006097          	auipc	ra,0x6
    800018e4:	8da080e7          	jalr	-1830(ra) # 800071ba <release>
      return 0;
    800018e8:	4501                	li	a0,0
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret
        p->state = RUNNABLE;
    800018f8:	478d                	li	a5,3
    800018fa:	cc9c                	sw	a5,24(s1)
    800018fc:	b7cd                	j	800018de <kill+0x52>

00000000800018fe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	84aa                	mv	s1,a0
    80001910:	892e                	mv	s2,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	584080e7          	jalr	1412(ra) # 80000e9a <myproc>
  if(user_dst){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	236080e7          	jalr	566(ra) # 80000b5e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove((char *)dst, src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	88c080e7          	jalr	-1908(ra) # 800001d4 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyout+0x32>

0000000080001954 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001954:	7179                	addi	sp,sp,-48
    80001956:	f406                	sd	ra,40(sp)
    80001958:	f022                	sd	s0,32(sp)
    8000195a:	ec26                	sd	s1,24(sp)
    8000195c:	e84a                	sd	s2,16(sp)
    8000195e:	e44e                	sd	s3,8(sp)
    80001960:	e052                	sd	s4,0(sp)
    80001962:	1800                	addi	s0,sp,48
    80001964:	892a                	mv	s2,a0
    80001966:	84ae                	mv	s1,a1
    80001968:	89b2                	mv	s3,a2
    8000196a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	52e080e7          	jalr	1326(ra) # 80000e9a <myproc>
  if(user_src){
    80001974:	c08d                	beqz	s1,80001996 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001976:	86d2                	mv	a3,s4
    80001978:	864e                	mv	a2,s3
    8000197a:	85ca                	mv	a1,s2
    8000197c:	6928                	ld	a0,80(a0)
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	26c080e7          	jalr	620(ra) # 80000bea <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001986:	70a2                	ld	ra,40(sp)
    80001988:	7402                	ld	s0,32(sp)
    8000198a:	64e2                	ld	s1,24(sp)
    8000198c:	6942                	ld	s2,16(sp)
    8000198e:	69a2                	ld	s3,8(sp)
    80001990:	6a02                	ld	s4,0(sp)
    80001992:	6145                	addi	sp,sp,48
    80001994:	8082                	ret
    memmove(dst, (char*)src, len);
    80001996:	000a061b          	sext.w	a2,s4
    8000199a:	85ce                	mv	a1,s3
    8000199c:	854a                	mv	a0,s2
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	836080e7          	jalr	-1994(ra) # 800001d4 <memmove>
    return 0;
    800019a6:	8526                	mv	a0,s1
    800019a8:	bff9                	j	80001986 <either_copyin+0x32>

00000000800019aa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019aa:	715d                	addi	sp,sp,-80
    800019ac:	e486                	sd	ra,72(sp)
    800019ae:	e0a2                	sd	s0,64(sp)
    800019b0:	fc26                	sd	s1,56(sp)
    800019b2:	f84a                	sd	s2,48(sp)
    800019b4:	f44e                	sd	s3,40(sp)
    800019b6:	f052                	sd	s4,32(sp)
    800019b8:	ec56                	sd	s5,24(sp)
    800019ba:	e85a                	sd	s6,16(sp)
    800019bc:	e45e                	sd	s7,8(sp)
    800019be:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c0:	00007517          	auipc	a0,0x7
    800019c4:	68850513          	addi	a0,a0,1672 # 80009048 <etext+0x48>
    800019c8:	00005097          	auipc	ra,0x5
    800019cc:	24c080e7          	jalr	588(ra) # 80006c14 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d0:	00009497          	auipc	s1,0x9
    800019d4:	c2848493          	addi	s1,s1,-984 # 8000a5f8 <proc+0x158>
    800019d8:	0000e917          	auipc	s2,0xe
    800019dc:	62090913          	addi	s2,s2,1568 # 8000fff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e2:	00008997          	auipc	s3,0x8
    800019e6:	82e98993          	addi	s3,s3,-2002 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    800019ea:	00008a97          	auipc	s5,0x8
    800019ee:	82ea8a93          	addi	s5,s5,-2002 # 80009218 <etext+0x218>
    printf("\n");
    800019f2:	00007a17          	auipc	s4,0x7
    800019f6:	656a0a13          	addi	s4,s4,1622 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fa:	00008b97          	auipc	s7,0x8
    800019fe:	856b8b93          	addi	s7,s7,-1962 # 80009250 <states.0>
    80001a02:	a00d                	j	80001a24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a04:	ed86a583          	lw	a1,-296(a3)
    80001a08:	8556                	mv	a0,s5
    80001a0a:	00005097          	auipc	ra,0x5
    80001a0e:	20a080e7          	jalr	522(ra) # 80006c14 <printf>
    printf("\n");
    80001a12:	8552                	mv	a0,s4
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	200080e7          	jalr	512(ra) # 80006c14 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1c:	16848493          	addi	s1,s1,360
    80001a20:	03248163          	beq	s1,s2,80001a42 <procdump+0x98>
    if(p->state == UNUSED)
    80001a24:	86a6                	mv	a3,s1
    80001a26:	ec04a783          	lw	a5,-320(s1)
    80001a2a:	dbed                	beqz	a5,80001a1c <procdump+0x72>
      state = "???";
    80001a2c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2e:	fcfb6be3          	bltu	s6,a5,80001a04 <procdump+0x5a>
    80001a32:	1782                	slli	a5,a5,0x20
    80001a34:	9381                	srli	a5,a5,0x20
    80001a36:	078e                	slli	a5,a5,0x3
    80001a38:	97de                	add	a5,a5,s7
    80001a3a:	6390                	ld	a2,0(a5)
    80001a3c:	f661                	bnez	a2,80001a04 <procdump+0x5a>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    80001a40:	b7d1                	j	80001a04 <procdump+0x5a>
  }
}
    80001a42:	60a6                	ld	ra,72(sp)
    80001a44:	6406                	ld	s0,64(sp)
    80001a46:	74e2                	ld	s1,56(sp)
    80001a48:	7942                	ld	s2,48(sp)
    80001a4a:	79a2                	ld	s3,40(sp)
    80001a4c:	7a02                	ld	s4,32(sp)
    80001a4e:	6ae2                	ld	s5,24(sp)
    80001a50:	6b42                	ld	s6,16(sp)
    80001a52:	6ba2                	ld	s7,8(sp)
    80001a54:	6161                	addi	sp,sp,80
    80001a56:	8082                	ret

0000000080001a58 <swtch>:
    80001a58:	00153023          	sd	ra,0(a0)
    80001a5c:	00253423          	sd	sp,8(a0)
    80001a60:	e900                	sd	s0,16(a0)
    80001a62:	ed04                	sd	s1,24(a0)
    80001a64:	03253023          	sd	s2,32(a0)
    80001a68:	03353423          	sd	s3,40(a0)
    80001a6c:	03453823          	sd	s4,48(a0)
    80001a70:	03553c23          	sd	s5,56(a0)
    80001a74:	05653023          	sd	s6,64(a0)
    80001a78:	05753423          	sd	s7,72(a0)
    80001a7c:	05853823          	sd	s8,80(a0)
    80001a80:	05953c23          	sd	s9,88(a0)
    80001a84:	07a53023          	sd	s10,96(a0)
    80001a88:	07b53423          	sd	s11,104(a0)
    80001a8c:	0005b083          	ld	ra,0(a1)
    80001a90:	0085b103          	ld	sp,8(a1)
    80001a94:	6980                	ld	s0,16(a1)
    80001a96:	6d84                	ld	s1,24(a1)
    80001a98:	0205b903          	ld	s2,32(a1)
    80001a9c:	0285b983          	ld	s3,40(a1)
    80001aa0:	0305ba03          	ld	s4,48(a1)
    80001aa4:	0385ba83          	ld	s5,56(a1)
    80001aa8:	0405bb03          	ld	s6,64(a1)
    80001aac:	0485bb83          	ld	s7,72(a1)
    80001ab0:	0505bc03          	ld	s8,80(a1)
    80001ab4:	0585bc83          	ld	s9,88(a1)
    80001ab8:	0605bd03          	ld	s10,96(a1)
    80001abc:	0685bd83          	ld	s11,104(a1)
    80001ac0:	8082                	ret

0000000080001ac2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aca:	00007597          	auipc	a1,0x7
    80001ace:	7b658593          	addi	a1,a1,1974 # 80009280 <states.0+0x30>
    80001ad2:	0000e517          	auipc	a0,0xe
    80001ad6:	3ce50513          	addi	a0,a0,974 # 8000fea0 <tickslock>
    80001ada:	00005097          	auipc	ra,0x5
    80001ade:	59c080e7          	jalr	1436(ra) # 80007076 <initlock>
}
    80001ae2:	60a2                	ld	ra,8(sp)
    80001ae4:	6402                	ld	s0,0(sp)
    80001ae6:	0141                	addi	sp,sp,16
    80001ae8:	8082                	ret

0000000080001aea <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aea:	1141                	addi	sp,sp,-16
    80001aec:	e422                	sd	s0,8(sp)
    80001aee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	00003797          	auipc	a5,0x3
    80001af4:	58078793          	addi	a5,a5,1408 # 80005070 <kernelvec>
    80001af8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afc:	6422                	ld	s0,8(sp)
    80001afe:	0141                	addi	sp,sp,16
    80001b00:	8082                	ret

0000000080001b02 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b02:	1141                	addi	sp,sp,-16
    80001b04:	e406                	sd	ra,8(sp)
    80001b06:	e022                	sd	s0,0(sp)
    80001b08:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	390080e7          	jalr	912(ra) # 80000e9a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b18:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b1c:	00006617          	auipc	a2,0x6
    80001b20:	4e460613          	addi	a2,a2,1252 # 80008000 <_trampoline>
    80001b24:	00006697          	auipc	a3,0x6
    80001b28:	4dc68693          	addi	a3,a3,1244 # 80008000 <_trampoline>
    80001b2c:	8e91                	sub	a3,a3,a2
    80001b2e:	040007b7          	lui	a5,0x4000
    80001b32:	17fd                	addi	a5,a5,-1
    80001b34:	07b2                	slli	a5,a5,0xc
    80001b36:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b38:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b3e:	180026f3          	csrr	a3,satp
    80001b42:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b44:	6d38                	ld	a4,88(a0)
    80001b46:	6134                	ld	a3,64(a0)
    80001b48:	6585                	lui	a1,0x1
    80001b4a:	96ae                	add	a3,a3,a1
    80001b4c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b4e:	6d38                	ld	a4,88(a0)
    80001b50:	00000697          	auipc	a3,0x0
    80001b54:	14a68693          	addi	a3,a3,330 # 80001c9a <usertrap>
    80001b58:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5c:	8692                	mv	a3,tp
    80001b5e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b60:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b64:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b68:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b70:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b72:	6f18                	ld	a4,24(a4)
    80001b74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b78:	692c                	ld	a1,80(a0)
    80001b7a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b7c:	00006717          	auipc	a4,0x6
    80001b80:	51470713          	addi	a4,a4,1300 # 80008090 <userret>
    80001b84:	8f11                	sub	a4,a4,a2
    80001b86:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b88:	577d                	li	a4,-1
    80001b8a:	177e                	slli	a4,a4,0x3f
    80001b8c:	8dd9                	or	a1,a1,a4
    80001b8e:	02000537          	lui	a0,0x2000
    80001b92:	157d                	addi	a0,a0,-1
    80001b94:	0536                	slli	a0,a0,0xd
    80001b96:	9782                	jalr	a5
}
    80001b98:	60a2                	ld	ra,8(sp)
    80001b9a:	6402                	ld	s0,0(sp)
    80001b9c:	0141                	addi	sp,sp,16
    80001b9e:	8082                	ret

0000000080001ba0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001baa:	0000e497          	auipc	s1,0xe
    80001bae:	2f648493          	addi	s1,s1,758 # 8000fea0 <tickslock>
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00005097          	auipc	ra,0x5
    80001bb8:	552080e7          	jalr	1362(ra) # 80007106 <acquire>
  ticks++;
    80001bbc:	00008517          	auipc	a0,0x8
    80001bc0:	45c50513          	addi	a0,a0,1116 # 8000a018 <ticks>
    80001bc4:	411c                	lw	a5,0(a0)
    80001bc6:	2785                	addiw	a5,a5,1
    80001bc8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	b1c080e7          	jalr	-1252(ra) # 800016e6 <wakeup>
  release(&tickslock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	00005097          	auipc	ra,0x5
    80001bd8:	5e6080e7          	jalr	1510(ra) # 800071ba <release>
}
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6105                	addi	sp,sp,32
    80001be4:	8082                	ret

0000000080001be6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be6:	1101                	addi	sp,sp,-32
    80001be8:	ec06                	sd	ra,24(sp)
    80001bea:	e822                	sd	s0,16(sp)
    80001bec:	e426                	sd	s1,8(sp)
    80001bee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf4:	00074d63          	bltz	a4,80001c0e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf8:	57fd                	li	a5,-1
    80001bfa:	17fe                	slli	a5,a5,0x3f
    80001bfc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c00:	06f70c63          	beq	a4,a5,80001c78 <devintr+0x92>
  }
}
    80001c04:	60e2                	ld	ra,24(sp)
    80001c06:	6442                	ld	s0,16(sp)
    80001c08:	64a2                	ld	s1,8(sp)
    80001c0a:	6105                	addi	sp,sp,32
    80001c0c:	8082                	ret
     (scause & 0xff) == 9){
    80001c0e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c12:	46a5                	li	a3,9
    80001c14:	fed792e3          	bne	a5,a3,80001bf8 <devintr+0x12>
    int irq = plic_claim();
    80001c18:	00003097          	auipc	ra,0x3
    80001c1c:	57a080e7          	jalr	1402(ra) # 80005192 <plic_claim>
    80001c20:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c22:	47a9                	li	a5,10
    80001c24:	02f50563          	beq	a0,a5,80001c4e <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001c28:	4785                	li	a5,1
    80001c2a:	02f50d63          	beq	a0,a5,80001c64 <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001c2e:	02100793          	li	a5,33
    80001c32:	02f50e63          	beq	a0,a5,80001c6e <devintr+0x88>
    return 1;
    80001c36:	4505                	li	a0,1
    else if(irq){
    80001c38:	d4f1                	beqz	s1,80001c04 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3a:	85a6                	mv	a1,s1
    80001c3c:	00007517          	auipc	a0,0x7
    80001c40:	64c50513          	addi	a0,a0,1612 # 80009288 <states.0+0x38>
    80001c44:	00005097          	auipc	ra,0x5
    80001c48:	fd0080e7          	jalr	-48(ra) # 80006c14 <printf>
    80001c4c:	a029                	j	80001c56 <devintr+0x70>
      uartintr();
    80001c4e:	00005097          	auipc	ra,0x5
    80001c52:	3d8080e7          	jalr	984(ra) # 80007026 <uartintr>
      plic_complete(irq);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00003097          	auipc	ra,0x3
    80001c5c:	55e080e7          	jalr	1374(ra) # 800051b6 <plic_complete>
    return 1;
    80001c60:	4505                	li	a0,1
    80001c62:	b74d                	j	80001c04 <devintr+0x1e>
      virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	9e4080e7          	jalr	-1564(ra) # 80005648 <virtio_disk_intr>
    80001c6c:	b7ed                	j	80001c56 <devintr+0x70>
      e1000_intr();
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	d1e080e7          	jalr	-738(ra) # 8000598c <e1000_intr>
    80001c76:	b7c5                	j	80001c56 <devintr+0x70>
    if(cpuid() == 0){
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	1f6080e7          	jalr	502(ra) # 80000e6e <cpuid>
    80001c80:	c901                	beqz	a0,80001c90 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c82:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c86:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c88:	14479073          	csrw	sip,a5
    return 2;
    80001c8c:	4509                	li	a0,2
    80001c8e:	bf9d                	j	80001c04 <devintr+0x1e>
      clockintr();
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	f10080e7          	jalr	-240(ra) # 80001ba0 <clockintr>
    80001c98:	b7ed                	j	80001c82 <devintr+0x9c>

0000000080001c9a <usertrap>:
{
    80001c9a:	1101                	addi	sp,sp,-32
    80001c9c:	ec06                	sd	ra,24(sp)
    80001c9e:	e822                	sd	s0,16(sp)
    80001ca0:	e426                	sd	s1,8(sp)
    80001ca2:	e04a                	sd	s2,0(sp)
    80001ca4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001caa:	1007f793          	andi	a5,a5,256
    80001cae:	e3b9                	bnez	a5,80001cf4 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	00003797          	auipc	a5,0x3
    80001cb4:	3c078793          	addi	a5,a5,960 # 80005070 <kernelvec>
    80001cb8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	1de080e7          	jalr	478(ra) # 80000e9a <myproc>
    80001cc4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cc6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc8:	14102773          	csrr	a4,sepc
    80001ccc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cce:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cd2:	47a1                	li	a5,8
    80001cd4:	02f70863          	beq	a4,a5,80001d04 <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f0e080e7          	jalr	-242(ra) # 80001be6 <devintr>
    80001ce0:	892a                	mv	s2,a0
    80001ce2:	c551                	beqz	a0,80001d6e <usertrap+0xd4>
  if(lockfree_read4(&p->killed))
    80001ce4:	02848513          	addi	a0,s1,40
    80001ce8:	00005097          	auipc	ra,0x5
    80001cec:	530080e7          	jalr	1328(ra) # 80007218 <lockfree_read4>
    80001cf0:	cd21                	beqz	a0,80001d48 <usertrap+0xae>
    80001cf2:	a0b1                	j	80001d3e <usertrap+0xa4>
    panic("usertrap: not from user mode");
    80001cf4:	00007517          	auipc	a0,0x7
    80001cf8:	5b450513          	addi	a0,a0,1460 # 800092a8 <states.0+0x58>
    80001cfc:	00005097          	auipc	ra,0x5
    80001d00:	ece080e7          	jalr	-306(ra) # 80006bca <panic>
    if(lockfree_read4(&p->killed))
    80001d04:	02850513          	addi	a0,a0,40
    80001d08:	00005097          	auipc	ra,0x5
    80001d0c:	510080e7          	jalr	1296(ra) # 80007218 <lockfree_read4>
    80001d10:	e929                	bnez	a0,80001d62 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001d12:	6cb8                	ld	a4,88(s1)
    80001d14:	6f1c                	ld	a5,24(a4)
    80001d16:	0791                	addi	a5,a5,4
    80001d18:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d1e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d22:	10079073          	csrw	sstatus,a5
    syscall();
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	2c8080e7          	jalr	712(ra) # 80001fee <syscall>
  if(lockfree_read4(&p->killed))
    80001d2e:	02848513          	addi	a0,s1,40
    80001d32:	00005097          	auipc	ra,0x5
    80001d36:	4e6080e7          	jalr	1254(ra) # 80007218 <lockfree_read4>
    80001d3a:	c911                	beqz	a0,80001d4e <usertrap+0xb4>
    80001d3c:	4901                	li	s2,0
    exit(-1);
    80001d3e:	557d                	li	a0,-1
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	a76080e7          	jalr	-1418(ra) # 800017b6 <exit>
  if(which_dev == 2)
    80001d48:	4789                	li	a5,2
    80001d4a:	04f90c63          	beq	s2,a5,80001da2 <usertrap+0x108>
  usertrapret();
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	db4080e7          	jalr	-588(ra) # 80001b02 <usertrapret>
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	64a2                	ld	s1,8(sp)
    80001d5c:	6902                	ld	s2,0(sp)
    80001d5e:	6105                	addi	sp,sp,32
    80001d60:	8082                	ret
      exit(-1);
    80001d62:	557d                	li	a0,-1
    80001d64:	00000097          	auipc	ra,0x0
    80001d68:	a52080e7          	jalr	-1454(ra) # 800017b6 <exit>
    80001d6c:	b75d                	j	80001d12 <usertrap+0x78>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d6e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d72:	5890                	lw	a2,48(s1)
    80001d74:	00007517          	auipc	a0,0x7
    80001d78:	55450513          	addi	a0,a0,1364 # 800092c8 <states.0+0x78>
    80001d7c:	00005097          	auipc	ra,0x5
    80001d80:	e98080e7          	jalr	-360(ra) # 80006c14 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d88:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d8c:	00007517          	auipc	a0,0x7
    80001d90:	56c50513          	addi	a0,a0,1388 # 800092f8 <states.0+0xa8>
    80001d94:	00005097          	auipc	ra,0x5
    80001d98:	e80080e7          	jalr	-384(ra) # 80006c14 <printf>
    p->killed = 1;
    80001d9c:	4785                	li	a5,1
    80001d9e:	d49c                	sw	a5,40(s1)
    80001da0:	b779                	j	80001d2e <usertrap+0x94>
    yield();
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	77c080e7          	jalr	1916(ra) # 8000151e <yield>
    80001daa:	b755                	j	80001d4e <usertrap+0xb4>

0000000080001dac <kerneltrap>:
{
    80001dac:	7179                	addi	sp,sp,-48
    80001dae:	f406                	sd	ra,40(sp)
    80001db0:	f022                	sd	s0,32(sp)
    80001db2:	ec26                	sd	s1,24(sp)
    80001db4:	e84a                	sd	s2,16(sp)
    80001db6:	e44e                	sd	s3,8(sp)
    80001db8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dc6:	1004f793          	andi	a5,s1,256
    80001dca:	cb85                	beqz	a5,80001dfa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dd2:	ef85                	bnez	a5,80001e0a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	e12080e7          	jalr	-494(ra) # 80001be6 <devintr>
    80001ddc:	cd1d                	beqz	a0,80001e1a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dde:	4789                	li	a5,2
    80001de0:	06f50a63          	beq	a0,a5,80001e54 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001de4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de8:	10049073          	csrw	sstatus,s1
}
    80001dec:	70a2                	ld	ra,40(sp)
    80001dee:	7402                	ld	s0,32(sp)
    80001df0:	64e2                	ld	s1,24(sp)
    80001df2:	6942                	ld	s2,16(sp)
    80001df4:	69a2                	ld	s3,8(sp)
    80001df6:	6145                	addi	sp,sp,48
    80001df8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfa:	00007517          	auipc	a0,0x7
    80001dfe:	51e50513          	addi	a0,a0,1310 # 80009318 <states.0+0xc8>
    80001e02:	00005097          	auipc	ra,0x5
    80001e06:	dc8080e7          	jalr	-568(ra) # 80006bca <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0a:	00007517          	auipc	a0,0x7
    80001e0e:	53650513          	addi	a0,a0,1334 # 80009340 <states.0+0xf0>
    80001e12:	00005097          	auipc	ra,0x5
    80001e16:	db8080e7          	jalr	-584(ra) # 80006bca <panic>
    printf("scause %p\n", scause);
    80001e1a:	85ce                	mv	a1,s3
    80001e1c:	00007517          	auipc	a0,0x7
    80001e20:	54450513          	addi	a0,a0,1348 # 80009360 <states.0+0x110>
    80001e24:	00005097          	auipc	ra,0x5
    80001e28:	df0080e7          	jalr	-528(ra) # 80006c14 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e30:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e34:	00007517          	auipc	a0,0x7
    80001e38:	53c50513          	addi	a0,a0,1340 # 80009370 <states.0+0x120>
    80001e3c:	00005097          	auipc	ra,0x5
    80001e40:	dd8080e7          	jalr	-552(ra) # 80006c14 <printf>
    panic("kerneltrap");
    80001e44:	00007517          	auipc	a0,0x7
    80001e48:	54450513          	addi	a0,a0,1348 # 80009388 <states.0+0x138>
    80001e4c:	00005097          	auipc	ra,0x5
    80001e50:	d7e080e7          	jalr	-642(ra) # 80006bca <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	046080e7          	jalr	70(ra) # 80000e9a <myproc>
    80001e5c:	d541                	beqz	a0,80001de4 <kerneltrap+0x38>
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	03c080e7          	jalr	60(ra) # 80000e9a <myproc>
    80001e66:	4d18                	lw	a4,24(a0)
    80001e68:	4791                	li	a5,4
    80001e6a:	f6f71de3          	bne	a4,a5,80001de4 <kerneltrap+0x38>
    yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	6b0080e7          	jalr	1712(ra) # 8000151e <yield>
    80001e76:	b7bd                	j	80001de4 <kerneltrap+0x38>

0000000080001e78 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
    80001e82:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	016080e7          	jalr	22(ra) # 80000e9a <myproc>
  switch (n) {
    80001e8c:	4795                	li	a5,5
    80001e8e:	0497e163          	bltu	a5,s1,80001ed0 <argraw+0x58>
    80001e92:	048a                	slli	s1,s1,0x2
    80001e94:	00007717          	auipc	a4,0x7
    80001e98:	52c70713          	addi	a4,a4,1324 # 800093c0 <states.0+0x170>
    80001e9c:	94ba                	add	s1,s1,a4
    80001e9e:	409c                	lw	a5,0(s1)
    80001ea0:	97ba                	add	a5,a5,a4
    80001ea2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    return p->trapframe->a1;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	7fa8                	ld	a0,120(a5)
    80001eb6:	bfcd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a2;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	63c8                	ld	a0,128(a5)
    80001ebc:	b7f5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a3;
    80001ebe:	6d3c                	ld	a5,88(a0)
    80001ec0:	67c8                	ld	a0,136(a5)
    80001ec2:	b7dd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a4;
    80001ec4:	6d3c                	ld	a5,88(a0)
    80001ec6:	6bc8                	ld	a0,144(a5)
    80001ec8:	b7c5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a5;
    80001eca:	6d3c                	ld	a5,88(a0)
    80001ecc:	6fc8                	ld	a0,152(a5)
    80001ece:	bfe9                	j	80001ea8 <argraw+0x30>
  panic("argraw");
    80001ed0:	00007517          	auipc	a0,0x7
    80001ed4:	4c850513          	addi	a0,a0,1224 # 80009398 <states.0+0x148>
    80001ed8:	00005097          	auipc	ra,0x5
    80001edc:	cf2080e7          	jalr	-782(ra) # 80006bca <panic>

0000000080001ee0 <fetchaddr>:
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	e04a                	sd	s2,0(sp)
    80001eea:	1000                	addi	s0,sp,32
    80001eec:	84aa                	mv	s1,a0
    80001eee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	faa080e7          	jalr	-86(ra) # 80000e9a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ef8:	653c                	ld	a5,72(a0)
    80001efa:	02f4f863          	bgeu	s1,a5,80001f2a <fetchaddr+0x4a>
    80001efe:	00848713          	addi	a4,s1,8
    80001f02:	02e7e663          	bltu	a5,a4,80001f2e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f06:	46a1                	li	a3,8
    80001f08:	8626                	mv	a2,s1
    80001f0a:	85ca                	mv	a1,s2
    80001f0c:	6928                	ld	a0,80(a0)
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	cdc080e7          	jalr	-804(ra) # 80000bea <copyin>
    80001f16:	00a03533          	snez	a0,a0
    80001f1a:	40a00533          	neg	a0,a0
}
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6902                	ld	s2,0(sp)
    80001f26:	6105                	addi	sp,sp,32
    80001f28:	8082                	ret
    return -1;
    80001f2a:	557d                	li	a0,-1
    80001f2c:	bfcd                	j	80001f1e <fetchaddr+0x3e>
    80001f2e:	557d                	li	a0,-1
    80001f30:	b7fd                	j	80001f1e <fetchaddr+0x3e>

0000000080001f32 <fetchstr>:
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	e84a                	sd	s2,16(sp)
    80001f3c:	e44e                	sd	s3,8(sp)
    80001f3e:	1800                	addi	s0,sp,48
    80001f40:	892a                	mv	s2,a0
    80001f42:	84ae                	mv	s1,a1
    80001f44:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	f54080e7          	jalr	-172(ra) # 80000e9a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f4e:	86ce                	mv	a3,s3
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	6928                	ld	a0,80(a0)
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	d22080e7          	jalr	-734(ra) # 80000c78 <copyinstr>
  if(err < 0)
    80001f5e:	00054763          	bltz	a0,80001f6c <fetchstr+0x3a>
  return strlen(buf);
    80001f62:	8526                	mv	a0,s1
    80001f64:	ffffe097          	auipc	ra,0xffffe
    80001f68:	390080e7          	jalr	912(ra) # 800002f4 <strlen>
}
    80001f6c:	70a2                	ld	ra,40(sp)
    80001f6e:	7402                	ld	s0,32(sp)
    80001f70:	64e2                	ld	s1,24(sp)
    80001f72:	6942                	ld	s2,16(sp)
    80001f74:	69a2                	ld	s3,8(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret

0000000080001f7a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	ef2080e7          	jalr	-270(ra) # 80001e78 <argraw>
    80001f8e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f90:	4501                	li	a0,0
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret

0000000080001f9c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	ed0080e7          	jalr	-304(ra) # 80001e78 <argraw>
    80001fb0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fb2:	4501                	li	a0,0
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	64a2                	ld	s1,8(sp)
    80001fba:	6105                	addi	sp,sp,32
    80001fbc:	8082                	ret

0000000080001fbe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	e04a                	sd	s2,0(sp)
    80001fc8:	1000                	addi	s0,sp,32
    80001fca:	84ae                	mv	s1,a1
    80001fcc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	eaa080e7          	jalr	-342(ra) # 80001e78 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd6:	864a                	mv	a2,s2
    80001fd8:	85a6                	mv	a1,s1
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	f58080e7          	jalr	-168(ra) # 80001f32 <fetchstr>
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6902                	ld	s2,0(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <syscall>:



void
syscall(void)
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	ea0080e7          	jalr	-352(ra) # 80000e9a <myproc>
    80002002:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002004:	05853903          	ld	s2,88(a0)
    80002008:	0a893783          	ld	a5,168(s2)
    8000200c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002010:	37fd                	addiw	a5,a5,-1
    80002012:	4771                	li	a4,28
    80002014:	00f76f63          	bltu	a4,a5,80002032 <syscall+0x44>
    80002018:	00369713          	slli	a4,a3,0x3
    8000201c:	00007797          	auipc	a5,0x7
    80002020:	3bc78793          	addi	a5,a5,956 # 800093d8 <syscalls>
    80002024:	97ba                	add	a5,a5,a4
    80002026:	639c                	ld	a5,0(a5)
    80002028:	c789                	beqz	a5,80002032 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000202a:	9782                	jalr	a5
    8000202c:	06a93823          	sd	a0,112(s2)
    80002030:	a839                	j	8000204e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002032:	15848613          	addi	a2,s1,344
    80002036:	588c                	lw	a1,48(s1)
    80002038:	00007517          	auipc	a0,0x7
    8000203c:	36850513          	addi	a0,a0,872 # 800093a0 <states.0+0x150>
    80002040:	00005097          	auipc	ra,0x5
    80002044:	bd4080e7          	jalr	-1068(ra) # 80006c14 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002048:	6cbc                	ld	a5,88(s1)
    8000204a:	577d                	li	a4,-1
    8000204c:	fbb8                	sd	a4,112(a5)
  }
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6902                	ld	s2,0(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret

000000008000205a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002062:	fec40593          	addi	a1,s0,-20
    80002066:	4501                	li	a0,0
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	f12080e7          	jalr	-238(ra) # 80001f7a <argint>
    return -1;
    80002070:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002072:	00054963          	bltz	a0,80002084 <sys_exit+0x2a>
  exit(n);
    80002076:	fec42503          	lw	a0,-20(s0)
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	73c080e7          	jalr	1852(ra) # 800017b6 <exit>
  return 0;  // not reached
    80002082:	4781                	li	a5,0
}
    80002084:	853e                	mv	a0,a5
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	6105                	addi	sp,sp,32
    8000208c:	8082                	ret

000000008000208e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000208e:	1141                	addi	sp,sp,-16
    80002090:	e406                	sd	ra,8(sp)
    80002092:	e022                	sd	s0,0(sp)
    80002094:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	e04080e7          	jalr	-508(ra) # 80000e9a <myproc>
}
    8000209e:	5908                	lw	a0,48(a0)
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_fork>:

uint64
sys_fork(void)
{
    800020a8:	1141                	addi	sp,sp,-16
    800020aa:	e406                	sd	ra,8(sp)
    800020ac:	e022                	sd	s0,0(sp)
    800020ae:	0800                	addi	s0,sp,16
  return fork();
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	1b8080e7          	jalr	440(ra) # 80001268 <fork>
}
    800020b8:	60a2                	ld	ra,8(sp)
    800020ba:	6402                	ld	s0,0(sp)
    800020bc:	0141                	addi	sp,sp,16
    800020be:	8082                	ret

00000000800020c0 <sys_wait>:

uint64
sys_wait(void)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020c8:	fe840593          	addi	a1,s0,-24
    800020cc:	4501                	li	a0,0
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	ece080e7          	jalr	-306(ra) # 80001f9c <argaddr>
    800020d6:	87aa                	mv	a5,a0
    return -1;
    800020d8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020da:	0007c863          	bltz	a5,800020ea <sys_wait+0x2a>
  return wait(p);
    800020de:	fe843503          	ld	a0,-24(s0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	4dc080e7          	jalr	1244(ra) # 800015be <wait>
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020f2:	7179                	addi	sp,sp,-48
    800020f4:	f406                	sd	ra,40(sp)
    800020f6:	f022                	sd	s0,32(sp)
    800020f8:	ec26                	sd	s1,24(sp)
    800020fa:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020fc:	fdc40593          	addi	a1,s0,-36
    80002100:	4501                	li	a0,0
    80002102:	00000097          	auipc	ra,0x0
    80002106:	e78080e7          	jalr	-392(ra) # 80001f7a <argint>
    return -1;
    8000210a:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    8000210c:	00054f63          	bltz	a0,8000212a <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	d8a080e7          	jalr	-630(ra) # 80000e9a <myproc>
    80002118:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000211a:	fdc42503          	lw	a0,-36(s0)
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	0d6080e7          	jalr	214(ra) # 800011f4 <growproc>
    80002126:	00054863          	bltz	a0,80002136 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    8000212a:	8526                	mv	a0,s1
    8000212c:	70a2                	ld	ra,40(sp)
    8000212e:	7402                	ld	s0,32(sp)
    80002130:	64e2                	ld	s1,24(sp)
    80002132:	6145                	addi	sp,sp,48
    80002134:	8082                	ret
    return -1;
    80002136:	54fd                	li	s1,-1
    80002138:	bfcd                	j	8000212a <sys_sbrk+0x38>

000000008000213a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000213a:	7139                	addi	sp,sp,-64
    8000213c:	fc06                	sd	ra,56(sp)
    8000213e:	f822                	sd	s0,48(sp)
    80002140:	f426                	sd	s1,40(sp)
    80002142:	f04a                	sd	s2,32(sp)
    80002144:	ec4e                	sd	s3,24(sp)
    80002146:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002148:	fcc40593          	addi	a1,s0,-52
    8000214c:	4501                	li	a0,0
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	e2c080e7          	jalr	-468(ra) # 80001f7a <argint>
    return -1;
    80002156:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002158:	06054563          	bltz	a0,800021c2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000215c:	0000e517          	auipc	a0,0xe
    80002160:	d4450513          	addi	a0,a0,-700 # 8000fea0 <tickslock>
    80002164:	00005097          	auipc	ra,0x5
    80002168:	fa2080e7          	jalr	-94(ra) # 80007106 <acquire>
  ticks0 = ticks;
    8000216c:	00008917          	auipc	s2,0x8
    80002170:	eac92903          	lw	s2,-340(s2) # 8000a018 <ticks>
  while(ticks - ticks0 < n){
    80002174:	fcc42783          	lw	a5,-52(s0)
    80002178:	cf85                	beqz	a5,800021b0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000217a:	0000e997          	auipc	s3,0xe
    8000217e:	d2698993          	addi	s3,s3,-730 # 8000fea0 <tickslock>
    80002182:	00008497          	auipc	s1,0x8
    80002186:	e9648493          	addi	s1,s1,-362 # 8000a018 <ticks>
    if(myproc()->killed){
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	d10080e7          	jalr	-752(ra) # 80000e9a <myproc>
    80002192:	551c                	lw	a5,40(a0)
    80002194:	ef9d                	bnez	a5,800021d2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002196:	85ce                	mv	a1,s3
    80002198:	8526                	mv	a0,s1
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	3c0080e7          	jalr	960(ra) # 8000155a <sleep>
  while(ticks - ticks0 < n){
    800021a2:	409c                	lw	a5,0(s1)
    800021a4:	412787bb          	subw	a5,a5,s2
    800021a8:	fcc42703          	lw	a4,-52(s0)
    800021ac:	fce7efe3          	bltu	a5,a4,8000218a <sys_sleep+0x50>
  }
  release(&tickslock);
    800021b0:	0000e517          	auipc	a0,0xe
    800021b4:	cf050513          	addi	a0,a0,-784 # 8000fea0 <tickslock>
    800021b8:	00005097          	auipc	ra,0x5
    800021bc:	002080e7          	jalr	2(ra) # 800071ba <release>
  return 0;
    800021c0:	4781                	li	a5,0
}
    800021c2:	853e                	mv	a0,a5
    800021c4:	70e2                	ld	ra,56(sp)
    800021c6:	7442                	ld	s0,48(sp)
    800021c8:	74a2                	ld	s1,40(sp)
    800021ca:	7902                	ld	s2,32(sp)
    800021cc:	69e2                	ld	s3,24(sp)
    800021ce:	6121                	addi	sp,sp,64
    800021d0:	8082                	ret
      release(&tickslock);
    800021d2:	0000e517          	auipc	a0,0xe
    800021d6:	cce50513          	addi	a0,a0,-818 # 8000fea0 <tickslock>
    800021da:	00005097          	auipc	ra,0x5
    800021de:	fe0080e7          	jalr	-32(ra) # 800071ba <release>
      return -1;
    800021e2:	57fd                	li	a5,-1
    800021e4:	bff9                	j	800021c2 <sys_sleep+0x88>

00000000800021e6 <sys_kill>:

uint64
sys_kill(void)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021ee:	fec40593          	addi	a1,s0,-20
    800021f2:	4501                	li	a0,0
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	d86080e7          	jalr	-634(ra) # 80001f7a <argint>
    800021fc:	87aa                	mv	a5,a0
    return -1;
    800021fe:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002200:	0007c863          	bltz	a5,80002210 <sys_kill+0x2a>
  return kill(pid);
    80002204:	fec42503          	lw	a0,-20(s0)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	684080e7          	jalr	1668(ra) # 8000188c <kill>
}
    80002210:	60e2                	ld	ra,24(sp)
    80002212:	6442                	ld	s0,16(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret

0000000080002218 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	e426                	sd	s1,8(sp)
    80002220:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002222:	0000e517          	auipc	a0,0xe
    80002226:	c7e50513          	addi	a0,a0,-898 # 8000fea0 <tickslock>
    8000222a:	00005097          	auipc	ra,0x5
    8000222e:	edc080e7          	jalr	-292(ra) # 80007106 <acquire>
  xticks = ticks;
    80002232:	00008497          	auipc	s1,0x8
    80002236:	de64a483          	lw	s1,-538(s1) # 8000a018 <ticks>
  release(&tickslock);
    8000223a:	0000e517          	auipc	a0,0xe
    8000223e:	c6650513          	addi	a0,a0,-922 # 8000fea0 <tickslock>
    80002242:	00005097          	auipc	ra,0x5
    80002246:	f78080e7          	jalr	-136(ra) # 800071ba <release>
  return xticks;
}
    8000224a:	02049513          	slli	a0,s1,0x20
    8000224e:	9101                	srli	a0,a0,0x20
    80002250:	60e2                	ld	ra,24(sp)
    80002252:	6442                	ld	s0,16(sp)
    80002254:	64a2                	ld	s1,8(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000225a:	7179                	addi	sp,sp,-48
    8000225c:	f406                	sd	ra,40(sp)
    8000225e:	f022                	sd	s0,32(sp)
    80002260:	ec26                	sd	s1,24(sp)
    80002262:	e84a                	sd	s2,16(sp)
    80002264:	e44e                	sd	s3,8(sp)
    80002266:	e052                	sd	s4,0(sp)
    80002268:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000226a:	00007597          	auipc	a1,0x7
    8000226e:	25e58593          	addi	a1,a1,606 # 800094c8 <syscalls+0xf0>
    80002272:	0000e517          	auipc	a0,0xe
    80002276:	c4650513          	addi	a0,a0,-954 # 8000feb8 <bcache>
    8000227a:	00005097          	auipc	ra,0x5
    8000227e:	dfc080e7          	jalr	-516(ra) # 80007076 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002282:	00016797          	auipc	a5,0x16
    80002286:	c3678793          	addi	a5,a5,-970 # 80017eb8 <bcache+0x8000>
    8000228a:	00016717          	auipc	a4,0x16
    8000228e:	e9670713          	addi	a4,a4,-362 # 80018120 <bcache+0x8268>
    80002292:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002296:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000229a:	0000e497          	auipc	s1,0xe
    8000229e:	c3648493          	addi	s1,s1,-970 # 8000fed0 <bcache+0x18>
    b->next = bcache.head.next;
    800022a2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022a4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022a6:	00007a17          	auipc	s4,0x7
    800022aa:	22aa0a13          	addi	s4,s4,554 # 800094d0 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022ae:	2b893783          	ld	a5,696(s2)
    800022b2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022b4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022b8:	85d2                	mv	a1,s4
    800022ba:	01048513          	addi	a0,s1,16
    800022be:	00001097          	auipc	ra,0x1
    800022c2:	4bc080e7          	jalr	1212(ra) # 8000377a <initsleeplock>
    bcache.head.next->prev = b;
    800022c6:	2b893783          	ld	a5,696(s2)
    800022ca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d0:	45848493          	addi	s1,s1,1112
    800022d4:	fd349de3          	bne	s1,s3,800022ae <binit+0x54>
  }
}
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6942                	ld	s2,16(sp)
    800022e0:	69a2                	ld	s3,8(sp)
    800022e2:	6a02                	ld	s4,0(sp)
    800022e4:	6145                	addi	sp,sp,48
    800022e6:	8082                	ret

00000000800022e8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022e8:	7179                	addi	sp,sp,-48
    800022ea:	f406                	sd	ra,40(sp)
    800022ec:	f022                	sd	s0,32(sp)
    800022ee:	ec26                	sd	s1,24(sp)
    800022f0:	e84a                	sd	s2,16(sp)
    800022f2:	e44e                	sd	s3,8(sp)
    800022f4:	1800                	addi	s0,sp,48
    800022f6:	892a                	mv	s2,a0
    800022f8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022fa:	0000e517          	auipc	a0,0xe
    800022fe:	bbe50513          	addi	a0,a0,-1090 # 8000feb8 <bcache>
    80002302:	00005097          	auipc	ra,0x5
    80002306:	e04080e7          	jalr	-508(ra) # 80007106 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000230a:	00016497          	auipc	s1,0x16
    8000230e:	e664b483          	ld	s1,-410(s1) # 80018170 <bcache+0x82b8>
    80002312:	00016797          	auipc	a5,0x16
    80002316:	e0e78793          	addi	a5,a5,-498 # 80018120 <bcache+0x8268>
    8000231a:	02f48f63          	beq	s1,a5,80002358 <bread+0x70>
    8000231e:	873e                	mv	a4,a5
    80002320:	a021                	j	80002328 <bread+0x40>
    80002322:	68a4                	ld	s1,80(s1)
    80002324:	02e48a63          	beq	s1,a4,80002358 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002328:	449c                	lw	a5,8(s1)
    8000232a:	ff279ce3          	bne	a5,s2,80002322 <bread+0x3a>
    8000232e:	44dc                	lw	a5,12(s1)
    80002330:	ff3799e3          	bne	a5,s3,80002322 <bread+0x3a>
      b->refcnt++;
    80002334:	40bc                	lw	a5,64(s1)
    80002336:	2785                	addiw	a5,a5,1
    80002338:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000233a:	0000e517          	auipc	a0,0xe
    8000233e:	b7e50513          	addi	a0,a0,-1154 # 8000feb8 <bcache>
    80002342:	00005097          	auipc	ra,0x5
    80002346:	e78080e7          	jalr	-392(ra) # 800071ba <release>
      acquiresleep(&b->lock);
    8000234a:	01048513          	addi	a0,s1,16
    8000234e:	00001097          	auipc	ra,0x1
    80002352:	466080e7          	jalr	1126(ra) # 800037b4 <acquiresleep>
      return b;
    80002356:	a8b9                	j	800023b4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002358:	00016497          	auipc	s1,0x16
    8000235c:	e104b483          	ld	s1,-496(s1) # 80018168 <bcache+0x82b0>
    80002360:	00016797          	auipc	a5,0x16
    80002364:	dc078793          	addi	a5,a5,-576 # 80018120 <bcache+0x8268>
    80002368:	00f48863          	beq	s1,a5,80002378 <bread+0x90>
    8000236c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000236e:	40bc                	lw	a5,64(s1)
    80002370:	cf81                	beqz	a5,80002388 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002372:	64a4                	ld	s1,72(s1)
    80002374:	fee49de3          	bne	s1,a4,8000236e <bread+0x86>
  panic("bget: no buffers");
    80002378:	00007517          	auipc	a0,0x7
    8000237c:	16050513          	addi	a0,a0,352 # 800094d8 <syscalls+0x100>
    80002380:	00005097          	auipc	ra,0x5
    80002384:	84a080e7          	jalr	-1974(ra) # 80006bca <panic>
      b->dev = dev;
    80002388:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000238c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002390:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002394:	4785                	li	a5,1
    80002396:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002398:	0000e517          	auipc	a0,0xe
    8000239c:	b2050513          	addi	a0,a0,-1248 # 8000feb8 <bcache>
    800023a0:	00005097          	auipc	ra,0x5
    800023a4:	e1a080e7          	jalr	-486(ra) # 800071ba <release>
      acquiresleep(&b->lock);
    800023a8:	01048513          	addi	a0,s1,16
    800023ac:	00001097          	auipc	ra,0x1
    800023b0:	408080e7          	jalr	1032(ra) # 800037b4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023b4:	409c                	lw	a5,0(s1)
    800023b6:	cb89                	beqz	a5,800023c8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023b8:	8526                	mv	a0,s1
    800023ba:	70a2                	ld	ra,40(sp)
    800023bc:	7402                	ld	s0,32(sp)
    800023be:	64e2                	ld	s1,24(sp)
    800023c0:	6942                	ld	s2,16(sp)
    800023c2:	69a2                	ld	s3,8(sp)
    800023c4:	6145                	addi	sp,sp,48
    800023c6:	8082                	ret
    virtio_disk_rw(b, 0);
    800023c8:	4581                	li	a1,0
    800023ca:	8526                	mv	a0,s1
    800023cc:	00003097          	auipc	ra,0x3
    800023d0:	ff4080e7          	jalr	-12(ra) # 800053c0 <virtio_disk_rw>
    b->valid = 1;
    800023d4:	4785                	li	a5,1
    800023d6:	c09c                	sw	a5,0(s1)
  return b;
    800023d8:	b7c5                	j	800023b8 <bread+0xd0>

00000000800023da <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	1000                	addi	s0,sp,32
    800023e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023e6:	0541                	addi	a0,a0,16
    800023e8:	00001097          	auipc	ra,0x1
    800023ec:	466080e7          	jalr	1126(ra) # 8000384e <holdingsleep>
    800023f0:	cd01                	beqz	a0,80002408 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023f2:	4585                	li	a1,1
    800023f4:	8526                	mv	a0,s1
    800023f6:	00003097          	auipc	ra,0x3
    800023fa:	fca080e7          	jalr	-54(ra) # 800053c0 <virtio_disk_rw>
}
    800023fe:	60e2                	ld	ra,24(sp)
    80002400:	6442                	ld	s0,16(sp)
    80002402:	64a2                	ld	s1,8(sp)
    80002404:	6105                	addi	sp,sp,32
    80002406:	8082                	ret
    panic("bwrite");
    80002408:	00007517          	auipc	a0,0x7
    8000240c:	0e850513          	addi	a0,a0,232 # 800094f0 <syscalls+0x118>
    80002410:	00004097          	auipc	ra,0x4
    80002414:	7ba080e7          	jalr	1978(ra) # 80006bca <panic>

0000000080002418 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002418:	1101                	addi	sp,sp,-32
    8000241a:	ec06                	sd	ra,24(sp)
    8000241c:	e822                	sd	s0,16(sp)
    8000241e:	e426                	sd	s1,8(sp)
    80002420:	e04a                	sd	s2,0(sp)
    80002422:	1000                	addi	s0,sp,32
    80002424:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002426:	01050913          	addi	s2,a0,16
    8000242a:	854a                	mv	a0,s2
    8000242c:	00001097          	auipc	ra,0x1
    80002430:	422080e7          	jalr	1058(ra) # 8000384e <holdingsleep>
    80002434:	c92d                	beqz	a0,800024a6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002436:	854a                	mv	a0,s2
    80002438:	00001097          	auipc	ra,0x1
    8000243c:	3d2080e7          	jalr	978(ra) # 8000380a <releasesleep>

  acquire(&bcache.lock);
    80002440:	0000e517          	auipc	a0,0xe
    80002444:	a7850513          	addi	a0,a0,-1416 # 8000feb8 <bcache>
    80002448:	00005097          	auipc	ra,0x5
    8000244c:	cbe080e7          	jalr	-834(ra) # 80007106 <acquire>
  b->refcnt--;
    80002450:	40bc                	lw	a5,64(s1)
    80002452:	37fd                	addiw	a5,a5,-1
    80002454:	0007871b          	sext.w	a4,a5
    80002458:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000245a:	eb05                	bnez	a4,8000248a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000245c:	68bc                	ld	a5,80(s1)
    8000245e:	64b8                	ld	a4,72(s1)
    80002460:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002462:	64bc                	ld	a5,72(s1)
    80002464:	68b8                	ld	a4,80(s1)
    80002466:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002468:	00016797          	auipc	a5,0x16
    8000246c:	a5078793          	addi	a5,a5,-1456 # 80017eb8 <bcache+0x8000>
    80002470:	2b87b703          	ld	a4,696(a5)
    80002474:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002476:	00016717          	auipc	a4,0x16
    8000247a:	caa70713          	addi	a4,a4,-854 # 80018120 <bcache+0x8268>
    8000247e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002480:	2b87b703          	ld	a4,696(a5)
    80002484:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002486:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000248a:	0000e517          	auipc	a0,0xe
    8000248e:	a2e50513          	addi	a0,a0,-1490 # 8000feb8 <bcache>
    80002492:	00005097          	auipc	ra,0x5
    80002496:	d28080e7          	jalr	-728(ra) # 800071ba <release>
}
    8000249a:	60e2                	ld	ra,24(sp)
    8000249c:	6442                	ld	s0,16(sp)
    8000249e:	64a2                	ld	s1,8(sp)
    800024a0:	6902                	ld	s2,0(sp)
    800024a2:	6105                	addi	sp,sp,32
    800024a4:	8082                	ret
    panic("brelse");
    800024a6:	00007517          	auipc	a0,0x7
    800024aa:	05250513          	addi	a0,a0,82 # 800094f8 <syscalls+0x120>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	71c080e7          	jalr	1820(ra) # 80006bca <panic>

00000000800024b6 <bpin>:

void
bpin(struct buf *b) {
    800024b6:	1101                	addi	sp,sp,-32
    800024b8:	ec06                	sd	ra,24(sp)
    800024ba:	e822                	sd	s0,16(sp)
    800024bc:	e426                	sd	s1,8(sp)
    800024be:	1000                	addi	s0,sp,32
    800024c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024c2:	0000e517          	auipc	a0,0xe
    800024c6:	9f650513          	addi	a0,a0,-1546 # 8000feb8 <bcache>
    800024ca:	00005097          	auipc	ra,0x5
    800024ce:	c3c080e7          	jalr	-964(ra) # 80007106 <acquire>
  b->refcnt++;
    800024d2:	40bc                	lw	a5,64(s1)
    800024d4:	2785                	addiw	a5,a5,1
    800024d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024d8:	0000e517          	auipc	a0,0xe
    800024dc:	9e050513          	addi	a0,a0,-1568 # 8000feb8 <bcache>
    800024e0:	00005097          	auipc	ra,0x5
    800024e4:	cda080e7          	jalr	-806(ra) # 800071ba <release>
}
    800024e8:	60e2                	ld	ra,24(sp)
    800024ea:	6442                	ld	s0,16(sp)
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret

00000000800024f2 <bunpin>:

void
bunpin(struct buf *b) {
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024fe:	0000e517          	auipc	a0,0xe
    80002502:	9ba50513          	addi	a0,a0,-1606 # 8000feb8 <bcache>
    80002506:	00005097          	auipc	ra,0x5
    8000250a:	c00080e7          	jalr	-1024(ra) # 80007106 <acquire>
  b->refcnt--;
    8000250e:	40bc                	lw	a5,64(s1)
    80002510:	37fd                	addiw	a5,a5,-1
    80002512:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002514:	0000e517          	auipc	a0,0xe
    80002518:	9a450513          	addi	a0,a0,-1628 # 8000feb8 <bcache>
    8000251c:	00005097          	auipc	ra,0x5
    80002520:	c9e080e7          	jalr	-866(ra) # 800071ba <release>
}
    80002524:	60e2                	ld	ra,24(sp)
    80002526:	6442                	ld	s0,16(sp)
    80002528:	64a2                	ld	s1,8(sp)
    8000252a:	6105                	addi	sp,sp,32
    8000252c:	8082                	ret

000000008000252e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000252e:	1101                	addi	sp,sp,-32
    80002530:	ec06                	sd	ra,24(sp)
    80002532:	e822                	sd	s0,16(sp)
    80002534:	e426                	sd	s1,8(sp)
    80002536:	e04a                	sd	s2,0(sp)
    80002538:	1000                	addi	s0,sp,32
    8000253a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000253c:	00d5d59b          	srliw	a1,a1,0xd
    80002540:	00016797          	auipc	a5,0x16
    80002544:	0547a783          	lw	a5,84(a5) # 80018594 <sb+0x1c>
    80002548:	9dbd                	addw	a1,a1,a5
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	d9e080e7          	jalr	-610(ra) # 800022e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002552:	0074f713          	andi	a4,s1,7
    80002556:	4785                	li	a5,1
    80002558:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000255c:	14ce                	slli	s1,s1,0x33
    8000255e:	90d9                	srli	s1,s1,0x36
    80002560:	00950733          	add	a4,a0,s1
    80002564:	05874703          	lbu	a4,88(a4)
    80002568:	00e7f6b3          	and	a3,a5,a4
    8000256c:	c69d                	beqz	a3,8000259a <bfree+0x6c>
    8000256e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002570:	94aa                	add	s1,s1,a0
    80002572:	fff7c793          	not	a5,a5
    80002576:	8ff9                	and	a5,a5,a4
    80002578:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000257c:	00001097          	auipc	ra,0x1
    80002580:	118080e7          	jalr	280(ra) # 80003694 <log_write>
  brelse(bp);
    80002584:	854a                	mv	a0,s2
    80002586:	00000097          	auipc	ra,0x0
    8000258a:	e92080e7          	jalr	-366(ra) # 80002418 <brelse>
}
    8000258e:	60e2                	ld	ra,24(sp)
    80002590:	6442                	ld	s0,16(sp)
    80002592:	64a2                	ld	s1,8(sp)
    80002594:	6902                	ld	s2,0(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret
    panic("freeing free block");
    8000259a:	00007517          	auipc	a0,0x7
    8000259e:	f6650513          	addi	a0,a0,-154 # 80009500 <syscalls+0x128>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	628080e7          	jalr	1576(ra) # 80006bca <panic>

00000000800025aa <balloc>:
{
    800025aa:	711d                	addi	sp,sp,-96
    800025ac:	ec86                	sd	ra,88(sp)
    800025ae:	e8a2                	sd	s0,80(sp)
    800025b0:	e4a6                	sd	s1,72(sp)
    800025b2:	e0ca                	sd	s2,64(sp)
    800025b4:	fc4e                	sd	s3,56(sp)
    800025b6:	f852                	sd	s4,48(sp)
    800025b8:	f456                	sd	s5,40(sp)
    800025ba:	f05a                	sd	s6,32(sp)
    800025bc:	ec5e                	sd	s7,24(sp)
    800025be:	e862                	sd	s8,16(sp)
    800025c0:	e466                	sd	s9,8(sp)
    800025c2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025c4:	00016797          	auipc	a5,0x16
    800025c8:	fb87a783          	lw	a5,-72(a5) # 8001857c <sb+0x4>
    800025cc:	cbd1                	beqz	a5,80002660 <balloc+0xb6>
    800025ce:	8baa                	mv	s7,a0
    800025d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025d2:	00016b17          	auipc	s6,0x16
    800025d6:	fa6b0b13          	addi	s6,s6,-90 # 80018578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025e0:	6c89                	lui	s9,0x2
    800025e2:	a831                	j	800025fe <balloc+0x54>
    brelse(bp);
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e32080e7          	jalr	-462(ra) # 80002418 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025ee:	015c87bb          	addw	a5,s9,s5
    800025f2:	00078a9b          	sext.w	s5,a5
    800025f6:	004b2703          	lw	a4,4(s6)
    800025fa:	06eaf363          	bgeu	s5,a4,80002660 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800025fe:	41fad79b          	sraiw	a5,s5,0x1f
    80002602:	0137d79b          	srliw	a5,a5,0x13
    80002606:	015787bb          	addw	a5,a5,s5
    8000260a:	40d7d79b          	sraiw	a5,a5,0xd
    8000260e:	01cb2583          	lw	a1,28(s6)
    80002612:	9dbd                	addw	a1,a1,a5
    80002614:	855e                	mv	a0,s7
    80002616:	00000097          	auipc	ra,0x0
    8000261a:	cd2080e7          	jalr	-814(ra) # 800022e8 <bread>
    8000261e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002620:	004b2503          	lw	a0,4(s6)
    80002624:	000a849b          	sext.w	s1,s5
    80002628:	8662                	mv	a2,s8
    8000262a:	faa4fde3          	bgeu	s1,a0,800025e4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000262e:	41f6579b          	sraiw	a5,a2,0x1f
    80002632:	01d7d69b          	srliw	a3,a5,0x1d
    80002636:	00c6873b          	addw	a4,a3,a2
    8000263a:	00777793          	andi	a5,a4,7
    8000263e:	9f95                	subw	a5,a5,a3
    80002640:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002644:	4037571b          	sraiw	a4,a4,0x3
    80002648:	00e906b3          	add	a3,s2,a4
    8000264c:	0586c683          	lbu	a3,88(a3)
    80002650:	00d7f5b3          	and	a1,a5,a3
    80002654:	cd91                	beqz	a1,80002670 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002656:	2605                	addiw	a2,a2,1
    80002658:	2485                	addiw	s1,s1,1
    8000265a:	fd4618e3          	bne	a2,s4,8000262a <balloc+0x80>
    8000265e:	b759                	j	800025e4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002660:	00007517          	auipc	a0,0x7
    80002664:	eb850513          	addi	a0,a0,-328 # 80009518 <syscalls+0x140>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	562080e7          	jalr	1378(ra) # 80006bca <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002670:	974a                	add	a4,a4,s2
    80002672:	8fd5                	or	a5,a5,a3
    80002674:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002678:	854a                	mv	a0,s2
    8000267a:	00001097          	auipc	ra,0x1
    8000267e:	01a080e7          	jalr	26(ra) # 80003694 <log_write>
        brelse(bp);
    80002682:	854a                	mv	a0,s2
    80002684:	00000097          	auipc	ra,0x0
    80002688:	d94080e7          	jalr	-620(ra) # 80002418 <brelse>
  bp = bread(dev, bno);
    8000268c:	85a6                	mv	a1,s1
    8000268e:	855e                	mv	a0,s7
    80002690:	00000097          	auipc	ra,0x0
    80002694:	c58080e7          	jalr	-936(ra) # 800022e8 <bread>
    80002698:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000269a:	40000613          	li	a2,1024
    8000269e:	4581                	li	a1,0
    800026a0:	05850513          	addi	a0,a0,88
    800026a4:	ffffe097          	auipc	ra,0xffffe
    800026a8:	ad4080e7          	jalr	-1324(ra) # 80000178 <memset>
  log_write(bp);
    800026ac:	854a                	mv	a0,s2
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	fe6080e7          	jalr	-26(ra) # 80003694 <log_write>
  brelse(bp);
    800026b6:	854a                	mv	a0,s2
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	d60080e7          	jalr	-672(ra) # 80002418 <brelse>
}
    800026c0:	8526                	mv	a0,s1
    800026c2:	60e6                	ld	ra,88(sp)
    800026c4:	6446                	ld	s0,80(sp)
    800026c6:	64a6                	ld	s1,72(sp)
    800026c8:	6906                	ld	s2,64(sp)
    800026ca:	79e2                	ld	s3,56(sp)
    800026cc:	7a42                	ld	s4,48(sp)
    800026ce:	7aa2                	ld	s5,40(sp)
    800026d0:	7b02                	ld	s6,32(sp)
    800026d2:	6be2                	ld	s7,24(sp)
    800026d4:	6c42                	ld	s8,16(sp)
    800026d6:	6ca2                	ld	s9,8(sp)
    800026d8:	6125                	addi	sp,sp,96
    800026da:	8082                	ret

00000000800026dc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026dc:	7179                	addi	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	e052                	sd	s4,0(sp)
    800026ea:	1800                	addi	s0,sp,48
    800026ec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026ee:	47ad                	li	a5,11
    800026f0:	04b7fe63          	bgeu	a5,a1,8000274c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026f4:	ff45849b          	addiw	s1,a1,-12
    800026f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026fc:	0ff00793          	li	a5,255
    80002700:	0ae7e363          	bltu	a5,a4,800027a6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002704:	08052583          	lw	a1,128(a0)
    80002708:	c5ad                	beqz	a1,80002772 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000270a:	00092503          	lw	a0,0(s2)
    8000270e:	00000097          	auipc	ra,0x0
    80002712:	bda080e7          	jalr	-1062(ra) # 800022e8 <bread>
    80002716:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002718:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000271c:	02049593          	slli	a1,s1,0x20
    80002720:	9181                	srli	a1,a1,0x20
    80002722:	058a                	slli	a1,a1,0x2
    80002724:	00b784b3          	add	s1,a5,a1
    80002728:	0004a983          	lw	s3,0(s1)
    8000272c:	04098d63          	beqz	s3,80002786 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002730:	8552                	mv	a0,s4
    80002732:	00000097          	auipc	ra,0x0
    80002736:	ce6080e7          	jalr	-794(ra) # 80002418 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000273a:	854e                	mv	a0,s3
    8000273c:	70a2                	ld	ra,40(sp)
    8000273e:	7402                	ld	s0,32(sp)
    80002740:	64e2                	ld	s1,24(sp)
    80002742:	6942                	ld	s2,16(sp)
    80002744:	69a2                	ld	s3,8(sp)
    80002746:	6a02                	ld	s4,0(sp)
    80002748:	6145                	addi	sp,sp,48
    8000274a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000274c:	02059493          	slli	s1,a1,0x20
    80002750:	9081                	srli	s1,s1,0x20
    80002752:	048a                	slli	s1,s1,0x2
    80002754:	94aa                	add	s1,s1,a0
    80002756:	0504a983          	lw	s3,80(s1)
    8000275a:	fe0990e3          	bnez	s3,8000273a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000275e:	4108                	lw	a0,0(a0)
    80002760:	00000097          	auipc	ra,0x0
    80002764:	e4a080e7          	jalr	-438(ra) # 800025aa <balloc>
    80002768:	0005099b          	sext.w	s3,a0
    8000276c:	0534a823          	sw	s3,80(s1)
    80002770:	b7e9                	j	8000273a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002772:	4108                	lw	a0,0(a0)
    80002774:	00000097          	auipc	ra,0x0
    80002778:	e36080e7          	jalr	-458(ra) # 800025aa <balloc>
    8000277c:	0005059b          	sext.w	a1,a0
    80002780:	08b92023          	sw	a1,128(s2)
    80002784:	b759                	j	8000270a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002786:	00092503          	lw	a0,0(s2)
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	e20080e7          	jalr	-480(ra) # 800025aa <balloc>
    80002792:	0005099b          	sext.w	s3,a0
    80002796:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000279a:	8552                	mv	a0,s4
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	ef8080e7          	jalr	-264(ra) # 80003694 <log_write>
    800027a4:	b771                	j	80002730 <bmap+0x54>
  panic("bmap: out of range");
    800027a6:	00007517          	auipc	a0,0x7
    800027aa:	d8a50513          	addi	a0,a0,-630 # 80009530 <syscalls+0x158>
    800027ae:	00004097          	auipc	ra,0x4
    800027b2:	41c080e7          	jalr	1052(ra) # 80006bca <panic>

00000000800027b6 <iget>:
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	e052                	sd	s4,0(sp)
    800027c4:	1800                	addi	s0,sp,48
    800027c6:	89aa                	mv	s3,a0
    800027c8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ca:	00016517          	auipc	a0,0x16
    800027ce:	dce50513          	addi	a0,a0,-562 # 80018598 <itable>
    800027d2:	00005097          	auipc	ra,0x5
    800027d6:	934080e7          	jalr	-1740(ra) # 80007106 <acquire>
  empty = 0;
    800027da:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027dc:	00016497          	auipc	s1,0x16
    800027e0:	dd448493          	addi	s1,s1,-556 # 800185b0 <itable+0x18>
    800027e4:	00018697          	auipc	a3,0x18
    800027e8:	85c68693          	addi	a3,a3,-1956 # 8001a040 <log>
    800027ec:	a039                	j	800027fa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ee:	02090b63          	beqz	s2,80002824 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f2:	08848493          	addi	s1,s1,136
    800027f6:	02d48a63          	beq	s1,a3,8000282a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027fa:	449c                	lw	a5,8(s1)
    800027fc:	fef059e3          	blez	a5,800027ee <iget+0x38>
    80002800:	4098                	lw	a4,0(s1)
    80002802:	ff3716e3          	bne	a4,s3,800027ee <iget+0x38>
    80002806:	40d8                	lw	a4,4(s1)
    80002808:	ff4713e3          	bne	a4,s4,800027ee <iget+0x38>
      ip->ref++;
    8000280c:	2785                	addiw	a5,a5,1
    8000280e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002810:	00016517          	auipc	a0,0x16
    80002814:	d8850513          	addi	a0,a0,-632 # 80018598 <itable>
    80002818:	00005097          	auipc	ra,0x5
    8000281c:	9a2080e7          	jalr	-1630(ra) # 800071ba <release>
      return ip;
    80002820:	8926                	mv	s2,s1
    80002822:	a03d                	j	80002850 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002824:	f7f9                	bnez	a5,800027f2 <iget+0x3c>
    80002826:	8926                	mv	s2,s1
    80002828:	b7e9                	j	800027f2 <iget+0x3c>
  if(empty == 0)
    8000282a:	02090c63          	beqz	s2,80002862 <iget+0xac>
  ip->dev = dev;
    8000282e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002832:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002836:	4785                	li	a5,1
    80002838:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002840:	00016517          	auipc	a0,0x16
    80002844:	d5850513          	addi	a0,a0,-680 # 80018598 <itable>
    80002848:	00005097          	auipc	ra,0x5
    8000284c:	972080e7          	jalr	-1678(ra) # 800071ba <release>
}
    80002850:	854a                	mv	a0,s2
    80002852:	70a2                	ld	ra,40(sp)
    80002854:	7402                	ld	s0,32(sp)
    80002856:	64e2                	ld	s1,24(sp)
    80002858:	6942                	ld	s2,16(sp)
    8000285a:	69a2                	ld	s3,8(sp)
    8000285c:	6a02                	ld	s4,0(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
    panic("iget: no inodes");
    80002862:	00007517          	auipc	a0,0x7
    80002866:	ce650513          	addi	a0,a0,-794 # 80009548 <syscalls+0x170>
    8000286a:	00004097          	auipc	ra,0x4
    8000286e:	360080e7          	jalr	864(ra) # 80006bca <panic>

0000000080002872 <fsinit>:
fsinit(int dev) {
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002882:	4585                	li	a1,1
    80002884:	00000097          	auipc	ra,0x0
    80002888:	a64080e7          	jalr	-1436(ra) # 800022e8 <bread>
    8000288c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000288e:	00016997          	auipc	s3,0x16
    80002892:	cea98993          	addi	s3,s3,-790 # 80018578 <sb>
    80002896:	02000613          	li	a2,32
    8000289a:	05850593          	addi	a1,a0,88
    8000289e:	854e                	mv	a0,s3
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	934080e7          	jalr	-1740(ra) # 800001d4 <memmove>
  brelse(bp);
    800028a8:	8526                	mv	a0,s1
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	b6e080e7          	jalr	-1170(ra) # 80002418 <brelse>
  if(sb.magic != FSMAGIC)
    800028b2:	0009a703          	lw	a4,0(s3)
    800028b6:	102037b7          	lui	a5,0x10203
    800028ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028be:	02f71263          	bne	a4,a5,800028e2 <fsinit+0x70>
  initlog(dev, &sb);
    800028c2:	00016597          	auipc	a1,0x16
    800028c6:	cb658593          	addi	a1,a1,-842 # 80018578 <sb>
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	b4c080e7          	jalr	-1204(ra) # 80003418 <initlog>
}
    800028d4:	70a2                	ld	ra,40(sp)
    800028d6:	7402                	ld	s0,32(sp)
    800028d8:	64e2                	ld	s1,24(sp)
    800028da:	6942                	ld	s2,16(sp)
    800028dc:	69a2                	ld	s3,8(sp)
    800028de:	6145                	addi	sp,sp,48
    800028e0:	8082                	ret
    panic("invalid file system");
    800028e2:	00007517          	auipc	a0,0x7
    800028e6:	c7650513          	addi	a0,a0,-906 # 80009558 <syscalls+0x180>
    800028ea:	00004097          	auipc	ra,0x4
    800028ee:	2e0080e7          	jalr	736(ra) # 80006bca <panic>

00000000800028f2 <iinit>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002900:	00007597          	auipc	a1,0x7
    80002904:	c7058593          	addi	a1,a1,-912 # 80009570 <syscalls+0x198>
    80002908:	00016517          	auipc	a0,0x16
    8000290c:	c9050513          	addi	a0,a0,-880 # 80018598 <itable>
    80002910:	00004097          	auipc	ra,0x4
    80002914:	766080e7          	jalr	1894(ra) # 80007076 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002918:	00016497          	auipc	s1,0x16
    8000291c:	ca848493          	addi	s1,s1,-856 # 800185c0 <itable+0x28>
    80002920:	00017997          	auipc	s3,0x17
    80002924:	73098993          	addi	s3,s3,1840 # 8001a050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002928:	00007917          	auipc	s2,0x7
    8000292c:	c5090913          	addi	s2,s2,-944 # 80009578 <syscalls+0x1a0>
    80002930:	85ca                	mv	a1,s2
    80002932:	8526                	mv	a0,s1
    80002934:	00001097          	auipc	ra,0x1
    80002938:	e46080e7          	jalr	-442(ra) # 8000377a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293c:	08848493          	addi	s1,s1,136
    80002940:	ff3498e3          	bne	s1,s3,80002930 <iinit+0x3e>
}
    80002944:	70a2                	ld	ra,40(sp)
    80002946:	7402                	ld	s0,32(sp)
    80002948:	64e2                	ld	s1,24(sp)
    8000294a:	6942                	ld	s2,16(sp)
    8000294c:	69a2                	ld	s3,8(sp)
    8000294e:	6145                	addi	sp,sp,48
    80002950:	8082                	ret

0000000080002952 <ialloc>:
{
    80002952:	715d                	addi	sp,sp,-80
    80002954:	e486                	sd	ra,72(sp)
    80002956:	e0a2                	sd	s0,64(sp)
    80002958:	fc26                	sd	s1,56(sp)
    8000295a:	f84a                	sd	s2,48(sp)
    8000295c:	f44e                	sd	s3,40(sp)
    8000295e:	f052                	sd	s4,32(sp)
    80002960:	ec56                	sd	s5,24(sp)
    80002962:	e85a                	sd	s6,16(sp)
    80002964:	e45e                	sd	s7,8(sp)
    80002966:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002968:	00016717          	auipc	a4,0x16
    8000296c:	c1c72703          	lw	a4,-996(a4) # 80018584 <sb+0xc>
    80002970:	4785                	li	a5,1
    80002972:	04e7fa63          	bgeu	a5,a4,800029c6 <ialloc+0x74>
    80002976:	8aaa                	mv	s5,a0
    80002978:	8bae                	mv	s7,a1
    8000297a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297c:	00016a17          	auipc	s4,0x16
    80002980:	bfca0a13          	addi	s4,s4,-1028 # 80018578 <sb>
    80002984:	00048b1b          	sext.w	s6,s1
    80002988:	0044d793          	srli	a5,s1,0x4
    8000298c:	018a2583          	lw	a1,24(s4)
    80002990:	9dbd                	addw	a1,a1,a5
    80002992:	8556                	mv	a0,s5
    80002994:	00000097          	auipc	ra,0x0
    80002998:	954080e7          	jalr	-1708(ra) # 800022e8 <bread>
    8000299c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000299e:	05850993          	addi	s3,a0,88
    800029a2:	00f4f793          	andi	a5,s1,15
    800029a6:	079a                	slli	a5,a5,0x6
    800029a8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029aa:	00099783          	lh	a5,0(s3)
    800029ae:	c785                	beqz	a5,800029d6 <ialloc+0x84>
    brelse(bp);
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	a68080e7          	jalr	-1432(ra) # 80002418 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b8:	0485                	addi	s1,s1,1
    800029ba:	00ca2703          	lw	a4,12(s4)
    800029be:	0004879b          	sext.w	a5,s1
    800029c2:	fce7e1e3          	bltu	a5,a4,80002984 <ialloc+0x32>
  panic("ialloc: no inodes");
    800029c6:	00007517          	auipc	a0,0x7
    800029ca:	bba50513          	addi	a0,a0,-1094 # 80009580 <syscalls+0x1a8>
    800029ce:	00004097          	auipc	ra,0x4
    800029d2:	1fc080e7          	jalr	508(ra) # 80006bca <panic>
      memset(dip, 0, sizeof(*dip));
    800029d6:	04000613          	li	a2,64
    800029da:	4581                	li	a1,0
    800029dc:	854e                	mv	a0,s3
    800029de:	ffffd097          	auipc	ra,0xffffd
    800029e2:	79a080e7          	jalr	1946(ra) # 80000178 <memset>
      dip->type = type;
    800029e6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029ea:	854a                	mv	a0,s2
    800029ec:	00001097          	auipc	ra,0x1
    800029f0:	ca8080e7          	jalr	-856(ra) # 80003694 <log_write>
      brelse(bp);
    800029f4:	854a                	mv	a0,s2
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	a22080e7          	jalr	-1502(ra) # 80002418 <brelse>
      return iget(dev, inum);
    800029fe:	85da                	mv	a1,s6
    80002a00:	8556                	mv	a0,s5
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	db4080e7          	jalr	-588(ra) # 800027b6 <iget>
}
    80002a0a:	60a6                	ld	ra,72(sp)
    80002a0c:	6406                	ld	s0,64(sp)
    80002a0e:	74e2                	ld	s1,56(sp)
    80002a10:	7942                	ld	s2,48(sp)
    80002a12:	79a2                	ld	s3,40(sp)
    80002a14:	7a02                	ld	s4,32(sp)
    80002a16:	6ae2                	ld	s5,24(sp)
    80002a18:	6b42                	ld	s6,16(sp)
    80002a1a:	6ba2                	ld	s7,8(sp)
    80002a1c:	6161                	addi	sp,sp,80
    80002a1e:	8082                	ret

0000000080002a20 <iupdate>:
{
    80002a20:	1101                	addi	sp,sp,-32
    80002a22:	ec06                	sd	ra,24(sp)
    80002a24:	e822                	sd	s0,16(sp)
    80002a26:	e426                	sd	s1,8(sp)
    80002a28:	e04a                	sd	s2,0(sp)
    80002a2a:	1000                	addi	s0,sp,32
    80002a2c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a2e:	415c                	lw	a5,4(a0)
    80002a30:	0047d79b          	srliw	a5,a5,0x4
    80002a34:	00016597          	auipc	a1,0x16
    80002a38:	b5c5a583          	lw	a1,-1188(a1) # 80018590 <sb+0x18>
    80002a3c:	9dbd                	addw	a1,a1,a5
    80002a3e:	4108                	lw	a0,0(a0)
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	8a8080e7          	jalr	-1880(ra) # 800022e8 <bread>
    80002a48:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4a:	05850793          	addi	a5,a0,88
    80002a4e:	40c8                	lw	a0,4(s1)
    80002a50:	893d                	andi	a0,a0,15
    80002a52:	051a                	slli	a0,a0,0x6
    80002a54:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a56:	04449703          	lh	a4,68(s1)
    80002a5a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a5e:	04649703          	lh	a4,70(s1)
    80002a62:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a66:	04849703          	lh	a4,72(s1)
    80002a6a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a6e:	04a49703          	lh	a4,74(s1)
    80002a72:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a76:	44f8                	lw	a4,76(s1)
    80002a78:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a7a:	03400613          	li	a2,52
    80002a7e:	05048593          	addi	a1,s1,80
    80002a82:	0531                	addi	a0,a0,12
    80002a84:	ffffd097          	auipc	ra,0xffffd
    80002a88:	750080e7          	jalr	1872(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	00001097          	auipc	ra,0x1
    80002a92:	c06080e7          	jalr	-1018(ra) # 80003694 <log_write>
  brelse(bp);
    80002a96:	854a                	mv	a0,s2
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	980080e7          	jalr	-1664(ra) # 80002418 <brelse>
}
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6902                	ld	s2,0(sp)
    80002aa8:	6105                	addi	sp,sp,32
    80002aaa:	8082                	ret

0000000080002aac <idup>:
{
    80002aac:	1101                	addi	sp,sp,-32
    80002aae:	ec06                	sd	ra,24(sp)
    80002ab0:	e822                	sd	s0,16(sp)
    80002ab2:	e426                	sd	s1,8(sp)
    80002ab4:	1000                	addi	s0,sp,32
    80002ab6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ab8:	00016517          	auipc	a0,0x16
    80002abc:	ae050513          	addi	a0,a0,-1312 # 80018598 <itable>
    80002ac0:	00004097          	auipc	ra,0x4
    80002ac4:	646080e7          	jalr	1606(ra) # 80007106 <acquire>
  ip->ref++;
    80002ac8:	449c                	lw	a5,8(s1)
    80002aca:	2785                	addiw	a5,a5,1
    80002acc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ace:	00016517          	auipc	a0,0x16
    80002ad2:	aca50513          	addi	a0,a0,-1334 # 80018598 <itable>
    80002ad6:	00004097          	auipc	ra,0x4
    80002ada:	6e4080e7          	jalr	1764(ra) # 800071ba <release>
}
    80002ade:	8526                	mv	a0,s1
    80002ae0:	60e2                	ld	ra,24(sp)
    80002ae2:	6442                	ld	s0,16(sp)
    80002ae4:	64a2                	ld	s1,8(sp)
    80002ae6:	6105                	addi	sp,sp,32
    80002ae8:	8082                	ret

0000000080002aea <ilock>:
{
    80002aea:	1101                	addi	sp,sp,-32
    80002aec:	ec06                	sd	ra,24(sp)
    80002aee:	e822                	sd	s0,16(sp)
    80002af0:	e426                	sd	s1,8(sp)
    80002af2:	e04a                	sd	s2,0(sp)
    80002af4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002af6:	c115                	beqz	a0,80002b1a <ilock+0x30>
    80002af8:	84aa                	mv	s1,a0
    80002afa:	451c                	lw	a5,8(a0)
    80002afc:	00f05f63          	blez	a5,80002b1a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b00:	0541                	addi	a0,a0,16
    80002b02:	00001097          	auipc	ra,0x1
    80002b06:	cb2080e7          	jalr	-846(ra) # 800037b4 <acquiresleep>
  if(ip->valid == 0){
    80002b0a:	40bc                	lw	a5,64(s1)
    80002b0c:	cf99                	beqz	a5,80002b2a <ilock+0x40>
}
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6902                	ld	s2,0(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret
    panic("ilock");
    80002b1a:	00007517          	auipc	a0,0x7
    80002b1e:	a7e50513          	addi	a0,a0,-1410 # 80009598 <syscalls+0x1c0>
    80002b22:	00004097          	auipc	ra,0x4
    80002b26:	0a8080e7          	jalr	168(ra) # 80006bca <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2a:	40dc                	lw	a5,4(s1)
    80002b2c:	0047d79b          	srliw	a5,a5,0x4
    80002b30:	00016597          	auipc	a1,0x16
    80002b34:	a605a583          	lw	a1,-1440(a1) # 80018590 <sb+0x18>
    80002b38:	9dbd                	addw	a1,a1,a5
    80002b3a:	4088                	lw	a0,0(s1)
    80002b3c:	fffff097          	auipc	ra,0xfffff
    80002b40:	7ac080e7          	jalr	1964(ra) # 800022e8 <bread>
    80002b44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b46:	05850593          	addi	a1,a0,88
    80002b4a:	40dc                	lw	a5,4(s1)
    80002b4c:	8bbd                	andi	a5,a5,15
    80002b4e:	079a                	slli	a5,a5,0x6
    80002b50:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b52:	00059783          	lh	a5,0(a1)
    80002b56:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5a:	00259783          	lh	a5,2(a1)
    80002b5e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b62:	00459783          	lh	a5,4(a1)
    80002b66:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6a:	00659783          	lh	a5,6(a1)
    80002b6e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b72:	459c                	lw	a5,8(a1)
    80002b74:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b76:	03400613          	li	a2,52
    80002b7a:	05b1                	addi	a1,a1,12
    80002b7c:	05048513          	addi	a0,s1,80
    80002b80:	ffffd097          	auipc	ra,0xffffd
    80002b84:	654080e7          	jalr	1620(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b88:	854a                	mv	a0,s2
    80002b8a:	00000097          	auipc	ra,0x0
    80002b8e:	88e080e7          	jalr	-1906(ra) # 80002418 <brelse>
    ip->valid = 1;
    80002b92:	4785                	li	a5,1
    80002b94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b96:	04449783          	lh	a5,68(s1)
    80002b9a:	fbb5                	bnez	a5,80002b0e <ilock+0x24>
      panic("ilock: no type");
    80002b9c:	00007517          	auipc	a0,0x7
    80002ba0:	a0450513          	addi	a0,a0,-1532 # 800095a0 <syscalls+0x1c8>
    80002ba4:	00004097          	auipc	ra,0x4
    80002ba8:	026080e7          	jalr	38(ra) # 80006bca <panic>

0000000080002bac <iunlock>:
{
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	e04a                	sd	s2,0(sp)
    80002bb6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bb8:	c905                	beqz	a0,80002be8 <iunlock+0x3c>
    80002bba:	84aa                	mv	s1,a0
    80002bbc:	01050913          	addi	s2,a0,16
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	c8c080e7          	jalr	-884(ra) # 8000384e <holdingsleep>
    80002bca:	cd19                	beqz	a0,80002be8 <iunlock+0x3c>
    80002bcc:	449c                	lw	a5,8(s1)
    80002bce:	00f05d63          	blez	a5,80002be8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	c36080e7          	jalr	-970(ra) # 8000380a <releasesleep>
}
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6902                	ld	s2,0(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret
    panic("iunlock");
    80002be8:	00007517          	auipc	a0,0x7
    80002bec:	9c850513          	addi	a0,a0,-1592 # 800095b0 <syscalls+0x1d8>
    80002bf0:	00004097          	auipc	ra,0x4
    80002bf4:	fda080e7          	jalr	-38(ra) # 80006bca <panic>

0000000080002bf8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bf8:	7179                	addi	sp,sp,-48
    80002bfa:	f406                	sd	ra,40(sp)
    80002bfc:	f022                	sd	s0,32(sp)
    80002bfe:	ec26                	sd	s1,24(sp)
    80002c00:	e84a                	sd	s2,16(sp)
    80002c02:	e44e                	sd	s3,8(sp)
    80002c04:	e052                	sd	s4,0(sp)
    80002c06:	1800                	addi	s0,sp,48
    80002c08:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0a:	05050493          	addi	s1,a0,80
    80002c0e:	08050913          	addi	s2,a0,128
    80002c12:	a021                	j	80002c1a <itrunc+0x22>
    80002c14:	0491                	addi	s1,s1,4
    80002c16:	01248d63          	beq	s1,s2,80002c30 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1a:	408c                	lw	a1,0(s1)
    80002c1c:	dde5                	beqz	a1,80002c14 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c1e:	0009a503          	lw	a0,0(s3)
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	90c080e7          	jalr	-1780(ra) # 8000252e <bfree>
      ip->addrs[i] = 0;
    80002c2a:	0004a023          	sw	zero,0(s1)
    80002c2e:	b7dd                	j	80002c14 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c30:	0809a583          	lw	a1,128(s3)
    80002c34:	e185                	bnez	a1,80002c54 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c36:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3a:	854e                	mv	a0,s3
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	de4080e7          	jalr	-540(ra) # 80002a20 <iupdate>
}
    80002c44:	70a2                	ld	ra,40(sp)
    80002c46:	7402                	ld	s0,32(sp)
    80002c48:	64e2                	ld	s1,24(sp)
    80002c4a:	6942                	ld	s2,16(sp)
    80002c4c:	69a2                	ld	s3,8(sp)
    80002c4e:	6a02                	ld	s4,0(sp)
    80002c50:	6145                	addi	sp,sp,48
    80002c52:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c54:	0009a503          	lw	a0,0(s3)
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	690080e7          	jalr	1680(ra) # 800022e8 <bread>
    80002c60:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c62:	05850493          	addi	s1,a0,88
    80002c66:	45850913          	addi	s2,a0,1112
    80002c6a:	a021                	j	80002c72 <itrunc+0x7a>
    80002c6c:	0491                	addi	s1,s1,4
    80002c6e:	01248b63          	beq	s1,s2,80002c84 <itrunc+0x8c>
      if(a[j])
    80002c72:	408c                	lw	a1,0(s1)
    80002c74:	dde5                	beqz	a1,80002c6c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c76:	0009a503          	lw	a0,0(s3)
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	8b4080e7          	jalr	-1868(ra) # 8000252e <bfree>
    80002c82:	b7ed                	j	80002c6c <itrunc+0x74>
    brelse(bp);
    80002c84:	8552                	mv	a0,s4
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	792080e7          	jalr	1938(ra) # 80002418 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c8e:	0809a583          	lw	a1,128(s3)
    80002c92:	0009a503          	lw	a0,0(s3)
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	898080e7          	jalr	-1896(ra) # 8000252e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c9e:	0809a023          	sw	zero,128(s3)
    80002ca2:	bf51                	j	80002c36 <itrunc+0x3e>

0000000080002ca4 <iput>:
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	e04a                	sd	s2,0(sp)
    80002cae:	1000                	addi	s0,sp,32
    80002cb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb2:	00016517          	auipc	a0,0x16
    80002cb6:	8e650513          	addi	a0,a0,-1818 # 80018598 <itable>
    80002cba:	00004097          	auipc	ra,0x4
    80002cbe:	44c080e7          	jalr	1100(ra) # 80007106 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc2:	4498                	lw	a4,8(s1)
    80002cc4:	4785                	li	a5,1
    80002cc6:	02f70363          	beq	a4,a5,80002cec <iput+0x48>
  ip->ref--;
    80002cca:	449c                	lw	a5,8(s1)
    80002ccc:	37fd                	addiw	a5,a5,-1
    80002cce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd0:	00016517          	auipc	a0,0x16
    80002cd4:	8c850513          	addi	a0,a0,-1848 # 80018598 <itable>
    80002cd8:	00004097          	auipc	ra,0x4
    80002cdc:	4e2080e7          	jalr	1250(ra) # 800071ba <release>
}
    80002ce0:	60e2                	ld	ra,24(sp)
    80002ce2:	6442                	ld	s0,16(sp)
    80002ce4:	64a2                	ld	s1,8(sp)
    80002ce6:	6902                	ld	s2,0(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cec:	40bc                	lw	a5,64(s1)
    80002cee:	dff1                	beqz	a5,80002cca <iput+0x26>
    80002cf0:	04a49783          	lh	a5,74(s1)
    80002cf4:	fbf9                	bnez	a5,80002cca <iput+0x26>
    acquiresleep(&ip->lock);
    80002cf6:	01048913          	addi	s2,s1,16
    80002cfa:	854a                	mv	a0,s2
    80002cfc:	00001097          	auipc	ra,0x1
    80002d00:	ab8080e7          	jalr	-1352(ra) # 800037b4 <acquiresleep>
    release(&itable.lock);
    80002d04:	00016517          	auipc	a0,0x16
    80002d08:	89450513          	addi	a0,a0,-1900 # 80018598 <itable>
    80002d0c:	00004097          	auipc	ra,0x4
    80002d10:	4ae080e7          	jalr	1198(ra) # 800071ba <release>
    itrunc(ip);
    80002d14:	8526                	mv	a0,s1
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	ee2080e7          	jalr	-286(ra) # 80002bf8 <itrunc>
    ip->type = 0;
    80002d1e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d22:	8526                	mv	a0,s1
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	cfc080e7          	jalr	-772(ra) # 80002a20 <iupdate>
    ip->valid = 0;
    80002d2c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d30:	854a                	mv	a0,s2
    80002d32:	00001097          	auipc	ra,0x1
    80002d36:	ad8080e7          	jalr	-1320(ra) # 8000380a <releasesleep>
    acquire(&itable.lock);
    80002d3a:	00016517          	auipc	a0,0x16
    80002d3e:	85e50513          	addi	a0,a0,-1954 # 80018598 <itable>
    80002d42:	00004097          	auipc	ra,0x4
    80002d46:	3c4080e7          	jalr	964(ra) # 80007106 <acquire>
    80002d4a:	b741                	j	80002cca <iput+0x26>

0000000080002d4c <iunlockput>:
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	1000                	addi	s0,sp,32
    80002d56:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	e54080e7          	jalr	-428(ra) # 80002bac <iunlock>
  iput(ip);
    80002d60:	8526                	mv	a0,s1
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	f42080e7          	jalr	-190(ra) # 80002ca4 <iput>
}
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d74:	1141                	addi	sp,sp,-16
    80002d76:	e422                	sd	s0,8(sp)
    80002d78:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7a:	411c                	lw	a5,0(a0)
    80002d7c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d7e:	415c                	lw	a5,4(a0)
    80002d80:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d82:	04451783          	lh	a5,68(a0)
    80002d86:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8a:	04a51783          	lh	a5,74(a0)
    80002d8e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d92:	04c56783          	lwu	a5,76(a0)
    80002d96:	e99c                	sd	a5,16(a1)
}
    80002d98:	6422                	ld	s0,8(sp)
    80002d9a:	0141                	addi	sp,sp,16
    80002d9c:	8082                	ret

0000000080002d9e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d9e:	457c                	lw	a5,76(a0)
    80002da0:	0ed7e963          	bltu	a5,a3,80002e92 <readi+0xf4>
{
    80002da4:	7159                	addi	sp,sp,-112
    80002da6:	f486                	sd	ra,104(sp)
    80002da8:	f0a2                	sd	s0,96(sp)
    80002daa:	eca6                	sd	s1,88(sp)
    80002dac:	e8ca                	sd	s2,80(sp)
    80002dae:	e4ce                	sd	s3,72(sp)
    80002db0:	e0d2                	sd	s4,64(sp)
    80002db2:	fc56                	sd	s5,56(sp)
    80002db4:	f85a                	sd	s6,48(sp)
    80002db6:	f45e                	sd	s7,40(sp)
    80002db8:	f062                	sd	s8,32(sp)
    80002dba:	ec66                	sd	s9,24(sp)
    80002dbc:	e86a                	sd	s10,16(sp)
    80002dbe:	e46e                	sd	s11,8(sp)
    80002dc0:	1880                	addi	s0,sp,112
    80002dc2:	8baa                	mv	s7,a0
    80002dc4:	8c2e                	mv	s8,a1
    80002dc6:	8ab2                	mv	s5,a2
    80002dc8:	84b6                	mv	s1,a3
    80002dca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dcc:	9f35                	addw	a4,a4,a3
    return 0;
    80002dce:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd0:	0ad76063          	bltu	a4,a3,80002e70 <readi+0xd2>
  if(off + n > ip->size)
    80002dd4:	00e7f463          	bgeu	a5,a4,80002ddc <readi+0x3e>
    n = ip->size - off;
    80002dd8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ddc:	0a0b0963          	beqz	s6,80002e8e <readi+0xf0>
    80002de0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002de6:	5cfd                	li	s9,-1
    80002de8:	a82d                	j	80002e22 <readi+0x84>
    80002dea:	020a1d93          	slli	s11,s4,0x20
    80002dee:	020ddd93          	srli	s11,s11,0x20
    80002df2:	05890793          	addi	a5,s2,88
    80002df6:	86ee                	mv	a3,s11
    80002df8:	963e                	add	a2,a2,a5
    80002dfa:	85d6                	mv	a1,s5
    80002dfc:	8562                	mv	a0,s8
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	b00080e7          	jalr	-1280(ra) # 800018fe <either_copyout>
    80002e06:	05950d63          	beq	a0,s9,80002e60 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	60c080e7          	jalr	1548(ra) # 80002418 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e14:	013a09bb          	addw	s3,s4,s3
    80002e18:	009a04bb          	addw	s1,s4,s1
    80002e1c:	9aee                	add	s5,s5,s11
    80002e1e:	0569f763          	bgeu	s3,s6,80002e6c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e22:	000ba903          	lw	s2,0(s7)
    80002e26:	00a4d59b          	srliw	a1,s1,0xa
    80002e2a:	855e                	mv	a0,s7
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	8b0080e7          	jalr	-1872(ra) # 800026dc <bmap>
    80002e34:	0005059b          	sext.w	a1,a0
    80002e38:	854a                	mv	a0,s2
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	4ae080e7          	jalr	1198(ra) # 800022e8 <bread>
    80002e42:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e44:	3ff4f613          	andi	a2,s1,1023
    80002e48:	40cd07bb          	subw	a5,s10,a2
    80002e4c:	413b073b          	subw	a4,s6,s3
    80002e50:	8a3e                	mv	s4,a5
    80002e52:	2781                	sext.w	a5,a5
    80002e54:	0007069b          	sext.w	a3,a4
    80002e58:	f8f6f9e3          	bgeu	a3,a5,80002dea <readi+0x4c>
    80002e5c:	8a3a                	mv	s4,a4
    80002e5e:	b771                	j	80002dea <readi+0x4c>
      brelse(bp);
    80002e60:	854a                	mv	a0,s2
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	5b6080e7          	jalr	1462(ra) # 80002418 <brelse>
      tot = -1;
    80002e6a:	59fd                	li	s3,-1
  }
  return tot;
    80002e6c:	0009851b          	sext.w	a0,s3
}
    80002e70:	70a6                	ld	ra,104(sp)
    80002e72:	7406                	ld	s0,96(sp)
    80002e74:	64e6                	ld	s1,88(sp)
    80002e76:	6946                	ld	s2,80(sp)
    80002e78:	69a6                	ld	s3,72(sp)
    80002e7a:	6a06                	ld	s4,64(sp)
    80002e7c:	7ae2                	ld	s5,56(sp)
    80002e7e:	7b42                	ld	s6,48(sp)
    80002e80:	7ba2                	ld	s7,40(sp)
    80002e82:	7c02                	ld	s8,32(sp)
    80002e84:	6ce2                	ld	s9,24(sp)
    80002e86:	6d42                	ld	s10,16(sp)
    80002e88:	6da2                	ld	s11,8(sp)
    80002e8a:	6165                	addi	sp,sp,112
    80002e8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e8e:	89da                	mv	s3,s6
    80002e90:	bff1                	j	80002e6c <readi+0xce>
    return 0;
    80002e92:	4501                	li	a0,0
}
    80002e94:	8082                	ret

0000000080002e96 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e96:	457c                	lw	a5,76(a0)
    80002e98:	10d7e863          	bltu	a5,a3,80002fa8 <writei+0x112>
{
    80002e9c:	7159                	addi	sp,sp,-112
    80002e9e:	f486                	sd	ra,104(sp)
    80002ea0:	f0a2                	sd	s0,96(sp)
    80002ea2:	eca6                	sd	s1,88(sp)
    80002ea4:	e8ca                	sd	s2,80(sp)
    80002ea6:	e4ce                	sd	s3,72(sp)
    80002ea8:	e0d2                	sd	s4,64(sp)
    80002eaa:	fc56                	sd	s5,56(sp)
    80002eac:	f85a                	sd	s6,48(sp)
    80002eae:	f45e                	sd	s7,40(sp)
    80002eb0:	f062                	sd	s8,32(sp)
    80002eb2:	ec66                	sd	s9,24(sp)
    80002eb4:	e86a                	sd	s10,16(sp)
    80002eb6:	e46e                	sd	s11,8(sp)
    80002eb8:	1880                	addi	s0,sp,112
    80002eba:	8b2a                	mv	s6,a0
    80002ebc:	8c2e                	mv	s8,a1
    80002ebe:	8ab2                	mv	s5,a2
    80002ec0:	8936                	mv	s2,a3
    80002ec2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ec4:	00e687bb          	addw	a5,a3,a4
    80002ec8:	0ed7e263          	bltu	a5,a3,80002fac <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ecc:	00043737          	lui	a4,0x43
    80002ed0:	0ef76063          	bltu	a4,a5,80002fb0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed4:	0c0b8863          	beqz	s7,80002fa4 <writei+0x10e>
    80002ed8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eda:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ede:	5cfd                	li	s9,-1
    80002ee0:	a091                	j	80002f24 <writei+0x8e>
    80002ee2:	02099d93          	slli	s11,s3,0x20
    80002ee6:	020ddd93          	srli	s11,s11,0x20
    80002eea:	05848793          	addi	a5,s1,88
    80002eee:	86ee                	mv	a3,s11
    80002ef0:	8656                	mv	a2,s5
    80002ef2:	85e2                	mv	a1,s8
    80002ef4:	953e                	add	a0,a0,a5
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	a5e080e7          	jalr	-1442(ra) # 80001954 <either_copyin>
    80002efe:	07950263          	beq	a0,s9,80002f62 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f02:	8526                	mv	a0,s1
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	790080e7          	jalr	1936(ra) # 80003694 <log_write>
    brelse(bp);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	50a080e7          	jalr	1290(ra) # 80002418 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f16:	01498a3b          	addw	s4,s3,s4
    80002f1a:	0129893b          	addw	s2,s3,s2
    80002f1e:	9aee                	add	s5,s5,s11
    80002f20:	057a7663          	bgeu	s4,s7,80002f6c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f24:	000b2483          	lw	s1,0(s6)
    80002f28:	00a9559b          	srliw	a1,s2,0xa
    80002f2c:	855a                	mv	a0,s6
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	7ae080e7          	jalr	1966(ra) # 800026dc <bmap>
    80002f36:	0005059b          	sext.w	a1,a0
    80002f3a:	8526                	mv	a0,s1
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	3ac080e7          	jalr	940(ra) # 800022e8 <bread>
    80002f44:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f46:	3ff97513          	andi	a0,s2,1023
    80002f4a:	40ad07bb          	subw	a5,s10,a0
    80002f4e:	414b873b          	subw	a4,s7,s4
    80002f52:	89be                	mv	s3,a5
    80002f54:	2781                	sext.w	a5,a5
    80002f56:	0007069b          	sext.w	a3,a4
    80002f5a:	f8f6f4e3          	bgeu	a3,a5,80002ee2 <writei+0x4c>
    80002f5e:	89ba                	mv	s3,a4
    80002f60:	b749                	j	80002ee2 <writei+0x4c>
      brelse(bp);
    80002f62:	8526                	mv	a0,s1
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	4b4080e7          	jalr	1204(ra) # 80002418 <brelse>
  }

  if(off > ip->size)
    80002f6c:	04cb2783          	lw	a5,76(s6)
    80002f70:	0127f463          	bgeu	a5,s2,80002f78 <writei+0xe2>
    ip->size = off;
    80002f74:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f78:	855a                	mv	a0,s6
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	aa6080e7          	jalr	-1370(ra) # 80002a20 <iupdate>

  return tot;
    80002f82:	000a051b          	sext.w	a0,s4
}
    80002f86:	70a6                	ld	ra,104(sp)
    80002f88:	7406                	ld	s0,96(sp)
    80002f8a:	64e6                	ld	s1,88(sp)
    80002f8c:	6946                	ld	s2,80(sp)
    80002f8e:	69a6                	ld	s3,72(sp)
    80002f90:	6a06                	ld	s4,64(sp)
    80002f92:	7ae2                	ld	s5,56(sp)
    80002f94:	7b42                	ld	s6,48(sp)
    80002f96:	7ba2                	ld	s7,40(sp)
    80002f98:	7c02                	ld	s8,32(sp)
    80002f9a:	6ce2                	ld	s9,24(sp)
    80002f9c:	6d42                	ld	s10,16(sp)
    80002f9e:	6da2                	ld	s11,8(sp)
    80002fa0:	6165                	addi	sp,sp,112
    80002fa2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa4:	8a5e                	mv	s4,s7
    80002fa6:	bfc9                	j	80002f78 <writei+0xe2>
    return -1;
    80002fa8:	557d                	li	a0,-1
}
    80002faa:	8082                	ret
    return -1;
    80002fac:	557d                	li	a0,-1
    80002fae:	bfe1                	j	80002f86 <writei+0xf0>
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfd1                	j	80002f86 <writei+0xf0>

0000000080002fb4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb4:	1141                	addi	sp,sp,-16
    80002fb6:	e406                	sd	ra,8(sp)
    80002fb8:	e022                	sd	s0,0(sp)
    80002fba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fbc:	4639                	li	a2,14
    80002fbe:	ffffd097          	auipc	ra,0xffffd
    80002fc2:	28a080e7          	jalr	650(ra) # 80000248 <strncmp>
}
    80002fc6:	60a2                	ld	ra,8(sp)
    80002fc8:	6402                	ld	s0,0(sp)
    80002fca:	0141                	addi	sp,sp,16
    80002fcc:	8082                	ret

0000000080002fce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fce:	7139                	addi	sp,sp,-64
    80002fd0:	fc06                	sd	ra,56(sp)
    80002fd2:	f822                	sd	s0,48(sp)
    80002fd4:	f426                	sd	s1,40(sp)
    80002fd6:	f04a                	sd	s2,32(sp)
    80002fd8:	ec4e                	sd	s3,24(sp)
    80002fda:	e852                	sd	s4,16(sp)
    80002fdc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fde:	04451703          	lh	a4,68(a0)
    80002fe2:	4785                	li	a5,1
    80002fe4:	00f71a63          	bne	a4,a5,80002ff8 <dirlookup+0x2a>
    80002fe8:	892a                	mv	s2,a0
    80002fea:	89ae                	mv	s3,a1
    80002fec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fee:	457c                	lw	a5,76(a0)
    80002ff0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff4:	e79d                	bnez	a5,80003022 <dirlookup+0x54>
    80002ff6:	a8a5                	j	8000306e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ff8:	00006517          	auipc	a0,0x6
    80002ffc:	5c050513          	addi	a0,a0,1472 # 800095b8 <syscalls+0x1e0>
    80003000:	00004097          	auipc	ra,0x4
    80003004:	bca080e7          	jalr	-1078(ra) # 80006bca <panic>
      panic("dirlookup read");
    80003008:	00006517          	auipc	a0,0x6
    8000300c:	5c850513          	addi	a0,a0,1480 # 800095d0 <syscalls+0x1f8>
    80003010:	00004097          	auipc	ra,0x4
    80003014:	bba080e7          	jalr	-1094(ra) # 80006bca <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003018:	24c1                	addiw	s1,s1,16
    8000301a:	04c92783          	lw	a5,76(s2)
    8000301e:	04f4f763          	bgeu	s1,a5,8000306c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003022:	4741                	li	a4,16
    80003024:	86a6                	mv	a3,s1
    80003026:	fc040613          	addi	a2,s0,-64
    8000302a:	4581                	li	a1,0
    8000302c:	854a                	mv	a0,s2
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	d70080e7          	jalr	-656(ra) # 80002d9e <readi>
    80003036:	47c1                	li	a5,16
    80003038:	fcf518e3          	bne	a0,a5,80003008 <dirlookup+0x3a>
    if(de.inum == 0)
    8000303c:	fc045783          	lhu	a5,-64(s0)
    80003040:	dfe1                	beqz	a5,80003018 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003042:	fc240593          	addi	a1,s0,-62
    80003046:	854e                	mv	a0,s3
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	f6c080e7          	jalr	-148(ra) # 80002fb4 <namecmp>
    80003050:	f561                	bnez	a0,80003018 <dirlookup+0x4a>
      if(poff)
    80003052:	000a0463          	beqz	s4,8000305a <dirlookup+0x8c>
        *poff = off;
    80003056:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305a:	fc045583          	lhu	a1,-64(s0)
    8000305e:	00092503          	lw	a0,0(s2)
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	754080e7          	jalr	1876(ra) # 800027b6 <iget>
    8000306a:	a011                	j	8000306e <dirlookup+0xa0>
  return 0;
    8000306c:	4501                	li	a0,0
}
    8000306e:	70e2                	ld	ra,56(sp)
    80003070:	7442                	ld	s0,48(sp)
    80003072:	74a2                	ld	s1,40(sp)
    80003074:	7902                	ld	s2,32(sp)
    80003076:	69e2                	ld	s3,24(sp)
    80003078:	6a42                	ld	s4,16(sp)
    8000307a:	6121                	addi	sp,sp,64
    8000307c:	8082                	ret

000000008000307e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000307e:	711d                	addi	sp,sp,-96
    80003080:	ec86                	sd	ra,88(sp)
    80003082:	e8a2                	sd	s0,80(sp)
    80003084:	e4a6                	sd	s1,72(sp)
    80003086:	e0ca                	sd	s2,64(sp)
    80003088:	fc4e                	sd	s3,56(sp)
    8000308a:	f852                	sd	s4,48(sp)
    8000308c:	f456                	sd	s5,40(sp)
    8000308e:	f05a                	sd	s6,32(sp)
    80003090:	ec5e                	sd	s7,24(sp)
    80003092:	e862                	sd	s8,16(sp)
    80003094:	e466                	sd	s9,8(sp)
    80003096:	1080                	addi	s0,sp,96
    80003098:	84aa                	mv	s1,a0
    8000309a:	8aae                	mv	s5,a1
    8000309c:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000309e:	00054703          	lbu	a4,0(a0)
    800030a2:	02f00793          	li	a5,47
    800030a6:	02f70363          	beq	a4,a5,800030cc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030aa:	ffffe097          	auipc	ra,0xffffe
    800030ae:	df0080e7          	jalr	-528(ra) # 80000e9a <myproc>
    800030b2:	15053503          	ld	a0,336(a0)
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	9f6080e7          	jalr	-1546(ra) # 80002aac <idup>
    800030be:	89aa                	mv	s3,a0
  while(*path == '/')
    800030c0:	02f00913          	li	s2,47
  len = path - s;
    800030c4:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800030c6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030c8:	4b85                	li	s7,1
    800030ca:	a865                	j	80003182 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030cc:	4585                	li	a1,1
    800030ce:	4505                	li	a0,1
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	6e6080e7          	jalr	1766(ra) # 800027b6 <iget>
    800030d8:	89aa                	mv	s3,a0
    800030da:	b7dd                	j	800030c0 <namex+0x42>
      iunlockput(ip);
    800030dc:	854e                	mv	a0,s3
    800030de:	00000097          	auipc	ra,0x0
    800030e2:	c6e080e7          	jalr	-914(ra) # 80002d4c <iunlockput>
      return 0;
    800030e6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030e8:	854e                	mv	a0,s3
    800030ea:	60e6                	ld	ra,88(sp)
    800030ec:	6446                	ld	s0,80(sp)
    800030ee:	64a6                	ld	s1,72(sp)
    800030f0:	6906                	ld	s2,64(sp)
    800030f2:	79e2                	ld	s3,56(sp)
    800030f4:	7a42                	ld	s4,48(sp)
    800030f6:	7aa2                	ld	s5,40(sp)
    800030f8:	7b02                	ld	s6,32(sp)
    800030fa:	6be2                	ld	s7,24(sp)
    800030fc:	6c42                	ld	s8,16(sp)
    800030fe:	6ca2                	ld	s9,8(sp)
    80003100:	6125                	addi	sp,sp,96
    80003102:	8082                	ret
      iunlock(ip);
    80003104:	854e                	mv	a0,s3
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	aa6080e7          	jalr	-1370(ra) # 80002bac <iunlock>
      return ip;
    8000310e:	bfe9                	j	800030e8 <namex+0x6a>
      iunlockput(ip);
    80003110:	854e                	mv	a0,s3
    80003112:	00000097          	auipc	ra,0x0
    80003116:	c3a080e7          	jalr	-966(ra) # 80002d4c <iunlockput>
      return 0;
    8000311a:	89e6                	mv	s3,s9
    8000311c:	b7f1                	j	800030e8 <namex+0x6a>
  len = path - s;
    8000311e:	40b48633          	sub	a2,s1,a1
    80003122:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003126:	099c5463          	bge	s8,s9,800031ae <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000312a:	4639                	li	a2,14
    8000312c:	8552                	mv	a0,s4
    8000312e:	ffffd097          	auipc	ra,0xffffd
    80003132:	0a6080e7          	jalr	166(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003136:	0004c783          	lbu	a5,0(s1)
    8000313a:	01279763          	bne	a5,s2,80003148 <namex+0xca>
    path++;
    8000313e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003140:	0004c783          	lbu	a5,0(s1)
    80003144:	ff278de3          	beq	a5,s2,8000313e <namex+0xc0>
    ilock(ip);
    80003148:	854e                	mv	a0,s3
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	9a0080e7          	jalr	-1632(ra) # 80002aea <ilock>
    if(ip->type != T_DIR){
    80003152:	04499783          	lh	a5,68(s3)
    80003156:	f97793e3          	bne	a5,s7,800030dc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000315a:	000a8563          	beqz	s5,80003164 <namex+0xe6>
    8000315e:	0004c783          	lbu	a5,0(s1)
    80003162:	d3cd                	beqz	a5,80003104 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003164:	865a                	mv	a2,s6
    80003166:	85d2                	mv	a1,s4
    80003168:	854e                	mv	a0,s3
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	e64080e7          	jalr	-412(ra) # 80002fce <dirlookup>
    80003172:	8caa                	mv	s9,a0
    80003174:	dd51                	beqz	a0,80003110 <namex+0x92>
    iunlockput(ip);
    80003176:	854e                	mv	a0,s3
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	bd4080e7          	jalr	-1068(ra) # 80002d4c <iunlockput>
    ip = next;
    80003180:	89e6                	mv	s3,s9
  while(*path == '/')
    80003182:	0004c783          	lbu	a5,0(s1)
    80003186:	05279763          	bne	a5,s2,800031d4 <namex+0x156>
    path++;
    8000318a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000318c:	0004c783          	lbu	a5,0(s1)
    80003190:	ff278de3          	beq	a5,s2,8000318a <namex+0x10c>
  if(*path == 0)
    80003194:	c79d                	beqz	a5,800031c2 <namex+0x144>
    path++;
    80003196:	85a6                	mv	a1,s1
  len = path - s;
    80003198:	8cda                	mv	s9,s6
    8000319a:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000319c:	01278963          	beq	a5,s2,800031ae <namex+0x130>
    800031a0:	dfbd                	beqz	a5,8000311e <namex+0xa0>
    path++;
    800031a2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031a4:	0004c783          	lbu	a5,0(s1)
    800031a8:	ff279ce3          	bne	a5,s2,800031a0 <namex+0x122>
    800031ac:	bf8d                	j	8000311e <namex+0xa0>
    memmove(name, s, len);
    800031ae:	2601                	sext.w	a2,a2
    800031b0:	8552                	mv	a0,s4
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	022080e7          	jalr	34(ra) # 800001d4 <memmove>
    name[len] = 0;
    800031ba:	9cd2                	add	s9,s9,s4
    800031bc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031c0:	bf9d                	j	80003136 <namex+0xb8>
  if(nameiparent){
    800031c2:	f20a83e3          	beqz	s5,800030e8 <namex+0x6a>
    iput(ip);
    800031c6:	854e                	mv	a0,s3
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	adc080e7          	jalr	-1316(ra) # 80002ca4 <iput>
    return 0;
    800031d0:	4981                	li	s3,0
    800031d2:	bf19                	j	800030e8 <namex+0x6a>
  if(*path == 0)
    800031d4:	d7fd                	beqz	a5,800031c2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031d6:	0004c783          	lbu	a5,0(s1)
    800031da:	85a6                	mv	a1,s1
    800031dc:	b7d1                	j	800031a0 <namex+0x122>

00000000800031de <dirlink>:
{
    800031de:	7139                	addi	sp,sp,-64
    800031e0:	fc06                	sd	ra,56(sp)
    800031e2:	f822                	sd	s0,48(sp)
    800031e4:	f426                	sd	s1,40(sp)
    800031e6:	f04a                	sd	s2,32(sp)
    800031e8:	ec4e                	sd	s3,24(sp)
    800031ea:	e852                	sd	s4,16(sp)
    800031ec:	0080                	addi	s0,sp,64
    800031ee:	892a                	mv	s2,a0
    800031f0:	8a2e                	mv	s4,a1
    800031f2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f4:	4601                	li	a2,0
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	dd8080e7          	jalr	-552(ra) # 80002fce <dirlookup>
    800031fe:	e93d                	bnez	a0,80003274 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003200:	04c92483          	lw	s1,76(s2)
    80003204:	c49d                	beqz	s1,80003232 <dirlink+0x54>
    80003206:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003208:	4741                	li	a4,16
    8000320a:	86a6                	mv	a3,s1
    8000320c:	fc040613          	addi	a2,s0,-64
    80003210:	4581                	li	a1,0
    80003212:	854a                	mv	a0,s2
    80003214:	00000097          	auipc	ra,0x0
    80003218:	b8a080e7          	jalr	-1142(ra) # 80002d9e <readi>
    8000321c:	47c1                	li	a5,16
    8000321e:	06f51163          	bne	a0,a5,80003280 <dirlink+0xa2>
    if(de.inum == 0)
    80003222:	fc045783          	lhu	a5,-64(s0)
    80003226:	c791                	beqz	a5,80003232 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	24c1                	addiw	s1,s1,16
    8000322a:	04c92783          	lw	a5,76(s2)
    8000322e:	fcf4ede3          	bltu	s1,a5,80003208 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003232:	4639                	li	a2,14
    80003234:	85d2                	mv	a1,s4
    80003236:	fc240513          	addi	a0,s0,-62
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	04a080e7          	jalr	74(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003242:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003246:	4741                	li	a4,16
    80003248:	86a6                	mv	a3,s1
    8000324a:	fc040613          	addi	a2,s0,-64
    8000324e:	4581                	li	a1,0
    80003250:	854a                	mv	a0,s2
    80003252:	00000097          	auipc	ra,0x0
    80003256:	c44080e7          	jalr	-956(ra) # 80002e96 <writei>
    8000325a:	872a                	mv	a4,a0
    8000325c:	47c1                	li	a5,16
  return 0;
    8000325e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003260:	02f71863          	bne	a4,a5,80003290 <dirlink+0xb2>
}
    80003264:	70e2                	ld	ra,56(sp)
    80003266:	7442                	ld	s0,48(sp)
    80003268:	74a2                	ld	s1,40(sp)
    8000326a:	7902                	ld	s2,32(sp)
    8000326c:	69e2                	ld	s3,24(sp)
    8000326e:	6a42                	ld	s4,16(sp)
    80003270:	6121                	addi	sp,sp,64
    80003272:	8082                	ret
    iput(ip);
    80003274:	00000097          	auipc	ra,0x0
    80003278:	a30080e7          	jalr	-1488(ra) # 80002ca4 <iput>
    return -1;
    8000327c:	557d                	li	a0,-1
    8000327e:	b7dd                	j	80003264 <dirlink+0x86>
      panic("dirlink read");
    80003280:	00006517          	auipc	a0,0x6
    80003284:	36050513          	addi	a0,a0,864 # 800095e0 <syscalls+0x208>
    80003288:	00004097          	auipc	ra,0x4
    8000328c:	942080e7          	jalr	-1726(ra) # 80006bca <panic>
    panic("dirlink");
    80003290:	00006517          	auipc	a0,0x6
    80003294:	46050513          	addi	a0,a0,1120 # 800096f0 <syscalls+0x318>
    80003298:	00004097          	auipc	ra,0x4
    8000329c:	932080e7          	jalr	-1742(ra) # 80006bca <panic>

00000000800032a0 <namei>:

struct inode*
namei(char *path)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032a8:	fe040613          	addi	a2,s0,-32
    800032ac:	4581                	li	a1,0
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	dd0080e7          	jalr	-560(ra) # 8000307e <namex>
}
    800032b6:	60e2                	ld	ra,24(sp)
    800032b8:	6442                	ld	s0,16(sp)
    800032ba:	6105                	addi	sp,sp,32
    800032bc:	8082                	ret

00000000800032be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032be:	1141                	addi	sp,sp,-16
    800032c0:	e406                	sd	ra,8(sp)
    800032c2:	e022                	sd	s0,0(sp)
    800032c4:	0800                	addi	s0,sp,16
    800032c6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032c8:	4585                	li	a1,1
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	db4080e7          	jalr	-588(ra) # 8000307e <namex>
}
    800032d2:	60a2                	ld	ra,8(sp)
    800032d4:	6402                	ld	s0,0(sp)
    800032d6:	0141                	addi	sp,sp,16
    800032d8:	8082                	ret

00000000800032da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032da:	1101                	addi	sp,sp,-32
    800032dc:	ec06                	sd	ra,24(sp)
    800032de:	e822                	sd	s0,16(sp)
    800032e0:	e426                	sd	s1,8(sp)
    800032e2:	e04a                	sd	s2,0(sp)
    800032e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032e6:	00017917          	auipc	s2,0x17
    800032ea:	d5a90913          	addi	s2,s2,-678 # 8001a040 <log>
    800032ee:	01892583          	lw	a1,24(s2)
    800032f2:	02892503          	lw	a0,40(s2)
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	ff2080e7          	jalr	-14(ra) # 800022e8 <bread>
    800032fe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003300:	02c92683          	lw	a3,44(s2)
    80003304:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003306:	02d05763          	blez	a3,80003334 <write_head+0x5a>
    8000330a:	00017797          	auipc	a5,0x17
    8000330e:	d6678793          	addi	a5,a5,-666 # 8001a070 <log+0x30>
    80003312:	05c50713          	addi	a4,a0,92
    80003316:	36fd                	addiw	a3,a3,-1
    80003318:	1682                	slli	a3,a3,0x20
    8000331a:	9281                	srli	a3,a3,0x20
    8000331c:	068a                	slli	a3,a3,0x2
    8000331e:	00017617          	auipc	a2,0x17
    80003322:	d5660613          	addi	a2,a2,-682 # 8001a074 <log+0x34>
    80003326:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003328:	4390                	lw	a2,0(a5)
    8000332a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000332c:	0791                	addi	a5,a5,4
    8000332e:	0711                	addi	a4,a4,4
    80003330:	fed79ce3          	bne	a5,a3,80003328 <write_head+0x4e>
  }
  bwrite(buf);
    80003334:	8526                	mv	a0,s1
    80003336:	fffff097          	auipc	ra,0xfffff
    8000333a:	0a4080e7          	jalr	164(ra) # 800023da <bwrite>
  brelse(buf);
    8000333e:	8526                	mv	a0,s1
    80003340:	fffff097          	auipc	ra,0xfffff
    80003344:	0d8080e7          	jalr	216(ra) # 80002418 <brelse>
}
    80003348:	60e2                	ld	ra,24(sp)
    8000334a:	6442                	ld	s0,16(sp)
    8000334c:	64a2                	ld	s1,8(sp)
    8000334e:	6902                	ld	s2,0(sp)
    80003350:	6105                	addi	sp,sp,32
    80003352:	8082                	ret

0000000080003354 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003354:	00017797          	auipc	a5,0x17
    80003358:	d187a783          	lw	a5,-744(a5) # 8001a06c <log+0x2c>
    8000335c:	0af05d63          	blez	a5,80003416 <install_trans+0xc2>
{
    80003360:	7139                	addi	sp,sp,-64
    80003362:	fc06                	sd	ra,56(sp)
    80003364:	f822                	sd	s0,48(sp)
    80003366:	f426                	sd	s1,40(sp)
    80003368:	f04a                	sd	s2,32(sp)
    8000336a:	ec4e                	sd	s3,24(sp)
    8000336c:	e852                	sd	s4,16(sp)
    8000336e:	e456                	sd	s5,8(sp)
    80003370:	e05a                	sd	s6,0(sp)
    80003372:	0080                	addi	s0,sp,64
    80003374:	8b2a                	mv	s6,a0
    80003376:	00017a97          	auipc	s5,0x17
    8000337a:	cfaa8a93          	addi	s5,s5,-774 # 8001a070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003380:	00017997          	auipc	s3,0x17
    80003384:	cc098993          	addi	s3,s3,-832 # 8001a040 <log>
    80003388:	a00d                	j	800033aa <install_trans+0x56>
    brelse(lbuf);
    8000338a:	854a                	mv	a0,s2
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	08c080e7          	jalr	140(ra) # 80002418 <brelse>
    brelse(dbuf);
    80003394:	8526                	mv	a0,s1
    80003396:	fffff097          	auipc	ra,0xfffff
    8000339a:	082080e7          	jalr	130(ra) # 80002418 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000339e:	2a05                	addiw	s4,s4,1
    800033a0:	0a91                	addi	s5,s5,4
    800033a2:	02c9a783          	lw	a5,44(s3)
    800033a6:	04fa5e63          	bge	s4,a5,80003402 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033aa:	0189a583          	lw	a1,24(s3)
    800033ae:	014585bb          	addw	a1,a1,s4
    800033b2:	2585                	addiw	a1,a1,1
    800033b4:	0289a503          	lw	a0,40(s3)
    800033b8:	fffff097          	auipc	ra,0xfffff
    800033bc:	f30080e7          	jalr	-208(ra) # 800022e8 <bread>
    800033c0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033c2:	000aa583          	lw	a1,0(s5)
    800033c6:	0289a503          	lw	a0,40(s3)
    800033ca:	fffff097          	auipc	ra,0xfffff
    800033ce:	f1e080e7          	jalr	-226(ra) # 800022e8 <bread>
    800033d2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033d4:	40000613          	li	a2,1024
    800033d8:	05890593          	addi	a1,s2,88
    800033dc:	05850513          	addi	a0,a0,88
    800033e0:	ffffd097          	auipc	ra,0xffffd
    800033e4:	df4080e7          	jalr	-524(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e8:	8526                	mv	a0,s1
    800033ea:	fffff097          	auipc	ra,0xfffff
    800033ee:	ff0080e7          	jalr	-16(ra) # 800023da <bwrite>
    if(recovering == 0)
    800033f2:	f80b1ce3          	bnez	s6,8000338a <install_trans+0x36>
      bunpin(dbuf);
    800033f6:	8526                	mv	a0,s1
    800033f8:	fffff097          	auipc	ra,0xfffff
    800033fc:	0fa080e7          	jalr	250(ra) # 800024f2 <bunpin>
    80003400:	b769                	j	8000338a <install_trans+0x36>
}
    80003402:	70e2                	ld	ra,56(sp)
    80003404:	7442                	ld	s0,48(sp)
    80003406:	74a2                	ld	s1,40(sp)
    80003408:	7902                	ld	s2,32(sp)
    8000340a:	69e2                	ld	s3,24(sp)
    8000340c:	6a42                	ld	s4,16(sp)
    8000340e:	6aa2                	ld	s5,8(sp)
    80003410:	6b02                	ld	s6,0(sp)
    80003412:	6121                	addi	sp,sp,64
    80003414:	8082                	ret
    80003416:	8082                	ret

0000000080003418 <initlog>:
{
    80003418:	7179                	addi	sp,sp,-48
    8000341a:	f406                	sd	ra,40(sp)
    8000341c:	f022                	sd	s0,32(sp)
    8000341e:	ec26                	sd	s1,24(sp)
    80003420:	e84a                	sd	s2,16(sp)
    80003422:	e44e                	sd	s3,8(sp)
    80003424:	1800                	addi	s0,sp,48
    80003426:	892a                	mv	s2,a0
    80003428:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000342a:	00017497          	auipc	s1,0x17
    8000342e:	c1648493          	addi	s1,s1,-1002 # 8001a040 <log>
    80003432:	00006597          	auipc	a1,0x6
    80003436:	1be58593          	addi	a1,a1,446 # 800095f0 <syscalls+0x218>
    8000343a:	8526                	mv	a0,s1
    8000343c:	00004097          	auipc	ra,0x4
    80003440:	c3a080e7          	jalr	-966(ra) # 80007076 <initlock>
  log.start = sb->logstart;
    80003444:	0149a583          	lw	a1,20(s3)
    80003448:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000344a:	0109a783          	lw	a5,16(s3)
    8000344e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003450:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003454:	854a                	mv	a0,s2
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	e92080e7          	jalr	-366(ra) # 800022e8 <bread>
  log.lh.n = lh->n;
    8000345e:	4d34                	lw	a3,88(a0)
    80003460:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003462:	02d05563          	blez	a3,8000348c <initlog+0x74>
    80003466:	05c50793          	addi	a5,a0,92
    8000346a:	00017717          	auipc	a4,0x17
    8000346e:	c0670713          	addi	a4,a4,-1018 # 8001a070 <log+0x30>
    80003472:	36fd                	addiw	a3,a3,-1
    80003474:	1682                	slli	a3,a3,0x20
    80003476:	9281                	srli	a3,a3,0x20
    80003478:	068a                	slli	a3,a3,0x2
    8000347a:	06050613          	addi	a2,a0,96
    8000347e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003480:	4390                	lw	a2,0(a5)
    80003482:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003484:	0791                	addi	a5,a5,4
    80003486:	0711                	addi	a4,a4,4
    80003488:	fed79ce3          	bne	a5,a3,80003480 <initlog+0x68>
  brelse(buf);
    8000348c:	fffff097          	auipc	ra,0xfffff
    80003490:	f8c080e7          	jalr	-116(ra) # 80002418 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003494:	4505                	li	a0,1
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	ebe080e7          	jalr	-322(ra) # 80003354 <install_trans>
  log.lh.n = 0;
    8000349e:	00017797          	auipc	a5,0x17
    800034a2:	bc07a723          	sw	zero,-1074(a5) # 8001a06c <log+0x2c>
  write_head(); // clear the log
    800034a6:	00000097          	auipc	ra,0x0
    800034aa:	e34080e7          	jalr	-460(ra) # 800032da <write_head>
}
    800034ae:	70a2                	ld	ra,40(sp)
    800034b0:	7402                	ld	s0,32(sp)
    800034b2:	64e2                	ld	s1,24(sp)
    800034b4:	6942                	ld	s2,16(sp)
    800034b6:	69a2                	ld	s3,8(sp)
    800034b8:	6145                	addi	sp,sp,48
    800034ba:	8082                	ret

00000000800034bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034bc:	1101                	addi	sp,sp,-32
    800034be:	ec06                	sd	ra,24(sp)
    800034c0:	e822                	sd	s0,16(sp)
    800034c2:	e426                	sd	s1,8(sp)
    800034c4:	e04a                	sd	s2,0(sp)
    800034c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034c8:	00017517          	auipc	a0,0x17
    800034cc:	b7850513          	addi	a0,a0,-1160 # 8001a040 <log>
    800034d0:	00004097          	auipc	ra,0x4
    800034d4:	c36080e7          	jalr	-970(ra) # 80007106 <acquire>
  while(1){
    if(log.committing){
    800034d8:	00017497          	auipc	s1,0x17
    800034dc:	b6848493          	addi	s1,s1,-1176 # 8001a040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e0:	4979                	li	s2,30
    800034e2:	a039                	j	800034f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034e4:	85a6                	mv	a1,s1
    800034e6:	8526                	mv	a0,s1
    800034e8:	ffffe097          	auipc	ra,0xffffe
    800034ec:	072080e7          	jalr	114(ra) # 8000155a <sleep>
    if(log.committing){
    800034f0:	50dc                	lw	a5,36(s1)
    800034f2:	fbed                	bnez	a5,800034e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f4:	509c                	lw	a5,32(s1)
    800034f6:	0017871b          	addiw	a4,a5,1
    800034fa:	0007069b          	sext.w	a3,a4
    800034fe:	0027179b          	slliw	a5,a4,0x2
    80003502:	9fb9                	addw	a5,a5,a4
    80003504:	0017979b          	slliw	a5,a5,0x1
    80003508:	54d8                	lw	a4,44(s1)
    8000350a:	9fb9                	addw	a5,a5,a4
    8000350c:	00f95963          	bge	s2,a5,8000351e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003510:	85a6                	mv	a1,s1
    80003512:	8526                	mv	a0,s1
    80003514:	ffffe097          	auipc	ra,0xffffe
    80003518:	046080e7          	jalr	70(ra) # 8000155a <sleep>
    8000351c:	bfd1                	j	800034f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000351e:	00017517          	auipc	a0,0x17
    80003522:	b2250513          	addi	a0,a0,-1246 # 8001a040 <log>
    80003526:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003528:	00004097          	auipc	ra,0x4
    8000352c:	c92080e7          	jalr	-878(ra) # 800071ba <release>
      break;
    }
  }
}
    80003530:	60e2                	ld	ra,24(sp)
    80003532:	6442                	ld	s0,16(sp)
    80003534:	64a2                	ld	s1,8(sp)
    80003536:	6902                	ld	s2,0(sp)
    80003538:	6105                	addi	sp,sp,32
    8000353a:	8082                	ret

000000008000353c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000353c:	7139                	addi	sp,sp,-64
    8000353e:	fc06                	sd	ra,56(sp)
    80003540:	f822                	sd	s0,48(sp)
    80003542:	f426                	sd	s1,40(sp)
    80003544:	f04a                	sd	s2,32(sp)
    80003546:	ec4e                	sd	s3,24(sp)
    80003548:	e852                	sd	s4,16(sp)
    8000354a:	e456                	sd	s5,8(sp)
    8000354c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000354e:	00017497          	auipc	s1,0x17
    80003552:	af248493          	addi	s1,s1,-1294 # 8001a040 <log>
    80003556:	8526                	mv	a0,s1
    80003558:	00004097          	auipc	ra,0x4
    8000355c:	bae080e7          	jalr	-1106(ra) # 80007106 <acquire>
  log.outstanding -= 1;
    80003560:	509c                	lw	a5,32(s1)
    80003562:	37fd                	addiw	a5,a5,-1
    80003564:	0007891b          	sext.w	s2,a5
    80003568:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000356a:	50dc                	lw	a5,36(s1)
    8000356c:	e7b9                	bnez	a5,800035ba <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000356e:	04091e63          	bnez	s2,800035ca <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003572:	00017497          	auipc	s1,0x17
    80003576:	ace48493          	addi	s1,s1,-1330 # 8001a040 <log>
    8000357a:	4785                	li	a5,1
    8000357c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000357e:	8526                	mv	a0,s1
    80003580:	00004097          	auipc	ra,0x4
    80003584:	c3a080e7          	jalr	-966(ra) # 800071ba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003588:	54dc                	lw	a5,44(s1)
    8000358a:	06f04763          	bgtz	a5,800035f8 <end_op+0xbc>
    acquire(&log.lock);
    8000358e:	00017497          	auipc	s1,0x17
    80003592:	ab248493          	addi	s1,s1,-1358 # 8001a040 <log>
    80003596:	8526                	mv	a0,s1
    80003598:	00004097          	auipc	ra,0x4
    8000359c:	b6e080e7          	jalr	-1170(ra) # 80007106 <acquire>
    log.committing = 0;
    800035a0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035a4:	8526                	mv	a0,s1
    800035a6:	ffffe097          	auipc	ra,0xffffe
    800035aa:	140080e7          	jalr	320(ra) # 800016e6 <wakeup>
    release(&log.lock);
    800035ae:	8526                	mv	a0,s1
    800035b0:	00004097          	auipc	ra,0x4
    800035b4:	c0a080e7          	jalr	-1014(ra) # 800071ba <release>
}
    800035b8:	a03d                	j	800035e6 <end_op+0xaa>
    panic("log.committing");
    800035ba:	00006517          	auipc	a0,0x6
    800035be:	03e50513          	addi	a0,a0,62 # 800095f8 <syscalls+0x220>
    800035c2:	00003097          	auipc	ra,0x3
    800035c6:	608080e7          	jalr	1544(ra) # 80006bca <panic>
    wakeup(&log);
    800035ca:	00017497          	auipc	s1,0x17
    800035ce:	a7648493          	addi	s1,s1,-1418 # 8001a040 <log>
    800035d2:	8526                	mv	a0,s1
    800035d4:	ffffe097          	auipc	ra,0xffffe
    800035d8:	112080e7          	jalr	274(ra) # 800016e6 <wakeup>
  release(&log.lock);
    800035dc:	8526                	mv	a0,s1
    800035de:	00004097          	auipc	ra,0x4
    800035e2:	bdc080e7          	jalr	-1060(ra) # 800071ba <release>
}
    800035e6:	70e2                	ld	ra,56(sp)
    800035e8:	7442                	ld	s0,48(sp)
    800035ea:	74a2                	ld	s1,40(sp)
    800035ec:	7902                	ld	s2,32(sp)
    800035ee:	69e2                	ld	s3,24(sp)
    800035f0:	6a42                	ld	s4,16(sp)
    800035f2:	6aa2                	ld	s5,8(sp)
    800035f4:	6121                	addi	sp,sp,64
    800035f6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f8:	00017a97          	auipc	s5,0x17
    800035fc:	a78a8a93          	addi	s5,s5,-1416 # 8001a070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003600:	00017a17          	auipc	s4,0x17
    80003604:	a40a0a13          	addi	s4,s4,-1472 # 8001a040 <log>
    80003608:	018a2583          	lw	a1,24(s4)
    8000360c:	012585bb          	addw	a1,a1,s2
    80003610:	2585                	addiw	a1,a1,1
    80003612:	028a2503          	lw	a0,40(s4)
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	cd2080e7          	jalr	-814(ra) # 800022e8 <bread>
    8000361e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003620:	000aa583          	lw	a1,0(s5)
    80003624:	028a2503          	lw	a0,40(s4)
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	cc0080e7          	jalr	-832(ra) # 800022e8 <bread>
    80003630:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003632:	40000613          	li	a2,1024
    80003636:	05850593          	addi	a1,a0,88
    8000363a:	05848513          	addi	a0,s1,88
    8000363e:	ffffd097          	auipc	ra,0xffffd
    80003642:	b96080e7          	jalr	-1130(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003646:	8526                	mv	a0,s1
    80003648:	fffff097          	auipc	ra,0xfffff
    8000364c:	d92080e7          	jalr	-622(ra) # 800023da <bwrite>
    brelse(from);
    80003650:	854e                	mv	a0,s3
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	dc6080e7          	jalr	-570(ra) # 80002418 <brelse>
    brelse(to);
    8000365a:	8526                	mv	a0,s1
    8000365c:	fffff097          	auipc	ra,0xfffff
    80003660:	dbc080e7          	jalr	-580(ra) # 80002418 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003664:	2905                	addiw	s2,s2,1
    80003666:	0a91                	addi	s5,s5,4
    80003668:	02ca2783          	lw	a5,44(s4)
    8000366c:	f8f94ee3          	blt	s2,a5,80003608 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003670:	00000097          	auipc	ra,0x0
    80003674:	c6a080e7          	jalr	-918(ra) # 800032da <write_head>
    install_trans(0); // Now install writes to home locations
    80003678:	4501                	li	a0,0
    8000367a:	00000097          	auipc	ra,0x0
    8000367e:	cda080e7          	jalr	-806(ra) # 80003354 <install_trans>
    log.lh.n = 0;
    80003682:	00017797          	auipc	a5,0x17
    80003686:	9e07a523          	sw	zero,-1558(a5) # 8001a06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000368a:	00000097          	auipc	ra,0x0
    8000368e:	c50080e7          	jalr	-944(ra) # 800032da <write_head>
    80003692:	bdf5                	j	8000358e <end_op+0x52>

0000000080003694 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003694:	1101                	addi	sp,sp,-32
    80003696:	ec06                	sd	ra,24(sp)
    80003698:	e822                	sd	s0,16(sp)
    8000369a:	e426                	sd	s1,8(sp)
    8000369c:	e04a                	sd	s2,0(sp)
    8000369e:	1000                	addi	s0,sp,32
    800036a0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036a2:	00017917          	auipc	s2,0x17
    800036a6:	99e90913          	addi	s2,s2,-1634 # 8001a040 <log>
    800036aa:	854a                	mv	a0,s2
    800036ac:	00004097          	auipc	ra,0x4
    800036b0:	a5a080e7          	jalr	-1446(ra) # 80007106 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036b4:	02c92603          	lw	a2,44(s2)
    800036b8:	47f5                	li	a5,29
    800036ba:	06c7c563          	blt	a5,a2,80003724 <log_write+0x90>
    800036be:	00017797          	auipc	a5,0x17
    800036c2:	99e7a783          	lw	a5,-1634(a5) # 8001a05c <log+0x1c>
    800036c6:	37fd                	addiw	a5,a5,-1
    800036c8:	04f65e63          	bge	a2,a5,80003724 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036cc:	00017797          	auipc	a5,0x17
    800036d0:	9947a783          	lw	a5,-1644(a5) # 8001a060 <log+0x20>
    800036d4:	06f05063          	blez	a5,80003734 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036d8:	4781                	li	a5,0
    800036da:	06c05563          	blez	a2,80003744 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036de:	44cc                	lw	a1,12(s1)
    800036e0:	00017717          	auipc	a4,0x17
    800036e4:	99070713          	addi	a4,a4,-1648 # 8001a070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036e8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ea:	4314                	lw	a3,0(a4)
    800036ec:	04b68c63          	beq	a3,a1,80003744 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036f0:	2785                	addiw	a5,a5,1
    800036f2:	0711                	addi	a4,a4,4
    800036f4:	fef61be3          	bne	a2,a5,800036ea <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036f8:	0621                	addi	a2,a2,8
    800036fa:	060a                	slli	a2,a2,0x2
    800036fc:	00017797          	auipc	a5,0x17
    80003700:	94478793          	addi	a5,a5,-1724 # 8001a040 <log>
    80003704:	963e                	add	a2,a2,a5
    80003706:	44dc                	lw	a5,12(s1)
    80003708:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000370a:	8526                	mv	a0,s1
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	daa080e7          	jalr	-598(ra) # 800024b6 <bpin>
    log.lh.n++;
    80003714:	00017717          	auipc	a4,0x17
    80003718:	92c70713          	addi	a4,a4,-1748 # 8001a040 <log>
    8000371c:	575c                	lw	a5,44(a4)
    8000371e:	2785                	addiw	a5,a5,1
    80003720:	d75c                	sw	a5,44(a4)
    80003722:	a835                	j	8000375e <log_write+0xca>
    panic("too big a transaction");
    80003724:	00006517          	auipc	a0,0x6
    80003728:	ee450513          	addi	a0,a0,-284 # 80009608 <syscalls+0x230>
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	49e080e7          	jalr	1182(ra) # 80006bca <panic>
    panic("log_write outside of trans");
    80003734:	00006517          	auipc	a0,0x6
    80003738:	eec50513          	addi	a0,a0,-276 # 80009620 <syscalls+0x248>
    8000373c:	00003097          	auipc	ra,0x3
    80003740:	48e080e7          	jalr	1166(ra) # 80006bca <panic>
  log.lh.block[i] = b->blockno;
    80003744:	00878713          	addi	a4,a5,8
    80003748:	00271693          	slli	a3,a4,0x2
    8000374c:	00017717          	auipc	a4,0x17
    80003750:	8f470713          	addi	a4,a4,-1804 # 8001a040 <log>
    80003754:	9736                	add	a4,a4,a3
    80003756:	44d4                	lw	a3,12(s1)
    80003758:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000375a:	faf608e3          	beq	a2,a5,8000370a <log_write+0x76>
  }
  release(&log.lock);
    8000375e:	00017517          	auipc	a0,0x17
    80003762:	8e250513          	addi	a0,a0,-1822 # 8001a040 <log>
    80003766:	00004097          	auipc	ra,0x4
    8000376a:	a54080e7          	jalr	-1452(ra) # 800071ba <release>
}
    8000376e:	60e2                	ld	ra,24(sp)
    80003770:	6442                	ld	s0,16(sp)
    80003772:	64a2                	ld	s1,8(sp)
    80003774:	6902                	ld	s2,0(sp)
    80003776:	6105                	addi	sp,sp,32
    80003778:	8082                	ret

000000008000377a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000377a:	1101                	addi	sp,sp,-32
    8000377c:	ec06                	sd	ra,24(sp)
    8000377e:	e822                	sd	s0,16(sp)
    80003780:	e426                	sd	s1,8(sp)
    80003782:	e04a                	sd	s2,0(sp)
    80003784:	1000                	addi	s0,sp,32
    80003786:	84aa                	mv	s1,a0
    80003788:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000378a:	00006597          	auipc	a1,0x6
    8000378e:	eb658593          	addi	a1,a1,-330 # 80009640 <syscalls+0x268>
    80003792:	0521                	addi	a0,a0,8
    80003794:	00004097          	auipc	ra,0x4
    80003798:	8e2080e7          	jalr	-1822(ra) # 80007076 <initlock>
  lk->name = name;
    8000379c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037a4:	0204a423          	sw	zero,40(s1)
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6902                	ld	s2,0(sp)
    800037b0:	6105                	addi	sp,sp,32
    800037b2:	8082                	ret

00000000800037b4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037b4:	1101                	addi	sp,sp,-32
    800037b6:	ec06                	sd	ra,24(sp)
    800037b8:	e822                	sd	s0,16(sp)
    800037ba:	e426                	sd	s1,8(sp)
    800037bc:	e04a                	sd	s2,0(sp)
    800037be:	1000                	addi	s0,sp,32
    800037c0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037c2:	00850913          	addi	s2,a0,8
    800037c6:	854a                	mv	a0,s2
    800037c8:	00004097          	auipc	ra,0x4
    800037cc:	93e080e7          	jalr	-1730(ra) # 80007106 <acquire>
  while (lk->locked) {
    800037d0:	409c                	lw	a5,0(s1)
    800037d2:	cb89                	beqz	a5,800037e4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037d4:	85ca                	mv	a1,s2
    800037d6:	8526                	mv	a0,s1
    800037d8:	ffffe097          	auipc	ra,0xffffe
    800037dc:	d82080e7          	jalr	-638(ra) # 8000155a <sleep>
  while (lk->locked) {
    800037e0:	409c                	lw	a5,0(s1)
    800037e2:	fbed                	bnez	a5,800037d4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037e4:	4785                	li	a5,1
    800037e6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	6b2080e7          	jalr	1714(ra) # 80000e9a <myproc>
    800037f0:	591c                	lw	a5,48(a0)
    800037f2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037f4:	854a                	mv	a0,s2
    800037f6:	00004097          	auipc	ra,0x4
    800037fa:	9c4080e7          	jalr	-1596(ra) # 800071ba <release>
}
    800037fe:	60e2                	ld	ra,24(sp)
    80003800:	6442                	ld	s0,16(sp)
    80003802:	64a2                	ld	s1,8(sp)
    80003804:	6902                	ld	s2,0(sp)
    80003806:	6105                	addi	sp,sp,32
    80003808:	8082                	ret

000000008000380a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000380a:	1101                	addi	sp,sp,-32
    8000380c:	ec06                	sd	ra,24(sp)
    8000380e:	e822                	sd	s0,16(sp)
    80003810:	e426                	sd	s1,8(sp)
    80003812:	e04a                	sd	s2,0(sp)
    80003814:	1000                	addi	s0,sp,32
    80003816:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003818:	00850913          	addi	s2,a0,8
    8000381c:	854a                	mv	a0,s2
    8000381e:	00004097          	auipc	ra,0x4
    80003822:	8e8080e7          	jalr	-1816(ra) # 80007106 <acquire>
  lk->locked = 0;
    80003826:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000382a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000382e:	8526                	mv	a0,s1
    80003830:	ffffe097          	auipc	ra,0xffffe
    80003834:	eb6080e7          	jalr	-330(ra) # 800016e6 <wakeup>
  release(&lk->lk);
    80003838:	854a                	mv	a0,s2
    8000383a:	00004097          	auipc	ra,0x4
    8000383e:	980080e7          	jalr	-1664(ra) # 800071ba <release>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6902                	ld	s2,0(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret

000000008000384e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000384e:	7179                	addi	sp,sp,-48
    80003850:	f406                	sd	ra,40(sp)
    80003852:	f022                	sd	s0,32(sp)
    80003854:	ec26                	sd	s1,24(sp)
    80003856:	e84a                	sd	s2,16(sp)
    80003858:	e44e                	sd	s3,8(sp)
    8000385a:	1800                	addi	s0,sp,48
    8000385c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000385e:	00850913          	addi	s2,a0,8
    80003862:	854a                	mv	a0,s2
    80003864:	00004097          	auipc	ra,0x4
    80003868:	8a2080e7          	jalr	-1886(ra) # 80007106 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000386c:	409c                	lw	a5,0(s1)
    8000386e:	ef99                	bnez	a5,8000388c <holdingsleep+0x3e>
    80003870:	4481                	li	s1,0
  release(&lk->lk);
    80003872:	854a                	mv	a0,s2
    80003874:	00004097          	auipc	ra,0x4
    80003878:	946080e7          	jalr	-1722(ra) # 800071ba <release>
  return r;
}
    8000387c:	8526                	mv	a0,s1
    8000387e:	70a2                	ld	ra,40(sp)
    80003880:	7402                	ld	s0,32(sp)
    80003882:	64e2                	ld	s1,24(sp)
    80003884:	6942                	ld	s2,16(sp)
    80003886:	69a2                	ld	s3,8(sp)
    80003888:	6145                	addi	sp,sp,48
    8000388a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000388c:	0284a983          	lw	s3,40(s1)
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	60a080e7          	jalr	1546(ra) # 80000e9a <myproc>
    80003898:	5904                	lw	s1,48(a0)
    8000389a:	413484b3          	sub	s1,s1,s3
    8000389e:	0014b493          	seqz	s1,s1
    800038a2:	bfc1                	j	80003872 <holdingsleep+0x24>

00000000800038a4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038a4:	1141                	addi	sp,sp,-16
    800038a6:	e406                	sd	ra,8(sp)
    800038a8:	e022                	sd	s0,0(sp)
    800038aa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038ac:	00006597          	auipc	a1,0x6
    800038b0:	da458593          	addi	a1,a1,-604 # 80009650 <syscalls+0x278>
    800038b4:	00017517          	auipc	a0,0x17
    800038b8:	8d450513          	addi	a0,a0,-1836 # 8001a188 <ftable>
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	7ba080e7          	jalr	1978(ra) # 80007076 <initlock>
}
    800038c4:	60a2                	ld	ra,8(sp)
    800038c6:	6402                	ld	s0,0(sp)
    800038c8:	0141                	addi	sp,sp,16
    800038ca:	8082                	ret

00000000800038cc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	e426                	sd	s1,8(sp)
    800038d4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038d6:	00017517          	auipc	a0,0x17
    800038da:	8b250513          	addi	a0,a0,-1870 # 8001a188 <ftable>
    800038de:	00004097          	auipc	ra,0x4
    800038e2:	828080e7          	jalr	-2008(ra) # 80007106 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e6:	00017497          	auipc	s1,0x17
    800038ea:	8ba48493          	addi	s1,s1,-1862 # 8001a1a0 <ftable+0x18>
    800038ee:	00018717          	auipc	a4,0x18
    800038f2:	b7270713          	addi	a4,a4,-1166 # 8001b460 <ftable+0x12d8>
    if(f->ref == 0){
    800038f6:	40dc                	lw	a5,4(s1)
    800038f8:	cf99                	beqz	a5,80003916 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038fa:	03048493          	addi	s1,s1,48
    800038fe:	fee49ce3          	bne	s1,a4,800038f6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003902:	00017517          	auipc	a0,0x17
    80003906:	88650513          	addi	a0,a0,-1914 # 8001a188 <ftable>
    8000390a:	00004097          	auipc	ra,0x4
    8000390e:	8b0080e7          	jalr	-1872(ra) # 800071ba <release>
  return 0;
    80003912:	4481                	li	s1,0
    80003914:	a819                	j	8000392a <filealloc+0x5e>
      f->ref = 1;
    80003916:	4785                	li	a5,1
    80003918:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000391a:	00017517          	auipc	a0,0x17
    8000391e:	86e50513          	addi	a0,a0,-1938 # 8001a188 <ftable>
    80003922:	00004097          	auipc	ra,0x4
    80003926:	898080e7          	jalr	-1896(ra) # 800071ba <release>
}
    8000392a:	8526                	mv	a0,s1
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6105                	addi	sp,sp,32
    80003934:	8082                	ret

0000000080003936 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003936:	1101                	addi	sp,sp,-32
    80003938:	ec06                	sd	ra,24(sp)
    8000393a:	e822                	sd	s0,16(sp)
    8000393c:	e426                	sd	s1,8(sp)
    8000393e:	1000                	addi	s0,sp,32
    80003940:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003942:	00017517          	auipc	a0,0x17
    80003946:	84650513          	addi	a0,a0,-1978 # 8001a188 <ftable>
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	7bc080e7          	jalr	1980(ra) # 80007106 <acquire>
  if(f->ref < 1)
    80003952:	40dc                	lw	a5,4(s1)
    80003954:	02f05263          	blez	a5,80003978 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003958:	2785                	addiw	a5,a5,1
    8000395a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000395c:	00017517          	auipc	a0,0x17
    80003960:	82c50513          	addi	a0,a0,-2004 # 8001a188 <ftable>
    80003964:	00004097          	auipc	ra,0x4
    80003968:	856080e7          	jalr	-1962(ra) # 800071ba <release>
  return f;
}
    8000396c:	8526                	mv	a0,s1
    8000396e:	60e2                	ld	ra,24(sp)
    80003970:	6442                	ld	s0,16(sp)
    80003972:	64a2                	ld	s1,8(sp)
    80003974:	6105                	addi	sp,sp,32
    80003976:	8082                	ret
    panic("filedup");
    80003978:	00006517          	auipc	a0,0x6
    8000397c:	ce050513          	addi	a0,a0,-800 # 80009658 <syscalls+0x280>
    80003980:	00003097          	auipc	ra,0x3
    80003984:	24a080e7          	jalr	586(ra) # 80006bca <panic>

0000000080003988 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003988:	7139                	addi	sp,sp,-64
    8000398a:	fc06                	sd	ra,56(sp)
    8000398c:	f822                	sd	s0,48(sp)
    8000398e:	f426                	sd	s1,40(sp)
    80003990:	f04a                	sd	s2,32(sp)
    80003992:	ec4e                	sd	s3,24(sp)
    80003994:	e852                	sd	s4,16(sp)
    80003996:	e456                	sd	s5,8(sp)
    80003998:	e05a                	sd	s6,0(sp)
    8000399a:	0080                	addi	s0,sp,64
    8000399c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000399e:	00016517          	auipc	a0,0x16
    800039a2:	7ea50513          	addi	a0,a0,2026 # 8001a188 <ftable>
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	760080e7          	jalr	1888(ra) # 80007106 <acquire>
  if(f->ref < 1)
    800039ae:	40dc                	lw	a5,4(s1)
    800039b0:	04f05f63          	blez	a5,80003a0e <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039b4:	37fd                	addiw	a5,a5,-1
    800039b6:	0007871b          	sext.w	a4,a5
    800039ba:	c0dc                	sw	a5,4(s1)
    800039bc:	06e04163          	bgtz	a4,80003a1e <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039c0:	0004a903          	lw	s2,0(s1)
    800039c4:	0094ca83          	lbu	s5,9(s1)
    800039c8:	0104ba03          	ld	s4,16(s1)
    800039cc:	0184b983          	ld	s3,24(s1)
    800039d0:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    800039d4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039d8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039dc:	00016517          	auipc	a0,0x16
    800039e0:	7ac50513          	addi	a0,a0,1964 # 8001a188 <ftable>
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	7d6080e7          	jalr	2006(ra) # 800071ba <release>

  if(ff.type == FD_PIPE){
    800039ec:	4785                	li	a5,1
    800039ee:	04f90a63          	beq	s2,a5,80003a42 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039f2:	ffe9079b          	addiw	a5,s2,-2
    800039f6:	4705                	li	a4,1
    800039f8:	04f77c63          	bgeu	a4,a5,80003a50 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    800039fc:	4791                	li	a5,4
    800039fe:	02f91863          	bne	s2,a5,80003a2e <fileclose+0xa6>
    sockclose(ff.sock);
    80003a02:	855a                	mv	a0,s6
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	962080e7          	jalr	-1694(ra) # 80006366 <sockclose>
    80003a0c:	a00d                	j	80003a2e <fileclose+0xa6>
    panic("fileclose");
    80003a0e:	00006517          	auipc	a0,0x6
    80003a12:	c5250513          	addi	a0,a0,-942 # 80009660 <syscalls+0x288>
    80003a16:	00003097          	auipc	ra,0x3
    80003a1a:	1b4080e7          	jalr	436(ra) # 80006bca <panic>
    release(&ftable.lock);
    80003a1e:	00016517          	auipc	a0,0x16
    80003a22:	76a50513          	addi	a0,a0,1898 # 8001a188 <ftable>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	794080e7          	jalr	1940(ra) # 800071ba <release>
  }
#endif
}
    80003a2e:	70e2                	ld	ra,56(sp)
    80003a30:	7442                	ld	s0,48(sp)
    80003a32:	74a2                	ld	s1,40(sp)
    80003a34:	7902                	ld	s2,32(sp)
    80003a36:	69e2                	ld	s3,24(sp)
    80003a38:	6a42                	ld	s4,16(sp)
    80003a3a:	6aa2                	ld	s5,8(sp)
    80003a3c:	6b02                	ld	s6,0(sp)
    80003a3e:	6121                	addi	sp,sp,64
    80003a40:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a42:	85d6                	mv	a1,s5
    80003a44:	8552                	mv	a0,s4
    80003a46:	00000097          	auipc	ra,0x0
    80003a4a:	37c080e7          	jalr	892(ra) # 80003dc2 <pipeclose>
    80003a4e:	b7c5                	j	80003a2e <fileclose+0xa6>
    begin_op();
    80003a50:	00000097          	auipc	ra,0x0
    80003a54:	a6c080e7          	jalr	-1428(ra) # 800034bc <begin_op>
    iput(ff.ip);
    80003a58:	854e                	mv	a0,s3
    80003a5a:	fffff097          	auipc	ra,0xfffff
    80003a5e:	24a080e7          	jalr	586(ra) # 80002ca4 <iput>
    end_op();
    80003a62:	00000097          	auipc	ra,0x0
    80003a66:	ada080e7          	jalr	-1318(ra) # 8000353c <end_op>
    80003a6a:	b7d1                	j	80003a2e <fileclose+0xa6>

0000000080003a6c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a6c:	715d                	addi	sp,sp,-80
    80003a6e:	e486                	sd	ra,72(sp)
    80003a70:	e0a2                	sd	s0,64(sp)
    80003a72:	fc26                	sd	s1,56(sp)
    80003a74:	f84a                	sd	s2,48(sp)
    80003a76:	f44e                	sd	s3,40(sp)
    80003a78:	0880                	addi	s0,sp,80
    80003a7a:	84aa                	mv	s1,a0
    80003a7c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a7e:	ffffd097          	auipc	ra,0xffffd
    80003a82:	41c080e7          	jalr	1052(ra) # 80000e9a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a86:	409c                	lw	a5,0(s1)
    80003a88:	37f9                	addiw	a5,a5,-2
    80003a8a:	4705                	li	a4,1
    80003a8c:	04f76763          	bltu	a4,a5,80003ada <filestat+0x6e>
    80003a90:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a92:	6c88                	ld	a0,24(s1)
    80003a94:	fffff097          	auipc	ra,0xfffff
    80003a98:	056080e7          	jalr	86(ra) # 80002aea <ilock>
    stati(f->ip, &st);
    80003a9c:	fb840593          	addi	a1,s0,-72
    80003aa0:	6c88                	ld	a0,24(s1)
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	2d2080e7          	jalr	722(ra) # 80002d74 <stati>
    iunlock(f->ip);
    80003aaa:	6c88                	ld	a0,24(s1)
    80003aac:	fffff097          	auipc	ra,0xfffff
    80003ab0:	100080e7          	jalr	256(ra) # 80002bac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ab4:	46e1                	li	a3,24
    80003ab6:	fb840613          	addi	a2,s0,-72
    80003aba:	85ce                	mv	a1,s3
    80003abc:	05093503          	ld	a0,80(s2)
    80003ac0:	ffffd097          	auipc	ra,0xffffd
    80003ac4:	09e080e7          	jalr	158(ra) # 80000b5e <copyout>
    80003ac8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003acc:	60a6                	ld	ra,72(sp)
    80003ace:	6406                	ld	s0,64(sp)
    80003ad0:	74e2                	ld	s1,56(sp)
    80003ad2:	7942                	ld	s2,48(sp)
    80003ad4:	79a2                	ld	s3,40(sp)
    80003ad6:	6161                	addi	sp,sp,80
    80003ad8:	8082                	ret
  return -1;
    80003ada:	557d                	li	a0,-1
    80003adc:	bfc5                	j	80003acc <filestat+0x60>

0000000080003ade <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ade:	7179                	addi	sp,sp,-48
    80003ae0:	f406                	sd	ra,40(sp)
    80003ae2:	f022                	sd	s0,32(sp)
    80003ae4:	ec26                	sd	s1,24(sp)
    80003ae6:	e84a                	sd	s2,16(sp)
    80003ae8:	e44e                	sd	s3,8(sp)
    80003aea:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aec:	00854783          	lbu	a5,8(a0)
    80003af0:	cfc5                	beqz	a5,80003ba8 <fileread+0xca>
    80003af2:	84aa                	mv	s1,a0
    80003af4:	89ae                	mv	s3,a1
    80003af6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003af8:	411c                	lw	a5,0(a0)
    80003afa:	4705                	li	a4,1
    80003afc:	02e78963          	beq	a5,a4,80003b2e <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b00:	470d                	li	a4,3
    80003b02:	02e78d63          	beq	a5,a4,80003b3c <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b06:	4709                	li	a4,2
    80003b08:	04e78e63          	beq	a5,a4,80003b64 <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b0c:	4711                	li	a4,4
    80003b0e:	08e79563          	bne	a5,a4,80003b98 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b12:	7108                	ld	a0,32(a0)
    80003b14:	00003097          	auipc	ra,0x3
    80003b18:	8e2080e7          	jalr	-1822(ra) # 800063f6 <sockread>
    80003b1c:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b1e:	854a                	mv	a0,s2
    80003b20:	70a2                	ld	ra,40(sp)
    80003b22:	7402                	ld	s0,32(sp)
    80003b24:	64e2                	ld	s1,24(sp)
    80003b26:	6942                	ld	s2,16(sp)
    80003b28:	69a2                	ld	s3,8(sp)
    80003b2a:	6145                	addi	sp,sp,48
    80003b2c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b2e:	6908                	ld	a0,16(a0)
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	3f4080e7          	jalr	1012(ra) # 80003f24 <piperead>
    80003b38:	892a                	mv	s2,a0
    80003b3a:	b7d5                	j	80003b1e <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b3c:	02c51783          	lh	a5,44(a0)
    80003b40:	03079693          	slli	a3,a5,0x30
    80003b44:	92c1                	srli	a3,a3,0x30
    80003b46:	4725                	li	a4,9
    80003b48:	06d76263          	bltu	a4,a3,80003bac <fileread+0xce>
    80003b4c:	0792                	slli	a5,a5,0x4
    80003b4e:	00016717          	auipc	a4,0x16
    80003b52:	59a70713          	addi	a4,a4,1434 # 8001a0e8 <devsw>
    80003b56:	97ba                	add	a5,a5,a4
    80003b58:	639c                	ld	a5,0(a5)
    80003b5a:	cbb9                	beqz	a5,80003bb0 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003b5c:	4505                	li	a0,1
    80003b5e:	9782                	jalr	a5
    80003b60:	892a                	mv	s2,a0
    80003b62:	bf75                	j	80003b1e <fileread+0x40>
    ilock(f->ip);
    80003b64:	6d08                	ld	a0,24(a0)
    80003b66:	fffff097          	auipc	ra,0xfffff
    80003b6a:	f84080e7          	jalr	-124(ra) # 80002aea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b6e:	874a                	mv	a4,s2
    80003b70:	5494                	lw	a3,40(s1)
    80003b72:	864e                	mv	a2,s3
    80003b74:	4585                	li	a1,1
    80003b76:	6c88                	ld	a0,24(s1)
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	226080e7          	jalr	550(ra) # 80002d9e <readi>
    80003b80:	892a                	mv	s2,a0
    80003b82:	00a05563          	blez	a0,80003b8c <fileread+0xae>
      f->off += r;
    80003b86:	549c                	lw	a5,40(s1)
    80003b88:	9fa9                	addw	a5,a5,a0
    80003b8a:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003b8c:	6c88                	ld	a0,24(s1)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	01e080e7          	jalr	30(ra) # 80002bac <iunlock>
    80003b96:	b761                	j	80003b1e <fileread+0x40>
    panic("fileread");
    80003b98:	00006517          	auipc	a0,0x6
    80003b9c:	ad850513          	addi	a0,a0,-1320 # 80009670 <syscalls+0x298>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	02a080e7          	jalr	42(ra) # 80006bca <panic>
    return -1;
    80003ba8:	597d                	li	s2,-1
    80003baa:	bf95                	j	80003b1e <fileread+0x40>
      return -1;
    80003bac:	597d                	li	s2,-1
    80003bae:	bf85                	j	80003b1e <fileread+0x40>
    80003bb0:	597d                	li	s2,-1
    80003bb2:	b7b5                	j	80003b1e <fileread+0x40>

0000000080003bb4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bb4:	00954783          	lbu	a5,9(a0)
    80003bb8:	12078263          	beqz	a5,80003cdc <filewrite+0x128>
{
    80003bbc:	715d                	addi	sp,sp,-80
    80003bbe:	e486                	sd	ra,72(sp)
    80003bc0:	e0a2                	sd	s0,64(sp)
    80003bc2:	fc26                	sd	s1,56(sp)
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	f44e                	sd	s3,40(sp)
    80003bc8:	f052                	sd	s4,32(sp)
    80003bca:	ec56                	sd	s5,24(sp)
    80003bcc:	e85a                	sd	s6,16(sp)
    80003bce:	e45e                	sd	s7,8(sp)
    80003bd0:	e062                	sd	s8,0(sp)
    80003bd2:	0880                	addi	s0,sp,80
    80003bd4:	84aa                	mv	s1,a0
    80003bd6:	8aae                	mv	s5,a1
    80003bd8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bda:	411c                	lw	a5,0(a0)
    80003bdc:	4705                	li	a4,1
    80003bde:	02e78c63          	beq	a5,a4,80003c16 <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be2:	470d                	li	a4,3
    80003be4:	02e78f63          	beq	a5,a4,80003c22 <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be8:	4709                	li	a4,2
    80003bea:	04e78f63          	beq	a5,a4,80003c48 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003bee:	4711                	li	a4,4
    80003bf0:	0ce79e63          	bne	a5,a4,80003ccc <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003bf4:	7108                	ld	a0,32(a0)
    80003bf6:	00003097          	auipc	ra,0x3
    80003bfa:	8d0080e7          	jalr	-1840(ra) # 800064c6 <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003bfe:	60a6                	ld	ra,72(sp)
    80003c00:	6406                	ld	s0,64(sp)
    80003c02:	74e2                	ld	s1,56(sp)
    80003c04:	7942                	ld	s2,48(sp)
    80003c06:	79a2                	ld	s3,40(sp)
    80003c08:	7a02                	ld	s4,32(sp)
    80003c0a:	6ae2                	ld	s5,24(sp)
    80003c0c:	6b42                	ld	s6,16(sp)
    80003c0e:	6ba2                	ld	s7,8(sp)
    80003c10:	6c02                	ld	s8,0(sp)
    80003c12:	6161                	addi	sp,sp,80
    80003c14:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c16:	6908                	ld	a0,16(a0)
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	21a080e7          	jalr	538(ra) # 80003e32 <pipewrite>
    80003c20:	bff9                	j	80003bfe <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c22:	02c51783          	lh	a5,44(a0)
    80003c26:	03079693          	slli	a3,a5,0x30
    80003c2a:	92c1                	srli	a3,a3,0x30
    80003c2c:	4725                	li	a4,9
    80003c2e:	0ad76963          	bltu	a4,a3,80003ce0 <filewrite+0x12c>
    80003c32:	0792                	slli	a5,a5,0x4
    80003c34:	00016717          	auipc	a4,0x16
    80003c38:	4b470713          	addi	a4,a4,1204 # 8001a0e8 <devsw>
    80003c3c:	97ba                	add	a5,a5,a4
    80003c3e:	679c                	ld	a5,8(a5)
    80003c40:	c3d5                	beqz	a5,80003ce4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c42:	4505                	li	a0,1
    80003c44:	9782                	jalr	a5
    80003c46:	bf65                	j	80003bfe <filewrite+0x4a>
    while(i < n){
    80003c48:	06c05c63          	blez	a2,80003cc0 <filewrite+0x10c>
    int i = 0;
    80003c4c:	4981                	li	s3,0
    80003c4e:	6b05                	lui	s6,0x1
    80003c50:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c54:	6b85                	lui	s7,0x1
    80003c56:	c00b8b9b          	addiw	s7,s7,-1024
    80003c5a:	a899                	j	80003cb0 <filewrite+0xfc>
    80003c5c:	00090c1b          	sext.w	s8,s2
      begin_op();
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	85c080e7          	jalr	-1956(ra) # 800034bc <begin_op>
      ilock(f->ip);
    80003c68:	6c88                	ld	a0,24(s1)
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	e80080e7          	jalr	-384(ra) # 80002aea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c72:	8762                	mv	a4,s8
    80003c74:	5494                	lw	a3,40(s1)
    80003c76:	01598633          	add	a2,s3,s5
    80003c7a:	4585                	li	a1,1
    80003c7c:	6c88                	ld	a0,24(s1)
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	218080e7          	jalr	536(ra) # 80002e96 <writei>
    80003c86:	892a                	mv	s2,a0
    80003c88:	00a05563          	blez	a0,80003c92 <filewrite+0xde>
        f->off += r;
    80003c8c:	549c                	lw	a5,40(s1)
    80003c8e:	9fa9                	addw	a5,a5,a0
    80003c90:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003c92:	6c88                	ld	a0,24(s1)
    80003c94:	fffff097          	auipc	ra,0xfffff
    80003c98:	f18080e7          	jalr	-232(ra) # 80002bac <iunlock>
      end_op();
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	8a0080e7          	jalr	-1888(ra) # 8000353c <end_op>
      if(r != n1){
    80003ca4:	012c1f63          	bne	s8,s2,80003cc2 <filewrite+0x10e>
      i += r;
    80003ca8:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003cac:	0149db63          	bge	s3,s4,80003cc2 <filewrite+0x10e>
      int n1 = n - i;
    80003cb0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cb4:	893e                	mv	s2,a5
    80003cb6:	2781                	sext.w	a5,a5
    80003cb8:	fafb52e3          	bge	s6,a5,80003c5c <filewrite+0xa8>
    80003cbc:	895e                	mv	s2,s7
    80003cbe:	bf79                	j	80003c5c <filewrite+0xa8>
    int i = 0;
    80003cc0:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003cc2:	8552                	mv	a0,s4
    80003cc4:	f33a0de3          	beq	s4,s3,80003bfe <filewrite+0x4a>
    80003cc8:	557d                	li	a0,-1
    80003cca:	bf15                	j	80003bfe <filewrite+0x4a>
    panic("filewrite");
    80003ccc:	00006517          	auipc	a0,0x6
    80003cd0:	9b450513          	addi	a0,a0,-1612 # 80009680 <syscalls+0x2a8>
    80003cd4:	00003097          	auipc	ra,0x3
    80003cd8:	ef6080e7          	jalr	-266(ra) # 80006bca <panic>
    return -1;
    80003cdc:	557d                	li	a0,-1
}
    80003cde:	8082                	ret
      return -1;
    80003ce0:	557d                	li	a0,-1
    80003ce2:	bf31                	j	80003bfe <filewrite+0x4a>
    80003ce4:	557d                	li	a0,-1
    80003ce6:	bf21                	j	80003bfe <filewrite+0x4a>

0000000080003ce8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ce8:	7179                	addi	sp,sp,-48
    80003cea:	f406                	sd	ra,40(sp)
    80003cec:	f022                	sd	s0,32(sp)
    80003cee:	ec26                	sd	s1,24(sp)
    80003cf0:	e84a                	sd	s2,16(sp)
    80003cf2:	e44e                	sd	s3,8(sp)
    80003cf4:	e052                	sd	s4,0(sp)
    80003cf6:	1800                	addi	s0,sp,48
    80003cf8:	84aa                	mv	s1,a0
    80003cfa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cfc:	0005b023          	sd	zero,0(a1)
    80003d00:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	bc8080e7          	jalr	-1080(ra) # 800038cc <filealloc>
    80003d0c:	e088                	sd	a0,0(s1)
    80003d0e:	c551                	beqz	a0,80003d9a <pipealloc+0xb2>
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	bbc080e7          	jalr	-1092(ra) # 800038cc <filealloc>
    80003d18:	00aa3023          	sd	a0,0(s4)
    80003d1c:	c92d                	beqz	a0,80003d8e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d1e:	ffffc097          	auipc	ra,0xffffc
    80003d22:	3fa080e7          	jalr	1018(ra) # 80000118 <kalloc>
    80003d26:	892a                	mv	s2,a0
    80003d28:	c125                	beqz	a0,80003d88 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d2a:	4985                	li	s3,1
    80003d2c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d30:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d34:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d38:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d3c:	00006597          	auipc	a1,0x6
    80003d40:	95458593          	addi	a1,a1,-1708 # 80009690 <syscalls+0x2b8>
    80003d44:	00003097          	auipc	ra,0x3
    80003d48:	332080e7          	jalr	818(ra) # 80007076 <initlock>
  (*f0)->type = FD_PIPE;
    80003d4c:	609c                	ld	a5,0(s1)
    80003d4e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d52:	609c                	ld	a5,0(s1)
    80003d54:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d58:	609c                	ld	a5,0(s1)
    80003d5a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d5e:	609c                	ld	a5,0(s1)
    80003d60:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d64:	000a3783          	ld	a5,0(s4)
    80003d68:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d6c:	000a3783          	ld	a5,0(s4)
    80003d70:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d74:	000a3783          	ld	a5,0(s4)
    80003d78:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d7c:	000a3783          	ld	a5,0(s4)
    80003d80:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d84:	4501                	li	a0,0
    80003d86:	a025                	j	80003dae <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d88:	6088                	ld	a0,0(s1)
    80003d8a:	e501                	bnez	a0,80003d92 <pipealloc+0xaa>
    80003d8c:	a039                	j	80003d9a <pipealloc+0xb2>
    80003d8e:	6088                	ld	a0,0(s1)
    80003d90:	c51d                	beqz	a0,80003dbe <pipealloc+0xd6>
    fileclose(*f0);
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	bf6080e7          	jalr	-1034(ra) # 80003988 <fileclose>
  if(*f1)
    80003d9a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d9e:	557d                	li	a0,-1
  if(*f1)
    80003da0:	c799                	beqz	a5,80003dae <pipealloc+0xc6>
    fileclose(*f1);
    80003da2:	853e                	mv	a0,a5
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	be4080e7          	jalr	-1052(ra) # 80003988 <fileclose>
  return -1;
    80003dac:	557d                	li	a0,-1
}
    80003dae:	70a2                	ld	ra,40(sp)
    80003db0:	7402                	ld	s0,32(sp)
    80003db2:	64e2                	ld	s1,24(sp)
    80003db4:	6942                	ld	s2,16(sp)
    80003db6:	69a2                	ld	s3,8(sp)
    80003db8:	6a02                	ld	s4,0(sp)
    80003dba:	6145                	addi	sp,sp,48
    80003dbc:	8082                	ret
  return -1;
    80003dbe:	557d                	li	a0,-1
    80003dc0:	b7fd                	j	80003dae <pipealloc+0xc6>

0000000080003dc2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dc2:	1101                	addi	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	addi	s0,sp,32
    80003dce:	84aa                	mv	s1,a0
    80003dd0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003dd2:	00003097          	auipc	ra,0x3
    80003dd6:	334080e7          	jalr	820(ra) # 80007106 <acquire>
  if(writable){
    80003dda:	02090d63          	beqz	s2,80003e14 <pipeclose+0x52>
    pi->writeopen = 0;
    80003dde:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003de2:	21848513          	addi	a0,s1,536
    80003de6:	ffffe097          	auipc	ra,0xffffe
    80003dea:	900080e7          	jalr	-1792(ra) # 800016e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dee:	2204b783          	ld	a5,544(s1)
    80003df2:	eb95                	bnez	a5,80003e26 <pipeclose+0x64>
    release(&pi->lock);
    80003df4:	8526                	mv	a0,s1
    80003df6:	00003097          	auipc	ra,0x3
    80003dfa:	3c4080e7          	jalr	964(ra) # 800071ba <release>
    kfree((char*)pi);
    80003dfe:	8526                	mv	a0,s1
    80003e00:	ffffc097          	auipc	ra,0xffffc
    80003e04:	21c080e7          	jalr	540(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e08:	60e2                	ld	ra,24(sp)
    80003e0a:	6442                	ld	s0,16(sp)
    80003e0c:	64a2                	ld	s1,8(sp)
    80003e0e:	6902                	ld	s2,0(sp)
    80003e10:	6105                	addi	sp,sp,32
    80003e12:	8082                	ret
    pi->readopen = 0;
    80003e14:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e18:	21c48513          	addi	a0,s1,540
    80003e1c:	ffffe097          	auipc	ra,0xffffe
    80003e20:	8ca080e7          	jalr	-1846(ra) # 800016e6 <wakeup>
    80003e24:	b7e9                	j	80003dee <pipeclose+0x2c>
    release(&pi->lock);
    80003e26:	8526                	mv	a0,s1
    80003e28:	00003097          	auipc	ra,0x3
    80003e2c:	392080e7          	jalr	914(ra) # 800071ba <release>
}
    80003e30:	bfe1                	j	80003e08 <pipeclose+0x46>

0000000080003e32 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e32:	711d                	addi	sp,sp,-96
    80003e34:	ec86                	sd	ra,88(sp)
    80003e36:	e8a2                	sd	s0,80(sp)
    80003e38:	e4a6                	sd	s1,72(sp)
    80003e3a:	e0ca                	sd	s2,64(sp)
    80003e3c:	fc4e                	sd	s3,56(sp)
    80003e3e:	f852                	sd	s4,48(sp)
    80003e40:	f456                	sd	s5,40(sp)
    80003e42:	f05a                	sd	s6,32(sp)
    80003e44:	ec5e                	sd	s7,24(sp)
    80003e46:	e862                	sd	s8,16(sp)
    80003e48:	1080                	addi	s0,sp,96
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	8aae                	mv	s5,a1
    80003e4e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e50:	ffffd097          	auipc	ra,0xffffd
    80003e54:	04a080e7          	jalr	74(ra) # 80000e9a <myproc>
    80003e58:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e5a:	8526                	mv	a0,s1
    80003e5c:	00003097          	auipc	ra,0x3
    80003e60:	2aa080e7          	jalr	682(ra) # 80007106 <acquire>
  while(i < n){
    80003e64:	0b405363          	blez	s4,80003f0a <pipewrite+0xd8>
  int i = 0;
    80003e68:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e6a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e6c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e70:	21c48b93          	addi	s7,s1,540
    80003e74:	a089                	j	80003eb6 <pipewrite+0x84>
      release(&pi->lock);
    80003e76:	8526                	mv	a0,s1
    80003e78:	00003097          	auipc	ra,0x3
    80003e7c:	342080e7          	jalr	834(ra) # 800071ba <release>
      return -1;
    80003e80:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e82:	854a                	mv	a0,s2
    80003e84:	60e6                	ld	ra,88(sp)
    80003e86:	6446                	ld	s0,80(sp)
    80003e88:	64a6                	ld	s1,72(sp)
    80003e8a:	6906                	ld	s2,64(sp)
    80003e8c:	79e2                	ld	s3,56(sp)
    80003e8e:	7a42                	ld	s4,48(sp)
    80003e90:	7aa2                	ld	s5,40(sp)
    80003e92:	7b02                	ld	s6,32(sp)
    80003e94:	6be2                	ld	s7,24(sp)
    80003e96:	6c42                	ld	s8,16(sp)
    80003e98:	6125                	addi	sp,sp,96
    80003e9a:	8082                	ret
      wakeup(&pi->nread);
    80003e9c:	8562                	mv	a0,s8
    80003e9e:	ffffe097          	auipc	ra,0xffffe
    80003ea2:	848080e7          	jalr	-1976(ra) # 800016e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ea6:	85a6                	mv	a1,s1
    80003ea8:	855e                	mv	a0,s7
    80003eaa:	ffffd097          	auipc	ra,0xffffd
    80003eae:	6b0080e7          	jalr	1712(ra) # 8000155a <sleep>
  while(i < n){
    80003eb2:	05495d63          	bge	s2,s4,80003f0c <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003eb6:	2204a783          	lw	a5,544(s1)
    80003eba:	dfd5                	beqz	a5,80003e76 <pipewrite+0x44>
    80003ebc:	0289a783          	lw	a5,40(s3)
    80003ec0:	fbdd                	bnez	a5,80003e76 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ec2:	2184a783          	lw	a5,536(s1)
    80003ec6:	21c4a703          	lw	a4,540(s1)
    80003eca:	2007879b          	addiw	a5,a5,512
    80003ece:	fcf707e3          	beq	a4,a5,80003e9c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ed2:	4685                	li	a3,1
    80003ed4:	01590633          	add	a2,s2,s5
    80003ed8:	faf40593          	addi	a1,s0,-81
    80003edc:	0509b503          	ld	a0,80(s3)
    80003ee0:	ffffd097          	auipc	ra,0xffffd
    80003ee4:	d0a080e7          	jalr	-758(ra) # 80000bea <copyin>
    80003ee8:	03650263          	beq	a0,s6,80003f0c <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eec:	21c4a783          	lw	a5,540(s1)
    80003ef0:	0017871b          	addiw	a4,a5,1
    80003ef4:	20e4ae23          	sw	a4,540(s1)
    80003ef8:	1ff7f793          	andi	a5,a5,511
    80003efc:	97a6                	add	a5,a5,s1
    80003efe:	faf44703          	lbu	a4,-81(s0)
    80003f02:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f06:	2905                	addiw	s2,s2,1
    80003f08:	b76d                	j	80003eb2 <pipewrite+0x80>
  int i = 0;
    80003f0a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f0c:	21848513          	addi	a0,s1,536
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	7d6080e7          	jalr	2006(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    80003f18:	8526                	mv	a0,s1
    80003f1a:	00003097          	auipc	ra,0x3
    80003f1e:	2a0080e7          	jalr	672(ra) # 800071ba <release>
  return i;
    80003f22:	b785                	j	80003e82 <pipewrite+0x50>

0000000080003f24 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f24:	715d                	addi	sp,sp,-80
    80003f26:	e486                	sd	ra,72(sp)
    80003f28:	e0a2                	sd	s0,64(sp)
    80003f2a:	fc26                	sd	s1,56(sp)
    80003f2c:	f84a                	sd	s2,48(sp)
    80003f2e:	f44e                	sd	s3,40(sp)
    80003f30:	f052                	sd	s4,32(sp)
    80003f32:	ec56                	sd	s5,24(sp)
    80003f34:	e85a                	sd	s6,16(sp)
    80003f36:	0880                	addi	s0,sp,80
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	892e                	mv	s2,a1
    80003f3c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	f5c080e7          	jalr	-164(ra) # 80000e9a <myproc>
    80003f46:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00003097          	auipc	ra,0x3
    80003f4e:	1bc080e7          	jalr	444(ra) # 80007106 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f52:	2184a703          	lw	a4,536(s1)
    80003f56:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f5a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f5e:	02f71463          	bne	a4,a5,80003f86 <piperead+0x62>
    80003f62:	2244a783          	lw	a5,548(s1)
    80003f66:	c385                	beqz	a5,80003f86 <piperead+0x62>
    if(pr->killed){
    80003f68:	028a2783          	lw	a5,40(s4)
    80003f6c:	ebc1                	bnez	a5,80003ffc <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f6e:	85a6                	mv	a1,s1
    80003f70:	854e                	mv	a0,s3
    80003f72:	ffffd097          	auipc	ra,0xffffd
    80003f76:	5e8080e7          	jalr	1512(ra) # 8000155a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f7a:	2184a703          	lw	a4,536(s1)
    80003f7e:	21c4a783          	lw	a5,540(s1)
    80003f82:	fef700e3          	beq	a4,a5,80003f62 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f86:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f88:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f8a:	05505363          	blez	s5,80003fd0 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80003f8e:	2184a783          	lw	a5,536(s1)
    80003f92:	21c4a703          	lw	a4,540(s1)
    80003f96:	02f70d63          	beq	a4,a5,80003fd0 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f9a:	0017871b          	addiw	a4,a5,1
    80003f9e:	20e4ac23          	sw	a4,536(s1)
    80003fa2:	1ff7f793          	andi	a5,a5,511
    80003fa6:	97a6                	add	a5,a5,s1
    80003fa8:	0187c783          	lbu	a5,24(a5)
    80003fac:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fb0:	4685                	li	a3,1
    80003fb2:	fbf40613          	addi	a2,s0,-65
    80003fb6:	85ca                	mv	a1,s2
    80003fb8:	050a3503          	ld	a0,80(s4)
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	ba2080e7          	jalr	-1118(ra) # 80000b5e <copyout>
    80003fc4:	01650663          	beq	a0,s6,80003fd0 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fc8:	2985                	addiw	s3,s3,1
    80003fca:	0905                	addi	s2,s2,1
    80003fcc:	fd3a91e3          	bne	s5,s3,80003f8e <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fd0:	21c48513          	addi	a0,s1,540
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	712080e7          	jalr	1810(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	00003097          	auipc	ra,0x3
    80003fe2:	1dc080e7          	jalr	476(ra) # 800071ba <release>
  return i;
}
    80003fe6:	854e                	mv	a0,s3
    80003fe8:	60a6                	ld	ra,72(sp)
    80003fea:	6406                	ld	s0,64(sp)
    80003fec:	74e2                	ld	s1,56(sp)
    80003fee:	7942                	ld	s2,48(sp)
    80003ff0:	79a2                	ld	s3,40(sp)
    80003ff2:	7a02                	ld	s4,32(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6b42                	ld	s6,16(sp)
    80003ff8:	6161                	addi	sp,sp,80
    80003ffa:	8082                	ret
      release(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00003097          	auipc	ra,0x3
    80004002:	1bc080e7          	jalr	444(ra) # 800071ba <release>
      return -1;
    80004006:	59fd                	li	s3,-1
    80004008:	bff9                	j	80003fe6 <piperead+0xc2>

000000008000400a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000400a:	de010113          	addi	sp,sp,-544
    8000400e:	20113c23          	sd	ra,536(sp)
    80004012:	20813823          	sd	s0,528(sp)
    80004016:	20913423          	sd	s1,520(sp)
    8000401a:	21213023          	sd	s2,512(sp)
    8000401e:	ffce                	sd	s3,504(sp)
    80004020:	fbd2                	sd	s4,496(sp)
    80004022:	f7d6                	sd	s5,488(sp)
    80004024:	f3da                	sd	s6,480(sp)
    80004026:	efde                	sd	s7,472(sp)
    80004028:	ebe2                	sd	s8,464(sp)
    8000402a:	e7e6                	sd	s9,456(sp)
    8000402c:	e3ea                	sd	s10,448(sp)
    8000402e:	ff6e                	sd	s11,440(sp)
    80004030:	1400                	addi	s0,sp,544
    80004032:	892a                	mv	s2,a0
    80004034:	dea43423          	sd	a0,-536(s0)
    80004038:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	e5e080e7          	jalr	-418(ra) # 80000e9a <myproc>
    80004044:	84aa                	mv	s1,a0

  begin_op();
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	476080e7          	jalr	1142(ra) # 800034bc <begin_op>

  if((ip = namei(path)) == 0){
    8000404e:	854a                	mv	a0,s2
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	250080e7          	jalr	592(ra) # 800032a0 <namei>
    80004058:	c93d                	beqz	a0,800040ce <exec+0xc4>
    8000405a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000405c:	fffff097          	auipc	ra,0xfffff
    80004060:	a8e080e7          	jalr	-1394(ra) # 80002aea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004064:	04000713          	li	a4,64
    80004068:	4681                	li	a3,0
    8000406a:	e5040613          	addi	a2,s0,-432
    8000406e:	4581                	li	a1,0
    80004070:	8556                	mv	a0,s5
    80004072:	fffff097          	auipc	ra,0xfffff
    80004076:	d2c080e7          	jalr	-724(ra) # 80002d9e <readi>
    8000407a:	04000793          	li	a5,64
    8000407e:	00f51a63          	bne	a0,a5,80004092 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004082:	e5042703          	lw	a4,-432(s0)
    80004086:	464c47b7          	lui	a5,0x464c4
    8000408a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000408e:	04f70663          	beq	a4,a5,800040da <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004092:	8556                	mv	a0,s5
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	cb8080e7          	jalr	-840(ra) # 80002d4c <iunlockput>
    end_op();
    8000409c:	fffff097          	auipc	ra,0xfffff
    800040a0:	4a0080e7          	jalr	1184(ra) # 8000353c <end_op>
  }
  return -1;
    800040a4:	557d                	li	a0,-1
}
    800040a6:	21813083          	ld	ra,536(sp)
    800040aa:	21013403          	ld	s0,528(sp)
    800040ae:	20813483          	ld	s1,520(sp)
    800040b2:	20013903          	ld	s2,512(sp)
    800040b6:	79fe                	ld	s3,504(sp)
    800040b8:	7a5e                	ld	s4,496(sp)
    800040ba:	7abe                	ld	s5,488(sp)
    800040bc:	7b1e                	ld	s6,480(sp)
    800040be:	6bfe                	ld	s7,472(sp)
    800040c0:	6c5e                	ld	s8,464(sp)
    800040c2:	6cbe                	ld	s9,456(sp)
    800040c4:	6d1e                	ld	s10,448(sp)
    800040c6:	7dfa                	ld	s11,440(sp)
    800040c8:	22010113          	addi	sp,sp,544
    800040cc:	8082                	ret
    end_op();
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	46e080e7          	jalr	1134(ra) # 8000353c <end_op>
    return -1;
    800040d6:	557d                	li	a0,-1
    800040d8:	b7f9                	j	800040a6 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040da:	8526                	mv	a0,s1
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	e82080e7          	jalr	-382(ra) # 80000f5e <proc_pagetable>
    800040e4:	8b2a                	mv	s6,a0
    800040e6:	d555                	beqz	a0,80004092 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040e8:	e7042783          	lw	a5,-400(s0)
    800040ec:	e8845703          	lhu	a4,-376(s0)
    800040f0:	c735                	beqz	a4,8000415c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040f2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040f4:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800040f8:	6a05                	lui	s4,0x1
    800040fa:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040fe:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004102:	6d85                	lui	s11,0x1
    80004104:	7d7d                	lui	s10,0xfffff
    80004106:	ac1d                	j	8000433c <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004108:	00005517          	auipc	a0,0x5
    8000410c:	59050513          	addi	a0,a0,1424 # 80009698 <syscalls+0x2c0>
    80004110:	00003097          	auipc	ra,0x3
    80004114:	aba080e7          	jalr	-1350(ra) # 80006bca <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004118:	874a                	mv	a4,s2
    8000411a:	009c86bb          	addw	a3,s9,s1
    8000411e:	4581                	li	a1,0
    80004120:	8556                	mv	a0,s5
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	c7c080e7          	jalr	-900(ra) # 80002d9e <readi>
    8000412a:	2501                	sext.w	a0,a0
    8000412c:	1aa91863          	bne	s2,a0,800042dc <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004130:	009d84bb          	addw	s1,s11,s1
    80004134:	013d09bb          	addw	s3,s10,s3
    80004138:	1f74f263          	bgeu	s1,s7,8000431c <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000413c:	02049593          	slli	a1,s1,0x20
    80004140:	9181                	srli	a1,a1,0x20
    80004142:	95e2                	add	a1,a1,s8
    80004144:	855a                	mv	a0,s6
    80004146:	ffffc097          	auipc	ra,0xffffc
    8000414a:	3d0080e7          	jalr	976(ra) # 80000516 <walkaddr>
    8000414e:	862a                	mv	a2,a0
    if(pa == 0)
    80004150:	dd45                	beqz	a0,80004108 <exec+0xfe>
      n = PGSIZE;
    80004152:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004154:	fd49f2e3          	bgeu	s3,s4,80004118 <exec+0x10e>
      n = sz - i;
    80004158:	894e                	mv	s2,s3
    8000415a:	bf7d                	j	80004118 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000415c:	4481                	li	s1,0
  iunlockput(ip);
    8000415e:	8556                	mv	a0,s5
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	bec080e7          	jalr	-1044(ra) # 80002d4c <iunlockput>
  end_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	3d4080e7          	jalr	980(ra) # 8000353c <end_op>
  p = myproc();
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	d2a080e7          	jalr	-726(ra) # 80000e9a <myproc>
    80004178:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000417a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000417e:	6785                	lui	a5,0x1
    80004180:	17fd                	addi	a5,a5,-1
    80004182:	94be                	add	s1,s1,a5
    80004184:	77fd                	lui	a5,0xfffff
    80004186:	8fe5                	and	a5,a5,s1
    80004188:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000418c:	6609                	lui	a2,0x2
    8000418e:	963e                	add	a2,a2,a5
    80004190:	85be                	mv	a1,a5
    80004192:	855a                	mv	a0,s6
    80004194:	ffffc097          	auipc	ra,0xffffc
    80004198:	77a080e7          	jalr	1914(ra) # 8000090e <uvmalloc>
    8000419c:	8c2a                	mv	s8,a0
  ip = 0;
    8000419e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041a0:	12050e63          	beqz	a0,800042dc <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041a4:	75f9                	lui	a1,0xffffe
    800041a6:	95aa                	add	a1,a1,a0
    800041a8:	855a                	mv	a0,s6
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	982080e7          	jalr	-1662(ra) # 80000b2c <uvmclear>
  stackbase = sp - PGSIZE;
    800041b2:	7afd                	lui	s5,0xfffff
    800041b4:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041b6:	df043783          	ld	a5,-528(s0)
    800041ba:	6388                	ld	a0,0(a5)
    800041bc:	c925                	beqz	a0,8000422c <exec+0x222>
    800041be:	e9040993          	addi	s3,s0,-368
    800041c2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041c6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041c8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041ca:	ffffc097          	auipc	ra,0xffffc
    800041ce:	12a080e7          	jalr	298(ra) # 800002f4 <strlen>
    800041d2:	0015079b          	addiw	a5,a0,1
    800041d6:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041da:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041de:	13596363          	bltu	s2,s5,80004304 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041e2:	df043d83          	ld	s11,-528(s0)
    800041e6:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041ea:	8552                	mv	a0,s4
    800041ec:	ffffc097          	auipc	ra,0xffffc
    800041f0:	108080e7          	jalr	264(ra) # 800002f4 <strlen>
    800041f4:	0015069b          	addiw	a3,a0,1
    800041f8:	8652                	mv	a2,s4
    800041fa:	85ca                	mv	a1,s2
    800041fc:	855a                	mv	a0,s6
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	960080e7          	jalr	-1696(ra) # 80000b5e <copyout>
    80004206:	10054363          	bltz	a0,8000430c <exec+0x302>
    ustack[argc] = sp;
    8000420a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000420e:	0485                	addi	s1,s1,1
    80004210:	008d8793          	addi	a5,s11,8
    80004214:	def43823          	sd	a5,-528(s0)
    80004218:	008db503          	ld	a0,8(s11)
    8000421c:	c911                	beqz	a0,80004230 <exec+0x226>
    if(argc >= MAXARG)
    8000421e:	09a1                	addi	s3,s3,8
    80004220:	fb3c95e3          	bne	s9,s3,800041ca <exec+0x1c0>
  sz = sz1;
    80004224:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004228:	4a81                	li	s5,0
    8000422a:	a84d                	j	800042dc <exec+0x2d2>
  sp = sz;
    8000422c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000422e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004230:	00349793          	slli	a5,s1,0x3
    80004234:	f9040713          	addi	a4,s0,-112
    80004238:	97ba                	add	a5,a5,a4
    8000423a:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd7980>
  sp -= (argc+1) * sizeof(uint64);
    8000423e:	00148693          	addi	a3,s1,1
    80004242:	068e                	slli	a3,a3,0x3
    80004244:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004248:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000424c:	01597663          	bgeu	s2,s5,80004258 <exec+0x24e>
  sz = sz1;
    80004250:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004254:	4a81                	li	s5,0
    80004256:	a059                	j	800042dc <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004258:	e9040613          	addi	a2,s0,-368
    8000425c:	85ca                	mv	a1,s2
    8000425e:	855a                	mv	a0,s6
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	8fe080e7          	jalr	-1794(ra) # 80000b5e <copyout>
    80004268:	0a054663          	bltz	a0,80004314 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000426c:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004270:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004274:	de843783          	ld	a5,-536(s0)
    80004278:	0007c703          	lbu	a4,0(a5)
    8000427c:	cf11                	beqz	a4,80004298 <exec+0x28e>
    8000427e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004280:	02f00693          	li	a3,47
    80004284:	a039                	j	80004292 <exec+0x288>
      last = s+1;
    80004286:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000428a:	0785                	addi	a5,a5,1
    8000428c:	fff7c703          	lbu	a4,-1(a5)
    80004290:	c701                	beqz	a4,80004298 <exec+0x28e>
    if(*s == '/')
    80004292:	fed71ce3          	bne	a4,a3,8000428a <exec+0x280>
    80004296:	bfc5                	j	80004286 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004298:	4641                	li	a2,16
    8000429a:	de843583          	ld	a1,-536(s0)
    8000429e:	158b8513          	addi	a0,s7,344
    800042a2:	ffffc097          	auipc	ra,0xffffc
    800042a6:	020080e7          	jalr	32(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800042aa:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042ae:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042b2:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042b6:	058bb783          	ld	a5,88(s7)
    800042ba:	e6843703          	ld	a4,-408(s0)
    800042be:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042c0:	058bb783          	ld	a5,88(s7)
    800042c4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042c8:	85ea                	mv	a1,s10
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	d30080e7          	jalr	-720(ra) # 80000ffa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042d2:	0004851b          	sext.w	a0,s1
    800042d6:	bbc1                	j	800040a6 <exec+0x9c>
    800042d8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042dc:	df843583          	ld	a1,-520(s0)
    800042e0:	855a                	mv	a0,s6
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	d18080e7          	jalr	-744(ra) # 80000ffa <proc_freepagetable>
  if(ip){
    800042ea:	da0a94e3          	bnez	s5,80004092 <exec+0x88>
  return -1;
    800042ee:	557d                	li	a0,-1
    800042f0:	bb5d                	j	800040a6 <exec+0x9c>
    800042f2:	de943c23          	sd	s1,-520(s0)
    800042f6:	b7dd                	j	800042dc <exec+0x2d2>
    800042f8:	de943c23          	sd	s1,-520(s0)
    800042fc:	b7c5                	j	800042dc <exec+0x2d2>
    800042fe:	de943c23          	sd	s1,-520(s0)
    80004302:	bfe9                	j	800042dc <exec+0x2d2>
  sz = sz1;
    80004304:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004308:	4a81                	li	s5,0
    8000430a:	bfc9                	j	800042dc <exec+0x2d2>
  sz = sz1;
    8000430c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004310:	4a81                	li	s5,0
    80004312:	b7e9                	j	800042dc <exec+0x2d2>
  sz = sz1;
    80004314:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004318:	4a81                	li	s5,0
    8000431a:	b7c9                	j	800042dc <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000431c:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004320:	e0843783          	ld	a5,-504(s0)
    80004324:	0017869b          	addiw	a3,a5,1
    80004328:	e0d43423          	sd	a3,-504(s0)
    8000432c:	e0043783          	ld	a5,-512(s0)
    80004330:	0387879b          	addiw	a5,a5,56
    80004334:	e8845703          	lhu	a4,-376(s0)
    80004338:	e2e6d3e3          	bge	a3,a4,8000415e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000433c:	2781                	sext.w	a5,a5
    8000433e:	e0f43023          	sd	a5,-512(s0)
    80004342:	03800713          	li	a4,56
    80004346:	86be                	mv	a3,a5
    80004348:	e1840613          	addi	a2,s0,-488
    8000434c:	4581                	li	a1,0
    8000434e:	8556                	mv	a0,s5
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	a4e080e7          	jalr	-1458(ra) # 80002d9e <readi>
    80004358:	03800793          	li	a5,56
    8000435c:	f6f51ee3          	bne	a0,a5,800042d8 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004360:	e1842783          	lw	a5,-488(s0)
    80004364:	4705                	li	a4,1
    80004366:	fae79de3          	bne	a5,a4,80004320 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000436a:	e4043603          	ld	a2,-448(s0)
    8000436e:	e3843783          	ld	a5,-456(s0)
    80004372:	f8f660e3          	bltu	a2,a5,800042f2 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004376:	e2843783          	ld	a5,-472(s0)
    8000437a:	963e                	add	a2,a2,a5
    8000437c:	f6f66ee3          	bltu	a2,a5,800042f8 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004380:	85a6                	mv	a1,s1
    80004382:	855a                	mv	a0,s6
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	58a080e7          	jalr	1418(ra) # 8000090e <uvmalloc>
    8000438c:	dea43c23          	sd	a0,-520(s0)
    80004390:	d53d                	beqz	a0,800042fe <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004392:	e2843c03          	ld	s8,-472(s0)
    80004396:	de043783          	ld	a5,-544(s0)
    8000439a:	00fc77b3          	and	a5,s8,a5
    8000439e:	ff9d                	bnez	a5,800042dc <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043a0:	e2042c83          	lw	s9,-480(s0)
    800043a4:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043a8:	f60b8ae3          	beqz	s7,8000431c <exec+0x312>
    800043ac:	89de                	mv	s3,s7
    800043ae:	4481                	li	s1,0
    800043b0:	b371                	j	8000413c <exec+0x132>

00000000800043b2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043b2:	7179                	addi	sp,sp,-48
    800043b4:	f406                	sd	ra,40(sp)
    800043b6:	f022                	sd	s0,32(sp)
    800043b8:	ec26                	sd	s1,24(sp)
    800043ba:	e84a                	sd	s2,16(sp)
    800043bc:	1800                	addi	s0,sp,48
    800043be:	892e                	mv	s2,a1
    800043c0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043c2:	fdc40593          	addi	a1,s0,-36
    800043c6:	ffffe097          	auipc	ra,0xffffe
    800043ca:	bb4080e7          	jalr	-1100(ra) # 80001f7a <argint>
    800043ce:	04054063          	bltz	a0,8000440e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043d2:	fdc42703          	lw	a4,-36(s0)
    800043d6:	47bd                	li	a5,15
    800043d8:	02e7ed63          	bltu	a5,a4,80004412 <argfd+0x60>
    800043dc:	ffffd097          	auipc	ra,0xffffd
    800043e0:	abe080e7          	jalr	-1346(ra) # 80000e9a <myproc>
    800043e4:	fdc42703          	lw	a4,-36(s0)
    800043e8:	01a70793          	addi	a5,a4,26
    800043ec:	078e                	slli	a5,a5,0x3
    800043ee:	953e                	add	a0,a0,a5
    800043f0:	611c                	ld	a5,0(a0)
    800043f2:	c395                	beqz	a5,80004416 <argfd+0x64>
    return -1;
  if(pfd)
    800043f4:	00090463          	beqz	s2,800043fc <argfd+0x4a>
    *pfd = fd;
    800043f8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043fc:	4501                	li	a0,0
  if(pf)
    800043fe:	c091                	beqz	s1,80004402 <argfd+0x50>
    *pf = f;
    80004400:	e09c                	sd	a5,0(s1)
}
    80004402:	70a2                	ld	ra,40(sp)
    80004404:	7402                	ld	s0,32(sp)
    80004406:	64e2                	ld	s1,24(sp)
    80004408:	6942                	ld	s2,16(sp)
    8000440a:	6145                	addi	sp,sp,48
    8000440c:	8082                	ret
    return -1;
    8000440e:	557d                	li	a0,-1
    80004410:	bfcd                	j	80004402 <argfd+0x50>
    return -1;
    80004412:	557d                	li	a0,-1
    80004414:	b7fd                	j	80004402 <argfd+0x50>
    80004416:	557d                	li	a0,-1
    80004418:	b7ed                	j	80004402 <argfd+0x50>

000000008000441a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000441a:	1101                	addi	sp,sp,-32
    8000441c:	ec06                	sd	ra,24(sp)
    8000441e:	e822                	sd	s0,16(sp)
    80004420:	e426                	sd	s1,8(sp)
    80004422:	1000                	addi	s0,sp,32
    80004424:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004426:	ffffd097          	auipc	ra,0xffffd
    8000442a:	a74080e7          	jalr	-1420(ra) # 80000e9a <myproc>
    8000442e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004430:	0d050793          	addi	a5,a0,208
    80004434:	4501                	li	a0,0
    80004436:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004438:	6398                	ld	a4,0(a5)
    8000443a:	cb19                	beqz	a4,80004450 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000443c:	2505                	addiw	a0,a0,1
    8000443e:	07a1                	addi	a5,a5,8
    80004440:	fed51ce3          	bne	a0,a3,80004438 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004444:	557d                	li	a0,-1
}
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6105                	addi	sp,sp,32
    8000444e:	8082                	ret
      p->ofile[fd] = f;
    80004450:	01a50793          	addi	a5,a0,26
    80004454:	078e                	slli	a5,a5,0x3
    80004456:	963e                	add	a2,a2,a5
    80004458:	e204                	sd	s1,0(a2)
      return fd;
    8000445a:	b7f5                	j	80004446 <fdalloc+0x2c>

000000008000445c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000445c:	715d                	addi	sp,sp,-80
    8000445e:	e486                	sd	ra,72(sp)
    80004460:	e0a2                	sd	s0,64(sp)
    80004462:	fc26                	sd	s1,56(sp)
    80004464:	f84a                	sd	s2,48(sp)
    80004466:	f44e                	sd	s3,40(sp)
    80004468:	f052                	sd	s4,32(sp)
    8000446a:	ec56                	sd	s5,24(sp)
    8000446c:	0880                	addi	s0,sp,80
    8000446e:	89ae                	mv	s3,a1
    80004470:	8ab2                	mv	s5,a2
    80004472:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004474:	fb040593          	addi	a1,s0,-80
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	e46080e7          	jalr	-442(ra) # 800032be <nameiparent>
    80004480:	892a                	mv	s2,a0
    80004482:	12050e63          	beqz	a0,800045be <create+0x162>
    return 0;

  ilock(dp);
    80004486:	ffffe097          	auipc	ra,0xffffe
    8000448a:	664080e7          	jalr	1636(ra) # 80002aea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000448e:	4601                	li	a2,0
    80004490:	fb040593          	addi	a1,s0,-80
    80004494:	854a                	mv	a0,s2
    80004496:	fffff097          	auipc	ra,0xfffff
    8000449a:	b38080e7          	jalr	-1224(ra) # 80002fce <dirlookup>
    8000449e:	84aa                	mv	s1,a0
    800044a0:	c921                	beqz	a0,800044f0 <create+0x94>
    iunlockput(dp);
    800044a2:	854a                	mv	a0,s2
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	8a8080e7          	jalr	-1880(ra) # 80002d4c <iunlockput>
    ilock(ip);
    800044ac:	8526                	mv	a0,s1
    800044ae:	ffffe097          	auipc	ra,0xffffe
    800044b2:	63c080e7          	jalr	1596(ra) # 80002aea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044b6:	2981                	sext.w	s3,s3
    800044b8:	4789                	li	a5,2
    800044ba:	02f99463          	bne	s3,a5,800044e2 <create+0x86>
    800044be:	0444d783          	lhu	a5,68(s1)
    800044c2:	37f9                	addiw	a5,a5,-2
    800044c4:	17c2                	slli	a5,a5,0x30
    800044c6:	93c1                	srli	a5,a5,0x30
    800044c8:	4705                	li	a4,1
    800044ca:	00f76c63          	bltu	a4,a5,800044e2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044ce:	8526                	mv	a0,s1
    800044d0:	60a6                	ld	ra,72(sp)
    800044d2:	6406                	ld	s0,64(sp)
    800044d4:	74e2                	ld	s1,56(sp)
    800044d6:	7942                	ld	s2,48(sp)
    800044d8:	79a2                	ld	s3,40(sp)
    800044da:	7a02                	ld	s4,32(sp)
    800044dc:	6ae2                	ld	s5,24(sp)
    800044de:	6161                	addi	sp,sp,80
    800044e0:	8082                	ret
    iunlockput(ip);
    800044e2:	8526                	mv	a0,s1
    800044e4:	fffff097          	auipc	ra,0xfffff
    800044e8:	868080e7          	jalr	-1944(ra) # 80002d4c <iunlockput>
    return 0;
    800044ec:	4481                	li	s1,0
    800044ee:	b7c5                	j	800044ce <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800044f0:	85ce                	mv	a1,s3
    800044f2:	00092503          	lw	a0,0(s2)
    800044f6:	ffffe097          	auipc	ra,0xffffe
    800044fa:	45c080e7          	jalr	1116(ra) # 80002952 <ialloc>
    800044fe:	84aa                	mv	s1,a0
    80004500:	c521                	beqz	a0,80004548 <create+0xec>
  ilock(ip);
    80004502:	ffffe097          	auipc	ra,0xffffe
    80004506:	5e8080e7          	jalr	1512(ra) # 80002aea <ilock>
  ip->major = major;
    8000450a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000450e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004512:	4a05                	li	s4,1
    80004514:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004518:	8526                	mv	a0,s1
    8000451a:	ffffe097          	auipc	ra,0xffffe
    8000451e:	506080e7          	jalr	1286(ra) # 80002a20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004522:	2981                	sext.w	s3,s3
    80004524:	03498a63          	beq	s3,s4,80004558 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004528:	40d0                	lw	a2,4(s1)
    8000452a:	fb040593          	addi	a1,s0,-80
    8000452e:	854a                	mv	a0,s2
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	cae080e7          	jalr	-850(ra) # 800031de <dirlink>
    80004538:	06054b63          	bltz	a0,800045ae <create+0x152>
  iunlockput(dp);
    8000453c:	854a                	mv	a0,s2
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	80e080e7          	jalr	-2034(ra) # 80002d4c <iunlockput>
  return ip;
    80004546:	b761                	j	800044ce <create+0x72>
    panic("create: ialloc");
    80004548:	00005517          	auipc	a0,0x5
    8000454c:	17050513          	addi	a0,a0,368 # 800096b8 <syscalls+0x2e0>
    80004550:	00002097          	auipc	ra,0x2
    80004554:	67a080e7          	jalr	1658(ra) # 80006bca <panic>
    dp->nlink++;  // for ".."
    80004558:	04a95783          	lhu	a5,74(s2)
    8000455c:	2785                	addiw	a5,a5,1
    8000455e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004562:	854a                	mv	a0,s2
    80004564:	ffffe097          	auipc	ra,0xffffe
    80004568:	4bc080e7          	jalr	1212(ra) # 80002a20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000456c:	40d0                	lw	a2,4(s1)
    8000456e:	00005597          	auipc	a1,0x5
    80004572:	15a58593          	addi	a1,a1,346 # 800096c8 <syscalls+0x2f0>
    80004576:	8526                	mv	a0,s1
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	c66080e7          	jalr	-922(ra) # 800031de <dirlink>
    80004580:	00054f63          	bltz	a0,8000459e <create+0x142>
    80004584:	00492603          	lw	a2,4(s2)
    80004588:	00005597          	auipc	a1,0x5
    8000458c:	14858593          	addi	a1,a1,328 # 800096d0 <syscalls+0x2f8>
    80004590:	8526                	mv	a0,s1
    80004592:	fffff097          	auipc	ra,0xfffff
    80004596:	c4c080e7          	jalr	-948(ra) # 800031de <dirlink>
    8000459a:	f80557e3          	bgez	a0,80004528 <create+0xcc>
      panic("create dots");
    8000459e:	00005517          	auipc	a0,0x5
    800045a2:	13a50513          	addi	a0,a0,314 # 800096d8 <syscalls+0x300>
    800045a6:	00002097          	auipc	ra,0x2
    800045aa:	624080e7          	jalr	1572(ra) # 80006bca <panic>
    panic("create: dirlink");
    800045ae:	00005517          	auipc	a0,0x5
    800045b2:	13a50513          	addi	a0,a0,314 # 800096e8 <syscalls+0x310>
    800045b6:	00002097          	auipc	ra,0x2
    800045ba:	614080e7          	jalr	1556(ra) # 80006bca <panic>
    return 0;
    800045be:	84aa                	mv	s1,a0
    800045c0:	b739                	j	800044ce <create+0x72>

00000000800045c2 <sys_dup>:
{
    800045c2:	7179                	addi	sp,sp,-48
    800045c4:	f406                	sd	ra,40(sp)
    800045c6:	f022                	sd	s0,32(sp)
    800045c8:	ec26                	sd	s1,24(sp)
    800045ca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045cc:	fd840613          	addi	a2,s0,-40
    800045d0:	4581                	li	a1,0
    800045d2:	4501                	li	a0,0
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	dde080e7          	jalr	-546(ra) # 800043b2 <argfd>
    return -1;
    800045dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045de:	02054363          	bltz	a0,80004604 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045e2:	fd843503          	ld	a0,-40(s0)
    800045e6:	00000097          	auipc	ra,0x0
    800045ea:	e34080e7          	jalr	-460(ra) # 8000441a <fdalloc>
    800045ee:	84aa                	mv	s1,a0
    return -1;
    800045f0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045f2:	00054963          	bltz	a0,80004604 <sys_dup+0x42>
  filedup(f);
    800045f6:	fd843503          	ld	a0,-40(s0)
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	33c080e7          	jalr	828(ra) # 80003936 <filedup>
  return fd;
    80004602:	87a6                	mv	a5,s1
}
    80004604:	853e                	mv	a0,a5
    80004606:	70a2                	ld	ra,40(sp)
    80004608:	7402                	ld	s0,32(sp)
    8000460a:	64e2                	ld	s1,24(sp)
    8000460c:	6145                	addi	sp,sp,48
    8000460e:	8082                	ret

0000000080004610 <sys_read>:
{
    80004610:	7179                	addi	sp,sp,-48
    80004612:	f406                	sd	ra,40(sp)
    80004614:	f022                	sd	s0,32(sp)
    80004616:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004618:	fe840613          	addi	a2,s0,-24
    8000461c:	4581                	li	a1,0
    8000461e:	4501                	li	a0,0
    80004620:	00000097          	auipc	ra,0x0
    80004624:	d92080e7          	jalr	-622(ra) # 800043b2 <argfd>
    return -1;
    80004628:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000462a:	04054163          	bltz	a0,8000466c <sys_read+0x5c>
    8000462e:	fe440593          	addi	a1,s0,-28
    80004632:	4509                	li	a0,2
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	946080e7          	jalr	-1722(ra) # 80001f7a <argint>
    return -1;
    8000463c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000463e:	02054763          	bltz	a0,8000466c <sys_read+0x5c>
    80004642:	fd840593          	addi	a1,s0,-40
    80004646:	4505                	li	a0,1
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	954080e7          	jalr	-1708(ra) # 80001f9c <argaddr>
    return -1;
    80004650:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004652:	00054d63          	bltz	a0,8000466c <sys_read+0x5c>
  return fileread(f, p, n);
    80004656:	fe442603          	lw	a2,-28(s0)
    8000465a:	fd843583          	ld	a1,-40(s0)
    8000465e:	fe843503          	ld	a0,-24(s0)
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	47c080e7          	jalr	1148(ra) # 80003ade <fileread>
    8000466a:	87aa                	mv	a5,a0
}
    8000466c:	853e                	mv	a0,a5
    8000466e:	70a2                	ld	ra,40(sp)
    80004670:	7402                	ld	s0,32(sp)
    80004672:	6145                	addi	sp,sp,48
    80004674:	8082                	ret

0000000080004676 <sys_write>:
{
    80004676:	7179                	addi	sp,sp,-48
    80004678:	f406                	sd	ra,40(sp)
    8000467a:	f022                	sd	s0,32(sp)
    8000467c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000467e:	fe840613          	addi	a2,s0,-24
    80004682:	4581                	li	a1,0
    80004684:	4501                	li	a0,0
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	d2c080e7          	jalr	-724(ra) # 800043b2 <argfd>
    return -1;
    8000468e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004690:	04054163          	bltz	a0,800046d2 <sys_write+0x5c>
    80004694:	fe440593          	addi	a1,s0,-28
    80004698:	4509                	li	a0,2
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	8e0080e7          	jalr	-1824(ra) # 80001f7a <argint>
    return -1;
    800046a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a4:	02054763          	bltz	a0,800046d2 <sys_write+0x5c>
    800046a8:	fd840593          	addi	a1,s0,-40
    800046ac:	4505                	li	a0,1
    800046ae:	ffffe097          	auipc	ra,0xffffe
    800046b2:	8ee080e7          	jalr	-1810(ra) # 80001f9c <argaddr>
    return -1;
    800046b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b8:	00054d63          	bltz	a0,800046d2 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046bc:	fe442603          	lw	a2,-28(s0)
    800046c0:	fd843583          	ld	a1,-40(s0)
    800046c4:	fe843503          	ld	a0,-24(s0)
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	4ec080e7          	jalr	1260(ra) # 80003bb4 <filewrite>
    800046d0:	87aa                	mv	a5,a0
}
    800046d2:	853e                	mv	a0,a5
    800046d4:	70a2                	ld	ra,40(sp)
    800046d6:	7402                	ld	s0,32(sp)
    800046d8:	6145                	addi	sp,sp,48
    800046da:	8082                	ret

00000000800046dc <sys_close>:
{
    800046dc:	1101                	addi	sp,sp,-32
    800046de:	ec06                	sd	ra,24(sp)
    800046e0:	e822                	sd	s0,16(sp)
    800046e2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046e4:	fe040613          	addi	a2,s0,-32
    800046e8:	fec40593          	addi	a1,s0,-20
    800046ec:	4501                	li	a0,0
    800046ee:	00000097          	auipc	ra,0x0
    800046f2:	cc4080e7          	jalr	-828(ra) # 800043b2 <argfd>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046f8:	02054463          	bltz	a0,80004720 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	79e080e7          	jalr	1950(ra) # 80000e9a <myproc>
    80004704:	fec42783          	lw	a5,-20(s0)
    80004708:	07e9                	addi	a5,a5,26
    8000470a:	078e                	slli	a5,a5,0x3
    8000470c:	97aa                	add	a5,a5,a0
    8000470e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004712:	fe043503          	ld	a0,-32(s0)
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	272080e7          	jalr	626(ra) # 80003988 <fileclose>
  return 0;
    8000471e:	4781                	li	a5,0
}
    80004720:	853e                	mv	a0,a5
    80004722:	60e2                	ld	ra,24(sp)
    80004724:	6442                	ld	s0,16(sp)
    80004726:	6105                	addi	sp,sp,32
    80004728:	8082                	ret

000000008000472a <sys_fstat>:
{
    8000472a:	1101                	addi	sp,sp,-32
    8000472c:	ec06                	sd	ra,24(sp)
    8000472e:	e822                	sd	s0,16(sp)
    80004730:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004732:	fe840613          	addi	a2,s0,-24
    80004736:	4581                	li	a1,0
    80004738:	4501                	li	a0,0
    8000473a:	00000097          	auipc	ra,0x0
    8000473e:	c78080e7          	jalr	-904(ra) # 800043b2 <argfd>
    return -1;
    80004742:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004744:	02054563          	bltz	a0,8000476e <sys_fstat+0x44>
    80004748:	fe040593          	addi	a1,s0,-32
    8000474c:	4505                	li	a0,1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	84e080e7          	jalr	-1970(ra) # 80001f9c <argaddr>
    return -1;
    80004756:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004758:	00054b63          	bltz	a0,8000476e <sys_fstat+0x44>
  return filestat(f, st);
    8000475c:	fe043583          	ld	a1,-32(s0)
    80004760:	fe843503          	ld	a0,-24(s0)
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	308080e7          	jalr	776(ra) # 80003a6c <filestat>
    8000476c:	87aa                	mv	a5,a0
}
    8000476e:	853e                	mv	a0,a5
    80004770:	60e2                	ld	ra,24(sp)
    80004772:	6442                	ld	s0,16(sp)
    80004774:	6105                	addi	sp,sp,32
    80004776:	8082                	ret

0000000080004778 <sys_link>:
{
    80004778:	7169                	addi	sp,sp,-304
    8000477a:	f606                	sd	ra,296(sp)
    8000477c:	f222                	sd	s0,288(sp)
    8000477e:	ee26                	sd	s1,280(sp)
    80004780:	ea4a                	sd	s2,272(sp)
    80004782:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004784:	08000613          	li	a2,128
    80004788:	ed040593          	addi	a1,s0,-304
    8000478c:	4501                	li	a0,0
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	830080e7          	jalr	-2000(ra) # 80001fbe <argstr>
    return -1;
    80004796:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004798:	10054e63          	bltz	a0,800048b4 <sys_link+0x13c>
    8000479c:	08000613          	li	a2,128
    800047a0:	f5040593          	addi	a1,s0,-176
    800047a4:	4505                	li	a0,1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	818080e7          	jalr	-2024(ra) # 80001fbe <argstr>
    return -1;
    800047ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047b0:	10054263          	bltz	a0,800048b4 <sys_link+0x13c>
  begin_op();
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	d08080e7          	jalr	-760(ra) # 800034bc <begin_op>
  if((ip = namei(old)) == 0){
    800047bc:	ed040513          	addi	a0,s0,-304
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	ae0080e7          	jalr	-1312(ra) # 800032a0 <namei>
    800047c8:	84aa                	mv	s1,a0
    800047ca:	c551                	beqz	a0,80004856 <sys_link+0xde>
  ilock(ip);
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	31e080e7          	jalr	798(ra) # 80002aea <ilock>
  if(ip->type == T_DIR){
    800047d4:	04449703          	lh	a4,68(s1)
    800047d8:	4785                	li	a5,1
    800047da:	08f70463          	beq	a4,a5,80004862 <sys_link+0xea>
  ip->nlink++;
    800047de:	04a4d783          	lhu	a5,74(s1)
    800047e2:	2785                	addiw	a5,a5,1
    800047e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	236080e7          	jalr	566(ra) # 80002a20 <iupdate>
  iunlock(ip);
    800047f2:	8526                	mv	a0,s1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	3b8080e7          	jalr	952(ra) # 80002bac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047fc:	fd040593          	addi	a1,s0,-48
    80004800:	f5040513          	addi	a0,s0,-176
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	aba080e7          	jalr	-1350(ra) # 800032be <nameiparent>
    8000480c:	892a                	mv	s2,a0
    8000480e:	c935                	beqz	a0,80004882 <sys_link+0x10a>
  ilock(dp);
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	2da080e7          	jalr	730(ra) # 80002aea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004818:	00092703          	lw	a4,0(s2)
    8000481c:	409c                	lw	a5,0(s1)
    8000481e:	04f71d63          	bne	a4,a5,80004878 <sys_link+0x100>
    80004822:	40d0                	lw	a2,4(s1)
    80004824:	fd040593          	addi	a1,s0,-48
    80004828:	854a                	mv	a0,s2
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	9b4080e7          	jalr	-1612(ra) # 800031de <dirlink>
    80004832:	04054363          	bltz	a0,80004878 <sys_link+0x100>
  iunlockput(dp);
    80004836:	854a                	mv	a0,s2
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	514080e7          	jalr	1300(ra) # 80002d4c <iunlockput>
  iput(ip);
    80004840:	8526                	mv	a0,s1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	462080e7          	jalr	1122(ra) # 80002ca4 <iput>
  end_op();
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	cf2080e7          	jalr	-782(ra) # 8000353c <end_op>
  return 0;
    80004852:	4781                	li	a5,0
    80004854:	a085                	j	800048b4 <sys_link+0x13c>
    end_op();
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	ce6080e7          	jalr	-794(ra) # 8000353c <end_op>
    return -1;
    8000485e:	57fd                	li	a5,-1
    80004860:	a891                	j	800048b4 <sys_link+0x13c>
    iunlockput(ip);
    80004862:	8526                	mv	a0,s1
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	4e8080e7          	jalr	1256(ra) # 80002d4c <iunlockput>
    end_op();
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	cd0080e7          	jalr	-816(ra) # 8000353c <end_op>
    return -1;
    80004874:	57fd                	li	a5,-1
    80004876:	a83d                	j	800048b4 <sys_link+0x13c>
    iunlockput(dp);
    80004878:	854a                	mv	a0,s2
    8000487a:	ffffe097          	auipc	ra,0xffffe
    8000487e:	4d2080e7          	jalr	1234(ra) # 80002d4c <iunlockput>
  ilock(ip);
    80004882:	8526                	mv	a0,s1
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	266080e7          	jalr	614(ra) # 80002aea <ilock>
  ip->nlink--;
    8000488c:	04a4d783          	lhu	a5,74(s1)
    80004890:	37fd                	addiw	a5,a5,-1
    80004892:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004896:	8526                	mv	a0,s1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	188080e7          	jalr	392(ra) # 80002a20 <iupdate>
  iunlockput(ip);
    800048a0:	8526                	mv	a0,s1
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	4aa080e7          	jalr	1194(ra) # 80002d4c <iunlockput>
  end_op();
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	c92080e7          	jalr	-878(ra) # 8000353c <end_op>
  return -1;
    800048b2:	57fd                	li	a5,-1
}
    800048b4:	853e                	mv	a0,a5
    800048b6:	70b2                	ld	ra,296(sp)
    800048b8:	7412                	ld	s0,288(sp)
    800048ba:	64f2                	ld	s1,280(sp)
    800048bc:	6952                	ld	s2,272(sp)
    800048be:	6155                	addi	sp,sp,304
    800048c0:	8082                	ret

00000000800048c2 <sys_unlink>:
{
    800048c2:	7151                	addi	sp,sp,-240
    800048c4:	f586                	sd	ra,232(sp)
    800048c6:	f1a2                	sd	s0,224(sp)
    800048c8:	eda6                	sd	s1,216(sp)
    800048ca:	e9ca                	sd	s2,208(sp)
    800048cc:	e5ce                	sd	s3,200(sp)
    800048ce:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048d0:	08000613          	li	a2,128
    800048d4:	f3040593          	addi	a1,s0,-208
    800048d8:	4501                	li	a0,0
    800048da:	ffffd097          	auipc	ra,0xffffd
    800048de:	6e4080e7          	jalr	1764(ra) # 80001fbe <argstr>
    800048e2:	18054163          	bltz	a0,80004a64 <sys_unlink+0x1a2>
  begin_op();
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	bd6080e7          	jalr	-1066(ra) # 800034bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ee:	fb040593          	addi	a1,s0,-80
    800048f2:	f3040513          	addi	a0,s0,-208
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	9c8080e7          	jalr	-1592(ra) # 800032be <nameiparent>
    800048fe:	84aa                	mv	s1,a0
    80004900:	c979                	beqz	a0,800049d6 <sys_unlink+0x114>
  ilock(dp);
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	1e8080e7          	jalr	488(ra) # 80002aea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000490a:	00005597          	auipc	a1,0x5
    8000490e:	dbe58593          	addi	a1,a1,-578 # 800096c8 <syscalls+0x2f0>
    80004912:	fb040513          	addi	a0,s0,-80
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	69e080e7          	jalr	1694(ra) # 80002fb4 <namecmp>
    8000491e:	14050a63          	beqz	a0,80004a72 <sys_unlink+0x1b0>
    80004922:	00005597          	auipc	a1,0x5
    80004926:	dae58593          	addi	a1,a1,-594 # 800096d0 <syscalls+0x2f8>
    8000492a:	fb040513          	addi	a0,s0,-80
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	686080e7          	jalr	1670(ra) # 80002fb4 <namecmp>
    80004936:	12050e63          	beqz	a0,80004a72 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000493a:	f2c40613          	addi	a2,s0,-212
    8000493e:	fb040593          	addi	a1,s0,-80
    80004942:	8526                	mv	a0,s1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	68a080e7          	jalr	1674(ra) # 80002fce <dirlookup>
    8000494c:	892a                	mv	s2,a0
    8000494e:	12050263          	beqz	a0,80004a72 <sys_unlink+0x1b0>
  ilock(ip);
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	198080e7          	jalr	408(ra) # 80002aea <ilock>
  if(ip->nlink < 1)
    8000495a:	04a91783          	lh	a5,74(s2)
    8000495e:	08f05263          	blez	a5,800049e2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004962:	04491703          	lh	a4,68(s2)
    80004966:	4785                	li	a5,1
    80004968:	08f70563          	beq	a4,a5,800049f2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000496c:	4641                	li	a2,16
    8000496e:	4581                	li	a1,0
    80004970:	fc040513          	addi	a0,s0,-64
    80004974:	ffffc097          	auipc	ra,0xffffc
    80004978:	804080e7          	jalr	-2044(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000497c:	4741                	li	a4,16
    8000497e:	f2c42683          	lw	a3,-212(s0)
    80004982:	fc040613          	addi	a2,s0,-64
    80004986:	4581                	li	a1,0
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	50c080e7          	jalr	1292(ra) # 80002e96 <writei>
    80004992:	47c1                	li	a5,16
    80004994:	0af51563          	bne	a0,a5,80004a3e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004998:	04491703          	lh	a4,68(s2)
    8000499c:	4785                	li	a5,1
    8000499e:	0af70863          	beq	a4,a5,80004a4e <sys_unlink+0x18c>
  iunlockput(dp);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	3a8080e7          	jalr	936(ra) # 80002d4c <iunlockput>
  ip->nlink--;
    800049ac:	04a95783          	lhu	a5,74(s2)
    800049b0:	37fd                	addiw	a5,a5,-1
    800049b2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	068080e7          	jalr	104(ra) # 80002a20 <iupdate>
  iunlockput(ip);
    800049c0:	854a                	mv	a0,s2
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	38a080e7          	jalr	906(ra) # 80002d4c <iunlockput>
  end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	b72080e7          	jalr	-1166(ra) # 8000353c <end_op>
  return 0;
    800049d2:	4501                	li	a0,0
    800049d4:	a84d                	j	80004a86 <sys_unlink+0x1c4>
    end_op();
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	b66080e7          	jalr	-1178(ra) # 8000353c <end_op>
    return -1;
    800049de:	557d                	li	a0,-1
    800049e0:	a05d                	j	80004a86 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049e2:	00005517          	auipc	a0,0x5
    800049e6:	d1650513          	addi	a0,a0,-746 # 800096f8 <syscalls+0x320>
    800049ea:	00002097          	auipc	ra,0x2
    800049ee:	1e0080e7          	jalr	480(ra) # 80006bca <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049f2:	04c92703          	lw	a4,76(s2)
    800049f6:	02000793          	li	a5,32
    800049fa:	f6e7f9e3          	bgeu	a5,a4,8000496c <sys_unlink+0xaa>
    800049fe:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a02:	4741                	li	a4,16
    80004a04:	86ce                	mv	a3,s3
    80004a06:	f1840613          	addi	a2,s0,-232
    80004a0a:	4581                	li	a1,0
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	390080e7          	jalr	912(ra) # 80002d9e <readi>
    80004a16:	47c1                	li	a5,16
    80004a18:	00f51b63          	bne	a0,a5,80004a2e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a1c:	f1845783          	lhu	a5,-232(s0)
    80004a20:	e7a1                	bnez	a5,80004a68 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a22:	29c1                	addiw	s3,s3,16
    80004a24:	04c92783          	lw	a5,76(s2)
    80004a28:	fcf9ede3          	bltu	s3,a5,80004a02 <sys_unlink+0x140>
    80004a2c:	b781                	j	8000496c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a2e:	00005517          	auipc	a0,0x5
    80004a32:	ce250513          	addi	a0,a0,-798 # 80009710 <syscalls+0x338>
    80004a36:	00002097          	auipc	ra,0x2
    80004a3a:	194080e7          	jalr	404(ra) # 80006bca <panic>
    panic("unlink: writei");
    80004a3e:	00005517          	auipc	a0,0x5
    80004a42:	cea50513          	addi	a0,a0,-790 # 80009728 <syscalls+0x350>
    80004a46:	00002097          	auipc	ra,0x2
    80004a4a:	184080e7          	jalr	388(ra) # 80006bca <panic>
    dp->nlink--;
    80004a4e:	04a4d783          	lhu	a5,74(s1)
    80004a52:	37fd                	addiw	a5,a5,-1
    80004a54:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	fc6080e7          	jalr	-58(ra) # 80002a20 <iupdate>
    80004a62:	b781                	j	800049a2 <sys_unlink+0xe0>
    return -1;
    80004a64:	557d                	li	a0,-1
    80004a66:	a005                	j	80004a86 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	2e2080e7          	jalr	738(ra) # 80002d4c <iunlockput>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	2d8080e7          	jalr	728(ra) # 80002d4c <iunlockput>
  end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	ac0080e7          	jalr	-1344(ra) # 8000353c <end_op>
  return -1;
    80004a84:	557d                	li	a0,-1
}
    80004a86:	70ae                	ld	ra,232(sp)
    80004a88:	740e                	ld	s0,224(sp)
    80004a8a:	64ee                	ld	s1,216(sp)
    80004a8c:	694e                	ld	s2,208(sp)
    80004a8e:	69ae                	ld	s3,200(sp)
    80004a90:	616d                	addi	sp,sp,240
    80004a92:	8082                	ret

0000000080004a94 <sys_open>:

uint64
sys_open(void)
{
    80004a94:	7131                	addi	sp,sp,-192
    80004a96:	fd06                	sd	ra,184(sp)
    80004a98:	f922                	sd	s0,176(sp)
    80004a9a:	f526                	sd	s1,168(sp)
    80004a9c:	f14a                	sd	s2,160(sp)
    80004a9e:	ed4e                	sd	s3,152(sp)
    80004aa0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004aa2:	08000613          	li	a2,128
    80004aa6:	f5040593          	addi	a1,s0,-176
    80004aaa:	4501                	li	a0,0
    80004aac:	ffffd097          	auipc	ra,0xffffd
    80004ab0:	512080e7          	jalr	1298(ra) # 80001fbe <argstr>
    return -1;
    80004ab4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ab6:	0c054163          	bltz	a0,80004b78 <sys_open+0xe4>
    80004aba:	f4c40593          	addi	a1,s0,-180
    80004abe:	4505                	li	a0,1
    80004ac0:	ffffd097          	auipc	ra,0xffffd
    80004ac4:	4ba080e7          	jalr	1210(ra) # 80001f7a <argint>
    80004ac8:	0a054863          	bltz	a0,80004b78 <sys_open+0xe4>

  begin_op();
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	9f0080e7          	jalr	-1552(ra) # 800034bc <begin_op>

  if(omode & O_CREATE){
    80004ad4:	f4c42783          	lw	a5,-180(s0)
    80004ad8:	2007f793          	andi	a5,a5,512
    80004adc:	cbdd                	beqz	a5,80004b92 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ade:	4681                	li	a3,0
    80004ae0:	4601                	li	a2,0
    80004ae2:	4589                	li	a1,2
    80004ae4:	f5040513          	addi	a0,s0,-176
    80004ae8:	00000097          	auipc	ra,0x0
    80004aec:	974080e7          	jalr	-1676(ra) # 8000445c <create>
    80004af0:	892a                	mv	s2,a0
    if(ip == 0){
    80004af2:	c959                	beqz	a0,80004b88 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004af4:	04491703          	lh	a4,68(s2)
    80004af8:	478d                	li	a5,3
    80004afa:	00f71763          	bne	a4,a5,80004b08 <sys_open+0x74>
    80004afe:	04695703          	lhu	a4,70(s2)
    80004b02:	47a5                	li	a5,9
    80004b04:	0ce7ec63          	bltu	a5,a4,80004bdc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	dc4080e7          	jalr	-572(ra) # 800038cc <filealloc>
    80004b10:	89aa                	mv	s3,a0
    80004b12:	10050263          	beqz	a0,80004c16 <sys_open+0x182>
    80004b16:	00000097          	auipc	ra,0x0
    80004b1a:	904080e7          	jalr	-1788(ra) # 8000441a <fdalloc>
    80004b1e:	84aa                	mv	s1,a0
    80004b20:	0e054663          	bltz	a0,80004c0c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b24:	04491703          	lh	a4,68(s2)
    80004b28:	478d                	li	a5,3
    80004b2a:	0cf70463          	beq	a4,a5,80004bf2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b2e:	4789                	li	a5,2
    80004b30:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b34:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004b38:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b3c:	f4c42783          	lw	a5,-180(s0)
    80004b40:	0017c713          	xori	a4,a5,1
    80004b44:	8b05                	andi	a4,a4,1
    80004b46:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b4a:	0037f713          	andi	a4,a5,3
    80004b4e:	00e03733          	snez	a4,a4
    80004b52:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b56:	4007f793          	andi	a5,a5,1024
    80004b5a:	c791                	beqz	a5,80004b66 <sys_open+0xd2>
    80004b5c:	04491703          	lh	a4,68(s2)
    80004b60:	4789                	li	a5,2
    80004b62:	08f70f63          	beq	a4,a5,80004c00 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b66:	854a                	mv	a0,s2
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	044080e7          	jalr	68(ra) # 80002bac <iunlock>
  end_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	9cc080e7          	jalr	-1588(ra) # 8000353c <end_op>

  return fd;
}
    80004b78:	8526                	mv	a0,s1
    80004b7a:	70ea                	ld	ra,184(sp)
    80004b7c:	744a                	ld	s0,176(sp)
    80004b7e:	74aa                	ld	s1,168(sp)
    80004b80:	790a                	ld	s2,160(sp)
    80004b82:	69ea                	ld	s3,152(sp)
    80004b84:	6129                	addi	sp,sp,192
    80004b86:	8082                	ret
      end_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	9b4080e7          	jalr	-1612(ra) # 8000353c <end_op>
      return -1;
    80004b90:	b7e5                	j	80004b78 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b92:	f5040513          	addi	a0,s0,-176
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	70a080e7          	jalr	1802(ra) # 800032a0 <namei>
    80004b9e:	892a                	mv	s2,a0
    80004ba0:	c905                	beqz	a0,80004bd0 <sys_open+0x13c>
    ilock(ip);
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	f48080e7          	jalr	-184(ra) # 80002aea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004baa:	04491703          	lh	a4,68(s2)
    80004bae:	4785                	li	a5,1
    80004bb0:	f4f712e3          	bne	a4,a5,80004af4 <sys_open+0x60>
    80004bb4:	f4c42783          	lw	a5,-180(s0)
    80004bb8:	dba1                	beqz	a5,80004b08 <sys_open+0x74>
      iunlockput(ip);
    80004bba:	854a                	mv	a0,s2
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	190080e7          	jalr	400(ra) # 80002d4c <iunlockput>
      end_op();
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	978080e7          	jalr	-1672(ra) # 8000353c <end_op>
      return -1;
    80004bcc:	54fd                	li	s1,-1
    80004bce:	b76d                	j	80004b78 <sys_open+0xe4>
      end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	96c080e7          	jalr	-1684(ra) # 8000353c <end_op>
      return -1;
    80004bd8:	54fd                	li	s1,-1
    80004bda:	bf79                	j	80004b78 <sys_open+0xe4>
    iunlockput(ip);
    80004bdc:	854a                	mv	a0,s2
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	16e080e7          	jalr	366(ra) # 80002d4c <iunlockput>
    end_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	956080e7          	jalr	-1706(ra) # 8000353c <end_op>
    return -1;
    80004bee:	54fd                	li	s1,-1
    80004bf0:	b761                	j	80004b78 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bf2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bf6:	04691783          	lh	a5,70(s2)
    80004bfa:	02f99623          	sh	a5,44(s3)
    80004bfe:	bf2d                	j	80004b38 <sys_open+0xa4>
    itrunc(ip);
    80004c00:	854a                	mv	a0,s2
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	ff6080e7          	jalr	-10(ra) # 80002bf8 <itrunc>
    80004c0a:	bfb1                	j	80004b66 <sys_open+0xd2>
      fileclose(f);
    80004c0c:	854e                	mv	a0,s3
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	d7a080e7          	jalr	-646(ra) # 80003988 <fileclose>
    iunlockput(ip);
    80004c16:	854a                	mv	a0,s2
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	134080e7          	jalr	308(ra) # 80002d4c <iunlockput>
    end_op();
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	91c080e7          	jalr	-1764(ra) # 8000353c <end_op>
    return -1;
    80004c28:	54fd                	li	s1,-1
    80004c2a:	b7b9                	j	80004b78 <sys_open+0xe4>

0000000080004c2c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c2c:	7175                	addi	sp,sp,-144
    80004c2e:	e506                	sd	ra,136(sp)
    80004c30:	e122                	sd	s0,128(sp)
    80004c32:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	888080e7          	jalr	-1912(ra) # 800034bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c3c:	08000613          	li	a2,128
    80004c40:	f7040593          	addi	a1,s0,-144
    80004c44:	4501                	li	a0,0
    80004c46:	ffffd097          	auipc	ra,0xffffd
    80004c4a:	378080e7          	jalr	888(ra) # 80001fbe <argstr>
    80004c4e:	02054963          	bltz	a0,80004c80 <sys_mkdir+0x54>
    80004c52:	4681                	li	a3,0
    80004c54:	4601                	li	a2,0
    80004c56:	4585                	li	a1,1
    80004c58:	f7040513          	addi	a0,s0,-144
    80004c5c:	00000097          	auipc	ra,0x0
    80004c60:	800080e7          	jalr	-2048(ra) # 8000445c <create>
    80004c64:	cd11                	beqz	a0,80004c80 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	0e6080e7          	jalr	230(ra) # 80002d4c <iunlockput>
  end_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	8ce080e7          	jalr	-1842(ra) # 8000353c <end_op>
  return 0;
    80004c76:	4501                	li	a0,0
}
    80004c78:	60aa                	ld	ra,136(sp)
    80004c7a:	640a                	ld	s0,128(sp)
    80004c7c:	6149                	addi	sp,sp,144
    80004c7e:	8082                	ret
    end_op();
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	8bc080e7          	jalr	-1860(ra) # 8000353c <end_op>
    return -1;
    80004c88:	557d                	li	a0,-1
    80004c8a:	b7fd                	j	80004c78 <sys_mkdir+0x4c>

0000000080004c8c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c8c:	7135                	addi	sp,sp,-160
    80004c8e:	ed06                	sd	ra,152(sp)
    80004c90:	e922                	sd	s0,144(sp)
    80004c92:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	828080e7          	jalr	-2008(ra) # 800034bc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c9c:	08000613          	li	a2,128
    80004ca0:	f7040593          	addi	a1,s0,-144
    80004ca4:	4501                	li	a0,0
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	318080e7          	jalr	792(ra) # 80001fbe <argstr>
    80004cae:	04054a63          	bltz	a0,80004d02 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cb2:	f6c40593          	addi	a1,s0,-148
    80004cb6:	4505                	li	a0,1
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	2c2080e7          	jalr	706(ra) # 80001f7a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc0:	04054163          	bltz	a0,80004d02 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cc4:	f6840593          	addi	a1,s0,-152
    80004cc8:	4509                	li	a0,2
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	2b0080e7          	jalr	688(ra) # 80001f7a <argint>
     argint(1, &major) < 0 ||
    80004cd2:	02054863          	bltz	a0,80004d02 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cd6:	f6841683          	lh	a3,-152(s0)
    80004cda:	f6c41603          	lh	a2,-148(s0)
    80004cde:	458d                	li	a1,3
    80004ce0:	f7040513          	addi	a0,s0,-144
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	778080e7          	jalr	1912(ra) # 8000445c <create>
     argint(2, &minor) < 0 ||
    80004cec:	c919                	beqz	a0,80004d02 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	05e080e7          	jalr	94(ra) # 80002d4c <iunlockput>
  end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	846080e7          	jalr	-1978(ra) # 8000353c <end_op>
  return 0;
    80004cfe:	4501                	li	a0,0
    80004d00:	a031                	j	80004d0c <sys_mknod+0x80>
    end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	83a080e7          	jalr	-1990(ra) # 8000353c <end_op>
    return -1;
    80004d0a:	557d                	li	a0,-1
}
    80004d0c:	60ea                	ld	ra,152(sp)
    80004d0e:	644a                	ld	s0,144(sp)
    80004d10:	610d                	addi	sp,sp,160
    80004d12:	8082                	ret

0000000080004d14 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d14:	7135                	addi	sp,sp,-160
    80004d16:	ed06                	sd	ra,152(sp)
    80004d18:	e922                	sd	s0,144(sp)
    80004d1a:	e526                	sd	s1,136(sp)
    80004d1c:	e14a                	sd	s2,128(sp)
    80004d1e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d20:	ffffc097          	auipc	ra,0xffffc
    80004d24:	17a080e7          	jalr	378(ra) # 80000e9a <myproc>
    80004d28:	892a                	mv	s2,a0
  
  begin_op();
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	792080e7          	jalr	1938(ra) # 800034bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d32:	08000613          	li	a2,128
    80004d36:	f6040593          	addi	a1,s0,-160
    80004d3a:	4501                	li	a0,0
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	282080e7          	jalr	642(ra) # 80001fbe <argstr>
    80004d44:	04054b63          	bltz	a0,80004d9a <sys_chdir+0x86>
    80004d48:	f6040513          	addi	a0,s0,-160
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	554080e7          	jalr	1364(ra) # 800032a0 <namei>
    80004d54:	84aa                	mv	s1,a0
    80004d56:	c131                	beqz	a0,80004d9a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	d92080e7          	jalr	-622(ra) # 80002aea <ilock>
  if(ip->type != T_DIR){
    80004d60:	04449703          	lh	a4,68(s1)
    80004d64:	4785                	li	a5,1
    80004d66:	04f71063          	bne	a4,a5,80004da6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	e40080e7          	jalr	-448(ra) # 80002bac <iunlock>
  iput(p->cwd);
    80004d74:	15093503          	ld	a0,336(s2)
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	f2c080e7          	jalr	-212(ra) # 80002ca4 <iput>
  end_op();
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	7bc080e7          	jalr	1980(ra) # 8000353c <end_op>
  p->cwd = ip;
    80004d88:	14993823          	sd	s1,336(s2)
  return 0;
    80004d8c:	4501                	li	a0,0
}
    80004d8e:	60ea                	ld	ra,152(sp)
    80004d90:	644a                	ld	s0,144(sp)
    80004d92:	64aa                	ld	s1,136(sp)
    80004d94:	690a                	ld	s2,128(sp)
    80004d96:	610d                	addi	sp,sp,160
    80004d98:	8082                	ret
    end_op();
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	7a2080e7          	jalr	1954(ra) # 8000353c <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	b7ed                	j	80004d8e <sys_chdir+0x7a>
    iunlockput(ip);
    80004da6:	8526                	mv	a0,s1
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	fa4080e7          	jalr	-92(ra) # 80002d4c <iunlockput>
    end_op();
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	78c080e7          	jalr	1932(ra) # 8000353c <end_op>
    return -1;
    80004db8:	557d                	li	a0,-1
    80004dba:	bfd1                	j	80004d8e <sys_chdir+0x7a>

0000000080004dbc <sys_exec>:

uint64
sys_exec(void)
{
    80004dbc:	7145                	addi	sp,sp,-464
    80004dbe:	e786                	sd	ra,456(sp)
    80004dc0:	e3a2                	sd	s0,448(sp)
    80004dc2:	ff26                	sd	s1,440(sp)
    80004dc4:	fb4a                	sd	s2,432(sp)
    80004dc6:	f74e                	sd	s3,424(sp)
    80004dc8:	f352                	sd	s4,416(sp)
    80004dca:	ef56                	sd	s5,408(sp)
    80004dcc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004dce:	08000613          	li	a2,128
    80004dd2:	f4040593          	addi	a1,s0,-192
    80004dd6:	4501                	li	a0,0
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	1e6080e7          	jalr	486(ra) # 80001fbe <argstr>
    return -1;
    80004de0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004de2:	0c054a63          	bltz	a0,80004eb6 <sys_exec+0xfa>
    80004de6:	e3840593          	addi	a1,s0,-456
    80004dea:	4505                	li	a0,1
    80004dec:	ffffd097          	auipc	ra,0xffffd
    80004df0:	1b0080e7          	jalr	432(ra) # 80001f9c <argaddr>
    80004df4:	0c054163          	bltz	a0,80004eb6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004df8:	10000613          	li	a2,256
    80004dfc:	4581                	li	a1,0
    80004dfe:	e4040513          	addi	a0,s0,-448
    80004e02:	ffffb097          	auipc	ra,0xffffb
    80004e06:	376080e7          	jalr	886(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e0a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e0e:	89a6                	mv	s3,s1
    80004e10:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e12:	02000a13          	li	s4,32
    80004e16:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e1a:	00391793          	slli	a5,s2,0x3
    80004e1e:	e3040593          	addi	a1,s0,-464
    80004e22:	e3843503          	ld	a0,-456(s0)
    80004e26:	953e                	add	a0,a0,a5
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	0b8080e7          	jalr	184(ra) # 80001ee0 <fetchaddr>
    80004e30:	02054a63          	bltz	a0,80004e64 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e34:	e3043783          	ld	a5,-464(s0)
    80004e38:	c3b9                	beqz	a5,80004e7e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e3a:	ffffb097          	auipc	ra,0xffffb
    80004e3e:	2de080e7          	jalr	734(ra) # 80000118 <kalloc>
    80004e42:	85aa                	mv	a1,a0
    80004e44:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e48:	cd11                	beqz	a0,80004e64 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e4a:	6605                	lui	a2,0x1
    80004e4c:	e3043503          	ld	a0,-464(s0)
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	0e2080e7          	jalr	226(ra) # 80001f32 <fetchstr>
    80004e58:	00054663          	bltz	a0,80004e64 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e5c:	0905                	addi	s2,s2,1
    80004e5e:	09a1                	addi	s3,s3,8
    80004e60:	fb491be3          	bne	s2,s4,80004e16 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e64:	10048913          	addi	s2,s1,256
    80004e68:	6088                	ld	a0,0(s1)
    80004e6a:	c529                	beqz	a0,80004eb4 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e6c:	ffffb097          	auipc	ra,0xffffb
    80004e70:	1b0080e7          	jalr	432(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e74:	04a1                	addi	s1,s1,8
    80004e76:	ff2499e3          	bne	s1,s2,80004e68 <sys_exec+0xac>
  return -1;
    80004e7a:	597d                	li	s2,-1
    80004e7c:	a82d                	j	80004eb6 <sys_exec+0xfa>
      argv[i] = 0;
    80004e7e:	0a8e                	slli	s5,s5,0x3
    80004e80:	fc040793          	addi	a5,s0,-64
    80004e84:	9abe                	add	s5,s5,a5
    80004e86:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7900>
  int ret = exec(path, argv);
    80004e8a:	e4040593          	addi	a1,s0,-448
    80004e8e:	f4040513          	addi	a0,s0,-192
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	178080e7          	jalr	376(ra) # 8000400a <exec>
    80004e9a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9c:	10048993          	addi	s3,s1,256
    80004ea0:	6088                	ld	a0,0(s1)
    80004ea2:	c911                	beqz	a0,80004eb6 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ea4:	ffffb097          	auipc	ra,0xffffb
    80004ea8:	178080e7          	jalr	376(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eac:	04a1                	addi	s1,s1,8
    80004eae:	ff3499e3          	bne	s1,s3,80004ea0 <sys_exec+0xe4>
    80004eb2:	a011                	j	80004eb6 <sys_exec+0xfa>
  return -1;
    80004eb4:	597d                	li	s2,-1
}
    80004eb6:	854a                	mv	a0,s2
    80004eb8:	60be                	ld	ra,456(sp)
    80004eba:	641e                	ld	s0,448(sp)
    80004ebc:	74fa                	ld	s1,440(sp)
    80004ebe:	795a                	ld	s2,432(sp)
    80004ec0:	79ba                	ld	s3,424(sp)
    80004ec2:	7a1a                	ld	s4,416(sp)
    80004ec4:	6afa                	ld	s5,408(sp)
    80004ec6:	6179                	addi	sp,sp,464
    80004ec8:	8082                	ret

0000000080004eca <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eca:	7139                	addi	sp,sp,-64
    80004ecc:	fc06                	sd	ra,56(sp)
    80004ece:	f822                	sd	s0,48(sp)
    80004ed0:	f426                	sd	s1,40(sp)
    80004ed2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ed4:	ffffc097          	auipc	ra,0xffffc
    80004ed8:	fc6080e7          	jalr	-58(ra) # 80000e9a <myproc>
    80004edc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004ede:	fd840593          	addi	a1,s0,-40
    80004ee2:	4501                	li	a0,0
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	0b8080e7          	jalr	184(ra) # 80001f9c <argaddr>
    return -1;
    80004eec:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004eee:	0e054063          	bltz	a0,80004fce <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ef2:	fc840593          	addi	a1,s0,-56
    80004ef6:	fd040513          	addi	a0,s0,-48
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	dee080e7          	jalr	-530(ra) # 80003ce8 <pipealloc>
    return -1;
    80004f02:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f04:	0c054563          	bltz	a0,80004fce <sys_pipe+0x104>
  fd0 = -1;
    80004f08:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f0c:	fd043503          	ld	a0,-48(s0)
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	50a080e7          	jalr	1290(ra) # 8000441a <fdalloc>
    80004f18:	fca42223          	sw	a0,-60(s0)
    80004f1c:	08054c63          	bltz	a0,80004fb4 <sys_pipe+0xea>
    80004f20:	fc843503          	ld	a0,-56(s0)
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	4f6080e7          	jalr	1270(ra) # 8000441a <fdalloc>
    80004f2c:	fca42023          	sw	a0,-64(s0)
    80004f30:	06054863          	bltz	a0,80004fa0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f34:	4691                	li	a3,4
    80004f36:	fc440613          	addi	a2,s0,-60
    80004f3a:	fd843583          	ld	a1,-40(s0)
    80004f3e:	68a8                	ld	a0,80(s1)
    80004f40:	ffffc097          	auipc	ra,0xffffc
    80004f44:	c1e080e7          	jalr	-994(ra) # 80000b5e <copyout>
    80004f48:	02054063          	bltz	a0,80004f68 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f4c:	4691                	li	a3,4
    80004f4e:	fc040613          	addi	a2,s0,-64
    80004f52:	fd843583          	ld	a1,-40(s0)
    80004f56:	0591                	addi	a1,a1,4
    80004f58:	68a8                	ld	a0,80(s1)
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	c04080e7          	jalr	-1020(ra) # 80000b5e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f62:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f64:	06055563          	bgez	a0,80004fce <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f68:	fc442783          	lw	a5,-60(s0)
    80004f6c:	07e9                	addi	a5,a5,26
    80004f6e:	078e                	slli	a5,a5,0x3
    80004f70:	97a6                	add	a5,a5,s1
    80004f72:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f76:	fc042503          	lw	a0,-64(s0)
    80004f7a:	0569                	addi	a0,a0,26
    80004f7c:	050e                	slli	a0,a0,0x3
    80004f7e:	9526                	add	a0,a0,s1
    80004f80:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f84:	fd043503          	ld	a0,-48(s0)
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	a00080e7          	jalr	-1536(ra) # 80003988 <fileclose>
    fileclose(wf);
    80004f90:	fc843503          	ld	a0,-56(s0)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	9f4080e7          	jalr	-1548(ra) # 80003988 <fileclose>
    return -1;
    80004f9c:	57fd                	li	a5,-1
    80004f9e:	a805                	j	80004fce <sys_pipe+0x104>
    if(fd0 >= 0)
    80004fa0:	fc442783          	lw	a5,-60(s0)
    80004fa4:	0007c863          	bltz	a5,80004fb4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fa8:	01a78513          	addi	a0,a5,26
    80004fac:	050e                	slli	a0,a0,0x3
    80004fae:	9526                	add	a0,a0,s1
    80004fb0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fb4:	fd043503          	ld	a0,-48(s0)
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	9d0080e7          	jalr	-1584(ra) # 80003988 <fileclose>
    fileclose(wf);
    80004fc0:	fc843503          	ld	a0,-56(s0)
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	9c4080e7          	jalr	-1596(ra) # 80003988 <fileclose>
    return -1;
    80004fcc:	57fd                	li	a5,-1
}
    80004fce:	853e                	mv	a0,a5
    80004fd0:	70e2                	ld	ra,56(sp)
    80004fd2:	7442                	ld	s0,48(sp)
    80004fd4:	74a2                	ld	s1,40(sp)
    80004fd6:	6121                	addi	sp,sp,64
    80004fd8:	8082                	ret

0000000080004fda <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    80004fda:	7179                	addi	sp,sp,-48
    80004fdc:	f406                	sd	ra,40(sp)
    80004fde:	f022                	sd	s0,32(sp)
    80004fe0:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
    80004fe2:	fe440593          	addi	a1,s0,-28
    80004fe6:	4501                	li	a0,0
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	f92080e7          	jalr	-110(ra) # 80001f7a <argint>
    80004ff0:	06054663          	bltz	a0,8000505c <sys_connect+0x82>
      argint(1, (int*)&lport) < 0 ||
    80004ff4:	fdc40593          	addi	a1,s0,-36
    80004ff8:	4505                	li	a0,1
    80004ffa:	ffffd097          	auipc	ra,0xffffd
    80004ffe:	f80080e7          	jalr	-128(ra) # 80001f7a <argint>
  if (argint(0, (int*)&raddr) < 0 ||
    80005002:	04054f63          	bltz	a0,80005060 <sys_connect+0x86>
      argint(2, (int*)&rport) < 0) {
    80005006:	fe040593          	addi	a1,s0,-32
    8000500a:	4509                	li	a0,2
    8000500c:	ffffd097          	auipc	ra,0xffffd
    80005010:	f6e080e7          	jalr	-146(ra) # 80001f7a <argint>
      argint(1, (int*)&lport) < 0 ||
    80005014:	04054863          	bltz	a0,80005064 <sys_connect+0x8a>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
    80005018:	fe045683          	lhu	a3,-32(s0)
    8000501c:	fdc45603          	lhu	a2,-36(s0)
    80005020:	fe442583          	lw	a1,-28(s0)
    80005024:	fe840513          	addi	a0,s0,-24
    80005028:	00001097          	auipc	ra,0x1
    8000502c:	218080e7          	jalr	536(ra) # 80006240 <sockalloc>
    80005030:	02054c63          	bltz	a0,80005068 <sys_connect+0x8e>
    return -1;
  if((fd=fdalloc(f)) < 0){
    80005034:	fe843503          	ld	a0,-24(s0)
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	3e2080e7          	jalr	994(ra) # 8000441a <fdalloc>
    80005040:	00054663          	bltz	a0,8000504c <sys_connect+0x72>
    fileclose(f);
    return -1;
  }

  return fd;
}
    80005044:	70a2                	ld	ra,40(sp)
    80005046:	7402                	ld	s0,32(sp)
    80005048:	6145                	addi	sp,sp,48
    8000504a:	8082                	ret
    fileclose(f);
    8000504c:	fe843503          	ld	a0,-24(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	938080e7          	jalr	-1736(ra) # 80003988 <fileclose>
    return -1;
    80005058:	557d                	li	a0,-1
    8000505a:	b7ed                	j	80005044 <sys_connect+0x6a>
    return -1;
    8000505c:	557d                	li	a0,-1
    8000505e:	b7dd                	j	80005044 <sys_connect+0x6a>
    80005060:	557d                	li	a0,-1
    80005062:	b7cd                	j	80005044 <sys_connect+0x6a>
    80005064:	557d                	li	a0,-1
    80005066:	bff9                	j	80005044 <sys_connect+0x6a>
    return -1;
    80005068:	557d                	li	a0,-1
    8000506a:	bfe9                	j	80005044 <sys_connect+0x6a>
    8000506c:	0000                	unimp
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
    800050b0:	cfdfc0ef          	jal	ra,80001dac <kerneltrap>
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
    8000513a:	0791                	addi	a5,a5,4
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    8000513c:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    8000513e:	0c000737          	lui	a4,0xc000
    80005142:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    80005146:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    80005148:	0791                	addi	a5,a5,4
    8000514a:	fee79ee3          	bne	a5,a4,80005146 <plicinit+0x1c>
  }
#endif  
}
    8000514e:	6422                	ld	s0,8(sp)
    80005150:	0141                	addi	sp,sp,16
    80005152:	8082                	ret

0000000080005154 <plicinithart>:

void
plicinithart(void)
{
    80005154:	1141                	addi	sp,sp,-16
    80005156:	e406                	sd	ra,8(sp)
    80005158:	e022                	sd	s0,0(sp)
    8000515a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	d12080e7          	jalr	-750(ra) # 80000e6e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005164:	0085171b          	slliw	a4,a0,0x8
    80005168:	0c0027b7          	lui	a5,0xc002
    8000516c:	97ba                	add	a5,a5,a4
    8000516e:	40200713          	li	a4,1026
    80005172:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80005176:	577d                	li	a4,-1
    80005178:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000517c:	00d5151b          	slliw	a0,a0,0xd
    80005180:	0c2017b7          	lui	a5,0xc201
    80005184:	953e                	add	a0,a0,a5
    80005186:	00052023          	sw	zero,0(a0)
}
    8000518a:	60a2                	ld	ra,8(sp)
    8000518c:	6402                	ld	s0,0(sp)
    8000518e:	0141                	addi	sp,sp,16
    80005190:	8082                	ret

0000000080005192 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005192:	1141                	addi	sp,sp,-16
    80005194:	e406                	sd	ra,8(sp)
    80005196:	e022                	sd	s0,0(sp)
    80005198:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000519a:	ffffc097          	auipc	ra,0xffffc
    8000519e:	cd4080e7          	jalr	-812(ra) # 80000e6e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a2:	00d5179b          	slliw	a5,a0,0xd
    800051a6:	0c201537          	lui	a0,0xc201
    800051aa:	953e                	add	a0,a0,a5
  return irq;
}
    800051ac:	4148                	lw	a0,4(a0)
    800051ae:	60a2                	ld	ra,8(sp)
    800051b0:	6402                	ld	s0,0(sp)
    800051b2:	0141                	addi	sp,sp,16
    800051b4:	8082                	ret

00000000800051b6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051b6:	1101                	addi	sp,sp,-32
    800051b8:	ec06                	sd	ra,24(sp)
    800051ba:	e822                	sd	s0,16(sp)
    800051bc:	e426                	sd	s1,8(sp)
    800051be:	1000                	addi	s0,sp,32
    800051c0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	cac080e7          	jalr	-852(ra) # 80000e6e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051ca:	00d5151b          	slliw	a0,a0,0xd
    800051ce:	0c2017b7          	lui	a5,0xc201
    800051d2:	97aa                	add	a5,a5,a0
    800051d4:	c3c4                	sw	s1,4(a5)
}
    800051d6:	60e2                	ld	ra,24(sp)
    800051d8:	6442                	ld	s0,16(sp)
    800051da:	64a2                	ld	s1,8(sp)
    800051dc:	6105                	addi	sp,sp,32
    800051de:	8082                	ret

00000000800051e0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e0:	1141                	addi	sp,sp,-16
    800051e2:	e406                	sd	ra,8(sp)
    800051e4:	e022                	sd	s0,0(sp)
    800051e6:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051e8:	479d                	li	a5,7
    800051ea:	06a7c963          	blt	a5,a0,8000525c <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051ee:	00017797          	auipc	a5,0x17
    800051f2:	e1278793          	addi	a5,a5,-494 # 8001c000 <disk>
    800051f6:	00a78733          	add	a4,a5,a0
    800051fa:	6789                	lui	a5,0x2
    800051fc:	97ba                	add	a5,a5,a4
    800051fe:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005202:	e7ad                	bnez	a5,8000526c <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005204:	00451793          	slli	a5,a0,0x4
    80005208:	00019717          	auipc	a4,0x19
    8000520c:	df870713          	addi	a4,a4,-520 # 8001e000 <disk+0x2000>
    80005210:	6314                	ld	a3,0(a4)
    80005212:	96be                	add	a3,a3,a5
    80005214:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005218:	6314                	ld	a3,0(a4)
    8000521a:	96be                	add	a3,a3,a5
    8000521c:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005220:	6314                	ld	a3,0(a4)
    80005222:	96be                	add	a3,a3,a5
    80005224:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005228:	6318                	ld	a4,0(a4)
    8000522a:	97ba                	add	a5,a5,a4
    8000522c:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005230:	00017797          	auipc	a5,0x17
    80005234:	dd078793          	addi	a5,a5,-560 # 8001c000 <disk>
    80005238:	97aa                	add	a5,a5,a0
    8000523a:	6509                	lui	a0,0x2
    8000523c:	953e                	add	a0,a0,a5
    8000523e:	4785                	li	a5,1
    80005240:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005244:	00019517          	auipc	a0,0x19
    80005248:	dd450513          	addi	a0,a0,-556 # 8001e018 <disk+0x2018>
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	49a080e7          	jalr	1178(ra) # 800016e6 <wakeup>
}
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret
    panic("free_desc 1");
    8000525c:	00004517          	auipc	a0,0x4
    80005260:	4dc50513          	addi	a0,a0,1244 # 80009738 <syscalls+0x360>
    80005264:	00002097          	auipc	ra,0x2
    80005268:	966080e7          	jalr	-1690(ra) # 80006bca <panic>
    panic("free_desc 2");
    8000526c:	00004517          	auipc	a0,0x4
    80005270:	4dc50513          	addi	a0,a0,1244 # 80009748 <syscalls+0x370>
    80005274:	00002097          	auipc	ra,0x2
    80005278:	956080e7          	jalr	-1706(ra) # 80006bca <panic>

000000008000527c <virtio_disk_init>:
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005286:	00004597          	auipc	a1,0x4
    8000528a:	4d258593          	addi	a1,a1,1234 # 80009758 <syscalls+0x380>
    8000528e:	00019517          	auipc	a0,0x19
    80005292:	e9a50513          	addi	a0,a0,-358 # 8001e128 <disk+0x2128>
    80005296:	00002097          	auipc	ra,0x2
    8000529a:	de0080e7          	jalr	-544(ra) # 80007076 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000529e:	100017b7          	lui	a5,0x10001
    800052a2:	4398                	lw	a4,0(a5)
    800052a4:	2701                	sext.w	a4,a4
    800052a6:	747277b7          	lui	a5,0x74727
    800052aa:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ae:	0ef71163          	bne	a4,a5,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b2:	100017b7          	lui	a5,0x10001
    800052b6:	43dc                	lw	a5,4(a5)
    800052b8:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ba:	4705                	li	a4,1
    800052bc:	0ce79a63          	bne	a5,a4,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c0:	100017b7          	lui	a5,0x10001
    800052c4:	479c                	lw	a5,8(a5)
    800052c6:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	4709                	li	a4,2
    800052ca:	0ce79363          	bne	a5,a4,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	47d8                	lw	a4,12(a5)
    800052d4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	554d47b7          	lui	a5,0x554d4
    800052da:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052de:	0af71963          	bne	a4,a5,80005390 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e2:	100017b7          	lui	a5,0x10001
    800052e6:	4705                	li	a4,1
    800052e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ea:	470d                	li	a4,3
    800052ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052ee:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052f0:	c7ffe737          	lui	a4,0xc7ffe
    800052f4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd71df>
    800052f8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052fa:	2701                	sext.w	a4,a4
    800052fc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	472d                	li	a4,11
    80005300:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005302:	473d                	li	a4,15
    80005304:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005306:	6705                	lui	a4,0x1
    80005308:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000530a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000530e:	5bdc                	lw	a5,52(a5)
    80005310:	2781                	sext.w	a5,a5
  if(max == 0)
    80005312:	c7d9                	beqz	a5,800053a0 <virtio_disk_init+0x124>
  if(max < NUM)
    80005314:	471d                	li	a4,7
    80005316:	08f77d63          	bgeu	a4,a5,800053b0 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000531a:	100014b7          	lui	s1,0x10001
    8000531e:	47a1                	li	a5,8
    80005320:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005322:	6609                	lui	a2,0x2
    80005324:	4581                	li	a1,0
    80005326:	00017517          	auipc	a0,0x17
    8000532a:	cda50513          	addi	a0,a0,-806 # 8001c000 <disk>
    8000532e:	ffffb097          	auipc	ra,0xffffb
    80005332:	e4a080e7          	jalr	-438(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005336:	00017717          	auipc	a4,0x17
    8000533a:	cca70713          	addi	a4,a4,-822 # 8001c000 <disk>
    8000533e:	00c75793          	srli	a5,a4,0xc
    80005342:	2781                	sext.w	a5,a5
    80005344:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005346:	00019797          	auipc	a5,0x19
    8000534a:	cba78793          	addi	a5,a5,-838 # 8001e000 <disk+0x2000>
    8000534e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005350:	00017717          	auipc	a4,0x17
    80005354:	d3070713          	addi	a4,a4,-720 # 8001c080 <disk+0x80>
    80005358:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000535a:	00018717          	auipc	a4,0x18
    8000535e:	ca670713          	addi	a4,a4,-858 # 8001d000 <disk+0x1000>
    80005362:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005364:	4705                	li	a4,1
    80005366:	00e78c23          	sb	a4,24(a5)
    8000536a:	00e78ca3          	sb	a4,25(a5)
    8000536e:	00e78d23          	sb	a4,26(a5)
    80005372:	00e78da3          	sb	a4,27(a5)
    80005376:	00e78e23          	sb	a4,28(a5)
    8000537a:	00e78ea3          	sb	a4,29(a5)
    8000537e:	00e78f23          	sb	a4,30(a5)
    80005382:	00e78fa3          	sb	a4,31(a5)
}
    80005386:	60e2                	ld	ra,24(sp)
    80005388:	6442                	ld	s0,16(sp)
    8000538a:	64a2                	ld	s1,8(sp)
    8000538c:	6105                	addi	sp,sp,32
    8000538e:	8082                	ret
    panic("could not find virtio disk");
    80005390:	00004517          	auipc	a0,0x4
    80005394:	3d850513          	addi	a0,a0,984 # 80009768 <syscalls+0x390>
    80005398:	00002097          	auipc	ra,0x2
    8000539c:	832080e7          	jalr	-1998(ra) # 80006bca <panic>
    panic("virtio disk has no queue 0");
    800053a0:	00004517          	auipc	a0,0x4
    800053a4:	3e850513          	addi	a0,a0,1000 # 80009788 <syscalls+0x3b0>
    800053a8:	00002097          	auipc	ra,0x2
    800053ac:	822080e7          	jalr	-2014(ra) # 80006bca <panic>
    panic("virtio disk max queue too short");
    800053b0:	00004517          	auipc	a0,0x4
    800053b4:	3f850513          	addi	a0,a0,1016 # 800097a8 <syscalls+0x3d0>
    800053b8:	00002097          	auipc	ra,0x2
    800053bc:	812080e7          	jalr	-2030(ra) # 80006bca <panic>

00000000800053c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053c0:	7119                	addi	sp,sp,-128
    800053c2:	fc86                	sd	ra,120(sp)
    800053c4:	f8a2                	sd	s0,112(sp)
    800053c6:	f4a6                	sd	s1,104(sp)
    800053c8:	f0ca                	sd	s2,96(sp)
    800053ca:	ecce                	sd	s3,88(sp)
    800053cc:	e8d2                	sd	s4,80(sp)
    800053ce:	e4d6                	sd	s5,72(sp)
    800053d0:	e0da                	sd	s6,64(sp)
    800053d2:	fc5e                	sd	s7,56(sp)
    800053d4:	f862                	sd	s8,48(sp)
    800053d6:	f466                	sd	s9,40(sp)
    800053d8:	f06a                	sd	s10,32(sp)
    800053da:	ec6e                	sd	s11,24(sp)
    800053dc:	0100                	addi	s0,sp,128
    800053de:	8aaa                	mv	s5,a0
    800053e0:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053e2:	00c52c83          	lw	s9,12(a0)
    800053e6:	001c9c9b          	slliw	s9,s9,0x1
    800053ea:	1c82                	slli	s9,s9,0x20
    800053ec:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053f0:	00019517          	auipc	a0,0x19
    800053f4:	d3850513          	addi	a0,a0,-712 # 8001e128 <disk+0x2128>
    800053f8:	00002097          	auipc	ra,0x2
    800053fc:	d0e080e7          	jalr	-754(ra) # 80007106 <acquire>
  for(int i = 0; i < 3; i++){
    80005400:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005402:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005404:	00017c17          	auipc	s8,0x17
    80005408:	bfcc0c13          	addi	s8,s8,-1028 # 8001c000 <disk>
    8000540c:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000540e:	4b0d                	li	s6,3
    80005410:	a0ad                	j	8000547a <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005412:	00fc0733          	add	a4,s8,a5
    80005416:	975e                	add	a4,a4,s7
    80005418:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000541c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000541e:	0207c563          	bltz	a5,80005448 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005422:	2905                	addiw	s2,s2,1
    80005424:	0611                	addi	a2,a2,4
    80005426:	19690d63          	beq	s2,s6,800055c0 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    8000542a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000542c:	00019717          	auipc	a4,0x19
    80005430:	bec70713          	addi	a4,a4,-1044 # 8001e018 <disk+0x2018>
    80005434:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005436:	00074683          	lbu	a3,0(a4)
    8000543a:	fee1                	bnez	a3,80005412 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000543c:	2785                	addiw	a5,a5,1
    8000543e:	0705                	addi	a4,a4,1
    80005440:	fe979be3          	bne	a5,s1,80005436 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005444:	57fd                	li	a5,-1
    80005446:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005448:	01205d63          	blez	s2,80005462 <virtio_disk_rw+0xa2>
    8000544c:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000544e:	000a2503          	lw	a0,0(s4)
    80005452:	00000097          	auipc	ra,0x0
    80005456:	d8e080e7          	jalr	-626(ra) # 800051e0 <free_desc>
      for(int j = 0; j < i; j++)
    8000545a:	2d85                	addiw	s11,s11,1
    8000545c:	0a11                	addi	s4,s4,4
    8000545e:	ffb918e3          	bne	s2,s11,8000544e <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005462:	00019597          	auipc	a1,0x19
    80005466:	cc658593          	addi	a1,a1,-826 # 8001e128 <disk+0x2128>
    8000546a:	00019517          	auipc	a0,0x19
    8000546e:	bae50513          	addi	a0,a0,-1106 # 8001e018 <disk+0x2018>
    80005472:	ffffc097          	auipc	ra,0xffffc
    80005476:	0e8080e7          	jalr	232(ra) # 8000155a <sleep>
  for(int i = 0; i < 3; i++){
    8000547a:	f8040a13          	addi	s4,s0,-128
{
    8000547e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005480:	894e                	mv	s2,s3
    80005482:	b765                	j	8000542a <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005484:	00019697          	auipc	a3,0x19
    80005488:	b7c6b683          	ld	a3,-1156(a3) # 8001e000 <disk+0x2000>
    8000548c:	96ba                	add	a3,a3,a4
    8000548e:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005492:	00017817          	auipc	a6,0x17
    80005496:	b6e80813          	addi	a6,a6,-1170 # 8001c000 <disk>
    8000549a:	00019697          	auipc	a3,0x19
    8000549e:	b6668693          	addi	a3,a3,-1178 # 8001e000 <disk+0x2000>
    800054a2:	6290                	ld	a2,0(a3)
    800054a4:	963a                	add	a2,a2,a4
    800054a6:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800054aa:	0015e593          	ori	a1,a1,1
    800054ae:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054b2:	f8842603          	lw	a2,-120(s0)
    800054b6:	628c                	ld	a1,0(a3)
    800054b8:	972e                	add	a4,a4,a1
    800054ba:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054be:	20050593          	addi	a1,a0,512
    800054c2:	0592                	slli	a1,a1,0x4
    800054c4:	95c2                	add	a1,a1,a6
    800054c6:	577d                	li	a4,-1
    800054c8:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054cc:	00461713          	slli	a4,a2,0x4
    800054d0:	6290                	ld	a2,0(a3)
    800054d2:	963a                	add	a2,a2,a4
    800054d4:	03078793          	addi	a5,a5,48
    800054d8:	97c2                	add	a5,a5,a6
    800054da:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054dc:	629c                	ld	a5,0(a3)
    800054de:	97ba                	add	a5,a5,a4
    800054e0:	4605                	li	a2,1
    800054e2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054e4:	629c                	ld	a5,0(a3)
    800054e6:	97ba                	add	a5,a5,a4
    800054e8:	4809                	li	a6,2
    800054ea:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054ee:	629c                	ld	a5,0(a3)
    800054f0:	973e                	add	a4,a4,a5
    800054f2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054f6:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054fa:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054fe:	6698                	ld	a4,8(a3)
    80005500:	00275783          	lhu	a5,2(a4)
    80005504:	8b9d                	andi	a5,a5,7
    80005506:	0786                	slli	a5,a5,0x1
    80005508:	97ba                	add	a5,a5,a4
    8000550a:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    8000550e:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005512:	6698                	ld	a4,8(a3)
    80005514:	00275783          	lhu	a5,2(a4)
    80005518:	2785                	addiw	a5,a5,1
    8000551a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000551e:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005522:	100017b7          	lui	a5,0x10001
    80005526:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000552a:	004aa783          	lw	a5,4(s5)
    8000552e:	02c79163          	bne	a5,a2,80005550 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005532:	00019917          	auipc	s2,0x19
    80005536:	bf690913          	addi	s2,s2,-1034 # 8001e128 <disk+0x2128>
  while(b->disk == 1) {
    8000553a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000553c:	85ca                	mv	a1,s2
    8000553e:	8556                	mv	a0,s5
    80005540:	ffffc097          	auipc	ra,0xffffc
    80005544:	01a080e7          	jalr	26(ra) # 8000155a <sleep>
  while(b->disk == 1) {
    80005548:	004aa783          	lw	a5,4(s5)
    8000554c:	fe9788e3          	beq	a5,s1,8000553c <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005550:	f8042903          	lw	s2,-128(s0)
    80005554:	20090793          	addi	a5,s2,512
    80005558:	00479713          	slli	a4,a5,0x4
    8000555c:	00017797          	auipc	a5,0x17
    80005560:	aa478793          	addi	a5,a5,-1372 # 8001c000 <disk>
    80005564:	97ba                	add	a5,a5,a4
    80005566:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000556a:	00019997          	auipc	s3,0x19
    8000556e:	a9698993          	addi	s3,s3,-1386 # 8001e000 <disk+0x2000>
    80005572:	00491713          	slli	a4,s2,0x4
    80005576:	0009b783          	ld	a5,0(s3)
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005580:	854a                	mv	a0,s2
    80005582:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005586:	00000097          	auipc	ra,0x0
    8000558a:	c5a080e7          	jalr	-934(ra) # 800051e0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000558e:	8885                	andi	s1,s1,1
    80005590:	f0ed                	bnez	s1,80005572 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005592:	00019517          	auipc	a0,0x19
    80005596:	b9650513          	addi	a0,a0,-1130 # 8001e128 <disk+0x2128>
    8000559a:	00002097          	auipc	ra,0x2
    8000559e:	c20080e7          	jalr	-992(ra) # 800071ba <release>
}
    800055a2:	70e6                	ld	ra,120(sp)
    800055a4:	7446                	ld	s0,112(sp)
    800055a6:	74a6                	ld	s1,104(sp)
    800055a8:	7906                	ld	s2,96(sp)
    800055aa:	69e6                	ld	s3,88(sp)
    800055ac:	6a46                	ld	s4,80(sp)
    800055ae:	6aa6                	ld	s5,72(sp)
    800055b0:	6b06                	ld	s6,64(sp)
    800055b2:	7be2                	ld	s7,56(sp)
    800055b4:	7c42                	ld	s8,48(sp)
    800055b6:	7ca2                	ld	s9,40(sp)
    800055b8:	7d02                	ld	s10,32(sp)
    800055ba:	6de2                	ld	s11,24(sp)
    800055bc:	6109                	addi	sp,sp,128
    800055be:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055c0:	f8042503          	lw	a0,-128(s0)
    800055c4:	20050793          	addi	a5,a0,512
    800055c8:	0792                	slli	a5,a5,0x4
  if(write)
    800055ca:	00017817          	auipc	a6,0x17
    800055ce:	a3680813          	addi	a6,a6,-1482 # 8001c000 <disk>
    800055d2:	00f80733          	add	a4,a6,a5
    800055d6:	01a036b3          	snez	a3,s10
    800055da:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055de:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055e2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e6:	7679                	lui	a2,0xffffe
    800055e8:	963e                	add	a2,a2,a5
    800055ea:	00019697          	auipc	a3,0x19
    800055ee:	a1668693          	addi	a3,a3,-1514 # 8001e000 <disk+0x2000>
    800055f2:	6298                	ld	a4,0(a3)
    800055f4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f6:	0a878593          	addi	a1,a5,168
    800055fa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055fc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055fe:	6298                	ld	a4,0(a3)
    80005600:	9732                	add	a4,a4,a2
    80005602:	45c1                	li	a1,16
    80005604:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005606:	6298                	ld	a4,0(a3)
    80005608:	9732                	add	a4,a4,a2
    8000560a:	4585                	li	a1,1
    8000560c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005610:	f8442703          	lw	a4,-124(s0)
    80005614:	628c                	ld	a1,0(a3)
    80005616:	962e                	add	a2,a2,a1
    80005618:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd6a8e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000561c:	0712                	slli	a4,a4,0x4
    8000561e:	6290                	ld	a2,0(a3)
    80005620:	963a                	add	a2,a2,a4
    80005622:	058a8593          	addi	a1,s5,88
    80005626:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005628:	6294                	ld	a3,0(a3)
    8000562a:	96ba                	add	a3,a3,a4
    8000562c:	40000613          	li	a2,1024
    80005630:	c690                	sw	a2,8(a3)
  if(write)
    80005632:	e40d19e3          	bnez	s10,80005484 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005636:	00019697          	auipc	a3,0x19
    8000563a:	9ca6b683          	ld	a3,-1590(a3) # 8001e000 <disk+0x2000>
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	4609                	li	a2,2
    80005642:	00c69623          	sh	a2,12(a3)
    80005646:	b5b1                	j	80005492 <virtio_disk_rw+0xd2>

0000000080005648 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005648:	1101                	addi	sp,sp,-32
    8000564a:	ec06                	sd	ra,24(sp)
    8000564c:	e822                	sd	s0,16(sp)
    8000564e:	e426                	sd	s1,8(sp)
    80005650:	e04a                	sd	s2,0(sp)
    80005652:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005654:	00019517          	auipc	a0,0x19
    80005658:	ad450513          	addi	a0,a0,-1324 # 8001e128 <disk+0x2128>
    8000565c:	00002097          	auipc	ra,0x2
    80005660:	aaa080e7          	jalr	-1366(ra) # 80007106 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005664:	10001737          	lui	a4,0x10001
    80005668:	533c                	lw	a5,96(a4)
    8000566a:	8b8d                	andi	a5,a5,3
    8000566c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000566e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005672:	00019797          	auipc	a5,0x19
    80005676:	98e78793          	addi	a5,a5,-1650 # 8001e000 <disk+0x2000>
    8000567a:	6b94                	ld	a3,16(a5)
    8000567c:	0207d703          	lhu	a4,32(a5)
    80005680:	0026d783          	lhu	a5,2(a3)
    80005684:	06f70163          	beq	a4,a5,800056e6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005688:	00017917          	auipc	s2,0x17
    8000568c:	97890913          	addi	s2,s2,-1672 # 8001c000 <disk>
    80005690:	00019497          	auipc	s1,0x19
    80005694:	97048493          	addi	s1,s1,-1680 # 8001e000 <disk+0x2000>
    __sync_synchronize();
    80005698:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000569c:	6898                	ld	a4,16(s1)
    8000569e:	0204d783          	lhu	a5,32(s1)
    800056a2:	8b9d                	andi	a5,a5,7
    800056a4:	078e                	slli	a5,a5,0x3
    800056a6:	97ba                	add	a5,a5,a4
    800056a8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056aa:	20078713          	addi	a4,a5,512
    800056ae:	0712                	slli	a4,a4,0x4
    800056b0:	974a                	add	a4,a4,s2
    800056b2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056b6:	e731                	bnez	a4,80005702 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056b8:	20078793          	addi	a5,a5,512
    800056bc:	0792                	slli	a5,a5,0x4
    800056be:	97ca                	add	a5,a5,s2
    800056c0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056c2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056c6:	ffffc097          	auipc	ra,0xffffc
    800056ca:	020080e7          	jalr	32(ra) # 800016e6 <wakeup>

    disk.used_idx += 1;
    800056ce:	0204d783          	lhu	a5,32(s1)
    800056d2:	2785                	addiw	a5,a5,1
    800056d4:	17c2                	slli	a5,a5,0x30
    800056d6:	93c1                	srli	a5,a5,0x30
    800056d8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056dc:	6898                	ld	a4,16(s1)
    800056de:	00275703          	lhu	a4,2(a4)
    800056e2:	faf71be3          	bne	a4,a5,80005698 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056e6:	00019517          	auipc	a0,0x19
    800056ea:	a4250513          	addi	a0,a0,-1470 # 8001e128 <disk+0x2128>
    800056ee:	00002097          	auipc	ra,0x2
    800056f2:	acc080e7          	jalr	-1332(ra) # 800071ba <release>
}
    800056f6:	60e2                	ld	ra,24(sp)
    800056f8:	6442                	ld	s0,16(sp)
    800056fa:	64a2                	ld	s1,8(sp)
    800056fc:	6902                	ld	s2,0(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret
      panic("virtio_disk_intr status");
    80005702:	00004517          	auipc	a0,0x4
    80005706:	0c650513          	addi	a0,a0,198 # 800097c8 <syscalls+0x3f0>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	4c0080e7          	jalr	1216(ra) # 80006bca <panic>

0000000080005712 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005712:	7179                	addi	sp,sp,-48
    80005714:	f406                	sd	ra,40(sp)
    80005716:	f022                	sd	s0,32(sp)
    80005718:	ec26                	sd	s1,24(sp)
    8000571a:	e84a                	sd	s2,16(sp)
    8000571c:	e44e                	sd	s3,8(sp)
    8000571e:	1800                	addi	s0,sp,48
    80005720:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80005722:	00004597          	auipc	a1,0x4
    80005726:	0be58593          	addi	a1,a1,190 # 800097e0 <syscalls+0x408>
    8000572a:	0001a517          	auipc	a0,0x1a
    8000572e:	8d650513          	addi	a0,a0,-1834 # 8001f000 <e1000_lock>
    80005732:	00002097          	auipc	ra,0x2
    80005736:	944080e7          	jalr	-1724(ra) # 80007076 <initlock>

  regs = xregs;
    8000573a:	00005797          	auipc	a5,0x5
    8000573e:	8e97b323          	sd	s1,-1818(a5) # 8000a020 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80005742:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80005746:	409c                	lw	a5,0(s1)
    80005748:	00400737          	lui	a4,0x400
    8000574c:	8fd9                	or	a5,a5,a4
    8000574e:	2781                	sext.w	a5,a5
    80005750:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80005752:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80005756:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    8000575a:	10000613          	li	a2,256
    8000575e:	4581                	li	a1,0
    80005760:	0001a517          	auipc	a0,0x1a
    80005764:	8c050513          	addi	a0,a0,-1856 # 8001f020 <tx_ring>
    80005768:	ffffb097          	auipc	ra,0xffffb
    8000576c:	a10080e7          	jalr	-1520(ra) # 80000178 <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005770:	0001a717          	auipc	a4,0x1a
    80005774:	8bc70713          	addi	a4,a4,-1860 # 8001f02c <tx_ring+0xc>
    80005778:	0001a797          	auipc	a5,0x1a
    8000577c:	9a878793          	addi	a5,a5,-1624 # 8001f120 <tx_mbufs>
    80005780:	0001a617          	auipc	a2,0x1a
    80005784:	a2060613          	addi	a2,a2,-1504 # 8001f1a0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80005788:	4685                	li	a3,1
    8000578a:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    8000578e:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005792:	0741                	addi	a4,a4,16
    80005794:	07a1                	addi	a5,a5,8
    80005796:	fec79ae3          	bne	a5,a2,8000578a <e1000_init+0x78>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    8000579a:	0001a717          	auipc	a4,0x1a
    8000579e:	88670713          	addi	a4,a4,-1914 # 8001f020 <tx_ring>
    800057a2:	00005797          	auipc	a5,0x5
    800057a6:	87e7b783          	ld	a5,-1922(a5) # 8000a020 <regs>
    800057aa:	6691                	lui	a3,0x4
    800057ac:	97b6                	add	a5,a5,a3
    800057ae:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800057b2:	10000713          	li	a4,256
    800057b6:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800057ba:	8007ac23          	sw	zero,-2024(a5)
    800057be:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    800057c2:	0001a917          	auipc	s2,0x1a
    800057c6:	9de90913          	addi	s2,s2,-1570 # 8001f1a0 <rx_ring>
    800057ca:	10000613          	li	a2,256
    800057ce:	4581                	li	a1,0
    800057d0:	854a                	mv	a0,s2
    800057d2:	ffffb097          	auipc	ra,0xffffb
    800057d6:	9a6080e7          	jalr	-1626(ra) # 80000178 <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    800057da:	0001a497          	auipc	s1,0x1a
    800057de:	ac648493          	addi	s1,s1,-1338 # 8001f2a0 <rx_mbufs>
    800057e2:	0001a997          	auipc	s3,0x1a
    800057e6:	b3e98993          	addi	s3,s3,-1218 # 8001f320 <lock>
    rx_mbufs[i] = mbufalloc(0);
    800057ea:	4501                	li	a0,0
    800057ec:	00000097          	auipc	ra,0x0
    800057f0:	44e080e7          	jalr	1102(ra) # 80005c3a <mbufalloc>
    800057f4:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    800057f6:	c945                	beqz	a0,800058a6 <e1000_init+0x194>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    800057f8:	651c                	ld	a5,8(a0)
    800057fa:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    800057fe:	04a1                	addi	s1,s1,8
    80005800:	0941                	addi	s2,s2,16
    80005802:	ff3494e3          	bne	s1,s3,800057ea <e1000_init+0xd8>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80005806:	00005697          	auipc	a3,0x5
    8000580a:	81a6b683          	ld	a3,-2022(a3) # 8000a020 <regs>
    8000580e:	0001a717          	auipc	a4,0x1a
    80005812:	99270713          	addi	a4,a4,-1646 # 8001f1a0 <rx_ring>
    80005816:	678d                	lui	a5,0x3
    80005818:	97b6                	add	a5,a5,a3
    8000581a:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    8000581e:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005822:	473d                	li	a4,15
    80005824:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80005828:	10000713          	li	a4,256
    8000582c:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005830:	6715                	lui	a4,0x5
    80005832:	00e68633          	add	a2,a3,a4
    80005836:	120057b7          	lui	a5,0x12005
    8000583a:	45278793          	addi	a5,a5,1106 # 12005452 <_entry-0x6dffabae>
    8000583e:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80005842:	800057b7          	lui	a5,0x80005
    80005846:	63478793          	addi	a5,a5,1588 # ffffffff80005634 <end+0xfffffffefffde0b4>
    8000584a:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    8000584e:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    80005852:	97b6                	add	a5,a5,a3
    80005854:	40070713          	addi	a4,a4,1024
    80005858:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    8000585a:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    8000585e:	0791                	addi	a5,a5,4
    80005860:	fee79de3          	bne	a5,a4,8000585a <e1000_init+0x148>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    80005864:	000407b7          	lui	a5,0x40
    80005868:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    8000586c:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80005870:	006027b7          	lui	a5,0x602
    80005874:	07a9                	addi	a5,a5,10
    80005876:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    8000587a:	040087b7          	lui	a5,0x4008
    8000587e:	0789                	addi	a5,a5,2
    80005880:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80005884:	678d                	lui	a5,0x3
    80005886:	97b6                	add	a5,a5,a3
    80005888:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    8000588c:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    80005890:	08000793          	li	a5,128
    80005894:	0cf6a823          	sw	a5,208(a3)
}
    80005898:	70a2                	ld	ra,40(sp)
    8000589a:	7402                	ld	s0,32(sp)
    8000589c:	64e2                	ld	s1,24(sp)
    8000589e:	6942                	ld	s2,16(sp)
    800058a0:	69a2                	ld	s3,8(sp)
    800058a2:	6145                	addi	sp,sp,48
    800058a4:	8082                	ret
      panic("e1000");
    800058a6:	00004517          	auipc	a0,0x4
    800058aa:	f3a50513          	addi	a0,a0,-198 # 800097e0 <syscalls+0x408>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	31c080e7          	jalr	796(ra) # 80006bca <panic>

00000000800058b6 <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    800058b6:	7179                	addi	sp,sp,-48
    800058b8:	f406                	sd	ra,40(sp)
    800058ba:	f022                	sd	s0,32(sp)
    800058bc:	ec26                	sd	s1,24(sp)
    800058be:	e84a                	sd	s2,16(sp)
    800058c0:	e44e                	sd	s3,8(sp)
    800058c2:	1800                	addi	s0,sp,48
    800058c4:	892a                	mv	s2,a0
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);
    800058c6:	00019997          	auipc	s3,0x19
    800058ca:	73a98993          	addi	s3,s3,1850 # 8001f000 <e1000_lock>
    800058ce:	854e                	mv	a0,s3
    800058d0:	00002097          	auipc	ra,0x2
    800058d4:	836080e7          	jalr	-1994(ra) # 80007106 <acquire>
  int end = regs[E1000_TDT];
    800058d8:	00004797          	auipc	a5,0x4
    800058dc:	7487b783          	ld	a5,1864(a5) # 8000a020 <regs>
    800058e0:	6711                	lui	a4,0x4
    800058e2:	97ba                	add	a5,a5,a4
    800058e4:	8187a483          	lw	s1,-2024(a5)
    800058e8:	2481                	sext.w	s1,s1
  if(!(tx_ring[end].status & E1000_TXD_STAT_DD))
    800058ea:	00449793          	slli	a5,s1,0x4
    800058ee:	99be                	add	s3,s3,a5
    800058f0:	02c9c783          	lbu	a5,44(s3)
    800058f4:	8b85                	andi	a5,a5,1
    800058f6:	c3c9                	beqz	a5,80005978 <e1000_transmit+0xc2>
  {
    release(&e1000_lock);
    return -1;
  }

  if(tx_mbufs[end])
    800058f8:	00349713          	slli	a4,s1,0x3
    800058fc:	00019797          	auipc	a5,0x19
    80005900:	70478793          	addi	a5,a5,1796 # 8001f000 <e1000_lock>
    80005904:	97ba                	add	a5,a5,a4
    80005906:	1207b503          	ld	a0,288(a5)
    8000590a:	c509                	beqz	a0,80005914 <e1000_transmit+0x5e>
    mbuffree(tx_mbufs[end]);
    8000590c:	00000097          	auipc	ra,0x0
    80005910:	386080e7          	jalr	902(ra) # 80005c92 <mbuffree>

  tx_ring[end].addr = (uint64)m->head;
    80005914:	00019517          	auipc	a0,0x19
    80005918:	6ec50513          	addi	a0,a0,1772 # 8001f000 <e1000_lock>
    8000591c:	00449793          	slli	a5,s1,0x4
    80005920:	97aa                	add	a5,a5,a0
    80005922:	00893703          	ld	a4,8(s2)
    80005926:	f398                	sd	a4,32(a5)
  tx_ring[end].cmd = E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS;
    80005928:	4725                	li	a4,9
    8000592a:	02e785a3          	sb	a4,43(a5)
  tx_ring[end].length = m->len;
    8000592e:	01092703          	lw	a4,16(s2)
    80005932:	02e79423          	sh	a4,40(a5)
  tx_mbufs[end] = m;
    80005936:	00349793          	slli	a5,s1,0x3
    8000593a:	97aa                	add	a5,a5,a0
    8000593c:	1327b023          	sd	s2,288(a5)
  regs[E1000_TDT] = (end+1)%TX_RING_SIZE;
    80005940:	2485                	addiw	s1,s1,1
    80005942:	41f4d79b          	sraiw	a5,s1,0x1f
    80005946:	01c7d79b          	srliw	a5,a5,0x1c
    8000594a:	9cbd                	addw	s1,s1,a5
    8000594c:	88bd                	andi	s1,s1,15
    8000594e:	9c9d                	subw	s1,s1,a5
    80005950:	00004797          	auipc	a5,0x4
    80005954:	6d07b783          	ld	a5,1744(a5) # 8000a020 <regs>
    80005958:	6711                	lui	a4,0x4
    8000595a:	97ba                	add	a5,a5,a4
    8000595c:	8097ac23          	sw	s1,-2024(a5)
  release(&e1000_lock);
    80005960:	00002097          	auipc	ra,0x2
    80005964:	85a080e7          	jalr	-1958(ra) # 800071ba <release>
  return 0;
    80005968:	4501                	li	a0,0
}
    8000596a:	70a2                	ld	ra,40(sp)
    8000596c:	7402                	ld	s0,32(sp)
    8000596e:	64e2                	ld	s1,24(sp)
    80005970:	6942                	ld	s2,16(sp)
    80005972:	69a2                	ld	s3,8(sp)
    80005974:	6145                	addi	sp,sp,48
    80005976:	8082                	ret
    release(&e1000_lock);
    80005978:	00019517          	auipc	a0,0x19
    8000597c:	68850513          	addi	a0,a0,1672 # 8001f000 <e1000_lock>
    80005980:	00002097          	auipc	ra,0x2
    80005984:	83a080e7          	jalr	-1990(ra) # 800071ba <release>
    return -1;
    80005988:	557d                	li	a0,-1
    8000598a:	b7c5                	j	8000596a <e1000_transmit+0xb4>

000000008000598c <e1000_intr>:
  regs[E1000_RDT] = (end - 1) % RX_RING_SIZE;
}

void
e1000_intr(void)
{
    8000598c:	7179                	addi	sp,sp,-48
    8000598e:	f406                	sd	ra,40(sp)
    80005990:	f022                	sd	s0,32(sp)
    80005992:	ec26                	sd	s1,24(sp)
    80005994:	e84a                	sd	s2,16(sp)
    80005996:	e44e                	sd	s3,8(sp)
    80005998:	e052                	sd	s4,0(sp)
    8000599a:	1800                	addi	s0,sp,48
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    8000599c:	00004797          	auipc	a5,0x4
    800059a0:	6847b783          	ld	a5,1668(a5) # 8000a020 <regs>
    800059a4:	577d                	li	a4,-1
    800059a6:	0ce7a023          	sw	a4,192(a5)
  int end = (regs[E1000_RDT]+1)%RX_RING_SIZE;
    800059aa:	670d                	lui	a4,0x3
    800059ac:	97ba                	add	a5,a5,a4
    800059ae:	8187a483          	lw	s1,-2024(a5)
    800059b2:	2485                	addiw	s1,s1,1
    800059b4:	88bd                	andi	s1,s1,15
  while(rx_ring[end].status & E1000_TXD_STAT_DD)
    800059b6:	00449713          	slli	a4,s1,0x4
    800059ba:	00019797          	auipc	a5,0x19
    800059be:	64678793          	addi	a5,a5,1606 # 8001f000 <e1000_lock>
    800059c2:	97ba                	add	a5,a5,a4
    800059c4:	1ac7c783          	lbu	a5,428(a5)
    800059c8:	8b85                	andi	a5,a5,1
    800059ca:	cfa5                	beqz	a5,80005a42 <e1000_intr+0xb6>
    if(rx_ring[end].length>MBUF_SIZE)
    800059cc:	00019997          	auipc	s3,0x19
    800059d0:	63498993          	addi	s3,s3,1588 # 8001f000 <e1000_lock>
    800059d4:	6a05                	lui	s4,0x1
    800059d6:	800a0a13          	addi	s4,s4,-2048 # 800 <_entry-0x7ffff800>
    800059da:	00449793          	slli	a5,s1,0x4
    800059de:	97ce                	add	a5,a5,s3
    800059e0:	1a87d783          	lhu	a5,424(a5)
    800059e4:	0007871b          	sext.w	a4,a5
    800059e8:	08ea6663          	bltu	s4,a4,80005a74 <e1000_intr+0xe8>
    rx_mbufs[end]->len = rx_ring[end].length;
    800059ec:	00349913          	slli	s2,s1,0x3
    800059f0:	994e                	add	s2,s2,s3
    800059f2:	2a093703          	ld	a4,672(s2)
    800059f6:	cb1c                	sw	a5,16(a4)
    net_rx(rx_mbufs[end]);
    800059f8:	2a093503          	ld	a0,672(s2)
    800059fc:	00000097          	auipc	ra,0x0
    80005a00:	412080e7          	jalr	1042(ra) # 80005e0e <net_rx>
    rx_mbufs[end] = mbufalloc(0);
    80005a04:	4501                	li	a0,0
    80005a06:	00000097          	auipc	ra,0x0
    80005a0a:	234080e7          	jalr	564(ra) # 80005c3a <mbufalloc>
    80005a0e:	2aa93023          	sd	a0,672(s2)
    if(rx_mbufs[end]==0)
    80005a12:	c92d                	beqz	a0,80005a84 <e1000_intr+0xf8>
    rx_ring[end].addr = (uint64)(rx_mbufs[end]->head);
    80005a14:	00449793          	slli	a5,s1,0x4
    80005a18:	97ce                	add	a5,a5,s3
    80005a1a:	6518                	ld	a4,8(a0)
    80005a1c:	1ae7b023          	sd	a4,416(a5)
    rx_ring[end].status = 0;
    80005a20:	1a078623          	sb	zero,428(a5)
    end = (end + 1) % RX_RING_SIZE;
    80005a24:	2485                	addiw	s1,s1,1
    80005a26:	41f4d79b          	sraiw	a5,s1,0x1f
    80005a2a:	01c7d79b          	srliw	a5,a5,0x1c
    80005a2e:	9cbd                	addw	s1,s1,a5
    80005a30:	88bd                	andi	s1,s1,15
    80005a32:	9c9d                	subw	s1,s1,a5
  while(rx_ring[end].status & E1000_TXD_STAT_DD)
    80005a34:	00449793          	slli	a5,s1,0x4
    80005a38:	97ce                	add	a5,a5,s3
    80005a3a:	1ac7c783          	lbu	a5,428(a5)
    80005a3e:	8b85                	andi	a5,a5,1
    80005a40:	ffc9                	bnez	a5,800059da <e1000_intr+0x4e>
  regs[E1000_RDT] = (end - 1) % RX_RING_SIZE;
    80005a42:	34fd                	addiw	s1,s1,-1
    80005a44:	41f4d79b          	sraiw	a5,s1,0x1f
    80005a48:	01c7d71b          	srliw	a4,a5,0x1c
    80005a4c:	9cb9                	addw	s1,s1,a4
    80005a4e:	00f4f793          	andi	a5,s1,15
    80005a52:	9f99                	subw	a5,a5,a4
    80005a54:	00004717          	auipc	a4,0x4
    80005a58:	5cc73703          	ld	a4,1484(a4) # 8000a020 <regs>
    80005a5c:	668d                	lui	a3,0x3
    80005a5e:	9736                	add	a4,a4,a3
    80005a60:	80f72c23          	sw	a5,-2024(a4)

  e1000_recv();
}
    80005a64:	70a2                	ld	ra,40(sp)
    80005a66:	7402                	ld	s0,32(sp)
    80005a68:	64e2                	ld	s1,24(sp)
    80005a6a:	6942                	ld	s2,16(sp)
    80005a6c:	69a2                	ld	s3,8(sp)
    80005a6e:	6a02                	ld	s4,0(sp)
    80005a70:	6145                	addi	sp,sp,48
    80005a72:	8082                	ret
      panic("Out of Buf");
    80005a74:	00004517          	auipc	a0,0x4
    80005a78:	d7450513          	addi	a0,a0,-652 # 800097e8 <syscalls+0x410>
    80005a7c:	00001097          	auipc	ra,0x1
    80005a80:	14e080e7          	jalr	334(ra) # 80006bca <panic>
      panic("no mbufs");
    80005a84:	00004517          	auipc	a0,0x4
    80005a88:	d7450513          	addi	a0,a0,-652 # 800097f8 <syscalls+0x420>
    80005a8c:	00001097          	auipc	ra,0x1
    80005a90:	13e080e7          	jalr	318(ra) # 80006bca <panic>

0000000080005a94 <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005a94:	1101                	addi	sp,sp,-32
    80005a96:	ec22                	sd	s0,24(sp)
    80005a98:	1000                	addi	s0,sp,32
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;
    80005a9a:	fe041723          	sh	zero,-18(s0)
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005a9e:	4785                	li	a5,1
    80005aa0:	04b7da63          	bge	a5,a1,80005af4 <in_cksum+0x60>
    80005aa4:	ffe5861b          	addiw	a2,a1,-2
    80005aa8:	0016561b          	srliw	a2,a2,0x1
    80005aac:	0016069b          	addiw	a3,a2,1
    80005ab0:	1682                	slli	a3,a3,0x20
    80005ab2:	9281                	srli	a3,a3,0x20
    80005ab4:	0686                	slli	a3,a3,0x1
    80005ab6:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    80005ab8:	4781                	li	a5,0
    sum += *w++;
    80005aba:	0509                	addi	a0,a0,2
    80005abc:	ffe55703          	lhu	a4,-2(a0)
    80005ac0:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    80005ac2:	fed51ce3          	bne	a0,a3,80005aba <in_cksum+0x26>
    nleft -= 2;
    80005ac6:	35f9                	addiw	a1,a1,-2
    80005ac8:	0016161b          	slliw	a2,a2,0x1
    80005acc:	9d91                	subw	a1,a1,a2
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005ace:	4705                	li	a4,1
    80005ad0:	02e58563          	beq	a1,a4,80005afa <in_cksum+0x66>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005ad4:	03079513          	slli	a0,a5,0x30
    80005ad8:	9141                	srli	a0,a0,0x30
    80005ada:	0107d79b          	srliw	a5,a5,0x10
    80005ade:	9fa9                	addw	a5,a5,a0
  sum += (sum >> 16);
    80005ae0:	0107d51b          	srliw	a0,a5,0x10
    80005ae4:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005ae6:	fff54513          	not	a0,a0
  return answer;
}
    80005aea:	1542                	slli	a0,a0,0x30
    80005aec:	9141                	srli	a0,a0,0x30
    80005aee:	6462                	ld	s0,24(sp)
    80005af0:	6105                	addi	sp,sp,32
    80005af2:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005af4:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    80005af6:	4781                	li	a5,0
    80005af8:	bfd9                	j	80005ace <in_cksum+0x3a>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005afa:	0006c703          	lbu	a4,0(a3) # 3000 <_entry-0x7fffd000>
    80005afe:	fee40723          	sb	a4,-18(s0)
    sum += answer;
    80005b02:	fee45703          	lhu	a4,-18(s0)
    80005b06:	9fb9                	addw	a5,a5,a4
    80005b08:	b7f1                	j	80005ad4 <in_cksum+0x40>

0000000080005b0a <mbufpull>:
{
    80005b0a:	1141                	addi	sp,sp,-16
    80005b0c:	e422                	sd	s0,8(sp)
    80005b0e:	0800                	addi	s0,sp,16
    80005b10:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005b12:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005b14:	4b98                	lw	a4,16(a5)
    80005b16:	00b76b63          	bltu	a4,a1,80005b2c <mbufpull+0x22>
  m->len -= len;
    80005b1a:	9f0d                	subw	a4,a4,a1
    80005b1c:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005b1e:	1582                	slli	a1,a1,0x20
    80005b20:	9181                	srli	a1,a1,0x20
    80005b22:	95aa                	add	a1,a1,a0
    80005b24:	e78c                	sd	a1,8(a5)
}
    80005b26:	6422                	ld	s0,8(sp)
    80005b28:	0141                	addi	sp,sp,16
    80005b2a:	8082                	ret
    return 0;
    80005b2c:	4501                	li	a0,0
    80005b2e:	bfe5                	j	80005b26 <mbufpull+0x1c>

0000000080005b30 <mbufpush>:
{
    80005b30:	87aa                	mv	a5,a0
  m->head -= len;
    80005b32:	02059713          	slli	a4,a1,0x20
    80005b36:	9301                	srli	a4,a4,0x20
    80005b38:	6508                	ld	a0,8(a0)
    80005b3a:	8d19                	sub	a0,a0,a4
    80005b3c:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005b3e:	01478713          	addi	a4,a5,20
    80005b42:	00e56663          	bltu	a0,a4,80005b4e <mbufpush+0x1e>
  m->len += len;
    80005b46:	4b98                	lw	a4,16(a5)
    80005b48:	9db9                	addw	a1,a1,a4
    80005b4a:	cb8c                	sw	a1,16(a5)
}
    80005b4c:	8082                	ret
{
    80005b4e:	1141                	addi	sp,sp,-16
    80005b50:	e406                	sd	ra,8(sp)
    80005b52:	e022                	sd	s0,0(sp)
    80005b54:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005b56:	00004517          	auipc	a0,0x4
    80005b5a:	cb250513          	addi	a0,a0,-846 # 80009808 <syscalls+0x430>
    80005b5e:	00001097          	auipc	ra,0x1
    80005b62:	06c080e7          	jalr	108(ra) # 80006bca <panic>

0000000080005b66 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005b66:	7179                	addi	sp,sp,-48
    80005b68:	f406                	sd	ra,40(sp)
    80005b6a:	f022                	sd	s0,32(sp)
    80005b6c:	ec26                	sd	s1,24(sp)
    80005b6e:	e84a                	sd	s2,16(sp)
    80005b70:	e44e                	sd	s3,8(sp)
    80005b72:	1800                	addi	s0,sp,48
    80005b74:	89aa                	mv	s3,a0
    80005b76:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005b78:	45b9                	li	a1,14
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	fb6080e7          	jalr	-74(ra) # 80005b30 <mbufpush>
    80005b82:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005b84:	4619                	li	a2,6
    80005b86:	00004597          	auipc	a1,0x4
    80005b8a:	d3a58593          	addi	a1,a1,-710 # 800098c0 <local_mac>
    80005b8e:	0519                	addi	a0,a0,6
    80005b90:	ffffa097          	auipc	ra,0xffffa
    80005b94:	644080e7          	jalr	1604(ra) # 800001d4 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005b98:	4619                	li	a2,6
    80005b9a:	00004597          	auipc	a1,0x4
    80005b9e:	d1e58593          	addi	a1,a1,-738 # 800098b8 <broadcast_mac>
    80005ba2:	8526                	mv	a0,s1
    80005ba4:	ffffa097          	auipc	ra,0xffffa
    80005ba8:	630080e7          	jalr	1584(ra) # 800001d4 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005bac:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005bb0:	00f48623          	sb	a5,12(s1)
    80005bb4:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005bb8:	854e                	mv	a0,s3
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	cfc080e7          	jalr	-772(ra) # 800058b6 <e1000_transmit>
    80005bc2:	e901                	bnez	a0,80005bd2 <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005bc4:	70a2                	ld	ra,40(sp)
    80005bc6:	7402                	ld	s0,32(sp)
    80005bc8:	64e2                	ld	s1,24(sp)
    80005bca:	6942                	ld	s2,16(sp)
    80005bcc:	69a2                	ld	s3,8(sp)
    80005bce:	6145                	addi	sp,sp,48
    80005bd0:	8082                	ret
  kfree(m);
    80005bd2:	854e                	mv	a0,s3
    80005bd4:	ffffa097          	auipc	ra,0xffffa
    80005bd8:	448080e7          	jalr	1096(ra) # 8000001c <kfree>
}
    80005bdc:	b7e5                	j	80005bc4 <net_tx_eth+0x5e>

0000000080005bde <mbufput>:
{
    80005bde:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005be0:	4918                	lw	a4,16(a0)
    80005be2:	02071693          	slli	a3,a4,0x20
    80005be6:	9281                	srli	a3,a3,0x20
    80005be8:	6508                	ld	a0,8(a0)
    80005bea:	9536                	add	a0,a0,a3
  m->len += len;
    80005bec:	9f2d                	addw	a4,a4,a1
    80005bee:	0007069b          	sext.w	a3,a4
    80005bf2:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005bf4:	6785                	lui	a5,0x1
    80005bf6:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005bfa:	00d7e363          	bltu	a5,a3,80005c00 <mbufput+0x22>
}
    80005bfe:	8082                	ret
{
    80005c00:	1141                	addi	sp,sp,-16
    80005c02:	e406                	sd	ra,8(sp)
    80005c04:	e022                	sd	s0,0(sp)
    80005c06:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005c08:	00004517          	auipc	a0,0x4
    80005c0c:	c1050513          	addi	a0,a0,-1008 # 80009818 <syscalls+0x440>
    80005c10:	00001097          	auipc	ra,0x1
    80005c14:	fba080e7          	jalr	-70(ra) # 80006bca <panic>

0000000080005c18 <mbuftrim>:
{
    80005c18:	1141                	addi	sp,sp,-16
    80005c1a:	e422                	sd	s0,8(sp)
    80005c1c:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005c1e:	491c                	lw	a5,16(a0)
    80005c20:	00b7eb63          	bltu	a5,a1,80005c36 <mbuftrim+0x1e>
  m->len -= len;
    80005c24:	9f8d                	subw	a5,a5,a1
    80005c26:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005c28:	1782                	slli	a5,a5,0x20
    80005c2a:	9381                	srli	a5,a5,0x20
    80005c2c:	6508                	ld	a0,8(a0)
    80005c2e:	953e                	add	a0,a0,a5
}
    80005c30:	6422                	ld	s0,8(sp)
    80005c32:	0141                	addi	sp,sp,16
    80005c34:	8082                	ret
    return 0;
    80005c36:	4501                	li	a0,0
    80005c38:	bfe5                	j	80005c30 <mbuftrim+0x18>

0000000080005c3a <mbufalloc>:
{
    80005c3a:	1101                	addi	sp,sp,-32
    80005c3c:	ec06                	sd	ra,24(sp)
    80005c3e:	e822                	sd	s0,16(sp)
    80005c40:	e426                	sd	s1,8(sp)
    80005c42:	e04a                	sd	s2,0(sp)
    80005c44:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005c46:	6785                	lui	a5,0x1
    80005c48:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005c4c:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005c4e:	02a7eb63          	bltu	a5,a0,80005c84 <mbufalloc+0x4a>
    80005c52:	84aa                	mv	s1,a0
  m = kalloc();
    80005c54:	ffffa097          	auipc	ra,0xffffa
    80005c58:	4c4080e7          	jalr	1220(ra) # 80000118 <kalloc>
    80005c5c:	892a                	mv	s2,a0
  if (m == 0)
    80005c5e:	c11d                	beqz	a0,80005c84 <mbufalloc+0x4a>
  m->next = 0;
    80005c60:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005c64:	0551                	addi	a0,a0,20
    80005c66:	1482                	slli	s1,s1,0x20
    80005c68:	9081                	srli	s1,s1,0x20
    80005c6a:	94aa                	add	s1,s1,a0
    80005c6c:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005c70:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005c74:	6605                	lui	a2,0x1
    80005c76:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005c7a:	4581                	li	a1,0
    80005c7c:	ffffa097          	auipc	ra,0xffffa
    80005c80:	4fc080e7          	jalr	1276(ra) # 80000178 <memset>
}
    80005c84:	854a                	mv	a0,s2
    80005c86:	60e2                	ld	ra,24(sp)
    80005c88:	6442                	ld	s0,16(sp)
    80005c8a:	64a2                	ld	s1,8(sp)
    80005c8c:	6902                	ld	s2,0(sp)
    80005c8e:	6105                	addi	sp,sp,32
    80005c90:	8082                	ret

0000000080005c92 <mbuffree>:
{
    80005c92:	1141                	addi	sp,sp,-16
    80005c94:	e406                	sd	ra,8(sp)
    80005c96:	e022                	sd	s0,0(sp)
    80005c98:	0800                	addi	s0,sp,16
  kfree(m);
    80005c9a:	ffffa097          	auipc	ra,0xffffa
    80005c9e:	382080e7          	jalr	898(ra) # 8000001c <kfree>
}
    80005ca2:	60a2                	ld	ra,8(sp)
    80005ca4:	6402                	ld	s0,0(sp)
    80005ca6:	0141                	addi	sp,sp,16
    80005ca8:	8082                	ret

0000000080005caa <mbufq_pushtail>:
{
    80005caa:	1141                	addi	sp,sp,-16
    80005cac:	e422                	sd	s0,8(sp)
    80005cae:	0800                	addi	s0,sp,16
  m->next = 0;
    80005cb0:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005cb4:	611c                	ld	a5,0(a0)
    80005cb6:	c799                	beqz	a5,80005cc4 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005cb8:	651c                	ld	a5,8(a0)
    80005cba:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005cbc:	e50c                	sd	a1,8(a0)
}
    80005cbe:	6422                	ld	s0,8(sp)
    80005cc0:	0141                	addi	sp,sp,16
    80005cc2:	8082                	ret
    q->head = q->tail = m;
    80005cc4:	e50c                	sd	a1,8(a0)
    80005cc6:	e10c                	sd	a1,0(a0)
    return;
    80005cc8:	bfdd                	j	80005cbe <mbufq_pushtail+0x14>

0000000080005cca <mbufq_pophead>:
{
    80005cca:	1141                	addi	sp,sp,-16
    80005ccc:	e422                	sd	s0,8(sp)
    80005cce:	0800                	addi	s0,sp,16
    80005cd0:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005cd2:	6108                	ld	a0,0(a0)
  if (!head)
    80005cd4:	c119                	beqz	a0,80005cda <mbufq_pophead+0x10>
  q->head = head->next;
    80005cd6:	6118                	ld	a4,0(a0)
    80005cd8:	e398                	sd	a4,0(a5)
}
    80005cda:	6422                	ld	s0,8(sp)
    80005cdc:	0141                	addi	sp,sp,16
    80005cde:	8082                	ret

0000000080005ce0 <mbufq_empty>:
{
    80005ce0:	1141                	addi	sp,sp,-16
    80005ce2:	e422                	sd	s0,8(sp)
    80005ce4:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005ce6:	6108                	ld	a0,0(a0)
}
    80005ce8:	00153513          	seqz	a0,a0
    80005cec:	6422                	ld	s0,8(sp)
    80005cee:	0141                	addi	sp,sp,16
    80005cf0:	8082                	ret

0000000080005cf2 <mbufq_init>:
{
    80005cf2:	1141                	addi	sp,sp,-16
    80005cf4:	e422                	sd	s0,8(sp)
    80005cf6:	0800                	addi	s0,sp,16
  q->head = 0;
    80005cf8:	00053023          	sd	zero,0(a0)
}
    80005cfc:	6422                	ld	s0,8(sp)
    80005cfe:	0141                	addi	sp,sp,16
    80005d00:	8082                	ret

0000000080005d02 <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005d02:	7179                	addi	sp,sp,-48
    80005d04:	f406                	sd	ra,40(sp)
    80005d06:	f022                	sd	s0,32(sp)
    80005d08:	ec26                	sd	s1,24(sp)
    80005d0a:	e84a                	sd	s2,16(sp)
    80005d0c:	e44e                	sd	s3,8(sp)
    80005d0e:	e052                	sd	s4,0(sp)
    80005d10:	1800                	addi	s0,sp,48
    80005d12:	89aa                	mv	s3,a0
    80005d14:	892e                	mv	s2,a1
    80005d16:	8a32                	mv	s4,a2
    80005d18:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005d1a:	45a1                	li	a1,8
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	e14080e7          	jalr	-492(ra) # 80005b30 <mbufpush>
    80005d24:	008a161b          	slliw	a2,s4,0x8
    80005d28:	008a5a1b          	srliw	s4,s4,0x8
    80005d2c:	01466a33          	or	s4,a2,s4
  udphdr->sport = htons(sport);
    80005d30:	01451023          	sh	s4,0(a0)
    80005d34:	0084969b          	slliw	a3,s1,0x8
    80005d38:	0084d49b          	srliw	s1,s1,0x8
    80005d3c:	8cd5                	or	s1,s1,a3
  udphdr->dport = htons(dport);
    80005d3e:	00951123          	sh	s1,2(a0)
  udphdr->ulen = htons(m->len);
    80005d42:	0109a783          	lw	a5,16(s3)
    80005d46:	0087971b          	slliw	a4,a5,0x8
    80005d4a:	0107979b          	slliw	a5,a5,0x10
    80005d4e:	0107d79b          	srliw	a5,a5,0x10
    80005d52:	0087d79b          	srliw	a5,a5,0x8
    80005d56:	8fd9                	or	a5,a5,a4
    80005d58:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005d5c:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005d60:	45d1                	li	a1,20
    80005d62:	854e                	mv	a0,s3
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	dcc080e7          	jalr	-564(ra) # 80005b30 <mbufpush>
    80005d6c:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005d6e:	4651                	li	a2,20
    80005d70:	4581                	li	a1,0
    80005d72:	ffffa097          	auipc	ra,0xffffa
    80005d76:	406080e7          	jalr	1030(ra) # 80000178 <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005d7a:	04500793          	li	a5,69
    80005d7e:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005d82:	47c5                	li	a5,17
    80005d84:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005d88:	0f0207b7          	lui	a5,0xf020
    80005d8c:	07a9                	addi	a5,a5,10
    80005d8e:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005d90:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005d94:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005d98:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005d9a:	0089171b          	slliw	a4,s2,0x8
    80005d9e:	00ff06b7          	lui	a3,0xff0
    80005da2:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005da4:	8fd9                	or	a5,a5,a4
    80005da6:	0089591b          	srliw	s2,s2,0x8
    80005daa:	65c1                	lui	a1,0x10
    80005dac:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005db0:	00b97933          	and	s2,s2,a1
    80005db4:	0127e933          	or	s2,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005db8:	0124a823          	sw	s2,16(s1)
  iphdr->ip_len = htons(m->len);
    80005dbc:	0109a783          	lw	a5,16(s3)
  return (((val & 0x00ffU) << 8) |
    80005dc0:	0087971b          	slliw	a4,a5,0x8
    80005dc4:	0107979b          	slliw	a5,a5,0x10
    80005dc8:	0107d79b          	srliw	a5,a5,0x10
    80005dcc:	0087d79b          	srliw	a5,a5,0x8
    80005dd0:	8fd9                	or	a5,a5,a4
    80005dd2:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005dd6:	06400793          	li	a5,100
    80005dda:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005dde:	45d1                	li	a1,20
    80005de0:	8526                	mv	a0,s1
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	cb2080e7          	jalr	-846(ra) # 80005a94 <in_cksum>
    80005dea:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005dee:	6585                	lui	a1,0x1
    80005df0:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005df4:	854e                	mv	a0,s3
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	d70080e7          	jalr	-656(ra) # 80005b66 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005dfe:	70a2                	ld	ra,40(sp)
    80005e00:	7402                	ld	s0,32(sp)
    80005e02:	64e2                	ld	s1,24(sp)
    80005e04:	6942                	ld	s2,16(sp)
    80005e06:	69a2                	ld	s3,8(sp)
    80005e08:	6a02                	ld	s4,0(sp)
    80005e0a:	6145                	addi	sp,sp,48
    80005e0c:	8082                	ret

0000000080005e0e <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005e0e:	715d                	addi	sp,sp,-80
    80005e10:	e486                	sd	ra,72(sp)
    80005e12:	e0a2                	sd	s0,64(sp)
    80005e14:	fc26                	sd	s1,56(sp)
    80005e16:	f84a                	sd	s2,48(sp)
    80005e18:	f44e                	sd	s3,40(sp)
    80005e1a:	f052                	sd	s4,32(sp)
    80005e1c:	ec56                	sd	s5,24(sp)
    80005e1e:	0880                	addi	s0,sp,80
    80005e20:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005e22:	45b9                	li	a1,14
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	ce6080e7          	jalr	-794(ra) # 80005b0a <mbufpull>
  if (!ethhdr) {
    80005e2c:	c521                	beqz	a0,80005e74 <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005e2e:	00c54703          	lbu	a4,12(a0)
    80005e32:	00d54783          	lbu	a5,13(a0)
    80005e36:	07a2                	slli	a5,a5,0x8
    80005e38:	8fd9                	or	a5,a5,a4
    80005e3a:	0087971b          	slliw	a4,a5,0x8
    80005e3e:	83a1                	srli	a5,a5,0x8
    80005e40:	8fd9                	or	a5,a5,a4
    80005e42:	17c2                	slli	a5,a5,0x30
    80005e44:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005e46:	8007871b          	addiw	a4,a5,-2048
    80005e4a:	cb1d                	beqz	a4,80005e80 <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005e4c:	2781                	sext.w	a5,a5
    80005e4e:	6705                	lui	a4,0x1
    80005e50:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005e54:	1ae78a63          	beq	a5,a4,80006008 <net_rx+0x1fa>
  kfree(m);
    80005e58:	8526                	mv	a0,s1
    80005e5a:	ffffa097          	auipc	ra,0xffffa
    80005e5e:	1c2080e7          	jalr	450(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005e62:	60a6                	ld	ra,72(sp)
    80005e64:	6406                	ld	s0,64(sp)
    80005e66:	74e2                	ld	s1,56(sp)
    80005e68:	7942                	ld	s2,48(sp)
    80005e6a:	79a2                	ld	s3,40(sp)
    80005e6c:	7a02                	ld	s4,32(sp)
    80005e6e:	6ae2                	ld	s5,24(sp)
    80005e70:	6161                	addi	sp,sp,80
    80005e72:	8082                	ret
  kfree(m);
    80005e74:	8526                	mv	a0,s1
    80005e76:	ffffa097          	auipc	ra,0xffffa
    80005e7a:	1a6080e7          	jalr	422(ra) # 8000001c <kfree>
}
    80005e7e:	b7d5                	j	80005e62 <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005e80:	45d1                	li	a1,20
    80005e82:	8526                	mv	a0,s1
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	c86080e7          	jalr	-890(ra) # 80005b0a <mbufpull>
    80005e8c:	892a                	mv	s2,a0
  if (!iphdr)
    80005e8e:	c519                	beqz	a0,80005e9c <net_rx+0x8e>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005e90:	00054703          	lbu	a4,0(a0)
    80005e94:	04500793          	li	a5,69
    80005e98:	00f70863          	beq	a4,a5,80005ea8 <net_rx+0x9a>
  kfree(m);
    80005e9c:	8526                	mv	a0,s1
    80005e9e:	ffffa097          	auipc	ra,0xffffa
    80005ea2:	17e080e7          	jalr	382(ra) # 8000001c <kfree>
}
    80005ea6:	bf75                	j	80005e62 <net_rx+0x54>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005ea8:	45d1                	li	a1,20
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	bea080e7          	jalr	-1046(ra) # 80005a94 <in_cksum>
    80005eb2:	f56d                	bnez	a0,80005e9c <net_rx+0x8e>
    80005eb4:	00695783          	lhu	a5,6(s2)
    80005eb8:	0087971b          	slliw	a4,a5,0x8
    80005ebc:	0107979b          	slliw	a5,a5,0x10
    80005ec0:	0107d79b          	srliw	a5,a5,0x10
    80005ec4:	0087d79b          	srliw	a5,a5,0x8
    80005ec8:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005eca:	17c2                	slli	a5,a5,0x30
    80005ecc:	93c1                	srli	a5,a5,0x30
    80005ece:	f7f9                	bnez	a5,80005e9c <net_rx+0x8e>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005ed0:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005ed4:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005ed8:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005edc:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005ede:	0087169b          	slliw	a3,a4,0x8
    80005ee2:	00ff0637          	lui	a2,0xff0
    80005ee6:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005ee8:	8fd5                	or	a5,a5,a3
    80005eea:	0087571b          	srliw	a4,a4,0x8
    80005eee:	66c1                	lui	a3,0x10
    80005ef0:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005ef4:	8f75                	and	a4,a4,a3
    80005ef6:	8fd9                	or	a5,a5,a4
    80005ef8:	2781                	sext.w	a5,a5
    80005efa:	0a000737          	lui	a4,0xa000
    80005efe:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005f02:	f8e79de3          	bne	a5,a4,80005e9c <net_rx+0x8e>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005f06:	00994703          	lbu	a4,9(s2)
    80005f0a:	47c5                	li	a5,17
    80005f0c:	f8f718e3          	bne	a4,a5,80005e9c <net_rx+0x8e>
  return (((val & 0x00ffU) << 8) |
    80005f10:	00295783          	lhu	a5,2(s2)
    80005f14:	0087999b          	slliw	s3,a5,0x8
    80005f18:	0107979b          	slliw	a5,a5,0x10
    80005f1c:	0107d79b          	srliw	a5,a5,0x10
    80005f20:	0087d79b          	srliw	a5,a5,0x8
    80005f24:	00f9e7b3          	or	a5,s3,a5
    80005f28:	03079993          	slli	s3,a5,0x30
    80005f2c:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005f30:	fec9879b          	addiw	a5,s3,-20
    80005f34:	03079a13          	slli	s4,a5,0x30
    80005f38:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005f3c:	45a1                	li	a1,8
    80005f3e:	8526                	mv	a0,s1
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	bca080e7          	jalr	-1078(ra) # 80005b0a <mbufpull>
    80005f48:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005f4a:	cd0d                	beqz	a0,80005f84 <net_rx+0x176>
    80005f4c:	00455783          	lhu	a5,4(a0)
    80005f50:	0087971b          	slliw	a4,a5,0x8
    80005f54:	0107979b          	slliw	a5,a5,0x10
    80005f58:	0107d79b          	srliw	a5,a5,0x10
    80005f5c:	0087d79b          	srliw	a5,a5,0x8
    80005f60:	8f5d                	or	a4,a4,a5
  if (ntohs(udphdr->ulen) != len)
    80005f62:	000a079b          	sext.w	a5,s4
    80005f66:	1742                	slli	a4,a4,0x30
    80005f68:	9341                	srli	a4,a4,0x30
    80005f6a:	00e79d63          	bne	a5,a4,80005f84 <net_rx+0x176>
  len -= sizeof(*udphdr);
    80005f6e:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005f72:	0107979b          	slliw	a5,a5,0x10
    80005f76:	0107d79b          	srliw	a5,a5,0x10
    80005f7a:	0007871b          	sext.w	a4,a5
    80005f7e:	488c                	lw	a1,16(s1)
    80005f80:	00e5f863          	bgeu	a1,a4,80005f90 <net_rx+0x182>
  kfree(m);
    80005f84:	8526                	mv	a0,s1
    80005f86:	ffffa097          	auipc	ra,0xffffa
    80005f8a:	096080e7          	jalr	150(ra) # 8000001c <kfree>
}
    80005f8e:	bdd1                	j	80005e62 <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80005f90:	9d9d                	subw	a1,a1,a5
    80005f92:	8526                	mv	a0,s1
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	c84080e7          	jalr	-892(ra) # 80005c18 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005f9c:	00c92783          	lw	a5,12(s2)
    80005fa0:	000ad703          	lhu	a4,0(s5)
    80005fa4:	0087169b          	slliw	a3,a4,0x8
    80005fa8:	0107171b          	slliw	a4,a4,0x10
    80005fac:	0107571b          	srliw	a4,a4,0x10
    80005fb0:	0087571b          	srliw	a4,a4,0x8
    80005fb4:	8ed9                	or	a3,a3,a4
    80005fb6:	002ad703          	lhu	a4,2(s5)
    80005fba:	0087161b          	slliw	a2,a4,0x8
    80005fbe:	0107171b          	slliw	a4,a4,0x10
    80005fc2:	0107571b          	srliw	a4,a4,0x10
    80005fc6:	0087571b          	srliw	a4,a4,0x8
    80005fca:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005fcc:	0187971b          	slliw	a4,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005fd0:	0187d59b          	srliw	a1,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005fd4:	8f4d                	or	a4,a4,a1
          ((val & 0x0000ff00UL) << 8) |
    80005fd6:	0087959b          	slliw	a1,a5,0x8
    80005fda:	00ff0537          	lui	a0,0xff0
    80005fde:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005fe0:	8f4d                	or	a4,a4,a1
    80005fe2:	0087d79b          	srliw	a5,a5,0x8
    80005fe6:	65c1                	lui	a1,0x10
    80005fe8:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005fec:	8fed                	and	a5,a5,a1
    80005fee:	8fd9                	or	a5,a5,a4
  sockrecvudp(m, sip, dport, sport);
    80005ff0:	16c2                	slli	a3,a3,0x30
    80005ff2:	92c1                	srli	a3,a3,0x30
    80005ff4:	1642                	slli	a2,a2,0x30
    80005ff6:	9241                	srli	a2,a2,0x30
    80005ff8:	0007859b          	sext.w	a1,a5
    80005ffc:	8526                	mv	a0,s1
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	55c080e7          	jalr	1372(ra) # 8000655a <sockrecvudp>
  return;
    80006006:	bdb1                	j	80005e62 <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    80006008:	45f1                	li	a1,28
    8000600a:	8526                	mv	a0,s1
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	afe080e7          	jalr	-1282(ra) # 80005b0a <mbufpull>
    80006014:	892a                	mv	s2,a0
  if (!arphdr)
    80006016:	c179                	beqz	a0,800060dc <net_rx+0x2ce>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80006018:	00054703          	lbu	a4,0(a0) # ff0000 <_entry-0x7f010000>
    8000601c:	00154783          	lbu	a5,1(a0)
    80006020:	07a2                	slli	a5,a5,0x8
    80006022:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    80006024:	0087971b          	slliw	a4,a5,0x8
    80006028:	83a1                	srli	a5,a5,0x8
    8000602a:	8fd9                	or	a5,a5,a4
    8000602c:	17c2                	slli	a5,a5,0x30
    8000602e:	93c1                	srli	a5,a5,0x30
    80006030:	4705                	li	a4,1
    80006032:	0ae79563          	bne	a5,a4,800060dc <net_rx+0x2ce>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80006036:	00254703          	lbu	a4,2(a0)
    8000603a:	00354783          	lbu	a5,3(a0)
    8000603e:	07a2                	slli	a5,a5,0x8
    80006040:	8fd9                	or	a5,a5,a4
    80006042:	0087971b          	slliw	a4,a5,0x8
    80006046:	83a1                	srli	a5,a5,0x8
    80006048:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    8000604a:	0107979b          	slliw	a5,a5,0x10
    8000604e:	0107d79b          	srliw	a5,a5,0x10
    80006052:	8007879b          	addiw	a5,a5,-2048
    80006056:	e3d9                	bnez	a5,800060dc <net_rx+0x2ce>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80006058:	00454703          	lbu	a4,4(a0)
    8000605c:	4799                	li	a5,6
    8000605e:	06f71f63          	bne	a4,a5,800060dc <net_rx+0x2ce>
      arphdr->hln != ETHADDR_LEN ||
    80006062:	00554703          	lbu	a4,5(a0)
    80006066:	4791                	li	a5,4
    80006068:	06f71a63          	bne	a4,a5,800060dc <net_rx+0x2ce>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    8000606c:	00654703          	lbu	a4,6(a0)
    80006070:	00754783          	lbu	a5,7(a0)
    80006074:	07a2                	slli	a5,a5,0x8
    80006076:	8fd9                	or	a5,a5,a4
    80006078:	0087971b          	slliw	a4,a5,0x8
    8000607c:	83a1                	srli	a5,a5,0x8
    8000607e:	8fd9                	or	a5,a5,a4
    80006080:	17c2                	slli	a5,a5,0x30
    80006082:	93c1                	srli	a5,a5,0x30
    80006084:	4705                	li	a4,1
    80006086:	04e79b63          	bne	a5,a4,800060dc <net_rx+0x2ce>
  tip = ntohl(arphdr->tip); // target IP address
    8000608a:	01854783          	lbu	a5,24(a0)
    8000608e:	01954703          	lbu	a4,25(a0)
    80006092:	0722                	slli	a4,a4,0x8
    80006094:	8f5d                	or	a4,a4,a5
    80006096:	01a54783          	lbu	a5,26(a0)
    8000609a:	07c2                	slli	a5,a5,0x10
    8000609c:	8f5d                	or	a4,a4,a5
    8000609e:	01b54783          	lbu	a5,27(a0)
    800060a2:	07e2                	slli	a5,a5,0x18
    800060a4:	8fd9                	or	a5,a5,a4
    800060a6:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800060aa:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060ae:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060b2:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    800060b4:	0087169b          	slliw	a3,a4,0x8
    800060b8:	00ff0637          	lui	a2,0xff0
    800060bc:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    800060be:	8fd5                	or	a5,a5,a3
    800060c0:	0087571b          	srliw	a4,a4,0x8
    800060c4:	66c1                	lui	a3,0x10
    800060c6:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800060ca:	8f75                	and	a4,a4,a3
    800060cc:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    800060ce:	2781                	sext.w	a5,a5
    800060d0:	0a000737          	lui	a4,0xa000
    800060d4:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    800060d8:	00e78863          	beq	a5,a4,800060e8 <net_rx+0x2da>
  kfree(m);
    800060dc:	8526                	mv	a0,s1
    800060de:	ffffa097          	auipc	ra,0xffffa
    800060e2:	f3e080e7          	jalr	-194(ra) # 8000001c <kfree>
}
    800060e6:	bbb5                	j	80005e62 <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    800060e8:	4619                	li	a2,6
    800060ea:	00850593          	addi	a1,a0,8
    800060ee:	fb840513          	addi	a0,s0,-72
    800060f2:	ffffa097          	auipc	ra,0xffffa
    800060f6:	0e2080e7          	jalr	226(ra) # 800001d4 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    800060fa:	00e94783          	lbu	a5,14(s2)
    800060fe:	00f94703          	lbu	a4,15(s2)
    80006102:	0722                	slli	a4,a4,0x8
    80006104:	8f5d                	or	a4,a4,a5
    80006106:	01094783          	lbu	a5,16(s2)
    8000610a:	07c2                	slli	a5,a5,0x10
    8000610c:	8f5d                	or	a4,a4,a5
    8000610e:	01194783          	lbu	a5,17(s2)
    80006112:	07e2                	slli	a5,a5,0x18
    80006114:	8fd9                	or	a5,a5,a4
    80006116:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    8000611a:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    8000611e:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006122:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    80006126:	0087179b          	slliw	a5,a4,0x8
    8000612a:	00ff06b7          	lui	a3,0xff0
    8000612e:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006130:	00f96933          	or	s2,s2,a5
    80006134:	0087579b          	srliw	a5,a4,0x8
    80006138:	6741                	lui	a4,0x10
    8000613a:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    8000613e:	8ff9                	and	a5,a5,a4
    80006140:	00f96933          	or	s2,s2,a5
    80006144:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006146:	08000513          	li	a0,128
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	af0080e7          	jalr	-1296(ra) # 80005c3a <mbufalloc>
    80006152:	8a2a                	mv	s4,a0
  if (!m)
    80006154:	d541                	beqz	a0,800060dc <net_rx+0x2ce>
  arphdr = mbufputhdr(m, *arphdr);
    80006156:	45f1                	li	a1,28
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	a86080e7          	jalr	-1402(ra) # 80005bde <mbufput>
    80006160:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    80006162:	00050023          	sb	zero,0(a0)
    80006166:	4785                	li	a5,1
    80006168:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    8000616c:	47a1                	li	a5,8
    8000616e:	00f50123          	sb	a5,2(a0)
    80006172:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80006176:	4799                	li	a5,6
    80006178:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    8000617c:	4791                	li	a5,4
    8000617e:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    80006182:	00050323          	sb	zero,6(a0)
    80006186:	4a89                	li	s5,2
    80006188:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    8000618c:	4619                	li	a2,6
    8000618e:	00003597          	auipc	a1,0x3
    80006192:	73258593          	addi	a1,a1,1842 # 800098c0 <local_mac>
    80006196:	0521                	addi	a0,a0,8
    80006198:	ffffa097          	auipc	ra,0xffffa
    8000619c:	03c080e7          	jalr	60(ra) # 800001d4 <memmove>
  arphdr->sip = htonl(local_ip);
    800061a0:	47a9                	li	a5,10
    800061a2:	00f98723          	sb	a5,14(s3)
    800061a6:	000987a3          	sb	zero,15(s3)
    800061aa:	01598823          	sb	s5,16(s3)
    800061ae:	47bd                	li	a5,15
    800061b0:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    800061b4:	4619                	li	a2,6
    800061b6:	fb840593          	addi	a1,s0,-72
    800061ba:	01298513          	addi	a0,s3,18
    800061be:	ffffa097          	auipc	ra,0xffffa
    800061c2:	016080e7          	jalr	22(ra) # 800001d4 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    800061c6:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    800061ca:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061ce:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    800061d0:	0089179b          	slliw	a5,s2,0x8
    800061d4:	00ff06b7          	lui	a3,0xff0
    800061d8:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061da:	8f5d                	or	a4,a4,a5
    800061dc:	0089579b          	srliw	a5,s2,0x8
    800061e0:	66c1                	lui	a3,0x10
    800061e2:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800061e6:	8ff5                	and	a5,a5,a3
    800061e8:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    800061ea:	00e98c23          	sb	a4,24(s3)
    800061ee:	0087d71b          	srliw	a4,a5,0x8
    800061f2:	00e98ca3          	sb	a4,25(s3)
    800061f6:	0107d71b          	srliw	a4,a5,0x10
    800061fa:	00e98d23          	sb	a4,26(s3)
    800061fe:	0187d79b          	srliw	a5,a5,0x18
    80006202:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    80006206:	6585                	lui	a1,0x1
    80006208:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    8000620c:	8552                	mv	a0,s4
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	958080e7          	jalr	-1704(ra) # 80005b66 <net_tx_eth>
  return 0;
    80006216:	b5d9                	j	800060dc <net_rx+0x2ce>

0000000080006218 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    80006218:	1141                	addi	sp,sp,-16
    8000621a:	e406                	sd	ra,8(sp)
    8000621c:	e022                	sd	s0,0(sp)
    8000621e:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    80006220:	00003597          	auipc	a1,0x3
    80006224:	60058593          	addi	a1,a1,1536 # 80009820 <syscalls+0x448>
    80006228:	00019517          	auipc	a0,0x19
    8000622c:	0f850513          	addi	a0,a0,248 # 8001f320 <lock>
    80006230:	00001097          	auipc	ra,0x1
    80006234:	e46080e7          	jalr	-442(ra) # 80007076 <initlock>
}
    80006238:	60a2                	ld	ra,8(sp)
    8000623a:	6402                	ld	s0,0(sp)
    8000623c:	0141                	addi	sp,sp,16
    8000623e:	8082                	ret

0000000080006240 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    80006240:	7139                	addi	sp,sp,-64
    80006242:	fc06                	sd	ra,56(sp)
    80006244:	f822                	sd	s0,48(sp)
    80006246:	f426                	sd	s1,40(sp)
    80006248:	f04a                	sd	s2,32(sp)
    8000624a:	ec4e                	sd	s3,24(sp)
    8000624c:	e852                	sd	s4,16(sp)
    8000624e:	e456                	sd	s5,8(sp)
    80006250:	0080                	addi	s0,sp,64
    80006252:	892a                	mv	s2,a0
    80006254:	84ae                	mv	s1,a1
    80006256:	8a32                	mv	s4,a2
    80006258:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    8000625a:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    8000625e:	ffffd097          	auipc	ra,0xffffd
    80006262:	66e080e7          	jalr	1646(ra) # 800038cc <filealloc>
    80006266:	00a93023          	sd	a0,0(s2)
    8000626a:	c975                	beqz	a0,8000635e <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    8000626c:	ffffa097          	auipc	ra,0xffffa
    80006270:	eac080e7          	jalr	-340(ra) # 80000118 <kalloc>
    80006274:	8aaa                	mv	s5,a0
    80006276:	c15d                	beqz	a0,8000631c <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    80006278:	c504                	sw	s1,8(a0)
  si->lport = lport;
    8000627a:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    8000627e:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    80006282:	00003597          	auipc	a1,0x3
    80006286:	5a658593          	addi	a1,a1,1446 # 80009828 <syscalls+0x450>
    8000628a:	0541                	addi	a0,a0,16
    8000628c:	00001097          	auipc	ra,0x1
    80006290:	dea080e7          	jalr	-534(ra) # 80007076 <initlock>
  mbufq_init(&si->rxq);
    80006294:	028a8513          	addi	a0,s5,40
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	a5a080e7          	jalr	-1446(ra) # 80005cf2 <mbufq_init>
  (*f)->type = FD_SOCK;
    800062a0:	00093783          	ld	a5,0(s2)
    800062a4:	4711                	li	a4,4
    800062a6:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    800062a8:	00093703          	ld	a4,0(s2)
    800062ac:	4785                	li	a5,1
    800062ae:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    800062b2:	00093703          	ld	a4,0(s2)
    800062b6:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    800062ba:	00093783          	ld	a5,0(s2)
    800062be:	0357b023          	sd	s5,32(a5) # f020020 <_entry-0x70fdffe0>

  // add to list of sockets
  acquire(&lock);
    800062c2:	00019517          	auipc	a0,0x19
    800062c6:	05e50513          	addi	a0,a0,94 # 8001f320 <lock>
    800062ca:	00001097          	auipc	ra,0x1
    800062ce:	e3c080e7          	jalr	-452(ra) # 80007106 <acquire>
  pos = sockets;
    800062d2:	00004597          	auipc	a1,0x4
    800062d6:	d565b583          	ld	a1,-682(a1) # 8000a028 <sockets>
  while (pos) {
    800062da:	c9b1                	beqz	a1,8000632e <sockalloc+0xee>
  pos = sockets;
    800062dc:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    800062de:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    800062e2:	0009869b          	sext.w	a3,s3
    800062e6:	a019                	j	800062ec <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    800062e8:	639c                	ld	a5,0(a5)
  while (pos) {
    800062ea:	c3b1                	beqz	a5,8000632e <sockalloc+0xee>
    if (pos->raddr == raddr &&
    800062ec:	4798                	lw	a4,8(a5)
    800062ee:	fe971de3          	bne	a4,s1,800062e8 <sockalloc+0xa8>
    800062f2:	00c7d703          	lhu	a4,12(a5)
    800062f6:	fec719e3          	bne	a4,a2,800062e8 <sockalloc+0xa8>
        pos->lport == lport &&
    800062fa:	00e7d703          	lhu	a4,14(a5)
    800062fe:	fed715e3          	bne	a4,a3,800062e8 <sockalloc+0xa8>
      release(&lock);
    80006302:	00019517          	auipc	a0,0x19
    80006306:	01e50513          	addi	a0,a0,30 # 8001f320 <lock>
    8000630a:	00001097          	auipc	ra,0x1
    8000630e:	eb0080e7          	jalr	-336(ra) # 800071ba <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    80006312:	8556                	mv	a0,s5
    80006314:	ffffa097          	auipc	ra,0xffffa
    80006318:	d08080e7          	jalr	-760(ra) # 8000001c <kfree>
  if (*f)
    8000631c:	00093503          	ld	a0,0(s2)
    80006320:	c129                	beqz	a0,80006362 <sockalloc+0x122>
    fileclose(*f);
    80006322:	ffffd097          	auipc	ra,0xffffd
    80006326:	666080e7          	jalr	1638(ra) # 80003988 <fileclose>
  return -1;
    8000632a:	557d                	li	a0,-1
    8000632c:	a005                	j	8000634c <sockalloc+0x10c>
  si->next = sockets;
    8000632e:	00bab023          	sd	a1,0(s5)
  sockets = si;
    80006332:	00004797          	auipc	a5,0x4
    80006336:	cf57bb23          	sd	s5,-778(a5) # 8000a028 <sockets>
  release(&lock);
    8000633a:	00019517          	auipc	a0,0x19
    8000633e:	fe650513          	addi	a0,a0,-26 # 8001f320 <lock>
    80006342:	00001097          	auipc	ra,0x1
    80006346:	e78080e7          	jalr	-392(ra) # 800071ba <release>
  return 0;
    8000634a:	4501                	li	a0,0
}
    8000634c:	70e2                	ld	ra,56(sp)
    8000634e:	7442                	ld	s0,48(sp)
    80006350:	74a2                	ld	s1,40(sp)
    80006352:	7902                	ld	s2,32(sp)
    80006354:	69e2                	ld	s3,24(sp)
    80006356:	6a42                	ld	s4,16(sp)
    80006358:	6aa2                	ld	s5,8(sp)
    8000635a:	6121                	addi	sp,sp,64
    8000635c:	8082                	ret
  return -1;
    8000635e:	557d                	li	a0,-1
    80006360:	b7f5                	j	8000634c <sockalloc+0x10c>
    80006362:	557d                	li	a0,-1
    80006364:	b7e5                	j	8000634c <sockalloc+0x10c>

0000000080006366 <sockclose>:

void
sockclose(struct sock *si)
{
    80006366:	1101                	addi	sp,sp,-32
    80006368:	ec06                	sd	ra,24(sp)
    8000636a:	e822                	sd	s0,16(sp)
    8000636c:	e426                	sd	s1,8(sp)
    8000636e:	e04a                	sd	s2,0(sp)
    80006370:	1000                	addi	s0,sp,32
    80006372:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    80006374:	00019517          	auipc	a0,0x19
    80006378:	fac50513          	addi	a0,a0,-84 # 8001f320 <lock>
    8000637c:	00001097          	auipc	ra,0x1
    80006380:	d8a080e7          	jalr	-630(ra) # 80007106 <acquire>
  pos = &sockets;
    80006384:	00004797          	auipc	a5,0x4
    80006388:	ca47b783          	ld	a5,-860(a5) # 8000a028 <sockets>
  while (*pos) {
    8000638c:	cb99                	beqz	a5,800063a2 <sockclose+0x3c>
    if (*pos == si){
    8000638e:	04f90463          	beq	s2,a5,800063d6 <sockclose+0x70>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    80006392:	873e                	mv	a4,a5
    80006394:	639c                	ld	a5,0(a5)
  while (*pos) {
    80006396:	c791                	beqz	a5,800063a2 <sockclose+0x3c>
    if (*pos == si){
    80006398:	fef91de3          	bne	s2,a5,80006392 <sockclose+0x2c>
      *pos = si->next;
    8000639c:	00093783          	ld	a5,0(s2)
    800063a0:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    800063a2:	00019517          	auipc	a0,0x19
    800063a6:	f7e50513          	addi	a0,a0,-130 # 8001f320 <lock>
    800063aa:	00001097          	auipc	ra,0x1
    800063ae:	e10080e7          	jalr	-496(ra) # 800071ba <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    800063b2:	02890493          	addi	s1,s2,40
    800063b6:	8526                	mv	a0,s1
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	928080e7          	jalr	-1752(ra) # 80005ce0 <mbufq_empty>
    800063c0:	e105                	bnez	a0,800063e0 <sockclose+0x7a>
    m = mbufq_pophead(&si->rxq);
    800063c2:	8526                	mv	a0,s1
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	906080e7          	jalr	-1786(ra) # 80005cca <mbufq_pophead>
    mbuffree(m);
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	8c6080e7          	jalr	-1850(ra) # 80005c92 <mbuffree>
    800063d4:	b7cd                	j	800063b6 <sockclose+0x50>
  pos = &sockets;
    800063d6:	00004717          	auipc	a4,0x4
    800063da:	c5270713          	addi	a4,a4,-942 # 8000a028 <sockets>
    800063de:	bf7d                	j	8000639c <sockclose+0x36>
  }

  kfree((char*)si);
    800063e0:	854a                	mv	a0,s2
    800063e2:	ffffa097          	auipc	ra,0xffffa
    800063e6:	c3a080e7          	jalr	-966(ra) # 8000001c <kfree>
}
    800063ea:	60e2                	ld	ra,24(sp)
    800063ec:	6442                	ld	s0,16(sp)
    800063ee:	64a2                	ld	s1,8(sp)
    800063f0:	6902                	ld	s2,0(sp)
    800063f2:	6105                	addi	sp,sp,32
    800063f4:	8082                	ret

00000000800063f6 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    800063f6:	7139                	addi	sp,sp,-64
    800063f8:	fc06                	sd	ra,56(sp)
    800063fa:	f822                	sd	s0,48(sp)
    800063fc:	f426                	sd	s1,40(sp)
    800063fe:	f04a                	sd	s2,32(sp)
    80006400:	ec4e                	sd	s3,24(sp)
    80006402:	e852                	sd	s4,16(sp)
    80006404:	e456                	sd	s5,8(sp)
    80006406:	0080                	addi	s0,sp,64
    80006408:	84aa                	mv	s1,a0
    8000640a:	8a2e                	mv	s4,a1
    8000640c:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    8000640e:	ffffb097          	auipc	ra,0xffffb
    80006412:	a8c080e7          	jalr	-1396(ra) # 80000e9a <myproc>
    80006416:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    80006418:	01048993          	addi	s3,s1,16
    8000641c:	854e                	mv	a0,s3
    8000641e:	00001097          	auipc	ra,0x1
    80006422:	ce8080e7          	jalr	-792(ra) # 80007106 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    80006426:	02848493          	addi	s1,s1,40
    8000642a:	a039                	j	80006438 <sockread+0x42>
    sleep(&si->rxq, &si->lock);
    8000642c:	85ce                	mv	a1,s3
    8000642e:	8526                	mv	a0,s1
    80006430:	ffffb097          	auipc	ra,0xffffb
    80006434:	12a080e7          	jalr	298(ra) # 8000155a <sleep>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    80006438:	8526                	mv	a0,s1
    8000643a:	00000097          	auipc	ra,0x0
    8000643e:	8a6080e7          	jalr	-1882(ra) # 80005ce0 <mbufq_empty>
    80006442:	c919                	beqz	a0,80006458 <sockread+0x62>
    80006444:	02892783          	lw	a5,40(s2)
    80006448:	d3f5                	beqz	a5,8000642c <sockread+0x36>
  }
  if (pr->killed) {
    release(&si->lock);
    8000644a:	854e                	mv	a0,s3
    8000644c:	00001097          	auipc	ra,0x1
    80006450:	d6e080e7          	jalr	-658(ra) # 800071ba <release>
    return -1;
    80006454:	59fd                	li	s3,-1
    80006456:	a0b9                	j	800064a4 <sockread+0xae>
  if (pr->killed) {
    80006458:	02892783          	lw	a5,40(s2)
    8000645c:	f7fd                	bnez	a5,8000644a <sockread+0x54>
  }
  m = mbufq_pophead(&si->rxq);
    8000645e:	8526                	mv	a0,s1
    80006460:	00000097          	auipc	ra,0x0
    80006464:	86a080e7          	jalr	-1942(ra) # 80005cca <mbufq_pophead>
    80006468:	84aa                	mv	s1,a0
  release(&si->lock);
    8000646a:	854e                	mv	a0,s3
    8000646c:	00001097          	auipc	ra,0x1
    80006470:	d4e080e7          	jalr	-690(ra) # 800071ba <release>

  len = m->len;
    80006474:	489c                	lw	a5,16(s1)
  if (len > n)
    80006476:	89be                	mv	s3,a5
    80006478:	00fad363          	bge	s5,a5,8000647e <sockread+0x88>
    8000647c:	89d6                	mv	s3,s5
    8000647e:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    80006480:	86ce                	mv	a3,s3
    80006482:	6490                	ld	a2,8(s1)
    80006484:	85d2                	mv	a1,s4
    80006486:	05093503          	ld	a0,80(s2)
    8000648a:	ffffa097          	auipc	ra,0xffffa
    8000648e:	6d4080e7          	jalr	1748(ra) # 80000b5e <copyout>
    80006492:	892a                	mv	s2,a0
    80006494:	57fd                	li	a5,-1
    80006496:	02f50163          	beq	a0,a5,800064b8 <sockread+0xc2>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    8000649a:	8526                	mv	a0,s1
    8000649c:	fffff097          	auipc	ra,0xfffff
    800064a0:	7f6080e7          	jalr	2038(ra) # 80005c92 <mbuffree>
  return len;
}
    800064a4:	854e                	mv	a0,s3
    800064a6:	70e2                	ld	ra,56(sp)
    800064a8:	7442                	ld	s0,48(sp)
    800064aa:	74a2                	ld	s1,40(sp)
    800064ac:	7902                	ld	s2,32(sp)
    800064ae:	69e2                	ld	s3,24(sp)
    800064b0:	6a42                	ld	s4,16(sp)
    800064b2:	6aa2                	ld	s5,8(sp)
    800064b4:	6121                	addi	sp,sp,64
    800064b6:	8082                	ret
    mbuffree(m);
    800064b8:	8526                	mv	a0,s1
    800064ba:	fffff097          	auipc	ra,0xfffff
    800064be:	7d8080e7          	jalr	2008(ra) # 80005c92 <mbuffree>
    return -1;
    800064c2:	89ca                	mv	s3,s2
    800064c4:	b7c5                	j	800064a4 <sockread+0xae>

00000000800064c6 <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    800064c6:	7139                	addi	sp,sp,-64
    800064c8:	fc06                	sd	ra,56(sp)
    800064ca:	f822                	sd	s0,48(sp)
    800064cc:	f426                	sd	s1,40(sp)
    800064ce:	f04a                	sd	s2,32(sp)
    800064d0:	ec4e                	sd	s3,24(sp)
    800064d2:	e852                	sd	s4,16(sp)
    800064d4:	e456                	sd	s5,8(sp)
    800064d6:	0080                	addi	s0,sp,64
    800064d8:	8aaa                	mv	s5,a0
    800064da:	89ae                	mv	s3,a1
    800064dc:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    800064de:	ffffb097          	auipc	ra,0xffffb
    800064e2:	9bc080e7          	jalr	-1604(ra) # 80000e9a <myproc>
    800064e6:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    800064e8:	08000513          	li	a0,128
    800064ec:	fffff097          	auipc	ra,0xfffff
    800064f0:	74e080e7          	jalr	1870(ra) # 80005c3a <mbufalloc>
  if (!m)
    800064f4:	c12d                	beqz	a0,80006556 <sockwrite+0x90>
    800064f6:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    800064f8:	050a3a03          	ld	s4,80(s4)
    800064fc:	85ca                	mv	a1,s2
    800064fe:	fffff097          	auipc	ra,0xfffff
    80006502:	6e0080e7          	jalr	1760(ra) # 80005bde <mbufput>
    80006506:	85aa                	mv	a1,a0
    80006508:	86ca                	mv	a3,s2
    8000650a:	864e                	mv	a2,s3
    8000650c:	8552                	mv	a0,s4
    8000650e:	ffffa097          	auipc	ra,0xffffa
    80006512:	6dc080e7          	jalr	1756(ra) # 80000bea <copyin>
    80006516:	89aa                	mv	s3,a0
    80006518:	57fd                	li	a5,-1
    8000651a:	02f50863          	beq	a0,a5,8000654a <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    8000651e:	00ead683          	lhu	a3,14(s5)
    80006522:	00cad603          	lhu	a2,12(s5)
    80006526:	008aa583          	lw	a1,8(s5)
    8000652a:	8526                	mv	a0,s1
    8000652c:	fffff097          	auipc	ra,0xfffff
    80006530:	7d6080e7          	jalr	2006(ra) # 80005d02 <net_tx_udp>
  return n;
    80006534:	89ca                	mv	s3,s2
}
    80006536:	854e                	mv	a0,s3
    80006538:	70e2                	ld	ra,56(sp)
    8000653a:	7442                	ld	s0,48(sp)
    8000653c:	74a2                	ld	s1,40(sp)
    8000653e:	7902                	ld	s2,32(sp)
    80006540:	69e2                	ld	s3,24(sp)
    80006542:	6a42                	ld	s4,16(sp)
    80006544:	6aa2                	ld	s5,8(sp)
    80006546:	6121                	addi	sp,sp,64
    80006548:	8082                	ret
    mbuffree(m);
    8000654a:	8526                	mv	a0,s1
    8000654c:	fffff097          	auipc	ra,0xfffff
    80006550:	746080e7          	jalr	1862(ra) # 80005c92 <mbuffree>
    return -1;
    80006554:	b7cd                	j	80006536 <sockwrite+0x70>
    return -1;
    80006556:	59fd                	li	s3,-1
    80006558:	bff9                	j	80006536 <sockwrite+0x70>

000000008000655a <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    8000655a:	7139                	addi	sp,sp,-64
    8000655c:	fc06                	sd	ra,56(sp)
    8000655e:	f822                	sd	s0,48(sp)
    80006560:	f426                	sd	s1,40(sp)
    80006562:	f04a                	sd	s2,32(sp)
    80006564:	ec4e                	sd	s3,24(sp)
    80006566:	e852                	sd	s4,16(sp)
    80006568:	e456                	sd	s5,8(sp)
    8000656a:	0080                	addi	s0,sp,64
    8000656c:	8a2a                	mv	s4,a0
    8000656e:	892e                	mv	s2,a1
    80006570:	89b2                	mv	s3,a2
    80006572:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    80006574:	00019517          	auipc	a0,0x19
    80006578:	dac50513          	addi	a0,a0,-596 # 8001f320 <lock>
    8000657c:	00001097          	auipc	ra,0x1
    80006580:	b8a080e7          	jalr	-1142(ra) # 80007106 <acquire>
  si = sockets;
    80006584:	00004497          	auipc	s1,0x4
    80006588:	aa44b483          	ld	s1,-1372(s1) # 8000a028 <sockets>
  while (si) {
    8000658c:	c4ad                	beqz	s1,800065f6 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    8000658e:	0009871b          	sext.w	a4,s3
    80006592:	000a869b          	sext.w	a3,s5
    80006596:	a019                	j	8000659c <sockrecvudp+0x42>
      goto found;
    si = si->next;
    80006598:	6084                	ld	s1,0(s1)
  while (si) {
    8000659a:	ccb1                	beqz	s1,800065f6 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    8000659c:	449c                	lw	a5,8(s1)
    8000659e:	ff279de3          	bne	a5,s2,80006598 <sockrecvudp+0x3e>
    800065a2:	00c4d783          	lhu	a5,12(s1)
    800065a6:	fee799e3          	bne	a5,a4,80006598 <sockrecvudp+0x3e>
    800065aa:	00e4d783          	lhu	a5,14(s1)
    800065ae:	fed795e3          	bne	a5,a3,80006598 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    800065b2:	01048913          	addi	s2,s1,16
    800065b6:	854a                	mv	a0,s2
    800065b8:	00001097          	auipc	ra,0x1
    800065bc:	b4e080e7          	jalr	-1202(ra) # 80007106 <acquire>
  mbufq_pushtail(&si->rxq, m);
    800065c0:	02848493          	addi	s1,s1,40
    800065c4:	85d2                	mv	a1,s4
    800065c6:	8526                	mv	a0,s1
    800065c8:	fffff097          	auipc	ra,0xfffff
    800065cc:	6e2080e7          	jalr	1762(ra) # 80005caa <mbufq_pushtail>
  wakeup(&si->rxq);
    800065d0:	8526                	mv	a0,s1
    800065d2:	ffffb097          	auipc	ra,0xffffb
    800065d6:	114080e7          	jalr	276(ra) # 800016e6 <wakeup>
  release(&si->lock);
    800065da:	854a                	mv	a0,s2
    800065dc:	00001097          	auipc	ra,0x1
    800065e0:	bde080e7          	jalr	-1058(ra) # 800071ba <release>
  release(&lock);
    800065e4:	00019517          	auipc	a0,0x19
    800065e8:	d3c50513          	addi	a0,a0,-708 # 8001f320 <lock>
    800065ec:	00001097          	auipc	ra,0x1
    800065f0:	bce080e7          	jalr	-1074(ra) # 800071ba <release>
    800065f4:	a831                	j	80006610 <sockrecvudp+0xb6>
  release(&lock);
    800065f6:	00019517          	auipc	a0,0x19
    800065fa:	d2a50513          	addi	a0,a0,-726 # 8001f320 <lock>
    800065fe:	00001097          	auipc	ra,0x1
    80006602:	bbc080e7          	jalr	-1092(ra) # 800071ba <release>
  mbuffree(m);
    80006606:	8552                	mv	a0,s4
    80006608:	fffff097          	auipc	ra,0xfffff
    8000660c:	68a080e7          	jalr	1674(ra) # 80005c92 <mbuffree>
}
    80006610:	70e2                	ld	ra,56(sp)
    80006612:	7442                	ld	s0,48(sp)
    80006614:	74a2                	ld	s1,40(sp)
    80006616:	7902                	ld	s2,32(sp)
    80006618:	69e2                	ld	s3,24(sp)
    8000661a:	6a42                	ld	s4,16(sp)
    8000661c:	6aa2                	ld	s5,8(sp)
    8000661e:	6121                	addi	sp,sp,64
    80006620:	8082                	ret

0000000080006622 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    80006622:	715d                	addi	sp,sp,-80
    80006624:	e486                	sd	ra,72(sp)
    80006626:	e0a2                	sd	s0,64(sp)
    80006628:	fc26                	sd	s1,56(sp)
    8000662a:	f84a                	sd	s2,48(sp)
    8000662c:	f44e                	sd	s3,40(sp)
    8000662e:	f052                	sd	s4,32(sp)
    80006630:	ec56                	sd	s5,24(sp)
    80006632:	e85a                	sd	s6,16(sp)
    80006634:	e45e                	sd	s7,8(sp)
    80006636:	0880                	addi	s0,sp,80
    80006638:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    8000663c:	100e8937          	lui	s2,0x100e8
    80006640:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006644:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80006646:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80006648:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    8000664c:	6a09                	lui	s4,0x2
    8000664e:	300409b7          	lui	s3,0x30040
    80006652:	a819                	j	80006668 <pci_init+0x46>
      base[4+0] = e1000_regs;
    80006654:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80006658:	855a                	mv	a0,s6
    8000665a:	fffff097          	auipc	ra,0xfffff
    8000665e:	0b8080e7          	jalr	184(ra) # 80005712 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    80006662:	94d2                	add	s1,s1,s4
    80006664:	03348a63          	beq	s1,s3,80006698 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006668:	86a6                	mv	a3,s1
    uint32 id = base[0];
    8000666a:	409c                	lw	a5,0(s1)
    8000666c:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    8000666e:	ff279ae3          	bne	a5,s2,80006662 <pci_init+0x40>
      base[1] = 7;
    80006672:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80006676:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    8000667a:	01048793          	addi	a5,s1,16
    8000667e:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80006682:	4398                	lw	a4,0(a5)
    80006684:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80006686:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    8000668a:	0ff0000f          	fence
        base[4+i] = old;
    8000668e:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80006690:	0791                	addi	a5,a5,4
    80006692:	fec798e3          	bne	a5,a2,80006682 <pci_init+0x60>
    80006696:	bf7d                	j	80006654 <pci_init+0x32>
    }
  }
}
    80006698:	60a6                	ld	ra,72(sp)
    8000669a:	6406                	ld	s0,64(sp)
    8000669c:	74e2                	ld	s1,56(sp)
    8000669e:	7942                	ld	s2,48(sp)
    800066a0:	79a2                	ld	s3,40(sp)
    800066a2:	7a02                	ld	s4,32(sp)
    800066a4:	6ae2                	ld	s5,24(sp)
    800066a6:	6b42                	ld	s6,16(sp)
    800066a8:	6ba2                	ld	s7,8(sp)
    800066aa:	6161                	addi	sp,sp,80
    800066ac:	8082                	ret

00000000800066ae <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800066ae:	1141                	addi	sp,sp,-16
    800066b0:	e422                	sd	s0,8(sp)
    800066b2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800066b4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800066b8:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800066bc:	0037979b          	slliw	a5,a5,0x3
    800066c0:	02004737          	lui	a4,0x2004
    800066c4:	97ba                	add	a5,a5,a4
    800066c6:	0200c737          	lui	a4,0x200c
    800066ca:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800066ce:	000f4637          	lui	a2,0xf4
    800066d2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800066d6:	95b2                	add	a1,a1,a2
    800066d8:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800066da:	00269713          	slli	a4,a3,0x2
    800066de:	9736                	add	a4,a4,a3
    800066e0:	00371693          	slli	a3,a4,0x3
    800066e4:	00019717          	auipc	a4,0x19
    800066e8:	c5c70713          	addi	a4,a4,-932 # 8001f340 <timer_scratch>
    800066ec:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800066ee:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800066f0:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800066f2:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800066f6:	fffff797          	auipc	a5,0xfffff
    800066fa:	a0a78793          	addi	a5,a5,-1526 # 80005100 <timervec>
    800066fe:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006702:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006706:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000670a:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000670e:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80006712:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80006716:	30479073          	csrw	mie,a5
}
    8000671a:	6422                	ld	s0,8(sp)
    8000671c:	0141                	addi	sp,sp,16
    8000671e:	8082                	ret

0000000080006720 <start>:
{
    80006720:	1141                	addi	sp,sp,-16
    80006722:	e406                	sd	ra,8(sp)
    80006724:	e022                	sd	s0,0(sp)
    80006726:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006728:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000672c:	7779                	lui	a4,0xffffe
    8000672e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd727f>
    80006732:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80006734:	6705                	lui	a4,0x1
    80006736:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000673a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000673c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80006740:	ffffa797          	auipc	a5,0xffffa
    80006744:	bde78793          	addi	a5,a5,-1058 # 8000031e <main>
    80006748:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000674c:	4781                	li	a5,0
    8000674e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80006752:	67c1                	lui	a5,0x10
    80006754:	17fd                	addi	a5,a5,-1
    80006756:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000675a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000675e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006762:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80006766:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000676a:	57fd                	li	a5,-1
    8000676c:	83a9                	srli	a5,a5,0xa
    8000676e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80006772:	47bd                	li	a5,15
    80006774:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006778:	00000097          	auipc	ra,0x0
    8000677c:	f36080e7          	jalr	-202(ra) # 800066ae <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006780:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80006784:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80006786:	823e                	mv	tp,a5
  asm volatile("mret");
    80006788:	30200073          	mret
}
    8000678c:	60a2                	ld	ra,8(sp)
    8000678e:	6402                	ld	s0,0(sp)
    80006790:	0141                	addi	sp,sp,16
    80006792:	8082                	ret

0000000080006794 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80006794:	715d                	addi	sp,sp,-80
    80006796:	e486                	sd	ra,72(sp)
    80006798:	e0a2                	sd	s0,64(sp)
    8000679a:	fc26                	sd	s1,56(sp)
    8000679c:	f84a                	sd	s2,48(sp)
    8000679e:	f44e                	sd	s3,40(sp)
    800067a0:	f052                	sd	s4,32(sp)
    800067a2:	ec56                	sd	s5,24(sp)
    800067a4:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800067a6:	04c05663          	blez	a2,800067f2 <consolewrite+0x5e>
    800067aa:	8a2a                	mv	s4,a0
    800067ac:	84ae                	mv	s1,a1
    800067ae:	89b2                	mv	s3,a2
    800067b0:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800067b2:	5afd                	li	s5,-1
    800067b4:	4685                	li	a3,1
    800067b6:	8626                	mv	a2,s1
    800067b8:	85d2                	mv	a1,s4
    800067ba:	fbf40513          	addi	a0,s0,-65
    800067be:	ffffb097          	auipc	ra,0xffffb
    800067c2:	196080e7          	jalr	406(ra) # 80001954 <either_copyin>
    800067c6:	01550c63          	beq	a0,s5,800067de <consolewrite+0x4a>
      break;
    uartputc(c);
    800067ca:	fbf44503          	lbu	a0,-65(s0)
    800067ce:	00000097          	auipc	ra,0x0
    800067d2:	77a080e7          	jalr	1914(ra) # 80006f48 <uartputc>
  for(i = 0; i < n; i++){
    800067d6:	2905                	addiw	s2,s2,1
    800067d8:	0485                	addi	s1,s1,1
    800067da:	fd299de3          	bne	s3,s2,800067b4 <consolewrite+0x20>
  }

  return i;
}
    800067de:	854a                	mv	a0,s2
    800067e0:	60a6                	ld	ra,72(sp)
    800067e2:	6406                	ld	s0,64(sp)
    800067e4:	74e2                	ld	s1,56(sp)
    800067e6:	7942                	ld	s2,48(sp)
    800067e8:	79a2                	ld	s3,40(sp)
    800067ea:	7a02                	ld	s4,32(sp)
    800067ec:	6ae2                	ld	s5,24(sp)
    800067ee:	6161                	addi	sp,sp,80
    800067f0:	8082                	ret
  for(i = 0; i < n; i++){
    800067f2:	4901                	li	s2,0
    800067f4:	b7ed                	j	800067de <consolewrite+0x4a>

00000000800067f6 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800067f6:	7159                	addi	sp,sp,-112
    800067f8:	f486                	sd	ra,104(sp)
    800067fa:	f0a2                	sd	s0,96(sp)
    800067fc:	eca6                	sd	s1,88(sp)
    800067fe:	e8ca                	sd	s2,80(sp)
    80006800:	e4ce                	sd	s3,72(sp)
    80006802:	e0d2                	sd	s4,64(sp)
    80006804:	fc56                	sd	s5,56(sp)
    80006806:	f85a                	sd	s6,48(sp)
    80006808:	f45e                	sd	s7,40(sp)
    8000680a:	f062                	sd	s8,32(sp)
    8000680c:	ec66                	sd	s9,24(sp)
    8000680e:	e86a                	sd	s10,16(sp)
    80006810:	1880                	addi	s0,sp,112
    80006812:	8aaa                	mv	s5,a0
    80006814:	8a2e                	mv	s4,a1
    80006816:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80006818:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000681c:	00021517          	auipc	a0,0x21
    80006820:	c6450513          	addi	a0,a0,-924 # 80027480 <cons>
    80006824:	00001097          	auipc	ra,0x1
    80006828:	8e2080e7          	jalr	-1822(ra) # 80007106 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000682c:	00021497          	auipc	s1,0x21
    80006830:	c5448493          	addi	s1,s1,-940 # 80027480 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006834:	00021917          	auipc	s2,0x21
    80006838:	ce490913          	addi	s2,s2,-796 # 80027518 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000683c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000683e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006840:	4ca9                	li	s9,10
  while(n > 0){
    80006842:	07305863          	blez	s3,800068b2 <consoleread+0xbc>
    while(cons.r == cons.w){
    80006846:	0984a783          	lw	a5,152(s1)
    8000684a:	09c4a703          	lw	a4,156(s1)
    8000684e:	02f71463          	bne	a4,a5,80006876 <consoleread+0x80>
      if(myproc()->killed){
    80006852:	ffffa097          	auipc	ra,0xffffa
    80006856:	648080e7          	jalr	1608(ra) # 80000e9a <myproc>
    8000685a:	551c                	lw	a5,40(a0)
    8000685c:	e7b5                	bnez	a5,800068c8 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    8000685e:	85a6                	mv	a1,s1
    80006860:	854a                	mv	a0,s2
    80006862:	ffffb097          	auipc	ra,0xffffb
    80006866:	cf8080e7          	jalr	-776(ra) # 8000155a <sleep>
    while(cons.r == cons.w){
    8000686a:	0984a783          	lw	a5,152(s1)
    8000686e:	09c4a703          	lw	a4,156(s1)
    80006872:	fef700e3          	beq	a4,a5,80006852 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80006876:	0017871b          	addiw	a4,a5,1
    8000687a:	08e4ac23          	sw	a4,152(s1)
    8000687e:	07f7f713          	andi	a4,a5,127
    80006882:	9726                	add	a4,a4,s1
    80006884:	01874703          	lbu	a4,24(a4)
    80006888:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000688c:	077d0563          	beq	s10,s7,800068f6 <consoleread+0x100>
    cbuf = c;
    80006890:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006894:	4685                	li	a3,1
    80006896:	f9f40613          	addi	a2,s0,-97
    8000689a:	85d2                	mv	a1,s4
    8000689c:	8556                	mv	a0,s5
    8000689e:	ffffb097          	auipc	ra,0xffffb
    800068a2:	060080e7          	jalr	96(ra) # 800018fe <either_copyout>
    800068a6:	01850663          	beq	a0,s8,800068b2 <consoleread+0xbc>
    dst++;
    800068aa:	0a05                	addi	s4,s4,1
    --n;
    800068ac:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800068ae:	f99d1ae3          	bne	s10,s9,80006842 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800068b2:	00021517          	auipc	a0,0x21
    800068b6:	bce50513          	addi	a0,a0,-1074 # 80027480 <cons>
    800068ba:	00001097          	auipc	ra,0x1
    800068be:	900080e7          	jalr	-1792(ra) # 800071ba <release>

  return target - n;
    800068c2:	413b053b          	subw	a0,s6,s3
    800068c6:	a811                	j	800068da <consoleread+0xe4>
        release(&cons.lock);
    800068c8:	00021517          	auipc	a0,0x21
    800068cc:	bb850513          	addi	a0,a0,-1096 # 80027480 <cons>
    800068d0:	00001097          	auipc	ra,0x1
    800068d4:	8ea080e7          	jalr	-1814(ra) # 800071ba <release>
        return -1;
    800068d8:	557d                	li	a0,-1
}
    800068da:	70a6                	ld	ra,104(sp)
    800068dc:	7406                	ld	s0,96(sp)
    800068de:	64e6                	ld	s1,88(sp)
    800068e0:	6946                	ld	s2,80(sp)
    800068e2:	69a6                	ld	s3,72(sp)
    800068e4:	6a06                	ld	s4,64(sp)
    800068e6:	7ae2                	ld	s5,56(sp)
    800068e8:	7b42                	ld	s6,48(sp)
    800068ea:	7ba2                	ld	s7,40(sp)
    800068ec:	7c02                	ld	s8,32(sp)
    800068ee:	6ce2                	ld	s9,24(sp)
    800068f0:	6d42                	ld	s10,16(sp)
    800068f2:	6165                	addi	sp,sp,112
    800068f4:	8082                	ret
      if(n < target){
    800068f6:	0009871b          	sext.w	a4,s3
    800068fa:	fb677ce3          	bgeu	a4,s6,800068b2 <consoleread+0xbc>
        cons.r--;
    800068fe:	00021717          	auipc	a4,0x21
    80006902:	c0f72d23          	sw	a5,-998(a4) # 80027518 <cons+0x98>
    80006906:	b775                	j	800068b2 <consoleread+0xbc>

0000000080006908 <consputc>:
{
    80006908:	1141                	addi	sp,sp,-16
    8000690a:	e406                	sd	ra,8(sp)
    8000690c:	e022                	sd	s0,0(sp)
    8000690e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80006910:	10000793          	li	a5,256
    80006914:	00f50a63          	beq	a0,a5,80006928 <consputc+0x20>
    uartputc_sync(c);
    80006918:	00000097          	auipc	ra,0x0
    8000691c:	55e080e7          	jalr	1374(ra) # 80006e76 <uartputc_sync>
}
    80006920:	60a2                	ld	ra,8(sp)
    80006922:	6402                	ld	s0,0(sp)
    80006924:	0141                	addi	sp,sp,16
    80006926:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80006928:	4521                	li	a0,8
    8000692a:	00000097          	auipc	ra,0x0
    8000692e:	54c080e7          	jalr	1356(ra) # 80006e76 <uartputc_sync>
    80006932:	02000513          	li	a0,32
    80006936:	00000097          	auipc	ra,0x0
    8000693a:	540080e7          	jalr	1344(ra) # 80006e76 <uartputc_sync>
    8000693e:	4521                	li	a0,8
    80006940:	00000097          	auipc	ra,0x0
    80006944:	536080e7          	jalr	1334(ra) # 80006e76 <uartputc_sync>
    80006948:	bfe1                	j	80006920 <consputc+0x18>

000000008000694a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000694a:	1101                	addi	sp,sp,-32
    8000694c:	ec06                	sd	ra,24(sp)
    8000694e:	e822                	sd	s0,16(sp)
    80006950:	e426                	sd	s1,8(sp)
    80006952:	e04a                	sd	s2,0(sp)
    80006954:	1000                	addi	s0,sp,32
    80006956:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006958:	00021517          	auipc	a0,0x21
    8000695c:	b2850513          	addi	a0,a0,-1240 # 80027480 <cons>
    80006960:	00000097          	auipc	ra,0x0
    80006964:	7a6080e7          	jalr	1958(ra) # 80007106 <acquire>

  switch(c){
    80006968:	47d5                	li	a5,21
    8000696a:	0af48663          	beq	s1,a5,80006a16 <consoleintr+0xcc>
    8000696e:	0297ca63          	blt	a5,s1,800069a2 <consoleintr+0x58>
    80006972:	47a1                	li	a5,8
    80006974:	0ef48763          	beq	s1,a5,80006a62 <consoleintr+0x118>
    80006978:	47c1                	li	a5,16
    8000697a:	10f49a63          	bne	s1,a5,80006a8e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000697e:	ffffb097          	auipc	ra,0xffffb
    80006982:	02c080e7          	jalr	44(ra) # 800019aa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006986:	00021517          	auipc	a0,0x21
    8000698a:	afa50513          	addi	a0,a0,-1286 # 80027480 <cons>
    8000698e:	00001097          	auipc	ra,0x1
    80006992:	82c080e7          	jalr	-2004(ra) # 800071ba <release>
}
    80006996:	60e2                	ld	ra,24(sp)
    80006998:	6442                	ld	s0,16(sp)
    8000699a:	64a2                	ld	s1,8(sp)
    8000699c:	6902                	ld	s2,0(sp)
    8000699e:	6105                	addi	sp,sp,32
    800069a0:	8082                	ret
  switch(c){
    800069a2:	07f00793          	li	a5,127
    800069a6:	0af48e63          	beq	s1,a5,80006a62 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800069aa:	00021717          	auipc	a4,0x21
    800069ae:	ad670713          	addi	a4,a4,-1322 # 80027480 <cons>
    800069b2:	0a072783          	lw	a5,160(a4)
    800069b6:	09872703          	lw	a4,152(a4)
    800069ba:	9f99                	subw	a5,a5,a4
    800069bc:	07f00713          	li	a4,127
    800069c0:	fcf763e3          	bltu	a4,a5,80006986 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800069c4:	47b5                	li	a5,13
    800069c6:	0cf48763          	beq	s1,a5,80006a94 <consoleintr+0x14a>
      consputc(c);
    800069ca:	8526                	mv	a0,s1
    800069cc:	00000097          	auipc	ra,0x0
    800069d0:	f3c080e7          	jalr	-196(ra) # 80006908 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800069d4:	00021797          	auipc	a5,0x21
    800069d8:	aac78793          	addi	a5,a5,-1364 # 80027480 <cons>
    800069dc:	0a07a703          	lw	a4,160(a5)
    800069e0:	0017069b          	addiw	a3,a4,1
    800069e4:	0006861b          	sext.w	a2,a3
    800069e8:	0ad7a023          	sw	a3,160(a5)
    800069ec:	07f77713          	andi	a4,a4,127
    800069f0:	97ba                	add	a5,a5,a4
    800069f2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    800069f6:	47a9                	li	a5,10
    800069f8:	0cf48563          	beq	s1,a5,80006ac2 <consoleintr+0x178>
    800069fc:	4791                	li	a5,4
    800069fe:	0cf48263          	beq	s1,a5,80006ac2 <consoleintr+0x178>
    80006a02:	00021797          	auipc	a5,0x21
    80006a06:	b167a783          	lw	a5,-1258(a5) # 80027518 <cons+0x98>
    80006a0a:	0807879b          	addiw	a5,a5,128
    80006a0e:	f6f61ce3          	bne	a2,a5,80006986 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a12:	863e                	mv	a2,a5
    80006a14:	a07d                	j	80006ac2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006a16:	00021717          	auipc	a4,0x21
    80006a1a:	a6a70713          	addi	a4,a4,-1430 # 80027480 <cons>
    80006a1e:	0a072783          	lw	a5,160(a4)
    80006a22:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a26:	00021497          	auipc	s1,0x21
    80006a2a:	a5a48493          	addi	s1,s1,-1446 # 80027480 <cons>
    while(cons.e != cons.w &&
    80006a2e:	4929                	li	s2,10
    80006a30:	f4f70be3          	beq	a4,a5,80006986 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a34:	37fd                	addiw	a5,a5,-1
    80006a36:	07f7f713          	andi	a4,a5,127
    80006a3a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006a3c:	01874703          	lbu	a4,24(a4)
    80006a40:	f52703e3          	beq	a4,s2,80006986 <consoleintr+0x3c>
      cons.e--;
    80006a44:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006a48:	10000513          	li	a0,256
    80006a4c:	00000097          	auipc	ra,0x0
    80006a50:	ebc080e7          	jalr	-324(ra) # 80006908 <consputc>
    while(cons.e != cons.w &&
    80006a54:	0a04a783          	lw	a5,160(s1)
    80006a58:	09c4a703          	lw	a4,156(s1)
    80006a5c:	fcf71ce3          	bne	a4,a5,80006a34 <consoleintr+0xea>
    80006a60:	b71d                	j	80006986 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006a62:	00021717          	auipc	a4,0x21
    80006a66:	a1e70713          	addi	a4,a4,-1506 # 80027480 <cons>
    80006a6a:	0a072783          	lw	a5,160(a4)
    80006a6e:	09c72703          	lw	a4,156(a4)
    80006a72:	f0f70ae3          	beq	a4,a5,80006986 <consoleintr+0x3c>
      cons.e--;
    80006a76:	37fd                	addiw	a5,a5,-1
    80006a78:	00021717          	auipc	a4,0x21
    80006a7c:	aaf72423          	sw	a5,-1368(a4) # 80027520 <cons+0xa0>
      consputc(BACKSPACE);
    80006a80:	10000513          	li	a0,256
    80006a84:	00000097          	auipc	ra,0x0
    80006a88:	e84080e7          	jalr	-380(ra) # 80006908 <consputc>
    80006a8c:	bded                	j	80006986 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006a8e:	ee048ce3          	beqz	s1,80006986 <consoleintr+0x3c>
    80006a92:	bf21                	j	800069aa <consoleintr+0x60>
      consputc(c);
    80006a94:	4529                	li	a0,10
    80006a96:	00000097          	auipc	ra,0x0
    80006a9a:	e72080e7          	jalr	-398(ra) # 80006908 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a9e:	00021797          	auipc	a5,0x21
    80006aa2:	9e278793          	addi	a5,a5,-1566 # 80027480 <cons>
    80006aa6:	0a07a703          	lw	a4,160(a5)
    80006aaa:	0017069b          	addiw	a3,a4,1
    80006aae:	0006861b          	sext.w	a2,a3
    80006ab2:	0ad7a023          	sw	a3,160(a5)
    80006ab6:	07f77713          	andi	a4,a4,127
    80006aba:	97ba                	add	a5,a5,a4
    80006abc:	4729                	li	a4,10
    80006abe:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006ac2:	00021797          	auipc	a5,0x21
    80006ac6:	a4c7ad23          	sw	a2,-1446(a5) # 8002751c <cons+0x9c>
        wakeup(&cons.r);
    80006aca:	00021517          	auipc	a0,0x21
    80006ace:	a4e50513          	addi	a0,a0,-1458 # 80027518 <cons+0x98>
    80006ad2:	ffffb097          	auipc	ra,0xffffb
    80006ad6:	c14080e7          	jalr	-1004(ra) # 800016e6 <wakeup>
    80006ada:	b575                	j	80006986 <consoleintr+0x3c>

0000000080006adc <consoleinit>:

void
consoleinit(void)
{
    80006adc:	1141                	addi	sp,sp,-16
    80006ade:	e406                	sd	ra,8(sp)
    80006ae0:	e022                	sd	s0,0(sp)
    80006ae2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006ae4:	00003597          	auipc	a1,0x3
    80006ae8:	d4c58593          	addi	a1,a1,-692 # 80009830 <syscalls+0x458>
    80006aec:	00021517          	auipc	a0,0x21
    80006af0:	99450513          	addi	a0,a0,-1644 # 80027480 <cons>
    80006af4:	00000097          	auipc	ra,0x0
    80006af8:	582080e7          	jalr	1410(ra) # 80007076 <initlock>

  uartinit();
    80006afc:	00000097          	auipc	ra,0x0
    80006b00:	32a080e7          	jalr	810(ra) # 80006e26 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006b04:	00013797          	auipc	a5,0x13
    80006b08:	5e478793          	addi	a5,a5,1508 # 8001a0e8 <devsw>
    80006b0c:	00000717          	auipc	a4,0x0
    80006b10:	cea70713          	addi	a4,a4,-790 # 800067f6 <consoleread>
    80006b14:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006b16:	00000717          	auipc	a4,0x0
    80006b1a:	c7e70713          	addi	a4,a4,-898 # 80006794 <consolewrite>
    80006b1e:	ef98                	sd	a4,24(a5)
}
    80006b20:	60a2                	ld	ra,8(sp)
    80006b22:	6402                	ld	s0,0(sp)
    80006b24:	0141                	addi	sp,sp,16
    80006b26:	8082                	ret

0000000080006b28 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006b28:	7179                	addi	sp,sp,-48
    80006b2a:	f406                	sd	ra,40(sp)
    80006b2c:	f022                	sd	s0,32(sp)
    80006b2e:	ec26                	sd	s1,24(sp)
    80006b30:	e84a                	sd	s2,16(sp)
    80006b32:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006b34:	c219                	beqz	a2,80006b3a <printint+0x12>
    80006b36:	08054663          	bltz	a0,80006bc2 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006b3a:	2501                	sext.w	a0,a0
    80006b3c:	4881                	li	a7,0
    80006b3e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006b42:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006b44:	2581                	sext.w	a1,a1
    80006b46:	00003617          	auipc	a2,0x3
    80006b4a:	d1a60613          	addi	a2,a2,-742 # 80009860 <digits>
    80006b4e:	883a                	mv	a6,a4
    80006b50:	2705                	addiw	a4,a4,1
    80006b52:	02b577bb          	remuw	a5,a0,a1
    80006b56:	1782                	slli	a5,a5,0x20
    80006b58:	9381                	srli	a5,a5,0x20
    80006b5a:	97b2                	add	a5,a5,a2
    80006b5c:	0007c783          	lbu	a5,0(a5)
    80006b60:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006b64:	0005079b          	sext.w	a5,a0
    80006b68:	02b5553b          	divuw	a0,a0,a1
    80006b6c:	0685                	addi	a3,a3,1
    80006b6e:	feb7f0e3          	bgeu	a5,a1,80006b4e <printint+0x26>

  if(sign)
    80006b72:	00088b63          	beqz	a7,80006b88 <printint+0x60>
    buf[i++] = '-';
    80006b76:	fe040793          	addi	a5,s0,-32
    80006b7a:	973e                	add	a4,a4,a5
    80006b7c:	02d00793          	li	a5,45
    80006b80:	fef70823          	sb	a5,-16(a4)
    80006b84:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006b88:	02e05763          	blez	a4,80006bb6 <printint+0x8e>
    80006b8c:	fd040793          	addi	a5,s0,-48
    80006b90:	00e784b3          	add	s1,a5,a4
    80006b94:	fff78913          	addi	s2,a5,-1
    80006b98:	993a                	add	s2,s2,a4
    80006b9a:	377d                	addiw	a4,a4,-1
    80006b9c:	1702                	slli	a4,a4,0x20
    80006b9e:	9301                	srli	a4,a4,0x20
    80006ba0:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006ba4:	fff4c503          	lbu	a0,-1(s1)
    80006ba8:	00000097          	auipc	ra,0x0
    80006bac:	d60080e7          	jalr	-672(ra) # 80006908 <consputc>
  while(--i >= 0)
    80006bb0:	14fd                	addi	s1,s1,-1
    80006bb2:	ff2499e3          	bne	s1,s2,80006ba4 <printint+0x7c>
}
    80006bb6:	70a2                	ld	ra,40(sp)
    80006bb8:	7402                	ld	s0,32(sp)
    80006bba:	64e2                	ld	s1,24(sp)
    80006bbc:	6942                	ld	s2,16(sp)
    80006bbe:	6145                	addi	sp,sp,48
    80006bc0:	8082                	ret
    x = -xx;
    80006bc2:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006bc6:	4885                	li	a7,1
    x = -xx;
    80006bc8:	bf9d                	j	80006b3e <printint+0x16>

0000000080006bca <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006bca:	1101                	addi	sp,sp,-32
    80006bcc:	ec06                	sd	ra,24(sp)
    80006bce:	e822                	sd	s0,16(sp)
    80006bd0:	e426                	sd	s1,8(sp)
    80006bd2:	1000                	addi	s0,sp,32
    80006bd4:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006bd6:	00021797          	auipc	a5,0x21
    80006bda:	9607a523          	sw	zero,-1686(a5) # 80027540 <pr+0x18>
  printf("panic: ");
    80006bde:	00003517          	auipc	a0,0x3
    80006be2:	c5a50513          	addi	a0,a0,-934 # 80009838 <syscalls+0x460>
    80006be6:	00000097          	auipc	ra,0x0
    80006bea:	02e080e7          	jalr	46(ra) # 80006c14 <printf>
  printf(s);
    80006bee:	8526                	mv	a0,s1
    80006bf0:	00000097          	auipc	ra,0x0
    80006bf4:	024080e7          	jalr	36(ra) # 80006c14 <printf>
  printf("\n");
    80006bf8:	00002517          	auipc	a0,0x2
    80006bfc:	45050513          	addi	a0,a0,1104 # 80009048 <etext+0x48>
    80006c00:	00000097          	auipc	ra,0x0
    80006c04:	014080e7          	jalr	20(ra) # 80006c14 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006c08:	4785                	li	a5,1
    80006c0a:	00003717          	auipc	a4,0x3
    80006c0e:	42f72323          	sw	a5,1062(a4) # 8000a030 <panicked>
  for(;;)
    80006c12:	a001                	j	80006c12 <panic+0x48>

0000000080006c14 <printf>:
{
    80006c14:	7131                	addi	sp,sp,-192
    80006c16:	fc86                	sd	ra,120(sp)
    80006c18:	f8a2                	sd	s0,112(sp)
    80006c1a:	f4a6                	sd	s1,104(sp)
    80006c1c:	f0ca                	sd	s2,96(sp)
    80006c1e:	ecce                	sd	s3,88(sp)
    80006c20:	e8d2                	sd	s4,80(sp)
    80006c22:	e4d6                	sd	s5,72(sp)
    80006c24:	e0da                	sd	s6,64(sp)
    80006c26:	fc5e                	sd	s7,56(sp)
    80006c28:	f862                	sd	s8,48(sp)
    80006c2a:	f466                	sd	s9,40(sp)
    80006c2c:	f06a                	sd	s10,32(sp)
    80006c2e:	ec6e                	sd	s11,24(sp)
    80006c30:	0100                	addi	s0,sp,128
    80006c32:	8a2a                	mv	s4,a0
    80006c34:	e40c                	sd	a1,8(s0)
    80006c36:	e810                	sd	a2,16(s0)
    80006c38:	ec14                	sd	a3,24(s0)
    80006c3a:	f018                	sd	a4,32(s0)
    80006c3c:	f41c                	sd	a5,40(s0)
    80006c3e:	03043823          	sd	a6,48(s0)
    80006c42:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006c46:	00021d97          	auipc	s11,0x21
    80006c4a:	8fadad83          	lw	s11,-1798(s11) # 80027540 <pr+0x18>
  if(locking)
    80006c4e:	020d9b63          	bnez	s11,80006c84 <printf+0x70>
  if (fmt == 0)
    80006c52:	040a0263          	beqz	s4,80006c96 <printf+0x82>
  va_start(ap, fmt);
    80006c56:	00840793          	addi	a5,s0,8
    80006c5a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006c5e:	000a4503          	lbu	a0,0(s4) # 2000 <_entry-0x7fffe000>
    80006c62:	14050f63          	beqz	a0,80006dc0 <printf+0x1ac>
    80006c66:	4981                	li	s3,0
    if(c != '%'){
    80006c68:	02500a93          	li	s5,37
    switch(c){
    80006c6c:	07000b93          	li	s7,112
  consputc('x');
    80006c70:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006c72:	00003b17          	auipc	s6,0x3
    80006c76:	beeb0b13          	addi	s6,s6,-1042 # 80009860 <digits>
    switch(c){
    80006c7a:	07300c93          	li	s9,115
    80006c7e:	06400c13          	li	s8,100
    80006c82:	a82d                	j	80006cbc <printf+0xa8>
    acquire(&pr.lock);
    80006c84:	00021517          	auipc	a0,0x21
    80006c88:	8a450513          	addi	a0,a0,-1884 # 80027528 <pr>
    80006c8c:	00000097          	auipc	ra,0x0
    80006c90:	47a080e7          	jalr	1146(ra) # 80007106 <acquire>
    80006c94:	bf7d                	j	80006c52 <printf+0x3e>
    panic("null fmt");
    80006c96:	00003517          	auipc	a0,0x3
    80006c9a:	bb250513          	addi	a0,a0,-1102 # 80009848 <syscalls+0x470>
    80006c9e:	00000097          	auipc	ra,0x0
    80006ca2:	f2c080e7          	jalr	-212(ra) # 80006bca <panic>
      consputc(c);
    80006ca6:	00000097          	auipc	ra,0x0
    80006caa:	c62080e7          	jalr	-926(ra) # 80006908 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006cae:	2985                	addiw	s3,s3,1
    80006cb0:	013a07b3          	add	a5,s4,s3
    80006cb4:	0007c503          	lbu	a0,0(a5)
    80006cb8:	10050463          	beqz	a0,80006dc0 <printf+0x1ac>
    if(c != '%'){
    80006cbc:	ff5515e3          	bne	a0,s5,80006ca6 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006cc0:	2985                	addiw	s3,s3,1
    80006cc2:	013a07b3          	add	a5,s4,s3
    80006cc6:	0007c783          	lbu	a5,0(a5)
    80006cca:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006cce:	cbed                	beqz	a5,80006dc0 <printf+0x1ac>
    switch(c){
    80006cd0:	05778a63          	beq	a5,s7,80006d24 <printf+0x110>
    80006cd4:	02fbf663          	bgeu	s7,a5,80006d00 <printf+0xec>
    80006cd8:	09978863          	beq	a5,s9,80006d68 <printf+0x154>
    80006cdc:	07800713          	li	a4,120
    80006ce0:	0ce79563          	bne	a5,a4,80006daa <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006ce4:	f8843783          	ld	a5,-120(s0)
    80006ce8:	00878713          	addi	a4,a5,8
    80006cec:	f8e43423          	sd	a4,-120(s0)
    80006cf0:	4605                	li	a2,1
    80006cf2:	85ea                	mv	a1,s10
    80006cf4:	4388                	lw	a0,0(a5)
    80006cf6:	00000097          	auipc	ra,0x0
    80006cfa:	e32080e7          	jalr	-462(ra) # 80006b28 <printint>
      break;
    80006cfe:	bf45                	j	80006cae <printf+0x9a>
    switch(c){
    80006d00:	09578f63          	beq	a5,s5,80006d9e <printf+0x18a>
    80006d04:	0b879363          	bne	a5,s8,80006daa <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006d08:	f8843783          	ld	a5,-120(s0)
    80006d0c:	00878713          	addi	a4,a5,8
    80006d10:	f8e43423          	sd	a4,-120(s0)
    80006d14:	4605                	li	a2,1
    80006d16:	45a9                	li	a1,10
    80006d18:	4388                	lw	a0,0(a5)
    80006d1a:	00000097          	auipc	ra,0x0
    80006d1e:	e0e080e7          	jalr	-498(ra) # 80006b28 <printint>
      break;
    80006d22:	b771                	j	80006cae <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006d24:	f8843783          	ld	a5,-120(s0)
    80006d28:	00878713          	addi	a4,a5,8
    80006d2c:	f8e43423          	sd	a4,-120(s0)
    80006d30:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006d34:	03000513          	li	a0,48
    80006d38:	00000097          	auipc	ra,0x0
    80006d3c:	bd0080e7          	jalr	-1072(ra) # 80006908 <consputc>
  consputc('x');
    80006d40:	07800513          	li	a0,120
    80006d44:	00000097          	auipc	ra,0x0
    80006d48:	bc4080e7          	jalr	-1084(ra) # 80006908 <consputc>
    80006d4c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d4e:	03c95793          	srli	a5,s2,0x3c
    80006d52:	97da                	add	a5,a5,s6
    80006d54:	0007c503          	lbu	a0,0(a5)
    80006d58:	00000097          	auipc	ra,0x0
    80006d5c:	bb0080e7          	jalr	-1104(ra) # 80006908 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006d60:	0912                	slli	s2,s2,0x4
    80006d62:	34fd                	addiw	s1,s1,-1
    80006d64:	f4ed                	bnez	s1,80006d4e <printf+0x13a>
    80006d66:	b7a1                	j	80006cae <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006d68:	f8843783          	ld	a5,-120(s0)
    80006d6c:	00878713          	addi	a4,a5,8
    80006d70:	f8e43423          	sd	a4,-120(s0)
    80006d74:	6384                	ld	s1,0(a5)
    80006d76:	cc89                	beqz	s1,80006d90 <printf+0x17c>
      for(; *s; s++)
    80006d78:	0004c503          	lbu	a0,0(s1)
    80006d7c:	d90d                	beqz	a0,80006cae <printf+0x9a>
        consputc(*s);
    80006d7e:	00000097          	auipc	ra,0x0
    80006d82:	b8a080e7          	jalr	-1142(ra) # 80006908 <consputc>
      for(; *s; s++)
    80006d86:	0485                	addi	s1,s1,1
    80006d88:	0004c503          	lbu	a0,0(s1)
    80006d8c:	f96d                	bnez	a0,80006d7e <printf+0x16a>
    80006d8e:	b705                	j	80006cae <printf+0x9a>
        s = "(null)";
    80006d90:	00003497          	auipc	s1,0x3
    80006d94:	ab048493          	addi	s1,s1,-1360 # 80009840 <syscalls+0x468>
      for(; *s; s++)
    80006d98:	02800513          	li	a0,40
    80006d9c:	b7cd                	j	80006d7e <printf+0x16a>
      consputc('%');
    80006d9e:	8556                	mv	a0,s5
    80006da0:	00000097          	auipc	ra,0x0
    80006da4:	b68080e7          	jalr	-1176(ra) # 80006908 <consputc>
      break;
    80006da8:	b719                	j	80006cae <printf+0x9a>
      consputc('%');
    80006daa:	8556                	mv	a0,s5
    80006dac:	00000097          	auipc	ra,0x0
    80006db0:	b5c080e7          	jalr	-1188(ra) # 80006908 <consputc>
      consputc(c);
    80006db4:	8526                	mv	a0,s1
    80006db6:	00000097          	auipc	ra,0x0
    80006dba:	b52080e7          	jalr	-1198(ra) # 80006908 <consputc>
      break;
    80006dbe:	bdc5                	j	80006cae <printf+0x9a>
  if(locking)
    80006dc0:	020d9163          	bnez	s11,80006de2 <printf+0x1ce>
}
    80006dc4:	70e6                	ld	ra,120(sp)
    80006dc6:	7446                	ld	s0,112(sp)
    80006dc8:	74a6                	ld	s1,104(sp)
    80006dca:	7906                	ld	s2,96(sp)
    80006dcc:	69e6                	ld	s3,88(sp)
    80006dce:	6a46                	ld	s4,80(sp)
    80006dd0:	6aa6                	ld	s5,72(sp)
    80006dd2:	6b06                	ld	s6,64(sp)
    80006dd4:	7be2                	ld	s7,56(sp)
    80006dd6:	7c42                	ld	s8,48(sp)
    80006dd8:	7ca2                	ld	s9,40(sp)
    80006dda:	7d02                	ld	s10,32(sp)
    80006ddc:	6de2                	ld	s11,24(sp)
    80006dde:	6129                	addi	sp,sp,192
    80006de0:	8082                	ret
    release(&pr.lock);
    80006de2:	00020517          	auipc	a0,0x20
    80006de6:	74650513          	addi	a0,a0,1862 # 80027528 <pr>
    80006dea:	00000097          	auipc	ra,0x0
    80006dee:	3d0080e7          	jalr	976(ra) # 800071ba <release>
}
    80006df2:	bfc9                	j	80006dc4 <printf+0x1b0>

0000000080006df4 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006df4:	1101                	addi	sp,sp,-32
    80006df6:	ec06                	sd	ra,24(sp)
    80006df8:	e822                	sd	s0,16(sp)
    80006dfa:	e426                	sd	s1,8(sp)
    80006dfc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006dfe:	00020497          	auipc	s1,0x20
    80006e02:	72a48493          	addi	s1,s1,1834 # 80027528 <pr>
    80006e06:	00003597          	auipc	a1,0x3
    80006e0a:	a5258593          	addi	a1,a1,-1454 # 80009858 <syscalls+0x480>
    80006e0e:	8526                	mv	a0,s1
    80006e10:	00000097          	auipc	ra,0x0
    80006e14:	266080e7          	jalr	614(ra) # 80007076 <initlock>
  pr.locking = 1;
    80006e18:	4785                	li	a5,1
    80006e1a:	cc9c                	sw	a5,24(s1)
}
    80006e1c:	60e2                	ld	ra,24(sp)
    80006e1e:	6442                	ld	s0,16(sp)
    80006e20:	64a2                	ld	s1,8(sp)
    80006e22:	6105                	addi	sp,sp,32
    80006e24:	8082                	ret

0000000080006e26 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006e26:	1141                	addi	sp,sp,-16
    80006e28:	e406                	sd	ra,8(sp)
    80006e2a:	e022                	sd	s0,0(sp)
    80006e2c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006e2e:	100007b7          	lui	a5,0x10000
    80006e32:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006e36:	f8000713          	li	a4,-128
    80006e3a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006e3e:	470d                	li	a4,3
    80006e40:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006e44:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006e48:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006e4c:	469d                	li	a3,7
    80006e4e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006e52:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006e56:	00003597          	auipc	a1,0x3
    80006e5a:	a2258593          	addi	a1,a1,-1502 # 80009878 <digits+0x18>
    80006e5e:	00020517          	auipc	a0,0x20
    80006e62:	6ea50513          	addi	a0,a0,1770 # 80027548 <uart_tx_lock>
    80006e66:	00000097          	auipc	ra,0x0
    80006e6a:	210080e7          	jalr	528(ra) # 80007076 <initlock>
}
    80006e6e:	60a2                	ld	ra,8(sp)
    80006e70:	6402                	ld	s0,0(sp)
    80006e72:	0141                	addi	sp,sp,16
    80006e74:	8082                	ret

0000000080006e76 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006e76:	1101                	addi	sp,sp,-32
    80006e78:	ec06                	sd	ra,24(sp)
    80006e7a:	e822                	sd	s0,16(sp)
    80006e7c:	e426                	sd	s1,8(sp)
    80006e7e:	1000                	addi	s0,sp,32
    80006e80:	84aa                	mv	s1,a0
  push_off();
    80006e82:	00000097          	auipc	ra,0x0
    80006e86:	238080e7          	jalr	568(ra) # 800070ba <push_off>

  if(panicked){
    80006e8a:	00003797          	auipc	a5,0x3
    80006e8e:	1a67a783          	lw	a5,422(a5) # 8000a030 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006e92:	10000737          	lui	a4,0x10000
  if(panicked){
    80006e96:	c391                	beqz	a5,80006e9a <uartputc_sync+0x24>
    for(;;)
    80006e98:	a001                	j	80006e98 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006e9a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006e9e:	0207f793          	andi	a5,a5,32
    80006ea2:	dfe5                	beqz	a5,80006e9a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006ea4:	0ff4f513          	andi	a0,s1,255
    80006ea8:	100007b7          	lui	a5,0x10000
    80006eac:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006eb0:	00000097          	auipc	ra,0x0
    80006eb4:	2aa080e7          	jalr	682(ra) # 8000715a <pop_off>
}
    80006eb8:	60e2                	ld	ra,24(sp)
    80006eba:	6442                	ld	s0,16(sp)
    80006ebc:	64a2                	ld	s1,8(sp)
    80006ebe:	6105                	addi	sp,sp,32
    80006ec0:	8082                	ret

0000000080006ec2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006ec2:	00003797          	auipc	a5,0x3
    80006ec6:	1767b783          	ld	a5,374(a5) # 8000a038 <uart_tx_r>
    80006eca:	00003717          	auipc	a4,0x3
    80006ece:	17673703          	ld	a4,374(a4) # 8000a040 <uart_tx_w>
    80006ed2:	06f70a63          	beq	a4,a5,80006f46 <uartstart+0x84>
{
    80006ed6:	7139                	addi	sp,sp,-64
    80006ed8:	fc06                	sd	ra,56(sp)
    80006eda:	f822                	sd	s0,48(sp)
    80006edc:	f426                	sd	s1,40(sp)
    80006ede:	f04a                	sd	s2,32(sp)
    80006ee0:	ec4e                	sd	s3,24(sp)
    80006ee2:	e852                	sd	s4,16(sp)
    80006ee4:	e456                	sd	s5,8(sp)
    80006ee6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006ee8:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006eec:	00020a17          	auipc	s4,0x20
    80006ef0:	65ca0a13          	addi	s4,s4,1628 # 80027548 <uart_tx_lock>
    uart_tx_r += 1;
    80006ef4:	00003497          	auipc	s1,0x3
    80006ef8:	14448493          	addi	s1,s1,324 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006efc:	00003997          	auipc	s3,0x3
    80006f00:	14498993          	addi	s3,s3,324 # 8000a040 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f04:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006f08:	02077713          	andi	a4,a4,32
    80006f0c:	c705                	beqz	a4,80006f34 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f0e:	01f7f713          	andi	a4,a5,31
    80006f12:	9752                	add	a4,a4,s4
    80006f14:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006f18:	0785                	addi	a5,a5,1
    80006f1a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006f1c:	8526                	mv	a0,s1
    80006f1e:	ffffa097          	auipc	ra,0xffffa
    80006f22:	7c8080e7          	jalr	1992(ra) # 800016e6 <wakeup>
    
    WriteReg(THR, c);
    80006f26:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006f2a:	609c                	ld	a5,0(s1)
    80006f2c:	0009b703          	ld	a4,0(s3)
    80006f30:	fcf71ae3          	bne	a4,a5,80006f04 <uartstart+0x42>
  }
}
    80006f34:	70e2                	ld	ra,56(sp)
    80006f36:	7442                	ld	s0,48(sp)
    80006f38:	74a2                	ld	s1,40(sp)
    80006f3a:	7902                	ld	s2,32(sp)
    80006f3c:	69e2                	ld	s3,24(sp)
    80006f3e:	6a42                	ld	s4,16(sp)
    80006f40:	6aa2                	ld	s5,8(sp)
    80006f42:	6121                	addi	sp,sp,64
    80006f44:	8082                	ret
    80006f46:	8082                	ret

0000000080006f48 <uartputc>:
{
    80006f48:	7179                	addi	sp,sp,-48
    80006f4a:	f406                	sd	ra,40(sp)
    80006f4c:	f022                	sd	s0,32(sp)
    80006f4e:	ec26                	sd	s1,24(sp)
    80006f50:	e84a                	sd	s2,16(sp)
    80006f52:	e44e                	sd	s3,8(sp)
    80006f54:	e052                	sd	s4,0(sp)
    80006f56:	1800                	addi	s0,sp,48
    80006f58:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006f5a:	00020517          	auipc	a0,0x20
    80006f5e:	5ee50513          	addi	a0,a0,1518 # 80027548 <uart_tx_lock>
    80006f62:	00000097          	auipc	ra,0x0
    80006f66:	1a4080e7          	jalr	420(ra) # 80007106 <acquire>
  if(panicked){
    80006f6a:	00003797          	auipc	a5,0x3
    80006f6e:	0c67a783          	lw	a5,198(a5) # 8000a030 <panicked>
    80006f72:	c391                	beqz	a5,80006f76 <uartputc+0x2e>
    for(;;)
    80006f74:	a001                	j	80006f74 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f76:	00003717          	auipc	a4,0x3
    80006f7a:	0ca73703          	ld	a4,202(a4) # 8000a040 <uart_tx_w>
    80006f7e:	00003797          	auipc	a5,0x3
    80006f82:	0ba7b783          	ld	a5,186(a5) # 8000a038 <uart_tx_r>
    80006f86:	02078793          	addi	a5,a5,32
    80006f8a:	02e79b63          	bne	a5,a4,80006fc0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006f8e:	00020997          	auipc	s3,0x20
    80006f92:	5ba98993          	addi	s3,s3,1466 # 80027548 <uart_tx_lock>
    80006f96:	00003497          	auipc	s1,0x3
    80006f9a:	0a248493          	addi	s1,s1,162 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f9e:	00003917          	auipc	s2,0x3
    80006fa2:	0a290913          	addi	s2,s2,162 # 8000a040 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006fa6:	85ce                	mv	a1,s3
    80006fa8:	8526                	mv	a0,s1
    80006faa:	ffffa097          	auipc	ra,0xffffa
    80006fae:	5b0080e7          	jalr	1456(ra) # 8000155a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fb2:	00093703          	ld	a4,0(s2)
    80006fb6:	609c                	ld	a5,0(s1)
    80006fb8:	02078793          	addi	a5,a5,32
    80006fbc:	fee785e3          	beq	a5,a4,80006fa6 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006fc0:	00020497          	auipc	s1,0x20
    80006fc4:	58848493          	addi	s1,s1,1416 # 80027548 <uart_tx_lock>
    80006fc8:	01f77793          	andi	a5,a4,31
    80006fcc:	97a6                	add	a5,a5,s1
    80006fce:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006fd2:	0705                	addi	a4,a4,1
    80006fd4:	00003797          	auipc	a5,0x3
    80006fd8:	06e7b623          	sd	a4,108(a5) # 8000a040 <uart_tx_w>
      uartstart();
    80006fdc:	00000097          	auipc	ra,0x0
    80006fe0:	ee6080e7          	jalr	-282(ra) # 80006ec2 <uartstart>
      release(&uart_tx_lock);
    80006fe4:	8526                	mv	a0,s1
    80006fe6:	00000097          	auipc	ra,0x0
    80006fea:	1d4080e7          	jalr	468(ra) # 800071ba <release>
}
    80006fee:	70a2                	ld	ra,40(sp)
    80006ff0:	7402                	ld	s0,32(sp)
    80006ff2:	64e2                	ld	s1,24(sp)
    80006ff4:	6942                	ld	s2,16(sp)
    80006ff6:	69a2                	ld	s3,8(sp)
    80006ff8:	6a02                	ld	s4,0(sp)
    80006ffa:	6145                	addi	sp,sp,48
    80006ffc:	8082                	ret

0000000080006ffe <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006ffe:	1141                	addi	sp,sp,-16
    80007000:	e422                	sd	s0,8(sp)
    80007002:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80007004:	100007b7          	lui	a5,0x10000
    80007008:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000700c:	8b85                	andi	a5,a5,1
    8000700e:	cb91                	beqz	a5,80007022 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80007010:	100007b7          	lui	a5,0x10000
    80007014:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80007018:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000701c:	6422                	ld	s0,8(sp)
    8000701e:	0141                	addi	sp,sp,16
    80007020:	8082                	ret
    return -1;
    80007022:	557d                	li	a0,-1
    80007024:	bfe5                	j	8000701c <uartgetc+0x1e>

0000000080007026 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80007026:	1101                	addi	sp,sp,-32
    80007028:	ec06                	sd	ra,24(sp)
    8000702a:	e822                	sd	s0,16(sp)
    8000702c:	e426                	sd	s1,8(sp)
    8000702e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80007030:	54fd                	li	s1,-1
    80007032:	a029                	j	8000703c <uartintr+0x16>
      break;
    consoleintr(c);
    80007034:	00000097          	auipc	ra,0x0
    80007038:	916080e7          	jalr	-1770(ra) # 8000694a <consoleintr>
    int c = uartgetc();
    8000703c:	00000097          	auipc	ra,0x0
    80007040:	fc2080e7          	jalr	-62(ra) # 80006ffe <uartgetc>
    if(c == -1)
    80007044:	fe9518e3          	bne	a0,s1,80007034 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80007048:	00020497          	auipc	s1,0x20
    8000704c:	50048493          	addi	s1,s1,1280 # 80027548 <uart_tx_lock>
    80007050:	8526                	mv	a0,s1
    80007052:	00000097          	auipc	ra,0x0
    80007056:	0b4080e7          	jalr	180(ra) # 80007106 <acquire>
  uartstart();
    8000705a:	00000097          	auipc	ra,0x0
    8000705e:	e68080e7          	jalr	-408(ra) # 80006ec2 <uartstart>
  release(&uart_tx_lock);
    80007062:	8526                	mv	a0,s1
    80007064:	00000097          	auipc	ra,0x0
    80007068:	156080e7          	jalr	342(ra) # 800071ba <release>
}
    8000706c:	60e2                	ld	ra,24(sp)
    8000706e:	6442                	ld	s0,16(sp)
    80007070:	64a2                	ld	s1,8(sp)
    80007072:	6105                	addi	sp,sp,32
    80007074:	8082                	ret

0000000080007076 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80007076:	1141                	addi	sp,sp,-16
    80007078:	e422                	sd	s0,8(sp)
    8000707a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000707c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000707e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80007082:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80007086:	6422                	ld	s0,8(sp)
    80007088:	0141                	addi	sp,sp,16
    8000708a:	8082                	ret

000000008000708c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000708c:	411c                	lw	a5,0(a0)
    8000708e:	e399                	bnez	a5,80007094 <holding+0x8>
    80007090:	4501                	li	a0,0
  return r;
}
    80007092:	8082                	ret
{
    80007094:	1101                	addi	sp,sp,-32
    80007096:	ec06                	sd	ra,24(sp)
    80007098:	e822                	sd	s0,16(sp)
    8000709a:	e426                	sd	s1,8(sp)
    8000709c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000709e:	6904                	ld	s1,16(a0)
    800070a0:	ffffa097          	auipc	ra,0xffffa
    800070a4:	dde080e7          	jalr	-546(ra) # 80000e7e <mycpu>
    800070a8:	40a48533          	sub	a0,s1,a0
    800070ac:	00153513          	seqz	a0,a0
}
    800070b0:	60e2                	ld	ra,24(sp)
    800070b2:	6442                	ld	s0,16(sp)
    800070b4:	64a2                	ld	s1,8(sp)
    800070b6:	6105                	addi	sp,sp,32
    800070b8:	8082                	ret

00000000800070ba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800070ba:	1101                	addi	sp,sp,-32
    800070bc:	ec06                	sd	ra,24(sp)
    800070be:	e822                	sd	s0,16(sp)
    800070c0:	e426                	sd	s1,8(sp)
    800070c2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800070c4:	100024f3          	csrr	s1,sstatus
    800070c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800070cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800070ce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800070d2:	ffffa097          	auipc	ra,0xffffa
    800070d6:	dac080e7          	jalr	-596(ra) # 80000e7e <mycpu>
    800070da:	5d3c                	lw	a5,120(a0)
    800070dc:	cf89                	beqz	a5,800070f6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800070de:	ffffa097          	auipc	ra,0xffffa
    800070e2:	da0080e7          	jalr	-608(ra) # 80000e7e <mycpu>
    800070e6:	5d3c                	lw	a5,120(a0)
    800070e8:	2785                	addiw	a5,a5,1
    800070ea:	dd3c                	sw	a5,120(a0)
}
    800070ec:	60e2                	ld	ra,24(sp)
    800070ee:	6442                	ld	s0,16(sp)
    800070f0:	64a2                	ld	s1,8(sp)
    800070f2:	6105                	addi	sp,sp,32
    800070f4:	8082                	ret
    mycpu()->intena = old;
    800070f6:	ffffa097          	auipc	ra,0xffffa
    800070fa:	d88080e7          	jalr	-632(ra) # 80000e7e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800070fe:	8085                	srli	s1,s1,0x1
    80007100:	8885                	andi	s1,s1,1
    80007102:	dd64                	sw	s1,124(a0)
    80007104:	bfe9                	j	800070de <push_off+0x24>

0000000080007106 <acquire>:
{
    80007106:	1101                	addi	sp,sp,-32
    80007108:	ec06                	sd	ra,24(sp)
    8000710a:	e822                	sd	s0,16(sp)
    8000710c:	e426                	sd	s1,8(sp)
    8000710e:	1000                	addi	s0,sp,32
    80007110:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80007112:	00000097          	auipc	ra,0x0
    80007116:	fa8080e7          	jalr	-88(ra) # 800070ba <push_off>
  if(holding(lk))
    8000711a:	8526                	mv	a0,s1
    8000711c:	00000097          	auipc	ra,0x0
    80007120:	f70080e7          	jalr	-144(ra) # 8000708c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007124:	4705                	li	a4,1
  if(holding(lk))
    80007126:	e115                	bnez	a0,8000714a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007128:	87ba                	mv	a5,a4
    8000712a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000712e:	2781                	sext.w	a5,a5
    80007130:	ffe5                	bnez	a5,80007128 <acquire+0x22>
  __sync_synchronize();
    80007132:	0ff0000f          	fence
  lk->cpu = mycpu();
    80007136:	ffffa097          	auipc	ra,0xffffa
    8000713a:	d48080e7          	jalr	-696(ra) # 80000e7e <mycpu>
    8000713e:	e888                	sd	a0,16(s1)
}
    80007140:	60e2                	ld	ra,24(sp)
    80007142:	6442                	ld	s0,16(sp)
    80007144:	64a2                	ld	s1,8(sp)
    80007146:	6105                	addi	sp,sp,32
    80007148:	8082                	ret
    panic("acquire");
    8000714a:	00002517          	auipc	a0,0x2
    8000714e:	73650513          	addi	a0,a0,1846 # 80009880 <digits+0x20>
    80007152:	00000097          	auipc	ra,0x0
    80007156:	a78080e7          	jalr	-1416(ra) # 80006bca <panic>

000000008000715a <pop_off>:

void
pop_off(void)
{
    8000715a:	1141                	addi	sp,sp,-16
    8000715c:	e406                	sd	ra,8(sp)
    8000715e:	e022                	sd	s0,0(sp)
    80007160:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80007162:	ffffa097          	auipc	ra,0xffffa
    80007166:	d1c080e7          	jalr	-740(ra) # 80000e7e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000716a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000716e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80007170:	e78d                	bnez	a5,8000719a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80007172:	5d3c                	lw	a5,120(a0)
    80007174:	02f05b63          	blez	a5,800071aa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80007178:	37fd                	addiw	a5,a5,-1
    8000717a:	0007871b          	sext.w	a4,a5
    8000717e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80007180:	eb09                	bnez	a4,80007192 <pop_off+0x38>
    80007182:	5d7c                	lw	a5,124(a0)
    80007184:	c799                	beqz	a5,80007192 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007186:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000718a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000718e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80007192:	60a2                	ld	ra,8(sp)
    80007194:	6402                	ld	s0,0(sp)
    80007196:	0141                	addi	sp,sp,16
    80007198:	8082                	ret
    panic("pop_off - interruptible");
    8000719a:	00002517          	auipc	a0,0x2
    8000719e:	6ee50513          	addi	a0,a0,1774 # 80009888 <digits+0x28>
    800071a2:	00000097          	auipc	ra,0x0
    800071a6:	a28080e7          	jalr	-1496(ra) # 80006bca <panic>
    panic("pop_off");
    800071aa:	00002517          	auipc	a0,0x2
    800071ae:	6f650513          	addi	a0,a0,1782 # 800098a0 <digits+0x40>
    800071b2:	00000097          	auipc	ra,0x0
    800071b6:	a18080e7          	jalr	-1512(ra) # 80006bca <panic>

00000000800071ba <release>:
{
    800071ba:	1101                	addi	sp,sp,-32
    800071bc:	ec06                	sd	ra,24(sp)
    800071be:	e822                	sd	s0,16(sp)
    800071c0:	e426                	sd	s1,8(sp)
    800071c2:	1000                	addi	s0,sp,32
    800071c4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800071c6:	00000097          	auipc	ra,0x0
    800071ca:	ec6080e7          	jalr	-314(ra) # 8000708c <holding>
    800071ce:	c115                	beqz	a0,800071f2 <release+0x38>
  lk->cpu = 0;
    800071d0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800071d4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800071d8:	0f50000f          	fence	iorw,ow
    800071dc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800071e0:	00000097          	auipc	ra,0x0
    800071e4:	f7a080e7          	jalr	-134(ra) # 8000715a <pop_off>
}
    800071e8:	60e2                	ld	ra,24(sp)
    800071ea:	6442                	ld	s0,16(sp)
    800071ec:	64a2                	ld	s1,8(sp)
    800071ee:	6105                	addi	sp,sp,32
    800071f0:	8082                	ret
    panic("release");
    800071f2:	00002517          	auipc	a0,0x2
    800071f6:	6b650513          	addi	a0,a0,1718 # 800098a8 <digits+0x48>
    800071fa:	00000097          	auipc	ra,0x0
    800071fe:	9d0080e7          	jalr	-1584(ra) # 80006bca <panic>

0000000080007202 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80007202:	1141                	addi	sp,sp,-16
    80007204:	e422                	sd	s0,8(sp)
    80007206:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007208:	0ff0000f          	fence
    8000720c:	6108                	ld	a0,0(a0)
    8000720e:	0ff0000f          	fence
  return val;
}
    80007212:	6422                	ld	s0,8(sp)
    80007214:	0141                	addi	sp,sp,16
    80007216:	8082                	ret

0000000080007218 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80007218:	1141                	addi	sp,sp,-16
    8000721a:	e422                	sd	s0,8(sp)
    8000721c:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000721e:	0ff0000f          	fence
    80007222:	4108                	lw	a0,0(a0)
    80007224:	0ff0000f          	fence
  return val;
}
    80007228:	2501                	sext.w	a0,a0
    8000722a:	6422                	ld	s0,8(sp)
    8000722c:	0141                	addi	sp,sp,16
    8000722e:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
