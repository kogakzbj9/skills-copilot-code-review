# HTTP 502 エラーのトラブルシューティング

## 問題の症状

ポートタブからウェブページを開こうとすると、以下のエラーが表示される：

```
このページは動作していません
organic-space-robot-qpqjxvx7rxgf4jrx-8000.app.github.dev では現在このリクエストを処理できません。
HTTP ERROR 502
```

## 根本原因

**原因**: MongoDBデータベースサービスが起動していないため、FastAPIアプリケーションの起動時に応答がなくなっています。

### 技術的な詳細

1. `src/app.py` の22行目で `database.init_database()` が呼び出されます
2. この関数はMongoDBに接続しようとします (`src/backend/database.py` の43行目)
3. MongoDBが起動していない場合、接続試行がハングし、アプリケーションが完全に起動できません
4. その結果、ポート8000でリクエストを処理できるサーバーが存在せず、HTTP 502エラーが発生します

## 切り分け方法（診断手順）

### 1. MongoDBの状態を確認

ターミナルで以下のコマンドを実行してください：

```bash
sudo systemctl status mongod
```

または

```bash
pgrep -l mongod
```

**期待される結果**: MongoDBプロセスが実行中と表示されるはずです。

**問題がある場合**: "active (running)" が表示されない、またはプロセスが見つからない場合、MongoDBが起動していません。

### 2. MongoDBのログを確認

```bash
sudo cat /var/log/mongodb/mongod.log | tail -50
```

エラーメッセージや起動失敗の原因を確認できます。

### 3. FastAPIアプリケーションの状態を確認

デバッグコンソールまたはターミナルで、アプリケーションがハングしているか確認：

```bash
ps aux | grep uvicorn
```

uvicornプロセスが存在しない場合、アプリケーションは起動できていません。

## 解決方法

### 方法1: MongoDBを起動する（推奨）

Codespacesのターミナルで、以下のスクリプトを実行してください：

```bash
./.devcontainer/startMongoDB.sh
```

または、手動で起動：

```bash
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

### 方法2: MongoDB インストール後の初回セットアップ

MongoDBがインストールされていない場合：

```bash
# MongoDBをインストール
./.devcontainer/installMongoDB.sh

# MongoDBを起動
./.devcontainer/startMongoDB.sh
```

### 方法3: Codespacesを再起動

Codespacesを完全に再起動すると、`postStartCommand` が実行され、MongoDBが自動的に起動されます。

1. Codespaceを停止
2. 再度起動
3. 起動完了まで待機（postStartCommandの実行を含む）

## 解決の確認

1. MongoDBが起動していることを確認：
   ```bash
   mongosh --eval "db.version()"
   ```
   
2. FastAPIアプリケーションを起動：
   - VS Codeの「実行とデバッグ」タブを使用
   - または、ターミナルで: `uvicorn src.app:app --reload`

3. ポートタブでポート8000を確認し、ブラウザで開く

4. "Mergington High School" のウェブページが正常に表示されることを確認

## 予防策

今後同じ問題を避けるために：

1. Codespacesを起動したら、MongoDBが実行中であることを確認してからアプリケーションを起動する
2. `.devcontainer/postStart.sh` スクリプトが正常に完了していることを確認する
3. 長時間使用しない場合、Codespacesがスリープから復帰した際にMongoDBが停止している可能性があるため、再起動する

## さらなる診断

上記の手順で解決しない場合：

### データディレクトリの権限を確認

```bash
ls -la /data/db
sudo chown -R mongodb:mongodb /data/db
```

### ポートの競合を確認

```bash
sudo lsof -i :27017
```

ポート27017（MongoDBのデフォルトポート）が他のプロセスで使用されていないか確認します。

### システムリソースを確認

```bash
df -h
free -h
```

ディスク容量やメモリが不足していないか確認します。

## まとめ

**最も可能性の高い原因**: MongoDBサービスが起動していない

**最速の解決方法**: `./.devcontainer/startMongoDB.sh` を実行

**長期的な解決**: Codespacesの起動時に自動的にMongoDBが起動されるように設定されていますが、手動で停止した場合や、何らかの理由で起動に失敗した場合は、手動で起動する必要があります。
