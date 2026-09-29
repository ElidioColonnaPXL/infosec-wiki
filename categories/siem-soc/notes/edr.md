# EDR

Endpoint devices (workstations, laptops, etc.) are the entry points for most of the attacks that we face on a daily basis. Considering that most threats will originate from the internet and target users who are browsing websites, opening attachments, or running malicious executables, a significant percentage of this activity will occur on their corporate endpoints.

There are a few widely recognized endpoint hardening standards now, with CIS and Microsoft baselines being the most popular, and these should really be the building blocks for our organization's hardening baselines. Some highly important actions (that actually work) to note and do something about are:

- Disable LLMNR/NetBIOS.
- Implement LAPS and remove administrative privileges from regular users.
- Disable or configure PowerShell in "ConstrainedLanguage" mode.
- Enable Attack Surface Reduction (ASR) rules if using Microsoft Defender.
- Implement whitelisting. We know this is nearly impossible to implement. Consider at least blocking execution from user-writable folders (Downloads, Desktop, AppData, etc.). These are the locations where exploits and malicious payloads will initially find themselves. Remember to also block script types such as .hta, .vbs, .cmd, .bat, .js, and similar. We need to pay attention to [LOLBin](https://lolbas-project.github.io/) files while implementing whitelisting. Do not overlook them; they are really used in the wild as initial access to bypass whitelisting.
- Utilize host-based firewalls. As a bare minimum, block workstation-to-workstation communication and block outbound traffic to LOLBins.
- Deploy an EDR product. At this point in time, [AMSI](https://learn.microsoft.com/en-us/windows/win32/amsi/how-amsi-helps) provides great visibility into obfuscated scripts for antimalware products to inspect the content before it gets executed. It is highly recommended that we only choose products that integrate with AMSI.
-
