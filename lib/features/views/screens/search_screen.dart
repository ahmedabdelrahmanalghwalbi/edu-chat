import 'package:edu_chat/core/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../provider/firebase_provider.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/empty_widget.dart';
import '../widgets/user_item.dart';

class UsersSearchScreen extends StatefulWidget {
  const UsersSearchScreen({super.key});

  @override
  State<UsersSearchScreen> createState() => _UsersSearchScreenState();
}

class _UsersSearchScreenState extends State<UsersSearchScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text(
            AppStrings.userSearch,
            style: TextStyle(fontSize: AppSizes.s25),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
          child: Column(
            children: [
              CustomTextFormField(
                controller: controller,
                hintText: AppStrings.search,
                onChanged: (val) =>
                    Provider.of<FirebaseProvider>(context, listen: false)
                        .searchUser(val),
              ),
              Consumer<FirebaseProvider>(
                builder: (context, value, child) => Expanded(
                  child: controller.text.isEmpty
                      ? const EmptyWidget(
                          icon: Icons.search, text: AppStrings.searchOfUser)
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSizes.s16),
                          itemCount: value.search.length,
                          itemBuilder: (context, index) =>
                              value.search[index].uid !=
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? UserItem(user: value.search[index])
                                  : const SizedBox(),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}
