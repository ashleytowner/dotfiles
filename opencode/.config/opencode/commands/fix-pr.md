---
description: <pr_number> — Make a plan to resolve comments on a github pull request
subtask: false
---

---

Input: $ARGUMENTS

---

Use the GitHub CLI to view the pull request number provided in the Input, using the gh CLI tool:

```bash
gh pr view <number>
```

- Read the entire pull request, as well as all the comments
- Take into account discussion on the PR, and determine the conclusions made at the end of any discussion
- Explore the codebase to validate assumptions made within the PR, as things may have changed since the PR was written
- Investigate the codebase deeply to find the source of any bugs mentioned, and use any clues or discoveries added to the PR to aid you
- Devise an implementation plan to enact the changes, taking into account any changes in assumptions
