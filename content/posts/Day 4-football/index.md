+++
title = "Day 4: 足球場的高畫質紀錄"
date = 2026-04-17
draft = false
layout = "wide"
thumbnail = "Negative15.webp"
feature = "Negative15.webp"
+++

這裡是第四天的攝影實驗。採用 5 欄式高密度排版，展現攝影集般的紀錄質感。

<style>
  .football-gallery {
    display: flex !important;
    flex-wrap: wrap !important;
    gap: 8px !important; /* 縮小間距，給大圖更多空間 */
    width: 100% !important;
    padding: 20px 0 !important;
  }
  
  .football-gallery .photo-item {
    /* 100% 除以 5 = 20% */
    flex: 1 1 calc(20% - 8px) !important;
    /* 必須調低 min-width，否則在筆電螢幕會因為太擠而自動斷行 */
    min-width: 150px !important; 
    margin: 0 !important;
  }

  .football-gallery img {
    width: 100% !important;
    height: auto !important;
    border-radius: 4px !important; /* 5 欄較小，圓角縮小一點更精緻 */
    box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
    display: block !important;
    transition: all 0.3s ease !important;
    cursor: zoom-in;
  }

  .football-gallery img:hover {
    transform: scale(1.08); /* 縮圖較小，滑鼠懸停時放大明顯一點 */
    z-index: 10;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3) !important;
  }
</style>

<div class="football-gallery">
  <div class="photo-item">
    <img src="Negative17.webp" alt="足球場 1" class="medium-zoom-image" />
  </div>
  <div class="photo-item">
    <img src="Negative10.webp" alt="足球場 2" class="medium-zoom-image" />
  </div>
  <div class="photo-item">
    <img src="Negative12.webp" alt="足球場 3" class="medium-zoom-image" />
  </div>
  <div class="photo-item">
    <img src="Negative15.webp" alt="足球場 4" class="medium-zoom-image" />
  </div>
  </div>