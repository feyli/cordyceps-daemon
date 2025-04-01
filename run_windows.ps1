# PowerShell script equivalent to run_ubuntu.sh

# Set working directory to user's home
$homeDir = [System.Environment]::GetFolderPath('UserProfile')
$hiddenDir = "$homeDir\.cordyceps_daemon"

# Create the hidden directory if it doesn't exist
if (!(Test-Path $hiddenDir)) {
    New-Item -ItemType Directory -Path $hiddenDir | Out-Null
}

# Change to the hidden directory
Set-Location -Path $hiddenDir

# Download the daemon script
Write-Output "Downloading daemon..."
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/feyli/cordyceps-daemon/refs/heads/main/cordyceps.py" -OutFile "daemon.py"

# Download bundled dependencies
Write-Output "Downloading bundled dependencies..."
Invoke-WebRequest -Uri "https://github.com/feyli/cordyceps-daemon/raw/refs/heads/main/dependencies.zip" -OutFile "dependencies.zip"
Expand-Archive -Path "dependencies.zip" -DestinationPath "dependencies"
Remove-Item "dependencies.zip"

# Detect Python version
$python = ""
if (Get-Command python3 -ErrorAction SilentlyContinue) {
    $python = "python3"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $python = "python"
} else {
    Write-Output "Python not found. Exiting."
    Remove-Item -Recurse -Force $hiddenDir
    exit 1
}

# Run the daemon
Write-Output "Starting cordyceps daemon..."
$env:PYTHONPATH = "$hiddenDir\dependencies"
Start-Process -NoNewWindow -FilePath $python -ArgumentList "daemon.py" -RedirectStandardOutput "out.log" -RedirectStandardError "err.log"

# Cleanup after process exits
Write-Output "Cleaning up..."
Remove-Item -Recurse -Force $hiddenDir
