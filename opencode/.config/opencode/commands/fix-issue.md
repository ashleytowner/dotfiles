---
description: Make a plan to fix a github <issue>
agent: plan
---

---

Input: $ARGUMENTS

---

Use the GitHub CLI to view the issue number provided in the Input, using the gh CLI tool:

```bash
gh issue view <number>
```

- Read the entire issue, as well as all the comments
- Take into account discussion on the ticket, and determine the conclusions made at the end of any discussion
- Explore the codebase to validate assumptions made within the ticket, as things may have changed since the ticket was written
- Investigate the codebase deeply to find the source of any bugs mentioned, and use any clues or discoveries added to the ticket to aid you
- Devise an implementation plan to enact the changes, taking into account any changes in assumptions
