## 名称：devsetup

## 課題（開発の背景）
- 今、必要だと感じたので **いきなり作成しました！**
- そのため、現時点では全体が **整理されておりません。後で整えます！**


## 目的：
#### 開発中に感じた課題を解消するために作成
- 複数のDockerコンテナを作成していく過程で、ポート競合や構成の衝突が増えてきた。
- 毎回行っている同じ初期構築作業が煩雑かつ退屈に感じられるようになった。

## 概要：
- 開発環境初期構築用CLIツール
- Dockerベースの開発環境を、対話形式のシェルスクリプト一発で構築
- 面倒な初期設定をスキップして、すぐに開発を開始できる状態を提供


## 主な特徴：
- 対話形式でプロジェクト設定（名前・ディレクトリ・ポート・DB・FW）を案内
- Laravel／Django／Symfony／Express など複数フレームワークに対応
- バージョン指定にも対応
- Dockerfile・compose.yml・src/ ディレクトリを自動生成
- ポート競合やファイル衝突の簡易チェック機能を実装

## tree
```
devsetup-tool/                     
├── devsetup.sh                    
├── templates/                     
│   ├── php-nginx-mysql/           
│   │   ├── docker-compose.yml.template
│   │   ├── .env.template
│   │   └── docker/                
│   │       ├── php/Dockerfile
│   │       └── nginx/default.conf
│   └── ...                    //拡張用    
├── functions/                     
│   ├── port_checker.sh            
│   ├── env_generator.sh           
│   ├── compose_generator.sh       
│   └── logger.sh                  
└── README.md                      

projects/                          
├── myapp1/                        
│   ├── src/                       
│   ├── docker-compose.yml         
│   ├── .env                     
│   └── docker/                    
│       ├── php/
│       └── nginx/
└── myapp2/                        
    └── ...

```

## 🚀 使い方
```
chmod +x devsetup.sh

./devsetup.sh
```

## 今後の予定：
- Makefileによるコマンドの簡素化
- GitHub連携のオプション機能
- FastAPI / SvelteKit / Go などのフレームワーク追加
- b設定テンプレートの事前定義・読み込み機能
- テスト自動化＆CI/CD対応（気が向いたら）
- ...
