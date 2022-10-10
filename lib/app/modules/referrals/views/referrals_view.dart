import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/send_invite/views/send_invite_view.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../repositories/notification_repository.dart';
import '../../../../utils/base.dart';
import '../../../../widgets/loading.dart';
import '../controllers/referrals_controller.dart';

class ReferralsView extends GetView<ReferralsController> {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(ReferralsController());
  final _notificationRepo = Get.put(NotificationRepository());
  final _reelRepo = Get.put(ReelRepository());

  @override
  Widget build(BuildContext context) {
    _controller.getReferralList();
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Referrals',
            style: TextStyle(fontSize: 17),
          ),
        ),
        // backgroundColor: AppColors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder<List<String>>(
                  future: _giveawayRepo.getBuddyPairByUserId(
                      _controller.profileId!, _controller.token!),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: Get.height * 0.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xffFFD669), Color(0xffFFEAB4)],
                            stops: [0.0, 1.0],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: (!snapshot.hasData)
                                    ? const NetworkImage(
                                        'https://s3.amazonaws.com/babelcube/users/61f7c584d9efd_fault-avatar-profile-icon-vector-social-media-user-image-182145777.jpg')
                                    : NetworkImage(
                                        "${Base.profileBucketUrl}/${snapshot.data![0].toString()}",
                                      ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Buddy Pair:",
                                  style:
                                      style.titleMedium?.copyWith(fontSize: 14),
                                ),
                                (!snapshot.hasData)
                                    ? const Loading()
                                    : Text(
                                        snapshot.data![1].toString(),
                                        style: style.titleSmall
                                            ?.copyWith(fontSize: 18),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: AppColors.containerGradiantColor,
                          stops: [0.0, 1.0],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Referral Entries",
                                      style: style.headlineSmall
                                          ?.copyWith(fontSize: 20),
                                    ),
                                    FutureBuilder<String>(
                                      future: _giveawayRepo
                                          .getReferralsEntryCountByUserId(
                                              _controller.profileId!,
                                              _controller.token!),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Loading();
                                        }
                                        if (snapshot.hasError) {
                                          printInfo(
                                              info:
                                                  "getReferralsEntryCountByUserId: ${snapshot.hasError}");
                                          return Container();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data.toString(),
                                            style: style.titleLarge?.copyWith(
                                                color: AppColors.red),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: Get.width * 0.35,
                                  height: 50,
                                  child: MyElevatedButton(
                                    buttonText: "Send Invite",
                                    onPressed: () {
                                      Get.to(() => SendInviteView());
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _controller.referrals.isNotEmpty
                              ? DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Color(0xffF6DC9D)),
                                  dataRowColor: MaterialStateProperty.all(
                                      Color(0xffFFF3D2)),
                                  columnSpacing: 10,
                                  dataRowHeight: 80,
                                  columns: const [
                                    DataColumn(
                                      label: Text("Name",
                                          textAlign: TextAlign.center),
                                    ),
                                    DataColumn(
                                      label: Text("Total\nEntries",
                                          textAlign: TextAlign.center),
                                    ),
                                    DataColumn(
                                      label: Text("Referral\nEntries",
                                          textAlign: TextAlign.center),
                                    ),
                                    DataColumn(
                                      label: Text("Activity",
                                          textAlign: TextAlign.center),
                                    ),
                                    DataColumn(
                                      label: Text("Poke",
                                          textAlign: TextAlign.center),
                                    )
                                  ],
                                  rows: _controller
                                      .referrals // Loops through dataColumnText, each iteration assigning the value to element
                                      .map(
                                        ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 12,
                                                        child: CircleAvatar(
                                                          backgroundImage: element
                                                                      .user_profile ==
                                                                  null
                                                              ? NetworkImage(
                                                                  'assets/Ellipse_1.png')
                                                              : NetworkImage(
                                                                  "${Base.profileBucketUrl}/${element.user_profile!.profile_img}",
                                                                ),
                                                        ),
                                                      ),
                                                      Text(
                                                        element.user_profile ==
                                                                null
                                                            ? ' No data'
                                                            : ' ${element.user_profile!.fullname!}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child:
                                                          FutureBuilder<String>(
                                                    future: _giveawayRepo
                                                        .getTotalEntryCountByUserId(
                                                            element.id,
                                                            _controller.token!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Loading();
                                                      }
                                                      if (snapshot.hasError) {
                                                        printInfo(
                                                            info:
                                                                "getTotalEntryCountByUserId: ${snapshot.hasError}");
                                                        return Container();
                                                      }
                                                      return Text(
                                                        snapshot.data
                                                            .toString(),
                                                        style: style
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                fontSize: 14),
                                                      );
                                                    },
                                                  )),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child:
                                                          FutureBuilder<String>(
                                                    future: _giveawayRepo
                                                        .getReferralsEntryCountByUserId(
                                                            element.id,
                                                            _controller.token!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Loading();
                                                      }
                                                      if (snapshot.hasError) {
                                                        printInfo(
                                                            info:
                                                                "getReferralsEntryCountByUserId: ${snapshot.hasError}");
                                                        return Container();
                                                      }
                                                      return Text(
                                                        //TODO
                                                        '1',
                                                        // snapshot.data
                                                        //     .toString(),
                                                        style: style
                                                            .headlineSmall
                                                            ?.copyWith(
                                                                fontSize: 14),
                                                      );
                                                    },
                                                  )),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: FutureBuilder<bool>(
                                                      future:
                                                          _reelRepo.isActive(
                                                              element.id,
                                                              _controller
                                                                  .token!),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const Loading();
                                                        }
                                                        if (snapshot.hasError) {
                                                          printInfo(
                                                              info:
                                                                  "isActive: ${snapshot.hasError}");
                                                          return Container();
                                                        }
                                                        return CircleAvatar(
                                                          backgroundColor:
                                                              snapshot.data!
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          radius: (8.0),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  FutureBuilder<bool>(
                                                    future: _reelRepo.isActive(
                                                        element.id,
                                                        _controller.token!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Loading();
                                                      }
                                                      if (snapshot.hasError) {
                                                        printInfo(
                                                            info:
                                                                "isActive: ${snapshot.hasError}");
                                                        return Container();
                                                      }
                                                      return snapshot.data!
                                                          ? Container(
                                                              child:
                                                                  disabledPokeButton(),
                                                            )
                                                          : InkWell(
                                                              child: pokebtn(),
                                                              onTap: () {
                                                                _notificationRepo
                                                                    .pokeSingleUser(
                                                                        _controller
                                                                            .token!,
                                                                        element
                                                                            .id);
                                                              },
                                                            );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )
                                      .toList(),
                                )
                              : SizedBox()
                        ],
                      )),
                ),
                _controller.referrals.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: Get.width * 1,
                          child: MyElevatedButton(
                            buttonText: "Poke Inactive Users",
                            onPressed: () {
                              _notificationRepo
                                  .pokeAllInactiveUser(_controller.token!);
                            },
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget pokebtn() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: AppColors.pokeGradiantColor,
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
        )),
    child: Icon(Icons.arrow_right),
    // const Center(child: Text("Poke")),
    width: Get.width * 0.15,
    height: Get.height * 0.04,
  );
}

Widget disabledPokeButton() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: AppColors.pokeDisabledGradiantColor,
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
        )),
    child: const Center(
      child: Icon(
        Icons.arrow_right,
        color: Colors.grey,
      ),
      // child: Text("Poke", style: TextStyle(color: Colors.grey)),
    ),
    width: Get.width * 0.15,
    height: Get.height * 0.04,
  );
}
