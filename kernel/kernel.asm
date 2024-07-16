
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a0013103          	ld	sp,-1536(sp) # 80008a00 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	792050ef          	jal	ra,800057a8 <start>

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
    8000005e:	148080e7          	jalr	328(ra) # 800061a2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1e8080e7          	jalr	488(ra) # 80006256 <release>
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
    8000008e:	bce080e7          	jalr	-1074(ra) # 80005c58 <panic>

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
    800000f8:	01e080e7          	jalr	30(ra) # 80006112 <initlock>
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
    80000130:	076080e7          	jalr	118(ra) # 800061a2 <acquire>
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
    80000148:	112080e7          	jalr	274(ra) # 80006256 <release>

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
    80000172:	0e8080e7          	jalr	232(ra) # 80006256 <release>
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
    80000198:	00e080e7          	jalr	14(ra) # 800061a2 <acquire>
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
    800001ba:	0a0080e7          	jalr	160(ra) # 80006256 <release>
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
    80000384:	aee080e7          	jalr	-1298(ra) # 80000e6e <cpuid>
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
    800003a0:	ad2080e7          	jalr	-1326(ra) # 80000e6e <cpuid>
    800003a4:	85aa                	mv	a1,a0
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c9250513          	addi	a0,a0,-878 # 80008038 <etext+0x38>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	8f4080e7          	jalr	-1804(ra) # 80005ca2 <printf>
    kvminithart();    // turn on paging
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	0d8080e7          	jalr	216(ra) # 8000048e <kvminithart>
    trapinithart();   // install kernel trap vector
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	766080e7          	jalr	1894(ra) # 80001b24 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003c6:	00005097          	auipc	ra,0x5
    800003ca:	d6a080e7          	jalr	-662(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	fde080e7          	jalr	-34(ra) # 800013ac <scheduler>
    consoleinit();
    800003d6:	00005097          	auipc	ra,0x5
    800003da:	794080e7          	jalr	1940(ra) # 80005b6a <consoleinit>
    printfinit();
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	aaa080e7          	jalr	-1366(ra) # 80005e88 <printfinit>
    printf("\n");
    800003e6:	00008517          	auipc	a0,0x8
    800003ea:	c6250513          	addi	a0,a0,-926 # 80008048 <etext+0x48>
    800003ee:	00006097          	auipc	ra,0x6
    800003f2:	8b4080e7          	jalr	-1868(ra) # 80005ca2 <printf>
    printf("xv6 kernel is booting\n");
    800003f6:	00008517          	auipc	a0,0x8
    800003fa:	c2a50513          	addi	a0,a0,-982 # 80008020 <etext+0x20>
    800003fe:	00006097          	auipc	ra,0x6
    80000402:	8a4080e7          	jalr	-1884(ra) # 80005ca2 <printf>
    printf("\n");
    80000406:	00008517          	auipc	a0,0x8
    8000040a:	c4250513          	addi	a0,a0,-958 # 80008048 <etext+0x48>
    8000040e:	00006097          	auipc	ra,0x6
    80000412:	894080e7          	jalr	-1900(ra) # 80005ca2 <printf>
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
    80000432:	990080e7          	jalr	-1648(ra) # 80000dbe <procinit>
    trapinit();      // trap vectors
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	6c6080e7          	jalr	1734(ra) # 80001afc <trapinit>
    trapinithart();  // install kernel trap vector
    8000043e:	00001097          	auipc	ra,0x1
    80000442:	6e6080e7          	jalr	1766(ra) # 80001b24 <trapinithart>
    plicinit();      // set up interrupt controller
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	cd4080e7          	jalr	-812(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000044e:	00005097          	auipc	ra,0x5
    80000452:	ce2080e7          	jalr	-798(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	ec2080e7          	jalr	-318(ra) # 80002318 <binit>
    iinit();         // inode table
    8000045e:	00002097          	auipc	ra,0x2
    80000462:	552080e7          	jalr	1362(ra) # 800029b0 <iinit>
    fileinit();      // file table
    80000466:	00003097          	auipc	ra,0x3
    8000046a:	4fc080e7          	jalr	1276(ra) # 80003962 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000046e:	00005097          	auipc	ra,0x5
    80000472:	de4080e7          	jalr	-540(ra) # 80005252 <virtio_disk_init>
    userinit();      // first user process
    80000476:	00001097          	auipc	ra,0x1
    8000047a:	cfc080e7          	jalr	-772(ra) # 80001172 <userinit>
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
    800004e0:	00005097          	auipc	ra,0x5
    800004e4:	778080e7          	jalr	1912(ra) # 80005c58 <panic>
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
    800005dc:	680080e7          	jalr	1664(ra) # 80005c58 <panic>
      panic("mappages: remap");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a8850513          	addi	a0,a0,-1400 # 80008068 <etext+0x68>
    800005e8:	00005097          	auipc	ra,0x5
    800005ec:	670080e7          	jalr	1648(ra) # 80005c58 <panic>
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
    80000666:	5f6080e7          	jalr	1526(ra) # 80005c58 <panic>

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
    8000072e:	5fe080e7          	jalr	1534(ra) # 80000d28 <proc_mapstacks>
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
    800007b2:	4aa080e7          	jalr	1194(ra) # 80005c58 <panic>
      panic("uvmunmap: walk");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	8e250513          	addi	a0,a0,-1822 # 80008098 <etext+0x98>
    800007be:	00005097          	auipc	ra,0x5
    800007c2:	49a080e7          	jalr	1178(ra) # 80005c58 <panic>
      panic("uvmunmap: not mapped");
    800007c6:	00008517          	auipc	a0,0x8
    800007ca:	8e250513          	addi	a0,a0,-1822 # 800080a8 <etext+0xa8>
    800007ce:	00005097          	auipc	ra,0x5
    800007d2:	48a080e7          	jalr	1162(ra) # 80005c58 <panic>
      panic("uvmunmap: not a leaf");
    800007d6:	00008517          	auipc	a0,0x8
    800007da:	8ea50513          	addi	a0,a0,-1814 # 800080c0 <etext+0xc0>
    800007de:	00005097          	auipc	ra,0x5
    800007e2:	47a080e7          	jalr	1146(ra) # 80005c58 <panic>
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
    800008c0:	39c080e7          	jalr	924(ra) # 80005c58 <panic>

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
    80000a02:	25a080e7          	jalr	602(ra) # 80005c58 <panic>
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
    80000ade:	17e080e7          	jalr	382(ra) # 80005c58 <panic>
      panic("uvmcopy: page not present");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	64650513          	addi	a0,a0,1606 # 80008128 <etext+0x128>
    80000aea:	00005097          	auipc	ra,0x5
    80000aee:	16e080e7          	jalr	366(ra) # 80005c58 <panic>
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
    80000b58:	104080e7          	jalr	260(ra) # 80005c58 <panic>

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

0000000080000d28 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d28:	7139                	addi	sp,sp,-64
    80000d2a:	fc06                	sd	ra,56(sp)
    80000d2c:	f822                	sd	s0,48(sp)
    80000d2e:	f426                	sd	s1,40(sp)
    80000d30:	f04a                	sd	s2,32(sp)
    80000d32:	ec4e                	sd	s3,24(sp)
    80000d34:	e852                	sd	s4,16(sp)
    80000d36:	e456                	sd	s5,8(sp)
    80000d38:	e05a                	sd	s6,0(sp)
    80000d3a:	0080                	addi	s0,sp,64
    80000d3c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3e:	00008497          	auipc	s1,0x8
    80000d42:	74248493          	addi	s1,s1,1858 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d46:	8b26                	mv	s6,s1
    80000d48:	00007a97          	auipc	s5,0x7
    80000d4c:	2b8a8a93          	addi	s5,s5,696 # 80008000 <etext>
    80000d50:	04000937          	lui	s2,0x4000
    80000d54:	197d                	addi	s2,s2,-1
    80000d56:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d58:	0000ea17          	auipc	s4,0xe
    80000d5c:	128a0a13          	addi	s4,s4,296 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d60:	fffff097          	auipc	ra,0xfffff
    80000d64:	3b8080e7          	jalr	952(ra) # 80000118 <kalloc>
    80000d68:	862a                	mv	a2,a0
    if(pa == 0)
    80000d6a:	c131                	beqz	a0,80000dae <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d6c:	416485b3          	sub	a1,s1,s6
    80000d70:	858d                	srai	a1,a1,0x3
    80000d72:	000ab783          	ld	a5,0(s5)
    80000d76:	02f585b3          	mul	a1,a1,a5
    80000d7a:	2585                	addiw	a1,a1,1
    80000d7c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d80:	4719                	li	a4,6
    80000d82:	6685                	lui	a3,0x1
    80000d84:	40b905b3          	sub	a1,s2,a1
    80000d88:	854e                	mv	a0,s3
    80000d8a:	00000097          	auipc	ra,0x0
    80000d8e:	8b0080e7          	jalr	-1872(ra) # 8000063a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d92:	16848493          	addi	s1,s1,360
    80000d96:	fd4495e3          	bne	s1,s4,80000d60 <proc_mapstacks+0x38>
  }
}
    80000d9a:	70e2                	ld	ra,56(sp)
    80000d9c:	7442                	ld	s0,48(sp)
    80000d9e:	74a2                	ld	s1,40(sp)
    80000da0:	7902                	ld	s2,32(sp)
    80000da2:	69e2                	ld	s3,24(sp)
    80000da4:	6a42                	ld	s4,16(sp)
    80000da6:	6aa2                	ld	s5,8(sp)
    80000da8:	6b02                	ld	s6,0(sp)
    80000daa:	6121                	addi	sp,sp,64
    80000dac:	8082                	ret
      panic("kalloc");
    80000dae:	00007517          	auipc	a0,0x7
    80000db2:	3aa50513          	addi	a0,a0,938 # 80008158 <etext+0x158>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	ea2080e7          	jalr	-350(ra) # 80005c58 <panic>

0000000080000dbe <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000dbe:	7139                	addi	sp,sp,-64
    80000dc0:	fc06                	sd	ra,56(sp)
    80000dc2:	f822                	sd	s0,48(sp)
    80000dc4:	f426                	sd	s1,40(sp)
    80000dc6:	f04a                	sd	s2,32(sp)
    80000dc8:	ec4e                	sd	s3,24(sp)
    80000dca:	e852                	sd	s4,16(sp)
    80000dcc:	e456                	sd	s5,8(sp)
    80000dce:	e05a                	sd	s6,0(sp)
    80000dd0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd2:	00007597          	auipc	a1,0x7
    80000dd6:	38e58593          	addi	a1,a1,910 # 80008160 <etext+0x160>
    80000dda:	00008517          	auipc	a0,0x8
    80000dde:	27650513          	addi	a0,a0,630 # 80009050 <pid_lock>
    80000de2:	00005097          	auipc	ra,0x5
    80000de6:	330080e7          	jalr	816(ra) # 80006112 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dea:	00007597          	auipc	a1,0x7
    80000dee:	37e58593          	addi	a1,a1,894 # 80008168 <etext+0x168>
    80000df2:	00008517          	auipc	a0,0x8
    80000df6:	27650513          	addi	a0,a0,630 # 80009068 <wait_lock>
    80000dfa:	00005097          	auipc	ra,0x5
    80000dfe:	318080e7          	jalr	792(ra) # 80006112 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e02:	00008497          	auipc	s1,0x8
    80000e06:	67e48493          	addi	s1,s1,1662 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e0a:	00007b17          	auipc	s6,0x7
    80000e0e:	36eb0b13          	addi	s6,s6,878 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e12:	8aa6                	mv	s5,s1
    80000e14:	00007a17          	auipc	s4,0x7
    80000e18:	1eca0a13          	addi	s4,s4,492 # 80008000 <etext>
    80000e1c:	04000937          	lui	s2,0x4000
    80000e20:	197d                	addi	s2,s2,-1
    80000e22:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	0000e997          	auipc	s3,0xe
    80000e28:	05c98993          	addi	s3,s3,92 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e2c:	85da                	mv	a1,s6
    80000e2e:	8526                	mv	a0,s1
    80000e30:	00005097          	auipc	ra,0x5
    80000e34:	2e2080e7          	jalr	738(ra) # 80006112 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e38:	415487b3          	sub	a5,s1,s5
    80000e3c:	878d                	srai	a5,a5,0x3
    80000e3e:	000a3703          	ld	a4,0(s4)
    80000e42:	02e787b3          	mul	a5,a5,a4
    80000e46:	2785                	addiw	a5,a5,1
    80000e48:	00d7979b          	slliw	a5,a5,0xd
    80000e4c:	40f907b3          	sub	a5,s2,a5
    80000e50:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	16848493          	addi	s1,s1,360
    80000e56:	fd349be3          	bne	s1,s3,80000e2c <procinit+0x6e>
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
    80000e8a:	00008517          	auipc	a0,0x8
    80000e8e:	1f650513          	addi	a0,a0,502 # 80009080 <cpus>
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
    80000ea4:	00005097          	auipc	ra,0x5
    80000ea8:	2b2080e7          	jalr	690(ra) # 80006156 <push_off>
    80000eac:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eae:	2781                	sext.w	a5,a5
    80000eb0:	079e                	slli	a5,a5,0x7
    80000eb2:	00008717          	auipc	a4,0x8
    80000eb6:	19e70713          	addi	a4,a4,414 # 80009050 <pid_lock>
    80000eba:	97ba                	add	a5,a5,a4
    80000ebc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ebe:	00005097          	auipc	ra,0x5
    80000ec2:	338080e7          	jalr	824(ra) # 800061f6 <pop_off>
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
    80000ee2:	00005097          	auipc	ra,0x5
    80000ee6:	374080e7          	jalr	884(ra) # 80006256 <release>

  if (first) {
    80000eea:	00008797          	auipc	a5,0x8
    80000eee:	ac67a783          	lw	a5,-1338(a5) # 800089b0 <first.1677>
    80000ef2:	eb89                	bnez	a5,80000f04 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ef4:	00001097          	auipc	ra,0x1
    80000ef8:	c48080e7          	jalr	-952(ra) # 80001b3c <usertrapret>
}
    80000efc:	60a2                	ld	ra,8(sp)
    80000efe:	6402                	ld	s0,0(sp)
    80000f00:	0141                	addi	sp,sp,16
    80000f02:	8082                	ret
    first = 0;
    80000f04:	00008797          	auipc	a5,0x8
    80000f08:	aa07a623          	sw	zero,-1364(a5) # 800089b0 <first.1677>
    fsinit(ROOTDEV);
    80000f0c:	4505                	li	a0,1
    80000f0e:	00002097          	auipc	ra,0x2
    80000f12:	a22080e7          	jalr	-1502(ra) # 80002930 <fsinit>
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
    80000f24:	00008917          	auipc	s2,0x8
    80000f28:	12c90913          	addi	s2,s2,300 # 80009050 <pid_lock>
    80000f2c:	854a                	mv	a0,s2
    80000f2e:	00005097          	auipc	ra,0x5
    80000f32:	274080e7          	jalr	628(ra) # 800061a2 <acquire>
  pid = nextpid;
    80000f36:	00008797          	auipc	a5,0x8
    80000f3a:	a7e78793          	addi	a5,a5,-1410 # 800089b4 <nextpid>
    80000f3e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f40:	0014871b          	addiw	a4,s1,1
    80000f44:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f46:	854a                	mv	a0,s2
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	30e080e7          	jalr	782(ra) # 80006256 <release>
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
    80000f70:	8b8080e7          	jalr	-1864(ra) # 80000824 <uvmcreate>
    80000f74:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f76:	c121                	beqz	a0,80000fb6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f78:	4729                	li	a4,10
    80000f7a:	00006697          	auipc	a3,0x6
    80000f7e:	08668693          	addi	a3,a3,134 # 80007000 <_trampoline>
    80000f82:	6605                	lui	a2,0x1
    80000f84:	040005b7          	lui	a1,0x4000
    80000f88:	15fd                	addi	a1,a1,-1
    80000f8a:	05b2                	slli	a1,a1,0xc
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	60e080e7          	jalr	1550(ra) # 8000059a <mappages>
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
    80000fae:	5f0080e7          	jalr	1520(ra) # 8000059a <mappages>
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
    80000fcc:	a58080e7          	jalr	-1448(ra) # 80000a20 <uvmfree>
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
    80000fe6:	77e080e7          	jalr	1918(ra) # 80000760 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fea:	4581                	li	a1,0
    80000fec:	8526                	mv	a0,s1
    80000fee:	00000097          	auipc	ra,0x0
    80000ff2:	a32080e7          	jalr	-1486(ra) # 80000a20 <uvmfree>
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
    8000101a:	74a080e7          	jalr	1866(ra) # 80000760 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000101e:	4681                	li	a3,0
    80001020:	4605                	li	a2,1
    80001022:	020005b7          	lui	a1,0x2000
    80001026:	15fd                	addi	a1,a1,-1
    80001028:	05b6                	slli	a1,a1,0xd
    8000102a:	8526                	mv	a0,s1
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	734080e7          	jalr	1844(ra) # 80000760 <uvmunmap>
  uvmfree(pagetable, sz);
    80001034:	85ca                	mv	a1,s2
    80001036:	8526                	mv	a0,s1
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	9e8080e7          	jalr	-1560(ra) # 80000a20 <uvmfree>
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
    800010b0:	00008497          	auipc	s1,0x8
    800010b4:	3d048493          	addi	s1,s1,976 # 80009480 <proc>
    800010b8:	0000e917          	auipc	s2,0xe
    800010bc:	dc890913          	addi	s2,s2,-568 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010c0:	8526                	mv	a0,s1
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	0e0080e7          	jalr	224(ra) # 800061a2 <acquire>
    if(p->state == UNUSED) {
    800010ca:	4c9c                	lw	a5,24(s1)
    800010cc:	cf81                	beqz	a5,800010e4 <allocproc+0x40>
      release(&p->lock);
    800010ce:	8526                	mv	a0,s1
    800010d0:	00005097          	auipc	ra,0x5
    800010d4:	186080e7          	jalr	390(ra) # 80006256 <release>
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
    8000111e:	0b0080e7          	jalr	176(ra) # 800001ca <memset>
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
    8000114e:	00005097          	auipc	ra,0x5
    80001152:	108080e7          	jalr	264(ra) # 80006256 <release>
    return 0;
    80001156:	84ca                	mv	s1,s2
    80001158:	bff1                	j	80001134 <allocproc+0x90>
    freeproc(p);
    8000115a:	8526                	mv	a0,s1
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	ef0080e7          	jalr	-272(ra) # 8000104c <freeproc>
    release(&p->lock);
    80001164:	8526                	mv	a0,s1
    80001166:	00005097          	auipc	ra,0x5
    8000116a:	0f0080e7          	jalr	240(ra) # 80006256 <release>
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
    80001186:	00008797          	auipc	a5,0x8
    8000118a:	e8a7b523          	sd	a0,-374(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000118e:	03400613          	li	a2,52
    80001192:	00008597          	auipc	a1,0x8
    80001196:	82e58593          	addi	a1,a1,-2002 # 800089c0 <initcode>
    8000119a:	6928                	ld	a0,80(a0)
    8000119c:	fffff097          	auipc	ra,0xfffff
    800011a0:	6b6080e7          	jalr	1718(ra) # 80000852 <uvminit>
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
    800011b4:	00007597          	auipc	a1,0x7
    800011b8:	fcc58593          	addi	a1,a1,-52 # 80008180 <etext+0x180>
    800011bc:	15848513          	addi	a0,s1,344
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	15c080e7          	jalr	348(ra) # 8000031c <safestrcpy>
  p->cwd = namei("/");
    800011c8:	00007517          	auipc	a0,0x7
    800011cc:	fc850513          	addi	a0,a0,-56 # 80008190 <etext+0x190>
    800011d0:	00002097          	auipc	ra,0x2
    800011d4:	18e080e7          	jalr	398(ra) # 8000335e <namei>
    800011d8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011dc:	478d                	li	a5,3
    800011de:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00005097          	auipc	ra,0x5
    800011e6:	074080e7          	jalr	116(ra) # 80006256 <release>
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
    80001240:	6d0080e7          	jalr	1744(ra) # 8000090c <uvmalloc>
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
    8000125e:	66a080e7          	jalr	1642(ra) # 800008c4 <uvmdealloc>
    80001262:	0005061b          	sext.w	a2,a0
    80001266:	bf55                	j	8000121a <growproc+0x26>

0000000080001268 <fork>:
{
    80001268:	7179                	addi	sp,sp,-48
    8000126a:	f406                	sd	ra,40(sp)
    8000126c:	f022                	sd	s0,32(sp)
    8000126e:	ec26                	sd	s1,24(sp)
    80001270:	e84a                	sd	s2,16(sp)
    80001272:	e44e                	sd	s3,8(sp)
    80001274:	e052                	sd	s4,0(sp)
    80001276:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	c22080e7          	jalr	-990(ra) # 80000e9a <myproc>
    80001280:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001282:	00000097          	auipc	ra,0x0
    80001286:	e22080e7          	jalr	-478(ra) # 800010a4 <allocproc>
    8000128a:	10050f63          	beqz	a0,800013a8 <fork+0x140>
    8000128e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001290:	04893603          	ld	a2,72(s2)
    80001294:	692c                	ld	a1,80(a0)
    80001296:	05093503          	ld	a0,80(s2)
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	7be080e7          	jalr	1982(ra) # 80000a58 <uvmcopy>
    800012a2:	04054663          	bltz	a0,800012ee <fork+0x86>
  np->sz = p->sz;
    800012a6:	04893783          	ld	a5,72(s2)
    800012aa:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012ae:	05893683          	ld	a3,88(s2)
    800012b2:	87b6                	mv	a5,a3
    800012b4:	0589b703          	ld	a4,88(s3)
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
    800012d8:	fed792e3          	bne	a5,a3,800012bc <fork+0x54>
  np->trapframe->a0 = 0;
    800012dc:	0589b783          	ld	a5,88(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
    800012e4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e8:	15000a13          	li	s4,336
    800012ec:	a03d                	j	8000131a <fork+0xb2>
    freeproc(np);
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d5c080e7          	jalr	-676(ra) # 8000104c <freeproc>
    release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	f5c080e7          	jalr	-164(ra) # 80006256 <release>
    return -1;
    80001302:	5a7d                	li	s4,-1
    80001304:	a849                	j	80001396 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	6ee080e7          	jalr	1774(ra) # 800039f4 <filedup>
    8000130e:	009987b3          	add	a5,s3,s1
    80001312:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001314:	04a1                	addi	s1,s1,8
    80001316:	01448763          	beq	s1,s4,80001324 <fork+0xbc>
    if(p->ofile[i])
    8000131a:	009907b3          	add	a5,s2,s1
    8000131e:	6388                	ld	a0,0(a5)
    80001320:	f17d                	bnez	a0,80001306 <fork+0x9e>
    80001322:	bfcd                	j	80001314 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001324:	15093503          	ld	a0,336(s2)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	842080e7          	jalr	-1982(ra) # 80002b6a <idup>
    80001330:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001334:	4641                	li	a2,16
    80001336:	15890593          	addi	a1,s2,344
    8000133a:	15898513          	addi	a0,s3,344
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	fde080e7          	jalr	-34(ra) # 8000031c <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001346:	03492783          	lw	a5,52(s2)
    8000134a:	02f9aa23          	sw	a5,52(s3)
  pid = np->pid;
    8000134e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001352:	854e                	mv	a0,s3
    80001354:	00005097          	auipc	ra,0x5
    80001358:	f02080e7          	jalr	-254(ra) # 80006256 <release>
  acquire(&wait_lock);
    8000135c:	00008497          	auipc	s1,0x8
    80001360:	d0c48493          	addi	s1,s1,-756 # 80009068 <wait_lock>
    80001364:	8526                	mv	a0,s1
    80001366:	00005097          	auipc	ra,0x5
    8000136a:	e3c080e7          	jalr	-452(ra) # 800061a2 <acquire>
  np->parent = p;
    8000136e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001372:	8526                	mv	a0,s1
    80001374:	00005097          	auipc	ra,0x5
    80001378:	ee2080e7          	jalr	-286(ra) # 80006256 <release>
  acquire(&np->lock);
    8000137c:	854e                	mv	a0,s3
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	e24080e7          	jalr	-476(ra) # 800061a2 <acquire>
  np->state = RUNNABLE;
    80001386:	478d                	li	a5,3
    80001388:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000138c:	854e                	mv	a0,s3
    8000138e:	00005097          	auipc	ra,0x5
    80001392:	ec8080e7          	jalr	-312(ra) # 80006256 <release>
}
    80001396:	8552                	mv	a0,s4
    80001398:	70a2                	ld	ra,40(sp)
    8000139a:	7402                	ld	s0,32(sp)
    8000139c:	64e2                	ld	s1,24(sp)
    8000139e:	6942                	ld	s2,16(sp)
    800013a0:	69a2                	ld	s3,8(sp)
    800013a2:	6a02                	ld	s4,0(sp)
    800013a4:	6145                	addi	sp,sp,48
    800013a6:	8082                	ret
    return -1;
    800013a8:	5a7d                	li	s4,-1
    800013aa:	b7f5                	j	80001396 <fork+0x12e>

00000000800013ac <scheduler>:
{
    800013ac:	7139                	addi	sp,sp,-64
    800013ae:	fc06                	sd	ra,56(sp)
    800013b0:	f822                	sd	s0,48(sp)
    800013b2:	f426                	sd	s1,40(sp)
    800013b4:	f04a                	sd	s2,32(sp)
    800013b6:	ec4e                	sd	s3,24(sp)
    800013b8:	e852                	sd	s4,16(sp)
    800013ba:	e456                	sd	s5,8(sp)
    800013bc:	e05a                	sd	s6,0(sp)
    800013be:	0080                	addi	s0,sp,64
    800013c0:	8792                	mv	a5,tp
  int id = r_tp();
    800013c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c4:	00779a93          	slli	s5,a5,0x7
    800013c8:	00008717          	auipc	a4,0x8
    800013cc:	c8870713          	addi	a4,a4,-888 # 80009050 <pid_lock>
    800013d0:	9756                	add	a4,a4,s5
    800013d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d6:	00008717          	auipc	a4,0x8
    800013da:	cb270713          	addi	a4,a4,-846 # 80009088 <cpus+0x8>
    800013de:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e0:	498d                	li	s3,3
        p->state = RUNNING;
    800013e2:	4b11                	li	s6,4
        c->proc = p;
    800013e4:	079e                	slli	a5,a5,0x7
    800013e6:	00008a17          	auipc	s4,0x8
    800013ea:	c6aa0a13          	addi	s4,s4,-918 # 80009050 <pid_lock>
    800013ee:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f0:	0000e917          	auipc	s2,0xe
    800013f4:	a9090913          	addi	s2,s2,-1392 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001400:	10079073          	csrw	sstatus,a5
    80001404:	00008497          	auipc	s1,0x8
    80001408:	07c48493          	addi	s1,s1,124 # 80009480 <proc>
    8000140c:	a03d                	j	8000143a <scheduler+0x8e>
        p->state = RUNNING;
    8000140e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001412:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001416:	06048593          	addi	a1,s1,96
    8000141a:	8556                	mv	a0,s5
    8000141c:	00000097          	auipc	ra,0x0
    80001420:	676080e7          	jalr	1654(ra) # 80001a92 <swtch>
        c->proc = 0;
    80001424:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001428:	8526                	mv	a0,s1
    8000142a:	00005097          	auipc	ra,0x5
    8000142e:	e2c080e7          	jalr	-468(ra) # 80006256 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001432:	16848493          	addi	s1,s1,360
    80001436:	fd2481e3          	beq	s1,s2,800013f8 <scheduler+0x4c>
      acquire(&p->lock);
    8000143a:	8526                	mv	a0,s1
    8000143c:	00005097          	auipc	ra,0x5
    80001440:	d66080e7          	jalr	-666(ra) # 800061a2 <acquire>
      if(p->state == RUNNABLE) {
    80001444:	4c9c                	lw	a5,24(s1)
    80001446:	ff3791e3          	bne	a5,s3,80001428 <scheduler+0x7c>
    8000144a:	b7d1                	j	8000140e <scheduler+0x62>

000000008000144c <sched>:
{
    8000144c:	7179                	addi	sp,sp,-48
    8000144e:	f406                	sd	ra,40(sp)
    80001450:	f022                	sd	s0,32(sp)
    80001452:	ec26                	sd	s1,24(sp)
    80001454:	e84a                	sd	s2,16(sp)
    80001456:	e44e                	sd	s3,8(sp)
    80001458:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	a40080e7          	jalr	-1472(ra) # 80000e9a <myproc>
    80001462:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001464:	00005097          	auipc	ra,0x5
    80001468:	cc4080e7          	jalr	-828(ra) # 80006128 <holding>
    8000146c:	c93d                	beqz	a0,800014e2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	00008717          	auipc	a4,0x8
    80001478:	bdc70713          	addi	a4,a4,-1060 # 80009050 <pid_lock>
    8000147c:	97ba                	add	a5,a5,a4
    8000147e:	0a87a703          	lw	a4,168(a5)
    80001482:	4785                	li	a5,1
    80001484:	06f71763          	bne	a4,a5,800014f2 <sched+0xa6>
  if(p->state == RUNNING)
    80001488:	4c98                	lw	a4,24(s1)
    8000148a:	4791                	li	a5,4
    8000148c:	06f70b63          	beq	a4,a5,80001502 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001490:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001494:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001496:	efb5                	bnez	a5,80001512 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001498:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149a:	00008917          	auipc	s2,0x8
    8000149e:	bb690913          	addi	s2,s2,-1098 # 80009050 <pid_lock>
    800014a2:	2781                	sext.w	a5,a5
    800014a4:	079e                	slli	a5,a5,0x7
    800014a6:	97ca                	add	a5,a5,s2
    800014a8:	0ac7a983          	lw	s3,172(a5)
    800014ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	00008597          	auipc	a1,0x8
    800014b6:	bd658593          	addi	a1,a1,-1066 # 80009088 <cpus+0x8>
    800014ba:	95be                	add	a1,a1,a5
    800014bc:	06048513          	addi	a0,s1,96
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	5d2080e7          	jalr	1490(ra) # 80001a92 <swtch>
    800014c8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	97ca                	add	a5,a5,s2
    800014d0:	0b37a623          	sw	s3,172(a5)
}
    800014d4:	70a2                	ld	ra,40(sp)
    800014d6:	7402                	ld	s0,32(sp)
    800014d8:	64e2                	ld	s1,24(sp)
    800014da:	6942                	ld	s2,16(sp)
    800014dc:	69a2                	ld	s3,8(sp)
    800014de:	6145                	addi	sp,sp,48
    800014e0:	8082                	ret
    panic("sched p->lock");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	cb650513          	addi	a0,a0,-842 # 80008198 <etext+0x198>
    800014ea:	00004097          	auipc	ra,0x4
    800014ee:	76e080e7          	jalr	1902(ra) # 80005c58 <panic>
    panic("sched locks");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	cb650513          	addi	a0,a0,-842 # 800081a8 <etext+0x1a8>
    800014fa:	00004097          	auipc	ra,0x4
    800014fe:	75e080e7          	jalr	1886(ra) # 80005c58 <panic>
    panic("sched running");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	cb650513          	addi	a0,a0,-842 # 800081b8 <etext+0x1b8>
    8000150a:	00004097          	auipc	ra,0x4
    8000150e:	74e080e7          	jalr	1870(ra) # 80005c58 <panic>
    panic("sched interruptible");
    80001512:	00007517          	auipc	a0,0x7
    80001516:	cb650513          	addi	a0,a0,-842 # 800081c8 <etext+0x1c8>
    8000151a:	00004097          	auipc	ra,0x4
    8000151e:	73e080e7          	jalr	1854(ra) # 80005c58 <panic>

0000000080001522 <yield>:
{
    80001522:	1101                	addi	sp,sp,-32
    80001524:	ec06                	sd	ra,24(sp)
    80001526:	e822                	sd	s0,16(sp)
    80001528:	e426                	sd	s1,8(sp)
    8000152a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	96e080e7          	jalr	-1682(ra) # 80000e9a <myproc>
    80001534:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	c6c080e7          	jalr	-916(ra) # 800061a2 <acquire>
  p->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	cc9c                	sw	a5,24(s1)
  sched();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	f0a080e7          	jalr	-246(ra) # 8000144c <sched>
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	d0a080e7          	jalr	-758(ra) # 80006256 <release>
}
    80001554:	60e2                	ld	ra,24(sp)
    80001556:	6442                	ld	s0,16(sp)
    80001558:	64a2                	ld	s1,8(sp)
    8000155a:	6105                	addi	sp,sp,32
    8000155c:	8082                	ret

000000008000155e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155e:	7179                	addi	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	89aa                	mv	s3,a0
    8000156e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	92a080e7          	jalr	-1750(ra) # 80000e9a <myproc>
    80001578:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	c28080e7          	jalr	-984(ra) # 800061a2 <acquire>
  release(lk);
    80001582:	854a                	mv	a0,s2
    80001584:	00005097          	auipc	ra,0x5
    80001588:	cd2080e7          	jalr	-814(ra) # 80006256 <release>

  // Go to sleep.
  p->chan = chan;
    8000158c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001590:	4789                	li	a5,2
    80001592:	cc9c                	sw	a5,24(s1)

  sched();
    80001594:	00000097          	auipc	ra,0x0
    80001598:	eb8080e7          	jalr	-328(ra) # 8000144c <sched>

  // Tidy up.
  p->chan = 0;
    8000159c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	cb4080e7          	jalr	-844(ra) # 80006256 <release>
  acquire(lk);
    800015aa:	854a                	mv	a0,s2
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	bf6080e7          	jalr	-1034(ra) # 800061a2 <acquire>
}
    800015b4:	70a2                	ld	ra,40(sp)
    800015b6:	7402                	ld	s0,32(sp)
    800015b8:	64e2                	ld	s1,24(sp)
    800015ba:	6942                	ld	s2,16(sp)
    800015bc:	69a2                	ld	s3,8(sp)
    800015be:	6145                	addi	sp,sp,48
    800015c0:	8082                	ret

00000000800015c2 <wait>:
{
    800015c2:	715d                	addi	sp,sp,-80
    800015c4:	e486                	sd	ra,72(sp)
    800015c6:	e0a2                	sd	s0,64(sp)
    800015c8:	fc26                	sd	s1,56(sp)
    800015ca:	f84a                	sd	s2,48(sp)
    800015cc:	f44e                	sd	s3,40(sp)
    800015ce:	f052                	sd	s4,32(sp)
    800015d0:	ec56                	sd	s5,24(sp)
    800015d2:	e85a                	sd	s6,16(sp)
    800015d4:	e45e                	sd	s7,8(sp)
    800015d6:	e062                	sd	s8,0(sp)
    800015d8:	0880                	addi	s0,sp,80
    800015da:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	8be080e7          	jalr	-1858(ra) # 80000e9a <myproc>
    800015e4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e6:	00008517          	auipc	a0,0x8
    800015ea:	a8250513          	addi	a0,a0,-1406 # 80009068 <wait_lock>
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	bb4080e7          	jalr	-1100(ra) # 800061a2 <acquire>
    havekids = 0;
    800015f6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f8:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015fa:	0000e997          	auipc	s3,0xe
    800015fe:	88698993          	addi	s3,s3,-1914 # 8000ee80 <tickslock>
        havekids = 1;
    80001602:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001604:	00008c17          	auipc	s8,0x8
    80001608:	a64c0c13          	addi	s8,s8,-1436 # 80009068 <wait_lock>
    havekids = 0;
    8000160c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160e:	00008497          	auipc	s1,0x8
    80001612:	e7248493          	addi	s1,s1,-398 # 80009480 <proc>
    80001616:	a0bd                	j	80001684 <wait+0xc2>
          pid = np->pid;
    80001618:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161c:	000b0e63          	beqz	s6,80001638 <wait+0x76>
    80001620:	4691                	li	a3,4
    80001622:	02c48613          	addi	a2,s1,44
    80001626:	85da                	mv	a1,s6
    80001628:	05093503          	ld	a0,80(s2)
    8000162c:	fffff097          	auipc	ra,0xfffff
    80001630:	530080e7          	jalr	1328(ra) # 80000b5c <copyout>
    80001634:	02054563          	bltz	a0,8000165e <wait+0x9c>
          freeproc(np);
    80001638:	8526                	mv	a0,s1
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	a12080e7          	jalr	-1518(ra) # 8000104c <freeproc>
          release(&np->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	c12080e7          	jalr	-1006(ra) # 80006256 <release>
          release(&wait_lock);
    8000164c:	00008517          	auipc	a0,0x8
    80001650:	a1c50513          	addi	a0,a0,-1508 # 80009068 <wait_lock>
    80001654:	00005097          	auipc	ra,0x5
    80001658:	c02080e7          	jalr	-1022(ra) # 80006256 <release>
          return pid;
    8000165c:	a09d                	j	800016c2 <wait+0x100>
            release(&np->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	bf6080e7          	jalr	-1034(ra) # 80006256 <release>
            release(&wait_lock);
    80001668:	00008517          	auipc	a0,0x8
    8000166c:	a0050513          	addi	a0,a0,-1536 # 80009068 <wait_lock>
    80001670:	00005097          	auipc	ra,0x5
    80001674:	be6080e7          	jalr	-1050(ra) # 80006256 <release>
            return -1;
    80001678:	59fd                	li	s3,-1
    8000167a:	a0a1                	j	800016c2 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167c:	16848493          	addi	s1,s1,360
    80001680:	03348463          	beq	s1,s3,800016a8 <wait+0xe6>
      if(np->parent == p){
    80001684:	7c9c                	ld	a5,56(s1)
    80001686:	ff279be3          	bne	a5,s2,8000167c <wait+0xba>
        acquire(&np->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	b16080e7          	jalr	-1258(ra) # 800061a2 <acquire>
        if(np->state == ZOMBIE){
    80001694:	4c9c                	lw	a5,24(s1)
    80001696:	f94781e3          	beq	a5,s4,80001618 <wait+0x56>
        release(&np->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	bba080e7          	jalr	-1094(ra) # 80006256 <release>
        havekids = 1;
    800016a4:	8756                	mv	a4,s5
    800016a6:	bfd9                	j	8000167c <wait+0xba>
    if(!havekids || p->killed){
    800016a8:	c701                	beqz	a4,800016b0 <wait+0xee>
    800016aa:	02892783          	lw	a5,40(s2)
    800016ae:	c79d                	beqz	a5,800016dc <wait+0x11a>
      release(&wait_lock);
    800016b0:	00008517          	auipc	a0,0x8
    800016b4:	9b850513          	addi	a0,a0,-1608 # 80009068 <wait_lock>
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	b9e080e7          	jalr	-1122(ra) # 80006256 <release>
      return -1;
    800016c0:	59fd                	li	s3,-1
}
    800016c2:	854e                	mv	a0,s3
    800016c4:	60a6                	ld	ra,72(sp)
    800016c6:	6406                	ld	s0,64(sp)
    800016c8:	74e2                	ld	s1,56(sp)
    800016ca:	7942                	ld	s2,48(sp)
    800016cc:	79a2                	ld	s3,40(sp)
    800016ce:	7a02                	ld	s4,32(sp)
    800016d0:	6ae2                	ld	s5,24(sp)
    800016d2:	6b42                	ld	s6,16(sp)
    800016d4:	6ba2                	ld	s7,8(sp)
    800016d6:	6c02                	ld	s8,0(sp)
    800016d8:	6161                	addi	sp,sp,80
    800016da:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016dc:	85e2                	mv	a1,s8
    800016de:	854a                	mv	a0,s2
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	e7e080e7          	jalr	-386(ra) # 8000155e <sleep>
    havekids = 0;
    800016e8:	b715                	j	8000160c <wait+0x4a>

00000000800016ea <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ea:	7139                	addi	sp,sp,-64
    800016ec:	fc06                	sd	ra,56(sp)
    800016ee:	f822                	sd	s0,48(sp)
    800016f0:	f426                	sd	s1,40(sp)
    800016f2:	f04a                	sd	s2,32(sp)
    800016f4:	ec4e                	sd	s3,24(sp)
    800016f6:	e852                	sd	s4,16(sp)
    800016f8:	e456                	sd	s5,8(sp)
    800016fa:	0080                	addi	s0,sp,64
    800016fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	00008497          	auipc	s1,0x8
    80001702:	d8248493          	addi	s1,s1,-638 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001706:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001708:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170a:	0000d917          	auipc	s2,0xd
    8000170e:	77690913          	addi	s2,s2,1910 # 8000ee80 <tickslock>
    80001712:	a821                	j	8000172a <wakeup+0x40>
        p->state = RUNNABLE;
    80001714:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	b3c080e7          	jalr	-1220(ra) # 80006256 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	16848493          	addi	s1,s1,360
    80001726:	03248463          	beq	s1,s2,8000174e <wakeup+0x64>
    if(p != myproc()){
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	770080e7          	jalr	1904(ra) # 80000e9a <myproc>
    80001732:	fea488e3          	beq	s1,a0,80001722 <wakeup+0x38>
      acquire(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	a6a080e7          	jalr	-1430(ra) # 800061a2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4c9c                	lw	a5,24(s1)
    80001742:	fd379be3          	bne	a5,s3,80001718 <wakeup+0x2e>
    80001746:	709c                	ld	a5,32(s1)
    80001748:	fd4798e3          	bne	a5,s4,80001718 <wakeup+0x2e>
    8000174c:	b7e1                	j	80001714 <wakeup+0x2a>
    }
  }
}
    8000174e:	70e2                	ld	ra,56(sp)
    80001750:	7442                	ld	s0,48(sp)
    80001752:	74a2                	ld	s1,40(sp)
    80001754:	7902                	ld	s2,32(sp)
    80001756:	69e2                	ld	s3,24(sp)
    80001758:	6a42                	ld	s4,16(sp)
    8000175a:	6aa2                	ld	s5,8(sp)
    8000175c:	6121                	addi	sp,sp,64
    8000175e:	8082                	ret

0000000080001760 <reparent>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001772:	00008497          	auipc	s1,0x8
    80001776:	d0e48493          	addi	s1,s1,-754 # 80009480 <proc>
      pp->parent = initproc;
    8000177a:	00008a17          	auipc	s4,0x8
    8000177e:	896a0a13          	addi	s4,s4,-1898 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001782:	0000d997          	auipc	s3,0xd
    80001786:	6fe98993          	addi	s3,s3,1790 # 8000ee80 <tickslock>
    8000178a:	a029                	j	80001794 <reparent+0x34>
    8000178c:	16848493          	addi	s1,s1,360
    80001790:	01348d63          	beq	s1,s3,800017aa <reparent+0x4a>
    if(pp->parent == p){
    80001794:	7c9c                	ld	a5,56(s1)
    80001796:	ff279be3          	bne	a5,s2,8000178c <reparent+0x2c>
      pp->parent = initproc;
    8000179a:	000a3503          	ld	a0,0(s4)
    8000179e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	f4a080e7          	jalr	-182(ra) # 800016ea <wakeup>
    800017a8:	b7d5                	j	8000178c <reparent+0x2c>
}
    800017aa:	70a2                	ld	ra,40(sp)
    800017ac:	7402                	ld	s0,32(sp)
    800017ae:	64e2                	ld	s1,24(sp)
    800017b0:	6942                	ld	s2,16(sp)
    800017b2:	69a2                	ld	s3,8(sp)
    800017b4:	6a02                	ld	s4,0(sp)
    800017b6:	6145                	addi	sp,sp,48
    800017b8:	8082                	ret

00000000800017ba <exit>:
{
    800017ba:	7179                	addi	sp,sp,-48
    800017bc:	f406                	sd	ra,40(sp)
    800017be:	f022                	sd	s0,32(sp)
    800017c0:	ec26                	sd	s1,24(sp)
    800017c2:	e84a                	sd	s2,16(sp)
    800017c4:	e44e                	sd	s3,8(sp)
    800017c6:	e052                	sd	s4,0(sp)
    800017c8:	1800                	addi	s0,sp,48
    800017ca:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017cc:	fffff097          	auipc	ra,0xfffff
    800017d0:	6ce080e7          	jalr	1742(ra) # 80000e9a <myproc>
    800017d4:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d6:	00008797          	auipc	a5,0x8
    800017da:	83a7b783          	ld	a5,-1990(a5) # 80009010 <initproc>
    800017de:	0d050493          	addi	s1,a0,208
    800017e2:	15050913          	addi	s2,a0,336
    800017e6:	02a79363          	bne	a5,a0,8000180c <exit+0x52>
    panic("init exiting");
    800017ea:	00007517          	auipc	a0,0x7
    800017ee:	9f650513          	addi	a0,a0,-1546 # 800081e0 <etext+0x1e0>
    800017f2:	00004097          	auipc	ra,0x4
    800017f6:	466080e7          	jalr	1126(ra) # 80005c58 <panic>
      fileclose(f);
    800017fa:	00002097          	auipc	ra,0x2
    800017fe:	24c080e7          	jalr	588(ra) # 80003a46 <fileclose>
      p->ofile[fd] = 0;
    80001802:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001806:	04a1                	addi	s1,s1,8
    80001808:	01248563          	beq	s1,s2,80001812 <exit+0x58>
    if(p->ofile[fd]){
    8000180c:	6088                	ld	a0,0(s1)
    8000180e:	f575                	bnez	a0,800017fa <exit+0x40>
    80001810:	bfdd                	j	80001806 <exit+0x4c>
  begin_op();
    80001812:	00002097          	auipc	ra,0x2
    80001816:	d68080e7          	jalr	-664(ra) # 8000357a <begin_op>
  iput(p->cwd);
    8000181a:	1509b503          	ld	a0,336(s3)
    8000181e:	00001097          	auipc	ra,0x1
    80001822:	544080e7          	jalr	1348(ra) # 80002d62 <iput>
  end_op();
    80001826:	00002097          	auipc	ra,0x2
    8000182a:	dd4080e7          	jalr	-556(ra) # 800035fa <end_op>
  p->cwd = 0;
    8000182e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001832:	00008497          	auipc	s1,0x8
    80001836:	83648493          	addi	s1,s1,-1994 # 80009068 <wait_lock>
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	966080e7          	jalr	-1690(ra) # 800061a2 <acquire>
  reparent(p);
    80001844:	854e                	mv	a0,s3
    80001846:	00000097          	auipc	ra,0x0
    8000184a:	f1a080e7          	jalr	-230(ra) # 80001760 <reparent>
  wakeup(p->parent);
    8000184e:	0389b503          	ld	a0,56(s3)
    80001852:	00000097          	auipc	ra,0x0
    80001856:	e98080e7          	jalr	-360(ra) # 800016ea <wakeup>
  acquire(&p->lock);
    8000185a:	854e                	mv	a0,s3
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	946080e7          	jalr	-1722(ra) # 800061a2 <acquire>
  p->xstate = status;
    80001864:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001868:	4795                	li	a5,5
    8000186a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	9e6080e7          	jalr	-1562(ra) # 80006256 <release>
  sched();
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	bd4080e7          	jalr	-1068(ra) # 8000144c <sched>
  panic("zombie exit");
    80001880:	00007517          	auipc	a0,0x7
    80001884:	97050513          	addi	a0,a0,-1680 # 800081f0 <etext+0x1f0>
    80001888:	00004097          	auipc	ra,0x4
    8000188c:	3d0080e7          	jalr	976(ra) # 80005c58 <panic>

0000000080001890 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001890:	7179                	addi	sp,sp,-48
    80001892:	f406                	sd	ra,40(sp)
    80001894:	f022                	sd	s0,32(sp)
    80001896:	ec26                	sd	s1,24(sp)
    80001898:	e84a                	sd	s2,16(sp)
    8000189a:	e44e                	sd	s3,8(sp)
    8000189c:	1800                	addi	s0,sp,48
    8000189e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	00008497          	auipc	s1,0x8
    800018a4:	be048493          	addi	s1,s1,-1056 # 80009480 <proc>
    800018a8:	0000d997          	auipc	s3,0xd
    800018ac:	5d898993          	addi	s3,s3,1496 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018b0:	8526                	mv	a0,s1
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	8f0080e7          	jalr	-1808(ra) # 800061a2 <acquire>
    if(p->pid == pid){
    800018ba:	589c                	lw	a5,48(s1)
    800018bc:	01278d63          	beq	a5,s2,800018d6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	994080e7          	jalr	-1644(ra) # 80006256 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ca:	16848493          	addi	s1,s1,360
    800018ce:	ff3491e3          	bne	s1,s3,800018b0 <kill+0x20>
  }
  return -1;
    800018d2:	557d                	li	a0,-1
    800018d4:	a829                	j	800018ee <kill+0x5e>
      p->killed = 1;
    800018d6:	4785                	li	a5,1
    800018d8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018da:	4c98                	lw	a4,24(s1)
    800018dc:	4789                	li	a5,2
    800018de:	00f70f63          	beq	a4,a5,800018fc <kill+0x6c>
      release(&p->lock);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	972080e7          	jalr	-1678(ra) # 80006256 <release>
      return 0;
    800018ec:	4501                	li	a0,0
}
    800018ee:	70a2                	ld	ra,40(sp)
    800018f0:	7402                	ld	s0,32(sp)
    800018f2:	64e2                	ld	s1,24(sp)
    800018f4:	6942                	ld	s2,16(sp)
    800018f6:	69a2                	ld	s3,8(sp)
    800018f8:	6145                	addi	sp,sp,48
    800018fa:	8082                	ret
        p->state = RUNNABLE;
    800018fc:	478d                	li	a5,3
    800018fe:	cc9c                	sw	a5,24(s1)
    80001900:	b7cd                	j	800018e2 <kill+0x52>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	580080e7          	jalr	1408(ra) # 80000e9a <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	230080e7          	jalr	560(ra) # 80000b5c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	8de080e7          	jalr	-1826(ra) # 8000022a <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	52a080e7          	jalr	1322(ra) # 80000e9a <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	266080e7          	jalr	614(ra) # 80000be8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	888080e7          	jalr	-1912(ra) # 8000022a <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	2d6080e7          	jalr	726(ra) # 80005ca2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00008497          	auipc	s1,0x8
    800019d8:	c0448493          	addi	s1,s1,-1020 # 800095d8 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	5fc90913          	addi	s2,s2,1532 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	842b8b93          	addi	s7,s7,-1982 # 80008240 <states.1714>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	294080e7          	jalr	660(ra) # 80005ca2 <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	28a080e7          	jalr	650(ra) # 80005ca2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	16848493          	addi	s1,s1,360
    80001a24:	03248163          	beq	s1,s2,80001a46 <procdump+0x98>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	1782                	slli	a5,a5,0x20
    80001a38:	9381                	srli	a5,a5,0x20
    80001a3a:	078e                	slli	a5,a5,0x3
    80001a3c:	97de                	add	a5,a5,s7
    80001a3e:	6390                	ld	a2,0(a5)
    80001a40:	f661                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a42:	864e                	mv	a2,s3
    80001a44:	b7d1                	j	80001a08 <procdump+0x5a>
  }
}
    80001a46:	60a6                	ld	ra,72(sp)
    80001a48:	6406                	ld	s0,64(sp)
    80001a4a:	74e2                	ld	s1,56(sp)
    80001a4c:	7942                	ld	s2,48(sp)
    80001a4e:	79a2                	ld	s3,40(sp)
    80001a50:	7a02                	ld	s4,32(sp)
    80001a52:	6ae2                	ld	s5,24(sp)
    80001a54:	6b42                	ld	s6,16(sp)
    80001a56:	6ba2                	ld	s7,8(sp)
    80001a58:	6161                	addi	sp,sp,80
    80001a5a:	8082                	ret

0000000080001a5c <procnum>:

void
procnum(uint64* dst)
{
    80001a5c:	1141                	addi	sp,sp,-16
    80001a5e:	e422                	sd	s0,8(sp)
    80001a60:	0800                	addi	s0,sp,16
  *dst = 0;
    80001a62:	00053023          	sd	zero,0(a0)
  struct proc* p;
  // 不需要锁进程 proc 结构，因为我们只需要读取进程列表，不需要写
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a66:	00008797          	auipc	a5,0x8
    80001a6a:	a1a78793          	addi	a5,a5,-1510 # 80009480 <proc>
    80001a6e:	0000d697          	auipc	a3,0xd
    80001a72:	41268693          	addi	a3,a3,1042 # 8000ee80 <tickslock>
    80001a76:	a029                	j	80001a80 <procnum+0x24>
    80001a78:	16878793          	addi	a5,a5,360
    80001a7c:	00d78863          	beq	a5,a3,80001a8c <procnum+0x30>
    // 不是 UNUSED 的进程位，就是已经分配的
    if (p->state != UNUSED)
    80001a80:	4f98                	lw	a4,24(a5)
    80001a82:	db7d                	beqz	a4,80001a78 <procnum+0x1c>
      (*dst)++;
    80001a84:	6118                	ld	a4,0(a0)
    80001a86:	0705                	addi	a4,a4,1
    80001a88:	e118                	sd	a4,0(a0)
    80001a8a:	b7fd                	j	80001a78 <procnum+0x1c>
  }
}
    80001a8c:	6422                	ld	s0,8(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <swtch>:
    80001a92:	00153023          	sd	ra,0(a0)
    80001a96:	00253423          	sd	sp,8(a0)
    80001a9a:	e900                	sd	s0,16(a0)
    80001a9c:	ed04                	sd	s1,24(a0)
    80001a9e:	03253023          	sd	s2,32(a0)
    80001aa2:	03353423          	sd	s3,40(a0)
    80001aa6:	03453823          	sd	s4,48(a0)
    80001aaa:	03553c23          	sd	s5,56(a0)
    80001aae:	05653023          	sd	s6,64(a0)
    80001ab2:	05753423          	sd	s7,72(a0)
    80001ab6:	05853823          	sd	s8,80(a0)
    80001aba:	05953c23          	sd	s9,88(a0)
    80001abe:	07a53023          	sd	s10,96(a0)
    80001ac2:	07b53423          	sd	s11,104(a0)
    80001ac6:	0005b083          	ld	ra,0(a1)
    80001aca:	0085b103          	ld	sp,8(a1)
    80001ace:	6980                	ld	s0,16(a1)
    80001ad0:	6d84                	ld	s1,24(a1)
    80001ad2:	0205b903          	ld	s2,32(a1)
    80001ad6:	0285b983          	ld	s3,40(a1)
    80001ada:	0305ba03          	ld	s4,48(a1)
    80001ade:	0385ba83          	ld	s5,56(a1)
    80001ae2:	0405bb03          	ld	s6,64(a1)
    80001ae6:	0485bb83          	ld	s7,72(a1)
    80001aea:	0505bc03          	ld	s8,80(a1)
    80001aee:	0585bc83          	ld	s9,88(a1)
    80001af2:	0605bd03          	ld	s10,96(a1)
    80001af6:	0685bd83          	ld	s11,104(a1)
    80001afa:	8082                	ret

0000000080001afc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001afc:	1141                	addi	sp,sp,-16
    80001afe:	e406                	sd	ra,8(sp)
    80001b00:	e022                	sd	s0,0(sp)
    80001b02:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b04:	00006597          	auipc	a1,0x6
    80001b08:	76c58593          	addi	a1,a1,1900 # 80008270 <states.1714+0x30>
    80001b0c:	0000d517          	auipc	a0,0xd
    80001b10:	37450513          	addi	a0,a0,884 # 8000ee80 <tickslock>
    80001b14:	00004097          	auipc	ra,0x4
    80001b18:	5fe080e7          	jalr	1534(ra) # 80006112 <initlock>
}
    80001b1c:	60a2                	ld	ra,8(sp)
    80001b1e:	6402                	ld	s0,0(sp)
    80001b20:	0141                	addi	sp,sp,16
    80001b22:	8082                	ret

0000000080001b24 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b24:	1141                	addi	sp,sp,-16
    80001b26:	e422                	sd	s0,8(sp)
    80001b28:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b2a:	00003797          	auipc	a5,0x3
    80001b2e:	53678793          	addi	a5,a5,1334 # 80005060 <kernelvec>
    80001b32:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b36:	6422                	ld	s0,8(sp)
    80001b38:	0141                	addi	sp,sp,16
    80001b3a:	8082                	ret

0000000080001b3c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b3c:	1141                	addi	sp,sp,-16
    80001b3e:	e406                	sd	ra,8(sp)
    80001b40:	e022                	sd	s0,0(sp)
    80001b42:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b44:	fffff097          	auipc	ra,0xfffff
    80001b48:	356080e7          	jalr	854(ra) # 80000e9a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b52:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b56:	00005617          	auipc	a2,0x5
    80001b5a:	4aa60613          	addi	a2,a2,1194 # 80007000 <_trampoline>
    80001b5e:	00005697          	auipc	a3,0x5
    80001b62:	4a268693          	addi	a3,a3,1186 # 80007000 <_trampoline>
    80001b66:	8e91                	sub	a3,a3,a2
    80001b68:	040007b7          	lui	a5,0x4000
    80001b6c:	17fd                	addi	a5,a5,-1
    80001b6e:	07b2                	slli	a5,a5,0xc
    80001b70:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b72:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b76:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b78:	180026f3          	csrr	a3,satp
    80001b7c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b7e:	6d38                	ld	a4,88(a0)
    80001b80:	6134                	ld	a3,64(a0)
    80001b82:	6585                	lui	a1,0x1
    80001b84:	96ae                	add	a3,a3,a1
    80001b86:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b88:	6d38                	ld	a4,88(a0)
    80001b8a:	00000697          	auipc	a3,0x0
    80001b8e:	13868693          	addi	a3,a3,312 # 80001cc2 <usertrap>
    80001b92:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b94:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b96:	8692                	mv	a3,tp
    80001b98:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b9e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ba2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001baa:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bac:	6f18                	ld	a4,24(a4)
    80001bae:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bb2:	692c                	ld	a1,80(a0)
    80001bb4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb6:	00005717          	auipc	a4,0x5
    80001bba:	4da70713          	addi	a4,a4,1242 # 80007090 <userret>
    80001bbe:	8f11                	sub	a4,a4,a2
    80001bc0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bc2:	577d                	li	a4,-1
    80001bc4:	177e                	slli	a4,a4,0x3f
    80001bc6:	8dd9                	or	a1,a1,a4
    80001bc8:	02000537          	lui	a0,0x2000
    80001bcc:	157d                	addi	a0,a0,-1
    80001bce:	0536                	slli	a0,a0,0xd
    80001bd0:	9782                	jalr	a5
}
    80001bd2:	60a2                	ld	ra,8(sp)
    80001bd4:	6402                	ld	s0,0(sp)
    80001bd6:	0141                	addi	sp,sp,16
    80001bd8:	8082                	ret

0000000080001bda <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	e426                	sd	s1,8(sp)
    80001be2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be4:	0000d497          	auipc	s1,0xd
    80001be8:	29c48493          	addi	s1,s1,668 # 8000ee80 <tickslock>
    80001bec:	8526                	mv	a0,s1
    80001bee:	00004097          	auipc	ra,0x4
    80001bf2:	5b4080e7          	jalr	1460(ra) # 800061a2 <acquire>
  ticks++;
    80001bf6:	00007517          	auipc	a0,0x7
    80001bfa:	42250513          	addi	a0,a0,1058 # 80009018 <ticks>
    80001bfe:	411c                	lw	a5,0(a0)
    80001c00:	2785                	addiw	a5,a5,1
    80001c02:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c04:	00000097          	auipc	ra,0x0
    80001c08:	ae6080e7          	jalr	-1306(ra) # 800016ea <wakeup>
  release(&tickslock);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	648080e7          	jalr	1608(ra) # 80006256 <release>
}
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6105                	addi	sp,sp,32
    80001c1e:	8082                	ret

0000000080001c20 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c2a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c2e:	00074d63          	bltz	a4,80001c48 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c32:	57fd                	li	a5,-1
    80001c34:	17fe                	slli	a5,a5,0x3f
    80001c36:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c38:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c3a:	06f70363          	beq	a4,a5,80001ca0 <devintr+0x80>
  }
}
    80001c3e:	60e2                	ld	ra,24(sp)
    80001c40:	6442                	ld	s0,16(sp)
    80001c42:	64a2                	ld	s1,8(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
     (scause & 0xff) == 9){
    80001c48:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c4c:	46a5                	li	a3,9
    80001c4e:	fed792e3          	bne	a5,a3,80001c32 <devintr+0x12>
    int irq = plic_claim();
    80001c52:	00003097          	auipc	ra,0x3
    80001c56:	516080e7          	jalr	1302(ra) # 80005168 <plic_claim>
    80001c5a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c5c:	47a9                	li	a5,10
    80001c5e:	02f50763          	beq	a0,a5,80001c8c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c62:	4785                	li	a5,1
    80001c64:	02f50963          	beq	a0,a5,80001c96 <devintr+0x76>
    return 1;
    80001c68:	4505                	li	a0,1
    } else if(irq){
    80001c6a:	d8f1                	beqz	s1,80001c3e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	00006517          	auipc	a0,0x6
    80001c72:	60a50513          	addi	a0,a0,1546 # 80008278 <states.1714+0x38>
    80001c76:	00004097          	auipc	ra,0x4
    80001c7a:	02c080e7          	jalr	44(ra) # 80005ca2 <printf>
      plic_complete(irq);
    80001c7e:	8526                	mv	a0,s1
    80001c80:	00003097          	auipc	ra,0x3
    80001c84:	50c080e7          	jalr	1292(ra) # 8000518c <plic_complete>
    return 1;
    80001c88:	4505                	li	a0,1
    80001c8a:	bf55                	j	80001c3e <devintr+0x1e>
      uartintr();
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	436080e7          	jalr	1078(ra) # 800060c2 <uartintr>
    80001c94:	b7ed                	j	80001c7e <devintr+0x5e>
      virtio_disk_intr();
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	9d6080e7          	jalr	-1578(ra) # 8000566c <virtio_disk_intr>
    80001c9e:	b7c5                	j	80001c7e <devintr+0x5e>
    if(cpuid() == 0){
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	1ce080e7          	jalr	462(ra) # 80000e6e <cpuid>
    80001ca8:	c901                	beqz	a0,80001cb8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001caa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cb0:	14479073          	csrw	sip,a5
    return 2;
    80001cb4:	4509                	li	a0,2
    80001cb6:	b761                	j	80001c3e <devintr+0x1e>
      clockintr();
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	f22080e7          	jalr	-222(ra) # 80001bda <clockintr>
    80001cc0:	b7ed                	j	80001caa <devintr+0x8a>

0000000080001cc2 <usertrap>:
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	e04a                	sd	s2,0(sp)
    80001ccc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd2:	1007f793          	andi	a5,a5,256
    80001cd6:	e3ad                	bnez	a5,80001d38 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cd8:	00003797          	auipc	a5,0x3
    80001cdc:	38878793          	addi	a5,a5,904 # 80005060 <kernelvec>
    80001ce0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	1b6080e7          	jalr	438(ra) # 80000e9a <myproc>
    80001cec:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cee:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf0:	14102773          	csrr	a4,sepc
    80001cf4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cfa:	47a1                	li	a5,8
    80001cfc:	04f71c63          	bne	a4,a5,80001d54 <usertrap+0x92>
    if(p->killed)
    80001d00:	551c                	lw	a5,40(a0)
    80001d02:	e3b9                	bnez	a5,80001d48 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d04:	6cb8                	ld	a4,88(s1)
    80001d06:	6f1c                	ld	a5,24(a4)
    80001d08:	0791                	addi	a5,a5,4
    80001d0a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10079073          	csrw	sstatus,a5
    syscall();
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	2e0080e7          	jalr	736(ra) # 80001ff8 <syscall>
  if(p->killed)
    80001d20:	549c                	lw	a5,40(s1)
    80001d22:	ebc1                	bnez	a5,80001db2 <usertrap+0xf0>
  usertrapret();
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	e18080e7          	jalr	-488(ra) # 80001b3c <usertrapret>
}
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    panic("usertrap: not from user mode");
    80001d38:	00006517          	auipc	a0,0x6
    80001d3c:	56050513          	addi	a0,a0,1376 # 80008298 <states.1714+0x58>
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	f18080e7          	jalr	-232(ra) # 80005c58 <panic>
      exit(-1);
    80001d48:	557d                	li	a0,-1
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a70080e7          	jalr	-1424(ra) # 800017ba <exit>
    80001d52:	bf4d                	j	80001d04 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	ecc080e7          	jalr	-308(ra) # 80001c20 <devintr>
    80001d5c:	892a                	mv	s2,a0
    80001d5e:	c501                	beqz	a0,80001d66 <usertrap+0xa4>
  if(p->killed)
    80001d60:	549c                	lw	a5,40(s1)
    80001d62:	c3a1                	beqz	a5,80001da2 <usertrap+0xe0>
    80001d64:	a815                	j	80001d98 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d66:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d6a:	5890                	lw	a2,48(s1)
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	54c50513          	addi	a0,a0,1356 # 800082b8 <states.1714+0x78>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	f2e080e7          	jalr	-210(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d80:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	56450513          	addi	a0,a0,1380 # 800082e8 <states.1714+0xa8>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	f16080e7          	jalr	-234(ra) # 80005ca2 <printf>
    p->killed = 1;
    80001d94:	4785                	li	a5,1
    80001d96:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d98:	557d                	li	a0,-1
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	a20080e7          	jalr	-1504(ra) # 800017ba <exit>
  if(which_dev == 2)
    80001da2:	4789                	li	a5,2
    80001da4:	f8f910e3          	bne	s2,a5,80001d24 <usertrap+0x62>
    yield();
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	77a080e7          	jalr	1914(ra) # 80001522 <yield>
    80001db0:	bf95                	j	80001d24 <usertrap+0x62>
  int which_dev = 0;
    80001db2:	4901                	li	s2,0
    80001db4:	b7d5                	j	80001d98 <usertrap+0xd6>

0000000080001db6 <kerneltrap>:
{
    80001db6:	7179                	addi	sp,sp,-48
    80001db8:	f406                	sd	ra,40(sp)
    80001dba:	f022                	sd	s0,32(sp)
    80001dbc:	ec26                	sd	s1,24(sp)
    80001dbe:	e84a                	sd	s2,16(sp)
    80001dc0:	e44e                	sd	s3,8(sp)
    80001dc2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dcc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dd0:	1004f793          	andi	a5,s1,256
    80001dd4:	cb85                	beqz	a5,80001e04 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dda:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ddc:	ef85                	bnez	a5,80001e14 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	e42080e7          	jalr	-446(ra) # 80001c20 <devintr>
    80001de6:	cd1d                	beqz	a0,80001e24 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de8:	4789                	li	a5,2
    80001dea:	06f50a63          	beq	a0,a5,80001e5e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dee:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df2:	10049073          	csrw	sstatus,s1
}
    80001df6:	70a2                	ld	ra,40(sp)
    80001df8:	7402                	ld	s0,32(sp)
    80001dfa:	64e2                	ld	s1,24(sp)
    80001dfc:	6942                	ld	s2,16(sp)
    80001dfe:	69a2                	ld	s3,8(sp)
    80001e00:	6145                	addi	sp,sp,48
    80001e02:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	50450513          	addi	a0,a0,1284 # 80008308 <states.1714+0xc8>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	e4c080e7          	jalr	-436(ra) # 80005c58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e14:	00006517          	auipc	a0,0x6
    80001e18:	51c50513          	addi	a0,a0,1308 # 80008330 <states.1714+0xf0>
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	e3c080e7          	jalr	-452(ra) # 80005c58 <panic>
    printf("scause %p\n", scause);
    80001e24:	85ce                	mv	a1,s3
    80001e26:	00006517          	auipc	a0,0x6
    80001e2a:	52a50513          	addi	a0,a0,1322 # 80008350 <states.1714+0x110>
    80001e2e:	00004097          	auipc	ra,0x4
    80001e32:	e74080e7          	jalr	-396(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e36:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e3a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	52250513          	addi	a0,a0,1314 # 80008360 <states.1714+0x120>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	e5c080e7          	jalr	-420(ra) # 80005ca2 <printf>
    panic("kerneltrap");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	52a50513          	addi	a0,a0,1322 # 80008378 <states.1714+0x138>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	e02080e7          	jalr	-510(ra) # 80005c58 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	03c080e7          	jalr	60(ra) # 80000e9a <myproc>
    80001e66:	d541                	beqz	a0,80001dee <kerneltrap+0x38>
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	032080e7          	jalr	50(ra) # 80000e9a <myproc>
    80001e70:	4d18                	lw	a4,24(a0)
    80001e72:	4791                	li	a5,4
    80001e74:	f6f71de3          	bne	a4,a5,80001dee <kerneltrap+0x38>
    yield();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	6aa080e7          	jalr	1706(ra) # 80001522 <yield>
    80001e80:	b7bd                	j	80001dee <kerneltrap+0x38>

0000000080001e82 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e82:	1101                	addi	sp,sp,-32
    80001e84:	ec06                	sd	ra,24(sp)
    80001e86:	e822                	sd	s0,16(sp)
    80001e88:	e426                	sd	s1,8(sp)
    80001e8a:	1000                	addi	s0,sp,32
    80001e8c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	00c080e7          	jalr	12(ra) # 80000e9a <myproc>
  switch (n) {
    80001e96:	4795                	li	a5,5
    80001e98:	0497e163          	bltu	a5,s1,80001eda <argraw+0x58>
    80001e9c:	048a                	slli	s1,s1,0x2
    80001e9e:	00006717          	auipc	a4,0x6
    80001ea2:	5e270713          	addi	a4,a4,1506 # 80008480 <states.1714+0x240>
    80001ea6:	94ba                	add	s1,s1,a4
    80001ea8:	409c                	lw	a5,0(s1)
    80001eaa:	97ba                	add	a5,a5,a4
    80001eac:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eb2:	60e2                	ld	ra,24(sp)
    80001eb4:	6442                	ld	s0,16(sp)
    80001eb6:	64a2                	ld	s1,8(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret
    return p->trapframe->a1;
    80001ebc:	6d3c                	ld	a5,88(a0)
    80001ebe:	7fa8                	ld	a0,120(a5)
    80001ec0:	bfcd                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a2;
    80001ec2:	6d3c                	ld	a5,88(a0)
    80001ec4:	63c8                	ld	a0,128(a5)
    80001ec6:	b7f5                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a3;
    80001ec8:	6d3c                	ld	a5,88(a0)
    80001eca:	67c8                	ld	a0,136(a5)
    80001ecc:	b7dd                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a4;
    80001ece:	6d3c                	ld	a5,88(a0)
    80001ed0:	6bc8                	ld	a0,144(a5)
    80001ed2:	b7c5                	j	80001eb2 <argraw+0x30>
    return p->trapframe->a5;
    80001ed4:	6d3c                	ld	a5,88(a0)
    80001ed6:	6fc8                	ld	a0,152(a5)
    80001ed8:	bfe9                	j	80001eb2 <argraw+0x30>
  panic("argraw");
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	4ae50513          	addi	a0,a0,1198 # 80008388 <states.1714+0x148>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	d76080e7          	jalr	-650(ra) # 80005c58 <panic>

0000000080001eea <fetchaddr>:
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	e426                	sd	s1,8(sp)
    80001ef2:	e04a                	sd	s2,0(sp)
    80001ef4:	1000                	addi	s0,sp,32
    80001ef6:	84aa                	mv	s1,a0
    80001ef8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	fa0080e7          	jalr	-96(ra) # 80000e9a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f02:	653c                	ld	a5,72(a0)
    80001f04:	02f4f863          	bgeu	s1,a5,80001f34 <fetchaddr+0x4a>
    80001f08:	00848713          	addi	a4,s1,8
    80001f0c:	02e7e663          	bltu	a5,a4,80001f38 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f10:	46a1                	li	a3,8
    80001f12:	8626                	mv	a2,s1
    80001f14:	85ca                	mv	a1,s2
    80001f16:	6928                	ld	a0,80(a0)
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	cd0080e7          	jalr	-816(ra) # 80000be8 <copyin>
    80001f20:	00a03533          	snez	a0,a0
    80001f24:	40a00533          	neg	a0,a0
}
    80001f28:	60e2                	ld	ra,24(sp)
    80001f2a:	6442                	ld	s0,16(sp)
    80001f2c:	64a2                	ld	s1,8(sp)
    80001f2e:	6902                	ld	s2,0(sp)
    80001f30:	6105                	addi	sp,sp,32
    80001f32:	8082                	ret
    return -1;
    80001f34:	557d                	li	a0,-1
    80001f36:	bfcd                	j	80001f28 <fetchaddr+0x3e>
    80001f38:	557d                	li	a0,-1
    80001f3a:	b7fd                	j	80001f28 <fetchaddr+0x3e>

0000000080001f3c <fetchstr>:
{
    80001f3c:	7179                	addi	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	1800                	addi	s0,sp,48
    80001f4a:	892a                	mv	s2,a0
    80001f4c:	84ae                	mv	s1,a1
    80001f4e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	f4a080e7          	jalr	-182(ra) # 80000e9a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f58:	86ce                	mv	a3,s3
    80001f5a:	864a                	mv	a2,s2
    80001f5c:	85a6                	mv	a1,s1
    80001f5e:	6928                	ld	a0,80(a0)
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d14080e7          	jalr	-748(ra) # 80000c74 <copyinstr>
  if(err < 0)
    80001f68:	00054763          	bltz	a0,80001f76 <fetchstr+0x3a>
  return strlen(buf);
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	ffffe097          	auipc	ra,0xffffe
    80001f72:	3e0080e7          	jalr	992(ra) # 8000034e <strlen>
}
    80001f76:	70a2                	ld	ra,40(sp)
    80001f78:	7402                	ld	s0,32(sp)
    80001f7a:	64e2                	ld	s1,24(sp)
    80001f7c:	6942                	ld	s2,16(sp)
    80001f7e:	69a2                	ld	s3,8(sp)
    80001f80:	6145                	addi	sp,sp,48
    80001f82:	8082                	ret

0000000080001f84 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	1000                	addi	s0,sp,32
    80001f8e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	ef2080e7          	jalr	-270(ra) # 80001e82 <argraw>
    80001f98:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f9a:	4501                	li	a0,0
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fa6:	1101                	addi	sp,sp,-32
    80001fa8:	ec06                	sd	ra,24(sp)
    80001faa:	e822                	sd	s0,16(sp)
    80001fac:	e426                	sd	s1,8(sp)
    80001fae:	1000                	addi	s0,sp,32
    80001fb0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	ed0080e7          	jalr	-304(ra) # 80001e82 <argraw>
    80001fba:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fbc:	4501                	li	a0,0
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	64a2                	ld	s1,8(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	e04a                	sd	s2,0(sp)
    80001fd2:	1000                	addi	s0,sp,32
    80001fd4:	84ae                	mv	s1,a1
    80001fd6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	eaa080e7          	jalr	-342(ra) # 80001e82 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fe0:	864a                	mv	a2,s2
    80001fe2:	85a6                	mv	a1,s1
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	f58080e7          	jalr	-168(ra) # 80001f3c <fetchstr>
}
    80001fec:	60e2                	ld	ra,24(sp)
    80001fee:	6442                	ld	s0,16(sp)
    80001ff0:	64a2                	ld	s1,8(sp)
    80001ff2:	6902                	ld	s2,0(sp)
    80001ff4:	6105                	addi	sp,sp,32
    80001ff6:	8082                	ret

0000000080001ff8 <syscall>:
[SYS_sysinfo]   sys_sysinfo,
};

void
syscall(void)
{
    80001ff8:	7179                	addi	sp,sp,-48
    80001ffa:	f406                	sd	ra,40(sp)
    80001ffc:	f022                	sd	s0,32(sp)
    80001ffe:	ec26                	sd	s1,24(sp)
    80002000:	e84a                	sd	s2,16(sp)
    80002002:	e44e                	sd	s3,8(sp)
    80002004:	1800                	addi	s0,sp,48
  int num;
  struct proc* p = myproc();
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	e94080e7          	jalr	-364(ra) # 80000e9a <myproc>
    8000200e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;  // 系统调用编号，参见书中4.3节
    80002010:	05853903          	ld	s2,88(a0)
    80002014:	0a893783          	ld	a5,168(s2)
    80002018:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000201c:	37fd                	addiw	a5,a5,-1
    8000201e:	4759                	li	a4,22
    80002020:	04f76763          	bltu	a4,a5,8000206e <syscall+0x76>
    80002024:	00399713          	slli	a4,s3,0x3
    80002028:	00006797          	auipc	a5,0x6
    8000202c:	47078793          	addi	a5,a5,1136 # 80008498 <syscalls>
    80002030:	97ba                	add	a5,a5,a4
    80002032:	639c                	ld	a5,0(a5)
    80002034:	cf8d                	beqz	a5,8000206e <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();  // 执行系统调用，然后将返回值存入a0
    80002036:	9782                	jalr	a5
    80002038:	06a93823          	sd	a0,112(s2)

    // 系统调用是否匹配 -- 位运算判断
    //如果我们要追踪read,那么trace_mask的值为32,也就是10000
    //假如当前系统调用号为5,那么1左移五位为: 10000
    //此时相与得到1,说明是我们需要追踪的系统调用,则进行打点记录
    if ((1 << num) & p->trace_mask)
    8000203c:	58dc                	lw	a5,52(s1)
    8000203e:	4137d7bb          	sraw	a5,a5,s3
    80002042:	8b85                	andi	a5,a5,1
    80002044:	c7a1                	beqz	a5,8000208c <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    80002046:	6cb8                	ld	a4,88(s1)
    80002048:	098e                	slli	s3,s3,0x3
    8000204a:	00006797          	auipc	a5,0x6
    8000204e:	44e78793          	addi	a5,a5,1102 # 80008498 <syscalls>
    80002052:	99be                	add	s3,s3,a5
    80002054:	7b34                	ld	a3,112(a4)
    80002056:	0c09b603          	ld	a2,192(s3)
    8000205a:	588c                	lw	a1,48(s1)
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	33450513          	addi	a0,a0,820 # 80008390 <states.1714+0x150>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	c3e080e7          	jalr	-962(ra) # 80005ca2 <printf>
    8000206c:	a005                	j	8000208c <syscall+0x94>
  }
  else {
    printf("%d %s: unknown sys call %d\n",
    8000206e:	86ce                	mv	a3,s3
    80002070:	15848613          	addi	a2,s1,344
    80002074:	588c                	lw	a1,48(s1)
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	33250513          	addi	a0,a0,818 # 800083a8 <states.1714+0x168>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	c24080e7          	jalr	-988(ra) # 80005ca2 <printf>
      p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002086:	6cbc                	ld	a5,88(s1)
    80002088:	577d                	li	a4,-1
    8000208a:	fbb8                	sd	a4,112(a5)
  }
}
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	69a2                	ld	s3,8(sp)
    80002096:	6145                	addi	sp,sp,48
    80002098:	8082                	ret

000000008000209a <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020a2:	fec40593          	addi	a1,s0,-20
    800020a6:	4501                	li	a0,0
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	edc080e7          	jalr	-292(ra) # 80001f84 <argint>
    return -1;
    800020b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020b2:	00054963          	bltz	a0,800020c4 <sys_exit+0x2a>
  exit(n);
    800020b6:	fec42503          	lw	a0,-20(s0)
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	700080e7          	jalr	1792(ra) # 800017ba <exit>
  return 0;  // not reached
    800020c2:	4781                	li	a5,0
}
    800020c4:	853e                	mv	a0,a5
    800020c6:	60e2                	ld	ra,24(sp)
    800020c8:	6442                	ld	s0,16(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800020ce:	1141                	addi	sp,sp,-16
    800020d0:	e406                	sd	ra,8(sp)
    800020d2:	e022                	sd	s0,0(sp)
    800020d4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	dc4080e7          	jalr	-572(ra) # 80000e9a <myproc>
}
    800020de:	5908                	lw	a0,48(a0)
    800020e0:	60a2                	ld	ra,8(sp)
    800020e2:	6402                	ld	s0,0(sp)
    800020e4:	0141                	addi	sp,sp,16
    800020e6:	8082                	ret

00000000800020e8 <sys_fork>:

uint64
sys_fork(void)
{
    800020e8:	1141                	addi	sp,sp,-16
    800020ea:	e406                	sd	ra,8(sp)
    800020ec:	e022                	sd	s0,0(sp)
    800020ee:	0800                	addi	s0,sp,16
  return fork();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	178080e7          	jalr	376(ra) # 80001268 <fork>
}
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_wait>:

uint64
sys_wait(void)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002108:	fe840593          	addi	a1,s0,-24
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	e98080e7          	jalr	-360(ra) # 80001fa6 <argaddr>
    80002116:	87aa                	mv	a5,a0
    return -1;
    80002118:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000211a:	0007c863          	bltz	a5,8000212a <sys_wait+0x2a>
  return wait(p);
    8000211e:	fe843503          	ld	a0,-24(s0)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	4a0080e7          	jalr	1184(ra) # 800015c2 <wait>
}
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret

0000000080002132 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002132:	7179                	addi	sp,sp,-48
    80002134:	f406                	sd	ra,40(sp)
    80002136:	f022                	sd	s0,32(sp)
    80002138:	ec26                	sd	s1,24(sp)
    8000213a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000213c:	fdc40593          	addi	a1,s0,-36
    80002140:	4501                	li	a0,0
    80002142:	00000097          	auipc	ra,0x0
    80002146:	e42080e7          	jalr	-446(ra) # 80001f84 <argint>
    8000214a:	87aa                	mv	a5,a0
    return -1;
    8000214c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000214e:	0207c063          	bltz	a5,8000216e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	d48080e7          	jalr	-696(ra) # 80000e9a <myproc>
    8000215a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000215c:	fdc42503          	lw	a0,-36(s0)
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	094080e7          	jalr	148(ra) # 800011f4 <growproc>
    80002168:	00054863          	bltz	a0,80002178 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000216c:	8526                	mv	a0,s1
}
    8000216e:	70a2                	ld	ra,40(sp)
    80002170:	7402                	ld	s0,32(sp)
    80002172:	64e2                	ld	s1,24(sp)
    80002174:	6145                	addi	sp,sp,48
    80002176:	8082                	ret
    return -1;
    80002178:	557d                	li	a0,-1
    8000217a:	bfd5                	j	8000216e <sys_sbrk+0x3c>

000000008000217c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000217c:	7139                	addi	sp,sp,-64
    8000217e:	fc06                	sd	ra,56(sp)
    80002180:	f822                	sd	s0,48(sp)
    80002182:	f426                	sd	s1,40(sp)
    80002184:	f04a                	sd	s2,32(sp)
    80002186:	ec4e                	sd	s3,24(sp)
    80002188:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000218a:	fcc40593          	addi	a1,s0,-52
    8000218e:	4501                	li	a0,0
    80002190:	00000097          	auipc	ra,0x0
    80002194:	df4080e7          	jalr	-524(ra) # 80001f84 <argint>
    return -1;
    80002198:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000219a:	06054563          	bltz	a0,80002204 <sys_sleep+0x88>
  acquire(&tickslock);
    8000219e:	0000d517          	auipc	a0,0xd
    800021a2:	ce250513          	addi	a0,a0,-798 # 8000ee80 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	ffc080e7          	jalr	-4(ra) # 800061a2 <acquire>
  ticks0 = ticks;
    800021ae:	00007917          	auipc	s2,0x7
    800021b2:	e6a92903          	lw	s2,-406(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021b6:	fcc42783          	lw	a5,-52(s0)
    800021ba:	cf85                	beqz	a5,800021f2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021bc:	0000d997          	auipc	s3,0xd
    800021c0:	cc498993          	addi	s3,s3,-828 # 8000ee80 <tickslock>
    800021c4:	00007497          	auipc	s1,0x7
    800021c8:	e5448493          	addi	s1,s1,-428 # 80009018 <ticks>
    if(myproc()->killed){
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	cce080e7          	jalr	-818(ra) # 80000e9a <myproc>
    800021d4:	551c                	lw	a5,40(a0)
    800021d6:	ef9d                	bnez	a5,80002214 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021d8:	85ce                	mv	a1,s3
    800021da:	8526                	mv	a0,s1
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	382080e7          	jalr	898(ra) # 8000155e <sleep>
  while(ticks - ticks0 < n){
    800021e4:	409c                	lw	a5,0(s1)
    800021e6:	412787bb          	subw	a5,a5,s2
    800021ea:	fcc42703          	lw	a4,-52(s0)
    800021ee:	fce7efe3          	bltu	a5,a4,800021cc <sys_sleep+0x50>
  }
  release(&tickslock);
    800021f2:	0000d517          	auipc	a0,0xd
    800021f6:	c8e50513          	addi	a0,a0,-882 # 8000ee80 <tickslock>
    800021fa:	00004097          	auipc	ra,0x4
    800021fe:	05c080e7          	jalr	92(ra) # 80006256 <release>
  return 0;
    80002202:	4781                	li	a5,0
}
    80002204:	853e                	mv	a0,a5
    80002206:	70e2                	ld	ra,56(sp)
    80002208:	7442                	ld	s0,48(sp)
    8000220a:	74a2                	ld	s1,40(sp)
    8000220c:	7902                	ld	s2,32(sp)
    8000220e:	69e2                	ld	s3,24(sp)
    80002210:	6121                	addi	sp,sp,64
    80002212:	8082                	ret
      release(&tickslock);
    80002214:	0000d517          	auipc	a0,0xd
    80002218:	c6c50513          	addi	a0,a0,-916 # 8000ee80 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	03a080e7          	jalr	58(ra) # 80006256 <release>
      return -1;
    80002224:	57fd                	li	a5,-1
    80002226:	bff9                	j	80002204 <sys_sleep+0x88>

0000000080002228 <sys_kill>:

uint64
sys_kill(void)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002230:	fec40593          	addi	a1,s0,-20
    80002234:	4501                	li	a0,0
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	d4e080e7          	jalr	-690(ra) # 80001f84 <argint>
    8000223e:	87aa                	mv	a5,a0
    return -1;
    80002240:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002242:	0007c863          	bltz	a5,80002252 <sys_kill+0x2a>
  return kill(pid);
    80002246:	fec42503          	lw	a0,-20(s0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	646080e7          	jalr	1606(ra) # 80001890 <kill>
}
    80002252:	60e2                	ld	ra,24(sp)
    80002254:	6442                	ld	s0,16(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	c1c50513          	addi	a0,a0,-996 # 8000ee80 <tickslock>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	f36080e7          	jalr	-202(ra) # 800061a2 <acquire>
  xticks = ticks;
    80002274:	00007497          	auipc	s1,0x7
    80002278:	da44a483          	lw	s1,-604(s1) # 80009018 <ticks>
  release(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	c0450513          	addi	a0,a0,-1020 # 8000ee80 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	fd2080e7          	jalr	-46(ra) # 80006256 <release>
  return xticks;
}
    8000228c:	02049513          	slli	a0,s1,0x20
    80002290:	9101                	srli	a0,a0,0x20
    80002292:	60e2                	ld	ra,24(sp)
    80002294:	6442                	ld	s0,16(sp)
    80002296:	64a2                	ld	s1,8(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000229c:	7179                	addi	sp,sp,-48
    8000229e:	f406                	sd	ra,40(sp)
    800022a0:	f022                	sd	s0,32(sp)
    800022a2:	1800                	addi	s0,sp,48
  struct sysinfo info;
  freebytes(&info.freemem);
    800022a4:	fe040513          	addi	a0,s0,-32
    800022a8:	ffffe097          	auipc	ra,0xffffe
    800022ac:	ed0080e7          	jalr	-304(ra) # 80000178 <freebytes>
  procnum(&info.nproc);
    800022b0:	fe840513          	addi	a0,s0,-24
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	7a8080e7          	jalr	1960(ra) # 80001a5c <procnum>

  // a0寄存器作为系统调用的参数寄存器,从中取出存放 sysinfo 结构的用户态缓冲区指针
  uint64 dstaddr;
  argaddr(0, &dstaddr);
    800022bc:	fd840593          	addi	a1,s0,-40
    800022c0:	4501                	li	a0,0
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	ce4080e7          	jalr	-796(ra) # 80001fa6 <argaddr>

  // 使用 copyout，结合当前进程的页表，获得进程传进来的指针（逻辑地址）对应的物理地址
  // 然后将 &sinfo 中的数据复制到该指针所指位置，供用户进程使用。
  if (copyout(myproc()->pagetable, dstaddr, (char*)&info, sizeof info) < 0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	bd0080e7          	jalr	-1072(ra) # 80000e9a <myproc>
    800022d2:	46c1                	li	a3,16
    800022d4:	fe040613          	addi	a2,s0,-32
    800022d8:	fd843583          	ld	a1,-40(s0)
    800022dc:	6928                	ld	a0,80(a0)
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	87e080e7          	jalr	-1922(ra) # 80000b5c <copyout>
    return -1;

  return 0;
}
    800022e6:	957d                	srai	a0,a0,0x3f
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	6145                	addi	sp,sp,48
    800022ee:	8082                	ret

00000000800022f0 <sys_trace>:

uint64
sys_trace(void)
{
    800022f0:	1141                	addi	sp,sp,-16
    800022f2:	e406                	sd	ra,8(sp)
    800022f4:	e022                	sd	s0,0(sp)
    800022f6:	0800                	addi	s0,sp,16
  // 获取系统调用的参数
  argint(0, &(myproc()->trace_mask));
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	ba2080e7          	jalr	-1118(ra) # 80000e9a <myproc>
    80002300:	03450593          	addi	a1,a0,52
    80002304:	4501                	li	a0,0
    80002306:	00000097          	auipc	ra,0x0
    8000230a:	c7e080e7          	jalr	-898(ra) # 80001f84 <argint>
  return 0;
}
    8000230e:	4501                	li	a0,0
    80002310:	60a2                	ld	ra,8(sp)
    80002312:	6402                	ld	s0,0(sp)
    80002314:	0141                	addi	sp,sp,16
    80002316:	8082                	ret

0000000080002318 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002318:	7179                	addi	sp,sp,-48
    8000231a:	f406                	sd	ra,40(sp)
    8000231c:	f022                	sd	s0,32(sp)
    8000231e:	ec26                	sd	s1,24(sp)
    80002320:	e84a                	sd	s2,16(sp)
    80002322:	e44e                	sd	s3,8(sp)
    80002324:	e052                	sd	s4,0(sp)
    80002326:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002328:	00006597          	auipc	a1,0x6
    8000232c:	2f058593          	addi	a1,a1,752 # 80008618 <syscalls_name+0xc0>
    80002330:	0000d517          	auipc	a0,0xd
    80002334:	b6850513          	addi	a0,a0,-1176 # 8000ee98 <bcache>
    80002338:	00004097          	auipc	ra,0x4
    8000233c:	dda080e7          	jalr	-550(ra) # 80006112 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002340:	00015797          	auipc	a5,0x15
    80002344:	b5878793          	addi	a5,a5,-1192 # 80016e98 <bcache+0x8000>
    80002348:	00015717          	auipc	a4,0x15
    8000234c:	db870713          	addi	a4,a4,-584 # 80017100 <bcache+0x8268>
    80002350:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002354:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002358:	0000d497          	auipc	s1,0xd
    8000235c:	b5848493          	addi	s1,s1,-1192 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002360:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002362:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002364:	00006a17          	auipc	s4,0x6
    80002368:	2bca0a13          	addi	s4,s4,700 # 80008620 <syscalls_name+0xc8>
    b->next = bcache.head.next;
    8000236c:	2b893783          	ld	a5,696(s2)
    80002370:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002372:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002376:	85d2                	mv	a1,s4
    80002378:	01048513          	addi	a0,s1,16
    8000237c:	00001097          	auipc	ra,0x1
    80002380:	4bc080e7          	jalr	1212(ra) # 80003838 <initsleeplock>
    bcache.head.next->prev = b;
    80002384:	2b893783          	ld	a5,696(s2)
    80002388:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000238a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000238e:	45848493          	addi	s1,s1,1112
    80002392:	fd349de3          	bne	s1,s3,8000236c <binit+0x54>
  }
}
    80002396:	70a2                	ld	ra,40(sp)
    80002398:	7402                	ld	s0,32(sp)
    8000239a:	64e2                	ld	s1,24(sp)
    8000239c:	6942                	ld	s2,16(sp)
    8000239e:	69a2                	ld	s3,8(sp)
    800023a0:	6a02                	ld	s4,0(sp)
    800023a2:	6145                	addi	sp,sp,48
    800023a4:	8082                	ret

00000000800023a6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023a6:	7179                	addi	sp,sp,-48
    800023a8:	f406                	sd	ra,40(sp)
    800023aa:	f022                	sd	s0,32(sp)
    800023ac:	ec26                	sd	s1,24(sp)
    800023ae:	e84a                	sd	s2,16(sp)
    800023b0:	e44e                	sd	s3,8(sp)
    800023b2:	1800                	addi	s0,sp,48
    800023b4:	89aa                	mv	s3,a0
    800023b6:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023b8:	0000d517          	auipc	a0,0xd
    800023bc:	ae050513          	addi	a0,a0,-1312 # 8000ee98 <bcache>
    800023c0:	00004097          	auipc	ra,0x4
    800023c4:	de2080e7          	jalr	-542(ra) # 800061a2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c8:	00015497          	auipc	s1,0x15
    800023cc:	d884b483          	ld	s1,-632(s1) # 80017150 <bcache+0x82b8>
    800023d0:	00015797          	auipc	a5,0x15
    800023d4:	d3078793          	addi	a5,a5,-720 # 80017100 <bcache+0x8268>
    800023d8:	02f48f63          	beq	s1,a5,80002416 <bread+0x70>
    800023dc:	873e                	mv	a4,a5
    800023de:	a021                	j	800023e6 <bread+0x40>
    800023e0:	68a4                	ld	s1,80(s1)
    800023e2:	02e48a63          	beq	s1,a4,80002416 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023e6:	449c                	lw	a5,8(s1)
    800023e8:	ff379ce3          	bne	a5,s3,800023e0 <bread+0x3a>
    800023ec:	44dc                	lw	a5,12(s1)
    800023ee:	ff2799e3          	bne	a5,s2,800023e0 <bread+0x3a>
      b->refcnt++;
    800023f2:	40bc                	lw	a5,64(s1)
    800023f4:	2785                	addiw	a5,a5,1
    800023f6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f8:	0000d517          	auipc	a0,0xd
    800023fc:	aa050513          	addi	a0,a0,-1376 # 8000ee98 <bcache>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	e56080e7          	jalr	-426(ra) # 80006256 <release>
      acquiresleep(&b->lock);
    80002408:	01048513          	addi	a0,s1,16
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	466080e7          	jalr	1126(ra) # 80003872 <acquiresleep>
      return b;
    80002414:	a8b9                	j	80002472 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002416:	00015497          	auipc	s1,0x15
    8000241a:	d324b483          	ld	s1,-718(s1) # 80017148 <bcache+0x82b0>
    8000241e:	00015797          	auipc	a5,0x15
    80002422:	ce278793          	addi	a5,a5,-798 # 80017100 <bcache+0x8268>
    80002426:	00f48863          	beq	s1,a5,80002436 <bread+0x90>
    8000242a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	cf81                	beqz	a5,80002446 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002430:	64a4                	ld	s1,72(s1)
    80002432:	fee49de3          	bne	s1,a4,8000242c <bread+0x86>
  panic("bget: no buffers");
    80002436:	00006517          	auipc	a0,0x6
    8000243a:	1f250513          	addi	a0,a0,498 # 80008628 <syscalls_name+0xd0>
    8000243e:	00004097          	auipc	ra,0x4
    80002442:	81a080e7          	jalr	-2022(ra) # 80005c58 <panic>
      b->dev = dev;
    80002446:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000244a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000244e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002452:	4785                	li	a5,1
    80002454:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002456:	0000d517          	auipc	a0,0xd
    8000245a:	a4250513          	addi	a0,a0,-1470 # 8000ee98 <bcache>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	df8080e7          	jalr	-520(ra) # 80006256 <release>
      acquiresleep(&b->lock);
    80002466:	01048513          	addi	a0,s1,16
    8000246a:	00001097          	auipc	ra,0x1
    8000246e:	408080e7          	jalr	1032(ra) # 80003872 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002472:	409c                	lw	a5,0(s1)
    80002474:	cb89                	beqz	a5,80002486 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002476:	8526                	mv	a0,s1
    80002478:	70a2                	ld	ra,40(sp)
    8000247a:	7402                	ld	s0,32(sp)
    8000247c:	64e2                	ld	s1,24(sp)
    8000247e:	6942                	ld	s2,16(sp)
    80002480:	69a2                	ld	s3,8(sp)
    80002482:	6145                	addi	sp,sp,48
    80002484:	8082                	ret
    virtio_disk_rw(b, 0);
    80002486:	4581                	li	a1,0
    80002488:	8526                	mv	a0,s1
    8000248a:	00003097          	auipc	ra,0x3
    8000248e:	f0c080e7          	jalr	-244(ra) # 80005396 <virtio_disk_rw>
    b->valid = 1;
    80002492:	4785                	li	a5,1
    80002494:	c09c                	sw	a5,0(s1)
  return b;
    80002496:	b7c5                	j	80002476 <bread+0xd0>

0000000080002498 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002498:	1101                	addi	sp,sp,-32
    8000249a:	ec06                	sd	ra,24(sp)
    8000249c:	e822                	sd	s0,16(sp)
    8000249e:	e426                	sd	s1,8(sp)
    800024a0:	1000                	addi	s0,sp,32
    800024a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024a4:	0541                	addi	a0,a0,16
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	466080e7          	jalr	1126(ra) # 8000390c <holdingsleep>
    800024ae:	cd01                	beqz	a0,800024c6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024b0:	4585                	li	a1,1
    800024b2:	8526                	mv	a0,s1
    800024b4:	00003097          	auipc	ra,0x3
    800024b8:	ee2080e7          	jalr	-286(ra) # 80005396 <virtio_disk_rw>
}
    800024bc:	60e2                	ld	ra,24(sp)
    800024be:	6442                	ld	s0,16(sp)
    800024c0:	64a2                	ld	s1,8(sp)
    800024c2:	6105                	addi	sp,sp,32
    800024c4:	8082                	ret
    panic("bwrite");
    800024c6:	00006517          	auipc	a0,0x6
    800024ca:	17a50513          	addi	a0,a0,378 # 80008640 <syscalls_name+0xe8>
    800024ce:	00003097          	auipc	ra,0x3
    800024d2:	78a080e7          	jalr	1930(ra) # 80005c58 <panic>

00000000800024d6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024d6:	1101                	addi	sp,sp,-32
    800024d8:	ec06                	sd	ra,24(sp)
    800024da:	e822                	sd	s0,16(sp)
    800024dc:	e426                	sd	s1,8(sp)
    800024de:	e04a                	sd	s2,0(sp)
    800024e0:	1000                	addi	s0,sp,32
    800024e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e4:	01050913          	addi	s2,a0,16
    800024e8:	854a                	mv	a0,s2
    800024ea:	00001097          	auipc	ra,0x1
    800024ee:	422080e7          	jalr	1058(ra) # 8000390c <holdingsleep>
    800024f2:	c92d                	beqz	a0,80002564 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024f4:	854a                	mv	a0,s2
    800024f6:	00001097          	auipc	ra,0x1
    800024fa:	3d2080e7          	jalr	978(ra) # 800038c8 <releasesleep>

  acquire(&bcache.lock);
    800024fe:	0000d517          	auipc	a0,0xd
    80002502:	99a50513          	addi	a0,a0,-1638 # 8000ee98 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	c9c080e7          	jalr	-868(ra) # 800061a2 <acquire>
  b->refcnt--;
    8000250e:	40bc                	lw	a5,64(s1)
    80002510:	37fd                	addiw	a5,a5,-1
    80002512:	0007871b          	sext.w	a4,a5
    80002516:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002518:	eb05                	bnez	a4,80002548 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000251a:	68bc                	ld	a5,80(s1)
    8000251c:	64b8                	ld	a4,72(s1)
    8000251e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002520:	64bc                	ld	a5,72(s1)
    80002522:	68b8                	ld	a4,80(s1)
    80002524:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002526:	00015797          	auipc	a5,0x15
    8000252a:	97278793          	addi	a5,a5,-1678 # 80016e98 <bcache+0x8000>
    8000252e:	2b87b703          	ld	a4,696(a5)
    80002532:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002534:	00015717          	auipc	a4,0x15
    80002538:	bcc70713          	addi	a4,a4,-1076 # 80017100 <bcache+0x8268>
    8000253c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000253e:	2b87b703          	ld	a4,696(a5)
    80002542:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002544:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002548:	0000d517          	auipc	a0,0xd
    8000254c:	95050513          	addi	a0,a0,-1712 # 8000ee98 <bcache>
    80002550:	00004097          	auipc	ra,0x4
    80002554:	d06080e7          	jalr	-762(ra) # 80006256 <release>
}
    80002558:	60e2                	ld	ra,24(sp)
    8000255a:	6442                	ld	s0,16(sp)
    8000255c:	64a2                	ld	s1,8(sp)
    8000255e:	6902                	ld	s2,0(sp)
    80002560:	6105                	addi	sp,sp,32
    80002562:	8082                	ret
    panic("brelse");
    80002564:	00006517          	auipc	a0,0x6
    80002568:	0e450513          	addi	a0,a0,228 # 80008648 <syscalls_name+0xf0>
    8000256c:	00003097          	auipc	ra,0x3
    80002570:	6ec080e7          	jalr	1772(ra) # 80005c58 <panic>

0000000080002574 <bpin>:

void
bpin(struct buf *b) {
    80002574:	1101                	addi	sp,sp,-32
    80002576:	ec06                	sd	ra,24(sp)
    80002578:	e822                	sd	s0,16(sp)
    8000257a:	e426                	sd	s1,8(sp)
    8000257c:	1000                	addi	s0,sp,32
    8000257e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	91850513          	addi	a0,a0,-1768 # 8000ee98 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	c1a080e7          	jalr	-998(ra) # 800061a2 <acquire>
  b->refcnt++;
    80002590:	40bc                	lw	a5,64(s1)
    80002592:	2785                	addiw	a5,a5,1
    80002594:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002596:	0000d517          	auipc	a0,0xd
    8000259a:	90250513          	addi	a0,a0,-1790 # 8000ee98 <bcache>
    8000259e:	00004097          	auipc	ra,0x4
    800025a2:	cb8080e7          	jalr	-840(ra) # 80006256 <release>
}
    800025a6:	60e2                	ld	ra,24(sp)
    800025a8:	6442                	ld	s0,16(sp)
    800025aa:	64a2                	ld	s1,8(sp)
    800025ac:	6105                	addi	sp,sp,32
    800025ae:	8082                	ret

00000000800025b0 <bunpin>:

void
bunpin(struct buf *b) {
    800025b0:	1101                	addi	sp,sp,-32
    800025b2:	ec06                	sd	ra,24(sp)
    800025b4:	e822                	sd	s0,16(sp)
    800025b6:	e426                	sd	s1,8(sp)
    800025b8:	1000                	addi	s0,sp,32
    800025ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	8dc50513          	addi	a0,a0,-1828 # 8000ee98 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	bde080e7          	jalr	-1058(ra) # 800061a2 <acquire>
  b->refcnt--;
    800025cc:	40bc                	lw	a5,64(s1)
    800025ce:	37fd                	addiw	a5,a5,-1
    800025d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d2:	0000d517          	auipc	a0,0xd
    800025d6:	8c650513          	addi	a0,a0,-1850 # 8000ee98 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	c7c080e7          	jalr	-900(ra) # 80006256 <release>
}
    800025e2:	60e2                	ld	ra,24(sp)
    800025e4:	6442                	ld	s0,16(sp)
    800025e6:	64a2                	ld	s1,8(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret

00000000800025ec <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	e04a                	sd	s2,0(sp)
    800025f6:	1000                	addi	s0,sp,32
    800025f8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025fa:	00d5d59b          	srliw	a1,a1,0xd
    800025fe:	00015797          	auipc	a5,0x15
    80002602:	f767a783          	lw	a5,-138(a5) # 80017574 <sb+0x1c>
    80002606:	9dbd                	addw	a1,a1,a5
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	d9e080e7          	jalr	-610(ra) # 800023a6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002610:	0074f713          	andi	a4,s1,7
    80002614:	4785                	li	a5,1
    80002616:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000261a:	14ce                	slli	s1,s1,0x33
    8000261c:	90d9                	srli	s1,s1,0x36
    8000261e:	00950733          	add	a4,a0,s1
    80002622:	05874703          	lbu	a4,88(a4)
    80002626:	00e7f6b3          	and	a3,a5,a4
    8000262a:	c69d                	beqz	a3,80002658 <bfree+0x6c>
    8000262c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000262e:	94aa                	add	s1,s1,a0
    80002630:	fff7c793          	not	a5,a5
    80002634:	8ff9                	and	a5,a5,a4
    80002636:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	118080e7          	jalr	280(ra) # 80003752 <log_write>
  brelse(bp);
    80002642:	854a                	mv	a0,s2
    80002644:	00000097          	auipc	ra,0x0
    80002648:	e92080e7          	jalr	-366(ra) # 800024d6 <brelse>
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	64a2                	ld	s1,8(sp)
    80002652:	6902                	ld	s2,0(sp)
    80002654:	6105                	addi	sp,sp,32
    80002656:	8082                	ret
    panic("freeing free block");
    80002658:	00006517          	auipc	a0,0x6
    8000265c:	ff850513          	addi	a0,a0,-8 # 80008650 <syscalls_name+0xf8>
    80002660:	00003097          	auipc	ra,0x3
    80002664:	5f8080e7          	jalr	1528(ra) # 80005c58 <panic>

0000000080002668 <balloc>:
{
    80002668:	711d                	addi	sp,sp,-96
    8000266a:	ec86                	sd	ra,88(sp)
    8000266c:	e8a2                	sd	s0,80(sp)
    8000266e:	e4a6                	sd	s1,72(sp)
    80002670:	e0ca                	sd	s2,64(sp)
    80002672:	fc4e                	sd	s3,56(sp)
    80002674:	f852                	sd	s4,48(sp)
    80002676:	f456                	sd	s5,40(sp)
    80002678:	f05a                	sd	s6,32(sp)
    8000267a:	ec5e                	sd	s7,24(sp)
    8000267c:	e862                	sd	s8,16(sp)
    8000267e:	e466                	sd	s9,8(sp)
    80002680:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002682:	00015797          	auipc	a5,0x15
    80002686:	eda7a783          	lw	a5,-294(a5) # 8001755c <sb+0x4>
    8000268a:	cbd1                	beqz	a5,8000271e <balloc+0xb6>
    8000268c:	8baa                	mv	s7,a0
    8000268e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002690:	00015b17          	auipc	s6,0x15
    80002694:	ec8b0b13          	addi	s6,s6,-312 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002698:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000269a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000269c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000269e:	6c89                	lui	s9,0x2
    800026a0:	a831                	j	800026bc <balloc+0x54>
    brelse(bp);
    800026a2:	854a                	mv	a0,s2
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	e32080e7          	jalr	-462(ra) # 800024d6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026ac:	015c87bb          	addw	a5,s9,s5
    800026b0:	00078a9b          	sext.w	s5,a5
    800026b4:	004b2703          	lw	a4,4(s6)
    800026b8:	06eaf363          	bgeu	s5,a4,8000271e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026bc:	41fad79b          	sraiw	a5,s5,0x1f
    800026c0:	0137d79b          	srliw	a5,a5,0x13
    800026c4:	015787bb          	addw	a5,a5,s5
    800026c8:	40d7d79b          	sraiw	a5,a5,0xd
    800026cc:	01cb2583          	lw	a1,28(s6)
    800026d0:	9dbd                	addw	a1,a1,a5
    800026d2:	855e                	mv	a0,s7
    800026d4:	00000097          	auipc	ra,0x0
    800026d8:	cd2080e7          	jalr	-814(ra) # 800023a6 <bread>
    800026dc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026de:	004b2503          	lw	a0,4(s6)
    800026e2:	000a849b          	sext.w	s1,s5
    800026e6:	8662                	mv	a2,s8
    800026e8:	faa4fde3          	bgeu	s1,a0,800026a2 <balloc+0x3a>
      m = 1 << (bi % 8);
    800026ec:	41f6579b          	sraiw	a5,a2,0x1f
    800026f0:	01d7d69b          	srliw	a3,a5,0x1d
    800026f4:	00c6873b          	addw	a4,a3,a2
    800026f8:	00777793          	andi	a5,a4,7
    800026fc:	9f95                	subw	a5,a5,a3
    800026fe:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002702:	4037571b          	sraiw	a4,a4,0x3
    80002706:	00e906b3          	add	a3,s2,a4
    8000270a:	0586c683          	lbu	a3,88(a3)
    8000270e:	00d7f5b3          	and	a1,a5,a3
    80002712:	cd91                	beqz	a1,8000272e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002714:	2605                	addiw	a2,a2,1
    80002716:	2485                	addiw	s1,s1,1
    80002718:	fd4618e3          	bne	a2,s4,800026e8 <balloc+0x80>
    8000271c:	b759                	j	800026a2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000271e:	00006517          	auipc	a0,0x6
    80002722:	f4a50513          	addi	a0,a0,-182 # 80008668 <syscalls_name+0x110>
    80002726:	00003097          	auipc	ra,0x3
    8000272a:	532080e7          	jalr	1330(ra) # 80005c58 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000272e:	974a                	add	a4,a4,s2
    80002730:	8fd5                	or	a5,a5,a3
    80002732:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002736:	854a                	mv	a0,s2
    80002738:	00001097          	auipc	ra,0x1
    8000273c:	01a080e7          	jalr	26(ra) # 80003752 <log_write>
        brelse(bp);
    80002740:	854a                	mv	a0,s2
    80002742:	00000097          	auipc	ra,0x0
    80002746:	d94080e7          	jalr	-620(ra) # 800024d6 <brelse>
  bp = bread(dev, bno);
    8000274a:	85a6                	mv	a1,s1
    8000274c:	855e                	mv	a0,s7
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	c58080e7          	jalr	-936(ra) # 800023a6 <bread>
    80002756:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002758:	40000613          	li	a2,1024
    8000275c:	4581                	li	a1,0
    8000275e:	05850513          	addi	a0,a0,88
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	a68080e7          	jalr	-1432(ra) # 800001ca <memset>
  log_write(bp);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	fe6080e7          	jalr	-26(ra) # 80003752 <log_write>
  brelse(bp);
    80002774:	854a                	mv	a0,s2
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	d60080e7          	jalr	-672(ra) # 800024d6 <brelse>
}
    8000277e:	8526                	mv	a0,s1
    80002780:	60e6                	ld	ra,88(sp)
    80002782:	6446                	ld	s0,80(sp)
    80002784:	64a6                	ld	s1,72(sp)
    80002786:	6906                	ld	s2,64(sp)
    80002788:	79e2                	ld	s3,56(sp)
    8000278a:	7a42                	ld	s4,48(sp)
    8000278c:	7aa2                	ld	s5,40(sp)
    8000278e:	7b02                	ld	s6,32(sp)
    80002790:	6be2                	ld	s7,24(sp)
    80002792:	6c42                	ld	s8,16(sp)
    80002794:	6ca2                	ld	s9,8(sp)
    80002796:	6125                	addi	sp,sp,96
    80002798:	8082                	ret

000000008000279a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	e052                	sd	s4,0(sp)
    800027a8:	1800                	addi	s0,sp,48
    800027aa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ac:	47ad                	li	a5,11
    800027ae:	04b7fe63          	bgeu	a5,a1,8000280a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027b2:	ff45849b          	addiw	s1,a1,-12
    800027b6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027ba:	0ff00793          	li	a5,255
    800027be:	0ae7e363          	bltu	a5,a4,80002864 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027c2:	08052583          	lw	a1,128(a0)
    800027c6:	c5ad                	beqz	a1,80002830 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027c8:	00092503          	lw	a0,0(s2)
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	bda080e7          	jalr	-1062(ra) # 800023a6 <bread>
    800027d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027d6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027da:	02049593          	slli	a1,s1,0x20
    800027de:	9181                	srli	a1,a1,0x20
    800027e0:	058a                	slli	a1,a1,0x2
    800027e2:	00b784b3          	add	s1,a5,a1
    800027e6:	0004a983          	lw	s3,0(s1)
    800027ea:	04098d63          	beqz	s3,80002844 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027ee:	8552                	mv	a0,s4
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	ce6080e7          	jalr	-794(ra) # 800024d6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027f8:	854e                	mv	a0,s3
    800027fa:	70a2                	ld	ra,40(sp)
    800027fc:	7402                	ld	s0,32(sp)
    800027fe:	64e2                	ld	s1,24(sp)
    80002800:	6942                	ld	s2,16(sp)
    80002802:	69a2                	ld	s3,8(sp)
    80002804:	6a02                	ld	s4,0(sp)
    80002806:	6145                	addi	sp,sp,48
    80002808:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000280a:	02059493          	slli	s1,a1,0x20
    8000280e:	9081                	srli	s1,s1,0x20
    80002810:	048a                	slli	s1,s1,0x2
    80002812:	94aa                	add	s1,s1,a0
    80002814:	0504a983          	lw	s3,80(s1)
    80002818:	fe0990e3          	bnez	s3,800027f8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000281c:	4108                	lw	a0,0(a0)
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	e4a080e7          	jalr	-438(ra) # 80002668 <balloc>
    80002826:	0005099b          	sext.w	s3,a0
    8000282a:	0534a823          	sw	s3,80(s1)
    8000282e:	b7e9                	j	800027f8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002830:	4108                	lw	a0,0(a0)
    80002832:	00000097          	auipc	ra,0x0
    80002836:	e36080e7          	jalr	-458(ra) # 80002668 <balloc>
    8000283a:	0005059b          	sext.w	a1,a0
    8000283e:	08b92023          	sw	a1,128(s2)
    80002842:	b759                	j	800027c8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002844:	00092503          	lw	a0,0(s2)
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	e20080e7          	jalr	-480(ra) # 80002668 <balloc>
    80002850:	0005099b          	sext.w	s3,a0
    80002854:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002858:	8552                	mv	a0,s4
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	ef8080e7          	jalr	-264(ra) # 80003752 <log_write>
    80002862:	b771                	j	800027ee <bmap+0x54>
  panic("bmap: out of range");
    80002864:	00006517          	auipc	a0,0x6
    80002868:	e1c50513          	addi	a0,a0,-484 # 80008680 <syscalls_name+0x128>
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	3ec080e7          	jalr	1004(ra) # 80005c58 <panic>

0000000080002874 <iget>:
{
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	e052                	sd	s4,0(sp)
    80002882:	1800                	addi	s0,sp,48
    80002884:	89aa                	mv	s3,a0
    80002886:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002888:	00015517          	auipc	a0,0x15
    8000288c:	cf050513          	addi	a0,a0,-784 # 80017578 <itable>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	912080e7          	jalr	-1774(ra) # 800061a2 <acquire>
  empty = 0;
    80002898:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000289a:	00015497          	auipc	s1,0x15
    8000289e:	cf648493          	addi	s1,s1,-778 # 80017590 <itable+0x18>
    800028a2:	00016697          	auipc	a3,0x16
    800028a6:	77e68693          	addi	a3,a3,1918 # 80019020 <log>
    800028aa:	a039                	j	800028b8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ac:	02090b63          	beqz	s2,800028e2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b0:	08848493          	addi	s1,s1,136
    800028b4:	02d48a63          	beq	s1,a3,800028e8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b8:	449c                	lw	a5,8(s1)
    800028ba:	fef059e3          	blez	a5,800028ac <iget+0x38>
    800028be:	4098                	lw	a4,0(s1)
    800028c0:	ff3716e3          	bne	a4,s3,800028ac <iget+0x38>
    800028c4:	40d8                	lw	a4,4(s1)
    800028c6:	ff4713e3          	bne	a4,s4,800028ac <iget+0x38>
      ip->ref++;
    800028ca:	2785                	addiw	a5,a5,1
    800028cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ce:	00015517          	auipc	a0,0x15
    800028d2:	caa50513          	addi	a0,a0,-854 # 80017578 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	980080e7          	jalr	-1664(ra) # 80006256 <release>
      return ip;
    800028de:	8926                	mv	s2,s1
    800028e0:	a03d                	j	8000290e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e2:	f7f9                	bnez	a5,800028b0 <iget+0x3c>
    800028e4:	8926                	mv	s2,s1
    800028e6:	b7e9                	j	800028b0 <iget+0x3c>
  if(empty == 0)
    800028e8:	02090c63          	beqz	s2,80002920 <iget+0xac>
  ip->dev = dev;
    800028ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f4:	4785                	li	a5,1
    800028f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fe:	00015517          	auipc	a0,0x15
    80002902:	c7a50513          	addi	a0,a0,-902 # 80017578 <itable>
    80002906:	00004097          	auipc	ra,0x4
    8000290a:	950080e7          	jalr	-1712(ra) # 80006256 <release>
}
    8000290e:	854a                	mv	a0,s2
    80002910:	70a2                	ld	ra,40(sp)
    80002912:	7402                	ld	s0,32(sp)
    80002914:	64e2                	ld	s1,24(sp)
    80002916:	6942                	ld	s2,16(sp)
    80002918:	69a2                	ld	s3,8(sp)
    8000291a:	6a02                	ld	s4,0(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
    panic("iget: no inodes");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	d7850513          	addi	a0,a0,-648 # 80008698 <syscalls_name+0x140>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	330080e7          	jalr	816(ra) # 80005c58 <panic>

0000000080002930 <fsinit>:
fsinit(int dev) {
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	1800                	addi	s0,sp,48
    8000293e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002940:	4585                	li	a1,1
    80002942:	00000097          	auipc	ra,0x0
    80002946:	a64080e7          	jalr	-1436(ra) # 800023a6 <bread>
    8000294a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000294c:	00015997          	auipc	s3,0x15
    80002950:	c0c98993          	addi	s3,s3,-1012 # 80017558 <sb>
    80002954:	02000613          	li	a2,32
    80002958:	05850593          	addi	a1,a0,88
    8000295c:	854e                	mv	a0,s3
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	8cc080e7          	jalr	-1844(ra) # 8000022a <memmove>
  brelse(bp);
    80002966:	8526                	mv	a0,s1
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	b6e080e7          	jalr	-1170(ra) # 800024d6 <brelse>
  if(sb.magic != FSMAGIC)
    80002970:	0009a703          	lw	a4,0(s3)
    80002974:	102037b7          	lui	a5,0x10203
    80002978:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000297c:	02f71263          	bne	a4,a5,800029a0 <fsinit+0x70>
  initlog(dev, &sb);
    80002980:	00015597          	auipc	a1,0x15
    80002984:	bd858593          	addi	a1,a1,-1064 # 80017558 <sb>
    80002988:	854a                	mv	a0,s2
    8000298a:	00001097          	auipc	ra,0x1
    8000298e:	b4c080e7          	jalr	-1204(ra) # 800034d6 <initlog>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
    panic("invalid file system");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	d0850513          	addi	a0,a0,-760 # 800086a8 <syscalls_name+0x150>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	2b0080e7          	jalr	688(ra) # 80005c58 <panic>

00000000800029b0 <iinit>:
{
    800029b0:	7179                	addi	sp,sp,-48
    800029b2:	f406                	sd	ra,40(sp)
    800029b4:	f022                	sd	s0,32(sp)
    800029b6:	ec26                	sd	s1,24(sp)
    800029b8:	e84a                	sd	s2,16(sp)
    800029ba:	e44e                	sd	s3,8(sp)
    800029bc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029be:	00006597          	auipc	a1,0x6
    800029c2:	d0258593          	addi	a1,a1,-766 # 800086c0 <syscalls_name+0x168>
    800029c6:	00015517          	auipc	a0,0x15
    800029ca:	bb250513          	addi	a0,a0,-1102 # 80017578 <itable>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	744080e7          	jalr	1860(ra) # 80006112 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d6:	00015497          	auipc	s1,0x15
    800029da:	bca48493          	addi	s1,s1,-1078 # 800175a0 <itable+0x28>
    800029de:	00016997          	auipc	s3,0x16
    800029e2:	65298993          	addi	s3,s3,1618 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e6:	00006917          	auipc	s2,0x6
    800029ea:	ce290913          	addi	s2,s2,-798 # 800086c8 <syscalls_name+0x170>
    800029ee:	85ca                	mv	a1,s2
    800029f0:	8526                	mv	a0,s1
    800029f2:	00001097          	auipc	ra,0x1
    800029f6:	e46080e7          	jalr	-442(ra) # 80003838 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029fa:	08848493          	addi	s1,s1,136
    800029fe:	ff3498e3          	bne	s1,s3,800029ee <iinit+0x3e>
}
    80002a02:	70a2                	ld	ra,40(sp)
    80002a04:	7402                	ld	s0,32(sp)
    80002a06:	64e2                	ld	s1,24(sp)
    80002a08:	6942                	ld	s2,16(sp)
    80002a0a:	69a2                	ld	s3,8(sp)
    80002a0c:	6145                	addi	sp,sp,48
    80002a0e:	8082                	ret

0000000080002a10 <ialloc>:
{
    80002a10:	715d                	addi	sp,sp,-80
    80002a12:	e486                	sd	ra,72(sp)
    80002a14:	e0a2                	sd	s0,64(sp)
    80002a16:	fc26                	sd	s1,56(sp)
    80002a18:	f84a                	sd	s2,48(sp)
    80002a1a:	f44e                	sd	s3,40(sp)
    80002a1c:	f052                	sd	s4,32(sp)
    80002a1e:	ec56                	sd	s5,24(sp)
    80002a20:	e85a                	sd	s6,16(sp)
    80002a22:	e45e                	sd	s7,8(sp)
    80002a24:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a26:	00015717          	auipc	a4,0x15
    80002a2a:	b3e72703          	lw	a4,-1218(a4) # 80017564 <sb+0xc>
    80002a2e:	4785                	li	a5,1
    80002a30:	04e7fa63          	bgeu	a5,a4,80002a84 <ialloc+0x74>
    80002a34:	8aaa                	mv	s5,a0
    80002a36:	8bae                	mv	s7,a1
    80002a38:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a3a:	00015a17          	auipc	s4,0x15
    80002a3e:	b1ea0a13          	addi	s4,s4,-1250 # 80017558 <sb>
    80002a42:	00048b1b          	sext.w	s6,s1
    80002a46:	0044d593          	srli	a1,s1,0x4
    80002a4a:	018a2783          	lw	a5,24(s4)
    80002a4e:	9dbd                	addw	a1,a1,a5
    80002a50:	8556                	mv	a0,s5
    80002a52:	00000097          	auipc	ra,0x0
    80002a56:	954080e7          	jalr	-1708(ra) # 800023a6 <bread>
    80002a5a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a5c:	05850993          	addi	s3,a0,88
    80002a60:	00f4f793          	andi	a5,s1,15
    80002a64:	079a                	slli	a5,a5,0x6
    80002a66:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a68:	00099783          	lh	a5,0(s3)
    80002a6c:	c785                	beqz	a5,80002a94 <ialloc+0x84>
    brelse(bp);
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	a68080e7          	jalr	-1432(ra) # 800024d6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a76:	0485                	addi	s1,s1,1
    80002a78:	00ca2703          	lw	a4,12(s4)
    80002a7c:	0004879b          	sext.w	a5,s1
    80002a80:	fce7e1e3          	bltu	a5,a4,80002a42 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a84:	00006517          	auipc	a0,0x6
    80002a88:	c4c50513          	addi	a0,a0,-948 # 800086d0 <syscalls_name+0x178>
    80002a8c:	00003097          	auipc	ra,0x3
    80002a90:	1cc080e7          	jalr	460(ra) # 80005c58 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a94:	04000613          	li	a2,64
    80002a98:	4581                	li	a1,0
    80002a9a:	854e                	mv	a0,s3
    80002a9c:	ffffd097          	auipc	ra,0xffffd
    80002aa0:	72e080e7          	jalr	1838(ra) # 800001ca <memset>
      dip->type = type;
    80002aa4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aa8:	854a                	mv	a0,s2
    80002aaa:	00001097          	auipc	ra,0x1
    80002aae:	ca8080e7          	jalr	-856(ra) # 80003752 <log_write>
      brelse(bp);
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	a22080e7          	jalr	-1502(ra) # 800024d6 <brelse>
      return iget(dev, inum);
    80002abc:	85da                	mv	a1,s6
    80002abe:	8556                	mv	a0,s5
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	db4080e7          	jalr	-588(ra) # 80002874 <iget>
}
    80002ac8:	60a6                	ld	ra,72(sp)
    80002aca:	6406                	ld	s0,64(sp)
    80002acc:	74e2                	ld	s1,56(sp)
    80002ace:	7942                	ld	s2,48(sp)
    80002ad0:	79a2                	ld	s3,40(sp)
    80002ad2:	7a02                	ld	s4,32(sp)
    80002ad4:	6ae2                	ld	s5,24(sp)
    80002ad6:	6b42                	ld	s6,16(sp)
    80002ad8:	6ba2                	ld	s7,8(sp)
    80002ada:	6161                	addi	sp,sp,80
    80002adc:	8082                	ret

0000000080002ade <iupdate>:
{
    80002ade:	1101                	addi	sp,sp,-32
    80002ae0:	ec06                	sd	ra,24(sp)
    80002ae2:	e822                	sd	s0,16(sp)
    80002ae4:	e426                	sd	s1,8(sp)
    80002ae6:	e04a                	sd	s2,0(sp)
    80002ae8:	1000                	addi	s0,sp,32
    80002aea:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aec:	415c                	lw	a5,4(a0)
    80002aee:	0047d79b          	srliw	a5,a5,0x4
    80002af2:	00015597          	auipc	a1,0x15
    80002af6:	a7e5a583          	lw	a1,-1410(a1) # 80017570 <sb+0x18>
    80002afa:	9dbd                	addw	a1,a1,a5
    80002afc:	4108                	lw	a0,0(a0)
    80002afe:	00000097          	auipc	ra,0x0
    80002b02:	8a8080e7          	jalr	-1880(ra) # 800023a6 <bread>
    80002b06:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b08:	05850793          	addi	a5,a0,88
    80002b0c:	40c8                	lw	a0,4(s1)
    80002b0e:	893d                	andi	a0,a0,15
    80002b10:	051a                	slli	a0,a0,0x6
    80002b12:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b14:	04449703          	lh	a4,68(s1)
    80002b18:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b1c:	04649703          	lh	a4,70(s1)
    80002b20:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b24:	04849703          	lh	a4,72(s1)
    80002b28:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b2c:	04a49703          	lh	a4,74(s1)
    80002b30:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b34:	44f8                	lw	a4,76(s1)
    80002b36:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b38:	03400613          	li	a2,52
    80002b3c:	05048593          	addi	a1,s1,80
    80002b40:	0531                	addi	a0,a0,12
    80002b42:	ffffd097          	auipc	ra,0xffffd
    80002b46:	6e8080e7          	jalr	1768(ra) # 8000022a <memmove>
  log_write(bp);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	c06080e7          	jalr	-1018(ra) # 80003752 <log_write>
  brelse(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	980080e7          	jalr	-1664(ra) # 800024d6 <brelse>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6902                	ld	s2,0(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret

0000000080002b6a <idup>:
{
    80002b6a:	1101                	addi	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b76:	00015517          	auipc	a0,0x15
    80002b7a:	a0250513          	addi	a0,a0,-1534 # 80017578 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	624080e7          	jalr	1572(ra) # 800061a2 <acquire>
  ip->ref++;
    80002b86:	449c                	lw	a5,8(s1)
    80002b88:	2785                	addiw	a5,a5,1
    80002b8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b8c:	00015517          	auipc	a0,0x15
    80002b90:	9ec50513          	addi	a0,a0,-1556 # 80017578 <itable>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	6c2080e7          	jalr	1730(ra) # 80006256 <release>
}
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret

0000000080002ba8 <ilock>:
{
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	e04a                	sd	s2,0(sp)
    80002bb2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bb4:	c115                	beqz	a0,80002bd8 <ilock+0x30>
    80002bb6:	84aa                	mv	s1,a0
    80002bb8:	451c                	lw	a5,8(a0)
    80002bba:	00f05f63          	blez	a5,80002bd8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bbe:	0541                	addi	a0,a0,16
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	cb2080e7          	jalr	-846(ra) # 80003872 <acquiresleep>
  if(ip->valid == 0){
    80002bc8:	40bc                	lw	a5,64(s1)
    80002bca:	cf99                	beqz	a5,80002be8 <ilock+0x40>
}
    80002bcc:	60e2                	ld	ra,24(sp)
    80002bce:	6442                	ld	s0,16(sp)
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	6902                	ld	s2,0(sp)
    80002bd4:	6105                	addi	sp,sp,32
    80002bd6:	8082                	ret
    panic("ilock");
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	b1050513          	addi	a0,a0,-1264 # 800086e8 <syscalls_name+0x190>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	078080e7          	jalr	120(ra) # 80005c58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be8:	40dc                	lw	a5,4(s1)
    80002bea:	0047d79b          	srliw	a5,a5,0x4
    80002bee:	00015597          	auipc	a1,0x15
    80002bf2:	9825a583          	lw	a1,-1662(a1) # 80017570 <sb+0x18>
    80002bf6:	9dbd                	addw	a1,a1,a5
    80002bf8:	4088                	lw	a0,0(s1)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	7ac080e7          	jalr	1964(ra) # 800023a6 <bread>
    80002c02:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c04:	05850593          	addi	a1,a0,88
    80002c08:	40dc                	lw	a5,4(s1)
    80002c0a:	8bbd                	andi	a5,a5,15
    80002c0c:	079a                	slli	a5,a5,0x6
    80002c0e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c10:	00059783          	lh	a5,0(a1)
    80002c14:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c18:	00259783          	lh	a5,2(a1)
    80002c1c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c20:	00459783          	lh	a5,4(a1)
    80002c24:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c28:	00659783          	lh	a5,6(a1)
    80002c2c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c30:	459c                	lw	a5,8(a1)
    80002c32:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c34:	03400613          	li	a2,52
    80002c38:	05b1                	addi	a1,a1,12
    80002c3a:	05048513          	addi	a0,s1,80
    80002c3e:	ffffd097          	auipc	ra,0xffffd
    80002c42:	5ec080e7          	jalr	1516(ra) # 8000022a <memmove>
    brelse(bp);
    80002c46:	854a                	mv	a0,s2
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	88e080e7          	jalr	-1906(ra) # 800024d6 <brelse>
    ip->valid = 1;
    80002c50:	4785                	li	a5,1
    80002c52:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c54:	04449783          	lh	a5,68(s1)
    80002c58:	fbb5                	bnez	a5,80002bcc <ilock+0x24>
      panic("ilock: no type");
    80002c5a:	00006517          	auipc	a0,0x6
    80002c5e:	a9650513          	addi	a0,a0,-1386 # 800086f0 <syscalls_name+0x198>
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	ff6080e7          	jalr	-10(ra) # 80005c58 <panic>

0000000080002c6a <iunlock>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	e04a                	sd	s2,0(sp)
    80002c74:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c76:	c905                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c78:	84aa                	mv	s1,a0
    80002c7a:	01050913          	addi	s2,a0,16
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	c8c080e7          	jalr	-884(ra) # 8000390c <holdingsleep>
    80002c88:	cd19                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c8a:	449c                	lw	a5,8(s1)
    80002c8c:	00f05d63          	blez	a5,80002ca6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	c36080e7          	jalr	-970(ra) # 800038c8 <releasesleep>
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6902                	ld	s2,0(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret
    panic("iunlock");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	a5a50513          	addi	a0,a0,-1446 # 80008700 <syscalls_name+0x1a8>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	faa080e7          	jalr	-86(ra) # 80005c58 <panic>

0000000080002cb6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb6:	7179                	addi	sp,sp,-48
    80002cb8:	f406                	sd	ra,40(sp)
    80002cba:	f022                	sd	s0,32(sp)
    80002cbc:	ec26                	sd	s1,24(sp)
    80002cbe:	e84a                	sd	s2,16(sp)
    80002cc0:	e44e                	sd	s3,8(sp)
    80002cc2:	e052                	sd	s4,0(sp)
    80002cc4:	1800                	addi	s0,sp,48
    80002cc6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cc8:	05050493          	addi	s1,a0,80
    80002ccc:	08050913          	addi	s2,a0,128
    80002cd0:	a021                	j	80002cd8 <itrunc+0x22>
    80002cd2:	0491                	addi	s1,s1,4
    80002cd4:	01248d63          	beq	s1,s2,80002cee <itrunc+0x38>
    if(ip->addrs[i]){
    80002cd8:	408c                	lw	a1,0(s1)
    80002cda:	dde5                	beqz	a1,80002cd2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cdc:	0009a503          	lw	a0,0(s3)
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	90c080e7          	jalr	-1780(ra) # 800025ec <bfree>
      ip->addrs[i] = 0;
    80002ce8:	0004a023          	sw	zero,0(s1)
    80002cec:	b7dd                	j	80002cd2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cee:	0809a583          	lw	a1,128(s3)
    80002cf2:	e185                	bnez	a1,80002d12 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cf4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cf8:	854e                	mv	a0,s3
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	de4080e7          	jalr	-540(ra) # 80002ade <iupdate>
}
    80002d02:	70a2                	ld	ra,40(sp)
    80002d04:	7402                	ld	s0,32(sp)
    80002d06:	64e2                	ld	s1,24(sp)
    80002d08:	6942                	ld	s2,16(sp)
    80002d0a:	69a2                	ld	s3,8(sp)
    80002d0c:	6a02                	ld	s4,0(sp)
    80002d0e:	6145                	addi	sp,sp,48
    80002d10:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d12:	0009a503          	lw	a0,0(s3)
    80002d16:	fffff097          	auipc	ra,0xfffff
    80002d1a:	690080e7          	jalr	1680(ra) # 800023a6 <bread>
    80002d1e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d20:	05850493          	addi	s1,a0,88
    80002d24:	45850913          	addi	s2,a0,1112
    80002d28:	a811                	j	80002d3c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d2a:	0009a503          	lw	a0,0(s3)
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	8be080e7          	jalr	-1858(ra) # 800025ec <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d36:	0491                	addi	s1,s1,4
    80002d38:	01248563          	beq	s1,s2,80002d42 <itrunc+0x8c>
      if(a[j])
    80002d3c:	408c                	lw	a1,0(s1)
    80002d3e:	dde5                	beqz	a1,80002d36 <itrunc+0x80>
    80002d40:	b7ed                	j	80002d2a <itrunc+0x74>
    brelse(bp);
    80002d42:	8552                	mv	a0,s4
    80002d44:	fffff097          	auipc	ra,0xfffff
    80002d48:	792080e7          	jalr	1938(ra) # 800024d6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d4c:	0809a583          	lw	a1,128(s3)
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	898080e7          	jalr	-1896(ra) # 800025ec <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d5c:	0809a023          	sw	zero,128(s3)
    80002d60:	bf51                	j	80002cf4 <itrunc+0x3e>

0000000080002d62 <iput>:
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	e426                	sd	s1,8(sp)
    80002d6a:	e04a                	sd	s2,0(sp)
    80002d6c:	1000                	addi	s0,sp,32
    80002d6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d70:	00015517          	auipc	a0,0x15
    80002d74:	80850513          	addi	a0,a0,-2040 # 80017578 <itable>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	42a080e7          	jalr	1066(ra) # 800061a2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d80:	4498                	lw	a4,8(s1)
    80002d82:	4785                	li	a5,1
    80002d84:	02f70363          	beq	a4,a5,80002daa <iput+0x48>
  ip->ref--;
    80002d88:	449c                	lw	a5,8(s1)
    80002d8a:	37fd                	addiw	a5,a5,-1
    80002d8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8e:	00014517          	auipc	a0,0x14
    80002d92:	7ea50513          	addi	a0,a0,2026 # 80017578 <itable>
    80002d96:	00003097          	auipc	ra,0x3
    80002d9a:	4c0080e7          	jalr	1216(ra) # 80006256 <release>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002daa:	40bc                	lw	a5,64(s1)
    80002dac:	dff1                	beqz	a5,80002d88 <iput+0x26>
    80002dae:	04a49783          	lh	a5,74(s1)
    80002db2:	fbf9                	bnez	a5,80002d88 <iput+0x26>
    acquiresleep(&ip->lock);
    80002db4:	01048913          	addi	s2,s1,16
    80002db8:	854a                	mv	a0,s2
    80002dba:	00001097          	auipc	ra,0x1
    80002dbe:	ab8080e7          	jalr	-1352(ra) # 80003872 <acquiresleep>
    release(&itable.lock);
    80002dc2:	00014517          	auipc	a0,0x14
    80002dc6:	7b650513          	addi	a0,a0,1974 # 80017578 <itable>
    80002dca:	00003097          	auipc	ra,0x3
    80002dce:	48c080e7          	jalr	1164(ra) # 80006256 <release>
    itrunc(ip);
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	ee2080e7          	jalr	-286(ra) # 80002cb6 <itrunc>
    ip->type = 0;
    80002ddc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002de0:	8526                	mv	a0,s1
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	cfc080e7          	jalr	-772(ra) # 80002ade <iupdate>
    ip->valid = 0;
    80002dea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dee:	854a                	mv	a0,s2
    80002df0:	00001097          	auipc	ra,0x1
    80002df4:	ad8080e7          	jalr	-1320(ra) # 800038c8 <releasesleep>
    acquire(&itable.lock);
    80002df8:	00014517          	auipc	a0,0x14
    80002dfc:	78050513          	addi	a0,a0,1920 # 80017578 <itable>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	3a2080e7          	jalr	930(ra) # 800061a2 <acquire>
    80002e08:	b741                	j	80002d88 <iput+0x26>

0000000080002e0a <iunlockput>:
{
    80002e0a:	1101                	addi	sp,sp,-32
    80002e0c:	ec06                	sd	ra,24(sp)
    80002e0e:	e822                	sd	s0,16(sp)
    80002e10:	e426                	sd	s1,8(sp)
    80002e12:	1000                	addi	s0,sp,32
    80002e14:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	e54080e7          	jalr	-428(ra) # 80002c6a <iunlock>
  iput(ip);
    80002e1e:	8526                	mv	a0,s1
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	f42080e7          	jalr	-190(ra) # 80002d62 <iput>
}
    80002e28:	60e2                	ld	ra,24(sp)
    80002e2a:	6442                	ld	s0,16(sp)
    80002e2c:	64a2                	ld	s1,8(sp)
    80002e2e:	6105                	addi	sp,sp,32
    80002e30:	8082                	ret

0000000080002e32 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e32:	1141                	addi	sp,sp,-16
    80002e34:	e422                	sd	s0,8(sp)
    80002e36:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e38:	411c                	lw	a5,0(a0)
    80002e3a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e3c:	415c                	lw	a5,4(a0)
    80002e3e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e40:	04451783          	lh	a5,68(a0)
    80002e44:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e48:	04a51783          	lh	a5,74(a0)
    80002e4c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e50:	04c56783          	lwu	a5,76(a0)
    80002e54:	e99c                	sd	a5,16(a1)
}
    80002e56:	6422                	ld	s0,8(sp)
    80002e58:	0141                	addi	sp,sp,16
    80002e5a:	8082                	ret

0000000080002e5c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e5c:	457c                	lw	a5,76(a0)
    80002e5e:	0ed7e963          	bltu	a5,a3,80002f50 <readi+0xf4>
{
    80002e62:	7159                	addi	sp,sp,-112
    80002e64:	f486                	sd	ra,104(sp)
    80002e66:	f0a2                	sd	s0,96(sp)
    80002e68:	eca6                	sd	s1,88(sp)
    80002e6a:	e8ca                	sd	s2,80(sp)
    80002e6c:	e4ce                	sd	s3,72(sp)
    80002e6e:	e0d2                	sd	s4,64(sp)
    80002e70:	fc56                	sd	s5,56(sp)
    80002e72:	f85a                	sd	s6,48(sp)
    80002e74:	f45e                	sd	s7,40(sp)
    80002e76:	f062                	sd	s8,32(sp)
    80002e78:	ec66                	sd	s9,24(sp)
    80002e7a:	e86a                	sd	s10,16(sp)
    80002e7c:	e46e                	sd	s11,8(sp)
    80002e7e:	1880                	addi	s0,sp,112
    80002e80:	8baa                	mv	s7,a0
    80002e82:	8c2e                	mv	s8,a1
    80002e84:	8ab2                	mv	s5,a2
    80002e86:	84b6                	mv	s1,a3
    80002e88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e8a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e8c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e8e:	0ad76063          	bltu	a4,a3,80002f2e <readi+0xd2>
  if(off + n > ip->size)
    80002e92:	00e7f463          	bgeu	a5,a4,80002e9a <readi+0x3e>
    n = ip->size - off;
    80002e96:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e9a:	0a0b0963          	beqz	s6,80002f4c <readi+0xf0>
    80002e9e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ea4:	5cfd                	li	s9,-1
    80002ea6:	a82d                	j	80002ee0 <readi+0x84>
    80002ea8:	020a1d93          	slli	s11,s4,0x20
    80002eac:	020ddd93          	srli	s11,s11,0x20
    80002eb0:	05890613          	addi	a2,s2,88
    80002eb4:	86ee                	mv	a3,s11
    80002eb6:	963a                	add	a2,a2,a4
    80002eb8:	85d6                	mv	a1,s5
    80002eba:	8562                	mv	a0,s8
    80002ebc:	fffff097          	auipc	ra,0xfffff
    80002ec0:	a46080e7          	jalr	-1466(ra) # 80001902 <either_copyout>
    80002ec4:	05950d63          	beq	a0,s9,80002f1e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	60c080e7          	jalr	1548(ra) # 800024d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed2:	013a09bb          	addw	s3,s4,s3
    80002ed6:	009a04bb          	addw	s1,s4,s1
    80002eda:	9aee                	add	s5,s5,s11
    80002edc:	0569f763          	bgeu	s3,s6,80002f2a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ee0:	000ba903          	lw	s2,0(s7)
    80002ee4:	00a4d59b          	srliw	a1,s1,0xa
    80002ee8:	855e                	mv	a0,s7
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	8b0080e7          	jalr	-1872(ra) # 8000279a <bmap>
    80002ef2:	0005059b          	sext.w	a1,a0
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	4ae080e7          	jalr	1198(ra) # 800023a6 <bread>
    80002f00:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f02:	3ff4f713          	andi	a4,s1,1023
    80002f06:	40ed07bb          	subw	a5,s10,a4
    80002f0a:	413b06bb          	subw	a3,s6,s3
    80002f0e:	8a3e                	mv	s4,a5
    80002f10:	2781                	sext.w	a5,a5
    80002f12:	0006861b          	sext.w	a2,a3
    80002f16:	f8f679e3          	bgeu	a2,a5,80002ea8 <readi+0x4c>
    80002f1a:	8a36                	mv	s4,a3
    80002f1c:	b771                	j	80002ea8 <readi+0x4c>
      brelse(bp);
    80002f1e:	854a                	mv	a0,s2
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	5b6080e7          	jalr	1462(ra) # 800024d6 <brelse>
      tot = -1;
    80002f28:	59fd                	li	s3,-1
  }
  return tot;
    80002f2a:	0009851b          	sext.w	a0,s3
}
    80002f2e:	70a6                	ld	ra,104(sp)
    80002f30:	7406                	ld	s0,96(sp)
    80002f32:	64e6                	ld	s1,88(sp)
    80002f34:	6946                	ld	s2,80(sp)
    80002f36:	69a6                	ld	s3,72(sp)
    80002f38:	6a06                	ld	s4,64(sp)
    80002f3a:	7ae2                	ld	s5,56(sp)
    80002f3c:	7b42                	ld	s6,48(sp)
    80002f3e:	7ba2                	ld	s7,40(sp)
    80002f40:	7c02                	ld	s8,32(sp)
    80002f42:	6ce2                	ld	s9,24(sp)
    80002f44:	6d42                	ld	s10,16(sp)
    80002f46:	6da2                	ld	s11,8(sp)
    80002f48:	6165                	addi	sp,sp,112
    80002f4a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4c:	89da                	mv	s3,s6
    80002f4e:	bff1                	j	80002f2a <readi+0xce>
    return 0;
    80002f50:	4501                	li	a0,0
}
    80002f52:	8082                	ret

0000000080002f54 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f54:	457c                	lw	a5,76(a0)
    80002f56:	10d7e863          	bltu	a5,a3,80003066 <writei+0x112>
{
    80002f5a:	7159                	addi	sp,sp,-112
    80002f5c:	f486                	sd	ra,104(sp)
    80002f5e:	f0a2                	sd	s0,96(sp)
    80002f60:	eca6                	sd	s1,88(sp)
    80002f62:	e8ca                	sd	s2,80(sp)
    80002f64:	e4ce                	sd	s3,72(sp)
    80002f66:	e0d2                	sd	s4,64(sp)
    80002f68:	fc56                	sd	s5,56(sp)
    80002f6a:	f85a                	sd	s6,48(sp)
    80002f6c:	f45e                	sd	s7,40(sp)
    80002f6e:	f062                	sd	s8,32(sp)
    80002f70:	ec66                	sd	s9,24(sp)
    80002f72:	e86a                	sd	s10,16(sp)
    80002f74:	e46e                	sd	s11,8(sp)
    80002f76:	1880                	addi	s0,sp,112
    80002f78:	8b2a                	mv	s6,a0
    80002f7a:	8c2e                	mv	s8,a1
    80002f7c:	8ab2                	mv	s5,a2
    80002f7e:	8936                	mv	s2,a3
    80002f80:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f82:	00e687bb          	addw	a5,a3,a4
    80002f86:	0ed7e263          	bltu	a5,a3,8000306a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f8a:	00043737          	lui	a4,0x43
    80002f8e:	0ef76063          	bltu	a4,a5,8000306e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f92:	0c0b8863          	beqz	s7,80003062 <writei+0x10e>
    80002f96:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f98:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f9c:	5cfd                	li	s9,-1
    80002f9e:	a091                	j	80002fe2 <writei+0x8e>
    80002fa0:	02099d93          	slli	s11,s3,0x20
    80002fa4:	020ddd93          	srli	s11,s11,0x20
    80002fa8:	05848513          	addi	a0,s1,88
    80002fac:	86ee                	mv	a3,s11
    80002fae:	8656                	mv	a2,s5
    80002fb0:	85e2                	mv	a1,s8
    80002fb2:	953a                	add	a0,a0,a4
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	9a4080e7          	jalr	-1628(ra) # 80001958 <either_copyin>
    80002fbc:	07950263          	beq	a0,s9,80003020 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	00000097          	auipc	ra,0x0
    80002fc6:	790080e7          	jalr	1936(ra) # 80003752 <log_write>
    brelse(bp);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	50a080e7          	jalr	1290(ra) # 800024d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd4:	01498a3b          	addw	s4,s3,s4
    80002fd8:	0129893b          	addw	s2,s3,s2
    80002fdc:	9aee                	add	s5,s5,s11
    80002fde:	057a7663          	bgeu	s4,s7,8000302a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fe2:	000b2483          	lw	s1,0(s6)
    80002fe6:	00a9559b          	srliw	a1,s2,0xa
    80002fea:	855a                	mv	a0,s6
    80002fec:	fffff097          	auipc	ra,0xfffff
    80002ff0:	7ae080e7          	jalr	1966(ra) # 8000279a <bmap>
    80002ff4:	0005059b          	sext.w	a1,a0
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	3ac080e7          	jalr	940(ra) # 800023a6 <bread>
    80003002:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003004:	3ff97713          	andi	a4,s2,1023
    80003008:	40ed07bb          	subw	a5,s10,a4
    8000300c:	414b86bb          	subw	a3,s7,s4
    80003010:	89be                	mv	s3,a5
    80003012:	2781                	sext.w	a5,a5
    80003014:	0006861b          	sext.w	a2,a3
    80003018:	f8f674e3          	bgeu	a2,a5,80002fa0 <writei+0x4c>
    8000301c:	89b6                	mv	s3,a3
    8000301e:	b749                	j	80002fa0 <writei+0x4c>
      brelse(bp);
    80003020:	8526                	mv	a0,s1
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	4b4080e7          	jalr	1204(ra) # 800024d6 <brelse>
  }

  if(off > ip->size)
    8000302a:	04cb2783          	lw	a5,76(s6)
    8000302e:	0127f463          	bgeu	a5,s2,80003036 <writei+0xe2>
    ip->size = off;
    80003032:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003036:	855a                	mv	a0,s6
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	aa6080e7          	jalr	-1370(ra) # 80002ade <iupdate>

  return tot;
    80003040:	000a051b          	sext.w	a0,s4
}
    80003044:	70a6                	ld	ra,104(sp)
    80003046:	7406                	ld	s0,96(sp)
    80003048:	64e6                	ld	s1,88(sp)
    8000304a:	6946                	ld	s2,80(sp)
    8000304c:	69a6                	ld	s3,72(sp)
    8000304e:	6a06                	ld	s4,64(sp)
    80003050:	7ae2                	ld	s5,56(sp)
    80003052:	7b42                	ld	s6,48(sp)
    80003054:	7ba2                	ld	s7,40(sp)
    80003056:	7c02                	ld	s8,32(sp)
    80003058:	6ce2                	ld	s9,24(sp)
    8000305a:	6d42                	ld	s10,16(sp)
    8000305c:	6da2                	ld	s11,8(sp)
    8000305e:	6165                	addi	sp,sp,112
    80003060:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003062:	8a5e                	mv	s4,s7
    80003064:	bfc9                	j	80003036 <writei+0xe2>
    return -1;
    80003066:	557d                	li	a0,-1
}
    80003068:	8082                	ret
    return -1;
    8000306a:	557d                	li	a0,-1
    8000306c:	bfe1                	j	80003044 <writei+0xf0>
    return -1;
    8000306e:	557d                	li	a0,-1
    80003070:	bfd1                	j	80003044 <writei+0xf0>

0000000080003072 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003072:	1141                	addi	sp,sp,-16
    80003074:	e406                	sd	ra,8(sp)
    80003076:	e022                	sd	s0,0(sp)
    80003078:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000307a:	4639                	li	a2,14
    8000307c:	ffffd097          	auipc	ra,0xffffd
    80003080:	226080e7          	jalr	550(ra) # 800002a2 <strncmp>
}
    80003084:	60a2                	ld	ra,8(sp)
    80003086:	6402                	ld	s0,0(sp)
    80003088:	0141                	addi	sp,sp,16
    8000308a:	8082                	ret

000000008000308c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000308c:	7139                	addi	sp,sp,-64
    8000308e:	fc06                	sd	ra,56(sp)
    80003090:	f822                	sd	s0,48(sp)
    80003092:	f426                	sd	s1,40(sp)
    80003094:	f04a                	sd	s2,32(sp)
    80003096:	ec4e                	sd	s3,24(sp)
    80003098:	e852                	sd	s4,16(sp)
    8000309a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000309c:	04451703          	lh	a4,68(a0)
    800030a0:	4785                	li	a5,1
    800030a2:	00f71a63          	bne	a4,a5,800030b6 <dirlookup+0x2a>
    800030a6:	892a                	mv	s2,a0
    800030a8:	89ae                	mv	s3,a1
    800030aa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ac:	457c                	lw	a5,76(a0)
    800030ae:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030b0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030b2:	e79d                	bnez	a5,800030e0 <dirlookup+0x54>
    800030b4:	a8a5                	j	8000312c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030b6:	00005517          	auipc	a0,0x5
    800030ba:	65250513          	addi	a0,a0,1618 # 80008708 <syscalls_name+0x1b0>
    800030be:	00003097          	auipc	ra,0x3
    800030c2:	b9a080e7          	jalr	-1126(ra) # 80005c58 <panic>
      panic("dirlookup read");
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	65a50513          	addi	a0,a0,1626 # 80008720 <syscalls_name+0x1c8>
    800030ce:	00003097          	auipc	ra,0x3
    800030d2:	b8a080e7          	jalr	-1142(ra) # 80005c58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d6:	24c1                	addiw	s1,s1,16
    800030d8:	04c92783          	lw	a5,76(s2)
    800030dc:	04f4f763          	bgeu	s1,a5,8000312a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030e0:	4741                	li	a4,16
    800030e2:	86a6                	mv	a3,s1
    800030e4:	fc040613          	addi	a2,s0,-64
    800030e8:	4581                	li	a1,0
    800030ea:	854a                	mv	a0,s2
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	d70080e7          	jalr	-656(ra) # 80002e5c <readi>
    800030f4:	47c1                	li	a5,16
    800030f6:	fcf518e3          	bne	a0,a5,800030c6 <dirlookup+0x3a>
    if(de.inum == 0)
    800030fa:	fc045783          	lhu	a5,-64(s0)
    800030fe:	dfe1                	beqz	a5,800030d6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003100:	fc240593          	addi	a1,s0,-62
    80003104:	854e                	mv	a0,s3
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	f6c080e7          	jalr	-148(ra) # 80003072 <namecmp>
    8000310e:	f561                	bnez	a0,800030d6 <dirlookup+0x4a>
      if(poff)
    80003110:	000a0463          	beqz	s4,80003118 <dirlookup+0x8c>
        *poff = off;
    80003114:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003118:	fc045583          	lhu	a1,-64(s0)
    8000311c:	00092503          	lw	a0,0(s2)
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	754080e7          	jalr	1876(ra) # 80002874 <iget>
    80003128:	a011                	j	8000312c <dirlookup+0xa0>
  return 0;
    8000312a:	4501                	li	a0,0
}
    8000312c:	70e2                	ld	ra,56(sp)
    8000312e:	7442                	ld	s0,48(sp)
    80003130:	74a2                	ld	s1,40(sp)
    80003132:	7902                	ld	s2,32(sp)
    80003134:	69e2                	ld	s3,24(sp)
    80003136:	6a42                	ld	s4,16(sp)
    80003138:	6121                	addi	sp,sp,64
    8000313a:	8082                	ret

000000008000313c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000313c:	711d                	addi	sp,sp,-96
    8000313e:	ec86                	sd	ra,88(sp)
    80003140:	e8a2                	sd	s0,80(sp)
    80003142:	e4a6                	sd	s1,72(sp)
    80003144:	e0ca                	sd	s2,64(sp)
    80003146:	fc4e                	sd	s3,56(sp)
    80003148:	f852                	sd	s4,48(sp)
    8000314a:	f456                	sd	s5,40(sp)
    8000314c:	f05a                	sd	s6,32(sp)
    8000314e:	ec5e                	sd	s7,24(sp)
    80003150:	e862                	sd	s8,16(sp)
    80003152:	e466                	sd	s9,8(sp)
    80003154:	1080                	addi	s0,sp,96
    80003156:	84aa                	mv	s1,a0
    80003158:	8b2e                	mv	s6,a1
    8000315a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000315c:	00054703          	lbu	a4,0(a0)
    80003160:	02f00793          	li	a5,47
    80003164:	02f70363          	beq	a4,a5,8000318a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	d32080e7          	jalr	-718(ra) # 80000e9a <myproc>
    80003170:	15053503          	ld	a0,336(a0)
    80003174:	00000097          	auipc	ra,0x0
    80003178:	9f6080e7          	jalr	-1546(ra) # 80002b6a <idup>
    8000317c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000317e:	02f00913          	li	s2,47
  len = path - s;
    80003182:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003184:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003186:	4c05                	li	s8,1
    80003188:	a865                	j	80003240 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000318a:	4585                	li	a1,1
    8000318c:	4505                	li	a0,1
    8000318e:	fffff097          	auipc	ra,0xfffff
    80003192:	6e6080e7          	jalr	1766(ra) # 80002874 <iget>
    80003196:	89aa                	mv	s3,a0
    80003198:	b7dd                	j	8000317e <namex+0x42>
      iunlockput(ip);
    8000319a:	854e                	mv	a0,s3
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	c6e080e7          	jalr	-914(ra) # 80002e0a <iunlockput>
      return 0;
    800031a4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031a6:	854e                	mv	a0,s3
    800031a8:	60e6                	ld	ra,88(sp)
    800031aa:	6446                	ld	s0,80(sp)
    800031ac:	64a6                	ld	s1,72(sp)
    800031ae:	6906                	ld	s2,64(sp)
    800031b0:	79e2                	ld	s3,56(sp)
    800031b2:	7a42                	ld	s4,48(sp)
    800031b4:	7aa2                	ld	s5,40(sp)
    800031b6:	7b02                	ld	s6,32(sp)
    800031b8:	6be2                	ld	s7,24(sp)
    800031ba:	6c42                	ld	s8,16(sp)
    800031bc:	6ca2                	ld	s9,8(sp)
    800031be:	6125                	addi	sp,sp,96
    800031c0:	8082                	ret
      iunlock(ip);
    800031c2:	854e                	mv	a0,s3
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	aa6080e7          	jalr	-1370(ra) # 80002c6a <iunlock>
      return ip;
    800031cc:	bfe9                	j	800031a6 <namex+0x6a>
      iunlockput(ip);
    800031ce:	854e                	mv	a0,s3
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	c3a080e7          	jalr	-966(ra) # 80002e0a <iunlockput>
      return 0;
    800031d8:	89d2                	mv	s3,s4
    800031da:	b7f1                	j	800031a6 <namex+0x6a>
  len = path - s;
    800031dc:	40b48633          	sub	a2,s1,a1
    800031e0:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031e4:	094cd463          	bge	s9,s4,8000326c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031e8:	4639                	li	a2,14
    800031ea:	8556                	mv	a0,s5
    800031ec:	ffffd097          	auipc	ra,0xffffd
    800031f0:	03e080e7          	jalr	62(ra) # 8000022a <memmove>
  while(*path == '/')
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	01279763          	bne	a5,s2,80003206 <namex+0xca>
    path++;
    800031fc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031fe:	0004c783          	lbu	a5,0(s1)
    80003202:	ff278de3          	beq	a5,s2,800031fc <namex+0xc0>
    ilock(ip);
    80003206:	854e                	mv	a0,s3
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	9a0080e7          	jalr	-1632(ra) # 80002ba8 <ilock>
    if(ip->type != T_DIR){
    80003210:	04499783          	lh	a5,68(s3)
    80003214:	f98793e3          	bne	a5,s8,8000319a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003218:	000b0563          	beqz	s6,80003222 <namex+0xe6>
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	d3cd                	beqz	a5,800031c2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003222:	865e                	mv	a2,s7
    80003224:	85d6                	mv	a1,s5
    80003226:	854e                	mv	a0,s3
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	e64080e7          	jalr	-412(ra) # 8000308c <dirlookup>
    80003230:	8a2a                	mv	s4,a0
    80003232:	dd51                	beqz	a0,800031ce <namex+0x92>
    iunlockput(ip);
    80003234:	854e                	mv	a0,s3
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	bd4080e7          	jalr	-1068(ra) # 80002e0a <iunlockput>
    ip = next;
    8000323e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	05279763          	bne	a5,s2,80003292 <namex+0x156>
    path++;
    80003248:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	ff278de3          	beq	a5,s2,80003248 <namex+0x10c>
  if(*path == 0)
    80003252:	c79d                	beqz	a5,80003280 <namex+0x144>
    path++;
    80003254:	85a6                	mv	a1,s1
  len = path - s;
    80003256:	8a5e                	mv	s4,s7
    80003258:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000325a:	01278963          	beq	a5,s2,8000326c <namex+0x130>
    8000325e:	dfbd                	beqz	a5,800031dc <namex+0xa0>
    path++;
    80003260:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003262:	0004c783          	lbu	a5,0(s1)
    80003266:	ff279ce3          	bne	a5,s2,8000325e <namex+0x122>
    8000326a:	bf8d                	j	800031dc <namex+0xa0>
    memmove(name, s, len);
    8000326c:	2601                	sext.w	a2,a2
    8000326e:	8556                	mv	a0,s5
    80003270:	ffffd097          	auipc	ra,0xffffd
    80003274:	fba080e7          	jalr	-70(ra) # 8000022a <memmove>
    name[len] = 0;
    80003278:	9a56                	add	s4,s4,s5
    8000327a:	000a0023          	sb	zero,0(s4)
    8000327e:	bf9d                	j	800031f4 <namex+0xb8>
  if(nameiparent){
    80003280:	f20b03e3          	beqz	s6,800031a6 <namex+0x6a>
    iput(ip);
    80003284:	854e                	mv	a0,s3
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	adc080e7          	jalr	-1316(ra) # 80002d62 <iput>
    return 0;
    8000328e:	4981                	li	s3,0
    80003290:	bf19                	j	800031a6 <namex+0x6a>
  if(*path == 0)
    80003292:	d7fd                	beqz	a5,80003280 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	85a6                	mv	a1,s1
    8000329a:	b7d1                	j	8000325e <namex+0x122>

000000008000329c <dirlink>:
{
    8000329c:	7139                	addi	sp,sp,-64
    8000329e:	fc06                	sd	ra,56(sp)
    800032a0:	f822                	sd	s0,48(sp)
    800032a2:	f426                	sd	s1,40(sp)
    800032a4:	f04a                	sd	s2,32(sp)
    800032a6:	ec4e                	sd	s3,24(sp)
    800032a8:	e852                	sd	s4,16(sp)
    800032aa:	0080                	addi	s0,sp,64
    800032ac:	892a                	mv	s2,a0
    800032ae:	8a2e                	mv	s4,a1
    800032b0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032b2:	4601                	li	a2,0
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	dd8080e7          	jalr	-552(ra) # 8000308c <dirlookup>
    800032bc:	e93d                	bnez	a0,80003332 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032be:	04c92483          	lw	s1,76(s2)
    800032c2:	c49d                	beqz	s1,800032f0 <dirlink+0x54>
    800032c4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c6:	4741                	li	a4,16
    800032c8:	86a6                	mv	a3,s1
    800032ca:	fc040613          	addi	a2,s0,-64
    800032ce:	4581                	li	a1,0
    800032d0:	854a                	mv	a0,s2
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	b8a080e7          	jalr	-1142(ra) # 80002e5c <readi>
    800032da:	47c1                	li	a5,16
    800032dc:	06f51163          	bne	a0,a5,8000333e <dirlink+0xa2>
    if(de.inum == 0)
    800032e0:	fc045783          	lhu	a5,-64(s0)
    800032e4:	c791                	beqz	a5,800032f0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e6:	24c1                	addiw	s1,s1,16
    800032e8:	04c92783          	lw	a5,76(s2)
    800032ec:	fcf4ede3          	bltu	s1,a5,800032c6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032f0:	4639                	li	a2,14
    800032f2:	85d2                	mv	a1,s4
    800032f4:	fc240513          	addi	a0,s0,-62
    800032f8:	ffffd097          	auipc	ra,0xffffd
    800032fc:	fe6080e7          	jalr	-26(ra) # 800002de <strncpy>
  de.inum = inum;
    80003300:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003304:	4741                	li	a4,16
    80003306:	86a6                	mv	a3,s1
    80003308:	fc040613          	addi	a2,s0,-64
    8000330c:	4581                	li	a1,0
    8000330e:	854a                	mv	a0,s2
    80003310:	00000097          	auipc	ra,0x0
    80003314:	c44080e7          	jalr	-956(ra) # 80002f54 <writei>
    80003318:	872a                	mv	a4,a0
    8000331a:	47c1                	li	a5,16
  return 0;
    8000331c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331e:	02f71863          	bne	a4,a5,8000334e <dirlink+0xb2>
}
    80003322:	70e2                	ld	ra,56(sp)
    80003324:	7442                	ld	s0,48(sp)
    80003326:	74a2                	ld	s1,40(sp)
    80003328:	7902                	ld	s2,32(sp)
    8000332a:	69e2                	ld	s3,24(sp)
    8000332c:	6a42                	ld	s4,16(sp)
    8000332e:	6121                	addi	sp,sp,64
    80003330:	8082                	ret
    iput(ip);
    80003332:	00000097          	auipc	ra,0x0
    80003336:	a30080e7          	jalr	-1488(ra) # 80002d62 <iput>
    return -1;
    8000333a:	557d                	li	a0,-1
    8000333c:	b7dd                	j	80003322 <dirlink+0x86>
      panic("dirlink read");
    8000333e:	00005517          	auipc	a0,0x5
    80003342:	3f250513          	addi	a0,a0,1010 # 80008730 <syscalls_name+0x1d8>
    80003346:	00003097          	auipc	ra,0x3
    8000334a:	912080e7          	jalr	-1774(ra) # 80005c58 <panic>
    panic("dirlink");
    8000334e:	00005517          	auipc	a0,0x5
    80003352:	4ea50513          	addi	a0,a0,1258 # 80008838 <syscalls_name+0x2e0>
    80003356:	00003097          	auipc	ra,0x3
    8000335a:	902080e7          	jalr	-1790(ra) # 80005c58 <panic>

000000008000335e <namei>:

struct inode*
namei(char *path)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003366:	fe040613          	addi	a2,s0,-32
    8000336a:	4581                	li	a1,0
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	dd0080e7          	jalr	-560(ra) # 8000313c <namex>
}
    80003374:	60e2                	ld	ra,24(sp)
    80003376:	6442                	ld	s0,16(sp)
    80003378:	6105                	addi	sp,sp,32
    8000337a:	8082                	ret

000000008000337c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000337c:	1141                	addi	sp,sp,-16
    8000337e:	e406                	sd	ra,8(sp)
    80003380:	e022                	sd	s0,0(sp)
    80003382:	0800                	addi	s0,sp,16
    80003384:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003386:	4585                	li	a1,1
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	db4080e7          	jalr	-588(ra) # 8000313c <namex>
}
    80003390:	60a2                	ld	ra,8(sp)
    80003392:	6402                	ld	s0,0(sp)
    80003394:	0141                	addi	sp,sp,16
    80003396:	8082                	ret

0000000080003398 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	e426                	sd	s1,8(sp)
    800033a0:	e04a                	sd	s2,0(sp)
    800033a2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033a4:	00016917          	auipc	s2,0x16
    800033a8:	c7c90913          	addi	s2,s2,-900 # 80019020 <log>
    800033ac:	01892583          	lw	a1,24(s2)
    800033b0:	02892503          	lw	a0,40(s2)
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	ff2080e7          	jalr	-14(ra) # 800023a6 <bread>
    800033bc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033be:	02c92683          	lw	a3,44(s2)
    800033c2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033c4:	02d05763          	blez	a3,800033f2 <write_head+0x5a>
    800033c8:	00016797          	auipc	a5,0x16
    800033cc:	c8878793          	addi	a5,a5,-888 # 80019050 <log+0x30>
    800033d0:	05c50713          	addi	a4,a0,92
    800033d4:	36fd                	addiw	a3,a3,-1
    800033d6:	1682                	slli	a3,a3,0x20
    800033d8:	9281                	srli	a3,a3,0x20
    800033da:	068a                	slli	a3,a3,0x2
    800033dc:	00016617          	auipc	a2,0x16
    800033e0:	c7860613          	addi	a2,a2,-904 # 80019054 <log+0x34>
    800033e4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033e6:	4390                	lw	a2,0(a5)
    800033e8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033ea:	0791                	addi	a5,a5,4
    800033ec:	0711                	addi	a4,a4,4
    800033ee:	fed79ce3          	bne	a5,a3,800033e6 <write_head+0x4e>
  }
  bwrite(buf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	0a4080e7          	jalr	164(ra) # 80002498 <bwrite>
  brelse(buf);
    800033fc:	8526                	mv	a0,s1
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	0d8080e7          	jalr	216(ra) # 800024d6 <brelse>
}
    80003406:	60e2                	ld	ra,24(sp)
    80003408:	6442                	ld	s0,16(sp)
    8000340a:	64a2                	ld	s1,8(sp)
    8000340c:	6902                	ld	s2,0(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret

0000000080003412 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003412:	00016797          	auipc	a5,0x16
    80003416:	c3a7a783          	lw	a5,-966(a5) # 8001904c <log+0x2c>
    8000341a:	0af05d63          	blez	a5,800034d4 <install_trans+0xc2>
{
    8000341e:	7139                	addi	sp,sp,-64
    80003420:	fc06                	sd	ra,56(sp)
    80003422:	f822                	sd	s0,48(sp)
    80003424:	f426                	sd	s1,40(sp)
    80003426:	f04a                	sd	s2,32(sp)
    80003428:	ec4e                	sd	s3,24(sp)
    8000342a:	e852                	sd	s4,16(sp)
    8000342c:	e456                	sd	s5,8(sp)
    8000342e:	e05a                	sd	s6,0(sp)
    80003430:	0080                	addi	s0,sp,64
    80003432:	8b2a                	mv	s6,a0
    80003434:	00016a97          	auipc	s5,0x16
    80003438:	c1ca8a93          	addi	s5,s5,-996 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000343e:	00016997          	auipc	s3,0x16
    80003442:	be298993          	addi	s3,s3,-1054 # 80019020 <log>
    80003446:	a035                	j	80003472 <install_trans+0x60>
      bunpin(dbuf);
    80003448:	8526                	mv	a0,s1
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	166080e7          	jalr	358(ra) # 800025b0 <bunpin>
    brelse(lbuf);
    80003452:	854a                	mv	a0,s2
    80003454:	fffff097          	auipc	ra,0xfffff
    80003458:	082080e7          	jalr	130(ra) # 800024d6 <brelse>
    brelse(dbuf);
    8000345c:	8526                	mv	a0,s1
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	078080e7          	jalr	120(ra) # 800024d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003466:	2a05                	addiw	s4,s4,1
    80003468:	0a91                	addi	s5,s5,4
    8000346a:	02c9a783          	lw	a5,44(s3)
    8000346e:	04fa5963          	bge	s4,a5,800034c0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003472:	0189a583          	lw	a1,24(s3)
    80003476:	014585bb          	addw	a1,a1,s4
    8000347a:	2585                	addiw	a1,a1,1
    8000347c:	0289a503          	lw	a0,40(s3)
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	f26080e7          	jalr	-218(ra) # 800023a6 <bread>
    80003488:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000348a:	000aa583          	lw	a1,0(s5)
    8000348e:	0289a503          	lw	a0,40(s3)
    80003492:	fffff097          	auipc	ra,0xfffff
    80003496:	f14080e7          	jalr	-236(ra) # 800023a6 <bread>
    8000349a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000349c:	40000613          	li	a2,1024
    800034a0:	05890593          	addi	a1,s2,88
    800034a4:	05850513          	addi	a0,a0,88
    800034a8:	ffffd097          	auipc	ra,0xffffd
    800034ac:	d82080e7          	jalr	-638(ra) # 8000022a <memmove>
    bwrite(dbuf);  // write dst to disk
    800034b0:	8526                	mv	a0,s1
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	fe6080e7          	jalr	-26(ra) # 80002498 <bwrite>
    if(recovering == 0)
    800034ba:	f80b1ce3          	bnez	s6,80003452 <install_trans+0x40>
    800034be:	b769                	j	80003448 <install_trans+0x36>
}
    800034c0:	70e2                	ld	ra,56(sp)
    800034c2:	7442                	ld	s0,48(sp)
    800034c4:	74a2                	ld	s1,40(sp)
    800034c6:	7902                	ld	s2,32(sp)
    800034c8:	69e2                	ld	s3,24(sp)
    800034ca:	6a42                	ld	s4,16(sp)
    800034cc:	6aa2                	ld	s5,8(sp)
    800034ce:	6b02                	ld	s6,0(sp)
    800034d0:	6121                	addi	sp,sp,64
    800034d2:	8082                	ret
    800034d4:	8082                	ret

00000000800034d6 <initlog>:
{
    800034d6:	7179                	addi	sp,sp,-48
    800034d8:	f406                	sd	ra,40(sp)
    800034da:	f022                	sd	s0,32(sp)
    800034dc:	ec26                	sd	s1,24(sp)
    800034de:	e84a                	sd	s2,16(sp)
    800034e0:	e44e                	sd	s3,8(sp)
    800034e2:	1800                	addi	s0,sp,48
    800034e4:	892a                	mv	s2,a0
    800034e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e8:	00016497          	auipc	s1,0x16
    800034ec:	b3848493          	addi	s1,s1,-1224 # 80019020 <log>
    800034f0:	00005597          	auipc	a1,0x5
    800034f4:	25058593          	addi	a1,a1,592 # 80008740 <syscalls_name+0x1e8>
    800034f8:	8526                	mv	a0,s1
    800034fa:	00003097          	auipc	ra,0x3
    800034fe:	c18080e7          	jalr	-1000(ra) # 80006112 <initlock>
  log.start = sb->logstart;
    80003502:	0149a583          	lw	a1,20(s3)
    80003506:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003508:	0109a783          	lw	a5,16(s3)
    8000350c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000350e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003512:	854a                	mv	a0,s2
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	e92080e7          	jalr	-366(ra) # 800023a6 <bread>
  log.lh.n = lh->n;
    8000351c:	4d3c                	lw	a5,88(a0)
    8000351e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003520:	02f05563          	blez	a5,8000354a <initlog+0x74>
    80003524:	05c50713          	addi	a4,a0,92
    80003528:	00016697          	auipc	a3,0x16
    8000352c:	b2868693          	addi	a3,a3,-1240 # 80019050 <log+0x30>
    80003530:	37fd                	addiw	a5,a5,-1
    80003532:	1782                	slli	a5,a5,0x20
    80003534:	9381                	srli	a5,a5,0x20
    80003536:	078a                	slli	a5,a5,0x2
    80003538:	06050613          	addi	a2,a0,96
    8000353c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000353e:	4310                	lw	a2,0(a4)
    80003540:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	0711                	addi	a4,a4,4
    80003544:	0691                	addi	a3,a3,4
    80003546:	fef71ce3          	bne	a4,a5,8000353e <initlog+0x68>
  brelse(buf);
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	f8c080e7          	jalr	-116(ra) # 800024d6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003552:	4505                	li	a0,1
    80003554:	00000097          	auipc	ra,0x0
    80003558:	ebe080e7          	jalr	-322(ra) # 80003412 <install_trans>
  log.lh.n = 0;
    8000355c:	00016797          	auipc	a5,0x16
    80003560:	ae07a823          	sw	zero,-1296(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003564:	00000097          	auipc	ra,0x0
    80003568:	e34080e7          	jalr	-460(ra) # 80003398 <write_head>
}
    8000356c:	70a2                	ld	ra,40(sp)
    8000356e:	7402                	ld	s0,32(sp)
    80003570:	64e2                	ld	s1,24(sp)
    80003572:	6942                	ld	s2,16(sp)
    80003574:	69a2                	ld	s3,8(sp)
    80003576:	6145                	addi	sp,sp,48
    80003578:	8082                	ret

000000008000357a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	e04a                	sd	s2,0(sp)
    80003584:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003586:	00016517          	auipc	a0,0x16
    8000358a:	a9a50513          	addi	a0,a0,-1382 # 80019020 <log>
    8000358e:	00003097          	auipc	ra,0x3
    80003592:	c14080e7          	jalr	-1004(ra) # 800061a2 <acquire>
  while(1){
    if(log.committing){
    80003596:	00016497          	auipc	s1,0x16
    8000359a:	a8a48493          	addi	s1,s1,-1398 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359e:	4979                	li	s2,30
    800035a0:	a039                	j	800035ae <begin_op+0x34>
      sleep(&log, &log.lock);
    800035a2:	85a6                	mv	a1,s1
    800035a4:	8526                	mv	a0,s1
    800035a6:	ffffe097          	auipc	ra,0xffffe
    800035aa:	fb8080e7          	jalr	-72(ra) # 8000155e <sleep>
    if(log.committing){
    800035ae:	50dc                	lw	a5,36(s1)
    800035b0:	fbed                	bnez	a5,800035a2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b2:	509c                	lw	a5,32(s1)
    800035b4:	0017871b          	addiw	a4,a5,1
    800035b8:	0007069b          	sext.w	a3,a4
    800035bc:	0027179b          	slliw	a5,a4,0x2
    800035c0:	9fb9                	addw	a5,a5,a4
    800035c2:	0017979b          	slliw	a5,a5,0x1
    800035c6:	54d8                	lw	a4,44(s1)
    800035c8:	9fb9                	addw	a5,a5,a4
    800035ca:	00f95963          	bge	s2,a5,800035dc <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ce:	85a6                	mv	a1,s1
    800035d0:	8526                	mv	a0,s1
    800035d2:	ffffe097          	auipc	ra,0xffffe
    800035d6:	f8c080e7          	jalr	-116(ra) # 8000155e <sleep>
    800035da:	bfd1                	j	800035ae <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035dc:	00016517          	auipc	a0,0x16
    800035e0:	a4450513          	addi	a0,a0,-1468 # 80019020 <log>
    800035e4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035e6:	00003097          	auipc	ra,0x3
    800035ea:	c70080e7          	jalr	-912(ra) # 80006256 <release>
      break;
    }
  }
}
    800035ee:	60e2                	ld	ra,24(sp)
    800035f0:	6442                	ld	s0,16(sp)
    800035f2:	64a2                	ld	s1,8(sp)
    800035f4:	6902                	ld	s2,0(sp)
    800035f6:	6105                	addi	sp,sp,32
    800035f8:	8082                	ret

00000000800035fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035fa:	7139                	addi	sp,sp,-64
    800035fc:	fc06                	sd	ra,56(sp)
    800035fe:	f822                	sd	s0,48(sp)
    80003600:	f426                	sd	s1,40(sp)
    80003602:	f04a                	sd	s2,32(sp)
    80003604:	ec4e                	sd	s3,24(sp)
    80003606:	e852                	sd	s4,16(sp)
    80003608:	e456                	sd	s5,8(sp)
    8000360a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000360c:	00016497          	auipc	s1,0x16
    80003610:	a1448493          	addi	s1,s1,-1516 # 80019020 <log>
    80003614:	8526                	mv	a0,s1
    80003616:	00003097          	auipc	ra,0x3
    8000361a:	b8c080e7          	jalr	-1140(ra) # 800061a2 <acquire>
  log.outstanding -= 1;
    8000361e:	509c                	lw	a5,32(s1)
    80003620:	37fd                	addiw	a5,a5,-1
    80003622:	0007891b          	sext.w	s2,a5
    80003626:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003628:	50dc                	lw	a5,36(s1)
    8000362a:	efb9                	bnez	a5,80003688 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000362c:	06091663          	bnez	s2,80003698 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003630:	00016497          	auipc	s1,0x16
    80003634:	9f048493          	addi	s1,s1,-1552 # 80019020 <log>
    80003638:	4785                	li	a5,1
    8000363a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000363c:	8526                	mv	a0,s1
    8000363e:	00003097          	auipc	ra,0x3
    80003642:	c18080e7          	jalr	-1000(ra) # 80006256 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003646:	54dc                	lw	a5,44(s1)
    80003648:	06f04763          	bgtz	a5,800036b6 <end_op+0xbc>
    acquire(&log.lock);
    8000364c:	00016497          	auipc	s1,0x16
    80003650:	9d448493          	addi	s1,s1,-1580 # 80019020 <log>
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	b4c080e7          	jalr	-1204(ra) # 800061a2 <acquire>
    log.committing = 0;
    8000365e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003662:	8526                	mv	a0,s1
    80003664:	ffffe097          	auipc	ra,0xffffe
    80003668:	086080e7          	jalr	134(ra) # 800016ea <wakeup>
    release(&log.lock);
    8000366c:	8526                	mv	a0,s1
    8000366e:	00003097          	auipc	ra,0x3
    80003672:	be8080e7          	jalr	-1048(ra) # 80006256 <release>
}
    80003676:	70e2                	ld	ra,56(sp)
    80003678:	7442                	ld	s0,48(sp)
    8000367a:	74a2                	ld	s1,40(sp)
    8000367c:	7902                	ld	s2,32(sp)
    8000367e:	69e2                	ld	s3,24(sp)
    80003680:	6a42                	ld	s4,16(sp)
    80003682:	6aa2                	ld	s5,8(sp)
    80003684:	6121                	addi	sp,sp,64
    80003686:	8082                	ret
    panic("log.committing");
    80003688:	00005517          	auipc	a0,0x5
    8000368c:	0c050513          	addi	a0,a0,192 # 80008748 <syscalls_name+0x1f0>
    80003690:	00002097          	auipc	ra,0x2
    80003694:	5c8080e7          	jalr	1480(ra) # 80005c58 <panic>
    wakeup(&log);
    80003698:	00016497          	auipc	s1,0x16
    8000369c:	98848493          	addi	s1,s1,-1656 # 80019020 <log>
    800036a0:	8526                	mv	a0,s1
    800036a2:	ffffe097          	auipc	ra,0xffffe
    800036a6:	048080e7          	jalr	72(ra) # 800016ea <wakeup>
  release(&log.lock);
    800036aa:	8526                	mv	a0,s1
    800036ac:	00003097          	auipc	ra,0x3
    800036b0:	baa080e7          	jalr	-1110(ra) # 80006256 <release>
  if(do_commit){
    800036b4:	b7c9                	j	80003676 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b6:	00016a97          	auipc	s5,0x16
    800036ba:	99aa8a93          	addi	s5,s5,-1638 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036be:	00016a17          	auipc	s4,0x16
    800036c2:	962a0a13          	addi	s4,s4,-1694 # 80019020 <log>
    800036c6:	018a2583          	lw	a1,24(s4)
    800036ca:	012585bb          	addw	a1,a1,s2
    800036ce:	2585                	addiw	a1,a1,1
    800036d0:	028a2503          	lw	a0,40(s4)
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	cd2080e7          	jalr	-814(ra) # 800023a6 <bread>
    800036dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036de:	000aa583          	lw	a1,0(s5)
    800036e2:	028a2503          	lw	a0,40(s4)
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	cc0080e7          	jalr	-832(ra) # 800023a6 <bread>
    800036ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036f0:	40000613          	li	a2,1024
    800036f4:	05850593          	addi	a1,a0,88
    800036f8:	05848513          	addi	a0,s1,88
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	b2e080e7          	jalr	-1234(ra) # 8000022a <memmove>
    bwrite(to);  // write the log
    80003704:	8526                	mv	a0,s1
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	d92080e7          	jalr	-622(ra) # 80002498 <bwrite>
    brelse(from);
    8000370e:	854e                	mv	a0,s3
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	dc6080e7          	jalr	-570(ra) # 800024d6 <brelse>
    brelse(to);
    80003718:	8526                	mv	a0,s1
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	dbc080e7          	jalr	-580(ra) # 800024d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003722:	2905                	addiw	s2,s2,1
    80003724:	0a91                	addi	s5,s5,4
    80003726:	02ca2783          	lw	a5,44(s4)
    8000372a:	f8f94ee3          	blt	s2,a5,800036c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	c6a080e7          	jalr	-918(ra) # 80003398 <write_head>
    install_trans(0); // Now install writes to home locations
    80003736:	4501                	li	a0,0
    80003738:	00000097          	auipc	ra,0x0
    8000373c:	cda080e7          	jalr	-806(ra) # 80003412 <install_trans>
    log.lh.n = 0;
    80003740:	00016797          	auipc	a5,0x16
    80003744:	9007a623          	sw	zero,-1780(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	c50080e7          	jalr	-944(ra) # 80003398 <write_head>
    80003750:	bdf5                	j	8000364c <end_op+0x52>

0000000080003752 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003752:	1101                	addi	sp,sp,-32
    80003754:	ec06                	sd	ra,24(sp)
    80003756:	e822                	sd	s0,16(sp)
    80003758:	e426                	sd	s1,8(sp)
    8000375a:	e04a                	sd	s2,0(sp)
    8000375c:	1000                	addi	s0,sp,32
    8000375e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003760:	00016917          	auipc	s2,0x16
    80003764:	8c090913          	addi	s2,s2,-1856 # 80019020 <log>
    80003768:	854a                	mv	a0,s2
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	a38080e7          	jalr	-1480(ra) # 800061a2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003772:	02c92603          	lw	a2,44(s2)
    80003776:	47f5                	li	a5,29
    80003778:	06c7c563          	blt	a5,a2,800037e2 <log_write+0x90>
    8000377c:	00016797          	auipc	a5,0x16
    80003780:	8c07a783          	lw	a5,-1856(a5) # 8001903c <log+0x1c>
    80003784:	37fd                	addiw	a5,a5,-1
    80003786:	04f65e63          	bge	a2,a5,800037e2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000378a:	00016797          	auipc	a5,0x16
    8000378e:	8b67a783          	lw	a5,-1866(a5) # 80019040 <log+0x20>
    80003792:	06f05063          	blez	a5,800037f2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003796:	4781                	li	a5,0
    80003798:	06c05563          	blez	a2,80003802 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379c:	44cc                	lw	a1,12(s1)
    8000379e:	00016717          	auipc	a4,0x16
    800037a2:	8b270713          	addi	a4,a4,-1870 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037a6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a8:	4314                	lw	a3,0(a4)
    800037aa:	04b68c63          	beq	a3,a1,80003802 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ae:	2785                	addiw	a5,a5,1
    800037b0:	0711                	addi	a4,a4,4
    800037b2:	fef61be3          	bne	a2,a5,800037a8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037b6:	0621                	addi	a2,a2,8
    800037b8:	060a                	slli	a2,a2,0x2
    800037ba:	00016797          	auipc	a5,0x16
    800037be:	86678793          	addi	a5,a5,-1946 # 80019020 <log>
    800037c2:	963e                	add	a2,a2,a5
    800037c4:	44dc                	lw	a5,12(s1)
    800037c6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	daa080e7          	jalr	-598(ra) # 80002574 <bpin>
    log.lh.n++;
    800037d2:	00016717          	auipc	a4,0x16
    800037d6:	84e70713          	addi	a4,a4,-1970 # 80019020 <log>
    800037da:	575c                	lw	a5,44(a4)
    800037dc:	2785                	addiw	a5,a5,1
    800037de:	d75c                	sw	a5,44(a4)
    800037e0:	a835                	j	8000381c <log_write+0xca>
    panic("too big a transaction");
    800037e2:	00005517          	auipc	a0,0x5
    800037e6:	f7650513          	addi	a0,a0,-138 # 80008758 <syscalls_name+0x200>
    800037ea:	00002097          	auipc	ra,0x2
    800037ee:	46e080e7          	jalr	1134(ra) # 80005c58 <panic>
    panic("log_write outside of trans");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	f7e50513          	addi	a0,a0,-130 # 80008770 <syscalls_name+0x218>
    800037fa:	00002097          	auipc	ra,0x2
    800037fe:	45e080e7          	jalr	1118(ra) # 80005c58 <panic>
  log.lh.block[i] = b->blockno;
    80003802:	00878713          	addi	a4,a5,8
    80003806:	00271693          	slli	a3,a4,0x2
    8000380a:	00016717          	auipc	a4,0x16
    8000380e:	81670713          	addi	a4,a4,-2026 # 80019020 <log>
    80003812:	9736                	add	a4,a4,a3
    80003814:	44d4                	lw	a3,12(s1)
    80003816:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003818:	faf608e3          	beq	a2,a5,800037c8 <log_write+0x76>
  }
  release(&log.lock);
    8000381c:	00016517          	auipc	a0,0x16
    80003820:	80450513          	addi	a0,a0,-2044 # 80019020 <log>
    80003824:	00003097          	auipc	ra,0x3
    80003828:	a32080e7          	jalr	-1486(ra) # 80006256 <release>
}
    8000382c:	60e2                	ld	ra,24(sp)
    8000382e:	6442                	ld	s0,16(sp)
    80003830:	64a2                	ld	s1,8(sp)
    80003832:	6902                	ld	s2,0(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003838:	1101                	addi	sp,sp,-32
    8000383a:	ec06                	sd	ra,24(sp)
    8000383c:	e822                	sd	s0,16(sp)
    8000383e:	e426                	sd	s1,8(sp)
    80003840:	e04a                	sd	s2,0(sp)
    80003842:	1000                	addi	s0,sp,32
    80003844:	84aa                	mv	s1,a0
    80003846:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003848:	00005597          	auipc	a1,0x5
    8000384c:	f4858593          	addi	a1,a1,-184 # 80008790 <syscalls_name+0x238>
    80003850:	0521                	addi	a0,a0,8
    80003852:	00003097          	auipc	ra,0x3
    80003856:	8c0080e7          	jalr	-1856(ra) # 80006112 <initlock>
  lk->name = name;
    8000385a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000385e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003862:	0204a423          	sw	zero,40(s1)
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
    8000388a:	91c080e7          	jalr	-1764(ra) # 800061a2 <acquire>
  while (lk->locked) {
    8000388e:	409c                	lw	a5,0(s1)
    80003890:	cb89                	beqz	a5,800038a2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003892:	85ca                	mv	a1,s2
    80003894:	8526                	mv	a0,s1
    80003896:	ffffe097          	auipc	ra,0xffffe
    8000389a:	cc8080e7          	jalr	-824(ra) # 8000155e <sleep>
  while (lk->locked) {
    8000389e:	409c                	lw	a5,0(s1)
    800038a0:	fbed                	bnez	a5,80003892 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038a2:	4785                	li	a5,1
    800038a4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	5f4080e7          	jalr	1524(ra) # 80000e9a <myproc>
    800038ae:	591c                	lw	a5,48(a0)
    800038b0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038b2:	854a                	mv	a0,s2
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	9a2080e7          	jalr	-1630(ra) # 80006256 <release>
}
    800038bc:	60e2                	ld	ra,24(sp)
    800038be:	6442                	ld	s0,16(sp)
    800038c0:	64a2                	ld	s1,8(sp)
    800038c2:	6902                	ld	s2,0(sp)
    800038c4:	6105                	addi	sp,sp,32
    800038c6:	8082                	ret

00000000800038c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d6:	00850913          	addi	s2,a0,8
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	8c6080e7          	jalr	-1850(ra) # 800061a2 <acquire>
  lk->locked = 0;
    800038e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038ec:	8526                	mv	a0,s1
    800038ee:	ffffe097          	auipc	ra,0xffffe
    800038f2:	dfc080e7          	jalr	-516(ra) # 800016ea <wakeup>
  release(&lk->lk);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	95e080e7          	jalr	-1698(ra) # 80006256 <release>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret

000000008000390c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000390c:	7179                	addi	sp,sp,-48
    8000390e:	f406                	sd	ra,40(sp)
    80003910:	f022                	sd	s0,32(sp)
    80003912:	ec26                	sd	s1,24(sp)
    80003914:	e84a                	sd	s2,16(sp)
    80003916:	e44e                	sd	s3,8(sp)
    80003918:	1800                	addi	s0,sp,48
    8000391a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000391c:	00850913          	addi	s2,a0,8
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	880080e7          	jalr	-1920(ra) # 800061a2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000392a:	409c                	lw	a5,0(s1)
    8000392c:	ef99                	bnez	a5,8000394a <holdingsleep+0x3e>
    8000392e:	4481                	li	s1,0
  release(&lk->lk);
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	924080e7          	jalr	-1756(ra) # 80006256 <release>
  return r;
}
    8000393a:	8526                	mv	a0,s1
    8000393c:	70a2                	ld	ra,40(sp)
    8000393e:	7402                	ld	s0,32(sp)
    80003940:	64e2                	ld	s1,24(sp)
    80003942:	6942                	ld	s2,16(sp)
    80003944:	69a2                	ld	s3,8(sp)
    80003946:	6145                	addi	sp,sp,48
    80003948:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000394a:	0284a983          	lw	s3,40(s1)
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	54c080e7          	jalr	1356(ra) # 80000e9a <myproc>
    80003956:	5904                	lw	s1,48(a0)
    80003958:	413484b3          	sub	s1,s1,s3
    8000395c:	0014b493          	seqz	s1,s1
    80003960:	bfc1                	j	80003930 <holdingsleep+0x24>

0000000080003962 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003962:	1141                	addi	sp,sp,-16
    80003964:	e406                	sd	ra,8(sp)
    80003966:	e022                	sd	s0,0(sp)
    80003968:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000396a:	00005597          	auipc	a1,0x5
    8000396e:	e3658593          	addi	a1,a1,-458 # 800087a0 <syscalls_name+0x248>
    80003972:	00015517          	auipc	a0,0x15
    80003976:	7f650513          	addi	a0,a0,2038 # 80019168 <ftable>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	798080e7          	jalr	1944(ra) # 80006112 <initlock>
}
    80003982:	60a2                	ld	ra,8(sp)
    80003984:	6402                	ld	s0,0(sp)
    80003986:	0141                	addi	sp,sp,16
    80003988:	8082                	ret

000000008000398a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003994:	00015517          	auipc	a0,0x15
    80003998:	7d450513          	addi	a0,a0,2004 # 80019168 <ftable>
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	806080e7          	jalr	-2042(ra) # 800061a2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a4:	00015497          	auipc	s1,0x15
    800039a8:	7dc48493          	addi	s1,s1,2012 # 80019180 <ftable+0x18>
    800039ac:	00016717          	auipc	a4,0x16
    800039b0:	77470713          	addi	a4,a4,1908 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039b4:	40dc                	lw	a5,4(s1)
    800039b6:	cf99                	beqz	a5,800039d4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b8:	02848493          	addi	s1,s1,40
    800039bc:	fee49ce3          	bne	s1,a4,800039b4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039c0:	00015517          	auipc	a0,0x15
    800039c4:	7a850513          	addi	a0,a0,1960 # 80019168 <ftable>
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	88e080e7          	jalr	-1906(ra) # 80006256 <release>
  return 0;
    800039d0:	4481                	li	s1,0
    800039d2:	a819                	j	800039e8 <filealloc+0x5e>
      f->ref = 1;
    800039d4:	4785                	li	a5,1
    800039d6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039d8:	00015517          	auipc	a0,0x15
    800039dc:	79050513          	addi	a0,a0,1936 # 80019168 <ftable>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	876080e7          	jalr	-1930(ra) # 80006256 <release>
}
    800039e8:	8526                	mv	a0,s1
    800039ea:	60e2                	ld	ra,24(sp)
    800039ec:	6442                	ld	s0,16(sp)
    800039ee:	64a2                	ld	s1,8(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039f4:	1101                	addi	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	e426                	sd	s1,8(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a00:	00015517          	auipc	a0,0x15
    80003a04:	76850513          	addi	a0,a0,1896 # 80019168 <ftable>
    80003a08:	00002097          	auipc	ra,0x2
    80003a0c:	79a080e7          	jalr	1946(ra) # 800061a2 <acquire>
  if(f->ref < 1)
    80003a10:	40dc                	lw	a5,4(s1)
    80003a12:	02f05263          	blez	a5,80003a36 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a16:	2785                	addiw	a5,a5,1
    80003a18:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a1a:	00015517          	auipc	a0,0x15
    80003a1e:	74e50513          	addi	a0,a0,1870 # 80019168 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	834080e7          	jalr	-1996(ra) # 80006256 <release>
  return f;
}
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	60e2                	ld	ra,24(sp)
    80003a2e:	6442                	ld	s0,16(sp)
    80003a30:	64a2                	ld	s1,8(sp)
    80003a32:	6105                	addi	sp,sp,32
    80003a34:	8082                	ret
    panic("filedup");
    80003a36:	00005517          	auipc	a0,0x5
    80003a3a:	d7250513          	addi	a0,a0,-654 # 800087a8 <syscalls_name+0x250>
    80003a3e:	00002097          	auipc	ra,0x2
    80003a42:	21a080e7          	jalr	538(ra) # 80005c58 <panic>

0000000080003a46 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a46:	7139                	addi	sp,sp,-64
    80003a48:	fc06                	sd	ra,56(sp)
    80003a4a:	f822                	sd	s0,48(sp)
    80003a4c:	f426                	sd	s1,40(sp)
    80003a4e:	f04a                	sd	s2,32(sp)
    80003a50:	ec4e                	sd	s3,24(sp)
    80003a52:	e852                	sd	s4,16(sp)
    80003a54:	e456                	sd	s5,8(sp)
    80003a56:	0080                	addi	s0,sp,64
    80003a58:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a5a:	00015517          	auipc	a0,0x15
    80003a5e:	70e50513          	addi	a0,a0,1806 # 80019168 <ftable>
    80003a62:	00002097          	auipc	ra,0x2
    80003a66:	740080e7          	jalr	1856(ra) # 800061a2 <acquire>
  if(f->ref < 1)
    80003a6a:	40dc                	lw	a5,4(s1)
    80003a6c:	06f05163          	blez	a5,80003ace <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a70:	37fd                	addiw	a5,a5,-1
    80003a72:	0007871b          	sext.w	a4,a5
    80003a76:	c0dc                	sw	a5,4(s1)
    80003a78:	06e04363          	bgtz	a4,80003ade <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a7c:	0004a903          	lw	s2,0(s1)
    80003a80:	0094ca83          	lbu	s5,9(s1)
    80003a84:	0104ba03          	ld	s4,16(s1)
    80003a88:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a8c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a90:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a94:	00015517          	auipc	a0,0x15
    80003a98:	6d450513          	addi	a0,a0,1748 # 80019168 <ftable>
    80003a9c:	00002097          	auipc	ra,0x2
    80003aa0:	7ba080e7          	jalr	1978(ra) # 80006256 <release>

  if(ff.type == FD_PIPE){
    80003aa4:	4785                	li	a5,1
    80003aa6:	04f90d63          	beq	s2,a5,80003b00 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aaa:	3979                	addiw	s2,s2,-2
    80003aac:	4785                	li	a5,1
    80003aae:	0527e063          	bltu	a5,s2,80003aee <fileclose+0xa8>
    begin_op();
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	ac8080e7          	jalr	-1336(ra) # 8000357a <begin_op>
    iput(ff.ip);
    80003aba:	854e                	mv	a0,s3
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	2a6080e7          	jalr	678(ra) # 80002d62 <iput>
    end_op();
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	b36080e7          	jalr	-1226(ra) # 800035fa <end_op>
    80003acc:	a00d                	j	80003aee <fileclose+0xa8>
    panic("fileclose");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	ce250513          	addi	a0,a0,-798 # 800087b0 <syscalls_name+0x258>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	182080e7          	jalr	386(ra) # 80005c58 <panic>
    release(&ftable.lock);
    80003ade:	00015517          	auipc	a0,0x15
    80003ae2:	68a50513          	addi	a0,a0,1674 # 80019168 <ftable>
    80003ae6:	00002097          	auipc	ra,0x2
    80003aea:	770080e7          	jalr	1904(ra) # 80006256 <release>
  }
}
    80003aee:	70e2                	ld	ra,56(sp)
    80003af0:	7442                	ld	s0,48(sp)
    80003af2:	74a2                	ld	s1,40(sp)
    80003af4:	7902                	ld	s2,32(sp)
    80003af6:	69e2                	ld	s3,24(sp)
    80003af8:	6a42                	ld	s4,16(sp)
    80003afa:	6aa2                	ld	s5,8(sp)
    80003afc:	6121                	addi	sp,sp,64
    80003afe:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b00:	85d6                	mv	a1,s5
    80003b02:	8552                	mv	a0,s4
    80003b04:	00000097          	auipc	ra,0x0
    80003b08:	34c080e7          	jalr	844(ra) # 80003e50 <pipeclose>
    80003b0c:	b7cd                	j	80003aee <fileclose+0xa8>

0000000080003b0e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b0e:	715d                	addi	sp,sp,-80
    80003b10:	e486                	sd	ra,72(sp)
    80003b12:	e0a2                	sd	s0,64(sp)
    80003b14:	fc26                	sd	s1,56(sp)
    80003b16:	f84a                	sd	s2,48(sp)
    80003b18:	f44e                	sd	s3,40(sp)
    80003b1a:	0880                	addi	s0,sp,80
    80003b1c:	84aa                	mv	s1,a0
    80003b1e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	37a080e7          	jalr	890(ra) # 80000e9a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b28:	409c                	lw	a5,0(s1)
    80003b2a:	37f9                	addiw	a5,a5,-2
    80003b2c:	4705                	li	a4,1
    80003b2e:	04f76763          	bltu	a4,a5,80003b7c <filestat+0x6e>
    80003b32:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b34:	6c88                	ld	a0,24(s1)
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	072080e7          	jalr	114(ra) # 80002ba8 <ilock>
    stati(f->ip, &st);
    80003b3e:	fb840593          	addi	a1,s0,-72
    80003b42:	6c88                	ld	a0,24(s1)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	2ee080e7          	jalr	750(ra) # 80002e32 <stati>
    iunlock(f->ip);
    80003b4c:	6c88                	ld	a0,24(s1)
    80003b4e:	fffff097          	auipc	ra,0xfffff
    80003b52:	11c080e7          	jalr	284(ra) # 80002c6a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b56:	46e1                	li	a3,24
    80003b58:	fb840613          	addi	a2,s0,-72
    80003b5c:	85ce                	mv	a1,s3
    80003b5e:	05093503          	ld	a0,80(s2)
    80003b62:	ffffd097          	auipc	ra,0xffffd
    80003b66:	ffa080e7          	jalr	-6(ra) # 80000b5c <copyout>
    80003b6a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b6e:	60a6                	ld	ra,72(sp)
    80003b70:	6406                	ld	s0,64(sp)
    80003b72:	74e2                	ld	s1,56(sp)
    80003b74:	7942                	ld	s2,48(sp)
    80003b76:	79a2                	ld	s3,40(sp)
    80003b78:	6161                	addi	sp,sp,80
    80003b7a:	8082                	ret
  return -1;
    80003b7c:	557d                	li	a0,-1
    80003b7e:	bfc5                	j	80003b6e <filestat+0x60>

0000000080003b80 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b80:	7179                	addi	sp,sp,-48
    80003b82:	f406                	sd	ra,40(sp)
    80003b84:	f022                	sd	s0,32(sp)
    80003b86:	ec26                	sd	s1,24(sp)
    80003b88:	e84a                	sd	s2,16(sp)
    80003b8a:	e44e                	sd	s3,8(sp)
    80003b8c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b8e:	00854783          	lbu	a5,8(a0)
    80003b92:	c3d5                	beqz	a5,80003c36 <fileread+0xb6>
    80003b94:	84aa                	mv	s1,a0
    80003b96:	89ae                	mv	s3,a1
    80003b98:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b9a:	411c                	lw	a5,0(a0)
    80003b9c:	4705                	li	a4,1
    80003b9e:	04e78963          	beq	a5,a4,80003bf0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ba2:	470d                	li	a4,3
    80003ba4:	04e78d63          	beq	a5,a4,80003bfe <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba8:	4709                	li	a4,2
    80003baa:	06e79e63          	bne	a5,a4,80003c26 <fileread+0xa6>
    ilock(f->ip);
    80003bae:	6d08                	ld	a0,24(a0)
    80003bb0:	fffff097          	auipc	ra,0xfffff
    80003bb4:	ff8080e7          	jalr	-8(ra) # 80002ba8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bb8:	874a                	mv	a4,s2
    80003bba:	5094                	lw	a3,32(s1)
    80003bbc:	864e                	mv	a2,s3
    80003bbe:	4585                	li	a1,1
    80003bc0:	6c88                	ld	a0,24(s1)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	29a080e7          	jalr	666(ra) # 80002e5c <readi>
    80003bca:	892a                	mv	s2,a0
    80003bcc:	00a05563          	blez	a0,80003bd6 <fileread+0x56>
      f->off += r;
    80003bd0:	509c                	lw	a5,32(s1)
    80003bd2:	9fa9                	addw	a5,a5,a0
    80003bd4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	092080e7          	jalr	146(ra) # 80002c6a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003be0:	854a                	mv	a0,s2
    80003be2:	70a2                	ld	ra,40(sp)
    80003be4:	7402                	ld	s0,32(sp)
    80003be6:	64e2                	ld	s1,24(sp)
    80003be8:	6942                	ld	s2,16(sp)
    80003bea:	69a2                	ld	s3,8(sp)
    80003bec:	6145                	addi	sp,sp,48
    80003bee:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bf0:	6908                	ld	a0,16(a0)
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	3c8080e7          	jalr	968(ra) # 80003fba <piperead>
    80003bfa:	892a                	mv	s2,a0
    80003bfc:	b7d5                	j	80003be0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bfe:	02451783          	lh	a5,36(a0)
    80003c02:	03079693          	slli	a3,a5,0x30
    80003c06:	92c1                	srli	a3,a3,0x30
    80003c08:	4725                	li	a4,9
    80003c0a:	02d76863          	bltu	a4,a3,80003c3a <fileread+0xba>
    80003c0e:	0792                	slli	a5,a5,0x4
    80003c10:	00015717          	auipc	a4,0x15
    80003c14:	4b870713          	addi	a4,a4,1208 # 800190c8 <devsw>
    80003c18:	97ba                	add	a5,a5,a4
    80003c1a:	639c                	ld	a5,0(a5)
    80003c1c:	c38d                	beqz	a5,80003c3e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c1e:	4505                	li	a0,1
    80003c20:	9782                	jalr	a5
    80003c22:	892a                	mv	s2,a0
    80003c24:	bf75                	j	80003be0 <fileread+0x60>
    panic("fileread");
    80003c26:	00005517          	auipc	a0,0x5
    80003c2a:	b9a50513          	addi	a0,a0,-1126 # 800087c0 <syscalls_name+0x268>
    80003c2e:	00002097          	auipc	ra,0x2
    80003c32:	02a080e7          	jalr	42(ra) # 80005c58 <panic>
    return -1;
    80003c36:	597d                	li	s2,-1
    80003c38:	b765                	j	80003be0 <fileread+0x60>
      return -1;
    80003c3a:	597d                	li	s2,-1
    80003c3c:	b755                	j	80003be0 <fileread+0x60>
    80003c3e:	597d                	li	s2,-1
    80003c40:	b745                	j	80003be0 <fileread+0x60>

0000000080003c42 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c42:	715d                	addi	sp,sp,-80
    80003c44:	e486                	sd	ra,72(sp)
    80003c46:	e0a2                	sd	s0,64(sp)
    80003c48:	fc26                	sd	s1,56(sp)
    80003c4a:	f84a                	sd	s2,48(sp)
    80003c4c:	f44e                	sd	s3,40(sp)
    80003c4e:	f052                	sd	s4,32(sp)
    80003c50:	ec56                	sd	s5,24(sp)
    80003c52:	e85a                	sd	s6,16(sp)
    80003c54:	e45e                	sd	s7,8(sp)
    80003c56:	e062                	sd	s8,0(sp)
    80003c58:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c5a:	00954783          	lbu	a5,9(a0)
    80003c5e:	10078663          	beqz	a5,80003d6a <filewrite+0x128>
    80003c62:	892a                	mv	s2,a0
    80003c64:	8aae                	mv	s5,a1
    80003c66:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c68:	411c                	lw	a5,0(a0)
    80003c6a:	4705                	li	a4,1
    80003c6c:	02e78263          	beq	a5,a4,80003c90 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c70:	470d                	li	a4,3
    80003c72:	02e78663          	beq	a5,a4,80003c9e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c76:	4709                	li	a4,2
    80003c78:	0ee79163          	bne	a5,a4,80003d5a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c7c:	0ac05d63          	blez	a2,80003d36 <filewrite+0xf4>
    int i = 0;
    80003c80:	4981                	li	s3,0
    80003c82:	6b05                	lui	s6,0x1
    80003c84:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c88:	6b85                	lui	s7,0x1
    80003c8a:	c00b8b9b          	addiw	s7,s7,-1024
    80003c8e:	a861                	j	80003d26 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c90:	6908                	ld	a0,16(a0)
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	22e080e7          	jalr	558(ra) # 80003ec0 <pipewrite>
    80003c9a:	8a2a                	mv	s4,a0
    80003c9c:	a045                	j	80003d3c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c9e:	02451783          	lh	a5,36(a0)
    80003ca2:	03079693          	slli	a3,a5,0x30
    80003ca6:	92c1                	srli	a3,a3,0x30
    80003ca8:	4725                	li	a4,9
    80003caa:	0cd76263          	bltu	a4,a3,80003d6e <filewrite+0x12c>
    80003cae:	0792                	slli	a5,a5,0x4
    80003cb0:	00015717          	auipc	a4,0x15
    80003cb4:	41870713          	addi	a4,a4,1048 # 800190c8 <devsw>
    80003cb8:	97ba                	add	a5,a5,a4
    80003cba:	679c                	ld	a5,8(a5)
    80003cbc:	cbdd                	beqz	a5,80003d72 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cbe:	4505                	li	a0,1
    80003cc0:	9782                	jalr	a5
    80003cc2:	8a2a                	mv	s4,a0
    80003cc4:	a8a5                	j	80003d3c <filewrite+0xfa>
    80003cc6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	8b0080e7          	jalr	-1872(ra) # 8000357a <begin_op>
      ilock(f->ip);
    80003cd2:	01893503          	ld	a0,24(s2)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	ed2080e7          	jalr	-302(ra) # 80002ba8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cde:	8762                	mv	a4,s8
    80003ce0:	02092683          	lw	a3,32(s2)
    80003ce4:	01598633          	add	a2,s3,s5
    80003ce8:	4585                	li	a1,1
    80003cea:	01893503          	ld	a0,24(s2)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	266080e7          	jalr	614(ra) # 80002f54 <writei>
    80003cf6:	84aa                	mv	s1,a0
    80003cf8:	00a05763          	blez	a0,80003d06 <filewrite+0xc4>
        f->off += r;
    80003cfc:	02092783          	lw	a5,32(s2)
    80003d00:	9fa9                	addw	a5,a5,a0
    80003d02:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d06:	01893503          	ld	a0,24(s2)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	f60080e7          	jalr	-160(ra) # 80002c6a <iunlock>
      end_op();
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	8e8080e7          	jalr	-1816(ra) # 800035fa <end_op>

      if(r != n1){
    80003d1a:	009c1f63          	bne	s8,s1,80003d38 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d1e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d22:	0149db63          	bge	s3,s4,80003d38 <filewrite+0xf6>
      int n1 = n - i;
    80003d26:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d2a:	84be                	mv	s1,a5
    80003d2c:	2781                	sext.w	a5,a5
    80003d2e:	f8fb5ce3          	bge	s6,a5,80003cc6 <filewrite+0x84>
    80003d32:	84de                	mv	s1,s7
    80003d34:	bf49                	j	80003cc6 <filewrite+0x84>
    int i = 0;
    80003d36:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d38:	013a1f63          	bne	s4,s3,80003d56 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d3c:	8552                	mv	a0,s4
    80003d3e:	60a6                	ld	ra,72(sp)
    80003d40:	6406                	ld	s0,64(sp)
    80003d42:	74e2                	ld	s1,56(sp)
    80003d44:	7942                	ld	s2,48(sp)
    80003d46:	79a2                	ld	s3,40(sp)
    80003d48:	7a02                	ld	s4,32(sp)
    80003d4a:	6ae2                	ld	s5,24(sp)
    80003d4c:	6b42                	ld	s6,16(sp)
    80003d4e:	6ba2                	ld	s7,8(sp)
    80003d50:	6c02                	ld	s8,0(sp)
    80003d52:	6161                	addi	sp,sp,80
    80003d54:	8082                	ret
    ret = (i == n ? n : -1);
    80003d56:	5a7d                	li	s4,-1
    80003d58:	b7d5                	j	80003d3c <filewrite+0xfa>
    panic("filewrite");
    80003d5a:	00005517          	auipc	a0,0x5
    80003d5e:	a7650513          	addi	a0,a0,-1418 # 800087d0 <syscalls_name+0x278>
    80003d62:	00002097          	auipc	ra,0x2
    80003d66:	ef6080e7          	jalr	-266(ra) # 80005c58 <panic>
    return -1;
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	bfc1                	j	80003d3c <filewrite+0xfa>
      return -1;
    80003d6e:	5a7d                	li	s4,-1
    80003d70:	b7f1                	j	80003d3c <filewrite+0xfa>
    80003d72:	5a7d                	li	s4,-1
    80003d74:	b7e1                	j	80003d3c <filewrite+0xfa>

0000000080003d76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d76:	7179                	addi	sp,sp,-48
    80003d78:	f406                	sd	ra,40(sp)
    80003d7a:	f022                	sd	s0,32(sp)
    80003d7c:	ec26                	sd	s1,24(sp)
    80003d7e:	e84a                	sd	s2,16(sp)
    80003d80:	e44e                	sd	s3,8(sp)
    80003d82:	e052                	sd	s4,0(sp)
    80003d84:	1800                	addi	s0,sp,48
    80003d86:	84aa                	mv	s1,a0
    80003d88:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d8a:	0005b023          	sd	zero,0(a1)
    80003d8e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	bf8080e7          	jalr	-1032(ra) # 8000398a <filealloc>
    80003d9a:	e088                	sd	a0,0(s1)
    80003d9c:	c551                	beqz	a0,80003e28 <pipealloc+0xb2>
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	bec080e7          	jalr	-1044(ra) # 8000398a <filealloc>
    80003da6:	00aa3023          	sd	a0,0(s4)
    80003daa:	c92d                	beqz	a0,80003e1c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dac:	ffffc097          	auipc	ra,0xffffc
    80003db0:	36c080e7          	jalr	876(ra) # 80000118 <kalloc>
    80003db4:	892a                	mv	s2,a0
    80003db6:	c125                	beqz	a0,80003e16 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db8:	4985                	li	s3,1
    80003dba:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dbe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dc2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dc6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dca:	00004597          	auipc	a1,0x4
    80003dce:	61658593          	addi	a1,a1,1558 # 800083e0 <states.1714+0x1a0>
    80003dd2:	00002097          	auipc	ra,0x2
    80003dd6:	340080e7          	jalr	832(ra) # 80006112 <initlock>
  (*f0)->type = FD_PIPE;
    80003dda:	609c                	ld	a5,0(s1)
    80003ddc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003de0:	609c                	ld	a5,0(s1)
    80003de2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003de6:	609c                	ld	a5,0(s1)
    80003de8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dec:	609c                	ld	a5,0(s1)
    80003dee:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003df2:	000a3783          	ld	a5,0(s4)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dfa:	000a3783          	ld	a5,0(s4)
    80003dfe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e02:	000a3783          	ld	a5,0(s4)
    80003e06:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e0a:	000a3783          	ld	a5,0(s4)
    80003e0e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e12:	4501                	li	a0,0
    80003e14:	a025                	j	80003e3c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e16:	6088                	ld	a0,0(s1)
    80003e18:	e501                	bnez	a0,80003e20 <pipealloc+0xaa>
    80003e1a:	a039                	j	80003e28 <pipealloc+0xb2>
    80003e1c:	6088                	ld	a0,0(s1)
    80003e1e:	c51d                	beqz	a0,80003e4c <pipealloc+0xd6>
    fileclose(*f0);
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	c26080e7          	jalr	-986(ra) # 80003a46 <fileclose>
  if(*f1)
    80003e28:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e2c:	557d                	li	a0,-1
  if(*f1)
    80003e2e:	c799                	beqz	a5,80003e3c <pipealloc+0xc6>
    fileclose(*f1);
    80003e30:	853e                	mv	a0,a5
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	c14080e7          	jalr	-1004(ra) # 80003a46 <fileclose>
  return -1;
    80003e3a:	557d                	li	a0,-1
}
    80003e3c:	70a2                	ld	ra,40(sp)
    80003e3e:	7402                	ld	s0,32(sp)
    80003e40:	64e2                	ld	s1,24(sp)
    80003e42:	6942                	ld	s2,16(sp)
    80003e44:	69a2                	ld	s3,8(sp)
    80003e46:	6a02                	ld	s4,0(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
  return -1;
    80003e4c:	557d                	li	a0,-1
    80003e4e:	b7fd                	j	80003e3c <pipealloc+0xc6>

0000000080003e50 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e50:	1101                	addi	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	e426                	sd	s1,8(sp)
    80003e58:	e04a                	sd	s2,0(sp)
    80003e5a:	1000                	addi	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	342080e7          	jalr	834(ra) # 800061a2 <acquire>
  if(writable){
    80003e68:	02090d63          	beqz	s2,80003ea2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e6c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e70:	21848513          	addi	a0,s1,536
    80003e74:	ffffe097          	auipc	ra,0xffffe
    80003e78:	876080e7          	jalr	-1930(ra) # 800016ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e7c:	2204b783          	ld	a5,544(s1)
    80003e80:	eb95                	bnez	a5,80003eb4 <pipeclose+0x64>
    release(&pi->lock);
    80003e82:	8526                	mv	a0,s1
    80003e84:	00002097          	auipc	ra,0x2
    80003e88:	3d2080e7          	jalr	978(ra) # 80006256 <release>
    kfree((char*)pi);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	ffffc097          	auipc	ra,0xffffc
    80003e92:	18e080e7          	jalr	398(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6902                	ld	s2,0(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret
    pi->readopen = 0;
    80003ea2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ea6:	21c48513          	addi	a0,s1,540
    80003eaa:	ffffe097          	auipc	ra,0xffffe
    80003eae:	840080e7          	jalr	-1984(ra) # 800016ea <wakeup>
    80003eb2:	b7e9                	j	80003e7c <pipeclose+0x2c>
    release(&pi->lock);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	00002097          	auipc	ra,0x2
    80003eba:	3a0080e7          	jalr	928(ra) # 80006256 <release>
}
    80003ebe:	bfe1                	j	80003e96 <pipeclose+0x46>

0000000080003ec0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ec0:	7159                	addi	sp,sp,-112
    80003ec2:	f486                	sd	ra,104(sp)
    80003ec4:	f0a2                	sd	s0,96(sp)
    80003ec6:	eca6                	sd	s1,88(sp)
    80003ec8:	e8ca                	sd	s2,80(sp)
    80003eca:	e4ce                	sd	s3,72(sp)
    80003ecc:	e0d2                	sd	s4,64(sp)
    80003ece:	fc56                	sd	s5,56(sp)
    80003ed0:	f85a                	sd	s6,48(sp)
    80003ed2:	f45e                	sd	s7,40(sp)
    80003ed4:	f062                	sd	s8,32(sp)
    80003ed6:	ec66                	sd	s9,24(sp)
    80003ed8:	1880                	addi	s0,sp,112
    80003eda:	84aa                	mv	s1,a0
    80003edc:	8aae                	mv	s5,a1
    80003ede:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ee0:	ffffd097          	auipc	ra,0xffffd
    80003ee4:	fba080e7          	jalr	-70(ra) # 80000e9a <myproc>
    80003ee8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eea:	8526                	mv	a0,s1
    80003eec:	00002097          	auipc	ra,0x2
    80003ef0:	2b6080e7          	jalr	694(ra) # 800061a2 <acquire>
  while(i < n){
    80003ef4:	0d405163          	blez	s4,80003fb6 <pipewrite+0xf6>
    80003ef8:	8ba6                	mv	s7,s1
  int i = 0;
    80003efa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003efc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003efe:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f02:	21c48c13          	addi	s8,s1,540
    80003f06:	a08d                	j	80003f68 <pipewrite+0xa8>
      release(&pi->lock);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	00002097          	auipc	ra,0x2
    80003f0e:	34c080e7          	jalr	844(ra) # 80006256 <release>
      return -1;
    80003f12:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f14:	854a                	mv	a0,s2
    80003f16:	70a6                	ld	ra,104(sp)
    80003f18:	7406                	ld	s0,96(sp)
    80003f1a:	64e6                	ld	s1,88(sp)
    80003f1c:	6946                	ld	s2,80(sp)
    80003f1e:	69a6                	ld	s3,72(sp)
    80003f20:	6a06                	ld	s4,64(sp)
    80003f22:	7ae2                	ld	s5,56(sp)
    80003f24:	7b42                	ld	s6,48(sp)
    80003f26:	7ba2                	ld	s7,40(sp)
    80003f28:	7c02                	ld	s8,32(sp)
    80003f2a:	6ce2                	ld	s9,24(sp)
    80003f2c:	6165                	addi	sp,sp,112
    80003f2e:	8082                	ret
      wakeup(&pi->nread);
    80003f30:	8566                	mv	a0,s9
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	7b8080e7          	jalr	1976(ra) # 800016ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f3a:	85de                	mv	a1,s7
    80003f3c:	8562                	mv	a0,s8
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	620080e7          	jalr	1568(ra) # 8000155e <sleep>
    80003f46:	a839                	j	80003f64 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f48:	21c4a783          	lw	a5,540(s1)
    80003f4c:	0017871b          	addiw	a4,a5,1
    80003f50:	20e4ae23          	sw	a4,540(s1)
    80003f54:	1ff7f793          	andi	a5,a5,511
    80003f58:	97a6                	add	a5,a5,s1
    80003f5a:	f9f44703          	lbu	a4,-97(s0)
    80003f5e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f62:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f64:	03495d63          	bge	s2,s4,80003f9e <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f68:	2204a783          	lw	a5,544(s1)
    80003f6c:	dfd1                	beqz	a5,80003f08 <pipewrite+0x48>
    80003f6e:	0289a783          	lw	a5,40(s3)
    80003f72:	fbd9                	bnez	a5,80003f08 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f74:	2184a783          	lw	a5,536(s1)
    80003f78:	21c4a703          	lw	a4,540(s1)
    80003f7c:	2007879b          	addiw	a5,a5,512
    80003f80:	faf708e3          	beq	a4,a5,80003f30 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f84:	4685                	li	a3,1
    80003f86:	01590633          	add	a2,s2,s5
    80003f8a:	f9f40593          	addi	a1,s0,-97
    80003f8e:	0509b503          	ld	a0,80(s3)
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	c56080e7          	jalr	-938(ra) # 80000be8 <copyin>
    80003f9a:	fb6517e3          	bne	a0,s6,80003f48 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f9e:	21848513          	addi	a0,s1,536
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	748080e7          	jalr	1864(ra) # 800016ea <wakeup>
  release(&pi->lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	2aa080e7          	jalr	682(ra) # 80006256 <release>
  return i;
    80003fb4:	b785                	j	80003f14 <pipewrite+0x54>
  int i = 0;
    80003fb6:	4901                	li	s2,0
    80003fb8:	b7dd                	j	80003f9e <pipewrite+0xde>

0000000080003fba <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fba:	715d                	addi	sp,sp,-80
    80003fbc:	e486                	sd	ra,72(sp)
    80003fbe:	e0a2                	sd	s0,64(sp)
    80003fc0:	fc26                	sd	s1,56(sp)
    80003fc2:	f84a                	sd	s2,48(sp)
    80003fc4:	f44e                	sd	s3,40(sp)
    80003fc6:	f052                	sd	s4,32(sp)
    80003fc8:	ec56                	sd	s5,24(sp)
    80003fca:	e85a                	sd	s6,16(sp)
    80003fcc:	0880                	addi	s0,sp,80
    80003fce:	84aa                	mv	s1,a0
    80003fd0:	892e                	mv	s2,a1
    80003fd2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	ec6080e7          	jalr	-314(ra) # 80000e9a <myproc>
    80003fdc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fde:	8b26                	mv	s6,s1
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	00002097          	auipc	ra,0x2
    80003fe6:	1c0080e7          	jalr	448(ra) # 800061a2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fea:	2184a703          	lw	a4,536(s1)
    80003fee:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff6:	02f71463          	bne	a4,a5,8000401e <piperead+0x64>
    80003ffa:	2244a783          	lw	a5,548(s1)
    80003ffe:	c385                	beqz	a5,8000401e <piperead+0x64>
    if(pr->killed){
    80004000:	028a2783          	lw	a5,40(s4)
    80004004:	ebc1                	bnez	a5,80004094 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004006:	85da                	mv	a1,s6
    80004008:	854e                	mv	a0,s3
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	554080e7          	jalr	1364(ra) # 8000155e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004012:	2184a703          	lw	a4,536(s1)
    80004016:	21c4a783          	lw	a5,540(s1)
    8000401a:	fef700e3          	beq	a4,a5,80003ffa <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401e:	09505263          	blez	s5,800040a2 <piperead+0xe8>
    80004022:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004024:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004026:	2184a783          	lw	a5,536(s1)
    8000402a:	21c4a703          	lw	a4,540(s1)
    8000402e:	02f70d63          	beq	a4,a5,80004068 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004032:	0017871b          	addiw	a4,a5,1
    80004036:	20e4ac23          	sw	a4,536(s1)
    8000403a:	1ff7f793          	andi	a5,a5,511
    8000403e:	97a6                	add	a5,a5,s1
    80004040:	0187c783          	lbu	a5,24(a5)
    80004044:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004048:	4685                	li	a3,1
    8000404a:	fbf40613          	addi	a2,s0,-65
    8000404e:	85ca                	mv	a1,s2
    80004050:	050a3503          	ld	a0,80(s4)
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	b08080e7          	jalr	-1272(ra) # 80000b5c <copyout>
    8000405c:	01650663          	beq	a0,s6,80004068 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004060:	2985                	addiw	s3,s3,1
    80004062:	0905                	addi	s2,s2,1
    80004064:	fd3a91e3          	bne	s5,s3,80004026 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004068:	21c48513          	addi	a0,s1,540
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	67e080e7          	jalr	1662(ra) # 800016ea <wakeup>
  release(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	1e0080e7          	jalr	480(ra) # 80006256 <release>
  return i;
}
    8000407e:	854e                	mv	a0,s3
    80004080:	60a6                	ld	ra,72(sp)
    80004082:	6406                	ld	s0,64(sp)
    80004084:	74e2                	ld	s1,56(sp)
    80004086:	7942                	ld	s2,48(sp)
    80004088:	79a2                	ld	s3,40(sp)
    8000408a:	7a02                	ld	s4,32(sp)
    8000408c:	6ae2                	ld	s5,24(sp)
    8000408e:	6b42                	ld	s6,16(sp)
    80004090:	6161                	addi	sp,sp,80
    80004092:	8082                	ret
      release(&pi->lock);
    80004094:	8526                	mv	a0,s1
    80004096:	00002097          	auipc	ra,0x2
    8000409a:	1c0080e7          	jalr	448(ra) # 80006256 <release>
      return -1;
    8000409e:	59fd                	li	s3,-1
    800040a0:	bff9                	j	8000407e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a2:	4981                	li	s3,0
    800040a4:	b7d1                	j	80004068 <piperead+0xae>

00000000800040a6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040a6:	df010113          	addi	sp,sp,-528
    800040aa:	20113423          	sd	ra,520(sp)
    800040ae:	20813023          	sd	s0,512(sp)
    800040b2:	ffa6                	sd	s1,504(sp)
    800040b4:	fbca                	sd	s2,496(sp)
    800040b6:	f7ce                	sd	s3,488(sp)
    800040b8:	f3d2                	sd	s4,480(sp)
    800040ba:	efd6                	sd	s5,472(sp)
    800040bc:	ebda                	sd	s6,464(sp)
    800040be:	e7de                	sd	s7,456(sp)
    800040c0:	e3e2                	sd	s8,448(sp)
    800040c2:	ff66                	sd	s9,440(sp)
    800040c4:	fb6a                	sd	s10,432(sp)
    800040c6:	f76e                	sd	s11,424(sp)
    800040c8:	0c00                	addi	s0,sp,528
    800040ca:	84aa                	mv	s1,a0
    800040cc:	dea43c23          	sd	a0,-520(s0)
    800040d0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	dc6080e7          	jalr	-570(ra) # 80000e9a <myproc>
    800040dc:	892a                	mv	s2,a0

  begin_op();
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	49c080e7          	jalr	1180(ra) # 8000357a <begin_op>

  if((ip = namei(path)) == 0){
    800040e6:	8526                	mv	a0,s1
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	276080e7          	jalr	630(ra) # 8000335e <namei>
    800040f0:	c92d                	beqz	a0,80004162 <exec+0xbc>
    800040f2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	ab4080e7          	jalr	-1356(ra) # 80002ba8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040fc:	04000713          	li	a4,64
    80004100:	4681                	li	a3,0
    80004102:	e5040613          	addi	a2,s0,-432
    80004106:	4581                	li	a1,0
    80004108:	8526                	mv	a0,s1
    8000410a:	fffff097          	auipc	ra,0xfffff
    8000410e:	d52080e7          	jalr	-686(ra) # 80002e5c <readi>
    80004112:	04000793          	li	a5,64
    80004116:	00f51a63          	bne	a0,a5,8000412a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000411a:	e5042703          	lw	a4,-432(s0)
    8000411e:	464c47b7          	lui	a5,0x464c4
    80004122:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004126:	04f70463          	beq	a4,a5,8000416e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000412a:	8526                	mv	a0,s1
    8000412c:	fffff097          	auipc	ra,0xfffff
    80004130:	cde080e7          	jalr	-802(ra) # 80002e0a <iunlockput>
    end_op();
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	4c6080e7          	jalr	1222(ra) # 800035fa <end_op>
  }
  return -1;
    8000413c:	557d                	li	a0,-1
}
    8000413e:	20813083          	ld	ra,520(sp)
    80004142:	20013403          	ld	s0,512(sp)
    80004146:	74fe                	ld	s1,504(sp)
    80004148:	795e                	ld	s2,496(sp)
    8000414a:	79be                	ld	s3,488(sp)
    8000414c:	7a1e                	ld	s4,480(sp)
    8000414e:	6afe                	ld	s5,472(sp)
    80004150:	6b5e                	ld	s6,464(sp)
    80004152:	6bbe                	ld	s7,456(sp)
    80004154:	6c1e                	ld	s8,448(sp)
    80004156:	7cfa                	ld	s9,440(sp)
    80004158:	7d5a                	ld	s10,432(sp)
    8000415a:	7dba                	ld	s11,424(sp)
    8000415c:	21010113          	addi	sp,sp,528
    80004160:	8082                	ret
    end_op();
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	498080e7          	jalr	1176(ra) # 800035fa <end_op>
    return -1;
    8000416a:	557d                	li	a0,-1
    8000416c:	bfc9                	j	8000413e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000416e:	854a                	mv	a0,s2
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	dee080e7          	jalr	-530(ra) # 80000f5e <proc_pagetable>
    80004178:	8baa                	mv	s7,a0
    8000417a:	d945                	beqz	a0,8000412a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000417c:	e7042983          	lw	s3,-400(s0)
    80004180:	e8845783          	lhu	a5,-376(s0)
    80004184:	c7ad                	beqz	a5,800041ee <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004186:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004188:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000418a:	6c85                	lui	s9,0x1
    8000418c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004190:	def43823          	sd	a5,-528(s0)
    80004194:	a42d                	j	800043be <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004196:	00004517          	auipc	a0,0x4
    8000419a:	64a50513          	addi	a0,a0,1610 # 800087e0 <syscalls_name+0x288>
    8000419e:	00002097          	auipc	ra,0x2
    800041a2:	aba080e7          	jalr	-1350(ra) # 80005c58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a6:	8756                	mv	a4,s5
    800041a8:	012d86bb          	addw	a3,s11,s2
    800041ac:	4581                	li	a1,0
    800041ae:	8526                	mv	a0,s1
    800041b0:	fffff097          	auipc	ra,0xfffff
    800041b4:	cac080e7          	jalr	-852(ra) # 80002e5c <readi>
    800041b8:	2501                	sext.w	a0,a0
    800041ba:	1aaa9963          	bne	s5,a0,8000436c <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041be:	6785                	lui	a5,0x1
    800041c0:	0127893b          	addw	s2,a5,s2
    800041c4:	77fd                	lui	a5,0xfffff
    800041c6:	01478a3b          	addw	s4,a5,s4
    800041ca:	1f897163          	bgeu	s2,s8,800043ac <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041ce:	02091593          	slli	a1,s2,0x20
    800041d2:	9181                	srli	a1,a1,0x20
    800041d4:	95ea                	add	a1,a1,s10
    800041d6:	855e                	mv	a0,s7
    800041d8:	ffffc097          	auipc	ra,0xffffc
    800041dc:	380080e7          	jalr	896(ra) # 80000558 <walkaddr>
    800041e0:	862a                	mv	a2,a0
    if(pa == 0)
    800041e2:	d955                	beqz	a0,80004196 <exec+0xf0>
      n = PGSIZE;
    800041e4:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041e6:	fd9a70e3          	bgeu	s4,s9,800041a6 <exec+0x100>
      n = sz - i;
    800041ea:	8ad2                	mv	s5,s4
    800041ec:	bf6d                	j	800041a6 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ee:	4901                	li	s2,0
  iunlockput(ip);
    800041f0:	8526                	mv	a0,s1
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	c18080e7          	jalr	-1000(ra) # 80002e0a <iunlockput>
  end_op();
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	400080e7          	jalr	1024(ra) # 800035fa <end_op>
  p = myproc();
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	c98080e7          	jalr	-872(ra) # 80000e9a <myproc>
    8000420a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000420c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004210:	6785                	lui	a5,0x1
    80004212:	17fd                	addi	a5,a5,-1
    80004214:	993e                	add	s2,s2,a5
    80004216:	757d                	lui	a0,0xfffff
    80004218:	00a977b3          	and	a5,s2,a0
    8000421c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004220:	6609                	lui	a2,0x2
    80004222:	963e                	add	a2,a2,a5
    80004224:	85be                	mv	a1,a5
    80004226:	855e                	mv	a0,s7
    80004228:	ffffc097          	auipc	ra,0xffffc
    8000422c:	6e4080e7          	jalr	1764(ra) # 8000090c <uvmalloc>
    80004230:	8b2a                	mv	s6,a0
  ip = 0;
    80004232:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004234:	12050c63          	beqz	a0,8000436c <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004238:	75f9                	lui	a1,0xffffe
    8000423a:	95aa                	add	a1,a1,a0
    8000423c:	855e                	mv	a0,s7
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	8ec080e7          	jalr	-1812(ra) # 80000b2a <uvmclear>
  stackbase = sp - PGSIZE;
    80004246:	7c7d                	lui	s8,0xfffff
    80004248:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000424a:	e0043783          	ld	a5,-512(s0)
    8000424e:	6388                	ld	a0,0(a5)
    80004250:	c535                	beqz	a0,800042bc <exec+0x216>
    80004252:	e9040993          	addi	s3,s0,-368
    80004256:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000425a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000425c:	ffffc097          	auipc	ra,0xffffc
    80004260:	0f2080e7          	jalr	242(ra) # 8000034e <strlen>
    80004264:	2505                	addiw	a0,a0,1
    80004266:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000426a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000426e:	13896363          	bltu	s2,s8,80004394 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004272:	e0043d83          	ld	s11,-512(s0)
    80004276:	000dba03          	ld	s4,0(s11)
    8000427a:	8552                	mv	a0,s4
    8000427c:	ffffc097          	auipc	ra,0xffffc
    80004280:	0d2080e7          	jalr	210(ra) # 8000034e <strlen>
    80004284:	0015069b          	addiw	a3,a0,1
    80004288:	8652                	mv	a2,s4
    8000428a:	85ca                	mv	a1,s2
    8000428c:	855e                	mv	a0,s7
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	8ce080e7          	jalr	-1842(ra) # 80000b5c <copyout>
    80004296:	10054363          	bltz	a0,8000439c <exec+0x2f6>
    ustack[argc] = sp;
    8000429a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000429e:	0485                	addi	s1,s1,1
    800042a0:	008d8793          	addi	a5,s11,8
    800042a4:	e0f43023          	sd	a5,-512(s0)
    800042a8:	008db503          	ld	a0,8(s11)
    800042ac:	c911                	beqz	a0,800042c0 <exec+0x21a>
    if(argc >= MAXARG)
    800042ae:	09a1                	addi	s3,s3,8
    800042b0:	fb3c96e3          	bne	s9,s3,8000425c <exec+0x1b6>
  sz = sz1;
    800042b4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042b8:	4481                	li	s1,0
    800042ba:	a84d                	j	8000436c <exec+0x2c6>
  sp = sz;
    800042bc:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042be:	4481                	li	s1,0
  ustack[argc] = 0;
    800042c0:	00349793          	slli	a5,s1,0x3
    800042c4:	f9040713          	addi	a4,s0,-112
    800042c8:	97ba                	add	a5,a5,a4
    800042ca:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042ce:	00148693          	addi	a3,s1,1
    800042d2:	068e                	slli	a3,a3,0x3
    800042d4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042d8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042dc:	01897663          	bgeu	s2,s8,800042e8 <exec+0x242>
  sz = sz1;
    800042e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e4:	4481                	li	s1,0
    800042e6:	a059                	j	8000436c <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042e8:	e9040613          	addi	a2,s0,-368
    800042ec:	85ca                	mv	a1,s2
    800042ee:	855e                	mv	a0,s7
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	86c080e7          	jalr	-1940(ra) # 80000b5c <copyout>
    800042f8:	0a054663          	bltz	a0,800043a4 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042fc:	058ab783          	ld	a5,88(s5)
    80004300:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004304:	df843783          	ld	a5,-520(s0)
    80004308:	0007c703          	lbu	a4,0(a5)
    8000430c:	cf11                	beqz	a4,80004328 <exec+0x282>
    8000430e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004310:	02f00693          	li	a3,47
    80004314:	a039                	j	80004322 <exec+0x27c>
      last = s+1;
    80004316:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000431a:	0785                	addi	a5,a5,1
    8000431c:	fff7c703          	lbu	a4,-1(a5)
    80004320:	c701                	beqz	a4,80004328 <exec+0x282>
    if(*s == '/')
    80004322:	fed71ce3          	bne	a4,a3,8000431a <exec+0x274>
    80004326:	bfc5                	j	80004316 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004328:	4641                	li	a2,16
    8000432a:	df843583          	ld	a1,-520(s0)
    8000432e:	158a8513          	addi	a0,s5,344
    80004332:	ffffc097          	auipc	ra,0xffffc
    80004336:	fea080e7          	jalr	-22(ra) # 8000031c <safestrcpy>
  oldpagetable = p->pagetable;
    8000433a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000433e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004342:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004346:	058ab783          	ld	a5,88(s5)
    8000434a:	e6843703          	ld	a4,-408(s0)
    8000434e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004350:	058ab783          	ld	a5,88(s5)
    80004354:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004358:	85ea                	mv	a1,s10
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	ca0080e7          	jalr	-864(ra) # 80000ffa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004362:	0004851b          	sext.w	a0,s1
    80004366:	bbe1                	j	8000413e <exec+0x98>
    80004368:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000436c:	e0843583          	ld	a1,-504(s0)
    80004370:	855e                	mv	a0,s7
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	c88080e7          	jalr	-888(ra) # 80000ffa <proc_freepagetable>
  if(ip){
    8000437a:	da0498e3          	bnez	s1,8000412a <exec+0x84>
  return -1;
    8000437e:	557d                	li	a0,-1
    80004380:	bb7d                	j	8000413e <exec+0x98>
    80004382:	e1243423          	sd	s2,-504(s0)
    80004386:	b7dd                	j	8000436c <exec+0x2c6>
    80004388:	e1243423          	sd	s2,-504(s0)
    8000438c:	b7c5                	j	8000436c <exec+0x2c6>
    8000438e:	e1243423          	sd	s2,-504(s0)
    80004392:	bfe9                	j	8000436c <exec+0x2c6>
  sz = sz1;
    80004394:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004398:	4481                	li	s1,0
    8000439a:	bfc9                	j	8000436c <exec+0x2c6>
  sz = sz1;
    8000439c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a0:	4481                	li	s1,0
    800043a2:	b7e9                	j	8000436c <exec+0x2c6>
  sz = sz1;
    800043a4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a8:	4481                	li	s1,0
    800043aa:	b7c9                	j	8000436c <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ac:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043b0:	2b05                	addiw	s6,s6,1
    800043b2:	0389899b          	addiw	s3,s3,56
    800043b6:	e8845783          	lhu	a5,-376(s0)
    800043ba:	e2fb5be3          	bge	s6,a5,800041f0 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043be:	2981                	sext.w	s3,s3
    800043c0:	03800713          	li	a4,56
    800043c4:	86ce                	mv	a3,s3
    800043c6:	e1840613          	addi	a2,s0,-488
    800043ca:	4581                	li	a1,0
    800043cc:	8526                	mv	a0,s1
    800043ce:	fffff097          	auipc	ra,0xfffff
    800043d2:	a8e080e7          	jalr	-1394(ra) # 80002e5c <readi>
    800043d6:	03800793          	li	a5,56
    800043da:	f8f517e3          	bne	a0,a5,80004368 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043de:	e1842783          	lw	a5,-488(s0)
    800043e2:	4705                	li	a4,1
    800043e4:	fce796e3          	bne	a5,a4,800043b0 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043e8:	e4043603          	ld	a2,-448(s0)
    800043ec:	e3843783          	ld	a5,-456(s0)
    800043f0:	f8f669e3          	bltu	a2,a5,80004382 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043f4:	e2843783          	ld	a5,-472(s0)
    800043f8:	963e                	add	a2,a2,a5
    800043fa:	f8f667e3          	bltu	a2,a5,80004388 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043fe:	85ca                	mv	a1,s2
    80004400:	855e                	mv	a0,s7
    80004402:	ffffc097          	auipc	ra,0xffffc
    80004406:	50a080e7          	jalr	1290(ra) # 8000090c <uvmalloc>
    8000440a:	e0a43423          	sd	a0,-504(s0)
    8000440e:	d141                	beqz	a0,8000438e <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004410:	e2843d03          	ld	s10,-472(s0)
    80004414:	df043783          	ld	a5,-528(s0)
    80004418:	00fd77b3          	and	a5,s10,a5
    8000441c:	fba1                	bnez	a5,8000436c <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000441e:	e2042d83          	lw	s11,-480(s0)
    80004422:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004426:	f80c03e3          	beqz	s8,800043ac <exec+0x306>
    8000442a:	8a62                	mv	s4,s8
    8000442c:	4901                	li	s2,0
    8000442e:	b345                	j	800041ce <exec+0x128>

0000000080004430 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004430:	7179                	addi	sp,sp,-48
    80004432:	f406                	sd	ra,40(sp)
    80004434:	f022                	sd	s0,32(sp)
    80004436:	ec26                	sd	s1,24(sp)
    80004438:	e84a                	sd	s2,16(sp)
    8000443a:	1800                	addi	s0,sp,48
    8000443c:	892e                	mv	s2,a1
    8000443e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004440:	fdc40593          	addi	a1,s0,-36
    80004444:	ffffe097          	auipc	ra,0xffffe
    80004448:	b40080e7          	jalr	-1216(ra) # 80001f84 <argint>
    8000444c:	04054063          	bltz	a0,8000448c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004450:	fdc42703          	lw	a4,-36(s0)
    80004454:	47bd                	li	a5,15
    80004456:	02e7ed63          	bltu	a5,a4,80004490 <argfd+0x60>
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	a40080e7          	jalr	-1472(ra) # 80000e9a <myproc>
    80004462:	fdc42703          	lw	a4,-36(s0)
    80004466:	01a70793          	addi	a5,a4,26
    8000446a:	078e                	slli	a5,a5,0x3
    8000446c:	953e                	add	a0,a0,a5
    8000446e:	611c                	ld	a5,0(a0)
    80004470:	c395                	beqz	a5,80004494 <argfd+0x64>
    return -1;
  if(pfd)
    80004472:	00090463          	beqz	s2,8000447a <argfd+0x4a>
    *pfd = fd;
    80004476:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000447a:	4501                	li	a0,0
  if(pf)
    8000447c:	c091                	beqz	s1,80004480 <argfd+0x50>
    *pf = f;
    8000447e:	e09c                	sd	a5,0(s1)
}
    80004480:	70a2                	ld	ra,40(sp)
    80004482:	7402                	ld	s0,32(sp)
    80004484:	64e2                	ld	s1,24(sp)
    80004486:	6942                	ld	s2,16(sp)
    80004488:	6145                	addi	sp,sp,48
    8000448a:	8082                	ret
    return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	bfcd                	j	80004480 <argfd+0x50>
    return -1;
    80004490:	557d                	li	a0,-1
    80004492:	b7fd                	j	80004480 <argfd+0x50>
    80004494:	557d                	li	a0,-1
    80004496:	b7ed                	j	80004480 <argfd+0x50>

0000000080004498 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004498:	1101                	addi	sp,sp,-32
    8000449a:	ec06                	sd	ra,24(sp)
    8000449c:	e822                	sd	s0,16(sp)
    8000449e:	e426                	sd	s1,8(sp)
    800044a0:	1000                	addi	s0,sp,32
    800044a2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044a4:	ffffd097          	auipc	ra,0xffffd
    800044a8:	9f6080e7          	jalr	-1546(ra) # 80000e9a <myproc>
    800044ac:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044ae:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044b2:	4501                	li	a0,0
    800044b4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044b6:	6398                	ld	a4,0(a5)
    800044b8:	cb19                	beqz	a4,800044ce <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044ba:	2505                	addiw	a0,a0,1
    800044bc:	07a1                	addi	a5,a5,8
    800044be:	fed51ce3          	bne	a0,a3,800044b6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044c2:	557d                	li	a0,-1
}
    800044c4:	60e2                	ld	ra,24(sp)
    800044c6:	6442                	ld	s0,16(sp)
    800044c8:	64a2                	ld	s1,8(sp)
    800044ca:	6105                	addi	sp,sp,32
    800044cc:	8082                	ret
      p->ofile[fd] = f;
    800044ce:	01a50793          	addi	a5,a0,26
    800044d2:	078e                	slli	a5,a5,0x3
    800044d4:	963e                	add	a2,a2,a5
    800044d6:	e204                	sd	s1,0(a2)
      return fd;
    800044d8:	b7f5                	j	800044c4 <fdalloc+0x2c>

00000000800044da <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044da:	715d                	addi	sp,sp,-80
    800044dc:	e486                	sd	ra,72(sp)
    800044de:	e0a2                	sd	s0,64(sp)
    800044e0:	fc26                	sd	s1,56(sp)
    800044e2:	f84a                	sd	s2,48(sp)
    800044e4:	f44e                	sd	s3,40(sp)
    800044e6:	f052                	sd	s4,32(sp)
    800044e8:	ec56                	sd	s5,24(sp)
    800044ea:	0880                	addi	s0,sp,80
    800044ec:	89ae                	mv	s3,a1
    800044ee:	8ab2                	mv	s5,a2
    800044f0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044f2:	fb040593          	addi	a1,s0,-80
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	e86080e7          	jalr	-378(ra) # 8000337c <nameiparent>
    800044fe:	892a                	mv	s2,a0
    80004500:	12050f63          	beqz	a0,8000463e <create+0x164>
    return 0;

  ilock(dp);
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	6a4080e7          	jalr	1700(ra) # 80002ba8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000450c:	4601                	li	a2,0
    8000450e:	fb040593          	addi	a1,s0,-80
    80004512:	854a                	mv	a0,s2
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	b78080e7          	jalr	-1160(ra) # 8000308c <dirlookup>
    8000451c:	84aa                	mv	s1,a0
    8000451e:	c921                	beqz	a0,8000456e <create+0x94>
    iunlockput(dp);
    80004520:	854a                	mv	a0,s2
    80004522:	fffff097          	auipc	ra,0xfffff
    80004526:	8e8080e7          	jalr	-1816(ra) # 80002e0a <iunlockput>
    ilock(ip);
    8000452a:	8526                	mv	a0,s1
    8000452c:	ffffe097          	auipc	ra,0xffffe
    80004530:	67c080e7          	jalr	1660(ra) # 80002ba8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004534:	2981                	sext.w	s3,s3
    80004536:	4789                	li	a5,2
    80004538:	02f99463          	bne	s3,a5,80004560 <create+0x86>
    8000453c:	0444d783          	lhu	a5,68(s1)
    80004540:	37f9                	addiw	a5,a5,-2
    80004542:	17c2                	slli	a5,a5,0x30
    80004544:	93c1                	srli	a5,a5,0x30
    80004546:	4705                	li	a4,1
    80004548:	00f76c63          	bltu	a4,a5,80004560 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000454c:	8526                	mv	a0,s1
    8000454e:	60a6                	ld	ra,72(sp)
    80004550:	6406                	ld	s0,64(sp)
    80004552:	74e2                	ld	s1,56(sp)
    80004554:	7942                	ld	s2,48(sp)
    80004556:	79a2                	ld	s3,40(sp)
    80004558:	7a02                	ld	s4,32(sp)
    8000455a:	6ae2                	ld	s5,24(sp)
    8000455c:	6161                	addi	sp,sp,80
    8000455e:	8082                	ret
    iunlockput(ip);
    80004560:	8526                	mv	a0,s1
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	8a8080e7          	jalr	-1880(ra) # 80002e0a <iunlockput>
    return 0;
    8000456a:	4481                	li	s1,0
    8000456c:	b7c5                	j	8000454c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000456e:	85ce                	mv	a1,s3
    80004570:	00092503          	lw	a0,0(s2)
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	49c080e7          	jalr	1180(ra) # 80002a10 <ialloc>
    8000457c:	84aa                	mv	s1,a0
    8000457e:	c529                	beqz	a0,800045c8 <create+0xee>
  ilock(ip);
    80004580:	ffffe097          	auipc	ra,0xffffe
    80004584:	628080e7          	jalr	1576(ra) # 80002ba8 <ilock>
  ip->major = major;
    80004588:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000458c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004590:	4785                	li	a5,1
    80004592:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004596:	8526                	mv	a0,s1
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	546080e7          	jalr	1350(ra) # 80002ade <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045a0:	2981                	sext.w	s3,s3
    800045a2:	4785                	li	a5,1
    800045a4:	02f98a63          	beq	s3,a5,800045d8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045a8:	40d0                	lw	a2,4(s1)
    800045aa:	fb040593          	addi	a1,s0,-80
    800045ae:	854a                	mv	a0,s2
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	cec080e7          	jalr	-788(ra) # 8000329c <dirlink>
    800045b8:	06054b63          	bltz	a0,8000462e <create+0x154>
  iunlockput(dp);
    800045bc:	854a                	mv	a0,s2
    800045be:	fffff097          	auipc	ra,0xfffff
    800045c2:	84c080e7          	jalr	-1972(ra) # 80002e0a <iunlockput>
  return ip;
    800045c6:	b759                	j	8000454c <create+0x72>
    panic("create: ialloc");
    800045c8:	00004517          	auipc	a0,0x4
    800045cc:	23850513          	addi	a0,a0,568 # 80008800 <syscalls_name+0x2a8>
    800045d0:	00001097          	auipc	ra,0x1
    800045d4:	688080e7          	jalr	1672(ra) # 80005c58 <panic>
    dp->nlink++;  // for ".."
    800045d8:	04a95783          	lhu	a5,74(s2)
    800045dc:	2785                	addiw	a5,a5,1
    800045de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045e2:	854a                	mv	a0,s2
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	4fa080e7          	jalr	1274(ra) # 80002ade <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045ec:	40d0                	lw	a2,4(s1)
    800045ee:	00004597          	auipc	a1,0x4
    800045f2:	22258593          	addi	a1,a1,546 # 80008810 <syscalls_name+0x2b8>
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	ca4080e7          	jalr	-860(ra) # 8000329c <dirlink>
    80004600:	00054f63          	bltz	a0,8000461e <create+0x144>
    80004604:	00492603          	lw	a2,4(s2)
    80004608:	00004597          	auipc	a1,0x4
    8000460c:	21058593          	addi	a1,a1,528 # 80008818 <syscalls_name+0x2c0>
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	c8a080e7          	jalr	-886(ra) # 8000329c <dirlink>
    8000461a:	f80557e3          	bgez	a0,800045a8 <create+0xce>
      panic("create dots");
    8000461e:	00004517          	auipc	a0,0x4
    80004622:	20250513          	addi	a0,a0,514 # 80008820 <syscalls_name+0x2c8>
    80004626:	00001097          	auipc	ra,0x1
    8000462a:	632080e7          	jalr	1586(ra) # 80005c58 <panic>
    panic("create: dirlink");
    8000462e:	00004517          	auipc	a0,0x4
    80004632:	20250513          	addi	a0,a0,514 # 80008830 <syscalls_name+0x2d8>
    80004636:	00001097          	auipc	ra,0x1
    8000463a:	622080e7          	jalr	1570(ra) # 80005c58 <panic>
    return 0;
    8000463e:	84aa                	mv	s1,a0
    80004640:	b731                	j	8000454c <create+0x72>

0000000080004642 <sys_dup>:
{
    80004642:	7179                	addi	sp,sp,-48
    80004644:	f406                	sd	ra,40(sp)
    80004646:	f022                	sd	s0,32(sp)
    80004648:	ec26                	sd	s1,24(sp)
    8000464a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000464c:	fd840613          	addi	a2,s0,-40
    80004650:	4581                	li	a1,0
    80004652:	4501                	li	a0,0
    80004654:	00000097          	auipc	ra,0x0
    80004658:	ddc080e7          	jalr	-548(ra) # 80004430 <argfd>
    return -1;
    8000465c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000465e:	02054363          	bltz	a0,80004684 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004662:	fd843503          	ld	a0,-40(s0)
    80004666:	00000097          	auipc	ra,0x0
    8000466a:	e32080e7          	jalr	-462(ra) # 80004498 <fdalloc>
    8000466e:	84aa                	mv	s1,a0
    return -1;
    80004670:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004672:	00054963          	bltz	a0,80004684 <sys_dup+0x42>
  filedup(f);
    80004676:	fd843503          	ld	a0,-40(s0)
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	37a080e7          	jalr	890(ra) # 800039f4 <filedup>
  return fd;
    80004682:	87a6                	mv	a5,s1
}
    80004684:	853e                	mv	a0,a5
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	64e2                	ld	s1,24(sp)
    8000468c:	6145                	addi	sp,sp,48
    8000468e:	8082                	ret

0000000080004690 <sys_read>:
{
    80004690:	7179                	addi	sp,sp,-48
    80004692:	f406                	sd	ra,40(sp)
    80004694:	f022                	sd	s0,32(sp)
    80004696:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004698:	fe840613          	addi	a2,s0,-24
    8000469c:	4581                	li	a1,0
    8000469e:	4501                	li	a0,0
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	d90080e7          	jalr	-624(ra) # 80004430 <argfd>
    return -1;
    800046a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046aa:	04054163          	bltz	a0,800046ec <sys_read+0x5c>
    800046ae:	fe440593          	addi	a1,s0,-28
    800046b2:	4509                	li	a0,2
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	8d0080e7          	jalr	-1840(ra) # 80001f84 <argint>
    return -1;
    800046bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	02054763          	bltz	a0,800046ec <sys_read+0x5c>
    800046c2:	fd840593          	addi	a1,s0,-40
    800046c6:	4505                	li	a0,1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	8de080e7          	jalr	-1826(ra) # 80001fa6 <argaddr>
    return -1;
    800046d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	00054d63          	bltz	a0,800046ec <sys_read+0x5c>
  return fileread(f, p, n);
    800046d6:	fe442603          	lw	a2,-28(s0)
    800046da:	fd843583          	ld	a1,-40(s0)
    800046de:	fe843503          	ld	a0,-24(s0)
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	49e080e7          	jalr	1182(ra) # 80003b80 <fileread>
    800046ea:	87aa                	mv	a5,a0
}
    800046ec:	853e                	mv	a0,a5
    800046ee:	70a2                	ld	ra,40(sp)
    800046f0:	7402                	ld	s0,32(sp)
    800046f2:	6145                	addi	sp,sp,48
    800046f4:	8082                	ret

00000000800046f6 <sys_write>:
{
    800046f6:	7179                	addi	sp,sp,-48
    800046f8:	f406                	sd	ra,40(sp)
    800046fa:	f022                	sd	s0,32(sp)
    800046fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	fe840613          	addi	a2,s0,-24
    80004702:	4581                	li	a1,0
    80004704:	4501                	li	a0,0
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	d2a080e7          	jalr	-726(ra) # 80004430 <argfd>
    return -1;
    8000470e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004710:	04054163          	bltz	a0,80004752 <sys_write+0x5c>
    80004714:	fe440593          	addi	a1,s0,-28
    80004718:	4509                	li	a0,2
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	86a080e7          	jalr	-1942(ra) # 80001f84 <argint>
    return -1;
    80004722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	02054763          	bltz	a0,80004752 <sys_write+0x5c>
    80004728:	fd840593          	addi	a1,s0,-40
    8000472c:	4505                	li	a0,1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	878080e7          	jalr	-1928(ra) # 80001fa6 <argaddr>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	00054d63          	bltz	a0,80004752 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000473c:	fe442603          	lw	a2,-28(s0)
    80004740:	fd843583          	ld	a1,-40(s0)
    80004744:	fe843503          	ld	a0,-24(s0)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	4fa080e7          	jalr	1274(ra) # 80003c42 <filewrite>
    80004750:	87aa                	mv	a5,a0
}
    80004752:	853e                	mv	a0,a5
    80004754:	70a2                	ld	ra,40(sp)
    80004756:	7402                	ld	s0,32(sp)
    80004758:	6145                	addi	sp,sp,48
    8000475a:	8082                	ret

000000008000475c <sys_close>:
{
    8000475c:	1101                	addi	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004764:	fe040613          	addi	a2,s0,-32
    80004768:	fec40593          	addi	a1,s0,-20
    8000476c:	4501                	li	a0,0
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	cc2080e7          	jalr	-830(ra) # 80004430 <argfd>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004778:	02054463          	bltz	a0,800047a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000477c:	ffffc097          	auipc	ra,0xffffc
    80004780:	71e080e7          	jalr	1822(ra) # 80000e9a <myproc>
    80004784:	fec42783          	lw	a5,-20(s0)
    80004788:	07e9                	addi	a5,a5,26
    8000478a:	078e                	slli	a5,a5,0x3
    8000478c:	97aa                	add	a5,a5,a0
    8000478e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004792:	fe043503          	ld	a0,-32(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	2b0080e7          	jalr	688(ra) # 80003a46 <fileclose>
  return 0;
    8000479e:	4781                	li	a5,0
}
    800047a0:	853e                	mv	a0,a5
    800047a2:	60e2                	ld	ra,24(sp)
    800047a4:	6442                	ld	s0,16(sp)
    800047a6:	6105                	addi	sp,sp,32
    800047a8:	8082                	ret

00000000800047aa <sys_fstat>:
{
    800047aa:	1101                	addi	sp,sp,-32
    800047ac:	ec06                	sd	ra,24(sp)
    800047ae:	e822                	sd	s0,16(sp)
    800047b0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b2:	fe840613          	addi	a2,s0,-24
    800047b6:	4581                	li	a1,0
    800047b8:	4501                	li	a0,0
    800047ba:	00000097          	auipc	ra,0x0
    800047be:	c76080e7          	jalr	-906(ra) # 80004430 <argfd>
    return -1;
    800047c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c4:	02054563          	bltz	a0,800047ee <sys_fstat+0x44>
    800047c8:	fe040593          	addi	a1,s0,-32
    800047cc:	4505                	li	a0,1
    800047ce:	ffffd097          	auipc	ra,0xffffd
    800047d2:	7d8080e7          	jalr	2008(ra) # 80001fa6 <argaddr>
    return -1;
    800047d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d8:	00054b63          	bltz	a0,800047ee <sys_fstat+0x44>
  return filestat(f, st);
    800047dc:	fe043583          	ld	a1,-32(s0)
    800047e0:	fe843503          	ld	a0,-24(s0)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	32a080e7          	jalr	810(ra) # 80003b0e <filestat>
    800047ec:	87aa                	mv	a5,a0
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	60e2                	ld	ra,24(sp)
    800047f2:	6442                	ld	s0,16(sp)
    800047f4:	6105                	addi	sp,sp,32
    800047f6:	8082                	ret

00000000800047f8 <sys_link>:
{
    800047f8:	7169                	addi	sp,sp,-304
    800047fa:	f606                	sd	ra,296(sp)
    800047fc:	f222                	sd	s0,288(sp)
    800047fe:	ee26                	sd	s1,280(sp)
    80004800:	ea4a                	sd	s2,272(sp)
    80004802:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004804:	08000613          	li	a2,128
    80004808:	ed040593          	addi	a1,s0,-304
    8000480c:	4501                	li	a0,0
    8000480e:	ffffd097          	auipc	ra,0xffffd
    80004812:	7ba080e7          	jalr	1978(ra) # 80001fc8 <argstr>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004818:	10054e63          	bltz	a0,80004934 <sys_link+0x13c>
    8000481c:	08000613          	li	a2,128
    80004820:	f5040593          	addi	a1,s0,-176
    80004824:	4505                	li	a0,1
    80004826:	ffffd097          	auipc	ra,0xffffd
    8000482a:	7a2080e7          	jalr	1954(ra) # 80001fc8 <argstr>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004830:	10054263          	bltz	a0,80004934 <sys_link+0x13c>
  begin_op();
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	d46080e7          	jalr	-698(ra) # 8000357a <begin_op>
  if((ip = namei(old)) == 0){
    8000483c:	ed040513          	addi	a0,s0,-304
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	b1e080e7          	jalr	-1250(ra) # 8000335e <namei>
    80004848:	84aa                	mv	s1,a0
    8000484a:	c551                	beqz	a0,800048d6 <sys_link+0xde>
  ilock(ip);
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	35c080e7          	jalr	860(ra) # 80002ba8 <ilock>
  if(ip->type == T_DIR){
    80004854:	04449703          	lh	a4,68(s1)
    80004858:	4785                	li	a5,1
    8000485a:	08f70463          	beq	a4,a5,800048e2 <sys_link+0xea>
  ip->nlink++;
    8000485e:	04a4d783          	lhu	a5,74(s1)
    80004862:	2785                	addiw	a5,a5,1
    80004864:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	274080e7          	jalr	628(ra) # 80002ade <iupdate>
  iunlock(ip);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	3f6080e7          	jalr	1014(ra) # 80002c6a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000487c:	fd040593          	addi	a1,s0,-48
    80004880:	f5040513          	addi	a0,s0,-176
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	af8080e7          	jalr	-1288(ra) # 8000337c <nameiparent>
    8000488c:	892a                	mv	s2,a0
    8000488e:	c935                	beqz	a0,80004902 <sys_link+0x10a>
  ilock(dp);
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	318080e7          	jalr	792(ra) # 80002ba8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004898:	00092703          	lw	a4,0(s2)
    8000489c:	409c                	lw	a5,0(s1)
    8000489e:	04f71d63          	bne	a4,a5,800048f8 <sys_link+0x100>
    800048a2:	40d0                	lw	a2,4(s1)
    800048a4:	fd040593          	addi	a1,s0,-48
    800048a8:	854a                	mv	a0,s2
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	9f2080e7          	jalr	-1550(ra) # 8000329c <dirlink>
    800048b2:	04054363          	bltz	a0,800048f8 <sys_link+0x100>
  iunlockput(dp);
    800048b6:	854a                	mv	a0,s2
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	552080e7          	jalr	1362(ra) # 80002e0a <iunlockput>
  iput(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	4a0080e7          	jalr	1184(ra) # 80002d62 <iput>
  end_op();
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	d30080e7          	jalr	-720(ra) # 800035fa <end_op>
  return 0;
    800048d2:	4781                	li	a5,0
    800048d4:	a085                	j	80004934 <sys_link+0x13c>
    end_op();
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	d24080e7          	jalr	-732(ra) # 800035fa <end_op>
    return -1;
    800048de:	57fd                	li	a5,-1
    800048e0:	a891                	j	80004934 <sys_link+0x13c>
    iunlockput(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	526080e7          	jalr	1318(ra) # 80002e0a <iunlockput>
    end_op();
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	d0e080e7          	jalr	-754(ra) # 800035fa <end_op>
    return -1;
    800048f4:	57fd                	li	a5,-1
    800048f6:	a83d                	j	80004934 <sys_link+0x13c>
    iunlockput(dp);
    800048f8:	854a                	mv	a0,s2
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	510080e7          	jalr	1296(ra) # 80002e0a <iunlockput>
  ilock(ip);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	2a4080e7          	jalr	676(ra) # 80002ba8 <ilock>
  ip->nlink--;
    8000490c:	04a4d783          	lhu	a5,74(s1)
    80004910:	37fd                	addiw	a5,a5,-1
    80004912:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	1c6080e7          	jalr	454(ra) # 80002ade <iupdate>
  iunlockput(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	4e8080e7          	jalr	1256(ra) # 80002e0a <iunlockput>
  end_op();
    8000492a:	fffff097          	auipc	ra,0xfffff
    8000492e:	cd0080e7          	jalr	-816(ra) # 800035fa <end_op>
  return -1;
    80004932:	57fd                	li	a5,-1
}
    80004934:	853e                	mv	a0,a5
    80004936:	70b2                	ld	ra,296(sp)
    80004938:	7412                	ld	s0,288(sp)
    8000493a:	64f2                	ld	s1,280(sp)
    8000493c:	6952                	ld	s2,272(sp)
    8000493e:	6155                	addi	sp,sp,304
    80004940:	8082                	ret

0000000080004942 <sys_unlink>:
{
    80004942:	7151                	addi	sp,sp,-240
    80004944:	f586                	sd	ra,232(sp)
    80004946:	f1a2                	sd	s0,224(sp)
    80004948:	eda6                	sd	s1,216(sp)
    8000494a:	e9ca                	sd	s2,208(sp)
    8000494c:	e5ce                	sd	s3,200(sp)
    8000494e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004950:	08000613          	li	a2,128
    80004954:	f3040593          	addi	a1,s0,-208
    80004958:	4501                	li	a0,0
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	66e080e7          	jalr	1646(ra) # 80001fc8 <argstr>
    80004962:	18054163          	bltz	a0,80004ae4 <sys_unlink+0x1a2>
  begin_op();
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	c14080e7          	jalr	-1004(ra) # 8000357a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000496e:	fb040593          	addi	a1,s0,-80
    80004972:	f3040513          	addi	a0,s0,-208
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	a06080e7          	jalr	-1530(ra) # 8000337c <nameiparent>
    8000497e:	84aa                	mv	s1,a0
    80004980:	c979                	beqz	a0,80004a56 <sys_unlink+0x114>
  ilock(dp);
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	226080e7          	jalr	550(ra) # 80002ba8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000498a:	00004597          	auipc	a1,0x4
    8000498e:	e8658593          	addi	a1,a1,-378 # 80008810 <syscalls_name+0x2b8>
    80004992:	fb040513          	addi	a0,s0,-80
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	6dc080e7          	jalr	1756(ra) # 80003072 <namecmp>
    8000499e:	14050a63          	beqz	a0,80004af2 <sys_unlink+0x1b0>
    800049a2:	00004597          	auipc	a1,0x4
    800049a6:	e7658593          	addi	a1,a1,-394 # 80008818 <syscalls_name+0x2c0>
    800049aa:	fb040513          	addi	a0,s0,-80
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	6c4080e7          	jalr	1732(ra) # 80003072 <namecmp>
    800049b6:	12050e63          	beqz	a0,80004af2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ba:	f2c40613          	addi	a2,s0,-212
    800049be:	fb040593          	addi	a1,s0,-80
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	6c8080e7          	jalr	1736(ra) # 8000308c <dirlookup>
    800049cc:	892a                	mv	s2,a0
    800049ce:	12050263          	beqz	a0,80004af2 <sys_unlink+0x1b0>
  ilock(ip);
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	1d6080e7          	jalr	470(ra) # 80002ba8 <ilock>
  if(ip->nlink < 1)
    800049da:	04a91783          	lh	a5,74(s2)
    800049de:	08f05263          	blez	a5,80004a62 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049e2:	04491703          	lh	a4,68(s2)
    800049e6:	4785                	li	a5,1
    800049e8:	08f70563          	beq	a4,a5,80004a72 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049ec:	4641                	li	a2,16
    800049ee:	4581                	li	a1,0
    800049f0:	fc040513          	addi	a0,s0,-64
    800049f4:	ffffb097          	auipc	ra,0xffffb
    800049f8:	7d6080e7          	jalr	2006(ra) # 800001ca <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049fc:	4741                	li	a4,16
    800049fe:	f2c42683          	lw	a3,-212(s0)
    80004a02:	fc040613          	addi	a2,s0,-64
    80004a06:	4581                	li	a1,0
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	54a080e7          	jalr	1354(ra) # 80002f54 <writei>
    80004a12:	47c1                	li	a5,16
    80004a14:	0af51563          	bne	a0,a5,80004abe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a18:	04491703          	lh	a4,68(s2)
    80004a1c:	4785                	li	a5,1
    80004a1e:	0af70863          	beq	a4,a5,80004ace <sys_unlink+0x18c>
  iunlockput(dp);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	3e6080e7          	jalr	998(ra) # 80002e0a <iunlockput>
  ip->nlink--;
    80004a2c:	04a95783          	lhu	a5,74(s2)
    80004a30:	37fd                	addiw	a5,a5,-1
    80004a32:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	0a6080e7          	jalr	166(ra) # 80002ade <iupdate>
  iunlockput(ip);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	3c8080e7          	jalr	968(ra) # 80002e0a <iunlockput>
  end_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	bb0080e7          	jalr	-1104(ra) # 800035fa <end_op>
  return 0;
    80004a52:	4501                	li	a0,0
    80004a54:	a84d                	j	80004b06 <sys_unlink+0x1c4>
    end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	ba4080e7          	jalr	-1116(ra) # 800035fa <end_op>
    return -1;
    80004a5e:	557d                	li	a0,-1
    80004a60:	a05d                	j	80004b06 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a62:	00004517          	auipc	a0,0x4
    80004a66:	dde50513          	addi	a0,a0,-546 # 80008840 <syscalls_name+0x2e8>
    80004a6a:	00001097          	auipc	ra,0x1
    80004a6e:	1ee080e7          	jalr	494(ra) # 80005c58 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a72:	04c92703          	lw	a4,76(s2)
    80004a76:	02000793          	li	a5,32
    80004a7a:	f6e7f9e3          	bgeu	a5,a4,800049ec <sys_unlink+0xaa>
    80004a7e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a82:	4741                	li	a4,16
    80004a84:	86ce                	mv	a3,s3
    80004a86:	f1840613          	addi	a2,s0,-232
    80004a8a:	4581                	li	a1,0
    80004a8c:	854a                	mv	a0,s2
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	3ce080e7          	jalr	974(ra) # 80002e5c <readi>
    80004a96:	47c1                	li	a5,16
    80004a98:	00f51b63          	bne	a0,a5,80004aae <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a9c:	f1845783          	lhu	a5,-232(s0)
    80004aa0:	e7a1                	bnez	a5,80004ae8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa2:	29c1                	addiw	s3,s3,16
    80004aa4:	04c92783          	lw	a5,76(s2)
    80004aa8:	fcf9ede3          	bltu	s3,a5,80004a82 <sys_unlink+0x140>
    80004aac:	b781                	j	800049ec <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aae:	00004517          	auipc	a0,0x4
    80004ab2:	daa50513          	addi	a0,a0,-598 # 80008858 <syscalls_name+0x300>
    80004ab6:	00001097          	auipc	ra,0x1
    80004aba:	1a2080e7          	jalr	418(ra) # 80005c58 <panic>
    panic("unlink: writei");
    80004abe:	00004517          	auipc	a0,0x4
    80004ac2:	db250513          	addi	a0,a0,-590 # 80008870 <syscalls_name+0x318>
    80004ac6:	00001097          	auipc	ra,0x1
    80004aca:	192080e7          	jalr	402(ra) # 80005c58 <panic>
    dp->nlink--;
    80004ace:	04a4d783          	lhu	a5,74(s1)
    80004ad2:	37fd                	addiw	a5,a5,-1
    80004ad4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	004080e7          	jalr	4(ra) # 80002ade <iupdate>
    80004ae2:	b781                	j	80004a22 <sys_unlink+0xe0>
    return -1;
    80004ae4:	557d                	li	a0,-1
    80004ae6:	a005                	j	80004b06 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	320080e7          	jalr	800(ra) # 80002e0a <iunlockput>
  iunlockput(dp);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	316080e7          	jalr	790(ra) # 80002e0a <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	afe080e7          	jalr	-1282(ra) # 800035fa <end_op>
  return -1;
    80004b04:	557d                	li	a0,-1
}
    80004b06:	70ae                	ld	ra,232(sp)
    80004b08:	740e                	ld	s0,224(sp)
    80004b0a:	64ee                	ld	s1,216(sp)
    80004b0c:	694e                	ld	s2,208(sp)
    80004b0e:	69ae                	ld	s3,200(sp)
    80004b10:	616d                	addi	sp,sp,240
    80004b12:	8082                	ret

0000000080004b14 <sys_open>:

uint64
sys_open(void)
{
    80004b14:	7131                	addi	sp,sp,-192
    80004b16:	fd06                	sd	ra,184(sp)
    80004b18:	f922                	sd	s0,176(sp)
    80004b1a:	f526                	sd	s1,168(sp)
    80004b1c:	f14a                	sd	s2,160(sp)
    80004b1e:	ed4e                	sd	s3,152(sp)
    80004b20:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b22:	08000613          	li	a2,128
    80004b26:	f5040593          	addi	a1,s0,-176
    80004b2a:	4501                	li	a0,0
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	49c080e7          	jalr	1180(ra) # 80001fc8 <argstr>
    return -1;
    80004b34:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b36:	0c054163          	bltz	a0,80004bf8 <sys_open+0xe4>
    80004b3a:	f4c40593          	addi	a1,s0,-180
    80004b3e:	4505                	li	a0,1
    80004b40:	ffffd097          	auipc	ra,0xffffd
    80004b44:	444080e7          	jalr	1092(ra) # 80001f84 <argint>
    80004b48:	0a054863          	bltz	a0,80004bf8 <sys_open+0xe4>

  begin_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	a2e080e7          	jalr	-1490(ra) # 8000357a <begin_op>

  if(omode & O_CREATE){
    80004b54:	f4c42783          	lw	a5,-180(s0)
    80004b58:	2007f793          	andi	a5,a5,512
    80004b5c:	cbdd                	beqz	a5,80004c12 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b5e:	4681                	li	a3,0
    80004b60:	4601                	li	a2,0
    80004b62:	4589                	li	a1,2
    80004b64:	f5040513          	addi	a0,s0,-176
    80004b68:	00000097          	auipc	ra,0x0
    80004b6c:	972080e7          	jalr	-1678(ra) # 800044da <create>
    80004b70:	892a                	mv	s2,a0
    if(ip == 0){
    80004b72:	c959                	beqz	a0,80004c08 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b74:	04491703          	lh	a4,68(s2)
    80004b78:	478d                	li	a5,3
    80004b7a:	00f71763          	bne	a4,a5,80004b88 <sys_open+0x74>
    80004b7e:	04695703          	lhu	a4,70(s2)
    80004b82:	47a5                	li	a5,9
    80004b84:	0ce7ec63          	bltu	a5,a4,80004c5c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	e02080e7          	jalr	-510(ra) # 8000398a <filealloc>
    80004b90:	89aa                	mv	s3,a0
    80004b92:	10050263          	beqz	a0,80004c96 <sys_open+0x182>
    80004b96:	00000097          	auipc	ra,0x0
    80004b9a:	902080e7          	jalr	-1790(ra) # 80004498 <fdalloc>
    80004b9e:	84aa                	mv	s1,a0
    80004ba0:	0e054663          	bltz	a0,80004c8c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba4:	04491703          	lh	a4,68(s2)
    80004ba8:	478d                	li	a5,3
    80004baa:	0cf70463          	beq	a4,a5,80004c72 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bae:	4789                	li	a5,2
    80004bb0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bb4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bbc:	f4c42783          	lw	a5,-180(s0)
    80004bc0:	0017c713          	xori	a4,a5,1
    80004bc4:	8b05                	andi	a4,a4,1
    80004bc6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bca:	0037f713          	andi	a4,a5,3
    80004bce:	00e03733          	snez	a4,a4
    80004bd2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bd6:	4007f793          	andi	a5,a5,1024
    80004bda:	c791                	beqz	a5,80004be6 <sys_open+0xd2>
    80004bdc:	04491703          	lh	a4,68(s2)
    80004be0:	4789                	li	a5,2
    80004be2:	08f70f63          	beq	a4,a5,80004c80 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004be6:	854a                	mv	a0,s2
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	082080e7          	jalr	130(ra) # 80002c6a <iunlock>
  end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	a0a080e7          	jalr	-1526(ra) # 800035fa <end_op>

  return fd;
}
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	70ea                	ld	ra,184(sp)
    80004bfc:	744a                	ld	s0,176(sp)
    80004bfe:	74aa                	ld	s1,168(sp)
    80004c00:	790a                	ld	s2,160(sp)
    80004c02:	69ea                	ld	s3,152(sp)
    80004c04:	6129                	addi	sp,sp,192
    80004c06:	8082                	ret
      end_op();
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	9f2080e7          	jalr	-1550(ra) # 800035fa <end_op>
      return -1;
    80004c10:	b7e5                	j	80004bf8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c12:	f5040513          	addi	a0,s0,-176
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	748080e7          	jalr	1864(ra) # 8000335e <namei>
    80004c1e:	892a                	mv	s2,a0
    80004c20:	c905                	beqz	a0,80004c50 <sys_open+0x13c>
    ilock(ip);
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	f86080e7          	jalr	-122(ra) # 80002ba8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c2a:	04491703          	lh	a4,68(s2)
    80004c2e:	4785                	li	a5,1
    80004c30:	f4f712e3          	bne	a4,a5,80004b74 <sys_open+0x60>
    80004c34:	f4c42783          	lw	a5,-180(s0)
    80004c38:	dba1                	beqz	a5,80004b88 <sys_open+0x74>
      iunlockput(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	1ce080e7          	jalr	462(ra) # 80002e0a <iunlockput>
      end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	9b6080e7          	jalr	-1610(ra) # 800035fa <end_op>
      return -1;
    80004c4c:	54fd                	li	s1,-1
    80004c4e:	b76d                	j	80004bf8 <sys_open+0xe4>
      end_op();
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	9aa080e7          	jalr	-1622(ra) # 800035fa <end_op>
      return -1;
    80004c58:	54fd                	li	s1,-1
    80004c5a:	bf79                	j	80004bf8 <sys_open+0xe4>
    iunlockput(ip);
    80004c5c:	854a                	mv	a0,s2
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	1ac080e7          	jalr	428(ra) # 80002e0a <iunlockput>
    end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	994080e7          	jalr	-1644(ra) # 800035fa <end_op>
    return -1;
    80004c6e:	54fd                	li	s1,-1
    80004c70:	b761                	j	80004bf8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c72:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c76:	04691783          	lh	a5,70(s2)
    80004c7a:	02f99223          	sh	a5,36(s3)
    80004c7e:	bf2d                	j	80004bb8 <sys_open+0xa4>
    itrunc(ip);
    80004c80:	854a                	mv	a0,s2
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	034080e7          	jalr	52(ra) # 80002cb6 <itrunc>
    80004c8a:	bfb1                	j	80004be6 <sys_open+0xd2>
      fileclose(f);
    80004c8c:	854e                	mv	a0,s3
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	db8080e7          	jalr	-584(ra) # 80003a46 <fileclose>
    iunlockput(ip);
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	172080e7          	jalr	370(ra) # 80002e0a <iunlockput>
    end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	95a080e7          	jalr	-1702(ra) # 800035fa <end_op>
    return -1;
    80004ca8:	54fd                	li	s1,-1
    80004caa:	b7b9                	j	80004bf8 <sys_open+0xe4>

0000000080004cac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cac:	7175                	addi	sp,sp,-144
    80004cae:	e506                	sd	ra,136(sp)
    80004cb0:	e122                	sd	s0,128(sp)
    80004cb2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	8c6080e7          	jalr	-1850(ra) # 8000357a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cbc:	08000613          	li	a2,128
    80004cc0:	f7040593          	addi	a1,s0,-144
    80004cc4:	4501                	li	a0,0
    80004cc6:	ffffd097          	auipc	ra,0xffffd
    80004cca:	302080e7          	jalr	770(ra) # 80001fc8 <argstr>
    80004cce:	02054963          	bltz	a0,80004d00 <sys_mkdir+0x54>
    80004cd2:	4681                	li	a3,0
    80004cd4:	4601                	li	a2,0
    80004cd6:	4585                	li	a1,1
    80004cd8:	f7040513          	addi	a0,s0,-144
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	7fe080e7          	jalr	2046(ra) # 800044da <create>
    80004ce4:	cd11                	beqz	a0,80004d00 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	124080e7          	jalr	292(ra) # 80002e0a <iunlockput>
  end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	90c080e7          	jalr	-1780(ra) # 800035fa <end_op>
  return 0;
    80004cf6:	4501                	li	a0,0
}
    80004cf8:	60aa                	ld	ra,136(sp)
    80004cfa:	640a                	ld	s0,128(sp)
    80004cfc:	6149                	addi	sp,sp,144
    80004cfe:	8082                	ret
    end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	8fa080e7          	jalr	-1798(ra) # 800035fa <end_op>
    return -1;
    80004d08:	557d                	li	a0,-1
    80004d0a:	b7fd                	j	80004cf8 <sys_mkdir+0x4c>

0000000080004d0c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d0c:	7135                	addi	sp,sp,-160
    80004d0e:	ed06                	sd	ra,152(sp)
    80004d10:	e922                	sd	s0,144(sp)
    80004d12:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	866080e7          	jalr	-1946(ra) # 8000357a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d1c:	08000613          	li	a2,128
    80004d20:	f7040593          	addi	a1,s0,-144
    80004d24:	4501                	li	a0,0
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	2a2080e7          	jalr	674(ra) # 80001fc8 <argstr>
    80004d2e:	04054a63          	bltz	a0,80004d82 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d32:	f6c40593          	addi	a1,s0,-148
    80004d36:	4505                	li	a0,1
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	24c080e7          	jalr	588(ra) # 80001f84 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d40:	04054163          	bltz	a0,80004d82 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d44:	f6840593          	addi	a1,s0,-152
    80004d48:	4509                	li	a0,2
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	23a080e7          	jalr	570(ra) # 80001f84 <argint>
     argint(1, &major) < 0 ||
    80004d52:	02054863          	bltz	a0,80004d82 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d56:	f6841683          	lh	a3,-152(s0)
    80004d5a:	f6c41603          	lh	a2,-148(s0)
    80004d5e:	458d                	li	a1,3
    80004d60:	f7040513          	addi	a0,s0,-144
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	776080e7          	jalr	1910(ra) # 800044da <create>
     argint(2, &minor) < 0 ||
    80004d6c:	c919                	beqz	a0,80004d82 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	09c080e7          	jalr	156(ra) # 80002e0a <iunlockput>
  end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	884080e7          	jalr	-1916(ra) # 800035fa <end_op>
  return 0;
    80004d7e:	4501                	li	a0,0
    80004d80:	a031                	j	80004d8c <sys_mknod+0x80>
    end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	878080e7          	jalr	-1928(ra) # 800035fa <end_op>
    return -1;
    80004d8a:	557d                	li	a0,-1
}
    80004d8c:	60ea                	ld	ra,152(sp)
    80004d8e:	644a                	ld	s0,144(sp)
    80004d90:	610d                	addi	sp,sp,160
    80004d92:	8082                	ret

0000000080004d94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d94:	7135                	addi	sp,sp,-160
    80004d96:	ed06                	sd	ra,152(sp)
    80004d98:	e922                	sd	s0,144(sp)
    80004d9a:	e526                	sd	s1,136(sp)
    80004d9c:	e14a                	sd	s2,128(sp)
    80004d9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004da0:	ffffc097          	auipc	ra,0xffffc
    80004da4:	0fa080e7          	jalr	250(ra) # 80000e9a <myproc>
    80004da8:	892a                	mv	s2,a0
  
  begin_op();
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	7d0080e7          	jalr	2000(ra) # 8000357a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004db2:	08000613          	li	a2,128
    80004db6:	f6040593          	addi	a1,s0,-160
    80004dba:	4501                	li	a0,0
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	20c080e7          	jalr	524(ra) # 80001fc8 <argstr>
    80004dc4:	04054b63          	bltz	a0,80004e1a <sys_chdir+0x86>
    80004dc8:	f6040513          	addi	a0,s0,-160
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	592080e7          	jalr	1426(ra) # 8000335e <namei>
    80004dd4:	84aa                	mv	s1,a0
    80004dd6:	c131                	beqz	a0,80004e1a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	dd0080e7          	jalr	-560(ra) # 80002ba8 <ilock>
  if(ip->type != T_DIR){
    80004de0:	04449703          	lh	a4,68(s1)
    80004de4:	4785                	li	a5,1
    80004de6:	04f71063          	bne	a4,a5,80004e26 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dea:	8526                	mv	a0,s1
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	e7e080e7          	jalr	-386(ra) # 80002c6a <iunlock>
  iput(p->cwd);
    80004df4:	15093503          	ld	a0,336(s2)
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	f6a080e7          	jalr	-150(ra) # 80002d62 <iput>
  end_op();
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	7fa080e7          	jalr	2042(ra) # 800035fa <end_op>
  p->cwd = ip;
    80004e08:	14993823          	sd	s1,336(s2)
  return 0;
    80004e0c:	4501                	li	a0,0
}
    80004e0e:	60ea                	ld	ra,152(sp)
    80004e10:	644a                	ld	s0,144(sp)
    80004e12:	64aa                	ld	s1,136(sp)
    80004e14:	690a                	ld	s2,128(sp)
    80004e16:	610d                	addi	sp,sp,160
    80004e18:	8082                	ret
    end_op();
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	7e0080e7          	jalr	2016(ra) # 800035fa <end_op>
    return -1;
    80004e22:	557d                	li	a0,-1
    80004e24:	b7ed                	j	80004e0e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	fe2080e7          	jalr	-30(ra) # 80002e0a <iunlockput>
    end_op();
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	7ca080e7          	jalr	1994(ra) # 800035fa <end_op>
    return -1;
    80004e38:	557d                	li	a0,-1
    80004e3a:	bfd1                	j	80004e0e <sys_chdir+0x7a>

0000000080004e3c <sys_exec>:

uint64
sys_exec(void)
{
    80004e3c:	7145                	addi	sp,sp,-464
    80004e3e:	e786                	sd	ra,456(sp)
    80004e40:	e3a2                	sd	s0,448(sp)
    80004e42:	ff26                	sd	s1,440(sp)
    80004e44:	fb4a                	sd	s2,432(sp)
    80004e46:	f74e                	sd	s3,424(sp)
    80004e48:	f352                	sd	s4,416(sp)
    80004e4a:	ef56                	sd	s5,408(sp)
    80004e4c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e4e:	08000613          	li	a2,128
    80004e52:	f4040593          	addi	a1,s0,-192
    80004e56:	4501                	li	a0,0
    80004e58:	ffffd097          	auipc	ra,0xffffd
    80004e5c:	170080e7          	jalr	368(ra) # 80001fc8 <argstr>
    return -1;
    80004e60:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e62:	0c054a63          	bltz	a0,80004f36 <sys_exec+0xfa>
    80004e66:	e3840593          	addi	a1,s0,-456
    80004e6a:	4505                	li	a0,1
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	13a080e7          	jalr	314(ra) # 80001fa6 <argaddr>
    80004e74:	0c054163          	bltz	a0,80004f36 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e78:	10000613          	li	a2,256
    80004e7c:	4581                	li	a1,0
    80004e7e:	e4040513          	addi	a0,s0,-448
    80004e82:	ffffb097          	auipc	ra,0xffffb
    80004e86:	348080e7          	jalr	840(ra) # 800001ca <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e8a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e8e:	89a6                	mv	s3,s1
    80004e90:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e92:	02000a13          	li	s4,32
    80004e96:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e9a:	00391513          	slli	a0,s2,0x3
    80004e9e:	e3040593          	addi	a1,s0,-464
    80004ea2:	e3843783          	ld	a5,-456(s0)
    80004ea6:	953e                	add	a0,a0,a5
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	042080e7          	jalr	66(ra) # 80001eea <fetchaddr>
    80004eb0:	02054a63          	bltz	a0,80004ee4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eb4:	e3043783          	ld	a5,-464(s0)
    80004eb8:	c3b9                	beqz	a5,80004efe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eba:	ffffb097          	auipc	ra,0xffffb
    80004ebe:	25e080e7          	jalr	606(ra) # 80000118 <kalloc>
    80004ec2:	85aa                	mv	a1,a0
    80004ec4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ec8:	cd11                	beqz	a0,80004ee4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eca:	6605                	lui	a2,0x1
    80004ecc:	e3043503          	ld	a0,-464(s0)
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	06c080e7          	jalr	108(ra) # 80001f3c <fetchstr>
    80004ed8:	00054663          	bltz	a0,80004ee4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004edc:	0905                	addi	s2,s2,1
    80004ede:	09a1                	addi	s3,s3,8
    80004ee0:	fb491be3          	bne	s2,s4,80004e96 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee4:	10048913          	addi	s2,s1,256
    80004ee8:	6088                	ld	a0,0(s1)
    80004eea:	c529                	beqz	a0,80004f34 <sys_exec+0xf8>
    kfree(argv[i]);
    80004eec:	ffffb097          	auipc	ra,0xffffb
    80004ef0:	130080e7          	jalr	304(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef4:	04a1                	addi	s1,s1,8
    80004ef6:	ff2499e3          	bne	s1,s2,80004ee8 <sys_exec+0xac>
  return -1;
    80004efa:	597d                	li	s2,-1
    80004efc:	a82d                	j	80004f36 <sys_exec+0xfa>
      argv[i] = 0;
    80004efe:	0a8e                	slli	s5,s5,0x3
    80004f00:	fc040793          	addi	a5,s0,-64
    80004f04:	9abe                	add	s5,s5,a5
    80004f06:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f0a:	e4040593          	addi	a1,s0,-448
    80004f0e:	f4040513          	addi	a0,s0,-192
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	194080e7          	jalr	404(ra) # 800040a6 <exec>
    80004f1a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1c:	10048993          	addi	s3,s1,256
    80004f20:	6088                	ld	a0,0(s1)
    80004f22:	c911                	beqz	a0,80004f36 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f24:	ffffb097          	auipc	ra,0xffffb
    80004f28:	0f8080e7          	jalr	248(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2c:	04a1                	addi	s1,s1,8
    80004f2e:	ff3499e3          	bne	s1,s3,80004f20 <sys_exec+0xe4>
    80004f32:	a011                	j	80004f36 <sys_exec+0xfa>
  return -1;
    80004f34:	597d                	li	s2,-1
}
    80004f36:	854a                	mv	a0,s2
    80004f38:	60be                	ld	ra,456(sp)
    80004f3a:	641e                	ld	s0,448(sp)
    80004f3c:	74fa                	ld	s1,440(sp)
    80004f3e:	795a                	ld	s2,432(sp)
    80004f40:	79ba                	ld	s3,424(sp)
    80004f42:	7a1a                	ld	s4,416(sp)
    80004f44:	6afa                	ld	s5,408(sp)
    80004f46:	6179                	addi	sp,sp,464
    80004f48:	8082                	ret

0000000080004f4a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f4a:	7139                	addi	sp,sp,-64
    80004f4c:	fc06                	sd	ra,56(sp)
    80004f4e:	f822                	sd	s0,48(sp)
    80004f50:	f426                	sd	s1,40(sp)
    80004f52:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f54:	ffffc097          	auipc	ra,0xffffc
    80004f58:	f46080e7          	jalr	-186(ra) # 80000e9a <myproc>
    80004f5c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f5e:	fd840593          	addi	a1,s0,-40
    80004f62:	4501                	li	a0,0
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	042080e7          	jalr	66(ra) # 80001fa6 <argaddr>
    return -1;
    80004f6c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f6e:	0e054063          	bltz	a0,8000504e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f72:	fc840593          	addi	a1,s0,-56
    80004f76:	fd040513          	addi	a0,s0,-48
    80004f7a:	fffff097          	auipc	ra,0xfffff
    80004f7e:	dfc080e7          	jalr	-516(ra) # 80003d76 <pipealloc>
    return -1;
    80004f82:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f84:	0c054563          	bltz	a0,8000504e <sys_pipe+0x104>
  fd0 = -1;
    80004f88:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f8c:	fd043503          	ld	a0,-48(s0)
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	508080e7          	jalr	1288(ra) # 80004498 <fdalloc>
    80004f98:	fca42223          	sw	a0,-60(s0)
    80004f9c:	08054c63          	bltz	a0,80005034 <sys_pipe+0xea>
    80004fa0:	fc843503          	ld	a0,-56(s0)
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	4f4080e7          	jalr	1268(ra) # 80004498 <fdalloc>
    80004fac:	fca42023          	sw	a0,-64(s0)
    80004fb0:	06054863          	bltz	a0,80005020 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb4:	4691                	li	a3,4
    80004fb6:	fc440613          	addi	a2,s0,-60
    80004fba:	fd843583          	ld	a1,-40(s0)
    80004fbe:	68a8                	ld	a0,80(s1)
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	b9c080e7          	jalr	-1124(ra) # 80000b5c <copyout>
    80004fc8:	02054063          	bltz	a0,80004fe8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fcc:	4691                	li	a3,4
    80004fce:	fc040613          	addi	a2,s0,-64
    80004fd2:	fd843583          	ld	a1,-40(s0)
    80004fd6:	0591                	addi	a1,a1,4
    80004fd8:	68a8                	ld	a0,80(s1)
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	b82080e7          	jalr	-1150(ra) # 80000b5c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fe2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe4:	06055563          	bgez	a0,8000504e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fe8:	fc442783          	lw	a5,-60(s0)
    80004fec:	07e9                	addi	a5,a5,26
    80004fee:	078e                	slli	a5,a5,0x3
    80004ff0:	97a6                	add	a5,a5,s1
    80004ff2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ff6:	fc042503          	lw	a0,-64(s0)
    80004ffa:	0569                	addi	a0,a0,26
    80004ffc:	050e                	slli	a0,a0,0x3
    80004ffe:	9526                	add	a0,a0,s1
    80005000:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005004:	fd043503          	ld	a0,-48(s0)
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	a3e080e7          	jalr	-1474(ra) # 80003a46 <fileclose>
    fileclose(wf);
    80005010:	fc843503          	ld	a0,-56(s0)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	a32080e7          	jalr	-1486(ra) # 80003a46 <fileclose>
    return -1;
    8000501c:	57fd                	li	a5,-1
    8000501e:	a805                	j	8000504e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005020:	fc442783          	lw	a5,-60(s0)
    80005024:	0007c863          	bltz	a5,80005034 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005028:	01a78513          	addi	a0,a5,26
    8000502c:	050e                	slli	a0,a0,0x3
    8000502e:	9526                	add	a0,a0,s1
    80005030:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005034:	fd043503          	ld	a0,-48(s0)
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	a0e080e7          	jalr	-1522(ra) # 80003a46 <fileclose>
    fileclose(wf);
    80005040:	fc843503          	ld	a0,-56(s0)
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	a02080e7          	jalr	-1534(ra) # 80003a46 <fileclose>
    return -1;
    8000504c:	57fd                	li	a5,-1
}
    8000504e:	853e                	mv	a0,a5
    80005050:	70e2                	ld	ra,56(sp)
    80005052:	7442                	ld	s0,48(sp)
    80005054:	74a2                	ld	s1,40(sp)
    80005056:	6121                	addi	sp,sp,64
    80005058:	8082                	ret
    8000505a:	0000                	unimp
    8000505c:	0000                	unimp
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	d17fc0ef          	jal	ra,80001db6 <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d36080e7          	jalr	-714(ra) # 80000e6e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00052023          	sw	zero,0(a0)
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	cfe080e7          	jalr	-770(ra) # 80000e6e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5179b          	slliw	a5,a0,0xd
    8000517c:	0c201537          	lui	a0,0xc201
    80005180:	953e                	add	a0,a0,a5
  return irq;
}
    80005182:	4148                	lw	a0,4(a0)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cd6080e7          	jalr	-810(ra) # 80000e6e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c963          	blt	a5,a0,80005232 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00016797          	auipc	a5,0x16
    800051c8:	e3c78793          	addi	a5,a5,-452 # 8001b000 <disk>
    800051cc:	00a78733          	add	a4,a5,a0
    800051d0:	6789                	lui	a5,0x2
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d8:	e7ad                	bnez	a5,80005242 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051da:	00451793          	slli	a5,a0,0x4
    800051de:	00018717          	auipc	a4,0x18
    800051e2:	e2270713          	addi	a4,a4,-478 # 8001d000 <disk+0x2000>
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ee:	6314                	ld	a3,0(a4)
    800051f0:	96be                	add	a3,a3,a5
    800051f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fe:	6318                	ld	a4,0(a4)
    80005200:	97ba                	add	a5,a5,a4
    80005202:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005206:	00016797          	auipc	a5,0x16
    8000520a:	dfa78793          	addi	a5,a5,-518 # 8001b000 <disk>
    8000520e:	97aa                	add	a5,a5,a0
    80005210:	6509                	lui	a0,0x2
    80005212:	953e                	add	a0,a0,a5
    80005214:	4785                	li	a5,1
    80005216:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000521a:	00018517          	auipc	a0,0x18
    8000521e:	dfe50513          	addi	a0,a0,-514 # 8001d018 <disk+0x2018>
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	4c8080e7          	jalr	1224(ra) # 800016ea <wakeup>
}
    8000522a:	60a2                	ld	ra,8(sp)
    8000522c:	6402                	ld	s0,0(sp)
    8000522e:	0141                	addi	sp,sp,16
    80005230:	8082                	ret
    panic("free_desc 1");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	64e50513          	addi	a0,a0,1614 # 80008880 <syscalls_name+0x328>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a1e080e7          	jalr	-1506(ra) # 80005c58 <panic>
    panic("free_desc 2");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	64e50513          	addi	a0,a0,1614 # 80008890 <syscalls_name+0x338>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a0e080e7          	jalr	-1522(ra) # 80005c58 <panic>

0000000080005252 <virtio_disk_init>:
{
    80005252:	1101                	addi	sp,sp,-32
    80005254:	ec06                	sd	ra,24(sp)
    80005256:	e822                	sd	s0,16(sp)
    80005258:	e426                	sd	s1,8(sp)
    8000525a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525c:	00003597          	auipc	a1,0x3
    80005260:	64458593          	addi	a1,a1,1604 # 800088a0 <syscalls_name+0x348>
    80005264:	00018517          	auipc	a0,0x18
    80005268:	ec450513          	addi	a0,a0,-316 # 8001d128 <disk+0x2128>
    8000526c:	00001097          	auipc	ra,0x1
    80005270:	ea6080e7          	jalr	-346(ra) # 80006112 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	4398                	lw	a4,0(a5)
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	747277b7          	lui	a5,0x74727
    80005280:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005284:	0ef71163          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	43dc                	lw	a5,4(a5)
    8000528e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005290:	4705                	li	a4,1
    80005292:	0ce79a63          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	479c                	lw	a5,8(a5)
    8000529c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529e:	4709                	li	a4,2
    800052a0:	0ce79363          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	47d8                	lw	a4,12(a5)
    800052aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ac:	554d47b7          	lui	a5,0x554d4
    800052b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b4:	0af71963          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	4705                	li	a4,1
    800052be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c0:	470d                	li	a4,3
    800052c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052c6:	c7ffe737          	lui	a4,0xc7ffe
    800052ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052d0:	2701                	sext.w	a4,a4
    800052d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	472d                	li	a4,11
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	473d                	li	a4,15
    800052da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052dc:	6705                	lui	a4,0x1
    800052de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e4:	5bdc                	lw	a5,52(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e8:	c7d9                	beqz	a5,80005376 <virtio_disk_init+0x124>
  if(max < NUM)
    800052ea:	471d                	li	a4,7
    800052ec:	08f77d63          	bgeu	a4,a5,80005386 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052f0:	100014b7          	lui	s1,0x10001
    800052f4:	47a1                	li	a5,8
    800052f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f8:	6609                	lui	a2,0x2
    800052fa:	4581                	li	a1,0
    800052fc:	00016517          	auipc	a0,0x16
    80005300:	d0450513          	addi	a0,a0,-764 # 8001b000 <disk>
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	ec6080e7          	jalr	-314(ra) # 800001ca <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000530c:	00016717          	auipc	a4,0x16
    80005310:	cf470713          	addi	a4,a4,-780 # 8001b000 <disk>
    80005314:	00c75793          	srli	a5,a4,0xc
    80005318:	2781                	sext.w	a5,a5
    8000531a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000531c:	00018797          	auipc	a5,0x18
    80005320:	ce478793          	addi	a5,a5,-796 # 8001d000 <disk+0x2000>
    80005324:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005326:	00016717          	auipc	a4,0x16
    8000532a:	d5a70713          	addi	a4,a4,-678 # 8001b080 <disk+0x80>
    8000532e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005330:	00017717          	auipc	a4,0x17
    80005334:	cd070713          	addi	a4,a4,-816 # 8001c000 <disk+0x1000>
    80005338:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000533a:	4705                	li	a4,1
    8000533c:	00e78c23          	sb	a4,24(a5)
    80005340:	00e78ca3          	sb	a4,25(a5)
    80005344:	00e78d23          	sb	a4,26(a5)
    80005348:	00e78da3          	sb	a4,27(a5)
    8000534c:	00e78e23          	sb	a4,28(a5)
    80005350:	00e78ea3          	sb	a4,29(a5)
    80005354:	00e78f23          	sb	a4,30(a5)
    80005358:	00e78fa3          	sb	a4,31(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret
    panic("could not find virtio disk");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	54a50513          	addi	a0,a0,1354 # 800088b0 <syscalls_name+0x358>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	8ea080e7          	jalr	-1814(ra) # 80005c58 <panic>
    panic("virtio disk has no queue 0");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	55a50513          	addi	a0,a0,1370 # 800088d0 <syscalls_name+0x378>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8da080e7          	jalr	-1830(ra) # 80005c58 <panic>
    panic("virtio disk max queue too short");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	56a50513          	addi	a0,a0,1386 # 800088f0 <syscalls_name+0x398>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8ca080e7          	jalr	-1846(ra) # 80005c58 <panic>

0000000080005396 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005396:	7159                	addi	sp,sp,-112
    80005398:	f486                	sd	ra,104(sp)
    8000539a:	f0a2                	sd	s0,96(sp)
    8000539c:	eca6                	sd	s1,88(sp)
    8000539e:	e8ca                	sd	s2,80(sp)
    800053a0:	e4ce                	sd	s3,72(sp)
    800053a2:	e0d2                	sd	s4,64(sp)
    800053a4:	fc56                	sd	s5,56(sp)
    800053a6:	f85a                	sd	s6,48(sp)
    800053a8:	f45e                	sd	s7,40(sp)
    800053aa:	f062                	sd	s8,32(sp)
    800053ac:	ec66                	sd	s9,24(sp)
    800053ae:	e86a                	sd	s10,16(sp)
    800053b0:	1880                	addi	s0,sp,112
    800053b2:	892a                	mv	s2,a0
    800053b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b6:	00c52c83          	lw	s9,12(a0)
    800053ba:	001c9c9b          	slliw	s9,s9,0x1
    800053be:	1c82                	slli	s9,s9,0x20
    800053c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c4:	00018517          	auipc	a0,0x18
    800053c8:	d6450513          	addi	a0,a0,-668 # 8001d128 <disk+0x2128>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	dd6080e7          	jalr	-554(ra) # 800061a2 <acquire>
  for(int i = 0; i < 3; i++){
    800053d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053d8:	00016b97          	auipc	s7,0x16
    800053dc:	c28b8b93          	addi	s7,s7,-984 # 8001b000 <disk>
    800053e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053e4:	8a4e                	mv	s4,s3
    800053e6:	a051                	j	8000546a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053e8:	00fb86b3          	add	a3,s7,a5
    800053ec:	96da                	add	a3,a3,s6
    800053ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053f4:	0207c563          	bltz	a5,8000541e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053f8:	2485                	addiw	s1,s1,1
    800053fa:	0711                	addi	a4,a4,4
    800053fc:	25548063          	beq	s1,s5,8000563c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005400:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005402:	00018697          	auipc	a3,0x18
    80005406:	c1668693          	addi	a3,a3,-1002 # 8001d018 <disk+0x2018>
    8000540a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000540c:	0006c583          	lbu	a1,0(a3)
    80005410:	fde1                	bnez	a1,800053e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005412:	2785                	addiw	a5,a5,1
    80005414:	0685                	addi	a3,a3,1
    80005416:	ff879be3          	bne	a5,s8,8000540c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000541a:	57fd                	li	a5,-1
    8000541c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000541e:	02905a63          	blez	s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005422:	f9042503          	lw	a0,-112(s0)
    80005426:	00000097          	auipc	ra,0x0
    8000542a:	d90080e7          	jalr	-624(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000542e:	4785                	li	a5,1
    80005430:	0297d163          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005434:	f9442503          	lw	a0,-108(s0)
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	d7e080e7          	jalr	-642(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005440:	4789                	li	a5,2
    80005442:	0097d863          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005446:	f9842503          	lw	a0,-104(s0)
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	d6c080e7          	jalr	-660(ra) # 800051b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005452:	00018597          	auipc	a1,0x18
    80005456:	cd658593          	addi	a1,a1,-810 # 8001d128 <disk+0x2128>
    8000545a:	00018517          	auipc	a0,0x18
    8000545e:	bbe50513          	addi	a0,a0,-1090 # 8001d018 <disk+0x2018>
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	0fc080e7          	jalr	252(ra) # 8000155e <sleep>
  for(int i = 0; i < 3; i++){
    8000546a:	f9040713          	addi	a4,s0,-112
    8000546e:	84ce                	mv	s1,s3
    80005470:	bf41                	j	80005400 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005472:	20058713          	addi	a4,a1,512
    80005476:	00471693          	slli	a3,a4,0x4
    8000547a:	00016717          	auipc	a4,0x16
    8000547e:	b8670713          	addi	a4,a4,-1146 # 8001b000 <disk>
    80005482:	9736                	add	a4,a4,a3
    80005484:	4685                	li	a3,1
    80005486:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000548a:	20058713          	addi	a4,a1,512
    8000548e:	00471693          	slli	a3,a4,0x4
    80005492:	00016717          	auipc	a4,0x16
    80005496:	b6e70713          	addi	a4,a4,-1170 # 8001b000 <disk>
    8000549a:	9736                	add	a4,a4,a3
    8000549c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054a4:	7679                	lui	a2,0xffffe
    800054a6:	963e                	add	a2,a2,a5
    800054a8:	00018697          	auipc	a3,0x18
    800054ac:	b5868693          	addi	a3,a3,-1192 # 8001d000 <disk+0x2000>
    800054b0:	6298                	ld	a4,0(a3)
    800054b2:	9732                	add	a4,a4,a2
    800054b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054b6:	6298                	ld	a4,0(a3)
    800054b8:	9732                	add	a4,a4,a2
    800054ba:	4541                	li	a0,16
    800054bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054be:	6298                	ld	a4,0(a3)
    800054c0:	9732                	add	a4,a4,a2
    800054c2:	4505                	li	a0,1
    800054c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054c8:	f9442703          	lw	a4,-108(s0)
    800054cc:	6288                	ld	a0,0(a3)
    800054ce:	962a                	add	a2,a2,a0
    800054d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054d4:	0712                	slli	a4,a4,0x4
    800054d6:	6290                	ld	a2,0(a3)
    800054d8:	963a                	add	a2,a2,a4
    800054da:	05890513          	addi	a0,s2,88
    800054de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054e0:	6294                	ld	a3,0(a3)
    800054e2:	96ba                	add	a3,a3,a4
    800054e4:	40000613          	li	a2,1024
    800054e8:	c690                	sw	a2,8(a3)
  if(write)
    800054ea:	140d0063          	beqz	s10,8000562a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054ee:	00018697          	auipc	a3,0x18
    800054f2:	b126b683          	ld	a3,-1262(a3) # 8001d000 <disk+0x2000>
    800054f6:	96ba                	add	a3,a3,a4
    800054f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054fc:	00016817          	auipc	a6,0x16
    80005500:	b0480813          	addi	a6,a6,-1276 # 8001b000 <disk>
    80005504:	00018517          	auipc	a0,0x18
    80005508:	afc50513          	addi	a0,a0,-1284 # 8001d000 <disk+0x2000>
    8000550c:	6114                	ld	a3,0(a0)
    8000550e:	96ba                	add	a3,a3,a4
    80005510:	00c6d603          	lhu	a2,12(a3)
    80005514:	00166613          	ori	a2,a2,1
    80005518:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000551c:	f9842683          	lw	a3,-104(s0)
    80005520:	6110                	ld	a2,0(a0)
    80005522:	9732                	add	a4,a4,a2
    80005524:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005528:	20058613          	addi	a2,a1,512
    8000552c:	0612                	slli	a2,a2,0x4
    8000552e:	9642                	add	a2,a2,a6
    80005530:	577d                	li	a4,-1
    80005532:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005536:	00469713          	slli	a4,a3,0x4
    8000553a:	6114                	ld	a3,0(a0)
    8000553c:	96ba                	add	a3,a3,a4
    8000553e:	03078793          	addi	a5,a5,48
    80005542:	97c2                	add	a5,a5,a6
    80005544:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005546:	611c                	ld	a5,0(a0)
    80005548:	97ba                	add	a5,a5,a4
    8000554a:	4685                	li	a3,1
    8000554c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000554e:	611c                	ld	a5,0(a0)
    80005550:	97ba                	add	a5,a5,a4
    80005552:	4809                	li	a6,2
    80005554:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005558:	611c                	ld	a5,0(a0)
    8000555a:	973e                	add	a4,a4,a5
    8000555c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005560:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005564:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005568:	6518                	ld	a4,8(a0)
    8000556a:	00275783          	lhu	a5,2(a4)
    8000556e:	8b9d                	andi	a5,a5,7
    80005570:	0786                	slli	a5,a5,0x1
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005578:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000557c:	6518                	ld	a4,8(a0)
    8000557e:	00275783          	lhu	a5,2(a4)
    80005582:	2785                	addiw	a5,a5,1
    80005584:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005588:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000558c:	100017b7          	lui	a5,0x10001
    80005590:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005594:	00492703          	lw	a4,4(s2)
    80005598:	4785                	li	a5,1
    8000559a:	02f71163          	bne	a4,a5,800055bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000559e:	00018997          	auipc	s3,0x18
    800055a2:	b8a98993          	addi	s3,s3,-1142 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055a8:	85ce                	mv	a1,s3
    800055aa:	854a                	mv	a0,s2
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	fb2080e7          	jalr	-78(ra) # 8000155e <sleep>
  while(b->disk == 1) {
    800055b4:	00492783          	lw	a5,4(s2)
    800055b8:	fe9788e3          	beq	a5,s1,800055a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055bc:	f9042903          	lw	s2,-112(s0)
    800055c0:	20090793          	addi	a5,s2,512
    800055c4:	00479713          	slli	a4,a5,0x4
    800055c8:	00016797          	auipc	a5,0x16
    800055cc:	a3878793          	addi	a5,a5,-1480 # 8001b000 <disk>
    800055d0:	97ba                	add	a5,a5,a4
    800055d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055d6:	00018997          	auipc	s3,0x18
    800055da:	a2a98993          	addi	s3,s3,-1494 # 8001d000 <disk+0x2000>
    800055de:	00491713          	slli	a4,s2,0x4
    800055e2:	0009b783          	ld	a5,0(s3)
    800055e6:	97ba                	add	a5,a5,a4
    800055e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055ec:	854a                	mv	a0,s2
    800055ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f2:	00000097          	auipc	ra,0x0
    800055f6:	bc4080e7          	jalr	-1084(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055fa:	8885                	andi	s1,s1,1
    800055fc:	f0ed                	bnez	s1,800055de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055fe:	00018517          	auipc	a0,0x18
    80005602:	b2a50513          	addi	a0,a0,-1238 # 8001d128 <disk+0x2128>
    80005606:	00001097          	auipc	ra,0x1
    8000560a:	c50080e7          	jalr	-944(ra) # 80006256 <release>
}
    8000560e:	70a6                	ld	ra,104(sp)
    80005610:	7406                	ld	s0,96(sp)
    80005612:	64e6                	ld	s1,88(sp)
    80005614:	6946                	ld	s2,80(sp)
    80005616:	69a6                	ld	s3,72(sp)
    80005618:	6a06                	ld	s4,64(sp)
    8000561a:	7ae2                	ld	s5,56(sp)
    8000561c:	7b42                	ld	s6,48(sp)
    8000561e:	7ba2                	ld	s7,40(sp)
    80005620:	7c02                	ld	s8,32(sp)
    80005622:	6ce2                	ld	s9,24(sp)
    80005624:	6d42                	ld	s10,16(sp)
    80005626:	6165                	addi	sp,sp,112
    80005628:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000562a:	00018697          	auipc	a3,0x18
    8000562e:	9d66b683          	ld	a3,-1578(a3) # 8001d000 <disk+0x2000>
    80005632:	96ba                	add	a3,a3,a4
    80005634:	4609                	li	a2,2
    80005636:	00c69623          	sh	a2,12(a3)
    8000563a:	b5c9                	j	800054fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000563c:	f9042583          	lw	a1,-112(s0)
    80005640:	20058793          	addi	a5,a1,512
    80005644:	0792                	slli	a5,a5,0x4
    80005646:	00016517          	auipc	a0,0x16
    8000564a:	a6250513          	addi	a0,a0,-1438 # 8001b0a8 <disk+0xa8>
    8000564e:	953e                	add	a0,a0,a5
  if(write)
    80005650:	e20d11e3          	bnez	s10,80005472 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005654:	20058713          	addi	a4,a1,512
    80005658:	00471693          	slli	a3,a4,0x4
    8000565c:	00016717          	auipc	a4,0x16
    80005660:	9a470713          	addi	a4,a4,-1628 # 8001b000 <disk>
    80005664:	9736                	add	a4,a4,a3
    80005666:	0a072423          	sw	zero,168(a4)
    8000566a:	b505                	j	8000548a <virtio_disk_rw+0xf4>

000000008000566c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000566c:	1101                	addi	sp,sp,-32
    8000566e:	ec06                	sd	ra,24(sp)
    80005670:	e822                	sd	s0,16(sp)
    80005672:	e426                	sd	s1,8(sp)
    80005674:	e04a                	sd	s2,0(sp)
    80005676:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005678:	00018517          	auipc	a0,0x18
    8000567c:	ab050513          	addi	a0,a0,-1360 # 8001d128 <disk+0x2128>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	b22080e7          	jalr	-1246(ra) # 800061a2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005688:	10001737          	lui	a4,0x10001
    8000568c:	533c                	lw	a5,96(a4)
    8000568e:	8b8d                	andi	a5,a5,3
    80005690:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005692:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005696:	00018797          	auipc	a5,0x18
    8000569a:	96a78793          	addi	a5,a5,-1686 # 8001d000 <disk+0x2000>
    8000569e:	6b94                	ld	a3,16(a5)
    800056a0:	0207d703          	lhu	a4,32(a5)
    800056a4:	0026d783          	lhu	a5,2(a3)
    800056a8:	06f70163          	beq	a4,a5,8000570a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ac:	00016917          	auipc	s2,0x16
    800056b0:	95490913          	addi	s2,s2,-1708 # 8001b000 <disk>
    800056b4:	00018497          	auipc	s1,0x18
    800056b8:	94c48493          	addi	s1,s1,-1716 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c0:	6898                	ld	a4,16(s1)
    800056c2:	0204d783          	lhu	a5,32(s1)
    800056c6:	8b9d                	andi	a5,a5,7
    800056c8:	078e                	slli	a5,a5,0x3
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ce:	20078713          	addi	a4,a5,512
    800056d2:	0712                	slli	a4,a4,0x4
    800056d4:	974a                	add	a4,a4,s2
    800056d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056da:	e731                	bnez	a4,80005726 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056dc:	20078793          	addi	a5,a5,512
    800056e0:	0792                	slli	a5,a5,0x4
    800056e2:	97ca                	add	a5,a5,s2
    800056e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	000080e7          	jalr	ra # 800016ea <wakeup>

    disk.used_idx += 1;
    800056f2:	0204d783          	lhu	a5,32(s1)
    800056f6:	2785                	addiw	a5,a5,1
    800056f8:	17c2                	slli	a5,a5,0x30
    800056fa:	93c1                	srli	a5,a5,0x30
    800056fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005700:	6898                	ld	a4,16(s1)
    80005702:	00275703          	lhu	a4,2(a4)
    80005706:	faf71be3          	bne	a4,a5,800056bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000570a:	00018517          	auipc	a0,0x18
    8000570e:	a1e50513          	addi	a0,a0,-1506 # 8001d128 <disk+0x2128>
    80005712:	00001097          	auipc	ra,0x1
    80005716:	b44080e7          	jalr	-1212(ra) # 80006256 <release>
}
    8000571a:	60e2                	ld	ra,24(sp)
    8000571c:	6442                	ld	s0,16(sp)
    8000571e:	64a2                	ld	s1,8(sp)
    80005720:	6902                	ld	s2,0(sp)
    80005722:	6105                	addi	sp,sp,32
    80005724:	8082                	ret
      panic("virtio_disk_intr status");
    80005726:	00003517          	auipc	a0,0x3
    8000572a:	1ea50513          	addi	a0,a0,490 # 80008910 <syscalls_name+0x3b8>
    8000572e:	00000097          	auipc	ra,0x0
    80005732:	52a080e7          	jalr	1322(ra) # 80005c58 <panic>

0000000080005736 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005736:	1141                	addi	sp,sp,-16
    80005738:	e422                	sd	s0,8(sp)
    8000573a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005740:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005744:	0037979b          	slliw	a5,a5,0x3
    80005748:	02004737          	lui	a4,0x2004
    8000574c:	97ba                	add	a5,a5,a4
    8000574e:	0200c737          	lui	a4,0x200c
    80005752:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005756:	000f4637          	lui	a2,0xf4
    8000575a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000575e:	95b2                	add	a1,a1,a2
    80005760:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005762:	00269713          	slli	a4,a3,0x2
    80005766:	9736                	add	a4,a4,a3
    80005768:	00371693          	slli	a3,a4,0x3
    8000576c:	00019717          	auipc	a4,0x19
    80005770:	89470713          	addi	a4,a4,-1900 # 8001e000 <timer_scratch>
    80005774:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005776:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005778:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000577a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000577e:	00000797          	auipc	a5,0x0
    80005782:	97278793          	addi	a5,a5,-1678 # 800050f0 <timervec>
    80005786:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000578e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005792:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005796:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000579e:	30479073          	csrw	mie,a5
}
    800057a2:	6422                	ld	s0,8(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <start>:
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b4:	7779                	lui	a4,0xffffe
    800057b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057bc:	6705                	lui	a4,0x1
    800057be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057c8:	ffffb797          	auipc	a5,0xffffb
    800057cc:	bb078793          	addi	a5,a5,-1104 # 80000378 <main>
    800057d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d4:	4781                	li	a5,0
    800057d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057da:	67c1                	lui	a5,0x10
    800057dc:	17fd                	addi	a5,a5,-1
    800057de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f2:	57fd                	li	a5,-1
    800057f4:	83a9                	srli	a5,a5,0xa
    800057f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057fa:	47bd                	li	a5,15
    800057fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005800:	00000097          	auipc	ra,0x0
    80005804:	f36080e7          	jalr	-202(ra) # 80005736 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005808:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000580e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005810:	30200073          	mret
}
    80005814:	60a2                	ld	ra,8(sp)
    80005816:	6402                	ld	s0,0(sp)
    80005818:	0141                	addi	sp,sp,16
    8000581a:	8082                	ret

000000008000581c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581c:	715d                	addi	sp,sp,-80
    8000581e:	e486                	sd	ra,72(sp)
    80005820:	e0a2                	sd	s0,64(sp)
    80005822:	fc26                	sd	s1,56(sp)
    80005824:	f84a                	sd	s2,48(sp)
    80005826:	f44e                	sd	s3,40(sp)
    80005828:	f052                	sd	s4,32(sp)
    8000582a:	ec56                	sd	s5,24(sp)
    8000582c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000582e:	04c05663          	blez	a2,8000587a <consolewrite+0x5e>
    80005832:	8a2a                	mv	s4,a0
    80005834:	84ae                	mv	s1,a1
    80005836:	89b2                	mv	s3,a2
    80005838:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583a:	5afd                	li	s5,-1
    8000583c:	4685                	li	a3,1
    8000583e:	8626                	mv	a2,s1
    80005840:	85d2                	mv	a1,s4
    80005842:	fbf40513          	addi	a0,s0,-65
    80005846:	ffffc097          	auipc	ra,0xffffc
    8000584a:	112080e7          	jalr	274(ra) # 80001958 <either_copyin>
    8000584e:	01550c63          	beq	a0,s5,80005866 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005852:	fbf44503          	lbu	a0,-65(s0)
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	78e080e7          	jalr	1934(ra) # 80005fe4 <uartputc>
  for(i = 0; i < n; i++){
    8000585e:	2905                	addiw	s2,s2,1
    80005860:	0485                	addi	s1,s1,1
    80005862:	fd299de3          	bne	s3,s2,8000583c <consolewrite+0x20>
  }

  return i;
}
    80005866:	854a                	mv	a0,s2
    80005868:	60a6                	ld	ra,72(sp)
    8000586a:	6406                	ld	s0,64(sp)
    8000586c:	74e2                	ld	s1,56(sp)
    8000586e:	7942                	ld	s2,48(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6ae2                	ld	s5,24(sp)
    80005876:	6161                	addi	sp,sp,80
    80005878:	8082                	ret
  for(i = 0; i < n; i++){
    8000587a:	4901                	li	s2,0
    8000587c:	b7ed                	j	80005866 <consolewrite+0x4a>

000000008000587e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000587e:	7119                	addi	sp,sp,-128
    80005880:	fc86                	sd	ra,120(sp)
    80005882:	f8a2                	sd	s0,112(sp)
    80005884:	f4a6                	sd	s1,104(sp)
    80005886:	f0ca                	sd	s2,96(sp)
    80005888:	ecce                	sd	s3,88(sp)
    8000588a:	e8d2                	sd	s4,80(sp)
    8000588c:	e4d6                	sd	s5,72(sp)
    8000588e:	e0da                	sd	s6,64(sp)
    80005890:	fc5e                	sd	s7,56(sp)
    80005892:	f862                	sd	s8,48(sp)
    80005894:	f466                	sd	s9,40(sp)
    80005896:	f06a                	sd	s10,32(sp)
    80005898:	ec6e                	sd	s11,24(sp)
    8000589a:	0100                	addi	s0,sp,128
    8000589c:	8b2a                	mv	s6,a0
    8000589e:	8aae                	mv	s5,a1
    800058a0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058a6:	00021517          	auipc	a0,0x21
    800058aa:	89a50513          	addi	a0,a0,-1894 # 80026140 <cons>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	8f4080e7          	jalr	-1804(ra) # 800061a2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058b6:	00021497          	auipc	s1,0x21
    800058ba:	88a48493          	addi	s1,s1,-1910 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058be:	89a6                	mv	s3,s1
    800058c0:	00021917          	auipc	s2,0x21
    800058c4:	91890913          	addi	s2,s2,-1768 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058c8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ca:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058cc:	4da9                	li	s11,10
  while(n > 0){
    800058ce:	07405863          	blez	s4,8000593e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058d2:	0984a783          	lw	a5,152(s1)
    800058d6:	09c4a703          	lw	a4,156(s1)
    800058da:	02f71463          	bne	a4,a5,80005902 <consoleread+0x84>
      if(myproc()->killed){
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	5bc080e7          	jalr	1468(ra) # 80000e9a <myproc>
    800058e6:	551c                	lw	a5,40(a0)
    800058e8:	e7b5                	bnez	a5,80005954 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058ea:	85ce                	mv	a1,s3
    800058ec:	854a                	mv	a0,s2
    800058ee:	ffffc097          	auipc	ra,0xffffc
    800058f2:	c70080e7          	jalr	-912(ra) # 8000155e <sleep>
    while(cons.r == cons.w){
    800058f6:	0984a783          	lw	a5,152(s1)
    800058fa:	09c4a703          	lw	a4,156(s1)
    800058fe:	fef700e3          	beq	a4,a5,800058de <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005902:	0017871b          	addiw	a4,a5,1
    80005906:	08e4ac23          	sw	a4,152(s1)
    8000590a:	07f7f713          	andi	a4,a5,127
    8000590e:	9726                	add	a4,a4,s1
    80005910:	01874703          	lbu	a4,24(a4)
    80005914:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005918:	079c0663          	beq	s8,s9,80005984 <consoleread+0x106>
    cbuf = c;
    8000591c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005920:	4685                	li	a3,1
    80005922:	f8f40613          	addi	a2,s0,-113
    80005926:	85d6                	mv	a1,s5
    80005928:	855a                	mv	a0,s6
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	fd8080e7          	jalr	-40(ra) # 80001902 <either_copyout>
    80005932:	01a50663          	beq	a0,s10,8000593e <consoleread+0xc0>
    dst++;
    80005936:	0a85                	addi	s5,s5,1
    --n;
    80005938:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000593a:	f9bc1ae3          	bne	s8,s11,800058ce <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000593e:	00021517          	auipc	a0,0x21
    80005942:	80250513          	addi	a0,a0,-2046 # 80026140 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	910080e7          	jalr	-1776(ra) # 80006256 <release>

  return target - n;
    8000594e:	414b853b          	subw	a0,s7,s4
    80005952:	a811                	j	80005966 <consoleread+0xe8>
        release(&cons.lock);
    80005954:	00020517          	auipc	a0,0x20
    80005958:	7ec50513          	addi	a0,a0,2028 # 80026140 <cons>
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	8fa080e7          	jalr	-1798(ra) # 80006256 <release>
        return -1;
    80005964:	557d                	li	a0,-1
}
    80005966:	70e6                	ld	ra,120(sp)
    80005968:	7446                	ld	s0,112(sp)
    8000596a:	74a6                	ld	s1,104(sp)
    8000596c:	7906                	ld	s2,96(sp)
    8000596e:	69e6                	ld	s3,88(sp)
    80005970:	6a46                	ld	s4,80(sp)
    80005972:	6aa6                	ld	s5,72(sp)
    80005974:	6b06                	ld	s6,64(sp)
    80005976:	7be2                	ld	s7,56(sp)
    80005978:	7c42                	ld	s8,48(sp)
    8000597a:	7ca2                	ld	s9,40(sp)
    8000597c:	7d02                	ld	s10,32(sp)
    8000597e:	6de2                	ld	s11,24(sp)
    80005980:	6109                	addi	sp,sp,128
    80005982:	8082                	ret
      if(n < target){
    80005984:	000a071b          	sext.w	a4,s4
    80005988:	fb777be3          	bgeu	a4,s7,8000593e <consoleread+0xc0>
        cons.r--;
    8000598c:	00021717          	auipc	a4,0x21
    80005990:	84f72623          	sw	a5,-1972(a4) # 800261d8 <cons+0x98>
    80005994:	b76d                	j	8000593e <consoleread+0xc0>

0000000080005996 <consputc>:
{
    80005996:	1141                	addi	sp,sp,-16
    80005998:	e406                	sd	ra,8(sp)
    8000599a:	e022                	sd	s0,0(sp)
    8000599c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000599e:	10000793          	li	a5,256
    800059a2:	00f50a63          	beq	a0,a5,800059b6 <consputc+0x20>
    uartputc_sync(c);
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	564080e7          	jalr	1380(ra) # 80005f0a <uartputc_sync>
}
    800059ae:	60a2                	ld	ra,8(sp)
    800059b0:	6402                	ld	s0,0(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059b6:	4521                	li	a0,8
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	552080e7          	jalr	1362(ra) # 80005f0a <uartputc_sync>
    800059c0:	02000513          	li	a0,32
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	546080e7          	jalr	1350(ra) # 80005f0a <uartputc_sync>
    800059cc:	4521                	li	a0,8
    800059ce:	00000097          	auipc	ra,0x0
    800059d2:	53c080e7          	jalr	1340(ra) # 80005f0a <uartputc_sync>
    800059d6:	bfe1                	j	800059ae <consputc+0x18>

00000000800059d8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059d8:	1101                	addi	sp,sp,-32
    800059da:	ec06                	sd	ra,24(sp)
    800059dc:	e822                	sd	s0,16(sp)
    800059de:	e426                	sd	s1,8(sp)
    800059e0:	e04a                	sd	s2,0(sp)
    800059e2:	1000                	addi	s0,sp,32
    800059e4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059e6:	00020517          	auipc	a0,0x20
    800059ea:	75a50513          	addi	a0,a0,1882 # 80026140 <cons>
    800059ee:	00000097          	auipc	ra,0x0
    800059f2:	7b4080e7          	jalr	1972(ra) # 800061a2 <acquire>

  switch(c){
    800059f6:	47d5                	li	a5,21
    800059f8:	0af48663          	beq	s1,a5,80005aa4 <consoleintr+0xcc>
    800059fc:	0297ca63          	blt	a5,s1,80005a30 <consoleintr+0x58>
    80005a00:	47a1                	li	a5,8
    80005a02:	0ef48763          	beq	s1,a5,80005af0 <consoleintr+0x118>
    80005a06:	47c1                	li	a5,16
    80005a08:	10f49a63          	bne	s1,a5,80005b1c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a0c:	ffffc097          	auipc	ra,0xffffc
    80005a10:	fa2080e7          	jalr	-94(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a14:	00020517          	auipc	a0,0x20
    80005a18:	72c50513          	addi	a0,a0,1836 # 80026140 <cons>
    80005a1c:	00001097          	auipc	ra,0x1
    80005a20:	83a080e7          	jalr	-1990(ra) # 80006256 <release>
}
    80005a24:	60e2                	ld	ra,24(sp)
    80005a26:	6442                	ld	s0,16(sp)
    80005a28:	64a2                	ld	s1,8(sp)
    80005a2a:	6902                	ld	s2,0(sp)
    80005a2c:	6105                	addi	sp,sp,32
    80005a2e:	8082                	ret
  switch(c){
    80005a30:	07f00793          	li	a5,127
    80005a34:	0af48e63          	beq	s1,a5,80005af0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a38:	00020717          	auipc	a4,0x20
    80005a3c:	70870713          	addi	a4,a4,1800 # 80026140 <cons>
    80005a40:	0a072783          	lw	a5,160(a4)
    80005a44:	09872703          	lw	a4,152(a4)
    80005a48:	9f99                	subw	a5,a5,a4
    80005a4a:	07f00713          	li	a4,127
    80005a4e:	fcf763e3          	bltu	a4,a5,80005a14 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a52:	47b5                	li	a5,13
    80005a54:	0cf48763          	beq	s1,a5,80005b22 <consoleintr+0x14a>
      consputc(c);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	f3c080e7          	jalr	-196(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a62:	00020797          	auipc	a5,0x20
    80005a66:	6de78793          	addi	a5,a5,1758 # 80026140 <cons>
    80005a6a:	0a07a703          	lw	a4,160(a5)
    80005a6e:	0017069b          	addiw	a3,a4,1
    80005a72:	0006861b          	sext.w	a2,a3
    80005a76:	0ad7a023          	sw	a3,160(a5)
    80005a7a:	07f77713          	andi	a4,a4,127
    80005a7e:	97ba                	add	a5,a5,a4
    80005a80:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a84:	47a9                	li	a5,10
    80005a86:	0cf48563          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a8a:	4791                	li	a5,4
    80005a8c:	0cf48263          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a90:	00020797          	auipc	a5,0x20
    80005a94:	7487a783          	lw	a5,1864(a5) # 800261d8 <cons+0x98>
    80005a98:	0807879b          	addiw	a5,a5,128
    80005a9c:	f6f61ce3          	bne	a2,a5,80005a14 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa0:	863e                	mv	a2,a5
    80005aa2:	a07d                	j	80005b50 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aa4:	00020717          	auipc	a4,0x20
    80005aa8:	69c70713          	addi	a4,a4,1692 # 80026140 <cons>
    80005aac:	0a072783          	lw	a5,160(a4)
    80005ab0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab4:	00020497          	auipc	s1,0x20
    80005ab8:	68c48493          	addi	s1,s1,1676 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005abc:	4929                	li	s2,10
    80005abe:	f4f70be3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac2:	37fd                	addiw	a5,a5,-1
    80005ac4:	07f7f713          	andi	a4,a5,127
    80005ac8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aca:	01874703          	lbu	a4,24(a4)
    80005ace:	f52703e3          	beq	a4,s2,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005ad2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ad6:	10000513          	li	a0,256
    80005ada:	00000097          	auipc	ra,0x0
    80005ade:	ebc080e7          	jalr	-324(ra) # 80005996 <consputc>
    while(cons.e != cons.w &&
    80005ae2:	0a04a783          	lw	a5,160(s1)
    80005ae6:	09c4a703          	lw	a4,156(s1)
    80005aea:	fcf71ce3          	bne	a4,a5,80005ac2 <consoleintr+0xea>
    80005aee:	b71d                	j	80005a14 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af0:	00020717          	auipc	a4,0x20
    80005af4:	65070713          	addi	a4,a4,1616 # 80026140 <cons>
    80005af8:	0a072783          	lw	a5,160(a4)
    80005afc:	09c72703          	lw	a4,156(a4)
    80005b00:	f0f70ae3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005b04:	37fd                	addiw	a5,a5,-1
    80005b06:	00020717          	auipc	a4,0x20
    80005b0a:	6cf72d23          	sw	a5,1754(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0e:	10000513          	li	a0,256
    80005b12:	00000097          	auipc	ra,0x0
    80005b16:	e84080e7          	jalr	-380(ra) # 80005996 <consputc>
    80005b1a:	bded                	j	80005a14 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b1c:	ee048ce3          	beqz	s1,80005a14 <consoleintr+0x3c>
    80005b20:	bf21                	j	80005a38 <consoleintr+0x60>
      consputc(c);
    80005b22:	4529                	li	a0,10
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	e72080e7          	jalr	-398(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b2c:	00020797          	auipc	a5,0x20
    80005b30:	61478793          	addi	a5,a5,1556 # 80026140 <cons>
    80005b34:	0a07a703          	lw	a4,160(a5)
    80005b38:	0017069b          	addiw	a3,a4,1
    80005b3c:	0006861b          	sext.w	a2,a3
    80005b40:	0ad7a023          	sw	a3,160(a5)
    80005b44:	07f77713          	andi	a4,a4,127
    80005b48:	97ba                	add	a5,a5,a4
    80005b4a:	4729                	li	a4,10
    80005b4c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b50:	00020797          	auipc	a5,0x20
    80005b54:	68c7a623          	sw	a2,1676(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b58:	00020517          	auipc	a0,0x20
    80005b5c:	68050513          	addi	a0,a0,1664 # 800261d8 <cons+0x98>
    80005b60:	ffffc097          	auipc	ra,0xffffc
    80005b64:	b8a080e7          	jalr	-1142(ra) # 800016ea <wakeup>
    80005b68:	b575                	j	80005a14 <consoleintr+0x3c>

0000000080005b6a <consoleinit>:

void
consoleinit(void)
{
    80005b6a:	1141                	addi	sp,sp,-16
    80005b6c:	e406                	sd	ra,8(sp)
    80005b6e:	e022                	sd	s0,0(sp)
    80005b70:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b72:	00003597          	auipc	a1,0x3
    80005b76:	db658593          	addi	a1,a1,-586 # 80008928 <syscalls_name+0x3d0>
    80005b7a:	00020517          	auipc	a0,0x20
    80005b7e:	5c650513          	addi	a0,a0,1478 # 80026140 <cons>
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	590080e7          	jalr	1424(ra) # 80006112 <initlock>

  uartinit();
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	330080e7          	jalr	816(ra) # 80005eba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b92:	00013797          	auipc	a5,0x13
    80005b96:	53678793          	addi	a5,a5,1334 # 800190c8 <devsw>
    80005b9a:	00000717          	auipc	a4,0x0
    80005b9e:	ce470713          	addi	a4,a4,-796 # 8000587e <consoleread>
    80005ba2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ba4:	00000717          	auipc	a4,0x0
    80005ba8:	c7870713          	addi	a4,a4,-904 # 8000581c <consolewrite>
    80005bac:	ef98                	sd	a4,24(a5)
}
    80005bae:	60a2                	ld	ra,8(sp)
    80005bb0:	6402                	ld	s0,0(sp)
    80005bb2:	0141                	addi	sp,sp,16
    80005bb4:	8082                	ret

0000000080005bb6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb6:	7179                	addi	sp,sp,-48
    80005bb8:	f406                	sd	ra,40(sp)
    80005bba:	f022                	sd	s0,32(sp)
    80005bbc:	ec26                	sd	s1,24(sp)
    80005bbe:	e84a                	sd	s2,16(sp)
    80005bc0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bc2:	c219                	beqz	a2,80005bc8 <printint+0x12>
    80005bc4:	08054663          	bltz	a0,80005c50 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bc8:	2501                	sext.w	a0,a0
    80005bca:	4881                	li	a7,0
    80005bcc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bd2:	2581                	sext.w	a1,a1
    80005bd4:	00003617          	auipc	a2,0x3
    80005bd8:	d8460613          	addi	a2,a2,-636 # 80008958 <digits>
    80005bdc:	883a                	mv	a6,a4
    80005bde:	2705                	addiw	a4,a4,1
    80005be0:	02b577bb          	remuw	a5,a0,a1
    80005be4:	1782                	slli	a5,a5,0x20
    80005be6:	9381                	srli	a5,a5,0x20
    80005be8:	97b2                	add	a5,a5,a2
    80005bea:	0007c783          	lbu	a5,0(a5)
    80005bee:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bf2:	0005079b          	sext.w	a5,a0
    80005bf6:	02b5553b          	divuw	a0,a0,a1
    80005bfa:	0685                	addi	a3,a3,1
    80005bfc:	feb7f0e3          	bgeu	a5,a1,80005bdc <printint+0x26>

  if(sign)
    80005c00:	00088b63          	beqz	a7,80005c16 <printint+0x60>
    buf[i++] = '-';
    80005c04:	fe040793          	addi	a5,s0,-32
    80005c08:	973e                	add	a4,a4,a5
    80005c0a:	02d00793          	li	a5,45
    80005c0e:	fef70823          	sb	a5,-16(a4)
    80005c12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c16:	02e05763          	blez	a4,80005c44 <printint+0x8e>
    80005c1a:	fd040793          	addi	a5,s0,-48
    80005c1e:	00e784b3          	add	s1,a5,a4
    80005c22:	fff78913          	addi	s2,a5,-1
    80005c26:	993a                	add	s2,s2,a4
    80005c28:	377d                	addiw	a4,a4,-1
    80005c2a:	1702                	slli	a4,a4,0x20
    80005c2c:	9301                	srli	a4,a4,0x20
    80005c2e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c32:	fff4c503          	lbu	a0,-1(s1)
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	d60080e7          	jalr	-672(ra) # 80005996 <consputc>
  while(--i >= 0)
    80005c3e:	14fd                	addi	s1,s1,-1
    80005c40:	ff2499e3          	bne	s1,s2,80005c32 <printint+0x7c>
}
    80005c44:	70a2                	ld	ra,40(sp)
    80005c46:	7402                	ld	s0,32(sp)
    80005c48:	64e2                	ld	s1,24(sp)
    80005c4a:	6942                	ld	s2,16(sp)
    80005c4c:	6145                	addi	sp,sp,48
    80005c4e:	8082                	ret
    x = -xx;
    80005c50:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c54:	4885                	li	a7,1
    x = -xx;
    80005c56:	bf9d                	j	80005bcc <printint+0x16>

0000000080005c58 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c58:	1101                	addi	sp,sp,-32
    80005c5a:	ec06                	sd	ra,24(sp)
    80005c5c:	e822                	sd	s0,16(sp)
    80005c5e:	e426                	sd	s1,8(sp)
    80005c60:	1000                	addi	s0,sp,32
    80005c62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c64:	00020797          	auipc	a5,0x20
    80005c68:	5807ae23          	sw	zero,1436(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c6c:	00003517          	auipc	a0,0x3
    80005c70:	cc450513          	addi	a0,a0,-828 # 80008930 <syscalls_name+0x3d8>
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	02e080e7          	jalr	46(ra) # 80005ca2 <printf>
  printf(s);
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	024080e7          	jalr	36(ra) # 80005ca2 <printf>
  printf("\n");
    80005c86:	00002517          	auipc	a0,0x2
    80005c8a:	3c250513          	addi	a0,a0,962 # 80008048 <etext+0x48>
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	014080e7          	jalr	20(ra) # 80005ca2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c96:	4785                	li	a5,1
    80005c98:	00003717          	auipc	a4,0x3
    80005c9c:	38f72223          	sw	a5,900(a4) # 8000901c <panicked>
  for(;;)
    80005ca0:	a001                	j	80005ca0 <panic+0x48>

0000000080005ca2 <printf>:
{
    80005ca2:	7131                	addi	sp,sp,-192
    80005ca4:	fc86                	sd	ra,120(sp)
    80005ca6:	f8a2                	sd	s0,112(sp)
    80005ca8:	f4a6                	sd	s1,104(sp)
    80005caa:	f0ca                	sd	s2,96(sp)
    80005cac:	ecce                	sd	s3,88(sp)
    80005cae:	e8d2                	sd	s4,80(sp)
    80005cb0:	e4d6                	sd	s5,72(sp)
    80005cb2:	e0da                	sd	s6,64(sp)
    80005cb4:	fc5e                	sd	s7,56(sp)
    80005cb6:	f862                	sd	s8,48(sp)
    80005cb8:	f466                	sd	s9,40(sp)
    80005cba:	f06a                	sd	s10,32(sp)
    80005cbc:	ec6e                	sd	s11,24(sp)
    80005cbe:	0100                	addi	s0,sp,128
    80005cc0:	8a2a                	mv	s4,a0
    80005cc2:	e40c                	sd	a1,8(s0)
    80005cc4:	e810                	sd	a2,16(s0)
    80005cc6:	ec14                	sd	a3,24(s0)
    80005cc8:	f018                	sd	a4,32(s0)
    80005cca:	f41c                	sd	a5,40(s0)
    80005ccc:	03043823          	sd	a6,48(s0)
    80005cd0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cd4:	00020d97          	auipc	s11,0x20
    80005cd8:	52cdad83          	lw	s11,1324(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cdc:	020d9b63          	bnez	s11,80005d12 <printf+0x70>
  if (fmt == 0)
    80005ce0:	040a0263          	beqz	s4,80005d24 <printf+0x82>
  va_start(ap, fmt);
    80005ce4:	00840793          	addi	a5,s0,8
    80005ce8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cec:	000a4503          	lbu	a0,0(s4)
    80005cf0:	16050263          	beqz	a0,80005e54 <printf+0x1b2>
    80005cf4:	4481                	li	s1,0
    if(c != '%'){
    80005cf6:	02500a93          	li	s5,37
    switch(c){
    80005cfa:	07000b13          	li	s6,112
  consputc('x');
    80005cfe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d00:	00003b97          	auipc	s7,0x3
    80005d04:	c58b8b93          	addi	s7,s7,-936 # 80008958 <digits>
    switch(c){
    80005d08:	07300c93          	li	s9,115
    80005d0c:	06400c13          	li	s8,100
    80005d10:	a82d                	j	80005d4a <printf+0xa8>
    acquire(&pr.lock);
    80005d12:	00020517          	auipc	a0,0x20
    80005d16:	4d650513          	addi	a0,a0,1238 # 800261e8 <pr>
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	488080e7          	jalr	1160(ra) # 800061a2 <acquire>
    80005d22:	bf7d                	j	80005ce0 <printf+0x3e>
    panic("null fmt");
    80005d24:	00003517          	auipc	a0,0x3
    80005d28:	c1c50513          	addi	a0,a0,-996 # 80008940 <syscalls_name+0x3e8>
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	f2c080e7          	jalr	-212(ra) # 80005c58 <panic>
      consputc(c);
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	c62080e7          	jalr	-926(ra) # 80005996 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3c:	2485                	addiw	s1,s1,1
    80005d3e:	009a07b3          	add	a5,s4,s1
    80005d42:	0007c503          	lbu	a0,0(a5)
    80005d46:	10050763          	beqz	a0,80005e54 <printf+0x1b2>
    if(c != '%'){
    80005d4a:	ff5515e3          	bne	a0,s5,80005d34 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d4e:	2485                	addiw	s1,s1,1
    80005d50:	009a07b3          	add	a5,s4,s1
    80005d54:	0007c783          	lbu	a5,0(a5)
    80005d58:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d5c:	cfe5                	beqz	a5,80005e54 <printf+0x1b2>
    switch(c){
    80005d5e:	05678a63          	beq	a5,s6,80005db2 <printf+0x110>
    80005d62:	02fb7663          	bgeu	s6,a5,80005d8e <printf+0xec>
    80005d66:	09978963          	beq	a5,s9,80005df8 <printf+0x156>
    80005d6a:	07800713          	li	a4,120
    80005d6e:	0ce79863          	bne	a5,a4,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d72:	f8843783          	ld	a5,-120(s0)
    80005d76:	00878713          	addi	a4,a5,8
    80005d7a:	f8e43423          	sd	a4,-120(s0)
    80005d7e:	4605                	li	a2,1
    80005d80:	85ea                	mv	a1,s10
    80005d82:	4388                	lw	a0,0(a5)
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	e32080e7          	jalr	-462(ra) # 80005bb6 <printint>
      break;
    80005d8c:	bf45                	j	80005d3c <printf+0x9a>
    switch(c){
    80005d8e:	0b578263          	beq	a5,s5,80005e32 <printf+0x190>
    80005d92:	0b879663          	bne	a5,s8,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d96:	f8843783          	ld	a5,-120(s0)
    80005d9a:	00878713          	addi	a4,a5,8
    80005d9e:	f8e43423          	sd	a4,-120(s0)
    80005da2:	4605                	li	a2,1
    80005da4:	45a9                	li	a1,10
    80005da6:	4388                	lw	a0,0(a5)
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	e0e080e7          	jalr	-498(ra) # 80005bb6 <printint>
      break;
    80005db0:	b771                	j	80005d3c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dc2:	03000513          	li	a0,48
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	bd0080e7          	jalr	-1072(ra) # 80005996 <consputc>
  consputc('x');
    80005dce:	07800513          	li	a0,120
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	bc4080e7          	jalr	-1084(ra) # 80005996 <consputc>
    80005dda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ddc:	03c9d793          	srli	a5,s3,0x3c
    80005de0:	97de                	add	a5,a5,s7
    80005de2:	0007c503          	lbu	a0,0(a5)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	bb0080e7          	jalr	-1104(ra) # 80005996 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dee:	0992                	slli	s3,s3,0x4
    80005df0:	397d                	addiw	s2,s2,-1
    80005df2:	fe0915e3          	bnez	s2,80005ddc <printf+0x13a>
    80005df6:	b799                	j	80005d3c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005df8:	f8843783          	ld	a5,-120(s0)
    80005dfc:	00878713          	addi	a4,a5,8
    80005e00:	f8e43423          	sd	a4,-120(s0)
    80005e04:	0007b903          	ld	s2,0(a5)
    80005e08:	00090e63          	beqz	s2,80005e24 <printf+0x182>
      for(; *s; s++)
    80005e0c:	00094503          	lbu	a0,0(s2)
    80005e10:	d515                	beqz	a0,80005d3c <printf+0x9a>
        consputc(*s);
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b84080e7          	jalr	-1148(ra) # 80005996 <consputc>
      for(; *s; s++)
    80005e1a:	0905                	addi	s2,s2,1
    80005e1c:	00094503          	lbu	a0,0(s2)
    80005e20:	f96d                	bnez	a0,80005e12 <printf+0x170>
    80005e22:	bf29                	j	80005d3c <printf+0x9a>
        s = "(null)";
    80005e24:	00003917          	auipc	s2,0x3
    80005e28:	b1490913          	addi	s2,s2,-1260 # 80008938 <syscalls_name+0x3e0>
      for(; *s; s++)
    80005e2c:	02800513          	li	a0,40
    80005e30:	b7cd                	j	80005e12 <printf+0x170>
      consputc('%');
    80005e32:	8556                	mv	a0,s5
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	b62080e7          	jalr	-1182(ra) # 80005996 <consputc>
      break;
    80005e3c:	b701                	j	80005d3c <printf+0x9a>
      consputc('%');
    80005e3e:	8556                	mv	a0,s5
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	b56080e7          	jalr	-1194(ra) # 80005996 <consputc>
      consputc(c);
    80005e48:	854a                	mv	a0,s2
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b4c080e7          	jalr	-1204(ra) # 80005996 <consputc>
      break;
    80005e52:	b5ed                	j	80005d3c <printf+0x9a>
  if(locking)
    80005e54:	020d9163          	bnez	s11,80005e76 <printf+0x1d4>
}
    80005e58:	70e6                	ld	ra,120(sp)
    80005e5a:	7446                	ld	s0,112(sp)
    80005e5c:	74a6                	ld	s1,104(sp)
    80005e5e:	7906                	ld	s2,96(sp)
    80005e60:	69e6                	ld	s3,88(sp)
    80005e62:	6a46                	ld	s4,80(sp)
    80005e64:	6aa6                	ld	s5,72(sp)
    80005e66:	6b06                	ld	s6,64(sp)
    80005e68:	7be2                	ld	s7,56(sp)
    80005e6a:	7c42                	ld	s8,48(sp)
    80005e6c:	7ca2                	ld	s9,40(sp)
    80005e6e:	7d02                	ld	s10,32(sp)
    80005e70:	6de2                	ld	s11,24(sp)
    80005e72:	6129                	addi	sp,sp,192
    80005e74:	8082                	ret
    release(&pr.lock);
    80005e76:	00020517          	auipc	a0,0x20
    80005e7a:	37250513          	addi	a0,a0,882 # 800261e8 <pr>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	3d8080e7          	jalr	984(ra) # 80006256 <release>
}
    80005e86:	bfc9                	j	80005e58 <printf+0x1b6>

0000000080005e88 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e88:	1101                	addi	sp,sp,-32
    80005e8a:	ec06                	sd	ra,24(sp)
    80005e8c:	e822                	sd	s0,16(sp)
    80005e8e:	e426                	sd	s1,8(sp)
    80005e90:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e92:	00020497          	auipc	s1,0x20
    80005e96:	35648493          	addi	s1,s1,854 # 800261e8 <pr>
    80005e9a:	00003597          	auipc	a1,0x3
    80005e9e:	ab658593          	addi	a1,a1,-1354 # 80008950 <syscalls_name+0x3f8>
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	26e080e7          	jalr	622(ra) # 80006112 <initlock>
  pr.locking = 1;
    80005eac:	4785                	li	a5,1
    80005eae:	cc9c                	sw	a5,24(s1)
}
    80005eb0:	60e2                	ld	ra,24(sp)
    80005eb2:	6442                	ld	s0,16(sp)
    80005eb4:	64a2                	ld	s1,8(sp)
    80005eb6:	6105                	addi	sp,sp,32
    80005eb8:	8082                	ret

0000000080005eba <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eba:	1141                	addi	sp,sp,-16
    80005ebc:	e406                	sd	ra,8(sp)
    80005ebe:	e022                	sd	s0,0(sp)
    80005ec0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ec2:	100007b7          	lui	a5,0x10000
    80005ec6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eca:	f8000713          	li	a4,-128
    80005ece:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ed2:	470d                	li	a4,3
    80005ed4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ed8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005edc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee0:	469d                	li	a3,7
    80005ee2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ee6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eea:	00003597          	auipc	a1,0x3
    80005eee:	a8658593          	addi	a1,a1,-1402 # 80008970 <digits+0x18>
    80005ef2:	00020517          	auipc	a0,0x20
    80005ef6:	31650513          	addi	a0,a0,790 # 80026208 <uart_tx_lock>
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	218080e7          	jalr	536(ra) # 80006112 <initlock>
}
    80005f02:	60a2                	ld	ra,8(sp)
    80005f04:	6402                	ld	s0,0(sp)
    80005f06:	0141                	addi	sp,sp,16
    80005f08:	8082                	ret

0000000080005f0a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f0a:	1101                	addi	sp,sp,-32
    80005f0c:	ec06                	sd	ra,24(sp)
    80005f0e:	e822                	sd	s0,16(sp)
    80005f10:	e426                	sd	s1,8(sp)
    80005f12:	1000                	addi	s0,sp,32
    80005f14:	84aa                	mv	s1,a0
  push_off();
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	240080e7          	jalr	576(ra) # 80006156 <push_off>

  if(panicked){
    80005f1e:	00003797          	auipc	a5,0x3
    80005f22:	0fe7a783          	lw	a5,254(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f26:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f2a:	c391                	beqz	a5,80005f2e <uartputc_sync+0x24>
    for(;;)
    80005f2c:	a001                	j	80005f2c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f2e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f32:	0ff7f793          	andi	a5,a5,255
    80005f36:	0207f793          	andi	a5,a5,32
    80005f3a:	dbf5                	beqz	a5,80005f2e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f3c:	0ff4f793          	andi	a5,s1,255
    80005f40:	10000737          	lui	a4,0x10000
    80005f44:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	2ae080e7          	jalr	686(ra) # 800061f6 <pop_off>
}
    80005f50:	60e2                	ld	ra,24(sp)
    80005f52:	6442                	ld	s0,16(sp)
    80005f54:	64a2                	ld	s1,8(sp)
    80005f56:	6105                	addi	sp,sp,32
    80005f58:	8082                	ret

0000000080005f5a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f5a:	00003717          	auipc	a4,0x3
    80005f5e:	0c673703          	ld	a4,198(a4) # 80009020 <uart_tx_r>
    80005f62:	00003797          	auipc	a5,0x3
    80005f66:	0c67b783          	ld	a5,198(a5) # 80009028 <uart_tx_w>
    80005f6a:	06e78c63          	beq	a5,a4,80005fe2 <uartstart+0x88>
{
    80005f6e:	7139                	addi	sp,sp,-64
    80005f70:	fc06                	sd	ra,56(sp)
    80005f72:	f822                	sd	s0,48(sp)
    80005f74:	f426                	sd	s1,40(sp)
    80005f76:	f04a                	sd	s2,32(sp)
    80005f78:	ec4e                	sd	s3,24(sp)
    80005f7a:	e852                	sd	s4,16(sp)
    80005f7c:	e456                	sd	s5,8(sp)
    80005f7e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f80:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f84:	00020a17          	auipc	s4,0x20
    80005f88:	284a0a13          	addi	s4,s4,644 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f8c:	00003497          	auipc	s1,0x3
    80005f90:	09448493          	addi	s1,s1,148 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f94:	00003997          	auipc	s3,0x3
    80005f98:	09498993          	addi	s3,s3,148 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f9c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fa0:	0ff7f793          	andi	a5,a5,255
    80005fa4:	0207f793          	andi	a5,a5,32
    80005fa8:	c785                	beqz	a5,80005fd0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005faa:	01f77793          	andi	a5,a4,31
    80005fae:	97d2                	add	a5,a5,s4
    80005fb0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fb4:	0705                	addi	a4,a4,1
    80005fb6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb8:	8526                	mv	a0,s1
    80005fba:	ffffb097          	auipc	ra,0xffffb
    80005fbe:	730080e7          	jalr	1840(ra) # 800016ea <wakeup>
    
    WriteReg(THR, c);
    80005fc2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc6:	6098                	ld	a4,0(s1)
    80005fc8:	0009b783          	ld	a5,0(s3)
    80005fcc:	fce798e3          	bne	a5,a4,80005f9c <uartstart+0x42>
  }
}
    80005fd0:	70e2                	ld	ra,56(sp)
    80005fd2:	7442                	ld	s0,48(sp)
    80005fd4:	74a2                	ld	s1,40(sp)
    80005fd6:	7902                	ld	s2,32(sp)
    80005fd8:	69e2                	ld	s3,24(sp)
    80005fda:	6a42                	ld	s4,16(sp)
    80005fdc:	6aa2                	ld	s5,8(sp)
    80005fde:	6121                	addi	sp,sp,64
    80005fe0:	8082                	ret
    80005fe2:	8082                	ret

0000000080005fe4 <uartputc>:
{
    80005fe4:	7179                	addi	sp,sp,-48
    80005fe6:	f406                	sd	ra,40(sp)
    80005fe8:	f022                	sd	s0,32(sp)
    80005fea:	ec26                	sd	s1,24(sp)
    80005fec:	e84a                	sd	s2,16(sp)
    80005fee:	e44e                	sd	s3,8(sp)
    80005ff0:	e052                	sd	s4,0(sp)
    80005ff2:	1800                	addi	s0,sp,48
    80005ff4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005ff6:	00020517          	auipc	a0,0x20
    80005ffa:	21250513          	addi	a0,a0,530 # 80026208 <uart_tx_lock>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	1a4080e7          	jalr	420(ra) # 800061a2 <acquire>
  if(panicked){
    80006006:	00003797          	auipc	a5,0x3
    8000600a:	0167a783          	lw	a5,22(a5) # 8000901c <panicked>
    8000600e:	c391                	beqz	a5,80006012 <uartputc+0x2e>
    for(;;)
    80006010:	a001                	j	80006010 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006012:	00003797          	auipc	a5,0x3
    80006016:	0167b783          	ld	a5,22(a5) # 80009028 <uart_tx_w>
    8000601a:	00003717          	auipc	a4,0x3
    8000601e:	00673703          	ld	a4,6(a4) # 80009020 <uart_tx_r>
    80006022:	02070713          	addi	a4,a4,32
    80006026:	02f71b63          	bne	a4,a5,8000605c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000602a:	00020a17          	auipc	s4,0x20
    8000602e:	1dea0a13          	addi	s4,s4,478 # 80026208 <uart_tx_lock>
    80006032:	00003497          	auipc	s1,0x3
    80006036:	fee48493          	addi	s1,s1,-18 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603a:	00003917          	auipc	s2,0x3
    8000603e:	fee90913          	addi	s2,s2,-18 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006042:	85d2                	mv	a1,s4
    80006044:	8526                	mv	a0,s1
    80006046:	ffffb097          	auipc	ra,0xffffb
    8000604a:	518080e7          	jalr	1304(ra) # 8000155e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604e:	00093783          	ld	a5,0(s2)
    80006052:	6098                	ld	a4,0(s1)
    80006054:	02070713          	addi	a4,a4,32
    80006058:	fef705e3          	beq	a4,a5,80006042 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000605c:	00020497          	auipc	s1,0x20
    80006060:	1ac48493          	addi	s1,s1,428 # 80026208 <uart_tx_lock>
    80006064:	01f7f713          	andi	a4,a5,31
    80006068:	9726                	add	a4,a4,s1
    8000606a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000606e:	0785                	addi	a5,a5,1
    80006070:	00003717          	auipc	a4,0x3
    80006074:	faf73c23          	sd	a5,-72(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	ee2080e7          	jalr	-286(ra) # 80005f5a <uartstart>
      release(&uart_tx_lock);
    80006080:	8526                	mv	a0,s1
    80006082:	00000097          	auipc	ra,0x0
    80006086:	1d4080e7          	jalr	468(ra) # 80006256 <release>
}
    8000608a:	70a2                	ld	ra,40(sp)
    8000608c:	7402                	ld	s0,32(sp)
    8000608e:	64e2                	ld	s1,24(sp)
    80006090:	6942                	ld	s2,16(sp)
    80006092:	69a2                	ld	s3,8(sp)
    80006094:	6a02                	ld	s4,0(sp)
    80006096:	6145                	addi	sp,sp,48
    80006098:	8082                	ret

000000008000609a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e422                	sd	s0,8(sp)
    8000609e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060a0:	100007b7          	lui	a5,0x10000
    800060a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a8:	8b85                	andi	a5,a5,1
    800060aa:	cb91                	beqz	a5,800060be <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ac:	100007b7          	lui	a5,0x10000
    800060b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060b4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060b8:	6422                	ld	s0,8(sp)
    800060ba:	0141                	addi	sp,sp,16
    800060bc:	8082                	ret
    return -1;
    800060be:	557d                	li	a0,-1
    800060c0:	bfe5                	j	800060b8 <uartgetc+0x1e>

00000000800060c2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060c2:	1101                	addi	sp,sp,-32
    800060c4:	ec06                	sd	ra,24(sp)
    800060c6:	e822                	sd	s0,16(sp)
    800060c8:	e426                	sd	s1,8(sp)
    800060ca:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060cc:	54fd                	li	s1,-1
    int c = uartgetc();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	fcc080e7          	jalr	-52(ra) # 8000609a <uartgetc>
    if(c == -1)
    800060d6:	00950763          	beq	a0,s1,800060e4 <uartintr+0x22>
      break;
    consoleintr(c);
    800060da:	00000097          	auipc	ra,0x0
    800060de:	8fe080e7          	jalr	-1794(ra) # 800059d8 <consoleintr>
  while(1){
    800060e2:	b7f5                	j	800060ce <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060e4:	00020497          	auipc	s1,0x20
    800060e8:	12448493          	addi	s1,s1,292 # 80026208 <uart_tx_lock>
    800060ec:	8526                	mv	a0,s1
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	0b4080e7          	jalr	180(ra) # 800061a2 <acquire>
  uartstart();
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	e64080e7          	jalr	-412(ra) # 80005f5a <uartstart>
  release(&uart_tx_lock);
    800060fe:	8526                	mv	a0,s1
    80006100:	00000097          	auipc	ra,0x0
    80006104:	156080e7          	jalr	342(ra) # 80006256 <release>
}
    80006108:	60e2                	ld	ra,24(sp)
    8000610a:	6442                	ld	s0,16(sp)
    8000610c:	64a2                	ld	s1,8(sp)
    8000610e:	6105                	addi	sp,sp,32
    80006110:	8082                	ret

0000000080006112 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006112:	1141                	addi	sp,sp,-16
    80006114:	e422                	sd	s0,8(sp)
    80006116:	0800                	addi	s0,sp,16
  lk->name = name;
    80006118:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000611a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000611e:	00053823          	sd	zero,16(a0)
}
    80006122:	6422                	ld	s0,8(sp)
    80006124:	0141                	addi	sp,sp,16
    80006126:	8082                	ret

0000000080006128 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006128:	411c                	lw	a5,0(a0)
    8000612a:	e399                	bnez	a5,80006130 <holding+0x8>
    8000612c:	4501                	li	a0,0
  return r;
}
    8000612e:	8082                	ret
{
    80006130:	1101                	addi	sp,sp,-32
    80006132:	ec06                	sd	ra,24(sp)
    80006134:	e822                	sd	s0,16(sp)
    80006136:	e426                	sd	s1,8(sp)
    80006138:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000613a:	6904                	ld	s1,16(a0)
    8000613c:	ffffb097          	auipc	ra,0xffffb
    80006140:	d42080e7          	jalr	-702(ra) # 80000e7e <mycpu>
    80006144:	40a48533          	sub	a0,s1,a0
    80006148:	00153513          	seqz	a0,a0
}
    8000614c:	60e2                	ld	ra,24(sp)
    8000614e:	6442                	ld	s0,16(sp)
    80006150:	64a2                	ld	s1,8(sp)
    80006152:	6105                	addi	sp,sp,32
    80006154:	8082                	ret

0000000080006156 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006156:	1101                	addi	sp,sp,-32
    80006158:	ec06                	sd	ra,24(sp)
    8000615a:	e822                	sd	s0,16(sp)
    8000615c:	e426                	sd	s1,8(sp)
    8000615e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006160:	100024f3          	csrr	s1,sstatus
    80006164:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006168:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000616a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	d10080e7          	jalr	-752(ra) # 80000e7e <mycpu>
    80006176:	5d3c                	lw	a5,120(a0)
    80006178:	cf89                	beqz	a5,80006192 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000617a:	ffffb097          	auipc	ra,0xffffb
    8000617e:	d04080e7          	jalr	-764(ra) # 80000e7e <mycpu>
    80006182:	5d3c                	lw	a5,120(a0)
    80006184:	2785                	addiw	a5,a5,1
    80006186:	dd3c                	sw	a5,120(a0)
}
    80006188:	60e2                	ld	ra,24(sp)
    8000618a:	6442                	ld	s0,16(sp)
    8000618c:	64a2                	ld	s1,8(sp)
    8000618e:	6105                	addi	sp,sp,32
    80006190:	8082                	ret
    mycpu()->intena = old;
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	cec080e7          	jalr	-788(ra) # 80000e7e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000619a:	8085                	srli	s1,s1,0x1
    8000619c:	8885                	andi	s1,s1,1
    8000619e:	dd64                	sw	s1,124(a0)
    800061a0:	bfe9                	j	8000617a <push_off+0x24>

00000000800061a2 <acquire>:
{
    800061a2:	1101                	addi	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	addi	s0,sp,32
    800061ac:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	fa8080e7          	jalr	-88(ra) # 80006156 <push_off>
  if(holding(lk))
    800061b6:	8526                	mv	a0,s1
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	f70080e7          	jalr	-144(ra) # 80006128 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061c0:	4705                	li	a4,1
  if(holding(lk))
    800061c2:	e115                	bnez	a0,800061e6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061c4:	87ba                	mv	a5,a4
    800061c6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061ca:	2781                	sext.w	a5,a5
    800061cc:	ffe5                	bnez	a5,800061c4 <acquire+0x22>
  __sync_synchronize();
    800061ce:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	cac080e7          	jalr	-852(ra) # 80000e7e <mycpu>
    800061da:	e888                	sd	a0,16(s1)
}
    800061dc:	60e2                	ld	ra,24(sp)
    800061de:	6442                	ld	s0,16(sp)
    800061e0:	64a2                	ld	s1,8(sp)
    800061e2:	6105                	addi	sp,sp,32
    800061e4:	8082                	ret
    panic("acquire");
    800061e6:	00002517          	auipc	a0,0x2
    800061ea:	79250513          	addi	a0,a0,1938 # 80008978 <digits+0x20>
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	a6a080e7          	jalr	-1430(ra) # 80005c58 <panic>

00000000800061f6 <pop_off>:

void
pop_off(void)
{
    800061f6:	1141                	addi	sp,sp,-16
    800061f8:	e406                	sd	ra,8(sp)
    800061fa:	e022                	sd	s0,0(sp)
    800061fc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061fe:	ffffb097          	auipc	ra,0xffffb
    80006202:	c80080e7          	jalr	-896(ra) # 80000e7e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006206:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000620a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000620c:	e78d                	bnez	a5,80006236 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000620e:	5d3c                	lw	a5,120(a0)
    80006210:	02f05b63          	blez	a5,80006246 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006214:	37fd                	addiw	a5,a5,-1
    80006216:	0007871b          	sext.w	a4,a5
    8000621a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000621c:	eb09                	bnez	a4,8000622e <pop_off+0x38>
    8000621e:	5d7c                	lw	a5,124(a0)
    80006220:	c799                	beqz	a5,8000622e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006222:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006226:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000622a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000622e:	60a2                	ld	ra,8(sp)
    80006230:	6402                	ld	s0,0(sp)
    80006232:	0141                	addi	sp,sp,16
    80006234:	8082                	ret
    panic("pop_off - interruptible");
    80006236:	00002517          	auipc	a0,0x2
    8000623a:	74a50513          	addi	a0,a0,1866 # 80008980 <digits+0x28>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	a1a080e7          	jalr	-1510(ra) # 80005c58 <panic>
    panic("pop_off");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	75250513          	addi	a0,a0,1874 # 80008998 <digits+0x40>
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	a0a080e7          	jalr	-1526(ra) # 80005c58 <panic>

0000000080006256 <release>:
{
    80006256:	1101                	addi	sp,sp,-32
    80006258:	ec06                	sd	ra,24(sp)
    8000625a:	e822                	sd	s0,16(sp)
    8000625c:	e426                	sd	s1,8(sp)
    8000625e:	1000                	addi	s0,sp,32
    80006260:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006262:	00000097          	auipc	ra,0x0
    80006266:	ec6080e7          	jalr	-314(ra) # 80006128 <holding>
    8000626a:	c115                	beqz	a0,8000628e <release+0x38>
  lk->cpu = 0;
    8000626c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006270:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006274:	0f50000f          	fence	iorw,ow
    80006278:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000627c:	00000097          	auipc	ra,0x0
    80006280:	f7a080e7          	jalr	-134(ra) # 800061f6 <pop_off>
}
    80006284:	60e2                	ld	ra,24(sp)
    80006286:	6442                	ld	s0,16(sp)
    80006288:	64a2                	ld	s1,8(sp)
    8000628a:	6105                	addi	sp,sp,32
    8000628c:	8082                	ret
    panic("release");
    8000628e:	00002517          	auipc	a0,0x2
    80006292:	71250513          	addi	a0,a0,1810 # 800089a0 <digits+0x48>
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	9c2080e7          	jalr	-1598(ra) # 80005c58 <panic>
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
