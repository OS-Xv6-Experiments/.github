
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	85013103          	ld	sp,-1968(sp) # 80008850 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5c3050ef          	jal	ra,80005dd8 <start>

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
    80000030:	0002e797          	auipc	a5,0x2e
    80000034:	21078793          	addi	a5,a5,528 # 8002e240 <end>
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
    8000005e:	778080e7          	jalr	1912(ra) # 800067d2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	818080e7          	jalr	-2024(ra) # 80006886 <release>
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
    8000008e:	1fe080e7          	jalr	510(ra) # 80006288 <panic>

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
    800000f8:	64e080e7          	jalr	1614(ra) # 80006742 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	14050513          	addi	a0,a0,320 # 8002e240 <end>
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
    80000130:	6a6080e7          	jalr	1702(ra) # 800067d2 <acquire>
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
    80000148:	742080e7          	jalr	1858(ra) # 80006886 <release>

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
    80000172:	718080e7          	jalr	1816(ra) # 80006886 <release>
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
    80000332:	ac4080e7          	jalr	-1340(ra) # 80000df2 <cpuid>
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
    8000034e:	aa8080e7          	jalr	-1368(ra) # 80000df2 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	f76080e7          	jalr	-138(ra) # 800062d2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	8f6080e7          	jalr	-1802(ra) # 80001c62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	3ec080e7          	jalr	1004(ra) # 80005760 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	ff0080e7          	jalr	-16(ra) # 8000136c <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	e16080e7          	jalr	-490(ra) # 8000619a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	12c080e7          	jalr	300(ra) # 800064b8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	f36080e7          	jalr	-202(ra) # 800062d2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	f26080e7          	jalr	-218(ra) # 800062d2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	f16080e7          	jalr	-234(ra) # 800062d2 <printf>
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
    800003e0:	966080e7          	jalr	-1690(ra) # 80000d42 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	856080e7          	jalr	-1962(ra) # 80001c3a <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	876080e7          	jalr	-1930(ra) # 80001c62 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	356080e7          	jalr	854(ra) # 8000574a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	364080e7          	jalr	868(ra) # 80005760 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	10a080e7          	jalr	266(ra) # 8000250e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	79a080e7          	jalr	1946(ra) # 80002ba6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	744080e7          	jalr	1860(ra) # 80003b58 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	466080e7          	jalr	1126(ra) # 80005882 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cd2080e7          	jalr	-814(ra) # 800010f6 <userinit>
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
    80000492:	dfa080e7          	jalr	-518(ra) # 80006288 <panic>
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
    8000058a:	d02080e7          	jalr	-766(ra) # 80006288 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	cf2080e7          	jalr	-782(ra) # 80006288 <panic>
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
    80000610:	00006097          	auipc	ra,0x6
    80000614:	c78080e7          	jalr	-904(ra) # 80006288 <panic>

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
    800006dc:	5d4080e7          	jalr	1492(ra) # 80000cac <proc_mapstacks>
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
    8000072e:	8bb6                	mv	s7,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      //panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b05                	li	s6,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0535e963          	bltu	a1,s3,8000078c <uvmunmap+0x7e>
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
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	b2c080e7          	jalr	-1236(ra) # 80006288 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	b1c080e7          	jalr	-1252(ra) # 80006288 <panic>
      uint64 pa = PTE2PA(*pte);
    80000774:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000776:	00c79513          	slli	a0,a5,0xc
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	8a2080e7          	jalr	-1886(ra) # 8000001c <kfree>
    *pte = 0;
    80000782:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000786:	9956                	add	s2,s2,s5
    80000788:	fb397be3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078c:	4601                	li	a2,0
    8000078e:	85ca                	mv	a1,s2
    80000790:	8552                	mv	a0,s4
    80000792:	00000097          	auipc	ra,0x0
    80000796:	cce080e7          	jalr	-818(ra) # 80000460 <walk>
    8000079a:	84aa                	mv	s1,a0
    8000079c:	d561                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000079e:	611c                	ld	a5,0(a0)
    800007a0:	0017f713          	andi	a4,a5,1
    800007a4:	d36d                	beqz	a4,80000786 <uvmunmap+0x78>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a6:	3ff7f713          	andi	a4,a5,1023
    800007aa:	fd670ee3          	beq	a4,s6,80000786 <uvmunmap+0x78>
    if(do_free){
    800007ae:	fc0b8ae3          	beqz	s7,80000782 <uvmunmap+0x74>
    800007b2:	b7c9                	j	80000774 <uvmunmap+0x66>

00000000800007b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	95a080e7          	jalr	-1702(ra) # 80000118 <kalloc>
    800007c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007c8:	c519                	beqz	a0,800007d6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ca:	6605                	lui	a2,0x1
    800007cc:	4581                	li	a1,0
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	9aa080e7          	jalr	-1622(ra) # 80000178 <memset>
  return pagetable;
}
    800007d6:	8526                	mv	a0,s1
    800007d8:	60e2                	ld	ra,24(sp)
    800007da:	6442                	ld	s0,16(sp)
    800007dc:	64a2                	ld	s1,8(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007e2:	7179                	addi	sp,sp,-48
    800007e4:	f406                	sd	ra,40(sp)
    800007e6:	f022                	sd	s0,32(sp)
    800007e8:	ec26                	sd	s1,24(sp)
    800007ea:	e84a                	sd	s2,16(sp)
    800007ec:	e44e                	sd	s3,8(sp)
    800007ee:	e052                	sd	s4,0(sp)
    800007f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007f2:	6785                	lui	a5,0x1
    800007f4:	04f67863          	bgeu	a2,a5,80000844 <uvminit+0x62>
    800007f8:	8a2a                	mv	s4,a0
    800007fa:	89ae                	mv	s3,a1
    800007fc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	91a080e7          	jalr	-1766(ra) # 80000118 <kalloc>
    80000806:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000808:	6605                	lui	a2,0x1
    8000080a:	4581                	li	a1,0
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	96c080e7          	jalr	-1684(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000814:	4779                	li	a4,30
    80000816:	86ca                	mv	a3,s2
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	8552                	mv	a0,s4
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	d2a080e7          	jalr	-726(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000826:	8626                	mv	a2,s1
    80000828:	85ce                	mv	a1,s3
    8000082a:	854a                	mv	a0,s2
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	9ac080e7          	jalr	-1620(ra) # 800001d8 <memmove>
}
    80000834:	70a2                	ld	ra,40(sp)
    80000836:	7402                	ld	s0,32(sp)
    80000838:	64e2                	ld	s1,24(sp)
    8000083a:	6942                	ld	s2,16(sp)
    8000083c:	69a2                	ld	s3,8(sp)
    8000083e:	6a02                	ld	s4,0(sp)
    80000840:	6145                	addi	sp,sp,48
    80000842:	8082                	ret
    panic("inituvm: more than a page");
    80000844:	00008517          	auipc	a0,0x8
    80000848:	86450513          	addi	a0,a0,-1948 # 800080a8 <etext+0xa8>
    8000084c:	00006097          	auipc	ra,0x6
    80000850:	a3c080e7          	jalr	-1476(ra) # 80006288 <panic>

0000000080000854 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000085e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000860:	00b67d63          	bgeu	a2,a1,8000087a <uvmdealloc+0x26>
    80000864:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000866:	6785                	lui	a5,0x1
    80000868:	17fd                	addi	a5,a5,-1
    8000086a:	00f60733          	add	a4,a2,a5
    8000086e:	767d                	lui	a2,0xfffff
    80000870:	8f71                	and	a4,a4,a2
    80000872:	97ae                	add	a5,a5,a1
    80000874:	8ff1                	and	a5,a5,a2
    80000876:	00f76863          	bltu	a4,a5,80000886 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000087a:	8526                	mv	a0,s1
    8000087c:	60e2                	ld	ra,24(sp)
    8000087e:	6442                	ld	s0,16(sp)
    80000880:	64a2                	ld	s1,8(sp)
    80000882:	6105                	addi	sp,sp,32
    80000884:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000886:	8f99                	sub	a5,a5,a4
    80000888:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000088a:	4685                	li	a3,1
    8000088c:	0007861b          	sext.w	a2,a5
    80000890:	85ba                	mv	a1,a4
    80000892:	00000097          	auipc	ra,0x0
    80000896:	e7c080e7          	jalr	-388(ra) # 8000070e <uvmunmap>
    8000089a:	b7c5                	j	8000087a <uvmdealloc+0x26>

000000008000089c <uvmalloc>:
  if(newsz < oldsz)
    8000089c:	0ab66163          	bltu	a2,a1,8000093e <uvmalloc+0xa2>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	0080                	addi	s0,sp,64
    800008b2:	8aaa                	mv	s5,a0
    800008b4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008b6:	6985                	lui	s3,0x1
    800008b8:	19fd                	addi	s3,s3,-1
    800008ba:	95ce                	add	a1,a1,s3
    800008bc:	79fd                	lui	s3,0xfffff
    800008be:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008c2:	08c9f063          	bgeu	s3,a2,80000942 <uvmalloc+0xa6>
    800008c6:	894e                	mv	s2,s3
    mem = kalloc();
    800008c8:	00000097          	auipc	ra,0x0
    800008cc:	850080e7          	jalr	-1968(ra) # 80000118 <kalloc>
    800008d0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008d2:	c51d                	beqz	a0,80000900 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008d4:	6605                	lui	a2,0x1
    800008d6:	4581                	li	a1,0
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	8a0080e7          	jalr	-1888(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008e0:	4779                	li	a4,30
    800008e2:	86a6                	mv	a3,s1
    800008e4:	6605                	lui	a2,0x1
    800008e6:	85ca                	mv	a1,s2
    800008e8:	8556                	mv	a0,s5
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	c5e080e7          	jalr	-930(ra) # 80000548 <mappages>
    800008f2:	e905                	bnez	a0,80000922 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008f4:	6785                	lui	a5,0x1
    800008f6:	993e                	add	s2,s2,a5
    800008f8:	fd4968e3          	bltu	s2,s4,800008c8 <uvmalloc+0x2c>
  return newsz;
    800008fc:	8552                	mv	a0,s4
    800008fe:	a809                	j	80000910 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000900:	864e                	mv	a2,s3
    80000902:	85ca                	mv	a1,s2
    80000904:	8556                	mv	a0,s5
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f4e080e7          	jalr	-178(ra) # 80000854 <uvmdealloc>
      return 0;
    8000090e:	4501                	li	a0,0
}
    80000910:	70e2                	ld	ra,56(sp)
    80000912:	7442                	ld	s0,48(sp)
    80000914:	74a2                	ld	s1,40(sp)
    80000916:	7902                	ld	s2,32(sp)
    80000918:	69e2                	ld	s3,24(sp)
    8000091a:	6a42                	ld	s4,16(sp)
    8000091c:	6aa2                	ld	s5,8(sp)
    8000091e:	6121                	addi	sp,sp,64
    80000920:	8082                	ret
      kfree(mem);
    80000922:	8526                	mv	a0,s1
    80000924:	fffff097          	auipc	ra,0xfffff
    80000928:	6f8080e7          	jalr	1784(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000092c:	864e                	mv	a2,s3
    8000092e:	85ca                	mv	a1,s2
    80000930:	8556                	mv	a0,s5
    80000932:	00000097          	auipc	ra,0x0
    80000936:	f22080e7          	jalr	-222(ra) # 80000854 <uvmdealloc>
      return 0;
    8000093a:	4501                	li	a0,0
    8000093c:	bfd1                	j	80000910 <uvmalloc+0x74>
    return oldsz;
    8000093e:	852e                	mv	a0,a1
}
    80000940:	8082                	ret
  return newsz;
    80000942:	8532                	mv	a0,a2
    80000944:	b7f1                	j	80000910 <uvmalloc+0x74>

0000000080000946 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000946:	7179                	addi	sp,sp,-48
    80000948:	f406                	sd	ra,40(sp)
    8000094a:	f022                	sd	s0,32(sp)
    8000094c:	ec26                	sd	s1,24(sp)
    8000094e:	e84a                	sd	s2,16(sp)
    80000950:	e44e                	sd	s3,8(sp)
    80000952:	e052                	sd	s4,0(sp)
    80000954:	1800                	addi	s0,sp,48
    80000956:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000958:	84aa                	mv	s1,a0
    8000095a:	6905                	lui	s2,0x1
    8000095c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000095e:	4985                	li	s3,1
    80000960:	a821                	j	80000978 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000962:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000964:	0532                	slli	a0,a0,0xc
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	fe0080e7          	jalr	-32(ra) # 80000946 <freewalk>
      pagetable[i] = 0;
    8000096e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000972:	04a1                	addi	s1,s1,8
    80000974:	03248163          	beq	s1,s2,80000996 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000978:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097a:	00f57793          	andi	a5,a0,15
    8000097e:	ff3782e3          	beq	a5,s3,80000962 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000982:	8905                	andi	a0,a0,1
    80000984:	d57d                	beqz	a0,80000972 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000986:	00007517          	auipc	a0,0x7
    8000098a:	74250513          	addi	a0,a0,1858 # 800080c8 <etext+0xc8>
    8000098e:	00006097          	auipc	ra,0x6
    80000992:	8fa080e7          	jalr	-1798(ra) # 80006288 <panic>
    }
  }
  kfree((void*)pagetable);
    80000996:	8552                	mv	a0,s4
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	684080e7          	jalr	1668(ra) # 8000001c <kfree>
}
    800009a0:	70a2                	ld	ra,40(sp)
    800009a2:	7402                	ld	s0,32(sp)
    800009a4:	64e2                	ld	s1,24(sp)
    800009a6:	6942                	ld	s2,16(sp)
    800009a8:	69a2                	ld	s3,8(sp)
    800009aa:	6a02                	ld	s4,0(sp)
    800009ac:	6145                	addi	sp,sp,48
    800009ae:	8082                	ret

00000000800009b0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
    800009ba:	84aa                	mv	s1,a0
  if(sz > 0)
    800009bc:	e999                	bnez	a1,800009d2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	f86080e7          	jalr	-122(ra) # 80000946 <freewalk>
}
    800009c8:	60e2                	ld	ra,24(sp)
    800009ca:	6442                	ld	s0,16(sp)
    800009cc:	64a2                	ld	s1,8(sp)
    800009ce:	6105                	addi	sp,sp,32
    800009d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009d2:	6605                	lui	a2,0x1
    800009d4:	167d                	addi	a2,a2,-1
    800009d6:	962e                	add	a2,a2,a1
    800009d8:	4685                	li	a3,1
    800009da:	8231                	srli	a2,a2,0xc
    800009dc:	4581                	li	a1,0
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	d30080e7          	jalr	-720(ra) # 8000070e <uvmunmap>
    800009e6:	bfe1                	j	800009be <uvmfree+0xe>

00000000800009e8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009e8:	c269                	beqz	a2,80000aaa <uvmcopy+0xc2>
{
    800009ea:	715d                	addi	sp,sp,-80
    800009ec:	e486                	sd	ra,72(sp)
    800009ee:	e0a2                	sd	s0,64(sp)
    800009f0:	fc26                	sd	s1,56(sp)
    800009f2:	f84a                	sd	s2,48(sp)
    800009f4:	f44e                	sd	s3,40(sp)
    800009f6:	f052                	sd	s4,32(sp)
    800009f8:	ec56                	sd	s5,24(sp)
    800009fa:	e85a                	sd	s6,16(sp)
    800009fc:	e45e                	sd	s7,8(sp)
    800009fe:	0880                	addi	s0,sp,80
    80000a00:	8aaa                	mv	s5,a0
    80000a02:	8b2e                	mv	s6,a1
    80000a04:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	4481                	li	s1,0
    80000a08:	a829                	j	80000a22 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a0a:	00007517          	auipc	a0,0x7
    80000a0e:	6ce50513          	addi	a0,a0,1742 # 800080d8 <etext+0xd8>
    80000a12:	00006097          	auipc	ra,0x6
    80000a16:	876080e7          	jalr	-1930(ra) # 80006288 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a1a:	6785                	lui	a5,0x1
    80000a1c:	94be                	add	s1,s1,a5
    80000a1e:	0944f463          	bgeu	s1,s4,80000aa6 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a22:	4601                	li	a2,0
    80000a24:	85a6                	mv	a1,s1
    80000a26:	8556                	mv	a0,s5
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	a38080e7          	jalr	-1480(ra) # 80000460 <walk>
    80000a30:	dd69                	beqz	a0,80000a0a <uvmcopy+0x22>
    if ((*pte & PTE_V) == 0)
    80000a32:	6118                	ld	a4,0(a0)
    80000a34:	00177793          	andi	a5,a4,1
    80000a38:	d3ed                	beqz	a5,80000a1a <uvmcopy+0x32>
      // panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80000a3a:	00a75593          	srli	a1,a4,0xa
    80000a3e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a42:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a46:	fffff097          	auipc	ra,0xfffff
    80000a4a:	6d2080e7          	jalr	1746(ra) # 80000118 <kalloc>
    80000a4e:	89aa                	mv	s3,a0
    80000a50:	c515                	beqz	a0,80000a7c <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a52:	6605                	lui	a2,0x1
    80000a54:	85de                	mv	a1,s7
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	782080e7          	jalr	1922(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5e:	874a                	mv	a4,s2
    80000a60:	86ce                	mv	a3,s3
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85a6                	mv	a1,s1
    80000a66:	855a                	mv	a0,s6
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	ae0080e7          	jalr	-1312(ra) # 80000548 <mappages>
    80000a70:	d54d                	beqz	a0,80000a1a <uvmcopy+0x32>
      kfree(mem);
    80000a72:	854e                	mv	a0,s3
    80000a74:	fffff097          	auipc	ra,0xfffff
    80000a78:	5a8080e7          	jalr	1448(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a7c:	4685                	li	a3,1
    80000a7e:	00c4d613          	srli	a2,s1,0xc
    80000a82:	4581                	li	a1,0
    80000a84:	855a                	mv	a0,s6
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	c88080e7          	jalr	-888(ra) # 8000070e <uvmunmap>
  return -1;
    80000a8e:	557d                	li	a0,-1
}
    80000a90:	60a6                	ld	ra,72(sp)
    80000a92:	6406                	ld	s0,64(sp)
    80000a94:	74e2                	ld	s1,56(sp)
    80000a96:	7942                	ld	s2,48(sp)
    80000a98:	79a2                	ld	s3,40(sp)
    80000a9a:	7a02                	ld	s4,32(sp)
    80000a9c:	6ae2                	ld	s5,24(sp)
    80000a9e:	6b42                	ld	s6,16(sp)
    80000aa0:	6ba2                	ld	s7,8(sp)
    80000aa2:	6161                	addi	sp,sp,80
    80000aa4:	8082                	ret
  return 0;
    80000aa6:	4501                	li	a0,0
    80000aa8:	b7e5                	j	80000a90 <uvmcopy+0xa8>
    80000aaa:	4501                	li	a0,0
}
    80000aac:	8082                	ret

0000000080000aae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aae:	1141                	addi	sp,sp,-16
    80000ab0:	e406                	sd	ra,8(sp)
    80000ab2:	e022                	sd	s0,0(sp)
    80000ab4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ab6:	4601                	li	a2,0
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	9a8080e7          	jalr	-1624(ra) # 80000460 <walk>
  if(pte == 0)
    80000ac0:	c901                	beqz	a0,80000ad0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ac2:	611c                	ld	a5,0(a0)
    80000ac4:	9bbd                	andi	a5,a5,-17
    80000ac6:	e11c                	sd	a5,0(a0)
}
    80000ac8:	60a2                	ld	ra,8(sp)
    80000aca:	6402                	ld	s0,0(sp)
    80000acc:	0141                	addi	sp,sp,16
    80000ace:	8082                	ret
    panic("uvmclear");
    80000ad0:	00007517          	auipc	a0,0x7
    80000ad4:	62850513          	addi	a0,a0,1576 # 800080f8 <etext+0xf8>
    80000ad8:	00005097          	auipc	ra,0x5
    80000adc:	7b0080e7          	jalr	1968(ra) # 80006288 <panic>

0000000080000ae0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ae0:	c6bd                	beqz	a3,80000b4e <copyout+0x6e>
{
    80000ae2:	715d                	addi	sp,sp,-80
    80000ae4:	e486                	sd	ra,72(sp)
    80000ae6:	e0a2                	sd	s0,64(sp)
    80000ae8:	fc26                	sd	s1,56(sp)
    80000aea:	f84a                	sd	s2,48(sp)
    80000aec:	f44e                	sd	s3,40(sp)
    80000aee:	f052                	sd	s4,32(sp)
    80000af0:	ec56                	sd	s5,24(sp)
    80000af2:	e85a                	sd	s6,16(sp)
    80000af4:	e45e                	sd	s7,8(sp)
    80000af6:	e062                	sd	s8,0(sp)
    80000af8:	0880                	addi	s0,sp,80
    80000afa:	8b2a                	mv	s6,a0
    80000afc:	8c2e                	mv	s8,a1
    80000afe:	8a32                	mv	s4,a2
    80000b00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b04:	6a85                	lui	s5,0x1
    80000b06:	a015                	j	80000b2a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b08:	9562                	add	a0,a0,s8
    80000b0a:	0004861b          	sext.w	a2,s1
    80000b0e:	85d2                	mv	a1,s4
    80000b10:	41250533          	sub	a0,a0,s2
    80000b14:	fffff097          	auipc	ra,0xfffff
    80000b18:	6c4080e7          	jalr	1732(ra) # 800001d8 <memmove>

    len -= n;
    80000b1c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b20:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b26:	02098263          	beqz	s3,80000b4a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b2e:	85ca                	mv	a1,s2
    80000b30:	855a                	mv	a0,s6
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	9d4080e7          	jalr	-1580(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b3a:	cd01                	beqz	a0,80000b52 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b3c:	418904b3          	sub	s1,s2,s8
    80000b40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b42:	fc99f3e3          	bgeu	s3,s1,80000b08 <copyout+0x28>
    80000b46:	84ce                	mv	s1,s3
    80000b48:	b7c1                	j	80000b08 <copyout+0x28>
  }
  return 0;
    80000b4a:	4501                	li	a0,0
    80000b4c:	a021                	j	80000b54 <copyout+0x74>
    80000b4e:	4501                	li	a0,0
}
    80000b50:	8082                	ret
      return -1;
    80000b52:	557d                	li	a0,-1
}
    80000b54:	60a6                	ld	ra,72(sp)
    80000b56:	6406                	ld	s0,64(sp)
    80000b58:	74e2                	ld	s1,56(sp)
    80000b5a:	7942                	ld	s2,48(sp)
    80000b5c:	79a2                	ld	s3,40(sp)
    80000b5e:	7a02                	ld	s4,32(sp)
    80000b60:	6ae2                	ld	s5,24(sp)
    80000b62:	6b42                	ld	s6,16(sp)
    80000b64:	6ba2                	ld	s7,8(sp)
    80000b66:	6c02                	ld	s8,0(sp)
    80000b68:	6161                	addi	sp,sp,80
    80000b6a:	8082                	ret

0000000080000b6c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b6c:	c6bd                	beqz	a3,80000bda <copyin+0x6e>
{
    80000b6e:	715d                	addi	sp,sp,-80
    80000b70:	e486                	sd	ra,72(sp)
    80000b72:	e0a2                	sd	s0,64(sp)
    80000b74:	fc26                	sd	s1,56(sp)
    80000b76:	f84a                	sd	s2,48(sp)
    80000b78:	f44e                	sd	s3,40(sp)
    80000b7a:	f052                	sd	s4,32(sp)
    80000b7c:	ec56                	sd	s5,24(sp)
    80000b7e:	e85a                	sd	s6,16(sp)
    80000b80:	e45e                	sd	s7,8(sp)
    80000b82:	e062                	sd	s8,0(sp)
    80000b84:	0880                	addi	s0,sp,80
    80000b86:	8b2a                	mv	s6,a0
    80000b88:	8a2e                	mv	s4,a1
    80000b8a:	8c32                	mv	s8,a2
    80000b8c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b8e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b90:	6a85                	lui	s5,0x1
    80000b92:	a015                	j	80000bb6 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b94:	9562                	add	a0,a0,s8
    80000b96:	0004861b          	sext.w	a2,s1
    80000b9a:	412505b3          	sub	a1,a0,s2
    80000b9e:	8552                	mv	a0,s4
    80000ba0:	fffff097          	auipc	ra,0xfffff
    80000ba4:	638080e7          	jalr	1592(ra) # 800001d8 <memmove>

    len -= n;
    80000ba8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bac:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bae:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bb2:	02098263          	beqz	s3,80000bd6 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bba:	85ca                	mv	a1,s2
    80000bbc:	855a                	mv	a0,s6
    80000bbe:	00000097          	auipc	ra,0x0
    80000bc2:	948080e7          	jalr	-1720(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bc6:	cd01                	beqz	a0,80000bde <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bc8:	418904b3          	sub	s1,s2,s8
    80000bcc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bce:	fc99f3e3          	bgeu	s3,s1,80000b94 <copyin+0x28>
    80000bd2:	84ce                	mv	s1,s3
    80000bd4:	b7c1                	j	80000b94 <copyin+0x28>
  }
  return 0;
    80000bd6:	4501                	li	a0,0
    80000bd8:	a021                	j	80000be0 <copyin+0x74>
    80000bda:	4501                	li	a0,0
}
    80000bdc:	8082                	ret
      return -1;
    80000bde:	557d                	li	a0,-1
}
    80000be0:	60a6                	ld	ra,72(sp)
    80000be2:	6406                	ld	s0,64(sp)
    80000be4:	74e2                	ld	s1,56(sp)
    80000be6:	7942                	ld	s2,48(sp)
    80000be8:	79a2                	ld	s3,40(sp)
    80000bea:	7a02                	ld	s4,32(sp)
    80000bec:	6ae2                	ld	s5,24(sp)
    80000bee:	6b42                	ld	s6,16(sp)
    80000bf0:	6ba2                	ld	s7,8(sp)
    80000bf2:	6c02                	ld	s8,0(sp)
    80000bf4:	6161                	addi	sp,sp,80
    80000bf6:	8082                	ret

0000000080000bf8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000bf8:	c6c5                	beqz	a3,80000ca0 <copyinstr+0xa8>
{
    80000bfa:	715d                	addi	sp,sp,-80
    80000bfc:	e486                	sd	ra,72(sp)
    80000bfe:	e0a2                	sd	s0,64(sp)
    80000c00:	fc26                	sd	s1,56(sp)
    80000c02:	f84a                	sd	s2,48(sp)
    80000c04:	f44e                	sd	s3,40(sp)
    80000c06:	f052                	sd	s4,32(sp)
    80000c08:	ec56                	sd	s5,24(sp)
    80000c0a:	e85a                	sd	s6,16(sp)
    80000c0c:	e45e                	sd	s7,8(sp)
    80000c0e:	0880                	addi	s0,sp,80
    80000c10:	8a2a                	mv	s4,a0
    80000c12:	8b2e                	mv	s6,a1
    80000c14:	8bb2                	mv	s7,a2
    80000c16:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c18:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1a:	6985                	lui	s3,0x1
    80000c1c:	a035                	j	80000c48 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c1e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c22:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c24:	0017b793          	seqz	a5,a5
    80000c28:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c2c:	60a6                	ld	ra,72(sp)
    80000c2e:	6406                	ld	s0,64(sp)
    80000c30:	74e2                	ld	s1,56(sp)
    80000c32:	7942                	ld	s2,48(sp)
    80000c34:	79a2                	ld	s3,40(sp)
    80000c36:	7a02                	ld	s4,32(sp)
    80000c38:	6ae2                	ld	s5,24(sp)
    80000c3a:	6b42                	ld	s6,16(sp)
    80000c3c:	6ba2                	ld	s7,8(sp)
    80000c3e:	6161                	addi	sp,sp,80
    80000c40:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c42:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c46:	c8a9                	beqz	s1,80000c98 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c48:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c4c:	85ca                	mv	a1,s2
    80000c4e:	8552                	mv	a0,s4
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	8b6080e7          	jalr	-1866(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c58:	c131                	beqz	a0,80000c9c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c5a:	41790833          	sub	a6,s2,s7
    80000c5e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c60:	0104f363          	bgeu	s1,a6,80000c66 <copyinstr+0x6e>
    80000c64:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c66:	955e                	add	a0,a0,s7
    80000c68:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c6c:	fc080be3          	beqz	a6,80000c42 <copyinstr+0x4a>
    80000c70:	985a                	add	a6,a6,s6
    80000c72:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c74:	41650633          	sub	a2,a0,s6
    80000c78:	14fd                	addi	s1,s1,-1
    80000c7a:	9b26                	add	s6,s6,s1
    80000c7c:	00f60733          	add	a4,a2,a5
    80000c80:	00074703          	lbu	a4,0(a4)
    80000c84:	df49                	beqz	a4,80000c1e <copyinstr+0x26>
        *dst = *p;
    80000c86:	00e78023          	sb	a4,0(a5)
      --max;
    80000c8a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c8e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c90:	ff0796e3          	bne	a5,a6,80000c7c <copyinstr+0x84>
      dst++;
    80000c94:	8b42                	mv	s6,a6
    80000c96:	b775                	j	80000c42 <copyinstr+0x4a>
    80000c98:	4781                	li	a5,0
    80000c9a:	b769                	j	80000c24 <copyinstr+0x2c>
      return -1;
    80000c9c:	557d                	li	a0,-1
    80000c9e:	b779                	j	80000c2c <copyinstr+0x34>
  int got_null = 0;
    80000ca0:	4781                	li	a5,0
  if(got_null){
    80000ca2:	0017b793          	seqz	a5,a5
    80000ca6:	40f00533          	neg	a0,a5
}
    80000caa:	8082                	ret

0000000080000cac <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cac:	7139                	addi	sp,sp,-64
    80000cae:	fc06                	sd	ra,56(sp)
    80000cb0:	f822                	sd	s0,48(sp)
    80000cb2:	f426                	sd	s1,40(sp)
    80000cb4:	f04a                	sd	s2,32(sp)
    80000cb6:	ec4e                	sd	s3,24(sp)
    80000cb8:	e852                	sd	s4,16(sp)
    80000cba:	e456                	sd	s5,8(sp)
    80000cbc:	e05a                	sd	s6,0(sp)
    80000cbe:	0080                	addi	s0,sp,64
    80000cc0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc2:	00008497          	auipc	s1,0x8
    80000cc6:	7be48493          	addi	s1,s1,1982 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cca:	8b26                	mv	s6,s1
    80000ccc:	00007a97          	auipc	s5,0x7
    80000cd0:	334a8a93          	addi	s5,s5,820 # 80008000 <etext>
    80000cd4:	04000937          	lui	s2,0x4000
    80000cd8:	197d                	addi	s2,s2,-1
    80000cda:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cdc:	00016a17          	auipc	s4,0x16
    80000ce0:	1a4a0a13          	addi	s4,s4,420 # 80016e80 <tickslock>
    char *pa = kalloc();
    80000ce4:	fffff097          	auipc	ra,0xfffff
    80000ce8:	434080e7          	jalr	1076(ra) # 80000118 <kalloc>
    80000cec:	862a                	mv	a2,a0
    if(pa == 0)
    80000cee:	c131                	beqz	a0,80000d32 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	416485b3          	sub	a1,s1,s6
    80000cf4:	858d                	srai	a1,a1,0x3
    80000cf6:	000ab783          	ld	a5,0(s5)
    80000cfa:	02f585b3          	mul	a1,a1,a5
    80000cfe:	2585                	addiw	a1,a1,1
    80000d00:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d04:	4719                	li	a4,6
    80000d06:	6685                	lui	a3,0x1
    80000d08:	40b905b3          	sub	a1,s2,a1
    80000d0c:	854e                	mv	a0,s3
    80000d0e:	00000097          	auipc	ra,0x0
    80000d12:	8da080e7          	jalr	-1830(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d16:	36848493          	addi	s1,s1,872
    80000d1a:	fd4495e3          	bne	s1,s4,80000ce4 <proc_mapstacks+0x38>
  }
}
    80000d1e:	70e2                	ld	ra,56(sp)
    80000d20:	7442                	ld	s0,48(sp)
    80000d22:	74a2                	ld	s1,40(sp)
    80000d24:	7902                	ld	s2,32(sp)
    80000d26:	69e2                	ld	s3,24(sp)
    80000d28:	6a42                	ld	s4,16(sp)
    80000d2a:	6aa2                	ld	s5,8(sp)
    80000d2c:	6b02                	ld	s6,0(sp)
    80000d2e:	6121                	addi	sp,sp,64
    80000d30:	8082                	ret
      panic("kalloc");
    80000d32:	00007517          	auipc	a0,0x7
    80000d36:	3d650513          	addi	a0,a0,982 # 80008108 <etext+0x108>
    80000d3a:	00005097          	auipc	ra,0x5
    80000d3e:	54e080e7          	jalr	1358(ra) # 80006288 <panic>

0000000080000d42 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d42:	7139                	addi	sp,sp,-64
    80000d44:	fc06                	sd	ra,56(sp)
    80000d46:	f822                	sd	s0,48(sp)
    80000d48:	f426                	sd	s1,40(sp)
    80000d4a:	f04a                	sd	s2,32(sp)
    80000d4c:	ec4e                	sd	s3,24(sp)
    80000d4e:	e852                	sd	s4,16(sp)
    80000d50:	e456                	sd	s5,8(sp)
    80000d52:	e05a                	sd	s6,0(sp)
    80000d54:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d56:	00007597          	auipc	a1,0x7
    80000d5a:	3ba58593          	addi	a1,a1,954 # 80008110 <etext+0x110>
    80000d5e:	00008517          	auipc	a0,0x8
    80000d62:	2f250513          	addi	a0,a0,754 # 80009050 <pid_lock>
    80000d66:	00006097          	auipc	ra,0x6
    80000d6a:	9dc080e7          	jalr	-1572(ra) # 80006742 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d6e:	00007597          	auipc	a1,0x7
    80000d72:	3aa58593          	addi	a1,a1,938 # 80008118 <etext+0x118>
    80000d76:	00008517          	auipc	a0,0x8
    80000d7a:	2f250513          	addi	a0,a0,754 # 80009068 <wait_lock>
    80000d7e:	00006097          	auipc	ra,0x6
    80000d82:	9c4080e7          	jalr	-1596(ra) # 80006742 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d86:	00008497          	auipc	s1,0x8
    80000d8a:	6fa48493          	addi	s1,s1,1786 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000d8e:	00007b17          	auipc	s6,0x7
    80000d92:	39ab0b13          	addi	s6,s6,922 # 80008128 <etext+0x128>
      p->kstack = KSTACK((int) (p - proc));
    80000d96:	8aa6                	mv	s5,s1
    80000d98:	00007a17          	auipc	s4,0x7
    80000d9c:	268a0a13          	addi	s4,s4,616 # 80008000 <etext>
    80000da0:	04000937          	lui	s2,0x4000
    80000da4:	197d                	addi	s2,s2,-1
    80000da6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da8:	00016997          	auipc	s3,0x16
    80000dac:	0d898993          	addi	s3,s3,216 # 80016e80 <tickslock>
      initlock(&p->lock, "proc");
    80000db0:	85da                	mv	a1,s6
    80000db2:	8526                	mv	a0,s1
    80000db4:	00006097          	auipc	ra,0x6
    80000db8:	98e080e7          	jalr	-1650(ra) # 80006742 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	415487b3          	sub	a5,s1,s5
    80000dc0:	878d                	srai	a5,a5,0x3
    80000dc2:	000a3703          	ld	a4,0(s4)
    80000dc6:	02e787b3          	mul	a5,a5,a4
    80000dca:	2785                	addiw	a5,a5,1
    80000dcc:	00d7979b          	slliw	a5,a5,0xd
    80000dd0:	40f907b3          	sub	a5,s2,a5
    80000dd4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	36848493          	addi	s1,s1,872
    80000dda:	fd349be3          	bne	s1,s3,80000db0 <procinit+0x6e>
  }
}
    80000dde:	70e2                	ld	ra,56(sp)
    80000de0:	7442                	ld	s0,48(sp)
    80000de2:	74a2                	ld	s1,40(sp)
    80000de4:	7902                	ld	s2,32(sp)
    80000de6:	69e2                	ld	s3,24(sp)
    80000de8:	6a42                	ld	s4,16(sp)
    80000dea:	6aa2                	ld	s5,8(sp)
    80000dec:	6b02                	ld	s6,0(sp)
    80000dee:	6121                	addi	sp,sp,64
    80000df0:	8082                	ret

0000000080000df2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000df2:	1141                	addi	sp,sp,-16
    80000df4:	e422                	sd	s0,8(sp)
    80000df6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000df8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000dfa:	2501                	sext.w	a0,a0
    80000dfc:	6422                	ld	s0,8(sp)
    80000dfe:	0141                	addi	sp,sp,16
    80000e00:	8082                	ret

0000000080000e02 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e02:	1141                	addi	sp,sp,-16
    80000e04:	e422                	sd	s0,8(sp)
    80000e06:	0800                	addi	s0,sp,16
    80000e08:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e0a:	2781                	sext.w	a5,a5
    80000e0c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e0e:	00008517          	auipc	a0,0x8
    80000e12:	27250513          	addi	a0,a0,626 # 80009080 <cpus>
    80000e16:	953e                	add	a0,a0,a5
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e1e:	1101                	addi	sp,sp,-32
    80000e20:	ec06                	sd	ra,24(sp)
    80000e22:	e822                	sd	s0,16(sp)
    80000e24:	e426                	sd	s1,8(sp)
    80000e26:	1000                	addi	s0,sp,32
  push_off();
    80000e28:	00006097          	auipc	ra,0x6
    80000e2c:	95e080e7          	jalr	-1698(ra) # 80006786 <push_off>
    80000e30:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e32:	2781                	sext.w	a5,a5
    80000e34:	079e                	slli	a5,a5,0x7
    80000e36:	00008717          	auipc	a4,0x8
    80000e3a:	21a70713          	addi	a4,a4,538 # 80009050 <pid_lock>
    80000e3e:	97ba                	add	a5,a5,a4
    80000e40:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e42:	00006097          	auipc	ra,0x6
    80000e46:	9e4080e7          	jalr	-1564(ra) # 80006826 <pop_off>
  return p;
}
    80000e4a:	8526                	mv	a0,s1
    80000e4c:	60e2                	ld	ra,24(sp)
    80000e4e:	6442                	ld	s0,16(sp)
    80000e50:	64a2                	ld	s1,8(sp)
    80000e52:	6105                	addi	sp,sp,32
    80000e54:	8082                	ret

0000000080000e56 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e406                	sd	ra,8(sp)
    80000e5a:	e022                	sd	s0,0(sp)
    80000e5c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e5e:	00000097          	auipc	ra,0x0
    80000e62:	fc0080e7          	jalr	-64(ra) # 80000e1e <myproc>
    80000e66:	00006097          	auipc	ra,0x6
    80000e6a:	a20080e7          	jalr	-1504(ra) # 80006886 <release>

  if (first) {
    80000e6e:	00008797          	auipc	a5,0x8
    80000e72:	9927a783          	lw	a5,-1646(a5) # 80008800 <first.1762>
    80000e76:	eb89                	bnez	a5,80000e88 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e78:	00001097          	auipc	ra,0x1
    80000e7c:	e02080e7          	jalr	-510(ra) # 80001c7a <usertrapret>
}
    80000e80:	60a2                	ld	ra,8(sp)
    80000e82:	6402                	ld	s0,0(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret
    first = 0;
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	9607ac23          	sw	zero,-1672(a5) # 80008800 <first.1762>
    fsinit(ROOTDEV);
    80000e90:	4505                	li	a0,1
    80000e92:	00002097          	auipc	ra,0x2
    80000e96:	c94080e7          	jalr	-876(ra) # 80002b26 <fsinit>
    80000e9a:	bff9                	j	80000e78 <forkret+0x22>

0000000080000e9c <allocpid>:
allocpid() {
    80000e9c:	1101                	addi	sp,sp,-32
    80000e9e:	ec06                	sd	ra,24(sp)
    80000ea0:	e822                	sd	s0,16(sp)
    80000ea2:	e426                	sd	s1,8(sp)
    80000ea4:	e04a                	sd	s2,0(sp)
    80000ea6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ea8:	00008917          	auipc	s2,0x8
    80000eac:	1a890913          	addi	s2,s2,424 # 80009050 <pid_lock>
    80000eb0:	854a                	mv	a0,s2
    80000eb2:	00006097          	auipc	ra,0x6
    80000eb6:	920080e7          	jalr	-1760(ra) # 800067d2 <acquire>
  pid = nextpid;
    80000eba:	00008797          	auipc	a5,0x8
    80000ebe:	94a78793          	addi	a5,a5,-1718 # 80008804 <nextpid>
    80000ec2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ec4:	0014871b          	addiw	a4,s1,1
    80000ec8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00006097          	auipc	ra,0x6
    80000ed0:	9ba080e7          	jalr	-1606(ra) # 80006886 <release>
}
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	60e2                	ld	ra,24(sp)
    80000ed8:	6442                	ld	s0,16(sp)
    80000eda:	64a2                	ld	s1,8(sp)
    80000edc:	6902                	ld	s2,0(sp)
    80000ede:	6105                	addi	sp,sp,32
    80000ee0:	8082                	ret

0000000080000ee2 <proc_pagetable>:
{
    80000ee2:	1101                	addi	sp,sp,-32
    80000ee4:	ec06                	sd	ra,24(sp)
    80000ee6:	e822                	sd	s0,16(sp)
    80000ee8:	e426                	sd	s1,8(sp)
    80000eea:	e04a                	sd	s2,0(sp)
    80000eec:	1000                	addi	s0,sp,32
    80000eee:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	8c4080e7          	jalr	-1852(ra) # 800007b4 <uvmcreate>
    80000ef8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000efa:	c121                	beqz	a0,80000f3a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000efc:	4729                	li	a4,10
    80000efe:	00006697          	auipc	a3,0x6
    80000f02:	10268693          	addi	a3,a3,258 # 80007000 <_trampoline>
    80000f06:	6605                	lui	a2,0x1
    80000f08:	040005b7          	lui	a1,0x4000
    80000f0c:	15fd                	addi	a1,a1,-1
    80000f0e:	05b2                	slli	a1,a1,0xc
    80000f10:	fffff097          	auipc	ra,0xfffff
    80000f14:	638080e7          	jalr	1592(ra) # 80000548 <mappages>
    80000f18:	02054863          	bltz	a0,80000f48 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f1c:	4719                	li	a4,6
    80000f1e:	05893683          	ld	a3,88(s2)
    80000f22:	6605                	lui	a2,0x1
    80000f24:	020005b7          	lui	a1,0x2000
    80000f28:	15fd                	addi	a1,a1,-1
    80000f2a:	05b6                	slli	a1,a1,0xd
    80000f2c:	8526                	mv	a0,s1
    80000f2e:	fffff097          	auipc	ra,0xfffff
    80000f32:	61a080e7          	jalr	1562(ra) # 80000548 <mappages>
    80000f36:	02054163          	bltz	a0,80000f58 <proc_pagetable+0x76>
}
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	60e2                	ld	ra,24(sp)
    80000f3e:	6442                	ld	s0,16(sp)
    80000f40:	64a2                	ld	s1,8(sp)
    80000f42:	6902                	ld	s2,0(sp)
    80000f44:	6105                	addi	sp,sp,32
    80000f46:	8082                	ret
    uvmfree(pagetable, 0);
    80000f48:	4581                	li	a1,0
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	00000097          	auipc	ra,0x0
    80000f50:	a64080e7          	jalr	-1436(ra) # 800009b0 <uvmfree>
    return 0;
    80000f54:	4481                	li	s1,0
    80000f56:	b7d5                	j	80000f3a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f58:	4681                	li	a3,0
    80000f5a:	4605                	li	a2,1
    80000f5c:	040005b7          	lui	a1,0x4000
    80000f60:	15fd                	addi	a1,a1,-1
    80000f62:	05b2                	slli	a1,a1,0xc
    80000f64:	8526                	mv	a0,s1
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	7a8080e7          	jalr	1960(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a3e080e7          	jalr	-1474(ra) # 800009b0 <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	bf7d                	j	80000f3a <proc_pagetable+0x58>

0000000080000f7e <proc_freepagetable>:
{
    80000f7e:	1101                	addi	sp,sp,-32
    80000f80:	ec06                	sd	ra,24(sp)
    80000f82:	e822                	sd	s0,16(sp)
    80000f84:	e426                	sd	s1,8(sp)
    80000f86:	e04a                	sd	s2,0(sp)
    80000f88:	1000                	addi	s0,sp,32
    80000f8a:	84aa                	mv	s1,a0
    80000f8c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8e:	4681                	li	a3,0
    80000f90:	4605                	li	a2,1
    80000f92:	040005b7          	lui	a1,0x4000
    80000f96:	15fd                	addi	a1,a1,-1
    80000f98:	05b2                	slli	a1,a1,0xc
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	774080e7          	jalr	1908(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fa2:	4681                	li	a3,0
    80000fa4:	4605                	li	a2,1
    80000fa6:	020005b7          	lui	a1,0x2000
    80000faa:	15fd                	addi	a1,a1,-1
    80000fac:	05b6                	slli	a1,a1,0xd
    80000fae:	8526                	mv	a0,s1
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	75e080e7          	jalr	1886(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fb8:	85ca                	mv	a1,s2
    80000fba:	8526                	mv	a0,s1
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	9f4080e7          	jalr	-1548(ra) # 800009b0 <uvmfree>
}
    80000fc4:	60e2                	ld	ra,24(sp)
    80000fc6:	6442                	ld	s0,16(sp)
    80000fc8:	64a2                	ld	s1,8(sp)
    80000fca:	6902                	ld	s2,0(sp)
    80000fcc:	6105                	addi	sp,sp,32
    80000fce:	8082                	ret

0000000080000fd0 <freeproc>:
{
    80000fd0:	1101                	addi	sp,sp,-32
    80000fd2:	ec06                	sd	ra,24(sp)
    80000fd4:	e822                	sd	s0,16(sp)
    80000fd6:	e426                	sd	s1,8(sp)
    80000fd8:	1000                	addi	s0,sp,32
    80000fda:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fdc:	6d28                	ld	a0,88(a0)
    80000fde:	c509                	beqz	a0,80000fe8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000fe0:	fffff097          	auipc	ra,0xfffff
    80000fe4:	03c080e7          	jalr	60(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000fe8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000fec:	68a8                	ld	a0,80(s1)
    80000fee:	c511                	beqz	a0,80000ffa <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80000ff0:	64ac                	ld	a1,72(s1)
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	f8c080e7          	jalr	-116(ra) # 80000f7e <proc_freepagetable>
  p->pagetable = 0;
    80000ffa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ffe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001002:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001006:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000100a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000100e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001012:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001016:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000101a:	0004ac23          	sw	zero,24(s1)
}
    8000101e:	60e2                	ld	ra,24(sp)
    80001020:	6442                	ld	s0,16(sp)
    80001022:	64a2                	ld	s1,8(sp)
    80001024:	6105                	addi	sp,sp,32
    80001026:	8082                	ret

0000000080001028 <allocproc>:
{
    80001028:	1101                	addi	sp,sp,-32
    8000102a:	ec06                	sd	ra,24(sp)
    8000102c:	e822                	sd	s0,16(sp)
    8000102e:	e426                	sd	s1,8(sp)
    80001030:	e04a                	sd	s2,0(sp)
    80001032:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001034:	00008497          	auipc	s1,0x8
    80001038:	44c48493          	addi	s1,s1,1100 # 80009480 <proc>
    8000103c:	00016917          	auipc	s2,0x16
    80001040:	e4490913          	addi	s2,s2,-444 # 80016e80 <tickslock>
    acquire(&p->lock);
    80001044:	8526                	mv	a0,s1
    80001046:	00005097          	auipc	ra,0x5
    8000104a:	78c080e7          	jalr	1932(ra) # 800067d2 <acquire>
    if(p->state == UNUSED) {
    8000104e:	4c9c                	lw	a5,24(s1)
    80001050:	cf81                	beqz	a5,80001068 <allocproc+0x40>
      release(&p->lock);
    80001052:	8526                	mv	a0,s1
    80001054:	00006097          	auipc	ra,0x6
    80001058:	832080e7          	jalr	-1998(ra) # 80006886 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105c:	36848493          	addi	s1,s1,872
    80001060:	ff2492e3          	bne	s1,s2,80001044 <allocproc+0x1c>
  return 0;
    80001064:	4481                	li	s1,0
    80001066:	a889                	j	800010b8 <allocproc+0x90>
  p->pid = allocpid();
    80001068:	00000097          	auipc	ra,0x0
    8000106c:	e34080e7          	jalr	-460(ra) # 80000e9c <allocpid>
    80001070:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001072:	4785                	li	a5,1
    80001074:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	0a2080e7          	jalr	162(ra) # 80000118 <kalloc>
    8000107e:	892a                	mv	s2,a0
    80001080:	eca8                	sd	a0,88(s1)
    80001082:	c131                	beqz	a0,800010c6 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001084:	8526                	mv	a0,s1
    80001086:	00000097          	auipc	ra,0x0
    8000108a:	e5c080e7          	jalr	-420(ra) # 80000ee2 <proc_pagetable>
    8000108e:	892a                	mv	s2,a0
    80001090:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001092:	c531                	beqz	a0,800010de <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001094:	07000613          	li	a2,112
    80001098:	4581                	li	a1,0
    8000109a:	06048513          	addi	a0,s1,96
    8000109e:	fffff097          	auipc	ra,0xfffff
    800010a2:	0da080e7          	jalr	218(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010a6:	00000797          	auipc	a5,0x0
    800010aa:	db078793          	addi	a5,a5,-592 # 80000e56 <forkret>
    800010ae:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010b0:	60bc                	ld	a5,64(s1)
    800010b2:	6705                	lui	a4,0x1
    800010b4:	97ba                	add	a5,a5,a4
    800010b6:	f4bc                	sd	a5,104(s1)
}
    800010b8:	8526                	mv	a0,s1
    800010ba:	60e2                	ld	ra,24(sp)
    800010bc:	6442                	ld	s0,16(sp)
    800010be:	64a2                	ld	s1,8(sp)
    800010c0:	6902                	ld	s2,0(sp)
    800010c2:	6105                	addi	sp,sp,32
    800010c4:	8082                	ret
    freeproc(p);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	f08080e7          	jalr	-248(ra) # 80000fd0 <freeproc>
    release(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00005097          	auipc	ra,0x5
    800010d6:	7b4080e7          	jalr	1972(ra) # 80006886 <release>
    return 0;
    800010da:	84ca                	mv	s1,s2
    800010dc:	bff1                	j	800010b8 <allocproc+0x90>
    freeproc(p);
    800010de:	8526                	mv	a0,s1
    800010e0:	00000097          	auipc	ra,0x0
    800010e4:	ef0080e7          	jalr	-272(ra) # 80000fd0 <freeproc>
    release(&p->lock);
    800010e8:	8526                	mv	a0,s1
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	79c080e7          	jalr	1948(ra) # 80006886 <release>
    return 0;
    800010f2:	84ca                	mv	s1,s2
    800010f4:	b7d1                	j	800010b8 <allocproc+0x90>

00000000800010f6 <userinit>:
{
    800010f6:	1101                	addi	sp,sp,-32
    800010f8:	ec06                	sd	ra,24(sp)
    800010fa:	e822                	sd	s0,16(sp)
    800010fc:	e426                	sd	s1,8(sp)
    800010fe:	1000                	addi	s0,sp,32
  p = allocproc();
    80001100:	00000097          	auipc	ra,0x0
    80001104:	f28080e7          	jalr	-216(ra) # 80001028 <allocproc>
    80001108:	84aa                	mv	s1,a0
  initproc = p;
    8000110a:	00008797          	auipc	a5,0x8
    8000110e:	f0a7b323          	sd	a0,-250(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001112:	03400613          	li	a2,52
    80001116:	00007597          	auipc	a1,0x7
    8000111a:	6fa58593          	addi	a1,a1,1786 # 80008810 <initcode>
    8000111e:	6928                	ld	a0,80(a0)
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	6c2080e7          	jalr	1730(ra) # 800007e2 <uvminit>
  p->sz = PGSIZE;
    80001128:	6785                	lui	a5,0x1
    8000112a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000112c:	6cb8                	ld	a4,88(s1)
    8000112e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001132:	6cb8                	ld	a4,88(s1)
    80001134:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001136:	4641                	li	a2,16
    80001138:	00007597          	auipc	a1,0x7
    8000113c:	ff858593          	addi	a1,a1,-8 # 80008130 <etext+0x130>
    80001140:	15848513          	addi	a0,s1,344
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	186080e7          	jalr	390(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000114c:	00007517          	auipc	a0,0x7
    80001150:	ff450513          	addi	a0,a0,-12 # 80008140 <etext+0x140>
    80001154:	00002097          	auipc	ra,0x2
    80001158:	400080e7          	jalr	1024(ra) # 80003554 <namei>
    8000115c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001160:	478d                	li	a5,3
    80001162:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001164:	8526                	mv	a0,s1
    80001166:	00005097          	auipc	ra,0x5
    8000116a:	720080e7          	jalr	1824(ra) # 80006886 <release>
}
    8000116e:	60e2                	ld	ra,24(sp)
    80001170:	6442                	ld	s0,16(sp)
    80001172:	64a2                	ld	s1,8(sp)
    80001174:	6105                	addi	sp,sp,32
    80001176:	8082                	ret

0000000080001178 <growproc>:
{
    80001178:	1101                	addi	sp,sp,-32
    8000117a:	ec06                	sd	ra,24(sp)
    8000117c:	e822                	sd	s0,16(sp)
    8000117e:	e426                	sd	s1,8(sp)
    80001180:	e04a                	sd	s2,0(sp)
    80001182:	1000                	addi	s0,sp,32
    80001184:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	c98080e7          	jalr	-872(ra) # 80000e1e <myproc>
    8000118e:	892a                	mv	s2,a0
  sz = p->sz;
    80001190:	652c                	ld	a1,72(a0)
    80001192:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001196:	00904f63          	bgtz	s1,800011b4 <growproc+0x3c>
  } else if(n < 0){
    8000119a:	0204cc63          	bltz	s1,800011d2 <growproc+0x5a>
  p->sz = sz;
    8000119e:	1602                	slli	a2,a2,0x20
    800011a0:	9201                	srli	a2,a2,0x20
    800011a2:	04c93423          	sd	a2,72(s2)
  return 0;
    800011a6:	4501                	li	a0,0
}
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6902                	ld	s2,0(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011b4:	9e25                	addw	a2,a2,s1
    800011b6:	1602                	slli	a2,a2,0x20
    800011b8:	9201                	srli	a2,a2,0x20
    800011ba:	1582                	slli	a1,a1,0x20
    800011bc:	9181                	srli	a1,a1,0x20
    800011be:	6928                	ld	a0,80(a0)
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	6dc080e7          	jalr	1756(ra) # 8000089c <uvmalloc>
    800011c8:	0005061b          	sext.w	a2,a0
    800011cc:	fa69                	bnez	a2,8000119e <growproc+0x26>
      return -1;
    800011ce:	557d                	li	a0,-1
    800011d0:	bfe1                	j	800011a8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011d2:	9e25                	addw	a2,a2,s1
    800011d4:	1602                	slli	a2,a2,0x20
    800011d6:	9201                	srli	a2,a2,0x20
    800011d8:	1582                	slli	a1,a1,0x20
    800011da:	9181                	srli	a1,a1,0x20
    800011dc:	6928                	ld	a0,80(a0)
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	676080e7          	jalr	1654(ra) # 80000854 <uvmdealloc>
    800011e6:	0005061b          	sext.w	a2,a0
    800011ea:	bf55                	j	8000119e <growproc+0x26>

00000000800011ec <fork>:
{
    800011ec:	7139                	addi	sp,sp,-64
    800011ee:	fc06                	sd	ra,56(sp)
    800011f0:	f822                	sd	s0,48(sp)
    800011f2:	f426                	sd	s1,40(sp)
    800011f4:	f04a                	sd	s2,32(sp)
    800011f6:	ec4e                	sd	s3,24(sp)
    800011f8:	e852                	sd	s4,16(sp)
    800011fa:	e456                	sd	s5,8(sp)
    800011fc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	c20080e7          	jalr	-992(ra) # 80000e1e <myproc>
    80001206:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	e20080e7          	jalr	-480(ra) # 80001028 <allocproc>
    80001210:	14050c63          	beqz	a0,80001368 <fork+0x17c>
    80001214:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001216:	0489b603          	ld	a2,72(s3)
    8000121a:	692c                	ld	a1,80(a0)
    8000121c:	0509b503          	ld	a0,80(s3)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	7c8080e7          	jalr	1992(ra) # 800009e8 <uvmcopy>
    80001228:	04054663          	bltz	a0,80001274 <fork+0x88>
  np->sz = p->sz;
    8000122c:	0489b783          	ld	a5,72(s3)
    80001230:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001234:	0589b683          	ld	a3,88(s3)
    80001238:	87b6                	mv	a5,a3
    8000123a:	058a3703          	ld	a4,88(s4)
    8000123e:	12068693          	addi	a3,a3,288
    80001242:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001246:	6788                	ld	a0,8(a5)
    80001248:	6b8c                	ld	a1,16(a5)
    8000124a:	6f90                	ld	a2,24(a5)
    8000124c:	01073023          	sd	a6,0(a4)
    80001250:	e708                	sd	a0,8(a4)
    80001252:	eb0c                	sd	a1,16(a4)
    80001254:	ef10                	sd	a2,24(a4)
    80001256:	02078793          	addi	a5,a5,32
    8000125a:	02070713          	addi	a4,a4,32
    8000125e:	fed792e3          	bne	a5,a3,80001242 <fork+0x56>
  np->trapframe->a0 = 0;
    80001262:	058a3783          	ld	a5,88(s4)
    80001266:	0607b823          	sd	zero,112(a5)
    8000126a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000126e:	15000913          	li	s2,336
    80001272:	a03d                	j	800012a0 <fork+0xb4>
    freeproc(np);
    80001274:	8552                	mv	a0,s4
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	d5a080e7          	jalr	-678(ra) # 80000fd0 <freeproc>
    release(&np->lock);
    8000127e:	8552                	mv	a0,s4
    80001280:	00005097          	auipc	ra,0x5
    80001284:	606080e7          	jalr	1542(ra) # 80006886 <release>
    return -1;
    80001288:	597d                	li	s2,-1
    8000128a:	a0e9                	j	80001354 <fork+0x168>
      np->ofile[i] = filedup(p->ofile[i]);
    8000128c:	00003097          	auipc	ra,0x3
    80001290:	95e080e7          	jalr	-1698(ra) # 80003bea <filedup>
    80001294:	009a07b3          	add	a5,s4,s1
    80001298:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000129a:	04a1                	addi	s1,s1,8
    8000129c:	01248763          	beq	s1,s2,800012aa <fork+0xbe>
    if(p->ofile[i])
    800012a0:	009987b3          	add	a5,s3,s1
    800012a4:	6388                	ld	a0,0(a5)
    800012a6:	f17d                	bnez	a0,8000128c <fork+0xa0>
    800012a8:	bfcd                	j	8000129a <fork+0xae>
  np->cwd = idup(p->cwd);
    800012aa:	1509b503          	ld	a0,336(s3)
    800012ae:	00002097          	auipc	ra,0x2
    800012b2:	ab2080e7          	jalr	-1358(ra) # 80002d60 <idup>
    800012b6:	14aa3823          	sd	a0,336(s4)
  for (i = 0; i < NVMA; i++) 
    800012ba:	16898493          	addi	s1,s3,360
    800012be:	180a0913          	addi	s2,s4,384
    800012c2:	36898a93          	addi	s5,s3,872
    800012c6:	a03d                	j	800012f4 <fork+0x108>
      np->vma[i] = p->vma[i];
    800012c8:	86be                	mv	a3,a5
    800012ca:	6498                	ld	a4,8(s1)
    800012cc:	689c                	ld	a5,16(s1)
    800012ce:	6c88                	ld	a0,24(s1)
    800012d0:	fed93423          	sd	a3,-24(s2)
    800012d4:	fee93823          	sd	a4,-16(s2)
    800012d8:	fef93c23          	sd	a5,-8(s2)
    800012dc:	00a93023          	sd	a0,0(s2)
      filedup(np->vma[i].f);
    800012e0:	00003097          	auipc	ra,0x3
    800012e4:	90a080e7          	jalr	-1782(ra) # 80003bea <filedup>
  for (i = 0; i < NVMA; i++) 
    800012e8:	02048493          	addi	s1,s1,32
    800012ec:	02090913          	addi	s2,s2,32
    800012f0:	01548563          	beq	s1,s5,800012fa <fork+0x10e>
    if (p->vma[i].addr) {
    800012f4:	609c                	ld	a5,0(s1)
    800012f6:	dbed                	beqz	a5,800012e8 <fork+0xfc>
    800012f8:	bfc1                	j	800012c8 <fork+0xdc>
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012fa:	4641                	li	a2,16
    800012fc:	15898593          	addi	a1,s3,344
    80001300:	158a0513          	addi	a0,s4,344
    80001304:	fffff097          	auipc	ra,0xfffff
    80001308:	fc6080e7          	jalr	-58(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000130c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001310:	8552                	mv	a0,s4
    80001312:	00005097          	auipc	ra,0x5
    80001316:	574080e7          	jalr	1396(ra) # 80006886 <release>
  acquire(&wait_lock);
    8000131a:	00008497          	auipc	s1,0x8
    8000131e:	d4e48493          	addi	s1,s1,-690 # 80009068 <wait_lock>
    80001322:	8526                	mv	a0,s1
    80001324:	00005097          	auipc	ra,0x5
    80001328:	4ae080e7          	jalr	1198(ra) # 800067d2 <acquire>
  np->parent = p;
    8000132c:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    80001330:	8526                	mv	a0,s1
    80001332:	00005097          	auipc	ra,0x5
    80001336:	554080e7          	jalr	1364(ra) # 80006886 <release>
  acquire(&np->lock);
    8000133a:	8552                	mv	a0,s4
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	496080e7          	jalr	1174(ra) # 800067d2 <acquire>
  np->state = RUNNABLE;
    80001344:	478d                	li	a5,3
    80001346:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000134a:	8552                	mv	a0,s4
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	53a080e7          	jalr	1338(ra) # 80006886 <release>
}
    80001354:	854a                	mv	a0,s2
    80001356:	70e2                	ld	ra,56(sp)
    80001358:	7442                	ld	s0,48(sp)
    8000135a:	74a2                	ld	s1,40(sp)
    8000135c:	7902                	ld	s2,32(sp)
    8000135e:	69e2                	ld	s3,24(sp)
    80001360:	6a42                	ld	s4,16(sp)
    80001362:	6aa2                	ld	s5,8(sp)
    80001364:	6121                	addi	sp,sp,64
    80001366:	8082                	ret
    return -1;
    80001368:	597d                	li	s2,-1
    8000136a:	b7ed                	j	80001354 <fork+0x168>

000000008000136c <scheduler>:
{
    8000136c:	7139                	addi	sp,sp,-64
    8000136e:	fc06                	sd	ra,56(sp)
    80001370:	f822                	sd	s0,48(sp)
    80001372:	f426                	sd	s1,40(sp)
    80001374:	f04a                	sd	s2,32(sp)
    80001376:	ec4e                	sd	s3,24(sp)
    80001378:	e852                	sd	s4,16(sp)
    8000137a:	e456                	sd	s5,8(sp)
    8000137c:	e05a                	sd	s6,0(sp)
    8000137e:	0080                	addi	s0,sp,64
    80001380:	8792                	mv	a5,tp
  int id = r_tp();
    80001382:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001384:	00779a93          	slli	s5,a5,0x7
    80001388:	00008717          	auipc	a4,0x8
    8000138c:	cc870713          	addi	a4,a4,-824 # 80009050 <pid_lock>
    80001390:	9756                	add	a4,a4,s5
    80001392:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001396:	00008717          	auipc	a4,0x8
    8000139a:	cf270713          	addi	a4,a4,-782 # 80009088 <cpus+0x8>
    8000139e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013a0:	498d                	li	s3,3
        p->state = RUNNING;
    800013a2:	4b11                	li	s6,4
        c->proc = p;
    800013a4:	079e                	slli	a5,a5,0x7
    800013a6:	00008a17          	auipc	s4,0x8
    800013aa:	caaa0a13          	addi	s4,s4,-854 # 80009050 <pid_lock>
    800013ae:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b0:	00016917          	auipc	s2,0x16
    800013b4:	ad090913          	addi	s2,s2,-1328 # 80016e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013c0:	10079073          	csrw	sstatus,a5
    800013c4:	00008497          	auipc	s1,0x8
    800013c8:	0bc48493          	addi	s1,s1,188 # 80009480 <proc>
    800013cc:	a03d                	j	800013fa <scheduler+0x8e>
        p->state = RUNNING;
    800013ce:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d6:	06048593          	addi	a1,s1,96
    800013da:	8556                	mv	a0,s5
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	7f4080e7          	jalr	2036(ra) # 80001bd0 <swtch>
        c->proc = 0;
    800013e4:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	49c080e7          	jalr	1180(ra) # 80006886 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	36848493          	addi	s1,s1,872
    800013f6:	fd2481e3          	beq	s1,s2,800013b8 <scheduler+0x4c>
      acquire(&p->lock);
    800013fa:	8526                	mv	a0,s1
    800013fc:	00005097          	auipc	ra,0x5
    80001400:	3d6080e7          	jalr	982(ra) # 800067d2 <acquire>
      if(p->state == RUNNABLE) {
    80001404:	4c9c                	lw	a5,24(s1)
    80001406:	ff3791e3          	bne	a5,s3,800013e8 <scheduler+0x7c>
    8000140a:	b7d1                	j	800013ce <scheduler+0x62>

000000008000140c <sched>:
{
    8000140c:	7179                	addi	sp,sp,-48
    8000140e:	f406                	sd	ra,40(sp)
    80001410:	f022                	sd	s0,32(sp)
    80001412:	ec26                	sd	s1,24(sp)
    80001414:	e84a                	sd	s2,16(sp)
    80001416:	e44e                	sd	s3,8(sp)
    80001418:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	a04080e7          	jalr	-1532(ra) # 80000e1e <myproc>
    80001422:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001424:	00005097          	auipc	ra,0x5
    80001428:	334080e7          	jalr	820(ra) # 80006758 <holding>
    8000142c:	c93d                	beqz	a0,800014a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000142e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001430:	2781                	sext.w	a5,a5
    80001432:	079e                	slli	a5,a5,0x7
    80001434:	00008717          	auipc	a4,0x8
    80001438:	c1c70713          	addi	a4,a4,-996 # 80009050 <pid_lock>
    8000143c:	97ba                	add	a5,a5,a4
    8000143e:	0a87a703          	lw	a4,168(a5)
    80001442:	4785                	li	a5,1
    80001444:	06f71763          	bne	a4,a5,800014b2 <sched+0xa6>
  if(p->state == RUNNING)
    80001448:	4c98                	lw	a4,24(s1)
    8000144a:	4791                	li	a5,4
    8000144c:	06f70b63          	beq	a4,a5,800014c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001450:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001454:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001456:	efb5                	bnez	a5,800014d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001458:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000145a:	00008917          	auipc	s2,0x8
    8000145e:	bf690913          	addi	s2,s2,-1034 # 80009050 <pid_lock>
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	97ca                	add	a5,a5,s2
    80001468:	0ac7a983          	lw	s3,172(a5)
    8000146c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	00008597          	auipc	a1,0x8
    80001476:	c1658593          	addi	a1,a1,-1002 # 80009088 <cpus+0x8>
    8000147a:	95be                	add	a1,a1,a5
    8000147c:	06048513          	addi	a0,s1,96
    80001480:	00000097          	auipc	ra,0x0
    80001484:	750080e7          	jalr	1872(ra) # 80001bd0 <swtch>
    80001488:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	97ca                	add	a5,a5,s2
    80001490:	0b37a623          	sw	s3,172(a5)
}
    80001494:	70a2                	ld	ra,40(sp)
    80001496:	7402                	ld	s0,32(sp)
    80001498:	64e2                	ld	s1,24(sp)
    8000149a:	6942                	ld	s2,16(sp)
    8000149c:	69a2                	ld	s3,8(sp)
    8000149e:	6145                	addi	sp,sp,48
    800014a0:	8082                	ret
    panic("sched p->lock");
    800014a2:	00007517          	auipc	a0,0x7
    800014a6:	ca650513          	addi	a0,a0,-858 # 80008148 <etext+0x148>
    800014aa:	00005097          	auipc	ra,0x5
    800014ae:	dde080e7          	jalr	-546(ra) # 80006288 <panic>
    panic("sched locks");
    800014b2:	00007517          	auipc	a0,0x7
    800014b6:	ca650513          	addi	a0,a0,-858 # 80008158 <etext+0x158>
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	dce080e7          	jalr	-562(ra) # 80006288 <panic>
    panic("sched running");
    800014c2:	00007517          	auipc	a0,0x7
    800014c6:	ca650513          	addi	a0,a0,-858 # 80008168 <etext+0x168>
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	dbe080e7          	jalr	-578(ra) # 80006288 <panic>
    panic("sched interruptible");
    800014d2:	00007517          	auipc	a0,0x7
    800014d6:	ca650513          	addi	a0,a0,-858 # 80008178 <etext+0x178>
    800014da:	00005097          	auipc	ra,0x5
    800014de:	dae080e7          	jalr	-594(ra) # 80006288 <panic>

00000000800014e2 <yield>:
{
    800014e2:	1101                	addi	sp,sp,-32
    800014e4:	ec06                	sd	ra,24(sp)
    800014e6:	e822                	sd	s0,16(sp)
    800014e8:	e426                	sd	s1,8(sp)
    800014ea:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	932080e7          	jalr	-1742(ra) # 80000e1e <myproc>
    800014f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	2dc080e7          	jalr	732(ra) # 800067d2 <acquire>
  p->state = RUNNABLE;
    800014fe:	478d                	li	a5,3
    80001500:	cc9c                	sw	a5,24(s1)
  sched();
    80001502:	00000097          	auipc	ra,0x0
    80001506:	f0a080e7          	jalr	-246(ra) # 8000140c <sched>
  release(&p->lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	37a080e7          	jalr	890(ra) # 80006886 <release>
}
    80001514:	60e2                	ld	ra,24(sp)
    80001516:	6442                	ld	s0,16(sp)
    80001518:	64a2                	ld	s1,8(sp)
    8000151a:	6105                	addi	sp,sp,32
    8000151c:	8082                	ret

000000008000151e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000151e:	7179                	addi	sp,sp,-48
    80001520:	f406                	sd	ra,40(sp)
    80001522:	f022                	sd	s0,32(sp)
    80001524:	ec26                	sd	s1,24(sp)
    80001526:	e84a                	sd	s2,16(sp)
    80001528:	e44e                	sd	s3,8(sp)
    8000152a:	1800                	addi	s0,sp,48
    8000152c:	89aa                	mv	s3,a0
    8000152e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	8ee080e7          	jalr	-1810(ra) # 80000e1e <myproc>
    80001538:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	298080e7          	jalr	664(ra) # 800067d2 <acquire>
  release(lk);
    80001542:	854a                	mv	a0,s2
    80001544:	00005097          	auipc	ra,0x5
    80001548:	342080e7          	jalr	834(ra) # 80006886 <release>

  // Go to sleep.
  p->chan = chan;
    8000154c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001550:	4789                	li	a5,2
    80001552:	cc9c                	sw	a5,24(s1)

  sched();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	eb8080e7          	jalr	-328(ra) # 8000140c <sched>

  // Tidy up.
  p->chan = 0;
    8000155c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	324080e7          	jalr	804(ra) # 80006886 <release>
  acquire(lk);
    8000156a:	854a                	mv	a0,s2
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	266080e7          	jalr	614(ra) # 800067d2 <acquire>
}
    80001574:	70a2                	ld	ra,40(sp)
    80001576:	7402                	ld	s0,32(sp)
    80001578:	64e2                	ld	s1,24(sp)
    8000157a:	6942                	ld	s2,16(sp)
    8000157c:	69a2                	ld	s3,8(sp)
    8000157e:	6145                	addi	sp,sp,48
    80001580:	8082                	ret

0000000080001582 <wait>:
{
    80001582:	715d                	addi	sp,sp,-80
    80001584:	e486                	sd	ra,72(sp)
    80001586:	e0a2                	sd	s0,64(sp)
    80001588:	fc26                	sd	s1,56(sp)
    8000158a:	f84a                	sd	s2,48(sp)
    8000158c:	f44e                	sd	s3,40(sp)
    8000158e:	f052                	sd	s4,32(sp)
    80001590:	ec56                	sd	s5,24(sp)
    80001592:	e85a                	sd	s6,16(sp)
    80001594:	e45e                	sd	s7,8(sp)
    80001596:	e062                	sd	s8,0(sp)
    80001598:	0880                	addi	s0,sp,80
    8000159a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	882080e7          	jalr	-1918(ra) # 80000e1e <myproc>
    800015a4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015a6:	00008517          	auipc	a0,0x8
    800015aa:	ac250513          	addi	a0,a0,-1342 # 80009068 <wait_lock>
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	224080e7          	jalr	548(ra) # 800067d2 <acquire>
    havekids = 0;
    800015b6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015b8:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015ba:	00016997          	auipc	s3,0x16
    800015be:	8c698993          	addi	s3,s3,-1850 # 80016e80 <tickslock>
        havekids = 1;
    800015c2:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c4:	00008c17          	auipc	s8,0x8
    800015c8:	aa4c0c13          	addi	s8,s8,-1372 # 80009068 <wait_lock>
    havekids = 0;
    800015cc:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015ce:	00008497          	auipc	s1,0x8
    800015d2:	eb248493          	addi	s1,s1,-334 # 80009480 <proc>
    800015d6:	a0bd                	j	80001644 <wait+0xc2>
          pid = np->pid;
    800015d8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015dc:	000b0e63          	beqz	s6,800015f8 <wait+0x76>
    800015e0:	4691                	li	a3,4
    800015e2:	02c48613          	addi	a2,s1,44
    800015e6:	85da                	mv	a1,s6
    800015e8:	05093503          	ld	a0,80(s2)
    800015ec:	fffff097          	auipc	ra,0xfffff
    800015f0:	4f4080e7          	jalr	1268(ra) # 80000ae0 <copyout>
    800015f4:	02054563          	bltz	a0,8000161e <wait+0x9c>
          freeproc(np);
    800015f8:	8526                	mv	a0,s1
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	9d6080e7          	jalr	-1578(ra) # 80000fd0 <freeproc>
          release(&np->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	282080e7          	jalr	642(ra) # 80006886 <release>
          release(&wait_lock);
    8000160c:	00008517          	auipc	a0,0x8
    80001610:	a5c50513          	addi	a0,a0,-1444 # 80009068 <wait_lock>
    80001614:	00005097          	auipc	ra,0x5
    80001618:	272080e7          	jalr	626(ra) # 80006886 <release>
          return pid;
    8000161c:	a09d                	j	80001682 <wait+0x100>
            release(&np->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	00005097          	auipc	ra,0x5
    80001624:	266080e7          	jalr	614(ra) # 80006886 <release>
            release(&wait_lock);
    80001628:	00008517          	auipc	a0,0x8
    8000162c:	a4050513          	addi	a0,a0,-1472 # 80009068 <wait_lock>
    80001630:	00005097          	auipc	ra,0x5
    80001634:	256080e7          	jalr	598(ra) # 80006886 <release>
            return -1;
    80001638:	59fd                	li	s3,-1
    8000163a:	a0a1                	j	80001682 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000163c:	36848493          	addi	s1,s1,872
    80001640:	03348463          	beq	s1,s3,80001668 <wait+0xe6>
      if(np->parent == p){
    80001644:	7c9c                	ld	a5,56(s1)
    80001646:	ff279be3          	bne	a5,s2,8000163c <wait+0xba>
        acquire(&np->lock);
    8000164a:	8526                	mv	a0,s1
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	186080e7          	jalr	390(ra) # 800067d2 <acquire>
        if(np->state == ZOMBIE){
    80001654:	4c9c                	lw	a5,24(s1)
    80001656:	f94781e3          	beq	a5,s4,800015d8 <wait+0x56>
        release(&np->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	22a080e7          	jalr	554(ra) # 80006886 <release>
        havekids = 1;
    80001664:	8756                	mv	a4,s5
    80001666:	bfd9                	j	8000163c <wait+0xba>
    if(!havekids || p->killed){
    80001668:	c701                	beqz	a4,80001670 <wait+0xee>
    8000166a:	02892783          	lw	a5,40(s2)
    8000166e:	c79d                	beqz	a5,8000169c <wait+0x11a>
      release(&wait_lock);
    80001670:	00008517          	auipc	a0,0x8
    80001674:	9f850513          	addi	a0,a0,-1544 # 80009068 <wait_lock>
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	20e080e7          	jalr	526(ra) # 80006886 <release>
      return -1;
    80001680:	59fd                	li	s3,-1
}
    80001682:	854e                	mv	a0,s3
    80001684:	60a6                	ld	ra,72(sp)
    80001686:	6406                	ld	s0,64(sp)
    80001688:	74e2                	ld	s1,56(sp)
    8000168a:	7942                	ld	s2,48(sp)
    8000168c:	79a2                	ld	s3,40(sp)
    8000168e:	7a02                	ld	s4,32(sp)
    80001690:	6ae2                	ld	s5,24(sp)
    80001692:	6b42                	ld	s6,16(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	6c02                	ld	s8,0(sp)
    80001698:	6161                	addi	sp,sp,80
    8000169a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000169c:	85e2                	mv	a1,s8
    8000169e:	854a                	mv	a0,s2
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	e7e080e7          	jalr	-386(ra) # 8000151e <sleep>
    havekids = 0;
    800016a8:	b715                	j	800015cc <wait+0x4a>

00000000800016aa <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016aa:	7139                	addi	sp,sp,-64
    800016ac:	fc06                	sd	ra,56(sp)
    800016ae:	f822                	sd	s0,48(sp)
    800016b0:	f426                	sd	s1,40(sp)
    800016b2:	f04a                	sd	s2,32(sp)
    800016b4:	ec4e                	sd	s3,24(sp)
    800016b6:	e852                	sd	s4,16(sp)
    800016b8:	e456                	sd	s5,8(sp)
    800016ba:	0080                	addi	s0,sp,64
    800016bc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016be:	00008497          	auipc	s1,0x8
    800016c2:	dc248493          	addi	s1,s1,-574 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016c6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016c8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ca:	00015917          	auipc	s2,0x15
    800016ce:	7b690913          	addi	s2,s2,1974 # 80016e80 <tickslock>
    800016d2:	a821                	j	800016ea <wakeup+0x40>
        p->state = RUNNABLE;
    800016d4:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016d8:	8526                	mv	a0,s1
    800016da:	00005097          	auipc	ra,0x5
    800016de:	1ac080e7          	jalr	428(ra) # 80006886 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e2:	36848493          	addi	s1,s1,872
    800016e6:	03248463          	beq	s1,s2,8000170e <wakeup+0x64>
    if(p != myproc()){
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	734080e7          	jalr	1844(ra) # 80000e1e <myproc>
    800016f2:	fea488e3          	beq	s1,a0,800016e2 <wakeup+0x38>
      acquire(&p->lock);
    800016f6:	8526                	mv	a0,s1
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	0da080e7          	jalr	218(ra) # 800067d2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001700:	4c9c                	lw	a5,24(s1)
    80001702:	fd379be3          	bne	a5,s3,800016d8 <wakeup+0x2e>
    80001706:	709c                	ld	a5,32(s1)
    80001708:	fd4798e3          	bne	a5,s4,800016d8 <wakeup+0x2e>
    8000170c:	b7e1                	j	800016d4 <wakeup+0x2a>
    }
  }
}
    8000170e:	70e2                	ld	ra,56(sp)
    80001710:	7442                	ld	s0,48(sp)
    80001712:	74a2                	ld	s1,40(sp)
    80001714:	7902                	ld	s2,32(sp)
    80001716:	69e2                	ld	s3,24(sp)
    80001718:	6a42                	ld	s4,16(sp)
    8000171a:	6aa2                	ld	s5,8(sp)
    8000171c:	6121                	addi	sp,sp,64
    8000171e:	8082                	ret

0000000080001720 <reparent>:
{
    80001720:	7179                	addi	sp,sp,-48
    80001722:	f406                	sd	ra,40(sp)
    80001724:	f022                	sd	s0,32(sp)
    80001726:	ec26                	sd	s1,24(sp)
    80001728:	e84a                	sd	s2,16(sp)
    8000172a:	e44e                	sd	s3,8(sp)
    8000172c:	e052                	sd	s4,0(sp)
    8000172e:	1800                	addi	s0,sp,48
    80001730:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001732:	00008497          	auipc	s1,0x8
    80001736:	d4e48493          	addi	s1,s1,-690 # 80009480 <proc>
      pp->parent = initproc;
    8000173a:	00008a17          	auipc	s4,0x8
    8000173e:	8d6a0a13          	addi	s4,s4,-1834 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001742:	00015997          	auipc	s3,0x15
    80001746:	73e98993          	addi	s3,s3,1854 # 80016e80 <tickslock>
    8000174a:	a029                	j	80001754 <reparent+0x34>
    8000174c:	36848493          	addi	s1,s1,872
    80001750:	01348d63          	beq	s1,s3,8000176a <reparent+0x4a>
    if(pp->parent == p){
    80001754:	7c9c                	ld	a5,56(s1)
    80001756:	ff279be3          	bne	a5,s2,8000174c <reparent+0x2c>
      pp->parent = initproc;
    8000175a:	000a3503          	ld	a0,0(s4)
    8000175e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001760:	00000097          	auipc	ra,0x0
    80001764:	f4a080e7          	jalr	-182(ra) # 800016aa <wakeup>
    80001768:	b7d5                	j	8000174c <reparent+0x2c>
}
    8000176a:	70a2                	ld	ra,40(sp)
    8000176c:	7402                	ld	s0,32(sp)
    8000176e:	64e2                	ld	s1,24(sp)
    80001770:	6942                	ld	s2,16(sp)
    80001772:	69a2                	ld	s3,8(sp)
    80001774:	6a02                	ld	s4,0(sp)
    80001776:	6145                	addi	sp,sp,48
    80001778:	8082                	ret

000000008000177a <exit>:
{
    8000177a:	7135                	addi	sp,sp,-160
    8000177c:	ed06                	sd	ra,152(sp)
    8000177e:	e922                	sd	s0,144(sp)
    80001780:	e526                	sd	s1,136(sp)
    80001782:	e14a                	sd	s2,128(sp)
    80001784:	fcce                	sd	s3,120(sp)
    80001786:	f8d2                	sd	s4,112(sp)
    80001788:	f4d6                	sd	s5,104(sp)
    8000178a:	f0da                	sd	s6,96(sp)
    8000178c:	ecde                	sd	s7,88(sp)
    8000178e:	e8e2                	sd	s8,80(sp)
    80001790:	e4e6                	sd	s9,72(sp)
    80001792:	e0ea                	sd	s10,64(sp)
    80001794:	fc6e                	sd	s11,56(sp)
    80001796:	1100                	addi	s0,sp,160
    80001798:	f6a43423          	sd	a0,-152(s0)
  struct proc *p = myproc();
    8000179c:	fffff097          	auipc	ra,0xfffff
    800017a0:	682080e7          	jalr	1666(ra) # 80000e1e <myproc>
    800017a4:	f6a43c23          	sd	a0,-136(s0)
  if(p == initproc)
    800017a8:	00008797          	auipc	a5,0x8
    800017ac:	8687b783          	ld	a5,-1944(a5) # 80009010 <initproc>
    800017b0:	f8043023          	sd	zero,-128(s0)
    800017b4:	00a78c63          	beq	a5,a0,800017cc <exit+0x52>
    800017b8:	16850c93          	addi	s9,a0,360
          size=min(maxsize,range-i);
    800017bc:	6785                	lui	a5,0x1
    800017be:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
    800017c2:	c007879b          	addiw	a5,a5,-1024
    800017c6:	f8f42423          	sw	a5,-120(s0)
    800017ca:	a285                	j	8000192a <exit+0x1b0>
    panic("init exiting");
    800017cc:	00007517          	auipc	a0,0x7
    800017d0:	9c450513          	addi	a0,a0,-1596 # 80008190 <etext+0x190>
    800017d4:	00005097          	auipc	ra,0x5
    800017d8:	ab4080e7          	jalr	-1356(ra) # 80006288 <panic>
          size=min(maxsize,range-i);
    800017dc:	0009891b          	sext.w	s2,s3
          begin_op();
    800017e0:	00002097          	auipc	ra,0x2
    800017e4:	f90080e7          	jalr	-112(ra) # 80003770 <begin_op>
          ilock(vma->f->ip);
    800017e8:	6c9c                	ld	a5,24(s1)
    800017ea:	6f88                	ld	a0,24(a5)
    800017ec:	00001097          	auipc	ra,0x1
    800017f0:	5b2080e7          	jalr	1458(ra) # 80002d9e <ilock>
          if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size)
    800017f4:	48d4                	lw	a3,20(s1)
    800017f6:	017686bb          	addw	a3,a3,s7
    800017fa:	609c                	ld	a5,0(s1)
    800017fc:	9e9d                	subw	a3,a3,a5
    800017fe:	6c9c                	ld	a5,24(s1)
    80001800:	874a                	mv	a4,s2
    80001802:	015686bb          	addw	a3,a3,s5
    80001806:	8662                	mv	a2,s8
    80001808:	4585                	li	a1,1
    8000180a:	6f88                	ld	a0,24(a5)
    8000180c:	00002097          	auipc	ra,0x2
    80001810:	93e080e7          	jalr	-1730(ra) # 8000314a <writei>
    80001814:	2501                	sext.w	a0,a0
    80001816:	03251763          	bne	a0,s2,80001844 <exit+0xca>
          iunlock(vma->f->ip);
    8000181a:	6c9c                	ld	a5,24(s1)
    8000181c:	6f88                	ld	a0,24(a5)
    8000181e:	00001097          	auipc	ra,0x1
    80001822:	642080e7          	jalr	1602(ra) # 80002e60 <iunlock>
          end_op();
    80001826:	00002097          	auipc	ra,0x2
    8000182a:	fca080e7          	jalr	-54(ra) # 800037f0 <end_op>
        for(int r=0;r<range;r+=size){
    8000182e:	01498a3b          	addw	s4,s3,s4
    80001832:	056a7363          	bgeu	s4,s6,80001878 <exit+0xfe>
          size=min(maxsize,range-i);
    80001836:	f8c42983          	lw	s3,-116(s0)
    8000183a:	fbadf1e3          	bgeu	s11,s10,800017dc <exit+0x62>
    8000183e:	f8842983          	lw	s3,-120(s0)
    80001842:	bf69                	j	800017dc <exit+0x62>
            iunlock(vma->f->ip);
    80001844:	f7043783          	ld	a5,-144(s0)
    80001848:	00579513          	slli	a0,a5,0x5
    8000184c:	f7843783          	ld	a5,-136(s0)
    80001850:	953e                	add	a0,a0,a5
    80001852:	18053783          	ld	a5,384(a0)
    80001856:	6f88                	ld	a0,24(a5)
    80001858:	00001097          	auipc	ra,0x1
    8000185c:	608080e7          	jalr	1544(ra) # 80002e60 <iunlock>
            end_op();
    80001860:	00002097          	auipc	ra,0x2
    80001864:	f90080e7          	jalr	-112(ra) # 800037f0 <end_op>
            panic("exit: writei failed");
    80001868:	00007517          	auipc	a0,0x7
    8000186c:	93850513          	addi	a0,a0,-1736 # 800081a0 <etext+0x1a0>
    80001870:	00005097          	auipc	ra,0x5
    80001874:	a18080e7          	jalr	-1512(ra) # 80006288 <panic>
      for(uint64 va = vma->addr;va<vma->addr+vma->len;va+=PGSIZE){
    80001878:	6785                	lui	a5,0x1
    8000187a:	9abe                	add	s5,s5,a5
    8000187c:	9c3e                	add	s8,s8,a5
    8000187e:	449c                	lw	a5,8(s1)
    80001880:	6098                	ld	a4,0(s1)
    80001882:	97ba                	add	a5,a5,a4
    80001884:	04faf563          	bgeu	s5,a5,800018ce <exit+0x154>
        pte_t* pte = walk(p->pagetable,va,0);
    80001888:	4601                	li	a2,0
    8000188a:	85d6                	mv	a1,s5
    8000188c:	f7843783          	ld	a5,-136(s0)
    80001890:	6ba8                	ld	a0,80(a5)
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	bce080e7          	jalr	-1074(ra) # 80000460 <walk>
        if(pte==0 || (*pte & PTE_D)==0)
    8000189a:	dd79                	beqz	a0,80001878 <exit+0xfe>
    8000189c:	611c                	ld	a5,0(a0)
    8000189e:	0807f793          	andi	a5,a5,128
    800018a2:	dbf9                	beqz	a5,80001878 <exit+0xfe>
        range = min(vma->addr+vma->len-va,PGSIZE);
    800018a4:	0084ab03          	lw	s6,8(s1)
    800018a8:	609c                	ld	a5,0(s1)
    800018aa:	9b3e                	add	s6,s6,a5
    800018ac:	415b0b33          	sub	s6,s6,s5
    800018b0:	6785                	lui	a5,0x1
    800018b2:	0167f363          	bgeu	a5,s6,800018b8 <exit+0x13e>
    800018b6:	6b05                	lui	s6,0x1
    800018b8:	2b01                	sext.w	s6,s6
        for(int r=0;r<range;r+=size){
    800018ba:	fa0b0fe3          	beqz	s6,80001878 <exit+0xfe>
    800018be:	4a01                	li	s4,0
          size=min(maxsize,range-i);
    800018c0:	417b07bb          	subw	a5,s6,s7
    800018c4:	f8f42623          	sw	a5,-116(s0)
    800018c8:	00078d1b          	sext.w	s10,a5
    800018cc:	b7ad                	j	80001836 <exit+0xbc>
    uvmunmap(p->pagetable, vma->addr, (vma->len - 1) / PGSIZE + 1, 1);
    800018ce:	4490                	lw	a2,8(s1)
    800018d0:	fff6079b          	addiw	a5,a2,-1
    800018d4:	41f7d61b          	sraiw	a2,a5,0x1f
    800018d8:	0146561b          	srliw	a2,a2,0x14
    800018dc:	9e3d                	addw	a2,a2,a5
    800018de:	40c6561b          	sraiw	a2,a2,0xc
    800018e2:	4685                	li	a3,1
    800018e4:	2605                	addiw	a2,a2,1
    800018e6:	608c                	ld	a1,0(s1)
    800018e8:	f7843783          	ld	a5,-136(s0)
    800018ec:	6ba8                	ld	a0,80(a5)
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	e20080e7          	jalr	-480(ra) # 8000070e <uvmunmap>
    vma->addr = 0;
    800018f6:	0004b023          	sd	zero,0(s1)
    vma->len = 0;
    800018fa:	0004a423          	sw	zero,8(s1)
    vma->offset = 0;
    800018fe:	0004aa23          	sw	zero,20(s1)
    vma->flags = 0;
    80001902:	0004a823          	sw	zero,16(s1)
    fileclose(vma->f);
    80001906:	6c88                	ld	a0,24(s1)
    80001908:	00002097          	auipc	ra,0x2
    8000190c:	334080e7          	jalr	820(ra) # 80003c3c <fileclose>
    vma->f = 0;
    80001910:	0004bc23          	sd	zero,24(s1)
  for(int i=0;i<NVMA;i++)
    80001914:	f8043783          	ld	a5,-128(s0)
    80001918:	0785                	addi	a5,a5,1
    8000191a:	873e                	mv	a4,a5
    8000191c:	f8f43023          	sd	a5,-128(s0)
    80001920:	020c8c93          	addi	s9,s9,32
    80001924:	47c1                	li	a5,16
    80001926:	02f70963          	beq	a4,a5,80001958 <exit+0x1de>
    8000192a:	f8043683          	ld	a3,-128(s0)
    8000192e:	00068b9b          	sext.w	s7,a3
    80001932:	f7743823          	sd	s7,-144(s0)
    if(p->vma[i].addr==0)
    80001936:	84e6                	mv	s1,s9
    80001938:	000cba83          	ld	s5,0(s9)
    8000193c:	fc0a8ce3          	beqz	s5,80001914 <exit+0x19a>
    if(vma->flags & MAP_SHARED){
    80001940:	010ca783          	lw	a5,16(s9)
    80001944:	8b85                	andi	a5,a5,1
    80001946:	d7c1                	beqz	a5,800018ce <exit+0x154>
      for(uint64 va = vma->addr;va<vma->addr+vma->len;va+=PGSIZE){
    80001948:	008ca783          	lw	a5,8(s9)
    8000194c:	97d6                	add	a5,a5,s5
    8000194e:	f8faf0e3          	bgeu	s5,a5,800018ce <exit+0x154>
    80001952:	00da8c33          	add	s8,s5,a3
    80001956:	bf0d                	j	80001888 <exit+0x10e>
    80001958:	f7843783          	ld	a5,-136(s0)
    8000195c:	0d078493          	addi	s1,a5,208 # 10d0 <_entry-0x7fffef30>
    80001960:	15078913          	addi	s2,a5,336
    80001964:	a021                	j	8000196c <exit+0x1f2>
  for(int fd = 0; fd < NOFILE; fd++){
    80001966:	04a1                	addi	s1,s1,8
    80001968:	00990b63          	beq	s2,s1,8000197e <exit+0x204>
    if(p->ofile[fd]){
    8000196c:	6088                	ld	a0,0(s1)
    8000196e:	dd65                	beqz	a0,80001966 <exit+0x1ec>
      fileclose(f);
    80001970:	00002097          	auipc	ra,0x2
    80001974:	2cc080e7          	jalr	716(ra) # 80003c3c <fileclose>
      p->ofile[fd] = 0;
    80001978:	0004b023          	sd	zero,0(s1)
    8000197c:	b7ed                	j	80001966 <exit+0x1ec>
  begin_op();
    8000197e:	00002097          	auipc	ra,0x2
    80001982:	df2080e7          	jalr	-526(ra) # 80003770 <begin_op>
  iput(p->cwd);
    80001986:	f7843903          	ld	s2,-136(s0)
    8000198a:	15093503          	ld	a0,336(s2)
    8000198e:	00001097          	auipc	ra,0x1
    80001992:	5ca080e7          	jalr	1482(ra) # 80002f58 <iput>
  end_op();
    80001996:	00002097          	auipc	ra,0x2
    8000199a:	e5a080e7          	jalr	-422(ra) # 800037f0 <end_op>
  p->cwd = 0;
    8000199e:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800019a2:	00007497          	auipc	s1,0x7
    800019a6:	6c648493          	addi	s1,s1,1734 # 80009068 <wait_lock>
    800019aa:	8526                	mv	a0,s1
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	e26080e7          	jalr	-474(ra) # 800067d2 <acquire>
  reparent(p);
    800019b4:	854a                	mv	a0,s2
    800019b6:	00000097          	auipc	ra,0x0
    800019ba:	d6a080e7          	jalr	-662(ra) # 80001720 <reparent>
  wakeup(p->parent);
    800019be:	03893503          	ld	a0,56(s2)
    800019c2:	00000097          	auipc	ra,0x0
    800019c6:	ce8080e7          	jalr	-792(ra) # 800016aa <wakeup>
  acquire(&p->lock);
    800019ca:	854a                	mv	a0,s2
    800019cc:	00005097          	auipc	ra,0x5
    800019d0:	e06080e7          	jalr	-506(ra) # 800067d2 <acquire>
  p->xstate = status;
    800019d4:	f6843783          	ld	a5,-152(s0)
    800019d8:	02f92623          	sw	a5,44(s2)
  p->state = ZOMBIE;
    800019dc:	4795                	li	a5,5
    800019de:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	ea2080e7          	jalr	-350(ra) # 80006886 <release>
  sched();
    800019ec:	00000097          	auipc	ra,0x0
    800019f0:	a20080e7          	jalr	-1504(ra) # 8000140c <sched>
  panic("zombie exit");
    800019f4:	00006517          	auipc	a0,0x6
    800019f8:	7c450513          	addi	a0,a0,1988 # 800081b8 <etext+0x1b8>
    800019fc:	00005097          	auipc	ra,0x5
    80001a00:	88c080e7          	jalr	-1908(ra) # 80006288 <panic>

0000000080001a04 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a04:	7179                	addi	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	1800                	addi	s0,sp,48
    80001a12:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a14:	00008497          	auipc	s1,0x8
    80001a18:	a6c48493          	addi	s1,s1,-1428 # 80009480 <proc>
    80001a1c:	00015997          	auipc	s3,0x15
    80001a20:	46498993          	addi	s3,s3,1124 # 80016e80 <tickslock>
    acquire(&p->lock);
    80001a24:	8526                	mv	a0,s1
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	dac080e7          	jalr	-596(ra) # 800067d2 <acquire>
    if(p->pid == pid){
    80001a2e:	589c                	lw	a5,48(s1)
    80001a30:	01278d63          	beq	a5,s2,80001a4a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a34:	8526                	mv	a0,s1
    80001a36:	00005097          	auipc	ra,0x5
    80001a3a:	e50080e7          	jalr	-432(ra) # 80006886 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3e:	36848493          	addi	s1,s1,872
    80001a42:	ff3491e3          	bne	s1,s3,80001a24 <kill+0x20>
  }
  return -1;
    80001a46:	557d                	li	a0,-1
    80001a48:	a829                	j	80001a62 <kill+0x5e>
      p->killed = 1;
    80001a4a:	4785                	li	a5,1
    80001a4c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a4e:	4c98                	lw	a4,24(s1)
    80001a50:	4789                	li	a5,2
    80001a52:	00f70f63          	beq	a4,a5,80001a70 <kill+0x6c>
      release(&p->lock);
    80001a56:	8526                	mv	a0,s1
    80001a58:	00005097          	auipc	ra,0x5
    80001a5c:	e2e080e7          	jalr	-466(ra) # 80006886 <release>
      return 0;
    80001a60:	4501                	li	a0,0
}
    80001a62:	70a2                	ld	ra,40(sp)
    80001a64:	7402                	ld	s0,32(sp)
    80001a66:	64e2                	ld	s1,24(sp)
    80001a68:	6942                	ld	s2,16(sp)
    80001a6a:	69a2                	ld	s3,8(sp)
    80001a6c:	6145                	addi	sp,sp,48
    80001a6e:	8082                	ret
        p->state = RUNNABLE;
    80001a70:	478d                	li	a5,3
    80001a72:	cc9c                	sw	a5,24(s1)
    80001a74:	b7cd                	j	80001a56 <kill+0x52>

0000000080001a76 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a76:	7179                	addi	sp,sp,-48
    80001a78:	f406                	sd	ra,40(sp)
    80001a7a:	f022                	sd	s0,32(sp)
    80001a7c:	ec26                	sd	s1,24(sp)
    80001a7e:	e84a                	sd	s2,16(sp)
    80001a80:	e44e                	sd	s3,8(sp)
    80001a82:	e052                	sd	s4,0(sp)
    80001a84:	1800                	addi	s0,sp,48
    80001a86:	84aa                	mv	s1,a0
    80001a88:	892e                	mv	s2,a1
    80001a8a:	89b2                	mv	s3,a2
    80001a8c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	390080e7          	jalr	912(ra) # 80000e1e <myproc>
  if(user_dst){
    80001a96:	c08d                	beqz	s1,80001ab8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a98:	86d2                	mv	a3,s4
    80001a9a:	864e                	mv	a2,s3
    80001a9c:	85ca                	mv	a1,s2
    80001a9e:	6928                	ld	a0,80(a0)
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	040080e7          	jalr	64(ra) # 80000ae0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa8:	70a2                	ld	ra,40(sp)
    80001aaa:	7402                	ld	s0,32(sp)
    80001aac:	64e2                	ld	s1,24(sp)
    80001aae:	6942                	ld	s2,16(sp)
    80001ab0:	69a2                	ld	s3,8(sp)
    80001ab2:	6a02                	ld	s4,0(sp)
    80001ab4:	6145                	addi	sp,sp,48
    80001ab6:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab8:	000a061b          	sext.w	a2,s4
    80001abc:	85ce                	mv	a1,s3
    80001abe:	854a                	mv	a0,s2
    80001ac0:	ffffe097          	auipc	ra,0xffffe
    80001ac4:	718080e7          	jalr	1816(ra) # 800001d8 <memmove>
    return 0;
    80001ac8:	8526                	mv	a0,s1
    80001aca:	bff9                	j	80001aa8 <either_copyout+0x32>

0000000080001acc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001acc:	7179                	addi	sp,sp,-48
    80001ace:	f406                	sd	ra,40(sp)
    80001ad0:	f022                	sd	s0,32(sp)
    80001ad2:	ec26                	sd	s1,24(sp)
    80001ad4:	e84a                	sd	s2,16(sp)
    80001ad6:	e44e                	sd	s3,8(sp)
    80001ad8:	e052                	sd	s4,0(sp)
    80001ada:	1800                	addi	s0,sp,48
    80001adc:	892a                	mv	s2,a0
    80001ade:	84ae                	mv	s1,a1
    80001ae0:	89b2                	mv	s3,a2
    80001ae2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	33a080e7          	jalr	826(ra) # 80000e1e <myproc>
  if(user_src){
    80001aec:	c08d                	beqz	s1,80001b0e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aee:	86d2                	mv	a3,s4
    80001af0:	864e                	mv	a2,s3
    80001af2:	85ca                	mv	a1,s2
    80001af4:	6928                	ld	a0,80(a0)
    80001af6:	fffff097          	auipc	ra,0xfffff
    80001afa:	076080e7          	jalr	118(ra) # 80000b6c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001afe:	70a2                	ld	ra,40(sp)
    80001b00:	7402                	ld	s0,32(sp)
    80001b02:	64e2                	ld	s1,24(sp)
    80001b04:	6942                	ld	s2,16(sp)
    80001b06:	69a2                	ld	s3,8(sp)
    80001b08:	6a02                	ld	s4,0(sp)
    80001b0a:	6145                	addi	sp,sp,48
    80001b0c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b0e:	000a061b          	sext.w	a2,s4
    80001b12:	85ce                	mv	a1,s3
    80001b14:	854a                	mv	a0,s2
    80001b16:	ffffe097          	auipc	ra,0xffffe
    80001b1a:	6c2080e7          	jalr	1730(ra) # 800001d8 <memmove>
    return 0;
    80001b1e:	8526                	mv	a0,s1
    80001b20:	bff9                	j	80001afe <either_copyin+0x32>

0000000080001b22 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b22:	715d                	addi	sp,sp,-80
    80001b24:	e486                	sd	ra,72(sp)
    80001b26:	e0a2                	sd	s0,64(sp)
    80001b28:	fc26                	sd	s1,56(sp)
    80001b2a:	f84a                	sd	s2,48(sp)
    80001b2c:	f44e                	sd	s3,40(sp)
    80001b2e:	f052                	sd	s4,32(sp)
    80001b30:	ec56                	sd	s5,24(sp)
    80001b32:	e85a                	sd	s6,16(sp)
    80001b34:	e45e                	sd	s7,8(sp)
    80001b36:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b38:	00006517          	auipc	a0,0x6
    80001b3c:	51050513          	addi	a0,a0,1296 # 80008048 <etext+0x48>
    80001b40:	00004097          	auipc	ra,0x4
    80001b44:	792080e7          	jalr	1938(ra) # 800062d2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b48:	00008497          	auipc	s1,0x8
    80001b4c:	a9048493          	addi	s1,s1,-1392 # 800095d8 <proc+0x158>
    80001b50:	00015917          	auipc	s2,0x15
    80001b54:	48890913          	addi	s2,s2,1160 # 80016fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b58:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b5a:	00006997          	auipc	s3,0x6
    80001b5e:	66e98993          	addi	s3,s3,1646 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001b62:	00006a97          	auipc	s5,0x6
    80001b66:	66ea8a93          	addi	s5,s5,1646 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001b6a:	00006a17          	auipc	s4,0x6
    80001b6e:	4dea0a13          	addi	s4,s4,1246 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b72:	00006b97          	auipc	s7,0x6
    80001b76:	696b8b93          	addi	s7,s7,1686 # 80008208 <states.1799>
    80001b7a:	a00d                	j	80001b9c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7c:	ed86a583          	lw	a1,-296(a3)
    80001b80:	8556                	mv	a0,s5
    80001b82:	00004097          	auipc	ra,0x4
    80001b86:	750080e7          	jalr	1872(ra) # 800062d2 <printf>
    printf("\n");
    80001b8a:	8552                	mv	a0,s4
    80001b8c:	00004097          	auipc	ra,0x4
    80001b90:	746080e7          	jalr	1862(ra) # 800062d2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b94:	36848493          	addi	s1,s1,872
    80001b98:	03248163          	beq	s1,s2,80001bba <procdump+0x98>
    if(p->state == UNUSED)
    80001b9c:	86a6                	mv	a3,s1
    80001b9e:	ec04a783          	lw	a5,-320(s1)
    80001ba2:	dbed                	beqz	a5,80001b94 <procdump+0x72>
      state = "???";
    80001ba4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba6:	fcfb6be3          	bltu	s6,a5,80001b7c <procdump+0x5a>
    80001baa:	1782                	slli	a5,a5,0x20
    80001bac:	9381                	srli	a5,a5,0x20
    80001bae:	078e                	slli	a5,a5,0x3
    80001bb0:	97de                	add	a5,a5,s7
    80001bb2:	6390                	ld	a2,0(a5)
    80001bb4:	f661                	bnez	a2,80001b7c <procdump+0x5a>
      state = "???";
    80001bb6:	864e                	mv	a2,s3
    80001bb8:	b7d1                	j	80001b7c <procdump+0x5a>
  }
}
    80001bba:	60a6                	ld	ra,72(sp)
    80001bbc:	6406                	ld	s0,64(sp)
    80001bbe:	74e2                	ld	s1,56(sp)
    80001bc0:	7942                	ld	s2,48(sp)
    80001bc2:	79a2                	ld	s3,40(sp)
    80001bc4:	7a02                	ld	s4,32(sp)
    80001bc6:	6ae2                	ld	s5,24(sp)
    80001bc8:	6b42                	ld	s6,16(sp)
    80001bca:	6ba2                	ld	s7,8(sp)
    80001bcc:	6161                	addi	sp,sp,80
    80001bce:	8082                	ret

0000000080001bd0 <swtch>:
    80001bd0:	00153023          	sd	ra,0(a0)
    80001bd4:	00253423          	sd	sp,8(a0)
    80001bd8:	e900                	sd	s0,16(a0)
    80001bda:	ed04                	sd	s1,24(a0)
    80001bdc:	03253023          	sd	s2,32(a0)
    80001be0:	03353423          	sd	s3,40(a0)
    80001be4:	03453823          	sd	s4,48(a0)
    80001be8:	03553c23          	sd	s5,56(a0)
    80001bec:	05653023          	sd	s6,64(a0)
    80001bf0:	05753423          	sd	s7,72(a0)
    80001bf4:	05853823          	sd	s8,80(a0)
    80001bf8:	05953c23          	sd	s9,88(a0)
    80001bfc:	07a53023          	sd	s10,96(a0)
    80001c00:	07b53423          	sd	s11,104(a0)
    80001c04:	0005b083          	ld	ra,0(a1)
    80001c08:	0085b103          	ld	sp,8(a1)
    80001c0c:	6980                	ld	s0,16(a1)
    80001c0e:	6d84                	ld	s1,24(a1)
    80001c10:	0205b903          	ld	s2,32(a1)
    80001c14:	0285b983          	ld	s3,40(a1)
    80001c18:	0305ba03          	ld	s4,48(a1)
    80001c1c:	0385ba83          	ld	s5,56(a1)
    80001c20:	0405bb03          	ld	s6,64(a1)
    80001c24:	0485bb83          	ld	s7,72(a1)
    80001c28:	0505bc03          	ld	s8,80(a1)
    80001c2c:	0585bc83          	ld	s9,88(a1)
    80001c30:	0605bd03          	ld	s10,96(a1)
    80001c34:	0685bd83          	ld	s11,104(a1)
    80001c38:	8082                	ret

0000000080001c3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e406                	sd	ra,8(sp)
    80001c3e:	e022                	sd	s0,0(sp)
    80001c40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c42:	00006597          	auipc	a1,0x6
    80001c46:	5f658593          	addi	a1,a1,1526 # 80008238 <states.1799+0x30>
    80001c4a:	00015517          	auipc	a0,0x15
    80001c4e:	23650513          	addi	a0,a0,566 # 80016e80 <tickslock>
    80001c52:	00005097          	auipc	ra,0x5
    80001c56:	af0080e7          	jalr	-1296(ra) # 80006742 <initlock>
}
    80001c5a:	60a2                	ld	ra,8(sp)
    80001c5c:	6402                	ld	s0,0(sp)
    80001c5e:	0141                	addi	sp,sp,16
    80001c60:	8082                	ret

0000000080001c62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c62:	1141                	addi	sp,sp,-16
    80001c64:	e422                	sd	s0,8(sp)
    80001c66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c68:	00004797          	auipc	a5,0x4
    80001c6c:	a2878793          	addi	a5,a5,-1496 # 80005690 <kernelvec>
    80001c70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c74:	6422                	ld	s0,8(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c7a:	1141                	addi	sp,sp,-16
    80001c7c:	e406                	sd	ra,8(sp)
    80001c7e:	e022                	sd	s0,0(sp)
    80001c80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	19c080e7          	jalr	412(ra) # 80000e1e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c94:	00005617          	auipc	a2,0x5
    80001c98:	36c60613          	addi	a2,a2,876 # 80007000 <_trampoline>
    80001c9c:	00005697          	auipc	a3,0x5
    80001ca0:	36468693          	addi	a3,a3,868 # 80007000 <_trampoline>
    80001ca4:	8e91                	sub	a3,a3,a2
    80001ca6:	040007b7          	lui	a5,0x4000
    80001caa:	17fd                	addi	a5,a5,-1
    80001cac:	07b2                	slli	a5,a5,0xc
    80001cae:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cb4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb6:	180026f3          	csrr	a3,satp
    80001cba:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cbc:	6d38                	ld	a4,88(a0)
    80001cbe:	6134                	ld	a3,64(a0)
    80001cc0:	6585                	lui	a1,0x1
    80001cc2:	96ae                	add	a3,a3,a1
    80001cc4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc6:	6d38                	ld	a4,88(a0)
    80001cc8:	00000697          	auipc	a3,0x0
    80001ccc:	13868693          	addi	a3,a3,312 # 80001e00 <usertrap>
    80001cd0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cd2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd4:	8692                	mv	a3,tp
    80001cd6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cdc:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ce0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cea:	6f18                	ld	a4,24(a4)
    80001cec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cf0:	692c                	ld	a1,80(a0)
    80001cf2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cf4:	00005717          	auipc	a4,0x5
    80001cf8:	39c70713          	addi	a4,a4,924 # 80007090 <userret>
    80001cfc:	8f11                	sub	a4,a4,a2
    80001cfe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d00:	577d                	li	a4,-1
    80001d02:	177e                	slli	a4,a4,0x3f
    80001d04:	8dd9                	or	a1,a1,a4
    80001d06:	02000537          	lui	a0,0x2000
    80001d0a:	157d                	addi	a0,a0,-1
    80001d0c:	0536                	slli	a0,a0,0xd
    80001d0e:	9782                	jalr	a5
}
    80001d10:	60a2                	ld	ra,8(sp)
    80001d12:	6402                	ld	s0,0(sp)
    80001d14:	0141                	addi	sp,sp,16
    80001d16:	8082                	ret

0000000080001d18 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	e426                	sd	s1,8(sp)
    80001d20:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d22:	00015497          	auipc	s1,0x15
    80001d26:	15e48493          	addi	s1,s1,350 # 80016e80 <tickslock>
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00005097          	auipc	ra,0x5
    80001d30:	aa6080e7          	jalr	-1370(ra) # 800067d2 <acquire>
  ticks++;
    80001d34:	00007517          	auipc	a0,0x7
    80001d38:	2e450513          	addi	a0,a0,740 # 80009018 <ticks>
    80001d3c:	411c                	lw	a5,0(a0)
    80001d3e:	2785                	addiw	a5,a5,1
    80001d40:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	968080e7          	jalr	-1688(ra) # 800016aa <wakeup>
  release(&tickslock);
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	00005097          	auipc	ra,0x5
    80001d50:	b3a080e7          	jalr	-1222(ra) # 80006886 <release>
}
    80001d54:	60e2                	ld	ra,24(sp)
    80001d56:	6442                	ld	s0,16(sp)
    80001d58:	64a2                	ld	s1,8(sp)
    80001d5a:	6105                	addi	sp,sp,32
    80001d5c:	8082                	ret

0000000080001d5e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d5e:	1101                	addi	sp,sp,-32
    80001d60:	ec06                	sd	ra,24(sp)
    80001d62:	e822                	sd	s0,16(sp)
    80001d64:	e426                	sd	s1,8(sp)
    80001d66:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d68:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d6c:	00074d63          	bltz	a4,80001d86 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d70:	57fd                	li	a5,-1
    80001d72:	17fe                	slli	a5,a5,0x3f
    80001d74:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d76:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d78:	06f70363          	beq	a4,a5,80001dde <devintr+0x80>
  }
}
    80001d7c:	60e2                	ld	ra,24(sp)
    80001d7e:	6442                	ld	s0,16(sp)
    80001d80:	64a2                	ld	s1,8(sp)
    80001d82:	6105                	addi	sp,sp,32
    80001d84:	8082                	ret
     (scause & 0xff) == 9){
    80001d86:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d8a:	46a5                	li	a3,9
    80001d8c:	fed792e3          	bne	a5,a3,80001d70 <devintr+0x12>
    int irq = plic_claim();
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	a08080e7          	jalr	-1528(ra) # 80005798 <plic_claim>
    80001d98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d9a:	47a9                	li	a5,10
    80001d9c:	02f50763          	beq	a0,a5,80001dca <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001da0:	4785                	li	a5,1
    80001da2:	02f50963          	beq	a0,a5,80001dd4 <devintr+0x76>
    return 1;
    80001da6:	4505                	li	a0,1
    } else if(irq){
    80001da8:	d8f1                	beqz	s1,80001d7c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001daa:	85a6                	mv	a1,s1
    80001dac:	00006517          	auipc	a0,0x6
    80001db0:	49450513          	addi	a0,a0,1172 # 80008240 <states.1799+0x38>
    80001db4:	00004097          	auipc	ra,0x4
    80001db8:	51e080e7          	jalr	1310(ra) # 800062d2 <printf>
      plic_complete(irq);
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	9fe080e7          	jalr	-1538(ra) # 800057bc <plic_complete>
    return 1;
    80001dc6:	4505                	li	a0,1
    80001dc8:	bf55                	j	80001d7c <devintr+0x1e>
      uartintr();
    80001dca:	00005097          	auipc	ra,0x5
    80001dce:	928080e7          	jalr	-1752(ra) # 800066f2 <uartintr>
    80001dd2:	b7ed                	j	80001dbc <devintr+0x5e>
      virtio_disk_intr();
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	ec8080e7          	jalr	-312(ra) # 80005c9c <virtio_disk_intr>
    80001ddc:	b7c5                	j	80001dbc <devintr+0x5e>
    if(cpuid() == 0){
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	014080e7          	jalr	20(ra) # 80000df2 <cpuid>
    80001de6:	c901                	beqz	a0,80001df6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001de8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dee:	14479073          	csrw	sip,a5
    return 2;
    80001df2:	4509                	li	a0,2
    80001df4:	b761                	j	80001d7c <devintr+0x1e>
      clockintr();
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	f22080e7          	jalr	-222(ra) # 80001d18 <clockintr>
    80001dfe:	b7ed                	j	80001de8 <devintr+0x8a>

0000000080001e00 <usertrap>:
{
    80001e00:	7139                	addi	sp,sp,-64
    80001e02:	fc06                	sd	ra,56(sp)
    80001e04:	f822                	sd	s0,48(sp)
    80001e06:	f426                	sd	s1,40(sp)
    80001e08:	f04a                	sd	s2,32(sp)
    80001e0a:	ec4e                	sd	s3,24(sp)
    80001e0c:	e852                	sd	s4,16(sp)
    80001e0e:	e456                	sd	s5,8(sp)
    80001e10:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e16:	1007f793          	andi	a5,a5,256
    80001e1a:	efb1                	bnez	a5,80001e76 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e1c:	00004797          	auipc	a5,0x4
    80001e20:	87478793          	addi	a5,a5,-1932 # 80005690 <kernelvec>
    80001e24:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	ff6080e7          	jalr	-10(ra) # 80000e1e <myproc>
    80001e30:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001e32:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e34:	14102773          	csrr	a4,sepc
    80001e38:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e3e:	47a1                	li	a5,8
    80001e40:	04f70363          	beq	a4,a5,80001e86 <usertrap+0x86>
    80001e44:	14202773          	csrr	a4,scause
  else if(r_scause() == 12||r_scause() == 13||r_scause() == 15)
    80001e48:	47b1                	li	a5,12
    80001e4a:	00f70c63          	beq	a4,a5,80001e62 <usertrap+0x62>
    80001e4e:	14202773          	csrr	a4,scause
    80001e52:	47b5                	li	a5,13
    80001e54:	00f70763          	beq	a4,a5,80001e62 <usertrap+0x62>
    80001e58:	14202773          	csrr	a4,scause
    80001e5c:	47bd                	li	a5,15
    80001e5e:	1ef71463          	bne	a4,a5,80002046 <usertrap+0x246>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e62:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001e66:	77fd                	lui	a5,0xfffff
    80001e68:	00f9f9b3          	and	s3,s3,a5
    for(int i=0;i<NVMA;i++){
    80001e6c:	16890793          	addi	a5,s2,360
    80001e70:	4481                	li	s1,0
    80001e72:	4641                	li	a2,16
    80001e74:	a0b5                	j	80001ee0 <usertrap+0xe0>
    panic("usertrap: not from user mode");
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	3ea50513          	addi	a0,a0,1002 # 80008260 <states.1799+0x58>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	40a080e7          	jalr	1034(ra) # 80006288 <panic>
    if(p->killed)
    80001e86:	551c                	lw	a5,40(a0)
    80001e88:	e3a9                	bnez	a5,80001eca <usertrap+0xca>
    p->trapframe->epc += 4;
    80001e8a:	05893703          	ld	a4,88(s2)
    80001e8e:	6f1c                	ld	a5,24(a4)
    80001e90:	0791                	addi	a5,a5,4
    80001e92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	400080e7          	jalr	1024(ra) # 800022a0 <syscall>
  if(p->killed)
    80001ea8:	02892783          	lw	a5,40(s2)
    80001eac:	1a079763          	bnez	a5,8000205a <usertrap+0x25a>
  usertrapret();
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	dca080e7          	jalr	-566(ra) # 80001c7a <usertrapret>
}
    80001eb8:	70e2                	ld	ra,56(sp)
    80001eba:	7442                	ld	s0,48(sp)
    80001ebc:	74a2                	ld	s1,40(sp)
    80001ebe:	7902                	ld	s2,32(sp)
    80001ec0:	69e2                	ld	s3,24(sp)
    80001ec2:	6a42                	ld	s4,16(sp)
    80001ec4:	6aa2                	ld	s5,8(sp)
    80001ec6:	6121                	addi	sp,sp,64
    80001ec8:	8082                	ret
      exit(-1);
    80001eca:	557d                	li	a0,-1
    80001ecc:	00000097          	auipc	ra,0x0
    80001ed0:	8ae080e7          	jalr	-1874(ra) # 8000177a <exit>
    80001ed4:	bf5d                	j	80001e8a <usertrap+0x8a>
    for(int i=0;i<NVMA;i++){
    80001ed6:	2485                	addiw	s1,s1,1
    80001ed8:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    80001edc:	10c48663          	beq	s1,a2,80001fe8 <usertrap+0x1e8>
      if (p->vma[i].addr && va >= p->vma[i].addr
    80001ee0:	6398                	ld	a4,0(a5)
    80001ee2:	db75                	beqz	a4,80001ed6 <usertrap+0xd6>
    80001ee4:	fee9e9e3          	bltu	s3,a4,80001ed6 <usertrap+0xd6>
          && va < p->vma[i].addr + p->vma[i].len) {
    80001ee8:	4794                	lw	a3,8(a5)
    80001eea:	9736                	add	a4,a4,a3
    80001eec:	fee9f5e3          	bgeu	s3,a4,80001ed6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef0:	14202773          	csrr	a4,scause
    if (r_scause() == 15 && (vma->prot & PROT_WRITE) && walkaddr(p->pagetable, va)) {
    80001ef4:	47bd                	li	a5,15
    80001ef6:	00f71963          	bne	a4,a5,80001f08 <usertrap+0x108>
    80001efa:	00b48793          	addi	a5,s1,11
    80001efe:	0796                	slli	a5,a5,0x5
    80001f00:	97ca                	add	a5,a5,s2
    80001f02:	4bdc                	lw	a5,20(a5)
    80001f04:	8b89                	andi	a5,a5,2
    80001f06:	e7c5                	bnez	a5,80001fae <usertrap+0x1ae>
      if ((pa = kalloc()) == 0) 
    80001f08:	ffffe097          	auipc	ra,0xffffe
    80001f0c:	210080e7          	jalr	528(ra) # 80000118 <kalloc>
    80001f10:	8a2a                	mv	s4,a0
    80001f12:	c979                	beqz	a0,80001fe8 <usertrap+0x1e8>
      memset(pa, 0, PGSIZE);
    80001f14:	6605                	lui	a2,0x1
    80001f16:	4581                	li	a1,0
    80001f18:	ffffe097          	auipc	ra,0xffffe
    80001f1c:	260080e7          	jalr	608(ra) # 80000178 <memset>
      ilock(vma->f->ip);
    80001f20:	00549a93          	slli	s5,s1,0x5
    80001f24:	9aca                	add	s5,s5,s2
    80001f26:	180ab783          	ld	a5,384(s5)
    80001f2a:	6f88                	ld	a0,24(a5)
    80001f2c:	00001097          	auipc	ra,0x1
    80001f30:	e72080e7          	jalr	-398(ra) # 80002d9e <ilock>
      if (readi(vma->f->ip, 0, (uint64) pa, va - vma->addr + vma->offset, PGSIZE) < 0) 
    80001f34:	17caa783          	lw	a5,380(s5)
    80001f38:	013787bb          	addw	a5,a5,s3
    80001f3c:	168ab683          	ld	a3,360(s5)
    80001f40:	180ab503          	ld	a0,384(s5)
    80001f44:	6705                	lui	a4,0x1
    80001f46:	40d786bb          	subw	a3,a5,a3
    80001f4a:	8652                	mv	a2,s4
    80001f4c:	4581                	li	a1,0
    80001f4e:	6d08                	ld	a0,24(a0)
    80001f50:	00001097          	auipc	ra,0x1
    80001f54:	102080e7          	jalr	258(ra) # 80003052 <readi>
    80001f58:	08054163          	bltz	a0,80001fda <usertrap+0x1da>
      iunlock(vma->f->ip);
    80001f5c:	0496                	slli	s1,s1,0x5
    80001f5e:	94ca                	add	s1,s1,s2
    80001f60:	1804b783          	ld	a5,384(s1)
    80001f64:	6f88                	ld	a0,24(a5)
    80001f66:	00001097          	auipc	ra,0x1
    80001f6a:	efa080e7          	jalr	-262(ra) # 80002e60 <iunlock>
      if ((vma->prot & PROT_READ)) 
    80001f6e:	174aa783          	lw	a5,372(s5)
    80001f72:	0017f693          	andi	a3,a5,1
    int flags = PTE_U;
    80001f76:	4741                	li	a4,16
      if ((vma->prot & PROT_READ)) 
    80001f78:	c291                	beqz	a3,80001f7c <usertrap+0x17c>
        flags |= PTE_R;
    80001f7a:	4749                	li	a4,18
    80001f7c:	14202673          	csrr	a2,scause
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) 
    80001f80:	46bd                	li	a3,15
    80001f82:	0ad60c63          	beq	a2,a3,8000203a <usertrap+0x23a>
      if ((vma->prot & PROT_EXEC)) 
    80001f86:	8b91                	andi	a5,a5,4
    80001f88:	c399                	beqz	a5,80001f8e <usertrap+0x18e>
        flags |= PTE_X;
    80001f8a:	00876713          	ori	a4,a4,8
      if (mappages(p->pagetable, va, PGSIZE, (uint64) pa, flags) != 0) 
    80001f8e:	86d2                	mv	a3,s4
    80001f90:	6605                	lui	a2,0x1
    80001f92:	85ce                	mv	a1,s3
    80001f94:	05093503          	ld	a0,80(s2)
    80001f98:	ffffe097          	auipc	ra,0xffffe
    80001f9c:	5b0080e7          	jalr	1456(ra) # 80000548 <mappages>
    80001fa0:	d501                	beqz	a0,80001ea8 <usertrap+0xa8>
        kfree(pa);
    80001fa2:	8552                	mv	a0,s4
    80001fa4:	ffffe097          	auipc	ra,0xffffe
    80001fa8:	078080e7          	jalr	120(ra) # 8000001c <kfree>
        goto err;
    80001fac:	a835                	j	80001fe8 <usertrap+0x1e8>
    if (r_scause() == 15 && (vma->prot & PROT_WRITE) && walkaddr(p->pagetable, va)) {
    80001fae:	85ce                	mv	a1,s3
    80001fb0:	05093503          	ld	a0,80(s2)
    80001fb4:	ffffe097          	auipc	ra,0xffffe
    80001fb8:	552080e7          	jalr	1362(ra) # 80000506 <walkaddr>
    80001fbc:	d531                	beqz	a0,80001f08 <usertrap+0x108>
      pte_t* pte = walk(p->pagetable,va,0);
    80001fbe:	4601                	li	a2,0
    80001fc0:	85ce                	mv	a1,s3
    80001fc2:	05093503          	ld	a0,80(s2)
    80001fc6:	ffffe097          	auipc	ra,0xffffe
    80001fca:	49a080e7          	jalr	1178(ra) # 80000460 <walk>
      if(pte==0)
    80001fce:	cd09                	beqz	a0,80001fe8 <usertrap+0x1e8>
      *pte |= PTE_D | PTE_W;
    80001fd0:	611c                	ld	a5,0(a0)
    80001fd2:	0847e793          	ori	a5,a5,132
    80001fd6:	e11c                	sd	a5,0(a0)
    if (r_scause() == 15 && (vma->prot & PROT_WRITE) && walkaddr(p->pagetable, va)) {
    80001fd8:	bdc1                	j	80001ea8 <usertrap+0xa8>
        iunlock(vma->f->ip);
    80001fda:	180ab783          	ld	a5,384(s5)
    80001fde:	6f88                	ld	a0,24(a5)
    80001fe0:	00001097          	auipc	ra,0x1
    80001fe4:	e80080e7          	jalr	-384(ra) # 80002e60 <iunlock>
    80001fe8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fec:	03092603          	lw	a2,48(s2)
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	29050513          	addi	a0,a0,656 # 80008280 <states.1799+0x78>
    80001ff8:	00004097          	auipc	ra,0x4
    80001ffc:	2da080e7          	jalr	730(ra) # 800062d2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002000:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002004:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	2a850513          	addi	a0,a0,680 # 800082b0 <states.1799+0xa8>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	2c2080e7          	jalr	706(ra) # 800062d2 <printf>
    p->killed = 1;
    80002018:	4785                	li	a5,1
    8000201a:	02f92423          	sw	a5,40(s2)
    8000201e:	4481                	li	s1,0
    exit(-1);
    80002020:	557d                	li	a0,-1
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	758080e7          	jalr	1880(ra) # 8000177a <exit>
  if(which_dev == 2)
    8000202a:	4789                	li	a5,2
    8000202c:	e8f492e3          	bne	s1,a5,80001eb0 <usertrap+0xb0>
    yield();
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	4b2080e7          	jalr	1202(ra) # 800014e2 <yield>
    80002038:	bda5                	j	80001eb0 <usertrap+0xb0>
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) 
    8000203a:	0027f693          	andi	a3,a5,2
    8000203e:	d6a1                	beqz	a3,80001f86 <usertrap+0x186>
        flags |= PTE_W | PTE_D;
    80002040:	08476713          	ori	a4,a4,132
    80002044:	b789                	j	80001f86 <usertrap+0x186>
  }else if((which_dev = devintr()) != 0){
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	d18080e7          	jalr	-744(ra) # 80001d5e <devintr>
    8000204e:	84aa                	mv	s1,a0
    80002050:	dd41                	beqz	a0,80001fe8 <usertrap+0x1e8>
  if(p->killed)
    80002052:	02892783          	lw	a5,40(s2)
    80002056:	dbf1                	beqz	a5,8000202a <usertrap+0x22a>
    80002058:	b7e1                	j	80002020 <usertrap+0x220>
    8000205a:	4481                	li	s1,0
    8000205c:	b7d1                	j	80002020 <usertrap+0x220>

000000008000205e <kerneltrap>:
{
    8000205e:	7179                	addi	sp,sp,-48
    80002060:	f406                	sd	ra,40(sp)
    80002062:	f022                	sd	s0,32(sp)
    80002064:	ec26                	sd	s1,24(sp)
    80002066:	e84a                	sd	s2,16(sp)
    80002068:	e44e                	sd	s3,8(sp)
    8000206a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000206c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002070:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002074:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002078:	1004f793          	andi	a5,s1,256
    8000207c:	cb85                	beqz	a5,800020ac <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002082:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002084:	ef85                	bnez	a5,800020bc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	cd8080e7          	jalr	-808(ra) # 80001d5e <devintr>
    8000208e:	cd1d                	beqz	a0,800020cc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002090:	4789                	li	a5,2
    80002092:	06f50a63          	beq	a0,a5,80002106 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002096:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000209a:	10049073          	csrw	sstatus,s1
}
    8000209e:	70a2                	ld	ra,40(sp)
    800020a0:	7402                	ld	s0,32(sp)
    800020a2:	64e2                	ld	s1,24(sp)
    800020a4:	6942                	ld	s2,16(sp)
    800020a6:	69a2                	ld	s3,8(sp)
    800020a8:	6145                	addi	sp,sp,48
    800020aa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020ac:	00006517          	auipc	a0,0x6
    800020b0:	22450513          	addi	a0,a0,548 # 800082d0 <states.1799+0xc8>
    800020b4:	00004097          	auipc	ra,0x4
    800020b8:	1d4080e7          	jalr	468(ra) # 80006288 <panic>
    panic("kerneltrap: interrupts enabled");
    800020bc:	00006517          	auipc	a0,0x6
    800020c0:	23c50513          	addi	a0,a0,572 # 800082f8 <states.1799+0xf0>
    800020c4:	00004097          	auipc	ra,0x4
    800020c8:	1c4080e7          	jalr	452(ra) # 80006288 <panic>
    printf("scause %p\n", scause);
    800020cc:	85ce                	mv	a1,s3
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	24a50513          	addi	a0,a0,586 # 80008318 <states.1799+0x110>
    800020d6:	00004097          	auipc	ra,0x4
    800020da:	1fc080e7          	jalr	508(ra) # 800062d2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020de:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020e2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020e6:	00006517          	auipc	a0,0x6
    800020ea:	24250513          	addi	a0,a0,578 # 80008328 <states.1799+0x120>
    800020ee:	00004097          	auipc	ra,0x4
    800020f2:	1e4080e7          	jalr	484(ra) # 800062d2 <printf>
    panic("kerneltrap");
    800020f6:	00006517          	auipc	a0,0x6
    800020fa:	24a50513          	addi	a0,a0,586 # 80008340 <states.1799+0x138>
    800020fe:	00004097          	auipc	ra,0x4
    80002102:	18a080e7          	jalr	394(ra) # 80006288 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	d18080e7          	jalr	-744(ra) # 80000e1e <myproc>
    8000210e:	d541                	beqz	a0,80002096 <kerneltrap+0x38>
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	d0e080e7          	jalr	-754(ra) # 80000e1e <myproc>
    80002118:	4d18                	lw	a4,24(a0)
    8000211a:	4791                	li	a5,4
    8000211c:	f6f71de3          	bne	a4,a5,80002096 <kerneltrap+0x38>
    yield();
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	3c2080e7          	jalr	962(ra) # 800014e2 <yield>
    80002128:	b7bd                	j	80002096 <kerneltrap+0x38>

000000008000212a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000212a:	1101                	addi	sp,sp,-32
    8000212c:	ec06                	sd	ra,24(sp)
    8000212e:	e822                	sd	s0,16(sp)
    80002130:	e426                	sd	s1,8(sp)
    80002132:	1000                	addi	s0,sp,32
    80002134:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	ce8080e7          	jalr	-792(ra) # 80000e1e <myproc>
  switch (n) {
    8000213e:	4795                	li	a5,5
    80002140:	0497e163          	bltu	a5,s1,80002182 <argraw+0x58>
    80002144:	048a                	slli	s1,s1,0x2
    80002146:	00006717          	auipc	a4,0x6
    8000214a:	23270713          	addi	a4,a4,562 # 80008378 <states.1799+0x170>
    8000214e:	94ba                	add	s1,s1,a4
    80002150:	409c                	lw	a5,0(s1)
    80002152:	97ba                	add	a5,a5,a4
    80002154:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002156:	6d3c                	ld	a5,88(a0)
    80002158:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret
    return p->trapframe->a1;
    80002164:	6d3c                	ld	a5,88(a0)
    80002166:	7fa8                	ld	a0,120(a5)
    80002168:	bfcd                	j	8000215a <argraw+0x30>
    return p->trapframe->a2;
    8000216a:	6d3c                	ld	a5,88(a0)
    8000216c:	63c8                	ld	a0,128(a5)
    8000216e:	b7f5                	j	8000215a <argraw+0x30>
    return p->trapframe->a3;
    80002170:	6d3c                	ld	a5,88(a0)
    80002172:	67c8                	ld	a0,136(a5)
    80002174:	b7dd                	j	8000215a <argraw+0x30>
    return p->trapframe->a4;
    80002176:	6d3c                	ld	a5,88(a0)
    80002178:	6bc8                	ld	a0,144(a5)
    8000217a:	b7c5                	j	8000215a <argraw+0x30>
    return p->trapframe->a5;
    8000217c:	6d3c                	ld	a5,88(a0)
    8000217e:	6fc8                	ld	a0,152(a5)
    80002180:	bfe9                	j	8000215a <argraw+0x30>
  panic("argraw");
    80002182:	00006517          	auipc	a0,0x6
    80002186:	1ce50513          	addi	a0,a0,462 # 80008350 <states.1799+0x148>
    8000218a:	00004097          	auipc	ra,0x4
    8000218e:	0fe080e7          	jalr	254(ra) # 80006288 <panic>

0000000080002192 <fetchaddr>:
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	e426                	sd	s1,8(sp)
    8000219a:	e04a                	sd	s2,0(sp)
    8000219c:	1000                	addi	s0,sp,32
    8000219e:	84aa                	mv	s1,a0
    800021a0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	c7c080e7          	jalr	-900(ra) # 80000e1e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021aa:	653c                	ld	a5,72(a0)
    800021ac:	02f4f863          	bgeu	s1,a5,800021dc <fetchaddr+0x4a>
    800021b0:	00848713          	addi	a4,s1,8
    800021b4:	02e7e663          	bltu	a5,a4,800021e0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021b8:	46a1                	li	a3,8
    800021ba:	8626                	mv	a2,s1
    800021bc:	85ca                	mv	a1,s2
    800021be:	6928                	ld	a0,80(a0)
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	9ac080e7          	jalr	-1620(ra) # 80000b6c <copyin>
    800021c8:	00a03533          	snez	a0,a0
    800021cc:	40a00533          	neg	a0,a0
}
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6902                	ld	s2,0(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret
    return -1;
    800021dc:	557d                	li	a0,-1
    800021de:	bfcd                	j	800021d0 <fetchaddr+0x3e>
    800021e0:	557d                	li	a0,-1
    800021e2:	b7fd                	j	800021d0 <fetchaddr+0x3e>

00000000800021e4 <fetchstr>:
{
    800021e4:	7179                	addi	sp,sp,-48
    800021e6:	f406                	sd	ra,40(sp)
    800021e8:	f022                	sd	s0,32(sp)
    800021ea:	ec26                	sd	s1,24(sp)
    800021ec:	e84a                	sd	s2,16(sp)
    800021ee:	e44e                	sd	s3,8(sp)
    800021f0:	1800                	addi	s0,sp,48
    800021f2:	892a                	mv	s2,a0
    800021f4:	84ae                	mv	s1,a1
    800021f6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	c26080e7          	jalr	-986(ra) # 80000e1e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002200:	86ce                	mv	a3,s3
    80002202:	864a                	mv	a2,s2
    80002204:	85a6                	mv	a1,s1
    80002206:	6928                	ld	a0,80(a0)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	9f0080e7          	jalr	-1552(ra) # 80000bf8 <copyinstr>
  if(err < 0)
    80002210:	00054763          	bltz	a0,8000221e <fetchstr+0x3a>
  return strlen(buf);
    80002214:	8526                	mv	a0,s1
    80002216:	ffffe097          	auipc	ra,0xffffe
    8000221a:	0e6080e7          	jalr	230(ra) # 800002fc <strlen>
}
    8000221e:	70a2                	ld	ra,40(sp)
    80002220:	7402                	ld	s0,32(sp)
    80002222:	64e2                	ld	s1,24(sp)
    80002224:	6942                	ld	s2,16(sp)
    80002226:	69a2                	ld	s3,8(sp)
    80002228:	6145                	addi	sp,sp,48
    8000222a:	8082                	ret

000000008000222c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000222c:	1101                	addi	sp,sp,-32
    8000222e:	ec06                	sd	ra,24(sp)
    80002230:	e822                	sd	s0,16(sp)
    80002232:	e426                	sd	s1,8(sp)
    80002234:	1000                	addi	s0,sp,32
    80002236:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	ef2080e7          	jalr	-270(ra) # 8000212a <argraw>
    80002240:	c088                	sw	a0,0(s1)
  return 0;
}
    80002242:	4501                	li	a0,0
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	64a2                	ld	s1,8(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000224e:	1101                	addi	sp,sp,-32
    80002250:	ec06                	sd	ra,24(sp)
    80002252:	e822                	sd	s0,16(sp)
    80002254:	e426                	sd	s1,8(sp)
    80002256:	1000                	addi	s0,sp,32
    80002258:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	ed0080e7          	jalr	-304(ra) # 8000212a <argraw>
    80002262:	e088                	sd	a0,0(s1)
  return 0;
}
    80002264:	4501                	li	a0,0
    80002266:	60e2                	ld	ra,24(sp)
    80002268:	6442                	ld	s0,16(sp)
    8000226a:	64a2                	ld	s1,8(sp)
    8000226c:	6105                	addi	sp,sp,32
    8000226e:	8082                	ret

0000000080002270 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002270:	1101                	addi	sp,sp,-32
    80002272:	ec06                	sd	ra,24(sp)
    80002274:	e822                	sd	s0,16(sp)
    80002276:	e426                	sd	s1,8(sp)
    80002278:	e04a                	sd	s2,0(sp)
    8000227a:	1000                	addi	s0,sp,32
    8000227c:	84ae                	mv	s1,a1
    8000227e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002280:	00000097          	auipc	ra,0x0
    80002284:	eaa080e7          	jalr	-342(ra) # 8000212a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002288:	864a                	mv	a2,s2
    8000228a:	85a6                	mv	a1,s1
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	f58080e7          	jalr	-168(ra) # 800021e4 <fetchstr>
}
    80002294:	60e2                	ld	ra,24(sp)
    80002296:	6442                	ld	s0,16(sp)
    80002298:	64a2                	ld	s1,8(sp)
    8000229a:	6902                	ld	s2,0(sp)
    8000229c:	6105                	addi	sp,sp,32
    8000229e:	8082                	ret

00000000800022a0 <syscall>:
[SYS_munmap]  sys_munmap
};

void
syscall(void)
{
    800022a0:	1101                	addi	sp,sp,-32
    800022a2:	ec06                	sd	ra,24(sp)
    800022a4:	e822                	sd	s0,16(sp)
    800022a6:	e426                	sd	s1,8(sp)
    800022a8:	e04a                	sd	s2,0(sp)
    800022aa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	b72080e7          	jalr	-1166(ra) # 80000e1e <myproc>
    800022b4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022b6:	05853903          	ld	s2,88(a0)
    800022ba:	0a893783          	ld	a5,168(s2)
    800022be:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022c2:	37fd                	addiw	a5,a5,-1
    800022c4:	4759                	li	a4,22
    800022c6:	00f76f63          	bltu	a4,a5,800022e4 <syscall+0x44>
    800022ca:	00369713          	slli	a4,a3,0x3
    800022ce:	00006797          	auipc	a5,0x6
    800022d2:	0c278793          	addi	a5,a5,194 # 80008390 <syscalls>
    800022d6:	97ba                	add	a5,a5,a4
    800022d8:	639c                	ld	a5,0(a5)
    800022da:	c789                	beqz	a5,800022e4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022dc:	9782                	jalr	a5
    800022de:	06a93823          	sd	a0,112(s2)
    800022e2:	a839                	j	80002300 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022e4:	15848613          	addi	a2,s1,344
    800022e8:	588c                	lw	a1,48(s1)
    800022ea:	00006517          	auipc	a0,0x6
    800022ee:	06e50513          	addi	a0,a0,110 # 80008358 <states.1799+0x150>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	fe0080e7          	jalr	-32(ra) # 800062d2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022fa:	6cbc                	ld	a5,88(s1)
    800022fc:	577d                	li	a4,-1
    800022fe:	fbb8                	sd	a4,112(a5)
  }
}
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	64a2                	ld	s1,8(sp)
    80002306:	6902                	ld	s2,0(sp)
    80002308:	6105                	addi	sp,sp,32
    8000230a:	8082                	ret

000000008000230c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000230c:	1101                	addi	sp,sp,-32
    8000230e:	ec06                	sd	ra,24(sp)
    80002310:	e822                	sd	s0,16(sp)
    80002312:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002314:	fec40593          	addi	a1,s0,-20
    80002318:	4501                	li	a0,0
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	f12080e7          	jalr	-238(ra) # 8000222c <argint>
    return -1;
    80002322:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002324:	00054963          	bltz	a0,80002336 <sys_exit+0x2a>
  exit(n);
    80002328:	fec42503          	lw	a0,-20(s0)
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	44e080e7          	jalr	1102(ra) # 8000177a <exit>
  return 0;  // not reached
    80002334:	4781                	li	a5,0
}
    80002336:	853e                	mv	a0,a5
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	6105                	addi	sp,sp,32
    8000233e:	8082                	ret

0000000080002340 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002340:	1141                	addi	sp,sp,-16
    80002342:	e406                	sd	ra,8(sp)
    80002344:	e022                	sd	s0,0(sp)
    80002346:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	ad6080e7          	jalr	-1322(ra) # 80000e1e <myproc>
}
    80002350:	5908                	lw	a0,48(a0)
    80002352:	60a2                	ld	ra,8(sp)
    80002354:	6402                	ld	s0,0(sp)
    80002356:	0141                	addi	sp,sp,16
    80002358:	8082                	ret

000000008000235a <sys_fork>:

uint64
sys_fork(void)
{
    8000235a:	1141                	addi	sp,sp,-16
    8000235c:	e406                	sd	ra,8(sp)
    8000235e:	e022                	sd	s0,0(sp)
    80002360:	0800                	addi	s0,sp,16
  return fork();
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	e8a080e7          	jalr	-374(ra) # 800011ec <fork>
}
    8000236a:	60a2                	ld	ra,8(sp)
    8000236c:	6402                	ld	s0,0(sp)
    8000236e:	0141                	addi	sp,sp,16
    80002370:	8082                	ret

0000000080002372 <sys_wait>:

uint64
sys_wait(void)
{
    80002372:	1101                	addi	sp,sp,-32
    80002374:	ec06                	sd	ra,24(sp)
    80002376:	e822                	sd	s0,16(sp)
    80002378:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000237a:	fe840593          	addi	a1,s0,-24
    8000237e:	4501                	li	a0,0
    80002380:	00000097          	auipc	ra,0x0
    80002384:	ece080e7          	jalr	-306(ra) # 8000224e <argaddr>
    80002388:	87aa                	mv	a5,a0
    return -1;
    8000238a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000238c:	0007c863          	bltz	a5,8000239c <sys_wait+0x2a>
  return wait(p);
    80002390:	fe843503          	ld	a0,-24(s0)
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	1ee080e7          	jalr	494(ra) # 80001582 <wait>
}
    8000239c:	60e2                	ld	ra,24(sp)
    8000239e:	6442                	ld	s0,16(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret

00000000800023a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023a4:	7179                	addi	sp,sp,-48
    800023a6:	f406                	sd	ra,40(sp)
    800023a8:	f022                	sd	s0,32(sp)
    800023aa:	ec26                	sd	s1,24(sp)
    800023ac:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023ae:	fdc40593          	addi	a1,s0,-36
    800023b2:	4501                	li	a0,0
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	e78080e7          	jalr	-392(ra) # 8000222c <argint>
    800023bc:	87aa                	mv	a5,a0
    return -1;
    800023be:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023c0:	0207c063          	bltz	a5,800023e0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	a5a080e7          	jalr	-1446(ra) # 80000e1e <myproc>
    800023cc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023ce:	fdc42503          	lw	a0,-36(s0)
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	da6080e7          	jalr	-602(ra) # 80001178 <growproc>
    800023da:	00054863          	bltz	a0,800023ea <sys_sbrk+0x46>
    return -1;
  return addr;
    800023de:	8526                	mv	a0,s1
}
    800023e0:	70a2                	ld	ra,40(sp)
    800023e2:	7402                	ld	s0,32(sp)
    800023e4:	64e2                	ld	s1,24(sp)
    800023e6:	6145                	addi	sp,sp,48
    800023e8:	8082                	ret
    return -1;
    800023ea:	557d                	li	a0,-1
    800023ec:	bfd5                	j	800023e0 <sys_sbrk+0x3c>

00000000800023ee <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ee:	7139                	addi	sp,sp,-64
    800023f0:	fc06                	sd	ra,56(sp)
    800023f2:	f822                	sd	s0,48(sp)
    800023f4:	f426                	sd	s1,40(sp)
    800023f6:	f04a                	sd	s2,32(sp)
    800023f8:	ec4e                	sd	s3,24(sp)
    800023fa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023fc:	fcc40593          	addi	a1,s0,-52
    80002400:	4501                	li	a0,0
    80002402:	00000097          	auipc	ra,0x0
    80002406:	e2a080e7          	jalr	-470(ra) # 8000222c <argint>
    return -1;
    8000240a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000240c:	06054563          	bltz	a0,80002476 <sys_sleep+0x88>
  acquire(&tickslock);
    80002410:	00015517          	auipc	a0,0x15
    80002414:	a7050513          	addi	a0,a0,-1424 # 80016e80 <tickslock>
    80002418:	00004097          	auipc	ra,0x4
    8000241c:	3ba080e7          	jalr	954(ra) # 800067d2 <acquire>
  ticks0 = ticks;
    80002420:	00007917          	auipc	s2,0x7
    80002424:	bf892903          	lw	s2,-1032(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002428:	fcc42783          	lw	a5,-52(s0)
    8000242c:	cf85                	beqz	a5,80002464 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000242e:	00015997          	auipc	s3,0x15
    80002432:	a5298993          	addi	s3,s3,-1454 # 80016e80 <tickslock>
    80002436:	00007497          	auipc	s1,0x7
    8000243a:	be248493          	addi	s1,s1,-1054 # 80009018 <ticks>
    if(myproc()->killed){
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	9e0080e7          	jalr	-1568(ra) # 80000e1e <myproc>
    80002446:	551c                	lw	a5,40(a0)
    80002448:	ef9d                	bnez	a5,80002486 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000244a:	85ce                	mv	a1,s3
    8000244c:	8526                	mv	a0,s1
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	0d0080e7          	jalr	208(ra) # 8000151e <sleep>
  while(ticks - ticks0 < n){
    80002456:	409c                	lw	a5,0(s1)
    80002458:	412787bb          	subw	a5,a5,s2
    8000245c:	fcc42703          	lw	a4,-52(s0)
    80002460:	fce7efe3          	bltu	a5,a4,8000243e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002464:	00015517          	auipc	a0,0x15
    80002468:	a1c50513          	addi	a0,a0,-1508 # 80016e80 <tickslock>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	41a080e7          	jalr	1050(ra) # 80006886 <release>
  return 0;
    80002474:	4781                	li	a5,0
}
    80002476:	853e                	mv	a0,a5
    80002478:	70e2                	ld	ra,56(sp)
    8000247a:	7442                	ld	s0,48(sp)
    8000247c:	74a2                	ld	s1,40(sp)
    8000247e:	7902                	ld	s2,32(sp)
    80002480:	69e2                	ld	s3,24(sp)
    80002482:	6121                	addi	sp,sp,64
    80002484:	8082                	ret
      release(&tickslock);
    80002486:	00015517          	auipc	a0,0x15
    8000248a:	9fa50513          	addi	a0,a0,-1542 # 80016e80 <tickslock>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	3f8080e7          	jalr	1016(ra) # 80006886 <release>
      return -1;
    80002496:	57fd                	li	a5,-1
    80002498:	bff9                	j	80002476 <sys_sleep+0x88>

000000008000249a <sys_kill>:

uint64
sys_kill(void)
{
    8000249a:	1101                	addi	sp,sp,-32
    8000249c:	ec06                	sd	ra,24(sp)
    8000249e:	e822                	sd	s0,16(sp)
    800024a0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024a2:	fec40593          	addi	a1,s0,-20
    800024a6:	4501                	li	a0,0
    800024a8:	00000097          	auipc	ra,0x0
    800024ac:	d84080e7          	jalr	-636(ra) # 8000222c <argint>
    800024b0:	87aa                	mv	a5,a0
    return -1;
    800024b2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024b4:	0007c863          	bltz	a5,800024c4 <sys_kill+0x2a>
  return kill(pid);
    800024b8:	fec42503          	lw	a0,-20(s0)
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	548080e7          	jalr	1352(ra) # 80001a04 <kill>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	6105                	addi	sp,sp,32
    800024ca:	8082                	ret

00000000800024cc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024cc:	1101                	addi	sp,sp,-32
    800024ce:	ec06                	sd	ra,24(sp)
    800024d0:	e822                	sd	s0,16(sp)
    800024d2:	e426                	sd	s1,8(sp)
    800024d4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024d6:	00015517          	auipc	a0,0x15
    800024da:	9aa50513          	addi	a0,a0,-1622 # 80016e80 <tickslock>
    800024de:	00004097          	auipc	ra,0x4
    800024e2:	2f4080e7          	jalr	756(ra) # 800067d2 <acquire>
  xticks = ticks;
    800024e6:	00007497          	auipc	s1,0x7
    800024ea:	b324a483          	lw	s1,-1230(s1) # 80009018 <ticks>
  release(&tickslock);
    800024ee:	00015517          	auipc	a0,0x15
    800024f2:	99250513          	addi	a0,a0,-1646 # 80016e80 <tickslock>
    800024f6:	00004097          	auipc	ra,0x4
    800024fa:	390080e7          	jalr	912(ra) # 80006886 <release>
  return xticks;
}
    800024fe:	02049513          	slli	a0,s1,0x20
    80002502:	9101                	srli	a0,a0,0x20
    80002504:	60e2                	ld	ra,24(sp)
    80002506:	6442                	ld	s0,16(sp)
    80002508:	64a2                	ld	s1,8(sp)
    8000250a:	6105                	addi	sp,sp,32
    8000250c:	8082                	ret

000000008000250e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000250e:	7179                	addi	sp,sp,-48
    80002510:	f406                	sd	ra,40(sp)
    80002512:	f022                	sd	s0,32(sp)
    80002514:	ec26                	sd	s1,24(sp)
    80002516:	e84a                	sd	s2,16(sp)
    80002518:	e44e                	sd	s3,8(sp)
    8000251a:	e052                	sd	s4,0(sp)
    8000251c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000251e:	00006597          	auipc	a1,0x6
    80002522:	f3258593          	addi	a1,a1,-206 # 80008450 <syscalls+0xc0>
    80002526:	00015517          	auipc	a0,0x15
    8000252a:	97250513          	addi	a0,a0,-1678 # 80016e98 <bcache>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	214080e7          	jalr	532(ra) # 80006742 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002536:	0001d797          	auipc	a5,0x1d
    8000253a:	96278793          	addi	a5,a5,-1694 # 8001ee98 <bcache+0x8000>
    8000253e:	0001d717          	auipc	a4,0x1d
    80002542:	bc270713          	addi	a4,a4,-1086 # 8001f100 <bcache+0x8268>
    80002546:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000254a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000254e:	00015497          	auipc	s1,0x15
    80002552:	96248493          	addi	s1,s1,-1694 # 80016eb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002556:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002558:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000255a:	00006a17          	auipc	s4,0x6
    8000255e:	efea0a13          	addi	s4,s4,-258 # 80008458 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002562:	2b893783          	ld	a5,696(s2)
    80002566:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002568:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000256c:	85d2                	mv	a1,s4
    8000256e:	01048513          	addi	a0,s1,16
    80002572:	00001097          	auipc	ra,0x1
    80002576:	4bc080e7          	jalr	1212(ra) # 80003a2e <initsleeplock>
    bcache.head.next->prev = b;
    8000257a:	2b893783          	ld	a5,696(s2)
    8000257e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002580:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002584:	45848493          	addi	s1,s1,1112
    80002588:	fd349de3          	bne	s1,s3,80002562 <binit+0x54>
  }
}
    8000258c:	70a2                	ld	ra,40(sp)
    8000258e:	7402                	ld	s0,32(sp)
    80002590:	64e2                	ld	s1,24(sp)
    80002592:	6942                	ld	s2,16(sp)
    80002594:	69a2                	ld	s3,8(sp)
    80002596:	6a02                	ld	s4,0(sp)
    80002598:	6145                	addi	sp,sp,48
    8000259a:	8082                	ret

000000008000259c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000259c:	7179                	addi	sp,sp,-48
    8000259e:	f406                	sd	ra,40(sp)
    800025a0:	f022                	sd	s0,32(sp)
    800025a2:	ec26                	sd	s1,24(sp)
    800025a4:	e84a                	sd	s2,16(sp)
    800025a6:	e44e                	sd	s3,8(sp)
    800025a8:	1800                	addi	s0,sp,48
    800025aa:	89aa                	mv	s3,a0
    800025ac:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800025ae:	00015517          	auipc	a0,0x15
    800025b2:	8ea50513          	addi	a0,a0,-1814 # 80016e98 <bcache>
    800025b6:	00004097          	auipc	ra,0x4
    800025ba:	21c080e7          	jalr	540(ra) # 800067d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025be:	0001d497          	auipc	s1,0x1d
    800025c2:	b924b483          	ld	s1,-1134(s1) # 8001f150 <bcache+0x82b8>
    800025c6:	0001d797          	auipc	a5,0x1d
    800025ca:	b3a78793          	addi	a5,a5,-1222 # 8001f100 <bcache+0x8268>
    800025ce:	02f48f63          	beq	s1,a5,8000260c <bread+0x70>
    800025d2:	873e                	mv	a4,a5
    800025d4:	a021                	j	800025dc <bread+0x40>
    800025d6:	68a4                	ld	s1,80(s1)
    800025d8:	02e48a63          	beq	s1,a4,8000260c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025dc:	449c                	lw	a5,8(s1)
    800025de:	ff379ce3          	bne	a5,s3,800025d6 <bread+0x3a>
    800025e2:	44dc                	lw	a5,12(s1)
    800025e4:	ff2799e3          	bne	a5,s2,800025d6 <bread+0x3a>
      b->refcnt++;
    800025e8:	40bc                	lw	a5,64(s1)
    800025ea:	2785                	addiw	a5,a5,1
    800025ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ee:	00015517          	auipc	a0,0x15
    800025f2:	8aa50513          	addi	a0,a0,-1878 # 80016e98 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	290080e7          	jalr	656(ra) # 80006886 <release>
      acquiresleep(&b->lock);
    800025fe:	01048513          	addi	a0,s1,16
    80002602:	00001097          	auipc	ra,0x1
    80002606:	466080e7          	jalr	1126(ra) # 80003a68 <acquiresleep>
      return b;
    8000260a:	a8b9                	j	80002668 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000260c:	0001d497          	auipc	s1,0x1d
    80002610:	b3c4b483          	ld	s1,-1220(s1) # 8001f148 <bcache+0x82b0>
    80002614:	0001d797          	auipc	a5,0x1d
    80002618:	aec78793          	addi	a5,a5,-1300 # 8001f100 <bcache+0x8268>
    8000261c:	00f48863          	beq	s1,a5,8000262c <bread+0x90>
    80002620:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002622:	40bc                	lw	a5,64(s1)
    80002624:	cf81                	beqz	a5,8000263c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002626:	64a4                	ld	s1,72(s1)
    80002628:	fee49de3          	bne	s1,a4,80002622 <bread+0x86>
  panic("bget: no buffers");
    8000262c:	00006517          	auipc	a0,0x6
    80002630:	e3450513          	addi	a0,a0,-460 # 80008460 <syscalls+0xd0>
    80002634:	00004097          	auipc	ra,0x4
    80002638:	c54080e7          	jalr	-940(ra) # 80006288 <panic>
      b->dev = dev;
    8000263c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002640:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002644:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002648:	4785                	li	a5,1
    8000264a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000264c:	00015517          	auipc	a0,0x15
    80002650:	84c50513          	addi	a0,a0,-1972 # 80016e98 <bcache>
    80002654:	00004097          	auipc	ra,0x4
    80002658:	232080e7          	jalr	562(ra) # 80006886 <release>
      acquiresleep(&b->lock);
    8000265c:	01048513          	addi	a0,s1,16
    80002660:	00001097          	auipc	ra,0x1
    80002664:	408080e7          	jalr	1032(ra) # 80003a68 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002668:	409c                	lw	a5,0(s1)
    8000266a:	cb89                	beqz	a5,8000267c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000266c:	8526                	mv	a0,s1
    8000266e:	70a2                	ld	ra,40(sp)
    80002670:	7402                	ld	s0,32(sp)
    80002672:	64e2                	ld	s1,24(sp)
    80002674:	6942                	ld	s2,16(sp)
    80002676:	69a2                	ld	s3,8(sp)
    80002678:	6145                	addi	sp,sp,48
    8000267a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000267c:	4581                	li	a1,0
    8000267e:	8526                	mv	a0,s1
    80002680:	00003097          	auipc	ra,0x3
    80002684:	346080e7          	jalr	838(ra) # 800059c6 <virtio_disk_rw>
    b->valid = 1;
    80002688:	4785                	li	a5,1
    8000268a:	c09c                	sw	a5,0(s1)
  return b;
    8000268c:	b7c5                	j	8000266c <bread+0xd0>

000000008000268e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000268e:	1101                	addi	sp,sp,-32
    80002690:	ec06                	sd	ra,24(sp)
    80002692:	e822                	sd	s0,16(sp)
    80002694:	e426                	sd	s1,8(sp)
    80002696:	1000                	addi	s0,sp,32
    80002698:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269a:	0541                	addi	a0,a0,16
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	466080e7          	jalr	1126(ra) # 80003b02 <holdingsleep>
    800026a4:	cd01                	beqz	a0,800026bc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026a6:	4585                	li	a1,1
    800026a8:	8526                	mv	a0,s1
    800026aa:	00003097          	auipc	ra,0x3
    800026ae:	31c080e7          	jalr	796(ra) # 800059c6 <virtio_disk_rw>
}
    800026b2:	60e2                	ld	ra,24(sp)
    800026b4:	6442                	ld	s0,16(sp)
    800026b6:	64a2                	ld	s1,8(sp)
    800026b8:	6105                	addi	sp,sp,32
    800026ba:	8082                	ret
    panic("bwrite");
    800026bc:	00006517          	auipc	a0,0x6
    800026c0:	dbc50513          	addi	a0,a0,-580 # 80008478 <syscalls+0xe8>
    800026c4:	00004097          	auipc	ra,0x4
    800026c8:	bc4080e7          	jalr	-1084(ra) # 80006288 <panic>

00000000800026cc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026cc:	1101                	addi	sp,sp,-32
    800026ce:	ec06                	sd	ra,24(sp)
    800026d0:	e822                	sd	s0,16(sp)
    800026d2:	e426                	sd	s1,8(sp)
    800026d4:	e04a                	sd	s2,0(sp)
    800026d6:	1000                	addi	s0,sp,32
    800026d8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026da:	01050913          	addi	s2,a0,16
    800026de:	854a                	mv	a0,s2
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	422080e7          	jalr	1058(ra) # 80003b02 <holdingsleep>
    800026e8:	c92d                	beqz	a0,8000275a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	3d2080e7          	jalr	978(ra) # 80003abe <releasesleep>

  acquire(&bcache.lock);
    800026f4:	00014517          	auipc	a0,0x14
    800026f8:	7a450513          	addi	a0,a0,1956 # 80016e98 <bcache>
    800026fc:	00004097          	auipc	ra,0x4
    80002700:	0d6080e7          	jalr	214(ra) # 800067d2 <acquire>
  b->refcnt--;
    80002704:	40bc                	lw	a5,64(s1)
    80002706:	37fd                	addiw	a5,a5,-1
    80002708:	0007871b          	sext.w	a4,a5
    8000270c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000270e:	eb05                	bnez	a4,8000273e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002710:	68bc                	ld	a5,80(s1)
    80002712:	64b8                	ld	a4,72(s1)
    80002714:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002716:	64bc                	ld	a5,72(s1)
    80002718:	68b8                	ld	a4,80(s1)
    8000271a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000271c:	0001c797          	auipc	a5,0x1c
    80002720:	77c78793          	addi	a5,a5,1916 # 8001ee98 <bcache+0x8000>
    80002724:	2b87b703          	ld	a4,696(a5)
    80002728:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000272a:	0001d717          	auipc	a4,0x1d
    8000272e:	9d670713          	addi	a4,a4,-1578 # 8001f100 <bcache+0x8268>
    80002732:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002734:	2b87b703          	ld	a4,696(a5)
    80002738:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000273a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000273e:	00014517          	auipc	a0,0x14
    80002742:	75a50513          	addi	a0,a0,1882 # 80016e98 <bcache>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	140080e7          	jalr	320(ra) # 80006886 <release>
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6902                	ld	s2,0(sp)
    80002756:	6105                	addi	sp,sp,32
    80002758:	8082                	ret
    panic("brelse");
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	d2650513          	addi	a0,a0,-730 # 80008480 <syscalls+0xf0>
    80002762:	00004097          	auipc	ra,0x4
    80002766:	b26080e7          	jalr	-1242(ra) # 80006288 <panic>

000000008000276a <bpin>:

void
bpin(struct buf *b) {
    8000276a:	1101                	addi	sp,sp,-32
    8000276c:	ec06                	sd	ra,24(sp)
    8000276e:	e822                	sd	s0,16(sp)
    80002770:	e426                	sd	s1,8(sp)
    80002772:	1000                	addi	s0,sp,32
    80002774:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002776:	00014517          	auipc	a0,0x14
    8000277a:	72250513          	addi	a0,a0,1826 # 80016e98 <bcache>
    8000277e:	00004097          	auipc	ra,0x4
    80002782:	054080e7          	jalr	84(ra) # 800067d2 <acquire>
  b->refcnt++;
    80002786:	40bc                	lw	a5,64(s1)
    80002788:	2785                	addiw	a5,a5,1
    8000278a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000278c:	00014517          	auipc	a0,0x14
    80002790:	70c50513          	addi	a0,a0,1804 # 80016e98 <bcache>
    80002794:	00004097          	auipc	ra,0x4
    80002798:	0f2080e7          	jalr	242(ra) # 80006886 <release>
}
    8000279c:	60e2                	ld	ra,24(sp)
    8000279e:	6442                	ld	s0,16(sp)
    800027a0:	64a2                	ld	s1,8(sp)
    800027a2:	6105                	addi	sp,sp,32
    800027a4:	8082                	ret

00000000800027a6 <bunpin>:

void
bunpin(struct buf *b) {
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	1000                	addi	s0,sp,32
    800027b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027b2:	00014517          	auipc	a0,0x14
    800027b6:	6e650513          	addi	a0,a0,1766 # 80016e98 <bcache>
    800027ba:	00004097          	auipc	ra,0x4
    800027be:	018080e7          	jalr	24(ra) # 800067d2 <acquire>
  b->refcnt--;
    800027c2:	40bc                	lw	a5,64(s1)
    800027c4:	37fd                	addiw	a5,a5,-1
    800027c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027c8:	00014517          	auipc	a0,0x14
    800027cc:	6d050513          	addi	a0,a0,1744 # 80016e98 <bcache>
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	0b6080e7          	jalr	182(ra) # 80006886 <release>
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	e04a                	sd	s2,0(sp)
    800027ec:	1000                	addi	s0,sp,32
    800027ee:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027f0:	00d5d59b          	srliw	a1,a1,0xd
    800027f4:	0001d797          	auipc	a5,0x1d
    800027f8:	d807a783          	lw	a5,-640(a5) # 8001f574 <sb+0x1c>
    800027fc:	9dbd                	addw	a1,a1,a5
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	d9e080e7          	jalr	-610(ra) # 8000259c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002806:	0074f713          	andi	a4,s1,7
    8000280a:	4785                	li	a5,1
    8000280c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002810:	14ce                	slli	s1,s1,0x33
    80002812:	90d9                	srli	s1,s1,0x36
    80002814:	00950733          	add	a4,a0,s1
    80002818:	05874703          	lbu	a4,88(a4)
    8000281c:	00e7f6b3          	and	a3,a5,a4
    80002820:	c69d                	beqz	a3,8000284e <bfree+0x6c>
    80002822:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002824:	94aa                	add	s1,s1,a0
    80002826:	fff7c793          	not	a5,a5
    8000282a:	8ff9                	and	a5,a5,a4
    8000282c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002830:	00001097          	auipc	ra,0x1
    80002834:	118080e7          	jalr	280(ra) # 80003948 <log_write>
  brelse(bp);
    80002838:	854a                	mv	a0,s2
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e92080e7          	jalr	-366(ra) # 800026cc <brelse>
}
    80002842:	60e2                	ld	ra,24(sp)
    80002844:	6442                	ld	s0,16(sp)
    80002846:	64a2                	ld	s1,8(sp)
    80002848:	6902                	ld	s2,0(sp)
    8000284a:	6105                	addi	sp,sp,32
    8000284c:	8082                	ret
    panic("freeing free block");
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	c3a50513          	addi	a0,a0,-966 # 80008488 <syscalls+0xf8>
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	a32080e7          	jalr	-1486(ra) # 80006288 <panic>

000000008000285e <balloc>:
{
    8000285e:	711d                	addi	sp,sp,-96
    80002860:	ec86                	sd	ra,88(sp)
    80002862:	e8a2                	sd	s0,80(sp)
    80002864:	e4a6                	sd	s1,72(sp)
    80002866:	e0ca                	sd	s2,64(sp)
    80002868:	fc4e                	sd	s3,56(sp)
    8000286a:	f852                	sd	s4,48(sp)
    8000286c:	f456                	sd	s5,40(sp)
    8000286e:	f05a                	sd	s6,32(sp)
    80002870:	ec5e                	sd	s7,24(sp)
    80002872:	e862                	sd	s8,16(sp)
    80002874:	e466                	sd	s9,8(sp)
    80002876:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002878:	0001d797          	auipc	a5,0x1d
    8000287c:	ce47a783          	lw	a5,-796(a5) # 8001f55c <sb+0x4>
    80002880:	cbd1                	beqz	a5,80002914 <balloc+0xb6>
    80002882:	8baa                	mv	s7,a0
    80002884:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002886:	0001db17          	auipc	s6,0x1d
    8000288a:	cd2b0b13          	addi	s6,s6,-814 # 8001f558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002890:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002892:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002894:	6c89                	lui	s9,0x2
    80002896:	a831                	j	800028b2 <balloc+0x54>
    brelse(bp);
    80002898:	854a                	mv	a0,s2
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	e32080e7          	jalr	-462(ra) # 800026cc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028a2:	015c87bb          	addw	a5,s9,s5
    800028a6:	00078a9b          	sext.w	s5,a5
    800028aa:	004b2703          	lw	a4,4(s6)
    800028ae:	06eaf363          	bgeu	s5,a4,80002914 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028b2:	41fad79b          	sraiw	a5,s5,0x1f
    800028b6:	0137d79b          	srliw	a5,a5,0x13
    800028ba:	015787bb          	addw	a5,a5,s5
    800028be:	40d7d79b          	sraiw	a5,a5,0xd
    800028c2:	01cb2583          	lw	a1,28(s6)
    800028c6:	9dbd                	addw	a1,a1,a5
    800028c8:	855e                	mv	a0,s7
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	cd2080e7          	jalr	-814(ra) # 8000259c <bread>
    800028d2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d4:	004b2503          	lw	a0,4(s6)
    800028d8:	000a849b          	sext.w	s1,s5
    800028dc:	8662                	mv	a2,s8
    800028de:	faa4fde3          	bgeu	s1,a0,80002898 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028e2:	41f6579b          	sraiw	a5,a2,0x1f
    800028e6:	01d7d69b          	srliw	a3,a5,0x1d
    800028ea:	00c6873b          	addw	a4,a3,a2
    800028ee:	00777793          	andi	a5,a4,7
    800028f2:	9f95                	subw	a5,a5,a3
    800028f4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028f8:	4037571b          	sraiw	a4,a4,0x3
    800028fc:	00e906b3          	add	a3,s2,a4
    80002900:	0586c683          	lbu	a3,88(a3)
    80002904:	00d7f5b3          	and	a1,a5,a3
    80002908:	cd91                	beqz	a1,80002924 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000290a:	2605                	addiw	a2,a2,1
    8000290c:	2485                	addiw	s1,s1,1
    8000290e:	fd4618e3          	bne	a2,s4,800028de <balloc+0x80>
    80002912:	b759                	j	80002898 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002914:	00006517          	auipc	a0,0x6
    80002918:	b8c50513          	addi	a0,a0,-1140 # 800084a0 <syscalls+0x110>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	96c080e7          	jalr	-1684(ra) # 80006288 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002924:	974a                	add	a4,a4,s2
    80002926:	8fd5                	or	a5,a5,a3
    80002928:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000292c:	854a                	mv	a0,s2
    8000292e:	00001097          	auipc	ra,0x1
    80002932:	01a080e7          	jalr	26(ra) # 80003948 <log_write>
        brelse(bp);
    80002936:	854a                	mv	a0,s2
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	d94080e7          	jalr	-620(ra) # 800026cc <brelse>
  bp = bread(dev, bno);
    80002940:	85a6                	mv	a1,s1
    80002942:	855e                	mv	a0,s7
    80002944:	00000097          	auipc	ra,0x0
    80002948:	c58080e7          	jalr	-936(ra) # 8000259c <bread>
    8000294c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000294e:	40000613          	li	a2,1024
    80002952:	4581                	li	a1,0
    80002954:	05850513          	addi	a0,a0,88
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	820080e7          	jalr	-2016(ra) # 80000178 <memset>
  log_write(bp);
    80002960:	854a                	mv	a0,s2
    80002962:	00001097          	auipc	ra,0x1
    80002966:	fe6080e7          	jalr	-26(ra) # 80003948 <log_write>
  brelse(bp);
    8000296a:	854a                	mv	a0,s2
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	d60080e7          	jalr	-672(ra) # 800026cc <brelse>
}
    80002974:	8526                	mv	a0,s1
    80002976:	60e6                	ld	ra,88(sp)
    80002978:	6446                	ld	s0,80(sp)
    8000297a:	64a6                	ld	s1,72(sp)
    8000297c:	6906                	ld	s2,64(sp)
    8000297e:	79e2                	ld	s3,56(sp)
    80002980:	7a42                	ld	s4,48(sp)
    80002982:	7aa2                	ld	s5,40(sp)
    80002984:	7b02                	ld	s6,32(sp)
    80002986:	6be2                	ld	s7,24(sp)
    80002988:	6c42                	ld	s8,16(sp)
    8000298a:	6ca2                	ld	s9,8(sp)
    8000298c:	6125                	addi	sp,sp,96
    8000298e:	8082                	ret

0000000080002990 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002990:	7179                	addi	sp,sp,-48
    80002992:	f406                	sd	ra,40(sp)
    80002994:	f022                	sd	s0,32(sp)
    80002996:	ec26                	sd	s1,24(sp)
    80002998:	e84a                	sd	s2,16(sp)
    8000299a:	e44e                	sd	s3,8(sp)
    8000299c:	e052                	sd	s4,0(sp)
    8000299e:	1800                	addi	s0,sp,48
    800029a0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029a2:	47ad                	li	a5,11
    800029a4:	04b7fe63          	bgeu	a5,a1,80002a00 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029a8:	ff45849b          	addiw	s1,a1,-12
    800029ac:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029b0:	0ff00793          	li	a5,255
    800029b4:	0ae7e363          	bltu	a5,a4,80002a5a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029b8:	08052583          	lw	a1,128(a0)
    800029bc:	c5ad                	beqz	a1,80002a26 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029be:	00092503          	lw	a0,0(s2)
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	bda080e7          	jalr	-1062(ra) # 8000259c <bread>
    800029ca:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029cc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029d0:	02049593          	slli	a1,s1,0x20
    800029d4:	9181                	srli	a1,a1,0x20
    800029d6:	058a                	slli	a1,a1,0x2
    800029d8:	00b784b3          	add	s1,a5,a1
    800029dc:	0004a983          	lw	s3,0(s1)
    800029e0:	04098d63          	beqz	s3,80002a3a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029e4:	8552                	mv	a0,s4
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	ce6080e7          	jalr	-794(ra) # 800026cc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029ee:	854e                	mv	a0,s3
    800029f0:	70a2                	ld	ra,40(sp)
    800029f2:	7402                	ld	s0,32(sp)
    800029f4:	64e2                	ld	s1,24(sp)
    800029f6:	6942                	ld	s2,16(sp)
    800029f8:	69a2                	ld	s3,8(sp)
    800029fa:	6a02                	ld	s4,0(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a00:	02059493          	slli	s1,a1,0x20
    80002a04:	9081                	srli	s1,s1,0x20
    80002a06:	048a                	slli	s1,s1,0x2
    80002a08:	94aa                	add	s1,s1,a0
    80002a0a:	0504a983          	lw	s3,80(s1)
    80002a0e:	fe0990e3          	bnez	s3,800029ee <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a12:	4108                	lw	a0,0(a0)
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	e4a080e7          	jalr	-438(ra) # 8000285e <balloc>
    80002a1c:	0005099b          	sext.w	s3,a0
    80002a20:	0534a823          	sw	s3,80(s1)
    80002a24:	b7e9                	j	800029ee <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a26:	4108                	lw	a0,0(a0)
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	e36080e7          	jalr	-458(ra) # 8000285e <balloc>
    80002a30:	0005059b          	sext.w	a1,a0
    80002a34:	08b92023          	sw	a1,128(s2)
    80002a38:	b759                	j	800029be <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a3a:	00092503          	lw	a0,0(s2)
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	e20080e7          	jalr	-480(ra) # 8000285e <balloc>
    80002a46:	0005099b          	sext.w	s3,a0
    80002a4a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a4e:	8552                	mv	a0,s4
    80002a50:	00001097          	auipc	ra,0x1
    80002a54:	ef8080e7          	jalr	-264(ra) # 80003948 <log_write>
    80002a58:	b771                	j	800029e4 <bmap+0x54>
  panic("bmap: out of range");
    80002a5a:	00006517          	auipc	a0,0x6
    80002a5e:	a5e50513          	addi	a0,a0,-1442 # 800084b8 <syscalls+0x128>
    80002a62:	00004097          	auipc	ra,0x4
    80002a66:	826080e7          	jalr	-2010(ra) # 80006288 <panic>

0000000080002a6a <iget>:
{
    80002a6a:	7179                	addi	sp,sp,-48
    80002a6c:	f406                	sd	ra,40(sp)
    80002a6e:	f022                	sd	s0,32(sp)
    80002a70:	ec26                	sd	s1,24(sp)
    80002a72:	e84a                	sd	s2,16(sp)
    80002a74:	e44e                	sd	s3,8(sp)
    80002a76:	e052                	sd	s4,0(sp)
    80002a78:	1800                	addi	s0,sp,48
    80002a7a:	89aa                	mv	s3,a0
    80002a7c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a7e:	0001d517          	auipc	a0,0x1d
    80002a82:	afa50513          	addi	a0,a0,-1286 # 8001f578 <itable>
    80002a86:	00004097          	auipc	ra,0x4
    80002a8a:	d4c080e7          	jalr	-692(ra) # 800067d2 <acquire>
  empty = 0;
    80002a8e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a90:	0001d497          	auipc	s1,0x1d
    80002a94:	b0048493          	addi	s1,s1,-1280 # 8001f590 <itable+0x18>
    80002a98:	0001e697          	auipc	a3,0x1e
    80002a9c:	58868693          	addi	a3,a3,1416 # 80021020 <log>
    80002aa0:	a039                	j	80002aae <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa2:	02090b63          	beqz	s2,80002ad8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aa6:	08848493          	addi	s1,s1,136
    80002aaa:	02d48a63          	beq	s1,a3,80002ade <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aae:	449c                	lw	a5,8(s1)
    80002ab0:	fef059e3          	blez	a5,80002aa2 <iget+0x38>
    80002ab4:	4098                	lw	a4,0(s1)
    80002ab6:	ff3716e3          	bne	a4,s3,80002aa2 <iget+0x38>
    80002aba:	40d8                	lw	a4,4(s1)
    80002abc:	ff4713e3          	bne	a4,s4,80002aa2 <iget+0x38>
      ip->ref++;
    80002ac0:	2785                	addiw	a5,a5,1
    80002ac2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ac4:	0001d517          	auipc	a0,0x1d
    80002ac8:	ab450513          	addi	a0,a0,-1356 # 8001f578 <itable>
    80002acc:	00004097          	auipc	ra,0x4
    80002ad0:	dba080e7          	jalr	-582(ra) # 80006886 <release>
      return ip;
    80002ad4:	8926                	mv	s2,s1
    80002ad6:	a03d                	j	80002b04 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ad8:	f7f9                	bnez	a5,80002aa6 <iget+0x3c>
    80002ada:	8926                	mv	s2,s1
    80002adc:	b7e9                	j	80002aa6 <iget+0x3c>
  if(empty == 0)
    80002ade:	02090c63          	beqz	s2,80002b16 <iget+0xac>
  ip->dev = dev;
    80002ae2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ae6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aea:	4785                	li	a5,1
    80002aec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002af0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002af4:	0001d517          	auipc	a0,0x1d
    80002af8:	a8450513          	addi	a0,a0,-1404 # 8001f578 <itable>
    80002afc:	00004097          	auipc	ra,0x4
    80002b00:	d8a080e7          	jalr	-630(ra) # 80006886 <release>
}
    80002b04:	854a                	mv	a0,s2
    80002b06:	70a2                	ld	ra,40(sp)
    80002b08:	7402                	ld	s0,32(sp)
    80002b0a:	64e2                	ld	s1,24(sp)
    80002b0c:	6942                	ld	s2,16(sp)
    80002b0e:	69a2                	ld	s3,8(sp)
    80002b10:	6a02                	ld	s4,0(sp)
    80002b12:	6145                	addi	sp,sp,48
    80002b14:	8082                	ret
    panic("iget: no inodes");
    80002b16:	00006517          	auipc	a0,0x6
    80002b1a:	9ba50513          	addi	a0,a0,-1606 # 800084d0 <syscalls+0x140>
    80002b1e:	00003097          	auipc	ra,0x3
    80002b22:	76a080e7          	jalr	1898(ra) # 80006288 <panic>

0000000080002b26 <fsinit>:
fsinit(int dev) {
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	e44e                	sd	s3,8(sp)
    80002b32:	1800                	addi	s0,sp,48
    80002b34:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b36:	4585                	li	a1,1
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	a64080e7          	jalr	-1436(ra) # 8000259c <bread>
    80002b40:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b42:	0001d997          	auipc	s3,0x1d
    80002b46:	a1698993          	addi	s3,s3,-1514 # 8001f558 <sb>
    80002b4a:	02000613          	li	a2,32
    80002b4e:	05850593          	addi	a1,a0,88
    80002b52:	854e                	mv	a0,s3
    80002b54:	ffffd097          	auipc	ra,0xffffd
    80002b58:	684080e7          	jalr	1668(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	00000097          	auipc	ra,0x0
    80002b62:	b6e080e7          	jalr	-1170(ra) # 800026cc <brelse>
  if(sb.magic != FSMAGIC)
    80002b66:	0009a703          	lw	a4,0(s3)
    80002b6a:	102037b7          	lui	a5,0x10203
    80002b6e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b72:	02f71263          	bne	a4,a5,80002b96 <fsinit+0x70>
  initlog(dev, &sb);
    80002b76:	0001d597          	auipc	a1,0x1d
    80002b7a:	9e258593          	addi	a1,a1,-1566 # 8001f558 <sb>
    80002b7e:	854a                	mv	a0,s2
    80002b80:	00001097          	auipc	ra,0x1
    80002b84:	b4c080e7          	jalr	-1204(ra) # 800036cc <initlog>
}
    80002b88:	70a2                	ld	ra,40(sp)
    80002b8a:	7402                	ld	s0,32(sp)
    80002b8c:	64e2                	ld	s1,24(sp)
    80002b8e:	6942                	ld	s2,16(sp)
    80002b90:	69a2                	ld	s3,8(sp)
    80002b92:	6145                	addi	sp,sp,48
    80002b94:	8082                	ret
    panic("invalid file system");
    80002b96:	00006517          	auipc	a0,0x6
    80002b9a:	94a50513          	addi	a0,a0,-1718 # 800084e0 <syscalls+0x150>
    80002b9e:	00003097          	auipc	ra,0x3
    80002ba2:	6ea080e7          	jalr	1770(ra) # 80006288 <panic>

0000000080002ba6 <iinit>:
{
    80002ba6:	7179                	addi	sp,sp,-48
    80002ba8:	f406                	sd	ra,40(sp)
    80002baa:	f022                	sd	s0,32(sp)
    80002bac:	ec26                	sd	s1,24(sp)
    80002bae:	e84a                	sd	s2,16(sp)
    80002bb0:	e44e                	sd	s3,8(sp)
    80002bb2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bb4:	00006597          	auipc	a1,0x6
    80002bb8:	94458593          	addi	a1,a1,-1724 # 800084f8 <syscalls+0x168>
    80002bbc:	0001d517          	auipc	a0,0x1d
    80002bc0:	9bc50513          	addi	a0,a0,-1604 # 8001f578 <itable>
    80002bc4:	00004097          	auipc	ra,0x4
    80002bc8:	b7e080e7          	jalr	-1154(ra) # 80006742 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bcc:	0001d497          	auipc	s1,0x1d
    80002bd0:	9d448493          	addi	s1,s1,-1580 # 8001f5a0 <itable+0x28>
    80002bd4:	0001e997          	auipc	s3,0x1e
    80002bd8:	45c98993          	addi	s3,s3,1116 # 80021030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bdc:	00006917          	auipc	s2,0x6
    80002be0:	92490913          	addi	s2,s2,-1756 # 80008500 <syscalls+0x170>
    80002be4:	85ca                	mv	a1,s2
    80002be6:	8526                	mv	a0,s1
    80002be8:	00001097          	auipc	ra,0x1
    80002bec:	e46080e7          	jalr	-442(ra) # 80003a2e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bf0:	08848493          	addi	s1,s1,136
    80002bf4:	ff3498e3          	bne	s1,s3,80002be4 <iinit+0x3e>
}
    80002bf8:	70a2                	ld	ra,40(sp)
    80002bfa:	7402                	ld	s0,32(sp)
    80002bfc:	64e2                	ld	s1,24(sp)
    80002bfe:	6942                	ld	s2,16(sp)
    80002c00:	69a2                	ld	s3,8(sp)
    80002c02:	6145                	addi	sp,sp,48
    80002c04:	8082                	ret

0000000080002c06 <ialloc>:
{
    80002c06:	715d                	addi	sp,sp,-80
    80002c08:	e486                	sd	ra,72(sp)
    80002c0a:	e0a2                	sd	s0,64(sp)
    80002c0c:	fc26                	sd	s1,56(sp)
    80002c0e:	f84a                	sd	s2,48(sp)
    80002c10:	f44e                	sd	s3,40(sp)
    80002c12:	f052                	sd	s4,32(sp)
    80002c14:	ec56                	sd	s5,24(sp)
    80002c16:	e85a                	sd	s6,16(sp)
    80002c18:	e45e                	sd	s7,8(sp)
    80002c1a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c1c:	0001d717          	auipc	a4,0x1d
    80002c20:	94872703          	lw	a4,-1720(a4) # 8001f564 <sb+0xc>
    80002c24:	4785                	li	a5,1
    80002c26:	04e7fa63          	bgeu	a5,a4,80002c7a <ialloc+0x74>
    80002c2a:	8aaa                	mv	s5,a0
    80002c2c:	8bae                	mv	s7,a1
    80002c2e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c30:	0001da17          	auipc	s4,0x1d
    80002c34:	928a0a13          	addi	s4,s4,-1752 # 8001f558 <sb>
    80002c38:	00048b1b          	sext.w	s6,s1
    80002c3c:	0044d593          	srli	a1,s1,0x4
    80002c40:	018a2783          	lw	a5,24(s4)
    80002c44:	9dbd                	addw	a1,a1,a5
    80002c46:	8556                	mv	a0,s5
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	954080e7          	jalr	-1708(ra) # 8000259c <bread>
    80002c50:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c52:	05850993          	addi	s3,a0,88
    80002c56:	00f4f793          	andi	a5,s1,15
    80002c5a:	079a                	slli	a5,a5,0x6
    80002c5c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c5e:	00099783          	lh	a5,0(s3)
    80002c62:	c785                	beqz	a5,80002c8a <ialloc+0x84>
    brelse(bp);
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	a68080e7          	jalr	-1432(ra) # 800026cc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c6c:	0485                	addi	s1,s1,1
    80002c6e:	00ca2703          	lw	a4,12(s4)
    80002c72:	0004879b          	sext.w	a5,s1
    80002c76:	fce7e1e3          	bltu	a5,a4,80002c38 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c7a:	00006517          	auipc	a0,0x6
    80002c7e:	88e50513          	addi	a0,a0,-1906 # 80008508 <syscalls+0x178>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	606080e7          	jalr	1542(ra) # 80006288 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c8a:	04000613          	li	a2,64
    80002c8e:	4581                	li	a1,0
    80002c90:	854e                	mv	a0,s3
    80002c92:	ffffd097          	auipc	ra,0xffffd
    80002c96:	4e6080e7          	jalr	1254(ra) # 80000178 <memset>
      dip->type = type;
    80002c9a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	00001097          	auipc	ra,0x1
    80002ca4:	ca8080e7          	jalr	-856(ra) # 80003948 <log_write>
      brelse(bp);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	a22080e7          	jalr	-1502(ra) # 800026cc <brelse>
      return iget(dev, inum);
    80002cb2:	85da                	mv	a1,s6
    80002cb4:	8556                	mv	a0,s5
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	db4080e7          	jalr	-588(ra) # 80002a6a <iget>
}
    80002cbe:	60a6                	ld	ra,72(sp)
    80002cc0:	6406                	ld	s0,64(sp)
    80002cc2:	74e2                	ld	s1,56(sp)
    80002cc4:	7942                	ld	s2,48(sp)
    80002cc6:	79a2                	ld	s3,40(sp)
    80002cc8:	7a02                	ld	s4,32(sp)
    80002cca:	6ae2                	ld	s5,24(sp)
    80002ccc:	6b42                	ld	s6,16(sp)
    80002cce:	6ba2                	ld	s7,8(sp)
    80002cd0:	6161                	addi	sp,sp,80
    80002cd2:	8082                	ret

0000000080002cd4 <iupdate>:
{
    80002cd4:	1101                	addi	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	e04a                	sd	s2,0(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce2:	415c                	lw	a5,4(a0)
    80002ce4:	0047d79b          	srliw	a5,a5,0x4
    80002ce8:	0001d597          	auipc	a1,0x1d
    80002cec:	8885a583          	lw	a1,-1912(a1) # 8001f570 <sb+0x18>
    80002cf0:	9dbd                	addw	a1,a1,a5
    80002cf2:	4108                	lw	a0,0(a0)
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	8a8080e7          	jalr	-1880(ra) # 8000259c <bread>
    80002cfc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cfe:	05850793          	addi	a5,a0,88
    80002d02:	40c8                	lw	a0,4(s1)
    80002d04:	893d                	andi	a0,a0,15
    80002d06:	051a                	slli	a0,a0,0x6
    80002d08:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d0a:	04449703          	lh	a4,68(s1)
    80002d0e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d12:	04649703          	lh	a4,70(s1)
    80002d16:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d1a:	04849703          	lh	a4,72(s1)
    80002d1e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d22:	04a49703          	lh	a4,74(s1)
    80002d26:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d2a:	44f8                	lw	a4,76(s1)
    80002d2c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d2e:	03400613          	li	a2,52
    80002d32:	05048593          	addi	a1,s1,80
    80002d36:	0531                	addi	a0,a0,12
    80002d38:	ffffd097          	auipc	ra,0xffffd
    80002d3c:	4a0080e7          	jalr	1184(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d40:	854a                	mv	a0,s2
    80002d42:	00001097          	auipc	ra,0x1
    80002d46:	c06080e7          	jalr	-1018(ra) # 80003948 <log_write>
  brelse(bp);
    80002d4a:	854a                	mv	a0,s2
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	980080e7          	jalr	-1664(ra) # 800026cc <brelse>
}
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	6902                	ld	s2,0(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <idup>:
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	1000                	addi	s0,sp,32
    80002d6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d6c:	0001d517          	auipc	a0,0x1d
    80002d70:	80c50513          	addi	a0,a0,-2036 # 8001f578 <itable>
    80002d74:	00004097          	auipc	ra,0x4
    80002d78:	a5e080e7          	jalr	-1442(ra) # 800067d2 <acquire>
  ip->ref++;
    80002d7c:	449c                	lw	a5,8(s1)
    80002d7e:	2785                	addiw	a5,a5,1
    80002d80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d82:	0001c517          	auipc	a0,0x1c
    80002d86:	7f650513          	addi	a0,a0,2038 # 8001f578 <itable>
    80002d8a:	00004097          	auipc	ra,0x4
    80002d8e:	afc080e7          	jalr	-1284(ra) # 80006886 <release>
}
    80002d92:	8526                	mv	a0,s1
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6105                	addi	sp,sp,32
    80002d9c:	8082                	ret

0000000080002d9e <ilock>:
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	e04a                	sd	s2,0(sp)
    80002da8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002daa:	c115                	beqz	a0,80002dce <ilock+0x30>
    80002dac:	84aa                	mv	s1,a0
    80002dae:	451c                	lw	a5,8(a0)
    80002db0:	00f05f63          	blez	a5,80002dce <ilock+0x30>
  acquiresleep(&ip->lock);
    80002db4:	0541                	addi	a0,a0,16
    80002db6:	00001097          	auipc	ra,0x1
    80002dba:	cb2080e7          	jalr	-846(ra) # 80003a68 <acquiresleep>
  if(ip->valid == 0){
    80002dbe:	40bc                	lw	a5,64(s1)
    80002dc0:	cf99                	beqz	a5,80002dde <ilock+0x40>
}
    80002dc2:	60e2                	ld	ra,24(sp)
    80002dc4:	6442                	ld	s0,16(sp)
    80002dc6:	64a2                	ld	s1,8(sp)
    80002dc8:	6902                	ld	s2,0(sp)
    80002dca:	6105                	addi	sp,sp,32
    80002dcc:	8082                	ret
    panic("ilock");
    80002dce:	00005517          	auipc	a0,0x5
    80002dd2:	75250513          	addi	a0,a0,1874 # 80008520 <syscalls+0x190>
    80002dd6:	00003097          	auipc	ra,0x3
    80002dda:	4b2080e7          	jalr	1202(ra) # 80006288 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dde:	40dc                	lw	a5,4(s1)
    80002de0:	0047d79b          	srliw	a5,a5,0x4
    80002de4:	0001c597          	auipc	a1,0x1c
    80002de8:	78c5a583          	lw	a1,1932(a1) # 8001f570 <sb+0x18>
    80002dec:	9dbd                	addw	a1,a1,a5
    80002dee:	4088                	lw	a0,0(s1)
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	7ac080e7          	jalr	1964(ra) # 8000259c <bread>
    80002df8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dfa:	05850593          	addi	a1,a0,88
    80002dfe:	40dc                	lw	a5,4(s1)
    80002e00:	8bbd                	andi	a5,a5,15
    80002e02:	079a                	slli	a5,a5,0x6
    80002e04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e06:	00059783          	lh	a5,0(a1)
    80002e0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e0e:	00259783          	lh	a5,2(a1)
    80002e12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e16:	00459783          	lh	a5,4(a1)
    80002e1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e1e:	00659783          	lh	a5,6(a1)
    80002e22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e26:	459c                	lw	a5,8(a1)
    80002e28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e2a:	03400613          	li	a2,52
    80002e2e:	05b1                	addi	a1,a1,12
    80002e30:	05048513          	addi	a0,s1,80
    80002e34:	ffffd097          	auipc	ra,0xffffd
    80002e38:	3a4080e7          	jalr	932(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	88e080e7          	jalr	-1906(ra) # 800026cc <brelse>
    ip->valid = 1;
    80002e46:	4785                	li	a5,1
    80002e48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e4a:	04449783          	lh	a5,68(s1)
    80002e4e:	fbb5                	bnez	a5,80002dc2 <ilock+0x24>
      panic("ilock: no type");
    80002e50:	00005517          	auipc	a0,0x5
    80002e54:	6d850513          	addi	a0,a0,1752 # 80008528 <syscalls+0x198>
    80002e58:	00003097          	auipc	ra,0x3
    80002e5c:	430080e7          	jalr	1072(ra) # 80006288 <panic>

0000000080002e60 <iunlock>:
{
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	e426                	sd	s1,8(sp)
    80002e68:	e04a                	sd	s2,0(sp)
    80002e6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e6c:	c905                	beqz	a0,80002e9c <iunlock+0x3c>
    80002e6e:	84aa                	mv	s1,a0
    80002e70:	01050913          	addi	s2,a0,16
    80002e74:	854a                	mv	a0,s2
    80002e76:	00001097          	auipc	ra,0x1
    80002e7a:	c8c080e7          	jalr	-884(ra) # 80003b02 <holdingsleep>
    80002e7e:	cd19                	beqz	a0,80002e9c <iunlock+0x3c>
    80002e80:	449c                	lw	a5,8(s1)
    80002e82:	00f05d63          	blez	a5,80002e9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e86:	854a                	mv	a0,s2
    80002e88:	00001097          	auipc	ra,0x1
    80002e8c:	c36080e7          	jalr	-970(ra) # 80003abe <releasesleep>
}
    80002e90:	60e2                	ld	ra,24(sp)
    80002e92:	6442                	ld	s0,16(sp)
    80002e94:	64a2                	ld	s1,8(sp)
    80002e96:	6902                	ld	s2,0(sp)
    80002e98:	6105                	addi	sp,sp,32
    80002e9a:	8082                	ret
    panic("iunlock");
    80002e9c:	00005517          	auipc	a0,0x5
    80002ea0:	69c50513          	addi	a0,a0,1692 # 80008538 <syscalls+0x1a8>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	3e4080e7          	jalr	996(ra) # 80006288 <panic>

0000000080002eac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eac:	7179                	addi	sp,sp,-48
    80002eae:	f406                	sd	ra,40(sp)
    80002eb0:	f022                	sd	s0,32(sp)
    80002eb2:	ec26                	sd	s1,24(sp)
    80002eb4:	e84a                	sd	s2,16(sp)
    80002eb6:	e44e                	sd	s3,8(sp)
    80002eb8:	e052                	sd	s4,0(sp)
    80002eba:	1800                	addi	s0,sp,48
    80002ebc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ebe:	05050493          	addi	s1,a0,80
    80002ec2:	08050913          	addi	s2,a0,128
    80002ec6:	a021                	j	80002ece <itrunc+0x22>
    80002ec8:	0491                	addi	s1,s1,4
    80002eca:	01248d63          	beq	s1,s2,80002ee4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ece:	408c                	lw	a1,0(s1)
    80002ed0:	dde5                	beqz	a1,80002ec8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ed2:	0009a503          	lw	a0,0(s3)
    80002ed6:	00000097          	auipc	ra,0x0
    80002eda:	90c080e7          	jalr	-1780(ra) # 800027e2 <bfree>
      ip->addrs[i] = 0;
    80002ede:	0004a023          	sw	zero,0(s1)
    80002ee2:	b7dd                	j	80002ec8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ee4:	0809a583          	lw	a1,128(s3)
    80002ee8:	e185                	bnez	a1,80002f08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eee:	854e                	mv	a0,s3
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	de4080e7          	jalr	-540(ra) # 80002cd4 <iupdate>
}
    80002ef8:	70a2                	ld	ra,40(sp)
    80002efa:	7402                	ld	s0,32(sp)
    80002efc:	64e2                	ld	s1,24(sp)
    80002efe:	6942                	ld	s2,16(sp)
    80002f00:	69a2                	ld	s3,8(sp)
    80002f02:	6a02                	ld	s4,0(sp)
    80002f04:	6145                	addi	sp,sp,48
    80002f06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f08:	0009a503          	lw	a0,0(s3)
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	690080e7          	jalr	1680(ra) # 8000259c <bread>
    80002f14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f16:	05850493          	addi	s1,a0,88
    80002f1a:	45850913          	addi	s2,a0,1112
    80002f1e:	a811                	j	80002f32 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f20:	0009a503          	lw	a0,0(s3)
    80002f24:	00000097          	auipc	ra,0x0
    80002f28:	8be080e7          	jalr	-1858(ra) # 800027e2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f2c:	0491                	addi	s1,s1,4
    80002f2e:	01248563          	beq	s1,s2,80002f38 <itrunc+0x8c>
      if(a[j])
    80002f32:	408c                	lw	a1,0(s1)
    80002f34:	dde5                	beqz	a1,80002f2c <itrunc+0x80>
    80002f36:	b7ed                	j	80002f20 <itrunc+0x74>
    brelse(bp);
    80002f38:	8552                	mv	a0,s4
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	792080e7          	jalr	1938(ra) # 800026cc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f42:	0809a583          	lw	a1,128(s3)
    80002f46:	0009a503          	lw	a0,0(s3)
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	898080e7          	jalr	-1896(ra) # 800027e2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f52:	0809a023          	sw	zero,128(s3)
    80002f56:	bf51                	j	80002eea <itrunc+0x3e>

0000000080002f58 <iput>:
{
    80002f58:	1101                	addi	sp,sp,-32
    80002f5a:	ec06                	sd	ra,24(sp)
    80002f5c:	e822                	sd	s0,16(sp)
    80002f5e:	e426                	sd	s1,8(sp)
    80002f60:	e04a                	sd	s2,0(sp)
    80002f62:	1000                	addi	s0,sp,32
    80002f64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f66:	0001c517          	auipc	a0,0x1c
    80002f6a:	61250513          	addi	a0,a0,1554 # 8001f578 <itable>
    80002f6e:	00004097          	auipc	ra,0x4
    80002f72:	864080e7          	jalr	-1948(ra) # 800067d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f76:	4498                	lw	a4,8(s1)
    80002f78:	4785                	li	a5,1
    80002f7a:	02f70363          	beq	a4,a5,80002fa0 <iput+0x48>
  ip->ref--;
    80002f7e:	449c                	lw	a5,8(s1)
    80002f80:	37fd                	addiw	a5,a5,-1
    80002f82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f84:	0001c517          	auipc	a0,0x1c
    80002f88:	5f450513          	addi	a0,a0,1524 # 8001f578 <itable>
    80002f8c:	00004097          	auipc	ra,0x4
    80002f90:	8fa080e7          	jalr	-1798(ra) # 80006886 <release>
}
    80002f94:	60e2                	ld	ra,24(sp)
    80002f96:	6442                	ld	s0,16(sp)
    80002f98:	64a2                	ld	s1,8(sp)
    80002f9a:	6902                	ld	s2,0(sp)
    80002f9c:	6105                	addi	sp,sp,32
    80002f9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa0:	40bc                	lw	a5,64(s1)
    80002fa2:	dff1                	beqz	a5,80002f7e <iput+0x26>
    80002fa4:	04a49783          	lh	a5,74(s1)
    80002fa8:	fbf9                	bnez	a5,80002f7e <iput+0x26>
    acquiresleep(&ip->lock);
    80002faa:	01048913          	addi	s2,s1,16
    80002fae:	854a                	mv	a0,s2
    80002fb0:	00001097          	auipc	ra,0x1
    80002fb4:	ab8080e7          	jalr	-1352(ra) # 80003a68 <acquiresleep>
    release(&itable.lock);
    80002fb8:	0001c517          	auipc	a0,0x1c
    80002fbc:	5c050513          	addi	a0,a0,1472 # 8001f578 <itable>
    80002fc0:	00004097          	auipc	ra,0x4
    80002fc4:	8c6080e7          	jalr	-1850(ra) # 80006886 <release>
    itrunc(ip);
    80002fc8:	8526                	mv	a0,s1
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	ee2080e7          	jalr	-286(ra) # 80002eac <itrunc>
    ip->type = 0;
    80002fd2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	cfc080e7          	jalr	-772(ra) # 80002cd4 <iupdate>
    ip->valid = 0;
    80002fe0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	00001097          	auipc	ra,0x1
    80002fea:	ad8080e7          	jalr	-1320(ra) # 80003abe <releasesleep>
    acquire(&itable.lock);
    80002fee:	0001c517          	auipc	a0,0x1c
    80002ff2:	58a50513          	addi	a0,a0,1418 # 8001f578 <itable>
    80002ff6:	00003097          	auipc	ra,0x3
    80002ffa:	7dc080e7          	jalr	2012(ra) # 800067d2 <acquire>
    80002ffe:	b741                	j	80002f7e <iput+0x26>

0000000080003000 <iunlockput>:
{
    80003000:	1101                	addi	sp,sp,-32
    80003002:	ec06                	sd	ra,24(sp)
    80003004:	e822                	sd	s0,16(sp)
    80003006:	e426                	sd	s1,8(sp)
    80003008:	1000                	addi	s0,sp,32
    8000300a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	e54080e7          	jalr	-428(ra) # 80002e60 <iunlock>
  iput(ip);
    80003014:	8526                	mv	a0,s1
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	f42080e7          	jalr	-190(ra) # 80002f58 <iput>
}
    8000301e:	60e2                	ld	ra,24(sp)
    80003020:	6442                	ld	s0,16(sp)
    80003022:	64a2                	ld	s1,8(sp)
    80003024:	6105                	addi	sp,sp,32
    80003026:	8082                	ret

0000000080003028 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003028:	1141                	addi	sp,sp,-16
    8000302a:	e422                	sd	s0,8(sp)
    8000302c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000302e:	411c                	lw	a5,0(a0)
    80003030:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003032:	415c                	lw	a5,4(a0)
    80003034:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003036:	04451783          	lh	a5,68(a0)
    8000303a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000303e:	04a51783          	lh	a5,74(a0)
    80003042:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003046:	04c56783          	lwu	a5,76(a0)
    8000304a:	e99c                	sd	a5,16(a1)
}
    8000304c:	6422                	ld	s0,8(sp)
    8000304e:	0141                	addi	sp,sp,16
    80003050:	8082                	ret

0000000080003052 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003052:	457c                	lw	a5,76(a0)
    80003054:	0ed7e963          	bltu	a5,a3,80003146 <readi+0xf4>
{
    80003058:	7159                	addi	sp,sp,-112
    8000305a:	f486                	sd	ra,104(sp)
    8000305c:	f0a2                	sd	s0,96(sp)
    8000305e:	eca6                	sd	s1,88(sp)
    80003060:	e8ca                	sd	s2,80(sp)
    80003062:	e4ce                	sd	s3,72(sp)
    80003064:	e0d2                	sd	s4,64(sp)
    80003066:	fc56                	sd	s5,56(sp)
    80003068:	f85a                	sd	s6,48(sp)
    8000306a:	f45e                	sd	s7,40(sp)
    8000306c:	f062                	sd	s8,32(sp)
    8000306e:	ec66                	sd	s9,24(sp)
    80003070:	e86a                	sd	s10,16(sp)
    80003072:	e46e                	sd	s11,8(sp)
    80003074:	1880                	addi	s0,sp,112
    80003076:	8baa                	mv	s7,a0
    80003078:	8c2e                	mv	s8,a1
    8000307a:	8ab2                	mv	s5,a2
    8000307c:	84b6                	mv	s1,a3
    8000307e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003080:	9f35                	addw	a4,a4,a3
    return 0;
    80003082:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003084:	0ad76063          	bltu	a4,a3,80003124 <readi+0xd2>
  if(off + n > ip->size)
    80003088:	00e7f463          	bgeu	a5,a4,80003090 <readi+0x3e>
    n = ip->size - off;
    8000308c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003090:	0a0b0963          	beqz	s6,80003142 <readi+0xf0>
    80003094:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003096:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000309a:	5cfd                	li	s9,-1
    8000309c:	a82d                	j	800030d6 <readi+0x84>
    8000309e:	020a1d93          	slli	s11,s4,0x20
    800030a2:	020ddd93          	srli	s11,s11,0x20
    800030a6:	05890613          	addi	a2,s2,88
    800030aa:	86ee                	mv	a3,s11
    800030ac:	963a                	add	a2,a2,a4
    800030ae:	85d6                	mv	a1,s5
    800030b0:	8562                	mv	a0,s8
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	9c4080e7          	jalr	-1596(ra) # 80001a76 <either_copyout>
    800030ba:	05950d63          	beq	a0,s9,80003114 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030be:	854a                	mv	a0,s2
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	60c080e7          	jalr	1548(ra) # 800026cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030c8:	013a09bb          	addw	s3,s4,s3
    800030cc:	009a04bb          	addw	s1,s4,s1
    800030d0:	9aee                	add	s5,s5,s11
    800030d2:	0569f763          	bgeu	s3,s6,80003120 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030d6:	000ba903          	lw	s2,0(s7)
    800030da:	00a4d59b          	srliw	a1,s1,0xa
    800030de:	855e                	mv	a0,s7
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	8b0080e7          	jalr	-1872(ra) # 80002990 <bmap>
    800030e8:	0005059b          	sext.w	a1,a0
    800030ec:	854a                	mv	a0,s2
    800030ee:	fffff097          	auipc	ra,0xfffff
    800030f2:	4ae080e7          	jalr	1198(ra) # 8000259c <bread>
    800030f6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f8:	3ff4f713          	andi	a4,s1,1023
    800030fc:	40ed07bb          	subw	a5,s10,a4
    80003100:	413b06bb          	subw	a3,s6,s3
    80003104:	8a3e                	mv	s4,a5
    80003106:	2781                	sext.w	a5,a5
    80003108:	0006861b          	sext.w	a2,a3
    8000310c:	f8f679e3          	bgeu	a2,a5,8000309e <readi+0x4c>
    80003110:	8a36                	mv	s4,a3
    80003112:	b771                	j	8000309e <readi+0x4c>
      brelse(bp);
    80003114:	854a                	mv	a0,s2
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	5b6080e7          	jalr	1462(ra) # 800026cc <brelse>
      tot = -1;
    8000311e:	59fd                	li	s3,-1
  }
  return tot;
    80003120:	0009851b          	sext.w	a0,s3
}
    80003124:	70a6                	ld	ra,104(sp)
    80003126:	7406                	ld	s0,96(sp)
    80003128:	64e6                	ld	s1,88(sp)
    8000312a:	6946                	ld	s2,80(sp)
    8000312c:	69a6                	ld	s3,72(sp)
    8000312e:	6a06                	ld	s4,64(sp)
    80003130:	7ae2                	ld	s5,56(sp)
    80003132:	7b42                	ld	s6,48(sp)
    80003134:	7ba2                	ld	s7,40(sp)
    80003136:	7c02                	ld	s8,32(sp)
    80003138:	6ce2                	ld	s9,24(sp)
    8000313a:	6d42                	ld	s10,16(sp)
    8000313c:	6da2                	ld	s11,8(sp)
    8000313e:	6165                	addi	sp,sp,112
    80003140:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003142:	89da                	mv	s3,s6
    80003144:	bff1                	j	80003120 <readi+0xce>
    return 0;
    80003146:	4501                	li	a0,0
}
    80003148:	8082                	ret

000000008000314a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000314a:	457c                	lw	a5,76(a0)
    8000314c:	10d7e863          	bltu	a5,a3,8000325c <writei+0x112>
{
    80003150:	7159                	addi	sp,sp,-112
    80003152:	f486                	sd	ra,104(sp)
    80003154:	f0a2                	sd	s0,96(sp)
    80003156:	eca6                	sd	s1,88(sp)
    80003158:	e8ca                	sd	s2,80(sp)
    8000315a:	e4ce                	sd	s3,72(sp)
    8000315c:	e0d2                	sd	s4,64(sp)
    8000315e:	fc56                	sd	s5,56(sp)
    80003160:	f85a                	sd	s6,48(sp)
    80003162:	f45e                	sd	s7,40(sp)
    80003164:	f062                	sd	s8,32(sp)
    80003166:	ec66                	sd	s9,24(sp)
    80003168:	e86a                	sd	s10,16(sp)
    8000316a:	e46e                	sd	s11,8(sp)
    8000316c:	1880                	addi	s0,sp,112
    8000316e:	8b2a                	mv	s6,a0
    80003170:	8c2e                	mv	s8,a1
    80003172:	8ab2                	mv	s5,a2
    80003174:	8936                	mv	s2,a3
    80003176:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003178:	00e687bb          	addw	a5,a3,a4
    8000317c:	0ed7e263          	bltu	a5,a3,80003260 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003180:	00043737          	lui	a4,0x43
    80003184:	0ef76063          	bltu	a4,a5,80003264 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003188:	0c0b8863          	beqz	s7,80003258 <writei+0x10e>
    8000318c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000318e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003192:	5cfd                	li	s9,-1
    80003194:	a091                	j	800031d8 <writei+0x8e>
    80003196:	02099d93          	slli	s11,s3,0x20
    8000319a:	020ddd93          	srli	s11,s11,0x20
    8000319e:	05848513          	addi	a0,s1,88
    800031a2:	86ee                	mv	a3,s11
    800031a4:	8656                	mv	a2,s5
    800031a6:	85e2                	mv	a1,s8
    800031a8:	953a                	add	a0,a0,a4
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	922080e7          	jalr	-1758(ra) # 80001acc <either_copyin>
    800031b2:	07950263          	beq	a0,s9,80003216 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031b6:	8526                	mv	a0,s1
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	790080e7          	jalr	1936(ra) # 80003948 <log_write>
    brelse(bp);
    800031c0:	8526                	mv	a0,s1
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	50a080e7          	jalr	1290(ra) # 800026cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ca:	01498a3b          	addw	s4,s3,s4
    800031ce:	0129893b          	addw	s2,s3,s2
    800031d2:	9aee                	add	s5,s5,s11
    800031d4:	057a7663          	bgeu	s4,s7,80003220 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031d8:	000b2483          	lw	s1,0(s6)
    800031dc:	00a9559b          	srliw	a1,s2,0xa
    800031e0:	855a                	mv	a0,s6
    800031e2:	fffff097          	auipc	ra,0xfffff
    800031e6:	7ae080e7          	jalr	1966(ra) # 80002990 <bmap>
    800031ea:	0005059b          	sext.w	a1,a0
    800031ee:	8526                	mv	a0,s1
    800031f0:	fffff097          	auipc	ra,0xfffff
    800031f4:	3ac080e7          	jalr	940(ra) # 8000259c <bread>
    800031f8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031fa:	3ff97713          	andi	a4,s2,1023
    800031fe:	40ed07bb          	subw	a5,s10,a4
    80003202:	414b86bb          	subw	a3,s7,s4
    80003206:	89be                	mv	s3,a5
    80003208:	2781                	sext.w	a5,a5
    8000320a:	0006861b          	sext.w	a2,a3
    8000320e:	f8f674e3          	bgeu	a2,a5,80003196 <writei+0x4c>
    80003212:	89b6                	mv	s3,a3
    80003214:	b749                	j	80003196 <writei+0x4c>
      brelse(bp);
    80003216:	8526                	mv	a0,s1
    80003218:	fffff097          	auipc	ra,0xfffff
    8000321c:	4b4080e7          	jalr	1204(ra) # 800026cc <brelse>
  }

  if(off > ip->size)
    80003220:	04cb2783          	lw	a5,76(s6)
    80003224:	0127f463          	bgeu	a5,s2,8000322c <writei+0xe2>
    ip->size = off;
    80003228:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000322c:	855a                	mv	a0,s6
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	aa6080e7          	jalr	-1370(ra) # 80002cd4 <iupdate>

  return tot;
    80003236:	000a051b          	sext.w	a0,s4
}
    8000323a:	70a6                	ld	ra,104(sp)
    8000323c:	7406                	ld	s0,96(sp)
    8000323e:	64e6                	ld	s1,88(sp)
    80003240:	6946                	ld	s2,80(sp)
    80003242:	69a6                	ld	s3,72(sp)
    80003244:	6a06                	ld	s4,64(sp)
    80003246:	7ae2                	ld	s5,56(sp)
    80003248:	7b42                	ld	s6,48(sp)
    8000324a:	7ba2                	ld	s7,40(sp)
    8000324c:	7c02                	ld	s8,32(sp)
    8000324e:	6ce2                	ld	s9,24(sp)
    80003250:	6d42                	ld	s10,16(sp)
    80003252:	6da2                	ld	s11,8(sp)
    80003254:	6165                	addi	sp,sp,112
    80003256:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003258:	8a5e                	mv	s4,s7
    8000325a:	bfc9                	j	8000322c <writei+0xe2>
    return -1;
    8000325c:	557d                	li	a0,-1
}
    8000325e:	8082                	ret
    return -1;
    80003260:	557d                	li	a0,-1
    80003262:	bfe1                	j	8000323a <writei+0xf0>
    return -1;
    80003264:	557d                	li	a0,-1
    80003266:	bfd1                	j	8000323a <writei+0xf0>

0000000080003268 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003268:	1141                	addi	sp,sp,-16
    8000326a:	e406                	sd	ra,8(sp)
    8000326c:	e022                	sd	s0,0(sp)
    8000326e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003270:	4639                	li	a2,14
    80003272:	ffffd097          	auipc	ra,0xffffd
    80003276:	fde080e7          	jalr	-34(ra) # 80000250 <strncmp>
}
    8000327a:	60a2                	ld	ra,8(sp)
    8000327c:	6402                	ld	s0,0(sp)
    8000327e:	0141                	addi	sp,sp,16
    80003280:	8082                	ret

0000000080003282 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003282:	7139                	addi	sp,sp,-64
    80003284:	fc06                	sd	ra,56(sp)
    80003286:	f822                	sd	s0,48(sp)
    80003288:	f426                	sd	s1,40(sp)
    8000328a:	f04a                	sd	s2,32(sp)
    8000328c:	ec4e                	sd	s3,24(sp)
    8000328e:	e852                	sd	s4,16(sp)
    80003290:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003292:	04451703          	lh	a4,68(a0)
    80003296:	4785                	li	a5,1
    80003298:	00f71a63          	bne	a4,a5,800032ac <dirlookup+0x2a>
    8000329c:	892a                	mv	s2,a0
    8000329e:	89ae                	mv	s3,a1
    800032a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a2:	457c                	lw	a5,76(a0)
    800032a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a8:	e79d                	bnez	a5,800032d6 <dirlookup+0x54>
    800032aa:	a8a5                	j	80003322 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032ac:	00005517          	auipc	a0,0x5
    800032b0:	29450513          	addi	a0,a0,660 # 80008540 <syscalls+0x1b0>
    800032b4:	00003097          	auipc	ra,0x3
    800032b8:	fd4080e7          	jalr	-44(ra) # 80006288 <panic>
      panic("dirlookup read");
    800032bc:	00005517          	auipc	a0,0x5
    800032c0:	29c50513          	addi	a0,a0,668 # 80008558 <syscalls+0x1c8>
    800032c4:	00003097          	auipc	ra,0x3
    800032c8:	fc4080e7          	jalr	-60(ra) # 80006288 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032cc:	24c1                	addiw	s1,s1,16
    800032ce:	04c92783          	lw	a5,76(s2)
    800032d2:	04f4f763          	bgeu	s1,a5,80003320 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d6:	4741                	li	a4,16
    800032d8:	86a6                	mv	a3,s1
    800032da:	fc040613          	addi	a2,s0,-64
    800032de:	4581                	li	a1,0
    800032e0:	854a                	mv	a0,s2
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	d70080e7          	jalr	-656(ra) # 80003052 <readi>
    800032ea:	47c1                	li	a5,16
    800032ec:	fcf518e3          	bne	a0,a5,800032bc <dirlookup+0x3a>
    if(de.inum == 0)
    800032f0:	fc045783          	lhu	a5,-64(s0)
    800032f4:	dfe1                	beqz	a5,800032cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032f6:	fc240593          	addi	a1,s0,-62
    800032fa:	854e                	mv	a0,s3
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	f6c080e7          	jalr	-148(ra) # 80003268 <namecmp>
    80003304:	f561                	bnez	a0,800032cc <dirlookup+0x4a>
      if(poff)
    80003306:	000a0463          	beqz	s4,8000330e <dirlookup+0x8c>
        *poff = off;
    8000330a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000330e:	fc045583          	lhu	a1,-64(s0)
    80003312:	00092503          	lw	a0,0(s2)
    80003316:	fffff097          	auipc	ra,0xfffff
    8000331a:	754080e7          	jalr	1876(ra) # 80002a6a <iget>
    8000331e:	a011                	j	80003322 <dirlookup+0xa0>
  return 0;
    80003320:	4501                	li	a0,0
}
    80003322:	70e2                	ld	ra,56(sp)
    80003324:	7442                	ld	s0,48(sp)
    80003326:	74a2                	ld	s1,40(sp)
    80003328:	7902                	ld	s2,32(sp)
    8000332a:	69e2                	ld	s3,24(sp)
    8000332c:	6a42                	ld	s4,16(sp)
    8000332e:	6121                	addi	sp,sp,64
    80003330:	8082                	ret

0000000080003332 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003332:	711d                	addi	sp,sp,-96
    80003334:	ec86                	sd	ra,88(sp)
    80003336:	e8a2                	sd	s0,80(sp)
    80003338:	e4a6                	sd	s1,72(sp)
    8000333a:	e0ca                	sd	s2,64(sp)
    8000333c:	fc4e                	sd	s3,56(sp)
    8000333e:	f852                	sd	s4,48(sp)
    80003340:	f456                	sd	s5,40(sp)
    80003342:	f05a                	sd	s6,32(sp)
    80003344:	ec5e                	sd	s7,24(sp)
    80003346:	e862                	sd	s8,16(sp)
    80003348:	e466                	sd	s9,8(sp)
    8000334a:	1080                	addi	s0,sp,96
    8000334c:	84aa                	mv	s1,a0
    8000334e:	8b2e                	mv	s6,a1
    80003350:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003352:	00054703          	lbu	a4,0(a0)
    80003356:	02f00793          	li	a5,47
    8000335a:	02f70363          	beq	a4,a5,80003380 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000335e:	ffffe097          	auipc	ra,0xffffe
    80003362:	ac0080e7          	jalr	-1344(ra) # 80000e1e <myproc>
    80003366:	15053503          	ld	a0,336(a0)
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	9f6080e7          	jalr	-1546(ra) # 80002d60 <idup>
    80003372:	89aa                	mv	s3,a0
  while(*path == '/')
    80003374:	02f00913          	li	s2,47
  len = path - s;
    80003378:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000337a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000337c:	4c05                	li	s8,1
    8000337e:	a865                	j	80003436 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003380:	4585                	li	a1,1
    80003382:	4505                	li	a0,1
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	6e6080e7          	jalr	1766(ra) # 80002a6a <iget>
    8000338c:	89aa                	mv	s3,a0
    8000338e:	b7dd                	j	80003374 <namex+0x42>
      iunlockput(ip);
    80003390:	854e                	mv	a0,s3
    80003392:	00000097          	auipc	ra,0x0
    80003396:	c6e080e7          	jalr	-914(ra) # 80003000 <iunlockput>
      return 0;
    8000339a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000339c:	854e                	mv	a0,s3
    8000339e:	60e6                	ld	ra,88(sp)
    800033a0:	6446                	ld	s0,80(sp)
    800033a2:	64a6                	ld	s1,72(sp)
    800033a4:	6906                	ld	s2,64(sp)
    800033a6:	79e2                	ld	s3,56(sp)
    800033a8:	7a42                	ld	s4,48(sp)
    800033aa:	7aa2                	ld	s5,40(sp)
    800033ac:	7b02                	ld	s6,32(sp)
    800033ae:	6be2                	ld	s7,24(sp)
    800033b0:	6c42                	ld	s8,16(sp)
    800033b2:	6ca2                	ld	s9,8(sp)
    800033b4:	6125                	addi	sp,sp,96
    800033b6:	8082                	ret
      iunlock(ip);
    800033b8:	854e                	mv	a0,s3
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	aa6080e7          	jalr	-1370(ra) # 80002e60 <iunlock>
      return ip;
    800033c2:	bfe9                	j	8000339c <namex+0x6a>
      iunlockput(ip);
    800033c4:	854e                	mv	a0,s3
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	c3a080e7          	jalr	-966(ra) # 80003000 <iunlockput>
      return 0;
    800033ce:	89d2                	mv	s3,s4
    800033d0:	b7f1                	j	8000339c <namex+0x6a>
  len = path - s;
    800033d2:	40b48633          	sub	a2,s1,a1
    800033d6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033da:	094cd463          	bge	s9,s4,80003462 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033de:	4639                	li	a2,14
    800033e0:	8556                	mv	a0,s5
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	df6080e7          	jalr	-522(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033ea:	0004c783          	lbu	a5,0(s1)
    800033ee:	01279763          	bne	a5,s2,800033fc <namex+0xca>
    path++;
    800033f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033f4:	0004c783          	lbu	a5,0(s1)
    800033f8:	ff278de3          	beq	a5,s2,800033f2 <namex+0xc0>
    ilock(ip);
    800033fc:	854e                	mv	a0,s3
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	9a0080e7          	jalr	-1632(ra) # 80002d9e <ilock>
    if(ip->type != T_DIR){
    80003406:	04499783          	lh	a5,68(s3)
    8000340a:	f98793e3          	bne	a5,s8,80003390 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000340e:	000b0563          	beqz	s6,80003418 <namex+0xe6>
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	d3cd                	beqz	a5,800033b8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003418:	865e                	mv	a2,s7
    8000341a:	85d6                	mv	a1,s5
    8000341c:	854e                	mv	a0,s3
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	e64080e7          	jalr	-412(ra) # 80003282 <dirlookup>
    80003426:	8a2a                	mv	s4,a0
    80003428:	dd51                	beqz	a0,800033c4 <namex+0x92>
    iunlockput(ip);
    8000342a:	854e                	mv	a0,s3
    8000342c:	00000097          	auipc	ra,0x0
    80003430:	bd4080e7          	jalr	-1068(ra) # 80003000 <iunlockput>
    ip = next;
    80003434:	89d2                	mv	s3,s4
  while(*path == '/')
    80003436:	0004c783          	lbu	a5,0(s1)
    8000343a:	05279763          	bne	a5,s2,80003488 <namex+0x156>
    path++;
    8000343e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003440:	0004c783          	lbu	a5,0(s1)
    80003444:	ff278de3          	beq	a5,s2,8000343e <namex+0x10c>
  if(*path == 0)
    80003448:	c79d                	beqz	a5,80003476 <namex+0x144>
    path++;
    8000344a:	85a6                	mv	a1,s1
  len = path - s;
    8000344c:	8a5e                	mv	s4,s7
    8000344e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003450:	01278963          	beq	a5,s2,80003462 <namex+0x130>
    80003454:	dfbd                	beqz	a5,800033d2 <namex+0xa0>
    path++;
    80003456:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003458:	0004c783          	lbu	a5,0(s1)
    8000345c:	ff279ce3          	bne	a5,s2,80003454 <namex+0x122>
    80003460:	bf8d                	j	800033d2 <namex+0xa0>
    memmove(name, s, len);
    80003462:	2601                	sext.w	a2,a2
    80003464:	8556                	mv	a0,s5
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	d72080e7          	jalr	-654(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000346e:	9a56                	add	s4,s4,s5
    80003470:	000a0023          	sb	zero,0(s4)
    80003474:	bf9d                	j	800033ea <namex+0xb8>
  if(nameiparent){
    80003476:	f20b03e3          	beqz	s6,8000339c <namex+0x6a>
    iput(ip);
    8000347a:	854e                	mv	a0,s3
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	adc080e7          	jalr	-1316(ra) # 80002f58 <iput>
    return 0;
    80003484:	4981                	li	s3,0
    80003486:	bf19                	j	8000339c <namex+0x6a>
  if(*path == 0)
    80003488:	d7fd                	beqz	a5,80003476 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000348a:	0004c783          	lbu	a5,0(s1)
    8000348e:	85a6                	mv	a1,s1
    80003490:	b7d1                	j	80003454 <namex+0x122>

0000000080003492 <dirlink>:
{
    80003492:	7139                	addi	sp,sp,-64
    80003494:	fc06                	sd	ra,56(sp)
    80003496:	f822                	sd	s0,48(sp)
    80003498:	f426                	sd	s1,40(sp)
    8000349a:	f04a                	sd	s2,32(sp)
    8000349c:	ec4e                	sd	s3,24(sp)
    8000349e:	e852                	sd	s4,16(sp)
    800034a0:	0080                	addi	s0,sp,64
    800034a2:	892a                	mv	s2,a0
    800034a4:	8a2e                	mv	s4,a1
    800034a6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034a8:	4601                	li	a2,0
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	dd8080e7          	jalr	-552(ra) # 80003282 <dirlookup>
    800034b2:	e93d                	bnez	a0,80003528 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034b4:	04c92483          	lw	s1,76(s2)
    800034b8:	c49d                	beqz	s1,800034e6 <dirlink+0x54>
    800034ba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034bc:	4741                	li	a4,16
    800034be:	86a6                	mv	a3,s1
    800034c0:	fc040613          	addi	a2,s0,-64
    800034c4:	4581                	li	a1,0
    800034c6:	854a                	mv	a0,s2
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	b8a080e7          	jalr	-1142(ra) # 80003052 <readi>
    800034d0:	47c1                	li	a5,16
    800034d2:	06f51163          	bne	a0,a5,80003534 <dirlink+0xa2>
    if(de.inum == 0)
    800034d6:	fc045783          	lhu	a5,-64(s0)
    800034da:	c791                	beqz	a5,800034e6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034dc:	24c1                	addiw	s1,s1,16
    800034de:	04c92783          	lw	a5,76(s2)
    800034e2:	fcf4ede3          	bltu	s1,a5,800034bc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034e6:	4639                	li	a2,14
    800034e8:	85d2                	mv	a1,s4
    800034ea:	fc240513          	addi	a0,s0,-62
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	d9e080e7          	jalr	-610(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034f6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034fa:	4741                	li	a4,16
    800034fc:	86a6                	mv	a3,s1
    800034fe:	fc040613          	addi	a2,s0,-64
    80003502:	4581                	li	a1,0
    80003504:	854a                	mv	a0,s2
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	c44080e7          	jalr	-956(ra) # 8000314a <writei>
    8000350e:	872a                	mv	a4,a0
    80003510:	47c1                	li	a5,16
  return 0;
    80003512:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003514:	02f71863          	bne	a4,a5,80003544 <dirlink+0xb2>
}
    80003518:	70e2                	ld	ra,56(sp)
    8000351a:	7442                	ld	s0,48(sp)
    8000351c:	74a2                	ld	s1,40(sp)
    8000351e:	7902                	ld	s2,32(sp)
    80003520:	69e2                	ld	s3,24(sp)
    80003522:	6a42                	ld	s4,16(sp)
    80003524:	6121                	addi	sp,sp,64
    80003526:	8082                	ret
    iput(ip);
    80003528:	00000097          	auipc	ra,0x0
    8000352c:	a30080e7          	jalr	-1488(ra) # 80002f58 <iput>
    return -1;
    80003530:	557d                	li	a0,-1
    80003532:	b7dd                	j	80003518 <dirlink+0x86>
      panic("dirlink read");
    80003534:	00005517          	auipc	a0,0x5
    80003538:	03450513          	addi	a0,a0,52 # 80008568 <syscalls+0x1d8>
    8000353c:	00003097          	auipc	ra,0x3
    80003540:	d4c080e7          	jalr	-692(ra) # 80006288 <panic>
    panic("dirlink");
    80003544:	00005517          	auipc	a0,0x5
    80003548:	13450513          	addi	a0,a0,308 # 80008678 <syscalls+0x2e8>
    8000354c:	00003097          	auipc	ra,0x3
    80003550:	d3c080e7          	jalr	-708(ra) # 80006288 <panic>

0000000080003554 <namei>:

struct inode*
namei(char *path)
{
    80003554:	1101                	addi	sp,sp,-32
    80003556:	ec06                	sd	ra,24(sp)
    80003558:	e822                	sd	s0,16(sp)
    8000355a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000355c:	fe040613          	addi	a2,s0,-32
    80003560:	4581                	li	a1,0
    80003562:	00000097          	auipc	ra,0x0
    80003566:	dd0080e7          	jalr	-560(ra) # 80003332 <namex>
}
    8000356a:	60e2                	ld	ra,24(sp)
    8000356c:	6442                	ld	s0,16(sp)
    8000356e:	6105                	addi	sp,sp,32
    80003570:	8082                	ret

0000000080003572 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003572:	1141                	addi	sp,sp,-16
    80003574:	e406                	sd	ra,8(sp)
    80003576:	e022                	sd	s0,0(sp)
    80003578:	0800                	addi	s0,sp,16
    8000357a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000357c:	4585                	li	a1,1
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	db4080e7          	jalr	-588(ra) # 80003332 <namex>
}
    80003586:	60a2                	ld	ra,8(sp)
    80003588:	6402                	ld	s0,0(sp)
    8000358a:	0141                	addi	sp,sp,16
    8000358c:	8082                	ret

000000008000358e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000358e:	1101                	addi	sp,sp,-32
    80003590:	ec06                	sd	ra,24(sp)
    80003592:	e822                	sd	s0,16(sp)
    80003594:	e426                	sd	s1,8(sp)
    80003596:	e04a                	sd	s2,0(sp)
    80003598:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000359a:	0001e917          	auipc	s2,0x1e
    8000359e:	a8690913          	addi	s2,s2,-1402 # 80021020 <log>
    800035a2:	01892583          	lw	a1,24(s2)
    800035a6:	02892503          	lw	a0,40(s2)
    800035aa:	fffff097          	auipc	ra,0xfffff
    800035ae:	ff2080e7          	jalr	-14(ra) # 8000259c <bread>
    800035b2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035b4:	02c92683          	lw	a3,44(s2)
    800035b8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035ba:	02d05763          	blez	a3,800035e8 <write_head+0x5a>
    800035be:	0001e797          	auipc	a5,0x1e
    800035c2:	a9278793          	addi	a5,a5,-1390 # 80021050 <log+0x30>
    800035c6:	05c50713          	addi	a4,a0,92
    800035ca:	36fd                	addiw	a3,a3,-1
    800035cc:	1682                	slli	a3,a3,0x20
    800035ce:	9281                	srli	a3,a3,0x20
    800035d0:	068a                	slli	a3,a3,0x2
    800035d2:	0001e617          	auipc	a2,0x1e
    800035d6:	a8260613          	addi	a2,a2,-1406 # 80021054 <log+0x34>
    800035da:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035dc:	4390                	lw	a2,0(a5)
    800035de:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035e0:	0791                	addi	a5,a5,4
    800035e2:	0711                	addi	a4,a4,4
    800035e4:	fed79ce3          	bne	a5,a3,800035dc <write_head+0x4e>
  }
  bwrite(buf);
    800035e8:	8526                	mv	a0,s1
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	0a4080e7          	jalr	164(ra) # 8000268e <bwrite>
  brelse(buf);
    800035f2:	8526                	mv	a0,s1
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	0d8080e7          	jalr	216(ra) # 800026cc <brelse>
}
    800035fc:	60e2                	ld	ra,24(sp)
    800035fe:	6442                	ld	s0,16(sp)
    80003600:	64a2                	ld	s1,8(sp)
    80003602:	6902                	ld	s2,0(sp)
    80003604:	6105                	addi	sp,sp,32
    80003606:	8082                	ret

0000000080003608 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003608:	0001e797          	auipc	a5,0x1e
    8000360c:	a447a783          	lw	a5,-1468(a5) # 8002104c <log+0x2c>
    80003610:	0af05d63          	blez	a5,800036ca <install_trans+0xc2>
{
    80003614:	7139                	addi	sp,sp,-64
    80003616:	fc06                	sd	ra,56(sp)
    80003618:	f822                	sd	s0,48(sp)
    8000361a:	f426                	sd	s1,40(sp)
    8000361c:	f04a                	sd	s2,32(sp)
    8000361e:	ec4e                	sd	s3,24(sp)
    80003620:	e852                	sd	s4,16(sp)
    80003622:	e456                	sd	s5,8(sp)
    80003624:	e05a                	sd	s6,0(sp)
    80003626:	0080                	addi	s0,sp,64
    80003628:	8b2a                	mv	s6,a0
    8000362a:	0001ea97          	auipc	s5,0x1e
    8000362e:	a26a8a93          	addi	s5,s5,-1498 # 80021050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003632:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003634:	0001e997          	auipc	s3,0x1e
    80003638:	9ec98993          	addi	s3,s3,-1556 # 80021020 <log>
    8000363c:	a035                	j	80003668 <install_trans+0x60>
      bunpin(dbuf);
    8000363e:	8526                	mv	a0,s1
    80003640:	fffff097          	auipc	ra,0xfffff
    80003644:	166080e7          	jalr	358(ra) # 800027a6 <bunpin>
    brelse(lbuf);
    80003648:	854a                	mv	a0,s2
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	082080e7          	jalr	130(ra) # 800026cc <brelse>
    brelse(dbuf);
    80003652:	8526                	mv	a0,s1
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	078080e7          	jalr	120(ra) # 800026cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365c:	2a05                	addiw	s4,s4,1
    8000365e:	0a91                	addi	s5,s5,4
    80003660:	02c9a783          	lw	a5,44(s3)
    80003664:	04fa5963          	bge	s4,a5,800036b6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003668:	0189a583          	lw	a1,24(s3)
    8000366c:	014585bb          	addw	a1,a1,s4
    80003670:	2585                	addiw	a1,a1,1
    80003672:	0289a503          	lw	a0,40(s3)
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	f26080e7          	jalr	-218(ra) # 8000259c <bread>
    8000367e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003680:	000aa583          	lw	a1,0(s5)
    80003684:	0289a503          	lw	a0,40(s3)
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	f14080e7          	jalr	-236(ra) # 8000259c <bread>
    80003690:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003692:	40000613          	li	a2,1024
    80003696:	05890593          	addi	a1,s2,88
    8000369a:	05850513          	addi	a0,a0,88
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	b3a080e7          	jalr	-1222(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036a6:	8526                	mv	a0,s1
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	fe6080e7          	jalr	-26(ra) # 8000268e <bwrite>
    if(recovering == 0)
    800036b0:	f80b1ce3          	bnez	s6,80003648 <install_trans+0x40>
    800036b4:	b769                	j	8000363e <install_trans+0x36>
}
    800036b6:	70e2                	ld	ra,56(sp)
    800036b8:	7442                	ld	s0,48(sp)
    800036ba:	74a2                	ld	s1,40(sp)
    800036bc:	7902                	ld	s2,32(sp)
    800036be:	69e2                	ld	s3,24(sp)
    800036c0:	6a42                	ld	s4,16(sp)
    800036c2:	6aa2                	ld	s5,8(sp)
    800036c4:	6b02                	ld	s6,0(sp)
    800036c6:	6121                	addi	sp,sp,64
    800036c8:	8082                	ret
    800036ca:	8082                	ret

00000000800036cc <initlog>:
{
    800036cc:	7179                	addi	sp,sp,-48
    800036ce:	f406                	sd	ra,40(sp)
    800036d0:	f022                	sd	s0,32(sp)
    800036d2:	ec26                	sd	s1,24(sp)
    800036d4:	e84a                	sd	s2,16(sp)
    800036d6:	e44e                	sd	s3,8(sp)
    800036d8:	1800                	addi	s0,sp,48
    800036da:	892a                	mv	s2,a0
    800036dc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036de:	0001e497          	auipc	s1,0x1e
    800036e2:	94248493          	addi	s1,s1,-1726 # 80021020 <log>
    800036e6:	00005597          	auipc	a1,0x5
    800036ea:	e9258593          	addi	a1,a1,-366 # 80008578 <syscalls+0x1e8>
    800036ee:	8526                	mv	a0,s1
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	052080e7          	jalr	82(ra) # 80006742 <initlock>
  log.start = sb->logstart;
    800036f8:	0149a583          	lw	a1,20(s3)
    800036fc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036fe:	0109a783          	lw	a5,16(s3)
    80003702:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003704:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003708:	854a                	mv	a0,s2
    8000370a:	fffff097          	auipc	ra,0xfffff
    8000370e:	e92080e7          	jalr	-366(ra) # 8000259c <bread>
  log.lh.n = lh->n;
    80003712:	4d3c                	lw	a5,88(a0)
    80003714:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003716:	02f05563          	blez	a5,80003740 <initlog+0x74>
    8000371a:	05c50713          	addi	a4,a0,92
    8000371e:	0001e697          	auipc	a3,0x1e
    80003722:	93268693          	addi	a3,a3,-1742 # 80021050 <log+0x30>
    80003726:	37fd                	addiw	a5,a5,-1
    80003728:	1782                	slli	a5,a5,0x20
    8000372a:	9381                	srli	a5,a5,0x20
    8000372c:	078a                	slli	a5,a5,0x2
    8000372e:	06050613          	addi	a2,a0,96
    80003732:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003734:	4310                	lw	a2,0(a4)
    80003736:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003738:	0711                	addi	a4,a4,4
    8000373a:	0691                	addi	a3,a3,4
    8000373c:	fef71ce3          	bne	a4,a5,80003734 <initlog+0x68>
  brelse(buf);
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	f8c080e7          	jalr	-116(ra) # 800026cc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003748:	4505                	li	a0,1
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	ebe080e7          	jalr	-322(ra) # 80003608 <install_trans>
  log.lh.n = 0;
    80003752:	0001e797          	auipc	a5,0x1e
    80003756:	8e07ad23          	sw	zero,-1798(a5) # 8002104c <log+0x2c>
  write_head(); // clear the log
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	e34080e7          	jalr	-460(ra) # 8000358e <write_head>
}
    80003762:	70a2                	ld	ra,40(sp)
    80003764:	7402                	ld	s0,32(sp)
    80003766:	64e2                	ld	s1,24(sp)
    80003768:	6942                	ld	s2,16(sp)
    8000376a:	69a2                	ld	s3,8(sp)
    8000376c:	6145                	addi	sp,sp,48
    8000376e:	8082                	ret

0000000080003770 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003770:	1101                	addi	sp,sp,-32
    80003772:	ec06                	sd	ra,24(sp)
    80003774:	e822                	sd	s0,16(sp)
    80003776:	e426                	sd	s1,8(sp)
    80003778:	e04a                	sd	s2,0(sp)
    8000377a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000377c:	0001e517          	auipc	a0,0x1e
    80003780:	8a450513          	addi	a0,a0,-1884 # 80021020 <log>
    80003784:	00003097          	auipc	ra,0x3
    80003788:	04e080e7          	jalr	78(ra) # 800067d2 <acquire>
  while(1){
    if(log.committing){
    8000378c:	0001e497          	auipc	s1,0x1e
    80003790:	89448493          	addi	s1,s1,-1900 # 80021020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003794:	4979                	li	s2,30
    80003796:	a039                	j	800037a4 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003798:	85a6                	mv	a1,s1
    8000379a:	8526                	mv	a0,s1
    8000379c:	ffffe097          	auipc	ra,0xffffe
    800037a0:	d82080e7          	jalr	-638(ra) # 8000151e <sleep>
    if(log.committing){
    800037a4:	50dc                	lw	a5,36(s1)
    800037a6:	fbed                	bnez	a5,80003798 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a8:	509c                	lw	a5,32(s1)
    800037aa:	0017871b          	addiw	a4,a5,1
    800037ae:	0007069b          	sext.w	a3,a4
    800037b2:	0027179b          	slliw	a5,a4,0x2
    800037b6:	9fb9                	addw	a5,a5,a4
    800037b8:	0017979b          	slliw	a5,a5,0x1
    800037bc:	54d8                	lw	a4,44(s1)
    800037be:	9fb9                	addw	a5,a5,a4
    800037c0:	00f95963          	bge	s2,a5,800037d2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037c4:	85a6                	mv	a1,s1
    800037c6:	8526                	mv	a0,s1
    800037c8:	ffffe097          	auipc	ra,0xffffe
    800037cc:	d56080e7          	jalr	-682(ra) # 8000151e <sleep>
    800037d0:	bfd1                	j	800037a4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037d2:	0001e517          	auipc	a0,0x1e
    800037d6:	84e50513          	addi	a0,a0,-1970 # 80021020 <log>
    800037da:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	0aa080e7          	jalr	170(ra) # 80006886 <release>
      break;
    }
  }
}
    800037e4:	60e2                	ld	ra,24(sp)
    800037e6:	6442                	ld	s0,16(sp)
    800037e8:	64a2                	ld	s1,8(sp)
    800037ea:	6902                	ld	s2,0(sp)
    800037ec:	6105                	addi	sp,sp,32
    800037ee:	8082                	ret

00000000800037f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037f0:	7139                	addi	sp,sp,-64
    800037f2:	fc06                	sd	ra,56(sp)
    800037f4:	f822                	sd	s0,48(sp)
    800037f6:	f426                	sd	s1,40(sp)
    800037f8:	f04a                	sd	s2,32(sp)
    800037fa:	ec4e                	sd	s3,24(sp)
    800037fc:	e852                	sd	s4,16(sp)
    800037fe:	e456                	sd	s5,8(sp)
    80003800:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003802:	0001e497          	auipc	s1,0x1e
    80003806:	81e48493          	addi	s1,s1,-2018 # 80021020 <log>
    8000380a:	8526                	mv	a0,s1
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	fc6080e7          	jalr	-58(ra) # 800067d2 <acquire>
  log.outstanding -= 1;
    80003814:	509c                	lw	a5,32(s1)
    80003816:	37fd                	addiw	a5,a5,-1
    80003818:	0007891b          	sext.w	s2,a5
    8000381c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000381e:	50dc                	lw	a5,36(s1)
    80003820:	efb9                	bnez	a5,8000387e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003822:	06091663          	bnez	s2,8000388e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003826:	0001d497          	auipc	s1,0x1d
    8000382a:	7fa48493          	addi	s1,s1,2042 # 80021020 <log>
    8000382e:	4785                	li	a5,1
    80003830:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003832:	8526                	mv	a0,s1
    80003834:	00003097          	auipc	ra,0x3
    80003838:	052080e7          	jalr	82(ra) # 80006886 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000383c:	54dc                	lw	a5,44(s1)
    8000383e:	06f04763          	bgtz	a5,800038ac <end_op+0xbc>
    acquire(&log.lock);
    80003842:	0001d497          	auipc	s1,0x1d
    80003846:	7de48493          	addi	s1,s1,2014 # 80021020 <log>
    8000384a:	8526                	mv	a0,s1
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	f86080e7          	jalr	-122(ra) # 800067d2 <acquire>
    log.committing = 0;
    80003854:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003858:	8526                	mv	a0,s1
    8000385a:	ffffe097          	auipc	ra,0xffffe
    8000385e:	e50080e7          	jalr	-432(ra) # 800016aa <wakeup>
    release(&log.lock);
    80003862:	8526                	mv	a0,s1
    80003864:	00003097          	auipc	ra,0x3
    80003868:	022080e7          	jalr	34(ra) # 80006886 <release>
}
    8000386c:	70e2                	ld	ra,56(sp)
    8000386e:	7442                	ld	s0,48(sp)
    80003870:	74a2                	ld	s1,40(sp)
    80003872:	7902                	ld	s2,32(sp)
    80003874:	69e2                	ld	s3,24(sp)
    80003876:	6a42                	ld	s4,16(sp)
    80003878:	6aa2                	ld	s5,8(sp)
    8000387a:	6121                	addi	sp,sp,64
    8000387c:	8082                	ret
    panic("log.committing");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	d0250513          	addi	a0,a0,-766 # 80008580 <syscalls+0x1f0>
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	a02080e7          	jalr	-1534(ra) # 80006288 <panic>
    wakeup(&log);
    8000388e:	0001d497          	auipc	s1,0x1d
    80003892:	79248493          	addi	s1,s1,1938 # 80021020 <log>
    80003896:	8526                	mv	a0,s1
    80003898:	ffffe097          	auipc	ra,0xffffe
    8000389c:	e12080e7          	jalr	-494(ra) # 800016aa <wakeup>
  release(&log.lock);
    800038a0:	8526                	mv	a0,s1
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	fe4080e7          	jalr	-28(ra) # 80006886 <release>
  if(do_commit){
    800038aa:	b7c9                	j	8000386c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ac:	0001da97          	auipc	s5,0x1d
    800038b0:	7a4a8a93          	addi	s5,s5,1956 # 80021050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038b4:	0001da17          	auipc	s4,0x1d
    800038b8:	76ca0a13          	addi	s4,s4,1900 # 80021020 <log>
    800038bc:	018a2583          	lw	a1,24(s4)
    800038c0:	012585bb          	addw	a1,a1,s2
    800038c4:	2585                	addiw	a1,a1,1
    800038c6:	028a2503          	lw	a0,40(s4)
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	cd2080e7          	jalr	-814(ra) # 8000259c <bread>
    800038d2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038d4:	000aa583          	lw	a1,0(s5)
    800038d8:	028a2503          	lw	a0,40(s4)
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	cc0080e7          	jalr	-832(ra) # 8000259c <bread>
    800038e4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038e6:	40000613          	li	a2,1024
    800038ea:	05850593          	addi	a1,a0,88
    800038ee:	05848513          	addi	a0,s1,88
    800038f2:	ffffd097          	auipc	ra,0xffffd
    800038f6:	8e6080e7          	jalr	-1818(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038fa:	8526                	mv	a0,s1
    800038fc:	fffff097          	auipc	ra,0xfffff
    80003900:	d92080e7          	jalr	-622(ra) # 8000268e <bwrite>
    brelse(from);
    80003904:	854e                	mv	a0,s3
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	dc6080e7          	jalr	-570(ra) # 800026cc <brelse>
    brelse(to);
    8000390e:	8526                	mv	a0,s1
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	dbc080e7          	jalr	-580(ra) # 800026cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003918:	2905                	addiw	s2,s2,1
    8000391a:	0a91                	addi	s5,s5,4
    8000391c:	02ca2783          	lw	a5,44(s4)
    80003920:	f8f94ee3          	blt	s2,a5,800038bc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003924:	00000097          	auipc	ra,0x0
    80003928:	c6a080e7          	jalr	-918(ra) # 8000358e <write_head>
    install_trans(0); // Now install writes to home locations
    8000392c:	4501                	li	a0,0
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	cda080e7          	jalr	-806(ra) # 80003608 <install_trans>
    log.lh.n = 0;
    80003936:	0001d797          	auipc	a5,0x1d
    8000393a:	7007ab23          	sw	zero,1814(a5) # 8002104c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000393e:	00000097          	auipc	ra,0x0
    80003942:	c50080e7          	jalr	-944(ra) # 8000358e <write_head>
    80003946:	bdf5                	j	80003842 <end_op+0x52>

0000000080003948 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003948:	1101                	addi	sp,sp,-32
    8000394a:	ec06                	sd	ra,24(sp)
    8000394c:	e822                	sd	s0,16(sp)
    8000394e:	e426                	sd	s1,8(sp)
    80003950:	e04a                	sd	s2,0(sp)
    80003952:	1000                	addi	s0,sp,32
    80003954:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003956:	0001d917          	auipc	s2,0x1d
    8000395a:	6ca90913          	addi	s2,s2,1738 # 80021020 <log>
    8000395e:	854a                	mv	a0,s2
    80003960:	00003097          	auipc	ra,0x3
    80003964:	e72080e7          	jalr	-398(ra) # 800067d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003968:	02c92603          	lw	a2,44(s2)
    8000396c:	47f5                	li	a5,29
    8000396e:	06c7c563          	blt	a5,a2,800039d8 <log_write+0x90>
    80003972:	0001d797          	auipc	a5,0x1d
    80003976:	6ca7a783          	lw	a5,1738(a5) # 8002103c <log+0x1c>
    8000397a:	37fd                	addiw	a5,a5,-1
    8000397c:	04f65e63          	bge	a2,a5,800039d8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003980:	0001d797          	auipc	a5,0x1d
    80003984:	6c07a783          	lw	a5,1728(a5) # 80021040 <log+0x20>
    80003988:	06f05063          	blez	a5,800039e8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000398c:	4781                	li	a5,0
    8000398e:	06c05563          	blez	a2,800039f8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003992:	44cc                	lw	a1,12(s1)
    80003994:	0001d717          	auipc	a4,0x1d
    80003998:	6bc70713          	addi	a4,a4,1724 # 80021050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000399c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000399e:	4314                	lw	a3,0(a4)
    800039a0:	04b68c63          	beq	a3,a1,800039f8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039a4:	2785                	addiw	a5,a5,1
    800039a6:	0711                	addi	a4,a4,4
    800039a8:	fef61be3          	bne	a2,a5,8000399e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039ac:	0621                	addi	a2,a2,8
    800039ae:	060a                	slli	a2,a2,0x2
    800039b0:	0001d797          	auipc	a5,0x1d
    800039b4:	67078793          	addi	a5,a5,1648 # 80021020 <log>
    800039b8:	963e                	add	a2,a2,a5
    800039ba:	44dc                	lw	a5,12(s1)
    800039bc:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039be:	8526                	mv	a0,s1
    800039c0:	fffff097          	auipc	ra,0xfffff
    800039c4:	daa080e7          	jalr	-598(ra) # 8000276a <bpin>
    log.lh.n++;
    800039c8:	0001d717          	auipc	a4,0x1d
    800039cc:	65870713          	addi	a4,a4,1624 # 80021020 <log>
    800039d0:	575c                	lw	a5,44(a4)
    800039d2:	2785                	addiw	a5,a5,1
    800039d4:	d75c                	sw	a5,44(a4)
    800039d6:	a835                	j	80003a12 <log_write+0xca>
    panic("too big a transaction");
    800039d8:	00005517          	auipc	a0,0x5
    800039dc:	bb850513          	addi	a0,a0,-1096 # 80008590 <syscalls+0x200>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	8a8080e7          	jalr	-1880(ra) # 80006288 <panic>
    panic("log_write outside of trans");
    800039e8:	00005517          	auipc	a0,0x5
    800039ec:	bc050513          	addi	a0,a0,-1088 # 800085a8 <syscalls+0x218>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	898080e7          	jalr	-1896(ra) # 80006288 <panic>
  log.lh.block[i] = b->blockno;
    800039f8:	00878713          	addi	a4,a5,8
    800039fc:	00271693          	slli	a3,a4,0x2
    80003a00:	0001d717          	auipc	a4,0x1d
    80003a04:	62070713          	addi	a4,a4,1568 # 80021020 <log>
    80003a08:	9736                	add	a4,a4,a3
    80003a0a:	44d4                	lw	a3,12(s1)
    80003a0c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a0e:	faf608e3          	beq	a2,a5,800039be <log_write+0x76>
  }
  release(&log.lock);
    80003a12:	0001d517          	auipc	a0,0x1d
    80003a16:	60e50513          	addi	a0,a0,1550 # 80021020 <log>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	e6c080e7          	jalr	-404(ra) # 80006886 <release>
}
    80003a22:	60e2                	ld	ra,24(sp)
    80003a24:	6442                	ld	s0,16(sp)
    80003a26:	64a2                	ld	s1,8(sp)
    80003a28:	6902                	ld	s2,0(sp)
    80003a2a:	6105                	addi	sp,sp,32
    80003a2c:	8082                	ret

0000000080003a2e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a2e:	1101                	addi	sp,sp,-32
    80003a30:	ec06                	sd	ra,24(sp)
    80003a32:	e822                	sd	s0,16(sp)
    80003a34:	e426                	sd	s1,8(sp)
    80003a36:	e04a                	sd	s2,0(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
    80003a3c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a3e:	00005597          	auipc	a1,0x5
    80003a42:	b8a58593          	addi	a1,a1,-1142 # 800085c8 <syscalls+0x238>
    80003a46:	0521                	addi	a0,a0,8
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	cfa080e7          	jalr	-774(ra) # 80006742 <initlock>
  lk->name = name;
    80003a50:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a54:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a58:	0204a423          	sw	zero,40(s1)
}
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6902                	ld	s2,0(sp)
    80003a64:	6105                	addi	sp,sp,32
    80003a66:	8082                	ret

0000000080003a68 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a68:	1101                	addi	sp,sp,-32
    80003a6a:	ec06                	sd	ra,24(sp)
    80003a6c:	e822                	sd	s0,16(sp)
    80003a6e:	e426                	sd	s1,8(sp)
    80003a70:	e04a                	sd	s2,0(sp)
    80003a72:	1000                	addi	s0,sp,32
    80003a74:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a76:	00850913          	addi	s2,a0,8
    80003a7a:	854a                	mv	a0,s2
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	d56080e7          	jalr	-682(ra) # 800067d2 <acquire>
  while (lk->locked) {
    80003a84:	409c                	lw	a5,0(s1)
    80003a86:	cb89                	beqz	a5,80003a98 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a88:	85ca                	mv	a1,s2
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	ffffe097          	auipc	ra,0xffffe
    80003a90:	a92080e7          	jalr	-1390(ra) # 8000151e <sleep>
  while (lk->locked) {
    80003a94:	409c                	lw	a5,0(s1)
    80003a96:	fbed                	bnez	a5,80003a88 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a98:	4785                	li	a5,1
    80003a9a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a9c:	ffffd097          	auipc	ra,0xffffd
    80003aa0:	382080e7          	jalr	898(ra) # 80000e1e <myproc>
    80003aa4:	591c                	lw	a5,48(a0)
    80003aa6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003aa8:	854a                	mv	a0,s2
    80003aaa:	00003097          	auipc	ra,0x3
    80003aae:	ddc080e7          	jalr	-548(ra) # 80006886 <release>
}
    80003ab2:	60e2                	ld	ra,24(sp)
    80003ab4:	6442                	ld	s0,16(sp)
    80003ab6:	64a2                	ld	s1,8(sp)
    80003ab8:	6902                	ld	s2,0(sp)
    80003aba:	6105                	addi	sp,sp,32
    80003abc:	8082                	ret

0000000080003abe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003abe:	1101                	addi	sp,sp,-32
    80003ac0:	ec06                	sd	ra,24(sp)
    80003ac2:	e822                	sd	s0,16(sp)
    80003ac4:	e426                	sd	s1,8(sp)
    80003ac6:	e04a                	sd	s2,0(sp)
    80003ac8:	1000                	addi	s0,sp,32
    80003aca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003acc:	00850913          	addi	s2,a0,8
    80003ad0:	854a                	mv	a0,s2
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	d00080e7          	jalr	-768(ra) # 800067d2 <acquire>
  lk->locked = 0;
    80003ada:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ade:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	ffffe097          	auipc	ra,0xffffe
    80003ae8:	bc6080e7          	jalr	-1082(ra) # 800016aa <wakeup>
  release(&lk->lk);
    80003aec:	854a                	mv	a0,s2
    80003aee:	00003097          	auipc	ra,0x3
    80003af2:	d98080e7          	jalr	-616(ra) # 80006886 <release>
}
    80003af6:	60e2                	ld	ra,24(sp)
    80003af8:	6442                	ld	s0,16(sp)
    80003afa:	64a2                	ld	s1,8(sp)
    80003afc:	6902                	ld	s2,0(sp)
    80003afe:	6105                	addi	sp,sp,32
    80003b00:	8082                	ret

0000000080003b02 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b02:	7179                	addi	sp,sp,-48
    80003b04:	f406                	sd	ra,40(sp)
    80003b06:	f022                	sd	s0,32(sp)
    80003b08:	ec26                	sd	s1,24(sp)
    80003b0a:	e84a                	sd	s2,16(sp)
    80003b0c:	e44e                	sd	s3,8(sp)
    80003b0e:	1800                	addi	s0,sp,48
    80003b10:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b12:	00850913          	addi	s2,a0,8
    80003b16:	854a                	mv	a0,s2
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	cba080e7          	jalr	-838(ra) # 800067d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b20:	409c                	lw	a5,0(s1)
    80003b22:	ef99                	bnez	a5,80003b40 <holdingsleep+0x3e>
    80003b24:	4481                	li	s1,0
  release(&lk->lk);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	d5e080e7          	jalr	-674(ra) # 80006886 <release>
  return r;
}
    80003b30:	8526                	mv	a0,s1
    80003b32:	70a2                	ld	ra,40(sp)
    80003b34:	7402                	ld	s0,32(sp)
    80003b36:	64e2                	ld	s1,24(sp)
    80003b38:	6942                	ld	s2,16(sp)
    80003b3a:	69a2                	ld	s3,8(sp)
    80003b3c:	6145                	addi	sp,sp,48
    80003b3e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b40:	0284a983          	lw	s3,40(s1)
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	2da080e7          	jalr	730(ra) # 80000e1e <myproc>
    80003b4c:	5904                	lw	s1,48(a0)
    80003b4e:	413484b3          	sub	s1,s1,s3
    80003b52:	0014b493          	seqz	s1,s1
    80003b56:	bfc1                	j	80003b26 <holdingsleep+0x24>

0000000080003b58 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b58:	1141                	addi	sp,sp,-16
    80003b5a:	e406                	sd	ra,8(sp)
    80003b5c:	e022                	sd	s0,0(sp)
    80003b5e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b60:	00005597          	auipc	a1,0x5
    80003b64:	a7858593          	addi	a1,a1,-1416 # 800085d8 <syscalls+0x248>
    80003b68:	0001d517          	auipc	a0,0x1d
    80003b6c:	60050513          	addi	a0,a0,1536 # 80021168 <ftable>
    80003b70:	00003097          	auipc	ra,0x3
    80003b74:	bd2080e7          	jalr	-1070(ra) # 80006742 <initlock>
}
    80003b78:	60a2                	ld	ra,8(sp)
    80003b7a:	6402                	ld	s0,0(sp)
    80003b7c:	0141                	addi	sp,sp,16
    80003b7e:	8082                	ret

0000000080003b80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b80:	1101                	addi	sp,sp,-32
    80003b82:	ec06                	sd	ra,24(sp)
    80003b84:	e822                	sd	s0,16(sp)
    80003b86:	e426                	sd	s1,8(sp)
    80003b88:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b8a:	0001d517          	auipc	a0,0x1d
    80003b8e:	5de50513          	addi	a0,a0,1502 # 80021168 <ftable>
    80003b92:	00003097          	auipc	ra,0x3
    80003b96:	c40080e7          	jalr	-960(ra) # 800067d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b9a:	0001d497          	auipc	s1,0x1d
    80003b9e:	5e648493          	addi	s1,s1,1510 # 80021180 <ftable+0x18>
    80003ba2:	0001e717          	auipc	a4,0x1e
    80003ba6:	57e70713          	addi	a4,a4,1406 # 80022120 <ftable+0xfb8>
    if(f->ref == 0){
    80003baa:	40dc                	lw	a5,4(s1)
    80003bac:	cf99                	beqz	a5,80003bca <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bae:	02848493          	addi	s1,s1,40
    80003bb2:	fee49ce3          	bne	s1,a4,80003baa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bb6:	0001d517          	auipc	a0,0x1d
    80003bba:	5b250513          	addi	a0,a0,1458 # 80021168 <ftable>
    80003bbe:	00003097          	auipc	ra,0x3
    80003bc2:	cc8080e7          	jalr	-824(ra) # 80006886 <release>
  return 0;
    80003bc6:	4481                	li	s1,0
    80003bc8:	a819                	j	80003bde <filealloc+0x5e>
      f->ref = 1;
    80003bca:	4785                	li	a5,1
    80003bcc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bce:	0001d517          	auipc	a0,0x1d
    80003bd2:	59a50513          	addi	a0,a0,1434 # 80021168 <ftable>
    80003bd6:	00003097          	auipc	ra,0x3
    80003bda:	cb0080e7          	jalr	-848(ra) # 80006886 <release>
}
    80003bde:	8526                	mv	a0,s1
    80003be0:	60e2                	ld	ra,24(sp)
    80003be2:	6442                	ld	s0,16(sp)
    80003be4:	64a2                	ld	s1,8(sp)
    80003be6:	6105                	addi	sp,sp,32
    80003be8:	8082                	ret

0000000080003bea <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bea:	1101                	addi	sp,sp,-32
    80003bec:	ec06                	sd	ra,24(sp)
    80003bee:	e822                	sd	s0,16(sp)
    80003bf0:	e426                	sd	s1,8(sp)
    80003bf2:	1000                	addi	s0,sp,32
    80003bf4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bf6:	0001d517          	auipc	a0,0x1d
    80003bfa:	57250513          	addi	a0,a0,1394 # 80021168 <ftable>
    80003bfe:	00003097          	auipc	ra,0x3
    80003c02:	bd4080e7          	jalr	-1068(ra) # 800067d2 <acquire>
  if(f->ref < 1)
    80003c06:	40dc                	lw	a5,4(s1)
    80003c08:	02f05263          	blez	a5,80003c2c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c0c:	2785                	addiw	a5,a5,1
    80003c0e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c10:	0001d517          	auipc	a0,0x1d
    80003c14:	55850513          	addi	a0,a0,1368 # 80021168 <ftable>
    80003c18:	00003097          	auipc	ra,0x3
    80003c1c:	c6e080e7          	jalr	-914(ra) # 80006886 <release>
  return f;
}
    80003c20:	8526                	mv	a0,s1
    80003c22:	60e2                	ld	ra,24(sp)
    80003c24:	6442                	ld	s0,16(sp)
    80003c26:	64a2                	ld	s1,8(sp)
    80003c28:	6105                	addi	sp,sp,32
    80003c2a:	8082                	ret
    panic("filedup");
    80003c2c:	00005517          	auipc	a0,0x5
    80003c30:	9b450513          	addi	a0,a0,-1612 # 800085e0 <syscalls+0x250>
    80003c34:	00002097          	auipc	ra,0x2
    80003c38:	654080e7          	jalr	1620(ra) # 80006288 <panic>

0000000080003c3c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c3c:	7139                	addi	sp,sp,-64
    80003c3e:	fc06                	sd	ra,56(sp)
    80003c40:	f822                	sd	s0,48(sp)
    80003c42:	f426                	sd	s1,40(sp)
    80003c44:	f04a                	sd	s2,32(sp)
    80003c46:	ec4e                	sd	s3,24(sp)
    80003c48:	e852                	sd	s4,16(sp)
    80003c4a:	e456                	sd	s5,8(sp)
    80003c4c:	0080                	addi	s0,sp,64
    80003c4e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c50:	0001d517          	auipc	a0,0x1d
    80003c54:	51850513          	addi	a0,a0,1304 # 80021168 <ftable>
    80003c58:	00003097          	auipc	ra,0x3
    80003c5c:	b7a080e7          	jalr	-1158(ra) # 800067d2 <acquire>
  if(f->ref < 1)
    80003c60:	40dc                	lw	a5,4(s1)
    80003c62:	06f05163          	blez	a5,80003cc4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c66:	37fd                	addiw	a5,a5,-1
    80003c68:	0007871b          	sext.w	a4,a5
    80003c6c:	c0dc                	sw	a5,4(s1)
    80003c6e:	06e04363          	bgtz	a4,80003cd4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c72:	0004a903          	lw	s2,0(s1)
    80003c76:	0094ca83          	lbu	s5,9(s1)
    80003c7a:	0104ba03          	ld	s4,16(s1)
    80003c7e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c82:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c86:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c8a:	0001d517          	auipc	a0,0x1d
    80003c8e:	4de50513          	addi	a0,a0,1246 # 80021168 <ftable>
    80003c92:	00003097          	auipc	ra,0x3
    80003c96:	bf4080e7          	jalr	-1036(ra) # 80006886 <release>

  if(ff.type == FD_PIPE){
    80003c9a:	4785                	li	a5,1
    80003c9c:	04f90d63          	beq	s2,a5,80003cf6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ca0:	3979                	addiw	s2,s2,-2
    80003ca2:	4785                	li	a5,1
    80003ca4:	0527e063          	bltu	a5,s2,80003ce4 <fileclose+0xa8>
    begin_op();
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	ac8080e7          	jalr	-1336(ra) # 80003770 <begin_op>
    iput(ff.ip);
    80003cb0:	854e                	mv	a0,s3
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	2a6080e7          	jalr	678(ra) # 80002f58 <iput>
    end_op();
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	b36080e7          	jalr	-1226(ra) # 800037f0 <end_op>
    80003cc2:	a00d                	j	80003ce4 <fileclose+0xa8>
    panic("fileclose");
    80003cc4:	00005517          	auipc	a0,0x5
    80003cc8:	92450513          	addi	a0,a0,-1756 # 800085e8 <syscalls+0x258>
    80003ccc:	00002097          	auipc	ra,0x2
    80003cd0:	5bc080e7          	jalr	1468(ra) # 80006288 <panic>
    release(&ftable.lock);
    80003cd4:	0001d517          	auipc	a0,0x1d
    80003cd8:	49450513          	addi	a0,a0,1172 # 80021168 <ftable>
    80003cdc:	00003097          	auipc	ra,0x3
    80003ce0:	baa080e7          	jalr	-1110(ra) # 80006886 <release>
  }
}
    80003ce4:	70e2                	ld	ra,56(sp)
    80003ce6:	7442                	ld	s0,48(sp)
    80003ce8:	74a2                	ld	s1,40(sp)
    80003cea:	7902                	ld	s2,32(sp)
    80003cec:	69e2                	ld	s3,24(sp)
    80003cee:	6a42                	ld	s4,16(sp)
    80003cf0:	6aa2                	ld	s5,8(sp)
    80003cf2:	6121                	addi	sp,sp,64
    80003cf4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cf6:	85d6                	mv	a1,s5
    80003cf8:	8552                	mv	a0,s4
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	34c080e7          	jalr	844(ra) # 80004046 <pipeclose>
    80003d02:	b7cd                	j	80003ce4 <fileclose+0xa8>

0000000080003d04 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d04:	715d                	addi	sp,sp,-80
    80003d06:	e486                	sd	ra,72(sp)
    80003d08:	e0a2                	sd	s0,64(sp)
    80003d0a:	fc26                	sd	s1,56(sp)
    80003d0c:	f84a                	sd	s2,48(sp)
    80003d0e:	f44e                	sd	s3,40(sp)
    80003d10:	0880                	addi	s0,sp,80
    80003d12:	84aa                	mv	s1,a0
    80003d14:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d16:	ffffd097          	auipc	ra,0xffffd
    80003d1a:	108080e7          	jalr	264(ra) # 80000e1e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d1e:	409c                	lw	a5,0(s1)
    80003d20:	37f9                	addiw	a5,a5,-2
    80003d22:	4705                	li	a4,1
    80003d24:	04f76763          	bltu	a4,a5,80003d72 <filestat+0x6e>
    80003d28:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d2a:	6c88                	ld	a0,24(s1)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	072080e7          	jalr	114(ra) # 80002d9e <ilock>
    stati(f->ip, &st);
    80003d34:	fb840593          	addi	a1,s0,-72
    80003d38:	6c88                	ld	a0,24(s1)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	2ee080e7          	jalr	750(ra) # 80003028 <stati>
    iunlock(f->ip);
    80003d42:	6c88                	ld	a0,24(s1)
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	11c080e7          	jalr	284(ra) # 80002e60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d4c:	46e1                	li	a3,24
    80003d4e:	fb840613          	addi	a2,s0,-72
    80003d52:	85ce                	mv	a1,s3
    80003d54:	05093503          	ld	a0,80(s2)
    80003d58:	ffffd097          	auipc	ra,0xffffd
    80003d5c:	d88080e7          	jalr	-632(ra) # 80000ae0 <copyout>
    80003d60:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d64:	60a6                	ld	ra,72(sp)
    80003d66:	6406                	ld	s0,64(sp)
    80003d68:	74e2                	ld	s1,56(sp)
    80003d6a:	7942                	ld	s2,48(sp)
    80003d6c:	79a2                	ld	s3,40(sp)
    80003d6e:	6161                	addi	sp,sp,80
    80003d70:	8082                	ret
  return -1;
    80003d72:	557d                	li	a0,-1
    80003d74:	bfc5                	j	80003d64 <filestat+0x60>

0000000080003d76 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d76:	7179                	addi	sp,sp,-48
    80003d78:	f406                	sd	ra,40(sp)
    80003d7a:	f022                	sd	s0,32(sp)
    80003d7c:	ec26                	sd	s1,24(sp)
    80003d7e:	e84a                	sd	s2,16(sp)
    80003d80:	e44e                	sd	s3,8(sp)
    80003d82:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d84:	00854783          	lbu	a5,8(a0)
    80003d88:	c3d5                	beqz	a5,80003e2c <fileread+0xb6>
    80003d8a:	84aa                	mv	s1,a0
    80003d8c:	89ae                	mv	s3,a1
    80003d8e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d90:	411c                	lw	a5,0(a0)
    80003d92:	4705                	li	a4,1
    80003d94:	04e78963          	beq	a5,a4,80003de6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d98:	470d                	li	a4,3
    80003d9a:	04e78d63          	beq	a5,a4,80003df4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d9e:	4709                	li	a4,2
    80003da0:	06e79e63          	bne	a5,a4,80003e1c <fileread+0xa6>
    ilock(f->ip);
    80003da4:	6d08                	ld	a0,24(a0)
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	ff8080e7          	jalr	-8(ra) # 80002d9e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dae:	874a                	mv	a4,s2
    80003db0:	5094                	lw	a3,32(s1)
    80003db2:	864e                	mv	a2,s3
    80003db4:	4585                	li	a1,1
    80003db6:	6c88                	ld	a0,24(s1)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	29a080e7          	jalr	666(ra) # 80003052 <readi>
    80003dc0:	892a                	mv	s2,a0
    80003dc2:	00a05563          	blez	a0,80003dcc <fileread+0x56>
      f->off += r;
    80003dc6:	509c                	lw	a5,32(s1)
    80003dc8:	9fa9                	addw	a5,a5,a0
    80003dca:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dcc:	6c88                	ld	a0,24(s1)
    80003dce:	fffff097          	auipc	ra,0xfffff
    80003dd2:	092080e7          	jalr	146(ra) # 80002e60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003dd6:	854a                	mv	a0,s2
    80003dd8:	70a2                	ld	ra,40(sp)
    80003dda:	7402                	ld	s0,32(sp)
    80003ddc:	64e2                	ld	s1,24(sp)
    80003dde:	6942                	ld	s2,16(sp)
    80003de0:	69a2                	ld	s3,8(sp)
    80003de2:	6145                	addi	sp,sp,48
    80003de4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003de6:	6908                	ld	a0,16(a0)
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	3c8080e7          	jalr	968(ra) # 800041b0 <piperead>
    80003df0:	892a                	mv	s2,a0
    80003df2:	b7d5                	j	80003dd6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003df4:	02451783          	lh	a5,36(a0)
    80003df8:	03079693          	slli	a3,a5,0x30
    80003dfc:	92c1                	srli	a3,a3,0x30
    80003dfe:	4725                	li	a4,9
    80003e00:	02d76863          	bltu	a4,a3,80003e30 <fileread+0xba>
    80003e04:	0792                	slli	a5,a5,0x4
    80003e06:	0001d717          	auipc	a4,0x1d
    80003e0a:	2c270713          	addi	a4,a4,706 # 800210c8 <devsw>
    80003e0e:	97ba                	add	a5,a5,a4
    80003e10:	639c                	ld	a5,0(a5)
    80003e12:	c38d                	beqz	a5,80003e34 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e14:	4505                	li	a0,1
    80003e16:	9782                	jalr	a5
    80003e18:	892a                	mv	s2,a0
    80003e1a:	bf75                	j	80003dd6 <fileread+0x60>
    panic("fileread");
    80003e1c:	00004517          	auipc	a0,0x4
    80003e20:	7dc50513          	addi	a0,a0,2012 # 800085f8 <syscalls+0x268>
    80003e24:	00002097          	auipc	ra,0x2
    80003e28:	464080e7          	jalr	1124(ra) # 80006288 <panic>
    return -1;
    80003e2c:	597d                	li	s2,-1
    80003e2e:	b765                	j	80003dd6 <fileread+0x60>
      return -1;
    80003e30:	597d                	li	s2,-1
    80003e32:	b755                	j	80003dd6 <fileread+0x60>
    80003e34:	597d                	li	s2,-1
    80003e36:	b745                	j	80003dd6 <fileread+0x60>

0000000080003e38 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e38:	715d                	addi	sp,sp,-80
    80003e3a:	e486                	sd	ra,72(sp)
    80003e3c:	e0a2                	sd	s0,64(sp)
    80003e3e:	fc26                	sd	s1,56(sp)
    80003e40:	f84a                	sd	s2,48(sp)
    80003e42:	f44e                	sd	s3,40(sp)
    80003e44:	f052                	sd	s4,32(sp)
    80003e46:	ec56                	sd	s5,24(sp)
    80003e48:	e85a                	sd	s6,16(sp)
    80003e4a:	e45e                	sd	s7,8(sp)
    80003e4c:	e062                	sd	s8,0(sp)
    80003e4e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e50:	00954783          	lbu	a5,9(a0)
    80003e54:	10078663          	beqz	a5,80003f60 <filewrite+0x128>
    80003e58:	892a                	mv	s2,a0
    80003e5a:	8aae                	mv	s5,a1
    80003e5c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e5e:	411c                	lw	a5,0(a0)
    80003e60:	4705                	li	a4,1
    80003e62:	02e78263          	beq	a5,a4,80003e86 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e66:	470d                	li	a4,3
    80003e68:	02e78663          	beq	a5,a4,80003e94 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e6c:	4709                	li	a4,2
    80003e6e:	0ee79163          	bne	a5,a4,80003f50 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e72:	0ac05d63          	blez	a2,80003f2c <filewrite+0xf4>
    int i = 0;
    80003e76:	4981                	li	s3,0
    80003e78:	6b05                	lui	s6,0x1
    80003e7a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e7e:	6b85                	lui	s7,0x1
    80003e80:	c00b8b9b          	addiw	s7,s7,-1024
    80003e84:	a861                	j	80003f1c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e86:	6908                	ld	a0,16(a0)
    80003e88:	00000097          	auipc	ra,0x0
    80003e8c:	22e080e7          	jalr	558(ra) # 800040b6 <pipewrite>
    80003e90:	8a2a                	mv	s4,a0
    80003e92:	a045                	j	80003f32 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e94:	02451783          	lh	a5,36(a0)
    80003e98:	03079693          	slli	a3,a5,0x30
    80003e9c:	92c1                	srli	a3,a3,0x30
    80003e9e:	4725                	li	a4,9
    80003ea0:	0cd76263          	bltu	a4,a3,80003f64 <filewrite+0x12c>
    80003ea4:	0792                	slli	a5,a5,0x4
    80003ea6:	0001d717          	auipc	a4,0x1d
    80003eaa:	22270713          	addi	a4,a4,546 # 800210c8 <devsw>
    80003eae:	97ba                	add	a5,a5,a4
    80003eb0:	679c                	ld	a5,8(a5)
    80003eb2:	cbdd                	beqz	a5,80003f68 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003eb4:	4505                	li	a0,1
    80003eb6:	9782                	jalr	a5
    80003eb8:	8a2a                	mv	s4,a0
    80003eba:	a8a5                	j	80003f32 <filewrite+0xfa>
    80003ebc:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	8b0080e7          	jalr	-1872(ra) # 80003770 <begin_op>
      ilock(f->ip);
    80003ec8:	01893503          	ld	a0,24(s2)
    80003ecc:	fffff097          	auipc	ra,0xfffff
    80003ed0:	ed2080e7          	jalr	-302(ra) # 80002d9e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ed4:	8762                	mv	a4,s8
    80003ed6:	02092683          	lw	a3,32(s2)
    80003eda:	01598633          	add	a2,s3,s5
    80003ede:	4585                	li	a1,1
    80003ee0:	01893503          	ld	a0,24(s2)
    80003ee4:	fffff097          	auipc	ra,0xfffff
    80003ee8:	266080e7          	jalr	614(ra) # 8000314a <writei>
    80003eec:	84aa                	mv	s1,a0
    80003eee:	00a05763          	blez	a0,80003efc <filewrite+0xc4>
        f->off += r;
    80003ef2:	02092783          	lw	a5,32(s2)
    80003ef6:	9fa9                	addw	a5,a5,a0
    80003ef8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003efc:	01893503          	ld	a0,24(s2)
    80003f00:	fffff097          	auipc	ra,0xfffff
    80003f04:	f60080e7          	jalr	-160(ra) # 80002e60 <iunlock>
      end_op();
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	8e8080e7          	jalr	-1816(ra) # 800037f0 <end_op>

      if(r != n1){
    80003f10:	009c1f63          	bne	s8,s1,80003f2e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f14:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f18:	0149db63          	bge	s3,s4,80003f2e <filewrite+0xf6>
      int n1 = n - i;
    80003f1c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f20:	84be                	mv	s1,a5
    80003f22:	2781                	sext.w	a5,a5
    80003f24:	f8fb5ce3          	bge	s6,a5,80003ebc <filewrite+0x84>
    80003f28:	84de                	mv	s1,s7
    80003f2a:	bf49                	j	80003ebc <filewrite+0x84>
    int i = 0;
    80003f2c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f2e:	013a1f63          	bne	s4,s3,80003f4c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f32:	8552                	mv	a0,s4
    80003f34:	60a6                	ld	ra,72(sp)
    80003f36:	6406                	ld	s0,64(sp)
    80003f38:	74e2                	ld	s1,56(sp)
    80003f3a:	7942                	ld	s2,48(sp)
    80003f3c:	79a2                	ld	s3,40(sp)
    80003f3e:	7a02                	ld	s4,32(sp)
    80003f40:	6ae2                	ld	s5,24(sp)
    80003f42:	6b42                	ld	s6,16(sp)
    80003f44:	6ba2                	ld	s7,8(sp)
    80003f46:	6c02                	ld	s8,0(sp)
    80003f48:	6161                	addi	sp,sp,80
    80003f4a:	8082                	ret
    ret = (i == n ? n : -1);
    80003f4c:	5a7d                	li	s4,-1
    80003f4e:	b7d5                	j	80003f32 <filewrite+0xfa>
    panic("filewrite");
    80003f50:	00004517          	auipc	a0,0x4
    80003f54:	6b850513          	addi	a0,a0,1720 # 80008608 <syscalls+0x278>
    80003f58:	00002097          	auipc	ra,0x2
    80003f5c:	330080e7          	jalr	816(ra) # 80006288 <panic>
    return -1;
    80003f60:	5a7d                	li	s4,-1
    80003f62:	bfc1                	j	80003f32 <filewrite+0xfa>
      return -1;
    80003f64:	5a7d                	li	s4,-1
    80003f66:	b7f1                	j	80003f32 <filewrite+0xfa>
    80003f68:	5a7d                	li	s4,-1
    80003f6a:	b7e1                	j	80003f32 <filewrite+0xfa>

0000000080003f6c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f6c:	7179                	addi	sp,sp,-48
    80003f6e:	f406                	sd	ra,40(sp)
    80003f70:	f022                	sd	s0,32(sp)
    80003f72:	ec26                	sd	s1,24(sp)
    80003f74:	e84a                	sd	s2,16(sp)
    80003f76:	e44e                	sd	s3,8(sp)
    80003f78:	e052                	sd	s4,0(sp)
    80003f7a:	1800                	addi	s0,sp,48
    80003f7c:	84aa                	mv	s1,a0
    80003f7e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f80:	0005b023          	sd	zero,0(a1)
    80003f84:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	bf8080e7          	jalr	-1032(ra) # 80003b80 <filealloc>
    80003f90:	e088                	sd	a0,0(s1)
    80003f92:	c551                	beqz	a0,8000401e <pipealloc+0xb2>
    80003f94:	00000097          	auipc	ra,0x0
    80003f98:	bec080e7          	jalr	-1044(ra) # 80003b80 <filealloc>
    80003f9c:	00aa3023          	sd	a0,0(s4)
    80003fa0:	c92d                	beqz	a0,80004012 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fa2:	ffffc097          	auipc	ra,0xffffc
    80003fa6:	176080e7          	jalr	374(ra) # 80000118 <kalloc>
    80003faa:	892a                	mv	s2,a0
    80003fac:	c125                	beqz	a0,8000400c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fae:	4985                	li	s3,1
    80003fb0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fb4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fb8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fbc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fc0:	00004597          	auipc	a1,0x4
    80003fc4:	65858593          	addi	a1,a1,1624 # 80008618 <syscalls+0x288>
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	77a080e7          	jalr	1914(ra) # 80006742 <initlock>
  (*f0)->type = FD_PIPE;
    80003fd0:	609c                	ld	a5,0(s1)
    80003fd2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fd6:	609c                	ld	a5,0(s1)
    80003fd8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fdc:	609c                	ld	a5,0(s1)
    80003fde:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fe2:	609c                	ld	a5,0(s1)
    80003fe4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fe8:	000a3783          	ld	a5,0(s4)
    80003fec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ff0:	000a3783          	ld	a5,0(s4)
    80003ff4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ff8:	000a3783          	ld	a5,0(s4)
    80003ffc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004000:	000a3783          	ld	a5,0(s4)
    80004004:	0127b823          	sd	s2,16(a5)
  return 0;
    80004008:	4501                	li	a0,0
    8000400a:	a025                	j	80004032 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000400c:	6088                	ld	a0,0(s1)
    8000400e:	e501                	bnez	a0,80004016 <pipealloc+0xaa>
    80004010:	a039                	j	8000401e <pipealloc+0xb2>
    80004012:	6088                	ld	a0,0(s1)
    80004014:	c51d                	beqz	a0,80004042 <pipealloc+0xd6>
    fileclose(*f0);
    80004016:	00000097          	auipc	ra,0x0
    8000401a:	c26080e7          	jalr	-986(ra) # 80003c3c <fileclose>
  if(*f1)
    8000401e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004022:	557d                	li	a0,-1
  if(*f1)
    80004024:	c799                	beqz	a5,80004032 <pipealloc+0xc6>
    fileclose(*f1);
    80004026:	853e                	mv	a0,a5
    80004028:	00000097          	auipc	ra,0x0
    8000402c:	c14080e7          	jalr	-1004(ra) # 80003c3c <fileclose>
  return -1;
    80004030:	557d                	li	a0,-1
}
    80004032:	70a2                	ld	ra,40(sp)
    80004034:	7402                	ld	s0,32(sp)
    80004036:	64e2                	ld	s1,24(sp)
    80004038:	6942                	ld	s2,16(sp)
    8000403a:	69a2                	ld	s3,8(sp)
    8000403c:	6a02                	ld	s4,0(sp)
    8000403e:	6145                	addi	sp,sp,48
    80004040:	8082                	ret
  return -1;
    80004042:	557d                	li	a0,-1
    80004044:	b7fd                	j	80004032 <pipealloc+0xc6>

0000000080004046 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004046:	1101                	addi	sp,sp,-32
    80004048:	ec06                	sd	ra,24(sp)
    8000404a:	e822                	sd	s0,16(sp)
    8000404c:	e426                	sd	s1,8(sp)
    8000404e:	e04a                	sd	s2,0(sp)
    80004050:	1000                	addi	s0,sp,32
    80004052:	84aa                	mv	s1,a0
    80004054:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	77c080e7          	jalr	1916(ra) # 800067d2 <acquire>
  if(writable){
    8000405e:	02090d63          	beqz	s2,80004098 <pipeclose+0x52>
    pi->writeopen = 0;
    80004062:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004066:	21848513          	addi	a0,s1,536
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	640080e7          	jalr	1600(ra) # 800016aa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004072:	2204b783          	ld	a5,544(s1)
    80004076:	eb95                	bnez	a5,800040aa <pipeclose+0x64>
    release(&pi->lock);
    80004078:	8526                	mv	a0,s1
    8000407a:	00003097          	auipc	ra,0x3
    8000407e:	80c080e7          	jalr	-2036(ra) # 80006886 <release>
    kfree((char*)pi);
    80004082:	8526                	mv	a0,s1
    80004084:	ffffc097          	auipc	ra,0xffffc
    80004088:	f98080e7          	jalr	-104(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000408c:	60e2                	ld	ra,24(sp)
    8000408e:	6442                	ld	s0,16(sp)
    80004090:	64a2                	ld	s1,8(sp)
    80004092:	6902                	ld	s2,0(sp)
    80004094:	6105                	addi	sp,sp,32
    80004096:	8082                	ret
    pi->readopen = 0;
    80004098:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000409c:	21c48513          	addi	a0,s1,540
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	60a080e7          	jalr	1546(ra) # 800016aa <wakeup>
    800040a8:	b7e9                	j	80004072 <pipeclose+0x2c>
    release(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	7da080e7          	jalr	2010(ra) # 80006886 <release>
}
    800040b4:	bfe1                	j	8000408c <pipeclose+0x46>

00000000800040b6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040b6:	7159                	addi	sp,sp,-112
    800040b8:	f486                	sd	ra,104(sp)
    800040ba:	f0a2                	sd	s0,96(sp)
    800040bc:	eca6                	sd	s1,88(sp)
    800040be:	e8ca                	sd	s2,80(sp)
    800040c0:	e4ce                	sd	s3,72(sp)
    800040c2:	e0d2                	sd	s4,64(sp)
    800040c4:	fc56                	sd	s5,56(sp)
    800040c6:	f85a                	sd	s6,48(sp)
    800040c8:	f45e                	sd	s7,40(sp)
    800040ca:	f062                	sd	s8,32(sp)
    800040cc:	ec66                	sd	s9,24(sp)
    800040ce:	1880                	addi	s0,sp,112
    800040d0:	84aa                	mv	s1,a0
    800040d2:	8aae                	mv	s5,a1
    800040d4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	d48080e7          	jalr	-696(ra) # 80000e1e <myproc>
    800040de:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040e0:	8526                	mv	a0,s1
    800040e2:	00002097          	auipc	ra,0x2
    800040e6:	6f0080e7          	jalr	1776(ra) # 800067d2 <acquire>
  while(i < n){
    800040ea:	0d405163          	blez	s4,800041ac <pipewrite+0xf6>
    800040ee:	8ba6                	mv	s7,s1
  int i = 0;
    800040f0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040f2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040f4:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040f8:	21c48c13          	addi	s8,s1,540
    800040fc:	a08d                	j	8000415e <pipewrite+0xa8>
      release(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	786080e7          	jalr	1926(ra) # 80006886 <release>
      return -1;
    80004108:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000410a:	854a                	mv	a0,s2
    8000410c:	70a6                	ld	ra,104(sp)
    8000410e:	7406                	ld	s0,96(sp)
    80004110:	64e6                	ld	s1,88(sp)
    80004112:	6946                	ld	s2,80(sp)
    80004114:	69a6                	ld	s3,72(sp)
    80004116:	6a06                	ld	s4,64(sp)
    80004118:	7ae2                	ld	s5,56(sp)
    8000411a:	7b42                	ld	s6,48(sp)
    8000411c:	7ba2                	ld	s7,40(sp)
    8000411e:	7c02                	ld	s8,32(sp)
    80004120:	6ce2                	ld	s9,24(sp)
    80004122:	6165                	addi	sp,sp,112
    80004124:	8082                	ret
      wakeup(&pi->nread);
    80004126:	8566                	mv	a0,s9
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	582080e7          	jalr	1410(ra) # 800016aa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004130:	85de                	mv	a1,s7
    80004132:	8562                	mv	a0,s8
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	3ea080e7          	jalr	1002(ra) # 8000151e <sleep>
    8000413c:	a839                	j	8000415a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000413e:	21c4a783          	lw	a5,540(s1)
    80004142:	0017871b          	addiw	a4,a5,1
    80004146:	20e4ae23          	sw	a4,540(s1)
    8000414a:	1ff7f793          	andi	a5,a5,511
    8000414e:	97a6                	add	a5,a5,s1
    80004150:	f9f44703          	lbu	a4,-97(s0)
    80004154:	00e78c23          	sb	a4,24(a5)
      i++;
    80004158:	2905                	addiw	s2,s2,1
  while(i < n){
    8000415a:	03495d63          	bge	s2,s4,80004194 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000415e:	2204a783          	lw	a5,544(s1)
    80004162:	dfd1                	beqz	a5,800040fe <pipewrite+0x48>
    80004164:	0289a783          	lw	a5,40(s3)
    80004168:	fbd9                	bnez	a5,800040fe <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000416a:	2184a783          	lw	a5,536(s1)
    8000416e:	21c4a703          	lw	a4,540(s1)
    80004172:	2007879b          	addiw	a5,a5,512
    80004176:	faf708e3          	beq	a4,a5,80004126 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000417a:	4685                	li	a3,1
    8000417c:	01590633          	add	a2,s2,s5
    80004180:	f9f40593          	addi	a1,s0,-97
    80004184:	0509b503          	ld	a0,80(s3)
    80004188:	ffffd097          	auipc	ra,0xffffd
    8000418c:	9e4080e7          	jalr	-1564(ra) # 80000b6c <copyin>
    80004190:	fb6517e3          	bne	a0,s6,8000413e <pipewrite+0x88>
  wakeup(&pi->nread);
    80004194:	21848513          	addi	a0,s1,536
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	512080e7          	jalr	1298(ra) # 800016aa <wakeup>
  release(&pi->lock);
    800041a0:	8526                	mv	a0,s1
    800041a2:	00002097          	auipc	ra,0x2
    800041a6:	6e4080e7          	jalr	1764(ra) # 80006886 <release>
  return i;
    800041aa:	b785                	j	8000410a <pipewrite+0x54>
  int i = 0;
    800041ac:	4901                	li	s2,0
    800041ae:	b7dd                	j	80004194 <pipewrite+0xde>

00000000800041b0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041b0:	715d                	addi	sp,sp,-80
    800041b2:	e486                	sd	ra,72(sp)
    800041b4:	e0a2                	sd	s0,64(sp)
    800041b6:	fc26                	sd	s1,56(sp)
    800041b8:	f84a                	sd	s2,48(sp)
    800041ba:	f44e                	sd	s3,40(sp)
    800041bc:	f052                	sd	s4,32(sp)
    800041be:	ec56                	sd	s5,24(sp)
    800041c0:	e85a                	sd	s6,16(sp)
    800041c2:	0880                	addi	s0,sp,80
    800041c4:	84aa                	mv	s1,a0
    800041c6:	892e                	mv	s2,a1
    800041c8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	c54080e7          	jalr	-940(ra) # 80000e1e <myproc>
    800041d2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041d4:	8b26                	mv	s6,s1
    800041d6:	8526                	mv	a0,s1
    800041d8:	00002097          	auipc	ra,0x2
    800041dc:	5fa080e7          	jalr	1530(ra) # 800067d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041e0:	2184a703          	lw	a4,536(s1)
    800041e4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041e8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ec:	02f71463          	bne	a4,a5,80004214 <piperead+0x64>
    800041f0:	2244a783          	lw	a5,548(s1)
    800041f4:	c385                	beqz	a5,80004214 <piperead+0x64>
    if(pr->killed){
    800041f6:	028a2783          	lw	a5,40(s4)
    800041fa:	ebc1                	bnez	a5,8000428a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041fc:	85da                	mv	a1,s6
    800041fe:	854e                	mv	a0,s3
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	31e080e7          	jalr	798(ra) # 8000151e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004208:	2184a703          	lw	a4,536(s1)
    8000420c:	21c4a783          	lw	a5,540(s1)
    80004210:	fef700e3          	beq	a4,a5,800041f0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004214:	09505263          	blez	s5,80004298 <piperead+0xe8>
    80004218:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000421a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000421c:	2184a783          	lw	a5,536(s1)
    80004220:	21c4a703          	lw	a4,540(s1)
    80004224:	02f70d63          	beq	a4,a5,8000425e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004228:	0017871b          	addiw	a4,a5,1
    8000422c:	20e4ac23          	sw	a4,536(s1)
    80004230:	1ff7f793          	andi	a5,a5,511
    80004234:	97a6                	add	a5,a5,s1
    80004236:	0187c783          	lbu	a5,24(a5)
    8000423a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000423e:	4685                	li	a3,1
    80004240:	fbf40613          	addi	a2,s0,-65
    80004244:	85ca                	mv	a1,s2
    80004246:	050a3503          	ld	a0,80(s4)
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	896080e7          	jalr	-1898(ra) # 80000ae0 <copyout>
    80004252:	01650663          	beq	a0,s6,8000425e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004256:	2985                	addiw	s3,s3,1
    80004258:	0905                	addi	s2,s2,1
    8000425a:	fd3a91e3          	bne	s5,s3,8000421c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000425e:	21c48513          	addi	a0,s1,540
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	448080e7          	jalr	1096(ra) # 800016aa <wakeup>
  release(&pi->lock);
    8000426a:	8526                	mv	a0,s1
    8000426c:	00002097          	auipc	ra,0x2
    80004270:	61a080e7          	jalr	1562(ra) # 80006886 <release>
  return i;
}
    80004274:	854e                	mv	a0,s3
    80004276:	60a6                	ld	ra,72(sp)
    80004278:	6406                	ld	s0,64(sp)
    8000427a:	74e2                	ld	s1,56(sp)
    8000427c:	7942                	ld	s2,48(sp)
    8000427e:	79a2                	ld	s3,40(sp)
    80004280:	7a02                	ld	s4,32(sp)
    80004282:	6ae2                	ld	s5,24(sp)
    80004284:	6b42                	ld	s6,16(sp)
    80004286:	6161                	addi	sp,sp,80
    80004288:	8082                	ret
      release(&pi->lock);
    8000428a:	8526                	mv	a0,s1
    8000428c:	00002097          	auipc	ra,0x2
    80004290:	5fa080e7          	jalr	1530(ra) # 80006886 <release>
      return -1;
    80004294:	59fd                	li	s3,-1
    80004296:	bff9                	j	80004274 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004298:	4981                	li	s3,0
    8000429a:	b7d1                	j	8000425e <piperead+0xae>

000000008000429c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000429c:	df010113          	addi	sp,sp,-528
    800042a0:	20113423          	sd	ra,520(sp)
    800042a4:	20813023          	sd	s0,512(sp)
    800042a8:	ffa6                	sd	s1,504(sp)
    800042aa:	fbca                	sd	s2,496(sp)
    800042ac:	f7ce                	sd	s3,488(sp)
    800042ae:	f3d2                	sd	s4,480(sp)
    800042b0:	efd6                	sd	s5,472(sp)
    800042b2:	ebda                	sd	s6,464(sp)
    800042b4:	e7de                	sd	s7,456(sp)
    800042b6:	e3e2                	sd	s8,448(sp)
    800042b8:	ff66                	sd	s9,440(sp)
    800042ba:	fb6a                	sd	s10,432(sp)
    800042bc:	f76e                	sd	s11,424(sp)
    800042be:	0c00                	addi	s0,sp,528
    800042c0:	84aa                	mv	s1,a0
    800042c2:	dea43c23          	sd	a0,-520(s0)
    800042c6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	b54080e7          	jalr	-1196(ra) # 80000e1e <myproc>
    800042d2:	892a                	mv	s2,a0

  begin_op();
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	49c080e7          	jalr	1180(ra) # 80003770 <begin_op>

  if((ip = namei(path)) == 0){
    800042dc:	8526                	mv	a0,s1
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	276080e7          	jalr	630(ra) # 80003554 <namei>
    800042e6:	c92d                	beqz	a0,80004358 <exec+0xbc>
    800042e8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	ab4080e7          	jalr	-1356(ra) # 80002d9e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042f2:	04000713          	li	a4,64
    800042f6:	4681                	li	a3,0
    800042f8:	e5040613          	addi	a2,s0,-432
    800042fc:	4581                	li	a1,0
    800042fe:	8526                	mv	a0,s1
    80004300:	fffff097          	auipc	ra,0xfffff
    80004304:	d52080e7          	jalr	-686(ra) # 80003052 <readi>
    80004308:	04000793          	li	a5,64
    8000430c:	00f51a63          	bne	a0,a5,80004320 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004310:	e5042703          	lw	a4,-432(s0)
    80004314:	464c47b7          	lui	a5,0x464c4
    80004318:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000431c:	04f70463          	beq	a4,a5,80004364 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004320:	8526                	mv	a0,s1
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	cde080e7          	jalr	-802(ra) # 80003000 <iunlockput>
    end_op();
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	4c6080e7          	jalr	1222(ra) # 800037f0 <end_op>
  }
  return -1;
    80004332:	557d                	li	a0,-1
}
    80004334:	20813083          	ld	ra,520(sp)
    80004338:	20013403          	ld	s0,512(sp)
    8000433c:	74fe                	ld	s1,504(sp)
    8000433e:	795e                	ld	s2,496(sp)
    80004340:	79be                	ld	s3,488(sp)
    80004342:	7a1e                	ld	s4,480(sp)
    80004344:	6afe                	ld	s5,472(sp)
    80004346:	6b5e                	ld	s6,464(sp)
    80004348:	6bbe                	ld	s7,456(sp)
    8000434a:	6c1e                	ld	s8,448(sp)
    8000434c:	7cfa                	ld	s9,440(sp)
    8000434e:	7d5a                	ld	s10,432(sp)
    80004350:	7dba                	ld	s11,424(sp)
    80004352:	21010113          	addi	sp,sp,528
    80004356:	8082                	ret
    end_op();
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	498080e7          	jalr	1176(ra) # 800037f0 <end_op>
    return -1;
    80004360:	557d                	li	a0,-1
    80004362:	bfc9                	j	80004334 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004364:	854a                	mv	a0,s2
    80004366:	ffffd097          	auipc	ra,0xffffd
    8000436a:	b7c080e7          	jalr	-1156(ra) # 80000ee2 <proc_pagetable>
    8000436e:	8baa                	mv	s7,a0
    80004370:	d945                	beqz	a0,80004320 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004372:	e7042983          	lw	s3,-400(s0)
    80004376:	e8845783          	lhu	a5,-376(s0)
    8000437a:	c7ad                	beqz	a5,800043e4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000437c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000437e:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004380:	6c85                	lui	s9,0x1
    80004382:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004386:	def43823          	sd	a5,-528(s0)
    8000438a:	a42d                	j	800045b4 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000438c:	00004517          	auipc	a0,0x4
    80004390:	29450513          	addi	a0,a0,660 # 80008620 <syscalls+0x290>
    80004394:	00002097          	auipc	ra,0x2
    80004398:	ef4080e7          	jalr	-268(ra) # 80006288 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000439c:	8756                	mv	a4,s5
    8000439e:	012d86bb          	addw	a3,s11,s2
    800043a2:	4581                	li	a1,0
    800043a4:	8526                	mv	a0,s1
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	cac080e7          	jalr	-852(ra) # 80003052 <readi>
    800043ae:	2501                	sext.w	a0,a0
    800043b0:	1aaa9963          	bne	s5,a0,80004562 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800043b4:	6785                	lui	a5,0x1
    800043b6:	0127893b          	addw	s2,a5,s2
    800043ba:	77fd                	lui	a5,0xfffff
    800043bc:	01478a3b          	addw	s4,a5,s4
    800043c0:	1f897163          	bgeu	s2,s8,800045a2 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800043c4:	02091593          	slli	a1,s2,0x20
    800043c8:	9181                	srli	a1,a1,0x20
    800043ca:	95ea                	add	a1,a1,s10
    800043cc:	855e                	mv	a0,s7
    800043ce:	ffffc097          	auipc	ra,0xffffc
    800043d2:	138080e7          	jalr	312(ra) # 80000506 <walkaddr>
    800043d6:	862a                	mv	a2,a0
    if(pa == 0)
    800043d8:	d955                	beqz	a0,8000438c <exec+0xf0>
      n = PGSIZE;
    800043da:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043dc:	fd9a70e3          	bgeu	s4,s9,8000439c <exec+0x100>
      n = sz - i;
    800043e0:	8ad2                	mv	s5,s4
    800043e2:	bf6d                	j	8000439c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043e4:	4901                	li	s2,0
  iunlockput(ip);
    800043e6:	8526                	mv	a0,s1
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	c18080e7          	jalr	-1000(ra) # 80003000 <iunlockput>
  end_op();
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	400080e7          	jalr	1024(ra) # 800037f0 <end_op>
  p = myproc();
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	a26080e7          	jalr	-1498(ra) # 80000e1e <myproc>
    80004400:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004402:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004406:	6785                	lui	a5,0x1
    80004408:	17fd                	addi	a5,a5,-1
    8000440a:	993e                	add	s2,s2,a5
    8000440c:	757d                	lui	a0,0xfffff
    8000440e:	00a977b3          	and	a5,s2,a0
    80004412:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004416:	6609                	lui	a2,0x2
    80004418:	963e                	add	a2,a2,a5
    8000441a:	85be                	mv	a1,a5
    8000441c:	855e                	mv	a0,s7
    8000441e:	ffffc097          	auipc	ra,0xffffc
    80004422:	47e080e7          	jalr	1150(ra) # 8000089c <uvmalloc>
    80004426:	8b2a                	mv	s6,a0
  ip = 0;
    80004428:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000442a:	12050c63          	beqz	a0,80004562 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000442e:	75f9                	lui	a1,0xffffe
    80004430:	95aa                	add	a1,a1,a0
    80004432:	855e                	mv	a0,s7
    80004434:	ffffc097          	auipc	ra,0xffffc
    80004438:	67a080e7          	jalr	1658(ra) # 80000aae <uvmclear>
  stackbase = sp - PGSIZE;
    8000443c:	7c7d                	lui	s8,0xfffff
    8000443e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004440:	e0043783          	ld	a5,-512(s0)
    80004444:	6388                	ld	a0,0(a5)
    80004446:	c535                	beqz	a0,800044b2 <exec+0x216>
    80004448:	e9040993          	addi	s3,s0,-368
    8000444c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004450:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	eaa080e7          	jalr	-342(ra) # 800002fc <strlen>
    8000445a:	2505                	addiw	a0,a0,1
    8000445c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004460:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004464:	13896363          	bltu	s2,s8,8000458a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004468:	e0043d83          	ld	s11,-512(s0)
    8000446c:	000dba03          	ld	s4,0(s11)
    80004470:	8552                	mv	a0,s4
    80004472:	ffffc097          	auipc	ra,0xffffc
    80004476:	e8a080e7          	jalr	-374(ra) # 800002fc <strlen>
    8000447a:	0015069b          	addiw	a3,a0,1
    8000447e:	8652                	mv	a2,s4
    80004480:	85ca                	mv	a1,s2
    80004482:	855e                	mv	a0,s7
    80004484:	ffffc097          	auipc	ra,0xffffc
    80004488:	65c080e7          	jalr	1628(ra) # 80000ae0 <copyout>
    8000448c:	10054363          	bltz	a0,80004592 <exec+0x2f6>
    ustack[argc] = sp;
    80004490:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004494:	0485                	addi	s1,s1,1
    80004496:	008d8793          	addi	a5,s11,8
    8000449a:	e0f43023          	sd	a5,-512(s0)
    8000449e:	008db503          	ld	a0,8(s11)
    800044a2:	c911                	beqz	a0,800044b6 <exec+0x21a>
    if(argc >= MAXARG)
    800044a4:	09a1                	addi	s3,s3,8
    800044a6:	fb3c96e3          	bne	s9,s3,80004452 <exec+0x1b6>
  sz = sz1;
    800044aa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ae:	4481                	li	s1,0
    800044b0:	a84d                	j	80004562 <exec+0x2c6>
  sp = sz;
    800044b2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044b4:	4481                	li	s1,0
  ustack[argc] = 0;
    800044b6:	00349793          	slli	a5,s1,0x3
    800044ba:	f9040713          	addi	a4,s0,-112
    800044be:	97ba                	add	a5,a5,a4
    800044c0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044c4:	00148693          	addi	a3,s1,1
    800044c8:	068e                	slli	a3,a3,0x3
    800044ca:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044ce:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044d2:	01897663          	bgeu	s2,s8,800044de <exec+0x242>
  sz = sz1;
    800044d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044da:	4481                	li	s1,0
    800044dc:	a059                	j	80004562 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044de:	e9040613          	addi	a2,s0,-368
    800044e2:	85ca                	mv	a1,s2
    800044e4:	855e                	mv	a0,s7
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	5fa080e7          	jalr	1530(ra) # 80000ae0 <copyout>
    800044ee:	0a054663          	bltz	a0,8000459a <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044f2:	058ab783          	ld	a5,88(s5)
    800044f6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044fa:	df843783          	ld	a5,-520(s0)
    800044fe:	0007c703          	lbu	a4,0(a5)
    80004502:	cf11                	beqz	a4,8000451e <exec+0x282>
    80004504:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004506:	02f00693          	li	a3,47
    8000450a:	a039                	j	80004518 <exec+0x27c>
      last = s+1;
    8000450c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004510:	0785                	addi	a5,a5,1
    80004512:	fff7c703          	lbu	a4,-1(a5)
    80004516:	c701                	beqz	a4,8000451e <exec+0x282>
    if(*s == '/')
    80004518:	fed71ce3          	bne	a4,a3,80004510 <exec+0x274>
    8000451c:	bfc5                	j	8000450c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000451e:	4641                	li	a2,16
    80004520:	df843583          	ld	a1,-520(s0)
    80004524:	158a8513          	addi	a0,s5,344
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	da2080e7          	jalr	-606(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004530:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004534:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004538:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000453c:	058ab783          	ld	a5,88(s5)
    80004540:	e6843703          	ld	a4,-408(s0)
    80004544:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004546:	058ab783          	ld	a5,88(s5)
    8000454a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000454e:	85ea                	mv	a1,s10
    80004550:	ffffd097          	auipc	ra,0xffffd
    80004554:	a2e080e7          	jalr	-1490(ra) # 80000f7e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004558:	0004851b          	sext.w	a0,s1
    8000455c:	bbe1                	j	80004334 <exec+0x98>
    8000455e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004562:	e0843583          	ld	a1,-504(s0)
    80004566:	855e                	mv	a0,s7
    80004568:	ffffd097          	auipc	ra,0xffffd
    8000456c:	a16080e7          	jalr	-1514(ra) # 80000f7e <proc_freepagetable>
  if(ip){
    80004570:	da0498e3          	bnez	s1,80004320 <exec+0x84>
  return -1;
    80004574:	557d                	li	a0,-1
    80004576:	bb7d                	j	80004334 <exec+0x98>
    80004578:	e1243423          	sd	s2,-504(s0)
    8000457c:	b7dd                	j	80004562 <exec+0x2c6>
    8000457e:	e1243423          	sd	s2,-504(s0)
    80004582:	b7c5                	j	80004562 <exec+0x2c6>
    80004584:	e1243423          	sd	s2,-504(s0)
    80004588:	bfe9                	j	80004562 <exec+0x2c6>
  sz = sz1;
    8000458a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000458e:	4481                	li	s1,0
    80004590:	bfc9                	j	80004562 <exec+0x2c6>
  sz = sz1;
    80004592:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004596:	4481                	li	s1,0
    80004598:	b7e9                	j	80004562 <exec+0x2c6>
  sz = sz1;
    8000459a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000459e:	4481                	li	s1,0
    800045a0:	b7c9                	j	80004562 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045a2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045a6:	2b05                	addiw	s6,s6,1
    800045a8:	0389899b          	addiw	s3,s3,56
    800045ac:	e8845783          	lhu	a5,-376(s0)
    800045b0:	e2fb5be3          	bge	s6,a5,800043e6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045b4:	2981                	sext.w	s3,s3
    800045b6:	03800713          	li	a4,56
    800045ba:	86ce                	mv	a3,s3
    800045bc:	e1840613          	addi	a2,s0,-488
    800045c0:	4581                	li	a1,0
    800045c2:	8526                	mv	a0,s1
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	a8e080e7          	jalr	-1394(ra) # 80003052 <readi>
    800045cc:	03800793          	li	a5,56
    800045d0:	f8f517e3          	bne	a0,a5,8000455e <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800045d4:	e1842783          	lw	a5,-488(s0)
    800045d8:	4705                	li	a4,1
    800045da:	fce796e3          	bne	a5,a4,800045a6 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045de:	e4043603          	ld	a2,-448(s0)
    800045e2:	e3843783          	ld	a5,-456(s0)
    800045e6:	f8f669e3          	bltu	a2,a5,80004578 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045ea:	e2843783          	ld	a5,-472(s0)
    800045ee:	963e                	add	a2,a2,a5
    800045f0:	f8f667e3          	bltu	a2,a5,8000457e <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045f4:	85ca                	mv	a1,s2
    800045f6:	855e                	mv	a0,s7
    800045f8:	ffffc097          	auipc	ra,0xffffc
    800045fc:	2a4080e7          	jalr	676(ra) # 8000089c <uvmalloc>
    80004600:	e0a43423          	sd	a0,-504(s0)
    80004604:	d141                	beqz	a0,80004584 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004606:	e2843d03          	ld	s10,-472(s0)
    8000460a:	df043783          	ld	a5,-528(s0)
    8000460e:	00fd77b3          	and	a5,s10,a5
    80004612:	fba1                	bnez	a5,80004562 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004614:	e2042d83          	lw	s11,-480(s0)
    80004618:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000461c:	f80c03e3          	beqz	s8,800045a2 <exec+0x306>
    80004620:	8a62                	mv	s4,s8
    80004622:	4901                	li	s2,0
    80004624:	b345                	j	800043c4 <exec+0x128>

0000000080004626 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004626:	7179                	addi	sp,sp,-48
    80004628:	f406                	sd	ra,40(sp)
    8000462a:	f022                	sd	s0,32(sp)
    8000462c:	ec26                	sd	s1,24(sp)
    8000462e:	e84a                	sd	s2,16(sp)
    80004630:	1800                	addi	s0,sp,48
    80004632:	892e                	mv	s2,a1
    80004634:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004636:	fdc40593          	addi	a1,s0,-36
    8000463a:	ffffe097          	auipc	ra,0xffffe
    8000463e:	bf2080e7          	jalr	-1038(ra) # 8000222c <argint>
    80004642:	04054063          	bltz	a0,80004682 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004646:	fdc42703          	lw	a4,-36(s0)
    8000464a:	47bd                	li	a5,15
    8000464c:	02e7ed63          	bltu	a5,a4,80004686 <argfd+0x60>
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	7ce080e7          	jalr	1998(ra) # 80000e1e <myproc>
    80004658:	fdc42703          	lw	a4,-36(s0)
    8000465c:	01a70793          	addi	a5,a4,26
    80004660:	078e                	slli	a5,a5,0x3
    80004662:	953e                	add	a0,a0,a5
    80004664:	611c                	ld	a5,0(a0)
    80004666:	c395                	beqz	a5,8000468a <argfd+0x64>
    return -1;
  if(pfd)
    80004668:	00090463          	beqz	s2,80004670 <argfd+0x4a>
    *pfd = fd;
    8000466c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004670:	4501                	li	a0,0
  if(pf)
    80004672:	c091                	beqz	s1,80004676 <argfd+0x50>
    *pf = f;
    80004674:	e09c                	sd	a5,0(s1)
}
    80004676:	70a2                	ld	ra,40(sp)
    80004678:	7402                	ld	s0,32(sp)
    8000467a:	64e2                	ld	s1,24(sp)
    8000467c:	6942                	ld	s2,16(sp)
    8000467e:	6145                	addi	sp,sp,48
    80004680:	8082                	ret
    return -1;
    80004682:	557d                	li	a0,-1
    80004684:	bfcd                	j	80004676 <argfd+0x50>
    return -1;
    80004686:	557d                	li	a0,-1
    80004688:	b7fd                	j	80004676 <argfd+0x50>
    8000468a:	557d                	li	a0,-1
    8000468c:	b7ed                	j	80004676 <argfd+0x50>

000000008000468e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000468e:	1101                	addi	sp,sp,-32
    80004690:	ec06                	sd	ra,24(sp)
    80004692:	e822                	sd	s0,16(sp)
    80004694:	e426                	sd	s1,8(sp)
    80004696:	1000                	addi	s0,sp,32
    80004698:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000469a:	ffffc097          	auipc	ra,0xffffc
    8000469e:	784080e7          	jalr	1924(ra) # 80000e1e <myproc>
    800046a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046a4:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd0e90>
    800046a8:	4501                	li	a0,0
    800046aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046ac:	6398                	ld	a4,0(a5)
    800046ae:	cb19                	beqz	a4,800046c4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046b0:	2505                	addiw	a0,a0,1
    800046b2:	07a1                	addi	a5,a5,8
    800046b4:	fed51ce3          	bne	a0,a3,800046ac <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046b8:	557d                	li	a0,-1
}
    800046ba:	60e2                	ld	ra,24(sp)
    800046bc:	6442                	ld	s0,16(sp)
    800046be:	64a2                	ld	s1,8(sp)
    800046c0:	6105                	addi	sp,sp,32
    800046c2:	8082                	ret
      p->ofile[fd] = f;
    800046c4:	01a50793          	addi	a5,a0,26
    800046c8:	078e                	slli	a5,a5,0x3
    800046ca:	963e                	add	a2,a2,a5
    800046cc:	e204                	sd	s1,0(a2)
      return fd;
    800046ce:	b7f5                	j	800046ba <fdalloc+0x2c>

00000000800046d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046d0:	715d                	addi	sp,sp,-80
    800046d2:	e486                	sd	ra,72(sp)
    800046d4:	e0a2                	sd	s0,64(sp)
    800046d6:	fc26                	sd	s1,56(sp)
    800046d8:	f84a                	sd	s2,48(sp)
    800046da:	f44e                	sd	s3,40(sp)
    800046dc:	f052                	sd	s4,32(sp)
    800046de:	ec56                	sd	s5,24(sp)
    800046e0:	0880                	addi	s0,sp,80
    800046e2:	89ae                	mv	s3,a1
    800046e4:	8ab2                	mv	s5,a2
    800046e6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046e8:	fb040593          	addi	a1,s0,-80
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	e86080e7          	jalr	-378(ra) # 80003572 <nameiparent>
    800046f4:	892a                	mv	s2,a0
    800046f6:	12050f63          	beqz	a0,80004834 <create+0x164>
    return 0;

  ilock(dp);
    800046fa:	ffffe097          	auipc	ra,0xffffe
    800046fe:	6a4080e7          	jalr	1700(ra) # 80002d9e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004702:	4601                	li	a2,0
    80004704:	fb040593          	addi	a1,s0,-80
    80004708:	854a                	mv	a0,s2
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	b78080e7          	jalr	-1160(ra) # 80003282 <dirlookup>
    80004712:	84aa                	mv	s1,a0
    80004714:	c921                	beqz	a0,80004764 <create+0x94>
    iunlockput(dp);
    80004716:	854a                	mv	a0,s2
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	8e8080e7          	jalr	-1816(ra) # 80003000 <iunlockput>
    ilock(ip);
    80004720:	8526                	mv	a0,s1
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	67c080e7          	jalr	1660(ra) # 80002d9e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000472a:	2981                	sext.w	s3,s3
    8000472c:	4789                	li	a5,2
    8000472e:	02f99463          	bne	s3,a5,80004756 <create+0x86>
    80004732:	0444d783          	lhu	a5,68(s1)
    80004736:	37f9                	addiw	a5,a5,-2
    80004738:	17c2                	slli	a5,a5,0x30
    8000473a:	93c1                	srli	a5,a5,0x30
    8000473c:	4705                	li	a4,1
    8000473e:	00f76c63          	bltu	a4,a5,80004756 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004742:	8526                	mv	a0,s1
    80004744:	60a6                	ld	ra,72(sp)
    80004746:	6406                	ld	s0,64(sp)
    80004748:	74e2                	ld	s1,56(sp)
    8000474a:	7942                	ld	s2,48(sp)
    8000474c:	79a2                	ld	s3,40(sp)
    8000474e:	7a02                	ld	s4,32(sp)
    80004750:	6ae2                	ld	s5,24(sp)
    80004752:	6161                	addi	sp,sp,80
    80004754:	8082                	ret
    iunlockput(ip);
    80004756:	8526                	mv	a0,s1
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	8a8080e7          	jalr	-1880(ra) # 80003000 <iunlockput>
    return 0;
    80004760:	4481                	li	s1,0
    80004762:	b7c5                	j	80004742 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004764:	85ce                	mv	a1,s3
    80004766:	00092503          	lw	a0,0(s2)
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	49c080e7          	jalr	1180(ra) # 80002c06 <ialloc>
    80004772:	84aa                	mv	s1,a0
    80004774:	c529                	beqz	a0,800047be <create+0xee>
  ilock(ip);
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	628080e7          	jalr	1576(ra) # 80002d9e <ilock>
  ip->major = major;
    8000477e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004782:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004786:	4785                	li	a5,1
    80004788:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000478c:	8526                	mv	a0,s1
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	546080e7          	jalr	1350(ra) # 80002cd4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004796:	2981                	sext.w	s3,s3
    80004798:	4785                	li	a5,1
    8000479a:	02f98a63          	beq	s3,a5,800047ce <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000479e:	40d0                	lw	a2,4(s1)
    800047a0:	fb040593          	addi	a1,s0,-80
    800047a4:	854a                	mv	a0,s2
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	cec080e7          	jalr	-788(ra) # 80003492 <dirlink>
    800047ae:	06054b63          	bltz	a0,80004824 <create+0x154>
  iunlockput(dp);
    800047b2:	854a                	mv	a0,s2
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	84c080e7          	jalr	-1972(ra) # 80003000 <iunlockput>
  return ip;
    800047bc:	b759                	j	80004742 <create+0x72>
    panic("create: ialloc");
    800047be:	00004517          	auipc	a0,0x4
    800047c2:	e8250513          	addi	a0,a0,-382 # 80008640 <syscalls+0x2b0>
    800047c6:	00002097          	auipc	ra,0x2
    800047ca:	ac2080e7          	jalr	-1342(ra) # 80006288 <panic>
    dp->nlink++;  // for ".."
    800047ce:	04a95783          	lhu	a5,74(s2)
    800047d2:	2785                	addiw	a5,a5,1
    800047d4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047d8:	854a                	mv	a0,s2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	4fa080e7          	jalr	1274(ra) # 80002cd4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047e2:	40d0                	lw	a2,4(s1)
    800047e4:	00004597          	auipc	a1,0x4
    800047e8:	e6c58593          	addi	a1,a1,-404 # 80008650 <syscalls+0x2c0>
    800047ec:	8526                	mv	a0,s1
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	ca4080e7          	jalr	-860(ra) # 80003492 <dirlink>
    800047f6:	00054f63          	bltz	a0,80004814 <create+0x144>
    800047fa:	00492603          	lw	a2,4(s2)
    800047fe:	00004597          	auipc	a1,0x4
    80004802:	e5a58593          	addi	a1,a1,-422 # 80008658 <syscalls+0x2c8>
    80004806:	8526                	mv	a0,s1
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	c8a080e7          	jalr	-886(ra) # 80003492 <dirlink>
    80004810:	f80557e3          	bgez	a0,8000479e <create+0xce>
      panic("create dots");
    80004814:	00004517          	auipc	a0,0x4
    80004818:	e4c50513          	addi	a0,a0,-436 # 80008660 <syscalls+0x2d0>
    8000481c:	00002097          	auipc	ra,0x2
    80004820:	a6c080e7          	jalr	-1428(ra) # 80006288 <panic>
    panic("create: dirlink");
    80004824:	00004517          	auipc	a0,0x4
    80004828:	e4c50513          	addi	a0,a0,-436 # 80008670 <syscalls+0x2e0>
    8000482c:	00002097          	auipc	ra,0x2
    80004830:	a5c080e7          	jalr	-1444(ra) # 80006288 <panic>
    return 0;
    80004834:	84aa                	mv	s1,a0
    80004836:	b731                	j	80004742 <create+0x72>

0000000080004838 <sys_dup>:
{
    80004838:	7179                	addi	sp,sp,-48
    8000483a:	f406                	sd	ra,40(sp)
    8000483c:	f022                	sd	s0,32(sp)
    8000483e:	ec26                	sd	s1,24(sp)
    80004840:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004842:	fd840613          	addi	a2,s0,-40
    80004846:	4581                	li	a1,0
    80004848:	4501                	li	a0,0
    8000484a:	00000097          	auipc	ra,0x0
    8000484e:	ddc080e7          	jalr	-548(ra) # 80004626 <argfd>
    return -1;
    80004852:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004854:	02054363          	bltz	a0,8000487a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004858:	fd843503          	ld	a0,-40(s0)
    8000485c:	00000097          	auipc	ra,0x0
    80004860:	e32080e7          	jalr	-462(ra) # 8000468e <fdalloc>
    80004864:	84aa                	mv	s1,a0
    return -1;
    80004866:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004868:	00054963          	bltz	a0,8000487a <sys_dup+0x42>
  filedup(f);
    8000486c:	fd843503          	ld	a0,-40(s0)
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	37a080e7          	jalr	890(ra) # 80003bea <filedup>
  return fd;
    80004878:	87a6                	mv	a5,s1
}
    8000487a:	853e                	mv	a0,a5
    8000487c:	70a2                	ld	ra,40(sp)
    8000487e:	7402                	ld	s0,32(sp)
    80004880:	64e2                	ld	s1,24(sp)
    80004882:	6145                	addi	sp,sp,48
    80004884:	8082                	ret

0000000080004886 <sys_read>:
{
    80004886:	7179                	addi	sp,sp,-48
    80004888:	f406                	sd	ra,40(sp)
    8000488a:	f022                	sd	s0,32(sp)
    8000488c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	fe840613          	addi	a2,s0,-24
    80004892:	4581                	li	a1,0
    80004894:	4501                	li	a0,0
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	d90080e7          	jalr	-624(ra) # 80004626 <argfd>
    return -1;
    8000489e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a0:	04054163          	bltz	a0,800048e2 <sys_read+0x5c>
    800048a4:	fe440593          	addi	a1,s0,-28
    800048a8:	4509                	li	a0,2
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	982080e7          	jalr	-1662(ra) # 8000222c <argint>
    return -1;
    800048b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b4:	02054763          	bltz	a0,800048e2 <sys_read+0x5c>
    800048b8:	fd840593          	addi	a1,s0,-40
    800048bc:	4505                	li	a0,1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	990080e7          	jalr	-1648(ra) # 8000224e <argaddr>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c8:	00054d63          	bltz	a0,800048e2 <sys_read+0x5c>
  return fileread(f, p, n);
    800048cc:	fe442603          	lw	a2,-28(s0)
    800048d0:	fd843583          	ld	a1,-40(s0)
    800048d4:	fe843503          	ld	a0,-24(s0)
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	49e080e7          	jalr	1182(ra) # 80003d76 <fileread>
    800048e0:	87aa                	mv	a5,a0
}
    800048e2:	853e                	mv	a0,a5
    800048e4:	70a2                	ld	ra,40(sp)
    800048e6:	7402                	ld	s0,32(sp)
    800048e8:	6145                	addi	sp,sp,48
    800048ea:	8082                	ret

00000000800048ec <sys_write>:
{
    800048ec:	7179                	addi	sp,sp,-48
    800048ee:	f406                	sd	ra,40(sp)
    800048f0:	f022                	sd	s0,32(sp)
    800048f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f4:	fe840613          	addi	a2,s0,-24
    800048f8:	4581                	li	a1,0
    800048fa:	4501                	li	a0,0
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	d2a080e7          	jalr	-726(ra) # 80004626 <argfd>
    return -1;
    80004904:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004906:	04054163          	bltz	a0,80004948 <sys_write+0x5c>
    8000490a:	fe440593          	addi	a1,s0,-28
    8000490e:	4509                	li	a0,2
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	91c080e7          	jalr	-1764(ra) # 8000222c <argint>
    return -1;
    80004918:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000491a:	02054763          	bltz	a0,80004948 <sys_write+0x5c>
    8000491e:	fd840593          	addi	a1,s0,-40
    80004922:	4505                	li	a0,1
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	92a080e7          	jalr	-1750(ra) # 8000224e <argaddr>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492e:	00054d63          	bltz	a0,80004948 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004932:	fe442603          	lw	a2,-28(s0)
    80004936:	fd843583          	ld	a1,-40(s0)
    8000493a:	fe843503          	ld	a0,-24(s0)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	4fa080e7          	jalr	1274(ra) # 80003e38 <filewrite>
    80004946:	87aa                	mv	a5,a0
}
    80004948:	853e                	mv	a0,a5
    8000494a:	70a2                	ld	ra,40(sp)
    8000494c:	7402                	ld	s0,32(sp)
    8000494e:	6145                	addi	sp,sp,48
    80004950:	8082                	ret

0000000080004952 <sys_close>:
{
    80004952:	1101                	addi	sp,sp,-32
    80004954:	ec06                	sd	ra,24(sp)
    80004956:	e822                	sd	s0,16(sp)
    80004958:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000495a:	fe040613          	addi	a2,s0,-32
    8000495e:	fec40593          	addi	a1,s0,-20
    80004962:	4501                	li	a0,0
    80004964:	00000097          	auipc	ra,0x0
    80004968:	cc2080e7          	jalr	-830(ra) # 80004626 <argfd>
    return -1;
    8000496c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000496e:	02054463          	bltz	a0,80004996 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004972:	ffffc097          	auipc	ra,0xffffc
    80004976:	4ac080e7          	jalr	1196(ra) # 80000e1e <myproc>
    8000497a:	fec42783          	lw	a5,-20(s0)
    8000497e:	07e9                	addi	a5,a5,26
    80004980:	078e                	slli	a5,a5,0x3
    80004982:	97aa                	add	a5,a5,a0
    80004984:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004988:	fe043503          	ld	a0,-32(s0)
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	2b0080e7          	jalr	688(ra) # 80003c3c <fileclose>
  return 0;
    80004994:	4781                	li	a5,0
}
    80004996:	853e                	mv	a0,a5
    80004998:	60e2                	ld	ra,24(sp)
    8000499a:	6442                	ld	s0,16(sp)
    8000499c:	6105                	addi	sp,sp,32
    8000499e:	8082                	ret

00000000800049a0 <sys_fstat>:
{
    800049a0:	1101                	addi	sp,sp,-32
    800049a2:	ec06                	sd	ra,24(sp)
    800049a4:	e822                	sd	s0,16(sp)
    800049a6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049a8:	fe840613          	addi	a2,s0,-24
    800049ac:	4581                	li	a1,0
    800049ae:	4501                	li	a0,0
    800049b0:	00000097          	auipc	ra,0x0
    800049b4:	c76080e7          	jalr	-906(ra) # 80004626 <argfd>
    return -1;
    800049b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ba:	02054563          	bltz	a0,800049e4 <sys_fstat+0x44>
    800049be:	fe040593          	addi	a1,s0,-32
    800049c2:	4505                	li	a0,1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	88a080e7          	jalr	-1910(ra) # 8000224e <argaddr>
    return -1;
    800049cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ce:	00054b63          	bltz	a0,800049e4 <sys_fstat+0x44>
  return filestat(f, st);
    800049d2:	fe043583          	ld	a1,-32(s0)
    800049d6:	fe843503          	ld	a0,-24(s0)
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	32a080e7          	jalr	810(ra) # 80003d04 <filestat>
    800049e2:	87aa                	mv	a5,a0
}
    800049e4:	853e                	mv	a0,a5
    800049e6:	60e2                	ld	ra,24(sp)
    800049e8:	6442                	ld	s0,16(sp)
    800049ea:	6105                	addi	sp,sp,32
    800049ec:	8082                	ret

00000000800049ee <sys_link>:
{
    800049ee:	7169                	addi	sp,sp,-304
    800049f0:	f606                	sd	ra,296(sp)
    800049f2:	f222                	sd	s0,288(sp)
    800049f4:	ee26                	sd	s1,280(sp)
    800049f6:	ea4a                	sd	s2,272(sp)
    800049f8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049fa:	08000613          	li	a2,128
    800049fe:	ed040593          	addi	a1,s0,-304
    80004a02:	4501                	li	a0,0
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	86c080e7          	jalr	-1940(ra) # 80002270 <argstr>
    return -1;
    80004a0c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0e:	10054e63          	bltz	a0,80004b2a <sys_link+0x13c>
    80004a12:	08000613          	li	a2,128
    80004a16:	f5040593          	addi	a1,s0,-176
    80004a1a:	4505                	li	a0,1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	854080e7          	jalr	-1964(ra) # 80002270 <argstr>
    return -1;
    80004a24:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a26:	10054263          	bltz	a0,80004b2a <sys_link+0x13c>
  begin_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	d46080e7          	jalr	-698(ra) # 80003770 <begin_op>
  if((ip = namei(old)) == 0){
    80004a32:	ed040513          	addi	a0,s0,-304
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	b1e080e7          	jalr	-1250(ra) # 80003554 <namei>
    80004a3e:	84aa                	mv	s1,a0
    80004a40:	c551                	beqz	a0,80004acc <sys_link+0xde>
  ilock(ip);
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	35c080e7          	jalr	860(ra) # 80002d9e <ilock>
  if(ip->type == T_DIR){
    80004a4a:	04449703          	lh	a4,68(s1)
    80004a4e:	4785                	li	a5,1
    80004a50:	08f70463          	beq	a4,a5,80004ad8 <sys_link+0xea>
  ip->nlink++;
    80004a54:	04a4d783          	lhu	a5,74(s1)
    80004a58:	2785                	addiw	a5,a5,1
    80004a5a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	274080e7          	jalr	628(ra) # 80002cd4 <iupdate>
  iunlock(ip);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3f6080e7          	jalr	1014(ra) # 80002e60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a72:	fd040593          	addi	a1,s0,-48
    80004a76:	f5040513          	addi	a0,s0,-176
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	af8080e7          	jalr	-1288(ra) # 80003572 <nameiparent>
    80004a82:	892a                	mv	s2,a0
    80004a84:	c935                	beqz	a0,80004af8 <sys_link+0x10a>
  ilock(dp);
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	318080e7          	jalr	792(ra) # 80002d9e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a8e:	00092703          	lw	a4,0(s2)
    80004a92:	409c                	lw	a5,0(s1)
    80004a94:	04f71d63          	bne	a4,a5,80004aee <sys_link+0x100>
    80004a98:	40d0                	lw	a2,4(s1)
    80004a9a:	fd040593          	addi	a1,s0,-48
    80004a9e:	854a                	mv	a0,s2
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	9f2080e7          	jalr	-1550(ra) # 80003492 <dirlink>
    80004aa8:	04054363          	bltz	a0,80004aee <sys_link+0x100>
  iunlockput(dp);
    80004aac:	854a                	mv	a0,s2
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	552080e7          	jalr	1362(ra) # 80003000 <iunlockput>
  iput(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	4a0080e7          	jalr	1184(ra) # 80002f58 <iput>
  end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	d30080e7          	jalr	-720(ra) # 800037f0 <end_op>
  return 0;
    80004ac8:	4781                	li	a5,0
    80004aca:	a085                	j	80004b2a <sys_link+0x13c>
    end_op();
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	d24080e7          	jalr	-732(ra) # 800037f0 <end_op>
    return -1;
    80004ad4:	57fd                	li	a5,-1
    80004ad6:	a891                	j	80004b2a <sys_link+0x13c>
    iunlockput(ip);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	526080e7          	jalr	1318(ra) # 80003000 <iunlockput>
    end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	d0e080e7          	jalr	-754(ra) # 800037f0 <end_op>
    return -1;
    80004aea:	57fd                	li	a5,-1
    80004aec:	a83d                	j	80004b2a <sys_link+0x13c>
    iunlockput(dp);
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	510080e7          	jalr	1296(ra) # 80003000 <iunlockput>
  ilock(ip);
    80004af8:	8526                	mv	a0,s1
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	2a4080e7          	jalr	676(ra) # 80002d9e <ilock>
  ip->nlink--;
    80004b02:	04a4d783          	lhu	a5,74(s1)
    80004b06:	37fd                	addiw	a5,a5,-1
    80004b08:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	1c6080e7          	jalr	454(ra) # 80002cd4 <iupdate>
  iunlockput(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	4e8080e7          	jalr	1256(ra) # 80003000 <iunlockput>
  end_op();
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	cd0080e7          	jalr	-816(ra) # 800037f0 <end_op>
  return -1;
    80004b28:	57fd                	li	a5,-1
}
    80004b2a:	853e                	mv	a0,a5
    80004b2c:	70b2                	ld	ra,296(sp)
    80004b2e:	7412                	ld	s0,288(sp)
    80004b30:	64f2                	ld	s1,280(sp)
    80004b32:	6952                	ld	s2,272(sp)
    80004b34:	6155                	addi	sp,sp,304
    80004b36:	8082                	ret

0000000080004b38 <sys_unlink>:
{
    80004b38:	7151                	addi	sp,sp,-240
    80004b3a:	f586                	sd	ra,232(sp)
    80004b3c:	f1a2                	sd	s0,224(sp)
    80004b3e:	eda6                	sd	s1,216(sp)
    80004b40:	e9ca                	sd	s2,208(sp)
    80004b42:	e5ce                	sd	s3,200(sp)
    80004b44:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b46:	08000613          	li	a2,128
    80004b4a:	f3040593          	addi	a1,s0,-208
    80004b4e:	4501                	li	a0,0
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	720080e7          	jalr	1824(ra) # 80002270 <argstr>
    80004b58:	18054163          	bltz	a0,80004cda <sys_unlink+0x1a2>
  begin_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	c14080e7          	jalr	-1004(ra) # 80003770 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b64:	fb040593          	addi	a1,s0,-80
    80004b68:	f3040513          	addi	a0,s0,-208
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	a06080e7          	jalr	-1530(ra) # 80003572 <nameiparent>
    80004b74:	84aa                	mv	s1,a0
    80004b76:	c979                	beqz	a0,80004c4c <sys_unlink+0x114>
  ilock(dp);
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	226080e7          	jalr	550(ra) # 80002d9e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b80:	00004597          	auipc	a1,0x4
    80004b84:	ad058593          	addi	a1,a1,-1328 # 80008650 <syscalls+0x2c0>
    80004b88:	fb040513          	addi	a0,s0,-80
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	6dc080e7          	jalr	1756(ra) # 80003268 <namecmp>
    80004b94:	14050a63          	beqz	a0,80004ce8 <sys_unlink+0x1b0>
    80004b98:	00004597          	auipc	a1,0x4
    80004b9c:	ac058593          	addi	a1,a1,-1344 # 80008658 <syscalls+0x2c8>
    80004ba0:	fb040513          	addi	a0,s0,-80
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	6c4080e7          	jalr	1732(ra) # 80003268 <namecmp>
    80004bac:	12050e63          	beqz	a0,80004ce8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bb0:	f2c40613          	addi	a2,s0,-212
    80004bb4:	fb040593          	addi	a1,s0,-80
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	6c8080e7          	jalr	1736(ra) # 80003282 <dirlookup>
    80004bc2:	892a                	mv	s2,a0
    80004bc4:	12050263          	beqz	a0,80004ce8 <sys_unlink+0x1b0>
  ilock(ip);
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	1d6080e7          	jalr	470(ra) # 80002d9e <ilock>
  if(ip->nlink < 1)
    80004bd0:	04a91783          	lh	a5,74(s2)
    80004bd4:	08f05263          	blez	a5,80004c58 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bd8:	04491703          	lh	a4,68(s2)
    80004bdc:	4785                	li	a5,1
    80004bde:	08f70563          	beq	a4,a5,80004c68 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004be2:	4641                	li	a2,16
    80004be4:	4581                	li	a1,0
    80004be6:	fc040513          	addi	a0,s0,-64
    80004bea:	ffffb097          	auipc	ra,0xffffb
    80004bee:	58e080e7          	jalr	1422(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bf2:	4741                	li	a4,16
    80004bf4:	f2c42683          	lw	a3,-212(s0)
    80004bf8:	fc040613          	addi	a2,s0,-64
    80004bfc:	4581                	li	a1,0
    80004bfe:	8526                	mv	a0,s1
    80004c00:	ffffe097          	auipc	ra,0xffffe
    80004c04:	54a080e7          	jalr	1354(ra) # 8000314a <writei>
    80004c08:	47c1                	li	a5,16
    80004c0a:	0af51563          	bne	a0,a5,80004cb4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c0e:	04491703          	lh	a4,68(s2)
    80004c12:	4785                	li	a5,1
    80004c14:	0af70863          	beq	a4,a5,80004cc4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	3e6080e7          	jalr	998(ra) # 80003000 <iunlockput>
  ip->nlink--;
    80004c22:	04a95783          	lhu	a5,74(s2)
    80004c26:	37fd                	addiw	a5,a5,-1
    80004c28:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c2c:	854a                	mv	a0,s2
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	0a6080e7          	jalr	166(ra) # 80002cd4 <iupdate>
  iunlockput(ip);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	3c8080e7          	jalr	968(ra) # 80003000 <iunlockput>
  end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	bb0080e7          	jalr	-1104(ra) # 800037f0 <end_op>
  return 0;
    80004c48:	4501                	li	a0,0
    80004c4a:	a84d                	j	80004cfc <sys_unlink+0x1c4>
    end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	ba4080e7          	jalr	-1116(ra) # 800037f0 <end_op>
    return -1;
    80004c54:	557d                	li	a0,-1
    80004c56:	a05d                	j	80004cfc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c58:	00004517          	auipc	a0,0x4
    80004c5c:	a2850513          	addi	a0,a0,-1496 # 80008680 <syscalls+0x2f0>
    80004c60:	00001097          	auipc	ra,0x1
    80004c64:	628080e7          	jalr	1576(ra) # 80006288 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c68:	04c92703          	lw	a4,76(s2)
    80004c6c:	02000793          	li	a5,32
    80004c70:	f6e7f9e3          	bgeu	a5,a4,80004be2 <sys_unlink+0xaa>
    80004c74:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c78:	4741                	li	a4,16
    80004c7a:	86ce                	mv	a3,s3
    80004c7c:	f1840613          	addi	a2,s0,-232
    80004c80:	4581                	li	a1,0
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	3ce080e7          	jalr	974(ra) # 80003052 <readi>
    80004c8c:	47c1                	li	a5,16
    80004c8e:	00f51b63          	bne	a0,a5,80004ca4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c92:	f1845783          	lhu	a5,-232(s0)
    80004c96:	e7a1                	bnez	a5,80004cde <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c98:	29c1                	addiw	s3,s3,16
    80004c9a:	04c92783          	lw	a5,76(s2)
    80004c9e:	fcf9ede3          	bltu	s3,a5,80004c78 <sys_unlink+0x140>
    80004ca2:	b781                	j	80004be2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ca4:	00004517          	auipc	a0,0x4
    80004ca8:	9f450513          	addi	a0,a0,-1548 # 80008698 <syscalls+0x308>
    80004cac:	00001097          	auipc	ra,0x1
    80004cb0:	5dc080e7          	jalr	1500(ra) # 80006288 <panic>
    panic("unlink: writei");
    80004cb4:	00004517          	auipc	a0,0x4
    80004cb8:	9fc50513          	addi	a0,a0,-1540 # 800086b0 <syscalls+0x320>
    80004cbc:	00001097          	auipc	ra,0x1
    80004cc0:	5cc080e7          	jalr	1484(ra) # 80006288 <panic>
    dp->nlink--;
    80004cc4:	04a4d783          	lhu	a5,74(s1)
    80004cc8:	37fd                	addiw	a5,a5,-1
    80004cca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cce:	8526                	mv	a0,s1
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	004080e7          	jalr	4(ra) # 80002cd4 <iupdate>
    80004cd8:	b781                	j	80004c18 <sys_unlink+0xe0>
    return -1;
    80004cda:	557d                	li	a0,-1
    80004cdc:	a005                	j	80004cfc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cde:	854a                	mv	a0,s2
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	320080e7          	jalr	800(ra) # 80003000 <iunlockput>
  iunlockput(dp);
    80004ce8:	8526                	mv	a0,s1
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	316080e7          	jalr	790(ra) # 80003000 <iunlockput>
  end_op();
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	afe080e7          	jalr	-1282(ra) # 800037f0 <end_op>
  return -1;
    80004cfa:	557d                	li	a0,-1
}
    80004cfc:	70ae                	ld	ra,232(sp)
    80004cfe:	740e                	ld	s0,224(sp)
    80004d00:	64ee                	ld	s1,216(sp)
    80004d02:	694e                	ld	s2,208(sp)
    80004d04:	69ae                	ld	s3,200(sp)
    80004d06:	616d                	addi	sp,sp,240
    80004d08:	8082                	ret

0000000080004d0a <sys_open>:

uint64
sys_open(void)
{
    80004d0a:	7131                	addi	sp,sp,-192
    80004d0c:	fd06                	sd	ra,184(sp)
    80004d0e:	f922                	sd	s0,176(sp)
    80004d10:	f526                	sd	s1,168(sp)
    80004d12:	f14a                	sd	s2,160(sp)
    80004d14:	ed4e                	sd	s3,152(sp)
    80004d16:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d18:	08000613          	li	a2,128
    80004d1c:	f5040593          	addi	a1,s0,-176
    80004d20:	4501                	li	a0,0
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	54e080e7          	jalr	1358(ra) # 80002270 <argstr>
    return -1;
    80004d2a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d2c:	0c054163          	bltz	a0,80004dee <sys_open+0xe4>
    80004d30:	f4c40593          	addi	a1,s0,-180
    80004d34:	4505                	li	a0,1
    80004d36:	ffffd097          	auipc	ra,0xffffd
    80004d3a:	4f6080e7          	jalr	1270(ra) # 8000222c <argint>
    80004d3e:	0a054863          	bltz	a0,80004dee <sys_open+0xe4>

  begin_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	a2e080e7          	jalr	-1490(ra) # 80003770 <begin_op>

  if(omode & O_CREATE){
    80004d4a:	f4c42783          	lw	a5,-180(s0)
    80004d4e:	2007f793          	andi	a5,a5,512
    80004d52:	cbdd                	beqz	a5,80004e08 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d54:	4681                	li	a3,0
    80004d56:	4601                	li	a2,0
    80004d58:	4589                	li	a1,2
    80004d5a:	f5040513          	addi	a0,s0,-176
    80004d5e:	00000097          	auipc	ra,0x0
    80004d62:	972080e7          	jalr	-1678(ra) # 800046d0 <create>
    80004d66:	892a                	mv	s2,a0
    if(ip == 0){
    80004d68:	c959                	beqz	a0,80004dfe <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d6a:	04491703          	lh	a4,68(s2)
    80004d6e:	478d                	li	a5,3
    80004d70:	00f71763          	bne	a4,a5,80004d7e <sys_open+0x74>
    80004d74:	04695703          	lhu	a4,70(s2)
    80004d78:	47a5                	li	a5,9
    80004d7a:	0ce7ec63          	bltu	a5,a4,80004e52 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	e02080e7          	jalr	-510(ra) # 80003b80 <filealloc>
    80004d86:	89aa                	mv	s3,a0
    80004d88:	10050263          	beqz	a0,80004e8c <sys_open+0x182>
    80004d8c:	00000097          	auipc	ra,0x0
    80004d90:	902080e7          	jalr	-1790(ra) # 8000468e <fdalloc>
    80004d94:	84aa                	mv	s1,a0
    80004d96:	0e054663          	bltz	a0,80004e82 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d9a:	04491703          	lh	a4,68(s2)
    80004d9e:	478d                	li	a5,3
    80004da0:	0cf70463          	beq	a4,a5,80004e68 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004da4:	4789                	li	a5,2
    80004da6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004daa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dae:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	0017c713          	xori	a4,a5,1
    80004dba:	8b05                	andi	a4,a4,1
    80004dbc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dc0:	0037f713          	andi	a4,a5,3
    80004dc4:	00e03733          	snez	a4,a4
    80004dc8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dcc:	4007f793          	andi	a5,a5,1024
    80004dd0:	c791                	beqz	a5,80004ddc <sys_open+0xd2>
    80004dd2:	04491703          	lh	a4,68(s2)
    80004dd6:	4789                	li	a5,2
    80004dd8:	08f70f63          	beq	a4,a5,80004e76 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ddc:	854a                	mv	a0,s2
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	082080e7          	jalr	130(ra) # 80002e60 <iunlock>
  end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	a0a080e7          	jalr	-1526(ra) # 800037f0 <end_op>

  return fd;
}
    80004dee:	8526                	mv	a0,s1
    80004df0:	70ea                	ld	ra,184(sp)
    80004df2:	744a                	ld	s0,176(sp)
    80004df4:	74aa                	ld	s1,168(sp)
    80004df6:	790a                	ld	s2,160(sp)
    80004df8:	69ea                	ld	s3,152(sp)
    80004dfa:	6129                	addi	sp,sp,192
    80004dfc:	8082                	ret
      end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	9f2080e7          	jalr	-1550(ra) # 800037f0 <end_op>
      return -1;
    80004e06:	b7e5                	j	80004dee <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e08:	f5040513          	addi	a0,s0,-176
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	748080e7          	jalr	1864(ra) # 80003554 <namei>
    80004e14:	892a                	mv	s2,a0
    80004e16:	c905                	beqz	a0,80004e46 <sys_open+0x13c>
    ilock(ip);
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	f86080e7          	jalr	-122(ra) # 80002d9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e20:	04491703          	lh	a4,68(s2)
    80004e24:	4785                	li	a5,1
    80004e26:	f4f712e3          	bne	a4,a5,80004d6a <sys_open+0x60>
    80004e2a:	f4c42783          	lw	a5,-180(s0)
    80004e2e:	dba1                	beqz	a5,80004d7e <sys_open+0x74>
      iunlockput(ip);
    80004e30:	854a                	mv	a0,s2
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	1ce080e7          	jalr	462(ra) # 80003000 <iunlockput>
      end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	9b6080e7          	jalr	-1610(ra) # 800037f0 <end_op>
      return -1;
    80004e42:	54fd                	li	s1,-1
    80004e44:	b76d                	j	80004dee <sys_open+0xe4>
      end_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	9aa080e7          	jalr	-1622(ra) # 800037f0 <end_op>
      return -1;
    80004e4e:	54fd                	li	s1,-1
    80004e50:	bf79                	j	80004dee <sys_open+0xe4>
    iunlockput(ip);
    80004e52:	854a                	mv	a0,s2
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	1ac080e7          	jalr	428(ra) # 80003000 <iunlockput>
    end_op();
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	994080e7          	jalr	-1644(ra) # 800037f0 <end_op>
    return -1;
    80004e64:	54fd                	li	s1,-1
    80004e66:	b761                	j	80004dee <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e68:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e6c:	04691783          	lh	a5,70(s2)
    80004e70:	02f99223          	sh	a5,36(s3)
    80004e74:	bf2d                	j	80004dae <sys_open+0xa4>
    itrunc(ip);
    80004e76:	854a                	mv	a0,s2
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	034080e7          	jalr	52(ra) # 80002eac <itrunc>
    80004e80:	bfb1                	j	80004ddc <sys_open+0xd2>
      fileclose(f);
    80004e82:	854e                	mv	a0,s3
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	db8080e7          	jalr	-584(ra) # 80003c3c <fileclose>
    iunlockput(ip);
    80004e8c:	854a                	mv	a0,s2
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	172080e7          	jalr	370(ra) # 80003000 <iunlockput>
    end_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	95a080e7          	jalr	-1702(ra) # 800037f0 <end_op>
    return -1;
    80004e9e:	54fd                	li	s1,-1
    80004ea0:	b7b9                	j	80004dee <sys_open+0xe4>

0000000080004ea2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ea2:	7175                	addi	sp,sp,-144
    80004ea4:	e506                	sd	ra,136(sp)
    80004ea6:	e122                	sd	s0,128(sp)
    80004ea8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	8c6080e7          	jalr	-1850(ra) # 80003770 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004eb2:	08000613          	li	a2,128
    80004eb6:	f7040593          	addi	a1,s0,-144
    80004eba:	4501                	li	a0,0
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	3b4080e7          	jalr	948(ra) # 80002270 <argstr>
    80004ec4:	02054963          	bltz	a0,80004ef6 <sys_mkdir+0x54>
    80004ec8:	4681                	li	a3,0
    80004eca:	4601                	li	a2,0
    80004ecc:	4585                	li	a1,1
    80004ece:	f7040513          	addi	a0,s0,-144
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	7fe080e7          	jalr	2046(ra) # 800046d0 <create>
    80004eda:	cd11                	beqz	a0,80004ef6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	124080e7          	jalr	292(ra) # 80003000 <iunlockput>
  end_op();
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	90c080e7          	jalr	-1780(ra) # 800037f0 <end_op>
  return 0;
    80004eec:	4501                	li	a0,0
}
    80004eee:	60aa                	ld	ra,136(sp)
    80004ef0:	640a                	ld	s0,128(sp)
    80004ef2:	6149                	addi	sp,sp,144
    80004ef4:	8082                	ret
    end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	8fa080e7          	jalr	-1798(ra) # 800037f0 <end_op>
    return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	b7fd                	j	80004eee <sys_mkdir+0x4c>

0000000080004f02 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f02:	7135                	addi	sp,sp,-160
    80004f04:	ed06                	sd	ra,152(sp)
    80004f06:	e922                	sd	s0,144(sp)
    80004f08:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	866080e7          	jalr	-1946(ra) # 80003770 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f12:	08000613          	li	a2,128
    80004f16:	f7040593          	addi	a1,s0,-144
    80004f1a:	4501                	li	a0,0
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	354080e7          	jalr	852(ra) # 80002270 <argstr>
    80004f24:	04054a63          	bltz	a0,80004f78 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f28:	f6c40593          	addi	a1,s0,-148
    80004f2c:	4505                	li	a0,1
    80004f2e:	ffffd097          	auipc	ra,0xffffd
    80004f32:	2fe080e7          	jalr	766(ra) # 8000222c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f36:	04054163          	bltz	a0,80004f78 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f3a:	f6840593          	addi	a1,s0,-152
    80004f3e:	4509                	li	a0,2
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	2ec080e7          	jalr	748(ra) # 8000222c <argint>
     argint(1, &major) < 0 ||
    80004f48:	02054863          	bltz	a0,80004f78 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f4c:	f6841683          	lh	a3,-152(s0)
    80004f50:	f6c41603          	lh	a2,-148(s0)
    80004f54:	458d                	li	a1,3
    80004f56:	f7040513          	addi	a0,s0,-144
    80004f5a:	fffff097          	auipc	ra,0xfffff
    80004f5e:	776080e7          	jalr	1910(ra) # 800046d0 <create>
     argint(2, &minor) < 0 ||
    80004f62:	c919                	beqz	a0,80004f78 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	09c080e7          	jalr	156(ra) # 80003000 <iunlockput>
  end_op();
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	884080e7          	jalr	-1916(ra) # 800037f0 <end_op>
  return 0;
    80004f74:	4501                	li	a0,0
    80004f76:	a031                	j	80004f82 <sys_mknod+0x80>
    end_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	878080e7          	jalr	-1928(ra) # 800037f0 <end_op>
    return -1;
    80004f80:	557d                	li	a0,-1
}
    80004f82:	60ea                	ld	ra,152(sp)
    80004f84:	644a                	ld	s0,144(sp)
    80004f86:	610d                	addi	sp,sp,160
    80004f88:	8082                	ret

0000000080004f8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f8a:	7135                	addi	sp,sp,-160
    80004f8c:	ed06                	sd	ra,152(sp)
    80004f8e:	e922                	sd	s0,144(sp)
    80004f90:	e526                	sd	s1,136(sp)
    80004f92:	e14a                	sd	s2,128(sp)
    80004f94:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	e88080e7          	jalr	-376(ra) # 80000e1e <myproc>
    80004f9e:	892a                	mv	s2,a0
  
  begin_op();
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	7d0080e7          	jalr	2000(ra) # 80003770 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fa8:	08000613          	li	a2,128
    80004fac:	f6040593          	addi	a1,s0,-160
    80004fb0:	4501                	li	a0,0
    80004fb2:	ffffd097          	auipc	ra,0xffffd
    80004fb6:	2be080e7          	jalr	702(ra) # 80002270 <argstr>
    80004fba:	04054b63          	bltz	a0,80005010 <sys_chdir+0x86>
    80004fbe:	f6040513          	addi	a0,s0,-160
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	592080e7          	jalr	1426(ra) # 80003554 <namei>
    80004fca:	84aa                	mv	s1,a0
    80004fcc:	c131                	beqz	a0,80005010 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	dd0080e7          	jalr	-560(ra) # 80002d9e <ilock>
  if(ip->type != T_DIR){
    80004fd6:	04449703          	lh	a4,68(s1)
    80004fda:	4785                	li	a5,1
    80004fdc:	04f71063          	bne	a4,a5,8000501c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fe0:	8526                	mv	a0,s1
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	e7e080e7          	jalr	-386(ra) # 80002e60 <iunlock>
  iput(p->cwd);
    80004fea:	15093503          	ld	a0,336(s2)
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	f6a080e7          	jalr	-150(ra) # 80002f58 <iput>
  end_op();
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	7fa080e7          	jalr	2042(ra) # 800037f0 <end_op>
  p->cwd = ip;
    80004ffe:	14993823          	sd	s1,336(s2)
  return 0;
    80005002:	4501                	li	a0,0
}
    80005004:	60ea                	ld	ra,152(sp)
    80005006:	644a                	ld	s0,144(sp)
    80005008:	64aa                	ld	s1,136(sp)
    8000500a:	690a                	ld	s2,128(sp)
    8000500c:	610d                	addi	sp,sp,160
    8000500e:	8082                	ret
    end_op();
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	7e0080e7          	jalr	2016(ra) # 800037f0 <end_op>
    return -1;
    80005018:	557d                	li	a0,-1
    8000501a:	b7ed                	j	80005004 <sys_chdir+0x7a>
    iunlockput(ip);
    8000501c:	8526                	mv	a0,s1
    8000501e:	ffffe097          	auipc	ra,0xffffe
    80005022:	fe2080e7          	jalr	-30(ra) # 80003000 <iunlockput>
    end_op();
    80005026:	ffffe097          	auipc	ra,0xffffe
    8000502a:	7ca080e7          	jalr	1994(ra) # 800037f0 <end_op>
    return -1;
    8000502e:	557d                	li	a0,-1
    80005030:	bfd1                	j	80005004 <sys_chdir+0x7a>

0000000080005032 <sys_exec>:

uint64
sys_exec(void)
{
    80005032:	7145                	addi	sp,sp,-464
    80005034:	e786                	sd	ra,456(sp)
    80005036:	e3a2                	sd	s0,448(sp)
    80005038:	ff26                	sd	s1,440(sp)
    8000503a:	fb4a                	sd	s2,432(sp)
    8000503c:	f74e                	sd	s3,424(sp)
    8000503e:	f352                	sd	s4,416(sp)
    80005040:	ef56                	sd	s5,408(sp)
    80005042:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005044:	08000613          	li	a2,128
    80005048:	f4040593          	addi	a1,s0,-192
    8000504c:	4501                	li	a0,0
    8000504e:	ffffd097          	auipc	ra,0xffffd
    80005052:	222080e7          	jalr	546(ra) # 80002270 <argstr>
    return -1;
    80005056:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005058:	0c054a63          	bltz	a0,8000512c <sys_exec+0xfa>
    8000505c:	e3840593          	addi	a1,s0,-456
    80005060:	4505                	li	a0,1
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	1ec080e7          	jalr	492(ra) # 8000224e <argaddr>
    8000506a:	0c054163          	bltz	a0,8000512c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000506e:	10000613          	li	a2,256
    80005072:	4581                	li	a1,0
    80005074:	e4040513          	addi	a0,s0,-448
    80005078:	ffffb097          	auipc	ra,0xffffb
    8000507c:	100080e7          	jalr	256(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005080:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005084:	89a6                	mv	s3,s1
    80005086:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005088:	02000a13          	li	s4,32
    8000508c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005090:	00391513          	slli	a0,s2,0x3
    80005094:	e3040593          	addi	a1,s0,-464
    80005098:	e3843783          	ld	a5,-456(s0)
    8000509c:	953e                	add	a0,a0,a5
    8000509e:	ffffd097          	auipc	ra,0xffffd
    800050a2:	0f4080e7          	jalr	244(ra) # 80002192 <fetchaddr>
    800050a6:	02054a63          	bltz	a0,800050da <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050aa:	e3043783          	ld	a5,-464(s0)
    800050ae:	c3b9                	beqz	a5,800050f4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	068080e7          	jalr	104(ra) # 80000118 <kalloc>
    800050b8:	85aa                	mv	a1,a0
    800050ba:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050be:	cd11                	beqz	a0,800050da <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050c0:	6605                	lui	a2,0x1
    800050c2:	e3043503          	ld	a0,-464(s0)
    800050c6:	ffffd097          	auipc	ra,0xffffd
    800050ca:	11e080e7          	jalr	286(ra) # 800021e4 <fetchstr>
    800050ce:	00054663          	bltz	a0,800050da <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050d2:	0905                	addi	s2,s2,1
    800050d4:	09a1                	addi	s3,s3,8
    800050d6:	fb491be3          	bne	s2,s4,8000508c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050da:	10048913          	addi	s2,s1,256
    800050de:	6088                	ld	a0,0(s1)
    800050e0:	c529                	beqz	a0,8000512a <sys_exec+0xf8>
    kfree(argv[i]);
    800050e2:	ffffb097          	auipc	ra,0xffffb
    800050e6:	f3a080e7          	jalr	-198(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ea:	04a1                	addi	s1,s1,8
    800050ec:	ff2499e3          	bne	s1,s2,800050de <sys_exec+0xac>
  return -1;
    800050f0:	597d                	li	s2,-1
    800050f2:	a82d                	j	8000512c <sys_exec+0xfa>
      argv[i] = 0;
    800050f4:	0a8e                	slli	s5,s5,0x3
    800050f6:	fc040793          	addi	a5,s0,-64
    800050fa:	9abe                	add	s5,s5,a5
    800050fc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005100:	e4040593          	addi	a1,s0,-448
    80005104:	f4040513          	addi	a0,s0,-192
    80005108:	fffff097          	auipc	ra,0xfffff
    8000510c:	194080e7          	jalr	404(ra) # 8000429c <exec>
    80005110:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005112:	10048993          	addi	s3,s1,256
    80005116:	6088                	ld	a0,0(s1)
    80005118:	c911                	beqz	a0,8000512c <sys_exec+0xfa>
    kfree(argv[i]);
    8000511a:	ffffb097          	auipc	ra,0xffffb
    8000511e:	f02080e7          	jalr	-254(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005122:	04a1                	addi	s1,s1,8
    80005124:	ff3499e3          	bne	s1,s3,80005116 <sys_exec+0xe4>
    80005128:	a011                	j	8000512c <sys_exec+0xfa>
  return -1;
    8000512a:	597d                	li	s2,-1
}
    8000512c:	854a                	mv	a0,s2
    8000512e:	60be                	ld	ra,456(sp)
    80005130:	641e                	ld	s0,448(sp)
    80005132:	74fa                	ld	s1,440(sp)
    80005134:	795a                	ld	s2,432(sp)
    80005136:	79ba                	ld	s3,424(sp)
    80005138:	7a1a                	ld	s4,416(sp)
    8000513a:	6afa                	ld	s5,408(sp)
    8000513c:	6179                	addi	sp,sp,464
    8000513e:	8082                	ret

0000000080005140 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005140:	7139                	addi	sp,sp,-64
    80005142:	fc06                	sd	ra,56(sp)
    80005144:	f822                	sd	s0,48(sp)
    80005146:	f426                	sd	s1,40(sp)
    80005148:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	cd4080e7          	jalr	-812(ra) # 80000e1e <myproc>
    80005152:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005154:	fd840593          	addi	a1,s0,-40
    80005158:	4501                	li	a0,0
    8000515a:	ffffd097          	auipc	ra,0xffffd
    8000515e:	0f4080e7          	jalr	244(ra) # 8000224e <argaddr>
    return -1;
    80005162:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005164:	0e054063          	bltz	a0,80005244 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005168:	fc840593          	addi	a1,s0,-56
    8000516c:	fd040513          	addi	a0,s0,-48
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	dfc080e7          	jalr	-516(ra) # 80003f6c <pipealloc>
    return -1;
    80005178:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000517a:	0c054563          	bltz	a0,80005244 <sys_pipe+0x104>
  fd0 = -1;
    8000517e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	508080e7          	jalr	1288(ra) # 8000468e <fdalloc>
    8000518e:	fca42223          	sw	a0,-60(s0)
    80005192:	08054c63          	bltz	a0,8000522a <sys_pipe+0xea>
    80005196:	fc843503          	ld	a0,-56(s0)
    8000519a:	fffff097          	auipc	ra,0xfffff
    8000519e:	4f4080e7          	jalr	1268(ra) # 8000468e <fdalloc>
    800051a2:	fca42023          	sw	a0,-64(s0)
    800051a6:	06054863          	bltz	a0,80005216 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051aa:	4691                	li	a3,4
    800051ac:	fc440613          	addi	a2,s0,-60
    800051b0:	fd843583          	ld	a1,-40(s0)
    800051b4:	68a8                	ld	a0,80(s1)
    800051b6:	ffffc097          	auipc	ra,0xffffc
    800051ba:	92a080e7          	jalr	-1750(ra) # 80000ae0 <copyout>
    800051be:	02054063          	bltz	a0,800051de <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051c2:	4691                	li	a3,4
    800051c4:	fc040613          	addi	a2,s0,-64
    800051c8:	fd843583          	ld	a1,-40(s0)
    800051cc:	0591                	addi	a1,a1,4
    800051ce:	68a8                	ld	a0,80(s1)
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	910080e7          	jalr	-1776(ra) # 80000ae0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051d8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051da:	06055563          	bgez	a0,80005244 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051de:	fc442783          	lw	a5,-60(s0)
    800051e2:	07e9                	addi	a5,a5,26
    800051e4:	078e                	slli	a5,a5,0x3
    800051e6:	97a6                	add	a5,a5,s1
    800051e8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ec:	fc042503          	lw	a0,-64(s0)
    800051f0:	0569                	addi	a0,a0,26
    800051f2:	050e                	slli	a0,a0,0x3
    800051f4:	9526                	add	a0,a0,s1
    800051f6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051fa:	fd043503          	ld	a0,-48(s0)
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	a3e080e7          	jalr	-1474(ra) # 80003c3c <fileclose>
    fileclose(wf);
    80005206:	fc843503          	ld	a0,-56(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	a32080e7          	jalr	-1486(ra) # 80003c3c <fileclose>
    return -1;
    80005212:	57fd                	li	a5,-1
    80005214:	a805                	j	80005244 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005216:	fc442783          	lw	a5,-60(s0)
    8000521a:	0007c863          	bltz	a5,8000522a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000521e:	01a78513          	addi	a0,a5,26
    80005222:	050e                	slli	a0,a0,0x3
    80005224:	9526                	add	a0,a0,s1
    80005226:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	a0e080e7          	jalr	-1522(ra) # 80003c3c <fileclose>
    fileclose(wf);
    80005236:	fc843503          	ld	a0,-56(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	a02080e7          	jalr	-1534(ra) # 80003c3c <fileclose>
    return -1;
    80005242:	57fd                	li	a5,-1
}
    80005244:	853e                	mv	a0,a5
    80005246:	70e2                	ld	ra,56(sp)
    80005248:	7442                	ld	s0,48(sp)
    8000524a:	74a2                	ld	s1,40(sp)
    8000524c:	6121                	addi	sp,sp,64
    8000524e:	8082                	ret

0000000080005250 <sys_mmap>:

uint64
sys_mmap(void)
{
    80005250:	7139                	addi	sp,sp,-64
    80005252:	fc06                	sd	ra,56(sp)
    80005254:	f822                	sd	s0,48(sp)
    80005256:	f426                	sd	s1,40(sp)
    80005258:	0080                	addi	s0,sp,64
  uint64 addr;
  int len,prot,flags,offset;
  struct VMA* vma=0;
  struct file* f;
  struct proc* p;
  p = myproc();
    8000525a:	ffffc097          	auipc	ra,0xffffc
    8000525e:	bc4080e7          	jalr	-1084(ra) # 80000e1e <myproc>
    80005262:	84aa                	mv	s1,a0
  // 获取系统调用参数
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005264:	fd840593          	addi	a1,s0,-40
    80005268:	4501                	li	a0,0
    8000526a:	ffffd097          	auipc	ra,0xffffd
    8000526e:	fe4080e7          	jalr	-28(ra) # 8000224e <argaddr>
  {
    return -1;
    80005272:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005274:	14054863          	bltz	a0,800053c4 <sys_mmap+0x174>
    80005278:	fd440593          	addi	a1,s0,-44
    8000527c:	4505                	li	a0,1
    8000527e:	ffffd097          	auipc	ra,0xffffd
    80005282:	fae080e7          	jalr	-82(ra) # 8000222c <argint>
    return -1;
    80005286:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005288:	12054e63          	bltz	a0,800053c4 <sys_mmap+0x174>
    8000528c:	fd040593          	addi	a1,s0,-48
    80005290:	4509                	li	a0,2
    80005292:	ffffd097          	auipc	ra,0xffffd
    80005296:	f9a080e7          	jalr	-102(ra) # 8000222c <argint>
    return -1;
    8000529a:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    8000529c:	12054463          	bltz	a0,800053c4 <sys_mmap+0x174>
    800052a0:	fcc40593          	addi	a1,s0,-52
    800052a4:	450d                	li	a0,3
    800052a6:	ffffd097          	auipc	ra,0xffffd
    800052aa:	f86080e7          	jalr	-122(ra) # 8000222c <argint>
    return -1;
    800052ae:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    800052b0:	10054a63          	bltz	a0,800053c4 <sys_mmap+0x174>
    800052b4:	fc040613          	addi	a2,s0,-64
    800052b8:	4581                	li	a1,0
    800052ba:	4511                	li	a0,4
    800052bc:	fffff097          	auipc	ra,0xfffff
    800052c0:	36a080e7          	jalr	874(ra) # 80004626 <argfd>
    return -1;
    800052c4:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    800052c6:	0e054f63          	bltz	a0,800053c4 <sys_mmap+0x174>
    800052ca:	fc840593          	addi	a1,s0,-56
    800052ce:	4515                	li	a0,5
    800052d0:	ffffd097          	auipc	ra,0xffffd
    800052d4:	f5c080e7          	jalr	-164(ra) # 8000222c <argint>
    800052d8:	0e054c63          	bltz	a0,800053d0 <sys_mmap+0x180>
  }
  // 参数合法性检查
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) 
    800052dc:	fcc42883          	lw	a7,-52(s0)
    800052e0:	fff8869b          	addiw	a3,a7,-1
    800052e4:	4705                	li	a4,1
    return -1;
    800052e6:	57fd                	li	a5,-1
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) 
    800052e8:	0cd76e63          	bltu	a4,a3,800053c4 <sys_mmap+0x174>
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    800052ec:	4785                	li	a5,1
    800052ee:	02f88c63          	beq	a7,a5,80005326 <sys_mmap+0xd6>
    return -1;
  if(len<0||offset<0||offset%PGSIZE)
    800052f2:	fd442303          	lw	t1,-44(s0)
    800052f6:	0c034f63          	bltz	t1,800053d4 <sys_mmap+0x184>
    800052fa:	fc842e03          	lw	t3,-56(s0)
    800052fe:	0c0e4d63          	bltz	t3,800053d8 <sys_mmap+0x188>
    80005302:	034e1713          	slli	a4,t3,0x34
    return -1;
    80005306:	57fd                	li	a5,-1
  if(len<0||offset<0||offset%PGSIZE)
    80005308:	ef55                	bnez	a4,800053c4 <sys_mmap+0x174>
    8000530a:	16848793          	addi	a5,s1,360
    8000530e:	873e                	mv	a4,a5
  // 查找空闲的 VMA
  for(int i = 0;i<NVMA;i++){
    80005310:	4601                	li	a2,0
    80005312:	45c1                	li	a1,16
    if(p->vma[i].addr == 0){
    80005314:	6314                	ld	a3,0(a4)
    80005316:	c29d                	beqz	a3,8000533c <sys_mmap+0xec>
  for(int i = 0;i<NVMA;i++){
    80005318:	2605                	addiw	a2,a2,1
    8000531a:	02070713          	addi	a4,a4,32
    8000531e:	feb61be3          	bne	a2,a1,80005314 <sys_mmap+0xc4>
      vma = &p->vma[i];
      break;
    }
  }
  if(vma==0)
    return -1;
    80005322:	57fd                	li	a5,-1
    80005324:	a045                	j	800053c4 <sys_mmap+0x174>
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    80005326:	fc043783          	ld	a5,-64(s0)
    8000532a:	0097c783          	lbu	a5,9(a5)
    8000532e:	f3f1                	bnez	a5,800052f2 <sys_mmap+0xa2>
    80005330:	fd042703          	lw	a4,-48(s0)
    80005334:	8b09                	andi	a4,a4,2
    return -1;
    80005336:	57fd                	li	a5,-1
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    80005338:	df4d                	beqz	a4,800052f2 <sys_mmap+0xa2>
    8000533a:	a069                	j	800053c4 <sys_mmap+0x174>
  // 计算映射的起始地址，将其设置为 TRAPFRAME 减去 10 页的大小（为了避免与内核栈和陷阱帧重叠）
  // 遍历进程的 VMA，找到当前最大的地址，并向上对齐。如果最终地址超过 TRAPFRAME，则返回 -1
  addr = TRAPFRAME - 10*PGSIZE;
    8000533c:	010005b7          	lui	a1,0x1000
    80005340:	15f5                	addi	a1,a1,-3
    80005342:	05ba                	slli	a1,a1,0xe
    80005344:	fcb43c23          	sd	a1,-40(s0)
  for(int i=0;i<NVMA;i++)
    80005348:	36848513          	addi	a0,s1,872
  {
    if(p->vma[i].addr)
    {
       addr = max(p->vma[i].addr+p->vma[i].len,addr);
    8000534c:	4805                	li	a6,1
    8000534e:	a031                	j	8000535a <sys_mmap+0x10a>
    80005350:	86c2                	mv	a3,a6
  for(int i=0;i<NVMA;i++)
    80005352:	02078793          	addi	a5,a5,32
    80005356:	00a78a63          	beq	a5,a0,8000536a <sys_mmap+0x11a>
    if(p->vma[i].addr)
    8000535a:	6398                	ld	a4,0(a5)
    8000535c:	db7d                	beqz	a4,80005352 <sys_mmap+0x102>
       addr = max(p->vma[i].addr+p->vma[i].len,addr);
    8000535e:	4794                	lw	a3,8(a5)
    80005360:	9736                	add	a4,a4,a3
    80005362:	fee5f7e3          	bgeu	a1,a4,80005350 <sys_mmap+0x100>
    80005366:	85ba                	mv	a1,a4
    80005368:	b7e5                	j	80005350 <sys_mmap+0x100>
    8000536a:	c299                	beqz	a3,80005370 <sys_mmap+0x120>
    8000536c:	fcb43c23          	sd	a1,-40(s0)
    }
  }
  addr = PGROUNDUP(addr);
    80005370:	fd843703          	ld	a4,-40(s0)
    80005374:	6785                	lui	a5,0x1
    80005376:	17fd                	addi	a5,a5,-1
    80005378:	973e                	add	a4,a4,a5
    8000537a:	77fd                	lui	a5,0xfffff
    8000537c:	8f7d                	and	a4,a4,a5
    8000537e:	fce43c23          	sd	a4,-40(s0)
  if(addr + len >TRAPFRAME)
    80005382:	00e305b3          	add	a1,t1,a4
    80005386:	020006b7          	lui	a3,0x2000
    8000538a:	16fd                	addi	a3,a3,-1
    8000538c:	06b6                	slli	a3,a3,0xd
    return -1;
    8000538e:	57fd                	li	a5,-1
  if(addr + len >TRAPFRAME)
    80005390:	02b6ea63          	bltu	a3,a1,800053c4 <sys_mmap+0x174>
  // 设置 VMA 属性并返回地址
  vma->addr = addr;
    80005394:	0616                	slli	a2,a2,0x5
    80005396:	9626                	add	a2,a2,s1
    80005398:	16e63423          	sd	a4,360(a2) # 1168 <_entry-0x7fffee98>
  vma->len = len;
    8000539c:	16662823          	sw	t1,368(a2)
  vma->prot = prot;
    800053a0:	fd042783          	lw	a5,-48(s0)
    800053a4:	16f62a23          	sw	a5,372(a2)
  vma->flags = flags;
    800053a8:	17162c23          	sw	a7,376(a2)
  vma->offset = offset;
    800053ac:	17c62e23          	sw	t3,380(a2)
  vma->f = f;
    800053b0:	fc043503          	ld	a0,-64(s0)
    800053b4:	18a63023          	sd	a0,384(a2)
  filedup(f);
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	832080e7          	jalr	-1998(ra) # 80003bea <filedup>
  return addr;
    800053c0:	fd843783          	ld	a5,-40(s0)
}
    800053c4:	853e                	mv	a0,a5
    800053c6:	70e2                	ld	ra,56(sp)
    800053c8:	7442                	ld	s0,48(sp)
    800053ca:	74a2                	ld	s1,40(sp)
    800053cc:	6121                	addi	sp,sp,64
    800053ce:	8082                	ret
    return -1;
    800053d0:	57fd                	li	a5,-1
    800053d2:	bfcd                	j	800053c4 <sys_mmap+0x174>
    return -1;
    800053d4:	57fd                	li	a5,-1
    800053d6:	b7fd                	j	800053c4 <sys_mmap+0x174>
    800053d8:	57fd                	li	a5,-1
    800053da:	b7ed                	j	800053c4 <sys_mmap+0x174>

00000000800053dc <sys_munmap>:

uint64
sys_munmap(void)
{
    800053dc:	7175                	addi	sp,sp,-144
    800053de:	e506                	sd	ra,136(sp)
    800053e0:	e122                	sd	s0,128(sp)
    800053e2:	fca6                	sd	s1,120(sp)
    800053e4:	f8ca                	sd	s2,112(sp)
    800053e6:	f4ce                	sd	s3,104(sp)
    800053e8:	f0d2                	sd	s4,96(sp)
    800053ea:	ecd6                	sd	s5,88(sp)
    800053ec:	e8da                	sd	s6,80(sp)
    800053ee:	e4de                	sd	s7,72(sp)
    800053f0:	e0e2                	sd	s8,64(sp)
    800053f2:	fc66                	sd	s9,56(sp)
    800053f4:	f86a                	sd	s10,48(sp)
    800053f6:	f46e                	sd	s11,40(sp)
    800053f8:	0900                	addi	s0,sp,144
  uint64 addr,va;
  int len;
  struct VMA* vma=0;
  struct proc* p = myproc();
    800053fa:	ffffc097          	auipc	ra,0xffffc
    800053fe:	a24080e7          	jalr	-1500(ra) # 80000e1e <myproc>
    80005402:	84aa                	mv	s1,a0
    80005404:	f6a43c23          	sd	a0,-136(s0)
  // 获取系统调用参数
  if(argaddr(0,&addr)<0||argint(1,&len)<0)
    80005408:	f8840593          	addi	a1,s0,-120
    8000540c:	4501                	li	a0,0
    8000540e:	ffffd097          	auipc	ra,0xffffd
    80005412:	e40080e7          	jalr	-448(ra) # 8000224e <argaddr>
    80005416:	26054563          	bltz	a0,80005680 <sys_munmap+0x2a4>
    8000541a:	f8440593          	addi	a1,s0,-124
    8000541e:	4505                	li	a0,1
    80005420:	ffffd097          	auipc	ra,0xffffd
    80005424:	e0c080e7          	jalr	-500(ra) # 8000222c <argint>
    80005428:	24054e63          	bltz	a0,80005684 <sys_munmap+0x2a8>
    return -1;
  // 参数合法性检查
  if(addr%PGSIZE || len<0)
    8000542c:	f8843983          	ld	s3,-120(s0)
    80005430:	03499793          	slli	a5,s3,0x34
    80005434:	0347dd13          	srli	s10,a5,0x34
    80005438:	24079863          	bnez	a5,80005688 <sys_munmap+0x2ac>
    8000543c:	f8442583          	lw	a1,-124(s0)
    80005440:	2405c663          	bltz	a1,8000568c <sys_munmap+0x2b0>
    80005444:	16848793          	addi	a5,s1,360
    return -1;
  // 查找包含该地址的 VMA
  for(int i=0;i<NVMA;i++){
    80005448:	4481                	li	s1,0
    8000544a:	4641                	li	a2,16
    8000544c:	a031                	j	80005458 <sys_munmap+0x7c>
    8000544e:	2485                	addiw	s1,s1,1
    80005450:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    80005454:	04c48363          	beq	s1,a2,8000549a <sys_munmap+0xbe>
    if(p->vma[i].addr && addr >= p->vma[i].addr && addr <= p->vma[i].addr+p->vma[i].len){
    80005458:	6398                	ld	a4,0(a5)
    8000545a:	db75                	beqz	a4,8000544e <sys_munmap+0x72>
    8000545c:	fee9e9e3          	bltu	s3,a4,8000544e <sys_munmap+0x72>
    80005460:	4794                	lw	a3,8(a5)
    80005462:	9736                	add	a4,a4,a3
    80005464:	ff3765e3          	bltu	a4,s3,8000544e <sys_munmap+0x72>
    }
  }
  if(vma==0)
    return -1;
  // 处理长度为零的特殊情况
  if(len==0)
    80005468:	c995                	beqz	a1,8000549c <sys_munmap+0xc0>
    return 0;
  
  int maxsize;
  // 如果 VMA 的标志包含 MAP_SHARED，则处理该 VMA 中的脏页，将它们写回文件
  if(vma->flags & MAP_SHARED){
    8000546a:	00549793          	slli	a5,s1,0x5
    8000546e:	f7843703          	ld	a4,-136(s0)
    80005472:	97ba                	add	a5,a5,a4
    80005474:	1787a783          	lw	a5,376(a5)
    80005478:	8b85                	andi	a5,a5,1
    8000547a:	12078f63          	beqz	a5,800055b8 <sys_munmap+0x1dc>
    maxsize = ((MAXOPBLOCKS-4)/2)*BSIZE;
    for(va=addr;va<addr+len;va+=PGSIZE){
    8000547e:	95ce                	add	a1,a1,s3
    80005480:	12b9fc63          	bgeu	s3,a1,800055b8 <sys_munmap+0x1dc>
        continue;
      uint range,size;
      range = min(addr+len-va,PGSIZE);
      size = min(maxsize,range);
      for(int i=0;i<range;i+=size){
        size=min(maxsize,range-i);
    80005484:	6785                	lui	a5,0x1
    80005486:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
        begin_op();
        ilock(vma->f->ip);
    8000548a:	00549b13          	slli	s6,s1,0x5
    8000548e:	9b3a                	add	s6,s6,a4
        if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size){
    80005490:	00b48c93          	addi	s9,s1,11
    80005494:	0c96                	slli	s9,s9,0x5
    80005496:	9cba                	add	s9,s9,a4
    80005498:	a8e1                	j	80005570 <sys_munmap+0x194>
    return -1;
    8000549a:	5d7d                	li	s10,-1
    vma->len-=len;
  // 如果取消映射的范围在中间，则触发 panic
  else
    panic("failed munmap");
  return 0;
}
    8000549c:	856a                	mv	a0,s10
    8000549e:	60aa                	ld	ra,136(sp)
    800054a0:	640a                	ld	s0,128(sp)
    800054a2:	74e6                	ld	s1,120(sp)
    800054a4:	7946                	ld	s2,112(sp)
    800054a6:	79a6                	ld	s3,104(sp)
    800054a8:	7a06                	ld	s4,96(sp)
    800054aa:	6ae6                	ld	s5,88(sp)
    800054ac:	6b46                	ld	s6,80(sp)
    800054ae:	6ba6                	ld	s7,72(sp)
    800054b0:	6c06                	ld	s8,64(sp)
    800054b2:	7ce2                	ld	s9,56(sp)
    800054b4:	7d42                	ld	s10,48(sp)
    800054b6:	7da2                	ld	s11,40(sp)
    800054b8:	6149                	addi	sp,sp,144
    800054ba:	8082                	ret
        size=min(maxsize,range-i);
    800054bc:	00090a1b          	sext.w	s4,s2
        begin_op();
    800054c0:	ffffe097          	auipc	ra,0xffffe
    800054c4:	2b0080e7          	jalr	688(ra) # 80003770 <begin_op>
        ilock(vma->f->ip);
    800054c8:	180b3783          	ld	a5,384(s6)
    800054cc:	6f88                	ld	a0,24(a5)
    800054ce:	ffffe097          	auipc	ra,0xffffe
    800054d2:	8d0080e7          	jalr	-1840(ra) # 80002d9e <ilock>
        if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size){
    800054d6:	008cb783          	ld	a5,8(s9)
    800054da:	17cb2683          	lw	a3,380(s6)
    800054de:	9e9d                	subw	a3,a3,a5
    800054e0:	013686bb          	addw	a3,a3,s3
    800054e4:	180b3783          	ld	a5,384(s6)
    800054e8:	8752                	mv	a4,s4
    800054ea:	015686bb          	addw	a3,a3,s5
    800054ee:	013c0633          	add	a2,s8,s3
    800054f2:	4585                	li	a1,1
    800054f4:	6f88                	ld	a0,24(a5)
    800054f6:	ffffe097          	auipc	ra,0xffffe
    800054fa:	c54080e7          	jalr	-940(ra) # 8000314a <writei>
    800054fe:	2501                	sext.w	a0,a0
    80005500:	03451d63          	bne	a0,s4,8000553a <sys_munmap+0x15e>
        iunlock(vma->f->ip);
    80005504:	180b3783          	ld	a5,384(s6)
    80005508:	6f88                	ld	a0,24(a5)
    8000550a:	ffffe097          	auipc	ra,0xffffe
    8000550e:	956080e7          	jalr	-1706(ra) # 80002e60 <iunlock>
        end_op();
    80005512:	ffffe097          	auipc	ra,0xffffe
    80005516:	2de080e7          	jalr	734(ra) # 800037f0 <end_op>
      for(int i=0;i<range;i+=size){
    8000551a:	0159093b          	addw	s2,s2,s5
    8000551e:	00090a9b          	sext.w	s5,s2
    80005522:	8c56                	mv	s8,s5
    80005524:	037afd63          	bgeu	s5,s7,8000555e <sys_munmap+0x182>
        size=min(maxsize,range-i);
    80005528:	415b893b          	subw	s2,s7,s5
    8000552c:	0009079b          	sext.w	a5,s2
    80005530:	f8fdf6e3          	bgeu	s11,a5,800054bc <sys_munmap+0xe0>
    80005534:	f7442903          	lw	s2,-140(s0)
    80005538:	b751                	j	800054bc <sys_munmap+0xe0>
          iunlock(vma->f->ip);
    8000553a:	0496                	slli	s1,s1,0x5
    8000553c:	f7843783          	ld	a5,-136(s0)
    80005540:	00978533          	add	a0,a5,s1
    80005544:	18053783          	ld	a5,384(a0)
    80005548:	6f88                	ld	a0,24(a5)
    8000554a:	ffffe097          	auipc	ra,0xffffe
    8000554e:	916080e7          	jalr	-1770(ra) # 80002e60 <iunlock>
          end_op();
    80005552:	ffffe097          	auipc	ra,0xffffe
    80005556:	29e080e7          	jalr	670(ra) # 800037f0 <end_op>
          return -1;
    8000555a:	5d7d                	li	s10,-1
    8000555c:	b781                	j	8000549c <sys_munmap+0xc0>
    for(va=addr;va<addr+len;va+=PGSIZE){
    8000555e:	6785                	lui	a5,0x1
    80005560:	99be                	add	s3,s3,a5
    80005562:	f8442783          	lw	a5,-124(s0)
    80005566:	f8843703          	ld	a4,-120(s0)
    8000556a:	97ba                	add	a5,a5,a4
    8000556c:	04f9f663          	bgeu	s3,a5,800055b8 <sys_munmap+0x1dc>
      pte_t* pte = walk(p->pagetable,va,0);
    80005570:	4601                	li	a2,0
    80005572:	85ce                	mv	a1,s3
    80005574:	f7843783          	ld	a5,-136(s0)
    80005578:	6ba8                	ld	a0,80(a5)
    8000557a:	ffffb097          	auipc	ra,0xffffb
    8000557e:	ee6080e7          	jalr	-282(ra) # 80000460 <walk>
      if(pte==0 || (*pte & PTE_D)==0)
    80005582:	dd71                	beqz	a0,8000555e <sys_munmap+0x182>
    80005584:	611c                	ld	a5,0(a0)
    80005586:	0807f793          	andi	a5,a5,128
    8000558a:	dbf1                	beqz	a5,8000555e <sys_munmap+0x182>
      range = min(addr+len-va,PGSIZE);
    8000558c:	f8442b83          	lw	s7,-124(s0)
    80005590:	f8843783          	ld	a5,-120(s0)
    80005594:	9bbe                	add	s7,s7,a5
    80005596:	413b8bb3          	sub	s7,s7,s3
    8000559a:	6785                	lui	a5,0x1
    8000559c:	0177f363          	bgeu	a5,s7,800055a2 <sys_munmap+0x1c6>
    800055a0:	6b85                	lui	s7,0x1
    800055a2:	2b81                	sext.w	s7,s7
      for(int i=0;i<range;i+=size){
    800055a4:	fa0b8de3          	beqz	s7,8000555e <sys_munmap+0x182>
    800055a8:	4c01                	li	s8,0
    800055aa:	4a81                	li	s5,0
        size=min(maxsize,range-i);
    800055ac:	6785                	lui	a5,0x1
    800055ae:	c007879b          	addiw	a5,a5,-1024
    800055b2:	f6f42a23          	sw	a5,-140(s0)
    800055b6:	bf8d                	j	80005528 <sys_munmap+0x14c>
  uvmunmap(p->pagetable,addr,(len-1)/PGSIZE+1,1);
    800055b8:	f8442603          	lw	a2,-124(s0)
    800055bc:	fff6079b          	addiw	a5,a2,-1
    800055c0:	41f7d61b          	sraiw	a2,a5,0x1f
    800055c4:	0146561b          	srliw	a2,a2,0x14
    800055c8:	9e3d                	addw	a2,a2,a5
    800055ca:	40c6561b          	sraiw	a2,a2,0xc
    800055ce:	4685                	li	a3,1
    800055d0:	2605                	addiw	a2,a2,1
    800055d2:	f8843583          	ld	a1,-120(s0)
    800055d6:	f7843903          	ld	s2,-136(s0)
    800055da:	05093503          	ld	a0,80(s2)
    800055de:	ffffb097          	auipc	ra,0xffffb
    800055e2:	130080e7          	jalr	304(ra) # 8000070e <uvmunmap>
  if(addr==vma->addr && len==vma->len){
    800055e6:	00549793          	slli	a5,s1,0x5
    800055ea:	97ca                	add	a5,a5,s2
    800055ec:	1687b703          	ld	a4,360(a5) # 1168 <_entry-0x7fffee98>
    800055f0:	f8843683          	ld	a3,-120(s0)
    800055f4:	00d70e63          	beq	a4,a3,80005610 <sys_munmap+0x234>
  else if(addr+len==vma->addr+vma->len)
    800055f8:	f8442583          	lw	a1,-124(s0)
    800055fc:	1707a603          	lw	a2,368(a5)
    80005600:	96ae                	add	a3,a3,a1
    80005602:	9732                	add	a4,a4,a2
    80005604:	06e69663          	bne	a3,a4,80005670 <sys_munmap+0x294>
    vma->len-=len;
    80005608:	9e0d                	subw	a2,a2,a1
    8000560a:	16c7a823          	sw	a2,368(a5)
    8000560e:	b579                	j	8000549c <sys_munmap+0xc0>
  if(addr==vma->addr && len==vma->len){
    80005610:	f8442683          	lw	a3,-124(s0)
    80005614:	1707a603          	lw	a2,368(a5)
    80005618:	02d60563          	beq	a2,a3,80005642 <sys_munmap+0x266>
    vma->addr += len;
    8000561c:	9736                	add	a4,a4,a3
    8000561e:	16e7b423          	sd	a4,360(a5)
    vma->offset += len;
    80005622:	0496                	slli	s1,s1,0x5
    80005624:	f7843703          	ld	a4,-136(s0)
    80005628:	94ba                	add	s1,s1,a4
    8000562a:	17c4a703          	lw	a4,380(s1)
    8000562e:	9f35                	addw	a4,a4,a3
    80005630:	16e4ae23          	sw	a4,380(s1)
    vma->len -= len;
    80005634:	1707a703          	lw	a4,368(a5)
    80005638:	40d706bb          	subw	a3,a4,a3
    8000563c:	16d7a823          	sw	a3,368(a5)
    80005640:	bdb1                	j	8000549c <sys_munmap+0xc0>
    vma->addr = 0;
    80005642:	1607b423          	sd	zero,360(a5)
    vma->len = 0;
    80005646:	1607a823          	sw	zero,368(a5)
    vma->offset = 0;
    8000564a:	0496                	slli	s1,s1,0x5
    8000564c:	f7843703          	ld	a4,-136(s0)
    80005650:	94ba                	add	s1,s1,a4
    80005652:	1604ae23          	sw	zero,380(s1)
    vma->flags = 0;
    80005656:	1604ac23          	sw	zero,376(s1)
    vma->prot = 0;
    8000565a:	1607aa23          	sw	zero,372(a5)
    fileclose(vma->f);
    8000565e:	1804b503          	ld	a0,384(s1)
    80005662:	ffffe097          	auipc	ra,0xffffe
    80005666:	5da080e7          	jalr	1498(ra) # 80003c3c <fileclose>
    vma->f = 0;
    8000566a:	1804b023          	sd	zero,384(s1)
    8000566e:	b53d                	j	8000549c <sys_munmap+0xc0>
    panic("failed munmap");
    80005670:	00003517          	auipc	a0,0x3
    80005674:	05050513          	addi	a0,a0,80 # 800086c0 <syscalls+0x330>
    80005678:	00001097          	auipc	ra,0x1
    8000567c:	c10080e7          	jalr	-1008(ra) # 80006288 <panic>
    return -1;
    80005680:	5d7d                	li	s10,-1
    80005682:	bd29                	j	8000549c <sys_munmap+0xc0>
    80005684:	5d7d                	li	s10,-1
    80005686:	bd19                	j	8000549c <sys_munmap+0xc0>
    return -1;
    80005688:	5d7d                	li	s10,-1
    8000568a:	bd09                	j	8000549c <sys_munmap+0xc0>
    8000568c:	5d7d                	li	s10,-1
    8000568e:	b539                	j	8000549c <sys_munmap+0xc0>

0000000080005690 <kernelvec>:
    80005690:	7111                	addi	sp,sp,-256
    80005692:	e006                	sd	ra,0(sp)
    80005694:	e40a                	sd	sp,8(sp)
    80005696:	e80e                	sd	gp,16(sp)
    80005698:	ec12                	sd	tp,24(sp)
    8000569a:	f016                	sd	t0,32(sp)
    8000569c:	f41a                	sd	t1,40(sp)
    8000569e:	f81e                	sd	t2,48(sp)
    800056a0:	fc22                	sd	s0,56(sp)
    800056a2:	e0a6                	sd	s1,64(sp)
    800056a4:	e4aa                	sd	a0,72(sp)
    800056a6:	e8ae                	sd	a1,80(sp)
    800056a8:	ecb2                	sd	a2,88(sp)
    800056aa:	f0b6                	sd	a3,96(sp)
    800056ac:	f4ba                	sd	a4,104(sp)
    800056ae:	f8be                	sd	a5,112(sp)
    800056b0:	fcc2                	sd	a6,120(sp)
    800056b2:	e146                	sd	a7,128(sp)
    800056b4:	e54a                	sd	s2,136(sp)
    800056b6:	e94e                	sd	s3,144(sp)
    800056b8:	ed52                	sd	s4,152(sp)
    800056ba:	f156                	sd	s5,160(sp)
    800056bc:	f55a                	sd	s6,168(sp)
    800056be:	f95e                	sd	s7,176(sp)
    800056c0:	fd62                	sd	s8,184(sp)
    800056c2:	e1e6                	sd	s9,192(sp)
    800056c4:	e5ea                	sd	s10,200(sp)
    800056c6:	e9ee                	sd	s11,208(sp)
    800056c8:	edf2                	sd	t3,216(sp)
    800056ca:	f1f6                	sd	t4,224(sp)
    800056cc:	f5fa                	sd	t5,232(sp)
    800056ce:	f9fe                	sd	t6,240(sp)
    800056d0:	98ffc0ef          	jal	ra,8000205e <kerneltrap>
    800056d4:	6082                	ld	ra,0(sp)
    800056d6:	6122                	ld	sp,8(sp)
    800056d8:	61c2                	ld	gp,16(sp)
    800056da:	7282                	ld	t0,32(sp)
    800056dc:	7322                	ld	t1,40(sp)
    800056de:	73c2                	ld	t2,48(sp)
    800056e0:	7462                	ld	s0,56(sp)
    800056e2:	6486                	ld	s1,64(sp)
    800056e4:	6526                	ld	a0,72(sp)
    800056e6:	65c6                	ld	a1,80(sp)
    800056e8:	6666                	ld	a2,88(sp)
    800056ea:	7686                	ld	a3,96(sp)
    800056ec:	7726                	ld	a4,104(sp)
    800056ee:	77c6                	ld	a5,112(sp)
    800056f0:	7866                	ld	a6,120(sp)
    800056f2:	688a                	ld	a7,128(sp)
    800056f4:	692a                	ld	s2,136(sp)
    800056f6:	69ca                	ld	s3,144(sp)
    800056f8:	6a6a                	ld	s4,152(sp)
    800056fa:	7a8a                	ld	s5,160(sp)
    800056fc:	7b2a                	ld	s6,168(sp)
    800056fe:	7bca                	ld	s7,176(sp)
    80005700:	7c6a                	ld	s8,184(sp)
    80005702:	6c8e                	ld	s9,192(sp)
    80005704:	6d2e                	ld	s10,200(sp)
    80005706:	6dce                	ld	s11,208(sp)
    80005708:	6e6e                	ld	t3,216(sp)
    8000570a:	7e8e                	ld	t4,224(sp)
    8000570c:	7f2e                	ld	t5,232(sp)
    8000570e:	7fce                	ld	t6,240(sp)
    80005710:	6111                	addi	sp,sp,256
    80005712:	10200073          	sret
    80005716:	00000013          	nop
    8000571a:	00000013          	nop
    8000571e:	0001                	nop

0000000080005720 <timervec>:
    80005720:	34051573          	csrrw	a0,mscratch,a0
    80005724:	e10c                	sd	a1,0(a0)
    80005726:	e510                	sd	a2,8(a0)
    80005728:	e914                	sd	a3,16(a0)
    8000572a:	6d0c                	ld	a1,24(a0)
    8000572c:	7110                	ld	a2,32(a0)
    8000572e:	6194                	ld	a3,0(a1)
    80005730:	96b2                	add	a3,a3,a2
    80005732:	e194                	sd	a3,0(a1)
    80005734:	4589                	li	a1,2
    80005736:	14459073          	csrw	sip,a1
    8000573a:	6914                	ld	a3,16(a0)
    8000573c:	6510                	ld	a2,8(a0)
    8000573e:	610c                	ld	a1,0(a0)
    80005740:	34051573          	csrrw	a0,mscratch,a0
    80005744:	30200073          	mret
	...

000000008000574a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000574a:	1141                	addi	sp,sp,-16
    8000574c:	e422                	sd	s0,8(sp)
    8000574e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005750:	0c0007b7          	lui	a5,0xc000
    80005754:	4705                	li	a4,1
    80005756:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005758:	c3d8                	sw	a4,4(a5)
}
    8000575a:	6422                	ld	s0,8(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret

0000000080005760 <plicinithart>:

void
plicinithart(void)
{
    80005760:	1141                	addi	sp,sp,-16
    80005762:	e406                	sd	ra,8(sp)
    80005764:	e022                	sd	s0,0(sp)
    80005766:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005768:	ffffb097          	auipc	ra,0xffffb
    8000576c:	68a080e7          	jalr	1674(ra) # 80000df2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005770:	0085171b          	slliw	a4,a0,0x8
    80005774:	0c0027b7          	lui	a5,0xc002
    80005778:	97ba                	add	a5,a5,a4
    8000577a:	40200713          	li	a4,1026
    8000577e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005782:	00d5151b          	slliw	a0,a0,0xd
    80005786:	0c2017b7          	lui	a5,0xc201
    8000578a:	953e                	add	a0,a0,a5
    8000578c:	00052023          	sw	zero,0(a0)
}
    80005790:	60a2                	ld	ra,8(sp)
    80005792:	6402                	ld	s0,0(sp)
    80005794:	0141                	addi	sp,sp,16
    80005796:	8082                	ret

0000000080005798 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005798:	1141                	addi	sp,sp,-16
    8000579a:	e406                	sd	ra,8(sp)
    8000579c:	e022                	sd	s0,0(sp)
    8000579e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057a0:	ffffb097          	auipc	ra,0xffffb
    800057a4:	652080e7          	jalr	1618(ra) # 80000df2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800057a8:	00d5179b          	slliw	a5,a0,0xd
    800057ac:	0c201537          	lui	a0,0xc201
    800057b0:	953e                	add	a0,a0,a5
  return irq;
}
    800057b2:	4148                	lw	a0,4(a0)
    800057b4:	60a2                	ld	ra,8(sp)
    800057b6:	6402                	ld	s0,0(sp)
    800057b8:	0141                	addi	sp,sp,16
    800057ba:	8082                	ret

00000000800057bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800057bc:	1101                	addi	sp,sp,-32
    800057be:	ec06                	sd	ra,24(sp)
    800057c0:	e822                	sd	s0,16(sp)
    800057c2:	e426                	sd	s1,8(sp)
    800057c4:	1000                	addi	s0,sp,32
    800057c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800057c8:	ffffb097          	auipc	ra,0xffffb
    800057cc:	62a080e7          	jalr	1578(ra) # 80000df2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800057d0:	00d5151b          	slliw	a0,a0,0xd
    800057d4:	0c2017b7          	lui	a5,0xc201
    800057d8:	97aa                	add	a5,a5,a0
    800057da:	c3c4                	sw	s1,4(a5)
}
    800057dc:	60e2                	ld	ra,24(sp)
    800057de:	6442                	ld	s0,16(sp)
    800057e0:	64a2                	ld	s1,8(sp)
    800057e2:	6105                	addi	sp,sp,32
    800057e4:	8082                	ret

00000000800057e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800057e6:	1141                	addi	sp,sp,-16
    800057e8:	e406                	sd	ra,8(sp)
    800057ea:	e022                	sd	s0,0(sp)
    800057ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800057ee:	479d                	li	a5,7
    800057f0:	06a7c963          	blt	a5,a0,80005862 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800057f4:	0001e797          	auipc	a5,0x1e
    800057f8:	80c78793          	addi	a5,a5,-2036 # 80023000 <disk>
    800057fc:	00a78733          	add	a4,a5,a0
    80005800:	6789                	lui	a5,0x2
    80005802:	97ba                	add	a5,a5,a4
    80005804:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005808:	e7ad                	bnez	a5,80005872 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000580a:	00451793          	slli	a5,a0,0x4
    8000580e:	0001f717          	auipc	a4,0x1f
    80005812:	7f270713          	addi	a4,a4,2034 # 80025000 <disk+0x2000>
    80005816:	6314                	ld	a3,0(a4)
    80005818:	96be                	add	a3,a3,a5
    8000581a:	0006b023          	sd	zero,0(a3) # 2000000 <_entry-0x7e000000>
  disk.desc[i].len = 0;
    8000581e:	6314                	ld	a3,0(a4)
    80005820:	96be                	add	a3,a3,a5
    80005822:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005826:	6314                	ld	a3,0(a4)
    80005828:	96be                	add	a3,a3,a5
    8000582a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000582e:	6318                	ld	a4,0(a4)
    80005830:	97ba                	add	a5,a5,a4
    80005832:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005836:	0001d797          	auipc	a5,0x1d
    8000583a:	7ca78793          	addi	a5,a5,1994 # 80023000 <disk>
    8000583e:	97aa                	add	a5,a5,a0
    80005840:	6509                	lui	a0,0x2
    80005842:	953e                	add	a0,a0,a5
    80005844:	4785                	li	a5,1
    80005846:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000584a:	0001f517          	auipc	a0,0x1f
    8000584e:	7ce50513          	addi	a0,a0,1998 # 80025018 <disk+0x2018>
    80005852:	ffffc097          	auipc	ra,0xffffc
    80005856:	e58080e7          	jalr	-424(ra) # 800016aa <wakeup>
}
    8000585a:	60a2                	ld	ra,8(sp)
    8000585c:	6402                	ld	s0,0(sp)
    8000585e:	0141                	addi	sp,sp,16
    80005860:	8082                	ret
    panic("free_desc 1");
    80005862:	00003517          	auipc	a0,0x3
    80005866:	e6e50513          	addi	a0,a0,-402 # 800086d0 <syscalls+0x340>
    8000586a:	00001097          	auipc	ra,0x1
    8000586e:	a1e080e7          	jalr	-1506(ra) # 80006288 <panic>
    panic("free_desc 2");
    80005872:	00003517          	auipc	a0,0x3
    80005876:	e6e50513          	addi	a0,a0,-402 # 800086e0 <syscalls+0x350>
    8000587a:	00001097          	auipc	ra,0x1
    8000587e:	a0e080e7          	jalr	-1522(ra) # 80006288 <panic>

0000000080005882 <virtio_disk_init>:
{
    80005882:	1101                	addi	sp,sp,-32
    80005884:	ec06                	sd	ra,24(sp)
    80005886:	e822                	sd	s0,16(sp)
    80005888:	e426                	sd	s1,8(sp)
    8000588a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000588c:	00003597          	auipc	a1,0x3
    80005890:	e6458593          	addi	a1,a1,-412 # 800086f0 <syscalls+0x360>
    80005894:	00020517          	auipc	a0,0x20
    80005898:	89450513          	addi	a0,a0,-1900 # 80025128 <disk+0x2128>
    8000589c:	00001097          	auipc	ra,0x1
    800058a0:	ea6080e7          	jalr	-346(ra) # 80006742 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058a4:	100017b7          	lui	a5,0x10001
    800058a8:	4398                	lw	a4,0(a5)
    800058aa:	2701                	sext.w	a4,a4
    800058ac:	747277b7          	lui	a5,0x74727
    800058b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058b4:	0ef71163          	bne	a4,a5,80005996 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	43dc                	lw	a5,4(a5)
    800058be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058c0:	4705                	li	a4,1
    800058c2:	0ce79a63          	bne	a5,a4,80005996 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058c6:	100017b7          	lui	a5,0x10001
    800058ca:	479c                	lw	a5,8(a5)
    800058cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800058ce:	4709                	li	a4,2
    800058d0:	0ce79363          	bne	a5,a4,80005996 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058d4:	100017b7          	lui	a5,0x10001
    800058d8:	47d8                	lw	a4,12(a5)
    800058da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058dc:	554d47b7          	lui	a5,0x554d4
    800058e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058e4:	0af71963          	bne	a4,a5,80005996 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e8:	100017b7          	lui	a5,0x10001
    800058ec:	4705                	li	a4,1
    800058ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800058f0:	470d                	li	a4,3
    800058f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800058f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800058f6:	c7ffe737          	lui	a4,0xc7ffe
    800058fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd051f>
    800058fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005900:	2701                	sext.w	a4,a4
    80005902:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005904:	472d                	li	a4,11
    80005906:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005908:	473d                	li	a4,15
    8000590a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000590c:	6705                	lui	a4,0x1
    8000590e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005910:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005914:	5bdc                	lw	a5,52(a5)
    80005916:	2781                	sext.w	a5,a5
  if(max == 0)
    80005918:	c7d9                	beqz	a5,800059a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000591a:	471d                	li	a4,7
    8000591c:	08f77d63          	bgeu	a4,a5,800059b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005920:	100014b7          	lui	s1,0x10001
    80005924:	47a1                	li	a5,8
    80005926:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005928:	6609                	lui	a2,0x2
    8000592a:	4581                	li	a1,0
    8000592c:	0001d517          	auipc	a0,0x1d
    80005930:	6d450513          	addi	a0,a0,1748 # 80023000 <disk>
    80005934:	ffffb097          	auipc	ra,0xffffb
    80005938:	844080e7          	jalr	-1980(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000593c:	0001d717          	auipc	a4,0x1d
    80005940:	6c470713          	addi	a4,a4,1732 # 80023000 <disk>
    80005944:	00c75793          	srli	a5,a4,0xc
    80005948:	2781                	sext.w	a5,a5
    8000594a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000594c:	0001f797          	auipc	a5,0x1f
    80005950:	6b478793          	addi	a5,a5,1716 # 80025000 <disk+0x2000>
    80005954:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005956:	0001d717          	auipc	a4,0x1d
    8000595a:	72a70713          	addi	a4,a4,1834 # 80023080 <disk+0x80>
    8000595e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005960:	0001e717          	auipc	a4,0x1e
    80005964:	6a070713          	addi	a4,a4,1696 # 80024000 <disk+0x1000>
    80005968:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000596a:	4705                	li	a4,1
    8000596c:	00e78c23          	sb	a4,24(a5)
    80005970:	00e78ca3          	sb	a4,25(a5)
    80005974:	00e78d23          	sb	a4,26(a5)
    80005978:	00e78da3          	sb	a4,27(a5)
    8000597c:	00e78e23          	sb	a4,28(a5)
    80005980:	00e78ea3          	sb	a4,29(a5)
    80005984:	00e78f23          	sb	a4,30(a5)
    80005988:	00e78fa3          	sb	a4,31(a5)
}
    8000598c:	60e2                	ld	ra,24(sp)
    8000598e:	6442                	ld	s0,16(sp)
    80005990:	64a2                	ld	s1,8(sp)
    80005992:	6105                	addi	sp,sp,32
    80005994:	8082                	ret
    panic("could not find virtio disk");
    80005996:	00003517          	auipc	a0,0x3
    8000599a:	d6a50513          	addi	a0,a0,-662 # 80008700 <syscalls+0x370>
    8000599e:	00001097          	auipc	ra,0x1
    800059a2:	8ea080e7          	jalr	-1814(ra) # 80006288 <panic>
    panic("virtio disk has no queue 0");
    800059a6:	00003517          	auipc	a0,0x3
    800059aa:	d7a50513          	addi	a0,a0,-646 # 80008720 <syscalls+0x390>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	8da080e7          	jalr	-1830(ra) # 80006288 <panic>
    panic("virtio disk max queue too short");
    800059b6:	00003517          	auipc	a0,0x3
    800059ba:	d8a50513          	addi	a0,a0,-630 # 80008740 <syscalls+0x3b0>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	8ca080e7          	jalr	-1846(ra) # 80006288 <panic>

00000000800059c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800059c6:	7159                	addi	sp,sp,-112
    800059c8:	f486                	sd	ra,104(sp)
    800059ca:	f0a2                	sd	s0,96(sp)
    800059cc:	eca6                	sd	s1,88(sp)
    800059ce:	e8ca                	sd	s2,80(sp)
    800059d0:	e4ce                	sd	s3,72(sp)
    800059d2:	e0d2                	sd	s4,64(sp)
    800059d4:	fc56                	sd	s5,56(sp)
    800059d6:	f85a                	sd	s6,48(sp)
    800059d8:	f45e                	sd	s7,40(sp)
    800059da:	f062                	sd	s8,32(sp)
    800059dc:	ec66                	sd	s9,24(sp)
    800059de:	e86a                	sd	s10,16(sp)
    800059e0:	1880                	addi	s0,sp,112
    800059e2:	892a                	mv	s2,a0
    800059e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800059e6:	00c52c83          	lw	s9,12(a0)
    800059ea:	001c9c9b          	slliw	s9,s9,0x1
    800059ee:	1c82                	slli	s9,s9,0x20
    800059f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800059f4:	0001f517          	auipc	a0,0x1f
    800059f8:	73450513          	addi	a0,a0,1844 # 80025128 <disk+0x2128>
    800059fc:	00001097          	auipc	ra,0x1
    80005a00:	dd6080e7          	jalr	-554(ra) # 800067d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005a04:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005a06:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005a08:	0001db97          	auipc	s7,0x1d
    80005a0c:	5f8b8b93          	addi	s7,s7,1528 # 80023000 <disk>
    80005a10:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005a12:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005a14:	8a4e                	mv	s4,s3
    80005a16:	a051                	j	80005a9a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005a18:	00fb86b3          	add	a3,s7,a5
    80005a1c:	96da                	add	a3,a3,s6
    80005a1e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005a22:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005a24:	0207c563          	bltz	a5,80005a4e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005a28:	2485                	addiw	s1,s1,1
    80005a2a:	0711                	addi	a4,a4,4
    80005a2c:	25548063          	beq	s1,s5,80005c6c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005a30:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005a32:	0001f697          	auipc	a3,0x1f
    80005a36:	5e668693          	addi	a3,a3,1510 # 80025018 <disk+0x2018>
    80005a3a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005a3c:	0006c583          	lbu	a1,0(a3)
    80005a40:	fde1                	bnez	a1,80005a18 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005a42:	2785                	addiw	a5,a5,1
    80005a44:	0685                	addi	a3,a3,1
    80005a46:	ff879be3          	bne	a5,s8,80005a3c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005a4a:	57fd                	li	a5,-1
    80005a4c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005a4e:	02905a63          	blez	s1,80005a82 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a52:	f9042503          	lw	a0,-112(s0)
    80005a56:	00000097          	auipc	ra,0x0
    80005a5a:	d90080e7          	jalr	-624(ra) # 800057e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005a5e:	4785                	li	a5,1
    80005a60:	0297d163          	bge	a5,s1,80005a82 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a64:	f9442503          	lw	a0,-108(s0)
    80005a68:	00000097          	auipc	ra,0x0
    80005a6c:	d7e080e7          	jalr	-642(ra) # 800057e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005a70:	4789                	li	a5,2
    80005a72:	0097d863          	bge	a5,s1,80005a82 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a76:	f9842503          	lw	a0,-104(s0)
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	d6c080e7          	jalr	-660(ra) # 800057e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005a82:	0001f597          	auipc	a1,0x1f
    80005a86:	6a658593          	addi	a1,a1,1702 # 80025128 <disk+0x2128>
    80005a8a:	0001f517          	auipc	a0,0x1f
    80005a8e:	58e50513          	addi	a0,a0,1422 # 80025018 <disk+0x2018>
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	a8c080e7          	jalr	-1396(ra) # 8000151e <sleep>
  for(int i = 0; i < 3; i++){
    80005a9a:	f9040713          	addi	a4,s0,-112
    80005a9e:	84ce                	mv	s1,s3
    80005aa0:	bf41                	j	80005a30 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005aa2:	20058713          	addi	a4,a1,512
    80005aa6:	00471693          	slli	a3,a4,0x4
    80005aaa:	0001d717          	auipc	a4,0x1d
    80005aae:	55670713          	addi	a4,a4,1366 # 80023000 <disk>
    80005ab2:	9736                	add	a4,a4,a3
    80005ab4:	4685                	li	a3,1
    80005ab6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005aba:	20058713          	addi	a4,a1,512
    80005abe:	00471693          	slli	a3,a4,0x4
    80005ac2:	0001d717          	auipc	a4,0x1d
    80005ac6:	53e70713          	addi	a4,a4,1342 # 80023000 <disk>
    80005aca:	9736                	add	a4,a4,a3
    80005acc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005ad0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005ad4:	7679                	lui	a2,0xffffe
    80005ad6:	963e                	add	a2,a2,a5
    80005ad8:	0001f697          	auipc	a3,0x1f
    80005adc:	52868693          	addi	a3,a3,1320 # 80025000 <disk+0x2000>
    80005ae0:	6298                	ld	a4,0(a3)
    80005ae2:	9732                	add	a4,a4,a2
    80005ae4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005ae6:	6298                	ld	a4,0(a3)
    80005ae8:	9732                	add	a4,a4,a2
    80005aea:	4541                	li	a0,16
    80005aec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005aee:	6298                	ld	a4,0(a3)
    80005af0:	9732                	add	a4,a4,a2
    80005af2:	4505                	li	a0,1
    80005af4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005af8:	f9442703          	lw	a4,-108(s0)
    80005afc:	6288                	ld	a0,0(a3)
    80005afe:	962a                	add	a2,a2,a0
    80005b00:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcfdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b04:	0712                	slli	a4,a4,0x4
    80005b06:	6290                	ld	a2,0(a3)
    80005b08:	963a                	add	a2,a2,a4
    80005b0a:	05890513          	addi	a0,s2,88
    80005b0e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b10:	6294                	ld	a3,0(a3)
    80005b12:	96ba                	add	a3,a3,a4
    80005b14:	40000613          	li	a2,1024
    80005b18:	c690                	sw	a2,8(a3)
  if(write)
    80005b1a:	140d0063          	beqz	s10,80005c5a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005b1e:	0001f697          	auipc	a3,0x1f
    80005b22:	4e26b683          	ld	a3,1250(a3) # 80025000 <disk+0x2000>
    80005b26:	96ba                	add	a3,a3,a4
    80005b28:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005b2c:	0001d817          	auipc	a6,0x1d
    80005b30:	4d480813          	addi	a6,a6,1236 # 80023000 <disk>
    80005b34:	0001f517          	auipc	a0,0x1f
    80005b38:	4cc50513          	addi	a0,a0,1228 # 80025000 <disk+0x2000>
    80005b3c:	6114                	ld	a3,0(a0)
    80005b3e:	96ba                	add	a3,a3,a4
    80005b40:	00c6d603          	lhu	a2,12(a3)
    80005b44:	00166613          	ori	a2,a2,1
    80005b48:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005b4c:	f9842683          	lw	a3,-104(s0)
    80005b50:	6110                	ld	a2,0(a0)
    80005b52:	9732                	add	a4,a4,a2
    80005b54:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005b58:	20058613          	addi	a2,a1,512
    80005b5c:	0612                	slli	a2,a2,0x4
    80005b5e:	9642                	add	a2,a2,a6
    80005b60:	577d                	li	a4,-1
    80005b62:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005b66:	00469713          	slli	a4,a3,0x4
    80005b6a:	6114                	ld	a3,0(a0)
    80005b6c:	96ba                	add	a3,a3,a4
    80005b6e:	03078793          	addi	a5,a5,48
    80005b72:	97c2                	add	a5,a5,a6
    80005b74:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005b76:	611c                	ld	a5,0(a0)
    80005b78:	97ba                	add	a5,a5,a4
    80005b7a:	4685                	li	a3,1
    80005b7c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005b7e:	611c                	ld	a5,0(a0)
    80005b80:	97ba                	add	a5,a5,a4
    80005b82:	4809                	li	a6,2
    80005b84:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005b88:	611c                	ld	a5,0(a0)
    80005b8a:	973e                	add	a4,a4,a5
    80005b8c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005b90:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005b94:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005b98:	6518                	ld	a4,8(a0)
    80005b9a:	00275783          	lhu	a5,2(a4)
    80005b9e:	8b9d                	andi	a5,a5,7
    80005ba0:	0786                	slli	a5,a5,0x1
    80005ba2:	97ba                	add	a5,a5,a4
    80005ba4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005ba8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005bac:	6518                	ld	a4,8(a0)
    80005bae:	00275783          	lhu	a5,2(a4)
    80005bb2:	2785                	addiw	a5,a5,1
    80005bb4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005bb8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005bbc:	100017b7          	lui	a5,0x10001
    80005bc0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005bc4:	00492703          	lw	a4,4(s2)
    80005bc8:	4785                	li	a5,1
    80005bca:	02f71163          	bne	a4,a5,80005bec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005bce:	0001f997          	auipc	s3,0x1f
    80005bd2:	55a98993          	addi	s3,s3,1370 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80005bd6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005bd8:	85ce                	mv	a1,s3
    80005bda:	854a                	mv	a0,s2
    80005bdc:	ffffc097          	auipc	ra,0xffffc
    80005be0:	942080e7          	jalr	-1726(ra) # 8000151e <sleep>
  while(b->disk == 1) {
    80005be4:	00492783          	lw	a5,4(s2)
    80005be8:	fe9788e3          	beq	a5,s1,80005bd8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005bec:	f9042903          	lw	s2,-112(s0)
    80005bf0:	20090793          	addi	a5,s2,512
    80005bf4:	00479713          	slli	a4,a5,0x4
    80005bf8:	0001d797          	auipc	a5,0x1d
    80005bfc:	40878793          	addi	a5,a5,1032 # 80023000 <disk>
    80005c00:	97ba                	add	a5,a5,a4
    80005c02:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005c06:	0001f997          	auipc	s3,0x1f
    80005c0a:	3fa98993          	addi	s3,s3,1018 # 80025000 <disk+0x2000>
    80005c0e:	00491713          	slli	a4,s2,0x4
    80005c12:	0009b783          	ld	a5,0(s3)
    80005c16:	97ba                	add	a5,a5,a4
    80005c18:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c1c:	854a                	mv	a0,s2
    80005c1e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	bc4080e7          	jalr	-1084(ra) # 800057e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c2a:	8885                	andi	s1,s1,1
    80005c2c:	f0ed                	bnez	s1,80005c0e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c2e:	0001f517          	auipc	a0,0x1f
    80005c32:	4fa50513          	addi	a0,a0,1274 # 80025128 <disk+0x2128>
    80005c36:	00001097          	auipc	ra,0x1
    80005c3a:	c50080e7          	jalr	-944(ra) # 80006886 <release>
}
    80005c3e:	70a6                	ld	ra,104(sp)
    80005c40:	7406                	ld	s0,96(sp)
    80005c42:	64e6                	ld	s1,88(sp)
    80005c44:	6946                	ld	s2,80(sp)
    80005c46:	69a6                	ld	s3,72(sp)
    80005c48:	6a06                	ld	s4,64(sp)
    80005c4a:	7ae2                	ld	s5,56(sp)
    80005c4c:	7b42                	ld	s6,48(sp)
    80005c4e:	7ba2                	ld	s7,40(sp)
    80005c50:	7c02                	ld	s8,32(sp)
    80005c52:	6ce2                	ld	s9,24(sp)
    80005c54:	6d42                	ld	s10,16(sp)
    80005c56:	6165                	addi	sp,sp,112
    80005c58:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005c5a:	0001f697          	auipc	a3,0x1f
    80005c5e:	3a66b683          	ld	a3,934(a3) # 80025000 <disk+0x2000>
    80005c62:	96ba                	add	a3,a3,a4
    80005c64:	4609                	li	a2,2
    80005c66:	00c69623          	sh	a2,12(a3)
    80005c6a:	b5c9                	j	80005b2c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c6c:	f9042583          	lw	a1,-112(s0)
    80005c70:	20058793          	addi	a5,a1,512
    80005c74:	0792                	slli	a5,a5,0x4
    80005c76:	0001d517          	auipc	a0,0x1d
    80005c7a:	43250513          	addi	a0,a0,1074 # 800230a8 <disk+0xa8>
    80005c7e:	953e                	add	a0,a0,a5
  if(write)
    80005c80:	e20d11e3          	bnez	s10,80005aa2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005c84:	20058713          	addi	a4,a1,512
    80005c88:	00471693          	slli	a3,a4,0x4
    80005c8c:	0001d717          	auipc	a4,0x1d
    80005c90:	37470713          	addi	a4,a4,884 # 80023000 <disk>
    80005c94:	9736                	add	a4,a4,a3
    80005c96:	0a072423          	sw	zero,168(a4)
    80005c9a:	b505                	j	80005aba <virtio_disk_rw+0xf4>

0000000080005c9c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005c9c:	1101                	addi	sp,sp,-32
    80005c9e:	ec06                	sd	ra,24(sp)
    80005ca0:	e822                	sd	s0,16(sp)
    80005ca2:	e426                	sd	s1,8(sp)
    80005ca4:	e04a                	sd	s2,0(sp)
    80005ca6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005ca8:	0001f517          	auipc	a0,0x1f
    80005cac:	48050513          	addi	a0,a0,1152 # 80025128 <disk+0x2128>
    80005cb0:	00001097          	auipc	ra,0x1
    80005cb4:	b22080e7          	jalr	-1246(ra) # 800067d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cb8:	10001737          	lui	a4,0x10001
    80005cbc:	533c                	lw	a5,96(a4)
    80005cbe:	8b8d                	andi	a5,a5,3
    80005cc0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005cc2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cc6:	0001f797          	auipc	a5,0x1f
    80005cca:	33a78793          	addi	a5,a5,826 # 80025000 <disk+0x2000>
    80005cce:	6b94                	ld	a3,16(a5)
    80005cd0:	0207d703          	lhu	a4,32(a5)
    80005cd4:	0026d783          	lhu	a5,2(a3)
    80005cd8:	06f70163          	beq	a4,a5,80005d3a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cdc:	0001d917          	auipc	s2,0x1d
    80005ce0:	32490913          	addi	s2,s2,804 # 80023000 <disk>
    80005ce4:	0001f497          	auipc	s1,0x1f
    80005ce8:	31c48493          	addi	s1,s1,796 # 80025000 <disk+0x2000>
    __sync_synchronize();
    80005cec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cf0:	6898                	ld	a4,16(s1)
    80005cf2:	0204d783          	lhu	a5,32(s1)
    80005cf6:	8b9d                	andi	a5,a5,7
    80005cf8:	078e                	slli	a5,a5,0x3
    80005cfa:	97ba                	add	a5,a5,a4
    80005cfc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005cfe:	20078713          	addi	a4,a5,512
    80005d02:	0712                	slli	a4,a4,0x4
    80005d04:	974a                	add	a4,a4,s2
    80005d06:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005d0a:	e731                	bnez	a4,80005d56 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d0c:	20078793          	addi	a5,a5,512
    80005d10:	0792                	slli	a5,a5,0x4
    80005d12:	97ca                	add	a5,a5,s2
    80005d14:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005d16:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d1a:	ffffc097          	auipc	ra,0xffffc
    80005d1e:	990080e7          	jalr	-1648(ra) # 800016aa <wakeup>

    disk.used_idx += 1;
    80005d22:	0204d783          	lhu	a5,32(s1)
    80005d26:	2785                	addiw	a5,a5,1
    80005d28:	17c2                	slli	a5,a5,0x30
    80005d2a:	93c1                	srli	a5,a5,0x30
    80005d2c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d30:	6898                	ld	a4,16(s1)
    80005d32:	00275703          	lhu	a4,2(a4)
    80005d36:	faf71be3          	bne	a4,a5,80005cec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005d3a:	0001f517          	auipc	a0,0x1f
    80005d3e:	3ee50513          	addi	a0,a0,1006 # 80025128 <disk+0x2128>
    80005d42:	00001097          	auipc	ra,0x1
    80005d46:	b44080e7          	jalr	-1212(ra) # 80006886 <release>
}
    80005d4a:	60e2                	ld	ra,24(sp)
    80005d4c:	6442                	ld	s0,16(sp)
    80005d4e:	64a2                	ld	s1,8(sp)
    80005d50:	6902                	ld	s2,0(sp)
    80005d52:	6105                	addi	sp,sp,32
    80005d54:	8082                	ret
      panic("virtio_disk_intr status");
    80005d56:	00003517          	auipc	a0,0x3
    80005d5a:	a0a50513          	addi	a0,a0,-1526 # 80008760 <syscalls+0x3d0>
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	52a080e7          	jalr	1322(ra) # 80006288 <panic>

0000000080005d66 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d66:	1141                	addi	sp,sp,-16
    80005d68:	e422                	sd	s0,8(sp)
    80005d6a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d6c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d70:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d74:	0037979b          	slliw	a5,a5,0x3
    80005d78:	02004737          	lui	a4,0x2004
    80005d7c:	97ba                	add	a5,a5,a4
    80005d7e:	0200c737          	lui	a4,0x200c
    80005d82:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d86:	000f4637          	lui	a2,0xf4
    80005d8a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d8e:	95b2                	add	a1,a1,a2
    80005d90:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d92:	00269713          	slli	a4,a3,0x2
    80005d96:	9736                	add	a4,a4,a3
    80005d98:	00371693          	slli	a3,a4,0x3
    80005d9c:	00020717          	auipc	a4,0x20
    80005da0:	26470713          	addi	a4,a4,612 # 80026000 <timer_scratch>
    80005da4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005da6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005da8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005daa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005dae:	00000797          	auipc	a5,0x0
    80005db2:	97278793          	addi	a5,a5,-1678 # 80005720 <timervec>
    80005db6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005dba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005dbe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005dc2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005dc6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005dca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005dce:	30479073          	csrw	mie,a5
}
    80005dd2:	6422                	ld	s0,8(sp)
    80005dd4:	0141                	addi	sp,sp,16
    80005dd6:	8082                	ret

0000000080005dd8 <start>:
{
    80005dd8:	1141                	addi	sp,sp,-16
    80005dda:	e406                	sd	ra,8(sp)
    80005ddc:	e022                	sd	s0,0(sp)
    80005dde:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005de0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005de4:	7779                	lui	a4,0xffffe
    80005de6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd05bf>
    80005dea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005dec:	6705                	lui	a4,0x1
    80005dee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005df2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005df4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005df8:	ffffa797          	auipc	a5,0xffffa
    80005dfc:	52e78793          	addi	a5,a5,1326 # 80000326 <main>
    80005e00:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e04:	4781                	li	a5,0
    80005e06:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e0a:	67c1                	lui	a5,0x10
    80005e0c:	17fd                	addi	a5,a5,-1
    80005e0e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e12:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e16:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e1a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e1e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e22:	57fd                	li	a5,-1
    80005e24:	83a9                	srli	a5,a5,0xa
    80005e26:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e2a:	47bd                	li	a5,15
    80005e2c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	f36080e7          	jalr	-202(ra) # 80005d66 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e38:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e3c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e3e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e40:	30200073          	mret
}
    80005e44:	60a2                	ld	ra,8(sp)
    80005e46:	6402                	ld	s0,0(sp)
    80005e48:	0141                	addi	sp,sp,16
    80005e4a:	8082                	ret

0000000080005e4c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e4c:	715d                	addi	sp,sp,-80
    80005e4e:	e486                	sd	ra,72(sp)
    80005e50:	e0a2                	sd	s0,64(sp)
    80005e52:	fc26                	sd	s1,56(sp)
    80005e54:	f84a                	sd	s2,48(sp)
    80005e56:	f44e                	sd	s3,40(sp)
    80005e58:	f052                	sd	s4,32(sp)
    80005e5a:	ec56                	sd	s5,24(sp)
    80005e5c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e5e:	04c05663          	blez	a2,80005eaa <consolewrite+0x5e>
    80005e62:	8a2a                	mv	s4,a0
    80005e64:	84ae                	mv	s1,a1
    80005e66:	89b2                	mv	s3,a2
    80005e68:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e6a:	5afd                	li	s5,-1
    80005e6c:	4685                	li	a3,1
    80005e6e:	8626                	mv	a2,s1
    80005e70:	85d2                	mv	a1,s4
    80005e72:	fbf40513          	addi	a0,s0,-65
    80005e76:	ffffc097          	auipc	ra,0xffffc
    80005e7a:	c56080e7          	jalr	-938(ra) # 80001acc <either_copyin>
    80005e7e:	01550c63          	beq	a0,s5,80005e96 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005e82:	fbf44503          	lbu	a0,-65(s0)
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	78e080e7          	jalr	1934(ra) # 80006614 <uartputc>
  for(i = 0; i < n; i++){
    80005e8e:	2905                	addiw	s2,s2,1
    80005e90:	0485                	addi	s1,s1,1
    80005e92:	fd299de3          	bne	s3,s2,80005e6c <consolewrite+0x20>
  }

  return i;
}
    80005e96:	854a                	mv	a0,s2
    80005e98:	60a6                	ld	ra,72(sp)
    80005e9a:	6406                	ld	s0,64(sp)
    80005e9c:	74e2                	ld	s1,56(sp)
    80005e9e:	7942                	ld	s2,48(sp)
    80005ea0:	79a2                	ld	s3,40(sp)
    80005ea2:	7a02                	ld	s4,32(sp)
    80005ea4:	6ae2                	ld	s5,24(sp)
    80005ea6:	6161                	addi	sp,sp,80
    80005ea8:	8082                	ret
  for(i = 0; i < n; i++){
    80005eaa:	4901                	li	s2,0
    80005eac:	b7ed                	j	80005e96 <consolewrite+0x4a>

0000000080005eae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005eae:	7119                	addi	sp,sp,-128
    80005eb0:	fc86                	sd	ra,120(sp)
    80005eb2:	f8a2                	sd	s0,112(sp)
    80005eb4:	f4a6                	sd	s1,104(sp)
    80005eb6:	f0ca                	sd	s2,96(sp)
    80005eb8:	ecce                	sd	s3,88(sp)
    80005eba:	e8d2                	sd	s4,80(sp)
    80005ebc:	e4d6                	sd	s5,72(sp)
    80005ebe:	e0da                	sd	s6,64(sp)
    80005ec0:	fc5e                	sd	s7,56(sp)
    80005ec2:	f862                	sd	s8,48(sp)
    80005ec4:	f466                	sd	s9,40(sp)
    80005ec6:	f06a                	sd	s10,32(sp)
    80005ec8:	ec6e                	sd	s11,24(sp)
    80005eca:	0100                	addi	s0,sp,128
    80005ecc:	8b2a                	mv	s6,a0
    80005ece:	8aae                	mv	s5,a1
    80005ed0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ed2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005ed6:	00028517          	auipc	a0,0x28
    80005eda:	26a50513          	addi	a0,a0,618 # 8002e140 <cons>
    80005ede:	00001097          	auipc	ra,0x1
    80005ee2:	8f4080e7          	jalr	-1804(ra) # 800067d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ee6:	00028497          	auipc	s1,0x28
    80005eea:	25a48493          	addi	s1,s1,602 # 8002e140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005eee:	89a6                	mv	s3,s1
    80005ef0:	00028917          	auipc	s2,0x28
    80005ef4:	2e890913          	addi	s2,s2,744 # 8002e1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005ef8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005efa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005efc:	4da9                	li	s11,10
  while(n > 0){
    80005efe:	07405863          	blez	s4,80005f6e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005f02:	0984a783          	lw	a5,152(s1)
    80005f06:	09c4a703          	lw	a4,156(s1)
    80005f0a:	02f71463          	bne	a4,a5,80005f32 <consoleread+0x84>
      if(myproc()->killed){
    80005f0e:	ffffb097          	auipc	ra,0xffffb
    80005f12:	f10080e7          	jalr	-240(ra) # 80000e1e <myproc>
    80005f16:	551c                	lw	a5,40(a0)
    80005f18:	e7b5                	bnez	a5,80005f84 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005f1a:	85ce                	mv	a1,s3
    80005f1c:	854a                	mv	a0,s2
    80005f1e:	ffffb097          	auipc	ra,0xffffb
    80005f22:	600080e7          	jalr	1536(ra) # 8000151e <sleep>
    while(cons.r == cons.w){
    80005f26:	0984a783          	lw	a5,152(s1)
    80005f2a:	09c4a703          	lw	a4,156(s1)
    80005f2e:	fef700e3          	beq	a4,a5,80005f0e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005f32:	0017871b          	addiw	a4,a5,1
    80005f36:	08e4ac23          	sw	a4,152(s1)
    80005f3a:	07f7f713          	andi	a4,a5,127
    80005f3e:	9726                	add	a4,a4,s1
    80005f40:	01874703          	lbu	a4,24(a4)
    80005f44:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005f48:	079c0663          	beq	s8,s9,80005fb4 <consoleread+0x106>
    cbuf = c;
    80005f4c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f50:	4685                	li	a3,1
    80005f52:	f8f40613          	addi	a2,s0,-113
    80005f56:	85d6                	mv	a1,s5
    80005f58:	855a                	mv	a0,s6
    80005f5a:	ffffc097          	auipc	ra,0xffffc
    80005f5e:	b1c080e7          	jalr	-1252(ra) # 80001a76 <either_copyout>
    80005f62:	01a50663          	beq	a0,s10,80005f6e <consoleread+0xc0>
    dst++;
    80005f66:	0a85                	addi	s5,s5,1
    --n;
    80005f68:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005f6a:	f9bc1ae3          	bne	s8,s11,80005efe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005f6e:	00028517          	auipc	a0,0x28
    80005f72:	1d250513          	addi	a0,a0,466 # 8002e140 <cons>
    80005f76:	00001097          	auipc	ra,0x1
    80005f7a:	910080e7          	jalr	-1776(ra) # 80006886 <release>

  return target - n;
    80005f7e:	414b853b          	subw	a0,s7,s4
    80005f82:	a811                	j	80005f96 <consoleread+0xe8>
        release(&cons.lock);
    80005f84:	00028517          	auipc	a0,0x28
    80005f88:	1bc50513          	addi	a0,a0,444 # 8002e140 <cons>
    80005f8c:	00001097          	auipc	ra,0x1
    80005f90:	8fa080e7          	jalr	-1798(ra) # 80006886 <release>
        return -1;
    80005f94:	557d                	li	a0,-1
}
    80005f96:	70e6                	ld	ra,120(sp)
    80005f98:	7446                	ld	s0,112(sp)
    80005f9a:	74a6                	ld	s1,104(sp)
    80005f9c:	7906                	ld	s2,96(sp)
    80005f9e:	69e6                	ld	s3,88(sp)
    80005fa0:	6a46                	ld	s4,80(sp)
    80005fa2:	6aa6                	ld	s5,72(sp)
    80005fa4:	6b06                	ld	s6,64(sp)
    80005fa6:	7be2                	ld	s7,56(sp)
    80005fa8:	7c42                	ld	s8,48(sp)
    80005faa:	7ca2                	ld	s9,40(sp)
    80005fac:	7d02                	ld	s10,32(sp)
    80005fae:	6de2                	ld	s11,24(sp)
    80005fb0:	6109                	addi	sp,sp,128
    80005fb2:	8082                	ret
      if(n < target){
    80005fb4:	000a071b          	sext.w	a4,s4
    80005fb8:	fb777be3          	bgeu	a4,s7,80005f6e <consoleread+0xc0>
        cons.r--;
    80005fbc:	00028717          	auipc	a4,0x28
    80005fc0:	20f72e23          	sw	a5,540(a4) # 8002e1d8 <cons+0x98>
    80005fc4:	b76d                	j	80005f6e <consoleread+0xc0>

0000000080005fc6 <consputc>:
{
    80005fc6:	1141                	addi	sp,sp,-16
    80005fc8:	e406                	sd	ra,8(sp)
    80005fca:	e022                	sd	s0,0(sp)
    80005fcc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fce:	10000793          	li	a5,256
    80005fd2:	00f50a63          	beq	a0,a5,80005fe6 <consputc+0x20>
    uartputc_sync(c);
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	564080e7          	jalr	1380(ra) # 8000653a <uartputc_sync>
}
    80005fde:	60a2                	ld	ra,8(sp)
    80005fe0:	6402                	ld	s0,0(sp)
    80005fe2:	0141                	addi	sp,sp,16
    80005fe4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005fe6:	4521                	li	a0,8
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	552080e7          	jalr	1362(ra) # 8000653a <uartputc_sync>
    80005ff0:	02000513          	li	a0,32
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	546080e7          	jalr	1350(ra) # 8000653a <uartputc_sync>
    80005ffc:	4521                	li	a0,8
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	53c080e7          	jalr	1340(ra) # 8000653a <uartputc_sync>
    80006006:	bfe1                	j	80005fde <consputc+0x18>

0000000080006008 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006008:	1101                	addi	sp,sp,-32
    8000600a:	ec06                	sd	ra,24(sp)
    8000600c:	e822                	sd	s0,16(sp)
    8000600e:	e426                	sd	s1,8(sp)
    80006010:	e04a                	sd	s2,0(sp)
    80006012:	1000                	addi	s0,sp,32
    80006014:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006016:	00028517          	auipc	a0,0x28
    8000601a:	12a50513          	addi	a0,a0,298 # 8002e140 <cons>
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	7b4080e7          	jalr	1972(ra) # 800067d2 <acquire>

  switch(c){
    80006026:	47d5                	li	a5,21
    80006028:	0af48663          	beq	s1,a5,800060d4 <consoleintr+0xcc>
    8000602c:	0297ca63          	blt	a5,s1,80006060 <consoleintr+0x58>
    80006030:	47a1                	li	a5,8
    80006032:	0ef48763          	beq	s1,a5,80006120 <consoleintr+0x118>
    80006036:	47c1                	li	a5,16
    80006038:	10f49a63          	bne	s1,a5,8000614c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000603c:	ffffc097          	auipc	ra,0xffffc
    80006040:	ae6080e7          	jalr	-1306(ra) # 80001b22 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006044:	00028517          	auipc	a0,0x28
    80006048:	0fc50513          	addi	a0,a0,252 # 8002e140 <cons>
    8000604c:	00001097          	auipc	ra,0x1
    80006050:	83a080e7          	jalr	-1990(ra) # 80006886 <release>
}
    80006054:	60e2                	ld	ra,24(sp)
    80006056:	6442                	ld	s0,16(sp)
    80006058:	64a2                	ld	s1,8(sp)
    8000605a:	6902                	ld	s2,0(sp)
    8000605c:	6105                	addi	sp,sp,32
    8000605e:	8082                	ret
  switch(c){
    80006060:	07f00793          	li	a5,127
    80006064:	0af48e63          	beq	s1,a5,80006120 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006068:	00028717          	auipc	a4,0x28
    8000606c:	0d870713          	addi	a4,a4,216 # 8002e140 <cons>
    80006070:	0a072783          	lw	a5,160(a4)
    80006074:	09872703          	lw	a4,152(a4)
    80006078:	9f99                	subw	a5,a5,a4
    8000607a:	07f00713          	li	a4,127
    8000607e:	fcf763e3          	bltu	a4,a5,80006044 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006082:	47b5                	li	a5,13
    80006084:	0cf48763          	beq	s1,a5,80006152 <consoleintr+0x14a>
      consputc(c);
    80006088:	8526                	mv	a0,s1
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	f3c080e7          	jalr	-196(ra) # 80005fc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006092:	00028797          	auipc	a5,0x28
    80006096:	0ae78793          	addi	a5,a5,174 # 8002e140 <cons>
    8000609a:	0a07a703          	lw	a4,160(a5)
    8000609e:	0017069b          	addiw	a3,a4,1
    800060a2:	0006861b          	sext.w	a2,a3
    800060a6:	0ad7a023          	sw	a3,160(a5)
    800060aa:	07f77713          	andi	a4,a4,127
    800060ae:	97ba                	add	a5,a5,a4
    800060b0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    800060b4:	47a9                	li	a5,10
    800060b6:	0cf48563          	beq	s1,a5,80006180 <consoleintr+0x178>
    800060ba:	4791                	li	a5,4
    800060bc:	0cf48263          	beq	s1,a5,80006180 <consoleintr+0x178>
    800060c0:	00028797          	auipc	a5,0x28
    800060c4:	1187a783          	lw	a5,280(a5) # 8002e1d8 <cons+0x98>
    800060c8:	0807879b          	addiw	a5,a5,128
    800060cc:	f6f61ce3          	bne	a2,a5,80006044 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060d0:	863e                	mv	a2,a5
    800060d2:	a07d                	j	80006180 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800060d4:	00028717          	auipc	a4,0x28
    800060d8:	06c70713          	addi	a4,a4,108 # 8002e140 <cons>
    800060dc:	0a072783          	lw	a5,160(a4)
    800060e0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800060e4:	00028497          	auipc	s1,0x28
    800060e8:	05c48493          	addi	s1,s1,92 # 8002e140 <cons>
    while(cons.e != cons.w &&
    800060ec:	4929                	li	s2,10
    800060ee:	f4f70be3          	beq	a4,a5,80006044 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800060f2:	37fd                	addiw	a5,a5,-1
    800060f4:	07f7f713          	andi	a4,a5,127
    800060f8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800060fa:	01874703          	lbu	a4,24(a4)
    800060fe:	f52703e3          	beq	a4,s2,80006044 <consoleintr+0x3c>
      cons.e--;
    80006102:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006106:	10000513          	li	a0,256
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	ebc080e7          	jalr	-324(ra) # 80005fc6 <consputc>
    while(cons.e != cons.w &&
    80006112:	0a04a783          	lw	a5,160(s1)
    80006116:	09c4a703          	lw	a4,156(s1)
    8000611a:	fcf71ce3          	bne	a4,a5,800060f2 <consoleintr+0xea>
    8000611e:	b71d                	j	80006044 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006120:	00028717          	auipc	a4,0x28
    80006124:	02070713          	addi	a4,a4,32 # 8002e140 <cons>
    80006128:	0a072783          	lw	a5,160(a4)
    8000612c:	09c72703          	lw	a4,156(a4)
    80006130:	f0f70ae3          	beq	a4,a5,80006044 <consoleintr+0x3c>
      cons.e--;
    80006134:	37fd                	addiw	a5,a5,-1
    80006136:	00028717          	auipc	a4,0x28
    8000613a:	0af72523          	sw	a5,170(a4) # 8002e1e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000613e:	10000513          	li	a0,256
    80006142:	00000097          	auipc	ra,0x0
    80006146:	e84080e7          	jalr	-380(ra) # 80005fc6 <consputc>
    8000614a:	bded                	j	80006044 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000614c:	ee048ce3          	beqz	s1,80006044 <consoleintr+0x3c>
    80006150:	bf21                	j	80006068 <consoleintr+0x60>
      consputc(c);
    80006152:	4529                	li	a0,10
    80006154:	00000097          	auipc	ra,0x0
    80006158:	e72080e7          	jalr	-398(ra) # 80005fc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000615c:	00028797          	auipc	a5,0x28
    80006160:	fe478793          	addi	a5,a5,-28 # 8002e140 <cons>
    80006164:	0a07a703          	lw	a4,160(a5)
    80006168:	0017069b          	addiw	a3,a4,1
    8000616c:	0006861b          	sext.w	a2,a3
    80006170:	0ad7a023          	sw	a3,160(a5)
    80006174:	07f77713          	andi	a4,a4,127
    80006178:	97ba                	add	a5,a5,a4
    8000617a:	4729                	li	a4,10
    8000617c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006180:	00028797          	auipc	a5,0x28
    80006184:	04c7ae23          	sw	a2,92(a5) # 8002e1dc <cons+0x9c>
        wakeup(&cons.r);
    80006188:	00028517          	auipc	a0,0x28
    8000618c:	05050513          	addi	a0,a0,80 # 8002e1d8 <cons+0x98>
    80006190:	ffffb097          	auipc	ra,0xffffb
    80006194:	51a080e7          	jalr	1306(ra) # 800016aa <wakeup>
    80006198:	b575                	j	80006044 <consoleintr+0x3c>

000000008000619a <consoleinit>:

void
consoleinit(void)
{
    8000619a:	1141                	addi	sp,sp,-16
    8000619c:	e406                	sd	ra,8(sp)
    8000619e:	e022                	sd	s0,0(sp)
    800061a0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061a2:	00002597          	auipc	a1,0x2
    800061a6:	5d658593          	addi	a1,a1,1494 # 80008778 <syscalls+0x3e8>
    800061aa:	00028517          	auipc	a0,0x28
    800061ae:	f9650513          	addi	a0,a0,-106 # 8002e140 <cons>
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	590080e7          	jalr	1424(ra) # 80006742 <initlock>

  uartinit();
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	330080e7          	jalr	816(ra) # 800064ea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800061c2:	0001b797          	auipc	a5,0x1b
    800061c6:	f0678793          	addi	a5,a5,-250 # 800210c8 <devsw>
    800061ca:	00000717          	auipc	a4,0x0
    800061ce:	ce470713          	addi	a4,a4,-796 # 80005eae <consoleread>
    800061d2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061d4:	00000717          	auipc	a4,0x0
    800061d8:	c7870713          	addi	a4,a4,-904 # 80005e4c <consolewrite>
    800061dc:	ef98                	sd	a4,24(a5)
}
    800061de:	60a2                	ld	ra,8(sp)
    800061e0:	6402                	ld	s0,0(sp)
    800061e2:	0141                	addi	sp,sp,16
    800061e4:	8082                	ret

00000000800061e6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061e6:	7179                	addi	sp,sp,-48
    800061e8:	f406                	sd	ra,40(sp)
    800061ea:	f022                	sd	s0,32(sp)
    800061ec:	ec26                	sd	s1,24(sp)
    800061ee:	e84a                	sd	s2,16(sp)
    800061f0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800061f2:	c219                	beqz	a2,800061f8 <printint+0x12>
    800061f4:	08054663          	bltz	a0,80006280 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800061f8:	2501                	sext.w	a0,a0
    800061fa:	4881                	li	a7,0
    800061fc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006200:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006202:	2581                	sext.w	a1,a1
    80006204:	00002617          	auipc	a2,0x2
    80006208:	5a460613          	addi	a2,a2,1444 # 800087a8 <digits>
    8000620c:	883a                	mv	a6,a4
    8000620e:	2705                	addiw	a4,a4,1
    80006210:	02b577bb          	remuw	a5,a0,a1
    80006214:	1782                	slli	a5,a5,0x20
    80006216:	9381                	srli	a5,a5,0x20
    80006218:	97b2                	add	a5,a5,a2
    8000621a:	0007c783          	lbu	a5,0(a5)
    8000621e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006222:	0005079b          	sext.w	a5,a0
    80006226:	02b5553b          	divuw	a0,a0,a1
    8000622a:	0685                	addi	a3,a3,1
    8000622c:	feb7f0e3          	bgeu	a5,a1,8000620c <printint+0x26>

  if(sign)
    80006230:	00088b63          	beqz	a7,80006246 <printint+0x60>
    buf[i++] = '-';
    80006234:	fe040793          	addi	a5,s0,-32
    80006238:	973e                	add	a4,a4,a5
    8000623a:	02d00793          	li	a5,45
    8000623e:	fef70823          	sb	a5,-16(a4)
    80006242:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006246:	02e05763          	blez	a4,80006274 <printint+0x8e>
    8000624a:	fd040793          	addi	a5,s0,-48
    8000624e:	00e784b3          	add	s1,a5,a4
    80006252:	fff78913          	addi	s2,a5,-1
    80006256:	993a                	add	s2,s2,a4
    80006258:	377d                	addiw	a4,a4,-1
    8000625a:	1702                	slli	a4,a4,0x20
    8000625c:	9301                	srli	a4,a4,0x20
    8000625e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006262:	fff4c503          	lbu	a0,-1(s1)
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	d60080e7          	jalr	-672(ra) # 80005fc6 <consputc>
  while(--i >= 0)
    8000626e:	14fd                	addi	s1,s1,-1
    80006270:	ff2499e3          	bne	s1,s2,80006262 <printint+0x7c>
}
    80006274:	70a2                	ld	ra,40(sp)
    80006276:	7402                	ld	s0,32(sp)
    80006278:	64e2                	ld	s1,24(sp)
    8000627a:	6942                	ld	s2,16(sp)
    8000627c:	6145                	addi	sp,sp,48
    8000627e:	8082                	ret
    x = -xx;
    80006280:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006284:	4885                	li	a7,1
    x = -xx;
    80006286:	bf9d                	j	800061fc <printint+0x16>

0000000080006288 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006288:	1101                	addi	sp,sp,-32
    8000628a:	ec06                	sd	ra,24(sp)
    8000628c:	e822                	sd	s0,16(sp)
    8000628e:	e426                	sd	s1,8(sp)
    80006290:	1000                	addi	s0,sp,32
    80006292:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006294:	00028797          	auipc	a5,0x28
    80006298:	f607a623          	sw	zero,-148(a5) # 8002e200 <pr+0x18>
  printf("panic: ");
    8000629c:	00002517          	auipc	a0,0x2
    800062a0:	4e450513          	addi	a0,a0,1252 # 80008780 <syscalls+0x3f0>
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	02e080e7          	jalr	46(ra) # 800062d2 <printf>
  printf(s);
    800062ac:	8526                	mv	a0,s1
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	024080e7          	jalr	36(ra) # 800062d2 <printf>
  printf("\n");
    800062b6:	00002517          	auipc	a0,0x2
    800062ba:	d9250513          	addi	a0,a0,-622 # 80008048 <etext+0x48>
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	014080e7          	jalr	20(ra) # 800062d2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062c6:	4785                	li	a5,1
    800062c8:	00003717          	auipc	a4,0x3
    800062cc:	d4f72a23          	sw	a5,-684(a4) # 8000901c <panicked>
  for(;;)
    800062d0:	a001                	j	800062d0 <panic+0x48>

00000000800062d2 <printf>:
{
    800062d2:	7131                	addi	sp,sp,-192
    800062d4:	fc86                	sd	ra,120(sp)
    800062d6:	f8a2                	sd	s0,112(sp)
    800062d8:	f4a6                	sd	s1,104(sp)
    800062da:	f0ca                	sd	s2,96(sp)
    800062dc:	ecce                	sd	s3,88(sp)
    800062de:	e8d2                	sd	s4,80(sp)
    800062e0:	e4d6                	sd	s5,72(sp)
    800062e2:	e0da                	sd	s6,64(sp)
    800062e4:	fc5e                	sd	s7,56(sp)
    800062e6:	f862                	sd	s8,48(sp)
    800062e8:	f466                	sd	s9,40(sp)
    800062ea:	f06a                	sd	s10,32(sp)
    800062ec:	ec6e                	sd	s11,24(sp)
    800062ee:	0100                	addi	s0,sp,128
    800062f0:	8a2a                	mv	s4,a0
    800062f2:	e40c                	sd	a1,8(s0)
    800062f4:	e810                	sd	a2,16(s0)
    800062f6:	ec14                	sd	a3,24(s0)
    800062f8:	f018                	sd	a4,32(s0)
    800062fa:	f41c                	sd	a5,40(s0)
    800062fc:	03043823          	sd	a6,48(s0)
    80006300:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006304:	00028d97          	auipc	s11,0x28
    80006308:	efcdad83          	lw	s11,-260(s11) # 8002e200 <pr+0x18>
  if(locking)
    8000630c:	020d9b63          	bnez	s11,80006342 <printf+0x70>
  if (fmt == 0)
    80006310:	040a0263          	beqz	s4,80006354 <printf+0x82>
  va_start(ap, fmt);
    80006314:	00840793          	addi	a5,s0,8
    80006318:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000631c:	000a4503          	lbu	a0,0(s4)
    80006320:	16050263          	beqz	a0,80006484 <printf+0x1b2>
    80006324:	4481                	li	s1,0
    if(c != '%'){
    80006326:	02500a93          	li	s5,37
    switch(c){
    8000632a:	07000b13          	li	s6,112
  consputc('x');
    8000632e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006330:	00002b97          	auipc	s7,0x2
    80006334:	478b8b93          	addi	s7,s7,1144 # 800087a8 <digits>
    switch(c){
    80006338:	07300c93          	li	s9,115
    8000633c:	06400c13          	li	s8,100
    80006340:	a82d                	j	8000637a <printf+0xa8>
    acquire(&pr.lock);
    80006342:	00028517          	auipc	a0,0x28
    80006346:	ea650513          	addi	a0,a0,-346 # 8002e1e8 <pr>
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	488080e7          	jalr	1160(ra) # 800067d2 <acquire>
    80006352:	bf7d                	j	80006310 <printf+0x3e>
    panic("null fmt");
    80006354:	00002517          	auipc	a0,0x2
    80006358:	43c50513          	addi	a0,a0,1084 # 80008790 <syscalls+0x400>
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	f2c080e7          	jalr	-212(ra) # 80006288 <panic>
      consputc(c);
    80006364:	00000097          	auipc	ra,0x0
    80006368:	c62080e7          	jalr	-926(ra) # 80005fc6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000636c:	2485                	addiw	s1,s1,1
    8000636e:	009a07b3          	add	a5,s4,s1
    80006372:	0007c503          	lbu	a0,0(a5)
    80006376:	10050763          	beqz	a0,80006484 <printf+0x1b2>
    if(c != '%'){
    8000637a:	ff5515e3          	bne	a0,s5,80006364 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000637e:	2485                	addiw	s1,s1,1
    80006380:	009a07b3          	add	a5,s4,s1
    80006384:	0007c783          	lbu	a5,0(a5)
    80006388:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000638c:	cfe5                	beqz	a5,80006484 <printf+0x1b2>
    switch(c){
    8000638e:	05678a63          	beq	a5,s6,800063e2 <printf+0x110>
    80006392:	02fb7663          	bgeu	s6,a5,800063be <printf+0xec>
    80006396:	09978963          	beq	a5,s9,80006428 <printf+0x156>
    8000639a:	07800713          	li	a4,120
    8000639e:	0ce79863          	bne	a5,a4,8000646e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800063a2:	f8843783          	ld	a5,-120(s0)
    800063a6:	00878713          	addi	a4,a5,8
    800063aa:	f8e43423          	sd	a4,-120(s0)
    800063ae:	4605                	li	a2,1
    800063b0:	85ea                	mv	a1,s10
    800063b2:	4388                	lw	a0,0(a5)
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	e32080e7          	jalr	-462(ra) # 800061e6 <printint>
      break;
    800063bc:	bf45                	j	8000636c <printf+0x9a>
    switch(c){
    800063be:	0b578263          	beq	a5,s5,80006462 <printf+0x190>
    800063c2:	0b879663          	bne	a5,s8,8000646e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800063c6:	f8843783          	ld	a5,-120(s0)
    800063ca:	00878713          	addi	a4,a5,8
    800063ce:	f8e43423          	sd	a4,-120(s0)
    800063d2:	4605                	li	a2,1
    800063d4:	45a9                	li	a1,10
    800063d6:	4388                	lw	a0,0(a5)
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	e0e080e7          	jalr	-498(ra) # 800061e6 <printint>
      break;
    800063e0:	b771                	j	8000636c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800063e2:	f8843783          	ld	a5,-120(s0)
    800063e6:	00878713          	addi	a4,a5,8
    800063ea:	f8e43423          	sd	a4,-120(s0)
    800063ee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800063f2:	03000513          	li	a0,48
    800063f6:	00000097          	auipc	ra,0x0
    800063fa:	bd0080e7          	jalr	-1072(ra) # 80005fc6 <consputc>
  consputc('x');
    800063fe:	07800513          	li	a0,120
    80006402:	00000097          	auipc	ra,0x0
    80006406:	bc4080e7          	jalr	-1084(ra) # 80005fc6 <consputc>
    8000640a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000640c:	03c9d793          	srli	a5,s3,0x3c
    80006410:	97de                	add	a5,a5,s7
    80006412:	0007c503          	lbu	a0,0(a5)
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	bb0080e7          	jalr	-1104(ra) # 80005fc6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000641e:	0992                	slli	s3,s3,0x4
    80006420:	397d                	addiw	s2,s2,-1
    80006422:	fe0915e3          	bnez	s2,8000640c <printf+0x13a>
    80006426:	b799                	j	8000636c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006428:	f8843783          	ld	a5,-120(s0)
    8000642c:	00878713          	addi	a4,a5,8
    80006430:	f8e43423          	sd	a4,-120(s0)
    80006434:	0007b903          	ld	s2,0(a5)
    80006438:	00090e63          	beqz	s2,80006454 <printf+0x182>
      for(; *s; s++)
    8000643c:	00094503          	lbu	a0,0(s2)
    80006440:	d515                	beqz	a0,8000636c <printf+0x9a>
        consputc(*s);
    80006442:	00000097          	auipc	ra,0x0
    80006446:	b84080e7          	jalr	-1148(ra) # 80005fc6 <consputc>
      for(; *s; s++)
    8000644a:	0905                	addi	s2,s2,1
    8000644c:	00094503          	lbu	a0,0(s2)
    80006450:	f96d                	bnez	a0,80006442 <printf+0x170>
    80006452:	bf29                	j	8000636c <printf+0x9a>
        s = "(null)";
    80006454:	00002917          	auipc	s2,0x2
    80006458:	33490913          	addi	s2,s2,820 # 80008788 <syscalls+0x3f8>
      for(; *s; s++)
    8000645c:	02800513          	li	a0,40
    80006460:	b7cd                	j	80006442 <printf+0x170>
      consputc('%');
    80006462:	8556                	mv	a0,s5
    80006464:	00000097          	auipc	ra,0x0
    80006468:	b62080e7          	jalr	-1182(ra) # 80005fc6 <consputc>
      break;
    8000646c:	b701                	j	8000636c <printf+0x9a>
      consputc('%');
    8000646e:	8556                	mv	a0,s5
    80006470:	00000097          	auipc	ra,0x0
    80006474:	b56080e7          	jalr	-1194(ra) # 80005fc6 <consputc>
      consputc(c);
    80006478:	854a                	mv	a0,s2
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	b4c080e7          	jalr	-1204(ra) # 80005fc6 <consputc>
      break;
    80006482:	b5ed                	j	8000636c <printf+0x9a>
  if(locking)
    80006484:	020d9163          	bnez	s11,800064a6 <printf+0x1d4>
}
    80006488:	70e6                	ld	ra,120(sp)
    8000648a:	7446                	ld	s0,112(sp)
    8000648c:	74a6                	ld	s1,104(sp)
    8000648e:	7906                	ld	s2,96(sp)
    80006490:	69e6                	ld	s3,88(sp)
    80006492:	6a46                	ld	s4,80(sp)
    80006494:	6aa6                	ld	s5,72(sp)
    80006496:	6b06                	ld	s6,64(sp)
    80006498:	7be2                	ld	s7,56(sp)
    8000649a:	7c42                	ld	s8,48(sp)
    8000649c:	7ca2                	ld	s9,40(sp)
    8000649e:	7d02                	ld	s10,32(sp)
    800064a0:	6de2                	ld	s11,24(sp)
    800064a2:	6129                	addi	sp,sp,192
    800064a4:	8082                	ret
    release(&pr.lock);
    800064a6:	00028517          	auipc	a0,0x28
    800064aa:	d4250513          	addi	a0,a0,-702 # 8002e1e8 <pr>
    800064ae:	00000097          	auipc	ra,0x0
    800064b2:	3d8080e7          	jalr	984(ra) # 80006886 <release>
}
    800064b6:	bfc9                	j	80006488 <printf+0x1b6>

00000000800064b8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800064b8:	1101                	addi	sp,sp,-32
    800064ba:	ec06                	sd	ra,24(sp)
    800064bc:	e822                	sd	s0,16(sp)
    800064be:	e426                	sd	s1,8(sp)
    800064c0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064c2:	00028497          	auipc	s1,0x28
    800064c6:	d2648493          	addi	s1,s1,-730 # 8002e1e8 <pr>
    800064ca:	00002597          	auipc	a1,0x2
    800064ce:	2d658593          	addi	a1,a1,726 # 800087a0 <syscalls+0x410>
    800064d2:	8526                	mv	a0,s1
    800064d4:	00000097          	auipc	ra,0x0
    800064d8:	26e080e7          	jalr	622(ra) # 80006742 <initlock>
  pr.locking = 1;
    800064dc:	4785                	li	a5,1
    800064de:	cc9c                	sw	a5,24(s1)
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret

00000000800064ea <uartinit>:

void uartstart();

void
uartinit(void)
{
    800064ea:	1141                	addi	sp,sp,-16
    800064ec:	e406                	sd	ra,8(sp)
    800064ee:	e022                	sd	s0,0(sp)
    800064f0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800064f2:	100007b7          	lui	a5,0x10000
    800064f6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800064fa:	f8000713          	li	a4,-128
    800064fe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006502:	470d                	li	a4,3
    80006504:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006508:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000650c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006510:	469d                	li	a3,7
    80006512:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006516:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000651a:	00002597          	auipc	a1,0x2
    8000651e:	2a658593          	addi	a1,a1,678 # 800087c0 <digits+0x18>
    80006522:	00028517          	auipc	a0,0x28
    80006526:	ce650513          	addi	a0,a0,-794 # 8002e208 <uart_tx_lock>
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	218080e7          	jalr	536(ra) # 80006742 <initlock>
}
    80006532:	60a2                	ld	ra,8(sp)
    80006534:	6402                	ld	s0,0(sp)
    80006536:	0141                	addi	sp,sp,16
    80006538:	8082                	ret

000000008000653a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000653a:	1101                	addi	sp,sp,-32
    8000653c:	ec06                	sd	ra,24(sp)
    8000653e:	e822                	sd	s0,16(sp)
    80006540:	e426                	sd	s1,8(sp)
    80006542:	1000                	addi	s0,sp,32
    80006544:	84aa                	mv	s1,a0
  push_off();
    80006546:	00000097          	auipc	ra,0x0
    8000654a:	240080e7          	jalr	576(ra) # 80006786 <push_off>

  if(panicked){
    8000654e:	00003797          	auipc	a5,0x3
    80006552:	ace7a783          	lw	a5,-1330(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006556:	10000737          	lui	a4,0x10000
  if(panicked){
    8000655a:	c391                	beqz	a5,8000655e <uartputc_sync+0x24>
    for(;;)
    8000655c:	a001                	j	8000655c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000655e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006562:	0ff7f793          	andi	a5,a5,255
    80006566:	0207f793          	andi	a5,a5,32
    8000656a:	dbf5                	beqz	a5,8000655e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000656c:	0ff4f793          	andi	a5,s1,255
    80006570:	10000737          	lui	a4,0x10000
    80006574:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006578:	00000097          	auipc	ra,0x0
    8000657c:	2ae080e7          	jalr	686(ra) # 80006826 <pop_off>
}
    80006580:	60e2                	ld	ra,24(sp)
    80006582:	6442                	ld	s0,16(sp)
    80006584:	64a2                	ld	s1,8(sp)
    80006586:	6105                	addi	sp,sp,32
    80006588:	8082                	ret

000000008000658a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000658a:	00003717          	auipc	a4,0x3
    8000658e:	a9673703          	ld	a4,-1386(a4) # 80009020 <uart_tx_r>
    80006592:	00003797          	auipc	a5,0x3
    80006596:	a967b783          	ld	a5,-1386(a5) # 80009028 <uart_tx_w>
    8000659a:	06e78c63          	beq	a5,a4,80006612 <uartstart+0x88>
{
    8000659e:	7139                	addi	sp,sp,-64
    800065a0:	fc06                	sd	ra,56(sp)
    800065a2:	f822                	sd	s0,48(sp)
    800065a4:	f426                	sd	s1,40(sp)
    800065a6:	f04a                	sd	s2,32(sp)
    800065a8:	ec4e                	sd	s3,24(sp)
    800065aa:	e852                	sd	s4,16(sp)
    800065ac:	e456                	sd	s5,8(sp)
    800065ae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065b0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065b4:	00028a17          	auipc	s4,0x28
    800065b8:	c54a0a13          	addi	s4,s4,-940 # 8002e208 <uart_tx_lock>
    uart_tx_r += 1;
    800065bc:	00003497          	auipc	s1,0x3
    800065c0:	a6448493          	addi	s1,s1,-1436 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800065c4:	00003997          	auipc	s3,0x3
    800065c8:	a6498993          	addi	s3,s3,-1436 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065cc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800065d0:	0ff7f793          	andi	a5,a5,255
    800065d4:	0207f793          	andi	a5,a5,32
    800065d8:	c785                	beqz	a5,80006600 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065da:	01f77793          	andi	a5,a4,31
    800065de:	97d2                	add	a5,a5,s4
    800065e0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800065e4:	0705                	addi	a4,a4,1
    800065e6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800065e8:	8526                	mv	a0,s1
    800065ea:	ffffb097          	auipc	ra,0xffffb
    800065ee:	0c0080e7          	jalr	192(ra) # 800016aa <wakeup>
    
    WriteReg(THR, c);
    800065f2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800065f6:	6098                	ld	a4,0(s1)
    800065f8:	0009b783          	ld	a5,0(s3)
    800065fc:	fce798e3          	bne	a5,a4,800065cc <uartstart+0x42>
  }
}
    80006600:	70e2                	ld	ra,56(sp)
    80006602:	7442                	ld	s0,48(sp)
    80006604:	74a2                	ld	s1,40(sp)
    80006606:	7902                	ld	s2,32(sp)
    80006608:	69e2                	ld	s3,24(sp)
    8000660a:	6a42                	ld	s4,16(sp)
    8000660c:	6aa2                	ld	s5,8(sp)
    8000660e:	6121                	addi	sp,sp,64
    80006610:	8082                	ret
    80006612:	8082                	ret

0000000080006614 <uartputc>:
{
    80006614:	7179                	addi	sp,sp,-48
    80006616:	f406                	sd	ra,40(sp)
    80006618:	f022                	sd	s0,32(sp)
    8000661a:	ec26                	sd	s1,24(sp)
    8000661c:	e84a                	sd	s2,16(sp)
    8000661e:	e44e                	sd	s3,8(sp)
    80006620:	e052                	sd	s4,0(sp)
    80006622:	1800                	addi	s0,sp,48
    80006624:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006626:	00028517          	auipc	a0,0x28
    8000662a:	be250513          	addi	a0,a0,-1054 # 8002e208 <uart_tx_lock>
    8000662e:	00000097          	auipc	ra,0x0
    80006632:	1a4080e7          	jalr	420(ra) # 800067d2 <acquire>
  if(panicked){
    80006636:	00003797          	auipc	a5,0x3
    8000663a:	9e67a783          	lw	a5,-1562(a5) # 8000901c <panicked>
    8000663e:	c391                	beqz	a5,80006642 <uartputc+0x2e>
    for(;;)
    80006640:	a001                	j	80006640 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006642:	00003797          	auipc	a5,0x3
    80006646:	9e67b783          	ld	a5,-1562(a5) # 80009028 <uart_tx_w>
    8000664a:	00003717          	auipc	a4,0x3
    8000664e:	9d673703          	ld	a4,-1578(a4) # 80009020 <uart_tx_r>
    80006652:	02070713          	addi	a4,a4,32
    80006656:	02f71b63          	bne	a4,a5,8000668c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000665a:	00028a17          	auipc	s4,0x28
    8000665e:	baea0a13          	addi	s4,s4,-1106 # 8002e208 <uart_tx_lock>
    80006662:	00003497          	auipc	s1,0x3
    80006666:	9be48493          	addi	s1,s1,-1602 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000666a:	00003917          	auipc	s2,0x3
    8000666e:	9be90913          	addi	s2,s2,-1602 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006672:	85d2                	mv	a1,s4
    80006674:	8526                	mv	a0,s1
    80006676:	ffffb097          	auipc	ra,0xffffb
    8000667a:	ea8080e7          	jalr	-344(ra) # 8000151e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000667e:	00093783          	ld	a5,0(s2)
    80006682:	6098                	ld	a4,0(s1)
    80006684:	02070713          	addi	a4,a4,32
    80006688:	fef705e3          	beq	a4,a5,80006672 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000668c:	00028497          	auipc	s1,0x28
    80006690:	b7c48493          	addi	s1,s1,-1156 # 8002e208 <uart_tx_lock>
    80006694:	01f7f713          	andi	a4,a5,31
    80006698:	9726                	add	a4,a4,s1
    8000669a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000669e:	0785                	addi	a5,a5,1
    800066a0:	00003717          	auipc	a4,0x3
    800066a4:	98f73423          	sd	a5,-1656(a4) # 80009028 <uart_tx_w>
      uartstart();
    800066a8:	00000097          	auipc	ra,0x0
    800066ac:	ee2080e7          	jalr	-286(ra) # 8000658a <uartstart>
      release(&uart_tx_lock);
    800066b0:	8526                	mv	a0,s1
    800066b2:	00000097          	auipc	ra,0x0
    800066b6:	1d4080e7          	jalr	468(ra) # 80006886 <release>
}
    800066ba:	70a2                	ld	ra,40(sp)
    800066bc:	7402                	ld	s0,32(sp)
    800066be:	64e2                	ld	s1,24(sp)
    800066c0:	6942                	ld	s2,16(sp)
    800066c2:	69a2                	ld	s3,8(sp)
    800066c4:	6a02                	ld	s4,0(sp)
    800066c6:	6145                	addi	sp,sp,48
    800066c8:	8082                	ret

00000000800066ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800066ca:	1141                	addi	sp,sp,-16
    800066cc:	e422                	sd	s0,8(sp)
    800066ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800066d0:	100007b7          	lui	a5,0x10000
    800066d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800066d8:	8b85                	andi	a5,a5,1
    800066da:	cb91                	beqz	a5,800066ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800066dc:	100007b7          	lui	a5,0x10000
    800066e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800066e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800066e8:	6422                	ld	s0,8(sp)
    800066ea:	0141                	addi	sp,sp,16
    800066ec:	8082                	ret
    return -1;
    800066ee:	557d                	li	a0,-1
    800066f0:	bfe5                	j	800066e8 <uartgetc+0x1e>

00000000800066f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800066f2:	1101                	addi	sp,sp,-32
    800066f4:	ec06                	sd	ra,24(sp)
    800066f6:	e822                	sd	s0,16(sp)
    800066f8:	e426                	sd	s1,8(sp)
    800066fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800066fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	fcc080e7          	jalr	-52(ra) # 800066ca <uartgetc>
    if(c == -1)
    80006706:	00950763          	beq	a0,s1,80006714 <uartintr+0x22>
      break;
    consoleintr(c);
    8000670a:	00000097          	auipc	ra,0x0
    8000670e:	8fe080e7          	jalr	-1794(ra) # 80006008 <consoleintr>
  while(1){
    80006712:	b7f5                	j	800066fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006714:	00028497          	auipc	s1,0x28
    80006718:	af448493          	addi	s1,s1,-1292 # 8002e208 <uart_tx_lock>
    8000671c:	8526                	mv	a0,s1
    8000671e:	00000097          	auipc	ra,0x0
    80006722:	0b4080e7          	jalr	180(ra) # 800067d2 <acquire>
  uartstart();
    80006726:	00000097          	auipc	ra,0x0
    8000672a:	e64080e7          	jalr	-412(ra) # 8000658a <uartstart>
  release(&uart_tx_lock);
    8000672e:	8526                	mv	a0,s1
    80006730:	00000097          	auipc	ra,0x0
    80006734:	156080e7          	jalr	342(ra) # 80006886 <release>
}
    80006738:	60e2                	ld	ra,24(sp)
    8000673a:	6442                	ld	s0,16(sp)
    8000673c:	64a2                	ld	s1,8(sp)
    8000673e:	6105                	addi	sp,sp,32
    80006740:	8082                	ret

0000000080006742 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006742:	1141                	addi	sp,sp,-16
    80006744:	e422                	sd	s0,8(sp)
    80006746:	0800                	addi	s0,sp,16
  lk->name = name;
    80006748:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000674a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000674e:	00053823          	sd	zero,16(a0)
}
    80006752:	6422                	ld	s0,8(sp)
    80006754:	0141                	addi	sp,sp,16
    80006756:	8082                	ret

0000000080006758 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006758:	411c                	lw	a5,0(a0)
    8000675a:	e399                	bnez	a5,80006760 <holding+0x8>
    8000675c:	4501                	li	a0,0
  return r;
}
    8000675e:	8082                	ret
{
    80006760:	1101                	addi	sp,sp,-32
    80006762:	ec06                	sd	ra,24(sp)
    80006764:	e822                	sd	s0,16(sp)
    80006766:	e426                	sd	s1,8(sp)
    80006768:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000676a:	6904                	ld	s1,16(a0)
    8000676c:	ffffa097          	auipc	ra,0xffffa
    80006770:	696080e7          	jalr	1686(ra) # 80000e02 <mycpu>
    80006774:	40a48533          	sub	a0,s1,a0
    80006778:	00153513          	seqz	a0,a0
}
    8000677c:	60e2                	ld	ra,24(sp)
    8000677e:	6442                	ld	s0,16(sp)
    80006780:	64a2                	ld	s1,8(sp)
    80006782:	6105                	addi	sp,sp,32
    80006784:	8082                	ret

0000000080006786 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006786:	1101                	addi	sp,sp,-32
    80006788:	ec06                	sd	ra,24(sp)
    8000678a:	e822                	sd	s0,16(sp)
    8000678c:	e426                	sd	s1,8(sp)
    8000678e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006790:	100024f3          	csrr	s1,sstatus
    80006794:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006798:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000679a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000679e:	ffffa097          	auipc	ra,0xffffa
    800067a2:	664080e7          	jalr	1636(ra) # 80000e02 <mycpu>
    800067a6:	5d3c                	lw	a5,120(a0)
    800067a8:	cf89                	beqz	a5,800067c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800067aa:	ffffa097          	auipc	ra,0xffffa
    800067ae:	658080e7          	jalr	1624(ra) # 80000e02 <mycpu>
    800067b2:	5d3c                	lw	a5,120(a0)
    800067b4:	2785                	addiw	a5,a5,1
    800067b6:	dd3c                	sw	a5,120(a0)
}
    800067b8:	60e2                	ld	ra,24(sp)
    800067ba:	6442                	ld	s0,16(sp)
    800067bc:	64a2                	ld	s1,8(sp)
    800067be:	6105                	addi	sp,sp,32
    800067c0:	8082                	ret
    mycpu()->intena = old;
    800067c2:	ffffa097          	auipc	ra,0xffffa
    800067c6:	640080e7          	jalr	1600(ra) # 80000e02 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800067ca:	8085                	srli	s1,s1,0x1
    800067cc:	8885                	andi	s1,s1,1
    800067ce:	dd64                	sw	s1,124(a0)
    800067d0:	bfe9                	j	800067aa <push_off+0x24>

00000000800067d2 <acquire>:
{
    800067d2:	1101                	addi	sp,sp,-32
    800067d4:	ec06                	sd	ra,24(sp)
    800067d6:	e822                	sd	s0,16(sp)
    800067d8:	e426                	sd	s1,8(sp)
    800067da:	1000                	addi	s0,sp,32
    800067dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800067de:	00000097          	auipc	ra,0x0
    800067e2:	fa8080e7          	jalr	-88(ra) # 80006786 <push_off>
  if(holding(lk))
    800067e6:	8526                	mv	a0,s1
    800067e8:	00000097          	auipc	ra,0x0
    800067ec:	f70080e7          	jalr	-144(ra) # 80006758 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800067f0:	4705                	li	a4,1
  if(holding(lk))
    800067f2:	e115                	bnez	a0,80006816 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800067f4:	87ba                	mv	a5,a4
    800067f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800067fa:	2781                	sext.w	a5,a5
    800067fc:	ffe5                	bnez	a5,800067f4 <acquire+0x22>
  __sync_synchronize();
    800067fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006802:	ffffa097          	auipc	ra,0xffffa
    80006806:	600080e7          	jalr	1536(ra) # 80000e02 <mycpu>
    8000680a:	e888                	sd	a0,16(s1)
}
    8000680c:	60e2                	ld	ra,24(sp)
    8000680e:	6442                	ld	s0,16(sp)
    80006810:	64a2                	ld	s1,8(sp)
    80006812:	6105                	addi	sp,sp,32
    80006814:	8082                	ret
    panic("acquire");
    80006816:	00002517          	auipc	a0,0x2
    8000681a:	fb250513          	addi	a0,a0,-78 # 800087c8 <digits+0x20>
    8000681e:	00000097          	auipc	ra,0x0
    80006822:	a6a080e7          	jalr	-1430(ra) # 80006288 <panic>

0000000080006826 <pop_off>:

void
pop_off(void)
{
    80006826:	1141                	addi	sp,sp,-16
    80006828:	e406                	sd	ra,8(sp)
    8000682a:	e022                	sd	s0,0(sp)
    8000682c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000682e:	ffffa097          	auipc	ra,0xffffa
    80006832:	5d4080e7          	jalr	1492(ra) # 80000e02 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006836:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000683a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000683c:	e78d                	bnez	a5,80006866 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000683e:	5d3c                	lw	a5,120(a0)
    80006840:	02f05b63          	blez	a5,80006876 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006844:	37fd                	addiw	a5,a5,-1
    80006846:	0007871b          	sext.w	a4,a5
    8000684a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000684c:	eb09                	bnez	a4,8000685e <pop_off+0x38>
    8000684e:	5d7c                	lw	a5,124(a0)
    80006850:	c799                	beqz	a5,8000685e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006852:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006856:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000685a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000685e:	60a2                	ld	ra,8(sp)
    80006860:	6402                	ld	s0,0(sp)
    80006862:	0141                	addi	sp,sp,16
    80006864:	8082                	ret
    panic("pop_off - interruptible");
    80006866:	00002517          	auipc	a0,0x2
    8000686a:	f6a50513          	addi	a0,a0,-150 # 800087d0 <digits+0x28>
    8000686e:	00000097          	auipc	ra,0x0
    80006872:	a1a080e7          	jalr	-1510(ra) # 80006288 <panic>
    panic("pop_off");
    80006876:	00002517          	auipc	a0,0x2
    8000687a:	f7250513          	addi	a0,a0,-142 # 800087e8 <digits+0x40>
    8000687e:	00000097          	auipc	ra,0x0
    80006882:	a0a080e7          	jalr	-1526(ra) # 80006288 <panic>

0000000080006886 <release>:
{
    80006886:	1101                	addi	sp,sp,-32
    80006888:	ec06                	sd	ra,24(sp)
    8000688a:	e822                	sd	s0,16(sp)
    8000688c:	e426                	sd	s1,8(sp)
    8000688e:	1000                	addi	s0,sp,32
    80006890:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006892:	00000097          	auipc	ra,0x0
    80006896:	ec6080e7          	jalr	-314(ra) # 80006758 <holding>
    8000689a:	c115                	beqz	a0,800068be <release+0x38>
  lk->cpu = 0;
    8000689c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800068a4:	0f50000f          	fence	iorw,ow
    800068a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800068ac:	00000097          	auipc	ra,0x0
    800068b0:	f7a080e7          	jalr	-134(ra) # 80006826 <pop_off>
}
    800068b4:	60e2                	ld	ra,24(sp)
    800068b6:	6442                	ld	s0,16(sp)
    800068b8:	64a2                	ld	s1,8(sp)
    800068ba:	6105                	addi	sp,sp,32
    800068bc:	8082                	ret
    panic("release");
    800068be:	00002517          	auipc	a0,0x2
    800068c2:	f3250513          	addi	a0,a0,-206 # 800087f0 <digits+0x48>
    800068c6:	00000097          	auipc	ra,0x0
    800068ca:	9c2080e7          	jalr	-1598(ra) # 80006288 <panic>
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
