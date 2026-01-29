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

    
    try {
        # Run Pandoc: typst -> html with MathJax math and citation processing
        # Change directory to file location so relative paths (bibliography) work
        Push-Location $file.DirectoryName
        try {
            $outputName = $file.Name -replace "\.typ$", ".html"
            
            # Check for bibliography file
            $bibFile = Get-ChildItem -Filter "*.bib" | Select-Object -First 1
            $bibArg = ""
            if ($bibFile) {
                $bibArg = "--bibliography=`"$($bibFile.Name)`""
                # Check for IEEE CSL file
                $cslPath = Join-Path $PSScriptRoot "files/csl/ieee.csl"
                if (Test-Path $cslPath) {
                   $bibArg += " --csl=`"$cslPath`""
                }
            }

            $command = "pandoc $($file.Name) -f typst -t html --mathjax --citeproc $bibArg -o $outputName 2>&1"
            $result = Invoke-Expression $command
        }
        finally {
            Pop-Location
        }
        
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