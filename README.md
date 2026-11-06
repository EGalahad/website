# Documentation hub

Clones and builds the public main branches of EGalahad/personal_website, EGalahad/sim2real and EGalahad/boltrt into one static haoyangweng.pages.dev deployment. Source code stays in the original repositories. The personal_website-dist repository is no longer used.

## Cloudflare Pages settings

| Setting | Value |
| --- | --- |
| Project name | haoyangweng |
| Production branch | main |
| Root directory | repository root |
| Connected repository | EGalahad/website |
| Build command | `bash scripts/build-pages.sh` |
| Build output directory | site-dist |
| Environment variable | NODE_VERSION=20 |

The build exports DOCS_SITE_URL=https://haoyangweng.pages.dev. Both Docusaurus configurations use this for canonical URLs while retaining /sim2real/ and /boltrt/ as base paths. No Pages Functions or paid Workers plan is needed.

Run `bash scripts/build-pages.sh` locally with Node.js 20 or later. All three builds must succeed before the output is replaced. Source commit hashes appear in the build log. Generated files are checked against Pages Free file-size and file-count limits.

The personal_website Vite output supplies the root homepage, assets and blog. Docusaurus output is added under /sim2real/ and /boltrt/.

## Automatic updates

Changes to website trigger Cloudflare's Git integration. Repository webhooks in personal_website, sim2real and boltrt send push events directly to the production Deploy Hook. GitHub Actions is not required. The hook URL is stored in repository webhook settings, never in source code.

GitHub push webhooks cover all branches and all files. A push triggers a rebuild of the latest main branches; pushing a feature branch does not publish that branch. These rebuilds count against the shared Pages Free limit of 500 builds per month.

Every deployment builds all three sites. Failed builds leave the previous production deployment intact. Use the Cloudflare dashboard for rollbacks.

## Migration

Keep the original GitHub Pages sites live until the new subdirectories pass verification. Update links and replace old deployment workflows after the production deployment succeeds. Preserve old URLs with a static redirect site where needed.
