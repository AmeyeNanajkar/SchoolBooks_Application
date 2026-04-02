#!/bin/bash
# Launch script for SchoolBooks Flutter app

cd "$(dirname "$0")"

echo "=========================================="
echo "SchoolBooks Flutter Launcher"
echo "=========================================="
echo ""
echo "1. Run on Android Emulator (Default)"
echo "2. Run on Web (Chrome)"
echo "3. Run on Windows Desktop"
echo "4. Show available devices"
echo "0. Exit"
echo ""

read -p "Choose option: " choice

case $choice in
  1)
    echo "Starting on Android Emulator..."
    flutter run -d emulator-5554
    ;;
  2)
    echo "Starting on Chrome..."
    flutter run -d chrome
    ;;
  3)
    echo "Starting on Windows..."
    flutter run -d windows
    ;;
  4)
    echo "Available devices:"
    flutter devices
    ;;
  0)
    echo "Goodbye!"
    ;;
  *)
    echo "Invalid choice"
    ;;
esac
