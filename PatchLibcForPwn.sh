#!/bin/bash

# 接收输入的文件和libc版本
FILE_NAME=$1
LIBC_VERSION=$2
WORKDIR=$(pwd)

# 定义libc存放的目录
LIBC_BASE_DIR=~/tools/glibc-all-in-one/libs

# 检查是否提供了目标文件和libc版本
if [ "$1" = "--list" ]; then
    echo "Available libc versions:"
    ls "$LIBC_BASE_DIR" | sed -E 's/(_amd64|_i386)//g' | sort -u
    exit 0
fi

if [ -z "$FILE_NAME" ] || [ -z "$LIBC_VERSION" ]; then
    echo "Usage: $0 <file_name> <libc_version>"
    echo "use: $0 --list to list available libc versions."
    exit 1
fi

# 判断文件是否存在
if [ ! -f "$FILE_NAME" ]; then
    echo "File '$FILE_NAME' does not exist."
    exit 1
fi

# 检查文件的位数（32位或64位）
EBIT=$(file "$FILE_NAME" | awk '{print $3}' | cut -c 1-2)

# 根据位数选择对应的libc存放目录
if [ "$EBIT" = "32" ]; then
    LIBC_DIR="$LIBC_BASE_DIR/${LIBC_VERSION}_i386"
elif [ "$EBIT" = "64" ];then
    LIBC_DIR="$LIBC_BASE_DIR/${LIBC_VERSION}_amd64"
else
    echo "The file is not an ELF file or is not supported."
    exit 1
fi

# 检查是否找到对应的libc目录
if [ ! -d "$LIBC_DIR" ]; then
    echo "Libc version '$LIBC_VERSION' not found in '$LIBC_DIR'."
    exit 1
fi

# 判断libc版本是否大于2.33
if [[ "$LIBC_VERSION" > "2.33" ]]; then
    if [ "$EBIT" = "32" ]; then
        LD_PATH="$LIBC_DIR/ld-linux.so.2"
    else
        LD_PATH="$LIBC_DIR/ld-linux-x86-64.so.2"
    fi
else
    LD_PATH="$LIBC_DIR/ld-$LIBC_VERSION.so"
fi

# 检查ld文件是否存在
if [ ! -f "$LD_PATH" ]; then
    echo "LD file for version '$LIBC_VERSION' not found."
    exit 1
fi

# 检查是否提供第三个参数来决定使用哪个rpath
if [ "$3" ]; then
    # 使用当前目录作为rpath
    patchelf --set-interpreter "$LD_PATH" --set-rpath "$WORKDIR" "$FILE_NAME"
else
    # 使用libc所在目录作为rpath
    patchelf --set-interpreter "$LD_PATH" --set-rpath "$LIBC_DIR" "$FILE_NAME"
fi

echo "Libc version switched to $LIBC_VERSION successfully!"
