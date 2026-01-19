# new-post.ps1 - Create a new Typst blog post
# Usage: .\scripts\new-post.ps1 -Title "My Post Title"

param(
    [Parameter(Mandatory=$true)]
    [string]$Title
)

# Create slug from title (lowercase, replace spaces with hyphens, remove special chars)
$slug = $Title.ToLower() -replace '[^a-z0-9\s-]', '' -replace '\s+', '-' -replace '-+', '-'
$date = Get-Date -Format "yyyy-MM-dd"

# Create post directory
$postDir = "content\blog\$slug"
if (Test-Path $postDir) {
    Write-Host "Error: Post directory already exists: $postDir" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $postDir -Force | Out-Null

# Create index.md with frontmatter
$indexContent = @"
+++
title = "$Title"
date = $date
template = "blog-page.html" 
+++

{{ typst(src="content/blog/$slug/content.html") }}
"@

$indexContent | Out-File -FilePath "$postDir\index.md" -Encoding utf8

# Create content.typ template
$typstContent = @"
= $Title

// Write your Typst content here

This is a new blog post about...

== Section 1

Some content with math: `$x^2 + y^2 = z^2$`

== Section 2

- List item 1
- List item 2
"@

$typstContent | Out-File -FilePath "$postDir\content.typ" -Encoding utf8

Write-Host "Created new post: $postDir" -ForegroundColor Green
Write-Host "  - Edit: $postDir\content.typ" -ForegroundColor Cyan
Write-Host "  - Then run: .\build.ps1" -ForegroundColor Cyan
Write-Host "  - Then run: zola serve" -ForegroundColor Cyan
