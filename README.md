# BookVerse — Online Books Library

**Open a Book. Explore a Universe.**

BookVerse is a Flutter + Dart student project (Mobile Application Development, BSCS 5th semester). It is built on the teacher's **ExpenseManager / Owlance** starter project and reuses its patterns: `MaterialApp` with named routes, one `ThemeData` file, simple model classes, mock data in `lib/mock/`, a single Provider/`ChangeNotifier` store, reusable widgets, and one Dart file per screen.

## What BookVerse does

- **Login / Sign up** with email + password (local demo accounts, validation, show/hide password).
- **Home**: hero section with search, quick links, category filters, Featured, Recommended and Quran/Hadith/Seerah rows, and the catalogue count.
- **Browse**: 180 books in 30 categories — search by title, author, category or theme; filter by category; sort by title or price.
- **Book details** with four working actions: **Add to Shelf**, **Start Reading**, **More About This Book**, **Order**.
- **Reading screen**: page-by-page sample, progress bar, and progress saved per user.
- **My Shelf**, **Reading History**, **Cart** (quantities, remove, totals), **Checkout** (name, email, phone, address, city, country, payment choice), **My Orders**, **Profile** with **Log out**, and **About BookVerse**.
- Responsive layout: bottom navigation bar on phones; a navigation rail (sidebar) and multi-column grids on tablets, web and desktop.

## Prerequisites

- Flutter SDK with Dart **3.10.8 or newer** (same requirement as the teacher project; check with `flutter --version`).
- VS Code with the **Flutter** and **Dart** extensions.
- For Android: Android Studio's Android SDK, an emulator (or a phone with USB debugging), and `flutter doctor --android-licenses` accepted.
- For web: Google Chrome.
- Internet only for the first `flutter pub get`. The app itself works offline (all covers are local files).

## Run it

Open the `BookVerse` folder in VS Code, then in the terminal (**Terminal → New Terminal**):

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

To choose a device: `flutter devices`, then `flutter run -d <device-id>`.

**Flutter Web (Chrome):**

```bash
flutter run -d chrome
```

You can also press **F5** in VS Code and pick a launch configuration: *BookVerse — Android Emulator*, *BookVerse — Chrome (Flutter Web)* or *BookVerse — Any device*. On Windows, double-click `run.bat`.

## Demo login

| Reader | Email | Password |
|---|---|---|
| Ayesha Khan | `ayesha@example.com` | `Reader@123` |
| Omar Farooq | `omar@example.com` | `Reader@456` |

On the login screen, tap a demo reader's chip to fill in their details. You can also create a new account on **Sign Up**. Change the demo readers in `lib/mock/mock_users.dart`.

**How the demo login works:** `BookStore.logIn()` looks up the email in the list of accounts (the demo readers plus anyone who signed up) and compares the password. Nothing is sent to a server. It is **not** Google sign-in and no email is verified. Passwords are stored in plain text on the device, so **never use a real password**.

## Does data persist after restarting?

**Yes, on the same device only.** BookVerse adds one package, `shared_preferences` (the only package not already in the teacher's `pubspec.yaml`). It saves:

- `bookverse_users`: accounts created with Sign Up
- `bookverse_session`: who is logged in, so the app can reopen on the library
- `bookverse_library_<userId>`: that user's shelf, cart, orders, history and reading progress, saved as JSON text

Each user has their own key, and only the signed-in user's library is ever loaded into memory. Logging out clears it from memory, so one reader never sees another reader's data. Nothing is synced to the cloud. On Flutter Web the data lives in that browser's local storage.

## What is simulated

| Feature | Reality in this demo |
|---|---|
| Login / sign-up | Local demo accounts only. No Google, Firebase or email verification. |
| Payment | Demo choices only (Cash on Delivery, Card on Delivery (Demo), Bank Transfer (Demo)). No card numbers, CVVs or bank details are collected, and no money is charged. |
| Orders and delivery | Saved as demo orders with the status "Demo order placed". Nothing is shipped. |
| Reading | Short public-domain openings (works published before 1929), Surah Al-Fatiha for Quran titles, and clearly labelled BookVerse demo previews for every other book. Full copyrighted books are **not** included. |
| Covers | BookVerse-designed cover images, not the publishers' artwork. |
| Prices | Demo prices in US dollars. |

## Main files

```
lib/
├── main.dart                     Entry point: loads BookStore, then starts the app with ChangeNotifierProvider
├── app.dart                      MaterialApp, theme and named routes ('/login', '/home', '/book', '/read', ...)
├── core/
│   ├── app_theme.dart            BvColors, BvText and buildBookVerseTheme() — every colour and style
│   └── format.dart               usd() for $12.99, plus date and "time ago" helpers
├── models/
│   ├── book.dart                 Book + BookAccess (Free to read / Preview available / Order only)
│   ├── app_user.dart             AppUser (demo account) with toJson/fromJson
│   ├── order.dart                CartLine, OrderItem, BookOrder
│   └── activity.dart             ActivityType + ActivityEntry (reading history)
├── mock/                         Same folder idea as the teacher project
│   ├── mock_books.dart           ALL 180 books, 30 categories, category icons and cover paths
│   ├── mock_reading.dart         Reading pages: public-domain openings, the Quran sample, demo previews
│   └── mock_users.dart           Demo reader accounts
├── providers/
│   └── book_store.dart           The ChangeNotifier: login, shelf, cart, orders, history, search, saving
├── screens/                      One file per screen
│   ├── login_screen.dart         Login (+ shared email check and error box)
│   ├── signup_screen.dart        Sign up
│   ├── app_shell.dart            Bottom navigation bar (phone) / navigation rail (wide)
│   ├── home_screen.dart          Hero, search, quick links, categories, book rows
│   ├── browse_screen.dart        Search, category chips, sort, grid
│   ├── book_details_screen.dart  Details + the four actions + "More about this book" sheet
│   ├── reading_screen.dart       Page-by-page reader with saved progress
│   ├── shelf_screen.dart         My Shelf
│   ├── history_screen.dart       Reading History
│   ├── cart_screen.dart          Cart + CartSummary (also used by checkout)
│   ├── checkout_screen.dart      Delivery form, payment choice, order confirmation page
│   ├── orders_screen.dart        My Orders
│   ├── profile_screen.dart       Profile + confirmLogOut()
│   └── about_screen.dart         About BookVerse
└── widgets/
    ├── bookverse_widgets.dart    Logo, AuthLayout, BvCard, SectionTitle, EmptyState, CoverImage, AccessBadge, InfoNote, dialogs
    └── book_card.dart            BookCard, BookRow, BookGrid and BookActions (shared button behaviour)
assets/
├── covers/bv001.jpg … bv180.jpg  One cover per book
└── fonts/                        Playfair Display (SIL Open Font License, OFL text included)
test/widget_test.dart             Catalogue, user separation, persistence, orders, search and login tests
```

### Changes made to the teacher project

- **Replaced:** the Owlance expense screens, models, mock data, store and widgets in `lib/` (their patterns are reused, not their content). Also replaced `assets/images/logo.jpeg` and `assets/icons/hamburger.svg` (Owlance branding) with `assets/covers/` and `assets/fonts/`.
- **pubspec.yaml:** renamed the package to `bookverse`; added `shared_preferences`; removed `fl_chart` (BookVerse draws no charts); added the covers folder and the Playfair font.
- **Branding:** the app name is BookVerse on Android, iOS, web, Windows and Linux; new app icons and web favicon.
- **Unchanged:** the Android/iOS/desktop build setup, `analysis_options.yaml`, `devtools_options.yaml` and the IDE files.

`pubspec.lock` is the teacher's file. `flutter pub get` updates it automatically for `shared_preferences`.

## How to replace or add book covers

All covers are listed in **one place**: the `cover:` field of each book in `lib/mock/mock_books.dart`.

- **Replace a cover:** put your own image in `assets/covers/` with the **same file name** (for example `assets/covers/bv049.jpg` for *The Noble Quran*), then fully restart the app.
- **Use an online image:** change the field to a URL, e.g. `cover: 'https://example.com/my-cover.jpg'`. This needs internet; if it fails to load, `CoverImage` shows a designed fallback cover instead of a broken image.
- **Add a new book:** copy one `Book(...)` block in `mock_books.dart`, give it a new unique `id` (e.g. `BV181`), choose one of the existing categories, and point `cover:` at your new image in `assets/covers/`. The `assets/covers/` folder is already declared in `pubspec.yaml`, so new files in it are picked up automatically.

## Viva preparation

See **VIVA_GUIDE.md** for likely questions with simple answers.
