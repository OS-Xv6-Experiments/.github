
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <mapping>:
#include "stddef.h"

// 文件描述符重定向(讲成映射比较好)
void
mapping(int n, int pd[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  // 关闭文件描述符 n
  close(n);
  10:	00000097          	auipc	ra,0x0
  14:	404080e7          	jalr	1028(ra) # 414 <close>
  // 将管道的 读或写 端口复制到描述符 n 上
  // 即产生一个 n 到 pd[n] 的映射
  dup(pd[n]);
  18:	048a                	slli	s1,s1,0x2
  1a:	94ca                	add	s1,s1,s2
  1c:	4088                	lw	a0,0(s1)
  1e:	00000097          	auipc	ra,0x0
  22:	446080e7          	jalr	1094(ra) # 464 <dup>
  // 关闭管道中的描述符
  close(pd[0]);
  26:	00092503          	lw	a0,0(s2)
  2a:	00000097          	auipc	ra,0x0
  2e:	3ea080e7          	jalr	1002(ra) # 414 <close>
  close(pd[1]);
  32:	00492503          	lw	a0,4(s2)
  36:	00000097          	auipc	ra,0x0
  3a:	3de080e7          	jalr	990(ra) # 414 <close>
}
  3e:	60e2                	ld	ra,24(sp)
  40:	6442                	ld	s0,16(sp)
  42:	64a2                	ld	s1,8(sp)
  44:	6902                	ld	s2,0(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret

000000000000004a <primes>:

// 求素数
void
primes()
{
  4a:	1101                	addi	sp,sp,-32
  4c:	ec06                	sd	ra,24(sp)
  4e:	e822                	sd	s0,16(sp)
  50:	1000                	addi	s0,sp,32
  // 定义变量获取管道中的数
  int previous, next;
  // 定义管道描述符数组
  int fd[2];
  // 从管道读取数据
  if (read(0, &previous, sizeof(int)))
  52:	4611                	li	a2,4
  54:	fec40593          	addi	a1,s0,-20
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	3aa080e7          	jalr	938(ra) # 404 <read>
  62:	e509                	bnez	a0,6c <primes+0x22>
      mapping(0, fd);
      // 递归执行此过程
      primes();
    }  
  }  
}
  64:	60e2                	ld	ra,24(sp)
  66:	6442                	ld	s0,16(sp)
  68:	6105                	addi	sp,sp,32
  6a:	8082                	ret
    printf("prime %d\n", previous);
  6c:	fec42583          	lw	a1,-20(s0)
  70:	00001517          	auipc	a0,0x1
  74:	89850513          	addi	a0,a0,-1896 # 908 <malloc+0xe6>
  78:	00000097          	auipc	ra,0x0
  7c:	6ec080e7          	jalr	1772(ra) # 764 <printf>
    pipe(fd);
  80:	fe040513          	addi	a0,s0,-32
  84:	00000097          	auipc	ra,0x0
  88:	378080e7          	jalr	888(ra) # 3fc <pipe>
    if (fork() == 0)
  8c:	00000097          	auipc	ra,0x0
  90:	358080e7          	jalr	856(ra) # 3e4 <fork>
  94:	e129                	bnez	a0,d6 <primes+0x8c>
      mapping(1, fd);
  96:	fe040593          	addi	a1,s0,-32
  9a:	4505                	li	a0,1
  9c:	00000097          	auipc	ra,0x0
  a0:	f64080e7          	jalr	-156(ra) # 0 <mapping>
      while (read(0, &next, sizeof(int)))
  a4:	4611                	li	a2,4
  a6:	fe840593          	addi	a1,s0,-24
  aa:	4501                	li	a0,0
  ac:	00000097          	auipc	ra,0x0
  b0:	358080e7          	jalr	856(ra) # 404 <read>
  b4:	d945                	beqz	a0,64 <primes+0x1a>
        if (next % previous != 0)
  b6:	fe842783          	lw	a5,-24(s0)
  ba:	fec42703          	lw	a4,-20(s0)
  be:	02e7e7bb          	remw	a5,a5,a4
  c2:	d3ed                	beqz	a5,a4 <primes+0x5a>
          write(1, &next, sizeof(int));
  c4:	4611                	li	a2,4
  c6:	fe840593          	addi	a1,s0,-24
  ca:	4505                	li	a0,1
  cc:	00000097          	auipc	ra,0x0
  d0:	340080e7          	jalr	832(ra) # 40c <write>
  d4:	bfc1                	j	a4 <primes+0x5a>
      wait(NULL);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	31c080e7          	jalr	796(ra) # 3f4 <wait>
      mapping(0, fd);
  e0:	fe040593          	addi	a1,s0,-32
  e4:	4501                	li	a0,0
  e6:	00000097          	auipc	ra,0x0
  ea:	f1a080e7          	jalr	-230(ra) # 0 <mapping>
      primes();
  ee:	00000097          	auipc	ra,0x0
  f2:	f5c080e7          	jalr	-164(ra) # 4a <primes>
}
  f6:	b7bd                	j	64 <primes+0x1a>

00000000000000f8 <main>:

int 
main(int argc, char *argv[])
{
  f8:	7179                	addi	sp,sp,-48
  fa:	f406                	sd	ra,40(sp)
  fc:	f022                	sd	s0,32(sp)
  fe:	ec26                	sd	s1,24(sp)
 100:	1800                	addi	s0,sp,48
  // 定义描述符
  int fd[2];
  // 创建管道
  pipe(fd);
 102:	fd840513          	addi	a0,s0,-40
 106:	00000097          	auipc	ra,0x0
 10a:	2f6080e7          	jalr	758(ra) # 3fc <pipe>
  // 创建进程
  if (fork() == 0)
 10e:	00000097          	auipc	ra,0x0
 112:	2d6080e7          	jalr	726(ra) # 3e4 <fork>
 116:	ed1d                	bnez	a0,154 <main+0x5c>
  {
    // 子进程
    // 子进程将管道的写端口映射到描述符 1 上
    mapping(1, fd);
 118:	fd840593          	addi	a1,s0,-40
 11c:	4505                	li	a0,1
 11e:	00000097          	auipc	ra,0x0
 122:	ee2080e7          	jalr	-286(ra) # 0 <mapping>
    // 循环获取 2 至 35
    for (int i = 2; i < 36; i++)
 126:	4789                	li	a5,2
 128:	fcf42a23          	sw	a5,-44(s0)
 12c:	02300493          	li	s1,35
    {
      // 将其写入管道
      write(1, &i, sizeof(int));
 130:	4611                	li	a2,4
 132:	fd440593          	addi	a1,s0,-44
 136:	4505                	li	a0,1
 138:	00000097          	auipc	ra,0x0
 13c:	2d4080e7          	jalr	724(ra) # 40c <write>
    for (int i = 2; i < 36; i++)
 140:	fd442783          	lw	a5,-44(s0)
 144:	2785                	addiw	a5,a5,1
 146:	0007871b          	sext.w	a4,a5
 14a:	fcf42a23          	sw	a5,-44(s0)
 14e:	fee4d1e3          	bge	s1,a4,130 <main+0x38>
 152:	a00d                	j	174 <main+0x7c>
  }
  else
  {
    // 父进程
    // 等待子进程把数据全部写入管道
    wait(NULL);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	29e080e7          	jalr	670(ra) # 3f4 <wait>
    // 父进程将管道的读端口映射到描述符 0 上
    mapping(0, fd);
 15e:	fd840593          	addi	a1,s0,-40
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	e9c080e7          	jalr	-356(ra) # 0 <mapping>
    // 调用 primes() 函数求素数
    primes();
 16c:	00000097          	auipc	ra,0x0
 170:	ede080e7          	jalr	-290(ra) # 4a <primes>
  }
  // 正常退出
  exit(0);
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	276080e7          	jalr	630(ra) # 3ec <exit>

000000000000017e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 184:	87aa                	mv	a5,a0
 186:	0585                	addi	a1,a1,1
 188:	0785                	addi	a5,a5,1
 18a:	fff5c703          	lbu	a4,-1(a1)
 18e:	fee78fa3          	sb	a4,-1(a5)
 192:	fb75                	bnez	a4,186 <strcpy+0x8>
    ;
  return os;
}
 194:	6422                	ld	s0,8(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cb91                	beqz	a5,1b8 <strcmp+0x1e>
 1a6:	0005c703          	lbu	a4,0(a1)
 1aa:	00f71763          	bne	a4,a5,1b8 <strcmp+0x1e>
    p++, q++;
 1ae:	0505                	addi	a0,a0,1
 1b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbe5                	bnez	a5,1a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b8:	0005c503          	lbu	a0,0(a1)
}
 1bc:	40a7853b          	subw	a0,a5,a0
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strlen>:

uint
strlen(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cf91                	beqz	a5,1ec <strlen+0x26>
 1d2:	0505                	addi	a0,a0,1
 1d4:	87aa                	mv	a5,a0
 1d6:	4685                	li	a3,1
 1d8:	9e89                	subw	a3,a3,a0
 1da:	00f6853b          	addw	a0,a3,a5
 1de:	0785                	addi	a5,a5,1
 1e0:	fff7c703          	lbu	a4,-1(a5)
 1e4:	fb7d                	bnez	a4,1da <strlen+0x14>
    ;
  return n;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  for(n = 0; s[n]; n++)
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strlen+0x20>

00000000000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f6:	ca19                	beqz	a2,20c <memset+0x1c>
 1f8:	87aa                	mv	a5,a0
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 202:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 206:	0785                	addi	a5,a5,1
 208:	fee79de3          	bne	a5,a4,202 <memset+0x12>
  }
  return dst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strchr>:

char*
strchr(const char *s, char c)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  for(; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb99                	beqz	a5,232 <strchr+0x20>
    if(*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1a>
  for(; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xc>
      return (char*)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  return 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <strchr+0x1a>

0000000000000236 <gets>:

char*
gets(char *buf, int max)
{
 236:	711d                	addi	sp,sp,-96
 238:	ec86                	sd	ra,88(sp)
 23a:	e8a2                	sd	s0,80(sp)
 23c:	e4a6                	sd	s1,72(sp)
 23e:	e0ca                	sd	s2,64(sp)
 240:	fc4e                	sd	s3,56(sp)
 242:	f852                	sd	s4,48(sp)
 244:	f456                	sd	s5,40(sp)
 246:	f05a                	sd	s6,32(sp)
 248:	ec5e                	sd	s7,24(sp)
 24a:	1080                	addi	s0,sp,96
 24c:	8baa                	mv	s7,a0
 24e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 250:	892a                	mv	s2,a0
 252:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 254:	4aa9                	li	s5,10
 256:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 258:	89a6                	mv	s3,s1
 25a:	2485                	addiw	s1,s1,1
 25c:	0344d863          	bge	s1,s4,28c <gets+0x56>
    cc = read(0, &c, 1);
 260:	4605                	li	a2,1
 262:	faf40593          	addi	a1,s0,-81
 266:	4501                	li	a0,0
 268:	00000097          	auipc	ra,0x0
 26c:	19c080e7          	jalr	412(ra) # 404 <read>
    if(cc < 1)
 270:	00a05e63          	blez	a0,28c <gets+0x56>
    buf[i++] = c;
 274:	faf44783          	lbu	a5,-81(s0)
 278:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27c:	01578763          	beq	a5,s5,28a <gets+0x54>
 280:	0905                	addi	s2,s2,1
 282:	fd679be3          	bne	a5,s6,258 <gets+0x22>
  for(i=0; i+1 < max; ){
 286:	89a6                	mv	s3,s1
 288:	a011                	j	28c <gets+0x56>
 28a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 28c:	99de                	add	s3,s3,s7
 28e:	00098023          	sb	zero,0(s3)
  return buf;
}
 292:	855e                	mv	a0,s7
 294:	60e6                	ld	ra,88(sp)
 296:	6446                	ld	s0,80(sp)
 298:	64a6                	ld	s1,72(sp)
 29a:	6906                	ld	s2,64(sp)
 29c:	79e2                	ld	s3,56(sp)
 29e:	7a42                	ld	s4,48(sp)
 2a0:	7aa2                	ld	s5,40(sp)
 2a2:	7b02                	ld	s6,32(sp)
 2a4:	6be2                	ld	s7,24(sp)
 2a6:	6125                	addi	sp,sp,96
 2a8:	8082                	ret

00000000000002aa <stat>:

int
stat(const char *n, struct stat *st)
{
 2aa:	1101                	addi	sp,sp,-32
 2ac:	ec06                	sd	ra,24(sp)
 2ae:	e822                	sd	s0,16(sp)
 2b0:	e426                	sd	s1,8(sp)
 2b2:	e04a                	sd	s2,0(sp)
 2b4:	1000                	addi	s0,sp,32
 2b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b8:	4581                	li	a1,0
 2ba:	00000097          	auipc	ra,0x0
 2be:	172080e7          	jalr	370(ra) # 42c <open>
  if(fd < 0)
 2c2:	02054563          	bltz	a0,2ec <stat+0x42>
 2c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c8:	85ca                	mv	a1,s2
 2ca:	00000097          	auipc	ra,0x0
 2ce:	17a080e7          	jalr	378(ra) # 444 <fstat>
 2d2:	892a                	mv	s2,a0
  close(fd);
 2d4:	8526                	mv	a0,s1
 2d6:	00000097          	auipc	ra,0x0
 2da:	13e080e7          	jalr	318(ra) # 414 <close>
  return r;
}
 2de:	854a                	mv	a0,s2
 2e0:	60e2                	ld	ra,24(sp)
 2e2:	6442                	ld	s0,16(sp)
 2e4:	64a2                	ld	s1,8(sp)
 2e6:	6902                	ld	s2,0(sp)
 2e8:	6105                	addi	sp,sp,32
 2ea:	8082                	ret
    return -1;
 2ec:	597d                	li	s2,-1
 2ee:	bfc5                	j	2de <stat+0x34>

00000000000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f6:	00054603          	lbu	a2,0(a0)
 2fa:	fd06079b          	addiw	a5,a2,-48
 2fe:	0ff7f793          	andi	a5,a5,255
 302:	4725                	li	a4,9
 304:	02f76963          	bltu	a4,a5,336 <atoi+0x46>
 308:	86aa                	mv	a3,a0
  n = 0;
 30a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 30c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 30e:	0685                	addi	a3,a3,1
 310:	0025179b          	slliw	a5,a0,0x2
 314:	9fa9                	addw	a5,a5,a0
 316:	0017979b          	slliw	a5,a5,0x1
 31a:	9fb1                	addw	a5,a5,a2
 31c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 320:	0006c603          	lbu	a2,0(a3)
 324:	fd06071b          	addiw	a4,a2,-48
 328:	0ff77713          	andi	a4,a4,255
 32c:	fee5f1e3          	bgeu	a1,a4,30e <atoi+0x1e>
  return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  n = 0;
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <atoi+0x40>

000000000000033a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 340:	02b57463          	bgeu	a0,a1,368 <memmove+0x2e>
    while(n-- > 0)
 344:	00c05f63          	blez	a2,362 <memmove+0x28>
 348:	1602                	slli	a2,a2,0x20
 34a:	9201                	srli	a2,a2,0x20
 34c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 350:	872a                	mv	a4,a0
      *dst++ = *src++;
 352:	0585                	addi	a1,a1,1
 354:	0705                	addi	a4,a4,1
 356:	fff5c683          	lbu	a3,-1(a1)
 35a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35e:	fee79ae3          	bne	a5,a4,352 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
    dst += n;
 368:	00c50733          	add	a4,a0,a2
    src += n;
 36c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 36e:	fec05ae3          	blez	a2,362 <memmove+0x28>
 372:	fff6079b          	addiw	a5,a2,-1
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	fff7c793          	not	a5,a5
 37e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 380:	15fd                	addi	a1,a1,-1
 382:	177d                	addi	a4,a4,-1
 384:	0005c683          	lbu	a3,0(a1)
 388:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38c:	fee79ae3          	bne	a5,a4,380 <memmove+0x46>
 390:	bfc9                	j	362 <memmove+0x28>

0000000000000392 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 398:	ca05                	beqz	a2,3c8 <memcmp+0x36>
 39a:	fff6069b          	addiw	a3,a2,-1
 39e:	1682                	slli	a3,a3,0x20
 3a0:	9281                	srli	a3,a3,0x20
 3a2:	0685                	addi	a3,a3,1
 3a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	0005c703          	lbu	a4,0(a1)
 3ae:	00e79863          	bne	a5,a4,3be <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b2:	0505                	addi	a0,a0,1
    p2++;
 3b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b6:	fed518e3          	bne	a0,a3,3a6 <memcmp+0x14>
  }
  return 0;
 3ba:	4501                	li	a0,0
 3bc:	a019                	j	3c2 <memcmp+0x30>
      return *p1 - *p2;
 3be:	40e7853b          	subw	a0,a5,a4
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	bfe5                	j	3c2 <memcmp+0x30>

00000000000003cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d4:	00000097          	auipc	ra,0x0
 3d8:	f66080e7          	jalr	-154(ra) # 33a <memmove>
}
 3dc:	60a2                	ld	ra,8(sp)
 3de:	6402                	ld	s0,0(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e4:	4885                	li	a7,1
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ec:	4889                	li	a7,2
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f4:	488d                	li	a7,3
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fc:	4891                	li	a7,4
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <read>:
.global read
read:
 li a7, SYS_read
 404:	4895                	li	a7,5
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <write>:
.global write
write:
 li a7, SYS_write
 40c:	48c1                	li	a7,16
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <close>:
.global close
close:
 li a7, SYS_close
 414:	48d5                	li	a7,21
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <kill>:
.global kill
kill:
 li a7, SYS_kill
 41c:	4899                	li	a7,6
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <exec>:
.global exec
exec:
 li a7, SYS_exec
 424:	489d                	li	a7,7
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <open>:
.global open
open:
 li a7, SYS_open
 42c:	48bd                	li	a7,15
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 434:	48c5                	li	a7,17
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43c:	48c9                	li	a7,18
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 444:	48a1                	li	a7,8
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <link>:
.global link
link:
 li a7, SYS_link
 44c:	48cd                	li	a7,19
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 454:	48d1                	li	a7,20
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45c:	48a5                	li	a7,9
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <dup>:
.global dup
dup:
 li a7, SYS_dup
 464:	48a9                	li	a7,10
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46c:	48ad                	li	a7,11
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 474:	48b1                	li	a7,12
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47c:	48b5                	li	a7,13
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 484:	48b9                	li	a7,14
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	f6e080e7          	jalr	-146(ra) # 40c <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	0080                	addi	s0,sp,64
 4bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4be:	c299                	beqz	a3,4c4 <printint+0x16>
 4c0:	0805c863          	bltz	a1,550 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c4:	2581                	sext.w	a1,a1
  neg = 0;
 4c6:	4881                	li	a7,0
 4c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ce:	2601                	sext.w	a2,a2
 4d0:	00000517          	auipc	a0,0x0
 4d4:	45050513          	addi	a0,a0,1104 # 920 <digits>
 4d8:	883a                	mv	a6,a4
 4da:	2705                	addiw	a4,a4,1
 4dc:	02c5f7bb          	remuw	a5,a1,a2
 4e0:	1782                	slli	a5,a5,0x20
 4e2:	9381                	srli	a5,a5,0x20
 4e4:	97aa                	add	a5,a5,a0
 4e6:	0007c783          	lbu	a5,0(a5)
 4ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ee:	0005879b          	sext.w	a5,a1
 4f2:	02c5d5bb          	divuw	a1,a1,a2
 4f6:	0685                	addi	a3,a3,1
 4f8:	fec7f0e3          	bgeu	a5,a2,4d8 <printint+0x2a>
  if(neg)
 4fc:	00088b63          	beqz	a7,512 <printint+0x64>
    buf[i++] = '-';
 500:	fd040793          	addi	a5,s0,-48
 504:	973e                	add	a4,a4,a5
 506:	02d00793          	li	a5,45
 50a:	fef70823          	sb	a5,-16(a4)
 50e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 512:	02e05863          	blez	a4,542 <printint+0x94>
 516:	fc040793          	addi	a5,s0,-64
 51a:	00e78933          	add	s2,a5,a4
 51e:	fff78993          	addi	s3,a5,-1
 522:	99ba                	add	s3,s3,a4
 524:	377d                	addiw	a4,a4,-1
 526:	1702                	slli	a4,a4,0x20
 528:	9301                	srli	a4,a4,0x20
 52a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52e:	fff94583          	lbu	a1,-1(s2)
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	f58080e7          	jalr	-168(ra) # 48c <putc>
  while(--i >= 0)
 53c:	197d                	addi	s2,s2,-1
 53e:	ff3918e3          	bne	s2,s3,52e <printint+0x80>
}
 542:	70e2                	ld	ra,56(sp)
 544:	7442                	ld	s0,48(sp)
 546:	74a2                	ld	s1,40(sp)
 548:	7902                	ld	s2,32(sp)
 54a:	69e2                	ld	s3,24(sp)
 54c:	6121                	addi	sp,sp,64
 54e:	8082                	ret
    x = -xx;
 550:	40b005bb          	negw	a1,a1
    neg = 1;
 554:	4885                	li	a7,1
    x = -xx;
 556:	bf8d                	j	4c8 <printint+0x1a>

0000000000000558 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 558:	7119                	addi	sp,sp,-128
 55a:	fc86                	sd	ra,120(sp)
 55c:	f8a2                	sd	s0,112(sp)
 55e:	f4a6                	sd	s1,104(sp)
 560:	f0ca                	sd	s2,96(sp)
 562:	ecce                	sd	s3,88(sp)
 564:	e8d2                	sd	s4,80(sp)
 566:	e4d6                	sd	s5,72(sp)
 568:	e0da                	sd	s6,64(sp)
 56a:	fc5e                	sd	s7,56(sp)
 56c:	f862                	sd	s8,48(sp)
 56e:	f466                	sd	s9,40(sp)
 570:	f06a                	sd	s10,32(sp)
 572:	ec6e                	sd	s11,24(sp)
 574:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 576:	0005c903          	lbu	s2,0(a1)
 57a:	18090f63          	beqz	s2,718 <vprintf+0x1c0>
 57e:	8aaa                	mv	s5,a0
 580:	8b32                	mv	s6,a2
 582:	00158493          	addi	s1,a1,1
  state = 0;
 586:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 588:	02500a13          	li	s4,37
      if(c == 'd'){
 58c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 590:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 594:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 598:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59c:	00000b97          	auipc	s7,0x0
 5a0:	384b8b93          	addi	s7,s7,900 # 920 <digits>
 5a4:	a839                	j	5c2 <vprintf+0x6a>
        putc(fd, c);
 5a6:	85ca                	mv	a1,s2
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ee2080e7          	jalr	-286(ra) # 48c <putc>
 5b2:	a019                	j	5b8 <vprintf+0x60>
    } else if(state == '%'){
 5b4:	01498f63          	beq	s3,s4,5d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b8:	0485                	addi	s1,s1,1
 5ba:	fff4c903          	lbu	s2,-1(s1)
 5be:	14090d63          	beqz	s2,718 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c6:	fe0997e3          	bnez	s3,5b4 <vprintf+0x5c>
      if(c == '%'){
 5ca:	fd479ee3          	bne	a5,s4,5a6 <vprintf+0x4e>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7e5                	j	5b8 <vprintf+0x60>
      if(c == 'd'){
 5d2:	05878063          	beq	a5,s8,612 <vprintf+0xba>
      } else if(c == 'l') {
 5d6:	05978c63          	beq	a5,s9,62e <vprintf+0xd6>
      } else if(c == 'x') {
 5da:	07a78863          	beq	a5,s10,64a <vprintf+0xf2>
      } else if(c == 'p') {
 5de:	09b78463          	beq	a5,s11,666 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e2:	07300713          	li	a4,115
 5e6:	0ce78663          	beq	a5,a4,6b2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ea:	06300713          	li	a4,99
 5ee:	0ee78e63          	beq	a5,a4,6ea <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f2:	11478863          	beq	a5,s4,702 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f6:	85d2                	mv	a1,s4
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e92080e7          	jalr	-366(ra) # 48c <putc>
        putc(fd, c);
 602:	85ca                	mv	a1,s2
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e86080e7          	jalr	-378(ra) # 48c <putc>
      }
      state = 0;
 60e:	4981                	li	s3,0
 610:	b765                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 612:	008b0913          	addi	s2,s6,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000b2583          	lw	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e8e080e7          	jalr	-370(ra) # 4ae <printint>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b771                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b0913          	addi	s2,s6,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000b2583          	lw	a1,0(s6)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e72080e7          	jalr	-398(ra) # 4ae <printint>
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bf85                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 64a:	008b0913          	addi	s2,s6,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000b2583          	lw	a1,0(s6)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e56080e7          	jalr	-426(ra) # 4ae <printint>
 660:	8b4a                	mv	s6,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bf91                	j	5b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 666:	008b0793          	addi	a5,s6,8
 66a:	f8f43423          	sd	a5,-120(s0)
 66e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e14080e7          	jalr	-492(ra) # 48c <putc>
  putc(fd, 'x');
 680:	85ea                	mv	a1,s10
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e08080e7          	jalr	-504(ra) # 48c <putc>
 68c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	df2080e7          	jalr	-526(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b721                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b2:	008b0993          	addi	s3,s6,8
 6b6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ba:	02090163          	beqz	s2,6dc <vprintf+0x184>
        while(*s != 0){
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c9a1                	beqz	a1,712 <vprintf+0x1ba>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dc6080e7          	jalr	-570(ra) # 48c <putc>
          s++;
 6ce:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d6:	8b4e                	mv	s6,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bdf9                	j	5b8 <vprintf+0x60>
          s = "(null)";
 6dc:	00000917          	auipc	s2,0x0
 6e0:	23c90913          	addi	s2,s2,572 # 918 <malloc+0xf6>
        while(*s != 0){
 6e4:	02800593          	li	a1,40
 6e8:	bff1                	j	6c4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ea:	008b0913          	addi	s2,s6,8
 6ee:	000b4583          	lbu	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d98080e7          	jalr	-616(ra) # 48c <putc>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd65                	j	5b8 <vprintf+0x60>
        putc(fd, c);
 702:	85d2                	mv	a1,s4
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d86080e7          	jalr	-634(ra) # 48c <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b565                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 712:	8b4e                	mv	s6,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b54d                	j	5b8 <vprintf+0x60>
    }
  }
}
 718:	70e6                	ld	ra,120(sp)
 71a:	7446                	ld	s0,112(sp)
 71c:	74a6                	ld	s1,104(sp)
 71e:	7906                	ld	s2,96(sp)
 720:	69e6                	ld	s3,88(sp)
 722:	6a46                	ld	s4,80(sp)
 724:	6aa6                	ld	s5,72(sp)
 726:	6b06                	ld	s6,64(sp)
 728:	7be2                	ld	s7,56(sp)
 72a:	7c42                	ld	s8,48(sp)
 72c:	7ca2                	ld	s9,40(sp)
 72e:	7d02                	ld	s10,32(sp)
 730:	6de2                	ld	s11,24(sp)
 732:	6109                	addi	sp,sp,128
 734:	8082                	ret

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	addi	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	8622                	mv	a2,s0
 754:	00000097          	auipc	ra,0x0
 758:	e04080e7          	jalr	-508(ra) # 558 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	00000097          	auipc	ra,0x0
 78e:	dce080e7          	jalr	-562(ra) # 558 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	1141                	addi	sp,sp,-16
 79c:	e422                	sd	s0,8(sp)
 79e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	00000797          	auipc	a5,0x0
 7a8:	1947b783          	ld	a5,404(a5) # 938 <freep>
 7ac:	a805                	j	7dc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ae:	4618                	lw	a4,8(a2)
 7b0:	9db9                	addw	a1,a1,a4
 7b2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	6318                	ld	a4,0(a4)
 7ba:	fee53823          	sd	a4,-16(a0)
 7be:	a091                	j	802 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9e39                	addw	a2,a2,a4
 7c6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053703          	ld	a4,-16(a0)
 7cc:	e398                	sd	a4,0(a5)
 7ce:	a099                	j	814 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x40>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x50>
{
 7da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x36>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059713          	slli	a4,a1,0x20
 7f4:	9301                	srli	a4,a4,0x20
 7f6:	0712                	slli	a4,a4,0x4
 7f8:	9736                	add	a4,a4,a3
 7fa:	fae60ae3          	beq	a2,a4,7ae <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 802:	4790                	lw	a2,8(a5)
 804:	02061713          	slli	a4,a2,0x20
 808:	9301                	srli	a4,a4,0x20
 80a:	0712                	slli	a4,a4,0x4
 80c:	973e                	add	a4,a4,a5
 80e:	fae689e3          	beq	a3,a4,7c0 <free+0x26>
  } else
    p->s.ptr = bp;
 812:	e394                	sd	a3,0(a5)
  freep = p;
 814:	00000717          	auipc	a4,0x0
 818:	12f73223          	sd	a5,292(a4) # 938 <freep>
}
 81c:	6422                	ld	s0,8(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f426                	sd	s1,40(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051493          	slli	s1,a0,0x20
 83a:	9081                	srli	s1,s1,0x20
 83c:	04bd                	addi	s1,s1,15
 83e:	8091                	srli	s1,s1,0x4
 840:	0014899b          	addiw	s3,s1,1
 844:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 846:	00000517          	auipc	a0,0x0
 84a:	0f253503          	ld	a0,242(a0) # 938 <freep>
 84e:	c515                	beqz	a0,87a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	02977f63          	bgeu	a4,s1,892 <malloc+0x70>
 858:	8a4e                	mv	s4,s3
 85a:	0009871b          	sext.w	a4,s3
 85e:	6685                	lui	a3,0x1
 860:	00d77363          	bgeu	a4,a3,866 <malloc+0x44>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86e:	00000917          	auipc	s2,0x0
 872:	0ca90913          	addi	s2,s2,202 # 938 <freep>
  if(p == (char*)-1)
 876:	5afd                	li	s5,-1
 878:	a88d                	j	8ea <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 87a:	00000797          	auipc	a5,0x0
 87e:	0c678793          	addi	a5,a5,198 # 940 <base>
 882:	00000717          	auipc	a4,0x0
 886:	0af73b23          	sd	a5,182(a4) # 938 <freep>
 88a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 890:	b7e1                	j	858 <malloc+0x36>
      if(p->s.size == nunits)
 892:	02e48b63          	beq	s1,a4,8c8 <malloc+0xa6>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	1702                	slli	a4,a4,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	0712                	slli	a4,a4,0x4
 8a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	08a73823          	sd	a0,144(a4) # 938 <freep>
      return (void*)(p + 1);
 8b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	e118                	sd	a4,0(a0)
 8cc:	bff1                	j	8a8 <malloc+0x86>
  hp->s.size = nu;
 8ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d2:	0541                	addi	a0,a0,16
 8d4:	00000097          	auipc	ra,0x0
 8d8:	ec6080e7          	jalr	-314(ra) # 79a <free>
  return freep;
 8dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e0:	d971                	beqz	a0,8b4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	fa9776e3          	bgeu	a4,s1,892 <malloc+0x70>
    if(p == freep)
 8ea:	00093703          	ld	a4,0(s2)
 8ee:	853e                	mv	a0,a5
 8f0:	fef719e3          	bne	a4,a5,8e2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	00000097          	auipc	ra,0x0
 8fa:	b7e080e7          	jalr	-1154(ra) # 474 <sbrk>
  if(p == (char*)-1)
 8fe:	fd5518e3          	bne	a0,s5,8ce <malloc+0xac>
        return 0;
 902:	4501                	li	a0,0
 904:	bf45                	j	8b4 <malloc+0x92>
