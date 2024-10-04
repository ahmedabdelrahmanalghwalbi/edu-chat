import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/firebase_firestore/firebase_firestore.service.dart';
import '../../../../core/services/media/media.service.dart';
import '../../../../core/services/notification/notification_legacy.service.dart';
import '../../search/widgets/custom_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  final notificationsService = NotificationsService();

  Uint8List? file;

  @override
  void initState() {
    notificationsService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: AppStrings.addMessage,
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
          gapW4,
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: AppSizes.s20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _sendImage,
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      await notificationsService.sendNotification(
        body: controller.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
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
      await notificationsService.sendNotification(
        body: AppStrings.image,
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }
}
