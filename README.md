# Windows-Auto-Update-Control
Stop Windows 7, 8, 10 from performing unwarranted auto-updates without user permissions.

I am so sick and tired of MS forcing these crappy updates on to my computers which cause me to lose work or even worse, cause BSOD's because the updates are flawed.  So I dug just deep enough into the registry to prevent the updates.

Let's keep in mind this code is eventually going to be integrated into a higher-level code which may include menus.


Use the following values for setting the Auto-Update Option (AUOption):  
&emsp;&emsp;2 = Notify before download.  
&emsp;&emsp;3 = Automatically download and notify of installation.  
&emsp;&emsp;4 = Automatically download and schedule installation. Only valid if values exist for ScheduledInstallDay and ScheduledInstallTime.  
&emsp;&emsp;5 = Automatic Updates is required and users can configure it.  

So you will need to set the value of `$auOption` such as  `$auOption = 2` 

As always I am thankful for any support.
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/MegaphatNetwork)
