# 注意事項

- **開発環境向け:**  
  本ツールは、開発環境の迅速なテスト・確認を目的としており、Laravel のマイグレーション実行時に `php artisan migrate:fresh --force` が自動的に呼び出されます。これにより、既存のデータベースがリフレッシュされ、常にクリーンな状態でテストが行われます。

- **本番環境でのご利用について:**  
  本番環境においてはこのまま実行すると、既存のデータがすべて破棄される恐れが。。。実運用時には、`php artisan migrate --force` を用いて、必要なスキーマ変更のみを適用するように。


# devsetup

## 概要
- **devsetup** は、Docker ベースの開発環境初期設定を自動化するための CLI ツール。  
- 対話形式のシェルスクリプトにより、初期設定作業の煩雑さや、複数の Docker コンテナ間で発生するポート競合・構成衝突の問題を解消し、すぐに開発に着手できる環境を提供するもの。

## 課題と背景
- **現状の課題:**  
  開発環境を手動で構築する際、同一作業の繰り返しにより、ポート競合やサービス構成の衝突が頻発し、作業効率が低下。
- **背景:**  
  Docker コンテナを用いた環境構築を行う中で、手動設定の煩雑さとエラーリスクを減らす必要性が高まり、本ツールを作成するに至った。

## 目的
本ツールは、下記の点を実現することを目的としている。
- 面倒な初期構築作業を自動化し、即座に開発を開始可能な状態を提供すること。
- 複数の Docker コンテナ間で発生しうるポート競合や設定衝突を簡易チェック・自動調整する機能を実装すること。
- 対話形式により柔軟かつ直感的な操作性を確保し、各種フレームワークに対応できる拡張性を持たせること。

## 主な特徴
- **対話形式のインターフェース:**  
  プロジェクト名、ディレクトリ、ポート番号、使用するフレームワークなど、必要な情報を逐一案内しながら設定を実行。
- **自動テンプレート生成:**  
  Dockerfile、docker-compose.yml、.env ファイル、そしてソースコードの初期フォルダ構造を自動生成。
- **ポート競合チェック:**  
  利用中のポート番号に対して自動的にインクリメントすることで、衝突を未然に防止。
- **拡張性:**  
  現在は PHP + nginx + MySQL + Laravel に特化しているが、将来的には Django、Symfony、Express など、必要だと思ったフレームワークおよびプラットフォームに対応可能な構造を備えている。

## メニュー構成（2025‑04-17-10:00 現在）

| 番号 | 構成テンプレート                       | 備考                             |
|----|--------------------------------|--------------------------------|
| 1  | PHP+nginx+MySQL                | 素の LEMP                        |
| 2  | PHP+nginx+MySQL+Laravel        | バージョン指定可・マイグレーション選択可           |
| 3  | PHP+nginx+MySQL+Laravel+Breeze | UI 認証付き・vite ビルド自動・migrate 選択可 |
|    |                                |                                |


追加テンプレートは随時拡張予定。


## ディレクトリ構造
```
.
├── devsetup.sh
├── functions
│   ├── compose_generator.sh
│   ├── env_generator.sh
│   ├── logger.sh
│   └── port_checker.sh
├── README.md
├── scripts
│   ├── build_base.sh
│   ├── build_breeze.sh
│   └── build_laravel.sh
└── templates
    └── php-nginx-mysql
        ├── docker
        │   ├── nginx
        │   │   └── default.conf
        │   └── php
        │       └── Dockerfile
        └── docker-compose.yml.template
```

## ∞フレームワーク適用後のディレクトリ構成案（改訂版）
```
devsetup/
├── bin/
│   └── devsetup.sh                     # フレームワークを起動するエントリポイント
│
├── config/
│   ├── default.conf                    # モジュールのデフォルト有効設定
│   └── user.conf                       # ユーザー設定（対話式で上書き可能）
│
├── framework/
│   ├── core.sh                         # run_phase等のライフサイクル制御
│   ├── loader.sh                       # モジュール検出 & 設定読み込み
│   └── logger.sh                       # 色付きログ出力＋タイムスタンプ
│
├── modules/
│   ├── menu/
│   │   └── init.sh                     # 最初に表示されるメニュー（既存のままでOK）
│   │
│   ├── docker/
│   │   ├── init.sh                     # テンプレートコピーなど初期化処理
│   │   ├── configure.sh                # ポート・DB等の設定
│   │   └── execute.sh                  # docker-compose 実行
│   │
│   ├── laravel/
│   │   ├── init.sh                     # Laravel 新規プロジェクト作成
│   │   ├── configure.sh                # .env 設定など
│   │   └── execute.sh                  # migrate などの実行
│   │
│   ├── breeze/
│   │   ├── init.sh                     # Breeze インストール
│   │   └── execute.sh                  # npm install 等
│   │
│   └── cleanup/
│       └── execute.sh                  # 一時ファイル削除・サマリー出力
│
├── templates/
│   └── php-nginx-mysql/
│       ├── docker/
│       │   ├── nginx/
│       │   │   └── default.conf        # nginx 設定テンプレート
│       │   └── php/
│       │       └── Dockerfile          # PHP Dockerfile
│       └── docker-compose.yml.template # Docker Compose テンプレート
│
├── README.md                           # 説明ファイル（そのままでOK）
└── .gitignore                          # 設定除外リスト（任意）

```


## 使い方
1. 必要な実行権限を全ての.shに付与。
```
chmod +x ~
```
2. 実行
```
./devsetup.sh
```
3. 後は実行すれば分かる。

## 必要環境および依存関係
- **Docker** および **Docker Compose**
- **Bash** 
- **envsubst**

## 今後の予定
- **機能拡張:**  
  複数のフレームワーク対応。
- **コマンドの簡素化:**  
  Makefile もしくは CLI オプションの追加による操作性向上。
- **GitHub 連携:**  
  プロジェクトの自動バージョン管理および CI/CD パイプラインの構築。
- **テスト自動化:**  
  各種テストの自動化による品質保証。
