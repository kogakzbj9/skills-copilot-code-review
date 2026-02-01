#!/bin/bash

# Start MongoDB service using systemctl
echo "Starting MongoDB service..."
sudo systemctl start mongod 2>&1

# Check if MongoDB started successfully
if sudo systemctl is-active --quiet mongod; then
    echo "MongoDB has been started successfully!"
    mongod --version
else
    echo "Failed to start MongoDB with systemctl, trying alternative method..."
    echo "Systemctl status:"
    sudo systemctl status mongod --no-pager 2>&1 || echo "Failed to retrieve systemctl status for mongod"
    echo "Checking journal logs:"
    sudo journalctl -u mongod -n 20 --no-pager 2>&1 || echo "Failed to retrieve journal logs via journalctl"
    # Create data directory if it doesn't exist
    sudo mkdir -p /var/lib/mongodb
    sudo mkdir -p /var/log/mongodb
    sudo chown -R mongodb:mongodb /var/lib/mongodb
    sudo chown -R mongodb:mongodb /var/log/mongodb
    
    # Try starting with config file
    if [ -f /etc/mongod.conf ]; then
        sudo -u mongodb mongod --config /etc/mongod.conf --fork
    else
        # Start with explicit parameters
        sudo -u mongodb mongod --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log --fork
    fi
    echo "MongoDB started with alternative method"
    mongod --version
fi

# Run sample MongoDB commands
echo "Current databases:"
mongosh --eval "db.getMongo().getDBNames()"