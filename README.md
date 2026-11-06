# Documentation hub

Builds the public main branches of EGalahad/sim2real and EGalahad/boltrt into the existing haoyangweng.pages.dev deployment. Source code stays in the original repositories. The homepage, assets and blog are preserved from the existing personal_website-dist checkout.

## Cloudflare Pages settings

| Setting | Value |
| --- | --- |
| Project name | haoyangweng |
| Production branch | main |
| Root directory | repository root |
| Connected repository | EGalahad/personal_website-dist (existing integration) |
| Build command | `git clone --depth 1 https://github.com/EGalahad/website.git ../docs-hub && PAGES_HOME_DIR="$PWD" bash ../docs-hub/scripts/build-pages.sh` |
| Build output directory | site-dist |
| Environment variable | NODE_VERSION=20 |

The build exports DOCS_SITE_URL=https://haoyangweng.pages.dev. Both Docusaurus configurations use this for canonical URLs while retaining /sim2real/ and /boltrt/ as base paths. No Pages Functions or paid Workers plan is needed.

Run `PAGES_HOME_DIR=/path/to/personal_website-dist bash scripts/build-pages.sh` locally with Node.js 20 or later. Both builds must succeed before the output is replaced. Source commit hashes appear in the build log. Generated files are checked against Pages Free file-size and file-count limits.

## Automatic updates

Personal homepage deployments trigger the existing Cloudflare Git integration. Create a production Deploy Hook for main in the Pages project settings. Save its URL as the GitHub Actions secret CLOUDFLARE_PAGES_DEPLOY_HOOK in this repository and both documentation repositories. Workflows call the hook after relevant changes. Never commit or print the hook URL.

Every deployment builds both sites. Failed builds leave the previous production deployment intact. Use the Cloudflare dashboard for rollbacks.

## Migration

Keep the original GitHub Pages sites live until the new subdirectories pass verification. Update links and replace old deployment workflows after the production deployment succeeds. Preserve old URLs with a static redirect site where needed.
