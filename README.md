# ぶんたん for 英検®

## App Store URL
https://apps.apple.com/us/app/ぶんたん-for-英検/id6739174811

## Environment
- Language Version: Swift 5
- Compiler Version: Apple Swift version 6.0.3
- Xcode: 16.2

### Libraries

- Realm Swift
- Firebase Analytics

## Important Notes
The source code uploaded to GitHub does not include .realm files.
To verify the app's functionality, please install it from the App Store.

## Commit Message Rules

This project adopts the following commit message rules to clarify change history and facilitate management.

### Format

Commit messages follow the format below:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Type (Required)

Indicates the type of change.

- **feat**: New feature addition
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style fixes (formatting, semicolons, etc.)
- **refactor**: Refactoring (no functional changes)
- **test**: Test additions or fixes
- **chore**: Build, auxiliary tools, library changes (no impact on main code)

### Scope (Optional)

Describes the scope or module name affected by the change in `()`.

**Examples**: `feat(login)`, `fix(ui)`

### Description (Required)

A concise summary of the changes.

- Use present tense (e.g., "adds" instead of "add")
- Aim for 50 characters or less

### Breaking Change

For incompatible changes, add `!` immediately after `type/scope`.

**Example**: `feat!: Update authentication API to v2`

Or describe details in the footer section with `BREAKING CHANGE:`.

### Body (Optional)

Describe the details and background of the changes. Leave one line after Description.

### Footer (Optional)

Include related issue numbers or references.

**Common keywords**:
- **`Fixes #123`**: When fixing a bug that resolves an issue
- **`Closes #123`**: When adding a feature that completes an issue
- **`Closes #123`**: When adding a feature that completes an issue
- **`Closes #123`**: When adding a feature that completes an issue
- **`Refs #123`**: When referencing a related issue
- **`Addresses #123`**: When addressing an issue but not fully resolving it
- **`Part of #123`**: When working on part of a larger issue

**Examples**:
```bash
# Single issue
Fixes #123

# Multiple issues
Fixes #123
Closes #456
Refs #789

# With description
fix(auth): Fix login timeout issue

The login process was timing out after 30 seconds.
Increased timeout to 60 seconds and added retry logic.

Fixes #234
```

### Commit Examples

```bash
feat(user): Add user profile editing functionality
fix(auth): Fix password input error during login
feat!: Change authentication token format to JWT

Legacy session tokens are no longer supported.
All users need to re-login.
```

> This rule is based on the [Conventional Commits Specification](https://www.conventionalcommits.org/).
