# BookVerse — Viva Guide

Short, honest answers based on the code in this project. Open the file mentioned in each answer while you practise.

---

## 1. Flutter and Dart

**Q: What is Flutter?**
A: Google's UI toolkit for building apps for Android, iOS, web and desktop from one codebase. Everything on screen is a *widget*.

**Q: What is Dart?**
A: The programming language Flutter uses. It is object-oriented, null-safe and has classes, lists, maps, `async`/`await` and enums.

**Q: What is a widget?**
A: A description of part of the UI, such as `Text`, `Row`, `Card` or a whole screen like `HomeScreen`. Widgets nest inside each other to form the *widget tree*.

**Q: StatelessWidget vs StatefulWidget?**
A: A `StatelessWidget` has no changing data of its own (for example `BookCard`, `AboutScreen`). A `StatefulWidget` keeps data that can change and calls `setState()` to redraw. Examples: `LoginScreen` (show/hide password, loading spinner), `ReadingScreen` (current page) and `CheckoutScreen` (payment choice).

**Q: What does `null safety` mean here?**
A: A variable can only be null if its type ends with `?`. For example `AppUser? currentUser` is null when nobody is logged in, and `findBook()` returns `Book?` because an ID might not exist.

## 2. main.dart and app.dart

**Q: What happens in `main.dart`?**
A: (1) `WidgetsFlutterBinding.ensureInitialized()` prepares Flutter so plugins can be used; (2) we create one `BookStore` and `await store.load()` to read saved data; (3) `runApp` starts `BookVerseApp`, wrapped in `ChangeNotifierProvider.value` so every screen can reach the store.

**Q: What is in `app.dart`?**
A: The `MaterialApp`: app title, theme (`buildBookVerseTheme()`), the first screen (`LoginScreen`, or `AppShell` if a saved session was restored), the named `routes` map, and `onGenerateRoute` for routes that need a book ID.

## 3. Widgets and screen layout

**Q: How is a screen built?**
A: Usually `Scaffold` → `AppBar` + `body`. The body uses `ListView`/`Column` for vertical layout, `Row` for horizontal, `Padding`/`SizedBox` for spacing, and `Card` for boxes.

**Q: How did you make it responsive?**
A: `LayoutBuilder` checks the available width. In `app_shell.dart`, wider than 900 px shows a `NavigationRail` sidebar; narrower shows a bottom `NavigationBar`. `BookGrid` uses `SliverGridDelegateWithMaxCrossAxisExtent`, so it adds columns as the screen gets wider. `PageBody` stops content becoming too wide on desktops.

**Q: Why put reusable widgets in `widgets/`?**
A: So styles are written once. For example `CoverImage`, `EmptyState`, `SectionTitle` and `BookVerseLogo` are used on many screens. This is the same idea as `owl_widgets.dart` in the teacher project.

**Q: How is the logo made?**
A: With widgets only: a `Container` with a navy-to-green gradient and a gold border, plus two `Icon`s stacked in a `Stack` (an open book with a star above it). No image file is needed.

## 4. MaterialApp and named routes

**Q: What are named routes?**
A: Screens registered by name in `MaterialApp.routes`, e.g. `'/cart'`. We open them with `Navigator.pushNamed(context, '/cart')`.

**Q: How do you send a book to the details screen?**
A: `Navigator.pushNamed(context, '/book', arguments: book.id)`. In `app.dart`, `onGenerateRoute` reads `settings.arguments` and builds `BookDetailsScreen(bookId: ...)`.

**Q: Why `pushNamedAndRemoveUntil` after login and logout?**
A: It removes all old screens, so pressing Back after logout cannot reopen another user's library.

## 5. Models and the book data list

**Q: What is a model?**
A: A simple Dart class that describes data. `Book` has `id`, `title`, `author`, `category`, `cover`, `summary`, `languages`, `tags`, `price`, `access` and `featured`.

**Q: What is `BookAccess`?**
A: An *enhanced enum* with three values (free, preview, orderOnly). Each value carries its own label and description, e.g. "Free to read".

**Q: Where are the 180 books?**
A: In `lib/mock/mock_books.dart`, as a `const List<Book>`. They cover 30 categories, with real titles and authors. Prices are demo prices.

**Q: What are `toJson` / `fromJson` for?**
A: To save objects as text and read them back. `toJson()` turns a `BookOrder` into a `Map`; `jsonEncode` turns that Map into a string. `fromJson` does the reverse and uses defaults (`?? ''`) so damaged data does not crash the app.

## 6. Provider / ChangeNotifier (state management)

**Q: How does state management work?**
A: `BookStore` extends `ChangeNotifier`. It holds the shared data (current user, shelf, cart, orders, history, search text). Screens show the data with `Consumer<BookStore>`. When a method like `addToShelf()` changes data, it calls `notifyListeners()`, and every `Consumer` rebuilds.

**Q: What is the difference between `Consumer` and `context.read`?**
A: `Consumer` (or `watch`) *listens*: it rebuilds when data changes, so we use it in `build`. `context.read<BookStore>()` gets the store once without listening, so we use it inside button callbacks and `initState`. Provider does not allow `read` inside `build`.

**Q: Why one store instead of many?**
A: The teacher project uses one `FinanceStore`. One store keeps shelf, cart, orders and history consistent: placing an order, for example, empties the cart and adds history entries in one method.

## 7. Login / sign-up demo flow

**Q: How does login work?**
A: The form is validated (`TextFormField` validators check the email format and that the password is not empty). Then `BookStore.logIn(email, password)` searches the account list. It returns `null` on success or an error message. On success we load that user's saved library and open `/home`.

**Q: How does sign-up work?**
A: It validates name, email, password (6+ characters with a number) and the confirmation. `signUp()` rejects an email that already exists, creates an `AppUser`, saves it, and logs the user in.

**Q: Is it secure?**
A: No. It is a classroom simulation: passwords are stored in plain text with shared_preferences. A real app needs a backend (for example Firebase Auth) with hashed passwords and HTTPS.

**Q: How do you keep users' data separate?**
A: Each user's library is saved under its own key, `bookverse_library_<userId>`. Only the signed-in user's library is loaded into memory, and `logOut()` clears it.

## 8. Search and category filtering

**Q: How does search work?**
A: `filteredBooks` in `book_store.dart` uses `books.where(...)`: a book matches if its title, author, category or a tag contains the search text (all lower-case). It must also match the selected category, unless the category is "All". Then the list is sorted with `sort()`.

**Q: How does the Home search open the Browse tab?**
A: `openBrowse(query: text)` stores the text, sets `tabIndex = 1` and calls `notifyListeners()`. The shell switches tab, and the Browse search box (with a `ValueKey`) rebuilds with the new text.

## 9. Shelf, reading history, cart, checkout and orders

**Q: How does Add to Shelf avoid duplicates?**
A: `addToShelf()` returns `false` if the ID is already in `_shelf`; otherwise it adds it, logs history, saves and notifies.

**Q: How is reading progress saved?**
A: `ReadingScreen` saves `(page + 1) / totalPages` with `saveProgress()`. Next time the reader opens on that page, and the details page shows "Continue Reading".

**Q: How is reading history recorded?**
A: `_log()` adds an `ActivityEntry` (type, book, time) for opening, starting or resuming reading, shelving and ordering. It skips exact repeats within one minute and keeps the latest 100.

**Q: How does the cart avoid duplicate rows?**
A: The cart is a `Map<String, int>` of book ID to number of copies. Ordering the same book again increases the number; a Map key cannot appear twice.

**Q: How are totals calculated?**
A: `cartSubtotal` adds `price × quantity` with `fold`. Delivery is free from $50, otherwise $4.99. Total = subtotal + delivery. `usd()` formats everything as dollars.

**Q: What does checkout do?**
A: It validates name, email, phone (7–15 digits), address, city and country, and lets the reader pick a demo payment method. After a confirmation dialog, `placeOrder()` creates a `BookOrder` with an order number and the status "Demo order placed", saves it and empties the cart. A `placing` flag stops double taps.

## 10. Local persistence

**Q: Why shared_preferences?**
A: It is the simplest key–value storage for small data and is the only package added to the teacher's dependencies. We store JSON text under a few keys. It works on Android, iOS, web and desktop.

**Q: What happens with damaged saved data?**
A: Reading is wrapped in `try/catch`; on an error we start with an empty library instead of crashing.

## 11. Images, assets and pubspec.yaml

**Q: What does `pubspec.yaml` do?**
A: It names the project, lists packages (`provider`, `intl`, `shared_preferences`) and declares assets (`assets/covers/`) and fonts (Playfair Display).

**Q: How are covers shown?**
A: `CoverImage` uses `Image.asset` for local files (or `Image.network` for URLs) with an `errorBuilder`. If an image is missing or fails, a designed fallback cover appears instead of a broken icon.

**Q: Are these the real covers?**
A: No. They are BookVerse-designed covers made for this project, so the app works offline and avoids copyright problems. The Quran covers use traditional mushaf styling (gold frame, medallion and Arabic calligraphy).

## 12. Demo vs production

**Q: What would a real online library need?**
A: A backend and database (accounts, catalogue, orders), secure authentication with hashed passwords, a real payment gateway, licensed book content and cover images, cloud sync across devices, an admin panel, delivery tracking, and server-side validation.

**Q: What are the main limitations of this demo?**
A: Accounts and data live only on one device; passwords are not encrypted; payments and deliveries are simulated; reading content is limited to samples and previews; prices are examples.
