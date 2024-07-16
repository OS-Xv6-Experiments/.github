
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "stddef.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
    int ptoc_fd[2], ctop_fd[2];
    pipe(ptoc_fd);
   a:	fd840513          	addi	a0,s0,-40
   e:	00000097          	auipc	ra,0x0
  12:	366080e7          	jalr	870(ra) # 374 <pipe>
    pipe(ctop_fd);
  16:	fd040513          	addi	a0,s0,-48
  1a:	00000097          	auipc	ra,0x0
  1e:	35a080e7          	jalr	858(ra) # 374 <pipe>
    char buf[8];
    if (fork() == 0) {
  22:	00000097          	auipc	ra,0x0
  26:	33a080e7          	jalr	826(ra) # 35c <fork>
  2a:	e13d                	bnez	a0,90 <main+0x90>
        // child process
        read(ptoc_fd[0], buf, 4);
  2c:	4611                	li	a2,4
  2e:	fc840593          	addi	a1,s0,-56
  32:	fd842503          	lw	a0,-40(s0)
  36:	00000097          	auipc	ra,0x0
  3a:	346080e7          	jalr	838(ra) # 37c <read>
        printf("%d: received %s\n", getpid(), buf);
  3e:	00000097          	auipc	ra,0x0
  42:	3a6080e7          	jalr	934(ra) # 3e4 <getpid>
  46:	85aa                	mv	a1,a0
  48:	fc840613          	addi	a2,s0,-56
  4c:	00001517          	auipc	a0,0x1
  50:	83450513          	addi	a0,a0,-1996 # 880 <malloc+0xe6>
  54:	00000097          	auipc	ra,0x0
  58:	688080e7          	jalr	1672(ra) # 6dc <printf>
        write(ctop_fd[1], "pong", strlen("pong"));
  5c:	fd442483          	lw	s1,-44(s0)
  60:	00001517          	auipc	a0,0x1
  64:	83850513          	addi	a0,a0,-1992 # 898 <malloc+0xfe>
  68:	00000097          	auipc	ra,0x0
  6c:	0d6080e7          	jalr	214(ra) # 13e <strlen>
  70:	0005061b          	sext.w	a2,a0
  74:	00001597          	auipc	a1,0x1
  78:	82458593          	addi	a1,a1,-2012 # 898 <malloc+0xfe>
  7c:	8526                	mv	a0,s1
  7e:	00000097          	auipc	ra,0x0
  82:	306080e7          	jalr	774(ra) # 384 <write>
        write(ptoc_fd[1], "ping", strlen("ping"));
        wait(NULL);
        read(ctop_fd[0], buf, 4);
        printf("%d: received %s\n", getpid(), buf);
    }
    exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2dc080e7          	jalr	732(ra) # 364 <exit>
        write(ptoc_fd[1], "ping", strlen("ping"));
  90:	fdc42483          	lw	s1,-36(s0)
  94:	00001517          	auipc	a0,0x1
  98:	80c50513          	addi	a0,a0,-2036 # 8a0 <malloc+0x106>
  9c:	00000097          	auipc	ra,0x0
  a0:	0a2080e7          	jalr	162(ra) # 13e <strlen>
  a4:	0005061b          	sext.w	a2,a0
  a8:	00000597          	auipc	a1,0x0
  ac:	7f858593          	addi	a1,a1,2040 # 8a0 <malloc+0x106>
  b0:	8526                	mv	a0,s1
  b2:	00000097          	auipc	ra,0x0
  b6:	2d2080e7          	jalr	722(ra) # 384 <write>
        wait(NULL);
  ba:	4501                	li	a0,0
  bc:	00000097          	auipc	ra,0x0
  c0:	2b0080e7          	jalr	688(ra) # 36c <wait>
        read(ctop_fd[0], buf, 4);
  c4:	4611                	li	a2,4
  c6:	fc840593          	addi	a1,s0,-56
  ca:	fd042503          	lw	a0,-48(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	2ae080e7          	jalr	686(ra) # 37c <read>
        printf("%d: received %s\n", getpid(), buf);
  d6:	00000097          	auipc	ra,0x0
  da:	30e080e7          	jalr	782(ra) # 3e4 <getpid>
  de:	85aa                	mv	a1,a0
  e0:	fc840613          	addi	a2,s0,-56
  e4:	00000517          	auipc	a0,0x0
  e8:	79c50513          	addi	a0,a0,1948 # 880 <malloc+0xe6>
  ec:	00000097          	auipc	ra,0x0
  f0:	5f0080e7          	jalr	1520(ra) # 6dc <printf>
  f4:	bf49                	j	86 <main+0x86>

00000000000000f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	addi	a1,a1,1
 100:	0785                	addi	a5,a5,1
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	addi	a0,a0,1
 128:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	addi	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	4685                	li	a3,1
 150:	9e89                	subw	a3,a3,a0
 152:	00f6853b          	addw	a0,a3,a5
 156:	0785                	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	fb7d                	bnez	a4,152 <strlen+0x14>
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ca19                	beqz	a2,184 <memset+0x1c>
 170:	87aa                	mv	a5,a0
 172:	1602                	slli	a2,a2,0x20
 174:	9201                	srli	a2,a2,0x20
 176:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17e:	0785                	addi	a5,a5,1
 180:	fee79de3          	bne	a5,a4,17a <memset+0x12>
  }
  return dst;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb99                	beqz	a5,1aa <strchr+0x20>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1a>
  for(; *s; s++)
 19a:	0505                	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xc>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strchr+0x1a>

00000000000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	711d                	addi	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	addi	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	2485                	addiw	s1,s1,1
 1d4:	0344d863          	bge	s1,s4,204 <gets+0x56>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	addi	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	19c080e7          	jalr	412(ra) # 37c <read>
    if(cc < 1)
 1e8:	00a05e63          	blez	a0,204 <gets+0x56>
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f4:	01578763          	beq	a5,s5,202 <gets+0x54>
 1f8:	0905                	addi	s2,s2,1
 1fa:	fd679be3          	bne	a5,s6,1d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 1fe:	89a6                	mv	s3,s1
 200:	a011                	j	204 <gets+0x56>
 202:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 204:	99de                	add	s3,s3,s7
 206:	00098023          	sb	zero,0(s3)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	00000097          	auipc	ra,0x0
 236:	172080e7          	jalr	370(ra) # 3a4 <open>
  if(fd < 0)
 23a:	02054563          	bltz	a0,264 <stat+0x42>
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	00000097          	auipc	ra,0x0
 246:	17a080e7          	jalr	378(ra) # 3bc <fstat>
 24a:	892a                	mv	s2,a0
  close(fd);
 24c:	8526                	mv	a0,s1
 24e:	00000097          	auipc	ra,0x0
 252:	13e080e7          	jalr	318(ra) # 38c <close>
  return r;
}
 256:	854a                	mv	a0,s2
 258:	60e2                	ld	ra,24(sp)
 25a:	6442                	ld	s0,16(sp)
 25c:	64a2                	ld	s1,8(sp)
 25e:	6902                	ld	s2,0(sp)
 260:	6105                	addi	sp,sp,32
 262:	8082                	ret
    return -1;
 264:	597d                	li	s2,-1
 266:	bfc5                	j	256 <stat+0x34>

0000000000000268 <atoi>:

int
atoi(const char *s)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26e:	00054603          	lbu	a2,0(a0)
 272:	fd06079b          	addiw	a5,a2,-48
 276:	0ff7f793          	andi	a5,a5,255
 27a:	4725                	li	a4,9
 27c:	02f76963          	bltu	a4,a5,2ae <atoi+0x46>
 280:	86aa                	mv	a3,a0
  n = 0;
 282:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 284:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 286:	0685                	addi	a3,a3,1
 288:	0025179b          	slliw	a5,a0,0x2
 28c:	9fa9                	addw	a5,a5,a0
 28e:	0017979b          	slliw	a5,a5,0x1
 292:	9fb1                	addw	a5,a5,a2
 294:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 298:	0006c603          	lbu	a2,0(a3)
 29c:	fd06071b          	addiw	a4,a2,-48
 2a0:	0ff77713          	andi	a4,a4,255
 2a4:	fee5f1e3          	bgeu	a1,a4,286 <atoi+0x1e>
  return n;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  n = 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <atoi+0x40>

00000000000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57463          	bgeu	a0,a1,2e0 <memmove+0x2e>
    while(n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x28>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d6:	fee79ae3          	bne	a5,a4,2ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e6:	fec05ae3          	blez	a2,2da <memmove+0x28>
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x46>
 308:	bfc9                	j	2da <memmove+0x28>

000000000000030a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca05                	beqz	a2,340 <memcmp+0x36>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x14>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x30>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <memcmp+0x30>

0000000000000344 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34c:	00000097          	auipc	ra,0x0
 350:	f66080e7          	jalr	-154(ra) # 2b2 <memmove>
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35c:	4885                	li	a7,1
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exit>:
.global exit
exit:
 li a7, SYS_exit
 364:	4889                	li	a7,2
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <wait>:
.global wait
wait:
 li a7, SYS_wait
 36c:	488d                	li	a7,3
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 374:	4891                	li	a7,4
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <read>:
.global read
read:
 li a7, SYS_read
 37c:	4895                	li	a7,5
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <write>:
.global write
write:
 li a7, SYS_write
 384:	48c1                	li	a7,16
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <close>:
.global close
close:
 li a7, SYS_close
 38c:	48d5                	li	a7,21
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <kill>:
.global kill
kill:
 li a7, SYS_kill
 394:	4899                	li	a7,6
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exec>:
.global exec
exec:
 li a7, SYS_exec
 39c:	489d                	li	a7,7
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <open>:
.global open
open:
 li a7, SYS_open
 3a4:	48bd                	li	a7,15
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ac:	48c5                	li	a7,17
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b4:	48c9                	li	a7,18
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3bc:	48a1                	li	a7,8
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <link>:
.global link
link:
 li a7, SYS_link
 3c4:	48cd                	li	a7,19
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3cc:	48d1                	li	a7,20
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d4:	48a5                	li	a7,9
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3dc:	48a9                	li	a7,10
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e4:	48ad                	li	a7,11
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ec:	48b1                	li	a7,12
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f4:	48b5                	li	a7,13
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fc:	48b9                	li	a7,14
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 410:	4605                	li	a2,1
 412:	fef40593          	addi	a1,s0,-17
 416:	00000097          	auipc	ra,0x0
 41a:	f6e080e7          	jalr	-146(ra) # 384 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 426:	7139                	addi	sp,sp,-64
 428:	fc06                	sd	ra,56(sp)
 42a:	f822                	sd	s0,48(sp)
 42c:	f426                	sd	s1,40(sp)
 42e:	f04a                	sd	s2,32(sp)
 430:	ec4e                	sd	s3,24(sp)
 432:	0080                	addi	s0,sp,64
 434:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c299                	beqz	a3,43c <printint+0x16>
 438:	0805c863          	bltz	a1,4c8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43c:	2581                	sext.w	a1,a1
  neg = 0;
 43e:	4881                	li	a7,0
 440:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 444:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 446:	2601                	sext.w	a2,a2
 448:	00000517          	auipc	a0,0x0
 44c:	46850513          	addi	a0,a0,1128 # 8b0 <digits>
 450:	883a                	mv	a6,a4
 452:	2705                	addiw	a4,a4,1
 454:	02c5f7bb          	remuw	a5,a1,a2
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	97aa                	add	a5,a5,a0
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 466:	0005879b          	sext.w	a5,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f0e3          	bgeu	a5,a2,450 <printint+0x2a>
  if(neg)
 474:	00088b63          	beqz	a7,48a <printint+0x64>
    buf[i++] = '-';
 478:	fd040793          	addi	a5,s0,-48
 47c:	973e                	add	a4,a4,a5
 47e:	02d00793          	li	a5,45
 482:	fef70823          	sb	a5,-16(a4)
 486:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48a:	02e05863          	blez	a4,4ba <printint+0x94>
 48e:	fc040793          	addi	a5,s0,-64
 492:	00e78933          	add	s2,a5,a4
 496:	fff78993          	addi	s3,a5,-1
 49a:	99ba                	add	s3,s3,a4
 49c:	377d                	addiw	a4,a4,-1
 49e:	1702                	slli	a4,a4,0x20
 4a0:	9301                	srli	a4,a4,0x20
 4a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a6:	fff94583          	lbu	a1,-1(s2)
 4aa:	8526                	mv	a0,s1
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f58080e7          	jalr	-168(ra) # 404 <putc>
  while(--i >= 0)
 4b4:	197d                	addi	s2,s2,-1
 4b6:	ff3918e3          	bne	s2,s3,4a6 <printint+0x80>
}
 4ba:	70e2                	ld	ra,56(sp)
 4bc:	7442                	ld	s0,48(sp)
 4be:	74a2                	ld	s1,40(sp)
 4c0:	7902                	ld	s2,32(sp)
 4c2:	69e2                	ld	s3,24(sp)
 4c4:	6121                	addi	sp,sp,64
 4c6:	8082                	ret
    x = -xx;
 4c8:	40b005bb          	negw	a1,a1
    neg = 1;
 4cc:	4885                	li	a7,1
    x = -xx;
 4ce:	bf8d                	j	440 <printint+0x1a>

00000000000004d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d0:	7119                	addi	sp,sp,-128
 4d2:	fc86                	sd	ra,120(sp)
 4d4:	f8a2                	sd	s0,112(sp)
 4d6:	f4a6                	sd	s1,104(sp)
 4d8:	f0ca                	sd	s2,96(sp)
 4da:	ecce                	sd	s3,88(sp)
 4dc:	e8d2                	sd	s4,80(sp)
 4de:	e4d6                	sd	s5,72(sp)
 4e0:	e0da                	sd	s6,64(sp)
 4e2:	fc5e                	sd	s7,56(sp)
 4e4:	f862                	sd	s8,48(sp)
 4e6:	f466                	sd	s9,40(sp)
 4e8:	f06a                	sd	s10,32(sp)
 4ea:	ec6e                	sd	s11,24(sp)
 4ec:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ee:	0005c903          	lbu	s2,0(a1)
 4f2:	18090f63          	beqz	s2,690 <vprintf+0x1c0>
 4f6:	8aaa                	mv	s5,a0
 4f8:	8b32                	mv	s6,a2
 4fa:	00158493          	addi	s1,a1,1
  state = 0;
 4fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 500:	02500a13          	li	s4,37
      if(c == 'd'){
 504:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 508:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 50c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 510:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 514:	00000b97          	auipc	s7,0x0
 518:	39cb8b93          	addi	s7,s7,924 # 8b0 <digits>
 51c:	a839                	j	53a <vprintf+0x6a>
        putc(fd, c);
 51e:	85ca                	mv	a1,s2
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	ee2080e7          	jalr	-286(ra) # 404 <putc>
 52a:	a019                	j	530 <vprintf+0x60>
    } else if(state == '%'){
 52c:	01498f63          	beq	s3,s4,54a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 530:	0485                	addi	s1,s1,1
 532:	fff4c903          	lbu	s2,-1(s1)
 536:	14090d63          	beqz	s2,690 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 53a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53e:	fe0997e3          	bnez	s3,52c <vprintf+0x5c>
      if(c == '%'){
 542:	fd479ee3          	bne	a5,s4,51e <vprintf+0x4e>
        state = '%';
 546:	89be                	mv	s3,a5
 548:	b7e5                	j	530 <vprintf+0x60>
      if(c == 'd'){
 54a:	05878063          	beq	a5,s8,58a <vprintf+0xba>
      } else if(c == 'l') {
 54e:	05978c63          	beq	a5,s9,5a6 <vprintf+0xd6>
      } else if(c == 'x') {
 552:	07a78863          	beq	a5,s10,5c2 <vprintf+0xf2>
      } else if(c == 'p') {
 556:	09b78463          	beq	a5,s11,5de <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 55a:	07300713          	li	a4,115
 55e:	0ce78663          	beq	a5,a4,62a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 562:	06300713          	li	a4,99
 566:	0ee78e63          	beq	a5,a4,662 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 56a:	11478863          	beq	a5,s4,67a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56e:	85d2                	mv	a1,s4
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e92080e7          	jalr	-366(ra) # 404 <putc>
        putc(fd, c);
 57a:	85ca                	mv	a1,s2
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e86080e7          	jalr	-378(ra) # 404 <putc>
      }
      state = 0;
 586:	4981                	li	s3,0
 588:	b765                	j	530 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 58a:	008b0913          	addi	s2,s6,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000b2583          	lw	a1,0(s6)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e8e080e7          	jalr	-370(ra) # 426 <printint>
 5a0:	8b4a                	mv	s6,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b771                	j	530 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b0913          	addi	s2,s6,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000b2583          	lw	a1,0(s6)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e72080e7          	jalr	-398(ra) # 426 <printint>
 5bc:	8b4a                	mv	s6,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bf85                	j	530 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5c2:	008b0913          	addi	s2,s6,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000b2583          	lw	a1,0(s6)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e56080e7          	jalr	-426(ra) # 426 <printint>
 5d8:	8b4a                	mv	s6,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bf91                	j	530 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5de:	008b0793          	addi	a5,s6,8
 5e2:	f8f43423          	sd	a5,-120(s0)
 5e6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ea:	03000593          	li	a1,48
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e14080e7          	jalr	-492(ra) # 404 <putc>
  putc(fd, 'x');
 5f8:	85ea                	mv	a1,s10
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e08080e7          	jalr	-504(ra) # 404 <putc>
 604:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 606:	03c9d793          	srli	a5,s3,0x3c
 60a:	97de                	add	a5,a5,s7
 60c:	0007c583          	lbu	a1,0(a5)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	df2080e7          	jalr	-526(ra) # 404 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61a:	0992                	slli	s3,s3,0x4
 61c:	397d                	addiw	s2,s2,-1
 61e:	fe0914e3          	bnez	s2,606 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 622:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 626:	4981                	li	s3,0
 628:	b721                	j	530 <vprintf+0x60>
        s = va_arg(ap, char*);
 62a:	008b0993          	addi	s3,s6,8
 62e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 632:	02090163          	beqz	s2,654 <vprintf+0x184>
        while(*s != 0){
 636:	00094583          	lbu	a1,0(s2)
 63a:	c9a1                	beqz	a1,68a <vprintf+0x1ba>
          putc(fd, *s);
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	dc6080e7          	jalr	-570(ra) # 404 <putc>
          s++;
 646:	0905                	addi	s2,s2,1
        while(*s != 0){
 648:	00094583          	lbu	a1,0(s2)
 64c:	f9e5                	bnez	a1,63c <vprintf+0x16c>
        s = va_arg(ap, char*);
 64e:	8b4e                	mv	s6,s3
      state = 0;
 650:	4981                	li	s3,0
 652:	bdf9                	j	530 <vprintf+0x60>
          s = "(null)";
 654:	00000917          	auipc	s2,0x0
 658:	25490913          	addi	s2,s2,596 # 8a8 <malloc+0x10e>
        while(*s != 0){
 65c:	02800593          	li	a1,40
 660:	bff1                	j	63c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 662:	008b0913          	addi	s2,s6,8
 666:	000b4583          	lbu	a1,0(s6)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	d98080e7          	jalr	-616(ra) # 404 <putc>
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	bd65                	j	530 <vprintf+0x60>
        putc(fd, c);
 67a:	85d2                	mv	a1,s4
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	d86080e7          	jalr	-634(ra) # 404 <putc>
      state = 0;
 686:	4981                	li	s3,0
 688:	b565                	j	530 <vprintf+0x60>
        s = va_arg(ap, char*);
 68a:	8b4e                	mv	s6,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b54d                	j	530 <vprintf+0x60>
    }
  }
}
 690:	70e6                	ld	ra,120(sp)
 692:	7446                	ld	s0,112(sp)
 694:	74a6                	ld	s1,104(sp)
 696:	7906                	ld	s2,96(sp)
 698:	69e6                	ld	s3,88(sp)
 69a:	6a46                	ld	s4,80(sp)
 69c:	6aa6                	ld	s5,72(sp)
 69e:	6b06                	ld	s6,64(sp)
 6a0:	7be2                	ld	s7,56(sp)
 6a2:	7c42                	ld	s8,48(sp)
 6a4:	7ca2                	ld	s9,40(sp)
 6a6:	7d02                	ld	s10,32(sp)
 6a8:	6de2                	ld	s11,24(sp)
 6aa:	6109                	addi	sp,sp,128
 6ac:	8082                	ret

00000000000006ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ae:	715d                	addi	sp,sp,-80
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e010                	sd	a2,0(s0)
 6b8:	e414                	sd	a3,8(s0)
 6ba:	e818                	sd	a4,16(s0)
 6bc:	ec1c                	sd	a5,24(s0)
 6be:	03043023          	sd	a6,32(s0)
 6c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ca:	8622                	mv	a2,s0
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e04080e7          	jalr	-508(ra) # 4d0 <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6161                	addi	sp,sp,80
 6da:	8082                	ret

00000000000006dc <printf>:

void
printf(const char *fmt, ...)
{
 6dc:	711d                	addi	sp,sp,-96
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e40c                	sd	a1,8(s0)
 6e6:	e810                	sd	a2,16(s0)
 6e8:	ec14                	sd	a3,24(s0)
 6ea:	f018                	sd	a4,32(s0)
 6ec:	f41c                	sd	a5,40(s0)
 6ee:	03043823          	sd	a6,48(s0)
 6f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	00840613          	addi	a2,s0,8
 6fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fe:	85aa                	mv	a1,a0
 700:	4505                	li	a0,1
 702:	00000097          	auipc	ra,0x0
 706:	dce080e7          	jalr	-562(ra) # 4d0 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6125                	addi	sp,sp,96
 710:	8082                	ret

0000000000000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	1141                	addi	sp,sp,-16
 714:	e422                	sd	s0,8(sp)
 716:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 718:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	00000797          	auipc	a5,0x0
 720:	1ac7b783          	ld	a5,428(a5) # 8c8 <freep>
 724:	a805                	j	754 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 726:	4618                	lw	a4,8(a2)
 728:	9db9                	addw	a1,a1,a4
 72a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72e:	6398                	ld	a4,0(a5)
 730:	6318                	ld	a4,0(a4)
 732:	fee53823          	sd	a4,-16(a0)
 736:	a091                	j	77a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 738:	ff852703          	lw	a4,-8(a0)
 73c:	9e39                	addw	a2,a2,a4
 73e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 740:	ff053703          	ld	a4,-16(a0)
 744:	e398                	sd	a4,0(a5)
 746:	a099                	j	78c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	6398                	ld	a4,0(a5)
 74a:	00e7e463          	bltu	a5,a4,752 <free+0x40>
 74e:	00e6ea63          	bltu	a3,a4,762 <free+0x50>
{
 752:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	fed7fae3          	bgeu	a5,a3,748 <free+0x36>
 758:	6398                	ld	a4,0(a5)
 75a:	00e6e463          	bltu	a3,a4,762 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	fee7eae3          	bltu	a5,a4,752 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 762:	ff852583          	lw	a1,-8(a0)
 766:	6390                	ld	a2,0(a5)
 768:	02059713          	slli	a4,a1,0x20
 76c:	9301                	srli	a4,a4,0x20
 76e:	0712                	slli	a4,a4,0x4
 770:	9736                	add	a4,a4,a3
 772:	fae60ae3          	beq	a2,a4,726 <free+0x14>
    bp->s.ptr = p->s.ptr;
 776:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77a:	4790                	lw	a2,8(a5)
 77c:	02061713          	slli	a4,a2,0x20
 780:	9301                	srli	a4,a4,0x20
 782:	0712                	slli	a4,a4,0x4
 784:	973e                	add	a4,a4,a5
 786:	fae689e3          	beq	a3,a4,738 <free+0x26>
  } else
    p->s.ptr = bp;
 78a:	e394                	sd	a3,0(a5)
  freep = p;
 78c:	00000717          	auipc	a4,0x0
 790:	12f73e23          	sd	a5,316(a4) # 8c8 <freep>
}
 794:	6422                	ld	s0,8(sp)
 796:	0141                	addi	sp,sp,16
 798:	8082                	ret

000000000000079a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79a:	7139                	addi	sp,sp,-64
 79c:	fc06                	sd	ra,56(sp)
 79e:	f822                	sd	s0,48(sp)
 7a0:	f426                	sd	s1,40(sp)
 7a2:	f04a                	sd	s2,32(sp)
 7a4:	ec4e                	sd	s3,24(sp)
 7a6:	e852                	sd	s4,16(sp)
 7a8:	e456                	sd	s5,8(sp)
 7aa:	e05a                	sd	s6,0(sp)
 7ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	02051493          	slli	s1,a0,0x20
 7b2:	9081                	srli	s1,s1,0x20
 7b4:	04bd                	addi	s1,s1,15
 7b6:	8091                	srli	s1,s1,0x4
 7b8:	0014899b          	addiw	s3,s1,1
 7bc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7be:	00000517          	auipc	a0,0x0
 7c2:	10a53503          	ld	a0,266(a0) # 8c8 <freep>
 7c6:	c515                	beqz	a0,7f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ca:	4798                	lw	a4,8(a5)
 7cc:	02977f63          	bgeu	a4,s1,80a <malloc+0x70>
 7d0:	8a4e                	mv	s4,s3
 7d2:	0009871b          	sext.w	a4,s3
 7d6:	6685                	lui	a3,0x1
 7d8:	00d77363          	bgeu	a4,a3,7de <malloc+0x44>
 7dc:	6a05                	lui	s4,0x1
 7de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e6:	00000917          	auipc	s2,0x0
 7ea:	0e290913          	addi	s2,s2,226 # 8c8 <freep>
  if(p == (char*)-1)
 7ee:	5afd                	li	s5,-1
 7f0:	a88d                	j	862 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7f2:	00000797          	auipc	a5,0x0
 7f6:	0de78793          	addi	a5,a5,222 # 8d0 <base>
 7fa:	00000717          	auipc	a4,0x0
 7fe:	0cf73723          	sd	a5,206(a4) # 8c8 <freep>
 802:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 804:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 808:	b7e1                	j	7d0 <malloc+0x36>
      if(p->s.size == nunits)
 80a:	02e48b63          	beq	s1,a4,840 <malloc+0xa6>
        p->s.size -= nunits;
 80e:	4137073b          	subw	a4,a4,s3
 812:	c798                	sw	a4,8(a5)
        p += p->s.size;
 814:	1702                	slli	a4,a4,0x20
 816:	9301                	srli	a4,a4,0x20
 818:	0712                	slli	a4,a4,0x4
 81a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 820:	00000717          	auipc	a4,0x0
 824:	0aa73423          	sd	a0,168(a4) # 8c8 <freep>
      return (void*)(p + 1);
 828:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82c:	70e2                	ld	ra,56(sp)
 82e:	7442                	ld	s0,48(sp)
 830:	74a2                	ld	s1,40(sp)
 832:	7902                	ld	s2,32(sp)
 834:	69e2                	ld	s3,24(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
 83c:	6121                	addi	sp,sp,64
 83e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	e118                	sd	a4,0(a0)
 844:	bff1                	j	820 <malloc+0x86>
  hp->s.size = nu;
 846:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84a:	0541                	addi	a0,a0,16
 84c:	00000097          	auipc	ra,0x0
 850:	ec6080e7          	jalr	-314(ra) # 712 <free>
  return freep;
 854:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 858:	d971                	beqz	a0,82c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	fa9776e3          	bgeu	a4,s1,80a <malloc+0x70>
    if(p == freep)
 862:	00093703          	ld	a4,0(s2)
 866:	853e                	mv	a0,a5
 868:	fef719e3          	bne	a4,a5,85a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 86c:	8552                	mv	a0,s4
 86e:	00000097          	auipc	ra,0x0
 872:	b7e080e7          	jalr	-1154(ra) # 3ec <sbrk>
  if(p == (char*)-1)
 876:	fd5518e3          	bne	a0,s5,846 <malloc+0xac>
        return 0;
 87a:	4501                	li	a0,0
 87c:	bf45                	j	82c <malloc+0x92>
