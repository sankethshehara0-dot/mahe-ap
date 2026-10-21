# Mahe source without `assets/` and `lib/`

This ZIP intentionally has no `assets/` or `lib/` folders. App source is at the root as `main.dart`; the logo is drawn with Flutter widgets instead of image assets.

Upload all files to the root of your GitHub repository, including `.github/workflows/build-apk.yml`. Open GitHub → Actions → Build Mahe APK. Run the workflow and, when it succeeds, download the `mahe-android-apk` artifact and extract `app-release.apk`.

The app is a starter with demo feed/chat/friend-request screens. Online accounts, real messaging, video hosting and random matching need a secure backend and moderation. iPhone builds require macOS and Xcode.
