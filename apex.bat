@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

set /p "SteamApexPath=输入Steam版Apex的安装路径 (e.g., E:\Steam\steamapps\common\Apex Legends): "
set /p "EAPath=输入EA App的安装路径 (e.g., E:\App\EA App): "

mklink /J "%EAPath%\Apex" "%SteamApexPath%"

set "SteamBackup=%SteamApexPath%\ApexBackup\Steam"
set "EABackup=%SteamApexPath%\ApexBackup\EA"
if not exist "%SteamBackup%" mkdir "%SteamBackup%"
if not exist "%EABackup%" mkdir "%EABackup%"

:confirm_steam
set /p "confirm=Steam版Apex是否可以正常启动? 按y继续: "
if /i "%confirm%" neq "y" goto confirm_steam

echo 正在备份Steam版文件...
for %%F in (amd_ags_x64.dll binkawin64.dll installscript.vdf mileswin64.dll OriginSDK.dll r5apex.exe r5apex_dx12.exe) do (
    if exist "%SteamApexPath%\%%F" robocopy "%SteamApexPath%" "%SteamBackup%" %%F /MOV > NUL 2>&1
)
if exist "%SteamApexPath%\bin" robocopy "%SteamApexPath%\bin" "%SteamBackup%\bin" /E /MOV > NUL 2>&1
if exist "%SteamApexPath%\EasyAntiCheat" robocopy "%SteamApexPath%\EasyAntiCheat" "%SteamBackup%\EasyAntiCheat" /E /MOV > NUL 2>&1




echo 添加环境变量 STEAM_APEX_PATH...
echo 等待期间请在 EA App 点击下载 Apex 并修补
setx STEAM_APEX_PATH "%SteamApexPath%"

:confirm_ea
set /p "confirm=EA版Apex是否可以正常启动? 按y继续: "
if /i "%confirm%" neq "y" goto confirm_ea

echo 正在备份EA版文件...
for %%F in (amd_ags_x64.dll binkawin64.dll mileswin64.dll OriginSDK.dll r5apex.exe r5apex_dx12.exe) do (
    if exist "%EAPath%\Apex\%%F" robocopy "%EAPath%\Apex" "%EABackup%" %%F /MOV > NUL 2>&1
)
if exist "%EAPath%\Apex\bin" robocopy "%EAPath%\Apex\bin" "%EABackup%\bin" /E /MOV > NUL 2>&1
if exist "%EAPath%\Apex\EasyAntiCheat" robocopy "%EAPath%\Apex\EasyAntiCheat" "%EABackup%\EasyAntiCheat" /E /MOV > NUL 2>&1

echo 创建切换到EA版的快捷方式...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%~dp0SwitchToEA.lnk'); $Shortcut.TargetPath = '%%ComSpec%%'; $Shortcut.Arguments = '/c del \"%%STEAM_APEX_PATH%%\installscript.vdf\" & xcopy \"%%STEAM_APEX_PATH%%\ApexBackup\EA\*\" \"%%STEAM_APEX_PATH%%\" /E /I /Y & start \"\" \"%%STEAM_APEX_PATH%%\r5apex.exe\"'; $Shortcut.WorkingDirectory = '%%STEAM_APEX_PATH%%'; $Shortcut.Save()"

echo 创建切换到Steam版的快捷方式...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%~dp0SwitchToSteam.lnk'); $Shortcut.TargetPath = '%%ComSpec%%'; $Shortcut.Arguments = '/c xcopy \"%%STEAM_APEX_PATH%%\ApexBackup\Steam\*\" \"%%STEAM_APEX_PATH%%\" /E /I /Y & start \"\" \"%%STEAM_APEX_PATH%%\r5apex.exe\"'; $Shortcut.WorkingDirectory = '%%STEAM_APEX_PATH%%'; $Shortcut.Save()"


echo 备份和快捷方式已创建完成。
echo SwitchToEA.lnk - 切换到EA版本并启动
echo SwitchToSteam.lnk - 切换到Steam版本并启动
echo 双击对应的快捷方式即可切换并启动游戏。

pause
