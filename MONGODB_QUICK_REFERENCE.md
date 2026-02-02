# MongoDB クイックリファレンス / MongoDB Quick Reference

## ⚠️ 重要 / Important

**MongoDBは自動起動が期待値です / MongoDB auto-start is expected**

Codespacesでは自動的に起動されます。起動していない場合は問題があります。
詳細: [MONGODB_AUTOSTART.md](./MONGODB_AUTOSTART.md)

In Codespaces, it starts automatically. If not running, there's an issue.
Details: [MONGODB_AUTOSTART.md](./MONGODB_AUTOSTART.md)

## 🚀 最速チェック / Quick Check

```bash
bash check-mongodb-status.sh
```

## 📝 よく使うコマンド / Common Commands

### MongoDBの状態確認 / Check Status

```bash
# 方法1: サービス状態
sudo systemctl status mongod

# 方法2: プロセス確認
pgrep -l mongod

# 方法3: 接続テスト
mongosh --eval "db.adminCommand('ping')"

# 方法4: ポート確認
sudo lsof -i :27017
```

### MongoDBの起動 / Start MongoDB

```bash
# スクリプトで起動
./.devcontainer/startMongoDB.sh

# 手動で起動
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

### MongoDBの停止 / Stop MongoDB

```bash
sudo systemctl stop mongod
```

### MongoDBの再起動 / Restart MongoDB

```bash
sudo systemctl restart mongod
```

## 📖 詳細ドキュメント / Detailed Documentation

| Document | Description |
|----------|-------------|
| [MONGODB_STATUS_CHECK.md](./MONGODB_STATUS_CHECK.md) | MongoDB起動状況確認の詳細ガイド (日本語) |
| [MONGODB_STATUS_CHECK_EN.md](./MONGODB_STATUS_CHECK_EN.md) | Detailed MongoDB status check guide (English) |
| [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md) | HTTP 502エラーのトラブルシューティング (日本語) |
| [TROUBLESHOOTING_502_ERROR_EN.md](./TROUBLESHOOTING_502_ERROR_EN.md) | HTTP 502 error troubleshooting (English) |
| [SOLUTION_SUMMARY.md](./SOLUTION_SUMMARY.md) | 解決方法のまとめ / Solution summary (Bilingual) |

## ✅ 正常時の表示 / Normal Output

```
✅ MongoDB process is running (PID: 12345)
✅ MongoDB service is active
✅ Port 27017 is listening
✅ Successfully connected to MongoDB
```

## ❌ 問題がある時の表示 / Error Output

```
❌ MongoDB process is NOT running
❌ MongoDB service is not active
❌ Port 27017 is NOT listening
❌ Cannot connect to MongoDB
```

→ 解決方法: `./.devcontainer/startMongoDB.sh` を実行

## 🔍 ログの確認 / Check Logs

```bash
# 最新のログを表示
sudo tail -50 /var/log/mongodb/mongod.log

# エラーを検索
sudo grep -i error /var/log/mongodb/mongod.log | tail -20
```

## 💡 ヒント / Tips

1. **自動起動を有効化 / Enable auto-start:**
   ```bash
   sudo systemctl enable mongod
   ```

2. **バージョン確認 / Check version:**
   ```bash
   mongod --version
   ```

3. **設定ファイル / Config file:**
   ```bash
   cat /etc/mongod.conf
   ```

## 🆘 困った時は / If You Need Help

1. 自動チェックスクリプトを実行: `bash check-mongodb-status.sh`
2. ログを確認: `sudo tail -50 /var/log/mongodb/mongod.log`
3. 詳細ガイドを参照: [MONGODB_STATUS_CHECK.md](./MONGODB_STATUS_CHECK.md)
4. トラブルシューティング: [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md)
