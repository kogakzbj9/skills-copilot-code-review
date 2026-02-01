# Troubleshooting HTTP 502 Error

## Problem Symptoms

When trying to open the webpage from the Ports tab, you see this error:

```
This site can't be reached
organic-space-robot-qpqjxvx7rxgf4jrx-8000.app.github.dev is currently unable to handle this request.
HTTP ERROR 502
```

## Root Cause

**Cause**: The MongoDB database service is not running, which causes the FastAPI application to hang during startup.

### Technical Details

1. In `src/app.py` line 22, `database.init_database()` is called during module import
2. This function attempts to connect to MongoDB (line 43 in `src/backend/database.py`)
3. When MongoDB is not running, the connection attempt hangs indefinitely
4. As a result, the server never fully starts and cannot handle requests on port 8000, causing HTTP 502 errors

## Diagnostic Steps (Troubleshooting Methods)

### 1. Check MongoDB Status

Run this command in the terminal:

```bash
sudo systemctl status mongod
```

or

```bash
pgrep -l mongod
```

**Expected result**: Should show MongoDB process is running.

**Problem indicator**: If "active (running)" is not displayed or process is not found, MongoDB is not running.

### 2. Check MongoDB Logs

```bash
sudo cat /var/log/mongodb/mongod.log | tail -50
```

This will show any error messages or reasons for startup failures.

### 3. Check FastAPI Application Status

In the debug console or terminal, check if the application is hanging:

```bash
ps aux | grep uvicorn
```

If no uvicorn process exists, the application failed to start.

## Solution

### Method 1: Start MongoDB (Recommended)

In the Codespaces terminal, run the startup script:

```bash
./.devcontainer/startMongoDB.sh
```

Or start manually:

```bash
sudo mongod --fork --logpath /var/log/mongodb/mongod.log
```

### Method 2: Initial Setup After MongoDB Installation

If MongoDB is not installed:

```bash
# Install MongoDB
./.devcontainer/installMongoDB.sh

# Start MongoDB
./.devcontainer/startMongoDB.sh
```

### Method 3: Restart Codespace

Completely restarting the Codespace will execute the `postStartCommand` which automatically starts MongoDB:

1. Stop the Codespace
2. Start it again
3. Wait for startup to complete (including postStartCommand execution)

## Verification

1. Confirm MongoDB is running:
   ```bash
   mongosh --eval "db.version()"
   ```
   
2. Start the FastAPI application:
   - Use VS Code's "Run and Debug" tab
   - Or in terminal: `uvicorn src.app:app --reload`

3. Check port 8000 in the Ports tab and open in browser

4. Verify the "Mergington High School" webpage displays correctly

## Prevention

To avoid this issue in the future:

1. Always verify MongoDB is running before starting the application
2. Ensure `.devcontainer/postStart.sh` script completes successfully
3. After Codespace resumes from sleep, MongoDB may need to be restarted

## Additional Diagnostics

If the above steps don't resolve the issue:

### Check Data Directory Permissions

```bash
ls -la /data/db
sudo chown -R mongodb:mongodb /data/db
```

### Check for Port Conflicts

```bash
sudo lsof -i :27017
```

Verify port 27017 (MongoDB's default port) is not being used by another process.

### Check System Resources

```bash
df -h
free -h
```

Verify sufficient disk space and memory are available.

## Summary

**Most Likely Cause**: MongoDB service is not running

**Quickest Fix**: Run `./.devcontainer/startMongoDB.sh`

**Long-term Solution**: Codespaces is configured to automatically start MongoDB on startup, but if manually stopped or if startup fails for any reason, manual intervention is required.
