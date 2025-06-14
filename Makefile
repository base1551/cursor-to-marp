# Cursor to Marp Makefile
# outputディレクトリ内のMarkdownファイルから一括でPDF/PPTX生成

# 変数定義
OUTPUT_DIR = output
IMAGES_DIR = .images
OUTPUT_IMAGES_DIR = $(OUTPUT_DIR)/.images
MARP = marp
MARP_OPTIONS = --allow-local-files

# outputディレクトリ内の.mdファイルを検索
MD_FILES = $(wildcard $(OUTPUT_DIR)/*.md)
PDF_FILES = $(MD_FILES:.md=.pdf)
PPTX_FILES = $(MD_FILES:.md=.pptx)
HTML_FILES = $(MD_FILES:.md=.html)

# デフォルトターゲット
.PHONY: help
help:
	@echo "Cursor to Marp - 利用可能なコマンド:"
	@echo ""
	@echo "  make pdf     - 未生成のPDFファイルを一括作成"
	@echo "  make pptx    - 未生成のPPTXファイルを一括作成"
	@echo "  make html    - 未生成のHTMLファイルを一括作成"
	@echo "  make all     - PDF、PPTX、HTMLを全て作成"
	@echo "  make clean   - outputディレクトリをクリーンアップ"
	@echo "  make list    - outputディレクトリ内のファイル一覧表示"
	@echo "  make help    - このヘルプメッセージを表示"
	@echo ""
	@echo "例:"
	@echo "  make pdf     # 全ての.mdファイルをPDFに変換"
	@echo "  make all     # 全形式で出力"
	@echo ""
	@echo "注意: 変換時に画像ファイルを自動でoutputディレクトリにコピーします"

# 画像ファイルの準備
.PHONY: prepare-images
prepare-images:
	@echo "画像ファイルを準備中..."
	@if [ -d "$(IMAGES_DIR)" ]; then \
		mkdir -p "$(OUTPUT_IMAGES_DIR)"; \
		cp -r "$(IMAGES_DIR)"/* "$(OUTPUT_IMAGES_DIR)"/; \
		echo "画像ファイルをoutputディレクトリにコピーしました"; \
	else \
		echo "警告: $(IMAGES_DIR) ディレクトリが見つかりませんでした"; \
	fi

# PDF生成（未生成のもののみ）
.PHONY: pdf
pdf: prepare-images
	@echo "PDF生成を開始..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			pdf_file="$${md_file%.md}.pdf"; \
			if [ ! -f "$$pdf_file" ] || [ "$$md_file" -nt "$$pdf_file" ]; then \
				echo "生成中: $$pdf_file"; \
				$(MARP) "$$md_file" --pdf $(MARP_OPTIONS); \
			else \
				echo "スキップ: $$pdf_file (最新版が既に存在)"; \
			fi; \
		fi; \
	done
	@echo "PDF生成完了!"

# PPTX生成（未生成のもののみ）
.PHONY: pptx
pptx: prepare-images
	@echo "PPTX生成を開始..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			pptx_file="$${md_file%.md}.pptx"; \
			if [ ! -f "$$pptx_file" ] || [ "$$md_file" -nt "$$pptx_file" ]; then \
				echo "生成中: $$pptx_file"; \
				$(MARP) "$$md_file" --pptx $(MARP_OPTIONS); \
			else \
				echo "スキップ: $$pptx_file (最新版が既に存在)"; \
			fi; \
		fi; \
	done
	@echo "PPTX生成完了!"

# HTML生成（未生成のもののみ）
.PHONY: html
html: prepare-images
	@echo "HTML生成を開始..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			html_file="$${md_file%.md}.html"; \
			if [ ! -f "$$html_file" ] || [ "$$md_file" -nt "$$html_file" ]; then \
				echo "生成中: $$html_file"; \
				$(MARP) "$$md_file" --html $(MARP_OPTIONS); \
			else \
				echo "スキップ: $$html_file (最新版が既に存在)"; \
			fi; \
		fi; \
	done
	@echo "HTML生成完了!"

# 全形式生成
.PHONY: all
all: prepare-images pdf pptx html
	@echo "全ての形式での生成が完了しました!"

# outputディレクトリのクリーンアップ
.PHONY: clean
clean:
	@echo "outputディレクトリをクリーンアップ中..."
	@rm -f $(OUTPUT_DIR)/*.pdf $(OUTPUT_DIR)/*.pptx $(OUTPUT_DIR)/*.html
	@rm -rf $(OUTPUT_IMAGES_DIR)
	@echo "クリーンアップ完了!"

# ファイル一覧表示
.PHONY: list
list:
	@echo "outputディレクトリ内のファイル:"
	@ls -la $(OUTPUT_DIR)/ || echo "outputディレクトリが存在しません"

# 強制的に全て再生成
.PHONY: force-pdf force-pptx force-html
force-pdf: prepare-images
	@echo "全PDFファイルを強制再生成..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			echo "生成中: $${md_file%.md}.pdf"; \
			$(MARP) "$$md_file" --pdf $(MARP_OPTIONS); \
		fi; \
	done

force-pptx: prepare-images
	@echo "全PPTXファイルを強制再生成..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			echo "生成中: $${md_file%.md}.pptx"; \
			$(MARP) "$$md_file" --pptx $(MARP_OPTIONS); \
		fi; \
	done

force-html: prepare-images
	@echo "全HTMLファイルを強制再生成..."
	@for md_file in $(OUTPUT_DIR)/*.md; do \
		if [ -f "$$md_file" ]; then \
			echo "生成中: $${md_file%.md}.html"; \
			$(MARP) "$$md_file" --html $(MARP_OPTIONS); \
		fi; \
	done
