#!/bin/bash

echo "Starting 24/7 SR-IOV mesh test..."

# Start the continuous test in background with nohup
nohup ./continuous-mesh-test.sh > mesh-test.log 2>&1 &

echo "Continuous mesh test started (PID: $!)"
echo "Monitor with: tail -f mesh-test.log"
echo "Stop with: pkill -f continuous-mesh-test.sh"
