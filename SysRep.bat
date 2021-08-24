@echo off

::This code is prompting admin if the program isnt ran as admin

CLS

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)


::Everything under this is code.

goto Start


:Start
cls
title SysRepair 2.2
echo.
echo  System Repair
echo.
echo.
echo   1: Restart Explorer.exe
echo   2: Run a SFC scan (System file check scan)
echo   3: Repair system with DISM
echo   4: Run a CheckDisk scan
echo   5: Run Netsh Winsock Reset (Restart needed)
echo   6: Program shortcuts
echo   7: Powershell commands
echo   8: Boot into Windows Recovery Environment
echo   9: Details
echo   10: Shutdown your PC
echo   11: Log out
echo   12: Exit
echo.
set /p Input=Choice:

if %Input%==1 goto REXP
if %Input%==2 goto SFCS
if %Input%==3 goto DISMS
if %Input%==4 goto CHKDSKS
if %Input%==5 goto ResetWS
if %Input%==6 goto PShortcuts
if %Input%==7 goto PowershellCmdsCheck
if %Input%==8 goto BootWinRE
if %Input%==9 goto Details
if %Input%==10 goto Shutdown
if %Input%==11 goto Logout
if %Input%==12 goto Exit

if NOT %Input%==1 goto ERR
if NOT %Input%==2 goto ERR
if NOT %Input%==3 goto ERR
if NOT %Input%==4 goto ERR
if NOT %Input%==5 goto ERR
if NOT %Input%==6 goto ERR
if NOT %Input%==7 goto ERR
if NOT %Input%==8 goto ERR
if NOT %Input%==9 goto ERR
if NOT %Input%==10 goto ERR
if NOT %Input%==11 goto ERR
if NOT %Input%==12 goto ERR

:BootWinRE
shutdown /o /r /f
set /p 1234=Please Wait...
pause
pause


:PowershellCmdsCheck
CLS
echo Checking windows version...
timeout /t 2 >nul
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" goto PowershellCmds
if "%version%" == "6.3" goto PowershellERR
if "%version%" == "6.2" goto PowershellERR
if "%version%" == "6.1" goto PowershellERR
if "%version%" == "6.0" goto PowershellERR
rem etc etc
endlocal

:PowershellERR
CLS
echo Sorry but you cannot run this menu.
pause
goto Start

:PowershellCmds
CLS
echo.
echo Powershell commands:
echo.
echo.
echo 1: Reinstall all UWP apps (Takes a long time on hard drives)
echo 2: Reset this PC
echo 3: Set the execution policy of powershell to unrestricted (Choose A)
echo 4: View TCP connections
echo 5: Clear DNS cache
echo 6: Exit
echo.
set /p Input5=Choice:

if %Input5%==1 goto PRApps
if %Input5%==2 goto PRPC
if %Input5%==3 goto PUPolicy
if %Input5%==4 goto PVConnections
if %Input5%==5 goto PCC
if %Input5%==6 goto Start

if NOT %Input5%==1 goto ERR
if NOT %Input5%==2 goto ERR
if NOT %Input5%==3 goto ERR
if NOT %Input5%==4 goto ERR
if NOT %Input5%==5 goto ERR
if NOT %Input5%==6 goto ERR


:PRApps
powershell -command "Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}"
pause
goto PowershellCmdsCheck

:PRPC
powershell -command "systemreset"
pause
goto PowershellCmdsCheck

:PUPolicy
powershell -command "Set-ExecutionPolicy Unrestricted"
pause
goto PowershellCmdsCheck

:PVConnections
powershell -command "Get-NetTCPConnection"
pause
goto PowershellCmdsCheck

:PCC
powershell -command "Clear-DnsClientCache"
pause
goto PowershellCmdsCheck

:ERR
CLS
echo The command that you have inputted is incorrect.
echo Try again.
echo.
echo 1: Go back
echo 2: Exit
set /p Input2=Choice:

if %Input2%==1 goto Start
if %Input2%==2 exit /b

if NOT %Input2%==1 goto ERR
if NOT %Input2%==2 goto ERR

:PShortcuts
CLS
echo.
echo Program shortcuts
echo.
echo.
echo 1: Windows version
echo 2: UAC settings
echo 3: Security and maintenance
echo 4: Windows troubleshooting
echo 5: Computer management
echo 6: System information
echo 7: Event log
echo 8: Programs
echo 9: System properties
echo 10: Internet options
echo 11: Internet protocol configuration
echo 12: Performance monitor
echo 13: Resource monitor
echo 14: Task manager
echo 15: CMD
echo 16: Regedit
echo 17: TeamViewer ripoff
echo 18: System restore
echo 19: Windows configuration
echo 20: Go back
echo.
echo Directly ripped off from MSConfig TM
echo.
set /p Input4=Choice:


if %Input4%==1 goto swinver
if %Input4%==2 goto sUAC
if %Input4%==3 goto sSAM
if %Input4%==4 goto sTrouble
if %Input4%==5 goto sCM
if %Input4%==6 goto SMInfo
if %Input4%==7 goto sEView
if %Input4%==8 goto sPrograms
if %Input4%==9 goto sSysP
if %Input4%==10 goto sIOptions
if %Input4%==11 goto sIConfig
if %Input4%==12 goto sPMonitor
if %Input4%==13 goto sRMonitor
if %Input4%==14 goto sTaskmgr
if %Input4%==15 goto sCmd
if %Input4%==16 goto sRegedit
if %Input4%==17 goto sNo
if %Input4%==18 goto sRecov
if %Input4%==19 goto sConfig
if %Input4%==20 goto Start

if NOT %Input4%==1 goto ERR
if NOT %Input4%==2 goto ERR
if NOT %Input4%==3 goto ERR
if NOT %Input4%==4 goto ERR
if NOT %Input4%==5 goto ERR
if NOT %Input4%==6 goto ERR
if NOT %Input4%==7 goto ERR
if NOT %Input4%==8 goto ERR
if NOT %Input4%==9 goto ERR
if NOT %Input4%==10 goto ERR
if NOT %Input4%==11 goto ERR
if NOT %Input4%==12 goto ERR
if NOT %Input4%==13 goto ERR
if NOT %Input4%==14 goto ERR
if NOT %Input4%==15 goto ERR
if NOT %Input4%==16 goto ERR
if NOT %Input4%==17 goto ERR
if NOT %Input4%==18 goto ERR
if NOT %Input4%==19 goto ERR
if NOT %Input4%==20 goto ERR


:swinver
start C:\Windows\system32\winver.exe
goto PShortcuts

:sUAC
start C:\Windows\System32\UserAccountControlSettings.exe
goto PShortcuts

:sSAM
start C:\Windows\System32\wscui.cpl
goto PShortcuts

:sTrouble
start C:\Windows\System32\control.exe /name Microsoft.Troubleshooting
goto PShortcuts

:sCM
start C:\Windows\System32\compmgmt.msc
goto PShortcuts

:sMInfo
start C:\Windows\System32\msinfo32.exe
goto PShortcuts

:sEView
start C:\Windows\System32\eventvwr.exe
goto PShortcuts

:sPrograms
start C:\Windows\System32\appwiz.cpl
goto PShortcuts

:sSysP
start C:\Windows\System32\control.exe system
goto PShortcuts

:sIOptions
start C:\Windows\System32\inetcpl.cpl
goto PShortcuts

:sIConfig
start C:\Windows\System32\cmd.exe /k %windir%\system32\ipconfig.exe
goto PShortcuts

:sPMonitor
start C:\Windows\System32\perfmon.exe
goto PShortcuts

:sRMonitor
start C:\Windows\System32\resmon.exe
goto PShortcuts

:sTaskmgr
start C:\Windows\System32\taskmgr.exe /7
goto PShortcuts

:sCmd
start C:\Windows\System32\cmd.exe
goto PShortcuts

:SRegedit
start C:\Windows\System32\regedt32.exe
goto PShortcuts

:sNo
start C:\Windows\System32\msra.exe
goto PShortcuts

:sRecov
start C:\Windows\System32\rstrui.exe
goto PShortcuts

:sConfig
start C:\Windows\System32\msconfig.exe
goto PShortcuts

:REXP
CLS
taskkill /f /im explorer.exe 
Echo Starting explorer...
start explorer.exe
echo Please wait while explorer starts. (If you still have a black screen AFTER you have been redirected to the main menu, try waiting more or resetting youre PC)
timeout /t 18 >nul
goto Start

:SFCS
CLS
@echo on
SFC /Scannow
Echo Scan completed!
@echo off
goto Start

:DISMS
CLS
Echo Starting repair..
@echo on
DISM /Online /Cleanup-Image /RestoreHealth
Echo Repair completed!
@echo off
goto Start
:Details
CLS
echo.
echo Details:
echo.
echo System Repair:
echo Version 2.2
NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    ECHO You are running this as Administrator.
) ELSE (
    ECHO You are not running this as admin (HOW)
)
echo.
echo.
echo System Details:
echo.
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" echo Windows 10 (Most stable)
if "%version%" == "6.3" echo Windows 8.1 (Most stable)
if "%version%" == "6.2" echo Windows 8. (Stable)
if "%version%" == "6.1" echo Windows 7. (Most options will not work)
if "%version%" == "6.0" echo Windows Vista. (Most options will not work and also why)
rem etc etc
endlocal
for /f "tokens=3 delims=: " %%a in (
    'cscript //nologo "%systemroot%\system32\slmgr.vbs" /dli ^| find "License Status:"' 
) do set "licenseStatus=%%a"

if /i "%licenseStatus%"=="Licensed" (
  echo System is activated/licensed
) else (
  echo System is not activated/licensed
)
echo.
pause
goto Start

:Shutdown
CLS
echo Shutting down... (It will take a minute or so)
shutdown /s /f
set /p 145=Please wait.

:Logout
CLS
echo Logging out...
shutdown /l /f
set /p 146=Please wait.

:Exit
CLS
Echo Exiting...
exit /b

:CHKDSKS
CLS
echo Run a CheckDisk scan
echo.
echo 1: Run a CheckDisk scan in read only mode (Not reccomended)
echo 2: Run a CheckDisk scan in write mode (Restart needed)
echo 3: Go back
echo.
set /p Input3=Choice:

if %Input3%==1 goto CHKDSKWM
if %Input3%==2 goto CHKDSKROM
if %Input3%==3 goto Start

if NOT %Input3%==1 goto ERR
if NOT %Input3%==2 goto ERR
if NOT %Input3%==3 goto ERR

:CHKDSKWM
CLS
echo Beggining scan...
chkdsk /f
echo Restarting...
shutdown /f /r

:CHKDSKROM
CLS
echo Beggining scan...
@echo on
chkdsk
@echo off
echo Scan completed! (No errors fixed, CHKDSK was ran in read only mode)
pause
goto Start

:ResetWS
CLS
@echo on
netsh winsock reset
@echo off
Echo Restarting...
shutdown /f /r