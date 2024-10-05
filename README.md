
# Edu_Chat - Flutter Chat Application

## 1. Project Demo Video 🎥
[Edu_Chat Demo Video](#)  
*Add the link to your project demo video here after recording and uploading it to a platform like YouTube or Vimeo.*

---

## 2. Project Architecture: Layered First File Architecture with MVC Pattern

### Overview
Edu_Chat is built following the **MVC (Model-View-Controller)** pattern, ensuring a clean separation of concerns and making the project more scalable and maintainable. The project also uses **Provider** as the state management solution and integrates Firebase services for user authentication, real-time database, and media storage.

### Architecture Breakdown

- **Model**: This layer manages the data and business logic, including interactions with Firebase Firestore and Firebase Storage.
- **View**: This layer defines the user interface using Flutter widgets, including screens for authentication, chat, and user search.
- **Controller**: Acts as the intermediary between the View and Model, handling user input, managing authentication, and ensuring real-time updates in the chat interface.

### Technologies Used
- **State Management**: Provider
- **Firebase Authentication**: Handles user sign-up, login, and logout.
- **Firestore**: Manages real-time messaging and stores user data.
- **Firebase Storage**: Used to store and retrieve media files (e.g., images).

---

## 3. Features in Edu_Chat

### User Authentication
- **Firebase Authentication** is implemented to handle user sign-up, login, and logout.
- Support for both email-based and anonymous authentication.

### Real-Time Messaging
- **Firestore** is used to enable real-time messaging, ensuring messages are sent and received instantly.
- Chat history is displayed with user-friendly timestamps (e.g., "1 minute ago").
- **Online status indicators** show whether users are active, with last-seen timestamps (e.g., "Active 1 minute ago").
- Users can send both text and media messages (images).

### User Search
- **Search Page** allows users to search for other users by name or ID and initiate conversations.

### Chat Interface
- **User-friendly chat interface**: Messages are displayed in a chat bubble format with user avatars and timestamps.
- A text input field and send button are provided for sending messages.
- Supports real-time updates and smooth interactions for an optimal chat experience.

---

## 4. Installation and Setup

### Steps to Run the Project Locally

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/ahmedabdelrahmanalghwalbi/edu-chat.git
   cd edu-chat
   ```

2. **Install Dependencies**  
   Run the following command to install all necessary dependencies:
   ```bash
   flutter pub get
   ```

3. **Connect to Firebase**  
   This project is linked to a Firebase project under my account. To run it with your own Firebase account:
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new Firebase project and add Android and iOS apps.
   - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) from your Firebase project.
   - Replace the existing `google-services.json` and `GoogleService-Info.plist` files in the project with your own.

4. **Run the App**  
   Use the following command to run the app on your connected device or emulator:
   ```bash
   flutter run
   ```

### Note:
The project is connected to Firebase services via my email account, but you can easily set up your own Firebase account and replace the configuration files (`google-services.json` and `GoogleService-Info.plist`) to run the app under your own Firebase project.


