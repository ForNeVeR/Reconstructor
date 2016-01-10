param (
    [string]$BackupDirectory,
    [string]$Target,
    [string]$StripPath = $null,
    [string]$DateTimeFormat = 'yyyyMMddHHmmss'
)

$ErrorActionPreference = 'Stop'

function parseDate($date) {
    [DateTime]::ParseExact(
        $date,
        $DateTimeFormat,
        [Globalization.Cultureinfo]::InvariantCulture,
        [System.Globalization.DateTimeStyles]::AdjustToUniversal -bor
            [System.Globalization.DateTimeStyles]::AssumeUniversal)
}

$BackupDirectory = [IO.Path]::GetFullPath($BackupDirectory)
$Target = [IO.Path]::GetFullPath($Target)

if (-not (Test-Path $Target)) {
    New-Item -Type Directory $Target
}

try {
    Push-Location $Target
    git init

    $backupsAvailable = Get-ChildItem $BackupDirectory | Sort-Object -Property Name
    $backupsAvailable | % {
        $directory = $_
        if ($StripPath) {
            $directory = Join-Path $directory.FullName $StripPath
        }

        $directoryName = [IO.Path]::GetFileName($_)
        if (-not ($directoryName -match '^.*?(\d+)$')) {
            throw "Cannot extract date from directory $directoryName"
        }

        $date = (parseDate $Matches[1]).ToString('s') + 'Z'
        Write-Output "Processing date $date"

        Remove-Item -Recurse $Target/*
        Copy-Item -Recurse $directory/* $Target

        $message = "History reconstruction from $date`n`nUsing exhibit: $directoryName"

        git add -A
        git commit -m $message --date $date
    }
} finally {
    Pop-Location
}
