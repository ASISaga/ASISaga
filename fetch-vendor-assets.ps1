# Set destination folder
$vendorPath = "Website\theme.asisaga.com\assets\js\vendor"

# Create folder if it doesn't exist
if (-Not (Test-Path $vendorPath)) {
    New-Item -ItemType Directory -Path $vendorPath | Out-Null
}

# --- Download Bootstrap ESM ---
Invoke-WebRequest `
    -Uri "https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.esm.min.js" `
    -OutFile "$vendorPath\bootstrap.esm.min.js"

# --- Download Popper ESM ---
Invoke-WebRequest `
    -Uri "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/popper.min.js" `
    -OutFile "$vendorPath\popper.min.js"

# Download fontawesome-svg-core ESM from GitHub
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/js-packages/@fortawesome/fontawesome-svg-core/index.es.js" `
  -OutFile "$vendorPath\fontawesome-core.es.js"
