import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../provider/firebase_provider.dart';
import 'widgets/chat_messages.dart';
import 'widgets/chat_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.userId),
            ChatTextField(receiverId: widget.userId)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.user != null
            ? Row(
                children: [
                  if (value.user?.image != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.user!.image),
                      radius: AppSizes.s20,
                    ),
                  gapW12,
                  Column(
                    children: [
                      Text(
                        value.user?.name ?? '-',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: AppSizes.s20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.user?.isOnline ?? false
                            ? AppStrings.online
                            : AppStrings.offline,
                        style: TextStyle(
                          color: value.user?.isOnline ?? false
                              ? Colors.green
                              : Colors.grey,
                          fontSize: AppSizes.s14,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
      ));
}
