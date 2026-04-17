#!/bin/bash

# ==========================================
# M5 通用影像自動化引擎 (V-681031 最終完整版)
# ==========================================

TARGET_DIR="./content/posts"
QUALITY=90
WIDTH=2560
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S+08:00)

echo "🚀 [M5 核心引擎] 啟動中，開始處理影像與排序..."

# 檢查 ImageMagick 是否安裝
if ! command -v convert &> /dev/null; then
    echo "❌ 嚴重錯誤: 找不到 convert 指令。請執行 'brew install imagemagick'"
    exit 1
fi

# 遍歷目標目錄下的所有子資料夾
for dir in "$TARGET_DIR"/*/; do
    [ -d "$dir" ] || continue
    FOLDER_NAME=$(basename "$dir")
    
    # --- 1. 權重計算 (Day 5 變 -5，確保降序排列) ---
    NUM_ID=$(echo "$FOLDER_NAME" | grep -oE '[0-9]+' | head -1)
    if [ -z "$NUM_ID" ]; then
        FINAL_WEIGHT=0
    else
        FINAL_WEIGHT=$((NUM_ID * -1))
    fi

    # --- 2. 影像轉檔邏輯 ---
    find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) | while read -r img; do
        filename=$(basename "$img")
        
        # 跳過封面圖
        if [[ "$filename" == *"feature"* ]]; then
            continue
        fi

        base_path="${img%.*}"
        webp_path="${base_path}.webp"
        
        # 若 WebP 不存在則進行高品質轉檔
        if [ ! -f "$webp_path" ]; then
            convert "$img" -resize "${WIDTH}x" -strip -quality "$QUALITY" "$webp_path"
            echo "  ✅ 已生成 WebP: $(basename "$webp_path")"
        fi
    done

    # --- 3. 更新 index.md (解決重複標籤問題) ---
    # 這裡不強加 layout，讓主題自動接管最保險
    printf "+++\ntitle = \"%s\"\ndate = %s\nweight = %d\ndraft = false\n+++\n\n{{< auto-gallery >}}\n" "$FOLDER_NAME" "$CURRENT_TIME" "$FINAL_WEIGHT" > "$dir/index.md"
    
    echo "  ✨ $FOLDER_NAME 同步完成 (權重: $FINAL_WEIGHT)"
done

echo "🎉 [系統回報] 影像處理完畢。"
exit 0