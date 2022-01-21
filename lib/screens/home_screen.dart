import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/providers/get_contacts_provider.dart';
import 'package:houzeo_task/screens/contacts_page.dart';
import 'package:houzeo_task/screens/favorites_page.dart';
import 'package:houzeo_task/utils/search_contact_delegate.dart';
import '../create_contact_screen.dart';

final indexStateProvider = StateProvider((ref) => 1);

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexStateProvider.state);
    final model = ref.watch(authProvider);
    final contacts =
        ref.watch(getContactsProvider(ref.read(userProvider).value!.uid)).value;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contacts"),
        actions: [
            IconButton(
                onPressed: () async {
                  showSearch(
                      context: context, delegate: SearchContact(contacts!));
                },
                icon: const Icon(Icons.search)),
            PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1) {
                    try {
                      await model.logOut();
                    } catch (e) {
                      print("logOut: $e");
                    }
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Logout"),
                        value: 1,
                      ),
                    ]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateContact(),
            ),
          ),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: index.state,
            onTap: (int i) => index.state = i,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Contacts",
              ),
            ]),
        body: index.state == 0 ? const FavoritesPage() : const ContactsPage(),
      ),
    );
  }
}

class CustomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authProvider);
    final contacts =
        ref.watch(getContactsProvider(ref.read(userProvider).value!.uid)).value;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(ref.read(userProvider).value!.photoURL!),
        ),
        title: const TextField(
          readOnly: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async {
                  showSearch(
                      context: context, delegate: SearchContact(contacts!));
                },
                icon: const Icon(Icons.search)),
            PopupMenuButton(
                onSelected: (v) async {
                  if (v == 1) {
                    try {
                      await model.logOut();
                    } catch (e) {
                      print("logOut: $e");
                    }
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Logout"),
                        value: 1,
                      ),
                    ]),
          ],
        ),
      ),
    );
  }
}
