#!/bin/bash
set -e

echo "Starting Open WebUI development server..."
echo "Python path: $PYTHONPATH"
echo "Working directory: $(pwd)"

# 環境変数の確認
echo "Environment variables:"
echo "  ENV: $ENV"
echo "  PORT: $PORT"
echo "  WEBUI_SECRET_KEY: ${WEBUI_SECRET_KEY:0:10}..."

# 必要なディレクトリの作成
mkdir -p /app/backend/data/cache/embedding/models
mkdir -p /app/backend/data/cache/whisper/models
mkdir -p /app/backend/data/cache/tiktoken
mkdir -p /app/backend/data/logs

# フロントエンド依存関係のインストール
echo "Checking frontend dependencies..."
cd /app
if [ ! -d "/app/node_modules" ] || [ ! -d "/app/node_modules/pyodide" ]; then
    echo "Installing frontend dependencies with legacy peer deps..."
    npm install --legacy-peer-deps
else
    echo "Dependencies already installed"
fi

# バックエンドディレクトリに移動
cd /app/backend

# データベースの初期化（必要に応じて）
if [ ! -f "/app/backend/data/webui.db" ]; then
    echo "Initializing database..."
    python -c "
from open_webui.apps.webui.internal.db import init_db
init_db()
print('Database initialized successfully')
"
fi

# フロントエンド開発サーバーをバックグラウンドで起動
echo "Starting frontend development server..."
cd /app

# フロントエンド開発サーバー起動
echo "Starting SvelteKit development server..."
# pyodideの準備を先に実行
npm run pyodide:fetch

# SvelteKitの開発サーバーを起動
npm run dev -- --host 0.0.0.0 --port 5173 &
FRONTEND_PID=$!

# バックエンド開発サーバー起動（ホットリロード有効）
echo "Starting backend development server..."
cd /app/backend

# シグナルハンドラー設定（Ctrl+Cでフロントエンドも終了）
trap "echo 'Stopping servers...'; kill $FRONTEND_PID 2>/dev/null || true; exit 0" SIGTERM SIGINT

python -m uvicorn open_webui.main:app \
    --host 0.0.0.0 \
    --port 8080 \
    --reload \
    --reload-dir /app/backend \
    --log-level debug &
BACKEND_PID=$!

# 両方のプロセスを待機
wait $BACKEND_PID