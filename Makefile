# --------------------------------------
# Makefile for devsetup
# 開発用＋Homebrew配布用 統合構成（開発後に開発用は削除）
# --------------------------------------

.PHONY: devsetup run

# メインエントリ：開発中は devsetup.sh、Homebrew用には devsetup を使用します
devsetup:
ifeq ($(wildcard ./bin/devsetup.sh), ./bin/devsetup.sh)
	@echo "Launching devsetup.sh (開発用)"
	@bash ./bin/devsetup.sh
else
	@echo "Launching devsetup (Homebrew用)"
	@./bin/devsetup
endif

# エイリアス的に run でも起動
run: devsetup
