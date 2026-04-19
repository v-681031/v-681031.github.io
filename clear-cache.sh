#!/usr/bin/env bash
# ============================================================
#  clear-cache.sh  ─ Hugo 專案「最徹底」清快取腳本
#  涵蓋：本地 build 產物 + Hugo 全域快取 + Hugo Modules
#        + Go modules (互動確認) + Node/npm + macOS .DS_Store
# ============================================================

cd "$(dirname "$0")" || exit 1

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  🧹  Hugo 專案 最深層 清快取腳本         ║"
echo "╚══════════════════════════════════════════╝"
echo "📂 專案目錄：$(pwd)"
echo ""

# ---------- 1. 殺掉正在跑的 Hugo server ----------
echo "▶ [1/8] 關閉所有正在跑的 Hugo server"
pkill -9 -f "hugo server" 2>/dev/null && echo "   ✅ 已關閉 Hugo server" || echo "   ℹ️  無 Hugo server 在跑"

# ---------- 2. 清除本地 build 輸出 ----------
echo "▶ [2/8] 清除本地 build 產物：public/ resources/ .hugo_build.lock"
rm -rf public resources .hugo_build.lock
echo "   ✅ 完成"

# ---------- 3. 清除 Hugo 全域快取 ----------
echo "▶ [3/8] 清除 Hugo 全域快取 (~/Library/Caches/hugo_cache*)"
rm -rf "$HOME/Library/Caches/hugo_cache"
rm -rf "$HOME/Library/Caches/hugo_cache_runner"
rm -rf "/tmp/hugo_cache"
rm -rf "/tmp/hugo_cache_$(whoami)"
echo "   ✅ 完成"

# ---------- 4. 清除 Hugo Modules ----------
echo "▶ [4/8] 清除 Hugo Modules 快取 (hugo mod clean --all)"
if command -v hugo >/dev/null 2>&1; then
    hugo mod clean --all >/dev/null 2>&1 && echo "   ✅ hugo mod clean --all 完成" || echo "   ℹ️  無 modules 可清"
else
    echo "   ⚠️  找不到 hugo 指令，跳過"
fi

# ---------- 5. 清除 Go modules & build cache（互動確認）----------
echo ""
echo "▶ [5/8] 清除 Go modules & build cache"
echo "   ⚠️  這會影響電腦上「所有 Go 專案」："
echo "      • go clean -modcache → 刪掉 ~/go/pkg/mod/ （所有下載過的 Go 套件）"
echo "      • go clean -cache    → 刪掉 ~/Library/Caches/go-build/ （編譯中間檔）"
echo "   💡 若你電腦上只有 Hugo 專案 / 沒做其他 Go 開發 → 選 y 沒問題"
echo "   💡 若你有其他 Go 專案在開發中 → 建議選 n 跳過"
echo ""
read -p "   要執行嗎？ [y/N]: " -r GO_CLEAN_CONFIRM
echo ""

if [[ "$GO_CLEAN_CONFIRM" =~ ^[Yy]$ ]]; then
    if command -v go >/dev/null 2>&1; then
        echo "   🔄 執行中..."
        go clean -modcache >/dev/null 2>&1 || true
        go clean -cache    >/dev/null 2>&1 || true
        echo "   ✅ 完成"
    else
        echo "   ⚠️  找不到 go 指令，跳過"
    fi
else
    echo "   ⏭️  已跳過 Go 快取清除"
fi

# ---------- 6. 清除 Node/npm/Vite 等快取 ----------
echo "▶ [6/8] 清除 Node/npm/Vite/PostCSS 快取"
rm -rf node_modules/.cache
rm -rf node_modules/.vite
rm -rf .cache
rm -rf dist
rm -rf .parcel-cache
if command -v npm >/dev/null 2>&1; then
    npm cache clean --force >/dev/null 2>&1 || true
fi
echo "   ✅ 完成"

# ---------- 7. 清除 macOS .DS_Store 殘留 ----------
echo "▶ [7/8] 清除 macOS .DS_Store"
find . -name ".DS_Store" -type f -delete 2>/dev/null || true
echo "   ✅ 完成"

# ---------- 8. 磁碟同步 ----------
echo "▶ [8/8] 執行 sync 強制磁碟寫入"
sync
echo "   ✅ 完成"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  🎉  所有快取已清除完畢                  ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "建議後續動作："
echo "  1. 啟動 server：  hugo server --disableFastRender --noHTTPCache"
echo "  2. 瀏覽器：       Cmd + Shift + R  (強制刷新)"
echo "  3. DevTools：    Network tab → 勾 [✓] Disable cache"
echo ""