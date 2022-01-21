import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/models/contact_model.dart';
import 'package:houzeo_task/repository/contact_repository.dart';

final favoritesProvider = StreamProvider.family<List<ContactModel>, String>(
    (ref, uid) => ref.read(contactRepository).getFavoriteContact(uid));
