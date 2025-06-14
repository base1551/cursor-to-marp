# Cursor to Marp

CursorのAIアシスタントを使用して、MarkdownファイルからMarpスライドを簡単に生成するリポジトリです。

## ディレクトリ構成

```
cursor-to-marp/
├── input/              # 入力ファイル
│   └── input.md       # 変換元のMarkdownファイル
├── output/            # 出力ファイル（gitignore対象）
│   ├── *.md          # 生成されたスライドファイル
│   └── *.pdf         # 生成されたPDFファイル
├── .images/           # 画像リソース
│   ├── logo.png      # ロゴ画像
│   └── background.png # 背景画像
├── Makefile           # 一括変換用Makefile
└── YYYYMMDD_template.md # スライドテンプレート
```

## 前提条件

1. Cursorのインストール
2. VS Codeの拡張機能「Marp for VS Code」の追加
3. テーマの設定
   - VS Codeの設定で、Markdown > Marp:Themesに以下を追加：
   ```
   https://cunhapaulo.github.io/style/freud.css
   ```
   - その他のテーマについては[Qiita記事](https://qiita.com/YoshikiIto/items/74b3d786266b1de3ed93)を参考にしてください
   - 人気のテーマ：
     - gradient
     - beamer
     - border
     - dracula
     - speee
     - plato
     - heidegger

## 基本的な使い方

1. 入力ファイルの準備
   - `input/input.md`に変換したいMarkdownファイルを配置
   - ※mdファイルの名前は任意のものでも構いません

2. スライド生成ルールの適用
   - CursorのAIチャットの@rulesにて「slidemarprules」を設定
   - これにより、以下のルールが自動的に適用されます：
     - テンプレートの使用
     - 文字数制限
     - レイアウト制限
     - 画像使用ルール
     - フォーマット制限   

3. スライドの生成
   - CursorのAIチャットに「@input.md を元にスライド生成」と指示
   - 自動的に`output/YYYYMMDD_タイトル.md`形式でスライドが生成されます
   - ※1でファイル名を変更している場合は任意のものに変更すること

## 一括変換（Makeコマンド）

`output/`ディレクトリ内の全てのMarkdownファイルを一括で各種形式に変換できます。

### 基本コマンド

```bash
# ヘルプ表示
make help

# 未生成のPDFファイルを一括作成
make pdf

# 未生成のPPTXファイルを一括作成
make pptx

# 未生成のHTMLファイルを一括作成
make html

# 全形式（PDF、PPTX、HTML）を一括作成
make all

# outputディレクトリ内のファイル一覧表示
make list

# 生成ファイルのクリーンアップ
make clean
```

### 特徴

- **差分更新**: 既に存在するファイルは、元のMarkdownファイルが更新された場合のみ再生成
- **一括処理**: `output/`ディレクトリ内の全ての`.md`ファイルを自動検出して処理
- **安全性**: ローカルファイル（画像）アクセスを自動で有効化

### 使用例

```bash
# 複数のスライドファイルがある場合の一括PDF生成
make pdf

# 全形式で出力したい場合
make all

# 作業をリセットしたい場合
make clean
make all
```


## 注意事項

1. 画像の配置
   - 必ず`.images`ディレクトリに配置
   - ロゴ画像は必須

2. スライドのスタイル
   - `YYYYMMDD_template.md`で定義
   - カスタマイズする場合はテンプレートを編集

3. 日本語対応
   - フォントは'Hiragino Sans'と'Noto Sans CJK JP'を使用
   - 文字化けが発生する場合はフォントの確認を

4. PDF生成時の画像表示
   - Marp CLIで画像を含むPDFを生成する場合は`--allow-local-files`オプションが必要
   - セキュリティ上の警告が表示されますが、ローカル開発では問題ありません

5. ファイル管理
   - 生成されたスライド（`.md`）とPDF（`.pdf`）は`output/`ディレクトリに保存されます
   - `output/`ディレクトリは`.gitignore`で管理対象外に設定されています
   - 生成ファイルはGitにコミットされません
