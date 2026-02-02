#!/bin/bash
# MongoDB Status Check Script
# This script checks if MongoDB is running and provides clear status information

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  MongoDB Status Check / MongoDB起動状況確認"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Initialize status flags
mongodb_running=false
can_connect=false

# Check 1: Process check using pgrep
echo "🔍 Check 1: Checking MongoDB process / プロセス確認中..."
if pgrep -x mongod > /dev/null 2>&1; then
    pid=$(pgrep -x mongod)
    echo "   ✅ MongoDB process is running (PID: $pid)"
    echo "      MongoDBプロセスが実行中です (PID: $pid)"
    mongodb_running=true
else
    echo "   ❌ MongoDB process is NOT running"
    echo "      MongoDBプロセスが実行されていません"
fi
echo ""

# Check 2: systemctl status (if available)
echo "🔍 Check 2: Checking service status / サービス状態確認中..."
if command -v systemctl > /dev/null 2>&1; then
    if sudo systemctl is-active --quiet mongod 2>/dev/null; then
        echo "   ✅ MongoDB service is active"
        echo "      MongoDBサービスがアクティブです"
        mongodb_running=true
    else
        status=$(sudo systemctl is-active mongod 2>&1)
        echo "   ❌ MongoDB service is not active (status: $status)"
        echo "      MongoDBサービスがアクティブではありません (状態: $status)"
    fi
else
    echo "   ⚠️  systemctl not available, skipping this check"
    echo "      systemctlが利用できません。このチェックをスキップします"
fi
echo ""

# Check 3: Port check
echo "🔍 Check 3: Checking MongoDB port (27017) / ポート確認中..."
if command -v lsof > /dev/null 2>&1; then
    if sudo lsof -i :27017 > /dev/null 2>&1; then
        echo "   ✅ Port 27017 is listening"
        echo "      ポート27017がリッスンしています"
        mongodb_running=true
    else
        echo "   ❌ Port 27017 is NOT listening"
        echo "      ポート27017がリッスンしていません"
    fi
else
    echo "   ⚠️  lsof not available, skipping this check"
    echo "      lsofが利用できません。このチェックをスキップします"
fi
echo ""

# Check 4: Connection test
echo "🔍 Check 4: Testing MongoDB connection / 接続テスト中..."
if command -v mongosh > /dev/null 2>&1; then
    if mongosh --eval "db.adminCommand('ping')" --quiet > /dev/null 2>&1; then
        echo "   ✅ Successfully connected to MongoDB"
        echo "      MongoDBへの接続に成功しました"
        can_connect=true
        
        # Get MongoDB version
        version=$(mongosh --eval "db.version()" --quiet 2>/dev/null | tr -d '\n')
        if [ ! -z "$version" ]; then
            echo "      MongoDB version: $version"
            echo "      MongoDBバージョン: $version"
        fi
    else
        echo "   ❌ Cannot connect to MongoDB"
        echo "      MongoDBに接続できません"
    fi
else
    echo "   ⚠️  mongosh not available, skipping connection test"
    echo "      mongoshが利用できません。接続テストをスキップします"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Summary / 結果まとめ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$mongodb_running" = true ] && [ "$can_connect" = true ]; then
    echo "✅ STATUS: MongoDB is RUNNING and ACCESSIBLE"
    echo "   状態: MongoDBは正常に起動しており、アクセス可能です"
    echo ""
    echo "   You can start your FastAPI application now!"
    echo "   FastAPIアプリケーションを起動できます！"
    exit 0
elif [ "$mongodb_running" = true ]; then
    echo "⚠️  STATUS: MongoDB process is running but cannot connect"
    echo "   状態: MongoDBプロセスは実行中ですが接続できません"
    echo ""
    echo "   Check MongoDB logs for errors:"
    echo "   MongoDBのログでエラーを確認してください："
    echo "   sudo tail -50 /var/log/mongodb/mongod.log"
    exit 1
else
    echo "❌ STATUS: MongoDB is NOT RUNNING"
    echo "   状態: MongoDBが起動していません"
    echo ""
    echo "   To start MongoDB, run:"
    echo "   MongoDBを起動するには、以下を実行してください："
    echo ""
    echo "   ./.devcontainer/startMongoDB.sh"
    echo ""
    echo "   Or manually:"
    echo "   または手動で："
    echo ""
    echo "   sudo mongod --fork --logpath /var/log/mongodb/mongod.log"
    echo ""
    echo "   For more help, see:"
    echo "   詳細なヘルプについては以下を参照："
    echo "   - MONGODB_STATUS_CHECK.md"
    echo "   - TROUBLESHOOTING_502_ERROR.md"
    exit 1
fi
