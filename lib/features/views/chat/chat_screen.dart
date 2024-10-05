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
      body: Column(
        children: [
          ChatMessages(receiverId: widget.userId),
          ChatTextField(receiverId: widget.userId)
        ],
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xff463462),
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.user != null
            ? Row(
                children: [
                  if (value.user?.image != null)
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(value.user!.image),
                          radius: AppSizes.s22,
                        ),
                        CircleAvatar(
                          backgroundColor: value.user?.isOnline ?? false
                              ? Colors.green
                              : Colors.grey,
                          radius: AppSizes.s5,
                        ),
                      ],
                    ),
                  gapW12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.user?.name ?? '-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.s20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      gapH4,
                      Text(
                        value.user?.isOnline ?? false
                            ? AppStrings.online
                            : AppStrings.offline,
                        style: TextStyle(
                          color: value.user?.isOnline ?? false
                              ? Colors.green
                              : Colors.grey,
                          fontSize: AppSizes.s14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
      ));
}
