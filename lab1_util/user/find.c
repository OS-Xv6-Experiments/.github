// Lab Xv6 and Unix utilities
// find.c

#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fs.h"

// find ����
void
find(char* dir, char* file)
{
  // ���� �ļ��������� �� ָ��
  char buf[512], * p;
  // �����ļ������� fd
  int fd;
  // �������ļ���صĽṹ��
  struct dirent de;
  struct stat st;

  // open() ������·��������һ���ļ���������������󷵻� -1
  if ((fd = open(dir, 0)) < 0)
  {
    // ������ʾ�޷��򿪴�·��
    fprintf(2, "find: cannot open %s\n", dir);
    return;
  }

  // int fstat(int fd, struct stat *);
  // ϵͳ���� fstat �� stat ���ƣ��������ļ���������Ϊ����
  // int stat(char *, struct stat *);
  // stat ϵͳ���ã����Ի��һ���Ѵ����ļ���ģʽ��������ģʽ��ֵ�����ĸ���
  // stat ���ļ�����Ϊ�����������ļ��� i ����е�������Ϣ
  // ��������򷵻� -1
  if (fstat(fd, &st) < 0)
  {
    // �����򱨴�
    fprintf(2, "find: cannot stat %s\n", dir);
    // �ر��ļ������� fd
    close(fd);
    return;
  }

  // �������Ŀ¼����
  if (st.type != T_DIR)
  {
    // �����Ͳ���Ŀ¼����
    fprintf(2, "find: %s is not a directory\n", dir);
    // �ر��ļ������� fd
    close(fd);
    return;
  }

  // ���·�������Ų��뻺�������򱨴���ʾ
  if (strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf)
  {
    fprintf(2, "find: directory too long\n");
    // �ر��ļ������� fd
    close(fd);
    return;
  }
  // �� dir ָ����ַ���������·�����Ƶ� buf
  strcpy(buf, dir);
  // buf ��һ������·����p ��һ���ļ�����ͨ���� "/" ǰ׺ƴ���� buf �ĺ���
  p = buf + strlen(buf);
  *p++ = '/';
  // ��ȡ fd ����� read �����ֽ����� de ���������ѭ��
  while (read(fd, &de, sizeof(de)) == sizeof(de))
  {
    if (de.inum == 0)
      continue;
    // strcmp(s, t);
    // ���� s ָ����ַ���С�ڣ�s<t�������ڣ�s==t������ڣ�s>t�� t ָ����ַ����Ĳ�ͬ���
    // �ֱ𷵻ظ�������0��������
    // ��Ҫ�ݹ� "." �� "..."
    if (!strcmp(de.name, ".") || !strcmp(de.name, ".."))
      continue;
    // memmove���� de.name ��Ϣ���� p������ de.name �����ļ���
    memmove(p, de.name, DIRSIZ);
    // �����ļ���������
    p[DIRSIZ] = 0;
    // int stat(char *, struct stat *);
    // stat ϵͳ���ã����Ի��һ���Ѵ����ļ���ģʽ��������ģʽ��ֵ�����ĸ���
    // stat ���ļ�����Ϊ�����������ļ��� i ����е�������Ϣ
    // ��������򷵻� -1
    if (stat(buf, &st) < 0)
    {
      // �����򱨴�
      fprintf(2, "find: cannot stat %s\n", buf);
      continue;
    }
    // �����Ŀ¼���ͣ��ݹ����
    if (st.type == T_DIR)
    {
      find(buf, file);
    }
    // ������ļ����� ���� ������Ҫ���ҵ��ļ�����ͬ
    else if (st.type == T_FILE && !strcmp(de.name, file))
    {
      // ��ӡ��������ŵ�·��
      printf("%s\n", buf);
    }
  }
}

int
main(int argc, char* argv[])
{
  // �������������Ϊ 3 �򱨴�
  if (argc != 3)
  {
    // �����ʾ
    fprintf(2, "usage: find dirName fileName\n");
    // �쳣�˳�
    exit(1);
  }
  // ���� find ��������ָ��Ŀ¼�µ��ļ�
  find(argv[1], argv[2]);
  // �����˳�
  exit(0);
}
