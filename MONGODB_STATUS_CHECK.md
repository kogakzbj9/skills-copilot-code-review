# MongoDBの起動状況を確認する手順

このガイドでは、MongoDBが正常に起動しているかどうかを確認する方法を説明します。

## 🚀 クイックチェック（推奨）

最も簡単な方法は、用意されたスクリプトを使用することです：

```bash
bash check-mongodb-status.sh
```

このスクリプトは自動的にMongoDBの状態をチェックし、結果を分かりやすく表示します。

## 📋 手動でチェックする方法

### 方法1: systemctlコマンドを使用（推奨）

MongoDBのサービス状態を確認：

```bash
sudo systemctl status mongod
```

**正常な場合の出力例：**
```
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled)
   Active: active (running) since ...
   ...
```

✅ **"Active: active (running)"** が表示されていればMongoDBは起動しています。

❌ **"Active: inactive (dead)"** または **"Active: failed"** の場合、MongoDBは起動していません。

### 方法2: プロセスを直接確認

MongoDBプロセスが実行されているか確認：

```bash
pgrep -l mongod
```

**正常な場合の出力例：**
```
12345 mongod
```

✅ プロセスID（数字）と "mongod" が表示されていればMongoDBは起動しています。

❌ 何も表示されない場合、MongoDBは起動していません。

### 方法3: MongoDBクライアントで接続確認

MongoDBに実際に接続して確認：

```bash
mongosh --eval "db.adminCommand('ping')"
```

**正常な場合の出力例：**
```
{ ok: 1 }
```

✅ `{ ok: 1 }` が表示されればMongoDBは起動しており、接続可能です。

❌ エラーメッセージが表示される場合、MongoDBは起動していないか、接続できません。

### 方法4: ポートをチェック

MongoDBのデフォルトポート（27017）がリッスンしているか確認：

```bash
sudo lsof -i :27017
```

または

```bash
sudo netstat -tulpn | grep 27017
```

**正常な場合の出力例：**
```
mongod    12345   mongodb   11u  IPv4  ...  TCP *:27017 (LISTEN)
```

✅ ポート27017でLISTENしていればMongoDBは起動しています。

❌ 何も表示されない場合、MongoDBは起動していません。

## 🔍 詳細情報の確認

### MongoDBのバージョン確認

```bash
mongod --version
```

### MongoDBのログを確認

最近のログエントリを表示：

```bash
sudo tail -50 /var/log/mongodb/mongod.log
```

エラーがないか確認：

```bash
sudo grep -i error /var/log/mongodb/mongod.log | tail -20
```

### MongoDBの設定ファイルを確認

```bash
cat /etc/mongod.conf
```

## ⚠️ MongoDBが起動していない場合

MongoDBが起動していないことが確認できた場合は、以下のコマンドで起動してください：

```bash
./.devcontainer/startMongoDB.sh
```

または手動で：

```bash
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

## 🔄 トラブルシューティング

MongoDBが起動しない、または問題がある場合は、以下のドキュメントを参照してください：

- 📖 **詳細なトラブルシューティング**: [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md)
- 📖 **English version**: [TROUBLESHOOTING_502_ERROR_EN.md](./TROUBLESHOOTING_502_ERROR_EN.md)
- 📖 **解決方法のまとめ**: [SOLUTION_SUMMARY.md](./SOLUTION_SUMMARY.md)

## 📊 チェックリスト

MongoDBが正常に動作しているか確認するためのチェックリスト：

- [ ] `sudo systemctl status mongod` で "active (running)" が表示される
- [ ] `pgrep -l mongod` でプロセスIDが表示される
- [ ] `mongosh --eval "db.adminCommand('ping')"` で `{ ok: 1 }` が返される
- [ ] `sudo lsof -i :27017` でポート27017がLISTENしている
- [ ] `/var/log/mongodb/mongod.log` にエラーがない

すべてチェックできれば、MongoDBは正常に動作しています！ ✅
