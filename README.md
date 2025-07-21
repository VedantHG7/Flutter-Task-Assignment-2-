# Transactions App

This is a Flutter application designed to manage personal financial transactions. It allows users to view a list of transactions, add new ones, and filter them by type, category, or date range. The app simulates API integration for fetching and posting transaction data.

## Features

1.  **Transaction List:** Displays a list of transactions with details like amount, title, type (credit/debit), date, and category.
2.  **Conditional Formatting:** Amounts are colored green for credit transactions and red for debit transactions.
3.  **Currency & Date Formatting:** Displays amounts with proper currency symbols and dates in a readable format.
4.  **Filters:** Users can sort/filter transactions by category, type, or a specific date range.
5.  **Add Transaction:** A floating action button allows users to add new transactions via a modal form.
6.  **API Integration (Simulated):** New transactions are "posted" to a simulated backend, and the list updates instantly.
7.  **State Management:** Implemented using the `provider` package, a popular solution for state management in Flutter.
8.  **Clean Architecture:** Organized into `models`, `services`, `providers`, `screens`, and `widgets` for modularity and clarity.

## Framework Version Used

*   **Flutter SDK:** `3.0.0` or higher (tested with `3.19.x`)
*   **Dart SDK:** `>=3.0.0 <4.0.0`

## Setup & Run Instructions

To get this project up and running on your local machine, follow these steps:

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and configured.
*   An IDE like VS Code with the Flutter extension or Android Studio.

### Steps

1.  **Clone the repository (or create a new project):**
    If you're starting from scratch, create a new Flutter project:
    \`\`\`bash
    flutter create transactions_app
    cd transactions_app
    \`\`\`
    If you're integrating this code into an existing project, navigate to your project directory.

2.  **Update `pubspec.yaml`:**
    Replace the content of your `pubspec.yaml` file with the one provided in the project. Ensure the `dependencies` section includes:
    \`\`\`yaml
    dependencies:
      flutter:
        sdk: flutter
      provider: ^6.0.5
      intl: ^0.18.1
      uuid: ^4.3.3
      cupertino_icons: ^1.0.2
    \`\`\`

3.  **Get dependencies:**
    Run the following command in your project's root directory to fetch all required packages:
    \`\`\`bash
    flutter pub get
    \`\`\`

4.  **Organize `lib` folder:**
    Create the following subdirectories inside your `lib` folder:
    *   `models`
    *   `providers`
    *   `screens`
    *   `services`
    *   `widgets`

5.  **Copy source code:**
    Copy the provided Dart files into their respective paths within the `lib` folder:
    *   `lib/main.dart`
    *   `lib/models/transaction.dart`
    *   `lib/services/transaction_service.dart`
    *   `lib/providers/transaction_provider.dart`
    *   `lib/screens/transactions_screen.dart`
    *   `lib/widgets/transaction_list_item.dart`
    *   `lib/widgets/add_transaction_form.dart`
    *   `lib/widgets/filter_options.dart`

6.  **Run the application:**
    Connect a device or start an emulator, then run the app:
    \`\`\`bash
    flutter run
    \`\`\`

## Notes on Challenges, Improvements, or Known Bugs

### Challenges Faced
*   **`BuildContext` across async gaps:** Ensuring `BuildContext` is not used after an `await` call when the widget might have been unmounted. This was addressed by adding `if (!mounted) return;` checks.
*   **Extension Method Scope:** Making sure the `capitalize` extension method was accessible in all necessary files by importing the file where it's defined.

### Potential Improvements
*   **Real API Integration:** Replace the `TransactionService`'s in-memory data with actual HTTP requests to a live backend (e.g., Firebase, Supabase, or a custom REST API).
*   **Persistent Storage:** Implement local data persistence using `sqflite` (for SQLite) or `Hive` (for NoSQL) to store transactions even when the app is closed.
*   **Error Handling & UI Feedback:** Enhance error messages and provide more sophisticated UI feedback (e.g., snackbars for all operations, dedicated error screens).
*   **Sorting Options:** Add explicit sorting options (e.g., sort by amount, title) in addition to the default date sorting.
*   **Transaction Editing/Deletion:** Implement functionality to edit existing transactions and delete them from the list.
*   **Search Functionality:** Add a search bar to filter transactions by title or description.
*   **User Authentication:** Integrate user authentication to manage transactions for different users.
*   **Unit & Widget Testing:** Add comprehensive unit tests for providers and services, and widget tests for UI components.
*   **Theming:** Expand the theming options to include dark mode support.

### Known Bugs
*   No known critical bugs at the time of development. Minor UI glitches might occur on specific device aspect ratios, which can be addressed with further responsive design adjustments.
