#!/bin/bash

dir="WorkDir"

# 检查 exiftool 是否安装
if ! command -v exiftool &>/dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "请先安装 exiftool，例如: brew install exiftool"
    else
        echo "请先安装 exiftool，例如: sudo apt install libimage-exiftool-perl"
    fi
    exit 1
fi

# 按最后修改时间排序并处理
# macOS和Linux的find命令有所不同
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS使用stat获取时间戳
    find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | \
    xargs -0 stat -f '%m %N' | sort -n | while read -r timestamp filepath; do
        # 格式化时间为 YYYYMMDD_HHMMSS
        newname=$(date -r "${timestamp%.*}" +"%Y%m%d_%H%M%S")

        # 获取文件扩展名（小写）
        ext="${filepath##*.}"
        ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        # 防止重名
        counter=1
        finalname="${dir}/${newname}.${ext_lower}"
        while [ -e "$finalname" ]; do
            finalname="${dir}/${newname}_$counter.${ext_lower}"
            counter=$((counter+1))
        done

        # 重命名
        mv "$filepath" "$finalname"

        # 修改 EXIF 拍摄时间和文件修改时间
        if exiftool "-DateTimeOriginal=$(date -r "${timestamp%.*}" +"%Y:%m:%d %H:%M:%S")" -overwrite_original "$finalname" 2>/dev/null; then
            touch -m -t "$(date -r "${timestamp%.*}" +"%Y%m%d%H%M.%S")" "$finalname"
            echo "处理完成: $finalname"
        else
            echo "警告: 处理 $finalname 的EXIF数据时出错，跳过此文件"
        fi
    done
else
    # Linux使用printf
    find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
      -printf "%T@ %p\n" | sort -n | while read -r timestamp filepath; do
        # 格式化时间为 YYYYMMDD_HHMMSS
        newname=$(date -d @"${timestamp%.*}" +"%Y%m%d_%H%M%S")

        # 获取文件扩展名（小写）
        ext="${filepath##*.}"
        ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        # 防止重名
        counter=1
        finalname="${dir}/${newname}.${ext_lower}"
        while [ -e "$finalname" ]; do
            finalname="${dir}/${newname}_$counter.${ext_lower}"
            counter=$((counter+1))
        done

        # 重命名
        mv "$filepath" "$finalname"

        # 修改 EXIF 拍摄时间和文件修改时间
        if exiftool "-DateTimeOriginal=$(date -d @"${timestamp%.*}" +"%Y:%m:%d %H:%M:%S")" -overwrite_original "$finalname" 2>/dev/null; then
            touch -m -t "$(date -d @"${timestamp%.*}" +"%Y%m%d%H%M.%S")" "$finalname"
            echo "处理完成: $finalname"
        else
            echo "警告: 处理 $finalname 的EXIF数据时出错，跳过此文件"
        fi
    done
fi