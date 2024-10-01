# PatchLibcForPwn
一键替换Libc版本,让pwn题libc切换更加简单,需要组合glibc-all-in-one组合使用


```d
┌──(kali㉿kali)-[~/tools]
└─$ ln -s /home/kali/tools/glibc-all-in-one/PatchLibcForPwn.sh /usr/local/bin/PatchLibcForPwn

```


使用例子:
```d
┌──(kali㉿kali)-[~/tools/glibc-all-in-one]
└─$ PatchLibcForPwn                      
Usage: /usr/local/bin/PatchLibcForPwn <file_name> <libc_version>
use: /usr/local/bin/PatchLibcForPwn --list to list available libc versions.
                                                                                                                                                                                                                                           
┌──(kali㉿kali)-[~/tools/glibc-all-in-one]
└─$ PatchLibcForPwn ./ciscn_2019_c_3 2.23
Libc version switched to 2.23 successfully!
                                                                                                                                                                                                                                           
┌──(kali㉿kali)-[~/tools/glibc-all-in-one]
└─$ PatchLibcForPwn --list               
Available libc versions:
2.23
2.27
2.29
2.30
2.31
2.35
```