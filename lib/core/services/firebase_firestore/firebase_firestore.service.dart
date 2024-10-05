import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/models/message.dart';
import '../../../features/models/user.dart';
import '../firebase_storage/firebase_storage.service.dart';

/// A service class that handles operations related to Firestore, such as
/// creating users, sending messages, and updating user data.
class FirebaseFirestoreService {
  // Firestore instance to interact with the Firestore database.
  static final firestore = FirebaseFirestore.instance;

  /// Creates a new user in the Firestore `users` collection.
  ///
  /// Takes the user's [name], [image], [email], and [uid] as required parameters
  /// and saves them in the database.
  ///
  /// The user is set to online and the last active time is set to the current time.
  static Future<void> createUser({
    required String name,
    required String image,
    required String email,
    required String uid,
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      image: image,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    // Save the user data as a document with `uid` as the document ID.
    await firestore.collection('users').doc(uid).set(user.toJson());
  }

  /// Sends a text message from the current user to the [receiverId].
  ///
  /// The [content] of the message is saved along with metadata like the time
  /// the message was sent, the receiver's ID, and the sender's ID.
  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Adds the message to both the sender's and receiver's chat history.
    await _addMessageToChat(receiverId, message);
  }

  /// Sends an image message from the current user to the [receiverId].
  ///
  /// The image [file] is uploaded to Firebase Storage and the file URL is saved
  /// as the content of the message. The message is then stored in the chat.
  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    // Uploads the image file and gets the download URL.
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Adds the message to both the sender's and receiver's chat history.
    await _addMessageToChat(receiverId, message);
  }

  /// A helper function that adds a [message] to the chat between the current user
  /// and the user with [receiverId].
  ///
  /// The message is added to both the sender's and receiver's message collection.
  static Future<void> _addMessageToChat(
    String receiverId,
    Message message,
  ) async {
    // Adds the message to the current user's chat history with the receiver.
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    // Adds the message to the receiver's chat history with the current user.
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  /// Updates the current user's data in the Firestore `users` collection.
  ///
  /// Accepts a [data] map of key-value pairs representing the user data fields
  /// to be updated.
  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  /// Searches for users in the Firestore `users` collection based on their [name].
  ///
  /// Returns a list of [UserModel] objects whose name matches the search criteria.
  static Future<List<UserModel>> searchUser(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    // Maps Firestore document data to UserModel objects.
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }
}
