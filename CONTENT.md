# DaoDao Blog content contract

本分支新增雙語 Markdown 內容資料。`articles/` 的首組文章僅供格式驗證，未經人工核准，不可當作已發布文章。`published_at` 為範例日期；正式首發時才記錄實際日期，後續修訂保留首發日期並填 `updated_at`。

- `authors.json`：雙語作者名稱與簡介，不捏造資歷。
- `topics.json`：受控主題及雙語名稱；文章以主題 ID 引用。
- `articles/<zh-tw|en>/<stable-id>.md`：YAML frontmatter 加 Markdown 內文，同一 `id` 必須有 `zh-TW` 與 `en`，一次驗證完整語言組。
- `images/`：文章圖片；可不放封面。加入圖片時需提供替代文字，圖片路徑必須位於此目錄。
- 核准證據及私人研究材料放在內容 repo 之外，不得當成公開靜態資源。

共用 schema、解析器、CLI 與測試只有一份：`daodao-f2e/packages/blog-content`。網站建置、CI 與後續 blog-publisher 都應呼叫同一個套件，勿各自複製規則。

## 本機驗證

在配對的 daodao-f2e checkout 執行（root 改為內容 checkout 的絕對路徑）：

```sh
pnpm --filter @daodao/blog-content validate --root /absolute/path/daodao-blog --mode draft
```

草稿模式只證明格式與檔案參照符合契約，不代表內容事實正確、編輯核准或已發布。發布模式預設拒絕缺核准證據或 digest 不符的內容；具體 CLI 參數以共用套件 README 為準。核准紀錄只用來綁定已審查內容，不能替代 Git 權限與人工核准流程。

目前確認的 CTA target 是 `beta-interest`，連到 https://tally.so/r/44WXdk 燈塔封測意願表。Demo 由團隊後續安排，這不是即時預約表。其他直接操作入口尚未驗證，不在此宣稱可用。

## 舊站遷移狀態

舊 Notion/Next.js 程式暫留，待 Hosting 綁定及既有 PR 順序查核完成再清除。新資料不會被舊站自動載入。此分支沒有部署、網域切換、Git 歷史重寫或正式文章發布。
