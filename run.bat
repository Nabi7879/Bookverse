@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK was not found. Install Flutter and add its bin folder to PATH.
  echo Setup guide: https://docs.flutter.dev/get-started/install/windows
  pause
  exit /b 1
)

echo Installing the locked project dependencies...
flutter pub get
if errorlevel 1 (
  echo Dependency installation failed. Check your internet connection and try again.
  pause
  exit /b 1
)

echo Starting BookVerse...
flutter run
if errorlevel 1 (
  echo App could not start. Make sure an emulator or device is available.
  pause
  exit /b 1
)
