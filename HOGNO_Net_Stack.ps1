# Kelley Edwin Sims
# a.k.a Diaz Dizazter
# Windows 11 Network Stack Alignment for Online Gaming™
# 7.26.26

# https://github.com/diazdizazter/OnlineGamingNetworkOverhaul

# order of operations 
# net_stack > _Reg > _Hw

# disclaimer: This file "HOGNO_Net_Stack.ps1" assumes you have at least a greater than infintismal modcom of windows network knowledge
#             Yes, this file is for Windows 11, Like humans, the inside of every PC OS is different. Your mileage may vary
#             if you break your stuff, that is a you problem, not a me problem

Write-Host "Locking down your life long lover..." -ForegroundColor Yellow
# this is the part you go and find out the name of your nic
# disable so no active infighting occurs
Disable-NetAdapter -Name "BattleBitch" -Confirm:$false

Write-Host "In Happy Tcp Stack..." -ForegroundColor Green

# sucks do not use - included just to say do not use it
# netsh interface tcp set supplemental template=Internet congestionprovider=CTCP
# netsh interface tcp set supplemental template=InternetCustom congestionprovider=CTCP

# windows 10 and 11 default to cubic
# netsh interface tcp set supplemental template=Internet congestionprovider=CUBIC
# netsh interface tcp set supplemental template=InternetCustom congestionprovider=CUBIC

# by far my preferred favorite.  Your mileage may vary
netsh interface tcp set supplemental template=Internet congestionprovider=bbr2
netsh interface tcp set supplemental template=InternetCustom congestionprovider=bbr2

# some routers, networks and isp's like ecn, some do not. ecn requires an entirely ecn network aware travel interstate
# ecn can change on home networks depending upon setup, especially between wired, bluetooth and wifi. 
# by default neither setting is disabled or enabled.  most operating systems disable ecn by default  
# you will want to test whether or not it is beneficial for your usage metrics 

# netsh interface tcp set global ecncapability=disabled
netsh interface tcp set global ecncapability=enabled

# lower handshake latency
#not supported under netsh
# netsh int tcp set supplemental template=internet icw=10
# netsh int tcp set supplemental template=internetcustom icw=10

# something to normally just leave alone
netsh interface tcp set global autotuninglevel=normal

# one of the biggest issues with hardware is the kiss approach does not allow
# for easy activation of settings which are absolutel necessary 
netsh interface tcp set global rss=enabled

#this is good for downloading, not for gaming
netsh interface tcp set global rsc=disabled

# see above
netsh interface tcp set global dca=disabled 

# sacks are funny, the og values are horrible
netsh interface tcp set global nonsackrttresiliency=disabled 

# keep it low for a reason
netsh interface tcp set global maxsynretransmissions=2

# 5 ms is 5 ms
netsh interface tcp set global timestamps=disabled

# absolutely essential so that windows doesnt control your gaming
netsh interface tcp set heuristics disabled

# connection establishment speed improvement
netsh int tcp set global fastopen=enabled

# connection establishment fallback speed improvement
netsh int tcp set global fastopenfallback=enabled

Write-Host "IPv4 stack..." -ForegroundColor Green
netsh interface ipv4 set global taskoffload=enabled

# this defies port overload, ensuring that that ports are always open and active
Write-Host "Dynamic IPv4 Stack..." -ForegroundColor Green
netsh interface ipv4 set dynamicport tcp start=10000 num=55535
netsh interface ipv4 set dynamicport udp start=10000 num=55535

Write-Host "Udp Stack..." -ForegroundColor Green

# udp send offload
netsh interface udp set global uso=enabled

# udp packet coalescence 
netsh interface udp set global uro=disabled

Write-Host "Stack is getting naked to show you everything" -ForegroundColor Green

Start-Sleep -Seconds 4

Write-Host "Sexy Network BattleBitch has returned" -ForegroundColor Yellow
Enable-NetAdapter -Name "BattleBitch" -Confirm:$false
Start-Sleep -Seconds 6

ipconfig /flushdns
Start-Sleep -Seconds 3 

ipconfig /release
Start-Sleep -Seconds 4

ipconfig /renew
Start-Sleep -Seconds 4 

ipconfig /all
Start-Sleep -Seconds 4

Write-Host "Stack sure takes her time.... flashy flashy" -ForegroundColor Green
netsh interface ipv4 show global 
netsh interface ipv4 show tcpstats
netsh interface tcp show global
netsh interface tcp show rscstats
netsh interface tcp show supplemental
netsh interface udp show global 

# power setting alterations have been removed from public files 

# this is the part where I say you are welcome and happy gaming
# paypal edwin.kelsi54@gmail.com
