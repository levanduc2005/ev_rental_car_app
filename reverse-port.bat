@echo off
echo ========================================================
echo Dang ket noi port 8080 giua dien thoai va may tinh...
echo ========================================================
"D:\Android\Sdk\platform-tools\adb.exe" reverse tcp:8080 tcp:8080
if %errorlevel% equ 0 (
    echo.
    echo [OK] Reverse port thanh cong!
    echo Dien thoai bay gio co the goi API toi http://localhost:8080
) else (
    echo.
    echo [LOI] Chua nhan dien thoai.
    echo Vui long kiem tra:
    echo 1. Dien thoai da cam day USB vao may tinh chua?
    echo 2. Da bat "Go loi qua USB" (USB Debugging) chua?
    echo 3. Da bam "Cho phep" (Allow) tren man hinh dien thoai chua?
)
echo.
pause
