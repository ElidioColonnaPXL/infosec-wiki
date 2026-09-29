# Alert properties

## Alert Properties

|№|Property|Description|Examples|
|---|---|---|---|
|**1**|Alert Time|Shows alert creation time. Alert usually triggers  <br>a few minutes after the actual event|- Alert Time: March 21, 15:35<br>- Event Time: March 21, 15:32|
|**2**|Alert Name|Provides a summary of what happened,  <br>based on the detection rule's name|- Unusual Login Location<br>- Email Marked as Phishing<br>- Windows RDP Bruteforce<br>- Potential Data Exfiltration|
|**3**|Alert Severity|Defines the urgency of the alert,  <br>initially set by detection engineers,  <br>but can be altered by analysts if needed|- (🟢) Low / Informational<br>- (🟡) Medium / Moderate<br>- (🟠) High / Severe<br>- (🔴) Critical / Urgent|
|**4**|Alert Status|Informs if somebody is working on the alert  <br>or if the triage is done|- (🆕) New / Unassigned<br>- (🔄) In Progress / Pending<br>- (✅) Closed / Resolved<br>- And often other custom statuses|
|**5**|Alert Verdict|Also called alert classification,  <br>explains if the alert is a real threat or noise|- (🔴) True Positive / Real Threat<br>- (🟢) False Positive / No Threat<br>- And often other custom verdicts|
|**6**|Alert Assignee|Shows the analyst that was assigned  <br>or assigned themselves to review the alert|- Assignee can sometimes be called alert owner<br>    <br>- Assignee takes responsibility for their alerts|
|**7**|Alert Description|Explains what the alert is about,  <br>usually in three sections on the right|- The logic of the alert generating rule<br>- Why this activity can indicate an attack<br>- Optionally, how to triage this alert|
|**8**|Alert Fields|Provides SOC analysts' comments  <br>and values on which the alert was triggered|- Affected Hostname<br>- Entered Commandline<br>- And many more, depending on the alert|
