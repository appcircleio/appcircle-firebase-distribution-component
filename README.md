# Appcircle _Firebase App Distribution_ Component

Distribute your builds via Firebase App Distribution

## Required Inputs

- `AC_FIREBASE_VERSION`: Firebase Version. Firebase version to be used. Enter v11.11.0 for a specific version.
- `AC_FIREBASE_APP_PATH`: Path of the build. Full path of the build. For example $AC_EXPORT_DIR/Myapp.ipa
- `AC_FIREBASE_APP_ID`: App ID. Your app's Firebase App ID. You can find the App ID in the Firebase console.
- `AC_FIREBASE_TOKEN`: Firebase Token. A refresh token that's printed when you authenticate with firebase login:ci command.

## Optional Inputs

- `AC_FIREBASE_RELEASE_NOTES`: Release Notes. Release notes for this build. If you want to use a file for release notes, leave this place empty and configure the next section.
- `AC_FIREBASE_RELEASE_NOTES_PATH`: Release Notes Path. If you use Publish Release Notes component before this step, release-notes.txt will be used as release notes.
- `AC_FIREBASE_GROUPS`: Firebase Groups. Firebase tester groups you want to invite.
- `AC_FIREBASE_EXTRA_PARAMETERS`: Extra parameters. Extra command line parameters. Enter --debug for debug mode.
