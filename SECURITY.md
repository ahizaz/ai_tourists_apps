# Security policy

## Supported branch

Security fixes should target the `izaz` branch until a stable release branch is introduced.

## Reporting a vulnerability

Please do not open a public issue for a credential leak or exploitable security problem. Contact the repository owner privately through the email address listed on the [GitHub profile](https://github.com/ahizaz), including:

- a clear description of the issue
- affected file, feature, or commit
- steps to reproduce
- potential impact
- a suggested fix, if available

Please allow time for the issue to be investigated before public disclosure.

## Credential incidents

If a key, token, password, signing file, or private key is committed:

1. Revoke or rotate it immediately.
2. Remove the sensitive file from the working tree and Git history.
3. Check all branches and releases for copies.
4. Report the incident privately using the process above.

Google Maps keys must be restricted by platform, application identifier, and required APIs in Google Cloud Console. A key embedded in a mobile application is not a server-side secret; restrictions and quota monitoring are required.
