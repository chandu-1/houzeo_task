import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/providers/contact_detail_provider.dart';
import 'package:houzeo_task/providers/get_contacts_provider.dart';
import 'package:houzeo_task/screens/search_favorites_delegate.dart';

import 'home_screen.dart';

class AddMoreFavories extends ConsumerWidget {
  const AddMoreFavories({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref
        .watch(getContactsProvider(ref.read(userProvider).value!.uid))
        .asData!
        .value;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a contact"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchFavorites(contacts, ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: contacts
            .where((element) => !element.isFavorite)
            .toList()
            .map((e) => ListTile(
                  onTap: () async {
                    ref.read(contactDetailProvider).changeFavStatus(e, () {
                        Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                  (route) => false);
                    });
                  },
                  leading: CircleAvatar(
                    radius: 20,
                    child: Text(e.firstName[0]),
                  ),
                  title: Text("${e.firstName} ${e.lastName}"),
                ))
            .toList(),
      ),
    );
  }
}
