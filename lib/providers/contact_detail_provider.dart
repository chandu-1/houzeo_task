import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/repository/call_logs_repository.dart';
import 'package:houzeo_task/repository/contact_repository.dart';
import 'package:url_launcher/url_launcher.dart';

final contactDetailProvider =
    ChangeNotifierProvider((ref) => ContactDetailViewModel(ref));

class ContactDetailViewModel extends ChangeNotifier {
  final Ref ref;
  ContactDetailViewModel(this.ref);

  ContactRepository get contactRepo => ref.read(contactRepository);
  CallLogsRepository get callRepo => ref.read(callLogsProvider);

  void changeFavStatus(ContactModel contactModel, VoidCallback onDone) async {
    try {
      await contactRepo.changeFavStatus(
        contactModel.isFavorite,
        contactModel.id,
      );
      onDone();
    } catch (e) {
      print("favorite: $e");
    }
  }

  void deleteContact(ContactModel contactModel, VoidCallback onDone) async {
    try {
      await ref.read(contactRepository).deleteContact(contactModel.id);
      onDone();
    } catch (e) {
      print("deleteContact: $e");
    }
  }

  void directCall(String number) async {
    try {
      await callRepo.call(number);
    } catch (e) {
      print("directCall: $e");
    }
  }

  void sendSms(String number) async {
    final _url = 'sms:$number';
    if (await canLaunch(_url)) {
      launch(_url);
    } else {
      throw "error";
    }
  }

  void sendEmail(String email) async {
    final _url = 'mailto:$email';
    if (await canLaunch(_url)) {
      launch(_url);
    } else {
      throw "error";
    }
  }
}
