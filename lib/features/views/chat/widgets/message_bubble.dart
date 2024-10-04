import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_sizes.dart';
import '../../../models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final bool isImage;
  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(AppSizes.s30),
                    bottomRight: Radius.circular(AppSizes.s30),
                    topLeft: Radius.circular(AppSizes.s30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(AppSizes.s30),
                    bottomLeft: Radius.circular(AppSizes.s30),
                    topLeft: Radius.circular(AppSizes.s30),
                  ),
          ),
          margin: const EdgeInsets.only(
              top: AppSizes.s10, right: AppSizes.s10, left: AppSizes.s10),
          padding: const EdgeInsets.all(AppSizes.s10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              isImage
                  ? Container(
                      height: AppSizes.s200,
                      width: AppSizes.s200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.s15),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(message.content,
                      style: const TextStyle(color: Colors.white)),
              const SizedBox(height: AppSizes.s5),
              Text(
                timeago.format(message.sentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.s10,
                ),
              ),
            ],
          ),
        ),
      );
}
