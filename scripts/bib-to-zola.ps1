<#
.SYNOPSIS
    Converts a BibTeX file to Zola-compatible publication markdown files.

.DESCRIPTION
    Parses a BibTeX file and generates individual markdown files in content/publications/
    with proper frontmatter for Zola's taxonomy system.

.PARAMETER BibFile
    Path to the BibTeX file to parse.

.PARAMETER OutputDir
    Output directory for generated markdown files. Defaults to content/publications/

.EXAMPLE
    .\bib-to-zola.ps1 -BibFile publications.bib
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BibFile,
    
    [string]$OutputDir = "content/publications"
)

# Ensure output directory exists
$scriptRoot = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path $scriptRoot $OutputDir
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
    Write-Host "Created directory: $outputPath"
}

# Read the BibTeX file
$bibContent = Get-Content $BibFile -Raw

# Parse BibTeX entries
$entryPattern = '@(\w+)\s*\{\s*([^,]+)\s*,([^@]+)\}'
$entries = [regex]::Matches($bibContent, $entryPattern)

Write-Host "Found $($entries.Count) entries in $BibFile"

foreach ($entry in $entries) {
    $entryType = $entry.Groups[1].Value.ToLower()
    $citeKey = $entry.Groups[2].Value.Trim()
    $fieldsBlock = $entry.Groups[3].Value
    
    # Parse fields
    $fields = @{}
    $fieldPattern = '(\w+)\s*=\s*[{"]([^}"]*)[}"]'
    $fieldMatches = [regex]::Matches($fieldsBlock, $fieldPattern)
    
    foreach ($field in $fieldMatches) {
        $fieldName = $field.Groups[1].Value.ToLower()
        $fieldValue = $field.Groups[2].Value.Trim()
        $fields[$fieldName] = $fieldValue
    }
    
    # Extract required fields
    $title = $fields['title'] -replace '[{}]', ''
    $authors = $fields['author'] -replace '[{}]', '' -replace ' and ', ', '
    $year = $fields['year'] -replace '[{}]', ''
    
    if (-not $title -or -not $year) {
        Write-Warning "Skipping entry '$citeKey': missing title or year"
        continue
    }
    
    # Extract venue based on entry type
    $venue = switch ($entryType) {
        'article' { $fields['journal'] }
        'inproceedings' { $fields['booktitle'] }
        'conference' { $fields['booktitle'] }
        'book' { $fields['publisher'] }
        'phdthesis' { "PhD Thesis, $($fields['school'])" }
        'mastersthesis' { "Master's Thesis, $($fields['school'])" }
        default { if ($fields['journal']) { $fields['journal'] } elseif ($fields['booktitle']) { $fields['booktitle'] } else { '' } }
    }
    $venue = $venue -replace '[{}]', ''
    
    # Extract optional fields
    $abstract = $fields['abstract'] -replace '[{}]', ''
    $doi = $fields['doi'] -replace '[{}]', ''
    $tags = $fields['tags'] -replace '[{}]', ''
    
    # URL fields (all optional)
    $paperUrl = $fields['paper_url'] -replace '[{}]', ''
    $slidesUrl = $fields['slides_url'] -replace '[{}]', ''
    $blogUrl = $fields['blog_url'] -replace '[{}]', ''
    $codeUrl = $fields['code_url'] -replace '[{}]', ''
    $videoUrl = $fields['video_url'] -replace '[{}]', ''
    $posterUrl = $fields['poster_url'] -replace '[{}]', ''
    $websiteUrl = $fields['website_url'] -replace '[{}]', ''
    $award = $fields['award'] -replace '[{}]', ''
    
    # Generate slug from cite key
    $slug = $citeKey.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|-$', ''
    
    # Build frontmatter
    $frontmatter = @"
+++
title = "$($title -replace '"', '\"')"
date = $year-01-01
template = "publication.html"

[extra]
authors = "$authors"
venue = "$venue"
entry_type = "$entryType"
cite_key = "$citeKey"
"@

    # Add optional fields
    if ($doi) {
        $frontmatter += "`ndoi = `"$doi`""
    }
    if ($paperUrl) {
        $frontmatter += "`npaper_url = `"$paperUrl`""
    }
    if ($slidesUrl) {
        $frontmatter += "`nslides_url = `"$slidesUrl`""
    }
    if ($blogUrl) {
        $frontmatter += "`nblog_url = `"$blogUrl`""
    }
    if ($codeUrl) {
        $frontmatter += "`ncode_url = `"$codeUrl`""
    }
    if ($videoUrl) {
        $frontmatter += "`nvideo_url = `"$videoUrl`""
    }
    if ($posterUrl) {
        $frontmatter += "`nposter_url = `"$posterUrl`""
    }
    if ($websiteUrl) {
        $frontmatter += "`nwebsite_url = `"$websiteUrl`""
    }
    if ($award) {
        $frontmatter += "`naward = `"$award`""
    }
    
    # Add tags if present
    if ($tags) {
        $tagList = ($tags -split ',\s*' | ForEach-Object { "`"$($_.Trim())`"" }) -join ', '
        $frontmatter += "`n`n[taxonomies]`ntags = [$tagList]"
    }
    
    $frontmatter += "`n+++"
    
    # Add abstract as content if present
    $content = if ($abstract) { "`n`n$abstract" } else { "" }
    
    # Write file
    $outputFile = Join-Path $outputPath "$slug.md"
    $fullContent = $frontmatter + $content
    Set-Content -Path $outputFile -Value $fullContent -Encoding UTF8
    
    Write-Host "  Created: $slug.md ($title)"
}

# Create or update _index.md for the publications section
$indexPath = Join-Path $outputPath "_index.md"
if (-not (Test-Path $indexPath)) {
    $indexContent = @"
+++
title = "Publications"
sort_by = "date"
template = "section.html"
transparent = true
+++
"@
    Set-Content -Path $indexPath -Value $indexContent -Encoding UTF8
    Write-Host "`nCreated publications section index: _index.md"
}

Write-Host "`nDone! Generated $($entries.Count) publication files."
Write-Host "Run 'zola build' or 'zola serve' to see your publications."
