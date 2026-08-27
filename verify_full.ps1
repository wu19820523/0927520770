$content = Get-Content -Path "js\species-data.js" -Raw -Encoding UTF8

$idMatches = [regex]::Matches($content, 'id:\s*"([^"]+)"')
$nameMatches = [regex]::Matches($content, 'name:\s*"([^"]+)"')
$imgMatches = [regex]::Matches($content, 'image:\s*"([^"]+)"')
$catMatches = [regex]::Matches($content, 'category:\s*"([^"]+)"')

Write-Host "=========================================="
Write-Host "   OCEAN CRAFTSMAN DIRECTORY & PATH TEST  "
Write-Host "=========================================="
Write-Host "Total Species in DB: $($idMatches.Count)"
Write-Host "Total Images in DB:  $($imgMatches.Count)"

$images1Count = (Get-ChildItem -Path "images" -File).Count
$images2Count = (Get-ChildItem -Path "images2" -File).Count
$imagesBackupCount = (Get-ChildItem -Path "images_backup" -File).Count

Write-Host "`nFolder file counts (Must all be <= 100):"
Write-Host " - images/:        $images1Count files  $([char]0x2192) $(if ($images1Count -le 100) {'[PASS]'} else {'[FAIL]'})"
Write-Host " - images2/:       $images2Count files  $([char]0x2192) $(if ($images2Count -le 100) {'[PASS]'} else {'[FAIL]'})"
Write-Host " - images_backup/: $imagesBackupCount files  $([char]0x2192) $(if ($imagesBackupCount -le 100) {'[PASS]'} else {'[FAIL]'})"

$missingImages = @()
for ($i = 0; $i -lt $imgMatches.Count; $i++) {
    $img = $imgMatches[$i].Groups[1].Value
    $spName = $nameMatches[$i].Groups[1].Value
    $spId = $idMatches[$i].Groups[1].Value
    if (-not (Test-Path $img)) {
        $missingImages += "[$spId] $spName -> $img"
    }
}

if ($missingImages.Count -eq 0) {
    Write-Host "`nSUCCESS: All $($imgMatches.Count) species image paths verified and exist on disk!" -ForegroundColor Green
} else {
    Write-Host "`nERROR: Missing images ($($missingImages.Count)):" -ForegroundColor Red
    $missingImages | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
}
