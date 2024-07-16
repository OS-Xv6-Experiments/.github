
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"

// find 函数
void
find(char *dir, char *file)
{   
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	24913c23          	sd	s1,600(sp)
  10:	25213823          	sd	s2,592(sp)
  14:	25313423          	sd	s3,584(sp)
  18:	25413023          	sd	s4,576(sp)
  1c:	23513c23          	sd	s5,568(sp)
  20:	23613823          	sd	s6,560(sp)
  24:	1c80                	addi	s0,sp,624
  26:	892a                	mv	s2,a0
  28:	89ae                	mv	s3,a1
    // 声明与文件相关的结构体
    struct dirent de;
    struct stat st;

    // open() 函数打开路径，返回一个文件描述符，如果错误返回 -1
    if ((fd = open(dir, 0)) < 0)
  2a:	4581                	li	a1,0
  2c:	00000097          	auipc	ra,0x0
  30:	4d0080e7          	jalr	1232(ra) # 4fc <open>
  34:	06054263          	bltz	a0,98 <find+0x98>
  38:	84aa                	mv	s1,a0
    // 系统调用 fstat 与 stat 类似，但它以文件描述符作为参数
    // int stat(char *, struct stat *);
    // stat 系统调用，可以获得一个已存在文件的模式，并将此模式赋值给它的副本
    // stat 以文件名作为参数，返回文件的 i 结点中的所有信息
    // 如果出错，则返回 -1
    if (fstat(fd, &st) < 0)
  3a:	d9840593          	addi	a1,s0,-616
  3e:	00000097          	auipc	ra,0x0
  42:	4d6080e7          	jalr	1238(ra) # 514 <fstat>
  46:	06054463          	bltz	a0,ae <find+0xae>
        close(fd);
        return;
    }

    // 如果不是目录类型
    if (st.type != T_DIR)
  4a:	da041703          	lh	a4,-608(s0)
  4e:	4785                	li	a5,1
  50:	06f70f63          	beq	a4,a5,ce <find+0xce>
    {
        // 报类型不是目录错误
        fprintf(2, "find: %s is not a directory\n", dir);
  54:	864a                	mv	a2,s2
  56:	00001597          	auipc	a1,0x1
  5a:	9b258593          	addi	a1,a1,-1614 # a08 <malloc+0x116>
  5e:	4509                	li	a0,2
  60:	00000097          	auipc	ra,0x0
  64:	7a6080e7          	jalr	1958(ra) # 806 <fprintf>
        // 关闭文件描述符 fd
        close(fd);
  68:	8526                	mv	a0,s1
  6a:	00000097          	auipc	ra,0x0
  6e:	47a080e7          	jalr	1146(ra) # 4e4 <close>
        {
            // 打印缓冲区存放的路径
            printf("%s\n", buf);
        } 
    }
}
  72:	26813083          	ld	ra,616(sp)
  76:	26013403          	ld	s0,608(sp)
  7a:	25813483          	ld	s1,600(sp)
  7e:	25013903          	ld	s2,592(sp)
  82:	24813983          	ld	s3,584(sp)
  86:	24013a03          	ld	s4,576(sp)
  8a:	23813a83          	ld	s5,568(sp)
  8e:	23013b03          	ld	s6,560(sp)
  92:	27010113          	addi	sp,sp,624
  96:	8082                	ret
        fprintf(2, "find: cannot open %s\n", dir);
  98:	864a                	mv	a2,s2
  9a:	00001597          	auipc	a1,0x1
  9e:	93e58593          	addi	a1,a1,-1730 # 9d8 <malloc+0xe6>
  a2:	4509                	li	a0,2
  a4:	00000097          	auipc	ra,0x0
  a8:	762080e7          	jalr	1890(ra) # 806 <fprintf>
        return;
  ac:	b7d9                	j	72 <find+0x72>
        fprintf(2, "find: cannot stat %s\n", dir);
  ae:	864a                	mv	a2,s2
  b0:	00001597          	auipc	a1,0x1
  b4:	94058593          	addi	a1,a1,-1728 # 9f0 <malloc+0xfe>
  b8:	4509                	li	a0,2
  ba:	00000097          	auipc	ra,0x0
  be:	74c080e7          	jalr	1868(ra) # 806 <fprintf>
        close(fd);
  c2:	8526                	mv	a0,s1
  c4:	00000097          	auipc	ra,0x0
  c8:	420080e7          	jalr	1056(ra) # 4e4 <close>
        return;
  cc:	b75d                	j	72 <find+0x72>
    if(strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf)
  ce:	854a                	mv	a0,s2
  d0:	00000097          	auipc	ra,0x0
  d4:	1c6080e7          	jalr	454(ra) # 296 <strlen>
  d8:	2541                	addiw	a0,a0,16
  da:	20000793          	li	a5,512
  de:	0ea7e463          	bltu	a5,a0,1c6 <find+0x1c6>
    strcpy(buf, dir);
  e2:	85ca                	mv	a1,s2
  e4:	dc040513          	addi	a0,s0,-576
  e8:	00000097          	auipc	ra,0x0
  ec:	166080e7          	jalr	358(ra) # 24e <strcpy>
    p = buf + strlen(buf);
  f0:	dc040513          	addi	a0,s0,-576
  f4:	00000097          	auipc	ra,0x0
  f8:	1a2080e7          	jalr	418(ra) # 296 <strlen>
  fc:	02051913          	slli	s2,a0,0x20
 100:	02095913          	srli	s2,s2,0x20
 104:	dc040793          	addi	a5,s0,-576
 108:	993e                	add	s2,s2,a5
    *p++ = '/';
 10a:	00190b13          	addi	s6,s2,1
 10e:	02f00793          	li	a5,47
 112:	00f90023          	sb	a5,0(s2)
        if (!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 116:	00001a17          	auipc	s4,0x1
 11a:	932a0a13          	addi	s4,s4,-1742 # a48 <malloc+0x156>
 11e:	00001a97          	auipc	s5,0x1
 122:	932a8a93          	addi	s5,s5,-1742 # a50 <malloc+0x15e>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 126:	4641                	li	a2,16
 128:	db040593          	addi	a1,s0,-592
 12c:	8526                	mv	a0,s1
 12e:	00000097          	auipc	ra,0x0
 132:	3a6080e7          	jalr	934(ra) # 4d4 <read>
 136:	47c1                	li	a5,16
 138:	f2f51de3          	bne	a0,a5,72 <find+0x72>
        if(de.inum == 0)
 13c:	db045783          	lhu	a5,-592(s0)
 140:	d3fd                	beqz	a5,126 <find+0x126>
        if (!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 142:	85d2                	mv	a1,s4
 144:	db240513          	addi	a0,s0,-590
 148:	00000097          	auipc	ra,0x0
 14c:	122080e7          	jalr	290(ra) # 26a <strcmp>
 150:	d979                	beqz	a0,126 <find+0x126>
 152:	85d6                	mv	a1,s5
 154:	db240513          	addi	a0,s0,-590
 158:	00000097          	auipc	ra,0x0
 15c:	112080e7          	jalr	274(ra) # 26a <strcmp>
 160:	d179                	beqz	a0,126 <find+0x126>
        memmove(p, de.name, DIRSIZ);
 162:	4639                	li	a2,14
 164:	db240593          	addi	a1,s0,-590
 168:	855a                	mv	a0,s6
 16a:	00000097          	auipc	ra,0x0
 16e:	2a0080e7          	jalr	672(ra) # 40a <memmove>
        p[DIRSIZ] = 0;
 172:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0)
 176:	d9840593          	addi	a1,s0,-616
 17a:	dc040513          	addi	a0,s0,-576
 17e:	00000097          	auipc	ra,0x0
 182:	1fc080e7          	jalr	508(ra) # 37a <stat>
 186:	04054f63          	bltz	a0,1e4 <find+0x1e4>
        if (st.type == T_DIR)
 18a:	da041783          	lh	a5,-608(s0)
 18e:	0007869b          	sext.w	a3,a5
 192:	4705                	li	a4,1
 194:	06e68463          	beq	a3,a4,1fc <find+0x1fc>
        else if (st.type == T_FILE && !strcmp(de.name, file))
 198:	2781                	sext.w	a5,a5
 19a:	4709                	li	a4,2
 19c:	f8e795e3          	bne	a5,a4,126 <find+0x126>
 1a0:	85ce                	mv	a1,s3
 1a2:	db240513          	addi	a0,s0,-590
 1a6:	00000097          	auipc	ra,0x0
 1aa:	0c4080e7          	jalr	196(ra) # 26a <strcmp>
 1ae:	fd25                	bnez	a0,126 <find+0x126>
            printf("%s\n", buf);
 1b0:	dc040593          	addi	a1,s0,-576
 1b4:	00001517          	auipc	a0,0x1
 1b8:	8a450513          	addi	a0,a0,-1884 # a58 <malloc+0x166>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	678080e7          	jalr	1656(ra) # 834 <printf>
 1c4:	b78d                	j	126 <find+0x126>
        fprintf(2, "find: directory too long\n");
 1c6:	00001597          	auipc	a1,0x1
 1ca:	86258593          	addi	a1,a1,-1950 # a28 <malloc+0x136>
 1ce:	4509                	li	a0,2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	636080e7          	jalr	1590(ra) # 806 <fprintf>
        close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	00000097          	auipc	ra,0x0
 1de:	30a080e7          	jalr	778(ra) # 4e4 <close>
        return;
 1e2:	bd41                	j	72 <find+0x72>
            fprintf(2, "find: cannot stat %s\n", buf);
 1e4:	dc040613          	addi	a2,s0,-576
 1e8:	00001597          	auipc	a1,0x1
 1ec:	80858593          	addi	a1,a1,-2040 # 9f0 <malloc+0xfe>
 1f0:	4509                	li	a0,2
 1f2:	00000097          	auipc	ra,0x0
 1f6:	614080e7          	jalr	1556(ra) # 806 <fprintf>
            continue;
 1fa:	b735                	j	126 <find+0x126>
            find(buf, file);
 1fc:	85ce                	mv	a1,s3
 1fe:	dc040513          	addi	a0,s0,-576
 202:	00000097          	auipc	ra,0x0
 206:	dfe080e7          	jalr	-514(ra) # 0 <find>
 20a:	bf31                	j	126 <find+0x126>

000000000000020c <main>:

int
main(int argc, char *argv[])
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
    // 如果参数个数不为 3 则报错
    if (argc != 3)
 214:	470d                	li	a4,3
 216:	02e50063          	beq	a0,a4,236 <main+0x2a>
    {
        // 输出提示
        fprintf(2, "usage: find dirName fileName\n");
 21a:	00001597          	auipc	a1,0x1
 21e:	84658593          	addi	a1,a1,-1978 # a60 <malloc+0x16e>
 222:	4509                	li	a0,2
 224:	00000097          	auipc	ra,0x0
 228:	5e2080e7          	jalr	1506(ra) # 806 <fprintf>
        // 异常退出
        exit(1);
 22c:	4505                	li	a0,1
 22e:	00000097          	auipc	ra,0x0
 232:	28e080e7          	jalr	654(ra) # 4bc <exit>
 236:	87ae                	mv	a5,a1
    }
    // 调用 find 函数查找指定目录下的文件
    find(argv[1], argv[2]);
 238:	698c                	ld	a1,16(a1)
 23a:	6788                	ld	a0,8(a5)
 23c:	00000097          	auipc	ra,0x0
 240:	dc4080e7          	jalr	-572(ra) # 0 <find>
    // 正常退出
    exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	276080e7          	jalr	630(ra) # 4bc <exit>

000000000000024e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 254:	87aa                	mv	a5,a0
 256:	0585                	addi	a1,a1,1
 258:	0785                	addi	a5,a5,1
 25a:	fff5c703          	lbu	a4,-1(a1)
 25e:	fee78fa3          	sb	a4,-1(a5)
 262:	fb75                	bnez	a4,256 <strcpy+0x8>
    ;
  return os;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret

000000000000026a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 270:	00054783          	lbu	a5,0(a0)
 274:	cb91                	beqz	a5,288 <strcmp+0x1e>
 276:	0005c703          	lbu	a4,0(a1)
 27a:	00f71763          	bne	a4,a5,288 <strcmp+0x1e>
    p++, q++;
 27e:	0505                	addi	a0,a0,1
 280:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 282:	00054783          	lbu	a5,0(a0)
 286:	fbe5                	bnez	a5,276 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 288:	0005c503          	lbu	a0,0(a1)
}
 28c:	40a7853b          	subw	a0,a5,a0
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strlen>:

uint
strlen(const char *s)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cf91                	beqz	a5,2bc <strlen+0x26>
 2a2:	0505                	addi	a0,a0,1
 2a4:	87aa                	mv	a5,a0
 2a6:	4685                	li	a3,1
 2a8:	9e89                	subw	a3,a3,a0
 2aa:	00f6853b          	addw	a0,a3,a5
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff7c703          	lbu	a4,-1(a5)
 2b4:	fb7d                	bnez	a4,2aa <strlen+0x14>
    ;
  return n;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  for(n = 0; s[n]; n++)
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <strlen+0x20>

00000000000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c6:	ca19                	beqz	a2,2dc <memset+0x1c>
 2c8:	87aa                	mv	a5,a0
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d6:	0785                	addi	a5,a5,1
 2d8:	fee79de3          	bne	a5,a4,2d2 <memset+0x12>
  }
  return dst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <strchr>:

char*
strchr(const char *s, char c)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	cb99                	beqz	a5,302 <strchr+0x20>
    if(*s == c)
 2ee:	00f58763          	beq	a1,a5,2fc <strchr+0x1a>
  for(; *s; s++)
 2f2:	0505                	addi	a0,a0,1
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	fbfd                	bnez	a5,2ee <strchr+0xc>
      return (char*)s;
  return 0;
 2fa:	4501                	li	a0,0
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <strchr+0x1a>

0000000000000306 <gets>:

char*
gets(char *buf, int max)
{
 306:	711d                	addi	sp,sp,-96
 308:	ec86                	sd	ra,88(sp)
 30a:	e8a2                	sd	s0,80(sp)
 30c:	e4a6                	sd	s1,72(sp)
 30e:	e0ca                	sd	s2,64(sp)
 310:	fc4e                	sd	s3,56(sp)
 312:	f852                	sd	s4,48(sp)
 314:	f456                	sd	s5,40(sp)
 316:	f05a                	sd	s6,32(sp)
 318:	ec5e                	sd	s7,24(sp)
 31a:	1080                	addi	s0,sp,96
 31c:	8baa                	mv	s7,a0
 31e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	892a                	mv	s2,a0
 322:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 324:	4aa9                	li	s5,10
 326:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 328:	89a6                	mv	s3,s1
 32a:	2485                	addiw	s1,s1,1
 32c:	0344d863          	bge	s1,s4,35c <gets+0x56>
    cc = read(0, &c, 1);
 330:	4605                	li	a2,1
 332:	faf40593          	addi	a1,s0,-81
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	19c080e7          	jalr	412(ra) # 4d4 <read>
    if(cc < 1)
 340:	00a05e63          	blez	a0,35c <gets+0x56>
    buf[i++] = c;
 344:	faf44783          	lbu	a5,-81(s0)
 348:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 34c:	01578763          	beq	a5,s5,35a <gets+0x54>
 350:	0905                	addi	s2,s2,1
 352:	fd679be3          	bne	a5,s6,328 <gets+0x22>
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	a011                	j	35c <gets+0x56>
 35a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 35c:	99de                	add	s3,s3,s7
 35e:	00098023          	sb	zero,0(s3)
  return buf;
}
 362:	855e                	mv	a0,s7
 364:	60e6                	ld	ra,88(sp)
 366:	6446                	ld	s0,80(sp)
 368:	64a6                	ld	s1,72(sp)
 36a:	6906                	ld	s2,64(sp)
 36c:	79e2                	ld	s3,56(sp)
 36e:	7a42                	ld	s4,48(sp)
 370:	7aa2                	ld	s5,40(sp)
 372:	7b02                	ld	s6,32(sp)
 374:	6be2                	ld	s7,24(sp)
 376:	6125                	addi	sp,sp,96
 378:	8082                	ret

000000000000037a <stat>:

int
stat(const char *n, struct stat *st)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	e426                	sd	s1,8(sp)
 382:	e04a                	sd	s2,0(sp)
 384:	1000                	addi	s0,sp,32
 386:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	4581                	li	a1,0
 38a:	00000097          	auipc	ra,0x0
 38e:	172080e7          	jalr	370(ra) # 4fc <open>
  if(fd < 0)
 392:	02054563          	bltz	a0,3bc <stat+0x42>
 396:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 398:	85ca                	mv	a1,s2
 39a:	00000097          	auipc	ra,0x0
 39e:	17a080e7          	jalr	378(ra) # 514 <fstat>
 3a2:	892a                	mv	s2,a0
  close(fd);
 3a4:	8526                	mv	a0,s1
 3a6:	00000097          	auipc	ra,0x0
 3aa:	13e080e7          	jalr	318(ra) # 4e4 <close>
  return r;
}
 3ae:	854a                	mv	a0,s2
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	64a2                	ld	s1,8(sp)
 3b6:	6902                	ld	s2,0(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret
    return -1;
 3bc:	597d                	li	s2,-1
 3be:	bfc5                	j	3ae <stat+0x34>

00000000000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c6:	00054603          	lbu	a2,0(a0)
 3ca:	fd06079b          	addiw	a5,a2,-48
 3ce:	0ff7f793          	andi	a5,a5,255
 3d2:	4725                	li	a4,9
 3d4:	02f76963          	bltu	a4,a5,406 <atoi+0x46>
 3d8:	86aa                	mv	a3,a0
  n = 0;
 3da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3de:	0685                	addi	a3,a3,1
 3e0:	0025179b          	slliw	a5,a0,0x2
 3e4:	9fa9                	addw	a5,a5,a0
 3e6:	0017979b          	slliw	a5,a5,0x1
 3ea:	9fb1                	addw	a5,a5,a2
 3ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f0:	0006c603          	lbu	a2,0(a3)
 3f4:	fd06071b          	addiw	a4,a2,-48
 3f8:	0ff77713          	andi	a4,a4,255
 3fc:	fee5f1e3          	bgeu	a1,a4,3de <atoi+0x1e>
  return n;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
  n = 0;
 406:	4501                	li	a0,0
 408:	bfe5                	j	400 <atoi+0x40>

000000000000040a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40a:	1141                	addi	sp,sp,-16
 40c:	e422                	sd	s0,8(sp)
 40e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 410:	02b57463          	bgeu	a0,a1,438 <memmove+0x2e>
    while(n-- > 0)
 414:	00c05f63          	blez	a2,432 <memmove+0x28>
 418:	1602                	slli	a2,a2,0x20
 41a:	9201                	srli	a2,a2,0x20
 41c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 420:	872a                	mv	a4,a0
      *dst++ = *src++;
 422:	0585                	addi	a1,a1,1
 424:	0705                	addi	a4,a4,1
 426:	fff5c683          	lbu	a3,-1(a1)
 42a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 42e:	fee79ae3          	bne	a5,a4,422 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
    dst += n;
 438:	00c50733          	add	a4,a0,a2
    src += n;
 43c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 43e:	fec05ae3          	blez	a2,432 <memmove+0x28>
 442:	fff6079b          	addiw	a5,a2,-1
 446:	1782                	slli	a5,a5,0x20
 448:	9381                	srli	a5,a5,0x20
 44a:	fff7c793          	not	a5,a5
 44e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 450:	15fd                	addi	a1,a1,-1
 452:	177d                	addi	a4,a4,-1
 454:	0005c683          	lbu	a3,0(a1)
 458:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45c:	fee79ae3          	bne	a5,a4,450 <memmove+0x46>
 460:	bfc9                	j	432 <memmove+0x28>

0000000000000462 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 468:	ca05                	beqz	a2,498 <memcmp+0x36>
 46a:	fff6069b          	addiw	a3,a2,-1
 46e:	1682                	slli	a3,a3,0x20
 470:	9281                	srli	a3,a3,0x20
 472:	0685                	addi	a3,a3,1
 474:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 476:	00054783          	lbu	a5,0(a0)
 47a:	0005c703          	lbu	a4,0(a1)
 47e:	00e79863          	bne	a5,a4,48e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 482:	0505                	addi	a0,a0,1
    p2++;
 484:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 486:	fed518e3          	bne	a0,a3,476 <memcmp+0x14>
  }
  return 0;
 48a:	4501                	li	a0,0
 48c:	a019                	j	492 <memcmp+0x30>
      return *p1 - *p2;
 48e:	40e7853b          	subw	a0,a5,a4
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret
  return 0;
 498:	4501                	li	a0,0
 49a:	bfe5                	j	492 <memcmp+0x30>

000000000000049c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a4:	00000097          	auipc	ra,0x0
 4a8:	f66080e7          	jalr	-154(ra) # 40a <memmove>
}
 4ac:	60a2                	ld	ra,8(sp)
 4ae:	6402                	ld	s0,0(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret

00000000000004b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b4:	4885                	li	a7,1
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4bc:	4889                	li	a7,2
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c4:	488d                	li	a7,3
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4cc:	4891                	li	a7,4
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <read>:
.global read
read:
 li a7, SYS_read
 4d4:	4895                	li	a7,5
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <write>:
.global write
write:
 li a7, SYS_write
 4dc:	48c1                	li	a7,16
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <close>:
.global close
close:
 li a7, SYS_close
 4e4:	48d5                	li	a7,21
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ec:	4899                	li	a7,6
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f4:	489d                	li	a7,7
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <open>:
.global open
open:
 li a7, SYS_open
 4fc:	48bd                	li	a7,15
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 504:	48c5                	li	a7,17
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50c:	48c9                	li	a7,18
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 514:	48a1                	li	a7,8
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <link>:
.global link
link:
 li a7, SYS_link
 51c:	48cd                	li	a7,19
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 524:	48d1                	li	a7,20
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52c:	48a5                	li	a7,9
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <dup>:
.global dup
dup:
 li a7, SYS_dup
 534:	48a9                	li	a7,10
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53c:	48ad                	li	a7,11
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 544:	48b1                	li	a7,12
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54c:	48b5                	li	a7,13
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 554:	48b9                	li	a7,14
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f6e080e7          	jalr	-146(ra) # 4dc <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	f04a                	sd	s2,32(sp)
 588:	ec4e                	sd	s3,24(sp)
 58a:	0080                	addi	s0,sp,64
 58c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58e:	c299                	beqz	a3,594 <printint+0x16>
 590:	0805c863          	bltz	a1,620 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 594:	2581                	sext.w	a1,a1
  neg = 0;
 596:	4881                	li	a7,0
 598:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59e:	2601                	sext.w	a2,a2
 5a0:	00000517          	auipc	a0,0x0
 5a4:	4e850513          	addi	a0,a0,1256 # a88 <digits>
 5a8:	883a                	mv	a6,a4
 5aa:	2705                	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	97aa                	add	a5,a5,a0
 5b6:	0007c783          	lbu	a5,0(a5)
 5ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5be:	0005879b          	sext.w	a5,a1
 5c2:	02c5d5bb          	divuw	a1,a1,a2
 5c6:	0685                	addi	a3,a3,1
 5c8:	fec7f0e3          	bgeu	a5,a2,5a8 <printint+0x2a>
  if(neg)
 5cc:	00088b63          	beqz	a7,5e2 <printint+0x64>
    buf[i++] = '-';
 5d0:	fd040793          	addi	a5,s0,-48
 5d4:	973e                	add	a4,a4,a5
 5d6:	02d00793          	li	a5,45
 5da:	fef70823          	sb	a5,-16(a4)
 5de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e2:	02e05863          	blez	a4,612 <printint+0x94>
 5e6:	fc040793          	addi	a5,s0,-64
 5ea:	00e78933          	add	s2,a5,a4
 5ee:	fff78993          	addi	s3,a5,-1
 5f2:	99ba                	add	s3,s3,a4
 5f4:	377d                	addiw	a4,a4,-1
 5f6:	1702                	slli	a4,a4,0x20
 5f8:	9301                	srli	a4,a4,0x20
 5fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fe:	fff94583          	lbu	a1,-1(s2)
 602:	8526                	mv	a0,s1
 604:	00000097          	auipc	ra,0x0
 608:	f58080e7          	jalr	-168(ra) # 55c <putc>
  while(--i >= 0)
 60c:	197d                	addi	s2,s2,-1
 60e:	ff3918e3          	bne	s2,s3,5fe <printint+0x80>
}
 612:	70e2                	ld	ra,56(sp)
 614:	7442                	ld	s0,48(sp)
 616:	74a2                	ld	s1,40(sp)
 618:	7902                	ld	s2,32(sp)
 61a:	69e2                	ld	s3,24(sp)
 61c:	6121                	addi	sp,sp,64
 61e:	8082                	ret
    x = -xx;
 620:	40b005bb          	negw	a1,a1
    neg = 1;
 624:	4885                	li	a7,1
    x = -xx;
 626:	bf8d                	j	598 <printint+0x1a>

0000000000000628 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 628:	7119                	addi	sp,sp,-128
 62a:	fc86                	sd	ra,120(sp)
 62c:	f8a2                	sd	s0,112(sp)
 62e:	f4a6                	sd	s1,104(sp)
 630:	f0ca                	sd	s2,96(sp)
 632:	ecce                	sd	s3,88(sp)
 634:	e8d2                	sd	s4,80(sp)
 636:	e4d6                	sd	s5,72(sp)
 638:	e0da                	sd	s6,64(sp)
 63a:	fc5e                	sd	s7,56(sp)
 63c:	f862                	sd	s8,48(sp)
 63e:	f466                	sd	s9,40(sp)
 640:	f06a                	sd	s10,32(sp)
 642:	ec6e                	sd	s11,24(sp)
 644:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 646:	0005c903          	lbu	s2,0(a1)
 64a:	18090f63          	beqz	s2,7e8 <vprintf+0x1c0>
 64e:	8aaa                	mv	s5,a0
 650:	8b32                	mv	s6,a2
 652:	00158493          	addi	s1,a1,1
  state = 0;
 656:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 658:	02500a13          	li	s4,37
      if(c == 'd'){
 65c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 660:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 664:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 668:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	41cb8b93          	addi	s7,s7,1052 # a88 <digits>
 674:	a839                	j	692 <vprintf+0x6a>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	ee2080e7          	jalr	-286(ra) # 55c <putc>
 682:	a019                	j	688 <vprintf+0x60>
    } else if(state == '%'){
 684:	01498f63          	beq	s3,s4,6a2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 688:	0485                	addi	s1,s1,1
 68a:	fff4c903          	lbu	s2,-1(s1)
 68e:	14090d63          	beqz	s2,7e8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 692:	0009079b          	sext.w	a5,s2
    if(state == 0){
 696:	fe0997e3          	bnez	s3,684 <vprintf+0x5c>
      if(c == '%'){
 69a:	fd479ee3          	bne	a5,s4,676 <vprintf+0x4e>
        state = '%';
 69e:	89be                	mv	s3,a5
 6a0:	b7e5                	j	688 <vprintf+0x60>
      if(c == 'd'){
 6a2:	05878063          	beq	a5,s8,6e2 <vprintf+0xba>
      } else if(c == 'l') {
 6a6:	05978c63          	beq	a5,s9,6fe <vprintf+0xd6>
      } else if(c == 'x') {
 6aa:	07a78863          	beq	a5,s10,71a <vprintf+0xf2>
      } else if(c == 'p') {
 6ae:	09b78463          	beq	a5,s11,736 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b2:	07300713          	li	a4,115
 6b6:	0ce78663          	beq	a5,a4,782 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ba:	06300713          	li	a4,99
 6be:	0ee78e63          	beq	a5,a4,7ba <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c2:	11478863          	beq	a5,s4,7d2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c6:	85d2                	mv	a1,s4
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e92080e7          	jalr	-366(ra) # 55c <putc>
        putc(fd, c);
 6d2:	85ca                	mv	a1,s2
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e86080e7          	jalr	-378(ra) # 55c <putc>
      }
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b765                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e2:	008b0913          	addi	s2,s6,8
 6e6:	4685                	li	a3,1
 6e8:	4629                	li	a2,10
 6ea:	000b2583          	lw	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e8e080e7          	jalr	-370(ra) # 57e <printint>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b771                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b0913          	addi	s2,s6,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000b2583          	lw	a1,0(s6)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e72080e7          	jalr	-398(ra) # 57e <printint>
 714:	8b4a                	mv	s6,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bf85                	j	688 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71a:	008b0913          	addi	s2,s6,8
 71e:	4681                	li	a3,0
 720:	4641                	li	a2,16
 722:	000b2583          	lw	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e56080e7          	jalr	-426(ra) # 57e <printint>
 730:	8b4a                	mv	s6,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bf91                	j	688 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 736:	008b0793          	addi	a5,s6,8
 73a:	f8f43423          	sd	a5,-120(s0)
 73e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 742:	03000593          	li	a1,48
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e14080e7          	jalr	-492(ra) # 55c <putc>
  putc(fd, 'x');
 750:	85ea                	mv	a1,s10
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e08080e7          	jalr	-504(ra) # 55c <putc>
 75c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	03c9d793          	srli	a5,s3,0x3c
 762:	97de                	add	a5,a5,s7
 764:	0007c583          	lbu	a1,0(a5)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	df2080e7          	jalr	-526(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 772:	0992                	slli	s3,s3,0x4
 774:	397d                	addiw	s2,s2,-1
 776:	fe0914e3          	bnez	s2,75e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77e:	4981                	li	s3,0
 780:	b721                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 782:	008b0993          	addi	s3,s6,8
 786:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 78a:	02090163          	beqz	s2,7ac <vprintf+0x184>
        while(*s != 0){
 78e:	00094583          	lbu	a1,0(s2)
 792:	c9a1                	beqz	a1,7e2 <vprintf+0x1ba>
          putc(fd, *s);
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	dc6080e7          	jalr	-570(ra) # 55c <putc>
          s++;
 79e:	0905                	addi	s2,s2,1
        while(*s != 0){
 7a0:	00094583          	lbu	a1,0(s2)
 7a4:	f9e5                	bnez	a1,794 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a6:	8b4e                	mv	s6,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bdf9                	j	688 <vprintf+0x60>
          s = "(null)";
 7ac:	00000917          	auipc	s2,0x0
 7b0:	2d490913          	addi	s2,s2,724 # a80 <malloc+0x18e>
        while(*s != 0){
 7b4:	02800593          	li	a1,40
 7b8:	bff1                	j	794 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7ba:	008b0913          	addi	s2,s6,8
 7be:	000b4583          	lbu	a1,0(s6)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	d98080e7          	jalr	-616(ra) # 55c <putc>
 7cc:	8b4a                	mv	s6,s2
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bd65                	j	688 <vprintf+0x60>
        putc(fd, c);
 7d2:	85d2                	mv	a1,s4
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d86080e7          	jalr	-634(ra) # 55c <putc>
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b565                	j	688 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	8b4e                	mv	s6,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b54d                	j	688 <vprintf+0x60>
    }
  }
}
 7e8:	70e6                	ld	ra,120(sp)
 7ea:	7446                	ld	s0,112(sp)
 7ec:	74a6                	ld	s1,104(sp)
 7ee:	7906                	ld	s2,96(sp)
 7f0:	69e6                	ld	s3,88(sp)
 7f2:	6a46                	ld	s4,80(sp)
 7f4:	6aa6                	ld	s5,72(sp)
 7f6:	6b06                	ld	s6,64(sp)
 7f8:	7be2                	ld	s7,56(sp)
 7fa:	7c42                	ld	s8,48(sp)
 7fc:	7ca2                	ld	s9,40(sp)
 7fe:	7d02                	ld	s10,32(sp)
 800:	6de2                	ld	s11,24(sp)
 802:	6109                	addi	sp,sp,128
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	8622                	mv	a2,s0
 824:	00000097          	auipc	ra,0x0
 828:	e04080e7          	jalr	-508(ra) # 628 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:

void
printf(const char *fmt, ...)
{
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	00000097          	auipc	ra,0x0
 85e:	dce080e7          	jalr	-562(ra) # 628 <vprintf>
}
 862:	60e2                	ld	ra,24(sp)
 864:	6442                	ld	s0,16(sp)
 866:	6125                	addi	sp,sp,96
 868:	8082                	ret

000000000000086a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86a:	1141                	addi	sp,sp,-16
 86c:	e422                	sd	s0,8(sp)
 86e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	00000797          	auipc	a5,0x0
 878:	22c7b783          	ld	a5,556(a5) # aa0 <freep>
 87c:	a805                	j	8ac <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87e:	4618                	lw	a4,8(a2)
 880:	9db9                	addw	a1,a1,a4
 882:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	6318                	ld	a4,0(a4)
 88a:	fee53823          	sd	a4,-16(a0)
 88e:	a091                	j	8d2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 890:	ff852703          	lw	a4,-8(a0)
 894:	9e39                	addw	a2,a2,a4
 896:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 898:	ff053703          	ld	a4,-16(a0)
 89c:	e398                	sd	a4,0(a5)
 89e:	a099                	j	8e4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x40>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x50>
{
 8aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x36>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059713          	slli	a4,a1,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60ae3          	beq	a2,a4,87e <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061713          	slli	a4,a2,0x20
 8d8:	9301                	srli	a4,a4,0x20
 8da:	0712                	slli	a4,a4,0x4
 8dc:	973e                	add	a4,a4,a5
 8de:	fae689e3          	beq	a3,a4,890 <free+0x26>
  } else
    p->s.ptr = bp;
 8e2:	e394                	sd	a3,0(a5)
  freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	1af73e23          	sd	a5,444(a4) # aa0 <freep>
}
 8ec:	6422                	ld	s0,8(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f426                	sd	s1,40(sp)
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000517          	auipc	a0,0x0
 91a:	18a53503          	ld	a0,394(a0) # aa0 <freep>
 91e:	c515                	beqz	a0,94a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	02977f63          	bgeu	a4,s1,962 <malloc+0x70>
 928:	8a4e                	mv	s4,s3
 92a:	0009871b          	sext.w	a4,s3
 92e:	6685                	lui	a3,0x1
 930:	00d77363          	bgeu	a4,a3,936 <malloc+0x44>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93e:	00000917          	auipc	s2,0x0
 942:	16290913          	addi	s2,s2,354 # aa0 <freep>
  if(p == (char*)-1)
 946:	5afd                	li	s5,-1
 948:	a88d                	j	9ba <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 94a:	00000797          	auipc	a5,0x0
 94e:	15e78793          	addi	a5,a5,350 # aa8 <base>
 952:	00000717          	auipc	a4,0x0
 956:	14f73723          	sd	a5,334(a4) # aa0 <freep>
 95a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 960:	b7e1                	j	928 <malloc+0x36>
      if(p->s.size == nunits)
 962:	02e48b63          	beq	s1,a4,998 <malloc+0xa6>
        p->s.size -= nunits;
 966:	4137073b          	subw	a4,a4,s3
 96a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96c:	1702                	slli	a4,a4,0x20
 96e:	9301                	srli	a4,a4,0x20
 970:	0712                	slli	a4,a4,0x4
 972:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 974:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	12a73423          	sd	a0,296(a4) # aa0 <freep>
      return (void*)(p + 1);
 980:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 984:	70e2                	ld	ra,56(sp)
 986:	7442                	ld	s0,48(sp)
 988:	74a2                	ld	s1,40(sp)
 98a:	7902                	ld	s2,32(sp)
 98c:	69e2                	ld	s3,24(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	6121                	addi	sp,sp,64
 996:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 998:	6398                	ld	a4,0(a5)
 99a:	e118                	sd	a4,0(a0)
 99c:	bff1                	j	978 <malloc+0x86>
  hp->s.size = nu;
 99e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a2:	0541                	addi	a0,a0,16
 9a4:	00000097          	auipc	ra,0x0
 9a8:	ec6080e7          	jalr	-314(ra) # 86a <free>
  return freep;
 9ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b0:	d971                	beqz	a0,984 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b4:	4798                	lw	a4,8(a5)
 9b6:	fa9776e3          	bgeu	a4,s1,962 <malloc+0x70>
    if(p == freep)
 9ba:	00093703          	ld	a4,0(s2)
 9be:	853e                	mv	a0,a5
 9c0:	fef719e3          	bne	a4,a5,9b2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c4:	8552                	mv	a0,s4
 9c6:	00000097          	auipc	ra,0x0
 9ca:	b7e080e7          	jalr	-1154(ra) # 544 <sbrk>
  if(p == (char*)-1)
 9ce:	fd5518e3          	bne	a0,s5,99e <malloc+0xac>
        return 0;
 9d2:	4501                	li	a0,0
 9d4:	bf45                	j	984 <malloc+0x92>
