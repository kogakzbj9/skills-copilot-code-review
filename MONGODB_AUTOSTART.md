# MongoDBの自動起動について / About MongoDB Auto-Start

## 期待される動作 / Expected Behavior

### ✅ 正常な場合

**Codespacesでは、MongoDBは自動的に起動されるように設定されています。**

In Codespaces, MongoDB is configured to start automatically.

#### 自動起動のタイミング / Auto-Start Timing

1. **初回作成時 (postCreateCommand)**
   - Codespaceを初めて作成したとき
   - MongoDBをインストール＆起動
   - When you first create the Codespace
   - Installs and starts MongoDB

2. **起動時 (postStartCommand)**
   - Codespaceを起動・再開するたびに
   - MongoDBを自動起動
   - Every time you start/resume the Codespace
   - Automatically starts MongoDB

#### 設定ファイル / Configuration

この動作は `.devcontainer/devcontainer.json` で定義されています：

```json
{
  "postCreateCommand": "bash ./.devcontainer/postCreate.sh",
  "postStartCommand": "bash ./.devcontainer/postStart.sh"
}
```

- `postCreate.sh`: MongoDBのインストールと初回起動
- `postStart.sh`: MongoDB起動（毎回）

## ⚠️ MongoDBが起動していない場合

MongoDBが起動していない場合は、**何か問題が発生しています**。

If MongoDB is not running, **something went wrong**.

### 考えられる原因 / Possible Causes

1. **postStartCommandが失敗した**
   - スクリプト実行エラー
   - 権限の問題
   - Script execution error
   - Permission issues

2. **MongoDBのインストールが失敗した**
   - postCreateCommand実行時の問題
   - ディスク容量不足
   - Installation failure during postCreateCommand
   - Insufficient disk space

3. **MongoDBがクラッシュした**
   - 自動起動後に停止
   - メモリ不足
   - Crashed after auto-start
   - Out of memory

4. **手動で停止した**
   - `systemctl stop mongod` を実行した
   - Manually stopped with `systemctl stop mongod`

## 🔍 問題の診断 / Diagnosing Issues

### ステップ1: MongoDBの状態を確認

```bash
bash check-mongodb-status.sh
```

### ステップ2: postStartCommandのログを確認

Codespacesのターミナルで、起動時のログを確認：

```bash
# postStartCommandのログを探す
# GitHubのCodespacesログパネルで確認
```

### ステップ3: MongoDBのログを確認

```bash
# インストールログ
cat /var/log/mongodb/mongod.log

# エラーを検索
sudo grep -i error /var/log/mongodb/mongod.log
```

## 🛠️ 解決方法 / Solutions

### 解決方法1: 手動で起動（一時的な解決）

```bash
./.devcontainer/startMongoDB.sh
```

または

```bash
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

### 解決方法2: Codespaceを再構築（推奨）

自動起動が常に失敗する場合は、Codespaceを再構築：

1. コマンドパレット（Ctrl/Cmd + Shift + P）を開く
2. "Codespaces: Rebuild Container" を選択
3. 再構築が完了するまで待つ

If auto-start consistently fails, rebuild the Codespace:

1. Open Command Palette (Ctrl/Cmd + Shift + P)
2. Select "Codespaces: Rebuild Container"
3. Wait for rebuild to complete

### 解決方法3: 自動起動を有効化

MongoDBサービスの自動起動を有効化：

```bash
sudo systemctl enable mongod
```

## 📋 チェックリスト / Checklist

正常な自動起動環境かチェック：

- [ ] Codespace起動時にMongoDBが自動的に起動する
- [ ] `systemctl status mongod` で "enabled" と表示される
- [ ] `/var/log/mongodb/mongod.log` にエラーがない
- [ ] アプリケーション起動時にMongoDB接続エラーが出ない

## 💡 ベストプラクティス / Best Practices

1. **定期的な状態確認**
   ```bash
   # 作業開始時に確認
   bash check-mongodb-status.sh
   ```

2. **問題があれば早期発見**
   - アプリケーション起動前にMongoDBの状態を確認
   - Check MongoDB status before starting the application

3. **ログの監視**
   - エラーログを定期的に確認
   - Regularly check error logs

## 📚 関連ドキュメント / Related Documentation

- 📖 [MONGODB_STATUS_CHECK.md](./MONGODB_STATUS_CHECK.md) - 起動状況確認の詳細
- 📖 [MONGODB_QUICK_REFERENCE.md](./MONGODB_QUICK_REFERENCE.md) - クイックリファレンス
- 📖 [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md) - トラブルシューティング

## まとめ / Summary

| 項目 | 期待値 | 実際の問題時 |
|------|--------|------------|
| 自動起動 | ✅ はい（自動） | ❌ 起動していない |
| ユーザー操作 | ✅ 不要 | ⚠️ 手動起動が必要 |
| 問題の種類 | - | ⚠️ 設定・システムエラー |
| 対処方法 | - | 🔧 手動起動 or 再構築 |

**結論**: MongoDBは自動起動が期待値です。起動していない場合は何らかの問題があるため、このドキュメントの手順に従って診断・解決してください。

**Conclusion**: MongoDB auto-start is the expected behavior. If it's not running, there's an issue that needs to be diagnosed and resolved following this document's procedures.
