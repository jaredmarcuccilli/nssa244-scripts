# Jared Marcuccilli
# NSSA-244

function Show-Menu { # Print the menu options
    param (
        [string]$Title = 'VM Stuff'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to create a VM."
    Write-Host "2: Press '2' to list existing VMs."
    Write-Host "3: Press '3' to start a VM."
    Write-Host "4: Press '4' to stop a VM."
    Write-Host "5: Press '5' to list the settings of a VM."
    Write-Host "6: Press '6' to delete a VM."
    Write-Host "Q: Press 'Q' to quit."
}

do { # Main program loop
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' { # Create a VM
            $name = Read-Host "Enter VM name"
            $memory = Read-Host "Enter VM memory"
            #$memory_bytes = $memory_gigs * 1000000000 # Convert gigabytes to bytes

            $selection = Read-Host "Enter 'new' for a new VHD, or 'existing' to use an existing VHD"
            switch ($selection) {
                "new" { 
                    $path = Read-Host "Enter file path to use (ending with {name}.vhdx)"
                    $size = Read-Host "Enter disk size"
                    #$size = $size * 1000000000 # Convert gigabytes to bytes
                    New-VM -Name $name -MemoryStartupBytes $memory -NewVHDPath $path -NewVHDSizeBytes $size
                }

                "existing" { 
                    $path = Read-Host "Enter file path of VHD"
                    New-VM -Name $name -MemoryStartupBytes $memory -VHDPath $path
                }
            }

        } '2' { # List VMs
            Write-Host "Existing VMs:"
            $out = Get-VM | Out-String
            Write-Host $out
        
        } '3' { # Start a VM
            $selection = Read-Host "Enter VM name to START"
            Start-VM $selection
        
        } '4' { # Stop a VM
            $selection = Read-Host "Enter VM name to STOP"
            Stop-VM $selection -Force
        
        } '5' { # List settings of a VM
            $selection = Read-Host "Enter VM name to LIST SETTINGS"

            # Network settings
            $out = Get-VMNetworkAdapter -VMName $selection | Out-String
            Write-Host "Network settings:"
            Write-Host $out
            
            # Processor settings
            $out = Get-VMProcessor -VMName $selection | Out-String
            Write-Host "Processor settings:"
            Write-Host $out
            
            # Memory settings
            $out = Get-VMMemory -VMName $selection | Out-String
            Write-Host "Memory settings:"
            Write-Host $out
            
            # Bios settings
            $out = Get-VMBios -VMName $selection | Out-String
            Write-Host "BIOS settings:"
            Write-Host $out
            
            # Security settings
            $out = Get-VMSecurity -VMName $selection | Out-String
            Write-Host "Security settings:"
            Write-Host $out
            
            # Disk settings
            $out = Get-VMHardDiskDrive -VMName $selection | Out-String
            Write-Host "Disk settings:"
            Write-Host $out
        
        } '6' { # Delete a VM
            $selection = Read-Host "Enter VM name to DELETE"
            Remove-VM $selection -Force
        }
    }
    pause
 }
 until ($selection -eq 'q')

 # -- Sources --
 # Menu: https://adamtheautomator.com/powershell-menu/
 # Cmdlets: https://docs.microsoft.com/en-us/powershell/module/hyper-v/?view=windowsserver2019-ps