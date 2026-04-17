#!/bin/bash

# --- M5 通用影像自動化引擎 (Universal Image Factory) ---
# 功能：自動轉檔 WebP、高品質縮放、抹除隱私、自動生成 index.md
# 排序邏輯：自動提取資料夾名稱中的數字作為「負數權重」(數字越大，位置越高)

TARGET_DIR="./content/posts"
QUALITY=90
WIDTH=2560
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S+08:00)

echo "🚀 [通用影像工廠] 啟動！正在進行全自動出版流程..."

# 檢查 ImageMagick 是否安裝
if ! command -v convert &> /dev/null; then
    echo "❌ 錯誤: 找不到 convert 指令。請執行 'brew install imagemagick' 以啟用影像轉檔功能。"
    exit 1
fi

# 1. 遍歷目標目錄下的所有子資料夾
for dir in "$TARGET_DIR"/*/; do
    # 確保是有效的資料夾
    [ -d "$dir" ] || continue
    
    FOLDER_NAME=$(basename "$dir")
    
    # --- 智慧權重計算 ---
    # 從資料夾名稱中提取第一個出現的數字序列
    NUM_ID=$(echo "$FOLDER_NAME" | grep -oE '[0-9]+' | head -1)
    
    if [ -z "$NUM_ID" ]; then
        # 名稱中無數字時，權重設為 0
        FINAL_WEIGHT=0
        echo "📂 處理資料夾：$FOLDER_NAME (無序號，預設權重: 0)"
    else
        # 將數字轉為負數權重 (例如：序號 100 -> 權重 -100，保證排在序號 99 之前)
        FINAL_WEIGHT=$((NUM_ID * -1))
        echo "📂 處理資料夾：$FOLDER_NAME (偵測到序號: $NUM_ID -> 權重: $FINAL_WEIGHT)"
    fi

    # --- 影像轉檔與優化 ---
    # 掃描 JPG, PNG, BMP 原始檔
    find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) | while read -r img; do
        base_path="${img%.*}"
        webp_path="${base_path}.webp"
        
        # 僅當 WebP 不存在時才執行轉檔，避免重複運算
        if [ ! -f "$webp_path" ]; then
            convert "$img" -resize "${WIDTH}x" -strip -quality "$QUALITY" "$webp_path"
            echo "  ✅ 影像優化完成: $(basename "$webp_path")"
        fi
    done

    # --- 自動出版 index.md (強制覆蓋，確保排序邏輯同步) ---
    printf "+++\ntitle = \"%s\"\ndate = %s\nweight = %d\nlayout = \"wide\"\ndraft = false\n+++\n\n{{< auto-gallery >}}\n" "$FOLDER_NAME" "$CURRENT_TIME" "$FINAL_WEIGHT" > "$dir/index.md"
    
    echo "  ✨ $FOLDER_NAME 出版配置已更新完成。"
done

echo "🎉 [任務達成] 全數目錄處理完畢！"
exit 0