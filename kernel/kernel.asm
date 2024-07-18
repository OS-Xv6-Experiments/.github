
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5d3050ef          	jal	ra,80005de8 <start>

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
    8000005e:	788080e7          	jalr	1928(ra) # 800067e2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	828080e7          	jalr	-2008(ra) # 80006896 <release>
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
    8000008e:	20e080e7          	jalr	526(ra) # 80006298 <panic>

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
    800000f8:	65e080e7          	jalr	1630(ra) # 80006752 <initlock>
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
    80000130:	6b6080e7          	jalr	1718(ra) # 800067e2 <acquire>
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
    80000148:	752080e7          	jalr	1874(ra) # 80006896 <release>

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
    80000172:	728080e7          	jalr	1832(ra) # 80006896 <release>
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
    80000332:	ad0080e7          	jalr	-1328(ra) # 80000dfe <cpuid>
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
    8000034e:	ab4080e7          	jalr	-1356(ra) # 80000dfe <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	f86080e7          	jalr	-122(ra) # 800062e2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	902080e7          	jalr	-1790(ra) # 80001c6e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	3fc080e7          	jalr	1020(ra) # 80005770 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	ffc080e7          	jalr	-4(ra) # 80001378 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	e26080e7          	jalr	-474(ra) # 800061aa <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	13c080e7          	jalr	316(ra) # 800064c8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	f46080e7          	jalr	-186(ra) # 800062e2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	f36080e7          	jalr	-202(ra) # 800062e2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	f26080e7          	jalr	-218(ra) # 800062e2 <printf>
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
    800003e0:	972080e7          	jalr	-1678(ra) # 80000d4e <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	862080e7          	jalr	-1950(ra) # 80001c46 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	882080e7          	jalr	-1918(ra) # 80001c6e <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	366080e7          	jalr	870(ra) # 8000575a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	374080e7          	jalr	884(ra) # 80005770 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	116080e7          	jalr	278(ra) # 8000251a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	7a6080e7          	jalr	1958(ra) # 80002bb2 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	750080e7          	jalr	1872(ra) # 80003b64 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	476080e7          	jalr	1142(ra) # 80005892 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cde080e7          	jalr	-802(ra) # 80001102 <userinit>
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
    80000492:	e0a080e7          	jalr	-502(ra) # 80006298 <panic>
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
    8000058a:	d12080e7          	jalr	-750(ra) # 80006298 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	d02080e7          	jalr	-766(ra) # 80006298 <panic>
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
    80000614:	c88080e7          	jalr	-888(ra) # 80006298 <panic>

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
    800006dc:	5e0080e7          	jalr	1504(ra) # 80000cb8 <proc_mapstacks>
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
    80000760:	b3c080e7          	jalr	-1220(ra) # 80006298 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	b2c080e7          	jalr	-1236(ra) # 80006298 <panic>
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
    80000850:	a4c080e7          	jalr	-1460(ra) # 80006298 <panic>

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
    80000992:	90a080e7          	jalr	-1782(ra) # 80006298 <panic>
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
    800009e8:	c679                	beqz	a2,80000ab6 <uvmcopy+0xce>
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
    80000a00:	8b2a                	mv	s6,a0
    80000a02:	8aae                	mv	s5,a1
    80000a04:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a08:	4601                	li	a2,0
    80000a0a:	85ce                	mv	a1,s3
    80000a0c:	855a                	mv	a0,s6
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	a52080e7          	jalr	-1454(ra) # 80000460 <walk>
    80000a16:	c531                	beqz	a0,80000a62 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a18:	6118                	ld	a4,0(a0)
    80000a1a:	00177793          	andi	a5,a4,1
    80000a1e:	cbb1                	beqz	a5,80000a72 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a20:	00a75593          	srli	a1,a4,0xa
    80000a24:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a28:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a2c:	fffff097          	auipc	ra,0xfffff
    80000a30:	6ec080e7          	jalr	1772(ra) # 80000118 <kalloc>
    80000a34:	892a                	mv	s2,a0
    80000a36:	c939                	beqz	a0,80000a8c <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a38:	6605                	lui	a2,0x1
    80000a3a:	85de                	mv	a1,s7
    80000a3c:	fffff097          	auipc	ra,0xfffff
    80000a40:	79c080e7          	jalr	1948(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a44:	8726                	mv	a4,s1
    80000a46:	86ca                	mv	a3,s2
    80000a48:	6605                	lui	a2,0x1
    80000a4a:	85ce                	mv	a1,s3
    80000a4c:	8556                	mv	a0,s5
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	afa080e7          	jalr	-1286(ra) # 80000548 <mappages>
    80000a56:	e515                	bnez	a0,80000a82 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a58:	6785                	lui	a5,0x1
    80000a5a:	99be                	add	s3,s3,a5
    80000a5c:	fb49e6e3          	bltu	s3,s4,80000a08 <uvmcopy+0x20>
    80000a60:	a081                	j	80000aa0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a62:	00007517          	auipc	a0,0x7
    80000a66:	67650513          	addi	a0,a0,1654 # 800080d8 <etext+0xd8>
    80000a6a:	00006097          	auipc	ra,0x6
    80000a6e:	82e080e7          	jalr	-2002(ra) # 80006298 <panic>
      panic("uvmcopy: page not present");
    80000a72:	00007517          	auipc	a0,0x7
    80000a76:	68650513          	addi	a0,a0,1670 # 800080f8 <etext+0xf8>
    80000a7a:	00006097          	auipc	ra,0x6
    80000a7e:	81e080e7          	jalr	-2018(ra) # 80006298 <panic>
      kfree(mem);
    80000a82:	854a                	mv	a0,s2
    80000a84:	fffff097          	auipc	ra,0xfffff
    80000a88:	598080e7          	jalr	1432(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8c:	4685                	li	a3,1
    80000a8e:	00c9d613          	srli	a2,s3,0xc
    80000a92:	4581                	li	a1,0
    80000a94:	8556                	mv	a0,s5
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	c78080e7          	jalr	-904(ra) # 8000070e <uvmunmap>
  return -1;
    80000a9e:	557d                	li	a0,-1
}
    80000aa0:	60a6                	ld	ra,72(sp)
    80000aa2:	6406                	ld	s0,64(sp)
    80000aa4:	74e2                	ld	s1,56(sp)
    80000aa6:	7942                	ld	s2,48(sp)
    80000aa8:	79a2                	ld	s3,40(sp)
    80000aaa:	7a02                	ld	s4,32(sp)
    80000aac:	6ae2                	ld	s5,24(sp)
    80000aae:	6b42                	ld	s6,16(sp)
    80000ab0:	6ba2                	ld	s7,8(sp)
    80000ab2:	6161                	addi	sp,sp,80
    80000ab4:	8082                	ret
  return 0;
    80000ab6:	4501                	li	a0,0
}
    80000ab8:	8082                	ret

0000000080000aba <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aba:	1141                	addi	sp,sp,-16
    80000abc:	e406                	sd	ra,8(sp)
    80000abe:	e022                	sd	s0,0(sp)
    80000ac0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ac2:	4601                	li	a2,0
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	99c080e7          	jalr	-1636(ra) # 80000460 <walk>
  if(pte == 0)
    80000acc:	c901                	beqz	a0,80000adc <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ace:	611c                	ld	a5,0(a0)
    80000ad0:	9bbd                	andi	a5,a5,-17
    80000ad2:	e11c                	sd	a5,0(a0)
}
    80000ad4:	60a2                	ld	ra,8(sp)
    80000ad6:	6402                	ld	s0,0(sp)
    80000ad8:	0141                	addi	sp,sp,16
    80000ada:	8082                	ret
    panic("uvmclear");
    80000adc:	00007517          	auipc	a0,0x7
    80000ae0:	63c50513          	addi	a0,a0,1596 # 80008118 <etext+0x118>
    80000ae4:	00005097          	auipc	ra,0x5
    80000ae8:	7b4080e7          	jalr	1972(ra) # 80006298 <panic>

0000000080000aec <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000aec:	c6bd                	beqz	a3,80000b5a <copyout+0x6e>
{
    80000aee:	715d                	addi	sp,sp,-80
    80000af0:	e486                	sd	ra,72(sp)
    80000af2:	e0a2                	sd	s0,64(sp)
    80000af4:	fc26                	sd	s1,56(sp)
    80000af6:	f84a                	sd	s2,48(sp)
    80000af8:	f44e                	sd	s3,40(sp)
    80000afa:	f052                	sd	s4,32(sp)
    80000afc:	ec56                	sd	s5,24(sp)
    80000afe:	e85a                	sd	s6,16(sp)
    80000b00:	e45e                	sd	s7,8(sp)
    80000b02:	e062                	sd	s8,0(sp)
    80000b04:	0880                	addi	s0,sp,80
    80000b06:	8b2a                	mv	s6,a0
    80000b08:	8c2e                	mv	s8,a1
    80000b0a:	8a32                	mv	s4,a2
    80000b0c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b0e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b10:	6a85                	lui	s5,0x1
    80000b12:	a015                	j	80000b36 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b14:	9562                	add	a0,a0,s8
    80000b16:	0004861b          	sext.w	a2,s1
    80000b1a:	85d2                	mv	a1,s4
    80000b1c:	41250533          	sub	a0,a0,s2
    80000b20:	fffff097          	auipc	ra,0xfffff
    80000b24:	6b8080e7          	jalr	1720(ra) # 800001d8 <memmove>

    len -= n;
    80000b28:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b2c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b2e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b32:	02098263          	beqz	s3,80000b56 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b36:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3a:	85ca                	mv	a1,s2
    80000b3c:	855a                	mv	a0,s6
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	9c8080e7          	jalr	-1592(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b46:	cd01                	beqz	a0,80000b5e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b48:	418904b3          	sub	s1,s2,s8
    80000b4c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4e:	fc99f3e3          	bgeu	s3,s1,80000b14 <copyout+0x28>
    80000b52:	84ce                	mv	s1,s3
    80000b54:	b7c1                	j	80000b14 <copyout+0x28>
  }
  return 0;
    80000b56:	4501                	li	a0,0
    80000b58:	a021                	j	80000b60 <copyout+0x74>
    80000b5a:	4501                	li	a0,0
}
    80000b5c:	8082                	ret
      return -1;
    80000b5e:	557d                	li	a0,-1
}
    80000b60:	60a6                	ld	ra,72(sp)
    80000b62:	6406                	ld	s0,64(sp)
    80000b64:	74e2                	ld	s1,56(sp)
    80000b66:	7942                	ld	s2,48(sp)
    80000b68:	79a2                	ld	s3,40(sp)
    80000b6a:	7a02                	ld	s4,32(sp)
    80000b6c:	6ae2                	ld	s5,24(sp)
    80000b6e:	6b42                	ld	s6,16(sp)
    80000b70:	6ba2                	ld	s7,8(sp)
    80000b72:	6c02                	ld	s8,0(sp)
    80000b74:	6161                	addi	sp,sp,80
    80000b76:	8082                	ret

0000000080000b78 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b78:	c6bd                	beqz	a3,80000be6 <copyin+0x6e>
{
    80000b7a:	715d                	addi	sp,sp,-80
    80000b7c:	e486                	sd	ra,72(sp)
    80000b7e:	e0a2                	sd	s0,64(sp)
    80000b80:	fc26                	sd	s1,56(sp)
    80000b82:	f84a                	sd	s2,48(sp)
    80000b84:	f44e                	sd	s3,40(sp)
    80000b86:	f052                	sd	s4,32(sp)
    80000b88:	ec56                	sd	s5,24(sp)
    80000b8a:	e85a                	sd	s6,16(sp)
    80000b8c:	e45e                	sd	s7,8(sp)
    80000b8e:	e062                	sd	s8,0(sp)
    80000b90:	0880                	addi	s0,sp,80
    80000b92:	8b2a                	mv	s6,a0
    80000b94:	8a2e                	mv	s4,a1
    80000b96:	8c32                	mv	s8,a2
    80000b98:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b9c:	6a85                	lui	s5,0x1
    80000b9e:	a015                	j	80000bc2 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba0:	9562                	add	a0,a0,s8
    80000ba2:	0004861b          	sext.w	a2,s1
    80000ba6:	412505b3          	sub	a1,a0,s2
    80000baa:	8552                	mv	a0,s4
    80000bac:	fffff097          	auipc	ra,0xfffff
    80000bb0:	62c080e7          	jalr	1580(ra) # 800001d8 <memmove>

    len -= n;
    80000bb4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bb8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bba:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bbe:	02098263          	beqz	s3,80000be2 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bc6:	85ca                	mv	a1,s2
    80000bc8:	855a                	mv	a0,s6
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	93c080e7          	jalr	-1732(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bd2:	cd01                	beqz	a0,80000bea <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bd4:	418904b3          	sub	s1,s2,s8
    80000bd8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bda:	fc99f3e3          	bgeu	s3,s1,80000ba0 <copyin+0x28>
    80000bde:	84ce                	mv	s1,s3
    80000be0:	b7c1                	j	80000ba0 <copyin+0x28>
  }
  return 0;
    80000be2:	4501                	li	a0,0
    80000be4:	a021                	j	80000bec <copyin+0x74>
    80000be6:	4501                	li	a0,0
}
    80000be8:	8082                	ret
      return -1;
    80000bea:	557d                	li	a0,-1
}
    80000bec:	60a6                	ld	ra,72(sp)
    80000bee:	6406                	ld	s0,64(sp)
    80000bf0:	74e2                	ld	s1,56(sp)
    80000bf2:	7942                	ld	s2,48(sp)
    80000bf4:	79a2                	ld	s3,40(sp)
    80000bf6:	7a02                	ld	s4,32(sp)
    80000bf8:	6ae2                	ld	s5,24(sp)
    80000bfa:	6b42                	ld	s6,16(sp)
    80000bfc:	6ba2                	ld	s7,8(sp)
    80000bfe:	6c02                	ld	s8,0(sp)
    80000c00:	6161                	addi	sp,sp,80
    80000c02:	8082                	ret

0000000080000c04 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c04:	c6c5                	beqz	a3,80000cac <copyinstr+0xa8>
{
    80000c06:	715d                	addi	sp,sp,-80
    80000c08:	e486                	sd	ra,72(sp)
    80000c0a:	e0a2                	sd	s0,64(sp)
    80000c0c:	fc26                	sd	s1,56(sp)
    80000c0e:	f84a                	sd	s2,48(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	ec56                	sd	s5,24(sp)
    80000c16:	e85a                	sd	s6,16(sp)
    80000c18:	e45e                	sd	s7,8(sp)
    80000c1a:	0880                	addi	s0,sp,80
    80000c1c:	8a2a                	mv	s4,a0
    80000c1e:	8b2e                	mv	s6,a1
    80000c20:	8bb2                	mv	s7,a2
    80000c22:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c24:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c26:	6985                	lui	s3,0x1
    80000c28:	a035                	j	80000c54 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c2a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c2e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c30:	0017b793          	seqz	a5,a5
    80000c34:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c38:	60a6                	ld	ra,72(sp)
    80000c3a:	6406                	ld	s0,64(sp)
    80000c3c:	74e2                	ld	s1,56(sp)
    80000c3e:	7942                	ld	s2,48(sp)
    80000c40:	79a2                	ld	s3,40(sp)
    80000c42:	7a02                	ld	s4,32(sp)
    80000c44:	6ae2                	ld	s5,24(sp)
    80000c46:	6b42                	ld	s6,16(sp)
    80000c48:	6ba2                	ld	s7,8(sp)
    80000c4a:	6161                	addi	sp,sp,80
    80000c4c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c4e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c52:	c8a9                	beqz	s1,80000ca4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c54:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c58:	85ca                	mv	a1,s2
    80000c5a:	8552                	mv	a0,s4
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	8aa080e7          	jalr	-1878(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c64:	c131                	beqz	a0,80000ca8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c66:	41790833          	sub	a6,s2,s7
    80000c6a:	984e                	add	a6,a6,s3
    if(n > max)
    80000c6c:	0104f363          	bgeu	s1,a6,80000c72 <copyinstr+0x6e>
    80000c70:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c72:	955e                	add	a0,a0,s7
    80000c74:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c78:	fc080be3          	beqz	a6,80000c4e <copyinstr+0x4a>
    80000c7c:	985a                	add	a6,a6,s6
    80000c7e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c80:	41650633          	sub	a2,a0,s6
    80000c84:	14fd                	addi	s1,s1,-1
    80000c86:	9b26                	add	s6,s6,s1
    80000c88:	00f60733          	add	a4,a2,a5
    80000c8c:	00074703          	lbu	a4,0(a4)
    80000c90:	df49                	beqz	a4,80000c2a <copyinstr+0x26>
        *dst = *p;
    80000c92:	00e78023          	sb	a4,0(a5)
      --max;
    80000c96:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c9a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c9c:	ff0796e3          	bne	a5,a6,80000c88 <copyinstr+0x84>
      dst++;
    80000ca0:	8b42                	mv	s6,a6
    80000ca2:	b775                	j	80000c4e <copyinstr+0x4a>
    80000ca4:	4781                	li	a5,0
    80000ca6:	b769                	j	80000c30 <copyinstr+0x2c>
      return -1;
    80000ca8:	557d                	li	a0,-1
    80000caa:	b779                	j	80000c38 <copyinstr+0x34>
  int got_null = 0;
    80000cac:	4781                	li	a5,0
  if(got_null){
    80000cae:	0017b793          	seqz	a5,a5
    80000cb2:	40f00533          	neg	a0,a5
}
    80000cb6:	8082                	ret

0000000080000cb8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cb8:	7139                	addi	sp,sp,-64
    80000cba:	fc06                	sd	ra,56(sp)
    80000cbc:	f822                	sd	s0,48(sp)
    80000cbe:	f426                	sd	s1,40(sp)
    80000cc0:	f04a                	sd	s2,32(sp)
    80000cc2:	ec4e                	sd	s3,24(sp)
    80000cc4:	e852                	sd	s4,16(sp)
    80000cc6:	e456                	sd	s5,8(sp)
    80000cc8:	e05a                	sd	s6,0(sp)
    80000cca:	0080                	addi	s0,sp,64
    80000ccc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cce:	00008497          	auipc	s1,0x8
    80000cd2:	7b248493          	addi	s1,s1,1970 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cd6:	8b26                	mv	s6,s1
    80000cd8:	00007a97          	auipc	s5,0x7
    80000cdc:	328a8a93          	addi	s5,s5,808 # 80008000 <etext>
    80000ce0:	04000937          	lui	s2,0x4000
    80000ce4:	197d                	addi	s2,s2,-1
    80000ce6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00016a17          	auipc	s4,0x16
    80000cec:	198a0a13          	addi	s4,s4,408 # 80016e80 <tickslock>
    char *pa = kalloc();
    80000cf0:	fffff097          	auipc	ra,0xfffff
    80000cf4:	428080e7          	jalr	1064(ra) # 80000118 <kalloc>
    80000cf8:	862a                	mv	a2,a0
    if(pa == 0)
    80000cfa:	c131                	beqz	a0,80000d3e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000cfc:	416485b3          	sub	a1,s1,s6
    80000d00:	858d                	srai	a1,a1,0x3
    80000d02:	000ab783          	ld	a5,0(s5)
    80000d06:	02f585b3          	mul	a1,a1,a5
    80000d0a:	2585                	addiw	a1,a1,1
    80000d0c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d10:	4719                	li	a4,6
    80000d12:	6685                	lui	a3,0x1
    80000d14:	40b905b3          	sub	a1,s2,a1
    80000d18:	854e                	mv	a0,s3
    80000d1a:	00000097          	auipc	ra,0x0
    80000d1e:	8ce080e7          	jalr	-1842(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d22:	36848493          	addi	s1,s1,872
    80000d26:	fd4495e3          	bne	s1,s4,80000cf0 <proc_mapstacks+0x38>
  }
}
    80000d2a:	70e2                	ld	ra,56(sp)
    80000d2c:	7442                	ld	s0,48(sp)
    80000d2e:	74a2                	ld	s1,40(sp)
    80000d30:	7902                	ld	s2,32(sp)
    80000d32:	69e2                	ld	s3,24(sp)
    80000d34:	6a42                	ld	s4,16(sp)
    80000d36:	6aa2                	ld	s5,8(sp)
    80000d38:	6b02                	ld	s6,0(sp)
    80000d3a:	6121                	addi	sp,sp,64
    80000d3c:	8082                	ret
      panic("kalloc");
    80000d3e:	00007517          	auipc	a0,0x7
    80000d42:	3ea50513          	addi	a0,a0,1002 # 80008128 <etext+0x128>
    80000d46:	00005097          	auipc	ra,0x5
    80000d4a:	552080e7          	jalr	1362(ra) # 80006298 <panic>

0000000080000d4e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d4e:	7139                	addi	sp,sp,-64
    80000d50:	fc06                	sd	ra,56(sp)
    80000d52:	f822                	sd	s0,48(sp)
    80000d54:	f426                	sd	s1,40(sp)
    80000d56:	f04a                	sd	s2,32(sp)
    80000d58:	ec4e                	sd	s3,24(sp)
    80000d5a:	e852                	sd	s4,16(sp)
    80000d5c:	e456                	sd	s5,8(sp)
    80000d5e:	e05a                	sd	s6,0(sp)
    80000d60:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d62:	00007597          	auipc	a1,0x7
    80000d66:	3ce58593          	addi	a1,a1,974 # 80008130 <etext+0x130>
    80000d6a:	00008517          	auipc	a0,0x8
    80000d6e:	2e650513          	addi	a0,a0,742 # 80009050 <pid_lock>
    80000d72:	00006097          	auipc	ra,0x6
    80000d76:	9e0080e7          	jalr	-1568(ra) # 80006752 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3be58593          	addi	a1,a1,958 # 80008138 <etext+0x138>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2e650513          	addi	a0,a0,742 # 80009068 <wait_lock>
    80000d8a:	00006097          	auipc	ra,0x6
    80000d8e:	9c8080e7          	jalr	-1592(ra) # 80006752 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d92:	00008497          	auipc	s1,0x8
    80000d96:	6ee48493          	addi	s1,s1,1774 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000d9a:	00007b17          	auipc	s6,0x7
    80000d9e:	3aeb0b13          	addi	s6,s6,942 # 80008148 <etext+0x148>
      p->kstack = KSTACK((int) (p - proc));
    80000da2:	8aa6                	mv	s5,s1
    80000da4:	00007a17          	auipc	s4,0x7
    80000da8:	25ca0a13          	addi	s4,s4,604 # 80008000 <etext>
    80000dac:	04000937          	lui	s2,0x4000
    80000db0:	197d                	addi	s2,s2,-1
    80000db2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db4:	00016997          	auipc	s3,0x16
    80000db8:	0cc98993          	addi	s3,s3,204 # 80016e80 <tickslock>
      initlock(&p->lock, "proc");
    80000dbc:	85da                	mv	a1,s6
    80000dbe:	8526                	mv	a0,s1
    80000dc0:	00006097          	auipc	ra,0x6
    80000dc4:	992080e7          	jalr	-1646(ra) # 80006752 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dc8:	415487b3          	sub	a5,s1,s5
    80000dcc:	878d                	srai	a5,a5,0x3
    80000dce:	000a3703          	ld	a4,0(s4)
    80000dd2:	02e787b3          	mul	a5,a5,a4
    80000dd6:	2785                	addiw	a5,a5,1
    80000dd8:	00d7979b          	slliw	a5,a5,0xd
    80000ddc:	40f907b3          	sub	a5,s2,a5
    80000de0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de2:	36848493          	addi	s1,s1,872
    80000de6:	fd349be3          	bne	s1,s3,80000dbc <procinit+0x6e>
  }
}
    80000dea:	70e2                	ld	ra,56(sp)
    80000dec:	7442                	ld	s0,48(sp)
    80000dee:	74a2                	ld	s1,40(sp)
    80000df0:	7902                	ld	s2,32(sp)
    80000df2:	69e2                	ld	s3,24(sp)
    80000df4:	6a42                	ld	s4,16(sp)
    80000df6:	6aa2                	ld	s5,8(sp)
    80000df8:	6b02                	ld	s6,0(sp)
    80000dfa:	6121                	addi	sp,sp,64
    80000dfc:	8082                	ret

0000000080000dfe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e422                	sd	s0,8(sp)
    80000e02:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e04:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e06:	2501                	sext.w	a0,a0
    80000e08:	6422                	ld	s0,8(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret

0000000080000e0e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
    80000e14:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e16:	2781                	sext.w	a5,a5
    80000e18:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e1a:	00008517          	auipc	a0,0x8
    80000e1e:	26650513          	addi	a0,a0,614 # 80009080 <cpus>
    80000e22:	953e                	add	a0,a0,a5
    80000e24:	6422                	ld	s0,8(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret

0000000080000e2a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e2a:	1101                	addi	sp,sp,-32
    80000e2c:	ec06                	sd	ra,24(sp)
    80000e2e:	e822                	sd	s0,16(sp)
    80000e30:	e426                	sd	s1,8(sp)
    80000e32:	1000                	addi	s0,sp,32
  push_off();
    80000e34:	00006097          	auipc	ra,0x6
    80000e38:	962080e7          	jalr	-1694(ra) # 80006796 <push_off>
    80000e3c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
    80000e42:	00008717          	auipc	a4,0x8
    80000e46:	20e70713          	addi	a4,a4,526 # 80009050 <pid_lock>
    80000e4a:	97ba                	add	a5,a5,a4
    80000e4c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e4e:	00006097          	auipc	ra,0x6
    80000e52:	9e8080e7          	jalr	-1560(ra) # 80006836 <pop_off>
  return p;
}
    80000e56:	8526                	mv	a0,s1
    80000e58:	60e2                	ld	ra,24(sp)
    80000e5a:	6442                	ld	s0,16(sp)
    80000e5c:	64a2                	ld	s1,8(sp)
    80000e5e:	6105                	addi	sp,sp,32
    80000e60:	8082                	ret

0000000080000e62 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e6a:	00000097          	auipc	ra,0x0
    80000e6e:	fc0080e7          	jalr	-64(ra) # 80000e2a <myproc>
    80000e72:	00006097          	auipc	ra,0x6
    80000e76:	a24080e7          	jalr	-1500(ra) # 80006896 <release>

  if (first) {
    80000e7a:	00008797          	auipc	a5,0x8
    80000e7e:	9a67a783          	lw	a5,-1626(a5) # 80008820 <first.1762>
    80000e82:	eb89                	bnez	a5,80000e94 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e84:	00001097          	auipc	ra,0x1
    80000e88:	e02080e7          	jalr	-510(ra) # 80001c86 <usertrapret>
}
    80000e8c:	60a2                	ld	ra,8(sp)
    80000e8e:	6402                	ld	s0,0(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret
    first = 0;
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	9807a623          	sw	zero,-1652(a5) # 80008820 <first.1762>
    fsinit(ROOTDEV);
    80000e9c:	4505                	li	a0,1
    80000e9e:	00002097          	auipc	ra,0x2
    80000ea2:	c94080e7          	jalr	-876(ra) # 80002b32 <fsinit>
    80000ea6:	bff9                	j	80000e84 <forkret+0x22>

0000000080000ea8 <allocpid>:
allocpid() {
    80000ea8:	1101                	addi	sp,sp,-32
    80000eaa:	ec06                	sd	ra,24(sp)
    80000eac:	e822                	sd	s0,16(sp)
    80000eae:	e426                	sd	s1,8(sp)
    80000eb0:	e04a                	sd	s2,0(sp)
    80000eb2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb4:	00008917          	auipc	s2,0x8
    80000eb8:	19c90913          	addi	s2,s2,412 # 80009050 <pid_lock>
    80000ebc:	854a                	mv	a0,s2
    80000ebe:	00006097          	auipc	ra,0x6
    80000ec2:	924080e7          	jalr	-1756(ra) # 800067e2 <acquire>
  pid = nextpid;
    80000ec6:	00008797          	auipc	a5,0x8
    80000eca:	95e78793          	addi	a5,a5,-1698 # 80008824 <nextpid>
    80000ece:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ed0:	0014871b          	addiw	a4,s1,1
    80000ed4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00006097          	auipc	ra,0x6
    80000edc:	9be080e7          	jalr	-1602(ra) # 80006896 <release>
}
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	60e2                	ld	ra,24(sp)
    80000ee4:	6442                	ld	s0,16(sp)
    80000ee6:	64a2                	ld	s1,8(sp)
    80000ee8:	6902                	ld	s2,0(sp)
    80000eea:	6105                	addi	sp,sp,32
    80000eec:	8082                	ret

0000000080000eee <proc_pagetable>:
{
    80000eee:	1101                	addi	sp,sp,-32
    80000ef0:	ec06                	sd	ra,24(sp)
    80000ef2:	e822                	sd	s0,16(sp)
    80000ef4:	e426                	sd	s1,8(sp)
    80000ef6:	e04a                	sd	s2,0(sp)
    80000ef8:	1000                	addi	s0,sp,32
    80000efa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	8b8080e7          	jalr	-1864(ra) # 800007b4 <uvmcreate>
    80000f04:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f06:	c121                	beqz	a0,80000f46 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f08:	4729                	li	a4,10
    80000f0a:	00006697          	auipc	a3,0x6
    80000f0e:	0f668693          	addi	a3,a3,246 # 80007000 <_trampoline>
    80000f12:	6605                	lui	a2,0x1
    80000f14:	040005b7          	lui	a1,0x4000
    80000f18:	15fd                	addi	a1,a1,-1
    80000f1a:	05b2                	slli	a1,a1,0xc
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	62c080e7          	jalr	1580(ra) # 80000548 <mappages>
    80000f24:	02054863          	bltz	a0,80000f54 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f28:	4719                	li	a4,6
    80000f2a:	05893683          	ld	a3,88(s2)
    80000f2e:	6605                	lui	a2,0x1
    80000f30:	020005b7          	lui	a1,0x2000
    80000f34:	15fd                	addi	a1,a1,-1
    80000f36:	05b6                	slli	a1,a1,0xd
    80000f38:	8526                	mv	a0,s1
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054163          	bltz	a0,80000f64 <proc_pagetable+0x76>
}
    80000f46:	8526                	mv	a0,s1
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6902                	ld	s2,0(sp)
    80000f50:	6105                	addi	sp,sp,32
    80000f52:	8082                	ret
    uvmfree(pagetable, 0);
    80000f54:	4581                	li	a1,0
    80000f56:	8526                	mv	a0,s1
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	a58080e7          	jalr	-1448(ra) # 800009b0 <uvmfree>
    return 0;
    80000f60:	4481                	li	s1,0
    80000f62:	b7d5                	j	80000f46 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f64:	4681                	li	a3,0
    80000f66:	4605                	li	a2,1
    80000f68:	040005b7          	lui	a1,0x4000
    80000f6c:	15fd                	addi	a1,a1,-1
    80000f6e:	05b2                	slli	a1,a1,0xc
    80000f70:	8526                	mv	a0,s1
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	79c080e7          	jalr	1948(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f7a:	4581                	li	a1,0
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	a32080e7          	jalr	-1486(ra) # 800009b0 <uvmfree>
    return 0;
    80000f86:	4481                	li	s1,0
    80000f88:	bf7d                	j	80000f46 <proc_pagetable+0x58>

0000000080000f8a <proc_freepagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	84aa                	mv	s1,a0
    80000f98:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9a:	4681                	li	a3,0
    80000f9c:	4605                	li	a2,1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	768080e7          	jalr	1896(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	020005b7          	lui	a1,0x2000
    80000fb6:	15fd                	addi	a1,a1,-1
    80000fb8:	05b6                	slli	a1,a1,0xd
    80000fba:	8526                	mv	a0,s1
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	752080e7          	jalr	1874(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc4:	85ca                	mv	a1,s2
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	9e8080e7          	jalr	-1560(ra) # 800009b0 <uvmfree>
}
    80000fd0:	60e2                	ld	ra,24(sp)
    80000fd2:	6442                	ld	s0,16(sp)
    80000fd4:	64a2                	ld	s1,8(sp)
    80000fd6:	6902                	ld	s2,0(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <freeproc>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
    80000fe6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fe8:	6d28                	ld	a0,88(a0)
    80000fea:	c509                	beqz	a0,80000ff4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	030080e7          	jalr	48(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000ff4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ff8:	68a8                	ld	a0,80(s1)
    80000ffa:	c511                	beqz	a0,80001006 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80000ffc:	64ac                	ld	a1,72(s1)
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	f8c080e7          	jalr	-116(ra) # 80000f8a <proc_freepagetable>
  p->pagetable = 0;
    80001006:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000100a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000100e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001012:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001016:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000101a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000101e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001022:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001026:	0004ac23          	sw	zero,24(s1)
}
    8000102a:	60e2                	ld	ra,24(sp)
    8000102c:	6442                	ld	s0,16(sp)
    8000102e:	64a2                	ld	s1,8(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret

0000000080001034 <allocproc>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001040:	00008497          	auipc	s1,0x8
    80001044:	44048493          	addi	s1,s1,1088 # 80009480 <proc>
    80001048:	00016917          	auipc	s2,0x16
    8000104c:	e3890913          	addi	s2,s2,-456 # 80016e80 <tickslock>
    acquire(&p->lock);
    80001050:	8526                	mv	a0,s1
    80001052:	00005097          	auipc	ra,0x5
    80001056:	790080e7          	jalr	1936(ra) # 800067e2 <acquire>
    if(p->state == UNUSED) {
    8000105a:	4c9c                	lw	a5,24(s1)
    8000105c:	cf81                	beqz	a5,80001074 <allocproc+0x40>
      release(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00006097          	auipc	ra,0x6
    80001064:	836080e7          	jalr	-1994(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	36848493          	addi	s1,s1,872
    8000106c:	ff2492e3          	bne	s1,s2,80001050 <allocproc+0x1c>
  return 0;
    80001070:	4481                	li	s1,0
    80001072:	a889                	j	800010c4 <allocproc+0x90>
  p->pid = allocpid();
    80001074:	00000097          	auipc	ra,0x0
    80001078:	e34080e7          	jalr	-460(ra) # 80000ea8 <allocpid>
    8000107c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000107e:	4785                	li	a5,1
    80001080:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	096080e7          	jalr	150(ra) # 80000118 <kalloc>
    8000108a:	892a                	mv	s2,a0
    8000108c:	eca8                	sd	a0,88(s1)
    8000108e:	c131                	beqz	a0,800010d2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001090:	8526                	mv	a0,s1
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e5c080e7          	jalr	-420(ra) # 80000eee <proc_pagetable>
    8000109a:	892a                	mv	s2,a0
    8000109c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000109e:	c531                	beqz	a0,800010ea <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010a0:	07000613          	li	a2,112
    800010a4:	4581                	li	a1,0
    800010a6:	06048513          	addi	a0,s1,96
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	0ce080e7          	jalr	206(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010b2:	00000797          	auipc	a5,0x0
    800010b6:	db078793          	addi	a5,a5,-592 # 80000e62 <forkret>
    800010ba:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010bc:	60bc                	ld	a5,64(s1)
    800010be:	6705                	lui	a4,0x1
    800010c0:	97ba                	add	a5,a5,a4
    800010c2:	f4bc                	sd	a5,104(s1)
}
    800010c4:	8526                	mv	a0,s1
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6902                	ld	s2,0(sp)
    800010ce:	6105                	addi	sp,sp,32
    800010d0:	8082                	ret
    freeproc(p);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	f08080e7          	jalr	-248(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010dc:	8526                	mv	a0,s1
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	7b8080e7          	jalr	1976(ra) # 80006896 <release>
    return 0;
    800010e6:	84ca                	mv	s1,s2
    800010e8:	bff1                	j	800010c4 <allocproc+0x90>
    freeproc(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	ef0080e7          	jalr	-272(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	7a0080e7          	jalr	1952(ra) # 80006896 <release>
    return 0;
    800010fe:	84ca                	mv	s1,s2
    80001100:	b7d1                	j	800010c4 <allocproc+0x90>

0000000080001102 <userinit>:
{
    80001102:	1101                	addi	sp,sp,-32
    80001104:	ec06                	sd	ra,24(sp)
    80001106:	e822                	sd	s0,16(sp)
    80001108:	e426                	sd	s1,8(sp)
    8000110a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f28080e7          	jalr	-216(ra) # 80001034 <allocproc>
    80001114:	84aa                	mv	s1,a0
  initproc = p;
    80001116:	00008797          	auipc	a5,0x8
    8000111a:	eea7bd23          	sd	a0,-262(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000111e:	03400613          	li	a2,52
    80001122:	00007597          	auipc	a1,0x7
    80001126:	70e58593          	addi	a1,a1,1806 # 80008830 <initcode>
    8000112a:	6928                	ld	a0,80(a0)
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	6b6080e7          	jalr	1718(ra) # 800007e2 <uvminit>
  p->sz = PGSIZE;
    80001134:	6785                	lui	a5,0x1
    80001136:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001138:	6cb8                	ld	a4,88(s1)
    8000113a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000113e:	6cb8                	ld	a4,88(s1)
    80001140:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001142:	4641                	li	a2,16
    80001144:	00007597          	auipc	a1,0x7
    80001148:	00c58593          	addi	a1,a1,12 # 80008150 <etext+0x150>
    8000114c:	15848513          	addi	a0,s1,344
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	17a080e7          	jalr	378(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	00850513          	addi	a0,a0,8 # 80008160 <etext+0x160>
    80001160:	00002097          	auipc	ra,0x2
    80001164:	400080e7          	jalr	1024(ra) # 80003560 <namei>
    80001168:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	724080e7          	jalr	1828(ra) # 80006896 <release>
}
    8000117a:	60e2                	ld	ra,24(sp)
    8000117c:	6442                	ld	s0,16(sp)
    8000117e:	64a2                	ld	s1,8(sp)
    80001180:	6105                	addi	sp,sp,32
    80001182:	8082                	ret

0000000080001184 <growproc>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	e04a                	sd	s2,0(sp)
    8000118e:	1000                	addi	s0,sp,32
    80001190:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001192:	00000097          	auipc	ra,0x0
    80001196:	c98080e7          	jalr	-872(ra) # 80000e2a <myproc>
    8000119a:	892a                	mv	s2,a0
  sz = p->sz;
    8000119c:	652c                	ld	a1,72(a0)
    8000119e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011a2:	00904f63          	bgtz	s1,800011c0 <growproc+0x3c>
  } else if(n < 0){
    800011a6:	0204cc63          	bltz	s1,800011de <growproc+0x5a>
  p->sz = sz;
    800011aa:	1602                	slli	a2,a2,0x20
    800011ac:	9201                	srli	a2,a2,0x20
    800011ae:	04c93423          	sd	a2,72(s2)
  return 0;
    800011b2:	4501                	li	a0,0
}
    800011b4:	60e2                	ld	ra,24(sp)
    800011b6:	6442                	ld	s0,16(sp)
    800011b8:	64a2                	ld	s1,8(sp)
    800011ba:	6902                	ld	s2,0(sp)
    800011bc:	6105                	addi	sp,sp,32
    800011be:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011c0:	9e25                	addw	a2,a2,s1
    800011c2:	1602                	slli	a2,a2,0x20
    800011c4:	9201                	srli	a2,a2,0x20
    800011c6:	1582                	slli	a1,a1,0x20
    800011c8:	9181                	srli	a1,a1,0x20
    800011ca:	6928                	ld	a0,80(a0)
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	6d0080e7          	jalr	1744(ra) # 8000089c <uvmalloc>
    800011d4:	0005061b          	sext.w	a2,a0
    800011d8:	fa69                	bnez	a2,800011aa <growproc+0x26>
      return -1;
    800011da:	557d                	li	a0,-1
    800011dc:	bfe1                	j	800011b4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	66a080e7          	jalr	1642(ra) # 80000854 <uvmdealloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	bf55                	j	800011aa <growproc+0x26>

00000000800011f8 <fork>:
{
    800011f8:	7139                	addi	sp,sp,-64
    800011fa:	fc06                	sd	ra,56(sp)
    800011fc:	f822                	sd	s0,48(sp)
    800011fe:	f426                	sd	s1,40(sp)
    80001200:	f04a                	sd	s2,32(sp)
    80001202:	ec4e                	sd	s3,24(sp)
    80001204:	e852                	sd	s4,16(sp)
    80001206:	e456                	sd	s5,8(sp)
    80001208:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	c20080e7          	jalr	-992(ra) # 80000e2a <myproc>
    80001212:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001214:	00000097          	auipc	ra,0x0
    80001218:	e20080e7          	jalr	-480(ra) # 80001034 <allocproc>
    8000121c:	14050c63          	beqz	a0,80001374 <fork+0x17c>
    80001220:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001222:	0489b603          	ld	a2,72(s3)
    80001226:	692c                	ld	a1,80(a0)
    80001228:	0509b503          	ld	a0,80(s3)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	7bc080e7          	jalr	1980(ra) # 800009e8 <uvmcopy>
    80001234:	04054663          	bltz	a0,80001280 <fork+0x88>
  np->sz = p->sz;
    80001238:	0489b783          	ld	a5,72(s3)
    8000123c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001240:	0589b683          	ld	a3,88(s3)
    80001244:	87b6                	mv	a5,a3
    80001246:	058a3703          	ld	a4,88(s4)
    8000124a:	12068693          	addi	a3,a3,288
    8000124e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001252:	6788                	ld	a0,8(a5)
    80001254:	6b8c                	ld	a1,16(a5)
    80001256:	6f90                	ld	a2,24(a5)
    80001258:	01073023          	sd	a6,0(a4)
    8000125c:	e708                	sd	a0,8(a4)
    8000125e:	eb0c                	sd	a1,16(a4)
    80001260:	ef10                	sd	a2,24(a4)
    80001262:	02078793          	addi	a5,a5,32
    80001266:	02070713          	addi	a4,a4,32
    8000126a:	fed792e3          	bne	a5,a3,8000124e <fork+0x56>
  np->trapframe->a0 = 0;
    8000126e:	058a3783          	ld	a5,88(s4)
    80001272:	0607b823          	sd	zero,112(a5)
    80001276:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000127a:	15000913          	li	s2,336
    8000127e:	a03d                	j	800012ac <fork+0xb4>
    freeproc(np);
    80001280:	8552                	mv	a0,s4
    80001282:	00000097          	auipc	ra,0x0
    80001286:	d5a080e7          	jalr	-678(ra) # 80000fdc <freeproc>
    release(&np->lock);
    8000128a:	8552                	mv	a0,s4
    8000128c:	00005097          	auipc	ra,0x5
    80001290:	60a080e7          	jalr	1546(ra) # 80006896 <release>
    return -1;
    80001294:	597d                	li	s2,-1
    80001296:	a0e9                	j	80001360 <fork+0x168>
      np->ofile[i] = filedup(p->ofile[i]);
    80001298:	00003097          	auipc	ra,0x3
    8000129c:	95e080e7          	jalr	-1698(ra) # 80003bf6 <filedup>
    800012a0:	009a07b3          	add	a5,s4,s1
    800012a4:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012a6:	04a1                	addi	s1,s1,8
    800012a8:	01248763          	beq	s1,s2,800012b6 <fork+0xbe>
    if(p->ofile[i])
    800012ac:	009987b3          	add	a5,s3,s1
    800012b0:	6388                	ld	a0,0(a5)
    800012b2:	f17d                	bnez	a0,80001298 <fork+0xa0>
    800012b4:	bfcd                	j	800012a6 <fork+0xae>
  np->cwd = idup(p->cwd);
    800012b6:	1509b503          	ld	a0,336(s3)
    800012ba:	00002097          	auipc	ra,0x2
    800012be:	ab2080e7          	jalr	-1358(ra) # 80002d6c <idup>
    800012c2:	14aa3823          	sd	a0,336(s4)
  for (i = 0; i < NVMA; i++) 
    800012c6:	16898493          	addi	s1,s3,360
    800012ca:	180a0913          	addi	s2,s4,384
    800012ce:	36898a93          	addi	s5,s3,872
    800012d2:	a03d                	j	80001300 <fork+0x108>
      np->vma[i] = p->vma[i];
    800012d4:	86be                	mv	a3,a5
    800012d6:	6498                	ld	a4,8(s1)
    800012d8:	689c                	ld	a5,16(s1)
    800012da:	6c88                	ld	a0,24(s1)
    800012dc:	fed93423          	sd	a3,-24(s2)
    800012e0:	fee93823          	sd	a4,-16(s2)
    800012e4:	fef93c23          	sd	a5,-8(s2)
    800012e8:	00a93023          	sd	a0,0(s2)
      filedup(np->vma[i].f);
    800012ec:	00003097          	auipc	ra,0x3
    800012f0:	90a080e7          	jalr	-1782(ra) # 80003bf6 <filedup>
  for (i = 0; i < NVMA; i++) 
    800012f4:	02048493          	addi	s1,s1,32
    800012f8:	02090913          	addi	s2,s2,32
    800012fc:	01548563          	beq	s1,s5,80001306 <fork+0x10e>
    if (p->vma[i].addr) {
    80001300:	609c                	ld	a5,0(s1)
    80001302:	dbed                	beqz	a5,800012f4 <fork+0xfc>
    80001304:	bfc1                	j	800012d4 <fork+0xdc>
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001306:	4641                	li	a2,16
    80001308:	15898593          	addi	a1,s3,344
    8000130c:	158a0513          	addi	a0,s4,344
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	fba080e7          	jalr	-70(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001318:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000131c:	8552                	mv	a0,s4
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	578080e7          	jalr	1400(ra) # 80006896 <release>
  acquire(&wait_lock);
    80001326:	00008497          	auipc	s1,0x8
    8000132a:	d4248493          	addi	s1,s1,-702 # 80009068 <wait_lock>
    8000132e:	8526                	mv	a0,s1
    80001330:	00005097          	auipc	ra,0x5
    80001334:	4b2080e7          	jalr	1202(ra) # 800067e2 <acquire>
  np->parent = p;
    80001338:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	558080e7          	jalr	1368(ra) # 80006896 <release>
  acquire(&np->lock);
    80001346:	8552                	mv	a0,s4
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	49a080e7          	jalr	1178(ra) # 800067e2 <acquire>
  np->state = RUNNABLE;
    80001350:	478d                	li	a5,3
    80001352:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	53e080e7          	jalr	1342(ra) # 80006896 <release>
}
    80001360:	854a                	mv	a0,s2
    80001362:	70e2                	ld	ra,56(sp)
    80001364:	7442                	ld	s0,48(sp)
    80001366:	74a2                	ld	s1,40(sp)
    80001368:	7902                	ld	s2,32(sp)
    8000136a:	69e2                	ld	s3,24(sp)
    8000136c:	6a42                	ld	s4,16(sp)
    8000136e:	6aa2                	ld	s5,8(sp)
    80001370:	6121                	addi	sp,sp,64
    80001372:	8082                	ret
    return -1;
    80001374:	597d                	li	s2,-1
    80001376:	b7ed                	j	80001360 <fork+0x168>

0000000080001378 <scheduler>:
{
    80001378:	7139                	addi	sp,sp,-64
    8000137a:	fc06                	sd	ra,56(sp)
    8000137c:	f822                	sd	s0,48(sp)
    8000137e:	f426                	sd	s1,40(sp)
    80001380:	f04a                	sd	s2,32(sp)
    80001382:	ec4e                	sd	s3,24(sp)
    80001384:	e852                	sd	s4,16(sp)
    80001386:	e456                	sd	s5,8(sp)
    80001388:	e05a                	sd	s6,0(sp)
    8000138a:	0080                	addi	s0,sp,64
    8000138c:	8792                	mv	a5,tp
  int id = r_tp();
    8000138e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001390:	00779a93          	slli	s5,a5,0x7
    80001394:	00008717          	auipc	a4,0x8
    80001398:	cbc70713          	addi	a4,a4,-836 # 80009050 <pid_lock>
    8000139c:	9756                	add	a4,a4,s5
    8000139e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a2:	00008717          	auipc	a4,0x8
    800013a6:	ce670713          	addi	a4,a4,-794 # 80009088 <cpus+0x8>
    800013aa:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ac:	498d                	li	s3,3
        p->state = RUNNING;
    800013ae:	4b11                	li	s6,4
        c->proc = p;
    800013b0:	079e                	slli	a5,a5,0x7
    800013b2:	00008a17          	auipc	s4,0x8
    800013b6:	c9ea0a13          	addi	s4,s4,-866 # 80009050 <pid_lock>
    800013ba:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013bc:	00016917          	auipc	s2,0x16
    800013c0:	ac490913          	addi	s2,s2,-1340 # 80016e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013cc:	10079073          	csrw	sstatus,a5
    800013d0:	00008497          	auipc	s1,0x8
    800013d4:	0b048493          	addi	s1,s1,176 # 80009480 <proc>
    800013d8:	a03d                	j	80001406 <scheduler+0x8e>
        p->state = RUNNING;
    800013da:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013de:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e2:	06048593          	addi	a1,s1,96
    800013e6:	8556                	mv	a0,s5
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	7f4080e7          	jalr	2036(ra) # 80001bdc <swtch>
        c->proc = 0;
    800013f0:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	00005097          	auipc	ra,0x5
    800013fa:	4a0080e7          	jalr	1184(ra) # 80006896 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	36848493          	addi	s1,s1,872
    80001402:	fd2481e3          	beq	s1,s2,800013c4 <scheduler+0x4c>
      acquire(&p->lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	3da080e7          	jalr	986(ra) # 800067e2 <acquire>
      if(p->state == RUNNABLE) {
    80001410:	4c9c                	lw	a5,24(s1)
    80001412:	ff3791e3          	bne	a5,s3,800013f4 <scheduler+0x7c>
    80001416:	b7d1                	j	800013da <scheduler+0x62>

0000000080001418 <sched>:
{
    80001418:	7179                	addi	sp,sp,-48
    8000141a:	f406                	sd	ra,40(sp)
    8000141c:	f022                	sd	s0,32(sp)
    8000141e:	ec26                	sd	s1,24(sp)
    80001420:	e84a                	sd	s2,16(sp)
    80001422:	e44e                	sd	s3,8(sp)
    80001424:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001426:	00000097          	auipc	ra,0x0
    8000142a:	a04080e7          	jalr	-1532(ra) # 80000e2a <myproc>
    8000142e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001430:	00005097          	auipc	ra,0x5
    80001434:	338080e7          	jalr	824(ra) # 80006768 <holding>
    80001438:	c93d                	beqz	a0,800014ae <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000143c:	2781                	sext.w	a5,a5
    8000143e:	079e                	slli	a5,a5,0x7
    80001440:	00008717          	auipc	a4,0x8
    80001444:	c1070713          	addi	a4,a4,-1008 # 80009050 <pid_lock>
    80001448:	97ba                	add	a5,a5,a4
    8000144a:	0a87a703          	lw	a4,168(a5)
    8000144e:	4785                	li	a5,1
    80001450:	06f71763          	bne	a4,a5,800014be <sched+0xa6>
  if(p->state == RUNNING)
    80001454:	4c98                	lw	a4,24(s1)
    80001456:	4791                	li	a5,4
    80001458:	06f70b63          	beq	a4,a5,800014ce <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001460:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001462:	efb5                	bnez	a5,800014de <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001466:	00008917          	auipc	s2,0x8
    8000146a:	bea90913          	addi	s2,s2,-1046 # 80009050 <pid_lock>
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	97ca                	add	a5,a5,s2
    80001474:	0ac7a983          	lw	s3,172(a5)
    80001478:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000147a:	2781                	sext.w	a5,a5
    8000147c:	079e                	slli	a5,a5,0x7
    8000147e:	00008597          	auipc	a1,0x8
    80001482:	c0a58593          	addi	a1,a1,-1014 # 80009088 <cpus+0x8>
    80001486:	95be                	add	a1,a1,a5
    80001488:	06048513          	addi	a0,s1,96
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	750080e7          	jalr	1872(ra) # 80001bdc <swtch>
    80001494:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	97ca                	add	a5,a5,s2
    8000149c:	0b37a623          	sw	s3,172(a5)
}
    800014a0:	70a2                	ld	ra,40(sp)
    800014a2:	7402                	ld	s0,32(sp)
    800014a4:	64e2                	ld	s1,24(sp)
    800014a6:	6942                	ld	s2,16(sp)
    800014a8:	69a2                	ld	s3,8(sp)
    800014aa:	6145                	addi	sp,sp,48
    800014ac:	8082                	ret
    panic("sched p->lock");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	cba50513          	addi	a0,a0,-838 # 80008168 <etext+0x168>
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	de2080e7          	jalr	-542(ra) # 80006298 <panic>
    panic("sched locks");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cba50513          	addi	a0,a0,-838 # 80008178 <etext+0x178>
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	dd2080e7          	jalr	-558(ra) # 80006298 <panic>
    panic("sched running");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cba50513          	addi	a0,a0,-838 # 80008188 <etext+0x188>
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	dc2080e7          	jalr	-574(ra) # 80006298 <panic>
    panic("sched interruptible");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cba50513          	addi	a0,a0,-838 # 80008198 <etext+0x198>
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	db2080e7          	jalr	-590(ra) # 80006298 <panic>

00000000800014ee <yield>:
{
    800014ee:	1101                	addi	sp,sp,-32
    800014f0:	ec06                	sd	ra,24(sp)
    800014f2:	e822                	sd	s0,16(sp)
    800014f4:	e426                	sd	s1,8(sp)
    800014f6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	932080e7          	jalr	-1742(ra) # 80000e2a <myproc>
    80001500:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001502:	00005097          	auipc	ra,0x5
    80001506:	2e0080e7          	jalr	736(ra) # 800067e2 <acquire>
  p->state = RUNNABLE;
    8000150a:	478d                	li	a5,3
    8000150c:	cc9c                	sw	a5,24(s1)
  sched();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	f0a080e7          	jalr	-246(ra) # 80001418 <sched>
  release(&p->lock);
    80001516:	8526                	mv	a0,s1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	37e080e7          	jalr	894(ra) # 80006896 <release>
}
    80001520:	60e2                	ld	ra,24(sp)
    80001522:	6442                	ld	s0,16(sp)
    80001524:	64a2                	ld	s1,8(sp)
    80001526:	6105                	addi	sp,sp,32
    80001528:	8082                	ret

000000008000152a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000152a:	7179                	addi	sp,sp,-48
    8000152c:	f406                	sd	ra,40(sp)
    8000152e:	f022                	sd	s0,32(sp)
    80001530:	ec26                	sd	s1,24(sp)
    80001532:	e84a                	sd	s2,16(sp)
    80001534:	e44e                	sd	s3,8(sp)
    80001536:	1800                	addi	s0,sp,48
    80001538:	89aa                	mv	s3,a0
    8000153a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	8ee080e7          	jalr	-1810(ra) # 80000e2a <myproc>
    80001544:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	29c080e7          	jalr	668(ra) # 800067e2 <acquire>
  release(lk);
    8000154e:	854a                	mv	a0,s2
    80001550:	00005097          	auipc	ra,0x5
    80001554:	346080e7          	jalr	838(ra) # 80006896 <release>

  // Go to sleep.
  p->chan = chan;
    80001558:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000155c:	4789                	li	a5,2
    8000155e:	cc9c                	sw	a5,24(s1)

  sched();
    80001560:	00000097          	auipc	ra,0x0
    80001564:	eb8080e7          	jalr	-328(ra) # 80001418 <sched>

  // Tidy up.
  p->chan = 0;
    80001568:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	328080e7          	jalr	808(ra) # 80006896 <release>
  acquire(lk);
    80001576:	854a                	mv	a0,s2
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	26a080e7          	jalr	618(ra) # 800067e2 <acquire>
}
    80001580:	70a2                	ld	ra,40(sp)
    80001582:	7402                	ld	s0,32(sp)
    80001584:	64e2                	ld	s1,24(sp)
    80001586:	6942                	ld	s2,16(sp)
    80001588:	69a2                	ld	s3,8(sp)
    8000158a:	6145                	addi	sp,sp,48
    8000158c:	8082                	ret

000000008000158e <wait>:
{
    8000158e:	715d                	addi	sp,sp,-80
    80001590:	e486                	sd	ra,72(sp)
    80001592:	e0a2                	sd	s0,64(sp)
    80001594:	fc26                	sd	s1,56(sp)
    80001596:	f84a                	sd	s2,48(sp)
    80001598:	f44e                	sd	s3,40(sp)
    8000159a:	f052                	sd	s4,32(sp)
    8000159c:	ec56                	sd	s5,24(sp)
    8000159e:	e85a                	sd	s6,16(sp)
    800015a0:	e45e                	sd	s7,8(sp)
    800015a2:	e062                	sd	s8,0(sp)
    800015a4:	0880                	addi	s0,sp,80
    800015a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	882080e7          	jalr	-1918(ra) # 80000e2a <myproc>
    800015b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b2:	00008517          	auipc	a0,0x8
    800015b6:	ab650513          	addi	a0,a0,-1354 # 80009068 <wait_lock>
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	228080e7          	jalr	552(ra) # 800067e2 <acquire>
    havekids = 0;
    800015c2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015c4:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015c6:	00016997          	auipc	s3,0x16
    800015ca:	8ba98993          	addi	s3,s3,-1862 # 80016e80 <tickslock>
        havekids = 1;
    800015ce:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d0:	00008c17          	auipc	s8,0x8
    800015d4:	a98c0c13          	addi	s8,s8,-1384 # 80009068 <wait_lock>
    havekids = 0;
    800015d8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015da:	00008497          	auipc	s1,0x8
    800015de:	ea648493          	addi	s1,s1,-346 # 80009480 <proc>
    800015e2:	a0bd                	j	80001650 <wait+0xc2>
          pid = np->pid;
    800015e4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015e8:	000b0e63          	beqz	s6,80001604 <wait+0x76>
    800015ec:	4691                	li	a3,4
    800015ee:	02c48613          	addi	a2,s1,44
    800015f2:	85da                	mv	a1,s6
    800015f4:	05093503          	ld	a0,80(s2)
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	4f4080e7          	jalr	1268(ra) # 80000aec <copyout>
    80001600:	02054563          	bltz	a0,8000162a <wait+0x9c>
          freeproc(np);
    80001604:	8526                	mv	a0,s1
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	9d6080e7          	jalr	-1578(ra) # 80000fdc <freeproc>
          release(&np->lock);
    8000160e:	8526                	mv	a0,s1
    80001610:	00005097          	auipc	ra,0x5
    80001614:	286080e7          	jalr	646(ra) # 80006896 <release>
          release(&wait_lock);
    80001618:	00008517          	auipc	a0,0x8
    8000161c:	a5050513          	addi	a0,a0,-1456 # 80009068 <wait_lock>
    80001620:	00005097          	auipc	ra,0x5
    80001624:	276080e7          	jalr	630(ra) # 80006896 <release>
          return pid;
    80001628:	a09d                	j	8000168e <wait+0x100>
            release(&np->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	26a080e7          	jalr	618(ra) # 80006896 <release>
            release(&wait_lock);
    80001634:	00008517          	auipc	a0,0x8
    80001638:	a3450513          	addi	a0,a0,-1484 # 80009068 <wait_lock>
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	25a080e7          	jalr	602(ra) # 80006896 <release>
            return -1;
    80001644:	59fd                	li	s3,-1
    80001646:	a0a1                	j	8000168e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001648:	36848493          	addi	s1,s1,872
    8000164c:	03348463          	beq	s1,s3,80001674 <wait+0xe6>
      if(np->parent == p){
    80001650:	7c9c                	ld	a5,56(s1)
    80001652:	ff279be3          	bne	a5,s2,80001648 <wait+0xba>
        acquire(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	18a080e7          	jalr	394(ra) # 800067e2 <acquire>
        if(np->state == ZOMBIE){
    80001660:	4c9c                	lw	a5,24(s1)
    80001662:	f94781e3          	beq	a5,s4,800015e4 <wait+0x56>
        release(&np->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	22e080e7          	jalr	558(ra) # 80006896 <release>
        havekids = 1;
    80001670:	8756                	mv	a4,s5
    80001672:	bfd9                	j	80001648 <wait+0xba>
    if(!havekids || p->killed){
    80001674:	c701                	beqz	a4,8000167c <wait+0xee>
    80001676:	02892783          	lw	a5,40(s2)
    8000167a:	c79d                	beqz	a5,800016a8 <wait+0x11a>
      release(&wait_lock);
    8000167c:	00008517          	auipc	a0,0x8
    80001680:	9ec50513          	addi	a0,a0,-1556 # 80009068 <wait_lock>
    80001684:	00005097          	auipc	ra,0x5
    80001688:	212080e7          	jalr	530(ra) # 80006896 <release>
      return -1;
    8000168c:	59fd                	li	s3,-1
}
    8000168e:	854e                	mv	a0,s3
    80001690:	60a6                	ld	ra,72(sp)
    80001692:	6406                	ld	s0,64(sp)
    80001694:	74e2                	ld	s1,56(sp)
    80001696:	7942                	ld	s2,48(sp)
    80001698:	79a2                	ld	s3,40(sp)
    8000169a:	7a02                	ld	s4,32(sp)
    8000169c:	6ae2                	ld	s5,24(sp)
    8000169e:	6b42                	ld	s6,16(sp)
    800016a0:	6ba2                	ld	s7,8(sp)
    800016a2:	6c02                	ld	s8,0(sp)
    800016a4:	6161                	addi	sp,sp,80
    800016a6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016a8:	85e2                	mv	a1,s8
    800016aa:	854a                	mv	a0,s2
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	e7e080e7          	jalr	-386(ra) # 8000152a <sleep>
    havekids = 0;
    800016b4:	b715                	j	800015d8 <wait+0x4a>

00000000800016b6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016b6:	7139                	addi	sp,sp,-64
    800016b8:	fc06                	sd	ra,56(sp)
    800016ba:	f822                	sd	s0,48(sp)
    800016bc:	f426                	sd	s1,40(sp)
    800016be:	f04a                	sd	s2,32(sp)
    800016c0:	ec4e                	sd	s3,24(sp)
    800016c2:	e852                	sd	s4,16(sp)
    800016c4:	e456                	sd	s5,8(sp)
    800016c6:	0080                	addi	s0,sp,64
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ca:	00008497          	auipc	s1,0x8
    800016ce:	db648493          	addi	s1,s1,-586 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016d2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016d4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d6:	00015917          	auipc	s2,0x15
    800016da:	7aa90913          	addi	s2,s2,1962 # 80016e80 <tickslock>
    800016de:	a821                	j	800016f6 <wakeup+0x40>
        p->state = RUNNABLE;
    800016e0:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	1b0080e7          	jalr	432(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ee:	36848493          	addi	s1,s1,872
    800016f2:	03248463          	beq	s1,s2,8000171a <wakeup+0x64>
    if(p != myproc()){
    800016f6:	fffff097          	auipc	ra,0xfffff
    800016fa:	734080e7          	jalr	1844(ra) # 80000e2a <myproc>
    800016fe:	fea488e3          	beq	s1,a0,800016ee <wakeup+0x38>
      acquire(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	0de080e7          	jalr	222(ra) # 800067e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000170c:	4c9c                	lw	a5,24(s1)
    8000170e:	fd379be3          	bne	a5,s3,800016e4 <wakeup+0x2e>
    80001712:	709c                	ld	a5,32(s1)
    80001714:	fd4798e3          	bne	a5,s4,800016e4 <wakeup+0x2e>
    80001718:	b7e1                	j	800016e0 <wakeup+0x2a>
    }
  }
}
    8000171a:	70e2                	ld	ra,56(sp)
    8000171c:	7442                	ld	s0,48(sp)
    8000171e:	74a2                	ld	s1,40(sp)
    80001720:	7902                	ld	s2,32(sp)
    80001722:	69e2                	ld	s3,24(sp)
    80001724:	6a42                	ld	s4,16(sp)
    80001726:	6aa2                	ld	s5,8(sp)
    80001728:	6121                	addi	sp,sp,64
    8000172a:	8082                	ret

000000008000172c <reparent>:
{
    8000172c:	7179                	addi	sp,sp,-48
    8000172e:	f406                	sd	ra,40(sp)
    80001730:	f022                	sd	s0,32(sp)
    80001732:	ec26                	sd	s1,24(sp)
    80001734:	e84a                	sd	s2,16(sp)
    80001736:	e44e                	sd	s3,8(sp)
    80001738:	e052                	sd	s4,0(sp)
    8000173a:	1800                	addi	s0,sp,48
    8000173c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000173e:	00008497          	auipc	s1,0x8
    80001742:	d4248493          	addi	s1,s1,-702 # 80009480 <proc>
      pp->parent = initproc;
    80001746:	00008a17          	auipc	s4,0x8
    8000174a:	8caa0a13          	addi	s4,s4,-1846 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000174e:	00015997          	auipc	s3,0x15
    80001752:	73298993          	addi	s3,s3,1842 # 80016e80 <tickslock>
    80001756:	a029                	j	80001760 <reparent+0x34>
    80001758:	36848493          	addi	s1,s1,872
    8000175c:	01348d63          	beq	s1,s3,80001776 <reparent+0x4a>
    if(pp->parent == p){
    80001760:	7c9c                	ld	a5,56(s1)
    80001762:	ff279be3          	bne	a5,s2,80001758 <reparent+0x2c>
      pp->parent = initproc;
    80001766:	000a3503          	ld	a0,0(s4)
    8000176a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000176c:	00000097          	auipc	ra,0x0
    80001770:	f4a080e7          	jalr	-182(ra) # 800016b6 <wakeup>
    80001774:	b7d5                	j	80001758 <reparent+0x2c>
}
    80001776:	70a2                	ld	ra,40(sp)
    80001778:	7402                	ld	s0,32(sp)
    8000177a:	64e2                	ld	s1,24(sp)
    8000177c:	6942                	ld	s2,16(sp)
    8000177e:	69a2                	ld	s3,8(sp)
    80001780:	6a02                	ld	s4,0(sp)
    80001782:	6145                	addi	sp,sp,48
    80001784:	8082                	ret

0000000080001786 <exit>:
{
    80001786:	7135                	addi	sp,sp,-160
    80001788:	ed06                	sd	ra,152(sp)
    8000178a:	e922                	sd	s0,144(sp)
    8000178c:	e526                	sd	s1,136(sp)
    8000178e:	e14a                	sd	s2,128(sp)
    80001790:	fcce                	sd	s3,120(sp)
    80001792:	f8d2                	sd	s4,112(sp)
    80001794:	f4d6                	sd	s5,104(sp)
    80001796:	f0da                	sd	s6,96(sp)
    80001798:	ecde                	sd	s7,88(sp)
    8000179a:	e8e2                	sd	s8,80(sp)
    8000179c:	e4e6                	sd	s9,72(sp)
    8000179e:	e0ea                	sd	s10,64(sp)
    800017a0:	fc6e                	sd	s11,56(sp)
    800017a2:	1100                	addi	s0,sp,160
    800017a4:	f6a43423          	sd	a0,-152(s0)
  struct proc *p = myproc();
    800017a8:	fffff097          	auipc	ra,0xfffff
    800017ac:	682080e7          	jalr	1666(ra) # 80000e2a <myproc>
    800017b0:	f6a43c23          	sd	a0,-136(s0)
  if(p == initproc)
    800017b4:	00008797          	auipc	a5,0x8
    800017b8:	85c7b783          	ld	a5,-1956(a5) # 80009010 <initproc>
    800017bc:	f8043023          	sd	zero,-128(s0)
    800017c0:	00a78c63          	beq	a5,a0,800017d8 <exit+0x52>
    800017c4:	16850c93          	addi	s9,a0,360
          size=min(maxsize,range-i);
    800017c8:	6785                	lui	a5,0x1
    800017ca:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
    800017ce:	c007879b          	addiw	a5,a5,-1024
    800017d2:	f8f42423          	sw	a5,-120(s0)
    800017d6:	a285                	j	80001936 <exit+0x1b0>
    panic("init exiting");
    800017d8:	00007517          	auipc	a0,0x7
    800017dc:	9d850513          	addi	a0,a0,-1576 # 800081b0 <etext+0x1b0>
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	ab8080e7          	jalr	-1352(ra) # 80006298 <panic>
          size=min(maxsize,range-i);
    800017e8:	0009891b          	sext.w	s2,s3
          begin_op();
    800017ec:	00002097          	auipc	ra,0x2
    800017f0:	f90080e7          	jalr	-112(ra) # 8000377c <begin_op>
          ilock(vma->f->ip);
    800017f4:	6c9c                	ld	a5,24(s1)
    800017f6:	6f88                	ld	a0,24(a5)
    800017f8:	00001097          	auipc	ra,0x1
    800017fc:	5b2080e7          	jalr	1458(ra) # 80002daa <ilock>
          if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size)
    80001800:	48d4                	lw	a3,20(s1)
    80001802:	017686bb          	addw	a3,a3,s7
    80001806:	609c                	ld	a5,0(s1)
    80001808:	9e9d                	subw	a3,a3,a5
    8000180a:	6c9c                	ld	a5,24(s1)
    8000180c:	874a                	mv	a4,s2
    8000180e:	015686bb          	addw	a3,a3,s5
    80001812:	8662                	mv	a2,s8
    80001814:	4585                	li	a1,1
    80001816:	6f88                	ld	a0,24(a5)
    80001818:	00002097          	auipc	ra,0x2
    8000181c:	93e080e7          	jalr	-1730(ra) # 80003156 <writei>
    80001820:	2501                	sext.w	a0,a0
    80001822:	03251763          	bne	a0,s2,80001850 <exit+0xca>
          iunlock(vma->f->ip);
    80001826:	6c9c                	ld	a5,24(s1)
    80001828:	6f88                	ld	a0,24(a5)
    8000182a:	00001097          	auipc	ra,0x1
    8000182e:	642080e7          	jalr	1602(ra) # 80002e6c <iunlock>
          end_op();
    80001832:	00002097          	auipc	ra,0x2
    80001836:	fca080e7          	jalr	-54(ra) # 800037fc <end_op>
        for(int r=0;r<range;r+=size)
    8000183a:	01498a3b          	addw	s4,s3,s4
    8000183e:	056a7363          	bgeu	s4,s6,80001884 <exit+0xfe>
          size=min(maxsize,range-i);
    80001842:	f8c42983          	lw	s3,-116(s0)
    80001846:	fbadf1e3          	bgeu	s11,s10,800017e8 <exit+0x62>
    8000184a:	f8842983          	lw	s3,-120(s0)
    8000184e:	bf69                	j	800017e8 <exit+0x62>
            iunlock(vma->f->ip);
    80001850:	f7043783          	ld	a5,-144(s0)
    80001854:	00579513          	slli	a0,a5,0x5
    80001858:	f7843783          	ld	a5,-136(s0)
    8000185c:	953e                	add	a0,a0,a5
    8000185e:	18053783          	ld	a5,384(a0)
    80001862:	6f88                	ld	a0,24(a5)
    80001864:	00001097          	auipc	ra,0x1
    80001868:	608080e7          	jalr	1544(ra) # 80002e6c <iunlock>
            end_op();
    8000186c:	00002097          	auipc	ra,0x2
    80001870:	f90080e7          	jalr	-112(ra) # 800037fc <end_op>
            panic("exit: writei failed");
    80001874:	00007517          	auipc	a0,0x7
    80001878:	94c50513          	addi	a0,a0,-1716 # 800081c0 <etext+0x1c0>
    8000187c:	00005097          	auipc	ra,0x5
    80001880:	a1c080e7          	jalr	-1508(ra) # 80006298 <panic>
      for(uint64 va = vma->addr;va<vma->addr+vma->len;va+=PGSIZE)
    80001884:	6785                	lui	a5,0x1
    80001886:	9abe                	add	s5,s5,a5
    80001888:	9c3e                	add	s8,s8,a5
    8000188a:	449c                	lw	a5,8(s1)
    8000188c:	6098                	ld	a4,0(s1)
    8000188e:	97ba                	add	a5,a5,a4
    80001890:	04faf563          	bgeu	s5,a5,800018da <exit+0x154>
        pte_t* pte = walk(p->pagetable,va,0);
    80001894:	4601                	li	a2,0
    80001896:	85d6                	mv	a1,s5
    80001898:	f7843783          	ld	a5,-136(s0)
    8000189c:	6ba8                	ld	a0,80(a5)
    8000189e:	fffff097          	auipc	ra,0xfffff
    800018a2:	bc2080e7          	jalr	-1086(ra) # 80000460 <walk>
        if(pte==0 || (*pte & PTE_D)==0)
    800018a6:	dd79                	beqz	a0,80001884 <exit+0xfe>
    800018a8:	611c                	ld	a5,0(a0)
    800018aa:	0807f793          	andi	a5,a5,128
    800018ae:	dbf9                	beqz	a5,80001884 <exit+0xfe>
        range = min(vma->addr+vma->len-va,PGSIZE);
    800018b0:	0084ab03          	lw	s6,8(s1)
    800018b4:	609c                	ld	a5,0(s1)
    800018b6:	9b3e                	add	s6,s6,a5
    800018b8:	415b0b33          	sub	s6,s6,s5
    800018bc:	6785                	lui	a5,0x1
    800018be:	0167f363          	bgeu	a5,s6,800018c4 <exit+0x13e>
    800018c2:	6b05                	lui	s6,0x1
    800018c4:	2b01                	sext.w	s6,s6
        for(int r=0;r<range;r+=size)
    800018c6:	fa0b0fe3          	beqz	s6,80001884 <exit+0xfe>
    800018ca:	4a01                	li	s4,0
          size=min(maxsize,range-i);
    800018cc:	417b07bb          	subw	a5,s6,s7
    800018d0:	f8f42623          	sw	a5,-116(s0)
    800018d4:	00078d1b          	sext.w	s10,a5
    800018d8:	b7ad                	j	80001842 <exit+0xbc>
    uvmunmap(p->pagetable, vma->addr, (vma->len - 1) / PGSIZE + 1, 1);
    800018da:	4490                	lw	a2,8(s1)
    800018dc:	fff6079b          	addiw	a5,a2,-1
    800018e0:	41f7d61b          	sraiw	a2,a5,0x1f
    800018e4:	0146561b          	srliw	a2,a2,0x14
    800018e8:	9e3d                	addw	a2,a2,a5
    800018ea:	40c6561b          	sraiw	a2,a2,0xc
    800018ee:	4685                	li	a3,1
    800018f0:	2605                	addiw	a2,a2,1
    800018f2:	608c                	ld	a1,0(s1)
    800018f4:	f7843783          	ld	a5,-136(s0)
    800018f8:	6ba8                	ld	a0,80(a5)
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	e14080e7          	jalr	-492(ra) # 8000070e <uvmunmap>
    vma->addr = 0;
    80001902:	0004b023          	sd	zero,0(s1)
    vma->len = 0;
    80001906:	0004a423          	sw	zero,8(s1)
    vma->offset = 0;
    8000190a:	0004aa23          	sw	zero,20(s1)
    vma->flags = 0;
    8000190e:	0004a823          	sw	zero,16(s1)
    fileclose(vma->f);
    80001912:	6c88                	ld	a0,24(s1)
    80001914:	00002097          	auipc	ra,0x2
    80001918:	334080e7          	jalr	820(ra) # 80003c48 <fileclose>
    vma->f = 0;
    8000191c:	0004bc23          	sd	zero,24(s1)
  for(int i=0;i<NVMA;i++)
    80001920:	f8043783          	ld	a5,-128(s0)
    80001924:	0785                	addi	a5,a5,1
    80001926:	873e                	mv	a4,a5
    80001928:	f8f43023          	sd	a5,-128(s0)
    8000192c:	020c8c93          	addi	s9,s9,32
    80001930:	47c1                	li	a5,16
    80001932:	02f70963          	beq	a4,a5,80001964 <exit+0x1de>
    80001936:	f8043683          	ld	a3,-128(s0)
    8000193a:	00068b9b          	sext.w	s7,a3
    8000193e:	f7743823          	sd	s7,-144(s0)
    if(p->vma[i].addr==0)
    80001942:	84e6                	mv	s1,s9
    80001944:	000cba83          	ld	s5,0(s9)
    80001948:	fc0a8ce3          	beqz	s5,80001920 <exit+0x19a>
    if(vma->flags & MAP_SHARED)
    8000194c:	010ca783          	lw	a5,16(s9)
    80001950:	8b85                	andi	a5,a5,1
    80001952:	d7c1                	beqz	a5,800018da <exit+0x154>
      for(uint64 va = vma->addr;va<vma->addr+vma->len;va+=PGSIZE)
    80001954:	008ca783          	lw	a5,8(s9)
    80001958:	97d6                	add	a5,a5,s5
    8000195a:	f8faf0e3          	bgeu	s5,a5,800018da <exit+0x154>
    8000195e:	00da8c33          	add	s8,s5,a3
    80001962:	bf0d                	j	80001894 <exit+0x10e>
    80001964:	f7843783          	ld	a5,-136(s0)
    80001968:	0d078493          	addi	s1,a5,208 # 10d0 <_entry-0x7fffef30>
    8000196c:	15078913          	addi	s2,a5,336
    80001970:	a021                	j	80001978 <exit+0x1f2>
  for(int fd = 0; fd < NOFILE; fd++){
    80001972:	04a1                	addi	s1,s1,8
    80001974:	00990b63          	beq	s2,s1,8000198a <exit+0x204>
    if(p->ofile[fd]){
    80001978:	6088                	ld	a0,0(s1)
    8000197a:	dd65                	beqz	a0,80001972 <exit+0x1ec>
      fileclose(f);
    8000197c:	00002097          	auipc	ra,0x2
    80001980:	2cc080e7          	jalr	716(ra) # 80003c48 <fileclose>
      p->ofile[fd] = 0;
    80001984:	0004b023          	sd	zero,0(s1)
    80001988:	b7ed                	j	80001972 <exit+0x1ec>
  begin_op();
    8000198a:	00002097          	auipc	ra,0x2
    8000198e:	df2080e7          	jalr	-526(ra) # 8000377c <begin_op>
  iput(p->cwd);
    80001992:	f7843903          	ld	s2,-136(s0)
    80001996:	15093503          	ld	a0,336(s2)
    8000199a:	00001097          	auipc	ra,0x1
    8000199e:	5ca080e7          	jalr	1482(ra) # 80002f64 <iput>
  end_op();
    800019a2:	00002097          	auipc	ra,0x2
    800019a6:	e5a080e7          	jalr	-422(ra) # 800037fc <end_op>
  p->cwd = 0;
    800019aa:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800019ae:	00007497          	auipc	s1,0x7
    800019b2:	6ba48493          	addi	s1,s1,1722 # 80009068 <wait_lock>
    800019b6:	8526                	mv	a0,s1
    800019b8:	00005097          	auipc	ra,0x5
    800019bc:	e2a080e7          	jalr	-470(ra) # 800067e2 <acquire>
  reparent(p);
    800019c0:	854a                	mv	a0,s2
    800019c2:	00000097          	auipc	ra,0x0
    800019c6:	d6a080e7          	jalr	-662(ra) # 8000172c <reparent>
  wakeup(p->parent);
    800019ca:	03893503          	ld	a0,56(s2)
    800019ce:	00000097          	auipc	ra,0x0
    800019d2:	ce8080e7          	jalr	-792(ra) # 800016b6 <wakeup>
  acquire(&p->lock);
    800019d6:	854a                	mv	a0,s2
    800019d8:	00005097          	auipc	ra,0x5
    800019dc:	e0a080e7          	jalr	-502(ra) # 800067e2 <acquire>
  p->xstate = status;
    800019e0:	f6843783          	ld	a5,-152(s0)
    800019e4:	02f92623          	sw	a5,44(s2)
  p->state = ZOMBIE;
    800019e8:	4795                	li	a5,5
    800019ea:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	ea6080e7          	jalr	-346(ra) # 80006896 <release>
  sched();
    800019f8:	00000097          	auipc	ra,0x0
    800019fc:	a20080e7          	jalr	-1504(ra) # 80001418 <sched>
  panic("zombie exit");
    80001a00:	00006517          	auipc	a0,0x6
    80001a04:	7d850513          	addi	a0,a0,2008 # 800081d8 <etext+0x1d8>
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	890080e7          	jalr	-1904(ra) # 80006298 <panic>

0000000080001a10 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a10:	7179                	addi	sp,sp,-48
    80001a12:	f406                	sd	ra,40(sp)
    80001a14:	f022                	sd	s0,32(sp)
    80001a16:	ec26                	sd	s1,24(sp)
    80001a18:	e84a                	sd	s2,16(sp)
    80001a1a:	e44e                	sd	s3,8(sp)
    80001a1c:	1800                	addi	s0,sp,48
    80001a1e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	00008497          	auipc	s1,0x8
    80001a24:	a6048493          	addi	s1,s1,-1440 # 80009480 <proc>
    80001a28:	00015997          	auipc	s3,0x15
    80001a2c:	45898993          	addi	s3,s3,1112 # 80016e80 <tickslock>
    acquire(&p->lock);
    80001a30:	8526                	mv	a0,s1
    80001a32:	00005097          	auipc	ra,0x5
    80001a36:	db0080e7          	jalr	-592(ra) # 800067e2 <acquire>
    if(p->pid == pid){
    80001a3a:	589c                	lw	a5,48(s1)
    80001a3c:	01278d63          	beq	a5,s2,80001a56 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a40:	8526                	mv	a0,s1
    80001a42:	00005097          	auipc	ra,0x5
    80001a46:	e54080e7          	jalr	-428(ra) # 80006896 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a4a:	36848493          	addi	s1,s1,872
    80001a4e:	ff3491e3          	bne	s1,s3,80001a30 <kill+0x20>
  }
  return -1;
    80001a52:	557d                	li	a0,-1
    80001a54:	a829                	j	80001a6e <kill+0x5e>
      p->killed = 1;
    80001a56:	4785                	li	a5,1
    80001a58:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a5a:	4c98                	lw	a4,24(s1)
    80001a5c:	4789                	li	a5,2
    80001a5e:	00f70f63          	beq	a4,a5,80001a7c <kill+0x6c>
      release(&p->lock);
    80001a62:	8526                	mv	a0,s1
    80001a64:	00005097          	auipc	ra,0x5
    80001a68:	e32080e7          	jalr	-462(ra) # 80006896 <release>
      return 0;
    80001a6c:	4501                	li	a0,0
}
    80001a6e:	70a2                	ld	ra,40(sp)
    80001a70:	7402                	ld	s0,32(sp)
    80001a72:	64e2                	ld	s1,24(sp)
    80001a74:	6942                	ld	s2,16(sp)
    80001a76:	69a2                	ld	s3,8(sp)
    80001a78:	6145                	addi	sp,sp,48
    80001a7a:	8082                	ret
        p->state = RUNNABLE;
    80001a7c:	478d                	li	a5,3
    80001a7e:	cc9c                	sw	a5,24(s1)
    80001a80:	b7cd                	j	80001a62 <kill+0x52>

0000000080001a82 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a82:	7179                	addi	sp,sp,-48
    80001a84:	f406                	sd	ra,40(sp)
    80001a86:	f022                	sd	s0,32(sp)
    80001a88:	ec26                	sd	s1,24(sp)
    80001a8a:	e84a                	sd	s2,16(sp)
    80001a8c:	e44e                	sd	s3,8(sp)
    80001a8e:	e052                	sd	s4,0(sp)
    80001a90:	1800                	addi	s0,sp,48
    80001a92:	84aa                	mv	s1,a0
    80001a94:	892e                	mv	s2,a1
    80001a96:	89b2                	mv	s3,a2
    80001a98:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a9a:	fffff097          	auipc	ra,0xfffff
    80001a9e:	390080e7          	jalr	912(ra) # 80000e2a <myproc>
  if(user_dst){
    80001aa2:	c08d                	beqz	s1,80001ac4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001aa4:	86d2                	mv	a3,s4
    80001aa6:	864e                	mv	a2,s3
    80001aa8:	85ca                	mv	a1,s2
    80001aaa:	6928                	ld	a0,80(a0)
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	040080e7          	jalr	64(ra) # 80000aec <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ab4:	70a2                	ld	ra,40(sp)
    80001ab6:	7402                	ld	s0,32(sp)
    80001ab8:	64e2                	ld	s1,24(sp)
    80001aba:	6942                	ld	s2,16(sp)
    80001abc:	69a2                	ld	s3,8(sp)
    80001abe:	6a02                	ld	s4,0(sp)
    80001ac0:	6145                	addi	sp,sp,48
    80001ac2:	8082                	ret
    memmove((char *)dst, src, len);
    80001ac4:	000a061b          	sext.w	a2,s4
    80001ac8:	85ce                	mv	a1,s3
    80001aca:	854a                	mv	a0,s2
    80001acc:	ffffe097          	auipc	ra,0xffffe
    80001ad0:	70c080e7          	jalr	1804(ra) # 800001d8 <memmove>
    return 0;
    80001ad4:	8526                	mv	a0,s1
    80001ad6:	bff9                	j	80001ab4 <either_copyout+0x32>

0000000080001ad8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ad8:	7179                	addi	sp,sp,-48
    80001ada:	f406                	sd	ra,40(sp)
    80001adc:	f022                	sd	s0,32(sp)
    80001ade:	ec26                	sd	s1,24(sp)
    80001ae0:	e84a                	sd	s2,16(sp)
    80001ae2:	e44e                	sd	s3,8(sp)
    80001ae4:	e052                	sd	s4,0(sp)
    80001ae6:	1800                	addi	s0,sp,48
    80001ae8:	892a                	mv	s2,a0
    80001aea:	84ae                	mv	s1,a1
    80001aec:	89b2                	mv	s3,a2
    80001aee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	33a080e7          	jalr	826(ra) # 80000e2a <myproc>
  if(user_src){
    80001af8:	c08d                	beqz	s1,80001b1a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001afa:	86d2                	mv	a3,s4
    80001afc:	864e                	mv	a2,s3
    80001afe:	85ca                	mv	a1,s2
    80001b00:	6928                	ld	a0,80(a0)
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	076080e7          	jalr	118(ra) # 80000b78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b0a:	70a2                	ld	ra,40(sp)
    80001b0c:	7402                	ld	s0,32(sp)
    80001b0e:	64e2                	ld	s1,24(sp)
    80001b10:	6942                	ld	s2,16(sp)
    80001b12:	69a2                	ld	s3,8(sp)
    80001b14:	6a02                	ld	s4,0(sp)
    80001b16:	6145                	addi	sp,sp,48
    80001b18:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b1a:	000a061b          	sext.w	a2,s4
    80001b1e:	85ce                	mv	a1,s3
    80001b20:	854a                	mv	a0,s2
    80001b22:	ffffe097          	auipc	ra,0xffffe
    80001b26:	6b6080e7          	jalr	1718(ra) # 800001d8 <memmove>
    return 0;
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	bff9                	j	80001b0a <either_copyin+0x32>

0000000080001b2e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b2e:	715d                	addi	sp,sp,-80
    80001b30:	e486                	sd	ra,72(sp)
    80001b32:	e0a2                	sd	s0,64(sp)
    80001b34:	fc26                	sd	s1,56(sp)
    80001b36:	f84a                	sd	s2,48(sp)
    80001b38:	f44e                	sd	s3,40(sp)
    80001b3a:	f052                	sd	s4,32(sp)
    80001b3c:	ec56                	sd	s5,24(sp)
    80001b3e:	e85a                	sd	s6,16(sp)
    80001b40:	e45e                	sd	s7,8(sp)
    80001b42:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b44:	00006517          	auipc	a0,0x6
    80001b48:	50450513          	addi	a0,a0,1284 # 80008048 <etext+0x48>
    80001b4c:	00004097          	auipc	ra,0x4
    80001b50:	796080e7          	jalr	1942(ra) # 800062e2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b54:	00008497          	auipc	s1,0x8
    80001b58:	a8448493          	addi	s1,s1,-1404 # 800095d8 <proc+0x158>
    80001b5c:	00015917          	auipc	s2,0x15
    80001b60:	47c90913          	addi	s2,s2,1148 # 80016fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b64:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b66:	00006997          	auipc	s3,0x6
    80001b6a:	68298993          	addi	s3,s3,1666 # 800081e8 <etext+0x1e8>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6e:	00006a97          	auipc	s5,0x6
    80001b72:	682a8a93          	addi	s5,s5,1666 # 800081f0 <etext+0x1f0>
    printf("\n");
    80001b76:	00006a17          	auipc	s4,0x6
    80001b7a:	4d2a0a13          	addi	s4,s4,1234 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b7e:	00006b97          	auipc	s7,0x6
    80001b82:	6aab8b93          	addi	s7,s7,1706 # 80008228 <states.1799>
    80001b86:	a00d                	j	80001ba8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b88:	ed86a583          	lw	a1,-296(a3)
    80001b8c:	8556                	mv	a0,s5
    80001b8e:	00004097          	auipc	ra,0x4
    80001b92:	754080e7          	jalr	1876(ra) # 800062e2 <printf>
    printf("\n");
    80001b96:	8552                	mv	a0,s4
    80001b98:	00004097          	auipc	ra,0x4
    80001b9c:	74a080e7          	jalr	1866(ra) # 800062e2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba0:	36848493          	addi	s1,s1,872
    80001ba4:	03248163          	beq	s1,s2,80001bc6 <procdump+0x98>
    if(p->state == UNUSED)
    80001ba8:	86a6                	mv	a3,s1
    80001baa:	ec04a783          	lw	a5,-320(s1)
    80001bae:	dbed                	beqz	a5,80001ba0 <procdump+0x72>
      state = "???";
    80001bb0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb2:	fcfb6be3          	bltu	s6,a5,80001b88 <procdump+0x5a>
    80001bb6:	1782                	slli	a5,a5,0x20
    80001bb8:	9381                	srli	a5,a5,0x20
    80001bba:	078e                	slli	a5,a5,0x3
    80001bbc:	97de                	add	a5,a5,s7
    80001bbe:	6390                	ld	a2,0(a5)
    80001bc0:	f661                	bnez	a2,80001b88 <procdump+0x5a>
      state = "???";
    80001bc2:	864e                	mv	a2,s3
    80001bc4:	b7d1                	j	80001b88 <procdump+0x5a>
  }
}
    80001bc6:	60a6                	ld	ra,72(sp)
    80001bc8:	6406                	ld	s0,64(sp)
    80001bca:	74e2                	ld	s1,56(sp)
    80001bcc:	7942                	ld	s2,48(sp)
    80001bce:	79a2                	ld	s3,40(sp)
    80001bd0:	7a02                	ld	s4,32(sp)
    80001bd2:	6ae2                	ld	s5,24(sp)
    80001bd4:	6b42                	ld	s6,16(sp)
    80001bd6:	6ba2                	ld	s7,8(sp)
    80001bd8:	6161                	addi	sp,sp,80
    80001bda:	8082                	ret

0000000080001bdc <swtch>:
    80001bdc:	00153023          	sd	ra,0(a0)
    80001be0:	00253423          	sd	sp,8(a0)
    80001be4:	e900                	sd	s0,16(a0)
    80001be6:	ed04                	sd	s1,24(a0)
    80001be8:	03253023          	sd	s2,32(a0)
    80001bec:	03353423          	sd	s3,40(a0)
    80001bf0:	03453823          	sd	s4,48(a0)
    80001bf4:	03553c23          	sd	s5,56(a0)
    80001bf8:	05653023          	sd	s6,64(a0)
    80001bfc:	05753423          	sd	s7,72(a0)
    80001c00:	05853823          	sd	s8,80(a0)
    80001c04:	05953c23          	sd	s9,88(a0)
    80001c08:	07a53023          	sd	s10,96(a0)
    80001c0c:	07b53423          	sd	s11,104(a0)
    80001c10:	0005b083          	ld	ra,0(a1)
    80001c14:	0085b103          	ld	sp,8(a1)
    80001c18:	6980                	ld	s0,16(a1)
    80001c1a:	6d84                	ld	s1,24(a1)
    80001c1c:	0205b903          	ld	s2,32(a1)
    80001c20:	0285b983          	ld	s3,40(a1)
    80001c24:	0305ba03          	ld	s4,48(a1)
    80001c28:	0385ba83          	ld	s5,56(a1)
    80001c2c:	0405bb03          	ld	s6,64(a1)
    80001c30:	0485bb83          	ld	s7,72(a1)
    80001c34:	0505bc03          	ld	s8,80(a1)
    80001c38:	0585bc83          	ld	s9,88(a1)
    80001c3c:	0605bd03          	ld	s10,96(a1)
    80001c40:	0685bd83          	ld	s11,104(a1)
    80001c44:	8082                	ret

0000000080001c46 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c46:	1141                	addi	sp,sp,-16
    80001c48:	e406                	sd	ra,8(sp)
    80001c4a:	e022                	sd	s0,0(sp)
    80001c4c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c4e:	00006597          	auipc	a1,0x6
    80001c52:	60a58593          	addi	a1,a1,1546 # 80008258 <states.1799+0x30>
    80001c56:	00015517          	auipc	a0,0x15
    80001c5a:	22a50513          	addi	a0,a0,554 # 80016e80 <tickslock>
    80001c5e:	00005097          	auipc	ra,0x5
    80001c62:	af4080e7          	jalr	-1292(ra) # 80006752 <initlock>
}
    80001c66:	60a2                	ld	ra,8(sp)
    80001c68:	6402                	ld	s0,0(sp)
    80001c6a:	0141                	addi	sp,sp,16
    80001c6c:	8082                	ret

0000000080001c6e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c6e:	1141                	addi	sp,sp,-16
    80001c70:	e422                	sd	s0,8(sp)
    80001c72:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c74:	00004797          	auipc	a5,0x4
    80001c78:	a2c78793          	addi	a5,a5,-1492 # 800056a0 <kernelvec>
    80001c7c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c80:	6422                	ld	s0,8(sp)
    80001c82:	0141                	addi	sp,sp,16
    80001c84:	8082                	ret

0000000080001c86 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c86:	1141                	addi	sp,sp,-16
    80001c88:	e406                	sd	ra,8(sp)
    80001c8a:	e022                	sd	s0,0(sp)
    80001c8c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	19c080e7          	jalr	412(ra) # 80000e2a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c9a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c9c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ca0:	00005617          	auipc	a2,0x5
    80001ca4:	36060613          	addi	a2,a2,864 # 80007000 <_trampoline>
    80001ca8:	00005697          	auipc	a3,0x5
    80001cac:	35868693          	addi	a3,a3,856 # 80007000 <_trampoline>
    80001cb0:	8e91                	sub	a3,a3,a2
    80001cb2:	040007b7          	lui	a5,0x4000
    80001cb6:	17fd                	addi	a5,a5,-1
    80001cb8:	07b2                	slli	a5,a5,0xc
    80001cba:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbc:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cc2:	180026f3          	csrr	a3,satp
    80001cc6:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cc8:	6d38                	ld	a4,88(a0)
    80001cca:	6134                	ld	a3,64(a0)
    80001ccc:	6585                	lui	a1,0x1
    80001cce:	96ae                	add	a3,a3,a1
    80001cd0:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cd2:	6d38                	ld	a4,88(a0)
    80001cd4:	00000697          	auipc	a3,0x0
    80001cd8:	13868693          	addi	a3,a3,312 # 80001e0c <usertrap>
    80001cdc:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cde:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce0:	8692                	mv	a3,tp
    80001ce2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ce8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cec:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cf4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cf6:	6f18                	ld	a4,24(a4)
    80001cf8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cfc:	692c                	ld	a1,80(a0)
    80001cfe:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d00:	00005717          	auipc	a4,0x5
    80001d04:	39070713          	addi	a4,a4,912 # 80007090 <userret>
    80001d08:	8f11                	sub	a4,a4,a2
    80001d0a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d0c:	577d                	li	a4,-1
    80001d0e:	177e                	slli	a4,a4,0x3f
    80001d10:	8dd9                	or	a1,a1,a4
    80001d12:	02000537          	lui	a0,0x2000
    80001d16:	157d                	addi	a0,a0,-1
    80001d18:	0536                	slli	a0,a0,0xd
    80001d1a:	9782                	jalr	a5
}
    80001d1c:	60a2                	ld	ra,8(sp)
    80001d1e:	6402                	ld	s0,0(sp)
    80001d20:	0141                	addi	sp,sp,16
    80001d22:	8082                	ret

0000000080001d24 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d24:	1101                	addi	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	e426                	sd	s1,8(sp)
    80001d2c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d2e:	00015497          	auipc	s1,0x15
    80001d32:	15248493          	addi	s1,s1,338 # 80016e80 <tickslock>
    80001d36:	8526                	mv	a0,s1
    80001d38:	00005097          	auipc	ra,0x5
    80001d3c:	aaa080e7          	jalr	-1366(ra) # 800067e2 <acquire>
  ticks++;
    80001d40:	00007517          	auipc	a0,0x7
    80001d44:	2d850513          	addi	a0,a0,728 # 80009018 <ticks>
    80001d48:	411c                	lw	a5,0(a0)
    80001d4a:	2785                	addiw	a5,a5,1
    80001d4c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	968080e7          	jalr	-1688(ra) # 800016b6 <wakeup>
  release(&tickslock);
    80001d56:	8526                	mv	a0,s1
    80001d58:	00005097          	auipc	ra,0x5
    80001d5c:	b3e080e7          	jalr	-1218(ra) # 80006896 <release>
}
    80001d60:	60e2                	ld	ra,24(sp)
    80001d62:	6442                	ld	s0,16(sp)
    80001d64:	64a2                	ld	s1,8(sp)
    80001d66:	6105                	addi	sp,sp,32
    80001d68:	8082                	ret

0000000080001d6a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d6a:	1101                	addi	sp,sp,-32
    80001d6c:	ec06                	sd	ra,24(sp)
    80001d6e:	e822                	sd	s0,16(sp)
    80001d70:	e426                	sd	s1,8(sp)
    80001d72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d74:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d78:	00074d63          	bltz	a4,80001d92 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d7c:	57fd                	li	a5,-1
    80001d7e:	17fe                	slli	a5,a5,0x3f
    80001d80:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d82:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d84:	06f70363          	beq	a4,a5,80001dea <devintr+0x80>
  }
}
    80001d88:	60e2                	ld	ra,24(sp)
    80001d8a:	6442                	ld	s0,16(sp)
    80001d8c:	64a2                	ld	s1,8(sp)
    80001d8e:	6105                	addi	sp,sp,32
    80001d90:	8082                	ret
     (scause & 0xff) == 9){
    80001d92:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d96:	46a5                	li	a3,9
    80001d98:	fed792e3          	bne	a5,a3,80001d7c <devintr+0x12>
    int irq = plic_claim();
    80001d9c:	00004097          	auipc	ra,0x4
    80001da0:	a0c080e7          	jalr	-1524(ra) # 800057a8 <plic_claim>
    80001da4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001da6:	47a9                	li	a5,10
    80001da8:	02f50763          	beq	a0,a5,80001dd6 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dac:	4785                	li	a5,1
    80001dae:	02f50963          	beq	a0,a5,80001de0 <devintr+0x76>
    return 1;
    80001db2:	4505                	li	a0,1
    } else if(irq){
    80001db4:	d8f1                	beqz	s1,80001d88 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001db6:	85a6                	mv	a1,s1
    80001db8:	00006517          	auipc	a0,0x6
    80001dbc:	4a850513          	addi	a0,a0,1192 # 80008260 <states.1799+0x38>
    80001dc0:	00004097          	auipc	ra,0x4
    80001dc4:	522080e7          	jalr	1314(ra) # 800062e2 <printf>
      plic_complete(irq);
    80001dc8:	8526                	mv	a0,s1
    80001dca:	00004097          	auipc	ra,0x4
    80001dce:	a02080e7          	jalr	-1534(ra) # 800057cc <plic_complete>
    return 1;
    80001dd2:	4505                	li	a0,1
    80001dd4:	bf55                	j	80001d88 <devintr+0x1e>
      uartintr();
    80001dd6:	00005097          	auipc	ra,0x5
    80001dda:	92c080e7          	jalr	-1748(ra) # 80006702 <uartintr>
    80001dde:	b7ed                	j	80001dc8 <devintr+0x5e>
      virtio_disk_intr();
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	ecc080e7          	jalr	-308(ra) # 80005cac <virtio_disk_intr>
    80001de8:	b7c5                	j	80001dc8 <devintr+0x5e>
    if(cpuid() == 0){
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	014080e7          	jalr	20(ra) # 80000dfe <cpuid>
    80001df2:	c901                	beqz	a0,80001e02 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001df4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001df8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dfa:	14479073          	csrw	sip,a5
    return 2;
    80001dfe:	4509                	li	a0,2
    80001e00:	b761                	j	80001d88 <devintr+0x1e>
      clockintr();
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	f22080e7          	jalr	-222(ra) # 80001d24 <clockintr>
    80001e0a:	b7ed                	j	80001df4 <devintr+0x8a>

0000000080001e0c <usertrap>:
{
    80001e0c:	7139                	addi	sp,sp,-64
    80001e0e:	fc06                	sd	ra,56(sp)
    80001e10:	f822                	sd	s0,48(sp)
    80001e12:	f426                	sd	s1,40(sp)
    80001e14:	f04a                	sd	s2,32(sp)
    80001e16:	ec4e                	sd	s3,24(sp)
    80001e18:	e852                	sd	s4,16(sp)
    80001e1a:	e456                	sd	s5,8(sp)
    80001e1c:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e22:	1007f793          	andi	a5,a5,256
    80001e26:	efb1                	bnez	a5,80001e82 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e28:	00004797          	auipc	a5,0x4
    80001e2c:	87878793          	addi	a5,a5,-1928 # 800056a0 <kernelvec>
    80001e30:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	ff6080e7          	jalr	-10(ra) # 80000e2a <myproc>
    80001e3c:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001e3e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e40:	14102773          	csrr	a4,sepc
    80001e44:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e46:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4a:	47a1                	li	a5,8
    80001e4c:	04f70363          	beq	a4,a5,80001e92 <usertrap+0x86>
    80001e50:	14202773          	csrr	a4,scause
  else if(r_scause() == 12||r_scause() == 13||r_scause() == 15)
    80001e54:	47b1                	li	a5,12
    80001e56:	00f70c63          	beq	a4,a5,80001e6e <usertrap+0x62>
    80001e5a:	14202773          	csrr	a4,scause
    80001e5e:	47b5                	li	a5,13
    80001e60:	00f70763          	beq	a4,a5,80001e6e <usertrap+0x62>
    80001e64:	14202773          	csrr	a4,scause
    80001e68:	47bd                	li	a5,15
    80001e6a:	1ef71463          	bne	a4,a5,80002052 <usertrap+0x246>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e6e:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001e72:	77fd                	lui	a5,0xfffff
    80001e74:	00f9f9b3          	and	s3,s3,a5
    for(int i=0;i<NVMA;i++)
    80001e78:	16890793          	addi	a5,s2,360
    80001e7c:	4481                	li	s1,0
    80001e7e:	4641                	li	a2,16
    80001e80:	a0b5                	j	80001eec <usertrap+0xe0>
    panic("usertrap: not from user mode");
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	3fe50513          	addi	a0,a0,1022 # 80008280 <states.1799+0x58>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	40e080e7          	jalr	1038(ra) # 80006298 <panic>
    if(p->killed)
    80001e92:	551c                	lw	a5,40(a0)
    80001e94:	e3a9                	bnez	a5,80001ed6 <usertrap+0xca>
    p->trapframe->epc += 4;
    80001e96:	05893703          	ld	a4,88(s2)
    80001e9a:	6f1c                	ld	a5,24(a4)
    80001e9c:	0791                	addi	a5,a5,4
    80001e9e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ea4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ea8:	10079073          	csrw	sstatus,a5
    syscall();
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	400080e7          	jalr	1024(ra) # 800022ac <syscall>
  if(p->killed)
    80001eb4:	02892783          	lw	a5,40(s2)
    80001eb8:	1a079763          	bnez	a5,80002066 <usertrap+0x25a>
  usertrapret();
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	dca080e7          	jalr	-566(ra) # 80001c86 <usertrapret>
}
    80001ec4:	70e2                	ld	ra,56(sp)
    80001ec6:	7442                	ld	s0,48(sp)
    80001ec8:	74a2                	ld	s1,40(sp)
    80001eca:	7902                	ld	s2,32(sp)
    80001ecc:	69e2                	ld	s3,24(sp)
    80001ece:	6a42                	ld	s4,16(sp)
    80001ed0:	6aa2                	ld	s5,8(sp)
    80001ed2:	6121                	addi	sp,sp,64
    80001ed4:	8082                	ret
      exit(-1);
    80001ed6:	557d                	li	a0,-1
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	8ae080e7          	jalr	-1874(ra) # 80001786 <exit>
    80001ee0:	bf5d                	j	80001e96 <usertrap+0x8a>
    for(int i=0;i<NVMA;i++)
    80001ee2:	2485                	addiw	s1,s1,1
    80001ee4:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    80001ee8:	10c48663          	beq	s1,a2,80001ff4 <usertrap+0x1e8>
      if (p->vma[i].addr && va >= p->vma[i].addr
    80001eec:	6398                	ld	a4,0(a5)
    80001eee:	db75                	beqz	a4,80001ee2 <usertrap+0xd6>
    80001ef0:	fee9e9e3          	bltu	s3,a4,80001ee2 <usertrap+0xd6>
          && va < p->vma[i].addr + p->vma[i].len) {
    80001ef4:	4794                	lw	a3,8(a5)
    80001ef6:	9736                	add	a4,a4,a3
    80001ef8:	fee9f5e3          	bgeu	s3,a4,80001ee2 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efc:	14202773          	csrr	a4,scause
    if (r_scause() == 15 && (vma->prot & PROT_WRITE) && walkaddr(p->pagetable, va)) 
    80001f00:	47bd                	li	a5,15
    80001f02:	00f71963          	bne	a4,a5,80001f14 <usertrap+0x108>
    80001f06:	00b48793          	addi	a5,s1,11
    80001f0a:	0796                	slli	a5,a5,0x5
    80001f0c:	97ca                	add	a5,a5,s2
    80001f0e:	4bdc                	lw	a5,20(a5)
    80001f10:	8b89                	andi	a5,a5,2
    80001f12:	e7c5                	bnez	a5,80001fba <usertrap+0x1ae>
      if ((pa = kalloc()) == 0) 
    80001f14:	ffffe097          	auipc	ra,0xffffe
    80001f18:	204080e7          	jalr	516(ra) # 80000118 <kalloc>
    80001f1c:	8a2a                	mv	s4,a0
    80001f1e:	c979                	beqz	a0,80001ff4 <usertrap+0x1e8>
      memset(pa, 0, PGSIZE);
    80001f20:	6605                	lui	a2,0x1
    80001f22:	4581                	li	a1,0
    80001f24:	ffffe097          	auipc	ra,0xffffe
    80001f28:	254080e7          	jalr	596(ra) # 80000178 <memset>
      ilock(vma->f->ip);
    80001f2c:	00549a93          	slli	s5,s1,0x5
    80001f30:	9aca                	add	s5,s5,s2
    80001f32:	180ab783          	ld	a5,384(s5)
    80001f36:	6f88                	ld	a0,24(a5)
    80001f38:	00001097          	auipc	ra,0x1
    80001f3c:	e72080e7          	jalr	-398(ra) # 80002daa <ilock>
      if (readi(vma->f->ip, 0, (uint64) pa, va - vma->addr + vma->offset, PGSIZE) < 0) 
    80001f40:	17caa783          	lw	a5,380(s5)
    80001f44:	013787bb          	addw	a5,a5,s3
    80001f48:	168ab683          	ld	a3,360(s5)
    80001f4c:	180ab503          	ld	a0,384(s5)
    80001f50:	6705                	lui	a4,0x1
    80001f52:	40d786bb          	subw	a3,a5,a3
    80001f56:	8652                	mv	a2,s4
    80001f58:	4581                	li	a1,0
    80001f5a:	6d08                	ld	a0,24(a0)
    80001f5c:	00001097          	auipc	ra,0x1
    80001f60:	102080e7          	jalr	258(ra) # 8000305e <readi>
    80001f64:	08054163          	bltz	a0,80001fe6 <usertrap+0x1da>
      iunlock(vma->f->ip);
    80001f68:	0496                	slli	s1,s1,0x5
    80001f6a:	94ca                	add	s1,s1,s2
    80001f6c:	1804b783          	ld	a5,384(s1)
    80001f70:	6f88                	ld	a0,24(a5)
    80001f72:	00001097          	auipc	ra,0x1
    80001f76:	efa080e7          	jalr	-262(ra) # 80002e6c <iunlock>
      if ((vma->prot & PROT_READ)) 
    80001f7a:	174aa783          	lw	a5,372(s5)
    80001f7e:	0017f693          	andi	a3,a5,1
    int flags = PTE_U;
    80001f82:	4741                	li	a4,16
      if ((vma->prot & PROT_READ)) 
    80001f84:	c291                	beqz	a3,80001f88 <usertrap+0x17c>
        flags |= PTE_R;
    80001f86:	4749                	li	a4,18
    80001f88:	14202673          	csrr	a2,scause
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) 
    80001f8c:	46bd                	li	a3,15
    80001f8e:	0ad60c63          	beq	a2,a3,80002046 <usertrap+0x23a>
      if ((vma->prot & PROT_EXEC)) 
    80001f92:	8b91                	andi	a5,a5,4
    80001f94:	c399                	beqz	a5,80001f9a <usertrap+0x18e>
        flags |= PTE_X;
    80001f96:	00876713          	ori	a4,a4,8
      if (mappages(p->pagetable, va, PGSIZE, (uint64) pa, flags) != 0) 
    80001f9a:	86d2                	mv	a3,s4
    80001f9c:	6605                	lui	a2,0x1
    80001f9e:	85ce                	mv	a1,s3
    80001fa0:	05093503          	ld	a0,80(s2)
    80001fa4:	ffffe097          	auipc	ra,0xffffe
    80001fa8:	5a4080e7          	jalr	1444(ra) # 80000548 <mappages>
    80001fac:	d501                	beqz	a0,80001eb4 <usertrap+0xa8>
        kfree(pa);
    80001fae:	8552                	mv	a0,s4
    80001fb0:	ffffe097          	auipc	ra,0xffffe
    80001fb4:	06c080e7          	jalr	108(ra) # 8000001c <kfree>
        goto err;
    80001fb8:	a835                	j	80001ff4 <usertrap+0x1e8>
    if (r_scause() == 15 && (vma->prot & PROT_WRITE) && walkaddr(p->pagetable, va)) 
    80001fba:	85ce                	mv	a1,s3
    80001fbc:	05093503          	ld	a0,80(s2)
    80001fc0:	ffffe097          	auipc	ra,0xffffe
    80001fc4:	546080e7          	jalr	1350(ra) # 80000506 <walkaddr>
    80001fc8:	d531                	beqz	a0,80001f14 <usertrap+0x108>
      pte_t* pte = walk(p->pagetable,va,0);
    80001fca:	4601                	li	a2,0
    80001fcc:	85ce                	mv	a1,s3
    80001fce:	05093503          	ld	a0,80(s2)
    80001fd2:	ffffe097          	auipc	ra,0xffffe
    80001fd6:	48e080e7          	jalr	1166(ra) # 80000460 <walk>
      if(pte==0)
    80001fda:	cd09                	beqz	a0,80001ff4 <usertrap+0x1e8>
      *pte |= PTE_D | PTE_W;
    80001fdc:	611c                	ld	a5,0(a0)
    80001fde:	0847e793          	ori	a5,a5,132
    80001fe2:	e11c                	sd	a5,0(a0)
    {
    80001fe4:	bdc1                	j	80001eb4 <usertrap+0xa8>
        iunlock(vma->f->ip);
    80001fe6:	180ab783          	ld	a5,384(s5)
    80001fea:	6f88                	ld	a0,24(a5)
    80001fec:	00001097          	auipc	ra,0x1
    80001ff0:	e80080e7          	jalr	-384(ra) # 80002e6c <iunlock>
    80001ff4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ff8:	03092603          	lw	a2,48(s2)
    80001ffc:	00006517          	auipc	a0,0x6
    80002000:	2a450513          	addi	a0,a0,676 # 800082a0 <states.1799+0x78>
    80002004:	00004097          	auipc	ra,0x4
    80002008:	2de080e7          	jalr	734(ra) # 800062e2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000200c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002010:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002014:	00006517          	auipc	a0,0x6
    80002018:	2bc50513          	addi	a0,a0,700 # 800082d0 <states.1799+0xa8>
    8000201c:	00004097          	auipc	ra,0x4
    80002020:	2c6080e7          	jalr	710(ra) # 800062e2 <printf>
    p->killed = 1;
    80002024:	4785                	li	a5,1
    80002026:	02f92423          	sw	a5,40(s2)
    8000202a:	4481                	li	s1,0
    exit(-1);
    8000202c:	557d                	li	a0,-1
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	758080e7          	jalr	1880(ra) # 80001786 <exit>
  if(which_dev == 2)
    80002036:	4789                	li	a5,2
    80002038:	e8f492e3          	bne	s1,a5,80001ebc <usertrap+0xb0>
    yield();
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	4b2080e7          	jalr	1202(ra) # 800014ee <yield>
    80002044:	bda5                	j	80001ebc <usertrap+0xb0>
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) 
    80002046:	0027f693          	andi	a3,a5,2
    8000204a:	d6a1                	beqz	a3,80001f92 <usertrap+0x186>
        flags |= PTE_W | PTE_D;
    8000204c:	08476713          	ori	a4,a4,132
    80002050:	b789                	j	80001f92 <usertrap+0x186>
  }else if((which_dev = devintr()) != 0){
    80002052:	00000097          	auipc	ra,0x0
    80002056:	d18080e7          	jalr	-744(ra) # 80001d6a <devintr>
    8000205a:	84aa                	mv	s1,a0
    8000205c:	dd41                	beqz	a0,80001ff4 <usertrap+0x1e8>
  if(p->killed)
    8000205e:	02892783          	lw	a5,40(s2)
    80002062:	dbf1                	beqz	a5,80002036 <usertrap+0x22a>
    80002064:	b7e1                	j	8000202c <usertrap+0x220>
    80002066:	4481                	li	s1,0
    80002068:	b7d1                	j	8000202c <usertrap+0x220>

000000008000206a <kerneltrap>:
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002078:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002080:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002084:	1004f793          	andi	a5,s1,256
    80002088:	cb85                	beqz	a5,800020b8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000208a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000208e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002090:	ef85                	bnez	a5,800020c8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002092:	00000097          	auipc	ra,0x0
    80002096:	cd8080e7          	jalr	-808(ra) # 80001d6a <devintr>
    8000209a:	cd1d                	beqz	a0,800020d8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000209c:	4789                	li	a5,2
    8000209e:	06f50a63          	beq	a0,a5,80002112 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800020a2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020a6:	10049073          	csrw	sstatus,s1
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	69a2                	ld	s3,8(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	23850513          	addi	a0,a0,568 # 800082f0 <states.1799+0xc8>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	1d8080e7          	jalr	472(ra) # 80006298 <panic>
    panic("kerneltrap: interrupts enabled");
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	25050513          	addi	a0,a0,592 # 80008318 <states.1799+0xf0>
    800020d0:	00004097          	auipc	ra,0x4
    800020d4:	1c8080e7          	jalr	456(ra) # 80006298 <panic>
    printf("scause %p\n", scause);
    800020d8:	85ce                	mv	a1,s3
    800020da:	00006517          	auipc	a0,0x6
    800020de:	25e50513          	addi	a0,a0,606 # 80008338 <states.1799+0x110>
    800020e2:	00004097          	auipc	ra,0x4
    800020e6:	200080e7          	jalr	512(ra) # 800062e2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020ea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020ee:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020f2:	00006517          	auipc	a0,0x6
    800020f6:	25650513          	addi	a0,a0,598 # 80008348 <states.1799+0x120>
    800020fa:	00004097          	auipc	ra,0x4
    800020fe:	1e8080e7          	jalr	488(ra) # 800062e2 <printf>
    panic("kerneltrap");
    80002102:	00006517          	auipc	a0,0x6
    80002106:	25e50513          	addi	a0,a0,606 # 80008360 <states.1799+0x138>
    8000210a:	00004097          	auipc	ra,0x4
    8000210e:	18e080e7          	jalr	398(ra) # 80006298 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	d18080e7          	jalr	-744(ra) # 80000e2a <myproc>
    8000211a:	d541                	beqz	a0,800020a2 <kerneltrap+0x38>
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	d0e080e7          	jalr	-754(ra) # 80000e2a <myproc>
    80002124:	4d18                	lw	a4,24(a0)
    80002126:	4791                	li	a5,4
    80002128:	f6f71de3          	bne	a4,a5,800020a2 <kerneltrap+0x38>
    yield();
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	3c2080e7          	jalr	962(ra) # 800014ee <yield>
    80002134:	b7bd                	j	800020a2 <kerneltrap+0x38>

0000000080002136 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	e426                	sd	s1,8(sp)
    8000213e:	1000                	addi	s0,sp,32
    80002140:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	ce8080e7          	jalr	-792(ra) # 80000e2a <myproc>
  switch (n) {
    8000214a:	4795                	li	a5,5
    8000214c:	0497e163          	bltu	a5,s1,8000218e <argraw+0x58>
    80002150:	048a                	slli	s1,s1,0x2
    80002152:	00006717          	auipc	a4,0x6
    80002156:	24670713          	addi	a4,a4,582 # 80008398 <states.1799+0x170>
    8000215a:	94ba                	add	s1,s1,a4
    8000215c:	409c                	lw	a5,0(s1)
    8000215e:	97ba                	add	a5,a5,a4
    80002160:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002162:	6d3c                	ld	a5,88(a0)
    80002164:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret
    return p->trapframe->a1;
    80002170:	6d3c                	ld	a5,88(a0)
    80002172:	7fa8                	ld	a0,120(a5)
    80002174:	bfcd                	j	80002166 <argraw+0x30>
    return p->trapframe->a2;
    80002176:	6d3c                	ld	a5,88(a0)
    80002178:	63c8                	ld	a0,128(a5)
    8000217a:	b7f5                	j	80002166 <argraw+0x30>
    return p->trapframe->a3;
    8000217c:	6d3c                	ld	a5,88(a0)
    8000217e:	67c8                	ld	a0,136(a5)
    80002180:	b7dd                	j	80002166 <argraw+0x30>
    return p->trapframe->a4;
    80002182:	6d3c                	ld	a5,88(a0)
    80002184:	6bc8                	ld	a0,144(a5)
    80002186:	b7c5                	j	80002166 <argraw+0x30>
    return p->trapframe->a5;
    80002188:	6d3c                	ld	a5,88(a0)
    8000218a:	6fc8                	ld	a0,152(a5)
    8000218c:	bfe9                	j	80002166 <argraw+0x30>
  panic("argraw");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	1e250513          	addi	a0,a0,482 # 80008370 <states.1799+0x148>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	102080e7          	jalr	258(ra) # 80006298 <panic>

000000008000219e <fetchaddr>:
{
    8000219e:	1101                	addi	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	e426                	sd	s1,8(sp)
    800021a6:	e04a                	sd	s2,0(sp)
    800021a8:	1000                	addi	s0,sp,32
    800021aa:	84aa                	mv	s1,a0
    800021ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	c7c080e7          	jalr	-900(ra) # 80000e2a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021b6:	653c                	ld	a5,72(a0)
    800021b8:	02f4f863          	bgeu	s1,a5,800021e8 <fetchaddr+0x4a>
    800021bc:	00848713          	addi	a4,s1,8
    800021c0:	02e7e663          	bltu	a5,a4,800021ec <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021c4:	46a1                	li	a3,8
    800021c6:	8626                	mv	a2,s1
    800021c8:	85ca                	mv	a1,s2
    800021ca:	6928                	ld	a0,80(a0)
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	9ac080e7          	jalr	-1620(ra) # 80000b78 <copyin>
    800021d4:	00a03533          	snez	a0,a0
    800021d8:	40a00533          	neg	a0,a0
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6902                	ld	s2,0(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret
    return -1;
    800021e8:	557d                	li	a0,-1
    800021ea:	bfcd                	j	800021dc <fetchaddr+0x3e>
    800021ec:	557d                	li	a0,-1
    800021ee:	b7fd                	j	800021dc <fetchaddr+0x3e>

00000000800021f0 <fetchstr>:
{
    800021f0:	7179                	addi	sp,sp,-48
    800021f2:	f406                	sd	ra,40(sp)
    800021f4:	f022                	sd	s0,32(sp)
    800021f6:	ec26                	sd	s1,24(sp)
    800021f8:	e84a                	sd	s2,16(sp)
    800021fa:	e44e                	sd	s3,8(sp)
    800021fc:	1800                	addi	s0,sp,48
    800021fe:	892a                	mv	s2,a0
    80002200:	84ae                	mv	s1,a1
    80002202:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	c26080e7          	jalr	-986(ra) # 80000e2a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000220c:	86ce                	mv	a3,s3
    8000220e:	864a                	mv	a2,s2
    80002210:	85a6                	mv	a1,s1
    80002212:	6928                	ld	a0,80(a0)
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	9f0080e7          	jalr	-1552(ra) # 80000c04 <copyinstr>
  if(err < 0)
    8000221c:	00054763          	bltz	a0,8000222a <fetchstr+0x3a>
  return strlen(buf);
    80002220:	8526                	mv	a0,s1
    80002222:	ffffe097          	auipc	ra,0xffffe
    80002226:	0da080e7          	jalr	218(ra) # 800002fc <strlen>
}
    8000222a:	70a2                	ld	ra,40(sp)
    8000222c:	7402                	ld	s0,32(sp)
    8000222e:	64e2                	ld	s1,24(sp)
    80002230:	6942                	ld	s2,16(sp)
    80002232:	69a2                	ld	s3,8(sp)
    80002234:	6145                	addi	sp,sp,48
    80002236:	8082                	ret

0000000080002238 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002238:	1101                	addi	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	e426                	sd	s1,8(sp)
    80002240:	1000                	addi	s0,sp,32
    80002242:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002244:	00000097          	auipc	ra,0x0
    80002248:	ef2080e7          	jalr	-270(ra) # 80002136 <argraw>
    8000224c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000224e:	4501                	li	a0,0
    80002250:	60e2                	ld	ra,24(sp)
    80002252:	6442                	ld	s0,16(sp)
    80002254:	64a2                	ld	s1,8(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
    80002264:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	ed0080e7          	jalr	-304(ra) # 80002136 <argraw>
    8000226e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002270:	4501                	li	a0,0
    80002272:	60e2                	ld	ra,24(sp)
    80002274:	6442                	ld	s0,16(sp)
    80002276:	64a2                	ld	s1,8(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	e04a                	sd	s2,0(sp)
    80002286:	1000                	addi	s0,sp,32
    80002288:	84ae                	mv	s1,a1
    8000228a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	eaa080e7          	jalr	-342(ra) # 80002136 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002294:	864a                	mv	a2,s2
    80002296:	85a6                	mv	a1,s1
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	f58080e7          	jalr	-168(ra) # 800021f0 <fetchstr>
}
    800022a0:	60e2                	ld	ra,24(sp)
    800022a2:	6442                	ld	s0,16(sp)
    800022a4:	64a2                	ld	s1,8(sp)
    800022a6:	6902                	ld	s2,0(sp)
    800022a8:	6105                	addi	sp,sp,32
    800022aa:	8082                	ret

00000000800022ac <syscall>:
[SYS_munmap]  sys_munmap
};

void
syscall(void)
{
    800022ac:	1101                	addi	sp,sp,-32
    800022ae:	ec06                	sd	ra,24(sp)
    800022b0:	e822                	sd	s0,16(sp)
    800022b2:	e426                	sd	s1,8(sp)
    800022b4:	e04a                	sd	s2,0(sp)
    800022b6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	b72080e7          	jalr	-1166(ra) # 80000e2a <myproc>
    800022c0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022c2:	05853903          	ld	s2,88(a0)
    800022c6:	0a893783          	ld	a5,168(s2)
    800022ca:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022ce:	37fd                	addiw	a5,a5,-1
    800022d0:	4759                	li	a4,22
    800022d2:	00f76f63          	bltu	a4,a5,800022f0 <syscall+0x44>
    800022d6:	00369713          	slli	a4,a3,0x3
    800022da:	00006797          	auipc	a5,0x6
    800022de:	0d678793          	addi	a5,a5,214 # 800083b0 <syscalls>
    800022e2:	97ba                	add	a5,a5,a4
    800022e4:	639c                	ld	a5,0(a5)
    800022e6:	c789                	beqz	a5,800022f0 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022e8:	9782                	jalr	a5
    800022ea:	06a93823          	sd	a0,112(s2)
    800022ee:	a839                	j	8000230c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022f0:	15848613          	addi	a2,s1,344
    800022f4:	588c                	lw	a1,48(s1)
    800022f6:	00006517          	auipc	a0,0x6
    800022fa:	08250513          	addi	a0,a0,130 # 80008378 <states.1799+0x150>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	fe4080e7          	jalr	-28(ra) # 800062e2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002306:	6cbc                	ld	a5,88(s1)
    80002308:	577d                	li	a4,-1
    8000230a:	fbb8                	sd	a4,112(a5)
  }
}
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6902                	ld	s2,0(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret

0000000080002318 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002318:	1101                	addi	sp,sp,-32
    8000231a:	ec06                	sd	ra,24(sp)
    8000231c:	e822                	sd	s0,16(sp)
    8000231e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002320:	fec40593          	addi	a1,s0,-20
    80002324:	4501                	li	a0,0
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	f12080e7          	jalr	-238(ra) # 80002238 <argint>
    return -1;
    8000232e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002330:	00054963          	bltz	a0,80002342 <sys_exit+0x2a>
  exit(n);
    80002334:	fec42503          	lw	a0,-20(s0)
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	44e080e7          	jalr	1102(ra) # 80001786 <exit>
  return 0;  // not reached
    80002340:	4781                	li	a5,0
}
    80002342:	853e                	mv	a0,a5
    80002344:	60e2                	ld	ra,24(sp)
    80002346:	6442                	ld	s0,16(sp)
    80002348:	6105                	addi	sp,sp,32
    8000234a:	8082                	ret

000000008000234c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000234c:	1141                	addi	sp,sp,-16
    8000234e:	e406                	sd	ra,8(sp)
    80002350:	e022                	sd	s0,0(sp)
    80002352:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	ad6080e7          	jalr	-1322(ra) # 80000e2a <myproc>
}
    8000235c:	5908                	lw	a0,48(a0)
    8000235e:	60a2                	ld	ra,8(sp)
    80002360:	6402                	ld	s0,0(sp)
    80002362:	0141                	addi	sp,sp,16
    80002364:	8082                	ret

0000000080002366 <sys_fork>:

uint64
sys_fork(void)
{
    80002366:	1141                	addi	sp,sp,-16
    80002368:	e406                	sd	ra,8(sp)
    8000236a:	e022                	sd	s0,0(sp)
    8000236c:	0800                	addi	s0,sp,16
  return fork();
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	e8a080e7          	jalr	-374(ra) # 800011f8 <fork>
}
    80002376:	60a2                	ld	ra,8(sp)
    80002378:	6402                	ld	s0,0(sp)
    8000237a:	0141                	addi	sp,sp,16
    8000237c:	8082                	ret

000000008000237e <sys_wait>:

uint64
sys_wait(void)
{
    8000237e:	1101                	addi	sp,sp,-32
    80002380:	ec06                	sd	ra,24(sp)
    80002382:	e822                	sd	s0,16(sp)
    80002384:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002386:	fe840593          	addi	a1,s0,-24
    8000238a:	4501                	li	a0,0
    8000238c:	00000097          	auipc	ra,0x0
    80002390:	ece080e7          	jalr	-306(ra) # 8000225a <argaddr>
    80002394:	87aa                	mv	a5,a0
    return -1;
    80002396:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002398:	0007c863          	bltz	a5,800023a8 <sys_wait+0x2a>
  return wait(p);
    8000239c:	fe843503          	ld	a0,-24(s0)
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	1ee080e7          	jalr	494(ra) # 8000158e <wait>
}
    800023a8:	60e2                	ld	ra,24(sp)
    800023aa:	6442                	ld	s0,16(sp)
    800023ac:	6105                	addi	sp,sp,32
    800023ae:	8082                	ret

00000000800023b0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023b0:	7179                	addi	sp,sp,-48
    800023b2:	f406                	sd	ra,40(sp)
    800023b4:	f022                	sd	s0,32(sp)
    800023b6:	ec26                	sd	s1,24(sp)
    800023b8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023ba:	fdc40593          	addi	a1,s0,-36
    800023be:	4501                	li	a0,0
    800023c0:	00000097          	auipc	ra,0x0
    800023c4:	e78080e7          	jalr	-392(ra) # 80002238 <argint>
    800023c8:	87aa                	mv	a5,a0
    return -1;
    800023ca:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023cc:	0207c063          	bltz	a5,800023ec <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	a5a080e7          	jalr	-1446(ra) # 80000e2a <myproc>
    800023d8:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023da:	fdc42503          	lw	a0,-36(s0)
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	da6080e7          	jalr	-602(ra) # 80001184 <growproc>
    800023e6:	00054863          	bltz	a0,800023f6 <sys_sbrk+0x46>
    return -1;
  return addr;
    800023ea:	8526                	mv	a0,s1
}
    800023ec:	70a2                	ld	ra,40(sp)
    800023ee:	7402                	ld	s0,32(sp)
    800023f0:	64e2                	ld	s1,24(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret
    return -1;
    800023f6:	557d                	li	a0,-1
    800023f8:	bfd5                	j	800023ec <sys_sbrk+0x3c>

00000000800023fa <sys_sleep>:

uint64
sys_sleep(void)
{
    800023fa:	7139                	addi	sp,sp,-64
    800023fc:	fc06                	sd	ra,56(sp)
    800023fe:	f822                	sd	s0,48(sp)
    80002400:	f426                	sd	s1,40(sp)
    80002402:	f04a                	sd	s2,32(sp)
    80002404:	ec4e                	sd	s3,24(sp)
    80002406:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002408:	fcc40593          	addi	a1,s0,-52
    8000240c:	4501                	li	a0,0
    8000240e:	00000097          	auipc	ra,0x0
    80002412:	e2a080e7          	jalr	-470(ra) # 80002238 <argint>
    return -1;
    80002416:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002418:	06054563          	bltz	a0,80002482 <sys_sleep+0x88>
  acquire(&tickslock);
    8000241c:	00015517          	auipc	a0,0x15
    80002420:	a6450513          	addi	a0,a0,-1436 # 80016e80 <tickslock>
    80002424:	00004097          	auipc	ra,0x4
    80002428:	3be080e7          	jalr	958(ra) # 800067e2 <acquire>
  ticks0 = ticks;
    8000242c:	00007917          	auipc	s2,0x7
    80002430:	bec92903          	lw	s2,-1044(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002434:	fcc42783          	lw	a5,-52(s0)
    80002438:	cf85                	beqz	a5,80002470 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000243a:	00015997          	auipc	s3,0x15
    8000243e:	a4698993          	addi	s3,s3,-1466 # 80016e80 <tickslock>
    80002442:	00007497          	auipc	s1,0x7
    80002446:	bd648493          	addi	s1,s1,-1066 # 80009018 <ticks>
    if(myproc()->killed){
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	9e0080e7          	jalr	-1568(ra) # 80000e2a <myproc>
    80002452:	551c                	lw	a5,40(a0)
    80002454:	ef9d                	bnez	a5,80002492 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002456:	85ce                	mv	a1,s3
    80002458:	8526                	mv	a0,s1
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	0d0080e7          	jalr	208(ra) # 8000152a <sleep>
  while(ticks - ticks0 < n){
    80002462:	409c                	lw	a5,0(s1)
    80002464:	412787bb          	subw	a5,a5,s2
    80002468:	fcc42703          	lw	a4,-52(s0)
    8000246c:	fce7efe3          	bltu	a5,a4,8000244a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002470:	00015517          	auipc	a0,0x15
    80002474:	a1050513          	addi	a0,a0,-1520 # 80016e80 <tickslock>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	41e080e7          	jalr	1054(ra) # 80006896 <release>
  return 0;
    80002480:	4781                	li	a5,0
}
    80002482:	853e                	mv	a0,a5
    80002484:	70e2                	ld	ra,56(sp)
    80002486:	7442                	ld	s0,48(sp)
    80002488:	74a2                	ld	s1,40(sp)
    8000248a:	7902                	ld	s2,32(sp)
    8000248c:	69e2                	ld	s3,24(sp)
    8000248e:	6121                	addi	sp,sp,64
    80002490:	8082                	ret
      release(&tickslock);
    80002492:	00015517          	auipc	a0,0x15
    80002496:	9ee50513          	addi	a0,a0,-1554 # 80016e80 <tickslock>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	3fc080e7          	jalr	1020(ra) # 80006896 <release>
      return -1;
    800024a2:	57fd                	li	a5,-1
    800024a4:	bff9                	j	80002482 <sys_sleep+0x88>

00000000800024a6 <sys_kill>:

uint64
sys_kill(void)
{
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024ae:	fec40593          	addi	a1,s0,-20
    800024b2:	4501                	li	a0,0
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	d84080e7          	jalr	-636(ra) # 80002238 <argint>
    800024bc:	87aa                	mv	a5,a0
    return -1;
    800024be:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024c0:	0007c863          	bltz	a5,800024d0 <sys_kill+0x2a>
  return kill(pid);
    800024c4:	fec42503          	lw	a0,-20(s0)
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	548080e7          	jalr	1352(ra) # 80001a10 <kill>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret

00000000800024d8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024d8:	1101                	addi	sp,sp,-32
    800024da:	ec06                	sd	ra,24(sp)
    800024dc:	e822                	sd	s0,16(sp)
    800024de:	e426                	sd	s1,8(sp)
    800024e0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024e2:	00015517          	auipc	a0,0x15
    800024e6:	99e50513          	addi	a0,a0,-1634 # 80016e80 <tickslock>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	2f8080e7          	jalr	760(ra) # 800067e2 <acquire>
  xticks = ticks;
    800024f2:	00007497          	auipc	s1,0x7
    800024f6:	b264a483          	lw	s1,-1242(s1) # 80009018 <ticks>
  release(&tickslock);
    800024fa:	00015517          	auipc	a0,0x15
    800024fe:	98650513          	addi	a0,a0,-1658 # 80016e80 <tickslock>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	394080e7          	jalr	916(ra) # 80006896 <release>
  return xticks;
}
    8000250a:	02049513          	slli	a0,s1,0x20
    8000250e:	9101                	srli	a0,a0,0x20
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret

000000008000251a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000251a:	7179                	addi	sp,sp,-48
    8000251c:	f406                	sd	ra,40(sp)
    8000251e:	f022                	sd	s0,32(sp)
    80002520:	ec26                	sd	s1,24(sp)
    80002522:	e84a                	sd	s2,16(sp)
    80002524:	e44e                	sd	s3,8(sp)
    80002526:	e052                	sd	s4,0(sp)
    80002528:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000252a:	00006597          	auipc	a1,0x6
    8000252e:	f4658593          	addi	a1,a1,-186 # 80008470 <syscalls+0xc0>
    80002532:	00015517          	auipc	a0,0x15
    80002536:	96650513          	addi	a0,a0,-1690 # 80016e98 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	218080e7          	jalr	536(ra) # 80006752 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002542:	0001d797          	auipc	a5,0x1d
    80002546:	95678793          	addi	a5,a5,-1706 # 8001ee98 <bcache+0x8000>
    8000254a:	0001d717          	auipc	a4,0x1d
    8000254e:	bb670713          	addi	a4,a4,-1098 # 8001f100 <bcache+0x8268>
    80002552:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002556:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000255a:	00015497          	auipc	s1,0x15
    8000255e:	95648493          	addi	s1,s1,-1706 # 80016eb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002562:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002564:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002566:	00006a17          	auipc	s4,0x6
    8000256a:	f12a0a13          	addi	s4,s4,-238 # 80008478 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000256e:	2b893783          	ld	a5,696(s2)
    80002572:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002574:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002578:	85d2                	mv	a1,s4
    8000257a:	01048513          	addi	a0,s1,16
    8000257e:	00001097          	auipc	ra,0x1
    80002582:	4bc080e7          	jalr	1212(ra) # 80003a3a <initsleeplock>
    bcache.head.next->prev = b;
    80002586:	2b893783          	ld	a5,696(s2)
    8000258a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000258c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002590:	45848493          	addi	s1,s1,1112
    80002594:	fd349de3          	bne	s1,s3,8000256e <binit+0x54>
  }
}
    80002598:	70a2                	ld	ra,40(sp)
    8000259a:	7402                	ld	s0,32(sp)
    8000259c:	64e2                	ld	s1,24(sp)
    8000259e:	6942                	ld	s2,16(sp)
    800025a0:	69a2                	ld	s3,8(sp)
    800025a2:	6a02                	ld	s4,0(sp)
    800025a4:	6145                	addi	sp,sp,48
    800025a6:	8082                	ret

00000000800025a8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025a8:	7179                	addi	sp,sp,-48
    800025aa:	f406                	sd	ra,40(sp)
    800025ac:	f022                	sd	s0,32(sp)
    800025ae:	ec26                	sd	s1,24(sp)
    800025b0:	e84a                	sd	s2,16(sp)
    800025b2:	e44e                	sd	s3,8(sp)
    800025b4:	1800                	addi	s0,sp,48
    800025b6:	89aa                	mv	s3,a0
    800025b8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800025ba:	00015517          	auipc	a0,0x15
    800025be:	8de50513          	addi	a0,a0,-1826 # 80016e98 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	220080e7          	jalr	544(ra) # 800067e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025ca:	0001d497          	auipc	s1,0x1d
    800025ce:	b864b483          	ld	s1,-1146(s1) # 8001f150 <bcache+0x82b8>
    800025d2:	0001d797          	auipc	a5,0x1d
    800025d6:	b2e78793          	addi	a5,a5,-1234 # 8001f100 <bcache+0x8268>
    800025da:	02f48f63          	beq	s1,a5,80002618 <bread+0x70>
    800025de:	873e                	mv	a4,a5
    800025e0:	a021                	j	800025e8 <bread+0x40>
    800025e2:	68a4                	ld	s1,80(s1)
    800025e4:	02e48a63          	beq	s1,a4,80002618 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025e8:	449c                	lw	a5,8(s1)
    800025ea:	ff379ce3          	bne	a5,s3,800025e2 <bread+0x3a>
    800025ee:	44dc                	lw	a5,12(s1)
    800025f0:	ff2799e3          	bne	a5,s2,800025e2 <bread+0x3a>
      b->refcnt++;
    800025f4:	40bc                	lw	a5,64(s1)
    800025f6:	2785                	addiw	a5,a5,1
    800025f8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025fa:	00015517          	auipc	a0,0x15
    800025fe:	89e50513          	addi	a0,a0,-1890 # 80016e98 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	294080e7          	jalr	660(ra) # 80006896 <release>
      acquiresleep(&b->lock);
    8000260a:	01048513          	addi	a0,s1,16
    8000260e:	00001097          	auipc	ra,0x1
    80002612:	466080e7          	jalr	1126(ra) # 80003a74 <acquiresleep>
      return b;
    80002616:	a8b9                	j	80002674 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002618:	0001d497          	auipc	s1,0x1d
    8000261c:	b304b483          	ld	s1,-1232(s1) # 8001f148 <bcache+0x82b0>
    80002620:	0001d797          	auipc	a5,0x1d
    80002624:	ae078793          	addi	a5,a5,-1312 # 8001f100 <bcache+0x8268>
    80002628:	00f48863          	beq	s1,a5,80002638 <bread+0x90>
    8000262c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000262e:	40bc                	lw	a5,64(s1)
    80002630:	cf81                	beqz	a5,80002648 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002632:	64a4                	ld	s1,72(s1)
    80002634:	fee49de3          	bne	s1,a4,8000262e <bread+0x86>
  panic("bget: no buffers");
    80002638:	00006517          	auipc	a0,0x6
    8000263c:	e4850513          	addi	a0,a0,-440 # 80008480 <syscalls+0xd0>
    80002640:	00004097          	auipc	ra,0x4
    80002644:	c58080e7          	jalr	-936(ra) # 80006298 <panic>
      b->dev = dev;
    80002648:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000264c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002650:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002654:	4785                	li	a5,1
    80002656:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002658:	00015517          	auipc	a0,0x15
    8000265c:	84050513          	addi	a0,a0,-1984 # 80016e98 <bcache>
    80002660:	00004097          	auipc	ra,0x4
    80002664:	236080e7          	jalr	566(ra) # 80006896 <release>
      acquiresleep(&b->lock);
    80002668:	01048513          	addi	a0,s1,16
    8000266c:	00001097          	auipc	ra,0x1
    80002670:	408080e7          	jalr	1032(ra) # 80003a74 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002674:	409c                	lw	a5,0(s1)
    80002676:	cb89                	beqz	a5,80002688 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002678:	8526                	mv	a0,s1
    8000267a:	70a2                	ld	ra,40(sp)
    8000267c:	7402                	ld	s0,32(sp)
    8000267e:	64e2                	ld	s1,24(sp)
    80002680:	6942                	ld	s2,16(sp)
    80002682:	69a2                	ld	s3,8(sp)
    80002684:	6145                	addi	sp,sp,48
    80002686:	8082                	ret
    virtio_disk_rw(b, 0);
    80002688:	4581                	li	a1,0
    8000268a:	8526                	mv	a0,s1
    8000268c:	00003097          	auipc	ra,0x3
    80002690:	34a080e7          	jalr	842(ra) # 800059d6 <virtio_disk_rw>
    b->valid = 1;
    80002694:	4785                	li	a5,1
    80002696:	c09c                	sw	a5,0(s1)
  return b;
    80002698:	b7c5                	j	80002678 <bread+0xd0>

000000008000269a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000269a:	1101                	addi	sp,sp,-32
    8000269c:	ec06                	sd	ra,24(sp)
    8000269e:	e822                	sd	s0,16(sp)
    800026a0:	e426                	sd	s1,8(sp)
    800026a2:	1000                	addi	s0,sp,32
    800026a4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026a6:	0541                	addi	a0,a0,16
    800026a8:	00001097          	auipc	ra,0x1
    800026ac:	466080e7          	jalr	1126(ra) # 80003b0e <holdingsleep>
    800026b0:	cd01                	beqz	a0,800026c8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026b2:	4585                	li	a1,1
    800026b4:	8526                	mv	a0,s1
    800026b6:	00003097          	auipc	ra,0x3
    800026ba:	320080e7          	jalr	800(ra) # 800059d6 <virtio_disk_rw>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("bwrite");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	dd050513          	addi	a0,a0,-560 # 80008498 <syscalls+0xe8>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	bc8080e7          	jalr	-1080(ra) # 80006298 <panic>

00000000800026d8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	e04a                	sd	s2,0(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026e6:	01050913          	addi	s2,a0,16
    800026ea:	854a                	mv	a0,s2
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	422080e7          	jalr	1058(ra) # 80003b0e <holdingsleep>
    800026f4:	c92d                	beqz	a0,80002766 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	3d2080e7          	jalr	978(ra) # 80003aca <releasesleep>

  acquire(&bcache.lock);
    80002700:	00014517          	auipc	a0,0x14
    80002704:	79850513          	addi	a0,a0,1944 # 80016e98 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	0da080e7          	jalr	218(ra) # 800067e2 <acquire>
  b->refcnt--;
    80002710:	40bc                	lw	a5,64(s1)
    80002712:	37fd                	addiw	a5,a5,-1
    80002714:	0007871b          	sext.w	a4,a5
    80002718:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000271a:	eb05                	bnez	a4,8000274a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000271c:	68bc                	ld	a5,80(s1)
    8000271e:	64b8                	ld	a4,72(s1)
    80002720:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002722:	64bc                	ld	a5,72(s1)
    80002724:	68b8                	ld	a4,80(s1)
    80002726:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002728:	0001c797          	auipc	a5,0x1c
    8000272c:	77078793          	addi	a5,a5,1904 # 8001ee98 <bcache+0x8000>
    80002730:	2b87b703          	ld	a4,696(a5)
    80002734:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002736:	0001d717          	auipc	a4,0x1d
    8000273a:	9ca70713          	addi	a4,a4,-1590 # 8001f100 <bcache+0x8268>
    8000273e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002740:	2b87b703          	ld	a4,696(a5)
    80002744:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002746:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000274a:	00014517          	auipc	a0,0x14
    8000274e:	74e50513          	addi	a0,a0,1870 # 80016e98 <bcache>
    80002752:	00004097          	auipc	ra,0x4
    80002756:	144080e7          	jalr	324(ra) # 80006896 <release>
}
    8000275a:	60e2                	ld	ra,24(sp)
    8000275c:	6442                	ld	s0,16(sp)
    8000275e:	64a2                	ld	s1,8(sp)
    80002760:	6902                	ld	s2,0(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
    panic("brelse");
    80002766:	00006517          	auipc	a0,0x6
    8000276a:	d3a50513          	addi	a0,a0,-710 # 800084a0 <syscalls+0xf0>
    8000276e:	00004097          	auipc	ra,0x4
    80002772:	b2a080e7          	jalr	-1238(ra) # 80006298 <panic>

0000000080002776 <bpin>:

void
bpin(struct buf *b) {
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	1000                	addi	s0,sp,32
    80002780:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002782:	00014517          	auipc	a0,0x14
    80002786:	71650513          	addi	a0,a0,1814 # 80016e98 <bcache>
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	058080e7          	jalr	88(ra) # 800067e2 <acquire>
  b->refcnt++;
    80002792:	40bc                	lw	a5,64(s1)
    80002794:	2785                	addiw	a5,a5,1
    80002796:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002798:	00014517          	auipc	a0,0x14
    8000279c:	70050513          	addi	a0,a0,1792 # 80016e98 <bcache>
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	0f6080e7          	jalr	246(ra) # 80006896 <release>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6105                	addi	sp,sp,32
    800027b0:	8082                	ret

00000000800027b2 <bunpin>:

void
bunpin(struct buf *b) {
    800027b2:	1101                	addi	sp,sp,-32
    800027b4:	ec06                	sd	ra,24(sp)
    800027b6:	e822                	sd	s0,16(sp)
    800027b8:	e426                	sd	s1,8(sp)
    800027ba:	1000                	addi	s0,sp,32
    800027bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027be:	00014517          	auipc	a0,0x14
    800027c2:	6da50513          	addi	a0,a0,1754 # 80016e98 <bcache>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	01c080e7          	jalr	28(ra) # 800067e2 <acquire>
  b->refcnt--;
    800027ce:	40bc                	lw	a5,64(s1)
    800027d0:	37fd                	addiw	a5,a5,-1
    800027d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027d4:	00014517          	auipc	a0,0x14
    800027d8:	6c450513          	addi	a0,a0,1732 # 80016e98 <bcache>
    800027dc:	00004097          	auipc	ra,0x4
    800027e0:	0ba080e7          	jalr	186(ra) # 80006896 <release>
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	e04a                	sd	s2,0(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027fc:	00d5d59b          	srliw	a1,a1,0xd
    80002800:	0001d797          	auipc	a5,0x1d
    80002804:	d747a783          	lw	a5,-652(a5) # 8001f574 <sb+0x1c>
    80002808:	9dbd                	addw	a1,a1,a5
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	d9e080e7          	jalr	-610(ra) # 800025a8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002812:	0074f713          	andi	a4,s1,7
    80002816:	4785                	li	a5,1
    80002818:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000281c:	14ce                	slli	s1,s1,0x33
    8000281e:	90d9                	srli	s1,s1,0x36
    80002820:	00950733          	add	a4,a0,s1
    80002824:	05874703          	lbu	a4,88(a4)
    80002828:	00e7f6b3          	and	a3,a5,a4
    8000282c:	c69d                	beqz	a3,8000285a <bfree+0x6c>
    8000282e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002830:	94aa                	add	s1,s1,a0
    80002832:	fff7c793          	not	a5,a5
    80002836:	8ff9                	and	a5,a5,a4
    80002838:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000283c:	00001097          	auipc	ra,0x1
    80002840:	118080e7          	jalr	280(ra) # 80003954 <log_write>
  brelse(bp);
    80002844:	854a                	mv	a0,s2
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e92080e7          	jalr	-366(ra) # 800026d8 <brelse>
}
    8000284e:	60e2                	ld	ra,24(sp)
    80002850:	6442                	ld	s0,16(sp)
    80002852:	64a2                	ld	s1,8(sp)
    80002854:	6902                	ld	s2,0(sp)
    80002856:	6105                	addi	sp,sp,32
    80002858:	8082                	ret
    panic("freeing free block");
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	c4e50513          	addi	a0,a0,-946 # 800084a8 <syscalls+0xf8>
    80002862:	00004097          	auipc	ra,0x4
    80002866:	a36080e7          	jalr	-1482(ra) # 80006298 <panic>

000000008000286a <balloc>:
{
    8000286a:	711d                	addi	sp,sp,-96
    8000286c:	ec86                	sd	ra,88(sp)
    8000286e:	e8a2                	sd	s0,80(sp)
    80002870:	e4a6                	sd	s1,72(sp)
    80002872:	e0ca                	sd	s2,64(sp)
    80002874:	fc4e                	sd	s3,56(sp)
    80002876:	f852                	sd	s4,48(sp)
    80002878:	f456                	sd	s5,40(sp)
    8000287a:	f05a                	sd	s6,32(sp)
    8000287c:	ec5e                	sd	s7,24(sp)
    8000287e:	e862                	sd	s8,16(sp)
    80002880:	e466                	sd	s9,8(sp)
    80002882:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002884:	0001d797          	auipc	a5,0x1d
    80002888:	cd87a783          	lw	a5,-808(a5) # 8001f55c <sb+0x4>
    8000288c:	cbd1                	beqz	a5,80002920 <balloc+0xb6>
    8000288e:	8baa                	mv	s7,a0
    80002890:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002892:	0001db17          	auipc	s6,0x1d
    80002896:	cc6b0b13          	addi	s6,s6,-826 # 8001f558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000289a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000289c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000289e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028a0:	6c89                	lui	s9,0x2
    800028a2:	a831                	j	800028be <balloc+0x54>
    brelse(bp);
    800028a4:	854a                	mv	a0,s2
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	e32080e7          	jalr	-462(ra) # 800026d8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ae:	015c87bb          	addw	a5,s9,s5
    800028b2:	00078a9b          	sext.w	s5,a5
    800028b6:	004b2703          	lw	a4,4(s6)
    800028ba:	06eaf363          	bgeu	s5,a4,80002920 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028be:	41fad79b          	sraiw	a5,s5,0x1f
    800028c2:	0137d79b          	srliw	a5,a5,0x13
    800028c6:	015787bb          	addw	a5,a5,s5
    800028ca:	40d7d79b          	sraiw	a5,a5,0xd
    800028ce:	01cb2583          	lw	a1,28(s6)
    800028d2:	9dbd                	addw	a1,a1,a5
    800028d4:	855e                	mv	a0,s7
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	cd2080e7          	jalr	-814(ra) # 800025a8 <bread>
    800028de:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e0:	004b2503          	lw	a0,4(s6)
    800028e4:	000a849b          	sext.w	s1,s5
    800028e8:	8662                	mv	a2,s8
    800028ea:	faa4fde3          	bgeu	s1,a0,800028a4 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028ee:	41f6579b          	sraiw	a5,a2,0x1f
    800028f2:	01d7d69b          	srliw	a3,a5,0x1d
    800028f6:	00c6873b          	addw	a4,a3,a2
    800028fa:	00777793          	andi	a5,a4,7
    800028fe:	9f95                	subw	a5,a5,a3
    80002900:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002904:	4037571b          	sraiw	a4,a4,0x3
    80002908:	00e906b3          	add	a3,s2,a4
    8000290c:	0586c683          	lbu	a3,88(a3)
    80002910:	00d7f5b3          	and	a1,a5,a3
    80002914:	cd91                	beqz	a1,80002930 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002916:	2605                	addiw	a2,a2,1
    80002918:	2485                	addiw	s1,s1,1
    8000291a:	fd4618e3          	bne	a2,s4,800028ea <balloc+0x80>
    8000291e:	b759                	j	800028a4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	ba050513          	addi	a0,a0,-1120 # 800084c0 <syscalls+0x110>
    80002928:	00004097          	auipc	ra,0x4
    8000292c:	970080e7          	jalr	-1680(ra) # 80006298 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002930:	974a                	add	a4,a4,s2
    80002932:	8fd5                	or	a5,a5,a3
    80002934:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002938:	854a                	mv	a0,s2
    8000293a:	00001097          	auipc	ra,0x1
    8000293e:	01a080e7          	jalr	26(ra) # 80003954 <log_write>
        brelse(bp);
    80002942:	854a                	mv	a0,s2
    80002944:	00000097          	auipc	ra,0x0
    80002948:	d94080e7          	jalr	-620(ra) # 800026d8 <brelse>
  bp = bread(dev, bno);
    8000294c:	85a6                	mv	a1,s1
    8000294e:	855e                	mv	a0,s7
    80002950:	00000097          	auipc	ra,0x0
    80002954:	c58080e7          	jalr	-936(ra) # 800025a8 <bread>
    80002958:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000295a:	40000613          	li	a2,1024
    8000295e:	4581                	li	a1,0
    80002960:	05850513          	addi	a0,a0,88
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	814080e7          	jalr	-2028(ra) # 80000178 <memset>
  log_write(bp);
    8000296c:	854a                	mv	a0,s2
    8000296e:	00001097          	auipc	ra,0x1
    80002972:	fe6080e7          	jalr	-26(ra) # 80003954 <log_write>
  brelse(bp);
    80002976:	854a                	mv	a0,s2
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	d60080e7          	jalr	-672(ra) # 800026d8 <brelse>
}
    80002980:	8526                	mv	a0,s1
    80002982:	60e6                	ld	ra,88(sp)
    80002984:	6446                	ld	s0,80(sp)
    80002986:	64a6                	ld	s1,72(sp)
    80002988:	6906                	ld	s2,64(sp)
    8000298a:	79e2                	ld	s3,56(sp)
    8000298c:	7a42                	ld	s4,48(sp)
    8000298e:	7aa2                	ld	s5,40(sp)
    80002990:	7b02                	ld	s6,32(sp)
    80002992:	6be2                	ld	s7,24(sp)
    80002994:	6c42                	ld	s8,16(sp)
    80002996:	6ca2                	ld	s9,8(sp)
    80002998:	6125                	addi	sp,sp,96
    8000299a:	8082                	ret

000000008000299c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000299c:	7179                	addi	sp,sp,-48
    8000299e:	f406                	sd	ra,40(sp)
    800029a0:	f022                	sd	s0,32(sp)
    800029a2:	ec26                	sd	s1,24(sp)
    800029a4:	e84a                	sd	s2,16(sp)
    800029a6:	e44e                	sd	s3,8(sp)
    800029a8:	e052                	sd	s4,0(sp)
    800029aa:	1800                	addi	s0,sp,48
    800029ac:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029ae:	47ad                	li	a5,11
    800029b0:	04b7fe63          	bgeu	a5,a1,80002a0c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029b4:	ff45849b          	addiw	s1,a1,-12
    800029b8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029bc:	0ff00793          	li	a5,255
    800029c0:	0ae7e363          	bltu	a5,a4,80002a66 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029c4:	08052583          	lw	a1,128(a0)
    800029c8:	c5ad                	beqz	a1,80002a32 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029ca:	00092503          	lw	a0,0(s2)
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	bda080e7          	jalr	-1062(ra) # 800025a8 <bread>
    800029d6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029d8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029dc:	02049593          	slli	a1,s1,0x20
    800029e0:	9181                	srli	a1,a1,0x20
    800029e2:	058a                	slli	a1,a1,0x2
    800029e4:	00b784b3          	add	s1,a5,a1
    800029e8:	0004a983          	lw	s3,0(s1)
    800029ec:	04098d63          	beqz	s3,80002a46 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029f0:	8552                	mv	a0,s4
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	ce6080e7          	jalr	-794(ra) # 800026d8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029fa:	854e                	mv	a0,s3
    800029fc:	70a2                	ld	ra,40(sp)
    800029fe:	7402                	ld	s0,32(sp)
    80002a00:	64e2                	ld	s1,24(sp)
    80002a02:	6942                	ld	s2,16(sp)
    80002a04:	69a2                	ld	s3,8(sp)
    80002a06:	6a02                	ld	s4,0(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a0c:	02059493          	slli	s1,a1,0x20
    80002a10:	9081                	srli	s1,s1,0x20
    80002a12:	048a                	slli	s1,s1,0x2
    80002a14:	94aa                	add	s1,s1,a0
    80002a16:	0504a983          	lw	s3,80(s1)
    80002a1a:	fe0990e3          	bnez	s3,800029fa <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a1e:	4108                	lw	a0,0(a0)
    80002a20:	00000097          	auipc	ra,0x0
    80002a24:	e4a080e7          	jalr	-438(ra) # 8000286a <balloc>
    80002a28:	0005099b          	sext.w	s3,a0
    80002a2c:	0534a823          	sw	s3,80(s1)
    80002a30:	b7e9                	j	800029fa <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a32:	4108                	lw	a0,0(a0)
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	e36080e7          	jalr	-458(ra) # 8000286a <balloc>
    80002a3c:	0005059b          	sext.w	a1,a0
    80002a40:	08b92023          	sw	a1,128(s2)
    80002a44:	b759                	j	800029ca <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a46:	00092503          	lw	a0,0(s2)
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	e20080e7          	jalr	-480(ra) # 8000286a <balloc>
    80002a52:	0005099b          	sext.w	s3,a0
    80002a56:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a5a:	8552                	mv	a0,s4
    80002a5c:	00001097          	auipc	ra,0x1
    80002a60:	ef8080e7          	jalr	-264(ra) # 80003954 <log_write>
    80002a64:	b771                	j	800029f0 <bmap+0x54>
  panic("bmap: out of range");
    80002a66:	00006517          	auipc	a0,0x6
    80002a6a:	a7250513          	addi	a0,a0,-1422 # 800084d8 <syscalls+0x128>
    80002a6e:	00004097          	auipc	ra,0x4
    80002a72:	82a080e7          	jalr	-2006(ra) # 80006298 <panic>

0000000080002a76 <iget>:
{
    80002a76:	7179                	addi	sp,sp,-48
    80002a78:	f406                	sd	ra,40(sp)
    80002a7a:	f022                	sd	s0,32(sp)
    80002a7c:	ec26                	sd	s1,24(sp)
    80002a7e:	e84a                	sd	s2,16(sp)
    80002a80:	e44e                	sd	s3,8(sp)
    80002a82:	e052                	sd	s4,0(sp)
    80002a84:	1800                	addi	s0,sp,48
    80002a86:	89aa                	mv	s3,a0
    80002a88:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a8a:	0001d517          	auipc	a0,0x1d
    80002a8e:	aee50513          	addi	a0,a0,-1298 # 8001f578 <itable>
    80002a92:	00004097          	auipc	ra,0x4
    80002a96:	d50080e7          	jalr	-688(ra) # 800067e2 <acquire>
  empty = 0;
    80002a9a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a9c:	0001d497          	auipc	s1,0x1d
    80002aa0:	af448493          	addi	s1,s1,-1292 # 8001f590 <itable+0x18>
    80002aa4:	0001e697          	auipc	a3,0x1e
    80002aa8:	57c68693          	addi	a3,a3,1404 # 80021020 <log>
    80002aac:	a039                	j	80002aba <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aae:	02090b63          	beqz	s2,80002ae4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ab2:	08848493          	addi	s1,s1,136
    80002ab6:	02d48a63          	beq	s1,a3,80002aea <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aba:	449c                	lw	a5,8(s1)
    80002abc:	fef059e3          	blez	a5,80002aae <iget+0x38>
    80002ac0:	4098                	lw	a4,0(s1)
    80002ac2:	ff3716e3          	bne	a4,s3,80002aae <iget+0x38>
    80002ac6:	40d8                	lw	a4,4(s1)
    80002ac8:	ff4713e3          	bne	a4,s4,80002aae <iget+0x38>
      ip->ref++;
    80002acc:	2785                	addiw	a5,a5,1
    80002ace:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ad0:	0001d517          	auipc	a0,0x1d
    80002ad4:	aa850513          	addi	a0,a0,-1368 # 8001f578 <itable>
    80002ad8:	00004097          	auipc	ra,0x4
    80002adc:	dbe080e7          	jalr	-578(ra) # 80006896 <release>
      return ip;
    80002ae0:	8926                	mv	s2,s1
    80002ae2:	a03d                	j	80002b10 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ae4:	f7f9                	bnez	a5,80002ab2 <iget+0x3c>
    80002ae6:	8926                	mv	s2,s1
    80002ae8:	b7e9                	j	80002ab2 <iget+0x3c>
  if(empty == 0)
    80002aea:	02090c63          	beqz	s2,80002b22 <iget+0xac>
  ip->dev = dev;
    80002aee:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002af2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002af6:	4785                	li	a5,1
    80002af8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002afc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b00:	0001d517          	auipc	a0,0x1d
    80002b04:	a7850513          	addi	a0,a0,-1416 # 8001f578 <itable>
    80002b08:	00004097          	auipc	ra,0x4
    80002b0c:	d8e080e7          	jalr	-626(ra) # 80006896 <release>
}
    80002b10:	854a                	mv	a0,s2
    80002b12:	70a2                	ld	ra,40(sp)
    80002b14:	7402                	ld	s0,32(sp)
    80002b16:	64e2                	ld	s1,24(sp)
    80002b18:	6942                	ld	s2,16(sp)
    80002b1a:	69a2                	ld	s3,8(sp)
    80002b1c:	6a02                	ld	s4,0(sp)
    80002b1e:	6145                	addi	sp,sp,48
    80002b20:	8082                	ret
    panic("iget: no inodes");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	9ce50513          	addi	a0,a0,-1586 # 800084f0 <syscalls+0x140>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	76e080e7          	jalr	1902(ra) # 80006298 <panic>

0000000080002b32 <fsinit>:
fsinit(int dev) {
    80002b32:	7179                	addi	sp,sp,-48
    80002b34:	f406                	sd	ra,40(sp)
    80002b36:	f022                	sd	s0,32(sp)
    80002b38:	ec26                	sd	s1,24(sp)
    80002b3a:	e84a                	sd	s2,16(sp)
    80002b3c:	e44e                	sd	s3,8(sp)
    80002b3e:	1800                	addi	s0,sp,48
    80002b40:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b42:	4585                	li	a1,1
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	a64080e7          	jalr	-1436(ra) # 800025a8 <bread>
    80002b4c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b4e:	0001d997          	auipc	s3,0x1d
    80002b52:	a0a98993          	addi	s3,s3,-1526 # 8001f558 <sb>
    80002b56:	02000613          	li	a2,32
    80002b5a:	05850593          	addi	a1,a0,88
    80002b5e:	854e                	mv	a0,s3
    80002b60:	ffffd097          	auipc	ra,0xffffd
    80002b64:	678080e7          	jalr	1656(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b68:	8526                	mv	a0,s1
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	b6e080e7          	jalr	-1170(ra) # 800026d8 <brelse>
  if(sb.magic != FSMAGIC)
    80002b72:	0009a703          	lw	a4,0(s3)
    80002b76:	102037b7          	lui	a5,0x10203
    80002b7a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b7e:	02f71263          	bne	a4,a5,80002ba2 <fsinit+0x70>
  initlog(dev, &sb);
    80002b82:	0001d597          	auipc	a1,0x1d
    80002b86:	9d658593          	addi	a1,a1,-1578 # 8001f558 <sb>
    80002b8a:	854a                	mv	a0,s2
    80002b8c:	00001097          	auipc	ra,0x1
    80002b90:	b4c080e7          	jalr	-1204(ra) # 800036d8 <initlog>
}
    80002b94:	70a2                	ld	ra,40(sp)
    80002b96:	7402                	ld	s0,32(sp)
    80002b98:	64e2                	ld	s1,24(sp)
    80002b9a:	6942                	ld	s2,16(sp)
    80002b9c:	69a2                	ld	s3,8(sp)
    80002b9e:	6145                	addi	sp,sp,48
    80002ba0:	8082                	ret
    panic("invalid file system");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	95e50513          	addi	a0,a0,-1698 # 80008500 <syscalls+0x150>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	6ee080e7          	jalr	1774(ra) # 80006298 <panic>

0000000080002bb2 <iinit>:
{
    80002bb2:	7179                	addi	sp,sp,-48
    80002bb4:	f406                	sd	ra,40(sp)
    80002bb6:	f022                	sd	s0,32(sp)
    80002bb8:	ec26                	sd	s1,24(sp)
    80002bba:	e84a                	sd	s2,16(sp)
    80002bbc:	e44e                	sd	s3,8(sp)
    80002bbe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bc0:	00006597          	auipc	a1,0x6
    80002bc4:	95858593          	addi	a1,a1,-1704 # 80008518 <syscalls+0x168>
    80002bc8:	0001d517          	auipc	a0,0x1d
    80002bcc:	9b050513          	addi	a0,a0,-1616 # 8001f578 <itable>
    80002bd0:	00004097          	auipc	ra,0x4
    80002bd4:	b82080e7          	jalr	-1150(ra) # 80006752 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bd8:	0001d497          	auipc	s1,0x1d
    80002bdc:	9c848493          	addi	s1,s1,-1592 # 8001f5a0 <itable+0x28>
    80002be0:	0001e997          	auipc	s3,0x1e
    80002be4:	45098993          	addi	s3,s3,1104 # 80021030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002be8:	00006917          	auipc	s2,0x6
    80002bec:	93890913          	addi	s2,s2,-1736 # 80008520 <syscalls+0x170>
    80002bf0:	85ca                	mv	a1,s2
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	00001097          	auipc	ra,0x1
    80002bf8:	e46080e7          	jalr	-442(ra) # 80003a3a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bfc:	08848493          	addi	s1,s1,136
    80002c00:	ff3498e3          	bne	s1,s3,80002bf0 <iinit+0x3e>
}
    80002c04:	70a2                	ld	ra,40(sp)
    80002c06:	7402                	ld	s0,32(sp)
    80002c08:	64e2                	ld	s1,24(sp)
    80002c0a:	6942                	ld	s2,16(sp)
    80002c0c:	69a2                	ld	s3,8(sp)
    80002c0e:	6145                	addi	sp,sp,48
    80002c10:	8082                	ret

0000000080002c12 <ialloc>:
{
    80002c12:	715d                	addi	sp,sp,-80
    80002c14:	e486                	sd	ra,72(sp)
    80002c16:	e0a2                	sd	s0,64(sp)
    80002c18:	fc26                	sd	s1,56(sp)
    80002c1a:	f84a                	sd	s2,48(sp)
    80002c1c:	f44e                	sd	s3,40(sp)
    80002c1e:	f052                	sd	s4,32(sp)
    80002c20:	ec56                	sd	s5,24(sp)
    80002c22:	e85a                	sd	s6,16(sp)
    80002c24:	e45e                	sd	s7,8(sp)
    80002c26:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c28:	0001d717          	auipc	a4,0x1d
    80002c2c:	93c72703          	lw	a4,-1732(a4) # 8001f564 <sb+0xc>
    80002c30:	4785                	li	a5,1
    80002c32:	04e7fa63          	bgeu	a5,a4,80002c86 <ialloc+0x74>
    80002c36:	8aaa                	mv	s5,a0
    80002c38:	8bae                	mv	s7,a1
    80002c3a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c3c:	0001da17          	auipc	s4,0x1d
    80002c40:	91ca0a13          	addi	s4,s4,-1764 # 8001f558 <sb>
    80002c44:	00048b1b          	sext.w	s6,s1
    80002c48:	0044d593          	srli	a1,s1,0x4
    80002c4c:	018a2783          	lw	a5,24(s4)
    80002c50:	9dbd                	addw	a1,a1,a5
    80002c52:	8556                	mv	a0,s5
    80002c54:	00000097          	auipc	ra,0x0
    80002c58:	954080e7          	jalr	-1708(ra) # 800025a8 <bread>
    80002c5c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c5e:	05850993          	addi	s3,a0,88
    80002c62:	00f4f793          	andi	a5,s1,15
    80002c66:	079a                	slli	a5,a5,0x6
    80002c68:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c6a:	00099783          	lh	a5,0(s3)
    80002c6e:	c785                	beqz	a5,80002c96 <ialloc+0x84>
    brelse(bp);
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	a68080e7          	jalr	-1432(ra) # 800026d8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c78:	0485                	addi	s1,s1,1
    80002c7a:	00ca2703          	lw	a4,12(s4)
    80002c7e:	0004879b          	sext.w	a5,s1
    80002c82:	fce7e1e3          	bltu	a5,a4,80002c44 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c86:	00006517          	auipc	a0,0x6
    80002c8a:	8a250513          	addi	a0,a0,-1886 # 80008528 <syscalls+0x178>
    80002c8e:	00003097          	auipc	ra,0x3
    80002c92:	60a080e7          	jalr	1546(ra) # 80006298 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c96:	04000613          	li	a2,64
    80002c9a:	4581                	li	a1,0
    80002c9c:	854e                	mv	a0,s3
    80002c9e:	ffffd097          	auipc	ra,0xffffd
    80002ca2:	4da080e7          	jalr	1242(ra) # 80000178 <memset>
      dip->type = type;
    80002ca6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002caa:	854a                	mv	a0,s2
    80002cac:	00001097          	auipc	ra,0x1
    80002cb0:	ca8080e7          	jalr	-856(ra) # 80003954 <log_write>
      brelse(bp);
    80002cb4:	854a                	mv	a0,s2
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	a22080e7          	jalr	-1502(ra) # 800026d8 <brelse>
      return iget(dev, inum);
    80002cbe:	85da                	mv	a1,s6
    80002cc0:	8556                	mv	a0,s5
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	db4080e7          	jalr	-588(ra) # 80002a76 <iget>
}
    80002cca:	60a6                	ld	ra,72(sp)
    80002ccc:	6406                	ld	s0,64(sp)
    80002cce:	74e2                	ld	s1,56(sp)
    80002cd0:	7942                	ld	s2,48(sp)
    80002cd2:	79a2                	ld	s3,40(sp)
    80002cd4:	7a02                	ld	s4,32(sp)
    80002cd6:	6ae2                	ld	s5,24(sp)
    80002cd8:	6b42                	ld	s6,16(sp)
    80002cda:	6ba2                	ld	s7,8(sp)
    80002cdc:	6161                	addi	sp,sp,80
    80002cde:	8082                	ret

0000000080002ce0 <iupdate>:
{
    80002ce0:	1101                	addi	sp,sp,-32
    80002ce2:	ec06                	sd	ra,24(sp)
    80002ce4:	e822                	sd	s0,16(sp)
    80002ce6:	e426                	sd	s1,8(sp)
    80002ce8:	e04a                	sd	s2,0(sp)
    80002cea:	1000                	addi	s0,sp,32
    80002cec:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cee:	415c                	lw	a5,4(a0)
    80002cf0:	0047d79b          	srliw	a5,a5,0x4
    80002cf4:	0001d597          	auipc	a1,0x1d
    80002cf8:	87c5a583          	lw	a1,-1924(a1) # 8001f570 <sb+0x18>
    80002cfc:	9dbd                	addw	a1,a1,a5
    80002cfe:	4108                	lw	a0,0(a0)
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	8a8080e7          	jalr	-1880(ra) # 800025a8 <bread>
    80002d08:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d0a:	05850793          	addi	a5,a0,88
    80002d0e:	40c8                	lw	a0,4(s1)
    80002d10:	893d                	andi	a0,a0,15
    80002d12:	051a                	slli	a0,a0,0x6
    80002d14:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d16:	04449703          	lh	a4,68(s1)
    80002d1a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d1e:	04649703          	lh	a4,70(s1)
    80002d22:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d26:	04849703          	lh	a4,72(s1)
    80002d2a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d2e:	04a49703          	lh	a4,74(s1)
    80002d32:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d36:	44f8                	lw	a4,76(s1)
    80002d38:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d3a:	03400613          	li	a2,52
    80002d3e:	05048593          	addi	a1,s1,80
    80002d42:	0531                	addi	a0,a0,12
    80002d44:	ffffd097          	auipc	ra,0xffffd
    80002d48:	494080e7          	jalr	1172(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d4c:	854a                	mv	a0,s2
    80002d4e:	00001097          	auipc	ra,0x1
    80002d52:	c06080e7          	jalr	-1018(ra) # 80003954 <log_write>
  brelse(bp);
    80002d56:	854a                	mv	a0,s2
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	980080e7          	jalr	-1664(ra) # 800026d8 <brelse>
}
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6902                	ld	s2,0(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <idup>:
{
    80002d6c:	1101                	addi	sp,sp,-32
    80002d6e:	ec06                	sd	ra,24(sp)
    80002d70:	e822                	sd	s0,16(sp)
    80002d72:	e426                	sd	s1,8(sp)
    80002d74:	1000                	addi	s0,sp,32
    80002d76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d78:	0001d517          	auipc	a0,0x1d
    80002d7c:	80050513          	addi	a0,a0,-2048 # 8001f578 <itable>
    80002d80:	00004097          	auipc	ra,0x4
    80002d84:	a62080e7          	jalr	-1438(ra) # 800067e2 <acquire>
  ip->ref++;
    80002d88:	449c                	lw	a5,8(s1)
    80002d8a:	2785                	addiw	a5,a5,1
    80002d8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8e:	0001c517          	auipc	a0,0x1c
    80002d92:	7ea50513          	addi	a0,a0,2026 # 8001f578 <itable>
    80002d96:	00004097          	auipc	ra,0x4
    80002d9a:	b00080e7          	jalr	-1280(ra) # 80006896 <release>
}
    80002d9e:	8526                	mv	a0,s1
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	64a2                	ld	s1,8(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret

0000000080002daa <ilock>:
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	e426                	sd	s1,8(sp)
    80002db2:	e04a                	sd	s2,0(sp)
    80002db4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002db6:	c115                	beqz	a0,80002dda <ilock+0x30>
    80002db8:	84aa                	mv	s1,a0
    80002dba:	451c                	lw	a5,8(a0)
    80002dbc:	00f05f63          	blez	a5,80002dda <ilock+0x30>
  acquiresleep(&ip->lock);
    80002dc0:	0541                	addi	a0,a0,16
    80002dc2:	00001097          	auipc	ra,0x1
    80002dc6:	cb2080e7          	jalr	-846(ra) # 80003a74 <acquiresleep>
  if(ip->valid == 0){
    80002dca:	40bc                	lw	a5,64(s1)
    80002dcc:	cf99                	beqz	a5,80002dea <ilock+0x40>
}
    80002dce:	60e2                	ld	ra,24(sp)
    80002dd0:	6442                	ld	s0,16(sp)
    80002dd2:	64a2                	ld	s1,8(sp)
    80002dd4:	6902                	ld	s2,0(sp)
    80002dd6:	6105                	addi	sp,sp,32
    80002dd8:	8082                	ret
    panic("ilock");
    80002dda:	00005517          	auipc	a0,0x5
    80002dde:	76650513          	addi	a0,a0,1894 # 80008540 <syscalls+0x190>
    80002de2:	00003097          	auipc	ra,0x3
    80002de6:	4b6080e7          	jalr	1206(ra) # 80006298 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dea:	40dc                	lw	a5,4(s1)
    80002dec:	0047d79b          	srliw	a5,a5,0x4
    80002df0:	0001c597          	auipc	a1,0x1c
    80002df4:	7805a583          	lw	a1,1920(a1) # 8001f570 <sb+0x18>
    80002df8:	9dbd                	addw	a1,a1,a5
    80002dfa:	4088                	lw	a0,0(s1)
    80002dfc:	fffff097          	auipc	ra,0xfffff
    80002e00:	7ac080e7          	jalr	1964(ra) # 800025a8 <bread>
    80002e04:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e06:	05850593          	addi	a1,a0,88
    80002e0a:	40dc                	lw	a5,4(s1)
    80002e0c:	8bbd                	andi	a5,a5,15
    80002e0e:	079a                	slli	a5,a5,0x6
    80002e10:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e12:	00059783          	lh	a5,0(a1)
    80002e16:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e1a:	00259783          	lh	a5,2(a1)
    80002e1e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e22:	00459783          	lh	a5,4(a1)
    80002e26:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e2a:	00659783          	lh	a5,6(a1)
    80002e2e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e32:	459c                	lw	a5,8(a1)
    80002e34:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e36:	03400613          	li	a2,52
    80002e3a:	05b1                	addi	a1,a1,12
    80002e3c:	05048513          	addi	a0,s1,80
    80002e40:	ffffd097          	auipc	ra,0xffffd
    80002e44:	398080e7          	jalr	920(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	88e080e7          	jalr	-1906(ra) # 800026d8 <brelse>
    ip->valid = 1;
    80002e52:	4785                	li	a5,1
    80002e54:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e56:	04449783          	lh	a5,68(s1)
    80002e5a:	fbb5                	bnez	a5,80002dce <ilock+0x24>
      panic("ilock: no type");
    80002e5c:	00005517          	auipc	a0,0x5
    80002e60:	6ec50513          	addi	a0,a0,1772 # 80008548 <syscalls+0x198>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	434080e7          	jalr	1076(ra) # 80006298 <panic>

0000000080002e6c <iunlock>:
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	e04a                	sd	s2,0(sp)
    80002e76:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e78:	c905                	beqz	a0,80002ea8 <iunlock+0x3c>
    80002e7a:	84aa                	mv	s1,a0
    80002e7c:	01050913          	addi	s2,a0,16
    80002e80:	854a                	mv	a0,s2
    80002e82:	00001097          	auipc	ra,0x1
    80002e86:	c8c080e7          	jalr	-884(ra) # 80003b0e <holdingsleep>
    80002e8a:	cd19                	beqz	a0,80002ea8 <iunlock+0x3c>
    80002e8c:	449c                	lw	a5,8(s1)
    80002e8e:	00f05d63          	blez	a5,80002ea8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e92:	854a                	mv	a0,s2
    80002e94:	00001097          	auipc	ra,0x1
    80002e98:	c36080e7          	jalr	-970(ra) # 80003aca <releasesleep>
}
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	64a2                	ld	s1,8(sp)
    80002ea2:	6902                	ld	s2,0(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret
    panic("iunlock");
    80002ea8:	00005517          	auipc	a0,0x5
    80002eac:	6b050513          	addi	a0,a0,1712 # 80008558 <syscalls+0x1a8>
    80002eb0:	00003097          	auipc	ra,0x3
    80002eb4:	3e8080e7          	jalr	1000(ra) # 80006298 <panic>

0000000080002eb8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eb8:	7179                	addi	sp,sp,-48
    80002eba:	f406                	sd	ra,40(sp)
    80002ebc:	f022                	sd	s0,32(sp)
    80002ebe:	ec26                	sd	s1,24(sp)
    80002ec0:	e84a                	sd	s2,16(sp)
    80002ec2:	e44e                	sd	s3,8(sp)
    80002ec4:	e052                	sd	s4,0(sp)
    80002ec6:	1800                	addi	s0,sp,48
    80002ec8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002eca:	05050493          	addi	s1,a0,80
    80002ece:	08050913          	addi	s2,a0,128
    80002ed2:	a021                	j	80002eda <itrunc+0x22>
    80002ed4:	0491                	addi	s1,s1,4
    80002ed6:	01248d63          	beq	s1,s2,80002ef0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002eda:	408c                	lw	a1,0(s1)
    80002edc:	dde5                	beqz	a1,80002ed4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ede:	0009a503          	lw	a0,0(s3)
    80002ee2:	00000097          	auipc	ra,0x0
    80002ee6:	90c080e7          	jalr	-1780(ra) # 800027ee <bfree>
      ip->addrs[i] = 0;
    80002eea:	0004a023          	sw	zero,0(s1)
    80002eee:	b7dd                	j	80002ed4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ef0:	0809a583          	lw	a1,128(s3)
    80002ef4:	e185                	bnez	a1,80002f14 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ef6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002efa:	854e                	mv	a0,s3
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	de4080e7          	jalr	-540(ra) # 80002ce0 <iupdate>
}
    80002f04:	70a2                	ld	ra,40(sp)
    80002f06:	7402                	ld	s0,32(sp)
    80002f08:	64e2                	ld	s1,24(sp)
    80002f0a:	6942                	ld	s2,16(sp)
    80002f0c:	69a2                	ld	s3,8(sp)
    80002f0e:	6a02                	ld	s4,0(sp)
    80002f10:	6145                	addi	sp,sp,48
    80002f12:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	690080e7          	jalr	1680(ra) # 800025a8 <bread>
    80002f20:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f22:	05850493          	addi	s1,a0,88
    80002f26:	45850913          	addi	s2,a0,1112
    80002f2a:	a811                	j	80002f3e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f2c:	0009a503          	lw	a0,0(s3)
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8be080e7          	jalr	-1858(ra) # 800027ee <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f38:	0491                	addi	s1,s1,4
    80002f3a:	01248563          	beq	s1,s2,80002f44 <itrunc+0x8c>
      if(a[j])
    80002f3e:	408c                	lw	a1,0(s1)
    80002f40:	dde5                	beqz	a1,80002f38 <itrunc+0x80>
    80002f42:	b7ed                	j	80002f2c <itrunc+0x74>
    brelse(bp);
    80002f44:	8552                	mv	a0,s4
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	792080e7          	jalr	1938(ra) # 800026d8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f4e:	0809a583          	lw	a1,128(s3)
    80002f52:	0009a503          	lw	a0,0(s3)
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	898080e7          	jalr	-1896(ra) # 800027ee <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f5e:	0809a023          	sw	zero,128(s3)
    80002f62:	bf51                	j	80002ef6 <itrunc+0x3e>

0000000080002f64 <iput>:
{
    80002f64:	1101                	addi	sp,sp,-32
    80002f66:	ec06                	sd	ra,24(sp)
    80002f68:	e822                	sd	s0,16(sp)
    80002f6a:	e426                	sd	s1,8(sp)
    80002f6c:	e04a                	sd	s2,0(sp)
    80002f6e:	1000                	addi	s0,sp,32
    80002f70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f72:	0001c517          	auipc	a0,0x1c
    80002f76:	60650513          	addi	a0,a0,1542 # 8001f578 <itable>
    80002f7a:	00004097          	auipc	ra,0x4
    80002f7e:	868080e7          	jalr	-1944(ra) # 800067e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f82:	4498                	lw	a4,8(s1)
    80002f84:	4785                	li	a5,1
    80002f86:	02f70363          	beq	a4,a5,80002fac <iput+0x48>
  ip->ref--;
    80002f8a:	449c                	lw	a5,8(s1)
    80002f8c:	37fd                	addiw	a5,a5,-1
    80002f8e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f90:	0001c517          	auipc	a0,0x1c
    80002f94:	5e850513          	addi	a0,a0,1512 # 8001f578 <itable>
    80002f98:	00004097          	auipc	ra,0x4
    80002f9c:	8fe080e7          	jalr	-1794(ra) # 80006896 <release>
}
    80002fa0:	60e2                	ld	ra,24(sp)
    80002fa2:	6442                	ld	s0,16(sp)
    80002fa4:	64a2                	ld	s1,8(sp)
    80002fa6:	6902                	ld	s2,0(sp)
    80002fa8:	6105                	addi	sp,sp,32
    80002faa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fac:	40bc                	lw	a5,64(s1)
    80002fae:	dff1                	beqz	a5,80002f8a <iput+0x26>
    80002fb0:	04a49783          	lh	a5,74(s1)
    80002fb4:	fbf9                	bnez	a5,80002f8a <iput+0x26>
    acquiresleep(&ip->lock);
    80002fb6:	01048913          	addi	s2,s1,16
    80002fba:	854a                	mv	a0,s2
    80002fbc:	00001097          	auipc	ra,0x1
    80002fc0:	ab8080e7          	jalr	-1352(ra) # 80003a74 <acquiresleep>
    release(&itable.lock);
    80002fc4:	0001c517          	auipc	a0,0x1c
    80002fc8:	5b450513          	addi	a0,a0,1460 # 8001f578 <itable>
    80002fcc:	00004097          	auipc	ra,0x4
    80002fd0:	8ca080e7          	jalr	-1846(ra) # 80006896 <release>
    itrunc(ip);
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	ee2080e7          	jalr	-286(ra) # 80002eb8 <itrunc>
    ip->type = 0;
    80002fde:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	cfc080e7          	jalr	-772(ra) # 80002ce0 <iupdate>
    ip->valid = 0;
    80002fec:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ff0:	854a                	mv	a0,s2
    80002ff2:	00001097          	auipc	ra,0x1
    80002ff6:	ad8080e7          	jalr	-1320(ra) # 80003aca <releasesleep>
    acquire(&itable.lock);
    80002ffa:	0001c517          	auipc	a0,0x1c
    80002ffe:	57e50513          	addi	a0,a0,1406 # 8001f578 <itable>
    80003002:	00003097          	auipc	ra,0x3
    80003006:	7e0080e7          	jalr	2016(ra) # 800067e2 <acquire>
    8000300a:	b741                	j	80002f8a <iput+0x26>

000000008000300c <iunlockput>:
{
    8000300c:	1101                	addi	sp,sp,-32
    8000300e:	ec06                	sd	ra,24(sp)
    80003010:	e822                	sd	s0,16(sp)
    80003012:	e426                	sd	s1,8(sp)
    80003014:	1000                	addi	s0,sp,32
    80003016:	84aa                	mv	s1,a0
  iunlock(ip);
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	e54080e7          	jalr	-428(ra) # 80002e6c <iunlock>
  iput(ip);
    80003020:	8526                	mv	a0,s1
    80003022:	00000097          	auipc	ra,0x0
    80003026:	f42080e7          	jalr	-190(ra) # 80002f64 <iput>
}
    8000302a:	60e2                	ld	ra,24(sp)
    8000302c:	6442                	ld	s0,16(sp)
    8000302e:	64a2                	ld	s1,8(sp)
    80003030:	6105                	addi	sp,sp,32
    80003032:	8082                	ret

0000000080003034 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003034:	1141                	addi	sp,sp,-16
    80003036:	e422                	sd	s0,8(sp)
    80003038:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000303a:	411c                	lw	a5,0(a0)
    8000303c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000303e:	415c                	lw	a5,4(a0)
    80003040:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003042:	04451783          	lh	a5,68(a0)
    80003046:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000304a:	04a51783          	lh	a5,74(a0)
    8000304e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003052:	04c56783          	lwu	a5,76(a0)
    80003056:	e99c                	sd	a5,16(a1)
}
    80003058:	6422                	ld	s0,8(sp)
    8000305a:	0141                	addi	sp,sp,16
    8000305c:	8082                	ret

000000008000305e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000305e:	457c                	lw	a5,76(a0)
    80003060:	0ed7e963          	bltu	a5,a3,80003152 <readi+0xf4>
{
    80003064:	7159                	addi	sp,sp,-112
    80003066:	f486                	sd	ra,104(sp)
    80003068:	f0a2                	sd	s0,96(sp)
    8000306a:	eca6                	sd	s1,88(sp)
    8000306c:	e8ca                	sd	s2,80(sp)
    8000306e:	e4ce                	sd	s3,72(sp)
    80003070:	e0d2                	sd	s4,64(sp)
    80003072:	fc56                	sd	s5,56(sp)
    80003074:	f85a                	sd	s6,48(sp)
    80003076:	f45e                	sd	s7,40(sp)
    80003078:	f062                	sd	s8,32(sp)
    8000307a:	ec66                	sd	s9,24(sp)
    8000307c:	e86a                	sd	s10,16(sp)
    8000307e:	e46e                	sd	s11,8(sp)
    80003080:	1880                	addi	s0,sp,112
    80003082:	8baa                	mv	s7,a0
    80003084:	8c2e                	mv	s8,a1
    80003086:	8ab2                	mv	s5,a2
    80003088:	84b6                	mv	s1,a3
    8000308a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000308c:	9f35                	addw	a4,a4,a3
    return 0;
    8000308e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003090:	0ad76063          	bltu	a4,a3,80003130 <readi+0xd2>
  if(off + n > ip->size)
    80003094:	00e7f463          	bgeu	a5,a4,8000309c <readi+0x3e>
    n = ip->size - off;
    80003098:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000309c:	0a0b0963          	beqz	s6,8000314e <readi+0xf0>
    800030a0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030a6:	5cfd                	li	s9,-1
    800030a8:	a82d                	j	800030e2 <readi+0x84>
    800030aa:	020a1d93          	slli	s11,s4,0x20
    800030ae:	020ddd93          	srli	s11,s11,0x20
    800030b2:	05890613          	addi	a2,s2,88
    800030b6:	86ee                	mv	a3,s11
    800030b8:	963a                	add	a2,a2,a4
    800030ba:	85d6                	mv	a1,s5
    800030bc:	8562                	mv	a0,s8
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	9c4080e7          	jalr	-1596(ra) # 80001a82 <either_copyout>
    800030c6:	05950d63          	beq	a0,s9,80003120 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030ca:	854a                	mv	a0,s2
    800030cc:	fffff097          	auipc	ra,0xfffff
    800030d0:	60c080e7          	jalr	1548(ra) # 800026d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d4:	013a09bb          	addw	s3,s4,s3
    800030d8:	009a04bb          	addw	s1,s4,s1
    800030dc:	9aee                	add	s5,s5,s11
    800030de:	0569f763          	bgeu	s3,s6,8000312c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030e2:	000ba903          	lw	s2,0(s7)
    800030e6:	00a4d59b          	srliw	a1,s1,0xa
    800030ea:	855e                	mv	a0,s7
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	8b0080e7          	jalr	-1872(ra) # 8000299c <bmap>
    800030f4:	0005059b          	sext.w	a1,a0
    800030f8:	854a                	mv	a0,s2
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	4ae080e7          	jalr	1198(ra) # 800025a8 <bread>
    80003102:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003104:	3ff4f713          	andi	a4,s1,1023
    80003108:	40ed07bb          	subw	a5,s10,a4
    8000310c:	413b06bb          	subw	a3,s6,s3
    80003110:	8a3e                	mv	s4,a5
    80003112:	2781                	sext.w	a5,a5
    80003114:	0006861b          	sext.w	a2,a3
    80003118:	f8f679e3          	bgeu	a2,a5,800030aa <readi+0x4c>
    8000311c:	8a36                	mv	s4,a3
    8000311e:	b771                	j	800030aa <readi+0x4c>
      brelse(bp);
    80003120:	854a                	mv	a0,s2
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	5b6080e7          	jalr	1462(ra) # 800026d8 <brelse>
      tot = -1;
    8000312a:	59fd                	li	s3,-1
  }
  return tot;
    8000312c:	0009851b          	sext.w	a0,s3
}
    80003130:	70a6                	ld	ra,104(sp)
    80003132:	7406                	ld	s0,96(sp)
    80003134:	64e6                	ld	s1,88(sp)
    80003136:	6946                	ld	s2,80(sp)
    80003138:	69a6                	ld	s3,72(sp)
    8000313a:	6a06                	ld	s4,64(sp)
    8000313c:	7ae2                	ld	s5,56(sp)
    8000313e:	7b42                	ld	s6,48(sp)
    80003140:	7ba2                	ld	s7,40(sp)
    80003142:	7c02                	ld	s8,32(sp)
    80003144:	6ce2                	ld	s9,24(sp)
    80003146:	6d42                	ld	s10,16(sp)
    80003148:	6da2                	ld	s11,8(sp)
    8000314a:	6165                	addi	sp,sp,112
    8000314c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000314e:	89da                	mv	s3,s6
    80003150:	bff1                	j	8000312c <readi+0xce>
    return 0;
    80003152:	4501                	li	a0,0
}
    80003154:	8082                	ret

0000000080003156 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003156:	457c                	lw	a5,76(a0)
    80003158:	10d7e863          	bltu	a5,a3,80003268 <writei+0x112>
{
    8000315c:	7159                	addi	sp,sp,-112
    8000315e:	f486                	sd	ra,104(sp)
    80003160:	f0a2                	sd	s0,96(sp)
    80003162:	eca6                	sd	s1,88(sp)
    80003164:	e8ca                	sd	s2,80(sp)
    80003166:	e4ce                	sd	s3,72(sp)
    80003168:	e0d2                	sd	s4,64(sp)
    8000316a:	fc56                	sd	s5,56(sp)
    8000316c:	f85a                	sd	s6,48(sp)
    8000316e:	f45e                	sd	s7,40(sp)
    80003170:	f062                	sd	s8,32(sp)
    80003172:	ec66                	sd	s9,24(sp)
    80003174:	e86a                	sd	s10,16(sp)
    80003176:	e46e                	sd	s11,8(sp)
    80003178:	1880                	addi	s0,sp,112
    8000317a:	8b2a                	mv	s6,a0
    8000317c:	8c2e                	mv	s8,a1
    8000317e:	8ab2                	mv	s5,a2
    80003180:	8936                	mv	s2,a3
    80003182:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003184:	00e687bb          	addw	a5,a3,a4
    80003188:	0ed7e263          	bltu	a5,a3,8000326c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000318c:	00043737          	lui	a4,0x43
    80003190:	0ef76063          	bltu	a4,a5,80003270 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003194:	0c0b8863          	beqz	s7,80003264 <writei+0x10e>
    80003198:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000319a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000319e:	5cfd                	li	s9,-1
    800031a0:	a091                	j	800031e4 <writei+0x8e>
    800031a2:	02099d93          	slli	s11,s3,0x20
    800031a6:	020ddd93          	srli	s11,s11,0x20
    800031aa:	05848513          	addi	a0,s1,88
    800031ae:	86ee                	mv	a3,s11
    800031b0:	8656                	mv	a2,s5
    800031b2:	85e2                	mv	a1,s8
    800031b4:	953a                	add	a0,a0,a4
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	922080e7          	jalr	-1758(ra) # 80001ad8 <either_copyin>
    800031be:	07950263          	beq	a0,s9,80003222 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031c2:	8526                	mv	a0,s1
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	790080e7          	jalr	1936(ra) # 80003954 <log_write>
    brelse(bp);
    800031cc:	8526                	mv	a0,s1
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	50a080e7          	jalr	1290(ra) # 800026d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d6:	01498a3b          	addw	s4,s3,s4
    800031da:	0129893b          	addw	s2,s3,s2
    800031de:	9aee                	add	s5,s5,s11
    800031e0:	057a7663          	bgeu	s4,s7,8000322c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031e4:	000b2483          	lw	s1,0(s6)
    800031e8:	00a9559b          	srliw	a1,s2,0xa
    800031ec:	855a                	mv	a0,s6
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	7ae080e7          	jalr	1966(ra) # 8000299c <bmap>
    800031f6:	0005059b          	sext.w	a1,a0
    800031fa:	8526                	mv	a0,s1
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	3ac080e7          	jalr	940(ra) # 800025a8 <bread>
    80003204:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003206:	3ff97713          	andi	a4,s2,1023
    8000320a:	40ed07bb          	subw	a5,s10,a4
    8000320e:	414b86bb          	subw	a3,s7,s4
    80003212:	89be                	mv	s3,a5
    80003214:	2781                	sext.w	a5,a5
    80003216:	0006861b          	sext.w	a2,a3
    8000321a:	f8f674e3          	bgeu	a2,a5,800031a2 <writei+0x4c>
    8000321e:	89b6                	mv	s3,a3
    80003220:	b749                	j	800031a2 <writei+0x4c>
      brelse(bp);
    80003222:	8526                	mv	a0,s1
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	4b4080e7          	jalr	1204(ra) # 800026d8 <brelse>
  }

  if(off > ip->size)
    8000322c:	04cb2783          	lw	a5,76(s6)
    80003230:	0127f463          	bgeu	a5,s2,80003238 <writei+0xe2>
    ip->size = off;
    80003234:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003238:	855a                	mv	a0,s6
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	aa6080e7          	jalr	-1370(ra) # 80002ce0 <iupdate>

  return tot;
    80003242:	000a051b          	sext.w	a0,s4
}
    80003246:	70a6                	ld	ra,104(sp)
    80003248:	7406                	ld	s0,96(sp)
    8000324a:	64e6                	ld	s1,88(sp)
    8000324c:	6946                	ld	s2,80(sp)
    8000324e:	69a6                	ld	s3,72(sp)
    80003250:	6a06                	ld	s4,64(sp)
    80003252:	7ae2                	ld	s5,56(sp)
    80003254:	7b42                	ld	s6,48(sp)
    80003256:	7ba2                	ld	s7,40(sp)
    80003258:	7c02                	ld	s8,32(sp)
    8000325a:	6ce2                	ld	s9,24(sp)
    8000325c:	6d42                	ld	s10,16(sp)
    8000325e:	6da2                	ld	s11,8(sp)
    80003260:	6165                	addi	sp,sp,112
    80003262:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003264:	8a5e                	mv	s4,s7
    80003266:	bfc9                	j	80003238 <writei+0xe2>
    return -1;
    80003268:	557d                	li	a0,-1
}
    8000326a:	8082                	ret
    return -1;
    8000326c:	557d                	li	a0,-1
    8000326e:	bfe1                	j	80003246 <writei+0xf0>
    return -1;
    80003270:	557d                	li	a0,-1
    80003272:	bfd1                	j	80003246 <writei+0xf0>

0000000080003274 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003274:	1141                	addi	sp,sp,-16
    80003276:	e406                	sd	ra,8(sp)
    80003278:	e022                	sd	s0,0(sp)
    8000327a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000327c:	4639                	li	a2,14
    8000327e:	ffffd097          	auipc	ra,0xffffd
    80003282:	fd2080e7          	jalr	-46(ra) # 80000250 <strncmp>
}
    80003286:	60a2                	ld	ra,8(sp)
    80003288:	6402                	ld	s0,0(sp)
    8000328a:	0141                	addi	sp,sp,16
    8000328c:	8082                	ret

000000008000328e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000328e:	7139                	addi	sp,sp,-64
    80003290:	fc06                	sd	ra,56(sp)
    80003292:	f822                	sd	s0,48(sp)
    80003294:	f426                	sd	s1,40(sp)
    80003296:	f04a                	sd	s2,32(sp)
    80003298:	ec4e                	sd	s3,24(sp)
    8000329a:	e852                	sd	s4,16(sp)
    8000329c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000329e:	04451703          	lh	a4,68(a0)
    800032a2:	4785                	li	a5,1
    800032a4:	00f71a63          	bne	a4,a5,800032b8 <dirlookup+0x2a>
    800032a8:	892a                	mv	s2,a0
    800032aa:	89ae                	mv	s3,a1
    800032ac:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ae:	457c                	lw	a5,76(a0)
    800032b0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032b2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b4:	e79d                	bnez	a5,800032e2 <dirlookup+0x54>
    800032b6:	a8a5                	j	8000332e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032b8:	00005517          	auipc	a0,0x5
    800032bc:	2a850513          	addi	a0,a0,680 # 80008560 <syscalls+0x1b0>
    800032c0:	00003097          	auipc	ra,0x3
    800032c4:	fd8080e7          	jalr	-40(ra) # 80006298 <panic>
      panic("dirlookup read");
    800032c8:	00005517          	auipc	a0,0x5
    800032cc:	2b050513          	addi	a0,a0,688 # 80008578 <syscalls+0x1c8>
    800032d0:	00003097          	auipc	ra,0x3
    800032d4:	fc8080e7          	jalr	-56(ra) # 80006298 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d8:	24c1                	addiw	s1,s1,16
    800032da:	04c92783          	lw	a5,76(s2)
    800032de:	04f4f763          	bgeu	s1,a5,8000332c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e2:	4741                	li	a4,16
    800032e4:	86a6                	mv	a3,s1
    800032e6:	fc040613          	addi	a2,s0,-64
    800032ea:	4581                	li	a1,0
    800032ec:	854a                	mv	a0,s2
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	d70080e7          	jalr	-656(ra) # 8000305e <readi>
    800032f6:	47c1                	li	a5,16
    800032f8:	fcf518e3          	bne	a0,a5,800032c8 <dirlookup+0x3a>
    if(de.inum == 0)
    800032fc:	fc045783          	lhu	a5,-64(s0)
    80003300:	dfe1                	beqz	a5,800032d8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003302:	fc240593          	addi	a1,s0,-62
    80003306:	854e                	mv	a0,s3
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	f6c080e7          	jalr	-148(ra) # 80003274 <namecmp>
    80003310:	f561                	bnez	a0,800032d8 <dirlookup+0x4a>
      if(poff)
    80003312:	000a0463          	beqz	s4,8000331a <dirlookup+0x8c>
        *poff = off;
    80003316:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000331a:	fc045583          	lhu	a1,-64(s0)
    8000331e:	00092503          	lw	a0,0(s2)
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	754080e7          	jalr	1876(ra) # 80002a76 <iget>
    8000332a:	a011                	j	8000332e <dirlookup+0xa0>
  return 0;
    8000332c:	4501                	li	a0,0
}
    8000332e:	70e2                	ld	ra,56(sp)
    80003330:	7442                	ld	s0,48(sp)
    80003332:	74a2                	ld	s1,40(sp)
    80003334:	7902                	ld	s2,32(sp)
    80003336:	69e2                	ld	s3,24(sp)
    80003338:	6a42                	ld	s4,16(sp)
    8000333a:	6121                	addi	sp,sp,64
    8000333c:	8082                	ret

000000008000333e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000333e:	711d                	addi	sp,sp,-96
    80003340:	ec86                	sd	ra,88(sp)
    80003342:	e8a2                	sd	s0,80(sp)
    80003344:	e4a6                	sd	s1,72(sp)
    80003346:	e0ca                	sd	s2,64(sp)
    80003348:	fc4e                	sd	s3,56(sp)
    8000334a:	f852                	sd	s4,48(sp)
    8000334c:	f456                	sd	s5,40(sp)
    8000334e:	f05a                	sd	s6,32(sp)
    80003350:	ec5e                	sd	s7,24(sp)
    80003352:	e862                	sd	s8,16(sp)
    80003354:	e466                	sd	s9,8(sp)
    80003356:	1080                	addi	s0,sp,96
    80003358:	84aa                	mv	s1,a0
    8000335a:	8b2e                	mv	s6,a1
    8000335c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000335e:	00054703          	lbu	a4,0(a0)
    80003362:	02f00793          	li	a5,47
    80003366:	02f70363          	beq	a4,a5,8000338c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000336a:	ffffe097          	auipc	ra,0xffffe
    8000336e:	ac0080e7          	jalr	-1344(ra) # 80000e2a <myproc>
    80003372:	15053503          	ld	a0,336(a0)
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	9f6080e7          	jalr	-1546(ra) # 80002d6c <idup>
    8000337e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003380:	02f00913          	li	s2,47
  len = path - s;
    80003384:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003386:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003388:	4c05                	li	s8,1
    8000338a:	a865                	j	80003442 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000338c:	4585                	li	a1,1
    8000338e:	4505                	li	a0,1
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	6e6080e7          	jalr	1766(ra) # 80002a76 <iget>
    80003398:	89aa                	mv	s3,a0
    8000339a:	b7dd                	j	80003380 <namex+0x42>
      iunlockput(ip);
    8000339c:	854e                	mv	a0,s3
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	c6e080e7          	jalr	-914(ra) # 8000300c <iunlockput>
      return 0;
    800033a6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033a8:	854e                	mv	a0,s3
    800033aa:	60e6                	ld	ra,88(sp)
    800033ac:	6446                	ld	s0,80(sp)
    800033ae:	64a6                	ld	s1,72(sp)
    800033b0:	6906                	ld	s2,64(sp)
    800033b2:	79e2                	ld	s3,56(sp)
    800033b4:	7a42                	ld	s4,48(sp)
    800033b6:	7aa2                	ld	s5,40(sp)
    800033b8:	7b02                	ld	s6,32(sp)
    800033ba:	6be2                	ld	s7,24(sp)
    800033bc:	6c42                	ld	s8,16(sp)
    800033be:	6ca2                	ld	s9,8(sp)
    800033c0:	6125                	addi	sp,sp,96
    800033c2:	8082                	ret
      iunlock(ip);
    800033c4:	854e                	mv	a0,s3
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	aa6080e7          	jalr	-1370(ra) # 80002e6c <iunlock>
      return ip;
    800033ce:	bfe9                	j	800033a8 <namex+0x6a>
      iunlockput(ip);
    800033d0:	854e                	mv	a0,s3
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	c3a080e7          	jalr	-966(ra) # 8000300c <iunlockput>
      return 0;
    800033da:	89d2                	mv	s3,s4
    800033dc:	b7f1                	j	800033a8 <namex+0x6a>
  len = path - s;
    800033de:	40b48633          	sub	a2,s1,a1
    800033e2:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033e6:	094cd463          	bge	s9,s4,8000346e <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033ea:	4639                	li	a2,14
    800033ec:	8556                	mv	a0,s5
    800033ee:	ffffd097          	auipc	ra,0xffffd
    800033f2:	dea080e7          	jalr	-534(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033f6:	0004c783          	lbu	a5,0(s1)
    800033fa:	01279763          	bne	a5,s2,80003408 <namex+0xca>
    path++;
    800033fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003400:	0004c783          	lbu	a5,0(s1)
    80003404:	ff278de3          	beq	a5,s2,800033fe <namex+0xc0>
    ilock(ip);
    80003408:	854e                	mv	a0,s3
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	9a0080e7          	jalr	-1632(ra) # 80002daa <ilock>
    if(ip->type != T_DIR){
    80003412:	04499783          	lh	a5,68(s3)
    80003416:	f98793e3          	bne	a5,s8,8000339c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000341a:	000b0563          	beqz	s6,80003424 <namex+0xe6>
    8000341e:	0004c783          	lbu	a5,0(s1)
    80003422:	d3cd                	beqz	a5,800033c4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003424:	865e                	mv	a2,s7
    80003426:	85d6                	mv	a1,s5
    80003428:	854e                	mv	a0,s3
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	e64080e7          	jalr	-412(ra) # 8000328e <dirlookup>
    80003432:	8a2a                	mv	s4,a0
    80003434:	dd51                	beqz	a0,800033d0 <namex+0x92>
    iunlockput(ip);
    80003436:	854e                	mv	a0,s3
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	bd4080e7          	jalr	-1068(ra) # 8000300c <iunlockput>
    ip = next;
    80003440:	89d2                	mv	s3,s4
  while(*path == '/')
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	05279763          	bne	a5,s2,80003494 <namex+0x156>
    path++;
    8000344a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000344c:	0004c783          	lbu	a5,0(s1)
    80003450:	ff278de3          	beq	a5,s2,8000344a <namex+0x10c>
  if(*path == 0)
    80003454:	c79d                	beqz	a5,80003482 <namex+0x144>
    path++;
    80003456:	85a6                	mv	a1,s1
  len = path - s;
    80003458:	8a5e                	mv	s4,s7
    8000345a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000345c:	01278963          	beq	a5,s2,8000346e <namex+0x130>
    80003460:	dfbd                	beqz	a5,800033de <namex+0xa0>
    path++;
    80003462:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003464:	0004c783          	lbu	a5,0(s1)
    80003468:	ff279ce3          	bne	a5,s2,80003460 <namex+0x122>
    8000346c:	bf8d                	j	800033de <namex+0xa0>
    memmove(name, s, len);
    8000346e:	2601                	sext.w	a2,a2
    80003470:	8556                	mv	a0,s5
    80003472:	ffffd097          	auipc	ra,0xffffd
    80003476:	d66080e7          	jalr	-666(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000347a:	9a56                	add	s4,s4,s5
    8000347c:	000a0023          	sb	zero,0(s4)
    80003480:	bf9d                	j	800033f6 <namex+0xb8>
  if(nameiparent){
    80003482:	f20b03e3          	beqz	s6,800033a8 <namex+0x6a>
    iput(ip);
    80003486:	854e                	mv	a0,s3
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	adc080e7          	jalr	-1316(ra) # 80002f64 <iput>
    return 0;
    80003490:	4981                	li	s3,0
    80003492:	bf19                	j	800033a8 <namex+0x6a>
  if(*path == 0)
    80003494:	d7fd                	beqz	a5,80003482 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003496:	0004c783          	lbu	a5,0(s1)
    8000349a:	85a6                	mv	a1,s1
    8000349c:	b7d1                	j	80003460 <namex+0x122>

000000008000349e <dirlink>:
{
    8000349e:	7139                	addi	sp,sp,-64
    800034a0:	fc06                	sd	ra,56(sp)
    800034a2:	f822                	sd	s0,48(sp)
    800034a4:	f426                	sd	s1,40(sp)
    800034a6:	f04a                	sd	s2,32(sp)
    800034a8:	ec4e                	sd	s3,24(sp)
    800034aa:	e852                	sd	s4,16(sp)
    800034ac:	0080                	addi	s0,sp,64
    800034ae:	892a                	mv	s2,a0
    800034b0:	8a2e                	mv	s4,a1
    800034b2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034b4:	4601                	li	a2,0
    800034b6:	00000097          	auipc	ra,0x0
    800034ba:	dd8080e7          	jalr	-552(ra) # 8000328e <dirlookup>
    800034be:	e93d                	bnez	a0,80003534 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034c0:	04c92483          	lw	s1,76(s2)
    800034c4:	c49d                	beqz	s1,800034f2 <dirlink+0x54>
    800034c6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c8:	4741                	li	a4,16
    800034ca:	86a6                	mv	a3,s1
    800034cc:	fc040613          	addi	a2,s0,-64
    800034d0:	4581                	li	a1,0
    800034d2:	854a                	mv	a0,s2
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	b8a080e7          	jalr	-1142(ra) # 8000305e <readi>
    800034dc:	47c1                	li	a5,16
    800034de:	06f51163          	bne	a0,a5,80003540 <dirlink+0xa2>
    if(de.inum == 0)
    800034e2:	fc045783          	lhu	a5,-64(s0)
    800034e6:	c791                	beqz	a5,800034f2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e8:	24c1                	addiw	s1,s1,16
    800034ea:	04c92783          	lw	a5,76(s2)
    800034ee:	fcf4ede3          	bltu	s1,a5,800034c8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034f2:	4639                	li	a2,14
    800034f4:	85d2                	mv	a1,s4
    800034f6:	fc240513          	addi	a0,s0,-62
    800034fa:	ffffd097          	auipc	ra,0xffffd
    800034fe:	d92080e7          	jalr	-622(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003502:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003506:	4741                	li	a4,16
    80003508:	86a6                	mv	a3,s1
    8000350a:	fc040613          	addi	a2,s0,-64
    8000350e:	4581                	li	a1,0
    80003510:	854a                	mv	a0,s2
    80003512:	00000097          	auipc	ra,0x0
    80003516:	c44080e7          	jalr	-956(ra) # 80003156 <writei>
    8000351a:	872a                	mv	a4,a0
    8000351c:	47c1                	li	a5,16
  return 0;
    8000351e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003520:	02f71863          	bne	a4,a5,80003550 <dirlink+0xb2>
}
    80003524:	70e2                	ld	ra,56(sp)
    80003526:	7442                	ld	s0,48(sp)
    80003528:	74a2                	ld	s1,40(sp)
    8000352a:	7902                	ld	s2,32(sp)
    8000352c:	69e2                	ld	s3,24(sp)
    8000352e:	6a42                	ld	s4,16(sp)
    80003530:	6121                	addi	sp,sp,64
    80003532:	8082                	ret
    iput(ip);
    80003534:	00000097          	auipc	ra,0x0
    80003538:	a30080e7          	jalr	-1488(ra) # 80002f64 <iput>
    return -1;
    8000353c:	557d                	li	a0,-1
    8000353e:	b7dd                	j	80003524 <dirlink+0x86>
      panic("dirlink read");
    80003540:	00005517          	auipc	a0,0x5
    80003544:	04850513          	addi	a0,a0,72 # 80008588 <syscalls+0x1d8>
    80003548:	00003097          	auipc	ra,0x3
    8000354c:	d50080e7          	jalr	-688(ra) # 80006298 <panic>
    panic("dirlink");
    80003550:	00005517          	auipc	a0,0x5
    80003554:	14850513          	addi	a0,a0,328 # 80008698 <syscalls+0x2e8>
    80003558:	00003097          	auipc	ra,0x3
    8000355c:	d40080e7          	jalr	-704(ra) # 80006298 <panic>

0000000080003560 <namei>:

struct inode*
namei(char *path)
{
    80003560:	1101                	addi	sp,sp,-32
    80003562:	ec06                	sd	ra,24(sp)
    80003564:	e822                	sd	s0,16(sp)
    80003566:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003568:	fe040613          	addi	a2,s0,-32
    8000356c:	4581                	li	a1,0
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	dd0080e7          	jalr	-560(ra) # 8000333e <namex>
}
    80003576:	60e2                	ld	ra,24(sp)
    80003578:	6442                	ld	s0,16(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000357e:	1141                	addi	sp,sp,-16
    80003580:	e406                	sd	ra,8(sp)
    80003582:	e022                	sd	s0,0(sp)
    80003584:	0800                	addi	s0,sp,16
    80003586:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003588:	4585                	li	a1,1
    8000358a:	00000097          	auipc	ra,0x0
    8000358e:	db4080e7          	jalr	-588(ra) # 8000333e <namex>
}
    80003592:	60a2                	ld	ra,8(sp)
    80003594:	6402                	ld	s0,0(sp)
    80003596:	0141                	addi	sp,sp,16
    80003598:	8082                	ret

000000008000359a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000359a:	1101                	addi	sp,sp,-32
    8000359c:	ec06                	sd	ra,24(sp)
    8000359e:	e822                	sd	s0,16(sp)
    800035a0:	e426                	sd	s1,8(sp)
    800035a2:	e04a                	sd	s2,0(sp)
    800035a4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035a6:	0001e917          	auipc	s2,0x1e
    800035aa:	a7a90913          	addi	s2,s2,-1414 # 80021020 <log>
    800035ae:	01892583          	lw	a1,24(s2)
    800035b2:	02892503          	lw	a0,40(s2)
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	ff2080e7          	jalr	-14(ra) # 800025a8 <bread>
    800035be:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035c0:	02c92683          	lw	a3,44(s2)
    800035c4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035c6:	02d05763          	blez	a3,800035f4 <write_head+0x5a>
    800035ca:	0001e797          	auipc	a5,0x1e
    800035ce:	a8678793          	addi	a5,a5,-1402 # 80021050 <log+0x30>
    800035d2:	05c50713          	addi	a4,a0,92
    800035d6:	36fd                	addiw	a3,a3,-1
    800035d8:	1682                	slli	a3,a3,0x20
    800035da:	9281                	srli	a3,a3,0x20
    800035dc:	068a                	slli	a3,a3,0x2
    800035de:	0001e617          	auipc	a2,0x1e
    800035e2:	a7660613          	addi	a2,a2,-1418 # 80021054 <log+0x34>
    800035e6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035e8:	4390                	lw	a2,0(a5)
    800035ea:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035ec:	0791                	addi	a5,a5,4
    800035ee:	0711                	addi	a4,a4,4
    800035f0:	fed79ce3          	bne	a5,a3,800035e8 <write_head+0x4e>
  }
  bwrite(buf);
    800035f4:	8526                	mv	a0,s1
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	0a4080e7          	jalr	164(ra) # 8000269a <bwrite>
  brelse(buf);
    800035fe:	8526                	mv	a0,s1
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	0d8080e7          	jalr	216(ra) # 800026d8 <brelse>
}
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6902                	ld	s2,0(sp)
    80003610:	6105                	addi	sp,sp,32
    80003612:	8082                	ret

0000000080003614 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003614:	0001e797          	auipc	a5,0x1e
    80003618:	a387a783          	lw	a5,-1480(a5) # 8002104c <log+0x2c>
    8000361c:	0af05d63          	blez	a5,800036d6 <install_trans+0xc2>
{
    80003620:	7139                	addi	sp,sp,-64
    80003622:	fc06                	sd	ra,56(sp)
    80003624:	f822                	sd	s0,48(sp)
    80003626:	f426                	sd	s1,40(sp)
    80003628:	f04a                	sd	s2,32(sp)
    8000362a:	ec4e                	sd	s3,24(sp)
    8000362c:	e852                	sd	s4,16(sp)
    8000362e:	e456                	sd	s5,8(sp)
    80003630:	e05a                	sd	s6,0(sp)
    80003632:	0080                	addi	s0,sp,64
    80003634:	8b2a                	mv	s6,a0
    80003636:	0001ea97          	auipc	s5,0x1e
    8000363a:	a1aa8a93          	addi	s5,s5,-1510 # 80021050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003640:	0001e997          	auipc	s3,0x1e
    80003644:	9e098993          	addi	s3,s3,-1568 # 80021020 <log>
    80003648:	a035                	j	80003674 <install_trans+0x60>
      bunpin(dbuf);
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	166080e7          	jalr	358(ra) # 800027b2 <bunpin>
    brelse(lbuf);
    80003654:	854a                	mv	a0,s2
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	082080e7          	jalr	130(ra) # 800026d8 <brelse>
    brelse(dbuf);
    8000365e:	8526                	mv	a0,s1
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	078080e7          	jalr	120(ra) # 800026d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003668:	2a05                	addiw	s4,s4,1
    8000366a:	0a91                	addi	s5,s5,4
    8000366c:	02c9a783          	lw	a5,44(s3)
    80003670:	04fa5963          	bge	s4,a5,800036c2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003674:	0189a583          	lw	a1,24(s3)
    80003678:	014585bb          	addw	a1,a1,s4
    8000367c:	2585                	addiw	a1,a1,1
    8000367e:	0289a503          	lw	a0,40(s3)
    80003682:	fffff097          	auipc	ra,0xfffff
    80003686:	f26080e7          	jalr	-218(ra) # 800025a8 <bread>
    8000368a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000368c:	000aa583          	lw	a1,0(s5)
    80003690:	0289a503          	lw	a0,40(s3)
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	f14080e7          	jalr	-236(ra) # 800025a8 <bread>
    8000369c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000369e:	40000613          	li	a2,1024
    800036a2:	05890593          	addi	a1,s2,88
    800036a6:	05850513          	addi	a0,a0,88
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	b2e080e7          	jalr	-1234(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036b2:	8526                	mv	a0,s1
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	fe6080e7          	jalr	-26(ra) # 8000269a <bwrite>
    if(recovering == 0)
    800036bc:	f80b1ce3          	bnez	s6,80003654 <install_trans+0x40>
    800036c0:	b769                	j	8000364a <install_trans+0x36>
}
    800036c2:	70e2                	ld	ra,56(sp)
    800036c4:	7442                	ld	s0,48(sp)
    800036c6:	74a2                	ld	s1,40(sp)
    800036c8:	7902                	ld	s2,32(sp)
    800036ca:	69e2                	ld	s3,24(sp)
    800036cc:	6a42                	ld	s4,16(sp)
    800036ce:	6aa2                	ld	s5,8(sp)
    800036d0:	6b02                	ld	s6,0(sp)
    800036d2:	6121                	addi	sp,sp,64
    800036d4:	8082                	ret
    800036d6:	8082                	ret

00000000800036d8 <initlog>:
{
    800036d8:	7179                	addi	sp,sp,-48
    800036da:	f406                	sd	ra,40(sp)
    800036dc:	f022                	sd	s0,32(sp)
    800036de:	ec26                	sd	s1,24(sp)
    800036e0:	e84a                	sd	s2,16(sp)
    800036e2:	e44e                	sd	s3,8(sp)
    800036e4:	1800                	addi	s0,sp,48
    800036e6:	892a                	mv	s2,a0
    800036e8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036ea:	0001e497          	auipc	s1,0x1e
    800036ee:	93648493          	addi	s1,s1,-1738 # 80021020 <log>
    800036f2:	00005597          	auipc	a1,0x5
    800036f6:	ea658593          	addi	a1,a1,-346 # 80008598 <syscalls+0x1e8>
    800036fa:	8526                	mv	a0,s1
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	056080e7          	jalr	86(ra) # 80006752 <initlock>
  log.start = sb->logstart;
    80003704:	0149a583          	lw	a1,20(s3)
    80003708:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000370a:	0109a783          	lw	a5,16(s3)
    8000370e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003710:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003714:	854a                	mv	a0,s2
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	e92080e7          	jalr	-366(ra) # 800025a8 <bread>
  log.lh.n = lh->n;
    8000371e:	4d3c                	lw	a5,88(a0)
    80003720:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003722:	02f05563          	blez	a5,8000374c <initlog+0x74>
    80003726:	05c50713          	addi	a4,a0,92
    8000372a:	0001e697          	auipc	a3,0x1e
    8000372e:	92668693          	addi	a3,a3,-1754 # 80021050 <log+0x30>
    80003732:	37fd                	addiw	a5,a5,-1
    80003734:	1782                	slli	a5,a5,0x20
    80003736:	9381                	srli	a5,a5,0x20
    80003738:	078a                	slli	a5,a5,0x2
    8000373a:	06050613          	addi	a2,a0,96
    8000373e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003740:	4310                	lw	a2,0(a4)
    80003742:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003744:	0711                	addi	a4,a4,4
    80003746:	0691                	addi	a3,a3,4
    80003748:	fef71ce3          	bne	a4,a5,80003740 <initlog+0x68>
  brelse(buf);
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	f8c080e7          	jalr	-116(ra) # 800026d8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003754:	4505                	li	a0,1
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	ebe080e7          	jalr	-322(ra) # 80003614 <install_trans>
  log.lh.n = 0;
    8000375e:	0001e797          	auipc	a5,0x1e
    80003762:	8e07a723          	sw	zero,-1810(a5) # 8002104c <log+0x2c>
  write_head(); // clear the log
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	e34080e7          	jalr	-460(ra) # 8000359a <write_head>
}
    8000376e:	70a2                	ld	ra,40(sp)
    80003770:	7402                	ld	s0,32(sp)
    80003772:	64e2                	ld	s1,24(sp)
    80003774:	6942                	ld	s2,16(sp)
    80003776:	69a2                	ld	s3,8(sp)
    80003778:	6145                	addi	sp,sp,48
    8000377a:	8082                	ret

000000008000377c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000377c:	1101                	addi	sp,sp,-32
    8000377e:	ec06                	sd	ra,24(sp)
    80003780:	e822                	sd	s0,16(sp)
    80003782:	e426                	sd	s1,8(sp)
    80003784:	e04a                	sd	s2,0(sp)
    80003786:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003788:	0001e517          	auipc	a0,0x1e
    8000378c:	89850513          	addi	a0,a0,-1896 # 80021020 <log>
    80003790:	00003097          	auipc	ra,0x3
    80003794:	052080e7          	jalr	82(ra) # 800067e2 <acquire>
  while(1){
    if(log.committing){
    80003798:	0001e497          	auipc	s1,0x1e
    8000379c:	88848493          	addi	s1,s1,-1912 # 80021020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a0:	4979                	li	s2,30
    800037a2:	a039                	j	800037b0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037a4:	85a6                	mv	a1,s1
    800037a6:	8526                	mv	a0,s1
    800037a8:	ffffe097          	auipc	ra,0xffffe
    800037ac:	d82080e7          	jalr	-638(ra) # 8000152a <sleep>
    if(log.committing){
    800037b0:	50dc                	lw	a5,36(s1)
    800037b2:	fbed                	bnez	a5,800037a4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037b4:	509c                	lw	a5,32(s1)
    800037b6:	0017871b          	addiw	a4,a5,1
    800037ba:	0007069b          	sext.w	a3,a4
    800037be:	0027179b          	slliw	a5,a4,0x2
    800037c2:	9fb9                	addw	a5,a5,a4
    800037c4:	0017979b          	slliw	a5,a5,0x1
    800037c8:	54d8                	lw	a4,44(s1)
    800037ca:	9fb9                	addw	a5,a5,a4
    800037cc:	00f95963          	bge	s2,a5,800037de <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037d0:	85a6                	mv	a1,s1
    800037d2:	8526                	mv	a0,s1
    800037d4:	ffffe097          	auipc	ra,0xffffe
    800037d8:	d56080e7          	jalr	-682(ra) # 8000152a <sleep>
    800037dc:	bfd1                	j	800037b0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037de:	0001e517          	auipc	a0,0x1e
    800037e2:	84250513          	addi	a0,a0,-1982 # 80021020 <log>
    800037e6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	0ae080e7          	jalr	174(ra) # 80006896 <release>
      break;
    }
  }
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037fc:	7139                	addi	sp,sp,-64
    800037fe:	fc06                	sd	ra,56(sp)
    80003800:	f822                	sd	s0,48(sp)
    80003802:	f426                	sd	s1,40(sp)
    80003804:	f04a                	sd	s2,32(sp)
    80003806:	ec4e                	sd	s3,24(sp)
    80003808:	e852                	sd	s4,16(sp)
    8000380a:	e456                	sd	s5,8(sp)
    8000380c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000380e:	0001e497          	auipc	s1,0x1e
    80003812:	81248493          	addi	s1,s1,-2030 # 80021020 <log>
    80003816:	8526                	mv	a0,s1
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	fca080e7          	jalr	-54(ra) # 800067e2 <acquire>
  log.outstanding -= 1;
    80003820:	509c                	lw	a5,32(s1)
    80003822:	37fd                	addiw	a5,a5,-1
    80003824:	0007891b          	sext.w	s2,a5
    80003828:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000382a:	50dc                	lw	a5,36(s1)
    8000382c:	efb9                	bnez	a5,8000388a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000382e:	06091663          	bnez	s2,8000389a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003832:	0001d497          	auipc	s1,0x1d
    80003836:	7ee48493          	addi	s1,s1,2030 # 80021020 <log>
    8000383a:	4785                	li	a5,1
    8000383c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000383e:	8526                	mv	a0,s1
    80003840:	00003097          	auipc	ra,0x3
    80003844:	056080e7          	jalr	86(ra) # 80006896 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003848:	54dc                	lw	a5,44(s1)
    8000384a:	06f04763          	bgtz	a5,800038b8 <end_op+0xbc>
    acquire(&log.lock);
    8000384e:	0001d497          	auipc	s1,0x1d
    80003852:	7d248493          	addi	s1,s1,2002 # 80021020 <log>
    80003856:	8526                	mv	a0,s1
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	f8a080e7          	jalr	-118(ra) # 800067e2 <acquire>
    log.committing = 0;
    80003860:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003864:	8526                	mv	a0,s1
    80003866:	ffffe097          	auipc	ra,0xffffe
    8000386a:	e50080e7          	jalr	-432(ra) # 800016b6 <wakeup>
    release(&log.lock);
    8000386e:	8526                	mv	a0,s1
    80003870:	00003097          	auipc	ra,0x3
    80003874:	026080e7          	jalr	38(ra) # 80006896 <release>
}
    80003878:	70e2                	ld	ra,56(sp)
    8000387a:	7442                	ld	s0,48(sp)
    8000387c:	74a2                	ld	s1,40(sp)
    8000387e:	7902                	ld	s2,32(sp)
    80003880:	69e2                	ld	s3,24(sp)
    80003882:	6a42                	ld	s4,16(sp)
    80003884:	6aa2                	ld	s5,8(sp)
    80003886:	6121                	addi	sp,sp,64
    80003888:	8082                	ret
    panic("log.committing");
    8000388a:	00005517          	auipc	a0,0x5
    8000388e:	d1650513          	addi	a0,a0,-746 # 800085a0 <syscalls+0x1f0>
    80003892:	00003097          	auipc	ra,0x3
    80003896:	a06080e7          	jalr	-1530(ra) # 80006298 <panic>
    wakeup(&log);
    8000389a:	0001d497          	auipc	s1,0x1d
    8000389e:	78648493          	addi	s1,s1,1926 # 80021020 <log>
    800038a2:	8526                	mv	a0,s1
    800038a4:	ffffe097          	auipc	ra,0xffffe
    800038a8:	e12080e7          	jalr	-494(ra) # 800016b6 <wakeup>
  release(&log.lock);
    800038ac:	8526                	mv	a0,s1
    800038ae:	00003097          	auipc	ra,0x3
    800038b2:	fe8080e7          	jalr	-24(ra) # 80006896 <release>
  if(do_commit){
    800038b6:	b7c9                	j	80003878 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038b8:	0001da97          	auipc	s5,0x1d
    800038bc:	798a8a93          	addi	s5,s5,1944 # 80021050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038c0:	0001da17          	auipc	s4,0x1d
    800038c4:	760a0a13          	addi	s4,s4,1888 # 80021020 <log>
    800038c8:	018a2583          	lw	a1,24(s4)
    800038cc:	012585bb          	addw	a1,a1,s2
    800038d0:	2585                	addiw	a1,a1,1
    800038d2:	028a2503          	lw	a0,40(s4)
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	cd2080e7          	jalr	-814(ra) # 800025a8 <bread>
    800038de:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038e0:	000aa583          	lw	a1,0(s5)
    800038e4:	028a2503          	lw	a0,40(s4)
    800038e8:	fffff097          	auipc	ra,0xfffff
    800038ec:	cc0080e7          	jalr	-832(ra) # 800025a8 <bread>
    800038f0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038f2:	40000613          	li	a2,1024
    800038f6:	05850593          	addi	a1,a0,88
    800038fa:	05848513          	addi	a0,s1,88
    800038fe:	ffffd097          	auipc	ra,0xffffd
    80003902:	8da080e7          	jalr	-1830(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003906:	8526                	mv	a0,s1
    80003908:	fffff097          	auipc	ra,0xfffff
    8000390c:	d92080e7          	jalr	-622(ra) # 8000269a <bwrite>
    brelse(from);
    80003910:	854e                	mv	a0,s3
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	dc6080e7          	jalr	-570(ra) # 800026d8 <brelse>
    brelse(to);
    8000391a:	8526                	mv	a0,s1
    8000391c:	fffff097          	auipc	ra,0xfffff
    80003920:	dbc080e7          	jalr	-580(ra) # 800026d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003924:	2905                	addiw	s2,s2,1
    80003926:	0a91                	addi	s5,s5,4
    80003928:	02ca2783          	lw	a5,44(s4)
    8000392c:	f8f94ee3          	blt	s2,a5,800038c8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003930:	00000097          	auipc	ra,0x0
    80003934:	c6a080e7          	jalr	-918(ra) # 8000359a <write_head>
    install_trans(0); // Now install writes to home locations
    80003938:	4501                	li	a0,0
    8000393a:	00000097          	auipc	ra,0x0
    8000393e:	cda080e7          	jalr	-806(ra) # 80003614 <install_trans>
    log.lh.n = 0;
    80003942:	0001d797          	auipc	a5,0x1d
    80003946:	7007a523          	sw	zero,1802(a5) # 8002104c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000394a:	00000097          	auipc	ra,0x0
    8000394e:	c50080e7          	jalr	-944(ra) # 8000359a <write_head>
    80003952:	bdf5                	j	8000384e <end_op+0x52>

0000000080003954 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003954:	1101                	addi	sp,sp,-32
    80003956:	ec06                	sd	ra,24(sp)
    80003958:	e822                	sd	s0,16(sp)
    8000395a:	e426                	sd	s1,8(sp)
    8000395c:	e04a                	sd	s2,0(sp)
    8000395e:	1000                	addi	s0,sp,32
    80003960:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003962:	0001d917          	auipc	s2,0x1d
    80003966:	6be90913          	addi	s2,s2,1726 # 80021020 <log>
    8000396a:	854a                	mv	a0,s2
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	e76080e7          	jalr	-394(ra) # 800067e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003974:	02c92603          	lw	a2,44(s2)
    80003978:	47f5                	li	a5,29
    8000397a:	06c7c563          	blt	a5,a2,800039e4 <log_write+0x90>
    8000397e:	0001d797          	auipc	a5,0x1d
    80003982:	6be7a783          	lw	a5,1726(a5) # 8002103c <log+0x1c>
    80003986:	37fd                	addiw	a5,a5,-1
    80003988:	04f65e63          	bge	a2,a5,800039e4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000398c:	0001d797          	auipc	a5,0x1d
    80003990:	6b47a783          	lw	a5,1716(a5) # 80021040 <log+0x20>
    80003994:	06f05063          	blez	a5,800039f4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003998:	4781                	li	a5,0
    8000399a:	06c05563          	blez	a2,80003a04 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000399e:	44cc                	lw	a1,12(s1)
    800039a0:	0001d717          	auipc	a4,0x1d
    800039a4:	6b070713          	addi	a4,a4,1712 # 80021050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039a8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039aa:	4314                	lw	a3,0(a4)
    800039ac:	04b68c63          	beq	a3,a1,80003a04 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039b0:	2785                	addiw	a5,a5,1
    800039b2:	0711                	addi	a4,a4,4
    800039b4:	fef61be3          	bne	a2,a5,800039aa <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039b8:	0621                	addi	a2,a2,8
    800039ba:	060a                	slli	a2,a2,0x2
    800039bc:	0001d797          	auipc	a5,0x1d
    800039c0:	66478793          	addi	a5,a5,1636 # 80021020 <log>
    800039c4:	963e                	add	a2,a2,a5
    800039c6:	44dc                	lw	a5,12(s1)
    800039c8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039ca:	8526                	mv	a0,s1
    800039cc:	fffff097          	auipc	ra,0xfffff
    800039d0:	daa080e7          	jalr	-598(ra) # 80002776 <bpin>
    log.lh.n++;
    800039d4:	0001d717          	auipc	a4,0x1d
    800039d8:	64c70713          	addi	a4,a4,1612 # 80021020 <log>
    800039dc:	575c                	lw	a5,44(a4)
    800039de:	2785                	addiw	a5,a5,1
    800039e0:	d75c                	sw	a5,44(a4)
    800039e2:	a835                	j	80003a1e <log_write+0xca>
    panic("too big a transaction");
    800039e4:	00005517          	auipc	a0,0x5
    800039e8:	bcc50513          	addi	a0,a0,-1076 # 800085b0 <syscalls+0x200>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	8ac080e7          	jalr	-1876(ra) # 80006298 <panic>
    panic("log_write outside of trans");
    800039f4:	00005517          	auipc	a0,0x5
    800039f8:	bd450513          	addi	a0,a0,-1068 # 800085c8 <syscalls+0x218>
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	89c080e7          	jalr	-1892(ra) # 80006298 <panic>
  log.lh.block[i] = b->blockno;
    80003a04:	00878713          	addi	a4,a5,8
    80003a08:	00271693          	slli	a3,a4,0x2
    80003a0c:	0001d717          	auipc	a4,0x1d
    80003a10:	61470713          	addi	a4,a4,1556 # 80021020 <log>
    80003a14:	9736                	add	a4,a4,a3
    80003a16:	44d4                	lw	a3,12(s1)
    80003a18:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a1a:	faf608e3          	beq	a2,a5,800039ca <log_write+0x76>
  }
  release(&log.lock);
    80003a1e:	0001d517          	auipc	a0,0x1d
    80003a22:	60250513          	addi	a0,a0,1538 # 80021020 <log>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	e70080e7          	jalr	-400(ra) # 80006896 <release>
}
    80003a2e:	60e2                	ld	ra,24(sp)
    80003a30:	6442                	ld	s0,16(sp)
    80003a32:	64a2                	ld	s1,8(sp)
    80003a34:	6902                	ld	s2,0(sp)
    80003a36:	6105                	addi	sp,sp,32
    80003a38:	8082                	ret

0000000080003a3a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a3a:	1101                	addi	sp,sp,-32
    80003a3c:	ec06                	sd	ra,24(sp)
    80003a3e:	e822                	sd	s0,16(sp)
    80003a40:	e426                	sd	s1,8(sp)
    80003a42:	e04a                	sd	s2,0(sp)
    80003a44:	1000                	addi	s0,sp,32
    80003a46:	84aa                	mv	s1,a0
    80003a48:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a4a:	00005597          	auipc	a1,0x5
    80003a4e:	b9e58593          	addi	a1,a1,-1122 # 800085e8 <syscalls+0x238>
    80003a52:	0521                	addi	a0,a0,8
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	cfe080e7          	jalr	-770(ra) # 80006752 <initlock>
  lk->name = name;
    80003a5c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a60:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a64:	0204a423          	sw	zero,40(s1)
}
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6902                	ld	s2,0(sp)
    80003a70:	6105                	addi	sp,sp,32
    80003a72:	8082                	ret

0000000080003a74 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a74:	1101                	addi	sp,sp,-32
    80003a76:	ec06                	sd	ra,24(sp)
    80003a78:	e822                	sd	s0,16(sp)
    80003a7a:	e426                	sd	s1,8(sp)
    80003a7c:	e04a                	sd	s2,0(sp)
    80003a7e:	1000                	addi	s0,sp,32
    80003a80:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a82:	00850913          	addi	s2,a0,8
    80003a86:	854a                	mv	a0,s2
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	d5a080e7          	jalr	-678(ra) # 800067e2 <acquire>
  while (lk->locked) {
    80003a90:	409c                	lw	a5,0(s1)
    80003a92:	cb89                	beqz	a5,80003aa4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a94:	85ca                	mv	a1,s2
    80003a96:	8526                	mv	a0,s1
    80003a98:	ffffe097          	auipc	ra,0xffffe
    80003a9c:	a92080e7          	jalr	-1390(ra) # 8000152a <sleep>
  while (lk->locked) {
    80003aa0:	409c                	lw	a5,0(s1)
    80003aa2:	fbed                	bnez	a5,80003a94 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003aa4:	4785                	li	a5,1
    80003aa6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	382080e7          	jalr	898(ra) # 80000e2a <myproc>
    80003ab0:	591c                	lw	a5,48(a0)
    80003ab2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ab4:	854a                	mv	a0,s2
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	de0080e7          	jalr	-544(ra) # 80006896 <release>
}
    80003abe:	60e2                	ld	ra,24(sp)
    80003ac0:	6442                	ld	s0,16(sp)
    80003ac2:	64a2                	ld	s1,8(sp)
    80003ac4:	6902                	ld	s2,0(sp)
    80003ac6:	6105                	addi	sp,sp,32
    80003ac8:	8082                	ret

0000000080003aca <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003aca:	1101                	addi	sp,sp,-32
    80003acc:	ec06                	sd	ra,24(sp)
    80003ace:	e822                	sd	s0,16(sp)
    80003ad0:	e426                	sd	s1,8(sp)
    80003ad2:	e04a                	sd	s2,0(sp)
    80003ad4:	1000                	addi	s0,sp,32
    80003ad6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ad8:	00850913          	addi	s2,a0,8
    80003adc:	854a                	mv	a0,s2
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	d04080e7          	jalr	-764(ra) # 800067e2 <acquire>
  lk->locked = 0;
    80003ae6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aea:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aee:	8526                	mv	a0,s1
    80003af0:	ffffe097          	auipc	ra,0xffffe
    80003af4:	bc6080e7          	jalr	-1082(ra) # 800016b6 <wakeup>
  release(&lk->lk);
    80003af8:	854a                	mv	a0,s2
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	d9c080e7          	jalr	-612(ra) # 80006896 <release>
}
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6902                	ld	s2,0(sp)
    80003b0a:	6105                	addi	sp,sp,32
    80003b0c:	8082                	ret

0000000080003b0e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b0e:	7179                	addi	sp,sp,-48
    80003b10:	f406                	sd	ra,40(sp)
    80003b12:	f022                	sd	s0,32(sp)
    80003b14:	ec26                	sd	s1,24(sp)
    80003b16:	e84a                	sd	s2,16(sp)
    80003b18:	e44e                	sd	s3,8(sp)
    80003b1a:	1800                	addi	s0,sp,48
    80003b1c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b1e:	00850913          	addi	s2,a0,8
    80003b22:	854a                	mv	a0,s2
    80003b24:	00003097          	auipc	ra,0x3
    80003b28:	cbe080e7          	jalr	-834(ra) # 800067e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b2c:	409c                	lw	a5,0(s1)
    80003b2e:	ef99                	bnez	a5,80003b4c <holdingsleep+0x3e>
    80003b30:	4481                	li	s1,0
  release(&lk->lk);
    80003b32:	854a                	mv	a0,s2
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	d62080e7          	jalr	-670(ra) # 80006896 <release>
  return r;
}
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	70a2                	ld	ra,40(sp)
    80003b40:	7402                	ld	s0,32(sp)
    80003b42:	64e2                	ld	s1,24(sp)
    80003b44:	6942                	ld	s2,16(sp)
    80003b46:	69a2                	ld	s3,8(sp)
    80003b48:	6145                	addi	sp,sp,48
    80003b4a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b4c:	0284a983          	lw	s3,40(s1)
    80003b50:	ffffd097          	auipc	ra,0xffffd
    80003b54:	2da080e7          	jalr	730(ra) # 80000e2a <myproc>
    80003b58:	5904                	lw	s1,48(a0)
    80003b5a:	413484b3          	sub	s1,s1,s3
    80003b5e:	0014b493          	seqz	s1,s1
    80003b62:	bfc1                	j	80003b32 <holdingsleep+0x24>

0000000080003b64 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b64:	1141                	addi	sp,sp,-16
    80003b66:	e406                	sd	ra,8(sp)
    80003b68:	e022                	sd	s0,0(sp)
    80003b6a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b6c:	00005597          	auipc	a1,0x5
    80003b70:	a8c58593          	addi	a1,a1,-1396 # 800085f8 <syscalls+0x248>
    80003b74:	0001d517          	auipc	a0,0x1d
    80003b78:	5f450513          	addi	a0,a0,1524 # 80021168 <ftable>
    80003b7c:	00003097          	auipc	ra,0x3
    80003b80:	bd6080e7          	jalr	-1066(ra) # 80006752 <initlock>
}
    80003b84:	60a2                	ld	ra,8(sp)
    80003b86:	6402                	ld	s0,0(sp)
    80003b88:	0141                	addi	sp,sp,16
    80003b8a:	8082                	ret

0000000080003b8c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b8c:	1101                	addi	sp,sp,-32
    80003b8e:	ec06                	sd	ra,24(sp)
    80003b90:	e822                	sd	s0,16(sp)
    80003b92:	e426                	sd	s1,8(sp)
    80003b94:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b96:	0001d517          	auipc	a0,0x1d
    80003b9a:	5d250513          	addi	a0,a0,1490 # 80021168 <ftable>
    80003b9e:	00003097          	auipc	ra,0x3
    80003ba2:	c44080e7          	jalr	-956(ra) # 800067e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ba6:	0001d497          	auipc	s1,0x1d
    80003baa:	5da48493          	addi	s1,s1,1498 # 80021180 <ftable+0x18>
    80003bae:	0001e717          	auipc	a4,0x1e
    80003bb2:	57270713          	addi	a4,a4,1394 # 80022120 <ftable+0xfb8>
    if(f->ref == 0){
    80003bb6:	40dc                	lw	a5,4(s1)
    80003bb8:	cf99                	beqz	a5,80003bd6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bba:	02848493          	addi	s1,s1,40
    80003bbe:	fee49ce3          	bne	s1,a4,80003bb6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bc2:	0001d517          	auipc	a0,0x1d
    80003bc6:	5a650513          	addi	a0,a0,1446 # 80021168 <ftable>
    80003bca:	00003097          	auipc	ra,0x3
    80003bce:	ccc080e7          	jalr	-820(ra) # 80006896 <release>
  return 0;
    80003bd2:	4481                	li	s1,0
    80003bd4:	a819                	j	80003bea <filealloc+0x5e>
      f->ref = 1;
    80003bd6:	4785                	li	a5,1
    80003bd8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bda:	0001d517          	auipc	a0,0x1d
    80003bde:	58e50513          	addi	a0,a0,1422 # 80021168 <ftable>
    80003be2:	00003097          	auipc	ra,0x3
    80003be6:	cb4080e7          	jalr	-844(ra) # 80006896 <release>
}
    80003bea:	8526                	mv	a0,s1
    80003bec:	60e2                	ld	ra,24(sp)
    80003bee:	6442                	ld	s0,16(sp)
    80003bf0:	64a2                	ld	s1,8(sp)
    80003bf2:	6105                	addi	sp,sp,32
    80003bf4:	8082                	ret

0000000080003bf6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bf6:	1101                	addi	sp,sp,-32
    80003bf8:	ec06                	sd	ra,24(sp)
    80003bfa:	e822                	sd	s0,16(sp)
    80003bfc:	e426                	sd	s1,8(sp)
    80003bfe:	1000                	addi	s0,sp,32
    80003c00:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c02:	0001d517          	auipc	a0,0x1d
    80003c06:	56650513          	addi	a0,a0,1382 # 80021168 <ftable>
    80003c0a:	00003097          	auipc	ra,0x3
    80003c0e:	bd8080e7          	jalr	-1064(ra) # 800067e2 <acquire>
  if(f->ref < 1)
    80003c12:	40dc                	lw	a5,4(s1)
    80003c14:	02f05263          	blez	a5,80003c38 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c18:	2785                	addiw	a5,a5,1
    80003c1a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c1c:	0001d517          	auipc	a0,0x1d
    80003c20:	54c50513          	addi	a0,a0,1356 # 80021168 <ftable>
    80003c24:	00003097          	auipc	ra,0x3
    80003c28:	c72080e7          	jalr	-910(ra) # 80006896 <release>
  return f;
}
    80003c2c:	8526                	mv	a0,s1
    80003c2e:	60e2                	ld	ra,24(sp)
    80003c30:	6442                	ld	s0,16(sp)
    80003c32:	64a2                	ld	s1,8(sp)
    80003c34:	6105                	addi	sp,sp,32
    80003c36:	8082                	ret
    panic("filedup");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	9c850513          	addi	a0,a0,-1592 # 80008600 <syscalls+0x250>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	658080e7          	jalr	1624(ra) # 80006298 <panic>

0000000080003c48 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c48:	7139                	addi	sp,sp,-64
    80003c4a:	fc06                	sd	ra,56(sp)
    80003c4c:	f822                	sd	s0,48(sp)
    80003c4e:	f426                	sd	s1,40(sp)
    80003c50:	f04a                	sd	s2,32(sp)
    80003c52:	ec4e                	sd	s3,24(sp)
    80003c54:	e852                	sd	s4,16(sp)
    80003c56:	e456                	sd	s5,8(sp)
    80003c58:	0080                	addi	s0,sp,64
    80003c5a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c5c:	0001d517          	auipc	a0,0x1d
    80003c60:	50c50513          	addi	a0,a0,1292 # 80021168 <ftable>
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	b7e080e7          	jalr	-1154(ra) # 800067e2 <acquire>
  if(f->ref < 1)
    80003c6c:	40dc                	lw	a5,4(s1)
    80003c6e:	06f05163          	blez	a5,80003cd0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c72:	37fd                	addiw	a5,a5,-1
    80003c74:	0007871b          	sext.w	a4,a5
    80003c78:	c0dc                	sw	a5,4(s1)
    80003c7a:	06e04363          	bgtz	a4,80003ce0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c7e:	0004a903          	lw	s2,0(s1)
    80003c82:	0094ca83          	lbu	s5,9(s1)
    80003c86:	0104ba03          	ld	s4,16(s1)
    80003c8a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c8e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c92:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c96:	0001d517          	auipc	a0,0x1d
    80003c9a:	4d250513          	addi	a0,a0,1234 # 80021168 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	bf8080e7          	jalr	-1032(ra) # 80006896 <release>

  if(ff.type == FD_PIPE){
    80003ca6:	4785                	li	a5,1
    80003ca8:	04f90d63          	beq	s2,a5,80003d02 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cac:	3979                	addiw	s2,s2,-2
    80003cae:	4785                	li	a5,1
    80003cb0:	0527e063          	bltu	a5,s2,80003cf0 <fileclose+0xa8>
    begin_op();
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	ac8080e7          	jalr	-1336(ra) # 8000377c <begin_op>
    iput(ff.ip);
    80003cbc:	854e                	mv	a0,s3
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	2a6080e7          	jalr	678(ra) # 80002f64 <iput>
    end_op();
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	b36080e7          	jalr	-1226(ra) # 800037fc <end_op>
    80003cce:	a00d                	j	80003cf0 <fileclose+0xa8>
    panic("fileclose");
    80003cd0:	00005517          	auipc	a0,0x5
    80003cd4:	93850513          	addi	a0,a0,-1736 # 80008608 <syscalls+0x258>
    80003cd8:	00002097          	auipc	ra,0x2
    80003cdc:	5c0080e7          	jalr	1472(ra) # 80006298 <panic>
    release(&ftable.lock);
    80003ce0:	0001d517          	auipc	a0,0x1d
    80003ce4:	48850513          	addi	a0,a0,1160 # 80021168 <ftable>
    80003ce8:	00003097          	auipc	ra,0x3
    80003cec:	bae080e7          	jalr	-1106(ra) # 80006896 <release>
  }
}
    80003cf0:	70e2                	ld	ra,56(sp)
    80003cf2:	7442                	ld	s0,48(sp)
    80003cf4:	74a2                	ld	s1,40(sp)
    80003cf6:	7902                	ld	s2,32(sp)
    80003cf8:	69e2                	ld	s3,24(sp)
    80003cfa:	6a42                	ld	s4,16(sp)
    80003cfc:	6aa2                	ld	s5,8(sp)
    80003cfe:	6121                	addi	sp,sp,64
    80003d00:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d02:	85d6                	mv	a1,s5
    80003d04:	8552                	mv	a0,s4
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	34c080e7          	jalr	844(ra) # 80004052 <pipeclose>
    80003d0e:	b7cd                	j	80003cf0 <fileclose+0xa8>

0000000080003d10 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d10:	715d                	addi	sp,sp,-80
    80003d12:	e486                	sd	ra,72(sp)
    80003d14:	e0a2                	sd	s0,64(sp)
    80003d16:	fc26                	sd	s1,56(sp)
    80003d18:	f84a                	sd	s2,48(sp)
    80003d1a:	f44e                	sd	s3,40(sp)
    80003d1c:	0880                	addi	s0,sp,80
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d22:	ffffd097          	auipc	ra,0xffffd
    80003d26:	108080e7          	jalr	264(ra) # 80000e2a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d2a:	409c                	lw	a5,0(s1)
    80003d2c:	37f9                	addiw	a5,a5,-2
    80003d2e:	4705                	li	a4,1
    80003d30:	04f76763          	bltu	a4,a5,80003d7e <filestat+0x6e>
    80003d34:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d36:	6c88                	ld	a0,24(s1)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	072080e7          	jalr	114(ra) # 80002daa <ilock>
    stati(f->ip, &st);
    80003d40:	fb840593          	addi	a1,s0,-72
    80003d44:	6c88                	ld	a0,24(s1)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	2ee080e7          	jalr	750(ra) # 80003034 <stati>
    iunlock(f->ip);
    80003d4e:	6c88                	ld	a0,24(s1)
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	11c080e7          	jalr	284(ra) # 80002e6c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d58:	46e1                	li	a3,24
    80003d5a:	fb840613          	addi	a2,s0,-72
    80003d5e:	85ce                	mv	a1,s3
    80003d60:	05093503          	ld	a0,80(s2)
    80003d64:	ffffd097          	auipc	ra,0xffffd
    80003d68:	d88080e7          	jalr	-632(ra) # 80000aec <copyout>
    80003d6c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d70:	60a6                	ld	ra,72(sp)
    80003d72:	6406                	ld	s0,64(sp)
    80003d74:	74e2                	ld	s1,56(sp)
    80003d76:	7942                	ld	s2,48(sp)
    80003d78:	79a2                	ld	s3,40(sp)
    80003d7a:	6161                	addi	sp,sp,80
    80003d7c:	8082                	ret
  return -1;
    80003d7e:	557d                	li	a0,-1
    80003d80:	bfc5                	j	80003d70 <filestat+0x60>

0000000080003d82 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d82:	7179                	addi	sp,sp,-48
    80003d84:	f406                	sd	ra,40(sp)
    80003d86:	f022                	sd	s0,32(sp)
    80003d88:	ec26                	sd	s1,24(sp)
    80003d8a:	e84a                	sd	s2,16(sp)
    80003d8c:	e44e                	sd	s3,8(sp)
    80003d8e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d90:	00854783          	lbu	a5,8(a0)
    80003d94:	c3d5                	beqz	a5,80003e38 <fileread+0xb6>
    80003d96:	84aa                	mv	s1,a0
    80003d98:	89ae                	mv	s3,a1
    80003d9a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d9c:	411c                	lw	a5,0(a0)
    80003d9e:	4705                	li	a4,1
    80003da0:	04e78963          	beq	a5,a4,80003df2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003da4:	470d                	li	a4,3
    80003da6:	04e78d63          	beq	a5,a4,80003e00 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003daa:	4709                	li	a4,2
    80003dac:	06e79e63          	bne	a5,a4,80003e28 <fileread+0xa6>
    ilock(f->ip);
    80003db0:	6d08                	ld	a0,24(a0)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	ff8080e7          	jalr	-8(ra) # 80002daa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dba:	874a                	mv	a4,s2
    80003dbc:	5094                	lw	a3,32(s1)
    80003dbe:	864e                	mv	a2,s3
    80003dc0:	4585                	li	a1,1
    80003dc2:	6c88                	ld	a0,24(s1)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	29a080e7          	jalr	666(ra) # 8000305e <readi>
    80003dcc:	892a                	mv	s2,a0
    80003dce:	00a05563          	blez	a0,80003dd8 <fileread+0x56>
      f->off += r;
    80003dd2:	509c                	lw	a5,32(s1)
    80003dd4:	9fa9                	addw	a5,a5,a0
    80003dd6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dd8:	6c88                	ld	a0,24(s1)
    80003dda:	fffff097          	auipc	ra,0xfffff
    80003dde:	092080e7          	jalr	146(ra) # 80002e6c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003de2:	854a                	mv	a0,s2
    80003de4:	70a2                	ld	ra,40(sp)
    80003de6:	7402                	ld	s0,32(sp)
    80003de8:	64e2                	ld	s1,24(sp)
    80003dea:	6942                	ld	s2,16(sp)
    80003dec:	69a2                	ld	s3,8(sp)
    80003dee:	6145                	addi	sp,sp,48
    80003df0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003df2:	6908                	ld	a0,16(a0)
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	3c8080e7          	jalr	968(ra) # 800041bc <piperead>
    80003dfc:	892a                	mv	s2,a0
    80003dfe:	b7d5                	j	80003de2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e00:	02451783          	lh	a5,36(a0)
    80003e04:	03079693          	slli	a3,a5,0x30
    80003e08:	92c1                	srli	a3,a3,0x30
    80003e0a:	4725                	li	a4,9
    80003e0c:	02d76863          	bltu	a4,a3,80003e3c <fileread+0xba>
    80003e10:	0792                	slli	a5,a5,0x4
    80003e12:	0001d717          	auipc	a4,0x1d
    80003e16:	2b670713          	addi	a4,a4,694 # 800210c8 <devsw>
    80003e1a:	97ba                	add	a5,a5,a4
    80003e1c:	639c                	ld	a5,0(a5)
    80003e1e:	c38d                	beqz	a5,80003e40 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e20:	4505                	li	a0,1
    80003e22:	9782                	jalr	a5
    80003e24:	892a                	mv	s2,a0
    80003e26:	bf75                	j	80003de2 <fileread+0x60>
    panic("fileread");
    80003e28:	00004517          	auipc	a0,0x4
    80003e2c:	7f050513          	addi	a0,a0,2032 # 80008618 <syscalls+0x268>
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	468080e7          	jalr	1128(ra) # 80006298 <panic>
    return -1;
    80003e38:	597d                	li	s2,-1
    80003e3a:	b765                	j	80003de2 <fileread+0x60>
      return -1;
    80003e3c:	597d                	li	s2,-1
    80003e3e:	b755                	j	80003de2 <fileread+0x60>
    80003e40:	597d                	li	s2,-1
    80003e42:	b745                	j	80003de2 <fileread+0x60>

0000000080003e44 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e44:	715d                	addi	sp,sp,-80
    80003e46:	e486                	sd	ra,72(sp)
    80003e48:	e0a2                	sd	s0,64(sp)
    80003e4a:	fc26                	sd	s1,56(sp)
    80003e4c:	f84a                	sd	s2,48(sp)
    80003e4e:	f44e                	sd	s3,40(sp)
    80003e50:	f052                	sd	s4,32(sp)
    80003e52:	ec56                	sd	s5,24(sp)
    80003e54:	e85a                	sd	s6,16(sp)
    80003e56:	e45e                	sd	s7,8(sp)
    80003e58:	e062                	sd	s8,0(sp)
    80003e5a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e5c:	00954783          	lbu	a5,9(a0)
    80003e60:	10078663          	beqz	a5,80003f6c <filewrite+0x128>
    80003e64:	892a                	mv	s2,a0
    80003e66:	8aae                	mv	s5,a1
    80003e68:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e6a:	411c                	lw	a5,0(a0)
    80003e6c:	4705                	li	a4,1
    80003e6e:	02e78263          	beq	a5,a4,80003e92 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e72:	470d                	li	a4,3
    80003e74:	02e78663          	beq	a5,a4,80003ea0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e78:	4709                	li	a4,2
    80003e7a:	0ee79163          	bne	a5,a4,80003f5c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e7e:	0ac05d63          	blez	a2,80003f38 <filewrite+0xf4>
    int i = 0;
    80003e82:	4981                	li	s3,0
    80003e84:	6b05                	lui	s6,0x1
    80003e86:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e8a:	6b85                	lui	s7,0x1
    80003e8c:	c00b8b9b          	addiw	s7,s7,-1024
    80003e90:	a861                	j	80003f28 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e92:	6908                	ld	a0,16(a0)
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	22e080e7          	jalr	558(ra) # 800040c2 <pipewrite>
    80003e9c:	8a2a                	mv	s4,a0
    80003e9e:	a045                	j	80003f3e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ea0:	02451783          	lh	a5,36(a0)
    80003ea4:	03079693          	slli	a3,a5,0x30
    80003ea8:	92c1                	srli	a3,a3,0x30
    80003eaa:	4725                	li	a4,9
    80003eac:	0cd76263          	bltu	a4,a3,80003f70 <filewrite+0x12c>
    80003eb0:	0792                	slli	a5,a5,0x4
    80003eb2:	0001d717          	auipc	a4,0x1d
    80003eb6:	21670713          	addi	a4,a4,534 # 800210c8 <devsw>
    80003eba:	97ba                	add	a5,a5,a4
    80003ebc:	679c                	ld	a5,8(a5)
    80003ebe:	cbdd                	beqz	a5,80003f74 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ec0:	4505                	li	a0,1
    80003ec2:	9782                	jalr	a5
    80003ec4:	8a2a                	mv	s4,a0
    80003ec6:	a8a5                	j	80003f3e <filewrite+0xfa>
    80003ec8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	8b0080e7          	jalr	-1872(ra) # 8000377c <begin_op>
      ilock(f->ip);
    80003ed4:	01893503          	ld	a0,24(s2)
    80003ed8:	fffff097          	auipc	ra,0xfffff
    80003edc:	ed2080e7          	jalr	-302(ra) # 80002daa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ee0:	8762                	mv	a4,s8
    80003ee2:	02092683          	lw	a3,32(s2)
    80003ee6:	01598633          	add	a2,s3,s5
    80003eea:	4585                	li	a1,1
    80003eec:	01893503          	ld	a0,24(s2)
    80003ef0:	fffff097          	auipc	ra,0xfffff
    80003ef4:	266080e7          	jalr	614(ra) # 80003156 <writei>
    80003ef8:	84aa                	mv	s1,a0
    80003efa:	00a05763          	blez	a0,80003f08 <filewrite+0xc4>
        f->off += r;
    80003efe:	02092783          	lw	a5,32(s2)
    80003f02:	9fa9                	addw	a5,a5,a0
    80003f04:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f08:	01893503          	ld	a0,24(s2)
    80003f0c:	fffff097          	auipc	ra,0xfffff
    80003f10:	f60080e7          	jalr	-160(ra) # 80002e6c <iunlock>
      end_op();
    80003f14:	00000097          	auipc	ra,0x0
    80003f18:	8e8080e7          	jalr	-1816(ra) # 800037fc <end_op>

      if(r != n1){
    80003f1c:	009c1f63          	bne	s8,s1,80003f3a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f20:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f24:	0149db63          	bge	s3,s4,80003f3a <filewrite+0xf6>
      int n1 = n - i;
    80003f28:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f2c:	84be                	mv	s1,a5
    80003f2e:	2781                	sext.w	a5,a5
    80003f30:	f8fb5ce3          	bge	s6,a5,80003ec8 <filewrite+0x84>
    80003f34:	84de                	mv	s1,s7
    80003f36:	bf49                	j	80003ec8 <filewrite+0x84>
    int i = 0;
    80003f38:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f3a:	013a1f63          	bne	s4,s3,80003f58 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f3e:	8552                	mv	a0,s4
    80003f40:	60a6                	ld	ra,72(sp)
    80003f42:	6406                	ld	s0,64(sp)
    80003f44:	74e2                	ld	s1,56(sp)
    80003f46:	7942                	ld	s2,48(sp)
    80003f48:	79a2                	ld	s3,40(sp)
    80003f4a:	7a02                	ld	s4,32(sp)
    80003f4c:	6ae2                	ld	s5,24(sp)
    80003f4e:	6b42                	ld	s6,16(sp)
    80003f50:	6ba2                	ld	s7,8(sp)
    80003f52:	6c02                	ld	s8,0(sp)
    80003f54:	6161                	addi	sp,sp,80
    80003f56:	8082                	ret
    ret = (i == n ? n : -1);
    80003f58:	5a7d                	li	s4,-1
    80003f5a:	b7d5                	j	80003f3e <filewrite+0xfa>
    panic("filewrite");
    80003f5c:	00004517          	auipc	a0,0x4
    80003f60:	6cc50513          	addi	a0,a0,1740 # 80008628 <syscalls+0x278>
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	334080e7          	jalr	820(ra) # 80006298 <panic>
    return -1;
    80003f6c:	5a7d                	li	s4,-1
    80003f6e:	bfc1                	j	80003f3e <filewrite+0xfa>
      return -1;
    80003f70:	5a7d                	li	s4,-1
    80003f72:	b7f1                	j	80003f3e <filewrite+0xfa>
    80003f74:	5a7d                	li	s4,-1
    80003f76:	b7e1                	j	80003f3e <filewrite+0xfa>

0000000080003f78 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f78:	7179                	addi	sp,sp,-48
    80003f7a:	f406                	sd	ra,40(sp)
    80003f7c:	f022                	sd	s0,32(sp)
    80003f7e:	ec26                	sd	s1,24(sp)
    80003f80:	e84a                	sd	s2,16(sp)
    80003f82:	e44e                	sd	s3,8(sp)
    80003f84:	e052                	sd	s4,0(sp)
    80003f86:	1800                	addi	s0,sp,48
    80003f88:	84aa                	mv	s1,a0
    80003f8a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f8c:	0005b023          	sd	zero,0(a1)
    80003f90:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f94:	00000097          	auipc	ra,0x0
    80003f98:	bf8080e7          	jalr	-1032(ra) # 80003b8c <filealloc>
    80003f9c:	e088                	sd	a0,0(s1)
    80003f9e:	c551                	beqz	a0,8000402a <pipealloc+0xb2>
    80003fa0:	00000097          	auipc	ra,0x0
    80003fa4:	bec080e7          	jalr	-1044(ra) # 80003b8c <filealloc>
    80003fa8:	00aa3023          	sd	a0,0(s4)
    80003fac:	c92d                	beqz	a0,8000401e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fae:	ffffc097          	auipc	ra,0xffffc
    80003fb2:	16a080e7          	jalr	362(ra) # 80000118 <kalloc>
    80003fb6:	892a                	mv	s2,a0
    80003fb8:	c125                	beqz	a0,80004018 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fba:	4985                	li	s3,1
    80003fbc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fc0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fc4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fc8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fcc:	00004597          	auipc	a1,0x4
    80003fd0:	66c58593          	addi	a1,a1,1644 # 80008638 <syscalls+0x288>
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	77e080e7          	jalr	1918(ra) # 80006752 <initlock>
  (*f0)->type = FD_PIPE;
    80003fdc:	609c                	ld	a5,0(s1)
    80003fde:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fe2:	609c                	ld	a5,0(s1)
    80003fe4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fe8:	609c                	ld	a5,0(s1)
    80003fea:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fee:	609c                	ld	a5,0(s1)
    80003ff0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ff4:	000a3783          	ld	a5,0(s4)
    80003ff8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ffc:	000a3783          	ld	a5,0(s4)
    80004000:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004004:	000a3783          	ld	a5,0(s4)
    80004008:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000400c:	000a3783          	ld	a5,0(s4)
    80004010:	0127b823          	sd	s2,16(a5)
  return 0;
    80004014:	4501                	li	a0,0
    80004016:	a025                	j	8000403e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004018:	6088                	ld	a0,0(s1)
    8000401a:	e501                	bnez	a0,80004022 <pipealloc+0xaa>
    8000401c:	a039                	j	8000402a <pipealloc+0xb2>
    8000401e:	6088                	ld	a0,0(s1)
    80004020:	c51d                	beqz	a0,8000404e <pipealloc+0xd6>
    fileclose(*f0);
    80004022:	00000097          	auipc	ra,0x0
    80004026:	c26080e7          	jalr	-986(ra) # 80003c48 <fileclose>
  if(*f1)
    8000402a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000402e:	557d                	li	a0,-1
  if(*f1)
    80004030:	c799                	beqz	a5,8000403e <pipealloc+0xc6>
    fileclose(*f1);
    80004032:	853e                	mv	a0,a5
    80004034:	00000097          	auipc	ra,0x0
    80004038:	c14080e7          	jalr	-1004(ra) # 80003c48 <fileclose>
  return -1;
    8000403c:	557d                	li	a0,-1
}
    8000403e:	70a2                	ld	ra,40(sp)
    80004040:	7402                	ld	s0,32(sp)
    80004042:	64e2                	ld	s1,24(sp)
    80004044:	6942                	ld	s2,16(sp)
    80004046:	69a2                	ld	s3,8(sp)
    80004048:	6a02                	ld	s4,0(sp)
    8000404a:	6145                	addi	sp,sp,48
    8000404c:	8082                	ret
  return -1;
    8000404e:	557d                	li	a0,-1
    80004050:	b7fd                	j	8000403e <pipealloc+0xc6>

0000000080004052 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004052:	1101                	addi	sp,sp,-32
    80004054:	ec06                	sd	ra,24(sp)
    80004056:	e822                	sd	s0,16(sp)
    80004058:	e426                	sd	s1,8(sp)
    8000405a:	e04a                	sd	s2,0(sp)
    8000405c:	1000                	addi	s0,sp,32
    8000405e:	84aa                	mv	s1,a0
    80004060:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004062:	00002097          	auipc	ra,0x2
    80004066:	780080e7          	jalr	1920(ra) # 800067e2 <acquire>
  if(writable){
    8000406a:	02090d63          	beqz	s2,800040a4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000406e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004072:	21848513          	addi	a0,s1,536
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	640080e7          	jalr	1600(ra) # 800016b6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000407e:	2204b783          	ld	a5,544(s1)
    80004082:	eb95                	bnez	a5,800040b6 <pipeclose+0x64>
    release(&pi->lock);
    80004084:	8526                	mv	a0,s1
    80004086:	00003097          	auipc	ra,0x3
    8000408a:	810080e7          	jalr	-2032(ra) # 80006896 <release>
    kfree((char*)pi);
    8000408e:	8526                	mv	a0,s1
    80004090:	ffffc097          	auipc	ra,0xffffc
    80004094:	f8c080e7          	jalr	-116(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004098:	60e2                	ld	ra,24(sp)
    8000409a:	6442                	ld	s0,16(sp)
    8000409c:	64a2                	ld	s1,8(sp)
    8000409e:	6902                	ld	s2,0(sp)
    800040a0:	6105                	addi	sp,sp,32
    800040a2:	8082                	ret
    pi->readopen = 0;
    800040a4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040a8:	21c48513          	addi	a0,s1,540
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	60a080e7          	jalr	1546(ra) # 800016b6 <wakeup>
    800040b4:	b7e9                	j	8000407e <pipeclose+0x2c>
    release(&pi->lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00002097          	auipc	ra,0x2
    800040bc:	7de080e7          	jalr	2014(ra) # 80006896 <release>
}
    800040c0:	bfe1                	j	80004098 <pipeclose+0x46>

00000000800040c2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040c2:	7159                	addi	sp,sp,-112
    800040c4:	f486                	sd	ra,104(sp)
    800040c6:	f0a2                	sd	s0,96(sp)
    800040c8:	eca6                	sd	s1,88(sp)
    800040ca:	e8ca                	sd	s2,80(sp)
    800040cc:	e4ce                	sd	s3,72(sp)
    800040ce:	e0d2                	sd	s4,64(sp)
    800040d0:	fc56                	sd	s5,56(sp)
    800040d2:	f85a                	sd	s6,48(sp)
    800040d4:	f45e                	sd	s7,40(sp)
    800040d6:	f062                	sd	s8,32(sp)
    800040d8:	ec66                	sd	s9,24(sp)
    800040da:	1880                	addi	s0,sp,112
    800040dc:	84aa                	mv	s1,a0
    800040de:	8aae                	mv	s5,a1
    800040e0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	d48080e7          	jalr	-696(ra) # 80000e2a <myproc>
    800040ea:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040ec:	8526                	mv	a0,s1
    800040ee:	00002097          	auipc	ra,0x2
    800040f2:	6f4080e7          	jalr	1780(ra) # 800067e2 <acquire>
  while(i < n){
    800040f6:	0d405163          	blez	s4,800041b8 <pipewrite+0xf6>
    800040fa:	8ba6                	mv	s7,s1
  int i = 0;
    800040fc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040fe:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004100:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004104:	21c48c13          	addi	s8,s1,540
    80004108:	a08d                	j	8000416a <pipewrite+0xa8>
      release(&pi->lock);
    8000410a:	8526                	mv	a0,s1
    8000410c:	00002097          	auipc	ra,0x2
    80004110:	78a080e7          	jalr	1930(ra) # 80006896 <release>
      return -1;
    80004114:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004116:	854a                	mv	a0,s2
    80004118:	70a6                	ld	ra,104(sp)
    8000411a:	7406                	ld	s0,96(sp)
    8000411c:	64e6                	ld	s1,88(sp)
    8000411e:	6946                	ld	s2,80(sp)
    80004120:	69a6                	ld	s3,72(sp)
    80004122:	6a06                	ld	s4,64(sp)
    80004124:	7ae2                	ld	s5,56(sp)
    80004126:	7b42                	ld	s6,48(sp)
    80004128:	7ba2                	ld	s7,40(sp)
    8000412a:	7c02                	ld	s8,32(sp)
    8000412c:	6ce2                	ld	s9,24(sp)
    8000412e:	6165                	addi	sp,sp,112
    80004130:	8082                	ret
      wakeup(&pi->nread);
    80004132:	8566                	mv	a0,s9
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	582080e7          	jalr	1410(ra) # 800016b6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000413c:	85de                	mv	a1,s7
    8000413e:	8562                	mv	a0,s8
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	3ea080e7          	jalr	1002(ra) # 8000152a <sleep>
    80004148:	a839                	j	80004166 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000414a:	21c4a783          	lw	a5,540(s1)
    8000414e:	0017871b          	addiw	a4,a5,1
    80004152:	20e4ae23          	sw	a4,540(s1)
    80004156:	1ff7f793          	andi	a5,a5,511
    8000415a:	97a6                	add	a5,a5,s1
    8000415c:	f9f44703          	lbu	a4,-97(s0)
    80004160:	00e78c23          	sb	a4,24(a5)
      i++;
    80004164:	2905                	addiw	s2,s2,1
  while(i < n){
    80004166:	03495d63          	bge	s2,s4,800041a0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000416a:	2204a783          	lw	a5,544(s1)
    8000416e:	dfd1                	beqz	a5,8000410a <pipewrite+0x48>
    80004170:	0289a783          	lw	a5,40(s3)
    80004174:	fbd9                	bnez	a5,8000410a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004176:	2184a783          	lw	a5,536(s1)
    8000417a:	21c4a703          	lw	a4,540(s1)
    8000417e:	2007879b          	addiw	a5,a5,512
    80004182:	faf708e3          	beq	a4,a5,80004132 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004186:	4685                	li	a3,1
    80004188:	01590633          	add	a2,s2,s5
    8000418c:	f9f40593          	addi	a1,s0,-97
    80004190:	0509b503          	ld	a0,80(s3)
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	9e4080e7          	jalr	-1564(ra) # 80000b78 <copyin>
    8000419c:	fb6517e3          	bne	a0,s6,8000414a <pipewrite+0x88>
  wakeup(&pi->nread);
    800041a0:	21848513          	addi	a0,s1,536
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	512080e7          	jalr	1298(ra) # 800016b6 <wakeup>
  release(&pi->lock);
    800041ac:	8526                	mv	a0,s1
    800041ae:	00002097          	auipc	ra,0x2
    800041b2:	6e8080e7          	jalr	1768(ra) # 80006896 <release>
  return i;
    800041b6:	b785                	j	80004116 <pipewrite+0x54>
  int i = 0;
    800041b8:	4901                	li	s2,0
    800041ba:	b7dd                	j	800041a0 <pipewrite+0xde>

00000000800041bc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041bc:	715d                	addi	sp,sp,-80
    800041be:	e486                	sd	ra,72(sp)
    800041c0:	e0a2                	sd	s0,64(sp)
    800041c2:	fc26                	sd	s1,56(sp)
    800041c4:	f84a                	sd	s2,48(sp)
    800041c6:	f44e                	sd	s3,40(sp)
    800041c8:	f052                	sd	s4,32(sp)
    800041ca:	ec56                	sd	s5,24(sp)
    800041cc:	e85a                	sd	s6,16(sp)
    800041ce:	0880                	addi	s0,sp,80
    800041d0:	84aa                	mv	s1,a0
    800041d2:	892e                	mv	s2,a1
    800041d4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	c54080e7          	jalr	-940(ra) # 80000e2a <myproc>
    800041de:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041e0:	8b26                	mv	s6,s1
    800041e2:	8526                	mv	a0,s1
    800041e4:	00002097          	auipc	ra,0x2
    800041e8:	5fe080e7          	jalr	1534(ra) # 800067e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ec:	2184a703          	lw	a4,536(s1)
    800041f0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041f4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041f8:	02f71463          	bne	a4,a5,80004220 <piperead+0x64>
    800041fc:	2244a783          	lw	a5,548(s1)
    80004200:	c385                	beqz	a5,80004220 <piperead+0x64>
    if(pr->killed){
    80004202:	028a2783          	lw	a5,40(s4)
    80004206:	ebc1                	bnez	a5,80004296 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004208:	85da                	mv	a1,s6
    8000420a:	854e                	mv	a0,s3
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	31e080e7          	jalr	798(ra) # 8000152a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004214:	2184a703          	lw	a4,536(s1)
    80004218:	21c4a783          	lw	a5,540(s1)
    8000421c:	fef700e3          	beq	a4,a5,800041fc <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004220:	09505263          	blez	s5,800042a4 <piperead+0xe8>
    80004224:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004226:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004228:	2184a783          	lw	a5,536(s1)
    8000422c:	21c4a703          	lw	a4,540(s1)
    80004230:	02f70d63          	beq	a4,a5,8000426a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004234:	0017871b          	addiw	a4,a5,1
    80004238:	20e4ac23          	sw	a4,536(s1)
    8000423c:	1ff7f793          	andi	a5,a5,511
    80004240:	97a6                	add	a5,a5,s1
    80004242:	0187c783          	lbu	a5,24(a5)
    80004246:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000424a:	4685                	li	a3,1
    8000424c:	fbf40613          	addi	a2,s0,-65
    80004250:	85ca                	mv	a1,s2
    80004252:	050a3503          	ld	a0,80(s4)
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	896080e7          	jalr	-1898(ra) # 80000aec <copyout>
    8000425e:	01650663          	beq	a0,s6,8000426a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004262:	2985                	addiw	s3,s3,1
    80004264:	0905                	addi	s2,s2,1
    80004266:	fd3a91e3          	bne	s5,s3,80004228 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000426a:	21c48513          	addi	a0,s1,540
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	448080e7          	jalr	1096(ra) # 800016b6 <wakeup>
  release(&pi->lock);
    80004276:	8526                	mv	a0,s1
    80004278:	00002097          	auipc	ra,0x2
    8000427c:	61e080e7          	jalr	1566(ra) # 80006896 <release>
  return i;
}
    80004280:	854e                	mv	a0,s3
    80004282:	60a6                	ld	ra,72(sp)
    80004284:	6406                	ld	s0,64(sp)
    80004286:	74e2                	ld	s1,56(sp)
    80004288:	7942                	ld	s2,48(sp)
    8000428a:	79a2                	ld	s3,40(sp)
    8000428c:	7a02                	ld	s4,32(sp)
    8000428e:	6ae2                	ld	s5,24(sp)
    80004290:	6b42                	ld	s6,16(sp)
    80004292:	6161                	addi	sp,sp,80
    80004294:	8082                	ret
      release(&pi->lock);
    80004296:	8526                	mv	a0,s1
    80004298:	00002097          	auipc	ra,0x2
    8000429c:	5fe080e7          	jalr	1534(ra) # 80006896 <release>
      return -1;
    800042a0:	59fd                	li	s3,-1
    800042a2:	bff9                	j	80004280 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a4:	4981                	li	s3,0
    800042a6:	b7d1                	j	8000426a <piperead+0xae>

00000000800042a8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042a8:	df010113          	addi	sp,sp,-528
    800042ac:	20113423          	sd	ra,520(sp)
    800042b0:	20813023          	sd	s0,512(sp)
    800042b4:	ffa6                	sd	s1,504(sp)
    800042b6:	fbca                	sd	s2,496(sp)
    800042b8:	f7ce                	sd	s3,488(sp)
    800042ba:	f3d2                	sd	s4,480(sp)
    800042bc:	efd6                	sd	s5,472(sp)
    800042be:	ebda                	sd	s6,464(sp)
    800042c0:	e7de                	sd	s7,456(sp)
    800042c2:	e3e2                	sd	s8,448(sp)
    800042c4:	ff66                	sd	s9,440(sp)
    800042c6:	fb6a                	sd	s10,432(sp)
    800042c8:	f76e                	sd	s11,424(sp)
    800042ca:	0c00                	addi	s0,sp,528
    800042cc:	84aa                	mv	s1,a0
    800042ce:	dea43c23          	sd	a0,-520(s0)
    800042d2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	b54080e7          	jalr	-1196(ra) # 80000e2a <myproc>
    800042de:	892a                	mv	s2,a0

  begin_op();
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	49c080e7          	jalr	1180(ra) # 8000377c <begin_op>

  if((ip = namei(path)) == 0){
    800042e8:	8526                	mv	a0,s1
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	276080e7          	jalr	630(ra) # 80003560 <namei>
    800042f2:	c92d                	beqz	a0,80004364 <exec+0xbc>
    800042f4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	ab4080e7          	jalr	-1356(ra) # 80002daa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042fe:	04000713          	li	a4,64
    80004302:	4681                	li	a3,0
    80004304:	e5040613          	addi	a2,s0,-432
    80004308:	4581                	li	a1,0
    8000430a:	8526                	mv	a0,s1
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	d52080e7          	jalr	-686(ra) # 8000305e <readi>
    80004314:	04000793          	li	a5,64
    80004318:	00f51a63          	bne	a0,a5,8000432c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000431c:	e5042703          	lw	a4,-432(s0)
    80004320:	464c47b7          	lui	a5,0x464c4
    80004324:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004328:	04f70463          	beq	a4,a5,80004370 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000432c:	8526                	mv	a0,s1
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	cde080e7          	jalr	-802(ra) # 8000300c <iunlockput>
    end_op();
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	4c6080e7          	jalr	1222(ra) # 800037fc <end_op>
  }
  return -1;
    8000433e:	557d                	li	a0,-1
}
    80004340:	20813083          	ld	ra,520(sp)
    80004344:	20013403          	ld	s0,512(sp)
    80004348:	74fe                	ld	s1,504(sp)
    8000434a:	795e                	ld	s2,496(sp)
    8000434c:	79be                	ld	s3,488(sp)
    8000434e:	7a1e                	ld	s4,480(sp)
    80004350:	6afe                	ld	s5,472(sp)
    80004352:	6b5e                	ld	s6,464(sp)
    80004354:	6bbe                	ld	s7,456(sp)
    80004356:	6c1e                	ld	s8,448(sp)
    80004358:	7cfa                	ld	s9,440(sp)
    8000435a:	7d5a                	ld	s10,432(sp)
    8000435c:	7dba                	ld	s11,424(sp)
    8000435e:	21010113          	addi	sp,sp,528
    80004362:	8082                	ret
    end_op();
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	498080e7          	jalr	1176(ra) # 800037fc <end_op>
    return -1;
    8000436c:	557d                	li	a0,-1
    8000436e:	bfc9                	j	80004340 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004370:	854a                	mv	a0,s2
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	b7c080e7          	jalr	-1156(ra) # 80000eee <proc_pagetable>
    8000437a:	8baa                	mv	s7,a0
    8000437c:	d945                	beqz	a0,8000432c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000437e:	e7042983          	lw	s3,-400(s0)
    80004382:	e8845783          	lhu	a5,-376(s0)
    80004386:	c7ad                	beqz	a5,800043f0 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004388:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438a:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000438c:	6c85                	lui	s9,0x1
    8000438e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004392:	def43823          	sd	a5,-528(s0)
    80004396:	a42d                	j	800045c0 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004398:	00004517          	auipc	a0,0x4
    8000439c:	2a850513          	addi	a0,a0,680 # 80008640 <syscalls+0x290>
    800043a0:	00002097          	auipc	ra,0x2
    800043a4:	ef8080e7          	jalr	-264(ra) # 80006298 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043a8:	8756                	mv	a4,s5
    800043aa:	012d86bb          	addw	a3,s11,s2
    800043ae:	4581                	li	a1,0
    800043b0:	8526                	mv	a0,s1
    800043b2:	fffff097          	auipc	ra,0xfffff
    800043b6:	cac080e7          	jalr	-852(ra) # 8000305e <readi>
    800043ba:	2501                	sext.w	a0,a0
    800043bc:	1aaa9963          	bne	s5,a0,8000456e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800043c0:	6785                	lui	a5,0x1
    800043c2:	0127893b          	addw	s2,a5,s2
    800043c6:	77fd                	lui	a5,0xfffff
    800043c8:	01478a3b          	addw	s4,a5,s4
    800043cc:	1f897163          	bgeu	s2,s8,800045ae <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800043d0:	02091593          	slli	a1,s2,0x20
    800043d4:	9181                	srli	a1,a1,0x20
    800043d6:	95ea                	add	a1,a1,s10
    800043d8:	855e                	mv	a0,s7
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	12c080e7          	jalr	300(ra) # 80000506 <walkaddr>
    800043e2:	862a                	mv	a2,a0
    if(pa == 0)
    800043e4:	d955                	beqz	a0,80004398 <exec+0xf0>
      n = PGSIZE;
    800043e6:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043e8:	fd9a70e3          	bgeu	s4,s9,800043a8 <exec+0x100>
      n = sz - i;
    800043ec:	8ad2                	mv	s5,s4
    800043ee:	bf6d                	j	800043a8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043f0:	4901                	li	s2,0
  iunlockput(ip);
    800043f2:	8526                	mv	a0,s1
    800043f4:	fffff097          	auipc	ra,0xfffff
    800043f8:	c18080e7          	jalr	-1000(ra) # 8000300c <iunlockput>
  end_op();
    800043fc:	fffff097          	auipc	ra,0xfffff
    80004400:	400080e7          	jalr	1024(ra) # 800037fc <end_op>
  p = myproc();
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	a26080e7          	jalr	-1498(ra) # 80000e2a <myproc>
    8000440c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000440e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004412:	6785                	lui	a5,0x1
    80004414:	17fd                	addi	a5,a5,-1
    80004416:	993e                	add	s2,s2,a5
    80004418:	757d                	lui	a0,0xfffff
    8000441a:	00a977b3          	and	a5,s2,a0
    8000441e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004422:	6609                	lui	a2,0x2
    80004424:	963e                	add	a2,a2,a5
    80004426:	85be                	mv	a1,a5
    80004428:	855e                	mv	a0,s7
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	472080e7          	jalr	1138(ra) # 8000089c <uvmalloc>
    80004432:	8b2a                	mv	s6,a0
  ip = 0;
    80004434:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004436:	12050c63          	beqz	a0,8000456e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000443a:	75f9                	lui	a1,0xffffe
    8000443c:	95aa                	add	a1,a1,a0
    8000443e:	855e                	mv	a0,s7
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	67a080e7          	jalr	1658(ra) # 80000aba <uvmclear>
  stackbase = sp - PGSIZE;
    80004448:	7c7d                	lui	s8,0xfffff
    8000444a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000444c:	e0043783          	ld	a5,-512(s0)
    80004450:	6388                	ld	a0,0(a5)
    80004452:	c535                	beqz	a0,800044be <exec+0x216>
    80004454:	e9040993          	addi	s3,s0,-368
    80004458:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000445c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	e9e080e7          	jalr	-354(ra) # 800002fc <strlen>
    80004466:	2505                	addiw	a0,a0,1
    80004468:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000446c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004470:	13896363          	bltu	s2,s8,80004596 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004474:	e0043d83          	ld	s11,-512(s0)
    80004478:	000dba03          	ld	s4,0(s11)
    8000447c:	8552                	mv	a0,s4
    8000447e:	ffffc097          	auipc	ra,0xffffc
    80004482:	e7e080e7          	jalr	-386(ra) # 800002fc <strlen>
    80004486:	0015069b          	addiw	a3,a0,1
    8000448a:	8652                	mv	a2,s4
    8000448c:	85ca                	mv	a1,s2
    8000448e:	855e                	mv	a0,s7
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	65c080e7          	jalr	1628(ra) # 80000aec <copyout>
    80004498:	10054363          	bltz	a0,8000459e <exec+0x2f6>
    ustack[argc] = sp;
    8000449c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044a0:	0485                	addi	s1,s1,1
    800044a2:	008d8793          	addi	a5,s11,8
    800044a6:	e0f43023          	sd	a5,-512(s0)
    800044aa:	008db503          	ld	a0,8(s11)
    800044ae:	c911                	beqz	a0,800044c2 <exec+0x21a>
    if(argc >= MAXARG)
    800044b0:	09a1                	addi	s3,s3,8
    800044b2:	fb3c96e3          	bne	s9,s3,8000445e <exec+0x1b6>
  sz = sz1;
    800044b6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ba:	4481                	li	s1,0
    800044bc:	a84d                	j	8000456e <exec+0x2c6>
  sp = sz;
    800044be:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044c0:	4481                	li	s1,0
  ustack[argc] = 0;
    800044c2:	00349793          	slli	a5,s1,0x3
    800044c6:	f9040713          	addi	a4,s0,-112
    800044ca:	97ba                	add	a5,a5,a4
    800044cc:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044d0:	00148693          	addi	a3,s1,1
    800044d4:	068e                	slli	a3,a3,0x3
    800044d6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044da:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044de:	01897663          	bgeu	s2,s8,800044ea <exec+0x242>
  sz = sz1;
    800044e2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e6:	4481                	li	s1,0
    800044e8:	a059                	j	8000456e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044ea:	e9040613          	addi	a2,s0,-368
    800044ee:	85ca                	mv	a1,s2
    800044f0:	855e                	mv	a0,s7
    800044f2:	ffffc097          	auipc	ra,0xffffc
    800044f6:	5fa080e7          	jalr	1530(ra) # 80000aec <copyout>
    800044fa:	0a054663          	bltz	a0,800045a6 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044fe:	058ab783          	ld	a5,88(s5)
    80004502:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004506:	df843783          	ld	a5,-520(s0)
    8000450a:	0007c703          	lbu	a4,0(a5)
    8000450e:	cf11                	beqz	a4,8000452a <exec+0x282>
    80004510:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004512:	02f00693          	li	a3,47
    80004516:	a039                	j	80004524 <exec+0x27c>
      last = s+1;
    80004518:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000451c:	0785                	addi	a5,a5,1
    8000451e:	fff7c703          	lbu	a4,-1(a5)
    80004522:	c701                	beqz	a4,8000452a <exec+0x282>
    if(*s == '/')
    80004524:	fed71ce3          	bne	a4,a3,8000451c <exec+0x274>
    80004528:	bfc5                	j	80004518 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000452a:	4641                	li	a2,16
    8000452c:	df843583          	ld	a1,-520(s0)
    80004530:	158a8513          	addi	a0,s5,344
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	d96080e7          	jalr	-618(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000453c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004540:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004544:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004548:	058ab783          	ld	a5,88(s5)
    8000454c:	e6843703          	ld	a4,-408(s0)
    80004550:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004552:	058ab783          	ld	a5,88(s5)
    80004556:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000455a:	85ea                	mv	a1,s10
    8000455c:	ffffd097          	auipc	ra,0xffffd
    80004560:	a2e080e7          	jalr	-1490(ra) # 80000f8a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004564:	0004851b          	sext.w	a0,s1
    80004568:	bbe1                	j	80004340 <exec+0x98>
    8000456a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000456e:	e0843583          	ld	a1,-504(s0)
    80004572:	855e                	mv	a0,s7
    80004574:	ffffd097          	auipc	ra,0xffffd
    80004578:	a16080e7          	jalr	-1514(ra) # 80000f8a <proc_freepagetable>
  if(ip){
    8000457c:	da0498e3          	bnez	s1,8000432c <exec+0x84>
  return -1;
    80004580:	557d                	li	a0,-1
    80004582:	bb7d                	j	80004340 <exec+0x98>
    80004584:	e1243423          	sd	s2,-504(s0)
    80004588:	b7dd                	j	8000456e <exec+0x2c6>
    8000458a:	e1243423          	sd	s2,-504(s0)
    8000458e:	b7c5                	j	8000456e <exec+0x2c6>
    80004590:	e1243423          	sd	s2,-504(s0)
    80004594:	bfe9                	j	8000456e <exec+0x2c6>
  sz = sz1;
    80004596:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000459a:	4481                	li	s1,0
    8000459c:	bfc9                	j	8000456e <exec+0x2c6>
  sz = sz1;
    8000459e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045a2:	4481                	li	s1,0
    800045a4:	b7e9                	j	8000456e <exec+0x2c6>
  sz = sz1;
    800045a6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045aa:	4481                	li	s1,0
    800045ac:	b7c9                	j	8000456e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045ae:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045b2:	2b05                	addiw	s6,s6,1
    800045b4:	0389899b          	addiw	s3,s3,56
    800045b8:	e8845783          	lhu	a5,-376(s0)
    800045bc:	e2fb5be3          	bge	s6,a5,800043f2 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045c0:	2981                	sext.w	s3,s3
    800045c2:	03800713          	li	a4,56
    800045c6:	86ce                	mv	a3,s3
    800045c8:	e1840613          	addi	a2,s0,-488
    800045cc:	4581                	li	a1,0
    800045ce:	8526                	mv	a0,s1
    800045d0:	fffff097          	auipc	ra,0xfffff
    800045d4:	a8e080e7          	jalr	-1394(ra) # 8000305e <readi>
    800045d8:	03800793          	li	a5,56
    800045dc:	f8f517e3          	bne	a0,a5,8000456a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800045e0:	e1842783          	lw	a5,-488(s0)
    800045e4:	4705                	li	a4,1
    800045e6:	fce796e3          	bne	a5,a4,800045b2 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045ea:	e4043603          	ld	a2,-448(s0)
    800045ee:	e3843783          	ld	a5,-456(s0)
    800045f2:	f8f669e3          	bltu	a2,a5,80004584 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045f6:	e2843783          	ld	a5,-472(s0)
    800045fa:	963e                	add	a2,a2,a5
    800045fc:	f8f667e3          	bltu	a2,a5,8000458a <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004600:	85ca                	mv	a1,s2
    80004602:	855e                	mv	a0,s7
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	298080e7          	jalr	664(ra) # 8000089c <uvmalloc>
    8000460c:	e0a43423          	sd	a0,-504(s0)
    80004610:	d141                	beqz	a0,80004590 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004612:	e2843d03          	ld	s10,-472(s0)
    80004616:	df043783          	ld	a5,-528(s0)
    8000461a:	00fd77b3          	and	a5,s10,a5
    8000461e:	fba1                	bnez	a5,8000456e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004620:	e2042d83          	lw	s11,-480(s0)
    80004624:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004628:	f80c03e3          	beqz	s8,800045ae <exec+0x306>
    8000462c:	8a62                	mv	s4,s8
    8000462e:	4901                	li	s2,0
    80004630:	b345                	j	800043d0 <exec+0x128>

0000000080004632 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004632:	7179                	addi	sp,sp,-48
    80004634:	f406                	sd	ra,40(sp)
    80004636:	f022                	sd	s0,32(sp)
    80004638:	ec26                	sd	s1,24(sp)
    8000463a:	e84a                	sd	s2,16(sp)
    8000463c:	1800                	addi	s0,sp,48
    8000463e:	892e                	mv	s2,a1
    80004640:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004642:	fdc40593          	addi	a1,s0,-36
    80004646:	ffffe097          	auipc	ra,0xffffe
    8000464a:	bf2080e7          	jalr	-1038(ra) # 80002238 <argint>
    8000464e:	04054063          	bltz	a0,8000468e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004652:	fdc42703          	lw	a4,-36(s0)
    80004656:	47bd                	li	a5,15
    80004658:	02e7ed63          	bltu	a5,a4,80004692 <argfd+0x60>
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	7ce080e7          	jalr	1998(ra) # 80000e2a <myproc>
    80004664:	fdc42703          	lw	a4,-36(s0)
    80004668:	01a70793          	addi	a5,a4,26
    8000466c:	078e                	slli	a5,a5,0x3
    8000466e:	953e                	add	a0,a0,a5
    80004670:	611c                	ld	a5,0(a0)
    80004672:	c395                	beqz	a5,80004696 <argfd+0x64>
    return -1;
  if(pfd)
    80004674:	00090463          	beqz	s2,8000467c <argfd+0x4a>
    *pfd = fd;
    80004678:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000467c:	4501                	li	a0,0
  if(pf)
    8000467e:	c091                	beqz	s1,80004682 <argfd+0x50>
    *pf = f;
    80004680:	e09c                	sd	a5,0(s1)
}
    80004682:	70a2                	ld	ra,40(sp)
    80004684:	7402                	ld	s0,32(sp)
    80004686:	64e2                	ld	s1,24(sp)
    80004688:	6942                	ld	s2,16(sp)
    8000468a:	6145                	addi	sp,sp,48
    8000468c:	8082                	ret
    return -1;
    8000468e:	557d                	li	a0,-1
    80004690:	bfcd                	j	80004682 <argfd+0x50>
    return -1;
    80004692:	557d                	li	a0,-1
    80004694:	b7fd                	j	80004682 <argfd+0x50>
    80004696:	557d                	li	a0,-1
    80004698:	b7ed                	j	80004682 <argfd+0x50>

000000008000469a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000469a:	1101                	addi	sp,sp,-32
    8000469c:	ec06                	sd	ra,24(sp)
    8000469e:	e822                	sd	s0,16(sp)
    800046a0:	e426                	sd	s1,8(sp)
    800046a2:	1000                	addi	s0,sp,32
    800046a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046a6:	ffffc097          	auipc	ra,0xffffc
    800046aa:	784080e7          	jalr	1924(ra) # 80000e2a <myproc>
    800046ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046b0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd0e90>
    800046b4:	4501                	li	a0,0
    800046b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046b8:	6398                	ld	a4,0(a5)
    800046ba:	cb19                	beqz	a4,800046d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046bc:	2505                	addiw	a0,a0,1
    800046be:	07a1                	addi	a5,a5,8
    800046c0:	fed51ce3          	bne	a0,a3,800046b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046c4:	557d                	li	a0,-1
}
    800046c6:	60e2                	ld	ra,24(sp)
    800046c8:	6442                	ld	s0,16(sp)
    800046ca:	64a2                	ld	s1,8(sp)
    800046cc:	6105                	addi	sp,sp,32
    800046ce:	8082                	ret
      p->ofile[fd] = f;
    800046d0:	01a50793          	addi	a5,a0,26
    800046d4:	078e                	slli	a5,a5,0x3
    800046d6:	963e                	add	a2,a2,a5
    800046d8:	e204                	sd	s1,0(a2)
      return fd;
    800046da:	b7f5                	j	800046c6 <fdalloc+0x2c>

00000000800046dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046dc:	715d                	addi	sp,sp,-80
    800046de:	e486                	sd	ra,72(sp)
    800046e0:	e0a2                	sd	s0,64(sp)
    800046e2:	fc26                	sd	s1,56(sp)
    800046e4:	f84a                	sd	s2,48(sp)
    800046e6:	f44e                	sd	s3,40(sp)
    800046e8:	f052                	sd	s4,32(sp)
    800046ea:	ec56                	sd	s5,24(sp)
    800046ec:	0880                	addi	s0,sp,80
    800046ee:	89ae                	mv	s3,a1
    800046f0:	8ab2                	mv	s5,a2
    800046f2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046f4:	fb040593          	addi	a1,s0,-80
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	e86080e7          	jalr	-378(ra) # 8000357e <nameiparent>
    80004700:	892a                	mv	s2,a0
    80004702:	12050f63          	beqz	a0,80004840 <create+0x164>
    return 0;

  ilock(dp);
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	6a4080e7          	jalr	1700(ra) # 80002daa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000470e:	4601                	li	a2,0
    80004710:	fb040593          	addi	a1,s0,-80
    80004714:	854a                	mv	a0,s2
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	b78080e7          	jalr	-1160(ra) # 8000328e <dirlookup>
    8000471e:	84aa                	mv	s1,a0
    80004720:	c921                	beqz	a0,80004770 <create+0x94>
    iunlockput(dp);
    80004722:	854a                	mv	a0,s2
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	8e8080e7          	jalr	-1816(ra) # 8000300c <iunlockput>
    ilock(ip);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	67c080e7          	jalr	1660(ra) # 80002daa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004736:	2981                	sext.w	s3,s3
    80004738:	4789                	li	a5,2
    8000473a:	02f99463          	bne	s3,a5,80004762 <create+0x86>
    8000473e:	0444d783          	lhu	a5,68(s1)
    80004742:	37f9                	addiw	a5,a5,-2
    80004744:	17c2                	slli	a5,a5,0x30
    80004746:	93c1                	srli	a5,a5,0x30
    80004748:	4705                	li	a4,1
    8000474a:	00f76c63          	bltu	a4,a5,80004762 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000474e:	8526                	mv	a0,s1
    80004750:	60a6                	ld	ra,72(sp)
    80004752:	6406                	ld	s0,64(sp)
    80004754:	74e2                	ld	s1,56(sp)
    80004756:	7942                	ld	s2,48(sp)
    80004758:	79a2                	ld	s3,40(sp)
    8000475a:	7a02                	ld	s4,32(sp)
    8000475c:	6ae2                	ld	s5,24(sp)
    8000475e:	6161                	addi	sp,sp,80
    80004760:	8082                	ret
    iunlockput(ip);
    80004762:	8526                	mv	a0,s1
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	8a8080e7          	jalr	-1880(ra) # 8000300c <iunlockput>
    return 0;
    8000476c:	4481                	li	s1,0
    8000476e:	b7c5                	j	8000474e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004770:	85ce                	mv	a1,s3
    80004772:	00092503          	lw	a0,0(s2)
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	49c080e7          	jalr	1180(ra) # 80002c12 <ialloc>
    8000477e:	84aa                	mv	s1,a0
    80004780:	c529                	beqz	a0,800047ca <create+0xee>
  ilock(ip);
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	628080e7          	jalr	1576(ra) # 80002daa <ilock>
  ip->major = major;
    8000478a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000478e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004792:	4785                	li	a5,1
    80004794:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004798:	8526                	mv	a0,s1
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	546080e7          	jalr	1350(ra) # 80002ce0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047a2:	2981                	sext.w	s3,s3
    800047a4:	4785                	li	a5,1
    800047a6:	02f98a63          	beq	s3,a5,800047da <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047aa:	40d0                	lw	a2,4(s1)
    800047ac:	fb040593          	addi	a1,s0,-80
    800047b0:	854a                	mv	a0,s2
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	cec080e7          	jalr	-788(ra) # 8000349e <dirlink>
    800047ba:	06054b63          	bltz	a0,80004830 <create+0x154>
  iunlockput(dp);
    800047be:	854a                	mv	a0,s2
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	84c080e7          	jalr	-1972(ra) # 8000300c <iunlockput>
  return ip;
    800047c8:	b759                	j	8000474e <create+0x72>
    panic("create: ialloc");
    800047ca:	00004517          	auipc	a0,0x4
    800047ce:	e9650513          	addi	a0,a0,-362 # 80008660 <syscalls+0x2b0>
    800047d2:	00002097          	auipc	ra,0x2
    800047d6:	ac6080e7          	jalr	-1338(ra) # 80006298 <panic>
    dp->nlink++;  // for ".."
    800047da:	04a95783          	lhu	a5,74(s2)
    800047de:	2785                	addiw	a5,a5,1
    800047e0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047e4:	854a                	mv	a0,s2
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	4fa080e7          	jalr	1274(ra) # 80002ce0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ee:	40d0                	lw	a2,4(s1)
    800047f0:	00004597          	auipc	a1,0x4
    800047f4:	e8058593          	addi	a1,a1,-384 # 80008670 <syscalls+0x2c0>
    800047f8:	8526                	mv	a0,s1
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	ca4080e7          	jalr	-860(ra) # 8000349e <dirlink>
    80004802:	00054f63          	bltz	a0,80004820 <create+0x144>
    80004806:	00492603          	lw	a2,4(s2)
    8000480a:	00004597          	auipc	a1,0x4
    8000480e:	e6e58593          	addi	a1,a1,-402 # 80008678 <syscalls+0x2c8>
    80004812:	8526                	mv	a0,s1
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	c8a080e7          	jalr	-886(ra) # 8000349e <dirlink>
    8000481c:	f80557e3          	bgez	a0,800047aa <create+0xce>
      panic("create dots");
    80004820:	00004517          	auipc	a0,0x4
    80004824:	e6050513          	addi	a0,a0,-416 # 80008680 <syscalls+0x2d0>
    80004828:	00002097          	auipc	ra,0x2
    8000482c:	a70080e7          	jalr	-1424(ra) # 80006298 <panic>
    panic("create: dirlink");
    80004830:	00004517          	auipc	a0,0x4
    80004834:	e6050513          	addi	a0,a0,-416 # 80008690 <syscalls+0x2e0>
    80004838:	00002097          	auipc	ra,0x2
    8000483c:	a60080e7          	jalr	-1440(ra) # 80006298 <panic>
    return 0;
    80004840:	84aa                	mv	s1,a0
    80004842:	b731                	j	8000474e <create+0x72>

0000000080004844 <sys_dup>:
{
    80004844:	7179                	addi	sp,sp,-48
    80004846:	f406                	sd	ra,40(sp)
    80004848:	f022                	sd	s0,32(sp)
    8000484a:	ec26                	sd	s1,24(sp)
    8000484c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000484e:	fd840613          	addi	a2,s0,-40
    80004852:	4581                	li	a1,0
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	ddc080e7          	jalr	-548(ra) # 80004632 <argfd>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004860:	02054363          	bltz	a0,80004886 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004864:	fd843503          	ld	a0,-40(s0)
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	e32080e7          	jalr	-462(ra) # 8000469a <fdalloc>
    80004870:	84aa                	mv	s1,a0
    return -1;
    80004872:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004874:	00054963          	bltz	a0,80004886 <sys_dup+0x42>
  filedup(f);
    80004878:	fd843503          	ld	a0,-40(s0)
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	37a080e7          	jalr	890(ra) # 80003bf6 <filedup>
  return fd;
    80004884:	87a6                	mv	a5,s1
}
    80004886:	853e                	mv	a0,a5
    80004888:	70a2                	ld	ra,40(sp)
    8000488a:	7402                	ld	s0,32(sp)
    8000488c:	64e2                	ld	s1,24(sp)
    8000488e:	6145                	addi	sp,sp,48
    80004890:	8082                	ret

0000000080004892 <sys_read>:
{
    80004892:	7179                	addi	sp,sp,-48
    80004894:	f406                	sd	ra,40(sp)
    80004896:	f022                	sd	s0,32(sp)
    80004898:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000489a:	fe840613          	addi	a2,s0,-24
    8000489e:	4581                	li	a1,0
    800048a0:	4501                	li	a0,0
    800048a2:	00000097          	auipc	ra,0x0
    800048a6:	d90080e7          	jalr	-624(ra) # 80004632 <argfd>
    return -1;
    800048aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ac:	04054163          	bltz	a0,800048ee <sys_read+0x5c>
    800048b0:	fe440593          	addi	a1,s0,-28
    800048b4:	4509                	li	a0,2
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	982080e7          	jalr	-1662(ra) # 80002238 <argint>
    return -1;
    800048be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c0:	02054763          	bltz	a0,800048ee <sys_read+0x5c>
    800048c4:	fd840593          	addi	a1,s0,-40
    800048c8:	4505                	li	a0,1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	990080e7          	jalr	-1648(ra) # 8000225a <argaddr>
    return -1;
    800048d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d4:	00054d63          	bltz	a0,800048ee <sys_read+0x5c>
  return fileread(f, p, n);
    800048d8:	fe442603          	lw	a2,-28(s0)
    800048dc:	fd843583          	ld	a1,-40(s0)
    800048e0:	fe843503          	ld	a0,-24(s0)
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	49e080e7          	jalr	1182(ra) # 80003d82 <fileread>
    800048ec:	87aa                	mv	a5,a0
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	70a2                	ld	ra,40(sp)
    800048f2:	7402                	ld	s0,32(sp)
    800048f4:	6145                	addi	sp,sp,48
    800048f6:	8082                	ret

00000000800048f8 <sys_write>:
{
    800048f8:	7179                	addi	sp,sp,-48
    800048fa:	f406                	sd	ra,40(sp)
    800048fc:	f022                	sd	s0,32(sp)
    800048fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004900:	fe840613          	addi	a2,s0,-24
    80004904:	4581                	li	a1,0
    80004906:	4501                	li	a0,0
    80004908:	00000097          	auipc	ra,0x0
    8000490c:	d2a080e7          	jalr	-726(ra) # 80004632 <argfd>
    return -1;
    80004910:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004912:	04054163          	bltz	a0,80004954 <sys_write+0x5c>
    80004916:	fe440593          	addi	a1,s0,-28
    8000491a:	4509                	li	a0,2
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	91c080e7          	jalr	-1764(ra) # 80002238 <argint>
    return -1;
    80004924:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004926:	02054763          	bltz	a0,80004954 <sys_write+0x5c>
    8000492a:	fd840593          	addi	a1,s0,-40
    8000492e:	4505                	li	a0,1
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	92a080e7          	jalr	-1750(ra) # 8000225a <argaddr>
    return -1;
    80004938:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493a:	00054d63          	bltz	a0,80004954 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000493e:	fe442603          	lw	a2,-28(s0)
    80004942:	fd843583          	ld	a1,-40(s0)
    80004946:	fe843503          	ld	a0,-24(s0)
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	4fa080e7          	jalr	1274(ra) # 80003e44 <filewrite>
    80004952:	87aa                	mv	a5,a0
}
    80004954:	853e                	mv	a0,a5
    80004956:	70a2                	ld	ra,40(sp)
    80004958:	7402                	ld	s0,32(sp)
    8000495a:	6145                	addi	sp,sp,48
    8000495c:	8082                	ret

000000008000495e <sys_close>:
{
    8000495e:	1101                	addi	sp,sp,-32
    80004960:	ec06                	sd	ra,24(sp)
    80004962:	e822                	sd	s0,16(sp)
    80004964:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004966:	fe040613          	addi	a2,s0,-32
    8000496a:	fec40593          	addi	a1,s0,-20
    8000496e:	4501                	li	a0,0
    80004970:	00000097          	auipc	ra,0x0
    80004974:	cc2080e7          	jalr	-830(ra) # 80004632 <argfd>
    return -1;
    80004978:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000497a:	02054463          	bltz	a0,800049a2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000497e:	ffffc097          	auipc	ra,0xffffc
    80004982:	4ac080e7          	jalr	1196(ra) # 80000e2a <myproc>
    80004986:	fec42783          	lw	a5,-20(s0)
    8000498a:	07e9                	addi	a5,a5,26
    8000498c:	078e                	slli	a5,a5,0x3
    8000498e:	97aa                	add	a5,a5,a0
    80004990:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004994:	fe043503          	ld	a0,-32(s0)
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	2b0080e7          	jalr	688(ra) # 80003c48 <fileclose>
  return 0;
    800049a0:	4781                	li	a5,0
}
    800049a2:	853e                	mv	a0,a5
    800049a4:	60e2                	ld	ra,24(sp)
    800049a6:	6442                	ld	s0,16(sp)
    800049a8:	6105                	addi	sp,sp,32
    800049aa:	8082                	ret

00000000800049ac <sys_fstat>:
{
    800049ac:	1101                	addi	sp,sp,-32
    800049ae:	ec06                	sd	ra,24(sp)
    800049b0:	e822                	sd	s0,16(sp)
    800049b2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049b4:	fe840613          	addi	a2,s0,-24
    800049b8:	4581                	li	a1,0
    800049ba:	4501                	li	a0,0
    800049bc:	00000097          	auipc	ra,0x0
    800049c0:	c76080e7          	jalr	-906(ra) # 80004632 <argfd>
    return -1;
    800049c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049c6:	02054563          	bltz	a0,800049f0 <sys_fstat+0x44>
    800049ca:	fe040593          	addi	a1,s0,-32
    800049ce:	4505                	li	a0,1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	88a080e7          	jalr	-1910(ra) # 8000225a <argaddr>
    return -1;
    800049d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049da:	00054b63          	bltz	a0,800049f0 <sys_fstat+0x44>
  return filestat(f, st);
    800049de:	fe043583          	ld	a1,-32(s0)
    800049e2:	fe843503          	ld	a0,-24(s0)
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	32a080e7          	jalr	810(ra) # 80003d10 <filestat>
    800049ee:	87aa                	mv	a5,a0
}
    800049f0:	853e                	mv	a0,a5
    800049f2:	60e2                	ld	ra,24(sp)
    800049f4:	6442                	ld	s0,16(sp)
    800049f6:	6105                	addi	sp,sp,32
    800049f8:	8082                	ret

00000000800049fa <sys_link>:
{
    800049fa:	7169                	addi	sp,sp,-304
    800049fc:	f606                	sd	ra,296(sp)
    800049fe:	f222                	sd	s0,288(sp)
    80004a00:	ee26                	sd	s1,280(sp)
    80004a02:	ea4a                	sd	s2,272(sp)
    80004a04:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a06:	08000613          	li	a2,128
    80004a0a:	ed040593          	addi	a1,s0,-304
    80004a0e:	4501                	li	a0,0
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	86c080e7          	jalr	-1940(ra) # 8000227c <argstr>
    return -1;
    80004a18:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a1a:	10054e63          	bltz	a0,80004b36 <sys_link+0x13c>
    80004a1e:	08000613          	li	a2,128
    80004a22:	f5040593          	addi	a1,s0,-176
    80004a26:	4505                	li	a0,1
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	854080e7          	jalr	-1964(ra) # 8000227c <argstr>
    return -1;
    80004a30:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a32:	10054263          	bltz	a0,80004b36 <sys_link+0x13c>
  begin_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	d46080e7          	jalr	-698(ra) # 8000377c <begin_op>
  if((ip = namei(old)) == 0){
    80004a3e:	ed040513          	addi	a0,s0,-304
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	b1e080e7          	jalr	-1250(ra) # 80003560 <namei>
    80004a4a:	84aa                	mv	s1,a0
    80004a4c:	c551                	beqz	a0,80004ad8 <sys_link+0xde>
  ilock(ip);
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	35c080e7          	jalr	860(ra) # 80002daa <ilock>
  if(ip->type == T_DIR){
    80004a56:	04449703          	lh	a4,68(s1)
    80004a5a:	4785                	li	a5,1
    80004a5c:	08f70463          	beq	a4,a5,80004ae4 <sys_link+0xea>
  ip->nlink++;
    80004a60:	04a4d783          	lhu	a5,74(s1)
    80004a64:	2785                	addiw	a5,a5,1
    80004a66:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	274080e7          	jalr	628(ra) # 80002ce0 <iupdate>
  iunlock(ip);
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	3f6080e7          	jalr	1014(ra) # 80002e6c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a7e:	fd040593          	addi	a1,s0,-48
    80004a82:	f5040513          	addi	a0,s0,-176
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	af8080e7          	jalr	-1288(ra) # 8000357e <nameiparent>
    80004a8e:	892a                	mv	s2,a0
    80004a90:	c935                	beqz	a0,80004b04 <sys_link+0x10a>
  ilock(dp);
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	318080e7          	jalr	792(ra) # 80002daa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a9a:	00092703          	lw	a4,0(s2)
    80004a9e:	409c                	lw	a5,0(s1)
    80004aa0:	04f71d63          	bne	a4,a5,80004afa <sys_link+0x100>
    80004aa4:	40d0                	lw	a2,4(s1)
    80004aa6:	fd040593          	addi	a1,s0,-48
    80004aaa:	854a                	mv	a0,s2
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	9f2080e7          	jalr	-1550(ra) # 8000349e <dirlink>
    80004ab4:	04054363          	bltz	a0,80004afa <sys_link+0x100>
  iunlockput(dp);
    80004ab8:	854a                	mv	a0,s2
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	552080e7          	jalr	1362(ra) # 8000300c <iunlockput>
  iput(ip);
    80004ac2:	8526                	mv	a0,s1
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	4a0080e7          	jalr	1184(ra) # 80002f64 <iput>
  end_op();
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	d30080e7          	jalr	-720(ra) # 800037fc <end_op>
  return 0;
    80004ad4:	4781                	li	a5,0
    80004ad6:	a085                	j	80004b36 <sys_link+0x13c>
    end_op();
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	d24080e7          	jalr	-732(ra) # 800037fc <end_op>
    return -1;
    80004ae0:	57fd                	li	a5,-1
    80004ae2:	a891                	j	80004b36 <sys_link+0x13c>
    iunlockput(ip);
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	526080e7          	jalr	1318(ra) # 8000300c <iunlockput>
    end_op();
    80004aee:	fffff097          	auipc	ra,0xfffff
    80004af2:	d0e080e7          	jalr	-754(ra) # 800037fc <end_op>
    return -1;
    80004af6:	57fd                	li	a5,-1
    80004af8:	a83d                	j	80004b36 <sys_link+0x13c>
    iunlockput(dp);
    80004afa:	854a                	mv	a0,s2
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	510080e7          	jalr	1296(ra) # 8000300c <iunlockput>
  ilock(ip);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	2a4080e7          	jalr	676(ra) # 80002daa <ilock>
  ip->nlink--;
    80004b0e:	04a4d783          	lhu	a5,74(s1)
    80004b12:	37fd                	addiw	a5,a5,-1
    80004b14:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	1c6080e7          	jalr	454(ra) # 80002ce0 <iupdate>
  iunlockput(ip);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	4e8080e7          	jalr	1256(ra) # 8000300c <iunlockput>
  end_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	cd0080e7          	jalr	-816(ra) # 800037fc <end_op>
  return -1;
    80004b34:	57fd                	li	a5,-1
}
    80004b36:	853e                	mv	a0,a5
    80004b38:	70b2                	ld	ra,296(sp)
    80004b3a:	7412                	ld	s0,288(sp)
    80004b3c:	64f2                	ld	s1,280(sp)
    80004b3e:	6952                	ld	s2,272(sp)
    80004b40:	6155                	addi	sp,sp,304
    80004b42:	8082                	ret

0000000080004b44 <sys_unlink>:
{
    80004b44:	7151                	addi	sp,sp,-240
    80004b46:	f586                	sd	ra,232(sp)
    80004b48:	f1a2                	sd	s0,224(sp)
    80004b4a:	eda6                	sd	s1,216(sp)
    80004b4c:	e9ca                	sd	s2,208(sp)
    80004b4e:	e5ce                	sd	s3,200(sp)
    80004b50:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b52:	08000613          	li	a2,128
    80004b56:	f3040593          	addi	a1,s0,-208
    80004b5a:	4501                	li	a0,0
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	720080e7          	jalr	1824(ra) # 8000227c <argstr>
    80004b64:	18054163          	bltz	a0,80004ce6 <sys_unlink+0x1a2>
  begin_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	c14080e7          	jalr	-1004(ra) # 8000377c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b70:	fb040593          	addi	a1,s0,-80
    80004b74:	f3040513          	addi	a0,s0,-208
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	a06080e7          	jalr	-1530(ra) # 8000357e <nameiparent>
    80004b80:	84aa                	mv	s1,a0
    80004b82:	c979                	beqz	a0,80004c58 <sys_unlink+0x114>
  ilock(dp);
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	226080e7          	jalr	550(ra) # 80002daa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b8c:	00004597          	auipc	a1,0x4
    80004b90:	ae458593          	addi	a1,a1,-1308 # 80008670 <syscalls+0x2c0>
    80004b94:	fb040513          	addi	a0,s0,-80
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	6dc080e7          	jalr	1756(ra) # 80003274 <namecmp>
    80004ba0:	14050a63          	beqz	a0,80004cf4 <sys_unlink+0x1b0>
    80004ba4:	00004597          	auipc	a1,0x4
    80004ba8:	ad458593          	addi	a1,a1,-1324 # 80008678 <syscalls+0x2c8>
    80004bac:	fb040513          	addi	a0,s0,-80
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	6c4080e7          	jalr	1732(ra) # 80003274 <namecmp>
    80004bb8:	12050e63          	beqz	a0,80004cf4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bbc:	f2c40613          	addi	a2,s0,-212
    80004bc0:	fb040593          	addi	a1,s0,-80
    80004bc4:	8526                	mv	a0,s1
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	6c8080e7          	jalr	1736(ra) # 8000328e <dirlookup>
    80004bce:	892a                	mv	s2,a0
    80004bd0:	12050263          	beqz	a0,80004cf4 <sys_unlink+0x1b0>
  ilock(ip);
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	1d6080e7          	jalr	470(ra) # 80002daa <ilock>
  if(ip->nlink < 1)
    80004bdc:	04a91783          	lh	a5,74(s2)
    80004be0:	08f05263          	blez	a5,80004c64 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004be4:	04491703          	lh	a4,68(s2)
    80004be8:	4785                	li	a5,1
    80004bea:	08f70563          	beq	a4,a5,80004c74 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bee:	4641                	li	a2,16
    80004bf0:	4581                	li	a1,0
    80004bf2:	fc040513          	addi	a0,s0,-64
    80004bf6:	ffffb097          	auipc	ra,0xffffb
    80004bfa:	582080e7          	jalr	1410(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bfe:	4741                	li	a4,16
    80004c00:	f2c42683          	lw	a3,-212(s0)
    80004c04:	fc040613          	addi	a2,s0,-64
    80004c08:	4581                	li	a1,0
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	54a080e7          	jalr	1354(ra) # 80003156 <writei>
    80004c14:	47c1                	li	a5,16
    80004c16:	0af51563          	bne	a0,a5,80004cc0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c1a:	04491703          	lh	a4,68(s2)
    80004c1e:	4785                	li	a5,1
    80004c20:	0af70863          	beq	a4,a5,80004cd0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	3e6080e7          	jalr	998(ra) # 8000300c <iunlockput>
  ip->nlink--;
    80004c2e:	04a95783          	lhu	a5,74(s2)
    80004c32:	37fd                	addiw	a5,a5,-1
    80004c34:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c38:	854a                	mv	a0,s2
    80004c3a:	ffffe097          	auipc	ra,0xffffe
    80004c3e:	0a6080e7          	jalr	166(ra) # 80002ce0 <iupdate>
  iunlockput(ip);
    80004c42:	854a                	mv	a0,s2
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	3c8080e7          	jalr	968(ra) # 8000300c <iunlockput>
  end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	bb0080e7          	jalr	-1104(ra) # 800037fc <end_op>
  return 0;
    80004c54:	4501                	li	a0,0
    80004c56:	a84d                	j	80004d08 <sys_unlink+0x1c4>
    end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	ba4080e7          	jalr	-1116(ra) # 800037fc <end_op>
    return -1;
    80004c60:	557d                	li	a0,-1
    80004c62:	a05d                	j	80004d08 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c64:	00004517          	auipc	a0,0x4
    80004c68:	a3c50513          	addi	a0,a0,-1476 # 800086a0 <syscalls+0x2f0>
    80004c6c:	00001097          	auipc	ra,0x1
    80004c70:	62c080e7          	jalr	1580(ra) # 80006298 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c74:	04c92703          	lw	a4,76(s2)
    80004c78:	02000793          	li	a5,32
    80004c7c:	f6e7f9e3          	bgeu	a5,a4,80004bee <sys_unlink+0xaa>
    80004c80:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c84:	4741                	li	a4,16
    80004c86:	86ce                	mv	a3,s3
    80004c88:	f1840613          	addi	a2,s0,-232
    80004c8c:	4581                	li	a1,0
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	3ce080e7          	jalr	974(ra) # 8000305e <readi>
    80004c98:	47c1                	li	a5,16
    80004c9a:	00f51b63          	bne	a0,a5,80004cb0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c9e:	f1845783          	lhu	a5,-232(s0)
    80004ca2:	e7a1                	bnez	a5,80004cea <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ca4:	29c1                	addiw	s3,s3,16
    80004ca6:	04c92783          	lw	a5,76(s2)
    80004caa:	fcf9ede3          	bltu	s3,a5,80004c84 <sys_unlink+0x140>
    80004cae:	b781                	j	80004bee <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cb0:	00004517          	auipc	a0,0x4
    80004cb4:	a0850513          	addi	a0,a0,-1528 # 800086b8 <syscalls+0x308>
    80004cb8:	00001097          	auipc	ra,0x1
    80004cbc:	5e0080e7          	jalr	1504(ra) # 80006298 <panic>
    panic("unlink: writei");
    80004cc0:	00004517          	auipc	a0,0x4
    80004cc4:	a1050513          	addi	a0,a0,-1520 # 800086d0 <syscalls+0x320>
    80004cc8:	00001097          	auipc	ra,0x1
    80004ccc:	5d0080e7          	jalr	1488(ra) # 80006298 <panic>
    dp->nlink--;
    80004cd0:	04a4d783          	lhu	a5,74(s1)
    80004cd4:	37fd                	addiw	a5,a5,-1
    80004cd6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cda:	8526                	mv	a0,s1
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	004080e7          	jalr	4(ra) # 80002ce0 <iupdate>
    80004ce4:	b781                	j	80004c24 <sys_unlink+0xe0>
    return -1;
    80004ce6:	557d                	li	a0,-1
    80004ce8:	a005                	j	80004d08 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cea:	854a                	mv	a0,s2
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	320080e7          	jalr	800(ra) # 8000300c <iunlockput>
  iunlockput(dp);
    80004cf4:	8526                	mv	a0,s1
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	316080e7          	jalr	790(ra) # 8000300c <iunlockput>
  end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	afe080e7          	jalr	-1282(ra) # 800037fc <end_op>
  return -1;
    80004d06:	557d                	li	a0,-1
}
    80004d08:	70ae                	ld	ra,232(sp)
    80004d0a:	740e                	ld	s0,224(sp)
    80004d0c:	64ee                	ld	s1,216(sp)
    80004d0e:	694e                	ld	s2,208(sp)
    80004d10:	69ae                	ld	s3,200(sp)
    80004d12:	616d                	addi	sp,sp,240
    80004d14:	8082                	ret

0000000080004d16 <sys_open>:

uint64
sys_open(void)
{
    80004d16:	7131                	addi	sp,sp,-192
    80004d18:	fd06                	sd	ra,184(sp)
    80004d1a:	f922                	sd	s0,176(sp)
    80004d1c:	f526                	sd	s1,168(sp)
    80004d1e:	f14a                	sd	s2,160(sp)
    80004d20:	ed4e                	sd	s3,152(sp)
    80004d22:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d24:	08000613          	li	a2,128
    80004d28:	f5040593          	addi	a1,s0,-176
    80004d2c:	4501                	li	a0,0
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	54e080e7          	jalr	1358(ra) # 8000227c <argstr>
    return -1;
    80004d36:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d38:	0c054163          	bltz	a0,80004dfa <sys_open+0xe4>
    80004d3c:	f4c40593          	addi	a1,s0,-180
    80004d40:	4505                	li	a0,1
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	4f6080e7          	jalr	1270(ra) # 80002238 <argint>
    80004d4a:	0a054863          	bltz	a0,80004dfa <sys_open+0xe4>

  begin_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	a2e080e7          	jalr	-1490(ra) # 8000377c <begin_op>

  if(omode & O_CREATE){
    80004d56:	f4c42783          	lw	a5,-180(s0)
    80004d5a:	2007f793          	andi	a5,a5,512
    80004d5e:	cbdd                	beqz	a5,80004e14 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d60:	4681                	li	a3,0
    80004d62:	4601                	li	a2,0
    80004d64:	4589                	li	a1,2
    80004d66:	f5040513          	addi	a0,s0,-176
    80004d6a:	00000097          	auipc	ra,0x0
    80004d6e:	972080e7          	jalr	-1678(ra) # 800046dc <create>
    80004d72:	892a                	mv	s2,a0
    if(ip == 0){
    80004d74:	c959                	beqz	a0,80004e0a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d76:	04491703          	lh	a4,68(s2)
    80004d7a:	478d                	li	a5,3
    80004d7c:	00f71763          	bne	a4,a5,80004d8a <sys_open+0x74>
    80004d80:	04695703          	lhu	a4,70(s2)
    80004d84:	47a5                	li	a5,9
    80004d86:	0ce7ec63          	bltu	a5,a4,80004e5e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	e02080e7          	jalr	-510(ra) # 80003b8c <filealloc>
    80004d92:	89aa                	mv	s3,a0
    80004d94:	10050263          	beqz	a0,80004e98 <sys_open+0x182>
    80004d98:	00000097          	auipc	ra,0x0
    80004d9c:	902080e7          	jalr	-1790(ra) # 8000469a <fdalloc>
    80004da0:	84aa                	mv	s1,a0
    80004da2:	0e054663          	bltz	a0,80004e8e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004da6:	04491703          	lh	a4,68(s2)
    80004daa:	478d                	li	a5,3
    80004dac:	0cf70463          	beq	a4,a5,80004e74 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004db0:	4789                	li	a5,2
    80004db2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004db6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dba:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dbe:	f4c42783          	lw	a5,-180(s0)
    80004dc2:	0017c713          	xori	a4,a5,1
    80004dc6:	8b05                	andi	a4,a4,1
    80004dc8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dcc:	0037f713          	andi	a4,a5,3
    80004dd0:	00e03733          	snez	a4,a4
    80004dd4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dd8:	4007f793          	andi	a5,a5,1024
    80004ddc:	c791                	beqz	a5,80004de8 <sys_open+0xd2>
    80004dde:	04491703          	lh	a4,68(s2)
    80004de2:	4789                	li	a5,2
    80004de4:	08f70f63          	beq	a4,a5,80004e82 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004de8:	854a                	mv	a0,s2
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	082080e7          	jalr	130(ra) # 80002e6c <iunlock>
  end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	a0a080e7          	jalr	-1526(ra) # 800037fc <end_op>

  return fd;
}
    80004dfa:	8526                	mv	a0,s1
    80004dfc:	70ea                	ld	ra,184(sp)
    80004dfe:	744a                	ld	s0,176(sp)
    80004e00:	74aa                	ld	s1,168(sp)
    80004e02:	790a                	ld	s2,160(sp)
    80004e04:	69ea                	ld	s3,152(sp)
    80004e06:	6129                	addi	sp,sp,192
    80004e08:	8082                	ret
      end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	9f2080e7          	jalr	-1550(ra) # 800037fc <end_op>
      return -1;
    80004e12:	b7e5                	j	80004dfa <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e14:	f5040513          	addi	a0,s0,-176
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	748080e7          	jalr	1864(ra) # 80003560 <namei>
    80004e20:	892a                	mv	s2,a0
    80004e22:	c905                	beqz	a0,80004e52 <sys_open+0x13c>
    ilock(ip);
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	f86080e7          	jalr	-122(ra) # 80002daa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e2c:	04491703          	lh	a4,68(s2)
    80004e30:	4785                	li	a5,1
    80004e32:	f4f712e3          	bne	a4,a5,80004d76 <sys_open+0x60>
    80004e36:	f4c42783          	lw	a5,-180(s0)
    80004e3a:	dba1                	beqz	a5,80004d8a <sys_open+0x74>
      iunlockput(ip);
    80004e3c:	854a                	mv	a0,s2
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	1ce080e7          	jalr	462(ra) # 8000300c <iunlockput>
      end_op();
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	9b6080e7          	jalr	-1610(ra) # 800037fc <end_op>
      return -1;
    80004e4e:	54fd                	li	s1,-1
    80004e50:	b76d                	j	80004dfa <sys_open+0xe4>
      end_op();
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	9aa080e7          	jalr	-1622(ra) # 800037fc <end_op>
      return -1;
    80004e5a:	54fd                	li	s1,-1
    80004e5c:	bf79                	j	80004dfa <sys_open+0xe4>
    iunlockput(ip);
    80004e5e:	854a                	mv	a0,s2
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	1ac080e7          	jalr	428(ra) # 8000300c <iunlockput>
    end_op();
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	994080e7          	jalr	-1644(ra) # 800037fc <end_op>
    return -1;
    80004e70:	54fd                	li	s1,-1
    80004e72:	b761                	j	80004dfa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e74:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e78:	04691783          	lh	a5,70(s2)
    80004e7c:	02f99223          	sh	a5,36(s3)
    80004e80:	bf2d                	j	80004dba <sys_open+0xa4>
    itrunc(ip);
    80004e82:	854a                	mv	a0,s2
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	034080e7          	jalr	52(ra) # 80002eb8 <itrunc>
    80004e8c:	bfb1                	j	80004de8 <sys_open+0xd2>
      fileclose(f);
    80004e8e:	854e                	mv	a0,s3
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	db8080e7          	jalr	-584(ra) # 80003c48 <fileclose>
    iunlockput(ip);
    80004e98:	854a                	mv	a0,s2
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	172080e7          	jalr	370(ra) # 8000300c <iunlockput>
    end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	95a080e7          	jalr	-1702(ra) # 800037fc <end_op>
    return -1;
    80004eaa:	54fd                	li	s1,-1
    80004eac:	b7b9                	j	80004dfa <sys_open+0xe4>

0000000080004eae <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eae:	7175                	addi	sp,sp,-144
    80004eb0:	e506                	sd	ra,136(sp)
    80004eb2:	e122                	sd	s0,128(sp)
    80004eb4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	8c6080e7          	jalr	-1850(ra) # 8000377c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ebe:	08000613          	li	a2,128
    80004ec2:	f7040593          	addi	a1,s0,-144
    80004ec6:	4501                	li	a0,0
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	3b4080e7          	jalr	948(ra) # 8000227c <argstr>
    80004ed0:	02054963          	bltz	a0,80004f02 <sys_mkdir+0x54>
    80004ed4:	4681                	li	a3,0
    80004ed6:	4601                	li	a2,0
    80004ed8:	4585                	li	a1,1
    80004eda:	f7040513          	addi	a0,s0,-144
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	7fe080e7          	jalr	2046(ra) # 800046dc <create>
    80004ee6:	cd11                	beqz	a0,80004f02 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	124080e7          	jalr	292(ra) # 8000300c <iunlockput>
  end_op();
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	90c080e7          	jalr	-1780(ra) # 800037fc <end_op>
  return 0;
    80004ef8:	4501                	li	a0,0
}
    80004efa:	60aa                	ld	ra,136(sp)
    80004efc:	640a                	ld	s0,128(sp)
    80004efe:	6149                	addi	sp,sp,144
    80004f00:	8082                	ret
    end_op();
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	8fa080e7          	jalr	-1798(ra) # 800037fc <end_op>
    return -1;
    80004f0a:	557d                	li	a0,-1
    80004f0c:	b7fd                	j	80004efa <sys_mkdir+0x4c>

0000000080004f0e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f0e:	7135                	addi	sp,sp,-160
    80004f10:	ed06                	sd	ra,152(sp)
    80004f12:	e922                	sd	s0,144(sp)
    80004f14:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	866080e7          	jalr	-1946(ra) # 8000377c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f1e:	08000613          	li	a2,128
    80004f22:	f7040593          	addi	a1,s0,-144
    80004f26:	4501                	li	a0,0
    80004f28:	ffffd097          	auipc	ra,0xffffd
    80004f2c:	354080e7          	jalr	852(ra) # 8000227c <argstr>
    80004f30:	04054a63          	bltz	a0,80004f84 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f34:	f6c40593          	addi	a1,s0,-148
    80004f38:	4505                	li	a0,1
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	2fe080e7          	jalr	766(ra) # 80002238 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f42:	04054163          	bltz	a0,80004f84 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f46:	f6840593          	addi	a1,s0,-152
    80004f4a:	4509                	li	a0,2
    80004f4c:	ffffd097          	auipc	ra,0xffffd
    80004f50:	2ec080e7          	jalr	748(ra) # 80002238 <argint>
     argint(1, &major) < 0 ||
    80004f54:	02054863          	bltz	a0,80004f84 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f58:	f6841683          	lh	a3,-152(s0)
    80004f5c:	f6c41603          	lh	a2,-148(s0)
    80004f60:	458d                	li	a1,3
    80004f62:	f7040513          	addi	a0,s0,-144
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	776080e7          	jalr	1910(ra) # 800046dc <create>
     argint(2, &minor) < 0 ||
    80004f6e:	c919                	beqz	a0,80004f84 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	09c080e7          	jalr	156(ra) # 8000300c <iunlockput>
  end_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	884080e7          	jalr	-1916(ra) # 800037fc <end_op>
  return 0;
    80004f80:	4501                	li	a0,0
    80004f82:	a031                	j	80004f8e <sys_mknod+0x80>
    end_op();
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	878080e7          	jalr	-1928(ra) # 800037fc <end_op>
    return -1;
    80004f8c:	557d                	li	a0,-1
}
    80004f8e:	60ea                	ld	ra,152(sp)
    80004f90:	644a                	ld	s0,144(sp)
    80004f92:	610d                	addi	sp,sp,160
    80004f94:	8082                	ret

0000000080004f96 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f96:	7135                	addi	sp,sp,-160
    80004f98:	ed06                	sd	ra,152(sp)
    80004f9a:	e922                	sd	s0,144(sp)
    80004f9c:	e526                	sd	s1,136(sp)
    80004f9e:	e14a                	sd	s2,128(sp)
    80004fa0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fa2:	ffffc097          	auipc	ra,0xffffc
    80004fa6:	e88080e7          	jalr	-376(ra) # 80000e2a <myproc>
    80004faa:	892a                	mv	s2,a0
  
  begin_op();
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	7d0080e7          	jalr	2000(ra) # 8000377c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fb4:	08000613          	li	a2,128
    80004fb8:	f6040593          	addi	a1,s0,-160
    80004fbc:	4501                	li	a0,0
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	2be080e7          	jalr	702(ra) # 8000227c <argstr>
    80004fc6:	04054b63          	bltz	a0,8000501c <sys_chdir+0x86>
    80004fca:	f6040513          	addi	a0,s0,-160
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	592080e7          	jalr	1426(ra) # 80003560 <namei>
    80004fd6:	84aa                	mv	s1,a0
    80004fd8:	c131                	beqz	a0,8000501c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	dd0080e7          	jalr	-560(ra) # 80002daa <ilock>
  if(ip->type != T_DIR){
    80004fe2:	04449703          	lh	a4,68(s1)
    80004fe6:	4785                	li	a5,1
    80004fe8:	04f71063          	bne	a4,a5,80005028 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fec:	8526                	mv	a0,s1
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	e7e080e7          	jalr	-386(ra) # 80002e6c <iunlock>
  iput(p->cwd);
    80004ff6:	15093503          	ld	a0,336(s2)
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	f6a080e7          	jalr	-150(ra) # 80002f64 <iput>
  end_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	7fa080e7          	jalr	2042(ra) # 800037fc <end_op>
  p->cwd = ip;
    8000500a:	14993823          	sd	s1,336(s2)
  return 0;
    8000500e:	4501                	li	a0,0
}
    80005010:	60ea                	ld	ra,152(sp)
    80005012:	644a                	ld	s0,144(sp)
    80005014:	64aa                	ld	s1,136(sp)
    80005016:	690a                	ld	s2,128(sp)
    80005018:	610d                	addi	sp,sp,160
    8000501a:	8082                	ret
    end_op();
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	7e0080e7          	jalr	2016(ra) # 800037fc <end_op>
    return -1;
    80005024:	557d                	li	a0,-1
    80005026:	b7ed                	j	80005010 <sys_chdir+0x7a>
    iunlockput(ip);
    80005028:	8526                	mv	a0,s1
    8000502a:	ffffe097          	auipc	ra,0xffffe
    8000502e:	fe2080e7          	jalr	-30(ra) # 8000300c <iunlockput>
    end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	7ca080e7          	jalr	1994(ra) # 800037fc <end_op>
    return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	bfd1                	j	80005010 <sys_chdir+0x7a>

000000008000503e <sys_exec>:

uint64
sys_exec(void)
{
    8000503e:	7145                	addi	sp,sp,-464
    80005040:	e786                	sd	ra,456(sp)
    80005042:	e3a2                	sd	s0,448(sp)
    80005044:	ff26                	sd	s1,440(sp)
    80005046:	fb4a                	sd	s2,432(sp)
    80005048:	f74e                	sd	s3,424(sp)
    8000504a:	f352                	sd	s4,416(sp)
    8000504c:	ef56                	sd	s5,408(sp)
    8000504e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005050:	08000613          	li	a2,128
    80005054:	f4040593          	addi	a1,s0,-192
    80005058:	4501                	li	a0,0
    8000505a:	ffffd097          	auipc	ra,0xffffd
    8000505e:	222080e7          	jalr	546(ra) # 8000227c <argstr>
    return -1;
    80005062:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005064:	0c054a63          	bltz	a0,80005138 <sys_exec+0xfa>
    80005068:	e3840593          	addi	a1,s0,-456
    8000506c:	4505                	li	a0,1
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	1ec080e7          	jalr	492(ra) # 8000225a <argaddr>
    80005076:	0c054163          	bltz	a0,80005138 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000507a:	10000613          	li	a2,256
    8000507e:	4581                	li	a1,0
    80005080:	e4040513          	addi	a0,s0,-448
    80005084:	ffffb097          	auipc	ra,0xffffb
    80005088:	0f4080e7          	jalr	244(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000508c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005090:	89a6                	mv	s3,s1
    80005092:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005094:	02000a13          	li	s4,32
    80005098:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000509c:	00391513          	slli	a0,s2,0x3
    800050a0:	e3040593          	addi	a1,s0,-464
    800050a4:	e3843783          	ld	a5,-456(s0)
    800050a8:	953e                	add	a0,a0,a5
    800050aa:	ffffd097          	auipc	ra,0xffffd
    800050ae:	0f4080e7          	jalr	244(ra) # 8000219e <fetchaddr>
    800050b2:	02054a63          	bltz	a0,800050e6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050b6:	e3043783          	ld	a5,-464(s0)
    800050ba:	c3b9                	beqz	a5,80005100 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	05c080e7          	jalr	92(ra) # 80000118 <kalloc>
    800050c4:	85aa                	mv	a1,a0
    800050c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050ca:	cd11                	beqz	a0,800050e6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050cc:	6605                	lui	a2,0x1
    800050ce:	e3043503          	ld	a0,-464(s0)
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	11e080e7          	jalr	286(ra) # 800021f0 <fetchstr>
    800050da:	00054663          	bltz	a0,800050e6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050de:	0905                	addi	s2,s2,1
    800050e0:	09a1                	addi	s3,s3,8
    800050e2:	fb491be3          	bne	s2,s4,80005098 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e6:	10048913          	addi	s2,s1,256
    800050ea:	6088                	ld	a0,0(s1)
    800050ec:	c529                	beqz	a0,80005136 <sys_exec+0xf8>
    kfree(argv[i]);
    800050ee:	ffffb097          	auipc	ra,0xffffb
    800050f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	04a1                	addi	s1,s1,8
    800050f8:	ff2499e3          	bne	s1,s2,800050ea <sys_exec+0xac>
  return -1;
    800050fc:	597d                	li	s2,-1
    800050fe:	a82d                	j	80005138 <sys_exec+0xfa>
      argv[i] = 0;
    80005100:	0a8e                	slli	s5,s5,0x3
    80005102:	fc040793          	addi	a5,s0,-64
    80005106:	9abe                	add	s5,s5,a5
    80005108:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000510c:	e4040593          	addi	a1,s0,-448
    80005110:	f4040513          	addi	a0,s0,-192
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	194080e7          	jalr	404(ra) # 800042a8 <exec>
    8000511c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000511e:	10048993          	addi	s3,s1,256
    80005122:	6088                	ld	a0,0(s1)
    80005124:	c911                	beqz	a0,80005138 <sys_exec+0xfa>
    kfree(argv[i]);
    80005126:	ffffb097          	auipc	ra,0xffffb
    8000512a:	ef6080e7          	jalr	-266(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000512e:	04a1                	addi	s1,s1,8
    80005130:	ff3499e3          	bne	s1,s3,80005122 <sys_exec+0xe4>
    80005134:	a011                	j	80005138 <sys_exec+0xfa>
  return -1;
    80005136:	597d                	li	s2,-1
}
    80005138:	854a                	mv	a0,s2
    8000513a:	60be                	ld	ra,456(sp)
    8000513c:	641e                	ld	s0,448(sp)
    8000513e:	74fa                	ld	s1,440(sp)
    80005140:	795a                	ld	s2,432(sp)
    80005142:	79ba                	ld	s3,424(sp)
    80005144:	7a1a                	ld	s4,416(sp)
    80005146:	6afa                	ld	s5,408(sp)
    80005148:	6179                	addi	sp,sp,464
    8000514a:	8082                	ret

000000008000514c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000514c:	7139                	addi	sp,sp,-64
    8000514e:	fc06                	sd	ra,56(sp)
    80005150:	f822                	sd	s0,48(sp)
    80005152:	f426                	sd	s1,40(sp)
    80005154:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005156:	ffffc097          	auipc	ra,0xffffc
    8000515a:	cd4080e7          	jalr	-812(ra) # 80000e2a <myproc>
    8000515e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005160:	fd840593          	addi	a1,s0,-40
    80005164:	4501                	li	a0,0
    80005166:	ffffd097          	auipc	ra,0xffffd
    8000516a:	0f4080e7          	jalr	244(ra) # 8000225a <argaddr>
    return -1;
    8000516e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005170:	0e054063          	bltz	a0,80005250 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005174:	fc840593          	addi	a1,s0,-56
    80005178:	fd040513          	addi	a0,s0,-48
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	dfc080e7          	jalr	-516(ra) # 80003f78 <pipealloc>
    return -1;
    80005184:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005186:	0c054563          	bltz	a0,80005250 <sys_pipe+0x104>
  fd0 = -1;
    8000518a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000518e:	fd043503          	ld	a0,-48(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	508080e7          	jalr	1288(ra) # 8000469a <fdalloc>
    8000519a:	fca42223          	sw	a0,-60(s0)
    8000519e:	08054c63          	bltz	a0,80005236 <sys_pipe+0xea>
    800051a2:	fc843503          	ld	a0,-56(s0)
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	4f4080e7          	jalr	1268(ra) # 8000469a <fdalloc>
    800051ae:	fca42023          	sw	a0,-64(s0)
    800051b2:	06054863          	bltz	a0,80005222 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b6:	4691                	li	a3,4
    800051b8:	fc440613          	addi	a2,s0,-60
    800051bc:	fd843583          	ld	a1,-40(s0)
    800051c0:	68a8                	ld	a0,80(s1)
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	92a080e7          	jalr	-1750(ra) # 80000aec <copyout>
    800051ca:	02054063          	bltz	a0,800051ea <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051ce:	4691                	li	a3,4
    800051d0:	fc040613          	addi	a2,s0,-64
    800051d4:	fd843583          	ld	a1,-40(s0)
    800051d8:	0591                	addi	a1,a1,4
    800051da:	68a8                	ld	a0,80(s1)
    800051dc:	ffffc097          	auipc	ra,0xffffc
    800051e0:	910080e7          	jalr	-1776(ra) # 80000aec <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e6:	06055563          	bgez	a0,80005250 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051ea:	fc442783          	lw	a5,-60(s0)
    800051ee:	07e9                	addi	a5,a5,26
    800051f0:	078e                	slli	a5,a5,0x3
    800051f2:	97a6                	add	a5,a5,s1
    800051f4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051f8:	fc042503          	lw	a0,-64(s0)
    800051fc:	0569                	addi	a0,a0,26
    800051fe:	050e                	slli	a0,a0,0x3
    80005200:	9526                	add	a0,a0,s1
    80005202:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005206:	fd043503          	ld	a0,-48(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	a3e080e7          	jalr	-1474(ra) # 80003c48 <fileclose>
    fileclose(wf);
    80005212:	fc843503          	ld	a0,-56(s0)
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	a32080e7          	jalr	-1486(ra) # 80003c48 <fileclose>
    return -1;
    8000521e:	57fd                	li	a5,-1
    80005220:	a805                	j	80005250 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005222:	fc442783          	lw	a5,-60(s0)
    80005226:	0007c863          	bltz	a5,80005236 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000522a:	01a78513          	addi	a0,a5,26
    8000522e:	050e                	slli	a0,a0,0x3
    80005230:	9526                	add	a0,a0,s1
    80005232:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005236:	fd043503          	ld	a0,-48(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	a0e080e7          	jalr	-1522(ra) # 80003c48 <fileclose>
    fileclose(wf);
    80005242:	fc843503          	ld	a0,-56(s0)
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	a02080e7          	jalr	-1534(ra) # 80003c48 <fileclose>
    return -1;
    8000524e:	57fd                	li	a5,-1
}
    80005250:	853e                	mv	a0,a5
    80005252:	70e2                	ld	ra,56(sp)
    80005254:	7442                	ld	s0,48(sp)
    80005256:	74a2                	ld	s1,40(sp)
    80005258:	6121                	addi	sp,sp,64
    8000525a:	8082                	ret

000000008000525c <sys_mmap>:

uint64
sys_mmap(void)
{
    8000525c:	7139                	addi	sp,sp,-64
    8000525e:	fc06                	sd	ra,56(sp)
    80005260:	f822                	sd	s0,48(sp)
    80005262:	f426                	sd	s1,40(sp)
    80005264:	0080                	addi	s0,sp,64
  uint64 addr;
  int len,prot,flags,offset;
  struct VMA* vma=0;
  struct file* f;
  struct proc* p;
  p = myproc();
    80005266:	ffffc097          	auipc	ra,0xffffc
    8000526a:	bc4080e7          	jalr	-1084(ra) # 80000e2a <myproc>
    8000526e:	84aa                	mv	s1,a0
  
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005270:	fd840593          	addi	a1,s0,-40
    80005274:	4501                	li	a0,0
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	fe4080e7          	jalr	-28(ra) # 8000225a <argaddr>
  {
    return -1;
    8000527e:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005280:	14054863          	bltz	a0,800053d0 <sys_mmap+0x174>
    80005284:	fd440593          	addi	a1,s0,-44
    80005288:	4505                	li	a0,1
    8000528a:	ffffd097          	auipc	ra,0xffffd
    8000528e:	fae080e7          	jalr	-82(ra) # 80002238 <argint>
    return -1;
    80005292:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    80005294:	12054e63          	bltz	a0,800053d0 <sys_mmap+0x174>
    80005298:	fd040593          	addi	a1,s0,-48
    8000529c:	4509                	li	a0,2
    8000529e:	ffffd097          	auipc	ra,0xffffd
    800052a2:	f9a080e7          	jalr	-102(ra) # 80002238 <argint>
    return -1;
    800052a6:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    800052a8:	12054463          	bltz	a0,800053d0 <sys_mmap+0x174>
    800052ac:	fcc40593          	addi	a1,s0,-52
    800052b0:	450d                	li	a0,3
    800052b2:	ffffd097          	auipc	ra,0xffffd
    800052b6:	f86080e7          	jalr	-122(ra) # 80002238 <argint>
    return -1;
    800052ba:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    800052bc:	10054a63          	bltz	a0,800053d0 <sys_mmap+0x174>
    800052c0:	fc040613          	addi	a2,s0,-64
    800052c4:	4581                	li	a1,0
    800052c6:	4511                	li	a0,4
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	36a080e7          	jalr	874(ra) # 80004632 <argfd>
    return -1;
    800052d0:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0||argint(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0)
    800052d2:	0e054f63          	bltz	a0,800053d0 <sys_mmap+0x174>
    800052d6:	fc840593          	addi	a1,s0,-56
    800052da:	4515                	li	a0,5
    800052dc:	ffffd097          	auipc	ra,0xffffd
    800052e0:	f5c080e7          	jalr	-164(ra) # 80002238 <argint>
    800052e4:	0e054c63          	bltz	a0,800053dc <sys_mmap+0x180>
  }
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) 
    800052e8:	fcc42883          	lw	a7,-52(s0)
    800052ec:	fff8869b          	addiw	a3,a7,-1
    800052f0:	4705                	li	a4,1
    return -1;
    800052f2:	57fd                	li	a5,-1
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) 
    800052f4:	0cd76e63          	bltu	a4,a3,800053d0 <sys_mmap+0x174>
  
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    800052f8:	4785                	li	a5,1
    800052fa:	02f88c63          	beq	a7,a5,80005332 <sys_mmap+0xd6>
    return -1;
  
  if(len<0||offset<0||offset%PGSIZE)
    800052fe:	fd442303          	lw	t1,-44(s0)
    80005302:	0c034f63          	bltz	t1,800053e0 <sys_mmap+0x184>
    80005306:	fc842e03          	lw	t3,-56(s0)
    8000530a:	0c0e4d63          	bltz	t3,800053e4 <sys_mmap+0x188>
    8000530e:	034e1713          	slli	a4,t3,0x34
    return -1;
    80005312:	57fd                	li	a5,-1
  if(len<0||offset<0||offset%PGSIZE)
    80005314:	ef55                	bnez	a4,800053d0 <sys_mmap+0x174>
    80005316:	16848793          	addi	a5,s1,360
    8000531a:	873e                	mv	a4,a5
  
  for(int i = 0;i<NVMA;i++)
    8000531c:	4601                	li	a2,0
    8000531e:	45c1                	li	a1,16
  {
    if(p->vma[i].addr == 0)
    80005320:	6314                	ld	a3,0(a4)
    80005322:	c29d                	beqz	a3,80005348 <sys_mmap+0xec>
  for(int i = 0;i<NVMA;i++)
    80005324:	2605                	addiw	a2,a2,1
    80005326:	02070713          	addi	a4,a4,32
    8000532a:	feb61be3          	bne	a2,a1,80005320 <sys_mmap+0xc4>
      break;
    }
  }

  if(vma==0)
    return -1;
    8000532e:	57fd                	li	a5,-1
    80005330:	a045                	j	800053d0 <sys_mmap+0x174>
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    80005332:	fc043783          	ld	a5,-64(s0)
    80005336:	0097c783          	lbu	a5,9(a5)
    8000533a:	f3f1                	bnez	a5,800052fe <sys_mmap+0xa2>
    8000533c:	fd042703          	lw	a4,-48(s0)
    80005340:	8b09                	andi	a4,a4,2
    return -1;
    80005342:	57fd                	li	a5,-1
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) 
    80005344:	df4d                	beqz	a4,800052fe <sys_mmap+0xa2>
    80005346:	a069                	j	800053d0 <sys_mmap+0x174>
  
  addr = TRAPFRAME - 10*PGSIZE;
    80005348:	010005b7          	lui	a1,0x1000
    8000534c:	15f5                	addi	a1,a1,-3
    8000534e:	05ba                	slli	a1,a1,0xe
    80005350:	fcb43c23          	sd	a1,-40(s0)
  for(int i=0;i<NVMA;i++)
    80005354:	36848513          	addi	a0,s1,872
  {
    if(p->vma[i].addr)
    {
       addr = max(p->vma[i].addr+p->vma[i].len,addr);
    80005358:	4805                	li	a6,1
    8000535a:	a031                	j	80005366 <sys_mmap+0x10a>
    8000535c:	86c2                	mv	a3,a6
  for(int i=0;i<NVMA;i++)
    8000535e:	02078793          	addi	a5,a5,32
    80005362:	00a78a63          	beq	a5,a0,80005376 <sys_mmap+0x11a>
    if(p->vma[i].addr)
    80005366:	6398                	ld	a4,0(a5)
    80005368:	db7d                	beqz	a4,8000535e <sys_mmap+0x102>
       addr = max(p->vma[i].addr+p->vma[i].len,addr);
    8000536a:	4794                	lw	a3,8(a5)
    8000536c:	9736                	add	a4,a4,a3
    8000536e:	fee5f7e3          	bgeu	a1,a4,8000535c <sys_mmap+0x100>
    80005372:	85ba                	mv	a1,a4
    80005374:	b7e5                	j	8000535c <sys_mmap+0x100>
    80005376:	c299                	beqz	a3,8000537c <sys_mmap+0x120>
    80005378:	fcb43c23          	sd	a1,-40(s0)
    }
  }

  addr = PGROUNDUP(addr);
    8000537c:	fd843703          	ld	a4,-40(s0)
    80005380:	6785                	lui	a5,0x1
    80005382:	17fd                	addi	a5,a5,-1
    80005384:	973e                	add	a4,a4,a5
    80005386:	77fd                	lui	a5,0xfffff
    80005388:	8f7d                	and	a4,a4,a5
    8000538a:	fce43c23          	sd	a4,-40(s0)
  if(addr + len >TRAPFRAME)
    8000538e:	00e305b3          	add	a1,t1,a4
    80005392:	020006b7          	lui	a3,0x2000
    80005396:	16fd                	addi	a3,a3,-1
    80005398:	06b6                	slli	a3,a3,0xd
    return -1;
    8000539a:	57fd                	li	a5,-1
  if(addr + len >TRAPFRAME)
    8000539c:	02b6ea63          	bltu	a3,a1,800053d0 <sys_mmap+0x174>
  
  vma->addr = addr;
    800053a0:	0616                	slli	a2,a2,0x5
    800053a2:	9626                	add	a2,a2,s1
    800053a4:	16e63423          	sd	a4,360(a2) # 1168 <_entry-0x7fffee98>
  vma->len = len;
    800053a8:	16662823          	sw	t1,368(a2)
  vma->prot = prot;
    800053ac:	fd042783          	lw	a5,-48(s0)
    800053b0:	16f62a23          	sw	a5,372(a2)
  vma->flags = flags;
    800053b4:	17162c23          	sw	a7,376(a2)
  vma->offset = offset;
    800053b8:	17c62e23          	sw	t3,380(a2)
  vma->f = f;
    800053bc:	fc043503          	ld	a0,-64(s0)
    800053c0:	18a63023          	sd	a0,384(a2)
  filedup(f);
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	832080e7          	jalr	-1998(ra) # 80003bf6 <filedup>
  return addr;
    800053cc:	fd843783          	ld	a5,-40(s0)
}
    800053d0:	853e                	mv	a0,a5
    800053d2:	70e2                	ld	ra,56(sp)
    800053d4:	7442                	ld	s0,48(sp)
    800053d6:	74a2                	ld	s1,40(sp)
    800053d8:	6121                	addi	sp,sp,64
    800053da:	8082                	ret
    return -1;
    800053dc:	57fd                	li	a5,-1
    800053de:	bfcd                	j	800053d0 <sys_mmap+0x174>
    return -1;
    800053e0:	57fd                	li	a5,-1
    800053e2:	b7fd                	j	800053d0 <sys_mmap+0x174>
    800053e4:	57fd                	li	a5,-1
    800053e6:	b7ed                	j	800053d0 <sys_mmap+0x174>

00000000800053e8 <sys_munmap>:

uint64
sys_munmap(void)
{
    800053e8:	7175                	addi	sp,sp,-144
    800053ea:	e506                	sd	ra,136(sp)
    800053ec:	e122                	sd	s0,128(sp)
    800053ee:	fca6                	sd	s1,120(sp)
    800053f0:	f8ca                	sd	s2,112(sp)
    800053f2:	f4ce                	sd	s3,104(sp)
    800053f4:	f0d2                	sd	s4,96(sp)
    800053f6:	ecd6                	sd	s5,88(sp)
    800053f8:	e8da                	sd	s6,80(sp)
    800053fa:	e4de                	sd	s7,72(sp)
    800053fc:	e0e2                	sd	s8,64(sp)
    800053fe:	fc66                	sd	s9,56(sp)
    80005400:	f86a                	sd	s10,48(sp)
    80005402:	f46e                	sd	s11,40(sp)
    80005404:	0900                	addi	s0,sp,144
  uint64 addr,va;
  int len;
  struct VMA* vma=0;
  struct proc* p = myproc();
    80005406:	ffffc097          	auipc	ra,0xffffc
    8000540a:	a24080e7          	jalr	-1500(ra) # 80000e2a <myproc>
    8000540e:	84aa                	mv	s1,a0
    80005410:	f6a43c23          	sd	a0,-136(s0)
  
  if(argaddr(0,&addr)<0||argint(1,&len)<0)
    80005414:	f8840593          	addi	a1,s0,-120
    80005418:	4501                	li	a0,0
    8000541a:	ffffd097          	auipc	ra,0xffffd
    8000541e:	e40080e7          	jalr	-448(ra) # 8000225a <argaddr>
    80005422:	26054563          	bltz	a0,8000568c <sys_munmap+0x2a4>
    80005426:	f8440593          	addi	a1,s0,-124
    8000542a:	4505                	li	a0,1
    8000542c:	ffffd097          	auipc	ra,0xffffd
    80005430:	e0c080e7          	jalr	-500(ra) # 80002238 <argint>
    80005434:	24054e63          	bltz	a0,80005690 <sys_munmap+0x2a8>
    return -1;
  
  if(addr%PGSIZE || len<0)
    80005438:	f8843983          	ld	s3,-120(s0)
    8000543c:	03499793          	slli	a5,s3,0x34
    80005440:	0347dd13          	srli	s10,a5,0x34
    80005444:	24079863          	bnez	a5,80005694 <sys_munmap+0x2ac>
    80005448:	f8442583          	lw	a1,-124(s0)
    8000544c:	2405c663          	bltz	a1,80005698 <sys_munmap+0x2b0>
    80005450:	16848793          	addi	a5,s1,360
    return -1;
  
  for(int i=0;i<NVMA;i++)
    80005454:	4481                	li	s1,0
    80005456:	4641                	li	a2,16
    80005458:	a031                	j	80005464 <sys_munmap+0x7c>
    8000545a:	2485                	addiw	s1,s1,1
    8000545c:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd0de0>
    80005460:	04c48363          	beq	s1,a2,800054a6 <sys_munmap+0xbe>
  {
    if(p->vma[i].addr && addr >= p->vma[i].addr && addr <= p->vma[i].addr+p->vma[i].len)
    80005464:	6398                	ld	a4,0(a5)
    80005466:	db75                	beqz	a4,8000545a <sys_munmap+0x72>
    80005468:	fee9e9e3          	bltu	s3,a4,8000545a <sys_munmap+0x72>
    8000546c:	4794                	lw	a3,8(a5)
    8000546e:	9736                	add	a4,a4,a3
    80005470:	ff3765e3          	bltu	a4,s3,8000545a <sys_munmap+0x72>
    }
  }
  if(vma==0)
    return -1;
  
  if(len==0)
    80005474:	c995                	beqz	a1,800054a8 <sys_munmap+0xc0>
    return 0;
  
  int maxsize;
  if(vma->flags & MAP_SHARED)
    80005476:	00549793          	slli	a5,s1,0x5
    8000547a:	f7843703          	ld	a4,-136(s0)
    8000547e:	97ba                	add	a5,a5,a4
    80005480:	1787a783          	lw	a5,376(a5)
    80005484:	8b85                	andi	a5,a5,1
    80005486:	12078f63          	beqz	a5,800055c4 <sys_munmap+0x1dc>
  {
    maxsize = ((MAXOPBLOCKS-4)/2)*BSIZE;
    for(va=addr;va<addr+len;va+=PGSIZE)
    8000548a:	95ce                	add	a1,a1,s3
    8000548c:	12b9fc63          	bgeu	s3,a1,800055c4 <sys_munmap+0x1dc>
      uint range,size;
      range = min(addr+len-va,PGSIZE);
      size = min(maxsize,range);
      for(int i=0;i<range;i+=size)
      {
        size=min(maxsize,range-i);
    80005490:	6785                	lui	a5,0x1
    80005492:	c0078d93          	addi	s11,a5,-1024 # c00 <_entry-0x7ffff400>
        begin_op();
        ilock(vma->f->ip);
    80005496:	00549b13          	slli	s6,s1,0x5
    8000549a:	9b3a                	add	s6,s6,a4
        if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size)
    8000549c:	00b48c93          	addi	s9,s1,11
    800054a0:	0c96                	slli	s9,s9,0x5
    800054a2:	9cba                	add	s9,s9,a4
    800054a4:	a8e1                	j	8000557c <sys_munmap+0x194>
    return -1;
    800054a6:	5d7d                	li	s10,-1
  else
  {
    panic("failed munmap");
  }
  return 0;
    800054a8:	856a                	mv	a0,s10
    800054aa:	60aa                	ld	ra,136(sp)
    800054ac:	640a                	ld	s0,128(sp)
    800054ae:	74e6                	ld	s1,120(sp)
    800054b0:	7946                	ld	s2,112(sp)
    800054b2:	79a6                	ld	s3,104(sp)
    800054b4:	7a06                	ld	s4,96(sp)
    800054b6:	6ae6                	ld	s5,88(sp)
    800054b8:	6b46                	ld	s6,80(sp)
    800054ba:	6ba6                	ld	s7,72(sp)
    800054bc:	6c06                	ld	s8,64(sp)
    800054be:	7ce2                	ld	s9,56(sp)
    800054c0:	7d42                	ld	s10,48(sp)
    800054c2:	7da2                	ld	s11,40(sp)
    800054c4:	6149                	addi	sp,sp,144
    800054c6:	8082                	ret
        size=min(maxsize,range-i);
    800054c8:	00090a1b          	sext.w	s4,s2
        begin_op();
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	2b0080e7          	jalr	688(ra) # 8000377c <begin_op>
        ilock(vma->f->ip);
    800054d4:	180b3783          	ld	a5,384(s6)
    800054d8:	6f88                	ld	a0,24(a5)
    800054da:	ffffe097          	auipc	ra,0xffffe
    800054de:	8d0080e7          	jalr	-1840(ra) # 80002daa <ilock>
        if(writei(vma->f->ip,1,va+i,va-vma->addr+vma->offset+i,size)!=size)
    800054e2:	008cb783          	ld	a5,8(s9)
    800054e6:	17cb2683          	lw	a3,380(s6)
    800054ea:	9e9d                	subw	a3,a3,a5
    800054ec:	013686bb          	addw	a3,a3,s3
    800054f0:	180b3783          	ld	a5,384(s6)
    800054f4:	8752                	mv	a4,s4
    800054f6:	015686bb          	addw	a3,a3,s5
    800054fa:	013c0633          	add	a2,s8,s3
    800054fe:	4585                	li	a1,1
    80005500:	6f88                	ld	a0,24(a5)
    80005502:	ffffe097          	auipc	ra,0xffffe
    80005506:	c54080e7          	jalr	-940(ra) # 80003156 <writei>
    8000550a:	2501                	sext.w	a0,a0
    8000550c:	03451d63          	bne	a0,s4,80005546 <sys_munmap+0x15e>
        iunlock(vma->f->ip);
    80005510:	180b3783          	ld	a5,384(s6)
    80005514:	6f88                	ld	a0,24(a5)
    80005516:	ffffe097          	auipc	ra,0xffffe
    8000551a:	956080e7          	jalr	-1706(ra) # 80002e6c <iunlock>
        end_op();
    8000551e:	ffffe097          	auipc	ra,0xffffe
    80005522:	2de080e7          	jalr	734(ra) # 800037fc <end_op>
      for(int i=0;i<range;i+=size)
    80005526:	0159093b          	addw	s2,s2,s5
    8000552a:	00090a9b          	sext.w	s5,s2
    8000552e:	8c56                	mv	s8,s5
    80005530:	037afd63          	bgeu	s5,s7,8000556a <sys_munmap+0x182>
        size=min(maxsize,range-i);
    80005534:	415b893b          	subw	s2,s7,s5
    80005538:	0009079b          	sext.w	a5,s2
    8000553c:	f8fdf6e3          	bgeu	s11,a5,800054c8 <sys_munmap+0xe0>
    80005540:	f7442903          	lw	s2,-140(s0)
    80005544:	b751                	j	800054c8 <sys_munmap+0xe0>
          iunlock(vma->f->ip);
    80005546:	0496                	slli	s1,s1,0x5
    80005548:	f7843783          	ld	a5,-136(s0)
    8000554c:	00978533          	add	a0,a5,s1
    80005550:	18053783          	ld	a5,384(a0)
    80005554:	6f88                	ld	a0,24(a5)
    80005556:	ffffe097          	auipc	ra,0xffffe
    8000555a:	916080e7          	jalr	-1770(ra) # 80002e6c <iunlock>
          end_op();
    8000555e:	ffffe097          	auipc	ra,0xffffe
    80005562:	29e080e7          	jalr	670(ra) # 800037fc <end_op>
          return -1;
    80005566:	5d7d                	li	s10,-1
    80005568:	b781                	j	800054a8 <sys_munmap+0xc0>
    for(va=addr;va<addr+len;va+=PGSIZE)
    8000556a:	6785                	lui	a5,0x1
    8000556c:	99be                	add	s3,s3,a5
    8000556e:	f8442783          	lw	a5,-124(s0)
    80005572:	f8843703          	ld	a4,-120(s0)
    80005576:	97ba                	add	a5,a5,a4
    80005578:	04f9f663          	bgeu	s3,a5,800055c4 <sys_munmap+0x1dc>
      pte_t* pte = walk(p->pagetable,va,0);
    8000557c:	4601                	li	a2,0
    8000557e:	85ce                	mv	a1,s3
    80005580:	f7843783          	ld	a5,-136(s0)
    80005584:	6ba8                	ld	a0,80(a5)
    80005586:	ffffb097          	auipc	ra,0xffffb
    8000558a:	eda080e7          	jalr	-294(ra) # 80000460 <walk>
      if(pte==0 || (*pte & PTE_D)==0)
    8000558e:	dd71                	beqz	a0,8000556a <sys_munmap+0x182>
    80005590:	611c                	ld	a5,0(a0)
    80005592:	0807f793          	andi	a5,a5,128
    80005596:	dbf1                	beqz	a5,8000556a <sys_munmap+0x182>
      range = min(addr+len-va,PGSIZE);
    80005598:	f8442b83          	lw	s7,-124(s0)
    8000559c:	f8843783          	ld	a5,-120(s0)
    800055a0:	9bbe                	add	s7,s7,a5
    800055a2:	413b8bb3          	sub	s7,s7,s3
    800055a6:	6785                	lui	a5,0x1
    800055a8:	0177f363          	bgeu	a5,s7,800055ae <sys_munmap+0x1c6>
    800055ac:	6b85                	lui	s7,0x1
    800055ae:	2b81                	sext.w	s7,s7
      for(int i=0;i<range;i+=size)
    800055b0:	fa0b8de3          	beqz	s7,8000556a <sys_munmap+0x182>
    800055b4:	4c01                	li	s8,0
    800055b6:	4a81                	li	s5,0
        size=min(maxsize,range-i);
    800055b8:	6785                	lui	a5,0x1
    800055ba:	c007879b          	addiw	a5,a5,-1024
    800055be:	f6f42a23          	sw	a5,-140(s0)
    800055c2:	bf8d                	j	80005534 <sys_munmap+0x14c>
  uvmunmap(p->pagetable,addr,(len-1)/PGSIZE+1,1);
    800055c4:	f8442603          	lw	a2,-124(s0)
    800055c8:	fff6079b          	addiw	a5,a2,-1
    800055cc:	41f7d61b          	sraiw	a2,a5,0x1f
    800055d0:	0146561b          	srliw	a2,a2,0x14
    800055d4:	9e3d                	addw	a2,a2,a5
    800055d6:	40c6561b          	sraiw	a2,a2,0xc
    800055da:	4685                	li	a3,1
    800055dc:	2605                	addiw	a2,a2,1
    800055de:	f8843583          	ld	a1,-120(s0)
    800055e2:	f7843903          	ld	s2,-136(s0)
    800055e6:	05093503          	ld	a0,80(s2)
    800055ea:	ffffb097          	auipc	ra,0xffffb
    800055ee:	124080e7          	jalr	292(ra) # 8000070e <uvmunmap>
  if(addr==vma->addr && len==vma->len)
    800055f2:	00549793          	slli	a5,s1,0x5
    800055f6:	97ca                	add	a5,a5,s2
    800055f8:	1687b703          	ld	a4,360(a5) # 1168 <_entry-0x7fffee98>
    800055fc:	f8843683          	ld	a3,-120(s0)
    80005600:	00d70e63          	beq	a4,a3,8000561c <sys_munmap+0x234>
  else if(addr+len==vma->addr+vma->len)
    80005604:	f8442583          	lw	a1,-124(s0)
    80005608:	1707a603          	lw	a2,368(a5)
    8000560c:	96ae                	add	a3,a3,a1
    8000560e:	9732                	add	a4,a4,a2
    80005610:	06e69663          	bne	a3,a4,8000567c <sys_munmap+0x294>
    vma->len-=len;
    80005614:	9e0d                	subw	a2,a2,a1
    80005616:	16c7a823          	sw	a2,368(a5)
    8000561a:	b579                	j	800054a8 <sys_munmap+0xc0>
  if(addr==vma->addr && len==vma->len)
    8000561c:	f8442683          	lw	a3,-124(s0)
    80005620:	1707a603          	lw	a2,368(a5)
    80005624:	02d60563          	beq	a2,a3,8000564e <sys_munmap+0x266>
    vma->addr += len;
    80005628:	9736                	add	a4,a4,a3
    8000562a:	16e7b423          	sd	a4,360(a5)
    vma->offset += len;
    8000562e:	0496                	slli	s1,s1,0x5
    80005630:	f7843703          	ld	a4,-136(s0)
    80005634:	94ba                	add	s1,s1,a4
    80005636:	17c4a703          	lw	a4,380(s1)
    8000563a:	9f35                	addw	a4,a4,a3
    8000563c:	16e4ae23          	sw	a4,380(s1)
    vma->len -= len;
    80005640:	1707a703          	lw	a4,368(a5)
    80005644:	40d706bb          	subw	a3,a4,a3
    80005648:	16d7a823          	sw	a3,368(a5)
    8000564c:	bdb1                	j	800054a8 <sys_munmap+0xc0>
    vma->addr = 0;
    8000564e:	1607b423          	sd	zero,360(a5)
    vma->len = 0;
    80005652:	1607a823          	sw	zero,368(a5)
    vma->offset = 0;
    80005656:	0496                	slli	s1,s1,0x5
    80005658:	f7843703          	ld	a4,-136(s0)
    8000565c:	94ba                	add	s1,s1,a4
    8000565e:	1604ae23          	sw	zero,380(s1)
    vma->flags = 0;
    80005662:	1604ac23          	sw	zero,376(s1)
    vma->prot = 0;
    80005666:	1607aa23          	sw	zero,372(a5)
    fileclose(vma->f);
    8000566a:	1804b503          	ld	a0,384(s1)
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	5da080e7          	jalr	1498(ra) # 80003c48 <fileclose>
    vma->f = 0;
    80005676:	1804b023          	sd	zero,384(s1)
    8000567a:	b53d                	j	800054a8 <sys_munmap+0xc0>
    panic("failed munmap");
    8000567c:	00003517          	auipc	a0,0x3
    80005680:	06450513          	addi	a0,a0,100 # 800086e0 <syscalls+0x330>
    80005684:	00001097          	auipc	ra,0x1
    80005688:	c14080e7          	jalr	-1004(ra) # 80006298 <panic>
    return -1;
    8000568c:	5d7d                	li	s10,-1
    8000568e:	bd29                	j	800054a8 <sys_munmap+0xc0>
    80005690:	5d7d                	li	s10,-1
    80005692:	bd19                	j	800054a8 <sys_munmap+0xc0>
    return -1;
    80005694:	5d7d                	li	s10,-1
    80005696:	bd09                	j	800054a8 <sys_munmap+0xc0>
    80005698:	5d7d                	li	s10,-1
    8000569a:	b539                	j	800054a8 <sys_munmap+0xc0>
    8000569c:	0000                	unimp
	...

00000000800056a0 <kernelvec>:
    800056a0:	7111                	addi	sp,sp,-256
    800056a2:	e006                	sd	ra,0(sp)
    800056a4:	e40a                	sd	sp,8(sp)
    800056a6:	e80e                	sd	gp,16(sp)
    800056a8:	ec12                	sd	tp,24(sp)
    800056aa:	f016                	sd	t0,32(sp)
    800056ac:	f41a                	sd	t1,40(sp)
    800056ae:	f81e                	sd	t2,48(sp)
    800056b0:	fc22                	sd	s0,56(sp)
    800056b2:	e0a6                	sd	s1,64(sp)
    800056b4:	e4aa                	sd	a0,72(sp)
    800056b6:	e8ae                	sd	a1,80(sp)
    800056b8:	ecb2                	sd	a2,88(sp)
    800056ba:	f0b6                	sd	a3,96(sp)
    800056bc:	f4ba                	sd	a4,104(sp)
    800056be:	f8be                	sd	a5,112(sp)
    800056c0:	fcc2                	sd	a6,120(sp)
    800056c2:	e146                	sd	a7,128(sp)
    800056c4:	e54a                	sd	s2,136(sp)
    800056c6:	e94e                	sd	s3,144(sp)
    800056c8:	ed52                	sd	s4,152(sp)
    800056ca:	f156                	sd	s5,160(sp)
    800056cc:	f55a                	sd	s6,168(sp)
    800056ce:	f95e                	sd	s7,176(sp)
    800056d0:	fd62                	sd	s8,184(sp)
    800056d2:	e1e6                	sd	s9,192(sp)
    800056d4:	e5ea                	sd	s10,200(sp)
    800056d6:	e9ee                	sd	s11,208(sp)
    800056d8:	edf2                	sd	t3,216(sp)
    800056da:	f1f6                	sd	t4,224(sp)
    800056dc:	f5fa                	sd	t5,232(sp)
    800056de:	f9fe                	sd	t6,240(sp)
    800056e0:	98bfc0ef          	jal	ra,8000206a <kerneltrap>
    800056e4:	6082                	ld	ra,0(sp)
    800056e6:	6122                	ld	sp,8(sp)
    800056e8:	61c2                	ld	gp,16(sp)
    800056ea:	7282                	ld	t0,32(sp)
    800056ec:	7322                	ld	t1,40(sp)
    800056ee:	73c2                	ld	t2,48(sp)
    800056f0:	7462                	ld	s0,56(sp)
    800056f2:	6486                	ld	s1,64(sp)
    800056f4:	6526                	ld	a0,72(sp)
    800056f6:	65c6                	ld	a1,80(sp)
    800056f8:	6666                	ld	a2,88(sp)
    800056fa:	7686                	ld	a3,96(sp)
    800056fc:	7726                	ld	a4,104(sp)
    800056fe:	77c6                	ld	a5,112(sp)
    80005700:	7866                	ld	a6,120(sp)
    80005702:	688a                	ld	a7,128(sp)
    80005704:	692a                	ld	s2,136(sp)
    80005706:	69ca                	ld	s3,144(sp)
    80005708:	6a6a                	ld	s4,152(sp)
    8000570a:	7a8a                	ld	s5,160(sp)
    8000570c:	7b2a                	ld	s6,168(sp)
    8000570e:	7bca                	ld	s7,176(sp)
    80005710:	7c6a                	ld	s8,184(sp)
    80005712:	6c8e                	ld	s9,192(sp)
    80005714:	6d2e                	ld	s10,200(sp)
    80005716:	6dce                	ld	s11,208(sp)
    80005718:	6e6e                	ld	t3,216(sp)
    8000571a:	7e8e                	ld	t4,224(sp)
    8000571c:	7f2e                	ld	t5,232(sp)
    8000571e:	7fce                	ld	t6,240(sp)
    80005720:	6111                	addi	sp,sp,256
    80005722:	10200073          	sret
    80005726:	00000013          	nop
    8000572a:	00000013          	nop
    8000572e:	0001                	nop

0000000080005730 <timervec>:
    80005730:	34051573          	csrrw	a0,mscratch,a0
    80005734:	e10c                	sd	a1,0(a0)
    80005736:	e510                	sd	a2,8(a0)
    80005738:	e914                	sd	a3,16(a0)
    8000573a:	6d0c                	ld	a1,24(a0)
    8000573c:	7110                	ld	a2,32(a0)
    8000573e:	6194                	ld	a3,0(a1)
    80005740:	96b2                	add	a3,a3,a2
    80005742:	e194                	sd	a3,0(a1)
    80005744:	4589                	li	a1,2
    80005746:	14459073          	csrw	sip,a1
    8000574a:	6914                	ld	a3,16(a0)
    8000574c:	6510                	ld	a2,8(a0)
    8000574e:	610c                	ld	a1,0(a0)
    80005750:	34051573          	csrrw	a0,mscratch,a0
    80005754:	30200073          	mret
	...

000000008000575a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000575a:	1141                	addi	sp,sp,-16
    8000575c:	e422                	sd	s0,8(sp)
    8000575e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005760:	0c0007b7          	lui	a5,0xc000
    80005764:	4705                	li	a4,1
    80005766:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005768:	c3d8                	sw	a4,4(a5)
}
    8000576a:	6422                	ld	s0,8(sp)
    8000576c:	0141                	addi	sp,sp,16
    8000576e:	8082                	ret

0000000080005770 <plicinithart>:

void
plicinithart(void)
{
    80005770:	1141                	addi	sp,sp,-16
    80005772:	e406                	sd	ra,8(sp)
    80005774:	e022                	sd	s0,0(sp)
    80005776:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005778:	ffffb097          	auipc	ra,0xffffb
    8000577c:	686080e7          	jalr	1670(ra) # 80000dfe <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005780:	0085171b          	slliw	a4,a0,0x8
    80005784:	0c0027b7          	lui	a5,0xc002
    80005788:	97ba                	add	a5,a5,a4
    8000578a:	40200713          	li	a4,1026
    8000578e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005792:	00d5151b          	slliw	a0,a0,0xd
    80005796:	0c2017b7          	lui	a5,0xc201
    8000579a:	953e                	add	a0,a0,a5
    8000579c:	00052023          	sw	zero,0(a0)
}
    800057a0:	60a2                	ld	ra,8(sp)
    800057a2:	6402                	ld	s0,0(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057b0:	ffffb097          	auipc	ra,0xffffb
    800057b4:	64e080e7          	jalr	1614(ra) # 80000dfe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800057b8:	00d5179b          	slliw	a5,a0,0xd
    800057bc:	0c201537          	lui	a0,0xc201
    800057c0:	953e                	add	a0,a0,a5
  return irq;
}
    800057c2:	4148                	lw	a0,4(a0)
    800057c4:	60a2                	ld	ra,8(sp)
    800057c6:	6402                	ld	s0,0(sp)
    800057c8:	0141                	addi	sp,sp,16
    800057ca:	8082                	ret

00000000800057cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800057cc:	1101                	addi	sp,sp,-32
    800057ce:	ec06                	sd	ra,24(sp)
    800057d0:	e822                	sd	s0,16(sp)
    800057d2:	e426                	sd	s1,8(sp)
    800057d4:	1000                	addi	s0,sp,32
    800057d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800057d8:	ffffb097          	auipc	ra,0xffffb
    800057dc:	626080e7          	jalr	1574(ra) # 80000dfe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800057e0:	00d5151b          	slliw	a0,a0,0xd
    800057e4:	0c2017b7          	lui	a5,0xc201
    800057e8:	97aa                	add	a5,a5,a0
    800057ea:	c3c4                	sw	s1,4(a5)
}
    800057ec:	60e2                	ld	ra,24(sp)
    800057ee:	6442                	ld	s0,16(sp)
    800057f0:	64a2                	ld	s1,8(sp)
    800057f2:	6105                	addi	sp,sp,32
    800057f4:	8082                	ret

00000000800057f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800057f6:	1141                	addi	sp,sp,-16
    800057f8:	e406                	sd	ra,8(sp)
    800057fa:	e022                	sd	s0,0(sp)
    800057fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800057fe:	479d                	li	a5,7
    80005800:	06a7c963          	blt	a5,a0,80005872 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005804:	0001d797          	auipc	a5,0x1d
    80005808:	7fc78793          	addi	a5,a5,2044 # 80023000 <disk>
    8000580c:	00a78733          	add	a4,a5,a0
    80005810:	6789                	lui	a5,0x2
    80005812:	97ba                	add	a5,a5,a4
    80005814:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005818:	e7ad                	bnez	a5,80005882 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000581a:	00451793          	slli	a5,a0,0x4
    8000581e:	0001f717          	auipc	a4,0x1f
    80005822:	7e270713          	addi	a4,a4,2018 # 80025000 <disk+0x2000>
    80005826:	6314                	ld	a3,0(a4)
    80005828:	96be                	add	a3,a3,a5
    8000582a:	0006b023          	sd	zero,0(a3) # 2000000 <_entry-0x7e000000>
  disk.desc[i].len = 0;
    8000582e:	6314                	ld	a3,0(a4)
    80005830:	96be                	add	a3,a3,a5
    80005832:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005836:	6314                	ld	a3,0(a4)
    80005838:	96be                	add	a3,a3,a5
    8000583a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000583e:	6318                	ld	a4,0(a4)
    80005840:	97ba                	add	a5,a5,a4
    80005842:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005846:	0001d797          	auipc	a5,0x1d
    8000584a:	7ba78793          	addi	a5,a5,1978 # 80023000 <disk>
    8000584e:	97aa                	add	a5,a5,a0
    80005850:	6509                	lui	a0,0x2
    80005852:	953e                	add	a0,a0,a5
    80005854:	4785                	li	a5,1
    80005856:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000585a:	0001f517          	auipc	a0,0x1f
    8000585e:	7be50513          	addi	a0,a0,1982 # 80025018 <disk+0x2018>
    80005862:	ffffc097          	auipc	ra,0xffffc
    80005866:	e54080e7          	jalr	-428(ra) # 800016b6 <wakeup>
}
    8000586a:	60a2                	ld	ra,8(sp)
    8000586c:	6402                	ld	s0,0(sp)
    8000586e:	0141                	addi	sp,sp,16
    80005870:	8082                	ret
    panic("free_desc 1");
    80005872:	00003517          	auipc	a0,0x3
    80005876:	e7e50513          	addi	a0,a0,-386 # 800086f0 <syscalls+0x340>
    8000587a:	00001097          	auipc	ra,0x1
    8000587e:	a1e080e7          	jalr	-1506(ra) # 80006298 <panic>
    panic("free_desc 2");
    80005882:	00003517          	auipc	a0,0x3
    80005886:	e7e50513          	addi	a0,a0,-386 # 80008700 <syscalls+0x350>
    8000588a:	00001097          	auipc	ra,0x1
    8000588e:	a0e080e7          	jalr	-1522(ra) # 80006298 <panic>

0000000080005892 <virtio_disk_init>:
{
    80005892:	1101                	addi	sp,sp,-32
    80005894:	ec06                	sd	ra,24(sp)
    80005896:	e822                	sd	s0,16(sp)
    80005898:	e426                	sd	s1,8(sp)
    8000589a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000589c:	00003597          	auipc	a1,0x3
    800058a0:	e7458593          	addi	a1,a1,-396 # 80008710 <syscalls+0x360>
    800058a4:	00020517          	auipc	a0,0x20
    800058a8:	88450513          	addi	a0,a0,-1916 # 80025128 <disk+0x2128>
    800058ac:	00001097          	auipc	ra,0x1
    800058b0:	ea6080e7          	jalr	-346(ra) # 80006752 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058b4:	100017b7          	lui	a5,0x10001
    800058b8:	4398                	lw	a4,0(a5)
    800058ba:	2701                	sext.w	a4,a4
    800058bc:	747277b7          	lui	a5,0x74727
    800058c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058c4:	0ef71163          	bne	a4,a5,800059a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800058c8:	100017b7          	lui	a5,0x10001
    800058cc:	43dc                	lw	a5,4(a5)
    800058ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058d0:	4705                	li	a4,1
    800058d2:	0ce79a63          	bne	a5,a4,800059a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058d6:	100017b7          	lui	a5,0x10001
    800058da:	479c                	lw	a5,8(a5)
    800058dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800058de:	4709                	li	a4,2
    800058e0:	0ce79363          	bne	a5,a4,800059a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058e4:	100017b7          	lui	a5,0x10001
    800058e8:	47d8                	lw	a4,12(a5)
    800058ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058ec:	554d47b7          	lui	a5,0x554d4
    800058f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058f4:	0af71963          	bne	a4,a5,800059a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058f8:	100017b7          	lui	a5,0x10001
    800058fc:	4705                	li	a4,1
    800058fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005900:	470d                	li	a4,3
    80005902:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005904:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005906:	c7ffe737          	lui	a4,0xc7ffe
    8000590a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd051f>
    8000590e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005910:	2701                	sext.w	a4,a4
    80005912:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005914:	472d                	li	a4,11
    80005916:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005918:	473d                	li	a4,15
    8000591a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000591c:	6705                	lui	a4,0x1
    8000591e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005920:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005924:	5bdc                	lw	a5,52(a5)
    80005926:	2781                	sext.w	a5,a5
  if(max == 0)
    80005928:	c7d9                	beqz	a5,800059b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000592a:	471d                	li	a4,7
    8000592c:	08f77d63          	bgeu	a4,a5,800059c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005930:	100014b7          	lui	s1,0x10001
    80005934:	47a1                	li	a5,8
    80005936:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005938:	6609                	lui	a2,0x2
    8000593a:	4581                	li	a1,0
    8000593c:	0001d517          	auipc	a0,0x1d
    80005940:	6c450513          	addi	a0,a0,1732 # 80023000 <disk>
    80005944:	ffffb097          	auipc	ra,0xffffb
    80005948:	834080e7          	jalr	-1996(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000594c:	0001d717          	auipc	a4,0x1d
    80005950:	6b470713          	addi	a4,a4,1716 # 80023000 <disk>
    80005954:	00c75793          	srli	a5,a4,0xc
    80005958:	2781                	sext.w	a5,a5
    8000595a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000595c:	0001f797          	auipc	a5,0x1f
    80005960:	6a478793          	addi	a5,a5,1700 # 80025000 <disk+0x2000>
    80005964:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005966:	0001d717          	auipc	a4,0x1d
    8000596a:	71a70713          	addi	a4,a4,1818 # 80023080 <disk+0x80>
    8000596e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005970:	0001e717          	auipc	a4,0x1e
    80005974:	69070713          	addi	a4,a4,1680 # 80024000 <disk+0x1000>
    80005978:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000597a:	4705                	li	a4,1
    8000597c:	00e78c23          	sb	a4,24(a5)
    80005980:	00e78ca3          	sb	a4,25(a5)
    80005984:	00e78d23          	sb	a4,26(a5)
    80005988:	00e78da3          	sb	a4,27(a5)
    8000598c:	00e78e23          	sb	a4,28(a5)
    80005990:	00e78ea3          	sb	a4,29(a5)
    80005994:	00e78f23          	sb	a4,30(a5)
    80005998:	00e78fa3          	sb	a4,31(a5)
}
    8000599c:	60e2                	ld	ra,24(sp)
    8000599e:	6442                	ld	s0,16(sp)
    800059a0:	64a2                	ld	s1,8(sp)
    800059a2:	6105                	addi	sp,sp,32
    800059a4:	8082                	ret
    panic("could not find virtio disk");
    800059a6:	00003517          	auipc	a0,0x3
    800059aa:	d7a50513          	addi	a0,a0,-646 # 80008720 <syscalls+0x370>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	8ea080e7          	jalr	-1814(ra) # 80006298 <panic>
    panic("virtio disk has no queue 0");
    800059b6:	00003517          	auipc	a0,0x3
    800059ba:	d8a50513          	addi	a0,a0,-630 # 80008740 <syscalls+0x390>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	8da080e7          	jalr	-1830(ra) # 80006298 <panic>
    panic("virtio disk max queue too short");
    800059c6:	00003517          	auipc	a0,0x3
    800059ca:	d9a50513          	addi	a0,a0,-614 # 80008760 <syscalls+0x3b0>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	8ca080e7          	jalr	-1846(ra) # 80006298 <panic>

00000000800059d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800059d6:	7159                	addi	sp,sp,-112
    800059d8:	f486                	sd	ra,104(sp)
    800059da:	f0a2                	sd	s0,96(sp)
    800059dc:	eca6                	sd	s1,88(sp)
    800059de:	e8ca                	sd	s2,80(sp)
    800059e0:	e4ce                	sd	s3,72(sp)
    800059e2:	e0d2                	sd	s4,64(sp)
    800059e4:	fc56                	sd	s5,56(sp)
    800059e6:	f85a                	sd	s6,48(sp)
    800059e8:	f45e                	sd	s7,40(sp)
    800059ea:	f062                	sd	s8,32(sp)
    800059ec:	ec66                	sd	s9,24(sp)
    800059ee:	e86a                	sd	s10,16(sp)
    800059f0:	1880                	addi	s0,sp,112
    800059f2:	892a                	mv	s2,a0
    800059f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800059f6:	00c52c83          	lw	s9,12(a0)
    800059fa:	001c9c9b          	slliw	s9,s9,0x1
    800059fe:	1c82                	slli	s9,s9,0x20
    80005a00:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005a04:	0001f517          	auipc	a0,0x1f
    80005a08:	72450513          	addi	a0,a0,1828 # 80025128 <disk+0x2128>
    80005a0c:	00001097          	auipc	ra,0x1
    80005a10:	dd6080e7          	jalr	-554(ra) # 800067e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005a14:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005a16:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005a18:	0001db97          	auipc	s7,0x1d
    80005a1c:	5e8b8b93          	addi	s7,s7,1512 # 80023000 <disk>
    80005a20:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005a22:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005a24:	8a4e                	mv	s4,s3
    80005a26:	a051                	j	80005aaa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005a28:	00fb86b3          	add	a3,s7,a5
    80005a2c:	96da                	add	a3,a3,s6
    80005a2e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005a32:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005a34:	0207c563          	bltz	a5,80005a5e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005a38:	2485                	addiw	s1,s1,1
    80005a3a:	0711                	addi	a4,a4,4
    80005a3c:	25548063          	beq	s1,s5,80005c7c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005a40:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005a42:	0001f697          	auipc	a3,0x1f
    80005a46:	5d668693          	addi	a3,a3,1494 # 80025018 <disk+0x2018>
    80005a4a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005a4c:	0006c583          	lbu	a1,0(a3)
    80005a50:	fde1                	bnez	a1,80005a28 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005a52:	2785                	addiw	a5,a5,1
    80005a54:	0685                	addi	a3,a3,1
    80005a56:	ff879be3          	bne	a5,s8,80005a4c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005a5a:	57fd                	li	a5,-1
    80005a5c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005a5e:	02905a63          	blez	s1,80005a92 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a62:	f9042503          	lw	a0,-112(s0)
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	d90080e7          	jalr	-624(ra) # 800057f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005a6e:	4785                	li	a5,1
    80005a70:	0297d163          	bge	a5,s1,80005a92 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a74:	f9442503          	lw	a0,-108(s0)
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	d7e080e7          	jalr	-642(ra) # 800057f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005a80:	4789                	li	a5,2
    80005a82:	0097d863          	bge	a5,s1,80005a92 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005a86:	f9842503          	lw	a0,-104(s0)
    80005a8a:	00000097          	auipc	ra,0x0
    80005a8e:	d6c080e7          	jalr	-660(ra) # 800057f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005a92:	0001f597          	auipc	a1,0x1f
    80005a96:	69658593          	addi	a1,a1,1686 # 80025128 <disk+0x2128>
    80005a9a:	0001f517          	auipc	a0,0x1f
    80005a9e:	57e50513          	addi	a0,a0,1406 # 80025018 <disk+0x2018>
    80005aa2:	ffffc097          	auipc	ra,0xffffc
    80005aa6:	a88080e7          	jalr	-1400(ra) # 8000152a <sleep>
  for(int i = 0; i < 3; i++){
    80005aaa:	f9040713          	addi	a4,s0,-112
    80005aae:	84ce                	mv	s1,s3
    80005ab0:	bf41                	j	80005a40 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005ab2:	20058713          	addi	a4,a1,512
    80005ab6:	00471693          	slli	a3,a4,0x4
    80005aba:	0001d717          	auipc	a4,0x1d
    80005abe:	54670713          	addi	a4,a4,1350 # 80023000 <disk>
    80005ac2:	9736                	add	a4,a4,a3
    80005ac4:	4685                	li	a3,1
    80005ac6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005aca:	20058713          	addi	a4,a1,512
    80005ace:	00471693          	slli	a3,a4,0x4
    80005ad2:	0001d717          	auipc	a4,0x1d
    80005ad6:	52e70713          	addi	a4,a4,1326 # 80023000 <disk>
    80005ada:	9736                	add	a4,a4,a3
    80005adc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005ae0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005ae4:	7679                	lui	a2,0xffffe
    80005ae6:	963e                	add	a2,a2,a5
    80005ae8:	0001f697          	auipc	a3,0x1f
    80005aec:	51868693          	addi	a3,a3,1304 # 80025000 <disk+0x2000>
    80005af0:	6298                	ld	a4,0(a3)
    80005af2:	9732                	add	a4,a4,a2
    80005af4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005af6:	6298                	ld	a4,0(a3)
    80005af8:	9732                	add	a4,a4,a2
    80005afa:	4541                	li	a0,16
    80005afc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005afe:	6298                	ld	a4,0(a3)
    80005b00:	9732                	add	a4,a4,a2
    80005b02:	4505                	li	a0,1
    80005b04:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005b08:	f9442703          	lw	a4,-108(s0)
    80005b0c:	6288                	ld	a0,0(a3)
    80005b0e:	962a                	add	a2,a2,a0
    80005b10:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcfdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b14:	0712                	slli	a4,a4,0x4
    80005b16:	6290                	ld	a2,0(a3)
    80005b18:	963a                	add	a2,a2,a4
    80005b1a:	05890513          	addi	a0,s2,88
    80005b1e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b20:	6294                	ld	a3,0(a3)
    80005b22:	96ba                	add	a3,a3,a4
    80005b24:	40000613          	li	a2,1024
    80005b28:	c690                	sw	a2,8(a3)
  if(write)
    80005b2a:	140d0063          	beqz	s10,80005c6a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005b2e:	0001f697          	auipc	a3,0x1f
    80005b32:	4d26b683          	ld	a3,1234(a3) # 80025000 <disk+0x2000>
    80005b36:	96ba                	add	a3,a3,a4
    80005b38:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005b3c:	0001d817          	auipc	a6,0x1d
    80005b40:	4c480813          	addi	a6,a6,1220 # 80023000 <disk>
    80005b44:	0001f517          	auipc	a0,0x1f
    80005b48:	4bc50513          	addi	a0,a0,1212 # 80025000 <disk+0x2000>
    80005b4c:	6114                	ld	a3,0(a0)
    80005b4e:	96ba                	add	a3,a3,a4
    80005b50:	00c6d603          	lhu	a2,12(a3)
    80005b54:	00166613          	ori	a2,a2,1
    80005b58:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005b5c:	f9842683          	lw	a3,-104(s0)
    80005b60:	6110                	ld	a2,0(a0)
    80005b62:	9732                	add	a4,a4,a2
    80005b64:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005b68:	20058613          	addi	a2,a1,512
    80005b6c:	0612                	slli	a2,a2,0x4
    80005b6e:	9642                	add	a2,a2,a6
    80005b70:	577d                	li	a4,-1
    80005b72:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005b76:	00469713          	slli	a4,a3,0x4
    80005b7a:	6114                	ld	a3,0(a0)
    80005b7c:	96ba                	add	a3,a3,a4
    80005b7e:	03078793          	addi	a5,a5,48
    80005b82:	97c2                	add	a5,a5,a6
    80005b84:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005b86:	611c                	ld	a5,0(a0)
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	4685                	li	a3,1
    80005b8c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005b8e:	611c                	ld	a5,0(a0)
    80005b90:	97ba                	add	a5,a5,a4
    80005b92:	4809                	li	a6,2
    80005b94:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005b98:	611c                	ld	a5,0(a0)
    80005b9a:	973e                	add	a4,a4,a5
    80005b9c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ba0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005ba4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ba8:	6518                	ld	a4,8(a0)
    80005baa:	00275783          	lhu	a5,2(a4)
    80005bae:	8b9d                	andi	a5,a5,7
    80005bb0:	0786                	slli	a5,a5,0x1
    80005bb2:	97ba                	add	a5,a5,a4
    80005bb4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005bb8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005bbc:	6518                	ld	a4,8(a0)
    80005bbe:	00275783          	lhu	a5,2(a4)
    80005bc2:	2785                	addiw	a5,a5,1
    80005bc4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005bc8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005bcc:	100017b7          	lui	a5,0x10001
    80005bd0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005bd4:	00492703          	lw	a4,4(s2)
    80005bd8:	4785                	li	a5,1
    80005bda:	02f71163          	bne	a4,a5,80005bfc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80005bde:	0001f997          	auipc	s3,0x1f
    80005be2:	54a98993          	addi	s3,s3,1354 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80005be6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005be8:	85ce                	mv	a1,s3
    80005bea:	854a                	mv	a0,s2
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	93e080e7          	jalr	-1730(ra) # 8000152a <sleep>
  while(b->disk == 1) {
    80005bf4:	00492783          	lw	a5,4(s2)
    80005bf8:	fe9788e3          	beq	a5,s1,80005be8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80005bfc:	f9042903          	lw	s2,-112(s0)
    80005c00:	20090793          	addi	a5,s2,512
    80005c04:	00479713          	slli	a4,a5,0x4
    80005c08:	0001d797          	auipc	a5,0x1d
    80005c0c:	3f878793          	addi	a5,a5,1016 # 80023000 <disk>
    80005c10:	97ba                	add	a5,a5,a4
    80005c12:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005c16:	0001f997          	auipc	s3,0x1f
    80005c1a:	3ea98993          	addi	s3,s3,1002 # 80025000 <disk+0x2000>
    80005c1e:	00491713          	slli	a4,s2,0x4
    80005c22:	0009b783          	ld	a5,0(s3)
    80005c26:	97ba                	add	a5,a5,a4
    80005c28:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c2c:	854a                	mv	a0,s2
    80005c2e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	bc4080e7          	jalr	-1084(ra) # 800057f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c3a:	8885                	andi	s1,s1,1
    80005c3c:	f0ed                	bnez	s1,80005c1e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c3e:	0001f517          	auipc	a0,0x1f
    80005c42:	4ea50513          	addi	a0,a0,1258 # 80025128 <disk+0x2128>
    80005c46:	00001097          	auipc	ra,0x1
    80005c4a:	c50080e7          	jalr	-944(ra) # 80006896 <release>
}
    80005c4e:	70a6                	ld	ra,104(sp)
    80005c50:	7406                	ld	s0,96(sp)
    80005c52:	64e6                	ld	s1,88(sp)
    80005c54:	6946                	ld	s2,80(sp)
    80005c56:	69a6                	ld	s3,72(sp)
    80005c58:	6a06                	ld	s4,64(sp)
    80005c5a:	7ae2                	ld	s5,56(sp)
    80005c5c:	7b42                	ld	s6,48(sp)
    80005c5e:	7ba2                	ld	s7,40(sp)
    80005c60:	7c02                	ld	s8,32(sp)
    80005c62:	6ce2                	ld	s9,24(sp)
    80005c64:	6d42                	ld	s10,16(sp)
    80005c66:	6165                	addi	sp,sp,112
    80005c68:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005c6a:	0001f697          	auipc	a3,0x1f
    80005c6e:	3966b683          	ld	a3,918(a3) # 80025000 <disk+0x2000>
    80005c72:	96ba                	add	a3,a3,a4
    80005c74:	4609                	li	a2,2
    80005c76:	00c69623          	sh	a2,12(a3)
    80005c7a:	b5c9                	j	80005b3c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c7c:	f9042583          	lw	a1,-112(s0)
    80005c80:	20058793          	addi	a5,a1,512
    80005c84:	0792                	slli	a5,a5,0x4
    80005c86:	0001d517          	auipc	a0,0x1d
    80005c8a:	42250513          	addi	a0,a0,1058 # 800230a8 <disk+0xa8>
    80005c8e:	953e                	add	a0,a0,a5
  if(write)
    80005c90:	e20d11e3          	bnez	s10,80005ab2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005c94:	20058713          	addi	a4,a1,512
    80005c98:	00471693          	slli	a3,a4,0x4
    80005c9c:	0001d717          	auipc	a4,0x1d
    80005ca0:	36470713          	addi	a4,a4,868 # 80023000 <disk>
    80005ca4:	9736                	add	a4,a4,a3
    80005ca6:	0a072423          	sw	zero,168(a4)
    80005caa:	b505                	j	80005aca <virtio_disk_rw+0xf4>

0000000080005cac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005cac:	1101                	addi	sp,sp,-32
    80005cae:	ec06                	sd	ra,24(sp)
    80005cb0:	e822                	sd	s0,16(sp)
    80005cb2:	e426                	sd	s1,8(sp)
    80005cb4:	e04a                	sd	s2,0(sp)
    80005cb6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cb8:	0001f517          	auipc	a0,0x1f
    80005cbc:	47050513          	addi	a0,a0,1136 # 80025128 <disk+0x2128>
    80005cc0:	00001097          	auipc	ra,0x1
    80005cc4:	b22080e7          	jalr	-1246(ra) # 800067e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cc8:	10001737          	lui	a4,0x10001
    80005ccc:	533c                	lw	a5,96(a4)
    80005cce:	8b8d                	andi	a5,a5,3
    80005cd0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005cd2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cd6:	0001f797          	auipc	a5,0x1f
    80005cda:	32a78793          	addi	a5,a5,810 # 80025000 <disk+0x2000>
    80005cde:	6b94                	ld	a3,16(a5)
    80005ce0:	0207d703          	lhu	a4,32(a5)
    80005ce4:	0026d783          	lhu	a5,2(a3)
    80005ce8:	06f70163          	beq	a4,a5,80005d4a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cec:	0001d917          	auipc	s2,0x1d
    80005cf0:	31490913          	addi	s2,s2,788 # 80023000 <disk>
    80005cf4:	0001f497          	auipc	s1,0x1f
    80005cf8:	30c48493          	addi	s1,s1,780 # 80025000 <disk+0x2000>
    __sync_synchronize();
    80005cfc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d00:	6898                	ld	a4,16(s1)
    80005d02:	0204d783          	lhu	a5,32(s1)
    80005d06:	8b9d                	andi	a5,a5,7
    80005d08:	078e                	slli	a5,a5,0x3
    80005d0a:	97ba                	add	a5,a5,a4
    80005d0c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005d0e:	20078713          	addi	a4,a5,512
    80005d12:	0712                	slli	a4,a4,0x4
    80005d14:	974a                	add	a4,a4,s2
    80005d16:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005d1a:	e731                	bnez	a4,80005d66 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d1c:	20078793          	addi	a5,a5,512
    80005d20:	0792                	slli	a5,a5,0x4
    80005d22:	97ca                	add	a5,a5,s2
    80005d24:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005d26:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d2a:	ffffc097          	auipc	ra,0xffffc
    80005d2e:	98c080e7          	jalr	-1652(ra) # 800016b6 <wakeup>

    disk.used_idx += 1;
    80005d32:	0204d783          	lhu	a5,32(s1)
    80005d36:	2785                	addiw	a5,a5,1
    80005d38:	17c2                	slli	a5,a5,0x30
    80005d3a:	93c1                	srli	a5,a5,0x30
    80005d3c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d40:	6898                	ld	a4,16(s1)
    80005d42:	00275703          	lhu	a4,2(a4)
    80005d46:	faf71be3          	bne	a4,a5,80005cfc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005d4a:	0001f517          	auipc	a0,0x1f
    80005d4e:	3de50513          	addi	a0,a0,990 # 80025128 <disk+0x2128>
    80005d52:	00001097          	auipc	ra,0x1
    80005d56:	b44080e7          	jalr	-1212(ra) # 80006896 <release>
}
    80005d5a:	60e2                	ld	ra,24(sp)
    80005d5c:	6442                	ld	s0,16(sp)
    80005d5e:	64a2                	ld	s1,8(sp)
    80005d60:	6902                	ld	s2,0(sp)
    80005d62:	6105                	addi	sp,sp,32
    80005d64:	8082                	ret
      panic("virtio_disk_intr status");
    80005d66:	00003517          	auipc	a0,0x3
    80005d6a:	a1a50513          	addi	a0,a0,-1510 # 80008780 <syscalls+0x3d0>
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	52a080e7          	jalr	1322(ra) # 80006298 <panic>

0000000080005d76 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d76:	1141                	addi	sp,sp,-16
    80005d78:	e422                	sd	s0,8(sp)
    80005d7a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d7c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d80:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d84:	0037979b          	slliw	a5,a5,0x3
    80005d88:	02004737          	lui	a4,0x2004
    80005d8c:	97ba                	add	a5,a5,a4
    80005d8e:	0200c737          	lui	a4,0x200c
    80005d92:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d96:	000f4637          	lui	a2,0xf4
    80005d9a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d9e:	95b2                	add	a1,a1,a2
    80005da0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005da2:	00269713          	slli	a4,a3,0x2
    80005da6:	9736                	add	a4,a4,a3
    80005da8:	00371693          	slli	a3,a4,0x3
    80005dac:	00020717          	auipc	a4,0x20
    80005db0:	25470713          	addi	a4,a4,596 # 80026000 <timer_scratch>
    80005db4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005db6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005db8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005dba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005dbe:	00000797          	auipc	a5,0x0
    80005dc2:	97278793          	addi	a5,a5,-1678 # 80005730 <timervec>
    80005dc6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005dca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005dce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005dd2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005dd6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005dda:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005dde:	30479073          	csrw	mie,a5
}
    80005de2:	6422                	ld	s0,8(sp)
    80005de4:	0141                	addi	sp,sp,16
    80005de6:	8082                	ret

0000000080005de8 <start>:
{
    80005de8:	1141                	addi	sp,sp,-16
    80005dea:	e406                	sd	ra,8(sp)
    80005dec:	e022                	sd	s0,0(sp)
    80005dee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005df0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005df4:	7779                	lui	a4,0xffffe
    80005df6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd05bf>
    80005dfa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005dfc:	6705                	lui	a4,0x1
    80005dfe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005e02:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e04:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005e08:	ffffa797          	auipc	a5,0xffffa
    80005e0c:	51e78793          	addi	a5,a5,1310 # 80000326 <main>
    80005e10:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e14:	4781                	li	a5,0
    80005e16:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e1a:	67c1                	lui	a5,0x10
    80005e1c:	17fd                	addi	a5,a5,-1
    80005e1e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005e22:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005e26:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005e2a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005e2e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005e32:	57fd                	li	a5,-1
    80005e34:	83a9                	srli	a5,a5,0xa
    80005e36:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005e3a:	47bd                	li	a5,15
    80005e3c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	f36080e7          	jalr	-202(ra) # 80005d76 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005e48:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005e4c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005e4e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e50:	30200073          	mret
}
    80005e54:	60a2                	ld	ra,8(sp)
    80005e56:	6402                	ld	s0,0(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e5c:	715d                	addi	sp,sp,-80
    80005e5e:	e486                	sd	ra,72(sp)
    80005e60:	e0a2                	sd	s0,64(sp)
    80005e62:	fc26                	sd	s1,56(sp)
    80005e64:	f84a                	sd	s2,48(sp)
    80005e66:	f44e                	sd	s3,40(sp)
    80005e68:	f052                	sd	s4,32(sp)
    80005e6a:	ec56                	sd	s5,24(sp)
    80005e6c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e6e:	04c05663          	blez	a2,80005eba <consolewrite+0x5e>
    80005e72:	8a2a                	mv	s4,a0
    80005e74:	84ae                	mv	s1,a1
    80005e76:	89b2                	mv	s3,a2
    80005e78:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e7a:	5afd                	li	s5,-1
    80005e7c:	4685                	li	a3,1
    80005e7e:	8626                	mv	a2,s1
    80005e80:	85d2                	mv	a1,s4
    80005e82:	fbf40513          	addi	a0,s0,-65
    80005e86:	ffffc097          	auipc	ra,0xffffc
    80005e8a:	c52080e7          	jalr	-942(ra) # 80001ad8 <either_copyin>
    80005e8e:	01550c63          	beq	a0,s5,80005ea6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005e92:	fbf44503          	lbu	a0,-65(s0)
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	78e080e7          	jalr	1934(ra) # 80006624 <uartputc>
  for(i = 0; i < n; i++){
    80005e9e:	2905                	addiw	s2,s2,1
    80005ea0:	0485                	addi	s1,s1,1
    80005ea2:	fd299de3          	bne	s3,s2,80005e7c <consolewrite+0x20>
  }

  return i;
}
    80005ea6:	854a                	mv	a0,s2
    80005ea8:	60a6                	ld	ra,72(sp)
    80005eaa:	6406                	ld	s0,64(sp)
    80005eac:	74e2                	ld	s1,56(sp)
    80005eae:	7942                	ld	s2,48(sp)
    80005eb0:	79a2                	ld	s3,40(sp)
    80005eb2:	7a02                	ld	s4,32(sp)
    80005eb4:	6ae2                	ld	s5,24(sp)
    80005eb6:	6161                	addi	sp,sp,80
    80005eb8:	8082                	ret
  for(i = 0; i < n; i++){
    80005eba:	4901                	li	s2,0
    80005ebc:	b7ed                	j	80005ea6 <consolewrite+0x4a>

0000000080005ebe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ebe:	7119                	addi	sp,sp,-128
    80005ec0:	fc86                	sd	ra,120(sp)
    80005ec2:	f8a2                	sd	s0,112(sp)
    80005ec4:	f4a6                	sd	s1,104(sp)
    80005ec6:	f0ca                	sd	s2,96(sp)
    80005ec8:	ecce                	sd	s3,88(sp)
    80005eca:	e8d2                	sd	s4,80(sp)
    80005ecc:	e4d6                	sd	s5,72(sp)
    80005ece:	e0da                	sd	s6,64(sp)
    80005ed0:	fc5e                	sd	s7,56(sp)
    80005ed2:	f862                	sd	s8,48(sp)
    80005ed4:	f466                	sd	s9,40(sp)
    80005ed6:	f06a                	sd	s10,32(sp)
    80005ed8:	ec6e                	sd	s11,24(sp)
    80005eda:	0100                	addi	s0,sp,128
    80005edc:	8b2a                	mv	s6,a0
    80005ede:	8aae                	mv	s5,a1
    80005ee0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ee2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005ee6:	00028517          	auipc	a0,0x28
    80005eea:	25a50513          	addi	a0,a0,602 # 8002e140 <cons>
    80005eee:	00001097          	auipc	ra,0x1
    80005ef2:	8f4080e7          	jalr	-1804(ra) # 800067e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ef6:	00028497          	auipc	s1,0x28
    80005efa:	24a48493          	addi	s1,s1,586 # 8002e140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005efe:	89a6                	mv	s3,s1
    80005f00:	00028917          	auipc	s2,0x28
    80005f04:	2d890913          	addi	s2,s2,728 # 8002e1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005f08:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f0a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005f0c:	4da9                	li	s11,10
  while(n > 0){
    80005f0e:	07405863          	blez	s4,80005f7e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005f12:	0984a783          	lw	a5,152(s1)
    80005f16:	09c4a703          	lw	a4,156(s1)
    80005f1a:	02f71463          	bne	a4,a5,80005f42 <consoleread+0x84>
      if(myproc()->killed){
    80005f1e:	ffffb097          	auipc	ra,0xffffb
    80005f22:	f0c080e7          	jalr	-244(ra) # 80000e2a <myproc>
    80005f26:	551c                	lw	a5,40(a0)
    80005f28:	e7b5                	bnez	a5,80005f94 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005f2a:	85ce                	mv	a1,s3
    80005f2c:	854a                	mv	a0,s2
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	5fc080e7          	jalr	1532(ra) # 8000152a <sleep>
    while(cons.r == cons.w){
    80005f36:	0984a783          	lw	a5,152(s1)
    80005f3a:	09c4a703          	lw	a4,156(s1)
    80005f3e:	fef700e3          	beq	a4,a5,80005f1e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005f42:	0017871b          	addiw	a4,a5,1
    80005f46:	08e4ac23          	sw	a4,152(s1)
    80005f4a:	07f7f713          	andi	a4,a5,127
    80005f4e:	9726                	add	a4,a4,s1
    80005f50:	01874703          	lbu	a4,24(a4)
    80005f54:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005f58:	079c0663          	beq	s8,s9,80005fc4 <consoleread+0x106>
    cbuf = c;
    80005f5c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f60:	4685                	li	a3,1
    80005f62:	f8f40613          	addi	a2,s0,-113
    80005f66:	85d6                	mv	a1,s5
    80005f68:	855a                	mv	a0,s6
    80005f6a:	ffffc097          	auipc	ra,0xffffc
    80005f6e:	b18080e7          	jalr	-1256(ra) # 80001a82 <either_copyout>
    80005f72:	01a50663          	beq	a0,s10,80005f7e <consoleread+0xc0>
    dst++;
    80005f76:	0a85                	addi	s5,s5,1
    --n;
    80005f78:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005f7a:	f9bc1ae3          	bne	s8,s11,80005f0e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005f7e:	00028517          	auipc	a0,0x28
    80005f82:	1c250513          	addi	a0,a0,450 # 8002e140 <cons>
    80005f86:	00001097          	auipc	ra,0x1
    80005f8a:	910080e7          	jalr	-1776(ra) # 80006896 <release>

  return target - n;
    80005f8e:	414b853b          	subw	a0,s7,s4
    80005f92:	a811                	j	80005fa6 <consoleread+0xe8>
        release(&cons.lock);
    80005f94:	00028517          	auipc	a0,0x28
    80005f98:	1ac50513          	addi	a0,a0,428 # 8002e140 <cons>
    80005f9c:	00001097          	auipc	ra,0x1
    80005fa0:	8fa080e7          	jalr	-1798(ra) # 80006896 <release>
        return -1;
    80005fa4:	557d                	li	a0,-1
}
    80005fa6:	70e6                	ld	ra,120(sp)
    80005fa8:	7446                	ld	s0,112(sp)
    80005faa:	74a6                	ld	s1,104(sp)
    80005fac:	7906                	ld	s2,96(sp)
    80005fae:	69e6                	ld	s3,88(sp)
    80005fb0:	6a46                	ld	s4,80(sp)
    80005fb2:	6aa6                	ld	s5,72(sp)
    80005fb4:	6b06                	ld	s6,64(sp)
    80005fb6:	7be2                	ld	s7,56(sp)
    80005fb8:	7c42                	ld	s8,48(sp)
    80005fba:	7ca2                	ld	s9,40(sp)
    80005fbc:	7d02                	ld	s10,32(sp)
    80005fbe:	6de2                	ld	s11,24(sp)
    80005fc0:	6109                	addi	sp,sp,128
    80005fc2:	8082                	ret
      if(n < target){
    80005fc4:	000a071b          	sext.w	a4,s4
    80005fc8:	fb777be3          	bgeu	a4,s7,80005f7e <consoleread+0xc0>
        cons.r--;
    80005fcc:	00028717          	auipc	a4,0x28
    80005fd0:	20f72623          	sw	a5,524(a4) # 8002e1d8 <cons+0x98>
    80005fd4:	b76d                	j	80005f7e <consoleread+0xc0>

0000000080005fd6 <consputc>:
{
    80005fd6:	1141                	addi	sp,sp,-16
    80005fd8:	e406                	sd	ra,8(sp)
    80005fda:	e022                	sd	s0,0(sp)
    80005fdc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fde:	10000793          	li	a5,256
    80005fe2:	00f50a63          	beq	a0,a5,80005ff6 <consputc+0x20>
    uartputc_sync(c);
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	564080e7          	jalr	1380(ra) # 8000654a <uartputc_sync>
}
    80005fee:	60a2                	ld	ra,8(sp)
    80005ff0:	6402                	ld	s0,0(sp)
    80005ff2:	0141                	addi	sp,sp,16
    80005ff4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ff6:	4521                	li	a0,8
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	552080e7          	jalr	1362(ra) # 8000654a <uartputc_sync>
    80006000:	02000513          	li	a0,32
    80006004:	00000097          	auipc	ra,0x0
    80006008:	546080e7          	jalr	1350(ra) # 8000654a <uartputc_sync>
    8000600c:	4521                	li	a0,8
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	53c080e7          	jalr	1340(ra) # 8000654a <uartputc_sync>
    80006016:	bfe1                	j	80005fee <consputc+0x18>

0000000080006018 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006018:	1101                	addi	sp,sp,-32
    8000601a:	ec06                	sd	ra,24(sp)
    8000601c:	e822                	sd	s0,16(sp)
    8000601e:	e426                	sd	s1,8(sp)
    80006020:	e04a                	sd	s2,0(sp)
    80006022:	1000                	addi	s0,sp,32
    80006024:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006026:	00028517          	auipc	a0,0x28
    8000602a:	11a50513          	addi	a0,a0,282 # 8002e140 <cons>
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	7b4080e7          	jalr	1972(ra) # 800067e2 <acquire>

  switch(c){
    80006036:	47d5                	li	a5,21
    80006038:	0af48663          	beq	s1,a5,800060e4 <consoleintr+0xcc>
    8000603c:	0297ca63          	blt	a5,s1,80006070 <consoleintr+0x58>
    80006040:	47a1                	li	a5,8
    80006042:	0ef48763          	beq	s1,a5,80006130 <consoleintr+0x118>
    80006046:	47c1                	li	a5,16
    80006048:	10f49a63          	bne	s1,a5,8000615c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000604c:	ffffc097          	auipc	ra,0xffffc
    80006050:	ae2080e7          	jalr	-1310(ra) # 80001b2e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006054:	00028517          	auipc	a0,0x28
    80006058:	0ec50513          	addi	a0,a0,236 # 8002e140 <cons>
    8000605c:	00001097          	auipc	ra,0x1
    80006060:	83a080e7          	jalr	-1990(ra) # 80006896 <release>
}
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	64a2                	ld	s1,8(sp)
    8000606a:	6902                	ld	s2,0(sp)
    8000606c:	6105                	addi	sp,sp,32
    8000606e:	8082                	ret
  switch(c){
    80006070:	07f00793          	li	a5,127
    80006074:	0af48e63          	beq	s1,a5,80006130 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006078:	00028717          	auipc	a4,0x28
    8000607c:	0c870713          	addi	a4,a4,200 # 8002e140 <cons>
    80006080:	0a072783          	lw	a5,160(a4)
    80006084:	09872703          	lw	a4,152(a4)
    80006088:	9f99                	subw	a5,a5,a4
    8000608a:	07f00713          	li	a4,127
    8000608e:	fcf763e3          	bltu	a4,a5,80006054 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006092:	47b5                	li	a5,13
    80006094:	0cf48763          	beq	s1,a5,80006162 <consoleintr+0x14a>
      consputc(c);
    80006098:	8526                	mv	a0,s1
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	f3c080e7          	jalr	-196(ra) # 80005fd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060a2:	00028797          	auipc	a5,0x28
    800060a6:	09e78793          	addi	a5,a5,158 # 8002e140 <cons>
    800060aa:	0a07a703          	lw	a4,160(a5)
    800060ae:	0017069b          	addiw	a3,a4,1
    800060b2:	0006861b          	sext.w	a2,a3
    800060b6:	0ad7a023          	sw	a3,160(a5)
    800060ba:	07f77713          	andi	a4,a4,127
    800060be:	97ba                	add	a5,a5,a4
    800060c0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    800060c4:	47a9                	li	a5,10
    800060c6:	0cf48563          	beq	s1,a5,80006190 <consoleintr+0x178>
    800060ca:	4791                	li	a5,4
    800060cc:	0cf48263          	beq	s1,a5,80006190 <consoleintr+0x178>
    800060d0:	00028797          	auipc	a5,0x28
    800060d4:	1087a783          	lw	a5,264(a5) # 8002e1d8 <cons+0x98>
    800060d8:	0807879b          	addiw	a5,a5,128
    800060dc:	f6f61ce3          	bne	a2,a5,80006054 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060e0:	863e                	mv	a2,a5
    800060e2:	a07d                	j	80006190 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800060e4:	00028717          	auipc	a4,0x28
    800060e8:	05c70713          	addi	a4,a4,92 # 8002e140 <cons>
    800060ec:	0a072783          	lw	a5,160(a4)
    800060f0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800060f4:	00028497          	auipc	s1,0x28
    800060f8:	04c48493          	addi	s1,s1,76 # 8002e140 <cons>
    while(cons.e != cons.w &&
    800060fc:	4929                	li	s2,10
    800060fe:	f4f70be3          	beq	a4,a5,80006054 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006102:	37fd                	addiw	a5,a5,-1
    80006104:	07f7f713          	andi	a4,a5,127
    80006108:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000610a:	01874703          	lbu	a4,24(a4)
    8000610e:	f52703e3          	beq	a4,s2,80006054 <consoleintr+0x3c>
      cons.e--;
    80006112:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006116:	10000513          	li	a0,256
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	ebc080e7          	jalr	-324(ra) # 80005fd6 <consputc>
    while(cons.e != cons.w &&
    80006122:	0a04a783          	lw	a5,160(s1)
    80006126:	09c4a703          	lw	a4,156(s1)
    8000612a:	fcf71ce3          	bne	a4,a5,80006102 <consoleintr+0xea>
    8000612e:	b71d                	j	80006054 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006130:	00028717          	auipc	a4,0x28
    80006134:	01070713          	addi	a4,a4,16 # 8002e140 <cons>
    80006138:	0a072783          	lw	a5,160(a4)
    8000613c:	09c72703          	lw	a4,156(a4)
    80006140:	f0f70ae3          	beq	a4,a5,80006054 <consoleintr+0x3c>
      cons.e--;
    80006144:	37fd                	addiw	a5,a5,-1
    80006146:	00028717          	auipc	a4,0x28
    8000614a:	08f72d23          	sw	a5,154(a4) # 8002e1e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000614e:	10000513          	li	a0,256
    80006152:	00000097          	auipc	ra,0x0
    80006156:	e84080e7          	jalr	-380(ra) # 80005fd6 <consputc>
    8000615a:	bded                	j	80006054 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000615c:	ee048ce3          	beqz	s1,80006054 <consoleintr+0x3c>
    80006160:	bf21                	j	80006078 <consoleintr+0x60>
      consputc(c);
    80006162:	4529                	li	a0,10
    80006164:	00000097          	auipc	ra,0x0
    80006168:	e72080e7          	jalr	-398(ra) # 80005fd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000616c:	00028797          	auipc	a5,0x28
    80006170:	fd478793          	addi	a5,a5,-44 # 8002e140 <cons>
    80006174:	0a07a703          	lw	a4,160(a5)
    80006178:	0017069b          	addiw	a3,a4,1
    8000617c:	0006861b          	sext.w	a2,a3
    80006180:	0ad7a023          	sw	a3,160(a5)
    80006184:	07f77713          	andi	a4,a4,127
    80006188:	97ba                	add	a5,a5,a4
    8000618a:	4729                	li	a4,10
    8000618c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006190:	00028797          	auipc	a5,0x28
    80006194:	04c7a623          	sw	a2,76(a5) # 8002e1dc <cons+0x9c>
        wakeup(&cons.r);
    80006198:	00028517          	auipc	a0,0x28
    8000619c:	04050513          	addi	a0,a0,64 # 8002e1d8 <cons+0x98>
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	516080e7          	jalr	1302(ra) # 800016b6 <wakeup>
    800061a8:	b575                	j	80006054 <consoleintr+0x3c>

00000000800061aa <consoleinit>:

void
consoleinit(void)
{
    800061aa:	1141                	addi	sp,sp,-16
    800061ac:	e406                	sd	ra,8(sp)
    800061ae:	e022                	sd	s0,0(sp)
    800061b0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800061b2:	00002597          	auipc	a1,0x2
    800061b6:	5e658593          	addi	a1,a1,1510 # 80008798 <syscalls+0x3e8>
    800061ba:	00028517          	auipc	a0,0x28
    800061be:	f8650513          	addi	a0,a0,-122 # 8002e140 <cons>
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	590080e7          	jalr	1424(ra) # 80006752 <initlock>

  uartinit();
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	330080e7          	jalr	816(ra) # 800064fa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800061d2:	0001b797          	auipc	a5,0x1b
    800061d6:	ef678793          	addi	a5,a5,-266 # 800210c8 <devsw>
    800061da:	00000717          	auipc	a4,0x0
    800061de:	ce470713          	addi	a4,a4,-796 # 80005ebe <consoleread>
    800061e2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061e4:	00000717          	auipc	a4,0x0
    800061e8:	c7870713          	addi	a4,a4,-904 # 80005e5c <consolewrite>
    800061ec:	ef98                	sd	a4,24(a5)
}
    800061ee:	60a2                	ld	ra,8(sp)
    800061f0:	6402                	ld	s0,0(sp)
    800061f2:	0141                	addi	sp,sp,16
    800061f4:	8082                	ret

00000000800061f6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061f6:	7179                	addi	sp,sp,-48
    800061f8:	f406                	sd	ra,40(sp)
    800061fa:	f022                	sd	s0,32(sp)
    800061fc:	ec26                	sd	s1,24(sp)
    800061fe:	e84a                	sd	s2,16(sp)
    80006200:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006202:	c219                	beqz	a2,80006208 <printint+0x12>
    80006204:	08054663          	bltz	a0,80006290 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006208:	2501                	sext.w	a0,a0
    8000620a:	4881                	li	a7,0
    8000620c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006210:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006212:	2581                	sext.w	a1,a1
    80006214:	00002617          	auipc	a2,0x2
    80006218:	5b460613          	addi	a2,a2,1460 # 800087c8 <digits>
    8000621c:	883a                	mv	a6,a4
    8000621e:	2705                	addiw	a4,a4,1
    80006220:	02b577bb          	remuw	a5,a0,a1
    80006224:	1782                	slli	a5,a5,0x20
    80006226:	9381                	srli	a5,a5,0x20
    80006228:	97b2                	add	a5,a5,a2
    8000622a:	0007c783          	lbu	a5,0(a5)
    8000622e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006232:	0005079b          	sext.w	a5,a0
    80006236:	02b5553b          	divuw	a0,a0,a1
    8000623a:	0685                	addi	a3,a3,1
    8000623c:	feb7f0e3          	bgeu	a5,a1,8000621c <printint+0x26>

  if(sign)
    80006240:	00088b63          	beqz	a7,80006256 <printint+0x60>
    buf[i++] = '-';
    80006244:	fe040793          	addi	a5,s0,-32
    80006248:	973e                	add	a4,a4,a5
    8000624a:	02d00793          	li	a5,45
    8000624e:	fef70823          	sb	a5,-16(a4)
    80006252:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006256:	02e05763          	blez	a4,80006284 <printint+0x8e>
    8000625a:	fd040793          	addi	a5,s0,-48
    8000625e:	00e784b3          	add	s1,a5,a4
    80006262:	fff78913          	addi	s2,a5,-1
    80006266:	993a                	add	s2,s2,a4
    80006268:	377d                	addiw	a4,a4,-1
    8000626a:	1702                	slli	a4,a4,0x20
    8000626c:	9301                	srli	a4,a4,0x20
    8000626e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006272:	fff4c503          	lbu	a0,-1(s1)
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	d60080e7          	jalr	-672(ra) # 80005fd6 <consputc>
  while(--i >= 0)
    8000627e:	14fd                	addi	s1,s1,-1
    80006280:	ff2499e3          	bne	s1,s2,80006272 <printint+0x7c>
}
    80006284:	70a2                	ld	ra,40(sp)
    80006286:	7402                	ld	s0,32(sp)
    80006288:	64e2                	ld	s1,24(sp)
    8000628a:	6942                	ld	s2,16(sp)
    8000628c:	6145                	addi	sp,sp,48
    8000628e:	8082                	ret
    x = -xx;
    80006290:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006294:	4885                	li	a7,1
    x = -xx;
    80006296:	bf9d                	j	8000620c <printint+0x16>

0000000080006298 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006298:	1101                	addi	sp,sp,-32
    8000629a:	ec06                	sd	ra,24(sp)
    8000629c:	e822                	sd	s0,16(sp)
    8000629e:	e426                	sd	s1,8(sp)
    800062a0:	1000                	addi	s0,sp,32
    800062a2:	84aa                	mv	s1,a0
  pr.locking = 0;
    800062a4:	00028797          	auipc	a5,0x28
    800062a8:	f407ae23          	sw	zero,-164(a5) # 8002e200 <pr+0x18>
  printf("panic: ");
    800062ac:	00002517          	auipc	a0,0x2
    800062b0:	4f450513          	addi	a0,a0,1268 # 800087a0 <syscalls+0x3f0>
    800062b4:	00000097          	auipc	ra,0x0
    800062b8:	02e080e7          	jalr	46(ra) # 800062e2 <printf>
  printf(s);
    800062bc:	8526                	mv	a0,s1
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	024080e7          	jalr	36(ra) # 800062e2 <printf>
  printf("\n");
    800062c6:	00002517          	auipc	a0,0x2
    800062ca:	d8250513          	addi	a0,a0,-638 # 80008048 <etext+0x48>
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	014080e7          	jalr	20(ra) # 800062e2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062d6:	4785                	li	a5,1
    800062d8:	00003717          	auipc	a4,0x3
    800062dc:	d4f72223          	sw	a5,-700(a4) # 8000901c <panicked>
  for(;;)
    800062e0:	a001                	j	800062e0 <panic+0x48>

00000000800062e2 <printf>:
{
    800062e2:	7131                	addi	sp,sp,-192
    800062e4:	fc86                	sd	ra,120(sp)
    800062e6:	f8a2                	sd	s0,112(sp)
    800062e8:	f4a6                	sd	s1,104(sp)
    800062ea:	f0ca                	sd	s2,96(sp)
    800062ec:	ecce                	sd	s3,88(sp)
    800062ee:	e8d2                	sd	s4,80(sp)
    800062f0:	e4d6                	sd	s5,72(sp)
    800062f2:	e0da                	sd	s6,64(sp)
    800062f4:	fc5e                	sd	s7,56(sp)
    800062f6:	f862                	sd	s8,48(sp)
    800062f8:	f466                	sd	s9,40(sp)
    800062fa:	f06a                	sd	s10,32(sp)
    800062fc:	ec6e                	sd	s11,24(sp)
    800062fe:	0100                	addi	s0,sp,128
    80006300:	8a2a                	mv	s4,a0
    80006302:	e40c                	sd	a1,8(s0)
    80006304:	e810                	sd	a2,16(s0)
    80006306:	ec14                	sd	a3,24(s0)
    80006308:	f018                	sd	a4,32(s0)
    8000630a:	f41c                	sd	a5,40(s0)
    8000630c:	03043823          	sd	a6,48(s0)
    80006310:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006314:	00028d97          	auipc	s11,0x28
    80006318:	eecdad83          	lw	s11,-276(s11) # 8002e200 <pr+0x18>
  if(locking)
    8000631c:	020d9b63          	bnez	s11,80006352 <printf+0x70>
  if (fmt == 0)
    80006320:	040a0263          	beqz	s4,80006364 <printf+0x82>
  va_start(ap, fmt);
    80006324:	00840793          	addi	a5,s0,8
    80006328:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000632c:	000a4503          	lbu	a0,0(s4)
    80006330:	16050263          	beqz	a0,80006494 <printf+0x1b2>
    80006334:	4481                	li	s1,0
    if(c != '%'){
    80006336:	02500a93          	li	s5,37
    switch(c){
    8000633a:	07000b13          	li	s6,112
  consputc('x');
    8000633e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006340:	00002b97          	auipc	s7,0x2
    80006344:	488b8b93          	addi	s7,s7,1160 # 800087c8 <digits>
    switch(c){
    80006348:	07300c93          	li	s9,115
    8000634c:	06400c13          	li	s8,100
    80006350:	a82d                	j	8000638a <printf+0xa8>
    acquire(&pr.lock);
    80006352:	00028517          	auipc	a0,0x28
    80006356:	e9650513          	addi	a0,a0,-362 # 8002e1e8 <pr>
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	488080e7          	jalr	1160(ra) # 800067e2 <acquire>
    80006362:	bf7d                	j	80006320 <printf+0x3e>
    panic("null fmt");
    80006364:	00002517          	auipc	a0,0x2
    80006368:	44c50513          	addi	a0,a0,1100 # 800087b0 <syscalls+0x400>
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	f2c080e7          	jalr	-212(ra) # 80006298 <panic>
      consputc(c);
    80006374:	00000097          	auipc	ra,0x0
    80006378:	c62080e7          	jalr	-926(ra) # 80005fd6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000637c:	2485                	addiw	s1,s1,1
    8000637e:	009a07b3          	add	a5,s4,s1
    80006382:	0007c503          	lbu	a0,0(a5)
    80006386:	10050763          	beqz	a0,80006494 <printf+0x1b2>
    if(c != '%'){
    8000638a:	ff5515e3          	bne	a0,s5,80006374 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000638e:	2485                	addiw	s1,s1,1
    80006390:	009a07b3          	add	a5,s4,s1
    80006394:	0007c783          	lbu	a5,0(a5)
    80006398:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000639c:	cfe5                	beqz	a5,80006494 <printf+0x1b2>
    switch(c){
    8000639e:	05678a63          	beq	a5,s6,800063f2 <printf+0x110>
    800063a2:	02fb7663          	bgeu	s6,a5,800063ce <printf+0xec>
    800063a6:	09978963          	beq	a5,s9,80006438 <printf+0x156>
    800063aa:	07800713          	li	a4,120
    800063ae:	0ce79863          	bne	a5,a4,8000647e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800063b2:	f8843783          	ld	a5,-120(s0)
    800063b6:	00878713          	addi	a4,a5,8
    800063ba:	f8e43423          	sd	a4,-120(s0)
    800063be:	4605                	li	a2,1
    800063c0:	85ea                	mv	a1,s10
    800063c2:	4388                	lw	a0,0(a5)
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	e32080e7          	jalr	-462(ra) # 800061f6 <printint>
      break;
    800063cc:	bf45                	j	8000637c <printf+0x9a>
    switch(c){
    800063ce:	0b578263          	beq	a5,s5,80006472 <printf+0x190>
    800063d2:	0b879663          	bne	a5,s8,8000647e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800063d6:	f8843783          	ld	a5,-120(s0)
    800063da:	00878713          	addi	a4,a5,8
    800063de:	f8e43423          	sd	a4,-120(s0)
    800063e2:	4605                	li	a2,1
    800063e4:	45a9                	li	a1,10
    800063e6:	4388                	lw	a0,0(a5)
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	e0e080e7          	jalr	-498(ra) # 800061f6 <printint>
      break;
    800063f0:	b771                	j	8000637c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800063f2:	f8843783          	ld	a5,-120(s0)
    800063f6:	00878713          	addi	a4,a5,8
    800063fa:	f8e43423          	sd	a4,-120(s0)
    800063fe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006402:	03000513          	li	a0,48
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	bd0080e7          	jalr	-1072(ra) # 80005fd6 <consputc>
  consputc('x');
    8000640e:	07800513          	li	a0,120
    80006412:	00000097          	auipc	ra,0x0
    80006416:	bc4080e7          	jalr	-1084(ra) # 80005fd6 <consputc>
    8000641a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000641c:	03c9d793          	srli	a5,s3,0x3c
    80006420:	97de                	add	a5,a5,s7
    80006422:	0007c503          	lbu	a0,0(a5)
    80006426:	00000097          	auipc	ra,0x0
    8000642a:	bb0080e7          	jalr	-1104(ra) # 80005fd6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000642e:	0992                	slli	s3,s3,0x4
    80006430:	397d                	addiw	s2,s2,-1
    80006432:	fe0915e3          	bnez	s2,8000641c <printf+0x13a>
    80006436:	b799                	j	8000637c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006438:	f8843783          	ld	a5,-120(s0)
    8000643c:	00878713          	addi	a4,a5,8
    80006440:	f8e43423          	sd	a4,-120(s0)
    80006444:	0007b903          	ld	s2,0(a5)
    80006448:	00090e63          	beqz	s2,80006464 <printf+0x182>
      for(; *s; s++)
    8000644c:	00094503          	lbu	a0,0(s2)
    80006450:	d515                	beqz	a0,8000637c <printf+0x9a>
        consputc(*s);
    80006452:	00000097          	auipc	ra,0x0
    80006456:	b84080e7          	jalr	-1148(ra) # 80005fd6 <consputc>
      for(; *s; s++)
    8000645a:	0905                	addi	s2,s2,1
    8000645c:	00094503          	lbu	a0,0(s2)
    80006460:	f96d                	bnez	a0,80006452 <printf+0x170>
    80006462:	bf29                	j	8000637c <printf+0x9a>
        s = "(null)";
    80006464:	00002917          	auipc	s2,0x2
    80006468:	34490913          	addi	s2,s2,836 # 800087a8 <syscalls+0x3f8>
      for(; *s; s++)
    8000646c:	02800513          	li	a0,40
    80006470:	b7cd                	j	80006452 <printf+0x170>
      consputc('%');
    80006472:	8556                	mv	a0,s5
    80006474:	00000097          	auipc	ra,0x0
    80006478:	b62080e7          	jalr	-1182(ra) # 80005fd6 <consputc>
      break;
    8000647c:	b701                	j	8000637c <printf+0x9a>
      consputc('%');
    8000647e:	8556                	mv	a0,s5
    80006480:	00000097          	auipc	ra,0x0
    80006484:	b56080e7          	jalr	-1194(ra) # 80005fd6 <consputc>
      consputc(c);
    80006488:	854a                	mv	a0,s2
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	b4c080e7          	jalr	-1204(ra) # 80005fd6 <consputc>
      break;
    80006492:	b5ed                	j	8000637c <printf+0x9a>
  if(locking)
    80006494:	020d9163          	bnez	s11,800064b6 <printf+0x1d4>
}
    80006498:	70e6                	ld	ra,120(sp)
    8000649a:	7446                	ld	s0,112(sp)
    8000649c:	74a6                	ld	s1,104(sp)
    8000649e:	7906                	ld	s2,96(sp)
    800064a0:	69e6                	ld	s3,88(sp)
    800064a2:	6a46                	ld	s4,80(sp)
    800064a4:	6aa6                	ld	s5,72(sp)
    800064a6:	6b06                	ld	s6,64(sp)
    800064a8:	7be2                	ld	s7,56(sp)
    800064aa:	7c42                	ld	s8,48(sp)
    800064ac:	7ca2                	ld	s9,40(sp)
    800064ae:	7d02                	ld	s10,32(sp)
    800064b0:	6de2                	ld	s11,24(sp)
    800064b2:	6129                	addi	sp,sp,192
    800064b4:	8082                	ret
    release(&pr.lock);
    800064b6:	00028517          	auipc	a0,0x28
    800064ba:	d3250513          	addi	a0,a0,-718 # 8002e1e8 <pr>
    800064be:	00000097          	auipc	ra,0x0
    800064c2:	3d8080e7          	jalr	984(ra) # 80006896 <release>
}
    800064c6:	bfc9                	j	80006498 <printf+0x1b6>

00000000800064c8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800064c8:	1101                	addi	sp,sp,-32
    800064ca:	ec06                	sd	ra,24(sp)
    800064cc:	e822                	sd	s0,16(sp)
    800064ce:	e426                	sd	s1,8(sp)
    800064d0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064d2:	00028497          	auipc	s1,0x28
    800064d6:	d1648493          	addi	s1,s1,-746 # 8002e1e8 <pr>
    800064da:	00002597          	auipc	a1,0x2
    800064de:	2e658593          	addi	a1,a1,742 # 800087c0 <syscalls+0x410>
    800064e2:	8526                	mv	a0,s1
    800064e4:	00000097          	auipc	ra,0x0
    800064e8:	26e080e7          	jalr	622(ra) # 80006752 <initlock>
  pr.locking = 1;
    800064ec:	4785                	li	a5,1
    800064ee:	cc9c                	sw	a5,24(s1)
}
    800064f0:	60e2                	ld	ra,24(sp)
    800064f2:	6442                	ld	s0,16(sp)
    800064f4:	64a2                	ld	s1,8(sp)
    800064f6:	6105                	addi	sp,sp,32
    800064f8:	8082                	ret

00000000800064fa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800064fa:	1141                	addi	sp,sp,-16
    800064fc:	e406                	sd	ra,8(sp)
    800064fe:	e022                	sd	s0,0(sp)
    80006500:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006502:	100007b7          	lui	a5,0x10000
    80006506:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000650a:	f8000713          	li	a4,-128
    8000650e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006512:	470d                	li	a4,3
    80006514:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006518:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000651c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006520:	469d                	li	a3,7
    80006522:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006526:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000652a:	00002597          	auipc	a1,0x2
    8000652e:	2b658593          	addi	a1,a1,694 # 800087e0 <digits+0x18>
    80006532:	00028517          	auipc	a0,0x28
    80006536:	cd650513          	addi	a0,a0,-810 # 8002e208 <uart_tx_lock>
    8000653a:	00000097          	auipc	ra,0x0
    8000653e:	218080e7          	jalr	536(ra) # 80006752 <initlock>
}
    80006542:	60a2                	ld	ra,8(sp)
    80006544:	6402                	ld	s0,0(sp)
    80006546:	0141                	addi	sp,sp,16
    80006548:	8082                	ret

000000008000654a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000654a:	1101                	addi	sp,sp,-32
    8000654c:	ec06                	sd	ra,24(sp)
    8000654e:	e822                	sd	s0,16(sp)
    80006550:	e426                	sd	s1,8(sp)
    80006552:	1000                	addi	s0,sp,32
    80006554:	84aa                	mv	s1,a0
  push_off();
    80006556:	00000097          	auipc	ra,0x0
    8000655a:	240080e7          	jalr	576(ra) # 80006796 <push_off>

  if(panicked){
    8000655e:	00003797          	auipc	a5,0x3
    80006562:	abe7a783          	lw	a5,-1346(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006566:	10000737          	lui	a4,0x10000
  if(panicked){
    8000656a:	c391                	beqz	a5,8000656e <uartputc_sync+0x24>
    for(;;)
    8000656c:	a001                	j	8000656c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000656e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006572:	0ff7f793          	andi	a5,a5,255
    80006576:	0207f793          	andi	a5,a5,32
    8000657a:	dbf5                	beqz	a5,8000656e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000657c:	0ff4f793          	andi	a5,s1,255
    80006580:	10000737          	lui	a4,0x10000
    80006584:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006588:	00000097          	auipc	ra,0x0
    8000658c:	2ae080e7          	jalr	686(ra) # 80006836 <pop_off>
}
    80006590:	60e2                	ld	ra,24(sp)
    80006592:	6442                	ld	s0,16(sp)
    80006594:	64a2                	ld	s1,8(sp)
    80006596:	6105                	addi	sp,sp,32
    80006598:	8082                	ret

000000008000659a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000659a:	00003717          	auipc	a4,0x3
    8000659e:	a8673703          	ld	a4,-1402(a4) # 80009020 <uart_tx_r>
    800065a2:	00003797          	auipc	a5,0x3
    800065a6:	a867b783          	ld	a5,-1402(a5) # 80009028 <uart_tx_w>
    800065aa:	06e78c63          	beq	a5,a4,80006622 <uartstart+0x88>
{
    800065ae:	7139                	addi	sp,sp,-64
    800065b0:	fc06                	sd	ra,56(sp)
    800065b2:	f822                	sd	s0,48(sp)
    800065b4:	f426                	sd	s1,40(sp)
    800065b6:	f04a                	sd	s2,32(sp)
    800065b8:	ec4e                	sd	s3,24(sp)
    800065ba:	e852                	sd	s4,16(sp)
    800065bc:	e456                	sd	s5,8(sp)
    800065be:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065c0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065c4:	00028a17          	auipc	s4,0x28
    800065c8:	c44a0a13          	addi	s4,s4,-956 # 8002e208 <uart_tx_lock>
    uart_tx_r += 1;
    800065cc:	00003497          	auipc	s1,0x3
    800065d0:	a5448493          	addi	s1,s1,-1452 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800065d4:	00003997          	auipc	s3,0x3
    800065d8:	a5498993          	addi	s3,s3,-1452 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065dc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800065e0:	0ff7f793          	andi	a5,a5,255
    800065e4:	0207f793          	andi	a5,a5,32
    800065e8:	c785                	beqz	a5,80006610 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065ea:	01f77793          	andi	a5,a4,31
    800065ee:	97d2                	add	a5,a5,s4
    800065f0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800065f4:	0705                	addi	a4,a4,1
    800065f6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800065f8:	8526                	mv	a0,s1
    800065fa:	ffffb097          	auipc	ra,0xffffb
    800065fe:	0bc080e7          	jalr	188(ra) # 800016b6 <wakeup>
    
    WriteReg(THR, c);
    80006602:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006606:	6098                	ld	a4,0(s1)
    80006608:	0009b783          	ld	a5,0(s3)
    8000660c:	fce798e3          	bne	a5,a4,800065dc <uartstart+0x42>
  }
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
    80006622:	8082                	ret

0000000080006624 <uartputc>:
{
    80006624:	7179                	addi	sp,sp,-48
    80006626:	f406                	sd	ra,40(sp)
    80006628:	f022                	sd	s0,32(sp)
    8000662a:	ec26                	sd	s1,24(sp)
    8000662c:	e84a                	sd	s2,16(sp)
    8000662e:	e44e                	sd	s3,8(sp)
    80006630:	e052                	sd	s4,0(sp)
    80006632:	1800                	addi	s0,sp,48
    80006634:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006636:	00028517          	auipc	a0,0x28
    8000663a:	bd250513          	addi	a0,a0,-1070 # 8002e208 <uart_tx_lock>
    8000663e:	00000097          	auipc	ra,0x0
    80006642:	1a4080e7          	jalr	420(ra) # 800067e2 <acquire>
  if(panicked){
    80006646:	00003797          	auipc	a5,0x3
    8000664a:	9d67a783          	lw	a5,-1578(a5) # 8000901c <panicked>
    8000664e:	c391                	beqz	a5,80006652 <uartputc+0x2e>
    for(;;)
    80006650:	a001                	j	80006650 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006652:	00003797          	auipc	a5,0x3
    80006656:	9d67b783          	ld	a5,-1578(a5) # 80009028 <uart_tx_w>
    8000665a:	00003717          	auipc	a4,0x3
    8000665e:	9c673703          	ld	a4,-1594(a4) # 80009020 <uart_tx_r>
    80006662:	02070713          	addi	a4,a4,32
    80006666:	02f71b63          	bne	a4,a5,8000669c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000666a:	00028a17          	auipc	s4,0x28
    8000666e:	b9ea0a13          	addi	s4,s4,-1122 # 8002e208 <uart_tx_lock>
    80006672:	00003497          	auipc	s1,0x3
    80006676:	9ae48493          	addi	s1,s1,-1618 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000667a:	00003917          	auipc	s2,0x3
    8000667e:	9ae90913          	addi	s2,s2,-1618 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006682:	85d2                	mv	a1,s4
    80006684:	8526                	mv	a0,s1
    80006686:	ffffb097          	auipc	ra,0xffffb
    8000668a:	ea4080e7          	jalr	-348(ra) # 8000152a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000668e:	00093783          	ld	a5,0(s2)
    80006692:	6098                	ld	a4,0(s1)
    80006694:	02070713          	addi	a4,a4,32
    80006698:	fef705e3          	beq	a4,a5,80006682 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000669c:	00028497          	auipc	s1,0x28
    800066a0:	b6c48493          	addi	s1,s1,-1172 # 8002e208 <uart_tx_lock>
    800066a4:	01f7f713          	andi	a4,a5,31
    800066a8:	9726                	add	a4,a4,s1
    800066aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800066ae:	0785                	addi	a5,a5,1
    800066b0:	00003717          	auipc	a4,0x3
    800066b4:	96f73c23          	sd	a5,-1672(a4) # 80009028 <uart_tx_w>
      uartstart();
    800066b8:	00000097          	auipc	ra,0x0
    800066bc:	ee2080e7          	jalr	-286(ra) # 8000659a <uartstart>
      release(&uart_tx_lock);
    800066c0:	8526                	mv	a0,s1
    800066c2:	00000097          	auipc	ra,0x0
    800066c6:	1d4080e7          	jalr	468(ra) # 80006896 <release>
}
    800066ca:	70a2                	ld	ra,40(sp)
    800066cc:	7402                	ld	s0,32(sp)
    800066ce:	64e2                	ld	s1,24(sp)
    800066d0:	6942                	ld	s2,16(sp)
    800066d2:	69a2                	ld	s3,8(sp)
    800066d4:	6a02                	ld	s4,0(sp)
    800066d6:	6145                	addi	sp,sp,48
    800066d8:	8082                	ret

00000000800066da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800066da:	1141                	addi	sp,sp,-16
    800066dc:	e422                	sd	s0,8(sp)
    800066de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800066e0:	100007b7          	lui	a5,0x10000
    800066e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800066e8:	8b85                	andi	a5,a5,1
    800066ea:	cb91                	beqz	a5,800066fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800066ec:	100007b7          	lui	a5,0x10000
    800066f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800066f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800066f8:	6422                	ld	s0,8(sp)
    800066fa:	0141                	addi	sp,sp,16
    800066fc:	8082                	ret
    return -1;
    800066fe:	557d                	li	a0,-1
    80006700:	bfe5                	j	800066f8 <uartgetc+0x1e>

0000000080006702 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006702:	1101                	addi	sp,sp,-32
    80006704:	ec06                	sd	ra,24(sp)
    80006706:	e822                	sd	s0,16(sp)
    80006708:	e426                	sd	s1,8(sp)
    8000670a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000670c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000670e:	00000097          	auipc	ra,0x0
    80006712:	fcc080e7          	jalr	-52(ra) # 800066da <uartgetc>
    if(c == -1)
    80006716:	00950763          	beq	a0,s1,80006724 <uartintr+0x22>
      break;
    consoleintr(c);
    8000671a:	00000097          	auipc	ra,0x0
    8000671e:	8fe080e7          	jalr	-1794(ra) # 80006018 <consoleintr>
  while(1){
    80006722:	b7f5                	j	8000670e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006724:	00028497          	auipc	s1,0x28
    80006728:	ae448493          	addi	s1,s1,-1308 # 8002e208 <uart_tx_lock>
    8000672c:	8526                	mv	a0,s1
    8000672e:	00000097          	auipc	ra,0x0
    80006732:	0b4080e7          	jalr	180(ra) # 800067e2 <acquire>
  uartstart();
    80006736:	00000097          	auipc	ra,0x0
    8000673a:	e64080e7          	jalr	-412(ra) # 8000659a <uartstart>
  release(&uart_tx_lock);
    8000673e:	8526                	mv	a0,s1
    80006740:	00000097          	auipc	ra,0x0
    80006744:	156080e7          	jalr	342(ra) # 80006896 <release>
}
    80006748:	60e2                	ld	ra,24(sp)
    8000674a:	6442                	ld	s0,16(sp)
    8000674c:	64a2                	ld	s1,8(sp)
    8000674e:	6105                	addi	sp,sp,32
    80006750:	8082                	ret

0000000080006752 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006752:	1141                	addi	sp,sp,-16
    80006754:	e422                	sd	s0,8(sp)
    80006756:	0800                	addi	s0,sp,16
  lk->name = name;
    80006758:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000675a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000675e:	00053823          	sd	zero,16(a0)
}
    80006762:	6422                	ld	s0,8(sp)
    80006764:	0141                	addi	sp,sp,16
    80006766:	8082                	ret

0000000080006768 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006768:	411c                	lw	a5,0(a0)
    8000676a:	e399                	bnez	a5,80006770 <holding+0x8>
    8000676c:	4501                	li	a0,0
  return r;
}
    8000676e:	8082                	ret
{
    80006770:	1101                	addi	sp,sp,-32
    80006772:	ec06                	sd	ra,24(sp)
    80006774:	e822                	sd	s0,16(sp)
    80006776:	e426                	sd	s1,8(sp)
    80006778:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000677a:	6904                	ld	s1,16(a0)
    8000677c:	ffffa097          	auipc	ra,0xffffa
    80006780:	692080e7          	jalr	1682(ra) # 80000e0e <mycpu>
    80006784:	40a48533          	sub	a0,s1,a0
    80006788:	00153513          	seqz	a0,a0
}
    8000678c:	60e2                	ld	ra,24(sp)
    8000678e:	6442                	ld	s0,16(sp)
    80006790:	64a2                	ld	s1,8(sp)
    80006792:	6105                	addi	sp,sp,32
    80006794:	8082                	ret

0000000080006796 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006796:	1101                	addi	sp,sp,-32
    80006798:	ec06                	sd	ra,24(sp)
    8000679a:	e822                	sd	s0,16(sp)
    8000679c:	e426                	sd	s1,8(sp)
    8000679e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067a0:	100024f3          	csrr	s1,sstatus
    800067a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800067a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800067ae:	ffffa097          	auipc	ra,0xffffa
    800067b2:	660080e7          	jalr	1632(ra) # 80000e0e <mycpu>
    800067b6:	5d3c                	lw	a5,120(a0)
    800067b8:	cf89                	beqz	a5,800067d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800067ba:	ffffa097          	auipc	ra,0xffffa
    800067be:	654080e7          	jalr	1620(ra) # 80000e0e <mycpu>
    800067c2:	5d3c                	lw	a5,120(a0)
    800067c4:	2785                	addiw	a5,a5,1
    800067c6:	dd3c                	sw	a5,120(a0)
}
    800067c8:	60e2                	ld	ra,24(sp)
    800067ca:	6442                	ld	s0,16(sp)
    800067cc:	64a2                	ld	s1,8(sp)
    800067ce:	6105                	addi	sp,sp,32
    800067d0:	8082                	ret
    mycpu()->intena = old;
    800067d2:	ffffa097          	auipc	ra,0xffffa
    800067d6:	63c080e7          	jalr	1596(ra) # 80000e0e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800067da:	8085                	srli	s1,s1,0x1
    800067dc:	8885                	andi	s1,s1,1
    800067de:	dd64                	sw	s1,124(a0)
    800067e0:	bfe9                	j	800067ba <push_off+0x24>

00000000800067e2 <acquire>:
{
    800067e2:	1101                	addi	sp,sp,-32
    800067e4:	ec06                	sd	ra,24(sp)
    800067e6:	e822                	sd	s0,16(sp)
    800067e8:	e426                	sd	s1,8(sp)
    800067ea:	1000                	addi	s0,sp,32
    800067ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800067ee:	00000097          	auipc	ra,0x0
    800067f2:	fa8080e7          	jalr	-88(ra) # 80006796 <push_off>
  if(holding(lk))
    800067f6:	8526                	mv	a0,s1
    800067f8:	00000097          	auipc	ra,0x0
    800067fc:	f70080e7          	jalr	-144(ra) # 80006768 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006800:	4705                	li	a4,1
  if(holding(lk))
    80006802:	e115                	bnez	a0,80006826 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006804:	87ba                	mv	a5,a4
    80006806:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000680a:	2781                	sext.w	a5,a5
    8000680c:	ffe5                	bnez	a5,80006804 <acquire+0x22>
  __sync_synchronize();
    8000680e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006812:	ffffa097          	auipc	ra,0xffffa
    80006816:	5fc080e7          	jalr	1532(ra) # 80000e0e <mycpu>
    8000681a:	e888                	sd	a0,16(s1)
}
    8000681c:	60e2                	ld	ra,24(sp)
    8000681e:	6442                	ld	s0,16(sp)
    80006820:	64a2                	ld	s1,8(sp)
    80006822:	6105                	addi	sp,sp,32
    80006824:	8082                	ret
    panic("acquire");
    80006826:	00002517          	auipc	a0,0x2
    8000682a:	fc250513          	addi	a0,a0,-62 # 800087e8 <digits+0x20>
    8000682e:	00000097          	auipc	ra,0x0
    80006832:	a6a080e7          	jalr	-1430(ra) # 80006298 <panic>

0000000080006836 <pop_off>:

void
pop_off(void)
{
    80006836:	1141                	addi	sp,sp,-16
    80006838:	e406                	sd	ra,8(sp)
    8000683a:	e022                	sd	s0,0(sp)
    8000683c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000683e:	ffffa097          	auipc	ra,0xffffa
    80006842:	5d0080e7          	jalr	1488(ra) # 80000e0e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006846:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000684a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000684c:	e78d                	bnez	a5,80006876 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000684e:	5d3c                	lw	a5,120(a0)
    80006850:	02f05b63          	blez	a5,80006886 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006854:	37fd                	addiw	a5,a5,-1
    80006856:	0007871b          	sext.w	a4,a5
    8000685a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000685c:	eb09                	bnez	a4,8000686e <pop_off+0x38>
    8000685e:	5d7c                	lw	a5,124(a0)
    80006860:	c799                	beqz	a5,8000686e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006862:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006866:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000686a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000686e:	60a2                	ld	ra,8(sp)
    80006870:	6402                	ld	s0,0(sp)
    80006872:	0141                	addi	sp,sp,16
    80006874:	8082                	ret
    panic("pop_off - interruptible");
    80006876:	00002517          	auipc	a0,0x2
    8000687a:	f7a50513          	addi	a0,a0,-134 # 800087f0 <digits+0x28>
    8000687e:	00000097          	auipc	ra,0x0
    80006882:	a1a080e7          	jalr	-1510(ra) # 80006298 <panic>
    panic("pop_off");
    80006886:	00002517          	auipc	a0,0x2
    8000688a:	f8250513          	addi	a0,a0,-126 # 80008808 <digits+0x40>
    8000688e:	00000097          	auipc	ra,0x0
    80006892:	a0a080e7          	jalr	-1526(ra) # 80006298 <panic>

0000000080006896 <release>:
{
    80006896:	1101                	addi	sp,sp,-32
    80006898:	ec06                	sd	ra,24(sp)
    8000689a:	e822                	sd	s0,16(sp)
    8000689c:	e426                	sd	s1,8(sp)
    8000689e:	1000                	addi	s0,sp,32
    800068a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800068a2:	00000097          	auipc	ra,0x0
    800068a6:	ec6080e7          	jalr	-314(ra) # 80006768 <holding>
    800068aa:	c115                	beqz	a0,800068ce <release+0x38>
  lk->cpu = 0;
    800068ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800068b4:	0f50000f          	fence	iorw,ow
    800068b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800068bc:	00000097          	auipc	ra,0x0
    800068c0:	f7a080e7          	jalr	-134(ra) # 80006836 <pop_off>
}
    800068c4:	60e2                	ld	ra,24(sp)
    800068c6:	6442                	ld	s0,16(sp)
    800068c8:	64a2                	ld	s1,8(sp)
    800068ca:	6105                	addi	sp,sp,32
    800068cc:	8082                	ret
    panic("release");
    800068ce:	00002517          	auipc	a0,0x2
    800068d2:	f4250513          	addi	a0,a0,-190 # 80008810 <digits+0x48>
    800068d6:	00000097          	auipc	ra,0x0
    800068da:	9c2080e7          	jalr	-1598(ra) # 80006298 <panic>
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
