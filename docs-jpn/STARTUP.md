# Open WebUI Docker開発環境セットアップガイド

このガイドでは、Docker Composeを使用してOpen WebUIの開発環境を立ち上げて、すぐに開発を開始できる状態にするための詳細な手順を説明します。

## 📋 前提条件

### 必要なソフトウェア

| ソフトウェア | バージョン | 用途 |
|-------------|-----------|------|
| **Docker** | 最新版 | コンテナランタイム |
| **Docker Compose** | v2.0以上 | マルチコンテナ管理 |
| **Git** | 最新版 | バージョン管理 |

---

## 🚀 クイックスタート

### 1. リポジトリのクローン

```bash
# GitHubからクローン
git clone https://github.com/open-webui/open-webui.git
cd open-webui

# 開発ブランチに切り替え（最新機能を試したい場合）
# git checkout dev
```

### 2. 環境変数ファイルの準備

```bash
# 開発用環境変数ファイルを確認・編集
cp .env.dev.example .env.dev  # 存在しない場合
vim .env.dev  # 必要に応じて設定を調整
```

### 3. Docker開発環境の起動

```bash
# 基本開発環境（SQLite + Ollama）
docker compose -f docker-compose.dev.yaml up -d

# 初回ビルド完了まで待機（2-3分）
docker compose -f docker-compose.dev.yaml logs -f

# サービス状態確認
docker compose -f docker-compose.dev.yaml ps
```

### 4. 動作確認

1. **フロントエンド**: http://localhost:5173 にアクセス
2. **バックエンドAPI**: http://localhost:8080/docs でSwagger UIを確認
3. **初回ユーザー登録**: WebUIで管理者アカウントを作成

---

## 🐳 Docker開発環境（推奨手順）

### Docker Compose開発環境の概要

**docker-compose.dev.yaml**を使用した統合開発環境を構築できます：

```yaml
# docker-compose.dev.yamlの構成
services:
  ollama:                    # ローカルLLMサーバー（ポート11434）
  open-webui:               # 統合開発サーバー（ホットリロード対応）
    build: 
      dockerfile: Dockerfile.dev.simple  # 開発用Dockerfile
    ports: 
      - "8080:8080"         # バックエンドAPI
      - "5173:5173"         # フロントエンド開発サーバー
    volumes:                # ソースコードマウント（ホットリロード用）
```

**開発環境の特徴**:
- ✅ **ホットリロード**: ソースコード変更時に自動リロード
- ✅ **分離構成**: フロントエンド（5173）とバックエンド（8080）が独立
- ✅ **Ollama統合**: ローカルLLMサーバーが自動起動
- ✅ **環境分離**: コンテナ内で完結、クリーンな環境

#### 🚀 開発用Docker環境の起動

```bash
# 基本開発環境（SQLite + Ollama）
docker compose -f docker-compose.dev.yaml up -d

# PostgreSQL + Redis付き開発環境
docker compose -f docker-compose.dev.yaml --profile postgres --profile redis up -d

# フォアグラウンドで起動（ログ表示）
docker compose -f docker-compose.dev.yaml up

# 再ビルドして起動
docker compose -f docker-compose.dev.yaml up --build -d
```

#### 💻 開発時によく使うコマンド

**基本操作**:
```bash
# 環境の起動
docker compose -f docker-compose.dev.yaml up -d

# 環境の停止
docker compose -f docker-compose.dev.yaml down

# 環境の再起動
docker compose -f docker-compose.dev.yaml restart

# 特定サービスの再起動
docker compose -f docker-compose.dev.yaml restart open-webui

# 完全な再起動（ボリューム含む）
docker compose -f docker-compose.dev.yaml down -v
docker compose -f docker-compose.dev.yaml up -d
```

**ログとステータス確認**:
```bash
# 全サービスの状態確認
docker compose -f docker-compose.dev.yaml ps

# ログの表示（全サービス）
docker compose -f docker-compose.dev.yaml logs -f

# 特定サービスのログ
docker compose -f docker-compose.dev.yaml logs -f open-webui
docker compose -f docker-compose.dev.yaml logs -f ollama

# 最新20行のログのみ表示
docker compose -f docker-compose.dev.yaml logs --tail 20 open-webui
```

**開発作業中のコマンド**:
```bash
# コンテナ内でコマンド実行
docker compose -f docker-compose.dev.yaml exec open-webui bash

# 環境変数の確認
docker compose -f docker-compose.dev.yaml exec open-webui env | grep ENABLE

# データベースアクセス（SQLite）
docker compose -f docker-compose.dev.yaml exec open-webui sqlite3 /app/backend/data/webui.db

# Python依存関係の追加
docker compose -f docker-compose.dev.yaml exec open-webui pip install package_name

# Node.js依存関係の追加
docker compose -f docker-compose.dev.yaml exec open-webui npm install package_name
```

**Ollamaモデル管理**:
```bash
# インストール済みモデル一覧
docker compose -f docker-compose.dev.yaml exec ollama ollama list

# 新しいモデルのインストール
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:1b

# モデルのテスト実行
docker compose -f docker-compose.dev.yaml exec ollama ollama run gemma3:1b "Hello, how are you?"

# モデルの削除
docker compose -f docker-compose.dev.yaml exec ollama ollama rm model_name
```

**問題解決時のコマンド**:
```bash
# システム全体の再ビルド
docker compose -f docker-compose.dev.yaml build --no-cache
docker compose -f docker-compose.dev.yaml up -d

# ボリュームも含めた完全リセット
docker compose -f docker-compose.dev.yaml down -v --rmi all
docker compose -f docker-compose.dev.yaml up --build -d

# Dockerシステムのクリーンアップ
docker system prune -f

# 特定サービスのみ再ビルド
docker compose -f docker-compose.dev.yaml build --no-cache open-webui
docker compose -f docker-compose.dev.yaml up -d open-webui
```

**ヘルスチェックとテスト**:
```bash
# API接続確認
curl http://localhost:8080/health

# フロントエンド接続確認
curl -I http://localhost:5173

# Ollama接続確認
curl http://localhost:11434/api/tags

# WebSocket設定確認
curl -s http://localhost:8080/api/config | jq .features.enable_websocket
```

#### 📊 開発環境の構成

| サービス | ポート | 用途 | ホットリロード |
|---------|--------|------|---------------|
| **open-webui** | 5173, 8080 | 統合開発サーバー | ✅ 有効 |
| **ollama** | 11434 | ローカルLLM | - |
| **postgres** | 5432 | データベース（オプション） | - |
| **redis** | 6379 | キャッシュ（オプション） | - |

#### 📍 アクセス方法

**開発時のアクセス先**:
- **メインWebUI**: http://localhost:5173 （👈 開発時はこちらを使用）
- **バックエンドAPI**: http://localhost:8080/docs （Swagger UI）
- **Ollama API**: http://localhost:11434/api/tags

#### ⚙️ 重要な設定

**WebSocket/SSEエラーの解決**:
チャット時に「SyntaxError: Unexpected token 'd', "data: {"id"... is not valid JSON」エラーが発生する場合、以下の設定が有効です：

```yaml
# docker-compose.dev.yaml内の環境変数
environment:
  - ENABLE_WEBSOCKET_SUPPORT=false  # WebSocketを無効化してSSEの競合を回避
```

この設定により：
- ✅ WebSocketとSSEストリーミングの競合が解決される
- ✅ nginx使用時も同様の問題が解決される
- ✅ フロントエンドコードの修正は不要

**推奨環境変数**:
```bash
# 開発環境での推奨設定
ENV=dev
ENABLE_WEBSOCKET_SUPPORT=false
CORS_ALLOW_ORIGIN=*
GLOBAL_LOG_LEVEL=DEBUG
DEFAULT_LOCALE=ja
```

#### 🔧 開発環境の特徴

**ホットリロード対応**:
- **フロントエンド**: ファイル変更時に自動リロード
- **バックエンド**: Pythonファイル変更時に自動再起動
- **設定変更**: 環境変数変更時も自動反映

**ボリュームマウント**:
```yaml
# ソースコードの直接マウント
volumes:
  - ./backend:/app/backend        # バックエンドソース
  - .:/app                        # フロントエンドソース
  - /app/node_modules             # node_modules除外
```

#### 📝 開発用Docker環境の使用手順

**1. 環境変数ファイルの準備**
```bash
# 開発用環境変数ファイルを確認・編集
cp .env.dev.example .env.dev  # 存在しない場合
vim .env.dev  # 必要に応じて設定を調整

# 主要な設定項目
# - OPENAI_API_KEY: OpenAI APIキー（必要に応じて）
# - DATABASE_URL: データベース接続先
# - OLLAMA_BASE_URL: Ollama接続先（Docker用に自動設定）
```

**2. 初回セットアップ**
```bash
# 開発用環境起動
docker-compose -f docker-compose.dev.yaml up -d

# 初回ビルド完了まで待機（2-3分）
docker-compose -f docker-compose.dev.yaml logs -f

# サービス状態確認
docker-compose -f docker-compose.dev.yaml ps
```

**2. 開発作業**
```bash
# アクセス先
# フロントエンド: http://localhost:5173
# バックエンドAPI: http://localhost:8080/docs
# Ollama: http://localhost:11434

# ログ監視
docker-compose -f docker-compose.dev.yaml logs -f backend
docker-compose -f docker-compose.dev.yaml logs -f frontend

# 特定サービス再起動
docker-compose -f docker-compose.dev.yaml restart backend
```

**3. データベース操作**
```bash
# SQLite（デフォルト）
docker-compose -f docker-compose.dev.yaml exec backend \
  sqlite3 /app/backend/data/webui.db

# PostgreSQL使用時
docker-compose -f docker-compose.dev.yaml --profile postgres exec postgres \
  psql -U openwebui -d openwebui
```

**4. 依存関係の更新**
```bash
# Python依存関係更新
docker-compose -f docker-compose.dev.yaml exec backend \
  uv pip install package_name

# Node.js依存関係更新
docker-compose -f docker-compose.dev.yaml exec frontend \
  npm install package_name

# コンテナ再ビルド（依存関係大幅変更時）
docker-compose -f docker-compose.dev.yaml build --no-cache
```

**5. 環境のクリーンアップ**
```bash
# 停止
docker-compose -f docker-compose.dev.yaml down

# ボリューム含めて削除
docker-compose -f docker-compose.dev.yaml down -v

# イメージも削除
docker-compose -f docker-compose.dev.yaml down --rmi all -v
```

#### 🐛 開発用Docker環境のトラブルシューティング

**ホットリロードが効かない場合**:
```bash
# ファイル監視設定確認
docker-compose -f docker-compose.dev.yaml exec backend \
  echo $WATCHFILES_FORCE_POLLING

docker-compose -f docker-compose.dev.yaml exec frontend \
  echo $CHOKIDAR_USEPOLLING

# サービス再起動
docker-compose -f docker-compose.dev.yaml restart backend frontend
```

**環境変数設定エラー**:
```bash
# .env.devファイルの確認
cat .env.dev

# Docker環境での設定確認
docker-compose -f docker-compose.dev.yaml config

# 環境変数の動的変更
echo "OPENAI_API_KEY=your_key_here" >> .env.dev
docker-compose -f docker-compose.dev.yaml restart backend
```

**ポート競合エラー**:
```bash
# ポート使用状況確認
lsof -i :5173  # フロントエンド
lsof -i :8080  # バックエンド
lsof -i :11434 # Ollama

# 別ポートで起動
OPEN_WEBUI_PORT=3001 docker-compose -f docker-compose.dev.yaml up -d
```

**Ollama接続エラー**:
```bash
# Ollamaサービス状態確認
docker-compose -f docker-compose.dev.yaml exec ollama ollama list

# Ollama接続テスト
docker-compose -f docker-compose.dev.yaml exec backend \
  curl http://ollama:11434/api/tags

# ローカルOllamaを使用する場合
# .env.devで OLLAMA_BASE_URL=http://host.docker.internal:11434 に変更
```

**Dockerfile構文エラー**:
```bash
# version警告の解決（既に修正済み）
# docker-compose.dev.yamlからversion: '3.8'を削除済み

# Dockerfile構文エラーの解決
# scripts/start-dev.shファイルを使用する方式に変更済み

# 完全な再ビルド
docker-compose -f docker-compose.dev.yaml build --no-cache

# キャッシュクリア
docker system prune -f
docker-compose -f docker-compose.dev.yaml up -d
```

**ビルドエラー（hatch_build.py関連）**:
```bash
# シンプルなDockerfileを使用
# docker-compose.dev.yamlは既にDockerfile.dev.simpleを使用

# 完全な再ビルド
docker-compose -f docker-compose.dev.yaml build --no-cache

# キャッシュクリア
docker system prune -f
docker-compose -f docker-compose.dev.yaml up -d
```

**npm依存関係競合エラー（ERESOLVE）**:
```bash
# TipTap依存関係競合の解決（既に修正済み）
# package.jsonでバージョンを統一済み

# legacy-peer-depsでの強制インストール
docker-compose -f docker-compose.dev.yaml exec frontend \
    npm install --legacy-peer-deps

# node_modulesクリア後再インストール
docker-compose -f docker-compose.dev.yaml exec frontend \
    sh -c "rm -rf node_modules package-lock.json && npm install --legacy-peer-deps"
```

**埋め込みエンジンエラー（Unknown embedding engine）**:
```bash
# 設定確認
docker-compose -f docker-compose.dev.yaml exec backend \
  printenv | grep RAG_EMBEDDING

# 正しい設定値（重要：空文字列でsentence-transformersを使用）
# RAG_EMBEDDING_ENGINE= (空文字列)
# RAG_RERANKING_ENGINE= (空文字列)

# 環境変数の修正
sed -i 's/RAG_EMBEDDING_ENGINE=.*/RAG_EMBEDDING_ENGINE=/' .env.dev
sed -i 's/RAG_RERANKING_ENGINE=.*/RAG_RERANKING_ENGINE=/' .env.dev
docker-compose -f docker-compose.dev.yaml restart backend
```

**フロントエンド依存関係エラー（node_modules busy）**:
```bash
# 安全なクリーンアップスクリプト使用
chmod +x scripts/clean-frontend.sh
./scripts/clean-frontend.sh

# コンテナ内でのクリーンアップ
docker-compose -f docker-compose.dev.yaml exec frontend \
  sh -c "npm cache clean --force && npm install --legacy-peer-deps"

# フロントエンドコンテナ再起動
docker-compose -f docker-compose.dev.yaml restart frontend
```

**y-protocols依存関係エラー**:
```bash
# 依存関係追加（既に修正済み）
# package.jsonにy-protocols追加済み

# 手動インストール
docker-compose -f docker-compose.dev.yaml exec frontend \
  npm install y-protocols --legacy-peer-deps

# 完全再構築（安全な方法）
docker-compose -f docker-compose.dev.yaml down
./scripts/clean-frontend.sh
docker-compose -f docker-compose.dev.yaml up -d
```

**CHANGELOG.mdファイル不足エラー**:
```bash
# ファイル存在確認
ls -la CHANGELOG.md

# Dockerfileで自動コピー（既に修正済み）
# docker-compose.dev.yamlでボリュームマウント（既に修正済み）

# 手動でファイル作成（緊急時）
echo "# Changelog\n\n## Development Version" > CHANGELOG.md
```

**JWT設定エラー（Invalid duration string）**:
```bash
# 設定確認
grep JWT_EXPIRES_IN .env.dev

# 正しい形式（単位付き）
# JWT_EXPIRES_IN=168h (時間)
# JWT_EXPIRES_IN=7d (日)
# JWT_EXPIRES_IN=1w (週)

# 設定修正
sed -i 's/JWT_EXPIRES_IN=168$/JWT_EXPIRES_IN=168h/' .env.dev
docker-compose -f docker-compose.dev.yaml restart backend

# ログイン機能テスト
curl -X POST http://localhost:8080/api/v1/auths/signin \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "test"}'
```

**完全な環境リセット（全エラー対応）**:
```bash
# 1. 完全停止・クリーンアップ
docker-compose -f docker-compose.dev.yaml down -v
docker system prune -f

# 2. 設定ファイル確認
cat .env.dev | grep -E "(RAG_EMBEDDING|RAG_RERANKING|JWT_EXPIRES_IN)"

# 3. 依存関係確認
grep -E "(y-protocols|yjs)" package.json

# 4. 完全再ビルド
docker-compose -f docker-compose.dev.yaml build --no-cache

# 5. 起動
docker-compose -f docker-compose.dev.yaml up -d

# 6. ログ監視
docker-compose -f docker-compose.dev.yaml logs -f
```

**依存関係エラー**:
```bash
# コンテナ再ビルド
docker-compose -f docker-compose.dev.yaml build --no-cache backend

# ボリューム削除して再作成
docker volume rm backend-data-dev frontend-cache-dev
docker-compose -f docker-compose.dev.yaml up -d

# requirements.txtの確認
docker-compose -f docker-compose.dev.yaml exec backend \
    pip list | grep -E "(fastapi|uvicorn|open-webui)"
```

### 開発用Dockerfileビルド（バックエンドのみ）

**backend/Dockerfile.dev** を作成:
```dockerfile
FROM python:3.11-slim-bookworm

WORKDIR /app/backend

# システム依存関係
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git build-essential pandoc gcc netcat-openbsd curl jq \
    ffmpeg libsm6 libxext6 && \
    rm -rf /var/lib/apt/lists/*

# Python依存関係
COPY requirements.txt .
RUN pip install --no-cache-dir uv && \
    uv pip install --system -r requirements.txt --no-cache-dir

# 開発用設定
ENV ENV=dev
ENV PORT=8080

EXPOSE 8080

# 開発サーバー起動（ホットリロード有効）
CMD ["python", "-m", "uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080", "--reload"]
```

### Docker開発環境の使い分け

| 用途 | 設定ファイル | 特徴 |
|------|-------------|------|
| **本番・デモ** | `docker-compose.yaml` | 統合サーバー、最適化済み |
| **開発** | `docker-compose.dev.yaml` | ホットリロード、分離構成 |
| **テスト** | 手動Docker実行 | 個別コンテナテスト |

### 推奨開発方法の比較

| 方法 | 起動時間 | ホットリロード | 環境分離 | 推奨用途 |
|------|----------|---------------|----------|----------|
| **ローカル開発** | ⚡ 高速 | ✅ 完全対応 | ❌ なし | 日常開発 |
| **Docker開発** | 🐌 中程度 | ✅ 完全対応 | ✅ 完全分離 | チーム開発・CI |
| **本番Docker** | 🐌 低速 | ❌ なし | ✅ 完全分離 | 本番確認 |

**選択指針**:
```bash
# 1. 軽量開発（日常開発・推奨）
npm run dev              # フロントエンド
open-webui serve         # バックエンド

# 2. Docker開発（チーム開発・環境統一）
docker-compose -f docker-compose.dev.yaml up -d

# 3. 本番確認（デプロイ前確認）
docker-compose up -d
```

**Docker開発環境の利点**:
- 🔒 **環境統一**: チーム全体で同じ環境
- 🐳 **分離**: ホストシステムに影響なし
- 🔄 **再現性**: 誰でも同じ環境を構築可能
- 🧪 **テスト**: 本番に近い環境でテスト
- 📦 **依存関係**: システム依存関係も含めて管理

---

## 📁 プロジェクト構造の理解

### 開発時によく使うディレクトリ

```
open-webui/
├── src/lib/components/        # UIコンポーネント開発
├── src/lib/apis/             # API通信ロジック
├── src/routes/               # ページルーティング
├── backend/open_webui/routers/ # APIエンドポイント
├── backend/open_webui/models/  # データモデル
├── backend/open_webui/utils/   # ユーティリティ関数
└── backend/open_webui/retrieval/ # RAG機能
```

### Docker開発環境関連ファイル

```
├── .env.dev                  # 開発用環境変数
├── docker-compose.dev.yaml   # 開発用Docker Compose設定
├── Dockerfile.dev.simple     # 開発用Dockerfile
├── scripts/start-dev.sh      # 開発用起動スクリプト
├── package.json              # Node.js依存関係
├── pyproject.toml            # Python依存関係
├── vite.config.ts            # Vite設定
└── tailwind.config.js        # Tailwind CSS設定
```

---

## 🤖 AIモデルの管理

### Ollamaモデルのインストール

```bash
# 軽量モデル（開発・テスト用）
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:1b      # 815MB
docker compose -f docker-compose.dev.yaml exec ollama ollama pull llama3.2:1b    # 1.3GB

# 標準モデル（本格利用）
docker compose -f docker-compose.dev.yaml exec ollama ollama pull llama3.2:3b    # 2.0GB
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:2b      # 1.6GB

# 高性能モデル（リソース豊富な環境）
docker compose -f docker-compose.dev.yaml exec ollama ollama pull llama3.1:8b    # 4.7GB
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:7b      # 4.8GB
```

### モデル管理コマンド

```bash
# インストール済みモデル一覧
docker compose -f docker-compose.dev.yaml exec ollama ollama list

# モデルのテスト実行
docker compose -f docker-compose.dev.yaml exec ollama ollama run gemma3:1b "Hello"

# モデルの削除
docker compose -f docker-compose.dev.yaml exec ollama ollama rm gemma3:1b

# Ollama接続確認
curl http://localhost:11434/api/tags
```

### Open WebUIでのモデル使用

1. **ブラウザアクセス**: http://localhost:5173
2. **ログイン**: 管理者アカウントでログイン
3. **モデル選択**: 画面上部のドロップダウンからモデル選択
4. **チャット開始**: メッセージを入力してAIと対話

### 推奨モデル

| モデル | サイズ | 用途 | 性能 |
|--------|--------|------|------|
| **gemma3:1b** | 815MB | 開発・テスト | 高速・軽量 |
| **llama3.2:1b** | 1.3GB | 軽量利用 | バランス良好 |
| **llama3.2:3b** | 2.0GB | 標準利用 | 高品質 |
| **gemma3:7b** | 4.8GB | 高性能利用 | 最高品質 |

## 🐛 チャット機能のトラブルシューティング

### SSE/JSON解析エラー（"data: {"id"... is not valid JSON"）

この問題は GitHub Discussion #11071 で報告されている既知の問題です。

```bash
# 1. 修正済みの実装確認
# - EventSourceParserStreamのフォールバック実装
# - 手動SSE解析の追加
# - エラーハンドリング強化

# 2. ストリーミング設定確認
grep ENABLE_STREAMING .env.dev

# 3. 完全再起動
docker compose -f docker-compose.dev.yaml restart

# 4. ブラウザキャッシュクリア
# Chrome: F12 → Network → "Disable cache"
# ハードリロード: Cmd+Shift+R (Mac) / Ctrl+Shift+R (Windows)

# 5. 開発者ツールでログ確認
# F12 → Console → "Manual parsed SSE data" または "Parsed SSE data" ログを確認

# 6. API直接テスト
curl -X POST http://localhost:8080/api/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "gemma3:1b", "messages": [{"role": "user", "content": "Hello"}], "stream": true}' \
  --no-buffer | head -5
```

### チャット機能が動作しない場合

```bash
# モデル確認
docker compose -f docker-compose.dev.yaml exec ollama ollama list

# Ollama接続確認
curl http://localhost:11434/api/tags

# バックエンドログ確認
docker compose -f docker-compose.dev.yaml logs backend --tail 20

# フロントエンドログ確認
docker compose -f docker-compose.dev.yaml logs frontend --tail 20
```

## 📋 クイックリファレンス

### 🚀 最も使用頻度の高いコマンド

```bash
# 🔴 環境起動・停止
docker compose -f docker-compose.dev.yaml up -d      # 開発環境起動
docker compose -f docker-compose.dev.yaml down       # 環境停止
docker compose -f docker-compose.dev.yaml restart    # 再起動

# 📊 状態確認
docker compose -f docker-compose.dev.yaml ps         # サービス状態
docker compose -f docker-compose.dev.yaml logs -f    # ログ監視

# 🤖 Ollamaモデル管理
docker compose -f docker-compose.dev.yaml exec ollama ollama list           # モデル一覧
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:1b # モデル追加

# 🔧 トラブルシューティング
docker compose -f docker-compose.dev.yaml build --no-cache  # 強制再ビルド
docker compose -f docker-compose.dev.yaml down -v          # 完全リセット
```

### 🌐 アクセスURL

| 用途 | URL | 説明 |
|------|-----|------|
| **メインWebUI** | http://localhost:5173 | 👈 開発時はこちら |
| **バックエンドAPI** | http://localhost:8080/docs | Swagger UI |
| **Ollama** | http://localhost:11434/api/tags | LLM API |

### ⚠️ よくある問題と解決策

**チャットでJSONエラーが発生する場合**:
```bash
# WebSocket無効化で解決
# docker-compose.dev.yamlにENABLE_WEBSOCKET_SUPPORT=falseが設定されていることを確認
curl -s http://localhost:8080/api/config | jq .features.enable_websocket
# → falseが返されればOK
```

**フロントエンドに接続できない場合**:
```bash
# フロントエンドサーバーの起動確認
docker compose -f docker-compose.dev.yaml logs -f open-webui | grep "ready in"
# → "VITE v5.4.19 ready in XXXms" が表示されるまで待機
```

**Ollamaにモデルがない場合**:
```bash
# 軽量モデルのインストール
docker compose -f docker-compose.dev.yaml exec ollama ollama pull gemma3:1b
```

これでDocker開発環境が完全にセットアップされ、AIモデルも利用可能になりました！
開発を楽しんでください！ 🎉