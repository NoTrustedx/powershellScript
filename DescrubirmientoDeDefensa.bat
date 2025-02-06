@echo off

REM *** 1. Informacion del Firewall ***
echo.
echo [1] Informacion del Firewall:
netsh advfirewall show allprofiles
netsh advfirewall firewall dump
netsh advfirewall show currentprofile
netsh advfirewall firewall show rule name=all
netsh advfirewall firewall show state
netsh advfirewall firewall show config

REM *** 2. Consultando con SC Query la existencia de Windows Defender ***
echo.
echo [2] Consultando con SC Query la existencia de Windows Defender
sc query windefend

REM *** 3. Listando procesos con taskkill  ***
echo.
echo [3] Listando procesos con taskkill :
tasklist.exe | findstr /i "virus cb defender cylance mc"


REM *** 4. Deteccion de servicio Sysmon ***
echo.
echo [4] Detectando servicio Sysmon:
fltmc.exe | findstr.exe 385201

REM *** 5. Descubrimiento de software de seguridad mediante WMI ***
echo.
echo [5] Descubrimiento de software de seguridad mediante WMI:
wmic.exe /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct Get displayName /Format:List

REM *** 6. Consultando exclusiones de Windows Defender mediante WMIC ***
echo.
echo [6] Consultando exclusiones de Windows Defender mediante WMIC:
wmic /Node:localhost /Namespace:\\root\Microsoft\Windows\Defender Path MSFT_MpPreference Get /format:list | find /i "DisableRealtimeMonitoring" "ExclusionPath" "ExclusionExtension" "ExclusionProcess"


echo.
echo Script finalizado.

pause
