run-function -word "Test"

function run-function {
    param($word)
    Write-Host $word -ForegroundColor Green
}