#https://github.com/diazdizazter/OnlineGamingNetworkOverhaul

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
