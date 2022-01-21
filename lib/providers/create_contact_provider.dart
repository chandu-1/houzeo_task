import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/repository/contact_repository.dart';

final createContactProvider =
    ChangeNotifierProvider((ref) => CreateContactViewModel(ref));

class CreateContactViewModel extends ChangeNotifier {
  final Ref ref;
  CreateContactViewModel(this.ref);

  User? get user => ref.read(userProvider).value;

  ContactRepository get _contactRepo => ref.read(contactRepository);

  final phoneLabels = [
    "No label",
    "Mobile",
    "Work",
    "Home",
    "Main",
    "Work Fax",
    "Home Fax",
    "Pager",
    "Other",
    "Custom",
  ];

  final emailLabels = [
    "No label",
    "Home",
    "Work",
    "Other",
    "Custom",
  ];

  final relationShipLabels = [
    "No label",
    "Assistant",
    "Brother",
    "Child",
    "Domestic Partner",
    "Father",
    "Friend",
    "Manager",
    "Mother",
    "Parent",
    "Partner",
    "Reffered by",
    "Relative",
    "Sister",
    "Spouse",
  ];

  var staticlabels = [
    "Family",
    "Friends",
  ];

  ContactModel? _contactModel;
  ContactModel get contactModel => _contactModel ?? ContactModel.empty();
  set contactModel(ContactModel contactModel) {
    _contactModel = contactModel;
  }

  String? _imgUrl;
  String? get imgUrl => _imgUrl ?? contactModel.imgUrl;
  set imgUrl(String? imgUrl) {
    _imgUrl = imgUrl;
  }

  bool get isEdit => contactModel != ContactModel.empty();

  String? _firstName;
  String get firstName => _firstName ?? contactModel.firstName;
  set firstName(String firstName) {
    _firstName = firstName;
  }

  String? _lastName;
  String? get lastName => _lastName ?? contactModel.lastName;
  set lastName(String? lastName) {
    _lastName = lastName;
  }

  TitleLabel? _phone;
  TitleLabel get phone => _phone ?? contactModel.phone;
  set phone(TitleLabel phone) {
    _phone = phone;
    notifyListeners();
  }

  TitleLabel? _atlPhone;
  TitleLabel? get atlPhone => _atlPhone ?? contactModel.altPhone;
  set atlPhone(TitleLabel? atlPhone) {
    _atlPhone = atlPhone;
    notifyListeners();
  }

  TitleLabel? _email;
  TitleLabel? get email => _email ?? contactModel.email;
  set email(TitleLabel? email) {
    _email = email;
    notifyListeners();
  }

  TitleLabel? _atlEmail;
  TitleLabel? get atlEmail => _atlEmail ?? contactModel.atlEmail;
  set atlEmail(TitleLabel? atlEmail) {
    _atlEmail = atlEmail;
    notifyListeners();
  }

  TitleLabel? _address;
  TitleLabel? get address => _address ?? contactModel.address;
  set address(TitleLabel? address) {
    _address = address;
    notifyListeners();
  }

  TitleLabel? _altAddress;
  TitleLabel? get altAddress => _altAddress ?? contactModel.atlAddress;
  set altAddress(TitleLabel? altAddress) {
    _altAddress = altAddress;
    notifyListeners();
  }

  TitleLabel? _relationShip;
  TitleLabel? get relationShip => _relationShip ?? contactModel.relationShip;
  set relationShip(TitleLabel? relationShip) {
    _relationShip = relationShip;
    notifyListeners();
  }

  String? _website;
  String? get website => _website ?? contactModel.website;
  set website(String? website) {
    _website = website;
  }

  String? _notes;
  String? get notes => _notes ?? contactModel.notes;
  set notes(String? notes) {
    _notes = notes;
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  bool _moreFields = false;
  bool get moreFields => _moreFields;
  set moreFields(bool moreFields) {
    _moreFields = moreFields;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  String? validateEmail(String v) {
    if (v.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(v)) {
      return "Invalid email";
    }
    return null;
  }

  String? validatePhone(String v) {
    if (v.isEmpty) {
      return "Phone number is required";
    }
    if (v.length != 10) {
      return "Phone number must be 10 digits";
    }
    return null;
  }

  void clean() {
    _firstName = null;
    lastName = null;
    _phone = null;
    atlPhone = null;
    email = null;
    atlEmail = null;
    address = null;
    altAddress = null;
    relationShip = null;
    notes = null;
    website = null;
    contactModel = ContactModel.empty();
  }

  void submit(VoidCallback onDone) async {
    loading = true;

    final updated = contactModel.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      altPhone: atlPhone,
      email: email,
      atlEmail: atlEmail,
      website: website,
      address: address ?? TitleLabel.empty(),
      atlAddress: altAddress ?? TitleLabel.empty(),
      relationShip: relationShip ?? TitleLabel.empty(),
      notes: notes,
      uid: user!.uid,
    );
    try {
      await _contactRepo.createContact(updated);
      onDone();
    } catch (e) {
      print("createContact: $e");
    }
    loading = false;
  }
}
