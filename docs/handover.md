# CocoBook 部落格交接文件

> 最後更新：2026-11-13
> 這份文件給「新開的 session」或「未來的自己」看。讀完這份 + `docs/content-roadmap.md`，就能繼續寫文章與部署，不需要回頭翻舊對話。

---

## 0. 新 session 開場指令（直接複製貼上）

```text
請先讀 docs/handover.md 與 docs/content-roadmap.md，然後依照路線圖繼續寫下一篇尚未完成的文章。
寫完後在本機驗證、部署到 https://cocobook.cc/，最後 commit 並 push。
```

若只想寫特定主題，把最後一句換成「這次寫第 N 篇：<slug>」。

---

## 1. 專案概觀

| 項目 | 內容 |
|---|---|
| 網站 | <https://cocobook.cc/>（Hugo + PaperMod 靜態部落格） |
| 目的 | 累積原創內容，申請 Google AdSense 主網域審核 |
| 內容方向 | 記帳理財 + App 教學 |
| 分類（固定三個） | `記帳技巧`、`理財觀念`、`App 教學` |
| 語言 | 繁體中文（`zh-TW`），文章檔名與網址用英文 |
| 原始碼 | `https://github.com/loctrk-hash/cocoblog.git` |
| 本機目錄 | `/home/darius/vscode_prj/cocoblog` |
| 部署方式 | 本機 `hugo` 建置 → `rsync` 到 VPS（沒有 CI/CD） |
| VPS | `darius@139.162.119.111` |
| 網站根目錄 | `/var/www/cocobook/` |

### 架構

```text
本機 content/posts/<slug>.md
  │ hugo --minify
  ▼
public/posts/<slug>/index.html
  │ ./deploy.sh（rsync -az --delete）
  ▼
VPS /var/www/cocobook/
  │ Nginx 靜態服務
  ▼
https://cocobook.cc/
```

同一個 Nginx server block 另外保留了 LINE Bot 的 `/webhook` 與 `/static/*`（見第 6 節）。

---

## 2. 環境與路徑

| 項目 | 路徑 / 值 |
|---|---|
| Hugo | `~/.local/bin/hugo`，**v0.169.0 extended**（PaperMod 需要 ≥ 0.158） |
| 設定檔 | `hugo.toml` |
| 文章 | `content/posts/*.md` |
| 固定頁面 | `content/about.md`、`content/privacy.md`、`content/404.md` |
| 自訂 layout | `layouts/`（404、robots.txt） |
| 自訂 partial | `layouts/_partials/`（`ad-slot`、`extend_post_content`、`extend_head`、`404-content`） |
| 自訂 shortcode | `layouts/_shortcodes/`（`site-card`、`ad-slot`） |
| 樣式 | `assets/css/extended/custom.css`（PaperMod 自動合併，內含設計變數與廣告位樣式） |
| 靜態檔 | `static/`（原樣複製到網站根目錄，例如 favicon、未來的 `ads.txt`） |
| 主題 | `themes/PaperMod/`（git submodule） |
| 部署腳本 | `deploy.sh` |
| 建置輸出 | `public/`（已 gitignore，不要 commit） |

VPS 端：

| 項目 | 路徑 |
|---|---|
| 站台設定 | `/etc/nginx/sites-available/cocobook` |
| 設定備份 | `/home/darius/cocobook.conf.bak.20261112_132927` |
| 設定版本控管 | repo 內 `deploy/nginx/cocobook.conf`（與線上一致） |
| 網站根目錄 | `/var/www/cocobook/` |
| 憑證 | `/etc/letsencrypt/live/cocobook.cc/`（SAN 含 `www.cocobook.cc`，`certbot.timer` 自動續約） |

---

## 3. 目前狀態（2026-11-13）

### 已完成

- 網站上線：首頁、文章、分類、標籤、關於、隱私權政策、RSS、sitemap、robots。
- HTTPS 正常；Cloudflare 已開 HSTS（`max-age=15552000; includeSubDomains`）。
- `www.cocobook.cc` → `https://cocobook.cc` 301（保留路徑）。
- 自訂中文 404 頁，且已排除在 sitemap 之外。
- favicon 一組（ico / 16 / 32 / apple-touch / safari pinned tab）。
- PaperMod 視覺微整型（米白 + 墨綠）：自訂色票、中文系統字型、首頁 hero、卡片與文章排版。
- 首頁 hero 含兩個 CTA：「開始閱讀」→ `/posts/`、「相關網站」→ `/sites/`。
- 廣告版位程式已就位但預設關閉（`params.ads.enabled = false`），關閉時不輸出任何空白區塊。
- Google Search Console：網域 TXT 驗證通過，sitemap 已提交。
- LINE Bot 的 `/webhook`、`/static/*` 保留未動。
- Nginx `sites-enabled` 已清掉重複的 `.bak`，`nginx -t` 無 warning。

### 目前內容

目前 **2 篇**文章：

- `content/posts/first-month-budgeting.md` — 記帳新手的第一個月：從零開始建立習慣
- `content/posts/three-budgeting-methods.md` — 三種記帳法比較：流水帳、分類預算、信封法

### 下一個主要目標

依 `docs/content-roadmap.md` 補到 **15–20 篇**原創文章，再送 AdSense 審核。

### 已知但不影響運作

- GSC 的 sitemap 剛提交時可能顯示「無法擷取」，通常 24–48 小時後會自己變成「成功」。實測 Googlebot 與 Mediapartners-Google 抓 `sitemap.xml` 都是 200。
- Cloudflare SSL 模式目前是「完整（Full）」，**不是**「完整（嚴格）」。不是 AdSense 必要條件，有看到「配置」按鈕再切即可。
- `content/404.md` 的 `url: "/404.html"` 是必要的；改掉會讓 404 頁變成 `/404/`。
- `layouts/404.html` 是早期留下的未使用檔案（實際生效的是 `layouts/_default/notfound.html`），留著無害，不要因此改動 404 設定。

---

## 4. 重要設定決策（不要隨便改）

| 設定 | 值 | 原因 |
|---|---|---|
| `permalinks.posts` | `/posts/:contentbasename/` | 檔名 = 網址。Hugo 0.169 的 `:slug` 對中文標題會產生中文網址，已避開 |
| `ShowReadingTime` | `false` | Hugo 用空白斷詞，中文閱讀時間會被低估成 1 分鐘 |
| `DateFormat` | `2006年1月2日` | 中文日期顯示 |
| `locale` | `zh-TW` | Hugo 0.169 起 `languageCode` 已 deprecated |
| `mainSections` | `["posts"]` | 首頁只列文章，不列 about/privacy |
| 404 | `content/404.md` + `layout: "notfound"` | `layout: "404"` 是保留字，會被忽略 |
| robots | `layouts/robots.txt` | 禁止 `/static/`、`/webhook`，並宣告 sitemap |
| 靜態快取 | Nginx `expires 30d` | CSS/JS/圖片；HTML 不快取，改版立即生效 |

其他既有設定：`ShowShareButtons = true`、`ShowBreadCrumbs = true`、`ShowPostNavLinks = true`、`ShowCodeCopyButtons = true`、`enableRobotsTXT = true`。

### 廣告版位（`params.ads`）

`hugo.toml` 的 `[params.ads]`：

| 參數 | 預設 | 說明 |
|---|---|---|
| `enabled` | `false` | 總開關。`false` 時全站不輸出 script、容器，也不會留下空白 |
| `client` | `""` | AdSense Publisher ID，例如 `ca-pub-1234567890123456` |
| `autoAds` | `false` | 保留欄位；啟用自動廣告時仍以 `client` 載入同一支 script |
| `articleBottomSlot` | `""` | 文章底部廣告單元 ID；`ad-slot` shortcode 未指定時也共用此值 |

檔案分工：

| 檔案 | 作用 |
|---|---|
| `layouts/_partials/extend_head.html` | 載入 `adsbygoogle.js`（需 `enabled` 且 `client` 有值） |
| `layouts/_partials/extend_post_content.html` | 文章底部自動版位（只在 `posts`、`enabled`、slot 有值時輸出） |
| `layouts/_shortcodes/ad-slot.html` | 文章中段手動版位，例如 `{{< ad-slot >}}` |
| `layouts/_partials/ad-slot.html` | 實際的廣告容器與 `ins.adsbygoogle` |
| `assets/css/extended/custom.css` | `.ad-slot` 的固定最小高度（降低 CLS） |

文章中加入中段版位：

```markdown
## 小標

段落……

{{< ad-slot >}}

下一個段落……
```

- 指定不同單元：`{{< ad-slot slot="1234567890" >}}`
- 單篇文章不想出現底部廣告：front matter 加 `hideAds: true`
- `about`、`privacy`、`sites`、404 不會出現廣告

啟用步驟：

1. AdSense 審核通過，取得 Publisher ID 與廣告單元 ID。
2. `hugo.toml` 設 `enabled = true`，填入 `client` 與 `articleBottomSlot`。
3. `rm -rf public && hugo --minify`，確認文章頁有 `adsbygoogle`，首頁／`about`／`sites` 沒有。
4. 把 AdSense 提供的 `ads.txt` 放進 `static/ads.txt`（**不要放假檔**）。
5. `./deploy.sh` 後用瀏覽器確認廣告載入前後沒有明顯跳版。

---

## 5. 發文流程（標準作業）

### 步驟 1：建立文章檔

檔名用**英文小寫 + 連字號**，例如 `content/posts/three-budgeting-methods.md`。

### 步驟 2：填 front matter

```markdown
---
title: "三種記帳法比較：流水帳、分類預算、信封法"
date: 2026-11-20T09:00:00+08:00
draft: false
description: "一句話摘要，約 60–120 字，會用在列表與 SEO description。"
tags: ["記帳", "預算"]
categories: ["記帳技巧"]
ShowToc: true
TocOpen: false
---

導言：先用 2–4 段說明讀者會遇到什麼問題、這篇能解決什麼。

<!--more-->

## 第一個小標
...
```

規則：

- `categories` **只能使用** `記帳技巧`、`理財觀念`、`App 教學` 三者之一（錯字會多出分類頁）。
- `date` 用 `+08:00`；建議排在未來或當天，維持穩定發文節奏。
- `<!--more-->` 之前是首頁摘要，建議 2–4 段；沒有這個標記時 Hugo 會自動截斷。
- 草稿用 `draft: true`：本機 `hugo server -D` 看得到，`./deploy.sh` 不會輸出。

### 步驟 3：本機預覽

```bash
cd /home/darius/vscode_prj/cocoblog
hugo server -D
```

開 <http://localhost:1313/> 確認：標題、日期、分類、目錄、內部連結、程式碼區塊（若有）。`Ctrl+C` 停止。

沒有瀏覽器時，至少做建置檢查：

```bash
rm -rf public && hugo --minify 2>&1 | grep -E 'WARN|ERROR|Total'
test -f public/posts/<slug>/index.html && echo OK
```

### 步驟 4：部署

```bash
./deploy.sh
```

腳本內容：`hugo --minify --cleanDestinationDir` → `rsync -az --delete public/ darius@139.162.119.111:/var/www/cocobook/`。

> `--delete` 會讓遠端與本機完全一致。**不要在 VPS 的 `/var/www/cocobook/` 手動放檔案**，下次部署會被刪掉。

### 步驟 5：線上驗證

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://cocobook.cc/posts/<slug>/
curl -s https://cocobook.cc/posts/<slug>/ | grep -oE '<title>[^<]*</title>'
```

首頁也確認新文章有出現：

```bash
curl -s https://cocobook.cc/ | grep -o 'posts/<slug>/' | head -1
```

### 步驟 6：commit & push

```bash
git add content/posts/<slug>.md docs/content-roadmap.md
git commit -m "Add post: <中文標題>"
git push origin main
```

發文後記得把 `docs/content-roadmap.md` 該篇狀態改成 `✅`。

### 圖片

- 全站共用：放 `static/images/`，文章寫 `![說明](/images/檔名.jpg)`。
- 單篇專屬：改成 page bundle（`content/posts/<slug>/index.md` + 圖片），文章寫 `![說明](檔名.jpg)`。
- 建議壓縮到寬度 1200px 以內，並填 alt 文字（SEO 與無障礙）。

---

## 6. 絕對不要動的地方

| 項目 | 說明 |
|---|---|
| `/home/darius/linebot` | LINE Bot App 本體，與部落格無關 |
| `/webhook` | Nginx 代理到 `127.0.0.1:3000`，App 用 |
| `/static/*` | Nginx alias 到 linebot 的 publicWeb 目錄，App 用 |
| 其他 Nginx site | `cocoweb`、`cocowebml`、`bot13` 都不要改 |
| Cloudflare DNS | 除了 AdSense / GSC 要求的 TXT，不要改動 |
| 憑證 | 不要手動改 `/etc/letsencrypt/`；續約由 `certbot.timer` 負責 |
| `/var/www/cocobook/` | 只由 `deploy.sh` 寫入，不要手動編輯 |

部落格若要放圖片，用 `static/images/`，**不要**建立 `content/static/` 之類會與 `/static/` 衝突的路徑。

---

## 7. VPS / sudo 操作規則

- **需要 sudo 的指令一律由使用者本人執行**，agent 只負責：準備指令、說明預期輸出、提供回滾方式。
- 一次只給一組指令，執行後回報結果再做下一組。
- 改 Nginx 前一定先備份，並先跑 `sudo nginx -t` 再 `reload`。

### 修改 Nginx 的標準流程

```bash
# 1. 本機改 deploy/nginx/cocobook.conf，上傳
scp deploy/nginx/cocobook.conf darius@139.162.119.111:~/cocobook.conf.new
ssh darius@139.162.119.111 'md5sum ~/cocobook.conf.new'
md5sum deploy/nginx/cocobook.conf   # 兩邊要一致

# 2. 由使用者在 VPS 執行
sudo cp /home/darius/cocobook.conf.new /etc/nginx/sites-available/cocobook \
  && sudo nginx -t \
  && sudo systemctl reload nginx
```

### 回滾

```bash
sudo cp /home/darius/cocobook.conf.bak.20261112_132927 /etc/nginx/sites-available/cocobook \
  && sudo nginx -t \
  && sudo systemctl reload nginx
```

---

## 8. 上線驗收清單

部署後跑這一段，全部要是 `200`（404 測試頁要是 `404`）：

```bash
for u in / /posts/ /about/ /privacy/ /categories/ /sitemap.xml /robots.txt /favicon.ico; do
  printf '%-20s ' "$u"
  curl -s -o /dev/null -w '%{http_code}\n' --max-time 20 "https://cocobook.cc$u"
done

curl -s -o /dev/null -w '404 test: %{http_code}\n' https://cocobook.cc/this-page-does-not-exist/
curl -s -o /dev/null -w 'www: %{http_code} -> %{redirect_url}\n' https://www.cocobook.cc/
curl -s -o /dev/null -w 'static: %{http_code}\n' https://cocobook.cc/static/main.html
```

| 檢查 | 預期 |
|---|---|
| `/`、`/posts/`、文章、`/about/`、`/privacy/` | 200 |
| `/sitemap.xml`、`/robots.txt`、`/favicon.ico` | 200 |
| 不存在的網址 | 404 + 中文 404 頁 |
| `https://www.cocobook.cc/` | 301 → `https://cocobook.cc/` |
| `/static/main.html` | 200（LINE Bot 路徑仍在） |
| `/webhook` | 502 是正常的（App 沒在跑）；重點是不要變成 404 |

---

## 9. 疑難排解

### 本機 `hugo` 找不到或版本太舊

```bash
hugo version   # 需要 ≥ 0.158 extended
```

若 `hugo` 不在 PATH，用 `~/.local/bin/hugo`，或把 `~/.local/bin` 加進 PATH。

### 部署後線上看不到新文章

1. 確認 `public/posts/<slug>/index.html` 存在。
2. `curl -s https://cocobook.cc/posts/<slug>/ | head` 看是舊內容還是 404。
3. HTML 是 `cf-cache-status: DYNAMIC`，正常不會被 Cloudflare 快取；若懷疑快取，到 Cloudflare 做 **Purge Everything**。
4. 確認 `deploy.sh` 沒有錯誤訊息（rsync 失敗會中止）。

### 404 頁變成英文或變成 `/404/`

- 確認 `content/404.md` 有 `url: "/404.html"` 與 `layout: "notfound"`。
- 確認 `layouts/_default/notfound.html` 與 `layouts/_partials/404-content.html` 存在。
- 本機 `rm -rf public && hugo --minify` 後確認 `public/404.html`（不是 `public/404/index.html`）。

### GSC sitemap 顯示「無法擷取」

先等 24–48 小時，不要反覆刪除重送。可用 Googlebot UA 自查：

```bash
curl -s -o /dev/null -w '%{http_code} %{content_type}\n' \
  -A 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)' \
  https://cocobook.cc/sitemap.xml
```

若是 200 且 `text/xml`，代表 Google 抓得到，只是 GSC 狀態還沒更新。

### 文章網址變成中文

代表有人改了 `permalinks` 或用了 `slug`。維持 `/posts/:contentbasename/`，並確認檔名是英文。

### Nginx 設定改壞

用第 7 節的回滾指令還原，再 `nginx -t` + `reload`。

---

## 10. 常用指令速查

```bash
# 版本與狀態
hugo version
git status -sb
git log --oneline -5

# 本機預覽
hugo server -D

# 建置
rm -rf public && hugo --minify

# 部署
./deploy.sh

# 線上檢查
curl -sI https://cocobook.cc/ | grep -iE 'HTTP|strict-transport-security'

# 發文後 commit
git add content/posts/<slug>.md docs/content-roadmap.md
git commit -m "Add post: <中文標題>"
git push origin main
```

---

## 11. 待辦（依優先序）

1. **寫文章**：依 `docs/content-roadmap.md` 補到 15–20 篇（目前 2 篇）。
2. **App 教學素材**：需要使用者提供 CocoBook App 的實際畫面與操作流程（截圖最好），才能寫出準確教學。
3. **AdSense**：內容足夠後送審；通過後依第 4 節「廣告版位」啟用 `params.ads`，並把正式 `ads.txt` 放進 `static/ads.txt`。
4. （選配）Cloudflare SSL 改「完整（嚴格）」。
5. （選配）GSC 觀察「索引 → 頁面」，確認文章陸續被收錄。
