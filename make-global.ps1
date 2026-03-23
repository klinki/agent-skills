[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Name
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return [System.IO.Path]::GetFullPath($Path)
}

$skillPath = Resolve-FullPath (Join-Path -Path $PSScriptRoot -ChildPath $Name)

if (-not (Test-Path -LiteralPath $skillPath -PathType Container)) {
    throw "Skill '$Name' was not found at '$skillPath'."
}

$globalSkillsDir = Resolve-FullPath (Join-Path -Path $HOME -ChildPath '.agents\skills')
$linkPath = Resolve-FullPath (Join-Path -Path $globalSkillsDir -ChildPath $Name)

if (-not (Test-IsAdministrator)) {
    $argumentList = @(
        '-NoProfile'
        '-ExecutionPolicy'
        'Bypass'
        '-File'
        "`"$PSCommandPath`""
        "`"$Name`""
    )

    Write-Host "Requesting administrator permissions..."
    try {
        $process = Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList $argumentList -Wait -PassThru
    }
    catch {
        throw 'Administrator approval is required to create the symbolic link.'
    }

    if ($process.ExitCode -ne 0) {
        throw "Elevated PowerShell exited with code $($process.ExitCode)."
    }

    return
}

if (-not (Test-Path -LiteralPath $globalSkillsDir -PathType Container)) {
    New-Item -ItemType Directory -Path $globalSkillsDir -Force | Out-Null
}

if (Test-Path -LiteralPath $linkPath) {
    $existingItem = Get-Item -LiteralPath $linkPath -Force
    $linkTypeProperty = $existingItem.PSObject.Properties['LinkType']

    if ($null -eq $linkTypeProperty -or $linkTypeProperty.Value -ne 'SymbolicLink') {
        throw "Path '$linkPath' already exists and is not a symbolic link."
    }

    $targetProperty = $existingItem.PSObject.Properties['Target']
    if ($null -eq $targetProperty -or [string]::IsNullOrWhiteSpace([string]$targetProperty.Value)) {
        throw "Symbolic link '$linkPath' exists, but its target could not be determined."
    }

    $existingTarget = $targetProperty.Value
    if ($existingTarget -is [Array]) {
        $existingTarget = $existingTarget[0]
    }

    $existingTargetPath = Resolve-FullPath $existingTarget
    if ($existingTargetPath -eq $skillPath) {
        Write-Host "Symbolic link already exists: '$linkPath' -> '$skillPath'"
        return
    }

    throw "Symbolic link '$linkPath' already points to '$existingTargetPath'."
}

New-Item -ItemType SymbolicLink -Path $linkPath -Target $skillPath | Out-Null
Write-Host "Created symbolic link: '$linkPath' -> '$skillPath'"
