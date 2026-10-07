# Contributing to AI Tourists

Thanks for helping improve AI Tourists.

## Before you start

1. Read the [README](README.md) and [API key setup guide](API_KEY_SETUP.md).
2. Never commit `.env`, API key files, local properties, signing files, or keystores.
3. Create a focused branch from `izaz`.

## Local checks

Run these commands before opening a pull request:

```bash
flutter pub get
flutter analyze
flutter test
dart format lib test
git diff --check
```

## Pull requests

- Explain the user-facing change and why it is needed.
- Include screenshots or a short recording for UI changes.
- Mention device/platform coverage when behavior is platform-specific.
- Keep unrelated formatting or generated files out of the change.
- Confirm that no credentials appear in the diff.

## Commit messages

Use a short imperative message with a clear scope, for example:

```text
feat: add saved place filtering
fix: handle denied location permission
docs: improve local setup guide
```
