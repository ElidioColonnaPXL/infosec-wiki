# DMARC

[DMARC](https://dmarcly.com/blog/how-to-implement-dmarc-dkim-spf-to-stop-email-spoofing-phishing-the-definitive-guide#what-is-dmarc) is an email protection mechanism against phishing built on top of the already existing [SPF](https://dmarcly.com/blog/how-to-implement-dmarc-dkim-spf-to-stop-email-spoofing-phishing-the-definitive-guide#what-is-spf) and [DKIM](https://dmarcly.com/blog/how-to-implement-dmarc-dkim-spf-to-stop-email-spoofing-phishing-the-definitive-guide#what-is-dkim). The idea behind DMARC is to reject emails that 'pretend' to originate from our organization. Therefore, if an adversary is spoofing an email pretending to be an employee asking for an invoice to be paid, the system will reject the email before it reaches the intended recipient. DMARC is easy and inexpensive to implement; however, we cannot stress enough that thorough testing is mandatory; otherwise (and this is oftentimes the case), we risk blocking legitimate emails with no ability to recover them.

With email filtering rules, we may be able to take DMARC to the 'next' level and apply additional protection against emails failing DMARC from domains we do not own. This is possible because some email systems will perform a DMARC check and include a header stating whether DMARC passed or failed in the message headers. While this can be incredibly powerful for detecting phishing emails from any domain, it requires extensive testing before it can be introduced in a production environment. High false positives here are emails that are sent 'on behalf of' via some email sending service, as they tend to fail DMARC due to domain mismatch.


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
