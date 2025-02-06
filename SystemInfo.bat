@echo off
set output_file=reporte_sistema.txt

echo === System Information === > %output_file%
systeminfo >> %output_file%

echo. >> %output_file%
echo === Disk Information === >> %output_file%
reg query HKLM\SYSTEM\CurrentControlSet\Services\Disk\Enum >> %output_file%

echo. >> %output_file%
echo === Hostname === >> %output_file%
hostname >> %output_file%

echo. >> %output_file%
echo === Machine GUID === >> %output_file%
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography /v MachineGuid >> %output_file%

echo. >> %output_file%
echo === CPU Information === >> %output_file%
wmic cpu get name >> %output_file%

echo. >> %output_file%
echo === Memory Capacity === >> %output_file%
wmic MEMPHYSICAL get MaxCapacity >> %output_file%

echo. >> %output_file%
echo === Motherboard Information === >> %output_file%
wmic baseboard get product >> %output_file%
wmic baseboard get version >> %output_file%

echo. >> %output_file%
echo === BIOS Information === >> %output_file%
wmic bios get SMBIOSBIOSVersion >> %output_file%

echo. >> %output_file%
echo === OS Information === >> %output_file%
wmic OS get Caption,OSArchitecture,Version >> %output_file%

echo. >> %output_file%
echo === Disk Drive Information === >> %output_file%
wmic DISKDRIVE get Caption >> %output_file%

echo.
echo Script ejecutado correctamente. Revisa el archivo %output_file%.
pause
