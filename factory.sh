#!/bin/bash

# --- v-681031 專屬影像工廠：超級進化版 ---
# 功能：自動掃描所有資料夾、縮放至 2560px、畫質 90、轉為 WebP 並移除隱私資訊

TARGET_DIR="./content/posts"
QUALITY=90
WIDTH=2560

echo "🚀 影像工廠啟動：正在掃描 $TARGET_DIR 底下的所有資料夾..."

# 檢查是否安裝了 ImageMagick (convert)
if ! command -v convert &> /dev/null; then
    echo "❌ 錯誤: 找不到 convert 指令。請先執行 'brew install imagemagick'"
    exit 1
fi

# 使用 find 指令遞迴搜尋所有 JPG 和 PNG (不論大小寫)
find "$TARGET_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    
    # 取得不含副檔名的路徑
    base_path="${img%.*}"
    webp_path="${base_path}.webp"

    # 檢查是否已經存在 webp 檔案，不存在才處理
    if [ ! -f "$webp_path" ]; then
        echo "📸 正在轉換並縮放: $img"
        # 1. 調整寬度至 2560px
        # 2. 抹除 GPS 與隱私資訊 (-strip)
        # 3. 設定畫質 90
        convert "$img" -resize "${WIDTH}x" -strip -quality "$QUALITY" "$webp_path"
        echo "✅ 成功產出: $webp_path"
    else
        # 如果已經轉過，就快速跳過，節省時間
        echo "⏩ 跳過 (已存在): $webp_path"
    fi
done

echo "🎉 處理完成！現在你的所有影像都是 2560px @ Q90 的極致畫質了。"