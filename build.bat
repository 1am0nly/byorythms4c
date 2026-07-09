@echo off
REM build.bat — полная сборка debug APK
cd /d C:\Users\a1am3\biorhythms_flutter
C:\src\flutter\bin\flutter.bat clean
C:\src\flutter\bin\flutter.bat pub get
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build apk --debug
pause