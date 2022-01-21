import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/create_contact_screen.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/providers/contact_detail_provider.dart';
import 'package:houzeo_task/providers/create_contact_provider.dart';

import 'home_screen.dart';

class ContactDetailPage extends ConsumerWidget {
  final ContactModel contactModel;
  const ContactDetailPage({Key? key, required this.contactModel})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(contactDetailProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("${contactModel.firstName} ${contactModel.lastName}"),
        actions: [
          IconButton(
            onPressed: () {
              model.changeFavStatus(contactModel, () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (route) => false);
              });
            },
            icon: Icon(
              Icons.star,
              color: contactModel.isFavorite ? Colors.amber : Colors.white,
            ),
          ),
          PopupMenuButton(
              onSelected: (v) async {
                if (v == 1) {
                  model.deleteContact(contactModel, () {
                    Navigator.pop(context);
                  });
                } else {
                  ref.read(createContactProvider).contactModel = contactModel;
                  final val = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateContact(),
                    ),
                  );
                  ref.read(createContactProvider).clean();
                  if (val != null) {
                    if (val) {
                      Navigator.pop(context);
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Delete"),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Edit"),
                      value: 2,
                    ),
                  ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(createContactProvider).contactModel = contactModel;
          final val = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateContact(),
            ),
          );
          ref.read(createContactProvider).clean();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
              (route) => false);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  contactModel.firstName[0],
                  style: style.headline3,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "${contactModel.firstName} ${contactModel.lastName}",
                      style: style.headline4!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            contactModel.altPhone!.title.isNotEmpty
                                ? showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text("Choose a number"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () => model.directCall(
                                                    contactModel.phone.title),
                                                title: Text(
                                                    contactModel.phone.title),
                                              ),
                                              ListTile(
                                                onTap: () => model.directCall(
                                                    contactModel
                                                        .altPhone!.title),
                                                title: Text(contactModel
                                                    .altPhone!.title),
                                              ),
                                            ],
                                          ),
                                        ))
                                : model.directCall(contactModel.phone.title);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Call",
                                style: style.bodyText1,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            contactModel.altPhone!.title.isNotEmpty
                                ? showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text("Choose a number"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () => model.sendSms(
                                                    contactModel.phone.title),
                                                title: Text(
                                                    contactModel.phone.title),
                                              ),
                                              ListTile(
                                                onTap: () => model.sendEmail(
                                                    contactModel
                                                        .altPhone!.title),
                                                title: Text(contactModel
                                                    .altPhone!.title),
                                              ),
                                            ],
                                          ),
                                        ))
                                : model.sendSms(contactModel.phone.title);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.message),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Text",
                                style: style.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () => model.directCall(contactModel.phone.title),
                    leading: const Icon(Icons.phone),
                    title: Text(contactModel.phone.title),
                    subtitle: contactModel.phone.label.isEmpty
                        ? null
                        : Text(contactModel.phone.label),
                    trailing: IconButton(
                        onPressed: () {
                          model.sendSms(contactModel.phone.title);
                        },
                        icon: const Icon(Icons.message)),
                  ),
                  Visibility(
                      visible: contactModel.altPhone != TitleLabel.empty(),
                      child: const Divider()),
                  contactModel.altPhone == TitleLabel.empty() ||
                          contactModel.altPhone!.title.isEmpty
                      ? Container()
                      : ListTile(
                          onTap: () =>
                              model.directCall(contactModel.altPhone!.title),
                          leading: const Icon(Icons.phone),
                          title: Text(contactModel.altPhone!.title),
                          subtitle: contactModel.altPhone!.label.isEmpty
                              ? null
                              : Text(contactModel.phone.label),
                          trailing: IconButton(
                              onPressed: () {
                                model.sendSms(contactModel.phone.title);
                              },
                              icon: const Icon(Icons.message)),
                        ),
                  Visibility(
                      visible: contactModel.email != TitleLabel.empty(),
                      child: const Divider()),
                  Visibility(
                    visible: contactModel.email != null &&
                        contactModel.email!.title.isNotEmpty,
                    child: ListTile(
                      onTap: () => model.sendEmail(contactModel.email!.title),
                      leading: const Icon(Icons.email),
                      title: Text(contactModel.email!.title),
                      subtitle: contactModel.email!.label.isEmpty
                          ? null
                          : Text(contactModel.email!.label),
                    ),
                  ),
                  Visibility(
                      visible: contactModel.atlEmail != TitleLabel.empty(),
                      child: const Divider()),
                  Visibility(
                    visible: contactModel.atlEmail != TitleLabel.empty() ||
                        contactModel.atlEmail!.title.isNotEmpty,
                    child: ListTile(
                      onTap: () => model.sendEmail(contactModel.email!.title),
                      leading: const Icon(Icons.email),
                      title: Text(contactModel.atlEmail!.title),
                      subtitle: contactModel.atlEmail!.label.isEmpty
                          ? null
                          : Text(contactModel.atlEmail!.label),
                    ),
                  ),
                  Visibility(
                      visible: contactModel.address != TitleLabel.empty(),
                      child: const Divider()),
                  Visibility(
                    visible: contactModel.address != TitleLabel.empty() ||
                        contactModel.address!.title.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(contactModel.address!.title),
                      subtitle: contactModel.address!.label.isEmpty
                          ? null
                          : Text(contactModel.address!.label),
                    ),
                  ),
                  Visibility(
                      visible: contactModel.atlAddress != TitleLabel.empty(),
                      child: const Divider()),
                  Visibility(
                    visible: contactModel.atlAddress != TitleLabel.empty() ||
                        contactModel.atlAddress!.title.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(contactModel.atlAddress!.title),
                      subtitle: contactModel.atlAddress!.label.isEmpty
                          ? null
                          : Text(contactModel.atlAddress!.label),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                      visible: contactModel.relationShip != TitleLabel.empty(),
                      child: const Divider()),
                  Visibility(
                    visible: contactModel.relationShip != TitleLabel.empty() ||
                        contactModel.relationShip!.title.isNotEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.person_outline_rounded),
                      title: Text(contactModel.relationShip!.title),
                      subtitle: contactModel.relationShip!.label.isEmpty
                          ? null
                          : Text(contactModel.relationShip!.label),
                    ),
                  ),
                  contactModel.website == null || contactModel.website!.isEmpty
                      ? Container()
                      : ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(contactModel.website!),
                          subtitle: const Divider(),
                        ),
                  contactModel.notes == null || contactModel.notes!.isEmpty
                      ? Container()
                      : ListTile(
                          leading: const Icon(Icons.note),
                          title: Text(contactModel.notes!),
                          subtitle: const Divider(),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
