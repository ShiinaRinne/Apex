@echo off
setlocal enabledelayedexpansion


:menu
cls
echo ��ѡ�����:
echo 1. Steam �汾ת EA �汾
echo 2. EA �汾ת Steam �汾
echo 3. �˳�
set /p choice="ѡ����� (1/2/3): "

if "%choice%"=="1" goto steam_to_ea
if "%choice%"=="2" goto ea_to_steam
if "%choice%"=="3" goto end

echo û���ѡ��, ���䡣
pause
goto menu

:steam_to_ea
set /p "SteamApexPath=���� Steam Apex �İ�װ·�� (e.g., E:\Steam\steamapps\common\Apex Legends): "
set /p "EAPath=���� EA App �İ�װ·�� (e.g., E:\App\EA App): "

if not exist "%EAPath%\Apex" (
    mkdir "%EAPath%\Apex"
)

for %%i in ("paks" "audio" "media" "cfg" "bin" "Crashpad" "LiveAPI" "materials" "r2") do (
    mklink /J "%EAPath%\Apex\%%i" "%SteamApexPath%\%%i" >NUL 2>NUL
)

echo ִ�����, �� EA App, ���ػ��޲� APEX, ֱ�����м���
goto end

:ea_to_steam
set /p "EAApexPath=���� EA Apex �İ�װ·�� (e.g., E:\App\EA App\Apex): "
set /p "SteamPath=���� Steam �Ŀ�·�� (e.g., E:\Steam\steamapps\common): "

if not exist "%SteamPath%\Apex Legends" (
    mkdir "%SteamPath%\Apex Legends"
)

for %%i in ("paks" "audio" "media" "cfg" "bin" "Crashpad" "LiveAPI" "materials" "r2") do (
    mklink /J "%SteamPath%\Apex Legends\%%i" "%EAApexPath%\%%i" >NUL 2>NUL
)

echo ִ�����, �� Steam, ���ػ��޲� APEX, ֱ�����м���
goto end

:end
pause
endlocal