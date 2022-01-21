import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/utils/constants.dart';

final contactRepository = Provider((ref) => ContactRepository());

class ContactRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String uid) async {
    final uploadTask = await _storage.ref("$uid/").putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> createContact(ContactModel contactModel) async {
    if (contactModel.id.isEmpty) {
      final docRef = _firestore.collection(Constants.contacts).doc();
      contactModel = contactModel.copyWith(
        id: docRef.id,
      );
      await docRef.set(contactModel.toMap());
    } else {
      await _firestore
          .collection(Constants.contacts)
          .doc(contactModel.id)
          .update(contactModel.toMap());
    }
  }

  Stream<List<ContactModel>> getContactsByUid(String uid) {
    return _firestore
        .collection(Constants.contacts)
        .where(Constants.uid, isEqualTo: uid)
        .withConverter<ContactModel>(
            fromFirestore: (model, _) => ContactModel.fromMap(model.data()!),
            toFirestore: (model, _) => model.toMap())
        .orderBy(Constants.firstName, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => e.data()).toList(),
        );
  }

  Stream<List<ContactModel>> getFavoriteContact(String uid) {
    return _firestore
        .collection(Constants.contacts)
        .where(Constants.uid, isEqualTo: uid)
        .where(Constants.isFavorite, isEqualTo: true)
        .withConverter<ContactModel>(
            fromFirestore: (model, _) => ContactModel.fromMap(model.data()!),
            toFirestore: (model, _) => model.toMap())
        .orderBy(Constants.firstName, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => e.data()).toList(),
        );
  }

  Future<void> deleteContact(String id) async {
    await _firestore.collection(Constants.contacts).doc(id).delete();
  }

  Future<void> changeFavStatus(bool val, String id) async {
    await _firestore.collection(Constants.contacts).doc(id).update({
      Constants.isFavorite: !val,
    });
  }
}
