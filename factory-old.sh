#!/bin/bash
# v-681031 專屬影像工廠腳本
# 功能：自動將照片轉為 WebP、縮放尺寸並移除隱私資訊

echo "🚀 影像工廠啟動中..."

# 處理資料夾內所有的 jpg 和 png 檔案
for f in *.jpg *.png *.JPG *.PNG; do
  if [ -f "$f" ]; then
    echo "⚙️ 正在處理: $f"
    # 1. 轉為 WebP (畫質 90)
    # 2. 縮放寬度至 2560px (網頁瀏覽最優化)
    # 3. 抹除 GPS 與中繼資料保護隱私
    convert "$f" -resize 2560x -strip -quality 90 "${f%.*}.webp"
  fi
done

echo "✅ 處理完成！你可以把產出的 .webp 檔案傳回 M5 了。"
