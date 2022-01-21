import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/providers/contact_detail_provider.dart';

import 'home_screen.dart';

class SearchFavorites extends SearchDelegate {
  final List<ContactModel> contacts;
  final WidgetRef ref;
  SearchFavorites(this.contacts, this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          showSuggestions(context);
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: contacts
          .where((element) => !element.isFavorite)
          .map(
            (e) => ListTile(
              leading: ListTile(
                onTap: () {
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
              ),
              title: Text(e.firstName),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: contacts
          .where((element) => !element.isFavorite)
          .where(
            (element) => element.firstName.toLowerCase().startsWith(
                  query.toLowerCase(),
                ),
          )
          .map(
            (e) => ListTile(
              onTap: () {
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
            ),
          )
          .toList(),
    );
  }
}
