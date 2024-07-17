
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8a013103          	ld	sp,-1888(sp) # 800088a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1c3050ef          	jal	ra,800059d8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void* pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
    8000002a:	892a                	mv	s2,a0
  struct run* r;

  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002c:	03451793          	slli	a5,a0,0x34
    80000030:	efd9                	bnez	a5,800000ce <kfree+0xb2>
    80000032:	00126797          	auipc	a5,0x126
    80000036:	20e78793          	addi	a5,a5,526 # 80126240 <end>
    8000003a:	08f56a63          	bltu	a0,a5,800000ce <kfree+0xb2>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	08f57663          	bgeu	a0,a5,800000ce <kfree+0xb2>
    printf("%p,%d\n", pa, krefget((void*)pa));
    panic("kfree");
  }


  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
    80000046:	800004b7          	lui	s1,0x80000
    8000004a:	94aa                	add	s1,s1,a0
    8000004c:	80b1                	srli	s1,s1,0xc
  acquire(&ref2pages[pg].lock);
    8000004e:	00549993          	slli	s3,s1,0x5
    80000052:	00009797          	auipc	a5,0x9
    80000056:	ffe78793          	addi	a5,a5,-2 # 80009050 <ref2pages>
    8000005a:	99be                	add	s3,s3,a5
    8000005c:	854e                	mv	a0,s3
    8000005e:	00006097          	auipc	ra,0x6
    80000062:	374080e7          	jalr	884(ra) # 800063d2 <acquire>
  if (ref2pages[pg].ref == 0)
    80000066:	0189a783          	lw	a5,24(s3)
    8000006a:	cfd1                	beqz	a5,80000106 <kfree+0xea>
  {
    release(&ref2pages[pg].lock);
    panic("kfree");
  }
  ref2pages[pg].ref--;
    8000006c:	37fd                	addiw	a5,a5,-1
    8000006e:	0007869b          	sext.w	a3,a5
    80000072:	0496                	slli	s1,s1,0x5
    80000074:	00009717          	auipc	a4,0x9
    80000078:	fdc70713          	addi	a4,a4,-36 # 80009050 <ref2pages>
    8000007c:	94ba                	add	s1,s1,a4
    8000007e:	cc9c                	sw	a5,24(s1)
  if (ref2pages[pg].ref != 0)
    80000080:	e2c5                	bnez	a3,80000120 <kfree+0x104>
    return;
  }
  else
  {
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000082:	6605                	lui	a2,0x1
    80000084:	4585                	li	a1,1
    80000086:	854a                	mv	a0,s2
    80000088:	00000097          	auipc	ra,0x0
    8000008c:	31e080e7          	jalr	798(ra) # 800003a6 <memset>

    r = (struct run*)pa;

    acquire(&kmem.lock);
    80000090:	00009497          	auipc	s1,0x9
    80000094:	fa048493          	addi	s1,s1,-96 # 80009030 <kmem>
    80000098:	8526                	mv	a0,s1
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	338080e7          	jalr	824(ra) # 800063d2 <acquire>
    r->next = kmem.freelist;
    800000a2:	6c9c                	ld	a5,24(s1)
    800000a4:	00f93023          	sd	a5,0(s2)
    kmem.freelist = r;
    800000a8:	0124bc23          	sd	s2,24(s1)
    release(&kmem.lock);
    800000ac:	8526                	mv	a0,s1
    800000ae:	00006097          	auipc	ra,0x6
    800000b2:	3d8080e7          	jalr	984(ra) # 80006486 <release>

    release(&ref2pages[pg].lock);
    800000b6:	854e                	mv	a0,s3
    800000b8:	00006097          	auipc	ra,0x6
    800000bc:	3ce080e7          	jalr	974(ra) # 80006486 <release>
  }

}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6942                	ld	s2,16(sp)
    800000c8:	69a2                	ld	s3,8(sp)
    800000ca:	6145                	addi	sp,sp,48
    800000cc:	8082                	ret
  return (void*)r;
}

int krefget(void* pa)
{
  return ref2pages[((uint64)pa - KERNBASE) / PGSIZE].ref;
    800000ce:	800007b7          	lui	a5,0x80000
    800000d2:	97ca                	add	a5,a5,s2
    800000d4:	83b1                	srli	a5,a5,0xc
    800000d6:	0796                	slli	a5,a5,0x5
    800000d8:	00009717          	auipc	a4,0x9
    800000dc:	f7870713          	addi	a4,a4,-136 # 80009050 <ref2pages>
    800000e0:	97ba                	add	a5,a5,a4
    printf("%p,%d\n", pa, krefget((void*)pa));
    800000e2:	4f90                	lw	a2,24(a5)
    800000e4:	85ca                	mv	a1,s2
    800000e6:	00008517          	auipc	a0,0x8
    800000ea:	f2a50513          	addi	a0,a0,-214 # 80008010 <etext+0x10>
    800000ee:	00006097          	auipc	ra,0x6
    800000f2:	de4080e7          	jalr	-540(ra) # 80005ed2 <printf>
    panic("kfree");
    800000f6:	00008517          	auipc	a0,0x8
    800000fa:	f2250513          	addi	a0,a0,-222 # 80008018 <etext+0x18>
    800000fe:	00006097          	auipc	ra,0x6
    80000102:	d8a080e7          	jalr	-630(ra) # 80005e88 <panic>
    release(&ref2pages[pg].lock);
    80000106:	854e                	mv	a0,s3
    80000108:	00006097          	auipc	ra,0x6
    8000010c:	37e080e7          	jalr	894(ra) # 80006486 <release>
    panic("kfree");
    80000110:	00008517          	auipc	a0,0x8
    80000114:	f0850513          	addi	a0,a0,-248 # 80008018 <etext+0x18>
    80000118:	00006097          	auipc	ra,0x6
    8000011c:	d70080e7          	jalr	-656(ra) # 80005e88 <panic>
    release(&ref2pages[pg].lock);
    80000120:	854e                	mv	a0,s3
    80000122:	00006097          	auipc	ra,0x6
    80000126:	364080e7          	jalr	868(ra) # 80006486 <release>
    return;
    8000012a:	bf59                	j	800000c0 <kfree+0xa4>

000000008000012c <freerange>:
{
    8000012c:	715d                	addi	sp,sp,-80
    8000012e:	e486                	sd	ra,72(sp)
    80000130:	e0a2                	sd	s0,64(sp)
    80000132:	fc26                	sd	s1,56(sp)
    80000134:	f84a                	sd	s2,48(sp)
    80000136:	f44e                	sd	s3,40(sp)
    80000138:	f052                	sd	s4,32(sp)
    8000013a:	ec56                	sd	s5,24(sp)
    8000013c:	e85a                	sd	s6,16(sp)
    8000013e:	e45e                	sd	s7,8(sp)
    80000140:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000142:	6785                	lui	a5,0x1
    80000144:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000148:	94aa                	add	s1,s1,a0
    8000014a:	757d                	lui	a0,0xfffff
    8000014c:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000014e:	94be                	add	s1,s1,a5
    80000150:	0295ee63          	bltu	a1,s1,8000018c <freerange+0x60>
    80000154:	89ae                	mv	s3,a1
    ref2pages[((uint64)p - KERNBASE) / PGSIZE].ref = 1;
    80000156:	00009a97          	auipc	s5,0x9
    8000015a:	efaa8a93          	addi	s5,s5,-262 # 80009050 <ref2pages>
    8000015e:	fff80937          	lui	s2,0xfff80
    80000162:	197d                	addi	s2,s2,-1
    80000164:	0932                	slli	s2,s2,0xc
    80000166:	4b85                	li	s7,1
    kfree(p);
    80000168:	7b7d                	lui	s6,0xfffff
  for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000016a:	6a05                	lui	s4,0x1
    ref2pages[((uint64)p - KERNBASE) / PGSIZE].ref = 1;
    8000016c:	012487b3          	add	a5,s1,s2
    80000170:	83b1                	srli	a5,a5,0xc
    80000172:	0796                	slli	a5,a5,0x5
    80000174:	97d6                	add	a5,a5,s5
    80000176:	0177ac23          	sw	s7,24(a5)
    kfree(p);
    8000017a:	01648533          	add	a0,s1,s6
    8000017e:	00000097          	auipc	ra,0x0
    80000182:	e9e080e7          	jalr	-354(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000186:	94d2                	add	s1,s1,s4
    80000188:	fe99f2e3          	bgeu	s3,s1,8000016c <freerange+0x40>
}
    8000018c:	60a6                	ld	ra,72(sp)
    8000018e:	6406                	ld	s0,64(sp)
    80000190:	74e2                	ld	s1,56(sp)
    80000192:	7942                	ld	s2,48(sp)
    80000194:	79a2                	ld	s3,40(sp)
    80000196:	7a02                	ld	s4,32(sp)
    80000198:	6ae2                	ld	s5,24(sp)
    8000019a:	6b42                	ld	s6,16(sp)
    8000019c:	6ba2                	ld	s7,8(sp)
    8000019e:	6161                	addi	sp,sp,80
    800001a0:	8082                	ret

00000000800001a2 <kinit>:
{
    800001a2:	7179                	addi	sp,sp,-48
    800001a4:	f406                	sd	ra,40(sp)
    800001a6:	f022                	sd	s0,32(sp)
    800001a8:	ec26                	sd	s1,24(sp)
    800001aa:	e84a                	sd	s2,16(sp)
    800001ac:	e44e                	sd	s3,8(sp)
    800001ae:	1800                	addi	s0,sp,48
  for (int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++)
    800001b0:	00009497          	auipc	s1,0x9
    800001b4:	ea048493          	addi	s1,s1,-352 # 80009050 <ref2pages>
    800001b8:	00109997          	auipc	s3,0x109
    800001bc:	e9898993          	addi	s3,s3,-360 # 80109050 <pid_lock>
    initlock(&(ref2pages[i].lock), "page_ref");
    800001c0:	00008917          	auipc	s2,0x8
    800001c4:	e6090913          	addi	s2,s2,-416 # 80008020 <etext+0x20>
    800001c8:	85ca                	mv	a1,s2
    800001ca:	8526                	mv	a0,s1
    800001cc:	00006097          	auipc	ra,0x6
    800001d0:	176080e7          	jalr	374(ra) # 80006342 <initlock>
  for (int i = 0; i < (PHYSTOP - KERNBASE) / PGSIZE; i++)
    800001d4:	02048493          	addi	s1,s1,32
    800001d8:	ff3498e3          	bne	s1,s3,800001c8 <kinit+0x26>
  initlock(&kmem.lock, "kmem");
    800001dc:	00008597          	auipc	a1,0x8
    800001e0:	e5458593          	addi	a1,a1,-428 # 80008030 <etext+0x30>
    800001e4:	00009517          	auipc	a0,0x9
    800001e8:	e4c50513          	addi	a0,a0,-436 # 80009030 <kmem>
    800001ec:	00006097          	auipc	ra,0x6
    800001f0:	156080e7          	jalr	342(ra) # 80006342 <initlock>
  freerange(end, (void*)PHYSTOP);
    800001f4:	45c5                	li	a1,17
    800001f6:	05ee                	slli	a1,a1,0x1b
    800001f8:	00126517          	auipc	a0,0x126
    800001fc:	04850513          	addi	a0,a0,72 # 80126240 <end>
    80000200:	00000097          	auipc	ra,0x0
    80000204:	f2c080e7          	jalr	-212(ra) # 8000012c <freerange>
}
    80000208:	70a2                	ld	ra,40(sp)
    8000020a:	7402                	ld	s0,32(sp)
    8000020c:	64e2                	ld	s1,24(sp)
    8000020e:	6942                	ld	s2,16(sp)
    80000210:	69a2                	ld	s3,8(sp)
    80000212:	6145                	addi	sp,sp,48
    80000214:	8082                	ret

0000000080000216 <kalloc>:
{
    80000216:	1101                	addi	sp,sp,-32
    80000218:	ec06                	sd	ra,24(sp)
    8000021a:	e822                	sd	s0,16(sp)
    8000021c:	e426                	sd	s1,8(sp)
    8000021e:	e04a                	sd	s2,0(sp)
    80000220:	1000                	addi	s0,sp,32
  acquire(&kmem.lock);
    80000222:	00009497          	auipc	s1,0x9
    80000226:	e0e48493          	addi	s1,s1,-498 # 80009030 <kmem>
    8000022a:	8526                	mv	a0,s1
    8000022c:	00006097          	auipc	ra,0x6
    80000230:	1a6080e7          	jalr	422(ra) # 800063d2 <acquire>
  r = kmem.freelist;
    80000234:	0184b903          	ld	s2,24(s1)
  if (r)
    80000238:	06090163          	beqz	s2,8000029a <kalloc+0x84>
    uint64 pg = ((uint64)r - KERNBASE) / PGSIZE;
    8000023c:	800004b7          	lui	s1,0x80000
    80000240:	94ca                	add	s1,s1,s2
    80000242:	80b1                	srli	s1,s1,0xc
    acquire(&ref2pages[pg].lock);
    80000244:	0496                	slli	s1,s1,0x5
    80000246:	00009797          	auipc	a5,0x9
    8000024a:	e0a78793          	addi	a5,a5,-502 # 80009050 <ref2pages>
    8000024e:	94be                	add	s1,s1,a5
    80000250:	8526                	mv	a0,s1
    80000252:	00006097          	auipc	ra,0x6
    80000256:	180080e7          	jalr	384(ra) # 800063d2 <acquire>
    ref2pages[pg].ref = 1;
    8000025a:	4785                	li	a5,1
    8000025c:	cc9c                	sw	a5,24(s1)
    release(&ref2pages[pg].lock);
    8000025e:	8526                	mv	a0,s1
    80000260:	00006097          	auipc	ra,0x6
    80000264:	226080e7          	jalr	550(ra) # 80006486 <release>
    kmem.freelist = r->next;
    80000268:	00093783          	ld	a5,0(s2)
    8000026c:	00009517          	auipc	a0,0x9
    80000270:	dc450513          	addi	a0,a0,-572 # 80009030 <kmem>
    80000274:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000276:	00006097          	auipc	ra,0x6
    8000027a:	210080e7          	jalr	528(ra) # 80006486 <release>
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000027e:	6605                	lui	a2,0x1
    80000280:	4595                	li	a1,5
    80000282:	854a                	mv	a0,s2
    80000284:	00000097          	auipc	ra,0x0
    80000288:	122080e7          	jalr	290(ra) # 800003a6 <memset>
}
    8000028c:	854a                	mv	a0,s2
    8000028e:	60e2                	ld	ra,24(sp)
    80000290:	6442                	ld	s0,16(sp)
    80000292:	64a2                	ld	s1,8(sp)
    80000294:	6902                	ld	s2,0(sp)
    80000296:	6105                	addi	sp,sp,32
    80000298:	8082                	ret
  release(&kmem.lock);
    8000029a:	00009517          	auipc	a0,0x9
    8000029e:	d9650513          	addi	a0,a0,-618 # 80009030 <kmem>
    800002a2:	00006097          	auipc	ra,0x6
    800002a6:	1e4080e7          	jalr	484(ra) # 80006486 <release>
  if (r)
    800002aa:	b7cd                	j	8000028c <kalloc+0x76>

00000000800002ac <krefget>:
{
    800002ac:	1141                	addi	sp,sp,-16
    800002ae:	e422                	sd	s0,8(sp)
    800002b0:	0800                	addi	s0,sp,16
  return ref2pages[((uint64)pa - KERNBASE) / PGSIZE].ref;
    800002b2:	800007b7          	lui	a5,0x80000
    800002b6:	953e                	add	a0,a0,a5
    800002b8:	8131                	srli	a0,a0,0xc
    800002ba:	0516                	slli	a0,a0,0x5
    800002bc:	00009797          	auipc	a5,0x9
    800002c0:	d9478793          	addi	a5,a5,-620 # 80009050 <ref2pages>
    800002c4:	953e                	add	a0,a0,a5
}
    800002c6:	4d08                	lw	a0,24(a0)
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <krefadd>:

void
krefadd(void* pa)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	1000                	addi	s0,sp,32
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800002d8:	03451793          	slli	a5,a0,0x34
    800002dc:	e7b9                	bnez	a5,8000032a <krefadd+0x5c>
    800002de:	00126797          	auipc	a5,0x126
    800002e2:	f6278793          	addi	a5,a5,-158 # 80126240 <end>
    800002e6:	04f56263          	bltu	a0,a5,8000032a <krefadd+0x5c>
    800002ea:	47c5                	li	a5,17
    800002ec:	07ee                	slli	a5,a5,0x1b
    800002ee:	02f57e63          	bgeu	a0,a5,8000032a <krefadd+0x5c>
    panic("kfrefadd");
  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
    800002f2:	800004b7          	lui	s1,0x80000
    800002f6:	94aa                	add	s1,s1,a0
    800002f8:	80b1                	srli	s1,s1,0xc
  acquire(&ref2pages[pg].lock);
    800002fa:	0496                	slli	s1,s1,0x5
    800002fc:	00009517          	auipc	a0,0x9
    80000300:	d5450513          	addi	a0,a0,-684 # 80009050 <ref2pages>
    80000304:	94aa                	add	s1,s1,a0
    80000306:	8526                	mv	a0,s1
    80000308:	00006097          	auipc	ra,0x6
    8000030c:	0ca080e7          	jalr	202(ra) # 800063d2 <acquire>
  ref2pages[pg].ref++;
    80000310:	4c9c                	lw	a5,24(s1)
    80000312:	2785                	addiw	a5,a5,1
    80000314:	cc9c                	sw	a5,24(s1)
  release(&ref2pages[pg].lock);
    80000316:	8526                	mv	a0,s1
    80000318:	00006097          	auipc	ra,0x6
    8000031c:	16e080e7          	jalr	366(ra) # 80006486 <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
    panic("kfrefadd");
    8000032a:	00008517          	auipc	a0,0x8
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80008038 <etext+0x38>
    80000332:	00006097          	auipc	ra,0x6
    80000336:	b56080e7          	jalr	-1194(ra) # 80005e88 <panic>

000000008000033a <krefdec>:

void
krefdec(void* pa)
{
    8000033a:	1101                	addi	sp,sp,-32
    8000033c:	ec06                	sd	ra,24(sp)
    8000033e:	e822                	sd	s0,16(sp)
    80000340:	e426                	sd	s1,8(sp)
    80000342:	1000                	addi	s0,sp,32
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000344:	03451793          	slli	a5,a0,0x34
    80000348:	e7b9                	bnez	a5,80000396 <krefdec+0x5c>
    8000034a:	00126797          	auipc	a5,0x126
    8000034e:	ef678793          	addi	a5,a5,-266 # 80126240 <end>
    80000352:	04f56263          	bltu	a0,a5,80000396 <krefdec+0x5c>
    80000356:	47c5                	li	a5,17
    80000358:	07ee                	slli	a5,a5,0x1b
    8000035a:	02f57e63          	bgeu	a0,a5,80000396 <krefdec+0x5c>
    panic("kfrefdec");
  uint64 pg = ((uint64)pa - KERNBASE) / PGSIZE;
    8000035e:	800004b7          	lui	s1,0x80000
    80000362:	94aa                	add	s1,s1,a0
    80000364:	80b1                	srli	s1,s1,0xc
  acquire(&ref2pages[pg].lock);
    80000366:	0496                	slli	s1,s1,0x5
    80000368:	00009517          	auipc	a0,0x9
    8000036c:	ce850513          	addi	a0,a0,-792 # 80009050 <ref2pages>
    80000370:	94aa                	add	s1,s1,a0
    80000372:	8526                	mv	a0,s1
    80000374:	00006097          	auipc	ra,0x6
    80000378:	05e080e7          	jalr	94(ra) # 800063d2 <acquire>
  ref2pages[pg].ref--;
    8000037c:	4c9c                	lw	a5,24(s1)
    8000037e:	37fd                	addiw	a5,a5,-1
    80000380:	cc9c                	sw	a5,24(s1)
  release(&ref2pages[pg].lock);
    80000382:	8526                	mv	a0,s1
    80000384:	00006097          	auipc	ra,0x6
    80000388:	102080e7          	jalr	258(ra) # 80006486 <release>
}
    8000038c:	60e2                	ld	ra,24(sp)
    8000038e:	6442                	ld	s0,16(sp)
    80000390:	64a2                	ld	s1,8(sp)
    80000392:	6105                	addi	sp,sp,32
    80000394:	8082                	ret
    panic("kfrefdec");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	cb250513          	addi	a0,a0,-846 # 80008048 <etext+0x48>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	aea080e7          	jalr	-1302(ra) # 80005e88 <panic>

00000000800003a6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800003a6:	1141                	addi	sp,sp,-16
    800003a8:	e422                	sd	s0,8(sp)
    800003aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800003ac:	ce09                	beqz	a2,800003c6 <memset+0x20>
    800003ae:	87aa                	mv	a5,a0
    800003b0:	fff6071b          	addiw	a4,a2,-1
    800003b4:	1702                	slli	a4,a4,0x20
    800003b6:	9301                	srli	a4,a4,0x20
    800003b8:	0705                	addi	a4,a4,1
    800003ba:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800003bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800003c0:	0785                	addi	a5,a5,1
    800003c2:	fee79de3          	bne	a5,a4,800003bc <memset+0x16>
  }
  return dst;
}
    800003c6:	6422                	ld	s0,8(sp)
    800003c8:	0141                	addi	sp,sp,16
    800003ca:	8082                	ret

00000000800003cc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800003cc:	1141                	addi	sp,sp,-16
    800003ce:	e422                	sd	s0,8(sp)
    800003d0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800003d2:	ca05                	beqz	a2,80000402 <memcmp+0x36>
    800003d4:	fff6069b          	addiw	a3,a2,-1
    800003d8:	1682                	slli	a3,a3,0x20
    800003da:	9281                	srli	a3,a3,0x20
    800003dc:	0685                	addi	a3,a3,1
    800003de:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800003e0:	00054783          	lbu	a5,0(a0)
    800003e4:	0005c703          	lbu	a4,0(a1)
    800003e8:	00e79863          	bne	a5,a4,800003f8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800003ec:	0505                	addi	a0,a0,1
    800003ee:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800003f0:	fed518e3          	bne	a0,a3,800003e0 <memcmp+0x14>
  }

  return 0;
    800003f4:	4501                	li	a0,0
    800003f6:	a019                	j	800003fc <memcmp+0x30>
      return *s1 - *s2;
    800003f8:	40e7853b          	subw	a0,a5,a4
}
    800003fc:	6422                	ld	s0,8(sp)
    800003fe:	0141                	addi	sp,sp,16
    80000400:	8082                	ret
  return 0;
    80000402:	4501                	li	a0,0
    80000404:	bfe5                	j	800003fc <memcmp+0x30>

0000000080000406 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000406:	1141                	addi	sp,sp,-16
    80000408:	e422                	sd	s0,8(sp)
    8000040a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000040c:	ca0d                	beqz	a2,8000043e <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000040e:	00a5f963          	bgeu	a1,a0,80000420 <memmove+0x1a>
    80000412:	02061693          	slli	a3,a2,0x20
    80000416:	9281                	srli	a3,a3,0x20
    80000418:	00d58733          	add	a4,a1,a3
    8000041c:	02e56463          	bltu	a0,a4,80000444 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000420:	fff6079b          	addiw	a5,a2,-1
    80000424:	1782                	slli	a5,a5,0x20
    80000426:	9381                	srli	a5,a5,0x20
    80000428:	0785                	addi	a5,a5,1
    8000042a:	97ae                	add	a5,a5,a1
    8000042c:	872a                	mv	a4,a0
      *d++ = *s++;
    8000042e:	0585                	addi	a1,a1,1
    80000430:	0705                	addi	a4,a4,1
    80000432:	fff5c683          	lbu	a3,-1(a1)
    80000436:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000043a:	fef59ae3          	bne	a1,a5,8000042e <memmove+0x28>

  return dst;
}
    8000043e:	6422                	ld	s0,8(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret
    d += n;
    80000444:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000446:	fff6079b          	addiw	a5,a2,-1
    8000044a:	1782                	slli	a5,a5,0x20
    8000044c:	9381                	srli	a5,a5,0x20
    8000044e:	fff7c793          	not	a5,a5
    80000452:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000454:	177d                	addi	a4,a4,-1
    80000456:	16fd                	addi	a3,a3,-1
    80000458:	00074603          	lbu	a2,0(a4)
    8000045c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000460:	fef71ae3          	bne	a4,a5,80000454 <memmove+0x4e>
    80000464:	bfe9                	j	8000043e <memmove+0x38>

0000000080000466 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000466:	1141                	addi	sp,sp,-16
    80000468:	e406                	sd	ra,8(sp)
    8000046a:	e022                	sd	s0,0(sp)
    8000046c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	f98080e7          	jalr	-104(ra) # 80000406 <memmove>
}
    80000476:	60a2                	ld	ra,8(sp)
    80000478:	6402                	ld	s0,0(sp)
    8000047a:	0141                	addi	sp,sp,16
    8000047c:	8082                	ret

000000008000047e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000047e:	1141                	addi	sp,sp,-16
    80000480:	e422                	sd	s0,8(sp)
    80000482:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000484:	ce11                	beqz	a2,800004a0 <strncmp+0x22>
    80000486:	00054783          	lbu	a5,0(a0)
    8000048a:	cf89                	beqz	a5,800004a4 <strncmp+0x26>
    8000048c:	0005c703          	lbu	a4,0(a1)
    80000490:	00f71a63          	bne	a4,a5,800004a4 <strncmp+0x26>
    n--, p++, q++;
    80000494:	367d                	addiw	a2,a2,-1
    80000496:	0505                	addi	a0,a0,1
    80000498:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000049a:	f675                	bnez	a2,80000486 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000049c:	4501                	li	a0,0
    8000049e:	a809                	j	800004b0 <strncmp+0x32>
    800004a0:	4501                	li	a0,0
    800004a2:	a039                	j	800004b0 <strncmp+0x32>
  if(n == 0)
    800004a4:	ca09                	beqz	a2,800004b6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800004a6:	00054503          	lbu	a0,0(a0)
    800004aa:	0005c783          	lbu	a5,0(a1)
    800004ae:	9d1d                	subw	a0,a0,a5
}
    800004b0:	6422                	ld	s0,8(sp)
    800004b2:	0141                	addi	sp,sp,16
    800004b4:	8082                	ret
    return 0;
    800004b6:	4501                	li	a0,0
    800004b8:	bfe5                	j	800004b0 <strncmp+0x32>

00000000800004ba <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800004ba:	1141                	addi	sp,sp,-16
    800004bc:	e422                	sd	s0,8(sp)
    800004be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800004c0:	872a                	mv	a4,a0
    800004c2:	8832                	mv	a6,a2
    800004c4:	367d                	addiw	a2,a2,-1
    800004c6:	01005963          	blez	a6,800004d8 <strncpy+0x1e>
    800004ca:	0705                	addi	a4,a4,1
    800004cc:	0005c783          	lbu	a5,0(a1)
    800004d0:	fef70fa3          	sb	a5,-1(a4)
    800004d4:	0585                	addi	a1,a1,1
    800004d6:	f7f5                	bnez	a5,800004c2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800004d8:	00c05d63          	blez	a2,800004f2 <strncpy+0x38>
    800004dc:	86ba                	mv	a3,a4
    *s++ = 0;
    800004de:	0685                	addi	a3,a3,1
    800004e0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800004e4:	fff6c793          	not	a5,a3
    800004e8:	9fb9                	addw	a5,a5,a4
    800004ea:	010787bb          	addw	a5,a5,a6
    800004ee:	fef048e3          	bgtz	a5,800004de <strncpy+0x24>
  return os;
}
    800004f2:	6422                	ld	s0,8(sp)
    800004f4:	0141                	addi	sp,sp,16
    800004f6:	8082                	ret

00000000800004f8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800004f8:	1141                	addi	sp,sp,-16
    800004fa:	e422                	sd	s0,8(sp)
    800004fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800004fe:	02c05363          	blez	a2,80000524 <safestrcpy+0x2c>
    80000502:	fff6069b          	addiw	a3,a2,-1
    80000506:	1682                	slli	a3,a3,0x20
    80000508:	9281                	srli	a3,a3,0x20
    8000050a:	96ae                	add	a3,a3,a1
    8000050c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000050e:	00d58963          	beq	a1,a3,80000520 <safestrcpy+0x28>
    80000512:	0585                	addi	a1,a1,1
    80000514:	0785                	addi	a5,a5,1
    80000516:	fff5c703          	lbu	a4,-1(a1)
    8000051a:	fee78fa3          	sb	a4,-1(a5)
    8000051e:	fb65                	bnez	a4,8000050e <safestrcpy+0x16>
    ;
  *s = 0;
    80000520:	00078023          	sb	zero,0(a5)
  return os;
}
    80000524:	6422                	ld	s0,8(sp)
    80000526:	0141                	addi	sp,sp,16
    80000528:	8082                	ret

000000008000052a <strlen>:

int
strlen(const char *s)
{
    8000052a:	1141                	addi	sp,sp,-16
    8000052c:	e422                	sd	s0,8(sp)
    8000052e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000530:	00054783          	lbu	a5,0(a0)
    80000534:	cf91                	beqz	a5,80000550 <strlen+0x26>
    80000536:	0505                	addi	a0,a0,1
    80000538:	87aa                	mv	a5,a0
    8000053a:	4685                	li	a3,1
    8000053c:	9e89                	subw	a3,a3,a0
    8000053e:	00f6853b          	addw	a0,a3,a5
    80000542:	0785                	addi	a5,a5,1
    80000544:	fff7c703          	lbu	a4,-1(a5)
    80000548:	fb7d                	bnez	a4,8000053e <strlen+0x14>
    ;
  return n;
}
    8000054a:	6422                	ld	s0,8(sp)
    8000054c:	0141                	addi	sp,sp,16
    8000054e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000550:	4501                	li	a0,0
    80000552:	bfe5                	j	8000054a <strlen+0x20>

0000000080000554 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000055c:	00001097          	auipc	ra,0x1
    80000560:	b1a080e7          	jalr	-1254(ra) # 80001076 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000564:	00009717          	auipc	a4,0x9
    80000568:	a9c70713          	addi	a4,a4,-1380 # 80009000 <started>
  if(cpuid() == 0){
    8000056c:	c139                	beqz	a0,800005b2 <main+0x5e>
    while(started == 0)
    8000056e:	431c                	lw	a5,0(a4)
    80000570:	2781                	sext.w	a5,a5
    80000572:	dff5                	beqz	a5,8000056e <main+0x1a>
      ;
    __sync_synchronize();
    80000574:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000578:	00001097          	auipc	ra,0x1
    8000057c:	afe080e7          	jalr	-1282(ra) # 80001076 <cpuid>
    80000580:	85aa                	mv	a1,a0
    80000582:	00008517          	auipc	a0,0x8
    80000586:	aee50513          	addi	a0,a0,-1298 # 80008070 <etext+0x70>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	948080e7          	jalr	-1720(ra) # 80005ed2 <printf>
    kvminithart();    // turn on paging
    80000592:	00000097          	auipc	ra,0x0
    80000596:	0d8080e7          	jalr	216(ra) # 8000066a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000059a:	00001097          	auipc	ra,0x1
    8000059e:	754080e7          	jalr	1876(ra) # 80001cee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800005a2:	00005097          	auipc	ra,0x5
    800005a6:	dbe080e7          	jalr	-578(ra) # 80005360 <plicinithart>
  }

  scheduler();        
    800005aa:	00001097          	auipc	ra,0x1
    800005ae:	002080e7          	jalr	2(ra) # 800015ac <scheduler>
    consoleinit();
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	7e8080e7          	jalr	2024(ra) # 80005d9a <consoleinit>
    printfinit();
    800005ba:	00006097          	auipc	ra,0x6
    800005be:	afe080e7          	jalr	-1282(ra) # 800060b8 <printfinit>
    printf("\n");
    800005c2:	00008517          	auipc	a0,0x8
    800005c6:	abe50513          	addi	a0,a0,-1346 # 80008080 <etext+0x80>
    800005ca:	00006097          	auipc	ra,0x6
    800005ce:	908080e7          	jalr	-1784(ra) # 80005ed2 <printf>
    printf("xv6 kernel is booting\n");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a8650513          	addi	a0,a0,-1402 # 80008058 <etext+0x58>
    800005da:	00006097          	auipc	ra,0x6
    800005de:	8f8080e7          	jalr	-1800(ra) # 80005ed2 <printf>
    printf("\n");
    800005e2:	00008517          	auipc	a0,0x8
    800005e6:	a9e50513          	addi	a0,a0,-1378 # 80008080 <etext+0x80>
    800005ea:	00006097          	auipc	ra,0x6
    800005ee:	8e8080e7          	jalr	-1816(ra) # 80005ed2 <printf>
    kinit();         // physical page allocator
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	bb0080e7          	jalr	-1104(ra) # 800001a2 <kinit>
    kvminit();       // create kernel page table
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	322080e7          	jalr	802(ra) # 8000091c <kvminit>
    kvminithart();   // turn on paging
    80000602:	00000097          	auipc	ra,0x0
    80000606:	068080e7          	jalr	104(ra) # 8000066a <kvminithart>
    procinit();      // process table
    8000060a:	00001097          	auipc	ra,0x1
    8000060e:	9bc080e7          	jalr	-1604(ra) # 80000fc6 <procinit>
    trapinit();      // trap vectors
    80000612:	00001097          	auipc	ra,0x1
    80000616:	6b4080e7          	jalr	1716(ra) # 80001cc6 <trapinit>
    trapinithart();  // install kernel trap vector
    8000061a:	00001097          	auipc	ra,0x1
    8000061e:	6d4080e7          	jalr	1748(ra) # 80001cee <trapinithart>
    plicinit();      // set up interrupt controller
    80000622:	00005097          	auipc	ra,0x5
    80000626:	d28080e7          	jalr	-728(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000062a:	00005097          	auipc	ra,0x5
    8000062e:	d36080e7          	jalr	-714(ra) # 80005360 <plicinithart>
    binit();         // buffer cache
    80000632:	00002097          	auipc	ra,0x2
    80000636:	f18080e7          	jalr	-232(ra) # 8000254a <binit>
    iinit();         // inode table
    8000063a:	00002097          	auipc	ra,0x2
    8000063e:	5a8080e7          	jalr	1448(ra) # 80002be2 <iinit>
    fileinit();      // file table
    80000642:	00003097          	auipc	ra,0x3
    80000646:	552080e7          	jalr	1362(ra) # 80003b94 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000064a:	00005097          	auipc	ra,0x5
    8000064e:	e38080e7          	jalr	-456(ra) # 80005482 <virtio_disk_init>
    userinit();      // first user process
    80000652:	00001097          	auipc	ra,0x1
    80000656:	d28080e7          	jalr	-728(ra) # 8000137a <userinit>
    __sync_synchronize();
    8000065a:	0ff0000f          	fence
    started = 1;
    8000065e:	4785                	li	a5,1
    80000660:	00009717          	auipc	a4,0x9
    80000664:	9af72023          	sw	a5,-1632(a4) # 80009000 <started>
    80000668:	b789                	j	800005aa <main+0x56>

000000008000066a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000066a:	1141                	addi	sp,sp,-16
    8000066c:	e422                	sd	s0,8(sp)
    8000066e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000670:	00009797          	auipc	a5,0x9
    80000674:	9987b783          	ld	a5,-1640(a5) # 80009008 <kernel_pagetable>
    80000678:	83b1                	srli	a5,a5,0xc
    8000067a:	577d                	li	a4,-1
    8000067c:	177e                	slli	a4,a4,0x3f
    8000067e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000680:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000684:	12000073          	sfence.vma
  sfence_vma();
}
    80000688:	6422                	ld	s0,8(sp)
    8000068a:	0141                	addi	sp,sp,16
    8000068c:	8082                	ret

000000008000068e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t*
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000068e:	7139                	addi	sp,sp,-64
    80000690:	fc06                	sd	ra,56(sp)
    80000692:	f822                	sd	s0,48(sp)
    80000694:	f426                	sd	s1,40(sp)
    80000696:	f04a                	sd	s2,32(sp)
    80000698:	ec4e                	sd	s3,24(sp)
    8000069a:	e852                	sd	s4,16(sp)
    8000069c:	e456                	sd	s5,8(sp)
    8000069e:	e05a                	sd	s6,0(sp)
    800006a0:	0080                	addi	s0,sp,64
    800006a2:	84aa                	mv	s1,a0
    800006a4:	89ae                	mv	s3,a1
    800006a6:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800006a8:	57fd                	li	a5,-1
    800006aa:	83e9                	srli	a5,a5,0x1a
    800006ac:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    800006ae:	4b31                	li	s6,12
  if (va >= MAXVA)
    800006b0:	04b7f263          	bgeu	a5,a1,800006f4 <walk+0x66>
    panic("walk");
    800006b4:	00008517          	auipc	a0,0x8
    800006b8:	9d450513          	addi	a0,a0,-1580 # 80008088 <etext+0x88>
    800006bc:	00005097          	auipc	ra,0x5
    800006c0:	7cc080e7          	jalr	1996(ra) # 80005e88 <panic>
    pte_t* pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else {
      if (!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800006c4:	060a8663          	beqz	s5,80000730 <walk+0xa2>
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	b4e080e7          	jalr	-1202(ra) # 80000216 <kalloc>
    800006d0:	84aa                	mv	s1,a0
    800006d2:	c529                	beqz	a0,8000071c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800006d4:	6605                	lui	a2,0x1
    800006d6:	4581                	li	a1,0
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	cce080e7          	jalr	-818(ra) # 800003a6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800006e0:	00c4d793          	srli	a5,s1,0xc
    800006e4:	07aa                	slli	a5,a5,0xa
    800006e6:	0017e793          	ori	a5,a5,1
    800006ea:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800006ee:	3a5d                	addiw	s4,s4,-9
    800006f0:	036a0063          	beq	s4,s6,80000710 <walk+0x82>
    pte_t* pte = &pagetable[PX(level, va)];
    800006f4:	0149d933          	srl	s2,s3,s4
    800006f8:	1ff97913          	andi	s2,s2,511
    800006fc:	090e                	slli	s2,s2,0x3
    800006fe:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000700:	00093483          	ld	s1,0(s2)
    80000704:	0014f793          	andi	a5,s1,1
    80000708:	dfd5                	beqz	a5,800006c4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000070a:	80a9                	srli	s1,s1,0xa
    8000070c:	04b2                	slli	s1,s1,0xc
    8000070e:	b7c5                	j	800006ee <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000710:	00c9d513          	srli	a0,s3,0xc
    80000714:	1ff57513          	andi	a0,a0,511
    80000718:	050e                	slli	a0,a0,0x3
    8000071a:	9526                	add	a0,a0,s1
}
    8000071c:	70e2                	ld	ra,56(sp)
    8000071e:	7442                	ld	s0,48(sp)
    80000720:	74a2                	ld	s1,40(sp)
    80000722:	7902                	ld	s2,32(sp)
    80000724:	69e2                	ld	s3,24(sp)
    80000726:	6a42                	ld	s4,16(sp)
    80000728:	6aa2                	ld	s5,8(sp)
    8000072a:	6b02                	ld	s6,0(sp)
    8000072c:	6121                	addi	sp,sp,64
    8000072e:	8082                	ret
        return 0;
    80000730:	4501                	li	a0,0
    80000732:	b7ed                	j	8000071c <walk+0x8e>

0000000080000734 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t* pte;
  uint64 pa;

  if (va >= MAXVA)
    80000734:	57fd                	li	a5,-1
    80000736:	83e9                	srli	a5,a5,0x1a
    80000738:	00b7f463          	bgeu	a5,a1,80000740 <walkaddr+0xc>
    return 0;
    8000073c:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000073e:	8082                	ret
{
    80000740:	1141                	addi	sp,sp,-16
    80000742:	e406                	sd	ra,8(sp)
    80000744:	e022                	sd	s0,0(sp)
    80000746:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000748:	4601                	li	a2,0
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f44080e7          	jalr	-188(ra) # 8000068e <walk>
  if (pte == 0)
    80000752:	c105                	beqz	a0,80000772 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000754:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000756:	0117f693          	andi	a3,a5,17
    8000075a:	4745                	li	a4,17
    return 0;
    8000075c:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000075e:	00e68663          	beq	a3,a4,8000076a <walkaddr+0x36>
}
    80000762:	60a2                	ld	ra,8(sp)
    80000764:	6402                	ld	s0,0(sp)
    80000766:	0141                	addi	sp,sp,16
    80000768:	8082                	ret
  pa = PTE2PA(*pte);
    8000076a:	00a7d513          	srli	a0,a5,0xa
    8000076e:	0532                	slli	a0,a0,0xc
  return pa;
    80000770:	bfcd                	j	80000762 <walkaddr+0x2e>
    return 0;
    80000772:	4501                	li	a0,0
    80000774:	b7fd                	j	80000762 <walkaddr+0x2e>

0000000080000776 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000776:	715d                	addi	sp,sp,-80
    80000778:	e486                	sd	ra,72(sp)
    8000077a:	e0a2                	sd	s0,64(sp)
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	f84a                	sd	s2,48(sp)
    80000780:	f44e                	sd	s3,40(sp)
    80000782:	f052                	sd	s4,32(sp)
    80000784:	ec56                	sd	s5,24(sp)
    80000786:	e85a                	sd	s6,16(sp)
    80000788:	e45e                	sd	s7,8(sp)
    8000078a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t* pte;

  if (size == 0)
    8000078c:	c205                	beqz	a2,800007ac <mappages+0x36>
    8000078e:	8aaa                	mv	s5,a0
    80000790:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    80000792:	77fd                	lui	a5,0xfffff
    80000794:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000798:	15fd                	addi	a1,a1,-1
    8000079a:	00c589b3          	add	s3,a1,a2
    8000079e:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800007a2:	8952                	mv	s2,s4
    800007a4:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800007a8:	6b85                	lui	s7,0x1
    800007aa:	a015                	j	800007ce <mappages+0x58>
    panic("mappages: size");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	8e450513          	addi	a0,a0,-1820 # 80008090 <etext+0x90>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	6d4080e7          	jalr	1748(ra) # 80005e88 <panic>
      panic("mappages: remap");
    800007bc:	00008517          	auipc	a0,0x8
    800007c0:	8e450513          	addi	a0,a0,-1820 # 800080a0 <etext+0xa0>
    800007c4:	00005097          	auipc	ra,0x5
    800007c8:	6c4080e7          	jalr	1732(ra) # 80005e88 <panic>
    a += PGSIZE;
    800007cc:	995e                	add	s2,s2,s7
  for (;;) {
    800007ce:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800007d2:	4605                	li	a2,1
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8556                	mv	a0,s5
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	eb6080e7          	jalr	-330(ra) # 8000068e <walk>
    800007e0:	cd19                	beqz	a0,800007fe <mappages+0x88>
    if (*pte & PTE_V)
    800007e2:	611c                	ld	a5,0(a0)
    800007e4:	8b85                	andi	a5,a5,1
    800007e6:	fbf9                	bnez	a5,800007bc <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007e8:	80b1                	srli	s1,s1,0xc
    800007ea:	04aa                	slli	s1,s1,0xa
    800007ec:	0164e4b3          	or	s1,s1,s6
    800007f0:	0014e493          	ori	s1,s1,1
    800007f4:	e104                	sd	s1,0(a0)
    if (a == last)
    800007f6:	fd391be3          	bne	s2,s3,800007cc <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800007fa:	4501                	li	a0,0
    800007fc:	a011                	j	80000800 <mappages+0x8a>
      return -1;
    800007fe:	557d                	li	a0,-1
}
    80000800:	60a6                	ld	ra,72(sp)
    80000802:	6406                	ld	s0,64(sp)
    80000804:	74e2                	ld	s1,56(sp)
    80000806:	7942                	ld	s2,48(sp)
    80000808:	79a2                	ld	s3,40(sp)
    8000080a:	7a02                	ld	s4,32(sp)
    8000080c:	6ae2                	ld	s5,24(sp)
    8000080e:	6b42                	ld	s6,16(sp)
    80000810:	6ba2                	ld	s7,8(sp)
    80000812:	6161                	addi	sp,sp,80
    80000814:	8082                	ret

0000000080000816 <kvmmap>:
{
    80000816:	1141                	addi	sp,sp,-16
    80000818:	e406                	sd	ra,8(sp)
    8000081a:	e022                	sd	s0,0(sp)
    8000081c:	0800                	addi	s0,sp,16
    8000081e:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000820:	86b2                	mv	a3,a2
    80000822:	863e                	mv	a2,a5
    80000824:	00000097          	auipc	ra,0x0
    80000828:	f52080e7          	jalr	-174(ra) # 80000776 <mappages>
    8000082c:	e509                	bnez	a0,80000836 <kvmmap+0x20>
}
    8000082e:	60a2                	ld	ra,8(sp)
    80000830:	6402                	ld	s0,0(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret
    panic("kvmmap");
    80000836:	00008517          	auipc	a0,0x8
    8000083a:	87a50513          	addi	a0,a0,-1926 # 800080b0 <etext+0xb0>
    8000083e:	00005097          	auipc	ra,0x5
    80000842:	64a080e7          	jalr	1610(ra) # 80005e88 <panic>

0000000080000846 <kvmmake>:
{
    80000846:	1101                	addi	sp,sp,-32
    80000848:	ec06                	sd	ra,24(sp)
    8000084a:	e822                	sd	s0,16(sp)
    8000084c:	e426                	sd	s1,8(sp)
    8000084e:	e04a                	sd	s2,0(sp)
    80000850:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000852:	00000097          	auipc	ra,0x0
    80000856:	9c4080e7          	jalr	-1596(ra) # 80000216 <kalloc>
    8000085a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000085c:	6605                	lui	a2,0x1
    8000085e:	4581                	li	a1,0
    80000860:	00000097          	auipc	ra,0x0
    80000864:	b46080e7          	jalr	-1210(ra) # 800003a6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000868:	4719                	li	a4,6
    8000086a:	6685                	lui	a3,0x1
    8000086c:	10000637          	lui	a2,0x10000
    80000870:	100005b7          	lui	a1,0x10000
    80000874:	8526                	mv	a0,s1
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	fa0080e7          	jalr	-96(ra) # 80000816 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000087e:	4719                	li	a4,6
    80000880:	6685                	lui	a3,0x1
    80000882:	10001637          	lui	a2,0x10001
    80000886:	100015b7          	lui	a1,0x10001
    8000088a:	8526                	mv	a0,s1
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	f8a080e7          	jalr	-118(ra) # 80000816 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000894:	4719                	li	a4,6
    80000896:	004006b7          	lui	a3,0x400
    8000089a:	0c000637          	lui	a2,0xc000
    8000089e:	0c0005b7          	lui	a1,0xc000
    800008a2:	8526                	mv	a0,s1
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	f72080e7          	jalr	-142(ra) # 80000816 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800008ac:	00007917          	auipc	s2,0x7
    800008b0:	75490913          	addi	s2,s2,1876 # 80008000 <etext>
    800008b4:	4729                	li	a4,10
    800008b6:	80007697          	auipc	a3,0x80007
    800008ba:	74a68693          	addi	a3,a3,1866 # 8000 <_entry-0x7fff8000>
    800008be:	4605                	li	a2,1
    800008c0:	067e                	slli	a2,a2,0x1f
    800008c2:	85b2                	mv	a1,a2
    800008c4:	8526                	mv	a0,s1
    800008c6:	00000097          	auipc	ra,0x0
    800008ca:	f50080e7          	jalr	-176(ra) # 80000816 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800008ce:	4719                	li	a4,6
    800008d0:	46c5                	li	a3,17
    800008d2:	06ee                	slli	a3,a3,0x1b
    800008d4:	412686b3          	sub	a3,a3,s2
    800008d8:	864a                	mv	a2,s2
    800008da:	85ca                	mv	a1,s2
    800008dc:	8526                	mv	a0,s1
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	f38080e7          	jalr	-200(ra) # 80000816 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800008e6:	4729                	li	a4,10
    800008e8:	6685                	lui	a3,0x1
    800008ea:	00006617          	auipc	a2,0x6
    800008ee:	71660613          	addi	a2,a2,1814 # 80007000 <_trampoline>
    800008f2:	040005b7          	lui	a1,0x4000
    800008f6:	15fd                	addi	a1,a1,-1
    800008f8:	05b2                	slli	a1,a1,0xc
    800008fa:	8526                	mv	a0,s1
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	f1a080e7          	jalr	-230(ra) # 80000816 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000904:	8526                	mv	a0,s1
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	62a080e7          	jalr	1578(ra) # 80000f30 <proc_mapstacks>
}
    8000090e:	8526                	mv	a0,s1
    80000910:	60e2                	ld	ra,24(sp)
    80000912:	6442                	ld	s0,16(sp)
    80000914:	64a2                	ld	s1,8(sp)
    80000916:	6902                	ld	s2,0(sp)
    80000918:	6105                	addi	sp,sp,32
    8000091a:	8082                	ret

000000008000091c <kvminit>:
{
    8000091c:	1141                	addi	sp,sp,-16
    8000091e:	e406                	sd	ra,8(sp)
    80000920:	e022                	sd	s0,0(sp)
    80000922:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f22080e7          	jalr	-222(ra) # 80000846 <kvmmake>
    8000092c:	00008797          	auipc	a5,0x8
    80000930:	6ca7be23          	sd	a0,1756(a5) # 80009008 <kernel_pagetable>
}
    80000934:	60a2                	ld	ra,8(sp)
    80000936:	6402                	ld	s0,0(sp)
    80000938:	0141                	addi	sp,sp,16
    8000093a:	8082                	ret

000000008000093c <uvmunmap>:
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t* pte;

  if (va > MAXVA)
    8000093c:	4785                	li	a5,1
    8000093e:	179a                	slli	a5,a5,0x26
    80000940:	0cb7e563          	bltu	a5,a1,80000a0a <uvmunmap+0xce>
{
    80000944:	715d                	addi	sp,sp,-80
    80000946:	e486                	sd	ra,72(sp)
    80000948:	e0a2                	sd	s0,64(sp)
    8000094a:	fc26                	sd	s1,56(sp)
    8000094c:	f84a                	sd	s2,48(sp)
    8000094e:	f44e                	sd	s3,40(sp)
    80000950:	f052                	sd	s4,32(sp)
    80000952:	ec56                	sd	s5,24(sp)
    80000954:	e85a                	sd	s6,16(sp)
    80000956:	e45e                	sd	s7,8(sp)
    80000958:	0880                	addi	s0,sp,80
    8000095a:	8a2a                	mv	s4,a0
    8000095c:	892e                	mv	s2,a1
    8000095e:	8ab6                	mv	s5,a3
    return;

  if ((va % PGSIZE) != 0)
    80000960:	03459793          	slli	a5,a1,0x34
    80000964:	e39d                	bnez	a5,8000098a <uvmunmap+0x4e>
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000966:	0632                	slli	a2,a2,0xc
    80000968:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000096c:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000096e:	6b05                	lui	s6,0x1
    80000970:	0735e963          	bltu	a1,s3,800009e2 <uvmunmap+0xa6>
    {
      kfree((void*)(pa));
    }
    *pte = 0;
  }
}
    80000974:	60a6                	ld	ra,72(sp)
    80000976:	6406                	ld	s0,64(sp)
    80000978:	74e2                	ld	s1,56(sp)
    8000097a:	7942                	ld	s2,48(sp)
    8000097c:	79a2                	ld	s3,40(sp)
    8000097e:	7a02                	ld	s4,32(sp)
    80000980:	6ae2                	ld	s5,24(sp)
    80000982:	6b42                	ld	s6,16(sp)
    80000984:	6ba2                	ld	s7,8(sp)
    80000986:	6161                	addi	sp,sp,80
    80000988:	8082                	ret
    panic("uvmunmap: not aligned");
    8000098a:	00007517          	auipc	a0,0x7
    8000098e:	72e50513          	addi	a0,a0,1838 # 800080b8 <etext+0xb8>
    80000992:	00005097          	auipc	ra,0x5
    80000996:	4f6080e7          	jalr	1270(ra) # 80005e88 <panic>
      panic("uvmunmap: walk");
    8000099a:	00007517          	auipc	a0,0x7
    8000099e:	73650513          	addi	a0,a0,1846 # 800080d0 <etext+0xd0>
    800009a2:	00005097          	auipc	ra,0x5
    800009a6:	4e6080e7          	jalr	1254(ra) # 80005e88 <panic>
      panic("uvmunmap: not mapped");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	73650513          	addi	a0,a0,1846 # 800080e0 <etext+0xe0>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	4d6080e7          	jalr	1238(ra) # 80005e88 <panic>
      panic("uvmunmap: not a leaf");
    800009ba:	00007517          	auipc	a0,0x7
    800009be:	73e50513          	addi	a0,a0,1854 # 800080f8 <etext+0xf8>
    800009c2:	00005097          	auipc	ra,0x5
    800009c6:	4c6080e7          	jalr	1222(ra) # 80005e88 <panic>
    uint64 pa = PTE2PA(*pte);
    800009ca:	83a9                	srli	a5,a5,0xa
      kfree((void*)(pa));
    800009cc:	00c79513          	slli	a0,a5,0xc
    800009d0:	fffff097          	auipc	ra,0xfffff
    800009d4:	64c080e7          	jalr	1612(ra) # 8000001c <kfree>
    *pte = 0;
    800009d8:	0004b023          	sd	zero,0(s1) # ffffffff80000000 <end+0xfffffffeffed9dc0>
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800009dc:	995a                	add	s2,s2,s6
    800009de:	f9397be3          	bgeu	s2,s3,80000974 <uvmunmap+0x38>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800009e2:	4601                	li	a2,0
    800009e4:	85ca                	mv	a1,s2
    800009e6:	8552                	mv	a0,s4
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	ca6080e7          	jalr	-858(ra) # 8000068e <walk>
    800009f0:	84aa                	mv	s1,a0
    800009f2:	d545                	beqz	a0,8000099a <uvmunmap+0x5e>
    if ((*pte & PTE_V) == 0)
    800009f4:	611c                	ld	a5,0(a0)
    800009f6:	0017f713          	andi	a4,a5,1
    800009fa:	db45                	beqz	a4,800009aa <uvmunmap+0x6e>
    if (PTE_FLAGS(*pte) == PTE_V)
    800009fc:	3ff7f713          	andi	a4,a5,1023
    80000a00:	fb770de3          	beq	a4,s7,800009ba <uvmunmap+0x7e>
    if (do_free)
    80000a04:	fc0a8ae3          	beqz	s5,800009d8 <uvmunmap+0x9c>
    80000a08:	b7c9                	j	800009ca <uvmunmap+0x8e>
    80000a0a:	8082                	ret

0000000080000a0c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	800080e7          	jalr	-2048(ra) # 80000216 <kalloc>
    80000a1e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000a20:	c519                	beqz	a0,80000a2e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000a22:	6605                	lui	a2,0x1
    80000a24:	4581                	li	a1,0
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	980080e7          	jalr	-1664(ra) # 800003a6 <memset>
  return pagetable;
}
    80000a2e:	8526                	mv	a0,s1
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret

0000000080000a3a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar* src, uint sz)
{
    80000a3a:	7179                	addi	sp,sp,-48
    80000a3c:	f406                	sd	ra,40(sp)
    80000a3e:	f022                	sd	s0,32(sp)
    80000a40:	ec26                	sd	s1,24(sp)
    80000a42:	e84a                	sd	s2,16(sp)
    80000a44:	e44e                	sd	s3,8(sp)
    80000a46:	e052                	sd	s4,0(sp)
    80000a48:	1800                	addi	s0,sp,48
  char* mem;

  if (sz >= PGSIZE)
    80000a4a:	6785                	lui	a5,0x1
    80000a4c:	04f67863          	bgeu	a2,a5,80000a9c <uvminit+0x62>
    80000a50:	8a2a                	mv	s4,a0
    80000a52:	89ae                	mv	s3,a1
    80000a54:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	7c0080e7          	jalr	1984(ra) # 80000216 <kalloc>
    80000a5e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	4581                	li	a1,0
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	942080e7          	jalr	-1726(ra) # 800003a6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000a6c:	4779                	li	a4,30
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	4581                	li	a1,0
    80000a74:	8552                	mv	a0,s4
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	d00080e7          	jalr	-768(ra) # 80000776 <mappages>
  memmove(mem, src, sz);
    80000a7e:	8626                	mv	a2,s1
    80000a80:	85ce                	mv	a1,s3
    80000a82:	854a                	mv	a0,s2
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	982080e7          	jalr	-1662(ra) # 80000406 <memmove>
}
    80000a8c:	70a2                	ld	ra,40(sp)
    80000a8e:	7402                	ld	s0,32(sp)
    80000a90:	64e2                	ld	s1,24(sp)
    80000a92:	6942                	ld	s2,16(sp)
    80000a94:	69a2                	ld	s3,8(sp)
    80000a96:	6a02                	ld	s4,0(sp)
    80000a98:	6145                	addi	sp,sp,48
    80000a9a:	8082                	ret
    panic("inituvm: more than a page");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	67450513          	addi	a0,a0,1652 # 80008110 <etext+0x110>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	3e4080e7          	jalr	996(ra) # 80005e88 <panic>

0000000080000aac <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000aac:	1101                	addi	sp,sp,-32
    80000aae:	ec06                	sd	ra,24(sp)
    80000ab0:	e822                	sd	s0,16(sp)
    80000ab2:	e426                	sd	s1,8(sp)
    80000ab4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000ab6:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80000ab8:	00b67d63          	bgeu	a2,a1,80000ad2 <uvmdealloc+0x26>
    80000abc:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000abe:	6785                	lui	a5,0x1
    80000ac0:	17fd                	addi	a5,a5,-1
    80000ac2:	00f60733          	add	a4,a2,a5
    80000ac6:	767d                	lui	a2,0xfffff
    80000ac8:	8f71                	and	a4,a4,a2
    80000aca:	97ae                	add	a5,a5,a1
    80000acc:	8ff1                	and	a5,a5,a2
    80000ace:	00f76863          	bltu	a4,a5,80000ade <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000ad2:	8526                	mv	a0,s1
    80000ad4:	60e2                	ld	ra,24(sp)
    80000ad6:	6442                	ld	s0,16(sp)
    80000ad8:	64a2                	ld	s1,8(sp)
    80000ada:	6105                	addi	sp,sp,32
    80000adc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000ade:	8f99                	sub	a5,a5,a4
    80000ae0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000ae2:	4685                	li	a3,1
    80000ae4:	0007861b          	sext.w	a2,a5
    80000ae8:	85ba                	mv	a1,a4
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	e52080e7          	jalr	-430(ra) # 8000093c <uvmunmap>
    80000af2:	b7c5                	j	80000ad2 <uvmdealloc+0x26>

0000000080000af4 <uvmalloc>:
  if (newsz < oldsz)
    80000af4:	0ab66163          	bltu	a2,a1,80000b96 <uvmalloc+0xa2>
{
    80000af8:	7139                	addi	sp,sp,-64
    80000afa:	fc06                	sd	ra,56(sp)
    80000afc:	f822                	sd	s0,48(sp)
    80000afe:	f426                	sd	s1,40(sp)
    80000b00:	f04a                	sd	s2,32(sp)
    80000b02:	ec4e                	sd	s3,24(sp)
    80000b04:	e852                	sd	s4,16(sp)
    80000b06:	e456                	sd	s5,8(sp)
    80000b08:	0080                	addi	s0,sp,64
    80000b0a:	8aaa                	mv	s5,a0
    80000b0c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000b0e:	6985                	lui	s3,0x1
    80000b10:	19fd                	addi	s3,s3,-1
    80000b12:	95ce                	add	a1,a1,s3
    80000b14:	79fd                	lui	s3,0xfffff
    80000b16:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000b1a:	08c9f063          	bgeu	s3,a2,80000b9a <uvmalloc+0xa6>
    80000b1e:	894e                	mv	s2,s3
    mem = kalloc();
    80000b20:	fffff097          	auipc	ra,0xfffff
    80000b24:	6f6080e7          	jalr	1782(ra) # 80000216 <kalloc>
    80000b28:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000b2a:	c51d                	beqz	a0,80000b58 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000b2c:	6605                	lui	a2,0x1
    80000b2e:	4581                	li	a1,0
    80000b30:	00000097          	auipc	ra,0x0
    80000b34:	876080e7          	jalr	-1930(ra) # 800003a6 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
    80000b38:	4779                	li	a4,30
    80000b3a:	86a6                	mv	a3,s1
    80000b3c:	6605                	lui	a2,0x1
    80000b3e:	85ca                	mv	a1,s2
    80000b40:	8556                	mv	a0,s5
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	c34080e7          	jalr	-972(ra) # 80000776 <mappages>
    80000b4a:	e905                	bnez	a0,80000b7a <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000b4c:	6785                	lui	a5,0x1
    80000b4e:	993e                	add	s2,s2,a5
    80000b50:	fd4968e3          	bltu	s2,s4,80000b20 <uvmalloc+0x2c>
  return newsz;
    80000b54:	8552                	mv	a0,s4
    80000b56:	a809                	j	80000b68 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000b58:	864e                	mv	a2,s3
    80000b5a:	85ca                	mv	a1,s2
    80000b5c:	8556                	mv	a0,s5
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	f4e080e7          	jalr	-178(ra) # 80000aac <uvmdealloc>
      return 0;
    80000b66:	4501                	li	a0,0
}
    80000b68:	70e2                	ld	ra,56(sp)
    80000b6a:	7442                	ld	s0,48(sp)
    80000b6c:	74a2                	ld	s1,40(sp)
    80000b6e:	7902                	ld	s2,32(sp)
    80000b70:	69e2                	ld	s3,24(sp)
    80000b72:	6a42                	ld	s4,16(sp)
    80000b74:	6aa2                	ld	s5,8(sp)
    80000b76:	6121                	addi	sp,sp,64
    80000b78:	8082                	ret
      kfree(mem);
    80000b7a:	8526                	mv	a0,s1
    80000b7c:	fffff097          	auipc	ra,0xfffff
    80000b80:	4a0080e7          	jalr	1184(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b84:	864e                	mv	a2,s3
    80000b86:	85ca                	mv	a1,s2
    80000b88:	8556                	mv	a0,s5
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	f22080e7          	jalr	-222(ra) # 80000aac <uvmdealloc>
      return 0;
    80000b92:	4501                	li	a0,0
    80000b94:	bfd1                	j	80000b68 <uvmalloc+0x74>
    return oldsz;
    80000b96:	852e                	mv	a0,a1
}
    80000b98:	8082                	ret
  return newsz;
    80000b9a:	8532                	mv	a0,a2
    80000b9c:	b7f1                	j	80000b68 <uvmalloc+0x74>

0000000080000b9e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b9e:	7179                	addi	sp,sp,-48
    80000ba0:	f406                	sd	ra,40(sp)
    80000ba2:	f022                	sd	s0,32(sp)
    80000ba4:	ec26                	sd	s1,24(sp)
    80000ba6:	e84a                	sd	s2,16(sp)
    80000ba8:	e44e                	sd	s3,8(sp)
    80000baa:	e052                	sd	s4,0(sp)
    80000bac:	1800                	addi	s0,sp,48
    80000bae:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000bb0:	84aa                	mv	s1,a0
    80000bb2:	6905                	lui	s2,0x1
    80000bb4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000bb6:	4985                	li	s3,1
    80000bb8:	a821                	j	80000bd0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000bba:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000bbc:	0532                	slli	a0,a0,0xc
    80000bbe:	00000097          	auipc	ra,0x0
    80000bc2:	fe0080e7          	jalr	-32(ra) # 80000b9e <freewalk>
      pagetable[i] = 0;
    80000bc6:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000bca:	04a1                	addi	s1,s1,8
    80000bcc:	03248163          	beq	s1,s2,80000bee <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000bd0:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000bd2:	00f57793          	andi	a5,a0,15
    80000bd6:	ff3782e3          	beq	a5,s3,80000bba <freewalk+0x1c>
    }
    else if (pte & PTE_V) {
    80000bda:	8905                	andi	a0,a0,1
    80000bdc:	d57d                	beqz	a0,80000bca <freewalk+0x2c>
      panic("freewalk: leaf");
    80000bde:	00007517          	auipc	a0,0x7
    80000be2:	55250513          	addi	a0,a0,1362 # 80008130 <etext+0x130>
    80000be6:	00005097          	auipc	ra,0x5
    80000bea:	2a2080e7          	jalr	674(ra) # 80005e88 <panic>
    }
  }
  kfree((void*)pagetable);
    80000bee:	8552                	mv	a0,s4
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	42c080e7          	jalr	1068(ra) # 8000001c <kfree>
}
    80000bf8:	70a2                	ld	ra,40(sp)
    80000bfa:	7402                	ld	s0,32(sp)
    80000bfc:	64e2                	ld	s1,24(sp)
    80000bfe:	6942                	ld	s2,16(sp)
    80000c00:	69a2                	ld	s3,8(sp)
    80000c02:	6a02                	ld	s4,0(sp)
    80000c04:	6145                	addi	sp,sp,48
    80000c06:	8082                	ret

0000000080000c08 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000c08:	1101                	addi	sp,sp,-32
    80000c0a:	ec06                	sd	ra,24(sp)
    80000c0c:	e822                	sd	s0,16(sp)
    80000c0e:	e426                	sd	s1,8(sp)
    80000c10:	1000                	addi	s0,sp,32
    80000c12:	84aa                	mv	s1,a0
  if (sz > 0)
    80000c14:	e999                	bnez	a1,80000c2a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	f86080e7          	jalr	-122(ra) # 80000b9e <freewalk>
}
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	addi	sp,sp,32
    80000c28:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000c2a:	6605                	lui	a2,0x1
    80000c2c:	167d                	addi	a2,a2,-1
    80000c2e:	962e                	add	a2,a2,a1
    80000c30:	4685                	li	a3,1
    80000c32:	8231                	srli	a2,a2,0xc
    80000c34:	4581                	li	a1,0
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	d06080e7          	jalr	-762(ra) # 8000093c <uvmunmap>
    80000c3e:	bfe1                	j	80000c16 <uvmfree+0xe>

0000000080000c40 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000c40:	7139                	addi	sp,sp,-64
    80000c42:	fc06                	sd	ra,56(sp)
    80000c44:	f822                	sd	s0,48(sp)
    80000c46:	f426                	sd	s1,40(sp)
    80000c48:	f04a                	sd	s2,32(sp)
    80000c4a:	ec4e                	sd	s3,24(sp)
    80000c4c:	e852                	sd	s4,16(sp)
    80000c4e:	e456                	sd	s5,8(sp)
    80000c50:	e05a                	sd	s6,0(sp)
    80000c52:	0080                	addi	s0,sp,64
  pte_t* pte;
  uint64 pa, i;
  uint flags;
  //char *mem;
  if (sz > MAXVA)
    80000c54:	4785                	li	a5,1
    80000c56:	179a                	slli	a5,a5,0x26
    80000c58:	0ac7ea63          	bltu	a5,a2,80000d0c <uvmcopy+0xcc>
    80000c5c:	8aaa                	mv	s5,a0
    80000c5e:	8a2e                	mv	s4,a1
    return -1;
  for (i = 0; i < sz; i += PGSIZE) {
    80000c60:	ca45                	beqz	a2,80000d10 <uvmcopy+0xd0>
    80000c62:	167d                	addi	a2,a2,-1
    80000c64:	79fd                	lui	s3,0xfffff
    80000c66:	013679b3          	and	s3,a2,s3
    80000c6a:	4481                	li	s1,0
    80000c6c:	a011                	j	80000c70 <uvmcopy+0x30>
    80000c6e:	84be                	mv	s1,a5
    if ((pte = walk(old, i, 0)) == 0)
    80000c70:	4601                	li	a2,0
    80000c72:	85a6                	mv	a1,s1
    80000c74:	8556                	mv	a0,s5
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	a18080e7          	jalr	-1512(ra) # 8000068e <walk>
    80000c7e:	c131                	beqz	a0,80000cc2 <uvmcopy+0x82>
      panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
    80000c80:	6118                	ld	a4,0(a0)
    80000c82:	00177793          	andi	a5,a4,1
    80000c86:	c7b1                	beqz	a5,80000cd2 <uvmcopy+0x92>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000c88:	00a75913          	srli	s2,a4,0xa
    80000c8c:	0932                	slli	s2,s2,0xc
    *pte &= (~PTE_W);
    80000c8e:	9b6d                	andi	a4,a4,-5
    *pte |= (PTE_F);
    80000c90:	10076713          	ori	a4,a4,256
    80000c94:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    //if((mem = kalloc()) == 0)
      //goto err;
    //memmove(mem, (char*)pa, PGSIZE);

    if (mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) {
    80000c96:	3fb77713          	andi	a4,a4,1019
    80000c9a:	86ca                	mv	a3,s2
    80000c9c:	6605                	lui	a2,0x1
    80000c9e:	85a6                	mv	a1,s1
    80000ca0:	8552                	mv	a0,s4
    80000ca2:	00000097          	auipc	ra,0x0
    80000ca6:	ad4080e7          	jalr	-1324(ra) # 80000776 <mappages>
    80000caa:	8b2a                	mv	s6,a0
    80000cac:	e91d                	bnez	a0,80000ce2 <uvmcopy+0xa2>
      //kfree(mem);
      goto err;
    }
    krefadd((void*)pa);
    80000cae:	854a                	mv	a0,s2
    80000cb0:	fffff097          	auipc	ra,0xfffff
    80000cb4:	61e080e7          	jalr	1566(ra) # 800002ce <krefadd>
  for (i = 0; i < sz; i += PGSIZE) {
    80000cb8:	6785                	lui	a5,0x1
    80000cba:	97a6                	add	a5,a5,s1
    80000cbc:	fa9999e3          	bne	s3,s1,80000c6e <uvmcopy+0x2e>
    80000cc0:	a81d                	j	80000cf6 <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	47e50513          	addi	a0,a0,1150 # 80008140 <etext+0x140>
    80000cca:	00005097          	auipc	ra,0x5
    80000cce:	1be080e7          	jalr	446(ra) # 80005e88 <panic>
      panic("uvmcopy: page not present");
    80000cd2:	00007517          	auipc	a0,0x7
    80000cd6:	48e50513          	addi	a0,a0,1166 # 80008160 <etext+0x160>
    80000cda:	00005097          	auipc	ra,0x5
    80000cde:	1ae080e7          	jalr	430(ra) # 80005e88 <panic>
  }
  return 0;

err:

  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ce2:	4685                	li	a3,1
    80000ce4:	00c4d613          	srli	a2,s1,0xc
    80000ce8:	4581                	li	a1,0
    80000cea:	8552                	mv	a0,s4
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	c50080e7          	jalr	-944(ra) # 8000093c <uvmunmap>
  return -1;
    80000cf4:	5b7d                	li	s6,-1
}
    80000cf6:	855a                	mv	a0,s6
    80000cf8:	70e2                	ld	ra,56(sp)
    80000cfa:	7442                	ld	s0,48(sp)
    80000cfc:	74a2                	ld	s1,40(sp)
    80000cfe:	7902                	ld	s2,32(sp)
    80000d00:	69e2                	ld	s3,24(sp)
    80000d02:	6a42                	ld	s4,16(sp)
    80000d04:	6aa2                	ld	s5,8(sp)
    80000d06:	6b02                	ld	s6,0(sp)
    80000d08:	6121                	addi	sp,sp,64
    80000d0a:	8082                	ret
    return -1;
    80000d0c:	5b7d                	li	s6,-1
    80000d0e:	b7e5                	j	80000cf6 <uvmcopy+0xb6>
  return 0;
    80000d10:	4b01                	li	s6,0
    80000d12:	b7d5                	j	80000cf6 <uvmcopy+0xb6>

0000000080000d14 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000d14:	1141                	addi	sp,sp,-16
    80000d16:	e406                	sd	ra,8(sp)
    80000d18:	e022                	sd	s0,0(sp)
    80000d1a:	0800                	addi	s0,sp,16
  pte_t* pte;
  pte = walk(pagetable, va, 0);
    80000d1c:	4601                	li	a2,0
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	970080e7          	jalr	-1680(ra) # 8000068e <walk>
  if (pte == 0)
    80000d26:	c901                	beqz	a0,80000d36 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000d28:	611c                	ld	a5,0(a0)
    80000d2a:	9bbd                	andi	a5,a5,-17
    80000d2c:	e11c                	sd	a5,0(a0)
}
    80000d2e:	60a2                	ld	ra,8(sp)
    80000d30:	6402                	ld	s0,0(sp)
    80000d32:	0141                	addi	sp,sp,16
    80000d34:	8082                	ret
    panic("uvmclear");
    80000d36:	00007517          	auipc	a0,0x7
    80000d3a:	44a50513          	addi	a0,a0,1098 # 80008180 <etext+0x180>
    80000d3e:	00005097          	auipc	ra,0x5
    80000d42:	14a080e7          	jalr	330(ra) # 80005e88 <panic>

0000000080000d46 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char* src, uint64 len)
{
    80000d46:	715d                	addi	sp,sp,-80
    80000d48:	e486                	sd	ra,72(sp)
    80000d4a:	e0a2                	sd	s0,64(sp)
    80000d4c:	fc26                	sd	s1,56(sp)
    80000d4e:	f84a                	sd	s2,48(sp)
    80000d50:	f44e                	sd	s3,40(sp)
    80000d52:	f052                	sd	s4,32(sp)
    80000d54:	ec56                	sd	s5,24(sp)
    80000d56:	e85a                	sd	s6,16(sp)
    80000d58:	e45e                	sd	s7,8(sp)
    80000d5a:	e062                	sd	s8,0(sp)
    80000d5c:	0880                	addi	s0,sp,80
    80000d5e:	8b2a                	mv	s6,a0
    80000d60:	8c2e                	mv	s8,a1
    80000d62:	8a32                	mv	s4,a2
    80000d64:	89b6                	mv	s3,a3
  uint64 n, va0, pa0;
  if (cowpagefault(pagetable, dstva))
    80000d66:	00001097          	auipc	ra,0x1
    80000d6a:	fa0080e7          	jalr	-96(ra) # 80001d06 <cowpagefault>
    80000d6e:	e511                	bnez	a0,80000d7a <copyout+0x34>
  {
    if (cowpagealloc(pagetable, dstva) == 0)
      return -1;
  }

  while (len > 0) {
    80000d70:	06098163          	beqz	s3,80000dd2 <copyout+0x8c>
    va0 = PGROUNDDOWN(dstva);
    80000d74:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000d76:	6a85                	lui	s5,0x1
    80000d78:	a81d                	j	80000dae <copyout+0x68>
    if (cowpagealloc(pagetable, dstva) == 0)
    80000d7a:	85e2                	mv	a1,s8
    80000d7c:	855a                	mv	a0,s6
    80000d7e:	00001097          	auipc	ra,0x1
    80000d82:	fc2080e7          	jalr	-62(ra) # 80001d40 <cowpagealloc>
    80000d86:	f56d                	bnez	a0,80000d70 <copyout+0x2a>
      return -1;
    80000d88:	557d                	li	a0,-1
    80000d8a:	a0b9                	j	80000dd8 <copyout+0x92>
    if (n > len)
      n = len;
    memmove((void*)(pa0 + (dstva - va0)), src, n);
    80000d8c:	9562                	add	a0,a0,s8
    80000d8e:	0004861b          	sext.w	a2,s1
    80000d92:	85d2                	mv	a1,s4
    80000d94:	41250533          	sub	a0,a0,s2
    80000d98:	fffff097          	auipc	ra,0xfffff
    80000d9c:	66e080e7          	jalr	1646(ra) # 80000406 <memmove>

    len -= n;
    80000da0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000da4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000da6:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000daa:	02098263          	beqz	s3,80000dce <copyout+0x88>
    va0 = PGROUNDDOWN(dstva);
    80000dae:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000db2:	85ca                	mv	a1,s2
    80000db4:	855a                	mv	a0,s6
    80000db6:	00000097          	auipc	ra,0x0
    80000dba:	97e080e7          	jalr	-1666(ra) # 80000734 <walkaddr>
    if (pa0 == 0)
    80000dbe:	cd01                	beqz	a0,80000dd6 <copyout+0x90>
    n = PGSIZE - (dstva - va0);
    80000dc0:	418904b3          	sub	s1,s2,s8
    80000dc4:	94d6                	add	s1,s1,s5
    if (n > len)
    80000dc6:	fc99f3e3          	bgeu	s3,s1,80000d8c <copyout+0x46>
    80000dca:	84ce                	mv	s1,s3
    80000dcc:	b7c1                	j	80000d8c <copyout+0x46>
  }
  return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	a021                	j	80000dd8 <copyout+0x92>
    80000dd2:	4501                	li	a0,0
    80000dd4:	a011                	j	80000dd8 <copyout+0x92>
      return -1;
    80000dd6:	557d                	li	a0,-1
}
    80000dd8:	60a6                	ld	ra,72(sp)
    80000dda:	6406                	ld	s0,64(sp)
    80000ddc:	74e2                	ld	s1,56(sp)
    80000dde:	7942                	ld	s2,48(sp)
    80000de0:	79a2                	ld	s3,40(sp)
    80000de2:	7a02                	ld	s4,32(sp)
    80000de4:	6ae2                	ld	s5,24(sp)
    80000de6:	6b42                	ld	s6,16(sp)
    80000de8:	6ba2                	ld	s7,8(sp)
    80000dea:	6c02                	ld	s8,0(sp)
    80000dec:	6161                	addi	sp,sp,80
    80000dee:	8082                	ret

0000000080000df0 <copyin>:
int
copyin(pagetable_t pagetable, char* dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0) {
    80000df0:	c6bd                	beqz	a3,80000e5e <copyin+0x6e>
{
    80000df2:	715d                	addi	sp,sp,-80
    80000df4:	e486                	sd	ra,72(sp)
    80000df6:	e0a2                	sd	s0,64(sp)
    80000df8:	fc26                	sd	s1,56(sp)
    80000dfa:	f84a                	sd	s2,48(sp)
    80000dfc:	f44e                	sd	s3,40(sp)
    80000dfe:	f052                	sd	s4,32(sp)
    80000e00:	ec56                	sd	s5,24(sp)
    80000e02:	e85a                	sd	s6,16(sp)
    80000e04:	e45e                	sd	s7,8(sp)
    80000e06:	e062                	sd	s8,0(sp)
    80000e08:	0880                	addi	s0,sp,80
    80000e0a:	8b2a                	mv	s6,a0
    80000e0c:	8a2e                	mv	s4,a1
    80000e0e:	8c32                	mv	s8,a2
    80000e10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000e12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e14:	6a85                	lui	s5,0x1
    80000e16:	a015                	j	80000e3a <copyin+0x4a>
    if (n > len)
      n = len;
    memmove(dst, (void*)(pa0 + (srcva - va0)), n);
    80000e18:	9562                	add	a0,a0,s8
    80000e1a:	0004861b          	sext.w	a2,s1
    80000e1e:	412505b3          	sub	a1,a0,s2
    80000e22:	8552                	mv	a0,s4
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	5e2080e7          	jalr	1506(ra) # 80000406 <memmove>

    len -= n;
    80000e2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000e30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000e32:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000e36:	02098263          	beqz	s3,80000e5a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000e3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000e3e:	85ca                	mv	a1,s2
    80000e40:	855a                	mv	a0,s6
    80000e42:	00000097          	auipc	ra,0x0
    80000e46:	8f2080e7          	jalr	-1806(ra) # 80000734 <walkaddr>
    if (pa0 == 0)
    80000e4a:	cd01                	beqz	a0,80000e62 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000e4c:	418904b3          	sub	s1,s2,s8
    80000e50:	94d6                	add	s1,s1,s5
    if (n > len)
    80000e52:	fc99f3e3          	bgeu	s3,s1,80000e18 <copyin+0x28>
    80000e56:	84ce                	mv	s1,s3
    80000e58:	b7c1                	j	80000e18 <copyin+0x28>
  }
  return 0;
    80000e5a:	4501                	li	a0,0
    80000e5c:	a021                	j	80000e64 <copyin+0x74>
    80000e5e:	4501                	li	a0,0
}
    80000e60:	8082                	ret
      return -1;
    80000e62:	557d                	li	a0,-1
}
    80000e64:	60a6                	ld	ra,72(sp)
    80000e66:	6406                	ld	s0,64(sp)
    80000e68:	74e2                	ld	s1,56(sp)
    80000e6a:	7942                	ld	s2,48(sp)
    80000e6c:	79a2                	ld	s3,40(sp)
    80000e6e:	7a02                	ld	s4,32(sp)
    80000e70:	6ae2                	ld	s5,24(sp)
    80000e72:	6b42                	ld	s6,16(sp)
    80000e74:	6ba2                	ld	s7,8(sp)
    80000e76:	6c02                	ld	s8,0(sp)
    80000e78:	6161                	addi	sp,sp,80
    80000e7a:	8082                	ret

0000000080000e7c <copyinstr>:
copyinstr(pagetable_t pagetable, char* dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000e7c:	c6c5                	beqz	a3,80000f24 <copyinstr+0xa8>
{
    80000e7e:	715d                	addi	sp,sp,-80
    80000e80:	e486                	sd	ra,72(sp)
    80000e82:	e0a2                	sd	s0,64(sp)
    80000e84:	fc26                	sd	s1,56(sp)
    80000e86:	f84a                	sd	s2,48(sp)
    80000e88:	f44e                	sd	s3,40(sp)
    80000e8a:	f052                	sd	s4,32(sp)
    80000e8c:	ec56                	sd	s5,24(sp)
    80000e8e:	e85a                	sd	s6,16(sp)
    80000e90:	e45e                	sd	s7,8(sp)
    80000e92:	0880                	addi	s0,sp,80
    80000e94:	8a2a                	mv	s4,a0
    80000e96:	8b2e                	mv	s6,a1
    80000e98:	8bb2                	mv	s7,a2
    80000e9a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e9e:	6985                	lui	s3,0x1
    80000ea0:	a035                	j	80000ecc <copyinstr+0x50>
      n = max;

    char* p = (char*)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000ea2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ea6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000ea8:	0017b793          	seqz	a5,a5
    80000eac:	40f00533          	neg	a0,a5
    return 0;
  }
  else {
    return -1;
  }
}
    80000eb0:	60a6                	ld	ra,72(sp)
    80000eb2:	6406                	ld	s0,64(sp)
    80000eb4:	74e2                	ld	s1,56(sp)
    80000eb6:	7942                	ld	s2,48(sp)
    80000eb8:	79a2                	ld	s3,40(sp)
    80000eba:	7a02                	ld	s4,32(sp)
    80000ebc:	6ae2                	ld	s5,24(sp)
    80000ebe:	6b42                	ld	s6,16(sp)
    80000ec0:	6ba2                	ld	s7,8(sp)
    80000ec2:	6161                	addi	sp,sp,80
    80000ec4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ec6:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000eca:	c8a9                	beqz	s1,80000f1c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000ecc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ed0:	85ca                	mv	a1,s2
    80000ed2:	8552                	mv	a0,s4
    80000ed4:	00000097          	auipc	ra,0x0
    80000ed8:	860080e7          	jalr	-1952(ra) # 80000734 <walkaddr>
    if (pa0 == 0)
    80000edc:	c131                	beqz	a0,80000f20 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ede:	41790833          	sub	a6,s2,s7
    80000ee2:	984e                	add	a6,a6,s3
    if (n > max)
    80000ee4:	0104f363          	bgeu	s1,a6,80000eea <copyinstr+0x6e>
    80000ee8:	8826                	mv	a6,s1
    char* p = (char*)(pa0 + (srcva - va0));
    80000eea:	955e                	add	a0,a0,s7
    80000eec:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000ef0:	fc080be3          	beqz	a6,80000ec6 <copyinstr+0x4a>
    80000ef4:	985a                	add	a6,a6,s6
    80000ef6:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000ef8:	41650633          	sub	a2,a0,s6
    80000efc:	14fd                	addi	s1,s1,-1
    80000efe:	9b26                	add	s6,s6,s1
    80000f00:	00f60733          	add	a4,a2,a5
    80000f04:	00074703          	lbu	a4,0(a4)
    80000f08:	df49                	beqz	a4,80000ea2 <copyinstr+0x26>
        *dst = *p;
    80000f0a:	00e78023          	sb	a4,0(a5)
      --max;
    80000f0e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000f12:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000f14:	ff0796e3          	bne	a5,a6,80000f00 <copyinstr+0x84>
      dst++;
    80000f18:	8b42                	mv	s6,a6
    80000f1a:	b775                	j	80000ec6 <copyinstr+0x4a>
    80000f1c:	4781                	li	a5,0
    80000f1e:	b769                	j	80000ea8 <copyinstr+0x2c>
      return -1;
    80000f20:	557d                	li	a0,-1
    80000f22:	b779                	j	80000eb0 <copyinstr+0x34>
  int got_null = 0;
    80000f24:	4781                	li	a5,0
  if (got_null) {
    80000f26:	0017b793          	seqz	a5,a5
    80000f2a:	40f00533          	neg	a0,a5
}
    80000f2e:	8082                	ret

0000000080000f30 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f30:	7139                	addi	sp,sp,-64
    80000f32:	fc06                	sd	ra,56(sp)
    80000f34:	f822                	sd	s0,48(sp)
    80000f36:	f426                	sd	s1,40(sp)
    80000f38:	f04a                	sd	s2,32(sp)
    80000f3a:	ec4e                	sd	s3,24(sp)
    80000f3c:	e852                	sd	s4,16(sp)
    80000f3e:	e456                	sd	s5,8(sp)
    80000f40:	e05a                	sd	s6,0(sp)
    80000f42:	0080                	addi	s0,sp,64
    80000f44:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f46:	00108497          	auipc	s1,0x108
    80000f4a:	53a48493          	addi	s1,s1,1338 # 80109480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f4e:	8b26                	mv	s6,s1
    80000f50:	00007a97          	auipc	s5,0x7
    80000f54:	0b0a8a93          	addi	s5,s5,176 # 80008000 <etext>
    80000f58:	04000937          	lui	s2,0x4000
    80000f5c:	197d                	addi	s2,s2,-1
    80000f5e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f60:	0010ea17          	auipc	s4,0x10e
    80000f64:	f20a0a13          	addi	s4,s4,-224 # 8010ee80 <tickslock>
    char *pa = kalloc();
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	2ae080e7          	jalr	686(ra) # 80000216 <kalloc>
    80000f70:	862a                	mv	a2,a0
    if(pa == 0)
    80000f72:	c131                	beqz	a0,80000fb6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f74:	416485b3          	sub	a1,s1,s6
    80000f78:	858d                	srai	a1,a1,0x3
    80000f7a:	000ab783          	ld	a5,0(s5)
    80000f7e:	02f585b3          	mul	a1,a1,a5
    80000f82:	2585                	addiw	a1,a1,1
    80000f84:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f88:	4719                	li	a4,6
    80000f8a:	6685                	lui	a3,0x1
    80000f8c:	40b905b3          	sub	a1,s2,a1
    80000f90:	854e                	mv	a0,s3
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	884080e7          	jalr	-1916(ra) # 80000816 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f9a:	16848493          	addi	s1,s1,360
    80000f9e:	fd4495e3          	bne	s1,s4,80000f68 <proc_mapstacks+0x38>
  }
}
    80000fa2:	70e2                	ld	ra,56(sp)
    80000fa4:	7442                	ld	s0,48(sp)
    80000fa6:	74a2                	ld	s1,40(sp)
    80000fa8:	7902                	ld	s2,32(sp)
    80000faa:	69e2                	ld	s3,24(sp)
    80000fac:	6a42                	ld	s4,16(sp)
    80000fae:	6aa2                	ld	s5,8(sp)
    80000fb0:	6b02                	ld	s6,0(sp)
    80000fb2:	6121                	addi	sp,sp,64
    80000fb4:	8082                	ret
      panic("kalloc");
    80000fb6:	00007517          	auipc	a0,0x7
    80000fba:	1da50513          	addi	a0,a0,474 # 80008190 <etext+0x190>
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	eca080e7          	jalr	-310(ra) # 80005e88 <panic>

0000000080000fc6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000fc6:	7139                	addi	sp,sp,-64
    80000fc8:	fc06                	sd	ra,56(sp)
    80000fca:	f822                	sd	s0,48(sp)
    80000fcc:	f426                	sd	s1,40(sp)
    80000fce:	f04a                	sd	s2,32(sp)
    80000fd0:	ec4e                	sd	s3,24(sp)
    80000fd2:	e852                	sd	s4,16(sp)
    80000fd4:	e456                	sd	s5,8(sp)
    80000fd6:	e05a                	sd	s6,0(sp)
    80000fd8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fda:	00007597          	auipc	a1,0x7
    80000fde:	1be58593          	addi	a1,a1,446 # 80008198 <etext+0x198>
    80000fe2:	00108517          	auipc	a0,0x108
    80000fe6:	06e50513          	addi	a0,a0,110 # 80109050 <pid_lock>
    80000fea:	00005097          	auipc	ra,0x5
    80000fee:	358080e7          	jalr	856(ra) # 80006342 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ff2:	00007597          	auipc	a1,0x7
    80000ff6:	1ae58593          	addi	a1,a1,430 # 800081a0 <etext+0x1a0>
    80000ffa:	00108517          	auipc	a0,0x108
    80000ffe:	06e50513          	addi	a0,a0,110 # 80109068 <wait_lock>
    80001002:	00005097          	auipc	ra,0x5
    80001006:	340080e7          	jalr	832(ra) # 80006342 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000100a:	00108497          	auipc	s1,0x108
    8000100e:	47648493          	addi	s1,s1,1142 # 80109480 <proc>
      initlock(&p->lock, "proc");
    80001012:	00007b17          	auipc	s6,0x7
    80001016:	19eb0b13          	addi	s6,s6,414 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    8000101a:	8aa6                	mv	s5,s1
    8000101c:	00007a17          	auipc	s4,0x7
    80001020:	fe4a0a13          	addi	s4,s4,-28 # 80008000 <etext>
    80001024:	04000937          	lui	s2,0x4000
    80001028:	197d                	addi	s2,s2,-1
    8000102a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000102c:	0010e997          	auipc	s3,0x10e
    80001030:	e5498993          	addi	s3,s3,-428 # 8010ee80 <tickslock>
      initlock(&p->lock, "proc");
    80001034:	85da                	mv	a1,s6
    80001036:	8526                	mv	a0,s1
    80001038:	00005097          	auipc	ra,0x5
    8000103c:	30a080e7          	jalr	778(ra) # 80006342 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001040:	415487b3          	sub	a5,s1,s5
    80001044:	878d                	srai	a5,a5,0x3
    80001046:	000a3703          	ld	a4,0(s4)
    8000104a:	02e787b3          	mul	a5,a5,a4
    8000104e:	2785                	addiw	a5,a5,1
    80001050:	00d7979b          	slliw	a5,a5,0xd
    80001054:	40f907b3          	sub	a5,s2,a5
    80001058:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	16848493          	addi	s1,s1,360
    8000105e:	fd349be3          	bne	s1,s3,80001034 <procinit+0x6e>
  }
}
    80001062:	70e2                	ld	ra,56(sp)
    80001064:	7442                	ld	s0,48(sp)
    80001066:	74a2                	ld	s1,40(sp)
    80001068:	7902                	ld	s2,32(sp)
    8000106a:	69e2                	ld	s3,24(sp)
    8000106c:	6a42                	ld	s4,16(sp)
    8000106e:	6aa2                	ld	s5,8(sp)
    80001070:	6b02                	ld	s6,0(sp)
    80001072:	6121                	addi	sp,sp,64
    80001074:	8082                	ret

0000000080001076 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001076:	1141                	addi	sp,sp,-16
    80001078:	e422                	sd	s0,8(sp)
    8000107a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x));
    8000107c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000107e:	2501                	sext.w	a0,a0
    80001080:	6422                	ld	s0,8(sp)
    80001082:	0141                	addi	sp,sp,16
    80001084:	8082                	ret

0000000080001086 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001086:	1141                	addi	sp,sp,-16
    80001088:	e422                	sd	s0,8(sp)
    8000108a:	0800                	addi	s0,sp,16
    8000108c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000108e:	2781                	sext.w	a5,a5
    80001090:	079e                	slli	a5,a5,0x7
  return c;
}
    80001092:	00108517          	auipc	a0,0x108
    80001096:	fee50513          	addi	a0,a0,-18 # 80109080 <cpus>
    8000109a:	953e                	add	a0,a0,a5
    8000109c:	6422                	ld	s0,8(sp)
    8000109e:	0141                	addi	sp,sp,16
    800010a0:	8082                	ret

00000000800010a2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800010a2:	1101                	addi	sp,sp,-32
    800010a4:	ec06                	sd	ra,24(sp)
    800010a6:	e822                	sd	s0,16(sp)
    800010a8:	e426                	sd	s1,8(sp)
    800010aa:	1000                	addi	s0,sp,32
  push_off();
    800010ac:	00005097          	auipc	ra,0x5
    800010b0:	2da080e7          	jalr	730(ra) # 80006386 <push_off>
    800010b4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010b6:	2781                	sext.w	a5,a5
    800010b8:	079e                	slli	a5,a5,0x7
    800010ba:	00108717          	auipc	a4,0x108
    800010be:	f9670713          	addi	a4,a4,-106 # 80109050 <pid_lock>
    800010c2:	97ba                	add	a5,a5,a4
    800010c4:	7b84                	ld	s1,48(a5)
  pop_off();
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	360080e7          	jalr	864(ra) # 80006426 <pop_off>
  return p;
}
    800010ce:	8526                	mv	a0,s1
    800010d0:	60e2                	ld	ra,24(sp)
    800010d2:	6442                	ld	s0,16(sp)
    800010d4:	64a2                	ld	s1,8(sp)
    800010d6:	6105                	addi	sp,sp,32
    800010d8:	8082                	ret

00000000800010da <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010da:	1141                	addi	sp,sp,-16
    800010dc:	e406                	sd	ra,8(sp)
    800010de:	e022                	sd	s0,0(sp)
    800010e0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	fc0080e7          	jalr	-64(ra) # 800010a2 <myproc>
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	39c080e7          	jalr	924(ra) # 80006486 <release>

  if (first) {
    800010f2:	00007797          	auipc	a5,0x7
    800010f6:	75e7a783          	lw	a5,1886(a5) # 80008850 <first.1688>
    800010fa:	eb89                	bnez	a5,8000110c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010fc:	00001097          	auipc	ra,0x1
    80001100:	ce0080e7          	jalr	-800(ra) # 80001ddc <usertrapret>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    first = 0;
    8000110c:	00007797          	auipc	a5,0x7
    80001110:	7407a223          	sw	zero,1860(a5) # 80008850 <first.1688>
    fsinit(ROOTDEV);
    80001114:	4505                	li	a0,1
    80001116:	00002097          	auipc	ra,0x2
    8000111a:	a4c080e7          	jalr	-1460(ra) # 80002b62 <fsinit>
    8000111e:	bff9                	j	800010fc <forkret+0x22>

0000000080001120 <allocpid>:
allocpid() {
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	e04a                	sd	s2,0(sp)
    8000112a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000112c:	00108917          	auipc	s2,0x108
    80001130:	f2490913          	addi	s2,s2,-220 # 80109050 <pid_lock>
    80001134:	854a                	mv	a0,s2
    80001136:	00005097          	auipc	ra,0x5
    8000113a:	29c080e7          	jalr	668(ra) # 800063d2 <acquire>
  pid = nextpid;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	71678793          	addi	a5,a5,1814 # 80008854 <nextpid>
    80001146:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001148:	0014871b          	addiw	a4,s1,1
    8000114c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000114e:	854a                	mv	a0,s2
    80001150:	00005097          	auipc	ra,0x5
    80001154:	336080e7          	jalr	822(ra) # 80006486 <release>
}
    80001158:	8526                	mv	a0,s1
    8000115a:	60e2                	ld	ra,24(sp)
    8000115c:	6442                	ld	s0,16(sp)
    8000115e:	64a2                	ld	s1,8(sp)
    80001160:	6902                	ld	s2,0(sp)
    80001162:	6105                	addi	sp,sp,32
    80001164:	8082                	ret

0000000080001166 <proc_pagetable>:
{
    80001166:	1101                	addi	sp,sp,-32
    80001168:	ec06                	sd	ra,24(sp)
    8000116a:	e822                	sd	s0,16(sp)
    8000116c:	e426                	sd	s1,8(sp)
    8000116e:	e04a                	sd	s2,0(sp)
    80001170:	1000                	addi	s0,sp,32
    80001172:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	898080e7          	jalr	-1896(ra) # 80000a0c <uvmcreate>
    8000117c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000117e:	c121                	beqz	a0,800011be <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001180:	4729                	li	a4,10
    80001182:	00006697          	auipc	a3,0x6
    80001186:	e7e68693          	addi	a3,a3,-386 # 80007000 <_trampoline>
    8000118a:	6605                	lui	a2,0x1
    8000118c:	040005b7          	lui	a1,0x4000
    80001190:	15fd                	addi	a1,a1,-1
    80001192:	05b2                	slli	a1,a1,0xc
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	5e2080e7          	jalr	1506(ra) # 80000776 <mappages>
    8000119c:	02054863          	bltz	a0,800011cc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800011a0:	4719                	li	a4,6
    800011a2:	05893683          	ld	a3,88(s2)
    800011a6:	6605                	lui	a2,0x1
    800011a8:	020005b7          	lui	a1,0x2000
    800011ac:	15fd                	addi	a1,a1,-1
    800011ae:	05b6                	slli	a1,a1,0xd
    800011b0:	8526                	mv	a0,s1
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	5c4080e7          	jalr	1476(ra) # 80000776 <mappages>
    800011ba:	02054163          	bltz	a0,800011dc <proc_pagetable+0x76>
}
    800011be:	8526                	mv	a0,s1
    800011c0:	60e2                	ld	ra,24(sp)
    800011c2:	6442                	ld	s0,16(sp)
    800011c4:	64a2                	ld	s1,8(sp)
    800011c6:	6902                	ld	s2,0(sp)
    800011c8:	6105                	addi	sp,sp,32
    800011ca:	8082                	ret
    uvmfree(pagetable, 0);
    800011cc:	4581                	li	a1,0
    800011ce:	8526                	mv	a0,s1
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	a38080e7          	jalr	-1480(ra) # 80000c08 <uvmfree>
    return 0;
    800011d8:	4481                	li	s1,0
    800011da:	b7d5                	j	800011be <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011dc:	4681                	li	a3,0
    800011de:	4605                	li	a2,1
    800011e0:	040005b7          	lui	a1,0x4000
    800011e4:	15fd                	addi	a1,a1,-1
    800011e6:	05b2                	slli	a1,a1,0xc
    800011e8:	8526                	mv	a0,s1
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	752080e7          	jalr	1874(ra) # 8000093c <uvmunmap>
    uvmfree(pagetable, 0);
    800011f2:	4581                	li	a1,0
    800011f4:	8526                	mv	a0,s1
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	a12080e7          	jalr	-1518(ra) # 80000c08 <uvmfree>
    return 0;
    800011fe:	4481                	li	s1,0
    80001200:	bf7d                	j	800011be <proc_pagetable+0x58>

0000000080001202 <proc_freepagetable>:
{
    80001202:	1101                	addi	sp,sp,-32
    80001204:	ec06                	sd	ra,24(sp)
    80001206:	e822                	sd	s0,16(sp)
    80001208:	e426                	sd	s1,8(sp)
    8000120a:	e04a                	sd	s2,0(sp)
    8000120c:	1000                	addi	s0,sp,32
    8000120e:	84aa                	mv	s1,a0
    80001210:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001212:	4681                	li	a3,0
    80001214:	4605                	li	a2,1
    80001216:	040005b7          	lui	a1,0x4000
    8000121a:	15fd                	addi	a1,a1,-1
    8000121c:	05b2                	slli	a1,a1,0xc
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	71e080e7          	jalr	1822(ra) # 8000093c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001226:	4681                	li	a3,0
    80001228:	4605                	li	a2,1
    8000122a:	020005b7          	lui	a1,0x2000
    8000122e:	15fd                	addi	a1,a1,-1
    80001230:	05b6                	slli	a1,a1,0xd
    80001232:	8526                	mv	a0,s1
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	708080e7          	jalr	1800(ra) # 8000093c <uvmunmap>
  uvmfree(pagetable, sz);
    8000123c:	85ca                	mv	a1,s2
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	9c8080e7          	jalr	-1592(ra) # 80000c08 <uvmfree>
}
    80001248:	60e2                	ld	ra,24(sp)
    8000124a:	6442                	ld	s0,16(sp)
    8000124c:	64a2                	ld	s1,8(sp)
    8000124e:	6902                	ld	s2,0(sp)
    80001250:	6105                	addi	sp,sp,32
    80001252:	8082                	ret

0000000080001254 <freeproc>:
{
    80001254:	1101                	addi	sp,sp,-32
    80001256:	ec06                	sd	ra,24(sp)
    80001258:	e822                	sd	s0,16(sp)
    8000125a:	e426                	sd	s1,8(sp)
    8000125c:	1000                	addi	s0,sp,32
    8000125e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001260:	6d28                	ld	a0,88(a0)
    80001262:	c509                	beqz	a0,8000126c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	db8080e7          	jalr	-584(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000126c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001270:	68a8                	ld	a0,80(s1)
    80001272:	c511                	beqz	a0,8000127e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001274:	64ac                	ld	a1,72(s1)
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	f8c080e7          	jalr	-116(ra) # 80001202 <proc_freepagetable>
  p->pagetable = 0;
    8000127e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001282:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001286:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000128a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000128e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001292:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001296:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000129a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000129e:	0004ac23          	sw	zero,24(s1)
}
    800012a2:	60e2                	ld	ra,24(sp)
    800012a4:	6442                	ld	s0,16(sp)
    800012a6:	64a2                	ld	s1,8(sp)
    800012a8:	6105                	addi	sp,sp,32
    800012aa:	8082                	ret

00000000800012ac <allocproc>:
{
    800012ac:	1101                	addi	sp,sp,-32
    800012ae:	ec06                	sd	ra,24(sp)
    800012b0:	e822                	sd	s0,16(sp)
    800012b2:	e426                	sd	s1,8(sp)
    800012b4:	e04a                	sd	s2,0(sp)
    800012b6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012b8:	00108497          	auipc	s1,0x108
    800012bc:	1c848493          	addi	s1,s1,456 # 80109480 <proc>
    800012c0:	0010e917          	auipc	s2,0x10e
    800012c4:	bc090913          	addi	s2,s2,-1088 # 8010ee80 <tickslock>
    acquire(&p->lock);
    800012c8:	8526                	mv	a0,s1
    800012ca:	00005097          	auipc	ra,0x5
    800012ce:	108080e7          	jalr	264(ra) # 800063d2 <acquire>
    if(p->state == UNUSED) {
    800012d2:	4c9c                	lw	a5,24(s1)
    800012d4:	cf81                	beqz	a5,800012ec <allocproc+0x40>
      release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	1ae080e7          	jalr	430(ra) # 80006486 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012e0:	16848493          	addi	s1,s1,360
    800012e4:	ff2492e3          	bne	s1,s2,800012c8 <allocproc+0x1c>
  return 0;
    800012e8:	4481                	li	s1,0
    800012ea:	a889                	j	8000133c <allocproc+0x90>
  p->pid = allocpid();
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	e34080e7          	jalr	-460(ra) # 80001120 <allocpid>
    800012f4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012f6:	4785                	li	a5,1
    800012f8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	f1c080e7          	jalr	-228(ra) # 80000216 <kalloc>
    80001302:	892a                	mv	s2,a0
    80001304:	eca8                	sd	a0,88(s1)
    80001306:	c131                	beqz	a0,8000134a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001308:	8526                	mv	a0,s1
    8000130a:	00000097          	auipc	ra,0x0
    8000130e:	e5c080e7          	jalr	-420(ra) # 80001166 <proc_pagetable>
    80001312:	892a                	mv	s2,a0
    80001314:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001316:	c531                	beqz	a0,80001362 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001318:	07000613          	li	a2,112
    8000131c:	4581                	li	a1,0
    8000131e:	06048513          	addi	a0,s1,96
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	084080e7          	jalr	132(ra) # 800003a6 <memset>
  p->context.ra = (uint64)forkret;
    8000132a:	00000797          	auipc	a5,0x0
    8000132e:	db078793          	addi	a5,a5,-592 # 800010da <forkret>
    80001332:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001334:	60bc                	ld	a5,64(s1)
    80001336:	6705                	lui	a4,0x1
    80001338:	97ba                	add	a5,a5,a4
    8000133a:	f4bc                	sd	a5,104(s1)
}
    8000133c:	8526                	mv	a0,s1
    8000133e:	60e2                	ld	ra,24(sp)
    80001340:	6442                	ld	s0,16(sp)
    80001342:	64a2                	ld	s1,8(sp)
    80001344:	6902                	ld	s2,0(sp)
    80001346:	6105                	addi	sp,sp,32
    80001348:	8082                	ret
    freeproc(p);
    8000134a:	8526                	mv	a0,s1
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	f08080e7          	jalr	-248(ra) # 80001254 <freeproc>
    release(&p->lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	130080e7          	jalr	304(ra) # 80006486 <release>
    return 0;
    8000135e:	84ca                	mv	s1,s2
    80001360:	bff1                	j	8000133c <allocproc+0x90>
    freeproc(p);
    80001362:	8526                	mv	a0,s1
    80001364:	00000097          	auipc	ra,0x0
    80001368:	ef0080e7          	jalr	-272(ra) # 80001254 <freeproc>
    release(&p->lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	118080e7          	jalr	280(ra) # 80006486 <release>
    return 0;
    80001376:	84ca                	mv	s1,s2
    80001378:	b7d1                	j	8000133c <allocproc+0x90>

000000008000137a <userinit>:
{
    8000137a:	1101                	addi	sp,sp,-32
    8000137c:	ec06                	sd	ra,24(sp)
    8000137e:	e822                	sd	s0,16(sp)
    80001380:	e426                	sd	s1,8(sp)
    80001382:	1000                	addi	s0,sp,32
  p = allocproc();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	f28080e7          	jalr	-216(ra) # 800012ac <allocproc>
    8000138c:	84aa                	mv	s1,a0
  initproc = p;
    8000138e:	00008797          	auipc	a5,0x8
    80001392:	c8a7b123          	sd	a0,-894(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001396:	03400613          	li	a2,52
    8000139a:	00007597          	auipc	a1,0x7
    8000139e:	4c658593          	addi	a1,a1,1222 # 80008860 <initcode>
    800013a2:	6928                	ld	a0,80(a0)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	696080e7          	jalr	1686(ra) # 80000a3a <uvminit>
  p->sz = PGSIZE;
    800013ac:	6785                	lui	a5,0x1
    800013ae:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013b0:	6cb8                	ld	a4,88(s1)
    800013b2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013b6:	6cb8                	ld	a4,88(s1)
    800013b8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013ba:	4641                	li	a2,16
    800013bc:	00007597          	auipc	a1,0x7
    800013c0:	dfc58593          	addi	a1,a1,-516 # 800081b8 <etext+0x1b8>
    800013c4:	15848513          	addi	a0,s1,344
    800013c8:	fffff097          	auipc	ra,0xfffff
    800013cc:	130080e7          	jalr	304(ra) # 800004f8 <safestrcpy>
  p->cwd = namei("/");
    800013d0:	00007517          	auipc	a0,0x7
    800013d4:	df850513          	addi	a0,a0,-520 # 800081c8 <etext+0x1c8>
    800013d8:	00002097          	auipc	ra,0x2
    800013dc:	1b8080e7          	jalr	440(ra) # 80003590 <namei>
    800013e0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013e4:	478d                	li	a5,3
    800013e6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	09c080e7          	jalr	156(ra) # 80006486 <release>
}
    800013f2:	60e2                	ld	ra,24(sp)
    800013f4:	6442                	ld	s0,16(sp)
    800013f6:	64a2                	ld	s1,8(sp)
    800013f8:	6105                	addi	sp,sp,32
    800013fa:	8082                	ret

00000000800013fc <growproc>:
{
    800013fc:	1101                	addi	sp,sp,-32
    800013fe:	ec06                	sd	ra,24(sp)
    80001400:	e822                	sd	s0,16(sp)
    80001402:	e426                	sd	s1,8(sp)
    80001404:	e04a                	sd	s2,0(sp)
    80001406:	1000                	addi	s0,sp,32
    80001408:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	c98080e7          	jalr	-872(ra) # 800010a2 <myproc>
    80001412:	892a                	mv	s2,a0
  sz = p->sz;
    80001414:	652c                	ld	a1,72(a0)
    80001416:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000141a:	00904f63          	bgtz	s1,80001438 <growproc+0x3c>
  } else if(n < 0){
    8000141e:	0204cc63          	bltz	s1,80001456 <growproc+0x5a>
  p->sz = sz;
    80001422:	1602                	slli	a2,a2,0x20
    80001424:	9201                	srli	a2,a2,0x20
    80001426:	04c93423          	sd	a2,72(s2)
  return 0;
    8000142a:	4501                	li	a0,0
}
    8000142c:	60e2                	ld	ra,24(sp)
    8000142e:	6442                	ld	s0,16(sp)
    80001430:	64a2                	ld	s1,8(sp)
    80001432:	6902                	ld	s2,0(sp)
    80001434:	6105                	addi	sp,sp,32
    80001436:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001438:	9e25                	addw	a2,a2,s1
    8000143a:	1602                	slli	a2,a2,0x20
    8000143c:	9201                	srli	a2,a2,0x20
    8000143e:	1582                	slli	a1,a1,0x20
    80001440:	9181                	srli	a1,a1,0x20
    80001442:	6928                	ld	a0,80(a0)
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	6b0080e7          	jalr	1712(ra) # 80000af4 <uvmalloc>
    8000144c:	0005061b          	sext.w	a2,a0
    80001450:	fa69                	bnez	a2,80001422 <growproc+0x26>
      return -1;
    80001452:	557d                	li	a0,-1
    80001454:	bfe1                	j	8000142c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001456:	9e25                	addw	a2,a2,s1
    80001458:	1602                	slli	a2,a2,0x20
    8000145a:	9201                	srli	a2,a2,0x20
    8000145c:	1582                	slli	a1,a1,0x20
    8000145e:	9181                	srli	a1,a1,0x20
    80001460:	6928                	ld	a0,80(a0)
    80001462:	fffff097          	auipc	ra,0xfffff
    80001466:	64a080e7          	jalr	1610(ra) # 80000aac <uvmdealloc>
    8000146a:	0005061b          	sext.w	a2,a0
    8000146e:	bf55                	j	80001422 <growproc+0x26>

0000000080001470 <fork>:
{
    80001470:	7179                	addi	sp,sp,-48
    80001472:	f406                	sd	ra,40(sp)
    80001474:	f022                	sd	s0,32(sp)
    80001476:	ec26                	sd	s1,24(sp)
    80001478:	e84a                	sd	s2,16(sp)
    8000147a:	e44e                	sd	s3,8(sp)
    8000147c:	e052                	sd	s4,0(sp)
    8000147e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001480:	00000097          	auipc	ra,0x0
    80001484:	c22080e7          	jalr	-990(ra) # 800010a2 <myproc>
    80001488:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	e22080e7          	jalr	-478(ra) # 800012ac <allocproc>
    80001492:	10050b63          	beqz	a0,800015a8 <fork+0x138>
    80001496:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001498:	04893603          	ld	a2,72(s2)
    8000149c:	692c                	ld	a1,80(a0)
    8000149e:	05093503          	ld	a0,80(s2)
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	79e080e7          	jalr	1950(ra) # 80000c40 <uvmcopy>
    800014aa:	04054663          	bltz	a0,800014f6 <fork+0x86>
  np->sz = p->sz;
    800014ae:	04893783          	ld	a5,72(s2)
    800014b2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800014b6:	05893683          	ld	a3,88(s2)
    800014ba:	87b6                	mv	a5,a3
    800014bc:	0589b703          	ld	a4,88(s3)
    800014c0:	12068693          	addi	a3,a3,288
    800014c4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014c8:	6788                	ld	a0,8(a5)
    800014ca:	6b8c                	ld	a1,16(a5)
    800014cc:	6f90                	ld	a2,24(a5)
    800014ce:	01073023          	sd	a6,0(a4)
    800014d2:	e708                	sd	a0,8(a4)
    800014d4:	eb0c                	sd	a1,16(a4)
    800014d6:	ef10                	sd	a2,24(a4)
    800014d8:	02078793          	addi	a5,a5,32
    800014dc:	02070713          	addi	a4,a4,32
    800014e0:	fed792e3          	bne	a5,a3,800014c4 <fork+0x54>
  np->trapframe->a0 = 0;
    800014e4:	0589b783          	ld	a5,88(s3)
    800014e8:	0607b823          	sd	zero,112(a5)
    800014ec:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800014f0:	15000a13          	li	s4,336
    800014f4:	a03d                	j	80001522 <fork+0xb2>
    freeproc(np);
    800014f6:	854e                	mv	a0,s3
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	d5c080e7          	jalr	-676(ra) # 80001254 <freeproc>
    release(&np->lock);
    80001500:	854e                	mv	a0,s3
    80001502:	00005097          	auipc	ra,0x5
    80001506:	f84080e7          	jalr	-124(ra) # 80006486 <release>
    return -1;
    8000150a:	5a7d                	li	s4,-1
    8000150c:	a069                	j	80001596 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000150e:	00002097          	auipc	ra,0x2
    80001512:	718080e7          	jalr	1816(ra) # 80003c26 <filedup>
    80001516:	009987b3          	add	a5,s3,s1
    8000151a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000151c:	04a1                	addi	s1,s1,8
    8000151e:	01448763          	beq	s1,s4,8000152c <fork+0xbc>
    if(p->ofile[i])
    80001522:	009907b3          	add	a5,s2,s1
    80001526:	6388                	ld	a0,0(a5)
    80001528:	f17d                	bnez	a0,8000150e <fork+0x9e>
    8000152a:	bfcd                	j	8000151c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000152c:	15093503          	ld	a0,336(s2)
    80001530:	00002097          	auipc	ra,0x2
    80001534:	86c080e7          	jalr	-1940(ra) # 80002d9c <idup>
    80001538:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000153c:	4641                	li	a2,16
    8000153e:	15890593          	addi	a1,s2,344
    80001542:	15898513          	addi	a0,s3,344
    80001546:	fffff097          	auipc	ra,0xfffff
    8000154a:	fb2080e7          	jalr	-78(ra) # 800004f8 <safestrcpy>
  pid = np->pid;
    8000154e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001552:	854e                	mv	a0,s3
    80001554:	00005097          	auipc	ra,0x5
    80001558:	f32080e7          	jalr	-206(ra) # 80006486 <release>
  acquire(&wait_lock);
    8000155c:	00108497          	auipc	s1,0x108
    80001560:	b0c48493          	addi	s1,s1,-1268 # 80109068 <wait_lock>
    80001564:	8526                	mv	a0,s1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	e6c080e7          	jalr	-404(ra) # 800063d2 <acquire>
  np->parent = p;
    8000156e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001572:	8526                	mv	a0,s1
    80001574:	00005097          	auipc	ra,0x5
    80001578:	f12080e7          	jalr	-238(ra) # 80006486 <release>
  acquire(&np->lock);
    8000157c:	854e                	mv	a0,s3
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	e54080e7          	jalr	-428(ra) # 800063d2 <acquire>
  np->state = RUNNABLE;
    80001586:	478d                	li	a5,3
    80001588:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000158c:	854e                	mv	a0,s3
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	ef8080e7          	jalr	-264(ra) # 80006486 <release>
}
    80001596:	8552                	mv	a0,s4
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6a02                	ld	s4,0(sp)
    800015a4:	6145                	addi	sp,sp,48
    800015a6:	8082                	ret
    return -1;
    800015a8:	5a7d                	li	s4,-1
    800015aa:	b7f5                	j	80001596 <fork+0x126>

00000000800015ac <scheduler>:
{
    800015ac:	7139                	addi	sp,sp,-64
    800015ae:	fc06                	sd	ra,56(sp)
    800015b0:	f822                	sd	s0,48(sp)
    800015b2:	f426                	sd	s1,40(sp)
    800015b4:	f04a                	sd	s2,32(sp)
    800015b6:	ec4e                	sd	s3,24(sp)
    800015b8:	e852                	sd	s4,16(sp)
    800015ba:	e456                	sd	s5,8(sp)
    800015bc:	e05a                	sd	s6,0(sp)
    800015be:	0080                	addi	s0,sp,64
    800015c0:	8792                	mv	a5,tp
  int id = r_tp();
    800015c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015c4:	00779a93          	slli	s5,a5,0x7
    800015c8:	00108717          	auipc	a4,0x108
    800015cc:	a8870713          	addi	a4,a4,-1400 # 80109050 <pid_lock>
    800015d0:	9756                	add	a4,a4,s5
    800015d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015d6:	00108717          	auipc	a4,0x108
    800015da:	ab270713          	addi	a4,a4,-1358 # 80109088 <cpus+0x8>
    800015de:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015e0:	498d                	li	s3,3
        p->state = RUNNING;
    800015e2:	4b11                	li	s6,4
        c->proc = p;
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	00108a17          	auipc	s4,0x108
    800015ea:	a6aa0a13          	addi	s4,s4,-1430 # 80109050 <pid_lock>
    800015ee:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015f0:	0010e917          	auipc	s2,0x10e
    800015f4:	89090913          	addi	s2,s2,-1904 # 8010ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    800015f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001600:	10079073          	csrw	sstatus,a5
    80001604:	00108497          	auipc	s1,0x108
    80001608:	e7c48493          	addi	s1,s1,-388 # 80109480 <proc>
    8000160c:	a03d                	j	8000163a <scheduler+0x8e>
        p->state = RUNNING;
    8000160e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001612:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001616:	06048593          	addi	a1,s1,96
    8000161a:	8556                	mv	a0,s5
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	640080e7          	jalr	1600(ra) # 80001c5c <swtch>
        c->proc = 0;
    80001624:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	e5c080e7          	jalr	-420(ra) # 80006486 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001632:	16848493          	addi	s1,s1,360
    80001636:	fd2481e3          	beq	s1,s2,800015f8 <scheduler+0x4c>
      acquire(&p->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	d96080e7          	jalr	-618(ra) # 800063d2 <acquire>
      if(p->state == RUNNABLE) {
    80001644:	4c9c                	lw	a5,24(s1)
    80001646:	ff3791e3          	bne	a5,s3,80001628 <scheduler+0x7c>
    8000164a:	b7d1                	j	8000160e <scheduler+0x62>

000000008000164c <sched>:
{
    8000164c:	7179                	addi	sp,sp,-48
    8000164e:	f406                	sd	ra,40(sp)
    80001650:	f022                	sd	s0,32(sp)
    80001652:	ec26                	sd	s1,24(sp)
    80001654:	e84a                	sd	s2,16(sp)
    80001656:	e44e                	sd	s3,8(sp)
    80001658:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	a48080e7          	jalr	-1464(ra) # 800010a2 <myproc>
    80001662:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001664:	00005097          	auipc	ra,0x5
    80001668:	cf4080e7          	jalr	-780(ra) # 80006358 <holding>
    8000166c:	c93d                	beqz	a0,800016e2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x));
    8000166e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001670:	2781                	sext.w	a5,a5
    80001672:	079e                	slli	a5,a5,0x7
    80001674:	00108717          	auipc	a4,0x108
    80001678:	9dc70713          	addi	a4,a4,-1572 # 80109050 <pid_lock>
    8000167c:	97ba                	add	a5,a5,a4
    8000167e:	0a87a703          	lw	a4,168(a5)
    80001682:	4785                	li	a5,1
    80001684:	06f71763          	bne	a4,a5,800016f2 <sched+0xa6>
  if(p->state == RUNNING)
    80001688:	4c98                	lw	a4,24(s1)
    8000168a:	4791                	li	a5,4
    8000168c:	06f70b63          	beq	a4,a5,80001702 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80001690:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001694:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001696:	efb5                	bnez	a5,80001712 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x));
    80001698:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000169a:	00108917          	auipc	s2,0x108
    8000169e:	9b690913          	addi	s2,s2,-1610 # 80109050 <pid_lock>
    800016a2:	2781                	sext.w	a5,a5
    800016a4:	079e                	slli	a5,a5,0x7
    800016a6:	97ca                	add	a5,a5,s2
    800016a8:	0ac7a983          	lw	s3,172(a5)
    800016ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016ae:	2781                	sext.w	a5,a5
    800016b0:	079e                	slli	a5,a5,0x7
    800016b2:	00108597          	auipc	a1,0x108
    800016b6:	9d658593          	addi	a1,a1,-1578 # 80109088 <cpus+0x8>
    800016ba:	95be                	add	a1,a1,a5
    800016bc:	06048513          	addi	a0,s1,96
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	59c080e7          	jalr	1436(ra) # 80001c5c <swtch>
    800016c8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016ca:	2781                	sext.w	a5,a5
    800016cc:	079e                	slli	a5,a5,0x7
    800016ce:	97ca                	add	a5,a5,s2
    800016d0:	0b37a623          	sw	s3,172(a5)
}
    800016d4:	70a2                	ld	ra,40(sp)
    800016d6:	7402                	ld	s0,32(sp)
    800016d8:	64e2                	ld	s1,24(sp)
    800016da:	6942                	ld	s2,16(sp)
    800016dc:	69a2                	ld	s3,8(sp)
    800016de:	6145                	addi	sp,sp,48
    800016e0:	8082                	ret
    panic("sched p->lock");
    800016e2:	00007517          	auipc	a0,0x7
    800016e6:	aee50513          	addi	a0,a0,-1298 # 800081d0 <etext+0x1d0>
    800016ea:	00004097          	auipc	ra,0x4
    800016ee:	79e080e7          	jalr	1950(ra) # 80005e88 <panic>
    panic("sched locks");
    800016f2:	00007517          	auipc	a0,0x7
    800016f6:	aee50513          	addi	a0,a0,-1298 # 800081e0 <etext+0x1e0>
    800016fa:	00004097          	auipc	ra,0x4
    800016fe:	78e080e7          	jalr	1934(ra) # 80005e88 <panic>
    panic("sched running");
    80001702:	00007517          	auipc	a0,0x7
    80001706:	aee50513          	addi	a0,a0,-1298 # 800081f0 <etext+0x1f0>
    8000170a:	00004097          	auipc	ra,0x4
    8000170e:	77e080e7          	jalr	1918(ra) # 80005e88 <panic>
    panic("sched interruptible");
    80001712:	00007517          	auipc	a0,0x7
    80001716:	aee50513          	addi	a0,a0,-1298 # 80008200 <etext+0x200>
    8000171a:	00004097          	auipc	ra,0x4
    8000171e:	76e080e7          	jalr	1902(ra) # 80005e88 <panic>

0000000080001722 <yield>:
{
    80001722:	1101                	addi	sp,sp,-32
    80001724:	ec06                	sd	ra,24(sp)
    80001726:	e822                	sd	s0,16(sp)
    80001728:	e426                	sd	s1,8(sp)
    8000172a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	976080e7          	jalr	-1674(ra) # 800010a2 <myproc>
    80001734:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	c9c080e7          	jalr	-868(ra) # 800063d2 <acquire>
  p->state = RUNNABLE;
    8000173e:	478d                	li	a5,3
    80001740:	cc9c                	sw	a5,24(s1)
  sched();
    80001742:	00000097          	auipc	ra,0x0
    80001746:	f0a080e7          	jalr	-246(ra) # 8000164c <sched>
  release(&p->lock);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	d3a080e7          	jalr	-710(ra) # 80006486 <release>
}
    80001754:	60e2                	ld	ra,24(sp)
    80001756:	6442                	ld	s0,16(sp)
    80001758:	64a2                	ld	s1,8(sp)
    8000175a:	6105                	addi	sp,sp,32
    8000175c:	8082                	ret

000000008000175e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	89aa                	mv	s3,a0
    8000176e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001770:	00000097          	auipc	ra,0x0
    80001774:	932080e7          	jalr	-1742(ra) # 800010a2 <myproc>
    80001778:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	c58080e7          	jalr	-936(ra) # 800063d2 <acquire>
  release(lk);
    80001782:	854a                	mv	a0,s2
    80001784:	00005097          	auipc	ra,0x5
    80001788:	d02080e7          	jalr	-766(ra) # 80006486 <release>

  // Go to sleep.
  p->chan = chan;
    8000178c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001790:	4789                	li	a5,2
    80001792:	cc9c                	sw	a5,24(s1)

  sched();
    80001794:	00000097          	auipc	ra,0x0
    80001798:	eb8080e7          	jalr	-328(ra) # 8000164c <sched>

  // Tidy up.
  p->chan = 0;
    8000179c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017a0:	8526                	mv	a0,s1
    800017a2:	00005097          	auipc	ra,0x5
    800017a6:	ce4080e7          	jalr	-796(ra) # 80006486 <release>
  acquire(lk);
    800017aa:	854a                	mv	a0,s2
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	c26080e7          	jalr	-986(ra) # 800063d2 <acquire>
}
    800017b4:	70a2                	ld	ra,40(sp)
    800017b6:	7402                	ld	s0,32(sp)
    800017b8:	64e2                	ld	s1,24(sp)
    800017ba:	6942                	ld	s2,16(sp)
    800017bc:	69a2                	ld	s3,8(sp)
    800017be:	6145                	addi	sp,sp,48
    800017c0:	8082                	ret

00000000800017c2 <wait>:
{
    800017c2:	715d                	addi	sp,sp,-80
    800017c4:	e486                	sd	ra,72(sp)
    800017c6:	e0a2                	sd	s0,64(sp)
    800017c8:	fc26                	sd	s1,56(sp)
    800017ca:	f84a                	sd	s2,48(sp)
    800017cc:	f44e                	sd	s3,40(sp)
    800017ce:	f052                	sd	s4,32(sp)
    800017d0:	ec56                	sd	s5,24(sp)
    800017d2:	e85a                	sd	s6,16(sp)
    800017d4:	e45e                	sd	s7,8(sp)
    800017d6:	e062                	sd	s8,0(sp)
    800017d8:	0880                	addi	s0,sp,80
    800017da:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	8c6080e7          	jalr	-1850(ra) # 800010a2 <myproc>
    800017e4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017e6:	00108517          	auipc	a0,0x108
    800017ea:	88250513          	addi	a0,a0,-1918 # 80109068 <wait_lock>
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	be4080e7          	jalr	-1052(ra) # 800063d2 <acquire>
    havekids = 0;
    800017f6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800017f8:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800017fa:	0010d997          	auipc	s3,0x10d
    800017fe:	68698993          	addi	s3,s3,1670 # 8010ee80 <tickslock>
        havekids = 1;
    80001802:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001804:	00108c17          	auipc	s8,0x108
    80001808:	864c0c13          	addi	s8,s8,-1948 # 80109068 <wait_lock>
    havekids = 0;
    8000180c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000180e:	00108497          	auipc	s1,0x108
    80001812:	c7248493          	addi	s1,s1,-910 # 80109480 <proc>
    80001816:	a0bd                	j	80001884 <wait+0xc2>
          pid = np->pid;
    80001818:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000181c:	000b0e63          	beqz	s6,80001838 <wait+0x76>
    80001820:	4691                	li	a3,4
    80001822:	02c48613          	addi	a2,s1,44
    80001826:	85da                	mv	a1,s6
    80001828:	05093503          	ld	a0,80(s2)
    8000182c:	fffff097          	auipc	ra,0xfffff
    80001830:	51a080e7          	jalr	1306(ra) # 80000d46 <copyout>
    80001834:	02054563          	bltz	a0,8000185e <wait+0x9c>
          freeproc(np);
    80001838:	8526                	mv	a0,s1
    8000183a:	00000097          	auipc	ra,0x0
    8000183e:	a1a080e7          	jalr	-1510(ra) # 80001254 <freeproc>
          release(&np->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	c42080e7          	jalr	-958(ra) # 80006486 <release>
          release(&wait_lock);
    8000184c:	00108517          	auipc	a0,0x108
    80001850:	81c50513          	addi	a0,a0,-2020 # 80109068 <wait_lock>
    80001854:	00005097          	auipc	ra,0x5
    80001858:	c32080e7          	jalr	-974(ra) # 80006486 <release>
          return pid;
    8000185c:	a09d                	j	800018c2 <wait+0x100>
            release(&np->lock);
    8000185e:	8526                	mv	a0,s1
    80001860:	00005097          	auipc	ra,0x5
    80001864:	c26080e7          	jalr	-986(ra) # 80006486 <release>
            release(&wait_lock);
    80001868:	00108517          	auipc	a0,0x108
    8000186c:	80050513          	addi	a0,a0,-2048 # 80109068 <wait_lock>
    80001870:	00005097          	auipc	ra,0x5
    80001874:	c16080e7          	jalr	-1002(ra) # 80006486 <release>
            return -1;
    80001878:	59fd                	li	s3,-1
    8000187a:	a0a1                	j	800018c2 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000187c:	16848493          	addi	s1,s1,360
    80001880:	03348463          	beq	s1,s3,800018a8 <wait+0xe6>
      if(np->parent == p){
    80001884:	7c9c                	ld	a5,56(s1)
    80001886:	ff279be3          	bne	a5,s2,8000187c <wait+0xba>
        acquire(&np->lock);
    8000188a:	8526                	mv	a0,s1
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	b46080e7          	jalr	-1210(ra) # 800063d2 <acquire>
        if(np->state == ZOMBIE){
    80001894:	4c9c                	lw	a5,24(s1)
    80001896:	f94781e3          	beq	a5,s4,80001818 <wait+0x56>
        release(&np->lock);
    8000189a:	8526                	mv	a0,s1
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	bea080e7          	jalr	-1046(ra) # 80006486 <release>
        havekids = 1;
    800018a4:	8756                	mv	a4,s5
    800018a6:	bfd9                	j	8000187c <wait+0xba>
    if(!havekids || p->killed){
    800018a8:	c701                	beqz	a4,800018b0 <wait+0xee>
    800018aa:	02892783          	lw	a5,40(s2)
    800018ae:	c79d                	beqz	a5,800018dc <wait+0x11a>
      release(&wait_lock);
    800018b0:	00107517          	auipc	a0,0x107
    800018b4:	7b850513          	addi	a0,a0,1976 # 80109068 <wait_lock>
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	bce080e7          	jalr	-1074(ra) # 80006486 <release>
      return -1;
    800018c0:	59fd                	li	s3,-1
}
    800018c2:	854e                	mv	a0,s3
    800018c4:	60a6                	ld	ra,72(sp)
    800018c6:	6406                	ld	s0,64(sp)
    800018c8:	74e2                	ld	s1,56(sp)
    800018ca:	7942                	ld	s2,48(sp)
    800018cc:	79a2                	ld	s3,40(sp)
    800018ce:	7a02                	ld	s4,32(sp)
    800018d0:	6ae2                	ld	s5,24(sp)
    800018d2:	6b42                	ld	s6,16(sp)
    800018d4:	6ba2                	ld	s7,8(sp)
    800018d6:	6c02                	ld	s8,0(sp)
    800018d8:	6161                	addi	sp,sp,80
    800018da:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018dc:	85e2                	mv	a1,s8
    800018de:	854a                	mv	a0,s2
    800018e0:	00000097          	auipc	ra,0x0
    800018e4:	e7e080e7          	jalr	-386(ra) # 8000175e <sleep>
    havekids = 0;
    800018e8:	b715                	j	8000180c <wait+0x4a>

00000000800018ea <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018ea:	7139                	addi	sp,sp,-64
    800018ec:	fc06                	sd	ra,56(sp)
    800018ee:	f822                	sd	s0,48(sp)
    800018f0:	f426                	sd	s1,40(sp)
    800018f2:	f04a                	sd	s2,32(sp)
    800018f4:	ec4e                	sd	s3,24(sp)
    800018f6:	e852                	sd	s4,16(sp)
    800018f8:	e456                	sd	s5,8(sp)
    800018fa:	0080                	addi	s0,sp,64
    800018fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018fe:	00108497          	auipc	s1,0x108
    80001902:	b8248493          	addi	s1,s1,-1150 # 80109480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001906:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001908:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000190a:	0010d917          	auipc	s2,0x10d
    8000190e:	57690913          	addi	s2,s2,1398 # 8010ee80 <tickslock>
    80001912:	a821                	j	8000192a <wakeup+0x40>
        p->state = RUNNABLE;
    80001914:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001918:	8526                	mv	a0,s1
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	b6c080e7          	jalr	-1172(ra) # 80006486 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001922:	16848493          	addi	s1,s1,360
    80001926:	03248463          	beq	s1,s2,8000194e <wakeup+0x64>
    if(p != myproc()){
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	778080e7          	jalr	1912(ra) # 800010a2 <myproc>
    80001932:	fea488e3          	beq	s1,a0,80001922 <wakeup+0x38>
      acquire(&p->lock);
    80001936:	8526                	mv	a0,s1
    80001938:	00005097          	auipc	ra,0x5
    8000193c:	a9a080e7          	jalr	-1382(ra) # 800063d2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001940:	4c9c                	lw	a5,24(s1)
    80001942:	fd379be3          	bne	a5,s3,80001918 <wakeup+0x2e>
    80001946:	709c                	ld	a5,32(s1)
    80001948:	fd4798e3          	bne	a5,s4,80001918 <wakeup+0x2e>
    8000194c:	b7e1                	j	80001914 <wakeup+0x2a>
    }
  }
}
    8000194e:	70e2                	ld	ra,56(sp)
    80001950:	7442                	ld	s0,48(sp)
    80001952:	74a2                	ld	s1,40(sp)
    80001954:	7902                	ld	s2,32(sp)
    80001956:	69e2                	ld	s3,24(sp)
    80001958:	6a42                	ld	s4,16(sp)
    8000195a:	6aa2                	ld	s5,8(sp)
    8000195c:	6121                	addi	sp,sp,64
    8000195e:	8082                	ret

0000000080001960 <reparent>:
{
    80001960:	7179                	addi	sp,sp,-48
    80001962:	f406                	sd	ra,40(sp)
    80001964:	f022                	sd	s0,32(sp)
    80001966:	ec26                	sd	s1,24(sp)
    80001968:	e84a                	sd	s2,16(sp)
    8000196a:	e44e                	sd	s3,8(sp)
    8000196c:	e052                	sd	s4,0(sp)
    8000196e:	1800                	addi	s0,sp,48
    80001970:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001972:	00108497          	auipc	s1,0x108
    80001976:	b0e48493          	addi	s1,s1,-1266 # 80109480 <proc>
      pp->parent = initproc;
    8000197a:	00007a17          	auipc	s4,0x7
    8000197e:	696a0a13          	addi	s4,s4,1686 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001982:	0010d997          	auipc	s3,0x10d
    80001986:	4fe98993          	addi	s3,s3,1278 # 8010ee80 <tickslock>
    8000198a:	a029                	j	80001994 <reparent+0x34>
    8000198c:	16848493          	addi	s1,s1,360
    80001990:	01348d63          	beq	s1,s3,800019aa <reparent+0x4a>
    if(pp->parent == p){
    80001994:	7c9c                	ld	a5,56(s1)
    80001996:	ff279be3          	bne	a5,s2,8000198c <reparent+0x2c>
      pp->parent = initproc;
    8000199a:	000a3503          	ld	a0,0(s4)
    8000199e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800019a0:	00000097          	auipc	ra,0x0
    800019a4:	f4a080e7          	jalr	-182(ra) # 800018ea <wakeup>
    800019a8:	b7d5                	j	8000198c <reparent+0x2c>
}
    800019aa:	70a2                	ld	ra,40(sp)
    800019ac:	7402                	ld	s0,32(sp)
    800019ae:	64e2                	ld	s1,24(sp)
    800019b0:	6942                	ld	s2,16(sp)
    800019b2:	69a2                	ld	s3,8(sp)
    800019b4:	6a02                	ld	s4,0(sp)
    800019b6:	6145                	addi	sp,sp,48
    800019b8:	8082                	ret

00000000800019ba <exit>:
{
    800019ba:	7179                	addi	sp,sp,-48
    800019bc:	f406                	sd	ra,40(sp)
    800019be:	f022                	sd	s0,32(sp)
    800019c0:	ec26                	sd	s1,24(sp)
    800019c2:	e84a                	sd	s2,16(sp)
    800019c4:	e44e                	sd	s3,8(sp)
    800019c6:	e052                	sd	s4,0(sp)
    800019c8:	1800                	addi	s0,sp,48
    800019ca:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	6d6080e7          	jalr	1750(ra) # 800010a2 <myproc>
    800019d4:	89aa                	mv	s3,a0
  if(p == initproc)
    800019d6:	00007797          	auipc	a5,0x7
    800019da:	63a7b783          	ld	a5,1594(a5) # 80009010 <initproc>
    800019de:	0d050493          	addi	s1,a0,208
    800019e2:	15050913          	addi	s2,a0,336
    800019e6:	02a79363          	bne	a5,a0,80001a0c <exit+0x52>
    panic("init exiting");
    800019ea:	00007517          	auipc	a0,0x7
    800019ee:	82e50513          	addi	a0,a0,-2002 # 80008218 <etext+0x218>
    800019f2:	00004097          	auipc	ra,0x4
    800019f6:	496080e7          	jalr	1174(ra) # 80005e88 <panic>
      fileclose(f);
    800019fa:	00002097          	auipc	ra,0x2
    800019fe:	27e080e7          	jalr	638(ra) # 80003c78 <fileclose>
      p->ofile[fd] = 0;
    80001a02:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a06:	04a1                	addi	s1,s1,8
    80001a08:	01248563          	beq	s1,s2,80001a12 <exit+0x58>
    if(p->ofile[fd]){
    80001a0c:	6088                	ld	a0,0(s1)
    80001a0e:	f575                	bnez	a0,800019fa <exit+0x40>
    80001a10:	bfdd                	j	80001a06 <exit+0x4c>
  begin_op();
    80001a12:	00002097          	auipc	ra,0x2
    80001a16:	d9a080e7          	jalr	-614(ra) # 800037ac <begin_op>
  iput(p->cwd);
    80001a1a:	1509b503          	ld	a0,336(s3)
    80001a1e:	00001097          	auipc	ra,0x1
    80001a22:	576080e7          	jalr	1398(ra) # 80002f94 <iput>
  end_op();
    80001a26:	00002097          	auipc	ra,0x2
    80001a2a:	e06080e7          	jalr	-506(ra) # 8000382c <end_op>
  p->cwd = 0;
    80001a2e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a32:	00107497          	auipc	s1,0x107
    80001a36:	63648493          	addi	s1,s1,1590 # 80109068 <wait_lock>
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	00005097          	auipc	ra,0x5
    80001a40:	996080e7          	jalr	-1642(ra) # 800063d2 <acquire>
  reparent(p);
    80001a44:	854e                	mv	a0,s3
    80001a46:	00000097          	auipc	ra,0x0
    80001a4a:	f1a080e7          	jalr	-230(ra) # 80001960 <reparent>
  wakeup(p->parent);
    80001a4e:	0389b503          	ld	a0,56(s3)
    80001a52:	00000097          	auipc	ra,0x0
    80001a56:	e98080e7          	jalr	-360(ra) # 800018ea <wakeup>
  acquire(&p->lock);
    80001a5a:	854e                	mv	a0,s3
    80001a5c:	00005097          	auipc	ra,0x5
    80001a60:	976080e7          	jalr	-1674(ra) # 800063d2 <acquire>
  p->xstate = status;
    80001a64:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a68:	4795                	li	a5,5
    80001a6a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	a16080e7          	jalr	-1514(ra) # 80006486 <release>
  sched();
    80001a78:	00000097          	auipc	ra,0x0
    80001a7c:	bd4080e7          	jalr	-1068(ra) # 8000164c <sched>
  panic("zombie exit");
    80001a80:	00006517          	auipc	a0,0x6
    80001a84:	7a850513          	addi	a0,a0,1960 # 80008228 <etext+0x228>
    80001a88:	00004097          	auipc	ra,0x4
    80001a8c:	400080e7          	jalr	1024(ra) # 80005e88 <panic>

0000000080001a90 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a90:	7179                	addi	sp,sp,-48
    80001a92:	f406                	sd	ra,40(sp)
    80001a94:	f022                	sd	s0,32(sp)
    80001a96:	ec26                	sd	s1,24(sp)
    80001a98:	e84a                	sd	s2,16(sp)
    80001a9a:	e44e                	sd	s3,8(sp)
    80001a9c:	1800                	addi	s0,sp,48
    80001a9e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001aa0:	00108497          	auipc	s1,0x108
    80001aa4:	9e048493          	addi	s1,s1,-1568 # 80109480 <proc>
    80001aa8:	0010d997          	auipc	s3,0x10d
    80001aac:	3d898993          	addi	s3,s3,984 # 8010ee80 <tickslock>
    acquire(&p->lock);
    80001ab0:	8526                	mv	a0,s1
    80001ab2:	00005097          	auipc	ra,0x5
    80001ab6:	920080e7          	jalr	-1760(ra) # 800063d2 <acquire>
    if(p->pid == pid){
    80001aba:	589c                	lw	a5,48(s1)
    80001abc:	01278d63          	beq	a5,s2,80001ad6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ac0:	8526                	mv	a0,s1
    80001ac2:	00005097          	auipc	ra,0x5
    80001ac6:	9c4080e7          	jalr	-1596(ra) # 80006486 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aca:	16848493          	addi	s1,s1,360
    80001ace:	ff3491e3          	bne	s1,s3,80001ab0 <kill+0x20>
  }
  return -1;
    80001ad2:	557d                	li	a0,-1
    80001ad4:	a829                	j	80001aee <kill+0x5e>
      p->killed = 1;
    80001ad6:	4785                	li	a5,1
    80001ad8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ada:	4c98                	lw	a4,24(s1)
    80001adc:	4789                	li	a5,2
    80001ade:	00f70f63          	beq	a4,a5,80001afc <kill+0x6c>
      release(&p->lock);
    80001ae2:	8526                	mv	a0,s1
    80001ae4:	00005097          	auipc	ra,0x5
    80001ae8:	9a2080e7          	jalr	-1630(ra) # 80006486 <release>
      return 0;
    80001aec:	4501                	li	a0,0
}
    80001aee:	70a2                	ld	ra,40(sp)
    80001af0:	7402                	ld	s0,32(sp)
    80001af2:	64e2                	ld	s1,24(sp)
    80001af4:	6942                	ld	s2,16(sp)
    80001af6:	69a2                	ld	s3,8(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
        p->state = RUNNABLE;
    80001afc:	478d                	li	a5,3
    80001afe:	cc9c                	sw	a5,24(s1)
    80001b00:	b7cd                	j	80001ae2 <kill+0x52>

0000000080001b02 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b02:	7179                	addi	sp,sp,-48
    80001b04:	f406                	sd	ra,40(sp)
    80001b06:	f022                	sd	s0,32(sp)
    80001b08:	ec26                	sd	s1,24(sp)
    80001b0a:	e84a                	sd	s2,16(sp)
    80001b0c:	e44e                	sd	s3,8(sp)
    80001b0e:	e052                	sd	s4,0(sp)
    80001b10:	1800                	addi	s0,sp,48
    80001b12:	84aa                	mv	s1,a0
    80001b14:	892e                	mv	s2,a1
    80001b16:	89b2                	mv	s3,a2
    80001b18:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	588080e7          	jalr	1416(ra) # 800010a2 <myproc>
  if(user_dst){
    80001b22:	c08d                	beqz	s1,80001b44 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b24:	86d2                	mv	a3,s4
    80001b26:	864e                	mv	a2,s3
    80001b28:	85ca                	mv	a1,s2
    80001b2a:	6928                	ld	a0,80(a0)
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	21a080e7          	jalr	538(ra) # 80000d46 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b34:	70a2                	ld	ra,40(sp)
    80001b36:	7402                	ld	s0,32(sp)
    80001b38:	64e2                	ld	s1,24(sp)
    80001b3a:	6942                	ld	s2,16(sp)
    80001b3c:	69a2                	ld	s3,8(sp)
    80001b3e:	6a02                	ld	s4,0(sp)
    80001b40:	6145                	addi	sp,sp,48
    80001b42:	8082                	ret
    memmove((char *)dst, src, len);
    80001b44:	000a061b          	sext.w	a2,s4
    80001b48:	85ce                	mv	a1,s3
    80001b4a:	854a                	mv	a0,s2
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	8ba080e7          	jalr	-1862(ra) # 80000406 <memmove>
    return 0;
    80001b54:	8526                	mv	a0,s1
    80001b56:	bff9                	j	80001b34 <either_copyout+0x32>

0000000080001b58 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b58:	7179                	addi	sp,sp,-48
    80001b5a:	f406                	sd	ra,40(sp)
    80001b5c:	f022                	sd	s0,32(sp)
    80001b5e:	ec26                	sd	s1,24(sp)
    80001b60:	e84a                	sd	s2,16(sp)
    80001b62:	e44e                	sd	s3,8(sp)
    80001b64:	e052                	sd	s4,0(sp)
    80001b66:	1800                	addi	s0,sp,48
    80001b68:	892a                	mv	s2,a0
    80001b6a:	84ae                	mv	s1,a1
    80001b6c:	89b2                	mv	s3,a2
    80001b6e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	532080e7          	jalr	1330(ra) # 800010a2 <myproc>
  if(user_src){
    80001b78:	c08d                	beqz	s1,80001b9a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b7a:	86d2                	mv	a3,s4
    80001b7c:	864e                	mv	a2,s3
    80001b7e:	85ca                	mv	a1,s2
    80001b80:	6928                	ld	a0,80(a0)
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	26e080e7          	jalr	622(ra) # 80000df0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b8a:	70a2                	ld	ra,40(sp)
    80001b8c:	7402                	ld	s0,32(sp)
    80001b8e:	64e2                	ld	s1,24(sp)
    80001b90:	6942                	ld	s2,16(sp)
    80001b92:	69a2                	ld	s3,8(sp)
    80001b94:	6a02                	ld	s4,0(sp)
    80001b96:	6145                	addi	sp,sp,48
    80001b98:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b9a:	000a061b          	sext.w	a2,s4
    80001b9e:	85ce                	mv	a1,s3
    80001ba0:	854a                	mv	a0,s2
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	864080e7          	jalr	-1948(ra) # 80000406 <memmove>
    return 0;
    80001baa:	8526                	mv	a0,s1
    80001bac:	bff9                	j	80001b8a <either_copyin+0x32>

0000000080001bae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bae:	715d                	addi	sp,sp,-80
    80001bb0:	e486                	sd	ra,72(sp)
    80001bb2:	e0a2                	sd	s0,64(sp)
    80001bb4:	fc26                	sd	s1,56(sp)
    80001bb6:	f84a                	sd	s2,48(sp)
    80001bb8:	f44e                	sd	s3,40(sp)
    80001bba:	f052                	sd	s4,32(sp)
    80001bbc:	ec56                	sd	s5,24(sp)
    80001bbe:	e85a                	sd	s6,16(sp)
    80001bc0:	e45e                	sd	s7,8(sp)
    80001bc2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bc4:	00006517          	auipc	a0,0x6
    80001bc8:	4bc50513          	addi	a0,a0,1212 # 80008080 <etext+0x80>
    80001bcc:	00004097          	auipc	ra,0x4
    80001bd0:	306080e7          	jalr	774(ra) # 80005ed2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bd4:	00108497          	auipc	s1,0x108
    80001bd8:	a0448493          	addi	s1,s1,-1532 # 801095d8 <proc+0x158>
    80001bdc:	0010d917          	auipc	s2,0x10d
    80001be0:	3fc90913          	addi	s2,s2,1020 # 8010efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001be4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001be6:	00006997          	auipc	s3,0x6
    80001bea:	65298993          	addi	s3,s3,1618 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001bee:	00006a97          	auipc	s5,0x6
    80001bf2:	652a8a93          	addi	s5,s5,1618 # 80008240 <etext+0x240>
    printf("\n");
    80001bf6:	00006a17          	auipc	s4,0x6
    80001bfa:	48aa0a13          	addi	s4,s4,1162 # 80008080 <etext+0x80>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfe:	00006b97          	auipc	s7,0x6
    80001c02:	67ab8b93          	addi	s7,s7,1658 # 80008278 <states.1725>
    80001c06:	a00d                	j	80001c28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c08:	ed86a583          	lw	a1,-296(a3)
    80001c0c:	8556                	mv	a0,s5
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	2c4080e7          	jalr	708(ra) # 80005ed2 <printf>
    printf("\n");
    80001c16:	8552                	mv	a0,s4
    80001c18:	00004097          	auipc	ra,0x4
    80001c1c:	2ba080e7          	jalr	698(ra) # 80005ed2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c20:	16848493          	addi	s1,s1,360
    80001c24:	03248163          	beq	s1,s2,80001c46 <procdump+0x98>
    if(p->state == UNUSED)
    80001c28:	86a6                	mv	a3,s1
    80001c2a:	ec04a783          	lw	a5,-320(s1)
    80001c2e:	dbed                	beqz	a5,80001c20 <procdump+0x72>
      state = "???";
    80001c30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c32:	fcfb6be3          	bltu	s6,a5,80001c08 <procdump+0x5a>
    80001c36:	1782                	slli	a5,a5,0x20
    80001c38:	9381                	srli	a5,a5,0x20
    80001c3a:	078e                	slli	a5,a5,0x3
    80001c3c:	97de                	add	a5,a5,s7
    80001c3e:	6390                	ld	a2,0(a5)
    80001c40:	f661                	bnez	a2,80001c08 <procdump+0x5a>
      state = "???";
    80001c42:	864e                	mv	a2,s3
    80001c44:	b7d1                	j	80001c08 <procdump+0x5a>
  }
}
    80001c46:	60a6                	ld	ra,72(sp)
    80001c48:	6406                	ld	s0,64(sp)
    80001c4a:	74e2                	ld	s1,56(sp)
    80001c4c:	7942                	ld	s2,48(sp)
    80001c4e:	79a2                	ld	s3,40(sp)
    80001c50:	7a02                	ld	s4,32(sp)
    80001c52:	6ae2                	ld	s5,24(sp)
    80001c54:	6b42                	ld	s6,16(sp)
    80001c56:	6ba2                	ld	s7,8(sp)
    80001c58:	6161                	addi	sp,sp,80
    80001c5a:	8082                	ret

0000000080001c5c <swtch>:
    80001c5c:	00153023          	sd	ra,0(a0)
    80001c60:	00253423          	sd	sp,8(a0)
    80001c64:	e900                	sd	s0,16(a0)
    80001c66:	ed04                	sd	s1,24(a0)
    80001c68:	03253023          	sd	s2,32(a0)
    80001c6c:	03353423          	sd	s3,40(a0)
    80001c70:	03453823          	sd	s4,48(a0)
    80001c74:	03553c23          	sd	s5,56(a0)
    80001c78:	05653023          	sd	s6,64(a0)
    80001c7c:	05753423          	sd	s7,72(a0)
    80001c80:	05853823          	sd	s8,80(a0)
    80001c84:	05953c23          	sd	s9,88(a0)
    80001c88:	07a53023          	sd	s10,96(a0)
    80001c8c:	07b53423          	sd	s11,104(a0)
    80001c90:	0005b083          	ld	ra,0(a1)
    80001c94:	0085b103          	ld	sp,8(a1)
    80001c98:	6980                	ld	s0,16(a1)
    80001c9a:	6d84                	ld	s1,24(a1)
    80001c9c:	0205b903          	ld	s2,32(a1)
    80001ca0:	0285b983          	ld	s3,40(a1)
    80001ca4:	0305ba03          	ld	s4,48(a1)
    80001ca8:	0385ba83          	ld	s5,56(a1)
    80001cac:	0405bb03          	ld	s6,64(a1)
    80001cb0:	0485bb83          	ld	s7,72(a1)
    80001cb4:	0505bc03          	ld	s8,80(a1)
    80001cb8:	0585bc83          	ld	s9,88(a1)
    80001cbc:	0605bd03          	ld	s10,96(a1)
    80001cc0:	0685bd83          	ld	s11,104(a1)
    80001cc4:	8082                	ret

0000000080001cc6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cc6:	1141                	addi	sp,sp,-16
    80001cc8:	e406                	sd	ra,8(sp)
    80001cca:	e022                	sd	s0,0(sp)
    80001ccc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cce:	00006597          	auipc	a1,0x6
    80001cd2:	5da58593          	addi	a1,a1,1498 # 800082a8 <states.1725+0x30>
    80001cd6:	0010d517          	auipc	a0,0x10d
    80001cda:	1aa50513          	addi	a0,a0,426 # 8010ee80 <tickslock>
    80001cde:	00004097          	auipc	ra,0x4
    80001ce2:	664080e7          	jalr	1636(ra) # 80006342 <initlock>
}
    80001ce6:	60a2                	ld	ra,8(sp)
    80001ce8:	6402                	ld	s0,0(sp)
    80001cea:	0141                	addi	sp,sp,16
    80001cec:	8082                	ret

0000000080001cee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cee:	1141                	addi	sp,sp,-16
    80001cf0:	e422                	sd	s0,8(sp)
    80001cf2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf4:	00003797          	auipc	a5,0x3
    80001cf8:	59c78793          	addi	a5,a5,1436 # 80005290 <kernelvec>
    80001cfc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d00:	6422                	ld	s0,8(sp)
    80001d02:	0141                	addi	sp,sp,16
    80001d04:	8082                	ret

0000000080001d06 <cowpagefault>:

int cowpagefault(pagetable_t pgt, uint64 va)
{
  if (va >= MAXVA)
    80001d06:	57fd                	li	a5,-1
    80001d08:	83e9                	srli	a5,a5,0x1a
    80001d0a:	00b7f463          	bgeu	a5,a1,80001d12 <cowpagefault+0xc>
    return 0;
    80001d0e:	4501                	li	a0,0
  if (!(*pte & PTE_V))
    return 0;
  if (*pte & PTE_F)
    return 1;
  return 0;
}
    80001d10:	8082                	ret
{
    80001d12:	1141                	addi	sp,sp,-16
    80001d14:	e406                	sd	ra,8(sp)
    80001d16:	e022                	sd	s0,0(sp)
    80001d18:	0800                	addi	s0,sp,16
  if ((pte = walk(pgt, va, 0)) == 0)
    80001d1a:	4601                	li	a2,0
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	972080e7          	jalr	-1678(ra) # 8000068e <walk>
    80001d24:	cd01                	beqz	a0,80001d3c <cowpagefault+0x36>
  if (*pte & PTE_F)
    80001d26:	6108                	ld	a0,0(a0)
    80001d28:	10157513          	andi	a0,a0,257
    80001d2c:	eff50513          	addi	a0,a0,-257
    return 0;
    80001d30:	00153513          	seqz	a0,a0
}
    80001d34:	60a2                	ld	ra,8(sp)
    80001d36:	6402                	ld	s0,0(sp)
    80001d38:	0141                	addi	sp,sp,16
    80001d3a:	8082                	ret
    return 0;
    80001d3c:	4501                	li	a0,0
    80001d3e:	bfdd                	j	80001d34 <cowpagefault+0x2e>

0000000080001d40 <cowpagealloc>:

void* cowpagealloc(pagetable_t pgt, uint64 va)
{
    80001d40:	7179                	addi	sp,sp,-48
    80001d42:	f406                	sd	ra,40(sp)
    80001d44:	f022                	sd	s0,32(sp)
    80001d46:	ec26                	sd	s1,24(sp)
    80001d48:	e84a                	sd	s2,16(sp)
    80001d4a:	e44e                	sd	s3,8(sp)
    80001d4c:	1800                	addi	s0,sp,48
  if (va<0 || va>MAXVA)
    80001d4e:	4785                	li	a5,1
    80001d50:	179a                	slli	a5,a5,0x26
    return 0;
    80001d52:	4901                	li	s2,0
  if (va<0 || va>MAXVA)
    80001d54:	06b7ec63          	bltu	a5,a1,80001dcc <cowpagealloc+0x8c>
  va = PGROUNDDOWN(va);
  pte_t* pte = walk(pgt, va, 0);
    80001d58:	4601                	li	a2,0
    80001d5a:	77fd                	lui	a5,0xfffff
    80001d5c:	8dfd                	and	a1,a1,a5
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	930080e7          	jalr	-1744(ra) # 8000068e <walk>
    80001d66:	89aa                	mv	s3,a0
  uint64 old_pa = PTE2PA(*pte);
    80001d68:	6104                	ld	s1,0(a0)
    80001d6a:	80a9                	srli	s1,s1,0xa
    80001d6c:	04b2                	slli	s1,s1,0xc
  if (krefget((void*)old_pa) == 1)
    80001d6e:	8526                	mv	a0,s1
    80001d70:	ffffe097          	auipc	ra,0xffffe
    80001d74:	53c080e7          	jalr	1340(ra) # 800002ac <krefget>
    80001d78:	4785                	li	a5,1
    80001d7a:	04f50063          	beq	a0,a5,80001dba <cowpagealloc+0x7a>
    *pte &= (~PTE_F);
    return (void*)old_pa;
  }
  else
  {
    void* new_pa = kalloc();
    80001d7e:	ffffe097          	auipc	ra,0xffffe
    80001d82:	498080e7          	jalr	1176(ra) # 80000216 <kalloc>
    80001d86:	892a                	mv	s2,a0
    if (new_pa == 0)
    80001d88:	c131                	beqz	a0,80001dcc <cowpagealloc+0x8c>
      return new_pa;
    }
    else
    {
      //复制物理内存
      memmove(new_pa, (void*)old_pa, PGSIZE);
    80001d8a:	6605                	lui	a2,0x1
    80001d8c:	85a6                	mv	a1,s1
    80001d8e:	ffffe097          	auipc	ra,0xffffe
    80001d92:	678080e7          	jalr	1656(ra) # 80000406 <memmove>
      uint flags = PTE_FLAGS(*pte);
    80001d96:	0009b783          	ld	a5,0(s3)
      uint64 new_pte = PA2PTE(new_pa);
    80001d9a:	00c95713          	srli	a4,s2,0xc
    80001d9e:	072a                	slli	a4,a4,0xa
      *pte = new_pte | flags;
    80001da0:	2ff7f793          	andi	a5,a5,767
      *pte |= PTE_W;
      *pte &= (~PTE_F);
    80001da4:	8fd9                	or	a5,a5,a4
    80001da6:	0047e793          	ori	a5,a5,4
    80001daa:	00f9b023          	sd	a5,0(s3)
      kfree((void*)old_pa);
    80001dae:	8526                	mv	a0,s1
    80001db0:	ffffe097          	auipc	ra,0xffffe
    80001db4:	26c080e7          	jalr	620(ra) # 8000001c <kfree>
      return new_pa;
    80001db8:	a811                	j	80001dcc <cowpagealloc+0x8c>
    *pte &= (~PTE_F);
    80001dba:	0009b783          	ld	a5,0(s3)
    80001dbe:	eff7f793          	andi	a5,a5,-257
    80001dc2:	0047e793          	ori	a5,a5,4
    80001dc6:	00f9b023          	sd	a5,0(s3)
    return (void*)old_pa;
    80001dca:	8926                	mv	s2,s1
    }
  }
  return 0;
}
    80001dcc:	854a                	mv	a0,s2
    80001dce:	70a2                	ld	ra,40(sp)
    80001dd0:	7402                	ld	s0,32(sp)
    80001dd2:	64e2                	ld	s1,24(sp)
    80001dd4:	6942                	ld	s2,16(sp)
    80001dd6:	69a2                	ld	s3,8(sp)
    80001dd8:	6145                	addi	sp,sp,48
    80001dda:	8082                	ret

0000000080001ddc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ddc:	1141                	addi	sp,sp,-16
    80001dde:	e406                	sd	ra,8(sp)
    80001de0:	e022                	sd	s0,0(sp)
    80001de2:	0800                	addi	s0,sp,16
  struct proc* p = myproc();
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	2be080e7          	jalr	702(ra) # 800010a2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80001dec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001df0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001df6:	00005617          	auipc	a2,0x5
    80001dfa:	20a60613          	addi	a2,a2,522 # 80007000 <_trampoline>
    80001dfe:	00005697          	auipc	a3,0x5
    80001e02:	20268693          	addi	a3,a3,514 # 80007000 <_trampoline>
    80001e06:	8e91                	sub	a3,a3,a2
    80001e08:	040007b7          	lui	a5,0x4000
    80001e0c:	17fd                	addi	a5,a5,-1
    80001e0e:	07b2                	slli	a5,a5,0xc
    80001e10:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e12:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001e16:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x));
    80001e18:	180026f3          	csrr	a3,satp
    80001e1c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001e1e:	6d38                	ld	a4,88(a0)
    80001e20:	6134                	ld	a3,64(a0)
    80001e22:	6585                	lui	a1,0x1
    80001e24:	96ae                	add	a3,a3,a1
    80001e26:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e28:	6d38                	ld	a4,88(a0)
    80001e2a:	00000697          	auipc	a3,0x0
    80001e2e:	13868693          	addi	a3,a3,312 # 80001f62 <usertrap>
    80001e32:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001e34:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x));
    80001e36:	8692                	mv	a3,tp
    80001e38:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80001e3a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001e3e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001e42:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e46:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e4c:	6f18                	ld	a4,24(a4)
    80001e4e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e52:	692c                	ld	a1,80(a0)
    80001e54:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001e56:	00005717          	auipc	a4,0x5
    80001e5a:	23a70713          	addi	a4,a4,570 # 80007090 <userret>
    80001e5e:	8f11                	sub	a4,a4,a2
    80001e60:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001e62:	577d                	li	a4,-1
    80001e64:	177e                	slli	a4,a4,0x3f
    80001e66:	8dd9                	or	a1,a1,a4
    80001e68:	02000537          	lui	a0,0x2000
    80001e6c:	157d                	addi	a0,a0,-1
    80001e6e:	0536                	slli	a0,a0,0xd
    80001e70:	9782                	jalr	a5
}
    80001e72:	60a2                	ld	ra,8(sp)
    80001e74:	6402                	ld	s0,0(sp)
    80001e76:	0141                	addi	sp,sp,16
    80001e78:	8082                	ret

0000000080001e7a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e7a:	1101                	addi	sp,sp,-32
    80001e7c:	ec06                	sd	ra,24(sp)
    80001e7e:	e822                	sd	s0,16(sp)
    80001e80:	e426                	sd	s1,8(sp)
    80001e82:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e84:	0010d497          	auipc	s1,0x10d
    80001e88:	ffc48493          	addi	s1,s1,-4 # 8010ee80 <tickslock>
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	544080e7          	jalr	1348(ra) # 800063d2 <acquire>
  ticks++;
    80001e96:	00007517          	auipc	a0,0x7
    80001e9a:	18250513          	addi	a0,a0,386 # 80009018 <ticks>
    80001e9e:	411c                	lw	a5,0(a0)
    80001ea0:	2785                	addiw	a5,a5,1
    80001ea2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ea4:	00000097          	auipc	ra,0x0
    80001ea8:	a46080e7          	jalr	-1466(ra) # 800018ea <wakeup>
  release(&tickslock);
    80001eac:	8526                	mv	a0,s1
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	5d8080e7          	jalr	1496(ra) # 80006486 <release>
}
    80001eb6:	60e2                	ld	ra,24(sp)
    80001eb8:	6442                	ld	s0,16(sp)
    80001eba:	64a2                	ld	s1,8(sp)
    80001ebc:	6105                	addi	sp,sp,32
    80001ebe:	8082                	ret

0000000080001ec0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ec0:	1101                	addi	sp,sp,-32
    80001ec2:	ec06                	sd	ra,24(sp)
    80001ec4:	e822                	sd	s0,16(sp)
    80001ec6:	e426                	sd	s1,8(sp)
    80001ec8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x));
    80001eca:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001ece:	00074d63          	bltz	a4,80001ee8 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L) {
    80001ed2:	57fd                	li	a5,-1
    80001ed4:	17fe                	slli	a5,a5,0x3f
    80001ed6:	0785                	addi	a5,a5,1
    w_sip(r_sip() & ~2);

    return 2;
  }
  else {
    return 0;
    80001ed8:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L) {
    80001eda:	06f70363          	beq	a4,a5,80001f40 <devintr+0x80>
  }
}
    80001ede:	60e2                	ld	ra,24(sp)
    80001ee0:	6442                	ld	s0,16(sp)
    80001ee2:	64a2                	ld	s1,8(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
    (scause & 0xff) == 9) {
    80001ee8:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80001eec:	46a5                	li	a3,9
    80001eee:	fed792e3          	bne	a5,a3,80001ed2 <devintr+0x12>
    int irq = plic_claim();
    80001ef2:	00003097          	auipc	ra,0x3
    80001ef6:	4a6080e7          	jalr	1190(ra) # 80005398 <plic_claim>
    80001efa:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001efc:	47a9                	li	a5,10
    80001efe:	02f50763          	beq	a0,a5,80001f2c <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ) {
    80001f02:	4785                	li	a5,1
    80001f04:	02f50963          	beq	a0,a5,80001f36 <devintr+0x76>
    return 1;
    80001f08:	4505                	li	a0,1
    else if (irq) {
    80001f0a:	d8f1                	beqz	s1,80001ede <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f0c:	85a6                	mv	a1,s1
    80001f0e:	00006517          	auipc	a0,0x6
    80001f12:	3a250513          	addi	a0,a0,930 # 800082b0 <states.1725+0x38>
    80001f16:	00004097          	auipc	ra,0x4
    80001f1a:	fbc080e7          	jalr	-68(ra) # 80005ed2 <printf>
      plic_complete(irq);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	00003097          	auipc	ra,0x3
    80001f24:	49c080e7          	jalr	1180(ra) # 800053bc <plic_complete>
    return 1;
    80001f28:	4505                	li	a0,1
    80001f2a:	bf55                	j	80001ede <devintr+0x1e>
      uartintr();
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	3c6080e7          	jalr	966(ra) # 800062f2 <uartintr>
    80001f34:	b7ed                	j	80001f1e <devintr+0x5e>
      virtio_disk_intr();
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	966080e7          	jalr	-1690(ra) # 8000589c <virtio_disk_intr>
    80001f3e:	b7c5                	j	80001f1e <devintr+0x5e>
    if (cpuid() == 0) {
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	136080e7          	jalr	310(ra) # 80001076 <cpuid>
    80001f48:	c901                	beqz	a0,80001f58 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x));
    80001f4a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f50:	14479073          	csrw	sip,a5
    return 2;
    80001f54:	4509                	li	a0,2
    80001f56:	b761                	j	80001ede <devintr+0x1e>
      clockintr();
    80001f58:	00000097          	auipc	ra,0x0
    80001f5c:	f22080e7          	jalr	-222(ra) # 80001e7a <clockintr>
    80001f60:	b7ed                	j	80001f4a <devintr+0x8a>

0000000080001f62 <usertrap>:
{
    80001f62:	7179                	addi	sp,sp,-48
    80001f64:	f406                	sd	ra,40(sp)
    80001f66:	f022                	sd	s0,32(sp)
    80001f68:	ec26                	sd	s1,24(sp)
    80001f6a:	e84a                	sd	s2,16(sp)
    80001f6c:	e44e                	sd	s3,8(sp)
    80001f6e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80001f70:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001f74:	1007f793          	andi	a5,a5,256
    80001f78:	e3b5                	bnez	a5,80001fdc <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f7a:	00003797          	auipc	a5,0x3
    80001f7e:	31678793          	addi	a5,a5,790 # 80005290 <kernelvec>
    80001f82:	10579073          	csrw	stvec,a5
  struct proc* p = myproc();
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	11c080e7          	jalr	284(ra) # 800010a2 <myproc>
    80001f8e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f90:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x));
    80001f92:	14102773          	csrr	a4,sepc
    80001f96:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x));
    80001f98:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001f9c:	47a1                	li	a5,8
    80001f9e:	04f71d63          	bne	a4,a5,80001ff8 <usertrap+0x96>
    if (p->killed)
    80001fa2:	551c                	lw	a5,40(a0)
    80001fa4:	e7a1                	bnez	a5,80001fec <usertrap+0x8a>
    p->trapframe->epc += 4;
    80001fa6:	6cb8                	ld	a4,88(s1)
    80001fa8:	6f1c                	ld	a5,24(a4)
    80001faa:	0791                	addi	a5,a5,4
    80001fac:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80001fae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb6:	10079073          	csrw	sstatus,a5
    syscall();
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	322080e7          	jalr	802(ra) # 800022dc <syscall>
  if (p->killed)
    80001fc2:	549c                	lw	a5,40(s1)
    80001fc4:	ebe9                	bnez	a5,80002096 <usertrap+0x134>
  usertrapret();
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	e16080e7          	jalr	-490(ra) # 80001ddc <usertrapret>
}
    80001fce:	70a2                	ld	ra,40(sp)
    80001fd0:	7402                	ld	s0,32(sp)
    80001fd2:	64e2                	ld	s1,24(sp)
    80001fd4:	6942                	ld	s2,16(sp)
    80001fd6:	69a2                	ld	s3,8(sp)
    80001fd8:	6145                	addi	sp,sp,48
    80001fda:	8082                	ret
    panic("usertrap: not from user mode");
    80001fdc:	00006517          	auipc	a0,0x6
    80001fe0:	2f450513          	addi	a0,a0,756 # 800082d0 <states.1725+0x58>
    80001fe4:	00004097          	auipc	ra,0x4
    80001fe8:	ea4080e7          	jalr	-348(ra) # 80005e88 <panic>
      exit(-1);
    80001fec:	557d                	li	a0,-1
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	9cc080e7          	jalr	-1588(ra) # 800019ba <exit>
    80001ff6:	bf45                	j	80001fa6 <usertrap+0x44>
  else if ((which_dev = devintr()) != 0) {
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	ec8080e7          	jalr	-312(ra) # 80001ec0 <devintr>
    80002000:	892a                	mv	s2,a0
    80002002:	e559                	bnez	a0,80002090 <usertrap+0x12e>
  asm volatile("csrr %0, scause" : "=r" (x));
    80002004:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80002008:	47b5                	li	a5,13
    8000200a:	00f70763          	beq	a4,a5,80002018 <usertrap+0xb6>
    8000200e:	14202773          	csrr	a4,scause
    80002012:	47bd                	li	a5,15
    80002014:	04f71463          	bne	a4,a5,8000205c <usertrap+0xfa>
  asm volatile("csrr %0, stval" : "=r" (x));
    80002018:	143029f3          	csrr	s3,stval
    if (cowpagefault(p->pagetable, va) == 0)
    8000201c:	85ce                	mv	a1,s3
    8000201e:	68a8                	ld	a0,80(s1)
    80002020:	00000097          	auipc	ra,0x0
    80002024:	ce6080e7          	jalr	-794(ra) # 80001d06 <cowpagefault>
    80002028:	e105                	bnez	a0,80002048 <usertrap+0xe6>
      p->killed = 1;
    8000202a:	4785                	li	a5,1
    8000202c:	d49c                	sw	a5,40(s1)
    exit(-1);
    8000202e:	557d                	li	a0,-1
    80002030:	00000097          	auipc	ra,0x0
    80002034:	98a080e7          	jalr	-1654(ra) # 800019ba <exit>
  if (which_dev == 2)
    80002038:	4789                	li	a5,2
    8000203a:	f8f916e3          	bne	s2,a5,80001fc6 <usertrap+0x64>
    yield();
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	6e4080e7          	jalr	1764(ra) # 80001722 <yield>
    80002046:	b741                	j	80001fc6 <usertrap+0x64>
    else if (cowpagealloc(p->pagetable, va) == 0)
    80002048:	85ce                	mv	a1,s3
    8000204a:	68a8                	ld	a0,80(s1)
    8000204c:	00000097          	auipc	ra,0x0
    80002050:	cf4080e7          	jalr	-780(ra) # 80001d40 <cowpagealloc>
    80002054:	f53d                	bnez	a0,80001fc2 <usertrap+0x60>
      p->killed = 1;
    80002056:	4785                	li	a5,1
    80002058:	d49c                	sw	a5,40(s1)
    8000205a:	bfd1                	j	8000202e <usertrap+0xcc>
  asm volatile("csrr %0, scause" : "=r" (x));
    8000205c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002060:	5890                	lw	a2,48(s1)
    80002062:	00006517          	auipc	a0,0x6
    80002066:	28e50513          	addi	a0,a0,654 # 800082f0 <states.1725+0x78>
    8000206a:	00004097          	auipc	ra,0x4
    8000206e:	e68080e7          	jalr	-408(ra) # 80005ed2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x));
    80002072:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x));
    80002076:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	2a650513          	addi	a0,a0,678 # 80008320 <states.1725+0xa8>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	e50080e7          	jalr	-432(ra) # 80005ed2 <printf>
    p->killed = 1;
    8000208a:	4785                	li	a5,1
    8000208c:	d49c                	sw	a5,40(s1)
    8000208e:	b745                	j	8000202e <usertrap+0xcc>
  if (p->killed)
    80002090:	549c                	lw	a5,40(s1)
    80002092:	d3dd                	beqz	a5,80002038 <usertrap+0xd6>
    80002094:	bf69                	j	8000202e <usertrap+0xcc>
    80002096:	4901                	li	s2,0
    80002098:	bf59                	j	8000202e <usertrap+0xcc>

000000008000209a <kerneltrap>:
{
    8000209a:	7179                	addi	sp,sp,-48
    8000209c:	f406                	sd	ra,40(sp)
    8000209e:	f022                	sd	s0,32(sp)
    800020a0:	ec26                	sd	s1,24(sp)
    800020a2:	e84a                	sd	s2,16(sp)
    800020a4:	e44e                	sd	s3,8(sp)
    800020a6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x));
    800020a8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x));
    800020ac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x));
    800020b0:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800020b4:	1004f793          	andi	a5,s1,256
    800020b8:	cb85                	beqz	a5,800020e8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    800020ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020be:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800020c0:	ef85                	bnez	a5,800020f8 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	dfe080e7          	jalr	-514(ra) # 80001ec0 <devintr>
    800020ca:	cd1d                	beqz	a0,80002108 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020cc:	4789                	li	a5,2
    800020ce:	06f50a63          	beq	a0,a5,80002142 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800020d2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020d6:	10049073          	csrw	sstatus,s1
}
    800020da:	70a2                	ld	ra,40(sp)
    800020dc:	7402                	ld	s0,32(sp)
    800020de:	64e2                	ld	s1,24(sp)
    800020e0:	6942                	ld	s2,16(sp)
    800020e2:	69a2                	ld	s3,8(sp)
    800020e4:	6145                	addi	sp,sp,48
    800020e6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	25850513          	addi	a0,a0,600 # 80008340 <states.1725+0xc8>
    800020f0:	00004097          	auipc	ra,0x4
    800020f4:	d98080e7          	jalr	-616(ra) # 80005e88 <panic>
    panic("kerneltrap: interrupts enabled");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	27050513          	addi	a0,a0,624 # 80008368 <states.1725+0xf0>
    80002100:	00004097          	auipc	ra,0x4
    80002104:	d88080e7          	jalr	-632(ra) # 80005e88 <panic>
    printf("scause %p\n", scause);
    80002108:	85ce                	mv	a1,s3
    8000210a:	00006517          	auipc	a0,0x6
    8000210e:	27e50513          	addi	a0,a0,638 # 80008388 <states.1725+0x110>
    80002112:	00004097          	auipc	ra,0x4
    80002116:	dc0080e7          	jalr	-576(ra) # 80005ed2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x));
    8000211a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x));
    8000211e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002122:	00006517          	auipc	a0,0x6
    80002126:	27650513          	addi	a0,a0,630 # 80008398 <states.1725+0x120>
    8000212a:	00004097          	auipc	ra,0x4
    8000212e:	da8080e7          	jalr	-600(ra) # 80005ed2 <printf>
    panic("kerneltrap");
    80002132:	00006517          	auipc	a0,0x6
    80002136:	27e50513          	addi	a0,a0,638 # 800083b0 <states.1725+0x138>
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	d4e080e7          	jalr	-690(ra) # 80005e88 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	f60080e7          	jalr	-160(ra) # 800010a2 <myproc>
    8000214a:	d541                	beqz	a0,800020d2 <kerneltrap+0x38>
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	f56080e7          	jalr	-170(ra) # 800010a2 <myproc>
    80002154:	4d18                	lw	a4,24(a0)
    80002156:	4791                	li	a5,4
    80002158:	f6f71de3          	bne	a4,a5,800020d2 <kerneltrap+0x38>
    yield();
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	5c6080e7          	jalr	1478(ra) # 80001722 <yield>
    80002164:	b7bd                	j	800020d2 <kerneltrap+0x38>

0000000080002166 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002166:	1101                	addi	sp,sp,-32
    80002168:	ec06                	sd	ra,24(sp)
    8000216a:	e822                	sd	s0,16(sp)
    8000216c:	e426                	sd	s1,8(sp)
    8000216e:	1000                	addi	s0,sp,32
    80002170:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	f30080e7          	jalr	-208(ra) # 800010a2 <myproc>
  switch (n) {
    8000217a:	4795                	li	a5,5
    8000217c:	0497e163          	bltu	a5,s1,800021be <argraw+0x58>
    80002180:	048a                	slli	s1,s1,0x2
    80002182:	00006717          	auipc	a4,0x6
    80002186:	26670713          	addi	a4,a4,614 # 800083e8 <states.1725+0x170>
    8000218a:	94ba                	add	s1,s1,a4
    8000218c:	409c                	lw	a5,0(s1)
    8000218e:	97ba                	add	a5,a5,a4
    80002190:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002192:	6d3c                	ld	a5,88(a0)
    80002194:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	64a2                	ld	s1,8(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret
    return p->trapframe->a1;
    800021a0:	6d3c                	ld	a5,88(a0)
    800021a2:	7fa8                	ld	a0,120(a5)
    800021a4:	bfcd                	j	80002196 <argraw+0x30>
    return p->trapframe->a2;
    800021a6:	6d3c                	ld	a5,88(a0)
    800021a8:	63c8                	ld	a0,128(a5)
    800021aa:	b7f5                	j	80002196 <argraw+0x30>
    return p->trapframe->a3;
    800021ac:	6d3c                	ld	a5,88(a0)
    800021ae:	67c8                	ld	a0,136(a5)
    800021b0:	b7dd                	j	80002196 <argraw+0x30>
    return p->trapframe->a4;
    800021b2:	6d3c                	ld	a5,88(a0)
    800021b4:	6bc8                	ld	a0,144(a5)
    800021b6:	b7c5                	j	80002196 <argraw+0x30>
    return p->trapframe->a5;
    800021b8:	6d3c                	ld	a5,88(a0)
    800021ba:	6fc8                	ld	a0,152(a5)
    800021bc:	bfe9                	j	80002196 <argraw+0x30>
  panic("argraw");
    800021be:	00006517          	auipc	a0,0x6
    800021c2:	20250513          	addi	a0,a0,514 # 800083c0 <states.1725+0x148>
    800021c6:	00004097          	auipc	ra,0x4
    800021ca:	cc2080e7          	jalr	-830(ra) # 80005e88 <panic>

00000000800021ce <fetchaddr>:
{
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	e426                	sd	s1,8(sp)
    800021d6:	e04a                	sd	s2,0(sp)
    800021d8:	1000                	addi	s0,sp,32
    800021da:	84aa                	mv	s1,a0
    800021dc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	ec4080e7          	jalr	-316(ra) # 800010a2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021e6:	653c                	ld	a5,72(a0)
    800021e8:	02f4f863          	bgeu	s1,a5,80002218 <fetchaddr+0x4a>
    800021ec:	00848713          	addi	a4,s1,8
    800021f0:	02e7e663          	bltu	a5,a4,8000221c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021f4:	46a1                	li	a3,8
    800021f6:	8626                	mv	a2,s1
    800021f8:	85ca                	mv	a1,s2
    800021fa:	6928                	ld	a0,80(a0)
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	bf4080e7          	jalr	-1036(ra) # 80000df0 <copyin>
    80002204:	00a03533          	snez	a0,a0
    80002208:	40a00533          	neg	a0,a0
}
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	64a2                	ld	s1,8(sp)
    80002212:	6902                	ld	s2,0(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret
    return -1;
    80002218:	557d                	li	a0,-1
    8000221a:	bfcd                	j	8000220c <fetchaddr+0x3e>
    8000221c:	557d                	li	a0,-1
    8000221e:	b7fd                	j	8000220c <fetchaddr+0x3e>

0000000080002220 <fetchstr>:
{
    80002220:	7179                	addi	sp,sp,-48
    80002222:	f406                	sd	ra,40(sp)
    80002224:	f022                	sd	s0,32(sp)
    80002226:	ec26                	sd	s1,24(sp)
    80002228:	e84a                	sd	s2,16(sp)
    8000222a:	e44e                	sd	s3,8(sp)
    8000222c:	1800                	addi	s0,sp,48
    8000222e:	892a                	mv	s2,a0
    80002230:	84ae                	mv	s1,a1
    80002232:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	e6e080e7          	jalr	-402(ra) # 800010a2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000223c:	86ce                	mv	a3,s3
    8000223e:	864a                	mv	a2,s2
    80002240:	85a6                	mv	a1,s1
    80002242:	6928                	ld	a0,80(a0)
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	c38080e7          	jalr	-968(ra) # 80000e7c <copyinstr>
  if(err < 0)
    8000224c:	00054763          	bltz	a0,8000225a <fetchstr+0x3a>
  return strlen(buf);
    80002250:	8526                	mv	a0,s1
    80002252:	ffffe097          	auipc	ra,0xffffe
    80002256:	2d8080e7          	jalr	728(ra) # 8000052a <strlen>
}
    8000225a:	70a2                	ld	ra,40(sp)
    8000225c:	7402                	ld	s0,32(sp)
    8000225e:	64e2                	ld	s1,24(sp)
    80002260:	6942                	ld	s2,16(sp)
    80002262:	69a2                	ld	s3,8(sp)
    80002264:	6145                	addi	sp,sp,48
    80002266:	8082                	ret

0000000080002268 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	e426                	sd	s1,8(sp)
    80002270:	1000                	addi	s0,sp,32
    80002272:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002274:	00000097          	auipc	ra,0x0
    80002278:	ef2080e7          	jalr	-270(ra) # 80002166 <argraw>
    8000227c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000227e:	4501                	li	a0,0
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	64a2                	ld	s1,8(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	e426                	sd	s1,8(sp)
    80002292:	1000                	addi	s0,sp,32
    80002294:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	ed0080e7          	jalr	-304(ra) # 80002166 <argraw>
    8000229e:	e088                	sd	a0,0(s1)
  return 0;
}
    800022a0:	4501                	li	a0,0
    800022a2:	60e2                	ld	ra,24(sp)
    800022a4:	6442                	ld	s0,16(sp)
    800022a6:	64a2                	ld	s1,8(sp)
    800022a8:	6105                	addi	sp,sp,32
    800022aa:	8082                	ret

00000000800022ac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800022ac:	1101                	addi	sp,sp,-32
    800022ae:	ec06                	sd	ra,24(sp)
    800022b0:	e822                	sd	s0,16(sp)
    800022b2:	e426                	sd	s1,8(sp)
    800022b4:	e04a                	sd	s2,0(sp)
    800022b6:	1000                	addi	s0,sp,32
    800022b8:	84ae                	mv	s1,a1
    800022ba:	8932                	mv	s2,a2
  *ip = argraw(n);
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	eaa080e7          	jalr	-342(ra) # 80002166 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800022c4:	864a                	mv	a2,s2
    800022c6:	85a6                	mv	a1,s1
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	f58080e7          	jalr	-168(ra) # 80002220 <fetchstr>
}
    800022d0:	60e2                	ld	ra,24(sp)
    800022d2:	6442                	ld	s0,16(sp)
    800022d4:	64a2                	ld	s1,8(sp)
    800022d6:	6902                	ld	s2,0(sp)
    800022d8:	6105                	addi	sp,sp,32
    800022da:	8082                	ret

00000000800022dc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800022dc:	1101                	addi	sp,sp,-32
    800022de:	ec06                	sd	ra,24(sp)
    800022e0:	e822                	sd	s0,16(sp)
    800022e2:	e426                	sd	s1,8(sp)
    800022e4:	e04a                	sd	s2,0(sp)
    800022e6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	dba080e7          	jalr	-582(ra) # 800010a2 <myproc>
    800022f0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022f2:	05853903          	ld	s2,88(a0)
    800022f6:	0a893783          	ld	a5,168(s2)
    800022fa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022fe:	37fd                	addiw	a5,a5,-1
    80002300:	4751                	li	a4,20
    80002302:	00f76f63          	bltu	a4,a5,80002320 <syscall+0x44>
    80002306:	00369713          	slli	a4,a3,0x3
    8000230a:	00006797          	auipc	a5,0x6
    8000230e:	0f678793          	addi	a5,a5,246 # 80008400 <syscalls>
    80002312:	97ba                	add	a5,a5,a4
    80002314:	639c                	ld	a5,0(a5)
    80002316:	c789                	beqz	a5,80002320 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002318:	9782                	jalr	a5
    8000231a:	06a93823          	sd	a0,112(s2)
    8000231e:	a839                	j	8000233c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002320:	15848613          	addi	a2,s1,344
    80002324:	588c                	lw	a1,48(s1)
    80002326:	00006517          	auipc	a0,0x6
    8000232a:	0a250513          	addi	a0,a0,162 # 800083c8 <states.1725+0x150>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	ba4080e7          	jalr	-1116(ra) # 80005ed2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002336:	6cbc                	ld	a5,88(s1)
    80002338:	577d                	li	a4,-1
    8000233a:	fbb8                	sd	a4,112(a5)
  }
}
    8000233c:	60e2                	ld	ra,24(sp)
    8000233e:	6442                	ld	s0,16(sp)
    80002340:	64a2                	ld	s1,8(sp)
    80002342:	6902                	ld	s2,0(sp)
    80002344:	6105                	addi	sp,sp,32
    80002346:	8082                	ret

0000000080002348 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002348:	1101                	addi	sp,sp,-32
    8000234a:	ec06                	sd	ra,24(sp)
    8000234c:	e822                	sd	s0,16(sp)
    8000234e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002350:	fec40593          	addi	a1,s0,-20
    80002354:	4501                	li	a0,0
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	f12080e7          	jalr	-238(ra) # 80002268 <argint>
    return -1;
    8000235e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002360:	00054963          	bltz	a0,80002372 <sys_exit+0x2a>
  exit(n);
    80002364:	fec42503          	lw	a0,-20(s0)
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	652080e7          	jalr	1618(ra) # 800019ba <exit>
  return 0;  // not reached
    80002370:	4781                	li	a5,0
}
    80002372:	853e                	mv	a0,a5
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	6105                	addi	sp,sp,32
    8000237a:	8082                	ret

000000008000237c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000237c:	1141                	addi	sp,sp,-16
    8000237e:	e406                	sd	ra,8(sp)
    80002380:	e022                	sd	s0,0(sp)
    80002382:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	d1e080e7          	jalr	-738(ra) # 800010a2 <myproc>
}
    8000238c:	5908                	lw	a0,48(a0)
    8000238e:	60a2                	ld	ra,8(sp)
    80002390:	6402                	ld	s0,0(sp)
    80002392:	0141                	addi	sp,sp,16
    80002394:	8082                	ret

0000000080002396 <sys_fork>:

uint64
sys_fork(void)
{
    80002396:	1141                	addi	sp,sp,-16
    80002398:	e406                	sd	ra,8(sp)
    8000239a:	e022                	sd	s0,0(sp)
    8000239c:	0800                	addi	s0,sp,16
  return fork();
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	0d2080e7          	jalr	210(ra) # 80001470 <fork>
}
    800023a6:	60a2                	ld	ra,8(sp)
    800023a8:	6402                	ld	s0,0(sp)
    800023aa:	0141                	addi	sp,sp,16
    800023ac:	8082                	ret

00000000800023ae <sys_wait>:

uint64
sys_wait(void)
{
    800023ae:	1101                	addi	sp,sp,-32
    800023b0:	ec06                	sd	ra,24(sp)
    800023b2:	e822                	sd	s0,16(sp)
    800023b4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800023b6:	fe840593          	addi	a1,s0,-24
    800023ba:	4501                	li	a0,0
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	ece080e7          	jalr	-306(ra) # 8000228a <argaddr>
    800023c4:	87aa                	mv	a5,a0
    return -1;
    800023c6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800023c8:	0007c863          	bltz	a5,800023d8 <sys_wait+0x2a>
  return wait(p);
    800023cc:	fe843503          	ld	a0,-24(s0)
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	3f2080e7          	jalr	1010(ra) # 800017c2 <wait>
}
    800023d8:	60e2                	ld	ra,24(sp)
    800023da:	6442                	ld	s0,16(sp)
    800023dc:	6105                	addi	sp,sp,32
    800023de:	8082                	ret

00000000800023e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023e0:	7179                	addi	sp,sp,-48
    800023e2:	f406                	sd	ra,40(sp)
    800023e4:	f022                	sd	s0,32(sp)
    800023e6:	ec26                	sd	s1,24(sp)
    800023e8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023ea:	fdc40593          	addi	a1,s0,-36
    800023ee:	4501                	li	a0,0
    800023f0:	00000097          	auipc	ra,0x0
    800023f4:	e78080e7          	jalr	-392(ra) # 80002268 <argint>
    800023f8:	87aa                	mv	a5,a0
    return -1;
    800023fa:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023fc:	0207c063          	bltz	a5,8000241c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	ca2080e7          	jalr	-862(ra) # 800010a2 <myproc>
    80002408:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000240a:	fdc42503          	lw	a0,-36(s0)
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	fee080e7          	jalr	-18(ra) # 800013fc <growproc>
    80002416:	00054863          	bltz	a0,80002426 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000241a:	8526                	mv	a0,s1
}
    8000241c:	70a2                	ld	ra,40(sp)
    8000241e:	7402                	ld	s0,32(sp)
    80002420:	64e2                	ld	s1,24(sp)
    80002422:	6145                	addi	sp,sp,48
    80002424:	8082                	ret
    return -1;
    80002426:	557d                	li	a0,-1
    80002428:	bfd5                	j	8000241c <sys_sbrk+0x3c>

000000008000242a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000242a:	7139                	addi	sp,sp,-64
    8000242c:	fc06                	sd	ra,56(sp)
    8000242e:	f822                	sd	s0,48(sp)
    80002430:	f426                	sd	s1,40(sp)
    80002432:	f04a                	sd	s2,32(sp)
    80002434:	ec4e                	sd	s3,24(sp)
    80002436:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002438:	fcc40593          	addi	a1,s0,-52
    8000243c:	4501                	li	a0,0
    8000243e:	00000097          	auipc	ra,0x0
    80002442:	e2a080e7          	jalr	-470(ra) # 80002268 <argint>
    return -1;
    80002446:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002448:	06054563          	bltz	a0,800024b2 <sys_sleep+0x88>
  acquire(&tickslock);
    8000244c:	0010d517          	auipc	a0,0x10d
    80002450:	a3450513          	addi	a0,a0,-1484 # 8010ee80 <tickslock>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	f7e080e7          	jalr	-130(ra) # 800063d2 <acquire>
  ticks0 = ticks;
    8000245c:	00007917          	auipc	s2,0x7
    80002460:	bbc92903          	lw	s2,-1092(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002464:	fcc42783          	lw	a5,-52(s0)
    80002468:	cf85                	beqz	a5,800024a0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000246a:	0010d997          	auipc	s3,0x10d
    8000246e:	a1698993          	addi	s3,s3,-1514 # 8010ee80 <tickslock>
    80002472:	00007497          	auipc	s1,0x7
    80002476:	ba648493          	addi	s1,s1,-1114 # 80009018 <ticks>
    if(myproc()->killed){
    8000247a:	fffff097          	auipc	ra,0xfffff
    8000247e:	c28080e7          	jalr	-984(ra) # 800010a2 <myproc>
    80002482:	551c                	lw	a5,40(a0)
    80002484:	ef9d                	bnez	a5,800024c2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002486:	85ce                	mv	a1,s3
    80002488:	8526                	mv	a0,s1
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	2d4080e7          	jalr	724(ra) # 8000175e <sleep>
  while(ticks - ticks0 < n){
    80002492:	409c                	lw	a5,0(s1)
    80002494:	412787bb          	subw	a5,a5,s2
    80002498:	fcc42703          	lw	a4,-52(s0)
    8000249c:	fce7efe3          	bltu	a5,a4,8000247a <sys_sleep+0x50>
  }
  release(&tickslock);
    800024a0:	0010d517          	auipc	a0,0x10d
    800024a4:	9e050513          	addi	a0,a0,-1568 # 8010ee80 <tickslock>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	fde080e7          	jalr	-34(ra) # 80006486 <release>
  return 0;
    800024b0:	4781                	li	a5,0
}
    800024b2:	853e                	mv	a0,a5
    800024b4:	70e2                	ld	ra,56(sp)
    800024b6:	7442                	ld	s0,48(sp)
    800024b8:	74a2                	ld	s1,40(sp)
    800024ba:	7902                	ld	s2,32(sp)
    800024bc:	69e2                	ld	s3,24(sp)
    800024be:	6121                	addi	sp,sp,64
    800024c0:	8082                	ret
      release(&tickslock);
    800024c2:	0010d517          	auipc	a0,0x10d
    800024c6:	9be50513          	addi	a0,a0,-1602 # 8010ee80 <tickslock>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	fbc080e7          	jalr	-68(ra) # 80006486 <release>
      return -1;
    800024d2:	57fd                	li	a5,-1
    800024d4:	bff9                	j	800024b2 <sys_sleep+0x88>

00000000800024d6 <sys_kill>:

uint64
sys_kill(void)
{
    800024d6:	1101                	addi	sp,sp,-32
    800024d8:	ec06                	sd	ra,24(sp)
    800024da:	e822                	sd	s0,16(sp)
    800024dc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024de:	fec40593          	addi	a1,s0,-20
    800024e2:	4501                	li	a0,0
    800024e4:	00000097          	auipc	ra,0x0
    800024e8:	d84080e7          	jalr	-636(ra) # 80002268 <argint>
    800024ec:	87aa                	mv	a5,a0
    return -1;
    800024ee:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024f0:	0007c863          	bltz	a5,80002500 <sys_kill+0x2a>
  return kill(pid);
    800024f4:	fec42503          	lw	a0,-20(s0)
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	598080e7          	jalr	1432(ra) # 80001a90 <kill>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	6105                	addi	sp,sp,32
    80002506:	8082                	ret

0000000080002508 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002508:	1101                	addi	sp,sp,-32
    8000250a:	ec06                	sd	ra,24(sp)
    8000250c:	e822                	sd	s0,16(sp)
    8000250e:	e426                	sd	s1,8(sp)
    80002510:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002512:	0010d517          	auipc	a0,0x10d
    80002516:	96e50513          	addi	a0,a0,-1682 # 8010ee80 <tickslock>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	eb8080e7          	jalr	-328(ra) # 800063d2 <acquire>
  xticks = ticks;
    80002522:	00007497          	auipc	s1,0x7
    80002526:	af64a483          	lw	s1,-1290(s1) # 80009018 <ticks>
  release(&tickslock);
    8000252a:	0010d517          	auipc	a0,0x10d
    8000252e:	95650513          	addi	a0,a0,-1706 # 8010ee80 <tickslock>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	f54080e7          	jalr	-172(ra) # 80006486 <release>
  return xticks;
}
    8000253a:	02049513          	slli	a0,s1,0x20
    8000253e:	9101                	srli	a0,a0,0x20
    80002540:	60e2                	ld	ra,24(sp)
    80002542:	6442                	ld	s0,16(sp)
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret

000000008000254a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000254a:	7179                	addi	sp,sp,-48
    8000254c:	f406                	sd	ra,40(sp)
    8000254e:	f022                	sd	s0,32(sp)
    80002550:	ec26                	sd	s1,24(sp)
    80002552:	e84a                	sd	s2,16(sp)
    80002554:	e44e                	sd	s3,8(sp)
    80002556:	e052                	sd	s4,0(sp)
    80002558:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000255a:	00006597          	auipc	a1,0x6
    8000255e:	f5658593          	addi	a1,a1,-170 # 800084b0 <syscalls+0xb0>
    80002562:	0010d517          	auipc	a0,0x10d
    80002566:	93650513          	addi	a0,a0,-1738 # 8010ee98 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	dd8080e7          	jalr	-552(ra) # 80006342 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002572:	00115797          	auipc	a5,0x115
    80002576:	92678793          	addi	a5,a5,-1754 # 80116e98 <bcache+0x8000>
    8000257a:	00115717          	auipc	a4,0x115
    8000257e:	b8670713          	addi	a4,a4,-1146 # 80117100 <bcache+0x8268>
    80002582:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002586:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000258a:	0010d497          	auipc	s1,0x10d
    8000258e:	92648493          	addi	s1,s1,-1754 # 8010eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002592:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002594:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002596:	00006a17          	auipc	s4,0x6
    8000259a:	f22a0a13          	addi	s4,s4,-222 # 800084b8 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000259e:	2b893783          	ld	a5,696(s2)
    800025a2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025a4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025a8:	85d2                	mv	a1,s4
    800025aa:	01048513          	addi	a0,s1,16
    800025ae:	00001097          	auipc	ra,0x1
    800025b2:	4bc080e7          	jalr	1212(ra) # 80003a6a <initsleeplock>
    bcache.head.next->prev = b;
    800025b6:	2b893783          	ld	a5,696(s2)
    800025ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025c0:	45848493          	addi	s1,s1,1112
    800025c4:	fd349de3          	bne	s1,s3,8000259e <binit+0x54>
  }
}
    800025c8:	70a2                	ld	ra,40(sp)
    800025ca:	7402                	ld	s0,32(sp)
    800025cc:	64e2                	ld	s1,24(sp)
    800025ce:	6942                	ld	s2,16(sp)
    800025d0:	69a2                	ld	s3,8(sp)
    800025d2:	6a02                	ld	s4,0(sp)
    800025d4:	6145                	addi	sp,sp,48
    800025d6:	8082                	ret

00000000800025d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025d8:	7179                	addi	sp,sp,-48
    800025da:	f406                	sd	ra,40(sp)
    800025dc:	f022                	sd	s0,32(sp)
    800025de:	ec26                	sd	s1,24(sp)
    800025e0:	e84a                	sd	s2,16(sp)
    800025e2:	e44e                	sd	s3,8(sp)
    800025e4:	1800                	addi	s0,sp,48
    800025e6:	89aa                	mv	s3,a0
    800025e8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800025ea:	0010d517          	auipc	a0,0x10d
    800025ee:	8ae50513          	addi	a0,a0,-1874 # 8010ee98 <bcache>
    800025f2:	00004097          	auipc	ra,0x4
    800025f6:	de0080e7          	jalr	-544(ra) # 800063d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025fa:	00115497          	auipc	s1,0x115
    800025fe:	b564b483          	ld	s1,-1194(s1) # 80117150 <bcache+0x82b8>
    80002602:	00115797          	auipc	a5,0x115
    80002606:	afe78793          	addi	a5,a5,-1282 # 80117100 <bcache+0x8268>
    8000260a:	02f48f63          	beq	s1,a5,80002648 <bread+0x70>
    8000260e:	873e                	mv	a4,a5
    80002610:	a021                	j	80002618 <bread+0x40>
    80002612:	68a4                	ld	s1,80(s1)
    80002614:	02e48a63          	beq	s1,a4,80002648 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002618:	449c                	lw	a5,8(s1)
    8000261a:	ff379ce3          	bne	a5,s3,80002612 <bread+0x3a>
    8000261e:	44dc                	lw	a5,12(s1)
    80002620:	ff2799e3          	bne	a5,s2,80002612 <bread+0x3a>
      b->refcnt++;
    80002624:	40bc                	lw	a5,64(s1)
    80002626:	2785                	addiw	a5,a5,1
    80002628:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000262a:	0010d517          	auipc	a0,0x10d
    8000262e:	86e50513          	addi	a0,a0,-1938 # 8010ee98 <bcache>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	e54080e7          	jalr	-428(ra) # 80006486 <release>
      acquiresleep(&b->lock);
    8000263a:	01048513          	addi	a0,s1,16
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	466080e7          	jalr	1126(ra) # 80003aa4 <acquiresleep>
      return b;
    80002646:	a8b9                	j	800026a4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002648:	00115497          	auipc	s1,0x115
    8000264c:	b004b483          	ld	s1,-1280(s1) # 80117148 <bcache+0x82b0>
    80002650:	00115797          	auipc	a5,0x115
    80002654:	ab078793          	addi	a5,a5,-1360 # 80117100 <bcache+0x8268>
    80002658:	00f48863          	beq	s1,a5,80002668 <bread+0x90>
    8000265c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000265e:	40bc                	lw	a5,64(s1)
    80002660:	cf81                	beqz	a5,80002678 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002662:	64a4                	ld	s1,72(s1)
    80002664:	fee49de3          	bne	s1,a4,8000265e <bread+0x86>
  panic("bget: no buffers");
    80002668:	00006517          	auipc	a0,0x6
    8000266c:	e5850513          	addi	a0,a0,-424 # 800084c0 <syscalls+0xc0>
    80002670:	00004097          	auipc	ra,0x4
    80002674:	818080e7          	jalr	-2024(ra) # 80005e88 <panic>
      b->dev = dev;
    80002678:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000267c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002680:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002684:	4785                	li	a5,1
    80002686:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002688:	0010d517          	auipc	a0,0x10d
    8000268c:	81050513          	addi	a0,a0,-2032 # 8010ee98 <bcache>
    80002690:	00004097          	auipc	ra,0x4
    80002694:	df6080e7          	jalr	-522(ra) # 80006486 <release>
      acquiresleep(&b->lock);
    80002698:	01048513          	addi	a0,s1,16
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	408080e7          	jalr	1032(ra) # 80003aa4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026a4:	409c                	lw	a5,0(s1)
    800026a6:	cb89                	beqz	a5,800026b8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026a8:	8526                	mv	a0,s1
    800026aa:	70a2                	ld	ra,40(sp)
    800026ac:	7402                	ld	s0,32(sp)
    800026ae:	64e2                	ld	s1,24(sp)
    800026b0:	6942                	ld	s2,16(sp)
    800026b2:	69a2                	ld	s3,8(sp)
    800026b4:	6145                	addi	sp,sp,48
    800026b6:	8082                	ret
    virtio_disk_rw(b, 0);
    800026b8:	4581                	li	a1,0
    800026ba:	8526                	mv	a0,s1
    800026bc:	00003097          	auipc	ra,0x3
    800026c0:	f0a080e7          	jalr	-246(ra) # 800055c6 <virtio_disk_rw>
    b->valid = 1;
    800026c4:	4785                	li	a5,1
    800026c6:	c09c                	sw	a5,0(s1)
  return b;
    800026c8:	b7c5                	j	800026a8 <bread+0xd0>

00000000800026ca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026ca:	1101                	addi	sp,sp,-32
    800026cc:	ec06                	sd	ra,24(sp)
    800026ce:	e822                	sd	s0,16(sp)
    800026d0:	e426                	sd	s1,8(sp)
    800026d2:	1000                	addi	s0,sp,32
    800026d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026d6:	0541                	addi	a0,a0,16
    800026d8:	00001097          	auipc	ra,0x1
    800026dc:	466080e7          	jalr	1126(ra) # 80003b3e <holdingsleep>
    800026e0:	cd01                	beqz	a0,800026f8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026e2:	4585                	li	a1,1
    800026e4:	8526                	mv	a0,s1
    800026e6:	00003097          	auipc	ra,0x3
    800026ea:	ee0080e7          	jalr	-288(ra) # 800055c6 <virtio_disk_rw>
}
    800026ee:	60e2                	ld	ra,24(sp)
    800026f0:	6442                	ld	s0,16(sp)
    800026f2:	64a2                	ld	s1,8(sp)
    800026f4:	6105                	addi	sp,sp,32
    800026f6:	8082                	ret
    panic("bwrite");
    800026f8:	00006517          	auipc	a0,0x6
    800026fc:	de050513          	addi	a0,a0,-544 # 800084d8 <syscalls+0xd8>
    80002700:	00003097          	auipc	ra,0x3
    80002704:	788080e7          	jalr	1928(ra) # 80005e88 <panic>

0000000080002708 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002708:	1101                	addi	sp,sp,-32
    8000270a:	ec06                	sd	ra,24(sp)
    8000270c:	e822                	sd	s0,16(sp)
    8000270e:	e426                	sd	s1,8(sp)
    80002710:	e04a                	sd	s2,0(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002716:	01050913          	addi	s2,a0,16
    8000271a:	854a                	mv	a0,s2
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	422080e7          	jalr	1058(ra) # 80003b3e <holdingsleep>
    80002724:	c92d                	beqz	a0,80002796 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002726:	854a                	mv	a0,s2
    80002728:	00001097          	auipc	ra,0x1
    8000272c:	3d2080e7          	jalr	978(ra) # 80003afa <releasesleep>

  acquire(&bcache.lock);
    80002730:	0010c517          	auipc	a0,0x10c
    80002734:	76850513          	addi	a0,a0,1896 # 8010ee98 <bcache>
    80002738:	00004097          	auipc	ra,0x4
    8000273c:	c9a080e7          	jalr	-870(ra) # 800063d2 <acquire>
  b->refcnt--;
    80002740:	40bc                	lw	a5,64(s1)
    80002742:	37fd                	addiw	a5,a5,-1
    80002744:	0007871b          	sext.w	a4,a5
    80002748:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000274a:	eb05                	bnez	a4,8000277a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000274c:	68bc                	ld	a5,80(s1)
    8000274e:	64b8                	ld	a4,72(s1)
    80002750:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002752:	64bc                	ld	a5,72(s1)
    80002754:	68b8                	ld	a4,80(s1)
    80002756:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002758:	00114797          	auipc	a5,0x114
    8000275c:	74078793          	addi	a5,a5,1856 # 80116e98 <bcache+0x8000>
    80002760:	2b87b703          	ld	a4,696(a5)
    80002764:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002766:	00115717          	auipc	a4,0x115
    8000276a:	99a70713          	addi	a4,a4,-1638 # 80117100 <bcache+0x8268>
    8000276e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002770:	2b87b703          	ld	a4,696(a5)
    80002774:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002776:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000277a:	0010c517          	auipc	a0,0x10c
    8000277e:	71e50513          	addi	a0,a0,1822 # 8010ee98 <bcache>
    80002782:	00004097          	auipc	ra,0x4
    80002786:	d04080e7          	jalr	-764(ra) # 80006486 <release>
}
    8000278a:	60e2                	ld	ra,24(sp)
    8000278c:	6442                	ld	s0,16(sp)
    8000278e:	64a2                	ld	s1,8(sp)
    80002790:	6902                	ld	s2,0(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret
    panic("brelse");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	d4a50513          	addi	a0,a0,-694 # 800084e0 <syscalls+0xe0>
    8000279e:	00003097          	auipc	ra,0x3
    800027a2:	6ea080e7          	jalr	1770(ra) # 80005e88 <panic>

00000000800027a6 <bpin>:

void
bpin(struct buf *b) {
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	1000                	addi	s0,sp,32
    800027b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027b2:	0010c517          	auipc	a0,0x10c
    800027b6:	6e650513          	addi	a0,a0,1766 # 8010ee98 <bcache>
    800027ba:	00004097          	auipc	ra,0x4
    800027be:	c18080e7          	jalr	-1000(ra) # 800063d2 <acquire>
  b->refcnt++;
    800027c2:	40bc                	lw	a5,64(s1)
    800027c4:	2785                	addiw	a5,a5,1
    800027c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027c8:	0010c517          	auipc	a0,0x10c
    800027cc:	6d050513          	addi	a0,a0,1744 # 8010ee98 <bcache>
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	cb6080e7          	jalr	-842(ra) # 80006486 <release>
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <bunpin>:

void
bunpin(struct buf *b) {
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	1000                	addi	s0,sp,32
    800027ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027ee:	0010c517          	auipc	a0,0x10c
    800027f2:	6aa50513          	addi	a0,a0,1706 # 8010ee98 <bcache>
    800027f6:	00004097          	auipc	ra,0x4
    800027fa:	bdc080e7          	jalr	-1060(ra) # 800063d2 <acquire>
  b->refcnt--;
    800027fe:	40bc                	lw	a5,64(s1)
    80002800:	37fd                	addiw	a5,a5,-1
    80002802:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002804:	0010c517          	auipc	a0,0x10c
    80002808:	69450513          	addi	a0,a0,1684 # 8010ee98 <bcache>
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	c7a080e7          	jalr	-902(ra) # 80006486 <release>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6105                	addi	sp,sp,32
    8000281c:	8082                	ret

000000008000281e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	e426                	sd	s1,8(sp)
    80002826:	e04a                	sd	s2,0(sp)
    80002828:	1000                	addi	s0,sp,32
    8000282a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000282c:	00d5d59b          	srliw	a1,a1,0xd
    80002830:	00115797          	auipc	a5,0x115
    80002834:	d447a783          	lw	a5,-700(a5) # 80117574 <sb+0x1c>
    80002838:	9dbd                	addw	a1,a1,a5
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	d9e080e7          	jalr	-610(ra) # 800025d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002842:	0074f713          	andi	a4,s1,7
    80002846:	4785                	li	a5,1
    80002848:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000284c:	14ce                	slli	s1,s1,0x33
    8000284e:	90d9                	srli	s1,s1,0x36
    80002850:	00950733          	add	a4,a0,s1
    80002854:	05874703          	lbu	a4,88(a4)
    80002858:	00e7f6b3          	and	a3,a5,a4
    8000285c:	c69d                	beqz	a3,8000288a <bfree+0x6c>
    8000285e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002860:	94aa                	add	s1,s1,a0
    80002862:	fff7c793          	not	a5,a5
    80002866:	8ff9                	and	a5,a5,a4
    80002868:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000286c:	00001097          	auipc	ra,0x1
    80002870:	118080e7          	jalr	280(ra) # 80003984 <log_write>
  brelse(bp);
    80002874:	854a                	mv	a0,s2
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e92080e7          	jalr	-366(ra) # 80002708 <brelse>
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6902                	ld	s2,0(sp)
    80002886:	6105                	addi	sp,sp,32
    80002888:	8082                	ret
    panic("freeing free block");
    8000288a:	00006517          	auipc	a0,0x6
    8000288e:	c5e50513          	addi	a0,a0,-930 # 800084e8 <syscalls+0xe8>
    80002892:	00003097          	auipc	ra,0x3
    80002896:	5f6080e7          	jalr	1526(ra) # 80005e88 <panic>

000000008000289a <balloc>:
{
    8000289a:	711d                	addi	sp,sp,-96
    8000289c:	ec86                	sd	ra,88(sp)
    8000289e:	e8a2                	sd	s0,80(sp)
    800028a0:	e4a6                	sd	s1,72(sp)
    800028a2:	e0ca                	sd	s2,64(sp)
    800028a4:	fc4e                	sd	s3,56(sp)
    800028a6:	f852                	sd	s4,48(sp)
    800028a8:	f456                	sd	s5,40(sp)
    800028aa:	f05a                	sd	s6,32(sp)
    800028ac:	ec5e                	sd	s7,24(sp)
    800028ae:	e862                	sd	s8,16(sp)
    800028b0:	e466                	sd	s9,8(sp)
    800028b2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028b4:	00115797          	auipc	a5,0x115
    800028b8:	ca87a783          	lw	a5,-856(a5) # 8011755c <sb+0x4>
    800028bc:	cbd1                	beqz	a5,80002950 <balloc+0xb6>
    800028be:	8baa                	mv	s7,a0
    800028c0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028c2:	00115b17          	auipc	s6,0x115
    800028c6:	c96b0b13          	addi	s6,s6,-874 # 80117558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ca:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028cc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ce:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028d0:	6c89                	lui	s9,0x2
    800028d2:	a831                	j	800028ee <balloc+0x54>
    brelse(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e32080e7          	jalr	-462(ra) # 80002708 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028de:	015c87bb          	addw	a5,s9,s5
    800028e2:	00078a9b          	sext.w	s5,a5
    800028e6:	004b2703          	lw	a4,4(s6)
    800028ea:	06eaf363          	bgeu	s5,a4,80002950 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028ee:	41fad79b          	sraiw	a5,s5,0x1f
    800028f2:	0137d79b          	srliw	a5,a5,0x13
    800028f6:	015787bb          	addw	a5,a5,s5
    800028fa:	40d7d79b          	sraiw	a5,a5,0xd
    800028fe:	01cb2583          	lw	a1,28(s6)
    80002902:	9dbd                	addw	a1,a1,a5
    80002904:	855e                	mv	a0,s7
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	cd2080e7          	jalr	-814(ra) # 800025d8 <bread>
    8000290e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002910:	004b2503          	lw	a0,4(s6)
    80002914:	000a849b          	sext.w	s1,s5
    80002918:	8662                	mv	a2,s8
    8000291a:	faa4fde3          	bgeu	s1,a0,800028d4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000291e:	41f6579b          	sraiw	a5,a2,0x1f
    80002922:	01d7d69b          	srliw	a3,a5,0x1d
    80002926:	00c6873b          	addw	a4,a3,a2
    8000292a:	00777793          	andi	a5,a4,7
    8000292e:	9f95                	subw	a5,a5,a3
    80002930:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002934:	4037571b          	sraiw	a4,a4,0x3
    80002938:	00e906b3          	add	a3,s2,a4
    8000293c:	0586c683          	lbu	a3,88(a3)
    80002940:	00d7f5b3          	and	a1,a5,a3
    80002944:	cd91                	beqz	a1,80002960 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002946:	2605                	addiw	a2,a2,1
    80002948:	2485                	addiw	s1,s1,1
    8000294a:	fd4618e3          	bne	a2,s4,8000291a <balloc+0x80>
    8000294e:	b759                	j	800028d4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002950:	00006517          	auipc	a0,0x6
    80002954:	bb050513          	addi	a0,a0,-1104 # 80008500 <syscalls+0x100>
    80002958:	00003097          	auipc	ra,0x3
    8000295c:	530080e7          	jalr	1328(ra) # 80005e88 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002960:	974a                	add	a4,a4,s2
    80002962:	8fd5                	or	a5,a5,a3
    80002964:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002968:	854a                	mv	a0,s2
    8000296a:	00001097          	auipc	ra,0x1
    8000296e:	01a080e7          	jalr	26(ra) # 80003984 <log_write>
        brelse(bp);
    80002972:	854a                	mv	a0,s2
    80002974:	00000097          	auipc	ra,0x0
    80002978:	d94080e7          	jalr	-620(ra) # 80002708 <brelse>
  bp = bread(dev, bno);
    8000297c:	85a6                	mv	a1,s1
    8000297e:	855e                	mv	a0,s7
    80002980:	00000097          	auipc	ra,0x0
    80002984:	c58080e7          	jalr	-936(ra) # 800025d8 <bread>
    80002988:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000298a:	40000613          	li	a2,1024
    8000298e:	4581                	li	a1,0
    80002990:	05850513          	addi	a0,a0,88
    80002994:	ffffe097          	auipc	ra,0xffffe
    80002998:	a12080e7          	jalr	-1518(ra) # 800003a6 <memset>
  log_write(bp);
    8000299c:	854a                	mv	a0,s2
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	fe6080e7          	jalr	-26(ra) # 80003984 <log_write>
  brelse(bp);
    800029a6:	854a                	mv	a0,s2
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	d60080e7          	jalr	-672(ra) # 80002708 <brelse>
}
    800029b0:	8526                	mv	a0,s1
    800029b2:	60e6                	ld	ra,88(sp)
    800029b4:	6446                	ld	s0,80(sp)
    800029b6:	64a6                	ld	s1,72(sp)
    800029b8:	6906                	ld	s2,64(sp)
    800029ba:	79e2                	ld	s3,56(sp)
    800029bc:	7a42                	ld	s4,48(sp)
    800029be:	7aa2                	ld	s5,40(sp)
    800029c0:	7b02                	ld	s6,32(sp)
    800029c2:	6be2                	ld	s7,24(sp)
    800029c4:	6c42                	ld	s8,16(sp)
    800029c6:	6ca2                	ld	s9,8(sp)
    800029c8:	6125                	addi	sp,sp,96
    800029ca:	8082                	ret

00000000800029cc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	e052                	sd	s4,0(sp)
    800029da:	1800                	addi	s0,sp,48
    800029dc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029de:	47ad                	li	a5,11
    800029e0:	04b7fe63          	bgeu	a5,a1,80002a3c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029e4:	ff45849b          	addiw	s1,a1,-12
    800029e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029ec:	0ff00793          	li	a5,255
    800029f0:	0ae7e363          	bltu	a5,a4,80002a96 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029f4:	08052583          	lw	a1,128(a0)
    800029f8:	c5ad                	beqz	a1,80002a62 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029fa:	00092503          	lw	a0,0(s2)
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	bda080e7          	jalr	-1062(ra) # 800025d8 <bread>
    80002a06:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a08:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a0c:	02049593          	slli	a1,s1,0x20
    80002a10:	9181                	srli	a1,a1,0x20
    80002a12:	058a                	slli	a1,a1,0x2
    80002a14:	00b784b3          	add	s1,a5,a1
    80002a18:	0004a983          	lw	s3,0(s1)
    80002a1c:	04098d63          	beqz	s3,80002a76 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a20:	8552                	mv	a0,s4
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	ce6080e7          	jalr	-794(ra) # 80002708 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a2a:	854e                	mv	a0,s3
    80002a2c:	70a2                	ld	ra,40(sp)
    80002a2e:	7402                	ld	s0,32(sp)
    80002a30:	64e2                	ld	s1,24(sp)
    80002a32:	6942                	ld	s2,16(sp)
    80002a34:	69a2                	ld	s3,8(sp)
    80002a36:	6a02                	ld	s4,0(sp)
    80002a38:	6145                	addi	sp,sp,48
    80002a3a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a3c:	02059493          	slli	s1,a1,0x20
    80002a40:	9081                	srli	s1,s1,0x20
    80002a42:	048a                	slli	s1,s1,0x2
    80002a44:	94aa                	add	s1,s1,a0
    80002a46:	0504a983          	lw	s3,80(s1)
    80002a4a:	fe0990e3          	bnez	s3,80002a2a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a4e:	4108                	lw	a0,0(a0)
    80002a50:	00000097          	auipc	ra,0x0
    80002a54:	e4a080e7          	jalr	-438(ra) # 8000289a <balloc>
    80002a58:	0005099b          	sext.w	s3,a0
    80002a5c:	0534a823          	sw	s3,80(s1)
    80002a60:	b7e9                	j	80002a2a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a62:	4108                	lw	a0,0(a0)
    80002a64:	00000097          	auipc	ra,0x0
    80002a68:	e36080e7          	jalr	-458(ra) # 8000289a <balloc>
    80002a6c:	0005059b          	sext.w	a1,a0
    80002a70:	08b92023          	sw	a1,128(s2)
    80002a74:	b759                	j	800029fa <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a76:	00092503          	lw	a0,0(s2)
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	e20080e7          	jalr	-480(ra) # 8000289a <balloc>
    80002a82:	0005099b          	sext.w	s3,a0
    80002a86:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a8a:	8552                	mv	a0,s4
    80002a8c:	00001097          	auipc	ra,0x1
    80002a90:	ef8080e7          	jalr	-264(ra) # 80003984 <log_write>
    80002a94:	b771                	j	80002a20 <bmap+0x54>
  panic("bmap: out of range");
    80002a96:	00006517          	auipc	a0,0x6
    80002a9a:	a8250513          	addi	a0,a0,-1406 # 80008518 <syscalls+0x118>
    80002a9e:	00003097          	auipc	ra,0x3
    80002aa2:	3ea080e7          	jalr	1002(ra) # 80005e88 <panic>

0000000080002aa6 <iget>:
{
    80002aa6:	7179                	addi	sp,sp,-48
    80002aa8:	f406                	sd	ra,40(sp)
    80002aaa:	f022                	sd	s0,32(sp)
    80002aac:	ec26                	sd	s1,24(sp)
    80002aae:	e84a                	sd	s2,16(sp)
    80002ab0:	e44e                	sd	s3,8(sp)
    80002ab2:	e052                	sd	s4,0(sp)
    80002ab4:	1800                	addi	s0,sp,48
    80002ab6:	89aa                	mv	s3,a0
    80002ab8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002aba:	00115517          	auipc	a0,0x115
    80002abe:	abe50513          	addi	a0,a0,-1346 # 80117578 <itable>
    80002ac2:	00004097          	auipc	ra,0x4
    80002ac6:	910080e7          	jalr	-1776(ra) # 800063d2 <acquire>
  empty = 0;
    80002aca:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002acc:	00115497          	auipc	s1,0x115
    80002ad0:	ac448493          	addi	s1,s1,-1340 # 80117590 <itable+0x18>
    80002ad4:	00116697          	auipc	a3,0x116
    80002ad8:	54c68693          	addi	a3,a3,1356 # 80119020 <log>
    80002adc:	a039                	j	80002aea <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ade:	02090b63          	beqz	s2,80002b14 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ae2:	08848493          	addi	s1,s1,136
    80002ae6:	02d48a63          	beq	s1,a3,80002b1a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aea:	449c                	lw	a5,8(s1)
    80002aec:	fef059e3          	blez	a5,80002ade <iget+0x38>
    80002af0:	4098                	lw	a4,0(s1)
    80002af2:	ff3716e3          	bne	a4,s3,80002ade <iget+0x38>
    80002af6:	40d8                	lw	a4,4(s1)
    80002af8:	ff4713e3          	bne	a4,s4,80002ade <iget+0x38>
      ip->ref++;
    80002afc:	2785                	addiw	a5,a5,1
    80002afe:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b00:	00115517          	auipc	a0,0x115
    80002b04:	a7850513          	addi	a0,a0,-1416 # 80117578 <itable>
    80002b08:	00004097          	auipc	ra,0x4
    80002b0c:	97e080e7          	jalr	-1666(ra) # 80006486 <release>
      return ip;
    80002b10:	8926                	mv	s2,s1
    80002b12:	a03d                	j	80002b40 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b14:	f7f9                	bnez	a5,80002ae2 <iget+0x3c>
    80002b16:	8926                	mv	s2,s1
    80002b18:	b7e9                	j	80002ae2 <iget+0x3c>
  if(empty == 0)
    80002b1a:	02090c63          	beqz	s2,80002b52 <iget+0xac>
  ip->dev = dev;
    80002b1e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b22:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b26:	4785                	li	a5,1
    80002b28:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b2c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b30:	00115517          	auipc	a0,0x115
    80002b34:	a4850513          	addi	a0,a0,-1464 # 80117578 <itable>
    80002b38:	00004097          	auipc	ra,0x4
    80002b3c:	94e080e7          	jalr	-1714(ra) # 80006486 <release>
}
    80002b40:	854a                	mv	a0,s2
    80002b42:	70a2                	ld	ra,40(sp)
    80002b44:	7402                	ld	s0,32(sp)
    80002b46:	64e2                	ld	s1,24(sp)
    80002b48:	6942                	ld	s2,16(sp)
    80002b4a:	69a2                	ld	s3,8(sp)
    80002b4c:	6a02                	ld	s4,0(sp)
    80002b4e:	6145                	addi	sp,sp,48
    80002b50:	8082                	ret
    panic("iget: no inodes");
    80002b52:	00006517          	auipc	a0,0x6
    80002b56:	9de50513          	addi	a0,a0,-1570 # 80008530 <syscalls+0x130>
    80002b5a:	00003097          	auipc	ra,0x3
    80002b5e:	32e080e7          	jalr	814(ra) # 80005e88 <panic>

0000000080002b62 <fsinit>:
fsinit(int dev) {
    80002b62:	7179                	addi	sp,sp,-48
    80002b64:	f406                	sd	ra,40(sp)
    80002b66:	f022                	sd	s0,32(sp)
    80002b68:	ec26                	sd	s1,24(sp)
    80002b6a:	e84a                	sd	s2,16(sp)
    80002b6c:	e44e                	sd	s3,8(sp)
    80002b6e:	1800                	addi	s0,sp,48
    80002b70:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b72:	4585                	li	a1,1
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	a64080e7          	jalr	-1436(ra) # 800025d8 <bread>
    80002b7c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b7e:	00115997          	auipc	s3,0x115
    80002b82:	9da98993          	addi	s3,s3,-1574 # 80117558 <sb>
    80002b86:	02000613          	li	a2,32
    80002b8a:	05850593          	addi	a1,a0,88
    80002b8e:	854e                	mv	a0,s3
    80002b90:	ffffe097          	auipc	ra,0xffffe
    80002b94:	876080e7          	jalr	-1930(ra) # 80000406 <memmove>
  brelse(bp);
    80002b98:	8526                	mv	a0,s1
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	b6e080e7          	jalr	-1170(ra) # 80002708 <brelse>
  if(sb.magic != FSMAGIC)
    80002ba2:	0009a703          	lw	a4,0(s3)
    80002ba6:	102037b7          	lui	a5,0x10203
    80002baa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bae:	02f71263          	bne	a4,a5,80002bd2 <fsinit+0x70>
  initlog(dev, &sb);
    80002bb2:	00115597          	auipc	a1,0x115
    80002bb6:	9a658593          	addi	a1,a1,-1626 # 80117558 <sb>
    80002bba:	854a                	mv	a0,s2
    80002bbc:	00001097          	auipc	ra,0x1
    80002bc0:	b4c080e7          	jalr	-1204(ra) # 80003708 <initlog>
}
    80002bc4:	70a2                	ld	ra,40(sp)
    80002bc6:	7402                	ld	s0,32(sp)
    80002bc8:	64e2                	ld	s1,24(sp)
    80002bca:	6942                	ld	s2,16(sp)
    80002bcc:	69a2                	ld	s3,8(sp)
    80002bce:	6145                	addi	sp,sp,48
    80002bd0:	8082                	ret
    panic("invalid file system");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	96e50513          	addi	a0,a0,-1682 # 80008540 <syscalls+0x140>
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	2ae080e7          	jalr	686(ra) # 80005e88 <panic>

0000000080002be2 <iinit>:
{
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	e44e                	sd	s3,8(sp)
    80002bee:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bf0:	00006597          	auipc	a1,0x6
    80002bf4:	96858593          	addi	a1,a1,-1688 # 80008558 <syscalls+0x158>
    80002bf8:	00115517          	auipc	a0,0x115
    80002bfc:	98050513          	addi	a0,a0,-1664 # 80117578 <itable>
    80002c00:	00003097          	auipc	ra,0x3
    80002c04:	742080e7          	jalr	1858(ra) # 80006342 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c08:	00115497          	auipc	s1,0x115
    80002c0c:	99848493          	addi	s1,s1,-1640 # 801175a0 <itable+0x28>
    80002c10:	00116997          	auipc	s3,0x116
    80002c14:	42098993          	addi	s3,s3,1056 # 80119030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c18:	00006917          	auipc	s2,0x6
    80002c1c:	94890913          	addi	s2,s2,-1720 # 80008560 <syscalls+0x160>
    80002c20:	85ca                	mv	a1,s2
    80002c22:	8526                	mv	a0,s1
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	e46080e7          	jalr	-442(ra) # 80003a6a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c2c:	08848493          	addi	s1,s1,136
    80002c30:	ff3498e3          	bne	s1,s3,80002c20 <iinit+0x3e>
}
    80002c34:	70a2                	ld	ra,40(sp)
    80002c36:	7402                	ld	s0,32(sp)
    80002c38:	64e2                	ld	s1,24(sp)
    80002c3a:	6942                	ld	s2,16(sp)
    80002c3c:	69a2                	ld	s3,8(sp)
    80002c3e:	6145                	addi	sp,sp,48
    80002c40:	8082                	ret

0000000080002c42 <ialloc>:
{
    80002c42:	715d                	addi	sp,sp,-80
    80002c44:	e486                	sd	ra,72(sp)
    80002c46:	e0a2                	sd	s0,64(sp)
    80002c48:	fc26                	sd	s1,56(sp)
    80002c4a:	f84a                	sd	s2,48(sp)
    80002c4c:	f44e                	sd	s3,40(sp)
    80002c4e:	f052                	sd	s4,32(sp)
    80002c50:	ec56                	sd	s5,24(sp)
    80002c52:	e85a                	sd	s6,16(sp)
    80002c54:	e45e                	sd	s7,8(sp)
    80002c56:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c58:	00115717          	auipc	a4,0x115
    80002c5c:	90c72703          	lw	a4,-1780(a4) # 80117564 <sb+0xc>
    80002c60:	4785                	li	a5,1
    80002c62:	04e7fa63          	bgeu	a5,a4,80002cb6 <ialloc+0x74>
    80002c66:	8aaa                	mv	s5,a0
    80002c68:	8bae                	mv	s7,a1
    80002c6a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c6c:	00115a17          	auipc	s4,0x115
    80002c70:	8eca0a13          	addi	s4,s4,-1812 # 80117558 <sb>
    80002c74:	00048b1b          	sext.w	s6,s1
    80002c78:	0044d593          	srli	a1,s1,0x4
    80002c7c:	018a2783          	lw	a5,24(s4)
    80002c80:	9dbd                	addw	a1,a1,a5
    80002c82:	8556                	mv	a0,s5
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	954080e7          	jalr	-1708(ra) # 800025d8 <bread>
    80002c8c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c8e:	05850993          	addi	s3,a0,88
    80002c92:	00f4f793          	andi	a5,s1,15
    80002c96:	079a                	slli	a5,a5,0x6
    80002c98:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c9a:	00099783          	lh	a5,0(s3)
    80002c9e:	c785                	beqz	a5,80002cc6 <ialloc+0x84>
    brelse(bp);
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	a68080e7          	jalr	-1432(ra) # 80002708 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ca8:	0485                	addi	s1,s1,1
    80002caa:	00ca2703          	lw	a4,12(s4)
    80002cae:	0004879b          	sext.w	a5,s1
    80002cb2:	fce7e1e3          	bltu	a5,a4,80002c74 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cb6:	00006517          	auipc	a0,0x6
    80002cba:	8b250513          	addi	a0,a0,-1870 # 80008568 <syscalls+0x168>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	1ca080e7          	jalr	458(ra) # 80005e88 <panic>
      memset(dip, 0, sizeof(*dip));
    80002cc6:	04000613          	li	a2,64
    80002cca:	4581                	li	a1,0
    80002ccc:	854e                	mv	a0,s3
    80002cce:	ffffd097          	auipc	ra,0xffffd
    80002cd2:	6d8080e7          	jalr	1752(ra) # 800003a6 <memset>
      dip->type = type;
    80002cd6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cda:	854a                	mv	a0,s2
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	ca8080e7          	jalr	-856(ra) # 80003984 <log_write>
      brelse(bp);
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	a22080e7          	jalr	-1502(ra) # 80002708 <brelse>
      return iget(dev, inum);
    80002cee:	85da                	mv	a1,s6
    80002cf0:	8556                	mv	a0,s5
    80002cf2:	00000097          	auipc	ra,0x0
    80002cf6:	db4080e7          	jalr	-588(ra) # 80002aa6 <iget>
}
    80002cfa:	60a6                	ld	ra,72(sp)
    80002cfc:	6406                	ld	s0,64(sp)
    80002cfe:	74e2                	ld	s1,56(sp)
    80002d00:	7942                	ld	s2,48(sp)
    80002d02:	79a2                	ld	s3,40(sp)
    80002d04:	7a02                	ld	s4,32(sp)
    80002d06:	6ae2                	ld	s5,24(sp)
    80002d08:	6b42                	ld	s6,16(sp)
    80002d0a:	6ba2                	ld	s7,8(sp)
    80002d0c:	6161                	addi	sp,sp,80
    80002d0e:	8082                	ret

0000000080002d10 <iupdate>:
{
    80002d10:	1101                	addi	sp,sp,-32
    80002d12:	ec06                	sd	ra,24(sp)
    80002d14:	e822                	sd	s0,16(sp)
    80002d16:	e426                	sd	s1,8(sp)
    80002d18:	e04a                	sd	s2,0(sp)
    80002d1a:	1000                	addi	s0,sp,32
    80002d1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d1e:	415c                	lw	a5,4(a0)
    80002d20:	0047d79b          	srliw	a5,a5,0x4
    80002d24:	00115597          	auipc	a1,0x115
    80002d28:	84c5a583          	lw	a1,-1972(a1) # 80117570 <sb+0x18>
    80002d2c:	9dbd                	addw	a1,a1,a5
    80002d2e:	4108                	lw	a0,0(a0)
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	8a8080e7          	jalr	-1880(ra) # 800025d8 <bread>
    80002d38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d3a:	05850793          	addi	a5,a0,88
    80002d3e:	40c8                	lw	a0,4(s1)
    80002d40:	893d                	andi	a0,a0,15
    80002d42:	051a                	slli	a0,a0,0x6
    80002d44:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d46:	04449703          	lh	a4,68(s1)
    80002d4a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d4e:	04649703          	lh	a4,70(s1)
    80002d52:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d56:	04849703          	lh	a4,72(s1)
    80002d5a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d5e:	04a49703          	lh	a4,74(s1)
    80002d62:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d66:	44f8                	lw	a4,76(s1)
    80002d68:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d6a:	03400613          	li	a2,52
    80002d6e:	05048593          	addi	a1,s1,80
    80002d72:	0531                	addi	a0,a0,12
    80002d74:	ffffd097          	auipc	ra,0xffffd
    80002d78:	692080e7          	jalr	1682(ra) # 80000406 <memmove>
  log_write(bp);
    80002d7c:	854a                	mv	a0,s2
    80002d7e:	00001097          	auipc	ra,0x1
    80002d82:	c06080e7          	jalr	-1018(ra) # 80003984 <log_write>
  brelse(bp);
    80002d86:	854a                	mv	a0,s2
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	980080e7          	jalr	-1664(ra) # 80002708 <brelse>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6902                	ld	s2,0(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret

0000000080002d9c <idup>:
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da8:	00114517          	auipc	a0,0x114
    80002dac:	7d050513          	addi	a0,a0,2000 # 80117578 <itable>
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	622080e7          	jalr	1570(ra) # 800063d2 <acquire>
  ip->ref++;
    80002db8:	449c                	lw	a5,8(s1)
    80002dba:	2785                	addiw	a5,a5,1
    80002dbc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dbe:	00114517          	auipc	a0,0x114
    80002dc2:	7ba50513          	addi	a0,a0,1978 # 80117578 <itable>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	6c0080e7          	jalr	1728(ra) # 80006486 <release>
}
    80002dce:	8526                	mv	a0,s1
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6105                	addi	sp,sp,32
    80002dd8:	8082                	ret

0000000080002dda <ilock>:
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	e04a                	sd	s2,0(sp)
    80002de4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002de6:	c115                	beqz	a0,80002e0a <ilock+0x30>
    80002de8:	84aa                	mv	s1,a0
    80002dea:	451c                	lw	a5,8(a0)
    80002dec:	00f05f63          	blez	a5,80002e0a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002df0:	0541                	addi	a0,a0,16
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	cb2080e7          	jalr	-846(ra) # 80003aa4 <acquiresleep>
  if(ip->valid == 0){
    80002dfa:	40bc                	lw	a5,64(s1)
    80002dfc:	cf99                	beqz	a5,80002e1a <ilock+0x40>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    panic("ilock");
    80002e0a:	00005517          	auipc	a0,0x5
    80002e0e:	77650513          	addi	a0,a0,1910 # 80008580 <syscalls+0x180>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	076080e7          	jalr	118(ra) # 80005e88 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1a:	40dc                	lw	a5,4(s1)
    80002e1c:	0047d79b          	srliw	a5,a5,0x4
    80002e20:	00114597          	auipc	a1,0x114
    80002e24:	7505a583          	lw	a1,1872(a1) # 80117570 <sb+0x18>
    80002e28:	9dbd                	addw	a1,a1,a5
    80002e2a:	4088                	lw	a0,0(s1)
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	7ac080e7          	jalr	1964(ra) # 800025d8 <bread>
    80002e34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e36:	05850593          	addi	a1,a0,88
    80002e3a:	40dc                	lw	a5,4(s1)
    80002e3c:	8bbd                	andi	a5,a5,15
    80002e3e:	079a                	slli	a5,a5,0x6
    80002e40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e42:	00059783          	lh	a5,0(a1)
    80002e46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e4a:	00259783          	lh	a5,2(a1)
    80002e4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e52:	00459783          	lh	a5,4(a1)
    80002e56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e5a:	00659783          	lh	a5,6(a1)
    80002e5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e62:	459c                	lw	a5,8(a1)
    80002e64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e66:	03400613          	li	a2,52
    80002e6a:	05b1                	addi	a1,a1,12
    80002e6c:	05048513          	addi	a0,s1,80
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	596080e7          	jalr	1430(ra) # 80000406 <memmove>
    brelse(bp);
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	88e080e7          	jalr	-1906(ra) # 80002708 <brelse>
    ip->valid = 1;
    80002e82:	4785                	li	a5,1
    80002e84:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e86:	04449783          	lh	a5,68(s1)
    80002e8a:	fbb5                	bnez	a5,80002dfe <ilock+0x24>
      panic("ilock: no type");
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	6fc50513          	addi	a0,a0,1788 # 80008588 <syscalls+0x188>
    80002e94:	00003097          	auipc	ra,0x3
    80002e98:	ff4080e7          	jalr	-12(ra) # 80005e88 <panic>

0000000080002e9c <iunlock>:
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	e04a                	sd	s2,0(sp)
    80002ea6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ea8:	c905                	beqz	a0,80002ed8 <iunlock+0x3c>
    80002eaa:	84aa                	mv	s1,a0
    80002eac:	01050913          	addi	s2,a0,16
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	00001097          	auipc	ra,0x1
    80002eb6:	c8c080e7          	jalr	-884(ra) # 80003b3e <holdingsleep>
    80002eba:	cd19                	beqz	a0,80002ed8 <iunlock+0x3c>
    80002ebc:	449c                	lw	a5,8(s1)
    80002ebe:	00f05d63          	blez	a5,80002ed8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00001097          	auipc	ra,0x1
    80002ec8:	c36080e7          	jalr	-970(ra) # 80003afa <releasesleep>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	64a2                	ld	s1,8(sp)
    80002ed2:	6902                	ld	s2,0(sp)
    80002ed4:	6105                	addi	sp,sp,32
    80002ed6:	8082                	ret
    panic("iunlock");
    80002ed8:	00005517          	auipc	a0,0x5
    80002edc:	6c050513          	addi	a0,a0,1728 # 80008598 <syscalls+0x198>
    80002ee0:	00003097          	auipc	ra,0x3
    80002ee4:	fa8080e7          	jalr	-88(ra) # 80005e88 <panic>

0000000080002ee8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ee8:	7179                	addi	sp,sp,-48
    80002eea:	f406                	sd	ra,40(sp)
    80002eec:	f022                	sd	s0,32(sp)
    80002eee:	ec26                	sd	s1,24(sp)
    80002ef0:	e84a                	sd	s2,16(sp)
    80002ef2:	e44e                	sd	s3,8(sp)
    80002ef4:	e052                	sd	s4,0(sp)
    80002ef6:	1800                	addi	s0,sp,48
    80002ef8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002efa:	05050493          	addi	s1,a0,80
    80002efe:	08050913          	addi	s2,a0,128
    80002f02:	a021                	j	80002f0a <itrunc+0x22>
    80002f04:	0491                	addi	s1,s1,4
    80002f06:	01248d63          	beq	s1,s2,80002f20 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f0a:	408c                	lw	a1,0(s1)
    80002f0c:	dde5                	beqz	a1,80002f04 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f0e:	0009a503          	lw	a0,0(s3)
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	90c080e7          	jalr	-1780(ra) # 8000281e <bfree>
      ip->addrs[i] = 0;
    80002f1a:	0004a023          	sw	zero,0(s1)
    80002f1e:	b7dd                	j	80002f04 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f20:	0809a583          	lw	a1,128(s3)
    80002f24:	e185                	bnez	a1,80002f44 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f26:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f2a:	854e                	mv	a0,s3
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	de4080e7          	jalr	-540(ra) # 80002d10 <iupdate>
}
    80002f34:	70a2                	ld	ra,40(sp)
    80002f36:	7402                	ld	s0,32(sp)
    80002f38:	64e2                	ld	s1,24(sp)
    80002f3a:	6942                	ld	s2,16(sp)
    80002f3c:	69a2                	ld	s3,8(sp)
    80002f3e:	6a02                	ld	s4,0(sp)
    80002f40:	6145                	addi	sp,sp,48
    80002f42:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f44:	0009a503          	lw	a0,0(s3)
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	690080e7          	jalr	1680(ra) # 800025d8 <bread>
    80002f50:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f52:	05850493          	addi	s1,a0,88
    80002f56:	45850913          	addi	s2,a0,1112
    80002f5a:	a811                	j	80002f6e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f5c:	0009a503          	lw	a0,0(s3)
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	8be080e7          	jalr	-1858(ra) # 8000281e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f68:	0491                	addi	s1,s1,4
    80002f6a:	01248563          	beq	s1,s2,80002f74 <itrunc+0x8c>
      if(a[j])
    80002f6e:	408c                	lw	a1,0(s1)
    80002f70:	dde5                	beqz	a1,80002f68 <itrunc+0x80>
    80002f72:	b7ed                	j	80002f5c <itrunc+0x74>
    brelse(bp);
    80002f74:	8552                	mv	a0,s4
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	792080e7          	jalr	1938(ra) # 80002708 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f7e:	0809a583          	lw	a1,128(s3)
    80002f82:	0009a503          	lw	a0,0(s3)
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	898080e7          	jalr	-1896(ra) # 8000281e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f8e:	0809a023          	sw	zero,128(s3)
    80002f92:	bf51                	j	80002f26 <itrunc+0x3e>

0000000080002f94 <iput>:
{
    80002f94:	1101                	addi	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	e426                	sd	s1,8(sp)
    80002f9c:	e04a                	sd	s2,0(sp)
    80002f9e:	1000                	addi	s0,sp,32
    80002fa0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fa2:	00114517          	auipc	a0,0x114
    80002fa6:	5d650513          	addi	a0,a0,1494 # 80117578 <itable>
    80002faa:	00003097          	auipc	ra,0x3
    80002fae:	428080e7          	jalr	1064(ra) # 800063d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fb2:	4498                	lw	a4,8(s1)
    80002fb4:	4785                	li	a5,1
    80002fb6:	02f70363          	beq	a4,a5,80002fdc <iput+0x48>
  ip->ref--;
    80002fba:	449c                	lw	a5,8(s1)
    80002fbc:	37fd                	addiw	a5,a5,-1
    80002fbe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fc0:	00114517          	auipc	a0,0x114
    80002fc4:	5b850513          	addi	a0,a0,1464 # 80117578 <itable>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	4be080e7          	jalr	1214(ra) # 80006486 <release>
}
    80002fd0:	60e2                	ld	ra,24(sp)
    80002fd2:	6442                	ld	s0,16(sp)
    80002fd4:	64a2                	ld	s1,8(sp)
    80002fd6:	6902                	ld	s2,0(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fdc:	40bc                	lw	a5,64(s1)
    80002fde:	dff1                	beqz	a5,80002fba <iput+0x26>
    80002fe0:	04a49783          	lh	a5,74(s1)
    80002fe4:	fbf9                	bnez	a5,80002fba <iput+0x26>
    acquiresleep(&ip->lock);
    80002fe6:	01048913          	addi	s2,s1,16
    80002fea:	854a                	mv	a0,s2
    80002fec:	00001097          	auipc	ra,0x1
    80002ff0:	ab8080e7          	jalr	-1352(ra) # 80003aa4 <acquiresleep>
    release(&itable.lock);
    80002ff4:	00114517          	auipc	a0,0x114
    80002ff8:	58450513          	addi	a0,a0,1412 # 80117578 <itable>
    80002ffc:	00003097          	auipc	ra,0x3
    80003000:	48a080e7          	jalr	1162(ra) # 80006486 <release>
    itrunc(ip);
    80003004:	8526                	mv	a0,s1
    80003006:	00000097          	auipc	ra,0x0
    8000300a:	ee2080e7          	jalr	-286(ra) # 80002ee8 <itrunc>
    ip->type = 0;
    8000300e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003012:	8526                	mv	a0,s1
    80003014:	00000097          	auipc	ra,0x0
    80003018:	cfc080e7          	jalr	-772(ra) # 80002d10 <iupdate>
    ip->valid = 0;
    8000301c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003020:	854a                	mv	a0,s2
    80003022:	00001097          	auipc	ra,0x1
    80003026:	ad8080e7          	jalr	-1320(ra) # 80003afa <releasesleep>
    acquire(&itable.lock);
    8000302a:	00114517          	auipc	a0,0x114
    8000302e:	54e50513          	addi	a0,a0,1358 # 80117578 <itable>
    80003032:	00003097          	auipc	ra,0x3
    80003036:	3a0080e7          	jalr	928(ra) # 800063d2 <acquire>
    8000303a:	b741                	j	80002fba <iput+0x26>

000000008000303c <iunlockput>:
{
    8000303c:	1101                	addi	sp,sp,-32
    8000303e:	ec06                	sd	ra,24(sp)
    80003040:	e822                	sd	s0,16(sp)
    80003042:	e426                	sd	s1,8(sp)
    80003044:	1000                	addi	s0,sp,32
    80003046:	84aa                	mv	s1,a0
  iunlock(ip);
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	e54080e7          	jalr	-428(ra) # 80002e9c <iunlock>
  iput(ip);
    80003050:	8526                	mv	a0,s1
    80003052:	00000097          	auipc	ra,0x0
    80003056:	f42080e7          	jalr	-190(ra) # 80002f94 <iput>
}
    8000305a:	60e2                	ld	ra,24(sp)
    8000305c:	6442                	ld	s0,16(sp)
    8000305e:	64a2                	ld	s1,8(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret

0000000080003064 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003064:	1141                	addi	sp,sp,-16
    80003066:	e422                	sd	s0,8(sp)
    80003068:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000306a:	411c                	lw	a5,0(a0)
    8000306c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000306e:	415c                	lw	a5,4(a0)
    80003070:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003072:	04451783          	lh	a5,68(a0)
    80003076:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000307a:	04a51783          	lh	a5,74(a0)
    8000307e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003082:	04c56783          	lwu	a5,76(a0)
    80003086:	e99c                	sd	a5,16(a1)
}
    80003088:	6422                	ld	s0,8(sp)
    8000308a:	0141                	addi	sp,sp,16
    8000308c:	8082                	ret

000000008000308e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000308e:	457c                	lw	a5,76(a0)
    80003090:	0ed7e963          	bltu	a5,a3,80003182 <readi+0xf4>
{
    80003094:	7159                	addi	sp,sp,-112
    80003096:	f486                	sd	ra,104(sp)
    80003098:	f0a2                	sd	s0,96(sp)
    8000309a:	eca6                	sd	s1,88(sp)
    8000309c:	e8ca                	sd	s2,80(sp)
    8000309e:	e4ce                	sd	s3,72(sp)
    800030a0:	e0d2                	sd	s4,64(sp)
    800030a2:	fc56                	sd	s5,56(sp)
    800030a4:	f85a                	sd	s6,48(sp)
    800030a6:	f45e                	sd	s7,40(sp)
    800030a8:	f062                	sd	s8,32(sp)
    800030aa:	ec66                	sd	s9,24(sp)
    800030ac:	e86a                	sd	s10,16(sp)
    800030ae:	e46e                	sd	s11,8(sp)
    800030b0:	1880                	addi	s0,sp,112
    800030b2:	8baa                	mv	s7,a0
    800030b4:	8c2e                	mv	s8,a1
    800030b6:	8ab2                	mv	s5,a2
    800030b8:	84b6                	mv	s1,a3
    800030ba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030bc:	9f35                	addw	a4,a4,a3
    return 0;
    800030be:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030c0:	0ad76063          	bltu	a4,a3,80003160 <readi+0xd2>
  if(off + n > ip->size)
    800030c4:	00e7f463          	bgeu	a5,a4,800030cc <readi+0x3e>
    n = ip->size - off;
    800030c8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030cc:	0a0b0963          	beqz	s6,8000317e <readi+0xf0>
    800030d0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030d6:	5cfd                	li	s9,-1
    800030d8:	a82d                	j	80003112 <readi+0x84>
    800030da:	020a1d93          	slli	s11,s4,0x20
    800030de:	020ddd93          	srli	s11,s11,0x20
    800030e2:	05890613          	addi	a2,s2,88
    800030e6:	86ee                	mv	a3,s11
    800030e8:	963a                	add	a2,a2,a4
    800030ea:	85d6                	mv	a1,s5
    800030ec:	8562                	mv	a0,s8
    800030ee:	fffff097          	auipc	ra,0xfffff
    800030f2:	a14080e7          	jalr	-1516(ra) # 80001b02 <either_copyout>
    800030f6:	05950d63          	beq	a0,s9,80003150 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030fa:	854a                	mv	a0,s2
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	60c080e7          	jalr	1548(ra) # 80002708 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003104:	013a09bb          	addw	s3,s4,s3
    80003108:	009a04bb          	addw	s1,s4,s1
    8000310c:	9aee                	add	s5,s5,s11
    8000310e:	0569f763          	bgeu	s3,s6,8000315c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003112:	000ba903          	lw	s2,0(s7)
    80003116:	00a4d59b          	srliw	a1,s1,0xa
    8000311a:	855e                	mv	a0,s7
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	8b0080e7          	jalr	-1872(ra) # 800029cc <bmap>
    80003124:	0005059b          	sext.w	a1,a0
    80003128:	854a                	mv	a0,s2
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	4ae080e7          	jalr	1198(ra) # 800025d8 <bread>
    80003132:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003134:	3ff4f713          	andi	a4,s1,1023
    80003138:	40ed07bb          	subw	a5,s10,a4
    8000313c:	413b06bb          	subw	a3,s6,s3
    80003140:	8a3e                	mv	s4,a5
    80003142:	2781                	sext.w	a5,a5
    80003144:	0006861b          	sext.w	a2,a3
    80003148:	f8f679e3          	bgeu	a2,a5,800030da <readi+0x4c>
    8000314c:	8a36                	mv	s4,a3
    8000314e:	b771                	j	800030da <readi+0x4c>
      brelse(bp);
    80003150:	854a                	mv	a0,s2
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	5b6080e7          	jalr	1462(ra) # 80002708 <brelse>
      tot = -1;
    8000315a:	59fd                	li	s3,-1
  }
  return tot;
    8000315c:	0009851b          	sext.w	a0,s3
}
    80003160:	70a6                	ld	ra,104(sp)
    80003162:	7406                	ld	s0,96(sp)
    80003164:	64e6                	ld	s1,88(sp)
    80003166:	6946                	ld	s2,80(sp)
    80003168:	69a6                	ld	s3,72(sp)
    8000316a:	6a06                	ld	s4,64(sp)
    8000316c:	7ae2                	ld	s5,56(sp)
    8000316e:	7b42                	ld	s6,48(sp)
    80003170:	7ba2                	ld	s7,40(sp)
    80003172:	7c02                	ld	s8,32(sp)
    80003174:	6ce2                	ld	s9,24(sp)
    80003176:	6d42                	ld	s10,16(sp)
    80003178:	6da2                	ld	s11,8(sp)
    8000317a:	6165                	addi	sp,sp,112
    8000317c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000317e:	89da                	mv	s3,s6
    80003180:	bff1                	j	8000315c <readi+0xce>
    return 0;
    80003182:	4501                	li	a0,0
}
    80003184:	8082                	ret

0000000080003186 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003186:	457c                	lw	a5,76(a0)
    80003188:	10d7e863          	bltu	a5,a3,80003298 <writei+0x112>
{
    8000318c:	7159                	addi	sp,sp,-112
    8000318e:	f486                	sd	ra,104(sp)
    80003190:	f0a2                	sd	s0,96(sp)
    80003192:	eca6                	sd	s1,88(sp)
    80003194:	e8ca                	sd	s2,80(sp)
    80003196:	e4ce                	sd	s3,72(sp)
    80003198:	e0d2                	sd	s4,64(sp)
    8000319a:	fc56                	sd	s5,56(sp)
    8000319c:	f85a                	sd	s6,48(sp)
    8000319e:	f45e                	sd	s7,40(sp)
    800031a0:	f062                	sd	s8,32(sp)
    800031a2:	ec66                	sd	s9,24(sp)
    800031a4:	e86a                	sd	s10,16(sp)
    800031a6:	e46e                	sd	s11,8(sp)
    800031a8:	1880                	addi	s0,sp,112
    800031aa:	8b2a                	mv	s6,a0
    800031ac:	8c2e                	mv	s8,a1
    800031ae:	8ab2                	mv	s5,a2
    800031b0:	8936                	mv	s2,a3
    800031b2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031b4:	00e687bb          	addw	a5,a3,a4
    800031b8:	0ed7e263          	bltu	a5,a3,8000329c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031bc:	00043737          	lui	a4,0x43
    800031c0:	0ef76063          	bltu	a4,a5,800032a0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c4:	0c0b8863          	beqz	s7,80003294 <writei+0x10e>
    800031c8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ca:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031ce:	5cfd                	li	s9,-1
    800031d0:	a091                	j	80003214 <writei+0x8e>
    800031d2:	02099d93          	slli	s11,s3,0x20
    800031d6:	020ddd93          	srli	s11,s11,0x20
    800031da:	05848513          	addi	a0,s1,88
    800031de:	86ee                	mv	a3,s11
    800031e0:	8656                	mv	a2,s5
    800031e2:	85e2                	mv	a1,s8
    800031e4:	953a                	add	a0,a0,a4
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	972080e7          	jalr	-1678(ra) # 80001b58 <either_copyin>
    800031ee:	07950263          	beq	a0,s9,80003252 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	790080e7          	jalr	1936(ra) # 80003984 <log_write>
    brelse(bp);
    800031fc:	8526                	mv	a0,s1
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	50a080e7          	jalr	1290(ra) # 80002708 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003206:	01498a3b          	addw	s4,s3,s4
    8000320a:	0129893b          	addw	s2,s3,s2
    8000320e:	9aee                	add	s5,s5,s11
    80003210:	057a7663          	bgeu	s4,s7,8000325c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003214:	000b2483          	lw	s1,0(s6)
    80003218:	00a9559b          	srliw	a1,s2,0xa
    8000321c:	855a                	mv	a0,s6
    8000321e:	fffff097          	auipc	ra,0xfffff
    80003222:	7ae080e7          	jalr	1966(ra) # 800029cc <bmap>
    80003226:	0005059b          	sext.w	a1,a0
    8000322a:	8526                	mv	a0,s1
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	3ac080e7          	jalr	940(ra) # 800025d8 <bread>
    80003234:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003236:	3ff97713          	andi	a4,s2,1023
    8000323a:	40ed07bb          	subw	a5,s10,a4
    8000323e:	414b86bb          	subw	a3,s7,s4
    80003242:	89be                	mv	s3,a5
    80003244:	2781                	sext.w	a5,a5
    80003246:	0006861b          	sext.w	a2,a3
    8000324a:	f8f674e3          	bgeu	a2,a5,800031d2 <writei+0x4c>
    8000324e:	89b6                	mv	s3,a3
    80003250:	b749                	j	800031d2 <writei+0x4c>
      brelse(bp);
    80003252:	8526                	mv	a0,s1
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	4b4080e7          	jalr	1204(ra) # 80002708 <brelse>
  }

  if(off > ip->size)
    8000325c:	04cb2783          	lw	a5,76(s6)
    80003260:	0127f463          	bgeu	a5,s2,80003268 <writei+0xe2>
    ip->size = off;
    80003264:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003268:	855a                	mv	a0,s6
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	aa6080e7          	jalr	-1370(ra) # 80002d10 <iupdate>

  return tot;
    80003272:	000a051b          	sext.w	a0,s4
}
    80003276:	70a6                	ld	ra,104(sp)
    80003278:	7406                	ld	s0,96(sp)
    8000327a:	64e6                	ld	s1,88(sp)
    8000327c:	6946                	ld	s2,80(sp)
    8000327e:	69a6                	ld	s3,72(sp)
    80003280:	6a06                	ld	s4,64(sp)
    80003282:	7ae2                	ld	s5,56(sp)
    80003284:	7b42                	ld	s6,48(sp)
    80003286:	7ba2                	ld	s7,40(sp)
    80003288:	7c02                	ld	s8,32(sp)
    8000328a:	6ce2                	ld	s9,24(sp)
    8000328c:	6d42                	ld	s10,16(sp)
    8000328e:	6da2                	ld	s11,8(sp)
    80003290:	6165                	addi	sp,sp,112
    80003292:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003294:	8a5e                	mv	s4,s7
    80003296:	bfc9                	j	80003268 <writei+0xe2>
    return -1;
    80003298:	557d                	li	a0,-1
}
    8000329a:	8082                	ret
    return -1;
    8000329c:	557d                	li	a0,-1
    8000329e:	bfe1                	j	80003276 <writei+0xf0>
    return -1;
    800032a0:	557d                	li	a0,-1
    800032a2:	bfd1                	j	80003276 <writei+0xf0>

00000000800032a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032a4:	1141                	addi	sp,sp,-16
    800032a6:	e406                	sd	ra,8(sp)
    800032a8:	e022                	sd	s0,0(sp)
    800032aa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032ac:	4639                	li	a2,14
    800032ae:	ffffd097          	auipc	ra,0xffffd
    800032b2:	1d0080e7          	jalr	464(ra) # 8000047e <strncmp>
}
    800032b6:	60a2                	ld	ra,8(sp)
    800032b8:	6402                	ld	s0,0(sp)
    800032ba:	0141                	addi	sp,sp,16
    800032bc:	8082                	ret

00000000800032be <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032be:	7139                	addi	sp,sp,-64
    800032c0:	fc06                	sd	ra,56(sp)
    800032c2:	f822                	sd	s0,48(sp)
    800032c4:	f426                	sd	s1,40(sp)
    800032c6:	f04a                	sd	s2,32(sp)
    800032c8:	ec4e                	sd	s3,24(sp)
    800032ca:	e852                	sd	s4,16(sp)
    800032cc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032ce:	04451703          	lh	a4,68(a0)
    800032d2:	4785                	li	a5,1
    800032d4:	00f71a63          	bne	a4,a5,800032e8 <dirlookup+0x2a>
    800032d8:	892a                	mv	s2,a0
    800032da:	89ae                	mv	s3,a1
    800032dc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032de:	457c                	lw	a5,76(a0)
    800032e0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032e2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e4:	e79d                	bnez	a5,80003312 <dirlookup+0x54>
    800032e6:	a8a5                	j	8000335e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032e8:	00005517          	auipc	a0,0x5
    800032ec:	2b850513          	addi	a0,a0,696 # 800085a0 <syscalls+0x1a0>
    800032f0:	00003097          	auipc	ra,0x3
    800032f4:	b98080e7          	jalr	-1128(ra) # 80005e88 <panic>
      panic("dirlookup read");
    800032f8:	00005517          	auipc	a0,0x5
    800032fc:	2c050513          	addi	a0,a0,704 # 800085b8 <syscalls+0x1b8>
    80003300:	00003097          	auipc	ra,0x3
    80003304:	b88080e7          	jalr	-1144(ra) # 80005e88 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003308:	24c1                	addiw	s1,s1,16
    8000330a:	04c92783          	lw	a5,76(s2)
    8000330e:	04f4f763          	bgeu	s1,a5,8000335c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003312:	4741                	li	a4,16
    80003314:	86a6                	mv	a3,s1
    80003316:	fc040613          	addi	a2,s0,-64
    8000331a:	4581                	li	a1,0
    8000331c:	854a                	mv	a0,s2
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	d70080e7          	jalr	-656(ra) # 8000308e <readi>
    80003326:	47c1                	li	a5,16
    80003328:	fcf518e3          	bne	a0,a5,800032f8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000332c:	fc045783          	lhu	a5,-64(s0)
    80003330:	dfe1                	beqz	a5,80003308 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003332:	fc240593          	addi	a1,s0,-62
    80003336:	854e                	mv	a0,s3
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	f6c080e7          	jalr	-148(ra) # 800032a4 <namecmp>
    80003340:	f561                	bnez	a0,80003308 <dirlookup+0x4a>
      if(poff)
    80003342:	000a0463          	beqz	s4,8000334a <dirlookup+0x8c>
        *poff = off;
    80003346:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000334a:	fc045583          	lhu	a1,-64(s0)
    8000334e:	00092503          	lw	a0,0(s2)
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	754080e7          	jalr	1876(ra) # 80002aa6 <iget>
    8000335a:	a011                	j	8000335e <dirlookup+0xa0>
  return 0;
    8000335c:	4501                	li	a0,0
}
    8000335e:	70e2                	ld	ra,56(sp)
    80003360:	7442                	ld	s0,48(sp)
    80003362:	74a2                	ld	s1,40(sp)
    80003364:	7902                	ld	s2,32(sp)
    80003366:	69e2                	ld	s3,24(sp)
    80003368:	6a42                	ld	s4,16(sp)
    8000336a:	6121                	addi	sp,sp,64
    8000336c:	8082                	ret

000000008000336e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000336e:	711d                	addi	sp,sp,-96
    80003370:	ec86                	sd	ra,88(sp)
    80003372:	e8a2                	sd	s0,80(sp)
    80003374:	e4a6                	sd	s1,72(sp)
    80003376:	e0ca                	sd	s2,64(sp)
    80003378:	fc4e                	sd	s3,56(sp)
    8000337a:	f852                	sd	s4,48(sp)
    8000337c:	f456                	sd	s5,40(sp)
    8000337e:	f05a                	sd	s6,32(sp)
    80003380:	ec5e                	sd	s7,24(sp)
    80003382:	e862                	sd	s8,16(sp)
    80003384:	e466                	sd	s9,8(sp)
    80003386:	1080                	addi	s0,sp,96
    80003388:	84aa                	mv	s1,a0
    8000338a:	8b2e                	mv	s6,a1
    8000338c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000338e:	00054703          	lbu	a4,0(a0)
    80003392:	02f00793          	li	a5,47
    80003396:	02f70363          	beq	a4,a5,800033bc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000339a:	ffffe097          	auipc	ra,0xffffe
    8000339e:	d08080e7          	jalr	-760(ra) # 800010a2 <myproc>
    800033a2:	15053503          	ld	a0,336(a0)
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	9f6080e7          	jalr	-1546(ra) # 80002d9c <idup>
    800033ae:	89aa                	mv	s3,a0
  while(*path == '/')
    800033b0:	02f00913          	li	s2,47
  len = path - s;
    800033b4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033b6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033b8:	4c05                	li	s8,1
    800033ba:	a865                	j	80003472 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033bc:	4585                	li	a1,1
    800033be:	4505                	li	a0,1
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	6e6080e7          	jalr	1766(ra) # 80002aa6 <iget>
    800033c8:	89aa                	mv	s3,a0
    800033ca:	b7dd                	j	800033b0 <namex+0x42>
      iunlockput(ip);
    800033cc:	854e                	mv	a0,s3
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	c6e080e7          	jalr	-914(ra) # 8000303c <iunlockput>
      return 0;
    800033d6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033d8:	854e                	mv	a0,s3
    800033da:	60e6                	ld	ra,88(sp)
    800033dc:	6446                	ld	s0,80(sp)
    800033de:	64a6                	ld	s1,72(sp)
    800033e0:	6906                	ld	s2,64(sp)
    800033e2:	79e2                	ld	s3,56(sp)
    800033e4:	7a42                	ld	s4,48(sp)
    800033e6:	7aa2                	ld	s5,40(sp)
    800033e8:	7b02                	ld	s6,32(sp)
    800033ea:	6be2                	ld	s7,24(sp)
    800033ec:	6c42                	ld	s8,16(sp)
    800033ee:	6ca2                	ld	s9,8(sp)
    800033f0:	6125                	addi	sp,sp,96
    800033f2:	8082                	ret
      iunlock(ip);
    800033f4:	854e                	mv	a0,s3
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	aa6080e7          	jalr	-1370(ra) # 80002e9c <iunlock>
      return ip;
    800033fe:	bfe9                	j	800033d8 <namex+0x6a>
      iunlockput(ip);
    80003400:	854e                	mv	a0,s3
    80003402:	00000097          	auipc	ra,0x0
    80003406:	c3a080e7          	jalr	-966(ra) # 8000303c <iunlockput>
      return 0;
    8000340a:	89d2                	mv	s3,s4
    8000340c:	b7f1                	j	800033d8 <namex+0x6a>
  len = path - s;
    8000340e:	40b48633          	sub	a2,s1,a1
    80003412:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003416:	094cd463          	bge	s9,s4,8000349e <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000341a:	4639                	li	a2,14
    8000341c:	8556                	mv	a0,s5
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	fe8080e7          	jalr	-24(ra) # 80000406 <memmove>
  while(*path == '/')
    80003426:	0004c783          	lbu	a5,0(s1)
    8000342a:	01279763          	bne	a5,s2,80003438 <namex+0xca>
    path++;
    8000342e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003430:	0004c783          	lbu	a5,0(s1)
    80003434:	ff278de3          	beq	a5,s2,8000342e <namex+0xc0>
    ilock(ip);
    80003438:	854e                	mv	a0,s3
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	9a0080e7          	jalr	-1632(ra) # 80002dda <ilock>
    if(ip->type != T_DIR){
    80003442:	04499783          	lh	a5,68(s3)
    80003446:	f98793e3          	bne	a5,s8,800033cc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000344a:	000b0563          	beqz	s6,80003454 <namex+0xe6>
    8000344e:	0004c783          	lbu	a5,0(s1)
    80003452:	d3cd                	beqz	a5,800033f4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003454:	865e                	mv	a2,s7
    80003456:	85d6                	mv	a1,s5
    80003458:	854e                	mv	a0,s3
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	e64080e7          	jalr	-412(ra) # 800032be <dirlookup>
    80003462:	8a2a                	mv	s4,a0
    80003464:	dd51                	beqz	a0,80003400 <namex+0x92>
    iunlockput(ip);
    80003466:	854e                	mv	a0,s3
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	bd4080e7          	jalr	-1068(ra) # 8000303c <iunlockput>
    ip = next;
    80003470:	89d2                	mv	s3,s4
  while(*path == '/')
    80003472:	0004c783          	lbu	a5,0(s1)
    80003476:	05279763          	bne	a5,s2,800034c4 <namex+0x156>
    path++;
    8000347a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000347c:	0004c783          	lbu	a5,0(s1)
    80003480:	ff278de3          	beq	a5,s2,8000347a <namex+0x10c>
  if(*path == 0)
    80003484:	c79d                	beqz	a5,800034b2 <namex+0x144>
    path++;
    80003486:	85a6                	mv	a1,s1
  len = path - s;
    80003488:	8a5e                	mv	s4,s7
    8000348a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000348c:	01278963          	beq	a5,s2,8000349e <namex+0x130>
    80003490:	dfbd                	beqz	a5,8000340e <namex+0xa0>
    path++;
    80003492:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003494:	0004c783          	lbu	a5,0(s1)
    80003498:	ff279ce3          	bne	a5,s2,80003490 <namex+0x122>
    8000349c:	bf8d                	j	8000340e <namex+0xa0>
    memmove(name, s, len);
    8000349e:	2601                	sext.w	a2,a2
    800034a0:	8556                	mv	a0,s5
    800034a2:	ffffd097          	auipc	ra,0xffffd
    800034a6:	f64080e7          	jalr	-156(ra) # 80000406 <memmove>
    name[len] = 0;
    800034aa:	9a56                	add	s4,s4,s5
    800034ac:	000a0023          	sb	zero,0(s4)
    800034b0:	bf9d                	j	80003426 <namex+0xb8>
  if(nameiparent){
    800034b2:	f20b03e3          	beqz	s6,800033d8 <namex+0x6a>
    iput(ip);
    800034b6:	854e                	mv	a0,s3
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	adc080e7          	jalr	-1316(ra) # 80002f94 <iput>
    return 0;
    800034c0:	4981                	li	s3,0
    800034c2:	bf19                	j	800033d8 <namex+0x6a>
  if(*path == 0)
    800034c4:	d7fd                	beqz	a5,800034b2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800034c6:	0004c783          	lbu	a5,0(s1)
    800034ca:	85a6                	mv	a1,s1
    800034cc:	b7d1                	j	80003490 <namex+0x122>

00000000800034ce <dirlink>:
{
    800034ce:	7139                	addi	sp,sp,-64
    800034d0:	fc06                	sd	ra,56(sp)
    800034d2:	f822                	sd	s0,48(sp)
    800034d4:	f426                	sd	s1,40(sp)
    800034d6:	f04a                	sd	s2,32(sp)
    800034d8:	ec4e                	sd	s3,24(sp)
    800034da:	e852                	sd	s4,16(sp)
    800034dc:	0080                	addi	s0,sp,64
    800034de:	892a                	mv	s2,a0
    800034e0:	8a2e                	mv	s4,a1
    800034e2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034e4:	4601                	li	a2,0
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	dd8080e7          	jalr	-552(ra) # 800032be <dirlookup>
    800034ee:	e93d                	bnez	a0,80003564 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034f0:	04c92483          	lw	s1,76(s2)
    800034f4:	c49d                	beqz	s1,80003522 <dirlink+0x54>
    800034f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034f8:	4741                	li	a4,16
    800034fa:	86a6                	mv	a3,s1
    800034fc:	fc040613          	addi	a2,s0,-64
    80003500:	4581                	li	a1,0
    80003502:	854a                	mv	a0,s2
    80003504:	00000097          	auipc	ra,0x0
    80003508:	b8a080e7          	jalr	-1142(ra) # 8000308e <readi>
    8000350c:	47c1                	li	a5,16
    8000350e:	06f51163          	bne	a0,a5,80003570 <dirlink+0xa2>
    if(de.inum == 0)
    80003512:	fc045783          	lhu	a5,-64(s0)
    80003516:	c791                	beqz	a5,80003522 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003518:	24c1                	addiw	s1,s1,16
    8000351a:	04c92783          	lw	a5,76(s2)
    8000351e:	fcf4ede3          	bltu	s1,a5,800034f8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003522:	4639                	li	a2,14
    80003524:	85d2                	mv	a1,s4
    80003526:	fc240513          	addi	a0,s0,-62
    8000352a:	ffffd097          	auipc	ra,0xffffd
    8000352e:	f90080e7          	jalr	-112(ra) # 800004ba <strncpy>
  de.inum = inum;
    80003532:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003536:	4741                	li	a4,16
    80003538:	86a6                	mv	a3,s1
    8000353a:	fc040613          	addi	a2,s0,-64
    8000353e:	4581                	li	a1,0
    80003540:	854a                	mv	a0,s2
    80003542:	00000097          	auipc	ra,0x0
    80003546:	c44080e7          	jalr	-956(ra) # 80003186 <writei>
    8000354a:	872a                	mv	a4,a0
    8000354c:	47c1                	li	a5,16
  return 0;
    8000354e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003550:	02f71863          	bne	a4,a5,80003580 <dirlink+0xb2>
}
    80003554:	70e2                	ld	ra,56(sp)
    80003556:	7442                	ld	s0,48(sp)
    80003558:	74a2                	ld	s1,40(sp)
    8000355a:	7902                	ld	s2,32(sp)
    8000355c:	69e2                	ld	s3,24(sp)
    8000355e:	6a42                	ld	s4,16(sp)
    80003560:	6121                	addi	sp,sp,64
    80003562:	8082                	ret
    iput(ip);
    80003564:	00000097          	auipc	ra,0x0
    80003568:	a30080e7          	jalr	-1488(ra) # 80002f94 <iput>
    return -1;
    8000356c:	557d                	li	a0,-1
    8000356e:	b7dd                	j	80003554 <dirlink+0x86>
      panic("dirlink read");
    80003570:	00005517          	auipc	a0,0x5
    80003574:	05850513          	addi	a0,a0,88 # 800085c8 <syscalls+0x1c8>
    80003578:	00003097          	auipc	ra,0x3
    8000357c:	910080e7          	jalr	-1776(ra) # 80005e88 <panic>
    panic("dirlink");
    80003580:	00005517          	auipc	a0,0x5
    80003584:	15850513          	addi	a0,a0,344 # 800086d8 <syscalls+0x2d8>
    80003588:	00003097          	auipc	ra,0x3
    8000358c:	900080e7          	jalr	-1792(ra) # 80005e88 <panic>

0000000080003590 <namei>:

struct inode*
namei(char *path)
{
    80003590:	1101                	addi	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003598:	fe040613          	addi	a2,s0,-32
    8000359c:	4581                	li	a1,0
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	dd0080e7          	jalr	-560(ra) # 8000336e <namex>
}
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	6105                	addi	sp,sp,32
    800035ac:	8082                	ret

00000000800035ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035ae:	1141                	addi	sp,sp,-16
    800035b0:	e406                	sd	ra,8(sp)
    800035b2:	e022                	sd	s0,0(sp)
    800035b4:	0800                	addi	s0,sp,16
    800035b6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035b8:	4585                	li	a1,1
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	db4080e7          	jalr	-588(ra) # 8000336e <namex>
}
    800035c2:	60a2                	ld	ra,8(sp)
    800035c4:	6402                	ld	s0,0(sp)
    800035c6:	0141                	addi	sp,sp,16
    800035c8:	8082                	ret

00000000800035ca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035ca:	1101                	addi	sp,sp,-32
    800035cc:	ec06                	sd	ra,24(sp)
    800035ce:	e822                	sd	s0,16(sp)
    800035d0:	e426                	sd	s1,8(sp)
    800035d2:	e04a                	sd	s2,0(sp)
    800035d4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035d6:	00116917          	auipc	s2,0x116
    800035da:	a4a90913          	addi	s2,s2,-1462 # 80119020 <log>
    800035de:	01892583          	lw	a1,24(s2)
    800035e2:	02892503          	lw	a0,40(s2)
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	ff2080e7          	jalr	-14(ra) # 800025d8 <bread>
    800035ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035f0:	02c92683          	lw	a3,44(s2)
    800035f4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035f6:	02d05763          	blez	a3,80003624 <write_head+0x5a>
    800035fa:	00116797          	auipc	a5,0x116
    800035fe:	a5678793          	addi	a5,a5,-1450 # 80119050 <log+0x30>
    80003602:	05c50713          	addi	a4,a0,92
    80003606:	36fd                	addiw	a3,a3,-1
    80003608:	1682                	slli	a3,a3,0x20
    8000360a:	9281                	srli	a3,a3,0x20
    8000360c:	068a                	slli	a3,a3,0x2
    8000360e:	00116617          	auipc	a2,0x116
    80003612:	a4660613          	addi	a2,a2,-1466 # 80119054 <log+0x34>
    80003616:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003618:	4390                	lw	a2,0(a5)
    8000361a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000361c:	0791                	addi	a5,a5,4
    8000361e:	0711                	addi	a4,a4,4
    80003620:	fed79ce3          	bne	a5,a3,80003618 <write_head+0x4e>
  }
  bwrite(buf);
    80003624:	8526                	mv	a0,s1
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	0a4080e7          	jalr	164(ra) # 800026ca <bwrite>
  brelse(buf);
    8000362e:	8526                	mv	a0,s1
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	0d8080e7          	jalr	216(ra) # 80002708 <brelse>
}
    80003638:	60e2                	ld	ra,24(sp)
    8000363a:	6442                	ld	s0,16(sp)
    8000363c:	64a2                	ld	s1,8(sp)
    8000363e:	6902                	ld	s2,0(sp)
    80003640:	6105                	addi	sp,sp,32
    80003642:	8082                	ret

0000000080003644 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003644:	00116797          	auipc	a5,0x116
    80003648:	a087a783          	lw	a5,-1528(a5) # 8011904c <log+0x2c>
    8000364c:	0af05d63          	blez	a5,80003706 <install_trans+0xc2>
{
    80003650:	7139                	addi	sp,sp,-64
    80003652:	fc06                	sd	ra,56(sp)
    80003654:	f822                	sd	s0,48(sp)
    80003656:	f426                	sd	s1,40(sp)
    80003658:	f04a                	sd	s2,32(sp)
    8000365a:	ec4e                	sd	s3,24(sp)
    8000365c:	e852                	sd	s4,16(sp)
    8000365e:	e456                	sd	s5,8(sp)
    80003660:	e05a                	sd	s6,0(sp)
    80003662:	0080                	addi	s0,sp,64
    80003664:	8b2a                	mv	s6,a0
    80003666:	00116a97          	auipc	s5,0x116
    8000366a:	9eaa8a93          	addi	s5,s5,-1558 # 80119050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000366e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003670:	00116997          	auipc	s3,0x116
    80003674:	9b098993          	addi	s3,s3,-1616 # 80119020 <log>
    80003678:	a035                	j	800036a4 <install_trans+0x60>
      bunpin(dbuf);
    8000367a:	8526                	mv	a0,s1
    8000367c:	fffff097          	auipc	ra,0xfffff
    80003680:	166080e7          	jalr	358(ra) # 800027e2 <bunpin>
    brelse(lbuf);
    80003684:	854a                	mv	a0,s2
    80003686:	fffff097          	auipc	ra,0xfffff
    8000368a:	082080e7          	jalr	130(ra) # 80002708 <brelse>
    brelse(dbuf);
    8000368e:	8526                	mv	a0,s1
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	078080e7          	jalr	120(ra) # 80002708 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003698:	2a05                	addiw	s4,s4,1
    8000369a:	0a91                	addi	s5,s5,4
    8000369c:	02c9a783          	lw	a5,44(s3)
    800036a0:	04fa5963          	bge	s4,a5,800036f2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036a4:	0189a583          	lw	a1,24(s3)
    800036a8:	014585bb          	addw	a1,a1,s4
    800036ac:	2585                	addiw	a1,a1,1
    800036ae:	0289a503          	lw	a0,40(s3)
    800036b2:	fffff097          	auipc	ra,0xfffff
    800036b6:	f26080e7          	jalr	-218(ra) # 800025d8 <bread>
    800036ba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036bc:	000aa583          	lw	a1,0(s5)
    800036c0:	0289a503          	lw	a0,40(s3)
    800036c4:	fffff097          	auipc	ra,0xfffff
    800036c8:	f14080e7          	jalr	-236(ra) # 800025d8 <bread>
    800036cc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036ce:	40000613          	li	a2,1024
    800036d2:	05890593          	addi	a1,s2,88
    800036d6:	05850513          	addi	a0,a0,88
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	d2c080e7          	jalr	-724(ra) # 80000406 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036e2:	8526                	mv	a0,s1
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	fe6080e7          	jalr	-26(ra) # 800026ca <bwrite>
    if(recovering == 0)
    800036ec:	f80b1ce3          	bnez	s6,80003684 <install_trans+0x40>
    800036f0:	b769                	j	8000367a <install_trans+0x36>
}
    800036f2:	70e2                	ld	ra,56(sp)
    800036f4:	7442                	ld	s0,48(sp)
    800036f6:	74a2                	ld	s1,40(sp)
    800036f8:	7902                	ld	s2,32(sp)
    800036fa:	69e2                	ld	s3,24(sp)
    800036fc:	6a42                	ld	s4,16(sp)
    800036fe:	6aa2                	ld	s5,8(sp)
    80003700:	6b02                	ld	s6,0(sp)
    80003702:	6121                	addi	sp,sp,64
    80003704:	8082                	ret
    80003706:	8082                	ret

0000000080003708 <initlog>:
{
    80003708:	7179                	addi	sp,sp,-48
    8000370a:	f406                	sd	ra,40(sp)
    8000370c:	f022                	sd	s0,32(sp)
    8000370e:	ec26                	sd	s1,24(sp)
    80003710:	e84a                	sd	s2,16(sp)
    80003712:	e44e                	sd	s3,8(sp)
    80003714:	1800                	addi	s0,sp,48
    80003716:	892a                	mv	s2,a0
    80003718:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000371a:	00116497          	auipc	s1,0x116
    8000371e:	90648493          	addi	s1,s1,-1786 # 80119020 <log>
    80003722:	00005597          	auipc	a1,0x5
    80003726:	eb658593          	addi	a1,a1,-330 # 800085d8 <syscalls+0x1d8>
    8000372a:	8526                	mv	a0,s1
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	c16080e7          	jalr	-1002(ra) # 80006342 <initlock>
  log.start = sb->logstart;
    80003734:	0149a583          	lw	a1,20(s3)
    80003738:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000373a:	0109a783          	lw	a5,16(s3)
    8000373e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003740:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003744:	854a                	mv	a0,s2
    80003746:	fffff097          	auipc	ra,0xfffff
    8000374a:	e92080e7          	jalr	-366(ra) # 800025d8 <bread>
  log.lh.n = lh->n;
    8000374e:	4d3c                	lw	a5,88(a0)
    80003750:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003752:	02f05563          	blez	a5,8000377c <initlog+0x74>
    80003756:	05c50713          	addi	a4,a0,92
    8000375a:	00116697          	auipc	a3,0x116
    8000375e:	8f668693          	addi	a3,a3,-1802 # 80119050 <log+0x30>
    80003762:	37fd                	addiw	a5,a5,-1
    80003764:	1782                	slli	a5,a5,0x20
    80003766:	9381                	srli	a5,a5,0x20
    80003768:	078a                	slli	a5,a5,0x2
    8000376a:	06050613          	addi	a2,a0,96
    8000376e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003770:	4310                	lw	a2,0(a4)
    80003772:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003774:	0711                	addi	a4,a4,4
    80003776:	0691                	addi	a3,a3,4
    80003778:	fef71ce3          	bne	a4,a5,80003770 <initlog+0x68>
  brelse(buf);
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	f8c080e7          	jalr	-116(ra) # 80002708 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003784:	4505                	li	a0,1
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	ebe080e7          	jalr	-322(ra) # 80003644 <install_trans>
  log.lh.n = 0;
    8000378e:	00116797          	auipc	a5,0x116
    80003792:	8a07af23          	sw	zero,-1858(a5) # 8011904c <log+0x2c>
  write_head(); // clear the log
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	e34080e7          	jalr	-460(ra) # 800035ca <write_head>
}
    8000379e:	70a2                	ld	ra,40(sp)
    800037a0:	7402                	ld	s0,32(sp)
    800037a2:	64e2                	ld	s1,24(sp)
    800037a4:	6942                	ld	s2,16(sp)
    800037a6:	69a2                	ld	s3,8(sp)
    800037a8:	6145                	addi	sp,sp,48
    800037aa:	8082                	ret

00000000800037ac <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037ac:	1101                	addi	sp,sp,-32
    800037ae:	ec06                	sd	ra,24(sp)
    800037b0:	e822                	sd	s0,16(sp)
    800037b2:	e426                	sd	s1,8(sp)
    800037b4:	e04a                	sd	s2,0(sp)
    800037b6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037b8:	00116517          	auipc	a0,0x116
    800037bc:	86850513          	addi	a0,a0,-1944 # 80119020 <log>
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	c12080e7          	jalr	-1006(ra) # 800063d2 <acquire>
  while(1){
    if(log.committing){
    800037c8:	00116497          	auipc	s1,0x116
    800037cc:	85848493          	addi	s1,s1,-1960 # 80119020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037d0:	4979                	li	s2,30
    800037d2:	a039                	j	800037e0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037d4:	85a6                	mv	a1,s1
    800037d6:	8526                	mv	a0,s1
    800037d8:	ffffe097          	auipc	ra,0xffffe
    800037dc:	f86080e7          	jalr	-122(ra) # 8000175e <sleep>
    if(log.committing){
    800037e0:	50dc                	lw	a5,36(s1)
    800037e2:	fbed                	bnez	a5,800037d4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037e4:	509c                	lw	a5,32(s1)
    800037e6:	0017871b          	addiw	a4,a5,1
    800037ea:	0007069b          	sext.w	a3,a4
    800037ee:	0027179b          	slliw	a5,a4,0x2
    800037f2:	9fb9                	addw	a5,a5,a4
    800037f4:	0017979b          	slliw	a5,a5,0x1
    800037f8:	54d8                	lw	a4,44(s1)
    800037fa:	9fb9                	addw	a5,a5,a4
    800037fc:	00f95963          	bge	s2,a5,8000380e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003800:	85a6                	mv	a1,s1
    80003802:	8526                	mv	a0,s1
    80003804:	ffffe097          	auipc	ra,0xffffe
    80003808:	f5a080e7          	jalr	-166(ra) # 8000175e <sleep>
    8000380c:	bfd1                	j	800037e0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000380e:	00116517          	auipc	a0,0x116
    80003812:	81250513          	addi	a0,a0,-2030 # 80119020 <log>
    80003816:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	c6e080e7          	jalr	-914(ra) # 80006486 <release>
      break;
    }
  }
}
    80003820:	60e2                	ld	ra,24(sp)
    80003822:	6442                	ld	s0,16(sp)
    80003824:	64a2                	ld	s1,8(sp)
    80003826:	6902                	ld	s2,0(sp)
    80003828:	6105                	addi	sp,sp,32
    8000382a:	8082                	ret

000000008000382c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000382c:	7139                	addi	sp,sp,-64
    8000382e:	fc06                	sd	ra,56(sp)
    80003830:	f822                	sd	s0,48(sp)
    80003832:	f426                	sd	s1,40(sp)
    80003834:	f04a                	sd	s2,32(sp)
    80003836:	ec4e                	sd	s3,24(sp)
    80003838:	e852                	sd	s4,16(sp)
    8000383a:	e456                	sd	s5,8(sp)
    8000383c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000383e:	00115497          	auipc	s1,0x115
    80003842:	7e248493          	addi	s1,s1,2018 # 80119020 <log>
    80003846:	8526                	mv	a0,s1
    80003848:	00003097          	auipc	ra,0x3
    8000384c:	b8a080e7          	jalr	-1142(ra) # 800063d2 <acquire>
  log.outstanding -= 1;
    80003850:	509c                	lw	a5,32(s1)
    80003852:	37fd                	addiw	a5,a5,-1
    80003854:	0007891b          	sext.w	s2,a5
    80003858:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000385a:	50dc                	lw	a5,36(s1)
    8000385c:	efb9                	bnez	a5,800038ba <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000385e:	06091663          	bnez	s2,800038ca <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003862:	00115497          	auipc	s1,0x115
    80003866:	7be48493          	addi	s1,s1,1982 # 80119020 <log>
    8000386a:	4785                	li	a5,1
    8000386c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000386e:	8526                	mv	a0,s1
    80003870:	00003097          	auipc	ra,0x3
    80003874:	c16080e7          	jalr	-1002(ra) # 80006486 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003878:	54dc                	lw	a5,44(s1)
    8000387a:	06f04763          	bgtz	a5,800038e8 <end_op+0xbc>
    acquire(&log.lock);
    8000387e:	00115497          	auipc	s1,0x115
    80003882:	7a248493          	addi	s1,s1,1954 # 80119020 <log>
    80003886:	8526                	mv	a0,s1
    80003888:	00003097          	auipc	ra,0x3
    8000388c:	b4a080e7          	jalr	-1206(ra) # 800063d2 <acquire>
    log.committing = 0;
    80003890:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003894:	8526                	mv	a0,s1
    80003896:	ffffe097          	auipc	ra,0xffffe
    8000389a:	054080e7          	jalr	84(ra) # 800018ea <wakeup>
    release(&log.lock);
    8000389e:	8526                	mv	a0,s1
    800038a0:	00003097          	auipc	ra,0x3
    800038a4:	be6080e7          	jalr	-1050(ra) # 80006486 <release>
}
    800038a8:	70e2                	ld	ra,56(sp)
    800038aa:	7442                	ld	s0,48(sp)
    800038ac:	74a2                	ld	s1,40(sp)
    800038ae:	7902                	ld	s2,32(sp)
    800038b0:	69e2                	ld	s3,24(sp)
    800038b2:	6a42                	ld	s4,16(sp)
    800038b4:	6aa2                	ld	s5,8(sp)
    800038b6:	6121                	addi	sp,sp,64
    800038b8:	8082                	ret
    panic("log.committing");
    800038ba:	00005517          	auipc	a0,0x5
    800038be:	d2650513          	addi	a0,a0,-730 # 800085e0 <syscalls+0x1e0>
    800038c2:	00002097          	auipc	ra,0x2
    800038c6:	5c6080e7          	jalr	1478(ra) # 80005e88 <panic>
    wakeup(&log);
    800038ca:	00115497          	auipc	s1,0x115
    800038ce:	75648493          	addi	s1,s1,1878 # 80119020 <log>
    800038d2:	8526                	mv	a0,s1
    800038d4:	ffffe097          	auipc	ra,0xffffe
    800038d8:	016080e7          	jalr	22(ra) # 800018ea <wakeup>
  release(&log.lock);
    800038dc:	8526                	mv	a0,s1
    800038de:	00003097          	auipc	ra,0x3
    800038e2:	ba8080e7          	jalr	-1112(ra) # 80006486 <release>
  if(do_commit){
    800038e6:	b7c9                	j	800038a8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038e8:	00115a97          	auipc	s5,0x115
    800038ec:	768a8a93          	addi	s5,s5,1896 # 80119050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038f0:	00115a17          	auipc	s4,0x115
    800038f4:	730a0a13          	addi	s4,s4,1840 # 80119020 <log>
    800038f8:	018a2583          	lw	a1,24(s4)
    800038fc:	012585bb          	addw	a1,a1,s2
    80003900:	2585                	addiw	a1,a1,1
    80003902:	028a2503          	lw	a0,40(s4)
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	cd2080e7          	jalr	-814(ra) # 800025d8 <bread>
    8000390e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003910:	000aa583          	lw	a1,0(s5)
    80003914:	028a2503          	lw	a0,40(s4)
    80003918:	fffff097          	auipc	ra,0xfffff
    8000391c:	cc0080e7          	jalr	-832(ra) # 800025d8 <bread>
    80003920:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003922:	40000613          	li	a2,1024
    80003926:	05850593          	addi	a1,a0,88
    8000392a:	05848513          	addi	a0,s1,88
    8000392e:	ffffd097          	auipc	ra,0xffffd
    80003932:	ad8080e7          	jalr	-1320(ra) # 80000406 <memmove>
    bwrite(to);  // write the log
    80003936:	8526                	mv	a0,s1
    80003938:	fffff097          	auipc	ra,0xfffff
    8000393c:	d92080e7          	jalr	-622(ra) # 800026ca <bwrite>
    brelse(from);
    80003940:	854e                	mv	a0,s3
    80003942:	fffff097          	auipc	ra,0xfffff
    80003946:	dc6080e7          	jalr	-570(ra) # 80002708 <brelse>
    brelse(to);
    8000394a:	8526                	mv	a0,s1
    8000394c:	fffff097          	auipc	ra,0xfffff
    80003950:	dbc080e7          	jalr	-580(ra) # 80002708 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003954:	2905                	addiw	s2,s2,1
    80003956:	0a91                	addi	s5,s5,4
    80003958:	02ca2783          	lw	a5,44(s4)
    8000395c:	f8f94ee3          	blt	s2,a5,800038f8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003960:	00000097          	auipc	ra,0x0
    80003964:	c6a080e7          	jalr	-918(ra) # 800035ca <write_head>
    install_trans(0); // Now install writes to home locations
    80003968:	4501                	li	a0,0
    8000396a:	00000097          	auipc	ra,0x0
    8000396e:	cda080e7          	jalr	-806(ra) # 80003644 <install_trans>
    log.lh.n = 0;
    80003972:	00115797          	auipc	a5,0x115
    80003976:	6c07ad23          	sw	zero,1754(a5) # 8011904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	c50080e7          	jalr	-944(ra) # 800035ca <write_head>
    80003982:	bdf5                	j	8000387e <end_op+0x52>

0000000080003984 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003992:	00115917          	auipc	s2,0x115
    80003996:	68e90913          	addi	s2,s2,1678 # 80119020 <log>
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	a36080e7          	jalr	-1482(ra) # 800063d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039a4:	02c92603          	lw	a2,44(s2)
    800039a8:	47f5                	li	a5,29
    800039aa:	06c7c563          	blt	a5,a2,80003a14 <log_write+0x90>
    800039ae:	00115797          	auipc	a5,0x115
    800039b2:	68e7a783          	lw	a5,1678(a5) # 8011903c <log+0x1c>
    800039b6:	37fd                	addiw	a5,a5,-1
    800039b8:	04f65e63          	bge	a2,a5,80003a14 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039bc:	00115797          	auipc	a5,0x115
    800039c0:	6847a783          	lw	a5,1668(a5) # 80119040 <log+0x20>
    800039c4:	06f05063          	blez	a5,80003a24 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039c8:	4781                	li	a5,0
    800039ca:	06c05563          	blez	a2,80003a34 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ce:	44cc                	lw	a1,12(s1)
    800039d0:	00115717          	auipc	a4,0x115
    800039d4:	68070713          	addi	a4,a4,1664 # 80119050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039da:	4314                	lw	a3,0(a4)
    800039dc:	04b68c63          	beq	a3,a1,80003a34 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039e0:	2785                	addiw	a5,a5,1
    800039e2:	0711                	addi	a4,a4,4
    800039e4:	fef61be3          	bne	a2,a5,800039da <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039e8:	0621                	addi	a2,a2,8
    800039ea:	060a                	slli	a2,a2,0x2
    800039ec:	00115797          	auipc	a5,0x115
    800039f0:	63478793          	addi	a5,a5,1588 # 80119020 <log>
    800039f4:	963e                	add	a2,a2,a5
    800039f6:	44dc                	lw	a5,12(s1)
    800039f8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039fa:	8526                	mv	a0,s1
    800039fc:	fffff097          	auipc	ra,0xfffff
    80003a00:	daa080e7          	jalr	-598(ra) # 800027a6 <bpin>
    log.lh.n++;
    80003a04:	00115717          	auipc	a4,0x115
    80003a08:	61c70713          	addi	a4,a4,1564 # 80119020 <log>
    80003a0c:	575c                	lw	a5,44(a4)
    80003a0e:	2785                	addiw	a5,a5,1
    80003a10:	d75c                	sw	a5,44(a4)
    80003a12:	a835                	j	80003a4e <log_write+0xca>
    panic("too big a transaction");
    80003a14:	00005517          	auipc	a0,0x5
    80003a18:	bdc50513          	addi	a0,a0,-1060 # 800085f0 <syscalls+0x1f0>
    80003a1c:	00002097          	auipc	ra,0x2
    80003a20:	46c080e7          	jalr	1132(ra) # 80005e88 <panic>
    panic("log_write outside of trans");
    80003a24:	00005517          	auipc	a0,0x5
    80003a28:	be450513          	addi	a0,a0,-1052 # 80008608 <syscalls+0x208>
    80003a2c:	00002097          	auipc	ra,0x2
    80003a30:	45c080e7          	jalr	1116(ra) # 80005e88 <panic>
  log.lh.block[i] = b->blockno;
    80003a34:	00878713          	addi	a4,a5,8
    80003a38:	00271693          	slli	a3,a4,0x2
    80003a3c:	00115717          	auipc	a4,0x115
    80003a40:	5e470713          	addi	a4,a4,1508 # 80119020 <log>
    80003a44:	9736                	add	a4,a4,a3
    80003a46:	44d4                	lw	a3,12(s1)
    80003a48:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a4a:	faf608e3          	beq	a2,a5,800039fa <log_write+0x76>
  }
  release(&log.lock);
    80003a4e:	00115517          	auipc	a0,0x115
    80003a52:	5d250513          	addi	a0,a0,1490 # 80119020 <log>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	a30080e7          	jalr	-1488(ra) # 80006486 <release>
}
    80003a5e:	60e2                	ld	ra,24(sp)
    80003a60:	6442                	ld	s0,16(sp)
    80003a62:	64a2                	ld	s1,8(sp)
    80003a64:	6902                	ld	s2,0(sp)
    80003a66:	6105                	addi	sp,sp,32
    80003a68:	8082                	ret

0000000080003a6a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a6a:	1101                	addi	sp,sp,-32
    80003a6c:	ec06                	sd	ra,24(sp)
    80003a6e:	e822                	sd	s0,16(sp)
    80003a70:	e426                	sd	s1,8(sp)
    80003a72:	e04a                	sd	s2,0(sp)
    80003a74:	1000                	addi	s0,sp,32
    80003a76:	84aa                	mv	s1,a0
    80003a78:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a7a:	00005597          	auipc	a1,0x5
    80003a7e:	bae58593          	addi	a1,a1,-1106 # 80008628 <syscalls+0x228>
    80003a82:	0521                	addi	a0,a0,8
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	8be080e7          	jalr	-1858(ra) # 80006342 <initlock>
  lk->name = name;
    80003a8c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a90:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a94:	0204a423          	sw	zero,40(s1)
}
    80003a98:	60e2                	ld	ra,24(sp)
    80003a9a:	6442                	ld	s0,16(sp)
    80003a9c:	64a2                	ld	s1,8(sp)
    80003a9e:	6902                	ld	s2,0(sp)
    80003aa0:	6105                	addi	sp,sp,32
    80003aa2:	8082                	ret

0000000080003aa4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003aa4:	1101                	addi	sp,sp,-32
    80003aa6:	ec06                	sd	ra,24(sp)
    80003aa8:	e822                	sd	s0,16(sp)
    80003aaa:	e426                	sd	s1,8(sp)
    80003aac:	e04a                	sd	s2,0(sp)
    80003aae:	1000                	addi	s0,sp,32
    80003ab0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ab2:	00850913          	addi	s2,a0,8
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	00003097          	auipc	ra,0x3
    80003abc:	91a080e7          	jalr	-1766(ra) # 800063d2 <acquire>
  while (lk->locked) {
    80003ac0:	409c                	lw	a5,0(s1)
    80003ac2:	cb89                	beqz	a5,80003ad4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ac4:	85ca                	mv	a1,s2
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	ffffe097          	auipc	ra,0xffffe
    80003acc:	c96080e7          	jalr	-874(ra) # 8000175e <sleep>
  while (lk->locked) {
    80003ad0:	409c                	lw	a5,0(s1)
    80003ad2:	fbed                	bnez	a5,80003ac4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ad4:	4785                	li	a5,1
    80003ad6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ad8:	ffffd097          	auipc	ra,0xffffd
    80003adc:	5ca080e7          	jalr	1482(ra) # 800010a2 <myproc>
    80003ae0:	591c                	lw	a5,48(a0)
    80003ae2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ae4:	854a                	mv	a0,s2
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	9a0080e7          	jalr	-1632(ra) # 80006486 <release>
}
    80003aee:	60e2                	ld	ra,24(sp)
    80003af0:	6442                	ld	s0,16(sp)
    80003af2:	64a2                	ld	s1,8(sp)
    80003af4:	6902                	ld	s2,0(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret

0000000080003afa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003afa:	1101                	addi	sp,sp,-32
    80003afc:	ec06                	sd	ra,24(sp)
    80003afe:	e822                	sd	s0,16(sp)
    80003b00:	e426                	sd	s1,8(sp)
    80003b02:	e04a                	sd	s2,0(sp)
    80003b04:	1000                	addi	s0,sp,32
    80003b06:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b08:	00850913          	addi	s2,a0,8
    80003b0c:	854a                	mv	a0,s2
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	8c4080e7          	jalr	-1852(ra) # 800063d2 <acquire>
  lk->locked = 0;
    80003b16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b1a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b1e:	8526                	mv	a0,s1
    80003b20:	ffffe097          	auipc	ra,0xffffe
    80003b24:	dca080e7          	jalr	-566(ra) # 800018ea <wakeup>
  release(&lk->lk);
    80003b28:	854a                	mv	a0,s2
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	95c080e7          	jalr	-1700(ra) # 80006486 <release>
}
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6902                	ld	s2,0(sp)
    80003b3a:	6105                	addi	sp,sp,32
    80003b3c:	8082                	ret

0000000080003b3e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b3e:	7179                	addi	sp,sp,-48
    80003b40:	f406                	sd	ra,40(sp)
    80003b42:	f022                	sd	s0,32(sp)
    80003b44:	ec26                	sd	s1,24(sp)
    80003b46:	e84a                	sd	s2,16(sp)
    80003b48:	e44e                	sd	s3,8(sp)
    80003b4a:	1800                	addi	s0,sp,48
    80003b4c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b4e:	00850913          	addi	s2,a0,8
    80003b52:	854a                	mv	a0,s2
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	87e080e7          	jalr	-1922(ra) # 800063d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b5c:	409c                	lw	a5,0(s1)
    80003b5e:	ef99                	bnez	a5,80003b7c <holdingsleep+0x3e>
    80003b60:	4481                	li	s1,0
  release(&lk->lk);
    80003b62:	854a                	mv	a0,s2
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	922080e7          	jalr	-1758(ra) # 80006486 <release>
  return r;
}
    80003b6c:	8526                	mv	a0,s1
    80003b6e:	70a2                	ld	ra,40(sp)
    80003b70:	7402                	ld	s0,32(sp)
    80003b72:	64e2                	ld	s1,24(sp)
    80003b74:	6942                	ld	s2,16(sp)
    80003b76:	69a2                	ld	s3,8(sp)
    80003b78:	6145                	addi	sp,sp,48
    80003b7a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b7c:	0284a983          	lw	s3,40(s1)
    80003b80:	ffffd097          	auipc	ra,0xffffd
    80003b84:	522080e7          	jalr	1314(ra) # 800010a2 <myproc>
    80003b88:	5904                	lw	s1,48(a0)
    80003b8a:	413484b3          	sub	s1,s1,s3
    80003b8e:	0014b493          	seqz	s1,s1
    80003b92:	bfc1                	j	80003b62 <holdingsleep+0x24>

0000000080003b94 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b94:	1141                	addi	sp,sp,-16
    80003b96:	e406                	sd	ra,8(sp)
    80003b98:	e022                	sd	s0,0(sp)
    80003b9a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b9c:	00005597          	auipc	a1,0x5
    80003ba0:	a9c58593          	addi	a1,a1,-1380 # 80008638 <syscalls+0x238>
    80003ba4:	00115517          	auipc	a0,0x115
    80003ba8:	5c450513          	addi	a0,a0,1476 # 80119168 <ftable>
    80003bac:	00002097          	auipc	ra,0x2
    80003bb0:	796080e7          	jalr	1942(ra) # 80006342 <initlock>
}
    80003bb4:	60a2                	ld	ra,8(sp)
    80003bb6:	6402                	ld	s0,0(sp)
    80003bb8:	0141                	addi	sp,sp,16
    80003bba:	8082                	ret

0000000080003bbc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bbc:	1101                	addi	sp,sp,-32
    80003bbe:	ec06                	sd	ra,24(sp)
    80003bc0:	e822                	sd	s0,16(sp)
    80003bc2:	e426                	sd	s1,8(sp)
    80003bc4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bc6:	00115517          	auipc	a0,0x115
    80003bca:	5a250513          	addi	a0,a0,1442 # 80119168 <ftable>
    80003bce:	00003097          	auipc	ra,0x3
    80003bd2:	804080e7          	jalr	-2044(ra) # 800063d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bd6:	00115497          	auipc	s1,0x115
    80003bda:	5aa48493          	addi	s1,s1,1450 # 80119180 <ftable+0x18>
    80003bde:	00116717          	auipc	a4,0x116
    80003be2:	54270713          	addi	a4,a4,1346 # 8011a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003be6:	40dc                	lw	a5,4(s1)
    80003be8:	cf99                	beqz	a5,80003c06 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bea:	02848493          	addi	s1,s1,40
    80003bee:	fee49ce3          	bne	s1,a4,80003be6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bf2:	00115517          	auipc	a0,0x115
    80003bf6:	57650513          	addi	a0,a0,1398 # 80119168 <ftable>
    80003bfa:	00003097          	auipc	ra,0x3
    80003bfe:	88c080e7          	jalr	-1908(ra) # 80006486 <release>
  return 0;
    80003c02:	4481                	li	s1,0
    80003c04:	a819                	j	80003c1a <filealloc+0x5e>
      f->ref = 1;
    80003c06:	4785                	li	a5,1
    80003c08:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c0a:	00115517          	auipc	a0,0x115
    80003c0e:	55e50513          	addi	a0,a0,1374 # 80119168 <ftable>
    80003c12:	00003097          	auipc	ra,0x3
    80003c16:	874080e7          	jalr	-1932(ra) # 80006486 <release>
}
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	60e2                	ld	ra,24(sp)
    80003c1e:	6442                	ld	s0,16(sp)
    80003c20:	64a2                	ld	s1,8(sp)
    80003c22:	6105                	addi	sp,sp,32
    80003c24:	8082                	ret

0000000080003c26 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c26:	1101                	addi	sp,sp,-32
    80003c28:	ec06                	sd	ra,24(sp)
    80003c2a:	e822                	sd	s0,16(sp)
    80003c2c:	e426                	sd	s1,8(sp)
    80003c2e:	1000                	addi	s0,sp,32
    80003c30:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c32:	00115517          	auipc	a0,0x115
    80003c36:	53650513          	addi	a0,a0,1334 # 80119168 <ftable>
    80003c3a:	00002097          	auipc	ra,0x2
    80003c3e:	798080e7          	jalr	1944(ra) # 800063d2 <acquire>
  if(f->ref < 1)
    80003c42:	40dc                	lw	a5,4(s1)
    80003c44:	02f05263          	blez	a5,80003c68 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c48:	2785                	addiw	a5,a5,1
    80003c4a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c4c:	00115517          	auipc	a0,0x115
    80003c50:	51c50513          	addi	a0,a0,1308 # 80119168 <ftable>
    80003c54:	00003097          	auipc	ra,0x3
    80003c58:	832080e7          	jalr	-1998(ra) # 80006486 <release>
  return f;
}
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	64a2                	ld	s1,8(sp)
    80003c64:	6105                	addi	sp,sp,32
    80003c66:	8082                	ret
    panic("filedup");
    80003c68:	00005517          	auipc	a0,0x5
    80003c6c:	9d850513          	addi	a0,a0,-1576 # 80008640 <syscalls+0x240>
    80003c70:	00002097          	auipc	ra,0x2
    80003c74:	218080e7          	jalr	536(ra) # 80005e88 <panic>

0000000080003c78 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c78:	7139                	addi	sp,sp,-64
    80003c7a:	fc06                	sd	ra,56(sp)
    80003c7c:	f822                	sd	s0,48(sp)
    80003c7e:	f426                	sd	s1,40(sp)
    80003c80:	f04a                	sd	s2,32(sp)
    80003c82:	ec4e                	sd	s3,24(sp)
    80003c84:	e852                	sd	s4,16(sp)
    80003c86:	e456                	sd	s5,8(sp)
    80003c88:	0080                	addi	s0,sp,64
    80003c8a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c8c:	00115517          	auipc	a0,0x115
    80003c90:	4dc50513          	addi	a0,a0,1244 # 80119168 <ftable>
    80003c94:	00002097          	auipc	ra,0x2
    80003c98:	73e080e7          	jalr	1854(ra) # 800063d2 <acquire>
  if(f->ref < 1)
    80003c9c:	40dc                	lw	a5,4(s1)
    80003c9e:	06f05163          	blez	a5,80003d00 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ca2:	37fd                	addiw	a5,a5,-1
    80003ca4:	0007871b          	sext.w	a4,a5
    80003ca8:	c0dc                	sw	a5,4(s1)
    80003caa:	06e04363          	bgtz	a4,80003d10 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cae:	0004a903          	lw	s2,0(s1)
    80003cb2:	0094ca83          	lbu	s5,9(s1)
    80003cb6:	0104ba03          	ld	s4,16(s1)
    80003cba:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cbe:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cc2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cc6:	00115517          	auipc	a0,0x115
    80003cca:	4a250513          	addi	a0,a0,1186 # 80119168 <ftable>
    80003cce:	00002097          	auipc	ra,0x2
    80003cd2:	7b8080e7          	jalr	1976(ra) # 80006486 <release>

  if(ff.type == FD_PIPE){
    80003cd6:	4785                	li	a5,1
    80003cd8:	04f90d63          	beq	s2,a5,80003d32 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cdc:	3979                	addiw	s2,s2,-2
    80003cde:	4785                	li	a5,1
    80003ce0:	0527e063          	bltu	a5,s2,80003d20 <fileclose+0xa8>
    begin_op();
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	ac8080e7          	jalr	-1336(ra) # 800037ac <begin_op>
    iput(ff.ip);
    80003cec:	854e                	mv	a0,s3
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	2a6080e7          	jalr	678(ra) # 80002f94 <iput>
    end_op();
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	b36080e7          	jalr	-1226(ra) # 8000382c <end_op>
    80003cfe:	a00d                	j	80003d20 <fileclose+0xa8>
    panic("fileclose");
    80003d00:	00005517          	auipc	a0,0x5
    80003d04:	94850513          	addi	a0,a0,-1720 # 80008648 <syscalls+0x248>
    80003d08:	00002097          	auipc	ra,0x2
    80003d0c:	180080e7          	jalr	384(ra) # 80005e88 <panic>
    release(&ftable.lock);
    80003d10:	00115517          	auipc	a0,0x115
    80003d14:	45850513          	addi	a0,a0,1112 # 80119168 <ftable>
    80003d18:	00002097          	auipc	ra,0x2
    80003d1c:	76e080e7          	jalr	1902(ra) # 80006486 <release>
  }
}
    80003d20:	70e2                	ld	ra,56(sp)
    80003d22:	7442                	ld	s0,48(sp)
    80003d24:	74a2                	ld	s1,40(sp)
    80003d26:	7902                	ld	s2,32(sp)
    80003d28:	69e2                	ld	s3,24(sp)
    80003d2a:	6a42                	ld	s4,16(sp)
    80003d2c:	6aa2                	ld	s5,8(sp)
    80003d2e:	6121                	addi	sp,sp,64
    80003d30:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d32:	85d6                	mv	a1,s5
    80003d34:	8552                	mv	a0,s4
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	34c080e7          	jalr	844(ra) # 80004082 <pipeclose>
    80003d3e:	b7cd                	j	80003d20 <fileclose+0xa8>

0000000080003d40 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d40:	715d                	addi	sp,sp,-80
    80003d42:	e486                	sd	ra,72(sp)
    80003d44:	e0a2                	sd	s0,64(sp)
    80003d46:	fc26                	sd	s1,56(sp)
    80003d48:	f84a                	sd	s2,48(sp)
    80003d4a:	f44e                	sd	s3,40(sp)
    80003d4c:	0880                	addi	s0,sp,80
    80003d4e:	84aa                	mv	s1,a0
    80003d50:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d52:	ffffd097          	auipc	ra,0xffffd
    80003d56:	350080e7          	jalr	848(ra) # 800010a2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d5a:	409c                	lw	a5,0(s1)
    80003d5c:	37f9                	addiw	a5,a5,-2
    80003d5e:	4705                	li	a4,1
    80003d60:	04f76763          	bltu	a4,a5,80003dae <filestat+0x6e>
    80003d64:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d66:	6c88                	ld	a0,24(s1)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	072080e7          	jalr	114(ra) # 80002dda <ilock>
    stati(f->ip, &st);
    80003d70:	fb840593          	addi	a1,s0,-72
    80003d74:	6c88                	ld	a0,24(s1)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	2ee080e7          	jalr	750(ra) # 80003064 <stati>
    iunlock(f->ip);
    80003d7e:	6c88                	ld	a0,24(s1)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	11c080e7          	jalr	284(ra) # 80002e9c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d88:	46e1                	li	a3,24
    80003d8a:	fb840613          	addi	a2,s0,-72
    80003d8e:	85ce                	mv	a1,s3
    80003d90:	05093503          	ld	a0,80(s2)
    80003d94:	ffffd097          	auipc	ra,0xffffd
    80003d98:	fb2080e7          	jalr	-78(ra) # 80000d46 <copyout>
    80003d9c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003da0:	60a6                	ld	ra,72(sp)
    80003da2:	6406                	ld	s0,64(sp)
    80003da4:	74e2                	ld	s1,56(sp)
    80003da6:	7942                	ld	s2,48(sp)
    80003da8:	79a2                	ld	s3,40(sp)
    80003daa:	6161                	addi	sp,sp,80
    80003dac:	8082                	ret
  return -1;
    80003dae:	557d                	li	a0,-1
    80003db0:	bfc5                	j	80003da0 <filestat+0x60>

0000000080003db2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003db2:	7179                	addi	sp,sp,-48
    80003db4:	f406                	sd	ra,40(sp)
    80003db6:	f022                	sd	s0,32(sp)
    80003db8:	ec26                	sd	s1,24(sp)
    80003dba:	e84a                	sd	s2,16(sp)
    80003dbc:	e44e                	sd	s3,8(sp)
    80003dbe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dc0:	00854783          	lbu	a5,8(a0)
    80003dc4:	c3d5                	beqz	a5,80003e68 <fileread+0xb6>
    80003dc6:	84aa                	mv	s1,a0
    80003dc8:	89ae                	mv	s3,a1
    80003dca:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dcc:	411c                	lw	a5,0(a0)
    80003dce:	4705                	li	a4,1
    80003dd0:	04e78963          	beq	a5,a4,80003e22 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd4:	470d                	li	a4,3
    80003dd6:	04e78d63          	beq	a5,a4,80003e30 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dda:	4709                	li	a4,2
    80003ddc:	06e79e63          	bne	a5,a4,80003e58 <fileread+0xa6>
    ilock(f->ip);
    80003de0:	6d08                	ld	a0,24(a0)
    80003de2:	fffff097          	auipc	ra,0xfffff
    80003de6:	ff8080e7          	jalr	-8(ra) # 80002dda <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dea:	874a                	mv	a4,s2
    80003dec:	5094                	lw	a3,32(s1)
    80003dee:	864e                	mv	a2,s3
    80003df0:	4585                	li	a1,1
    80003df2:	6c88                	ld	a0,24(s1)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	29a080e7          	jalr	666(ra) # 8000308e <readi>
    80003dfc:	892a                	mv	s2,a0
    80003dfe:	00a05563          	blez	a0,80003e08 <fileread+0x56>
      f->off += r;
    80003e02:	509c                	lw	a5,32(s1)
    80003e04:	9fa9                	addw	a5,a5,a0
    80003e06:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e08:	6c88                	ld	a0,24(s1)
    80003e0a:	fffff097          	auipc	ra,0xfffff
    80003e0e:	092080e7          	jalr	146(ra) # 80002e9c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e12:	854a                	mv	a0,s2
    80003e14:	70a2                	ld	ra,40(sp)
    80003e16:	7402                	ld	s0,32(sp)
    80003e18:	64e2                	ld	s1,24(sp)
    80003e1a:	6942                	ld	s2,16(sp)
    80003e1c:	69a2                	ld	s3,8(sp)
    80003e1e:	6145                	addi	sp,sp,48
    80003e20:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e22:	6908                	ld	a0,16(a0)
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	3c8080e7          	jalr	968(ra) # 800041ec <piperead>
    80003e2c:	892a                	mv	s2,a0
    80003e2e:	b7d5                	j	80003e12 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e30:	02451783          	lh	a5,36(a0)
    80003e34:	03079693          	slli	a3,a5,0x30
    80003e38:	92c1                	srli	a3,a3,0x30
    80003e3a:	4725                	li	a4,9
    80003e3c:	02d76863          	bltu	a4,a3,80003e6c <fileread+0xba>
    80003e40:	0792                	slli	a5,a5,0x4
    80003e42:	00115717          	auipc	a4,0x115
    80003e46:	28670713          	addi	a4,a4,646 # 801190c8 <devsw>
    80003e4a:	97ba                	add	a5,a5,a4
    80003e4c:	639c                	ld	a5,0(a5)
    80003e4e:	c38d                	beqz	a5,80003e70 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e50:	4505                	li	a0,1
    80003e52:	9782                	jalr	a5
    80003e54:	892a                	mv	s2,a0
    80003e56:	bf75                	j	80003e12 <fileread+0x60>
    panic("fileread");
    80003e58:	00005517          	auipc	a0,0x5
    80003e5c:	80050513          	addi	a0,a0,-2048 # 80008658 <syscalls+0x258>
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	028080e7          	jalr	40(ra) # 80005e88 <panic>
    return -1;
    80003e68:	597d                	li	s2,-1
    80003e6a:	b765                	j	80003e12 <fileread+0x60>
      return -1;
    80003e6c:	597d                	li	s2,-1
    80003e6e:	b755                	j	80003e12 <fileread+0x60>
    80003e70:	597d                	li	s2,-1
    80003e72:	b745                	j	80003e12 <fileread+0x60>

0000000080003e74 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e74:	715d                	addi	sp,sp,-80
    80003e76:	e486                	sd	ra,72(sp)
    80003e78:	e0a2                	sd	s0,64(sp)
    80003e7a:	fc26                	sd	s1,56(sp)
    80003e7c:	f84a                	sd	s2,48(sp)
    80003e7e:	f44e                	sd	s3,40(sp)
    80003e80:	f052                	sd	s4,32(sp)
    80003e82:	ec56                	sd	s5,24(sp)
    80003e84:	e85a                	sd	s6,16(sp)
    80003e86:	e45e                	sd	s7,8(sp)
    80003e88:	e062                	sd	s8,0(sp)
    80003e8a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e8c:	00954783          	lbu	a5,9(a0)
    80003e90:	10078663          	beqz	a5,80003f9c <filewrite+0x128>
    80003e94:	892a                	mv	s2,a0
    80003e96:	8aae                	mv	s5,a1
    80003e98:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e9a:	411c                	lw	a5,0(a0)
    80003e9c:	4705                	li	a4,1
    80003e9e:	02e78263          	beq	a5,a4,80003ec2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ea2:	470d                	li	a4,3
    80003ea4:	02e78663          	beq	a5,a4,80003ed0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ea8:	4709                	li	a4,2
    80003eaa:	0ee79163          	bne	a5,a4,80003f8c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003eae:	0ac05d63          	blez	a2,80003f68 <filewrite+0xf4>
    int i = 0;
    80003eb2:	4981                	li	s3,0
    80003eb4:	6b05                	lui	s6,0x1
    80003eb6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003eba:	6b85                	lui	s7,0x1
    80003ebc:	c00b8b9b          	addiw	s7,s7,-1024
    80003ec0:	a861                	j	80003f58 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ec2:	6908                	ld	a0,16(a0)
    80003ec4:	00000097          	auipc	ra,0x0
    80003ec8:	22e080e7          	jalr	558(ra) # 800040f2 <pipewrite>
    80003ecc:	8a2a                	mv	s4,a0
    80003ece:	a045                	j	80003f6e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ed0:	02451783          	lh	a5,36(a0)
    80003ed4:	03079693          	slli	a3,a5,0x30
    80003ed8:	92c1                	srli	a3,a3,0x30
    80003eda:	4725                	li	a4,9
    80003edc:	0cd76263          	bltu	a4,a3,80003fa0 <filewrite+0x12c>
    80003ee0:	0792                	slli	a5,a5,0x4
    80003ee2:	00115717          	auipc	a4,0x115
    80003ee6:	1e670713          	addi	a4,a4,486 # 801190c8 <devsw>
    80003eea:	97ba                	add	a5,a5,a4
    80003eec:	679c                	ld	a5,8(a5)
    80003eee:	cbdd                	beqz	a5,80003fa4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ef0:	4505                	li	a0,1
    80003ef2:	9782                	jalr	a5
    80003ef4:	8a2a                	mv	s4,a0
    80003ef6:	a8a5                	j	80003f6e <filewrite+0xfa>
    80003ef8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	8b0080e7          	jalr	-1872(ra) # 800037ac <begin_op>
      ilock(f->ip);
    80003f04:	01893503          	ld	a0,24(s2)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	ed2080e7          	jalr	-302(ra) # 80002dda <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f10:	8762                	mv	a4,s8
    80003f12:	02092683          	lw	a3,32(s2)
    80003f16:	01598633          	add	a2,s3,s5
    80003f1a:	4585                	li	a1,1
    80003f1c:	01893503          	ld	a0,24(s2)
    80003f20:	fffff097          	auipc	ra,0xfffff
    80003f24:	266080e7          	jalr	614(ra) # 80003186 <writei>
    80003f28:	84aa                	mv	s1,a0
    80003f2a:	00a05763          	blez	a0,80003f38 <filewrite+0xc4>
        f->off += r;
    80003f2e:	02092783          	lw	a5,32(s2)
    80003f32:	9fa9                	addw	a5,a5,a0
    80003f34:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f38:	01893503          	ld	a0,24(s2)
    80003f3c:	fffff097          	auipc	ra,0xfffff
    80003f40:	f60080e7          	jalr	-160(ra) # 80002e9c <iunlock>
      end_op();
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	8e8080e7          	jalr	-1816(ra) # 8000382c <end_op>

      if(r != n1){
    80003f4c:	009c1f63          	bne	s8,s1,80003f6a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f50:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f54:	0149db63          	bge	s3,s4,80003f6a <filewrite+0xf6>
      int n1 = n - i;
    80003f58:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f5c:	84be                	mv	s1,a5
    80003f5e:	2781                	sext.w	a5,a5
    80003f60:	f8fb5ce3          	bge	s6,a5,80003ef8 <filewrite+0x84>
    80003f64:	84de                	mv	s1,s7
    80003f66:	bf49                	j	80003ef8 <filewrite+0x84>
    int i = 0;
    80003f68:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f6a:	013a1f63          	bne	s4,s3,80003f88 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f6e:	8552                	mv	a0,s4
    80003f70:	60a6                	ld	ra,72(sp)
    80003f72:	6406                	ld	s0,64(sp)
    80003f74:	74e2                	ld	s1,56(sp)
    80003f76:	7942                	ld	s2,48(sp)
    80003f78:	79a2                	ld	s3,40(sp)
    80003f7a:	7a02                	ld	s4,32(sp)
    80003f7c:	6ae2                	ld	s5,24(sp)
    80003f7e:	6b42                	ld	s6,16(sp)
    80003f80:	6ba2                	ld	s7,8(sp)
    80003f82:	6c02                	ld	s8,0(sp)
    80003f84:	6161                	addi	sp,sp,80
    80003f86:	8082                	ret
    ret = (i == n ? n : -1);
    80003f88:	5a7d                	li	s4,-1
    80003f8a:	b7d5                	j	80003f6e <filewrite+0xfa>
    panic("filewrite");
    80003f8c:	00004517          	auipc	a0,0x4
    80003f90:	6dc50513          	addi	a0,a0,1756 # 80008668 <syscalls+0x268>
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	ef4080e7          	jalr	-268(ra) # 80005e88 <panic>
    return -1;
    80003f9c:	5a7d                	li	s4,-1
    80003f9e:	bfc1                	j	80003f6e <filewrite+0xfa>
      return -1;
    80003fa0:	5a7d                	li	s4,-1
    80003fa2:	b7f1                	j	80003f6e <filewrite+0xfa>
    80003fa4:	5a7d                	li	s4,-1
    80003fa6:	b7e1                	j	80003f6e <filewrite+0xfa>

0000000080003fa8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fa8:	7179                	addi	sp,sp,-48
    80003faa:	f406                	sd	ra,40(sp)
    80003fac:	f022                	sd	s0,32(sp)
    80003fae:	ec26                	sd	s1,24(sp)
    80003fb0:	e84a                	sd	s2,16(sp)
    80003fb2:	e44e                	sd	s3,8(sp)
    80003fb4:	e052                	sd	s4,0(sp)
    80003fb6:	1800                	addi	s0,sp,48
    80003fb8:	84aa                	mv	s1,a0
    80003fba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fbc:	0005b023          	sd	zero,0(a1)
    80003fc0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	bf8080e7          	jalr	-1032(ra) # 80003bbc <filealloc>
    80003fcc:	e088                	sd	a0,0(s1)
    80003fce:	c551                	beqz	a0,8000405a <pipealloc+0xb2>
    80003fd0:	00000097          	auipc	ra,0x0
    80003fd4:	bec080e7          	jalr	-1044(ra) # 80003bbc <filealloc>
    80003fd8:	00aa3023          	sd	a0,0(s4)
    80003fdc:	c92d                	beqz	a0,8000404e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fde:	ffffc097          	auipc	ra,0xffffc
    80003fe2:	238080e7          	jalr	568(ra) # 80000216 <kalloc>
    80003fe6:	892a                	mv	s2,a0
    80003fe8:	c125                	beqz	a0,80004048 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fea:	4985                	li	s3,1
    80003fec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ff0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ff4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ff8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ffc:	00004597          	auipc	a1,0x4
    80004000:	67c58593          	addi	a1,a1,1660 # 80008678 <syscalls+0x278>
    80004004:	00002097          	auipc	ra,0x2
    80004008:	33e080e7          	jalr	830(ra) # 80006342 <initlock>
  (*f0)->type = FD_PIPE;
    8000400c:	609c                	ld	a5,0(s1)
    8000400e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004012:	609c                	ld	a5,0(s1)
    80004014:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004018:	609c                	ld	a5,0(s1)
    8000401a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000401e:	609c                	ld	a5,0(s1)
    80004020:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004024:	000a3783          	ld	a5,0(s4)
    80004028:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000402c:	000a3783          	ld	a5,0(s4)
    80004030:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004034:	000a3783          	ld	a5,0(s4)
    80004038:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000403c:	000a3783          	ld	a5,0(s4)
    80004040:	0127b823          	sd	s2,16(a5)
  return 0;
    80004044:	4501                	li	a0,0
    80004046:	a025                	j	8000406e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004048:	6088                	ld	a0,0(s1)
    8000404a:	e501                	bnez	a0,80004052 <pipealloc+0xaa>
    8000404c:	a039                	j	8000405a <pipealloc+0xb2>
    8000404e:	6088                	ld	a0,0(s1)
    80004050:	c51d                	beqz	a0,8000407e <pipealloc+0xd6>
    fileclose(*f0);
    80004052:	00000097          	auipc	ra,0x0
    80004056:	c26080e7          	jalr	-986(ra) # 80003c78 <fileclose>
  if(*f1)
    8000405a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000405e:	557d                	li	a0,-1
  if(*f1)
    80004060:	c799                	beqz	a5,8000406e <pipealloc+0xc6>
    fileclose(*f1);
    80004062:	853e                	mv	a0,a5
    80004064:	00000097          	auipc	ra,0x0
    80004068:	c14080e7          	jalr	-1004(ra) # 80003c78 <fileclose>
  return -1;
    8000406c:	557d                	li	a0,-1
}
    8000406e:	70a2                	ld	ra,40(sp)
    80004070:	7402                	ld	s0,32(sp)
    80004072:	64e2                	ld	s1,24(sp)
    80004074:	6942                	ld	s2,16(sp)
    80004076:	69a2                	ld	s3,8(sp)
    80004078:	6a02                	ld	s4,0(sp)
    8000407a:	6145                	addi	sp,sp,48
    8000407c:	8082                	ret
  return -1;
    8000407e:	557d                	li	a0,-1
    80004080:	b7fd                	j	8000406e <pipealloc+0xc6>

0000000080004082 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004082:	1101                	addi	sp,sp,-32
    80004084:	ec06                	sd	ra,24(sp)
    80004086:	e822                	sd	s0,16(sp)
    80004088:	e426                	sd	s1,8(sp)
    8000408a:	e04a                	sd	s2,0(sp)
    8000408c:	1000                	addi	s0,sp,32
    8000408e:	84aa                	mv	s1,a0
    80004090:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004092:	00002097          	auipc	ra,0x2
    80004096:	340080e7          	jalr	832(ra) # 800063d2 <acquire>
  if(writable){
    8000409a:	02090d63          	beqz	s2,800040d4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000409e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040a2:	21848513          	addi	a0,s1,536
    800040a6:	ffffe097          	auipc	ra,0xffffe
    800040aa:	844080e7          	jalr	-1980(ra) # 800018ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040ae:	2204b783          	ld	a5,544(s1)
    800040b2:	eb95                	bnez	a5,800040e6 <pipeclose+0x64>
    release(&pi->lock);
    800040b4:	8526                	mv	a0,s1
    800040b6:	00002097          	auipc	ra,0x2
    800040ba:	3d0080e7          	jalr	976(ra) # 80006486 <release>
    kfree((char*)pi);
    800040be:	8526                	mv	a0,s1
    800040c0:	ffffc097          	auipc	ra,0xffffc
    800040c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040c8:	60e2                	ld	ra,24(sp)
    800040ca:	6442                	ld	s0,16(sp)
    800040cc:	64a2                	ld	s1,8(sp)
    800040ce:	6902                	ld	s2,0(sp)
    800040d0:	6105                	addi	sp,sp,32
    800040d2:	8082                	ret
    pi->readopen = 0;
    800040d4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040d8:	21c48513          	addi	a0,s1,540
    800040dc:	ffffe097          	auipc	ra,0xffffe
    800040e0:	80e080e7          	jalr	-2034(ra) # 800018ea <wakeup>
    800040e4:	b7e9                	j	800040ae <pipeclose+0x2c>
    release(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	39e080e7          	jalr	926(ra) # 80006486 <release>
}
    800040f0:	bfe1                	j	800040c8 <pipeclose+0x46>

00000000800040f2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040f2:	7159                	addi	sp,sp,-112
    800040f4:	f486                	sd	ra,104(sp)
    800040f6:	f0a2                	sd	s0,96(sp)
    800040f8:	eca6                	sd	s1,88(sp)
    800040fa:	e8ca                	sd	s2,80(sp)
    800040fc:	e4ce                	sd	s3,72(sp)
    800040fe:	e0d2                	sd	s4,64(sp)
    80004100:	fc56                	sd	s5,56(sp)
    80004102:	f85a                	sd	s6,48(sp)
    80004104:	f45e                	sd	s7,40(sp)
    80004106:	f062                	sd	s8,32(sp)
    80004108:	ec66                	sd	s9,24(sp)
    8000410a:	1880                	addi	s0,sp,112
    8000410c:	84aa                	mv	s1,a0
    8000410e:	8aae                	mv	s5,a1
    80004110:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	f90080e7          	jalr	-112(ra) # 800010a2 <myproc>
    8000411a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000411c:	8526                	mv	a0,s1
    8000411e:	00002097          	auipc	ra,0x2
    80004122:	2b4080e7          	jalr	692(ra) # 800063d2 <acquire>
  while(i < n){
    80004126:	0d405163          	blez	s4,800041e8 <pipewrite+0xf6>
    8000412a:	8ba6                	mv	s7,s1
  int i = 0;
    8000412c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000412e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004130:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004134:	21c48c13          	addi	s8,s1,540
    80004138:	a08d                	j	8000419a <pipewrite+0xa8>
      release(&pi->lock);
    8000413a:	8526                	mv	a0,s1
    8000413c:	00002097          	auipc	ra,0x2
    80004140:	34a080e7          	jalr	842(ra) # 80006486 <release>
      return -1;
    80004144:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004146:	854a                	mv	a0,s2
    80004148:	70a6                	ld	ra,104(sp)
    8000414a:	7406                	ld	s0,96(sp)
    8000414c:	64e6                	ld	s1,88(sp)
    8000414e:	6946                	ld	s2,80(sp)
    80004150:	69a6                	ld	s3,72(sp)
    80004152:	6a06                	ld	s4,64(sp)
    80004154:	7ae2                	ld	s5,56(sp)
    80004156:	7b42                	ld	s6,48(sp)
    80004158:	7ba2                	ld	s7,40(sp)
    8000415a:	7c02                	ld	s8,32(sp)
    8000415c:	6ce2                	ld	s9,24(sp)
    8000415e:	6165                	addi	sp,sp,112
    80004160:	8082                	ret
      wakeup(&pi->nread);
    80004162:	8566                	mv	a0,s9
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	786080e7          	jalr	1926(ra) # 800018ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000416c:	85de                	mv	a1,s7
    8000416e:	8562                	mv	a0,s8
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	5ee080e7          	jalr	1518(ra) # 8000175e <sleep>
    80004178:	a839                	j	80004196 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000417a:	21c4a783          	lw	a5,540(s1)
    8000417e:	0017871b          	addiw	a4,a5,1
    80004182:	20e4ae23          	sw	a4,540(s1)
    80004186:	1ff7f793          	andi	a5,a5,511
    8000418a:	97a6                	add	a5,a5,s1
    8000418c:	f9f44703          	lbu	a4,-97(s0)
    80004190:	00e78c23          	sb	a4,24(a5)
      i++;
    80004194:	2905                	addiw	s2,s2,1
  while(i < n){
    80004196:	03495d63          	bge	s2,s4,800041d0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000419a:	2204a783          	lw	a5,544(s1)
    8000419e:	dfd1                	beqz	a5,8000413a <pipewrite+0x48>
    800041a0:	0289a783          	lw	a5,40(s3)
    800041a4:	fbd9                	bnez	a5,8000413a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041a6:	2184a783          	lw	a5,536(s1)
    800041aa:	21c4a703          	lw	a4,540(s1)
    800041ae:	2007879b          	addiw	a5,a5,512
    800041b2:	faf708e3          	beq	a4,a5,80004162 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b6:	4685                	li	a3,1
    800041b8:	01590633          	add	a2,s2,s5
    800041bc:	f9f40593          	addi	a1,s0,-97
    800041c0:	0509b503          	ld	a0,80(s3)
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	c2c080e7          	jalr	-980(ra) # 80000df0 <copyin>
    800041cc:	fb6517e3          	bne	a0,s6,8000417a <pipewrite+0x88>
  wakeup(&pi->nread);
    800041d0:	21848513          	addi	a0,s1,536
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	716080e7          	jalr	1814(ra) # 800018ea <wakeup>
  release(&pi->lock);
    800041dc:	8526                	mv	a0,s1
    800041de:	00002097          	auipc	ra,0x2
    800041e2:	2a8080e7          	jalr	680(ra) # 80006486 <release>
  return i;
    800041e6:	b785                	j	80004146 <pipewrite+0x54>
  int i = 0;
    800041e8:	4901                	li	s2,0
    800041ea:	b7dd                	j	800041d0 <pipewrite+0xde>

00000000800041ec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041ec:	715d                	addi	sp,sp,-80
    800041ee:	e486                	sd	ra,72(sp)
    800041f0:	e0a2                	sd	s0,64(sp)
    800041f2:	fc26                	sd	s1,56(sp)
    800041f4:	f84a                	sd	s2,48(sp)
    800041f6:	f44e                	sd	s3,40(sp)
    800041f8:	f052                	sd	s4,32(sp)
    800041fa:	ec56                	sd	s5,24(sp)
    800041fc:	e85a                	sd	s6,16(sp)
    800041fe:	0880                	addi	s0,sp,80
    80004200:	84aa                	mv	s1,a0
    80004202:	892e                	mv	s2,a1
    80004204:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	e9c080e7          	jalr	-356(ra) # 800010a2 <myproc>
    8000420e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004210:	8b26                	mv	s6,s1
    80004212:	8526                	mv	a0,s1
    80004214:	00002097          	auipc	ra,0x2
    80004218:	1be080e7          	jalr	446(ra) # 800063d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000421c:	2184a703          	lw	a4,536(s1)
    80004220:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004224:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004228:	02f71463          	bne	a4,a5,80004250 <piperead+0x64>
    8000422c:	2244a783          	lw	a5,548(s1)
    80004230:	c385                	beqz	a5,80004250 <piperead+0x64>
    if(pr->killed){
    80004232:	028a2783          	lw	a5,40(s4)
    80004236:	ebc1                	bnez	a5,800042c6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004238:	85da                	mv	a1,s6
    8000423a:	854e                	mv	a0,s3
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	522080e7          	jalr	1314(ra) # 8000175e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004244:	2184a703          	lw	a4,536(s1)
    80004248:	21c4a783          	lw	a5,540(s1)
    8000424c:	fef700e3          	beq	a4,a5,8000422c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004250:	09505263          	blez	s5,800042d4 <piperead+0xe8>
    80004254:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004256:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004258:	2184a783          	lw	a5,536(s1)
    8000425c:	21c4a703          	lw	a4,540(s1)
    80004260:	02f70d63          	beq	a4,a5,8000429a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004264:	0017871b          	addiw	a4,a5,1
    80004268:	20e4ac23          	sw	a4,536(s1)
    8000426c:	1ff7f793          	andi	a5,a5,511
    80004270:	97a6                	add	a5,a5,s1
    80004272:	0187c783          	lbu	a5,24(a5)
    80004276:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000427a:	4685                	li	a3,1
    8000427c:	fbf40613          	addi	a2,s0,-65
    80004280:	85ca                	mv	a1,s2
    80004282:	050a3503          	ld	a0,80(s4)
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	ac0080e7          	jalr	-1344(ra) # 80000d46 <copyout>
    8000428e:	01650663          	beq	a0,s6,8000429a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004292:	2985                	addiw	s3,s3,1
    80004294:	0905                	addi	s2,s2,1
    80004296:	fd3a91e3          	bne	s5,s3,80004258 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000429a:	21c48513          	addi	a0,s1,540
    8000429e:	ffffd097          	auipc	ra,0xffffd
    800042a2:	64c080e7          	jalr	1612(ra) # 800018ea <wakeup>
  release(&pi->lock);
    800042a6:	8526                	mv	a0,s1
    800042a8:	00002097          	auipc	ra,0x2
    800042ac:	1de080e7          	jalr	478(ra) # 80006486 <release>
  return i;
}
    800042b0:	854e                	mv	a0,s3
    800042b2:	60a6                	ld	ra,72(sp)
    800042b4:	6406                	ld	s0,64(sp)
    800042b6:	74e2                	ld	s1,56(sp)
    800042b8:	7942                	ld	s2,48(sp)
    800042ba:	79a2                	ld	s3,40(sp)
    800042bc:	7a02                	ld	s4,32(sp)
    800042be:	6ae2                	ld	s5,24(sp)
    800042c0:	6b42                	ld	s6,16(sp)
    800042c2:	6161                	addi	sp,sp,80
    800042c4:	8082                	ret
      release(&pi->lock);
    800042c6:	8526                	mv	a0,s1
    800042c8:	00002097          	auipc	ra,0x2
    800042cc:	1be080e7          	jalr	446(ra) # 80006486 <release>
      return -1;
    800042d0:	59fd                	li	s3,-1
    800042d2:	bff9                	j	800042b0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042d4:	4981                	li	s3,0
    800042d6:	b7d1                	j	8000429a <piperead+0xae>

00000000800042d8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042d8:	df010113          	addi	sp,sp,-528
    800042dc:	20113423          	sd	ra,520(sp)
    800042e0:	20813023          	sd	s0,512(sp)
    800042e4:	ffa6                	sd	s1,504(sp)
    800042e6:	fbca                	sd	s2,496(sp)
    800042e8:	f7ce                	sd	s3,488(sp)
    800042ea:	f3d2                	sd	s4,480(sp)
    800042ec:	efd6                	sd	s5,472(sp)
    800042ee:	ebda                	sd	s6,464(sp)
    800042f0:	e7de                	sd	s7,456(sp)
    800042f2:	e3e2                	sd	s8,448(sp)
    800042f4:	ff66                	sd	s9,440(sp)
    800042f6:	fb6a                	sd	s10,432(sp)
    800042f8:	f76e                	sd	s11,424(sp)
    800042fa:	0c00                	addi	s0,sp,528
    800042fc:	84aa                	mv	s1,a0
    800042fe:	dea43c23          	sd	a0,-520(s0)
    80004302:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	d9c080e7          	jalr	-612(ra) # 800010a2 <myproc>
    8000430e:	892a                	mv	s2,a0

  begin_op();
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	49c080e7          	jalr	1180(ra) # 800037ac <begin_op>

  if((ip = namei(path)) == 0){
    80004318:	8526                	mv	a0,s1
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	276080e7          	jalr	630(ra) # 80003590 <namei>
    80004322:	c92d                	beqz	a0,80004394 <exec+0xbc>
    80004324:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	ab4080e7          	jalr	-1356(ra) # 80002dda <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000432e:	04000713          	li	a4,64
    80004332:	4681                	li	a3,0
    80004334:	e5040613          	addi	a2,s0,-432
    80004338:	4581                	li	a1,0
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	d52080e7          	jalr	-686(ra) # 8000308e <readi>
    80004344:	04000793          	li	a5,64
    80004348:	00f51a63          	bne	a0,a5,8000435c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000434c:	e5042703          	lw	a4,-432(s0)
    80004350:	464c47b7          	lui	a5,0x464c4
    80004354:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004358:	04f70463          	beq	a4,a5,800043a0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000435c:	8526                	mv	a0,s1
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	cde080e7          	jalr	-802(ra) # 8000303c <iunlockput>
    end_op();
    80004366:	fffff097          	auipc	ra,0xfffff
    8000436a:	4c6080e7          	jalr	1222(ra) # 8000382c <end_op>
  }
  return -1;
    8000436e:	557d                	li	a0,-1
}
    80004370:	20813083          	ld	ra,520(sp)
    80004374:	20013403          	ld	s0,512(sp)
    80004378:	74fe                	ld	s1,504(sp)
    8000437a:	795e                	ld	s2,496(sp)
    8000437c:	79be                	ld	s3,488(sp)
    8000437e:	7a1e                	ld	s4,480(sp)
    80004380:	6afe                	ld	s5,472(sp)
    80004382:	6b5e                	ld	s6,464(sp)
    80004384:	6bbe                	ld	s7,456(sp)
    80004386:	6c1e                	ld	s8,448(sp)
    80004388:	7cfa                	ld	s9,440(sp)
    8000438a:	7d5a                	ld	s10,432(sp)
    8000438c:	7dba                	ld	s11,424(sp)
    8000438e:	21010113          	addi	sp,sp,528
    80004392:	8082                	ret
    end_op();
    80004394:	fffff097          	auipc	ra,0xfffff
    80004398:	498080e7          	jalr	1176(ra) # 8000382c <end_op>
    return -1;
    8000439c:	557d                	li	a0,-1
    8000439e:	bfc9                	j	80004370 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043a0:	854a                	mv	a0,s2
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	dc4080e7          	jalr	-572(ra) # 80001166 <proc_pagetable>
    800043aa:	8baa                	mv	s7,a0
    800043ac:	d945                	beqz	a0,8000435c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ae:	e7042983          	lw	s3,-400(s0)
    800043b2:	e8845783          	lhu	a5,-376(s0)
    800043b6:	c7ad                	beqz	a5,80004420 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ba:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800043bc:	6c85                	lui	s9,0x1
    800043be:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043c2:	def43823          	sd	a5,-528(s0)
    800043c6:	a42d                	j	800045f0 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043c8:	00004517          	auipc	a0,0x4
    800043cc:	2b850513          	addi	a0,a0,696 # 80008680 <syscalls+0x280>
    800043d0:	00002097          	auipc	ra,0x2
    800043d4:	ab8080e7          	jalr	-1352(ra) # 80005e88 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043d8:	8756                	mv	a4,s5
    800043da:	012d86bb          	addw	a3,s11,s2
    800043de:	4581                	li	a1,0
    800043e0:	8526                	mv	a0,s1
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	cac080e7          	jalr	-852(ra) # 8000308e <readi>
    800043ea:	2501                	sext.w	a0,a0
    800043ec:	1aaa9963          	bne	s5,a0,8000459e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800043f0:	6785                	lui	a5,0x1
    800043f2:	0127893b          	addw	s2,a5,s2
    800043f6:	77fd                	lui	a5,0xfffff
    800043f8:	01478a3b          	addw	s4,a5,s4
    800043fc:	1f897163          	bgeu	s2,s8,800045de <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004400:	02091593          	slli	a1,s2,0x20
    80004404:	9181                	srli	a1,a1,0x20
    80004406:	95ea                	add	a1,a1,s10
    80004408:	855e                	mv	a0,s7
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	32a080e7          	jalr	810(ra) # 80000734 <walkaddr>
    80004412:	862a                	mv	a2,a0
    if(pa == 0)
    80004414:	d955                	beqz	a0,800043c8 <exec+0xf0>
      n = PGSIZE;
    80004416:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004418:	fd9a70e3          	bgeu	s4,s9,800043d8 <exec+0x100>
      n = sz - i;
    8000441c:	8ad2                	mv	s5,s4
    8000441e:	bf6d                	j	800043d8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004420:	4901                	li	s2,0
  iunlockput(ip);
    80004422:	8526                	mv	a0,s1
    80004424:	fffff097          	auipc	ra,0xfffff
    80004428:	c18080e7          	jalr	-1000(ra) # 8000303c <iunlockput>
  end_op();
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	400080e7          	jalr	1024(ra) # 8000382c <end_op>
  p = myproc();
    80004434:	ffffd097          	auipc	ra,0xffffd
    80004438:	c6e080e7          	jalr	-914(ra) # 800010a2 <myproc>
    8000443c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000443e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004442:	6785                	lui	a5,0x1
    80004444:	17fd                	addi	a5,a5,-1
    80004446:	993e                	add	s2,s2,a5
    80004448:	757d                	lui	a0,0xfffff
    8000444a:	00a977b3          	and	a5,s2,a0
    8000444e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004452:	6609                	lui	a2,0x2
    80004454:	963e                	add	a2,a2,a5
    80004456:	85be                	mv	a1,a5
    80004458:	855e                	mv	a0,s7
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	69a080e7          	jalr	1690(ra) # 80000af4 <uvmalloc>
    80004462:	8b2a                	mv	s6,a0
  ip = 0;
    80004464:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004466:	12050c63          	beqz	a0,8000459e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000446a:	75f9                	lui	a1,0xffffe
    8000446c:	95aa                	add	a1,a1,a0
    8000446e:	855e                	mv	a0,s7
    80004470:	ffffd097          	auipc	ra,0xffffd
    80004474:	8a4080e7          	jalr	-1884(ra) # 80000d14 <uvmclear>
  stackbase = sp - PGSIZE;
    80004478:	7c7d                	lui	s8,0xfffff
    8000447a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000447c:	e0043783          	ld	a5,-512(s0)
    80004480:	6388                	ld	a0,0(a5)
    80004482:	c535                	beqz	a0,800044ee <exec+0x216>
    80004484:	e9040993          	addi	s3,s0,-368
    80004488:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000448c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	09c080e7          	jalr	156(ra) # 8000052a <strlen>
    80004496:	2505                	addiw	a0,a0,1
    80004498:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000449c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800044a0:	13896363          	bltu	s2,s8,800045c6 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044a4:	e0043d83          	ld	s11,-512(s0)
    800044a8:	000dba03          	ld	s4,0(s11)
    800044ac:	8552                	mv	a0,s4
    800044ae:	ffffc097          	auipc	ra,0xffffc
    800044b2:	07c080e7          	jalr	124(ra) # 8000052a <strlen>
    800044b6:	0015069b          	addiw	a3,a0,1
    800044ba:	8652                	mv	a2,s4
    800044bc:	85ca                	mv	a1,s2
    800044be:	855e                	mv	a0,s7
    800044c0:	ffffd097          	auipc	ra,0xffffd
    800044c4:	886080e7          	jalr	-1914(ra) # 80000d46 <copyout>
    800044c8:	10054363          	bltz	a0,800045ce <exec+0x2f6>
    ustack[argc] = sp;
    800044cc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044d0:	0485                	addi	s1,s1,1
    800044d2:	008d8793          	addi	a5,s11,8
    800044d6:	e0f43023          	sd	a5,-512(s0)
    800044da:	008db503          	ld	a0,8(s11)
    800044de:	c911                	beqz	a0,800044f2 <exec+0x21a>
    if(argc >= MAXARG)
    800044e0:	09a1                	addi	s3,s3,8
    800044e2:	fb3c96e3          	bne	s9,s3,8000448e <exec+0x1b6>
  sz = sz1;
    800044e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ea:	4481                	li	s1,0
    800044ec:	a84d                	j	8000459e <exec+0x2c6>
  sp = sz;
    800044ee:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044f0:	4481                	li	s1,0
  ustack[argc] = 0;
    800044f2:	00349793          	slli	a5,s1,0x3
    800044f6:	f9040713          	addi	a4,s0,-112
    800044fa:	97ba                	add	a5,a5,a4
    800044fc:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004500:	00148693          	addi	a3,s1,1
    80004504:	068e                	slli	a3,a3,0x3
    80004506:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000450a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000450e:	01897663          	bgeu	s2,s8,8000451a <exec+0x242>
  sz = sz1;
    80004512:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004516:	4481                	li	s1,0
    80004518:	a059                	j	8000459e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000451a:	e9040613          	addi	a2,s0,-368
    8000451e:	85ca                	mv	a1,s2
    80004520:	855e                	mv	a0,s7
    80004522:	ffffd097          	auipc	ra,0xffffd
    80004526:	824080e7          	jalr	-2012(ra) # 80000d46 <copyout>
    8000452a:	0a054663          	bltz	a0,800045d6 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000452e:	058ab783          	ld	a5,88(s5)
    80004532:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004536:	df843783          	ld	a5,-520(s0)
    8000453a:	0007c703          	lbu	a4,0(a5)
    8000453e:	cf11                	beqz	a4,8000455a <exec+0x282>
    80004540:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004542:	02f00693          	li	a3,47
    80004546:	a039                	j	80004554 <exec+0x27c>
      last = s+1;
    80004548:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000454c:	0785                	addi	a5,a5,1
    8000454e:	fff7c703          	lbu	a4,-1(a5)
    80004552:	c701                	beqz	a4,8000455a <exec+0x282>
    if(*s == '/')
    80004554:	fed71ce3          	bne	a4,a3,8000454c <exec+0x274>
    80004558:	bfc5                	j	80004548 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000455a:	4641                	li	a2,16
    8000455c:	df843583          	ld	a1,-520(s0)
    80004560:	158a8513          	addi	a0,s5,344
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	f94080e7          	jalr	-108(ra) # 800004f8 <safestrcpy>
  oldpagetable = p->pagetable;
    8000456c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004570:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004574:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004578:	058ab783          	ld	a5,88(s5)
    8000457c:	e6843703          	ld	a4,-408(s0)
    80004580:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004582:	058ab783          	ld	a5,88(s5)
    80004586:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000458a:	85ea                	mv	a1,s10
    8000458c:	ffffd097          	auipc	ra,0xffffd
    80004590:	c76080e7          	jalr	-906(ra) # 80001202 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004594:	0004851b          	sext.w	a0,s1
    80004598:	bbe1                	j	80004370 <exec+0x98>
    8000459a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000459e:	e0843583          	ld	a1,-504(s0)
    800045a2:	855e                	mv	a0,s7
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	c5e080e7          	jalr	-930(ra) # 80001202 <proc_freepagetable>
  if(ip){
    800045ac:	da0498e3          	bnez	s1,8000435c <exec+0x84>
  return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	bb7d                	j	80004370 <exec+0x98>
    800045b4:	e1243423          	sd	s2,-504(s0)
    800045b8:	b7dd                	j	8000459e <exec+0x2c6>
    800045ba:	e1243423          	sd	s2,-504(s0)
    800045be:	b7c5                	j	8000459e <exec+0x2c6>
    800045c0:	e1243423          	sd	s2,-504(s0)
    800045c4:	bfe9                	j	8000459e <exec+0x2c6>
  sz = sz1;
    800045c6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045ca:	4481                	li	s1,0
    800045cc:	bfc9                	j	8000459e <exec+0x2c6>
  sz = sz1;
    800045ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045d2:	4481                	li	s1,0
    800045d4:	b7e9                	j	8000459e <exec+0x2c6>
  sz = sz1;
    800045d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045da:	4481                	li	s1,0
    800045dc:	b7c9                	j	8000459e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045de:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045e2:	2b05                	addiw	s6,s6,1
    800045e4:	0389899b          	addiw	s3,s3,56
    800045e8:	e8845783          	lhu	a5,-376(s0)
    800045ec:	e2fb5be3          	bge	s6,a5,80004422 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045f0:	2981                	sext.w	s3,s3
    800045f2:	03800713          	li	a4,56
    800045f6:	86ce                	mv	a3,s3
    800045f8:	e1840613          	addi	a2,s0,-488
    800045fc:	4581                	li	a1,0
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	a8e080e7          	jalr	-1394(ra) # 8000308e <readi>
    80004608:	03800793          	li	a5,56
    8000460c:	f8f517e3          	bne	a0,a5,8000459a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004610:	e1842783          	lw	a5,-488(s0)
    80004614:	4705                	li	a4,1
    80004616:	fce796e3          	bne	a5,a4,800045e2 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000461a:	e4043603          	ld	a2,-448(s0)
    8000461e:	e3843783          	ld	a5,-456(s0)
    80004622:	f8f669e3          	bltu	a2,a5,800045b4 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004626:	e2843783          	ld	a5,-472(s0)
    8000462a:	963e                	add	a2,a2,a5
    8000462c:	f8f667e3          	bltu	a2,a5,800045ba <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004630:	85ca                	mv	a1,s2
    80004632:	855e                	mv	a0,s7
    80004634:	ffffc097          	auipc	ra,0xffffc
    80004638:	4c0080e7          	jalr	1216(ra) # 80000af4 <uvmalloc>
    8000463c:	e0a43423          	sd	a0,-504(s0)
    80004640:	d141                	beqz	a0,800045c0 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004642:	e2843d03          	ld	s10,-472(s0)
    80004646:	df043783          	ld	a5,-528(s0)
    8000464a:	00fd77b3          	and	a5,s10,a5
    8000464e:	fba1                	bnez	a5,8000459e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004650:	e2042d83          	lw	s11,-480(s0)
    80004654:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004658:	f80c03e3          	beqz	s8,800045de <exec+0x306>
    8000465c:	8a62                	mv	s4,s8
    8000465e:	4901                	li	s2,0
    80004660:	b345                	j	80004400 <exec+0x128>

0000000080004662 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004662:	7179                	addi	sp,sp,-48
    80004664:	f406                	sd	ra,40(sp)
    80004666:	f022                	sd	s0,32(sp)
    80004668:	ec26                	sd	s1,24(sp)
    8000466a:	e84a                	sd	s2,16(sp)
    8000466c:	1800                	addi	s0,sp,48
    8000466e:	892e                	mv	s2,a1
    80004670:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004672:	fdc40593          	addi	a1,s0,-36
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	bf2080e7          	jalr	-1038(ra) # 80002268 <argint>
    8000467e:	04054063          	bltz	a0,800046be <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004682:	fdc42703          	lw	a4,-36(s0)
    80004686:	47bd                	li	a5,15
    80004688:	02e7ed63          	bltu	a5,a4,800046c2 <argfd+0x60>
    8000468c:	ffffd097          	auipc	ra,0xffffd
    80004690:	a16080e7          	jalr	-1514(ra) # 800010a2 <myproc>
    80004694:	fdc42703          	lw	a4,-36(s0)
    80004698:	01a70793          	addi	a5,a4,26
    8000469c:	078e                	slli	a5,a5,0x3
    8000469e:	953e                	add	a0,a0,a5
    800046a0:	611c                	ld	a5,0(a0)
    800046a2:	c395                	beqz	a5,800046c6 <argfd+0x64>
    return -1;
  if(pfd)
    800046a4:	00090463          	beqz	s2,800046ac <argfd+0x4a>
    *pfd = fd;
    800046a8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046ac:	4501                	li	a0,0
  if(pf)
    800046ae:	c091                	beqz	s1,800046b2 <argfd+0x50>
    *pf = f;
    800046b0:	e09c                	sd	a5,0(s1)
}
    800046b2:	70a2                	ld	ra,40(sp)
    800046b4:	7402                	ld	s0,32(sp)
    800046b6:	64e2                	ld	s1,24(sp)
    800046b8:	6942                	ld	s2,16(sp)
    800046ba:	6145                	addi	sp,sp,48
    800046bc:	8082                	ret
    return -1;
    800046be:	557d                	li	a0,-1
    800046c0:	bfcd                	j	800046b2 <argfd+0x50>
    return -1;
    800046c2:	557d                	li	a0,-1
    800046c4:	b7fd                	j	800046b2 <argfd+0x50>
    800046c6:	557d                	li	a0,-1
    800046c8:	b7ed                	j	800046b2 <argfd+0x50>

00000000800046ca <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046ca:	1101                	addi	sp,sp,-32
    800046cc:	ec06                	sd	ra,24(sp)
    800046ce:	e822                	sd	s0,16(sp)
    800046d0:	e426                	sd	s1,8(sp)
    800046d2:	1000                	addi	s0,sp,32
    800046d4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046d6:	ffffd097          	auipc	ra,0xffffd
    800046da:	9cc080e7          	jalr	-1588(ra) # 800010a2 <myproc>
    800046de:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046e0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fed8e90>
    800046e4:	4501                	li	a0,0
    800046e6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046e8:	6398                	ld	a4,0(a5)
    800046ea:	cb19                	beqz	a4,80004700 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046ec:	2505                	addiw	a0,a0,1
    800046ee:	07a1                	addi	a5,a5,8
    800046f0:	fed51ce3          	bne	a0,a3,800046e8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046f4:	557d                	li	a0,-1
}
    800046f6:	60e2                	ld	ra,24(sp)
    800046f8:	6442                	ld	s0,16(sp)
    800046fa:	64a2                	ld	s1,8(sp)
    800046fc:	6105                	addi	sp,sp,32
    800046fe:	8082                	ret
      p->ofile[fd] = f;
    80004700:	01a50793          	addi	a5,a0,26
    80004704:	078e                	slli	a5,a5,0x3
    80004706:	963e                	add	a2,a2,a5
    80004708:	e204                	sd	s1,0(a2)
      return fd;
    8000470a:	b7f5                	j	800046f6 <fdalloc+0x2c>

000000008000470c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000470c:	715d                	addi	sp,sp,-80
    8000470e:	e486                	sd	ra,72(sp)
    80004710:	e0a2                	sd	s0,64(sp)
    80004712:	fc26                	sd	s1,56(sp)
    80004714:	f84a                	sd	s2,48(sp)
    80004716:	f44e                	sd	s3,40(sp)
    80004718:	f052                	sd	s4,32(sp)
    8000471a:	ec56                	sd	s5,24(sp)
    8000471c:	0880                	addi	s0,sp,80
    8000471e:	89ae                	mv	s3,a1
    80004720:	8ab2                	mv	s5,a2
    80004722:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004724:	fb040593          	addi	a1,s0,-80
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	e86080e7          	jalr	-378(ra) # 800035ae <nameiparent>
    80004730:	892a                	mv	s2,a0
    80004732:	12050f63          	beqz	a0,80004870 <create+0x164>
    return 0;

  ilock(dp);
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	6a4080e7          	jalr	1700(ra) # 80002dda <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000473e:	4601                	li	a2,0
    80004740:	fb040593          	addi	a1,s0,-80
    80004744:	854a                	mv	a0,s2
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	b78080e7          	jalr	-1160(ra) # 800032be <dirlookup>
    8000474e:	84aa                	mv	s1,a0
    80004750:	c921                	beqz	a0,800047a0 <create+0x94>
    iunlockput(dp);
    80004752:	854a                	mv	a0,s2
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	8e8080e7          	jalr	-1816(ra) # 8000303c <iunlockput>
    ilock(ip);
    8000475c:	8526                	mv	a0,s1
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	67c080e7          	jalr	1660(ra) # 80002dda <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004766:	2981                	sext.w	s3,s3
    80004768:	4789                	li	a5,2
    8000476a:	02f99463          	bne	s3,a5,80004792 <create+0x86>
    8000476e:	0444d783          	lhu	a5,68(s1)
    80004772:	37f9                	addiw	a5,a5,-2
    80004774:	17c2                	slli	a5,a5,0x30
    80004776:	93c1                	srli	a5,a5,0x30
    80004778:	4705                	li	a4,1
    8000477a:	00f76c63          	bltu	a4,a5,80004792 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000477e:	8526                	mv	a0,s1
    80004780:	60a6                	ld	ra,72(sp)
    80004782:	6406                	ld	s0,64(sp)
    80004784:	74e2                	ld	s1,56(sp)
    80004786:	7942                	ld	s2,48(sp)
    80004788:	79a2                	ld	s3,40(sp)
    8000478a:	7a02                	ld	s4,32(sp)
    8000478c:	6ae2                	ld	s5,24(sp)
    8000478e:	6161                	addi	sp,sp,80
    80004790:	8082                	ret
    iunlockput(ip);
    80004792:	8526                	mv	a0,s1
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	8a8080e7          	jalr	-1880(ra) # 8000303c <iunlockput>
    return 0;
    8000479c:	4481                	li	s1,0
    8000479e:	b7c5                	j	8000477e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047a0:	85ce                	mv	a1,s3
    800047a2:	00092503          	lw	a0,0(s2)
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	49c080e7          	jalr	1180(ra) # 80002c42 <ialloc>
    800047ae:	84aa                	mv	s1,a0
    800047b0:	c529                	beqz	a0,800047fa <create+0xee>
  ilock(ip);
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	628080e7          	jalr	1576(ra) # 80002dda <ilock>
  ip->major = major;
    800047ba:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800047be:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800047c2:	4785                	li	a5,1
    800047c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	546080e7          	jalr	1350(ra) # 80002d10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047d2:	2981                	sext.w	s3,s3
    800047d4:	4785                	li	a5,1
    800047d6:	02f98a63          	beq	s3,a5,8000480a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047da:	40d0                	lw	a2,4(s1)
    800047dc:	fb040593          	addi	a1,s0,-80
    800047e0:	854a                	mv	a0,s2
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	cec080e7          	jalr	-788(ra) # 800034ce <dirlink>
    800047ea:	06054b63          	bltz	a0,80004860 <create+0x154>
  iunlockput(dp);
    800047ee:	854a                	mv	a0,s2
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	84c080e7          	jalr	-1972(ra) # 8000303c <iunlockput>
  return ip;
    800047f8:	b759                	j	8000477e <create+0x72>
    panic("create: ialloc");
    800047fa:	00004517          	auipc	a0,0x4
    800047fe:	ea650513          	addi	a0,a0,-346 # 800086a0 <syscalls+0x2a0>
    80004802:	00001097          	auipc	ra,0x1
    80004806:	686080e7          	jalr	1670(ra) # 80005e88 <panic>
    dp->nlink++;  // for ".."
    8000480a:	04a95783          	lhu	a5,74(s2)
    8000480e:	2785                	addiw	a5,a5,1
    80004810:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004814:	854a                	mv	a0,s2
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	4fa080e7          	jalr	1274(ra) # 80002d10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000481e:	40d0                	lw	a2,4(s1)
    80004820:	00004597          	auipc	a1,0x4
    80004824:	e9058593          	addi	a1,a1,-368 # 800086b0 <syscalls+0x2b0>
    80004828:	8526                	mv	a0,s1
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	ca4080e7          	jalr	-860(ra) # 800034ce <dirlink>
    80004832:	00054f63          	bltz	a0,80004850 <create+0x144>
    80004836:	00492603          	lw	a2,4(s2)
    8000483a:	00004597          	auipc	a1,0x4
    8000483e:	e7e58593          	addi	a1,a1,-386 # 800086b8 <syscalls+0x2b8>
    80004842:	8526                	mv	a0,s1
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	c8a080e7          	jalr	-886(ra) # 800034ce <dirlink>
    8000484c:	f80557e3          	bgez	a0,800047da <create+0xce>
      panic("create dots");
    80004850:	00004517          	auipc	a0,0x4
    80004854:	e7050513          	addi	a0,a0,-400 # 800086c0 <syscalls+0x2c0>
    80004858:	00001097          	auipc	ra,0x1
    8000485c:	630080e7          	jalr	1584(ra) # 80005e88 <panic>
    panic("create: dirlink");
    80004860:	00004517          	auipc	a0,0x4
    80004864:	e7050513          	addi	a0,a0,-400 # 800086d0 <syscalls+0x2d0>
    80004868:	00001097          	auipc	ra,0x1
    8000486c:	620080e7          	jalr	1568(ra) # 80005e88 <panic>
    return 0;
    80004870:	84aa                	mv	s1,a0
    80004872:	b731                	j	8000477e <create+0x72>

0000000080004874 <sys_dup>:
{
    80004874:	7179                	addi	sp,sp,-48
    80004876:	f406                	sd	ra,40(sp)
    80004878:	f022                	sd	s0,32(sp)
    8000487a:	ec26                	sd	s1,24(sp)
    8000487c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000487e:	fd840613          	addi	a2,s0,-40
    80004882:	4581                	li	a1,0
    80004884:	4501                	li	a0,0
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	ddc080e7          	jalr	-548(ra) # 80004662 <argfd>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004890:	02054363          	bltz	a0,800048b6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004894:	fd843503          	ld	a0,-40(s0)
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	e32080e7          	jalr	-462(ra) # 800046ca <fdalloc>
    800048a0:	84aa                	mv	s1,a0
    return -1;
    800048a2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048a4:	00054963          	bltz	a0,800048b6 <sys_dup+0x42>
  filedup(f);
    800048a8:	fd843503          	ld	a0,-40(s0)
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	37a080e7          	jalr	890(ra) # 80003c26 <filedup>
  return fd;
    800048b4:	87a6                	mv	a5,s1
}
    800048b6:	853e                	mv	a0,a5
    800048b8:	70a2                	ld	ra,40(sp)
    800048ba:	7402                	ld	s0,32(sp)
    800048bc:	64e2                	ld	s1,24(sp)
    800048be:	6145                	addi	sp,sp,48
    800048c0:	8082                	ret

00000000800048c2 <sys_read>:
{
    800048c2:	7179                	addi	sp,sp,-48
    800048c4:	f406                	sd	ra,40(sp)
    800048c6:	f022                	sd	s0,32(sp)
    800048c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ca:	fe840613          	addi	a2,s0,-24
    800048ce:	4581                	li	a1,0
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	d90080e7          	jalr	-624(ra) # 80004662 <argfd>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048dc:	04054163          	bltz	a0,8000491e <sys_read+0x5c>
    800048e0:	fe440593          	addi	a1,s0,-28
    800048e4:	4509                	li	a0,2
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	982080e7          	jalr	-1662(ra) # 80002268 <argint>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f0:	02054763          	bltz	a0,8000491e <sys_read+0x5c>
    800048f4:	fd840593          	addi	a1,s0,-40
    800048f8:	4505                	li	a0,1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	990080e7          	jalr	-1648(ra) # 8000228a <argaddr>
    return -1;
    80004902:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004904:	00054d63          	bltz	a0,8000491e <sys_read+0x5c>
  return fileread(f, p, n);
    80004908:	fe442603          	lw	a2,-28(s0)
    8000490c:	fd843583          	ld	a1,-40(s0)
    80004910:	fe843503          	ld	a0,-24(s0)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	49e080e7          	jalr	1182(ra) # 80003db2 <fileread>
    8000491c:	87aa                	mv	a5,a0
}
    8000491e:	853e                	mv	a0,a5
    80004920:	70a2                	ld	ra,40(sp)
    80004922:	7402                	ld	s0,32(sp)
    80004924:	6145                	addi	sp,sp,48
    80004926:	8082                	ret

0000000080004928 <sys_write>:
{
    80004928:	7179                	addi	sp,sp,-48
    8000492a:	f406                	sd	ra,40(sp)
    8000492c:	f022                	sd	s0,32(sp)
    8000492e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004930:	fe840613          	addi	a2,s0,-24
    80004934:	4581                	li	a1,0
    80004936:	4501                	li	a0,0
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	d2a080e7          	jalr	-726(ra) # 80004662 <argfd>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004942:	04054163          	bltz	a0,80004984 <sys_write+0x5c>
    80004946:	fe440593          	addi	a1,s0,-28
    8000494a:	4509                	li	a0,2
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	91c080e7          	jalr	-1764(ra) # 80002268 <argint>
    return -1;
    80004954:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004956:	02054763          	bltz	a0,80004984 <sys_write+0x5c>
    8000495a:	fd840593          	addi	a1,s0,-40
    8000495e:	4505                	li	a0,1
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	92a080e7          	jalr	-1750(ra) # 8000228a <argaddr>
    return -1;
    80004968:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496a:	00054d63          	bltz	a0,80004984 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000496e:	fe442603          	lw	a2,-28(s0)
    80004972:	fd843583          	ld	a1,-40(s0)
    80004976:	fe843503          	ld	a0,-24(s0)
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	4fa080e7          	jalr	1274(ra) # 80003e74 <filewrite>
    80004982:	87aa                	mv	a5,a0
}
    80004984:	853e                	mv	a0,a5
    80004986:	70a2                	ld	ra,40(sp)
    80004988:	7402                	ld	s0,32(sp)
    8000498a:	6145                	addi	sp,sp,48
    8000498c:	8082                	ret

000000008000498e <sys_close>:
{
    8000498e:	1101                	addi	sp,sp,-32
    80004990:	ec06                	sd	ra,24(sp)
    80004992:	e822                	sd	s0,16(sp)
    80004994:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004996:	fe040613          	addi	a2,s0,-32
    8000499a:	fec40593          	addi	a1,s0,-20
    8000499e:	4501                	li	a0,0
    800049a0:	00000097          	auipc	ra,0x0
    800049a4:	cc2080e7          	jalr	-830(ra) # 80004662 <argfd>
    return -1;
    800049a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049aa:	02054463          	bltz	a0,800049d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	6f4080e7          	jalr	1780(ra) # 800010a2 <myproc>
    800049b6:	fec42783          	lw	a5,-20(s0)
    800049ba:	07e9                	addi	a5,a5,26
    800049bc:	078e                	slli	a5,a5,0x3
    800049be:	97aa                	add	a5,a5,a0
    800049c0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049c4:	fe043503          	ld	a0,-32(s0)
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	2b0080e7          	jalr	688(ra) # 80003c78 <fileclose>
  return 0;
    800049d0:	4781                	li	a5,0
}
    800049d2:	853e                	mv	a0,a5
    800049d4:	60e2                	ld	ra,24(sp)
    800049d6:	6442                	ld	s0,16(sp)
    800049d8:	6105                	addi	sp,sp,32
    800049da:	8082                	ret

00000000800049dc <sys_fstat>:
{
    800049dc:	1101                	addi	sp,sp,-32
    800049de:	ec06                	sd	ra,24(sp)
    800049e0:	e822                	sd	s0,16(sp)
    800049e2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049e4:	fe840613          	addi	a2,s0,-24
    800049e8:	4581                	li	a1,0
    800049ea:	4501                	li	a0,0
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	c76080e7          	jalr	-906(ra) # 80004662 <argfd>
    return -1;
    800049f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049f6:	02054563          	bltz	a0,80004a20 <sys_fstat+0x44>
    800049fa:	fe040593          	addi	a1,s0,-32
    800049fe:	4505                	li	a0,1
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	88a080e7          	jalr	-1910(ra) # 8000228a <argaddr>
    return -1;
    80004a08:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a0a:	00054b63          	bltz	a0,80004a20 <sys_fstat+0x44>
  return filestat(f, st);
    80004a0e:	fe043583          	ld	a1,-32(s0)
    80004a12:	fe843503          	ld	a0,-24(s0)
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	32a080e7          	jalr	810(ra) # 80003d40 <filestat>
    80004a1e:	87aa                	mv	a5,a0
}
    80004a20:	853e                	mv	a0,a5
    80004a22:	60e2                	ld	ra,24(sp)
    80004a24:	6442                	ld	s0,16(sp)
    80004a26:	6105                	addi	sp,sp,32
    80004a28:	8082                	ret

0000000080004a2a <sys_link>:
{
    80004a2a:	7169                	addi	sp,sp,-304
    80004a2c:	f606                	sd	ra,296(sp)
    80004a2e:	f222                	sd	s0,288(sp)
    80004a30:	ee26                	sd	s1,280(sp)
    80004a32:	ea4a                	sd	s2,272(sp)
    80004a34:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a36:	08000613          	li	a2,128
    80004a3a:	ed040593          	addi	a1,s0,-304
    80004a3e:	4501                	li	a0,0
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	86c080e7          	jalr	-1940(ra) # 800022ac <argstr>
    return -1;
    80004a48:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a4a:	10054e63          	bltz	a0,80004b66 <sys_link+0x13c>
    80004a4e:	08000613          	li	a2,128
    80004a52:	f5040593          	addi	a1,s0,-176
    80004a56:	4505                	li	a0,1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	854080e7          	jalr	-1964(ra) # 800022ac <argstr>
    return -1;
    80004a60:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a62:	10054263          	bltz	a0,80004b66 <sys_link+0x13c>
  begin_op();
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	d46080e7          	jalr	-698(ra) # 800037ac <begin_op>
  if((ip = namei(old)) == 0){
    80004a6e:	ed040513          	addi	a0,s0,-304
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	b1e080e7          	jalr	-1250(ra) # 80003590 <namei>
    80004a7a:	84aa                	mv	s1,a0
    80004a7c:	c551                	beqz	a0,80004b08 <sys_link+0xde>
  ilock(ip);
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	35c080e7          	jalr	860(ra) # 80002dda <ilock>
  if(ip->type == T_DIR){
    80004a86:	04449703          	lh	a4,68(s1)
    80004a8a:	4785                	li	a5,1
    80004a8c:	08f70463          	beq	a4,a5,80004b14 <sys_link+0xea>
  ip->nlink++;
    80004a90:	04a4d783          	lhu	a5,74(s1)
    80004a94:	2785                	addiw	a5,a5,1
    80004a96:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	274080e7          	jalr	628(ra) # 80002d10 <iupdate>
  iunlock(ip);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	3f6080e7          	jalr	1014(ra) # 80002e9c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004aae:	fd040593          	addi	a1,s0,-48
    80004ab2:	f5040513          	addi	a0,s0,-176
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	af8080e7          	jalr	-1288(ra) # 800035ae <nameiparent>
    80004abe:	892a                	mv	s2,a0
    80004ac0:	c935                	beqz	a0,80004b34 <sys_link+0x10a>
  ilock(dp);
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	318080e7          	jalr	792(ra) # 80002dda <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aca:	00092703          	lw	a4,0(s2)
    80004ace:	409c                	lw	a5,0(s1)
    80004ad0:	04f71d63          	bne	a4,a5,80004b2a <sys_link+0x100>
    80004ad4:	40d0                	lw	a2,4(s1)
    80004ad6:	fd040593          	addi	a1,s0,-48
    80004ada:	854a                	mv	a0,s2
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	9f2080e7          	jalr	-1550(ra) # 800034ce <dirlink>
    80004ae4:	04054363          	bltz	a0,80004b2a <sys_link+0x100>
  iunlockput(dp);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	552080e7          	jalr	1362(ra) # 8000303c <iunlockput>
  iput(ip);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	4a0080e7          	jalr	1184(ra) # 80002f94 <iput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	d30080e7          	jalr	-720(ra) # 8000382c <end_op>
  return 0;
    80004b04:	4781                	li	a5,0
    80004b06:	a085                	j	80004b66 <sys_link+0x13c>
    end_op();
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	d24080e7          	jalr	-732(ra) # 8000382c <end_op>
    return -1;
    80004b10:	57fd                	li	a5,-1
    80004b12:	a891                	j	80004b66 <sys_link+0x13c>
    iunlockput(ip);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	526080e7          	jalr	1318(ra) # 8000303c <iunlockput>
    end_op();
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	d0e080e7          	jalr	-754(ra) # 8000382c <end_op>
    return -1;
    80004b26:	57fd                	li	a5,-1
    80004b28:	a83d                	j	80004b66 <sys_link+0x13c>
    iunlockput(dp);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	510080e7          	jalr	1296(ra) # 8000303c <iunlockput>
  ilock(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	2a4080e7          	jalr	676(ra) # 80002dda <ilock>
  ip->nlink--;
    80004b3e:	04a4d783          	lhu	a5,74(s1)
    80004b42:	37fd                	addiw	a5,a5,-1
    80004b44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	1c6080e7          	jalr	454(ra) # 80002d10 <iupdate>
  iunlockput(ip);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	4e8080e7          	jalr	1256(ra) # 8000303c <iunlockput>
  end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	cd0080e7          	jalr	-816(ra) # 8000382c <end_op>
  return -1;
    80004b64:	57fd                	li	a5,-1
}
    80004b66:	853e                	mv	a0,a5
    80004b68:	70b2                	ld	ra,296(sp)
    80004b6a:	7412                	ld	s0,288(sp)
    80004b6c:	64f2                	ld	s1,280(sp)
    80004b6e:	6952                	ld	s2,272(sp)
    80004b70:	6155                	addi	sp,sp,304
    80004b72:	8082                	ret

0000000080004b74 <sys_unlink>:
{
    80004b74:	7151                	addi	sp,sp,-240
    80004b76:	f586                	sd	ra,232(sp)
    80004b78:	f1a2                	sd	s0,224(sp)
    80004b7a:	eda6                	sd	s1,216(sp)
    80004b7c:	e9ca                	sd	s2,208(sp)
    80004b7e:	e5ce                	sd	s3,200(sp)
    80004b80:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b82:	08000613          	li	a2,128
    80004b86:	f3040593          	addi	a1,s0,-208
    80004b8a:	4501                	li	a0,0
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	720080e7          	jalr	1824(ra) # 800022ac <argstr>
    80004b94:	18054163          	bltz	a0,80004d16 <sys_unlink+0x1a2>
  begin_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	c14080e7          	jalr	-1004(ra) # 800037ac <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ba0:	fb040593          	addi	a1,s0,-80
    80004ba4:	f3040513          	addi	a0,s0,-208
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	a06080e7          	jalr	-1530(ra) # 800035ae <nameiparent>
    80004bb0:	84aa                	mv	s1,a0
    80004bb2:	c979                	beqz	a0,80004c88 <sys_unlink+0x114>
  ilock(dp);
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	226080e7          	jalr	550(ra) # 80002dda <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bbc:	00004597          	auipc	a1,0x4
    80004bc0:	af458593          	addi	a1,a1,-1292 # 800086b0 <syscalls+0x2b0>
    80004bc4:	fb040513          	addi	a0,s0,-80
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	6dc080e7          	jalr	1756(ra) # 800032a4 <namecmp>
    80004bd0:	14050a63          	beqz	a0,80004d24 <sys_unlink+0x1b0>
    80004bd4:	00004597          	auipc	a1,0x4
    80004bd8:	ae458593          	addi	a1,a1,-1308 # 800086b8 <syscalls+0x2b8>
    80004bdc:	fb040513          	addi	a0,s0,-80
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	6c4080e7          	jalr	1732(ra) # 800032a4 <namecmp>
    80004be8:	12050e63          	beqz	a0,80004d24 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bec:	f2c40613          	addi	a2,s0,-212
    80004bf0:	fb040593          	addi	a1,s0,-80
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	6c8080e7          	jalr	1736(ra) # 800032be <dirlookup>
    80004bfe:	892a                	mv	s2,a0
    80004c00:	12050263          	beqz	a0,80004d24 <sys_unlink+0x1b0>
  ilock(ip);
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	1d6080e7          	jalr	470(ra) # 80002dda <ilock>
  if(ip->nlink < 1)
    80004c0c:	04a91783          	lh	a5,74(s2)
    80004c10:	08f05263          	blez	a5,80004c94 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c14:	04491703          	lh	a4,68(s2)
    80004c18:	4785                	li	a5,1
    80004c1a:	08f70563          	beq	a4,a5,80004ca4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c1e:	4641                	li	a2,16
    80004c20:	4581                	li	a1,0
    80004c22:	fc040513          	addi	a0,s0,-64
    80004c26:	ffffb097          	auipc	ra,0xffffb
    80004c2a:	780080e7          	jalr	1920(ra) # 800003a6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c2e:	4741                	li	a4,16
    80004c30:	f2c42683          	lw	a3,-212(s0)
    80004c34:	fc040613          	addi	a2,s0,-64
    80004c38:	4581                	li	a1,0
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	54a080e7          	jalr	1354(ra) # 80003186 <writei>
    80004c44:	47c1                	li	a5,16
    80004c46:	0af51563          	bne	a0,a5,80004cf0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c4a:	04491703          	lh	a4,68(s2)
    80004c4e:	4785                	li	a5,1
    80004c50:	0af70863          	beq	a4,a5,80004d00 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	3e6080e7          	jalr	998(ra) # 8000303c <iunlockput>
  ip->nlink--;
    80004c5e:	04a95783          	lhu	a5,74(s2)
    80004c62:	37fd                	addiw	a5,a5,-1
    80004c64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c68:	854a                	mv	a0,s2
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	0a6080e7          	jalr	166(ra) # 80002d10 <iupdate>
  iunlockput(ip);
    80004c72:	854a                	mv	a0,s2
    80004c74:	ffffe097          	auipc	ra,0xffffe
    80004c78:	3c8080e7          	jalr	968(ra) # 8000303c <iunlockput>
  end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	bb0080e7          	jalr	-1104(ra) # 8000382c <end_op>
  return 0;
    80004c84:	4501                	li	a0,0
    80004c86:	a84d                	j	80004d38 <sys_unlink+0x1c4>
    end_op();
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	ba4080e7          	jalr	-1116(ra) # 8000382c <end_op>
    return -1;
    80004c90:	557d                	li	a0,-1
    80004c92:	a05d                	j	80004d38 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c94:	00004517          	auipc	a0,0x4
    80004c98:	a4c50513          	addi	a0,a0,-1460 # 800086e0 <syscalls+0x2e0>
    80004c9c:	00001097          	auipc	ra,0x1
    80004ca0:	1ec080e7          	jalr	492(ra) # 80005e88 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ca4:	04c92703          	lw	a4,76(s2)
    80004ca8:	02000793          	li	a5,32
    80004cac:	f6e7f9e3          	bgeu	a5,a4,80004c1e <sys_unlink+0xaa>
    80004cb0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb4:	4741                	li	a4,16
    80004cb6:	86ce                	mv	a3,s3
    80004cb8:	f1840613          	addi	a2,s0,-232
    80004cbc:	4581                	li	a1,0
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	3ce080e7          	jalr	974(ra) # 8000308e <readi>
    80004cc8:	47c1                	li	a5,16
    80004cca:	00f51b63          	bne	a0,a5,80004ce0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cce:	f1845783          	lhu	a5,-232(s0)
    80004cd2:	e7a1                	bnez	a5,80004d1a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cd4:	29c1                	addiw	s3,s3,16
    80004cd6:	04c92783          	lw	a5,76(s2)
    80004cda:	fcf9ede3          	bltu	s3,a5,80004cb4 <sys_unlink+0x140>
    80004cde:	b781                	j	80004c1e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ce0:	00004517          	auipc	a0,0x4
    80004ce4:	a1850513          	addi	a0,a0,-1512 # 800086f8 <syscalls+0x2f8>
    80004ce8:	00001097          	auipc	ra,0x1
    80004cec:	1a0080e7          	jalr	416(ra) # 80005e88 <panic>
    panic("unlink: writei");
    80004cf0:	00004517          	auipc	a0,0x4
    80004cf4:	a2050513          	addi	a0,a0,-1504 # 80008710 <syscalls+0x310>
    80004cf8:	00001097          	auipc	ra,0x1
    80004cfc:	190080e7          	jalr	400(ra) # 80005e88 <panic>
    dp->nlink--;
    80004d00:	04a4d783          	lhu	a5,74(s1)
    80004d04:	37fd                	addiw	a5,a5,-1
    80004d06:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	004080e7          	jalr	4(ra) # 80002d10 <iupdate>
    80004d14:	b781                	j	80004c54 <sys_unlink+0xe0>
    return -1;
    80004d16:	557d                	li	a0,-1
    80004d18:	a005                	j	80004d38 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d1a:	854a                	mv	a0,s2
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	320080e7          	jalr	800(ra) # 8000303c <iunlockput>
  iunlockput(dp);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	316080e7          	jalr	790(ra) # 8000303c <iunlockput>
  end_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	afe080e7          	jalr	-1282(ra) # 8000382c <end_op>
  return -1;
    80004d36:	557d                	li	a0,-1
}
    80004d38:	70ae                	ld	ra,232(sp)
    80004d3a:	740e                	ld	s0,224(sp)
    80004d3c:	64ee                	ld	s1,216(sp)
    80004d3e:	694e                	ld	s2,208(sp)
    80004d40:	69ae                	ld	s3,200(sp)
    80004d42:	616d                	addi	sp,sp,240
    80004d44:	8082                	ret

0000000080004d46 <sys_open>:

uint64
sys_open(void)
{
    80004d46:	7131                	addi	sp,sp,-192
    80004d48:	fd06                	sd	ra,184(sp)
    80004d4a:	f922                	sd	s0,176(sp)
    80004d4c:	f526                	sd	s1,168(sp)
    80004d4e:	f14a                	sd	s2,160(sp)
    80004d50:	ed4e                	sd	s3,152(sp)
    80004d52:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d54:	08000613          	li	a2,128
    80004d58:	f5040593          	addi	a1,s0,-176
    80004d5c:	4501                	li	a0,0
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	54e080e7          	jalr	1358(ra) # 800022ac <argstr>
    return -1;
    80004d66:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d68:	0c054163          	bltz	a0,80004e2a <sys_open+0xe4>
    80004d6c:	f4c40593          	addi	a1,s0,-180
    80004d70:	4505                	li	a0,1
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	4f6080e7          	jalr	1270(ra) # 80002268 <argint>
    80004d7a:	0a054863          	bltz	a0,80004e2a <sys_open+0xe4>

  begin_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	a2e080e7          	jalr	-1490(ra) # 800037ac <begin_op>

  if(omode & O_CREATE){
    80004d86:	f4c42783          	lw	a5,-180(s0)
    80004d8a:	2007f793          	andi	a5,a5,512
    80004d8e:	cbdd                	beqz	a5,80004e44 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d90:	4681                	li	a3,0
    80004d92:	4601                	li	a2,0
    80004d94:	4589                	li	a1,2
    80004d96:	f5040513          	addi	a0,s0,-176
    80004d9a:	00000097          	auipc	ra,0x0
    80004d9e:	972080e7          	jalr	-1678(ra) # 8000470c <create>
    80004da2:	892a                	mv	s2,a0
    if(ip == 0){
    80004da4:	c959                	beqz	a0,80004e3a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004da6:	04491703          	lh	a4,68(s2)
    80004daa:	478d                	li	a5,3
    80004dac:	00f71763          	bne	a4,a5,80004dba <sys_open+0x74>
    80004db0:	04695703          	lhu	a4,70(s2)
    80004db4:	47a5                	li	a5,9
    80004db6:	0ce7ec63          	bltu	a5,a4,80004e8e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	e02080e7          	jalr	-510(ra) # 80003bbc <filealloc>
    80004dc2:	89aa                	mv	s3,a0
    80004dc4:	10050263          	beqz	a0,80004ec8 <sys_open+0x182>
    80004dc8:	00000097          	auipc	ra,0x0
    80004dcc:	902080e7          	jalr	-1790(ra) # 800046ca <fdalloc>
    80004dd0:	84aa                	mv	s1,a0
    80004dd2:	0e054663          	bltz	a0,80004ebe <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dd6:	04491703          	lh	a4,68(s2)
    80004dda:	478d                	li	a5,3
    80004ddc:	0cf70463          	beq	a4,a5,80004ea4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004de0:	4789                	li	a5,2
    80004de2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004de6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dea:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dee:	f4c42783          	lw	a5,-180(s0)
    80004df2:	0017c713          	xori	a4,a5,1
    80004df6:	8b05                	andi	a4,a4,1
    80004df8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dfc:	0037f713          	andi	a4,a5,3
    80004e00:	00e03733          	snez	a4,a4
    80004e04:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e08:	4007f793          	andi	a5,a5,1024
    80004e0c:	c791                	beqz	a5,80004e18 <sys_open+0xd2>
    80004e0e:	04491703          	lh	a4,68(s2)
    80004e12:	4789                	li	a5,2
    80004e14:	08f70f63          	beq	a4,a5,80004eb2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	082080e7          	jalr	130(ra) # 80002e9c <iunlock>
  end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	a0a080e7          	jalr	-1526(ra) # 8000382c <end_op>

  return fd;
}
    80004e2a:	8526                	mv	a0,s1
    80004e2c:	70ea                	ld	ra,184(sp)
    80004e2e:	744a                	ld	s0,176(sp)
    80004e30:	74aa                	ld	s1,168(sp)
    80004e32:	790a                	ld	s2,160(sp)
    80004e34:	69ea                	ld	s3,152(sp)
    80004e36:	6129                	addi	sp,sp,192
    80004e38:	8082                	ret
      end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	9f2080e7          	jalr	-1550(ra) # 8000382c <end_op>
      return -1;
    80004e42:	b7e5                	j	80004e2a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e44:	f5040513          	addi	a0,s0,-176
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	748080e7          	jalr	1864(ra) # 80003590 <namei>
    80004e50:	892a                	mv	s2,a0
    80004e52:	c905                	beqz	a0,80004e82 <sys_open+0x13c>
    ilock(ip);
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	f86080e7          	jalr	-122(ra) # 80002dda <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e5c:	04491703          	lh	a4,68(s2)
    80004e60:	4785                	li	a5,1
    80004e62:	f4f712e3          	bne	a4,a5,80004da6 <sys_open+0x60>
    80004e66:	f4c42783          	lw	a5,-180(s0)
    80004e6a:	dba1                	beqz	a5,80004dba <sys_open+0x74>
      iunlockput(ip);
    80004e6c:	854a                	mv	a0,s2
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	1ce080e7          	jalr	462(ra) # 8000303c <iunlockput>
      end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	9b6080e7          	jalr	-1610(ra) # 8000382c <end_op>
      return -1;
    80004e7e:	54fd                	li	s1,-1
    80004e80:	b76d                	j	80004e2a <sys_open+0xe4>
      end_op();
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	9aa080e7          	jalr	-1622(ra) # 8000382c <end_op>
      return -1;
    80004e8a:	54fd                	li	s1,-1
    80004e8c:	bf79                	j	80004e2a <sys_open+0xe4>
    iunlockput(ip);
    80004e8e:	854a                	mv	a0,s2
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	1ac080e7          	jalr	428(ra) # 8000303c <iunlockput>
    end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	994080e7          	jalr	-1644(ra) # 8000382c <end_op>
    return -1;
    80004ea0:	54fd                	li	s1,-1
    80004ea2:	b761                	j	80004e2a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ea4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ea8:	04691783          	lh	a5,70(s2)
    80004eac:	02f99223          	sh	a5,36(s3)
    80004eb0:	bf2d                	j	80004dea <sys_open+0xa4>
    itrunc(ip);
    80004eb2:	854a                	mv	a0,s2
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	034080e7          	jalr	52(ra) # 80002ee8 <itrunc>
    80004ebc:	bfb1                	j	80004e18 <sys_open+0xd2>
      fileclose(f);
    80004ebe:	854e                	mv	a0,s3
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	db8080e7          	jalr	-584(ra) # 80003c78 <fileclose>
    iunlockput(ip);
    80004ec8:	854a                	mv	a0,s2
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	172080e7          	jalr	370(ra) # 8000303c <iunlockput>
    end_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	95a080e7          	jalr	-1702(ra) # 8000382c <end_op>
    return -1;
    80004eda:	54fd                	li	s1,-1
    80004edc:	b7b9                	j	80004e2a <sys_open+0xe4>

0000000080004ede <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ede:	7175                	addi	sp,sp,-144
    80004ee0:	e506                	sd	ra,136(sp)
    80004ee2:	e122                	sd	s0,128(sp)
    80004ee4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	8c6080e7          	jalr	-1850(ra) # 800037ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004eee:	08000613          	li	a2,128
    80004ef2:	f7040593          	addi	a1,s0,-144
    80004ef6:	4501                	li	a0,0
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	3b4080e7          	jalr	948(ra) # 800022ac <argstr>
    80004f00:	02054963          	bltz	a0,80004f32 <sys_mkdir+0x54>
    80004f04:	4681                	li	a3,0
    80004f06:	4601                	li	a2,0
    80004f08:	4585                	li	a1,1
    80004f0a:	f7040513          	addi	a0,s0,-144
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	7fe080e7          	jalr	2046(ra) # 8000470c <create>
    80004f16:	cd11                	beqz	a0,80004f32 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	124080e7          	jalr	292(ra) # 8000303c <iunlockput>
  end_op();
    80004f20:	fffff097          	auipc	ra,0xfffff
    80004f24:	90c080e7          	jalr	-1780(ra) # 8000382c <end_op>
  return 0;
    80004f28:	4501                	li	a0,0
}
    80004f2a:	60aa                	ld	ra,136(sp)
    80004f2c:	640a                	ld	s0,128(sp)
    80004f2e:	6149                	addi	sp,sp,144
    80004f30:	8082                	ret
    end_op();
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	8fa080e7          	jalr	-1798(ra) # 8000382c <end_op>
    return -1;
    80004f3a:	557d                	li	a0,-1
    80004f3c:	b7fd                	j	80004f2a <sys_mkdir+0x4c>

0000000080004f3e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f3e:	7135                	addi	sp,sp,-160
    80004f40:	ed06                	sd	ra,152(sp)
    80004f42:	e922                	sd	s0,144(sp)
    80004f44:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	866080e7          	jalr	-1946(ra) # 800037ac <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f4e:	08000613          	li	a2,128
    80004f52:	f7040593          	addi	a1,s0,-144
    80004f56:	4501                	li	a0,0
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	354080e7          	jalr	852(ra) # 800022ac <argstr>
    80004f60:	04054a63          	bltz	a0,80004fb4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f64:	f6c40593          	addi	a1,s0,-148
    80004f68:	4505                	li	a0,1
    80004f6a:	ffffd097          	auipc	ra,0xffffd
    80004f6e:	2fe080e7          	jalr	766(ra) # 80002268 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f72:	04054163          	bltz	a0,80004fb4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f76:	f6840593          	addi	a1,s0,-152
    80004f7a:	4509                	li	a0,2
    80004f7c:	ffffd097          	auipc	ra,0xffffd
    80004f80:	2ec080e7          	jalr	748(ra) # 80002268 <argint>
     argint(1, &major) < 0 ||
    80004f84:	02054863          	bltz	a0,80004fb4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f88:	f6841683          	lh	a3,-152(s0)
    80004f8c:	f6c41603          	lh	a2,-148(s0)
    80004f90:	458d                	li	a1,3
    80004f92:	f7040513          	addi	a0,s0,-144
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	776080e7          	jalr	1910(ra) # 8000470c <create>
     argint(2, &minor) < 0 ||
    80004f9e:	c919                	beqz	a0,80004fb4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	09c080e7          	jalr	156(ra) # 8000303c <iunlockput>
  end_op();
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	884080e7          	jalr	-1916(ra) # 8000382c <end_op>
  return 0;
    80004fb0:	4501                	li	a0,0
    80004fb2:	a031                	j	80004fbe <sys_mknod+0x80>
    end_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	878080e7          	jalr	-1928(ra) # 8000382c <end_op>
    return -1;
    80004fbc:	557d                	li	a0,-1
}
    80004fbe:	60ea                	ld	ra,152(sp)
    80004fc0:	644a                	ld	s0,144(sp)
    80004fc2:	610d                	addi	sp,sp,160
    80004fc4:	8082                	ret

0000000080004fc6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc6:	7135                	addi	sp,sp,-160
    80004fc8:	ed06                	sd	ra,152(sp)
    80004fca:	e922                	sd	s0,144(sp)
    80004fcc:	e526                	sd	s1,136(sp)
    80004fce:	e14a                	sd	s2,128(sp)
    80004fd0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	0d0080e7          	jalr	208(ra) # 800010a2 <myproc>
    80004fda:	892a                	mv	s2,a0
  
  begin_op();
    80004fdc:	ffffe097          	auipc	ra,0xffffe
    80004fe0:	7d0080e7          	jalr	2000(ra) # 800037ac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fe4:	08000613          	li	a2,128
    80004fe8:	f6040593          	addi	a1,s0,-160
    80004fec:	4501                	li	a0,0
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	2be080e7          	jalr	702(ra) # 800022ac <argstr>
    80004ff6:	04054b63          	bltz	a0,8000504c <sys_chdir+0x86>
    80004ffa:	f6040513          	addi	a0,s0,-160
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	592080e7          	jalr	1426(ra) # 80003590 <namei>
    80005006:	84aa                	mv	s1,a0
    80005008:	c131                	beqz	a0,8000504c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	dd0080e7          	jalr	-560(ra) # 80002dda <ilock>
  if(ip->type != T_DIR){
    80005012:	04449703          	lh	a4,68(s1)
    80005016:	4785                	li	a5,1
    80005018:	04f71063          	bne	a4,a5,80005058 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000501c:	8526                	mv	a0,s1
    8000501e:	ffffe097          	auipc	ra,0xffffe
    80005022:	e7e080e7          	jalr	-386(ra) # 80002e9c <iunlock>
  iput(p->cwd);
    80005026:	15093503          	ld	a0,336(s2)
    8000502a:	ffffe097          	auipc	ra,0xffffe
    8000502e:	f6a080e7          	jalr	-150(ra) # 80002f94 <iput>
  end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	7fa080e7          	jalr	2042(ra) # 8000382c <end_op>
  p->cwd = ip;
    8000503a:	14993823          	sd	s1,336(s2)
  return 0;
    8000503e:	4501                	li	a0,0
}
    80005040:	60ea                	ld	ra,152(sp)
    80005042:	644a                	ld	s0,144(sp)
    80005044:	64aa                	ld	s1,136(sp)
    80005046:	690a                	ld	s2,128(sp)
    80005048:	610d                	addi	sp,sp,160
    8000504a:	8082                	ret
    end_op();
    8000504c:	ffffe097          	auipc	ra,0xffffe
    80005050:	7e0080e7          	jalr	2016(ra) # 8000382c <end_op>
    return -1;
    80005054:	557d                	li	a0,-1
    80005056:	b7ed                	j	80005040 <sys_chdir+0x7a>
    iunlockput(ip);
    80005058:	8526                	mv	a0,s1
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	fe2080e7          	jalr	-30(ra) # 8000303c <iunlockput>
    end_op();
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	7ca080e7          	jalr	1994(ra) # 8000382c <end_op>
    return -1;
    8000506a:	557d                	li	a0,-1
    8000506c:	bfd1                	j	80005040 <sys_chdir+0x7a>

000000008000506e <sys_exec>:

uint64
sys_exec(void)
{
    8000506e:	7145                	addi	sp,sp,-464
    80005070:	e786                	sd	ra,456(sp)
    80005072:	e3a2                	sd	s0,448(sp)
    80005074:	ff26                	sd	s1,440(sp)
    80005076:	fb4a                	sd	s2,432(sp)
    80005078:	f74e                	sd	s3,424(sp)
    8000507a:	f352                	sd	s4,416(sp)
    8000507c:	ef56                	sd	s5,408(sp)
    8000507e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005080:	08000613          	li	a2,128
    80005084:	f4040593          	addi	a1,s0,-192
    80005088:	4501                	li	a0,0
    8000508a:	ffffd097          	auipc	ra,0xffffd
    8000508e:	222080e7          	jalr	546(ra) # 800022ac <argstr>
    return -1;
    80005092:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005094:	0c054a63          	bltz	a0,80005168 <sys_exec+0xfa>
    80005098:	e3840593          	addi	a1,s0,-456
    8000509c:	4505                	li	a0,1
    8000509e:	ffffd097          	auipc	ra,0xffffd
    800050a2:	1ec080e7          	jalr	492(ra) # 8000228a <argaddr>
    800050a6:	0c054163          	bltz	a0,80005168 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050aa:	10000613          	li	a2,256
    800050ae:	4581                	li	a1,0
    800050b0:	e4040513          	addi	a0,s0,-448
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	2f2080e7          	jalr	754(ra) # 800003a6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050bc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050c0:	89a6                	mv	s3,s1
    800050c2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050c4:	02000a13          	li	s4,32
    800050c8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050cc:	00391513          	slli	a0,s2,0x3
    800050d0:	e3040593          	addi	a1,s0,-464
    800050d4:	e3843783          	ld	a5,-456(s0)
    800050d8:	953e                	add	a0,a0,a5
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	0f4080e7          	jalr	244(ra) # 800021ce <fetchaddr>
    800050e2:	02054a63          	bltz	a0,80005116 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050e6:	e3043783          	ld	a5,-464(s0)
    800050ea:	c3b9                	beqz	a5,80005130 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050ec:	ffffb097          	auipc	ra,0xffffb
    800050f0:	12a080e7          	jalr	298(ra) # 80000216 <kalloc>
    800050f4:	85aa                	mv	a1,a0
    800050f6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050fa:	cd11                	beqz	a0,80005116 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050fc:	6605                	lui	a2,0x1
    800050fe:	e3043503          	ld	a0,-464(s0)
    80005102:	ffffd097          	auipc	ra,0xffffd
    80005106:	11e080e7          	jalr	286(ra) # 80002220 <fetchstr>
    8000510a:	00054663          	bltz	a0,80005116 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000510e:	0905                	addi	s2,s2,1
    80005110:	09a1                	addi	s3,s3,8
    80005112:	fb491be3          	bne	s2,s4,800050c8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005116:	10048913          	addi	s2,s1,256
    8000511a:	6088                	ld	a0,0(s1)
    8000511c:	c529                	beqz	a0,80005166 <sys_exec+0xf8>
    kfree(argv[i]);
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	efe080e7          	jalr	-258(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005126:	04a1                	addi	s1,s1,8
    80005128:	ff2499e3          	bne	s1,s2,8000511a <sys_exec+0xac>
  return -1;
    8000512c:	597d                	li	s2,-1
    8000512e:	a82d                	j	80005168 <sys_exec+0xfa>
      argv[i] = 0;
    80005130:	0a8e                	slli	s5,s5,0x3
    80005132:	fc040793          	addi	a5,s0,-64
    80005136:	9abe                	add	s5,s5,a5
    80005138:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000513c:	e4040593          	addi	a1,s0,-448
    80005140:	f4040513          	addi	a0,s0,-192
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	194080e7          	jalr	404(ra) # 800042d8 <exec>
    8000514c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514e:	10048993          	addi	s3,s1,256
    80005152:	6088                	ld	a0,0(s1)
    80005154:	c911                	beqz	a0,80005168 <sys_exec+0xfa>
    kfree(argv[i]);
    80005156:	ffffb097          	auipc	ra,0xffffb
    8000515a:	ec6080e7          	jalr	-314(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000515e:	04a1                	addi	s1,s1,8
    80005160:	ff3499e3          	bne	s1,s3,80005152 <sys_exec+0xe4>
    80005164:	a011                	j	80005168 <sys_exec+0xfa>
  return -1;
    80005166:	597d                	li	s2,-1
}
    80005168:	854a                	mv	a0,s2
    8000516a:	60be                	ld	ra,456(sp)
    8000516c:	641e                	ld	s0,448(sp)
    8000516e:	74fa                	ld	s1,440(sp)
    80005170:	795a                	ld	s2,432(sp)
    80005172:	79ba                	ld	s3,424(sp)
    80005174:	7a1a                	ld	s4,416(sp)
    80005176:	6afa                	ld	s5,408(sp)
    80005178:	6179                	addi	sp,sp,464
    8000517a:	8082                	ret

000000008000517c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000517c:	7139                	addi	sp,sp,-64
    8000517e:	fc06                	sd	ra,56(sp)
    80005180:	f822                	sd	s0,48(sp)
    80005182:	f426                	sd	s1,40(sp)
    80005184:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005186:	ffffc097          	auipc	ra,0xffffc
    8000518a:	f1c080e7          	jalr	-228(ra) # 800010a2 <myproc>
    8000518e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005190:	fd840593          	addi	a1,s0,-40
    80005194:	4501                	li	a0,0
    80005196:	ffffd097          	auipc	ra,0xffffd
    8000519a:	0f4080e7          	jalr	244(ra) # 8000228a <argaddr>
    return -1;
    8000519e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051a0:	0e054063          	bltz	a0,80005280 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051a4:	fc840593          	addi	a1,s0,-56
    800051a8:	fd040513          	addi	a0,s0,-48
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	dfc080e7          	jalr	-516(ra) # 80003fa8 <pipealloc>
    return -1;
    800051b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051b6:	0c054563          	bltz	a0,80005280 <sys_pipe+0x104>
  fd0 = -1;
    800051ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051be:	fd043503          	ld	a0,-48(s0)
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	508080e7          	jalr	1288(ra) # 800046ca <fdalloc>
    800051ca:	fca42223          	sw	a0,-60(s0)
    800051ce:	08054c63          	bltz	a0,80005266 <sys_pipe+0xea>
    800051d2:	fc843503          	ld	a0,-56(s0)
    800051d6:	fffff097          	auipc	ra,0xfffff
    800051da:	4f4080e7          	jalr	1268(ra) # 800046ca <fdalloc>
    800051de:	fca42023          	sw	a0,-64(s0)
    800051e2:	06054863          	bltz	a0,80005252 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e6:	4691                	li	a3,4
    800051e8:	fc440613          	addi	a2,s0,-60
    800051ec:	fd843583          	ld	a1,-40(s0)
    800051f0:	68a8                	ld	a0,80(s1)
    800051f2:	ffffc097          	auipc	ra,0xffffc
    800051f6:	b54080e7          	jalr	-1196(ra) # 80000d46 <copyout>
    800051fa:	02054063          	bltz	a0,8000521a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051fe:	4691                	li	a3,4
    80005200:	fc040613          	addi	a2,s0,-64
    80005204:	fd843583          	ld	a1,-40(s0)
    80005208:	0591                	addi	a1,a1,4
    8000520a:	68a8                	ld	a0,80(s1)
    8000520c:	ffffc097          	auipc	ra,0xffffc
    80005210:	b3a080e7          	jalr	-1222(ra) # 80000d46 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005214:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005216:	06055563          	bgez	a0,80005280 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000521a:	fc442783          	lw	a5,-60(s0)
    8000521e:	07e9                	addi	a5,a5,26
    80005220:	078e                	slli	a5,a5,0x3
    80005222:	97a6                	add	a5,a5,s1
    80005224:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005228:	fc042503          	lw	a0,-64(s0)
    8000522c:	0569                	addi	a0,a0,26
    8000522e:	050e                	slli	a0,a0,0x3
    80005230:	9526                	add	a0,a0,s1
    80005232:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005236:	fd043503          	ld	a0,-48(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	a3e080e7          	jalr	-1474(ra) # 80003c78 <fileclose>
    fileclose(wf);
    80005242:	fc843503          	ld	a0,-56(s0)
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	a32080e7          	jalr	-1486(ra) # 80003c78 <fileclose>
    return -1;
    8000524e:	57fd                	li	a5,-1
    80005250:	a805                	j	80005280 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005252:	fc442783          	lw	a5,-60(s0)
    80005256:	0007c863          	bltz	a5,80005266 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000525a:	01a78513          	addi	a0,a5,26
    8000525e:	050e                	slli	a0,a0,0x3
    80005260:	9526                	add	a0,a0,s1
    80005262:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005266:	fd043503          	ld	a0,-48(s0)
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	a0e080e7          	jalr	-1522(ra) # 80003c78 <fileclose>
    fileclose(wf);
    80005272:	fc843503          	ld	a0,-56(s0)
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	a02080e7          	jalr	-1534(ra) # 80003c78 <fileclose>
    return -1;
    8000527e:	57fd                	li	a5,-1
}
    80005280:	853e                	mv	a0,a5
    80005282:	70e2                	ld	ra,56(sp)
    80005284:	7442                	ld	s0,48(sp)
    80005286:	74a2                	ld	s1,40(sp)
    80005288:	6121                	addi	sp,sp,64
    8000528a:	8082                	ret
    8000528c:	0000                	unimp
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	dcbfc0ef          	jal	ra,8000209a <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	c3d8                	sw	a4,4(a5)
}
    8000535a:	6422                	ld	s0,8(sp)
    8000535c:	0141                	addi	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plicinithart>:

void
plicinithart(void)
{
    80005360:	1141                	addi	sp,sp,-16
    80005362:	e406                	sd	ra,8(sp)
    80005364:	e022                	sd	s0,0(sp)
    80005366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	d0e080e7          	jalr	-754(ra) # 80001076 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	953e                	add	a0,a0,a5
    8000538c:	00052023          	sw	zero,0(a0)
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	cd6080e7          	jalr	-810(ra) # 80001076 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5179b          	slliw	a5,a0,0xd
    800053ac:	0c201537          	lui	a0,0xc201
    800053b0:	953e                	add	a0,a0,a5
  return irq;
}
    800053b2:	4148                	lw	a0,4(a0)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	cae080e7          	jalr	-850(ra) # 80001076 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d0:	00d5151b          	slliw	a0,a0,0xd
    800053d4:	0c2017b7          	lui	a5,0xc201
    800053d8:	97aa                	add	a5,a5,a0
    800053da:	c3c4                	sw	s1,4(a5)
}
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	64a2                	ld	s1,8(sp)
    800053e2:	6105                	addi	sp,sp,32
    800053e4:	8082                	ret

00000000800053e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e6:	1141                	addi	sp,sp,-16
    800053e8:	e406                	sd	ra,8(sp)
    800053ea:	e022                	sd	s0,0(sp)
    800053ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ee:	479d                	li	a5,7
    800053f0:	06a7c963          	blt	a5,a0,80005462 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800053f4:	00116797          	auipc	a5,0x116
    800053f8:	c0c78793          	addi	a5,a5,-1012 # 8011b000 <disk>
    800053fc:	00a78733          	add	a4,a5,a0
    80005400:	6789                	lui	a5,0x2
    80005402:	97ba                	add	a5,a5,a4
    80005404:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005408:	e7ad                	bnez	a5,80005472 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000540a:	00451793          	slli	a5,a0,0x4
    8000540e:	00118717          	auipc	a4,0x118
    80005412:	bf270713          	addi	a4,a4,-1038 # 8011d000 <disk+0x2000>
    80005416:	6314                	ld	a3,0(a4)
    80005418:	96be                	add	a3,a3,a5
    8000541a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000541e:	6314                	ld	a3,0(a4)
    80005420:	96be                	add	a3,a3,a5
    80005422:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005426:	6314                	ld	a3,0(a4)
    80005428:	96be                	add	a3,a3,a5
    8000542a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000542e:	6318                	ld	a4,0(a4)
    80005430:	97ba                	add	a5,a5,a4
    80005432:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005436:	00116797          	auipc	a5,0x116
    8000543a:	bca78793          	addi	a5,a5,-1078 # 8011b000 <disk>
    8000543e:	97aa                	add	a5,a5,a0
    80005440:	6509                	lui	a0,0x2
    80005442:	953e                	add	a0,a0,a5
    80005444:	4785                	li	a5,1
    80005446:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000544a:	00118517          	auipc	a0,0x118
    8000544e:	bce50513          	addi	a0,a0,-1074 # 8011d018 <disk+0x2018>
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	498080e7          	jalr	1176(ra) # 800018ea <wakeup>
}
    8000545a:	60a2                	ld	ra,8(sp)
    8000545c:	6402                	ld	s0,0(sp)
    8000545e:	0141                	addi	sp,sp,16
    80005460:	8082                	ret
    panic("free_desc 1");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	2be50513          	addi	a0,a0,702 # 80008720 <syscalls+0x320>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	a1e080e7          	jalr	-1506(ra) # 80005e88 <panic>
    panic("free_desc 2");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	2be50513          	addi	a0,a0,702 # 80008730 <syscalls+0x330>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	a0e080e7          	jalr	-1522(ra) # 80005e88 <panic>

0000000080005482 <virtio_disk_init>:
{
    80005482:	1101                	addi	sp,sp,-32
    80005484:	ec06                	sd	ra,24(sp)
    80005486:	e822                	sd	s0,16(sp)
    80005488:	e426                	sd	s1,8(sp)
    8000548a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000548c:	00003597          	auipc	a1,0x3
    80005490:	2b458593          	addi	a1,a1,692 # 80008740 <syscalls+0x340>
    80005494:	00118517          	auipc	a0,0x118
    80005498:	c9450513          	addi	a0,a0,-876 # 8011d128 <disk+0x2128>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	ea6080e7          	jalr	-346(ra) # 80006342 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	4398                	lw	a4,0(a5)
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	747277b7          	lui	a5,0x74727
    800054b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054b4:	0ef71163          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	43dc                	lw	a5,4(a5)
    800054be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c0:	4705                	li	a4,1
    800054c2:	0ce79a63          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c6:	100017b7          	lui	a5,0x10001
    800054ca:	479c                	lw	a5,8(a5)
    800054cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054ce:	4709                	li	a4,2
    800054d0:	0ce79363          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	47d8                	lw	a4,12(a5)
    800054da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054dc:	554d47b7          	lui	a5,0x554d4
    800054e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054e4:	0af71963          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	4705                	li	a4,1
    800054ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f0:	470d                	li	a4,3
    800054f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054f6:	c7ffe737          	lui	a4,0xc7ffe
    800054fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47ed851f>
    800054fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005500:	2701                	sext.w	a4,a4
    80005502:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005504:	472d                	li	a4,11
    80005506:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005508:	473d                	li	a4,15
    8000550a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000550c:	6705                	lui	a4,0x1
    8000550e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005510:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005514:	5bdc                	lw	a5,52(a5)
    80005516:	2781                	sext.w	a5,a5
  if(max == 0)
    80005518:	c7d9                	beqz	a5,800055a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000551a:	471d                	li	a4,7
    8000551c:	08f77d63          	bgeu	a4,a5,800055b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005520:	100014b7          	lui	s1,0x10001
    80005524:	47a1                	li	a5,8
    80005526:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005528:	6609                	lui	a2,0x2
    8000552a:	4581                	li	a1,0
    8000552c:	00116517          	auipc	a0,0x116
    80005530:	ad450513          	addi	a0,a0,-1324 # 8011b000 <disk>
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	e72080e7          	jalr	-398(ra) # 800003a6 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000553c:	00116717          	auipc	a4,0x116
    80005540:	ac470713          	addi	a4,a4,-1340 # 8011b000 <disk>
    80005544:	00c75793          	srli	a5,a4,0xc
    80005548:	2781                	sext.w	a5,a5
    8000554a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000554c:	00118797          	auipc	a5,0x118
    80005550:	ab478793          	addi	a5,a5,-1356 # 8011d000 <disk+0x2000>
    80005554:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005556:	00116717          	auipc	a4,0x116
    8000555a:	b2a70713          	addi	a4,a4,-1238 # 8011b080 <disk+0x80>
    8000555e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005560:	00117717          	auipc	a4,0x117
    80005564:	aa070713          	addi	a4,a4,-1376 # 8011c000 <disk+0x1000>
    80005568:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000556a:	4705                	li	a4,1
    8000556c:	00e78c23          	sb	a4,24(a5)
    80005570:	00e78ca3          	sb	a4,25(a5)
    80005574:	00e78d23          	sb	a4,26(a5)
    80005578:	00e78da3          	sb	a4,27(a5)
    8000557c:	00e78e23          	sb	a4,28(a5)
    80005580:	00e78ea3          	sb	a4,29(a5)
    80005584:	00e78f23          	sb	a4,30(a5)
    80005588:	00e78fa3          	sb	a4,31(a5)
}
    8000558c:	60e2                	ld	ra,24(sp)
    8000558e:	6442                	ld	s0,16(sp)
    80005590:	64a2                	ld	s1,8(sp)
    80005592:	6105                	addi	sp,sp,32
    80005594:	8082                	ret
    panic("could not find virtio disk");
    80005596:	00003517          	auipc	a0,0x3
    8000559a:	1ba50513          	addi	a0,a0,442 # 80008750 <syscalls+0x350>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	8ea080e7          	jalr	-1814(ra) # 80005e88 <panic>
    panic("virtio disk has no queue 0");
    800055a6:	00003517          	auipc	a0,0x3
    800055aa:	1ca50513          	addi	a0,a0,458 # 80008770 <syscalls+0x370>
    800055ae:	00001097          	auipc	ra,0x1
    800055b2:	8da080e7          	jalr	-1830(ra) # 80005e88 <panic>
    panic("virtio disk max queue too short");
    800055b6:	00003517          	auipc	a0,0x3
    800055ba:	1da50513          	addi	a0,a0,474 # 80008790 <syscalls+0x390>
    800055be:	00001097          	auipc	ra,0x1
    800055c2:	8ca080e7          	jalr	-1846(ra) # 80005e88 <panic>

00000000800055c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055c6:	7159                	addi	sp,sp,-112
    800055c8:	f486                	sd	ra,104(sp)
    800055ca:	f0a2                	sd	s0,96(sp)
    800055cc:	eca6                	sd	s1,88(sp)
    800055ce:	e8ca                	sd	s2,80(sp)
    800055d0:	e4ce                	sd	s3,72(sp)
    800055d2:	e0d2                	sd	s4,64(sp)
    800055d4:	fc56                	sd	s5,56(sp)
    800055d6:	f85a                	sd	s6,48(sp)
    800055d8:	f45e                	sd	s7,40(sp)
    800055da:	f062                	sd	s8,32(sp)
    800055dc:	ec66                	sd	s9,24(sp)
    800055de:	e86a                	sd	s10,16(sp)
    800055e0:	1880                	addi	s0,sp,112
    800055e2:	892a                	mv	s2,a0
    800055e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055e6:	00c52c83          	lw	s9,12(a0)
    800055ea:	001c9c9b          	slliw	s9,s9,0x1
    800055ee:	1c82                	slli	s9,s9,0x20
    800055f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055f4:	00118517          	auipc	a0,0x118
    800055f8:	b3450513          	addi	a0,a0,-1228 # 8011d128 <disk+0x2128>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	dd6080e7          	jalr	-554(ra) # 800063d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005604:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005606:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005608:	00116b97          	auipc	s7,0x116
    8000560c:	9f8b8b93          	addi	s7,s7,-1544 # 8011b000 <disk>
    80005610:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005612:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005614:	8a4e                	mv	s4,s3
    80005616:	a051                	j	8000569a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005618:	00fb86b3          	add	a3,s7,a5
    8000561c:	96da                	add	a3,a3,s6
    8000561e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005622:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005624:	0207c563          	bltz	a5,8000564e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005628:	2485                	addiw	s1,s1,1
    8000562a:	0711                	addi	a4,a4,4
    8000562c:	25548063          	beq	s1,s5,8000586c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005630:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005632:	00118697          	auipc	a3,0x118
    80005636:	9e668693          	addi	a3,a3,-1562 # 8011d018 <disk+0x2018>
    8000563a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000563c:	0006c583          	lbu	a1,0(a3)
    80005640:	fde1                	bnez	a1,80005618 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005642:	2785                	addiw	a5,a5,1
    80005644:	0685                	addi	a3,a3,1
    80005646:	ff879be3          	bne	a5,s8,8000563c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000564a:	57fd                	li	a5,-1
    8000564c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000564e:	02905a63          	blez	s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005652:	f9042503          	lw	a0,-112(s0)
    80005656:	00000097          	auipc	ra,0x0
    8000565a:	d90080e7          	jalr	-624(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000565e:	4785                	li	a5,1
    80005660:	0297d163          	bge	a5,s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005664:	f9442503          	lw	a0,-108(s0)
    80005668:	00000097          	auipc	ra,0x0
    8000566c:	d7e080e7          	jalr	-642(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005670:	4789                	li	a5,2
    80005672:	0097d863          	bge	a5,s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005676:	f9842503          	lw	a0,-104(s0)
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	d6c080e7          	jalr	-660(ra) # 800053e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005682:	00118597          	auipc	a1,0x118
    80005686:	aa658593          	addi	a1,a1,-1370 # 8011d128 <disk+0x2128>
    8000568a:	00118517          	auipc	a0,0x118
    8000568e:	98e50513          	addi	a0,a0,-1650 # 8011d018 <disk+0x2018>
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	0cc080e7          	jalr	204(ra) # 8000175e <sleep>
  for(int i = 0; i < 3; i++){
    8000569a:	f9040713          	addi	a4,s0,-112
    8000569e:	84ce                	mv	s1,s3
    800056a0:	bf41                	j	80005630 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056a2:	20058713          	addi	a4,a1,512
    800056a6:	00471693          	slli	a3,a4,0x4
    800056aa:	00116717          	auipc	a4,0x116
    800056ae:	95670713          	addi	a4,a4,-1706 # 8011b000 <disk>
    800056b2:	9736                	add	a4,a4,a3
    800056b4:	4685                	li	a3,1
    800056b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056ba:	20058713          	addi	a4,a1,512
    800056be:	00471693          	slli	a3,a4,0x4
    800056c2:	00116717          	auipc	a4,0x116
    800056c6:	93e70713          	addi	a4,a4,-1730 # 8011b000 <disk>
    800056ca:	9736                	add	a4,a4,a3
    800056cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800056d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056d4:	7679                	lui	a2,0xffffe
    800056d6:	963e                	add	a2,a2,a5
    800056d8:	00118697          	auipc	a3,0x118
    800056dc:	92868693          	addi	a3,a3,-1752 # 8011d000 <disk+0x2000>
    800056e0:	6298                	ld	a4,0(a3)
    800056e2:	9732                	add	a4,a4,a2
    800056e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056e6:	6298                	ld	a4,0(a3)
    800056e8:	9732                	add	a4,a4,a2
    800056ea:	4541                	li	a0,16
    800056ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056ee:	6298                	ld	a4,0(a3)
    800056f0:	9732                	add	a4,a4,a2
    800056f2:	4505                	li	a0,1
    800056f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800056f8:	f9442703          	lw	a4,-108(s0)
    800056fc:	6288                	ld	a0,0(a3)
    800056fe:	962a                	add	a2,a2,a0
    80005700:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fed7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005704:	0712                	slli	a4,a4,0x4
    80005706:	6290                	ld	a2,0(a3)
    80005708:	963a                	add	a2,a2,a4
    8000570a:	05890513          	addi	a0,s2,88
    8000570e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005710:	6294                	ld	a3,0(a3)
    80005712:	96ba                	add	a3,a3,a4
    80005714:	40000613          	li	a2,1024
    80005718:	c690                	sw	a2,8(a3)
  if(write)
    8000571a:	140d0063          	beqz	s10,8000585a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000571e:	00118697          	auipc	a3,0x118
    80005722:	8e26b683          	ld	a3,-1822(a3) # 8011d000 <disk+0x2000>
    80005726:	96ba                	add	a3,a3,a4
    80005728:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000572c:	00116817          	auipc	a6,0x116
    80005730:	8d480813          	addi	a6,a6,-1836 # 8011b000 <disk>
    80005734:	00118517          	auipc	a0,0x118
    80005738:	8cc50513          	addi	a0,a0,-1844 # 8011d000 <disk+0x2000>
    8000573c:	6114                	ld	a3,0(a0)
    8000573e:	96ba                	add	a3,a3,a4
    80005740:	00c6d603          	lhu	a2,12(a3)
    80005744:	00166613          	ori	a2,a2,1
    80005748:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000574c:	f9842683          	lw	a3,-104(s0)
    80005750:	6110                	ld	a2,0(a0)
    80005752:	9732                	add	a4,a4,a2
    80005754:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005758:	20058613          	addi	a2,a1,512
    8000575c:	0612                	slli	a2,a2,0x4
    8000575e:	9642                	add	a2,a2,a6
    80005760:	577d                	li	a4,-1
    80005762:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005766:	00469713          	slli	a4,a3,0x4
    8000576a:	6114                	ld	a3,0(a0)
    8000576c:	96ba                	add	a3,a3,a4
    8000576e:	03078793          	addi	a5,a5,48
    80005772:	97c2                	add	a5,a5,a6
    80005774:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005776:	611c                	ld	a5,0(a0)
    80005778:	97ba                	add	a5,a5,a4
    8000577a:	4685                	li	a3,1
    8000577c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000577e:	611c                	ld	a5,0(a0)
    80005780:	97ba                	add	a5,a5,a4
    80005782:	4809                	li	a6,2
    80005784:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005788:	611c                	ld	a5,0(a0)
    8000578a:	973e                	add	a4,a4,a5
    8000578c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005790:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005794:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005798:	6518                	ld	a4,8(a0)
    8000579a:	00275783          	lhu	a5,2(a4)
    8000579e:	8b9d                	andi	a5,a5,7
    800057a0:	0786                	slli	a5,a5,0x1
    800057a2:	97ba                	add	a5,a5,a4
    800057a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ac:	6518                	ld	a4,8(a0)
    800057ae:	00275783          	lhu	a5,2(a4)
    800057b2:	2785                	addiw	a5,a5,1
    800057b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057bc:	100017b7          	lui	a5,0x10001
    800057c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057c4:	00492703          	lw	a4,4(s2)
    800057c8:	4785                	li	a5,1
    800057ca:	02f71163          	bne	a4,a5,800057ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800057ce:	00118997          	auipc	s3,0x118
    800057d2:	95a98993          	addi	s3,s3,-1702 # 8011d128 <disk+0x2128>
  while(b->disk == 1) {
    800057d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057d8:	85ce                	mv	a1,s3
    800057da:	854a                	mv	a0,s2
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	f82080e7          	jalr	-126(ra) # 8000175e <sleep>
  while(b->disk == 1) {
    800057e4:	00492783          	lw	a5,4(s2)
    800057e8:	fe9788e3          	beq	a5,s1,800057d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800057ec:	f9042903          	lw	s2,-112(s0)
    800057f0:	20090793          	addi	a5,s2,512
    800057f4:	00479713          	slli	a4,a5,0x4
    800057f8:	00116797          	auipc	a5,0x116
    800057fc:	80878793          	addi	a5,a5,-2040 # 8011b000 <disk>
    80005800:	97ba                	add	a5,a5,a4
    80005802:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005806:	00117997          	auipc	s3,0x117
    8000580a:	7fa98993          	addi	s3,s3,2042 # 8011d000 <disk+0x2000>
    8000580e:	00491713          	slli	a4,s2,0x4
    80005812:	0009b783          	ld	a5,0(s3)
    80005816:	97ba                	add	a5,a5,a4
    80005818:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000581c:	854a                	mv	a0,s2
    8000581e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005822:	00000097          	auipc	ra,0x0
    80005826:	bc4080e7          	jalr	-1084(ra) # 800053e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000582a:	8885                	andi	s1,s1,1
    8000582c:	f0ed                	bnez	s1,8000580e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000582e:	00118517          	auipc	a0,0x118
    80005832:	8fa50513          	addi	a0,a0,-1798 # 8011d128 <disk+0x2128>
    80005836:	00001097          	auipc	ra,0x1
    8000583a:	c50080e7          	jalr	-944(ra) # 80006486 <release>
}
    8000583e:	70a6                	ld	ra,104(sp)
    80005840:	7406                	ld	s0,96(sp)
    80005842:	64e6                	ld	s1,88(sp)
    80005844:	6946                	ld	s2,80(sp)
    80005846:	69a6                	ld	s3,72(sp)
    80005848:	6a06                	ld	s4,64(sp)
    8000584a:	7ae2                	ld	s5,56(sp)
    8000584c:	7b42                	ld	s6,48(sp)
    8000584e:	7ba2                	ld	s7,40(sp)
    80005850:	7c02                	ld	s8,32(sp)
    80005852:	6ce2                	ld	s9,24(sp)
    80005854:	6d42                	ld	s10,16(sp)
    80005856:	6165                	addi	sp,sp,112
    80005858:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000585a:	00117697          	auipc	a3,0x117
    8000585e:	7a66b683          	ld	a3,1958(a3) # 8011d000 <disk+0x2000>
    80005862:	96ba                	add	a3,a3,a4
    80005864:	4609                	li	a2,2
    80005866:	00c69623          	sh	a2,12(a3)
    8000586a:	b5c9                	j	8000572c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000586c:	f9042583          	lw	a1,-112(s0)
    80005870:	20058793          	addi	a5,a1,512
    80005874:	0792                	slli	a5,a5,0x4
    80005876:	00116517          	auipc	a0,0x116
    8000587a:	83250513          	addi	a0,a0,-1998 # 8011b0a8 <disk+0xa8>
    8000587e:	953e                	add	a0,a0,a5
  if(write)
    80005880:	e20d11e3          	bnez	s10,800056a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005884:	20058713          	addi	a4,a1,512
    80005888:	00471693          	slli	a3,a4,0x4
    8000588c:	00115717          	auipc	a4,0x115
    80005890:	77470713          	addi	a4,a4,1908 # 8011b000 <disk>
    80005894:	9736                	add	a4,a4,a3
    80005896:	0a072423          	sw	zero,168(a4)
    8000589a:	b505                	j	800056ba <virtio_disk_rw+0xf4>

000000008000589c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000589c:	1101                	addi	sp,sp,-32
    8000589e:	ec06                	sd	ra,24(sp)
    800058a0:	e822                	sd	s0,16(sp)
    800058a2:	e426                	sd	s1,8(sp)
    800058a4:	e04a                	sd	s2,0(sp)
    800058a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058a8:	00118517          	auipc	a0,0x118
    800058ac:	88050513          	addi	a0,a0,-1920 # 8011d128 <disk+0x2128>
    800058b0:	00001097          	auipc	ra,0x1
    800058b4:	b22080e7          	jalr	-1246(ra) # 800063d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b8:	10001737          	lui	a4,0x10001
    800058bc:	533c                	lw	a5,96(a4)
    800058be:	8b8d                	andi	a5,a5,3
    800058c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058c6:	00117797          	auipc	a5,0x117
    800058ca:	73a78793          	addi	a5,a5,1850 # 8011d000 <disk+0x2000>
    800058ce:	6b94                	ld	a3,16(a5)
    800058d0:	0207d703          	lhu	a4,32(a5)
    800058d4:	0026d783          	lhu	a5,2(a3)
    800058d8:	06f70163          	beq	a4,a5,8000593a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058dc:	00115917          	auipc	s2,0x115
    800058e0:	72490913          	addi	s2,s2,1828 # 8011b000 <disk>
    800058e4:	00117497          	auipc	s1,0x117
    800058e8:	71c48493          	addi	s1,s1,1820 # 8011d000 <disk+0x2000>
    __sync_synchronize();
    800058ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f0:	6898                	ld	a4,16(s1)
    800058f2:	0204d783          	lhu	a5,32(s1)
    800058f6:	8b9d                	andi	a5,a5,7
    800058f8:	078e                	slli	a5,a5,0x3
    800058fa:	97ba                	add	a5,a5,a4
    800058fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058fe:	20078713          	addi	a4,a5,512
    80005902:	0712                	slli	a4,a4,0x4
    80005904:	974a                	add	a4,a4,s2
    80005906:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000590a:	e731                	bnez	a4,80005956 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000590c:	20078793          	addi	a5,a5,512
    80005910:	0792                	slli	a5,a5,0x4
    80005912:	97ca                	add	a5,a5,s2
    80005914:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005916:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000591a:	ffffc097          	auipc	ra,0xffffc
    8000591e:	fd0080e7          	jalr	-48(ra) # 800018ea <wakeup>

    disk.used_idx += 1;
    80005922:	0204d783          	lhu	a5,32(s1)
    80005926:	2785                	addiw	a5,a5,1
    80005928:	17c2                	slli	a5,a5,0x30
    8000592a:	93c1                	srli	a5,a5,0x30
    8000592c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005930:	6898                	ld	a4,16(s1)
    80005932:	00275703          	lhu	a4,2(a4)
    80005936:	faf71be3          	bne	a4,a5,800058ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000593a:	00117517          	auipc	a0,0x117
    8000593e:	7ee50513          	addi	a0,a0,2030 # 8011d128 <disk+0x2128>
    80005942:	00001097          	auipc	ra,0x1
    80005946:	b44080e7          	jalr	-1212(ra) # 80006486 <release>
}
    8000594a:	60e2                	ld	ra,24(sp)
    8000594c:	6442                	ld	s0,16(sp)
    8000594e:	64a2                	ld	s1,8(sp)
    80005950:	6902                	ld	s2,0(sp)
    80005952:	6105                	addi	sp,sp,32
    80005954:	8082                	ret
      panic("virtio_disk_intr status");
    80005956:	00003517          	auipc	a0,0x3
    8000595a:	e5a50513          	addi	a0,a0,-422 # 800087b0 <syscalls+0x3b0>
    8000595e:	00000097          	auipc	ra,0x0
    80005962:	52a080e7          	jalr	1322(ra) # 80005e88 <panic>

0000000080005966 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005966:	1141                	addi	sp,sp,-16
    80005968:	e422                	sd	s0,8(sp)
    8000596a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x));
    8000596c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005970:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005974:	0037979b          	slliw	a5,a5,0x3
    80005978:	02004737          	lui	a4,0x2004
    8000597c:	97ba                	add	a5,a5,a4
    8000597e:	0200c737          	lui	a4,0x200c
    80005982:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005986:	000f4637          	lui	a2,0xf4
    8000598a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000598e:	95b2                	add	a1,a1,a2
    80005990:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005992:	00269713          	slli	a4,a3,0x2
    80005996:	9736                	add	a4,a4,a3
    80005998:	00371693          	slli	a3,a4,0x3
    8000599c:	00118717          	auipc	a4,0x118
    800059a0:	66470713          	addi	a4,a4,1636 # 8011e000 <timer_scratch>
    800059a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059ae:	00000797          	auipc	a5,0x0
    800059b2:	97278793          	addi	a5,a5,-1678 # 80005320 <timervec>
    800059b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x));
    800059ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x));
    800059c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059ce:	30479073          	csrw	mie,a5
}
    800059d2:	6422                	ld	s0,8(sp)
    800059d4:	0141                	addi	sp,sp,16
    800059d6:	8082                	ret

00000000800059d8 <start>:
{
    800059d8:	1141                	addi	sp,sp,-16
    800059da:	e406                	sd	ra,8(sp)
    800059dc:	e022                	sd	s0,0(sp)
    800059de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x));
    800059e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059e4:	7779                	lui	a4,0xffffe
    800059e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fed85bf>
    800059ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059ec:	6705                	lui	a4,0x1
    800059ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059f8:	ffffb797          	auipc	a5,0xffffb
    800059fc:	b5c78793          	addi	a5,a5,-1188 # 80000554 <main>
    80005a00:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a04:	4781                	li	a5,0
    80005a06:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a0a:	67c1                	lui	a5,0x10
    80005a0c:	17fd                	addi	a5,a5,-1
    80005a0e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a12:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x));
    80005a16:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a1a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a1e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a22:	57fd                	li	a5,-1
    80005a24:	83a9                	srli	a5,a5,0xa
    80005a26:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a2a:	47bd                	li	a5,15
    80005a2c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a30:	00000097          	auipc	ra,0x0
    80005a34:	f36080e7          	jalr	-202(ra) # 80005966 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x));
    80005a38:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a3c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a3e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a40:	30200073          	mret
}
    80005a44:	60a2                	ld	ra,8(sp)
    80005a46:	6402                	ld	s0,0(sp)
    80005a48:	0141                	addi	sp,sp,16
    80005a4a:	8082                	ret

0000000080005a4c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a4c:	715d                	addi	sp,sp,-80
    80005a4e:	e486                	sd	ra,72(sp)
    80005a50:	e0a2                	sd	s0,64(sp)
    80005a52:	fc26                	sd	s1,56(sp)
    80005a54:	f84a                	sd	s2,48(sp)
    80005a56:	f44e                	sd	s3,40(sp)
    80005a58:	f052                	sd	s4,32(sp)
    80005a5a:	ec56                	sd	s5,24(sp)
    80005a5c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a5e:	04c05663          	blez	a2,80005aaa <consolewrite+0x5e>
    80005a62:	8a2a                	mv	s4,a0
    80005a64:	84ae                	mv	s1,a1
    80005a66:	89b2                	mv	s3,a2
    80005a68:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a6a:	5afd                	li	s5,-1
    80005a6c:	4685                	li	a3,1
    80005a6e:	8626                	mv	a2,s1
    80005a70:	85d2                	mv	a1,s4
    80005a72:	fbf40513          	addi	a0,s0,-65
    80005a76:	ffffc097          	auipc	ra,0xffffc
    80005a7a:	0e2080e7          	jalr	226(ra) # 80001b58 <either_copyin>
    80005a7e:	01550c63          	beq	a0,s5,80005a96 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a82:	fbf44503          	lbu	a0,-65(s0)
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	78e080e7          	jalr	1934(ra) # 80006214 <uartputc>
  for(i = 0; i < n; i++){
    80005a8e:	2905                	addiw	s2,s2,1
    80005a90:	0485                	addi	s1,s1,1
    80005a92:	fd299de3          	bne	s3,s2,80005a6c <consolewrite+0x20>
  }

  return i;
}
    80005a96:	854a                	mv	a0,s2
    80005a98:	60a6                	ld	ra,72(sp)
    80005a9a:	6406                	ld	s0,64(sp)
    80005a9c:	74e2                	ld	s1,56(sp)
    80005a9e:	7942                	ld	s2,48(sp)
    80005aa0:	79a2                	ld	s3,40(sp)
    80005aa2:	7a02                	ld	s4,32(sp)
    80005aa4:	6ae2                	ld	s5,24(sp)
    80005aa6:	6161                	addi	sp,sp,80
    80005aa8:	8082                	ret
  for(i = 0; i < n; i++){
    80005aaa:	4901                	li	s2,0
    80005aac:	b7ed                	j	80005a96 <consolewrite+0x4a>

0000000080005aae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aae:	7119                	addi	sp,sp,-128
    80005ab0:	fc86                	sd	ra,120(sp)
    80005ab2:	f8a2                	sd	s0,112(sp)
    80005ab4:	f4a6                	sd	s1,104(sp)
    80005ab6:	f0ca                	sd	s2,96(sp)
    80005ab8:	ecce                	sd	s3,88(sp)
    80005aba:	e8d2                	sd	s4,80(sp)
    80005abc:	e4d6                	sd	s5,72(sp)
    80005abe:	e0da                	sd	s6,64(sp)
    80005ac0:	fc5e                	sd	s7,56(sp)
    80005ac2:	f862                	sd	s8,48(sp)
    80005ac4:	f466                	sd	s9,40(sp)
    80005ac6:	f06a                	sd	s10,32(sp)
    80005ac8:	ec6e                	sd	s11,24(sp)
    80005aca:	0100                	addi	s0,sp,128
    80005acc:	8b2a                	mv	s6,a0
    80005ace:	8aae                	mv	s5,a1
    80005ad0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ad2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005ad6:	00120517          	auipc	a0,0x120
    80005ada:	66a50513          	addi	a0,a0,1642 # 80126140 <cons>
    80005ade:	00001097          	auipc	ra,0x1
    80005ae2:	8f4080e7          	jalr	-1804(ra) # 800063d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ae6:	00120497          	auipc	s1,0x120
    80005aea:	65a48493          	addi	s1,s1,1626 # 80126140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005aee:	89a6                	mv	s3,s1
    80005af0:	00120917          	auipc	s2,0x120
    80005af4:	6e890913          	addi	s2,s2,1768 # 801261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005af8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005afa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005afc:	4da9                	li	s11,10
  while(n > 0){
    80005afe:	07405863          	blez	s4,80005b6e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005b02:	0984a783          	lw	a5,152(s1)
    80005b06:	09c4a703          	lw	a4,156(s1)
    80005b0a:	02f71463          	bne	a4,a5,80005b32 <consoleread+0x84>
      if(myproc()->killed){
    80005b0e:	ffffb097          	auipc	ra,0xffffb
    80005b12:	594080e7          	jalr	1428(ra) # 800010a2 <myproc>
    80005b16:	551c                	lw	a5,40(a0)
    80005b18:	e7b5                	bnez	a5,80005b84 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005b1a:	85ce                	mv	a1,s3
    80005b1c:	854a                	mv	a0,s2
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	c40080e7          	jalr	-960(ra) # 8000175e <sleep>
    while(cons.r == cons.w){
    80005b26:	0984a783          	lw	a5,152(s1)
    80005b2a:	09c4a703          	lw	a4,156(s1)
    80005b2e:	fef700e3          	beq	a4,a5,80005b0e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b32:	0017871b          	addiw	a4,a5,1
    80005b36:	08e4ac23          	sw	a4,152(s1)
    80005b3a:	07f7f713          	andi	a4,a5,127
    80005b3e:	9726                	add	a4,a4,s1
    80005b40:	01874703          	lbu	a4,24(a4)
    80005b44:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b48:	079c0663          	beq	s8,s9,80005bb4 <consoleread+0x106>
    cbuf = c;
    80005b4c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b50:	4685                	li	a3,1
    80005b52:	f8f40613          	addi	a2,s0,-113
    80005b56:	85d6                	mv	a1,s5
    80005b58:	855a                	mv	a0,s6
    80005b5a:	ffffc097          	auipc	ra,0xffffc
    80005b5e:	fa8080e7          	jalr	-88(ra) # 80001b02 <either_copyout>
    80005b62:	01a50663          	beq	a0,s10,80005b6e <consoleread+0xc0>
    dst++;
    80005b66:	0a85                	addi	s5,s5,1
    --n;
    80005b68:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b6a:	f9bc1ae3          	bne	s8,s11,80005afe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b6e:	00120517          	auipc	a0,0x120
    80005b72:	5d250513          	addi	a0,a0,1490 # 80126140 <cons>
    80005b76:	00001097          	auipc	ra,0x1
    80005b7a:	910080e7          	jalr	-1776(ra) # 80006486 <release>

  return target - n;
    80005b7e:	414b853b          	subw	a0,s7,s4
    80005b82:	a811                	j	80005b96 <consoleread+0xe8>
        release(&cons.lock);
    80005b84:	00120517          	auipc	a0,0x120
    80005b88:	5bc50513          	addi	a0,a0,1468 # 80126140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	8fa080e7          	jalr	-1798(ra) # 80006486 <release>
        return -1;
    80005b94:	557d                	li	a0,-1
}
    80005b96:	70e6                	ld	ra,120(sp)
    80005b98:	7446                	ld	s0,112(sp)
    80005b9a:	74a6                	ld	s1,104(sp)
    80005b9c:	7906                	ld	s2,96(sp)
    80005b9e:	69e6                	ld	s3,88(sp)
    80005ba0:	6a46                	ld	s4,80(sp)
    80005ba2:	6aa6                	ld	s5,72(sp)
    80005ba4:	6b06                	ld	s6,64(sp)
    80005ba6:	7be2                	ld	s7,56(sp)
    80005ba8:	7c42                	ld	s8,48(sp)
    80005baa:	7ca2                	ld	s9,40(sp)
    80005bac:	7d02                	ld	s10,32(sp)
    80005bae:	6de2                	ld	s11,24(sp)
    80005bb0:	6109                	addi	sp,sp,128
    80005bb2:	8082                	ret
      if(n < target){
    80005bb4:	000a071b          	sext.w	a4,s4
    80005bb8:	fb777be3          	bgeu	a4,s7,80005b6e <consoleread+0xc0>
        cons.r--;
    80005bbc:	00120717          	auipc	a4,0x120
    80005bc0:	60f72e23          	sw	a5,1564(a4) # 801261d8 <cons+0x98>
    80005bc4:	b76d                	j	80005b6e <consoleread+0xc0>

0000000080005bc6 <consputc>:
{
    80005bc6:	1141                	addi	sp,sp,-16
    80005bc8:	e406                	sd	ra,8(sp)
    80005bca:	e022                	sd	s0,0(sp)
    80005bcc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bce:	10000793          	li	a5,256
    80005bd2:	00f50a63          	beq	a0,a5,80005be6 <consputc+0x20>
    uartputc_sync(c);
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	564080e7          	jalr	1380(ra) # 8000613a <uartputc_sync>
}
    80005bde:	60a2                	ld	ra,8(sp)
    80005be0:	6402                	ld	s0,0(sp)
    80005be2:	0141                	addi	sp,sp,16
    80005be4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be6:	4521                	li	a0,8
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	552080e7          	jalr	1362(ra) # 8000613a <uartputc_sync>
    80005bf0:	02000513          	li	a0,32
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	546080e7          	jalr	1350(ra) # 8000613a <uartputc_sync>
    80005bfc:	4521                	li	a0,8
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	53c080e7          	jalr	1340(ra) # 8000613a <uartputc_sync>
    80005c06:	bfe1                	j	80005bde <consputc+0x18>

0000000080005c08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c08:	1101                	addi	sp,sp,-32
    80005c0a:	ec06                	sd	ra,24(sp)
    80005c0c:	e822                	sd	s0,16(sp)
    80005c0e:	e426                	sd	s1,8(sp)
    80005c10:	e04a                	sd	s2,0(sp)
    80005c12:	1000                	addi	s0,sp,32
    80005c14:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c16:	00120517          	auipc	a0,0x120
    80005c1a:	52a50513          	addi	a0,a0,1322 # 80126140 <cons>
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	7b4080e7          	jalr	1972(ra) # 800063d2 <acquire>

  switch(c){
    80005c26:	47d5                	li	a5,21
    80005c28:	0af48663          	beq	s1,a5,80005cd4 <consoleintr+0xcc>
    80005c2c:	0297ca63          	blt	a5,s1,80005c60 <consoleintr+0x58>
    80005c30:	47a1                	li	a5,8
    80005c32:	0ef48763          	beq	s1,a5,80005d20 <consoleintr+0x118>
    80005c36:	47c1                	li	a5,16
    80005c38:	10f49a63          	bne	s1,a5,80005d4c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c3c:	ffffc097          	auipc	ra,0xffffc
    80005c40:	f72080e7          	jalr	-142(ra) # 80001bae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c44:	00120517          	auipc	a0,0x120
    80005c48:	4fc50513          	addi	a0,a0,1276 # 80126140 <cons>
    80005c4c:	00001097          	auipc	ra,0x1
    80005c50:	83a080e7          	jalr	-1990(ra) # 80006486 <release>
}
    80005c54:	60e2                	ld	ra,24(sp)
    80005c56:	6442                	ld	s0,16(sp)
    80005c58:	64a2                	ld	s1,8(sp)
    80005c5a:	6902                	ld	s2,0(sp)
    80005c5c:	6105                	addi	sp,sp,32
    80005c5e:	8082                	ret
  switch(c){
    80005c60:	07f00793          	li	a5,127
    80005c64:	0af48e63          	beq	s1,a5,80005d20 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c68:	00120717          	auipc	a4,0x120
    80005c6c:	4d870713          	addi	a4,a4,1240 # 80126140 <cons>
    80005c70:	0a072783          	lw	a5,160(a4)
    80005c74:	09872703          	lw	a4,152(a4)
    80005c78:	9f99                	subw	a5,a5,a4
    80005c7a:	07f00713          	li	a4,127
    80005c7e:	fcf763e3          	bltu	a4,a5,80005c44 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c82:	47b5                	li	a5,13
    80005c84:	0cf48763          	beq	s1,a5,80005d52 <consoleintr+0x14a>
      consputc(c);
    80005c88:	8526                	mv	a0,s1
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	f3c080e7          	jalr	-196(ra) # 80005bc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c92:	00120797          	auipc	a5,0x120
    80005c96:	4ae78793          	addi	a5,a5,1198 # 80126140 <cons>
    80005c9a:	0a07a703          	lw	a4,160(a5)
    80005c9e:	0017069b          	addiw	a3,a4,1
    80005ca2:	0006861b          	sext.w	a2,a3
    80005ca6:	0ad7a023          	sw	a3,160(a5)
    80005caa:	07f77713          	andi	a4,a4,127
    80005cae:	97ba                	add	a5,a5,a4
    80005cb0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cb4:	47a9                	li	a5,10
    80005cb6:	0cf48563          	beq	s1,a5,80005d80 <consoleintr+0x178>
    80005cba:	4791                	li	a5,4
    80005cbc:	0cf48263          	beq	s1,a5,80005d80 <consoleintr+0x178>
    80005cc0:	00120797          	auipc	a5,0x120
    80005cc4:	5187a783          	lw	a5,1304(a5) # 801261d8 <cons+0x98>
    80005cc8:	0807879b          	addiw	a5,a5,128
    80005ccc:	f6f61ce3          	bne	a2,a5,80005c44 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cd0:	863e                	mv	a2,a5
    80005cd2:	a07d                	j	80005d80 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cd4:	00120717          	auipc	a4,0x120
    80005cd8:	46c70713          	addi	a4,a4,1132 # 80126140 <cons>
    80005cdc:	0a072783          	lw	a5,160(a4)
    80005ce0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ce4:	00120497          	auipc	s1,0x120
    80005ce8:	45c48493          	addi	s1,s1,1116 # 80126140 <cons>
    while(cons.e != cons.w &&
    80005cec:	4929                	li	s2,10
    80005cee:	f4f70be3          	beq	a4,a5,80005c44 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cf2:	37fd                	addiw	a5,a5,-1
    80005cf4:	07f7f713          	andi	a4,a5,127
    80005cf8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cfa:	01874703          	lbu	a4,24(a4)
    80005cfe:	f52703e3          	beq	a4,s2,80005c44 <consoleintr+0x3c>
      cons.e--;
    80005d02:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d06:	10000513          	li	a0,256
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	ebc080e7          	jalr	-324(ra) # 80005bc6 <consputc>
    while(cons.e != cons.w &&
    80005d12:	0a04a783          	lw	a5,160(s1)
    80005d16:	09c4a703          	lw	a4,156(s1)
    80005d1a:	fcf71ce3          	bne	a4,a5,80005cf2 <consoleintr+0xea>
    80005d1e:	b71d                	j	80005c44 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d20:	00120717          	auipc	a4,0x120
    80005d24:	42070713          	addi	a4,a4,1056 # 80126140 <cons>
    80005d28:	0a072783          	lw	a5,160(a4)
    80005d2c:	09c72703          	lw	a4,156(a4)
    80005d30:	f0f70ae3          	beq	a4,a5,80005c44 <consoleintr+0x3c>
      cons.e--;
    80005d34:	37fd                	addiw	a5,a5,-1
    80005d36:	00120717          	auipc	a4,0x120
    80005d3a:	4af72523          	sw	a5,1194(a4) # 801261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d3e:	10000513          	li	a0,256
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	e84080e7          	jalr	-380(ra) # 80005bc6 <consputc>
    80005d4a:	bded                	j	80005c44 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d4c:	ee048ce3          	beqz	s1,80005c44 <consoleintr+0x3c>
    80005d50:	bf21                	j	80005c68 <consoleintr+0x60>
      consputc(c);
    80005d52:	4529                	li	a0,10
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	e72080e7          	jalr	-398(ra) # 80005bc6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d5c:	00120797          	auipc	a5,0x120
    80005d60:	3e478793          	addi	a5,a5,996 # 80126140 <cons>
    80005d64:	0a07a703          	lw	a4,160(a5)
    80005d68:	0017069b          	addiw	a3,a4,1
    80005d6c:	0006861b          	sext.w	a2,a3
    80005d70:	0ad7a023          	sw	a3,160(a5)
    80005d74:	07f77713          	andi	a4,a4,127
    80005d78:	97ba                	add	a5,a5,a4
    80005d7a:	4729                	li	a4,10
    80005d7c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d80:	00120797          	auipc	a5,0x120
    80005d84:	44c7ae23          	sw	a2,1116(a5) # 801261dc <cons+0x9c>
        wakeup(&cons.r);
    80005d88:	00120517          	auipc	a0,0x120
    80005d8c:	45050513          	addi	a0,a0,1104 # 801261d8 <cons+0x98>
    80005d90:	ffffc097          	auipc	ra,0xffffc
    80005d94:	b5a080e7          	jalr	-1190(ra) # 800018ea <wakeup>
    80005d98:	b575                	j	80005c44 <consoleintr+0x3c>

0000000080005d9a <consoleinit>:

void
consoleinit(void)
{
    80005d9a:	1141                	addi	sp,sp,-16
    80005d9c:	e406                	sd	ra,8(sp)
    80005d9e:	e022                	sd	s0,0(sp)
    80005da0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005da2:	00003597          	auipc	a1,0x3
    80005da6:	a2658593          	addi	a1,a1,-1498 # 800087c8 <syscalls+0x3c8>
    80005daa:	00120517          	auipc	a0,0x120
    80005dae:	39650513          	addi	a0,a0,918 # 80126140 <cons>
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	590080e7          	jalr	1424(ra) # 80006342 <initlock>

  uartinit();
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	330080e7          	jalr	816(ra) # 800060ea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dc2:	00113797          	auipc	a5,0x113
    80005dc6:	30678793          	addi	a5,a5,774 # 801190c8 <devsw>
    80005dca:	00000717          	auipc	a4,0x0
    80005dce:	ce470713          	addi	a4,a4,-796 # 80005aae <consoleread>
    80005dd2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dd4:	00000717          	auipc	a4,0x0
    80005dd8:	c7870713          	addi	a4,a4,-904 # 80005a4c <consolewrite>
    80005ddc:	ef98                	sd	a4,24(a5)
}
    80005dde:	60a2                	ld	ra,8(sp)
    80005de0:	6402                	ld	s0,0(sp)
    80005de2:	0141                	addi	sp,sp,16
    80005de4:	8082                	ret

0000000080005de6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de6:	7179                	addi	sp,sp,-48
    80005de8:	f406                	sd	ra,40(sp)
    80005dea:	f022                	sd	s0,32(sp)
    80005dec:	ec26                	sd	s1,24(sp)
    80005dee:	e84a                	sd	s2,16(sp)
    80005df0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005df2:	c219                	beqz	a2,80005df8 <printint+0x12>
    80005df4:	08054663          	bltz	a0,80005e80 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005df8:	2501                	sext.w	a0,a0
    80005dfa:	4881                	li	a7,0
    80005dfc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e00:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e02:	2581                	sext.w	a1,a1
    80005e04:	00003617          	auipc	a2,0x3
    80005e08:	9f460613          	addi	a2,a2,-1548 # 800087f8 <digits>
    80005e0c:	883a                	mv	a6,a4
    80005e0e:	2705                	addiw	a4,a4,1
    80005e10:	02b577bb          	remuw	a5,a0,a1
    80005e14:	1782                	slli	a5,a5,0x20
    80005e16:	9381                	srli	a5,a5,0x20
    80005e18:	97b2                	add	a5,a5,a2
    80005e1a:	0007c783          	lbu	a5,0(a5)
    80005e1e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e22:	0005079b          	sext.w	a5,a0
    80005e26:	02b5553b          	divuw	a0,a0,a1
    80005e2a:	0685                	addi	a3,a3,1
    80005e2c:	feb7f0e3          	bgeu	a5,a1,80005e0c <printint+0x26>

  if(sign)
    80005e30:	00088b63          	beqz	a7,80005e46 <printint+0x60>
    buf[i++] = '-';
    80005e34:	fe040793          	addi	a5,s0,-32
    80005e38:	973e                	add	a4,a4,a5
    80005e3a:	02d00793          	li	a5,45
    80005e3e:	fef70823          	sb	a5,-16(a4)
    80005e42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e46:	02e05763          	blez	a4,80005e74 <printint+0x8e>
    80005e4a:	fd040793          	addi	a5,s0,-48
    80005e4e:	00e784b3          	add	s1,a5,a4
    80005e52:	fff78913          	addi	s2,a5,-1
    80005e56:	993a                	add	s2,s2,a4
    80005e58:	377d                	addiw	a4,a4,-1
    80005e5a:	1702                	slli	a4,a4,0x20
    80005e5c:	9301                	srli	a4,a4,0x20
    80005e5e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e62:	fff4c503          	lbu	a0,-1(s1)
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	d60080e7          	jalr	-672(ra) # 80005bc6 <consputc>
  while(--i >= 0)
    80005e6e:	14fd                	addi	s1,s1,-1
    80005e70:	ff2499e3          	bne	s1,s2,80005e62 <printint+0x7c>
}
    80005e74:	70a2                	ld	ra,40(sp)
    80005e76:	7402                	ld	s0,32(sp)
    80005e78:	64e2                	ld	s1,24(sp)
    80005e7a:	6942                	ld	s2,16(sp)
    80005e7c:	6145                	addi	sp,sp,48
    80005e7e:	8082                	ret
    x = -xx;
    80005e80:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e84:	4885                	li	a7,1
    x = -xx;
    80005e86:	bf9d                	j	80005dfc <printint+0x16>

0000000080005e88 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e88:	1101                	addi	sp,sp,-32
    80005e8a:	ec06                	sd	ra,24(sp)
    80005e8c:	e822                	sd	s0,16(sp)
    80005e8e:	e426                	sd	s1,8(sp)
    80005e90:	1000                	addi	s0,sp,32
    80005e92:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e94:	00120797          	auipc	a5,0x120
    80005e98:	3607a623          	sw	zero,876(a5) # 80126200 <pr+0x18>
  printf("panic: ");
    80005e9c:	00003517          	auipc	a0,0x3
    80005ea0:	93450513          	addi	a0,a0,-1740 # 800087d0 <syscalls+0x3d0>
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	02e080e7          	jalr	46(ra) # 80005ed2 <printf>
  printf(s);
    80005eac:	8526                	mv	a0,s1
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	024080e7          	jalr	36(ra) # 80005ed2 <printf>
  printf("\n");
    80005eb6:	00002517          	auipc	a0,0x2
    80005eba:	1ca50513          	addi	a0,a0,458 # 80008080 <etext+0x80>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	014080e7          	jalr	20(ra) # 80005ed2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ec6:	4785                	li	a5,1
    80005ec8:	00003717          	auipc	a4,0x3
    80005ecc:	14f72a23          	sw	a5,340(a4) # 8000901c <panicked>
  for(;;)
    80005ed0:	a001                	j	80005ed0 <panic+0x48>

0000000080005ed2 <printf>:
{
    80005ed2:	7131                	addi	sp,sp,-192
    80005ed4:	fc86                	sd	ra,120(sp)
    80005ed6:	f8a2                	sd	s0,112(sp)
    80005ed8:	f4a6                	sd	s1,104(sp)
    80005eda:	f0ca                	sd	s2,96(sp)
    80005edc:	ecce                	sd	s3,88(sp)
    80005ede:	e8d2                	sd	s4,80(sp)
    80005ee0:	e4d6                	sd	s5,72(sp)
    80005ee2:	e0da                	sd	s6,64(sp)
    80005ee4:	fc5e                	sd	s7,56(sp)
    80005ee6:	f862                	sd	s8,48(sp)
    80005ee8:	f466                	sd	s9,40(sp)
    80005eea:	f06a                	sd	s10,32(sp)
    80005eec:	ec6e                	sd	s11,24(sp)
    80005eee:	0100                	addi	s0,sp,128
    80005ef0:	8a2a                	mv	s4,a0
    80005ef2:	e40c                	sd	a1,8(s0)
    80005ef4:	e810                	sd	a2,16(s0)
    80005ef6:	ec14                	sd	a3,24(s0)
    80005ef8:	f018                	sd	a4,32(s0)
    80005efa:	f41c                	sd	a5,40(s0)
    80005efc:	03043823          	sd	a6,48(s0)
    80005f00:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f04:	00120d97          	auipc	s11,0x120
    80005f08:	2fcdad83          	lw	s11,764(s11) # 80126200 <pr+0x18>
  if(locking)
    80005f0c:	020d9b63          	bnez	s11,80005f42 <printf+0x70>
  if (fmt == 0)
    80005f10:	040a0263          	beqz	s4,80005f54 <printf+0x82>
  va_start(ap, fmt);
    80005f14:	00840793          	addi	a5,s0,8
    80005f18:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f1c:	000a4503          	lbu	a0,0(s4)
    80005f20:	16050263          	beqz	a0,80006084 <printf+0x1b2>
    80005f24:	4481                	li	s1,0
    if(c != '%'){
    80005f26:	02500a93          	li	s5,37
    switch(c){
    80005f2a:	07000b13          	li	s6,112
  consputc('x');
    80005f2e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f30:	00003b97          	auipc	s7,0x3
    80005f34:	8c8b8b93          	addi	s7,s7,-1848 # 800087f8 <digits>
    switch(c){
    80005f38:	07300c93          	li	s9,115
    80005f3c:	06400c13          	li	s8,100
    80005f40:	a82d                	j	80005f7a <printf+0xa8>
    acquire(&pr.lock);
    80005f42:	00120517          	auipc	a0,0x120
    80005f46:	2a650513          	addi	a0,a0,678 # 801261e8 <pr>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	488080e7          	jalr	1160(ra) # 800063d2 <acquire>
    80005f52:	bf7d                	j	80005f10 <printf+0x3e>
    panic("null fmt");
    80005f54:	00003517          	auipc	a0,0x3
    80005f58:	88c50513          	addi	a0,a0,-1908 # 800087e0 <syscalls+0x3e0>
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	f2c080e7          	jalr	-212(ra) # 80005e88 <panic>
      consputc(c);
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	c62080e7          	jalr	-926(ra) # 80005bc6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f6c:	2485                	addiw	s1,s1,1
    80005f6e:	009a07b3          	add	a5,s4,s1
    80005f72:	0007c503          	lbu	a0,0(a5)
    80005f76:	10050763          	beqz	a0,80006084 <printf+0x1b2>
    if(c != '%'){
    80005f7a:	ff5515e3          	bne	a0,s5,80005f64 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f7e:	2485                	addiw	s1,s1,1
    80005f80:	009a07b3          	add	a5,s4,s1
    80005f84:	0007c783          	lbu	a5,0(a5)
    80005f88:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f8c:	cfe5                	beqz	a5,80006084 <printf+0x1b2>
    switch(c){
    80005f8e:	05678a63          	beq	a5,s6,80005fe2 <printf+0x110>
    80005f92:	02fb7663          	bgeu	s6,a5,80005fbe <printf+0xec>
    80005f96:	09978963          	beq	a5,s9,80006028 <printf+0x156>
    80005f9a:	07800713          	li	a4,120
    80005f9e:	0ce79863          	bne	a5,a4,8000606e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005fa2:	f8843783          	ld	a5,-120(s0)
    80005fa6:	00878713          	addi	a4,a5,8
    80005faa:	f8e43423          	sd	a4,-120(s0)
    80005fae:	4605                	li	a2,1
    80005fb0:	85ea                	mv	a1,s10
    80005fb2:	4388                	lw	a0,0(a5)
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	e32080e7          	jalr	-462(ra) # 80005de6 <printint>
      break;
    80005fbc:	bf45                	j	80005f6c <printf+0x9a>
    switch(c){
    80005fbe:	0b578263          	beq	a5,s5,80006062 <printf+0x190>
    80005fc2:	0b879663          	bne	a5,s8,8000606e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fc6:	f8843783          	ld	a5,-120(s0)
    80005fca:	00878713          	addi	a4,a5,8
    80005fce:	f8e43423          	sd	a4,-120(s0)
    80005fd2:	4605                	li	a2,1
    80005fd4:	45a9                	li	a1,10
    80005fd6:	4388                	lw	a0,0(a5)
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	e0e080e7          	jalr	-498(ra) # 80005de6 <printint>
      break;
    80005fe0:	b771                	j	80005f6c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fe2:	f8843783          	ld	a5,-120(s0)
    80005fe6:	00878713          	addi	a4,a5,8
    80005fea:	f8e43423          	sd	a4,-120(s0)
    80005fee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ff2:	03000513          	li	a0,48
    80005ff6:	00000097          	auipc	ra,0x0
    80005ffa:	bd0080e7          	jalr	-1072(ra) # 80005bc6 <consputc>
  consputc('x');
    80005ffe:	07800513          	li	a0,120
    80006002:	00000097          	auipc	ra,0x0
    80006006:	bc4080e7          	jalr	-1084(ra) # 80005bc6 <consputc>
    8000600a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000600c:	03c9d793          	srli	a5,s3,0x3c
    80006010:	97de                	add	a5,a5,s7
    80006012:	0007c503          	lbu	a0,0(a5)
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	bb0080e7          	jalr	-1104(ra) # 80005bc6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000601e:	0992                	slli	s3,s3,0x4
    80006020:	397d                	addiw	s2,s2,-1
    80006022:	fe0915e3          	bnez	s2,8000600c <printf+0x13a>
    80006026:	b799                	j	80005f6c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006028:	f8843783          	ld	a5,-120(s0)
    8000602c:	00878713          	addi	a4,a5,8
    80006030:	f8e43423          	sd	a4,-120(s0)
    80006034:	0007b903          	ld	s2,0(a5)
    80006038:	00090e63          	beqz	s2,80006054 <printf+0x182>
      for(; *s; s++)
    8000603c:	00094503          	lbu	a0,0(s2)
    80006040:	d515                	beqz	a0,80005f6c <printf+0x9a>
        consputc(*s);
    80006042:	00000097          	auipc	ra,0x0
    80006046:	b84080e7          	jalr	-1148(ra) # 80005bc6 <consputc>
      for(; *s; s++)
    8000604a:	0905                	addi	s2,s2,1
    8000604c:	00094503          	lbu	a0,0(s2)
    80006050:	f96d                	bnez	a0,80006042 <printf+0x170>
    80006052:	bf29                	j	80005f6c <printf+0x9a>
        s = "(null)";
    80006054:	00002917          	auipc	s2,0x2
    80006058:	78490913          	addi	s2,s2,1924 # 800087d8 <syscalls+0x3d8>
      for(; *s; s++)
    8000605c:	02800513          	li	a0,40
    80006060:	b7cd                	j	80006042 <printf+0x170>
      consputc('%');
    80006062:	8556                	mv	a0,s5
    80006064:	00000097          	auipc	ra,0x0
    80006068:	b62080e7          	jalr	-1182(ra) # 80005bc6 <consputc>
      break;
    8000606c:	b701                	j	80005f6c <printf+0x9a>
      consputc('%');
    8000606e:	8556                	mv	a0,s5
    80006070:	00000097          	auipc	ra,0x0
    80006074:	b56080e7          	jalr	-1194(ra) # 80005bc6 <consputc>
      consputc(c);
    80006078:	854a                	mv	a0,s2
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	b4c080e7          	jalr	-1204(ra) # 80005bc6 <consputc>
      break;
    80006082:	b5ed                	j	80005f6c <printf+0x9a>
  if(locking)
    80006084:	020d9163          	bnez	s11,800060a6 <printf+0x1d4>
}
    80006088:	70e6                	ld	ra,120(sp)
    8000608a:	7446                	ld	s0,112(sp)
    8000608c:	74a6                	ld	s1,104(sp)
    8000608e:	7906                	ld	s2,96(sp)
    80006090:	69e6                	ld	s3,88(sp)
    80006092:	6a46                	ld	s4,80(sp)
    80006094:	6aa6                	ld	s5,72(sp)
    80006096:	6b06                	ld	s6,64(sp)
    80006098:	7be2                	ld	s7,56(sp)
    8000609a:	7c42                	ld	s8,48(sp)
    8000609c:	7ca2                	ld	s9,40(sp)
    8000609e:	7d02                	ld	s10,32(sp)
    800060a0:	6de2                	ld	s11,24(sp)
    800060a2:	6129                	addi	sp,sp,192
    800060a4:	8082                	ret
    release(&pr.lock);
    800060a6:	00120517          	auipc	a0,0x120
    800060aa:	14250513          	addi	a0,a0,322 # 801261e8 <pr>
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	3d8080e7          	jalr	984(ra) # 80006486 <release>
}
    800060b6:	bfc9                	j	80006088 <printf+0x1b6>

00000000800060b8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060b8:	1101                	addi	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060c2:	00120497          	auipc	s1,0x120
    800060c6:	12648493          	addi	s1,s1,294 # 801261e8 <pr>
    800060ca:	00002597          	auipc	a1,0x2
    800060ce:	72658593          	addi	a1,a1,1830 # 800087f0 <syscalls+0x3f0>
    800060d2:	8526                	mv	a0,s1
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	26e080e7          	jalr	622(ra) # 80006342 <initlock>
  pr.locking = 1;
    800060dc:	4785                	li	a5,1
    800060de:	cc9c                	sw	a5,24(s1)
}
    800060e0:	60e2                	ld	ra,24(sp)
    800060e2:	6442                	ld	s0,16(sp)
    800060e4:	64a2                	ld	s1,8(sp)
    800060e6:	6105                	addi	sp,sp,32
    800060e8:	8082                	ret

00000000800060ea <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060ea:	1141                	addi	sp,sp,-16
    800060ec:	e406                	sd	ra,8(sp)
    800060ee:	e022                	sd	s0,0(sp)
    800060f0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060f2:	100007b7          	lui	a5,0x10000
    800060f6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060fa:	f8000713          	li	a4,-128
    800060fe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006102:	470d                	li	a4,3
    80006104:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006108:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000610c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006110:	469d                	li	a3,7
    80006112:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006116:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000611a:	00002597          	auipc	a1,0x2
    8000611e:	6f658593          	addi	a1,a1,1782 # 80008810 <digits+0x18>
    80006122:	00120517          	auipc	a0,0x120
    80006126:	0e650513          	addi	a0,a0,230 # 80126208 <uart_tx_lock>
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	218080e7          	jalr	536(ra) # 80006342 <initlock>
}
    80006132:	60a2                	ld	ra,8(sp)
    80006134:	6402                	ld	s0,0(sp)
    80006136:	0141                	addi	sp,sp,16
    80006138:	8082                	ret

000000008000613a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000613a:	1101                	addi	sp,sp,-32
    8000613c:	ec06                	sd	ra,24(sp)
    8000613e:	e822                	sd	s0,16(sp)
    80006140:	e426                	sd	s1,8(sp)
    80006142:	1000                	addi	s0,sp,32
    80006144:	84aa                	mv	s1,a0
  push_off();
    80006146:	00000097          	auipc	ra,0x0
    8000614a:	240080e7          	jalr	576(ra) # 80006386 <push_off>

  if(panicked){
    8000614e:	00003797          	auipc	a5,0x3
    80006152:	ece7a783          	lw	a5,-306(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006156:	10000737          	lui	a4,0x10000
  if(panicked){
    8000615a:	c391                	beqz	a5,8000615e <uartputc_sync+0x24>
    for(;;)
    8000615c:	a001                	j	8000615c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000615e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006162:	0ff7f793          	andi	a5,a5,255
    80006166:	0207f793          	andi	a5,a5,32
    8000616a:	dbf5                	beqz	a5,8000615e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000616c:	0ff4f793          	andi	a5,s1,255
    80006170:	10000737          	lui	a4,0x10000
    80006174:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	2ae080e7          	jalr	686(ra) # 80006426 <pop_off>
}
    80006180:	60e2                	ld	ra,24(sp)
    80006182:	6442                	ld	s0,16(sp)
    80006184:	64a2                	ld	s1,8(sp)
    80006186:	6105                	addi	sp,sp,32
    80006188:	8082                	ret

000000008000618a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000618a:	00003717          	auipc	a4,0x3
    8000618e:	e9673703          	ld	a4,-362(a4) # 80009020 <uart_tx_r>
    80006192:	00003797          	auipc	a5,0x3
    80006196:	e967b783          	ld	a5,-362(a5) # 80009028 <uart_tx_w>
    8000619a:	06e78c63          	beq	a5,a4,80006212 <uartstart+0x88>
{
    8000619e:	7139                	addi	sp,sp,-64
    800061a0:	fc06                	sd	ra,56(sp)
    800061a2:	f822                	sd	s0,48(sp)
    800061a4:	f426                	sd	s1,40(sp)
    800061a6:	f04a                	sd	s2,32(sp)
    800061a8:	ec4e                	sd	s3,24(sp)
    800061aa:	e852                	sd	s4,16(sp)
    800061ac:	e456                	sd	s5,8(sp)
    800061ae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061b0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b4:	00120a17          	auipc	s4,0x120
    800061b8:	054a0a13          	addi	s4,s4,84 # 80126208 <uart_tx_lock>
    uart_tx_r += 1;
    800061bc:	00003497          	auipc	s1,0x3
    800061c0:	e6448493          	addi	s1,s1,-412 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061c4:	00003997          	auipc	s3,0x3
    800061c8:	e6498993          	addi	s3,s3,-412 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061cc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061d0:	0ff7f793          	andi	a5,a5,255
    800061d4:	0207f793          	andi	a5,a5,32
    800061d8:	c785                	beqz	a5,80006200 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061da:	01f77793          	andi	a5,a4,31
    800061de:	97d2                	add	a5,a5,s4
    800061e0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061e4:	0705                	addi	a4,a4,1
    800061e6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061e8:	8526                	mv	a0,s1
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	700080e7          	jalr	1792(ra) # 800018ea <wakeup>
    
    WriteReg(THR, c);
    800061f2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061f6:	6098                	ld	a4,0(s1)
    800061f8:	0009b783          	ld	a5,0(s3)
    800061fc:	fce798e3          	bne	a5,a4,800061cc <uartstart+0x42>
  }
}
    80006200:	70e2                	ld	ra,56(sp)
    80006202:	7442                	ld	s0,48(sp)
    80006204:	74a2                	ld	s1,40(sp)
    80006206:	7902                	ld	s2,32(sp)
    80006208:	69e2                	ld	s3,24(sp)
    8000620a:	6a42                	ld	s4,16(sp)
    8000620c:	6aa2                	ld	s5,8(sp)
    8000620e:	6121                	addi	sp,sp,64
    80006210:	8082                	ret
    80006212:	8082                	ret

0000000080006214 <uartputc>:
{
    80006214:	7179                	addi	sp,sp,-48
    80006216:	f406                	sd	ra,40(sp)
    80006218:	f022                	sd	s0,32(sp)
    8000621a:	ec26                	sd	s1,24(sp)
    8000621c:	e84a                	sd	s2,16(sp)
    8000621e:	e44e                	sd	s3,8(sp)
    80006220:	e052                	sd	s4,0(sp)
    80006222:	1800                	addi	s0,sp,48
    80006224:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006226:	00120517          	auipc	a0,0x120
    8000622a:	fe250513          	addi	a0,a0,-30 # 80126208 <uart_tx_lock>
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	1a4080e7          	jalr	420(ra) # 800063d2 <acquire>
  if(panicked){
    80006236:	00003797          	auipc	a5,0x3
    8000623a:	de67a783          	lw	a5,-538(a5) # 8000901c <panicked>
    8000623e:	c391                	beqz	a5,80006242 <uartputc+0x2e>
    for(;;)
    80006240:	a001                	j	80006240 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006242:	00003797          	auipc	a5,0x3
    80006246:	de67b783          	ld	a5,-538(a5) # 80009028 <uart_tx_w>
    8000624a:	00003717          	auipc	a4,0x3
    8000624e:	dd673703          	ld	a4,-554(a4) # 80009020 <uart_tx_r>
    80006252:	02070713          	addi	a4,a4,32
    80006256:	02f71b63          	bne	a4,a5,8000628c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000625a:	00120a17          	auipc	s4,0x120
    8000625e:	faea0a13          	addi	s4,s4,-82 # 80126208 <uart_tx_lock>
    80006262:	00003497          	auipc	s1,0x3
    80006266:	dbe48493          	addi	s1,s1,-578 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000626a:	00003917          	auipc	s2,0x3
    8000626e:	dbe90913          	addi	s2,s2,-578 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006272:	85d2                	mv	a1,s4
    80006274:	8526                	mv	a0,s1
    80006276:	ffffb097          	auipc	ra,0xffffb
    8000627a:	4e8080e7          	jalr	1256(ra) # 8000175e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627e:	00093783          	ld	a5,0(s2)
    80006282:	6098                	ld	a4,0(s1)
    80006284:	02070713          	addi	a4,a4,32
    80006288:	fef705e3          	beq	a4,a5,80006272 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000628c:	00120497          	auipc	s1,0x120
    80006290:	f7c48493          	addi	s1,s1,-132 # 80126208 <uart_tx_lock>
    80006294:	01f7f713          	andi	a4,a5,31
    80006298:	9726                	add	a4,a4,s1
    8000629a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000629e:	0785                	addi	a5,a5,1
    800062a0:	00003717          	auipc	a4,0x3
    800062a4:	d8f73423          	sd	a5,-632(a4) # 80009028 <uart_tx_w>
      uartstart();
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	ee2080e7          	jalr	-286(ra) # 8000618a <uartstart>
      release(&uart_tx_lock);
    800062b0:	8526                	mv	a0,s1
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	1d4080e7          	jalr	468(ra) # 80006486 <release>
}
    800062ba:	70a2                	ld	ra,40(sp)
    800062bc:	7402                	ld	s0,32(sp)
    800062be:	64e2                	ld	s1,24(sp)
    800062c0:	6942                	ld	s2,16(sp)
    800062c2:	69a2                	ld	s3,8(sp)
    800062c4:	6a02                	ld	s4,0(sp)
    800062c6:	6145                	addi	sp,sp,48
    800062c8:	8082                	ret

00000000800062ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062ca:	1141                	addi	sp,sp,-16
    800062cc:	e422                	sd	s0,8(sp)
    800062ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062d0:	100007b7          	lui	a5,0x10000
    800062d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062d8:	8b85                	andi	a5,a5,1
    800062da:	cb91                	beqz	a5,800062ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062dc:	100007b7          	lui	a5,0x10000
    800062e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062e8:	6422                	ld	s0,8(sp)
    800062ea:	0141                	addi	sp,sp,16
    800062ec:	8082                	ret
    return -1;
    800062ee:	557d                	li	a0,-1
    800062f0:	bfe5                	j	800062e8 <uartgetc+0x1e>

00000000800062f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062f2:	1101                	addi	sp,sp,-32
    800062f4:	ec06                	sd	ra,24(sp)
    800062f6:	e822                	sd	s0,16(sp)
    800062f8:	e426                	sd	s1,8(sp)
    800062fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	fcc080e7          	jalr	-52(ra) # 800062ca <uartgetc>
    if(c == -1)
    80006306:	00950763          	beq	a0,s1,80006314 <uartintr+0x22>
      break;
    consoleintr(c);
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	8fe080e7          	jalr	-1794(ra) # 80005c08 <consoleintr>
  while(1){
    80006312:	b7f5                	j	800062fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006314:	00120497          	auipc	s1,0x120
    80006318:	ef448493          	addi	s1,s1,-268 # 80126208 <uart_tx_lock>
    8000631c:	8526                	mv	a0,s1
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	0b4080e7          	jalr	180(ra) # 800063d2 <acquire>
  uartstart();
    80006326:	00000097          	auipc	ra,0x0
    8000632a:	e64080e7          	jalr	-412(ra) # 8000618a <uartstart>
  release(&uart_tx_lock);
    8000632e:	8526                	mv	a0,s1
    80006330:	00000097          	auipc	ra,0x0
    80006334:	156080e7          	jalr	342(ra) # 80006486 <release>
}
    80006338:	60e2                	ld	ra,24(sp)
    8000633a:	6442                	ld	s0,16(sp)
    8000633c:	64a2                	ld	s1,8(sp)
    8000633e:	6105                	addi	sp,sp,32
    80006340:	8082                	ret

0000000080006342 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006342:	1141                	addi	sp,sp,-16
    80006344:	e422                	sd	s0,8(sp)
    80006346:	0800                	addi	s0,sp,16
  lk->name = name;
    80006348:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000634a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000634e:	00053823          	sd	zero,16(a0)
}
    80006352:	6422                	ld	s0,8(sp)
    80006354:	0141                	addi	sp,sp,16
    80006356:	8082                	ret

0000000080006358 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006358:	411c                	lw	a5,0(a0)
    8000635a:	e399                	bnez	a5,80006360 <holding+0x8>
    8000635c:	4501                	li	a0,0
  return r;
}
    8000635e:	8082                	ret
{
    80006360:	1101                	addi	sp,sp,-32
    80006362:	ec06                	sd	ra,24(sp)
    80006364:	e822                	sd	s0,16(sp)
    80006366:	e426                	sd	s1,8(sp)
    80006368:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000636a:	6904                	ld	s1,16(a0)
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	d1a080e7          	jalr	-742(ra) # 80001086 <mycpu>
    80006374:	40a48533          	sub	a0,s1,a0
    80006378:	00153513          	seqz	a0,a0
}
    8000637c:	60e2                	ld	ra,24(sp)
    8000637e:	6442                	ld	s0,16(sp)
    80006380:	64a2                	ld	s1,8(sp)
    80006382:	6105                	addi	sp,sp,32
    80006384:	8082                	ret

0000000080006386 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006386:	1101                	addi	sp,sp,-32
    80006388:	ec06                	sd	ra,24(sp)
    8000638a:	e822                	sd	s0,16(sp)
    8000638c:	e426                	sd	s1,8(sp)
    8000638e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80006390:	100024f3          	csrr	s1,sstatus
    80006394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006398:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000639e:	ffffb097          	auipc	ra,0xffffb
    800063a2:	ce8080e7          	jalr	-792(ra) # 80001086 <mycpu>
    800063a6:	5d3c                	lw	a5,120(a0)
    800063a8:	cf89                	beqz	a5,800063c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063aa:	ffffb097          	auipc	ra,0xffffb
    800063ae:	cdc080e7          	jalr	-804(ra) # 80001086 <mycpu>
    800063b2:	5d3c                	lw	a5,120(a0)
    800063b4:	2785                	addiw	a5,a5,1
    800063b6:	dd3c                	sw	a5,120(a0)
}
    800063b8:	60e2                	ld	ra,24(sp)
    800063ba:	6442                	ld	s0,16(sp)
    800063bc:	64a2                	ld	s1,8(sp)
    800063be:	6105                	addi	sp,sp,32
    800063c0:	8082                	ret
    mycpu()->intena = old;
    800063c2:	ffffb097          	auipc	ra,0xffffb
    800063c6:	cc4080e7          	jalr	-828(ra) # 80001086 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063ca:	8085                	srli	s1,s1,0x1
    800063cc:	8885                	andi	s1,s1,1
    800063ce:	dd64                	sw	s1,124(a0)
    800063d0:	bfe9                	j	800063aa <push_off+0x24>

00000000800063d2 <acquire>:
{
    800063d2:	1101                	addi	sp,sp,-32
    800063d4:	ec06                	sd	ra,24(sp)
    800063d6:	e822                	sd	s0,16(sp)
    800063d8:	e426                	sd	s1,8(sp)
    800063da:	1000                	addi	s0,sp,32
    800063dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	fa8080e7          	jalr	-88(ra) # 80006386 <push_off>
  if(holding(lk))
    800063e6:	8526                	mv	a0,s1
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	f70080e7          	jalr	-144(ra) # 80006358 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063f0:	4705                	li	a4,1
  if(holding(lk))
    800063f2:	e115                	bnez	a0,80006416 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063f4:	87ba                	mv	a5,a4
    800063f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063fa:	2781                	sext.w	a5,a5
    800063fc:	ffe5                	bnez	a5,800063f4 <acquire+0x22>
  __sync_synchronize();
    800063fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006402:	ffffb097          	auipc	ra,0xffffb
    80006406:	c84080e7          	jalr	-892(ra) # 80001086 <mycpu>
    8000640a:	e888                	sd	a0,16(s1)
}
    8000640c:	60e2                	ld	ra,24(sp)
    8000640e:	6442                	ld	s0,16(sp)
    80006410:	64a2                	ld	s1,8(sp)
    80006412:	6105                	addi	sp,sp,32
    80006414:	8082                	ret
    panic("acquire");
    80006416:	00002517          	auipc	a0,0x2
    8000641a:	40250513          	addi	a0,a0,1026 # 80008818 <digits+0x20>
    8000641e:	00000097          	auipc	ra,0x0
    80006422:	a6a080e7          	jalr	-1430(ra) # 80005e88 <panic>

0000000080006426 <pop_off>:

void
pop_off(void)
{
    80006426:	1141                	addi	sp,sp,-16
    80006428:	e406                	sd	ra,8(sp)
    8000642a:	e022                	sd	s0,0(sp)
    8000642c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000642e:	ffffb097          	auipc	ra,0xffffb
    80006432:	c58080e7          	jalr	-936(ra) # 80001086 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80006436:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000643a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000643c:	e78d                	bnez	a5,80006466 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000643e:	5d3c                	lw	a5,120(a0)
    80006440:	02f05b63          	blez	a5,80006476 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006444:	37fd                	addiw	a5,a5,-1
    80006446:	0007871b          	sext.w	a4,a5
    8000644a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000644c:	eb09                	bnez	a4,8000645e <pop_off+0x38>
    8000644e:	5d7c                	lw	a5,124(a0)
    80006450:	c799                	beqz	a5,8000645e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x));
    80006452:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006456:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000645a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000645e:	60a2                	ld	ra,8(sp)
    80006460:	6402                	ld	s0,0(sp)
    80006462:	0141                	addi	sp,sp,16
    80006464:	8082                	ret
    panic("pop_off - interruptible");
    80006466:	00002517          	auipc	a0,0x2
    8000646a:	3ba50513          	addi	a0,a0,954 # 80008820 <digits+0x28>
    8000646e:	00000097          	auipc	ra,0x0
    80006472:	a1a080e7          	jalr	-1510(ra) # 80005e88 <panic>
    panic("pop_off");
    80006476:	00002517          	auipc	a0,0x2
    8000647a:	3c250513          	addi	a0,a0,962 # 80008838 <digits+0x40>
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	a0a080e7          	jalr	-1526(ra) # 80005e88 <panic>

0000000080006486 <release>:
{
    80006486:	1101                	addi	sp,sp,-32
    80006488:	ec06                	sd	ra,24(sp)
    8000648a:	e822                	sd	s0,16(sp)
    8000648c:	e426                	sd	s1,8(sp)
    8000648e:	1000                	addi	s0,sp,32
    80006490:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006492:	00000097          	auipc	ra,0x0
    80006496:	ec6080e7          	jalr	-314(ra) # 80006358 <holding>
    8000649a:	c115                	beqz	a0,800064be <release+0x38>
  lk->cpu = 0;
    8000649c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064a4:	0f50000f          	fence	iorw,ow
    800064a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064ac:	00000097          	auipc	ra,0x0
    800064b0:	f7a080e7          	jalr	-134(ra) # 80006426 <pop_off>
}
    800064b4:	60e2                	ld	ra,24(sp)
    800064b6:	6442                	ld	s0,16(sp)
    800064b8:	64a2                	ld	s1,8(sp)
    800064ba:	6105                	addi	sp,sp,32
    800064bc:	8082                	ret
    panic("release");
    800064be:	00002517          	auipc	a0,0x2
    800064c2:	38250513          	addi	a0,a0,898 # 80008840 <digits+0x48>
    800064c6:	00000097          	auipc	ra,0x0
    800064ca:	9c2080e7          	jalr	-1598(ra) # 80005e88 <panic>
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
