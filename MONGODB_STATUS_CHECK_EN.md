# How to Check MongoDB Startup Status

This guide explains how to verify if MongoDB is running properly.

## ⚠️ Important: MongoDB Auto-Start is Expected

**In Codespaces, MongoDB is configured to start automatically.**

- Auto-install & start when Codespace is first created
- Auto-start every time Codespace starts/resumes

If MongoDB is not running, something went wrong.
See [MONGODB_AUTOSTART.md](./MONGODB_AUTOSTART.md) for details.

## 🚀 Quick Check (Recommended)

The easiest way is to use the provided script:

```bash
bash check-mongodb-status.sh
```

This script automatically checks MongoDB status and displays results in a clear, easy-to-understand format.

## 📋 Manual Checking Methods

### Method 1: Using systemctl Command (Recommended)

Check MongoDB service status:

```bash
sudo systemctl status mongod
```

**Expected output when running:**
```
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled)
   Active: active (running) since ...
   ...
```

✅ **"Active: active (running)"** means MongoDB is running.

❌ **"Active: inactive (dead)"** or **"Active: failed"** means MongoDB is not running.

### Method 2: Direct Process Check

Check if MongoDB process is running:

```bash
pgrep -l mongod
```

**Expected output when running:**
```
12345 mongod
```

✅ If you see a process ID (number) and "mongod", MongoDB is running.

❌ If nothing appears, MongoDB is not running.

### Method 3: Connection Test with MongoDB Client

Test actual connection to MongoDB:

```bash
mongosh --eval "db.adminCommand('ping')"
```

**Expected output when running:**
```
{ ok: 1 }
```

✅ `{ ok: 1 }` means MongoDB is running and accessible.

❌ Error messages mean MongoDB is not running or not accessible.

### Method 4: Port Check

Check if MongoDB's default port (27017) is listening:

```bash
sudo lsof -i :27017
```

Or:

```bash
sudo netstat -tulpn | grep 27017
```

**Expected output when running:**
```
mongod    12345   mongodb   11u  IPv4  ...  TCP *:27017 (LISTEN)
```

✅ If port 27017 is LISTENING, MongoDB is running.

❌ If nothing appears, MongoDB is not running.

## 🔍 Detailed Information

### Check MongoDB Version

```bash
mongod --version
```

### Check MongoDB Logs

Display recent log entries:

```bash
sudo tail -50 /var/log/mongodb/mongod.log
```

Check for errors:

```bash
sudo grep -i error /var/log/mongodb/mongod.log | tail -20
```

### View MongoDB Configuration

```bash
cat /etc/mongod.conf
```

## ⚠️ If MongoDB is Not Running

If you confirm MongoDB is not running, start it with:

```bash
./.devcontainer/startMongoDB.sh
```

Or manually:

```bash
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

## 🔄 Troubleshooting

If MongoDB won't start or has issues, see these documents:

- 📖 **Detailed Troubleshooting**: [TROUBLESHOOTING_502_ERROR_EN.md](./TROUBLESHOOTING_502_ERROR_EN.md)
- 📖 **日本語版**: [TROUBLESHOOTING_502_ERROR.md](./TROUBLESHOOTING_502_ERROR.md)
- 📖 **Solution Summary**: [SOLUTION_SUMMARY.md](./SOLUTION_SUMMARY.md)

## 📊 Checklist

Checklist to verify MongoDB is working properly:

- [ ] `sudo systemctl status mongod` shows "active (running)"
- [ ] `pgrep -l mongod` shows a process ID
- [ ] `mongosh --eval "db.adminCommand('ping')"` returns `{ ok: 1 }`
- [ ] `sudo lsof -i :27017` shows port 27017 LISTENING
- [ ] `/var/log/mongodb/mongod.log` has no errors

If all checks pass, MongoDB is working correctly! ✅
