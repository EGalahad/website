#!/usr/bin/env bash
set -euo pipefail

website_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_workspace="$(mktemp -d)"
trap 'rm -rf "$build_workspace"' EXIT

export DOCS_SITE_URL="${DOCS_SITE_URL:-https://haoyangweng.pages.dev}"
mkdir -p "$build_workspace/site"
git clone --depth 1 --branch main --single-branch \
  https://github.com/EGalahad/personal_website.git "$build_workspace/personal_website"
git -C "$build_workspace/personal_website" rev-parse HEAD
(
  cd "$build_workspace/personal_website"
  npm ci --no-audit --no-fund
  npm run build
)
cp -a "$build_workspace/personal_website/dist/." "$build_workspace/site/"
cp -a "$website_root/static/." "$build_workspace/site/"

for project in sim2real boltrt; do
  git clone --depth 1 --branch main --single-branch \
    "https://github.com/EGalahad/$project.git" "$build_workspace/$project"
  git -C "$build_workspace/$project" rev-parse HEAD
  (
    cd "$build_workspace/$project/docs"
    npm ci --no-audit --no-fund
    npm run build
  )
  mkdir -p "$build_workspace/site/$project"
  cp -a "$build_workspace/$project/docs/build/." "$build_workspace/site/$project/"
done

if find "$build_workspace/site" -type f -size +26214400c -print -quit | grep -q .; then
  printf '%s\n' 'A generated file exceeds the Cloudflare Pages 25 MiB limit.' >&2
  exit 1
fi

file_count="$(find "$build_workspace/site" -type f | wc -l)"
if (( file_count > 20000 )); then
  printf '%s\n' 'Generated site exceeds the Cloudflare Pages 20,000-file limit.' >&2
  exit 1
fi

rm -rf "$website_root/site-dist"
mv "$build_workspace/site" "$website_root/site-dist"
printf 'Built %s files for %s\n' "$file_count" "$DOCS_SITE_URL"
