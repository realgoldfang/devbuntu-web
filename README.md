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

1. Build your `.deb` package
2. Place it in the `pool/` directory
3. Generate `Packages` file: `dpkg-scanpackages pool/ /dev/null | gzip -9c > dists/stable/main/binary-amd64/Packages.gz`
4. Generate `Release` file: `apt-ftparchive release dists/stable > dists/stable/Release`
5. Sign with GPG: `gpg --default-key <your-key-id> -abs -o dists/stable/Release.gpg dists/stable/Release`
6. Create InRelease: `gpg --default-key <your-key-id> --clearsign -o dists/stable/InRelease dists/stable/Release`
7. Commit and push changes

## License

See LICENSE file for details.