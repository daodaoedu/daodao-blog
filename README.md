# DaoDao Blog content

純內容分支：雙語文章位於 articles/zh-tw/、articles/en/，共用stable id；authors.json、topics.json和images/提供作者、主題及可選圖片。Git歷史完整保留，沒有repo刪除或historyrewrite。欄位及validator唯一權威位於daodao-f2e/packages/blog-content。

現有範例仍是未經人工核准的格式草稿，不因進入此分支而可公開發布。核准與私人研究紀錄不放內容庫。

## 合併前必要條件

**不可直接合併此純內容轉換。** Cloudflare Pages daodao-blog仍綁main正式部署與所有branch預覽，舊buildcommand指向Next/Notion。必須先完成Hosting切換策略、停用舊Git builds並回讀正式/preview設定；本PR沒有更改外部設定。舊Dependabot7張PR的package/yarn.lock升級於純內容架構不適用，由維護者於切換時處理，未擅自關閉。

## 驗證與觸發

content-contract.yml使用已審查的固定f2eSHA執行同一validator。PR為draft格式檢查，不代表人工核准；main內容更新後以專用BLOG_FRONTEND_DISPATCH_TOKEN依保護的BLOG_FRONTEND_REF（首次核准開發測試為dev、正式pin流程為prod）觸發f2e的blog-release.yml，傳完整content SHA。缺token就停止，不假稱發布。此repo目前尚無該secret；未自行建立或驗證crossrepo dispatch。

實際發布仍需f2e保護的frontend pin、私人approval evidence、前次baseline與已驗證的development deployment adapter。固定雙SHA、build、deploy、smoke和rollback各自記錄；不走force-deploy、不觸發product。詳細CLI/設定見f2e docs/blog/releases.md。
