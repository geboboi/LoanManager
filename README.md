# LoanManager 

An iOS application built with SwiftUI that consumes a RESTful API to display and manage peer-to-peer loan data. This project demonstrates modern iOS development practices, strict architectural patterns, and robust handling of complex JSON structures.

## How to Run the Code

1. **Requirements:** 
   * Xcode 15.0 or later.
   * iOS 16.0+ Simulator or Device.
2. **Installation:**
   * Clone or download the repository to your local machine.
   * Double-click the `LoanManager.xcodeproj` file to open it in Xcode.
3. **Execution:**
   * Select a simulator (e.g., iPhone 15 Pro) from the destination menu at the top.
   * Press `Cmd + R` or click the **Play** button to build and run the application.
   * *Note: This project does not rely on any third-party libraries (CocoaPods/SPM). It uses 100% native Apple frameworks.*

---

## Approach & Architecture

This application strictly adheres to the **MVVM (Model-View-ViewModel)** architectural pattern to ensure a clean separation of concerns, high testability, and modularity. 

*   **Model (`Model.swift`):** 
    *   Contains pure, stateless data structures (`Loan`, `Borrower`, `Collateral`, etc.) that conform to `Codable` and `Identifiable`. 
    *   Models are kept completely free of UI logic or data manipulation.
*   **View (`LoanListView.swift`, `LoanDetailView.swift`):** 
    *   Declarative, state-driven UI built entirely in SwiftUI. 
    *   Views act as "dumb" components—they only render what the ViewModel provides and route user intents (like sorting or refreshing) back to the ViewModel.
*   **ViewModel (`LoanViewModel.swift`):** 
    *   The central brain of the app, conforming to `ObservableObject`. 
    *   Handles all asynchronous networking, data parsing, error state management, and data formatting.

---

## Key Technical Decisions

*   **Strict MVVM for Data Formatting:** The API returns relative paths for loan documents instead of absolute URLs. Rather than polluting the Models or Views with string concatenation, helpers were added directly to the `LoanViewModel`.
*   **Modern Concurrency:** Network requests are handled using Swift's modern `async/await` syntax instead of completion handlers or Combine, resulting in highly readable, thread-safe code.
*   **Complex JSON Decoding:** The API payload contained a deeply nested structure for the repayment schedule (`repaymentSchedule -> installments -> [Installment]`). To parse this safely without writing a cumbersome custom `init(from decoder:)`, the Swift data models were structured to perfectly mirror the nested JSON, allowing `JSONDecoder` to handle the synthesis automatically.
*   **MainActor Isolation:** The `LoanViewModel` is marked with `@MainActor` to guarantee that all published property updates (like `loans` or `isLoading`) are routed to the main thread, preventing UI data races.

---

## Additional Features Implemented

Beyond the core requirements of fetching and displaying the list, the following quality-of-life features were implemented:

1.  **Dynamic Sorting:** Users can sort the active loan list via a navigation bar menu. Available sort options include **Amount** (descending), **Term** (descending), and **Purpose** (alphabetical).
2.  **Pull-to-Refresh:** Implemented the `.refreshable` modifier on the main list, allowing users to intuitively pull down to re-fetch the latest network data.
3.  **Robust Error Handling UI:** If the network request fails or the JSON schema changes, the app gracefully catches the error and displays a user-friendly error message alongside a functional **"Retry"** button, preventing dead-ends.
4.  **Smart URL Resolution:** The app safely checks if document URLs are already absolute paths or if they need the API's base domain appended to them, ensuring links always open correctly in Safari regardless of backend changes.

---
*Developed by Gabriela Putri Jelita Sihutomo*
