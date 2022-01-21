import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/providers/create_contact_provider.dart';
import 'package:houzeo_task/screens/home_screen.dart';
import 'package:houzeo_task/utils/custom_textfield.dart';
import 'package:houzeo_task/utils/loading.dart';
import 'package:houzeo_task/utils/profile_image_picker.dart';

class CreateContact extends ConsumerWidget {
  CreateContact({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(createContactProvider);
    return Scaffold(
      appBar: AppBar(
        title: model.isEdit ? Text("Edit contact") : Text("Create contact"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            model.submit(() {
              model.clean();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                  (route) => false);
            });
          }
        },
        label: model.isEdit ? const Text("Edit") : const Text("Save"),
      ),
      body: model.loading
          ? const Loading()
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileImagePicker(
                        file: model.file,
                        onSelect: (v) => model.file = v,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Add Photo",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        initialValue: model.firstName,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("First name"),
                          // hintText: "First Name",
                        ),
                        onSaved: (v) {
                          model.firstName = v!;
                        },
                        validator: (v) =>
                            v!.isEmpty ? "First name is required" : null,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        initialValue: model.lastName,
                        decoration: const InputDecoration(
                          icon: SizedBox(
                            width: 21,
                          ),
                          label: Text("Last name"),
                          hintText: "Last Name",
                        ),
                        onSaved: (v) {
                          model.lastName = v;
                        },
                        validator: (v) {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        icon: Icons.phone,
                        isPhone: true,
                        label: "Phone",
                        validator: (v) => model.validatePhone(v!),
                        items: model.phoneLabels,
                        initial: model.phone,
                        onChange: (v) {
                          model.phone = v!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        icon: Icons.phone,
                        isPhone: true,
                        label: "Alt Phone",
                        validator: (v) =>
                            v!.isNotEmpty ? model.validatePhone(v) : null,
                        items: model.phoneLabels,
                        initial: model.atlPhone ?? TitleLabel.empty(),
                        onChange: (v) => model.atlPhone = v,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        icon: Icons.email,
                        isPhone: false,
                        label: "Email",
                        validator: (v) =>
                            v!.isNotEmpty ? model.validateEmail(v) : null,
                        items: model.emailLabels,
                        initial: model.email ?? TitleLabel.empty(),
                        onChange: (v) => model.email = v,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        icon: Icons.alternate_email,
                        isPhone: false,
                        label: "Alt email",
                        validator: (v) =>
                            v!.isNotEmpty ? model.validateEmail(v) : null,
                        items: model.emailLabels,
                        initial: model.atlEmail ?? TitleLabel.empty(),
                        onChange: (v) => model.atlEmail = v,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            model.moreFields = !model.moreFields;
                          },
                          child: Text(!model.moreFields
                              ? "More fields"
                              : "Less fields"),
                        ),
                      ),
                      !model.moreFields
                          ? Container()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  icon: Icons.location_on,
                                  isPhone: false,
                                  label: "Address",
                                  validator: (v) {},
                                  items: model.emailLabels,
                                  initial: model.address ?? TitleLabel.empty(),
                                  onChange: (v) => model.address = v,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomTextField(
                                  icon: Icons.location_on,
                                  isPhone: false,
                                  label: "Alt Address",
                                  validator: (v) {},
                                  items: model.emailLabels,
                                  initial:
                                      model.altAddress ?? TitleLabel.empty(),
                                  onChange: (v) => model.altAddress = v,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomTextField(
                                  icon: Icons.person,
                                  isPhone: false,
                                  label: "Relationship",
                                  validator: (v) {},
                                  items: model.relationShipLabels,
                                  initial:
                                      model.relationShip ?? TitleLabel.empty(),
                                  onChange: (v) => model.relationShip = v,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  initialValue: model.website,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.link),
                                    label: Text("Website"),
                                  ),
                                  onSaved: (v) => model.website = v,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  initialValue: model.notes,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.note),
                                    label: Text("Notes"),
                                  ),
                                  onSaved: (v) => model.notes = v,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
