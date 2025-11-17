Create an appropriate commit for the current changes following these steps:

1. Run `git status` to check all untracked files and modified files
2. Run `git diff` to analyze the staged and unstaged changes in detail
3. Run `git log -5 --oneline` to check recent commit message style for consistency
4. Based on the changes, determine the appropriate commit message following the Conventional Commits format:
   - `feat: description` - for new features
   - `fix: description` - for bug fixes
   - `refactor: description` - for code refactoring
   - `docs: description` - for documentation changes
   - `chore: description` - for maintenance tasks
   - `style: description` - for code style/formatting changes
   - `test: description` - for adding or updating tests
   - `perf: description` - for performance improvements
5. Add relevant files to staging area with `git add <files>`
6. Create the commit with a clear, concise message using `git commit -m "type: description"`
7. Run `git log -1` to verify the commit was created successfully

**Commit Message Guidelines:**
- Use present tense ("add feature" not "added feature")
- Use imperative mood ("move cursor to..." not "moves cursor to...")
- Keep the first line under 50 characters
- Add detailed description in body if needed (separated by blank line)
- Reference issue numbers if applicable (e.g., "fix: resolve login issue (#123)")

**Example:**
```
feat: add user authentication with JWT
```

Do not commit files that likely contain secrets (.env, credentials.json, etc).
