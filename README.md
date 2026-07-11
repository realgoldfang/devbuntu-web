# Devbuntu Repository

Development packages for Ubuntu systems.

## Quick Start

```bash
# Import GPG key
curl -fsSL https://realgoldfang.github.io/devbuntu-web/gpg-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/devbuntu-archive-keyring.gpg

# Add repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/devbuntu-archive-keyring.gpg] https://realgoldfang.github.io/devbuntu-web stable main" | sudo tee /etc/apt/sources.list.d/devbuntu.list > /dev/null

# Update and install
sudo apt update
sudo apt install <package-name>
```

## Website

The repository website is hosted at: https://realgoldfang.github.io/devbuntu-web/

## Adding Packages

### Quick way (using build script)

1. Build your `.deb` package
2. Place it in the `pool/` directory
3. Add package info to `packages.json`:
   ```json
   {
     "packages": [
       {
         "name": "package-name",
         "version": "1.0.0",
         "size": "1.2 MB",
         "description": "Package description"
       }
     ]
   }
   ```
4. Run the build script:
   ```bash
   ./build-repo.sh
   ```
5. Commit and push

### Manual way

1. Build your `.deb` package
2. Place it in the `pool/` directory
3. Generate `Packages` file: `dpkg-scanpackages pool/ /dev/null | gzip -9c > dists/stable/main/binary-amd64/Packages.gz`
4. Generate `Release` file: `apt-ftparchive release dists/stable > dists/stable/Release`
5. Sign with GPG: `gpg --default-key 958F01226D3F9929 -abs -o dists/stable/Release.gpg dists/stable/Release`
6. Create InRelease: `gpg --default-key 958F01226D3F9929 --clearsign -o dists/stable/InRelease dists/stable/Release`
7. Commit and push changes

## Repository Structure

```
.
├── pool/                    # .deb packages
├── dists/
│   └── stable/
│       ├── main/
│       │   ├── binary-amd64/
│       │   │   ├── Packages
│       │   │   └── Packages.gz
│       │   └── binary-arm64/
│       │       ├── Packages
│       │       └── Packages.gz
│       ├── Release
│       ├── Release.gpg
│       └── InRelease
├── gpg-key.asc              # Public GPG key
├── build-repo.sh            # Build script
├── packages.json            # Package metadata for website
└── index.html               # Website
```

## GPG Key

- Key ID: `958F01226D3F9929`
- Email: devbuntu@realgoldfang.github.io

## License

See LICENSE file for details.