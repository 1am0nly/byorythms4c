@echo off
REM check.bat — быстрая проверка без сборки
cd /d C:\Users\a1am3\biorhythms_flutter
C:\src\flutter\bin\flutter.bat pub get
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
pause