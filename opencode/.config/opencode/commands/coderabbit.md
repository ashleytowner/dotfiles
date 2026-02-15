---
description: Run a code review with coderabbit & develop a plan to fix any found issues
agent: plan
---

Use coderabbit, a commandline tool, to perform a code review, and then write a plan
to fix any issues that coderabbit raises. 

Coderabbit takes a long time to run, so when you run it as a bash command, run it with a timeout of 10 minutes.

The most basic coderabbit command is:

```bash
coderabbit review --prompt-only
```

but there are more flags you can use to get more fine-detailed control over exactly
what is reviewed.

```
Usage: coderabbit review [options]

AI-driven code reviews with interactive or plain text output (default)

Options:
  -V, --version            output the version number
  --plain                  Output in plain text format (non-interactive)
  --prompt-only            Show only AI agent prompts (implies --plain)
  -t, --type <type>        Review type: all, committed, uncommitted (default:
                           "all")
  -c, --config <files...>  Additional instructions for CodeRabbit AI (e.g.,
                           claude.md, coderabbit.yaml)
  --base <branch>          Base branch for comparison
  --base-commit <commit>   Base commit on current branch for comparison
  --cwd <path>             Working directory path
  --no-color               Disable colored output
  -h, --help               display help for command
```
