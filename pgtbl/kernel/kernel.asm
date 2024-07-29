
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	742050ef          	jal	ra,80005758 <start>

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
    8000005e:	15c080e7          	jalr	348(ra) # 800061b6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1fc080e7          	jalr	508(ra) # 8000626a <release>
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
    8000008e:	b7e080e7          	jalr	-1154(ra) # 80005c08 <panic>

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
    800000f8:	032080e7          	jalr	50(ra) # 80006126 <initlock>
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
    80000130:	08a080e7          	jalr	138(ra) # 800061b6 <acquire>
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
    80000148:	126080e7          	jalr	294(ra) # 8000626a <release>

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
    80000172:	0fc080e7          	jalr	252(ra) # 8000626a <release>
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
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
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
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	8fe080e7          	jalr	-1794(ra) # 80005c5a <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	738080e7          	jalr	1848(ra) # 80001aa4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d6c080e7          	jalr	-660(ra) # 800050e0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fe6080e7          	jalr	-26(ra) # 80001362 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	796080e7          	jalr	1942(ra) # 80005b1a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b10080e7          	jalr	-1264(ra) # 80005e9c <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	8be080e7          	jalr	-1858(ra) # 80005c5a <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	8ae080e7          	jalr	-1874(ra) # 80005c5a <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	89e080e7          	jalr	-1890(ra) # 80005c5a <printf>
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
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	698080e7          	jalr	1688(ra) # 80001a7c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b8080e7          	jalr	1720(ra) # 80001aa4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cd6080e7          	jalr	-810(ra) # 800050ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ce4080e7          	jalr	-796(ra) # 800050e0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	ebe080e7          	jalr	-322(ra) # 800022c2 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	54e080e7          	jalr	1358(ra) # 8000295a <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	4f8080e7          	jalr	1272(ra) # 8000390c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	de6080e7          	jalr	-538(ra) # 80005202 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0c080e7          	jalr	-756(ra) # 80001130 <userinit>
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
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	77a080e7          	jalr	1914(ra) # 80005c08 <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	682080e7          	jalr	1666(ra) # 80005c08 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	672080e7          	jalr	1650(ra) # 80005c08 <panic>
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
    80000614:	5f8080e7          	jalr	1528(ra) # 80005c08 <panic>

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
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
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
    80000760:	4ac080e7          	jalr	1196(ra) # 80005c08 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	49c080e7          	jalr	1180(ra) # 80005c08 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	48c080e7          	jalr	1164(ra) # 80005c08 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	47c080e7          	jalr	1148(ra) # 80005c08 <panic>
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
    8000086e:	39e080e7          	jalr	926(ra) # 80005c08 <panic>

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
    800009b0:	25c080e7          	jalr	604(ra) # 80005c08 <panic>
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
    80000a8c:	180080e7          	jalr	384(ra) # 80005c08 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	170080e7          	jalr	368(ra) # 80005c08 <panic>
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
    80000b06:	106080e7          	jalr	262(ra) # 80005c08 <panic>

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

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	0000fa17          	auipc	s4,0xf
    80000d0a:	97aa0a13          	addi	s4,s4,-1670 # 8000f680 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	18848493          	addi	s1,s1,392
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	ea4080e7          	jalr	-348(ra) # 80005c08 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	396080e7          	jalr	918(ra) # 80006126 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	37e080e7          	jalr	894(ra) # 80006126 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	0000f997          	auipc	s3,0xf
    80000dd6:	8ae98993          	addi	s3,s3,-1874 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	348080e7          	jalr	840(ra) # 80006126 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	18848493          	addi	s1,s1,392
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	318080e7          	jalr	792(ra) # 8000616a <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	39e080e7          	jalr	926(ra) # 8000620a <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	3da080e7          	jalr	986(ra) # 8000626a <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9987a783          	lw	a5,-1640(a5) # 80008830 <first.1681>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c1a080e7          	jalr	-998(ra) # 80001abc <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607af23          	sw	zero,-1666(a5) # 80008830 <first.1681>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	a1e080e7          	jalr	-1506(ra) # 800028da <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	2da080e7          	jalr	730(ra) # 800061b6 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	95078793          	addi	a5,a5,-1712 # 80008834 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	374080e7          	jalr	884(ra) # 8000626a <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	0000e917          	auipc	s2,0xe
    8000106a:	61a90913          	addi	s2,s2,1562 # 8000f680 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	146080e7          	jalr	326(ra) # 800061b6 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	1ec080e7          	jalr	492(ra) # 8000626a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	18848493          	addi	s1,s1,392
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a08d                	j	800010f2 <allocproc+0xa0>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c931                	beqz	a0,80001100 <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	cd31                	beqz	a0,80001118 <allocproc+0xc6>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
  p->interval = 0;
    800010e2:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    800010e6:	1604b823          	sd	zero,368(s1)
  p->passedticks = 0;
    800010ea:	1604ac23          	sw	zero,376(s1)
  p->trapframecopy = 0;
    800010ee:	1804b023          	sd	zero,384(s1)
}
    800010f2:	8526                	mv	a0,s1
    800010f4:	60e2                	ld	ra,24(sp)
    800010f6:	6442                	ld	s0,16(sp)
    800010f8:	64a2                	ld	s1,8(sp)
    800010fa:	6902                	ld	s2,0(sp)
    800010fc:	6105                	addi	sp,sp,32
    800010fe:	8082                	ret
    freeproc(p);
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	ef8080e7          	jalr	-264(ra) # 80000ffa <freeproc>
    release(&p->lock);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	15e080e7          	jalr	350(ra) # 8000626a <release>
    return 0;
    80001114:	84ca                	mv	s1,s2
    80001116:	bff1                	j	800010f2 <allocproc+0xa0>
    freeproc(p);
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	ee0080e7          	jalr	-288(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001122:	8526                	mv	a0,s1
    80001124:	00005097          	auipc	ra,0x5
    80001128:	146080e7          	jalr	326(ra) # 8000626a <release>
    return 0;
    8000112c:	84ca                	mv	s1,s2
    8000112e:	b7d1                	j	800010f2 <allocproc+0xa0>

0000000080001130 <userinit>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f18080e7          	jalr	-232(ra) # 80001052 <allocproc>
    80001142:	84aa                	mv	s1,a0
  initproc = p;
    80001144:	00008797          	auipc	a5,0x8
    80001148:	eca7b623          	sd	a0,-308(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000114c:	03400613          	li	a2,52
    80001150:	00007597          	auipc	a1,0x7
    80001154:	6f058593          	addi	a1,a1,1776 # 80008840 <initcode>
    80001158:	6928                	ld	a0,80(a0)
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	6a6080e7          	jalr	1702(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001162:	6785                	lui	a5,0x1
    80001164:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116c:	6cb8                	ld	a4,88(s1)
    8000116e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001170:	4641                	li	a2,16
    80001172:	00007597          	auipc	a1,0x7
    80001176:	00e58593          	addi	a1,a1,14 # 80008180 <etext+0x180>
    8000117a:	15848513          	addi	a0,s1,344
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	14c080e7          	jalr	332(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	00a50513          	addi	a0,a0,10 # 80008190 <etext+0x190>
    8000118e:	00002097          	auipc	ra,0x2
    80001192:	17a080e7          	jalr	378(ra) # 80003308 <namei>
    80001196:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119a:	478d                	li	a5,3
    8000119c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	0ca080e7          	jalr	202(ra) # 8000626a <release>
}
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret

00000000800011b2 <growproc>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	e04a                	sd	s2,0(sp)
    800011bc:	1000                	addi	s0,sp,32
    800011be:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	c88080e7          	jalr	-888(ra) # 80000e48 <myproc>
    800011c8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ca:	652c                	ld	a1,72(a0)
    800011cc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011d0:	00904f63          	bgtz	s1,800011ee <growproc+0x3c>
  } else if(n < 0){
    800011d4:	0204cc63          	bltz	s1,8000120c <growproc+0x5a>
  p->sz = sz;
    800011d8:	1602                	slli	a2,a2,0x20
    800011da:	9201                	srli	a2,a2,0x20
    800011dc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011e0:	4501                	li	a0,0
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6902                	ld	s2,0(sp)
    800011ea:	6105                	addi	sp,sp,32
    800011ec:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011ee:	9e25                	addw	a2,a2,s1
    800011f0:	1602                	slli	a2,a2,0x20
    800011f2:	9201                	srli	a2,a2,0x20
    800011f4:	1582                	slli	a1,a1,0x20
    800011f6:	9181                	srli	a1,a1,0x20
    800011f8:	6928                	ld	a0,80(a0)
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	6c0080e7          	jalr	1728(ra) # 800008ba <uvmalloc>
    80001202:	0005061b          	sext.w	a2,a0
    80001206:	fa69                	bnez	a2,800011d8 <growproc+0x26>
      return -1;
    80001208:	557d                	li	a0,-1
    8000120a:	bfe1                	j	800011e2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120c:	9e25                	addw	a2,a2,s1
    8000120e:	1602                	slli	a2,a2,0x20
    80001210:	9201                	srli	a2,a2,0x20
    80001212:	1582                	slli	a1,a1,0x20
    80001214:	9181                	srli	a1,a1,0x20
    80001216:	6928                	ld	a0,80(a0)
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	65a080e7          	jalr	1626(ra) # 80000872 <uvmdealloc>
    80001220:	0005061b          	sext.w	a2,a0
    80001224:	bf55                	j	800011d8 <growproc+0x26>

0000000080001226 <fork>:
{
    80001226:	7179                	addi	sp,sp,-48
    80001228:	f406                	sd	ra,40(sp)
    8000122a:	f022                	sd	s0,32(sp)
    8000122c:	ec26                	sd	s1,24(sp)
    8000122e:	e84a                	sd	s2,16(sp)
    80001230:	e44e                	sd	s3,8(sp)
    80001232:	e052                	sd	s4,0(sp)
    80001234:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	c12080e7          	jalr	-1006(ra) # 80000e48 <myproc>
    8000123e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001240:	00000097          	auipc	ra,0x0
    80001244:	e12080e7          	jalr	-494(ra) # 80001052 <allocproc>
    80001248:	10050b63          	beqz	a0,8000135e <fork+0x138>
    8000124c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000124e:	04893603          	ld	a2,72(s2)
    80001252:	692c                	ld	a1,80(a0)
    80001254:	05093503          	ld	a0,80(s2)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	7ae080e7          	jalr	1966(ra) # 80000a06 <uvmcopy>
    80001260:	04054663          	bltz	a0,800012ac <fork+0x86>
  np->sz = p->sz;
    80001264:	04893783          	ld	a5,72(s2)
    80001268:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000126c:	05893683          	ld	a3,88(s2)
    80001270:	87b6                	mv	a5,a3
    80001272:	0589b703          	ld	a4,88(s3)
    80001276:	12068693          	addi	a3,a3,288
    8000127a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000127e:	6788                	ld	a0,8(a5)
    80001280:	6b8c                	ld	a1,16(a5)
    80001282:	6f90                	ld	a2,24(a5)
    80001284:	01073023          	sd	a6,0(a4)
    80001288:	e708                	sd	a0,8(a4)
    8000128a:	eb0c                	sd	a1,16(a4)
    8000128c:	ef10                	sd	a2,24(a4)
    8000128e:	02078793          	addi	a5,a5,32
    80001292:	02070713          	addi	a4,a4,32
    80001296:	fed792e3          	bne	a5,a3,8000127a <fork+0x54>
  np->trapframe->a0 = 0;
    8000129a:	0589b783          	ld	a5,88(s3)
    8000129e:	0607b823          	sd	zero,112(a5)
    800012a2:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012a6:	15000a13          	li	s4,336
    800012aa:	a03d                	j	800012d8 <fork+0xb2>
    freeproc(np);
    800012ac:	854e                	mv	a0,s3
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	d4c080e7          	jalr	-692(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012b6:	854e                	mv	a0,s3
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	fb2080e7          	jalr	-78(ra) # 8000626a <release>
    return -1;
    800012c0:	5a7d                	li	s4,-1
    800012c2:	a069                	j	8000134c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c4:	00002097          	auipc	ra,0x2
    800012c8:	6da080e7          	jalr	1754(ra) # 8000399e <filedup>
    800012cc:	009987b3          	add	a5,s3,s1
    800012d0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012d2:	04a1                	addi	s1,s1,8
    800012d4:	01448763          	beq	s1,s4,800012e2 <fork+0xbc>
    if(p->ofile[i])
    800012d8:	009907b3          	add	a5,s2,s1
    800012dc:	6388                	ld	a0,0(a5)
    800012de:	f17d                	bnez	a0,800012c4 <fork+0x9e>
    800012e0:	bfcd                	j	800012d2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012e2:	15093503          	ld	a0,336(s2)
    800012e6:	00002097          	auipc	ra,0x2
    800012ea:	82e080e7          	jalr	-2002(ra) # 80002b14 <idup>
    800012ee:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f2:	4641                	li	a2,16
    800012f4:	15890593          	addi	a1,s2,344
    800012f8:	15898513          	addi	a0,s3,344
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	fce080e7          	jalr	-50(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001304:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001308:	854e                	mv	a0,s3
    8000130a:	00005097          	auipc	ra,0x5
    8000130e:	f60080e7          	jalr	-160(ra) # 8000626a <release>
  acquire(&wait_lock);
    80001312:	00008497          	auipc	s1,0x8
    80001316:	d5648493          	addi	s1,s1,-682 # 80009068 <wait_lock>
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	e9a080e7          	jalr	-358(ra) # 800061b6 <acquire>
  np->parent = p;
    80001324:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	f40080e7          	jalr	-192(ra) # 8000626a <release>
  acquire(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	e82080e7          	jalr	-382(ra) # 800061b6 <acquire>
  np->state = RUNNABLE;
    8000133c:	478d                	li	a5,3
    8000133e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001342:	854e                	mv	a0,s3
    80001344:	00005097          	auipc	ra,0x5
    80001348:	f26080e7          	jalr	-218(ra) # 8000626a <release>
}
    8000134c:	8552                	mv	a0,s4
    8000134e:	70a2                	ld	ra,40(sp)
    80001350:	7402                	ld	s0,32(sp)
    80001352:	64e2                	ld	s1,24(sp)
    80001354:	6942                	ld	s2,16(sp)
    80001356:	69a2                	ld	s3,8(sp)
    80001358:	6a02                	ld	s4,0(sp)
    8000135a:	6145                	addi	sp,sp,48
    8000135c:	8082                	ret
    return -1;
    8000135e:	5a7d                	li	s4,-1
    80001360:	b7f5                	j	8000134c <fork+0x126>

0000000080001362 <scheduler>:
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	ec4e                	sd	s3,24(sp)
    8000136e:	e852                	sd	s4,16(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	e05a                	sd	s6,0(sp)
    80001374:	0080                	addi	s0,sp,64
    80001376:	8792                	mv	a5,tp
  int id = r_tp();
    80001378:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000137a:	00779a93          	slli	s5,a5,0x7
    8000137e:	00008717          	auipc	a4,0x8
    80001382:	cd270713          	addi	a4,a4,-814 # 80009050 <pid_lock>
    80001386:	9756                	add	a4,a4,s5
    80001388:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000138c:	00008717          	auipc	a4,0x8
    80001390:	cfc70713          	addi	a4,a4,-772 # 80009088 <cpus+0x8>
    80001394:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001396:	498d                	li	s3,3
        p->state = RUNNING;
    80001398:	4b11                	li	s6,4
        c->proc = p;
    8000139a:	079e                	slli	a5,a5,0x7
    8000139c:	00008a17          	auipc	s4,0x8
    800013a0:	cb4a0a13          	addi	s4,s4,-844 # 80009050 <pid_lock>
    800013a4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	0000e917          	auipc	s2,0xe
    800013aa:	2da90913          	addi	s2,s2,730 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b6:	10079073          	csrw	sstatus,a5
    800013ba:	00008497          	auipc	s1,0x8
    800013be:	0c648493          	addi	s1,s1,198 # 80009480 <proc>
    800013c2:	a03d                	j	800013f0 <scheduler+0x8e>
        p->state = RUNNING;
    800013c4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013cc:	06048593          	addi	a1,s1,96
    800013d0:	8556                	mv	a0,s5
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	640080e7          	jalr	1600(ra) # 80001a12 <swtch>
        c->proc = 0;
    800013da:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	e8a080e7          	jalr	-374(ra) # 8000626a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	18848493          	addi	s1,s1,392
    800013ec:	fd2481e3          	beq	s1,s2,800013ae <scheduler+0x4c>
      acquire(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	dc4080e7          	jalr	-572(ra) # 800061b6 <acquire>
      if(p->state == RUNNABLE) {
    800013fa:	4c9c                	lw	a5,24(s1)
    800013fc:	ff3791e3          	bne	a5,s3,800013de <scheduler+0x7c>
    80001400:	b7d1                	j	800013c4 <scheduler+0x62>

0000000080001402 <sched>:
{
    80001402:	7179                	addi	sp,sp,-48
    80001404:	f406                	sd	ra,40(sp)
    80001406:	f022                	sd	s0,32(sp)
    80001408:	ec26                	sd	s1,24(sp)
    8000140a:	e84a                	sd	s2,16(sp)
    8000140c:	e44e                	sd	s3,8(sp)
    8000140e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001410:	00000097          	auipc	ra,0x0
    80001414:	a38080e7          	jalr	-1480(ra) # 80000e48 <myproc>
    80001418:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	d22080e7          	jalr	-734(ra) # 8000613c <holding>
    80001422:	c93d                	beqz	a0,80001498 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001424:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001426:	2781                	sext.w	a5,a5
    80001428:	079e                	slli	a5,a5,0x7
    8000142a:	00008717          	auipc	a4,0x8
    8000142e:	c2670713          	addi	a4,a4,-986 # 80009050 <pid_lock>
    80001432:	97ba                	add	a5,a5,a4
    80001434:	0a87a703          	lw	a4,168(a5)
    80001438:	4785                	li	a5,1
    8000143a:	06f71763          	bne	a4,a5,800014a8 <sched+0xa6>
  if(p->state == RUNNING)
    8000143e:	4c98                	lw	a4,24(s1)
    80001440:	4791                	li	a5,4
    80001442:	06f70b63          	beq	a4,a5,800014b8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001446:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000144a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000144c:	efb5                	bnez	a5,800014c8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001450:	00008917          	auipc	s2,0x8
    80001454:	c0090913          	addi	s2,s2,-1024 # 80009050 <pid_lock>
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	97ca                	add	a5,a5,s2
    8000145e:	0ac7a983          	lw	s3,172(a5)
    80001462:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001464:	2781                	sext.w	a5,a5
    80001466:	079e                	slli	a5,a5,0x7
    80001468:	00008597          	auipc	a1,0x8
    8000146c:	c2058593          	addi	a1,a1,-992 # 80009088 <cpus+0x8>
    80001470:	95be                	add	a1,a1,a5
    80001472:	06048513          	addi	a0,s1,96
    80001476:	00000097          	auipc	ra,0x0
    8000147a:	59c080e7          	jalr	1436(ra) # 80001a12 <swtch>
    8000147e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001480:	2781                	sext.w	a5,a5
    80001482:	079e                	slli	a5,a5,0x7
    80001484:	97ca                	add	a5,a5,s2
    80001486:	0b37a623          	sw	s3,172(a5)
}
    8000148a:	70a2                	ld	ra,40(sp)
    8000148c:	7402                	ld	s0,32(sp)
    8000148e:	64e2                	ld	s1,24(sp)
    80001490:	6942                	ld	s2,16(sp)
    80001492:	69a2                	ld	s3,8(sp)
    80001494:	6145                	addi	sp,sp,48
    80001496:	8082                	ret
    panic("sched p->lock");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d0050513          	addi	a0,a0,-768 # 80008198 <etext+0x198>
    800014a0:	00004097          	auipc	ra,0x4
    800014a4:	768080e7          	jalr	1896(ra) # 80005c08 <panic>
    panic("sched locks");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d0050513          	addi	a0,a0,-768 # 800081a8 <etext+0x1a8>
    800014b0:	00004097          	auipc	ra,0x4
    800014b4:	758080e7          	jalr	1880(ra) # 80005c08 <panic>
    panic("sched running");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d0050513          	addi	a0,a0,-768 # 800081b8 <etext+0x1b8>
    800014c0:	00004097          	auipc	ra,0x4
    800014c4:	748080e7          	jalr	1864(ra) # 80005c08 <panic>
    panic("sched interruptible");
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	d0050513          	addi	a0,a0,-768 # 800081c8 <etext+0x1c8>
    800014d0:	00004097          	auipc	ra,0x4
    800014d4:	738080e7          	jalr	1848(ra) # 80005c08 <panic>

00000000800014d8 <yield>:
{
    800014d8:	1101                	addi	sp,sp,-32
    800014da:	ec06                	sd	ra,24(sp)
    800014dc:	e822                	sd	s0,16(sp)
    800014de:	e426                	sd	s1,8(sp)
    800014e0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	966080e7          	jalr	-1690(ra) # 80000e48 <myproc>
    800014ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	cca080e7          	jalr	-822(ra) # 800061b6 <acquire>
  p->state = RUNNABLE;
    800014f4:	478d                	li	a5,3
    800014f6:	cc9c                	sw	a5,24(s1)
  sched();
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	f0a080e7          	jalr	-246(ra) # 80001402 <sched>
  release(&p->lock);
    80001500:	8526                	mv	a0,s1
    80001502:	00005097          	auipc	ra,0x5
    80001506:	d68080e7          	jalr	-664(ra) # 8000626a <release>
}
    8000150a:	60e2                	ld	ra,24(sp)
    8000150c:	6442                	ld	s0,16(sp)
    8000150e:	64a2                	ld	s1,8(sp)
    80001510:	6105                	addi	sp,sp,32
    80001512:	8082                	ret

0000000080001514 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	89aa                	mv	s3,a0
    80001524:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	922080e7          	jalr	-1758(ra) # 80000e48 <myproc>
    8000152e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c86080e7          	jalr	-890(ra) # 800061b6 <acquire>
  release(lk);
    80001538:	854a                	mv	a0,s2
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	d30080e7          	jalr	-720(ra) # 8000626a <release>

  // Go to sleep.
  p->chan = chan;
    80001542:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001546:	4789                	li	a5,2
    80001548:	cc9c                	sw	a5,24(s1)

  sched();
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	eb8080e7          	jalr	-328(ra) # 80001402 <sched>

  // Tidy up.
  p->chan = 0;
    80001552:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	d12080e7          	jalr	-750(ra) # 8000626a <release>
  acquire(lk);
    80001560:	854a                	mv	a0,s2
    80001562:	00005097          	auipc	ra,0x5
    80001566:	c54080e7          	jalr	-940(ra) # 800061b6 <acquire>
}
    8000156a:	70a2                	ld	ra,40(sp)
    8000156c:	7402                	ld	s0,32(sp)
    8000156e:	64e2                	ld	s1,24(sp)
    80001570:	6942                	ld	s2,16(sp)
    80001572:	69a2                	ld	s3,8(sp)
    80001574:	6145                	addi	sp,sp,48
    80001576:	8082                	ret

0000000080001578 <wait>:
{
    80001578:	715d                	addi	sp,sp,-80
    8000157a:	e486                	sd	ra,72(sp)
    8000157c:	e0a2                	sd	s0,64(sp)
    8000157e:	fc26                	sd	s1,56(sp)
    80001580:	f84a                	sd	s2,48(sp)
    80001582:	f44e                	sd	s3,40(sp)
    80001584:	f052                	sd	s4,32(sp)
    80001586:	ec56                	sd	s5,24(sp)
    80001588:	e85a                	sd	s6,16(sp)
    8000158a:	e45e                	sd	s7,8(sp)
    8000158c:	e062                	sd	s8,0(sp)
    8000158e:	0880                	addi	s0,sp,80
    80001590:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001592:	00000097          	auipc	ra,0x0
    80001596:	8b6080e7          	jalr	-1866(ra) # 80000e48 <myproc>
    8000159a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000159c:	00008517          	auipc	a0,0x8
    800015a0:	acc50513          	addi	a0,a0,-1332 # 80009068 <wait_lock>
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c12080e7          	jalr	-1006(ra) # 800061b6 <acquire>
    havekids = 0;
    800015ac:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ae:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015b0:	0000e997          	auipc	s3,0xe
    800015b4:	0d098993          	addi	s3,s3,208 # 8000f680 <tickslock>
        havekids = 1;
    800015b8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ba:	00008c17          	auipc	s8,0x8
    800015be:	aaec0c13          	addi	s8,s8,-1362 # 80009068 <wait_lock>
    havekids = 0;
    800015c2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c4:	00008497          	auipc	s1,0x8
    800015c8:	ebc48493          	addi	s1,s1,-324 # 80009480 <proc>
    800015cc:	a0bd                	j	8000163a <wait+0xc2>
          pid = np->pid;
    800015ce:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d2:	000b0e63          	beqz	s6,800015ee <wait+0x76>
    800015d6:	4691                	li	a3,4
    800015d8:	02c48613          	addi	a2,s1,44
    800015dc:	85da                	mv	a1,s6
    800015de:	05093503          	ld	a0,80(s2)
    800015e2:	fffff097          	auipc	ra,0xfffff
    800015e6:	528080e7          	jalr	1320(ra) # 80000b0a <copyout>
    800015ea:	02054563          	bltz	a0,80001614 <wait+0x9c>
          freeproc(np);
    800015ee:	8526                	mv	a0,s1
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	a0a080e7          	jalr	-1526(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f8:	8526                	mv	a0,s1
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	c70080e7          	jalr	-912(ra) # 8000626a <release>
          release(&wait_lock);
    80001602:	00008517          	auipc	a0,0x8
    80001606:	a6650513          	addi	a0,a0,-1434 # 80009068 <wait_lock>
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	c60080e7          	jalr	-928(ra) # 8000626a <release>
          return pid;
    80001612:	a09d                	j	80001678 <wait+0x100>
            release(&np->lock);
    80001614:	8526                	mv	a0,s1
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	c54080e7          	jalr	-940(ra) # 8000626a <release>
            release(&wait_lock);
    8000161e:	00008517          	auipc	a0,0x8
    80001622:	a4a50513          	addi	a0,a0,-1462 # 80009068 <wait_lock>
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	c44080e7          	jalr	-956(ra) # 8000626a <release>
            return -1;
    8000162e:	59fd                	li	s3,-1
    80001630:	a0a1                	j	80001678 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001632:	18848493          	addi	s1,s1,392
    80001636:	03348463          	beq	s1,s3,8000165e <wait+0xe6>
      if(np->parent == p){
    8000163a:	7c9c                	ld	a5,56(s1)
    8000163c:	ff279be3          	bne	a5,s2,80001632 <wait+0xba>
        acquire(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	b74080e7          	jalr	-1164(ra) # 800061b6 <acquire>
        if(np->state == ZOMBIE){
    8000164a:	4c9c                	lw	a5,24(s1)
    8000164c:	f94781e3          	beq	a5,s4,800015ce <wait+0x56>
        release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	c18080e7          	jalr	-1000(ra) # 8000626a <release>
        havekids = 1;
    8000165a:	8756                	mv	a4,s5
    8000165c:	bfd9                	j	80001632 <wait+0xba>
    if(!havekids || p->killed){
    8000165e:	c701                	beqz	a4,80001666 <wait+0xee>
    80001660:	02892783          	lw	a5,40(s2)
    80001664:	c79d                	beqz	a5,80001692 <wait+0x11a>
      release(&wait_lock);
    80001666:	00008517          	auipc	a0,0x8
    8000166a:	a0250513          	addi	a0,a0,-1534 # 80009068 <wait_lock>
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	bfc080e7          	jalr	-1028(ra) # 8000626a <release>
      return -1;
    80001676:	59fd                	li	s3,-1
}
    80001678:	854e                	mv	a0,s3
    8000167a:	60a6                	ld	ra,72(sp)
    8000167c:	6406                	ld	s0,64(sp)
    8000167e:	74e2                	ld	s1,56(sp)
    80001680:	7942                	ld	s2,48(sp)
    80001682:	79a2                	ld	s3,40(sp)
    80001684:	7a02                	ld	s4,32(sp)
    80001686:	6ae2                	ld	s5,24(sp)
    80001688:	6b42                	ld	s6,16(sp)
    8000168a:	6ba2                	ld	s7,8(sp)
    8000168c:	6c02                	ld	s8,0(sp)
    8000168e:	6161                	addi	sp,sp,80
    80001690:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001692:	85e2                	mv	a1,s8
    80001694:	854a                	mv	a0,s2
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	e7e080e7          	jalr	-386(ra) # 80001514 <sleep>
    havekids = 0;
    8000169e:	b715                	j	800015c2 <wait+0x4a>

00000000800016a0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016a0:	7139                	addi	sp,sp,-64
    800016a2:	fc06                	sd	ra,56(sp)
    800016a4:	f822                	sd	s0,48(sp)
    800016a6:	f426                	sd	s1,40(sp)
    800016a8:	f04a                	sd	s2,32(sp)
    800016aa:	ec4e                	sd	s3,24(sp)
    800016ac:	e852                	sd	s4,16(sp)
    800016ae:	e456                	sd	s5,8(sp)
    800016b0:	0080                	addi	s0,sp,64
    800016b2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b4:	00008497          	auipc	s1,0x8
    800016b8:	dcc48493          	addi	s1,s1,-564 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016bc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016be:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c0:	0000e917          	auipc	s2,0xe
    800016c4:	fc090913          	addi	s2,s2,-64 # 8000f680 <tickslock>
    800016c8:	a821                	j	800016e0 <wakeup+0x40>
        p->state = RUNNABLE;
    800016ca:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	b9a080e7          	jalr	-1126(ra) # 8000626a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d8:	18848493          	addi	s1,s1,392
    800016dc:	03248463          	beq	s1,s2,80001704 <wakeup+0x64>
    if(p != myproc()){
    800016e0:	fffff097          	auipc	ra,0xfffff
    800016e4:	768080e7          	jalr	1896(ra) # 80000e48 <myproc>
    800016e8:	fea488e3          	beq	s1,a0,800016d8 <wakeup+0x38>
      acquire(&p->lock);
    800016ec:	8526                	mv	a0,s1
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	ac8080e7          	jalr	-1336(ra) # 800061b6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f6:	4c9c                	lw	a5,24(s1)
    800016f8:	fd379be3          	bne	a5,s3,800016ce <wakeup+0x2e>
    800016fc:	709c                	ld	a5,32(s1)
    800016fe:	fd4798e3          	bne	a5,s4,800016ce <wakeup+0x2e>
    80001702:	b7e1                	j	800016ca <wakeup+0x2a>
    }
  }
}
    80001704:	70e2                	ld	ra,56(sp)
    80001706:	7442                	ld	s0,48(sp)
    80001708:	74a2                	ld	s1,40(sp)
    8000170a:	7902                	ld	s2,32(sp)
    8000170c:	69e2                	ld	s3,24(sp)
    8000170e:	6a42                	ld	s4,16(sp)
    80001710:	6aa2                	ld	s5,8(sp)
    80001712:	6121                	addi	sp,sp,64
    80001714:	8082                	ret

0000000080001716 <reparent>:
{
    80001716:	7179                	addi	sp,sp,-48
    80001718:	f406                	sd	ra,40(sp)
    8000171a:	f022                	sd	s0,32(sp)
    8000171c:	ec26                	sd	s1,24(sp)
    8000171e:	e84a                	sd	s2,16(sp)
    80001720:	e44e                	sd	s3,8(sp)
    80001722:	e052                	sd	s4,0(sp)
    80001724:	1800                	addi	s0,sp,48
    80001726:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	00008497          	auipc	s1,0x8
    8000172c:	d5848493          	addi	s1,s1,-680 # 80009480 <proc>
      pp->parent = initproc;
    80001730:	00008a17          	auipc	s4,0x8
    80001734:	8e0a0a13          	addi	s4,s4,-1824 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001738:	0000e997          	auipc	s3,0xe
    8000173c:	f4898993          	addi	s3,s3,-184 # 8000f680 <tickslock>
    80001740:	a029                	j	8000174a <reparent+0x34>
    80001742:	18848493          	addi	s1,s1,392
    80001746:	01348d63          	beq	s1,s3,80001760 <reparent+0x4a>
    if(pp->parent == p){
    8000174a:	7c9c                	ld	a5,56(s1)
    8000174c:	ff279be3          	bne	a5,s2,80001742 <reparent+0x2c>
      pp->parent = initproc;
    80001750:	000a3503          	ld	a0,0(s4)
    80001754:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001756:	00000097          	auipc	ra,0x0
    8000175a:	f4a080e7          	jalr	-182(ra) # 800016a0 <wakeup>
    8000175e:	b7d5                	j	80001742 <reparent+0x2c>
}
    80001760:	70a2                	ld	ra,40(sp)
    80001762:	7402                	ld	s0,32(sp)
    80001764:	64e2                	ld	s1,24(sp)
    80001766:	6942                	ld	s2,16(sp)
    80001768:	69a2                	ld	s3,8(sp)
    8000176a:	6a02                	ld	s4,0(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret

0000000080001770 <exit>:
{
    80001770:	7179                	addi	sp,sp,-48
    80001772:	f406                	sd	ra,40(sp)
    80001774:	f022                	sd	s0,32(sp)
    80001776:	ec26                	sd	s1,24(sp)
    80001778:	e84a                	sd	s2,16(sp)
    8000177a:	e44e                	sd	s3,8(sp)
    8000177c:	e052                	sd	s4,0(sp)
    8000177e:	1800                	addi	s0,sp,48
    80001780:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001782:	fffff097          	auipc	ra,0xfffff
    80001786:	6c6080e7          	jalr	1734(ra) # 80000e48 <myproc>
    8000178a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000178c:	00008797          	auipc	a5,0x8
    80001790:	8847b783          	ld	a5,-1916(a5) # 80009010 <initproc>
    80001794:	0d050493          	addi	s1,a0,208
    80001798:	15050913          	addi	s2,a0,336
    8000179c:	02a79363          	bne	a5,a0,800017c2 <exit+0x52>
    panic("init exiting");
    800017a0:	00007517          	auipc	a0,0x7
    800017a4:	a4050513          	addi	a0,a0,-1472 # 800081e0 <etext+0x1e0>
    800017a8:	00004097          	auipc	ra,0x4
    800017ac:	460080e7          	jalr	1120(ra) # 80005c08 <panic>
      fileclose(f);
    800017b0:	00002097          	auipc	ra,0x2
    800017b4:	240080e7          	jalr	576(ra) # 800039f0 <fileclose>
      p->ofile[fd] = 0;
    800017b8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017bc:	04a1                	addi	s1,s1,8
    800017be:	01248563          	beq	s1,s2,800017c8 <exit+0x58>
    if(p->ofile[fd]){
    800017c2:	6088                	ld	a0,0(s1)
    800017c4:	f575                	bnez	a0,800017b0 <exit+0x40>
    800017c6:	bfdd                	j	800017bc <exit+0x4c>
  begin_op();
    800017c8:	00002097          	auipc	ra,0x2
    800017cc:	d5c080e7          	jalr	-676(ra) # 80003524 <begin_op>
  iput(p->cwd);
    800017d0:	1509b503          	ld	a0,336(s3)
    800017d4:	00001097          	auipc	ra,0x1
    800017d8:	538080e7          	jalr	1336(ra) # 80002d0c <iput>
  end_op();
    800017dc:	00002097          	auipc	ra,0x2
    800017e0:	dc8080e7          	jalr	-568(ra) # 800035a4 <end_op>
  p->cwd = 0;
    800017e4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e8:	00008497          	auipc	s1,0x8
    800017ec:	88048493          	addi	s1,s1,-1920 # 80009068 <wait_lock>
    800017f0:	8526                	mv	a0,s1
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	9c4080e7          	jalr	-1596(ra) # 800061b6 <acquire>
  reparent(p);
    800017fa:	854e                	mv	a0,s3
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	f1a080e7          	jalr	-230(ra) # 80001716 <reparent>
  wakeup(p->parent);
    80001804:	0389b503          	ld	a0,56(s3)
    80001808:	00000097          	auipc	ra,0x0
    8000180c:	e98080e7          	jalr	-360(ra) # 800016a0 <wakeup>
  acquire(&p->lock);
    80001810:	854e                	mv	a0,s3
    80001812:	00005097          	auipc	ra,0x5
    80001816:	9a4080e7          	jalr	-1628(ra) # 800061b6 <acquire>
  p->xstate = status;
    8000181a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181e:	4795                	li	a5,5
    80001820:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001824:	8526                	mv	a0,s1
    80001826:	00005097          	auipc	ra,0x5
    8000182a:	a44080e7          	jalr	-1468(ra) # 8000626a <release>
  sched();
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	bd4080e7          	jalr	-1068(ra) # 80001402 <sched>
  panic("zombie exit");
    80001836:	00007517          	auipc	a0,0x7
    8000183a:	9ba50513          	addi	a0,a0,-1606 # 800081f0 <etext+0x1f0>
    8000183e:	00004097          	auipc	ra,0x4
    80001842:	3ca080e7          	jalr	970(ra) # 80005c08 <panic>

0000000080001846 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001846:	7179                	addi	sp,sp,-48
    80001848:	f406                	sd	ra,40(sp)
    8000184a:	f022                	sd	s0,32(sp)
    8000184c:	ec26                	sd	s1,24(sp)
    8000184e:	e84a                	sd	s2,16(sp)
    80001850:	e44e                	sd	s3,8(sp)
    80001852:	1800                	addi	s0,sp,48
    80001854:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001856:	00008497          	auipc	s1,0x8
    8000185a:	c2a48493          	addi	s1,s1,-982 # 80009480 <proc>
    8000185e:	0000e997          	auipc	s3,0xe
    80001862:	e2298993          	addi	s3,s3,-478 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	94e080e7          	jalr	-1714(ra) # 800061b6 <acquire>
    if(p->pid == pid){
    80001870:	589c                	lw	a5,48(s1)
    80001872:	01278d63          	beq	a5,s2,8000188c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	9f2080e7          	jalr	-1550(ra) # 8000626a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001880:	18848493          	addi	s1,s1,392
    80001884:	ff3491e3          	bne	s1,s3,80001866 <kill+0x20>
  }
  return -1;
    80001888:	557d                	li	a0,-1
    8000188a:	a829                	j	800018a4 <kill+0x5e>
      p->killed = 1;
    8000188c:	4785                	li	a5,1
    8000188e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001890:	4c98                	lw	a4,24(s1)
    80001892:	4789                	li	a5,2
    80001894:	00f70f63          	beq	a4,a5,800018b2 <kill+0x6c>
      release(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	9d0080e7          	jalr	-1584(ra) # 8000626a <release>
      return 0;
    800018a2:	4501                	li	a0,0
}
    800018a4:	70a2                	ld	ra,40(sp)
    800018a6:	7402                	ld	s0,32(sp)
    800018a8:	64e2                	ld	s1,24(sp)
    800018aa:	6942                	ld	s2,16(sp)
    800018ac:	69a2                	ld	s3,8(sp)
    800018ae:	6145                	addi	sp,sp,48
    800018b0:	8082                	ret
        p->state = RUNNABLE;
    800018b2:	478d                	li	a5,3
    800018b4:	cc9c                	sw	a5,24(s1)
    800018b6:	b7cd                	j	80001898 <kill+0x52>

00000000800018b8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b8:	7179                	addi	sp,sp,-48
    800018ba:	f406                	sd	ra,40(sp)
    800018bc:	f022                	sd	s0,32(sp)
    800018be:	ec26                	sd	s1,24(sp)
    800018c0:	e84a                	sd	s2,16(sp)
    800018c2:	e44e                	sd	s3,8(sp)
    800018c4:	e052                	sd	s4,0(sp)
    800018c6:	1800                	addi	s0,sp,48
    800018c8:	84aa                	mv	s1,a0
    800018ca:	892e                	mv	s2,a1
    800018cc:	89b2                	mv	s3,a2
    800018ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	578080e7          	jalr	1400(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d8:	c08d                	beqz	s1,800018fa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018da:	86d2                	mv	a3,s4
    800018dc:	864e                	mv	a2,s3
    800018de:	85ca                	mv	a1,s2
    800018e0:	6928                	ld	a0,80(a0)
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	228080e7          	jalr	552(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6a02                	ld	s4,0(sp)
    800018f6:	6145                	addi	sp,sp,48
    800018f8:	8082                	ret
    memmove((char *)dst, src, len);
    800018fa:	000a061b          	sext.w	a2,s4
    800018fe:	85ce                	mv	a1,s3
    80001900:	854a                	mv	a0,s2
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	8d6080e7          	jalr	-1834(ra) # 800001d8 <memmove>
    return 0;
    8000190a:	8526                	mv	a0,s1
    8000190c:	bff9                	j	800018ea <either_copyout+0x32>

000000008000190e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190e:	7179                	addi	sp,sp,-48
    80001910:	f406                	sd	ra,40(sp)
    80001912:	f022                	sd	s0,32(sp)
    80001914:	ec26                	sd	s1,24(sp)
    80001916:	e84a                	sd	s2,16(sp)
    80001918:	e44e                	sd	s3,8(sp)
    8000191a:	e052                	sd	s4,0(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	892a                	mv	s2,a0
    80001920:	84ae                	mv	s1,a1
    80001922:	89b2                	mv	s3,a2
    80001924:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	522080e7          	jalr	1314(ra) # 80000e48 <myproc>
  if(user_src){
    8000192e:	c08d                	beqz	s1,80001950 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001930:	86d2                	mv	a3,s4
    80001932:	864e                	mv	a2,s3
    80001934:	85ca                	mv	a1,s2
    80001936:	6928                	ld	a0,80(a0)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	25e080e7          	jalr	606(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001940:	70a2                	ld	ra,40(sp)
    80001942:	7402                	ld	s0,32(sp)
    80001944:	64e2                	ld	s1,24(sp)
    80001946:	6942                	ld	s2,16(sp)
    80001948:	69a2                	ld	s3,8(sp)
    8000194a:	6a02                	ld	s4,0(sp)
    8000194c:	6145                	addi	sp,sp,48
    8000194e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001950:	000a061b          	sext.w	a2,s4
    80001954:	85ce                	mv	a1,s3
    80001956:	854a                	mv	a0,s2
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	880080e7          	jalr	-1920(ra) # 800001d8 <memmove>
    return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	bff9                	j	80001940 <either_copyin+0x32>

0000000080001964 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001964:	715d                	addi	sp,sp,-80
    80001966:	e486                	sd	ra,72(sp)
    80001968:	e0a2                	sd	s0,64(sp)
    8000196a:	fc26                	sd	s1,56(sp)
    8000196c:	f84a                	sd	s2,48(sp)
    8000196e:	f44e                	sd	s3,40(sp)
    80001970:	f052                	sd	s4,32(sp)
    80001972:	ec56                	sd	s5,24(sp)
    80001974:	e85a                	sd	s6,16(sp)
    80001976:	e45e                	sd	s7,8(sp)
    80001978:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000197a:	00006517          	auipc	a0,0x6
    8000197e:	6ce50513          	addi	a0,a0,1742 # 80008048 <etext+0x48>
    80001982:	00004097          	auipc	ra,0x4
    80001986:	2d8080e7          	jalr	728(ra) # 80005c5a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000198a:	00008497          	auipc	s1,0x8
    8000198e:	c4e48493          	addi	s1,s1,-946 # 800095d8 <proc+0x158>
    80001992:	0000e917          	auipc	s2,0xe
    80001996:	e4690913          	addi	s2,s2,-442 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000199a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000199c:	00007997          	auipc	s3,0x7
    800019a0:	86498993          	addi	s3,s3,-1948 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a4:	00007a97          	auipc	s5,0x7
    800019a8:	864a8a93          	addi	s5,s5,-1948 # 80008208 <etext+0x208>
    printf("\n");
    800019ac:	00006a17          	auipc	s4,0x6
    800019b0:	69ca0a13          	addi	s4,s4,1692 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b4:	00007b97          	auipc	s7,0x7
    800019b8:	88cb8b93          	addi	s7,s7,-1908 # 80008240 <states.1718>
    800019bc:	a00d                	j	800019de <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019be:	ed86a583          	lw	a1,-296(a3)
    800019c2:	8556                	mv	a0,s5
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	296080e7          	jalr	662(ra) # 80005c5a <printf>
    printf("\n");
    800019cc:	8552                	mv	a0,s4
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	28c080e7          	jalr	652(ra) # 80005c5a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	18848493          	addi	s1,s1,392
    800019da:	03248163          	beq	s1,s2,800019fc <procdump+0x98>
    if(p->state == UNUSED)
    800019de:	86a6                	mv	a3,s1
    800019e0:	ec04a783          	lw	a5,-320(s1)
    800019e4:	dbed                	beqz	a5,800019d6 <procdump+0x72>
      state = "???";
    800019e6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e8:	fcfb6be3          	bltu	s6,a5,800019be <procdump+0x5a>
    800019ec:	1782                	slli	a5,a5,0x20
    800019ee:	9381                	srli	a5,a5,0x20
    800019f0:	078e                	slli	a5,a5,0x3
    800019f2:	97de                	add	a5,a5,s7
    800019f4:	6390                	ld	a2,0(a5)
    800019f6:	f661                	bnez	a2,800019be <procdump+0x5a>
      state = "???";
    800019f8:	864e                	mv	a2,s3
    800019fa:	b7d1                	j	800019be <procdump+0x5a>
  }
}
    800019fc:	60a6                	ld	ra,72(sp)
    800019fe:	6406                	ld	s0,64(sp)
    80001a00:	74e2                	ld	s1,56(sp)
    80001a02:	7942                	ld	s2,48(sp)
    80001a04:	79a2                	ld	s3,40(sp)
    80001a06:	7a02                	ld	s4,32(sp)
    80001a08:	6ae2                	ld	s5,24(sp)
    80001a0a:	6b42                	ld	s6,16(sp)
    80001a0c:	6ba2                	ld	s7,8(sp)
    80001a0e:	6161                	addi	sp,sp,80
    80001a10:	8082                	ret

0000000080001a12 <swtch>:
    80001a12:	00153023          	sd	ra,0(a0)
    80001a16:	00253423          	sd	sp,8(a0)
    80001a1a:	e900                	sd	s0,16(a0)
    80001a1c:	ed04                	sd	s1,24(a0)
    80001a1e:	03253023          	sd	s2,32(a0)
    80001a22:	03353423          	sd	s3,40(a0)
    80001a26:	03453823          	sd	s4,48(a0)
    80001a2a:	03553c23          	sd	s5,56(a0)
    80001a2e:	05653023          	sd	s6,64(a0)
    80001a32:	05753423          	sd	s7,72(a0)
    80001a36:	05853823          	sd	s8,80(a0)
    80001a3a:	05953c23          	sd	s9,88(a0)
    80001a3e:	07a53023          	sd	s10,96(a0)
    80001a42:	07b53423          	sd	s11,104(a0)
    80001a46:	0005b083          	ld	ra,0(a1)
    80001a4a:	0085b103          	ld	sp,8(a1)
    80001a4e:	6980                	ld	s0,16(a1)
    80001a50:	6d84                	ld	s1,24(a1)
    80001a52:	0205b903          	ld	s2,32(a1)
    80001a56:	0285b983          	ld	s3,40(a1)
    80001a5a:	0305ba03          	ld	s4,48(a1)
    80001a5e:	0385ba83          	ld	s5,56(a1)
    80001a62:	0405bb03          	ld	s6,64(a1)
    80001a66:	0485bb83          	ld	s7,72(a1)
    80001a6a:	0505bc03          	ld	s8,80(a1)
    80001a6e:	0585bc83          	ld	s9,88(a1)
    80001a72:	0605bd03          	ld	s10,96(a1)
    80001a76:	0685bd83          	ld	s11,104(a1)
    80001a7a:	8082                	ret

0000000080001a7c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7c:	1141                	addi	sp,sp,-16
    80001a7e:	e406                	sd	ra,8(sp)
    80001a80:	e022                	sd	s0,0(sp)
    80001a82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a84:	00006597          	auipc	a1,0x6
    80001a88:	7ec58593          	addi	a1,a1,2028 # 80008270 <states.1718+0x30>
    80001a8c:	0000e517          	auipc	a0,0xe
    80001a90:	bf450513          	addi	a0,a0,-1036 # 8000f680 <tickslock>
    80001a94:	00004097          	auipc	ra,0x4
    80001a98:	692080e7          	jalr	1682(ra) # 80006126 <initlock>
}
    80001a9c:	60a2                	ld	ra,8(sp)
    80001a9e:	6402                	ld	s0,0(sp)
    80001aa0:	0141                	addi	sp,sp,16
    80001aa2:	8082                	ret

0000000080001aa4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa4:	1141                	addi	sp,sp,-16
    80001aa6:	e422                	sd	s0,8(sp)
    80001aa8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aaa:	00003797          	auipc	a5,0x3
    80001aae:	56678793          	addi	a5,a5,1382 # 80005010 <kernelvec>
    80001ab2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab6:	6422                	ld	s0,8(sp)
    80001ab8:	0141                	addi	sp,sp,16
    80001aba:	8082                	ret

0000000080001abc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001abc:	1141                	addi	sp,sp,-16
    80001abe:	e406                	sd	ra,8(sp)
    80001ac0:	e022                	sd	s0,0(sp)
    80001ac2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	384080e7          	jalr	900(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001acc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ad0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad6:	00005617          	auipc	a2,0x5
    80001ada:	52a60613          	addi	a2,a2,1322 # 80007000 <_trampoline>
    80001ade:	00005697          	auipc	a3,0x5
    80001ae2:	52268693          	addi	a3,a3,1314 # 80007000 <_trampoline>
    80001ae6:	8e91                	sub	a3,a3,a2
    80001ae8:	040007b7          	lui	a5,0x4000
    80001aec:	17fd                	addi	a5,a5,-1
    80001aee:	07b2                	slli	a5,a5,0xc
    80001af0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af8:	180026f3          	csrr	a3,satp
    80001afc:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afe:	6d38                	ld	a4,88(a0)
    80001b00:	6134                	ld	a3,64(a0)
    80001b02:	6585                	lui	a1,0x1
    80001b04:	96ae                	add	a3,a3,a1
    80001b06:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b08:	6d38                	ld	a4,88(a0)
    80001b0a:	00000697          	auipc	a3,0x0
    80001b0e:	13868693          	addi	a3,a3,312 # 80001c42 <usertrap>
    80001b12:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b14:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b16:	8692                	mv	a3,tp
    80001b18:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b22:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b26:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2c:	6f18                	ld	a4,24(a4)
    80001b2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b32:	692c                	ld	a1,80(a0)
    80001b34:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b36:	00005717          	auipc	a4,0x5
    80001b3a:	55a70713          	addi	a4,a4,1370 # 80007090 <userret>
    80001b3e:	8f11                	sub	a4,a4,a2
    80001b40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b42:	577d                	li	a4,-1
    80001b44:	177e                	slli	a4,a4,0x3f
    80001b46:	8dd9                	or	a1,a1,a4
    80001b48:	02000537          	lui	a0,0x2000
    80001b4c:	157d                	addi	a0,a0,-1
    80001b4e:	0536                	slli	a0,a0,0xd
    80001b50:	9782                	jalr	a5
}
    80001b52:	60a2                	ld	ra,8(sp)
    80001b54:	6402                	ld	s0,0(sp)
    80001b56:	0141                	addi	sp,sp,16
    80001b58:	8082                	ret

0000000080001b5a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b5a:	1101                	addi	sp,sp,-32
    80001b5c:	ec06                	sd	ra,24(sp)
    80001b5e:	e822                	sd	s0,16(sp)
    80001b60:	e426                	sd	s1,8(sp)
    80001b62:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b64:	0000e497          	auipc	s1,0xe
    80001b68:	b1c48493          	addi	s1,s1,-1252 # 8000f680 <tickslock>
    80001b6c:	8526                	mv	a0,s1
    80001b6e:	00004097          	auipc	ra,0x4
    80001b72:	648080e7          	jalr	1608(ra) # 800061b6 <acquire>
  ticks++;
    80001b76:	00007517          	auipc	a0,0x7
    80001b7a:	4a250513          	addi	a0,a0,1186 # 80009018 <ticks>
    80001b7e:	411c                	lw	a5,0(a0)
    80001b80:	2785                	addiw	a5,a5,1
    80001b82:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b84:	00000097          	auipc	ra,0x0
    80001b88:	b1c080e7          	jalr	-1252(ra) # 800016a0 <wakeup>
  release(&tickslock);
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	00004097          	auipc	ra,0x4
    80001b92:	6dc080e7          	jalr	1756(ra) # 8000626a <release>
}
    80001b96:	60e2                	ld	ra,24(sp)
    80001b98:	6442                	ld	s0,16(sp)
    80001b9a:	64a2                	ld	s1,8(sp)
    80001b9c:	6105                	addi	sp,sp,32
    80001b9e:	8082                	ret

0000000080001ba0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001baa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bae:	00074d63          	bltz	a4,80001bc8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb2:	57fd                	li	a5,-1
    80001bb4:	17fe                	slli	a5,a5,0x3f
    80001bb6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bba:	06f70363          	beq	a4,a5,80001c20 <devintr+0x80>
  }
}
    80001bbe:	60e2                	ld	ra,24(sp)
    80001bc0:	6442                	ld	s0,16(sp)
    80001bc2:	64a2                	ld	s1,8(sp)
    80001bc4:	6105                	addi	sp,sp,32
    80001bc6:	8082                	ret
     (scause & 0xff) == 9){
    80001bc8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bcc:	46a5                	li	a3,9
    80001bce:	fed792e3          	bne	a5,a3,80001bb2 <devintr+0x12>
    int irq = plic_claim();
    80001bd2:	00003097          	auipc	ra,0x3
    80001bd6:	546080e7          	jalr	1350(ra) # 80005118 <plic_claim>
    80001bda:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bdc:	47a9                	li	a5,10
    80001bde:	02f50763          	beq	a0,a5,80001c0c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be2:	4785                	li	a5,1
    80001be4:	02f50963          	beq	a0,a5,80001c16 <devintr+0x76>
    return 1;
    80001be8:	4505                	li	a0,1
    } else if(irq){
    80001bea:	d8f1                	beqz	s1,80001bbe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bec:	85a6                	mv	a1,s1
    80001bee:	00006517          	auipc	a0,0x6
    80001bf2:	68a50513          	addi	a0,a0,1674 # 80008278 <states.1718+0x38>
    80001bf6:	00004097          	auipc	ra,0x4
    80001bfa:	064080e7          	jalr	100(ra) # 80005c5a <printf>
      plic_complete(irq);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	00003097          	auipc	ra,0x3
    80001c04:	53c080e7          	jalr	1340(ra) # 8000513c <plic_complete>
    return 1;
    80001c08:	4505                	li	a0,1
    80001c0a:	bf55                	j	80001bbe <devintr+0x1e>
      uartintr();
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	4ca080e7          	jalr	1226(ra) # 800060d6 <uartintr>
    80001c14:	b7ed                	j	80001bfe <devintr+0x5e>
      virtio_disk_intr();
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	a06080e7          	jalr	-1530(ra) # 8000561c <virtio_disk_intr>
    80001c1e:	b7c5                	j	80001bfe <devintr+0x5e>
    if(cpuid() == 0){
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	1fc080e7          	jalr	508(ra) # 80000e1c <cpuid>
    80001c28:	c901                	beqz	a0,80001c38 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c2a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c30:	14479073          	csrw	sip,a5
    return 2;
    80001c34:	4509                	li	a0,2
    80001c36:	b761                	j	80001bbe <devintr+0x1e>
      clockintr();
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	f22080e7          	jalr	-222(ra) # 80001b5a <clockintr>
    80001c40:	b7ed                	j	80001c2a <devintr+0x8a>

0000000080001c42 <usertrap>:
{
    80001c42:	1101                	addi	sp,sp,-32
    80001c44:	ec06                	sd	ra,24(sp)
    80001c46:	e822                	sd	s0,16(sp)
    80001c48:	e426                	sd	s1,8(sp)
    80001c4a:	e04a                	sd	s2,0(sp)
    80001c4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c52:	1007f793          	andi	a5,a5,256
    80001c56:	e3ad                	bnez	a5,80001cb8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c58:	00003797          	auipc	a5,0x3
    80001c5c:	3b878793          	addi	a5,a5,952 # 80005010 <kernelvec>
    80001c60:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	1e4080e7          	jalr	484(ra) # 80000e48 <myproc>
    80001c6c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c70:	14102773          	csrr	a4,sepc
    80001c74:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c76:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c7a:	47a1                	li	a5,8
    80001c7c:	04f71c63          	bne	a4,a5,80001cd4 <usertrap+0x92>
    if(p->killed)
    80001c80:	551c                	lw	a5,40(a0)
    80001c82:	e3b9                	bnez	a5,80001cc8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c84:	6cb8                	ld	a4,88(s1)
    80001c86:	6f1c                	ld	a5,24(a4)
    80001c88:	0791                	addi	a5,a5,4
    80001c8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c94:	10079073          	csrw	sstatus,a5
    syscall();
    80001c98:	00000097          	auipc	ra,0x0
    80001c9c:	368080e7          	jalr	872(ra) # 80002000 <syscall>
  if(p->killed)
    80001ca0:	549c                	lw	a5,40(s1)
    80001ca2:	e7c5                	bnez	a5,80001d4a <usertrap+0x108>
  usertrapret();
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	e18080e7          	jalr	-488(ra) # 80001abc <usertrapret>
}
    80001cac:	60e2                	ld	ra,24(sp)
    80001cae:	6442                	ld	s0,16(sp)
    80001cb0:	64a2                	ld	s1,8(sp)
    80001cb2:	6902                	ld	s2,0(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb8:	00006517          	auipc	a0,0x6
    80001cbc:	5e050513          	addi	a0,a0,1504 # 80008298 <states.1718+0x58>
    80001cc0:	00004097          	auipc	ra,0x4
    80001cc4:	f48080e7          	jalr	-184(ra) # 80005c08 <panic>
      exit(-1);
    80001cc8:	557d                	li	a0,-1
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	aa6080e7          	jalr	-1370(ra) # 80001770 <exit>
    80001cd2:	bf4d                	j	80001c84 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	ecc080e7          	jalr	-308(ra) # 80001ba0 <devintr>
    80001cdc:	892a                	mv	s2,a0
    80001cde:	c501                	beqz	a0,80001ce6 <usertrap+0xa4>
  if(p->killed)
    80001ce0:	549c                	lw	a5,40(s1)
    80001ce2:	c3a1                	beqz	a5,80001d22 <usertrap+0xe0>
    80001ce4:	a815                	j	80001d18 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cea:	5890                	lw	a2,48(s1)
    80001cec:	00006517          	auipc	a0,0x6
    80001cf0:	5cc50513          	addi	a0,a0,1484 # 800082b8 <states.1718+0x78>
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	f66080e7          	jalr	-154(ra) # 80005c5a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d00:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d04:	00006517          	auipc	a0,0x6
    80001d08:	5e450513          	addi	a0,a0,1508 # 800082e8 <states.1718+0xa8>
    80001d0c:	00004097          	auipc	ra,0x4
    80001d10:	f4e080e7          	jalr	-178(ra) # 80005c5a <printf>
    p->killed = 1;
    80001d14:	4785                	li	a5,1
    80001d16:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d18:	557d                	li	a0,-1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	a56080e7          	jalr	-1450(ra) # 80001770 <exit>
  if (which_dev == 2) {   // timer interrupt
    80001d22:	4789                	li	a5,2
    80001d24:	f8f910e3          	bne	s2,a5,80001ca4 <usertrap+0x62>
    if (p->interval != 0 && ++p->passedticks == p->interval) {
    80001d28:	1684a783          	lw	a5,360(s1)
    80001d2c:	cb91                	beqz	a5,80001d40 <usertrap+0xfe>
    80001d2e:	1784a703          	lw	a4,376(s1)
    80001d32:	2705                	addiw	a4,a4,1
    80001d34:	0007069b          	sext.w	a3,a4
    80001d38:	16e4ac23          	sw	a4,376(s1)
    80001d3c:	00d78963          	beq	a5,a3,80001d4e <usertrap+0x10c>
    yield();
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	798080e7          	jalr	1944(ra) # 800014d8 <yield>
    80001d48:	bfb1                	j	80001ca4 <usertrap+0x62>
  int which_dev = 0;
    80001d4a:	4901                	li	s2,0
    80001d4c:	b7f1                	j	80001d18 <usertrap+0xd6>
      p->trapframecopy = p->trapframe + 512;
    80001d4e:	6cac                	ld	a1,88(s1)
    80001d50:	00024537          	lui	a0,0x24
    80001d54:	952e                	add	a0,a0,a1
    80001d56:	18a4b023          	sd	a0,384(s1)
      memmove(p->trapframecopy, p->trapframe, sizeof(struct trapframe));    // copy trapframe
    80001d5a:	12000613          	li	a2,288
    80001d5e:	ffffe097          	auipc	ra,0xffffe
    80001d62:	47a080e7          	jalr	1146(ra) # 800001d8 <memmove>
      p->trapframe->epc = p->handler;   
    80001d66:	6cbc                	ld	a5,88(s1)
    80001d68:	1704b703          	ld	a4,368(s1)
    80001d6c:	ef98                	sd	a4,24(a5)
    80001d6e:	bfc9                	j	80001d40 <usertrap+0xfe>

0000000080001d70 <kerneltrap>:
{
    80001d70:	7179                	addi	sp,sp,-48
    80001d72:	f406                	sd	ra,40(sp)
    80001d74:	f022                	sd	s0,32(sp)
    80001d76:	ec26                	sd	s1,24(sp)
    80001d78:	e84a                	sd	s2,16(sp)
    80001d7a:	e44e                	sd	s3,8(sp)
    80001d7c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d82:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d86:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d8a:	1004f793          	andi	a5,s1,256
    80001d8e:	cb85                	beqz	a5,80001dbe <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d94:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d96:	ef85                	bnez	a5,80001dce <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	e08080e7          	jalr	-504(ra) # 80001ba0 <devintr>
    80001da0:	cd1d                	beqz	a0,80001dde <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001da2:	4789                	li	a5,2
    80001da4:	06f50a63          	beq	a0,a5,80001e18 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dac:	10049073          	csrw	sstatus,s1
}
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	64e2                	ld	s1,24(sp)
    80001db6:	6942                	ld	s2,16(sp)
    80001db8:	69a2                	ld	s3,8(sp)
    80001dba:	6145                	addi	sp,sp,48
    80001dbc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	54a50513          	addi	a0,a0,1354 # 80008308 <states.1718+0xc8>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	e42080e7          	jalr	-446(ra) # 80005c08 <panic>
    panic("kerneltrap: interrupts enabled");
    80001dce:	00006517          	auipc	a0,0x6
    80001dd2:	56250513          	addi	a0,a0,1378 # 80008330 <states.1718+0xf0>
    80001dd6:	00004097          	auipc	ra,0x4
    80001dda:	e32080e7          	jalr	-462(ra) # 80005c08 <panic>
    printf("scause %p\n", scause);
    80001dde:	85ce                	mv	a1,s3
    80001de0:	00006517          	auipc	a0,0x6
    80001de4:	57050513          	addi	a0,a0,1392 # 80008350 <states.1718+0x110>
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	e72080e7          	jalr	-398(ra) # 80005c5a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	56850513          	addi	a0,a0,1384 # 80008360 <states.1718+0x120>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	e5a080e7          	jalr	-422(ra) # 80005c5a <printf>
    panic("kerneltrap");
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	57050513          	addi	a0,a0,1392 # 80008378 <states.1718+0x138>
    80001e10:	00004097          	auipc	ra,0x4
    80001e14:	df8080e7          	jalr	-520(ra) # 80005c08 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	030080e7          	jalr	48(ra) # 80000e48 <myproc>
    80001e20:	d541                	beqz	a0,80001da8 <kerneltrap+0x38>
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	026080e7          	jalr	38(ra) # 80000e48 <myproc>
    80001e2a:	4d18                	lw	a4,24(a0)
    80001e2c:	4791                	li	a5,4
    80001e2e:	f6f71de3          	bne	a4,a5,80001da8 <kerneltrap+0x38>
    yield();
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	6a6080e7          	jalr	1702(ra) # 800014d8 <yield>
    80001e3a:	b7bd                	j	80001da8 <kerneltrap+0x38>

0000000080001e3c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e3c:	1101                	addi	sp,sp,-32
    80001e3e:	ec06                	sd	ra,24(sp)
    80001e40:	e822                	sd	s0,16(sp)
    80001e42:	e426                	sd	s1,8(sp)
    80001e44:	1000                	addi	s0,sp,32
    80001e46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	000080e7          	jalr	ra # 80000e48 <myproc>
  switch (n) {
    80001e50:	4795                	li	a5,5
    80001e52:	0497e163          	bltu	a5,s1,80001e94 <argraw+0x58>
    80001e56:	048a                	slli	s1,s1,0x2
    80001e58:	00006717          	auipc	a4,0x6
    80001e5c:	55870713          	addi	a4,a4,1368 # 800083b0 <states.1718+0x170>
    80001e60:	94ba                	add	s1,s1,a4
    80001e62:	409c                	lw	a5,0(s1)
    80001e64:	97ba                	add	a5,a5,a4
    80001e66:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e68:	6d3c                	ld	a5,88(a0)
    80001e6a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e6c:	60e2                	ld	ra,24(sp)
    80001e6e:	6442                	ld	s0,16(sp)
    80001e70:	64a2                	ld	s1,8(sp)
    80001e72:	6105                	addi	sp,sp,32
    80001e74:	8082                	ret
    return p->trapframe->a1;
    80001e76:	6d3c                	ld	a5,88(a0)
    80001e78:	7fa8                	ld	a0,120(a5)
    80001e7a:	bfcd                	j	80001e6c <argraw+0x30>
    return p->trapframe->a2;
    80001e7c:	6d3c                	ld	a5,88(a0)
    80001e7e:	63c8                	ld	a0,128(a5)
    80001e80:	b7f5                	j	80001e6c <argraw+0x30>
    return p->trapframe->a3;
    80001e82:	6d3c                	ld	a5,88(a0)
    80001e84:	67c8                	ld	a0,136(a5)
    80001e86:	b7dd                	j	80001e6c <argraw+0x30>
    return p->trapframe->a4;
    80001e88:	6d3c                	ld	a5,88(a0)
    80001e8a:	6bc8                	ld	a0,144(a5)
    80001e8c:	b7c5                	j	80001e6c <argraw+0x30>
    return p->trapframe->a5;
    80001e8e:	6d3c                	ld	a5,88(a0)
    80001e90:	6fc8                	ld	a0,152(a5)
    80001e92:	bfe9                	j	80001e6c <argraw+0x30>
  panic("argraw");
    80001e94:	00006517          	auipc	a0,0x6
    80001e98:	4f450513          	addi	a0,a0,1268 # 80008388 <states.1718+0x148>
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	d6c080e7          	jalr	-660(ra) # 80005c08 <panic>

0000000080001ea4 <sys_sigalarm>:
    p->trapframe->a0 = -1;
  }
}

// lab4-3
uint64 sys_sigalarm(void) {
    80001ea4:	1101                	addi	sp,sp,-32
    80001ea6:	ec06                	sd	ra,24(sp)
    80001ea8:	e822                	sd	s0,16(sp)
    80001eaa:	e426                	sd	s1,8(sp)
    80001eac:	e04a                	sd	s2,0(sp)
    80001eae:	1000                	addi	s0,sp,32
  *ip = argraw(n);
    80001eb0:	4501                	li	a0,0
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	f8a080e7          	jalr	-118(ra) # 80001e3c <argraw>
    80001eba:	0005049b          	sext.w	s1,a0
  *ip = argraw(n);
    80001ebe:	4505                	li	a0,1
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	f7c080e7          	jalr	-132(ra) # 80001e3c <argraw>
    80001ec8:	892a                	mv	s2,a0
  int interval;
  uint64 handler;
  struct proc* p;
  // 要求时间间隔非负
  if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    return -1;
    80001eca:	557d                	li	a0,-1
  if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80001ecc:	0004cd63          	bltz	s1,80001ee6 <sys_sigalarm+0x42>
  }
  // lab4-3
  p = myproc();
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	f78080e7          	jalr	-136(ra) # 80000e48 <myproc>
  p->interval = interval;
    80001ed8:	16952423          	sw	s1,360(a0)
  p->handler = handler;
    80001edc:	17253823          	sd	s2,368(a0)
  p->passedticks = 0;    // 重置过去时钟数
    80001ee0:	16052c23          	sw	zero,376(a0)

  return 0;
    80001ee4:	4501                	li	a0,0
}
    80001ee6:	60e2                	ld	ra,24(sp)
    80001ee8:	6442                	ld	s0,16(sp)
    80001eea:	64a2                	ld	s1,8(sp)
    80001eec:	6902                	ld	s2,0(sp)
    80001eee:	6105                	addi	sp,sp,32
    80001ef0:	8082                	ret

0000000080001ef2 <fetchaddr>:
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	e04a                	sd	s2,0(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84aa                	mv	s1,a0
    80001f00:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f46080e7          	jalr	-186(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f0a:	653c                	ld	a5,72(a0)
    80001f0c:	02f4f863          	bgeu	s1,a5,80001f3c <fetchaddr+0x4a>
    80001f10:	00848713          	addi	a4,s1,8
    80001f14:	02e7e663          	bltu	a5,a4,80001f40 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f18:	46a1                	li	a3,8
    80001f1a:	8626                	mv	a2,s1
    80001f1c:	85ca                	mv	a1,s2
    80001f1e:	6928                	ld	a0,80(a0)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	c76080e7          	jalr	-906(ra) # 80000b96 <copyin>
    80001f28:	00a03533          	snez	a0,a0
    80001f2c:	40a00533          	neg	a0,a0
}
    80001f30:	60e2                	ld	ra,24(sp)
    80001f32:	6442                	ld	s0,16(sp)
    80001f34:	64a2                	ld	s1,8(sp)
    80001f36:	6902                	ld	s2,0(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret
    return -1;
    80001f3c:	557d                	li	a0,-1
    80001f3e:	bfcd                	j	80001f30 <fetchaddr+0x3e>
    80001f40:	557d                	li	a0,-1
    80001f42:	b7fd                	j	80001f30 <fetchaddr+0x3e>

0000000080001f44 <fetchstr>:
{
    80001f44:	7179                	addi	sp,sp,-48
    80001f46:	f406                	sd	ra,40(sp)
    80001f48:	f022                	sd	s0,32(sp)
    80001f4a:	ec26                	sd	s1,24(sp)
    80001f4c:	e84a                	sd	s2,16(sp)
    80001f4e:	e44e                	sd	s3,8(sp)
    80001f50:	1800                	addi	s0,sp,48
    80001f52:	892a                	mv	s2,a0
    80001f54:	84ae                	mv	s1,a1
    80001f56:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	ef0080e7          	jalr	-272(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f60:	86ce                	mv	a3,s3
    80001f62:	864a                	mv	a2,s2
    80001f64:	85a6                	mv	a1,s1
    80001f66:	6928                	ld	a0,80(a0)
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	cba080e7          	jalr	-838(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f70:	00054763          	bltz	a0,80001f7e <fetchstr+0x3a>
  return strlen(buf);
    80001f74:	8526                	mv	a0,s1
    80001f76:	ffffe097          	auipc	ra,0xffffe
    80001f7a:	386080e7          	jalr	902(ra) # 800002fc <strlen>
}
    80001f7e:	70a2                	ld	ra,40(sp)
    80001f80:	7402                	ld	s0,32(sp)
    80001f82:	64e2                	ld	s1,24(sp)
    80001f84:	6942                	ld	s2,16(sp)
    80001f86:	69a2                	ld	s3,8(sp)
    80001f88:	6145                	addi	sp,sp,48
    80001f8a:	8082                	ret

0000000080001f8c <argint>:
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	ea4080e7          	jalr	-348(ra) # 80001e3c <argraw>
    80001fa0:	c088                	sw	a0,0(s1)
}
    80001fa2:	4501                	li	a0,0
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret

0000000080001fae <argaddr>:
{
    80001fae:	1101                	addi	sp,sp,-32
    80001fb0:	ec06                	sd	ra,24(sp)
    80001fb2:	e822                	sd	s0,16(sp)
    80001fb4:	e426                	sd	s1,8(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	e82080e7          	jalr	-382(ra) # 80001e3c <argraw>
    80001fc2:	e088                	sd	a0,0(s1)
}
    80001fc4:	4501                	li	a0,0
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6105                	addi	sp,sp,32
    80001fce:	8082                	ret

0000000080001fd0 <argstr>:
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	e04a                	sd	s2,0(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	84ae                	mv	s1,a1
    80001fde:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	e5c080e7          	jalr	-420(ra) # 80001e3c <argraw>
  return fetchstr(addr, buf, max);
    80001fe8:	864a                	mv	a2,s2
    80001fea:	85a6                	mv	a1,s1
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	f58080e7          	jalr	-168(ra) # 80001f44 <fetchstr>
}
    80001ff4:	60e2                	ld	ra,24(sp)
    80001ff6:	6442                	ld	s0,16(sp)
    80001ff8:	64a2                	ld	s1,8(sp)
    80001ffa:	6902                	ld	s2,0(sp)
    80001ffc:	6105                	addi	sp,sp,32
    80001ffe:	8082                	ret

0000000080002000 <syscall>:
{
    80002000:	1101                	addi	sp,sp,-32
    80002002:	ec06                	sd	ra,24(sp)
    80002004:	e822                	sd	s0,16(sp)
    80002006:	e426                	sd	s1,8(sp)
    80002008:	e04a                	sd	s2,0(sp)
    8000200a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	e3c080e7          	jalr	-452(ra) # 80000e48 <myproc>
    80002014:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80002016:	05853903          	ld	s2,88(a0)
    8000201a:	0a893783          	ld	a5,168(s2)
    8000201e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002022:	37fd                	addiw	a5,a5,-1
    80002024:	4759                	li	a4,22
    80002026:	00f76f63          	bltu	a4,a5,80002044 <syscall+0x44>
    8000202a:	00369713          	slli	a4,a3,0x3
    8000202e:	00006797          	auipc	a5,0x6
    80002032:	39a78793          	addi	a5,a5,922 # 800083c8 <syscalls>
    80002036:	97ba                	add	a5,a5,a4
    80002038:	639c                	ld	a5,0(a5)
    8000203a:	c789                	beqz	a5,80002044 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000203c:	9782                	jalr	a5
    8000203e:	06a93823          	sd	a0,112(s2)
    80002042:	a839                	j	80002060 <syscall+0x60>
    printf("%d %s: unknown sys call %d\n",
    80002044:	15848613          	addi	a2,s1,344
    80002048:	588c                	lw	a1,48(s1)
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	34650513          	addi	a0,a0,838 # 80008390 <states.1718+0x150>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	c08080e7          	jalr	-1016(ra) # 80005c5a <printf>
    p->trapframe->a0 = -1;
    8000205a:	6cbc                	ld	a5,88(s1)
    8000205c:	577d                	li	a4,-1
    8000205e:	fbb8                	sd	a4,112(a5)
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6902                	ld	s2,0(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000206c:	1101                	addi	sp,sp,-32
    8000206e:	ec06                	sd	ra,24(sp)
    80002070:	e822                	sd	s0,16(sp)
    80002072:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002074:	fec40593          	addi	a1,s0,-20
    80002078:	4501                	li	a0,0
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	f12080e7          	jalr	-238(ra) # 80001f8c <argint>
    return -1;
    80002082:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002084:	00054963          	bltz	a0,80002096 <sys_exit+0x2a>
  exit(n);
    80002088:	fec42503          	lw	a0,-20(s0)
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	6e4080e7          	jalr	1764(ra) # 80001770 <exit>
  return 0;  // not reached
    80002094:	4781                	li	a5,0
}
    80002096:	853e                	mv	a0,a5
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret

00000000800020a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020a0:	1141                	addi	sp,sp,-16
    800020a2:	e406                	sd	ra,8(sp)
    800020a4:	e022                	sd	s0,0(sp)
    800020a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	da0080e7          	jalr	-608(ra) # 80000e48 <myproc>
}
    800020b0:	5908                	lw	a0,48(a0)
    800020b2:	60a2                	ld	ra,8(sp)
    800020b4:	6402                	ld	s0,0(sp)
    800020b6:	0141                	addi	sp,sp,16
    800020b8:	8082                	ret

00000000800020ba <sys_fork>:

uint64
sys_fork(void)
{
    800020ba:	1141                	addi	sp,sp,-16
    800020bc:	e406                	sd	ra,8(sp)
    800020be:	e022                	sd	s0,0(sp)
    800020c0:	0800                	addi	s0,sp,16
  return fork();
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	164080e7          	jalr	356(ra) # 80001226 <fork>
}
    800020ca:	60a2                	ld	ra,8(sp)
    800020cc:	6402                	ld	s0,0(sp)
    800020ce:	0141                	addi	sp,sp,16
    800020d0:	8082                	ret

00000000800020d2 <sys_wait>:

uint64
sys_wait(void)
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020da:	fe840593          	addi	a1,s0,-24
    800020de:	4501                	li	a0,0
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	ece080e7          	jalr	-306(ra) # 80001fae <argaddr>
    800020e8:	87aa                	mv	a5,a0
    return -1;
    800020ea:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020ec:	0007c863          	bltz	a5,800020fc <sys_wait+0x2a>
  return wait(p);
    800020f0:	fe843503          	ld	a0,-24(s0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	484080e7          	jalr	1156(ra) # 80001578 <wait>
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	6105                	addi	sp,sp,32
    80002102:	8082                	ret

0000000080002104 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002104:	7179                	addi	sp,sp,-48
    80002106:	f406                	sd	ra,40(sp)
    80002108:	f022                	sd	s0,32(sp)
    8000210a:	ec26                	sd	s1,24(sp)
    8000210c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000210e:	fdc40593          	addi	a1,s0,-36
    80002112:	4501                	li	a0,0
    80002114:	00000097          	auipc	ra,0x0
    80002118:	e78080e7          	jalr	-392(ra) # 80001f8c <argint>
    8000211c:	87aa                	mv	a5,a0
    return -1;
    8000211e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002120:	0207c063          	bltz	a5,80002140 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	d24080e7          	jalr	-732(ra) # 80000e48 <myproc>
    8000212c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000212e:	fdc42503          	lw	a0,-36(s0)
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	080080e7          	jalr	128(ra) # 800011b2 <growproc>
    8000213a:	00054863          	bltz	a0,8000214a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000213e:	8526                	mv	a0,s1
}
    80002140:	70a2                	ld	ra,40(sp)
    80002142:	7402                	ld	s0,32(sp)
    80002144:	64e2                	ld	s1,24(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret
    return -1;
    8000214a:	557d                	li	a0,-1
    8000214c:	bfd5                	j	80002140 <sys_sbrk+0x3c>

000000008000214e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000214e:	7139                	addi	sp,sp,-64
    80002150:	fc06                	sd	ra,56(sp)
    80002152:	f822                	sd	s0,48(sp)
    80002154:	f426                	sd	s1,40(sp)
    80002156:	f04a                	sd	s2,32(sp)
    80002158:	ec4e                	sd	s3,24(sp)
    8000215a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000215c:	fcc40593          	addi	a1,s0,-52
    80002160:	4501                	li	a0,0
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e2a080e7          	jalr	-470(ra) # 80001f8c <argint>
    return -1;
    8000216a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000216c:	06054963          	bltz	a0,800021de <sys_sleep+0x90>
  acquire(&tickslock);
    80002170:	0000d517          	auipc	a0,0xd
    80002174:	51050513          	addi	a0,a0,1296 # 8000f680 <tickslock>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	03e080e7          	jalr	62(ra) # 800061b6 <acquire>
  ticks0 = ticks;
    80002180:	00007917          	auipc	s2,0x7
    80002184:	e9892903          	lw	s2,-360(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002188:	fcc42783          	lw	a5,-52(s0)
    8000218c:	cf85                	beqz	a5,800021c4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000218e:	0000d997          	auipc	s3,0xd
    80002192:	4f298993          	addi	s3,s3,1266 # 8000f680 <tickslock>
    80002196:	00007497          	auipc	s1,0x7
    8000219a:	e8248493          	addi	s1,s1,-382 # 80009018 <ticks>
    if(myproc()->killed){
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	caa080e7          	jalr	-854(ra) # 80000e48 <myproc>
    800021a6:	551c                	lw	a5,40(a0)
    800021a8:	e3b9                	bnez	a5,800021ee <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021aa:	85ce                	mv	a1,s3
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	366080e7          	jalr	870(ra) # 80001514 <sleep>
  while(ticks - ticks0 < n){
    800021b6:	409c                	lw	a5,0(s1)
    800021b8:	412787bb          	subw	a5,a5,s2
    800021bc:	fcc42703          	lw	a4,-52(s0)
    800021c0:	fce7efe3          	bltu	a5,a4,8000219e <sys_sleep+0x50>
  }
  release(&tickslock);
    800021c4:	0000d517          	auipc	a0,0xd
    800021c8:	4bc50513          	addi	a0,a0,1212 # 8000f680 <tickslock>
    800021cc:	00004097          	auipc	ra,0x4
    800021d0:	09e080e7          	jalr	158(ra) # 8000626a <release>
  backtrace();
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	c6c080e7          	jalr	-916(ra) # 80005e40 <backtrace>
  return 0;
    800021dc:	4781                	li	a5,0
}
    800021de:	853e                	mv	a0,a5
    800021e0:	70e2                	ld	ra,56(sp)
    800021e2:	7442                	ld	s0,48(sp)
    800021e4:	74a2                	ld	s1,40(sp)
    800021e6:	7902                	ld	s2,32(sp)
    800021e8:	69e2                	ld	s3,24(sp)
    800021ea:	6121                	addi	sp,sp,64
    800021ec:	8082                	ret
      release(&tickslock);
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	49250513          	addi	a0,a0,1170 # 8000f680 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	074080e7          	jalr	116(ra) # 8000626a <release>
      return -1;
    800021fe:	57fd                	li	a5,-1
    80002200:	bff9                	j	800021de <sys_sleep+0x90>

0000000080002202 <sys_kill>:

uint64
sys_kill(void)
{
    80002202:	1101                	addi	sp,sp,-32
    80002204:	ec06                	sd	ra,24(sp)
    80002206:	e822                	sd	s0,16(sp)
    80002208:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000220a:	fec40593          	addi	a1,s0,-20
    8000220e:	4501                	li	a0,0
    80002210:	00000097          	auipc	ra,0x0
    80002214:	d7c080e7          	jalr	-644(ra) # 80001f8c <argint>
    80002218:	87aa                	mv	a5,a0
    return -1;
    8000221a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000221c:	0007c863          	bltz	a5,8000222c <sys_kill+0x2a>
  return kill(pid);
    80002220:	fec42503          	lw	a0,-20(s0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	622080e7          	jalr	1570(ra) # 80001846 <kill>
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret

0000000080002234 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002234:	1101                	addi	sp,sp,-32
    80002236:	ec06                	sd	ra,24(sp)
    80002238:	e822                	sd	s0,16(sp)
    8000223a:	e426                	sd	s1,8(sp)
    8000223c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000223e:	0000d517          	auipc	a0,0xd
    80002242:	44250513          	addi	a0,a0,1090 # 8000f680 <tickslock>
    80002246:	00004097          	auipc	ra,0x4
    8000224a:	f70080e7          	jalr	-144(ra) # 800061b6 <acquire>
  xticks = ticks;
    8000224e:	00007497          	auipc	s1,0x7
    80002252:	dca4a483          	lw	s1,-566(s1) # 80009018 <ticks>
  release(&tickslock);
    80002256:	0000d517          	auipc	a0,0xd
    8000225a:	42a50513          	addi	a0,a0,1066 # 8000f680 <tickslock>
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	00c080e7          	jalr	12(ra) # 8000626a <release>
  return xticks;
}
    80002266:	02049513          	slli	a0,s1,0x20
    8000226a:	9101                	srli	a0,a0,0x20
    8000226c:	60e2                	ld	ra,24(sp)
    8000226e:	6442                	ld	s0,16(sp)
    80002270:	64a2                	ld	s1,8(sp)
    80002272:	6105                	addi	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_sigreturn>:

// lab4-3
uint64 sys_sigreturn(void) {
    80002276:	1101                	addi	sp,sp,-32
    80002278:	ec06                	sd	ra,24(sp)
    8000227a:	e822                	sd	s0,16(sp)
    8000227c:	e426                	sd	s1,8(sp)
    8000227e:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	bc8080e7          	jalr	-1080(ra) # 80000e48 <myproc>
    80002288:	84aa                	mv	s1,a0
  // trapframecopy must have the copy of trapframe
  if (p->trapframecopy != p->trapframe + 512) {
    8000228a:	18053583          	ld	a1,384(a0)
    8000228e:	6d38                	ld	a4,88(a0)
    80002290:	000247b7          	lui	a5,0x24
    80002294:	97ba                	add	a5,a5,a4
    return -1;
    80002296:	557d                	li	a0,-1
  if (p->trapframecopy != p->trapframe + 512) {
    80002298:	00f58763          	beq	a1,a5,800022a6 <sys_sigreturn+0x30>
  }
  memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
  p->passedticks = 0;     // prevent re-entrant
  p->trapframecopy = 0;    // 置零
  return p->trapframe->a0;	// 返回a0,避免被返回值覆盖
}
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	64a2                	ld	s1,8(sp)
    800022a2:	6105                	addi	sp,sp,32
    800022a4:	8082                	ret
  memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
    800022a6:	12000613          	li	a2,288
    800022aa:	853a                	mv	a0,a4
    800022ac:	ffffe097          	auipc	ra,0xffffe
    800022b0:	f2c080e7          	jalr	-212(ra) # 800001d8 <memmove>
  p->passedticks = 0;     // prevent re-entrant
    800022b4:	1604ac23          	sw	zero,376(s1)
  p->trapframecopy = 0;    // 置零
    800022b8:	1804b023          	sd	zero,384(s1)
  return p->trapframe->a0;	// 返回a0,避免被返回值覆盖
    800022bc:	6cbc                	ld	a5,88(s1)
    800022be:	7ba8                	ld	a0,112(a5)
    800022c0:	bff1                	j	8000229c <sys_sigreturn+0x26>

00000000800022c2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022c2:	7179                	addi	sp,sp,-48
    800022c4:	f406                	sd	ra,40(sp)
    800022c6:	f022                	sd	s0,32(sp)
    800022c8:	ec26                	sd	s1,24(sp)
    800022ca:	e84a                	sd	s2,16(sp)
    800022cc:	e44e                	sd	s3,8(sp)
    800022ce:	e052                	sd	s4,0(sp)
    800022d0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022d2:	00006597          	auipc	a1,0x6
    800022d6:	1b658593          	addi	a1,a1,438 # 80008488 <syscalls+0xc0>
    800022da:	0000d517          	auipc	a0,0xd
    800022de:	3be50513          	addi	a0,a0,958 # 8000f698 <bcache>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	e44080e7          	jalr	-444(ra) # 80006126 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022ea:	00015797          	auipc	a5,0x15
    800022ee:	3ae78793          	addi	a5,a5,942 # 80017698 <bcache+0x8000>
    800022f2:	00015717          	auipc	a4,0x15
    800022f6:	60e70713          	addi	a4,a4,1550 # 80017900 <bcache+0x8268>
    800022fa:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022fe:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002302:	0000d497          	auipc	s1,0xd
    80002306:	3ae48493          	addi	s1,s1,942 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000230a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000230c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000230e:	00006a17          	auipc	s4,0x6
    80002312:	182a0a13          	addi	s4,s4,386 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002316:	2b893783          	ld	a5,696(s2)
    8000231a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000231c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002320:	85d2                	mv	a1,s4
    80002322:	01048513          	addi	a0,s1,16
    80002326:	00001097          	auipc	ra,0x1
    8000232a:	4bc080e7          	jalr	1212(ra) # 800037e2 <initsleeplock>
    bcache.head.next->prev = b;
    8000232e:	2b893783          	ld	a5,696(s2)
    80002332:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002334:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002338:	45848493          	addi	s1,s1,1112
    8000233c:	fd349de3          	bne	s1,s3,80002316 <binit+0x54>
  }
}
    80002340:	70a2                	ld	ra,40(sp)
    80002342:	7402                	ld	s0,32(sp)
    80002344:	64e2                	ld	s1,24(sp)
    80002346:	6942                	ld	s2,16(sp)
    80002348:	69a2                	ld	s3,8(sp)
    8000234a:	6a02                	ld	s4,0(sp)
    8000234c:	6145                	addi	sp,sp,48
    8000234e:	8082                	ret

0000000080002350 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002350:	7179                	addi	sp,sp,-48
    80002352:	f406                	sd	ra,40(sp)
    80002354:	f022                	sd	s0,32(sp)
    80002356:	ec26                	sd	s1,24(sp)
    80002358:	e84a                	sd	s2,16(sp)
    8000235a:	e44e                	sd	s3,8(sp)
    8000235c:	1800                	addi	s0,sp,48
    8000235e:	89aa                	mv	s3,a0
    80002360:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002362:	0000d517          	auipc	a0,0xd
    80002366:	33650513          	addi	a0,a0,822 # 8000f698 <bcache>
    8000236a:	00004097          	auipc	ra,0x4
    8000236e:	e4c080e7          	jalr	-436(ra) # 800061b6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002372:	00015497          	auipc	s1,0x15
    80002376:	5de4b483          	ld	s1,1502(s1) # 80017950 <bcache+0x82b8>
    8000237a:	00015797          	auipc	a5,0x15
    8000237e:	58678793          	addi	a5,a5,1414 # 80017900 <bcache+0x8268>
    80002382:	02f48f63          	beq	s1,a5,800023c0 <bread+0x70>
    80002386:	873e                	mv	a4,a5
    80002388:	a021                	j	80002390 <bread+0x40>
    8000238a:	68a4                	ld	s1,80(s1)
    8000238c:	02e48a63          	beq	s1,a4,800023c0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002390:	449c                	lw	a5,8(s1)
    80002392:	ff379ce3          	bne	a5,s3,8000238a <bread+0x3a>
    80002396:	44dc                	lw	a5,12(s1)
    80002398:	ff2799e3          	bne	a5,s2,8000238a <bread+0x3a>
      b->refcnt++;
    8000239c:	40bc                	lw	a5,64(s1)
    8000239e:	2785                	addiw	a5,a5,1
    800023a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023a2:	0000d517          	auipc	a0,0xd
    800023a6:	2f650513          	addi	a0,a0,758 # 8000f698 <bcache>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	ec0080e7          	jalr	-320(ra) # 8000626a <release>
      acquiresleep(&b->lock);
    800023b2:	01048513          	addi	a0,s1,16
    800023b6:	00001097          	auipc	ra,0x1
    800023ba:	466080e7          	jalr	1126(ra) # 8000381c <acquiresleep>
      return b;
    800023be:	a8b9                	j	8000241c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c0:	00015497          	auipc	s1,0x15
    800023c4:	5884b483          	ld	s1,1416(s1) # 80017948 <bcache+0x82b0>
    800023c8:	00015797          	auipc	a5,0x15
    800023cc:	53878793          	addi	a5,a5,1336 # 80017900 <bcache+0x8268>
    800023d0:	00f48863          	beq	s1,a5,800023e0 <bread+0x90>
    800023d4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023d6:	40bc                	lw	a5,64(s1)
    800023d8:	cf81                	beqz	a5,800023f0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023da:	64a4                	ld	s1,72(s1)
    800023dc:	fee49de3          	bne	s1,a4,800023d6 <bread+0x86>
  panic("bget: no buffers");
    800023e0:	00006517          	auipc	a0,0x6
    800023e4:	0b850513          	addi	a0,a0,184 # 80008498 <syscalls+0xd0>
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	820080e7          	jalr	-2016(ra) # 80005c08 <panic>
      b->dev = dev;
    800023f0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800023f4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800023f8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023fc:	4785                	li	a5,1
    800023fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002400:	0000d517          	auipc	a0,0xd
    80002404:	29850513          	addi	a0,a0,664 # 8000f698 <bcache>
    80002408:	00004097          	auipc	ra,0x4
    8000240c:	e62080e7          	jalr	-414(ra) # 8000626a <release>
      acquiresleep(&b->lock);
    80002410:	01048513          	addi	a0,s1,16
    80002414:	00001097          	auipc	ra,0x1
    80002418:	408080e7          	jalr	1032(ra) # 8000381c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000241c:	409c                	lw	a5,0(s1)
    8000241e:	cb89                	beqz	a5,80002430 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002420:	8526                	mv	a0,s1
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6145                	addi	sp,sp,48
    8000242e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002430:	4581                	li	a1,0
    80002432:	8526                	mv	a0,s1
    80002434:	00003097          	auipc	ra,0x3
    80002438:	f12080e7          	jalr	-238(ra) # 80005346 <virtio_disk_rw>
    b->valid = 1;
    8000243c:	4785                	li	a5,1
    8000243e:	c09c                	sw	a5,0(s1)
  return b;
    80002440:	b7c5                	j	80002420 <bread+0xd0>

0000000080002442 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002442:	1101                	addi	sp,sp,-32
    80002444:	ec06                	sd	ra,24(sp)
    80002446:	e822                	sd	s0,16(sp)
    80002448:	e426                	sd	s1,8(sp)
    8000244a:	1000                	addi	s0,sp,32
    8000244c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000244e:	0541                	addi	a0,a0,16
    80002450:	00001097          	auipc	ra,0x1
    80002454:	466080e7          	jalr	1126(ra) # 800038b6 <holdingsleep>
    80002458:	cd01                	beqz	a0,80002470 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000245a:	4585                	li	a1,1
    8000245c:	8526                	mv	a0,s1
    8000245e:	00003097          	auipc	ra,0x3
    80002462:	ee8080e7          	jalr	-280(ra) # 80005346 <virtio_disk_rw>
}
    80002466:	60e2                	ld	ra,24(sp)
    80002468:	6442                	ld	s0,16(sp)
    8000246a:	64a2                	ld	s1,8(sp)
    8000246c:	6105                	addi	sp,sp,32
    8000246e:	8082                	ret
    panic("bwrite");
    80002470:	00006517          	auipc	a0,0x6
    80002474:	04050513          	addi	a0,a0,64 # 800084b0 <syscalls+0xe8>
    80002478:	00003097          	auipc	ra,0x3
    8000247c:	790080e7          	jalr	1936(ra) # 80005c08 <panic>

0000000080002480 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002480:	1101                	addi	sp,sp,-32
    80002482:	ec06                	sd	ra,24(sp)
    80002484:	e822                	sd	s0,16(sp)
    80002486:	e426                	sd	s1,8(sp)
    80002488:	e04a                	sd	s2,0(sp)
    8000248a:	1000                	addi	s0,sp,32
    8000248c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248e:	01050913          	addi	s2,a0,16
    80002492:	854a                	mv	a0,s2
    80002494:	00001097          	auipc	ra,0x1
    80002498:	422080e7          	jalr	1058(ra) # 800038b6 <holdingsleep>
    8000249c:	c92d                	beqz	a0,8000250e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000249e:	854a                	mv	a0,s2
    800024a0:	00001097          	auipc	ra,0x1
    800024a4:	3d2080e7          	jalr	978(ra) # 80003872 <releasesleep>

  acquire(&bcache.lock);
    800024a8:	0000d517          	auipc	a0,0xd
    800024ac:	1f050513          	addi	a0,a0,496 # 8000f698 <bcache>
    800024b0:	00004097          	auipc	ra,0x4
    800024b4:	d06080e7          	jalr	-762(ra) # 800061b6 <acquire>
  b->refcnt--;
    800024b8:	40bc                	lw	a5,64(s1)
    800024ba:	37fd                	addiw	a5,a5,-1
    800024bc:	0007871b          	sext.w	a4,a5
    800024c0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024c2:	eb05                	bnez	a4,800024f2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024c4:	68bc                	ld	a5,80(s1)
    800024c6:	64b8                	ld	a4,72(s1)
    800024c8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024ca:	64bc                	ld	a5,72(s1)
    800024cc:	68b8                	ld	a4,80(s1)
    800024ce:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024d0:	00015797          	auipc	a5,0x15
    800024d4:	1c878793          	addi	a5,a5,456 # 80017698 <bcache+0x8000>
    800024d8:	2b87b703          	ld	a4,696(a5)
    800024dc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024de:	00015717          	auipc	a4,0x15
    800024e2:	42270713          	addi	a4,a4,1058 # 80017900 <bcache+0x8268>
    800024e6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024e8:	2b87b703          	ld	a4,696(a5)
    800024ec:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024ee:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024f2:	0000d517          	auipc	a0,0xd
    800024f6:	1a650513          	addi	a0,a0,422 # 8000f698 <bcache>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	d70080e7          	jalr	-656(ra) # 8000626a <release>
}
    80002502:	60e2                	ld	ra,24(sp)
    80002504:	6442                	ld	s0,16(sp)
    80002506:	64a2                	ld	s1,8(sp)
    80002508:	6902                	ld	s2,0(sp)
    8000250a:	6105                	addi	sp,sp,32
    8000250c:	8082                	ret
    panic("brelse");
    8000250e:	00006517          	auipc	a0,0x6
    80002512:	faa50513          	addi	a0,a0,-86 # 800084b8 <syscalls+0xf0>
    80002516:	00003097          	auipc	ra,0x3
    8000251a:	6f2080e7          	jalr	1778(ra) # 80005c08 <panic>

000000008000251e <bpin>:

void
bpin(struct buf *b) {
    8000251e:	1101                	addi	sp,sp,-32
    80002520:	ec06                	sd	ra,24(sp)
    80002522:	e822                	sd	s0,16(sp)
    80002524:	e426                	sd	s1,8(sp)
    80002526:	1000                	addi	s0,sp,32
    80002528:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000252a:	0000d517          	auipc	a0,0xd
    8000252e:	16e50513          	addi	a0,a0,366 # 8000f698 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	c84080e7          	jalr	-892(ra) # 800061b6 <acquire>
  b->refcnt++;
    8000253a:	40bc                	lw	a5,64(s1)
    8000253c:	2785                	addiw	a5,a5,1
    8000253e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	15850513          	addi	a0,a0,344 # 8000f698 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	d22080e7          	jalr	-734(ra) # 8000626a <release>
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	64a2                	ld	s1,8(sp)
    80002556:	6105                	addi	sp,sp,32
    80002558:	8082                	ret

000000008000255a <bunpin>:

void
bunpin(struct buf *b) {
    8000255a:	1101                	addi	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	1000                	addi	s0,sp,32
    80002564:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002566:	0000d517          	auipc	a0,0xd
    8000256a:	13250513          	addi	a0,a0,306 # 8000f698 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	c48080e7          	jalr	-952(ra) # 800061b6 <acquire>
  b->refcnt--;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	37fd                	addiw	a5,a5,-1
    8000257a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	11c50513          	addi	a0,a0,284 # 8000f698 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	ce6080e7          	jalr	-794(ra) # 8000626a <release>
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	64a2                	ld	s1,8(sp)
    80002592:	6105                	addi	sp,sp,32
    80002594:	8082                	ret

0000000080002596 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	e04a                	sd	s2,0(sp)
    800025a0:	1000                	addi	s0,sp,32
    800025a2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025a4:	00d5d59b          	srliw	a1,a1,0xd
    800025a8:	00015797          	auipc	a5,0x15
    800025ac:	7cc7a783          	lw	a5,1996(a5) # 80017d74 <sb+0x1c>
    800025b0:	9dbd                	addw	a1,a1,a5
    800025b2:	00000097          	auipc	ra,0x0
    800025b6:	d9e080e7          	jalr	-610(ra) # 80002350 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025ba:	0074f713          	andi	a4,s1,7
    800025be:	4785                	li	a5,1
    800025c0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025c4:	14ce                	slli	s1,s1,0x33
    800025c6:	90d9                	srli	s1,s1,0x36
    800025c8:	00950733          	add	a4,a0,s1
    800025cc:	05874703          	lbu	a4,88(a4)
    800025d0:	00e7f6b3          	and	a3,a5,a4
    800025d4:	c69d                	beqz	a3,80002602 <bfree+0x6c>
    800025d6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025d8:	94aa                	add	s1,s1,a0
    800025da:	fff7c793          	not	a5,a5
    800025de:	8ff9                	and	a5,a5,a4
    800025e0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800025e4:	00001097          	auipc	ra,0x1
    800025e8:	118080e7          	jalr	280(ra) # 800036fc <log_write>
  brelse(bp);
    800025ec:	854a                	mv	a0,s2
    800025ee:	00000097          	auipc	ra,0x0
    800025f2:	e92080e7          	jalr	-366(ra) # 80002480 <brelse>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	64a2                	ld	s1,8(sp)
    800025fc:	6902                	ld	s2,0(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret
    panic("freeing free block");
    80002602:	00006517          	auipc	a0,0x6
    80002606:	ebe50513          	addi	a0,a0,-322 # 800084c0 <syscalls+0xf8>
    8000260a:	00003097          	auipc	ra,0x3
    8000260e:	5fe080e7          	jalr	1534(ra) # 80005c08 <panic>

0000000080002612 <balloc>:
{
    80002612:	711d                	addi	sp,sp,-96
    80002614:	ec86                	sd	ra,88(sp)
    80002616:	e8a2                	sd	s0,80(sp)
    80002618:	e4a6                	sd	s1,72(sp)
    8000261a:	e0ca                	sd	s2,64(sp)
    8000261c:	fc4e                	sd	s3,56(sp)
    8000261e:	f852                	sd	s4,48(sp)
    80002620:	f456                	sd	s5,40(sp)
    80002622:	f05a                	sd	s6,32(sp)
    80002624:	ec5e                	sd	s7,24(sp)
    80002626:	e862                	sd	s8,16(sp)
    80002628:	e466                	sd	s9,8(sp)
    8000262a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000262c:	00015797          	auipc	a5,0x15
    80002630:	7307a783          	lw	a5,1840(a5) # 80017d5c <sb+0x4>
    80002634:	cbd1                	beqz	a5,800026c8 <balloc+0xb6>
    80002636:	8baa                	mv	s7,a0
    80002638:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000263a:	00015b17          	auipc	s6,0x15
    8000263e:	71eb0b13          	addi	s6,s6,1822 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002642:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002644:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002646:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002648:	6c89                	lui	s9,0x2
    8000264a:	a831                	j	80002666 <balloc+0x54>
    brelse(bp);
    8000264c:	854a                	mv	a0,s2
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	e32080e7          	jalr	-462(ra) # 80002480 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002656:	015c87bb          	addw	a5,s9,s5
    8000265a:	00078a9b          	sext.w	s5,a5
    8000265e:	004b2703          	lw	a4,4(s6)
    80002662:	06eaf363          	bgeu	s5,a4,800026c8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002666:	41fad79b          	sraiw	a5,s5,0x1f
    8000266a:	0137d79b          	srliw	a5,a5,0x13
    8000266e:	015787bb          	addw	a5,a5,s5
    80002672:	40d7d79b          	sraiw	a5,a5,0xd
    80002676:	01cb2583          	lw	a1,28(s6)
    8000267a:	9dbd                	addw	a1,a1,a5
    8000267c:	855e                	mv	a0,s7
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	cd2080e7          	jalr	-814(ra) # 80002350 <bread>
    80002686:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002688:	004b2503          	lw	a0,4(s6)
    8000268c:	000a849b          	sext.w	s1,s5
    80002690:	8662                	mv	a2,s8
    80002692:	faa4fde3          	bgeu	s1,a0,8000264c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002696:	41f6579b          	sraiw	a5,a2,0x1f
    8000269a:	01d7d69b          	srliw	a3,a5,0x1d
    8000269e:	00c6873b          	addw	a4,a3,a2
    800026a2:	00777793          	andi	a5,a4,7
    800026a6:	9f95                	subw	a5,a5,a3
    800026a8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ac:	4037571b          	sraiw	a4,a4,0x3
    800026b0:	00e906b3          	add	a3,s2,a4
    800026b4:	0586c683          	lbu	a3,88(a3)
    800026b8:	00d7f5b3          	and	a1,a5,a3
    800026bc:	cd91                	beqz	a1,800026d8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026be:	2605                	addiw	a2,a2,1
    800026c0:	2485                	addiw	s1,s1,1
    800026c2:	fd4618e3          	bne	a2,s4,80002692 <balloc+0x80>
    800026c6:	b759                	j	8000264c <balloc+0x3a>
  panic("balloc: out of blocks");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	e1050513          	addi	a0,a0,-496 # 800084d8 <syscalls+0x110>
    800026d0:	00003097          	auipc	ra,0x3
    800026d4:	538080e7          	jalr	1336(ra) # 80005c08 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026d8:	974a                	add	a4,a4,s2
    800026da:	8fd5                	or	a5,a5,a3
    800026dc:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	00001097          	auipc	ra,0x1
    800026e6:	01a080e7          	jalr	26(ra) # 800036fc <log_write>
        brelse(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	d94080e7          	jalr	-620(ra) # 80002480 <brelse>
  bp = bread(dev, bno);
    800026f4:	85a6                	mv	a1,s1
    800026f6:	855e                	mv	a0,s7
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	c58080e7          	jalr	-936(ra) # 80002350 <bread>
    80002700:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002702:	40000613          	li	a2,1024
    80002706:	4581                	li	a1,0
    80002708:	05850513          	addi	a0,a0,88
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	a6c080e7          	jalr	-1428(ra) # 80000178 <memset>
  log_write(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	00001097          	auipc	ra,0x1
    8000271a:	fe6080e7          	jalr	-26(ra) # 800036fc <log_write>
  brelse(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00000097          	auipc	ra,0x0
    80002724:	d60080e7          	jalr	-672(ra) # 80002480 <brelse>
}
    80002728:	8526                	mv	a0,s1
    8000272a:	60e6                	ld	ra,88(sp)
    8000272c:	6446                	ld	s0,80(sp)
    8000272e:	64a6                	ld	s1,72(sp)
    80002730:	6906                	ld	s2,64(sp)
    80002732:	79e2                	ld	s3,56(sp)
    80002734:	7a42                	ld	s4,48(sp)
    80002736:	7aa2                	ld	s5,40(sp)
    80002738:	7b02                	ld	s6,32(sp)
    8000273a:	6be2                	ld	s7,24(sp)
    8000273c:	6c42                	ld	s8,16(sp)
    8000273e:	6ca2                	ld	s9,8(sp)
    80002740:	6125                	addi	sp,sp,96
    80002742:	8082                	ret

0000000080002744 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002744:	7179                	addi	sp,sp,-48
    80002746:	f406                	sd	ra,40(sp)
    80002748:	f022                	sd	s0,32(sp)
    8000274a:	ec26                	sd	s1,24(sp)
    8000274c:	e84a                	sd	s2,16(sp)
    8000274e:	e44e                	sd	s3,8(sp)
    80002750:	e052                	sd	s4,0(sp)
    80002752:	1800                	addi	s0,sp,48
    80002754:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002756:	47ad                	li	a5,11
    80002758:	04b7fe63          	bgeu	a5,a1,800027b4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000275c:	ff45849b          	addiw	s1,a1,-12
    80002760:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002764:	0ff00793          	li	a5,255
    80002768:	0ae7e363          	bltu	a5,a4,8000280e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000276c:	08052583          	lw	a1,128(a0)
    80002770:	c5ad                	beqz	a1,800027da <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002772:	00092503          	lw	a0,0(s2)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	bda080e7          	jalr	-1062(ra) # 80002350 <bread>
    8000277e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002780:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002784:	02049593          	slli	a1,s1,0x20
    80002788:	9181                	srli	a1,a1,0x20
    8000278a:	058a                	slli	a1,a1,0x2
    8000278c:	00b784b3          	add	s1,a5,a1
    80002790:	0004a983          	lw	s3,0(s1)
    80002794:	04098d63          	beqz	s3,800027ee <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002798:	8552                	mv	a0,s4
    8000279a:	00000097          	auipc	ra,0x0
    8000279e:	ce6080e7          	jalr	-794(ra) # 80002480 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027a2:	854e                	mv	a0,s3
    800027a4:	70a2                	ld	ra,40(sp)
    800027a6:	7402                	ld	s0,32(sp)
    800027a8:	64e2                	ld	s1,24(sp)
    800027aa:	6942                	ld	s2,16(sp)
    800027ac:	69a2                	ld	s3,8(sp)
    800027ae:	6a02                	ld	s4,0(sp)
    800027b0:	6145                	addi	sp,sp,48
    800027b2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027b4:	02059493          	slli	s1,a1,0x20
    800027b8:	9081                	srli	s1,s1,0x20
    800027ba:	048a                	slli	s1,s1,0x2
    800027bc:	94aa                	add	s1,s1,a0
    800027be:	0504a983          	lw	s3,80(s1)
    800027c2:	fe0990e3          	bnez	s3,800027a2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027c6:	4108                	lw	a0,0(a0)
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	e4a080e7          	jalr	-438(ra) # 80002612 <balloc>
    800027d0:	0005099b          	sext.w	s3,a0
    800027d4:	0534a823          	sw	s3,80(s1)
    800027d8:	b7e9                	j	800027a2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027da:	4108                	lw	a0,0(a0)
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	e36080e7          	jalr	-458(ra) # 80002612 <balloc>
    800027e4:	0005059b          	sext.w	a1,a0
    800027e8:	08b92023          	sw	a1,128(s2)
    800027ec:	b759                	j	80002772 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027ee:	00092503          	lw	a0,0(s2)
    800027f2:	00000097          	auipc	ra,0x0
    800027f6:	e20080e7          	jalr	-480(ra) # 80002612 <balloc>
    800027fa:	0005099b          	sext.w	s3,a0
    800027fe:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002802:	8552                	mv	a0,s4
    80002804:	00001097          	auipc	ra,0x1
    80002808:	ef8080e7          	jalr	-264(ra) # 800036fc <log_write>
    8000280c:	b771                	j	80002798 <bmap+0x54>
  panic("bmap: out of range");
    8000280e:	00006517          	auipc	a0,0x6
    80002812:	ce250513          	addi	a0,a0,-798 # 800084f0 <syscalls+0x128>
    80002816:	00003097          	auipc	ra,0x3
    8000281a:	3f2080e7          	jalr	1010(ra) # 80005c08 <panic>

000000008000281e <iget>:
{
    8000281e:	7179                	addi	sp,sp,-48
    80002820:	f406                	sd	ra,40(sp)
    80002822:	f022                	sd	s0,32(sp)
    80002824:	ec26                	sd	s1,24(sp)
    80002826:	e84a                	sd	s2,16(sp)
    80002828:	e44e                	sd	s3,8(sp)
    8000282a:	e052                	sd	s4,0(sp)
    8000282c:	1800                	addi	s0,sp,48
    8000282e:	89aa                	mv	s3,a0
    80002830:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002832:	00015517          	auipc	a0,0x15
    80002836:	54650513          	addi	a0,a0,1350 # 80017d78 <itable>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	97c080e7          	jalr	-1668(ra) # 800061b6 <acquire>
  empty = 0;
    80002842:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002844:	00015497          	auipc	s1,0x15
    80002848:	54c48493          	addi	s1,s1,1356 # 80017d90 <itable+0x18>
    8000284c:	00017697          	auipc	a3,0x17
    80002850:	fd468693          	addi	a3,a3,-44 # 80019820 <log>
    80002854:	a039                	j	80002862 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002856:	02090b63          	beqz	s2,8000288c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000285a:	08848493          	addi	s1,s1,136
    8000285e:	02d48a63          	beq	s1,a3,80002892 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002862:	449c                	lw	a5,8(s1)
    80002864:	fef059e3          	blez	a5,80002856 <iget+0x38>
    80002868:	4098                	lw	a4,0(s1)
    8000286a:	ff3716e3          	bne	a4,s3,80002856 <iget+0x38>
    8000286e:	40d8                	lw	a4,4(s1)
    80002870:	ff4713e3          	bne	a4,s4,80002856 <iget+0x38>
      ip->ref++;
    80002874:	2785                	addiw	a5,a5,1
    80002876:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002878:	00015517          	auipc	a0,0x15
    8000287c:	50050513          	addi	a0,a0,1280 # 80017d78 <itable>
    80002880:	00004097          	auipc	ra,0x4
    80002884:	9ea080e7          	jalr	-1558(ra) # 8000626a <release>
      return ip;
    80002888:	8926                	mv	s2,s1
    8000288a:	a03d                	j	800028b8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000288c:	f7f9                	bnez	a5,8000285a <iget+0x3c>
    8000288e:	8926                	mv	s2,s1
    80002890:	b7e9                	j	8000285a <iget+0x3c>
  if(empty == 0)
    80002892:	02090c63          	beqz	s2,800028ca <iget+0xac>
  ip->dev = dev;
    80002896:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000289a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000289e:	4785                	li	a5,1
    800028a0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028a4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028a8:	00015517          	auipc	a0,0x15
    800028ac:	4d050513          	addi	a0,a0,1232 # 80017d78 <itable>
    800028b0:	00004097          	auipc	ra,0x4
    800028b4:	9ba080e7          	jalr	-1606(ra) # 8000626a <release>
}
    800028b8:	854a                	mv	a0,s2
    800028ba:	70a2                	ld	ra,40(sp)
    800028bc:	7402                	ld	s0,32(sp)
    800028be:	64e2                	ld	s1,24(sp)
    800028c0:	6942                	ld	s2,16(sp)
    800028c2:	69a2                	ld	s3,8(sp)
    800028c4:	6a02                	ld	s4,0(sp)
    800028c6:	6145                	addi	sp,sp,48
    800028c8:	8082                	ret
    panic("iget: no inodes");
    800028ca:	00006517          	auipc	a0,0x6
    800028ce:	c3e50513          	addi	a0,a0,-962 # 80008508 <syscalls+0x140>
    800028d2:	00003097          	auipc	ra,0x3
    800028d6:	336080e7          	jalr	822(ra) # 80005c08 <panic>

00000000800028da <fsinit>:
fsinit(int dev) {
    800028da:	7179                	addi	sp,sp,-48
    800028dc:	f406                	sd	ra,40(sp)
    800028de:	f022                	sd	s0,32(sp)
    800028e0:	ec26                	sd	s1,24(sp)
    800028e2:	e84a                	sd	s2,16(sp)
    800028e4:	e44e                	sd	s3,8(sp)
    800028e6:	1800                	addi	s0,sp,48
    800028e8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028ea:	4585                	li	a1,1
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	a64080e7          	jalr	-1436(ra) # 80002350 <bread>
    800028f4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028f6:	00015997          	auipc	s3,0x15
    800028fa:	46298993          	addi	s3,s3,1122 # 80017d58 <sb>
    800028fe:	02000613          	li	a2,32
    80002902:	05850593          	addi	a1,a0,88
    80002906:	854e                	mv	a0,s3
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	8d0080e7          	jalr	-1840(ra) # 800001d8 <memmove>
  brelse(bp);
    80002910:	8526                	mv	a0,s1
    80002912:	00000097          	auipc	ra,0x0
    80002916:	b6e080e7          	jalr	-1170(ra) # 80002480 <brelse>
  if(sb.magic != FSMAGIC)
    8000291a:	0009a703          	lw	a4,0(s3)
    8000291e:	102037b7          	lui	a5,0x10203
    80002922:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002926:	02f71263          	bne	a4,a5,8000294a <fsinit+0x70>
  initlog(dev, &sb);
    8000292a:	00015597          	auipc	a1,0x15
    8000292e:	42e58593          	addi	a1,a1,1070 # 80017d58 <sb>
    80002932:	854a                	mv	a0,s2
    80002934:	00001097          	auipc	ra,0x1
    80002938:	b4c080e7          	jalr	-1204(ra) # 80003480 <initlog>
}
    8000293c:	70a2                	ld	ra,40(sp)
    8000293e:	7402                	ld	s0,32(sp)
    80002940:	64e2                	ld	s1,24(sp)
    80002942:	6942                	ld	s2,16(sp)
    80002944:	69a2                	ld	s3,8(sp)
    80002946:	6145                	addi	sp,sp,48
    80002948:	8082                	ret
    panic("invalid file system");
    8000294a:	00006517          	auipc	a0,0x6
    8000294e:	bce50513          	addi	a0,a0,-1074 # 80008518 <syscalls+0x150>
    80002952:	00003097          	auipc	ra,0x3
    80002956:	2b6080e7          	jalr	694(ra) # 80005c08 <panic>

000000008000295a <iinit>:
{
    8000295a:	7179                	addi	sp,sp,-48
    8000295c:	f406                	sd	ra,40(sp)
    8000295e:	f022                	sd	s0,32(sp)
    80002960:	ec26                	sd	s1,24(sp)
    80002962:	e84a                	sd	s2,16(sp)
    80002964:	e44e                	sd	s3,8(sp)
    80002966:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002968:	00006597          	auipc	a1,0x6
    8000296c:	bc858593          	addi	a1,a1,-1080 # 80008530 <syscalls+0x168>
    80002970:	00015517          	auipc	a0,0x15
    80002974:	40850513          	addi	a0,a0,1032 # 80017d78 <itable>
    80002978:	00003097          	auipc	ra,0x3
    8000297c:	7ae080e7          	jalr	1966(ra) # 80006126 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002980:	00015497          	auipc	s1,0x15
    80002984:	42048493          	addi	s1,s1,1056 # 80017da0 <itable+0x28>
    80002988:	00017997          	auipc	s3,0x17
    8000298c:	ea898993          	addi	s3,s3,-344 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002990:	00006917          	auipc	s2,0x6
    80002994:	ba890913          	addi	s2,s2,-1112 # 80008538 <syscalls+0x170>
    80002998:	85ca                	mv	a1,s2
    8000299a:	8526                	mv	a0,s1
    8000299c:	00001097          	auipc	ra,0x1
    800029a0:	e46080e7          	jalr	-442(ra) # 800037e2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029a4:	08848493          	addi	s1,s1,136
    800029a8:	ff3498e3          	bne	s1,s3,80002998 <iinit+0x3e>
}
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret

00000000800029ba <ialloc>:
{
    800029ba:	715d                	addi	sp,sp,-80
    800029bc:	e486                	sd	ra,72(sp)
    800029be:	e0a2                	sd	s0,64(sp)
    800029c0:	fc26                	sd	s1,56(sp)
    800029c2:	f84a                	sd	s2,48(sp)
    800029c4:	f44e                	sd	s3,40(sp)
    800029c6:	f052                	sd	s4,32(sp)
    800029c8:	ec56                	sd	s5,24(sp)
    800029ca:	e85a                	sd	s6,16(sp)
    800029cc:	e45e                	sd	s7,8(sp)
    800029ce:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029d0:	00015717          	auipc	a4,0x15
    800029d4:	39472703          	lw	a4,916(a4) # 80017d64 <sb+0xc>
    800029d8:	4785                	li	a5,1
    800029da:	04e7fa63          	bgeu	a5,a4,80002a2e <ialloc+0x74>
    800029de:	8aaa                	mv	s5,a0
    800029e0:	8bae                	mv	s7,a1
    800029e2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029e4:	00015a17          	auipc	s4,0x15
    800029e8:	374a0a13          	addi	s4,s4,884 # 80017d58 <sb>
    800029ec:	00048b1b          	sext.w	s6,s1
    800029f0:	0044d593          	srli	a1,s1,0x4
    800029f4:	018a2783          	lw	a5,24(s4)
    800029f8:	9dbd                	addw	a1,a1,a5
    800029fa:	8556                	mv	a0,s5
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	954080e7          	jalr	-1708(ra) # 80002350 <bread>
    80002a04:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a06:	05850993          	addi	s3,a0,88
    80002a0a:	00f4f793          	andi	a5,s1,15
    80002a0e:	079a                	slli	a5,a5,0x6
    80002a10:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a12:	00099783          	lh	a5,0(s3)
    80002a16:	c785                	beqz	a5,80002a3e <ialloc+0x84>
    brelse(bp);
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	a68080e7          	jalr	-1432(ra) # 80002480 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a20:	0485                	addi	s1,s1,1
    80002a22:	00ca2703          	lw	a4,12(s4)
    80002a26:	0004879b          	sext.w	a5,s1
    80002a2a:	fce7e1e3          	bltu	a5,a4,800029ec <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	b1250513          	addi	a0,a0,-1262 # 80008540 <syscalls+0x178>
    80002a36:	00003097          	auipc	ra,0x3
    80002a3a:	1d2080e7          	jalr	466(ra) # 80005c08 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a3e:	04000613          	li	a2,64
    80002a42:	4581                	li	a1,0
    80002a44:	854e                	mv	a0,s3
    80002a46:	ffffd097          	auipc	ra,0xffffd
    80002a4a:	732080e7          	jalr	1842(ra) # 80000178 <memset>
      dip->type = type;
    80002a4e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a52:	854a                	mv	a0,s2
    80002a54:	00001097          	auipc	ra,0x1
    80002a58:	ca8080e7          	jalr	-856(ra) # 800036fc <log_write>
      brelse(bp);
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	a22080e7          	jalr	-1502(ra) # 80002480 <brelse>
      return iget(dev, inum);
    80002a66:	85da                	mv	a1,s6
    80002a68:	8556                	mv	a0,s5
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	db4080e7          	jalr	-588(ra) # 8000281e <iget>
}
    80002a72:	60a6                	ld	ra,72(sp)
    80002a74:	6406                	ld	s0,64(sp)
    80002a76:	74e2                	ld	s1,56(sp)
    80002a78:	7942                	ld	s2,48(sp)
    80002a7a:	79a2                	ld	s3,40(sp)
    80002a7c:	7a02                	ld	s4,32(sp)
    80002a7e:	6ae2                	ld	s5,24(sp)
    80002a80:	6b42                	ld	s6,16(sp)
    80002a82:	6ba2                	ld	s7,8(sp)
    80002a84:	6161                	addi	sp,sp,80
    80002a86:	8082                	ret

0000000080002a88 <iupdate>:
{
    80002a88:	1101                	addi	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	e04a                	sd	s2,0(sp)
    80002a92:	1000                	addi	s0,sp,32
    80002a94:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a96:	415c                	lw	a5,4(a0)
    80002a98:	0047d79b          	srliw	a5,a5,0x4
    80002a9c:	00015597          	auipc	a1,0x15
    80002aa0:	2d45a583          	lw	a1,724(a1) # 80017d70 <sb+0x18>
    80002aa4:	9dbd                	addw	a1,a1,a5
    80002aa6:	4108                	lw	a0,0(a0)
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	8a8080e7          	jalr	-1880(ra) # 80002350 <bread>
    80002ab0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ab2:	05850793          	addi	a5,a0,88
    80002ab6:	40c8                	lw	a0,4(s1)
    80002ab8:	893d                	andi	a0,a0,15
    80002aba:	051a                	slli	a0,a0,0x6
    80002abc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002abe:	04449703          	lh	a4,68(s1)
    80002ac2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ac6:	04649703          	lh	a4,70(s1)
    80002aca:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ace:	04849703          	lh	a4,72(s1)
    80002ad2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ad6:	04a49703          	lh	a4,74(s1)
    80002ada:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ade:	44f8                	lw	a4,76(s1)
    80002ae0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ae2:	03400613          	li	a2,52
    80002ae6:	05048593          	addi	a1,s1,80
    80002aea:	0531                	addi	a0,a0,12
    80002aec:	ffffd097          	auipc	ra,0xffffd
    80002af0:	6ec080e7          	jalr	1772(ra) # 800001d8 <memmove>
  log_write(bp);
    80002af4:	854a                	mv	a0,s2
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	c06080e7          	jalr	-1018(ra) # 800036fc <log_write>
  brelse(bp);
    80002afe:	854a                	mv	a0,s2
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	980080e7          	jalr	-1664(ra) # 80002480 <brelse>
}
    80002b08:	60e2                	ld	ra,24(sp)
    80002b0a:	6442                	ld	s0,16(sp)
    80002b0c:	64a2                	ld	s1,8(sp)
    80002b0e:	6902                	ld	s2,0(sp)
    80002b10:	6105                	addi	sp,sp,32
    80002b12:	8082                	ret

0000000080002b14 <idup>:
{
    80002b14:	1101                	addi	sp,sp,-32
    80002b16:	ec06                	sd	ra,24(sp)
    80002b18:	e822                	sd	s0,16(sp)
    80002b1a:	e426                	sd	s1,8(sp)
    80002b1c:	1000                	addi	s0,sp,32
    80002b1e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b20:	00015517          	auipc	a0,0x15
    80002b24:	25850513          	addi	a0,a0,600 # 80017d78 <itable>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	68e080e7          	jalr	1678(ra) # 800061b6 <acquire>
  ip->ref++;
    80002b30:	449c                	lw	a5,8(s1)
    80002b32:	2785                	addiw	a5,a5,1
    80002b34:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b36:	00015517          	auipc	a0,0x15
    80002b3a:	24250513          	addi	a0,a0,578 # 80017d78 <itable>
    80002b3e:	00003097          	auipc	ra,0x3
    80002b42:	72c080e7          	jalr	1836(ra) # 8000626a <release>
}
    80002b46:	8526                	mv	a0,s1
    80002b48:	60e2                	ld	ra,24(sp)
    80002b4a:	6442                	ld	s0,16(sp)
    80002b4c:	64a2                	ld	s1,8(sp)
    80002b4e:	6105                	addi	sp,sp,32
    80002b50:	8082                	ret

0000000080002b52 <ilock>:
{
    80002b52:	1101                	addi	sp,sp,-32
    80002b54:	ec06                	sd	ra,24(sp)
    80002b56:	e822                	sd	s0,16(sp)
    80002b58:	e426                	sd	s1,8(sp)
    80002b5a:	e04a                	sd	s2,0(sp)
    80002b5c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b5e:	c115                	beqz	a0,80002b82 <ilock+0x30>
    80002b60:	84aa                	mv	s1,a0
    80002b62:	451c                	lw	a5,8(a0)
    80002b64:	00f05f63          	blez	a5,80002b82 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b68:	0541                	addi	a0,a0,16
    80002b6a:	00001097          	auipc	ra,0x1
    80002b6e:	cb2080e7          	jalr	-846(ra) # 8000381c <acquiresleep>
  if(ip->valid == 0){
    80002b72:	40bc                	lw	a5,64(s1)
    80002b74:	cf99                	beqz	a5,80002b92 <ilock+0x40>
}
    80002b76:	60e2                	ld	ra,24(sp)
    80002b78:	6442                	ld	s0,16(sp)
    80002b7a:	64a2                	ld	s1,8(sp)
    80002b7c:	6902                	ld	s2,0(sp)
    80002b7e:	6105                	addi	sp,sp,32
    80002b80:	8082                	ret
    panic("ilock");
    80002b82:	00006517          	auipc	a0,0x6
    80002b86:	9d650513          	addi	a0,a0,-1578 # 80008558 <syscalls+0x190>
    80002b8a:	00003097          	auipc	ra,0x3
    80002b8e:	07e080e7          	jalr	126(ra) # 80005c08 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b92:	40dc                	lw	a5,4(s1)
    80002b94:	0047d79b          	srliw	a5,a5,0x4
    80002b98:	00015597          	auipc	a1,0x15
    80002b9c:	1d85a583          	lw	a1,472(a1) # 80017d70 <sb+0x18>
    80002ba0:	9dbd                	addw	a1,a1,a5
    80002ba2:	4088                	lw	a0,0(s1)
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	7ac080e7          	jalr	1964(ra) # 80002350 <bread>
    80002bac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bae:	05850593          	addi	a1,a0,88
    80002bb2:	40dc                	lw	a5,4(s1)
    80002bb4:	8bbd                	andi	a5,a5,15
    80002bb6:	079a                	slli	a5,a5,0x6
    80002bb8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bba:	00059783          	lh	a5,0(a1)
    80002bbe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bc2:	00259783          	lh	a5,2(a1)
    80002bc6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bca:	00459783          	lh	a5,4(a1)
    80002bce:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bd2:	00659783          	lh	a5,6(a1)
    80002bd6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bda:	459c                	lw	a5,8(a1)
    80002bdc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bde:	03400613          	li	a2,52
    80002be2:	05b1                	addi	a1,a1,12
    80002be4:	05048513          	addi	a0,s1,80
    80002be8:	ffffd097          	auipc	ra,0xffffd
    80002bec:	5f0080e7          	jalr	1520(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bf0:	854a                	mv	a0,s2
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	88e080e7          	jalr	-1906(ra) # 80002480 <brelse>
    ip->valid = 1;
    80002bfa:	4785                	li	a5,1
    80002bfc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bfe:	04449783          	lh	a5,68(s1)
    80002c02:	fbb5                	bnez	a5,80002b76 <ilock+0x24>
      panic("ilock: no type");
    80002c04:	00006517          	auipc	a0,0x6
    80002c08:	95c50513          	addi	a0,a0,-1700 # 80008560 <syscalls+0x198>
    80002c0c:	00003097          	auipc	ra,0x3
    80002c10:	ffc080e7          	jalr	-4(ra) # 80005c08 <panic>

0000000080002c14 <iunlock>:
{
    80002c14:	1101                	addi	sp,sp,-32
    80002c16:	ec06                	sd	ra,24(sp)
    80002c18:	e822                	sd	s0,16(sp)
    80002c1a:	e426                	sd	s1,8(sp)
    80002c1c:	e04a                	sd	s2,0(sp)
    80002c1e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c20:	c905                	beqz	a0,80002c50 <iunlock+0x3c>
    80002c22:	84aa                	mv	s1,a0
    80002c24:	01050913          	addi	s2,a0,16
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00001097          	auipc	ra,0x1
    80002c2e:	c8c080e7          	jalr	-884(ra) # 800038b6 <holdingsleep>
    80002c32:	cd19                	beqz	a0,80002c50 <iunlock+0x3c>
    80002c34:	449c                	lw	a5,8(s1)
    80002c36:	00f05d63          	blez	a5,80002c50 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c3a:	854a                	mv	a0,s2
    80002c3c:	00001097          	auipc	ra,0x1
    80002c40:	c36080e7          	jalr	-970(ra) # 80003872 <releasesleep>
}
    80002c44:	60e2                	ld	ra,24(sp)
    80002c46:	6442                	ld	s0,16(sp)
    80002c48:	64a2                	ld	s1,8(sp)
    80002c4a:	6902                	ld	s2,0(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret
    panic("iunlock");
    80002c50:	00006517          	auipc	a0,0x6
    80002c54:	92050513          	addi	a0,a0,-1760 # 80008570 <syscalls+0x1a8>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	fb0080e7          	jalr	-80(ra) # 80005c08 <panic>

0000000080002c60 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c60:	7179                	addi	sp,sp,-48
    80002c62:	f406                	sd	ra,40(sp)
    80002c64:	f022                	sd	s0,32(sp)
    80002c66:	ec26                	sd	s1,24(sp)
    80002c68:	e84a                	sd	s2,16(sp)
    80002c6a:	e44e                	sd	s3,8(sp)
    80002c6c:	e052                	sd	s4,0(sp)
    80002c6e:	1800                	addi	s0,sp,48
    80002c70:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c72:	05050493          	addi	s1,a0,80
    80002c76:	08050913          	addi	s2,a0,128
    80002c7a:	a021                	j	80002c82 <itrunc+0x22>
    80002c7c:	0491                	addi	s1,s1,4
    80002c7e:	01248d63          	beq	s1,s2,80002c98 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c82:	408c                	lw	a1,0(s1)
    80002c84:	dde5                	beqz	a1,80002c7c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c86:	0009a503          	lw	a0,0(s3)
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	90c080e7          	jalr	-1780(ra) # 80002596 <bfree>
      ip->addrs[i] = 0;
    80002c92:	0004a023          	sw	zero,0(s1)
    80002c96:	b7dd                	j	80002c7c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c98:	0809a583          	lw	a1,128(s3)
    80002c9c:	e185                	bnez	a1,80002cbc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c9e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ca2:	854e                	mv	a0,s3
    80002ca4:	00000097          	auipc	ra,0x0
    80002ca8:	de4080e7          	jalr	-540(ra) # 80002a88 <iupdate>
}
    80002cac:	70a2                	ld	ra,40(sp)
    80002cae:	7402                	ld	s0,32(sp)
    80002cb0:	64e2                	ld	s1,24(sp)
    80002cb2:	6942                	ld	s2,16(sp)
    80002cb4:	69a2                	ld	s3,8(sp)
    80002cb6:	6a02                	ld	s4,0(sp)
    80002cb8:	6145                	addi	sp,sp,48
    80002cba:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cbc:	0009a503          	lw	a0,0(s3)
    80002cc0:	fffff097          	auipc	ra,0xfffff
    80002cc4:	690080e7          	jalr	1680(ra) # 80002350 <bread>
    80002cc8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cca:	05850493          	addi	s1,a0,88
    80002cce:	45850913          	addi	s2,a0,1112
    80002cd2:	a811                	j	80002ce6 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002cd4:	0009a503          	lw	a0,0(s3)
    80002cd8:	00000097          	auipc	ra,0x0
    80002cdc:	8be080e7          	jalr	-1858(ra) # 80002596 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ce0:	0491                	addi	s1,s1,4
    80002ce2:	01248563          	beq	s1,s2,80002cec <itrunc+0x8c>
      if(a[j])
    80002ce6:	408c                	lw	a1,0(s1)
    80002ce8:	dde5                	beqz	a1,80002ce0 <itrunc+0x80>
    80002cea:	b7ed                	j	80002cd4 <itrunc+0x74>
    brelse(bp);
    80002cec:	8552                	mv	a0,s4
    80002cee:	fffff097          	auipc	ra,0xfffff
    80002cf2:	792080e7          	jalr	1938(ra) # 80002480 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cf6:	0809a583          	lw	a1,128(s3)
    80002cfa:	0009a503          	lw	a0,0(s3)
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	898080e7          	jalr	-1896(ra) # 80002596 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d06:	0809a023          	sw	zero,128(s3)
    80002d0a:	bf51                	j	80002c9e <itrunc+0x3e>

0000000080002d0c <iput>:
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	e04a                	sd	s2,0(sp)
    80002d16:	1000                	addi	s0,sp,32
    80002d18:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d1a:	00015517          	auipc	a0,0x15
    80002d1e:	05e50513          	addi	a0,a0,94 # 80017d78 <itable>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	494080e7          	jalr	1172(ra) # 800061b6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d2a:	4498                	lw	a4,8(s1)
    80002d2c:	4785                	li	a5,1
    80002d2e:	02f70363          	beq	a4,a5,80002d54 <iput+0x48>
  ip->ref--;
    80002d32:	449c                	lw	a5,8(s1)
    80002d34:	37fd                	addiw	a5,a5,-1
    80002d36:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d38:	00015517          	auipc	a0,0x15
    80002d3c:	04050513          	addi	a0,a0,64 # 80017d78 <itable>
    80002d40:	00003097          	auipc	ra,0x3
    80002d44:	52a080e7          	jalr	1322(ra) # 8000626a <release>
}
    80002d48:	60e2                	ld	ra,24(sp)
    80002d4a:	6442                	ld	s0,16(sp)
    80002d4c:	64a2                	ld	s1,8(sp)
    80002d4e:	6902                	ld	s2,0(sp)
    80002d50:	6105                	addi	sp,sp,32
    80002d52:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d54:	40bc                	lw	a5,64(s1)
    80002d56:	dff1                	beqz	a5,80002d32 <iput+0x26>
    80002d58:	04a49783          	lh	a5,74(s1)
    80002d5c:	fbf9                	bnez	a5,80002d32 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d5e:	01048913          	addi	s2,s1,16
    80002d62:	854a                	mv	a0,s2
    80002d64:	00001097          	auipc	ra,0x1
    80002d68:	ab8080e7          	jalr	-1352(ra) # 8000381c <acquiresleep>
    release(&itable.lock);
    80002d6c:	00015517          	auipc	a0,0x15
    80002d70:	00c50513          	addi	a0,a0,12 # 80017d78 <itable>
    80002d74:	00003097          	auipc	ra,0x3
    80002d78:	4f6080e7          	jalr	1270(ra) # 8000626a <release>
    itrunc(ip);
    80002d7c:	8526                	mv	a0,s1
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	ee2080e7          	jalr	-286(ra) # 80002c60 <itrunc>
    ip->type = 0;
    80002d86:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d8a:	8526                	mv	a0,s1
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	cfc080e7          	jalr	-772(ra) # 80002a88 <iupdate>
    ip->valid = 0;
    80002d94:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d98:	854a                	mv	a0,s2
    80002d9a:	00001097          	auipc	ra,0x1
    80002d9e:	ad8080e7          	jalr	-1320(ra) # 80003872 <releasesleep>
    acquire(&itable.lock);
    80002da2:	00015517          	auipc	a0,0x15
    80002da6:	fd650513          	addi	a0,a0,-42 # 80017d78 <itable>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	40c080e7          	jalr	1036(ra) # 800061b6 <acquire>
    80002db2:	b741                	j	80002d32 <iput+0x26>

0000000080002db4 <iunlockput>:
{
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	1000                	addi	s0,sp,32
    80002dbe:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	e54080e7          	jalr	-428(ra) # 80002c14 <iunlock>
  iput(ip);
    80002dc8:	8526                	mv	a0,s1
    80002dca:	00000097          	auipc	ra,0x0
    80002dce:	f42080e7          	jalr	-190(ra) # 80002d0c <iput>
}
    80002dd2:	60e2                	ld	ra,24(sp)
    80002dd4:	6442                	ld	s0,16(sp)
    80002dd6:	64a2                	ld	s1,8(sp)
    80002dd8:	6105                	addi	sp,sp,32
    80002dda:	8082                	ret

0000000080002ddc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ddc:	1141                	addi	sp,sp,-16
    80002dde:	e422                	sd	s0,8(sp)
    80002de0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002de2:	411c                	lw	a5,0(a0)
    80002de4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002de6:	415c                	lw	a5,4(a0)
    80002de8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dea:	04451783          	lh	a5,68(a0)
    80002dee:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002df2:	04a51783          	lh	a5,74(a0)
    80002df6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dfa:	04c56783          	lwu	a5,76(a0)
    80002dfe:	e99c                	sd	a5,16(a1)
}
    80002e00:	6422                	ld	s0,8(sp)
    80002e02:	0141                	addi	sp,sp,16
    80002e04:	8082                	ret

0000000080002e06 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e06:	457c                	lw	a5,76(a0)
    80002e08:	0ed7e963          	bltu	a5,a3,80002efa <readi+0xf4>
{
    80002e0c:	7159                	addi	sp,sp,-112
    80002e0e:	f486                	sd	ra,104(sp)
    80002e10:	f0a2                	sd	s0,96(sp)
    80002e12:	eca6                	sd	s1,88(sp)
    80002e14:	e8ca                	sd	s2,80(sp)
    80002e16:	e4ce                	sd	s3,72(sp)
    80002e18:	e0d2                	sd	s4,64(sp)
    80002e1a:	fc56                	sd	s5,56(sp)
    80002e1c:	f85a                	sd	s6,48(sp)
    80002e1e:	f45e                	sd	s7,40(sp)
    80002e20:	f062                	sd	s8,32(sp)
    80002e22:	ec66                	sd	s9,24(sp)
    80002e24:	e86a                	sd	s10,16(sp)
    80002e26:	e46e                	sd	s11,8(sp)
    80002e28:	1880                	addi	s0,sp,112
    80002e2a:	8baa                	mv	s7,a0
    80002e2c:	8c2e                	mv	s8,a1
    80002e2e:	8ab2                	mv	s5,a2
    80002e30:	84b6                	mv	s1,a3
    80002e32:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e34:	9f35                	addw	a4,a4,a3
    return 0;
    80002e36:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e38:	0ad76063          	bltu	a4,a3,80002ed8 <readi+0xd2>
  if(off + n > ip->size)
    80002e3c:	00e7f463          	bgeu	a5,a4,80002e44 <readi+0x3e>
    n = ip->size - off;
    80002e40:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e44:	0a0b0963          	beqz	s6,80002ef6 <readi+0xf0>
    80002e48:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e4a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e4e:	5cfd                	li	s9,-1
    80002e50:	a82d                	j	80002e8a <readi+0x84>
    80002e52:	020a1d93          	slli	s11,s4,0x20
    80002e56:	020ddd93          	srli	s11,s11,0x20
    80002e5a:	05890613          	addi	a2,s2,88
    80002e5e:	86ee                	mv	a3,s11
    80002e60:	963a                	add	a2,a2,a4
    80002e62:	85d6                	mv	a1,s5
    80002e64:	8562                	mv	a0,s8
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	a52080e7          	jalr	-1454(ra) # 800018b8 <either_copyout>
    80002e6e:	05950d63          	beq	a0,s9,80002ec8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e72:	854a                	mv	a0,s2
    80002e74:	fffff097          	auipc	ra,0xfffff
    80002e78:	60c080e7          	jalr	1548(ra) # 80002480 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e7c:	013a09bb          	addw	s3,s4,s3
    80002e80:	009a04bb          	addw	s1,s4,s1
    80002e84:	9aee                	add	s5,s5,s11
    80002e86:	0569f763          	bgeu	s3,s6,80002ed4 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e8a:	000ba903          	lw	s2,0(s7)
    80002e8e:	00a4d59b          	srliw	a1,s1,0xa
    80002e92:	855e                	mv	a0,s7
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	8b0080e7          	jalr	-1872(ra) # 80002744 <bmap>
    80002e9c:	0005059b          	sext.w	a1,a0
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	4ae080e7          	jalr	1198(ra) # 80002350 <bread>
    80002eaa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eac:	3ff4f713          	andi	a4,s1,1023
    80002eb0:	40ed07bb          	subw	a5,s10,a4
    80002eb4:	413b06bb          	subw	a3,s6,s3
    80002eb8:	8a3e                	mv	s4,a5
    80002eba:	2781                	sext.w	a5,a5
    80002ebc:	0006861b          	sext.w	a2,a3
    80002ec0:	f8f679e3          	bgeu	a2,a5,80002e52 <readi+0x4c>
    80002ec4:	8a36                	mv	s4,a3
    80002ec6:	b771                	j	80002e52 <readi+0x4c>
      brelse(bp);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	5b6080e7          	jalr	1462(ra) # 80002480 <brelse>
      tot = -1;
    80002ed2:	59fd                	li	s3,-1
  }
  return tot;
    80002ed4:	0009851b          	sext.w	a0,s3
}
    80002ed8:	70a6                	ld	ra,104(sp)
    80002eda:	7406                	ld	s0,96(sp)
    80002edc:	64e6                	ld	s1,88(sp)
    80002ede:	6946                	ld	s2,80(sp)
    80002ee0:	69a6                	ld	s3,72(sp)
    80002ee2:	6a06                	ld	s4,64(sp)
    80002ee4:	7ae2                	ld	s5,56(sp)
    80002ee6:	7b42                	ld	s6,48(sp)
    80002ee8:	7ba2                	ld	s7,40(sp)
    80002eea:	7c02                	ld	s8,32(sp)
    80002eec:	6ce2                	ld	s9,24(sp)
    80002eee:	6d42                	ld	s10,16(sp)
    80002ef0:	6da2                	ld	s11,8(sp)
    80002ef2:	6165                	addi	sp,sp,112
    80002ef4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef6:	89da                	mv	s3,s6
    80002ef8:	bff1                	j	80002ed4 <readi+0xce>
    return 0;
    80002efa:	4501                	li	a0,0
}
    80002efc:	8082                	ret

0000000080002efe <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002efe:	457c                	lw	a5,76(a0)
    80002f00:	10d7e863          	bltu	a5,a3,80003010 <writei+0x112>
{
    80002f04:	7159                	addi	sp,sp,-112
    80002f06:	f486                	sd	ra,104(sp)
    80002f08:	f0a2                	sd	s0,96(sp)
    80002f0a:	eca6                	sd	s1,88(sp)
    80002f0c:	e8ca                	sd	s2,80(sp)
    80002f0e:	e4ce                	sd	s3,72(sp)
    80002f10:	e0d2                	sd	s4,64(sp)
    80002f12:	fc56                	sd	s5,56(sp)
    80002f14:	f85a                	sd	s6,48(sp)
    80002f16:	f45e                	sd	s7,40(sp)
    80002f18:	f062                	sd	s8,32(sp)
    80002f1a:	ec66                	sd	s9,24(sp)
    80002f1c:	e86a                	sd	s10,16(sp)
    80002f1e:	e46e                	sd	s11,8(sp)
    80002f20:	1880                	addi	s0,sp,112
    80002f22:	8b2a                	mv	s6,a0
    80002f24:	8c2e                	mv	s8,a1
    80002f26:	8ab2                	mv	s5,a2
    80002f28:	8936                	mv	s2,a3
    80002f2a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f2c:	00e687bb          	addw	a5,a3,a4
    80002f30:	0ed7e263          	bltu	a5,a3,80003014 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f34:	00043737          	lui	a4,0x43
    80002f38:	0ef76063          	bltu	a4,a5,80003018 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f3c:	0c0b8863          	beqz	s7,8000300c <writei+0x10e>
    80002f40:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f42:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f46:	5cfd                	li	s9,-1
    80002f48:	a091                	j	80002f8c <writei+0x8e>
    80002f4a:	02099d93          	slli	s11,s3,0x20
    80002f4e:	020ddd93          	srli	s11,s11,0x20
    80002f52:	05848513          	addi	a0,s1,88
    80002f56:	86ee                	mv	a3,s11
    80002f58:	8656                	mv	a2,s5
    80002f5a:	85e2                	mv	a1,s8
    80002f5c:	953a                	add	a0,a0,a4
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	9b0080e7          	jalr	-1616(ra) # 8000190e <either_copyin>
    80002f66:	07950263          	beq	a0,s9,80002fca <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	00000097          	auipc	ra,0x0
    80002f70:	790080e7          	jalr	1936(ra) # 800036fc <log_write>
    brelse(bp);
    80002f74:	8526                	mv	a0,s1
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	50a080e7          	jalr	1290(ra) # 80002480 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f7e:	01498a3b          	addw	s4,s3,s4
    80002f82:	0129893b          	addw	s2,s3,s2
    80002f86:	9aee                	add	s5,s5,s11
    80002f88:	057a7663          	bgeu	s4,s7,80002fd4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f8c:	000b2483          	lw	s1,0(s6)
    80002f90:	00a9559b          	srliw	a1,s2,0xa
    80002f94:	855a                	mv	a0,s6
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	7ae080e7          	jalr	1966(ra) # 80002744 <bmap>
    80002f9e:	0005059b          	sext.w	a1,a0
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	3ac080e7          	jalr	940(ra) # 80002350 <bread>
    80002fac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fae:	3ff97713          	andi	a4,s2,1023
    80002fb2:	40ed07bb          	subw	a5,s10,a4
    80002fb6:	414b86bb          	subw	a3,s7,s4
    80002fba:	89be                	mv	s3,a5
    80002fbc:	2781                	sext.w	a5,a5
    80002fbe:	0006861b          	sext.w	a2,a3
    80002fc2:	f8f674e3          	bgeu	a2,a5,80002f4a <writei+0x4c>
    80002fc6:	89b6                	mv	s3,a3
    80002fc8:	b749                	j	80002f4a <writei+0x4c>
      brelse(bp);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	4b4080e7          	jalr	1204(ra) # 80002480 <brelse>
  }

  if(off > ip->size)
    80002fd4:	04cb2783          	lw	a5,76(s6)
    80002fd8:	0127f463          	bgeu	a5,s2,80002fe0 <writei+0xe2>
    ip->size = off;
    80002fdc:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fe0:	855a                	mv	a0,s6
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	aa6080e7          	jalr	-1370(ra) # 80002a88 <iupdate>

  return tot;
    80002fea:	000a051b          	sext.w	a0,s4
}
    80002fee:	70a6                	ld	ra,104(sp)
    80002ff0:	7406                	ld	s0,96(sp)
    80002ff2:	64e6                	ld	s1,88(sp)
    80002ff4:	6946                	ld	s2,80(sp)
    80002ff6:	69a6                	ld	s3,72(sp)
    80002ff8:	6a06                	ld	s4,64(sp)
    80002ffa:	7ae2                	ld	s5,56(sp)
    80002ffc:	7b42                	ld	s6,48(sp)
    80002ffe:	7ba2                	ld	s7,40(sp)
    80003000:	7c02                	ld	s8,32(sp)
    80003002:	6ce2                	ld	s9,24(sp)
    80003004:	6d42                	ld	s10,16(sp)
    80003006:	6da2                	ld	s11,8(sp)
    80003008:	6165                	addi	sp,sp,112
    8000300a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000300c:	8a5e                	mv	s4,s7
    8000300e:	bfc9                	j	80002fe0 <writei+0xe2>
    return -1;
    80003010:	557d                	li	a0,-1
}
    80003012:	8082                	ret
    return -1;
    80003014:	557d                	li	a0,-1
    80003016:	bfe1                	j	80002fee <writei+0xf0>
    return -1;
    80003018:	557d                	li	a0,-1
    8000301a:	bfd1                	j	80002fee <writei+0xf0>

000000008000301c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000301c:	1141                	addi	sp,sp,-16
    8000301e:	e406                	sd	ra,8(sp)
    80003020:	e022                	sd	s0,0(sp)
    80003022:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003024:	4639                	li	a2,14
    80003026:	ffffd097          	auipc	ra,0xffffd
    8000302a:	22a080e7          	jalr	554(ra) # 80000250 <strncmp>
}
    8000302e:	60a2                	ld	ra,8(sp)
    80003030:	6402                	ld	s0,0(sp)
    80003032:	0141                	addi	sp,sp,16
    80003034:	8082                	ret

0000000080003036 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003036:	7139                	addi	sp,sp,-64
    80003038:	fc06                	sd	ra,56(sp)
    8000303a:	f822                	sd	s0,48(sp)
    8000303c:	f426                	sd	s1,40(sp)
    8000303e:	f04a                	sd	s2,32(sp)
    80003040:	ec4e                	sd	s3,24(sp)
    80003042:	e852                	sd	s4,16(sp)
    80003044:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003046:	04451703          	lh	a4,68(a0)
    8000304a:	4785                	li	a5,1
    8000304c:	00f71a63          	bne	a4,a5,80003060 <dirlookup+0x2a>
    80003050:	892a                	mv	s2,a0
    80003052:	89ae                	mv	s3,a1
    80003054:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003056:	457c                	lw	a5,76(a0)
    80003058:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000305a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	e79d                	bnez	a5,8000308a <dirlookup+0x54>
    8000305e:	a8a5                	j	800030d6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003060:	00005517          	auipc	a0,0x5
    80003064:	51850513          	addi	a0,a0,1304 # 80008578 <syscalls+0x1b0>
    80003068:	00003097          	auipc	ra,0x3
    8000306c:	ba0080e7          	jalr	-1120(ra) # 80005c08 <panic>
      panic("dirlookup read");
    80003070:	00005517          	auipc	a0,0x5
    80003074:	52050513          	addi	a0,a0,1312 # 80008590 <syscalls+0x1c8>
    80003078:	00003097          	auipc	ra,0x3
    8000307c:	b90080e7          	jalr	-1136(ra) # 80005c08 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003080:	24c1                	addiw	s1,s1,16
    80003082:	04c92783          	lw	a5,76(s2)
    80003086:	04f4f763          	bgeu	s1,a5,800030d4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000308a:	4741                	li	a4,16
    8000308c:	86a6                	mv	a3,s1
    8000308e:	fc040613          	addi	a2,s0,-64
    80003092:	4581                	li	a1,0
    80003094:	854a                	mv	a0,s2
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	d70080e7          	jalr	-656(ra) # 80002e06 <readi>
    8000309e:	47c1                	li	a5,16
    800030a0:	fcf518e3          	bne	a0,a5,80003070 <dirlookup+0x3a>
    if(de.inum == 0)
    800030a4:	fc045783          	lhu	a5,-64(s0)
    800030a8:	dfe1                	beqz	a5,80003080 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030aa:	fc240593          	addi	a1,s0,-62
    800030ae:	854e                	mv	a0,s3
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	f6c080e7          	jalr	-148(ra) # 8000301c <namecmp>
    800030b8:	f561                	bnez	a0,80003080 <dirlookup+0x4a>
      if(poff)
    800030ba:	000a0463          	beqz	s4,800030c2 <dirlookup+0x8c>
        *poff = off;
    800030be:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030c2:	fc045583          	lhu	a1,-64(s0)
    800030c6:	00092503          	lw	a0,0(s2)
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	754080e7          	jalr	1876(ra) # 8000281e <iget>
    800030d2:	a011                	j	800030d6 <dirlookup+0xa0>
  return 0;
    800030d4:	4501                	li	a0,0
}
    800030d6:	70e2                	ld	ra,56(sp)
    800030d8:	7442                	ld	s0,48(sp)
    800030da:	74a2                	ld	s1,40(sp)
    800030dc:	7902                	ld	s2,32(sp)
    800030de:	69e2                	ld	s3,24(sp)
    800030e0:	6a42                	ld	s4,16(sp)
    800030e2:	6121                	addi	sp,sp,64
    800030e4:	8082                	ret

00000000800030e6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030e6:	711d                	addi	sp,sp,-96
    800030e8:	ec86                	sd	ra,88(sp)
    800030ea:	e8a2                	sd	s0,80(sp)
    800030ec:	e4a6                	sd	s1,72(sp)
    800030ee:	e0ca                	sd	s2,64(sp)
    800030f0:	fc4e                	sd	s3,56(sp)
    800030f2:	f852                	sd	s4,48(sp)
    800030f4:	f456                	sd	s5,40(sp)
    800030f6:	f05a                	sd	s6,32(sp)
    800030f8:	ec5e                	sd	s7,24(sp)
    800030fa:	e862                	sd	s8,16(sp)
    800030fc:	e466                	sd	s9,8(sp)
    800030fe:	1080                	addi	s0,sp,96
    80003100:	84aa                	mv	s1,a0
    80003102:	8b2e                	mv	s6,a1
    80003104:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003106:	00054703          	lbu	a4,0(a0)
    8000310a:	02f00793          	li	a5,47
    8000310e:	02f70363          	beq	a4,a5,80003134 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003112:	ffffe097          	auipc	ra,0xffffe
    80003116:	d36080e7          	jalr	-714(ra) # 80000e48 <myproc>
    8000311a:	15053503          	ld	a0,336(a0)
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	9f6080e7          	jalr	-1546(ra) # 80002b14 <idup>
    80003126:	89aa                	mv	s3,a0
  while(*path == '/')
    80003128:	02f00913          	li	s2,47
  len = path - s;
    8000312c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000312e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003130:	4c05                	li	s8,1
    80003132:	a865                	j	800031ea <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003134:	4585                	li	a1,1
    80003136:	4505                	li	a0,1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	6e6080e7          	jalr	1766(ra) # 8000281e <iget>
    80003140:	89aa                	mv	s3,a0
    80003142:	b7dd                	j	80003128 <namex+0x42>
      iunlockput(ip);
    80003144:	854e                	mv	a0,s3
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	c6e080e7          	jalr	-914(ra) # 80002db4 <iunlockput>
      return 0;
    8000314e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003150:	854e                	mv	a0,s3
    80003152:	60e6                	ld	ra,88(sp)
    80003154:	6446                	ld	s0,80(sp)
    80003156:	64a6                	ld	s1,72(sp)
    80003158:	6906                	ld	s2,64(sp)
    8000315a:	79e2                	ld	s3,56(sp)
    8000315c:	7a42                	ld	s4,48(sp)
    8000315e:	7aa2                	ld	s5,40(sp)
    80003160:	7b02                	ld	s6,32(sp)
    80003162:	6be2                	ld	s7,24(sp)
    80003164:	6c42                	ld	s8,16(sp)
    80003166:	6ca2                	ld	s9,8(sp)
    80003168:	6125                	addi	sp,sp,96
    8000316a:	8082                	ret
      iunlock(ip);
    8000316c:	854e                	mv	a0,s3
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	aa6080e7          	jalr	-1370(ra) # 80002c14 <iunlock>
      return ip;
    80003176:	bfe9                	j	80003150 <namex+0x6a>
      iunlockput(ip);
    80003178:	854e                	mv	a0,s3
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	c3a080e7          	jalr	-966(ra) # 80002db4 <iunlockput>
      return 0;
    80003182:	89d2                	mv	s3,s4
    80003184:	b7f1                	j	80003150 <namex+0x6a>
  len = path - s;
    80003186:	40b48633          	sub	a2,s1,a1
    8000318a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000318e:	094cd463          	bge	s9,s4,80003216 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003192:	4639                	li	a2,14
    80003194:	8556                	mv	a0,s5
    80003196:	ffffd097          	auipc	ra,0xffffd
    8000319a:	042080e7          	jalr	66(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000319e:	0004c783          	lbu	a5,0(s1)
    800031a2:	01279763          	bne	a5,s2,800031b0 <namex+0xca>
    path++;
    800031a6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031a8:	0004c783          	lbu	a5,0(s1)
    800031ac:	ff278de3          	beq	a5,s2,800031a6 <namex+0xc0>
    ilock(ip);
    800031b0:	854e                	mv	a0,s3
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	9a0080e7          	jalr	-1632(ra) # 80002b52 <ilock>
    if(ip->type != T_DIR){
    800031ba:	04499783          	lh	a5,68(s3)
    800031be:	f98793e3          	bne	a5,s8,80003144 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031c2:	000b0563          	beqz	s6,800031cc <namex+0xe6>
    800031c6:	0004c783          	lbu	a5,0(s1)
    800031ca:	d3cd                	beqz	a5,8000316c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031cc:	865e                	mv	a2,s7
    800031ce:	85d6                	mv	a1,s5
    800031d0:	854e                	mv	a0,s3
    800031d2:	00000097          	auipc	ra,0x0
    800031d6:	e64080e7          	jalr	-412(ra) # 80003036 <dirlookup>
    800031da:	8a2a                	mv	s4,a0
    800031dc:	dd51                	beqz	a0,80003178 <namex+0x92>
    iunlockput(ip);
    800031de:	854e                	mv	a0,s3
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	bd4080e7          	jalr	-1068(ra) # 80002db4 <iunlockput>
    ip = next;
    800031e8:	89d2                	mv	s3,s4
  while(*path == '/')
    800031ea:	0004c783          	lbu	a5,0(s1)
    800031ee:	05279763          	bne	a5,s2,8000323c <namex+0x156>
    path++;
    800031f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	ff278de3          	beq	a5,s2,800031f2 <namex+0x10c>
  if(*path == 0)
    800031fc:	c79d                	beqz	a5,8000322a <namex+0x144>
    path++;
    800031fe:	85a6                	mv	a1,s1
  len = path - s;
    80003200:	8a5e                	mv	s4,s7
    80003202:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003204:	01278963          	beq	a5,s2,80003216 <namex+0x130>
    80003208:	dfbd                	beqz	a5,80003186 <namex+0xa0>
    path++;
    8000320a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000320c:	0004c783          	lbu	a5,0(s1)
    80003210:	ff279ce3          	bne	a5,s2,80003208 <namex+0x122>
    80003214:	bf8d                	j	80003186 <namex+0xa0>
    memmove(name, s, len);
    80003216:	2601                	sext.w	a2,a2
    80003218:	8556                	mv	a0,s5
    8000321a:	ffffd097          	auipc	ra,0xffffd
    8000321e:	fbe080e7          	jalr	-66(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003222:	9a56                	add	s4,s4,s5
    80003224:	000a0023          	sb	zero,0(s4)
    80003228:	bf9d                	j	8000319e <namex+0xb8>
  if(nameiparent){
    8000322a:	f20b03e3          	beqz	s6,80003150 <namex+0x6a>
    iput(ip);
    8000322e:	854e                	mv	a0,s3
    80003230:	00000097          	auipc	ra,0x0
    80003234:	adc080e7          	jalr	-1316(ra) # 80002d0c <iput>
    return 0;
    80003238:	4981                	li	s3,0
    8000323a:	bf19                	j	80003150 <namex+0x6a>
  if(*path == 0)
    8000323c:	d7fd                	beqz	a5,8000322a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000323e:	0004c783          	lbu	a5,0(s1)
    80003242:	85a6                	mv	a1,s1
    80003244:	b7d1                	j	80003208 <namex+0x122>

0000000080003246 <dirlink>:
{
    80003246:	7139                	addi	sp,sp,-64
    80003248:	fc06                	sd	ra,56(sp)
    8000324a:	f822                	sd	s0,48(sp)
    8000324c:	f426                	sd	s1,40(sp)
    8000324e:	f04a                	sd	s2,32(sp)
    80003250:	ec4e                	sd	s3,24(sp)
    80003252:	e852                	sd	s4,16(sp)
    80003254:	0080                	addi	s0,sp,64
    80003256:	892a                	mv	s2,a0
    80003258:	8a2e                	mv	s4,a1
    8000325a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000325c:	4601                	li	a2,0
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	dd8080e7          	jalr	-552(ra) # 80003036 <dirlookup>
    80003266:	e93d                	bnez	a0,800032dc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003268:	04c92483          	lw	s1,76(s2)
    8000326c:	c49d                	beqz	s1,8000329a <dirlink+0x54>
    8000326e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003270:	4741                	li	a4,16
    80003272:	86a6                	mv	a3,s1
    80003274:	fc040613          	addi	a2,s0,-64
    80003278:	4581                	li	a1,0
    8000327a:	854a                	mv	a0,s2
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	b8a080e7          	jalr	-1142(ra) # 80002e06 <readi>
    80003284:	47c1                	li	a5,16
    80003286:	06f51163          	bne	a0,a5,800032e8 <dirlink+0xa2>
    if(de.inum == 0)
    8000328a:	fc045783          	lhu	a5,-64(s0)
    8000328e:	c791                	beqz	a5,8000329a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003290:	24c1                	addiw	s1,s1,16
    80003292:	04c92783          	lw	a5,76(s2)
    80003296:	fcf4ede3          	bltu	s1,a5,80003270 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000329a:	4639                	li	a2,14
    8000329c:	85d2                	mv	a1,s4
    8000329e:	fc240513          	addi	a0,s0,-62
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	fea080e7          	jalr	-22(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032aa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ae:	4741                	li	a4,16
    800032b0:	86a6                	mv	a3,s1
    800032b2:	fc040613          	addi	a2,s0,-64
    800032b6:	4581                	li	a1,0
    800032b8:	854a                	mv	a0,s2
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	c44080e7          	jalr	-956(ra) # 80002efe <writei>
    800032c2:	872a                	mv	a4,a0
    800032c4:	47c1                	li	a5,16
  return 0;
    800032c6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c8:	02f71863          	bne	a4,a5,800032f8 <dirlink+0xb2>
}
    800032cc:	70e2                	ld	ra,56(sp)
    800032ce:	7442                	ld	s0,48(sp)
    800032d0:	74a2                	ld	s1,40(sp)
    800032d2:	7902                	ld	s2,32(sp)
    800032d4:	69e2                	ld	s3,24(sp)
    800032d6:	6a42                	ld	s4,16(sp)
    800032d8:	6121                	addi	sp,sp,64
    800032da:	8082                	ret
    iput(ip);
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	a30080e7          	jalr	-1488(ra) # 80002d0c <iput>
    return -1;
    800032e4:	557d                	li	a0,-1
    800032e6:	b7dd                	j	800032cc <dirlink+0x86>
      panic("dirlink read");
    800032e8:	00005517          	auipc	a0,0x5
    800032ec:	2b850513          	addi	a0,a0,696 # 800085a0 <syscalls+0x1d8>
    800032f0:	00003097          	auipc	ra,0x3
    800032f4:	918080e7          	jalr	-1768(ra) # 80005c08 <panic>
    panic("dirlink");
    800032f8:	00005517          	auipc	a0,0x5
    800032fc:	3b850513          	addi	a0,a0,952 # 800086b0 <syscalls+0x2e8>
    80003300:	00003097          	auipc	ra,0x3
    80003304:	908080e7          	jalr	-1784(ra) # 80005c08 <panic>

0000000080003308 <namei>:

struct inode*
namei(char *path)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003310:	fe040613          	addi	a2,s0,-32
    80003314:	4581                	li	a1,0
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	dd0080e7          	jalr	-560(ra) # 800030e6 <namex>
}
    8000331e:	60e2                	ld	ra,24(sp)
    80003320:	6442                	ld	s0,16(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret

0000000080003326 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003326:	1141                	addi	sp,sp,-16
    80003328:	e406                	sd	ra,8(sp)
    8000332a:	e022                	sd	s0,0(sp)
    8000332c:	0800                	addi	s0,sp,16
    8000332e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003330:	4585                	li	a1,1
    80003332:	00000097          	auipc	ra,0x0
    80003336:	db4080e7          	jalr	-588(ra) # 800030e6 <namex>
}
    8000333a:	60a2                	ld	ra,8(sp)
    8000333c:	6402                	ld	s0,0(sp)
    8000333e:	0141                	addi	sp,sp,16
    80003340:	8082                	ret

0000000080003342 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	e04a                	sd	s2,0(sp)
    8000334c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000334e:	00016917          	auipc	s2,0x16
    80003352:	4d290913          	addi	s2,s2,1234 # 80019820 <log>
    80003356:	01892583          	lw	a1,24(s2)
    8000335a:	02892503          	lw	a0,40(s2)
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	ff2080e7          	jalr	-14(ra) # 80002350 <bread>
    80003366:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003368:	02c92683          	lw	a3,44(s2)
    8000336c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000336e:	02d05763          	blez	a3,8000339c <write_head+0x5a>
    80003372:	00016797          	auipc	a5,0x16
    80003376:	4de78793          	addi	a5,a5,1246 # 80019850 <log+0x30>
    8000337a:	05c50713          	addi	a4,a0,92
    8000337e:	36fd                	addiw	a3,a3,-1
    80003380:	1682                	slli	a3,a3,0x20
    80003382:	9281                	srli	a3,a3,0x20
    80003384:	068a                	slli	a3,a3,0x2
    80003386:	00016617          	auipc	a2,0x16
    8000338a:	4ce60613          	addi	a2,a2,1230 # 80019854 <log+0x34>
    8000338e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003390:	4390                	lw	a2,0(a5)
    80003392:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003394:	0791                	addi	a5,a5,4
    80003396:	0711                	addi	a4,a4,4
    80003398:	fed79ce3          	bne	a5,a3,80003390 <write_head+0x4e>
  }
  bwrite(buf);
    8000339c:	8526                	mv	a0,s1
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	0a4080e7          	jalr	164(ra) # 80002442 <bwrite>
  brelse(buf);
    800033a6:	8526                	mv	a0,s1
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	0d8080e7          	jalr	216(ra) # 80002480 <brelse>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6902                	ld	s2,0(sp)
    800033b8:	6105                	addi	sp,sp,32
    800033ba:	8082                	ret

00000000800033bc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033bc:	00016797          	auipc	a5,0x16
    800033c0:	4907a783          	lw	a5,1168(a5) # 8001984c <log+0x2c>
    800033c4:	0af05d63          	blez	a5,8000347e <install_trans+0xc2>
{
    800033c8:	7139                	addi	sp,sp,-64
    800033ca:	fc06                	sd	ra,56(sp)
    800033cc:	f822                	sd	s0,48(sp)
    800033ce:	f426                	sd	s1,40(sp)
    800033d0:	f04a                	sd	s2,32(sp)
    800033d2:	ec4e                	sd	s3,24(sp)
    800033d4:	e852                	sd	s4,16(sp)
    800033d6:	e456                	sd	s5,8(sp)
    800033d8:	e05a                	sd	s6,0(sp)
    800033da:	0080                	addi	s0,sp,64
    800033dc:	8b2a                	mv	s6,a0
    800033de:	00016a97          	auipc	s5,0x16
    800033e2:	472a8a93          	addi	s5,s5,1138 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033e8:	00016997          	auipc	s3,0x16
    800033ec:	43898993          	addi	s3,s3,1080 # 80019820 <log>
    800033f0:	a035                	j	8000341c <install_trans+0x60>
      bunpin(dbuf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	166080e7          	jalr	358(ra) # 8000255a <bunpin>
    brelse(lbuf);
    800033fc:	854a                	mv	a0,s2
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	082080e7          	jalr	130(ra) # 80002480 <brelse>
    brelse(dbuf);
    80003406:	8526                	mv	a0,s1
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	078080e7          	jalr	120(ra) # 80002480 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003410:	2a05                	addiw	s4,s4,1
    80003412:	0a91                	addi	s5,s5,4
    80003414:	02c9a783          	lw	a5,44(s3)
    80003418:	04fa5963          	bge	s4,a5,8000346a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000341c:	0189a583          	lw	a1,24(s3)
    80003420:	014585bb          	addw	a1,a1,s4
    80003424:	2585                	addiw	a1,a1,1
    80003426:	0289a503          	lw	a0,40(s3)
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	f26080e7          	jalr	-218(ra) # 80002350 <bread>
    80003432:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003434:	000aa583          	lw	a1,0(s5)
    80003438:	0289a503          	lw	a0,40(s3)
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	f14080e7          	jalr	-236(ra) # 80002350 <bread>
    80003444:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003446:	40000613          	li	a2,1024
    8000344a:	05890593          	addi	a1,s2,88
    8000344e:	05850513          	addi	a0,a0,88
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	d86080e7          	jalr	-634(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000345a:	8526                	mv	a0,s1
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	fe6080e7          	jalr	-26(ra) # 80002442 <bwrite>
    if(recovering == 0)
    80003464:	f80b1ce3          	bnez	s6,800033fc <install_trans+0x40>
    80003468:	b769                	j	800033f2 <install_trans+0x36>
}
    8000346a:	70e2                	ld	ra,56(sp)
    8000346c:	7442                	ld	s0,48(sp)
    8000346e:	74a2                	ld	s1,40(sp)
    80003470:	7902                	ld	s2,32(sp)
    80003472:	69e2                	ld	s3,24(sp)
    80003474:	6a42                	ld	s4,16(sp)
    80003476:	6aa2                	ld	s5,8(sp)
    80003478:	6b02                	ld	s6,0(sp)
    8000347a:	6121                	addi	sp,sp,64
    8000347c:	8082                	ret
    8000347e:	8082                	ret

0000000080003480 <initlog>:
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
    80003490:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003492:	00016497          	auipc	s1,0x16
    80003496:	38e48493          	addi	s1,s1,910 # 80019820 <log>
    8000349a:	00005597          	auipc	a1,0x5
    8000349e:	11658593          	addi	a1,a1,278 # 800085b0 <syscalls+0x1e8>
    800034a2:	8526                	mv	a0,s1
    800034a4:	00003097          	auipc	ra,0x3
    800034a8:	c82080e7          	jalr	-894(ra) # 80006126 <initlock>
  log.start = sb->logstart;
    800034ac:	0149a583          	lw	a1,20(s3)
    800034b0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034b2:	0109a783          	lw	a5,16(s3)
    800034b6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034b8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034bc:	854a                	mv	a0,s2
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	e92080e7          	jalr	-366(ra) # 80002350 <bread>
  log.lh.n = lh->n;
    800034c6:	4d3c                	lw	a5,88(a0)
    800034c8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034ca:	02f05563          	blez	a5,800034f4 <initlog+0x74>
    800034ce:	05c50713          	addi	a4,a0,92
    800034d2:	00016697          	auipc	a3,0x16
    800034d6:	37e68693          	addi	a3,a3,894 # 80019850 <log+0x30>
    800034da:	37fd                	addiw	a5,a5,-1
    800034dc:	1782                	slli	a5,a5,0x20
    800034de:	9381                	srli	a5,a5,0x20
    800034e0:	078a                	slli	a5,a5,0x2
    800034e2:	06050613          	addi	a2,a0,96
    800034e6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800034e8:	4310                	lw	a2,0(a4)
    800034ea:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800034ec:	0711                	addi	a4,a4,4
    800034ee:	0691                	addi	a3,a3,4
    800034f0:	fef71ce3          	bne	a4,a5,800034e8 <initlog+0x68>
  brelse(buf);
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	f8c080e7          	jalr	-116(ra) # 80002480 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034fc:	4505                	li	a0,1
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	ebe080e7          	jalr	-322(ra) # 800033bc <install_trans>
  log.lh.n = 0;
    80003506:	00016797          	auipc	a5,0x16
    8000350a:	3407a323          	sw	zero,838(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	e34080e7          	jalr	-460(ra) # 80003342 <write_head>
}
    80003516:	70a2                	ld	ra,40(sp)
    80003518:	7402                	ld	s0,32(sp)
    8000351a:	64e2                	ld	s1,24(sp)
    8000351c:	6942                	ld	s2,16(sp)
    8000351e:	69a2                	ld	s3,8(sp)
    80003520:	6145                	addi	sp,sp,48
    80003522:	8082                	ret

0000000080003524 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003524:	1101                	addi	sp,sp,-32
    80003526:	ec06                	sd	ra,24(sp)
    80003528:	e822                	sd	s0,16(sp)
    8000352a:	e426                	sd	s1,8(sp)
    8000352c:	e04a                	sd	s2,0(sp)
    8000352e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003530:	00016517          	auipc	a0,0x16
    80003534:	2f050513          	addi	a0,a0,752 # 80019820 <log>
    80003538:	00003097          	auipc	ra,0x3
    8000353c:	c7e080e7          	jalr	-898(ra) # 800061b6 <acquire>
  while(1){
    if(log.committing){
    80003540:	00016497          	auipc	s1,0x16
    80003544:	2e048493          	addi	s1,s1,736 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003548:	4979                	li	s2,30
    8000354a:	a039                	j	80003558 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000354c:	85a6                	mv	a1,s1
    8000354e:	8526                	mv	a0,s1
    80003550:	ffffe097          	auipc	ra,0xffffe
    80003554:	fc4080e7          	jalr	-60(ra) # 80001514 <sleep>
    if(log.committing){
    80003558:	50dc                	lw	a5,36(s1)
    8000355a:	fbed                	bnez	a5,8000354c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000355c:	509c                	lw	a5,32(s1)
    8000355e:	0017871b          	addiw	a4,a5,1
    80003562:	0007069b          	sext.w	a3,a4
    80003566:	0027179b          	slliw	a5,a4,0x2
    8000356a:	9fb9                	addw	a5,a5,a4
    8000356c:	0017979b          	slliw	a5,a5,0x1
    80003570:	54d8                	lw	a4,44(s1)
    80003572:	9fb9                	addw	a5,a5,a4
    80003574:	00f95963          	bge	s2,a5,80003586 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003578:	85a6                	mv	a1,s1
    8000357a:	8526                	mv	a0,s1
    8000357c:	ffffe097          	auipc	ra,0xffffe
    80003580:	f98080e7          	jalr	-104(ra) # 80001514 <sleep>
    80003584:	bfd1                	j	80003558 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003586:	00016517          	auipc	a0,0x16
    8000358a:	29a50513          	addi	a0,a0,666 # 80019820 <log>
    8000358e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003590:	00003097          	auipc	ra,0x3
    80003594:	cda080e7          	jalr	-806(ra) # 8000626a <release>
      break;
    }
  }
}
    80003598:	60e2                	ld	ra,24(sp)
    8000359a:	6442                	ld	s0,16(sp)
    8000359c:	64a2                	ld	s1,8(sp)
    8000359e:	6902                	ld	s2,0(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret

00000000800035a4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035a4:	7139                	addi	sp,sp,-64
    800035a6:	fc06                	sd	ra,56(sp)
    800035a8:	f822                	sd	s0,48(sp)
    800035aa:	f426                	sd	s1,40(sp)
    800035ac:	f04a                	sd	s2,32(sp)
    800035ae:	ec4e                	sd	s3,24(sp)
    800035b0:	e852                	sd	s4,16(sp)
    800035b2:	e456                	sd	s5,8(sp)
    800035b4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035b6:	00016497          	auipc	s1,0x16
    800035ba:	26a48493          	addi	s1,s1,618 # 80019820 <log>
    800035be:	8526                	mv	a0,s1
    800035c0:	00003097          	auipc	ra,0x3
    800035c4:	bf6080e7          	jalr	-1034(ra) # 800061b6 <acquire>
  log.outstanding -= 1;
    800035c8:	509c                	lw	a5,32(s1)
    800035ca:	37fd                	addiw	a5,a5,-1
    800035cc:	0007891b          	sext.w	s2,a5
    800035d0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035d2:	50dc                	lw	a5,36(s1)
    800035d4:	efb9                	bnez	a5,80003632 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035d6:	06091663          	bnez	s2,80003642 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800035da:	00016497          	auipc	s1,0x16
    800035de:	24648493          	addi	s1,s1,582 # 80019820 <log>
    800035e2:	4785                	li	a5,1
    800035e4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035e6:	8526                	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	c82080e7          	jalr	-894(ra) # 8000626a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035f0:	54dc                	lw	a5,44(s1)
    800035f2:	06f04763          	bgtz	a5,80003660 <end_op+0xbc>
    acquire(&log.lock);
    800035f6:	00016497          	auipc	s1,0x16
    800035fa:	22a48493          	addi	s1,s1,554 # 80019820 <log>
    800035fe:	8526                	mv	a0,s1
    80003600:	00003097          	auipc	ra,0x3
    80003604:	bb6080e7          	jalr	-1098(ra) # 800061b6 <acquire>
    log.committing = 0;
    80003608:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	092080e7          	jalr	146(ra) # 800016a0 <wakeup>
    release(&log.lock);
    80003616:	8526                	mv	a0,s1
    80003618:	00003097          	auipc	ra,0x3
    8000361c:	c52080e7          	jalr	-942(ra) # 8000626a <release>
}
    80003620:	70e2                	ld	ra,56(sp)
    80003622:	7442                	ld	s0,48(sp)
    80003624:	74a2                	ld	s1,40(sp)
    80003626:	7902                	ld	s2,32(sp)
    80003628:	69e2                	ld	s3,24(sp)
    8000362a:	6a42                	ld	s4,16(sp)
    8000362c:	6aa2                	ld	s5,8(sp)
    8000362e:	6121                	addi	sp,sp,64
    80003630:	8082                	ret
    panic("log.committing");
    80003632:	00005517          	auipc	a0,0x5
    80003636:	f8650513          	addi	a0,a0,-122 # 800085b8 <syscalls+0x1f0>
    8000363a:	00002097          	auipc	ra,0x2
    8000363e:	5ce080e7          	jalr	1486(ra) # 80005c08 <panic>
    wakeup(&log);
    80003642:	00016497          	auipc	s1,0x16
    80003646:	1de48493          	addi	s1,s1,478 # 80019820 <log>
    8000364a:	8526                	mv	a0,s1
    8000364c:	ffffe097          	auipc	ra,0xffffe
    80003650:	054080e7          	jalr	84(ra) # 800016a0 <wakeup>
  release(&log.lock);
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	c14080e7          	jalr	-1004(ra) # 8000626a <release>
  if(do_commit){
    8000365e:	b7c9                	j	80003620 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003660:	00016a97          	auipc	s5,0x16
    80003664:	1f0a8a93          	addi	s5,s5,496 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003668:	00016a17          	auipc	s4,0x16
    8000366c:	1b8a0a13          	addi	s4,s4,440 # 80019820 <log>
    80003670:	018a2583          	lw	a1,24(s4)
    80003674:	012585bb          	addw	a1,a1,s2
    80003678:	2585                	addiw	a1,a1,1
    8000367a:	028a2503          	lw	a0,40(s4)
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	cd2080e7          	jalr	-814(ra) # 80002350 <bread>
    80003686:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003688:	000aa583          	lw	a1,0(s5)
    8000368c:	028a2503          	lw	a0,40(s4)
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	cc0080e7          	jalr	-832(ra) # 80002350 <bread>
    80003698:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000369a:	40000613          	li	a2,1024
    8000369e:	05850593          	addi	a1,a0,88
    800036a2:	05848513          	addi	a0,s1,88
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	b32080e7          	jalr	-1230(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036ae:	8526                	mv	a0,s1
    800036b0:	fffff097          	auipc	ra,0xfffff
    800036b4:	d92080e7          	jalr	-622(ra) # 80002442 <bwrite>
    brelse(from);
    800036b8:	854e                	mv	a0,s3
    800036ba:	fffff097          	auipc	ra,0xfffff
    800036be:	dc6080e7          	jalr	-570(ra) # 80002480 <brelse>
    brelse(to);
    800036c2:	8526                	mv	a0,s1
    800036c4:	fffff097          	auipc	ra,0xfffff
    800036c8:	dbc080e7          	jalr	-580(ra) # 80002480 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036cc:	2905                	addiw	s2,s2,1
    800036ce:	0a91                	addi	s5,s5,4
    800036d0:	02ca2783          	lw	a5,44(s4)
    800036d4:	f8f94ee3          	blt	s2,a5,80003670 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	c6a080e7          	jalr	-918(ra) # 80003342 <write_head>
    install_trans(0); // Now install writes to home locations
    800036e0:	4501                	li	a0,0
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	cda080e7          	jalr	-806(ra) # 800033bc <install_trans>
    log.lh.n = 0;
    800036ea:	00016797          	auipc	a5,0x16
    800036ee:	1607a123          	sw	zero,354(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	c50080e7          	jalr	-944(ra) # 80003342 <write_head>
    800036fa:	bdf5                	j	800035f6 <end_op+0x52>

00000000800036fc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036fc:	1101                	addi	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	e04a                	sd	s2,0(sp)
    80003706:	1000                	addi	s0,sp,32
    80003708:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000370a:	00016917          	auipc	s2,0x16
    8000370e:	11690913          	addi	s2,s2,278 # 80019820 <log>
    80003712:	854a                	mv	a0,s2
    80003714:	00003097          	auipc	ra,0x3
    80003718:	aa2080e7          	jalr	-1374(ra) # 800061b6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000371c:	02c92603          	lw	a2,44(s2)
    80003720:	47f5                	li	a5,29
    80003722:	06c7c563          	blt	a5,a2,8000378c <log_write+0x90>
    80003726:	00016797          	auipc	a5,0x16
    8000372a:	1167a783          	lw	a5,278(a5) # 8001983c <log+0x1c>
    8000372e:	37fd                	addiw	a5,a5,-1
    80003730:	04f65e63          	bge	a2,a5,8000378c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003734:	00016797          	auipc	a5,0x16
    80003738:	10c7a783          	lw	a5,268(a5) # 80019840 <log+0x20>
    8000373c:	06f05063          	blez	a5,8000379c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003740:	4781                	li	a5,0
    80003742:	06c05563          	blez	a2,800037ac <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003746:	44cc                	lw	a1,12(s1)
    80003748:	00016717          	auipc	a4,0x16
    8000374c:	10870713          	addi	a4,a4,264 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003750:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003752:	4314                	lw	a3,0(a4)
    80003754:	04b68c63          	beq	a3,a1,800037ac <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003758:	2785                	addiw	a5,a5,1
    8000375a:	0711                	addi	a4,a4,4
    8000375c:	fef61be3          	bne	a2,a5,80003752 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003760:	0621                	addi	a2,a2,8
    80003762:	060a                	slli	a2,a2,0x2
    80003764:	00016797          	auipc	a5,0x16
    80003768:	0bc78793          	addi	a5,a5,188 # 80019820 <log>
    8000376c:	963e                	add	a2,a2,a5
    8000376e:	44dc                	lw	a5,12(s1)
    80003770:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003772:	8526                	mv	a0,s1
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	daa080e7          	jalr	-598(ra) # 8000251e <bpin>
    log.lh.n++;
    8000377c:	00016717          	auipc	a4,0x16
    80003780:	0a470713          	addi	a4,a4,164 # 80019820 <log>
    80003784:	575c                	lw	a5,44(a4)
    80003786:	2785                	addiw	a5,a5,1
    80003788:	d75c                	sw	a5,44(a4)
    8000378a:	a835                	j	800037c6 <log_write+0xca>
    panic("too big a transaction");
    8000378c:	00005517          	auipc	a0,0x5
    80003790:	e3c50513          	addi	a0,a0,-452 # 800085c8 <syscalls+0x200>
    80003794:	00002097          	auipc	ra,0x2
    80003798:	474080e7          	jalr	1140(ra) # 80005c08 <panic>
    panic("log_write outside of trans");
    8000379c:	00005517          	auipc	a0,0x5
    800037a0:	e4450513          	addi	a0,a0,-444 # 800085e0 <syscalls+0x218>
    800037a4:	00002097          	auipc	ra,0x2
    800037a8:	464080e7          	jalr	1124(ra) # 80005c08 <panic>
  log.lh.block[i] = b->blockno;
    800037ac:	00878713          	addi	a4,a5,8
    800037b0:	00271693          	slli	a3,a4,0x2
    800037b4:	00016717          	auipc	a4,0x16
    800037b8:	06c70713          	addi	a4,a4,108 # 80019820 <log>
    800037bc:	9736                	add	a4,a4,a3
    800037be:	44d4                	lw	a3,12(s1)
    800037c0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037c2:	faf608e3          	beq	a2,a5,80003772 <log_write+0x76>
  }
  release(&log.lock);
    800037c6:	00016517          	auipc	a0,0x16
    800037ca:	05a50513          	addi	a0,a0,90 # 80019820 <log>
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	a9c080e7          	jalr	-1380(ra) # 8000626a <release>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret

00000000800037e2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037e2:	1101                	addi	sp,sp,-32
    800037e4:	ec06                	sd	ra,24(sp)
    800037e6:	e822                	sd	s0,16(sp)
    800037e8:	e426                	sd	s1,8(sp)
    800037ea:	e04a                	sd	s2,0(sp)
    800037ec:	1000                	addi	s0,sp,32
    800037ee:	84aa                	mv	s1,a0
    800037f0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037f2:	00005597          	auipc	a1,0x5
    800037f6:	e0e58593          	addi	a1,a1,-498 # 80008600 <syscalls+0x238>
    800037fa:	0521                	addi	a0,a0,8
    800037fc:	00003097          	auipc	ra,0x3
    80003800:	92a080e7          	jalr	-1750(ra) # 80006126 <initlock>
  lk->name = name;
    80003804:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003808:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000380c:	0204a423          	sw	zero,40(s1)
}
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6902                	ld	s2,0(sp)
    80003818:	6105                	addi	sp,sp,32
    8000381a:	8082                	ret

000000008000381c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000381c:	1101                	addi	sp,sp,-32
    8000381e:	ec06                	sd	ra,24(sp)
    80003820:	e822                	sd	s0,16(sp)
    80003822:	e426                	sd	s1,8(sp)
    80003824:	e04a                	sd	s2,0(sp)
    80003826:	1000                	addi	s0,sp,32
    80003828:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000382a:	00850913          	addi	s2,a0,8
    8000382e:	854a                	mv	a0,s2
    80003830:	00003097          	auipc	ra,0x3
    80003834:	986080e7          	jalr	-1658(ra) # 800061b6 <acquire>
  while (lk->locked) {
    80003838:	409c                	lw	a5,0(s1)
    8000383a:	cb89                	beqz	a5,8000384c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000383c:	85ca                	mv	a1,s2
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	cd4080e7          	jalr	-812(ra) # 80001514 <sleep>
  while (lk->locked) {
    80003848:	409c                	lw	a5,0(s1)
    8000384a:	fbed                	bnez	a5,8000383c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000384c:	4785                	li	a5,1
    8000384e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	5f8080e7          	jalr	1528(ra) # 80000e48 <myproc>
    80003858:	591c                	lw	a5,48(a0)
    8000385a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000385c:	854a                	mv	a0,s2
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	a0c080e7          	jalr	-1524(ra) # 8000626a <release>
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003880:	00850913          	addi	s2,a0,8
    80003884:	854a                	mv	a0,s2
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	930080e7          	jalr	-1744(ra) # 800061b6 <acquire>
  lk->locked = 0;
    8000388e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003892:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003896:	8526                	mv	a0,s1
    80003898:	ffffe097          	auipc	ra,0xffffe
    8000389c:	e08080e7          	jalr	-504(ra) # 800016a0 <wakeup>
  release(&lk->lk);
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	9c8080e7          	jalr	-1592(ra) # 8000626a <release>
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038b6:	7179                	addi	sp,sp,-48
    800038b8:	f406                	sd	ra,40(sp)
    800038ba:	f022                	sd	s0,32(sp)
    800038bc:	ec26                	sd	s1,24(sp)
    800038be:	e84a                	sd	s2,16(sp)
    800038c0:	e44e                	sd	s3,8(sp)
    800038c2:	1800                	addi	s0,sp,48
    800038c4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	8ea080e7          	jalr	-1814(ra) # 800061b6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d4:	409c                	lw	a5,0(s1)
    800038d6:	ef99                	bnez	a5,800038f4 <holdingsleep+0x3e>
    800038d8:	4481                	li	s1,0
  release(&lk->lk);
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	98e080e7          	jalr	-1650(ra) # 8000626a <release>
  return r;
}
    800038e4:	8526                	mv	a0,s1
    800038e6:	70a2                	ld	ra,40(sp)
    800038e8:	7402                	ld	s0,32(sp)
    800038ea:	64e2                	ld	s1,24(sp)
    800038ec:	6942                	ld	s2,16(sp)
    800038ee:	69a2                	ld	s3,8(sp)
    800038f0:	6145                	addi	sp,sp,48
    800038f2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038f4:	0284a983          	lw	s3,40(s1)
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	550080e7          	jalr	1360(ra) # 80000e48 <myproc>
    80003900:	5904                	lw	s1,48(a0)
    80003902:	413484b3          	sub	s1,s1,s3
    80003906:	0014b493          	seqz	s1,s1
    8000390a:	bfc1                	j	800038da <holdingsleep+0x24>

000000008000390c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000390c:	1141                	addi	sp,sp,-16
    8000390e:	e406                	sd	ra,8(sp)
    80003910:	e022                	sd	s0,0(sp)
    80003912:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003914:	00005597          	auipc	a1,0x5
    80003918:	cfc58593          	addi	a1,a1,-772 # 80008610 <syscalls+0x248>
    8000391c:	00016517          	auipc	a0,0x16
    80003920:	04c50513          	addi	a0,a0,76 # 80019968 <ftable>
    80003924:	00003097          	auipc	ra,0x3
    80003928:	802080e7          	jalr	-2046(ra) # 80006126 <initlock>
}
    8000392c:	60a2                	ld	ra,8(sp)
    8000392e:	6402                	ld	s0,0(sp)
    80003930:	0141                	addi	sp,sp,16
    80003932:	8082                	ret

0000000080003934 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000393e:	00016517          	auipc	a0,0x16
    80003942:	02a50513          	addi	a0,a0,42 # 80019968 <ftable>
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	870080e7          	jalr	-1936(ra) # 800061b6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000394e:	00016497          	auipc	s1,0x16
    80003952:	03248493          	addi	s1,s1,50 # 80019980 <ftable+0x18>
    80003956:	00017717          	auipc	a4,0x17
    8000395a:	fca70713          	addi	a4,a4,-54 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    8000395e:	40dc                	lw	a5,4(s1)
    80003960:	cf99                	beqz	a5,8000397e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003962:	02848493          	addi	s1,s1,40
    80003966:	fee49ce3          	bne	s1,a4,8000395e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000396a:	00016517          	auipc	a0,0x16
    8000396e:	ffe50513          	addi	a0,a0,-2 # 80019968 <ftable>
    80003972:	00003097          	auipc	ra,0x3
    80003976:	8f8080e7          	jalr	-1800(ra) # 8000626a <release>
  return 0;
    8000397a:	4481                	li	s1,0
    8000397c:	a819                	j	80003992 <filealloc+0x5e>
      f->ref = 1;
    8000397e:	4785                	li	a5,1
    80003980:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003982:	00016517          	auipc	a0,0x16
    80003986:	fe650513          	addi	a0,a0,-26 # 80019968 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	8e0080e7          	jalr	-1824(ra) # 8000626a <release>
}
    80003992:	8526                	mv	a0,s1
    80003994:	60e2                	ld	ra,24(sp)
    80003996:	6442                	ld	s0,16(sp)
    80003998:	64a2                	ld	s1,8(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret

000000008000399e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	addi	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039aa:	00016517          	auipc	a0,0x16
    800039ae:	fbe50513          	addi	a0,a0,-66 # 80019968 <ftable>
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	804080e7          	jalr	-2044(ra) # 800061b6 <acquire>
  if(f->ref < 1)
    800039ba:	40dc                	lw	a5,4(s1)
    800039bc:	02f05263          	blez	a5,800039e0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039c0:	2785                	addiw	a5,a5,1
    800039c2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039c4:	00016517          	auipc	a0,0x16
    800039c8:	fa450513          	addi	a0,a0,-92 # 80019968 <ftable>
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	89e080e7          	jalr	-1890(ra) # 8000626a <release>
  return f;
}
    800039d4:	8526                	mv	a0,s1
    800039d6:	60e2                	ld	ra,24(sp)
    800039d8:	6442                	ld	s0,16(sp)
    800039da:	64a2                	ld	s1,8(sp)
    800039dc:	6105                	addi	sp,sp,32
    800039de:	8082                	ret
    panic("filedup");
    800039e0:	00005517          	auipc	a0,0x5
    800039e4:	c3850513          	addi	a0,a0,-968 # 80008618 <syscalls+0x250>
    800039e8:	00002097          	auipc	ra,0x2
    800039ec:	220080e7          	jalr	544(ra) # 80005c08 <panic>

00000000800039f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039f0:	7139                	addi	sp,sp,-64
    800039f2:	fc06                	sd	ra,56(sp)
    800039f4:	f822                	sd	s0,48(sp)
    800039f6:	f426                	sd	s1,40(sp)
    800039f8:	f04a                	sd	s2,32(sp)
    800039fa:	ec4e                	sd	s3,24(sp)
    800039fc:	e852                	sd	s4,16(sp)
    800039fe:	e456                	sd	s5,8(sp)
    80003a00:	0080                	addi	s0,sp,64
    80003a02:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a04:	00016517          	auipc	a0,0x16
    80003a08:	f6450513          	addi	a0,a0,-156 # 80019968 <ftable>
    80003a0c:	00002097          	auipc	ra,0x2
    80003a10:	7aa080e7          	jalr	1962(ra) # 800061b6 <acquire>
  if(f->ref < 1)
    80003a14:	40dc                	lw	a5,4(s1)
    80003a16:	06f05163          	blez	a5,80003a78 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a1a:	37fd                	addiw	a5,a5,-1
    80003a1c:	0007871b          	sext.w	a4,a5
    80003a20:	c0dc                	sw	a5,4(s1)
    80003a22:	06e04363          	bgtz	a4,80003a88 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a26:	0004a903          	lw	s2,0(s1)
    80003a2a:	0094ca83          	lbu	s5,9(s1)
    80003a2e:	0104ba03          	ld	s4,16(s1)
    80003a32:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a36:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a3a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a3e:	00016517          	auipc	a0,0x16
    80003a42:	f2a50513          	addi	a0,a0,-214 # 80019968 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	824080e7          	jalr	-2012(ra) # 8000626a <release>

  if(ff.type == FD_PIPE){
    80003a4e:	4785                	li	a5,1
    80003a50:	04f90d63          	beq	s2,a5,80003aaa <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a54:	3979                	addiw	s2,s2,-2
    80003a56:	4785                	li	a5,1
    80003a58:	0527e063          	bltu	a5,s2,80003a98 <fileclose+0xa8>
    begin_op();
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	ac8080e7          	jalr	-1336(ra) # 80003524 <begin_op>
    iput(ff.ip);
    80003a64:	854e                	mv	a0,s3
    80003a66:	fffff097          	auipc	ra,0xfffff
    80003a6a:	2a6080e7          	jalr	678(ra) # 80002d0c <iput>
    end_op();
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	b36080e7          	jalr	-1226(ra) # 800035a4 <end_op>
    80003a76:	a00d                	j	80003a98 <fileclose+0xa8>
    panic("fileclose");
    80003a78:	00005517          	auipc	a0,0x5
    80003a7c:	ba850513          	addi	a0,a0,-1112 # 80008620 <syscalls+0x258>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	188080e7          	jalr	392(ra) # 80005c08 <panic>
    release(&ftable.lock);
    80003a88:	00016517          	auipc	a0,0x16
    80003a8c:	ee050513          	addi	a0,a0,-288 # 80019968 <ftable>
    80003a90:	00002097          	auipc	ra,0x2
    80003a94:	7da080e7          	jalr	2010(ra) # 8000626a <release>
  }
}
    80003a98:	70e2                	ld	ra,56(sp)
    80003a9a:	7442                	ld	s0,48(sp)
    80003a9c:	74a2                	ld	s1,40(sp)
    80003a9e:	7902                	ld	s2,32(sp)
    80003aa0:	69e2                	ld	s3,24(sp)
    80003aa2:	6a42                	ld	s4,16(sp)
    80003aa4:	6aa2                	ld	s5,8(sp)
    80003aa6:	6121                	addi	sp,sp,64
    80003aa8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003aaa:	85d6                	mv	a1,s5
    80003aac:	8552                	mv	a0,s4
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	34c080e7          	jalr	844(ra) # 80003dfa <pipeclose>
    80003ab6:	b7cd                	j	80003a98 <fileclose+0xa8>

0000000080003ab8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ab8:	715d                	addi	sp,sp,-80
    80003aba:	e486                	sd	ra,72(sp)
    80003abc:	e0a2                	sd	s0,64(sp)
    80003abe:	fc26                	sd	s1,56(sp)
    80003ac0:	f84a                	sd	s2,48(sp)
    80003ac2:	f44e                	sd	s3,40(sp)
    80003ac4:	0880                	addi	s0,sp,80
    80003ac6:	84aa                	mv	s1,a0
    80003ac8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	37e080e7          	jalr	894(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ad2:	409c                	lw	a5,0(s1)
    80003ad4:	37f9                	addiw	a5,a5,-2
    80003ad6:	4705                	li	a4,1
    80003ad8:	04f76763          	bltu	a4,a5,80003b26 <filestat+0x6e>
    80003adc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ade:	6c88                	ld	a0,24(s1)
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	072080e7          	jalr	114(ra) # 80002b52 <ilock>
    stati(f->ip, &st);
    80003ae8:	fb840593          	addi	a1,s0,-72
    80003aec:	6c88                	ld	a0,24(s1)
    80003aee:	fffff097          	auipc	ra,0xfffff
    80003af2:	2ee080e7          	jalr	750(ra) # 80002ddc <stati>
    iunlock(f->ip);
    80003af6:	6c88                	ld	a0,24(s1)
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	11c080e7          	jalr	284(ra) # 80002c14 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b00:	46e1                	li	a3,24
    80003b02:	fb840613          	addi	a2,s0,-72
    80003b06:	85ce                	mv	a1,s3
    80003b08:	05093503          	ld	a0,80(s2)
    80003b0c:	ffffd097          	auipc	ra,0xffffd
    80003b10:	ffe080e7          	jalr	-2(ra) # 80000b0a <copyout>
    80003b14:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b18:	60a6                	ld	ra,72(sp)
    80003b1a:	6406                	ld	s0,64(sp)
    80003b1c:	74e2                	ld	s1,56(sp)
    80003b1e:	7942                	ld	s2,48(sp)
    80003b20:	79a2                	ld	s3,40(sp)
    80003b22:	6161                	addi	sp,sp,80
    80003b24:	8082                	ret
  return -1;
    80003b26:	557d                	li	a0,-1
    80003b28:	bfc5                	j	80003b18 <filestat+0x60>

0000000080003b2a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b2a:	7179                	addi	sp,sp,-48
    80003b2c:	f406                	sd	ra,40(sp)
    80003b2e:	f022                	sd	s0,32(sp)
    80003b30:	ec26                	sd	s1,24(sp)
    80003b32:	e84a                	sd	s2,16(sp)
    80003b34:	e44e                	sd	s3,8(sp)
    80003b36:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b38:	00854783          	lbu	a5,8(a0)
    80003b3c:	c3d5                	beqz	a5,80003be0 <fileread+0xb6>
    80003b3e:	84aa                	mv	s1,a0
    80003b40:	89ae                	mv	s3,a1
    80003b42:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b44:	411c                	lw	a5,0(a0)
    80003b46:	4705                	li	a4,1
    80003b48:	04e78963          	beq	a5,a4,80003b9a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b4c:	470d                	li	a4,3
    80003b4e:	04e78d63          	beq	a5,a4,80003ba8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b52:	4709                	li	a4,2
    80003b54:	06e79e63          	bne	a5,a4,80003bd0 <fileread+0xa6>
    ilock(f->ip);
    80003b58:	6d08                	ld	a0,24(a0)
    80003b5a:	fffff097          	auipc	ra,0xfffff
    80003b5e:	ff8080e7          	jalr	-8(ra) # 80002b52 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b62:	874a                	mv	a4,s2
    80003b64:	5094                	lw	a3,32(s1)
    80003b66:	864e                	mv	a2,s3
    80003b68:	4585                	li	a1,1
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	29a080e7          	jalr	666(ra) # 80002e06 <readi>
    80003b74:	892a                	mv	s2,a0
    80003b76:	00a05563          	blez	a0,80003b80 <fileread+0x56>
      f->off += r;
    80003b7a:	509c                	lw	a5,32(s1)
    80003b7c:	9fa9                	addw	a5,a5,a0
    80003b7e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b80:	6c88                	ld	a0,24(s1)
    80003b82:	fffff097          	auipc	ra,0xfffff
    80003b86:	092080e7          	jalr	146(ra) # 80002c14 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b8a:	854a                	mv	a0,s2
    80003b8c:	70a2                	ld	ra,40(sp)
    80003b8e:	7402                	ld	s0,32(sp)
    80003b90:	64e2                	ld	s1,24(sp)
    80003b92:	6942                	ld	s2,16(sp)
    80003b94:	69a2                	ld	s3,8(sp)
    80003b96:	6145                	addi	sp,sp,48
    80003b98:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b9a:	6908                	ld	a0,16(a0)
    80003b9c:	00000097          	auipc	ra,0x0
    80003ba0:	3c8080e7          	jalr	968(ra) # 80003f64 <piperead>
    80003ba4:	892a                	mv	s2,a0
    80003ba6:	b7d5                	j	80003b8a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ba8:	02451783          	lh	a5,36(a0)
    80003bac:	03079693          	slli	a3,a5,0x30
    80003bb0:	92c1                	srli	a3,a3,0x30
    80003bb2:	4725                	li	a4,9
    80003bb4:	02d76863          	bltu	a4,a3,80003be4 <fileread+0xba>
    80003bb8:	0792                	slli	a5,a5,0x4
    80003bba:	00016717          	auipc	a4,0x16
    80003bbe:	d0e70713          	addi	a4,a4,-754 # 800198c8 <devsw>
    80003bc2:	97ba                	add	a5,a5,a4
    80003bc4:	639c                	ld	a5,0(a5)
    80003bc6:	c38d                	beqz	a5,80003be8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bc8:	4505                	li	a0,1
    80003bca:	9782                	jalr	a5
    80003bcc:	892a                	mv	s2,a0
    80003bce:	bf75                	j	80003b8a <fileread+0x60>
    panic("fileread");
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	a6050513          	addi	a0,a0,-1440 # 80008630 <syscalls+0x268>
    80003bd8:	00002097          	auipc	ra,0x2
    80003bdc:	030080e7          	jalr	48(ra) # 80005c08 <panic>
    return -1;
    80003be0:	597d                	li	s2,-1
    80003be2:	b765                	j	80003b8a <fileread+0x60>
      return -1;
    80003be4:	597d                	li	s2,-1
    80003be6:	b755                	j	80003b8a <fileread+0x60>
    80003be8:	597d                	li	s2,-1
    80003bea:	b745                	j	80003b8a <fileread+0x60>

0000000080003bec <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bec:	715d                	addi	sp,sp,-80
    80003bee:	e486                	sd	ra,72(sp)
    80003bf0:	e0a2                	sd	s0,64(sp)
    80003bf2:	fc26                	sd	s1,56(sp)
    80003bf4:	f84a                	sd	s2,48(sp)
    80003bf6:	f44e                	sd	s3,40(sp)
    80003bf8:	f052                	sd	s4,32(sp)
    80003bfa:	ec56                	sd	s5,24(sp)
    80003bfc:	e85a                	sd	s6,16(sp)
    80003bfe:	e45e                	sd	s7,8(sp)
    80003c00:	e062                	sd	s8,0(sp)
    80003c02:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c04:	00954783          	lbu	a5,9(a0)
    80003c08:	10078663          	beqz	a5,80003d14 <filewrite+0x128>
    80003c0c:	892a                	mv	s2,a0
    80003c0e:	8aae                	mv	s5,a1
    80003c10:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c12:	411c                	lw	a5,0(a0)
    80003c14:	4705                	li	a4,1
    80003c16:	02e78263          	beq	a5,a4,80003c3a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c1a:	470d                	li	a4,3
    80003c1c:	02e78663          	beq	a5,a4,80003c48 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c20:	4709                	li	a4,2
    80003c22:	0ee79163          	bne	a5,a4,80003d04 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c26:	0ac05d63          	blez	a2,80003ce0 <filewrite+0xf4>
    int i = 0;
    80003c2a:	4981                	li	s3,0
    80003c2c:	6b05                	lui	s6,0x1
    80003c2e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c32:	6b85                	lui	s7,0x1
    80003c34:	c00b8b9b          	addiw	s7,s7,-1024
    80003c38:	a861                	j	80003cd0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c3a:	6908                	ld	a0,16(a0)
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	22e080e7          	jalr	558(ra) # 80003e6a <pipewrite>
    80003c44:	8a2a                	mv	s4,a0
    80003c46:	a045                	j	80003ce6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c48:	02451783          	lh	a5,36(a0)
    80003c4c:	03079693          	slli	a3,a5,0x30
    80003c50:	92c1                	srli	a3,a3,0x30
    80003c52:	4725                	li	a4,9
    80003c54:	0cd76263          	bltu	a4,a3,80003d18 <filewrite+0x12c>
    80003c58:	0792                	slli	a5,a5,0x4
    80003c5a:	00016717          	auipc	a4,0x16
    80003c5e:	c6e70713          	addi	a4,a4,-914 # 800198c8 <devsw>
    80003c62:	97ba                	add	a5,a5,a4
    80003c64:	679c                	ld	a5,8(a5)
    80003c66:	cbdd                	beqz	a5,80003d1c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c68:	4505                	li	a0,1
    80003c6a:	9782                	jalr	a5
    80003c6c:	8a2a                	mv	s4,a0
    80003c6e:	a8a5                	j	80003ce6 <filewrite+0xfa>
    80003c70:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	8b0080e7          	jalr	-1872(ra) # 80003524 <begin_op>
      ilock(f->ip);
    80003c7c:	01893503          	ld	a0,24(s2)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	ed2080e7          	jalr	-302(ra) # 80002b52 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c88:	8762                	mv	a4,s8
    80003c8a:	02092683          	lw	a3,32(s2)
    80003c8e:	01598633          	add	a2,s3,s5
    80003c92:	4585                	li	a1,1
    80003c94:	01893503          	ld	a0,24(s2)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	266080e7          	jalr	614(ra) # 80002efe <writei>
    80003ca0:	84aa                	mv	s1,a0
    80003ca2:	00a05763          	blez	a0,80003cb0 <filewrite+0xc4>
        f->off += r;
    80003ca6:	02092783          	lw	a5,32(s2)
    80003caa:	9fa9                	addw	a5,a5,a0
    80003cac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cb0:	01893503          	ld	a0,24(s2)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	f60080e7          	jalr	-160(ra) # 80002c14 <iunlock>
      end_op();
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	8e8080e7          	jalr	-1816(ra) # 800035a4 <end_op>

      if(r != n1){
    80003cc4:	009c1f63          	bne	s8,s1,80003ce2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cc8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ccc:	0149db63          	bge	s3,s4,80003ce2 <filewrite+0xf6>
      int n1 = n - i;
    80003cd0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cd4:	84be                	mv	s1,a5
    80003cd6:	2781                	sext.w	a5,a5
    80003cd8:	f8fb5ce3          	bge	s6,a5,80003c70 <filewrite+0x84>
    80003cdc:	84de                	mv	s1,s7
    80003cde:	bf49                	j	80003c70 <filewrite+0x84>
    int i = 0;
    80003ce0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ce2:	013a1f63          	bne	s4,s3,80003d00 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ce6:	8552                	mv	a0,s4
    80003ce8:	60a6                	ld	ra,72(sp)
    80003cea:	6406                	ld	s0,64(sp)
    80003cec:	74e2                	ld	s1,56(sp)
    80003cee:	7942                	ld	s2,48(sp)
    80003cf0:	79a2                	ld	s3,40(sp)
    80003cf2:	7a02                	ld	s4,32(sp)
    80003cf4:	6ae2                	ld	s5,24(sp)
    80003cf6:	6b42                	ld	s6,16(sp)
    80003cf8:	6ba2                	ld	s7,8(sp)
    80003cfa:	6c02                	ld	s8,0(sp)
    80003cfc:	6161                	addi	sp,sp,80
    80003cfe:	8082                	ret
    ret = (i == n ? n : -1);
    80003d00:	5a7d                	li	s4,-1
    80003d02:	b7d5                	j	80003ce6 <filewrite+0xfa>
    panic("filewrite");
    80003d04:	00005517          	auipc	a0,0x5
    80003d08:	93c50513          	addi	a0,a0,-1732 # 80008640 <syscalls+0x278>
    80003d0c:	00002097          	auipc	ra,0x2
    80003d10:	efc080e7          	jalr	-260(ra) # 80005c08 <panic>
    return -1;
    80003d14:	5a7d                	li	s4,-1
    80003d16:	bfc1                	j	80003ce6 <filewrite+0xfa>
      return -1;
    80003d18:	5a7d                	li	s4,-1
    80003d1a:	b7f1                	j	80003ce6 <filewrite+0xfa>
    80003d1c:	5a7d                	li	s4,-1
    80003d1e:	b7e1                	j	80003ce6 <filewrite+0xfa>

0000000080003d20 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d20:	7179                	addi	sp,sp,-48
    80003d22:	f406                	sd	ra,40(sp)
    80003d24:	f022                	sd	s0,32(sp)
    80003d26:	ec26                	sd	s1,24(sp)
    80003d28:	e84a                	sd	s2,16(sp)
    80003d2a:	e44e                	sd	s3,8(sp)
    80003d2c:	e052                	sd	s4,0(sp)
    80003d2e:	1800                	addi	s0,sp,48
    80003d30:	84aa                	mv	s1,a0
    80003d32:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d34:	0005b023          	sd	zero,0(a1)
    80003d38:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d3c:	00000097          	auipc	ra,0x0
    80003d40:	bf8080e7          	jalr	-1032(ra) # 80003934 <filealloc>
    80003d44:	e088                	sd	a0,0(s1)
    80003d46:	c551                	beqz	a0,80003dd2 <pipealloc+0xb2>
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	bec080e7          	jalr	-1044(ra) # 80003934 <filealloc>
    80003d50:	00aa3023          	sd	a0,0(s4)
    80003d54:	c92d                	beqz	a0,80003dc6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d56:	ffffc097          	auipc	ra,0xffffc
    80003d5a:	3c2080e7          	jalr	962(ra) # 80000118 <kalloc>
    80003d5e:	892a                	mv	s2,a0
    80003d60:	c125                	beqz	a0,80003dc0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d62:	4985                	li	s3,1
    80003d64:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d68:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d6c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d70:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d74:	00005597          	auipc	a1,0x5
    80003d78:	8dc58593          	addi	a1,a1,-1828 # 80008650 <syscalls+0x288>
    80003d7c:	00002097          	auipc	ra,0x2
    80003d80:	3aa080e7          	jalr	938(ra) # 80006126 <initlock>
  (*f0)->type = FD_PIPE;
    80003d84:	609c                	ld	a5,0(s1)
    80003d86:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d8a:	609c                	ld	a5,0(s1)
    80003d8c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d90:	609c                	ld	a5,0(s1)
    80003d92:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d96:	609c                	ld	a5,0(s1)
    80003d98:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d9c:	000a3783          	ld	a5,0(s4)
    80003da0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003da4:	000a3783          	ld	a5,0(s4)
    80003da8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dac:	000a3783          	ld	a5,0(s4)
    80003db0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003db4:	000a3783          	ld	a5,0(s4)
    80003db8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dbc:	4501                	li	a0,0
    80003dbe:	a025                	j	80003de6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dc0:	6088                	ld	a0,0(s1)
    80003dc2:	e501                	bnez	a0,80003dca <pipealloc+0xaa>
    80003dc4:	a039                	j	80003dd2 <pipealloc+0xb2>
    80003dc6:	6088                	ld	a0,0(s1)
    80003dc8:	c51d                	beqz	a0,80003df6 <pipealloc+0xd6>
    fileclose(*f0);
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	c26080e7          	jalr	-986(ra) # 800039f0 <fileclose>
  if(*f1)
    80003dd2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dd6:	557d                	li	a0,-1
  if(*f1)
    80003dd8:	c799                	beqz	a5,80003de6 <pipealloc+0xc6>
    fileclose(*f1);
    80003dda:	853e                	mv	a0,a5
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	c14080e7          	jalr	-1004(ra) # 800039f0 <fileclose>
  return -1;
    80003de4:	557d                	li	a0,-1
}
    80003de6:	70a2                	ld	ra,40(sp)
    80003de8:	7402                	ld	s0,32(sp)
    80003dea:	64e2                	ld	s1,24(sp)
    80003dec:	6942                	ld	s2,16(sp)
    80003dee:	69a2                	ld	s3,8(sp)
    80003df0:	6a02                	ld	s4,0(sp)
    80003df2:	6145                	addi	sp,sp,48
    80003df4:	8082                	ret
  return -1;
    80003df6:	557d                	li	a0,-1
    80003df8:	b7fd                	j	80003de6 <pipealloc+0xc6>

0000000080003dfa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dfa:	1101                	addi	sp,sp,-32
    80003dfc:	ec06                	sd	ra,24(sp)
    80003dfe:	e822                	sd	s0,16(sp)
    80003e00:	e426                	sd	s1,8(sp)
    80003e02:	e04a                	sd	s2,0(sp)
    80003e04:	1000                	addi	s0,sp,32
    80003e06:	84aa                	mv	s1,a0
    80003e08:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	3ac080e7          	jalr	940(ra) # 800061b6 <acquire>
  if(writable){
    80003e12:	02090d63          	beqz	s2,80003e4c <pipeclose+0x52>
    pi->writeopen = 0;
    80003e16:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e1a:	21848513          	addi	a0,s1,536
    80003e1e:	ffffe097          	auipc	ra,0xffffe
    80003e22:	882080e7          	jalr	-1918(ra) # 800016a0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e26:	2204b783          	ld	a5,544(s1)
    80003e2a:	eb95                	bnez	a5,80003e5e <pipeclose+0x64>
    release(&pi->lock);
    80003e2c:	8526                	mv	a0,s1
    80003e2e:	00002097          	auipc	ra,0x2
    80003e32:	43c080e7          	jalr	1084(ra) # 8000626a <release>
    kfree((char*)pi);
    80003e36:	8526                	mv	a0,s1
    80003e38:	ffffc097          	auipc	ra,0xffffc
    80003e3c:	1e4080e7          	jalr	484(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e40:	60e2                	ld	ra,24(sp)
    80003e42:	6442                	ld	s0,16(sp)
    80003e44:	64a2                	ld	s1,8(sp)
    80003e46:	6902                	ld	s2,0(sp)
    80003e48:	6105                	addi	sp,sp,32
    80003e4a:	8082                	ret
    pi->readopen = 0;
    80003e4c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e50:	21c48513          	addi	a0,s1,540
    80003e54:	ffffe097          	auipc	ra,0xffffe
    80003e58:	84c080e7          	jalr	-1972(ra) # 800016a0 <wakeup>
    80003e5c:	b7e9                	j	80003e26 <pipeclose+0x2c>
    release(&pi->lock);
    80003e5e:	8526                	mv	a0,s1
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	40a080e7          	jalr	1034(ra) # 8000626a <release>
}
    80003e68:	bfe1                	j	80003e40 <pipeclose+0x46>

0000000080003e6a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e6a:	7159                	addi	sp,sp,-112
    80003e6c:	f486                	sd	ra,104(sp)
    80003e6e:	f0a2                	sd	s0,96(sp)
    80003e70:	eca6                	sd	s1,88(sp)
    80003e72:	e8ca                	sd	s2,80(sp)
    80003e74:	e4ce                	sd	s3,72(sp)
    80003e76:	e0d2                	sd	s4,64(sp)
    80003e78:	fc56                	sd	s5,56(sp)
    80003e7a:	f85a                	sd	s6,48(sp)
    80003e7c:	f45e                	sd	s7,40(sp)
    80003e7e:	f062                	sd	s8,32(sp)
    80003e80:	ec66                	sd	s9,24(sp)
    80003e82:	1880                	addi	s0,sp,112
    80003e84:	84aa                	mv	s1,a0
    80003e86:	8aae                	mv	s5,a1
    80003e88:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	fbe080e7          	jalr	-66(ra) # 80000e48 <myproc>
    80003e92:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e94:	8526                	mv	a0,s1
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	320080e7          	jalr	800(ra) # 800061b6 <acquire>
  while(i < n){
    80003e9e:	0d405163          	blez	s4,80003f60 <pipewrite+0xf6>
    80003ea2:	8ba6                	mv	s7,s1
  int i = 0;
    80003ea4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ea6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ea8:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003eac:	21c48c13          	addi	s8,s1,540
    80003eb0:	a08d                	j	80003f12 <pipewrite+0xa8>
      release(&pi->lock);
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	00002097          	auipc	ra,0x2
    80003eb8:	3b6080e7          	jalr	950(ra) # 8000626a <release>
      return -1;
    80003ebc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	70a6                	ld	ra,104(sp)
    80003ec2:	7406                	ld	s0,96(sp)
    80003ec4:	64e6                	ld	s1,88(sp)
    80003ec6:	6946                	ld	s2,80(sp)
    80003ec8:	69a6                	ld	s3,72(sp)
    80003eca:	6a06                	ld	s4,64(sp)
    80003ecc:	7ae2                	ld	s5,56(sp)
    80003ece:	7b42                	ld	s6,48(sp)
    80003ed0:	7ba2                	ld	s7,40(sp)
    80003ed2:	7c02                	ld	s8,32(sp)
    80003ed4:	6ce2                	ld	s9,24(sp)
    80003ed6:	6165                	addi	sp,sp,112
    80003ed8:	8082                	ret
      wakeup(&pi->nread);
    80003eda:	8566                	mv	a0,s9
    80003edc:	ffffd097          	auipc	ra,0xffffd
    80003ee0:	7c4080e7          	jalr	1988(ra) # 800016a0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ee4:	85de                	mv	a1,s7
    80003ee6:	8562                	mv	a0,s8
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	62c080e7          	jalr	1580(ra) # 80001514 <sleep>
    80003ef0:	a839                	j	80003f0e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ef2:	21c4a783          	lw	a5,540(s1)
    80003ef6:	0017871b          	addiw	a4,a5,1
    80003efa:	20e4ae23          	sw	a4,540(s1)
    80003efe:	1ff7f793          	andi	a5,a5,511
    80003f02:	97a6                	add	a5,a5,s1
    80003f04:	f9f44703          	lbu	a4,-97(s0)
    80003f08:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f0c:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f0e:	03495d63          	bge	s2,s4,80003f48 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f12:	2204a783          	lw	a5,544(s1)
    80003f16:	dfd1                	beqz	a5,80003eb2 <pipewrite+0x48>
    80003f18:	0289a783          	lw	a5,40(s3)
    80003f1c:	fbd9                	bnez	a5,80003eb2 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f1e:	2184a783          	lw	a5,536(s1)
    80003f22:	21c4a703          	lw	a4,540(s1)
    80003f26:	2007879b          	addiw	a5,a5,512
    80003f2a:	faf708e3          	beq	a4,a5,80003eda <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f2e:	4685                	li	a3,1
    80003f30:	01590633          	add	a2,s2,s5
    80003f34:	f9f40593          	addi	a1,s0,-97
    80003f38:	0509b503          	ld	a0,80(s3)
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	c5a080e7          	jalr	-934(ra) # 80000b96 <copyin>
    80003f44:	fb6517e3          	bne	a0,s6,80003ef2 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f48:	21848513          	addi	a0,s1,536
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	754080e7          	jalr	1876(ra) # 800016a0 <wakeup>
  release(&pi->lock);
    80003f54:	8526                	mv	a0,s1
    80003f56:	00002097          	auipc	ra,0x2
    80003f5a:	314080e7          	jalr	788(ra) # 8000626a <release>
  return i;
    80003f5e:	b785                	j	80003ebe <pipewrite+0x54>
  int i = 0;
    80003f60:	4901                	li	s2,0
    80003f62:	b7dd                	j	80003f48 <pipewrite+0xde>

0000000080003f64 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f64:	715d                	addi	sp,sp,-80
    80003f66:	e486                	sd	ra,72(sp)
    80003f68:	e0a2                	sd	s0,64(sp)
    80003f6a:	fc26                	sd	s1,56(sp)
    80003f6c:	f84a                	sd	s2,48(sp)
    80003f6e:	f44e                	sd	s3,40(sp)
    80003f70:	f052                	sd	s4,32(sp)
    80003f72:	ec56                	sd	s5,24(sp)
    80003f74:	e85a                	sd	s6,16(sp)
    80003f76:	0880                	addi	s0,sp,80
    80003f78:	84aa                	mv	s1,a0
    80003f7a:	892e                	mv	s2,a1
    80003f7c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	eca080e7          	jalr	-310(ra) # 80000e48 <myproc>
    80003f86:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f88:	8b26                	mv	s6,s1
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	00002097          	auipc	ra,0x2
    80003f90:	22a080e7          	jalr	554(ra) # 800061b6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f94:	2184a703          	lw	a4,536(s1)
    80003f98:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f9c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa0:	02f71463          	bne	a4,a5,80003fc8 <piperead+0x64>
    80003fa4:	2244a783          	lw	a5,548(s1)
    80003fa8:	c385                	beqz	a5,80003fc8 <piperead+0x64>
    if(pr->killed){
    80003faa:	028a2783          	lw	a5,40(s4)
    80003fae:	ebc1                	bnez	a5,8000403e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fb0:	85da                	mv	a1,s6
    80003fb2:	854e                	mv	a0,s3
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	560080e7          	jalr	1376(ra) # 80001514 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fbc:	2184a703          	lw	a4,536(s1)
    80003fc0:	21c4a783          	lw	a5,540(s1)
    80003fc4:	fef700e3          	beq	a4,a5,80003fa4 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fc8:	09505263          	blez	s5,8000404c <piperead+0xe8>
    80003fcc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fce:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fd0:	2184a783          	lw	a5,536(s1)
    80003fd4:	21c4a703          	lw	a4,540(s1)
    80003fd8:	02f70d63          	beq	a4,a5,80004012 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fdc:	0017871b          	addiw	a4,a5,1
    80003fe0:	20e4ac23          	sw	a4,536(s1)
    80003fe4:	1ff7f793          	andi	a5,a5,511
    80003fe8:	97a6                	add	a5,a5,s1
    80003fea:	0187c783          	lbu	a5,24(a5)
    80003fee:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ff2:	4685                	li	a3,1
    80003ff4:	fbf40613          	addi	a2,s0,-65
    80003ff8:	85ca                	mv	a1,s2
    80003ffa:	050a3503          	ld	a0,80(s4)
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	b0c080e7          	jalr	-1268(ra) # 80000b0a <copyout>
    80004006:	01650663          	beq	a0,s6,80004012 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000400a:	2985                	addiw	s3,s3,1
    8000400c:	0905                	addi	s2,s2,1
    8000400e:	fd3a91e3          	bne	s5,s3,80003fd0 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004012:	21c48513          	addi	a0,s1,540
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	68a080e7          	jalr	1674(ra) # 800016a0 <wakeup>
  release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	24a080e7          	jalr	586(ra) # 8000626a <release>
  return i;
}
    80004028:	854e                	mv	a0,s3
    8000402a:	60a6                	ld	ra,72(sp)
    8000402c:	6406                	ld	s0,64(sp)
    8000402e:	74e2                	ld	s1,56(sp)
    80004030:	7942                	ld	s2,48(sp)
    80004032:	79a2                	ld	s3,40(sp)
    80004034:	7a02                	ld	s4,32(sp)
    80004036:	6ae2                	ld	s5,24(sp)
    80004038:	6b42                	ld	s6,16(sp)
    8000403a:	6161                	addi	sp,sp,80
    8000403c:	8082                	ret
      release(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	22a080e7          	jalr	554(ra) # 8000626a <release>
      return -1;
    80004048:	59fd                	li	s3,-1
    8000404a:	bff9                	j	80004028 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404c:	4981                	li	s3,0
    8000404e:	b7d1                	j	80004012 <piperead+0xae>

0000000080004050 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004050:	df010113          	addi	sp,sp,-528
    80004054:	20113423          	sd	ra,520(sp)
    80004058:	20813023          	sd	s0,512(sp)
    8000405c:	ffa6                	sd	s1,504(sp)
    8000405e:	fbca                	sd	s2,496(sp)
    80004060:	f7ce                	sd	s3,488(sp)
    80004062:	f3d2                	sd	s4,480(sp)
    80004064:	efd6                	sd	s5,472(sp)
    80004066:	ebda                	sd	s6,464(sp)
    80004068:	e7de                	sd	s7,456(sp)
    8000406a:	e3e2                	sd	s8,448(sp)
    8000406c:	ff66                	sd	s9,440(sp)
    8000406e:	fb6a                	sd	s10,432(sp)
    80004070:	f76e                	sd	s11,424(sp)
    80004072:	0c00                	addi	s0,sp,528
    80004074:	84aa                	mv	s1,a0
    80004076:	dea43c23          	sd	a0,-520(s0)
    8000407a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	dca080e7          	jalr	-566(ra) # 80000e48 <myproc>
    80004086:	892a                	mv	s2,a0

  begin_op();
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	49c080e7          	jalr	1180(ra) # 80003524 <begin_op>

  if((ip = namei(path)) == 0){
    80004090:	8526                	mv	a0,s1
    80004092:	fffff097          	auipc	ra,0xfffff
    80004096:	276080e7          	jalr	630(ra) # 80003308 <namei>
    8000409a:	c92d                	beqz	a0,8000410c <exec+0xbc>
    8000409c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	ab4080e7          	jalr	-1356(ra) # 80002b52 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040a6:	04000713          	li	a4,64
    800040aa:	4681                	li	a3,0
    800040ac:	e5040613          	addi	a2,s0,-432
    800040b0:	4581                	li	a1,0
    800040b2:	8526                	mv	a0,s1
    800040b4:	fffff097          	auipc	ra,0xfffff
    800040b8:	d52080e7          	jalr	-686(ra) # 80002e06 <readi>
    800040bc:	04000793          	li	a5,64
    800040c0:	00f51a63          	bne	a0,a5,800040d4 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040c4:	e5042703          	lw	a4,-432(s0)
    800040c8:	464c47b7          	lui	a5,0x464c4
    800040cc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040d0:	04f70463          	beq	a4,a5,80004118 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040d4:	8526                	mv	a0,s1
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	cde080e7          	jalr	-802(ra) # 80002db4 <iunlockput>
    end_op();
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	4c6080e7          	jalr	1222(ra) # 800035a4 <end_op>
  }
  return -1;
    800040e6:	557d                	li	a0,-1
}
    800040e8:	20813083          	ld	ra,520(sp)
    800040ec:	20013403          	ld	s0,512(sp)
    800040f0:	74fe                	ld	s1,504(sp)
    800040f2:	795e                	ld	s2,496(sp)
    800040f4:	79be                	ld	s3,488(sp)
    800040f6:	7a1e                	ld	s4,480(sp)
    800040f8:	6afe                	ld	s5,472(sp)
    800040fa:	6b5e                	ld	s6,464(sp)
    800040fc:	6bbe                	ld	s7,456(sp)
    800040fe:	6c1e                	ld	s8,448(sp)
    80004100:	7cfa                	ld	s9,440(sp)
    80004102:	7d5a                	ld	s10,432(sp)
    80004104:	7dba                	ld	s11,424(sp)
    80004106:	21010113          	addi	sp,sp,528
    8000410a:	8082                	ret
    end_op();
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	498080e7          	jalr	1176(ra) # 800035a4 <end_op>
    return -1;
    80004114:	557d                	li	a0,-1
    80004116:	bfc9                	j	800040e8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004118:	854a                	mv	a0,s2
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	df2080e7          	jalr	-526(ra) # 80000f0c <proc_pagetable>
    80004122:	8baa                	mv	s7,a0
    80004124:	d945                	beqz	a0,800040d4 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004126:	e7042983          	lw	s3,-400(s0)
    8000412a:	e8845783          	lhu	a5,-376(s0)
    8000412e:	c7ad                	beqz	a5,80004198 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004130:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004132:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004134:	6c85                	lui	s9,0x1
    80004136:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000413a:	def43823          	sd	a5,-528(s0)
    8000413e:	a42d                	j	80004368 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004140:	00004517          	auipc	a0,0x4
    80004144:	51850513          	addi	a0,a0,1304 # 80008658 <syscalls+0x290>
    80004148:	00002097          	auipc	ra,0x2
    8000414c:	ac0080e7          	jalr	-1344(ra) # 80005c08 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004150:	8756                	mv	a4,s5
    80004152:	012d86bb          	addw	a3,s11,s2
    80004156:	4581                	li	a1,0
    80004158:	8526                	mv	a0,s1
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	cac080e7          	jalr	-852(ra) # 80002e06 <readi>
    80004162:	2501                	sext.w	a0,a0
    80004164:	1aaa9963          	bne	s5,a0,80004316 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004168:	6785                	lui	a5,0x1
    8000416a:	0127893b          	addw	s2,a5,s2
    8000416e:	77fd                	lui	a5,0xfffff
    80004170:	01478a3b          	addw	s4,a5,s4
    80004174:	1f897163          	bgeu	s2,s8,80004356 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004178:	02091593          	slli	a1,s2,0x20
    8000417c:	9181                	srli	a1,a1,0x20
    8000417e:	95ea                	add	a1,a1,s10
    80004180:	855e                	mv	a0,s7
    80004182:	ffffc097          	auipc	ra,0xffffc
    80004186:	384080e7          	jalr	900(ra) # 80000506 <walkaddr>
    8000418a:	862a                	mv	a2,a0
    if(pa == 0)
    8000418c:	d955                	beqz	a0,80004140 <exec+0xf0>
      n = PGSIZE;
    8000418e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004190:	fd9a70e3          	bgeu	s4,s9,80004150 <exec+0x100>
      n = sz - i;
    80004194:	8ad2                	mv	s5,s4
    80004196:	bf6d                	j	80004150 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004198:	4901                	li	s2,0
  iunlockput(ip);
    8000419a:	8526                	mv	a0,s1
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	c18080e7          	jalr	-1000(ra) # 80002db4 <iunlockput>
  end_op();
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	400080e7          	jalr	1024(ra) # 800035a4 <end_op>
  p = myproc();
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	c9c080e7          	jalr	-868(ra) # 80000e48 <myproc>
    800041b4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041b6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041ba:	6785                	lui	a5,0x1
    800041bc:	17fd                	addi	a5,a5,-1
    800041be:	993e                	add	s2,s2,a5
    800041c0:	757d                	lui	a0,0xfffff
    800041c2:	00a977b3          	and	a5,s2,a0
    800041c6:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041ca:	6609                	lui	a2,0x2
    800041cc:	963e                	add	a2,a2,a5
    800041ce:	85be                	mv	a1,a5
    800041d0:	855e                	mv	a0,s7
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	6e8080e7          	jalr	1768(ra) # 800008ba <uvmalloc>
    800041da:	8b2a                	mv	s6,a0
  ip = 0;
    800041dc:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041de:	12050c63          	beqz	a0,80004316 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041e2:	75f9                	lui	a1,0xffffe
    800041e4:	95aa                	add	a1,a1,a0
    800041e6:	855e                	mv	a0,s7
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	8f0080e7          	jalr	-1808(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800041f0:	7c7d                	lui	s8,0xfffff
    800041f2:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800041f4:	e0043783          	ld	a5,-512(s0)
    800041f8:	6388                	ld	a0,0(a5)
    800041fa:	c535                	beqz	a0,80004266 <exec+0x216>
    800041fc:	e9040993          	addi	s3,s0,-368
    80004200:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004204:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004206:	ffffc097          	auipc	ra,0xffffc
    8000420a:	0f6080e7          	jalr	246(ra) # 800002fc <strlen>
    8000420e:	2505                	addiw	a0,a0,1
    80004210:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004214:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004218:	13896363          	bltu	s2,s8,8000433e <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000421c:	e0043d83          	ld	s11,-512(s0)
    80004220:	000dba03          	ld	s4,0(s11)
    80004224:	8552                	mv	a0,s4
    80004226:	ffffc097          	auipc	ra,0xffffc
    8000422a:	0d6080e7          	jalr	214(ra) # 800002fc <strlen>
    8000422e:	0015069b          	addiw	a3,a0,1
    80004232:	8652                	mv	a2,s4
    80004234:	85ca                	mv	a1,s2
    80004236:	855e                	mv	a0,s7
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	8d2080e7          	jalr	-1838(ra) # 80000b0a <copyout>
    80004240:	10054363          	bltz	a0,80004346 <exec+0x2f6>
    ustack[argc] = sp;
    80004244:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004248:	0485                	addi	s1,s1,1
    8000424a:	008d8793          	addi	a5,s11,8
    8000424e:	e0f43023          	sd	a5,-512(s0)
    80004252:	008db503          	ld	a0,8(s11)
    80004256:	c911                	beqz	a0,8000426a <exec+0x21a>
    if(argc >= MAXARG)
    80004258:	09a1                	addi	s3,s3,8
    8000425a:	fb3c96e3          	bne	s9,s3,80004206 <exec+0x1b6>
  sz = sz1;
    8000425e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004262:	4481                	li	s1,0
    80004264:	a84d                	j	80004316 <exec+0x2c6>
  sp = sz;
    80004266:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004268:	4481                	li	s1,0
  ustack[argc] = 0;
    8000426a:	00349793          	slli	a5,s1,0x3
    8000426e:	f9040713          	addi	a4,s0,-112
    80004272:	97ba                	add	a5,a5,a4
    80004274:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004278:	00148693          	addi	a3,s1,1
    8000427c:	068e                	slli	a3,a3,0x3
    8000427e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004282:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004286:	01897663          	bgeu	s2,s8,80004292 <exec+0x242>
  sz = sz1;
    8000428a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000428e:	4481                	li	s1,0
    80004290:	a059                	j	80004316 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004292:	e9040613          	addi	a2,s0,-368
    80004296:	85ca                	mv	a1,s2
    80004298:	855e                	mv	a0,s7
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	870080e7          	jalr	-1936(ra) # 80000b0a <copyout>
    800042a2:	0a054663          	bltz	a0,8000434e <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042a6:	058ab783          	ld	a5,88(s5)
    800042aa:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042ae:	df843783          	ld	a5,-520(s0)
    800042b2:	0007c703          	lbu	a4,0(a5)
    800042b6:	cf11                	beqz	a4,800042d2 <exec+0x282>
    800042b8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042ba:	02f00693          	li	a3,47
    800042be:	a039                	j	800042cc <exec+0x27c>
      last = s+1;
    800042c0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042c4:	0785                	addi	a5,a5,1
    800042c6:	fff7c703          	lbu	a4,-1(a5)
    800042ca:	c701                	beqz	a4,800042d2 <exec+0x282>
    if(*s == '/')
    800042cc:	fed71ce3          	bne	a4,a3,800042c4 <exec+0x274>
    800042d0:	bfc5                	j	800042c0 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800042d2:	4641                	li	a2,16
    800042d4:	df843583          	ld	a1,-520(s0)
    800042d8:	158a8513          	addi	a0,s5,344
    800042dc:	ffffc097          	auipc	ra,0xffffc
    800042e0:	fee080e7          	jalr	-18(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800042e4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042e8:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042ec:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f0:	058ab783          	ld	a5,88(s5)
    800042f4:	e6843703          	ld	a4,-408(s0)
    800042f8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042fa:	058ab783          	ld	a5,88(s5)
    800042fe:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004302:	85ea                	mv	a1,s10
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	ca4080e7          	jalr	-860(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000430c:	0004851b          	sext.w	a0,s1
    80004310:	bbe1                	j	800040e8 <exec+0x98>
    80004312:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004316:	e0843583          	ld	a1,-504(s0)
    8000431a:	855e                	mv	a0,s7
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	c8c080e7          	jalr	-884(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004324:	da0498e3          	bnez	s1,800040d4 <exec+0x84>
  return -1;
    80004328:	557d                	li	a0,-1
    8000432a:	bb7d                	j	800040e8 <exec+0x98>
    8000432c:	e1243423          	sd	s2,-504(s0)
    80004330:	b7dd                	j	80004316 <exec+0x2c6>
    80004332:	e1243423          	sd	s2,-504(s0)
    80004336:	b7c5                	j	80004316 <exec+0x2c6>
    80004338:	e1243423          	sd	s2,-504(s0)
    8000433c:	bfe9                	j	80004316 <exec+0x2c6>
  sz = sz1;
    8000433e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004342:	4481                	li	s1,0
    80004344:	bfc9                	j	80004316 <exec+0x2c6>
  sz = sz1;
    80004346:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000434a:	4481                	li	s1,0
    8000434c:	b7e9                	j	80004316 <exec+0x2c6>
  sz = sz1;
    8000434e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004352:	4481                	li	s1,0
    80004354:	b7c9                	j	80004316 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004356:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000435a:	2b05                	addiw	s6,s6,1
    8000435c:	0389899b          	addiw	s3,s3,56
    80004360:	e8845783          	lhu	a5,-376(s0)
    80004364:	e2fb5be3          	bge	s6,a5,8000419a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004368:	2981                	sext.w	s3,s3
    8000436a:	03800713          	li	a4,56
    8000436e:	86ce                	mv	a3,s3
    80004370:	e1840613          	addi	a2,s0,-488
    80004374:	4581                	li	a1,0
    80004376:	8526                	mv	a0,s1
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	a8e080e7          	jalr	-1394(ra) # 80002e06 <readi>
    80004380:	03800793          	li	a5,56
    80004384:	f8f517e3          	bne	a0,a5,80004312 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004388:	e1842783          	lw	a5,-488(s0)
    8000438c:	4705                	li	a4,1
    8000438e:	fce796e3          	bne	a5,a4,8000435a <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004392:	e4043603          	ld	a2,-448(s0)
    80004396:	e3843783          	ld	a5,-456(s0)
    8000439a:	f8f669e3          	bltu	a2,a5,8000432c <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000439e:	e2843783          	ld	a5,-472(s0)
    800043a2:	963e                	add	a2,a2,a5
    800043a4:	f8f667e3          	bltu	a2,a5,80004332 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a8:	85ca                	mv	a1,s2
    800043aa:	855e                	mv	a0,s7
    800043ac:	ffffc097          	auipc	ra,0xffffc
    800043b0:	50e080e7          	jalr	1294(ra) # 800008ba <uvmalloc>
    800043b4:	e0a43423          	sd	a0,-504(s0)
    800043b8:	d141                	beqz	a0,80004338 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800043ba:	e2843d03          	ld	s10,-472(s0)
    800043be:	df043783          	ld	a5,-528(s0)
    800043c2:	00fd77b3          	and	a5,s10,a5
    800043c6:	fba1                	bnez	a5,80004316 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043c8:	e2042d83          	lw	s11,-480(s0)
    800043cc:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043d0:	f80c03e3          	beqz	s8,80004356 <exec+0x306>
    800043d4:	8a62                	mv	s4,s8
    800043d6:	4901                	li	s2,0
    800043d8:	b345                	j	80004178 <exec+0x128>

00000000800043da <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043da:	7179                	addi	sp,sp,-48
    800043dc:	f406                	sd	ra,40(sp)
    800043de:	f022                	sd	s0,32(sp)
    800043e0:	ec26                	sd	s1,24(sp)
    800043e2:	e84a                	sd	s2,16(sp)
    800043e4:	1800                	addi	s0,sp,48
    800043e6:	892e                	mv	s2,a1
    800043e8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043ea:	fdc40593          	addi	a1,s0,-36
    800043ee:	ffffe097          	auipc	ra,0xffffe
    800043f2:	b9e080e7          	jalr	-1122(ra) # 80001f8c <argint>
    800043f6:	04054063          	bltz	a0,80004436 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043fa:	fdc42703          	lw	a4,-36(s0)
    800043fe:	47bd                	li	a5,15
    80004400:	02e7ed63          	bltu	a5,a4,8000443a <argfd+0x60>
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	a44080e7          	jalr	-1468(ra) # 80000e48 <myproc>
    8000440c:	fdc42703          	lw	a4,-36(s0)
    80004410:	01a70793          	addi	a5,a4,26
    80004414:	078e                	slli	a5,a5,0x3
    80004416:	953e                	add	a0,a0,a5
    80004418:	611c                	ld	a5,0(a0)
    8000441a:	c395                	beqz	a5,8000443e <argfd+0x64>
    return -1;
  if(pfd)
    8000441c:	00090463          	beqz	s2,80004424 <argfd+0x4a>
    *pfd = fd;
    80004420:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004424:	4501                	li	a0,0
  if(pf)
    80004426:	c091                	beqz	s1,8000442a <argfd+0x50>
    *pf = f;
    80004428:	e09c                	sd	a5,0(s1)
}
    8000442a:	70a2                	ld	ra,40(sp)
    8000442c:	7402                	ld	s0,32(sp)
    8000442e:	64e2                	ld	s1,24(sp)
    80004430:	6942                	ld	s2,16(sp)
    80004432:	6145                	addi	sp,sp,48
    80004434:	8082                	ret
    return -1;
    80004436:	557d                	li	a0,-1
    80004438:	bfcd                	j	8000442a <argfd+0x50>
    return -1;
    8000443a:	557d                	li	a0,-1
    8000443c:	b7fd                	j	8000442a <argfd+0x50>
    8000443e:	557d                	li	a0,-1
    80004440:	b7ed                	j	8000442a <argfd+0x50>

0000000080004442 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004442:	1101                	addi	sp,sp,-32
    80004444:	ec06                	sd	ra,24(sp)
    80004446:	e822                	sd	s0,16(sp)
    80004448:	e426                	sd	s1,8(sp)
    8000444a:	1000                	addi	s0,sp,32
    8000444c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	9fa080e7          	jalr	-1542(ra) # 80000e48 <myproc>
    80004456:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004458:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    8000445c:	4501                	li	a0,0
    8000445e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004460:	6398                	ld	a4,0(a5)
    80004462:	cb19                	beqz	a4,80004478 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004464:	2505                	addiw	a0,a0,1
    80004466:	07a1                	addi	a5,a5,8
    80004468:	fed51ce3          	bne	a0,a3,80004460 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000446c:	557d                	li	a0,-1
}
    8000446e:	60e2                	ld	ra,24(sp)
    80004470:	6442                	ld	s0,16(sp)
    80004472:	64a2                	ld	s1,8(sp)
    80004474:	6105                	addi	sp,sp,32
    80004476:	8082                	ret
      p->ofile[fd] = f;
    80004478:	01a50793          	addi	a5,a0,26
    8000447c:	078e                	slli	a5,a5,0x3
    8000447e:	963e                	add	a2,a2,a5
    80004480:	e204                	sd	s1,0(a2)
      return fd;
    80004482:	b7f5                	j	8000446e <fdalloc+0x2c>

0000000080004484 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004484:	715d                	addi	sp,sp,-80
    80004486:	e486                	sd	ra,72(sp)
    80004488:	e0a2                	sd	s0,64(sp)
    8000448a:	fc26                	sd	s1,56(sp)
    8000448c:	f84a                	sd	s2,48(sp)
    8000448e:	f44e                	sd	s3,40(sp)
    80004490:	f052                	sd	s4,32(sp)
    80004492:	ec56                	sd	s5,24(sp)
    80004494:	0880                	addi	s0,sp,80
    80004496:	89ae                	mv	s3,a1
    80004498:	8ab2                	mv	s5,a2
    8000449a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000449c:	fb040593          	addi	a1,s0,-80
    800044a0:	fffff097          	auipc	ra,0xfffff
    800044a4:	e86080e7          	jalr	-378(ra) # 80003326 <nameiparent>
    800044a8:	892a                	mv	s2,a0
    800044aa:	12050f63          	beqz	a0,800045e8 <create+0x164>
    return 0;

  ilock(dp);
    800044ae:	ffffe097          	auipc	ra,0xffffe
    800044b2:	6a4080e7          	jalr	1700(ra) # 80002b52 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044b6:	4601                	li	a2,0
    800044b8:	fb040593          	addi	a1,s0,-80
    800044bc:	854a                	mv	a0,s2
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	b78080e7          	jalr	-1160(ra) # 80003036 <dirlookup>
    800044c6:	84aa                	mv	s1,a0
    800044c8:	c921                	beqz	a0,80004518 <create+0x94>
    iunlockput(dp);
    800044ca:	854a                	mv	a0,s2
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	8e8080e7          	jalr	-1816(ra) # 80002db4 <iunlockput>
    ilock(ip);
    800044d4:	8526                	mv	a0,s1
    800044d6:	ffffe097          	auipc	ra,0xffffe
    800044da:	67c080e7          	jalr	1660(ra) # 80002b52 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044de:	2981                	sext.w	s3,s3
    800044e0:	4789                	li	a5,2
    800044e2:	02f99463          	bne	s3,a5,8000450a <create+0x86>
    800044e6:	0444d783          	lhu	a5,68(s1)
    800044ea:	37f9                	addiw	a5,a5,-2
    800044ec:	17c2                	slli	a5,a5,0x30
    800044ee:	93c1                	srli	a5,a5,0x30
    800044f0:	4705                	li	a4,1
    800044f2:	00f76c63          	bltu	a4,a5,8000450a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044f6:	8526                	mv	a0,s1
    800044f8:	60a6                	ld	ra,72(sp)
    800044fa:	6406                	ld	s0,64(sp)
    800044fc:	74e2                	ld	s1,56(sp)
    800044fe:	7942                	ld	s2,48(sp)
    80004500:	79a2                	ld	s3,40(sp)
    80004502:	7a02                	ld	s4,32(sp)
    80004504:	6ae2                	ld	s5,24(sp)
    80004506:	6161                	addi	sp,sp,80
    80004508:	8082                	ret
    iunlockput(ip);
    8000450a:	8526                	mv	a0,s1
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	8a8080e7          	jalr	-1880(ra) # 80002db4 <iunlockput>
    return 0;
    80004514:	4481                	li	s1,0
    80004516:	b7c5                	j	800044f6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004518:	85ce                	mv	a1,s3
    8000451a:	00092503          	lw	a0,0(s2)
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	49c080e7          	jalr	1180(ra) # 800029ba <ialloc>
    80004526:	84aa                	mv	s1,a0
    80004528:	c529                	beqz	a0,80004572 <create+0xee>
  ilock(ip);
    8000452a:	ffffe097          	auipc	ra,0xffffe
    8000452e:	628080e7          	jalr	1576(ra) # 80002b52 <ilock>
  ip->major = major;
    80004532:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004536:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000453a:	4785                	li	a5,1
    8000453c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004540:	8526                	mv	a0,s1
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	546080e7          	jalr	1350(ra) # 80002a88 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000454a:	2981                	sext.w	s3,s3
    8000454c:	4785                	li	a5,1
    8000454e:	02f98a63          	beq	s3,a5,80004582 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004552:	40d0                	lw	a2,4(s1)
    80004554:	fb040593          	addi	a1,s0,-80
    80004558:	854a                	mv	a0,s2
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	cec080e7          	jalr	-788(ra) # 80003246 <dirlink>
    80004562:	06054b63          	bltz	a0,800045d8 <create+0x154>
  iunlockput(dp);
    80004566:	854a                	mv	a0,s2
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	84c080e7          	jalr	-1972(ra) # 80002db4 <iunlockput>
  return ip;
    80004570:	b759                	j	800044f6 <create+0x72>
    panic("create: ialloc");
    80004572:	00004517          	auipc	a0,0x4
    80004576:	10650513          	addi	a0,a0,262 # 80008678 <syscalls+0x2b0>
    8000457a:	00001097          	auipc	ra,0x1
    8000457e:	68e080e7          	jalr	1678(ra) # 80005c08 <panic>
    dp->nlink++;  // for ".."
    80004582:	04a95783          	lhu	a5,74(s2)
    80004586:	2785                	addiw	a5,a5,1
    80004588:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000458c:	854a                	mv	a0,s2
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	4fa080e7          	jalr	1274(ra) # 80002a88 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004596:	40d0                	lw	a2,4(s1)
    80004598:	00004597          	auipc	a1,0x4
    8000459c:	0f058593          	addi	a1,a1,240 # 80008688 <syscalls+0x2c0>
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	ca4080e7          	jalr	-860(ra) # 80003246 <dirlink>
    800045aa:	00054f63          	bltz	a0,800045c8 <create+0x144>
    800045ae:	00492603          	lw	a2,4(s2)
    800045b2:	00004597          	auipc	a1,0x4
    800045b6:	0de58593          	addi	a1,a1,222 # 80008690 <syscalls+0x2c8>
    800045ba:	8526                	mv	a0,s1
    800045bc:	fffff097          	auipc	ra,0xfffff
    800045c0:	c8a080e7          	jalr	-886(ra) # 80003246 <dirlink>
    800045c4:	f80557e3          	bgez	a0,80004552 <create+0xce>
      panic("create dots");
    800045c8:	00004517          	auipc	a0,0x4
    800045cc:	0d050513          	addi	a0,a0,208 # 80008698 <syscalls+0x2d0>
    800045d0:	00001097          	auipc	ra,0x1
    800045d4:	638080e7          	jalr	1592(ra) # 80005c08 <panic>
    panic("create: dirlink");
    800045d8:	00004517          	auipc	a0,0x4
    800045dc:	0d050513          	addi	a0,a0,208 # 800086a8 <syscalls+0x2e0>
    800045e0:	00001097          	auipc	ra,0x1
    800045e4:	628080e7          	jalr	1576(ra) # 80005c08 <panic>
    return 0;
    800045e8:	84aa                	mv	s1,a0
    800045ea:	b731                	j	800044f6 <create+0x72>

00000000800045ec <sys_dup>:
{
    800045ec:	7179                	addi	sp,sp,-48
    800045ee:	f406                	sd	ra,40(sp)
    800045f0:	f022                	sd	s0,32(sp)
    800045f2:	ec26                	sd	s1,24(sp)
    800045f4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045f6:	fd840613          	addi	a2,s0,-40
    800045fa:	4581                	li	a1,0
    800045fc:	4501                	li	a0,0
    800045fe:	00000097          	auipc	ra,0x0
    80004602:	ddc080e7          	jalr	-548(ra) # 800043da <argfd>
    return -1;
    80004606:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004608:	02054363          	bltz	a0,8000462e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000460c:	fd843503          	ld	a0,-40(s0)
    80004610:	00000097          	auipc	ra,0x0
    80004614:	e32080e7          	jalr	-462(ra) # 80004442 <fdalloc>
    80004618:	84aa                	mv	s1,a0
    return -1;
    8000461a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000461c:	00054963          	bltz	a0,8000462e <sys_dup+0x42>
  filedup(f);
    80004620:	fd843503          	ld	a0,-40(s0)
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	37a080e7          	jalr	890(ra) # 8000399e <filedup>
  return fd;
    8000462c:	87a6                	mv	a5,s1
}
    8000462e:	853e                	mv	a0,a5
    80004630:	70a2                	ld	ra,40(sp)
    80004632:	7402                	ld	s0,32(sp)
    80004634:	64e2                	ld	s1,24(sp)
    80004636:	6145                	addi	sp,sp,48
    80004638:	8082                	ret

000000008000463a <sys_read>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004642:	fe840613          	addi	a2,s0,-24
    80004646:	4581                	li	a1,0
    80004648:	4501                	li	a0,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	d90080e7          	jalr	-624(ra) # 800043da <argfd>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004654:	04054163          	bltz	a0,80004696 <sys_read+0x5c>
    80004658:	fe440593          	addi	a1,s0,-28
    8000465c:	4509                	li	a0,2
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	92e080e7          	jalr	-1746(ra) # 80001f8c <argint>
    return -1;
    80004666:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004668:	02054763          	bltz	a0,80004696 <sys_read+0x5c>
    8000466c:	fd840593          	addi	a1,s0,-40
    80004670:	4505                	li	a0,1
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	93c080e7          	jalr	-1732(ra) # 80001fae <argaddr>
    return -1;
    8000467a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000467c:	00054d63          	bltz	a0,80004696 <sys_read+0x5c>
  return fileread(f, p, n);
    80004680:	fe442603          	lw	a2,-28(s0)
    80004684:	fd843583          	ld	a1,-40(s0)
    80004688:	fe843503          	ld	a0,-24(s0)
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	49e080e7          	jalr	1182(ra) # 80003b2a <fileread>
    80004694:	87aa                	mv	a5,a0
}
    80004696:	853e                	mv	a0,a5
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	6145                	addi	sp,sp,48
    8000469e:	8082                	ret

00000000800046a0 <sys_write>:
{
    800046a0:	7179                	addi	sp,sp,-48
    800046a2:	f406                	sd	ra,40(sp)
    800046a4:	f022                	sd	s0,32(sp)
    800046a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a8:	fe840613          	addi	a2,s0,-24
    800046ac:	4581                	li	a1,0
    800046ae:	4501                	li	a0,0
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	d2a080e7          	jalr	-726(ra) # 800043da <argfd>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	04054163          	bltz	a0,800046fc <sys_write+0x5c>
    800046be:	fe440593          	addi	a1,s0,-28
    800046c2:	4509                	li	a0,2
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	8c8080e7          	jalr	-1848(ra) # 80001f8c <argint>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	02054763          	bltz	a0,800046fc <sys_write+0x5c>
    800046d2:	fd840593          	addi	a1,s0,-40
    800046d6:	4505                	li	a0,1
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	8d6080e7          	jalr	-1834(ra) # 80001fae <argaddr>
    return -1;
    800046e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	00054d63          	bltz	a0,800046fc <sys_write+0x5c>
  return filewrite(f, p, n);
    800046e6:	fe442603          	lw	a2,-28(s0)
    800046ea:	fd843583          	ld	a1,-40(s0)
    800046ee:	fe843503          	ld	a0,-24(s0)
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	4fa080e7          	jalr	1274(ra) # 80003bec <filewrite>
    800046fa:	87aa                	mv	a5,a0
}
    800046fc:	853e                	mv	a0,a5
    800046fe:	70a2                	ld	ra,40(sp)
    80004700:	7402                	ld	s0,32(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret

0000000080004706 <sys_close>:
{
    80004706:	1101                	addi	sp,sp,-32
    80004708:	ec06                	sd	ra,24(sp)
    8000470a:	e822                	sd	s0,16(sp)
    8000470c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000470e:	fe040613          	addi	a2,s0,-32
    80004712:	fec40593          	addi	a1,s0,-20
    80004716:	4501                	li	a0,0
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	cc2080e7          	jalr	-830(ra) # 800043da <argfd>
    return -1;
    80004720:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004722:	02054463          	bltz	a0,8000474a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	722080e7          	jalr	1826(ra) # 80000e48 <myproc>
    8000472e:	fec42783          	lw	a5,-20(s0)
    80004732:	07e9                	addi	a5,a5,26
    80004734:	078e                	slli	a5,a5,0x3
    80004736:	97aa                	add	a5,a5,a0
    80004738:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000473c:	fe043503          	ld	a0,-32(s0)
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	2b0080e7          	jalr	688(ra) # 800039f0 <fileclose>
  return 0;
    80004748:	4781                	li	a5,0
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	6105                	addi	sp,sp,32
    80004752:	8082                	ret

0000000080004754 <sys_fstat>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475c:	fe840613          	addi	a2,s0,-24
    80004760:	4581                	li	a1,0
    80004762:	4501                	li	a0,0
    80004764:	00000097          	auipc	ra,0x0
    80004768:	c76080e7          	jalr	-906(ra) # 800043da <argfd>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000476e:	02054563          	bltz	a0,80004798 <sys_fstat+0x44>
    80004772:	fe040593          	addi	a1,s0,-32
    80004776:	4505                	li	a0,1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	836080e7          	jalr	-1994(ra) # 80001fae <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004782:	00054b63          	bltz	a0,80004798 <sys_fstat+0x44>
  return filestat(f, st);
    80004786:	fe043583          	ld	a1,-32(s0)
    8000478a:	fe843503          	ld	a0,-24(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	32a080e7          	jalr	810(ra) # 80003ab8 <filestat>
    80004796:	87aa                	mv	a5,a0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_link>:
{
    800047a2:	7169                	addi	sp,sp,-304
    800047a4:	f606                	sd	ra,296(sp)
    800047a6:	f222                	sd	s0,288(sp)
    800047a8:	ee26                	sd	s1,280(sp)
    800047aa:	ea4a                	sd	s2,272(sp)
    800047ac:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ae:	08000613          	li	a2,128
    800047b2:	ed040593          	addi	a1,s0,-304
    800047b6:	4501                	li	a0,0
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	818080e7          	jalr	-2024(ra) # 80001fd0 <argstr>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c2:	10054e63          	bltz	a0,800048de <sys_link+0x13c>
    800047c6:	08000613          	li	a2,128
    800047ca:	f5040593          	addi	a1,s0,-176
    800047ce:	4505                	li	a0,1
    800047d0:	ffffe097          	auipc	ra,0xffffe
    800047d4:	800080e7          	jalr	-2048(ra) # 80001fd0 <argstr>
    return -1;
    800047d8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047da:	10054263          	bltz	a0,800048de <sys_link+0x13c>
  begin_op();
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	d46080e7          	jalr	-698(ra) # 80003524 <begin_op>
  if((ip = namei(old)) == 0){
    800047e6:	ed040513          	addi	a0,s0,-304
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	b1e080e7          	jalr	-1250(ra) # 80003308 <namei>
    800047f2:	84aa                	mv	s1,a0
    800047f4:	c551                	beqz	a0,80004880 <sys_link+0xde>
  ilock(ip);
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	35c080e7          	jalr	860(ra) # 80002b52 <ilock>
  if(ip->type == T_DIR){
    800047fe:	04449703          	lh	a4,68(s1)
    80004802:	4785                	li	a5,1
    80004804:	08f70463          	beq	a4,a5,8000488c <sys_link+0xea>
  ip->nlink++;
    80004808:	04a4d783          	lhu	a5,74(s1)
    8000480c:	2785                	addiw	a5,a5,1
    8000480e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004812:	8526                	mv	a0,s1
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	274080e7          	jalr	628(ra) # 80002a88 <iupdate>
  iunlock(ip);
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	3f6080e7          	jalr	1014(ra) # 80002c14 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004826:	fd040593          	addi	a1,s0,-48
    8000482a:	f5040513          	addi	a0,s0,-176
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	af8080e7          	jalr	-1288(ra) # 80003326 <nameiparent>
    80004836:	892a                	mv	s2,a0
    80004838:	c935                	beqz	a0,800048ac <sys_link+0x10a>
  ilock(dp);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	318080e7          	jalr	792(ra) # 80002b52 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004842:	00092703          	lw	a4,0(s2)
    80004846:	409c                	lw	a5,0(s1)
    80004848:	04f71d63          	bne	a4,a5,800048a2 <sys_link+0x100>
    8000484c:	40d0                	lw	a2,4(s1)
    8000484e:	fd040593          	addi	a1,s0,-48
    80004852:	854a                	mv	a0,s2
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	9f2080e7          	jalr	-1550(ra) # 80003246 <dirlink>
    8000485c:	04054363          	bltz	a0,800048a2 <sys_link+0x100>
  iunlockput(dp);
    80004860:	854a                	mv	a0,s2
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	552080e7          	jalr	1362(ra) # 80002db4 <iunlockput>
  iput(ip);
    8000486a:	8526                	mv	a0,s1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	4a0080e7          	jalr	1184(ra) # 80002d0c <iput>
  end_op();
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	d30080e7          	jalr	-720(ra) # 800035a4 <end_op>
  return 0;
    8000487c:	4781                	li	a5,0
    8000487e:	a085                	j	800048de <sys_link+0x13c>
    end_op();
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	d24080e7          	jalr	-732(ra) # 800035a4 <end_op>
    return -1;
    80004888:	57fd                	li	a5,-1
    8000488a:	a891                	j	800048de <sys_link+0x13c>
    iunlockput(ip);
    8000488c:	8526                	mv	a0,s1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	526080e7          	jalr	1318(ra) # 80002db4 <iunlockput>
    end_op();
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	d0e080e7          	jalr	-754(ra) # 800035a4 <end_op>
    return -1;
    8000489e:	57fd                	li	a5,-1
    800048a0:	a83d                	j	800048de <sys_link+0x13c>
    iunlockput(dp);
    800048a2:	854a                	mv	a0,s2
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	510080e7          	jalr	1296(ra) # 80002db4 <iunlockput>
  ilock(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	2a4080e7          	jalr	676(ra) # 80002b52 <ilock>
  ip->nlink--;
    800048b6:	04a4d783          	lhu	a5,74(s1)
    800048ba:	37fd                	addiw	a5,a5,-1
    800048bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	1c6080e7          	jalr	454(ra) # 80002a88 <iupdate>
  iunlockput(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	4e8080e7          	jalr	1256(ra) # 80002db4 <iunlockput>
  end_op();
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	cd0080e7          	jalr	-816(ra) # 800035a4 <end_op>
  return -1;
    800048dc:	57fd                	li	a5,-1
}
    800048de:	853e                	mv	a0,a5
    800048e0:	70b2                	ld	ra,296(sp)
    800048e2:	7412                	ld	s0,288(sp)
    800048e4:	64f2                	ld	s1,280(sp)
    800048e6:	6952                	ld	s2,272(sp)
    800048e8:	6155                	addi	sp,sp,304
    800048ea:	8082                	ret

00000000800048ec <sys_unlink>:
{
    800048ec:	7151                	addi	sp,sp,-240
    800048ee:	f586                	sd	ra,232(sp)
    800048f0:	f1a2                	sd	s0,224(sp)
    800048f2:	eda6                	sd	s1,216(sp)
    800048f4:	e9ca                	sd	s2,208(sp)
    800048f6:	e5ce                	sd	s3,200(sp)
    800048f8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048fa:	08000613          	li	a2,128
    800048fe:	f3040593          	addi	a1,s0,-208
    80004902:	4501                	li	a0,0
    80004904:	ffffd097          	auipc	ra,0xffffd
    80004908:	6cc080e7          	jalr	1740(ra) # 80001fd0 <argstr>
    8000490c:	18054163          	bltz	a0,80004a8e <sys_unlink+0x1a2>
  begin_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	c14080e7          	jalr	-1004(ra) # 80003524 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004918:	fb040593          	addi	a1,s0,-80
    8000491c:	f3040513          	addi	a0,s0,-208
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	a06080e7          	jalr	-1530(ra) # 80003326 <nameiparent>
    80004928:	84aa                	mv	s1,a0
    8000492a:	c979                	beqz	a0,80004a00 <sys_unlink+0x114>
  ilock(dp);
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	226080e7          	jalr	550(ra) # 80002b52 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004934:	00004597          	auipc	a1,0x4
    80004938:	d5458593          	addi	a1,a1,-684 # 80008688 <syscalls+0x2c0>
    8000493c:	fb040513          	addi	a0,s0,-80
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	6dc080e7          	jalr	1756(ra) # 8000301c <namecmp>
    80004948:	14050a63          	beqz	a0,80004a9c <sys_unlink+0x1b0>
    8000494c:	00004597          	auipc	a1,0x4
    80004950:	d4458593          	addi	a1,a1,-700 # 80008690 <syscalls+0x2c8>
    80004954:	fb040513          	addi	a0,s0,-80
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	6c4080e7          	jalr	1732(ra) # 8000301c <namecmp>
    80004960:	12050e63          	beqz	a0,80004a9c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004964:	f2c40613          	addi	a2,s0,-212
    80004968:	fb040593          	addi	a1,s0,-80
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	6c8080e7          	jalr	1736(ra) # 80003036 <dirlookup>
    80004976:	892a                	mv	s2,a0
    80004978:	12050263          	beqz	a0,80004a9c <sys_unlink+0x1b0>
  ilock(ip);
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	1d6080e7          	jalr	470(ra) # 80002b52 <ilock>
  if(ip->nlink < 1)
    80004984:	04a91783          	lh	a5,74(s2)
    80004988:	08f05263          	blez	a5,80004a0c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000498c:	04491703          	lh	a4,68(s2)
    80004990:	4785                	li	a5,1
    80004992:	08f70563          	beq	a4,a5,80004a1c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004996:	4641                	li	a2,16
    80004998:	4581                	li	a1,0
    8000499a:	fc040513          	addi	a0,s0,-64
    8000499e:	ffffb097          	auipc	ra,0xffffb
    800049a2:	7da080e7          	jalr	2010(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049a6:	4741                	li	a4,16
    800049a8:	f2c42683          	lw	a3,-212(s0)
    800049ac:	fc040613          	addi	a2,s0,-64
    800049b0:	4581                	li	a1,0
    800049b2:	8526                	mv	a0,s1
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	54a080e7          	jalr	1354(ra) # 80002efe <writei>
    800049bc:	47c1                	li	a5,16
    800049be:	0af51563          	bne	a0,a5,80004a68 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049c2:	04491703          	lh	a4,68(s2)
    800049c6:	4785                	li	a5,1
    800049c8:	0af70863          	beq	a4,a5,80004a78 <sys_unlink+0x18c>
  iunlockput(dp);
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	3e6080e7          	jalr	998(ra) # 80002db4 <iunlockput>
  ip->nlink--;
    800049d6:	04a95783          	lhu	a5,74(s2)
    800049da:	37fd                	addiw	a5,a5,-1
    800049dc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049e0:	854a                	mv	a0,s2
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	0a6080e7          	jalr	166(ra) # 80002a88 <iupdate>
  iunlockput(ip);
    800049ea:	854a                	mv	a0,s2
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	3c8080e7          	jalr	968(ra) # 80002db4 <iunlockput>
  end_op();
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	bb0080e7          	jalr	-1104(ra) # 800035a4 <end_op>
  return 0;
    800049fc:	4501                	li	a0,0
    800049fe:	a84d                	j	80004ab0 <sys_unlink+0x1c4>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	ba4080e7          	jalr	-1116(ra) # 800035a4 <end_op>
    return -1;
    80004a08:	557d                	li	a0,-1
    80004a0a:	a05d                	j	80004ab0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a0c:	00004517          	auipc	a0,0x4
    80004a10:	cac50513          	addi	a0,a0,-852 # 800086b8 <syscalls+0x2f0>
    80004a14:	00001097          	auipc	ra,0x1
    80004a18:	1f4080e7          	jalr	500(ra) # 80005c08 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a1c:	04c92703          	lw	a4,76(s2)
    80004a20:	02000793          	li	a5,32
    80004a24:	f6e7f9e3          	bgeu	a5,a4,80004996 <sys_unlink+0xaa>
    80004a28:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2c:	4741                	li	a4,16
    80004a2e:	86ce                	mv	a3,s3
    80004a30:	f1840613          	addi	a2,s0,-232
    80004a34:	4581                	li	a1,0
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	3ce080e7          	jalr	974(ra) # 80002e06 <readi>
    80004a40:	47c1                	li	a5,16
    80004a42:	00f51b63          	bne	a0,a5,80004a58 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a46:	f1845783          	lhu	a5,-232(s0)
    80004a4a:	e7a1                	bnez	a5,80004a92 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a4c:	29c1                	addiw	s3,s3,16
    80004a4e:	04c92783          	lw	a5,76(s2)
    80004a52:	fcf9ede3          	bltu	s3,a5,80004a2c <sys_unlink+0x140>
    80004a56:	b781                	j	80004996 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	c7850513          	addi	a0,a0,-904 # 800086d0 <syscalls+0x308>
    80004a60:	00001097          	auipc	ra,0x1
    80004a64:	1a8080e7          	jalr	424(ra) # 80005c08 <panic>
    panic("unlink: writei");
    80004a68:	00004517          	auipc	a0,0x4
    80004a6c:	c8050513          	addi	a0,a0,-896 # 800086e8 <syscalls+0x320>
    80004a70:	00001097          	auipc	ra,0x1
    80004a74:	198080e7          	jalr	408(ra) # 80005c08 <panic>
    dp->nlink--;
    80004a78:	04a4d783          	lhu	a5,74(s1)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	004080e7          	jalr	4(ra) # 80002a88 <iupdate>
    80004a8c:	b781                	j	800049cc <sys_unlink+0xe0>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	a005                	j	80004ab0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	320080e7          	jalr	800(ra) # 80002db4 <iunlockput>
  iunlockput(dp);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	316080e7          	jalr	790(ra) # 80002db4 <iunlockput>
  end_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	afe080e7          	jalr	-1282(ra) # 800035a4 <end_op>
  return -1;
    80004aae:	557d                	li	a0,-1
}
    80004ab0:	70ae                	ld	ra,232(sp)
    80004ab2:	740e                	ld	s0,224(sp)
    80004ab4:	64ee                	ld	s1,216(sp)
    80004ab6:	694e                	ld	s2,208(sp)
    80004ab8:	69ae                	ld	s3,200(sp)
    80004aba:	616d                	addi	sp,sp,240
    80004abc:	8082                	ret

0000000080004abe <sys_open>:

uint64
sys_open(void)
{
    80004abe:	7131                	addi	sp,sp,-192
    80004ac0:	fd06                	sd	ra,184(sp)
    80004ac2:	f922                	sd	s0,176(sp)
    80004ac4:	f526                	sd	s1,168(sp)
    80004ac6:	f14a                	sd	s2,160(sp)
    80004ac8:	ed4e                	sd	s3,152(sp)
    80004aca:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004acc:	08000613          	li	a2,128
    80004ad0:	f5040593          	addi	a1,s0,-176
    80004ad4:	4501                	li	a0,0
    80004ad6:	ffffd097          	auipc	ra,0xffffd
    80004ada:	4fa080e7          	jalr	1274(ra) # 80001fd0 <argstr>
    return -1;
    80004ade:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ae0:	0c054163          	bltz	a0,80004ba2 <sys_open+0xe4>
    80004ae4:	f4c40593          	addi	a1,s0,-180
    80004ae8:	4505                	li	a0,1
    80004aea:	ffffd097          	auipc	ra,0xffffd
    80004aee:	4a2080e7          	jalr	1186(ra) # 80001f8c <argint>
    80004af2:	0a054863          	bltz	a0,80004ba2 <sys_open+0xe4>

  begin_op();
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	a2e080e7          	jalr	-1490(ra) # 80003524 <begin_op>

  if(omode & O_CREATE){
    80004afe:	f4c42783          	lw	a5,-180(s0)
    80004b02:	2007f793          	andi	a5,a5,512
    80004b06:	cbdd                	beqz	a5,80004bbc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b08:	4681                	li	a3,0
    80004b0a:	4601                	li	a2,0
    80004b0c:	4589                	li	a1,2
    80004b0e:	f5040513          	addi	a0,s0,-176
    80004b12:	00000097          	auipc	ra,0x0
    80004b16:	972080e7          	jalr	-1678(ra) # 80004484 <create>
    80004b1a:	892a                	mv	s2,a0
    if(ip == 0){
    80004b1c:	c959                	beqz	a0,80004bb2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b1e:	04491703          	lh	a4,68(s2)
    80004b22:	478d                	li	a5,3
    80004b24:	00f71763          	bne	a4,a5,80004b32 <sys_open+0x74>
    80004b28:	04695703          	lhu	a4,70(s2)
    80004b2c:	47a5                	li	a5,9
    80004b2e:	0ce7ec63          	bltu	a5,a4,80004c06 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	e02080e7          	jalr	-510(ra) # 80003934 <filealloc>
    80004b3a:	89aa                	mv	s3,a0
    80004b3c:	10050263          	beqz	a0,80004c40 <sys_open+0x182>
    80004b40:	00000097          	auipc	ra,0x0
    80004b44:	902080e7          	jalr	-1790(ra) # 80004442 <fdalloc>
    80004b48:	84aa                	mv	s1,a0
    80004b4a:	0e054663          	bltz	a0,80004c36 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	478d                	li	a5,3
    80004b54:	0cf70463          	beq	a4,a5,80004c1c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b58:	4789                	li	a5,2
    80004b5a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b5e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b62:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b66:	f4c42783          	lw	a5,-180(s0)
    80004b6a:	0017c713          	xori	a4,a5,1
    80004b6e:	8b05                	andi	a4,a4,1
    80004b70:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b74:	0037f713          	andi	a4,a5,3
    80004b78:	00e03733          	snez	a4,a4
    80004b7c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b80:	4007f793          	andi	a5,a5,1024
    80004b84:	c791                	beqz	a5,80004b90 <sys_open+0xd2>
    80004b86:	04491703          	lh	a4,68(s2)
    80004b8a:	4789                	li	a5,2
    80004b8c:	08f70f63          	beq	a4,a5,80004c2a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b90:	854a                	mv	a0,s2
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	082080e7          	jalr	130(ra) # 80002c14 <iunlock>
  end_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	a0a080e7          	jalr	-1526(ra) # 800035a4 <end_op>

  return fd;
}
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	70ea                	ld	ra,184(sp)
    80004ba6:	744a                	ld	s0,176(sp)
    80004ba8:	74aa                	ld	s1,168(sp)
    80004baa:	790a                	ld	s2,160(sp)
    80004bac:	69ea                	ld	s3,152(sp)
    80004bae:	6129                	addi	sp,sp,192
    80004bb0:	8082                	ret
      end_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	9f2080e7          	jalr	-1550(ra) # 800035a4 <end_op>
      return -1;
    80004bba:	b7e5                	j	80004ba2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bbc:	f5040513          	addi	a0,s0,-176
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	748080e7          	jalr	1864(ra) # 80003308 <namei>
    80004bc8:	892a                	mv	s2,a0
    80004bca:	c905                	beqz	a0,80004bfa <sys_open+0x13c>
    ilock(ip);
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	f86080e7          	jalr	-122(ra) # 80002b52 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bd4:	04491703          	lh	a4,68(s2)
    80004bd8:	4785                	li	a5,1
    80004bda:	f4f712e3          	bne	a4,a5,80004b1e <sys_open+0x60>
    80004bde:	f4c42783          	lw	a5,-180(s0)
    80004be2:	dba1                	beqz	a5,80004b32 <sys_open+0x74>
      iunlockput(ip);
    80004be4:	854a                	mv	a0,s2
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	1ce080e7          	jalr	462(ra) # 80002db4 <iunlockput>
      end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	9b6080e7          	jalr	-1610(ra) # 800035a4 <end_op>
      return -1;
    80004bf6:	54fd                	li	s1,-1
    80004bf8:	b76d                	j	80004ba2 <sys_open+0xe4>
      end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	9aa080e7          	jalr	-1622(ra) # 800035a4 <end_op>
      return -1;
    80004c02:	54fd                	li	s1,-1
    80004c04:	bf79                	j	80004ba2 <sys_open+0xe4>
    iunlockput(ip);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	1ac080e7          	jalr	428(ra) # 80002db4 <iunlockput>
    end_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	994080e7          	jalr	-1644(ra) # 800035a4 <end_op>
    return -1;
    80004c18:	54fd                	li	s1,-1
    80004c1a:	b761                	j	80004ba2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c1c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c20:	04691783          	lh	a5,70(s2)
    80004c24:	02f99223          	sh	a5,36(s3)
    80004c28:	bf2d                	j	80004b62 <sys_open+0xa4>
    itrunc(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	034080e7          	jalr	52(ra) # 80002c60 <itrunc>
    80004c34:	bfb1                	j	80004b90 <sys_open+0xd2>
      fileclose(f);
    80004c36:	854e                	mv	a0,s3
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	db8080e7          	jalr	-584(ra) # 800039f0 <fileclose>
    iunlockput(ip);
    80004c40:	854a                	mv	a0,s2
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	172080e7          	jalr	370(ra) # 80002db4 <iunlockput>
    end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	95a080e7          	jalr	-1702(ra) # 800035a4 <end_op>
    return -1;
    80004c52:	54fd                	li	s1,-1
    80004c54:	b7b9                	j	80004ba2 <sys_open+0xe4>

0000000080004c56 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c56:	7175                	addi	sp,sp,-144
    80004c58:	e506                	sd	ra,136(sp)
    80004c5a:	e122                	sd	s0,128(sp)
    80004c5c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	8c6080e7          	jalr	-1850(ra) # 80003524 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c66:	08000613          	li	a2,128
    80004c6a:	f7040593          	addi	a1,s0,-144
    80004c6e:	4501                	li	a0,0
    80004c70:	ffffd097          	auipc	ra,0xffffd
    80004c74:	360080e7          	jalr	864(ra) # 80001fd0 <argstr>
    80004c78:	02054963          	bltz	a0,80004caa <sys_mkdir+0x54>
    80004c7c:	4681                	li	a3,0
    80004c7e:	4601                	li	a2,0
    80004c80:	4585                	li	a1,1
    80004c82:	f7040513          	addi	a0,s0,-144
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	7fe080e7          	jalr	2046(ra) # 80004484 <create>
    80004c8e:	cd11                	beqz	a0,80004caa <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	124080e7          	jalr	292(ra) # 80002db4 <iunlockput>
  end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	90c080e7          	jalr	-1780(ra) # 800035a4 <end_op>
  return 0;
    80004ca0:	4501                	li	a0,0
}
    80004ca2:	60aa                	ld	ra,136(sp)
    80004ca4:	640a                	ld	s0,128(sp)
    80004ca6:	6149                	addi	sp,sp,144
    80004ca8:	8082                	ret
    end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	8fa080e7          	jalr	-1798(ra) # 800035a4 <end_op>
    return -1;
    80004cb2:	557d                	li	a0,-1
    80004cb4:	b7fd                	j	80004ca2 <sys_mkdir+0x4c>

0000000080004cb6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cb6:	7135                	addi	sp,sp,-160
    80004cb8:	ed06                	sd	ra,152(sp)
    80004cba:	e922                	sd	s0,144(sp)
    80004cbc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	866080e7          	jalr	-1946(ra) # 80003524 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc6:	08000613          	li	a2,128
    80004cca:	f7040593          	addi	a1,s0,-144
    80004cce:	4501                	li	a0,0
    80004cd0:	ffffd097          	auipc	ra,0xffffd
    80004cd4:	300080e7          	jalr	768(ra) # 80001fd0 <argstr>
    80004cd8:	04054a63          	bltz	a0,80004d2c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cdc:	f6c40593          	addi	a1,s0,-148
    80004ce0:	4505                	li	a0,1
    80004ce2:	ffffd097          	auipc	ra,0xffffd
    80004ce6:	2aa080e7          	jalr	682(ra) # 80001f8c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cea:	04054163          	bltz	a0,80004d2c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cee:	f6840593          	addi	a1,s0,-152
    80004cf2:	4509                	li	a0,2
    80004cf4:	ffffd097          	auipc	ra,0xffffd
    80004cf8:	298080e7          	jalr	664(ra) # 80001f8c <argint>
     argint(1, &major) < 0 ||
    80004cfc:	02054863          	bltz	a0,80004d2c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d00:	f6841683          	lh	a3,-152(s0)
    80004d04:	f6c41603          	lh	a2,-148(s0)
    80004d08:	458d                	li	a1,3
    80004d0a:	f7040513          	addi	a0,s0,-144
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	776080e7          	jalr	1910(ra) # 80004484 <create>
     argint(2, &minor) < 0 ||
    80004d16:	c919                	beqz	a0,80004d2c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	09c080e7          	jalr	156(ra) # 80002db4 <iunlockput>
  end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	884080e7          	jalr	-1916(ra) # 800035a4 <end_op>
  return 0;
    80004d28:	4501                	li	a0,0
    80004d2a:	a031                	j	80004d36 <sys_mknod+0x80>
    end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	878080e7          	jalr	-1928(ra) # 800035a4 <end_op>
    return -1;
    80004d34:	557d                	li	a0,-1
}
    80004d36:	60ea                	ld	ra,152(sp)
    80004d38:	644a                	ld	s0,144(sp)
    80004d3a:	610d                	addi	sp,sp,160
    80004d3c:	8082                	ret

0000000080004d3e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d3e:	7135                	addi	sp,sp,-160
    80004d40:	ed06                	sd	ra,152(sp)
    80004d42:	e922                	sd	s0,144(sp)
    80004d44:	e526                	sd	s1,136(sp)
    80004d46:	e14a                	sd	s2,128(sp)
    80004d48:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	0fe080e7          	jalr	254(ra) # 80000e48 <myproc>
    80004d52:	892a                	mv	s2,a0
  
  begin_op();
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	7d0080e7          	jalr	2000(ra) # 80003524 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d5c:	08000613          	li	a2,128
    80004d60:	f6040593          	addi	a1,s0,-160
    80004d64:	4501                	li	a0,0
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	26a080e7          	jalr	618(ra) # 80001fd0 <argstr>
    80004d6e:	04054b63          	bltz	a0,80004dc4 <sys_chdir+0x86>
    80004d72:	f6040513          	addi	a0,s0,-160
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	592080e7          	jalr	1426(ra) # 80003308 <namei>
    80004d7e:	84aa                	mv	s1,a0
    80004d80:	c131                	beqz	a0,80004dc4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	dd0080e7          	jalr	-560(ra) # 80002b52 <ilock>
  if(ip->type != T_DIR){
    80004d8a:	04449703          	lh	a4,68(s1)
    80004d8e:	4785                	li	a5,1
    80004d90:	04f71063          	bne	a4,a5,80004dd0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d94:	8526                	mv	a0,s1
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	e7e080e7          	jalr	-386(ra) # 80002c14 <iunlock>
  iput(p->cwd);
    80004d9e:	15093503          	ld	a0,336(s2)
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	f6a080e7          	jalr	-150(ra) # 80002d0c <iput>
  end_op();
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	7fa080e7          	jalr	2042(ra) # 800035a4 <end_op>
  p->cwd = ip;
    80004db2:	14993823          	sd	s1,336(s2)
  return 0;
    80004db6:	4501                	li	a0,0
}
    80004db8:	60ea                	ld	ra,152(sp)
    80004dba:	644a                	ld	s0,144(sp)
    80004dbc:	64aa                	ld	s1,136(sp)
    80004dbe:	690a                	ld	s2,128(sp)
    80004dc0:	610d                	addi	sp,sp,160
    80004dc2:	8082                	ret
    end_op();
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	7e0080e7          	jalr	2016(ra) # 800035a4 <end_op>
    return -1;
    80004dcc:	557d                	li	a0,-1
    80004dce:	b7ed                	j	80004db8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	fe2080e7          	jalr	-30(ra) # 80002db4 <iunlockput>
    end_op();
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	7ca080e7          	jalr	1994(ra) # 800035a4 <end_op>
    return -1;
    80004de2:	557d                	li	a0,-1
    80004de4:	bfd1                	j	80004db8 <sys_chdir+0x7a>

0000000080004de6 <sys_exec>:

uint64
sys_exec(void)
{
    80004de6:	7145                	addi	sp,sp,-464
    80004de8:	e786                	sd	ra,456(sp)
    80004dea:	e3a2                	sd	s0,448(sp)
    80004dec:	ff26                	sd	s1,440(sp)
    80004dee:	fb4a                	sd	s2,432(sp)
    80004df0:	f74e                	sd	s3,424(sp)
    80004df2:	f352                	sd	s4,416(sp)
    80004df4:	ef56                	sd	s5,408(sp)
    80004df6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004df8:	08000613          	li	a2,128
    80004dfc:	f4040593          	addi	a1,s0,-192
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	1ce080e7          	jalr	462(ra) # 80001fd0 <argstr>
    return -1;
    80004e0a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e0c:	0c054a63          	bltz	a0,80004ee0 <sys_exec+0xfa>
    80004e10:	e3840593          	addi	a1,s0,-456
    80004e14:	4505                	li	a0,1
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	198080e7          	jalr	408(ra) # 80001fae <argaddr>
    80004e1e:	0c054163          	bltz	a0,80004ee0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e22:	10000613          	li	a2,256
    80004e26:	4581                	li	a1,0
    80004e28:	e4040513          	addi	a0,s0,-448
    80004e2c:	ffffb097          	auipc	ra,0xffffb
    80004e30:	34c080e7          	jalr	844(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e34:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e38:	89a6                	mv	s3,s1
    80004e3a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e3c:	02000a13          	li	s4,32
    80004e40:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e44:	00391513          	slli	a0,s2,0x3
    80004e48:	e3040593          	addi	a1,s0,-464
    80004e4c:	e3843783          	ld	a5,-456(s0)
    80004e50:	953e                	add	a0,a0,a5
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	0a0080e7          	jalr	160(ra) # 80001ef2 <fetchaddr>
    80004e5a:	02054a63          	bltz	a0,80004e8e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e5e:	e3043783          	ld	a5,-464(s0)
    80004e62:	c3b9                	beqz	a5,80004ea8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e64:	ffffb097          	auipc	ra,0xffffb
    80004e68:	2b4080e7          	jalr	692(ra) # 80000118 <kalloc>
    80004e6c:	85aa                	mv	a1,a0
    80004e6e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e72:	cd11                	beqz	a0,80004e8e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e74:	6605                	lui	a2,0x1
    80004e76:	e3043503          	ld	a0,-464(s0)
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	0ca080e7          	jalr	202(ra) # 80001f44 <fetchstr>
    80004e82:	00054663          	bltz	a0,80004e8e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e86:	0905                	addi	s2,s2,1
    80004e88:	09a1                	addi	s3,s3,8
    80004e8a:	fb491be3          	bne	s2,s4,80004e40 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8e:	10048913          	addi	s2,s1,256
    80004e92:	6088                	ld	a0,0(s1)
    80004e94:	c529                	beqz	a0,80004ede <sys_exec+0xf8>
    kfree(argv[i]);
    80004e96:	ffffb097          	auipc	ra,0xffffb
    80004e9a:	186080e7          	jalr	390(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9e:	04a1                	addi	s1,s1,8
    80004ea0:	ff2499e3          	bne	s1,s2,80004e92 <sys_exec+0xac>
  return -1;
    80004ea4:	597d                	li	s2,-1
    80004ea6:	a82d                	j	80004ee0 <sys_exec+0xfa>
      argv[i] = 0;
    80004ea8:	0a8e                	slli	s5,s5,0x3
    80004eaa:	fc040793          	addi	a5,s0,-64
    80004eae:	9abe                	add	s5,s5,a5
    80004eb0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004eb4:	e4040593          	addi	a1,s0,-448
    80004eb8:	f4040513          	addi	a0,s0,-192
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	194080e7          	jalr	404(ra) # 80004050 <exec>
    80004ec4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ec6:	10048993          	addi	s3,s1,256
    80004eca:	6088                	ld	a0,0(s1)
    80004ecc:	c911                	beqz	a0,80004ee0 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ece:	ffffb097          	auipc	ra,0xffffb
    80004ed2:	14e080e7          	jalr	334(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed6:	04a1                	addi	s1,s1,8
    80004ed8:	ff3499e3          	bne	s1,s3,80004eca <sys_exec+0xe4>
    80004edc:	a011                	j	80004ee0 <sys_exec+0xfa>
  return -1;
    80004ede:	597d                	li	s2,-1
}
    80004ee0:	854a                	mv	a0,s2
    80004ee2:	60be                	ld	ra,456(sp)
    80004ee4:	641e                	ld	s0,448(sp)
    80004ee6:	74fa                	ld	s1,440(sp)
    80004ee8:	795a                	ld	s2,432(sp)
    80004eea:	79ba                	ld	s3,424(sp)
    80004eec:	7a1a                	ld	s4,416(sp)
    80004eee:	6afa                	ld	s5,408(sp)
    80004ef0:	6179                	addi	sp,sp,464
    80004ef2:	8082                	ret

0000000080004ef4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ef4:	7139                	addi	sp,sp,-64
    80004ef6:	fc06                	sd	ra,56(sp)
    80004ef8:	f822                	sd	s0,48(sp)
    80004efa:	f426                	sd	s1,40(sp)
    80004efc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004efe:	ffffc097          	auipc	ra,0xffffc
    80004f02:	f4a080e7          	jalr	-182(ra) # 80000e48 <myproc>
    80004f06:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f08:	fd840593          	addi	a1,s0,-40
    80004f0c:	4501                	li	a0,0
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	0a0080e7          	jalr	160(ra) # 80001fae <argaddr>
    return -1;
    80004f16:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f18:	0e054063          	bltz	a0,80004ff8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f1c:	fc840593          	addi	a1,s0,-56
    80004f20:	fd040513          	addi	a0,s0,-48
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	dfc080e7          	jalr	-516(ra) # 80003d20 <pipealloc>
    return -1;
    80004f2c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f2e:	0c054563          	bltz	a0,80004ff8 <sys_pipe+0x104>
  fd0 = -1;
    80004f32:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f36:	fd043503          	ld	a0,-48(s0)
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	508080e7          	jalr	1288(ra) # 80004442 <fdalloc>
    80004f42:	fca42223          	sw	a0,-60(s0)
    80004f46:	08054c63          	bltz	a0,80004fde <sys_pipe+0xea>
    80004f4a:	fc843503          	ld	a0,-56(s0)
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	4f4080e7          	jalr	1268(ra) # 80004442 <fdalloc>
    80004f56:	fca42023          	sw	a0,-64(s0)
    80004f5a:	06054863          	bltz	a0,80004fca <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f5e:	4691                	li	a3,4
    80004f60:	fc440613          	addi	a2,s0,-60
    80004f64:	fd843583          	ld	a1,-40(s0)
    80004f68:	68a8                	ld	a0,80(s1)
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	ba0080e7          	jalr	-1120(ra) # 80000b0a <copyout>
    80004f72:	02054063          	bltz	a0,80004f92 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f76:	4691                	li	a3,4
    80004f78:	fc040613          	addi	a2,s0,-64
    80004f7c:	fd843583          	ld	a1,-40(s0)
    80004f80:	0591                	addi	a1,a1,4
    80004f82:	68a8                	ld	a0,80(s1)
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	b86080e7          	jalr	-1146(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f8c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f8e:	06055563          	bgez	a0,80004ff8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f92:	fc442783          	lw	a5,-60(s0)
    80004f96:	07e9                	addi	a5,a5,26
    80004f98:	078e                	slli	a5,a5,0x3
    80004f9a:	97a6                	add	a5,a5,s1
    80004f9c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fa0:	fc042503          	lw	a0,-64(s0)
    80004fa4:	0569                	addi	a0,a0,26
    80004fa6:	050e                	slli	a0,a0,0x3
    80004fa8:	9526                	add	a0,a0,s1
    80004faa:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fae:	fd043503          	ld	a0,-48(s0)
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	a3e080e7          	jalr	-1474(ra) # 800039f0 <fileclose>
    fileclose(wf);
    80004fba:	fc843503          	ld	a0,-56(s0)
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	a32080e7          	jalr	-1486(ra) # 800039f0 <fileclose>
    return -1;
    80004fc6:	57fd                	li	a5,-1
    80004fc8:	a805                	j	80004ff8 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004fca:	fc442783          	lw	a5,-60(s0)
    80004fce:	0007c863          	bltz	a5,80004fde <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fd2:	01a78513          	addi	a0,a5,26
    80004fd6:	050e                	slli	a0,a0,0x3
    80004fd8:	9526                	add	a0,a0,s1
    80004fda:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fde:	fd043503          	ld	a0,-48(s0)
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	a0e080e7          	jalr	-1522(ra) # 800039f0 <fileclose>
    fileclose(wf);
    80004fea:	fc843503          	ld	a0,-56(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	a02080e7          	jalr	-1534(ra) # 800039f0 <fileclose>
    return -1;
    80004ff6:	57fd                	li	a5,-1
}
    80004ff8:	853e                	mv	a0,a5
    80004ffa:	70e2                	ld	ra,56(sp)
    80004ffc:	7442                	ld	s0,48(sp)
    80004ffe:	74a2                	ld	s1,40(sp)
    80005000:	6121                	addi	sp,sp,64
    80005002:	8082                	ret
	...

0000000080005010 <kernelvec>:
    80005010:	7111                	addi	sp,sp,-256
    80005012:	e006                	sd	ra,0(sp)
    80005014:	e40a                	sd	sp,8(sp)
    80005016:	e80e                	sd	gp,16(sp)
    80005018:	ec12                	sd	tp,24(sp)
    8000501a:	f016                	sd	t0,32(sp)
    8000501c:	f41a                	sd	t1,40(sp)
    8000501e:	f81e                	sd	t2,48(sp)
    80005020:	fc22                	sd	s0,56(sp)
    80005022:	e0a6                	sd	s1,64(sp)
    80005024:	e4aa                	sd	a0,72(sp)
    80005026:	e8ae                	sd	a1,80(sp)
    80005028:	ecb2                	sd	a2,88(sp)
    8000502a:	f0b6                	sd	a3,96(sp)
    8000502c:	f4ba                	sd	a4,104(sp)
    8000502e:	f8be                	sd	a5,112(sp)
    80005030:	fcc2                	sd	a6,120(sp)
    80005032:	e146                	sd	a7,128(sp)
    80005034:	e54a                	sd	s2,136(sp)
    80005036:	e94e                	sd	s3,144(sp)
    80005038:	ed52                	sd	s4,152(sp)
    8000503a:	f156                	sd	s5,160(sp)
    8000503c:	f55a                	sd	s6,168(sp)
    8000503e:	f95e                	sd	s7,176(sp)
    80005040:	fd62                	sd	s8,184(sp)
    80005042:	e1e6                	sd	s9,192(sp)
    80005044:	e5ea                	sd	s10,200(sp)
    80005046:	e9ee                	sd	s11,208(sp)
    80005048:	edf2                	sd	t3,216(sp)
    8000504a:	f1f6                	sd	t4,224(sp)
    8000504c:	f5fa                	sd	t5,232(sp)
    8000504e:	f9fe                	sd	t6,240(sp)
    80005050:	d21fc0ef          	jal	ra,80001d70 <kerneltrap>
    80005054:	6082                	ld	ra,0(sp)
    80005056:	6122                	ld	sp,8(sp)
    80005058:	61c2                	ld	gp,16(sp)
    8000505a:	7282                	ld	t0,32(sp)
    8000505c:	7322                	ld	t1,40(sp)
    8000505e:	73c2                	ld	t2,48(sp)
    80005060:	7462                	ld	s0,56(sp)
    80005062:	6486                	ld	s1,64(sp)
    80005064:	6526                	ld	a0,72(sp)
    80005066:	65c6                	ld	a1,80(sp)
    80005068:	6666                	ld	a2,88(sp)
    8000506a:	7686                	ld	a3,96(sp)
    8000506c:	7726                	ld	a4,104(sp)
    8000506e:	77c6                	ld	a5,112(sp)
    80005070:	7866                	ld	a6,120(sp)
    80005072:	688a                	ld	a7,128(sp)
    80005074:	692a                	ld	s2,136(sp)
    80005076:	69ca                	ld	s3,144(sp)
    80005078:	6a6a                	ld	s4,152(sp)
    8000507a:	7a8a                	ld	s5,160(sp)
    8000507c:	7b2a                	ld	s6,168(sp)
    8000507e:	7bca                	ld	s7,176(sp)
    80005080:	7c6a                	ld	s8,184(sp)
    80005082:	6c8e                	ld	s9,192(sp)
    80005084:	6d2e                	ld	s10,200(sp)
    80005086:	6dce                	ld	s11,208(sp)
    80005088:	6e6e                	ld	t3,216(sp)
    8000508a:	7e8e                	ld	t4,224(sp)
    8000508c:	7f2e                	ld	t5,232(sp)
    8000508e:	7fce                	ld	t6,240(sp)
    80005090:	6111                	addi	sp,sp,256
    80005092:	10200073          	sret
    80005096:	00000013          	nop
    8000509a:	00000013          	nop
    8000509e:	0001                	nop

00000000800050a0 <timervec>:
    800050a0:	34051573          	csrrw	a0,mscratch,a0
    800050a4:	e10c                	sd	a1,0(a0)
    800050a6:	e510                	sd	a2,8(a0)
    800050a8:	e914                	sd	a3,16(a0)
    800050aa:	6d0c                	ld	a1,24(a0)
    800050ac:	7110                	ld	a2,32(a0)
    800050ae:	6194                	ld	a3,0(a1)
    800050b0:	96b2                	add	a3,a3,a2
    800050b2:	e194                	sd	a3,0(a1)
    800050b4:	4589                	li	a1,2
    800050b6:	14459073          	csrw	sip,a1
    800050ba:	6914                	ld	a3,16(a0)
    800050bc:	6510                	ld	a2,8(a0)
    800050be:	610c                	ld	a1,0(a0)
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	30200073          	mret
	...

00000000800050ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ca:	1141                	addi	sp,sp,-16
    800050cc:	e422                	sd	s0,8(sp)
    800050ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050d0:	0c0007b7          	lui	a5,0xc000
    800050d4:	4705                	li	a4,1
    800050d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050d8:	c3d8                	sw	a4,4(a5)
}
    800050da:	6422                	ld	s0,8(sp)
    800050dc:	0141                	addi	sp,sp,16
    800050de:	8082                	ret

00000000800050e0 <plicinithart>:

void
plicinithart(void)
{
    800050e0:	1141                	addi	sp,sp,-16
    800050e2:	e406                	sd	ra,8(sp)
    800050e4:	e022                	sd	s0,0(sp)
    800050e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d34080e7          	jalr	-716(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050f0:	0085171b          	slliw	a4,a0,0x8
    800050f4:	0c0027b7          	lui	a5,0xc002
    800050f8:	97ba                	add	a5,a5,a4
    800050fa:	40200713          	li	a4,1026
    800050fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005102:	00d5151b          	slliw	a0,a0,0xd
    80005106:	0c2017b7          	lui	a5,0xc201
    8000510a:	953e                	add	a0,a0,a5
    8000510c:	00052023          	sw	zero,0(a0)
}
    80005110:	60a2                	ld	ra,8(sp)
    80005112:	6402                	ld	s0,0(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret

0000000080005118 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005118:	1141                	addi	sp,sp,-16
    8000511a:	e406                	sd	ra,8(sp)
    8000511c:	e022                	sd	s0,0(sp)
    8000511e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	cfc080e7          	jalr	-772(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005128:	00d5179b          	slliw	a5,a0,0xd
    8000512c:	0c201537          	lui	a0,0xc201
    80005130:	953e                	add	a0,a0,a5
  return irq;
}
    80005132:	4148                	lw	a0,4(a0)
    80005134:	60a2                	ld	ra,8(sp)
    80005136:	6402                	ld	s0,0(sp)
    80005138:	0141                	addi	sp,sp,16
    8000513a:	8082                	ret

000000008000513c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000513c:	1101                	addi	sp,sp,-32
    8000513e:	ec06                	sd	ra,24(sp)
    80005140:	e822                	sd	s0,16(sp)
    80005142:	e426                	sd	s1,8(sp)
    80005144:	1000                	addi	s0,sp,32
    80005146:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	cd4080e7          	jalr	-812(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005150:	00d5151b          	slliw	a0,a0,0xd
    80005154:	0c2017b7          	lui	a5,0xc201
    80005158:	97aa                	add	a5,a5,a0
    8000515a:	c3c4                	sw	s1,4(a5)
}
    8000515c:	60e2                	ld	ra,24(sp)
    8000515e:	6442                	ld	s0,16(sp)
    80005160:	64a2                	ld	s1,8(sp)
    80005162:	6105                	addi	sp,sp,32
    80005164:	8082                	ret

0000000080005166 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005166:	1141                	addi	sp,sp,-16
    80005168:	e406                	sd	ra,8(sp)
    8000516a:	e022                	sd	s0,0(sp)
    8000516c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000516e:	479d                	li	a5,7
    80005170:	06a7c963          	blt	a5,a0,800051e2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005174:	00016797          	auipc	a5,0x16
    80005178:	e8c78793          	addi	a5,a5,-372 # 8001b000 <disk>
    8000517c:	00a78733          	add	a4,a5,a0
    80005180:	6789                	lui	a5,0x2
    80005182:	97ba                	add	a5,a5,a4
    80005184:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005188:	e7ad                	bnez	a5,800051f2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000518a:	00451793          	slli	a5,a0,0x4
    8000518e:	00018717          	auipc	a4,0x18
    80005192:	e7270713          	addi	a4,a4,-398 # 8001d000 <disk+0x2000>
    80005196:	6314                	ld	a3,0(a4)
    80005198:	96be                	add	a3,a3,a5
    8000519a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000519e:	6314                	ld	a3,0(a4)
    800051a0:	96be                	add	a3,a3,a5
    800051a2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051a6:	6314                	ld	a3,0(a4)
    800051a8:	96be                	add	a3,a3,a5
    800051aa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051ae:	6318                	ld	a4,0(a4)
    800051b0:	97ba                	add	a5,a5,a4
    800051b2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051b6:	00016797          	auipc	a5,0x16
    800051ba:	e4a78793          	addi	a5,a5,-438 # 8001b000 <disk>
    800051be:	97aa                	add	a5,a5,a0
    800051c0:	6509                	lui	a0,0x2
    800051c2:	953e                	add	a0,a0,a5
    800051c4:	4785                	li	a5,1
    800051c6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051ca:	00018517          	auipc	a0,0x18
    800051ce:	e4e50513          	addi	a0,a0,-434 # 8001d018 <disk+0x2018>
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	4ce080e7          	jalr	1230(ra) # 800016a0 <wakeup>
}
    800051da:	60a2                	ld	ra,8(sp)
    800051dc:	6402                	ld	s0,0(sp)
    800051de:	0141                	addi	sp,sp,16
    800051e0:	8082                	ret
    panic("free_desc 1");
    800051e2:	00003517          	auipc	a0,0x3
    800051e6:	51650513          	addi	a0,a0,1302 # 800086f8 <syscalls+0x330>
    800051ea:	00001097          	auipc	ra,0x1
    800051ee:	a1e080e7          	jalr	-1506(ra) # 80005c08 <panic>
    panic("free_desc 2");
    800051f2:	00003517          	auipc	a0,0x3
    800051f6:	51650513          	addi	a0,a0,1302 # 80008708 <syscalls+0x340>
    800051fa:	00001097          	auipc	ra,0x1
    800051fe:	a0e080e7          	jalr	-1522(ra) # 80005c08 <panic>

0000000080005202 <virtio_disk_init>:
{
    80005202:	1101                	addi	sp,sp,-32
    80005204:	ec06                	sd	ra,24(sp)
    80005206:	e822                	sd	s0,16(sp)
    80005208:	e426                	sd	s1,8(sp)
    8000520a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000520c:	00003597          	auipc	a1,0x3
    80005210:	50c58593          	addi	a1,a1,1292 # 80008718 <syscalls+0x350>
    80005214:	00018517          	auipc	a0,0x18
    80005218:	f1450513          	addi	a0,a0,-236 # 8001d128 <disk+0x2128>
    8000521c:	00001097          	auipc	ra,0x1
    80005220:	f0a080e7          	jalr	-246(ra) # 80006126 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005224:	100017b7          	lui	a5,0x10001
    80005228:	4398                	lw	a4,0(a5)
    8000522a:	2701                	sext.w	a4,a4
    8000522c:	747277b7          	lui	a5,0x74727
    80005230:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005234:	0ef71163          	bne	a4,a5,80005316 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005238:	100017b7          	lui	a5,0x10001
    8000523c:	43dc                	lw	a5,4(a5)
    8000523e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005240:	4705                	li	a4,1
    80005242:	0ce79a63          	bne	a5,a4,80005316 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005246:	100017b7          	lui	a5,0x10001
    8000524a:	479c                	lw	a5,8(a5)
    8000524c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000524e:	4709                	li	a4,2
    80005250:	0ce79363          	bne	a5,a4,80005316 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005254:	100017b7          	lui	a5,0x10001
    80005258:	47d8                	lw	a4,12(a5)
    8000525a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000525c:	554d47b7          	lui	a5,0x554d4
    80005260:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005264:	0af71963          	bne	a4,a5,80005316 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005268:	100017b7          	lui	a5,0x10001
    8000526c:	4705                	li	a4,1
    8000526e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005270:	470d                	li	a4,3
    80005272:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005274:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005276:	c7ffe737          	lui	a4,0xc7ffe
    8000527a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000527e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005280:	2701                	sext.w	a4,a4
    80005282:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005284:	472d                	li	a4,11
    80005286:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005288:	473d                	li	a4,15
    8000528a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000528c:	6705                	lui	a4,0x1
    8000528e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005290:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005294:	5bdc                	lw	a5,52(a5)
    80005296:	2781                	sext.w	a5,a5
  if(max == 0)
    80005298:	c7d9                	beqz	a5,80005326 <virtio_disk_init+0x124>
  if(max < NUM)
    8000529a:	471d                	li	a4,7
    8000529c:	08f77d63          	bgeu	a4,a5,80005336 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052a0:	100014b7          	lui	s1,0x10001
    800052a4:	47a1                	li	a5,8
    800052a6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052a8:	6609                	lui	a2,0x2
    800052aa:	4581                	li	a1,0
    800052ac:	00016517          	auipc	a0,0x16
    800052b0:	d5450513          	addi	a0,a0,-684 # 8001b000 <disk>
    800052b4:	ffffb097          	auipc	ra,0xffffb
    800052b8:	ec4080e7          	jalr	-316(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052bc:	00016717          	auipc	a4,0x16
    800052c0:	d4470713          	addi	a4,a4,-700 # 8001b000 <disk>
    800052c4:	00c75793          	srli	a5,a4,0xc
    800052c8:	2781                	sext.w	a5,a5
    800052ca:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800052cc:	00018797          	auipc	a5,0x18
    800052d0:	d3478793          	addi	a5,a5,-716 # 8001d000 <disk+0x2000>
    800052d4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800052d6:	00016717          	auipc	a4,0x16
    800052da:	daa70713          	addi	a4,a4,-598 # 8001b080 <disk+0x80>
    800052de:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800052e0:	00017717          	auipc	a4,0x17
    800052e4:	d2070713          	addi	a4,a4,-736 # 8001c000 <disk+0x1000>
    800052e8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800052ea:	4705                	li	a4,1
    800052ec:	00e78c23          	sb	a4,24(a5)
    800052f0:	00e78ca3          	sb	a4,25(a5)
    800052f4:	00e78d23          	sb	a4,26(a5)
    800052f8:	00e78da3          	sb	a4,27(a5)
    800052fc:	00e78e23          	sb	a4,28(a5)
    80005300:	00e78ea3          	sb	a4,29(a5)
    80005304:	00e78f23          	sb	a4,30(a5)
    80005308:	00e78fa3          	sb	a4,31(a5)
}
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	64a2                	ld	s1,8(sp)
    80005312:	6105                	addi	sp,sp,32
    80005314:	8082                	ret
    panic("could not find virtio disk");
    80005316:	00003517          	auipc	a0,0x3
    8000531a:	41250513          	addi	a0,a0,1042 # 80008728 <syscalls+0x360>
    8000531e:	00001097          	auipc	ra,0x1
    80005322:	8ea080e7          	jalr	-1814(ra) # 80005c08 <panic>
    panic("virtio disk has no queue 0");
    80005326:	00003517          	auipc	a0,0x3
    8000532a:	42250513          	addi	a0,a0,1058 # 80008748 <syscalls+0x380>
    8000532e:	00001097          	auipc	ra,0x1
    80005332:	8da080e7          	jalr	-1830(ra) # 80005c08 <panic>
    panic("virtio disk max queue too short");
    80005336:	00003517          	auipc	a0,0x3
    8000533a:	43250513          	addi	a0,a0,1074 # 80008768 <syscalls+0x3a0>
    8000533e:	00001097          	auipc	ra,0x1
    80005342:	8ca080e7          	jalr	-1846(ra) # 80005c08 <panic>

0000000080005346 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005346:	7159                	addi	sp,sp,-112
    80005348:	f486                	sd	ra,104(sp)
    8000534a:	f0a2                	sd	s0,96(sp)
    8000534c:	eca6                	sd	s1,88(sp)
    8000534e:	e8ca                	sd	s2,80(sp)
    80005350:	e4ce                	sd	s3,72(sp)
    80005352:	e0d2                	sd	s4,64(sp)
    80005354:	fc56                	sd	s5,56(sp)
    80005356:	f85a                	sd	s6,48(sp)
    80005358:	f45e                	sd	s7,40(sp)
    8000535a:	f062                	sd	s8,32(sp)
    8000535c:	ec66                	sd	s9,24(sp)
    8000535e:	e86a                	sd	s10,16(sp)
    80005360:	1880                	addi	s0,sp,112
    80005362:	892a                	mv	s2,a0
    80005364:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005366:	00c52c83          	lw	s9,12(a0)
    8000536a:	001c9c9b          	slliw	s9,s9,0x1
    8000536e:	1c82                	slli	s9,s9,0x20
    80005370:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005374:	00018517          	auipc	a0,0x18
    80005378:	db450513          	addi	a0,a0,-588 # 8001d128 <disk+0x2128>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	e3a080e7          	jalr	-454(ra) # 800061b6 <acquire>
  for(int i = 0; i < 3; i++){
    80005384:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005386:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005388:	00016b97          	auipc	s7,0x16
    8000538c:	c78b8b93          	addi	s7,s7,-904 # 8001b000 <disk>
    80005390:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005392:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005394:	8a4e                	mv	s4,s3
    80005396:	a051                	j	8000541a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005398:	00fb86b3          	add	a3,s7,a5
    8000539c:	96da                	add	a3,a3,s6
    8000539e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053a2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053a4:	0207c563          	bltz	a5,800053ce <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053a8:	2485                	addiw	s1,s1,1
    800053aa:	0711                	addi	a4,a4,4
    800053ac:	25548063          	beq	s1,s5,800055ec <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800053b0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053b2:	00018697          	auipc	a3,0x18
    800053b6:	c6668693          	addi	a3,a3,-922 # 8001d018 <disk+0x2018>
    800053ba:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053bc:	0006c583          	lbu	a1,0(a3)
    800053c0:	fde1                	bnez	a1,80005398 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800053c2:	2785                	addiw	a5,a5,1
    800053c4:	0685                	addi	a3,a3,1
    800053c6:	ff879be3          	bne	a5,s8,800053bc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053ca:	57fd                	li	a5,-1
    800053cc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800053ce:	02905a63          	blez	s1,80005402 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800053d2:	f9042503          	lw	a0,-112(s0)
    800053d6:	00000097          	auipc	ra,0x0
    800053da:	d90080e7          	jalr	-624(ra) # 80005166 <free_desc>
      for(int j = 0; j < i; j++)
    800053de:	4785                	li	a5,1
    800053e0:	0297d163          	bge	a5,s1,80005402 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800053e4:	f9442503          	lw	a0,-108(s0)
    800053e8:	00000097          	auipc	ra,0x0
    800053ec:	d7e080e7          	jalr	-642(ra) # 80005166 <free_desc>
      for(int j = 0; j < i; j++)
    800053f0:	4789                	li	a5,2
    800053f2:	0097d863          	bge	a5,s1,80005402 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800053f6:	f9842503          	lw	a0,-104(s0)
    800053fa:	00000097          	auipc	ra,0x0
    800053fe:	d6c080e7          	jalr	-660(ra) # 80005166 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005402:	00018597          	auipc	a1,0x18
    80005406:	d2658593          	addi	a1,a1,-730 # 8001d128 <disk+0x2128>
    8000540a:	00018517          	auipc	a0,0x18
    8000540e:	c0e50513          	addi	a0,a0,-1010 # 8001d018 <disk+0x2018>
    80005412:	ffffc097          	auipc	ra,0xffffc
    80005416:	102080e7          	jalr	258(ra) # 80001514 <sleep>
  for(int i = 0; i < 3; i++){
    8000541a:	f9040713          	addi	a4,s0,-112
    8000541e:	84ce                	mv	s1,s3
    80005420:	bf41                	j	800053b0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005422:	20058713          	addi	a4,a1,512
    80005426:	00471693          	slli	a3,a4,0x4
    8000542a:	00016717          	auipc	a4,0x16
    8000542e:	bd670713          	addi	a4,a4,-1066 # 8001b000 <disk>
    80005432:	9736                	add	a4,a4,a3
    80005434:	4685                	li	a3,1
    80005436:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000543a:	20058713          	addi	a4,a1,512
    8000543e:	00471693          	slli	a3,a4,0x4
    80005442:	00016717          	auipc	a4,0x16
    80005446:	bbe70713          	addi	a4,a4,-1090 # 8001b000 <disk>
    8000544a:	9736                	add	a4,a4,a3
    8000544c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005450:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005454:	7679                	lui	a2,0xffffe
    80005456:	963e                	add	a2,a2,a5
    80005458:	00018697          	auipc	a3,0x18
    8000545c:	ba868693          	addi	a3,a3,-1112 # 8001d000 <disk+0x2000>
    80005460:	6298                	ld	a4,0(a3)
    80005462:	9732                	add	a4,a4,a2
    80005464:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005466:	6298                	ld	a4,0(a3)
    80005468:	9732                	add	a4,a4,a2
    8000546a:	4541                	li	a0,16
    8000546c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000546e:	6298                	ld	a4,0(a3)
    80005470:	9732                	add	a4,a4,a2
    80005472:	4505                	li	a0,1
    80005474:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005478:	f9442703          	lw	a4,-108(s0)
    8000547c:	6288                	ld	a0,0(a3)
    8000547e:	962a                	add	a2,a2,a0
    80005480:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005484:	0712                	slli	a4,a4,0x4
    80005486:	6290                	ld	a2,0(a3)
    80005488:	963a                	add	a2,a2,a4
    8000548a:	05890513          	addi	a0,s2,88
    8000548e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005490:	6294                	ld	a3,0(a3)
    80005492:	96ba                	add	a3,a3,a4
    80005494:	40000613          	li	a2,1024
    80005498:	c690                	sw	a2,8(a3)
  if(write)
    8000549a:	140d0063          	beqz	s10,800055da <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000549e:	00018697          	auipc	a3,0x18
    800054a2:	b626b683          	ld	a3,-1182(a3) # 8001d000 <disk+0x2000>
    800054a6:	96ba                	add	a3,a3,a4
    800054a8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ac:	00016817          	auipc	a6,0x16
    800054b0:	b5480813          	addi	a6,a6,-1196 # 8001b000 <disk>
    800054b4:	00018517          	auipc	a0,0x18
    800054b8:	b4c50513          	addi	a0,a0,-1204 # 8001d000 <disk+0x2000>
    800054bc:	6114                	ld	a3,0(a0)
    800054be:	96ba                	add	a3,a3,a4
    800054c0:	00c6d603          	lhu	a2,12(a3)
    800054c4:	00166613          	ori	a2,a2,1
    800054c8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054cc:	f9842683          	lw	a3,-104(s0)
    800054d0:	6110                	ld	a2,0(a0)
    800054d2:	9732                	add	a4,a4,a2
    800054d4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d8:	20058613          	addi	a2,a1,512
    800054dc:	0612                	slli	a2,a2,0x4
    800054de:	9642                	add	a2,a2,a6
    800054e0:	577d                	li	a4,-1
    800054e2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e6:	00469713          	slli	a4,a3,0x4
    800054ea:	6114                	ld	a3,0(a0)
    800054ec:	96ba                	add	a3,a3,a4
    800054ee:	03078793          	addi	a5,a5,48
    800054f2:	97c2                	add	a5,a5,a6
    800054f4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800054f6:	611c                	ld	a5,0(a0)
    800054f8:	97ba                	add	a5,a5,a4
    800054fa:	4685                	li	a3,1
    800054fc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054fe:	611c                	ld	a5,0(a0)
    80005500:	97ba                	add	a5,a5,a4
    80005502:	4809                	li	a6,2
    80005504:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005508:	611c                	ld	a5,0(a0)
    8000550a:	973e                	add	a4,a4,a5
    8000550c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005510:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005514:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005518:	6518                	ld	a4,8(a0)
    8000551a:	00275783          	lhu	a5,2(a4)
    8000551e:	8b9d                	andi	a5,a5,7
    80005520:	0786                	slli	a5,a5,0x1
    80005522:	97ba                	add	a5,a5,a4
    80005524:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005528:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000552c:	6518                	ld	a4,8(a0)
    8000552e:	00275783          	lhu	a5,2(a4)
    80005532:	2785                	addiw	a5,a5,1
    80005534:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005538:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000553c:	100017b7          	lui	a5,0x10001
    80005540:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005544:	00492703          	lw	a4,4(s2)
    80005548:	4785                	li	a5,1
    8000554a:	02f71163          	bne	a4,a5,8000556c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000554e:	00018997          	auipc	s3,0x18
    80005552:	bda98993          	addi	s3,s3,-1062 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005556:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005558:	85ce                	mv	a1,s3
    8000555a:	854a                	mv	a0,s2
    8000555c:	ffffc097          	auipc	ra,0xffffc
    80005560:	fb8080e7          	jalr	-72(ra) # 80001514 <sleep>
  while(b->disk == 1) {
    80005564:	00492783          	lw	a5,4(s2)
    80005568:	fe9788e3          	beq	a5,s1,80005558 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000556c:	f9042903          	lw	s2,-112(s0)
    80005570:	20090793          	addi	a5,s2,512
    80005574:	00479713          	slli	a4,a5,0x4
    80005578:	00016797          	auipc	a5,0x16
    8000557c:	a8878793          	addi	a5,a5,-1400 # 8001b000 <disk>
    80005580:	97ba                	add	a5,a5,a4
    80005582:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005586:	00018997          	auipc	s3,0x18
    8000558a:	a7a98993          	addi	s3,s3,-1414 # 8001d000 <disk+0x2000>
    8000558e:	00491713          	slli	a4,s2,0x4
    80005592:	0009b783          	ld	a5,0(s3)
    80005596:	97ba                	add	a5,a5,a4
    80005598:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000559c:	854a                	mv	a0,s2
    8000559e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055a2:	00000097          	auipc	ra,0x0
    800055a6:	bc4080e7          	jalr	-1084(ra) # 80005166 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055aa:	8885                	andi	s1,s1,1
    800055ac:	f0ed                	bnez	s1,8000558e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ae:	00018517          	auipc	a0,0x18
    800055b2:	b7a50513          	addi	a0,a0,-1158 # 8001d128 <disk+0x2128>
    800055b6:	00001097          	auipc	ra,0x1
    800055ba:	cb4080e7          	jalr	-844(ra) # 8000626a <release>
}
    800055be:	70a6                	ld	ra,104(sp)
    800055c0:	7406                	ld	s0,96(sp)
    800055c2:	64e6                	ld	s1,88(sp)
    800055c4:	6946                	ld	s2,80(sp)
    800055c6:	69a6                	ld	s3,72(sp)
    800055c8:	6a06                	ld	s4,64(sp)
    800055ca:	7ae2                	ld	s5,56(sp)
    800055cc:	7b42                	ld	s6,48(sp)
    800055ce:	7ba2                	ld	s7,40(sp)
    800055d0:	7c02                	ld	s8,32(sp)
    800055d2:	6ce2                	ld	s9,24(sp)
    800055d4:	6d42                	ld	s10,16(sp)
    800055d6:	6165                	addi	sp,sp,112
    800055d8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055da:	00018697          	auipc	a3,0x18
    800055de:	a266b683          	ld	a3,-1498(a3) # 8001d000 <disk+0x2000>
    800055e2:	96ba                	add	a3,a3,a4
    800055e4:	4609                	li	a2,2
    800055e6:	00c69623          	sh	a2,12(a3)
    800055ea:	b5c9                	j	800054ac <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055ec:	f9042583          	lw	a1,-112(s0)
    800055f0:	20058793          	addi	a5,a1,512
    800055f4:	0792                	slli	a5,a5,0x4
    800055f6:	00016517          	auipc	a0,0x16
    800055fa:	ab250513          	addi	a0,a0,-1358 # 8001b0a8 <disk+0xa8>
    800055fe:	953e                	add	a0,a0,a5
  if(write)
    80005600:	e20d11e3          	bnez	s10,80005422 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005604:	20058713          	addi	a4,a1,512
    80005608:	00471693          	slli	a3,a4,0x4
    8000560c:	00016717          	auipc	a4,0x16
    80005610:	9f470713          	addi	a4,a4,-1548 # 8001b000 <disk>
    80005614:	9736                	add	a4,a4,a3
    80005616:	0a072423          	sw	zero,168(a4)
    8000561a:	b505                	j	8000543a <virtio_disk_rw+0xf4>

000000008000561c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000561c:	1101                	addi	sp,sp,-32
    8000561e:	ec06                	sd	ra,24(sp)
    80005620:	e822                	sd	s0,16(sp)
    80005622:	e426                	sd	s1,8(sp)
    80005624:	e04a                	sd	s2,0(sp)
    80005626:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005628:	00018517          	auipc	a0,0x18
    8000562c:	b0050513          	addi	a0,a0,-1280 # 8001d128 <disk+0x2128>
    80005630:	00001097          	auipc	ra,0x1
    80005634:	b86080e7          	jalr	-1146(ra) # 800061b6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005638:	10001737          	lui	a4,0x10001
    8000563c:	533c                	lw	a5,96(a4)
    8000563e:	8b8d                	andi	a5,a5,3
    80005640:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005642:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005646:	00018797          	auipc	a5,0x18
    8000564a:	9ba78793          	addi	a5,a5,-1606 # 8001d000 <disk+0x2000>
    8000564e:	6b94                	ld	a3,16(a5)
    80005650:	0207d703          	lhu	a4,32(a5)
    80005654:	0026d783          	lhu	a5,2(a3)
    80005658:	06f70163          	beq	a4,a5,800056ba <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000565c:	00016917          	auipc	s2,0x16
    80005660:	9a490913          	addi	s2,s2,-1628 # 8001b000 <disk>
    80005664:	00018497          	auipc	s1,0x18
    80005668:	99c48493          	addi	s1,s1,-1636 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000566c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005670:	6898                	ld	a4,16(s1)
    80005672:	0204d783          	lhu	a5,32(s1)
    80005676:	8b9d                	andi	a5,a5,7
    80005678:	078e                	slli	a5,a5,0x3
    8000567a:	97ba                	add	a5,a5,a4
    8000567c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000567e:	20078713          	addi	a4,a5,512
    80005682:	0712                	slli	a4,a4,0x4
    80005684:	974a                	add	a4,a4,s2
    80005686:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000568a:	e731                	bnez	a4,800056d6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000568c:	20078793          	addi	a5,a5,512
    80005690:	0792                	slli	a5,a5,0x4
    80005692:	97ca                	add	a5,a5,s2
    80005694:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005696:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000569a:	ffffc097          	auipc	ra,0xffffc
    8000569e:	006080e7          	jalr	6(ra) # 800016a0 <wakeup>

    disk.used_idx += 1;
    800056a2:	0204d783          	lhu	a5,32(s1)
    800056a6:	2785                	addiw	a5,a5,1
    800056a8:	17c2                	slli	a5,a5,0x30
    800056aa:	93c1                	srli	a5,a5,0x30
    800056ac:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056b0:	6898                	ld	a4,16(s1)
    800056b2:	00275703          	lhu	a4,2(a4)
    800056b6:	faf71be3          	bne	a4,a5,8000566c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056ba:	00018517          	auipc	a0,0x18
    800056be:	a6e50513          	addi	a0,a0,-1426 # 8001d128 <disk+0x2128>
    800056c2:	00001097          	auipc	ra,0x1
    800056c6:	ba8080e7          	jalr	-1112(ra) # 8000626a <release>
}
    800056ca:	60e2                	ld	ra,24(sp)
    800056cc:	6442                	ld	s0,16(sp)
    800056ce:	64a2                	ld	s1,8(sp)
    800056d0:	6902                	ld	s2,0(sp)
    800056d2:	6105                	addi	sp,sp,32
    800056d4:	8082                	ret
      panic("virtio_disk_intr status");
    800056d6:	00003517          	auipc	a0,0x3
    800056da:	0b250513          	addi	a0,a0,178 # 80008788 <syscalls+0x3c0>
    800056de:	00000097          	auipc	ra,0x0
    800056e2:	52a080e7          	jalr	1322(ra) # 80005c08 <panic>

00000000800056e6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056e6:	1141                	addi	sp,sp,-16
    800056e8:	e422                	sd	s0,8(sp)
    800056ea:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056ec:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056f0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056f4:	0037979b          	slliw	a5,a5,0x3
    800056f8:	02004737          	lui	a4,0x2004
    800056fc:	97ba                	add	a5,a5,a4
    800056fe:	0200c737          	lui	a4,0x200c
    80005702:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005706:	000f4637          	lui	a2,0xf4
    8000570a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000570e:	95b2                	add	a1,a1,a2
    80005710:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005712:	00269713          	slli	a4,a3,0x2
    80005716:	9736                	add	a4,a4,a3
    80005718:	00371693          	slli	a3,a4,0x3
    8000571c:	00019717          	auipc	a4,0x19
    80005720:	8e470713          	addi	a4,a4,-1820 # 8001e000 <timer_scratch>
    80005724:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005726:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005728:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000572a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000572e:	00000797          	auipc	a5,0x0
    80005732:	97278793          	addi	a5,a5,-1678 # 800050a0 <timervec>
    80005736:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000573a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000573e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005742:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005746:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000574a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000574e:	30479073          	csrw	mie,a5
}
    80005752:	6422                	ld	s0,8(sp)
    80005754:	0141                	addi	sp,sp,16
    80005756:	8082                	ret

0000000080005758 <start>:
{
    80005758:	1141                	addi	sp,sp,-16
    8000575a:	e406                	sd	ra,8(sp)
    8000575c:	e022                	sd	s0,0(sp)
    8000575e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005760:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005764:	7779                	lui	a4,0xffffe
    80005766:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000576a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000576c:	6705                	lui	a4,0x1
    8000576e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005772:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005774:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005778:	ffffb797          	auipc	a5,0xffffb
    8000577c:	bae78793          	addi	a5,a5,-1106 # 80000326 <main>
    80005780:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005784:	4781                	li	a5,0
    80005786:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000578a:	67c1                	lui	a5,0x10
    8000578c:	17fd                	addi	a5,a5,-1
    8000578e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005792:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005796:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000579a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000579e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057a2:	57fd                	li	a5,-1
    800057a4:	83a9                	srli	a5,a5,0xa
    800057a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057aa:	47bd                	li	a5,15
    800057ac:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	f36080e7          	jalr	-202(ra) # 800056e6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057b8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057bc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057be:	823e                	mv	tp,a5
  asm volatile("mret");
    800057c0:	30200073          	mret
}
    800057c4:	60a2                	ld	ra,8(sp)
    800057c6:	6402                	ld	s0,0(sp)
    800057c8:	0141                	addi	sp,sp,16
    800057ca:	8082                	ret

00000000800057cc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057cc:	715d                	addi	sp,sp,-80
    800057ce:	e486                	sd	ra,72(sp)
    800057d0:	e0a2                	sd	s0,64(sp)
    800057d2:	fc26                	sd	s1,56(sp)
    800057d4:	f84a                	sd	s2,48(sp)
    800057d6:	f44e                	sd	s3,40(sp)
    800057d8:	f052                	sd	s4,32(sp)
    800057da:	ec56                	sd	s5,24(sp)
    800057dc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057de:	04c05663          	blez	a2,8000582a <consolewrite+0x5e>
    800057e2:	8a2a                	mv	s4,a0
    800057e4:	84ae                	mv	s1,a1
    800057e6:	89b2                	mv	s3,a2
    800057e8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057ea:	5afd                	li	s5,-1
    800057ec:	4685                	li	a3,1
    800057ee:	8626                	mv	a2,s1
    800057f0:	85d2                	mv	a1,s4
    800057f2:	fbf40513          	addi	a0,s0,-65
    800057f6:	ffffc097          	auipc	ra,0xffffc
    800057fa:	118080e7          	jalr	280(ra) # 8000190e <either_copyin>
    800057fe:	01550c63          	beq	a0,s5,80005816 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005802:	fbf44503          	lbu	a0,-65(s0)
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	7f2080e7          	jalr	2034(ra) # 80005ff8 <uartputc>
  for(i = 0; i < n; i++){
    8000580e:	2905                	addiw	s2,s2,1
    80005810:	0485                	addi	s1,s1,1
    80005812:	fd299de3          	bne	s3,s2,800057ec <consolewrite+0x20>
  }

  return i;
}
    80005816:	854a                	mv	a0,s2
    80005818:	60a6                	ld	ra,72(sp)
    8000581a:	6406                	ld	s0,64(sp)
    8000581c:	74e2                	ld	s1,56(sp)
    8000581e:	7942                	ld	s2,48(sp)
    80005820:	79a2                	ld	s3,40(sp)
    80005822:	7a02                	ld	s4,32(sp)
    80005824:	6ae2                	ld	s5,24(sp)
    80005826:	6161                	addi	sp,sp,80
    80005828:	8082                	ret
  for(i = 0; i < n; i++){
    8000582a:	4901                	li	s2,0
    8000582c:	b7ed                	j	80005816 <consolewrite+0x4a>

000000008000582e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000582e:	7119                	addi	sp,sp,-128
    80005830:	fc86                	sd	ra,120(sp)
    80005832:	f8a2                	sd	s0,112(sp)
    80005834:	f4a6                	sd	s1,104(sp)
    80005836:	f0ca                	sd	s2,96(sp)
    80005838:	ecce                	sd	s3,88(sp)
    8000583a:	e8d2                	sd	s4,80(sp)
    8000583c:	e4d6                	sd	s5,72(sp)
    8000583e:	e0da                	sd	s6,64(sp)
    80005840:	fc5e                	sd	s7,56(sp)
    80005842:	f862                	sd	s8,48(sp)
    80005844:	f466                	sd	s9,40(sp)
    80005846:	f06a                	sd	s10,32(sp)
    80005848:	ec6e                	sd	s11,24(sp)
    8000584a:	0100                	addi	s0,sp,128
    8000584c:	8b2a                	mv	s6,a0
    8000584e:	8aae                	mv	s5,a1
    80005850:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005852:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005856:	00021517          	auipc	a0,0x21
    8000585a:	8ea50513          	addi	a0,a0,-1814 # 80026140 <cons>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	958080e7          	jalr	-1704(ra) # 800061b6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005866:	00021497          	auipc	s1,0x21
    8000586a:	8da48493          	addi	s1,s1,-1830 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000586e:	89a6                	mv	s3,s1
    80005870:	00021917          	auipc	s2,0x21
    80005874:	96890913          	addi	s2,s2,-1688 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005878:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000587a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000587c:	4da9                	li	s11,10
  while(n > 0){
    8000587e:	07405863          	blez	s4,800058ee <consoleread+0xc0>
    while(cons.r == cons.w){
    80005882:	0984a783          	lw	a5,152(s1)
    80005886:	09c4a703          	lw	a4,156(s1)
    8000588a:	02f71463          	bne	a4,a5,800058b2 <consoleread+0x84>
      if(myproc()->killed){
    8000588e:	ffffb097          	auipc	ra,0xffffb
    80005892:	5ba080e7          	jalr	1466(ra) # 80000e48 <myproc>
    80005896:	551c                	lw	a5,40(a0)
    80005898:	e7b5                	bnez	a5,80005904 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000589a:	85ce                	mv	a1,s3
    8000589c:	854a                	mv	a0,s2
    8000589e:	ffffc097          	auipc	ra,0xffffc
    800058a2:	c76080e7          	jalr	-906(ra) # 80001514 <sleep>
    while(cons.r == cons.w){
    800058a6:	0984a783          	lw	a5,152(s1)
    800058aa:	09c4a703          	lw	a4,156(s1)
    800058ae:	fef700e3          	beq	a4,a5,8000588e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058b2:	0017871b          	addiw	a4,a5,1
    800058b6:	08e4ac23          	sw	a4,152(s1)
    800058ba:	07f7f713          	andi	a4,a5,127
    800058be:	9726                	add	a4,a4,s1
    800058c0:	01874703          	lbu	a4,24(a4)
    800058c4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800058c8:	079c0663          	beq	s8,s9,80005934 <consoleread+0x106>
    cbuf = c;
    800058cc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058d0:	4685                	li	a3,1
    800058d2:	f8f40613          	addi	a2,s0,-113
    800058d6:	85d6                	mv	a1,s5
    800058d8:	855a                	mv	a0,s6
    800058da:	ffffc097          	auipc	ra,0xffffc
    800058de:	fde080e7          	jalr	-34(ra) # 800018b8 <either_copyout>
    800058e2:	01a50663          	beq	a0,s10,800058ee <consoleread+0xc0>
    dst++;
    800058e6:	0a85                	addi	s5,s5,1
    --n;
    800058e8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800058ea:	f9bc1ae3          	bne	s8,s11,8000587e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058ee:	00021517          	auipc	a0,0x21
    800058f2:	85250513          	addi	a0,a0,-1966 # 80026140 <cons>
    800058f6:	00001097          	auipc	ra,0x1
    800058fa:	974080e7          	jalr	-1676(ra) # 8000626a <release>

  return target - n;
    800058fe:	414b853b          	subw	a0,s7,s4
    80005902:	a811                	j	80005916 <consoleread+0xe8>
        release(&cons.lock);
    80005904:	00021517          	auipc	a0,0x21
    80005908:	83c50513          	addi	a0,a0,-1988 # 80026140 <cons>
    8000590c:	00001097          	auipc	ra,0x1
    80005910:	95e080e7          	jalr	-1698(ra) # 8000626a <release>
        return -1;
    80005914:	557d                	li	a0,-1
}
    80005916:	70e6                	ld	ra,120(sp)
    80005918:	7446                	ld	s0,112(sp)
    8000591a:	74a6                	ld	s1,104(sp)
    8000591c:	7906                	ld	s2,96(sp)
    8000591e:	69e6                	ld	s3,88(sp)
    80005920:	6a46                	ld	s4,80(sp)
    80005922:	6aa6                	ld	s5,72(sp)
    80005924:	6b06                	ld	s6,64(sp)
    80005926:	7be2                	ld	s7,56(sp)
    80005928:	7c42                	ld	s8,48(sp)
    8000592a:	7ca2                	ld	s9,40(sp)
    8000592c:	7d02                	ld	s10,32(sp)
    8000592e:	6de2                	ld	s11,24(sp)
    80005930:	6109                	addi	sp,sp,128
    80005932:	8082                	ret
      if(n < target){
    80005934:	000a071b          	sext.w	a4,s4
    80005938:	fb777be3          	bgeu	a4,s7,800058ee <consoleread+0xc0>
        cons.r--;
    8000593c:	00021717          	auipc	a4,0x21
    80005940:	88f72e23          	sw	a5,-1892(a4) # 800261d8 <cons+0x98>
    80005944:	b76d                	j	800058ee <consoleread+0xc0>

0000000080005946 <consputc>:
{
    80005946:	1141                	addi	sp,sp,-16
    80005948:	e406                	sd	ra,8(sp)
    8000594a:	e022                	sd	s0,0(sp)
    8000594c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000594e:	10000793          	li	a5,256
    80005952:	00f50a63          	beq	a0,a5,80005966 <consputc+0x20>
    uartputc_sync(c);
    80005956:	00000097          	auipc	ra,0x0
    8000595a:	5c8080e7          	jalr	1480(ra) # 80005f1e <uartputc_sync>
}
    8000595e:	60a2                	ld	ra,8(sp)
    80005960:	6402                	ld	s0,0(sp)
    80005962:	0141                	addi	sp,sp,16
    80005964:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005966:	4521                	li	a0,8
    80005968:	00000097          	auipc	ra,0x0
    8000596c:	5b6080e7          	jalr	1462(ra) # 80005f1e <uartputc_sync>
    80005970:	02000513          	li	a0,32
    80005974:	00000097          	auipc	ra,0x0
    80005978:	5aa080e7          	jalr	1450(ra) # 80005f1e <uartputc_sync>
    8000597c:	4521                	li	a0,8
    8000597e:	00000097          	auipc	ra,0x0
    80005982:	5a0080e7          	jalr	1440(ra) # 80005f1e <uartputc_sync>
    80005986:	bfe1                	j	8000595e <consputc+0x18>

0000000080005988 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005988:	1101                	addi	sp,sp,-32
    8000598a:	ec06                	sd	ra,24(sp)
    8000598c:	e822                	sd	s0,16(sp)
    8000598e:	e426                	sd	s1,8(sp)
    80005990:	e04a                	sd	s2,0(sp)
    80005992:	1000                	addi	s0,sp,32
    80005994:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005996:	00020517          	auipc	a0,0x20
    8000599a:	7aa50513          	addi	a0,a0,1962 # 80026140 <cons>
    8000599e:	00001097          	auipc	ra,0x1
    800059a2:	818080e7          	jalr	-2024(ra) # 800061b6 <acquire>

  switch(c){
    800059a6:	47d5                	li	a5,21
    800059a8:	0af48663          	beq	s1,a5,80005a54 <consoleintr+0xcc>
    800059ac:	0297ca63          	blt	a5,s1,800059e0 <consoleintr+0x58>
    800059b0:	47a1                	li	a5,8
    800059b2:	0ef48763          	beq	s1,a5,80005aa0 <consoleintr+0x118>
    800059b6:	47c1                	li	a5,16
    800059b8:	10f49a63          	bne	s1,a5,80005acc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059bc:	ffffc097          	auipc	ra,0xffffc
    800059c0:	fa8080e7          	jalr	-88(ra) # 80001964 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059c4:	00020517          	auipc	a0,0x20
    800059c8:	77c50513          	addi	a0,a0,1916 # 80026140 <cons>
    800059cc:	00001097          	auipc	ra,0x1
    800059d0:	89e080e7          	jalr	-1890(ra) # 8000626a <release>
}
    800059d4:	60e2                	ld	ra,24(sp)
    800059d6:	6442                	ld	s0,16(sp)
    800059d8:	64a2                	ld	s1,8(sp)
    800059da:	6902                	ld	s2,0(sp)
    800059dc:	6105                	addi	sp,sp,32
    800059de:	8082                	ret
  switch(c){
    800059e0:	07f00793          	li	a5,127
    800059e4:	0af48e63          	beq	s1,a5,80005aa0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059e8:	00020717          	auipc	a4,0x20
    800059ec:	75870713          	addi	a4,a4,1880 # 80026140 <cons>
    800059f0:	0a072783          	lw	a5,160(a4)
    800059f4:	09872703          	lw	a4,152(a4)
    800059f8:	9f99                	subw	a5,a5,a4
    800059fa:	07f00713          	li	a4,127
    800059fe:	fcf763e3          	bltu	a4,a5,800059c4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a02:	47b5                	li	a5,13
    80005a04:	0cf48763          	beq	s1,a5,80005ad2 <consoleintr+0x14a>
      consputc(c);
    80005a08:	8526                	mv	a0,s1
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	f3c080e7          	jalr	-196(ra) # 80005946 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a12:	00020797          	auipc	a5,0x20
    80005a16:	72e78793          	addi	a5,a5,1838 # 80026140 <cons>
    80005a1a:	0a07a703          	lw	a4,160(a5)
    80005a1e:	0017069b          	addiw	a3,a4,1
    80005a22:	0006861b          	sext.w	a2,a3
    80005a26:	0ad7a023          	sw	a3,160(a5)
    80005a2a:	07f77713          	andi	a4,a4,127
    80005a2e:	97ba                	add	a5,a5,a4
    80005a30:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a34:	47a9                	li	a5,10
    80005a36:	0cf48563          	beq	s1,a5,80005b00 <consoleintr+0x178>
    80005a3a:	4791                	li	a5,4
    80005a3c:	0cf48263          	beq	s1,a5,80005b00 <consoleintr+0x178>
    80005a40:	00020797          	auipc	a5,0x20
    80005a44:	7987a783          	lw	a5,1944(a5) # 800261d8 <cons+0x98>
    80005a48:	0807879b          	addiw	a5,a5,128
    80005a4c:	f6f61ce3          	bne	a2,a5,800059c4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a50:	863e                	mv	a2,a5
    80005a52:	a07d                	j	80005b00 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a54:	00020717          	auipc	a4,0x20
    80005a58:	6ec70713          	addi	a4,a4,1772 # 80026140 <cons>
    80005a5c:	0a072783          	lw	a5,160(a4)
    80005a60:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a64:	00020497          	auipc	s1,0x20
    80005a68:	6dc48493          	addi	s1,s1,1756 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a6c:	4929                	li	s2,10
    80005a6e:	f4f70be3          	beq	a4,a5,800059c4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a72:	37fd                	addiw	a5,a5,-1
    80005a74:	07f7f713          	andi	a4,a5,127
    80005a78:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a7a:	01874703          	lbu	a4,24(a4)
    80005a7e:	f52703e3          	beq	a4,s2,800059c4 <consoleintr+0x3c>
      cons.e--;
    80005a82:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a86:	10000513          	li	a0,256
    80005a8a:	00000097          	auipc	ra,0x0
    80005a8e:	ebc080e7          	jalr	-324(ra) # 80005946 <consputc>
    while(cons.e != cons.w &&
    80005a92:	0a04a783          	lw	a5,160(s1)
    80005a96:	09c4a703          	lw	a4,156(s1)
    80005a9a:	fcf71ce3          	bne	a4,a5,80005a72 <consoleintr+0xea>
    80005a9e:	b71d                	j	800059c4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aa0:	00020717          	auipc	a4,0x20
    80005aa4:	6a070713          	addi	a4,a4,1696 # 80026140 <cons>
    80005aa8:	0a072783          	lw	a5,160(a4)
    80005aac:	09c72703          	lw	a4,156(a4)
    80005ab0:	f0f70ae3          	beq	a4,a5,800059c4 <consoleintr+0x3c>
      cons.e--;
    80005ab4:	37fd                	addiw	a5,a5,-1
    80005ab6:	00020717          	auipc	a4,0x20
    80005aba:	72f72523          	sw	a5,1834(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005abe:	10000513          	li	a0,256
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	e84080e7          	jalr	-380(ra) # 80005946 <consputc>
    80005aca:	bded                	j	800059c4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005acc:	ee048ce3          	beqz	s1,800059c4 <consoleintr+0x3c>
    80005ad0:	bf21                	j	800059e8 <consoleintr+0x60>
      consputc(c);
    80005ad2:	4529                	li	a0,10
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	e72080e7          	jalr	-398(ra) # 80005946 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005adc:	00020797          	auipc	a5,0x20
    80005ae0:	66478793          	addi	a5,a5,1636 # 80026140 <cons>
    80005ae4:	0a07a703          	lw	a4,160(a5)
    80005ae8:	0017069b          	addiw	a3,a4,1
    80005aec:	0006861b          	sext.w	a2,a3
    80005af0:	0ad7a023          	sw	a3,160(a5)
    80005af4:	07f77713          	andi	a4,a4,127
    80005af8:	97ba                	add	a5,a5,a4
    80005afa:	4729                	li	a4,10
    80005afc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b00:	00020797          	auipc	a5,0x20
    80005b04:	6cc7ae23          	sw	a2,1756(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b08:	00020517          	auipc	a0,0x20
    80005b0c:	6d050513          	addi	a0,a0,1744 # 800261d8 <cons+0x98>
    80005b10:	ffffc097          	auipc	ra,0xffffc
    80005b14:	b90080e7          	jalr	-1136(ra) # 800016a0 <wakeup>
    80005b18:	b575                	j	800059c4 <consoleintr+0x3c>

0000000080005b1a <consoleinit>:

void
consoleinit(void)
{
    80005b1a:	1141                	addi	sp,sp,-16
    80005b1c:	e406                	sd	ra,8(sp)
    80005b1e:	e022                	sd	s0,0(sp)
    80005b20:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b22:	00003597          	auipc	a1,0x3
    80005b26:	c7e58593          	addi	a1,a1,-898 # 800087a0 <syscalls+0x3d8>
    80005b2a:	00020517          	auipc	a0,0x20
    80005b2e:	61650513          	addi	a0,a0,1558 # 80026140 <cons>
    80005b32:	00000097          	auipc	ra,0x0
    80005b36:	5f4080e7          	jalr	1524(ra) # 80006126 <initlock>

  uartinit();
    80005b3a:	00000097          	auipc	ra,0x0
    80005b3e:	394080e7          	jalr	916(ra) # 80005ece <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b42:	00014797          	auipc	a5,0x14
    80005b46:	d8678793          	addi	a5,a5,-634 # 800198c8 <devsw>
    80005b4a:	00000717          	auipc	a4,0x0
    80005b4e:	ce470713          	addi	a4,a4,-796 # 8000582e <consoleread>
    80005b52:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b54:	00000717          	auipc	a4,0x0
    80005b58:	c7870713          	addi	a4,a4,-904 # 800057cc <consolewrite>
    80005b5c:	ef98                	sd	a4,24(a5)
}
    80005b5e:	60a2                	ld	ra,8(sp)
    80005b60:	6402                	ld	s0,0(sp)
    80005b62:	0141                	addi	sp,sp,16
    80005b64:	8082                	ret

0000000080005b66 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b66:	7179                	addi	sp,sp,-48
    80005b68:	f406                	sd	ra,40(sp)
    80005b6a:	f022                	sd	s0,32(sp)
    80005b6c:	ec26                	sd	s1,24(sp)
    80005b6e:	e84a                	sd	s2,16(sp)
    80005b70:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b72:	c219                	beqz	a2,80005b78 <printint+0x12>
    80005b74:	08054663          	bltz	a0,80005c00 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b78:	2501                	sext.w	a0,a0
    80005b7a:	4881                	li	a7,0
    80005b7c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b80:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b82:	2581                	sext.w	a1,a1
    80005b84:	00003617          	auipc	a2,0x3
    80005b88:	c5460613          	addi	a2,a2,-940 # 800087d8 <digits>
    80005b8c:	883a                	mv	a6,a4
    80005b8e:	2705                	addiw	a4,a4,1
    80005b90:	02b577bb          	remuw	a5,a0,a1
    80005b94:	1782                	slli	a5,a5,0x20
    80005b96:	9381                	srli	a5,a5,0x20
    80005b98:	97b2                	add	a5,a5,a2
    80005b9a:	0007c783          	lbu	a5,0(a5)
    80005b9e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ba2:	0005079b          	sext.w	a5,a0
    80005ba6:	02b5553b          	divuw	a0,a0,a1
    80005baa:	0685                	addi	a3,a3,1
    80005bac:	feb7f0e3          	bgeu	a5,a1,80005b8c <printint+0x26>

  if(sign)
    80005bb0:	00088b63          	beqz	a7,80005bc6 <printint+0x60>
    buf[i++] = '-';
    80005bb4:	fe040793          	addi	a5,s0,-32
    80005bb8:	973e                	add	a4,a4,a5
    80005bba:	02d00793          	li	a5,45
    80005bbe:	fef70823          	sb	a5,-16(a4)
    80005bc2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bc6:	02e05763          	blez	a4,80005bf4 <printint+0x8e>
    80005bca:	fd040793          	addi	a5,s0,-48
    80005bce:	00e784b3          	add	s1,a5,a4
    80005bd2:	fff78913          	addi	s2,a5,-1
    80005bd6:	993a                	add	s2,s2,a4
    80005bd8:	377d                	addiw	a4,a4,-1
    80005bda:	1702                	slli	a4,a4,0x20
    80005bdc:	9301                	srli	a4,a4,0x20
    80005bde:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005be2:	fff4c503          	lbu	a0,-1(s1)
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	d60080e7          	jalr	-672(ra) # 80005946 <consputc>
  while(--i >= 0)
    80005bee:	14fd                	addi	s1,s1,-1
    80005bf0:	ff2499e3          	bne	s1,s2,80005be2 <printint+0x7c>
}
    80005bf4:	70a2                	ld	ra,40(sp)
    80005bf6:	7402                	ld	s0,32(sp)
    80005bf8:	64e2                	ld	s1,24(sp)
    80005bfa:	6942                	ld	s2,16(sp)
    80005bfc:	6145                	addi	sp,sp,48
    80005bfe:	8082                	ret
    x = -xx;
    80005c00:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c04:	4885                	li	a7,1
    x = -xx;
    80005c06:	bf9d                	j	80005b7c <printint+0x16>

0000000080005c08 <panic>:
  }
}

void
panic(char *s)
{
    80005c08:	1101                	addi	sp,sp,-32
    80005c0a:	ec06                	sd	ra,24(sp)
    80005c0c:	e822                	sd	s0,16(sp)
    80005c0e:	e426                	sd	s1,8(sp)
    80005c10:	1000                	addi	s0,sp,32
    80005c12:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c14:	00020797          	auipc	a5,0x20
    80005c18:	5e07a623          	sw	zero,1516(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c1c:	00003517          	auipc	a0,0x3
    80005c20:	b8c50513          	addi	a0,a0,-1140 # 800087a8 <syscalls+0x3e0>
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	036080e7          	jalr	54(ra) # 80005c5a <printf>
  printf(s);
    80005c2c:	8526                	mv	a0,s1
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	02c080e7          	jalr	44(ra) # 80005c5a <printf>
  printf("\n");
    80005c36:	00002517          	auipc	a0,0x2
    80005c3a:	41250513          	addi	a0,a0,1042 # 80008048 <etext+0x48>
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	01c080e7          	jalr	28(ra) # 80005c5a <printf>
  backtrace();
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	1fa080e7          	jalr	506(ra) # 80005e40 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005c4e:	4785                	li	a5,1
    80005c50:	00003717          	auipc	a4,0x3
    80005c54:	3cf72623          	sw	a5,972(a4) # 8000901c <panicked>
  for(;;)
    80005c58:	a001                	j	80005c58 <panic+0x50>

0000000080005c5a <printf>:
{
    80005c5a:	7131                	addi	sp,sp,-192
    80005c5c:	fc86                	sd	ra,120(sp)
    80005c5e:	f8a2                	sd	s0,112(sp)
    80005c60:	f4a6                	sd	s1,104(sp)
    80005c62:	f0ca                	sd	s2,96(sp)
    80005c64:	ecce                	sd	s3,88(sp)
    80005c66:	e8d2                	sd	s4,80(sp)
    80005c68:	e4d6                	sd	s5,72(sp)
    80005c6a:	e0da                	sd	s6,64(sp)
    80005c6c:	fc5e                	sd	s7,56(sp)
    80005c6e:	f862                	sd	s8,48(sp)
    80005c70:	f466                	sd	s9,40(sp)
    80005c72:	f06a                	sd	s10,32(sp)
    80005c74:	ec6e                	sd	s11,24(sp)
    80005c76:	0100                	addi	s0,sp,128
    80005c78:	8a2a                	mv	s4,a0
    80005c7a:	e40c                	sd	a1,8(s0)
    80005c7c:	e810                	sd	a2,16(s0)
    80005c7e:	ec14                	sd	a3,24(s0)
    80005c80:	f018                	sd	a4,32(s0)
    80005c82:	f41c                	sd	a5,40(s0)
    80005c84:	03043823          	sd	a6,48(s0)
    80005c88:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c8c:	00020d97          	auipc	s11,0x20
    80005c90:	574dad83          	lw	s11,1396(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c94:	020d9b63          	bnez	s11,80005cca <printf+0x70>
  if (fmt == 0)
    80005c98:	040a0263          	beqz	s4,80005cdc <printf+0x82>
  va_start(ap, fmt);
    80005c9c:	00840793          	addi	a5,s0,8
    80005ca0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ca4:	000a4503          	lbu	a0,0(s4)
    80005ca8:	16050263          	beqz	a0,80005e0c <printf+0x1b2>
    80005cac:	4481                	li	s1,0
    if(c != '%'){
    80005cae:	02500a93          	li	s5,37
    switch(c){
    80005cb2:	07000b13          	li	s6,112
  consputc('x');
    80005cb6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cb8:	00003b97          	auipc	s7,0x3
    80005cbc:	b20b8b93          	addi	s7,s7,-1248 # 800087d8 <digits>
    switch(c){
    80005cc0:	07300c93          	li	s9,115
    80005cc4:	06400c13          	li	s8,100
    80005cc8:	a82d                	j	80005d02 <printf+0xa8>
    acquire(&pr.lock);
    80005cca:	00020517          	auipc	a0,0x20
    80005cce:	51e50513          	addi	a0,a0,1310 # 800261e8 <pr>
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	4e4080e7          	jalr	1252(ra) # 800061b6 <acquire>
    80005cda:	bf7d                	j	80005c98 <printf+0x3e>
    panic("null fmt");
    80005cdc:	00003517          	auipc	a0,0x3
    80005ce0:	adc50513          	addi	a0,a0,-1316 # 800087b8 <syscalls+0x3f0>
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	f24080e7          	jalr	-220(ra) # 80005c08 <panic>
      consputc(c);
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	c5a080e7          	jalr	-934(ra) # 80005946 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf4:	2485                	addiw	s1,s1,1
    80005cf6:	009a07b3          	add	a5,s4,s1
    80005cfa:	0007c503          	lbu	a0,0(a5)
    80005cfe:	10050763          	beqz	a0,80005e0c <printf+0x1b2>
    if(c != '%'){
    80005d02:	ff5515e3          	bne	a0,s5,80005cec <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d06:	2485                	addiw	s1,s1,1
    80005d08:	009a07b3          	add	a5,s4,s1
    80005d0c:	0007c783          	lbu	a5,0(a5)
    80005d10:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d14:	cfe5                	beqz	a5,80005e0c <printf+0x1b2>
    switch(c){
    80005d16:	05678a63          	beq	a5,s6,80005d6a <printf+0x110>
    80005d1a:	02fb7663          	bgeu	s6,a5,80005d46 <printf+0xec>
    80005d1e:	09978963          	beq	a5,s9,80005db0 <printf+0x156>
    80005d22:	07800713          	li	a4,120
    80005d26:	0ce79863          	bne	a5,a4,80005df6 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d2a:	f8843783          	ld	a5,-120(s0)
    80005d2e:	00878713          	addi	a4,a5,8
    80005d32:	f8e43423          	sd	a4,-120(s0)
    80005d36:	4605                	li	a2,1
    80005d38:	85ea                	mv	a1,s10
    80005d3a:	4388                	lw	a0,0(a5)
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	e2a080e7          	jalr	-470(ra) # 80005b66 <printint>
      break;
    80005d44:	bf45                	j	80005cf4 <printf+0x9a>
    switch(c){
    80005d46:	0b578263          	beq	a5,s5,80005dea <printf+0x190>
    80005d4a:	0b879663          	bne	a5,s8,80005df6 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d4e:	f8843783          	ld	a5,-120(s0)
    80005d52:	00878713          	addi	a4,a5,8
    80005d56:	f8e43423          	sd	a4,-120(s0)
    80005d5a:	4605                	li	a2,1
    80005d5c:	45a9                	li	a1,10
    80005d5e:	4388                	lw	a0,0(a5)
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	e06080e7          	jalr	-506(ra) # 80005b66 <printint>
      break;
    80005d68:	b771                	j	80005cf4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d6a:	f8843783          	ld	a5,-120(s0)
    80005d6e:	00878713          	addi	a4,a5,8
    80005d72:	f8e43423          	sd	a4,-120(s0)
    80005d76:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005d7a:	03000513          	li	a0,48
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	bc8080e7          	jalr	-1080(ra) # 80005946 <consputc>
  consputc('x');
    80005d86:	07800513          	li	a0,120
    80005d8a:	00000097          	auipc	ra,0x0
    80005d8e:	bbc080e7          	jalr	-1092(ra) # 80005946 <consputc>
    80005d92:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d94:	03c9d793          	srli	a5,s3,0x3c
    80005d98:	97de                	add	a5,a5,s7
    80005d9a:	0007c503          	lbu	a0,0(a5)
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	ba8080e7          	jalr	-1112(ra) # 80005946 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005da6:	0992                	slli	s3,s3,0x4
    80005da8:	397d                	addiw	s2,s2,-1
    80005daa:	fe0915e3          	bnez	s2,80005d94 <printf+0x13a>
    80005dae:	b799                	j	80005cf4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005db0:	f8843783          	ld	a5,-120(s0)
    80005db4:	00878713          	addi	a4,a5,8
    80005db8:	f8e43423          	sd	a4,-120(s0)
    80005dbc:	0007b903          	ld	s2,0(a5)
    80005dc0:	00090e63          	beqz	s2,80005ddc <printf+0x182>
      for(; *s; s++)
    80005dc4:	00094503          	lbu	a0,0(s2)
    80005dc8:	d515                	beqz	a0,80005cf4 <printf+0x9a>
        consputc(*s);
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	b7c080e7          	jalr	-1156(ra) # 80005946 <consputc>
      for(; *s; s++)
    80005dd2:	0905                	addi	s2,s2,1
    80005dd4:	00094503          	lbu	a0,0(s2)
    80005dd8:	f96d                	bnez	a0,80005dca <printf+0x170>
    80005dda:	bf29                	j	80005cf4 <printf+0x9a>
        s = "(null)";
    80005ddc:	00003917          	auipc	s2,0x3
    80005de0:	9d490913          	addi	s2,s2,-1580 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    80005de4:	02800513          	li	a0,40
    80005de8:	b7cd                	j	80005dca <printf+0x170>
      consputc('%');
    80005dea:	8556                	mv	a0,s5
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	b5a080e7          	jalr	-1190(ra) # 80005946 <consputc>
      break;
    80005df4:	b701                	j	80005cf4 <printf+0x9a>
      consputc('%');
    80005df6:	8556                	mv	a0,s5
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	b4e080e7          	jalr	-1202(ra) # 80005946 <consputc>
      consputc(c);
    80005e00:	854a                	mv	a0,s2
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	b44080e7          	jalr	-1212(ra) # 80005946 <consputc>
      break;
    80005e0a:	b5ed                	j	80005cf4 <printf+0x9a>
  if(locking)
    80005e0c:	020d9163          	bnez	s11,80005e2e <printf+0x1d4>
}
    80005e10:	70e6                	ld	ra,120(sp)
    80005e12:	7446                	ld	s0,112(sp)
    80005e14:	74a6                	ld	s1,104(sp)
    80005e16:	7906                	ld	s2,96(sp)
    80005e18:	69e6                	ld	s3,88(sp)
    80005e1a:	6a46                	ld	s4,80(sp)
    80005e1c:	6aa6                	ld	s5,72(sp)
    80005e1e:	6b06                	ld	s6,64(sp)
    80005e20:	7be2                	ld	s7,56(sp)
    80005e22:	7c42                	ld	s8,48(sp)
    80005e24:	7ca2                	ld	s9,40(sp)
    80005e26:	7d02                	ld	s10,32(sp)
    80005e28:	6de2                	ld	s11,24(sp)
    80005e2a:	6129                	addi	sp,sp,192
    80005e2c:	8082                	ret
    release(&pr.lock);
    80005e2e:	00020517          	auipc	a0,0x20
    80005e32:	3ba50513          	addi	a0,a0,954 # 800261e8 <pr>
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	434080e7          	jalr	1076(ra) # 8000626a <release>
}
    80005e3e:	bfc9                	j	80005e10 <printf+0x1b6>

0000000080005e40 <backtrace>:
void backtrace() {
    80005e40:	7179                	addi	sp,sp,-48
    80005e42:	f406                	sd	ra,40(sp)
    80005e44:	f022                	sd	s0,32(sp)
    80005e46:	ec26                	sd	s1,24(sp)
    80005e48:	e84a                	sd	s2,16(sp)
    80005e4a:	e44e                	sd	s3,8(sp)
    80005e4c:	e052                	sd	s4,0(sp)
    80005e4e:	1800                	addi	s0,sp,48
typedef uint64 *pagetable_t; // 512 PTEs

// read the current frame pointer from s0 register - lab4-2
static inline uint64 r_fp() {
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x));
    80005e50:	84a2                	mv	s1,s0
  uint64 top = PGROUNDUP(fp);    // 获取用户栈最高地址
    80005e52:	6905                	lui	s2,0x1
    80005e54:	197d                	addi	s2,s2,-1
    80005e56:	9926                	add	s2,s2,s1
    80005e58:	79fd                	lui	s3,0xfffff
    80005e5a:	01397933          	and	s2,s2,s3
  uint64 bottom = PGROUNDDOWN(fp);    // 获取用户栈最低地址
    80005e5e:	0134f9b3          	and	s3,s1,s3
  for (;
    80005e62:	0334e563          	bltu	s1,s3,80005e8c <backtrace+0x4c>
    fp >= bottom && fp < top;     // 终止条件
    80005e66:	0324f363          	bgeu	s1,s2,80005e8c <backtrace+0x4c>
    printf("%p\n", *((uint64*)(fp - 8)));    // 输出当前栈中返回地址
    80005e6a:	00003a17          	auipc	s4,0x3
    80005e6e:	95ea0a13          	addi	s4,s4,-1698 # 800087c8 <syscalls+0x400>
    80005e72:	ff84b583          	ld	a1,-8(s1)
    80005e76:	8552                	mv	a0,s4
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	de2080e7          	jalr	-542(ra) # 80005c5a <printf>
    fp = *((uint64*)(fp - 16))    // 获取下一栈帧
    80005e80:	ff04b483          	ld	s1,-16(s1)
  for (;
    80005e84:	0134e463          	bltu	s1,s3,80005e8c <backtrace+0x4c>
    fp >= bottom && fp < top;     // 终止条件
    80005e88:	ff24e5e3          	bltu	s1,s2,80005e72 <backtrace+0x32>
}
    80005e8c:	70a2                	ld	ra,40(sp)
    80005e8e:	7402                	ld	s0,32(sp)
    80005e90:	64e2                	ld	s1,24(sp)
    80005e92:	6942                	ld	s2,16(sp)
    80005e94:	69a2                	ld	s3,8(sp)
    80005e96:	6a02                	ld	s4,0(sp)
    80005e98:	6145                	addi	sp,sp,48
    80005e9a:	8082                	ret

0000000080005e9c <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e9c:	1101                	addi	sp,sp,-32
    80005e9e:	ec06                	sd	ra,24(sp)
    80005ea0:	e822                	sd	s0,16(sp)
    80005ea2:	e426                	sd	s1,8(sp)
    80005ea4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ea6:	00020497          	auipc	s1,0x20
    80005eaa:	34248493          	addi	s1,s1,834 # 800261e8 <pr>
    80005eae:	00003597          	auipc	a1,0x3
    80005eb2:	92258593          	addi	a1,a1,-1758 # 800087d0 <syscalls+0x408>
    80005eb6:	8526                	mv	a0,s1
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	26e080e7          	jalr	622(ra) # 80006126 <initlock>
  pr.locking = 1;
    80005ec0:	4785                	li	a5,1
    80005ec2:	cc9c                	sw	a5,24(s1)
}
    80005ec4:	60e2                	ld	ra,24(sp)
    80005ec6:	6442                	ld	s0,16(sp)
    80005ec8:	64a2                	ld	s1,8(sp)
    80005eca:	6105                	addi	sp,sp,32
    80005ecc:	8082                	ret

0000000080005ece <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ece:	1141                	addi	sp,sp,-16
    80005ed0:	e406                	sd	ra,8(sp)
    80005ed2:	e022                	sd	s0,0(sp)
    80005ed4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ed6:	100007b7          	lui	a5,0x10000
    80005eda:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ede:	f8000713          	li	a4,-128
    80005ee2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ee6:	470d                	li	a4,3
    80005ee8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eec:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ef0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ef4:	469d                	li	a3,7
    80005ef6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005efa:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005efe:	00003597          	auipc	a1,0x3
    80005f02:	8f258593          	addi	a1,a1,-1806 # 800087f0 <digits+0x18>
    80005f06:	00020517          	auipc	a0,0x20
    80005f0a:	30250513          	addi	a0,a0,770 # 80026208 <uart_tx_lock>
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	218080e7          	jalr	536(ra) # 80006126 <initlock>
}
    80005f16:	60a2                	ld	ra,8(sp)
    80005f18:	6402                	ld	s0,0(sp)
    80005f1a:	0141                	addi	sp,sp,16
    80005f1c:	8082                	ret

0000000080005f1e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f1e:	1101                	addi	sp,sp,-32
    80005f20:	ec06                	sd	ra,24(sp)
    80005f22:	e822                	sd	s0,16(sp)
    80005f24:	e426                	sd	s1,8(sp)
    80005f26:	1000                	addi	s0,sp,32
    80005f28:	84aa                	mv	s1,a0
  push_off();
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	240080e7          	jalr	576(ra) # 8000616a <push_off>

  if(panicked){
    80005f32:	00003797          	auipc	a5,0x3
    80005f36:	0ea7a783          	lw	a5,234(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f3a:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f3e:	c391                	beqz	a5,80005f42 <uartputc_sync+0x24>
    for(;;)
    80005f40:	a001                	j	80005f40 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f42:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f46:	0ff7f793          	andi	a5,a5,255
    80005f4a:	0207f793          	andi	a5,a5,32
    80005f4e:	dbf5                	beqz	a5,80005f42 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f50:	0ff4f793          	andi	a5,s1,255
    80005f54:	10000737          	lui	a4,0x10000
    80005f58:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	2ae080e7          	jalr	686(ra) # 8000620a <pop_off>
}
    80005f64:	60e2                	ld	ra,24(sp)
    80005f66:	6442                	ld	s0,16(sp)
    80005f68:	64a2                	ld	s1,8(sp)
    80005f6a:	6105                	addi	sp,sp,32
    80005f6c:	8082                	ret

0000000080005f6e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f6e:	00003717          	auipc	a4,0x3
    80005f72:	0b273703          	ld	a4,178(a4) # 80009020 <uart_tx_r>
    80005f76:	00003797          	auipc	a5,0x3
    80005f7a:	0b27b783          	ld	a5,178(a5) # 80009028 <uart_tx_w>
    80005f7e:	06e78c63          	beq	a5,a4,80005ff6 <uartstart+0x88>
{
    80005f82:	7139                	addi	sp,sp,-64
    80005f84:	fc06                	sd	ra,56(sp)
    80005f86:	f822                	sd	s0,48(sp)
    80005f88:	f426                	sd	s1,40(sp)
    80005f8a:	f04a                	sd	s2,32(sp)
    80005f8c:	ec4e                	sd	s3,24(sp)
    80005f8e:	e852                	sd	s4,16(sp)
    80005f90:	e456                	sd	s5,8(sp)
    80005f92:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f94:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f98:	00020a17          	auipc	s4,0x20
    80005f9c:	270a0a13          	addi	s4,s4,624 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fa0:	00003497          	auipc	s1,0x3
    80005fa4:	08048493          	addi	s1,s1,128 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fa8:	00003997          	auipc	s3,0x3
    80005fac:	08098993          	addi	s3,s3,128 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb0:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fb4:	0ff7f793          	andi	a5,a5,255
    80005fb8:	0207f793          	andi	a5,a5,32
    80005fbc:	c785                	beqz	a5,80005fe4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fbe:	01f77793          	andi	a5,a4,31
    80005fc2:	97d2                	add	a5,a5,s4
    80005fc4:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fc8:	0705                	addi	a4,a4,1
    80005fca:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fcc:	8526                	mv	a0,s1
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	6d2080e7          	jalr	1746(ra) # 800016a0 <wakeup>
    
    WriteReg(THR, c);
    80005fd6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fda:	6098                	ld	a4,0(s1)
    80005fdc:	0009b783          	ld	a5,0(s3)
    80005fe0:	fce798e3          	bne	a5,a4,80005fb0 <uartstart+0x42>
  }
}
    80005fe4:	70e2                	ld	ra,56(sp)
    80005fe6:	7442                	ld	s0,48(sp)
    80005fe8:	74a2                	ld	s1,40(sp)
    80005fea:	7902                	ld	s2,32(sp)
    80005fec:	69e2                	ld	s3,24(sp)
    80005fee:	6a42                	ld	s4,16(sp)
    80005ff0:	6aa2                	ld	s5,8(sp)
    80005ff2:	6121                	addi	sp,sp,64
    80005ff4:	8082                	ret
    80005ff6:	8082                	ret

0000000080005ff8 <uartputc>:
{
    80005ff8:	7179                	addi	sp,sp,-48
    80005ffa:	f406                	sd	ra,40(sp)
    80005ffc:	f022                	sd	s0,32(sp)
    80005ffe:	ec26                	sd	s1,24(sp)
    80006000:	e84a                	sd	s2,16(sp)
    80006002:	e44e                	sd	s3,8(sp)
    80006004:	e052                	sd	s4,0(sp)
    80006006:	1800                	addi	s0,sp,48
    80006008:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000600a:	00020517          	auipc	a0,0x20
    8000600e:	1fe50513          	addi	a0,a0,510 # 80026208 <uart_tx_lock>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	1a4080e7          	jalr	420(ra) # 800061b6 <acquire>
  if(panicked){
    8000601a:	00003797          	auipc	a5,0x3
    8000601e:	0027a783          	lw	a5,2(a5) # 8000901c <panicked>
    80006022:	c391                	beqz	a5,80006026 <uartputc+0x2e>
    for(;;)
    80006024:	a001                	j	80006024 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006026:	00003797          	auipc	a5,0x3
    8000602a:	0027b783          	ld	a5,2(a5) # 80009028 <uart_tx_w>
    8000602e:	00003717          	auipc	a4,0x3
    80006032:	ff273703          	ld	a4,-14(a4) # 80009020 <uart_tx_r>
    80006036:	02070713          	addi	a4,a4,32
    8000603a:	02f71b63          	bne	a4,a5,80006070 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000603e:	00020a17          	auipc	s4,0x20
    80006042:	1caa0a13          	addi	s4,s4,458 # 80026208 <uart_tx_lock>
    80006046:	00003497          	auipc	s1,0x3
    8000604a:	fda48493          	addi	s1,s1,-38 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604e:	00003917          	auipc	s2,0x3
    80006052:	fda90913          	addi	s2,s2,-38 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006056:	85d2                	mv	a1,s4
    80006058:	8526                	mv	a0,s1
    8000605a:	ffffb097          	auipc	ra,0xffffb
    8000605e:	4ba080e7          	jalr	1210(ra) # 80001514 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006062:	00093783          	ld	a5,0(s2)
    80006066:	6098                	ld	a4,0(s1)
    80006068:	02070713          	addi	a4,a4,32
    8000606c:	fef705e3          	beq	a4,a5,80006056 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006070:	00020497          	auipc	s1,0x20
    80006074:	19848493          	addi	s1,s1,408 # 80026208 <uart_tx_lock>
    80006078:	01f7f713          	andi	a4,a5,31
    8000607c:	9726                	add	a4,a4,s1
    8000607e:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80006082:	0785                	addi	a5,a5,1
    80006084:	00003717          	auipc	a4,0x3
    80006088:	faf73223          	sd	a5,-92(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	ee2080e7          	jalr	-286(ra) # 80005f6e <uartstart>
      release(&uart_tx_lock);
    80006094:	8526                	mv	a0,s1
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	1d4080e7          	jalr	468(ra) # 8000626a <release>
}
    8000609e:	70a2                	ld	ra,40(sp)
    800060a0:	7402                	ld	s0,32(sp)
    800060a2:	64e2                	ld	s1,24(sp)
    800060a4:	6942                	ld	s2,16(sp)
    800060a6:	69a2                	ld	s3,8(sp)
    800060a8:	6a02                	ld	s4,0(sp)
    800060aa:	6145                	addi	sp,sp,48
    800060ac:	8082                	ret

00000000800060ae <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ae:	1141                	addi	sp,sp,-16
    800060b0:	e422                	sd	s0,8(sp)
    800060b2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060b4:	100007b7          	lui	a5,0x10000
    800060b8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060bc:	8b85                	andi	a5,a5,1
    800060be:	cb91                	beqz	a5,800060d2 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060c0:	100007b7          	lui	a5,0x10000
    800060c4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060c8:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060cc:	6422                	ld	s0,8(sp)
    800060ce:	0141                	addi	sp,sp,16
    800060d0:	8082                	ret
    return -1;
    800060d2:	557d                	li	a0,-1
    800060d4:	bfe5                	j	800060cc <uartgetc+0x1e>

00000000800060d6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060d6:	1101                	addi	sp,sp,-32
    800060d8:	ec06                	sd	ra,24(sp)
    800060da:	e822                	sd	s0,16(sp)
    800060dc:	e426                	sd	s1,8(sp)
    800060de:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060e0:	54fd                	li	s1,-1
    int c = uartgetc();
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	fcc080e7          	jalr	-52(ra) # 800060ae <uartgetc>
    if(c == -1)
    800060ea:	00950763          	beq	a0,s1,800060f8 <uartintr+0x22>
      break;
    consoleintr(c);
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	89a080e7          	jalr	-1894(ra) # 80005988 <consoleintr>
  while(1){
    800060f6:	b7f5                	j	800060e2 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060f8:	00020497          	auipc	s1,0x20
    800060fc:	11048493          	addi	s1,s1,272 # 80026208 <uart_tx_lock>
    80006100:	8526                	mv	a0,s1
    80006102:	00000097          	auipc	ra,0x0
    80006106:	0b4080e7          	jalr	180(ra) # 800061b6 <acquire>
  uartstart();
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	e64080e7          	jalr	-412(ra) # 80005f6e <uartstart>
  release(&uart_tx_lock);
    80006112:	8526                	mv	a0,s1
    80006114:	00000097          	auipc	ra,0x0
    80006118:	156080e7          	jalr	342(ra) # 8000626a <release>
}
    8000611c:	60e2                	ld	ra,24(sp)
    8000611e:	6442                	ld	s0,16(sp)
    80006120:	64a2                	ld	s1,8(sp)
    80006122:	6105                	addi	sp,sp,32
    80006124:	8082                	ret

0000000080006126 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006126:	1141                	addi	sp,sp,-16
    80006128:	e422                	sd	s0,8(sp)
    8000612a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000612c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000612e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006132:	00053823          	sd	zero,16(a0)
}
    80006136:	6422                	ld	s0,8(sp)
    80006138:	0141                	addi	sp,sp,16
    8000613a:	8082                	ret

000000008000613c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000613c:	411c                	lw	a5,0(a0)
    8000613e:	e399                	bnez	a5,80006144 <holding+0x8>
    80006140:	4501                	li	a0,0
  return r;
}
    80006142:	8082                	ret
{
    80006144:	1101                	addi	sp,sp,-32
    80006146:	ec06                	sd	ra,24(sp)
    80006148:	e822                	sd	s0,16(sp)
    8000614a:	e426                	sd	s1,8(sp)
    8000614c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000614e:	6904                	ld	s1,16(a0)
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	cdc080e7          	jalr	-804(ra) # 80000e2c <mycpu>
    80006158:	40a48533          	sub	a0,s1,a0
    8000615c:	00153513          	seqz	a0,a0
}
    80006160:	60e2                	ld	ra,24(sp)
    80006162:	6442                	ld	s0,16(sp)
    80006164:	64a2                	ld	s1,8(sp)
    80006166:	6105                	addi	sp,sp,32
    80006168:	8082                	ret

000000008000616a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000616a:	1101                	addi	sp,sp,-32
    8000616c:	ec06                	sd	ra,24(sp)
    8000616e:	e822                	sd	s0,16(sp)
    80006170:	e426                	sd	s1,8(sp)
    80006172:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006174:	100024f3          	csrr	s1,sstatus
    80006178:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000617c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000617e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006182:	ffffb097          	auipc	ra,0xffffb
    80006186:	caa080e7          	jalr	-854(ra) # 80000e2c <mycpu>
    8000618a:	5d3c                	lw	a5,120(a0)
    8000618c:	cf89                	beqz	a5,800061a6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	c9e080e7          	jalr	-866(ra) # 80000e2c <mycpu>
    80006196:	5d3c                	lw	a5,120(a0)
    80006198:	2785                	addiw	a5,a5,1
    8000619a:	dd3c                	sw	a5,120(a0)
}
    8000619c:	60e2                	ld	ra,24(sp)
    8000619e:	6442                	ld	s0,16(sp)
    800061a0:	64a2                	ld	s1,8(sp)
    800061a2:	6105                	addi	sp,sp,32
    800061a4:	8082                	ret
    mycpu()->intena = old;
    800061a6:	ffffb097          	auipc	ra,0xffffb
    800061aa:	c86080e7          	jalr	-890(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ae:	8085                	srli	s1,s1,0x1
    800061b0:	8885                	andi	s1,s1,1
    800061b2:	dd64                	sw	s1,124(a0)
    800061b4:	bfe9                	j	8000618e <push_off+0x24>

00000000800061b6 <acquire>:
{
    800061b6:	1101                	addi	sp,sp,-32
    800061b8:	ec06                	sd	ra,24(sp)
    800061ba:	e822                	sd	s0,16(sp)
    800061bc:	e426                	sd	s1,8(sp)
    800061be:	1000                	addi	s0,sp,32
    800061c0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	fa8080e7          	jalr	-88(ra) # 8000616a <push_off>
  if(holding(lk))
    800061ca:	8526                	mv	a0,s1
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	f70080e7          	jalr	-144(ra) # 8000613c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d4:	4705                	li	a4,1
  if(holding(lk))
    800061d6:	e115                	bnez	a0,800061fa <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d8:	87ba                	mv	a5,a4
    800061da:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061de:	2781                	sext.w	a5,a5
    800061e0:	ffe5                	bnez	a5,800061d8 <acquire+0x22>
  __sync_synchronize();
    800061e2:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061e6:	ffffb097          	auipc	ra,0xffffb
    800061ea:	c46080e7          	jalr	-954(ra) # 80000e2c <mycpu>
    800061ee:	e888                	sd	a0,16(s1)
}
    800061f0:	60e2                	ld	ra,24(sp)
    800061f2:	6442                	ld	s0,16(sp)
    800061f4:	64a2                	ld	s1,8(sp)
    800061f6:	6105                	addi	sp,sp,32
    800061f8:	8082                	ret
    panic("acquire");
    800061fa:	00002517          	auipc	a0,0x2
    800061fe:	5fe50513          	addi	a0,a0,1534 # 800087f8 <digits+0x20>
    80006202:	00000097          	auipc	ra,0x0
    80006206:	a06080e7          	jalr	-1530(ra) # 80005c08 <panic>

000000008000620a <pop_off>:

void
pop_off(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e406                	sd	ra,8(sp)
    8000620e:	e022                	sd	s0,0(sp)
    80006210:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	c1a080e7          	jalr	-998(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000621a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000621e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006220:	e78d                	bnez	a5,8000624a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006222:	5d3c                	lw	a5,120(a0)
    80006224:	02f05b63          	blez	a5,8000625a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006228:	37fd                	addiw	a5,a5,-1
    8000622a:	0007871b          	sext.w	a4,a5
    8000622e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006230:	eb09                	bnez	a4,80006242 <pop_off+0x38>
    80006232:	5d7c                	lw	a5,124(a0)
    80006234:	c799                	beqz	a5,80006242 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006236:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000623a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000623e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006242:	60a2                	ld	ra,8(sp)
    80006244:	6402                	ld	s0,0(sp)
    80006246:	0141                	addi	sp,sp,16
    80006248:	8082                	ret
    panic("pop_off - interruptible");
    8000624a:	00002517          	auipc	a0,0x2
    8000624e:	5b650513          	addi	a0,a0,1462 # 80008800 <digits+0x28>
    80006252:	00000097          	auipc	ra,0x0
    80006256:	9b6080e7          	jalr	-1610(ra) # 80005c08 <panic>
    panic("pop_off");
    8000625a:	00002517          	auipc	a0,0x2
    8000625e:	5be50513          	addi	a0,a0,1470 # 80008818 <digits+0x40>
    80006262:	00000097          	auipc	ra,0x0
    80006266:	9a6080e7          	jalr	-1626(ra) # 80005c08 <panic>

000000008000626a <release>:
{
    8000626a:	1101                	addi	sp,sp,-32
    8000626c:	ec06                	sd	ra,24(sp)
    8000626e:	e822                	sd	s0,16(sp)
    80006270:	e426                	sd	s1,8(sp)
    80006272:	1000                	addi	s0,sp,32
    80006274:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	ec6080e7          	jalr	-314(ra) # 8000613c <holding>
    8000627e:	c115                	beqz	a0,800062a2 <release+0x38>
  lk->cpu = 0;
    80006280:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006284:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006288:	0f50000f          	fence	iorw,ow
    8000628c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006290:	00000097          	auipc	ra,0x0
    80006294:	f7a080e7          	jalr	-134(ra) # 8000620a <pop_off>
}
    80006298:	60e2                	ld	ra,24(sp)
    8000629a:	6442                	ld	s0,16(sp)
    8000629c:	64a2                	ld	s1,8(sp)
    8000629e:	6105                	addi	sp,sp,32
    800062a0:	8082                	ret
    panic("release");
    800062a2:	00002517          	auipc	a0,0x2
    800062a6:	57e50513          	addi	a0,a0,1406 # 80008820 <digits+0x48>
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	95e080e7          	jalr	-1698(ra) # 80005c08 <panic>
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
