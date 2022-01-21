import 'package:flutter/material.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/screens/contact_detail_page.dart';

class SearchContact extends SearchDelegate {
  final List<ContactModel> contacts;
  SearchContact(this.contacts);
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
          .map(
            (e) => ListTile(
              leading: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactDetailPage(
                      contactModel: e,
                    ),
                  ),
                ),
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
          .where(
            (element) => element.firstName.toLowerCase().startsWith(
                  query.toLowerCase(),
                ),
          )
          .map(
            (e) => ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactDetailPage(
                    contactModel: e,
                  ),
                ),
              ),
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
