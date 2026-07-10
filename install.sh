#!/bin/sh
# Instalador de DevFlow por terminal (macOS y Linux).
#   curl -fsSL https://raw.githubusercontent.com/pab-1984/devflow-releases/main/install.sh | sh
#
# Baja el último release público, lo instala y —en macOS— evita el bloqueo de Gatekeeper
# (los archivos bajados por curl no quedan en cuarentena; igual lo forzamos por las dudas).
# Windows: bajá el instalador .exe desde la página de releases.
set -eu

REPO="pab-1984/devflow-releases"
API="https://api.github.com/repos/${REPO}/releases/latest"

say()  { printf '\033[36m%s\033[0m\n' "$*"; }
ok()   { printf '\033[32m%s\033[0m\n' "$*"; }
die()  { printf '\033[31m%s\033[0m\n' "$*" >&2; exit 1; }

command -v curl >/dev/null 2>&1 || die "Necesitás curl instalado."

# Resuelve la URL de descarga de un asset por patrón (sin depender de la versión ni de jq).
asset_url() {
  curl -fsSL "$API" | grep -o "https://github.com/[^\"]*${1}\"" | tr -d '"' | head -1
}

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    case "$ARCH" in
      arm64)  PAT="aarch64.app.tar.gz" ;;
      x86_64) PAT="x64.app.tar.gz" ;;
      *) die "Arquitectura de macOS no soportada: $ARCH" ;;
    esac
    URL="$(asset_url "$PAT")"
    [ -n "$URL" ] || die "No pude encontrar el asset ($PAT) en el último release."

    say "Descargando DevFlow para macOS ($ARCH)..."
    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT
    curl -fSL# "$URL" -o "$TMP/devflow.app.tar.gz"
    tar -xzf "$TMP/devflow.app.tar.gz" -C "$TMP"
    APP="$(find "$TMP" -maxdepth 1 -name '*.app' | head -1)"
    [ -n "$APP" ] || die "No se encontró el .app dentro del paquete."

    # Elegí destino escribible: /Applications si se puede, si no ~/Applications.
    if [ -w /Applications ] || [ "$(id -u)" = "0" ]; then DEST="/Applications"; else DEST="$HOME/Applications"; mkdir -p "$DEST"; fi
    rm -rf "$DEST/DevFlow.app"
    mv "$APP" "$DEST/DevFlow.app"

    say "Habilitando la app (Gatekeeper)..."
    xattr -dr com.apple.quarantine "$DEST/DevFlow.app" 2>/dev/null || true
    codesign --force --deep --sign - "$DEST/DevFlow.app" >/dev/null 2>&1 || true

    ok "✓ DevFlow instalado en $DEST/DevFlow.app"
    ok "  Abrilo desde Launchpad, o:  open \"$DEST/DevFlow.app\""
    ;;

  Linux)
    URL="$(asset_url "amd64.AppImage")"
    [ -n "$URL" ] || die "No pude encontrar el AppImage en el último release."
    DEST="${XDG_BIN_HOME:-$HOME/.local/bin}"
    mkdir -p "$DEST"
    say "Descargando DevFlow (AppImage)..."
    curl -fSL# "$URL" -o "$DEST/DevFlow.AppImage"
    chmod +x "$DEST/DevFlow.AppImage"
    ok "✓ DevFlow instalado en $DEST/DevFlow.AppImage"
    case ":$PATH:" in
      *":$DEST:"*) ok "  Ejecutá:  DevFlow.AppImage" ;;
      *) ok "  Ejecutalo con:  $DEST/DevFlow.AppImage   (o agregá $DEST al PATH)" ;;
    esac
    ;;

  *)
    die "SO no soportado por este script ($OS). En Windows bajá el .exe desde https://github.com/${REPO}/releases/latest"
    ;;
esac
