# Script para descubrimiento de software de seguridad en Windows

<#
    .SYNOPSIS
    Este script realiza un reconocimiento del software de seguridad instalado en un sistema Windows.

    .DESCRIPTION
    Utiliza cmdlets de PowerShell y comandos externos para recopilar información sobre el software de seguridad, 
    incluyendo el estado del firewall, servicios y procesos de seguridad, detección de Sysmon, información del 
    antivirus mediante WMI y exclusiones de Windows Defender.

    .PARAMETER ComputerName
    Especifica el nombre del equipo en el que se ejecutará el script. El valor predeterminado es el equipo local.

    .PARAMETER EnableVerbose
    Activa la visualización de información detallada durante la ejecución del script.

    .EXAMPLE
    .\Descubrir-Software-Seguridad.ps1

    .EXAMPLE
    .\Descubrir-Software-Seguridad.ps1 -ComputerName "equipo-remoto" -EnableVerbose
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$ComputerName = $env:COMPUTERNAME,

    [Parameter(Mandatory=$false)]
    [switch]$EnableVerbose
)

BEGIN {
    if ($EnableVerbose) { Write-Host "Iniciando script en: $ComputerName" }
}

PROCESS {
    # --- 1. Información del Firewall ---
    Write-Host "`n[+] Información del Firewall:"
    try {
        $FirewallInfo = Get-NetFirewallProfile | Select-Object Name, Enabled | Format-Table -AutoSize | Out-String
        Write-Host $FirewallInfo

        if ($EnableVerbose) {
            Write-Host "`nConfiguración detallada del Firewall:"
            Get-NetFirewallSetting | Format-List *
            Write-Host "`nReglas del Firewall (activas):"
            Get-NetFirewallRule | Where-Object {$_.Enabled -eq "True"} | 
                Select-Object DisplayName, Enabled, Description, Direction, Profile | 
                Format-Table -AutoSize
        }
    }
    catch {
        Write-Warning "Error al obtener información del firewall: $_"
    }

    # --- 2. Servicios y procesos relacionados con seguridad ---
    Write-Host "`n[+] Servicios y procesos relacionados con seguridad:"
    try {
        # Servicios de seguridad
        $Services = Get-Service | Where-Object {
            $_.DisplayName -match "security|antivirus|firewall|sysmon"
        } | Select-Object Name, DisplayName, Status | Format-Table -AutoSize | Out-String
        Write-Host $Services

        # Procesos de seguridad
        $Processes = Get-Process | Where-Object {
            $_.Description -match "security|virus|carbonblack|defender|cylance|mcafee" -or 
            $_.ProcessName -match "sysmon"
        } | Select-Object Name, Description, ProcessName, Id | Format-Table -AutoSize | Out-String
        Write-Host $Processes
    }
    catch {
        Write-Warning "Error al obtener información de servicios o procesos: $_"
    }

    # --- 3. Detección de Sysmon ---
    Write-Host "`n[+] Detección de Sysmon:"
    try {
        $SysmonService = Get-Service -Name "Sysmon" -ErrorAction SilentlyContinue
        if ($SysmonService -and $SysmonService.Status -eq "Running") {
            Write-Host "Sysmon está en ejecución."
            $SysmonDriver = fltmc.exe | findstr.exe 385201 | Out-String
            Write-Host $SysmonDriver
        } else {
            Write-Host "Sysmon no está instalado o no está en ejecución."
        }
    }
    catch {
        Write-Warning "Error al detectar Sysmon: $_"
    }

    # --- 4. Software de seguridad mediante WMI ---
    Write-Host "`n[+] Software de seguridad mediante WMI:"
    try {
        $AntiVirusInfo = Get-CimInstance -Namespace root/securityCenter2 -ClassName antivirusproduct | 
            Select-Object displayName, pathToSignedProductExe, productState | 
            Format-Table -AutoSize | Out-String
        Write-Host $AntiVirusInfo
    }
    catch {
        Write-Warning "Error al obtener información del antivirus mediante Get-CimInstance: $_"
    }

    try {
        $AntiVirusInfo2 = Get-WmiObject -Namespace root\securitycenter2 -Class antivirusproduct | 
            Select-Object displayName, pathToSignedProductExe, productState | 
            Format-Table -AutoSize | Out-String
        Write-Host $AntiVirusInfo2
    }
    catch {
        Write-Warning "Error al obtener información del antivirus mediante Get-WmiObject: $_"
    }

    # --- 5. Exclusiones de Windows Defender ---
    Write-Host "`n[+] Exclusiones de Windows Defender:"
    try {
        $Exclusions = Get-MpPreference | Select-Object ExclusionPath, ExclusionExtension, ExclusionProcess, DisableRealtimeMonitoring | 
            Format-Table -AutoSize | Out-String
        Write-Host $Exclusions
    }
    catch {
        Write-Warning "Error al obtener exclusiones de Windows Defender: $_"
    }
}

END {
    Write-Host "`n[+] Análisis finalizado."
}
