# Open WebUI 開発者向け詳細ガイド

## 1. プロジェクト概要

**Open WebUI**は、完全オフライン動作可能なセルフホスト型AIプラットフォームです。Ollama、OpenAI互換API、独自の推論エンジンをサポートし、RAG（Retrieval Augmented Generation）機能を内蔵した強力なAI展開ソリューションです。

### 主要特徴
- 🚀 **簡単セットアップ**: Docker/Kubernetes対応、hassle-freeな体験
- 🤝 **多様なAPI統合**: Ollama、OpenAI、LMStudio、GroqCloud、Mistral等
- 🛡️ **詳細な権限管理**: ユーザーグループ・ロールベースアクセス制御
- 📱 **レスポンシブ設計**: デスクトップ・モバイル対応PWA
- 🎤📹 **音声・ビデオ通話**: WebRTC統合によるハンズフリー通信
- 🛠️ **モデルビルダー**: Web UI経由でのOllamaモデル作成
- 🐍 **Pythonツール統合**: コードエディタ付きネイティブ関数呼び出し
- 📚 **ローカルRAG**: 文書統合チャット体験
- 🔍 **Web検索RAG**: 複数プロバイダー対応検索結果統合
- 🎨 **画像生成統合**: AUTOMATIC1111、ComfyUI、DALL-E対応
- 🧩 **パイプライン・プラグイン**: カスタムロジック統合フレームワーク

---

## 2. アーキテクチャ構成

```
Open WebUI
├── フロントエンド (SvelteKit + TypeScript)
│   ├── PWA対応
│   ├── WebRTC音声・ビデオ
│   └── Pyodide (ブラウザ内Python実行)
├── バックエンド (FastAPI + Python)
│   ├── WebSocket (Socket.IO)
│   ├── 認証・認可システム
│   ├── AI統合レイヤー
│   └── タスク管理システム
├── データベース層
│   ├── メインDB (SQLite/PostgreSQL)
│   ├── ベクトルDB (ChromaDB/Qdrant/Milvus/Pinecone)
│   └── キャッシュ (Redis)
└── ストレージ層
    ├── ローカルファイル
    ├── S3互換ストレージ
    └── Azure Blob Storage
```

---

## 3. 技術スタック詳細

### フロントエンド技術

| 技術 | バージョン | 用途・特徴 |
|------|-----------|-----------|
| **SvelteKit** | 2.5.20 | フルスタックフレームワーク、SSR/SPA対応 |
| **TypeScript** | 5.5.4 | 型安全性、開発効率向上 |
| **Tailwind CSS** | 4.0.0 | ユーティリティファーストCSS、高速スタイリング |
| **Vite** | 5.4.14 | 高速ビルドツール、HMR対応 |
| **TipTap** | 3.0.7 | リッチテキストエディタ、Markdown/WYSIWYG |
| **bits-ui** | 0.21.15 | アクセシブルUIコンポーネント |
| **Chart.js** | 4.5.0 | データ可視化・グラフ描画 |
| **Pyodide** | 0.27.3 | ブラウザ内Python実行環境 |
| **Socket.IO Client** | 4.2.0 | リアルタイム双方向通信 |
| **Mermaid** | 11.6.0 | 図表・フローチャート描画 |
| **KaTeX** | 0.16.22 | 数式レンダリング |
| **PDF.js** | 5.3.93 | PDF表示・操作 |
| **Leaflet** | 1.9.4 | インタラクティブ地図 |

### バックエンド技術

| 技術 | バージョン | 用途・特徴 |
|------|-----------|-----------|
| **FastAPI** | 0.115.7 | 高性能WebAPIフレームワーク、自動ドキュメント生成 |
| **Uvicorn** | 0.34.2 | ASGIサーバー、高速非同期処理 |
| **SQLAlchemy** | 2.0.38 | 高機能ORM、複雑クエリ対応 |
| **Peewee** | 3.18.1 | 軽量ORM、シンプルなDB操作 |
| **Alembic** | 1.14.0 | データベースマイグレーション |
| **python-socketio** | 5.13.0 | WebSocket双方向通信 |
| **python-jose** | 3.4.0 | JWT認証トークン処理 |
| **passlib** | 1.7.4 | パスワードハッシュ化 |
| **cryptography** | - | 暗号化・セキュリティ |
| **httpx** | 0.28.1 | 非同期HTTPクライアント |
| **aiohttp** | 3.11.11 | 非同期HTTP処理 |
| **Redis** | - | キャッシュ・セッション管理 |
| **APScheduler** | 3.10.4 | タスクスケジューリング |

### AI・ML技術スタック

| 技術 | バージョン | 用途・特徴 |
|------|-----------|-----------|
| **LangChain** | 0.3.26 | LLMワークフロー構築フレームワーク |
| **Transformers** | - | HuggingFace製、大規模言語モデル |
| **Sentence Transformers** | 4.1.0 | 文章埋め込み生成 |
| **ChromaDB** | 0.6.3 | ベクトルデータベース |
| **Qdrant Client** | 1.14.3 | 高性能ベクトル検索 |
| **Milvus** | 2.5.0 | スケーラブルベクトルDB |
| **OpenSearch** | 2.8.0 | 検索・分析エンジン |
| **Faster Whisper** | 1.1.1 | 高速音声認識 |
| **ONNX Runtime** | 1.20.1 | 機械学習推論最適化 |
| **ColBERT** | 0.2.21 | 効率的な文書検索 |
| **OpenAI** | - | GPT API統合 |
| **Anthropic** | - | Claude API統合 |
| **Google GenAI** | 1.15.0 | Gemini API統合 |

### データベース・ストレージ

| 技術 | 用途 | 特徴 |
|------|------|------|
| **SQLite** | メインDB（デフォルト） | ファイルベース、セットアップ不要 |
| **PostgreSQL** | メインDB（本番環境） | 高機能RDBMS、pgvector対応 |
| **ChromaDB** | ベクトル検索 | 軽量、埋め込み特化 |
| **Qdrant** | ベクトル検索 | 高性能、フィルタリング対応 |
| **Milvus** | ベクトル検索 | 大規模データ対応 |
| **Pinecone** | ベクトル検索 | マネージドサービス |
| **Redis** | キャッシュ・セッション | インメモリ、高速アクセス |
| **S3互換** | ファイルストレージ | AWS S3、MinIO等 |
| **Azure Blob** | ファイルストレージ | Microsoft Azure |
| **Google Cloud Storage** | ファイルストレージ | Google Cloud |

---

## 4. 詳細ディレクトリ構造

```
open-webui/
├── src/                           # フロントエンド (SvelteKit)
│   ├── lib/
│   │   ├── apis/                  # API通信層
│   │   │   ├── audio/             # 音声API
│   │   │   ├── images/            # 画像生成API
│   │   │   ├── ollama/            # Ollama統合
│   │   │   ├── openai/            # OpenAI互換API
│   │   │   └── retrieval/         # RAG・検索API
│   │   ├── components/            # UIコンポーネント
│   │   │   ├── admin/             # 管理者画面
│   │   │   ├── chat/              # チャット機能
│   │   │   ├── common/            # 共通コンポーネント
│   │   │   ├── icons/             # アイコン
│   │   │   └── workspace/         # ワークスペース
│   │   ├── i18n/                  # 国際化
│   │   │   └── locales/           # 言語ファイル
│   │   ├── stores/                # 状態管理
│   │   ├── utils/                 # ユーティリティ
│   │   └── workers/               # Web Workers
│   └── routes/                    # ページルーティング
├── backend/                       # バックエンド (FastAPI)
│   └── open_webui/
│       ├── routers/               # APIルーター
│       │   ├── audio.py           # 音声処理
│       │   ├── auths.py           # 認証
│       │   ├── chats.py           # チャット管理
│       │   ├── files.py           # ファイル管理
│       │   ├── images.py          # 画像生成
│       │   ├── models.py          # モデル管理
│       │   ├── ollama.py          # Ollama統合
│       │   ├── openai.py          # OpenAI互換
│       │   ├── retrieval.py       # RAG機能
│       │   └── users.py           # ユーザー管理
│       ├── models/                # データモデル
│       │   ├── auths.py           # 認証モデル
│       │   ├── chats.py           # チャットモデル
│       │   ├── files.py           # ファイルモデル
│       │   ├── functions.py       # 関数モデル
│       │   ├── knowledge.py       # ナレッジベース
│       │   ├── memories.py        # メモリ機能
│       │   └── users.py           # ユーザーモデル
│       ├── utils/                 # ユーティリティ
│       │   ├── auth.py            # 認証ヘルパー
│       │   ├── chat.py            # チャット処理
│       │   ├── embeddings.py      # 埋め込み生成
│       │   ├── middleware.py      # ミドルウェア
│       │   └── tools.py           # ツール統合
│       ├── retrieval/             # RAG機能
│       │   ├── loaders/           # 文書ローダー
│       │   ├── models/            # 埋め込みモデル
│       │   ├── vector/            # ベクトルDB
│       │   └── web/               # Web検索
│       ├── internal/              # 内部システム
│       │   ├── db.py              # DB接続管理
│       │   └── wrappers.py        # DB接続ラッパー
│       ├── socket/                # WebSocket
│       ├── storage/               # ストレージ抽象化
│       ├── migrations/            # DBマイグレーション
│       └── static/                # 静的ファイル
├── docs/                          # ドキュメント
├── scripts/                       # ビルド・デプロイスクリプト
├── Dockerfile                     # Docker設定
├── docker-compose.yaml            # Docker Compose設定
├── pyproject.toml                 # Python依存関係
├── package.json                   # Node.js依存関係
└── vite.config.ts                 # Vite設定
```

---

## 5. 開発環境セットアップ

### 必要な環境
- **Python**: 3.11-3.12 (3.13は未対応)
- **Node.js**: 18.13.0-22.x
- **npm**: 6.0.0以上
- **Docker**: 最新版（オプション）

### ローカル開発セットアップ

```bash
# 1. リポジトリクローン
git clone https://github.com/open-webui/open-webui.git
cd open-webui

# 2. フロントエンド依存関係インストール
npm install

# 3. バックエンド依存関係インストール
pip install -e .

# 4. 開発サーバー起動
# ターミナル1: フロントエンド
npm run dev  # http://localhost:5173

# ターミナル2: バックエンド
open-webui serve  # http://localhost:8080
```

### Docker開発環境

```bash
# 開発用Docker Compose
docker-compose up -d

# または単体Docker実行
./run.sh
```

### 環境変数設定

主要な環境変数（`.env`ファイルに設定）:

```bash
# データベース
DATABASE_URL=sqlite:///./webui.db
# DATABASE_URL=postgresql://user:pass@localhost/openwebui

# Ollama設定
OLLAMA_BASE_URL=http://localhost:11434
ENABLE_OLLAMA_API=True

# OpenAI設定
OPENAI_API_KEY=your_openai_key
OPENAI_API_BASE_URL=https://api.openai.com/v1
ENABLE_OPENAI_API=True

# 認証設定
WEBUI_AUTH=True
ENABLE_SIGNUP=True
JWT_EXPIRES_IN=168  # 時間

# RAG設定
RAG_EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2
CHUNK_SIZE=1000
CHUNK_OVERLAP=200

# Redis（オプション）
REDIS_URL=redis://localhost:6379

# ストレージ（オプション）
STORAGE_PROVIDER=local  # local, s3, azure
```

---

## 6. 開発ワークフロー

### コード品質管理

```bash
# リンティング
npm run lint              # フロントエンド
npm run lint:backend      # バックエンド
npm run lint:types        # 型チェック

# フォーマット
npm run format            # フロントエンド
npm run format:backend    # バックエンド

# 型チェック
npm run check
npm run check:watch       # 監視モード
```

### テスト実行

```bash
# フロントエンドテスト
npm run test:frontend

# E2Eテスト
npm run cy:open           # Cypress GUI
npx cypress run           # ヘッドレス実行

# バックエンドテスト
pytest backend/open_webui/test/
```

### 国際化（i18n）

```bash
# 翻訳文字列抽出・更新
npm run i18n:parse

# 翻訳ファイル場所
src/lib/i18n/locales/
├── en/
├── ja/
├── zh/
└── ...
```

### ビルド・デプロイ

```bash
# 本番ビルド
npm run build

# プレビュー
npm run preview

# Docker イメージビルド
docker build -t open-webui .

# Pyodide準備（開発時）
npm run pyodide:fetch
```

---

## 7. 主要機能の実装場所

### 認証・認可システム
- **フロントエンド**: `src/lib/apis/auths/`
- **バックエンド**: `backend/open_webui/routers/auths.py`
- **モデル**: `backend/open_webui/models/auths.py`
- **ユーティリティ**: `backend/open_webui/utils/auth.py`

### チャット機能
- **フロントエンド**: `src/lib/components/chat/`
- **バックエンド**: `backend/open_webui/routers/chats.py`
- **WebSocket**: `backend/open_webui/socket/main.py`
- **処理ロジック**: `backend/open_webui/utils/chat.py`

### RAG・検索機能
- **フロントエンド**: `src/lib/apis/retrieval/`
- **バックエンド**: `backend/open_webui/routers/retrieval.py`
- **実装**: `backend/open_webui/retrieval/`
- **ベクトルDB**: `backend/open_webui/retrieval/vector/`
- **Web検索**: `backend/open_webui/retrieval/web/`

### AI統合
- **Ollama**: `backend/open_webui/routers/ollama.py`
- **OpenAI**: `backend/open_webui/routers/openai.py`
- **画像生成**: `backend/open_webui/routers/images.py`
- **音声処理**: `backend/open_webui/routers/audio.py`

### ファイル管理
- **フロントエンド**: `src/lib/apis/files/`
- **バックエンド**: `backend/open_webui/routers/files.py`
- **ストレージ**: `backend/open_webui/storage/provider.py`

### 管理機能
- **フロントエンド**: `src/lib/components/admin/`
- **設定管理**: `backend/open_webui/routers/configs.py`
- **ユーザー管理**: `backend/open_webui/routers/users.py`
- **グループ管理**: `backend/open_webui/routers/groups.py`

---

## 8. カスタマイズ・拡張ポイント

### 新しいAIプロバイダー追加
1. `backend/open_webui/routers/`に新しいルーター作成
2. `src/lib/apis/`にフロントエンドAPI追加
3. `backend/open_webui/config.py`に設定追加

### カスタムツール・関数追加
1. `backend/open_webui/routers/tools.py`でツール登録
2. `backend/open_webui/routers/functions.py`で関数管理
3. `src/lib/components/workspace/`でUI追加

### 新しいベクトルDB統合
1. `backend/open_webui/retrieval/vector/`に実装追加
2. `backend/open_webui/config.py`で設定対応
3. 依存関係を`pyproject.toml`に追加

### UI テーマ・スタイル変更
1. `src/lib/components/common/`でコンポーネント修正
2. `src/tailwind.css`でグローバルスタイル
3. `tailwind.config.js`でテーマ設定

### 認証プロバイダー追加
1. `backend/open_webui/utils/oauth.py`でOAuth実装
2. `backend/open_webui/config.py`で設定追加
3. `src/lib/components/`でログインUI追加

---

## 9. トラブルシューティング

### よくある問題と解決方法

#### データベース接続エラー
```bash
# SQLite権限問題
chmod 664 backend/data/webui.db
chown www-data:www-data backend/data/

# PostgreSQL接続問題
# DATABASE_URLの確認、pg_hba.conf設定確認
```

#### Ollama接続問題
```bash
# ローカルOllama確認
curl http://localhost:11434/api/tags

# Docker環境での接続
# --add-host=host.docker.internal:host-gateway 追加
```

#### フロントエンドビルドエラー
```bash
# Node.js バージョン確認
node --version  # 18.13.0-22.x

# 依存関係再インストール
rm -rf node_modules package-lock.json
npm install
```

#### Python依存関係エラー
```bash
# Python バージョン確認
python --version  # 3.11-3.12

# 仮想環境作成
python -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -e .
```

---

## 10. 貢献・開発参加

### 開発ブランチ戦略
- `main`: 安定版リリース
- `dev`: 開発版（最新機能、不安定な可能性）
- `feature/*`: 機能開発ブランチ

### プルリクエスト手順
1. Issueで議論・確認
2. フォーク・ブランチ作成
3. 実装・テスト
4. リンティング・フォーマット確認
5. プルリクエスト作成

### コミュニティ
- **Discord**: [Open WebUI Discord](https://discord.gg/5rJgQTnV4s)
- **GitHub**: [Issues・Discussions](https://github.com/open-webui/open-webui)
- **ドキュメント**: [公式ドキュメント](https://docs.openwebui.com/)

---

このガイドを参考に、Open WebUIの開発・カスタマイズを効率的に進めることができます。質問や不明点があれば、コミュニティで気軽に相談してください！

