#!/usr/bin/env bash
# GitHub 推送自动选路脚本（国内网络时好时坏时用）
# 用法: ./push.sh ["可选提交说明"]
# 逻辑: 依次探测 直连 / 常见本地代理端口，用第一个能连上 github.com 的通道执行 git push。
# 全部不通时打印诊断信息退出，不会反复无效重试。

set -u
cd "$(dirname "$0")" || exit 1

# 候选通道：先直连，再常见代理端口（Clash 7897/7890、v2ray 10809/10808、系统代理等）
CANDIDATES=(
  "direct|"
  "clash-7897|http://127.0.0.1:7897"
  "clash-7890|http://127.0.0.1:7890"
  "v2ray-10809|http://127.0.0.1:10809"
  "v2ray-10808|socks5://127.0.0.1:10808"
  "env-54158|http://127.0.0.1:54158"
)

probe() { # $1=proxy url (空=直连)  成功返回 0
  local p="$1" code
  if [ -z "$p" ]; then
    code=$(env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY \
      curl -s -o /dev/null -w '%{http_code}' --max-time 6 https://github.com 2>/dev/null)
  else
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 6 -x "$p" https://github.com 2>/dev/null)
  fi
  case "$code" in 200|301|302) return 0;; *) return 1;; esac
}

if [ $# -gt 0 ]; then
  git add -A | grep -v '^$' >/dev/null 2>&1
  git commit -m "$1" 2>/dev/null || echo "[info] 无改动可提交"
fi

for entry in "${CANDIDATES[@]}"; do
  name="${entry%%|*}"; proxy="${entry#*|}"
  printf '[probe] %-14s' "$name"
  if probe "$proxy"; then
    echo " OK -> pushing via $name"
    if [ -z "$proxy" ]; then
      env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY git push && { echo '[done] 推送成功（直连）'; exit 0; }
    else
      # socks5 需要给 git 用 sock5h 语法，curl 探测可用即转发
      GIT_PROXY="$proxy"
      http_proxy="$GIT_PROXY" https_proxy="$GIT_PROXY" HTTP_PROXY="$GIT_PROXY" HTTPS_PROXY="$GIT_PROXY" ALL_PROXY="$GIT_PROXY" \
        git push && { echo "[done] 推送成功（$name）"; exit 0; }
    fi
    echo "[warn] $name 探测通过但推送失败，换下一条"
  else
    echo " 不可用"
  fi
done

echo ''
echo '[fail] 所有通道都不通。建议依次排查：'
echo '  1) 代理软件是否在运行（Clash 端口 7897、v2ray 10809），必要时切节点或开 TUN 模式；'
echo '  2) curl -I https://github.com 直连是否 200；'
echo '  3) 换网络（手机热点）后重试；'
echo '  4) 只读场景可用镜像: https://gh-proxy.com/https://github.com/... 或 https://bgithub.xyz'
exit 1
