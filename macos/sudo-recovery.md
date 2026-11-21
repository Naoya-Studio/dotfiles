# macOS sudo 復旧マニュアル（sudo_local 破損時）

## 概要
Homebrew の整理や dotfiles の整理中に Touch ID 連携（pam_reattach）の設定を残したまま
関連ライブラリを削除すると、sudo が「sudo: unable to initialize PAM」で完全に動かなくなります。
この手順書は macOS リカバリモードを使い、sudo_local を安全に修正して復旧する方法です。

## 発生する問題とリカバリモードの罠
- FileVault でディスクがロックされ、リカバリ直後はマウントされていない
- リカバリ環境には nano が無く、vi を強いられる

## 復旧手順

### STEP 1: リカバリモード起動
- Apple Silicon: 電源長押し → 「起動オプションを読み込み中」 → 「オプション」→「続ける」
- Intel: 起動直後に ⌘+R を押し続ける  

メニューバーの「ユーティリティ」→「ターミナル」を開く。

### STEP 2: ディスクのロック解除とマウント
1. ディスク情報を確認
   ```sh
   diskutil apfs list
   ```
2. `Name: Macintosh HD` のブロックを探し、上部の  
   `APFS Volume Disk: diskXsY` を控える
3. アンロック（例: disk3s1）
   ```sh
   diskutil apfs unlockVolume disk3s1
   ```

Passphrase を求められたら普段のログインパスワードを入力し、  
`Unlocked and mounted` が出れば成功。

### STEP 3: 本体側の nano で sudo_local を編集
1. nano を起動（Macintosh HD の場合）
   ```sh
   /Volumes/Macintosh\ HD/usr/bin/nano "/Volumes/Macintosh HD/private/etc/pam.d/sudo_local"
   ```

   もし `No such file` なら Data 側を試す
   ```sh
   /Volumes/Macintosh\ HD\ -\ Data/usr/bin/nano "/Volumes/Macintosh HD - Data/private/etc/pam.d/sudo_local"
   ```

2. pam_reattach の行を削除  
   次のような行（パスは環境で異なる）を削除する
   ```
   auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
   auth       optional       /usr/local/lib/pam/pam_reattach.so
   ```

   `pam_reattach.so` を含む行を 1 行まるごと削除。  
   （nano なら `Ctrl + K`）

3. 保存して終了  
   `Ctrl + O` → Enter → `Ctrl + X`

### STEP 4: 再起動
```sh
reboot
```

通常起動後、`sudo ls` などが動作することを確認。

## 今後壊さないためのポイント
- pam_reattach は Homebrew で再インストールしてから設定を追加する
- Homebrew を消す前に sudo_local の pam_reattach 行を削除（またはコメントアウト）
