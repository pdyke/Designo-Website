#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install docker.io -y

# Install Runners
mkdir actions-runner
cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
echo "29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278  actions-runner-linux-x64-2.311.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz 

#Configure Runners
echo -ne "\n" | ./config.sh --url https://github.com/pdyke/designo-website --token BA4ROZ6Q5IYXGUQO7457H2TFMPS44
./run.sh&
