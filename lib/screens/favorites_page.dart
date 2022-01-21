import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houzeo_task/providers/auth_view_model_provider.dart';
import 'package:houzeo_task/providers/contact_detail_provider.dart';
import 'package:houzeo_task/providers/favorites_provider.dart';
import 'package:houzeo_task/screens/add_favorite_page.dart';
import 'package:houzeo_task/utils/loading.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model =
        ref.watch(favoritesProvider(ref.read(userProvider).value!.uid));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Favorites",
                  style: style.bodyText2!.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddMoreFavories(),
                      ),
                    );
                  },
                  child: const Text("Add More")),
            ],
          ),
        ),
        model.when(
          data: (favorites) => favorites.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text("No favorites available!"),
                  ),
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(children: [
                    ...favorites
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  e.altPhone!.title.isNotEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title:
                                                const Text("Choose a number"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
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
                                                  title: Text(e.phone.title),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : ref
                                          .read(contactDetailProvider)
                                          .directCall(e.phone.title);
                                },
                                onLongPress: () async {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: const Text(
                                                "Are you sure you want to remove from favorites"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("NO")),
                                              MaterialButton(
                                                onPressed: () => ref
                                                    .read(contactDetailProvider)
                                                    .changeFavStatus(e, () {
                                                  Navigator.pop(context);
                                                }),
                                                color: Colors.red,
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ));
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      child: Text(
                                        e.firstName[0],
                                        style: style.headline5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${e.firstName} ${e.lastName}",
                                      style: style.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ]),
                ),
          error: (e, s) => Center(
            child: Text(e.toString()),
          ),
          loading: () => const Loading(),
        ),
      ],
    );
  }
}
