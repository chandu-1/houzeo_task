import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/screens/home_screen.dart';
import 'package:houzeo_task/screens/login_screen.dart';
import 'package:houzeo_task/utils/loading.dart';

class Root extends ConsumerWidget {
  const Root({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) => user == null ? const LoginPage() : const HomePage(),
          error: (e, s) => Text(e.toString()),
          loading: () => const Loading(),
        );
  }
}
