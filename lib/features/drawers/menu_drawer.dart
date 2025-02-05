import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/core/Theme/app_pallete.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';

void logOut(WidgetRef ref) {
  ref.watch(authControllerProvider.notifier).logOut();
}

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontFamily: 'carter'),
          ),
          Text(
            '+91 ${user.phoneNumber}',
            style: const TextStyle(fontSize: 18, fontFamily: 'carter'),
          ),
          const Divider(
            thickness: 0.7,
          ),
          ListTile(
            title: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontFamily: 'carter'),
            ),
            leading: Icon(
              Icons.logout,
              color: AppPallete.errorColor,
            ),
            onTap: () {
              logOut(ref);
            },
          ),
        ],
      )),
    );
  }
}
