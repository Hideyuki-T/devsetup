.PHONY: devsetup devsetup.sh

# メインエントリ（make devsetup で起動）
devsetup: devsetup.sh

# 実際の実行処理（Makefile上の仮想ターゲット）
devsetup.sh:
	@echo "devsetup 実行"
	@bash bin/devsetup.sh
