# PowerShell script to restart SmartMachineInterfacingService after login
# Save this as: RestartSmartMachineService.ps1

param(
    [int]$DelaySeconds = 5
)

# Create log file path
$LogPath = "$env:TEMP\SmartMachineServiceRestart.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host "$timestamp - $Message"
}

try {
    Write-Log "Starting service restart process for user: $env:USERNAME"
    
    # Wait for the specified delay
    Write-Log "Waiting $DelaySeconds seconds before restarting service..."
    Start-Sleep -Seconds $DelaySeconds
    
    $ServiceName = "SmartMachineInterfacingService"
    
    # Check if service exists
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if (-not $Service) {
        Write-Log "ERROR: Service '$ServiceName' not found!"
        exit 1
    }
    
    Write-Log "Current service status: $($Service.Status)"
    
    # Stop the service if it's running
    if ($Service.Status -eq 'Running') {
        Write-Log "Stopping service..."
        Stop-Service -Name $ServiceName -Force -ErrorAction Stop
        
        # Wait for service to stop (max 30 seconds)
        $timeout = 5
        $elapsed = 0
        while ((Get-Service -Name $ServiceName).Status -ne 'Stopped' -and $elapsed -lt $timeout) {
            Start-Sleep -Seconds 1
            $elapsed++
        }
        
        $currentStatus = (Get-Service -Name $ServiceName).Status
        Write-Log "Service stopped. Current status: $currentStatus"
        
        if ($currentStatus -ne 'Stopped') {
            Write-Log "WARNING: Service did not stop within $timeout seconds"
        }
    }
    
    # Start the service
    Write-Log "Starting service..."
    Start-Service -Name $ServiceName -ErrorAction Stop
    
    # Verify service started
    Start-Sleep -Seconds 3
    $FinalStatus = (Get-Service -Name $ServiceName).Status
    Write-Log "Service restart completed. Final status: $FinalStatus"
    
    if ($FinalStatus -eq 'Running') {
        Write-Log "SUCCESS: Service restarted successfully"
    } else {
        Write-Log "WARNING: Service may not have started properly"
    }
    
} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    exit 1
}