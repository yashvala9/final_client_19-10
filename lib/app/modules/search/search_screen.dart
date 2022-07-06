import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/search/search_controller.dart';

import '../../../utils/assets.dart';
import '../../../widgets/loading.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final _controller = Get.put(SearchController());
  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return SingleChildScrollView(
      child: GetBuilder<SearchController>(
        builder: (_) => Padding(
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
                controller: searchTextController,
                onFieldSubmitted: (value) => _controller.searchUser(value),
                
              ),
              const SizedBox(
                height: 8,
              ),
              _controller.loading
                  ? const Loading()
                  : _controller.searchProfileModel == null
                      ? Container()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: colorSchema.primaryContainer,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: colorSchema.primary,
                                  backgroundImage: AssetImage(Assets.profile),
                                ),
                                title: Text(
                                  _controller.searchProfileModel!.fullname,
                                  style: style.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '@${_controller.searchProfileModel!.username}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 8,
                                  top: 4,
                                ),
                                child:
                                    Text(_controller.searchProfileModel!.bio),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(Assets.profile,
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
