@echo off
setlocal enableextensions disabledelayedexpansion
chcp 65001 > nul
color f
title Shatterline Easy Anti-Cheat manager by Liub0myr
:: https://github.com/Liub0myr/Shatterline_EAC_manager

::---main---
call :checkLang
if %errorlevel% == 0 (goto ukrLang) else (goto engLang)
:main_langBack

call :checkEAClocation
if %errorlevel% == 0 (goto main_skip_cdEAClocation)

call :cdEAClocation
if not %errorlevel% == 0 (
	echo %lang_main_error_cdEAClocation_line1_part1%%errorlevel%%lang_main_error_cdEAClocation_line1_part2%
	echo %lang_main_error_cdEAClocation_line2%
	echo %lang_error_go_help%
	pause
	exit
)

:main_skip_cdEAClocation

:menu
set user_input=nul
echo 1. %lang_main_menu_option1%
echo 2. %lang_main_menu_option2%
echo 0. %lang_main_menu_option3%
set /p user_input=
if "%user_input%"=="1" (
	color f
	cls
	call :script_uninstall
	goto menu
)
if "%user_input%"=="2" (
	color f
	cls
	call :script_install
	goto menu
)
if "%user_input%"=="0" (
	color f
	cls
	::Run a browser WITHOUT admin rights
	runas /trustlevel:0x20000 "cmd /c start https://github.com/Liub0myr/Shatterline_EAC_manager"
	goto menu
)
cls
echo %lang_main_menu_onlydigit%
goto menu
::---main---



:checkLang
reg query "HKEY_CURRENT_USER\Control Panel\Desktop\MuiCached" /v MachinePreferredUILanguages | findstr "uk-UA" > nul
exit /b %errorlevel%


:checkEAClocation
if exist "EasyAntiCheat_EOS_Setup.exe" (exit /b 0) else (exit /b 1)


:cdEAClocation
::get Steam location
for /f "tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam" /v "SteamPath" 2^>nul ^| find "SteamPath"') DO (set EAClocation=%%B)
::get game location from steamapps\libraryfolders.vdf
if not exist "%EAClocation%\steamapps\libraryfolders.vdf" (exit /b 1)
cd /d %EAClocation%\steamapps
for /F "tokens=1,2 delims=		" %%G IN (libraryfolders.vdf) DO (
	if %%G == "path" (set EAClocation=%%H)
	if %%G == "2087030" (goto breakForLibraryfolders)
)
exit /b 2
:breakForLibraryfolders
:: replacements
set EAClocation=%EAClocation:\\=\%
set EAClocation=%EAClocation:"=%
if not exist "%EAClocation%\steamapps\common\Shatterline\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" (exit /b 3)
cd /d "%EAClocation%\steamapps\common\Shatterline\EasyAntiCheat"
exit /b 0

:script_uninstall
echo %lang_script_uninstalling%
EasyAntiCheat_EOS_Setup.exe uninstall 0cbc7c03131b479ab1e5ec67f4da4290
if %errorlevel% == 1223 (
	color e
	echo %lang_script_error_rights%
	echo %lang_error_go_help%
	pause
	color f
	cls
	exit /b 1223
)
if %errorlevel% == 4 (
	echo %lang_script_info_EACwasNotInstalled%
	pause
	cls
	exit /b 4
)
if not %errorlevel% == 0 (
	color c
	echo %lang_script_error_unknown%
	echo %lang_error_go_help%
	pause
	color f
	cls
	exit /b 1
)
echo %lang_script_completed%
pause
cls
exit /b 0

:script_install
echo %lang_script_installing%
EasyAntiCheat_EOS_Setup.exe install 0cbc7c03131b479ab1e5ec67f4da4290
if %errorlevel% == 1223 (
	color e
	echo %lang_script_error_rights%
	echo %lang_error_go_help%
	pause
	color f
	cls
	exit /b 1223
)
if not %errorlevel% == 0 (
	color c
	echo %lang_script_error_unknown%
	echo %lang_error_go_help%
	pause
	color f
	cls
	exit /b 1
)
echo %lang_script_completed%
pause
cls
exit /b 0


:ukrLang
set lang_main_menu_option1=Видалити античіт
set lang_main_menu_option2=Встановити античіт
set lang_main_menu_option3=Онлайн довідка (відкриється браузер)
set lang_main_menu_onlydigit=Будь-ласка, введiть лише цифру

set lang_main_error_cdEAClocation_line1_part1=Помилка 3
set lang_main_error_cdEAClocation_line1_part2=. Не вдалось автоматично виявити розташування гри
set lang_main_error_cdEAClocation_line2=Перемістіть цей файл у папку Shatterline\EasyAntiCheat
set lang_error_go_help=Детальніше про помилку в онлайн довідці

set lang_script_completed=Готово!
set lang_script_uninstalling=Видаляю Easy Anti-Cheat...
set lang_script_installing=Встановлюю Easy Anti-Cheat...
set lang_script_error_unknown=Сталася помилка при роботі з античітом
set lang_script_error_rights=Помилка 1223. У доступі відмовлено. Зміни не були внесені
set lang_script_info_EACwasNotInstalled=Виявлено, що Easy Anti-Cheat не був встановлений на вашому ПК

goto main_langBack


:engLang

set lang_main_menu_option1=Remove anti-cheat
set lang_main_menu_option2=Install anti-cheat
set lang_main_menu_option3=Online help (browser will open)
set lang_main_menu_onlydigit=Please enter the digit of the corresponding action

set lang_main_error_cdEAClocation_line1_part1=Error 3
set lang_main_error_cdEAClocation_line1_part2=. Failed to automatically detect game location
set lang_main_error_cdEAClocation_line2=Move this file to a folder Shatterline\EasyAntiCheat
set lang_error_go_help=Read more about the error in the online help

set lang_script_completed=Done!
set lang_script_uninstalling=Uninstalling Easy Anti-Cheat...
set lang_script_installing=Installing Easy Anti-Cheat...
set lang_script_error_unknown=An error occurred while working with the anti-cheat
set lang_script_error_rights=Error 1223. Access is denied. Changes were not applied!
set lang_script_info_EACwasNotInstalled=It was detected that Easy Anti-Cheat was not installed on your PC

goto main_langBack