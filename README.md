<table>
<tr>
<th>モジュール</th><th>"menu"</th><th>"laravel"</th><th>"docker"</th><th>"breeze"</th><th>"oauth"</th>
</tr>
<tr>
<th>【init.sh】</th>
<th>ディレクトリ作成・モジュールを有効化＆並び替え・有効構成をログ出力</th>
<th>Laravel を Docker コンテナ内にインストールする</th>
<th>Docker の設定ファイルをプロジェクトにコピーする</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
</tr>
<tr>
<th>【configure.sh】</th>
<th>ファイルなし</th>
<th>特に処理なし</th>
<th>ポート番号を聞いて .env と docker-compose.yml を生成</th>
<th>特に処理なし</th>
<th>Laravel に Google OAuth 認証をフル自動で設定</th>
</tr>
<tr>
<th>【execute.sh】</th>
<th>ファイルなし</th>
<th>Laravel の初期化を Docker コンテナ内で実行する</th>
<th>Docker コンテナを一度止めてから、改めてビルドして起動</th>
<th>Laravel Breeze をコンテナ内でインストール＆ビルドし、ログインUIを使える状態にまで一括セットアップ</th>
<th>OAuth（Googleログイン）を使うために、Socialite をインストールし、Laravel を再起動＆キャッシュクリア</th>
</tr>
<tr>
<th>【cleanup.sh】</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
</tr>
</table>

<details>
<summary>各modulesスクリプトの処理概要一覧</summary>
<table>
<tr>
<th>ファイル名</th><th>処理の要約</th>
</tr>
<tr>
<th>modules/menu/init.sh</th><th>プロジェクト名を取得し、構成（docker/laravel/breeze/oauth）を選択・有効化</th>
</tr>
<tr>
<th>modules/docker/init.sh</th><th>docker/ディレクトリにテンプレートファイルをコピー</th>
</tr>
<tr>
<th>modules/docker/configure.sh</th><th>ポート番号を聞いて .env と docker-compose.yml を生成</th>
</tr>
<tr>
<th>modules/docker/execute.sh</th><th>Docker コンテナをリセット＆再起動</th>
</tr>
<tr>
<th>modules/laravel/init.sh</th><th>Laravel を Docker コンテナ内に create-project でインストール</th>
</tr>
<tr>
<th>modules/laravel/configure.sh</th><th>Laravel 側 .env は docker側で管理するのでスキップ（何もしない）</th>
</tr>
<tr>
<th>modules/laravel/execute.sh</th><th>artisan key:generate と migrate:fresh --seed を実行</th>
</tr>
<tr>
<th>modules/breeze/execute.sh</th><th>Breeze の導入、npm ビルド、マイグレーションを一括実行</th>
</tr>
<tr>
<th>modules/oauth/configure.sh</th><th>OAuth（Google）の設定ファイル・ルート・コントローラなどを一括生成</th>
</tr>
<tr>
<th>modules/oauth/execute.sh</th><th>Socialite のインストール、appコンテナの再起動、キャッシュクリア実施</th>
</tr>
</table>
</details>

<details>
<summary>不要なファイルかどうか確認する方法</summary>

## １. 参照検索：スクリプト内で使われているか調べる
grep -R "<対象>" -n modules/       # モジュール

grep -R "<対象>" -n functions/     # 汎用関数

grep -R "<対象>" -n .              # 全体


## ２. テンプレート＆コピー元との差分確認
diff -r "templates/<テンプレート相対パス>/" "<コピー先ディレクトリ>/"


## ３. Git 履歴調査：いつ追加されたかを確認
git log --pretty=oneline -- "<対象>"


## ４. 一時リネームして実行フローをテスト
mv "<対象>" "{対象}_bak"

bin/devsetup.sh init   # または関連サブコマンドを一巡
### → エラーなしなら safe to delete

## ５. .env／docker-compose テンプレート差分確認
diff "templates/<envテンプレート>" ".env"

diff "templates/<composeテンプレート>" "docker-compose.yml.template"

diff "templates/<composeテンプレート>" "docker-compose.yml"

## ６. テストカバレッジ（PHP＋PHPUnit の例）
### coverage レポート生成
./vendor/bin/phpunit --coverage-html coverage/
### coverage/html/index.html をブラウザで確認


## ７. 一時退避＆モニタリング：問題なければ本削除
mkdir -p backup_unused

mv "<対象>" backup_unused/
### 数日運用して異常なければ永久削除
</details>

<details>
<summary>便利検索コマンド</summary>
<table>
<tr>
<th colspan="2">grep -R "検索したいワード" -n "検索したいディレクトリ"</th>
</tr>
<tr>
<th>grep</th><th>指定した文字列をファイルの中から検索するコマンド</th>
<tr>
<tr>
<th>-R</th><th>再帰的にディレクトリ配下のすべてのファイルを対象に検索</th>
</tr>
<tr>
<th>-n</th><th>マッチした行の行番号も表示するオプション</th>
</tr>
<tr>
<th>modules</th><th>検索対象のディレクトリ（書かなくてもOK)</th>
</tr>
</table>
</details>

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
<table>
<tr>
<th>メニュー番号</th><th>構成テンプレート</th><th>備考</th>
</tr>
<tr>
<th>1</th><th>PHP+nginx+MySQL</th><th>素の LEMP</th>
</tr>
<tr>
<th>2</th><th>PHP+nginx+MySQL+Laravel  </th><th>バージョン指定可・マイグレーション選択可</th>
</tr>
<tr>
<th>3</th><th>PHP+nginx+MySQL+Laravel+Breeze</th><th>UI 認証付き・vite ビルド自動・migrate 選択可</th>
</tr>
<tr>
<th>4</th><th>PHP + nginx + MySQL + Laravel + Breeze + OAuth</th><th>Docker環境でOAuthまでをワンショット</th>
</tr>
</table>

追加テンプレートは随時拡張予定。


## ディレクトリ構造
```
.
├── bin
│   └── devsetup.sh
├── config
│   ├── default.conf
│   └── user.conf
├── docker
│   ├── nginx
│   │   └── default.conf
│   └── php
│       └── Dockerfile
├── docker-compose.yml
├── docker-compose.yml.template
├── framework
│   ├── core.sh
│   ├── loader.sh
│   └── logger.sh
├── functions
│   ├── compose_generator.sh
│   ├── env_generator.sh
│   ├── logger.sh
│   └── port_checker.sh
├── Makefile
├── modules
│   ├── breeze
│   │   ├── cleanup.sh
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   ├── docker
│   │   ├── cleanup.sh
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   ├── laravel
│   │   ├── cleanup.sh
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   ├── menu
│   │   ├── cleanup.sh
│   │   └── init.sh
│   └── oauth
│       ├── cleanup.sh
│       ├── configure.sh
│       ├── execute.sh
│       └── init.sh
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



## 必要環境および依存関係
- **Docker** および **Docker Compose**
- **Bash** 
- **envsubst**

## 今後の予定
- **プロジェクト内の不要ファイルを削除し、コードを整理・リファクタリング**
- **brew install devsetup で導入できるよう、Homebrew Formula対応を追加**