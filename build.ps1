# build.ps1 - Convert Typst files to HTML using Pandoc
# Run this before 'zola serve' or 'zola build'

param(
    [switch]$Watch  # Future: add file watching
)

Write-Host "Building Typst files..." -ForegroundColor Cyan

# Find all .typ files in the content directory
$files = Get-ChildItem -Path "content" -Recurse -Filter "*.typ" -ErrorAction SilentlyContinue

if ($files.Count -eq 0) {
    Write-Host "No .typ files found in content/" -ForegroundColor Yellow
    exit 0
}

$success = 0
$failed = 0

foreach ($file in $files) {
    # Output goes to content.html in same directory
    $output = $file.FullName -replace "\.typ$", ".html"
    
    try {
        # Run Pandoc: typst -> html with MathJax math
        $result = pandoc $file.FullName -f typst -t html --mathjax -o $output 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] $($file.Name)" -ForegroundColor Green
            $success++
        } else {
            Write-Host "  [FAIL] $($file.Name): $result" -ForegroundColor Red
            $failed++
        }
    }
    catch {
        Write-Host "  [ERROR] $($file.Name): $_" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Build complete: $success succeeded, $failed failed" -ForegroundColor $(if ($failed -gt 0) { "Yellow" } else { "Green" })

if ($failed -eq 0) {
    Write-Host "Run 'zola serve' to preview your site" -ForegroundColor Cyan
}