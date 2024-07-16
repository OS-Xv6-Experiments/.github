
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
  46:	aa690913          	addi	s2,s2,-1370 # ae8 <buf.1107>
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
  9e:	9a650513          	addi	a0,a0,-1626 # a40 <malloc+0xe4>
  a2:	00000097          	auipc	ra,0x0
  a6:	7fc080e7          	jalr	2044(ra) # 89e <printf>
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
 154:	8f858593          	addi	a1,a1,-1800 # a48 <malloc+0xec>
 158:	4509                	li	a0,2
 15a:	00000097          	auipc	ra,0x0
 15e:	716080e7          	jalr	1814(ra) # 870 <fprintf>
    return;
 162:	b7c9                	j	124 <find+0x78>
    fprintf(2, "find: cannot stat %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	8fa58593          	addi	a1,a1,-1798 # a60 <malloc+0x104>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	700080e7          	jalr	1792(ra) # 870 <fprintf>
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
 19c:	8e050513          	addi	a0,a0,-1824 # a78 <malloc+0x11c>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	6fe080e7          	jalr	1790(ra) # 89e <printf>
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
 1e0:	8b4a8a93          	addi	s5,s5,-1868 # a90 <malloc+0x134>
 1e4:	00001b97          	auipc	s7,0x1
 1e8:	8b4b8b93          	addi	s7,s7,-1868 # a98 <malloc+0x13c>
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
 282:	82250513          	addi	a0,a0,-2014 # aa0 <malloc+0x144>
 286:	00000097          	auipc	ra,0x0
 28a:	618080e7          	jalr	1560(ra) # 89e <printf>
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

00000000000005c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	fef40593          	addi	a1,s0,-17
 5d8:	00000097          	auipc	ra,0x0
 5dc:	f6e080e7          	jalr	-146(ra) # 546 <write>
}
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6442                	ld	s0,16(sp)
 5e4:	6105                	addi	sp,sp,32
 5e6:	8082                	ret

00000000000005e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e8:	7139                	addi	sp,sp,-64
 5ea:	fc06                	sd	ra,56(sp)
 5ec:	f822                	sd	s0,48(sp)
 5ee:	f426                	sd	s1,40(sp)
 5f0:	f04a                	sd	s2,32(sp)
 5f2:	ec4e                	sd	s3,24(sp)
 5f4:	0080                	addi	s0,sp,64
 5f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f8:	c299                	beqz	a3,5fe <printint+0x16>
 5fa:	0805c863          	bltz	a1,68a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5fe:	2581                	sext.w	a1,a1
  neg = 0;
 600:	4881                	li	a7,0
 602:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 606:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 608:	2601                	sext.w	a2,a2
 60a:	00000517          	auipc	a0,0x0
 60e:	4be50513          	addi	a0,a0,1214 # ac8 <digits>
 612:	883a                	mv	a6,a4
 614:	2705                	addiw	a4,a4,1
 616:	02c5f7bb          	remuw	a5,a1,a2
 61a:	1782                	slli	a5,a5,0x20
 61c:	9381                	srli	a5,a5,0x20
 61e:	97aa                	add	a5,a5,a0
 620:	0007c783          	lbu	a5,0(a5)
 624:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 628:	0005879b          	sext.w	a5,a1
 62c:	02c5d5bb          	divuw	a1,a1,a2
 630:	0685                	addi	a3,a3,1
 632:	fec7f0e3          	bgeu	a5,a2,612 <printint+0x2a>
  if(neg)
 636:	00088b63          	beqz	a7,64c <printint+0x64>
    buf[i++] = '-';
 63a:	fd040793          	addi	a5,s0,-48
 63e:	973e                	add	a4,a4,a5
 640:	02d00793          	li	a5,45
 644:	fef70823          	sb	a5,-16(a4)
 648:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 64c:	02e05863          	blez	a4,67c <printint+0x94>
 650:	fc040793          	addi	a5,s0,-64
 654:	00e78933          	add	s2,a5,a4
 658:	fff78993          	addi	s3,a5,-1
 65c:	99ba                	add	s3,s3,a4
 65e:	377d                	addiw	a4,a4,-1
 660:	1702                	slli	a4,a4,0x20
 662:	9301                	srli	a4,a4,0x20
 664:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 668:	fff94583          	lbu	a1,-1(s2)
 66c:	8526                	mv	a0,s1
 66e:	00000097          	auipc	ra,0x0
 672:	f58080e7          	jalr	-168(ra) # 5c6 <putc>
  while(--i >= 0)
 676:	197d                	addi	s2,s2,-1
 678:	ff3918e3          	bne	s2,s3,668 <printint+0x80>
}
 67c:	70e2                	ld	ra,56(sp)
 67e:	7442                	ld	s0,48(sp)
 680:	74a2                	ld	s1,40(sp)
 682:	7902                	ld	s2,32(sp)
 684:	69e2                	ld	s3,24(sp)
 686:	6121                	addi	sp,sp,64
 688:	8082                	ret
    x = -xx;
 68a:	40b005bb          	negw	a1,a1
    neg = 1;
 68e:	4885                	li	a7,1
    x = -xx;
 690:	bf8d                	j	602 <printint+0x1a>

0000000000000692 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 692:	7119                	addi	sp,sp,-128
 694:	fc86                	sd	ra,120(sp)
 696:	f8a2                	sd	s0,112(sp)
 698:	f4a6                	sd	s1,104(sp)
 69a:	f0ca                	sd	s2,96(sp)
 69c:	ecce                	sd	s3,88(sp)
 69e:	e8d2                	sd	s4,80(sp)
 6a0:	e4d6                	sd	s5,72(sp)
 6a2:	e0da                	sd	s6,64(sp)
 6a4:	fc5e                	sd	s7,56(sp)
 6a6:	f862                	sd	s8,48(sp)
 6a8:	f466                	sd	s9,40(sp)
 6aa:	f06a                	sd	s10,32(sp)
 6ac:	ec6e                	sd	s11,24(sp)
 6ae:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b0:	0005c903          	lbu	s2,0(a1)
 6b4:	18090f63          	beqz	s2,852 <vprintf+0x1c0>
 6b8:	8aaa                	mv	s5,a0
 6ba:	8b32                	mv	s6,a2
 6bc:	00158493          	addi	s1,a1,1
  state = 0;
 6c0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6c2:	02500a13          	li	s4,37
      if(c == 'd'){
 6c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6ca:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6ce:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6d2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d6:	00000b97          	auipc	s7,0x0
 6da:	3f2b8b93          	addi	s7,s7,1010 # ac8 <digits>
 6de:	a839                	j	6fc <vprintf+0x6a>
        putc(fd, c);
 6e0:	85ca                	mv	a1,s2
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	ee2080e7          	jalr	-286(ra) # 5c6 <putc>
 6ec:	a019                	j	6f2 <vprintf+0x60>
    } else if(state == '%'){
 6ee:	01498f63          	beq	s3,s4,70c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6f2:	0485                	addi	s1,s1,1
 6f4:	fff4c903          	lbu	s2,-1(s1)
 6f8:	14090d63          	beqz	s2,852 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 700:	fe0997e3          	bnez	s3,6ee <vprintf+0x5c>
      if(c == '%'){
 704:	fd479ee3          	bne	a5,s4,6e0 <vprintf+0x4e>
        state = '%';
 708:	89be                	mv	s3,a5
 70a:	b7e5                	j	6f2 <vprintf+0x60>
      if(c == 'd'){
 70c:	05878063          	beq	a5,s8,74c <vprintf+0xba>
      } else if(c == 'l') {
 710:	05978c63          	beq	a5,s9,768 <vprintf+0xd6>
      } else if(c == 'x') {
 714:	07a78863          	beq	a5,s10,784 <vprintf+0xf2>
      } else if(c == 'p') {
 718:	09b78463          	beq	a5,s11,7a0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 71c:	07300713          	li	a4,115
 720:	0ce78663          	beq	a5,a4,7ec <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 724:	06300713          	li	a4,99
 728:	0ee78e63          	beq	a5,a4,824 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 72c:	11478863          	beq	a5,s4,83c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 730:	85d2                	mv	a1,s4
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e92080e7          	jalr	-366(ra) # 5c6 <putc>
        putc(fd, c);
 73c:	85ca                	mv	a1,s2
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e86080e7          	jalr	-378(ra) # 5c6 <putc>
      }
      state = 0;
 748:	4981                	li	s3,0
 74a:	b765                	j	6f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 74c:	008b0913          	addi	s2,s6,8
 750:	4685                	li	a3,1
 752:	4629                	li	a2,10
 754:	000b2583          	lw	a1,0(s6)
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	e8e080e7          	jalr	-370(ra) # 5e8 <printint>
 762:	8b4a                	mv	s6,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	b771                	j	6f2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	008b0913          	addi	s2,s6,8
 76c:	4681                	li	a3,0
 76e:	4629                	li	a2,10
 770:	000b2583          	lw	a1,0(s6)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e72080e7          	jalr	-398(ra) # 5e8 <printint>
 77e:	8b4a                	mv	s6,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	bf85                	j	6f2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 784:	008b0913          	addi	s2,s6,8
 788:	4681                	li	a3,0
 78a:	4641                	li	a2,16
 78c:	000b2583          	lw	a1,0(s6)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e56080e7          	jalr	-426(ra) # 5e8 <printint>
 79a:	8b4a                	mv	s6,s2
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bf91                	j	6f2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7a0:	008b0793          	addi	a5,s6,8
 7a4:	f8f43423          	sd	a5,-120(s0)
 7a8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7ac:	03000593          	li	a1,48
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e14080e7          	jalr	-492(ra) # 5c6 <putc>
  putc(fd, 'x');
 7ba:	85ea                	mv	a1,s10
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e08080e7          	jalr	-504(ra) # 5c6 <putc>
 7c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c8:	03c9d793          	srli	a5,s3,0x3c
 7cc:	97de                	add	a5,a5,s7
 7ce:	0007c583          	lbu	a1,0(a5)
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	df2080e7          	jalr	-526(ra) # 5c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7dc:	0992                	slli	s3,s3,0x4
 7de:	397d                	addiw	s2,s2,-1
 7e0:	fe0914e3          	bnez	s2,7c8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7e4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b721                	j	6f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ec:	008b0993          	addi	s3,s6,8
 7f0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7f4:	02090163          	beqz	s2,816 <vprintf+0x184>
        while(*s != 0){
 7f8:	00094583          	lbu	a1,0(s2)
 7fc:	c9a1                	beqz	a1,84c <vprintf+0x1ba>
          putc(fd, *s);
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	dc6080e7          	jalr	-570(ra) # 5c6 <putc>
          s++;
 808:	0905                	addi	s2,s2,1
        while(*s != 0){
 80a:	00094583          	lbu	a1,0(s2)
 80e:	f9e5                	bnez	a1,7fe <vprintf+0x16c>
        s = va_arg(ap, char*);
 810:	8b4e                	mv	s6,s3
      state = 0;
 812:	4981                	li	s3,0
 814:	bdf9                	j	6f2 <vprintf+0x60>
          s = "(null)";
 816:	00000917          	auipc	s2,0x0
 81a:	2aa90913          	addi	s2,s2,682 # ac0 <malloc+0x164>
        while(*s != 0){
 81e:	02800593          	li	a1,40
 822:	bff1                	j	7fe <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 824:	008b0913          	addi	s2,s6,8
 828:	000b4583          	lbu	a1,0(s6)
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	d98080e7          	jalr	-616(ra) # 5c6 <putc>
 836:	8b4a                	mv	s6,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bd65                	j	6f2 <vprintf+0x60>
        putc(fd, c);
 83c:	85d2                	mv	a1,s4
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	d86080e7          	jalr	-634(ra) # 5c6 <putc>
      state = 0;
 848:	4981                	li	s3,0
 84a:	b565                	j	6f2 <vprintf+0x60>
        s = va_arg(ap, char*);
 84c:	8b4e                	mv	s6,s3
      state = 0;
 84e:	4981                	li	s3,0
 850:	b54d                	j	6f2 <vprintf+0x60>
    }
  }
}
 852:	70e6                	ld	ra,120(sp)
 854:	7446                	ld	s0,112(sp)
 856:	74a6                	ld	s1,104(sp)
 858:	7906                	ld	s2,96(sp)
 85a:	69e6                	ld	s3,88(sp)
 85c:	6a46                	ld	s4,80(sp)
 85e:	6aa6                	ld	s5,72(sp)
 860:	6b06                	ld	s6,64(sp)
 862:	7be2                	ld	s7,56(sp)
 864:	7c42                	ld	s8,48(sp)
 866:	7ca2                	ld	s9,40(sp)
 868:	7d02                	ld	s10,32(sp)
 86a:	6de2                	ld	s11,24(sp)
 86c:	6109                	addi	sp,sp,128
 86e:	8082                	ret

0000000000000870 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 870:	715d                	addi	sp,sp,-80
 872:	ec06                	sd	ra,24(sp)
 874:	e822                	sd	s0,16(sp)
 876:	1000                	addi	s0,sp,32
 878:	e010                	sd	a2,0(s0)
 87a:	e414                	sd	a3,8(s0)
 87c:	e818                	sd	a4,16(s0)
 87e:	ec1c                	sd	a5,24(s0)
 880:	03043023          	sd	a6,32(s0)
 884:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 888:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88c:	8622                	mv	a2,s0
 88e:	00000097          	auipc	ra,0x0
 892:	e04080e7          	jalr	-508(ra) # 692 <vprintf>
}
 896:	60e2                	ld	ra,24(sp)
 898:	6442                	ld	s0,16(sp)
 89a:	6161                	addi	sp,sp,80
 89c:	8082                	ret

000000000000089e <printf>:

void
printf(const char *fmt, ...)
{
 89e:	711d                	addi	sp,sp,-96
 8a0:	ec06                	sd	ra,24(sp)
 8a2:	e822                	sd	s0,16(sp)
 8a4:	1000                	addi	s0,sp,32
 8a6:	e40c                	sd	a1,8(s0)
 8a8:	e810                	sd	a2,16(s0)
 8aa:	ec14                	sd	a3,24(s0)
 8ac:	f018                	sd	a4,32(s0)
 8ae:	f41c                	sd	a5,40(s0)
 8b0:	03043823          	sd	a6,48(s0)
 8b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b8:	00840613          	addi	a2,s0,8
 8bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c0:	85aa                	mv	a1,a0
 8c2:	4505                	li	a0,1
 8c4:	00000097          	auipc	ra,0x0
 8c8:	dce080e7          	jalr	-562(ra) # 692 <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e422                	sd	s0,8(sp)
 8d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	00000797          	auipc	a5,0x0
 8e2:	2027b783          	ld	a5,514(a5) # ae0 <freep>
 8e6:	a805                	j	916 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e8:	4618                	lw	a4,8(a2)
 8ea:	9db9                	addw	a1,a1,a4
 8ec:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	6398                	ld	a4,0(a5)
 8f2:	6318                	ld	a4,0(a4)
 8f4:	fee53823          	sd	a4,-16(a0)
 8f8:	a091                	j	93c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8fa:	ff852703          	lw	a4,-8(a0)
 8fe:	9e39                	addw	a2,a2,a4
 900:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 902:	ff053703          	ld	a4,-16(a0)
 906:	e398                	sd	a4,0(a5)
 908:	a099                	j	94e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90a:	6398                	ld	a4,0(a5)
 90c:	00e7e463          	bltu	a5,a4,914 <free+0x40>
 910:	00e6ea63          	bltu	a3,a4,924 <free+0x50>
{
 914:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	fed7fae3          	bgeu	a5,a3,90a <free+0x36>
 91a:	6398                	ld	a4,0(a5)
 91c:	00e6e463          	bltu	a3,a4,924 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	fee7eae3          	bltu	a5,a4,914 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 924:	ff852583          	lw	a1,-8(a0)
 928:	6390                	ld	a2,0(a5)
 92a:	02059713          	slli	a4,a1,0x20
 92e:	9301                	srli	a4,a4,0x20
 930:	0712                	slli	a4,a4,0x4
 932:	9736                	add	a4,a4,a3
 934:	fae60ae3          	beq	a2,a4,8e8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 938:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 93c:	4790                	lw	a2,8(a5)
 93e:	02061713          	slli	a4,a2,0x20
 942:	9301                	srli	a4,a4,0x20
 944:	0712                	slli	a4,a4,0x4
 946:	973e                	add	a4,a4,a5
 948:	fae689e3          	beq	a3,a4,8fa <free+0x26>
  } else
    p->s.ptr = bp;
 94c:	e394                	sd	a3,0(a5)
  freep = p;
 94e:	00000717          	auipc	a4,0x0
 952:	18f73923          	sd	a5,402(a4) # ae0 <freep>
}
 956:	6422                	ld	s0,8(sp)
 958:	0141                	addi	sp,sp,16
 95a:	8082                	ret

000000000000095c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 95c:	7139                	addi	sp,sp,-64
 95e:	fc06                	sd	ra,56(sp)
 960:	f822                	sd	s0,48(sp)
 962:	f426                	sd	s1,40(sp)
 964:	f04a                	sd	s2,32(sp)
 966:	ec4e                	sd	s3,24(sp)
 968:	e852                	sd	s4,16(sp)
 96a:	e456                	sd	s5,8(sp)
 96c:	e05a                	sd	s6,0(sp)
 96e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 970:	02051493          	slli	s1,a0,0x20
 974:	9081                	srli	s1,s1,0x20
 976:	04bd                	addi	s1,s1,15
 978:	8091                	srli	s1,s1,0x4
 97a:	0014899b          	addiw	s3,s1,1
 97e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 980:	00000517          	auipc	a0,0x0
 984:	16053503          	ld	a0,352(a0) # ae0 <freep>
 988:	c515                	beqz	a0,9b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	02977f63          	bgeu	a4,s1,9cc <malloc+0x70>
 992:	8a4e                	mv	s4,s3
 994:	0009871b          	sext.w	a4,s3
 998:	6685                	lui	a3,0x1
 99a:	00d77363          	bgeu	a4,a3,9a0 <malloc+0x44>
 99e:	6a05                	lui	s4,0x1
 9a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a8:	00000917          	auipc	s2,0x0
 9ac:	13890913          	addi	s2,s2,312 # ae0 <freep>
  if(p == (char*)-1)
 9b0:	5afd                	li	s5,-1
 9b2:	a88d                	j	a24 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9b4:	00000797          	auipc	a5,0x0
 9b8:	14478793          	addi	a5,a5,324 # af8 <base>
 9bc:	00000717          	auipc	a4,0x0
 9c0:	12f73223          	sd	a5,292(a4) # ae0 <freep>
 9c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ca:	b7e1                	j	992 <malloc+0x36>
      if(p->s.size == nunits)
 9cc:	02e48b63          	beq	s1,a4,a02 <malloc+0xa6>
        p->s.size -= nunits;
 9d0:	4137073b          	subw	a4,a4,s3
 9d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d6:	1702                	slli	a4,a4,0x20
 9d8:	9301                	srli	a4,a4,0x20
 9da:	0712                	slli	a4,a4,0x4
 9dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e2:	00000717          	auipc	a4,0x0
 9e6:	0ea73f23          	sd	a0,254(a4) # ae0 <freep>
      return (void*)(p + 1);
 9ea:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ee:	70e2                	ld	ra,56(sp)
 9f0:	7442                	ld	s0,48(sp)
 9f2:	74a2                	ld	s1,40(sp)
 9f4:	7902                	ld	s2,32(sp)
 9f6:	69e2                	ld	s3,24(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	6121                	addi	sp,sp,64
 a00:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a02:	6398                	ld	a4,0(a5)
 a04:	e118                	sd	a4,0(a0)
 a06:	bff1                	j	9e2 <malloc+0x86>
  hp->s.size = nu;
 a08:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a0c:	0541                	addi	a0,a0,16
 a0e:	00000097          	auipc	ra,0x0
 a12:	ec6080e7          	jalr	-314(ra) # 8d4 <free>
  return freep;
 a16:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a1a:	d971                	beqz	a0,9ee <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1e:	4798                	lw	a4,8(a5)
 a20:	fa9776e3          	bgeu	a4,s1,9cc <malloc+0x70>
    if(p == freep)
 a24:	00093703          	ld	a4,0(s2)
 a28:	853e                	mv	a0,a5
 a2a:	fef719e3          	bne	a4,a5,a1c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a2e:	8552                	mv	a0,s4
 a30:	00000097          	auipc	ra,0x0
 a34:	b7e080e7          	jalr	-1154(ra) # 5ae <sbrk>
  if(p == (char*)-1)
 a38:	fd5518e3          	bne	a0,s5,a08 <malloc+0xac>
        return 0;
 a3c:	4501                	li	a0,0
 a3e:	bf45                	j	9ee <malloc+0x92>
