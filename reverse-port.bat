@echo off
echo ========================================================
echo Dang ket noi port 8080 giua dien thoai va may tinh...
echo ========================================================
set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
if not exist %ADB% set ADB="D:\Android\Sdk\platform-tools\adb.exe"
if not exist %ADB% set ADB=adb

REM Thu ket noi voi thiet bi USB that truoc (-d), neu loi thi thu chung
%ADB% -d reverse tcp:8080 tcp:8080 2>nul
if %errorlevel% neq 0 (
    %ADB% reverse tcp:8080 tcp:8080
)

if %errorlevel% equ 0 (
    echo.
    echo [OK] Reverse port 8080 thanh cong!
    echo Dien thoai bay gio co the goi API toi http://localhost:8080
) else (
    echo.
    echo [LOI] Chua nhan dien thoai hoac khong reverse duoc.
    echo Vui long kiem tra:
    echo 1. Dien thoai da cam day USB vao may tinh chua?
    echo 2. Da bat "Go loi qua USB" [USB Debugging] chua?
    echo 3. Da bam "Cho phep" [Allow] tren man hinh dien thoai chua?
)
echo.
pause
