#!/bin/bash
# 品牌域名门禁: 我们并不拥有 linxira.org / wiki.linxira.org。
set -euo pipefail
fail=0
if grep -q 'linxira\.org' linxira-branding; then
  echo "branding references linxira.org (not owned):"
  grep -n 'linxira\.org' linxira-branding
  fail=1
fi
grep -q 'HOME_URL="https://github.com/Linxira-OS"' linxira-branding || {
  echo "HOME_URL must be the GitHub organisation page"; fail=1; }
grep -q 'DOCUMENTATION_URL="https://linxira-os.github.io"' linxira-branding || {
  echo "DOCUMENTATION_URL must be the project site"; fail=1; }
grep -q 'BUG_REPORT_URL="https://github.com/Linxira-OS/linxira-os/issues"' linxira-branding || {
  echo "BUG_REPORT_URL must point at the maintained repository"; fail=1; }
exit "$fail"
