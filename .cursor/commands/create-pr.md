Prepare a pull request for the current branch following these steps:

1. Run `git status` to check the current branch and any uncommitted changes
2. Run `git log origin/develop..HEAD` to understand all commits in this branch since it diverged from develop
3. Run `git diff origin/develop...HEAD` to see all changes that will be included in the PR
4. Analyze all commits and changes to create a comprehensive PR summary using the template format from `.cursor/commands/pr-template.md`
5. Craft a concise English sentence for the PR title (no `type: description` prefixes, e.g., `Add Cursor command templates`)
6. Generate the complete `gh pr create` command with the sentence-style title and the body that the user can run directly from the chat via the Run button

Output format:
```bash
gh pr create --base develop --title "Add Cursor command templates" --body "..."
```

When presenting the command, keep it inside a fenced ```bash block so Cursor shows the Run button. Instruct the user to press that button instead of switching to an external terminal.
