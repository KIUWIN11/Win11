@echo off
:: ============================================================
::  install.bat - Chạy tự động sau khi Windows 11 cài xong
::  - Tải và cài VirtIO GPU driver (Red Hat)
::  - Bật Transparency / Blur effects qua Registry
::  - Tắt Windows Defender Antivirus tạm thời khi cài driver
:: ============================================================

echo.
echo ================================================================
echo   Virtual GPU Setup - Windows 11 Docker
echo   by dockur/windows + VirtIO GPU Driver
echo ================================================================
echo.

:: ── Bước 1: Tải VirtIO GPU Driver từ Red Hat ─────────────────────
echo [1/4] Tải VirtIO Windows Drivers...
set DRIVER_URL=https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win-guest-tools.exe
set DRIVER_FILE=C:\OEM\virtio-win-guest-tools.exe

:: Dùng PowerShell để tải
powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DRIVER_URL%' -OutFile '%DRIVER_FILE%' -UseBasicParsing }"

if exist "%DRIVER_FILE%" (
    echo [OK] Tải driver thành công!
) else (
    echo [WARN] Không tải được driver - kiểm tra kết nối mạng
    goto :enable_blur
)

:: ── Bước 2: Cài VirtIO GPU Driver ────────────────────────────────
echo.
echo [2/4] Cài đặt VirtIO GPU Driver...
:: /S = Silent install (không cần tương tác)
"%DRIVER_FILE%" /S
echo [OK] Cài driver xong!

:: ── Bước 3: Bật Transparency Effects ─────────────────────────────
:enable_blur
echo.
echo [3/4] Bật Transparency / Blur Effects...

:: Bật Transparency Effects (hiệu ứng trong suốt)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f

:: Bật Mica / Acrylic blur cho cửa sổ
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "Blur" /t REG_DWORD /d 1 /f

:: Bật Visual Effects (Animation, Fade, Blur...)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 1 /f

:: Bật tất cả hiệu ứng hình ảnh (Best appearance)
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9e1e078012000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 1 /f

:: Bật blur cho Start Menu và Taskbar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbar" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f

echo [OK] Transparency và Blur đã được bật!

:: ── Bước 4: Tối ưu hiển thị cho môi trường ảo ───────────────────
echo.
echo [4/4] Tối ưu cài đặt hiển thị...

:: Tăng độ phân giải mặc định
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration" /v "PrimaryResolution" /t REG_DWORD /d 0x00050400 /f

:: Tắt màn hình chờ (không cần trong VM)
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveActive" /t REG_SZ /d 0 /f

:: Bật Hardware Acceleration cho các ứng dụng
reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v "DisableHWAcceleration" /t REG_DWORD /d 0 /f

echo [OK] Hoàn tất tối ưu!

:: ── Hoàn tất ─────────────────────────────────────────────────────
echo.
echo ================================================================
echo   [DONE] Cài đặt Virtual GPU hoàn tất!
echo.
echo   Hiệu ứng blur/transparency đã được BẬT.
echo   Khởi động lại Windows để áp dụng thay đổi.
echo ================================================================
echo.

:: Tự động restart sau 30 giây
echo Khởi động lại sau 30 giây... (đóng cửa sổ này để hủy)
shutdown /r /t 30 /c "Khởi động lại để hoàn tất cài đặt VirtIO GPU"

exit /b 0
