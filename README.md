## Technical Overview

### Architecture & Framework

- **Framework:**  
  The app is built using [Flutter](https://flutter.dev/), supporting Android, iOS, Web, macOS, and Windows platforms. The UI is defined using `MaterialApp` and custom themes.

- **AI & Recipe Import:**  
  The codebase references “AI import features” but, as of this analysis, there is no implementation of OCR, AI, or NLP for recipe extraction from images, web, or PDFs in the available files. The current implementation focuses on recipe management and authentication, with structure in place to later add AI-powered importers.

- **Backend & Database:**  
  - **Supabase** is used as the Backend-as-a-Service (BaaS) and database.  
  - Recipes are stored and fetched from a Supabase PostgreSQL database (`RecipeService` in `lib/core/services/recipe_service.dart`).
  - Authentication (sign up, sign in, sign out, session management) is also handled by Supabase (`AuthService` in `lib/core/services/auth_service.dart`).

- **Authentication:**  
  Managed via Supabase. The app includes an authentication gate that routes users to login/signup or the main recipe interface, depending on their session state.

### Main Packages & Dependencies

- `flutter`
- `supabase_flutter` – for backend and auth
- Other dependencies can be seen in the project’s `pubspec.yaml`.

### Project Structure

- **lib/main.dart** – App entry point, initializes Supabase, and launches the app.
- **lib/presentation/app.dart** – Root widget, theme management, dependency injection.
- **lib/core/services/** – Service classes for authentication and recipes (Supabase logic).
- **lib/features/auth/presentation/** – Login, signup, and auth gate UI.
- **lib/features/recipes/presentation/** – Home page and recipe UI.
- **web/**, **android/**, **ios/**, **macos/** – Platform-specific bootstrap and config files.

### Cloud & Platform Integration

- **Supabase** for cloud database and user management.
- **Flutter** for cross-platform builds (mobile, web, desktop).
- **Android/iOS/macOS**: Standard platform-specific setup files (Gradle, Podfile, etc.).

### How to Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```
2. **Add your Supabase credentials:**  
   Configure your Supabase URL and API key as indicated in the code (`SupabaseInitializer`).
3. **Run the app:**
   ```bash
   flutter run
   ```
4. **For web:**
   ```bash
   flutter run -d chrome
   ```

### Extending with AI Import

While the README and UI reference "AI import features", the implementation of AI-based recipe extraction (from web, image, or PDF) is not present as of this code snapshot. This should be considered a future or planned feature; contributions or extensions in this area are welcome.

---

For more details, browse the [source code](https://github.com/luisfelipealves/recipe_cloud_app) and consult the official Flutter and Supabase documentation.
