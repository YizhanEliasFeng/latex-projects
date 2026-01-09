#!/usr/bin/env bash
set -e

kind="${1:-ctex-xe}"     # ctex-xe 或 en-xe
target="${2:-}"
depth="${3:-1}"          # 1=项目在仓库一级子目录；2=作业/hw01 这种二级目录

if [ -z "$target" ]; then
  echo "Usage: scripts/new-latex-project.sh <ctex-xe|en-xe> <target_path> [depth]"
  exit 1
fi

tmpl="templates/project-${kind}"
if [ ! -d "$tmpl" ]; then
  echo "Template not found: $tmpl"
  exit 1
fi

mkdir -p "$(dirname "$target")"
cp -R "$tmpl" "$target"

reporoot=".."
if [ "$depth" -gt 1 ]; then
  reporoot=".."
  for i in $(seq 2 "$depth"); do
    reporoot="${reporoot}/.."
  done
fi

printf '\\newcommand{\\reporoot}{%s}\n' "$reporoot" > "${target}/paths.tex"

echo "Created: $target"
echo "Next: edit ${target}/meta.tex, then compile ${target}/main.tex"