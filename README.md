# **Dotfiles Management Policy (with chezmoi)**

このリポジトリは、**chezmoi** を用いて複数の環境（macOS / Ubuntu VM など）の設定ファイルを一元管理するための構成を採用しています。

環境やホスト名に応じて自動的に設定が切り替わるよう設計しています。

## **🧭 運用方針**

### **1. 管理の基本方針**

- すべての設定ファイルは chezmoi により管理します。
- **共通設定**・**OSごとの設定**・**ホスト（マシン）ごとの設定**を明確に分離し、重複を避けます。
- chezmoi のテンプレート機能や .chezmoiignore により、
    
    各マシンが必要とする設定だけを自動的に反映します。

### **2. 管理レイヤーのルール**

| **区分** | **管理方法** | **例** |
| --- | --- | --- |
| **全OS共通**（vim、ターミナルなど） | 通常ファイルとして共通管理 | dot_vimrc, dot_config/starship.toml |
| **OS専用**（mac専用ツール、Linux専用設定など） | ファイル名に .os_<os名> を付与 | dot_tmux.conf.os_darwin |
| **マシン専用**（.zshrc など大きく異なる設定） | ファイル名に .hostname_<ホスト名> を付与 | dot_zshrc.hostname_MacBook-Air<br>dot_zshrc.hostname_cryptojacking-vm |
| **不要な設定**（ツールを使わない環境） | .chezmoiignore に条件を記述 | {{ if eq .chezmoi.os "linux" }} dot_config/yabai/ {{ end }} |

### **3. テンプレートの活用**

- 拡張子 .tmpl のファイルはテンプレートとして扱われ、
    
    chezmoi のデータ（OS・ホスト名など）に応じて内容を切り替えられます。
    

### **例：bat/batcat の alias**

```
{{ if eq .chezmoi.os "linux" }}
alias bat='batcat'
{{ end }}
alias batp='bat --style=header --paging=auto'
```

### **4. ファイル命名・命名規則**

| **種類** | **サフィックス** | **適用対象** |
| --- | --- | --- |
| 共通 | なし | 全マシン |
| OS専用 | .os_darwin, .os_linux | OS単位 |
| ホスト専用 | .hostname_<ホスト名> | 特定マシン |
| テンプレート | .tmpl | 条件分岐を含む設定 |
| 除外リスト | .chezmoiignore | 適用しない設定の定義 |

## **⚙️ 基本コマンド**

| **操作** | **コマンド** | **説明** |
| --- | --- | --- |
| **ファイル追加** | chezmoi add <path> | 既存設定をchezmoi管理下に登録 |
| **編集** | chezmoi edit <path> | chezmoi管理ファイルを編集・保存後自動反映 |
| **反映内容確認** | chezmoi diff または chezmoi apply --dry-run -v | 適用前に差分を確認 |
| **反映** | chezmoi apply | 設定をホームディレクトリに展開 |
| **除外** | .chezmoiignore に追記 | 適用をスキップする設定を条件指定 |
| **新規マシンへの適用** | chezmoi init git@github.com:s1m4ne/dotfiles.git → chezmoi apply | GitHubからリポジトリを取得し反映 |
| **更新（他マシンからpull）** | chezmoi update | 最新のdotfilesをpull + apply |
| **ファイル削除（管理解除）** | chezmoi forget <path> | 指定ファイルを管理対象から外す |

## **💡 運用フロー**

1. 新しい設定を作成または修正
2. chezmoi add or chezmoi edit
3. chezmoi diff で確認
4. chezmoi apply で反映
5. git add -A && git commit -m "update" && git push
6. 他マシンでは chezmoi update で同期

## **🧠 まとめ**

- **共通は共通ファイルで一元化。**
- **OSやマシン差は命名で分離。**
- **不要なものは .chezmoiignore で条件除外。**
- **テンプレートで柔軟に分岐。**

このルールにより、Mac・VM・新規マシンいずれでも最小の作業で環境を再現できます。
