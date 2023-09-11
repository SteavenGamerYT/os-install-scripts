echo Debloat
powershell -command "Get-AppxPackage Microsoft.People* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *onenote* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.BingWeather* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.BingSports* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.ZuneVideo* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.OneNote* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.ZuneMusic* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.SkypeApp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.BingNews* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MicrosoftEdge* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.WindowsAlarms* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.WindowsFeedbackHub* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.WindowsSoundRecorder* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Windows.Calendar* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.ToDo* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.Word* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.Excel* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.PowerPoint* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.Outlook* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MixedReality.Portal* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MicrosoftNews* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.GetHelp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MSPaint* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.Office.* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.YourPhone* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.MicrosoftPrinttoPDF* | Remove-AppxPackage"
powershell -command "Get-AppxPackage Microsoft.SkyDrive* | Remove-AppxPackage"
taskkill /f /im OneDrive.exe
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall

echo Winget
winget install -e --id Mozilla.Firefox
winget install -e --id Discord.Discord
winget install -e --id AIMP.AIMP
winget install -e --id Nextcloud.NextcloudDesktop
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id VideoLAN.VLC
winget install -e --id CodecGuide.K-LiteCodecPack.Mega
winget install -e --id GitHub.GitHubDesktop
winget install -e --id ArduinoSA.IDE.stable
winget install -e --id valinet.ExplorerPatcher
winget install -e --id qBittorrent.qBittorrent
winget install -e --id Unity.UnityHub
winget install -e --id Microsoft.VisualStudio.2022.Community
winget install -e --id Mojang.MinecraftLauncher
winget install -e --id PrismLauncher.PrismLauncher
winget install -e --id OBSProject.OBSStudio
winget install -e --id KDE.Kdenlive
winget install -e --id GIMP.GIMP.Nightly
winget install -e --id KDE.Krita
winget install -e --id Parsec.Parsec
winget install -e --id MoonlightGameStreamingProject.Moonlight
winget install -e --id LizardByte.Sunshine
winget install -e --id Valve.Steam
winget install -e --id EpicGames.EpicGamesLauncher
winget install -e --id HeroicGamesLauncher.HeroicGamesLauncher
winget install -e --id M2Team.NanaZip
winget install -e --id Microsoft.WindowsTerminal
winget install -e --id yt-dlp.yt-dlp
winget install -e --id Starship.Starship
winget install -e --id SomePythonThings.WingetUIStore

echo Choco
powershell -command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
choco install chocolateygui mpv.install winaero-tweaker.install qownnotes vcredist2005 vcredist2008 vcredist2010  vcredist2012 msvisualcplusplus2012-redist vcredist2013 vcredist2017 vcredist140 vcredist-all adoptopenjdk8openj9jre adoptopenjdk11openj9jre directx netfx-4.8.1 -y
echo Wsl
wsl --install
winget install -e --id whitewaterfoundry.fedora-remix-for-wsl

echo Tweaks
echo Disabling Web Search and Cortana
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f> nul
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f> nul
echo Hiding Cortana From Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f> nul
echo Hiding Teams Icon From Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f> nul
echo Disabling Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f> nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable> nul
echo Disabling Wi-Fi Sense...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Wifi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Wifi\AllowWiFiHotSpotReporting" /v "Value" /t REG_DWORD /d "0" /f> nul
echo Disabling Application suggestions...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f> nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f> nul
echo Disabling Activity History...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f> nul
echo Disabling Location Tracking...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d "0" /f> nul
echo Disabling Feedback...
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f> nul
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable> nul
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable> nul
echo Uninstalling Feedback Hub
powershell -command "Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage"> nul
echo Disabling Advertising ID...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f> nul
echo Disabling Error reporting...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f> nul
echo Restricting Windows Update P2P only to local network...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "1" /f> nul
echo Stopping and disabling Diagnostics Tracking Service...
sc stop DiagTrack> nul
sc config "DiagTrack" start=disabled> nul
echo Stopping and disabling WAP Push Service...
sc stop dmwappushservice> nul
sc config "dmwappushservice" start=disabled> nul
echo Enabling F8 boot menu options...
bcdedit /set {current} bootmenupolicy Legacy> nul
echo Stopping and disabling Home Groups services...
sc stop HomeGroupListener> nul
sc config "HomeGroupListener" start=disabled> nul
sc stop HomeGroupProvider> nul
sc config "HomeGroupProvider" start=disabled> nul
echo Disabling Remote Assistance...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f> nul
echo Enabling Hibernation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HibernteEnabled" /t REG_DWORD /d "1" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowHibernateOption" /t REG_DWORD /d "1" /f> nul
echo Showing file operations details...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f> nul
echo Hiding Cortana Button...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f> nul
echo Hiding Task View button...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f> nul
echo Hiding People icon...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d "0" /f> nul
echo Hide tray icons...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "1" /f> nul
echo Enabling NumLock after startup...
reg add "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_DWORD /d "558319670" /f> nul
echo Changing default Explorer view to This PC...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f> nul
echo Using regedit to improve RAM 
echo Making System Responsiveness Better using regedit
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f> nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_DWORD /d "2000" /f> nul
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f> nul
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f> nul
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f> nul
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f> nul
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "1000" /f> nul
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "8" /f> nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f> nul