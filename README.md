# 名称：devsetup

## 🧰 技術スタック / Tech Stack
#### 開発・言語・IDE
![PHP](https://img.shields.io/badge/PHP-777BB4?style=flat&logo=php&logoColor=white)
![ShellScript](https://img.shields.io/badge/ShellScript-0891b2?style=flat&logo=gnubash&logoColor=white)
![PhpStorm](https://img.shields.io/badge/PhpStorm-143?style=flat&logo=phpstorm&logoColor=white)

#### フレームワーク・認証
![Laravel](https://img.shields.io/badge/Laravel-ff2d20?style=flat&logo=laravel&logoColor=white)
![Laravel Breeze](https://img.shields.io/badge/Laravel_Breeze-ff2d20?style=flat&logo=laravel&logoColor=white)
![Symfony](https://img.shields.io/badge/Symfony-000000?style=flat&logo=symfony&logoColor=white)
![OAuth2](https://img.shields.io/badge/OAuth2-0076CE?style=flat&logo=openid&logoColor=white)

#### インフラ・ミドルウェア
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)

#### パッケージ・バージョン管理
![Composer](https://img.shields.io/badge/Composer-885630?style=flat&logo=composer&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)



## 🧭 概要
- **本ツール** は、Docker を基盤とした開発環境の構築を、対話型CLIと分割モジュール構成によって完全自動化するツールである。
- 対話形式の ShellScript によって、複数コンテナ環境における ポート競合・構成の衝突・初期化漏れ といった煩雑な問題を解決。
- Laravel、Symfony、MySQL、Nginx、OAuth 認証など、再現性のある複数構成パターンをメニュー選択で実行可能。
- 各モジュールは init → configure → execute → cleanup の厳密な実行フローに従い、Infinity Framework の設計思想を踏襲。
- .env自動生成、ログ出力、環境キャッシュ管理など、開発開始前の全処理を一括完結することを目的とする。

<details>
<summary>各モジュール説明</summary>

<table>
<tr>
<th>モジュール</th>
<th>"menu"</th>
<th>"laravel"</th>
<th>"Symfony"</th>
<th>"docker"</th>
<th>"breeze"</th>
<th>"oauth"</th>
</tr>
<tr>
<th>【init.sh】</th>
<th>ディレクトリ作成・モジュールを有効化＆並び替え・有効構成をログ出力</th>
<th>Laravel を Docker コンテナ内にインストールする</th>
<th>Dockerコンテナの再構築・PHP拡張の検証・Symfonyのインストール</th>
<th>Docker の設定ファイルをプロジェクトにコピーする</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
</tr>
<tr>
<th>【configure.sh】</th>
<th>ファイルなし</th>
<th>特に処理なし</th>
<th>.env ファイルにおける DATABASE_URL の設定値を、環境変数から動的に再構築し、MySQL接続に対応した正しい形式へ置換</th>
<th>ポート番号を聞いて .env と docker-compose.yml を生成</th>
<th>特に処理なし</th>
<th>Laravel に Google OAuth 認証をフル自動で設定</th>
</tr>
<tr>
<th>【execute.sh】</th>
<th>ファイルなし</th>
<th>Laravel の初期化を Docker コンテナ内で実行する</th>
<th>Symfonyが環境変数をキャッシュする .env.local.php を削除・再生成し、アプリケーション設定を反映させた上でキャッシュを完全に初期化する</th>
<th>Docker コンテナを一度止めてから、改めてビルドして起動</th>
<th>Laravel Breeze をコンテナ内でインストール＆ビルドし、ログインUIを使える状態にまで一括セットアップ</th>
<th>OAuth（Googleログイン）を使うために、Socialite をインストールし、Laravel を再起動＆キャッシュクリア</th>
</tr>
<tr>
<th>【cleanup.sh】</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
<th>構成完了後に、.env ファイルに正しく DATABASE_URL が記されているかを目視確認できるように出力</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
<th>特に処理なし</th>
</tr>
</table>

</details>

## 📦 機能一覧
<table>
<tr>
<th>メニュー番号</th><th>作成可能環境設定</th>
</tr>
<tr>
<th>[1]</th><th>PHP + nginx + MySQL</th>
</tr>
<tr>
<th>[2]</th><th>PHP + nginx + MySQL + Laravel</th>
</tr>
<tr>
<th>[3]</th><th>PHP + nginx + MySQL + Laravel + Breeze</th>
</tr>
<tr>
<th>[4]</th><th>PHP + nginx + MySQL + Laravel + Breeze + OAuth</th>
</tr>
<tr>
<th>[5]</th><th>PHP + nginx + MySQL + Symfony</th>
</tr>
</table>

追加テンプレートは随時拡張予定。

## 🚀 セットアップ手順
### リポジトリのクローン
```
https://github.com/Hideyuki-T/devsetup.git
```
#### SSHでクローンする場合はこちら:
```
git@github.com:Hideyuki-T/devsetup.git
```

## 🧪 使用方法
### 以下コマンドで実行 (親ディレクトリにプロジェクトが作成されます)
```
make run
```


## ディレクトリ構造
```
.
├── bin
│   └── devsetup.sh
├── config
│   ├── default.conf
│   └── user.conf
├── docker-compose.yml
├── framework
│   ├── core.sh
│   ├── loader.sh
│   └── logger.sh
├── functions
│   └── env_generator.sh
├── Makefile
├── modules
│   ├── breeze
│   │   ├── cleanup.sh
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   ├── common
│   │   ├── laravel.sh
│   │   └── symfony.sh
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
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   ├── oauth
│   │   ├── cleanup.sh
│   │   ├── configure.sh
│   │   ├── execute.sh
│   │   └── init.sh
│   └── symfony
│       ├── cleanup.sh
│       ├── configure.sh
│       ├── execute.sh
│       └── init.sh
├── README.md
└── templates
    └── php-nginx-mysql
        ├── docker
        │   ├── nginx
        │   │   └── default.conf
        │   └── php
        │       └── Dockerfile
        └── docker-compose.yml.template
```


## 現在の課題

- 途中停止後の再実行対応の不足
- エラーハンドリングとログ整備の甘さ

## 今後の拡張予定

- Homebrew での配布対応
- CI/CD 環境での構築動作確認（GitHub Actions 対応）
- `.env` を含むテンプレート定義ファイルからの自動生成
- Laravel + Inertia や Next.js とのマルチ構成対応
- モジュールごとの単体テストコマンド追加