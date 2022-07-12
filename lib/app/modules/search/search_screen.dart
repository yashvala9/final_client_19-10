import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';
import 'package:reel_ro/app/modules/search/widget/search_tile.dart';
import 'package:reel_ro/utils/empty_widget.dart';
import 'package:reel_ro/utils/snackbar.dart';
import 'package:reel_ro/widgets/chart_tile.dart';

import '../../../utils/assets.dart';
import '../../../widgets/loading.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  // final _controller = Get.put(SearchController());
  // final searchTextController = TextEditingController();
  final _debounce = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Text(
                "Search",
                style: style.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: "Search here..."),
              // controller: searchTextController,
              onFieldSubmitted: (value) {
                _debounce.run(() {
                  if (value.trim().isEmpty) {
                    showSnackBar("Search is empty", color: Colors.red);
                    return;
                  }
                  Get.to(
                    () => SearchUsers(
                      username: value.trim(),
                    ),
                  );
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            // Card(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //               ),
            //               color: colorSchema.primaryContainer,
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   ListTile(
            //                     contentPadding: const EdgeInsets.symmetric(
            //                         vertical: 8, horizontal: 8),
            //                     leading: CircleAvatar(
            //                       radius: 25,
            //                       backgroundColor: colorSchema.primary,
            //                       backgroundImage: AssetImage(Assets.profile),
            //                     ),
            //                     title: Text(
            //                       _controller.searchProfileModel!.fullname,
            //                       style: style.titleMedium!.copyWith(
            //                         fontWeight: FontWeight.w600,
            //                       ),
            //                     ),
            //                     subtitle: Text(
            //                       '@${_controller.searchProfileModel!.username}',
            //                       maxLines: 2,
            //                       overflow: TextOverflow.ellipsis,
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.only(
            //                       left: 12,
            //                       bottom: 8,
            //                       top: 4,
            //                     ),
            //                     child:
            //                         Text(_controller.searchProfileModel!.bio),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(16),
            //                       child: Image.asset(Assets.profile,
            //                           height: 300,
            //                           width: double.infinity,
            //                           fit: BoxFit.cover),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             )
          ],
        ),
      ),
    );
  }
}

class SearchUsers extends StatelessWidget {
  final String username;
  const SearchUsers({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final _controller = Get.put(SearchController(username));
    return GetBuilder<SearchController>(
      builder: (_) => SafeArea(
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Text(
                  "Search",
                  style: style.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                  child: _controller.loading
                      ? const Loading()
                      : _controller.searchProfiles.isEmpty
                          ? const EmptyWidget("No users found")
                          : ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                _controller.searchProfiles.length,
                                (index) => SearchTile(index: index),
                              ).toList(),
                            ))
            ],
          ),
        )),
      ),
    );
  }
}
