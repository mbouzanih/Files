<#
.Synopsis
    TPM 1.2 -> TPM 2.0 Update Verifier
.DESCRIPTION
    Verifies that TPM 1.2 -> TPM 2.0 upgrade completed successfully.
.EXAMPLE
    TpmUpgradeVerifier.ps1
.NOTES
    Created:	 2017-09-19
    Version:	 1.0
    Author - Anton Romanyuk
    Twitter: @admiraltolwyn
    Blog   : http://www.vacuumbreather.com
    Disclaimer:
    This script is provided 'AS IS' with no warranties, confers no rights and 
    is not supported by the author.
.LINK
    http://www.vacuumbreather.com
.NOTES

#>

# Determine where to do the logging 
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$logPath = $tsenv.Value("LogPath")  
$logFile = "$logPath\$($myInvocation.MyCommand).log"
$Make = $TSenv.Value("Make")
 
# Start the logging 
Start-Transcript $logFile
Write-Host "$($myInvocation.MyCommand) - Logging to $logFile"
 
# Start Main Code Here
Switch ($Make){
"HP"{
    Write-Host "$($myInvocation.MyCommand) - Detecting whether the TPM upgrade was successfull."
    Write-Host "$($myInvocation.MyCommand) - For HP platforms that support TPM mode changes, the output from powershell should include: ManufacturerVersion: 6.40 or 6.41 (1.2 mode), or 7.41 (2.0 mode)"
    $tpm_mode = (Get-TPM).ManufacturerVersion
    Write-Host "$($myInvocation.MyCommand) - Following ManufacturerVersion detected: $tpm_mode"

    If ($tpm_mode -eq "6.40" -or $tpm_mode -eq "6.41") {
         
        Write-Warning "$($myInvocation.MyCommand) - TPM Mode 1.2->2.0 upgrade (probably) failed."
        Exit 0
    }
}
"Dell Inc."{
    
    Write-Host "$($myInvocation.MyCommand) - Detecting whether the TPM upgrade was successfull."
    Write-Host "$($myInvocation.MyCommand) - For Dell platforms that support TPM mode changes, the output from powershell should include: ManufacturerVersion: 5.81 (1.2 mode), or 1.3 (2.0 mode)"
    $tpm_mode = (Get-TPM).ManufacturerVersion
    Write-Host "$($myInvocation.MyCommand) - Following ManufacturerVersion detected: $tpm_mode"

    If ($tpm_mode -eq "5.81") {
        Write-Warning "$($myInvocation.MyCommand) - TPM Mode 1.2->2.0 upgrade (probably) failed."
        Exit 0
    }
}
Default {
        Write-Host "$($myInvocation.MyCommand) - $Make is unsupported, exit" 
        Exit 0
    }
}

# Stop logging 
Stop-Transcript