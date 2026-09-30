# 日日澆水（獨立網站版）

手機瀏覽器打開就能用，可以「加到主畫面」變成像 App 的圖示。
帳號用 Email + 密碼，資料存在你自己的 Supabase 專案，換手機、換電腦登入同一個帳號就能接續。

## 資料夾內容

| 檔案 | 用途 |
| --- | --- |
| `index.html` | 整個程式（畫面、遊戲邏輯、登入、雲端同步） |
| `config.js` | **你要填的設定**：Supabase 網址與 anon 金鑰 |
| `schema.sql` | 資料表與權限規則，在 Supabase 執行一次 |
| `supabase.js` | Supabase 官方登入與資料套件（已內含，不用另外裝） |
| `manifest.webmanifest`、`sw.js`、`icon-*.png`、`apple-touch-icon.png` | 讓網站能加到主畫面、離線也能開啟外殼 |

## 設定步驟（約 15 分鐘）

### 1. 建立 Supabase 專案
1. 到 https://supabase.com 用 GitHub 或 Email 註冊。
2. 按 **New project**，取個名字（例如 `ririshuishui`），設定資料庫密碼（存好，之後幾乎用不到），地區選離台灣近的（例如 Singapore 或 Tokyo）。
3. 等專案建好（1～2 分鐘）。

### 2. 建立資料表
1. 左邊選單開 **SQL Editor** → **New query**。
2. 把 `schema.sql` 的內容整份貼上，按 **Run**。看到 Success 就完成。

### 3. 拿到兩個設定值
1. 左邊選單 **Project Settings** → **API**（新版介面可能叫 **API Keys**）。
2. 複製 **Project URL**，以及 **anon public** 金鑰（新版介面若叫 *publishable key* 也是同一種用途）。
3. 打開 `config.js`，把兩個值貼進去：
   ```js
   window.APP_CONFIG = {
     SUPABASE_URL: "https://xxxxxxxx.supabase.co",
     SUPABASE_ANON_KEY: "eyJ...（很長一串）"
   };
   ```
   這把金鑰本來就是給網頁公開使用的，資料安全靠 `schema.sql` 裡的規則（每個人只能讀寫自己的那一列）。**不要**貼 `service_role` 金鑰。

### 4. 放到 GitHub Pages
1. 在 GitHub 建一個新的 repository（例如 `ririshuishui`），設為 **Public**。
2. 把這個資料夾裡的所有檔案上傳到 repository 根目錄（網頁上按 **Add file → Upload files**，拖進去即可）。
3. 到 repository 的 **Settings → Pages**，Source 選 **Deploy from a branch**，Branch 選 `main`、資料夾選 `/ (root)`，按 Save。
4. 等 1～2 分鐘，網址會是 `https://你的帳號.github.io/ririshuishui/`。

### 5. 告訴 Supabase 你的網址（很重要，漏了登入信會失效）
1. Supabase 左邊 **Authentication** → **URL Configuration**。
2. **Site URL** 填你的 GitHub Pages 網址（含最後的 `/`）。
3. **Redirect URLs** 也加上同一個網址。

### 6. 決定要不要「信箱確認」
Supabase 預設註冊後要點信裡的連結才能登入，但免費方案內建寄信額度很少（每小時只有幾封）。
只有你自己用的話，建議關掉：**Authentication → Sign In / Providers → Email**，把 **Confirm email** 關閉。
（關掉之後，任何人只要知道你的網址都能註冊自己的帳號，但每個人只看得到自己的資料。）

### 7. 開始用
1. 用手機打開你的網址，按「建立帳號」。
2. 加到主畫面：
   - iPhone（Safari）：分享按鈕 → 加入主畫面。
   - Android（Chrome）：右上角三個點 → 安裝應用程式 / 加到主畫面。

## 把舊資料搬過來
如果你已經在 Claude 裡的版本玩過：在舊版「我」分頁按 **備份** 複製那串文字，到新網站登入後，在「我」分頁按 **還原** 貼上。

## 同步規則
- 每次操作後幾秒內自動上傳；離線時先存在裝置，恢復連線後自動補傳。
- 回到畫面時會檢查雲端有沒有更新的版本，有就採用。
- 兩台裝置同時操作時，以**最後一次操作的那份整份資料**為準（不是逐項合併），所以請避免兩台同時打卡。

## 之後要加 Google 登入
需要在 Google Cloud Console 建 OAuth 憑證，再到 Supabase 的 Authentication → Providers 開啟 Google。
需要時再跟我說，程式端只要加一顆按鈕。

## 更新程式
改完檔案重新上傳覆蓋即可。如果手機上看到的還是舊版，關掉再開一次，或在瀏覽器裡強制重新整理。

## 疑難排解
- **畫面顯示「還沒設定雲端」**：`config.js` 的兩個值沒填，或填錯後沒上傳。
- **登入後「我」分頁顯示同步失敗**：通常是 `schema.sql` 沒執行，或網址設定（步驟 5）漏了。
- **收不到確認信 / 重設信**：先看垃圾郵件匣；免費寄信額度用完需要等一小時，或照步驟 6 關掉信箱確認。
- **Supabase 免費專案太久沒人用會被暫停**：一週以上沒有任何請求時會暫停，到儀表板按 Restore 即可，資料不會消失。
