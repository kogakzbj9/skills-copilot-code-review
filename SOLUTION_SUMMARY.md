# HTTP 502 エラー解決のまとめ / HTTP 502 Error Resolution Summary

## 日本語 (Japanese)

### 問題の原因
ポートタブからウェブページを開こうとしたときに発生する **HTTP ERROR 502** は、**MongoDBが起動していない**ことが原因です。

### MongoDBの状態を確認
MongoDBが起動しているか確認するには：

```bash
bash check-mongodb-status.sh
```

詳細な確認手順は：
- 📖 [MONGODB_STATUS_CHECK.md](./MONGODB_STATUS_CHECK.md) (MongoDB起動状況確認ガイド)

### 解決方法
ターミナルで以下のコマンドを実行してください：

```bash
./.devcontainer/startMongoDB.sh
```

その後、VS Codeの「実行とデバッグ」タブから再度アプリケーションを起動してください。

### 詳細なトラブルシューティング
完全な診断ガイドについては、以下のドキュメントをご覧ください：
- 📖 [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md) (日本語)

### このPRで実装された改善点
1. **高速エラー検出**: アプリケーションが無限にハングする代わりに、5秒でエラーを表示
2. **明確なエラーメッセージ**: 問題と解決方法を含む分かりやすいメッセージ
3. **包括的なドキュメント**: 詳細なトラブルシューティングガイド
4. **改善されたREADME**: 前提条件とセットアップ手順を明記

---

## English

### Root Cause
The **HTTP ERROR 502** that occurs when opening the webpage from the Ports tab is caused by **MongoDB not running**.

### Check MongoDB Status
To check if MongoDB is running:

```bash
bash check-mongodb-status.sh
```

For detailed checking procedures, see:
- 📖 [MONGODB_STATUS_CHECK.md](./MONGODB_STATUS_CHECK.md) (MongoDB Status Check Guide)

### Solution
Run this command in the terminal:

```bash
./.devcontainer/startMongoDB.sh
```

Then restart the application from VS Code's "Run and Debug" tab.

### Detailed Troubleshooting
For a complete diagnostic guide, see:
- 📖 [TROUBLESHOOTING_502_ERROR_EN.md](./TROUBLESHOOTING_502_ERROR_EN.md) (English)

### Improvements Implemented in this PR
1. **Fast Error Detection**: Application fails in 5 seconds with clear error instead of hanging indefinitely
2. **Clear Error Messages**: Helpful message with problem description and solution steps
3. **Comprehensive Documentation**: Detailed troubleshooting guides
4. **Improved README**: Prerequisites and setup instructions clearly documented

---

## Technical Changes

### Modified Files
1. **src/backend/database.py**
   - Added connection timeouts (5 seconds)
   - Added specific exception handling for MongoDB connection errors
   - Added clear, formatted error message

2. **src/README.md**
   - Added Prerequisites section
   - Added MongoDB Status Check section
   - Added Troubleshooting section
   - Updated Getting Started instructions

3. **TROUBLESHOOTING_502_ERROR.md** (NEW)
   - Japanese troubleshooting guide

4. **TROUBLESHOOTING_502_ERROR_EN.md** (NEW)
   - English troubleshooting guide

5. **MONGODB_STATUS_CHECK.md** (NEW)
   - Japanese MongoDB status check guide
   - Step-by-step procedures to verify MongoDB is running

6. **check-mongodb-status.sh** (NEW)
   - Automated script to check MongoDB status
   - Provides clear bilingual output
   - Multiple verification checks

### Before vs After

**Before:**
- Application hung indefinitely when MongoDB wasn't running
- No clear indication of what went wrong
- Required manual process termination
- Very difficult to diagnose

**After:**
- Application fails fast (5 seconds)
- Clear error message explaining the problem
- Actionable solution steps provided
- Easy to diagnose and fix

---

## コードの変更点 / Code Changes

No changes were made to application logic or features. All changes are focused on:
- Error handling and diagnostics
- User experience improvements
- Documentation

The application functionality remains exactly the same when MongoDB is running correctly.
