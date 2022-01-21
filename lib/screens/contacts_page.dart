import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/providers/contact_detail_provider.dart';
import 'package:houzeo_task/providers/get_contacts_provider.dart';
import 'package:houzeo_task/screens/contact_detail_page.dart';
import 'package:houzeo_task/utils/loading.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model =
        ref.watch(getContactsProvider(ref.read(userProvider).value!.uid));
    return model.when(
      data: (contacts) => contacts.isEmpty
          ? const Center(
              child: Text("No contacts available!"),
            )
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: contacts
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Dismissible(
                          key: UniqueKey(),
                          confirmDismiss: (dismissDirection) async {
                            if (dismissDirection ==
                                DismissDirection.startToEnd) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to delete this contact"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("NO")),
                                    MaterialButton(
                                      color: Colors.red,
                                      onPressed: () async {
                                        ref
                                            .read(contactDetailProvider)
                                            .deleteContact(e, () {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text("YES"),
                                    ),
                                  ],
                                ),
                              );
                              return false;
                            }
                            return false;
                          },
                          background: Material(
                            color: Colors.red,
                            child: Row(
                              children: const [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Center(
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: ListTile(
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
                            trailing: IconButton(
                              onPressed: () {
                                e.altPhone!.title.isNotEmpty
                                    ? showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text("Choose a number"),
                                              content: Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () => ref
                                                        .read(
                                                            contactDetailProvider)
                                                        .directCall(
                                                            e.phone.title),
                                                    title: Text(e.phone.title),
                                                  ),
                                                  ListTile(
                                                    onTap: () => ref
                                                        .read(
                                                            contactDetailProvider)
                                                        .directCall(
                                                            e.altPhone!.title),
                                                    title:
                                                        Text(e.altPhone!.title),
                                                  ),
                                                ],
                                              ),
                                            ))
                                    : ref
                                        .read(contactDetailProvider)
                                        .directCall(e.phone.title);
                              },
                              icon: const Icon(Icons.phone),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
      error: (e, s) => Text(e.toString()),
      loading: () => const Loading(),
    );
  }
}
