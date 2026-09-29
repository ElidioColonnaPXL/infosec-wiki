# Rules of Engagement

---

The Rules of Engagement (`RoE`) is a document that explains how a penetration test will be done. It's an agreement between the client and testing team that clearly states what is allowed and what isn't. This document is important because it helps avoid confusion and sets clear expectations.

---

#### Defining the Boundaries

The RoE lists `which systems and networks` can be tested. It also states when testing can happen - during work hours or after. The document also explains which testing methods cannot be used, like attacks that could shut down services, to avoid harming the business.

Testers follow these rules to stay within `legal and ethical limits`. Companies can ask for changes to protect sensitive systems. This agreement keeps both sides safe and helps the test stay on track.

---

#### Contact Information

Good communication is essential during a penetration test. The document includes `contact details` for important people on both sides. This includes names, roles, email addresses, and phone numbers of people who can help when needed.

Sometimes problems can occur during testing. For example, a tester might accidentally trigger an alarm or interrupt a service. Having the right contact person helps fix issues quickly. Also, if testers find a serious security problem, they need to tell the client right away.

---

#### Lines of Communication

Before testing starts, everyone agrees on how they will communicate. This might include email, secure messaging, or special ticketing systems.

Different situations need different ways of communicating. Regular updates might be sent `by email`, while urgent issues might need a `phone call`. There's also a clear plan for who to contact when serious problems are found.

Testers are encouraged to ask questions when things aren't clear. For example, if they find unexpected systems, they can check with the client to make sure they're staying within the agreed limits.

---

#### Objectives

Every penetration test starts with clear goals. These goals are set during planning and tell us what we need to test. Common goals might include checking how safe external networks are, `finding weaknesses` in websites, or testing how well internal systems are protected against threats from inside the organization.

Different companies have different testing needs. For example, banks might need tests to make sure they follow specific security rules (like PCI DSS), while new tech companies might focus more on testing their cloud systems and APIs.

These goals also help us know if the test was successful. We can compare what we found to what we planned to check, helping both the client and testers see if the test did what it was supposed to do.

---

#### Evidence and Information Handling

Since we collect sensitive information like `logs` and `screenshots` that show security problems during the penetration test, we also must handle this information carefully and document everything properly.

To keep this information safe, we must use secure storage and encrypted connections in our environment and ensure this information cannot be accessed by unauthorized or involved parties. For example, they might store evidence on encrypted drives that only certain people can access. They also keep detailed records of everything they do during the test.

After the test is finished, testers follow strict rules about destroying client data. They safely delete all client information from their systems after delivering the final report to protect confidentiality.

---

#### Disclaimers and Liability

Every penetration testing agreement includes sections that explain `who is responsible for what`. These sections protect both the testing team and the client by making it clear what happens if something goes wrong.

For example, if testers discover and exploit a vulnerability that nobody knew about before, they won't be responsible for any damage it might cause. Sometimes tests might accidentally cause problems, like temporarily slowing down a system. These agreements help prevent legal problems if such issues happen.

The agreements also remind clients that the test only shows security issues at that specific time. Just because a system is secure today doesn't mean it will stay secure forever. This is why regular security testing is important.

---

#### Permission

Without `explicit authorization` and permission from the client, all the activities conducted during the penetration test could be considered illegal. To mitigate this risk, clients provide a formal document granting the testing team permission to probe their systems.

In real-world scenarios, this authorization is often quite detailed, and usually includes specific IP addresses, domains, or systems that are in scope, as well as timeframes and conditions under which we should test. Basically, it is a set of environmental conditions we have to meet during testing. Once we've obtained this written authorization, it confirms that we're operating within the bounds of the law, on client's request, protecting us from accusations of unauthorized access.

Additionally, real-world permissions often involve coordination with third-party vendors or service providers. For example, if we identify a part of client’s infrastructure that is hosted on a cloud platform, we may need additional authorization from the corresponding cloud provider to avoid violating their terms of service because they all have guidelines on how to reach out when a penetration test needs to be conducted on their platform for a client. This step highlights the importance of thorough preparation and communication before the test begins.
