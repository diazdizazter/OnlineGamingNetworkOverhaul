#https://github.com/diazdizazter/OnlineGamingNetworkOverhaul

# disclaimer: HOGNO_Net_Revert.ps1" assumes you havbe at least a greater than infintismal modcom of windows network knowledge
#             if you break your stuff, that is a you problem, not a me problem
#
# full disclaimer: see readme.md and license.md

netsh winsock reset catalog
Start-Sleep -Seconds 4
netsh interface ip reset
Start-Sleep -Seconds 4
netsh interface tcp reset
Start-Sleep -Seconds 4
ipconfig /flushdns
Start-Sleep -Seconds 4
ipconfig /release
Start-Sleep -Seconds 4
ipconfig /renew
Start-Sleep -Seconds 4
ipconfig /all
Start-Sleep -Seconds 4
