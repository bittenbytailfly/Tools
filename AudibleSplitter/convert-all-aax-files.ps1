param(
    [Parameter(Position=0)]
    [string]$activationBytes
)

# Prompt for AAX file name if blank
if ([string]::IsNullOrWhiteSpace($activationBytes)) {
    $activationBytes = Read-Host -Prompt "Enter the activation bytes"
}

# Get the current directory
$currentDirectory = Get-Location

# Retrieve AAX files in the current directory
$aaxFiles = Get-ChildItem -Path $currentDirectory -Filter "*.aax" -File

# Iterate over AAX files and call the conversion script for each file
foreach ($aaxFile in $aaxFiles) {
    # Construct the arguments for the conversion script
    $aaxFileName = $aaxFile.FullName

    # Call the conversion script with the arguments
    & ".\convert-audiobook.ps1" -aaxFileName $aaxFileName -activationBytes $activationBytes
}