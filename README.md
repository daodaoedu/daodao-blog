# DaoDao Blog content

This repository supplies bilingual Markdown to `daodao-f2e/apps/website`. After this migration, it no longer builds a standalone Notion/Next.js application. Git history is preserved. Paired articles live in `articles/zh-tw/` and `articles/en/`, with matching stable IDs; `authors.json`, `topics.json` and optional `images/` provide public dependencies. The only schema and validator are in the selected frontend's `packages/blog-content`.

## Write, review and publish

1. Prepare complete zh-TW and English drafts, then an isolated content branch and PR when review preparation is authorized. Run the shared validator in draft mode. An open PR or passing validator is not editorial approval.
2. Supply both rendered article URLs as part of the review handoff. An ordinary preview uses an explicit immutable content commit. Keep private research and approval evidence outside this public repository. Shared dev is publicly reachable; noindex is not privacy protection.
3. Revise the same PR, rebuild and verify its preview, and record the current content version. The user approves that exact bilingual version before public release. Preserve historical IDs, slugs and original publication dates.
4. After authorized merge, verify the merged article/dependency digest matches the reviewed version. A merge alone does not deploy Website. Follow the production operator process below and verify the actual public result.

The current `blog-dev-bootstrap.yml` / `publication-test` operation includes synthetic engineering fixtures and deliberate failure/retry/rollback tests. It is not a routine per-PR preview service. Do not run that entire matrix or bypass managed ownership merely to obtain a draft preview. If no authorized ordinary preview route is available, report the exact missing capability and keep rendered preview blocked. This document and plugin instructions do not provision automatic previews.

## Validation and release ownership

`content-contract.yml` validates PRs and main pushes in draft mode using the reviewed pinned shared validator. Source-aware CodeQL continues to scan actual tracked languages. Neither workflow is editorial approval.

Automatic cross-repository publication was explicitly deferred in [#536 acceptance](https://github.com/daodaoedu/daodao/issues/536#issuecomment-6888528875). The obsolete main-push job calling `blog-release.yml` has been removed: it depended on an unconfigured dispatch token and does not select the current managed production publisher. Automatic PR previews and content-to-production dispatch are not installed by this change. Do not add placeholder credentials or use an all-app/force deploy to compensate.

For production, an authorized operator inspects `blog-prod-publish.yml` and `docs/blog/production-publication.md` at the current official frontend `prod` commit. Read the live JSON marker; preserve existing content and approvals; validate the intended complete content set in publish mode; prepare the protected target/baseline/approval variables. Dispatch that workflow on `prod` with `ci_run_id` identifying a successful canonical Linode CI run for that exact current prod commit. Ordinary publication uses `legacy_bootstrap=false`. Freeze inputs, honor existing queue/ownership guards, and verify the live bilingual content, images and marker. The publisher deploys Website only; content changes must not build or recreate Product.

Keep raw approvals and secrets outside this repository. Required settings are maintainer operations, not values supplied by an article or PR. Missing host Actions/variable capabilities require an exact operator handoff rather than a fictitious completed release.

## Migration evidence and remaining gates

The following historical receipts do not replace checking current settings:

- [#536 acceptance](https://github.com/daodaoedu/daodao/issues/536#issuecomment-6888528875) covers manual dev publication and failure/retry/stale/paired rollback. Cross-repo automation was deferred.
- [#539 PM approval](https://github.com/daodaoedu/daodao/issues/539#issuecomment-6893854188) covers the actual bilingual `learning-group-weekly-review` article. It does not approve the format-only samples in migration PR #9 or any new/modified article.
- [First managed production run45022473953](https://github.com/daodaoedu/daodao-f2e/actions/runs/45022473953) published frontend `59eb476f9a5e0bb49aa07b5400ac1cc0e491ca36` and content `0daa4231bb2072657c807813e960919b982f9d8e`; the original cutover completed. Normal success did not exercise production rollback.
- Cloudflare legacy automatic Git builds were previously paused while retaining the old artifact, as recorded in [the scanning transition guide](docs/codeql-transition.md). Before merging this migration, a maintainer must recheck the actual production and branch-preview settings remain paused. Historical failed Cloudflare checks on #10 are old standalone-app builds; do not recreate that obsolete application merely to make them green.
- Preserve source-aware CodeQL during #9/#10 integration. The prior transition changed default setup to `not-configured` and enabled advanced uploads; verify current settings and the merged main analysis. Do not disable scanning or dismiss existing alerts to make migration pass.

Legacy Dependabot package/yarn.lock PRs belong to the retired application. Recheck their applicability after migration; this repair does not close them or dismiss their alerts.

PR #10 is stacked on #9's branch. Integrate both reviewed trees without dropping later CodeQL changes and verify the approved article bytes remain unchanged. The old full publisher PR `daodao-f2e#1199` has a separate scope; do not merge it or declare all original requirements complete merely because this narrow route works. PR descriptions and local green checks alone do not clear remaining migration gates.
