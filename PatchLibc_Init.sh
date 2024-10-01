#!/bin/bash

cd ~/tools/glibc-all-in-one


TARGET_DIR="/home/kali/tools/glibc-all-in-one/libs"
DOWNLOAD_SCRIPT="./download"
DOWNLOAD_OLD_SCRIPT="./download_old"

# 定义需要检查的文件夹列表和对应的下载命令
declare -A libc_versions=(
    ["2.23_amd64"]="$DOWNLOAD_SCRIPT 2.23-0ubuntu11.3_amd64"
    ["2.23_i386"]="$DOWNLOAD_SCRIPT 2.23-0ubuntu11.3_i386"
    ["2.27_amd64"]="$DOWNLOAD_SCRIPT 2.27-3ubuntu1_amd64"
    ["2.27_i386"]="$DOWNLOAD_SCRIPT 2.27-3ubuntu1_i386"
    ["2.29_amd64"]="$DOWNLOAD_OLD_SCRIPT 2.29-0ubuntu2_amd64"
    ["2.29_i386"]="$DOWNLOAD_OLD_SCRIPT 2.29-0ubuntu2_i386"
    ["2.30_amd64"]="$DOWNLOAD_OLD_SCRIPT 2.30-0ubuntu2_amd64"
    ["2.30_i386"]="$DOWNLOAD_OLD_SCRIPT 2.30-0ubuntu2_i386"
    ["2.31_amd64"]="$DOWNLOAD_SCRIPT 2.31-0ubuntu9_amd64"
    ["2.31_i386"]="$DOWNLOAD_SCRIPT 2.31-0ubuntu9_i386"
    ["2.35_amd64"]="$DOWNLOAD_SCRIPT 2.35-0ubuntu3.8_amd64"
    ["2.35_i386"]="$DOWNLOAD_SCRIPT 2.35-0ubuntu3.8_i386"
)

# 检查libs目录下是否存在指定的文件夹，若不存在则下载
for version in "${!libc_versions[@]}"; do
    # 检查目录是否存在
    if [ ! -d "$TARGET_DIR/$version" ]; then
    	echo "$TARGET_DIR/$version"
        echo "Directory '$version' does not exist. Downloading..."
        # 执行相应的下载命令
        ${libc_versions[$version]}
    else
        echo "Directory '$version' already exists."
    fi
done

echo "Download and check complete. Proceeding with renaming..."

# 遍历指定目录中的所有文件夹进行重命名
for folder in "$TARGET_DIR"/*; do
  # 检查是否为目录
  if [ -d "$folder" ]; then
    # 获取文件夹的基本名称
    folder_name=$(basename "$folder")
    
    # 使用正则表达式提取版本号和操作位数
    new_name=$(echo "$folder_name" | sed -E 's/^([0-9]+\.[0-9]+).*(_amd64|_i386)$/\1\2/')
    
    # 重命名文件夹
    if [ "$new_name" != "$folder_name" ]; then
      echo "Renaming '$folder_name' to '$new_name'"
      mv "$folder" "$TARGET_DIR/$new_name"
    fi
  fi
done

echo "所有文件夹已成功重命名。"
