/* Cross Hermit installer 0.1.234. Game-specific indexed extraction.
 * Copyright 2026. MIT license; see LICENSE.txt. blast.c retains its own license.
 * The index is produced from the original InstallShield directory metadata.
 * No game or installer code is executed. Never overwrites a destination file.
 */
#define UNICODE
#define _UNICODE
#include <windows.h>
#include <bcrypt.h>
#include <stdio.h>
#include <stdint.h>
#include <io.h>
#include <string.h>
#include <wchar.h>
#include "blast.h"
typedef struct { FILE *src,*out; uint32_t left,expected,written; unsigned char buf[65536]; BCRYPT_HASH_HANDLE hash; int bad; } State;
static unsigned input(void *p,unsigned char **buf){State*s=p;unsigned n=s->left>sizeof(s->buf)?sizeof(s->buf):s->left;unsigned got=(unsigned)fread(s->buf,1,n,s->src);s->left-=got;*buf=s->buf;return got;}
static int output(void*p,unsigned char*b,unsigned n){State*s=p;if(n>s->expected-s->written||fwrite(b,1,n,s->out)!=n||BCryptHashData(s->hash,b,n,0)<0){s->bad=1;return 1;}s->written+=n;return 0;}
static int readn(FILE*f,void*p,size_t n){return fread(p,1,n,f)==n;}
static int safe(const wchar_t*p){if(!*p||*p=='/'||*p=='\\')return 0;const wchar_t*t=p;for(;;p++){if(*p==':'||*p=='*'||*p=='?'||*p=='"'||*p=='<'||*p=='>'||*p=='|'||(*p&&*p<32))return 0;if(*p=='/'||*p=='\\'||!*p){size_t n=p-t;if(!n||(n==1&&t[0]=='.')||(n==2&&t[0]=='.'&&t[1]=='.')||p[-1]=='.'||p[-1]==' ')return 0;if(!*p)break;t=p+1;}}return 1;}
int wmain(int argc,wchar_t**argv){
 if(argc!=4){fwprintf(stderr,L"Usage: Extract-Game.exe archive index NEW-EMPTY-folder\n");return 2;}
 DWORD attr=GetFileAttributesW(argv[3]);if(attr!=INVALID_FILE_ATTRIBUTES){fwprintf(stderr,L"Destination must not exist.\n");return 3;}
 FILE*idx=_wfopen(argv[2],L"rb"),*src=_wfopen(argv[1],L"rb");if(!idx||!src)return 4;
 char magic[12];uint32_t count=0;if(!readn(idx,magic,12)||memcmp(magic,"CHINSTALL233",12)||!readn(idx,&count,4)||count!=7865)return 5;
 BCRYPT_ALG_HANDLE alg=NULL;if(BCryptOpenAlgorithmProvider(&alg,BCRYPT_SHA256_ALGORITHM,NULL,0)<0)return 6;
 if(!CreateDirectoryW(argv[3],NULL))return 7;
 int result=0;
 for(uint32_t i=0;i<count;i++){
  uint16_t chars;uint32_t off,compressed,original,flags;unsigned char expected[32],actual[32];wchar_t rel[1024],dest[32768];
  if(!readn(idx,&chars,2)||!chars||chars>=1024||!readn(idx,rel,chars*2)||!readn(idx,&off,4)||!readn(idx,&compressed,4)||!readn(idx,&original,4)||!readn(idx,&flags,4)||!readn(idx,expected,32)){result=8;break;}
  rel[chars]=0;if(!safe(rel)||wcslen(argv[3])+chars+2>=32768){result=9;break;}
  _snwprintf(dest,32768,L"%ls\\%ls",argv[3],rel);for(wchar_t*q=dest;*q;q++)if(*q=='/')*q='\\';
  for(wchar_t*q=dest+wcslen(argv[3])+1;*q;q++)if(*q=='\\'){*q=0;if(!CreateDirectoryW(dest,NULL)&&GetLastError()!=ERROR_ALREADY_EXISTS){result=10;break;}*q='\\';}if(result)break;
  HANDLE file=CreateFileW(dest,GENERIC_WRITE,0,NULL,CREATE_NEW,FILE_ATTRIBUTE_NORMAL,NULL);if(file==INVALID_HANDLE_VALUE){result=11;break;}
  int fd=_open_osfhandle((intptr_t)file,0);FILE*out=_fdopen(fd,"wb");if(!out){_close(fd);result=12;break;}
  State s={0};s.src=src;s.out=out;s.left=compressed;s.expected=original;
  if(BCryptCreateHash(alg,&s.hash,NULL,0,NULL,0,0)<0||_fseeki64(src,off,SEEK_SET)){fclose(out);result=13;break;}
  int rc=0;if(flags&0x10){while(s.left){unsigned char*b;unsigned n=input(&s,&b);if(!n||output(&s,b,n)){rc=1;break;}}}else{unsigned left=0;unsigned char*in=NULL;rc=blast(input,&s,output,&s,&left,&in);}
  if(fflush(out))rc=1;if(fclose(out))rc=1;
  if(BCryptFinishHash(s.hash,actual,32,0)<0)rc=1;BCryptDestroyHash(s.hash);
  if(rc||s.bad||s.written!=original||memcmp(expected,actual,32)){fwprintf(stderr,L"Extraction verification failed: %ls\n",rel);result=14;break;}
  if(i%100==0||i+1==count){printf("%u/%u\n",i+1,count);fflush(stdout);}
 }
 if(!result&&fgetc(idx)!=EOF)result=15;
 fclose(idx);fclose(src);BCryptCloseAlgorithmProvider(alg,0);if(result)fprintf(stderr,"Extraction stopped (%d). Existing installations were not changed.\n",result);return result;
}
