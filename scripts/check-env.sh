#!/bin/bash

# BondConnect: Developer Environment Check
# This script verifies that the environment is ready for development.

echo "🔍 Checking BondConnect Dev Environment..."

# 1. Check Node.js
NODE_VER=$(node -v | cut -d 'v' -f 2 | cut -d '.' -f 1)
if [ "$NODE_VER" -ge 20 ]; then
  echo "✅ Node.js $(node -v)"
else
  echo "❌ Node.js version 20+ required. Current: $(node -v)"
  exit 1
fi

# 2. Check Firebase CLI
if command -v firebase &> /dev/null; then
  echo "✅ Firebase CLI $(firebase --version)"
else
  echo "❌ Firebase CLI not found. Run: npm install -g firebase-tools"
  exit 1
fi

# 3. Check EAS CLI
if command -v eas &> /dev/null; then
  echo "✅ EAS CLI $(eas --version)"
else
  echo "❌ EAS CLI not found. Run: npm install -g eas-cli"
  exit 1
fi

# 4. Check Firebase Login
if firebase projects:list &> /dev/null; then
  echo "✅ Firebase Login confirmed"
else
  echo "❌ Not logged into Firebase. Run: firebase login"
  exit 1
fi

# 5. Check Project Alias
PROJECT=$(firebase use)
echo "✅ Active Project: $PROJECT"

# 6. Check .env file
if [ -f .env ]; then
  echo "✅ .env file found"
else
  echo "⚠️  .env file missing. Run: cp .env.example .env"
fi

# 7. Check Emulator Connectivity
if curl -s http://localhost:4000 &> /dev/null; then
  echo "✅ Firebase Emulator is running"
else
  echo "⚠️  Firebase Emulator is NOT running. Run: firebase emulators:start"
fi

echo "🚀 Environment looks good!"
