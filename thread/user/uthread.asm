
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d3a78793          	addi	a5,a5,-710 # d40 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d2f73123          	sd	a5,-734(a4) # d30 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d2f72423          	sw	a5,-728(a4) # 2d40 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	d0253503          	ld	a0,-766(a0) # d30 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb67>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	ee080813          	addi	a6,a6,-288 # 8f20 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb67>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	cda58593          	addi	a1,a1,-806 # d40 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b8850513          	addi	a0,a0,-1144 # bf8 <malloc+0xe4>
  78:	00001097          	auipc	ra,0x1
  7c:	9de080e7          	jalr	-1570(ra) # a56 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	65c080e7          	jalr	1628(ra) # 6de <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b50263          	beq	a0,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6789                	lui	a5,0x2
  90:	00f58733          	add	a4,a1,a5
  94:	4685                	li	a3,1
  96:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  98:	00001717          	auipc	a4,0x1
  9c:	c8b73c23          	sd	a1,-872(a4) # d30 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64)&(t->context),(uint64)&(next_thread->context));
  a0:	07a1                	addi	a5,a5,8
  a2:	95be                	add	a1,a1,a5
  a4:	953e                	add	a0,a0,a5
  a6:	00000097          	auipc	ra,0x0
  aa:	360080e7          	jalr	864(ra) # 406 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	c8478793          	addi	a5,a5,-892 # d40 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb67>
  ca:	00009617          	auipc	a2,0x9
  ce:	e5660613          	addi	a2,a2,-426 # 8f20 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	00e786b3          	add	a3,a5,a4
  e6:	4609                	li	a2,2
  e8:	c290                	sw	a2,0(a3)
  // YOUR CODE HERE
  t->context.ra = (uint64)(func);
  ea:	e688                	sd	a0,8(a3)
  t->context.sp = (uint64)&(t->stack[STACK_SIZE-1]);
  ec:	177d                	addi	a4,a4,-1
  ee:	97ba                	add	a5,a5,a4
  f0:	ea9c                	sd	a5,16(a3)
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <thread_yield>:

void 
thread_yield(void)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 100:	00001797          	auipc	a5,0x1
 104:	c307b783          	ld	a5,-976(a5) # d30 <current_thread>
 108:	6709                	lui	a4,0x2
 10a:	97ba                	add	a5,a5,a4
 10c:	4709                	li	a4,2
 10e:	c398                	sw	a4,0(a5)
  thread_schedule();
 110:	00000097          	auipc	ra,0x0
 114:	f16080e7          	jalr	-234(ra) # 26 <thread_schedule>
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 120:	7179                	addi	sp,sp,-48
 122:	f406                	sd	ra,40(sp)
 124:	f022                	sd	s0,32(sp)
 126:	ec26                	sd	s1,24(sp)
 128:	e84a                	sd	s2,16(sp)
 12a:	e44e                	sd	s3,8(sp)
 12c:	e052                	sd	s4,0(sp)
 12e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 130:	00001517          	auipc	a0,0x1
 134:	af050513          	addi	a0,a0,-1296 # c20 <malloc+0x10c>
 138:	00001097          	auipc	ra,0x1
 13c:	91e080e7          	jalr	-1762(ra) # a56 <printf>
  a_started = 1;
 140:	4785                	li	a5,1
 142:	00001717          	auipc	a4,0x1
 146:	bef72523          	sw	a5,-1046(a4) # d2c <a_started>
  while(b_started == 0 || c_started == 0)
 14a:	00001497          	auipc	s1,0x1
 14e:	bde48493          	addi	s1,s1,-1058 # d28 <b_started>
 152:	00001917          	auipc	s2,0x1
 156:	bd290913          	addi	s2,s2,-1070 # d24 <c_started>
 15a:	a029                	j	164 <thread_a+0x44>
    thread_yield();
 15c:	00000097          	auipc	ra,0x0
 160:	f9c080e7          	jalr	-100(ra) # f8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 164:	409c                	lw	a5,0(s1)
 166:	2781                	sext.w	a5,a5
 168:	dbf5                	beqz	a5,15c <thread_a+0x3c>
 16a:	00092783          	lw	a5,0(s2)
 16e:	2781                	sext.w	a5,a5
 170:	d7f5                	beqz	a5,15c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 172:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 174:	00001a17          	auipc	s4,0x1
 178:	ac4a0a13          	addi	s4,s4,-1340 # c38 <malloc+0x124>
    a_n += 1;
 17c:	00001917          	auipc	s2,0x1
 180:	ba490913          	addi	s2,s2,-1116 # d20 <a_n>
  for (i = 0; i < 100; i++) {
 184:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 188:	85a6                	mv	a1,s1
 18a:	8552                	mv	a0,s4
 18c:	00001097          	auipc	ra,0x1
 190:	8ca080e7          	jalr	-1846(ra) # a56 <printf>
    a_n += 1;
 194:	00092783          	lw	a5,0(s2)
 198:	2785                	addiw	a5,a5,1
 19a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f5a080e7          	jalr	-166(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a6:	2485                	addiw	s1,s1,1
 1a8:	ff3490e3          	bne	s1,s3,188 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1ac:	00001597          	auipc	a1,0x1
 1b0:	b745a583          	lw	a1,-1164(a1) # d20 <a_n>
 1b4:	00001517          	auipc	a0,0x1
 1b8:	a9450513          	addi	a0,a0,-1388 # c48 <malloc+0x134>
 1bc:	00001097          	auipc	ra,0x1
 1c0:	89a080e7          	jalr	-1894(ra) # a56 <printf>

  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	b6c7b783          	ld	a5,-1172(a5) # d30 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e52080e7          	jalr	-430(ra) # 26 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6a02                	ld	s4,0(sp)
 1e8:	6145                	addi	sp,sp,48
 1ea:	8082                	ret

00000000000001ec <thread_b>:

void 
thread_b(void)
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fc:	00001517          	auipc	a0,0x1
 200:	a6c50513          	addi	a0,a0,-1428 # c68 <malloc+0x154>
 204:	00001097          	auipc	ra,0x1
 208:	852080e7          	jalr	-1966(ra) # a56 <printf>
  b_started = 1;
 20c:	4785                	li	a5,1
 20e:	00001717          	auipc	a4,0x1
 212:	b0f72d23          	sw	a5,-1254(a4) # d28 <b_started>
  while(a_started == 0 || c_started == 0)
 216:	00001497          	auipc	s1,0x1
 21a:	b1648493          	addi	s1,s1,-1258 # d2c <a_started>
 21e:	00001917          	auipc	s2,0x1
 222:	b0690913          	addi	s2,s2,-1274 # d24 <c_started>
 226:	a029                	j	230 <thread_b+0x44>
    thread_yield();
 228:	00000097          	auipc	ra,0x0
 22c:	ed0080e7          	jalr	-304(ra) # f8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 230:	409c                	lw	a5,0(s1)
 232:	2781                	sext.w	a5,a5
 234:	dbf5                	beqz	a5,228 <thread_b+0x3c>
 236:	00092783          	lw	a5,0(s2)
 23a:	2781                	sext.w	a5,a5
 23c:	d7f5                	beqz	a5,228 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 240:	00001a17          	auipc	s4,0x1
 244:	a40a0a13          	addi	s4,s4,-1472 # c80 <malloc+0x16c>
    b_n += 1;
 248:	00001917          	auipc	s2,0x1
 24c:	ad490913          	addi	s2,s2,-1324 # d1c <b_n>
  for (i = 0; i < 100; i++) {
 250:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 254:	85a6                	mv	a1,s1
 256:	8552                	mv	a0,s4
 258:	00000097          	auipc	ra,0x0
 25c:	7fe080e7          	jalr	2046(ra) # a56 <printf>
    b_n += 1;
 260:	00092783          	lw	a5,0(s2)
 264:	2785                	addiw	a5,a5,1
 266:	00f92023          	sw	a5,0(s2)
    thread_yield();
 26a:	00000097          	auipc	ra,0x0
 26e:	e8e080e7          	jalr	-370(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 272:	2485                	addiw	s1,s1,1
 274:	ff3490e3          	bne	s1,s3,254 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 278:	00001597          	auipc	a1,0x1
 27c:	aa45a583          	lw	a1,-1372(a1) # d1c <b_n>
 280:	00001517          	auipc	a0,0x1
 284:	a1050513          	addi	a0,a0,-1520 # c90 <malloc+0x17c>
 288:	00000097          	auipc	ra,0x0
 28c:	7ce080e7          	jalr	1998(ra) # a56 <printf>

  current_thread->state = FREE;
 290:	00001797          	auipc	a5,0x1
 294:	aa07b783          	ld	a5,-1376(a5) # d30 <current_thread>
 298:	6709                	lui	a4,0x2
 29a:	97ba                	add	a5,a5,a4
 29c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	d86080e7          	jalr	-634(ra) # 26 <thread_schedule>
}
 2a8:	70a2                	ld	ra,40(sp)
 2aa:	7402                	ld	s0,32(sp)
 2ac:	64e2                	ld	s1,24(sp)
 2ae:	6942                	ld	s2,16(sp)
 2b0:	69a2                	ld	s3,8(sp)
 2b2:	6a02                	ld	s4,0(sp)
 2b4:	6145                	addi	sp,sp,48
 2b6:	8082                	ret

00000000000002b8 <thread_c>:

void 
thread_c(void)
{
 2b8:	7179                	addi	sp,sp,-48
 2ba:	f406                	sd	ra,40(sp)
 2bc:	f022                	sd	s0,32(sp)
 2be:	ec26                	sd	s1,24(sp)
 2c0:	e84a                	sd	s2,16(sp)
 2c2:	e44e                	sd	s3,8(sp)
 2c4:	e052                	sd	s4,0(sp)
 2c6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	9e850513          	addi	a0,a0,-1560 # cb0 <malloc+0x19c>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	786080e7          	jalr	1926(ra) # a56 <printf>
  c_started = 1;
 2d8:	4785                	li	a5,1
 2da:	00001717          	auipc	a4,0x1
 2de:	a4f72523          	sw	a5,-1462(a4) # d24 <c_started>
  while(a_started == 0 || b_started == 0)
 2e2:	00001497          	auipc	s1,0x1
 2e6:	a4a48493          	addi	s1,s1,-1462 # d2c <a_started>
 2ea:	00001917          	auipc	s2,0x1
 2ee:	a3e90913          	addi	s2,s2,-1474 # d28 <b_started>
 2f2:	a029                	j	2fc <thread_c+0x44>
    thread_yield();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	e04080e7          	jalr	-508(ra) # f8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fc:	409c                	lw	a5,0(s1)
 2fe:	2781                	sext.w	a5,a5
 300:	dbf5                	beqz	a5,2f4 <thread_c+0x3c>
 302:	00092783          	lw	a5,0(s2)
 306:	2781                	sext.w	a5,a5
 308:	d7f5                	beqz	a5,2f4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 30a:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30c:	00001a17          	auipc	s4,0x1
 310:	9bca0a13          	addi	s4,s4,-1604 # cc8 <malloc+0x1b4>
    c_n += 1;
 314:	00001917          	auipc	s2,0x1
 318:	a0490913          	addi	s2,s2,-1532 # d18 <c_n>
  for (i = 0; i < 100; i++) {
 31c:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 320:	85a6                	mv	a1,s1
 322:	8552                	mv	a0,s4
 324:	00000097          	auipc	ra,0x0
 328:	732080e7          	jalr	1842(ra) # a56 <printf>
    c_n += 1;
 32c:	00092783          	lw	a5,0(s2)
 330:	2785                	addiw	a5,a5,1
 332:	00f92023          	sw	a5,0(s2)
    thread_yield();
 336:	00000097          	auipc	ra,0x0
 33a:	dc2080e7          	jalr	-574(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 33e:	2485                	addiw	s1,s1,1
 340:	ff3490e3          	bne	s1,s3,320 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 344:	00001597          	auipc	a1,0x1
 348:	9d45a583          	lw	a1,-1580(a1) # d18 <c_n>
 34c:	00001517          	auipc	a0,0x1
 350:	98c50513          	addi	a0,a0,-1652 # cd8 <malloc+0x1c4>
 354:	00000097          	auipc	ra,0x0
 358:	702080e7          	jalr	1794(ra) # a56 <printf>

  current_thread->state = FREE;
 35c:	00001797          	auipc	a5,0x1
 360:	9d47b783          	ld	a5,-1580(a5) # d30 <current_thread>
 364:	6709                	lui	a4,0x2
 366:	97ba                	add	a5,a5,a4
 368:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 36c:	00000097          	auipc	ra,0x0
 370:	cba080e7          	jalr	-838(ra) # 26 <thread_schedule>
}
 374:	70a2                	ld	ra,40(sp)
 376:	7402                	ld	s0,32(sp)
 378:	64e2                	ld	s1,24(sp)
 37a:	6942                	ld	s2,16(sp)
 37c:	69a2                	ld	s3,8(sp)
 37e:	6a02                	ld	s4,0(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

0000000000000384 <main>:

int 
main(int argc, char *argv[]) 
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 38c:	00001797          	auipc	a5,0x1
 390:	9807ac23          	sw	zero,-1640(a5) # d24 <c_started>
 394:	00001797          	auipc	a5,0x1
 398:	9807aa23          	sw	zero,-1644(a5) # d28 <b_started>
 39c:	00001797          	auipc	a5,0x1
 3a0:	9807a823          	sw	zero,-1648(a5) # d2c <a_started>
  a_n = b_n = c_n = 0;
 3a4:	00001797          	auipc	a5,0x1
 3a8:	9607aa23          	sw	zero,-1676(a5) # d18 <c_n>
 3ac:	00001797          	auipc	a5,0x1
 3b0:	9607a823          	sw	zero,-1680(a5) # d1c <b_n>
 3b4:	00001797          	auipc	a5,0x1
 3b8:	9607a623          	sw	zero,-1684(a5) # d20 <a_n>
  thread_init();
 3bc:	00000097          	auipc	ra,0x0
 3c0:	c44080e7          	jalr	-956(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	d5c50513          	addi	a0,a0,-676 # 120 <thread_a>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cea080e7          	jalr	-790(ra) # b6 <thread_create>
  thread_create(thread_b);
 3d4:	00000517          	auipc	a0,0x0
 3d8:	e1850513          	addi	a0,a0,-488 # 1ec <thread_b>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	cda080e7          	jalr	-806(ra) # b6 <thread_create>
  thread_create(thread_c);
 3e4:	00000517          	auipc	a0,0x0
 3e8:	ed450513          	addi	a0,a0,-300 # 2b8 <thread_c>
 3ec:	00000097          	auipc	ra,0x0
 3f0:	cca080e7          	jalr	-822(ra) # b6 <thread_create>
  thread_schedule();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	c32080e7          	jalr	-974(ra) # 26 <thread_schedule>
  exit(0);
 3fc:	4501                	li	a0,0
 3fe:	00000097          	auipc	ra,0x0
 402:	2e0080e7          	jalr	736(ra) # 6de <exit>

0000000000000406 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	sd ra, 0(a0)
 406:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
 40a:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
 40e:	e900                	sd	s0,16(a0)
    sd s1, 24(a0)
 410:	ed04                	sd	s1,24(a0)
    sd s2, 32(a0)
 412:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 416:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 41a:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 41e:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 422:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 426:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 42a:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 42e:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 432:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 436:	07b53423          	sd	s11,104(a0)
    ld ra, 0(a1)
 43a:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
 43e:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
 442:	6980                	ld	s0,16(a1)
    ld s1, 24(a1)
 444:	6d84                	ld	s1,24(a1)
    ld s2, 32(a1)
 446:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 44a:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 44e:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 452:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 456:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 45a:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 45e:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 462:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 466:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 46a:	0685bd83          	ld	s11,104(a1)
	ret    /* return to ra */
 46e:	8082                	ret

0000000000000470 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 476:	87aa                	mv	a5,a0
 478:	0585                	addi	a1,a1,1
 47a:	0785                	addi	a5,a5,1
 47c:	fff5c703          	lbu	a4,-1(a1)
 480:	fee78fa3          	sb	a4,-1(a5)
 484:	fb75                	bnez	a4,478 <strcpy+0x8>
    ;
  return os;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret

000000000000048c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e422                	sd	s0,8(sp)
 490:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 492:	00054783          	lbu	a5,0(a0)
 496:	cb91                	beqz	a5,4aa <strcmp+0x1e>
 498:	0005c703          	lbu	a4,0(a1)
 49c:	00f71763          	bne	a4,a5,4aa <strcmp+0x1e>
    p++, q++;
 4a0:	0505                	addi	a0,a0,1
 4a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fbe5                	bnez	a5,498 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4aa:	0005c503          	lbu	a0,0(a1)
}
 4ae:	40a7853b          	subw	a0,a5,a0
 4b2:	6422                	ld	s0,8(sp)
 4b4:	0141                	addi	sp,sp,16
 4b6:	8082                	ret

00000000000004b8 <strlen>:

uint
strlen(const char *s)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	cf91                	beqz	a5,4de <strlen+0x26>
 4c4:	0505                	addi	a0,a0,1
 4c6:	87aa                	mv	a5,a0
 4c8:	4685                	li	a3,1
 4ca:	9e89                	subw	a3,a3,a0
 4cc:	00f6853b          	addw	a0,a3,a5
 4d0:	0785                	addi	a5,a5,1
 4d2:	fff7c703          	lbu	a4,-1(a5)
 4d6:	fb7d                	bnez	a4,4cc <strlen+0x14>
    ;
  return n;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  for(n = 0; s[n]; n++)
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <strlen+0x20>

00000000000004e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e8:	ca19                	beqz	a2,4fe <memset+0x1c>
 4ea:	87aa                	mv	a5,a0
 4ec:	1602                	slli	a2,a2,0x20
 4ee:	9201                	srli	a2,a2,0x20
 4f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f8:	0785                	addi	a5,a5,1
 4fa:	fee79de3          	bne	a5,a4,4f4 <memset+0x12>
  }
  return dst;
}
 4fe:	6422                	ld	s0,8(sp)
 500:	0141                	addi	sp,sp,16
 502:	8082                	ret

0000000000000504 <strchr>:

char*
strchr(const char *s, char c)
{
 504:	1141                	addi	sp,sp,-16
 506:	e422                	sd	s0,8(sp)
 508:	0800                	addi	s0,sp,16
  for(; *s; s++)
 50a:	00054783          	lbu	a5,0(a0)
 50e:	cb99                	beqz	a5,524 <strchr+0x20>
    if(*s == c)
 510:	00f58763          	beq	a1,a5,51e <strchr+0x1a>
  for(; *s; s++)
 514:	0505                	addi	a0,a0,1
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbfd                	bnez	a5,510 <strchr+0xc>
      return (char*)s;
  return 0;
 51c:	4501                	li	a0,0
}
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret
  return 0;
 524:	4501                	li	a0,0
 526:	bfe5                	j	51e <strchr+0x1a>

0000000000000528 <gets>:

char*
gets(char *buf, int max)
{
 528:	711d                	addi	sp,sp,-96
 52a:	ec86                	sd	ra,88(sp)
 52c:	e8a2                	sd	s0,80(sp)
 52e:	e4a6                	sd	s1,72(sp)
 530:	e0ca                	sd	s2,64(sp)
 532:	fc4e                	sd	s3,56(sp)
 534:	f852                	sd	s4,48(sp)
 536:	f456                	sd	s5,40(sp)
 538:	f05a                	sd	s6,32(sp)
 53a:	ec5e                	sd	s7,24(sp)
 53c:	1080                	addi	s0,sp,96
 53e:	8baa                	mv	s7,a0
 540:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 542:	892a                	mv	s2,a0
 544:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 546:	4aa9                	li	s5,10
 548:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 54a:	89a6                	mv	s3,s1
 54c:	2485                	addiw	s1,s1,1
 54e:	0344d863          	bge	s1,s4,57e <gets+0x56>
    cc = read(0, &c, 1);
 552:	4605                	li	a2,1
 554:	faf40593          	addi	a1,s0,-81
 558:	4501                	li	a0,0
 55a:	00000097          	auipc	ra,0x0
 55e:	19c080e7          	jalr	412(ra) # 6f6 <read>
    if(cc < 1)
 562:	00a05e63          	blez	a0,57e <gets+0x56>
    buf[i++] = c;
 566:	faf44783          	lbu	a5,-81(s0)
 56a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56e:	01578763          	beq	a5,s5,57c <gets+0x54>
 572:	0905                	addi	s2,s2,1
 574:	fd679be3          	bne	a5,s6,54a <gets+0x22>
  for(i=0; i+1 < max; ){
 578:	89a6                	mv	s3,s1
 57a:	a011                	j	57e <gets+0x56>
 57c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57e:	99de                	add	s3,s3,s7
 580:	00098023          	sb	zero,0(s3)
  return buf;
}
 584:	855e                	mv	a0,s7
 586:	60e6                	ld	ra,88(sp)
 588:	6446                	ld	s0,80(sp)
 58a:	64a6                	ld	s1,72(sp)
 58c:	6906                	ld	s2,64(sp)
 58e:	79e2                	ld	s3,56(sp)
 590:	7a42                	ld	s4,48(sp)
 592:	7aa2                	ld	s5,40(sp)
 594:	7b02                	ld	s6,32(sp)
 596:	6be2                	ld	s7,24(sp)
 598:	6125                	addi	sp,sp,96
 59a:	8082                	ret

000000000000059c <stat>:

int
stat(const char *n, struct stat *st)
{
 59c:	1101                	addi	sp,sp,-32
 59e:	ec06                	sd	ra,24(sp)
 5a0:	e822                	sd	s0,16(sp)
 5a2:	e426                	sd	s1,8(sp)
 5a4:	e04a                	sd	s2,0(sp)
 5a6:	1000                	addi	s0,sp,32
 5a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5aa:	4581                	li	a1,0
 5ac:	00000097          	auipc	ra,0x0
 5b0:	172080e7          	jalr	370(ra) # 71e <open>
  if(fd < 0)
 5b4:	02054563          	bltz	a0,5de <stat+0x42>
 5b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5ba:	85ca                	mv	a1,s2
 5bc:	00000097          	auipc	ra,0x0
 5c0:	17a080e7          	jalr	378(ra) # 736 <fstat>
 5c4:	892a                	mv	s2,a0
  close(fd);
 5c6:	8526                	mv	a0,s1
 5c8:	00000097          	auipc	ra,0x0
 5cc:	13e080e7          	jalr	318(ra) # 706 <close>
  return r;
}
 5d0:	854a                	mv	a0,s2
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	64a2                	ld	s1,8(sp)
 5d8:	6902                	ld	s2,0(sp)
 5da:	6105                	addi	sp,sp,32
 5dc:	8082                	ret
    return -1;
 5de:	597d                	li	s2,-1
 5e0:	bfc5                	j	5d0 <stat+0x34>

00000000000005e2 <atoi>:

int
atoi(const char *s)
{
 5e2:	1141                	addi	sp,sp,-16
 5e4:	e422                	sd	s0,8(sp)
 5e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e8:	00054603          	lbu	a2,0(a0)
 5ec:	fd06079b          	addiw	a5,a2,-48
 5f0:	0ff7f793          	andi	a5,a5,255
 5f4:	4725                	li	a4,9
 5f6:	02f76963          	bltu	a4,a5,628 <atoi+0x46>
 5fa:	86aa                	mv	a3,a0
  n = 0;
 5fc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 5fe:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 600:	0685                	addi	a3,a3,1
 602:	0025179b          	slliw	a5,a0,0x2
 606:	9fa9                	addw	a5,a5,a0
 608:	0017979b          	slliw	a5,a5,0x1
 60c:	9fb1                	addw	a5,a5,a2
 60e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 612:	0006c603          	lbu	a2,0(a3)
 616:	fd06071b          	addiw	a4,a2,-48
 61a:	0ff77713          	andi	a4,a4,255
 61e:	fee5f1e3          	bgeu	a1,a4,600 <atoi+0x1e>
  return n;
}
 622:	6422                	ld	s0,8(sp)
 624:	0141                	addi	sp,sp,16
 626:	8082                	ret
  n = 0;
 628:	4501                	li	a0,0
 62a:	bfe5                	j	622 <atoi+0x40>

000000000000062c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 62c:	1141                	addi	sp,sp,-16
 62e:	e422                	sd	s0,8(sp)
 630:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 632:	02b57463          	bgeu	a0,a1,65a <memmove+0x2e>
    while(n-- > 0)
 636:	00c05f63          	blez	a2,654 <memmove+0x28>
 63a:	1602                	slli	a2,a2,0x20
 63c:	9201                	srli	a2,a2,0x20
 63e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 642:	872a                	mv	a4,a0
      *dst++ = *src++;
 644:	0585                	addi	a1,a1,1
 646:	0705                	addi	a4,a4,1
 648:	fff5c683          	lbu	a3,-1(a1)
 64c:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xaee>
    while(n-- > 0)
 650:	fee79ae3          	bne	a5,a4,644 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 654:	6422                	ld	s0,8(sp)
 656:	0141                	addi	sp,sp,16
 658:	8082                	ret
    dst += n;
 65a:	00c50733          	add	a4,a0,a2
    src += n;
 65e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 660:	fec05ae3          	blez	a2,654 <memmove+0x28>
 664:	fff6079b          	addiw	a5,a2,-1
 668:	1782                	slli	a5,a5,0x20
 66a:	9381                	srli	a5,a5,0x20
 66c:	fff7c793          	not	a5,a5
 670:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 672:	15fd                	addi	a1,a1,-1
 674:	177d                	addi	a4,a4,-1
 676:	0005c683          	lbu	a3,0(a1)
 67a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 67e:	fee79ae3          	bne	a5,a4,672 <memmove+0x46>
 682:	bfc9                	j	654 <memmove+0x28>

0000000000000684 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 684:	1141                	addi	sp,sp,-16
 686:	e422                	sd	s0,8(sp)
 688:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 68a:	ca05                	beqz	a2,6ba <memcmp+0x36>
 68c:	fff6069b          	addiw	a3,a2,-1
 690:	1682                	slli	a3,a3,0x20
 692:	9281                	srli	a3,a3,0x20
 694:	0685                	addi	a3,a3,1
 696:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 698:	00054783          	lbu	a5,0(a0)
 69c:	0005c703          	lbu	a4,0(a1)
 6a0:	00e79863          	bne	a5,a4,6b0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a4:	0505                	addi	a0,a0,1
    p2++;
 6a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a8:	fed518e3          	bne	a0,a3,698 <memcmp+0x14>
  }
  return 0;
 6ac:	4501                	li	a0,0
 6ae:	a019                	j	6b4 <memcmp+0x30>
      return *p1 - *p2;
 6b0:	40e7853b          	subw	a0,a5,a4
}
 6b4:	6422                	ld	s0,8(sp)
 6b6:	0141                	addi	sp,sp,16
 6b8:	8082                	ret
  return 0;
 6ba:	4501                	li	a0,0
 6bc:	bfe5                	j	6b4 <memcmp+0x30>

00000000000006be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6be:	1141                	addi	sp,sp,-16
 6c0:	e406                	sd	ra,8(sp)
 6c2:	e022                	sd	s0,0(sp)
 6c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c6:	00000097          	auipc	ra,0x0
 6ca:	f66080e7          	jalr	-154(ra) # 62c <memmove>
}
 6ce:	60a2                	ld	ra,8(sp)
 6d0:	6402                	ld	s0,0(sp)
 6d2:	0141                	addi	sp,sp,16
 6d4:	8082                	ret

00000000000006d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d6:	4885                	li	a7,1
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <exit>:
.global exit
exit:
 li a7, SYS_exit
 6de:	4889                	li	a7,2
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6e6:	488d                	li	a7,3
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6ee:	4891                	li	a7,4
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <read>:
.global read
read:
 li a7, SYS_read
 6f6:	4895                	li	a7,5
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <write>:
.global write
write:
 li a7, SYS_write
 6fe:	48c1                	li	a7,16
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <close>:
.global close
close:
 li a7, SYS_close
 706:	48d5                	li	a7,21
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <kill>:
.global kill
kill:
 li a7, SYS_kill
 70e:	4899                	li	a7,6
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <exec>:
.global exec
exec:
 li a7, SYS_exec
 716:	489d                	li	a7,7
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <open>:
.global open
open:
 li a7, SYS_open
 71e:	48bd                	li	a7,15
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 726:	48c5                	li	a7,17
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 72e:	48c9                	li	a7,18
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 736:	48a1                	li	a7,8
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <link>:
.global link
link:
 li a7, SYS_link
 73e:	48cd                	li	a7,19
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 746:	48d1                	li	a7,20
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 74e:	48a5                	li	a7,9
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <dup>:
.global dup
dup:
 li a7, SYS_dup
 756:	48a9                	li	a7,10
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 75e:	48ad                	li	a7,11
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 766:	48b1                	li	a7,12
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 76e:	48b5                	li	a7,13
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 776:	48b9                	li	a7,14
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77e:	1101                	addi	sp,sp,-32
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 78a:	4605                	li	a2,1
 78c:	fef40593          	addi	a1,s0,-17
 790:	00000097          	auipc	ra,0x0
 794:	f6e080e7          	jalr	-146(ra) # 6fe <write>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6105                	addi	sp,sp,32
 79e:	8082                	ret

00000000000007a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a0:	7139                	addi	sp,sp,-64
 7a2:	fc06                	sd	ra,56(sp)
 7a4:	f822                	sd	s0,48(sp)
 7a6:	f426                	sd	s1,40(sp)
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	0080                	addi	s0,sp,64
 7ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7b0:	c299                	beqz	a3,7b6 <printint+0x16>
 7b2:	0805c863          	bltz	a1,842 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b6:	2581                	sext.w	a1,a1
  neg = 0;
 7b8:	4881                	li	a7,0
 7ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7c0:	2601                	sext.w	a2,a2
 7c2:	00000517          	auipc	a0,0x0
 7c6:	53e50513          	addi	a0,a0,1342 # d00 <digits>
 7ca:	883a                	mv	a6,a4
 7cc:	2705                	addiw	a4,a4,1
 7ce:	02c5f7bb          	remuw	a5,a1,a2
 7d2:	1782                	slli	a5,a5,0x20
 7d4:	9381                	srli	a5,a5,0x20
 7d6:	97aa                	add	a5,a5,a0
 7d8:	0007c783          	lbu	a5,0(a5)
 7dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7e0:	0005879b          	sext.w	a5,a1
 7e4:	02c5d5bb          	divuw	a1,a1,a2
 7e8:	0685                	addi	a3,a3,1
 7ea:	fec7f0e3          	bgeu	a5,a2,7ca <printint+0x2a>
  if(neg)
 7ee:	00088b63          	beqz	a7,804 <printint+0x64>
    buf[i++] = '-';
 7f2:	fd040793          	addi	a5,s0,-48
 7f6:	973e                	add	a4,a4,a5
 7f8:	02d00793          	li	a5,45
 7fc:	fef70823          	sb	a5,-16(a4)
 800:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 804:	02e05863          	blez	a4,834 <printint+0x94>
 808:	fc040793          	addi	a5,s0,-64
 80c:	00e78933          	add	s2,a5,a4
 810:	fff78993          	addi	s3,a5,-1
 814:	99ba                	add	s3,s3,a4
 816:	377d                	addiw	a4,a4,-1
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 820:	fff94583          	lbu	a1,-1(s2)
 824:	8526                	mv	a0,s1
 826:	00000097          	auipc	ra,0x0
 82a:	f58080e7          	jalr	-168(ra) # 77e <putc>
  while(--i >= 0)
 82e:	197d                	addi	s2,s2,-1
 830:	ff3918e3          	bne	s2,s3,820 <printint+0x80>
}
 834:	70e2                	ld	ra,56(sp)
 836:	7442                	ld	s0,48(sp)
 838:	74a2                	ld	s1,40(sp)
 83a:	7902                	ld	s2,32(sp)
 83c:	69e2                	ld	s3,24(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
    x = -xx;
 842:	40b005bb          	negw	a1,a1
    neg = 1;
 846:	4885                	li	a7,1
    x = -xx;
 848:	bf8d                	j	7ba <printint+0x1a>

000000000000084a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84a:	7119                	addi	sp,sp,-128
 84c:	fc86                	sd	ra,120(sp)
 84e:	f8a2                	sd	s0,112(sp)
 850:	f4a6                	sd	s1,104(sp)
 852:	f0ca                	sd	s2,96(sp)
 854:	ecce                	sd	s3,88(sp)
 856:	e8d2                	sd	s4,80(sp)
 858:	e4d6                	sd	s5,72(sp)
 85a:	e0da                	sd	s6,64(sp)
 85c:	fc5e                	sd	s7,56(sp)
 85e:	f862                	sd	s8,48(sp)
 860:	f466                	sd	s9,40(sp)
 862:	f06a                	sd	s10,32(sp)
 864:	ec6e                	sd	s11,24(sp)
 866:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 868:	0005c903          	lbu	s2,0(a1)
 86c:	18090f63          	beqz	s2,a0a <vprintf+0x1c0>
 870:	8aaa                	mv	s5,a0
 872:	8b32                	mv	s6,a2
 874:	00158493          	addi	s1,a1,1
  state = 0;
 878:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 87a:	02500a13          	li	s4,37
      if(c == 'd'){
 87e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 882:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 886:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 88a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88e:	00000b97          	auipc	s7,0x0
 892:	472b8b93          	addi	s7,s7,1138 # d00 <digits>
 896:	a839                	j	8b4 <vprintf+0x6a>
        putc(fd, c);
 898:	85ca                	mv	a1,s2
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	ee2080e7          	jalr	-286(ra) # 77e <putc>
 8a4:	a019                	j	8aa <vprintf+0x60>
    } else if(state == '%'){
 8a6:	01498f63          	beq	s3,s4,8c4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8aa:	0485                	addi	s1,s1,1
 8ac:	fff4c903          	lbu	s2,-1(s1)
 8b0:	14090d63          	beqz	s2,a0a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8b4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8b8:	fe0997e3          	bnez	s3,8a6 <vprintf+0x5c>
      if(c == '%'){
 8bc:	fd479ee3          	bne	a5,s4,898 <vprintf+0x4e>
        state = '%';
 8c0:	89be                	mv	s3,a5
 8c2:	b7e5                	j	8aa <vprintf+0x60>
      if(c == 'd'){
 8c4:	05878063          	beq	a5,s8,904 <vprintf+0xba>
      } else if(c == 'l') {
 8c8:	05978c63          	beq	a5,s9,920 <vprintf+0xd6>
      } else if(c == 'x') {
 8cc:	07a78863          	beq	a5,s10,93c <vprintf+0xf2>
      } else if(c == 'p') {
 8d0:	09b78463          	beq	a5,s11,958 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8d4:	07300713          	li	a4,115
 8d8:	0ce78663          	beq	a5,a4,9a4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8dc:	06300713          	li	a4,99
 8e0:	0ee78e63          	beq	a5,a4,9dc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8e4:	11478863          	beq	a5,s4,9f4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8e8:	85d2                	mv	a1,s4
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e92080e7          	jalr	-366(ra) # 77e <putc>
        putc(fd, c);
 8f4:	85ca                	mv	a1,s2
 8f6:	8556                	mv	a0,s5
 8f8:	00000097          	auipc	ra,0x0
 8fc:	e86080e7          	jalr	-378(ra) # 77e <putc>
      }
      state = 0;
 900:	4981                	li	s3,0
 902:	b765                	j	8aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 904:	008b0913          	addi	s2,s6,8
 908:	4685                	li	a3,1
 90a:	4629                	li	a2,10
 90c:	000b2583          	lw	a1,0(s6)
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	e8e080e7          	jalr	-370(ra) # 7a0 <printint>
 91a:	8b4a                	mv	s6,s2
      state = 0;
 91c:	4981                	li	s3,0
 91e:	b771                	j	8aa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 920:	008b0913          	addi	s2,s6,8
 924:	4681                	li	a3,0
 926:	4629                	li	a2,10
 928:	000b2583          	lw	a1,0(s6)
 92c:	8556                	mv	a0,s5
 92e:	00000097          	auipc	ra,0x0
 932:	e72080e7          	jalr	-398(ra) # 7a0 <printint>
 936:	8b4a                	mv	s6,s2
      state = 0;
 938:	4981                	li	s3,0
 93a:	bf85                	j	8aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 93c:	008b0913          	addi	s2,s6,8
 940:	4681                	li	a3,0
 942:	4641                	li	a2,16
 944:	000b2583          	lw	a1,0(s6)
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	e56080e7          	jalr	-426(ra) # 7a0 <printint>
 952:	8b4a                	mv	s6,s2
      state = 0;
 954:	4981                	li	s3,0
 956:	bf91                	j	8aa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 958:	008b0793          	addi	a5,s6,8
 95c:	f8f43423          	sd	a5,-120(s0)
 960:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 964:	03000593          	li	a1,48
 968:	8556                	mv	a0,s5
 96a:	00000097          	auipc	ra,0x0
 96e:	e14080e7          	jalr	-492(ra) # 77e <putc>
  putc(fd, 'x');
 972:	85ea                	mv	a1,s10
 974:	8556                	mv	a0,s5
 976:	00000097          	auipc	ra,0x0
 97a:	e08080e7          	jalr	-504(ra) # 77e <putc>
 97e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 980:	03c9d793          	srli	a5,s3,0x3c
 984:	97de                	add	a5,a5,s7
 986:	0007c583          	lbu	a1,0(a5)
 98a:	8556                	mv	a0,s5
 98c:	00000097          	auipc	ra,0x0
 990:	df2080e7          	jalr	-526(ra) # 77e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 994:	0992                	slli	s3,s3,0x4
 996:	397d                	addiw	s2,s2,-1
 998:	fe0914e3          	bnez	s2,980 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 99c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b721                	j	8aa <vprintf+0x60>
        s = va_arg(ap, char*);
 9a4:	008b0993          	addi	s3,s6,8
 9a8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9ac:	02090163          	beqz	s2,9ce <vprintf+0x184>
        while(*s != 0){
 9b0:	00094583          	lbu	a1,0(s2)
 9b4:	c9a1                	beqz	a1,a04 <vprintf+0x1ba>
          putc(fd, *s);
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	dc6080e7          	jalr	-570(ra) # 77e <putc>
          s++;
 9c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 9c2:	00094583          	lbu	a1,0(s2)
 9c6:	f9e5                	bnez	a1,9b6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9c8:	8b4e                	mv	s6,s3
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	bdf9                	j	8aa <vprintf+0x60>
          s = "(null)";
 9ce:	00000917          	auipc	s2,0x0
 9d2:	32a90913          	addi	s2,s2,810 # cf8 <malloc+0x1e4>
        while(*s != 0){
 9d6:	02800593          	li	a1,40
 9da:	bff1                	j	9b6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9dc:	008b0913          	addi	s2,s6,8
 9e0:	000b4583          	lbu	a1,0(s6)
 9e4:	8556                	mv	a0,s5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	d98080e7          	jalr	-616(ra) # 77e <putc>
 9ee:	8b4a                	mv	s6,s2
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	bd65                	j	8aa <vprintf+0x60>
        putc(fd, c);
 9f4:	85d2                	mv	a1,s4
 9f6:	8556                	mv	a0,s5
 9f8:	00000097          	auipc	ra,0x0
 9fc:	d86080e7          	jalr	-634(ra) # 77e <putc>
      state = 0;
 a00:	4981                	li	s3,0
 a02:	b565                	j	8aa <vprintf+0x60>
        s = va_arg(ap, char*);
 a04:	8b4e                	mv	s6,s3
      state = 0;
 a06:	4981                	li	s3,0
 a08:	b54d                	j	8aa <vprintf+0x60>
    }
  }
}
 a0a:	70e6                	ld	ra,120(sp)
 a0c:	7446                	ld	s0,112(sp)
 a0e:	74a6                	ld	s1,104(sp)
 a10:	7906                	ld	s2,96(sp)
 a12:	69e6                	ld	s3,88(sp)
 a14:	6a46                	ld	s4,80(sp)
 a16:	6aa6                	ld	s5,72(sp)
 a18:	6b06                	ld	s6,64(sp)
 a1a:	7be2                	ld	s7,56(sp)
 a1c:	7c42                	ld	s8,48(sp)
 a1e:	7ca2                	ld	s9,40(sp)
 a20:	7d02                	ld	s10,32(sp)
 a22:	6de2                	ld	s11,24(sp)
 a24:	6109                	addi	sp,sp,128
 a26:	8082                	ret

0000000000000a28 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a28:	715d                	addi	sp,sp,-80
 a2a:	ec06                	sd	ra,24(sp)
 a2c:	e822                	sd	s0,16(sp)
 a2e:	1000                	addi	s0,sp,32
 a30:	e010                	sd	a2,0(s0)
 a32:	e414                	sd	a3,8(s0)
 a34:	e818                	sd	a4,16(s0)
 a36:	ec1c                	sd	a5,24(s0)
 a38:	03043023          	sd	a6,32(s0)
 a3c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a40:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a44:	8622                	mv	a2,s0
 a46:	00000097          	auipc	ra,0x0
 a4a:	e04080e7          	jalr	-508(ra) # 84a <vprintf>
}
 a4e:	60e2                	ld	ra,24(sp)
 a50:	6442                	ld	s0,16(sp)
 a52:	6161                	addi	sp,sp,80
 a54:	8082                	ret

0000000000000a56 <printf>:

void
printf(const char *fmt, ...)
{
 a56:	711d                	addi	sp,sp,-96
 a58:	ec06                	sd	ra,24(sp)
 a5a:	e822                	sd	s0,16(sp)
 a5c:	1000                	addi	s0,sp,32
 a5e:	e40c                	sd	a1,8(s0)
 a60:	e810                	sd	a2,16(s0)
 a62:	ec14                	sd	a3,24(s0)
 a64:	f018                	sd	a4,32(s0)
 a66:	f41c                	sd	a5,40(s0)
 a68:	03043823          	sd	a6,48(s0)
 a6c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a70:	00840613          	addi	a2,s0,8
 a74:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a78:	85aa                	mv	a1,a0
 a7a:	4505                	li	a0,1
 a7c:	00000097          	auipc	ra,0x0
 a80:	dce080e7          	jalr	-562(ra) # 84a <vprintf>
}
 a84:	60e2                	ld	ra,24(sp)
 a86:	6442                	ld	s0,16(sp)
 a88:	6125                	addi	sp,sp,96
 a8a:	8082                	ret

0000000000000a8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8c:	1141                	addi	sp,sp,-16
 a8e:	e422                	sd	s0,8(sp)
 a90:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a92:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a96:	00000797          	auipc	a5,0x0
 a9a:	2a27b783          	ld	a5,674(a5) # d38 <freep>
 a9e:	a805                	j	ace <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa0:	4618                	lw	a4,8(a2)
 aa2:	9db9                	addw	a1,a1,a4
 aa4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa8:	6398                	ld	a4,0(a5)
 aaa:	6318                	ld	a4,0(a4)
 aac:	fee53823          	sd	a4,-16(a0)
 ab0:	a091                	j	af4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab2:	ff852703          	lw	a4,-8(a0)
 ab6:	9e39                	addw	a2,a2,a4
 ab8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 aba:	ff053703          	ld	a4,-16(a0)
 abe:	e398                	sd	a4,0(a5)
 ac0:	a099                	j	b06 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac2:	6398                	ld	a4,0(a5)
 ac4:	00e7e463          	bltu	a5,a4,acc <free+0x40>
 ac8:	00e6ea63          	bltu	a3,a4,adc <free+0x50>
{
 acc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ace:	fed7fae3          	bgeu	a5,a3,ac2 <free+0x36>
 ad2:	6398                	ld	a4,0(a5)
 ad4:	00e6e463          	bltu	a3,a4,adc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad8:	fee7eae3          	bltu	a5,a4,acc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 adc:	ff852583          	lw	a1,-8(a0)
 ae0:	6390                	ld	a2,0(a5)
 ae2:	02059713          	slli	a4,a1,0x20
 ae6:	9301                	srli	a4,a4,0x20
 ae8:	0712                	slli	a4,a4,0x4
 aea:	9736                	add	a4,a4,a3
 aec:	fae60ae3          	beq	a2,a4,aa0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 af0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af4:	4790                	lw	a2,8(a5)
 af6:	02061713          	slli	a4,a2,0x20
 afa:	9301                	srli	a4,a4,0x20
 afc:	0712                	slli	a4,a4,0x4
 afe:	973e                	add	a4,a4,a5
 b00:	fae689e3          	beq	a3,a4,ab2 <free+0x26>
  } else
    p->s.ptr = bp;
 b04:	e394                	sd	a3,0(a5)
  freep = p;
 b06:	00000717          	auipc	a4,0x0
 b0a:	22f73923          	sd	a5,562(a4) # d38 <freep>
}
 b0e:	6422                	ld	s0,8(sp)
 b10:	0141                	addi	sp,sp,16
 b12:	8082                	ret

0000000000000b14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b14:	7139                	addi	sp,sp,-64
 b16:	fc06                	sd	ra,56(sp)
 b18:	f822                	sd	s0,48(sp)
 b1a:	f426                	sd	s1,40(sp)
 b1c:	f04a                	sd	s2,32(sp)
 b1e:	ec4e                	sd	s3,24(sp)
 b20:	e852                	sd	s4,16(sp)
 b22:	e456                	sd	s5,8(sp)
 b24:	e05a                	sd	s6,0(sp)
 b26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b28:	02051493          	slli	s1,a0,0x20
 b2c:	9081                	srli	s1,s1,0x20
 b2e:	04bd                	addi	s1,s1,15
 b30:	8091                	srli	s1,s1,0x4
 b32:	0014899b          	addiw	s3,s1,1
 b36:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b38:	00000517          	auipc	a0,0x0
 b3c:	20053503          	ld	a0,512(a0) # d38 <freep>
 b40:	c515                	beqz	a0,b6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b44:	4798                	lw	a4,8(a5)
 b46:	02977f63          	bgeu	a4,s1,b84 <malloc+0x70>
 b4a:	8a4e                	mv	s4,s3
 b4c:	0009871b          	sext.w	a4,s3
 b50:	6685                	lui	a3,0x1
 b52:	00d77363          	bgeu	a4,a3,b58 <malloc+0x44>
 b56:	6a05                	lui	s4,0x1
 b58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b60:	00000917          	auipc	s2,0x0
 b64:	1d890913          	addi	s2,s2,472 # d38 <freep>
  if(p == (char*)-1)
 b68:	5afd                	li	s5,-1
 b6a:	a88d                	j	bdc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b6c:	00008797          	auipc	a5,0x8
 b70:	3b478793          	addi	a5,a5,948 # 8f20 <base>
 b74:	00000717          	auipc	a4,0x0
 b78:	1cf73223          	sd	a5,452(a4) # d38 <freep>
 b7c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b7e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b82:	b7e1                	j	b4a <malloc+0x36>
      if(p->s.size == nunits)
 b84:	02e48b63          	beq	s1,a4,bba <malloc+0xa6>
        p->s.size -= nunits;
 b88:	4137073b          	subw	a4,a4,s3
 b8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b8e:	1702                	slli	a4,a4,0x20
 b90:	9301                	srli	a4,a4,0x20
 b92:	0712                	slli	a4,a4,0x4
 b94:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b96:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b9a:	00000717          	auipc	a4,0x0
 b9e:	18a73f23          	sd	a0,414(a4) # d38 <freep>
      return (void*)(p + 1);
 ba2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ba6:	70e2                	ld	ra,56(sp)
 ba8:	7442                	ld	s0,48(sp)
 baa:	74a2                	ld	s1,40(sp)
 bac:	7902                	ld	s2,32(sp)
 bae:	69e2                	ld	s3,24(sp)
 bb0:	6a42                	ld	s4,16(sp)
 bb2:	6aa2                	ld	s5,8(sp)
 bb4:	6b02                	ld	s6,0(sp)
 bb6:	6121                	addi	sp,sp,64
 bb8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bba:	6398                	ld	a4,0(a5)
 bbc:	e118                	sd	a4,0(a0)
 bbe:	bff1                	j	b9a <malloc+0x86>
  hp->s.size = nu;
 bc0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc4:	0541                	addi	a0,a0,16
 bc6:	00000097          	auipc	ra,0x0
 bca:	ec6080e7          	jalr	-314(ra) # a8c <free>
  return freep;
 bce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bd2:	d971                	beqz	a0,ba6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd6:	4798                	lw	a4,8(a5)
 bd8:	fa9776e3          	bgeu	a4,s1,b84 <malloc+0x70>
    if(p == freep)
 bdc:	00093703          	ld	a4,0(s2)
 be0:	853e                	mv	a0,a5
 be2:	fef719e3          	bne	a4,a5,bd4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 be6:	8552                	mv	a0,s4
 be8:	00000097          	auipc	ra,0x0
 bec:	b7e080e7          	jalr	-1154(ra) # 766 <sbrk>
  if(p == (char*)-1)
 bf0:	fd5518e3          	bne	a0,s5,bc0 <malloc+0xac>
        return 0;
 bf4:	4501                	li	a0,0
 bf6:	bf45                	j	ba6 <malloc+0x92>
