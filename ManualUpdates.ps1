
Function Wait ($secs) {
	if (!($secs)) {$secs = 1}
	Start-Sleep $secs
}

Function Say($something) {
	Write-Host $something 
}

Function SayB($something) {
	Write-Host $something -ForegroundColor darkblue -BackgroundColor white
}

Function isOSTypeHome {
	$ret = (Get-WmiObject -class Win32_OperatingSystem).Caption | select-string "Home"
	Return $ret
}

Function isOSTypePro {
	$ret = (Get-WmiObject -class Win32_OperatingSystem).Caption | select-string "Pro"
	Return $ret
}

Function isOSTypeEnt {
	$ret = (Get-WmiObject -class Win32_OperatingSystem).Caption | select-string "Ent"
	Return $ret
}

Function getWinVer {
	$ret = (Get-WMIObject win32_operatingsystem).version
	Return $ret
}

function getWin10Ver {
	$wver = (Get-ComputerInfo).WindowsVersion
	Return $wver
}

Function isAdminLocal {
	$ret = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
	Return $ret
}

Function isAdminDomain {
	$ret = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Domain Admins")
	Return $ret
}

Function isElevated {
	$ret = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
	Return $ret
}

Function regSet ($KeyPath, $KeyItem, $KeyValue) {
	$Key = $KeyPath.Split("\")
	ForEach ($level in $Key) {
		If (!($ThisKey)) {
			$ThisKey = "$level"
		} Else {
			$ThisKey = "$ThisKey\$level"
		}
		If (!(Test-Path $ThisKey)) {New-Item $ThisKey -Force -ErrorAction SilentlyContinue | out-null}
	}
	if ($KeyValue -ne $null) {
		Set-ItemProperty $KeyPath $KeyItem -Value $KeyValue -ErrorAction SilentlyContinue 
	} Else {
		Remove-ItemProperty $KeyPath $KeyItem -ErrorAction SilentlyContinue 
	}
}

Function regGet($Key, $Item) {
	If (!(Test-Path $Key)) {
		Return
	} Else {
		If (!($Item)) {$Item = "(Default)"}
		$ret = (Get-ItemProperty -Path $Key -Name $Item -ErrorAction SilentlyContinue).$Item
		Return $ret
	}
}


function Elevate() {
	Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`" elevate" -f $PSCommandPath) -Verb RunAs
}




# # # # # # # # # # # # # # # # # # # # 
# # # # BEGIN MAIN ROUTINES # # # # # # 
# # # # # # # # # # # # # # # # # # # #

if (!(isElevated)) {Elevate}

<#
Use the following values for setting the Auto-Update Option (AUOption):
	2 = Notify before download.
	3 = Automatically download and notify of installation.
	4 = Automatically download and schedule installation. Only valid if values exist for ScheduledInstallDay and ScheduledInstallTime.
	5 = Automatic Updates is required and users can configure it.
#>
$auOption = 2
if ((regGet "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" "AUOptions") -ne $auOption) {
	regSet "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" "AUOptions" $auOption
}
if ((regGet "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions") -ne $auOption) {
	regSet "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" $auOption
}
#Uncomment the next line if autoupdates persist
#regSet "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 1
