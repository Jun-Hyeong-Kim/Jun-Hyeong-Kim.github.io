#!/usr/bin/env bash
# 로컬 미리보기. 파일을 저장하면 자동으로 다시 빌드됩니다 (브라우저에서 새로고침).
#   bash run_server.sh          -> http://127.0.0.1:4000
#   bash run_server.sh 4001     -> 포트 지정
#
# jekyll 3.9 내장 서버는 webrick 1.8 에서 500 이 나서, 빌드 감시와 정적 서버를 분리했습니다.
set -e

PORT="${1:-4000}"

source "$HOME/miniconda3/etc/profile.d/conda.sh"
conda activate jekyll

cleanup(){ kill "$BUILD_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM

ruby "$CONDA_PREFIX/share/rubygems/bin/bundle" exec jekyll build --watch --quiet &
BUILD_PID=$!

until [ -f _site/index.html ]; do sleep 1; done
echo "-> http://127.0.0.1:${PORT}   (Ctrl+C to stop)"
exec python3 -m http.server "$PORT" --bind 127.0.0.1 --directory _site
