Create a pull request for the current branch following these steps:

1. Run `git status` to check the current branch and any uncommitted changes
2. Run `git log origin/develop..HEAD` to understand all commits in this branch since it diverged from develop
3. Run `git diff origin/develop...HEAD` to see all changes that will be included in the PR
4. Analyze all commits and changes to create a comprehensive PR summary
5. Push the current branch to remote if needed with `git push -u origin <branch-name>`
6. Create the PR using `gh pr create` with base branch develop, using the template format from `.cursor/commands/pr-template.md`

After creating the PR, display the PR URL so the user can view it.
