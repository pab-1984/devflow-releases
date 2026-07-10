# DevFlow — releases

Instaladores oficiales y manifests de auto-actualización de **DevFlow**, un entorno de
desarrollo de escritorio con un equipo de agentes IA, orquestador de workflows y gestión
de proyectos punta a punta.

## Descargar

Bajá el instalador para tu sistema operativo desde la **[última release](../../releases/latest)**:

| Sistema | Archivo |
|---|---|
| Windows | `DevFlow_*_x64-setup.exe` |
| macOS (Apple Silicon) | `DevFlow_*_aarch64.dmg` |
| macOS (Intel) | `DevFlow_*_x64.dmg` |
| Linux | `DevFlow_*_amd64.AppImage` · `.deb` · `.rpm` |

Una vez instalado, DevFlow se **auto-actualiza**: avisa cuando hay una versión nueva firmada
y se actualiza solo.

## Sobre este repo

Este repositorio contiene únicamente los **binarios publicados** y los manifests del updater.
El código fuente se mantiene en un repositorio privado; la CI de acá lo compila y firma para
las tres plataformas en cada versión.
