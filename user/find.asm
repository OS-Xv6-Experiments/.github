
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_name>:
#include "user/user.h"

/*
  将路径格式化为文件名
*/
char* fmt_name(char* path) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char* p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--);
   e:	00000097          	auipc	ra,0x0
  12:	2ea080e7          	jalr	746(ra) # 2f8 <strlen>
  16:	02051593          	slli	a1,a0,0x20
  1a:	9181                	srli	a1,a1,0x20
  1c:	95a6                	add	a1,a1,s1
  1e:	02f00713          	li	a4,47
  22:	0095e963          	bltu	a1,s1,34 <fmt_name+0x34>
  26:	0005c783          	lbu	a5,0(a1)
  2a:	00e78563          	beq	a5,a4,34 <fmt_name+0x34>
  2e:	15fd                	addi	a1,a1,-1
  30:	fe95fbe3          	bgeu	a1,s1,26 <fmt_name+0x26>
  p++;
  34:	00158493          	addi	s1,a1,1
  memmove(buf, p, strlen(p) + 1);
  38:	8526                	mv	a0,s1
  3a:	00000097          	auipc	ra,0x0
  3e:	2be080e7          	jalr	702(ra) # 2f8 <strlen>
  42:	00001917          	auipc	s2,0x1
  46:	ab690913          	addi	s2,s2,-1354 # af8 <buf.1112>
  4a:	0015061b          	addiw	a2,a0,1
  4e:	85a6                	mv	a1,s1
  50:	854a                	mv	a0,s2
  52:	00000097          	auipc	ra,0x0
  56:	41e080e7          	jalr	1054(ra) # 470 <memmove>
  return buf;
}
  5a:	854a                	mv	a0,s2
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6902                	ld	s2,0(sp)
  64:	6105                	addi	sp,sp,32
  66:	8082                	ret

0000000000000068 <eq_print>:
/*
  系统文件名与要查找的文件名，若一致，打印系统文件完整路径
*/
void eq_print(char* fileName, char* findName) {
  68:	1101                	addi	sp,sp,-32
  6a:	ec06                	sd	ra,24(sp)
  6c:	e822                	sd	s0,16(sp)
  6e:	e426                	sd	s1,8(sp)
  70:	e04a                	sd	s2,0(sp)
  72:	1000                	addi	s0,sp,32
  74:	892a                	mv	s2,a0
  76:	84ae                	mv	s1,a1
  if (strcmp(fmt_name(fileName), findName) == 0) {
  78:	00000097          	auipc	ra,0x0
  7c:	f88080e7          	jalr	-120(ra) # 0 <fmt_name>
  80:	85a6                	mv	a1,s1
  82:	00000097          	auipc	ra,0x0
  86:	24a080e7          	jalr	586(ra) # 2cc <strcmp>
  8a:	c519                	beqz	a0,98 <eq_print+0x30>
    printf("%s\n", fileName);
  }
}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6902                	ld	s2,0(sp)
  94:	6105                	addi	sp,sp,32
  96:	8082                	ret
    printf("%s\n", fileName);
  98:	85ca                	mv	a1,s2
  9a:	00001517          	auipc	a0,0x1
  9e:	9b650513          	addi	a0,a0,-1610 # a50 <malloc+0xe4>
  a2:	00001097          	auipc	ra,0x1
  a6:	80c080e7          	jalr	-2036(ra) # 8ae <printf>
}
  aa:	b7cd                	j	8c <eq_print+0x24>

00000000000000ac <find>:
/*
  在某路径中查找某文件
*/
void find(char* path, char* findName) {
  ac:	d8010113          	addi	sp,sp,-640
  b0:	26113c23          	sd	ra,632(sp)
  b4:	26813823          	sd	s0,624(sp)
  b8:	26913423          	sd	s1,616(sp)
  bc:	27213023          	sd	s2,608(sp)
  c0:	25313c23          	sd	s3,600(sp)
  c4:	25413823          	sd	s4,592(sp)
  c8:	25513423          	sd	s5,584(sp)
  cc:	25613023          	sd	s6,576(sp)
  d0:	23713c23          	sd	s7,568(sp)
  d4:	0500                	addi	s0,sp,640
  d6:	892a                	mv	s2,a0
  d8:	89ae                	mv	s3,a1
  int fd;
  struct stat st;
  if ((fd = open(path, O_RDONLY)) < 0) {
  da:	4581                	li	a1,0
  dc:	00000097          	auipc	ra,0x0
  e0:	48a080e7          	jalr	1162(ra) # 566 <open>
  e4:	06054563          	bltz	a0,14e <find+0xa2>
  e8:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }
  if (fstat(fd, &st) < 0) {
  ea:	f9840593          	addi	a1,s0,-104
  ee:	00000097          	auipc	ra,0x0
  f2:	490080e7          	jalr	1168(ra) # 57e <fstat>
  f6:	06054763          	bltz	a0,164 <find+0xb8>
    close(fd);
    return;
  }
  char buf[512], * p;
  struct dirent de;
  switch (st.type) {
  fa:	fa041783          	lh	a5,-96(s0)
  fe:	0007869b          	sext.w	a3,a5
 102:	4705                	li	a4,1
 104:	08e68063          	beq	a3,a4,184 <find+0xd8>
 108:	4709                	li	a4,2
 10a:	00e69863          	bne	a3,a4,11a <find+0x6e>
  case T_FILE:
    eq_print(path, findName);
 10e:	85ce                	mv	a1,s3
 110:	854a                	mv	a0,s2
 112:	00000097          	auipc	ra,0x0
 116:	f56080e7          	jalr	-170(ra) # 68 <eq_print>
      p[strlen(de.name)] = 0;
      find(buf, findName);
    }
    break;
  }
  close(fd);
 11a:	8526                	mv	a0,s1
 11c:	00000097          	auipc	ra,0x0
 120:	432080e7          	jalr	1074(ra) # 54e <close>
}
 124:	27813083          	ld	ra,632(sp)
 128:	27013403          	ld	s0,624(sp)
 12c:	26813483          	ld	s1,616(sp)
 130:	26013903          	ld	s2,608(sp)
 134:	25813983          	ld	s3,600(sp)
 138:	25013a03          	ld	s4,592(sp)
 13c:	24813a83          	ld	s5,584(sp)
 140:	24013b03          	ld	s6,576(sp)
 144:	23813b83          	ld	s7,568(sp)
 148:	28010113          	addi	sp,sp,640
 14c:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
 14e:	864a                	mv	a2,s2
 150:	00001597          	auipc	a1,0x1
 154:	90858593          	addi	a1,a1,-1784 # a58 <malloc+0xec>
 158:	4509                	li	a0,2
 15a:	00000097          	auipc	ra,0x0
 15e:	726080e7          	jalr	1830(ra) # 880 <fprintf>
    return;
 162:	b7c9                	j	124 <find+0x78>
    fprintf(2, "find: cannot stat %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	90a58593          	addi	a1,a1,-1782 # a70 <malloc+0x104>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	710080e7          	jalr	1808(ra) # 880 <fprintf>
    close(fd);
 178:	8526                	mv	a0,s1
 17a:	00000097          	auipc	ra,0x0
 17e:	3d4080e7          	jalr	980(ra) # 54e <close>
    return;
 182:	b74d                	j	124 <find+0x78>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 184:	854a                	mv	a0,s2
 186:	00000097          	auipc	ra,0x0
 18a:	172080e7          	jalr	370(ra) # 2f8 <strlen>
 18e:	2541                	addiw	a0,a0,16
 190:	20000793          	li	a5,512
 194:	00a7fb63          	bgeu	a5,a0,1aa <find+0xfe>
      printf("find: path too long\n");
 198:	00001517          	auipc	a0,0x1
 19c:	8f050513          	addi	a0,a0,-1808 # a88 <malloc+0x11c>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	70e080e7          	jalr	1806(ra) # 8ae <printf>
      break;
 1a8:	bf8d                	j	11a <find+0x6e>
    strcpy(buf, path);
 1aa:	85ca                	mv	a1,s2
 1ac:	d9840513          	addi	a0,s0,-616
 1b0:	00000097          	auipc	ra,0x0
 1b4:	100080e7          	jalr	256(ra) # 2b0 <strcpy>
    p = buf + strlen(buf);
 1b8:	d9840513          	addi	a0,s0,-616
 1bc:	00000097          	auipc	ra,0x0
 1c0:	13c080e7          	jalr	316(ra) # 2f8 <strlen>
 1c4:	1502                	slli	a0,a0,0x20
 1c6:	9101                	srli	a0,a0,0x20
 1c8:	d9840793          	addi	a5,s0,-616
 1cc:	953e                	add	a0,a0,a5
    *p++ = '/';
 1ce:	00150b13          	addi	s6,a0,1
 1d2:	02f00793          	li	a5,47
 1d6:	00f50023          	sb	a5,0(a0)
      if (de.inum == 0 || de.inum == 1 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 1da:	4905                	li	s2,1
 1dc:	00001a97          	auipc	s5,0x1
 1e0:	8c4a8a93          	addi	s5,s5,-1852 # aa0 <malloc+0x134>
 1e4:	00001b97          	auipc	s7,0x1
 1e8:	8c4b8b93          	addi	s7,s7,-1852 # aa8 <malloc+0x13c>
 1ec:	d8a40a13          	addi	s4,s0,-630
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1f0:	4641                	li	a2,16
 1f2:	d8840593          	addi	a1,s0,-632
 1f6:	8526                	mv	a0,s1
 1f8:	00000097          	auipc	ra,0x0
 1fc:	346080e7          	jalr	838(ra) # 53e <read>
 200:	47c1                	li	a5,16
 202:	f0f51ce3          	bne	a0,a5,11a <find+0x6e>
      if (de.inum == 0 || de.inum == 1 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 206:	d8845783          	lhu	a5,-632(s0)
 20a:	fef973e3          	bgeu	s2,a5,1f0 <find+0x144>
 20e:	85d6                	mv	a1,s5
 210:	8552                	mv	a0,s4
 212:	00000097          	auipc	ra,0x0
 216:	0ba080e7          	jalr	186(ra) # 2cc <strcmp>
 21a:	d979                	beqz	a0,1f0 <find+0x144>
 21c:	85de                	mv	a1,s7
 21e:	8552                	mv	a0,s4
 220:	00000097          	auipc	ra,0x0
 224:	0ac080e7          	jalr	172(ra) # 2cc <strcmp>
 228:	d561                	beqz	a0,1f0 <find+0x144>
      memmove(p, de.name, strlen(de.name));
 22a:	d8a40513          	addi	a0,s0,-630
 22e:	00000097          	auipc	ra,0x0
 232:	0ca080e7          	jalr	202(ra) # 2f8 <strlen>
 236:	0005061b          	sext.w	a2,a0
 23a:	d8a40593          	addi	a1,s0,-630
 23e:	855a                	mv	a0,s6
 240:	00000097          	auipc	ra,0x0
 244:	230080e7          	jalr	560(ra) # 470 <memmove>
      p[strlen(de.name)] = 0;
 248:	d8a40513          	addi	a0,s0,-630
 24c:	00000097          	auipc	ra,0x0
 250:	0ac080e7          	jalr	172(ra) # 2f8 <strlen>
 254:	02051793          	slli	a5,a0,0x20
 258:	9381                	srli	a5,a5,0x20
 25a:	97da                	add	a5,a5,s6
 25c:	00078023          	sb	zero,0(a5)
      find(buf, findName);
 260:	85ce                	mv	a1,s3
 262:	d9840513          	addi	a0,s0,-616
 266:	00000097          	auipc	ra,0x0
 26a:	e46080e7          	jalr	-442(ra) # ac <find>
 26e:	b749                	j	1f0 <find+0x144>

0000000000000270 <main>:

int main(int argc, char* argv[]) {
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  if (argc < 3) {
 278:	4709                	li	a4,2
 27a:	00a74f63          	blt	a4,a0,298 <main+0x28>
    printf("find: find <path> <fileName>\n");
 27e:	00001517          	auipc	a0,0x1
 282:	83250513          	addi	a0,a0,-1998 # ab0 <malloc+0x144>
 286:	00000097          	auipc	ra,0x0
 28a:	628080e7          	jalr	1576(ra) # 8ae <printf>
    exit(0);
 28e:	4501                	li	a0,0
 290:	00000097          	auipc	ra,0x0
 294:	296080e7          	jalr	662(ra) # 526 <exit>
 298:	87ae                	mv	a5,a1
  }
  find(argv[1], argv[2]);
 29a:	698c                	ld	a1,16(a1)
 29c:	6788                	ld	a0,8(a5)
 29e:	00000097          	auipc	ra,0x0
 2a2:	e0e080e7          	jalr	-498(ra) # ac <find>
  exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	27e080e7          	jalr	638(ra) # 526 <exit>

00000000000002b0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b6:	87aa                	mv	a5,a0
 2b8:	0585                	addi	a1,a1,1
 2ba:	0785                	addi	a5,a5,1
 2bc:	fff5c703          	lbu	a4,-1(a1)
 2c0:	fee78fa3          	sb	a4,-1(a5)
 2c4:	fb75                	bnez	a4,2b8 <strcpy+0x8>
    ;
  return os;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	cb91                	beqz	a5,2ea <strcmp+0x1e>
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00f71763          	bne	a4,a5,2ea <strcmp+0x1e>
    p++, q++;
 2e0:	0505                	addi	a0,a0,1
 2e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	fbe5                	bnez	a5,2d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ea:	0005c503          	lbu	a0,0(a1)
}
 2ee:	40a7853b          	subw	a0,a5,a0
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strlen>:

uint
strlen(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	cf91                	beqz	a5,31e <strlen+0x26>
 304:	0505                	addi	a0,a0,1
 306:	87aa                	mv	a5,a0
 308:	4685                	li	a3,1
 30a:	9e89                	subw	a3,a3,a0
 30c:	00f6853b          	addw	a0,a3,a5
 310:	0785                	addi	a5,a5,1
 312:	fff7c703          	lbu	a4,-1(a5)
 316:	fb7d                	bnez	a4,30c <strlen+0x14>
    ;
  return n;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  for(n = 0; s[n]; n++)
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <strlen+0x20>

0000000000000322 <memset>:

void*
memset(void *dst, int c, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 328:	ce09                	beqz	a2,342 <memset+0x20>
 32a:	87aa                	mv	a5,a0
 32c:	fff6071b          	addiw	a4,a2,-1
 330:	1702                	slli	a4,a4,0x20
 332:	9301                	srli	a4,a4,0x20
 334:	0705                	addi	a4,a4,1
 336:	972a                	add	a4,a4,a0
    cdst[i] = c;
 338:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 33c:	0785                	addi	a5,a5,1
 33e:	fee79de3          	bne	a5,a4,338 <memset+0x16>
  }
  return dst;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <strchr>:

char*
strchr(const char *s, char c)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 34e:	00054783          	lbu	a5,0(a0)
 352:	cb99                	beqz	a5,368 <strchr+0x20>
    if(*s == c)
 354:	00f58763          	beq	a1,a5,362 <strchr+0x1a>
  for(; *s; s++)
 358:	0505                	addi	a0,a0,1
 35a:	00054783          	lbu	a5,0(a0)
 35e:	fbfd                	bnez	a5,354 <strchr+0xc>
      return (char*)s;
  return 0;
 360:	4501                	li	a0,0
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <strchr+0x1a>

000000000000036c <gets>:

char*
gets(char *buf, int max)
{
 36c:	711d                	addi	sp,sp,-96
 36e:	ec86                	sd	ra,88(sp)
 370:	e8a2                	sd	s0,80(sp)
 372:	e4a6                	sd	s1,72(sp)
 374:	e0ca                	sd	s2,64(sp)
 376:	fc4e                	sd	s3,56(sp)
 378:	f852                	sd	s4,48(sp)
 37a:	f456                	sd	s5,40(sp)
 37c:	f05a                	sd	s6,32(sp)
 37e:	ec5e                	sd	s7,24(sp)
 380:	1080                	addi	s0,sp,96
 382:	8baa                	mv	s7,a0
 384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	892a                	mv	s2,a0
 388:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 38a:	4aa9                	li	s5,10
 38c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 38e:	89a6                	mv	s3,s1
 390:	2485                	addiw	s1,s1,1
 392:	0344d863          	bge	s1,s4,3c2 <gets+0x56>
    cc = read(0, &c, 1);
 396:	4605                	li	a2,1
 398:	faf40593          	addi	a1,s0,-81
 39c:	4501                	li	a0,0
 39e:	00000097          	auipc	ra,0x0
 3a2:	1a0080e7          	jalr	416(ra) # 53e <read>
    if(cc < 1)
 3a6:	00a05e63          	blez	a0,3c2 <gets+0x56>
    buf[i++] = c;
 3aa:	faf44783          	lbu	a5,-81(s0)
 3ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b2:	01578763          	beq	a5,s5,3c0 <gets+0x54>
 3b6:	0905                	addi	s2,s2,1
 3b8:	fd679be3          	bne	a5,s6,38e <gets+0x22>
  for(i=0; i+1 < max; ){
 3bc:	89a6                	mv	s3,s1
 3be:	a011                	j	3c2 <gets+0x56>
 3c0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c2:	99de                	add	s3,s3,s7
 3c4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c8:	855e                	mv	a0,s7
 3ca:	60e6                	ld	ra,88(sp)
 3cc:	6446                	ld	s0,80(sp)
 3ce:	64a6                	ld	s1,72(sp)
 3d0:	6906                	ld	s2,64(sp)
 3d2:	79e2                	ld	s3,56(sp)
 3d4:	7a42                	ld	s4,48(sp)
 3d6:	7aa2                	ld	s5,40(sp)
 3d8:	7b02                	ld	s6,32(sp)
 3da:	6be2                	ld	s7,24(sp)
 3dc:	6125                	addi	sp,sp,96
 3de:	8082                	ret

00000000000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	e426                	sd	s1,8(sp)
 3e8:	e04a                	sd	s2,0(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ee:	4581                	li	a1,0
 3f0:	00000097          	auipc	ra,0x0
 3f4:	176080e7          	jalr	374(ra) # 566 <open>
  if(fd < 0)
 3f8:	02054563          	bltz	a0,422 <stat+0x42>
 3fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fe:	85ca                	mv	a1,s2
 400:	00000097          	auipc	ra,0x0
 404:	17e080e7          	jalr	382(ra) # 57e <fstat>
 408:	892a                	mv	s2,a0
  close(fd);
 40a:	8526                	mv	a0,s1
 40c:	00000097          	auipc	ra,0x0
 410:	142080e7          	jalr	322(ra) # 54e <close>
  return r;
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	64a2                	ld	s1,8(sp)
 41c:	6902                	ld	s2,0(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret
    return -1;
 422:	597d                	li	s2,-1
 424:	bfc5                	j	414 <stat+0x34>

0000000000000426 <atoi>:

int
atoi(const char *s)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42c:	00054603          	lbu	a2,0(a0)
 430:	fd06079b          	addiw	a5,a2,-48
 434:	0ff7f793          	andi	a5,a5,255
 438:	4725                	li	a4,9
 43a:	02f76963          	bltu	a4,a5,46c <atoi+0x46>
 43e:	86aa                	mv	a3,a0
  n = 0;
 440:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 442:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 444:	0685                	addi	a3,a3,1
 446:	0025179b          	slliw	a5,a0,0x2
 44a:	9fa9                	addw	a5,a5,a0
 44c:	0017979b          	slliw	a5,a5,0x1
 450:	9fb1                	addw	a5,a5,a2
 452:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 456:	0006c603          	lbu	a2,0(a3)
 45a:	fd06071b          	addiw	a4,a2,-48
 45e:	0ff77713          	andi	a4,a4,255
 462:	fee5f1e3          	bgeu	a1,a4,444 <atoi+0x1e>
  return n;
}
 466:	6422                	ld	s0,8(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  n = 0;
 46c:	4501                	li	a0,0
 46e:	bfe5                	j	466 <atoi+0x40>

0000000000000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 476:	02b57663          	bgeu	a0,a1,4a2 <memmove+0x32>
    while(n-- > 0)
 47a:	02c05163          	blez	a2,49c <memmove+0x2c>
 47e:	fff6079b          	addiw	a5,a2,-1
 482:	1782                	slli	a5,a5,0x20
 484:	9381                	srli	a5,a5,0x20
 486:	0785                	addi	a5,a5,1
 488:	97aa                	add	a5,a5,a0
  dst = vdst;
 48a:	872a                	mv	a4,a0
      *dst++ = *src++;
 48c:	0585                	addi	a1,a1,1
 48e:	0705                	addi	a4,a4,1
 490:	fff5c683          	lbu	a3,-1(a1)
 494:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 498:	fee79ae3          	bne	a5,a4,48c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    dst += n;
 4a2:	00c50733          	add	a4,a0,a2
    src += n;
 4a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a8:	fec05ae3          	blez	a2,49c <memmove+0x2c>
 4ac:	fff6079b          	addiw	a5,a2,-1
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ba:	15fd                	addi	a1,a1,-1
 4bc:	177d                	addi	a4,a4,-1
 4be:	0005c683          	lbu	a3,0(a1)
 4c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c6:	fee79ae3          	bne	a5,a4,4ba <memmove+0x4a>
 4ca:	bfc9                	j	49c <memmove+0x2c>

00000000000004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d2:	ca05                	beqz	a2,502 <memcmp+0x36>
 4d4:	fff6069b          	addiw	a3,a2,-1
 4d8:	1682                	slli	a3,a3,0x20
 4da:	9281                	srli	a3,a3,0x20
 4dc:	0685                	addi	a3,a3,1
 4de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e0:	00054783          	lbu	a5,0(a0)
 4e4:	0005c703          	lbu	a4,0(a1)
 4e8:	00e79863          	bne	a5,a4,4f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4ec:	0505                	addi	a0,a0,1
    p2++;
 4ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f0:	fed518e3          	bne	a0,a3,4e0 <memcmp+0x14>
  }
  return 0;
 4f4:	4501                	li	a0,0
 4f6:	a019                	j	4fc <memcmp+0x30>
      return *p1 - *p2;
 4f8:	40e7853b          	subw	a0,a5,a4
}
 4fc:	6422                	ld	s0,8(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret
  return 0;
 502:	4501                	li	a0,0
 504:	bfe5                	j	4fc <memcmp+0x30>

0000000000000506 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 506:	1141                	addi	sp,sp,-16
 508:	e406                	sd	ra,8(sp)
 50a:	e022                	sd	s0,0(sp)
 50c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 50e:	00000097          	auipc	ra,0x0
 512:	f62080e7          	jalr	-158(ra) # 470 <memmove>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51e:	4885                	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exit>:
.global exit
exit:
 li a7, SYS_exit
 526:	4889                	li	a7,2
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait>:
.global wait
wait:
 li a7, SYS_wait
 52e:	488d                	li	a7,3
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 536:	4891                	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <read>:
.global read
read:
 li a7, SYS_read
 53e:	4895                	li	a7,5
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <write>:
.global write
write:
 li a7, SYS_write
 546:	48c1                	li	a7,16
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kill>:
.global kill
kill:
 li a7, SYS_kill
 556:	4899                	li	a7,6
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exec>:
.global exec
exec:
 li a7, SYS_exec
 55e:	489d                	li	a7,7
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <open>:
.global open
open:
 li a7, SYS_open
 566:	48bd                	li	a7,15
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56e:	48c5                	li	a7,17
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 576:	48c9                	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57e:	48a1                	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <link>:
.global link
link:
 li a7, SYS_link
 586:	48cd                	li	a7,19
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58e:	48d1                	li	a7,20
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 596:	48a5                	li	a7,9
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <dup>:
.global dup
dup:
 li a7, SYS_dup
 59e:	48a9                	li	a7,10
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a6:	48ad                	li	a7,11
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ae:	48b1                	li	a7,12
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b6:	48b5                	li	a7,13
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5be:	48b9                	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5c6:	48d9                	li	a7,22
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5ce:	48dd                	li	a7,23
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	addi	s0,sp,32
 5de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e2:	4605                	li	a2,1
 5e4:	fef40593          	addi	a1,s0,-17
 5e8:	00000097          	auipc	ra,0x0
 5ec:	f5e080e7          	jalr	-162(ra) # 546 <write>
}
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	6105                	addi	sp,sp,32
 5f6:	8082                	ret

00000000000005f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f8:	7139                	addi	sp,sp,-64
 5fa:	fc06                	sd	ra,56(sp)
 5fc:	f822                	sd	s0,48(sp)
 5fe:	f426                	sd	s1,40(sp)
 600:	f04a                	sd	s2,32(sp)
 602:	ec4e                	sd	s3,24(sp)
 604:	0080                	addi	s0,sp,64
 606:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 608:	c299                	beqz	a3,60e <printint+0x16>
 60a:	0805c863          	bltz	a1,69a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 60e:	2581                	sext.w	a1,a1
  neg = 0;
 610:	4881                	li	a7,0
 612:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 616:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 618:	2601                	sext.w	a2,a2
 61a:	00000517          	auipc	a0,0x0
 61e:	4be50513          	addi	a0,a0,1214 # ad8 <digits>
 622:	883a                	mv	a6,a4
 624:	2705                	addiw	a4,a4,1
 626:	02c5f7bb          	remuw	a5,a1,a2
 62a:	1782                	slli	a5,a5,0x20
 62c:	9381                	srli	a5,a5,0x20
 62e:	97aa                	add	a5,a5,a0
 630:	0007c783          	lbu	a5,0(a5)
 634:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 638:	0005879b          	sext.w	a5,a1
 63c:	02c5d5bb          	divuw	a1,a1,a2
 640:	0685                	addi	a3,a3,1
 642:	fec7f0e3          	bgeu	a5,a2,622 <printint+0x2a>
  if(neg)
 646:	00088b63          	beqz	a7,65c <printint+0x64>
    buf[i++] = '-';
 64a:	fd040793          	addi	a5,s0,-48
 64e:	973e                	add	a4,a4,a5
 650:	02d00793          	li	a5,45
 654:	fef70823          	sb	a5,-16(a4)
 658:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 65c:	02e05863          	blez	a4,68c <printint+0x94>
 660:	fc040793          	addi	a5,s0,-64
 664:	00e78933          	add	s2,a5,a4
 668:	fff78993          	addi	s3,a5,-1
 66c:	99ba                	add	s3,s3,a4
 66e:	377d                	addiw	a4,a4,-1
 670:	1702                	slli	a4,a4,0x20
 672:	9301                	srli	a4,a4,0x20
 674:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 678:	fff94583          	lbu	a1,-1(s2)
 67c:	8526                	mv	a0,s1
 67e:	00000097          	auipc	ra,0x0
 682:	f58080e7          	jalr	-168(ra) # 5d6 <putc>
  while(--i >= 0)
 686:	197d                	addi	s2,s2,-1
 688:	ff3918e3          	bne	s2,s3,678 <printint+0x80>
}
 68c:	70e2                	ld	ra,56(sp)
 68e:	7442                	ld	s0,48(sp)
 690:	74a2                	ld	s1,40(sp)
 692:	7902                	ld	s2,32(sp)
 694:	69e2                	ld	s3,24(sp)
 696:	6121                	addi	sp,sp,64
 698:	8082                	ret
    x = -xx;
 69a:	40b005bb          	negw	a1,a1
    neg = 1;
 69e:	4885                	li	a7,1
    x = -xx;
 6a0:	bf8d                	j	612 <printint+0x1a>

00000000000006a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a2:	7119                	addi	sp,sp,-128
 6a4:	fc86                	sd	ra,120(sp)
 6a6:	f8a2                	sd	s0,112(sp)
 6a8:	f4a6                	sd	s1,104(sp)
 6aa:	f0ca                	sd	s2,96(sp)
 6ac:	ecce                	sd	s3,88(sp)
 6ae:	e8d2                	sd	s4,80(sp)
 6b0:	e4d6                	sd	s5,72(sp)
 6b2:	e0da                	sd	s6,64(sp)
 6b4:	fc5e                	sd	s7,56(sp)
 6b6:	f862                	sd	s8,48(sp)
 6b8:	f466                	sd	s9,40(sp)
 6ba:	f06a                	sd	s10,32(sp)
 6bc:	ec6e                	sd	s11,24(sp)
 6be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c0:	0005c903          	lbu	s2,0(a1)
 6c4:	18090f63          	beqz	s2,862 <vprintf+0x1c0>
 6c8:	8aaa                	mv	s5,a0
 6ca:	8b32                	mv	s6,a2
 6cc:	00158493          	addi	s1,a1,1
  state = 0;
 6d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6d2:	02500a13          	li	s4,37
      if(c == 'd'){
 6d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	00000b97          	auipc	s7,0x0
 6ea:	3f2b8b93          	addi	s7,s7,1010 # ad8 <digits>
 6ee:	a839                	j	70c <vprintf+0x6a>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	ee2080e7          	jalr	-286(ra) # 5d6 <putc>
 6fc:	a019                	j	702 <vprintf+0x60>
    } else if(state == '%'){
 6fe:	01498f63          	beq	s3,s4,71c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 702:	0485                	addi	s1,s1,1
 704:	fff4c903          	lbu	s2,-1(s1)
 708:	14090d63          	beqz	s2,862 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 70c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 710:	fe0997e3          	bnez	s3,6fe <vprintf+0x5c>
      if(c == '%'){
 714:	fd479ee3          	bne	a5,s4,6f0 <vprintf+0x4e>
        state = '%';
 718:	89be                	mv	s3,a5
 71a:	b7e5                	j	702 <vprintf+0x60>
      if(c == 'd'){
 71c:	05878063          	beq	a5,s8,75c <vprintf+0xba>
      } else if(c == 'l') {
 720:	05978c63          	beq	a5,s9,778 <vprintf+0xd6>
      } else if(c == 'x') {
 724:	07a78863          	beq	a5,s10,794 <vprintf+0xf2>
      } else if(c == 'p') {
 728:	09b78463          	beq	a5,s11,7b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 72c:	07300713          	li	a4,115
 730:	0ce78663          	beq	a5,a4,7fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 734:	06300713          	li	a4,99
 738:	0ee78e63          	beq	a5,a4,834 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 73c:	11478863          	beq	a5,s4,84c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 740:	85d2                	mv	a1,s4
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e92080e7          	jalr	-366(ra) # 5d6 <putc>
        putc(fd, c);
 74c:	85ca                	mv	a1,s2
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e86080e7          	jalr	-378(ra) # 5d6 <putc>
      }
      state = 0;
 758:	4981                	li	s3,0
 75a:	b765                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 75c:	008b0913          	addi	s2,s6,8
 760:	4685                	li	a3,1
 762:	4629                	li	a2,10
 764:	000b2583          	lw	a1,0(s6)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e8e080e7          	jalr	-370(ra) # 5f8 <printint>
 772:	8b4a                	mv	s6,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	b771                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	008b0913          	addi	s2,s6,8
 77c:	4681                	li	a3,0
 77e:	4629                	li	a2,10
 780:	000b2583          	lw	a1,0(s6)
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e72080e7          	jalr	-398(ra) # 5f8 <printint>
 78e:	8b4a                	mv	s6,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	bf85                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 794:	008b0913          	addi	s2,s6,8
 798:	4681                	li	a3,0
 79a:	4641                	li	a2,16
 79c:	000b2583          	lw	a1,0(s6)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e56080e7          	jalr	-426(ra) # 5f8 <printint>
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bf91                	j	702 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7b0:	008b0793          	addi	a5,s6,8
 7b4:	f8f43423          	sd	a5,-120(s0)
 7b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7bc:	03000593          	li	a1,48
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e14080e7          	jalr	-492(ra) # 5d6 <putc>
  putc(fd, 'x');
 7ca:	85ea                	mv	a1,s10
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e08080e7          	jalr	-504(ra) # 5d6 <putc>
 7d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d8:	03c9d793          	srli	a5,s3,0x3c
 7dc:	97de                	add	a5,a5,s7
 7de:	0007c583          	lbu	a1,0(a5)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	df2080e7          	jalr	-526(ra) # 5d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ec:	0992                	slli	s3,s3,0x4
 7ee:	397d                	addiw	s2,s2,-1
 7f0:	fe0914e3          	bnez	s2,7d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b721                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 7fc:	008b0993          	addi	s3,s6,8
 800:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 804:	02090163          	beqz	s2,826 <vprintf+0x184>
        while(*s != 0){
 808:	00094583          	lbu	a1,0(s2)
 80c:	c9a1                	beqz	a1,85c <vprintf+0x1ba>
          putc(fd, *s);
 80e:	8556                	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	dc6080e7          	jalr	-570(ra) # 5d6 <putc>
          s++;
 818:	0905                	addi	s2,s2,1
        while(*s != 0){
 81a:	00094583          	lbu	a1,0(s2)
 81e:	f9e5                	bnez	a1,80e <vprintf+0x16c>
        s = va_arg(ap, char*);
 820:	8b4e                	mv	s6,s3
      state = 0;
 822:	4981                	li	s3,0
 824:	bdf9                	j	702 <vprintf+0x60>
          s = "(null)";
 826:	00000917          	auipc	s2,0x0
 82a:	2aa90913          	addi	s2,s2,682 # ad0 <malloc+0x164>
        while(*s != 0){
 82e:	02800593          	li	a1,40
 832:	bff1                	j	80e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 834:	008b0913          	addi	s2,s6,8
 838:	000b4583          	lbu	a1,0(s6)
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	d98080e7          	jalr	-616(ra) # 5d6 <putc>
 846:	8b4a                	mv	s6,s2
      state = 0;
 848:	4981                	li	s3,0
 84a:	bd65                	j	702 <vprintf+0x60>
        putc(fd, c);
 84c:	85d2                	mv	a1,s4
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	d86080e7          	jalr	-634(ra) # 5d6 <putc>
      state = 0;
 858:	4981                	li	s3,0
 85a:	b565                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 85c:	8b4e                	mv	s6,s3
      state = 0;
 85e:	4981                	li	s3,0
 860:	b54d                	j	702 <vprintf+0x60>
    }
  }
}
 862:	70e6                	ld	ra,120(sp)
 864:	7446                	ld	s0,112(sp)
 866:	74a6                	ld	s1,104(sp)
 868:	7906                	ld	s2,96(sp)
 86a:	69e6                	ld	s3,88(sp)
 86c:	6a46                	ld	s4,80(sp)
 86e:	6aa6                	ld	s5,72(sp)
 870:	6b06                	ld	s6,64(sp)
 872:	7be2                	ld	s7,56(sp)
 874:	7c42                	ld	s8,48(sp)
 876:	7ca2                	ld	s9,40(sp)
 878:	7d02                	ld	s10,32(sp)
 87a:	6de2                	ld	s11,24(sp)
 87c:	6109                	addi	sp,sp,128
 87e:	8082                	ret

0000000000000880 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 880:	715d                	addi	sp,sp,-80
 882:	ec06                	sd	ra,24(sp)
 884:	e822                	sd	s0,16(sp)
 886:	1000                	addi	s0,sp,32
 888:	e010                	sd	a2,0(s0)
 88a:	e414                	sd	a3,8(s0)
 88c:	e818                	sd	a4,16(s0)
 88e:	ec1c                	sd	a5,24(s0)
 890:	03043023          	sd	a6,32(s0)
 894:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89c:	8622                	mv	a2,s0
 89e:	00000097          	auipc	ra,0x0
 8a2:	e04080e7          	jalr	-508(ra) # 6a2 <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6161                	addi	sp,sp,80
 8ac:	8082                	ret

00000000000008ae <printf>:

void
printf(const char *fmt, ...)
{
 8ae:	711d                	addi	sp,sp,-96
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e40c                	sd	a1,8(s0)
 8b8:	e810                	sd	a2,16(s0)
 8ba:	ec14                	sd	a3,24(s0)
 8bc:	f018                	sd	a4,32(s0)
 8be:	f41c                	sd	a5,40(s0)
 8c0:	03043823          	sd	a6,48(s0)
 8c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	00840613          	addi	a2,s0,8
 8cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d0:	85aa                	mv	a1,a0
 8d2:	4505                	li	a0,1
 8d4:	00000097          	auipc	ra,0x0
 8d8:	dce080e7          	jalr	-562(ra) # 6a2 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e4:	1141                	addi	sp,sp,-16
 8e6:	e422                	sd	s0,8(sp)
 8e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	00000797          	auipc	a5,0x0
 8f2:	2027b783          	ld	a5,514(a5) # af0 <freep>
 8f6:	a805                	j	926 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9db9                	addw	a1,a1,a4
 8fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6318                	ld	a4,0(a4)
 904:	fee53823          	sd	a4,-16(a0)
 908:	a091                	j	94c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 90a:	ff852703          	lw	a4,-8(a0)
 90e:	9e39                	addw	a2,a2,a4
 910:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 912:	ff053703          	ld	a4,-16(a0)
 916:	e398                	sd	a4,0(a5)
 918:	a099                	j	95e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	6398                	ld	a4,0(a5)
 91c:	00e7e463          	bltu	a5,a4,924 <free+0x40>
 920:	00e6ea63          	bltu	a3,a4,934 <free+0x50>
{
 924:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	fed7fae3          	bgeu	a5,a3,91a <free+0x36>
 92a:	6398                	ld	a4,0(a5)
 92c:	00e6e463          	bltu	a3,a4,934 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	fee7eae3          	bltu	a5,a4,924 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 934:	ff852583          	lw	a1,-8(a0)
 938:	6390                	ld	a2,0(a5)
 93a:	02059713          	slli	a4,a1,0x20
 93e:	9301                	srli	a4,a4,0x20
 940:	0712                	slli	a4,a4,0x4
 942:	9736                	add	a4,a4,a3
 944:	fae60ae3          	beq	a2,a4,8f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 948:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 94c:	4790                	lw	a2,8(a5)
 94e:	02061713          	slli	a4,a2,0x20
 952:	9301                	srli	a4,a4,0x20
 954:	0712                	slli	a4,a4,0x4
 956:	973e                	add	a4,a4,a5
 958:	fae689e3          	beq	a3,a4,90a <free+0x26>
  } else
    p->s.ptr = bp;
 95c:	e394                	sd	a3,0(a5)
  freep = p;
 95e:	00000717          	auipc	a4,0x0
 962:	18f73923          	sd	a5,402(a4) # af0 <freep>
}
 966:	6422                	ld	s0,8(sp)
 968:	0141                	addi	sp,sp,16
 96a:	8082                	ret

000000000000096c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96c:	7139                	addi	sp,sp,-64
 96e:	fc06                	sd	ra,56(sp)
 970:	f822                	sd	s0,48(sp)
 972:	f426                	sd	s1,40(sp)
 974:	f04a                	sd	s2,32(sp)
 976:	ec4e                	sd	s3,24(sp)
 978:	e852                	sd	s4,16(sp)
 97a:	e456                	sd	s5,8(sp)
 97c:	e05a                	sd	s6,0(sp)
 97e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 980:	02051493          	slli	s1,a0,0x20
 984:	9081                	srli	s1,s1,0x20
 986:	04bd                	addi	s1,s1,15
 988:	8091                	srli	s1,s1,0x4
 98a:	0014899b          	addiw	s3,s1,1
 98e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 990:	00000517          	auipc	a0,0x0
 994:	16053503          	ld	a0,352(a0) # af0 <freep>
 998:	c515                	beqz	a0,9c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99c:	4798                	lw	a4,8(a5)
 99e:	02977f63          	bgeu	a4,s1,9dc <malloc+0x70>
 9a2:	8a4e                	mv	s4,s3
 9a4:	0009871b          	sext.w	a4,s3
 9a8:	6685                	lui	a3,0x1
 9aa:	00d77363          	bgeu	a4,a3,9b0 <malloc+0x44>
 9ae:	6a05                	lui	s4,0x1
 9b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b8:	00000917          	auipc	s2,0x0
 9bc:	13890913          	addi	s2,s2,312 # af0 <freep>
  if(p == (char*)-1)
 9c0:	5afd                	li	s5,-1
 9c2:	a88d                	j	a34 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9c4:	00000797          	auipc	a5,0x0
 9c8:	14478793          	addi	a5,a5,324 # b08 <base>
 9cc:	00000717          	auipc	a4,0x0
 9d0:	12f73223          	sd	a5,292(a4) # af0 <freep>
 9d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9da:	b7e1                	j	9a2 <malloc+0x36>
      if(p->s.size == nunits)
 9dc:	02e48b63          	beq	s1,a4,a12 <malloc+0xa6>
        p->s.size -= nunits;
 9e0:	4137073b          	subw	a4,a4,s3
 9e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e6:	1702                	slli	a4,a4,0x20
 9e8:	9301                	srli	a4,a4,0x20
 9ea:	0712                	slli	a4,a4,0x4
 9ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	0ea73f23          	sd	a0,254(a4) # af0 <freep>
      return (void*)(p + 1);
 9fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9fe:	70e2                	ld	ra,56(sp)
 a00:	7442                	ld	s0,48(sp)
 a02:	74a2                	ld	s1,40(sp)
 a04:	7902                	ld	s2,32(sp)
 a06:	69e2                	ld	s3,24(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	6121                	addi	sp,sp,64
 a10:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a12:	6398                	ld	a4,0(a5)
 a14:	e118                	sd	a4,0(a0)
 a16:	bff1                	j	9f2 <malloc+0x86>
  hp->s.size = nu;
 a18:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1c:	0541                	addi	a0,a0,16
 a1e:	00000097          	auipc	ra,0x0
 a22:	ec6080e7          	jalr	-314(ra) # 8e4 <free>
  return freep;
 a26:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a2a:	d971                	beqz	a0,9fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2e:	4798                	lw	a4,8(a5)
 a30:	fa9776e3          	bgeu	a4,s1,9dc <malloc+0x70>
    if(p == freep)
 a34:	00093703          	ld	a4,0(s2)
 a38:	853e                	mv	a0,a5
 a3a:	fef719e3          	bne	a4,a5,a2c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a3e:	8552                	mv	a0,s4
 a40:	00000097          	auipc	ra,0x0
 a44:	b6e080e7          	jalr	-1170(ra) # 5ae <sbrk>
  if(p == (char*)-1)
 a48:	fd5518e3          	bne	a0,s5,a18 <malloc+0xac>
        return 0;
 a4c:	4501                	li	a0,0
 a4e:	bf45                	j	9fe <malloc+0x92>
