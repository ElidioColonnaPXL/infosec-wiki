# EyeWitness

EyeWitness visits a supplied list of web services and produces screenshots with basic response metadata. The report is useful for grouping many authorized web endpoints by visible application, login surface, error page, or default site.

```bash
eyewitness --web -f urls.txt --no-prompt
```

## Suggested workflow

1. Normalize and deduplicate the in-scope URL list.
2. Choose conservative concurrency and timeout values for the environment.
3. Store the generated report in a protected case directory because screenshots may contain sensitive information.
4. Triage by response status, page title, visual similarity, and unexpected administrative surfaces.
5. Verify findings directly; a screenshot is a point-in-time observation, not proof of a weakness.

Delete temporary browser data and reports according to the engagement's retention requirements.
