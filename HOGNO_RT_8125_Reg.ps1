# Kelley Edwin Sims
# a.k.a Diaz Dizazter
# Realtek Gaming 2.5GbE Family Controller
# 7.26.26

# order of operations 
# HOGNO_net_stack > HOGNO_RT_8125_Reg > HOGNO_RT_8125_Hw

# disclaimer: This file "HOGNO_RT_8125_Reg.ps1" assumes you havbe at least a greater than infintismal modcom of windows network knowledge
#             if you break your stuff, that is a you problem, not a me problem
#
# full disclaimer: see readme.md and license.md

Write-Host "Locking down your life long lover..." -ForegroundColor Yellow

# this is the part you go and find out the name of your nic
Disable-NetAdapter -Name "Ethernet" -Confirm:$false
# Disable-NetAdapter -Name "BattleBitch" -Confirm:$false

Write-Host "Multimedia..." -ForegroundColor Green

# # run this before Prime_Hw to propagate most of the ndi params that are missing
$SpPath="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
reg add $SpPath /t REG_DWORD /v SystemResponsiveness /d 0 /f 
reg add $SpPath /t REG_DWORD /v NetworkThrottlingIndex /d 0xffffffff /f 

Write-Host "Tcp Params..." -ForegroundColor Green

$ParamPath="HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
reg add $ParamPath /t REG_DWORD /v MaxUserPort /d 65534 /f 
reg add $ParamPath /t REG_DWORD /v TcpTimedWaitDelay /d 30 /f 

# this is the part you go and find out the name of your nic interface id
#USE netsh lan show interfaces
Write-Host "Ack Ack..." -ForegroundColor Green

# YES YOU HAVE TO INTERACT HERE.  DAMN OUR NERD LAZINESS
# c66efc71-87da-4ed4-8a12-3f52225e9d35
Reg Add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\c66efc71-87da-4ed4-8a12-3f52225e9d35" /t REG_DWORD /v TCPAckFrequency /d 1 /f 
Reg Add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\c66efc71-87da-4ed4-8a12-3f52225e9d35" /t REG_DWORD /v TCPNoDelay /d 1 /f 
Reg Add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\c66efc71-87da-4ed4-8a12-3f52225e9d35" /t REG_DWORD /v MTU /d 1500 /f 

Write-Host "Rss gets the Rizz..." -ForegroundColor Green

# this is the part where you have to know what pnp slot the nic is in the interface chain
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*RSS" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RSS" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSS" /v "ParamDesc" /t REG_SZ /d "Receive Side Scaling" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSS" /v "default" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSS" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSS\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSS\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*NumRssQueues" /t REG_SZ /d "2" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues" /v "ParamDesc" /t REG_SZ /d "Number of RSS Queues" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues" /v "default" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues\Enum" /v "1" /t REG_SZ /d "1 Queue" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues\Enum" /v "2" /t REG_SZ /d "2 Queues" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues\Enum" /v "3" /t REG_SZ /d "3 Queues" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*NumRssQueues\Enum" /v "4" /t REG_SZ /d "4 Queues" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*RSSProfile" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile" /v "ParamDesc" /t REG_SZ /d "*RSS load balancing profile#" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile" /v "default" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile\Enum" /v "1" /t REG_SZ /d "Closest" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile\Enum" /v "2" /t REG_SZ /d "ClosestStatic" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile\Enum" /v "3" /t REG_SZ /d "NUMAScaling" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile\Enum" /v "4" /t REG_SZ /d "NUMAScalingStatic" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RSSProfile\Enum" /v "5" /t REG_SZ /d "ConservativeScaling" /f

#probable bullshit RSS
Write-Host "The defaulting of default values has been defaulted to the new default defaults.." -ForegroundColor Green

# this deals with resets from og to new defaults ONLY 
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*FlowControl" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*FlowControl" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*LsoV2IPv4" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*LsoV2IPv6" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*LsoV2IPv6" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*NumaNodeId" /t REG_SZ /d "65535" /f    #system os management

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*PMARPOffload" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PMARPOffload" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*PMNSOffload" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PMNSOffload" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPChecksumOffloadIPv4" /v "default" /t REG_SZ /d "3" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPChecksumOffloadIPv4" /v "default" /t REG_SZ /d "3" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPChecksumOffloadIPv6" /v "default" /t REG_SZ /d "3" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPChecksumOffloadIPv6" /v "default" /t REG_SZ /d "3" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*WakeOnMagicPacket" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*WakeOnPattern" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*WakeOnPattern" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "AdvancedEEE" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\AdvancedEEE" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableGreenEthernet" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "GigaLite" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\GigaLite" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "LogDisconnectEvent" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\LogDisconnectEvent" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PowerSavingMode" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PowerSavingMode" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "S0MgcPkt" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\S0MgcPkt" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "S5WakeOnLan" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\S5WakeOnLan" /v "default" /t REG_SZ /d "0" /f

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "WolShutdownLinkSpeed" /t REG_SZ /d "2" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\WolShutdownLinkSpeed" /v "default" /t REG_SZ /d "0" /f

Write-Host "Pnp mu-h pizzle..." -ForegroundColor Green

#PnPCapabilities
# 24 = selective suspend 
# 108 - disables wake, power management and selective suspend  
# registry says 108 = 264
# registry says 118 = 280
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PnPCapabilities" /t REG_DWORD /d "280" /f     # 108 or 118 in hex???

# you should probably avoid changing what ever, but, who am I to judge 
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "ASPM" /t REG_DWORD /d "0" /f               #power saving bullshit
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "CFHTime" /t REG_DWORD /d "0" /f                # channel wait times
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "Characteristics" /t REG_DWORD /d "0" /f
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "CHNLWCnt" /t REG_DWORD /d "0" /f              # channel wait times
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "CHNLWTime" /t REG_DWORD /d "0" /f              # channel wait times
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "CLKREQ" /t REG_DWORD /d "0" /f           #power saving bullshit
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "ComboPerfAdjust" /t REG_SZ /d "0" /f     #performance scale
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "CRSPDThreshold" /t REG_DWORD /d "0" /f      #carrier speed detection
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "DACount" /t REG_DWORD /d "0" /f    #performance scale
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "DAInterval" /t REG_DWORD /d "0" /f     #performance scale
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "EnableEDT" /t REG_SZ /d "1" /f            #enhanced data transmission flag
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "ENPWMode" /t REG_SZ /d "0" /f             #phase locked loops
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "GPPSW" /t REG_SZ /d "0" /f       # power phase circuit switch
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwBpMask" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwFPSM" /t REG_DWORD /d "0" /f             #timeout idle
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwMode" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOptimize" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOption" /t REG_DWORD /d "0" /f                     #hardware masks
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOptionV2" /t REG_DWORD /d "10000000" /f
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOptionV3" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOptionV4" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwOptionV5" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwParaMask" /t REG_DWORD /d "0" /f                     #hardware masks
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "HwWolCrcVal" /t REG_DWORD /d "0" /f # wake on lan crc
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "IntMitiInterval" /t REG_DWORD /d "0" /f             # interrupt interval
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "L1L0sLT" /t REG_DWORD /d "0" /f                    # aspm params
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "LDWTime" /t REG_DWORD /d "0" /f              # channel wait times
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "LTROBFF" /t REG_DWORD /d "4" /f   # latency tolerance reporting - optimized buffer flush
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "MRRSize" /t REG_DWORD /d "0" /f   # max read request
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PowerDownPll" /t REG_SZ /d "0" /f           # power phase circuit switch
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PPSW" /t REG_SZ /d "0" /f           # power phase circuit switch
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PSLimit" /t REG_DWORD /d "8" /f            #timeout idle
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RDBSize" /t REG_DWORD /d "0xFFFFFFFF" /f      #descriptor buffer size
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RIACP" /t REG_SZ /d "0" /f
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RMPT" /t REG_DWORD /d "0" /f
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RtHwCapability" /t REG_DWORD /d "c" /f
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RtIdleTimeout" /t REG_DWORD /d "0" /f               #timeout idle
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "RxOptimizeThreshold" /t REG_DWORD /d "0" /f    #dma triggers
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "S5NicKeepOverrideMacAddr" /t REG_SZ /d "0" /f  # wake on lan crc
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "S5NicKeepOverrideMacAddrV2" /t REG_SZ /d "0" /f  # wake on lan crc
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "SwIML" /t REG_DWORD /d "0" /f                # interrupt interval
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "SwIML100" /t REG_DWORD /d "0" /f          # interrupt interval
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "SwIML100V2" /t REG_DWORD /d "0" /f          # interrupt interval
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "SwIMLV2" /t REG_DWORD /d "0" /f          # interrupt interval
# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "SwParaMask" /t REG_DWORD /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "TDBSize" /t REG_DWORD /d "0xFFFFFFFF" /f #descriptor buffer size
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "TxOptimizeThreshold" /t REG_DWORD /d "0" /f     #dma triggers
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "UCEM" /t REG_DWORD /d "0" /f           #power saving bullshit

Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile" /v "ParamDesc" /t REG_SZ /d "RSS load balancing profile^" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile" /v "default" /t REG_SZ /d "1" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile\Enum" /v "1" /t REG_SZ /d "Closest" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile\Enum" /v "2" /t REG_SZ /d "ClosestStatic" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile\Enum" /v "3" /t REG_SZ /d "NUMAScaling" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile\Enum" /v "4" /t REG_SZ /d "NUMAScalingStatic" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\RSSProfile\Enum" /v "5" /t REG_SZ /d "ConservativeScaling" /f

Write-Host "Ramming Registry settings into Enumeration ..." -ForegroundColor Green

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "ParamDesc" /t REG_SZ /d "TransmitBuffers" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "default" /t REG_SZ /d "1024" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "type" /t REG_SZ /d "int" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "Min" /t REG_SZ /d "256" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "Max" /t REG_SZ /d "2048" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TransmitBuffers" /v "Step" /t REG_SZ /d "128" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "ParamDesc" /t REG_SZ /d "Receive Buffers" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "default" /t REG_SZ /d "1024" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "type" /t REG_SZ /d "int" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "Min" /t REG_SZ /d "256" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "Max" /t REG_SZ /d "2048" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*ReceiveBuffers" /v "Step" /t REG_SZ /d "128" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*TCPConnectionOffloadIPv4" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv4" /v "ParamDesc" /t REG_SZ /d "TCP Connection Offload IPv4" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv4" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv4" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv4\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv4\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*TCPConnectionOffloadIPv6" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv6" /v "ParamDesc" /t REG_SZ /d "TCP Connection Offload IPv6" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv6" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv6" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv6\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*TCPConnectionOffloadIPv6\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*UDPConnectionOffloadIPv4" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv4" /v "ParamDesc" /t REG_SZ /d "UDP Connection Offload IPv4" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv4" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv4" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv4\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv4\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*UDPConnectionOffloadIPv6" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv6" /v "ParamDesc" /t REG_SZ /d "UDP Connection Offload IPv6" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv6" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv6" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv6\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*UDPConnectionOffloadIPv6\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*IPChecksumOffloadIPv4" /v "ParamDesc" /t REG_SZ /d "IP Checksum Offload IPv4" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*IPChecksumOffloadIPv4" /v "default" /t REG_SZ /d "3" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*IPChecksumOffloadIPv4" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*IPChecksumOffloadIPv4\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*IPChecksumOffloadIPv4\Enum" /v "1" /t REG_SZ /d "Enabled" /f

Write-Host "Probably..." -ForegroundColor Green

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*PacketCoalescing" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PacketCoalescing" /v "ParamDesc" /t REG_SZ /d "*Packet Coalescing" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PacketCoalescing" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PacketCoalescing" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PacketCoalescing\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*PacketCoalescing\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "PacketCoalescingFilter" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PacketCoalescingFilter" /v "ParamDesc" /t REG_SZ /d "Packet Coalescing Filter" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PacketCoalescingFilter" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PacketCoalescingFilter" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PacketCoalescingFilter\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\PacketCoalescingFilter\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*RscIPv4" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv4" /v "ParamDesc" /t REG_SZ /d "*Receive Side Coalescing IPv4" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv4" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv4" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv4\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv4\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "*RscIPv6" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv6" /v "ParamDesc" /t REG_SZ /d "*Receive Side Coalescing IPv6" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv6" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv6" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv6\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\*RscIPv6\Enum" /v "1" /t REG_SZ /d "Enabled" /f

# Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003" /v "EnableRSC" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableRSC" /v "ParamDesc" /t REG_SZ /d "Enable Receive Side Coalescing" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableRSC" /v "default" /t REG_SZ /d "0" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableRSC" /v "type" /t REG_SZ /d "enum" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableRSC\Enum" /v "0" /t REG_SZ /d "Disabled" /f
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0003\Ndi\Params\EnableRSC\Enum" /v "1" /t REG_SZ /d "Enabled" /f

Write-Host "Thor is tired, wait... no... he has an energy drink..." -ForegroundColor Green
Write-Host "Thor was knocked out by a tazer..." -ForegroundColor Green
Write-Host "Sexy Network BattleBit;ch has returned" -ForegroundColor Yellow

# find your nic name
Enable-NetAdapter -Name "Ethernet" -Confirm:$false
# Enable-NetAdapter -Name "BattleBitch" -Confirm:$false

# Write-Host "Yay" -ForegroundColor Green

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

# power setting alterations have been removed from public files
# this is the part wherwe I say you are welcome
# paypal edwin.kelsi54@gmail.com

# yes, splitting these makes it easier for you to test