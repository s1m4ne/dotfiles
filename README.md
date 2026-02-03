# **chezmoi / dotfiles（macOS専用）**

## **1. 概要**

このリポジトリは **macOS 1台専用の dotfiles 管理**です。
OS/ホストの条件分岐は使わず、設定は **そのまま直書き**で管理します。

別マシンを管理する場合は、**別リポジトリ + 別 chezmoi source dir** で完全分離します。


## **2. 日常運用の流れ**

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
```


## **3. 確認・デバッグ用コマンド**

| **目的** | **コマンド** |
| --- | --- |
| ドライラン（変更プレビュー） | chezmoi -n apply -v |
| 管理対象一覧 | chezmoi managed |
| 非管理対象一覧 | chezmoi unmanaged |


## **4. 管理と非管理の基準**

| **管理するもの** | **管理しないもの** |
| --- | --- |
| .zshrc, .gitconfig, .aliases.zsh, .tmux.conf, .config/* | .ssh/, .aws/credentials, .zsh_history, .viminfo, キャッシュ・機密ファイル |


## **5. 方針まとめ**

- **macOS 専用で直書き管理**（条件分岐やテンプレートは使わない）
- 別マシンは **別リポジトリ + 別 source dir** で完全分離
- 基本操作は diff → apply → commit の流れで統一
