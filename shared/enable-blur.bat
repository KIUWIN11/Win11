@echo off
:: ============================================================
::  enable-blur.bat
::  Chạy script này trong Windows để bật blur thủ công
::  Chuột phải → "Run as administrator"
:: ============================================================

echo Dang bat hieu ung Blur / Transparency...

:: Bật Transparency
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f

:: Bật DWM Blur (Desktop Window Manager)
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v "Blur" /t REG_DWORD /d 1 /f

:: Best visual effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9e1e078012000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 1 /f

:: Restart Explorer để áp dụng
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo [DONE] Blur va Transparency da duoc bat!
echo Neu chua thay hieu ung, vao Settings - Personalization - Colors - bat "Transparency effects"
pause
