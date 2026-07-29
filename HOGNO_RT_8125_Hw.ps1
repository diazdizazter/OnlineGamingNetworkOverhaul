# Kelley Edwin Sims
# a.k.a Diaz Dizazter
# Realtek 8125 - Gaming 2.5gbe Family
# 7.26.26

# order of operations 
# net_stack > _Reg > _Hw
# disclaimer: This file "HOGNO_RT_8125_Hw.ps1" assumes you havbe at least a greater than infintismal modcom of windows network knowledge
#             if you break your stuff, that is a you problem, not a me problem
#
# full disclaimer: see readme.md and license.md

Write-Host "Locking down your life long lover..." -ForegroundColor Yellow
# this is the part you go and find out the name of your nic
$Adapter = Get-NetAdapter | Where-Object { $_.Name -eq "Ethernet" }
# $Adapter = Get-NetAdapter | Where-Object { $_.Name -eq "BattleBitch" }

if (-not $Adapter) {
    Write-Error "Adapter 'Ethernet' not found. Run Get-NetAdapter to verify the name."
    return
}

# Disable-NetAdapter -Name "BattleBitch" -Confirm:$false

# find your nic name
Disable-NetAdapter -Name "Ethernet" -Confirm:$false

# Resolve did not resolve, all it did was create a \class\.name -eq "value"
# there for, due to inherent programmer laziness, with much resolve, we resolved to remove resolve in order to have this issue resolved

# this is the part you go and find out the name of your nic interface id and network interface chain id
$RegPath = "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003"

Write-Host "Live optimization path resolved to: hmm no fucking idea...  Battle Beetle does not exist in this Mandella Multiverse" -ForegroundColor Cyan

# Custom helper function to inject full parameter tables dynamically 
function Set-IntelParam {
    param (
        [string]$Keyword,
        [string]$Value,
        [string]$Description,
        [string]$Type = "enum",
        [string]$Default = "0"
    )
    # Direct raw injection 
    Reg Add $RegPath /v $Keyword /t REG_SZ /d $Value /f | Out-Null
    
    # Establish the Schema Infrastructure so Set-NetAdapterAdvancedProperty recognizes it
    Reg Add "$RegPath\Ndi\Params\$Keyword" /v "ParamDesc" /t REG_SZ /d $Description /f | Out-Null
    Reg Add "$RegPath\Ndi\Params\$Keyword" /v "default" /t REG_SZ /d $Default /f | Out-Null
    Reg Add "$RegPath\Ndi\Params\$Keyword" /v "type" /t REG_SZ /d $Type /f | Out-Null
}

# 2. Inject Int-Step Param Mappings (Fixes the unrecognized keyword errors)
Write-Host "Building Integer Schema Matrices..." -ForegroundColor Yellow

# Transmit Buffers Parameter Index Table
Set-IntelParam -Keyword "*TransmitBuffers" -Value "1664" -Description "TransmitBuffers" -Type "int" -Default "1664"
Reg Add "$RegPath\Ndi\Params\*TransmitBuffers" /v "Min" /t REG_SZ /d "256" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*TransmitBuffers" /v "Max" /t REG_SZ /d "2048" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*TransmitBuffers" /v "Step" /t REG_SZ /d "128" /f | Out-Null

# Receive Buffers Parameter Index Table
Set-IntelParam -Keyword "*ReceiveBuffers" -Value "1664" -Description "Receive Buffers" -Type "int" -Default "1664"
Reg Add "$RegPath\Ndi\Params\*ReceiveBuffers" /v "Min" /t REG_SZ /d "256" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*ReceiveBuffers" /v "Max" /t REG_SZ /d "2048" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*ReceiveBuffers" /v "Step" /t REG_SZ /d "128" /f | Out-Null

# 3. Inject Remaining Hardware Parameters
Write-Host "Offloads overrides..." -ForegroundColor Yellow

Enable-NetAdapterChecksumOffload -Name * -TcpIPv4 -UdpIPv4 -IpIPv4

Set-NetOffloadGlobalSetting -TaskOffload Enabled

#this covers Direct memory access.  doesnt exist on the Realtek gaming 2.5gbe.  
# the NIc has a function rx/tx system - fuck you Intel
#Set-NetOffloadGlobalSetting -NetworkDirect Disabled

Set-NetOffloadGlobalSetting -Chimney Disabled    # redundant as chimney depreceated in windows 10 build ~1600
                                                 # i like redundant though

Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled 

Disable-NetAdapterLso -Name *
Disable-NetAdapterRsc -Name *
Disable-NetAdapterPacketDirect -Name *

Write-Host "Offloads overrides of Overides..." -ForegroundColor Yellow

# Offloads (Keep IP offload active to prevent CPU bottlenecking, disable RSC for raw registration)
Set-IntelParam -Keyword "*TCPConnectionOffloadIPv4" -Value "0" -Description "TCP Connection Offload IPv4" -Default "0"
Set-IntelParam -Keyword "*TCPConnectionOffloadIPv6" -Value "0" -Description "TCP Connection Offload IPv6" -Default "0"
Set-IntelParam -Keyword "*UDPConnectionOffloadIPv4" -Value "0" -Description "UDP Connection Offload IPv4" -Default "0"
Set-IntelParam -Keyword "*UDPConnectionOffloadIPv6" -Value "0" -Description "UDP Connection Offload IPv6" -Default "0"

Set-IntelParam -Keyword "EnableRsc" -Value "0" -Description "Enable RSC" -Default "0"
Set-IntelParam -Keyword "*RscIPv4" -Value "0" -Description "Receive Segment Coalescing IPv4" -Default "0"
Set-IntelParam -Keyword "*RscIPv6" -Value "0" -Description "Receive Segment Coalescing IPv6" -Default "0"

Set-IntelParam -Keyword "*PacketCoalescing" -Value "0" -Description "Packet Coalescing" -Default "0"
Set-IntelParam -Keyword "PacketCoalescingFilter" -Value "0" -Description "Packet Coalescing Filter" -Default "0"

#rewrite OG values
Write-Host "No More Og Values pt 2..." -ForegroundColor Yellow
# DEFAULT IS 5, DO NOT KNOW WHAT 0-4 ARE
Set-IntelParam -Keyword "ASPM" -Value "0" -Description "ASPM" -Default "0" # if needed this is a dword
Reg Add "$RegPath\Ndi\Params\ASPM\Enum" /v "0" /t REG_SZ /d "Off" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\ASPM\Enum" /v "1" /t REG_SZ /d "On" /f | Out-Null

Set-IntelParam -Keyword "ActiveStatePowerManagement" -Value "0" -Description "Active State Power Management" -Default "0"
Set-IntelParam -Keyword "*EEE" -Value "0" -Description "EEE Energy Efficient Ethernet" -Default "0"
Set-IntelParam -Keyword "*InterruptModeration" -Value "0" -Description "Interrupt Moderation" -Default "0"
Set-IntelParam -Keyword "*IPChecksumOffloadIPv4" -Value "3" -Description "IPv4 Checksum Offload" -Default "3"

Write-Host "Extreme Power Saving & Sleep Destruction..." -ForegroundColor Yellow

# Reg Add $RegPath /v "LogDisconnectEvent" /t REG_SZ /d "16" /f | Out-Null
Set-IntelParam -Keyword "LogDisconnectEvent" -Value "16" -Description "Log Disconnect State" -Default "16"

Disable-NetAdapterPowerManagement -Name "BattleBitch" -NoRestart | Out-Null
# Disable-NetAdapterPowerManagement -Name * -NoRestart | Out-Null

Set-NetAdapterPowerManagement -name * -NSOffload Disabled
Set-NetAdapterPowerManagement -name * -ARPOffload Disabled
Set-NetAdapterPowerManagement -name * -SelectiveSuspend Disabled
Set-NetAdapterPowerManagement -name * -DeviceSleepOnDisconnect Disabled
Set-NetAdapterPowerManagement -name * -WakeOnMagicPacket Disabled
Set-NetAdapterPowerManagement -name * -WakeOnPattern Disabled

# this shows up as a different key for the realtek
# Set-NetAdapterAdvancedProperty -Name * -DisplayName "Wake on Magic Packet from S5" -RegistryValue "0"

# Rss values for Intel i5-11400 (6C/12T) Dual-Queue Setup
Write-Host "Building RSS Tables..." -ForegroundColor Yellow

# 1. Base Queue Count (Set to 2 Queues for optimal FPS caching)
Set-IntelParam -Keyword "*NumRssQueues" -Value "3" -Description "Number of RSS Queues" -Type "enum" -Default "3"
Reg Add "$RegPath\Ndi\Params\*NumRssQueues\Enum" /v "1" /t REG_SZ /d "1 Queue" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*NumRssQueues\Enum" /v "2" /t REG_SZ /d "2 Queues" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*NumRssQueues\Enum" /v "3" /t REG_SZ /d "3 Queues" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*NumRssQueues\Enum" /v "4" /t REG_SZ /d "4 Queues" /f | Out-Null

# 2. RSS Profile Configuration (Set to 1 = ClosestProcessor for lowest latency paths)
Set-IntelParam -Keyword "*RSSProfile" -Value "1" -Description "RSS load balancing profile?" -Type "enum" -Default "1"
Reg Add "$RegPath\Ndi\Params\*RSSProfile\Enum" /v "1" /t REG_SZ /d "#ClosestProcessor" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RSSProfile\Enum" /v "2" /t REG_SZ /d "2ClosestProcessorStatic" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RSSProfile\Enum" /v "3" /t REG_SZ /d "NUMAScaling" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RSSProfile\Enum" /v "4" /t REG_SZ /d "NUMAScalingStatic" /f | Out-Null

# Duplicate non-asterisk legacy property string just in case the driver is finicky
Set-IntelParam -Keyword "RSSProfile" -Value "1" -Description "RSS load balancing profile!" -Type "enum" -Default "1"
Reg Add "$RegPath\Ndi\Params\RSSProfile\Enum" /v "1" /t REG_SZ /d "ClosestProcessor" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\RSSProfile\Enum" /v "2" /t REG_SZ /d "ClosestProcessorStatic" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\RSSProfile\Enum" /v "3" /t REG_SZ /d "NUMAScaling" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\RSSProfile\Enum" /v "4" /t REG_SZ /d "NUMAScalingStatic" /f | Out-Null

Set-IntelParam -Keyword "*RssOrMsi" -Value "3" -Description "RSS or Mxi X Interupts" -Type "enum" -Default "3"
Reg Add "$RegPath\Ndi\Params\*RssOrMsi\Enum" /v "0" /t REG_SZ /d "Off" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RssOrMsi\Enum" /v "1" /t REG_SZ /d "Rss On" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RssOrMsi\Enum" /v "2" /t REG_SZ /d "Msi X On" /f | Out-Null
Reg Add "$RegPath\Ndi\Params\*RssOrMsi\Enum" /v "3" /t REG_SZ /d "Rss & Msi X" /f | Out-Null

# NumaNodeId = 65535 = windows management
#Set-IntelParam -Keyword "*NumaNodeId" -Description "NUMA Node Id" -Type "int" -Default "65535" -Max "65535" -Min "1000" -Step "100" -Base "1000"
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\*NumaNodeId" /v "Numa Node Id " /t REG_SZ /d "Numa Node Id" /f

# 3. Define the Core Affinity Target Bounds (Bypassing Core 0)
Set-IntelParam -Keyword "*MaxRssProcessors" -Value "2" -Description "Max RSS Processors" -Type "int" -Default "2"

# Force RSS to bypass CPU 0/1 and pin to Physical Thread 2 (Core 1)
Reg Add $RegPath /v "*RssBaseProcGroup" /t REG_DWORD /d 0 /f | Out-Null
Reg Add $RegPath /v "*RssMaxProcGroup" /t REG_DWORD /d 0 /f | Out-Null
Reg Add $RegPath /v "*RssBaseProcNumber" /t REG_DWORD /d 2 /f | Out-Null
Reg Add $RegPath /v "*RssMaxProcNumber" /t REG_DWORD /d 4 /f | Out-Null

Reg Add $RegPath /v "BaseProcessorNumber" /t REG_DWORD /d 2 /f | Out-Null
Reg Add $RegPath /v "MaxProcessorNumber" /t REG_DWORD /d 4 /f | Out-Null

# Value 1 (ClosestProcessor): Uses the CPU cores closest to the PCIe slot and dynamically rebalances queues depending on core load.
# Value 2 (ClosestProcessorStatic): Distributes RSS queues across cores statically without dynamic runtime rebalancing.
# gaming, ClosestProcessor is preferred - On an i5-11400 (6C/12T), dynamic rebalancing prevents queue starvation if one specific logical core gets saturated by a heavy game thread.

# 3.5 Global Operating System Core-Scaling Flag Ensure
Set-NetOffloadGlobalSetting -ReceiveSideScaling Enabled | Out-Null

Write-Host "Thor is tired, wait... no... he has an energy drink..." -ForegroundColor Green
Write-Host "Thor was knocked out by a tazer..." -ForegroundColor Green

# find your nic name
Enable-NetAdapter -Name "Ethernet" -Confirm:$false
# Enable-NetAdapter -Name "BattleBitch" -Confirm:$false
Write-Host "Sexy Network Battlestation throws the used tazer at the Twitching Thor" -ForegroundColor Yellow

Start-Sleep -Seconds 5

ipconfig /flushdns
Start-Sleep -Seconds 4

ipconfig /release
Start-Sleep -Seconds 4

ipconfig /renew
Start-Sleep -Seconds 4 

ipconfig /all
Start-Sleep -Seconds 4

Write-Host "Sexy Network Battlestation is ready for virtual murder" -ForegroundColor Yellow

Start-Sleep -Seconds 3 
Write-Host "Verifying Set-NetAdapterAdvancedProperty queries..." -ForegroundColor Cyan

# 5. Full Diagnostics Status Index Output
Write-Host "`n================ HARDWARE CONNECTION DIAGNOSTICS ================" -ForegroundColor Cyan

# find your nic name
Get-NetAdapter -Name "Ethernet" | Select-Object Name, InterfaceDescription, Status, LinkSpeed, MacAddress | Format-List
Get-NetAdapterAdvancedProperty -Name "BattleBitch" | Where-Object { $_.DisplayName -match "Buffer" -or $_.DisplayName -match "Ethernet" } | Format-Table -AutoSize
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" | Select-Object *Rss*, *Buffer*, ASPM, *EEE*

Write-Host "Genocidal PC sets 'Yay'..." -ForegroundColor Green

# power setting alterations have been removed from public files 
# this is the part wherwe I say you are welcome
# paypal edwin.kelsi54@gmail.com
