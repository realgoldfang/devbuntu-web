#!/bin/bash
set -e

GPG_KEY="958F01226D3F9929"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
POOL_DIR="$REPO_DIR/pool"
DISTS_DIR="$REPO_DIR/dists"

echo "=== Devbuntu Repository Builder ==="

if [ ! -d "$POOL_DIR" ] || [ -z "$(ls -A $POOL_DIR 2>/dev/null)" ]; then
    echo "No packages in pool/ - nothing to build."
    exit 0
fi

for arch in amd64 arm64; do
    PKGS_DIR="$DISTS_DIR/stable/main/binary-$arch"
    mkdir -p "$PKGS_DIR"
    
    ARCH_DEBS=$(find "$POOL_DIR" -name "*_$arch.deb" -o -name "*_all.deb" 2>/dev/null)
    
    if [ -z "$ARCH_DEBS" ]; then
        continue
    fi
    
    echo "Building Packages for $arch..."
    
    cd "$REPO_DIR"
    dpkg-scanpackages pool/ /dev/null 2>/dev/null | gzip -9c > "$PKGS_DIR/Packages.gz"
    dpkg-scanpackages pool/ /dev/null 2>/dev/null > "$PKGS_DIR/Packages"
done

echo "Building Release..."
cd "$REPO_DIR"
apt-ftparchive release "$DISTS_DIR/stable" > "$DISTS_DIR/stable/Release"

echo "Signing Release..."
gpg --default-key "$GPG_KEY" -abs -o "$DISTS_DIR/stable/Release.gpg" "$DISTS_DIR/stable/Release"
gpg --default-key "$GPG_KEY" --clearsign -o "$DISTS_DIR/stable/InRelease" "$DISTS_DIR/stable/Release"

echo "Exporting public key..."
gpg --armor --export "$GPG_KEY" > "$REPO_DIR/gpg-key.asc"

echo "Done! Repository is ready."