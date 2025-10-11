# Fix Syntax Errors in SCSS Files
# This script fixes the syntax errors introduced by the previous script

Write-Host "Fixing syntax errors in SCSS files..." -ForegroundColor Green

# Define the theme directory
$themeDir = "theme.asisaga.com/_sass/components"

# Function to fix specific syntax errors
function Fix-SyntaxErrors {
    param([string]$file)
    
    Write-Host "Fixing syntax errors in $file..." -ForegroundColor Yellow
    
    $content = Get-Content $file -Raw
    
    # Fix malformed display: flex lines
    $content = $content -replace 'display: flex with proper mixin or direct styles for Jekyll compatibility\s*\n\s*// @extend with direct styles\s*\n\s*display: flex;', 'display: flex;'
    $content = $content -replace 'display: flex with proper mixin or direct styles for Jekyll compatibility', 'display: flex;'
    
    # Fix other malformed lines
    $content = $content -replace '(\s+)// Replaced @extend with direct styles for Jekyll compatibility\s*\n\s*@include container-fluid\(\);\s*display: flex', '$1display: flex'
    
    # Remove duplicate display declarations
    $content = $content -replace 'display: flex;\s*\n\s*display: flex;', 'display: flex;'
    
    # Fix any other malformed lines that lack semicolons
    $content = $content -replace '(\s+)@include container-fluid\(\)$', '$1@include container-fluid();'
    $content = $content -replace '(\s+)flex: 1 0 0%$', '$1flex: 1 0 0%;'
    $content = $content -replace '(\s+)min-width: 0$', '$1min-width: 0;'
    $content = $content -replace '(\s+)flex-wrap: wrap$', '$1flex-wrap: wrap;'
    
    Set-Content $file -Value $content -NoNewline
}

# Get files with syntax errors
$errorFiles = @(
    "theme.asisaga.com/_sass/components/_card-component.scss",
    "theme.asisaga.com/_sass/components/_feature-grid.scss", 
    "theme.asisaga.com/_sass/components/_form-component.scss",
    "theme.asisaga.com/_sass/components/_image-card-component.scss",
    "theme.asisaga.com/_sass/components/_layout-component.scss",
    "theme.asisaga.com/_sass/components/_product-applications.scss",
    "theme.asisaga.com/_sass/components/_product-feature-grid.scss",
    "theme.asisaga.com/_sass/components/_product-page.scss",
    "theme.asisaga.com/_sass/components/_products-grid-component.scss",
    "theme.asisaga.com/_sass/components/_section-component.scss",
    "theme.asisaga.com/_sass/components/_team-component.scss",
    "theme.asisaga.com/_sass/components/_testimonial.scss"
)

foreach ($file in $errorFiles) {
    if (Test-Path $file) {
        Fix-SyntaxErrors $file
    }
}

Write-Host "`nRunning stylelint to check for remaining syntax errors..." -ForegroundColor Green
& npx stylelint "$themeDir/**/*.scss" --max-warnings 30

Write-Host "`nSyntax error fix complete!" -ForegroundColor Green