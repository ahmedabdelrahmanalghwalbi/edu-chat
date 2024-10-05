import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/models/message.dart';
import '../features/models/user.dart';
import '../core/services/firebase_firestore/firebase_firestore.service.dart';

/// A provider class that manages Firebase-related data such as users and messages,
/// and notifies listeners when the data changes.
class FirebaseProvider extends ChangeNotifier {
  // ScrollController to manage scrolling in chat views.
  ScrollController scrollController = ScrollController();

  // List of all users fetched from Firebase.
  List<UserModel> users = [];

  // The current user being viewed, fetched by ID.
  UserModel? user;

  // List of messages for a specific chat between the current user and another user.
  List<Message> messages = [];

  // List of users that match the search query.
  List<UserModel> search = [];

  /// Fetches all users from Firestore, ordered by their last active time in descending order.
  /// Listens for real-time updates and updates the `users` list.
  ///
  /// - The data changes will trigger the [notifyListeners] method, which updates any UI components
  ///   listening to this provider.
  ///
  /// Returns the list of all users.
  List<UserModel> getAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users =
          users.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      notifyListeners(); // Notifies UI components of changes.
    });
    return users;
  }

  /// Fetches a single user from Firestore by their [userId].
  ///
  /// The method listens for real-time updates and updates the `user` variable.
  /// The updated user will notify any UI components that listen to the provider.
  ///
  /// Returns the user fetched from Firestore.
  UserModel? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = UserModel.fromJson(user.data()!);
      notifyListeners(); // Notifies UI components of changes.
    });
    return user;
  }

  /// Fetches messages between the current authenticated user and the [receiverId] from Firestore.
  ///
  /// The method listens for real-time updates and updates the `messages` list. Messages are ordered
  /// by their sent time in ascending order (oldest first). After fetching messages, it scrolls
  /// the chat view down to the latest message.
  ///
  /// Returns the list of messages exchanged between the two users.
  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners(); // Notifies UI components of changes.

      // Automatically scrolls to the bottom of the chat when new messages are received.
      scrollDown();
    });
    return messages;
  }

  /// Scrolls the chat view down to the latest message.
  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  /// Searches for users in Firestore whose names match or are similar to the [name] query.
  ///
  /// It updates the `search` list with the results and notifies listeners.
  ///
  /// Example usage:
  /// ```dart
  /// await firebaseProvider.searchUser("John");
  /// ```
  Future<void> searchUser(String name) async {
    search = await FirebaseFirestoreService.searchUser(name);
    notifyListeners(); // Notifies UI components of changes.
  }
}
