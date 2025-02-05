import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/Resposive/responsive.dart';
import 'package:yappr/core/commons/loader.dart';
import 'package:yappr/core/constants/error_text.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/features/chat/controller/chat_controller.dart';
import 'package:yappr/features/chat/screens/pages/message_screen.dart';
import 'package:yappr/features/drawers/menu_drawer.dart';

class ChatScreen extends ConsumerWidget {
  final String uid;
  const ChatScreen({super.key, required this.uid});

  void navigateToMessageScreen(BuildContext context, String receiverId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageScreen(receiverId: receiverId)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(userProvider)!.uid;
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text(
          'Yappr',
          style: TextStyle(
            fontFamily: 'carter',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 42,
              weight: 30,
            ),
          );
        }),
      ),
      body: ref.watch(fetchAllUsersProvider).when(
            data: (userModels) {
              if (userModels.isEmpty) {
                return const Center(
                    child: ErrorText(error: 'No chat room exits.'));
              }
              return Center(
                child: Responsive(
                  child: ListView.builder(
                    itemCount: userModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userModels[index];
                      return GestureDetector(
                        onTap: () => navigateToMessageScreen(context, user.uid),
                        child: currUser == user.uid
                            ? const SizedBox()
                            : ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(user.profilePic),
                                    ),
                                  ),
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontFamily: 'carter',
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
