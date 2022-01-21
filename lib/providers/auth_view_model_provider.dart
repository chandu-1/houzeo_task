import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = Provider((ref) => AuthViewModel(ref));

final userProvider =
    StreamProvider((ref) => ref.read(authProvider).authChanges);

class AuthViewModel extends ChangeNotifier {
  final Ref ref;
  AuthViewModel(this.ref);

  final auth = FirebaseAuth.instance;
  Stream<User?> get authChanges => auth.authStateChanges();

  Future<void> logOut() async {
    await auth.signOut();
  }
}
