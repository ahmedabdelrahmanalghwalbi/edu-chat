import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/firebase_firestore/firebase_firestore.service.dart';
import '../../../../core/services/media/media.service.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  // final notificationsService = NotificationsService();
  Uint8List? file;

  @override
  void initState() {
    // TODO: Implement push notification service
    // notificationsService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(color: Colors.black87),
        padding: const EdgeInsets.only(
            left: AppSizes.s8,
            right: AppSizes.s8,
            top: AppSizes.s14,
            bottom: AppSizes.s40),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: AppSizes.s20,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _sendImage,
              ),
            ),
            gapW4,
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: AppStrings.addMessage,
                    contentPadding: EdgeInsets.all(AppSizes.s12)),
              ),
            ),
            gapW4,
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: AppSizes.s20,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendText(context),
              ),
            ),
          ],
        ),
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      // TODO: Implement push notification service
      // await notificationsService.sendNotification(
      //   body: controller.text,
      //   senderId: FirebaseAuth.instance.currentUser!.uid,
      // );
      controller.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
      // TODO: Implement push notification service
      // await notificationsService.sendNotification(
      //   body: AppStrings.image,
      //   senderId: FirebaseAuth.instance.currentUser!.uid,
      // );
    }
  }
}
