@echo off
setlocal enabledelayedexpansion


:menu
cls
echo 请选择操作:
echo 1. Steam 版本转 EA 版本
echo 2. EA 版本转 Steam 版本
echo 3. 退出
set /p choice="选择操作 (1/2/3): "

if "%choice%"=="1" goto steam_to_ea
if "%choice%"=="2" goto ea_to_steam
if "%choice%"=="3" goto end

echo 没这个选项, 重输。
pause
goto menu

:steam_to_ea
set /p "SteamApexPath=输入 Steam Apex 的安装路径 (e.g., E:\Steam\steamapps\common\Apex Legends): "
set /p "EAPath=输入 EA App 的安装路径 (e.g., E:\App\EA App): "

if not exist "%EAPath%\Apex" (
    mkdir "%EAPath%\Apex"
)

for %%i in ("paks" "audio" "media" "cfg" "bin" "Crashpad" "LiveAPI" "materials" "r2") do (
    mklink /J "%EAPath%\Apex\%%i" "%SteamApexPath%\%%i" >NUL 2>NUL
)

echo 执行完成, 打开 EA App, 下载或修补 APEX, 直接运行即可
goto end

:ea_to_steam
set /p "EAApexPath=输入 EA Apex 的安装路径 (e.g., E:\App\EA App\Apex): "
set /p "SteamPath=输入 Steam 的库路径 (e.g., E:\Steam\steamapps\common): "

if not exist "%SteamPath%\Apex Legends" (
    mkdir "%SteamPath%\Apex Legends"
)

for %%i in ("paks" "audio" "media" "cfg" "bin" "Crashpad" "LiveAPI" "materials" "r2") do (
    mklink /J "%SteamPath%\Apex Legends\%%i" "%EAApexPath%\%%i" >NUL 2>NUL
)

echo 执行完成, 打开 Steam, 下载或修补 APEX, 直接运行即可
goto end

:end
pause
endlocal