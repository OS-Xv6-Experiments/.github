
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a3013103          	ld	sp,-1488(sp) # 80008a30 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0a3050ef          	jal	ra,800058b8 <start>

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
    8000005e:	258080e7          	jalr	600(ra) # 800062b2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2f8080e7          	jalr	760(ra) # 80006366 <release>
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
    8000008e:	cde080e7          	jalr	-802(ra) # 80005d68 <panic>

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
    800000f8:	12e080e7          	jalr	302(ra) # 80006222 <initlock>
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
    80000130:	186080e7          	jalr	390(ra) # 800062b2 <acquire>
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
    80000148:	222080e7          	jalr	546(ra) # 80006366 <release>

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
    80000172:	1f8080e7          	jalr	504(ra) # 80006366 <release>
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
    80000198:	11e080e7          	jalr	286(ra) # 800062b2 <acquire>
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
    800001ba:	1b0080e7          	jalr	432(ra) # 80006366 <release>
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
    800001d0:	ce09                	beqz	a2,800001ea <memset+0x20>
    800001d2:	87aa                	mv	a5,a0
    800001d4:	fff6071b          	addiw	a4,a2,-1
    800001d8:	1702                	slli	a4,a4,0x20
    800001da:	9301                	srli	a4,a4,0x20
    800001dc:	0705                	addi	a4,a4,1
    800001de:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001e4:	0785                	addi	a5,a5,1
    800001e6:	fee79de3          	bne	a5,a4,800001e0 <memset+0x16>
  }
  return dst;
}
    800001ea:	6422                	ld	s0,8(sp)
    800001ec:	0141                	addi	sp,sp,16
    800001ee:	8082                	ret

00000000800001f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001f0:	1141                	addi	sp,sp,-16
    800001f2:	e422                	sd	s0,8(sp)
    800001f4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001f6:	ca05                	beqz	a2,80000226 <memcmp+0x36>
    800001f8:	fff6069b          	addiw	a3,a2,-1
    800001fc:	1682                	slli	a3,a3,0x20
    800001fe:	9281                	srli	a3,a3,0x20
    80000200:	0685                	addi	a3,a3,1
    80000202:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000204:	00054783          	lbu	a5,0(a0)
    80000208:	0005c703          	lbu	a4,0(a1)
    8000020c:	00e79863          	bne	a5,a4,8000021c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000210:	0505                	addi	a0,a0,1
    80000212:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000214:	fed518e3          	bne	a0,a3,80000204 <memcmp+0x14>
  }

  return 0;
    80000218:	4501                	li	a0,0
    8000021a:	a019                	j	80000220 <memcmp+0x30>
      return *s1 - *s2;
    8000021c:	40e7853b          	subw	a0,a5,a4
}
    80000220:	6422                	ld	s0,8(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret
  return 0;
    80000226:	4501                	li	a0,0
    80000228:	bfe5                	j	80000220 <memcmp+0x30>

000000008000022a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000022a:	1141                	addi	sp,sp,-16
    8000022c:	e422                	sd	s0,8(sp)
    8000022e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000230:	ca0d                	beqz	a2,80000262 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000232:	00a5f963          	bgeu	a1,a0,80000244 <memmove+0x1a>
    80000236:	02061693          	slli	a3,a2,0x20
    8000023a:	9281                	srli	a3,a3,0x20
    8000023c:	00d58733          	add	a4,a1,a3
    80000240:	02e56463          	bltu	a0,a4,80000268 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000244:	fff6079b          	addiw	a5,a2,-1
    80000248:	1782                	slli	a5,a5,0x20
    8000024a:	9381                	srli	a5,a5,0x20
    8000024c:	0785                	addi	a5,a5,1
    8000024e:	97ae                	add	a5,a5,a1
    80000250:	872a                	mv	a4,a0
      *d++ = *s++;
    80000252:	0585                	addi	a1,a1,1
    80000254:	0705                	addi	a4,a4,1
    80000256:	fff5c683          	lbu	a3,-1(a1)
    8000025a:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
    while(n-- > 0)
    8000025e:	fef59ae3          	bne	a1,a5,80000252 <memmove+0x28>

  return dst;
}
    80000262:	6422                	ld	s0,8(sp)
    80000264:	0141                	addi	sp,sp,16
    80000266:	8082                	ret
    d += n;
    80000268:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000026a:	fff6079b          	addiw	a5,a2,-1
    8000026e:	1782                	slli	a5,a5,0x20
    80000270:	9381                	srli	a5,a5,0x20
    80000272:	fff7c793          	not	a5,a5
    80000276:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000278:	177d                	addi	a4,a4,-1
    8000027a:	16fd                	addi	a3,a3,-1
    8000027c:	00074603          	lbu	a2,0(a4)
    80000280:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000284:	fef71ae3          	bne	a4,a5,80000278 <memmove+0x4e>
    80000288:	bfe9                	j	80000262 <memmove+0x38>

000000008000028a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000292:	00000097          	auipc	ra,0x0
    80000296:	f98080e7          	jalr	-104(ra) # 8000022a <memmove>
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret

00000000800002a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002a2:	1141                	addi	sp,sp,-16
    800002a4:	e422                	sd	s0,8(sp)
    800002a6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a8:	ce11                	beqz	a2,800002c4 <strncmp+0x22>
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf89                	beqz	a5,800002c8 <strncmp+0x26>
    800002b0:	0005c703          	lbu	a4,0(a1)
    800002b4:	00f71a63          	bne	a4,a5,800002c8 <strncmp+0x26>
    n--, p++, q++;
    800002b8:	367d                	addiw	a2,a2,-1
    800002ba:	0505                	addi	a0,a0,1
    800002bc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002be:	f675                	bnez	a2,800002aa <strncmp+0x8>
  if(n == 0)
    return 0;
    800002c0:	4501                	li	a0,0
    800002c2:	a809                	j	800002d4 <strncmp+0x32>
    800002c4:	4501                	li	a0,0
    800002c6:	a039                	j	800002d4 <strncmp+0x32>
  if(n == 0)
    800002c8:	ca09                	beqz	a2,800002da <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002ca:	00054503          	lbu	a0,0(a0)
    800002ce:	0005c783          	lbu	a5,0(a1)
    800002d2:	9d1d                	subw	a0,a0,a5
}
    800002d4:	6422                	ld	s0,8(sp)
    800002d6:	0141                	addi	sp,sp,16
    800002d8:	8082                	ret
    return 0;
    800002da:	4501                	li	a0,0
    800002dc:	bfe5                	j	800002d4 <strncmp+0x32>

00000000800002de <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002de:	1141                	addi	sp,sp,-16
    800002e0:	e422                	sd	s0,8(sp)
    800002e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002e4:	872a                	mv	a4,a0
    800002e6:	8832                	mv	a6,a2
    800002e8:	367d                	addiw	a2,a2,-1
    800002ea:	01005963          	blez	a6,800002fc <strncpy+0x1e>
    800002ee:	0705                	addi	a4,a4,1
    800002f0:	0005c783          	lbu	a5,0(a1)
    800002f4:	fef70fa3          	sb	a5,-1(a4)
    800002f8:	0585                	addi	a1,a1,1
    800002fa:	f7f5                	bnez	a5,800002e6 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002fc:	00c05d63          	blez	a2,80000316 <strncpy+0x38>
    80000300:	86ba                	mv	a3,a4
    *s++ = 0;
    80000302:	0685                	addi	a3,a3,1
    80000304:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000308:	fff6c793          	not	a5,a3
    8000030c:	9fb9                	addw	a5,a5,a4
    8000030e:	010787bb          	addw	a5,a5,a6
    80000312:	fef048e3          	bgtz	a5,80000302 <strncpy+0x24>
  return os;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret

000000008000031c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000031c:	1141                	addi	sp,sp,-16
    8000031e:	e422                	sd	s0,8(sp)
    80000320:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000322:	02c05363          	blez	a2,80000348 <safestrcpy+0x2c>
    80000326:	fff6069b          	addiw	a3,a2,-1
    8000032a:	1682                	slli	a3,a3,0x20
    8000032c:	9281                	srli	a3,a3,0x20
    8000032e:	96ae                	add	a3,a3,a1
    80000330:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000332:	00d58963          	beq	a1,a3,80000344 <safestrcpy+0x28>
    80000336:	0585                	addi	a1,a1,1
    80000338:	0785                	addi	a5,a5,1
    8000033a:	fff5c703          	lbu	a4,-1(a1)
    8000033e:	fee78fa3          	sb	a4,-1(a5)
    80000342:	fb65                	bnez	a4,80000332 <safestrcpy+0x16>
    ;
  *s = 0;
    80000344:	00078023          	sb	zero,0(a5)
  return os;
}
    80000348:	6422                	ld	s0,8(sp)
    8000034a:	0141                	addi	sp,sp,16
    8000034c:	8082                	ret

000000008000034e <strlen>:

int
strlen(const char *s)
{
    8000034e:	1141                	addi	sp,sp,-16
    80000350:	e422                	sd	s0,8(sp)
    80000352:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000354:	00054783          	lbu	a5,0(a0)
    80000358:	cf91                	beqz	a5,80000374 <strlen+0x26>
    8000035a:	0505                	addi	a0,a0,1
    8000035c:	87aa                	mv	a5,a0
    8000035e:	4685                	li	a3,1
    80000360:	9e89                	subw	a3,a3,a0
    80000362:	00f6853b          	addw	a0,a3,a5
    80000366:	0785                	addi	a5,a5,1
    80000368:	fff7c703          	lbu	a4,-1(a5)
    8000036c:	fb7d                	bnez	a4,80000362 <strlen+0x14>
    ;
  return n;
}
    8000036e:	6422                	ld	s0,8(sp)
    80000370:	0141                	addi	sp,sp,16
    80000372:	8082                	ret
  for(n = 0; s[n]; n++)
    80000374:	4501                	li	a0,0
    80000376:	bfe5                	j	8000036e <strlen+0x20>

0000000080000378 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000378:	1141                	addi	sp,sp,-16
    8000037a:	e406                	sd	ra,8(sp)
    8000037c:	e022                	sd	s0,0(sp)
    8000037e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000380:	00001097          	auipc	ra,0x1
    80000384:	bea080e7          	jalr	-1046(ra) # 80000f6a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000388:	00009717          	auipc	a4,0x9
    8000038c:	c7870713          	addi	a4,a4,-904 # 80009000 <started>
  if(cpuid() == 0){
    80000390:	c139                	beqz	a0,800003d6 <main+0x5e>
    while(started == 0)
    80000392:	431c                	lw	a5,0(a4)
    80000394:	2781                	sext.w	a5,a5
    80000396:	dff5                	beqz	a5,80000392 <main+0x1a>
      ;
    __sync_synchronize();
    80000398:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000039c:	00001097          	auipc	ra,0x1
    800003a0:	bce080e7          	jalr	-1074(ra) # 80000f6a <cpuid>
    800003a4:	85aa                	mv	a1,a0
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c9250513          	addi	a0,a0,-878 # 80008038 <etext+0x38>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a04080e7          	jalr	-1532(ra) # 80005db2 <printf>
    kvminithart();    // turn on paging
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	0d8080e7          	jalr	216(ra) # 8000048e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003be:	00002097          	auipc	ra,0x2
    800003c2:	862080e7          	jalr	-1950(ra) # 80001c20 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	e7a080e7          	jalr	-390(ra) # 80005240 <plicinithart>
  }

  scheduler();        
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	0da080e7          	jalr	218(ra) # 800014a8 <scheduler>
    consoleinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	8a4080e7          	jalr	-1884(ra) # 80005c7a <consoleinit>
    printfinit();
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	bba080e7          	jalr	-1094(ra) # 80005f98 <printfinit>
    printf("\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c6250513          	addi	a0,a0,-926 # 80008048 <etext+0x48>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	9c4080e7          	jalr	-1596(ra) # 80005db2 <printf>
    printf("xv6 kernel is booting\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c2a50513          	addi	a0,a0,-982 # 80008020 <etext+0x20>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	9b4080e7          	jalr	-1612(ra) # 80005db2 <printf>
    printf("\n");
    80000406:	00008517          	auipc	a0,0x8
    8000040a:	c4250513          	addi	a0,a0,-958 # 80008048 <etext+0x48>
    8000040e:	00006097          	auipc	ra,0x6
    80000412:	9a4080e7          	jalr	-1628(ra) # 80005db2 <printf>
    kinit();         // physical page allocator
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	cc6080e7          	jalr	-826(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	322080e7          	jalr	802(ra) # 80000740 <kvminit>
    kvminithart();   // turn on paging
    80000426:	00000097          	auipc	ra,0x0
    8000042a:	068080e7          	jalr	104(ra) # 8000048e <kvminithart>
    procinit();      // process table
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	a8c080e7          	jalr	-1396(ra) # 80000eba <procinit>
    trapinit();      // trap vectors
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	7c2080e7          	jalr	1986(ra) # 80001bf8 <trapinit>
    trapinithart();  // install kernel trap vector
    8000043e:	00001097          	auipc	ra,0x1
    80000442:	7e2080e7          	jalr	2018(ra) # 80001c20 <trapinithart>
    plicinit();      // set up interrupt controller
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	de4080e7          	jalr	-540(ra) # 8000522a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000044e:	00005097          	auipc	ra,0x5
    80000452:	df2080e7          	jalr	-526(ra) # 80005240 <plicinithart>
    binit();         // buffer cache
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	fbe080e7          	jalr	-66(ra) # 80002414 <binit>
    iinit();         // inode table
    8000045e:	00002097          	auipc	ra,0x2
    80000462:	64e080e7          	jalr	1614(ra) # 80002aac <iinit>
    fileinit();      // file table
    80000466:	00003097          	auipc	ra,0x3
    8000046a:	5f8080e7          	jalr	1528(ra) # 80003a5e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000046e:	00005097          	auipc	ra,0x5
    80000472:	ef4080e7          	jalr	-268(ra) # 80005362 <virtio_disk_init>
    userinit();      // first user process
    80000476:	00001097          	auipc	ra,0x1
    8000047a:	df8080e7          	jalr	-520(ra) # 8000126e <userinit>
    __sync_synchronize();
    8000047e:	0ff0000f          	fence
    started = 1;
    80000482:	4785                	li	a5,1
    80000484:	00009717          	auipc	a4,0x9
    80000488:	b6f72e23          	sw	a5,-1156(a4) # 80009000 <started>
    8000048c:	b789                	j	800003ce <main+0x56>

000000008000048e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000048e:	1141                	addi	sp,sp,-16
    80000490:	e422                	sd	s0,8(sp)
    80000492:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000494:	00009797          	auipc	a5,0x9
    80000498:	b747b783          	ld	a5,-1164(a5) # 80009008 <kernel_pagetable>
    8000049c:	83b1                	srli	a5,a5,0xc
    8000049e:	577d                	li	a4,-1
    800004a0:	177e                	slli	a4,a4,0x3f
    800004a2:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800004a4:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a8:	12000073          	sfence.vma
  sfence_vma();
}
    800004ac:	6422                	ld	s0,8(sp)
    800004ae:	0141                	addi	sp,sp,16
    800004b0:	8082                	ret

00000000800004b2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004b2:	7139                	addi	sp,sp,-64
    800004b4:	fc06                	sd	ra,56(sp)
    800004b6:	f822                	sd	s0,48(sp)
    800004b8:	f426                	sd	s1,40(sp)
    800004ba:	f04a                	sd	s2,32(sp)
    800004bc:	ec4e                	sd	s3,24(sp)
    800004be:	e852                	sd	s4,16(sp)
    800004c0:	e456                	sd	s5,8(sp)
    800004c2:	e05a                	sd	s6,0(sp)
    800004c4:	0080                	addi	s0,sp,64
    800004c6:	84aa                	mv	s1,a0
    800004c8:	89ae                	mv	s3,a1
    800004ca:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004cc:	57fd                	li	a5,-1
    800004ce:	83e9                	srli	a5,a5,0x1a
    800004d0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004d2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004d4:	04b7f263          	bgeu	a5,a1,80000518 <walk+0x66>
    panic("walk");
    800004d8:	00008517          	auipc	a0,0x8
    800004dc:	b7850513          	addi	a0,a0,-1160 # 80008050 <etext+0x50>
    800004e0:	00006097          	auipc	ra,0x6
    800004e4:	888080e7          	jalr	-1912(ra) # 80005d68 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e8:	060a8663          	beqz	s5,80000554 <walk+0xa2>
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	c2c080e7          	jalr	-980(ra) # 80000118 <kalloc>
    800004f4:	84aa                	mv	s1,a0
    800004f6:	c529                	beqz	a0,80000540 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f8:	6605                	lui	a2,0x1
    800004fa:	4581                	li	a1,0
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	cce080e7          	jalr	-818(ra) # 800001ca <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000504:	00c4d793          	srli	a5,s1,0xc
    80000508:	07aa                	slli	a5,a5,0xa
    8000050a:	0017e793          	ori	a5,a5,1
    8000050e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000512:	3a5d                	addiw	s4,s4,-9
    80000514:	036a0063          	beq	s4,s6,80000534 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000518:	0149d933          	srl	s2,s3,s4
    8000051c:	1ff97913          	andi	s2,s2,511
    80000520:	090e                	slli	s2,s2,0x3
    80000522:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000524:	00093483          	ld	s1,0(s2)
    80000528:	0014f793          	andi	a5,s1,1
    8000052c:	dfd5                	beqz	a5,800004e8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000052e:	80a9                	srli	s1,s1,0xa
    80000530:	04b2                	slli	s1,s1,0xc
    80000532:	b7c5                	j	80000512 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000534:	00c9d513          	srli	a0,s3,0xc
    80000538:	1ff57513          	andi	a0,a0,511
    8000053c:	050e                	slli	a0,a0,0x3
    8000053e:	9526                	add	a0,a0,s1
}
    80000540:	70e2                	ld	ra,56(sp)
    80000542:	7442                	ld	s0,48(sp)
    80000544:	74a2                	ld	s1,40(sp)
    80000546:	7902                	ld	s2,32(sp)
    80000548:	69e2                	ld	s3,24(sp)
    8000054a:	6a42                	ld	s4,16(sp)
    8000054c:	6aa2                	ld	s5,8(sp)
    8000054e:	6b02                	ld	s6,0(sp)
    80000550:	6121                	addi	sp,sp,64
    80000552:	8082                	ret
        return 0;
    80000554:	4501                	li	a0,0
    80000556:	b7ed                	j	80000540 <walk+0x8e>

0000000080000558 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000558:	57fd                	li	a5,-1
    8000055a:	83e9                	srli	a5,a5,0x1a
    8000055c:	00b7f463          	bgeu	a5,a1,80000564 <walkaddr+0xc>
    return 0;
    80000560:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000562:	8082                	ret
{
    80000564:	1141                	addi	sp,sp,-16
    80000566:	e406                	sd	ra,8(sp)
    80000568:	e022                	sd	s0,0(sp)
    8000056a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000056c:	4601                	li	a2,0
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	f44080e7          	jalr	-188(ra) # 800004b2 <walk>
  if(pte == 0)
    80000576:	c105                	beqz	a0,80000596 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000578:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000057a:	0117f693          	andi	a3,a5,17
    8000057e:	4745                	li	a4,17
    return 0;
    80000580:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000582:	00e68663          	beq	a3,a4,8000058e <walkaddr+0x36>
}
    80000586:	60a2                	ld	ra,8(sp)
    80000588:	6402                	ld	s0,0(sp)
    8000058a:	0141                	addi	sp,sp,16
    8000058c:	8082                	ret
  pa = PTE2PA(*pte);
    8000058e:	00a7d513          	srli	a0,a5,0xa
    80000592:	0532                	slli	a0,a0,0xc
  return pa;
    80000594:	bfcd                	j	80000586 <walkaddr+0x2e>
    return 0;
    80000596:	4501                	li	a0,0
    80000598:	b7fd                	j	80000586 <walkaddr+0x2e>

000000008000059a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000059a:	715d                	addi	sp,sp,-80
    8000059c:	e486                	sd	ra,72(sp)
    8000059e:	e0a2                	sd	s0,64(sp)
    800005a0:	fc26                	sd	s1,56(sp)
    800005a2:	f84a                	sd	s2,48(sp)
    800005a4:	f44e                	sd	s3,40(sp)
    800005a6:	f052                	sd	s4,32(sp)
    800005a8:	ec56                	sd	s5,24(sp)
    800005aa:	e85a                	sd	s6,16(sp)
    800005ac:	e45e                	sd	s7,8(sp)
    800005ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005b0:	c205                	beqz	a2,800005d0 <mappages+0x36>
    800005b2:	8aaa                	mv	s5,a0
    800005b4:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005b6:	77fd                	lui	a5,0xfffff
    800005b8:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005bc:	15fd                	addi	a1,a1,-1
    800005be:	00c589b3          	add	s3,a1,a2
    800005c2:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005c6:	8952                	mv	s2,s4
    800005c8:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005cc:	6b85                	lui	s7,0x1
    800005ce:	a015                	j	800005f2 <mappages+0x58>
    panic("mappages: size");
    800005d0:	00008517          	auipc	a0,0x8
    800005d4:	a8850513          	addi	a0,a0,-1400 # 80008058 <etext+0x58>
    800005d8:	00005097          	auipc	ra,0x5
    800005dc:	790080e7          	jalr	1936(ra) # 80005d68 <panic>
      panic("mappages: remap");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a8850513          	addi	a0,a0,-1400 # 80008068 <etext+0x68>
    800005e8:	00005097          	auipc	ra,0x5
    800005ec:	780080e7          	jalr	1920(ra) # 80005d68 <panic>
    a += PGSIZE;
    800005f0:	995e                	add	s2,s2,s7
  for(;;){
    800005f2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f6:	4605                	li	a2,1
    800005f8:	85ca                	mv	a1,s2
    800005fa:	8556                	mv	a0,s5
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	eb6080e7          	jalr	-330(ra) # 800004b2 <walk>
    80000604:	cd19                	beqz	a0,80000622 <mappages+0x88>
    if(*pte & PTE_V)
    80000606:	611c                	ld	a5,0(a0)
    80000608:	8b85                	andi	a5,a5,1
    8000060a:	fbf9                	bnez	a5,800005e0 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000060c:	80b1                	srli	s1,s1,0xc
    8000060e:	04aa                	slli	s1,s1,0xa
    80000610:	0164e4b3          	or	s1,s1,s6
    80000614:	0014e493          	ori	s1,s1,1
    80000618:	e104                	sd	s1,0(a0)
    if(a == last)
    8000061a:	fd391be3          	bne	s2,s3,800005f0 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000061e:	4501                	li	a0,0
    80000620:	a011                	j	80000624 <mappages+0x8a>
      return -1;
    80000622:	557d                	li	a0,-1
}
    80000624:	60a6                	ld	ra,72(sp)
    80000626:	6406                	ld	s0,64(sp)
    80000628:	74e2                	ld	s1,56(sp)
    8000062a:	7942                	ld	s2,48(sp)
    8000062c:	79a2                	ld	s3,40(sp)
    8000062e:	7a02                	ld	s4,32(sp)
    80000630:	6ae2                	ld	s5,24(sp)
    80000632:	6b42                	ld	s6,16(sp)
    80000634:	6ba2                	ld	s7,8(sp)
    80000636:	6161                	addi	sp,sp,80
    80000638:	8082                	ret

000000008000063a <kvmmap>:
{
    8000063a:	1141                	addi	sp,sp,-16
    8000063c:	e406                	sd	ra,8(sp)
    8000063e:	e022                	sd	s0,0(sp)
    80000640:	0800                	addi	s0,sp,16
    80000642:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000644:	86b2                	mv	a3,a2
    80000646:	863e                	mv	a2,a5
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	f52080e7          	jalr	-174(ra) # 8000059a <mappages>
    80000650:	e509                	bnez	a0,8000065a <kvmmap+0x20>
}
    80000652:	60a2                	ld	ra,8(sp)
    80000654:	6402                	ld	s0,0(sp)
    80000656:	0141                	addi	sp,sp,16
    80000658:	8082                	ret
    panic("kvmmap");
    8000065a:	00008517          	auipc	a0,0x8
    8000065e:	a1e50513          	addi	a0,a0,-1506 # 80008078 <etext+0x78>
    80000662:	00005097          	auipc	ra,0x5
    80000666:	706080e7          	jalr	1798(ra) # 80005d68 <panic>

000000008000066a <kvmmake>:
{
    8000066a:	1101                	addi	sp,sp,-32
    8000066c:	ec06                	sd	ra,24(sp)
    8000066e:	e822                	sd	s0,16(sp)
    80000670:	e426                	sd	s1,8(sp)
    80000672:	e04a                	sd	s2,0(sp)
    80000674:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	aa2080e7          	jalr	-1374(ra) # 80000118 <kalloc>
    8000067e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000680:	6605                	lui	a2,0x1
    80000682:	4581                	li	a1,0
    80000684:	00000097          	auipc	ra,0x0
    80000688:	b46080e7          	jalr	-1210(ra) # 800001ca <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10000637          	lui	a2,0x10000
    80000694:	100005b7          	lui	a1,0x10000
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	fa0080e7          	jalr	-96(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	6685                	lui	a3,0x1
    800006a6:	10001637          	lui	a2,0x10001
    800006aa:	100015b7          	lui	a1,0x10001
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f8a080e7          	jalr	-118(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b8:	4719                	li	a4,6
    800006ba:	004006b7          	lui	a3,0x400
    800006be:	0c000637          	lui	a2,0xc000
    800006c2:	0c0005b7          	lui	a1,0xc000
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f72080e7          	jalr	-142(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006d0:	00008917          	auipc	s2,0x8
    800006d4:	93090913          	addi	s2,s2,-1744 # 80008000 <etext>
    800006d8:	4729                	li	a4,10
    800006da:	80008697          	auipc	a3,0x80008
    800006de:	92668693          	addi	a3,a3,-1754 # 8000 <_entry-0x7fff8000>
    800006e2:	4605                	li	a2,1
    800006e4:	067e                	slli	a2,a2,0x1f
    800006e6:	85b2                	mv	a1,a2
    800006e8:	8526                	mv	a0,s1
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f50080e7          	jalr	-176(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006f2:	4719                	li	a4,6
    800006f4:	46c5                	li	a3,17
    800006f6:	06ee                	slli	a3,a3,0x1b
    800006f8:	412686b3          	sub	a3,a3,s2
    800006fc:	864a                	mv	a2,s2
    800006fe:	85ca                	mv	a1,s2
    80000700:	8526                	mv	a0,s1
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f38080e7          	jalr	-200(ra) # 8000063a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000070a:	4729                	li	a4,10
    8000070c:	6685                	lui	a3,0x1
    8000070e:	00007617          	auipc	a2,0x7
    80000712:	8f260613          	addi	a2,a2,-1806 # 80007000 <_trampoline>
    80000716:	040005b7          	lui	a1,0x4000
    8000071a:	15fd                	addi	a1,a1,-1
    8000071c:	05b2                	slli	a1,a1,0xc
    8000071e:	8526                	mv	a0,s1
    80000720:	00000097          	auipc	ra,0x0
    80000724:	f1a080e7          	jalr	-230(ra) # 8000063a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	6fa080e7          	jalr	1786(ra) # 80000e24 <proc_mapstacks>
}
    80000732:	8526                	mv	a0,s1
    80000734:	60e2                	ld	ra,24(sp)
    80000736:	6442                	ld	s0,16(sp)
    80000738:	64a2                	ld	s1,8(sp)
    8000073a:	6902                	ld	s2,0(sp)
    8000073c:	6105                	addi	sp,sp,32
    8000073e:	8082                	ret

0000000080000740 <kvminit>:
{
    80000740:	1141                	addi	sp,sp,-16
    80000742:	e406                	sd	ra,8(sp)
    80000744:	e022                	sd	s0,0(sp)
    80000746:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	f22080e7          	jalr	-222(ra) # 8000066a <kvmmake>
    80000750:	00009797          	auipc	a5,0x9
    80000754:	8aa7bc23          	sd	a0,-1864(a5) # 80009008 <kernel_pagetable>
}
    80000758:	60a2                	ld	ra,8(sp)
    8000075a:	6402                	ld	s0,0(sp)
    8000075c:	0141                	addi	sp,sp,16
    8000075e:	8082                	ret

0000000080000760 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000760:	715d                	addi	sp,sp,-80
    80000762:	e486                	sd	ra,72(sp)
    80000764:	e0a2                	sd	s0,64(sp)
    80000766:	fc26                	sd	s1,56(sp)
    80000768:	f84a                	sd	s2,48(sp)
    8000076a:	f44e                	sd	s3,40(sp)
    8000076c:	f052                	sd	s4,32(sp)
    8000076e:	ec56                	sd	s5,24(sp)
    80000770:	e85a                	sd	s6,16(sp)
    80000772:	e45e                	sd	s7,8(sp)
    80000774:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000776:	03459793          	slli	a5,a1,0x34
    8000077a:	e795                	bnez	a5,800007a6 <uvmunmap+0x46>
    8000077c:	8a2a                	mv	s4,a0
    8000077e:	892e                	mv	s2,a1
    80000780:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	0632                	slli	a2,a2,0xc
    80000784:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000788:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000078a:	6b05                	lui	s6,0x1
    8000078c:	0735e863          	bltu	a1,s3,800007fc <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000790:	60a6                	ld	ra,72(sp)
    80000792:	6406                	ld	s0,64(sp)
    80000794:	74e2                	ld	s1,56(sp)
    80000796:	7942                	ld	s2,48(sp)
    80000798:	79a2                	ld	s3,40(sp)
    8000079a:	7a02                	ld	s4,32(sp)
    8000079c:	6ae2                	ld	s5,24(sp)
    8000079e:	6b42                	ld	s6,16(sp)
    800007a0:	6ba2                	ld	s7,8(sp)
    800007a2:	6161                	addi	sp,sp,80
    800007a4:	8082                	ret
    panic("uvmunmap: not aligned");
    800007a6:	00008517          	auipc	a0,0x8
    800007aa:	8da50513          	addi	a0,a0,-1830 # 80008080 <etext+0x80>
    800007ae:	00005097          	auipc	ra,0x5
    800007b2:	5ba080e7          	jalr	1466(ra) # 80005d68 <panic>
      panic("uvmunmap: walk");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	8e250513          	addi	a0,a0,-1822 # 80008098 <etext+0x98>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	5aa080e7          	jalr	1450(ra) # 80005d68 <panic>
      panic("uvmunmap: not mapped");
    800007c6:	00008517          	auipc	a0,0x8
    800007ca:	8e250513          	addi	a0,a0,-1822 # 800080a8 <etext+0xa8>
    800007ce:	00005097          	auipc	ra,0x5
    800007d2:	59a080e7          	jalr	1434(ra) # 80005d68 <panic>
      panic("uvmunmap: not a leaf");
    800007d6:	00008517          	auipc	a0,0x8
    800007da:	8ea50513          	addi	a0,a0,-1814 # 800080c0 <etext+0xc0>
    800007de:	00005097          	auipc	ra,0x5
    800007e2:	58a080e7          	jalr	1418(ra) # 80005d68 <panic>
      uint64 pa = PTE2PA(*pte);
    800007e6:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e8:	0532                	slli	a0,a0,0xc
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	832080e7          	jalr	-1998(ra) # 8000001c <kfree>
    *pte = 0;
    800007f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f6:	995a                	add	s2,s2,s6
    800007f8:	f9397ce3          	bgeu	s2,s3,80000790 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fc:	4601                	li	a2,0
    800007fe:	85ca                	mv	a1,s2
    80000800:	8552                	mv	a0,s4
    80000802:	00000097          	auipc	ra,0x0
    80000806:	cb0080e7          	jalr	-848(ra) # 800004b2 <walk>
    8000080a:	84aa                	mv	s1,a0
    8000080c:	d54d                	beqz	a0,800007b6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000080e:	6108                	ld	a0,0(a0)
    80000810:	00157793          	andi	a5,a0,1
    80000814:	dbcd                	beqz	a5,800007c6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000816:	3ff57793          	andi	a5,a0,1023
    8000081a:	fb778ee3          	beq	a5,s7,800007d6 <uvmunmap+0x76>
    if(do_free){
    8000081e:	fc0a8ae3          	beqz	s5,800007f2 <uvmunmap+0x92>
    80000822:	b7d1                	j	800007e6 <uvmunmap+0x86>

0000000080000824 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	8ea080e7          	jalr	-1814(ra) # 80000118 <kalloc>
    80000836:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000838:	c519                	beqz	a0,80000846 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	98c080e7          	jalr	-1652(ra) # 800001ca <memset>
  return pagetable;
}
    80000846:	8526                	mv	a0,s1
    80000848:	60e2                	ld	ra,24(sp)
    8000084a:	6442                	ld	s0,16(sp)
    8000084c:	64a2                	ld	s1,8(sp)
    8000084e:	6105                	addi	sp,sp,32
    80000850:	8082                	ret

0000000080000852 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000852:	7179                	addi	sp,sp,-48
    80000854:	f406                	sd	ra,40(sp)
    80000856:	f022                	sd	s0,32(sp)
    80000858:	ec26                	sd	s1,24(sp)
    8000085a:	e84a                	sd	s2,16(sp)
    8000085c:	e44e                	sd	s3,8(sp)
    8000085e:	e052                	sd	s4,0(sp)
    80000860:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000862:	6785                	lui	a5,0x1
    80000864:	04f67863          	bgeu	a2,a5,800008b4 <uvminit+0x62>
    80000868:	8a2a                	mv	s4,a0
    8000086a:	89ae                	mv	s3,a1
    8000086c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	8aa080e7          	jalr	-1878(ra) # 80000118 <kalloc>
    80000876:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000878:	6605                	lui	a2,0x1
    8000087a:	4581                	li	a1,0
    8000087c:	00000097          	auipc	ra,0x0
    80000880:	94e080e7          	jalr	-1714(ra) # 800001ca <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000884:	4779                	li	a4,30
    80000886:	86ca                	mv	a3,s2
    80000888:	6605                	lui	a2,0x1
    8000088a:	4581                	li	a1,0
    8000088c:	8552                	mv	a0,s4
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	d0c080e7          	jalr	-756(ra) # 8000059a <mappages>
  memmove(mem, src, sz);
    80000896:	8626                	mv	a2,s1
    80000898:	85ce                	mv	a1,s3
    8000089a:	854a                	mv	a0,s2
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	98e080e7          	jalr	-1650(ra) # 8000022a <memmove>
}
    800008a4:	70a2                	ld	ra,40(sp)
    800008a6:	7402                	ld	s0,32(sp)
    800008a8:	64e2                	ld	s1,24(sp)
    800008aa:	6942                	ld	s2,16(sp)
    800008ac:	69a2                	ld	s3,8(sp)
    800008ae:	6a02                	ld	s4,0(sp)
    800008b0:	6145                	addi	sp,sp,48
    800008b2:	8082                	ret
    panic("inituvm: more than a page");
    800008b4:	00008517          	auipc	a0,0x8
    800008b8:	82450513          	addi	a0,a0,-2012 # 800080d8 <etext+0xd8>
    800008bc:	00005097          	auipc	ra,0x5
    800008c0:	4ac080e7          	jalr	1196(ra) # 80005d68 <panic>

00000000800008c4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c4:	1101                	addi	sp,sp,-32
    800008c6:	ec06                	sd	ra,24(sp)
    800008c8:	e822                	sd	s0,16(sp)
    800008ca:	e426                	sd	s1,8(sp)
    800008cc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008ce:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d0:	00b67d63          	bgeu	a2,a1,800008ea <uvmdealloc+0x26>
    800008d4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d6:	6785                	lui	a5,0x1
    800008d8:	17fd                	addi	a5,a5,-1
    800008da:	00f60733          	add	a4,a2,a5
    800008de:	767d                	lui	a2,0xfffff
    800008e0:	8f71                	and	a4,a4,a2
    800008e2:	97ae                	add	a5,a5,a1
    800008e4:	8ff1                	and	a5,a5,a2
    800008e6:	00f76863          	bltu	a4,a5,800008f6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ea:	8526                	mv	a0,s1
    800008ec:	60e2                	ld	ra,24(sp)
    800008ee:	6442                	ld	s0,16(sp)
    800008f0:	64a2                	ld	s1,8(sp)
    800008f2:	6105                	addi	sp,sp,32
    800008f4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f6:	8f99                	sub	a5,a5,a4
    800008f8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008fa:	4685                	li	a3,1
    800008fc:	0007861b          	sext.w	a2,a5
    80000900:	85ba                	mv	a1,a4
    80000902:	00000097          	auipc	ra,0x0
    80000906:	e5e080e7          	jalr	-418(ra) # 80000760 <uvmunmap>
    8000090a:	b7c5                	j	800008ea <uvmdealloc+0x26>

000000008000090c <uvmalloc>:
  if(newsz < oldsz)
    8000090c:	0ab66163          	bltu	a2,a1,800009ae <uvmalloc+0xa2>
{
    80000910:	7139                	addi	sp,sp,-64
    80000912:	fc06                	sd	ra,56(sp)
    80000914:	f822                	sd	s0,48(sp)
    80000916:	f426                	sd	s1,40(sp)
    80000918:	f04a                	sd	s2,32(sp)
    8000091a:	ec4e                	sd	s3,24(sp)
    8000091c:	e852                	sd	s4,16(sp)
    8000091e:	e456                	sd	s5,8(sp)
    80000920:	0080                	addi	s0,sp,64
    80000922:	8aaa                	mv	s5,a0
    80000924:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000926:	6985                	lui	s3,0x1
    80000928:	19fd                	addi	s3,s3,-1
    8000092a:	95ce                	add	a1,a1,s3
    8000092c:	79fd                	lui	s3,0xfffff
    8000092e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000932:	08c9f063          	bgeu	s3,a2,800009b2 <uvmalloc+0xa6>
    80000936:	894e                	mv	s2,s3
    mem = kalloc();
    80000938:	fffff097          	auipc	ra,0xfffff
    8000093c:	7e0080e7          	jalr	2016(ra) # 80000118 <kalloc>
    80000940:	84aa                	mv	s1,a0
    if(mem == 0){
    80000942:	c51d                	beqz	a0,80000970 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	4581                	li	a1,0
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	882080e7          	jalr	-1918(ra) # 800001ca <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000950:	4779                	li	a4,30
    80000952:	86a6                	mv	a3,s1
    80000954:	6605                	lui	a2,0x1
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	c40080e7          	jalr	-960(ra) # 8000059a <mappages>
    80000962:	e905                	bnez	a0,80000992 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000964:	6785                	lui	a5,0x1
    80000966:	993e                	add	s2,s2,a5
    80000968:	fd4968e3          	bltu	s2,s4,80000938 <uvmalloc+0x2c>
  return newsz;
    8000096c:	8552                	mv	a0,s4
    8000096e:	a809                	j	80000980 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000970:	864e                	mv	a2,s3
    80000972:	85ca                	mv	a1,s2
    80000974:	8556                	mv	a0,s5
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	f4e080e7          	jalr	-178(ra) # 800008c4 <uvmdealloc>
      return 0;
    8000097e:	4501                	li	a0,0
}
    80000980:	70e2                	ld	ra,56(sp)
    80000982:	7442                	ld	s0,48(sp)
    80000984:	74a2                	ld	s1,40(sp)
    80000986:	7902                	ld	s2,32(sp)
    80000988:	69e2                	ld	s3,24(sp)
    8000098a:	6a42                	ld	s4,16(sp)
    8000098c:	6aa2                	ld	s5,8(sp)
    8000098e:	6121                	addi	sp,sp,64
    80000990:	8082                	ret
      kfree(mem);
    80000992:	8526                	mv	a0,s1
    80000994:	fffff097          	auipc	ra,0xfffff
    80000998:	688080e7          	jalr	1672(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099c:	864e                	mv	a2,s3
    8000099e:	85ca                	mv	a1,s2
    800009a0:	8556                	mv	a0,s5
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	f22080e7          	jalr	-222(ra) # 800008c4 <uvmdealloc>
      return 0;
    800009aa:	4501                	li	a0,0
    800009ac:	bfd1                	j	80000980 <uvmalloc+0x74>
    return oldsz;
    800009ae:	852e                	mv	a0,a1
}
    800009b0:	8082                	ret
  return newsz;
    800009b2:	8532                	mv	a0,a2
    800009b4:	b7f1                	j	80000980 <uvmalloc+0x74>

00000000800009b6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b6:	7179                	addi	sp,sp,-48
    800009b8:	f406                	sd	ra,40(sp)
    800009ba:	f022                	sd	s0,32(sp)
    800009bc:	ec26                	sd	s1,24(sp)
    800009be:	e84a                	sd	s2,16(sp)
    800009c0:	e44e                	sd	s3,8(sp)
    800009c2:	e052                	sd	s4,0(sp)
    800009c4:	1800                	addi	s0,sp,48
    800009c6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c8:	84aa                	mv	s1,a0
    800009ca:	6905                	lui	s2,0x1
    800009cc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ce:	4985                	li	s3,1
    800009d0:	a821                	j	800009e8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009d4:	0532                	slli	a0,a0,0xc
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	fe0080e7          	jalr	-32(ra) # 800009b6 <freewalk>
      pagetable[i] = 0;
    800009de:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e2:	04a1                	addi	s1,s1,8
    800009e4:	03248163          	beq	s1,s2,80000a06 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ea:	00f57793          	andi	a5,a0,15
    800009ee:	ff3782e3          	beq	a5,s3,800009d2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f2:	8905                	andi	a0,a0,1
    800009f4:	d57d                	beqz	a0,800009e2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009f6:	00007517          	auipc	a0,0x7
    800009fa:	70250513          	addi	a0,a0,1794 # 800080f8 <etext+0xf8>
    800009fe:	00005097          	auipc	ra,0x5
    80000a02:	36a080e7          	jalr	874(ra) # 80005d68 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a06:	8552                	mv	a0,s4
    80000a08:	fffff097          	auipc	ra,0xfffff
    80000a0c:	614080e7          	jalr	1556(ra) # 8000001c <kfree>
}
    80000a10:	70a2                	ld	ra,40(sp)
    80000a12:	7402                	ld	s0,32(sp)
    80000a14:	64e2                	ld	s1,24(sp)
    80000a16:	6942                	ld	s2,16(sp)
    80000a18:	69a2                	ld	s3,8(sp)
    80000a1a:	6a02                	ld	s4,0(sp)
    80000a1c:	6145                	addi	sp,sp,48
    80000a1e:	8082                	ret

0000000080000a20 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a20:	1101                	addi	sp,sp,-32
    80000a22:	ec06                	sd	ra,24(sp)
    80000a24:	e822                	sd	s0,16(sp)
    80000a26:	e426                	sd	s1,8(sp)
    80000a28:	1000                	addi	s0,sp,32
    80000a2a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a2c:	e999                	bnez	a1,80000a42 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a2e:	8526                	mv	a0,s1
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	f86080e7          	jalr	-122(ra) # 800009b6 <freewalk>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a42:	6605                	lui	a2,0x1
    80000a44:	167d                	addi	a2,a2,-1
    80000a46:	962e                	add	a2,a2,a1
    80000a48:	4685                	li	a3,1
    80000a4a:	8231                	srli	a2,a2,0xc
    80000a4c:	4581                	li	a1,0
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	d12080e7          	jalr	-750(ra) # 80000760 <uvmunmap>
    80000a56:	bfe1                	j	80000a2e <uvmfree+0xe>

0000000080000a58 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a58:	c679                	beqz	a2,80000b26 <uvmcopy+0xce>
{
    80000a5a:	715d                	addi	sp,sp,-80
    80000a5c:	e486                	sd	ra,72(sp)
    80000a5e:	e0a2                	sd	s0,64(sp)
    80000a60:	fc26                	sd	s1,56(sp)
    80000a62:	f84a                	sd	s2,48(sp)
    80000a64:	f44e                	sd	s3,40(sp)
    80000a66:	f052                	sd	s4,32(sp)
    80000a68:	ec56                	sd	s5,24(sp)
    80000a6a:	e85a                	sd	s6,16(sp)
    80000a6c:	e45e                	sd	s7,8(sp)
    80000a6e:	0880                	addi	s0,sp,80
    80000a70:	8b2a                	mv	s6,a0
    80000a72:	8aae                	mv	s5,a1
    80000a74:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a78:	4601                	li	a2,0
    80000a7a:	85ce                	mv	a1,s3
    80000a7c:	855a                	mv	a0,s6
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	a34080e7          	jalr	-1484(ra) # 800004b2 <walk>
    80000a86:	c531                	beqz	a0,80000ad2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a88:	6118                	ld	a4,0(a0)
    80000a8a:	00177793          	andi	a5,a4,1
    80000a8e:	cbb1                	beqz	a5,80000ae2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a90:	00a75593          	srli	a1,a4,0xa
    80000a94:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a98:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	67c080e7          	jalr	1660(ra) # 80000118 <kalloc>
    80000aa4:	892a                	mv	s2,a0
    80000aa6:	c939                	beqz	a0,80000afc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85de                	mv	a1,s7
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	77e080e7          	jalr	1918(ra) # 8000022a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab4:	8726                	mv	a4,s1
    80000ab6:	86ca                	mv	a3,s2
    80000ab8:	6605                	lui	a2,0x1
    80000aba:	85ce                	mv	a1,s3
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	adc080e7          	jalr	-1316(ra) # 8000059a <mappages>
    80000ac6:	e515                	bnez	a0,80000af2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac8:	6785                	lui	a5,0x1
    80000aca:	99be                	add	s3,s3,a5
    80000acc:	fb49e6e3          	bltu	s3,s4,80000a78 <uvmcopy+0x20>
    80000ad0:	a081                	j	80000b10 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	63650513          	addi	a0,a0,1590 # 80008108 <etext+0x108>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	28e080e7          	jalr	654(ra) # 80005d68 <panic>
      panic("uvmcopy: page not present");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	64650513          	addi	a0,a0,1606 # 80008128 <etext+0x128>
    80000aea:	00005097          	auipc	ra,0x5
    80000aee:	27e080e7          	jalr	638(ra) # 80005d68 <panic>
      kfree(mem);
    80000af2:	854a                	mv	a0,s2
    80000af4:	fffff097          	auipc	ra,0xfffff
    80000af8:	528080e7          	jalr	1320(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000afc:	4685                	li	a3,1
    80000afe:	00c9d613          	srli	a2,s3,0xc
    80000b02:	4581                	li	a1,0
    80000b04:	8556                	mv	a0,s5
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	c5a080e7          	jalr	-934(ra) # 80000760 <uvmunmap>
  return -1;
    80000b0e:	557d                	li	a0,-1
}
    80000b10:	60a6                	ld	ra,72(sp)
    80000b12:	6406                	ld	s0,64(sp)
    80000b14:	74e2                	ld	s1,56(sp)
    80000b16:	7942                	ld	s2,48(sp)
    80000b18:	79a2                	ld	s3,40(sp)
    80000b1a:	7a02                	ld	s4,32(sp)
    80000b1c:	6ae2                	ld	s5,24(sp)
    80000b1e:	6b42                	ld	s6,16(sp)
    80000b20:	6ba2                	ld	s7,8(sp)
    80000b22:	6161                	addi	sp,sp,80
    80000b24:	8082                	ret
  return 0;
    80000b26:	4501                	li	a0,0
}
    80000b28:	8082                	ret

0000000080000b2a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2a:	1141                	addi	sp,sp,-16
    80000b2c:	e406                	sd	ra,8(sp)
    80000b2e:	e022                	sd	s0,0(sp)
    80000b30:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b32:	4601                	li	a2,0
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	97e080e7          	jalr	-1666(ra) # 800004b2 <walk>
  if(pte == 0)
    80000b3c:	c901                	beqz	a0,80000b4c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b3e:	611c                	ld	a5,0(a0)
    80000b40:	9bbd                	andi	a5,a5,-17
    80000b42:	e11c                	sd	a5,0(a0)
}
    80000b44:	60a2                	ld	ra,8(sp)
    80000b46:	6402                	ld	s0,0(sp)
    80000b48:	0141                	addi	sp,sp,16
    80000b4a:	8082                	ret
    panic("uvmclear");
    80000b4c:	00007517          	auipc	a0,0x7
    80000b50:	5fc50513          	addi	a0,a0,1532 # 80008148 <etext+0x148>
    80000b54:	00005097          	auipc	ra,0x5
    80000b58:	214080e7          	jalr	532(ra) # 80005d68 <panic>

0000000080000b5c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b5c:	c6bd                	beqz	a3,80000bca <copyout+0x6e>
{
    80000b5e:	715d                	addi	sp,sp,-80
    80000b60:	e486                	sd	ra,72(sp)
    80000b62:	e0a2                	sd	s0,64(sp)
    80000b64:	fc26                	sd	s1,56(sp)
    80000b66:	f84a                	sd	s2,48(sp)
    80000b68:	f44e                	sd	s3,40(sp)
    80000b6a:	f052                	sd	s4,32(sp)
    80000b6c:	ec56                	sd	s5,24(sp)
    80000b6e:	e85a                	sd	s6,16(sp)
    80000b70:	e45e                	sd	s7,8(sp)
    80000b72:	e062                	sd	s8,0(sp)
    80000b74:	0880                	addi	s0,sp,80
    80000b76:	8b2a                	mv	s6,a0
    80000b78:	8c2e                	mv	s8,a1
    80000b7a:	8a32                	mv	s4,a2
    80000b7c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b7e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b80:	6a85                	lui	s5,0x1
    80000b82:	a015                	j	80000ba6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b84:	9562                	add	a0,a0,s8
    80000b86:	0004861b          	sext.w	a2,s1
    80000b8a:	85d2                	mv	a1,s4
    80000b8c:	41250533          	sub	a0,a0,s2
    80000b90:	fffff097          	auipc	ra,0xfffff
    80000b94:	69a080e7          	jalr	1690(ra) # 8000022a <memmove>

    len -= n;
    80000b98:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b9c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b9e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba2:	02098263          	beqz	s3,80000bc6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ba6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000baa:	85ca                	mv	a1,s2
    80000bac:	855a                	mv	a0,s6
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	9aa080e7          	jalr	-1622(ra) # 80000558 <walkaddr>
    if(pa0 == 0)
    80000bb6:	cd01                	beqz	a0,80000bce <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb8:	418904b3          	sub	s1,s2,s8
    80000bbc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bbe:	fc99f3e3          	bgeu	s3,s1,80000b84 <copyout+0x28>
    80000bc2:	84ce                	mv	s1,s3
    80000bc4:	b7c1                	j	80000b84 <copyout+0x28>
  }
  return 0;
    80000bc6:	4501                	li	a0,0
    80000bc8:	a021                	j	80000bd0 <copyout+0x74>
    80000bca:	4501                	li	a0,0
}
    80000bcc:	8082                	ret
      return -1;
    80000bce:	557d                	li	a0,-1
}
    80000bd0:	60a6                	ld	ra,72(sp)
    80000bd2:	6406                	ld	s0,64(sp)
    80000bd4:	74e2                	ld	s1,56(sp)
    80000bd6:	7942                	ld	s2,48(sp)
    80000bd8:	79a2                	ld	s3,40(sp)
    80000bda:	7a02                	ld	s4,32(sp)
    80000bdc:	6ae2                	ld	s5,24(sp)
    80000bde:	6b42                	ld	s6,16(sp)
    80000be0:	6ba2                	ld	s7,8(sp)
    80000be2:	6c02                	ld	s8,0(sp)
    80000be4:	6161                	addi	sp,sp,80
    80000be6:	8082                	ret

0000000080000be8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be8:	c6bd                	beqz	a3,80000c56 <copyin+0x6e>
{
    80000bea:	715d                	addi	sp,sp,-80
    80000bec:	e486                	sd	ra,72(sp)
    80000bee:	e0a2                	sd	s0,64(sp)
    80000bf0:	fc26                	sd	s1,56(sp)
    80000bf2:	f84a                	sd	s2,48(sp)
    80000bf4:	f44e                	sd	s3,40(sp)
    80000bf6:	f052                	sd	s4,32(sp)
    80000bf8:	ec56                	sd	s5,24(sp)
    80000bfa:	e85a                	sd	s6,16(sp)
    80000bfc:	e45e                	sd	s7,8(sp)
    80000bfe:	e062                	sd	s8,0(sp)
    80000c00:	0880                	addi	s0,sp,80
    80000c02:	8b2a                	mv	s6,a0
    80000c04:	8a2e                	mv	s4,a1
    80000c06:	8c32                	mv	s8,a2
    80000c08:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c0a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c0c:	6a85                	lui	s5,0x1
    80000c0e:	a015                	j	80000c32 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c10:	9562                	add	a0,a0,s8
    80000c12:	0004861b          	sext.w	a2,s1
    80000c16:	412505b3          	sub	a1,a0,s2
    80000c1a:	8552                	mv	a0,s4
    80000c1c:	fffff097          	auipc	ra,0xfffff
    80000c20:	60e080e7          	jalr	1550(ra) # 8000022a <memmove>

    len -= n;
    80000c24:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c28:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c2a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c2e:	02098263          	beqz	s3,80000c52 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c32:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c36:	85ca                	mv	a1,s2
    80000c38:	855a                	mv	a0,s6
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	91e080e7          	jalr	-1762(ra) # 80000558 <walkaddr>
    if(pa0 == 0)
    80000c42:	cd01                	beqz	a0,80000c5a <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c44:	418904b3          	sub	s1,s2,s8
    80000c48:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c4a:	fc99f3e3          	bgeu	s3,s1,80000c10 <copyin+0x28>
    80000c4e:	84ce                	mv	s1,s3
    80000c50:	b7c1                	j	80000c10 <copyin+0x28>
  }
  return 0;
    80000c52:	4501                	li	a0,0
    80000c54:	a021                	j	80000c5c <copyin+0x74>
    80000c56:	4501                	li	a0,0
}
    80000c58:	8082                	ret
      return -1;
    80000c5a:	557d                	li	a0,-1
}
    80000c5c:	60a6                	ld	ra,72(sp)
    80000c5e:	6406                	ld	s0,64(sp)
    80000c60:	74e2                	ld	s1,56(sp)
    80000c62:	7942                	ld	s2,48(sp)
    80000c64:	79a2                	ld	s3,40(sp)
    80000c66:	7a02                	ld	s4,32(sp)
    80000c68:	6ae2                	ld	s5,24(sp)
    80000c6a:	6b42                	ld	s6,16(sp)
    80000c6c:	6ba2                	ld	s7,8(sp)
    80000c6e:	6c02                	ld	s8,0(sp)
    80000c70:	6161                	addi	sp,sp,80
    80000c72:	8082                	ret

0000000080000c74 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c74:	c6c5                	beqz	a3,80000d1c <copyinstr+0xa8>
{
    80000c76:	715d                	addi	sp,sp,-80
    80000c78:	e486                	sd	ra,72(sp)
    80000c7a:	e0a2                	sd	s0,64(sp)
    80000c7c:	fc26                	sd	s1,56(sp)
    80000c7e:	f84a                	sd	s2,48(sp)
    80000c80:	f44e                	sd	s3,40(sp)
    80000c82:	f052                	sd	s4,32(sp)
    80000c84:	ec56                	sd	s5,24(sp)
    80000c86:	e85a                	sd	s6,16(sp)
    80000c88:	e45e                	sd	s7,8(sp)
    80000c8a:	0880                	addi	s0,sp,80
    80000c8c:	8a2a                	mv	s4,a0
    80000c8e:	8b2e                	mv	s6,a1
    80000c90:	8bb2                	mv	s7,a2
    80000c92:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c94:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c96:	6985                	lui	s3,0x1
    80000c98:	a035                	j	80000cc4 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c9a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c9e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca0:	0017b793          	seqz	a5,a5
    80000ca4:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca8:	60a6                	ld	ra,72(sp)
    80000caa:	6406                	ld	s0,64(sp)
    80000cac:	74e2                	ld	s1,56(sp)
    80000cae:	7942                	ld	s2,48(sp)
    80000cb0:	79a2                	ld	s3,40(sp)
    80000cb2:	7a02                	ld	s4,32(sp)
    80000cb4:	6ae2                	ld	s5,24(sp)
    80000cb6:	6b42                	ld	s6,16(sp)
    80000cb8:	6ba2                	ld	s7,8(sp)
    80000cba:	6161                	addi	sp,sp,80
    80000cbc:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cbe:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cc2:	c8a9                	beqz	s1,80000d14 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cc4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc8:	85ca                	mv	a1,s2
    80000cca:	8552                	mv	a0,s4
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	88c080e7          	jalr	-1908(ra) # 80000558 <walkaddr>
    if(pa0 == 0)
    80000cd4:	c131                	beqz	a0,80000d18 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cd6:	41790833          	sub	a6,s2,s7
    80000cda:	984e                	add	a6,a6,s3
    if(n > max)
    80000cdc:	0104f363          	bgeu	s1,a6,80000ce2 <copyinstr+0x6e>
    80000ce0:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ce2:	955e                	add	a0,a0,s7
    80000ce4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce8:	fc080be3          	beqz	a6,80000cbe <copyinstr+0x4a>
    80000cec:	985a                	add	a6,a6,s6
    80000cee:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cf0:	41650633          	sub	a2,a0,s6
    80000cf4:	14fd                	addi	s1,s1,-1
    80000cf6:	9b26                	add	s6,s6,s1
    80000cf8:	00f60733          	add	a4,a2,a5
    80000cfc:	00074703          	lbu	a4,0(a4)
    80000d00:	df49                	beqz	a4,80000c9a <copyinstr+0x26>
        *dst = *p;
    80000d02:	00e78023          	sb	a4,0(a5)
      --max;
    80000d06:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d0a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d0c:	ff0796e3          	bne	a5,a6,80000cf8 <copyinstr+0x84>
      dst++;
    80000d10:	8b42                	mv	s6,a6
    80000d12:	b775                	j	80000cbe <copyinstr+0x4a>
    80000d14:	4781                	li	a5,0
    80000d16:	b769                	j	80000ca0 <copyinstr+0x2c>
      return -1;
    80000d18:	557d                	li	a0,-1
    80000d1a:	b779                	j	80000ca8 <copyinstr+0x34>
  int got_null = 0;
    80000d1c:	4781                	li	a5,0
  if(got_null){
    80000d1e:	0017b793          	seqz	a5,a5
    80000d22:	40f00533          	neg	a0,a5
}
    80000d26:	8082                	ret

0000000080000d28 <_vmprint>:

void 
_vmprint(pagetable_t pagetable, int level) {
    80000d28:	7159                	addi	sp,sp,-112
    80000d2a:	f486                	sd	ra,104(sp)
    80000d2c:	f0a2                	sd	s0,96(sp)
    80000d2e:	eca6                	sd	s1,88(sp)
    80000d30:	e8ca                	sd	s2,80(sp)
    80000d32:	e4ce                	sd	s3,72(sp)
    80000d34:	e0d2                	sd	s4,64(sp)
    80000d36:	fc56                	sd	s5,56(sp)
    80000d38:	f85a                	sd	s6,48(sp)
    80000d3a:	f45e                	sd	s7,40(sp)
    80000d3c:	f062                	sd	s8,32(sp)
    80000d3e:	ec66                	sd	s9,24(sp)
    80000d40:	e86a                	sd	s10,16(sp)
    80000d42:	e46e                	sd	s11,8(sp)
    80000d44:	1880                	addi	s0,sp,112
    80000d46:	8aae                	mv	s5,a1
  for (int i = 0; i < 512; i++) {
    80000d48:	8a2a                	mv	s4,a0
    80000d4a:	4981                	li	s3,0
        }
        else {
          printf(" ..");
        }
      }
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000d4c:	00007d17          	auipc	s10,0x7
    80000d50:	41cd0d13          	addi	s10,s10,1052 # 80008168 <etext+0x168>
      // 第三级页表存放的是物理地址，页表中页表项中W位，R位，X位起码有一位会被设置为1。如果是索引页表则这些值是0
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
        _vmprint((pagetable_t)child, level + 1);// 还没到第三级，继续递归。
    80000d54:	00158d9b          	addiw	s11,a1,1
          printf(" ..");
    80000d58:	00007b17          	auipc	s6,0x7
    80000d5c:	408b0b13          	addi	s6,s6,1032 # 80008160 <etext+0x160>
          printf("..");//第一个..前面不打印空格
    80000d60:	00007c97          	auipc	s9,0x7
    80000d64:	3f8c8c93          	addi	s9,s9,1016 # 80008158 <etext+0x158>
  for (int i = 0; i < 512; i++) {
    80000d68:	20000c13          	li	s8,512
    80000d6c:	a081                	j	80000dac <_vmprint+0x84>
          printf("..");//第一个..前面不打印空格
    80000d6e:	8566                	mv	a0,s9
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	042080e7          	jalr	66(ra) # 80005db2 <printf>
      for (int j = 0; j < level; j++) {
    80000d78:	2485                	addiw	s1,s1,1
    80000d7a:	009a8963          	beq	s5,s1,80000d8c <_vmprint+0x64>
        if (j == 0) {
    80000d7e:	d8e5                	beqz	s1,80000d6e <_vmprint+0x46>
          printf(" ..");
    80000d80:	855a                	mv	a0,s6
    80000d82:	00005097          	auipc	ra,0x5
    80000d86:	030080e7          	jalr	48(ra) # 80005db2 <printf>
    80000d8a:	b7fd                	j	80000d78 <_vmprint+0x50>
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000d8c:	86de                	mv	a3,s7
    80000d8e:	864a                	mv	a2,s2
    80000d90:	85ce                	mv	a1,s3
    80000d92:	856a                	mv	a0,s10
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	01e080e7          	jalr	30(ra) # 80005db2 <printf>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d9c:	00e97913          	andi	s2,s2,14
    80000da0:	02090263          	beqz	s2,80000dc4 <_vmprint+0x9c>
  for (int i = 0; i < 512; i++) {
    80000da4:	2985                	addiw	s3,s3,1
    80000da6:	0a21                	addi	s4,s4,8
    80000da8:	03898563          	beq	s3,s8,80000dd2 <_vmprint+0xaa>
    pte_t pte = pagetable[i];
    80000dac:	000a3903          	ld	s2,0(s4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    if (pte & PTE_V) {
    80000db0:	00197793          	andi	a5,s2,1
    80000db4:	dbe5                	beqz	a5,80000da4 <_vmprint+0x7c>
      uint64 child = PTE2PA(pte);
    80000db6:	00a95b93          	srli	s7,s2,0xa
    80000dba:	0bb2                	slli	s7,s7,0xc
      for (int j = 0; j < level; j++) {
    80000dbc:	fd5058e3          	blez	s5,80000d8c <_vmprint+0x64>
    80000dc0:	4481                	li	s1,0
    80000dc2:	bf75                	j	80000d7e <_vmprint+0x56>
        _vmprint((pagetable_t)child, level + 1);// 还没到第三级，继续递归。
    80000dc4:	85ee                	mv	a1,s11
    80000dc6:	855e                	mv	a0,s7
    80000dc8:	00000097          	auipc	ra,0x0
    80000dcc:	f60080e7          	jalr	-160(ra) # 80000d28 <_vmprint>
    80000dd0:	bfd1                	j	80000da4 <_vmprint+0x7c>
      }

    }
  }
}
    80000dd2:	70a6                	ld	ra,104(sp)
    80000dd4:	7406                	ld	s0,96(sp)
    80000dd6:	64e6                	ld	s1,88(sp)
    80000dd8:	6946                	ld	s2,80(sp)
    80000dda:	69a6                	ld	s3,72(sp)
    80000ddc:	6a06                	ld	s4,64(sp)
    80000dde:	7ae2                	ld	s5,56(sp)
    80000de0:	7b42                	ld	s6,48(sp)
    80000de2:	7ba2                	ld	s7,40(sp)
    80000de4:	7c02                	ld	s8,32(sp)
    80000de6:	6ce2                	ld	s9,24(sp)
    80000de8:	6d42                	ld	s10,16(sp)
    80000dea:	6da2                	ld	s11,8(sp)
    80000dec:	6165                	addi	sp,sp,112
    80000dee:	8082                	ret

0000000080000df0 <vmprint>:

void
vmprint(pagetable_t pagetable) {
    80000df0:	1101                	addi	sp,sp,-32
    80000df2:	ec06                	sd	ra,24(sp)
    80000df4:	e822                	sd	s0,16(sp)
    80000df6:	e426                	sd	s1,8(sp)
    80000df8:	1000                	addi	s0,sp,32
    80000dfa:	84aa                	mv	s1,a0
  // 打印根页表
  printf("page table %p\n", pagetable);
    80000dfc:	85aa                	mv	a1,a0
    80000dfe:	00007517          	auipc	a0,0x7
    80000e02:	38250513          	addi	a0,a0,898 # 80008180 <etext+0x180>
    80000e06:	00005097          	auipc	ra,0x5
    80000e0a:	fac080e7          	jalr	-84(ra) # 80005db2 <printf>
  // 重新写个函数是为了传递level级和递归
  _vmprint(pagetable, 1);
    80000e0e:	4585                	li	a1,1
    80000e10:	8526                	mv	a0,s1
    80000e12:	00000097          	auipc	ra,0x0
    80000e16:	f16080e7          	jalr	-234(ra) # 80000d28 <_vmprint>
}
    80000e1a:	60e2                	ld	ra,24(sp)
    80000e1c:	6442                	ld	s0,16(sp)
    80000e1e:	64a2                	ld	s1,8(sp)
    80000e20:	6105                	addi	sp,sp,32
    80000e22:	8082                	ret

0000000080000e24 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e24:	7139                	addi	sp,sp,-64
    80000e26:	fc06                	sd	ra,56(sp)
    80000e28:	f822                	sd	s0,48(sp)
    80000e2a:	f426                	sd	s1,40(sp)
    80000e2c:	f04a                	sd	s2,32(sp)
    80000e2e:	ec4e                	sd	s3,24(sp)
    80000e30:	e852                	sd	s4,16(sp)
    80000e32:	e456                	sd	s5,8(sp)
    80000e34:	e05a                	sd	s6,0(sp)
    80000e36:	0080                	addi	s0,sp,64
    80000e38:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3a:	00008497          	auipc	s1,0x8
    80000e3e:	64648493          	addi	s1,s1,1606 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e42:	8b26                	mv	s6,s1
    80000e44:	00007a97          	auipc	s5,0x7
    80000e48:	1bca8a93          	addi	s5,s5,444 # 80008000 <etext>
    80000e4c:	04000937          	lui	s2,0x4000
    80000e50:	197d                	addi	s2,s2,-1
    80000e52:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	0000ea17          	auipc	s4,0xe
    80000e58:	02ca0a13          	addi	s4,s4,44 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000e5c:	fffff097          	auipc	ra,0xfffff
    80000e60:	2bc080e7          	jalr	700(ra) # 80000118 <kalloc>
    80000e64:	862a                	mv	a2,a0
    if(pa == 0)
    80000e66:	c131                	beqz	a0,80000eaa <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e68:	416485b3          	sub	a1,s1,s6
    80000e6c:	858d                	srai	a1,a1,0x3
    80000e6e:	000ab783          	ld	a5,0(s5)
    80000e72:	02f585b3          	mul	a1,a1,a5
    80000e76:	2585                	addiw	a1,a1,1
    80000e78:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e7c:	4719                	li	a4,6
    80000e7e:	6685                	lui	a3,0x1
    80000e80:	40b905b3          	sub	a1,s2,a1
    80000e84:	854e                	mv	a0,s3
    80000e86:	fffff097          	auipc	ra,0xfffff
    80000e8a:	7b4080e7          	jalr	1972(ra) # 8000063a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8e:	16848493          	addi	s1,s1,360
    80000e92:	fd4495e3          	bne	s1,s4,80000e5c <proc_mapstacks+0x38>
  }
}
    80000e96:	70e2                	ld	ra,56(sp)
    80000e98:	7442                	ld	s0,48(sp)
    80000e9a:	74a2                	ld	s1,40(sp)
    80000e9c:	7902                	ld	s2,32(sp)
    80000e9e:	69e2                	ld	s3,24(sp)
    80000ea0:	6a42                	ld	s4,16(sp)
    80000ea2:	6aa2                	ld	s5,8(sp)
    80000ea4:	6b02                	ld	s6,0(sp)
    80000ea6:	6121                	addi	sp,sp,64
    80000ea8:	8082                	ret
      panic("kalloc");
    80000eaa:	00007517          	auipc	a0,0x7
    80000eae:	2e650513          	addi	a0,a0,742 # 80008190 <etext+0x190>
    80000eb2:	00005097          	auipc	ra,0x5
    80000eb6:	eb6080e7          	jalr	-330(ra) # 80005d68 <panic>

0000000080000eba <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000eba:	7139                	addi	sp,sp,-64
    80000ebc:	fc06                	sd	ra,56(sp)
    80000ebe:	f822                	sd	s0,48(sp)
    80000ec0:	f426                	sd	s1,40(sp)
    80000ec2:	f04a                	sd	s2,32(sp)
    80000ec4:	ec4e                	sd	s3,24(sp)
    80000ec6:	e852                	sd	s4,16(sp)
    80000ec8:	e456                	sd	s5,8(sp)
    80000eca:	e05a                	sd	s6,0(sp)
    80000ecc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ece:	00007597          	auipc	a1,0x7
    80000ed2:	2ca58593          	addi	a1,a1,714 # 80008198 <etext+0x198>
    80000ed6:	00008517          	auipc	a0,0x8
    80000eda:	17a50513          	addi	a0,a0,378 # 80009050 <pid_lock>
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	344080e7          	jalr	836(ra) # 80006222 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ee6:	00007597          	auipc	a1,0x7
    80000eea:	2ba58593          	addi	a1,a1,698 # 800081a0 <etext+0x1a0>
    80000eee:	00008517          	auipc	a0,0x8
    80000ef2:	17a50513          	addi	a0,a0,378 # 80009068 <wait_lock>
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	32c080e7          	jalr	812(ra) # 80006222 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efe:	00008497          	auipc	s1,0x8
    80000f02:	58248493          	addi	s1,s1,1410 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000f06:	00007b17          	auipc	s6,0x7
    80000f0a:	2aab0b13          	addi	s6,s6,682 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000f0e:	8aa6                	mv	s5,s1
    80000f10:	00007a17          	auipc	s4,0x7
    80000f14:	0f0a0a13          	addi	s4,s4,240 # 80008000 <etext>
    80000f18:	04000937          	lui	s2,0x4000
    80000f1c:	197d                	addi	s2,s2,-1
    80000f1e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f20:	0000e997          	auipc	s3,0xe
    80000f24:	f6098993          	addi	s3,s3,-160 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000f28:	85da                	mv	a1,s6
    80000f2a:	8526                	mv	a0,s1
    80000f2c:	00005097          	auipc	ra,0x5
    80000f30:	2f6080e7          	jalr	758(ra) # 80006222 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f34:	415487b3          	sub	a5,s1,s5
    80000f38:	878d                	srai	a5,a5,0x3
    80000f3a:	000a3703          	ld	a4,0(s4)
    80000f3e:	02e787b3          	mul	a5,a5,a4
    80000f42:	2785                	addiw	a5,a5,1
    80000f44:	00d7979b          	slliw	a5,a5,0xd
    80000f48:	40f907b3          	sub	a5,s2,a5
    80000f4c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4e:	16848493          	addi	s1,s1,360
    80000f52:	fd349be3          	bne	s1,s3,80000f28 <procinit+0x6e>
  }
}
    80000f56:	70e2                	ld	ra,56(sp)
    80000f58:	7442                	ld	s0,48(sp)
    80000f5a:	74a2                	ld	s1,40(sp)
    80000f5c:	7902                	ld	s2,32(sp)
    80000f5e:	69e2                	ld	s3,24(sp)
    80000f60:	6a42                	ld	s4,16(sp)
    80000f62:	6aa2                	ld	s5,8(sp)
    80000f64:	6b02                	ld	s6,0(sp)
    80000f66:	6121                	addi	sp,sp,64
    80000f68:	8082                	ret

0000000080000f6a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f6a:	1141                	addi	sp,sp,-16
    80000f6c:	e422                	sd	s0,8(sp)
    80000f6e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f70:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f72:	2501                	sext.w	a0,a0
    80000f74:	6422                	ld	s0,8(sp)
    80000f76:	0141                	addi	sp,sp,16
    80000f78:	8082                	ret

0000000080000f7a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f7a:	1141                	addi	sp,sp,-16
    80000f7c:	e422                	sd	s0,8(sp)
    80000f7e:	0800                	addi	s0,sp,16
    80000f80:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f82:	2781                	sext.w	a5,a5
    80000f84:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f86:	00008517          	auipc	a0,0x8
    80000f8a:	0fa50513          	addi	a0,a0,250 # 80009080 <cpus>
    80000f8e:	953e                	add	a0,a0,a5
    80000f90:	6422                	ld	s0,8(sp)
    80000f92:	0141                	addi	sp,sp,16
    80000f94:	8082                	ret

0000000080000f96 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f96:	1101                	addi	sp,sp,-32
    80000f98:	ec06                	sd	ra,24(sp)
    80000f9a:	e822                	sd	s0,16(sp)
    80000f9c:	e426                	sd	s1,8(sp)
    80000f9e:	1000                	addi	s0,sp,32
  push_off();
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	2c6080e7          	jalr	710(ra) # 80006266 <push_off>
    80000fa8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000faa:	2781                	sext.w	a5,a5
    80000fac:	079e                	slli	a5,a5,0x7
    80000fae:	00008717          	auipc	a4,0x8
    80000fb2:	0a270713          	addi	a4,a4,162 # 80009050 <pid_lock>
    80000fb6:	97ba                	add	a5,a5,a4
    80000fb8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	34c080e7          	jalr	844(ra) # 80006306 <pop_off>
  return p;
}
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	60e2                	ld	ra,24(sp)
    80000fc6:	6442                	ld	s0,16(sp)
    80000fc8:	64a2                	ld	s1,8(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret

0000000080000fce <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fce:	1141                	addi	sp,sp,-16
    80000fd0:	e406                	sd	ra,8(sp)
    80000fd2:	e022                	sd	s0,0(sp)
    80000fd4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fd6:	00000097          	auipc	ra,0x0
    80000fda:	fc0080e7          	jalr	-64(ra) # 80000f96 <myproc>
    80000fde:	00005097          	auipc	ra,0x5
    80000fe2:	388080e7          	jalr	904(ra) # 80006366 <release>

  if (first) {
    80000fe6:	00008797          	auipc	a5,0x8
    80000fea:	9fa7a783          	lw	a5,-1542(a5) # 800089e0 <first.1679>
    80000fee:	eb89                	bnez	a5,80001000 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ff0:	00001097          	auipc	ra,0x1
    80000ff4:	c48080e7          	jalr	-952(ra) # 80001c38 <usertrapret>
}
    80000ff8:	60a2                	ld	ra,8(sp)
    80000ffa:	6402                	ld	s0,0(sp)
    80000ffc:	0141                	addi	sp,sp,16
    80000ffe:	8082                	ret
    first = 0;
    80001000:	00008797          	auipc	a5,0x8
    80001004:	9e07a023          	sw	zero,-1568(a5) # 800089e0 <first.1679>
    fsinit(ROOTDEV);
    80001008:	4505                	li	a0,1
    8000100a:	00002097          	auipc	ra,0x2
    8000100e:	a22080e7          	jalr	-1502(ra) # 80002a2c <fsinit>
    80001012:	bff9                	j	80000ff0 <forkret+0x22>

0000000080001014 <allocpid>:
allocpid() {
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	e04a                	sd	s2,0(sp)
    8000101e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001020:	00008917          	auipc	s2,0x8
    80001024:	03090913          	addi	s2,s2,48 # 80009050 <pid_lock>
    80001028:	854a                	mv	a0,s2
    8000102a:	00005097          	auipc	ra,0x5
    8000102e:	288080e7          	jalr	648(ra) # 800062b2 <acquire>
  pid = nextpid;
    80001032:	00008797          	auipc	a5,0x8
    80001036:	9b278793          	addi	a5,a5,-1614 # 800089e4 <nextpid>
    8000103a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000103c:	0014871b          	addiw	a4,s1,1
    80001040:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001042:	854a                	mv	a0,s2
    80001044:	00005097          	auipc	ra,0x5
    80001048:	322080e7          	jalr	802(ra) # 80006366 <release>
}
    8000104c:	8526                	mv	a0,s1
    8000104e:	60e2                	ld	ra,24(sp)
    80001050:	6442                	ld	s0,16(sp)
    80001052:	64a2                	ld	s1,8(sp)
    80001054:	6902                	ld	s2,0(sp)
    80001056:	6105                	addi	sp,sp,32
    80001058:	8082                	ret

000000008000105a <proc_pagetable>:
{
    8000105a:	1101                	addi	sp,sp,-32
    8000105c:	ec06                	sd	ra,24(sp)
    8000105e:	e822                	sd	s0,16(sp)
    80001060:	e426                	sd	s1,8(sp)
    80001062:	e04a                	sd	s2,0(sp)
    80001064:	1000                	addi	s0,sp,32
    80001066:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	7bc080e7          	jalr	1980(ra) # 80000824 <uvmcreate>
    80001070:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001072:	c121                	beqz	a0,800010b2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001074:	4729                	li	a4,10
    80001076:	00006697          	auipc	a3,0x6
    8000107a:	f8a68693          	addi	a3,a3,-118 # 80007000 <_trampoline>
    8000107e:	6605                	lui	a2,0x1
    80001080:	040005b7          	lui	a1,0x4000
    80001084:	15fd                	addi	a1,a1,-1
    80001086:	05b2                	slli	a1,a1,0xc
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	512080e7          	jalr	1298(ra) # 8000059a <mappages>
    80001090:	02054863          	bltz	a0,800010c0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001094:	4719                	li	a4,6
    80001096:	05893683          	ld	a3,88(s2)
    8000109a:	6605                	lui	a2,0x1
    8000109c:	020005b7          	lui	a1,0x2000
    800010a0:	15fd                	addi	a1,a1,-1
    800010a2:	05b6                	slli	a1,a1,0xd
    800010a4:	8526                	mv	a0,s1
    800010a6:	fffff097          	auipc	ra,0xfffff
    800010aa:	4f4080e7          	jalr	1268(ra) # 8000059a <mappages>
    800010ae:	02054163          	bltz	a0,800010d0 <proc_pagetable+0x76>
}
    800010b2:	8526                	mv	a0,s1
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6902                	ld	s2,0(sp)
    800010bc:	6105                	addi	sp,sp,32
    800010be:	8082                	ret
    uvmfree(pagetable, 0);
    800010c0:	4581                	li	a1,0
    800010c2:	8526                	mv	a0,s1
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	95c080e7          	jalr	-1700(ra) # 80000a20 <uvmfree>
    return 0;
    800010cc:	4481                	li	s1,0
    800010ce:	b7d5                	j	800010b2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d0:	4681                	li	a3,0
    800010d2:	4605                	li	a2,1
    800010d4:	040005b7          	lui	a1,0x4000
    800010d8:	15fd                	addi	a1,a1,-1
    800010da:	05b2                	slli	a1,a1,0xc
    800010dc:	8526                	mv	a0,s1
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	682080e7          	jalr	1666(ra) # 80000760 <uvmunmap>
    uvmfree(pagetable, 0);
    800010e6:	4581                	li	a1,0
    800010e8:	8526                	mv	a0,s1
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	936080e7          	jalr	-1738(ra) # 80000a20 <uvmfree>
    return 0;
    800010f2:	4481                	li	s1,0
    800010f4:	bf7d                	j	800010b2 <proc_pagetable+0x58>

00000000800010f6 <proc_freepagetable>:
{
    800010f6:	1101                	addi	sp,sp,-32
    800010f8:	ec06                	sd	ra,24(sp)
    800010fa:	e822                	sd	s0,16(sp)
    800010fc:	e426                	sd	s1,8(sp)
    800010fe:	e04a                	sd	s2,0(sp)
    80001100:	1000                	addi	s0,sp,32
    80001102:	84aa                	mv	s1,a0
    80001104:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001106:	4681                	li	a3,0
    80001108:	4605                	li	a2,1
    8000110a:	040005b7          	lui	a1,0x4000
    8000110e:	15fd                	addi	a1,a1,-1
    80001110:	05b2                	slli	a1,a1,0xc
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	64e080e7          	jalr	1614(ra) # 80000760 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000111a:	4681                	li	a3,0
    8000111c:	4605                	li	a2,1
    8000111e:	020005b7          	lui	a1,0x2000
    80001122:	15fd                	addi	a1,a1,-1
    80001124:	05b6                	slli	a1,a1,0xd
    80001126:	8526                	mv	a0,s1
    80001128:	fffff097          	auipc	ra,0xfffff
    8000112c:	638080e7          	jalr	1592(ra) # 80000760 <uvmunmap>
  uvmfree(pagetable, sz);
    80001130:	85ca                	mv	a1,s2
    80001132:	8526                	mv	a0,s1
    80001134:	00000097          	auipc	ra,0x0
    80001138:	8ec080e7          	jalr	-1812(ra) # 80000a20 <uvmfree>
}
    8000113c:	60e2                	ld	ra,24(sp)
    8000113e:	6442                	ld	s0,16(sp)
    80001140:	64a2                	ld	s1,8(sp)
    80001142:	6902                	ld	s2,0(sp)
    80001144:	6105                	addi	sp,sp,32
    80001146:	8082                	ret

0000000080001148 <freeproc>:
{
    80001148:	1101                	addi	sp,sp,-32
    8000114a:	ec06                	sd	ra,24(sp)
    8000114c:	e822                	sd	s0,16(sp)
    8000114e:	e426                	sd	s1,8(sp)
    80001150:	1000                	addi	s0,sp,32
    80001152:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001154:	6d28                	ld	a0,88(a0)
    80001156:	c509                	beqz	a0,80001160 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	ec4080e7          	jalr	-316(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001160:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001164:	68a8                	ld	a0,80(s1)
    80001166:	c511                	beqz	a0,80001172 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001168:	64ac                	ld	a1,72(s1)
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	f8c080e7          	jalr	-116(ra) # 800010f6 <proc_freepagetable>
  p->pagetable = 0;
    80001172:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001176:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000117a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000117e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001182:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001186:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000118a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000118e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001192:	0004ac23          	sw	zero,24(s1)
}
    80001196:	60e2                	ld	ra,24(sp)
    80001198:	6442                	ld	s0,16(sp)
    8000119a:	64a2                	ld	s1,8(sp)
    8000119c:	6105                	addi	sp,sp,32
    8000119e:	8082                	ret

00000000800011a0 <allocproc>:
{
    800011a0:	1101                	addi	sp,sp,-32
    800011a2:	ec06                	sd	ra,24(sp)
    800011a4:	e822                	sd	s0,16(sp)
    800011a6:	e426                	sd	s1,8(sp)
    800011a8:	e04a                	sd	s2,0(sp)
    800011aa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ac:	00008497          	auipc	s1,0x8
    800011b0:	2d448493          	addi	s1,s1,724 # 80009480 <proc>
    800011b4:	0000e917          	auipc	s2,0xe
    800011b8:	ccc90913          	addi	s2,s2,-820 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800011bc:	8526                	mv	a0,s1
    800011be:	00005097          	auipc	ra,0x5
    800011c2:	0f4080e7          	jalr	244(ra) # 800062b2 <acquire>
    if(p->state == UNUSED) {
    800011c6:	4c9c                	lw	a5,24(s1)
    800011c8:	cf81                	beqz	a5,800011e0 <allocproc+0x40>
      release(&p->lock);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00005097          	auipc	ra,0x5
    800011d0:	19a080e7          	jalr	410(ra) # 80006366 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d4:	16848493          	addi	s1,s1,360
    800011d8:	ff2492e3          	bne	s1,s2,800011bc <allocproc+0x1c>
  return 0;
    800011dc:	4481                	li	s1,0
    800011de:	a889                	j	80001230 <allocproc+0x90>
  p->pid = allocpid();
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	e34080e7          	jalr	-460(ra) # 80001014 <allocpid>
    800011e8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011ea:	4785                	li	a5,1
    800011ec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	f2a080e7          	jalr	-214(ra) # 80000118 <kalloc>
    800011f6:	892a                	mv	s2,a0
    800011f8:	eca8                	sd	a0,88(s1)
    800011fa:	c131                	beqz	a0,8000123e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	e5c080e7          	jalr	-420(ra) # 8000105a <proc_pagetable>
    80001206:	892a                	mv	s2,a0
    80001208:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000120a:	c531                	beqz	a0,80001256 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000120c:	07000613          	li	a2,112
    80001210:	4581                	li	a1,0
    80001212:	06048513          	addi	a0,s1,96
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	fb4080e7          	jalr	-76(ra) # 800001ca <memset>
  p->context.ra = (uint64)forkret;
    8000121e:	00000797          	auipc	a5,0x0
    80001222:	db078793          	addi	a5,a5,-592 # 80000fce <forkret>
    80001226:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001228:	60bc                	ld	a5,64(s1)
    8000122a:	6705                	lui	a4,0x1
    8000122c:	97ba                	add	a5,a5,a4
    8000122e:	f4bc                	sd	a5,104(s1)
}
    80001230:	8526                	mv	a0,s1
    80001232:	60e2                	ld	ra,24(sp)
    80001234:	6442                	ld	s0,16(sp)
    80001236:	64a2                	ld	s1,8(sp)
    80001238:	6902                	ld	s2,0(sp)
    8000123a:	6105                	addi	sp,sp,32
    8000123c:	8082                	ret
    freeproc(p);
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	f08080e7          	jalr	-248(ra) # 80001148 <freeproc>
    release(&p->lock);
    80001248:	8526                	mv	a0,s1
    8000124a:	00005097          	auipc	ra,0x5
    8000124e:	11c080e7          	jalr	284(ra) # 80006366 <release>
    return 0;
    80001252:	84ca                	mv	s1,s2
    80001254:	bff1                	j	80001230 <allocproc+0x90>
    freeproc(p);
    80001256:	8526                	mv	a0,s1
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	ef0080e7          	jalr	-272(ra) # 80001148 <freeproc>
    release(&p->lock);
    80001260:	8526                	mv	a0,s1
    80001262:	00005097          	auipc	ra,0x5
    80001266:	104080e7          	jalr	260(ra) # 80006366 <release>
    return 0;
    8000126a:	84ca                	mv	s1,s2
    8000126c:	b7d1                	j	80001230 <allocproc+0x90>

000000008000126e <userinit>:
{
    8000126e:	1101                	addi	sp,sp,-32
    80001270:	ec06                	sd	ra,24(sp)
    80001272:	e822                	sd	s0,16(sp)
    80001274:	e426                	sd	s1,8(sp)
    80001276:	1000                	addi	s0,sp,32
  p = allocproc();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	f28080e7          	jalr	-216(ra) # 800011a0 <allocproc>
    80001280:	84aa                	mv	s1,a0
  initproc = p;
    80001282:	00008797          	auipc	a5,0x8
    80001286:	d8a7b723          	sd	a0,-626(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000128a:	03400613          	li	a2,52
    8000128e:	00007597          	auipc	a1,0x7
    80001292:	76258593          	addi	a1,a1,1890 # 800089f0 <initcode>
    80001296:	6928                	ld	a0,80(a0)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	5ba080e7          	jalr	1466(ra) # 80000852 <uvminit>
  p->sz = PGSIZE;
    800012a0:	6785                	lui	a5,0x1
    800012a2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012a4:	6cb8                	ld	a4,88(s1)
    800012a6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012aa:	6cb8                	ld	a4,88(s1)
    800012ac:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012ae:	4641                	li	a2,16
    800012b0:	00007597          	auipc	a1,0x7
    800012b4:	f0858593          	addi	a1,a1,-248 # 800081b8 <etext+0x1b8>
    800012b8:	15848513          	addi	a0,s1,344
    800012bc:	fffff097          	auipc	ra,0xfffff
    800012c0:	060080e7          	jalr	96(ra) # 8000031c <safestrcpy>
  p->cwd = namei("/");
    800012c4:	00007517          	auipc	a0,0x7
    800012c8:	f0450513          	addi	a0,a0,-252 # 800081c8 <etext+0x1c8>
    800012cc:	00002097          	auipc	ra,0x2
    800012d0:	18e080e7          	jalr	398(ra) # 8000345a <namei>
    800012d4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012d8:	478d                	li	a5,3
    800012da:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012dc:	8526                	mv	a0,s1
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	088080e7          	jalr	136(ra) # 80006366 <release>
}
    800012e6:	60e2                	ld	ra,24(sp)
    800012e8:	6442                	ld	s0,16(sp)
    800012ea:	64a2                	ld	s1,8(sp)
    800012ec:	6105                	addi	sp,sp,32
    800012ee:	8082                	ret

00000000800012f0 <growproc>:
{
    800012f0:	1101                	addi	sp,sp,-32
    800012f2:	ec06                	sd	ra,24(sp)
    800012f4:	e822                	sd	s0,16(sp)
    800012f6:	e426                	sd	s1,8(sp)
    800012f8:	e04a                	sd	s2,0(sp)
    800012fa:	1000                	addi	s0,sp,32
    800012fc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	c98080e7          	jalr	-872(ra) # 80000f96 <myproc>
    80001306:	892a                	mv	s2,a0
  sz = p->sz;
    80001308:	652c                	ld	a1,72(a0)
    8000130a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000130e:	00904f63          	bgtz	s1,8000132c <growproc+0x3c>
  } else if(n < 0){
    80001312:	0204cc63          	bltz	s1,8000134a <growproc+0x5a>
  p->sz = sz;
    80001316:	1602                	slli	a2,a2,0x20
    80001318:	9201                	srli	a2,a2,0x20
    8000131a:	04c93423          	sd	a2,72(s2)
  return 0;
    8000131e:	4501                	li	a0,0
}
    80001320:	60e2                	ld	ra,24(sp)
    80001322:	6442                	ld	s0,16(sp)
    80001324:	64a2                	ld	s1,8(sp)
    80001326:	6902                	ld	s2,0(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000132c:	9e25                	addw	a2,a2,s1
    8000132e:	1602                	slli	a2,a2,0x20
    80001330:	9201                	srli	a2,a2,0x20
    80001332:	1582                	slli	a1,a1,0x20
    80001334:	9181                	srli	a1,a1,0x20
    80001336:	6928                	ld	a0,80(a0)
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	5d4080e7          	jalr	1492(ra) # 8000090c <uvmalloc>
    80001340:	0005061b          	sext.w	a2,a0
    80001344:	fa69                	bnez	a2,80001316 <growproc+0x26>
      return -1;
    80001346:	557d                	li	a0,-1
    80001348:	bfe1                	j	80001320 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000134a:	9e25                	addw	a2,a2,s1
    8000134c:	1602                	slli	a2,a2,0x20
    8000134e:	9201                	srli	a2,a2,0x20
    80001350:	1582                	slli	a1,a1,0x20
    80001352:	9181                	srli	a1,a1,0x20
    80001354:	6928                	ld	a0,80(a0)
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	56e080e7          	jalr	1390(ra) # 800008c4 <uvmdealloc>
    8000135e:	0005061b          	sext.w	a2,a0
    80001362:	bf55                	j	80001316 <growproc+0x26>

0000000080001364 <fork>:
{
    80001364:	7179                	addi	sp,sp,-48
    80001366:	f406                	sd	ra,40(sp)
    80001368:	f022                	sd	s0,32(sp)
    8000136a:	ec26                	sd	s1,24(sp)
    8000136c:	e84a                	sd	s2,16(sp)
    8000136e:	e44e                	sd	s3,8(sp)
    80001370:	e052                	sd	s4,0(sp)
    80001372:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001374:	00000097          	auipc	ra,0x0
    80001378:	c22080e7          	jalr	-990(ra) # 80000f96 <myproc>
    8000137c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	e22080e7          	jalr	-478(ra) # 800011a0 <allocproc>
    80001386:	10050f63          	beqz	a0,800014a4 <fork+0x140>
    8000138a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000138c:	04893603          	ld	a2,72(s2)
    80001390:	692c                	ld	a1,80(a0)
    80001392:	05093503          	ld	a0,80(s2)
    80001396:	fffff097          	auipc	ra,0xfffff
    8000139a:	6c2080e7          	jalr	1730(ra) # 80000a58 <uvmcopy>
    8000139e:	04054663          	bltz	a0,800013ea <fork+0x86>
  np->sz = p->sz;
    800013a2:	04893783          	ld	a5,72(s2)
    800013a6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013aa:	05893683          	ld	a3,88(s2)
    800013ae:	87b6                	mv	a5,a3
    800013b0:	0589b703          	ld	a4,88(s3)
    800013b4:	12068693          	addi	a3,a3,288
    800013b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013bc:	6788                	ld	a0,8(a5)
    800013be:	6b8c                	ld	a1,16(a5)
    800013c0:	6f90                	ld	a2,24(a5)
    800013c2:	01073023          	sd	a6,0(a4)
    800013c6:	e708                	sd	a0,8(a4)
    800013c8:	eb0c                	sd	a1,16(a4)
    800013ca:	ef10                	sd	a2,24(a4)
    800013cc:	02078793          	addi	a5,a5,32
    800013d0:	02070713          	addi	a4,a4,32
    800013d4:	fed792e3          	bne	a5,a3,800013b8 <fork+0x54>
  np->trapframe->a0 = 0;
    800013d8:	0589b783          	ld	a5,88(s3)
    800013dc:	0607b823          	sd	zero,112(a5)
    800013e0:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800013e4:	15000a13          	li	s4,336
    800013e8:	a03d                	j	80001416 <fork+0xb2>
    freeproc(np);
    800013ea:	854e                	mv	a0,s3
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	d5c080e7          	jalr	-676(ra) # 80001148 <freeproc>
    release(&np->lock);
    800013f4:	854e                	mv	a0,s3
    800013f6:	00005097          	auipc	ra,0x5
    800013fa:	f70080e7          	jalr	-144(ra) # 80006366 <release>
    return -1;
    800013fe:	5a7d                	li	s4,-1
    80001400:	a849                	j	80001492 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001402:	00002097          	auipc	ra,0x2
    80001406:	6ee080e7          	jalr	1774(ra) # 80003af0 <filedup>
    8000140a:	009987b3          	add	a5,s3,s1
    8000140e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001410:	04a1                	addi	s1,s1,8
    80001412:	01448763          	beq	s1,s4,80001420 <fork+0xbc>
    if(p->ofile[i])
    80001416:	009907b3          	add	a5,s2,s1
    8000141a:	6388                	ld	a0,0(a5)
    8000141c:	f17d                	bnez	a0,80001402 <fork+0x9e>
    8000141e:	bfcd                	j	80001410 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001420:	15093503          	ld	a0,336(s2)
    80001424:	00002097          	auipc	ra,0x2
    80001428:	842080e7          	jalr	-1982(ra) # 80002c66 <idup>
    8000142c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001430:	4641                	li	a2,16
    80001432:	15890593          	addi	a1,s2,344
    80001436:	15898513          	addi	a0,s3,344
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	ee2080e7          	jalr	-286(ra) # 8000031c <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001442:	03492783          	lw	a5,52(s2)
    80001446:	02f9aa23          	sw	a5,52(s3)
  pid = np->pid;
    8000144a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000144e:	854e                	mv	a0,s3
    80001450:	00005097          	auipc	ra,0x5
    80001454:	f16080e7          	jalr	-234(ra) # 80006366 <release>
  acquire(&wait_lock);
    80001458:	00008497          	auipc	s1,0x8
    8000145c:	c1048493          	addi	s1,s1,-1008 # 80009068 <wait_lock>
    80001460:	8526                	mv	a0,s1
    80001462:	00005097          	auipc	ra,0x5
    80001466:	e50080e7          	jalr	-432(ra) # 800062b2 <acquire>
  np->parent = p;
    8000146a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000146e:	8526                	mv	a0,s1
    80001470:	00005097          	auipc	ra,0x5
    80001474:	ef6080e7          	jalr	-266(ra) # 80006366 <release>
  acquire(&np->lock);
    80001478:	854e                	mv	a0,s3
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	e38080e7          	jalr	-456(ra) # 800062b2 <acquire>
  np->state = RUNNABLE;
    80001482:	478d                	li	a5,3
    80001484:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001488:	854e                	mv	a0,s3
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	edc080e7          	jalr	-292(ra) # 80006366 <release>
}
    80001492:	8552                	mv	a0,s4
    80001494:	70a2                	ld	ra,40(sp)
    80001496:	7402                	ld	s0,32(sp)
    80001498:	64e2                	ld	s1,24(sp)
    8000149a:	6942                	ld	s2,16(sp)
    8000149c:	69a2                	ld	s3,8(sp)
    8000149e:	6a02                	ld	s4,0(sp)
    800014a0:	6145                	addi	sp,sp,48
    800014a2:	8082                	ret
    return -1;
    800014a4:	5a7d                	li	s4,-1
    800014a6:	b7f5                	j	80001492 <fork+0x12e>

00000000800014a8 <scheduler>:
{
    800014a8:	7139                	addi	sp,sp,-64
    800014aa:	fc06                	sd	ra,56(sp)
    800014ac:	f822                	sd	s0,48(sp)
    800014ae:	f426                	sd	s1,40(sp)
    800014b0:	f04a                	sd	s2,32(sp)
    800014b2:	ec4e                	sd	s3,24(sp)
    800014b4:	e852                	sd	s4,16(sp)
    800014b6:	e456                	sd	s5,8(sp)
    800014b8:	e05a                	sd	s6,0(sp)
    800014ba:	0080                	addi	s0,sp,64
    800014bc:	8792                	mv	a5,tp
  int id = r_tp();
    800014be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c0:	00779a93          	slli	s5,a5,0x7
    800014c4:	00008717          	auipc	a4,0x8
    800014c8:	b8c70713          	addi	a4,a4,-1140 # 80009050 <pid_lock>
    800014cc:	9756                	add	a4,a4,s5
    800014ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014d2:	00008717          	auipc	a4,0x8
    800014d6:	bb670713          	addi	a4,a4,-1098 # 80009088 <cpus+0x8>
    800014da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014dc:	498d                	li	s3,3
        p->state = RUNNING;
    800014de:	4b11                	li	s6,4
        c->proc = p;
    800014e0:	079e                	slli	a5,a5,0x7
    800014e2:	00008a17          	auipc	s4,0x8
    800014e6:	b6ea0a13          	addi	s4,s4,-1170 # 80009050 <pid_lock>
    800014ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ec:	0000e917          	auipc	s2,0xe
    800014f0:	99490913          	addi	s2,s2,-1644 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014fc:	10079073          	csrw	sstatus,a5
    80001500:	00008497          	auipc	s1,0x8
    80001504:	f8048493          	addi	s1,s1,-128 # 80009480 <proc>
    80001508:	a03d                	j	80001536 <scheduler+0x8e>
        p->state = RUNNING;
    8000150a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000150e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001512:	06048593          	addi	a1,s1,96
    80001516:	8556                	mv	a0,s5
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	676080e7          	jalr	1654(ra) # 80001b8e <swtch>
        c->proc = 0;
    80001520:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001524:	8526                	mv	a0,s1
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	e40080e7          	jalr	-448(ra) # 80006366 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000152e:	16848493          	addi	s1,s1,360
    80001532:	fd2481e3          	beq	s1,s2,800014f4 <scheduler+0x4c>
      acquire(&p->lock);
    80001536:	8526                	mv	a0,s1
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	d7a080e7          	jalr	-646(ra) # 800062b2 <acquire>
      if(p->state == RUNNABLE) {
    80001540:	4c9c                	lw	a5,24(s1)
    80001542:	ff3791e3          	bne	a5,s3,80001524 <scheduler+0x7c>
    80001546:	b7d1                	j	8000150a <scheduler+0x62>

0000000080001548 <sched>:
{
    80001548:	7179                	addi	sp,sp,-48
    8000154a:	f406                	sd	ra,40(sp)
    8000154c:	f022                	sd	s0,32(sp)
    8000154e:	ec26                	sd	s1,24(sp)
    80001550:	e84a                	sd	s2,16(sp)
    80001552:	e44e                	sd	s3,8(sp)
    80001554:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	a40080e7          	jalr	-1472(ra) # 80000f96 <myproc>
    8000155e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001560:	00005097          	auipc	ra,0x5
    80001564:	cd8080e7          	jalr	-808(ra) # 80006238 <holding>
    80001568:	c93d                	beqz	a0,800015de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000156a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000156c:	2781                	sext.w	a5,a5
    8000156e:	079e                	slli	a5,a5,0x7
    80001570:	00008717          	auipc	a4,0x8
    80001574:	ae070713          	addi	a4,a4,-1312 # 80009050 <pid_lock>
    80001578:	97ba                	add	a5,a5,a4
    8000157a:	0a87a703          	lw	a4,168(a5)
    8000157e:	4785                	li	a5,1
    80001580:	06f71763          	bne	a4,a5,800015ee <sched+0xa6>
  if(p->state == RUNNING)
    80001584:	4c98                	lw	a4,24(s1)
    80001586:	4791                	li	a5,4
    80001588:	06f70b63          	beq	a4,a5,800015fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000158c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001590:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001592:	efb5                	bnez	a5,8000160e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001594:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001596:	00008917          	auipc	s2,0x8
    8000159a:	aba90913          	addi	s2,s2,-1350 # 80009050 <pid_lock>
    8000159e:	2781                	sext.w	a5,a5
    800015a0:	079e                	slli	a5,a5,0x7
    800015a2:	97ca                	add	a5,a5,s2
    800015a4:	0ac7a983          	lw	s3,172(a5)
    800015a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015aa:	2781                	sext.w	a5,a5
    800015ac:	079e                	slli	a5,a5,0x7
    800015ae:	00008597          	auipc	a1,0x8
    800015b2:	ada58593          	addi	a1,a1,-1318 # 80009088 <cpus+0x8>
    800015b6:	95be                	add	a1,a1,a5
    800015b8:	06048513          	addi	a0,s1,96
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	5d2080e7          	jalr	1490(ra) # 80001b8e <swtch>
    800015c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015c6:	2781                	sext.w	a5,a5
    800015c8:	079e                	slli	a5,a5,0x7
    800015ca:	97ca                	add	a5,a5,s2
    800015cc:	0b37a623          	sw	s3,172(a5)
}
    800015d0:	70a2                	ld	ra,40(sp)
    800015d2:	7402                	ld	s0,32(sp)
    800015d4:	64e2                	ld	s1,24(sp)
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	69a2                	ld	s3,8(sp)
    800015da:	6145                	addi	sp,sp,48
    800015dc:	8082                	ret
    panic("sched p->lock");
    800015de:	00007517          	auipc	a0,0x7
    800015e2:	bf250513          	addi	a0,a0,-1038 # 800081d0 <etext+0x1d0>
    800015e6:	00004097          	auipc	ra,0x4
    800015ea:	782080e7          	jalr	1922(ra) # 80005d68 <panic>
    panic("sched locks");
    800015ee:	00007517          	auipc	a0,0x7
    800015f2:	bf250513          	addi	a0,a0,-1038 # 800081e0 <etext+0x1e0>
    800015f6:	00004097          	auipc	ra,0x4
    800015fa:	772080e7          	jalr	1906(ra) # 80005d68 <panic>
    panic("sched running");
    800015fe:	00007517          	auipc	a0,0x7
    80001602:	bf250513          	addi	a0,a0,-1038 # 800081f0 <etext+0x1f0>
    80001606:	00004097          	auipc	ra,0x4
    8000160a:	762080e7          	jalr	1890(ra) # 80005d68 <panic>
    panic("sched interruptible");
    8000160e:	00007517          	auipc	a0,0x7
    80001612:	bf250513          	addi	a0,a0,-1038 # 80008200 <etext+0x200>
    80001616:	00004097          	auipc	ra,0x4
    8000161a:	752080e7          	jalr	1874(ra) # 80005d68 <panic>

000000008000161e <yield>:
{
    8000161e:	1101                	addi	sp,sp,-32
    80001620:	ec06                	sd	ra,24(sp)
    80001622:	e822                	sd	s0,16(sp)
    80001624:	e426                	sd	s1,8(sp)
    80001626:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	96e080e7          	jalr	-1682(ra) # 80000f96 <myproc>
    80001630:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001632:	00005097          	auipc	ra,0x5
    80001636:	c80080e7          	jalr	-896(ra) # 800062b2 <acquire>
  p->state = RUNNABLE;
    8000163a:	478d                	li	a5,3
    8000163c:	cc9c                	sw	a5,24(s1)
  sched();
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	f0a080e7          	jalr	-246(ra) # 80001548 <sched>
  release(&p->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	d1e080e7          	jalr	-738(ra) # 80006366 <release>
}
    80001650:	60e2                	ld	ra,24(sp)
    80001652:	6442                	ld	s0,16(sp)
    80001654:	64a2                	ld	s1,8(sp)
    80001656:	6105                	addi	sp,sp,32
    80001658:	8082                	ret

000000008000165a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000165a:	7179                	addi	sp,sp,-48
    8000165c:	f406                	sd	ra,40(sp)
    8000165e:	f022                	sd	s0,32(sp)
    80001660:	ec26                	sd	s1,24(sp)
    80001662:	e84a                	sd	s2,16(sp)
    80001664:	e44e                	sd	s3,8(sp)
    80001666:	1800                	addi	s0,sp,48
    80001668:	89aa                	mv	s3,a0
    8000166a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	92a080e7          	jalr	-1750(ra) # 80000f96 <myproc>
    80001674:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	c3c080e7          	jalr	-964(ra) # 800062b2 <acquire>
  release(lk);
    8000167e:	854a                	mv	a0,s2
    80001680:	00005097          	auipc	ra,0x5
    80001684:	ce6080e7          	jalr	-794(ra) # 80006366 <release>

  // Go to sleep.
  p->chan = chan;
    80001688:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000168c:	4789                	li	a5,2
    8000168e:	cc9c                	sw	a5,24(s1)

  sched();
    80001690:	00000097          	auipc	ra,0x0
    80001694:	eb8080e7          	jalr	-328(ra) # 80001548 <sched>

  // Tidy up.
  p->chan = 0;
    80001698:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	cc8080e7          	jalr	-824(ra) # 80006366 <release>
  acquire(lk);
    800016a6:	854a                	mv	a0,s2
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	c0a080e7          	jalr	-1014(ra) # 800062b2 <acquire>
}
    800016b0:	70a2                	ld	ra,40(sp)
    800016b2:	7402                	ld	s0,32(sp)
    800016b4:	64e2                	ld	s1,24(sp)
    800016b6:	6942                	ld	s2,16(sp)
    800016b8:	69a2                	ld	s3,8(sp)
    800016ba:	6145                	addi	sp,sp,48
    800016bc:	8082                	ret

00000000800016be <wait>:
{
    800016be:	715d                	addi	sp,sp,-80
    800016c0:	e486                	sd	ra,72(sp)
    800016c2:	e0a2                	sd	s0,64(sp)
    800016c4:	fc26                	sd	s1,56(sp)
    800016c6:	f84a                	sd	s2,48(sp)
    800016c8:	f44e                	sd	s3,40(sp)
    800016ca:	f052                	sd	s4,32(sp)
    800016cc:	ec56                	sd	s5,24(sp)
    800016ce:	e85a                	sd	s6,16(sp)
    800016d0:	e45e                	sd	s7,8(sp)
    800016d2:	e062                	sd	s8,0(sp)
    800016d4:	0880                	addi	s0,sp,80
    800016d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	8be080e7          	jalr	-1858(ra) # 80000f96 <myproc>
    800016e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016e2:	00008517          	auipc	a0,0x8
    800016e6:	98650513          	addi	a0,a0,-1658 # 80009068 <wait_lock>
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	bc8080e7          	jalr	-1080(ra) # 800062b2 <acquire>
    havekids = 0;
    800016f2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016f4:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016f6:	0000d997          	auipc	s3,0xd
    800016fa:	78a98993          	addi	s3,s3,1930 # 8000ee80 <tickslock>
        havekids = 1;
    800016fe:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001700:	00008c17          	auipc	s8,0x8
    80001704:	968c0c13          	addi	s8,s8,-1688 # 80009068 <wait_lock>
    havekids = 0;
    80001708:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000170a:	00008497          	auipc	s1,0x8
    8000170e:	d7648493          	addi	s1,s1,-650 # 80009480 <proc>
    80001712:	a0bd                	j	80001780 <wait+0xc2>
          pid = np->pid;
    80001714:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001718:	000b0e63          	beqz	s6,80001734 <wait+0x76>
    8000171c:	4691                	li	a3,4
    8000171e:	02c48613          	addi	a2,s1,44
    80001722:	85da                	mv	a1,s6
    80001724:	05093503          	ld	a0,80(s2)
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	434080e7          	jalr	1076(ra) # 80000b5c <copyout>
    80001730:	02054563          	bltz	a0,8000175a <wait+0x9c>
          freeproc(np);
    80001734:	8526                	mv	a0,s1
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	a12080e7          	jalr	-1518(ra) # 80001148 <freeproc>
          release(&np->lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	c26080e7          	jalr	-986(ra) # 80006366 <release>
          release(&wait_lock);
    80001748:	00008517          	auipc	a0,0x8
    8000174c:	92050513          	addi	a0,a0,-1760 # 80009068 <wait_lock>
    80001750:	00005097          	auipc	ra,0x5
    80001754:	c16080e7          	jalr	-1002(ra) # 80006366 <release>
          return pid;
    80001758:	a09d                	j	800017be <wait+0x100>
            release(&np->lock);
    8000175a:	8526                	mv	a0,s1
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	c0a080e7          	jalr	-1014(ra) # 80006366 <release>
            release(&wait_lock);
    80001764:	00008517          	auipc	a0,0x8
    80001768:	90450513          	addi	a0,a0,-1788 # 80009068 <wait_lock>
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	bfa080e7          	jalr	-1030(ra) # 80006366 <release>
            return -1;
    80001774:	59fd                	li	s3,-1
    80001776:	a0a1                	j	800017be <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001778:	16848493          	addi	s1,s1,360
    8000177c:	03348463          	beq	s1,s3,800017a4 <wait+0xe6>
      if(np->parent == p){
    80001780:	7c9c                	ld	a5,56(s1)
    80001782:	ff279be3          	bne	a5,s2,80001778 <wait+0xba>
        acquire(&np->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	b2a080e7          	jalr	-1238(ra) # 800062b2 <acquire>
        if(np->state == ZOMBIE){
    80001790:	4c9c                	lw	a5,24(s1)
    80001792:	f94781e3          	beq	a5,s4,80001714 <wait+0x56>
        release(&np->lock);
    80001796:	8526                	mv	a0,s1
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	bce080e7          	jalr	-1074(ra) # 80006366 <release>
        havekids = 1;
    800017a0:	8756                	mv	a4,s5
    800017a2:	bfd9                	j	80001778 <wait+0xba>
    if(!havekids || p->killed){
    800017a4:	c701                	beqz	a4,800017ac <wait+0xee>
    800017a6:	02892783          	lw	a5,40(s2)
    800017aa:	c79d                	beqz	a5,800017d8 <wait+0x11a>
      release(&wait_lock);
    800017ac:	00008517          	auipc	a0,0x8
    800017b0:	8bc50513          	addi	a0,a0,-1860 # 80009068 <wait_lock>
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	bb2080e7          	jalr	-1102(ra) # 80006366 <release>
      return -1;
    800017bc:	59fd                	li	s3,-1
}
    800017be:	854e                	mv	a0,s3
    800017c0:	60a6                	ld	ra,72(sp)
    800017c2:	6406                	ld	s0,64(sp)
    800017c4:	74e2                	ld	s1,56(sp)
    800017c6:	7942                	ld	s2,48(sp)
    800017c8:	79a2                	ld	s3,40(sp)
    800017ca:	7a02                	ld	s4,32(sp)
    800017cc:	6ae2                	ld	s5,24(sp)
    800017ce:	6b42                	ld	s6,16(sp)
    800017d0:	6ba2                	ld	s7,8(sp)
    800017d2:	6c02                	ld	s8,0(sp)
    800017d4:	6161                	addi	sp,sp,80
    800017d6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017d8:	85e2                	mv	a1,s8
    800017da:	854a                	mv	a0,s2
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	e7e080e7          	jalr	-386(ra) # 8000165a <sleep>
    havekids = 0;
    800017e4:	b715                	j	80001708 <wait+0x4a>

00000000800017e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017e6:	7139                	addi	sp,sp,-64
    800017e8:	fc06                	sd	ra,56(sp)
    800017ea:	f822                	sd	s0,48(sp)
    800017ec:	f426                	sd	s1,40(sp)
    800017ee:	f04a                	sd	s2,32(sp)
    800017f0:	ec4e                	sd	s3,24(sp)
    800017f2:	e852                	sd	s4,16(sp)
    800017f4:	e456                	sd	s5,8(sp)
    800017f6:	0080                	addi	s0,sp,64
    800017f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017fa:	00008497          	auipc	s1,0x8
    800017fe:	c8648493          	addi	s1,s1,-890 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001802:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001804:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001806:	0000d917          	auipc	s2,0xd
    8000180a:	67a90913          	addi	s2,s2,1658 # 8000ee80 <tickslock>
    8000180e:	a821                	j	80001826 <wakeup+0x40>
        p->state = RUNNABLE;
    80001810:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	b50080e7          	jalr	-1200(ra) # 80006366 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000181e:	16848493          	addi	s1,s1,360
    80001822:	03248463          	beq	s1,s2,8000184a <wakeup+0x64>
    if(p != myproc()){
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	770080e7          	jalr	1904(ra) # 80000f96 <myproc>
    8000182e:	fea488e3          	beq	s1,a0,8000181e <wakeup+0x38>
      acquire(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	a7e080e7          	jalr	-1410(ra) # 800062b2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000183c:	4c9c                	lw	a5,24(s1)
    8000183e:	fd379be3          	bne	a5,s3,80001814 <wakeup+0x2e>
    80001842:	709c                	ld	a5,32(s1)
    80001844:	fd4798e3          	bne	a5,s4,80001814 <wakeup+0x2e>
    80001848:	b7e1                	j	80001810 <wakeup+0x2a>
    }
  }
}
    8000184a:	70e2                	ld	ra,56(sp)
    8000184c:	7442                	ld	s0,48(sp)
    8000184e:	74a2                	ld	s1,40(sp)
    80001850:	7902                	ld	s2,32(sp)
    80001852:	69e2                	ld	s3,24(sp)
    80001854:	6a42                	ld	s4,16(sp)
    80001856:	6aa2                	ld	s5,8(sp)
    80001858:	6121                	addi	sp,sp,64
    8000185a:	8082                	ret

000000008000185c <reparent>:
{
    8000185c:	7179                	addi	sp,sp,-48
    8000185e:	f406                	sd	ra,40(sp)
    80001860:	f022                	sd	s0,32(sp)
    80001862:	ec26                	sd	s1,24(sp)
    80001864:	e84a                	sd	s2,16(sp)
    80001866:	e44e                	sd	s3,8(sp)
    80001868:	e052                	sd	s4,0(sp)
    8000186a:	1800                	addi	s0,sp,48
    8000186c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000186e:	00008497          	auipc	s1,0x8
    80001872:	c1248493          	addi	s1,s1,-1006 # 80009480 <proc>
      pp->parent = initproc;
    80001876:	00007a17          	auipc	s4,0x7
    8000187a:	79aa0a13          	addi	s4,s4,1946 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187e:	0000d997          	auipc	s3,0xd
    80001882:	60298993          	addi	s3,s3,1538 # 8000ee80 <tickslock>
    80001886:	a029                	j	80001890 <reparent+0x34>
    80001888:	16848493          	addi	s1,s1,360
    8000188c:	01348d63          	beq	s1,s3,800018a6 <reparent+0x4a>
    if(pp->parent == p){
    80001890:	7c9c                	ld	a5,56(s1)
    80001892:	ff279be3          	bne	a5,s2,80001888 <reparent+0x2c>
      pp->parent = initproc;
    80001896:	000a3503          	ld	a0,0(s4)
    8000189a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000189c:	00000097          	auipc	ra,0x0
    800018a0:	f4a080e7          	jalr	-182(ra) # 800017e6 <wakeup>
    800018a4:	b7d5                	j	80001888 <reparent+0x2c>
}
    800018a6:	70a2                	ld	ra,40(sp)
    800018a8:	7402                	ld	s0,32(sp)
    800018aa:	64e2                	ld	s1,24(sp)
    800018ac:	6942                	ld	s2,16(sp)
    800018ae:	69a2                	ld	s3,8(sp)
    800018b0:	6a02                	ld	s4,0(sp)
    800018b2:	6145                	addi	sp,sp,48
    800018b4:	8082                	ret

00000000800018b6 <exit>:
{
    800018b6:	7179                	addi	sp,sp,-48
    800018b8:	f406                	sd	ra,40(sp)
    800018ba:	f022                	sd	s0,32(sp)
    800018bc:	ec26                	sd	s1,24(sp)
    800018be:	e84a                	sd	s2,16(sp)
    800018c0:	e44e                	sd	s3,8(sp)
    800018c2:	e052                	sd	s4,0(sp)
    800018c4:	1800                	addi	s0,sp,48
    800018c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	6ce080e7          	jalr	1742(ra) # 80000f96 <myproc>
    800018d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800018d2:	00007797          	auipc	a5,0x7
    800018d6:	73e7b783          	ld	a5,1854(a5) # 80009010 <initproc>
    800018da:	0d050493          	addi	s1,a0,208
    800018de:	15050913          	addi	s2,a0,336
    800018e2:	02a79363          	bne	a5,a0,80001908 <exit+0x52>
    panic("init exiting");
    800018e6:	00007517          	auipc	a0,0x7
    800018ea:	93250513          	addi	a0,a0,-1742 # 80008218 <etext+0x218>
    800018ee:	00004097          	auipc	ra,0x4
    800018f2:	47a080e7          	jalr	1146(ra) # 80005d68 <panic>
      fileclose(f);
    800018f6:	00002097          	auipc	ra,0x2
    800018fa:	24c080e7          	jalr	588(ra) # 80003b42 <fileclose>
      p->ofile[fd] = 0;
    800018fe:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001902:	04a1                	addi	s1,s1,8
    80001904:	01248563          	beq	s1,s2,8000190e <exit+0x58>
    if(p->ofile[fd]){
    80001908:	6088                	ld	a0,0(s1)
    8000190a:	f575                	bnez	a0,800018f6 <exit+0x40>
    8000190c:	bfdd                	j	80001902 <exit+0x4c>
  begin_op();
    8000190e:	00002097          	auipc	ra,0x2
    80001912:	d68080e7          	jalr	-664(ra) # 80003676 <begin_op>
  iput(p->cwd);
    80001916:	1509b503          	ld	a0,336(s3)
    8000191a:	00001097          	auipc	ra,0x1
    8000191e:	544080e7          	jalr	1348(ra) # 80002e5e <iput>
  end_op();
    80001922:	00002097          	auipc	ra,0x2
    80001926:	dd4080e7          	jalr	-556(ra) # 800036f6 <end_op>
  p->cwd = 0;
    8000192a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000192e:	00007497          	auipc	s1,0x7
    80001932:	73a48493          	addi	s1,s1,1850 # 80009068 <wait_lock>
    80001936:	8526                	mv	a0,s1
    80001938:	00005097          	auipc	ra,0x5
    8000193c:	97a080e7          	jalr	-1670(ra) # 800062b2 <acquire>
  reparent(p);
    80001940:	854e                	mv	a0,s3
    80001942:	00000097          	auipc	ra,0x0
    80001946:	f1a080e7          	jalr	-230(ra) # 8000185c <reparent>
  wakeup(p->parent);
    8000194a:	0389b503          	ld	a0,56(s3)
    8000194e:	00000097          	auipc	ra,0x0
    80001952:	e98080e7          	jalr	-360(ra) # 800017e6 <wakeup>
  acquire(&p->lock);
    80001956:	854e                	mv	a0,s3
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	95a080e7          	jalr	-1702(ra) # 800062b2 <acquire>
  p->xstate = status;
    80001960:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001964:	4795                	li	a5,5
    80001966:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000196a:	8526                	mv	a0,s1
    8000196c:	00005097          	auipc	ra,0x5
    80001970:	9fa080e7          	jalr	-1542(ra) # 80006366 <release>
  sched();
    80001974:	00000097          	auipc	ra,0x0
    80001978:	bd4080e7          	jalr	-1068(ra) # 80001548 <sched>
  panic("zombie exit");
    8000197c:	00007517          	auipc	a0,0x7
    80001980:	8ac50513          	addi	a0,a0,-1876 # 80008228 <etext+0x228>
    80001984:	00004097          	auipc	ra,0x4
    80001988:	3e4080e7          	jalr	996(ra) # 80005d68 <panic>

000000008000198c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000198c:	7179                	addi	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	1800                	addi	s0,sp,48
    8000199a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000199c:	00008497          	auipc	s1,0x8
    800019a0:	ae448493          	addi	s1,s1,-1308 # 80009480 <proc>
    800019a4:	0000d997          	auipc	s3,0xd
    800019a8:	4dc98993          	addi	s3,s3,1244 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	904080e7          	jalr	-1788(ra) # 800062b2 <acquire>
    if(p->pid == pid){
    800019b6:	589c                	lw	a5,48(s1)
    800019b8:	01278d63          	beq	a5,s2,800019d2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019bc:	8526                	mv	a0,s1
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	9a8080e7          	jalr	-1624(ra) # 80006366 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	ff3491e3          	bne	s1,s3,800019ac <kill+0x20>
  }
  return -1;
    800019ce:	557d                	li	a0,-1
    800019d0:	a829                	j	800019ea <kill+0x5e>
      p->killed = 1;
    800019d2:	4785                	li	a5,1
    800019d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019d6:	4c98                	lw	a4,24(s1)
    800019d8:	4789                	li	a5,2
    800019da:	00f70f63          	beq	a4,a5,800019f8 <kill+0x6c>
      release(&p->lock);
    800019de:	8526                	mv	a0,s1
    800019e0:	00005097          	auipc	ra,0x5
    800019e4:	986080e7          	jalr	-1658(ra) # 80006366 <release>
      return 0;
    800019e8:	4501                	li	a0,0
}
    800019ea:	70a2                	ld	ra,40(sp)
    800019ec:	7402                	ld	s0,32(sp)
    800019ee:	64e2                	ld	s1,24(sp)
    800019f0:	6942                	ld	s2,16(sp)
    800019f2:	69a2                	ld	s3,8(sp)
    800019f4:	6145                	addi	sp,sp,48
    800019f6:	8082                	ret
        p->state = RUNNABLE;
    800019f8:	478d                	li	a5,3
    800019fa:	cc9c                	sw	a5,24(s1)
    800019fc:	b7cd                	j	800019de <kill+0x52>

00000000800019fe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019fe:	7179                	addi	sp,sp,-48
    80001a00:	f406                	sd	ra,40(sp)
    80001a02:	f022                	sd	s0,32(sp)
    80001a04:	ec26                	sd	s1,24(sp)
    80001a06:	e84a                	sd	s2,16(sp)
    80001a08:	e44e                	sd	s3,8(sp)
    80001a0a:	e052                	sd	s4,0(sp)
    80001a0c:	1800                	addi	s0,sp,48
    80001a0e:	84aa                	mv	s1,a0
    80001a10:	892e                	mv	s2,a1
    80001a12:	89b2                	mv	s3,a2
    80001a14:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	580080e7          	jalr	1408(ra) # 80000f96 <myproc>
  if(user_dst){
    80001a1e:	c08d                	beqz	s1,80001a40 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a20:	86d2                	mv	a3,s4
    80001a22:	864e                	mv	a2,s3
    80001a24:	85ca                	mv	a1,s2
    80001a26:	6928                	ld	a0,80(a0)
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	134080e7          	jalr	308(ra) # 80000b5c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a30:	70a2                	ld	ra,40(sp)
    80001a32:	7402                	ld	s0,32(sp)
    80001a34:	64e2                	ld	s1,24(sp)
    80001a36:	6942                	ld	s2,16(sp)
    80001a38:	69a2                	ld	s3,8(sp)
    80001a3a:	6a02                	ld	s4,0(sp)
    80001a3c:	6145                	addi	sp,sp,48
    80001a3e:	8082                	ret
    memmove((char *)dst, src, len);
    80001a40:	000a061b          	sext.w	a2,s4
    80001a44:	85ce                	mv	a1,s3
    80001a46:	854a                	mv	a0,s2
    80001a48:	ffffe097          	auipc	ra,0xffffe
    80001a4c:	7e2080e7          	jalr	2018(ra) # 8000022a <memmove>
    return 0;
    80001a50:	8526                	mv	a0,s1
    80001a52:	bff9                	j	80001a30 <either_copyout+0x32>

0000000080001a54 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	e052                	sd	s4,0(sp)
    80001a62:	1800                	addi	s0,sp,48
    80001a64:	892a                	mv	s2,a0
    80001a66:	84ae                	mv	s1,a1
    80001a68:	89b2                	mv	s3,a2
    80001a6a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	52a080e7          	jalr	1322(ra) # 80000f96 <myproc>
  if(user_src){
    80001a74:	c08d                	beqz	s1,80001a96 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a76:	86d2                	mv	a3,s4
    80001a78:	864e                	mv	a2,s3
    80001a7a:	85ca                	mv	a1,s2
    80001a7c:	6928                	ld	a0,80(a0)
    80001a7e:	fffff097          	auipc	ra,0xfffff
    80001a82:	16a080e7          	jalr	362(ra) # 80000be8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a86:	70a2                	ld	ra,40(sp)
    80001a88:	7402                	ld	s0,32(sp)
    80001a8a:	64e2                	ld	s1,24(sp)
    80001a8c:	6942                	ld	s2,16(sp)
    80001a8e:	69a2                	ld	s3,8(sp)
    80001a90:	6a02                	ld	s4,0(sp)
    80001a92:	6145                	addi	sp,sp,48
    80001a94:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a96:	000a061b          	sext.w	a2,s4
    80001a9a:	85ce                	mv	a1,s3
    80001a9c:	854a                	mv	a0,s2
    80001a9e:	ffffe097          	auipc	ra,0xffffe
    80001aa2:	78c080e7          	jalr	1932(ra) # 8000022a <memmove>
    return 0;
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	bff9                	j	80001a86 <either_copyin+0x32>

0000000080001aaa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aaa:	715d                	addi	sp,sp,-80
    80001aac:	e486                	sd	ra,72(sp)
    80001aae:	e0a2                	sd	s0,64(sp)
    80001ab0:	fc26                	sd	s1,56(sp)
    80001ab2:	f84a                	sd	s2,48(sp)
    80001ab4:	f44e                	sd	s3,40(sp)
    80001ab6:	f052                	sd	s4,32(sp)
    80001ab8:	ec56                	sd	s5,24(sp)
    80001aba:	e85a                	sd	s6,16(sp)
    80001abc:	e45e                	sd	s7,8(sp)
    80001abe:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac0:	00006517          	auipc	a0,0x6
    80001ac4:	58850513          	addi	a0,a0,1416 # 80008048 <etext+0x48>
    80001ac8:	00004097          	auipc	ra,0x4
    80001acc:	2ea080e7          	jalr	746(ra) # 80005db2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad0:	00008497          	auipc	s1,0x8
    80001ad4:	b0848493          	addi	s1,s1,-1272 # 800095d8 <proc+0x158>
    80001ad8:	0000d917          	auipc	s2,0xd
    80001adc:	50090913          	addi	s2,s2,1280 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ae2:	00006997          	auipc	s3,0x6
    80001ae6:	75698993          	addi	s3,s3,1878 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001aea:	00006a97          	auipc	s5,0x6
    80001aee:	756a8a93          	addi	s5,s5,1878 # 80008240 <etext+0x240>
    printf("\n");
    80001af2:	00006a17          	auipc	s4,0x6
    80001af6:	556a0a13          	addi	s4,s4,1366 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001afa:	00006b97          	auipc	s7,0x6
    80001afe:	77eb8b93          	addi	s7,s7,1918 # 80008278 <states.1716>
    80001b02:	a00d                	j	80001b24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b04:	ed86a583          	lw	a1,-296(a3)
    80001b08:	8556                	mv	a0,s5
    80001b0a:	00004097          	auipc	ra,0x4
    80001b0e:	2a8080e7          	jalr	680(ra) # 80005db2 <printf>
    printf("\n");
    80001b12:	8552                	mv	a0,s4
    80001b14:	00004097          	auipc	ra,0x4
    80001b18:	29e080e7          	jalr	670(ra) # 80005db2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b1c:	16848493          	addi	s1,s1,360
    80001b20:	03248163          	beq	s1,s2,80001b42 <procdump+0x98>
    if(p->state == UNUSED)
    80001b24:	86a6                	mv	a3,s1
    80001b26:	ec04a783          	lw	a5,-320(s1)
    80001b2a:	dbed                	beqz	a5,80001b1c <procdump+0x72>
      state = "???";
    80001b2c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b2e:	fcfb6be3          	bltu	s6,a5,80001b04 <procdump+0x5a>
    80001b32:	1782                	slli	a5,a5,0x20
    80001b34:	9381                	srli	a5,a5,0x20
    80001b36:	078e                	slli	a5,a5,0x3
    80001b38:	97de                	add	a5,a5,s7
    80001b3a:	6390                	ld	a2,0(a5)
    80001b3c:	f661                	bnez	a2,80001b04 <procdump+0x5a>
      state = "???";
    80001b3e:	864e                	mv	a2,s3
    80001b40:	b7d1                	j	80001b04 <procdump+0x5a>
  }
}
    80001b42:	60a6                	ld	ra,72(sp)
    80001b44:	6406                	ld	s0,64(sp)
    80001b46:	74e2                	ld	s1,56(sp)
    80001b48:	7942                	ld	s2,48(sp)
    80001b4a:	79a2                	ld	s3,40(sp)
    80001b4c:	7a02                	ld	s4,32(sp)
    80001b4e:	6ae2                	ld	s5,24(sp)
    80001b50:	6b42                	ld	s6,16(sp)
    80001b52:	6ba2                	ld	s7,8(sp)
    80001b54:	6161                	addi	sp,sp,80
    80001b56:	8082                	ret

0000000080001b58 <procnum>:

void
procnum(uint64* dst)
{
    80001b58:	1141                	addi	sp,sp,-16
    80001b5a:	e422                	sd	s0,8(sp)
    80001b5c:	0800                	addi	s0,sp,16
  *dst = 0;
    80001b5e:	00053023          	sd	zero,0(a0)
  struct proc* p;
  // 不需要锁进程 proc 结构，因为我们只需要读取进程列表，不需要写
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b62:	00008797          	auipc	a5,0x8
    80001b66:	91e78793          	addi	a5,a5,-1762 # 80009480 <proc>
    80001b6a:	0000d697          	auipc	a3,0xd
    80001b6e:	31668693          	addi	a3,a3,790 # 8000ee80 <tickslock>
    80001b72:	a029                	j	80001b7c <procnum+0x24>
    80001b74:	16878793          	addi	a5,a5,360
    80001b78:	00d78863          	beq	a5,a3,80001b88 <procnum+0x30>
    // 不是 UNUSED 的进程位，就是已经分配的
    if (p->state != UNUSED)
    80001b7c:	4f98                	lw	a4,24(a5)
    80001b7e:	db7d                	beqz	a4,80001b74 <procnum+0x1c>
      (*dst)++;
    80001b80:	6118                	ld	a4,0(a0)
    80001b82:	0705                	addi	a4,a4,1
    80001b84:	e118                	sd	a4,0(a0)
    80001b86:	b7fd                	j	80001b74 <procnum+0x1c>
  }
}
    80001b88:	6422                	ld	s0,8(sp)
    80001b8a:	0141                	addi	sp,sp,16
    80001b8c:	8082                	ret

0000000080001b8e <swtch>:
    80001b8e:	00153023          	sd	ra,0(a0)
    80001b92:	00253423          	sd	sp,8(a0)
    80001b96:	e900                	sd	s0,16(a0)
    80001b98:	ed04                	sd	s1,24(a0)
    80001b9a:	03253023          	sd	s2,32(a0)
    80001b9e:	03353423          	sd	s3,40(a0)
    80001ba2:	03453823          	sd	s4,48(a0)
    80001ba6:	03553c23          	sd	s5,56(a0)
    80001baa:	05653023          	sd	s6,64(a0)
    80001bae:	05753423          	sd	s7,72(a0)
    80001bb2:	05853823          	sd	s8,80(a0)
    80001bb6:	05953c23          	sd	s9,88(a0)
    80001bba:	07a53023          	sd	s10,96(a0)
    80001bbe:	07b53423          	sd	s11,104(a0)
    80001bc2:	0005b083          	ld	ra,0(a1)
    80001bc6:	0085b103          	ld	sp,8(a1)
    80001bca:	6980                	ld	s0,16(a1)
    80001bcc:	6d84                	ld	s1,24(a1)
    80001bce:	0205b903          	ld	s2,32(a1)
    80001bd2:	0285b983          	ld	s3,40(a1)
    80001bd6:	0305ba03          	ld	s4,48(a1)
    80001bda:	0385ba83          	ld	s5,56(a1)
    80001bde:	0405bb03          	ld	s6,64(a1)
    80001be2:	0485bb83          	ld	s7,72(a1)
    80001be6:	0505bc03          	ld	s8,80(a1)
    80001bea:	0585bc83          	ld	s9,88(a1)
    80001bee:	0605bd03          	ld	s10,96(a1)
    80001bf2:	0685bd83          	ld	s11,104(a1)
    80001bf6:	8082                	ret

0000000080001bf8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bf8:	1141                	addi	sp,sp,-16
    80001bfa:	e406                	sd	ra,8(sp)
    80001bfc:	e022                	sd	s0,0(sp)
    80001bfe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c00:	00006597          	auipc	a1,0x6
    80001c04:	6a858593          	addi	a1,a1,1704 # 800082a8 <states.1716+0x30>
    80001c08:	0000d517          	auipc	a0,0xd
    80001c0c:	27850513          	addi	a0,a0,632 # 8000ee80 <tickslock>
    80001c10:	00004097          	auipc	ra,0x4
    80001c14:	612080e7          	jalr	1554(ra) # 80006222 <initlock>
}
    80001c18:	60a2                	ld	ra,8(sp)
    80001c1a:	6402                	ld	s0,0(sp)
    80001c1c:	0141                	addi	sp,sp,16
    80001c1e:	8082                	ret

0000000080001c20 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c20:	1141                	addi	sp,sp,-16
    80001c22:	e422                	sd	s0,8(sp)
    80001c24:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c26:	00003797          	auipc	a5,0x3
    80001c2a:	54a78793          	addi	a5,a5,1354 # 80005170 <kernelvec>
    80001c2e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c32:	6422                	ld	s0,8(sp)
    80001c34:	0141                	addi	sp,sp,16
    80001c36:	8082                	ret

0000000080001c38 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c38:	1141                	addi	sp,sp,-16
    80001c3a:	e406                	sd	ra,8(sp)
    80001c3c:	e022                	sd	s0,0(sp)
    80001c3e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	356080e7          	jalr	854(ra) # 80000f96 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c4e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c52:	00005617          	auipc	a2,0x5
    80001c56:	3ae60613          	addi	a2,a2,942 # 80007000 <_trampoline>
    80001c5a:	00005697          	auipc	a3,0x5
    80001c5e:	3a668693          	addi	a3,a3,934 # 80007000 <_trampoline>
    80001c62:	8e91                	sub	a3,a3,a2
    80001c64:	040007b7          	lui	a5,0x4000
    80001c68:	17fd                	addi	a5,a5,-1
    80001c6a:	07b2                	slli	a5,a5,0xc
    80001c6c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c6e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c72:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c74:	180026f3          	csrr	a3,satp
    80001c78:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c7a:	6d38                	ld	a4,88(a0)
    80001c7c:	6134                	ld	a3,64(a0)
    80001c7e:	6585                	lui	a1,0x1
    80001c80:	96ae                	add	a3,a3,a1
    80001c82:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c84:	6d38                	ld	a4,88(a0)
    80001c86:	00000697          	auipc	a3,0x0
    80001c8a:	13868693          	addi	a3,a3,312 # 80001dbe <usertrap>
    80001c8e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c90:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c92:	8692                	mv	a3,tp
    80001c94:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c9a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c9e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ca6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ca8:	6f18                	ld	a4,24(a4)
    80001caa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cae:	692c                	ld	a1,80(a0)
    80001cb0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cb2:	00005717          	auipc	a4,0x5
    80001cb6:	3de70713          	addi	a4,a4,990 # 80007090 <userret>
    80001cba:	8f11                	sub	a4,a4,a2
    80001cbc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cbe:	577d                	li	a4,-1
    80001cc0:	177e                	slli	a4,a4,0x3f
    80001cc2:	8dd9                	or	a1,a1,a4
    80001cc4:	02000537          	lui	a0,0x2000
    80001cc8:	157d                	addi	a0,a0,-1
    80001cca:	0536                	slli	a0,a0,0xd
    80001ccc:	9782                	jalr	a5
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret

0000000080001cd6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	e426                	sd	s1,8(sp)
    80001cde:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ce0:	0000d497          	auipc	s1,0xd
    80001ce4:	1a048493          	addi	s1,s1,416 # 8000ee80 <tickslock>
    80001ce8:	8526                	mv	a0,s1
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	5c8080e7          	jalr	1480(ra) # 800062b2 <acquire>
  ticks++;
    80001cf2:	00007517          	auipc	a0,0x7
    80001cf6:	32650513          	addi	a0,a0,806 # 80009018 <ticks>
    80001cfa:	411c                	lw	a5,0(a0)
    80001cfc:	2785                	addiw	a5,a5,1
    80001cfe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	ae6080e7          	jalr	-1306(ra) # 800017e6 <wakeup>
  release(&tickslock);
    80001d08:	8526                	mv	a0,s1
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	65c080e7          	jalr	1628(ra) # 80006366 <release>
}
    80001d12:	60e2                	ld	ra,24(sp)
    80001d14:	6442                	ld	s0,16(sp)
    80001d16:	64a2                	ld	s1,8(sp)
    80001d18:	6105                	addi	sp,sp,32
    80001d1a:	8082                	ret

0000000080001d1c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d1c:	1101                	addi	sp,sp,-32
    80001d1e:	ec06                	sd	ra,24(sp)
    80001d20:	e822                	sd	s0,16(sp)
    80001d22:	e426                	sd	s1,8(sp)
    80001d24:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d26:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d2a:	00074d63          	bltz	a4,80001d44 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d2e:	57fd                	li	a5,-1
    80001d30:	17fe                	slli	a5,a5,0x3f
    80001d32:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d34:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d36:	06f70363          	beq	a4,a5,80001d9c <devintr+0x80>
  }
}
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	64a2                	ld	s1,8(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
     (scause & 0xff) == 9){
    80001d44:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d48:	46a5                	li	a3,9
    80001d4a:	fed792e3          	bne	a5,a3,80001d2e <devintr+0x12>
    int irq = plic_claim();
    80001d4e:	00003097          	auipc	ra,0x3
    80001d52:	52a080e7          	jalr	1322(ra) # 80005278 <plic_claim>
    80001d56:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d58:	47a9                	li	a5,10
    80001d5a:	02f50763          	beq	a0,a5,80001d88 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d5e:	4785                	li	a5,1
    80001d60:	02f50963          	beq	a0,a5,80001d92 <devintr+0x76>
    return 1;
    80001d64:	4505                	li	a0,1
    } else if(irq){
    80001d66:	d8f1                	beqz	s1,80001d3a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d68:	85a6                	mv	a1,s1
    80001d6a:	00006517          	auipc	a0,0x6
    80001d6e:	54650513          	addi	a0,a0,1350 # 800082b0 <states.1716+0x38>
    80001d72:	00004097          	auipc	ra,0x4
    80001d76:	040080e7          	jalr	64(ra) # 80005db2 <printf>
      plic_complete(irq);
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	00003097          	auipc	ra,0x3
    80001d80:	520080e7          	jalr	1312(ra) # 8000529c <plic_complete>
    return 1;
    80001d84:	4505                	li	a0,1
    80001d86:	bf55                	j	80001d3a <devintr+0x1e>
      uartintr();
    80001d88:	00004097          	auipc	ra,0x4
    80001d8c:	44a080e7          	jalr	1098(ra) # 800061d2 <uartintr>
    80001d90:	b7ed                	j	80001d7a <devintr+0x5e>
      virtio_disk_intr();
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	9ea080e7          	jalr	-1558(ra) # 8000577c <virtio_disk_intr>
    80001d9a:	b7c5                	j	80001d7a <devintr+0x5e>
    if(cpuid() == 0){
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	1ce080e7          	jalr	462(ra) # 80000f6a <cpuid>
    80001da4:	c901                	beqz	a0,80001db4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001da6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001daa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dac:	14479073          	csrw	sip,a5
    return 2;
    80001db0:	4509                	li	a0,2
    80001db2:	b761                	j	80001d3a <devintr+0x1e>
      clockintr();
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	f22080e7          	jalr	-222(ra) # 80001cd6 <clockintr>
    80001dbc:	b7ed                	j	80001da6 <devintr+0x8a>

0000000080001dbe <usertrap>:
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	e04a                	sd	s2,0(sp)
    80001dc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dca:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dce:	1007f793          	andi	a5,a5,256
    80001dd2:	e3ad                	bnez	a5,80001e34 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dd4:	00003797          	auipc	a5,0x3
    80001dd8:	39c78793          	addi	a5,a5,924 # 80005170 <kernelvec>
    80001ddc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	1b6080e7          	jalr	438(ra) # 80000f96 <myproc>
    80001de8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dea:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dec:	14102773          	csrr	a4,sepc
    80001df0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001df6:	47a1                	li	a5,8
    80001df8:	04f71c63          	bne	a4,a5,80001e50 <usertrap+0x92>
    if(p->killed)
    80001dfc:	551c                	lw	a5,40(a0)
    80001dfe:	e3b9                	bnez	a5,80001e44 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e00:	6cb8                	ld	a4,88(s1)
    80001e02:	6f1c                	ld	a5,24(a4)
    80001e04:	0791                	addi	a5,a5,4
    80001e06:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e10:	10079073          	csrw	sstatus,a5
    syscall();
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	2e0080e7          	jalr	736(ra) # 800020f4 <syscall>
  if(p->killed)
    80001e1c:	549c                	lw	a5,40(s1)
    80001e1e:	ebc1                	bnez	a5,80001eae <usertrap+0xf0>
  usertrapret();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	e18080e7          	jalr	-488(ra) # 80001c38 <usertrapret>
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	64a2                	ld	s1,8(sp)
    80001e2e:	6902                	ld	s2,0(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret
    panic("usertrap: not from user mode");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	49c50513          	addi	a0,a0,1180 # 800082d0 <states.1716+0x58>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	f2c080e7          	jalr	-212(ra) # 80005d68 <panic>
      exit(-1);
    80001e44:	557d                	li	a0,-1
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	a70080e7          	jalr	-1424(ra) # 800018b6 <exit>
    80001e4e:	bf4d                	j	80001e00 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	ecc080e7          	jalr	-308(ra) # 80001d1c <devintr>
    80001e58:	892a                	mv	s2,a0
    80001e5a:	c501                	beqz	a0,80001e62 <usertrap+0xa4>
  if(p->killed)
    80001e5c:	549c                	lw	a5,40(s1)
    80001e5e:	c3a1                	beqz	a5,80001e9e <usertrap+0xe0>
    80001e60:	a815                	j	80001e94 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e62:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e66:	5890                	lw	a2,48(s1)
    80001e68:	00006517          	auipc	a0,0x6
    80001e6c:	48850513          	addi	a0,a0,1160 # 800082f0 <states.1716+0x78>
    80001e70:	00004097          	auipc	ra,0x4
    80001e74:	f42080e7          	jalr	-190(ra) # 80005db2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e7c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e80:	00006517          	auipc	a0,0x6
    80001e84:	4a050513          	addi	a0,a0,1184 # 80008320 <states.1716+0xa8>
    80001e88:	00004097          	auipc	ra,0x4
    80001e8c:	f2a080e7          	jalr	-214(ra) # 80005db2 <printf>
    p->killed = 1;
    80001e90:	4785                	li	a5,1
    80001e92:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e94:	557d                	li	a0,-1
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	a20080e7          	jalr	-1504(ra) # 800018b6 <exit>
  if(which_dev == 2)
    80001e9e:	4789                	li	a5,2
    80001ea0:	f8f910e3          	bne	s2,a5,80001e20 <usertrap+0x62>
    yield();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	77a080e7          	jalr	1914(ra) # 8000161e <yield>
    80001eac:	bf95                	j	80001e20 <usertrap+0x62>
  int which_dev = 0;
    80001eae:	4901                	li	s2,0
    80001eb0:	b7d5                	j	80001e94 <usertrap+0xd6>

0000000080001eb2 <kerneltrap>:
{
    80001eb2:	7179                	addi	sp,sp,-48
    80001eb4:	f406                	sd	ra,40(sp)
    80001eb6:	f022                	sd	s0,32(sp)
    80001eb8:	ec26                	sd	s1,24(sp)
    80001eba:	e84a                	sd	s2,16(sp)
    80001ebc:	e44e                	sd	s3,8(sp)
    80001ebe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ecc:	1004f793          	andi	a5,s1,256
    80001ed0:	cb85                	beqz	a5,80001f00 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ed6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ed8:	ef85                	bnez	a5,80001f10 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	e42080e7          	jalr	-446(ra) # 80001d1c <devintr>
    80001ee2:	cd1d                	beqz	a0,80001f20 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee4:	4789                	li	a5,2
    80001ee6:	06f50a63          	beq	a0,a5,80001f5a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eea:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eee:	10049073          	csrw	sstatus,s1
}
    80001ef2:	70a2                	ld	ra,40(sp)
    80001ef4:	7402                	ld	s0,32(sp)
    80001ef6:	64e2                	ld	s1,24(sp)
    80001ef8:	6942                	ld	s2,16(sp)
    80001efa:	69a2                	ld	s3,8(sp)
    80001efc:	6145                	addi	sp,sp,48
    80001efe:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	44050513          	addi	a0,a0,1088 # 80008340 <states.1716+0xc8>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	e60080e7          	jalr	-416(ra) # 80005d68 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f10:	00006517          	auipc	a0,0x6
    80001f14:	45850513          	addi	a0,a0,1112 # 80008368 <states.1716+0xf0>
    80001f18:	00004097          	auipc	ra,0x4
    80001f1c:	e50080e7          	jalr	-432(ra) # 80005d68 <panic>
    printf("scause %p\n", scause);
    80001f20:	85ce                	mv	a1,s3
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	46650513          	addi	a0,a0,1126 # 80008388 <states.1716+0x110>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	e88080e7          	jalr	-376(ra) # 80005db2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f32:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f36:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f3a:	00006517          	auipc	a0,0x6
    80001f3e:	45e50513          	addi	a0,a0,1118 # 80008398 <states.1716+0x120>
    80001f42:	00004097          	auipc	ra,0x4
    80001f46:	e70080e7          	jalr	-400(ra) # 80005db2 <printf>
    panic("kerneltrap");
    80001f4a:	00006517          	auipc	a0,0x6
    80001f4e:	46650513          	addi	a0,a0,1126 # 800083b0 <states.1716+0x138>
    80001f52:	00004097          	auipc	ra,0x4
    80001f56:	e16080e7          	jalr	-490(ra) # 80005d68 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	03c080e7          	jalr	60(ra) # 80000f96 <myproc>
    80001f62:	d541                	beqz	a0,80001eea <kerneltrap+0x38>
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	032080e7          	jalr	50(ra) # 80000f96 <myproc>
    80001f6c:	4d18                	lw	a4,24(a0)
    80001f6e:	4791                	li	a5,4
    80001f70:	f6f71de3          	bne	a4,a5,80001eea <kerneltrap+0x38>
    yield();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	6aa080e7          	jalr	1706(ra) # 8000161e <yield>
    80001f7c:	b7bd                	j	80001eea <kerneltrap+0x38>

0000000080001f7e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f7e:	1101                	addi	sp,sp,-32
    80001f80:	ec06                	sd	ra,24(sp)
    80001f82:	e822                	sd	s0,16(sp)
    80001f84:	e426                	sd	s1,8(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	84aa                	mv	s1,a0
  struct proc* p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	00c080e7          	jalr	12(ra) # 80000f96 <myproc>
  switch (n) {
    80001f92:	4795                	li	a5,5
    80001f94:	0497e163          	bltu	a5,s1,80001fd6 <argraw+0x58>
    80001f98:	048a                	slli	s1,s1,0x2
    80001f9a:	00006717          	auipc	a4,0x6
    80001f9e:	51e70713          	addi	a4,a4,1310 # 800084b8 <states.1716+0x240>
    80001fa2:	94ba                	add	s1,s1,a4
    80001fa4:	409c                	lw	a5,0(s1)
    80001fa6:	97ba                	add	a5,a5,a4
    80001fa8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001faa:	6d3c                	ld	a5,88(a0)
    80001fac:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret
    return p->trapframe->a1;
    80001fb8:	6d3c                	ld	a5,88(a0)
    80001fba:	7fa8                	ld	a0,120(a5)
    80001fbc:	bfcd                	j	80001fae <argraw+0x30>
    return p->trapframe->a2;
    80001fbe:	6d3c                	ld	a5,88(a0)
    80001fc0:	63c8                	ld	a0,128(a5)
    80001fc2:	b7f5                	j	80001fae <argraw+0x30>
    return p->trapframe->a3;
    80001fc4:	6d3c                	ld	a5,88(a0)
    80001fc6:	67c8                	ld	a0,136(a5)
    80001fc8:	b7dd                	j	80001fae <argraw+0x30>
    return p->trapframe->a4;
    80001fca:	6d3c                	ld	a5,88(a0)
    80001fcc:	6bc8                	ld	a0,144(a5)
    80001fce:	b7c5                	j	80001fae <argraw+0x30>
    return p->trapframe->a5;
    80001fd0:	6d3c                	ld	a5,88(a0)
    80001fd2:	6fc8                	ld	a0,152(a5)
    80001fd4:	bfe9                	j	80001fae <argraw+0x30>
  panic("argraw");
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	3ea50513          	addi	a0,a0,1002 # 800083c0 <states.1716+0x148>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	d8a080e7          	jalr	-630(ra) # 80005d68 <panic>

0000000080001fe6 <fetchaddr>:
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	addi	s0,sp,32
    80001ff2:	84aa                	mv	s1,a0
    80001ff4:	892e                	mv	s2,a1
  struct proc* p = myproc();
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	fa0080e7          	jalr	-96(ra) # 80000f96 <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80001ffe:	653c                	ld	a5,72(a0)
    80002000:	02f4f863          	bgeu	s1,a5,80002030 <fetchaddr+0x4a>
    80002004:	00848713          	addi	a4,s1,8
    80002008:	02e7e663          	bltu	a5,a4,80002034 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char*)ip, addr, sizeof(*ip)) != 0)
    8000200c:	46a1                	li	a3,8
    8000200e:	8626                	mv	a2,s1
    80002010:	85ca                	mv	a1,s2
    80002012:	6928                	ld	a0,80(a0)
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	bd4080e7          	jalr	-1068(ra) # 80000be8 <copyin>
    8000201c:	00a03533          	snez	a0,a0
    80002020:	40a00533          	neg	a0,a0
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6902                	ld	s2,0(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret
    return -1;
    80002030:	557d                	li	a0,-1
    80002032:	bfcd                	j	80002024 <fetchaddr+0x3e>
    80002034:	557d                	li	a0,-1
    80002036:	b7fd                	j	80002024 <fetchaddr+0x3e>

0000000080002038 <fetchstr>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	addi	s0,sp,48
    80002046:	892a                	mv	s2,a0
    80002048:	84ae                	mv	s1,a1
    8000204a:	89b2                	mv	s3,a2
  struct proc* p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	f4a080e7          	jalr	-182(ra) # 80000f96 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002054:	86ce                	mv	a3,s3
    80002056:	864a                	mv	a2,s2
    80002058:	85a6                	mv	a1,s1
    8000205a:	6928                	ld	a0,80(a0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	c18080e7          	jalr	-1000(ra) # 80000c74 <copyinstr>
  if (err < 0)
    80002064:	00054763          	bltz	a0,80002072 <fetchstr+0x3a>
  return strlen(buf);
    80002068:	8526                	mv	a0,s1
    8000206a:	ffffe097          	auipc	ra,0xffffe
    8000206e:	2e4080e7          	jalr	740(ra) # 8000034e <strlen>
}
    80002072:	70a2                	ld	ra,40(sp)
    80002074:	7402                	ld	s0,32(sp)
    80002076:	64e2                	ld	s1,24(sp)
    80002078:	6942                	ld	s2,16(sp)
    8000207a:	69a2                	ld	s3,8(sp)
    8000207c:	6145                	addi	sp,sp,48
    8000207e:	8082                	ret

0000000080002080 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int* ip)
{
    80002080:	1101                	addi	sp,sp,-32
    80002082:	ec06                	sd	ra,24(sp)
    80002084:	e822                	sd	s0,16(sp)
    80002086:	e426                	sd	s1,8(sp)
    80002088:	1000                	addi	s0,sp,32
    8000208a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	ef2080e7          	jalr	-270(ra) # 80001f7e <argraw>
    80002094:	c088                	sw	a0,0(s1)
  return 0;
}
    80002096:	4501                	li	a0,0
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret

00000000800020a2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64* ip)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	ed0080e7          	jalr	-304(ra) # 80001f7e <argraw>
    800020b6:	e088                	sd	a0,0(s1)
  return 0;
}
    800020b8:	4501                	li	a0,0
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	64a2                	ld	s1,8(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char* buf, int max)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	e04a                	sd	s2,0(sp)
    800020ce:	1000                	addi	s0,sp,32
    800020d0:	84ae                	mv	s1,a1
    800020d2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	eaa080e7          	jalr	-342(ra) # 80001f7e <argraw>
  uint64 addr;
  if (argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020dc:	864a                	mv	a2,s2
    800020de:	85a6                	mv	a1,s1
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	f58080e7          	jalr	-168(ra) # 80002038 <fetchstr>
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6902                	ld	s2,0(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <syscall>:
[SYS_sysinfo] sys_sysinfo,
};

void
syscall(void)
{
    800020f4:	7179                	addi	sp,sp,-48
    800020f6:	f406                	sd	ra,40(sp)
    800020f8:	f022                	sd	s0,32(sp)
    800020fa:	ec26                	sd	s1,24(sp)
    800020fc:	e84a                	sd	s2,16(sp)
    800020fe:	e44e                	sd	s3,8(sp)
    80002100:	1800                	addi	s0,sp,48
  int num;
  struct proc* p = myproc();
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	e94080e7          	jalr	-364(ra) # 80000f96 <myproc>
    8000210a:	84aa                	mv	s1,a0
  num = p->trapframe->a7;  // 系统调用编号，参见书中4.3节
    8000210c:	05853903          	ld	s2,88(a0)
    80002110:	0a893783          	ld	a5,168(s2)
    80002114:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002118:	37fd                	addiw	a5,a5,-1
    8000211a:	4759                	li	a4,22
    8000211c:	04f76763          	bltu	a4,a5,8000216a <syscall+0x76>
    80002120:	00399713          	slli	a4,s3,0x3
    80002124:	00006797          	auipc	a5,0x6
    80002128:	3ac78793          	addi	a5,a5,940 # 800084d0 <syscalls>
    8000212c:	97ba                	add	a5,a5,a4
    8000212e:	639c                	ld	a5,0(a5)
    80002130:	cf8d                	beqz	a5,8000216a <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();  // 执行系统调用，然后将返回值存入a0
    80002132:	9782                	jalr	a5
    80002134:	06a93823          	sd	a0,112(s2)

    //系统调用是否匹配 -- 位运算判断
    //如果我们要追踪read,那么trace_mask的值为32,也就是10000
    //假如当前系统调用号为5,那么1左移五位为: 10000
    //此时相与得到1,说明是我们需要追踪的系统调用,则进行打点记录
    if ((1 << num) & p->trace_mask)
    80002138:	58dc                	lw	a5,52(s1)
    8000213a:	4137d7bb          	sraw	a5,a5,s3
    8000213e:	8b85                	andi	a5,a5,1
    80002140:	c7a1                	beqz	a5,80002188 <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    80002142:	6cb8                	ld	a4,88(s1)
    80002144:	098e                	slli	s3,s3,0x3
    80002146:	00006797          	auipc	a5,0x6
    8000214a:	38a78793          	addi	a5,a5,906 # 800084d0 <syscalls>
    8000214e:	99be                	add	s3,s3,a5
    80002150:	7b34                	ld	a3,112(a4)
    80002152:	0c09b603          	ld	a2,192(s3)
    80002156:	588c                	lw	a1,48(s1)
    80002158:	00006517          	auipc	a0,0x6
    8000215c:	27050513          	addi	a0,a0,624 # 800083c8 <states.1716+0x150>
    80002160:	00004097          	auipc	ra,0x4
    80002164:	c52080e7          	jalr	-942(ra) # 80005db2 <printf>
    80002168:	a005                	j	80002188 <syscall+0x94>
  }
  else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    8000216a:	86ce                	mv	a3,s3
    8000216c:	15848613          	addi	a2,s1,344
    80002170:	588c                	lw	a1,48(s1)
    80002172:	00006517          	auipc	a0,0x6
    80002176:	26e50513          	addi	a0,a0,622 # 800083e0 <states.1716+0x168>
    8000217a:	00004097          	auipc	ra,0x4
    8000217e:	c38080e7          	jalr	-968(ra) # 80005db2 <printf>
    p->trapframe->a0 = -1;
    80002182:	6cbc                	ld	a5,88(s1)
    80002184:	577d                	li	a4,-1
    80002186:	fbb8                	sd	a4,112(a5)
  }
}
    80002188:	70a2                	ld	ra,40(sp)
    8000218a:	7402                	ld	s0,32(sp)
    8000218c:	64e2                	ld	s1,24(sp)
    8000218e:	6942                	ld	s2,16(sp)
    80002190:	69a2                	ld	s3,8(sp)
    80002192:	6145                	addi	sp,sp,48
    80002194:	8082                	ret

0000000080002196 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002196:	1101                	addi	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000219e:	fec40593          	addi	a1,s0,-20
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	edc080e7          	jalr	-292(ra) # 80002080 <argint>
    return -1;
    800021ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ae:	00054963          	bltz	a0,800021c0 <sys_exit+0x2a>
  exit(n);
    800021b2:	fec42503          	lw	a0,-20(s0)
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	700080e7          	jalr	1792(ra) # 800018b6 <exit>
  return 0;  // not reached
    800021be:	4781                	li	a5,0
}
    800021c0:	853e                	mv	a0,a5
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	6105                	addi	sp,sp,32
    800021c8:	8082                	ret

00000000800021ca <sys_getpid>:

uint64
sys_getpid(void)
{
    800021ca:	1141                	addi	sp,sp,-16
    800021cc:	e406                	sd	ra,8(sp)
    800021ce:	e022                	sd	s0,0(sp)
    800021d0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	dc4080e7          	jalr	-572(ra) # 80000f96 <myproc>
}
    800021da:	5908                	lw	a0,48(a0)
    800021dc:	60a2                	ld	ra,8(sp)
    800021de:	6402                	ld	s0,0(sp)
    800021e0:	0141                	addi	sp,sp,16
    800021e2:	8082                	ret

00000000800021e4 <sys_fork>:

uint64
sys_fork(void)
{
    800021e4:	1141                	addi	sp,sp,-16
    800021e6:	e406                	sd	ra,8(sp)
    800021e8:	e022                	sd	s0,0(sp)
    800021ea:	0800                	addi	s0,sp,16
  return fork();
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	178080e7          	jalr	376(ra) # 80001364 <fork>
}
    800021f4:	60a2                	ld	ra,8(sp)
    800021f6:	6402                	ld	s0,0(sp)
    800021f8:	0141                	addi	sp,sp,16
    800021fa:	8082                	ret

00000000800021fc <sys_wait>:

uint64
sys_wait(void)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002204:	fe840593          	addi	a1,s0,-24
    80002208:	4501                	li	a0,0
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	e98080e7          	jalr	-360(ra) # 800020a2 <argaddr>
    80002212:	87aa                	mv	a5,a0
    return -1;
    80002214:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002216:	0007c863          	bltz	a5,80002226 <sys_wait+0x2a>
  return wait(p);
    8000221a:	fe843503          	ld	a0,-24(s0)
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	4a0080e7          	jalr	1184(ra) # 800016be <wait>
}
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	6105                	addi	sp,sp,32
    8000222c:	8082                	ret

000000008000222e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002238:	fdc40593          	addi	a1,s0,-36
    8000223c:	4501                	li	a0,0
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	e42080e7          	jalr	-446(ra) # 80002080 <argint>
    80002246:	87aa                	mv	a5,a0
    return -1;
    80002248:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000224a:	0207c063          	bltz	a5,8000226a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	d48080e7          	jalr	-696(ra) # 80000f96 <myproc>
    80002256:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002258:	fdc42503          	lw	a0,-36(s0)
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	094080e7          	jalr	148(ra) # 800012f0 <growproc>
    80002264:	00054863          	bltz	a0,80002274 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002268:	8526                	mv	a0,s1
}
    8000226a:	70a2                	ld	ra,40(sp)
    8000226c:	7402                	ld	s0,32(sp)
    8000226e:	64e2                	ld	s1,24(sp)
    80002270:	6145                	addi	sp,sp,48
    80002272:	8082                	ret
    return -1;
    80002274:	557d                	li	a0,-1
    80002276:	bfd5                	j	8000226a <sys_sbrk+0x3c>

0000000080002278 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002278:	7139                	addi	sp,sp,-64
    8000227a:	fc06                	sd	ra,56(sp)
    8000227c:	f822                	sd	s0,48(sp)
    8000227e:	f426                	sd	s1,40(sp)
    80002280:	f04a                	sd	s2,32(sp)
    80002282:	ec4e                	sd	s3,24(sp)
    80002284:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002286:	fcc40593          	addi	a1,s0,-52
    8000228a:	4501                	li	a0,0
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	df4080e7          	jalr	-524(ra) # 80002080 <argint>
    return -1;
    80002294:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002296:	06054563          	bltz	a0,80002300 <sys_sleep+0x88>
  acquire(&tickslock);
    8000229a:	0000d517          	auipc	a0,0xd
    8000229e:	be650513          	addi	a0,a0,-1050 # 8000ee80 <tickslock>
    800022a2:	00004097          	auipc	ra,0x4
    800022a6:	010080e7          	jalr	16(ra) # 800062b2 <acquire>
  ticks0 = ticks;
    800022aa:	00007917          	auipc	s2,0x7
    800022ae:	d6e92903          	lw	s2,-658(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022b2:	fcc42783          	lw	a5,-52(s0)
    800022b6:	cf85                	beqz	a5,800022ee <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022b8:	0000d997          	auipc	s3,0xd
    800022bc:	bc898993          	addi	s3,s3,-1080 # 8000ee80 <tickslock>
    800022c0:	00007497          	auipc	s1,0x7
    800022c4:	d5848493          	addi	s1,s1,-680 # 80009018 <ticks>
    if(myproc()->killed){
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	cce080e7          	jalr	-818(ra) # 80000f96 <myproc>
    800022d0:	551c                	lw	a5,40(a0)
    800022d2:	ef9d                	bnez	a5,80002310 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022d4:	85ce                	mv	a1,s3
    800022d6:	8526                	mv	a0,s1
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	382080e7          	jalr	898(ra) # 8000165a <sleep>
  while(ticks - ticks0 < n){
    800022e0:	409c                	lw	a5,0(s1)
    800022e2:	412787bb          	subw	a5,a5,s2
    800022e6:	fcc42703          	lw	a4,-52(s0)
    800022ea:	fce7efe3          	bltu	a5,a4,800022c8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022ee:	0000d517          	auipc	a0,0xd
    800022f2:	b9250513          	addi	a0,a0,-1134 # 8000ee80 <tickslock>
    800022f6:	00004097          	auipc	ra,0x4
    800022fa:	070080e7          	jalr	112(ra) # 80006366 <release>
  return 0;
    800022fe:	4781                	li	a5,0
}
    80002300:	853e                	mv	a0,a5
    80002302:	70e2                	ld	ra,56(sp)
    80002304:	7442                	ld	s0,48(sp)
    80002306:	74a2                	ld	s1,40(sp)
    80002308:	7902                	ld	s2,32(sp)
    8000230a:	69e2                	ld	s3,24(sp)
    8000230c:	6121                	addi	sp,sp,64
    8000230e:	8082                	ret
      release(&tickslock);
    80002310:	0000d517          	auipc	a0,0xd
    80002314:	b7050513          	addi	a0,a0,-1168 # 8000ee80 <tickslock>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	04e080e7          	jalr	78(ra) # 80006366 <release>
      return -1;
    80002320:	57fd                	li	a5,-1
    80002322:	bff9                	j	80002300 <sys_sleep+0x88>

0000000080002324 <sys_kill>:

uint64
sys_kill(void)
{
    80002324:	1101                	addi	sp,sp,-32
    80002326:	ec06                	sd	ra,24(sp)
    80002328:	e822                	sd	s0,16(sp)
    8000232a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000232c:	fec40593          	addi	a1,s0,-20
    80002330:	4501                	li	a0,0
    80002332:	00000097          	auipc	ra,0x0
    80002336:	d4e080e7          	jalr	-690(ra) # 80002080 <argint>
    8000233a:	87aa                	mv	a5,a0
    return -1;
    8000233c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000233e:	0007c863          	bltz	a5,8000234e <sys_kill+0x2a>
  return kill(pid);
    80002342:	fec42503          	lw	a0,-20(s0)
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	646080e7          	jalr	1606(ra) # 8000198c <kill>
}
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	6105                	addi	sp,sp,32
    80002354:	8082                	ret

0000000080002356 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002360:	0000d517          	auipc	a0,0xd
    80002364:	b2050513          	addi	a0,a0,-1248 # 8000ee80 <tickslock>
    80002368:	00004097          	auipc	ra,0x4
    8000236c:	f4a080e7          	jalr	-182(ra) # 800062b2 <acquire>
  xticks = ticks;
    80002370:	00007497          	auipc	s1,0x7
    80002374:	ca84a483          	lw	s1,-856(s1) # 80009018 <ticks>
  release(&tickslock);
    80002378:	0000d517          	auipc	a0,0xd
    8000237c:	b0850513          	addi	a0,a0,-1272 # 8000ee80 <tickslock>
    80002380:	00004097          	auipc	ra,0x4
    80002384:	fe6080e7          	jalr	-26(ra) # 80006366 <release>
  return xticks;
}
    80002388:	02049513          	slli	a0,s1,0x20
    8000238c:	9101                	srli	a0,a0,0x20
    8000238e:	60e2                	ld	ra,24(sp)
    80002390:	6442                	ld	s0,16(sp)
    80002392:	64a2                	ld	s1,8(sp)
    80002394:	6105                	addi	sp,sp,32
    80002396:	8082                	ret

0000000080002398 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002398:	7179                	addi	sp,sp,-48
    8000239a:	f406                	sd	ra,40(sp)
    8000239c:	f022                	sd	s0,32(sp)
    8000239e:	1800                	addi	s0,sp,48
  struct sysinfo info;
  freebytes(&info.freemem);
    800023a0:	fe040513          	addi	a0,s0,-32
    800023a4:	ffffe097          	auipc	ra,0xffffe
    800023a8:	dd4080e7          	jalr	-556(ra) # 80000178 <freebytes>
  procnum(&info.nproc);
    800023ac:	fe840513          	addi	a0,s0,-24
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	7a8080e7          	jalr	1960(ra) # 80001b58 <procnum>

  // a0寄存器作为系统调用的参数寄存器,从中取出存放 sysinfo 结构的用户态缓冲区指针
  uint64 dstaddr;
  argaddr(0, &dstaddr);
    800023b8:	fd840593          	addi	a1,s0,-40
    800023bc:	4501                	li	a0,0
    800023be:	00000097          	auipc	ra,0x0
    800023c2:	ce4080e7          	jalr	-796(ra) # 800020a2 <argaddr>

  // 使用 copyout，结合当前进程的页表，获得进程传进来的指针（逻辑地址）对应的物理地址
  // 然后将 &sinfo 中的数据复制到该指针所指位置，供用户进程使用。
  if (copyout(myproc()->pagetable, dstaddr, (char*)&info, sizeof info) < 0)
    800023c6:	fffff097          	auipc	ra,0xfffff
    800023ca:	bd0080e7          	jalr	-1072(ra) # 80000f96 <myproc>
    800023ce:	46c1                	li	a3,16
    800023d0:	fe040613          	addi	a2,s0,-32
    800023d4:	fd843583          	ld	a1,-40(s0)
    800023d8:	6928                	ld	a0,80(a0)
    800023da:	ffffe097          	auipc	ra,0xffffe
    800023de:	782080e7          	jalr	1922(ra) # 80000b5c <copyout>
    return -1;

  return 0;
}
    800023e2:	957d                	srai	a0,a0,0x3f
    800023e4:	70a2                	ld	ra,40(sp)
    800023e6:	7402                	ld	s0,32(sp)
    800023e8:	6145                	addi	sp,sp,48
    800023ea:	8082                	ret

00000000800023ec <sys_trace>:

uint64
sys_trace(void)
{
    800023ec:	1141                	addi	sp,sp,-16
    800023ee:	e406                	sd	ra,8(sp)
    800023f0:	e022                	sd	s0,0(sp)
    800023f2:	0800                	addi	s0,sp,16
  // 获取系统调用的参数
  argint(0, &(myproc()->trace_mask));
    800023f4:	fffff097          	auipc	ra,0xfffff
    800023f8:	ba2080e7          	jalr	-1118(ra) # 80000f96 <myproc>
    800023fc:	03450593          	addi	a1,a0,52
    80002400:	4501                	li	a0,0
    80002402:	00000097          	auipc	ra,0x0
    80002406:	c7e080e7          	jalr	-898(ra) # 80002080 <argint>
  return 0;
}
    8000240a:	4501                	li	a0,0
    8000240c:	60a2                	ld	ra,8(sp)
    8000240e:	6402                	ld	s0,0(sp)
    80002410:	0141                	addi	sp,sp,16
    80002412:	8082                	ret

0000000080002414 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002414:	7179                	addi	sp,sp,-48
    80002416:	f406                	sd	ra,40(sp)
    80002418:	f022                	sd	s0,32(sp)
    8000241a:	ec26                	sd	s1,24(sp)
    8000241c:	e84a                	sd	s2,16(sp)
    8000241e:	e44e                	sd	s3,8(sp)
    80002420:	e052                	sd	s4,0(sp)
    80002422:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002424:	00006597          	auipc	a1,0x6
    80002428:	22c58593          	addi	a1,a1,556 # 80008650 <syscalls_name+0xc0>
    8000242c:	0000d517          	auipc	a0,0xd
    80002430:	a6c50513          	addi	a0,a0,-1428 # 8000ee98 <bcache>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	dee080e7          	jalr	-530(ra) # 80006222 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000243c:	00015797          	auipc	a5,0x15
    80002440:	a5c78793          	addi	a5,a5,-1444 # 80016e98 <bcache+0x8000>
    80002444:	00015717          	auipc	a4,0x15
    80002448:	cbc70713          	addi	a4,a4,-836 # 80017100 <bcache+0x8268>
    8000244c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002450:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002454:	0000d497          	auipc	s1,0xd
    80002458:	a5c48493          	addi	s1,s1,-1444 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000245c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000245e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002460:	00006a17          	auipc	s4,0x6
    80002464:	1f8a0a13          	addi	s4,s4,504 # 80008658 <syscalls_name+0xc8>
    b->next = bcache.head.next;
    80002468:	2b893783          	ld	a5,696(s2)
    8000246c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000246e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002472:	85d2                	mv	a1,s4
    80002474:	01048513          	addi	a0,s1,16
    80002478:	00001097          	auipc	ra,0x1
    8000247c:	4bc080e7          	jalr	1212(ra) # 80003934 <initsleeplock>
    bcache.head.next->prev = b;
    80002480:	2b893783          	ld	a5,696(s2)
    80002484:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002486:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000248a:	45848493          	addi	s1,s1,1112
    8000248e:	fd349de3          	bne	s1,s3,80002468 <binit+0x54>
  }
}
    80002492:	70a2                	ld	ra,40(sp)
    80002494:	7402                	ld	s0,32(sp)
    80002496:	64e2                	ld	s1,24(sp)
    80002498:	6942                	ld	s2,16(sp)
    8000249a:	69a2                	ld	s3,8(sp)
    8000249c:	6a02                	ld	s4,0(sp)
    8000249e:	6145                	addi	sp,sp,48
    800024a0:	8082                	ret

00000000800024a2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024a2:	7179                	addi	sp,sp,-48
    800024a4:	f406                	sd	ra,40(sp)
    800024a6:	f022                	sd	s0,32(sp)
    800024a8:	ec26                	sd	s1,24(sp)
    800024aa:	e84a                	sd	s2,16(sp)
    800024ac:	e44e                	sd	s3,8(sp)
    800024ae:	1800                	addi	s0,sp,48
    800024b0:	89aa                	mv	s3,a0
    800024b2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024b4:	0000d517          	auipc	a0,0xd
    800024b8:	9e450513          	addi	a0,a0,-1564 # 8000ee98 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	df6080e7          	jalr	-522(ra) # 800062b2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024c4:	00015497          	auipc	s1,0x15
    800024c8:	c8c4b483          	ld	s1,-884(s1) # 80017150 <bcache+0x82b8>
    800024cc:	00015797          	auipc	a5,0x15
    800024d0:	c3478793          	addi	a5,a5,-972 # 80017100 <bcache+0x8268>
    800024d4:	02f48f63          	beq	s1,a5,80002512 <bread+0x70>
    800024d8:	873e                	mv	a4,a5
    800024da:	a021                	j	800024e2 <bread+0x40>
    800024dc:	68a4                	ld	s1,80(s1)
    800024de:	02e48a63          	beq	s1,a4,80002512 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024e2:	449c                	lw	a5,8(s1)
    800024e4:	ff379ce3          	bne	a5,s3,800024dc <bread+0x3a>
    800024e8:	44dc                	lw	a5,12(s1)
    800024ea:	ff2799e3          	bne	a5,s2,800024dc <bread+0x3a>
      b->refcnt++;
    800024ee:	40bc                	lw	a5,64(s1)
    800024f0:	2785                	addiw	a5,a5,1
    800024f2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024f4:	0000d517          	auipc	a0,0xd
    800024f8:	9a450513          	addi	a0,a0,-1628 # 8000ee98 <bcache>
    800024fc:	00004097          	auipc	ra,0x4
    80002500:	e6a080e7          	jalr	-406(ra) # 80006366 <release>
      acquiresleep(&b->lock);
    80002504:	01048513          	addi	a0,s1,16
    80002508:	00001097          	auipc	ra,0x1
    8000250c:	466080e7          	jalr	1126(ra) # 8000396e <acquiresleep>
      return b;
    80002510:	a8b9                	j	8000256e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002512:	00015497          	auipc	s1,0x15
    80002516:	c364b483          	ld	s1,-970(s1) # 80017148 <bcache+0x82b0>
    8000251a:	00015797          	auipc	a5,0x15
    8000251e:	be678793          	addi	a5,a5,-1050 # 80017100 <bcache+0x8268>
    80002522:	00f48863          	beq	s1,a5,80002532 <bread+0x90>
    80002526:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002528:	40bc                	lw	a5,64(s1)
    8000252a:	cf81                	beqz	a5,80002542 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000252c:	64a4                	ld	s1,72(s1)
    8000252e:	fee49de3          	bne	s1,a4,80002528 <bread+0x86>
  panic("bget: no buffers");
    80002532:	00006517          	auipc	a0,0x6
    80002536:	12e50513          	addi	a0,a0,302 # 80008660 <syscalls_name+0xd0>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	82e080e7          	jalr	-2002(ra) # 80005d68 <panic>
      b->dev = dev;
    80002542:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002546:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000254a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000254e:	4785                	li	a5,1
    80002550:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002552:	0000d517          	auipc	a0,0xd
    80002556:	94650513          	addi	a0,a0,-1722 # 8000ee98 <bcache>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	e0c080e7          	jalr	-500(ra) # 80006366 <release>
      acquiresleep(&b->lock);
    80002562:	01048513          	addi	a0,s1,16
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	408080e7          	jalr	1032(ra) # 8000396e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000256e:	409c                	lw	a5,0(s1)
    80002570:	cb89                	beqz	a5,80002582 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002572:	8526                	mv	a0,s1
    80002574:	70a2                	ld	ra,40(sp)
    80002576:	7402                	ld	s0,32(sp)
    80002578:	64e2                	ld	s1,24(sp)
    8000257a:	6942                	ld	s2,16(sp)
    8000257c:	69a2                	ld	s3,8(sp)
    8000257e:	6145                	addi	sp,sp,48
    80002580:	8082                	ret
    virtio_disk_rw(b, 0);
    80002582:	4581                	li	a1,0
    80002584:	8526                	mv	a0,s1
    80002586:	00003097          	auipc	ra,0x3
    8000258a:	f20080e7          	jalr	-224(ra) # 800054a6 <virtio_disk_rw>
    b->valid = 1;
    8000258e:	4785                	li	a5,1
    80002590:	c09c                	sw	a5,0(s1)
  return b;
    80002592:	b7c5                	j	80002572 <bread+0xd0>

0000000080002594 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002594:	1101                	addi	sp,sp,-32
    80002596:	ec06                	sd	ra,24(sp)
    80002598:	e822                	sd	s0,16(sp)
    8000259a:	e426                	sd	s1,8(sp)
    8000259c:	1000                	addi	s0,sp,32
    8000259e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a0:	0541                	addi	a0,a0,16
    800025a2:	00001097          	auipc	ra,0x1
    800025a6:	466080e7          	jalr	1126(ra) # 80003a08 <holdingsleep>
    800025aa:	cd01                	beqz	a0,800025c2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025ac:	4585                	li	a1,1
    800025ae:	8526                	mv	a0,s1
    800025b0:	00003097          	auipc	ra,0x3
    800025b4:	ef6080e7          	jalr	-266(ra) # 800054a6 <virtio_disk_rw>
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6105                	addi	sp,sp,32
    800025c0:	8082                	ret
    panic("bwrite");
    800025c2:	00006517          	auipc	a0,0x6
    800025c6:	0b650513          	addi	a0,a0,182 # 80008678 <syscalls_name+0xe8>
    800025ca:	00003097          	auipc	ra,0x3
    800025ce:	79e080e7          	jalr	1950(ra) # 80005d68 <panic>

00000000800025d2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	e04a                	sd	s2,0(sp)
    800025dc:	1000                	addi	s0,sp,32
    800025de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025e0:	01050913          	addi	s2,a0,16
    800025e4:	854a                	mv	a0,s2
    800025e6:	00001097          	auipc	ra,0x1
    800025ea:	422080e7          	jalr	1058(ra) # 80003a08 <holdingsleep>
    800025ee:	c92d                	beqz	a0,80002660 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025f0:	854a                	mv	a0,s2
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	3d2080e7          	jalr	978(ra) # 800039c4 <releasesleep>

  acquire(&bcache.lock);
    800025fa:	0000d517          	auipc	a0,0xd
    800025fe:	89e50513          	addi	a0,a0,-1890 # 8000ee98 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	cb0080e7          	jalr	-848(ra) # 800062b2 <acquire>
  b->refcnt--;
    8000260a:	40bc                	lw	a5,64(s1)
    8000260c:	37fd                	addiw	a5,a5,-1
    8000260e:	0007871b          	sext.w	a4,a5
    80002612:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002614:	eb05                	bnez	a4,80002644 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002616:	68bc                	ld	a5,80(s1)
    80002618:	64b8                	ld	a4,72(s1)
    8000261a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000261c:	64bc                	ld	a5,72(s1)
    8000261e:	68b8                	ld	a4,80(s1)
    80002620:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002622:	00015797          	auipc	a5,0x15
    80002626:	87678793          	addi	a5,a5,-1930 # 80016e98 <bcache+0x8000>
    8000262a:	2b87b703          	ld	a4,696(a5)
    8000262e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002630:	00015717          	auipc	a4,0x15
    80002634:	ad070713          	addi	a4,a4,-1328 # 80017100 <bcache+0x8268>
    80002638:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000263a:	2b87b703          	ld	a4,696(a5)
    8000263e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002640:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002644:	0000d517          	auipc	a0,0xd
    80002648:	85450513          	addi	a0,a0,-1964 # 8000ee98 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	d1a080e7          	jalr	-742(ra) # 80006366 <release>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret
    panic("brelse");
    80002660:	00006517          	auipc	a0,0x6
    80002664:	02050513          	addi	a0,a0,32 # 80008680 <syscalls_name+0xf0>
    80002668:	00003097          	auipc	ra,0x3
    8000266c:	700080e7          	jalr	1792(ra) # 80005d68 <panic>

0000000080002670 <bpin>:

void
bpin(struct buf *b) {
    80002670:	1101                	addi	sp,sp,-32
    80002672:	ec06                	sd	ra,24(sp)
    80002674:	e822                	sd	s0,16(sp)
    80002676:	e426                	sd	s1,8(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000267c:	0000d517          	auipc	a0,0xd
    80002680:	81c50513          	addi	a0,a0,-2020 # 8000ee98 <bcache>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	c2e080e7          	jalr	-978(ra) # 800062b2 <acquire>
  b->refcnt++;
    8000268c:	40bc                	lw	a5,64(s1)
    8000268e:	2785                	addiw	a5,a5,1
    80002690:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002692:	0000d517          	auipc	a0,0xd
    80002696:	80650513          	addi	a0,a0,-2042 # 8000ee98 <bcache>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	ccc080e7          	jalr	-820(ra) # 80006366 <release>
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	64a2                	ld	s1,8(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret

00000000800026ac <bunpin>:

void
bunpin(struct buf *b) {
    800026ac:	1101                	addi	sp,sp,-32
    800026ae:	ec06                	sd	ra,24(sp)
    800026b0:	e822                	sd	s0,16(sp)
    800026b2:	e426                	sd	s1,8(sp)
    800026b4:	1000                	addi	s0,sp,32
    800026b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026b8:	0000c517          	auipc	a0,0xc
    800026bc:	7e050513          	addi	a0,a0,2016 # 8000ee98 <bcache>
    800026c0:	00004097          	auipc	ra,0x4
    800026c4:	bf2080e7          	jalr	-1038(ra) # 800062b2 <acquire>
  b->refcnt--;
    800026c8:	40bc                	lw	a5,64(s1)
    800026ca:	37fd                	addiw	a5,a5,-1
    800026cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ce:	0000c517          	auipc	a0,0xc
    800026d2:	7ca50513          	addi	a0,a0,1994 # 8000ee98 <bcache>
    800026d6:	00004097          	auipc	ra,0x4
    800026da:	c90080e7          	jalr	-880(ra) # 80006366 <release>
}
    800026de:	60e2                	ld	ra,24(sp)
    800026e0:	6442                	ld	s0,16(sp)
    800026e2:	64a2                	ld	s1,8(sp)
    800026e4:	6105                	addi	sp,sp,32
    800026e6:	8082                	ret

00000000800026e8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026e8:	1101                	addi	sp,sp,-32
    800026ea:	ec06                	sd	ra,24(sp)
    800026ec:	e822                	sd	s0,16(sp)
    800026ee:	e426                	sd	s1,8(sp)
    800026f0:	e04a                	sd	s2,0(sp)
    800026f2:	1000                	addi	s0,sp,32
    800026f4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026f6:	00d5d59b          	srliw	a1,a1,0xd
    800026fa:	00015797          	auipc	a5,0x15
    800026fe:	e7a7a783          	lw	a5,-390(a5) # 80017574 <sb+0x1c>
    80002702:	9dbd                	addw	a1,a1,a5
    80002704:	00000097          	auipc	ra,0x0
    80002708:	d9e080e7          	jalr	-610(ra) # 800024a2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000270c:	0074f713          	andi	a4,s1,7
    80002710:	4785                	li	a5,1
    80002712:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002716:	14ce                	slli	s1,s1,0x33
    80002718:	90d9                	srli	s1,s1,0x36
    8000271a:	00950733          	add	a4,a0,s1
    8000271e:	05874703          	lbu	a4,88(a4)
    80002722:	00e7f6b3          	and	a3,a5,a4
    80002726:	c69d                	beqz	a3,80002754 <bfree+0x6c>
    80002728:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000272a:	94aa                	add	s1,s1,a0
    8000272c:	fff7c793          	not	a5,a5
    80002730:	8ff9                	and	a5,a5,a4
    80002732:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002736:	00001097          	auipc	ra,0x1
    8000273a:	118080e7          	jalr	280(ra) # 8000384e <log_write>
  brelse(bp);
    8000273e:	854a                	mv	a0,s2
    80002740:	00000097          	auipc	ra,0x0
    80002744:	e92080e7          	jalr	-366(ra) # 800025d2 <brelse>
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6902                	ld	s2,0(sp)
    80002750:	6105                	addi	sp,sp,32
    80002752:	8082                	ret
    panic("freeing free block");
    80002754:	00006517          	auipc	a0,0x6
    80002758:	f3450513          	addi	a0,a0,-204 # 80008688 <syscalls_name+0xf8>
    8000275c:	00003097          	auipc	ra,0x3
    80002760:	60c080e7          	jalr	1548(ra) # 80005d68 <panic>

0000000080002764 <balloc>:
{
    80002764:	711d                	addi	sp,sp,-96
    80002766:	ec86                	sd	ra,88(sp)
    80002768:	e8a2                	sd	s0,80(sp)
    8000276a:	e4a6                	sd	s1,72(sp)
    8000276c:	e0ca                	sd	s2,64(sp)
    8000276e:	fc4e                	sd	s3,56(sp)
    80002770:	f852                	sd	s4,48(sp)
    80002772:	f456                	sd	s5,40(sp)
    80002774:	f05a                	sd	s6,32(sp)
    80002776:	ec5e                	sd	s7,24(sp)
    80002778:	e862                	sd	s8,16(sp)
    8000277a:	e466                	sd	s9,8(sp)
    8000277c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000277e:	00015797          	auipc	a5,0x15
    80002782:	dde7a783          	lw	a5,-546(a5) # 8001755c <sb+0x4>
    80002786:	cbd1                	beqz	a5,8000281a <balloc+0xb6>
    80002788:	8baa                	mv	s7,a0
    8000278a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000278c:	00015b17          	auipc	s6,0x15
    80002790:	dccb0b13          	addi	s6,s6,-564 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002794:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002796:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002798:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000279a:	6c89                	lui	s9,0x2
    8000279c:	a831                	j	800027b8 <balloc+0x54>
    brelse(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	e32080e7          	jalr	-462(ra) # 800025d2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027a8:	015c87bb          	addw	a5,s9,s5
    800027ac:	00078a9b          	sext.w	s5,a5
    800027b0:	004b2703          	lw	a4,4(s6)
    800027b4:	06eaf363          	bgeu	s5,a4,8000281a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027b8:	41fad79b          	sraiw	a5,s5,0x1f
    800027bc:	0137d79b          	srliw	a5,a5,0x13
    800027c0:	015787bb          	addw	a5,a5,s5
    800027c4:	40d7d79b          	sraiw	a5,a5,0xd
    800027c8:	01cb2583          	lw	a1,28(s6)
    800027cc:	9dbd                	addw	a1,a1,a5
    800027ce:	855e                	mv	a0,s7
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	cd2080e7          	jalr	-814(ra) # 800024a2 <bread>
    800027d8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027da:	004b2503          	lw	a0,4(s6)
    800027de:	000a849b          	sext.w	s1,s5
    800027e2:	8662                	mv	a2,s8
    800027e4:	faa4fde3          	bgeu	s1,a0,8000279e <balloc+0x3a>
      m = 1 << (bi % 8);
    800027e8:	41f6579b          	sraiw	a5,a2,0x1f
    800027ec:	01d7d69b          	srliw	a3,a5,0x1d
    800027f0:	00c6873b          	addw	a4,a3,a2
    800027f4:	00777793          	andi	a5,a4,7
    800027f8:	9f95                	subw	a5,a5,a3
    800027fa:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027fe:	4037571b          	sraiw	a4,a4,0x3
    80002802:	00e906b3          	add	a3,s2,a4
    80002806:	0586c683          	lbu	a3,88(a3)
    8000280a:	00d7f5b3          	and	a1,a5,a3
    8000280e:	cd91                	beqz	a1,8000282a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002810:	2605                	addiw	a2,a2,1
    80002812:	2485                	addiw	s1,s1,1
    80002814:	fd4618e3          	bne	a2,s4,800027e4 <balloc+0x80>
    80002818:	b759                	j	8000279e <balloc+0x3a>
  panic("balloc: out of blocks");
    8000281a:	00006517          	auipc	a0,0x6
    8000281e:	e8650513          	addi	a0,a0,-378 # 800086a0 <syscalls_name+0x110>
    80002822:	00003097          	auipc	ra,0x3
    80002826:	546080e7          	jalr	1350(ra) # 80005d68 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000282a:	974a                	add	a4,a4,s2
    8000282c:	8fd5                	or	a5,a5,a3
    8000282e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002832:	854a                	mv	a0,s2
    80002834:	00001097          	auipc	ra,0x1
    80002838:	01a080e7          	jalr	26(ra) # 8000384e <log_write>
        brelse(bp);
    8000283c:	854a                	mv	a0,s2
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	d94080e7          	jalr	-620(ra) # 800025d2 <brelse>
  bp = bread(dev, bno);
    80002846:	85a6                	mv	a1,s1
    80002848:	855e                	mv	a0,s7
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	c58080e7          	jalr	-936(ra) # 800024a2 <bread>
    80002852:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002854:	40000613          	li	a2,1024
    80002858:	4581                	li	a1,0
    8000285a:	05850513          	addi	a0,a0,88
    8000285e:	ffffe097          	auipc	ra,0xffffe
    80002862:	96c080e7          	jalr	-1684(ra) # 800001ca <memset>
  log_write(bp);
    80002866:	854a                	mv	a0,s2
    80002868:	00001097          	auipc	ra,0x1
    8000286c:	fe6080e7          	jalr	-26(ra) # 8000384e <log_write>
  brelse(bp);
    80002870:	854a                	mv	a0,s2
    80002872:	00000097          	auipc	ra,0x0
    80002876:	d60080e7          	jalr	-672(ra) # 800025d2 <brelse>
}
    8000287a:	8526                	mv	a0,s1
    8000287c:	60e6                	ld	ra,88(sp)
    8000287e:	6446                	ld	s0,80(sp)
    80002880:	64a6                	ld	s1,72(sp)
    80002882:	6906                	ld	s2,64(sp)
    80002884:	79e2                	ld	s3,56(sp)
    80002886:	7a42                	ld	s4,48(sp)
    80002888:	7aa2                	ld	s5,40(sp)
    8000288a:	7b02                	ld	s6,32(sp)
    8000288c:	6be2                	ld	s7,24(sp)
    8000288e:	6c42                	ld	s8,16(sp)
    80002890:	6ca2                	ld	s9,8(sp)
    80002892:	6125                	addi	sp,sp,96
    80002894:	8082                	ret

0000000080002896 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002896:	7179                	addi	sp,sp,-48
    80002898:	f406                	sd	ra,40(sp)
    8000289a:	f022                	sd	s0,32(sp)
    8000289c:	ec26                	sd	s1,24(sp)
    8000289e:	e84a                	sd	s2,16(sp)
    800028a0:	e44e                	sd	s3,8(sp)
    800028a2:	e052                	sd	s4,0(sp)
    800028a4:	1800                	addi	s0,sp,48
    800028a6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028a8:	47ad                	li	a5,11
    800028aa:	04b7fe63          	bgeu	a5,a1,80002906 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028ae:	ff45849b          	addiw	s1,a1,-12
    800028b2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028b6:	0ff00793          	li	a5,255
    800028ba:	0ae7e363          	bltu	a5,a4,80002960 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028be:	08052583          	lw	a1,128(a0)
    800028c2:	c5ad                	beqz	a1,8000292c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028c4:	00092503          	lw	a0,0(s2)
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	bda080e7          	jalr	-1062(ra) # 800024a2 <bread>
    800028d0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028d2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028d6:	02049593          	slli	a1,s1,0x20
    800028da:	9181                	srli	a1,a1,0x20
    800028dc:	058a                	slli	a1,a1,0x2
    800028de:	00b784b3          	add	s1,a5,a1
    800028e2:	0004a983          	lw	s3,0(s1)
    800028e6:	04098d63          	beqz	s3,80002940 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028ea:	8552                	mv	a0,s4
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	ce6080e7          	jalr	-794(ra) # 800025d2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028f4:	854e                	mv	a0,s3
    800028f6:	70a2                	ld	ra,40(sp)
    800028f8:	7402                	ld	s0,32(sp)
    800028fa:	64e2                	ld	s1,24(sp)
    800028fc:	6942                	ld	s2,16(sp)
    800028fe:	69a2                	ld	s3,8(sp)
    80002900:	6a02                	ld	s4,0(sp)
    80002902:	6145                	addi	sp,sp,48
    80002904:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002906:	02059493          	slli	s1,a1,0x20
    8000290a:	9081                	srli	s1,s1,0x20
    8000290c:	048a                	slli	s1,s1,0x2
    8000290e:	94aa                	add	s1,s1,a0
    80002910:	0504a983          	lw	s3,80(s1)
    80002914:	fe0990e3          	bnez	s3,800028f4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002918:	4108                	lw	a0,0(a0)
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	e4a080e7          	jalr	-438(ra) # 80002764 <balloc>
    80002922:	0005099b          	sext.w	s3,a0
    80002926:	0534a823          	sw	s3,80(s1)
    8000292a:	b7e9                	j	800028f4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000292c:	4108                	lw	a0,0(a0)
    8000292e:	00000097          	auipc	ra,0x0
    80002932:	e36080e7          	jalr	-458(ra) # 80002764 <balloc>
    80002936:	0005059b          	sext.w	a1,a0
    8000293a:	08b92023          	sw	a1,128(s2)
    8000293e:	b759                	j	800028c4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002940:	00092503          	lw	a0,0(s2)
    80002944:	00000097          	auipc	ra,0x0
    80002948:	e20080e7          	jalr	-480(ra) # 80002764 <balloc>
    8000294c:	0005099b          	sext.w	s3,a0
    80002950:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002954:	8552                	mv	a0,s4
    80002956:	00001097          	auipc	ra,0x1
    8000295a:	ef8080e7          	jalr	-264(ra) # 8000384e <log_write>
    8000295e:	b771                	j	800028ea <bmap+0x54>
  panic("bmap: out of range");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	d5850513          	addi	a0,a0,-680 # 800086b8 <syscalls_name+0x128>
    80002968:	00003097          	auipc	ra,0x3
    8000296c:	400080e7          	jalr	1024(ra) # 80005d68 <panic>

0000000080002970 <iget>:
{
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	e84a                	sd	s2,16(sp)
    8000297a:	e44e                	sd	s3,8(sp)
    8000297c:	e052                	sd	s4,0(sp)
    8000297e:	1800                	addi	s0,sp,48
    80002980:	89aa                	mv	s3,a0
    80002982:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002984:	00015517          	auipc	a0,0x15
    80002988:	bf450513          	addi	a0,a0,-1036 # 80017578 <itable>
    8000298c:	00004097          	auipc	ra,0x4
    80002990:	926080e7          	jalr	-1754(ra) # 800062b2 <acquire>
  empty = 0;
    80002994:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002996:	00015497          	auipc	s1,0x15
    8000299a:	bfa48493          	addi	s1,s1,-1030 # 80017590 <itable+0x18>
    8000299e:	00016697          	auipc	a3,0x16
    800029a2:	68268693          	addi	a3,a3,1666 # 80019020 <log>
    800029a6:	a039                	j	800029b4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029a8:	02090b63          	beqz	s2,800029de <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ac:	08848493          	addi	s1,s1,136
    800029b0:	02d48a63          	beq	s1,a3,800029e4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029b4:	449c                	lw	a5,8(s1)
    800029b6:	fef059e3          	blez	a5,800029a8 <iget+0x38>
    800029ba:	4098                	lw	a4,0(s1)
    800029bc:	ff3716e3          	bne	a4,s3,800029a8 <iget+0x38>
    800029c0:	40d8                	lw	a4,4(s1)
    800029c2:	ff4713e3          	bne	a4,s4,800029a8 <iget+0x38>
      ip->ref++;
    800029c6:	2785                	addiw	a5,a5,1
    800029c8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ca:	00015517          	auipc	a0,0x15
    800029ce:	bae50513          	addi	a0,a0,-1106 # 80017578 <itable>
    800029d2:	00004097          	auipc	ra,0x4
    800029d6:	994080e7          	jalr	-1644(ra) # 80006366 <release>
      return ip;
    800029da:	8926                	mv	s2,s1
    800029dc:	a03d                	j	80002a0a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029de:	f7f9                	bnez	a5,800029ac <iget+0x3c>
    800029e0:	8926                	mv	s2,s1
    800029e2:	b7e9                	j	800029ac <iget+0x3c>
  if(empty == 0)
    800029e4:	02090c63          	beqz	s2,80002a1c <iget+0xac>
  ip->dev = dev;
    800029e8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029ec:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029f0:	4785                	li	a5,1
    800029f2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029f6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029fa:	00015517          	auipc	a0,0x15
    800029fe:	b7e50513          	addi	a0,a0,-1154 # 80017578 <itable>
    80002a02:	00004097          	auipc	ra,0x4
    80002a06:	964080e7          	jalr	-1692(ra) # 80006366 <release>
}
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	70a2                	ld	ra,40(sp)
    80002a0e:	7402                	ld	s0,32(sp)
    80002a10:	64e2                	ld	s1,24(sp)
    80002a12:	6942                	ld	s2,16(sp)
    80002a14:	69a2                	ld	s3,8(sp)
    80002a16:	6a02                	ld	s4,0(sp)
    80002a18:	6145                	addi	sp,sp,48
    80002a1a:	8082                	ret
    panic("iget: no inodes");
    80002a1c:	00006517          	auipc	a0,0x6
    80002a20:	cb450513          	addi	a0,a0,-844 # 800086d0 <syscalls_name+0x140>
    80002a24:	00003097          	auipc	ra,0x3
    80002a28:	344080e7          	jalr	836(ra) # 80005d68 <panic>

0000000080002a2c <fsinit>:
fsinit(int dev) {
    80002a2c:	7179                	addi	sp,sp,-48
    80002a2e:	f406                	sd	ra,40(sp)
    80002a30:	f022                	sd	s0,32(sp)
    80002a32:	ec26                	sd	s1,24(sp)
    80002a34:	e84a                	sd	s2,16(sp)
    80002a36:	e44e                	sd	s3,8(sp)
    80002a38:	1800                	addi	s0,sp,48
    80002a3a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a3c:	4585                	li	a1,1
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	a64080e7          	jalr	-1436(ra) # 800024a2 <bread>
    80002a46:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a48:	00015997          	auipc	s3,0x15
    80002a4c:	b1098993          	addi	s3,s3,-1264 # 80017558 <sb>
    80002a50:	02000613          	li	a2,32
    80002a54:	05850593          	addi	a1,a0,88
    80002a58:	854e                	mv	a0,s3
    80002a5a:	ffffd097          	auipc	ra,0xffffd
    80002a5e:	7d0080e7          	jalr	2000(ra) # 8000022a <memmove>
  brelse(bp);
    80002a62:	8526                	mv	a0,s1
    80002a64:	00000097          	auipc	ra,0x0
    80002a68:	b6e080e7          	jalr	-1170(ra) # 800025d2 <brelse>
  if(sb.magic != FSMAGIC)
    80002a6c:	0009a703          	lw	a4,0(s3)
    80002a70:	102037b7          	lui	a5,0x10203
    80002a74:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a78:	02f71263          	bne	a4,a5,80002a9c <fsinit+0x70>
  initlog(dev, &sb);
    80002a7c:	00015597          	auipc	a1,0x15
    80002a80:	adc58593          	addi	a1,a1,-1316 # 80017558 <sb>
    80002a84:	854a                	mv	a0,s2
    80002a86:	00001097          	auipc	ra,0x1
    80002a8a:	b4c080e7          	jalr	-1204(ra) # 800035d2 <initlog>
}
    80002a8e:	70a2                	ld	ra,40(sp)
    80002a90:	7402                	ld	s0,32(sp)
    80002a92:	64e2                	ld	s1,24(sp)
    80002a94:	6942                	ld	s2,16(sp)
    80002a96:	69a2                	ld	s3,8(sp)
    80002a98:	6145                	addi	sp,sp,48
    80002a9a:	8082                	ret
    panic("invalid file system");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	c4450513          	addi	a0,a0,-956 # 800086e0 <syscalls_name+0x150>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	2c4080e7          	jalr	708(ra) # 80005d68 <panic>

0000000080002aac <iinit>:
{
    80002aac:	7179                	addi	sp,sp,-48
    80002aae:	f406                	sd	ra,40(sp)
    80002ab0:	f022                	sd	s0,32(sp)
    80002ab2:	ec26                	sd	s1,24(sp)
    80002ab4:	e84a                	sd	s2,16(sp)
    80002ab6:	e44e                	sd	s3,8(sp)
    80002ab8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aba:	00006597          	auipc	a1,0x6
    80002abe:	c3e58593          	addi	a1,a1,-962 # 800086f8 <syscalls_name+0x168>
    80002ac2:	00015517          	auipc	a0,0x15
    80002ac6:	ab650513          	addi	a0,a0,-1354 # 80017578 <itable>
    80002aca:	00003097          	auipc	ra,0x3
    80002ace:	758080e7          	jalr	1880(ra) # 80006222 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ad2:	00015497          	auipc	s1,0x15
    80002ad6:	ace48493          	addi	s1,s1,-1330 # 800175a0 <itable+0x28>
    80002ada:	00016997          	auipc	s3,0x16
    80002ade:	55698993          	addi	s3,s3,1366 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ae2:	00006917          	auipc	s2,0x6
    80002ae6:	c1e90913          	addi	s2,s2,-994 # 80008700 <syscalls_name+0x170>
    80002aea:	85ca                	mv	a1,s2
    80002aec:	8526                	mv	a0,s1
    80002aee:	00001097          	auipc	ra,0x1
    80002af2:	e46080e7          	jalr	-442(ra) # 80003934 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002af6:	08848493          	addi	s1,s1,136
    80002afa:	ff3498e3          	bne	s1,s3,80002aea <iinit+0x3e>
}
    80002afe:	70a2                	ld	ra,40(sp)
    80002b00:	7402                	ld	s0,32(sp)
    80002b02:	64e2                	ld	s1,24(sp)
    80002b04:	6942                	ld	s2,16(sp)
    80002b06:	69a2                	ld	s3,8(sp)
    80002b08:	6145                	addi	sp,sp,48
    80002b0a:	8082                	ret

0000000080002b0c <ialloc>:
{
    80002b0c:	715d                	addi	sp,sp,-80
    80002b0e:	e486                	sd	ra,72(sp)
    80002b10:	e0a2                	sd	s0,64(sp)
    80002b12:	fc26                	sd	s1,56(sp)
    80002b14:	f84a                	sd	s2,48(sp)
    80002b16:	f44e                	sd	s3,40(sp)
    80002b18:	f052                	sd	s4,32(sp)
    80002b1a:	ec56                	sd	s5,24(sp)
    80002b1c:	e85a                	sd	s6,16(sp)
    80002b1e:	e45e                	sd	s7,8(sp)
    80002b20:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b22:	00015717          	auipc	a4,0x15
    80002b26:	a4272703          	lw	a4,-1470(a4) # 80017564 <sb+0xc>
    80002b2a:	4785                	li	a5,1
    80002b2c:	04e7fa63          	bgeu	a5,a4,80002b80 <ialloc+0x74>
    80002b30:	8aaa                	mv	s5,a0
    80002b32:	8bae                	mv	s7,a1
    80002b34:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b36:	00015a17          	auipc	s4,0x15
    80002b3a:	a22a0a13          	addi	s4,s4,-1502 # 80017558 <sb>
    80002b3e:	00048b1b          	sext.w	s6,s1
    80002b42:	0044d593          	srli	a1,s1,0x4
    80002b46:	018a2783          	lw	a5,24(s4)
    80002b4a:	9dbd                	addw	a1,a1,a5
    80002b4c:	8556                	mv	a0,s5
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	954080e7          	jalr	-1708(ra) # 800024a2 <bread>
    80002b56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b58:	05850993          	addi	s3,a0,88
    80002b5c:	00f4f793          	andi	a5,s1,15
    80002b60:	079a                	slli	a5,a5,0x6
    80002b62:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b64:	00099783          	lh	a5,0(s3)
    80002b68:	c785                	beqz	a5,80002b90 <ialloc+0x84>
    brelse(bp);
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	a68080e7          	jalr	-1432(ra) # 800025d2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b72:	0485                	addi	s1,s1,1
    80002b74:	00ca2703          	lw	a4,12(s4)
    80002b78:	0004879b          	sext.w	a5,s1
    80002b7c:	fce7e1e3          	bltu	a5,a4,80002b3e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b80:	00006517          	auipc	a0,0x6
    80002b84:	b8850513          	addi	a0,a0,-1144 # 80008708 <syscalls_name+0x178>
    80002b88:	00003097          	auipc	ra,0x3
    80002b8c:	1e0080e7          	jalr	480(ra) # 80005d68 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b90:	04000613          	li	a2,64
    80002b94:	4581                	li	a1,0
    80002b96:	854e                	mv	a0,s3
    80002b98:	ffffd097          	auipc	ra,0xffffd
    80002b9c:	632080e7          	jalr	1586(ra) # 800001ca <memset>
      dip->type = type;
    80002ba0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ba4:	854a                	mv	a0,s2
    80002ba6:	00001097          	auipc	ra,0x1
    80002baa:	ca8080e7          	jalr	-856(ra) # 8000384e <log_write>
      brelse(bp);
    80002bae:	854a                	mv	a0,s2
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	a22080e7          	jalr	-1502(ra) # 800025d2 <brelse>
      return iget(dev, inum);
    80002bb8:	85da                	mv	a1,s6
    80002bba:	8556                	mv	a0,s5
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	db4080e7          	jalr	-588(ra) # 80002970 <iget>
}
    80002bc4:	60a6                	ld	ra,72(sp)
    80002bc6:	6406                	ld	s0,64(sp)
    80002bc8:	74e2                	ld	s1,56(sp)
    80002bca:	7942                	ld	s2,48(sp)
    80002bcc:	79a2                	ld	s3,40(sp)
    80002bce:	7a02                	ld	s4,32(sp)
    80002bd0:	6ae2                	ld	s5,24(sp)
    80002bd2:	6b42                	ld	s6,16(sp)
    80002bd4:	6ba2                	ld	s7,8(sp)
    80002bd6:	6161                	addi	sp,sp,80
    80002bd8:	8082                	ret

0000000080002bda <iupdate>:
{
    80002bda:	1101                	addi	sp,sp,-32
    80002bdc:	ec06                	sd	ra,24(sp)
    80002bde:	e822                	sd	s0,16(sp)
    80002be0:	e426                	sd	s1,8(sp)
    80002be2:	e04a                	sd	s2,0(sp)
    80002be4:	1000                	addi	s0,sp,32
    80002be6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be8:	415c                	lw	a5,4(a0)
    80002bea:	0047d79b          	srliw	a5,a5,0x4
    80002bee:	00015597          	auipc	a1,0x15
    80002bf2:	9825a583          	lw	a1,-1662(a1) # 80017570 <sb+0x18>
    80002bf6:	9dbd                	addw	a1,a1,a5
    80002bf8:	4108                	lw	a0,0(a0)
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	8a8080e7          	jalr	-1880(ra) # 800024a2 <bread>
    80002c02:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c04:	05850793          	addi	a5,a0,88
    80002c08:	40c8                	lw	a0,4(s1)
    80002c0a:	893d                	andi	a0,a0,15
    80002c0c:	051a                	slli	a0,a0,0x6
    80002c0e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c10:	04449703          	lh	a4,68(s1)
    80002c14:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c18:	04649703          	lh	a4,70(s1)
    80002c1c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c20:	04849703          	lh	a4,72(s1)
    80002c24:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c28:	04a49703          	lh	a4,74(s1)
    80002c2c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c30:	44f8                	lw	a4,76(s1)
    80002c32:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c34:	03400613          	li	a2,52
    80002c38:	05048593          	addi	a1,s1,80
    80002c3c:	0531                	addi	a0,a0,12
    80002c3e:	ffffd097          	auipc	ra,0xffffd
    80002c42:	5ec080e7          	jalr	1516(ra) # 8000022a <memmove>
  log_write(bp);
    80002c46:	854a                	mv	a0,s2
    80002c48:	00001097          	auipc	ra,0x1
    80002c4c:	c06080e7          	jalr	-1018(ra) # 8000384e <log_write>
  brelse(bp);
    80002c50:	854a                	mv	a0,s2
    80002c52:	00000097          	auipc	ra,0x0
    80002c56:	980080e7          	jalr	-1664(ra) # 800025d2 <brelse>
}
    80002c5a:	60e2                	ld	ra,24(sp)
    80002c5c:	6442                	ld	s0,16(sp)
    80002c5e:	64a2                	ld	s1,8(sp)
    80002c60:	6902                	ld	s2,0(sp)
    80002c62:	6105                	addi	sp,sp,32
    80002c64:	8082                	ret

0000000080002c66 <idup>:
{
    80002c66:	1101                	addi	sp,sp,-32
    80002c68:	ec06                	sd	ra,24(sp)
    80002c6a:	e822                	sd	s0,16(sp)
    80002c6c:	e426                	sd	s1,8(sp)
    80002c6e:	1000                	addi	s0,sp,32
    80002c70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c72:	00015517          	auipc	a0,0x15
    80002c76:	90650513          	addi	a0,a0,-1786 # 80017578 <itable>
    80002c7a:	00003097          	auipc	ra,0x3
    80002c7e:	638080e7          	jalr	1592(ra) # 800062b2 <acquire>
  ip->ref++;
    80002c82:	449c                	lw	a5,8(s1)
    80002c84:	2785                	addiw	a5,a5,1
    80002c86:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c88:	00015517          	auipc	a0,0x15
    80002c8c:	8f050513          	addi	a0,a0,-1808 # 80017578 <itable>
    80002c90:	00003097          	auipc	ra,0x3
    80002c94:	6d6080e7          	jalr	1750(ra) # 80006366 <release>
}
    80002c98:	8526                	mv	a0,s1
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6105                	addi	sp,sp,32
    80002ca2:	8082                	ret

0000000080002ca4 <ilock>:
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	e04a                	sd	s2,0(sp)
    80002cae:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cb0:	c115                	beqz	a0,80002cd4 <ilock+0x30>
    80002cb2:	84aa                	mv	s1,a0
    80002cb4:	451c                	lw	a5,8(a0)
    80002cb6:	00f05f63          	blez	a5,80002cd4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cba:	0541                	addi	a0,a0,16
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	cb2080e7          	jalr	-846(ra) # 8000396e <acquiresleep>
  if(ip->valid == 0){
    80002cc4:	40bc                	lw	a5,64(s1)
    80002cc6:	cf99                	beqz	a5,80002ce4 <ilock+0x40>
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6902                	ld	s2,0(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret
    panic("ilock");
    80002cd4:	00006517          	auipc	a0,0x6
    80002cd8:	a4c50513          	addi	a0,a0,-1460 # 80008720 <syscalls_name+0x190>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	08c080e7          	jalr	140(ra) # 80005d68 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce4:	40dc                	lw	a5,4(s1)
    80002ce6:	0047d79b          	srliw	a5,a5,0x4
    80002cea:	00015597          	auipc	a1,0x15
    80002cee:	8865a583          	lw	a1,-1914(a1) # 80017570 <sb+0x18>
    80002cf2:	9dbd                	addw	a1,a1,a5
    80002cf4:	4088                	lw	a0,0(s1)
    80002cf6:	fffff097          	auipc	ra,0xfffff
    80002cfa:	7ac080e7          	jalr	1964(ra) # 800024a2 <bread>
    80002cfe:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d00:	05850593          	addi	a1,a0,88
    80002d04:	40dc                	lw	a5,4(s1)
    80002d06:	8bbd                	andi	a5,a5,15
    80002d08:	079a                	slli	a5,a5,0x6
    80002d0a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d0c:	00059783          	lh	a5,0(a1)
    80002d10:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d14:	00259783          	lh	a5,2(a1)
    80002d18:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d1c:	00459783          	lh	a5,4(a1)
    80002d20:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d24:	00659783          	lh	a5,6(a1)
    80002d28:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d2c:	459c                	lw	a5,8(a1)
    80002d2e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d30:	03400613          	li	a2,52
    80002d34:	05b1                	addi	a1,a1,12
    80002d36:	05048513          	addi	a0,s1,80
    80002d3a:	ffffd097          	auipc	ra,0xffffd
    80002d3e:	4f0080e7          	jalr	1264(ra) # 8000022a <memmove>
    brelse(bp);
    80002d42:	854a                	mv	a0,s2
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	88e080e7          	jalr	-1906(ra) # 800025d2 <brelse>
    ip->valid = 1;
    80002d4c:	4785                	li	a5,1
    80002d4e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d50:	04449783          	lh	a5,68(s1)
    80002d54:	fbb5                	bnez	a5,80002cc8 <ilock+0x24>
      panic("ilock: no type");
    80002d56:	00006517          	auipc	a0,0x6
    80002d5a:	9d250513          	addi	a0,a0,-1582 # 80008728 <syscalls_name+0x198>
    80002d5e:	00003097          	auipc	ra,0x3
    80002d62:	00a080e7          	jalr	10(ra) # 80005d68 <panic>

0000000080002d66 <iunlock>:
{
    80002d66:	1101                	addi	sp,sp,-32
    80002d68:	ec06                	sd	ra,24(sp)
    80002d6a:	e822                	sd	s0,16(sp)
    80002d6c:	e426                	sd	s1,8(sp)
    80002d6e:	e04a                	sd	s2,0(sp)
    80002d70:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d72:	c905                	beqz	a0,80002da2 <iunlock+0x3c>
    80002d74:	84aa                	mv	s1,a0
    80002d76:	01050913          	addi	s2,a0,16
    80002d7a:	854a                	mv	a0,s2
    80002d7c:	00001097          	auipc	ra,0x1
    80002d80:	c8c080e7          	jalr	-884(ra) # 80003a08 <holdingsleep>
    80002d84:	cd19                	beqz	a0,80002da2 <iunlock+0x3c>
    80002d86:	449c                	lw	a5,8(s1)
    80002d88:	00f05d63          	blez	a5,80002da2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	00001097          	auipc	ra,0x1
    80002d92:	c36080e7          	jalr	-970(ra) # 800039c4 <releasesleep>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6902                	ld	s2,0(sp)
    80002d9e:	6105                	addi	sp,sp,32
    80002da0:	8082                	ret
    panic("iunlock");
    80002da2:	00006517          	auipc	a0,0x6
    80002da6:	99650513          	addi	a0,a0,-1642 # 80008738 <syscalls_name+0x1a8>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	fbe080e7          	jalr	-66(ra) # 80005d68 <panic>

0000000080002db2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002db2:	7179                	addi	sp,sp,-48
    80002db4:	f406                	sd	ra,40(sp)
    80002db6:	f022                	sd	s0,32(sp)
    80002db8:	ec26                	sd	s1,24(sp)
    80002dba:	e84a                	sd	s2,16(sp)
    80002dbc:	e44e                	sd	s3,8(sp)
    80002dbe:	e052                	sd	s4,0(sp)
    80002dc0:	1800                	addi	s0,sp,48
    80002dc2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dc4:	05050493          	addi	s1,a0,80
    80002dc8:	08050913          	addi	s2,a0,128
    80002dcc:	a021                	j	80002dd4 <itrunc+0x22>
    80002dce:	0491                	addi	s1,s1,4
    80002dd0:	01248d63          	beq	s1,s2,80002dea <itrunc+0x38>
    if(ip->addrs[i]){
    80002dd4:	408c                	lw	a1,0(s1)
    80002dd6:	dde5                	beqz	a1,80002dce <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dd8:	0009a503          	lw	a0,0(s3)
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	90c080e7          	jalr	-1780(ra) # 800026e8 <bfree>
      ip->addrs[i] = 0;
    80002de4:	0004a023          	sw	zero,0(s1)
    80002de8:	b7dd                	j	80002dce <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dea:	0809a583          	lw	a1,128(s3)
    80002dee:	e185                	bnez	a1,80002e0e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002df0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002df4:	854e                	mv	a0,s3
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	de4080e7          	jalr	-540(ra) # 80002bda <iupdate>
}
    80002dfe:	70a2                	ld	ra,40(sp)
    80002e00:	7402                	ld	s0,32(sp)
    80002e02:	64e2                	ld	s1,24(sp)
    80002e04:	6942                	ld	s2,16(sp)
    80002e06:	69a2                	ld	s3,8(sp)
    80002e08:	6a02                	ld	s4,0(sp)
    80002e0a:	6145                	addi	sp,sp,48
    80002e0c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	690080e7          	jalr	1680(ra) # 800024a2 <bread>
    80002e1a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e1c:	05850493          	addi	s1,a0,88
    80002e20:	45850913          	addi	s2,a0,1112
    80002e24:	a811                	j	80002e38 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e26:	0009a503          	lw	a0,0(s3)
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	8be080e7          	jalr	-1858(ra) # 800026e8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e32:	0491                	addi	s1,s1,4
    80002e34:	01248563          	beq	s1,s2,80002e3e <itrunc+0x8c>
      if(a[j])
    80002e38:	408c                	lw	a1,0(s1)
    80002e3a:	dde5                	beqz	a1,80002e32 <itrunc+0x80>
    80002e3c:	b7ed                	j	80002e26 <itrunc+0x74>
    brelse(bp);
    80002e3e:	8552                	mv	a0,s4
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	792080e7          	jalr	1938(ra) # 800025d2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e48:	0809a583          	lw	a1,128(s3)
    80002e4c:	0009a503          	lw	a0,0(s3)
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	898080e7          	jalr	-1896(ra) # 800026e8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e58:	0809a023          	sw	zero,128(s3)
    80002e5c:	bf51                	j	80002df0 <itrunc+0x3e>

0000000080002e5e <iput>:
{
    80002e5e:	1101                	addi	sp,sp,-32
    80002e60:	ec06                	sd	ra,24(sp)
    80002e62:	e822                	sd	s0,16(sp)
    80002e64:	e426                	sd	s1,8(sp)
    80002e66:	e04a                	sd	s2,0(sp)
    80002e68:	1000                	addi	s0,sp,32
    80002e6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e6c:	00014517          	auipc	a0,0x14
    80002e70:	70c50513          	addi	a0,a0,1804 # 80017578 <itable>
    80002e74:	00003097          	auipc	ra,0x3
    80002e78:	43e080e7          	jalr	1086(ra) # 800062b2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e7c:	4498                	lw	a4,8(s1)
    80002e7e:	4785                	li	a5,1
    80002e80:	02f70363          	beq	a4,a5,80002ea6 <iput+0x48>
  ip->ref--;
    80002e84:	449c                	lw	a5,8(s1)
    80002e86:	37fd                	addiw	a5,a5,-1
    80002e88:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e8a:	00014517          	auipc	a0,0x14
    80002e8e:	6ee50513          	addi	a0,a0,1774 # 80017578 <itable>
    80002e92:	00003097          	auipc	ra,0x3
    80002e96:	4d4080e7          	jalr	1236(ra) # 80006366 <release>
}
    80002e9a:	60e2                	ld	ra,24(sp)
    80002e9c:	6442                	ld	s0,16(sp)
    80002e9e:	64a2                	ld	s1,8(sp)
    80002ea0:	6902                	ld	s2,0(sp)
    80002ea2:	6105                	addi	sp,sp,32
    80002ea4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ea6:	40bc                	lw	a5,64(s1)
    80002ea8:	dff1                	beqz	a5,80002e84 <iput+0x26>
    80002eaa:	04a49783          	lh	a5,74(s1)
    80002eae:	fbf9                	bnez	a5,80002e84 <iput+0x26>
    acquiresleep(&ip->lock);
    80002eb0:	01048913          	addi	s2,s1,16
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	00001097          	auipc	ra,0x1
    80002eba:	ab8080e7          	jalr	-1352(ra) # 8000396e <acquiresleep>
    release(&itable.lock);
    80002ebe:	00014517          	auipc	a0,0x14
    80002ec2:	6ba50513          	addi	a0,a0,1722 # 80017578 <itable>
    80002ec6:	00003097          	auipc	ra,0x3
    80002eca:	4a0080e7          	jalr	1184(ra) # 80006366 <release>
    itrunc(ip);
    80002ece:	8526                	mv	a0,s1
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	ee2080e7          	jalr	-286(ra) # 80002db2 <itrunc>
    ip->type = 0;
    80002ed8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002edc:	8526                	mv	a0,s1
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	cfc080e7          	jalr	-772(ra) # 80002bda <iupdate>
    ip->valid = 0;
    80002ee6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eea:	854a                	mv	a0,s2
    80002eec:	00001097          	auipc	ra,0x1
    80002ef0:	ad8080e7          	jalr	-1320(ra) # 800039c4 <releasesleep>
    acquire(&itable.lock);
    80002ef4:	00014517          	auipc	a0,0x14
    80002ef8:	68450513          	addi	a0,a0,1668 # 80017578 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	3b6080e7          	jalr	950(ra) # 800062b2 <acquire>
    80002f04:	b741                	j	80002e84 <iput+0x26>

0000000080002f06 <iunlockput>:
{
    80002f06:	1101                	addi	sp,sp,-32
    80002f08:	ec06                	sd	ra,24(sp)
    80002f0a:	e822                	sd	s0,16(sp)
    80002f0c:	e426                	sd	s1,8(sp)
    80002f0e:	1000                	addi	s0,sp,32
    80002f10:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	e54080e7          	jalr	-428(ra) # 80002d66 <iunlock>
  iput(ip);
    80002f1a:	8526                	mv	a0,s1
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	f42080e7          	jalr	-190(ra) # 80002e5e <iput>
}
    80002f24:	60e2                	ld	ra,24(sp)
    80002f26:	6442                	ld	s0,16(sp)
    80002f28:	64a2                	ld	s1,8(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret

0000000080002f2e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f2e:	1141                	addi	sp,sp,-16
    80002f30:	e422                	sd	s0,8(sp)
    80002f32:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f34:	411c                	lw	a5,0(a0)
    80002f36:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f38:	415c                	lw	a5,4(a0)
    80002f3a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f3c:	04451783          	lh	a5,68(a0)
    80002f40:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f44:	04a51783          	lh	a5,74(a0)
    80002f48:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f4c:	04c56783          	lwu	a5,76(a0)
    80002f50:	e99c                	sd	a5,16(a1)
}
    80002f52:	6422                	ld	s0,8(sp)
    80002f54:	0141                	addi	sp,sp,16
    80002f56:	8082                	ret

0000000080002f58 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f58:	457c                	lw	a5,76(a0)
    80002f5a:	0ed7e963          	bltu	a5,a3,8000304c <readi+0xf4>
{
    80002f5e:	7159                	addi	sp,sp,-112
    80002f60:	f486                	sd	ra,104(sp)
    80002f62:	f0a2                	sd	s0,96(sp)
    80002f64:	eca6                	sd	s1,88(sp)
    80002f66:	e8ca                	sd	s2,80(sp)
    80002f68:	e4ce                	sd	s3,72(sp)
    80002f6a:	e0d2                	sd	s4,64(sp)
    80002f6c:	fc56                	sd	s5,56(sp)
    80002f6e:	f85a                	sd	s6,48(sp)
    80002f70:	f45e                	sd	s7,40(sp)
    80002f72:	f062                	sd	s8,32(sp)
    80002f74:	ec66                	sd	s9,24(sp)
    80002f76:	e86a                	sd	s10,16(sp)
    80002f78:	e46e                	sd	s11,8(sp)
    80002f7a:	1880                	addi	s0,sp,112
    80002f7c:	8baa                	mv	s7,a0
    80002f7e:	8c2e                	mv	s8,a1
    80002f80:	8ab2                	mv	s5,a2
    80002f82:	84b6                	mv	s1,a3
    80002f84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f86:	9f35                	addw	a4,a4,a3
    return 0;
    80002f88:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f8a:	0ad76063          	bltu	a4,a3,8000302a <readi+0xd2>
  if(off + n > ip->size)
    80002f8e:	00e7f463          	bgeu	a5,a4,80002f96 <readi+0x3e>
    n = ip->size - off;
    80002f92:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f96:	0a0b0963          	beqz	s6,80003048 <readi+0xf0>
    80002f9a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f9c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fa0:	5cfd                	li	s9,-1
    80002fa2:	a82d                	j	80002fdc <readi+0x84>
    80002fa4:	020a1d93          	slli	s11,s4,0x20
    80002fa8:	020ddd93          	srli	s11,s11,0x20
    80002fac:	05890613          	addi	a2,s2,88
    80002fb0:	86ee                	mv	a3,s11
    80002fb2:	963a                	add	a2,a2,a4
    80002fb4:	85d6                	mv	a1,s5
    80002fb6:	8562                	mv	a0,s8
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	a46080e7          	jalr	-1466(ra) # 800019fe <either_copyout>
    80002fc0:	05950d63          	beq	a0,s9,8000301a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	60c080e7          	jalr	1548(ra) # 800025d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fce:	013a09bb          	addw	s3,s4,s3
    80002fd2:	009a04bb          	addw	s1,s4,s1
    80002fd6:	9aee                	add	s5,s5,s11
    80002fd8:	0569f763          	bgeu	s3,s6,80003026 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fdc:	000ba903          	lw	s2,0(s7)
    80002fe0:	00a4d59b          	srliw	a1,s1,0xa
    80002fe4:	855e                	mv	a0,s7
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	8b0080e7          	jalr	-1872(ra) # 80002896 <bmap>
    80002fee:	0005059b          	sext.w	a1,a0
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	4ae080e7          	jalr	1198(ra) # 800024a2 <bread>
    80002ffc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffe:	3ff4f713          	andi	a4,s1,1023
    80003002:	40ed07bb          	subw	a5,s10,a4
    80003006:	413b06bb          	subw	a3,s6,s3
    8000300a:	8a3e                	mv	s4,a5
    8000300c:	2781                	sext.w	a5,a5
    8000300e:	0006861b          	sext.w	a2,a3
    80003012:	f8f679e3          	bgeu	a2,a5,80002fa4 <readi+0x4c>
    80003016:	8a36                	mv	s4,a3
    80003018:	b771                	j	80002fa4 <readi+0x4c>
      brelse(bp);
    8000301a:	854a                	mv	a0,s2
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	5b6080e7          	jalr	1462(ra) # 800025d2 <brelse>
      tot = -1;
    80003024:	59fd                	li	s3,-1
  }
  return tot;
    80003026:	0009851b          	sext.w	a0,s3
}
    8000302a:	70a6                	ld	ra,104(sp)
    8000302c:	7406                	ld	s0,96(sp)
    8000302e:	64e6                	ld	s1,88(sp)
    80003030:	6946                	ld	s2,80(sp)
    80003032:	69a6                	ld	s3,72(sp)
    80003034:	6a06                	ld	s4,64(sp)
    80003036:	7ae2                	ld	s5,56(sp)
    80003038:	7b42                	ld	s6,48(sp)
    8000303a:	7ba2                	ld	s7,40(sp)
    8000303c:	7c02                	ld	s8,32(sp)
    8000303e:	6ce2                	ld	s9,24(sp)
    80003040:	6d42                	ld	s10,16(sp)
    80003042:	6da2                	ld	s11,8(sp)
    80003044:	6165                	addi	sp,sp,112
    80003046:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003048:	89da                	mv	s3,s6
    8000304a:	bff1                	j	80003026 <readi+0xce>
    return 0;
    8000304c:	4501                	li	a0,0
}
    8000304e:	8082                	ret

0000000080003050 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003050:	457c                	lw	a5,76(a0)
    80003052:	10d7e863          	bltu	a5,a3,80003162 <writei+0x112>
{
    80003056:	7159                	addi	sp,sp,-112
    80003058:	f486                	sd	ra,104(sp)
    8000305a:	f0a2                	sd	s0,96(sp)
    8000305c:	eca6                	sd	s1,88(sp)
    8000305e:	e8ca                	sd	s2,80(sp)
    80003060:	e4ce                	sd	s3,72(sp)
    80003062:	e0d2                	sd	s4,64(sp)
    80003064:	fc56                	sd	s5,56(sp)
    80003066:	f85a                	sd	s6,48(sp)
    80003068:	f45e                	sd	s7,40(sp)
    8000306a:	f062                	sd	s8,32(sp)
    8000306c:	ec66                	sd	s9,24(sp)
    8000306e:	e86a                	sd	s10,16(sp)
    80003070:	e46e                	sd	s11,8(sp)
    80003072:	1880                	addi	s0,sp,112
    80003074:	8b2a                	mv	s6,a0
    80003076:	8c2e                	mv	s8,a1
    80003078:	8ab2                	mv	s5,a2
    8000307a:	8936                	mv	s2,a3
    8000307c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000307e:	00e687bb          	addw	a5,a3,a4
    80003082:	0ed7e263          	bltu	a5,a3,80003166 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003086:	00043737          	lui	a4,0x43
    8000308a:	0ef76063          	bltu	a4,a5,8000316a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000308e:	0c0b8863          	beqz	s7,8000315e <writei+0x10e>
    80003092:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003094:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003098:	5cfd                	li	s9,-1
    8000309a:	a091                	j	800030de <writei+0x8e>
    8000309c:	02099d93          	slli	s11,s3,0x20
    800030a0:	020ddd93          	srli	s11,s11,0x20
    800030a4:	05848513          	addi	a0,s1,88
    800030a8:	86ee                	mv	a3,s11
    800030aa:	8656                	mv	a2,s5
    800030ac:	85e2                	mv	a1,s8
    800030ae:	953a                	add	a0,a0,a4
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	9a4080e7          	jalr	-1628(ra) # 80001a54 <either_copyin>
    800030b8:	07950263          	beq	a0,s9,8000311c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030bc:	8526                	mv	a0,s1
    800030be:	00000097          	auipc	ra,0x0
    800030c2:	790080e7          	jalr	1936(ra) # 8000384e <log_write>
    brelse(bp);
    800030c6:	8526                	mv	a0,s1
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	50a080e7          	jalr	1290(ra) # 800025d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d0:	01498a3b          	addw	s4,s3,s4
    800030d4:	0129893b          	addw	s2,s3,s2
    800030d8:	9aee                	add	s5,s5,s11
    800030da:	057a7663          	bgeu	s4,s7,80003126 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030de:	000b2483          	lw	s1,0(s6)
    800030e2:	00a9559b          	srliw	a1,s2,0xa
    800030e6:	855a                	mv	a0,s6
    800030e8:	fffff097          	auipc	ra,0xfffff
    800030ec:	7ae080e7          	jalr	1966(ra) # 80002896 <bmap>
    800030f0:	0005059b          	sext.w	a1,a0
    800030f4:	8526                	mv	a0,s1
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	3ac080e7          	jalr	940(ra) # 800024a2 <bread>
    800030fe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003100:	3ff97713          	andi	a4,s2,1023
    80003104:	40ed07bb          	subw	a5,s10,a4
    80003108:	414b86bb          	subw	a3,s7,s4
    8000310c:	89be                	mv	s3,a5
    8000310e:	2781                	sext.w	a5,a5
    80003110:	0006861b          	sext.w	a2,a3
    80003114:	f8f674e3          	bgeu	a2,a5,8000309c <writei+0x4c>
    80003118:	89b6                	mv	s3,a3
    8000311a:	b749                	j	8000309c <writei+0x4c>
      brelse(bp);
    8000311c:	8526                	mv	a0,s1
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	4b4080e7          	jalr	1204(ra) # 800025d2 <brelse>
  }

  if(off > ip->size)
    80003126:	04cb2783          	lw	a5,76(s6)
    8000312a:	0127f463          	bgeu	a5,s2,80003132 <writei+0xe2>
    ip->size = off;
    8000312e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003132:	855a                	mv	a0,s6
    80003134:	00000097          	auipc	ra,0x0
    80003138:	aa6080e7          	jalr	-1370(ra) # 80002bda <iupdate>

  return tot;
    8000313c:	000a051b          	sext.w	a0,s4
}
    80003140:	70a6                	ld	ra,104(sp)
    80003142:	7406                	ld	s0,96(sp)
    80003144:	64e6                	ld	s1,88(sp)
    80003146:	6946                	ld	s2,80(sp)
    80003148:	69a6                	ld	s3,72(sp)
    8000314a:	6a06                	ld	s4,64(sp)
    8000314c:	7ae2                	ld	s5,56(sp)
    8000314e:	7b42                	ld	s6,48(sp)
    80003150:	7ba2                	ld	s7,40(sp)
    80003152:	7c02                	ld	s8,32(sp)
    80003154:	6ce2                	ld	s9,24(sp)
    80003156:	6d42                	ld	s10,16(sp)
    80003158:	6da2                	ld	s11,8(sp)
    8000315a:	6165                	addi	sp,sp,112
    8000315c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000315e:	8a5e                	mv	s4,s7
    80003160:	bfc9                	j	80003132 <writei+0xe2>
    return -1;
    80003162:	557d                	li	a0,-1
}
    80003164:	8082                	ret
    return -1;
    80003166:	557d                	li	a0,-1
    80003168:	bfe1                	j	80003140 <writei+0xf0>
    return -1;
    8000316a:	557d                	li	a0,-1
    8000316c:	bfd1                	j	80003140 <writei+0xf0>

000000008000316e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000316e:	1141                	addi	sp,sp,-16
    80003170:	e406                	sd	ra,8(sp)
    80003172:	e022                	sd	s0,0(sp)
    80003174:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003176:	4639                	li	a2,14
    80003178:	ffffd097          	auipc	ra,0xffffd
    8000317c:	12a080e7          	jalr	298(ra) # 800002a2 <strncmp>
}
    80003180:	60a2                	ld	ra,8(sp)
    80003182:	6402                	ld	s0,0(sp)
    80003184:	0141                	addi	sp,sp,16
    80003186:	8082                	ret

0000000080003188 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003188:	7139                	addi	sp,sp,-64
    8000318a:	fc06                	sd	ra,56(sp)
    8000318c:	f822                	sd	s0,48(sp)
    8000318e:	f426                	sd	s1,40(sp)
    80003190:	f04a                	sd	s2,32(sp)
    80003192:	ec4e                	sd	s3,24(sp)
    80003194:	e852                	sd	s4,16(sp)
    80003196:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003198:	04451703          	lh	a4,68(a0)
    8000319c:	4785                	li	a5,1
    8000319e:	00f71a63          	bne	a4,a5,800031b2 <dirlookup+0x2a>
    800031a2:	892a                	mv	s2,a0
    800031a4:	89ae                	mv	s3,a1
    800031a6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a8:	457c                	lw	a5,76(a0)
    800031aa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031ac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ae:	e79d                	bnez	a5,800031dc <dirlookup+0x54>
    800031b0:	a8a5                	j	80003228 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031b2:	00005517          	auipc	a0,0x5
    800031b6:	58e50513          	addi	a0,a0,1422 # 80008740 <syscalls_name+0x1b0>
    800031ba:	00003097          	auipc	ra,0x3
    800031be:	bae080e7          	jalr	-1106(ra) # 80005d68 <panic>
      panic("dirlookup read");
    800031c2:	00005517          	auipc	a0,0x5
    800031c6:	59650513          	addi	a0,a0,1430 # 80008758 <syscalls_name+0x1c8>
    800031ca:	00003097          	auipc	ra,0x3
    800031ce:	b9e080e7          	jalr	-1122(ra) # 80005d68 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031d2:	24c1                	addiw	s1,s1,16
    800031d4:	04c92783          	lw	a5,76(s2)
    800031d8:	04f4f763          	bgeu	s1,a5,80003226 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031dc:	4741                	li	a4,16
    800031de:	86a6                	mv	a3,s1
    800031e0:	fc040613          	addi	a2,s0,-64
    800031e4:	4581                	li	a1,0
    800031e6:	854a                	mv	a0,s2
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	d70080e7          	jalr	-656(ra) # 80002f58 <readi>
    800031f0:	47c1                	li	a5,16
    800031f2:	fcf518e3          	bne	a0,a5,800031c2 <dirlookup+0x3a>
    if(de.inum == 0)
    800031f6:	fc045783          	lhu	a5,-64(s0)
    800031fa:	dfe1                	beqz	a5,800031d2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031fc:	fc240593          	addi	a1,s0,-62
    80003200:	854e                	mv	a0,s3
    80003202:	00000097          	auipc	ra,0x0
    80003206:	f6c080e7          	jalr	-148(ra) # 8000316e <namecmp>
    8000320a:	f561                	bnez	a0,800031d2 <dirlookup+0x4a>
      if(poff)
    8000320c:	000a0463          	beqz	s4,80003214 <dirlookup+0x8c>
        *poff = off;
    80003210:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003214:	fc045583          	lhu	a1,-64(s0)
    80003218:	00092503          	lw	a0,0(s2)
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	754080e7          	jalr	1876(ra) # 80002970 <iget>
    80003224:	a011                	j	80003228 <dirlookup+0xa0>
  return 0;
    80003226:	4501                	li	a0,0
}
    80003228:	70e2                	ld	ra,56(sp)
    8000322a:	7442                	ld	s0,48(sp)
    8000322c:	74a2                	ld	s1,40(sp)
    8000322e:	7902                	ld	s2,32(sp)
    80003230:	69e2                	ld	s3,24(sp)
    80003232:	6a42                	ld	s4,16(sp)
    80003234:	6121                	addi	sp,sp,64
    80003236:	8082                	ret

0000000080003238 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003238:	711d                	addi	sp,sp,-96
    8000323a:	ec86                	sd	ra,88(sp)
    8000323c:	e8a2                	sd	s0,80(sp)
    8000323e:	e4a6                	sd	s1,72(sp)
    80003240:	e0ca                	sd	s2,64(sp)
    80003242:	fc4e                	sd	s3,56(sp)
    80003244:	f852                	sd	s4,48(sp)
    80003246:	f456                	sd	s5,40(sp)
    80003248:	f05a                	sd	s6,32(sp)
    8000324a:	ec5e                	sd	s7,24(sp)
    8000324c:	e862                	sd	s8,16(sp)
    8000324e:	e466                	sd	s9,8(sp)
    80003250:	1080                	addi	s0,sp,96
    80003252:	84aa                	mv	s1,a0
    80003254:	8b2e                	mv	s6,a1
    80003256:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003258:	00054703          	lbu	a4,0(a0)
    8000325c:	02f00793          	li	a5,47
    80003260:	02f70363          	beq	a4,a5,80003286 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	d32080e7          	jalr	-718(ra) # 80000f96 <myproc>
    8000326c:	15053503          	ld	a0,336(a0)
    80003270:	00000097          	auipc	ra,0x0
    80003274:	9f6080e7          	jalr	-1546(ra) # 80002c66 <idup>
    80003278:	89aa                	mv	s3,a0
  while(*path == '/')
    8000327a:	02f00913          	li	s2,47
  len = path - s;
    8000327e:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003280:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003282:	4c05                	li	s8,1
    80003284:	a865                	j	8000333c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003286:	4585                	li	a1,1
    80003288:	4505                	li	a0,1
    8000328a:	fffff097          	auipc	ra,0xfffff
    8000328e:	6e6080e7          	jalr	1766(ra) # 80002970 <iget>
    80003292:	89aa                	mv	s3,a0
    80003294:	b7dd                	j	8000327a <namex+0x42>
      iunlockput(ip);
    80003296:	854e                	mv	a0,s3
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	c6e080e7          	jalr	-914(ra) # 80002f06 <iunlockput>
      return 0;
    800032a0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032a2:	854e                	mv	a0,s3
    800032a4:	60e6                	ld	ra,88(sp)
    800032a6:	6446                	ld	s0,80(sp)
    800032a8:	64a6                	ld	s1,72(sp)
    800032aa:	6906                	ld	s2,64(sp)
    800032ac:	79e2                	ld	s3,56(sp)
    800032ae:	7a42                	ld	s4,48(sp)
    800032b0:	7aa2                	ld	s5,40(sp)
    800032b2:	7b02                	ld	s6,32(sp)
    800032b4:	6be2                	ld	s7,24(sp)
    800032b6:	6c42                	ld	s8,16(sp)
    800032b8:	6ca2                	ld	s9,8(sp)
    800032ba:	6125                	addi	sp,sp,96
    800032bc:	8082                	ret
      iunlock(ip);
    800032be:	854e                	mv	a0,s3
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	aa6080e7          	jalr	-1370(ra) # 80002d66 <iunlock>
      return ip;
    800032c8:	bfe9                	j	800032a2 <namex+0x6a>
      iunlockput(ip);
    800032ca:	854e                	mv	a0,s3
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	c3a080e7          	jalr	-966(ra) # 80002f06 <iunlockput>
      return 0;
    800032d4:	89d2                	mv	s3,s4
    800032d6:	b7f1                	j	800032a2 <namex+0x6a>
  len = path - s;
    800032d8:	40b48633          	sub	a2,s1,a1
    800032dc:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032e0:	094cd463          	bge	s9,s4,80003368 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032e4:	4639                	li	a2,14
    800032e6:	8556                	mv	a0,s5
    800032e8:	ffffd097          	auipc	ra,0xffffd
    800032ec:	f42080e7          	jalr	-190(ra) # 8000022a <memmove>
  while(*path == '/')
    800032f0:	0004c783          	lbu	a5,0(s1)
    800032f4:	01279763          	bne	a5,s2,80003302 <namex+0xca>
    path++;
    800032f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032fa:	0004c783          	lbu	a5,0(s1)
    800032fe:	ff278de3          	beq	a5,s2,800032f8 <namex+0xc0>
    ilock(ip);
    80003302:	854e                	mv	a0,s3
    80003304:	00000097          	auipc	ra,0x0
    80003308:	9a0080e7          	jalr	-1632(ra) # 80002ca4 <ilock>
    if(ip->type != T_DIR){
    8000330c:	04499783          	lh	a5,68(s3)
    80003310:	f98793e3          	bne	a5,s8,80003296 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003314:	000b0563          	beqz	s6,8000331e <namex+0xe6>
    80003318:	0004c783          	lbu	a5,0(s1)
    8000331c:	d3cd                	beqz	a5,800032be <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000331e:	865e                	mv	a2,s7
    80003320:	85d6                	mv	a1,s5
    80003322:	854e                	mv	a0,s3
    80003324:	00000097          	auipc	ra,0x0
    80003328:	e64080e7          	jalr	-412(ra) # 80003188 <dirlookup>
    8000332c:	8a2a                	mv	s4,a0
    8000332e:	dd51                	beqz	a0,800032ca <namex+0x92>
    iunlockput(ip);
    80003330:	854e                	mv	a0,s3
    80003332:	00000097          	auipc	ra,0x0
    80003336:	bd4080e7          	jalr	-1068(ra) # 80002f06 <iunlockput>
    ip = next;
    8000333a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000333c:	0004c783          	lbu	a5,0(s1)
    80003340:	05279763          	bne	a5,s2,8000338e <namex+0x156>
    path++;
    80003344:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003346:	0004c783          	lbu	a5,0(s1)
    8000334a:	ff278de3          	beq	a5,s2,80003344 <namex+0x10c>
  if(*path == 0)
    8000334e:	c79d                	beqz	a5,8000337c <namex+0x144>
    path++;
    80003350:	85a6                	mv	a1,s1
  len = path - s;
    80003352:	8a5e                	mv	s4,s7
    80003354:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003356:	01278963          	beq	a5,s2,80003368 <namex+0x130>
    8000335a:	dfbd                	beqz	a5,800032d8 <namex+0xa0>
    path++;
    8000335c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000335e:	0004c783          	lbu	a5,0(s1)
    80003362:	ff279ce3          	bne	a5,s2,8000335a <namex+0x122>
    80003366:	bf8d                	j	800032d8 <namex+0xa0>
    memmove(name, s, len);
    80003368:	2601                	sext.w	a2,a2
    8000336a:	8556                	mv	a0,s5
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	ebe080e7          	jalr	-322(ra) # 8000022a <memmove>
    name[len] = 0;
    80003374:	9a56                	add	s4,s4,s5
    80003376:	000a0023          	sb	zero,0(s4)
    8000337a:	bf9d                	j	800032f0 <namex+0xb8>
  if(nameiparent){
    8000337c:	f20b03e3          	beqz	s6,800032a2 <namex+0x6a>
    iput(ip);
    80003380:	854e                	mv	a0,s3
    80003382:	00000097          	auipc	ra,0x0
    80003386:	adc080e7          	jalr	-1316(ra) # 80002e5e <iput>
    return 0;
    8000338a:	4981                	li	s3,0
    8000338c:	bf19                	j	800032a2 <namex+0x6a>
  if(*path == 0)
    8000338e:	d7fd                	beqz	a5,8000337c <namex+0x144>
  while(*path != '/' && *path != 0)
    80003390:	0004c783          	lbu	a5,0(s1)
    80003394:	85a6                	mv	a1,s1
    80003396:	b7d1                	j	8000335a <namex+0x122>

0000000080003398 <dirlink>:
{
    80003398:	7139                	addi	sp,sp,-64
    8000339a:	fc06                	sd	ra,56(sp)
    8000339c:	f822                	sd	s0,48(sp)
    8000339e:	f426                	sd	s1,40(sp)
    800033a0:	f04a                	sd	s2,32(sp)
    800033a2:	ec4e                	sd	s3,24(sp)
    800033a4:	e852                	sd	s4,16(sp)
    800033a6:	0080                	addi	s0,sp,64
    800033a8:	892a                	mv	s2,a0
    800033aa:	8a2e                	mv	s4,a1
    800033ac:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033ae:	4601                	li	a2,0
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	dd8080e7          	jalr	-552(ra) # 80003188 <dirlookup>
    800033b8:	e93d                	bnez	a0,8000342e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ba:	04c92483          	lw	s1,76(s2)
    800033be:	c49d                	beqz	s1,800033ec <dirlink+0x54>
    800033c0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c2:	4741                	li	a4,16
    800033c4:	86a6                	mv	a3,s1
    800033c6:	fc040613          	addi	a2,s0,-64
    800033ca:	4581                	li	a1,0
    800033cc:	854a                	mv	a0,s2
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	b8a080e7          	jalr	-1142(ra) # 80002f58 <readi>
    800033d6:	47c1                	li	a5,16
    800033d8:	06f51163          	bne	a0,a5,8000343a <dirlink+0xa2>
    if(de.inum == 0)
    800033dc:	fc045783          	lhu	a5,-64(s0)
    800033e0:	c791                	beqz	a5,800033ec <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e2:	24c1                	addiw	s1,s1,16
    800033e4:	04c92783          	lw	a5,76(s2)
    800033e8:	fcf4ede3          	bltu	s1,a5,800033c2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033ec:	4639                	li	a2,14
    800033ee:	85d2                	mv	a1,s4
    800033f0:	fc240513          	addi	a0,s0,-62
    800033f4:	ffffd097          	auipc	ra,0xffffd
    800033f8:	eea080e7          	jalr	-278(ra) # 800002de <strncpy>
  de.inum = inum;
    800033fc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003400:	4741                	li	a4,16
    80003402:	86a6                	mv	a3,s1
    80003404:	fc040613          	addi	a2,s0,-64
    80003408:	4581                	li	a1,0
    8000340a:	854a                	mv	a0,s2
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	c44080e7          	jalr	-956(ra) # 80003050 <writei>
    80003414:	872a                	mv	a4,a0
    80003416:	47c1                	li	a5,16
  return 0;
    80003418:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341a:	02f71863          	bne	a4,a5,8000344a <dirlink+0xb2>
}
    8000341e:	70e2                	ld	ra,56(sp)
    80003420:	7442                	ld	s0,48(sp)
    80003422:	74a2                	ld	s1,40(sp)
    80003424:	7902                	ld	s2,32(sp)
    80003426:	69e2                	ld	s3,24(sp)
    80003428:	6a42                	ld	s4,16(sp)
    8000342a:	6121                	addi	sp,sp,64
    8000342c:	8082                	ret
    iput(ip);
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	a30080e7          	jalr	-1488(ra) # 80002e5e <iput>
    return -1;
    80003436:	557d                	li	a0,-1
    80003438:	b7dd                	j	8000341e <dirlink+0x86>
      panic("dirlink read");
    8000343a:	00005517          	auipc	a0,0x5
    8000343e:	32e50513          	addi	a0,a0,814 # 80008768 <syscalls_name+0x1d8>
    80003442:	00003097          	auipc	ra,0x3
    80003446:	926080e7          	jalr	-1754(ra) # 80005d68 <panic>
    panic("dirlink");
    8000344a:	00005517          	auipc	a0,0x5
    8000344e:	41e50513          	addi	a0,a0,1054 # 80008868 <syscalls_name+0x2d8>
    80003452:	00003097          	auipc	ra,0x3
    80003456:	916080e7          	jalr	-1770(ra) # 80005d68 <panic>

000000008000345a <namei>:

struct inode*
namei(char *path)
{
    8000345a:	1101                	addi	sp,sp,-32
    8000345c:	ec06                	sd	ra,24(sp)
    8000345e:	e822                	sd	s0,16(sp)
    80003460:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003462:	fe040613          	addi	a2,s0,-32
    80003466:	4581                	li	a1,0
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	dd0080e7          	jalr	-560(ra) # 80003238 <namex>
}
    80003470:	60e2                	ld	ra,24(sp)
    80003472:	6442                	ld	s0,16(sp)
    80003474:	6105                	addi	sp,sp,32
    80003476:	8082                	ret

0000000080003478 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003478:	1141                	addi	sp,sp,-16
    8000347a:	e406                	sd	ra,8(sp)
    8000347c:	e022                	sd	s0,0(sp)
    8000347e:	0800                	addi	s0,sp,16
    80003480:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003482:	4585                	li	a1,1
    80003484:	00000097          	auipc	ra,0x0
    80003488:	db4080e7          	jalr	-588(ra) # 80003238 <namex>
}
    8000348c:	60a2                	ld	ra,8(sp)
    8000348e:	6402                	ld	s0,0(sp)
    80003490:	0141                	addi	sp,sp,16
    80003492:	8082                	ret

0000000080003494 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	e426                	sd	s1,8(sp)
    8000349c:	e04a                	sd	s2,0(sp)
    8000349e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034a0:	00016917          	auipc	s2,0x16
    800034a4:	b8090913          	addi	s2,s2,-1152 # 80019020 <log>
    800034a8:	01892583          	lw	a1,24(s2)
    800034ac:	02892503          	lw	a0,40(s2)
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	ff2080e7          	jalr	-14(ra) # 800024a2 <bread>
    800034b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ba:	02c92683          	lw	a3,44(s2)
    800034be:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034c0:	02d05763          	blez	a3,800034ee <write_head+0x5a>
    800034c4:	00016797          	auipc	a5,0x16
    800034c8:	b8c78793          	addi	a5,a5,-1140 # 80019050 <log+0x30>
    800034cc:	05c50713          	addi	a4,a0,92
    800034d0:	36fd                	addiw	a3,a3,-1
    800034d2:	1682                	slli	a3,a3,0x20
    800034d4:	9281                	srli	a3,a3,0x20
    800034d6:	068a                	slli	a3,a3,0x2
    800034d8:	00016617          	auipc	a2,0x16
    800034dc:	b7c60613          	addi	a2,a2,-1156 # 80019054 <log+0x34>
    800034e0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034e2:	4390                	lw	a2,0(a5)
    800034e4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034e6:	0791                	addi	a5,a5,4
    800034e8:	0711                	addi	a4,a4,4
    800034ea:	fed79ce3          	bne	a5,a3,800034e2 <write_head+0x4e>
  }
  bwrite(buf);
    800034ee:	8526                	mv	a0,s1
    800034f0:	fffff097          	auipc	ra,0xfffff
    800034f4:	0a4080e7          	jalr	164(ra) # 80002594 <bwrite>
  brelse(buf);
    800034f8:	8526                	mv	a0,s1
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	0d8080e7          	jalr	216(ra) # 800025d2 <brelse>
}
    80003502:	60e2                	ld	ra,24(sp)
    80003504:	6442                	ld	s0,16(sp)
    80003506:	64a2                	ld	s1,8(sp)
    80003508:	6902                	ld	s2,0(sp)
    8000350a:	6105                	addi	sp,sp,32
    8000350c:	8082                	ret

000000008000350e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000350e:	00016797          	auipc	a5,0x16
    80003512:	b3e7a783          	lw	a5,-1218(a5) # 8001904c <log+0x2c>
    80003516:	0af05d63          	blez	a5,800035d0 <install_trans+0xc2>
{
    8000351a:	7139                	addi	sp,sp,-64
    8000351c:	fc06                	sd	ra,56(sp)
    8000351e:	f822                	sd	s0,48(sp)
    80003520:	f426                	sd	s1,40(sp)
    80003522:	f04a                	sd	s2,32(sp)
    80003524:	ec4e                	sd	s3,24(sp)
    80003526:	e852                	sd	s4,16(sp)
    80003528:	e456                	sd	s5,8(sp)
    8000352a:	e05a                	sd	s6,0(sp)
    8000352c:	0080                	addi	s0,sp,64
    8000352e:	8b2a                	mv	s6,a0
    80003530:	00016a97          	auipc	s5,0x16
    80003534:	b20a8a93          	addi	s5,s5,-1248 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003538:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000353a:	00016997          	auipc	s3,0x16
    8000353e:	ae698993          	addi	s3,s3,-1306 # 80019020 <log>
    80003542:	a035                	j	8000356e <install_trans+0x60>
      bunpin(dbuf);
    80003544:	8526                	mv	a0,s1
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	166080e7          	jalr	358(ra) # 800026ac <bunpin>
    brelse(lbuf);
    8000354e:	854a                	mv	a0,s2
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	082080e7          	jalr	130(ra) # 800025d2 <brelse>
    brelse(dbuf);
    80003558:	8526                	mv	a0,s1
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	078080e7          	jalr	120(ra) # 800025d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003562:	2a05                	addiw	s4,s4,1
    80003564:	0a91                	addi	s5,s5,4
    80003566:	02c9a783          	lw	a5,44(s3)
    8000356a:	04fa5963          	bge	s4,a5,800035bc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000356e:	0189a583          	lw	a1,24(s3)
    80003572:	014585bb          	addw	a1,a1,s4
    80003576:	2585                	addiw	a1,a1,1
    80003578:	0289a503          	lw	a0,40(s3)
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	f26080e7          	jalr	-218(ra) # 800024a2 <bread>
    80003584:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003586:	000aa583          	lw	a1,0(s5)
    8000358a:	0289a503          	lw	a0,40(s3)
    8000358e:	fffff097          	auipc	ra,0xfffff
    80003592:	f14080e7          	jalr	-236(ra) # 800024a2 <bread>
    80003596:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003598:	40000613          	li	a2,1024
    8000359c:	05890593          	addi	a1,s2,88
    800035a0:	05850513          	addi	a0,a0,88
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	c86080e7          	jalr	-890(ra) # 8000022a <memmove>
    bwrite(dbuf);  // write dst to disk
    800035ac:	8526                	mv	a0,s1
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	fe6080e7          	jalr	-26(ra) # 80002594 <bwrite>
    if(recovering == 0)
    800035b6:	f80b1ce3          	bnez	s6,8000354e <install_trans+0x40>
    800035ba:	b769                	j	80003544 <install_trans+0x36>
}
    800035bc:	70e2                	ld	ra,56(sp)
    800035be:	7442                	ld	s0,48(sp)
    800035c0:	74a2                	ld	s1,40(sp)
    800035c2:	7902                	ld	s2,32(sp)
    800035c4:	69e2                	ld	s3,24(sp)
    800035c6:	6a42                	ld	s4,16(sp)
    800035c8:	6aa2                	ld	s5,8(sp)
    800035ca:	6b02                	ld	s6,0(sp)
    800035cc:	6121                	addi	sp,sp,64
    800035ce:	8082                	ret
    800035d0:	8082                	ret

00000000800035d2 <initlog>:
{
    800035d2:	7179                	addi	sp,sp,-48
    800035d4:	f406                	sd	ra,40(sp)
    800035d6:	f022                	sd	s0,32(sp)
    800035d8:	ec26                	sd	s1,24(sp)
    800035da:	e84a                	sd	s2,16(sp)
    800035dc:	e44e                	sd	s3,8(sp)
    800035de:	1800                	addi	s0,sp,48
    800035e0:	892a                	mv	s2,a0
    800035e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035e4:	00016497          	auipc	s1,0x16
    800035e8:	a3c48493          	addi	s1,s1,-1476 # 80019020 <log>
    800035ec:	00005597          	auipc	a1,0x5
    800035f0:	18c58593          	addi	a1,a1,396 # 80008778 <syscalls_name+0x1e8>
    800035f4:	8526                	mv	a0,s1
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	c2c080e7          	jalr	-980(ra) # 80006222 <initlock>
  log.start = sb->logstart;
    800035fe:	0149a583          	lw	a1,20(s3)
    80003602:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003604:	0109a783          	lw	a5,16(s3)
    80003608:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000360a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000360e:	854a                	mv	a0,s2
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	e92080e7          	jalr	-366(ra) # 800024a2 <bread>
  log.lh.n = lh->n;
    80003618:	4d3c                	lw	a5,88(a0)
    8000361a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000361c:	02f05563          	blez	a5,80003646 <initlog+0x74>
    80003620:	05c50713          	addi	a4,a0,92
    80003624:	00016697          	auipc	a3,0x16
    80003628:	a2c68693          	addi	a3,a3,-1492 # 80019050 <log+0x30>
    8000362c:	37fd                	addiw	a5,a5,-1
    8000362e:	1782                	slli	a5,a5,0x20
    80003630:	9381                	srli	a5,a5,0x20
    80003632:	078a                	slli	a5,a5,0x2
    80003634:	06050613          	addi	a2,a0,96
    80003638:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000363a:	4310                	lw	a2,0(a4)
    8000363c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000363e:	0711                	addi	a4,a4,4
    80003640:	0691                	addi	a3,a3,4
    80003642:	fef71ce3          	bne	a4,a5,8000363a <initlog+0x68>
  brelse(buf);
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	f8c080e7          	jalr	-116(ra) # 800025d2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000364e:	4505                	li	a0,1
    80003650:	00000097          	auipc	ra,0x0
    80003654:	ebe080e7          	jalr	-322(ra) # 8000350e <install_trans>
  log.lh.n = 0;
    80003658:	00016797          	auipc	a5,0x16
    8000365c:	9e07aa23          	sw	zero,-1548(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003660:	00000097          	auipc	ra,0x0
    80003664:	e34080e7          	jalr	-460(ra) # 80003494 <write_head>
}
    80003668:	70a2                	ld	ra,40(sp)
    8000366a:	7402                	ld	s0,32(sp)
    8000366c:	64e2                	ld	s1,24(sp)
    8000366e:	6942                	ld	s2,16(sp)
    80003670:	69a2                	ld	s3,8(sp)
    80003672:	6145                	addi	sp,sp,48
    80003674:	8082                	ret

0000000080003676 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003676:	1101                	addi	sp,sp,-32
    80003678:	ec06                	sd	ra,24(sp)
    8000367a:	e822                	sd	s0,16(sp)
    8000367c:	e426                	sd	s1,8(sp)
    8000367e:	e04a                	sd	s2,0(sp)
    80003680:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003682:	00016517          	auipc	a0,0x16
    80003686:	99e50513          	addi	a0,a0,-1634 # 80019020 <log>
    8000368a:	00003097          	auipc	ra,0x3
    8000368e:	c28080e7          	jalr	-984(ra) # 800062b2 <acquire>
  while(1){
    if(log.committing){
    80003692:	00016497          	auipc	s1,0x16
    80003696:	98e48493          	addi	s1,s1,-1650 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000369a:	4979                	li	s2,30
    8000369c:	a039                	j	800036aa <begin_op+0x34>
      sleep(&log, &log.lock);
    8000369e:	85a6                	mv	a1,s1
    800036a0:	8526                	mv	a0,s1
    800036a2:	ffffe097          	auipc	ra,0xffffe
    800036a6:	fb8080e7          	jalr	-72(ra) # 8000165a <sleep>
    if(log.committing){
    800036aa:	50dc                	lw	a5,36(s1)
    800036ac:	fbed                	bnez	a5,8000369e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ae:	509c                	lw	a5,32(s1)
    800036b0:	0017871b          	addiw	a4,a5,1
    800036b4:	0007069b          	sext.w	a3,a4
    800036b8:	0027179b          	slliw	a5,a4,0x2
    800036bc:	9fb9                	addw	a5,a5,a4
    800036be:	0017979b          	slliw	a5,a5,0x1
    800036c2:	54d8                	lw	a4,44(s1)
    800036c4:	9fb9                	addw	a5,a5,a4
    800036c6:	00f95963          	bge	s2,a5,800036d8 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036ca:	85a6                	mv	a1,s1
    800036cc:	8526                	mv	a0,s1
    800036ce:	ffffe097          	auipc	ra,0xffffe
    800036d2:	f8c080e7          	jalr	-116(ra) # 8000165a <sleep>
    800036d6:	bfd1                	j	800036aa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036d8:	00016517          	auipc	a0,0x16
    800036dc:	94850513          	addi	a0,a0,-1720 # 80019020 <log>
    800036e0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	c84080e7          	jalr	-892(ra) # 80006366 <release>
      break;
    }
  }
}
    800036ea:	60e2                	ld	ra,24(sp)
    800036ec:	6442                	ld	s0,16(sp)
    800036ee:	64a2                	ld	s1,8(sp)
    800036f0:	6902                	ld	s2,0(sp)
    800036f2:	6105                	addi	sp,sp,32
    800036f4:	8082                	ret

00000000800036f6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036f6:	7139                	addi	sp,sp,-64
    800036f8:	fc06                	sd	ra,56(sp)
    800036fa:	f822                	sd	s0,48(sp)
    800036fc:	f426                	sd	s1,40(sp)
    800036fe:	f04a                	sd	s2,32(sp)
    80003700:	ec4e                	sd	s3,24(sp)
    80003702:	e852                	sd	s4,16(sp)
    80003704:	e456                	sd	s5,8(sp)
    80003706:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003708:	00016497          	auipc	s1,0x16
    8000370c:	91848493          	addi	s1,s1,-1768 # 80019020 <log>
    80003710:	8526                	mv	a0,s1
    80003712:	00003097          	auipc	ra,0x3
    80003716:	ba0080e7          	jalr	-1120(ra) # 800062b2 <acquire>
  log.outstanding -= 1;
    8000371a:	509c                	lw	a5,32(s1)
    8000371c:	37fd                	addiw	a5,a5,-1
    8000371e:	0007891b          	sext.w	s2,a5
    80003722:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003724:	50dc                	lw	a5,36(s1)
    80003726:	efb9                	bnez	a5,80003784 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003728:	06091663          	bnez	s2,80003794 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000372c:	00016497          	auipc	s1,0x16
    80003730:	8f448493          	addi	s1,s1,-1804 # 80019020 <log>
    80003734:	4785                	li	a5,1
    80003736:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	c2c080e7          	jalr	-980(ra) # 80006366 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003742:	54dc                	lw	a5,44(s1)
    80003744:	06f04763          	bgtz	a5,800037b2 <end_op+0xbc>
    acquire(&log.lock);
    80003748:	00016497          	auipc	s1,0x16
    8000374c:	8d848493          	addi	s1,s1,-1832 # 80019020 <log>
    80003750:	8526                	mv	a0,s1
    80003752:	00003097          	auipc	ra,0x3
    80003756:	b60080e7          	jalr	-1184(ra) # 800062b2 <acquire>
    log.committing = 0;
    8000375a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000375e:	8526                	mv	a0,s1
    80003760:	ffffe097          	auipc	ra,0xffffe
    80003764:	086080e7          	jalr	134(ra) # 800017e6 <wakeup>
    release(&log.lock);
    80003768:	8526                	mv	a0,s1
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	bfc080e7          	jalr	-1028(ra) # 80006366 <release>
}
    80003772:	70e2                	ld	ra,56(sp)
    80003774:	7442                	ld	s0,48(sp)
    80003776:	74a2                	ld	s1,40(sp)
    80003778:	7902                	ld	s2,32(sp)
    8000377a:	69e2                	ld	s3,24(sp)
    8000377c:	6a42                	ld	s4,16(sp)
    8000377e:	6aa2                	ld	s5,8(sp)
    80003780:	6121                	addi	sp,sp,64
    80003782:	8082                	ret
    panic("log.committing");
    80003784:	00005517          	auipc	a0,0x5
    80003788:	ffc50513          	addi	a0,a0,-4 # 80008780 <syscalls_name+0x1f0>
    8000378c:	00002097          	auipc	ra,0x2
    80003790:	5dc080e7          	jalr	1500(ra) # 80005d68 <panic>
    wakeup(&log);
    80003794:	00016497          	auipc	s1,0x16
    80003798:	88c48493          	addi	s1,s1,-1908 # 80019020 <log>
    8000379c:	8526                	mv	a0,s1
    8000379e:	ffffe097          	auipc	ra,0xffffe
    800037a2:	048080e7          	jalr	72(ra) # 800017e6 <wakeup>
  release(&log.lock);
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	bbe080e7          	jalr	-1090(ra) # 80006366 <release>
  if(do_commit){
    800037b0:	b7c9                	j	80003772 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037b2:	00016a97          	auipc	s5,0x16
    800037b6:	89ea8a93          	addi	s5,s5,-1890 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037ba:	00016a17          	auipc	s4,0x16
    800037be:	866a0a13          	addi	s4,s4,-1946 # 80019020 <log>
    800037c2:	018a2583          	lw	a1,24(s4)
    800037c6:	012585bb          	addw	a1,a1,s2
    800037ca:	2585                	addiw	a1,a1,1
    800037cc:	028a2503          	lw	a0,40(s4)
    800037d0:	fffff097          	auipc	ra,0xfffff
    800037d4:	cd2080e7          	jalr	-814(ra) # 800024a2 <bread>
    800037d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037da:	000aa583          	lw	a1,0(s5)
    800037de:	028a2503          	lw	a0,40(s4)
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	cc0080e7          	jalr	-832(ra) # 800024a2 <bread>
    800037ea:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037ec:	40000613          	li	a2,1024
    800037f0:	05850593          	addi	a1,a0,88
    800037f4:	05848513          	addi	a0,s1,88
    800037f8:	ffffd097          	auipc	ra,0xffffd
    800037fc:	a32080e7          	jalr	-1486(ra) # 8000022a <memmove>
    bwrite(to);  // write the log
    80003800:	8526                	mv	a0,s1
    80003802:	fffff097          	auipc	ra,0xfffff
    80003806:	d92080e7          	jalr	-622(ra) # 80002594 <bwrite>
    brelse(from);
    8000380a:	854e                	mv	a0,s3
    8000380c:	fffff097          	auipc	ra,0xfffff
    80003810:	dc6080e7          	jalr	-570(ra) # 800025d2 <brelse>
    brelse(to);
    80003814:	8526                	mv	a0,s1
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	dbc080e7          	jalr	-580(ra) # 800025d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000381e:	2905                	addiw	s2,s2,1
    80003820:	0a91                	addi	s5,s5,4
    80003822:	02ca2783          	lw	a5,44(s4)
    80003826:	f8f94ee3          	blt	s2,a5,800037c2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000382a:	00000097          	auipc	ra,0x0
    8000382e:	c6a080e7          	jalr	-918(ra) # 80003494 <write_head>
    install_trans(0); // Now install writes to home locations
    80003832:	4501                	li	a0,0
    80003834:	00000097          	auipc	ra,0x0
    80003838:	cda080e7          	jalr	-806(ra) # 8000350e <install_trans>
    log.lh.n = 0;
    8000383c:	00016797          	auipc	a5,0x16
    80003840:	8007a823          	sw	zero,-2032(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003844:	00000097          	auipc	ra,0x0
    80003848:	c50080e7          	jalr	-944(ra) # 80003494 <write_head>
    8000384c:	bdf5                	j	80003748 <end_op+0x52>

000000008000384e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000384e:	1101                	addi	sp,sp,-32
    80003850:	ec06                	sd	ra,24(sp)
    80003852:	e822                	sd	s0,16(sp)
    80003854:	e426                	sd	s1,8(sp)
    80003856:	e04a                	sd	s2,0(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000385c:	00015917          	auipc	s2,0x15
    80003860:	7c490913          	addi	s2,s2,1988 # 80019020 <log>
    80003864:	854a                	mv	a0,s2
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	a4c080e7          	jalr	-1460(ra) # 800062b2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000386e:	02c92603          	lw	a2,44(s2)
    80003872:	47f5                	li	a5,29
    80003874:	06c7c563          	blt	a5,a2,800038de <log_write+0x90>
    80003878:	00015797          	auipc	a5,0x15
    8000387c:	7c47a783          	lw	a5,1988(a5) # 8001903c <log+0x1c>
    80003880:	37fd                	addiw	a5,a5,-1
    80003882:	04f65e63          	bge	a2,a5,800038de <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003886:	00015797          	auipc	a5,0x15
    8000388a:	7ba7a783          	lw	a5,1978(a5) # 80019040 <log+0x20>
    8000388e:	06f05063          	blez	a5,800038ee <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003892:	4781                	li	a5,0
    80003894:	06c05563          	blez	a2,800038fe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003898:	44cc                	lw	a1,12(s1)
    8000389a:	00015717          	auipc	a4,0x15
    8000389e:	7b670713          	addi	a4,a4,1974 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038a2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038a4:	4314                	lw	a3,0(a4)
    800038a6:	04b68c63          	beq	a3,a1,800038fe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038aa:	2785                	addiw	a5,a5,1
    800038ac:	0711                	addi	a4,a4,4
    800038ae:	fef61be3          	bne	a2,a5,800038a4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038b2:	0621                	addi	a2,a2,8
    800038b4:	060a                	slli	a2,a2,0x2
    800038b6:	00015797          	auipc	a5,0x15
    800038ba:	76a78793          	addi	a5,a5,1898 # 80019020 <log>
    800038be:	963e                	add	a2,a2,a5
    800038c0:	44dc                	lw	a5,12(s1)
    800038c2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038c4:	8526                	mv	a0,s1
    800038c6:	fffff097          	auipc	ra,0xfffff
    800038ca:	daa080e7          	jalr	-598(ra) # 80002670 <bpin>
    log.lh.n++;
    800038ce:	00015717          	auipc	a4,0x15
    800038d2:	75270713          	addi	a4,a4,1874 # 80019020 <log>
    800038d6:	575c                	lw	a5,44(a4)
    800038d8:	2785                	addiw	a5,a5,1
    800038da:	d75c                	sw	a5,44(a4)
    800038dc:	a835                	j	80003918 <log_write+0xca>
    panic("too big a transaction");
    800038de:	00005517          	auipc	a0,0x5
    800038e2:	eb250513          	addi	a0,a0,-334 # 80008790 <syscalls_name+0x200>
    800038e6:	00002097          	auipc	ra,0x2
    800038ea:	482080e7          	jalr	1154(ra) # 80005d68 <panic>
    panic("log_write outside of trans");
    800038ee:	00005517          	auipc	a0,0x5
    800038f2:	eba50513          	addi	a0,a0,-326 # 800087a8 <syscalls_name+0x218>
    800038f6:	00002097          	auipc	ra,0x2
    800038fa:	472080e7          	jalr	1138(ra) # 80005d68 <panic>
  log.lh.block[i] = b->blockno;
    800038fe:	00878713          	addi	a4,a5,8
    80003902:	00271693          	slli	a3,a4,0x2
    80003906:	00015717          	auipc	a4,0x15
    8000390a:	71a70713          	addi	a4,a4,1818 # 80019020 <log>
    8000390e:	9736                	add	a4,a4,a3
    80003910:	44d4                	lw	a3,12(s1)
    80003912:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003914:	faf608e3          	beq	a2,a5,800038c4 <log_write+0x76>
  }
  release(&log.lock);
    80003918:	00015517          	auipc	a0,0x15
    8000391c:	70850513          	addi	a0,a0,1800 # 80019020 <log>
    80003920:	00003097          	auipc	ra,0x3
    80003924:	a46080e7          	jalr	-1466(ra) # 80006366 <release>
}
    80003928:	60e2                	ld	ra,24(sp)
    8000392a:	6442                	ld	s0,16(sp)
    8000392c:	64a2                	ld	s1,8(sp)
    8000392e:	6902                	ld	s2,0(sp)
    80003930:	6105                	addi	sp,sp,32
    80003932:	8082                	ret

0000000080003934 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	e04a                	sd	s2,0(sp)
    8000393e:	1000                	addi	s0,sp,32
    80003940:	84aa                	mv	s1,a0
    80003942:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003944:	00005597          	auipc	a1,0x5
    80003948:	e8458593          	addi	a1,a1,-380 # 800087c8 <syscalls_name+0x238>
    8000394c:	0521                	addi	a0,a0,8
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	8d4080e7          	jalr	-1836(ra) # 80006222 <initlock>
  lk->name = name;
    80003956:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000395a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395e:	0204a423          	sw	zero,40(s1)
}
    80003962:	60e2                	ld	ra,24(sp)
    80003964:	6442                	ld	s0,16(sp)
    80003966:	64a2                	ld	s1,8(sp)
    80003968:	6902                	ld	s2,0(sp)
    8000396a:	6105                	addi	sp,sp,32
    8000396c:	8082                	ret

000000008000396e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000396e:	1101                	addi	sp,sp,-32
    80003970:	ec06                	sd	ra,24(sp)
    80003972:	e822                	sd	s0,16(sp)
    80003974:	e426                	sd	s1,8(sp)
    80003976:	e04a                	sd	s2,0(sp)
    80003978:	1000                	addi	s0,sp,32
    8000397a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000397c:	00850913          	addi	s2,a0,8
    80003980:	854a                	mv	a0,s2
    80003982:	00003097          	auipc	ra,0x3
    80003986:	930080e7          	jalr	-1744(ra) # 800062b2 <acquire>
  while (lk->locked) {
    8000398a:	409c                	lw	a5,0(s1)
    8000398c:	cb89                	beqz	a5,8000399e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000398e:	85ca                	mv	a1,s2
    80003990:	8526                	mv	a0,s1
    80003992:	ffffe097          	auipc	ra,0xffffe
    80003996:	cc8080e7          	jalr	-824(ra) # 8000165a <sleep>
  while (lk->locked) {
    8000399a:	409c                	lw	a5,0(s1)
    8000399c:	fbed                	bnez	a5,8000398e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000399e:	4785                	li	a5,1
    800039a0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	5f4080e7          	jalr	1524(ra) # 80000f96 <myproc>
    800039aa:	591c                	lw	a5,48(a0)
    800039ac:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039ae:	854a                	mv	a0,s2
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	9b6080e7          	jalr	-1610(ra) # 80006366 <release>
}
    800039b8:	60e2                	ld	ra,24(sp)
    800039ba:	6442                	ld	s0,16(sp)
    800039bc:	64a2                	ld	s1,8(sp)
    800039be:	6902                	ld	s2,0(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
    800039dc:	8da080e7          	jalr	-1830(ra) # 800062b2 <acquire>
  lk->locked = 0;
    800039e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039e8:	8526                	mv	a0,s1
    800039ea:	ffffe097          	auipc	ra,0xffffe
    800039ee:	dfc080e7          	jalr	-516(ra) # 800017e6 <wakeup>
  release(&lk->lk);
    800039f2:	854a                	mv	a0,s2
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	972080e7          	jalr	-1678(ra) # 80006366 <release>
}
    800039fc:	60e2                	ld	ra,24(sp)
    800039fe:	6442                	ld	s0,16(sp)
    80003a00:	64a2                	ld	s1,8(sp)
    80003a02:	6902                	ld	s2,0(sp)
    80003a04:	6105                	addi	sp,sp,32
    80003a06:	8082                	ret

0000000080003a08 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a08:	7179                	addi	sp,sp,-48
    80003a0a:	f406                	sd	ra,40(sp)
    80003a0c:	f022                	sd	s0,32(sp)
    80003a0e:	ec26                	sd	s1,24(sp)
    80003a10:	e84a                	sd	s2,16(sp)
    80003a12:	e44e                	sd	s3,8(sp)
    80003a14:	1800                	addi	s0,sp,48
    80003a16:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a18:	00850913          	addi	s2,a0,8
    80003a1c:	854a                	mv	a0,s2
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	894080e7          	jalr	-1900(ra) # 800062b2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a26:	409c                	lw	a5,0(s1)
    80003a28:	ef99                	bnez	a5,80003a46 <holdingsleep+0x3e>
    80003a2a:	4481                	li	s1,0
  release(&lk->lk);
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	938080e7          	jalr	-1736(ra) # 80006366 <release>
  return r;
}
    80003a36:	8526                	mv	a0,s1
    80003a38:	70a2                	ld	ra,40(sp)
    80003a3a:	7402                	ld	s0,32(sp)
    80003a3c:	64e2                	ld	s1,24(sp)
    80003a3e:	6942                	ld	s2,16(sp)
    80003a40:	69a2                	ld	s3,8(sp)
    80003a42:	6145                	addi	sp,sp,48
    80003a44:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a46:	0284a983          	lw	s3,40(s1)
    80003a4a:	ffffd097          	auipc	ra,0xffffd
    80003a4e:	54c080e7          	jalr	1356(ra) # 80000f96 <myproc>
    80003a52:	5904                	lw	s1,48(a0)
    80003a54:	413484b3          	sub	s1,s1,s3
    80003a58:	0014b493          	seqz	s1,s1
    80003a5c:	bfc1                	j	80003a2c <holdingsleep+0x24>

0000000080003a5e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a5e:	1141                	addi	sp,sp,-16
    80003a60:	e406                	sd	ra,8(sp)
    80003a62:	e022                	sd	s0,0(sp)
    80003a64:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a66:	00005597          	auipc	a1,0x5
    80003a6a:	d7258593          	addi	a1,a1,-654 # 800087d8 <syscalls_name+0x248>
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	6fa50513          	addi	a0,a0,1786 # 80019168 <ftable>
    80003a76:	00002097          	auipc	ra,0x2
    80003a7a:	7ac080e7          	jalr	1964(ra) # 80006222 <initlock>
}
    80003a7e:	60a2                	ld	ra,8(sp)
    80003a80:	6402                	ld	s0,0(sp)
    80003a82:	0141                	addi	sp,sp,16
    80003a84:	8082                	ret

0000000080003a86 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a86:	1101                	addi	sp,sp,-32
    80003a88:	ec06                	sd	ra,24(sp)
    80003a8a:	e822                	sd	s0,16(sp)
    80003a8c:	e426                	sd	s1,8(sp)
    80003a8e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a90:	00015517          	auipc	a0,0x15
    80003a94:	6d850513          	addi	a0,a0,1752 # 80019168 <ftable>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	81a080e7          	jalr	-2022(ra) # 800062b2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa0:	00015497          	auipc	s1,0x15
    80003aa4:	6e048493          	addi	s1,s1,1760 # 80019180 <ftable+0x18>
    80003aa8:	00016717          	auipc	a4,0x16
    80003aac:	67870713          	addi	a4,a4,1656 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003ab0:	40dc                	lw	a5,4(s1)
    80003ab2:	cf99                	beqz	a5,80003ad0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ab4:	02848493          	addi	s1,s1,40
    80003ab8:	fee49ce3          	bne	s1,a4,80003ab0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003abc:	00015517          	auipc	a0,0x15
    80003ac0:	6ac50513          	addi	a0,a0,1708 # 80019168 <ftable>
    80003ac4:	00003097          	auipc	ra,0x3
    80003ac8:	8a2080e7          	jalr	-1886(ra) # 80006366 <release>
  return 0;
    80003acc:	4481                	li	s1,0
    80003ace:	a819                	j	80003ae4 <filealloc+0x5e>
      f->ref = 1;
    80003ad0:	4785                	li	a5,1
    80003ad2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ad4:	00015517          	auipc	a0,0x15
    80003ad8:	69450513          	addi	a0,a0,1684 # 80019168 <ftable>
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	88a080e7          	jalr	-1910(ra) # 80006366 <release>
}
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret

0000000080003af0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003af0:	1101                	addi	sp,sp,-32
    80003af2:	ec06                	sd	ra,24(sp)
    80003af4:	e822                	sd	s0,16(sp)
    80003af6:	e426                	sd	s1,8(sp)
    80003af8:	1000                	addi	s0,sp,32
    80003afa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003afc:	00015517          	auipc	a0,0x15
    80003b00:	66c50513          	addi	a0,a0,1644 # 80019168 <ftable>
    80003b04:	00002097          	auipc	ra,0x2
    80003b08:	7ae080e7          	jalr	1966(ra) # 800062b2 <acquire>
  if(f->ref < 1)
    80003b0c:	40dc                	lw	a5,4(s1)
    80003b0e:	02f05263          	blez	a5,80003b32 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b12:	2785                	addiw	a5,a5,1
    80003b14:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b16:	00015517          	auipc	a0,0x15
    80003b1a:	65250513          	addi	a0,a0,1618 # 80019168 <ftable>
    80003b1e:	00003097          	auipc	ra,0x3
    80003b22:	848080e7          	jalr	-1976(ra) # 80006366 <release>
  return f;
}
    80003b26:	8526                	mv	a0,s1
    80003b28:	60e2                	ld	ra,24(sp)
    80003b2a:	6442                	ld	s0,16(sp)
    80003b2c:	64a2                	ld	s1,8(sp)
    80003b2e:	6105                	addi	sp,sp,32
    80003b30:	8082                	ret
    panic("filedup");
    80003b32:	00005517          	auipc	a0,0x5
    80003b36:	cae50513          	addi	a0,a0,-850 # 800087e0 <syscalls_name+0x250>
    80003b3a:	00002097          	auipc	ra,0x2
    80003b3e:	22e080e7          	jalr	558(ra) # 80005d68 <panic>

0000000080003b42 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b42:	7139                	addi	sp,sp,-64
    80003b44:	fc06                	sd	ra,56(sp)
    80003b46:	f822                	sd	s0,48(sp)
    80003b48:	f426                	sd	s1,40(sp)
    80003b4a:	f04a                	sd	s2,32(sp)
    80003b4c:	ec4e                	sd	s3,24(sp)
    80003b4e:	e852                	sd	s4,16(sp)
    80003b50:	e456                	sd	s5,8(sp)
    80003b52:	0080                	addi	s0,sp,64
    80003b54:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b56:	00015517          	auipc	a0,0x15
    80003b5a:	61250513          	addi	a0,a0,1554 # 80019168 <ftable>
    80003b5e:	00002097          	auipc	ra,0x2
    80003b62:	754080e7          	jalr	1876(ra) # 800062b2 <acquire>
  if(f->ref < 1)
    80003b66:	40dc                	lw	a5,4(s1)
    80003b68:	06f05163          	blez	a5,80003bca <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b6c:	37fd                	addiw	a5,a5,-1
    80003b6e:	0007871b          	sext.w	a4,a5
    80003b72:	c0dc                	sw	a5,4(s1)
    80003b74:	06e04363          	bgtz	a4,80003bda <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b78:	0004a903          	lw	s2,0(s1)
    80003b7c:	0094ca83          	lbu	s5,9(s1)
    80003b80:	0104ba03          	ld	s4,16(s1)
    80003b84:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b88:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b8c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b90:	00015517          	auipc	a0,0x15
    80003b94:	5d850513          	addi	a0,a0,1496 # 80019168 <ftable>
    80003b98:	00002097          	auipc	ra,0x2
    80003b9c:	7ce080e7          	jalr	1998(ra) # 80006366 <release>

  if(ff.type == FD_PIPE){
    80003ba0:	4785                	li	a5,1
    80003ba2:	04f90d63          	beq	s2,a5,80003bfc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ba6:	3979                	addiw	s2,s2,-2
    80003ba8:	4785                	li	a5,1
    80003baa:	0527e063          	bltu	a5,s2,80003bea <fileclose+0xa8>
    begin_op();
    80003bae:	00000097          	auipc	ra,0x0
    80003bb2:	ac8080e7          	jalr	-1336(ra) # 80003676 <begin_op>
    iput(ff.ip);
    80003bb6:	854e                	mv	a0,s3
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	2a6080e7          	jalr	678(ra) # 80002e5e <iput>
    end_op();
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	b36080e7          	jalr	-1226(ra) # 800036f6 <end_op>
    80003bc8:	a00d                	j	80003bea <fileclose+0xa8>
    panic("fileclose");
    80003bca:	00005517          	auipc	a0,0x5
    80003bce:	c1e50513          	addi	a0,a0,-994 # 800087e8 <syscalls_name+0x258>
    80003bd2:	00002097          	auipc	ra,0x2
    80003bd6:	196080e7          	jalr	406(ra) # 80005d68 <panic>
    release(&ftable.lock);
    80003bda:	00015517          	auipc	a0,0x15
    80003bde:	58e50513          	addi	a0,a0,1422 # 80019168 <ftable>
    80003be2:	00002097          	auipc	ra,0x2
    80003be6:	784080e7          	jalr	1924(ra) # 80006366 <release>
  }
}
    80003bea:	70e2                	ld	ra,56(sp)
    80003bec:	7442                	ld	s0,48(sp)
    80003bee:	74a2                	ld	s1,40(sp)
    80003bf0:	7902                	ld	s2,32(sp)
    80003bf2:	69e2                	ld	s3,24(sp)
    80003bf4:	6a42                	ld	s4,16(sp)
    80003bf6:	6aa2                	ld	s5,8(sp)
    80003bf8:	6121                	addi	sp,sp,64
    80003bfa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bfc:	85d6                	mv	a1,s5
    80003bfe:	8552                	mv	a0,s4
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	34c080e7          	jalr	844(ra) # 80003f4c <pipeclose>
    80003c08:	b7cd                	j	80003bea <fileclose+0xa8>

0000000080003c0a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c0a:	715d                	addi	sp,sp,-80
    80003c0c:	e486                	sd	ra,72(sp)
    80003c0e:	e0a2                	sd	s0,64(sp)
    80003c10:	fc26                	sd	s1,56(sp)
    80003c12:	f84a                	sd	s2,48(sp)
    80003c14:	f44e                	sd	s3,40(sp)
    80003c16:	0880                	addi	s0,sp,80
    80003c18:	84aa                	mv	s1,a0
    80003c1a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	37a080e7          	jalr	890(ra) # 80000f96 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c24:	409c                	lw	a5,0(s1)
    80003c26:	37f9                	addiw	a5,a5,-2
    80003c28:	4705                	li	a4,1
    80003c2a:	04f76763          	bltu	a4,a5,80003c78 <filestat+0x6e>
    80003c2e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	072080e7          	jalr	114(ra) # 80002ca4 <ilock>
    stati(f->ip, &st);
    80003c3a:	fb840593          	addi	a1,s0,-72
    80003c3e:	6c88                	ld	a0,24(s1)
    80003c40:	fffff097          	auipc	ra,0xfffff
    80003c44:	2ee080e7          	jalr	750(ra) # 80002f2e <stati>
    iunlock(f->ip);
    80003c48:	6c88                	ld	a0,24(s1)
    80003c4a:	fffff097          	auipc	ra,0xfffff
    80003c4e:	11c080e7          	jalr	284(ra) # 80002d66 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c52:	46e1                	li	a3,24
    80003c54:	fb840613          	addi	a2,s0,-72
    80003c58:	85ce                	mv	a1,s3
    80003c5a:	05093503          	ld	a0,80(s2)
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	efe080e7          	jalr	-258(ra) # 80000b5c <copyout>
    80003c66:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c6a:	60a6                	ld	ra,72(sp)
    80003c6c:	6406                	ld	s0,64(sp)
    80003c6e:	74e2                	ld	s1,56(sp)
    80003c70:	7942                	ld	s2,48(sp)
    80003c72:	79a2                	ld	s3,40(sp)
    80003c74:	6161                	addi	sp,sp,80
    80003c76:	8082                	ret
  return -1;
    80003c78:	557d                	li	a0,-1
    80003c7a:	bfc5                	j	80003c6a <filestat+0x60>

0000000080003c7c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c7c:	7179                	addi	sp,sp,-48
    80003c7e:	f406                	sd	ra,40(sp)
    80003c80:	f022                	sd	s0,32(sp)
    80003c82:	ec26                	sd	s1,24(sp)
    80003c84:	e84a                	sd	s2,16(sp)
    80003c86:	e44e                	sd	s3,8(sp)
    80003c88:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c8a:	00854783          	lbu	a5,8(a0)
    80003c8e:	c3d5                	beqz	a5,80003d32 <fileread+0xb6>
    80003c90:	84aa                	mv	s1,a0
    80003c92:	89ae                	mv	s3,a1
    80003c94:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c96:	411c                	lw	a5,0(a0)
    80003c98:	4705                	li	a4,1
    80003c9a:	04e78963          	beq	a5,a4,80003cec <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c9e:	470d                	li	a4,3
    80003ca0:	04e78d63          	beq	a5,a4,80003cfa <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca4:	4709                	li	a4,2
    80003ca6:	06e79e63          	bne	a5,a4,80003d22 <fileread+0xa6>
    ilock(f->ip);
    80003caa:	6d08                	ld	a0,24(a0)
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	ff8080e7          	jalr	-8(ra) # 80002ca4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cb4:	874a                	mv	a4,s2
    80003cb6:	5094                	lw	a3,32(s1)
    80003cb8:	864e                	mv	a2,s3
    80003cba:	4585                	li	a1,1
    80003cbc:	6c88                	ld	a0,24(s1)
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	29a080e7          	jalr	666(ra) # 80002f58 <readi>
    80003cc6:	892a                	mv	s2,a0
    80003cc8:	00a05563          	blez	a0,80003cd2 <fileread+0x56>
      f->off += r;
    80003ccc:	509c                	lw	a5,32(s1)
    80003cce:	9fa9                	addw	a5,a5,a0
    80003cd0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cd2:	6c88                	ld	a0,24(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	092080e7          	jalr	146(ra) # 80002d66 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cdc:	854a                	mv	a0,s2
    80003cde:	70a2                	ld	ra,40(sp)
    80003ce0:	7402                	ld	s0,32(sp)
    80003ce2:	64e2                	ld	s1,24(sp)
    80003ce4:	6942                	ld	s2,16(sp)
    80003ce6:	69a2                	ld	s3,8(sp)
    80003ce8:	6145                	addi	sp,sp,48
    80003cea:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cec:	6908                	ld	a0,16(a0)
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	3c8080e7          	jalr	968(ra) # 800040b6 <piperead>
    80003cf6:	892a                	mv	s2,a0
    80003cf8:	b7d5                	j	80003cdc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cfa:	02451783          	lh	a5,36(a0)
    80003cfe:	03079693          	slli	a3,a5,0x30
    80003d02:	92c1                	srli	a3,a3,0x30
    80003d04:	4725                	li	a4,9
    80003d06:	02d76863          	bltu	a4,a3,80003d36 <fileread+0xba>
    80003d0a:	0792                	slli	a5,a5,0x4
    80003d0c:	00015717          	auipc	a4,0x15
    80003d10:	3bc70713          	addi	a4,a4,956 # 800190c8 <devsw>
    80003d14:	97ba                	add	a5,a5,a4
    80003d16:	639c                	ld	a5,0(a5)
    80003d18:	c38d                	beqz	a5,80003d3a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d1a:	4505                	li	a0,1
    80003d1c:	9782                	jalr	a5
    80003d1e:	892a                	mv	s2,a0
    80003d20:	bf75                	j	80003cdc <fileread+0x60>
    panic("fileread");
    80003d22:	00005517          	auipc	a0,0x5
    80003d26:	ad650513          	addi	a0,a0,-1322 # 800087f8 <syscalls_name+0x268>
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	03e080e7          	jalr	62(ra) # 80005d68 <panic>
    return -1;
    80003d32:	597d                	li	s2,-1
    80003d34:	b765                	j	80003cdc <fileread+0x60>
      return -1;
    80003d36:	597d                	li	s2,-1
    80003d38:	b755                	j	80003cdc <fileread+0x60>
    80003d3a:	597d                	li	s2,-1
    80003d3c:	b745                	j	80003cdc <fileread+0x60>

0000000080003d3e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d3e:	715d                	addi	sp,sp,-80
    80003d40:	e486                	sd	ra,72(sp)
    80003d42:	e0a2                	sd	s0,64(sp)
    80003d44:	fc26                	sd	s1,56(sp)
    80003d46:	f84a                	sd	s2,48(sp)
    80003d48:	f44e                	sd	s3,40(sp)
    80003d4a:	f052                	sd	s4,32(sp)
    80003d4c:	ec56                	sd	s5,24(sp)
    80003d4e:	e85a                	sd	s6,16(sp)
    80003d50:	e45e                	sd	s7,8(sp)
    80003d52:	e062                	sd	s8,0(sp)
    80003d54:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d56:	00954783          	lbu	a5,9(a0)
    80003d5a:	10078663          	beqz	a5,80003e66 <filewrite+0x128>
    80003d5e:	892a                	mv	s2,a0
    80003d60:	8aae                	mv	s5,a1
    80003d62:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d64:	411c                	lw	a5,0(a0)
    80003d66:	4705                	li	a4,1
    80003d68:	02e78263          	beq	a5,a4,80003d8c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d6c:	470d                	li	a4,3
    80003d6e:	02e78663          	beq	a5,a4,80003d9a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d72:	4709                	li	a4,2
    80003d74:	0ee79163          	bne	a5,a4,80003e56 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d78:	0ac05d63          	blez	a2,80003e32 <filewrite+0xf4>
    int i = 0;
    80003d7c:	4981                	li	s3,0
    80003d7e:	6b05                	lui	s6,0x1
    80003d80:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d84:	6b85                	lui	s7,0x1
    80003d86:	c00b8b9b          	addiw	s7,s7,-1024
    80003d8a:	a861                	j	80003e22 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d8c:	6908                	ld	a0,16(a0)
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	22e080e7          	jalr	558(ra) # 80003fbc <pipewrite>
    80003d96:	8a2a                	mv	s4,a0
    80003d98:	a045                	j	80003e38 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d9a:	02451783          	lh	a5,36(a0)
    80003d9e:	03079693          	slli	a3,a5,0x30
    80003da2:	92c1                	srli	a3,a3,0x30
    80003da4:	4725                	li	a4,9
    80003da6:	0cd76263          	bltu	a4,a3,80003e6a <filewrite+0x12c>
    80003daa:	0792                	slli	a5,a5,0x4
    80003dac:	00015717          	auipc	a4,0x15
    80003db0:	31c70713          	addi	a4,a4,796 # 800190c8 <devsw>
    80003db4:	97ba                	add	a5,a5,a4
    80003db6:	679c                	ld	a5,8(a5)
    80003db8:	cbdd                	beqz	a5,80003e6e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dba:	4505                	li	a0,1
    80003dbc:	9782                	jalr	a5
    80003dbe:	8a2a                	mv	s4,a0
    80003dc0:	a8a5                	j	80003e38 <filewrite+0xfa>
    80003dc2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	8b0080e7          	jalr	-1872(ra) # 80003676 <begin_op>
      ilock(f->ip);
    80003dce:	01893503          	ld	a0,24(s2)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	ed2080e7          	jalr	-302(ra) # 80002ca4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dda:	8762                	mv	a4,s8
    80003ddc:	02092683          	lw	a3,32(s2)
    80003de0:	01598633          	add	a2,s3,s5
    80003de4:	4585                	li	a1,1
    80003de6:	01893503          	ld	a0,24(s2)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	266080e7          	jalr	614(ra) # 80003050 <writei>
    80003df2:	84aa                	mv	s1,a0
    80003df4:	00a05763          	blez	a0,80003e02 <filewrite+0xc4>
        f->off += r;
    80003df8:	02092783          	lw	a5,32(s2)
    80003dfc:	9fa9                	addw	a5,a5,a0
    80003dfe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e02:	01893503          	ld	a0,24(s2)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	f60080e7          	jalr	-160(ra) # 80002d66 <iunlock>
      end_op();
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	8e8080e7          	jalr	-1816(ra) # 800036f6 <end_op>

      if(r != n1){
    80003e16:	009c1f63          	bne	s8,s1,80003e34 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e1a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e1e:	0149db63          	bge	s3,s4,80003e34 <filewrite+0xf6>
      int n1 = n - i;
    80003e22:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e26:	84be                	mv	s1,a5
    80003e28:	2781                	sext.w	a5,a5
    80003e2a:	f8fb5ce3          	bge	s6,a5,80003dc2 <filewrite+0x84>
    80003e2e:	84de                	mv	s1,s7
    80003e30:	bf49                	j	80003dc2 <filewrite+0x84>
    int i = 0;
    80003e32:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e34:	013a1f63          	bne	s4,s3,80003e52 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e38:	8552                	mv	a0,s4
    80003e3a:	60a6                	ld	ra,72(sp)
    80003e3c:	6406                	ld	s0,64(sp)
    80003e3e:	74e2                	ld	s1,56(sp)
    80003e40:	7942                	ld	s2,48(sp)
    80003e42:	79a2                	ld	s3,40(sp)
    80003e44:	7a02                	ld	s4,32(sp)
    80003e46:	6ae2                	ld	s5,24(sp)
    80003e48:	6b42                	ld	s6,16(sp)
    80003e4a:	6ba2                	ld	s7,8(sp)
    80003e4c:	6c02                	ld	s8,0(sp)
    80003e4e:	6161                	addi	sp,sp,80
    80003e50:	8082                	ret
    ret = (i == n ? n : -1);
    80003e52:	5a7d                	li	s4,-1
    80003e54:	b7d5                	j	80003e38 <filewrite+0xfa>
    panic("filewrite");
    80003e56:	00005517          	auipc	a0,0x5
    80003e5a:	9b250513          	addi	a0,a0,-1614 # 80008808 <syscalls_name+0x278>
    80003e5e:	00002097          	auipc	ra,0x2
    80003e62:	f0a080e7          	jalr	-246(ra) # 80005d68 <panic>
    return -1;
    80003e66:	5a7d                	li	s4,-1
    80003e68:	bfc1                	j	80003e38 <filewrite+0xfa>
      return -1;
    80003e6a:	5a7d                	li	s4,-1
    80003e6c:	b7f1                	j	80003e38 <filewrite+0xfa>
    80003e6e:	5a7d                	li	s4,-1
    80003e70:	b7e1                	j	80003e38 <filewrite+0xfa>

0000000080003e72 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e72:	7179                	addi	sp,sp,-48
    80003e74:	f406                	sd	ra,40(sp)
    80003e76:	f022                	sd	s0,32(sp)
    80003e78:	ec26                	sd	s1,24(sp)
    80003e7a:	e84a                	sd	s2,16(sp)
    80003e7c:	e44e                	sd	s3,8(sp)
    80003e7e:	e052                	sd	s4,0(sp)
    80003e80:	1800                	addi	s0,sp,48
    80003e82:	84aa                	mv	s1,a0
    80003e84:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e86:	0005b023          	sd	zero,0(a1)
    80003e8a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	bf8080e7          	jalr	-1032(ra) # 80003a86 <filealloc>
    80003e96:	e088                	sd	a0,0(s1)
    80003e98:	c551                	beqz	a0,80003f24 <pipealloc+0xb2>
    80003e9a:	00000097          	auipc	ra,0x0
    80003e9e:	bec080e7          	jalr	-1044(ra) # 80003a86 <filealloc>
    80003ea2:	00aa3023          	sd	a0,0(s4)
    80003ea6:	c92d                	beqz	a0,80003f18 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	270080e7          	jalr	624(ra) # 80000118 <kalloc>
    80003eb0:	892a                	mv	s2,a0
    80003eb2:	c125                	beqz	a0,80003f12 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003eb4:	4985                	li	s3,1
    80003eb6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003eba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ebe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ec2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ec6:	00004597          	auipc	a1,0x4
    80003eca:	55258593          	addi	a1,a1,1362 # 80008418 <states.1716+0x1a0>
    80003ece:	00002097          	auipc	ra,0x2
    80003ed2:	354080e7          	jalr	852(ra) # 80006222 <initlock>
  (*f0)->type = FD_PIPE;
    80003ed6:	609c                	ld	a5,0(s1)
    80003ed8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003edc:	609c                	ld	a5,0(s1)
    80003ede:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ee2:	609c                	ld	a5,0(s1)
    80003ee4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ee8:	609c                	ld	a5,0(s1)
    80003eea:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eee:	000a3783          	ld	a5,0(s4)
    80003ef2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ef6:	000a3783          	ld	a5,0(s4)
    80003efa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003efe:	000a3783          	ld	a5,0(s4)
    80003f02:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f06:	000a3783          	ld	a5,0(s4)
    80003f0a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f0e:	4501                	li	a0,0
    80003f10:	a025                	j	80003f38 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f12:	6088                	ld	a0,0(s1)
    80003f14:	e501                	bnez	a0,80003f1c <pipealloc+0xaa>
    80003f16:	a039                	j	80003f24 <pipealloc+0xb2>
    80003f18:	6088                	ld	a0,0(s1)
    80003f1a:	c51d                	beqz	a0,80003f48 <pipealloc+0xd6>
    fileclose(*f0);
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	c26080e7          	jalr	-986(ra) # 80003b42 <fileclose>
  if(*f1)
    80003f24:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f28:	557d                	li	a0,-1
  if(*f1)
    80003f2a:	c799                	beqz	a5,80003f38 <pipealloc+0xc6>
    fileclose(*f1);
    80003f2c:	853e                	mv	a0,a5
    80003f2e:	00000097          	auipc	ra,0x0
    80003f32:	c14080e7          	jalr	-1004(ra) # 80003b42 <fileclose>
  return -1;
    80003f36:	557d                	li	a0,-1
}
    80003f38:	70a2                	ld	ra,40(sp)
    80003f3a:	7402                	ld	s0,32(sp)
    80003f3c:	64e2                	ld	s1,24(sp)
    80003f3e:	6942                	ld	s2,16(sp)
    80003f40:	69a2                	ld	s3,8(sp)
    80003f42:	6a02                	ld	s4,0(sp)
    80003f44:	6145                	addi	sp,sp,48
    80003f46:	8082                	ret
  return -1;
    80003f48:	557d                	li	a0,-1
    80003f4a:	b7fd                	j	80003f38 <pipealloc+0xc6>

0000000080003f4c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f4c:	1101                	addi	sp,sp,-32
    80003f4e:	ec06                	sd	ra,24(sp)
    80003f50:	e822                	sd	s0,16(sp)
    80003f52:	e426                	sd	s1,8(sp)
    80003f54:	e04a                	sd	s2,0(sp)
    80003f56:	1000                	addi	s0,sp,32
    80003f58:	84aa                	mv	s1,a0
    80003f5a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	356080e7          	jalr	854(ra) # 800062b2 <acquire>
  if(writable){
    80003f64:	02090d63          	beqz	s2,80003f9e <pipeclose+0x52>
    pi->writeopen = 0;
    80003f68:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f6c:	21848513          	addi	a0,s1,536
    80003f70:	ffffe097          	auipc	ra,0xffffe
    80003f74:	876080e7          	jalr	-1930(ra) # 800017e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f78:	2204b783          	ld	a5,544(s1)
    80003f7c:	eb95                	bnez	a5,80003fb0 <pipeclose+0x64>
    release(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	3e6080e7          	jalr	998(ra) # 80006366 <release>
    kfree((char*)pi);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	ffffc097          	auipc	ra,0xffffc
    80003f8e:	092080e7          	jalr	146(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f92:	60e2                	ld	ra,24(sp)
    80003f94:	6442                	ld	s0,16(sp)
    80003f96:	64a2                	ld	s1,8(sp)
    80003f98:	6902                	ld	s2,0(sp)
    80003f9a:	6105                	addi	sp,sp,32
    80003f9c:	8082                	ret
    pi->readopen = 0;
    80003f9e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fa2:	21c48513          	addi	a0,s1,540
    80003fa6:	ffffe097          	auipc	ra,0xffffe
    80003faa:	840080e7          	jalr	-1984(ra) # 800017e6 <wakeup>
    80003fae:	b7e9                	j	80003f78 <pipeclose+0x2c>
    release(&pi->lock);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00002097          	auipc	ra,0x2
    80003fb6:	3b4080e7          	jalr	948(ra) # 80006366 <release>
}
    80003fba:	bfe1                	j	80003f92 <pipeclose+0x46>

0000000080003fbc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fbc:	7159                	addi	sp,sp,-112
    80003fbe:	f486                	sd	ra,104(sp)
    80003fc0:	f0a2                	sd	s0,96(sp)
    80003fc2:	eca6                	sd	s1,88(sp)
    80003fc4:	e8ca                	sd	s2,80(sp)
    80003fc6:	e4ce                	sd	s3,72(sp)
    80003fc8:	e0d2                	sd	s4,64(sp)
    80003fca:	fc56                	sd	s5,56(sp)
    80003fcc:	f85a                	sd	s6,48(sp)
    80003fce:	f45e                	sd	s7,40(sp)
    80003fd0:	f062                	sd	s8,32(sp)
    80003fd2:	ec66                	sd	s9,24(sp)
    80003fd4:	1880                	addi	s0,sp,112
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	8aae                	mv	s5,a1
    80003fda:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	fba080e7          	jalr	-70(ra) # 80000f96 <myproc>
    80003fe4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	2ca080e7          	jalr	714(ra) # 800062b2 <acquire>
  while(i < n){
    80003ff0:	0d405163          	blez	s4,800040b2 <pipewrite+0xf6>
    80003ff4:	8ba6                	mv	s7,s1
  int i = 0;
    80003ff6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ffa:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	21c48c13          	addi	s8,s1,540
    80004002:	a08d                	j	80004064 <pipewrite+0xa8>
      release(&pi->lock);
    80004004:	8526                	mv	a0,s1
    80004006:	00002097          	auipc	ra,0x2
    8000400a:	360080e7          	jalr	864(ra) # 80006366 <release>
      return -1;
    8000400e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004010:	854a                	mv	a0,s2
    80004012:	70a6                	ld	ra,104(sp)
    80004014:	7406                	ld	s0,96(sp)
    80004016:	64e6                	ld	s1,88(sp)
    80004018:	6946                	ld	s2,80(sp)
    8000401a:	69a6                	ld	s3,72(sp)
    8000401c:	6a06                	ld	s4,64(sp)
    8000401e:	7ae2                	ld	s5,56(sp)
    80004020:	7b42                	ld	s6,48(sp)
    80004022:	7ba2                	ld	s7,40(sp)
    80004024:	7c02                	ld	s8,32(sp)
    80004026:	6ce2                	ld	s9,24(sp)
    80004028:	6165                	addi	sp,sp,112
    8000402a:	8082                	ret
      wakeup(&pi->nread);
    8000402c:	8566                	mv	a0,s9
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	7b8080e7          	jalr	1976(ra) # 800017e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004036:	85de                	mv	a1,s7
    80004038:	8562                	mv	a0,s8
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	620080e7          	jalr	1568(ra) # 8000165a <sleep>
    80004042:	a839                	j	80004060 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004044:	21c4a783          	lw	a5,540(s1)
    80004048:	0017871b          	addiw	a4,a5,1
    8000404c:	20e4ae23          	sw	a4,540(s1)
    80004050:	1ff7f793          	andi	a5,a5,511
    80004054:	97a6                	add	a5,a5,s1
    80004056:	f9f44703          	lbu	a4,-97(s0)
    8000405a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000405e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004060:	03495d63          	bge	s2,s4,8000409a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004064:	2204a783          	lw	a5,544(s1)
    80004068:	dfd1                	beqz	a5,80004004 <pipewrite+0x48>
    8000406a:	0289a783          	lw	a5,40(s3)
    8000406e:	fbd9                	bnez	a5,80004004 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004070:	2184a783          	lw	a5,536(s1)
    80004074:	21c4a703          	lw	a4,540(s1)
    80004078:	2007879b          	addiw	a5,a5,512
    8000407c:	faf708e3          	beq	a4,a5,8000402c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004080:	4685                	li	a3,1
    80004082:	01590633          	add	a2,s2,s5
    80004086:	f9f40593          	addi	a1,s0,-97
    8000408a:	0509b503          	ld	a0,80(s3)
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	b5a080e7          	jalr	-1190(ra) # 80000be8 <copyin>
    80004096:	fb6517e3          	bne	a0,s6,80004044 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000409a:	21848513          	addi	a0,s1,536
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	748080e7          	jalr	1864(ra) # 800017e6 <wakeup>
  release(&pi->lock);
    800040a6:	8526                	mv	a0,s1
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	2be080e7          	jalr	702(ra) # 80006366 <release>
  return i;
    800040b0:	b785                	j	80004010 <pipewrite+0x54>
  int i = 0;
    800040b2:	4901                	li	s2,0
    800040b4:	b7dd                	j	8000409a <pipewrite+0xde>

00000000800040b6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040b6:	715d                	addi	sp,sp,-80
    800040b8:	e486                	sd	ra,72(sp)
    800040ba:	e0a2                	sd	s0,64(sp)
    800040bc:	fc26                	sd	s1,56(sp)
    800040be:	f84a                	sd	s2,48(sp)
    800040c0:	f44e                	sd	s3,40(sp)
    800040c2:	f052                	sd	s4,32(sp)
    800040c4:	ec56                	sd	s5,24(sp)
    800040c6:	e85a                	sd	s6,16(sp)
    800040c8:	0880                	addi	s0,sp,80
    800040ca:	84aa                	mv	s1,a0
    800040cc:	892e                	mv	s2,a1
    800040ce:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	ec6080e7          	jalr	-314(ra) # 80000f96 <myproc>
    800040d8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040da:	8b26                	mv	s6,s1
    800040dc:	8526                	mv	a0,s1
    800040de:	00002097          	auipc	ra,0x2
    800040e2:	1d4080e7          	jalr	468(ra) # 800062b2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e6:	2184a703          	lw	a4,536(s1)
    800040ea:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ee:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f2:	02f71463          	bne	a4,a5,8000411a <piperead+0x64>
    800040f6:	2244a783          	lw	a5,548(s1)
    800040fa:	c385                	beqz	a5,8000411a <piperead+0x64>
    if(pr->killed){
    800040fc:	028a2783          	lw	a5,40(s4)
    80004100:	ebc1                	bnez	a5,80004190 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004102:	85da                	mv	a1,s6
    80004104:	854e                	mv	a0,s3
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	554080e7          	jalr	1364(ra) # 8000165a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000410e:	2184a703          	lw	a4,536(s1)
    80004112:	21c4a783          	lw	a5,540(s1)
    80004116:	fef700e3          	beq	a4,a5,800040f6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411a:	09505263          	blez	s5,8000419e <piperead+0xe8>
    8000411e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004120:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004122:	2184a783          	lw	a5,536(s1)
    80004126:	21c4a703          	lw	a4,540(s1)
    8000412a:	02f70d63          	beq	a4,a5,80004164 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000412e:	0017871b          	addiw	a4,a5,1
    80004132:	20e4ac23          	sw	a4,536(s1)
    80004136:	1ff7f793          	andi	a5,a5,511
    8000413a:	97a6                	add	a5,a5,s1
    8000413c:	0187c783          	lbu	a5,24(a5)
    80004140:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004144:	4685                	li	a3,1
    80004146:	fbf40613          	addi	a2,s0,-65
    8000414a:	85ca                	mv	a1,s2
    8000414c:	050a3503          	ld	a0,80(s4)
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	a0c080e7          	jalr	-1524(ra) # 80000b5c <copyout>
    80004158:	01650663          	beq	a0,s6,80004164 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415c:	2985                	addiw	s3,s3,1
    8000415e:	0905                	addi	s2,s2,1
    80004160:	fd3a91e3          	bne	s5,s3,80004122 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004164:	21c48513          	addi	a0,s1,540
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	67e080e7          	jalr	1662(ra) # 800017e6 <wakeup>
  release(&pi->lock);
    80004170:	8526                	mv	a0,s1
    80004172:	00002097          	auipc	ra,0x2
    80004176:	1f4080e7          	jalr	500(ra) # 80006366 <release>
  return i;
}
    8000417a:	854e                	mv	a0,s3
    8000417c:	60a6                	ld	ra,72(sp)
    8000417e:	6406                	ld	s0,64(sp)
    80004180:	74e2                	ld	s1,56(sp)
    80004182:	7942                	ld	s2,48(sp)
    80004184:	79a2                	ld	s3,40(sp)
    80004186:	7a02                	ld	s4,32(sp)
    80004188:	6ae2                	ld	s5,24(sp)
    8000418a:	6b42                	ld	s6,16(sp)
    8000418c:	6161                	addi	sp,sp,80
    8000418e:	8082                	ret
      release(&pi->lock);
    80004190:	8526                	mv	a0,s1
    80004192:	00002097          	auipc	ra,0x2
    80004196:	1d4080e7          	jalr	468(ra) # 80006366 <release>
      return -1;
    8000419a:	59fd                	li	s3,-1
    8000419c:	bff9                	j	8000417a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	4981                	li	s3,0
    800041a0:	b7d1                	j	80004164 <piperead+0xae>

00000000800041a2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041a2:	df010113          	addi	sp,sp,-528
    800041a6:	20113423          	sd	ra,520(sp)
    800041aa:	20813023          	sd	s0,512(sp)
    800041ae:	ffa6                	sd	s1,504(sp)
    800041b0:	fbca                	sd	s2,496(sp)
    800041b2:	f7ce                	sd	s3,488(sp)
    800041b4:	f3d2                	sd	s4,480(sp)
    800041b6:	efd6                	sd	s5,472(sp)
    800041b8:	ebda                	sd	s6,464(sp)
    800041ba:	e7de                	sd	s7,456(sp)
    800041bc:	e3e2                	sd	s8,448(sp)
    800041be:	ff66                	sd	s9,440(sp)
    800041c0:	fb6a                	sd	s10,432(sp)
    800041c2:	f76e                	sd	s11,424(sp)
    800041c4:	0c00                	addi	s0,sp,528
    800041c6:	84aa                	mv	s1,a0
    800041c8:	dea43c23          	sd	a0,-520(s0)
    800041cc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041d0:	ffffd097          	auipc	ra,0xffffd
    800041d4:	dc6080e7          	jalr	-570(ra) # 80000f96 <myproc>
    800041d8:	892a                	mv	s2,a0

  begin_op();
    800041da:	fffff097          	auipc	ra,0xfffff
    800041de:	49c080e7          	jalr	1180(ra) # 80003676 <begin_op>

  if((ip = namei(path)) == 0){
    800041e2:	8526                	mv	a0,s1
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	276080e7          	jalr	630(ra) # 8000345a <namei>
    800041ec:	c92d                	beqz	a0,8000425e <exec+0xbc>
    800041ee:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	ab4080e7          	jalr	-1356(ra) # 80002ca4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041f8:	04000713          	li	a4,64
    800041fc:	4681                	li	a3,0
    800041fe:	e5040613          	addi	a2,s0,-432
    80004202:	4581                	li	a1,0
    80004204:	8526                	mv	a0,s1
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	d52080e7          	jalr	-686(ra) # 80002f58 <readi>
    8000420e:	04000793          	li	a5,64
    80004212:	00f51a63          	bne	a0,a5,80004226 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004216:	e5042703          	lw	a4,-432(s0)
    8000421a:	464c47b7          	lui	a5,0x464c4
    8000421e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004222:	04f70463          	beq	a4,a5,8000426a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004226:	8526                	mv	a0,s1
    80004228:	fffff097          	auipc	ra,0xfffff
    8000422c:	cde080e7          	jalr	-802(ra) # 80002f06 <iunlockput>
    end_op();
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	4c6080e7          	jalr	1222(ra) # 800036f6 <end_op>
  }
  return -1;
    80004238:	557d                	li	a0,-1
}
    8000423a:	20813083          	ld	ra,520(sp)
    8000423e:	20013403          	ld	s0,512(sp)
    80004242:	74fe                	ld	s1,504(sp)
    80004244:	795e                	ld	s2,496(sp)
    80004246:	79be                	ld	s3,488(sp)
    80004248:	7a1e                	ld	s4,480(sp)
    8000424a:	6afe                	ld	s5,472(sp)
    8000424c:	6b5e                	ld	s6,464(sp)
    8000424e:	6bbe                	ld	s7,456(sp)
    80004250:	6c1e                	ld	s8,448(sp)
    80004252:	7cfa                	ld	s9,440(sp)
    80004254:	7d5a                	ld	s10,432(sp)
    80004256:	7dba                	ld	s11,424(sp)
    80004258:	21010113          	addi	sp,sp,528
    8000425c:	8082                	ret
    end_op();
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	498080e7          	jalr	1176(ra) # 800036f6 <end_op>
    return -1;
    80004266:	557d                	li	a0,-1
    80004268:	bfc9                	j	8000423a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000426a:	854a                	mv	a0,s2
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	dee080e7          	jalr	-530(ra) # 8000105a <proc_pagetable>
    80004274:	8baa                	mv	s7,a0
    80004276:	d945                	beqz	a0,80004226 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004278:	e7042983          	lw	s3,-400(s0)
    8000427c:	e8845783          	lhu	a5,-376(s0)
    80004280:	c7ad                	beqz	a5,800042ea <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004282:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004284:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004286:	6c85                	lui	s9,0x1
    80004288:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000428c:	def43823          	sd	a5,-528(s0)
    80004290:	a489                	j	800044d2 <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004292:	00004517          	auipc	a0,0x4
    80004296:	58650513          	addi	a0,a0,1414 # 80008818 <syscalls_name+0x288>
    8000429a:	00002097          	auipc	ra,0x2
    8000429e:	ace080e7          	jalr	-1330(ra) # 80005d68 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042a2:	8756                	mv	a4,s5
    800042a4:	012d86bb          	addw	a3,s11,s2
    800042a8:	4581                	li	a1,0
    800042aa:	8526                	mv	a0,s1
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	cac080e7          	jalr	-852(ra) # 80002f58 <readi>
    800042b4:	2501                	sext.w	a0,a0
    800042b6:	1caa9563          	bne	s5,a0,80004480 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    800042ba:	6785                	lui	a5,0x1
    800042bc:	0127893b          	addw	s2,a5,s2
    800042c0:	77fd                	lui	a5,0xfffff
    800042c2:	01478a3b          	addw	s4,a5,s4
    800042c6:	1f897d63          	bgeu	s2,s8,800044c0 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    800042ca:	02091593          	slli	a1,s2,0x20
    800042ce:	9181                	srli	a1,a1,0x20
    800042d0:	95ea                	add	a1,a1,s10
    800042d2:	855e                	mv	a0,s7
    800042d4:	ffffc097          	auipc	ra,0xffffc
    800042d8:	284080e7          	jalr	644(ra) # 80000558 <walkaddr>
    800042dc:	862a                	mv	a2,a0
    if(pa == 0)
    800042de:	d955                	beqz	a0,80004292 <exec+0xf0>
      n = PGSIZE;
    800042e0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042e2:	fd9a70e3          	bgeu	s4,s9,800042a2 <exec+0x100>
      n = sz - i;
    800042e6:	8ad2                	mv	s5,s4
    800042e8:	bf6d                	j	800042a2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ea:	4901                	li	s2,0
  iunlockput(ip);
    800042ec:	8526                	mv	a0,s1
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	c18080e7          	jalr	-1000(ra) # 80002f06 <iunlockput>
  end_op();
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	400080e7          	jalr	1024(ra) # 800036f6 <end_op>
  p = myproc();
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	c98080e7          	jalr	-872(ra) # 80000f96 <myproc>
    80004306:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004308:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000430c:	6785                	lui	a5,0x1
    8000430e:	17fd                	addi	a5,a5,-1
    80004310:	993e                	add	s2,s2,a5
    80004312:	757d                	lui	a0,0xfffff
    80004314:	00a977b3          	and	a5,s2,a0
    80004318:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000431c:	6609                	lui	a2,0x2
    8000431e:	963e                	add	a2,a2,a5
    80004320:	85be                	mv	a1,a5
    80004322:	855e                	mv	a0,s7
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	5e8080e7          	jalr	1512(ra) # 8000090c <uvmalloc>
    8000432c:	8b2a                	mv	s6,a0
  ip = 0;
    8000432e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004330:	14050863          	beqz	a0,80004480 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004334:	75f9                	lui	a1,0xffffe
    80004336:	95aa                	add	a1,a1,a0
    80004338:	855e                	mv	a0,s7
    8000433a:	ffffc097          	auipc	ra,0xffffc
    8000433e:	7f0080e7          	jalr	2032(ra) # 80000b2a <uvmclear>
  stackbase = sp - PGSIZE;
    80004342:	7c7d                	lui	s8,0xfffff
    80004344:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004346:	e0043783          	ld	a5,-512(s0)
    8000434a:	6388                	ld	a0,0(a5)
    8000434c:	c535                	beqz	a0,800043b8 <exec+0x216>
    8000434e:	e9040993          	addi	s3,s0,-368
    80004352:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004356:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	ff6080e7          	jalr	-10(ra) # 8000034e <strlen>
    80004360:	2505                	addiw	a0,a0,1
    80004362:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004366:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000436a:	13896f63          	bltu	s2,s8,800044a8 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000436e:	e0043d83          	ld	s11,-512(s0)
    80004372:	000dba03          	ld	s4,0(s11)
    80004376:	8552                	mv	a0,s4
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	fd6080e7          	jalr	-42(ra) # 8000034e <strlen>
    80004380:	0015069b          	addiw	a3,a0,1
    80004384:	8652                	mv	a2,s4
    80004386:	85ca                	mv	a1,s2
    80004388:	855e                	mv	a0,s7
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	7d2080e7          	jalr	2002(ra) # 80000b5c <copyout>
    80004392:	10054f63          	bltz	a0,800044b0 <exec+0x30e>
    ustack[argc] = sp;
    80004396:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000439a:	0485                	addi	s1,s1,1
    8000439c:	008d8793          	addi	a5,s11,8
    800043a0:	e0f43023          	sd	a5,-512(s0)
    800043a4:	008db503          	ld	a0,8(s11)
    800043a8:	c911                	beqz	a0,800043bc <exec+0x21a>
    if(argc >= MAXARG)
    800043aa:	09a1                	addi	s3,s3,8
    800043ac:	fb3c96e3          	bne	s9,s3,80004358 <exec+0x1b6>
  sz = sz1;
    800043b0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b4:	4481                	li	s1,0
    800043b6:	a0e9                	j	80004480 <exec+0x2de>
  sp = sz;
    800043b8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ba:	4481                	li	s1,0
  ustack[argc] = 0;
    800043bc:	00349793          	slli	a5,s1,0x3
    800043c0:	f9040713          	addi	a4,s0,-112
    800043c4:	97ba                	add	a5,a5,a4
    800043c6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043ca:	00148693          	addi	a3,s1,1
    800043ce:	068e                	slli	a3,a3,0x3
    800043d0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043d4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043d8:	01897663          	bgeu	s2,s8,800043e4 <exec+0x242>
  sz = sz1;
    800043dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e0:	4481                	li	s1,0
    800043e2:	a879                	j	80004480 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043e4:	e9040613          	addi	a2,s0,-368
    800043e8:	85ca                	mv	a1,s2
    800043ea:	855e                	mv	a0,s7
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	770080e7          	jalr	1904(ra) # 80000b5c <copyout>
    800043f4:	0c054263          	bltz	a0,800044b8 <exec+0x316>
  p->trapframe->a1 = sp;
    800043f8:	058ab783          	ld	a5,88(s5)
    800043fc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004400:	df843783          	ld	a5,-520(s0)
    80004404:	0007c703          	lbu	a4,0(a5)
    80004408:	cf11                	beqz	a4,80004424 <exec+0x282>
    8000440a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000440c:	02f00693          	li	a3,47
    80004410:	a039                	j	8000441e <exec+0x27c>
      last = s+1;
    80004412:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004416:	0785                	addi	a5,a5,1
    80004418:	fff7c703          	lbu	a4,-1(a5)
    8000441c:	c701                	beqz	a4,80004424 <exec+0x282>
    if(*s == '/')
    8000441e:	fed71ce3          	bne	a4,a3,80004416 <exec+0x274>
    80004422:	bfc5                	j	80004412 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004424:	4641                	li	a2,16
    80004426:	df843583          	ld	a1,-520(s0)
    8000442a:	158a8513          	addi	a0,s5,344
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	eee080e7          	jalr	-274(ra) # 8000031c <safestrcpy>
  oldpagetable = p->pagetable;
    80004436:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000443a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000443e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004442:	058ab783          	ld	a5,88(s5)
    80004446:	e6843703          	ld	a4,-408(s0)
    8000444a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000444c:	058ab783          	ld	a5,88(s5)
    80004450:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004454:	85ea                	mv	a1,s10
    80004456:	ffffd097          	auipc	ra,0xffffd
    8000445a:	ca0080e7          	jalr	-864(ra) # 800010f6 <proc_freepagetable>
  if (p->pid == 1)
    8000445e:	030aa703          	lw	a4,48(s5)
    80004462:	4785                	li	a5,1
    80004464:	00f70563          	beq	a4,a5,8000446e <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004468:	0004851b          	sext.w	a0,s1
    8000446c:	b3f9                	j	8000423a <exec+0x98>
    vmprint(p->pagetable);
    8000446e:	050ab503          	ld	a0,80(s5)
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	97e080e7          	jalr	-1666(ra) # 80000df0 <vmprint>
    8000447a:	b7fd                	j	80004468 <exec+0x2c6>
    8000447c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004480:	e0843583          	ld	a1,-504(s0)
    80004484:	855e                	mv	a0,s7
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	c70080e7          	jalr	-912(ra) # 800010f6 <proc_freepagetable>
  if(ip){
    8000448e:	d8049ce3          	bnez	s1,80004226 <exec+0x84>
  return -1;
    80004492:	557d                	li	a0,-1
    80004494:	b35d                	j	8000423a <exec+0x98>
    80004496:	e1243423          	sd	s2,-504(s0)
    8000449a:	b7dd                	j	80004480 <exec+0x2de>
    8000449c:	e1243423          	sd	s2,-504(s0)
    800044a0:	b7c5                	j	80004480 <exec+0x2de>
    800044a2:	e1243423          	sd	s2,-504(s0)
    800044a6:	bfe9                	j	80004480 <exec+0x2de>
  sz = sz1;
    800044a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ac:	4481                	li	s1,0
    800044ae:	bfc9                	j	80004480 <exec+0x2de>
  sz = sz1;
    800044b0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044b4:	4481                	li	s1,0
    800044b6:	b7e9                	j	80004480 <exec+0x2de>
  sz = sz1;
    800044b8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044bc:	4481                	li	s1,0
    800044be:	b7c9                	j	80004480 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044c0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044c4:	2b05                	addiw	s6,s6,1
    800044c6:	0389899b          	addiw	s3,s3,56
    800044ca:	e8845783          	lhu	a5,-376(s0)
    800044ce:	e0fb5fe3          	bge	s6,a5,800042ec <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044d2:	2981                	sext.w	s3,s3
    800044d4:	03800713          	li	a4,56
    800044d8:	86ce                	mv	a3,s3
    800044da:	e1840613          	addi	a2,s0,-488
    800044de:	4581                	li	a1,0
    800044e0:	8526                	mv	a0,s1
    800044e2:	fffff097          	auipc	ra,0xfffff
    800044e6:	a76080e7          	jalr	-1418(ra) # 80002f58 <readi>
    800044ea:	03800793          	li	a5,56
    800044ee:	f8f517e3          	bne	a0,a5,8000447c <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    800044f2:	e1842783          	lw	a5,-488(s0)
    800044f6:	4705                	li	a4,1
    800044f8:	fce796e3          	bne	a5,a4,800044c4 <exec+0x322>
    if(ph.memsz < ph.filesz)
    800044fc:	e4043603          	ld	a2,-448(s0)
    80004500:	e3843783          	ld	a5,-456(s0)
    80004504:	f8f669e3          	bltu	a2,a5,80004496 <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004508:	e2843783          	ld	a5,-472(s0)
    8000450c:	963e                	add	a2,a2,a5
    8000450e:	f8f667e3          	bltu	a2,a5,8000449c <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004512:	85ca                	mv	a1,s2
    80004514:	855e                	mv	a0,s7
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	3f6080e7          	jalr	1014(ra) # 8000090c <uvmalloc>
    8000451e:	e0a43423          	sd	a0,-504(s0)
    80004522:	d141                	beqz	a0,800044a2 <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    80004524:	e2843d03          	ld	s10,-472(s0)
    80004528:	df043783          	ld	a5,-528(s0)
    8000452c:	00fd77b3          	and	a5,s10,a5
    80004530:	fba1                	bnez	a5,80004480 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004532:	e2042d83          	lw	s11,-480(s0)
    80004536:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000453a:	f80c03e3          	beqz	s8,800044c0 <exec+0x31e>
    8000453e:	8a62                	mv	s4,s8
    80004540:	4901                	li	s2,0
    80004542:	b361                	j	800042ca <exec+0x128>

0000000080004544 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004544:	7179                	addi	sp,sp,-48
    80004546:	f406                	sd	ra,40(sp)
    80004548:	f022                	sd	s0,32(sp)
    8000454a:	ec26                	sd	s1,24(sp)
    8000454c:	e84a                	sd	s2,16(sp)
    8000454e:	1800                	addi	s0,sp,48
    80004550:	892e                	mv	s2,a1
    80004552:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004554:	fdc40593          	addi	a1,s0,-36
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	b28080e7          	jalr	-1240(ra) # 80002080 <argint>
    80004560:	04054063          	bltz	a0,800045a0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004564:	fdc42703          	lw	a4,-36(s0)
    80004568:	47bd                	li	a5,15
    8000456a:	02e7ed63          	bltu	a5,a4,800045a4 <argfd+0x60>
    8000456e:	ffffd097          	auipc	ra,0xffffd
    80004572:	a28080e7          	jalr	-1496(ra) # 80000f96 <myproc>
    80004576:	fdc42703          	lw	a4,-36(s0)
    8000457a:	01a70793          	addi	a5,a4,26
    8000457e:	078e                	slli	a5,a5,0x3
    80004580:	953e                	add	a0,a0,a5
    80004582:	611c                	ld	a5,0(a0)
    80004584:	c395                	beqz	a5,800045a8 <argfd+0x64>
    return -1;
  if(pfd)
    80004586:	00090463          	beqz	s2,8000458e <argfd+0x4a>
    *pfd = fd;
    8000458a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000458e:	4501                	li	a0,0
  if(pf)
    80004590:	c091                	beqz	s1,80004594 <argfd+0x50>
    *pf = f;
    80004592:	e09c                	sd	a5,0(s1)
}
    80004594:	70a2                	ld	ra,40(sp)
    80004596:	7402                	ld	s0,32(sp)
    80004598:	64e2                	ld	s1,24(sp)
    8000459a:	6942                	ld	s2,16(sp)
    8000459c:	6145                	addi	sp,sp,48
    8000459e:	8082                	ret
    return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	bfcd                	j	80004594 <argfd+0x50>
    return -1;
    800045a4:	557d                	li	a0,-1
    800045a6:	b7fd                	j	80004594 <argfd+0x50>
    800045a8:	557d                	li	a0,-1
    800045aa:	b7ed                	j	80004594 <argfd+0x50>

00000000800045ac <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045ac:	1101                	addi	sp,sp,-32
    800045ae:	ec06                	sd	ra,24(sp)
    800045b0:	e822                	sd	s0,16(sp)
    800045b2:	e426                	sd	s1,8(sp)
    800045b4:	1000                	addi	s0,sp,32
    800045b6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045b8:	ffffd097          	auipc	ra,0xffffd
    800045bc:	9de080e7          	jalr	-1570(ra) # 80000f96 <myproc>
    800045c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045c2:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800045c6:	4501                	li	a0,0
    800045c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ca:	6398                	ld	a4,0(a5)
    800045cc:	cb19                	beqz	a4,800045e2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045ce:	2505                	addiw	a0,a0,1
    800045d0:	07a1                	addi	a5,a5,8
    800045d2:	fed51ce3          	bne	a0,a3,800045ca <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045d6:	557d                	li	a0,-1
}
    800045d8:	60e2                	ld	ra,24(sp)
    800045da:	6442                	ld	s0,16(sp)
    800045dc:	64a2                	ld	s1,8(sp)
    800045de:	6105                	addi	sp,sp,32
    800045e0:	8082                	ret
      p->ofile[fd] = f;
    800045e2:	01a50793          	addi	a5,a0,26
    800045e6:	078e                	slli	a5,a5,0x3
    800045e8:	963e                	add	a2,a2,a5
    800045ea:	e204                	sd	s1,0(a2)
      return fd;
    800045ec:	b7f5                	j	800045d8 <fdalloc+0x2c>

00000000800045ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045ee:	715d                	addi	sp,sp,-80
    800045f0:	e486                	sd	ra,72(sp)
    800045f2:	e0a2                	sd	s0,64(sp)
    800045f4:	fc26                	sd	s1,56(sp)
    800045f6:	f84a                	sd	s2,48(sp)
    800045f8:	f44e                	sd	s3,40(sp)
    800045fa:	f052                	sd	s4,32(sp)
    800045fc:	ec56                	sd	s5,24(sp)
    800045fe:	0880                	addi	s0,sp,80
    80004600:	89ae                	mv	s3,a1
    80004602:	8ab2                	mv	s5,a2
    80004604:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	e6e080e7          	jalr	-402(ra) # 80003478 <nameiparent>
    80004612:	892a                	mv	s2,a0
    80004614:	12050f63          	beqz	a0,80004752 <create+0x164>
    return 0;

  ilock(dp);
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	68c080e7          	jalr	1676(ra) # 80002ca4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004620:	4601                	li	a2,0
    80004622:	fb040593          	addi	a1,s0,-80
    80004626:	854a                	mv	a0,s2
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	b60080e7          	jalr	-1184(ra) # 80003188 <dirlookup>
    80004630:	84aa                	mv	s1,a0
    80004632:	c921                	beqz	a0,80004682 <create+0x94>
    iunlockput(dp);
    80004634:	854a                	mv	a0,s2
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	8d0080e7          	jalr	-1840(ra) # 80002f06 <iunlockput>
    ilock(ip);
    8000463e:	8526                	mv	a0,s1
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	664080e7          	jalr	1636(ra) # 80002ca4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004648:	2981                	sext.w	s3,s3
    8000464a:	4789                	li	a5,2
    8000464c:	02f99463          	bne	s3,a5,80004674 <create+0x86>
    80004650:	0444d783          	lhu	a5,68(s1)
    80004654:	37f9                	addiw	a5,a5,-2
    80004656:	17c2                	slli	a5,a5,0x30
    80004658:	93c1                	srli	a5,a5,0x30
    8000465a:	4705                	li	a4,1
    8000465c:	00f76c63          	bltu	a4,a5,80004674 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004660:	8526                	mv	a0,s1
    80004662:	60a6                	ld	ra,72(sp)
    80004664:	6406                	ld	s0,64(sp)
    80004666:	74e2                	ld	s1,56(sp)
    80004668:	7942                	ld	s2,48(sp)
    8000466a:	79a2                	ld	s3,40(sp)
    8000466c:	7a02                	ld	s4,32(sp)
    8000466e:	6ae2                	ld	s5,24(sp)
    80004670:	6161                	addi	sp,sp,80
    80004672:	8082                	ret
    iunlockput(ip);
    80004674:	8526                	mv	a0,s1
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	890080e7          	jalr	-1904(ra) # 80002f06 <iunlockput>
    return 0;
    8000467e:	4481                	li	s1,0
    80004680:	b7c5                	j	80004660 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004682:	85ce                	mv	a1,s3
    80004684:	00092503          	lw	a0,0(s2)
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	484080e7          	jalr	1156(ra) # 80002b0c <ialloc>
    80004690:	84aa                	mv	s1,a0
    80004692:	c529                	beqz	a0,800046dc <create+0xee>
  ilock(ip);
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	610080e7          	jalr	1552(ra) # 80002ca4 <ilock>
  ip->major = major;
    8000469c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046a0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046a4:	4785                	li	a5,1
    800046a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046aa:	8526                	mv	a0,s1
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	52e080e7          	jalr	1326(ra) # 80002bda <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046b4:	2981                	sext.w	s3,s3
    800046b6:	4785                	li	a5,1
    800046b8:	02f98a63          	beq	s3,a5,800046ec <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046bc:	40d0                	lw	a2,4(s1)
    800046be:	fb040593          	addi	a1,s0,-80
    800046c2:	854a                	mv	a0,s2
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	cd4080e7          	jalr	-812(ra) # 80003398 <dirlink>
    800046cc:	06054b63          	bltz	a0,80004742 <create+0x154>
  iunlockput(dp);
    800046d0:	854a                	mv	a0,s2
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	834080e7          	jalr	-1996(ra) # 80002f06 <iunlockput>
  return ip;
    800046da:	b759                	j	80004660 <create+0x72>
    panic("create: ialloc");
    800046dc:	00004517          	auipc	a0,0x4
    800046e0:	15c50513          	addi	a0,a0,348 # 80008838 <syscalls_name+0x2a8>
    800046e4:	00001097          	auipc	ra,0x1
    800046e8:	684080e7          	jalr	1668(ra) # 80005d68 <panic>
    dp->nlink++;  // for ".."
    800046ec:	04a95783          	lhu	a5,74(s2)
    800046f0:	2785                	addiw	a5,a5,1
    800046f2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046f6:	854a                	mv	a0,s2
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	4e2080e7          	jalr	1250(ra) # 80002bda <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004700:	40d0                	lw	a2,4(s1)
    80004702:	00004597          	auipc	a1,0x4
    80004706:	14658593          	addi	a1,a1,326 # 80008848 <syscalls_name+0x2b8>
    8000470a:	8526                	mv	a0,s1
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	c8c080e7          	jalr	-884(ra) # 80003398 <dirlink>
    80004714:	00054f63          	bltz	a0,80004732 <create+0x144>
    80004718:	00492603          	lw	a2,4(s2)
    8000471c:	00004597          	auipc	a1,0x4
    80004720:	a3c58593          	addi	a1,a1,-1476 # 80008158 <etext+0x158>
    80004724:	8526                	mv	a0,s1
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	c72080e7          	jalr	-910(ra) # 80003398 <dirlink>
    8000472e:	f80557e3          	bgez	a0,800046bc <create+0xce>
      panic("create dots");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	11e50513          	addi	a0,a0,286 # 80008850 <syscalls_name+0x2c0>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	62e080e7          	jalr	1582(ra) # 80005d68 <panic>
    panic("create: dirlink");
    80004742:	00004517          	auipc	a0,0x4
    80004746:	11e50513          	addi	a0,a0,286 # 80008860 <syscalls_name+0x2d0>
    8000474a:	00001097          	auipc	ra,0x1
    8000474e:	61e080e7          	jalr	1566(ra) # 80005d68 <panic>
    return 0;
    80004752:	84aa                	mv	s1,a0
    80004754:	b731                	j	80004660 <create+0x72>

0000000080004756 <sys_dup>:
{
    80004756:	7179                	addi	sp,sp,-48
    80004758:	f406                	sd	ra,40(sp)
    8000475a:	f022                	sd	s0,32(sp)
    8000475c:	ec26                	sd	s1,24(sp)
    8000475e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004760:	fd840613          	addi	a2,s0,-40
    80004764:	4581                	li	a1,0
    80004766:	4501                	li	a0,0
    80004768:	00000097          	auipc	ra,0x0
    8000476c:	ddc080e7          	jalr	-548(ra) # 80004544 <argfd>
    return -1;
    80004770:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004772:	02054363          	bltz	a0,80004798 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004776:	fd843503          	ld	a0,-40(s0)
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	e32080e7          	jalr	-462(ra) # 800045ac <fdalloc>
    80004782:	84aa                	mv	s1,a0
    return -1;
    80004784:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004786:	00054963          	bltz	a0,80004798 <sys_dup+0x42>
  filedup(f);
    8000478a:	fd843503          	ld	a0,-40(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	362080e7          	jalr	866(ra) # 80003af0 <filedup>
  return fd;
    80004796:	87a6                	mv	a5,s1
}
    80004798:	853e                	mv	a0,a5
    8000479a:	70a2                	ld	ra,40(sp)
    8000479c:	7402                	ld	s0,32(sp)
    8000479e:	64e2                	ld	s1,24(sp)
    800047a0:	6145                	addi	sp,sp,48
    800047a2:	8082                	ret

00000000800047a4 <sys_read>:
{
    800047a4:	7179                	addi	sp,sp,-48
    800047a6:	f406                	sd	ra,40(sp)
    800047a8:	f022                	sd	s0,32(sp)
    800047aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ac:	fe840613          	addi	a2,s0,-24
    800047b0:	4581                	li	a1,0
    800047b2:	4501                	li	a0,0
    800047b4:	00000097          	auipc	ra,0x0
    800047b8:	d90080e7          	jalr	-624(ra) # 80004544 <argfd>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	04054163          	bltz	a0,80004800 <sys_read+0x5c>
    800047c2:	fe440593          	addi	a1,s0,-28
    800047c6:	4509                	li	a0,2
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	8b8080e7          	jalr	-1864(ra) # 80002080 <argint>
    return -1;
    800047d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d2:	02054763          	bltz	a0,80004800 <sys_read+0x5c>
    800047d6:	fd840593          	addi	a1,s0,-40
    800047da:	4505                	li	a0,1
    800047dc:	ffffe097          	auipc	ra,0xffffe
    800047e0:	8c6080e7          	jalr	-1850(ra) # 800020a2 <argaddr>
    return -1;
    800047e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e6:	00054d63          	bltz	a0,80004800 <sys_read+0x5c>
  return fileread(f, p, n);
    800047ea:	fe442603          	lw	a2,-28(s0)
    800047ee:	fd843583          	ld	a1,-40(s0)
    800047f2:	fe843503          	ld	a0,-24(s0)
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	486080e7          	jalr	1158(ra) # 80003c7c <fileread>
    800047fe:	87aa                	mv	a5,a0
}
    80004800:	853e                	mv	a0,a5
    80004802:	70a2                	ld	ra,40(sp)
    80004804:	7402                	ld	s0,32(sp)
    80004806:	6145                	addi	sp,sp,48
    80004808:	8082                	ret

000000008000480a <sys_write>:
{
    8000480a:	7179                	addi	sp,sp,-48
    8000480c:	f406                	sd	ra,40(sp)
    8000480e:	f022                	sd	s0,32(sp)
    80004810:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004812:	fe840613          	addi	a2,s0,-24
    80004816:	4581                	li	a1,0
    80004818:	4501                	li	a0,0
    8000481a:	00000097          	auipc	ra,0x0
    8000481e:	d2a080e7          	jalr	-726(ra) # 80004544 <argfd>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004824:	04054163          	bltz	a0,80004866 <sys_write+0x5c>
    80004828:	fe440593          	addi	a1,s0,-28
    8000482c:	4509                	li	a0,2
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	852080e7          	jalr	-1966(ra) # 80002080 <argint>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004838:	02054763          	bltz	a0,80004866 <sys_write+0x5c>
    8000483c:	fd840593          	addi	a1,s0,-40
    80004840:	4505                	li	a0,1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	860080e7          	jalr	-1952(ra) # 800020a2 <argaddr>
    return -1;
    8000484a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000484c:	00054d63          	bltz	a0,80004866 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004850:	fe442603          	lw	a2,-28(s0)
    80004854:	fd843583          	ld	a1,-40(s0)
    80004858:	fe843503          	ld	a0,-24(s0)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	4e2080e7          	jalr	1250(ra) # 80003d3e <filewrite>
    80004864:	87aa                	mv	a5,a0
}
    80004866:	853e                	mv	a0,a5
    80004868:	70a2                	ld	ra,40(sp)
    8000486a:	7402                	ld	s0,32(sp)
    8000486c:	6145                	addi	sp,sp,48
    8000486e:	8082                	ret

0000000080004870 <sys_close>:
{
    80004870:	1101                	addi	sp,sp,-32
    80004872:	ec06                	sd	ra,24(sp)
    80004874:	e822                	sd	s0,16(sp)
    80004876:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004878:	fe040613          	addi	a2,s0,-32
    8000487c:	fec40593          	addi	a1,s0,-20
    80004880:	4501                	li	a0,0
    80004882:	00000097          	auipc	ra,0x0
    80004886:	cc2080e7          	jalr	-830(ra) # 80004544 <argfd>
    return -1;
    8000488a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000488c:	02054463          	bltz	a0,800048b4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004890:	ffffc097          	auipc	ra,0xffffc
    80004894:	706080e7          	jalr	1798(ra) # 80000f96 <myproc>
    80004898:	fec42783          	lw	a5,-20(s0)
    8000489c:	07e9                	addi	a5,a5,26
    8000489e:	078e                	slli	a5,a5,0x3
    800048a0:	97aa                	add	a5,a5,a0
    800048a2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048a6:	fe043503          	ld	a0,-32(s0)
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	298080e7          	jalr	664(ra) # 80003b42 <fileclose>
  return 0;
    800048b2:	4781                	li	a5,0
}
    800048b4:	853e                	mv	a0,a5
    800048b6:	60e2                	ld	ra,24(sp)
    800048b8:	6442                	ld	s0,16(sp)
    800048ba:	6105                	addi	sp,sp,32
    800048bc:	8082                	ret

00000000800048be <sys_fstat>:
{
    800048be:	1101                	addi	sp,sp,-32
    800048c0:	ec06                	sd	ra,24(sp)
    800048c2:	e822                	sd	s0,16(sp)
    800048c4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c6:	fe840613          	addi	a2,s0,-24
    800048ca:	4581                	li	a1,0
    800048cc:	4501                	li	a0,0
    800048ce:	00000097          	auipc	ra,0x0
    800048d2:	c76080e7          	jalr	-906(ra) # 80004544 <argfd>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d8:	02054563          	bltz	a0,80004902 <sys_fstat+0x44>
    800048dc:	fe040593          	addi	a1,s0,-32
    800048e0:	4505                	li	a0,1
    800048e2:	ffffd097          	auipc	ra,0xffffd
    800048e6:	7c0080e7          	jalr	1984(ra) # 800020a2 <argaddr>
    return -1;
    800048ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048ec:	00054b63          	bltz	a0,80004902 <sys_fstat+0x44>
  return filestat(f, st);
    800048f0:	fe043583          	ld	a1,-32(s0)
    800048f4:	fe843503          	ld	a0,-24(s0)
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	312080e7          	jalr	786(ra) # 80003c0a <filestat>
    80004900:	87aa                	mv	a5,a0
}
    80004902:	853e                	mv	a0,a5
    80004904:	60e2                	ld	ra,24(sp)
    80004906:	6442                	ld	s0,16(sp)
    80004908:	6105                	addi	sp,sp,32
    8000490a:	8082                	ret

000000008000490c <sys_link>:
{
    8000490c:	7169                	addi	sp,sp,-304
    8000490e:	f606                	sd	ra,296(sp)
    80004910:	f222                	sd	s0,288(sp)
    80004912:	ee26                	sd	s1,280(sp)
    80004914:	ea4a                	sd	s2,272(sp)
    80004916:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004918:	08000613          	li	a2,128
    8000491c:	ed040593          	addi	a1,s0,-304
    80004920:	4501                	li	a0,0
    80004922:	ffffd097          	auipc	ra,0xffffd
    80004926:	7a2080e7          	jalr	1954(ra) # 800020c4 <argstr>
    return -1;
    8000492a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492c:	10054e63          	bltz	a0,80004a48 <sys_link+0x13c>
    80004930:	08000613          	li	a2,128
    80004934:	f5040593          	addi	a1,s0,-176
    80004938:	4505                	li	a0,1
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	78a080e7          	jalr	1930(ra) # 800020c4 <argstr>
    return -1;
    80004942:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004944:	10054263          	bltz	a0,80004a48 <sys_link+0x13c>
  begin_op();
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	d2e080e7          	jalr	-722(ra) # 80003676 <begin_op>
  if((ip = namei(old)) == 0){
    80004950:	ed040513          	addi	a0,s0,-304
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	b06080e7          	jalr	-1274(ra) # 8000345a <namei>
    8000495c:	84aa                	mv	s1,a0
    8000495e:	c551                	beqz	a0,800049ea <sys_link+0xde>
  ilock(ip);
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	344080e7          	jalr	836(ra) # 80002ca4 <ilock>
  if(ip->type == T_DIR){
    80004968:	04449703          	lh	a4,68(s1)
    8000496c:	4785                	li	a5,1
    8000496e:	08f70463          	beq	a4,a5,800049f6 <sys_link+0xea>
  ip->nlink++;
    80004972:	04a4d783          	lhu	a5,74(s1)
    80004976:	2785                	addiw	a5,a5,1
    80004978:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000497c:	8526                	mv	a0,s1
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	25c080e7          	jalr	604(ra) # 80002bda <iupdate>
  iunlock(ip);
    80004986:	8526                	mv	a0,s1
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	3de080e7          	jalr	990(ra) # 80002d66 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004990:	fd040593          	addi	a1,s0,-48
    80004994:	f5040513          	addi	a0,s0,-176
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	ae0080e7          	jalr	-1312(ra) # 80003478 <nameiparent>
    800049a0:	892a                	mv	s2,a0
    800049a2:	c935                	beqz	a0,80004a16 <sys_link+0x10a>
  ilock(dp);
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	300080e7          	jalr	768(ra) # 80002ca4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049ac:	00092703          	lw	a4,0(s2)
    800049b0:	409c                	lw	a5,0(s1)
    800049b2:	04f71d63          	bne	a4,a5,80004a0c <sys_link+0x100>
    800049b6:	40d0                	lw	a2,4(s1)
    800049b8:	fd040593          	addi	a1,s0,-48
    800049bc:	854a                	mv	a0,s2
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	9da080e7          	jalr	-1574(ra) # 80003398 <dirlink>
    800049c6:	04054363          	bltz	a0,80004a0c <sys_link+0x100>
  iunlockput(dp);
    800049ca:	854a                	mv	a0,s2
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	53a080e7          	jalr	1338(ra) # 80002f06 <iunlockput>
  iput(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	488080e7          	jalr	1160(ra) # 80002e5e <iput>
  end_op();
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	d18080e7          	jalr	-744(ra) # 800036f6 <end_op>
  return 0;
    800049e6:	4781                	li	a5,0
    800049e8:	a085                	j	80004a48 <sys_link+0x13c>
    end_op();
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	d0c080e7          	jalr	-756(ra) # 800036f6 <end_op>
    return -1;
    800049f2:	57fd                	li	a5,-1
    800049f4:	a891                	j	80004a48 <sys_link+0x13c>
    iunlockput(ip);
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	50e080e7          	jalr	1294(ra) # 80002f06 <iunlockput>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	cf6080e7          	jalr	-778(ra) # 800036f6 <end_op>
    return -1;
    80004a08:	57fd                	li	a5,-1
    80004a0a:	a83d                	j	80004a48 <sys_link+0x13c>
    iunlockput(dp);
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	4f8080e7          	jalr	1272(ra) # 80002f06 <iunlockput>
  ilock(ip);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	28c080e7          	jalr	652(ra) # 80002ca4 <ilock>
  ip->nlink--;
    80004a20:	04a4d783          	lhu	a5,74(s1)
    80004a24:	37fd                	addiw	a5,a5,-1
    80004a26:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	1ae080e7          	jalr	430(ra) # 80002bda <iupdate>
  iunlockput(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	4d0080e7          	jalr	1232(ra) # 80002f06 <iunlockput>
  end_op();
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	cb8080e7          	jalr	-840(ra) # 800036f6 <end_op>
  return -1;
    80004a46:	57fd                	li	a5,-1
}
    80004a48:	853e                	mv	a0,a5
    80004a4a:	70b2                	ld	ra,296(sp)
    80004a4c:	7412                	ld	s0,288(sp)
    80004a4e:	64f2                	ld	s1,280(sp)
    80004a50:	6952                	ld	s2,272(sp)
    80004a52:	6155                	addi	sp,sp,304
    80004a54:	8082                	ret

0000000080004a56 <sys_unlink>:
{
    80004a56:	7151                	addi	sp,sp,-240
    80004a58:	f586                	sd	ra,232(sp)
    80004a5a:	f1a2                	sd	s0,224(sp)
    80004a5c:	eda6                	sd	s1,216(sp)
    80004a5e:	e9ca                	sd	s2,208(sp)
    80004a60:	e5ce                	sd	s3,200(sp)
    80004a62:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a64:	08000613          	li	a2,128
    80004a68:	f3040593          	addi	a1,s0,-208
    80004a6c:	4501                	li	a0,0
    80004a6e:	ffffd097          	auipc	ra,0xffffd
    80004a72:	656080e7          	jalr	1622(ra) # 800020c4 <argstr>
    80004a76:	18054163          	bltz	a0,80004bf8 <sys_unlink+0x1a2>
  begin_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	bfc080e7          	jalr	-1028(ra) # 80003676 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a82:	fb040593          	addi	a1,s0,-80
    80004a86:	f3040513          	addi	a0,s0,-208
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	9ee080e7          	jalr	-1554(ra) # 80003478 <nameiparent>
    80004a92:	84aa                	mv	s1,a0
    80004a94:	c979                	beqz	a0,80004b6a <sys_unlink+0x114>
  ilock(dp);
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	20e080e7          	jalr	526(ra) # 80002ca4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9e:	00004597          	auipc	a1,0x4
    80004aa2:	daa58593          	addi	a1,a1,-598 # 80008848 <syscalls_name+0x2b8>
    80004aa6:	fb040513          	addi	a0,s0,-80
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	6c4080e7          	jalr	1732(ra) # 8000316e <namecmp>
    80004ab2:	14050a63          	beqz	a0,80004c06 <sys_unlink+0x1b0>
    80004ab6:	00003597          	auipc	a1,0x3
    80004aba:	6a258593          	addi	a1,a1,1698 # 80008158 <etext+0x158>
    80004abe:	fb040513          	addi	a0,s0,-80
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	6ac080e7          	jalr	1708(ra) # 8000316e <namecmp>
    80004aca:	12050e63          	beqz	a0,80004c06 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ace:	f2c40613          	addi	a2,s0,-212
    80004ad2:	fb040593          	addi	a1,s0,-80
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	6b0080e7          	jalr	1712(ra) # 80003188 <dirlookup>
    80004ae0:	892a                	mv	s2,a0
    80004ae2:	12050263          	beqz	a0,80004c06 <sys_unlink+0x1b0>
  ilock(ip);
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	1be080e7          	jalr	446(ra) # 80002ca4 <ilock>
  if(ip->nlink < 1)
    80004aee:	04a91783          	lh	a5,74(s2)
    80004af2:	08f05263          	blez	a5,80004b76 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004af6:	04491703          	lh	a4,68(s2)
    80004afa:	4785                	li	a5,1
    80004afc:	08f70563          	beq	a4,a5,80004b86 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b00:	4641                	li	a2,16
    80004b02:	4581                	li	a1,0
    80004b04:	fc040513          	addi	a0,s0,-64
    80004b08:	ffffb097          	auipc	ra,0xffffb
    80004b0c:	6c2080e7          	jalr	1730(ra) # 800001ca <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b10:	4741                	li	a4,16
    80004b12:	f2c42683          	lw	a3,-212(s0)
    80004b16:	fc040613          	addi	a2,s0,-64
    80004b1a:	4581                	li	a1,0
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	532080e7          	jalr	1330(ra) # 80003050 <writei>
    80004b26:	47c1                	li	a5,16
    80004b28:	0af51563          	bne	a0,a5,80004bd2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b2c:	04491703          	lh	a4,68(s2)
    80004b30:	4785                	li	a5,1
    80004b32:	0af70863          	beq	a4,a5,80004be2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	3ce080e7          	jalr	974(ra) # 80002f06 <iunlockput>
  ip->nlink--;
    80004b40:	04a95783          	lhu	a5,74(s2)
    80004b44:	37fd                	addiw	a5,a5,-1
    80004b46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b4a:	854a                	mv	a0,s2
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	08e080e7          	jalr	142(ra) # 80002bda <iupdate>
  iunlockput(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	3b0080e7          	jalr	944(ra) # 80002f06 <iunlockput>
  end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	b98080e7          	jalr	-1128(ra) # 800036f6 <end_op>
  return 0;
    80004b66:	4501                	li	a0,0
    80004b68:	a84d                	j	80004c1a <sys_unlink+0x1c4>
    end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	b8c080e7          	jalr	-1140(ra) # 800036f6 <end_op>
    return -1;
    80004b72:	557d                	li	a0,-1
    80004b74:	a05d                	j	80004c1a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b76:	00004517          	auipc	a0,0x4
    80004b7a:	cfa50513          	addi	a0,a0,-774 # 80008870 <syscalls_name+0x2e0>
    80004b7e:	00001097          	auipc	ra,0x1
    80004b82:	1ea080e7          	jalr	490(ra) # 80005d68 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b86:	04c92703          	lw	a4,76(s2)
    80004b8a:	02000793          	li	a5,32
    80004b8e:	f6e7f9e3          	bgeu	a5,a4,80004b00 <sys_unlink+0xaa>
    80004b92:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b96:	4741                	li	a4,16
    80004b98:	86ce                	mv	a3,s3
    80004b9a:	f1840613          	addi	a2,s0,-232
    80004b9e:	4581                	li	a1,0
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	3b6080e7          	jalr	950(ra) # 80002f58 <readi>
    80004baa:	47c1                	li	a5,16
    80004bac:	00f51b63          	bne	a0,a5,80004bc2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bb0:	f1845783          	lhu	a5,-232(s0)
    80004bb4:	e7a1                	bnez	a5,80004bfc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb6:	29c1                	addiw	s3,s3,16
    80004bb8:	04c92783          	lw	a5,76(s2)
    80004bbc:	fcf9ede3          	bltu	s3,a5,80004b96 <sys_unlink+0x140>
    80004bc0:	b781                	j	80004b00 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bc2:	00004517          	auipc	a0,0x4
    80004bc6:	cc650513          	addi	a0,a0,-826 # 80008888 <syscalls_name+0x2f8>
    80004bca:	00001097          	auipc	ra,0x1
    80004bce:	19e080e7          	jalr	414(ra) # 80005d68 <panic>
    panic("unlink: writei");
    80004bd2:	00004517          	auipc	a0,0x4
    80004bd6:	cce50513          	addi	a0,a0,-818 # 800088a0 <syscalls_name+0x310>
    80004bda:	00001097          	auipc	ra,0x1
    80004bde:	18e080e7          	jalr	398(ra) # 80005d68 <panic>
    dp->nlink--;
    80004be2:	04a4d783          	lhu	a5,74(s1)
    80004be6:	37fd                	addiw	a5,a5,-1
    80004be8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	fec080e7          	jalr	-20(ra) # 80002bda <iupdate>
    80004bf6:	b781                	j	80004b36 <sys_unlink+0xe0>
    return -1;
    80004bf8:	557d                	li	a0,-1
    80004bfa:	a005                	j	80004c1a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bfc:	854a                	mv	a0,s2
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	308080e7          	jalr	776(ra) # 80002f06 <iunlockput>
  iunlockput(dp);
    80004c06:	8526                	mv	a0,s1
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	2fe080e7          	jalr	766(ra) # 80002f06 <iunlockput>
  end_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	ae6080e7          	jalr	-1306(ra) # 800036f6 <end_op>
  return -1;
    80004c18:	557d                	li	a0,-1
}
    80004c1a:	70ae                	ld	ra,232(sp)
    80004c1c:	740e                	ld	s0,224(sp)
    80004c1e:	64ee                	ld	s1,216(sp)
    80004c20:	694e                	ld	s2,208(sp)
    80004c22:	69ae                	ld	s3,200(sp)
    80004c24:	616d                	addi	sp,sp,240
    80004c26:	8082                	ret

0000000080004c28 <sys_open>:

uint64
sys_open(void)
{
    80004c28:	7131                	addi	sp,sp,-192
    80004c2a:	fd06                	sd	ra,184(sp)
    80004c2c:	f922                	sd	s0,176(sp)
    80004c2e:	f526                	sd	s1,168(sp)
    80004c30:	f14a                	sd	s2,160(sp)
    80004c32:	ed4e                	sd	s3,152(sp)
    80004c34:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c36:	08000613          	li	a2,128
    80004c3a:	f5040593          	addi	a1,s0,-176
    80004c3e:	4501                	li	a0,0
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	484080e7          	jalr	1156(ra) # 800020c4 <argstr>
    return -1;
    80004c48:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c4a:	0c054163          	bltz	a0,80004d0c <sys_open+0xe4>
    80004c4e:	f4c40593          	addi	a1,s0,-180
    80004c52:	4505                	li	a0,1
    80004c54:	ffffd097          	auipc	ra,0xffffd
    80004c58:	42c080e7          	jalr	1068(ra) # 80002080 <argint>
    80004c5c:	0a054863          	bltz	a0,80004d0c <sys_open+0xe4>

  begin_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	a16080e7          	jalr	-1514(ra) # 80003676 <begin_op>

  if(omode & O_CREATE){
    80004c68:	f4c42783          	lw	a5,-180(s0)
    80004c6c:	2007f793          	andi	a5,a5,512
    80004c70:	cbdd                	beqz	a5,80004d26 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c72:	4681                	li	a3,0
    80004c74:	4601                	li	a2,0
    80004c76:	4589                	li	a1,2
    80004c78:	f5040513          	addi	a0,s0,-176
    80004c7c:	00000097          	auipc	ra,0x0
    80004c80:	972080e7          	jalr	-1678(ra) # 800045ee <create>
    80004c84:	892a                	mv	s2,a0
    if(ip == 0){
    80004c86:	c959                	beqz	a0,80004d1c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c88:	04491703          	lh	a4,68(s2)
    80004c8c:	478d                	li	a5,3
    80004c8e:	00f71763          	bne	a4,a5,80004c9c <sys_open+0x74>
    80004c92:	04695703          	lhu	a4,70(s2)
    80004c96:	47a5                	li	a5,9
    80004c98:	0ce7ec63          	bltu	a5,a4,80004d70 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	dea080e7          	jalr	-534(ra) # 80003a86 <filealloc>
    80004ca4:	89aa                	mv	s3,a0
    80004ca6:	10050263          	beqz	a0,80004daa <sys_open+0x182>
    80004caa:	00000097          	auipc	ra,0x0
    80004cae:	902080e7          	jalr	-1790(ra) # 800045ac <fdalloc>
    80004cb2:	84aa                	mv	s1,a0
    80004cb4:	0e054663          	bltz	a0,80004da0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cb8:	04491703          	lh	a4,68(s2)
    80004cbc:	478d                	li	a5,3
    80004cbe:	0cf70463          	beq	a4,a5,80004d86 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cc2:	4789                	li	a5,2
    80004cc4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cc8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ccc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cd0:	f4c42783          	lw	a5,-180(s0)
    80004cd4:	0017c713          	xori	a4,a5,1
    80004cd8:	8b05                	andi	a4,a4,1
    80004cda:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cde:	0037f713          	andi	a4,a5,3
    80004ce2:	00e03733          	snez	a4,a4
    80004ce6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cea:	4007f793          	andi	a5,a5,1024
    80004cee:	c791                	beqz	a5,80004cfa <sys_open+0xd2>
    80004cf0:	04491703          	lh	a4,68(s2)
    80004cf4:	4789                	li	a5,2
    80004cf6:	08f70f63          	beq	a4,a5,80004d94 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cfa:	854a                	mv	a0,s2
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	06a080e7          	jalr	106(ra) # 80002d66 <iunlock>
  end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	9f2080e7          	jalr	-1550(ra) # 800036f6 <end_op>

  return fd;
}
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	70ea                	ld	ra,184(sp)
    80004d10:	744a                	ld	s0,176(sp)
    80004d12:	74aa                	ld	s1,168(sp)
    80004d14:	790a                	ld	s2,160(sp)
    80004d16:	69ea                	ld	s3,152(sp)
    80004d18:	6129                	addi	sp,sp,192
    80004d1a:	8082                	ret
      end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	9da080e7          	jalr	-1574(ra) # 800036f6 <end_op>
      return -1;
    80004d24:	b7e5                	j	80004d0c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d26:	f5040513          	addi	a0,s0,-176
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	730080e7          	jalr	1840(ra) # 8000345a <namei>
    80004d32:	892a                	mv	s2,a0
    80004d34:	c905                	beqz	a0,80004d64 <sys_open+0x13c>
    ilock(ip);
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	f6e080e7          	jalr	-146(ra) # 80002ca4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d3e:	04491703          	lh	a4,68(s2)
    80004d42:	4785                	li	a5,1
    80004d44:	f4f712e3          	bne	a4,a5,80004c88 <sys_open+0x60>
    80004d48:	f4c42783          	lw	a5,-180(s0)
    80004d4c:	dba1                	beqz	a5,80004c9c <sys_open+0x74>
      iunlockput(ip);
    80004d4e:	854a                	mv	a0,s2
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	1b6080e7          	jalr	438(ra) # 80002f06 <iunlockput>
      end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	99e080e7          	jalr	-1634(ra) # 800036f6 <end_op>
      return -1;
    80004d60:	54fd                	li	s1,-1
    80004d62:	b76d                	j	80004d0c <sys_open+0xe4>
      end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	992080e7          	jalr	-1646(ra) # 800036f6 <end_op>
      return -1;
    80004d6c:	54fd                	li	s1,-1
    80004d6e:	bf79                	j	80004d0c <sys_open+0xe4>
    iunlockput(ip);
    80004d70:	854a                	mv	a0,s2
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	194080e7          	jalr	404(ra) # 80002f06 <iunlockput>
    end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	97c080e7          	jalr	-1668(ra) # 800036f6 <end_op>
    return -1;
    80004d82:	54fd                	li	s1,-1
    80004d84:	b761                	j	80004d0c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d86:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d8a:	04691783          	lh	a5,70(s2)
    80004d8e:	02f99223          	sh	a5,36(s3)
    80004d92:	bf2d                	j	80004ccc <sys_open+0xa4>
    itrunc(ip);
    80004d94:	854a                	mv	a0,s2
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	01c080e7          	jalr	28(ra) # 80002db2 <itrunc>
    80004d9e:	bfb1                	j	80004cfa <sys_open+0xd2>
      fileclose(f);
    80004da0:	854e                	mv	a0,s3
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	da0080e7          	jalr	-608(ra) # 80003b42 <fileclose>
    iunlockput(ip);
    80004daa:	854a                	mv	a0,s2
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	15a080e7          	jalr	346(ra) # 80002f06 <iunlockput>
    end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	942080e7          	jalr	-1726(ra) # 800036f6 <end_op>
    return -1;
    80004dbc:	54fd                	li	s1,-1
    80004dbe:	b7b9                	j	80004d0c <sys_open+0xe4>

0000000080004dc0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dc0:	7175                	addi	sp,sp,-144
    80004dc2:	e506                	sd	ra,136(sp)
    80004dc4:	e122                	sd	s0,128(sp)
    80004dc6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	8ae080e7          	jalr	-1874(ra) # 80003676 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dd0:	08000613          	li	a2,128
    80004dd4:	f7040593          	addi	a1,s0,-144
    80004dd8:	4501                	li	a0,0
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	2ea080e7          	jalr	746(ra) # 800020c4 <argstr>
    80004de2:	02054963          	bltz	a0,80004e14 <sys_mkdir+0x54>
    80004de6:	4681                	li	a3,0
    80004de8:	4601                	li	a2,0
    80004dea:	4585                	li	a1,1
    80004dec:	f7040513          	addi	a0,s0,-144
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	7fe080e7          	jalr	2046(ra) # 800045ee <create>
    80004df8:	cd11                	beqz	a0,80004e14 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	10c080e7          	jalr	268(ra) # 80002f06 <iunlockput>
  end_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	8f4080e7          	jalr	-1804(ra) # 800036f6 <end_op>
  return 0;
    80004e0a:	4501                	li	a0,0
}
    80004e0c:	60aa                	ld	ra,136(sp)
    80004e0e:	640a                	ld	s0,128(sp)
    80004e10:	6149                	addi	sp,sp,144
    80004e12:	8082                	ret
    end_op();
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	8e2080e7          	jalr	-1822(ra) # 800036f6 <end_op>
    return -1;
    80004e1c:	557d                	li	a0,-1
    80004e1e:	b7fd                	j	80004e0c <sys_mkdir+0x4c>

0000000080004e20 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e20:	7135                	addi	sp,sp,-160
    80004e22:	ed06                	sd	ra,152(sp)
    80004e24:	e922                	sd	s0,144(sp)
    80004e26:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	84e080e7          	jalr	-1970(ra) # 80003676 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e30:	08000613          	li	a2,128
    80004e34:	f7040593          	addi	a1,s0,-144
    80004e38:	4501                	li	a0,0
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	28a080e7          	jalr	650(ra) # 800020c4 <argstr>
    80004e42:	04054a63          	bltz	a0,80004e96 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e46:	f6c40593          	addi	a1,s0,-148
    80004e4a:	4505                	li	a0,1
    80004e4c:	ffffd097          	auipc	ra,0xffffd
    80004e50:	234080e7          	jalr	564(ra) # 80002080 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e54:	04054163          	bltz	a0,80004e96 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e58:	f6840593          	addi	a1,s0,-152
    80004e5c:	4509                	li	a0,2
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	222080e7          	jalr	546(ra) # 80002080 <argint>
     argint(1, &major) < 0 ||
    80004e66:	02054863          	bltz	a0,80004e96 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e6a:	f6841683          	lh	a3,-152(s0)
    80004e6e:	f6c41603          	lh	a2,-148(s0)
    80004e72:	458d                	li	a1,3
    80004e74:	f7040513          	addi	a0,s0,-144
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	776080e7          	jalr	1910(ra) # 800045ee <create>
     argint(2, &minor) < 0 ||
    80004e80:	c919                	beqz	a0,80004e96 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	084080e7          	jalr	132(ra) # 80002f06 <iunlockput>
  end_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	86c080e7          	jalr	-1940(ra) # 800036f6 <end_op>
  return 0;
    80004e92:	4501                	li	a0,0
    80004e94:	a031                	j	80004ea0 <sys_mknod+0x80>
    end_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	860080e7          	jalr	-1952(ra) # 800036f6 <end_op>
    return -1;
    80004e9e:	557d                	li	a0,-1
}
    80004ea0:	60ea                	ld	ra,152(sp)
    80004ea2:	644a                	ld	s0,144(sp)
    80004ea4:	610d                	addi	sp,sp,160
    80004ea6:	8082                	ret

0000000080004ea8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ea8:	7135                	addi	sp,sp,-160
    80004eaa:	ed06                	sd	ra,152(sp)
    80004eac:	e922                	sd	s0,144(sp)
    80004eae:	e526                	sd	s1,136(sp)
    80004eb0:	e14a                	sd	s2,128(sp)
    80004eb2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eb4:	ffffc097          	auipc	ra,0xffffc
    80004eb8:	0e2080e7          	jalr	226(ra) # 80000f96 <myproc>
    80004ebc:	892a                	mv	s2,a0
  
  begin_op();
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	7b8080e7          	jalr	1976(ra) # 80003676 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ec6:	08000613          	li	a2,128
    80004eca:	f6040593          	addi	a1,s0,-160
    80004ece:	4501                	li	a0,0
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	1f4080e7          	jalr	500(ra) # 800020c4 <argstr>
    80004ed8:	04054b63          	bltz	a0,80004f2e <sys_chdir+0x86>
    80004edc:	f6040513          	addi	a0,s0,-160
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	57a080e7          	jalr	1402(ra) # 8000345a <namei>
    80004ee8:	84aa                	mv	s1,a0
    80004eea:	c131                	beqz	a0,80004f2e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	db8080e7          	jalr	-584(ra) # 80002ca4 <ilock>
  if(ip->type != T_DIR){
    80004ef4:	04449703          	lh	a4,68(s1)
    80004ef8:	4785                	li	a5,1
    80004efa:	04f71063          	bne	a4,a5,80004f3a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004efe:	8526                	mv	a0,s1
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	e66080e7          	jalr	-410(ra) # 80002d66 <iunlock>
  iput(p->cwd);
    80004f08:	15093503          	ld	a0,336(s2)
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	f52080e7          	jalr	-174(ra) # 80002e5e <iput>
  end_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	7e2080e7          	jalr	2018(ra) # 800036f6 <end_op>
  p->cwd = ip;
    80004f1c:	14993823          	sd	s1,336(s2)
  return 0;
    80004f20:	4501                	li	a0,0
}
    80004f22:	60ea                	ld	ra,152(sp)
    80004f24:	644a                	ld	s0,144(sp)
    80004f26:	64aa                	ld	s1,136(sp)
    80004f28:	690a                	ld	s2,128(sp)
    80004f2a:	610d                	addi	sp,sp,160
    80004f2c:	8082                	ret
    end_op();
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	7c8080e7          	jalr	1992(ra) # 800036f6 <end_op>
    return -1;
    80004f36:	557d                	li	a0,-1
    80004f38:	b7ed                	j	80004f22 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f3a:	8526                	mv	a0,s1
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	fca080e7          	jalr	-54(ra) # 80002f06 <iunlockput>
    end_op();
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	7b2080e7          	jalr	1970(ra) # 800036f6 <end_op>
    return -1;
    80004f4c:	557d                	li	a0,-1
    80004f4e:	bfd1                	j	80004f22 <sys_chdir+0x7a>

0000000080004f50 <sys_exec>:

uint64
sys_exec(void)
{
    80004f50:	7145                	addi	sp,sp,-464
    80004f52:	e786                	sd	ra,456(sp)
    80004f54:	e3a2                	sd	s0,448(sp)
    80004f56:	ff26                	sd	s1,440(sp)
    80004f58:	fb4a                	sd	s2,432(sp)
    80004f5a:	f74e                	sd	s3,424(sp)
    80004f5c:	f352                	sd	s4,416(sp)
    80004f5e:	ef56                	sd	s5,408(sp)
    80004f60:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f62:	08000613          	li	a2,128
    80004f66:	f4040593          	addi	a1,s0,-192
    80004f6a:	4501                	li	a0,0
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	158080e7          	jalr	344(ra) # 800020c4 <argstr>
    return -1;
    80004f74:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f76:	0c054a63          	bltz	a0,8000504a <sys_exec+0xfa>
    80004f7a:	e3840593          	addi	a1,s0,-456
    80004f7e:	4505                	li	a0,1
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	122080e7          	jalr	290(ra) # 800020a2 <argaddr>
    80004f88:	0c054163          	bltz	a0,8000504a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f8c:	10000613          	li	a2,256
    80004f90:	4581                	li	a1,0
    80004f92:	e4040513          	addi	a0,s0,-448
    80004f96:	ffffb097          	auipc	ra,0xffffb
    80004f9a:	234080e7          	jalr	564(ra) # 800001ca <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f9e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fa2:	89a6                	mv	s3,s1
    80004fa4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fa6:	02000a13          	li	s4,32
    80004faa:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fae:	00391513          	slli	a0,s2,0x3
    80004fb2:	e3040593          	addi	a1,s0,-464
    80004fb6:	e3843783          	ld	a5,-456(s0)
    80004fba:	953e                	add	a0,a0,a5
    80004fbc:	ffffd097          	auipc	ra,0xffffd
    80004fc0:	02a080e7          	jalr	42(ra) # 80001fe6 <fetchaddr>
    80004fc4:	02054a63          	bltz	a0,80004ff8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fc8:	e3043783          	ld	a5,-464(s0)
    80004fcc:	c3b9                	beqz	a5,80005012 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fce:	ffffb097          	auipc	ra,0xffffb
    80004fd2:	14a080e7          	jalr	330(ra) # 80000118 <kalloc>
    80004fd6:	85aa                	mv	a1,a0
    80004fd8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fdc:	cd11                	beqz	a0,80004ff8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fde:	6605                	lui	a2,0x1
    80004fe0:	e3043503          	ld	a0,-464(s0)
    80004fe4:	ffffd097          	auipc	ra,0xffffd
    80004fe8:	054080e7          	jalr	84(ra) # 80002038 <fetchstr>
    80004fec:	00054663          	bltz	a0,80004ff8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ff0:	0905                	addi	s2,s2,1
    80004ff2:	09a1                	addi	s3,s3,8
    80004ff4:	fb491be3          	bne	s2,s4,80004faa <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff8:	10048913          	addi	s2,s1,256
    80004ffc:	6088                	ld	a0,0(s1)
    80004ffe:	c529                	beqz	a0,80005048 <sys_exec+0xf8>
    kfree(argv[i]);
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	01c080e7          	jalr	28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005008:	04a1                	addi	s1,s1,8
    8000500a:	ff2499e3          	bne	s1,s2,80004ffc <sys_exec+0xac>
  return -1;
    8000500e:	597d                	li	s2,-1
    80005010:	a82d                	j	8000504a <sys_exec+0xfa>
      argv[i] = 0;
    80005012:	0a8e                	slli	s5,s5,0x3
    80005014:	fc040793          	addi	a5,s0,-64
    80005018:	9abe                	add	s5,s5,a5
    8000501a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000501e:	e4040593          	addi	a1,s0,-448
    80005022:	f4040513          	addi	a0,s0,-192
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	17c080e7          	jalr	380(ra) # 800041a2 <exec>
    8000502e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	10048993          	addi	s3,s1,256
    80005034:	6088                	ld	a0,0(s1)
    80005036:	c911                	beqz	a0,8000504a <sys_exec+0xfa>
    kfree(argv[i]);
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	fe4080e7          	jalr	-28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005040:	04a1                	addi	s1,s1,8
    80005042:	ff3499e3          	bne	s1,s3,80005034 <sys_exec+0xe4>
    80005046:	a011                	j	8000504a <sys_exec+0xfa>
  return -1;
    80005048:	597d                	li	s2,-1
}
    8000504a:	854a                	mv	a0,s2
    8000504c:	60be                	ld	ra,456(sp)
    8000504e:	641e                	ld	s0,448(sp)
    80005050:	74fa                	ld	s1,440(sp)
    80005052:	795a                	ld	s2,432(sp)
    80005054:	79ba                	ld	s3,424(sp)
    80005056:	7a1a                	ld	s4,416(sp)
    80005058:	6afa                	ld	s5,408(sp)
    8000505a:	6179                	addi	sp,sp,464
    8000505c:	8082                	ret

000000008000505e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000505e:	7139                	addi	sp,sp,-64
    80005060:	fc06                	sd	ra,56(sp)
    80005062:	f822                	sd	s0,48(sp)
    80005064:	f426                	sd	s1,40(sp)
    80005066:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	f2e080e7          	jalr	-210(ra) # 80000f96 <myproc>
    80005070:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005072:	fd840593          	addi	a1,s0,-40
    80005076:	4501                	li	a0,0
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	02a080e7          	jalr	42(ra) # 800020a2 <argaddr>
    return -1;
    80005080:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005082:	0e054063          	bltz	a0,80005162 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005086:	fc840593          	addi	a1,s0,-56
    8000508a:	fd040513          	addi	a0,s0,-48
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	de4080e7          	jalr	-540(ra) # 80003e72 <pipealloc>
    return -1;
    80005096:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005098:	0c054563          	bltz	a0,80005162 <sys_pipe+0x104>
  fd0 = -1;
    8000509c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050a0:	fd043503          	ld	a0,-48(s0)
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	508080e7          	jalr	1288(ra) # 800045ac <fdalloc>
    800050ac:	fca42223          	sw	a0,-60(s0)
    800050b0:	08054c63          	bltz	a0,80005148 <sys_pipe+0xea>
    800050b4:	fc843503          	ld	a0,-56(s0)
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	4f4080e7          	jalr	1268(ra) # 800045ac <fdalloc>
    800050c0:	fca42023          	sw	a0,-64(s0)
    800050c4:	06054863          	bltz	a0,80005134 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050c8:	4691                	li	a3,4
    800050ca:	fc440613          	addi	a2,s0,-60
    800050ce:	fd843583          	ld	a1,-40(s0)
    800050d2:	68a8                	ld	a0,80(s1)
    800050d4:	ffffc097          	auipc	ra,0xffffc
    800050d8:	a88080e7          	jalr	-1400(ra) # 80000b5c <copyout>
    800050dc:	02054063          	bltz	a0,800050fc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050e0:	4691                	li	a3,4
    800050e2:	fc040613          	addi	a2,s0,-64
    800050e6:	fd843583          	ld	a1,-40(s0)
    800050ea:	0591                	addi	a1,a1,4
    800050ec:	68a8                	ld	a0,80(s1)
    800050ee:	ffffc097          	auipc	ra,0xffffc
    800050f2:	a6e080e7          	jalr	-1426(ra) # 80000b5c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050f6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050f8:	06055563          	bgez	a0,80005162 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050fc:	fc442783          	lw	a5,-60(s0)
    80005100:	07e9                	addi	a5,a5,26
    80005102:	078e                	slli	a5,a5,0x3
    80005104:	97a6                	add	a5,a5,s1
    80005106:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000510a:	fc042503          	lw	a0,-64(s0)
    8000510e:	0569                	addi	a0,a0,26
    80005110:	050e                	slli	a0,a0,0x3
    80005112:	9526                	add	a0,a0,s1
    80005114:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005118:	fd043503          	ld	a0,-48(s0)
    8000511c:	fffff097          	auipc	ra,0xfffff
    80005120:	a26080e7          	jalr	-1498(ra) # 80003b42 <fileclose>
    fileclose(wf);
    80005124:	fc843503          	ld	a0,-56(s0)
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	a1a080e7          	jalr	-1510(ra) # 80003b42 <fileclose>
    return -1;
    80005130:	57fd                	li	a5,-1
    80005132:	a805                	j	80005162 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005134:	fc442783          	lw	a5,-60(s0)
    80005138:	0007c863          	bltz	a5,80005148 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000513c:	01a78513          	addi	a0,a5,26
    80005140:	050e                	slli	a0,a0,0x3
    80005142:	9526                	add	a0,a0,s1
    80005144:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005148:	fd043503          	ld	a0,-48(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	9f6080e7          	jalr	-1546(ra) # 80003b42 <fileclose>
    fileclose(wf);
    80005154:	fc843503          	ld	a0,-56(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	9ea080e7          	jalr	-1558(ra) # 80003b42 <fileclose>
    return -1;
    80005160:	57fd                	li	a5,-1
}
    80005162:	853e                	mv	a0,a5
    80005164:	70e2                	ld	ra,56(sp)
    80005166:	7442                	ld	s0,48(sp)
    80005168:	74a2                	ld	s1,40(sp)
    8000516a:	6121                	addi	sp,sp,64
    8000516c:	8082                	ret
	...

0000000080005170 <kernelvec>:
    80005170:	7111                	addi	sp,sp,-256
    80005172:	e006                	sd	ra,0(sp)
    80005174:	e40a                	sd	sp,8(sp)
    80005176:	e80e                	sd	gp,16(sp)
    80005178:	ec12                	sd	tp,24(sp)
    8000517a:	f016                	sd	t0,32(sp)
    8000517c:	f41a                	sd	t1,40(sp)
    8000517e:	f81e                	sd	t2,48(sp)
    80005180:	fc22                	sd	s0,56(sp)
    80005182:	e0a6                	sd	s1,64(sp)
    80005184:	e4aa                	sd	a0,72(sp)
    80005186:	e8ae                	sd	a1,80(sp)
    80005188:	ecb2                	sd	a2,88(sp)
    8000518a:	f0b6                	sd	a3,96(sp)
    8000518c:	f4ba                	sd	a4,104(sp)
    8000518e:	f8be                	sd	a5,112(sp)
    80005190:	fcc2                	sd	a6,120(sp)
    80005192:	e146                	sd	a7,128(sp)
    80005194:	e54a                	sd	s2,136(sp)
    80005196:	e94e                	sd	s3,144(sp)
    80005198:	ed52                	sd	s4,152(sp)
    8000519a:	f156                	sd	s5,160(sp)
    8000519c:	f55a                	sd	s6,168(sp)
    8000519e:	f95e                	sd	s7,176(sp)
    800051a0:	fd62                	sd	s8,184(sp)
    800051a2:	e1e6                	sd	s9,192(sp)
    800051a4:	e5ea                	sd	s10,200(sp)
    800051a6:	e9ee                	sd	s11,208(sp)
    800051a8:	edf2                	sd	t3,216(sp)
    800051aa:	f1f6                	sd	t4,224(sp)
    800051ac:	f5fa                	sd	t5,232(sp)
    800051ae:	f9fe                	sd	t6,240(sp)
    800051b0:	d03fc0ef          	jal	ra,80001eb2 <kerneltrap>
    800051b4:	6082                	ld	ra,0(sp)
    800051b6:	6122                	ld	sp,8(sp)
    800051b8:	61c2                	ld	gp,16(sp)
    800051ba:	7282                	ld	t0,32(sp)
    800051bc:	7322                	ld	t1,40(sp)
    800051be:	73c2                	ld	t2,48(sp)
    800051c0:	7462                	ld	s0,56(sp)
    800051c2:	6486                	ld	s1,64(sp)
    800051c4:	6526                	ld	a0,72(sp)
    800051c6:	65c6                	ld	a1,80(sp)
    800051c8:	6666                	ld	a2,88(sp)
    800051ca:	7686                	ld	a3,96(sp)
    800051cc:	7726                	ld	a4,104(sp)
    800051ce:	77c6                	ld	a5,112(sp)
    800051d0:	7866                	ld	a6,120(sp)
    800051d2:	688a                	ld	a7,128(sp)
    800051d4:	692a                	ld	s2,136(sp)
    800051d6:	69ca                	ld	s3,144(sp)
    800051d8:	6a6a                	ld	s4,152(sp)
    800051da:	7a8a                	ld	s5,160(sp)
    800051dc:	7b2a                	ld	s6,168(sp)
    800051de:	7bca                	ld	s7,176(sp)
    800051e0:	7c6a                	ld	s8,184(sp)
    800051e2:	6c8e                	ld	s9,192(sp)
    800051e4:	6d2e                	ld	s10,200(sp)
    800051e6:	6dce                	ld	s11,208(sp)
    800051e8:	6e6e                	ld	t3,216(sp)
    800051ea:	7e8e                	ld	t4,224(sp)
    800051ec:	7f2e                	ld	t5,232(sp)
    800051ee:	7fce                	ld	t6,240(sp)
    800051f0:	6111                	addi	sp,sp,256
    800051f2:	10200073          	sret
    800051f6:	00000013          	nop
    800051fa:	00000013          	nop
    800051fe:	0001                	nop

0000000080005200 <timervec>:
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	e10c                	sd	a1,0(a0)
    80005206:	e510                	sd	a2,8(a0)
    80005208:	e914                	sd	a3,16(a0)
    8000520a:	6d0c                	ld	a1,24(a0)
    8000520c:	7110                	ld	a2,32(a0)
    8000520e:	6194                	ld	a3,0(a1)
    80005210:	96b2                	add	a3,a3,a2
    80005212:	e194                	sd	a3,0(a1)
    80005214:	4589                	li	a1,2
    80005216:	14459073          	csrw	sip,a1
    8000521a:	6914                	ld	a3,16(a0)
    8000521c:	6510                	ld	a2,8(a0)
    8000521e:	610c                	ld	a1,0(a0)
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	30200073          	mret
	...

000000008000522a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000522a:	1141                	addi	sp,sp,-16
    8000522c:	e422                	sd	s0,8(sp)
    8000522e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005230:	0c0007b7          	lui	a5,0xc000
    80005234:	4705                	li	a4,1
    80005236:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005238:	c3d8                	sw	a4,4(a5)
}
    8000523a:	6422                	ld	s0,8(sp)
    8000523c:	0141                	addi	sp,sp,16
    8000523e:	8082                	ret

0000000080005240 <plicinithart>:

void
plicinithart(void)
{
    80005240:	1141                	addi	sp,sp,-16
    80005242:	e406                	sd	ra,8(sp)
    80005244:	e022                	sd	s0,0(sp)
    80005246:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	d22080e7          	jalr	-734(ra) # 80000f6a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005250:	0085171b          	slliw	a4,a0,0x8
    80005254:	0c0027b7          	lui	a5,0xc002
    80005258:	97ba                	add	a5,a5,a4
    8000525a:	40200713          	li	a4,1026
    8000525e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005262:	00d5151b          	slliw	a0,a0,0xd
    80005266:	0c2017b7          	lui	a5,0xc201
    8000526a:	953e                	add	a0,a0,a5
    8000526c:	00052023          	sw	zero,0(a0)
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret

0000000080005278 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	cea080e7          	jalr	-790(ra) # 80000f6a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005288:	00d5179b          	slliw	a5,a0,0xd
    8000528c:	0c201537          	lui	a0,0xc201
    80005290:	953e                	add	a0,a0,a5
  return irq;
}
    80005292:	4148                	lw	a0,4(a0)
    80005294:	60a2                	ld	ra,8(sp)
    80005296:	6402                	ld	s0,0(sp)
    80005298:	0141                	addi	sp,sp,16
    8000529a:	8082                	ret

000000008000529c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000529c:	1101                	addi	sp,sp,-32
    8000529e:	ec06                	sd	ra,24(sp)
    800052a0:	e822                	sd	s0,16(sp)
    800052a2:	e426                	sd	s1,8(sp)
    800052a4:	1000                	addi	s0,sp,32
    800052a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	cc2080e7          	jalr	-830(ra) # 80000f6a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052b0:	00d5151b          	slliw	a0,a0,0xd
    800052b4:	0c2017b7          	lui	a5,0xc201
    800052b8:	97aa                	add	a5,a5,a0
    800052ba:	c3c4                	sw	s1,4(a5)
}
    800052bc:	60e2                	ld	ra,24(sp)
    800052be:	6442                	ld	s0,16(sp)
    800052c0:	64a2                	ld	s1,8(sp)
    800052c2:	6105                	addi	sp,sp,32
    800052c4:	8082                	ret

00000000800052c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052c6:	1141                	addi	sp,sp,-16
    800052c8:	e406                	sd	ra,8(sp)
    800052ca:	e022                	sd	s0,0(sp)
    800052cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ce:	479d                	li	a5,7
    800052d0:	06a7c963          	blt	a5,a0,80005342 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052d4:	00016797          	auipc	a5,0x16
    800052d8:	d2c78793          	addi	a5,a5,-724 # 8001b000 <disk>
    800052dc:	00a78733          	add	a4,a5,a0
    800052e0:	6789                	lui	a5,0x2
    800052e2:	97ba                	add	a5,a5,a4
    800052e4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052e8:	e7ad                	bnez	a5,80005352 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052ea:	00451793          	slli	a5,a0,0x4
    800052ee:	00018717          	auipc	a4,0x18
    800052f2:	d1270713          	addi	a4,a4,-750 # 8001d000 <disk+0x2000>
    800052f6:	6314                	ld	a3,0(a4)
    800052f8:	96be                	add	a3,a3,a5
    800052fa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052fe:	6314                	ld	a3,0(a4)
    80005300:	96be                	add	a3,a3,a5
    80005302:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005306:	6314                	ld	a3,0(a4)
    80005308:	96be                	add	a3,a3,a5
    8000530a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000530e:	6318                	ld	a4,0(a4)
    80005310:	97ba                	add	a5,a5,a4
    80005312:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005316:	00016797          	auipc	a5,0x16
    8000531a:	cea78793          	addi	a5,a5,-790 # 8001b000 <disk>
    8000531e:	97aa                	add	a5,a5,a0
    80005320:	6509                	lui	a0,0x2
    80005322:	953e                	add	a0,a0,a5
    80005324:	4785                	li	a5,1
    80005326:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000532a:	00018517          	auipc	a0,0x18
    8000532e:	cee50513          	addi	a0,a0,-786 # 8001d018 <disk+0x2018>
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	4b4080e7          	jalr	1204(ra) # 800017e6 <wakeup>
}
    8000533a:	60a2                	ld	ra,8(sp)
    8000533c:	6402                	ld	s0,0(sp)
    8000533e:	0141                	addi	sp,sp,16
    80005340:	8082                	ret
    panic("free_desc 1");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	56e50513          	addi	a0,a0,1390 # 800088b0 <syscalls_name+0x320>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	a1e080e7          	jalr	-1506(ra) # 80005d68 <panic>
    panic("free_desc 2");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	56e50513          	addi	a0,a0,1390 # 800088c0 <syscalls_name+0x330>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	a0e080e7          	jalr	-1522(ra) # 80005d68 <panic>

0000000080005362 <virtio_disk_init>:
{
    80005362:	1101                	addi	sp,sp,-32
    80005364:	ec06                	sd	ra,24(sp)
    80005366:	e822                	sd	s0,16(sp)
    80005368:	e426                	sd	s1,8(sp)
    8000536a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000536c:	00003597          	auipc	a1,0x3
    80005370:	56458593          	addi	a1,a1,1380 # 800088d0 <syscalls_name+0x340>
    80005374:	00018517          	auipc	a0,0x18
    80005378:	db450513          	addi	a0,a0,-588 # 8001d128 <disk+0x2128>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	ea6080e7          	jalr	-346(ra) # 80006222 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	4398                	lw	a4,0(a5)
    8000538a:	2701                	sext.w	a4,a4
    8000538c:	747277b7          	lui	a5,0x74727
    80005390:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005394:	0ef71163          	bne	a4,a5,80005476 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005398:	100017b7          	lui	a5,0x10001
    8000539c:	43dc                	lw	a5,4(a5)
    8000539e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a0:	4705                	li	a4,1
    800053a2:	0ce79a63          	bne	a5,a4,80005476 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053a6:	100017b7          	lui	a5,0x10001
    800053aa:	479c                	lw	a5,8(a5)
    800053ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ae:	4709                	li	a4,2
    800053b0:	0ce79363          	bne	a5,a4,80005476 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053b4:	100017b7          	lui	a5,0x10001
    800053b8:	47d8                	lw	a4,12(a5)
    800053ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053bc:	554d47b7          	lui	a5,0x554d4
    800053c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053c4:	0af71963          	bne	a4,a5,80005476 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	4705                	li	a4,1
    800053ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d0:	470d                	li	a4,3
    800053d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053d4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053d6:	c7ffe737          	lui	a4,0xc7ffe
    800053da:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800053de:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053e0:	2701                	sext.w	a4,a4
    800053e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e4:	472d                	li	a4,11
    800053e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e8:	473d                	li	a4,15
    800053ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053ec:	6705                	lui	a4,0x1
    800053ee:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053f4:	5bdc                	lw	a5,52(a5)
    800053f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053f8:	c7d9                	beqz	a5,80005486 <virtio_disk_init+0x124>
  if(max < NUM)
    800053fa:	471d                	li	a4,7
    800053fc:	08f77d63          	bgeu	a4,a5,80005496 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005400:	100014b7          	lui	s1,0x10001
    80005404:	47a1                	li	a5,8
    80005406:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005408:	6609                	lui	a2,0x2
    8000540a:	4581                	li	a1,0
    8000540c:	00016517          	auipc	a0,0x16
    80005410:	bf450513          	addi	a0,a0,-1036 # 8001b000 <disk>
    80005414:	ffffb097          	auipc	ra,0xffffb
    80005418:	db6080e7          	jalr	-586(ra) # 800001ca <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000541c:	00016717          	auipc	a4,0x16
    80005420:	be470713          	addi	a4,a4,-1052 # 8001b000 <disk>
    80005424:	00c75793          	srli	a5,a4,0xc
    80005428:	2781                	sext.w	a5,a5
    8000542a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000542c:	00018797          	auipc	a5,0x18
    80005430:	bd478793          	addi	a5,a5,-1068 # 8001d000 <disk+0x2000>
    80005434:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005436:	00016717          	auipc	a4,0x16
    8000543a:	c4a70713          	addi	a4,a4,-950 # 8001b080 <disk+0x80>
    8000543e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005440:	00017717          	auipc	a4,0x17
    80005444:	bc070713          	addi	a4,a4,-1088 # 8001c000 <disk+0x1000>
    80005448:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000544a:	4705                	li	a4,1
    8000544c:	00e78c23          	sb	a4,24(a5)
    80005450:	00e78ca3          	sb	a4,25(a5)
    80005454:	00e78d23          	sb	a4,26(a5)
    80005458:	00e78da3          	sb	a4,27(a5)
    8000545c:	00e78e23          	sb	a4,28(a5)
    80005460:	00e78ea3          	sb	a4,29(a5)
    80005464:	00e78f23          	sb	a4,30(a5)
    80005468:	00e78fa3          	sb	a4,31(a5)
}
    8000546c:	60e2                	ld	ra,24(sp)
    8000546e:	6442                	ld	s0,16(sp)
    80005470:	64a2                	ld	s1,8(sp)
    80005472:	6105                	addi	sp,sp,32
    80005474:	8082                	ret
    panic("could not find virtio disk");
    80005476:	00003517          	auipc	a0,0x3
    8000547a:	46a50513          	addi	a0,a0,1130 # 800088e0 <syscalls_name+0x350>
    8000547e:	00001097          	auipc	ra,0x1
    80005482:	8ea080e7          	jalr	-1814(ra) # 80005d68 <panic>
    panic("virtio disk has no queue 0");
    80005486:	00003517          	auipc	a0,0x3
    8000548a:	47a50513          	addi	a0,a0,1146 # 80008900 <syscalls_name+0x370>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	8da080e7          	jalr	-1830(ra) # 80005d68 <panic>
    panic("virtio disk max queue too short");
    80005496:	00003517          	auipc	a0,0x3
    8000549a:	48a50513          	addi	a0,a0,1162 # 80008920 <syscalls_name+0x390>
    8000549e:	00001097          	auipc	ra,0x1
    800054a2:	8ca080e7          	jalr	-1846(ra) # 80005d68 <panic>

00000000800054a6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054a6:	7159                	addi	sp,sp,-112
    800054a8:	f486                	sd	ra,104(sp)
    800054aa:	f0a2                	sd	s0,96(sp)
    800054ac:	eca6                	sd	s1,88(sp)
    800054ae:	e8ca                	sd	s2,80(sp)
    800054b0:	e4ce                	sd	s3,72(sp)
    800054b2:	e0d2                	sd	s4,64(sp)
    800054b4:	fc56                	sd	s5,56(sp)
    800054b6:	f85a                	sd	s6,48(sp)
    800054b8:	f45e                	sd	s7,40(sp)
    800054ba:	f062                	sd	s8,32(sp)
    800054bc:	ec66                	sd	s9,24(sp)
    800054be:	e86a                	sd	s10,16(sp)
    800054c0:	1880                	addi	s0,sp,112
    800054c2:	892a                	mv	s2,a0
    800054c4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054c6:	00c52c83          	lw	s9,12(a0)
    800054ca:	001c9c9b          	slliw	s9,s9,0x1
    800054ce:	1c82                	slli	s9,s9,0x20
    800054d0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054d4:	00018517          	auipc	a0,0x18
    800054d8:	c5450513          	addi	a0,a0,-940 # 8001d128 <disk+0x2128>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	dd6080e7          	jalr	-554(ra) # 800062b2 <acquire>
  for(int i = 0; i < 3; i++){
    800054e4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054e6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054e8:	00016b97          	auipc	s7,0x16
    800054ec:	b18b8b93          	addi	s7,s7,-1256 # 8001b000 <disk>
    800054f0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054f2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054f4:	8a4e                	mv	s4,s3
    800054f6:	a051                	j	8000557a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054f8:	00fb86b3          	add	a3,s7,a5
    800054fc:	96da                	add	a3,a3,s6
    800054fe:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005502:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005504:	0207c563          	bltz	a5,8000552e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005508:	2485                	addiw	s1,s1,1
    8000550a:	0711                	addi	a4,a4,4
    8000550c:	25548063          	beq	s1,s5,8000574c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005510:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005512:	00018697          	auipc	a3,0x18
    80005516:	b0668693          	addi	a3,a3,-1274 # 8001d018 <disk+0x2018>
    8000551a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000551c:	0006c583          	lbu	a1,0(a3)
    80005520:	fde1                	bnez	a1,800054f8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005522:	2785                	addiw	a5,a5,1
    80005524:	0685                	addi	a3,a3,1
    80005526:	ff879be3          	bne	a5,s8,8000551c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000552a:	57fd                	li	a5,-1
    8000552c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000552e:	02905a63          	blez	s1,80005562 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005532:	f9042503          	lw	a0,-112(s0)
    80005536:	00000097          	auipc	ra,0x0
    8000553a:	d90080e7          	jalr	-624(ra) # 800052c6 <free_desc>
      for(int j = 0; j < i; j++)
    8000553e:	4785                	li	a5,1
    80005540:	0297d163          	bge	a5,s1,80005562 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005544:	f9442503          	lw	a0,-108(s0)
    80005548:	00000097          	auipc	ra,0x0
    8000554c:	d7e080e7          	jalr	-642(ra) # 800052c6 <free_desc>
      for(int j = 0; j < i; j++)
    80005550:	4789                	li	a5,2
    80005552:	0097d863          	bge	a5,s1,80005562 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005556:	f9842503          	lw	a0,-104(s0)
    8000555a:	00000097          	auipc	ra,0x0
    8000555e:	d6c080e7          	jalr	-660(ra) # 800052c6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005562:	00018597          	auipc	a1,0x18
    80005566:	bc658593          	addi	a1,a1,-1082 # 8001d128 <disk+0x2128>
    8000556a:	00018517          	auipc	a0,0x18
    8000556e:	aae50513          	addi	a0,a0,-1362 # 8001d018 <disk+0x2018>
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	0e8080e7          	jalr	232(ra) # 8000165a <sleep>
  for(int i = 0; i < 3; i++){
    8000557a:	f9040713          	addi	a4,s0,-112
    8000557e:	84ce                	mv	s1,s3
    80005580:	bf41                	j	80005510 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005582:	20058713          	addi	a4,a1,512
    80005586:	00471693          	slli	a3,a4,0x4
    8000558a:	00016717          	auipc	a4,0x16
    8000558e:	a7670713          	addi	a4,a4,-1418 # 8001b000 <disk>
    80005592:	9736                	add	a4,a4,a3
    80005594:	4685                	li	a3,1
    80005596:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000559a:	20058713          	addi	a4,a1,512
    8000559e:	00471693          	slli	a3,a4,0x4
    800055a2:	00016717          	auipc	a4,0x16
    800055a6:	a5e70713          	addi	a4,a4,-1442 # 8001b000 <disk>
    800055aa:	9736                	add	a4,a4,a3
    800055ac:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055b0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055b4:	7679                	lui	a2,0xffffe
    800055b6:	963e                	add	a2,a2,a5
    800055b8:	00018697          	auipc	a3,0x18
    800055bc:	a4868693          	addi	a3,a3,-1464 # 8001d000 <disk+0x2000>
    800055c0:	6298                	ld	a4,0(a3)
    800055c2:	9732                	add	a4,a4,a2
    800055c4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055c6:	6298                	ld	a4,0(a3)
    800055c8:	9732                	add	a4,a4,a2
    800055ca:	4541                	li	a0,16
    800055cc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ce:	6298                	ld	a4,0(a3)
    800055d0:	9732                	add	a4,a4,a2
    800055d2:	4505                	li	a0,1
    800055d4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055d8:	f9442703          	lw	a4,-108(s0)
    800055dc:	6288                	ld	a0,0(a3)
    800055de:	962a                	add	a2,a2,a0
    800055e0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055e4:	0712                	slli	a4,a4,0x4
    800055e6:	6290                	ld	a2,0(a3)
    800055e8:	963a                	add	a2,a2,a4
    800055ea:	05890513          	addi	a0,s2,88
    800055ee:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055f0:	6294                	ld	a3,0(a3)
    800055f2:	96ba                	add	a3,a3,a4
    800055f4:	40000613          	li	a2,1024
    800055f8:	c690                	sw	a2,8(a3)
  if(write)
    800055fa:	140d0063          	beqz	s10,8000573a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055fe:	00018697          	auipc	a3,0x18
    80005602:	a026b683          	ld	a3,-1534(a3) # 8001d000 <disk+0x2000>
    80005606:	96ba                	add	a3,a3,a4
    80005608:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000560c:	00016817          	auipc	a6,0x16
    80005610:	9f480813          	addi	a6,a6,-1548 # 8001b000 <disk>
    80005614:	00018517          	auipc	a0,0x18
    80005618:	9ec50513          	addi	a0,a0,-1556 # 8001d000 <disk+0x2000>
    8000561c:	6114                	ld	a3,0(a0)
    8000561e:	96ba                	add	a3,a3,a4
    80005620:	00c6d603          	lhu	a2,12(a3)
    80005624:	00166613          	ori	a2,a2,1
    80005628:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000562c:	f9842683          	lw	a3,-104(s0)
    80005630:	6110                	ld	a2,0(a0)
    80005632:	9732                	add	a4,a4,a2
    80005634:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005638:	20058613          	addi	a2,a1,512
    8000563c:	0612                	slli	a2,a2,0x4
    8000563e:	9642                	add	a2,a2,a6
    80005640:	577d                	li	a4,-1
    80005642:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005646:	00469713          	slli	a4,a3,0x4
    8000564a:	6114                	ld	a3,0(a0)
    8000564c:	96ba                	add	a3,a3,a4
    8000564e:	03078793          	addi	a5,a5,48
    80005652:	97c2                	add	a5,a5,a6
    80005654:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005656:	611c                	ld	a5,0(a0)
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	4685                	li	a3,1
    8000565c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000565e:	611c                	ld	a5,0(a0)
    80005660:	97ba                	add	a5,a5,a4
    80005662:	4809                	li	a6,2
    80005664:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005668:	611c                	ld	a5,0(a0)
    8000566a:	973e                	add	a4,a4,a5
    8000566c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005670:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005674:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005678:	6518                	ld	a4,8(a0)
    8000567a:	00275783          	lhu	a5,2(a4)
    8000567e:	8b9d                	andi	a5,a5,7
    80005680:	0786                	slli	a5,a5,0x1
    80005682:	97ba                	add	a5,a5,a4
    80005684:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005688:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000568c:	6518                	ld	a4,8(a0)
    8000568e:	00275783          	lhu	a5,2(a4)
    80005692:	2785                	addiw	a5,a5,1
    80005694:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005698:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000569c:	100017b7          	lui	a5,0x10001
    800056a0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056a4:	00492703          	lw	a4,4(s2)
    800056a8:	4785                	li	a5,1
    800056aa:	02f71163          	bne	a4,a5,800056cc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056ae:	00018997          	auipc	s3,0x18
    800056b2:	a7a98993          	addi	s3,s3,-1414 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056b6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056b8:	85ce                	mv	a1,s3
    800056ba:	854a                	mv	a0,s2
    800056bc:	ffffc097          	auipc	ra,0xffffc
    800056c0:	f9e080e7          	jalr	-98(ra) # 8000165a <sleep>
  while(b->disk == 1) {
    800056c4:	00492783          	lw	a5,4(s2)
    800056c8:	fe9788e3          	beq	a5,s1,800056b8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056cc:	f9042903          	lw	s2,-112(s0)
    800056d0:	20090793          	addi	a5,s2,512
    800056d4:	00479713          	slli	a4,a5,0x4
    800056d8:	00016797          	auipc	a5,0x16
    800056dc:	92878793          	addi	a5,a5,-1752 # 8001b000 <disk>
    800056e0:	97ba                	add	a5,a5,a4
    800056e2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056e6:	00018997          	auipc	s3,0x18
    800056ea:	91a98993          	addi	s3,s3,-1766 # 8001d000 <disk+0x2000>
    800056ee:	00491713          	slli	a4,s2,0x4
    800056f2:	0009b783          	ld	a5,0(s3)
    800056f6:	97ba                	add	a5,a5,a4
    800056f8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056fc:	854a                	mv	a0,s2
    800056fe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005702:	00000097          	auipc	ra,0x0
    80005706:	bc4080e7          	jalr	-1084(ra) # 800052c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000570a:	8885                	andi	s1,s1,1
    8000570c:	f0ed                	bnez	s1,800056ee <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000570e:	00018517          	auipc	a0,0x18
    80005712:	a1a50513          	addi	a0,a0,-1510 # 8001d128 <disk+0x2128>
    80005716:	00001097          	auipc	ra,0x1
    8000571a:	c50080e7          	jalr	-944(ra) # 80006366 <release>
}
    8000571e:	70a6                	ld	ra,104(sp)
    80005720:	7406                	ld	s0,96(sp)
    80005722:	64e6                	ld	s1,88(sp)
    80005724:	6946                	ld	s2,80(sp)
    80005726:	69a6                	ld	s3,72(sp)
    80005728:	6a06                	ld	s4,64(sp)
    8000572a:	7ae2                	ld	s5,56(sp)
    8000572c:	7b42                	ld	s6,48(sp)
    8000572e:	7ba2                	ld	s7,40(sp)
    80005730:	7c02                	ld	s8,32(sp)
    80005732:	6ce2                	ld	s9,24(sp)
    80005734:	6d42                	ld	s10,16(sp)
    80005736:	6165                	addi	sp,sp,112
    80005738:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000573a:	00018697          	auipc	a3,0x18
    8000573e:	8c66b683          	ld	a3,-1850(a3) # 8001d000 <disk+0x2000>
    80005742:	96ba                	add	a3,a3,a4
    80005744:	4609                	li	a2,2
    80005746:	00c69623          	sh	a2,12(a3)
    8000574a:	b5c9                	j	8000560c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000574c:	f9042583          	lw	a1,-112(s0)
    80005750:	20058793          	addi	a5,a1,512
    80005754:	0792                	slli	a5,a5,0x4
    80005756:	00016517          	auipc	a0,0x16
    8000575a:	95250513          	addi	a0,a0,-1710 # 8001b0a8 <disk+0xa8>
    8000575e:	953e                	add	a0,a0,a5
  if(write)
    80005760:	e20d11e3          	bnez	s10,80005582 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005764:	20058713          	addi	a4,a1,512
    80005768:	00471693          	slli	a3,a4,0x4
    8000576c:	00016717          	auipc	a4,0x16
    80005770:	89470713          	addi	a4,a4,-1900 # 8001b000 <disk>
    80005774:	9736                	add	a4,a4,a3
    80005776:	0a072423          	sw	zero,168(a4)
    8000577a:	b505                	j	8000559a <virtio_disk_rw+0xf4>

000000008000577c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000577c:	1101                	addi	sp,sp,-32
    8000577e:	ec06                	sd	ra,24(sp)
    80005780:	e822                	sd	s0,16(sp)
    80005782:	e426                	sd	s1,8(sp)
    80005784:	e04a                	sd	s2,0(sp)
    80005786:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005788:	00018517          	auipc	a0,0x18
    8000578c:	9a050513          	addi	a0,a0,-1632 # 8001d128 <disk+0x2128>
    80005790:	00001097          	auipc	ra,0x1
    80005794:	b22080e7          	jalr	-1246(ra) # 800062b2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005798:	10001737          	lui	a4,0x10001
    8000579c:	533c                	lw	a5,96(a4)
    8000579e:	8b8d                	andi	a5,a5,3
    800057a0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057a2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057a6:	00018797          	auipc	a5,0x18
    800057aa:	85a78793          	addi	a5,a5,-1958 # 8001d000 <disk+0x2000>
    800057ae:	6b94                	ld	a3,16(a5)
    800057b0:	0207d703          	lhu	a4,32(a5)
    800057b4:	0026d783          	lhu	a5,2(a3)
    800057b8:	06f70163          	beq	a4,a5,8000581a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057bc:	00016917          	auipc	s2,0x16
    800057c0:	84490913          	addi	s2,s2,-1980 # 8001b000 <disk>
    800057c4:	00018497          	auipc	s1,0x18
    800057c8:	83c48493          	addi	s1,s1,-1988 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057cc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d0:	6898                	ld	a4,16(s1)
    800057d2:	0204d783          	lhu	a5,32(s1)
    800057d6:	8b9d                	andi	a5,a5,7
    800057d8:	078e                	slli	a5,a5,0x3
    800057da:	97ba                	add	a5,a5,a4
    800057dc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057de:	20078713          	addi	a4,a5,512
    800057e2:	0712                	slli	a4,a4,0x4
    800057e4:	974a                	add	a4,a4,s2
    800057e6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057ea:	e731                	bnez	a4,80005836 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057ec:	20078793          	addi	a5,a5,512
    800057f0:	0792                	slli	a5,a5,0x4
    800057f2:	97ca                	add	a5,a5,s2
    800057f4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057f6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057fa:	ffffc097          	auipc	ra,0xffffc
    800057fe:	fec080e7          	jalr	-20(ra) # 800017e6 <wakeup>

    disk.used_idx += 1;
    80005802:	0204d783          	lhu	a5,32(s1)
    80005806:	2785                	addiw	a5,a5,1
    80005808:	17c2                	slli	a5,a5,0x30
    8000580a:	93c1                	srli	a5,a5,0x30
    8000580c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005810:	6898                	ld	a4,16(s1)
    80005812:	00275703          	lhu	a4,2(a4)
    80005816:	faf71be3          	bne	a4,a5,800057cc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000581a:	00018517          	auipc	a0,0x18
    8000581e:	90e50513          	addi	a0,a0,-1778 # 8001d128 <disk+0x2128>
    80005822:	00001097          	auipc	ra,0x1
    80005826:	b44080e7          	jalr	-1212(ra) # 80006366 <release>
}
    8000582a:	60e2                	ld	ra,24(sp)
    8000582c:	6442                	ld	s0,16(sp)
    8000582e:	64a2                	ld	s1,8(sp)
    80005830:	6902                	ld	s2,0(sp)
    80005832:	6105                	addi	sp,sp,32
    80005834:	8082                	ret
      panic("virtio_disk_intr status");
    80005836:	00003517          	auipc	a0,0x3
    8000583a:	10a50513          	addi	a0,a0,266 # 80008940 <syscalls_name+0x3b0>
    8000583e:	00000097          	auipc	ra,0x0
    80005842:	52a080e7          	jalr	1322(ra) # 80005d68 <panic>

0000000080005846 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005846:	1141                	addi	sp,sp,-16
    80005848:	e422                	sd	s0,8(sp)
    8000584a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000584c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005850:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005854:	0037979b          	slliw	a5,a5,0x3
    80005858:	02004737          	lui	a4,0x2004
    8000585c:	97ba                	add	a5,a5,a4
    8000585e:	0200c737          	lui	a4,0x200c
    80005862:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005866:	000f4637          	lui	a2,0xf4
    8000586a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000586e:	95b2                	add	a1,a1,a2
    80005870:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005872:	00269713          	slli	a4,a3,0x2
    80005876:	9736                	add	a4,a4,a3
    80005878:	00371693          	slli	a3,a4,0x3
    8000587c:	00018717          	auipc	a4,0x18
    80005880:	78470713          	addi	a4,a4,1924 # 8001e000 <timer_scratch>
    80005884:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005886:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005888:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000588a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000588e:	00000797          	auipc	a5,0x0
    80005892:	97278793          	addi	a5,a5,-1678 # 80005200 <timervec>
    80005896:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000589a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000589e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058a6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058aa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058ae:	30479073          	csrw	mie,a5
}
    800058b2:	6422                	ld	s0,8(sp)
    800058b4:	0141                	addi	sp,sp,16
    800058b6:	8082                	ret

00000000800058b8 <start>:
{
    800058b8:	1141                	addi	sp,sp,-16
    800058ba:	e406                	sd	ra,8(sp)
    800058bc:	e022                	sd	s0,0(sp)
    800058be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058c4:	7779                	lui	a4,0xffffe
    800058c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058cc:	6705                	lui	a4,0x1
    800058ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058d8:	ffffb797          	auipc	a5,0xffffb
    800058dc:	aa078793          	addi	a5,a5,-1376 # 80000378 <main>
    800058e0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058e4:	4781                	li	a5,0
    800058e6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ea:	67c1                	lui	a5,0x10
    800058ec:	17fd                	addi	a5,a5,-1
    800058ee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058fe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005902:	57fd                	li	a5,-1
    80005904:	83a9                	srli	a5,a5,0xa
    80005906:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000590a:	47bd                	li	a5,15
    8000590c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005910:	00000097          	auipc	ra,0x0
    80005914:	f36080e7          	jalr	-202(ra) # 80005846 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005918:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000591c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000591e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005920:	30200073          	mret
}
    80005924:	60a2                	ld	ra,8(sp)
    80005926:	6402                	ld	s0,0(sp)
    80005928:	0141                	addi	sp,sp,16
    8000592a:	8082                	ret

000000008000592c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000592c:	715d                	addi	sp,sp,-80
    8000592e:	e486                	sd	ra,72(sp)
    80005930:	e0a2                	sd	s0,64(sp)
    80005932:	fc26                	sd	s1,56(sp)
    80005934:	f84a                	sd	s2,48(sp)
    80005936:	f44e                	sd	s3,40(sp)
    80005938:	f052                	sd	s4,32(sp)
    8000593a:	ec56                	sd	s5,24(sp)
    8000593c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000593e:	04c05663          	blez	a2,8000598a <consolewrite+0x5e>
    80005942:	8a2a                	mv	s4,a0
    80005944:	84ae                	mv	s1,a1
    80005946:	89b2                	mv	s3,a2
    80005948:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000594a:	5afd                	li	s5,-1
    8000594c:	4685                	li	a3,1
    8000594e:	8626                	mv	a2,s1
    80005950:	85d2                	mv	a1,s4
    80005952:	fbf40513          	addi	a0,s0,-65
    80005956:	ffffc097          	auipc	ra,0xffffc
    8000595a:	0fe080e7          	jalr	254(ra) # 80001a54 <either_copyin>
    8000595e:	01550c63          	beq	a0,s5,80005976 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005962:	fbf44503          	lbu	a0,-65(s0)
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	78e080e7          	jalr	1934(ra) # 800060f4 <uartputc>
  for(i = 0; i < n; i++){
    8000596e:	2905                	addiw	s2,s2,1
    80005970:	0485                	addi	s1,s1,1
    80005972:	fd299de3          	bne	s3,s2,8000594c <consolewrite+0x20>
  }

  return i;
}
    80005976:	854a                	mv	a0,s2
    80005978:	60a6                	ld	ra,72(sp)
    8000597a:	6406                	ld	s0,64(sp)
    8000597c:	74e2                	ld	s1,56(sp)
    8000597e:	7942                	ld	s2,48(sp)
    80005980:	79a2                	ld	s3,40(sp)
    80005982:	7a02                	ld	s4,32(sp)
    80005984:	6ae2                	ld	s5,24(sp)
    80005986:	6161                	addi	sp,sp,80
    80005988:	8082                	ret
  for(i = 0; i < n; i++){
    8000598a:	4901                	li	s2,0
    8000598c:	b7ed                	j	80005976 <consolewrite+0x4a>

000000008000598e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000598e:	7119                	addi	sp,sp,-128
    80005990:	fc86                	sd	ra,120(sp)
    80005992:	f8a2                	sd	s0,112(sp)
    80005994:	f4a6                	sd	s1,104(sp)
    80005996:	f0ca                	sd	s2,96(sp)
    80005998:	ecce                	sd	s3,88(sp)
    8000599a:	e8d2                	sd	s4,80(sp)
    8000599c:	e4d6                	sd	s5,72(sp)
    8000599e:	e0da                	sd	s6,64(sp)
    800059a0:	fc5e                	sd	s7,56(sp)
    800059a2:	f862                	sd	s8,48(sp)
    800059a4:	f466                	sd	s9,40(sp)
    800059a6:	f06a                	sd	s10,32(sp)
    800059a8:	ec6e                	sd	s11,24(sp)
    800059aa:	0100                	addi	s0,sp,128
    800059ac:	8b2a                	mv	s6,a0
    800059ae:	8aae                	mv	s5,a1
    800059b0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059b2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059b6:	00020517          	auipc	a0,0x20
    800059ba:	78a50513          	addi	a0,a0,1930 # 80026140 <cons>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	8f4080e7          	jalr	-1804(ra) # 800062b2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059c6:	00020497          	auipc	s1,0x20
    800059ca:	77a48493          	addi	s1,s1,1914 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ce:	89a6                	mv	s3,s1
    800059d0:	00021917          	auipc	s2,0x21
    800059d4:	80890913          	addi	s2,s2,-2040 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059d8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059da:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059dc:	4da9                	li	s11,10
  while(n > 0){
    800059de:	07405863          	blez	s4,80005a4e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059e2:	0984a783          	lw	a5,152(s1)
    800059e6:	09c4a703          	lw	a4,156(s1)
    800059ea:	02f71463          	bne	a4,a5,80005a12 <consoleread+0x84>
      if(myproc()->killed){
    800059ee:	ffffb097          	auipc	ra,0xffffb
    800059f2:	5a8080e7          	jalr	1448(ra) # 80000f96 <myproc>
    800059f6:	551c                	lw	a5,40(a0)
    800059f8:	e7b5                	bnez	a5,80005a64 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059fa:	85ce                	mv	a1,s3
    800059fc:	854a                	mv	a0,s2
    800059fe:	ffffc097          	auipc	ra,0xffffc
    80005a02:	c5c080e7          	jalr	-932(ra) # 8000165a <sleep>
    while(cons.r == cons.w){
    80005a06:	0984a783          	lw	a5,152(s1)
    80005a0a:	09c4a703          	lw	a4,156(s1)
    80005a0e:	fef700e3          	beq	a4,a5,800059ee <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a12:	0017871b          	addiw	a4,a5,1
    80005a16:	08e4ac23          	sw	a4,152(s1)
    80005a1a:	07f7f713          	andi	a4,a5,127
    80005a1e:	9726                	add	a4,a4,s1
    80005a20:	01874703          	lbu	a4,24(a4)
    80005a24:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a28:	079c0663          	beq	s8,s9,80005a94 <consoleread+0x106>
    cbuf = c;
    80005a2c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a30:	4685                	li	a3,1
    80005a32:	f8f40613          	addi	a2,s0,-113
    80005a36:	85d6                	mv	a1,s5
    80005a38:	855a                	mv	a0,s6
    80005a3a:	ffffc097          	auipc	ra,0xffffc
    80005a3e:	fc4080e7          	jalr	-60(ra) # 800019fe <either_copyout>
    80005a42:	01a50663          	beq	a0,s10,80005a4e <consoleread+0xc0>
    dst++;
    80005a46:	0a85                	addi	s5,s5,1
    --n;
    80005a48:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a4a:	f9bc1ae3          	bne	s8,s11,800059de <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a4e:	00020517          	auipc	a0,0x20
    80005a52:	6f250513          	addi	a0,a0,1778 # 80026140 <cons>
    80005a56:	00001097          	auipc	ra,0x1
    80005a5a:	910080e7          	jalr	-1776(ra) # 80006366 <release>

  return target - n;
    80005a5e:	414b853b          	subw	a0,s7,s4
    80005a62:	a811                	j	80005a76 <consoleread+0xe8>
        release(&cons.lock);
    80005a64:	00020517          	auipc	a0,0x20
    80005a68:	6dc50513          	addi	a0,a0,1756 # 80026140 <cons>
    80005a6c:	00001097          	auipc	ra,0x1
    80005a70:	8fa080e7          	jalr	-1798(ra) # 80006366 <release>
        return -1;
    80005a74:	557d                	li	a0,-1
}
    80005a76:	70e6                	ld	ra,120(sp)
    80005a78:	7446                	ld	s0,112(sp)
    80005a7a:	74a6                	ld	s1,104(sp)
    80005a7c:	7906                	ld	s2,96(sp)
    80005a7e:	69e6                	ld	s3,88(sp)
    80005a80:	6a46                	ld	s4,80(sp)
    80005a82:	6aa6                	ld	s5,72(sp)
    80005a84:	6b06                	ld	s6,64(sp)
    80005a86:	7be2                	ld	s7,56(sp)
    80005a88:	7c42                	ld	s8,48(sp)
    80005a8a:	7ca2                	ld	s9,40(sp)
    80005a8c:	7d02                	ld	s10,32(sp)
    80005a8e:	6de2                	ld	s11,24(sp)
    80005a90:	6109                	addi	sp,sp,128
    80005a92:	8082                	ret
      if(n < target){
    80005a94:	000a071b          	sext.w	a4,s4
    80005a98:	fb777be3          	bgeu	a4,s7,80005a4e <consoleread+0xc0>
        cons.r--;
    80005a9c:	00020717          	auipc	a4,0x20
    80005aa0:	72f72e23          	sw	a5,1852(a4) # 800261d8 <cons+0x98>
    80005aa4:	b76d                	j	80005a4e <consoleread+0xc0>

0000000080005aa6 <consputc>:
{
    80005aa6:	1141                	addi	sp,sp,-16
    80005aa8:	e406                	sd	ra,8(sp)
    80005aaa:	e022                	sd	s0,0(sp)
    80005aac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aae:	10000793          	li	a5,256
    80005ab2:	00f50a63          	beq	a0,a5,80005ac6 <consputc+0x20>
    uartputc_sync(c);
    80005ab6:	00000097          	auipc	ra,0x0
    80005aba:	564080e7          	jalr	1380(ra) # 8000601a <uartputc_sync>
}
    80005abe:	60a2                	ld	ra,8(sp)
    80005ac0:	6402                	ld	s0,0(sp)
    80005ac2:	0141                	addi	sp,sp,16
    80005ac4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac6:	4521                	li	a0,8
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	552080e7          	jalr	1362(ra) # 8000601a <uartputc_sync>
    80005ad0:	02000513          	li	a0,32
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	546080e7          	jalr	1350(ra) # 8000601a <uartputc_sync>
    80005adc:	4521                	li	a0,8
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	53c080e7          	jalr	1340(ra) # 8000601a <uartputc_sync>
    80005ae6:	bfe1                	j	80005abe <consputc+0x18>

0000000080005ae8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ae8:	1101                	addi	sp,sp,-32
    80005aea:	ec06                	sd	ra,24(sp)
    80005aec:	e822                	sd	s0,16(sp)
    80005aee:	e426                	sd	s1,8(sp)
    80005af0:	e04a                	sd	s2,0(sp)
    80005af2:	1000                	addi	s0,sp,32
    80005af4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005af6:	00020517          	auipc	a0,0x20
    80005afa:	64a50513          	addi	a0,a0,1610 # 80026140 <cons>
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	7b4080e7          	jalr	1972(ra) # 800062b2 <acquire>

  switch(c){
    80005b06:	47d5                	li	a5,21
    80005b08:	0af48663          	beq	s1,a5,80005bb4 <consoleintr+0xcc>
    80005b0c:	0297ca63          	blt	a5,s1,80005b40 <consoleintr+0x58>
    80005b10:	47a1                	li	a5,8
    80005b12:	0ef48763          	beq	s1,a5,80005c00 <consoleintr+0x118>
    80005b16:	47c1                	li	a5,16
    80005b18:	10f49a63          	bne	s1,a5,80005c2c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b1c:	ffffc097          	auipc	ra,0xffffc
    80005b20:	f8e080e7          	jalr	-114(ra) # 80001aaa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b24:	00020517          	auipc	a0,0x20
    80005b28:	61c50513          	addi	a0,a0,1564 # 80026140 <cons>
    80005b2c:	00001097          	auipc	ra,0x1
    80005b30:	83a080e7          	jalr	-1990(ra) # 80006366 <release>
}
    80005b34:	60e2                	ld	ra,24(sp)
    80005b36:	6442                	ld	s0,16(sp)
    80005b38:	64a2                	ld	s1,8(sp)
    80005b3a:	6902                	ld	s2,0(sp)
    80005b3c:	6105                	addi	sp,sp,32
    80005b3e:	8082                	ret
  switch(c){
    80005b40:	07f00793          	li	a5,127
    80005b44:	0af48e63          	beq	s1,a5,80005c00 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b48:	00020717          	auipc	a4,0x20
    80005b4c:	5f870713          	addi	a4,a4,1528 # 80026140 <cons>
    80005b50:	0a072783          	lw	a5,160(a4)
    80005b54:	09872703          	lw	a4,152(a4)
    80005b58:	9f99                	subw	a5,a5,a4
    80005b5a:	07f00713          	li	a4,127
    80005b5e:	fcf763e3          	bltu	a4,a5,80005b24 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b62:	47b5                	li	a5,13
    80005b64:	0cf48763          	beq	s1,a5,80005c32 <consoleintr+0x14a>
      consputc(c);
    80005b68:	8526                	mv	a0,s1
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	f3c080e7          	jalr	-196(ra) # 80005aa6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b72:	00020797          	auipc	a5,0x20
    80005b76:	5ce78793          	addi	a5,a5,1486 # 80026140 <cons>
    80005b7a:	0a07a703          	lw	a4,160(a5)
    80005b7e:	0017069b          	addiw	a3,a4,1
    80005b82:	0006861b          	sext.w	a2,a3
    80005b86:	0ad7a023          	sw	a3,160(a5)
    80005b8a:	07f77713          	andi	a4,a4,127
    80005b8e:	97ba                	add	a5,a5,a4
    80005b90:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b94:	47a9                	li	a5,10
    80005b96:	0cf48563          	beq	s1,a5,80005c60 <consoleintr+0x178>
    80005b9a:	4791                	li	a5,4
    80005b9c:	0cf48263          	beq	s1,a5,80005c60 <consoleintr+0x178>
    80005ba0:	00020797          	auipc	a5,0x20
    80005ba4:	6387a783          	lw	a5,1592(a5) # 800261d8 <cons+0x98>
    80005ba8:	0807879b          	addiw	a5,a5,128
    80005bac:	f6f61ce3          	bne	a2,a5,80005b24 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bb0:	863e                	mv	a2,a5
    80005bb2:	a07d                	j	80005c60 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bb4:	00020717          	auipc	a4,0x20
    80005bb8:	58c70713          	addi	a4,a4,1420 # 80026140 <cons>
    80005bbc:	0a072783          	lw	a5,160(a4)
    80005bc0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bc4:	00020497          	auipc	s1,0x20
    80005bc8:	57c48493          	addi	s1,s1,1404 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bcc:	4929                	li	s2,10
    80005bce:	f4f70be3          	beq	a4,a5,80005b24 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bd2:	37fd                	addiw	a5,a5,-1
    80005bd4:	07f7f713          	andi	a4,a5,127
    80005bd8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bda:	01874703          	lbu	a4,24(a4)
    80005bde:	f52703e3          	beq	a4,s2,80005b24 <consoleintr+0x3c>
      cons.e--;
    80005be2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005be6:	10000513          	li	a0,256
    80005bea:	00000097          	auipc	ra,0x0
    80005bee:	ebc080e7          	jalr	-324(ra) # 80005aa6 <consputc>
    while(cons.e != cons.w &&
    80005bf2:	0a04a783          	lw	a5,160(s1)
    80005bf6:	09c4a703          	lw	a4,156(s1)
    80005bfa:	fcf71ce3          	bne	a4,a5,80005bd2 <consoleintr+0xea>
    80005bfe:	b71d                	j	80005b24 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c00:	00020717          	auipc	a4,0x20
    80005c04:	54070713          	addi	a4,a4,1344 # 80026140 <cons>
    80005c08:	0a072783          	lw	a5,160(a4)
    80005c0c:	09c72703          	lw	a4,156(a4)
    80005c10:	f0f70ae3          	beq	a4,a5,80005b24 <consoleintr+0x3c>
      cons.e--;
    80005c14:	37fd                	addiw	a5,a5,-1
    80005c16:	00020717          	auipc	a4,0x20
    80005c1a:	5cf72523          	sw	a5,1482(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c1e:	10000513          	li	a0,256
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	e84080e7          	jalr	-380(ra) # 80005aa6 <consputc>
    80005c2a:	bded                	j	80005b24 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c2c:	ee048ce3          	beqz	s1,80005b24 <consoleintr+0x3c>
    80005c30:	bf21                	j	80005b48 <consoleintr+0x60>
      consputc(c);
    80005c32:	4529                	li	a0,10
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	e72080e7          	jalr	-398(ra) # 80005aa6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c3c:	00020797          	auipc	a5,0x20
    80005c40:	50478793          	addi	a5,a5,1284 # 80026140 <cons>
    80005c44:	0a07a703          	lw	a4,160(a5)
    80005c48:	0017069b          	addiw	a3,a4,1
    80005c4c:	0006861b          	sext.w	a2,a3
    80005c50:	0ad7a023          	sw	a3,160(a5)
    80005c54:	07f77713          	andi	a4,a4,127
    80005c58:	97ba                	add	a5,a5,a4
    80005c5a:	4729                	li	a4,10
    80005c5c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c60:	00020797          	auipc	a5,0x20
    80005c64:	56c7ae23          	sw	a2,1404(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c68:	00020517          	auipc	a0,0x20
    80005c6c:	57050513          	addi	a0,a0,1392 # 800261d8 <cons+0x98>
    80005c70:	ffffc097          	auipc	ra,0xffffc
    80005c74:	b76080e7          	jalr	-1162(ra) # 800017e6 <wakeup>
    80005c78:	b575                	j	80005b24 <consoleintr+0x3c>

0000000080005c7a <consoleinit>:

void
consoleinit(void)
{
    80005c7a:	1141                	addi	sp,sp,-16
    80005c7c:	e406                	sd	ra,8(sp)
    80005c7e:	e022                	sd	s0,0(sp)
    80005c80:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c82:	00003597          	auipc	a1,0x3
    80005c86:	cd658593          	addi	a1,a1,-810 # 80008958 <syscalls_name+0x3c8>
    80005c8a:	00020517          	auipc	a0,0x20
    80005c8e:	4b650513          	addi	a0,a0,1206 # 80026140 <cons>
    80005c92:	00000097          	auipc	ra,0x0
    80005c96:	590080e7          	jalr	1424(ra) # 80006222 <initlock>

  uartinit();
    80005c9a:	00000097          	auipc	ra,0x0
    80005c9e:	330080e7          	jalr	816(ra) # 80005fca <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ca2:	00013797          	auipc	a5,0x13
    80005ca6:	42678793          	addi	a5,a5,1062 # 800190c8 <devsw>
    80005caa:	00000717          	auipc	a4,0x0
    80005cae:	ce470713          	addi	a4,a4,-796 # 8000598e <consoleread>
    80005cb2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cb4:	00000717          	auipc	a4,0x0
    80005cb8:	c7870713          	addi	a4,a4,-904 # 8000592c <consolewrite>
    80005cbc:	ef98                	sd	a4,24(a5)
}
    80005cbe:	60a2                	ld	ra,8(sp)
    80005cc0:	6402                	ld	s0,0(sp)
    80005cc2:	0141                	addi	sp,sp,16
    80005cc4:	8082                	ret

0000000080005cc6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cc6:	7179                	addi	sp,sp,-48
    80005cc8:	f406                	sd	ra,40(sp)
    80005cca:	f022                	sd	s0,32(sp)
    80005ccc:	ec26                	sd	s1,24(sp)
    80005cce:	e84a                	sd	s2,16(sp)
    80005cd0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cd2:	c219                	beqz	a2,80005cd8 <printint+0x12>
    80005cd4:	08054663          	bltz	a0,80005d60 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cd8:	2501                	sext.w	a0,a0
    80005cda:	4881                	li	a7,0
    80005cdc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ce0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ce2:	2581                	sext.w	a1,a1
    80005ce4:	00003617          	auipc	a2,0x3
    80005ce8:	ca460613          	addi	a2,a2,-860 # 80008988 <digits>
    80005cec:	883a                	mv	a6,a4
    80005cee:	2705                	addiw	a4,a4,1
    80005cf0:	02b577bb          	remuw	a5,a0,a1
    80005cf4:	1782                	slli	a5,a5,0x20
    80005cf6:	9381                	srli	a5,a5,0x20
    80005cf8:	97b2                	add	a5,a5,a2
    80005cfa:	0007c783          	lbu	a5,0(a5)
    80005cfe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d02:	0005079b          	sext.w	a5,a0
    80005d06:	02b5553b          	divuw	a0,a0,a1
    80005d0a:	0685                	addi	a3,a3,1
    80005d0c:	feb7f0e3          	bgeu	a5,a1,80005cec <printint+0x26>

  if(sign)
    80005d10:	00088b63          	beqz	a7,80005d26 <printint+0x60>
    buf[i++] = '-';
    80005d14:	fe040793          	addi	a5,s0,-32
    80005d18:	973e                	add	a4,a4,a5
    80005d1a:	02d00793          	li	a5,45
    80005d1e:	fef70823          	sb	a5,-16(a4)
    80005d22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d26:	02e05763          	blez	a4,80005d54 <printint+0x8e>
    80005d2a:	fd040793          	addi	a5,s0,-48
    80005d2e:	00e784b3          	add	s1,a5,a4
    80005d32:	fff78913          	addi	s2,a5,-1
    80005d36:	993a                	add	s2,s2,a4
    80005d38:	377d                	addiw	a4,a4,-1
    80005d3a:	1702                	slli	a4,a4,0x20
    80005d3c:	9301                	srli	a4,a4,0x20
    80005d3e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d42:	fff4c503          	lbu	a0,-1(s1)
    80005d46:	00000097          	auipc	ra,0x0
    80005d4a:	d60080e7          	jalr	-672(ra) # 80005aa6 <consputc>
  while(--i >= 0)
    80005d4e:	14fd                	addi	s1,s1,-1
    80005d50:	ff2499e3          	bne	s1,s2,80005d42 <printint+0x7c>
}
    80005d54:	70a2                	ld	ra,40(sp)
    80005d56:	7402                	ld	s0,32(sp)
    80005d58:	64e2                	ld	s1,24(sp)
    80005d5a:	6942                	ld	s2,16(sp)
    80005d5c:	6145                	addi	sp,sp,48
    80005d5e:	8082                	ret
    x = -xx;
    80005d60:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d64:	4885                	li	a7,1
    x = -xx;
    80005d66:	bf9d                	j	80005cdc <printint+0x16>

0000000080005d68 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d68:	1101                	addi	sp,sp,-32
    80005d6a:	ec06                	sd	ra,24(sp)
    80005d6c:	e822                	sd	s0,16(sp)
    80005d6e:	e426                	sd	s1,8(sp)
    80005d70:	1000                	addi	s0,sp,32
    80005d72:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d74:	00020797          	auipc	a5,0x20
    80005d78:	4807a623          	sw	zero,1164(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d7c:	00003517          	auipc	a0,0x3
    80005d80:	be450513          	addi	a0,a0,-1052 # 80008960 <syscalls_name+0x3d0>
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	02e080e7          	jalr	46(ra) # 80005db2 <printf>
  printf(s);
    80005d8c:	8526                	mv	a0,s1
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	024080e7          	jalr	36(ra) # 80005db2 <printf>
  printf("\n");
    80005d96:	00002517          	auipc	a0,0x2
    80005d9a:	2b250513          	addi	a0,a0,690 # 80008048 <etext+0x48>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	014080e7          	jalr	20(ra) # 80005db2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005da6:	4785                	li	a5,1
    80005da8:	00003717          	auipc	a4,0x3
    80005dac:	26f72a23          	sw	a5,628(a4) # 8000901c <panicked>
  for(;;)
    80005db0:	a001                	j	80005db0 <panic+0x48>

0000000080005db2 <printf>:
{
    80005db2:	7131                	addi	sp,sp,-192
    80005db4:	fc86                	sd	ra,120(sp)
    80005db6:	f8a2                	sd	s0,112(sp)
    80005db8:	f4a6                	sd	s1,104(sp)
    80005dba:	f0ca                	sd	s2,96(sp)
    80005dbc:	ecce                	sd	s3,88(sp)
    80005dbe:	e8d2                	sd	s4,80(sp)
    80005dc0:	e4d6                	sd	s5,72(sp)
    80005dc2:	e0da                	sd	s6,64(sp)
    80005dc4:	fc5e                	sd	s7,56(sp)
    80005dc6:	f862                	sd	s8,48(sp)
    80005dc8:	f466                	sd	s9,40(sp)
    80005dca:	f06a                	sd	s10,32(sp)
    80005dcc:	ec6e                	sd	s11,24(sp)
    80005dce:	0100                	addi	s0,sp,128
    80005dd0:	8a2a                	mv	s4,a0
    80005dd2:	e40c                	sd	a1,8(s0)
    80005dd4:	e810                	sd	a2,16(s0)
    80005dd6:	ec14                	sd	a3,24(s0)
    80005dd8:	f018                	sd	a4,32(s0)
    80005dda:	f41c                	sd	a5,40(s0)
    80005ddc:	03043823          	sd	a6,48(s0)
    80005de0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005de4:	00020d97          	auipc	s11,0x20
    80005de8:	41cdad83          	lw	s11,1052(s11) # 80026200 <pr+0x18>
  if(locking)
    80005dec:	020d9b63          	bnez	s11,80005e22 <printf+0x70>
  if (fmt == 0)
    80005df0:	040a0263          	beqz	s4,80005e34 <printf+0x82>
  va_start(ap, fmt);
    80005df4:	00840793          	addi	a5,s0,8
    80005df8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dfc:	000a4503          	lbu	a0,0(s4)
    80005e00:	16050263          	beqz	a0,80005f64 <printf+0x1b2>
    80005e04:	4481                	li	s1,0
    if(c != '%'){
    80005e06:	02500a93          	li	s5,37
    switch(c){
    80005e0a:	07000b13          	li	s6,112
  consputc('x');
    80005e0e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e10:	00003b97          	auipc	s7,0x3
    80005e14:	b78b8b93          	addi	s7,s7,-1160 # 80008988 <digits>
    switch(c){
    80005e18:	07300c93          	li	s9,115
    80005e1c:	06400c13          	li	s8,100
    80005e20:	a82d                	j	80005e5a <printf+0xa8>
    acquire(&pr.lock);
    80005e22:	00020517          	auipc	a0,0x20
    80005e26:	3c650513          	addi	a0,a0,966 # 800261e8 <pr>
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	488080e7          	jalr	1160(ra) # 800062b2 <acquire>
    80005e32:	bf7d                	j	80005df0 <printf+0x3e>
    panic("null fmt");
    80005e34:	00003517          	auipc	a0,0x3
    80005e38:	b3c50513          	addi	a0,a0,-1220 # 80008970 <syscalls_name+0x3e0>
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	f2c080e7          	jalr	-212(ra) # 80005d68 <panic>
      consputc(c);
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	c62080e7          	jalr	-926(ra) # 80005aa6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e4c:	2485                	addiw	s1,s1,1
    80005e4e:	009a07b3          	add	a5,s4,s1
    80005e52:	0007c503          	lbu	a0,0(a5)
    80005e56:	10050763          	beqz	a0,80005f64 <printf+0x1b2>
    if(c != '%'){
    80005e5a:	ff5515e3          	bne	a0,s5,80005e44 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e5e:	2485                	addiw	s1,s1,1
    80005e60:	009a07b3          	add	a5,s4,s1
    80005e64:	0007c783          	lbu	a5,0(a5)
    80005e68:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e6c:	cfe5                	beqz	a5,80005f64 <printf+0x1b2>
    switch(c){
    80005e6e:	05678a63          	beq	a5,s6,80005ec2 <printf+0x110>
    80005e72:	02fb7663          	bgeu	s6,a5,80005e9e <printf+0xec>
    80005e76:	09978963          	beq	a5,s9,80005f08 <printf+0x156>
    80005e7a:	07800713          	li	a4,120
    80005e7e:	0ce79863          	bne	a5,a4,80005f4e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e82:	f8843783          	ld	a5,-120(s0)
    80005e86:	00878713          	addi	a4,a5,8
    80005e8a:	f8e43423          	sd	a4,-120(s0)
    80005e8e:	4605                	li	a2,1
    80005e90:	85ea                	mv	a1,s10
    80005e92:	4388                	lw	a0,0(a5)
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	e32080e7          	jalr	-462(ra) # 80005cc6 <printint>
      break;
    80005e9c:	bf45                	j	80005e4c <printf+0x9a>
    switch(c){
    80005e9e:	0b578263          	beq	a5,s5,80005f42 <printf+0x190>
    80005ea2:	0b879663          	bne	a5,s8,80005f4e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ea6:	f8843783          	ld	a5,-120(s0)
    80005eaa:	00878713          	addi	a4,a5,8
    80005eae:	f8e43423          	sd	a4,-120(s0)
    80005eb2:	4605                	li	a2,1
    80005eb4:	45a9                	li	a1,10
    80005eb6:	4388                	lw	a0,0(a5)
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	e0e080e7          	jalr	-498(ra) # 80005cc6 <printint>
      break;
    80005ec0:	b771                	j	80005e4c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ec2:	f8843783          	ld	a5,-120(s0)
    80005ec6:	00878713          	addi	a4,a5,8
    80005eca:	f8e43423          	sd	a4,-120(s0)
    80005ece:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ed2:	03000513          	li	a0,48
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	bd0080e7          	jalr	-1072(ra) # 80005aa6 <consputc>
  consputc('x');
    80005ede:	07800513          	li	a0,120
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	bc4080e7          	jalr	-1084(ra) # 80005aa6 <consputc>
    80005eea:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eec:	03c9d793          	srli	a5,s3,0x3c
    80005ef0:	97de                	add	a5,a5,s7
    80005ef2:	0007c503          	lbu	a0,0(a5)
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	bb0080e7          	jalr	-1104(ra) # 80005aa6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005efe:	0992                	slli	s3,s3,0x4
    80005f00:	397d                	addiw	s2,s2,-1
    80005f02:	fe0915e3          	bnez	s2,80005eec <printf+0x13a>
    80005f06:	b799                	j	80005e4c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f08:	f8843783          	ld	a5,-120(s0)
    80005f0c:	00878713          	addi	a4,a5,8
    80005f10:	f8e43423          	sd	a4,-120(s0)
    80005f14:	0007b903          	ld	s2,0(a5)
    80005f18:	00090e63          	beqz	s2,80005f34 <printf+0x182>
      for(; *s; s++)
    80005f1c:	00094503          	lbu	a0,0(s2)
    80005f20:	d515                	beqz	a0,80005e4c <printf+0x9a>
        consputc(*s);
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	b84080e7          	jalr	-1148(ra) # 80005aa6 <consputc>
      for(; *s; s++)
    80005f2a:	0905                	addi	s2,s2,1
    80005f2c:	00094503          	lbu	a0,0(s2)
    80005f30:	f96d                	bnez	a0,80005f22 <printf+0x170>
    80005f32:	bf29                	j	80005e4c <printf+0x9a>
        s = "(null)";
    80005f34:	00003917          	auipc	s2,0x3
    80005f38:	a3490913          	addi	s2,s2,-1484 # 80008968 <syscalls_name+0x3d8>
      for(; *s; s++)
    80005f3c:	02800513          	li	a0,40
    80005f40:	b7cd                	j	80005f22 <printf+0x170>
      consputc('%');
    80005f42:	8556                	mv	a0,s5
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	b62080e7          	jalr	-1182(ra) # 80005aa6 <consputc>
      break;
    80005f4c:	b701                	j	80005e4c <printf+0x9a>
      consputc('%');
    80005f4e:	8556                	mv	a0,s5
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	b56080e7          	jalr	-1194(ra) # 80005aa6 <consputc>
      consputc(c);
    80005f58:	854a                	mv	a0,s2
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	b4c080e7          	jalr	-1204(ra) # 80005aa6 <consputc>
      break;
    80005f62:	b5ed                	j	80005e4c <printf+0x9a>
  if(locking)
    80005f64:	020d9163          	bnez	s11,80005f86 <printf+0x1d4>
}
    80005f68:	70e6                	ld	ra,120(sp)
    80005f6a:	7446                	ld	s0,112(sp)
    80005f6c:	74a6                	ld	s1,104(sp)
    80005f6e:	7906                	ld	s2,96(sp)
    80005f70:	69e6                	ld	s3,88(sp)
    80005f72:	6a46                	ld	s4,80(sp)
    80005f74:	6aa6                	ld	s5,72(sp)
    80005f76:	6b06                	ld	s6,64(sp)
    80005f78:	7be2                	ld	s7,56(sp)
    80005f7a:	7c42                	ld	s8,48(sp)
    80005f7c:	7ca2                	ld	s9,40(sp)
    80005f7e:	7d02                	ld	s10,32(sp)
    80005f80:	6de2                	ld	s11,24(sp)
    80005f82:	6129                	addi	sp,sp,192
    80005f84:	8082                	ret
    release(&pr.lock);
    80005f86:	00020517          	auipc	a0,0x20
    80005f8a:	26250513          	addi	a0,a0,610 # 800261e8 <pr>
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	3d8080e7          	jalr	984(ra) # 80006366 <release>
}
    80005f96:	bfc9                	j	80005f68 <printf+0x1b6>

0000000080005f98 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f98:	1101                	addi	sp,sp,-32
    80005f9a:	ec06                	sd	ra,24(sp)
    80005f9c:	e822                	sd	s0,16(sp)
    80005f9e:	e426                	sd	s1,8(sp)
    80005fa0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fa2:	00020497          	auipc	s1,0x20
    80005fa6:	24648493          	addi	s1,s1,582 # 800261e8 <pr>
    80005faa:	00003597          	auipc	a1,0x3
    80005fae:	9d658593          	addi	a1,a1,-1578 # 80008980 <syscalls_name+0x3f0>
    80005fb2:	8526                	mv	a0,s1
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	26e080e7          	jalr	622(ra) # 80006222 <initlock>
  pr.locking = 1;
    80005fbc:	4785                	li	a5,1
    80005fbe:	cc9c                	sw	a5,24(s1)
}
    80005fc0:	60e2                	ld	ra,24(sp)
    80005fc2:	6442                	ld	s0,16(sp)
    80005fc4:	64a2                	ld	s1,8(sp)
    80005fc6:	6105                	addi	sp,sp,32
    80005fc8:	8082                	ret

0000000080005fca <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fca:	1141                	addi	sp,sp,-16
    80005fcc:	e406                	sd	ra,8(sp)
    80005fce:	e022                	sd	s0,0(sp)
    80005fd0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fd2:	100007b7          	lui	a5,0x10000
    80005fd6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fda:	f8000713          	li	a4,-128
    80005fde:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fe2:	470d                	li	a4,3
    80005fe4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fe8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fec:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ff0:	469d                	li	a3,7
    80005ff2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ff6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ffa:	00003597          	auipc	a1,0x3
    80005ffe:	9a658593          	addi	a1,a1,-1626 # 800089a0 <digits+0x18>
    80006002:	00020517          	auipc	a0,0x20
    80006006:	20650513          	addi	a0,a0,518 # 80026208 <uart_tx_lock>
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	218080e7          	jalr	536(ra) # 80006222 <initlock>
}
    80006012:	60a2                	ld	ra,8(sp)
    80006014:	6402                	ld	s0,0(sp)
    80006016:	0141                	addi	sp,sp,16
    80006018:	8082                	ret

000000008000601a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000601a:	1101                	addi	sp,sp,-32
    8000601c:	ec06                	sd	ra,24(sp)
    8000601e:	e822                	sd	s0,16(sp)
    80006020:	e426                	sd	s1,8(sp)
    80006022:	1000                	addi	s0,sp,32
    80006024:	84aa                	mv	s1,a0
  push_off();
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	240080e7          	jalr	576(ra) # 80006266 <push_off>

  if(panicked){
    8000602e:	00003797          	auipc	a5,0x3
    80006032:	fee7a783          	lw	a5,-18(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006036:	10000737          	lui	a4,0x10000
  if(panicked){
    8000603a:	c391                	beqz	a5,8000603e <uartputc_sync+0x24>
    for(;;)
    8000603c:	a001                	j	8000603c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000603e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006042:	0ff7f793          	andi	a5,a5,255
    80006046:	0207f793          	andi	a5,a5,32
    8000604a:	dbf5                	beqz	a5,8000603e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000604c:	0ff4f793          	andi	a5,s1,255
    80006050:	10000737          	lui	a4,0x10000
    80006054:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	2ae080e7          	jalr	686(ra) # 80006306 <pop_off>
}
    80006060:	60e2                	ld	ra,24(sp)
    80006062:	6442                	ld	s0,16(sp)
    80006064:	64a2                	ld	s1,8(sp)
    80006066:	6105                	addi	sp,sp,32
    80006068:	8082                	ret

000000008000606a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000606a:	00003717          	auipc	a4,0x3
    8000606e:	fb673703          	ld	a4,-74(a4) # 80009020 <uart_tx_r>
    80006072:	00003797          	auipc	a5,0x3
    80006076:	fb67b783          	ld	a5,-74(a5) # 80009028 <uart_tx_w>
    8000607a:	06e78c63          	beq	a5,a4,800060f2 <uartstart+0x88>
{
    8000607e:	7139                	addi	sp,sp,-64
    80006080:	fc06                	sd	ra,56(sp)
    80006082:	f822                	sd	s0,48(sp)
    80006084:	f426                	sd	s1,40(sp)
    80006086:	f04a                	sd	s2,32(sp)
    80006088:	ec4e                	sd	s3,24(sp)
    8000608a:	e852                	sd	s4,16(sp)
    8000608c:	e456                	sd	s5,8(sp)
    8000608e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006090:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006094:	00020a17          	auipc	s4,0x20
    80006098:	174a0a13          	addi	s4,s4,372 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000609c:	00003497          	auipc	s1,0x3
    800060a0:	f8448493          	addi	s1,s1,-124 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060a4:	00003997          	auipc	s3,0x3
    800060a8:	f8498993          	addi	s3,s3,-124 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ac:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060b0:	0ff7f793          	andi	a5,a5,255
    800060b4:	0207f793          	andi	a5,a5,32
    800060b8:	c785                	beqz	a5,800060e0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ba:	01f77793          	andi	a5,a4,31
    800060be:	97d2                	add	a5,a5,s4
    800060c0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060c4:	0705                	addi	a4,a4,1
    800060c6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060c8:	8526                	mv	a0,s1
    800060ca:	ffffb097          	auipc	ra,0xffffb
    800060ce:	71c080e7          	jalr	1820(ra) # 800017e6 <wakeup>
    
    WriteReg(THR, c);
    800060d2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060d6:	6098                	ld	a4,0(s1)
    800060d8:	0009b783          	ld	a5,0(s3)
    800060dc:	fce798e3          	bne	a5,a4,800060ac <uartstart+0x42>
  }
}
    800060e0:	70e2                	ld	ra,56(sp)
    800060e2:	7442                	ld	s0,48(sp)
    800060e4:	74a2                	ld	s1,40(sp)
    800060e6:	7902                	ld	s2,32(sp)
    800060e8:	69e2                	ld	s3,24(sp)
    800060ea:	6a42                	ld	s4,16(sp)
    800060ec:	6aa2                	ld	s5,8(sp)
    800060ee:	6121                	addi	sp,sp,64
    800060f0:	8082                	ret
    800060f2:	8082                	ret

00000000800060f4 <uartputc>:
{
    800060f4:	7179                	addi	sp,sp,-48
    800060f6:	f406                	sd	ra,40(sp)
    800060f8:	f022                	sd	s0,32(sp)
    800060fa:	ec26                	sd	s1,24(sp)
    800060fc:	e84a                	sd	s2,16(sp)
    800060fe:	e44e                	sd	s3,8(sp)
    80006100:	e052                	sd	s4,0(sp)
    80006102:	1800                	addi	s0,sp,48
    80006104:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006106:	00020517          	auipc	a0,0x20
    8000610a:	10250513          	addi	a0,a0,258 # 80026208 <uart_tx_lock>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	1a4080e7          	jalr	420(ra) # 800062b2 <acquire>
  if(panicked){
    80006116:	00003797          	auipc	a5,0x3
    8000611a:	f067a783          	lw	a5,-250(a5) # 8000901c <panicked>
    8000611e:	c391                	beqz	a5,80006122 <uartputc+0x2e>
    for(;;)
    80006120:	a001                	j	80006120 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006122:	00003797          	auipc	a5,0x3
    80006126:	f067b783          	ld	a5,-250(a5) # 80009028 <uart_tx_w>
    8000612a:	00003717          	auipc	a4,0x3
    8000612e:	ef673703          	ld	a4,-266(a4) # 80009020 <uart_tx_r>
    80006132:	02070713          	addi	a4,a4,32
    80006136:	02f71b63          	bne	a4,a5,8000616c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000613a:	00020a17          	auipc	s4,0x20
    8000613e:	0cea0a13          	addi	s4,s4,206 # 80026208 <uart_tx_lock>
    80006142:	00003497          	auipc	s1,0x3
    80006146:	ede48493          	addi	s1,s1,-290 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000614a:	00003917          	auipc	s2,0x3
    8000614e:	ede90913          	addi	s2,s2,-290 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006152:	85d2                	mv	a1,s4
    80006154:	8526                	mv	a0,s1
    80006156:	ffffb097          	auipc	ra,0xffffb
    8000615a:	504080e7          	jalr	1284(ra) # 8000165a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000615e:	00093783          	ld	a5,0(s2)
    80006162:	6098                	ld	a4,0(s1)
    80006164:	02070713          	addi	a4,a4,32
    80006168:	fef705e3          	beq	a4,a5,80006152 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000616c:	00020497          	auipc	s1,0x20
    80006170:	09c48493          	addi	s1,s1,156 # 80026208 <uart_tx_lock>
    80006174:	01f7f713          	andi	a4,a5,31
    80006178:	9726                	add	a4,a4,s1
    8000617a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000617e:	0785                	addi	a5,a5,1
    80006180:	00003717          	auipc	a4,0x3
    80006184:	eaf73423          	sd	a5,-344(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	ee2080e7          	jalr	-286(ra) # 8000606a <uartstart>
      release(&uart_tx_lock);
    80006190:	8526                	mv	a0,s1
    80006192:	00000097          	auipc	ra,0x0
    80006196:	1d4080e7          	jalr	468(ra) # 80006366 <release>
}
    8000619a:	70a2                	ld	ra,40(sp)
    8000619c:	7402                	ld	s0,32(sp)
    8000619e:	64e2                	ld	s1,24(sp)
    800061a0:	6942                	ld	s2,16(sp)
    800061a2:	69a2                	ld	s3,8(sp)
    800061a4:	6a02                	ld	s4,0(sp)
    800061a6:	6145                	addi	sp,sp,48
    800061a8:	8082                	ret

00000000800061aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061aa:	1141                	addi	sp,sp,-16
    800061ac:	e422                	sd	s0,8(sp)
    800061ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061b0:	100007b7          	lui	a5,0x10000
    800061b4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061b8:	8b85                	andi	a5,a5,1
    800061ba:	cb91                	beqz	a5,800061ce <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061bc:	100007b7          	lui	a5,0x10000
    800061c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061c4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061c8:	6422                	ld	s0,8(sp)
    800061ca:	0141                	addi	sp,sp,16
    800061cc:	8082                	ret
    return -1;
    800061ce:	557d                	li	a0,-1
    800061d0:	bfe5                	j	800061c8 <uartgetc+0x1e>

00000000800061d2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061d2:	1101                	addi	sp,sp,-32
    800061d4:	ec06                	sd	ra,24(sp)
    800061d6:	e822                	sd	s0,16(sp)
    800061d8:	e426                	sd	s1,8(sp)
    800061da:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061dc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	fcc080e7          	jalr	-52(ra) # 800061aa <uartgetc>
    if(c == -1)
    800061e6:	00950763          	beq	a0,s1,800061f4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	8fe080e7          	jalr	-1794(ra) # 80005ae8 <consoleintr>
  while(1){
    800061f2:	b7f5                	j	800061de <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061f4:	00020497          	auipc	s1,0x20
    800061f8:	01448493          	addi	s1,s1,20 # 80026208 <uart_tx_lock>
    800061fc:	8526                	mv	a0,s1
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	0b4080e7          	jalr	180(ra) # 800062b2 <acquire>
  uartstart();
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	e64080e7          	jalr	-412(ra) # 8000606a <uartstart>
  release(&uart_tx_lock);
    8000620e:	8526                	mv	a0,s1
    80006210:	00000097          	auipc	ra,0x0
    80006214:	156080e7          	jalr	342(ra) # 80006366 <release>
}
    80006218:	60e2                	ld	ra,24(sp)
    8000621a:	6442                	ld	s0,16(sp)
    8000621c:	64a2                	ld	s1,8(sp)
    8000621e:	6105                	addi	sp,sp,32
    80006220:	8082                	ret

0000000080006222 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006222:	1141                	addi	sp,sp,-16
    80006224:	e422                	sd	s0,8(sp)
    80006226:	0800                	addi	s0,sp,16
  lk->name = name;
    80006228:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000622a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000622e:	00053823          	sd	zero,16(a0)
}
    80006232:	6422                	ld	s0,8(sp)
    80006234:	0141                	addi	sp,sp,16
    80006236:	8082                	ret

0000000080006238 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006238:	411c                	lw	a5,0(a0)
    8000623a:	e399                	bnez	a5,80006240 <holding+0x8>
    8000623c:	4501                	li	a0,0
  return r;
}
    8000623e:	8082                	ret
{
    80006240:	1101                	addi	sp,sp,-32
    80006242:	ec06                	sd	ra,24(sp)
    80006244:	e822                	sd	s0,16(sp)
    80006246:	e426                	sd	s1,8(sp)
    80006248:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000624a:	6904                	ld	s1,16(a0)
    8000624c:	ffffb097          	auipc	ra,0xffffb
    80006250:	d2e080e7          	jalr	-722(ra) # 80000f7a <mycpu>
    80006254:	40a48533          	sub	a0,s1,a0
    80006258:	00153513          	seqz	a0,a0
}
    8000625c:	60e2                	ld	ra,24(sp)
    8000625e:	6442                	ld	s0,16(sp)
    80006260:	64a2                	ld	s1,8(sp)
    80006262:	6105                	addi	sp,sp,32
    80006264:	8082                	ret

0000000080006266 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006270:	100024f3          	csrr	s1,sstatus
    80006274:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006278:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000627a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000627e:	ffffb097          	auipc	ra,0xffffb
    80006282:	cfc080e7          	jalr	-772(ra) # 80000f7a <mycpu>
    80006286:	5d3c                	lw	a5,120(a0)
    80006288:	cf89                	beqz	a5,800062a2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000628a:	ffffb097          	auipc	ra,0xffffb
    8000628e:	cf0080e7          	jalr	-784(ra) # 80000f7a <mycpu>
    80006292:	5d3c                	lw	a5,120(a0)
    80006294:	2785                	addiw	a5,a5,1
    80006296:	dd3c                	sw	a5,120(a0)
}
    80006298:	60e2                	ld	ra,24(sp)
    8000629a:	6442                	ld	s0,16(sp)
    8000629c:	64a2                	ld	s1,8(sp)
    8000629e:	6105                	addi	sp,sp,32
    800062a0:	8082                	ret
    mycpu()->intena = old;
    800062a2:	ffffb097          	auipc	ra,0xffffb
    800062a6:	cd8080e7          	jalr	-808(ra) # 80000f7a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062aa:	8085                	srli	s1,s1,0x1
    800062ac:	8885                	andi	s1,s1,1
    800062ae:	dd64                	sw	s1,124(a0)
    800062b0:	bfe9                	j	8000628a <push_off+0x24>

00000000800062b2 <acquire>:
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
    800062bc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	fa8080e7          	jalr	-88(ra) # 80006266 <push_off>
  if(holding(lk))
    800062c6:	8526                	mv	a0,s1
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	f70080e7          	jalr	-144(ra) # 80006238 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d0:	4705                	li	a4,1
  if(holding(lk))
    800062d2:	e115                	bnez	a0,800062f6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d4:	87ba                	mv	a5,a4
    800062d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062da:	2781                	sext.w	a5,a5
    800062dc:	ffe5                	bnez	a5,800062d4 <acquire+0x22>
  __sync_synchronize();
    800062de:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	c98080e7          	jalr	-872(ra) # 80000f7a <mycpu>
    800062ea:	e888                	sd	a0,16(s1)
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	addi	sp,sp,32
    800062f4:	8082                	ret
    panic("acquire");
    800062f6:	00002517          	auipc	a0,0x2
    800062fa:	6b250513          	addi	a0,a0,1714 # 800089a8 <digits+0x20>
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	a6a080e7          	jalr	-1430(ra) # 80005d68 <panic>

0000000080006306 <pop_off>:

void
pop_off(void)
{
    80006306:	1141                	addi	sp,sp,-16
    80006308:	e406                	sd	ra,8(sp)
    8000630a:	e022                	sd	s0,0(sp)
    8000630c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000630e:	ffffb097          	auipc	ra,0xffffb
    80006312:	c6c080e7          	jalr	-916(ra) # 80000f7a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006316:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000631a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000631c:	e78d                	bnez	a5,80006346 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000631e:	5d3c                	lw	a5,120(a0)
    80006320:	02f05b63          	blez	a5,80006356 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006324:	37fd                	addiw	a5,a5,-1
    80006326:	0007871b          	sext.w	a4,a5
    8000632a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000632c:	eb09                	bnez	a4,8000633e <pop_off+0x38>
    8000632e:	5d7c                	lw	a5,124(a0)
    80006330:	c799                	beqz	a5,8000633e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006332:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006336:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000633a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000633e:	60a2                	ld	ra,8(sp)
    80006340:	6402                	ld	s0,0(sp)
    80006342:	0141                	addi	sp,sp,16
    80006344:	8082                	ret
    panic("pop_off - interruptible");
    80006346:	00002517          	auipc	a0,0x2
    8000634a:	66a50513          	addi	a0,a0,1642 # 800089b0 <digits+0x28>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	a1a080e7          	jalr	-1510(ra) # 80005d68 <panic>
    panic("pop_off");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	67250513          	addi	a0,a0,1650 # 800089c8 <digits+0x40>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	a0a080e7          	jalr	-1526(ra) # 80005d68 <panic>

0000000080006366 <release>:
{
    80006366:	1101                	addi	sp,sp,-32
    80006368:	ec06                	sd	ra,24(sp)
    8000636a:	e822                	sd	s0,16(sp)
    8000636c:	e426                	sd	s1,8(sp)
    8000636e:	1000                	addi	s0,sp,32
    80006370:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006372:	00000097          	auipc	ra,0x0
    80006376:	ec6080e7          	jalr	-314(ra) # 80006238 <holding>
    8000637a:	c115                	beqz	a0,8000639e <release+0x38>
  lk->cpu = 0;
    8000637c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006380:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006384:	0f50000f          	fence	iorw,ow
    80006388:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	f7a080e7          	jalr	-134(ra) # 80006306 <pop_off>
}
    80006394:	60e2                	ld	ra,24(sp)
    80006396:	6442                	ld	s0,16(sp)
    80006398:	64a2                	ld	s1,8(sp)
    8000639a:	6105                	addi	sp,sp,32
    8000639c:	8082                	ret
    panic("release");
    8000639e:	00002517          	auipc	a0,0x2
    800063a2:	63250513          	addi	a0,a0,1586 # 800089d0 <digits+0x48>
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	9c2080e7          	jalr	-1598(ra) # 80005d68 <panic>
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
