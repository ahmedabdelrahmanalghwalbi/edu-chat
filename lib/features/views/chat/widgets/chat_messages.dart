import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../models/message.dart';
import '../../../../provider/firebase_provider.dart';
import '../../search/widgets/empty_widget.dart';
import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.receiverId});
  final String receiverId;

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
      builder: (context, value, child) => Expanded(
            child: Container(
              color: Colors.black,
              child: value.messages.isEmpty
                  ? EmptyWidget(
                      icon: Icons.waving_hand,
                      text: AppStrings.sayHello,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppSizes.s8),
                      child: ListView.builder(
                        controller: Provider.of<FirebaseProvider>(context,
                                listen: false)
                            .scrollController,
                        itemCount: value.messages.length,
                        itemBuilder: (context, index) {
                          final isTextMessage =
                              value.messages[index].messageType ==
                                  MessageType.text;
                          final isMe =
                              receiverId != value.messages[index].senderId;

                          return isTextMessage
                              ? MessageBubble(
                                  isMe: isMe,
                                  message: value.messages[index],
                                  isImage: false,
                                )
                              : MessageBubble(
                                  isMe: isMe,
                                  message: value.messages[index],
                                  isImage: true,
                                );
                        },
                      ),
                    ),
            ),
          ));
}
