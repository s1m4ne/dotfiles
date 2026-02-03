# dotfiles (chezmoi)

## 最小の流れ

```bash
# 新規に管理へ追加
chezmoi add ~/.zshrc

# 以後の編集
chezmoi edit ~/.zshrc

# 差分確認 → 反映
chezmoi diff
chezmoi apply

# コミット & push
chezmoi git add -A
chezmoi git commit -m "update"
chezmoi git push
```

## 新規作成と追記

- 新規で管理する: `chezmoi add ~/.foo`
- 既に管理されているファイルに追記: `chezmoi edit ~/.foo`

## 直接編集した場合

- 直接編集しても壊れないが、差分が出て上書きされる可能性あり
- 取り込むなら: `chezmoi re-add ~/.foo`
