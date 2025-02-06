# Script mejorado para obtener información del sistema con colores y banner

# Función para mostrar un banner con colores
function Show-Banner {
    param(
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "White",
        [ConsoleColor]$BackgroundColor = "DarkBlue"
    )

    Write-Host ""  # Línea en blanco antes del banner
    $bannerLine = "*" * ($Text.Length + 4)  # Ajusta el ancho según el texto
    Write-Host $bannerLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "* $Text *" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host $bannerLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host ""  # Línea en blanco después del banner
}

# Función para obtener información del sistema
function Get-SystemInfo {
    Show-Banner -Text "Información del Sistema" -ForegroundColor "Yellow" -BackgroundColor "DarkGreen"
    
    try {
        $systemInfo = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture, CSName, Manufacturer, SerialNumber
        
        if ($systemInfo) {
            $systemInfoFormatted = @(
                "Sistema: $($systemInfo.Caption)",
                "Versión: $($systemInfo.Version)",
                "Arquitectura: $($systemInfo.OSArchitecture)",
                "Nombre del Equipo: $($systemInfo.CSName)",
                "Fabricante: $($systemInfo.Manufacturer)",
                "Número de Serie: $($systemInfo.SerialNumber)"
            )
            
            $systemInfoFormatted | ForEach-Object { Write-Host $_ -ForegroundColor "Cyan" }
            $systemInfoFormatted | Out-File -FilePath $script:SystemInfoFile -Encoding UTF8
        } else {
            Write-Host "No se pudo obtener la información del sistema." -ForegroundColor "Red"
        }
    } catch {
        Write-Host "Error al obtener la información del sistema: $_" -ForegroundColor "Red"
    }
}

# Función para obtener parches instalados
function Get-InstalledPatches {
    Show-Banner -Text "Parches Instalados" -ForegroundColor "Magenta" -BackgroundColor "Black"
    
    try {
        $patches = Get-HotFix | Select-Object Description, HotFixID, InstalledOn
        if ($patches) {
            $patches | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor "White"
            $patches | Export-Csv -Path $script:PatchesFile -NoTypeInformation -Encoding UTF8
        } else {
            Write-Host "No se encontraron parches instalados." -ForegroundColor "Yellow"
        }
    } catch {
        Write-Host "Error al obtener parches instalados: $_" -ForegroundColor "Red"
    }
}

# Función para obtener paquetes instalados
function Get-InstalledPackages {
    Show-Banner -Text "Paquetes Instalados" -ForegroundColor "Blue" -BackgroundColor "Black"
    
    try {
        $packages = Get-WmiObject -Class Win32_Product | Select-Object Name, Version
        if ($packages) {
            $packages | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor "White"
            $packages | Export-Csv -Path $script:PackagesFile -NoTypeInformation -Encoding UTF8
        } else {
            Write-Host "No se encontraron paquetes instalados." -ForegroundColor "Yellow"
        }
    } catch {
        Write-Host "Error al obtener los paquetes instalados: $_" -ForegroundColor "Red"
    }
}

# Función para obtener unidades mapeadas
function Get-MappedDrives {
    Show-Banner -Text "Unidades Mapeadas" -ForegroundColor "Green" -BackgroundColor "Black"
    
    try {
        $drives = Get-WmiObject -Class Win32_NetworkConnection | Select-Object LocalName, RemoteName
        if ($drives) {
            $drives | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor "White"
            $drives | Export-Csv -Path $script:MappedDrivesFile -NoTypeInformation -Encoding UTF8
        } else {
            Write-Host "No se encontraron unidades mapeadas." -ForegroundColor "Yellow"
        }
    } catch {
        Write-Host "Error al obtener las unidades mapeadas: $_" -ForegroundColor "Red"
    }
}

# Función para obtener información de almacenamiento
function Get-StorageDrives {
    Show-Banner -Text "Unidades de Almacenamiento" -ForegroundColor "Cyan" -BackgroundColor "Black"
    
    try {
        $storage = Get-PhysicalDisk | Select-Object DeviceId, MediaType, Size
        if ($storage) {
            $storage | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor "White"
            $storage | Export-Csv -Path $script:StorageInfoFile -NoTypeInformation -Encoding UTF8
        } else {
            Write-Host "No se encontraron unidades de almacenamiento." -ForegroundColor "Yellow"
        }
    } catch {
        Write-Host "Error al obtener las unidades de almacenamiento: $_" -ForegroundColor "Red"
    }
}

# Función principal para ejecutar todas las funciones y generar archivos
function Get-SystemInformation {
    $timestamp = Get-Date -Format yyyyMMddHHmmss
    
    $script:SystemInfoFile = "SystemInfo_$timestamp.txt"
    $script:PatchesFile = "ParchesInstalados_$timestamp.csv"
    $script:PackagesFile = "PaquetesInstalados_$timestamp.csv"
    $script:MappedDrivesFile = "UnidadesMapeadas_$timestamp.csv"
    $script:StorageInfoFile = "UnidadesAlmacenamiento_$timestamp.csv"
    
    Get-SystemInfo
    Get-InstalledPatches
    Get-InstalledPackages
    Get-MappedDrives
    Get-StorageDrives
    
    
}

# Ejecutar el script
Get-SystemInformation
