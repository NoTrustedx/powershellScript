## 🖥️ Get-SystemInformation

Este script de PowerShell permite recolectar y visualizar información detallada del sistema Windows, incluyendo sistema operativo, parches, paquetes instalados, unidades de red y discos físicos. Todo ello se presenta en consola con colores y banners llamativos, además de generar archivos de salida para su análisis posterior.

## 🎯 Características

- 📋 Información del sistema operativo (nombre, versión, arquitectura, etc.)
- 🔒 Parches instalados (HotFixes)
- 📦 Paquetes instalados (Win32_Product)
- 🌐 Unidades de red mapeadas
- 💾 Información de discos físicos
- 🗃️ Exportación automática de los resultados a archivos `.csv` y `.txt` con timestamp

## 🚀 Cómo usar

### 1. Clona o descarga el script

```bash
git clone https://github.com/NoTrustedx/Get-SystemInformation.git
cd Get-SystemInformation
````

### 2. Ejecuta el script con PowerShell (como administrador)

```powershell
.\Get-SystemInformation.ps1
```

> ⚠️ Se recomienda ejecutar como **Administrador** para garantizar el acceso completo a WMI y CIM.

## 📁 Archivos generados

Tras ejecutarse, el script generará archivos con un timestamp en el nombre, como:

* `SystemInfo_20250801XXXXXX.txt`
* `ParchesInstalados_20250801XXXXXX.csv`
* `PaquetesInstalados_20250801XXXXXX.csv`
* `UnidadesMapeadas_20250801XXXXXX.csv`
* `UnidadesAlmacenamiento_20250801XXXXXX.csv`

Estos archivos estarán en el mismo directorio del script.

## 📌 Estructura del Script

Cada sección está modularizada como función:

| Función                 | Descripción                                 |
| ----------------------- | ------------------------------------------- |
| `Show-Banner`           | Muestra banners coloridos en consola        |
| `Get-SystemInfo`        | Info básica del sistema operativo           |
| `Get-InstalledPatches`  | Parches/HotFixes instalados                 |
| `Get-InstalledPackages` | Software instalado (via `Win32_Product`)    |
| `Get-MappedDrives`      | Unidades de red mapeadas                    |
| `Get-StorageDrives`     | Discos físicos detectados por el sistema    |
| `Get-SystemInformation` | Función principal que orquesta la ejecución |

## ✅ Requisitos

* PowerShell 5.1+
* Windows 10, 11 o Windows Server 2016+
* Permisos de administrador (recomendado para mejor acceso WMI)

## 📦 Posibles mejoras

* Exportación a JSON o Excel
* Opcionalidad de módulos individuales por parámetros (`-OnlySystemInfo`, `-OnlyPatches`, etc.)
* Interfaz gráfica mínima con `Out-GridView` o WinForms


## 🧑‍💻 Autor

ErickO.
🔗 GitHub: [@NoTrustedx](https://github.com/NoTrustedx)

## 📄 Licencia

Este proyecto está bajo la licencia MIT – libre para uso, modificación y distribución.
