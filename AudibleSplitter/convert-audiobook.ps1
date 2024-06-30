param(
    [Parameter(Position=0)]
    [string]$aaxFileName,

    [Parameter(Position=1)]
    [string]$activationBytes
)

# Prompt for AAX file name if blank
if ([string]::IsNullOrWhiteSpace($aaxFileName)) {
    $aaxFileName = Read-Host -Prompt "Enter the encrypted AAX file name"
}

# Prompt for AAX file name if blank
if ([string]::IsNullOrWhiteSpace($activationBytes)) {
    $activationBytes = Read-Host -Prompt "Enter the activation bytes"
}

# Convert AAX to MP3
$mp3FileName = [System.IO.Path]::ChangeExtension($aaxFileName, ".mp3")
ffmpeg -activation_bytes $activationBytes -i $aaxFileName $mp3FileName

# Extract audiobook name and chapter time markers
$metadata = ffprobe -v quiet -i $mp3FileName -print_format json -show_chapters -show_format | 
ConvertFrom-Json

# Try to find the audiobook name from common metadata tags
$audiobookName = $null

$tagsToCheck = @(
    "title",
    "album",
    "album_title",
    "title_sort",
    "album_sort",
    "sort"
)

foreach ($tag in $tagsToCheck) {
    if ($metadata.format.tags.$tag -ne $null -and $metadata.format.tags.$tag -ne "") {
        $audiobookName = $metadata.format.tags.$tag
        break
    }
}

# Check if audiobook name was found
if ($audiobookName -eq $null) {
    Write-Host "Failed to find the audiobook name in the metadata."
    exit
}

# Create audiobook folder
$audiobookFolder = $audiobookName -replace '[\\/:*?"<>|]', ''
New-Item -ItemType Directory -Force -Path $audiobookFolder | Out-Null

# Iterate through chapters and split into individual MP3 files
Foreach ($chapter in $metadata.chapters){
    $chapterFileName = $chapter.tags.title + '.mp3'
    $chapterOutputPath = Join-Path -Path $audiobookFolder -ChildPath $chapterFileName

    Write-Host $chapterFileName
    Write-Host $chapterOutputPath

    ffmpeg -i $mp3FileName -ss $chapter.start_time -to $chapter.end_time $chapterOutputPath
}

# Create M3U playlist file
$playlistPath = "$audiobookFolder\$audiobookFolder.m3u"
$playlistContent = "#EXTM3U`r`n"
Foreach ($chapter in $metadata.chapters){
    $chapterFileName = $chapter.tags.title + '.mp3'
    $playlistContent += "#EXTINF:0,$chapterFileName`r`n$chapterFileName`r`n`r`n"
}
$playlistContent | Out-File $playlistPath -Encoding utf8

Write-Host "Conversion and splitting completed successfully."
