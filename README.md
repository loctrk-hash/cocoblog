# CocoBook 記帳筆記

以 Hugo + PaperMod 建置的靜態部落格，部署於 <https://cocobook.cc/>（VPS + Nginx）。

> 新開 session 或接手維護時，請先讀 **[docs/handover.md](docs/handover.md)**（環境、部署、注意事項）與 **[docs/content-roadmap.md](docs/content-roadmap.md)**（20 篇文章進度）。

## 目錄結構

```
content/
  posts/           文章（一篇一個 .md，檔名 = 網址）
  about.md         關於
  privacy.md       隱私權政策
  404.md           自訂 404 頁（layout: notfound）
docs/
  handover.md      交接文件（環境、部署、注意事項）
  content-roadmap.md  20 篇文章進度
layouts/
  robots.txt       自訂 robots.txt
static/            原樣複製到網站根目錄的檔案（例如 ads.txt、圖片）
themes/PaperMod/   git submodule
hugo.toml          網站設定
deploy.sh          建置 + rsync 到 VPS
```

## 環境需求

- Hugo extended **0.158 以上**（目前使用 0.169.0，安裝於 `~/.local/bin/hugo`）
- `rsync`

確認版本：

```bash
hugo version
```

## 本機預覽

```bash
hugo server -D
```

開啟 <http://localhost:1313/>。存檔會自動重新整理，`Ctrl+C` 停止。

## 發文 SOP

1. 在 `content/posts/` 新增 Markdown 檔，**檔名用英文**，例如 `budget-tips.md`。
2. 檔案開頭填 front matter：

   ```markdown
   ---
   title: "文章中文標題"
   date: 2026-11-12T09:00:00+08:00
   draft: false
   description: "一句話摘要（列表與 SEO description 會用）"
   tags: ["標籤1", "標籤2"]
   categories: ["記帳技巧"]
   ShowToc: true
   ---

   導言段落……

   <!--more-->

   ## 第一個小標
   ```

   - `<!--more-->` 之前的內容會成為首頁列表的摘要；不寫的話 Hugo 會自動截取。
   - `categories` 目前使用：`記帳技巧`、`理財觀念`、`App 教學`。
3. 用 Markdown 寫正文。
4. `hugo server -D` 預覽確認。
5. `Ctrl+C` 後執行 `./deploy.sh` 部署。

### 網址規則

檔名就是網址，由 `hugo.toml` 的 `:contentbasename` 決定：

```
content/posts/first-month-budgeting.md  →  /posts/first-month-budgeting/
```

所以檔名請用英文小寫與連字號，重新命名檔案會改變文章網址。

### 草稿

front matter 設 `draft: true`：本機 `hugo server -D` 看得到，正式部署不會產生。

### 圖片

- 全站共用圖片：放在 `static/images/`，文章中寫 `![說明](/images/檔名.jpg)`。
- 文章專屬圖片：把文章改成 page bundle（`content/posts/<slug>/index.md` 加圖片），
  文章內寫 `![說明](檔名.jpg)`。

## 部署

```bash
./deploy.sh
```

腳本會依序執行：

1. `hugo --minify --cleanDestinationDir` → 產生 `public/`
2. `rsync -az --delete public/ darius@139.162.119.111:/var/www/cocobook/`

> `--delete` 會讓遠端目錄與本機完全一致，請勿在 VPS 的 `/var/www/cocobook/` 手動放檔案。

## 注意事項

- **閱讀時間已關閉**：Hugo 以空白斷詞，中文會被低估成「1 分鐘」，因此 `ShowReadingTime = false`。
- `/static/` 與 `/webhook` 由 VPS 上的 LINE Bot App 使用，部落格不要建立名為 `static` 的內容路徑。
- 隱私權政策的聯絡信箱：`darius.fsk.fong@gmail.com`。
- 主題是 git submodule，換電腦 clone 時請用：

  ```bash
  git clone --recurse-submodules <repo>
  ```
