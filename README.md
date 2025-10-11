# **chezmoi / dotfiles 運用方針**

## **1. 概要**

このリポジトリは、**複数マシン（macOS / Ubuntu）で共通設定と個別設定を安全に統一管理するための dotfiles 管理環境**です。

ツールには **chezmoi** を使用し、OSやマシンごとの違いをテンプレートと ignore 設定で柔軟に切り替えます。

Git によるバージョン管理と組み合わせることで、どのマシンでも同一環境を再現できます。


## **2. 複数マシンの設定差分の扱い方**

複数マシン間での設定差分は、ファイルの違いに応じて3つの方法で扱います。

### **2.1 環境ごとに完全に異なるファイルを使う場合**

**別テンプレートファイルとして分離管理**します。

各環境用のテンプレートを .chezmoitemplates/ に配置し、メインのテンプレートから template 関数で呼び分けます。

### **2.2 一部のみ設定が異なる場合**

**1ファイル内で条件分岐**を行います。

OS やホスト名ごとに {{ if ... }} 構文で切り替え、共通箇所は同じファイルで共有します。

### **2.3 特定のマシンだけで使う設定の場合**

**.chezmoiignore で除外管理**します。

他のマシンではファイルを生成せず、対象マシンのみで適用します。



## **3. 各パターンの詳細と運用例**

### **3.1 環境ごとに完全に異なるファイルを使う場合（別テンプレート管理）**

.zshrc のように内容が大きく異なる場合、

mac 用と VM 用でテンプレートを完全に分けて管理します。

**構成例**

```
~/.local/share/chezmoi
├── .chezmoitemplates/
│   ├── zshrc_mac.tmpl
│   ├── zshrc_vm.tmpl
│   └── zshrc_common.tmpl
└── dot_zshrc.tmpl
```

**dot_zshrc.tmpl**

```
{{ if eq .chezmoi.hostname "MacBook-Air" }}
{{ template "zshrc_mac.tmpl" . }}
{{ else if eq .chezmoi.hostname "cryptojacking-vm" }}
{{ template "zshrc_vm.tmpl" . }}
{{ end }}
```

この構成により、ホストごとに完全に独立した設定を保ちながら、

共通要素は zshrc_common.tmpl に分離して再利用できます。



### **3.2 一部のみ設定が異なる場合（条件分岐で管理）**

共通部分が多く、差分が小さいファイルは1つにまとめて条件分岐します。

**例：dot_aliases.zsh.tmpl**

```
# bat
{{ if eq .chezmoi.os "linux" }}
alias bat='batcat'
{{ end }}
alias batp='bat --style=header --paging=auto'
```

Linuxではbatcatエイリアスを追加し、

macOSでは共通設定のみが展開されます。



### **3.3 特定マシンだけで使う設定（ignoreで除外）**

.chezmoiignore を利用して、他マシンでは適用しない設定を除外します。

**例：.chezmoiignore**

```
{{ if ne .chezmoi.os "darwin" }}
dot_hammerspoon/**
dot_tmux.conf
dot_config/alacritty/**
{{ end }}
```

macOS 以外ではこれらの設定は無視され、生成されません。

Mac では通常通り管理対象に含まれます。



## **4. 日常運用の流れ**

```
# 新規登録
chezmoi add --template ~/.zshrc

# 編集と確認
chezmoi edit ~/.zshrc
chezmoi diff

# 反映とバージョン管理
chezmoi apply
git -C ~/.local/share/chezmoi add .
git -C ~/.local/share/chezmoi commit -m "update"
git -C ~/.local/share/chezmoi push

# 他マシンでの初期化
chezmoi init <repo-url>
chezmoi apply
```



## **5. 確認・デバッグ用コマンド**

| **目的** | **コマンド** |
| --- | --- |
| OS / ホスト確認 | chezmoi execute-template '{{ .chezmoi.os }} {{ .chezmoi.hostname }}' |
| ignoreの評価確認 | chezmoi execute-template "$(cat "$(chezmoi source-path)/.chezmoiignore")" |
| ドライラン（変更プレビュー） | chezmoi -n apply -v |
| 管理対象一覧 | chezmoi managed |
| 非管理対象一覧 | chezmoi unmanaged |



## **6. 管理と非管理の基準**

| **管理するもの** | **管理しないもの** |
| --- | --- |
| .zshrc, .gitconfig, .aliases.zsh, .tmux.conf, .config/* | .ssh/, .aws/credentials, .zsh_history, .viminfo, キャッシュ・機密ファイル |



## **7. 方針まとめ**

- **構成が大きく異なるファイル** → 別テンプレートを作成して template で呼び分ける
- **共通が多く一部のみ異なるファイル** → 1ファイル内で条件分岐
- **特定マシン専用の設定** → .chezmoiignore で除外
- 共通処理は .chezmoitemplates/ にまとめて再利用
- 基本操作は diff → apply → commit の流れで統一管理
