# DevFlow — releases

Official installers and auto-update manifests for **DevFlow**, a desktop development
environment with a team of AI agents, a workflow orchestrator and end-to-end project
management.

## Download

Grab the installer for your OS from the **[latest release](../../releases/latest)**:

| System | File |
|---|---|
| Windows | `DevFlow_*_x64-setup.exe` |
| macOS (Apple Silicon) | `DevFlow_*_aarch64.dmg` |
| macOS (Intel) | `DevFlow_*_x64.dmg` |
| Linux | `DevFlow_*_amd64.AppImage` · `.deb` · `.rpm` |

Or install from the terminal (macOS and Linux):

```sh
curl -fsSL https://raw.githubusercontent.com/pab-1984/devflow-releases/main/install.sh | sh
```

Once installed, DevFlow **auto-updates**: it notifies you when a new signed version is
available and updates itself.

## About this repo

This repository holds only the **published binaries** and the updater manifests. The source
code lives in a private repository; the CI here builds and signs it for the three platforms on
every release.
