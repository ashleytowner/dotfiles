---
name: coderabbit
description: "Use coderabbit CLI to review code & identify issues"
---

Use the `coderabbit review` command to have it identify issues in the code. 

You should always call the command with the `--prompt-only` flag.

Keep in mind that coderabbit is very long-running, so should be called with a 10-minute timeout.

Depending what you've been asked to compare against, you can either supply a `--base <branch>` or a `--base-commit <commit>` as the base for the diff against which the review will take place. 

When uncertain, just leave this blank and it'll default to the repository default.

## Examples

*The most generic review command (i.e. the one you'll use most often)*

```bash
coderabbit review --prompt-only
```

*Review the current branch against the "main" branch*

```bash
coderabbit review --prompt-only --base main
```

*Review against the specific commit abcdef123*

```bash
coderabbit review --prompt-only --base-commit abcdef123
```
