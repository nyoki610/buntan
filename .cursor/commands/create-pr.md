Prepare a pull request for the current branch following these steps:

1. Run `git status` to check the current branch and any uncommitted changes
2. Run `git log origin/develop..HEAD` to understand all commits in this branch since it diverged from develop
3. Run `git diff origin/develop...HEAD` to see all changes that will be included in the PR
4. Analyze all commits and changes to create a comprehensive PR summary using the template format from `.cursor/commands/pr-template.md`
5. Generate the complete `gh pr create` command with title and body that the user can copy and run in their terminal

Output format:
```bash
gh pr create --base develop --title "..." --body "..."
```

Note: Due to Cursor's sandbox restrictions, copy the generated command and run it in your external terminal (Terminal.app or iTerm2).
