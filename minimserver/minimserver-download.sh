#!/usr/bin/env bash
# MinimServer の動的ダウンロードURLを取得し、アーカイブをダウンロードする。
#
# ライセンス条項(License terms)ページの JavaScript は、ページ側(minimworld.com/download-server.php)と
# iframe(download-iframe.php)の2か所に置かれた info 配列の断片を連結して、
# 32文字の /files/<link>/<filename> を組み立てている。同じ連結をここで再現する。
#   link = P[inf] + P[inf+2] + I[inf+2] + P[inf+4] + I[inf+4]
#   (P: ページ側の info, I: iframe側の info, inf: P と I で一致した先頭2要素のインデックス)
#
# 注意: ライセンス条項への同意が前提。アドオンの accept_eula オプションで
# 利用者が条項を読んで同意したことを確認する(未同意なら run.sh が起動しない)。
#
# 使い方: minimserver-download.sh [-o 出力ディレクトリ] [-u] [ダウンロード種別]
#   -u  URL を表示するだけでダウンロードしない
#   種別の既定値は linux_x64_server (arm64 は linux_arm64_server)
set -euo pipefail

BASE="https://minimworld.com"
OUTDIR="."
URL_ONLY=0
while getopts "o:u" opt; do
  case "$opt" in
    o) OUTDIR="$OPTARG" ;;
    u) URL_ONLY=1 ;;
    *) exit 2 ;;
  esac
done
shift $((OPTIND - 1))
KIND="${1:-linux_x64_server}"

fetch() { curl -fsSL --retry 3 "$@"; }
# "var info = ['a','b',...]" から要素を空白区切りで取り出す
info_of() { grep -o "var info = \[[^]]*\]" | grep -o "'[0-9a-f]*'" | tr -d "'" | tr '\n' ' '; }

page="$(fetch "${BASE}/download-server.php?download=${KIND}&action=Install&package=minimserver")"
frame="$(fetch "${BASE}/download-iframe.php")"
read -r -a P <<<"$(info_of <<<"$page")"
read -r -a I <<<"$(info_of <<<"$frame")"
[ "${#P[@]}" -eq 6 ] && [ "${#I[@]}" -eq 6 ] || { echo "info 配列を取得できません(ページ構造が変わった可能性)" >&2; exit 1; }

# ページ側が iframe に送る先頭2要素のどちらが iframe 側の info[0] / info[1] と一致するかで inf が決まる
inf=""
for n in 0 1; do
  if [ "${P[0]}" = "${I[$n]}" ] || [ "${P[1]}" = "${I[$n]}" ]; then inf=$n; break; fi
done
[ -n "$inf" ] || { echo "iframe との同期に失敗(Download link error 2 相当)" >&2; exit 1; }
# 一致した値は P 側にも存在する。ページ側のインデックスを求める
pinf=$inf
[ "${P[$inf]}" = "${I[$inf]}" ] || pinf=$((1 - inf))
link="${P[$pinf]}${P[$((pinf + 2))]}${I[$((inf + 2))]}${P[$((pinf + 4))]}${I[$((inf + 4))]}"
[ "${#link}" -eq 32 ] || { echo "リンク長が不正: ${link}" >&2; exit 1; }

# 種別 -> ファイル名は filenames.js の連想配列から引く
filenames_js="$(fetch "${BASE}/$(grep -o 'filenames.js?m=[0-9]*' <<<"$page" | head -1)")"
filename="$(sed -n "/^var filenames/,/^};/p" <<<"$filenames_js" \
  | sed -n "s/^ *${KIND}: *'\([^']*\)'.*/\1/p" | head -1)"
[ -n "$filename" ] || { echo "種別 ${KIND} のファイル名が見つかりません" >&2; exit 1; }

url="${BASE}/files/${link}/${filename}"
if [ "$URL_ONLY" -eq 1 ]; then
  echo "$url"
  exit 0
fi

mkdir -p "$OUTDIR"
curl -fsSL --retry 3 -o "${OUTDIR}/${filename}" "$url"
echo "$url"
sha256sum "${OUTDIR}/${filename}"
