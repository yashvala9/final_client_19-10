import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/app/modules/send_invite/views/send_invite_view.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../controllers/referrals_controller.dart';

class ReferralsView extends GetView<ReferralsController> {
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(ReferralsController());
  @override
  Widget build(BuildContext context) {
    _controller.getReferralList();
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Referrals',
            style: style.titleMedium,
          ),
        ),
        backgroundColor: AppColors.white,
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
                                child: (!snapshot.hasData)
                                    ? const Loading()
                                    : Image.network(
                                        'https://s3.amazonaws.com/babelcube/users/61f7c584d9efd_fault-avatar-profile-icon-vector-social-media-user-image-182145777.jpg',
                                      ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Buddy Pair",
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
                          DataTable(
                            headingRowColor:
                                MaterialStateProperty.all(Color(0xffF6DC9D)),
                            dataRowColor:
                                MaterialStateProperty.all(Color(0xffFFF3D2)),
                            columnSpacing: 10,
                            dataRowHeight: 80,
                            columns: const [
                              DataColumn(
                                label: Text("Name"),
                              ),
                              DataColumn(
                                label: Text("Entries"),
                              ),
                              DataColumn(
                                label: Text("Activity"),
                              ),
                              DataColumn(
                                label: Text("Poke"),
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
                                                  child: Image.asset(
                                                    'assets/Ellipse_1.png',
                                                  ),
                                                ),
                                                const Text(
                                                  "Mike Torello",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                                child: Text(
                                              "2345",
                                              style: style.headlineSmall
                                                  ?.copyWith(fontSize: 14),
                                            )),
                                          ),
                                          DataCell(
                                            Center(
                                              child: activitygreen(),
                                            ),
                                          ),
                                          DataCell(
                                            pokebtn(),
                                          ),
                                        ],
                                      )),
                                )
                                .toList(),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: Get.width * 1,
                    child: MyElevatedButton(
                      buttonText: "Poke Inactive Users",
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget activitygreen() {
  return const CircleAvatar(
    backgroundColor: Colors.green,
    radius: (8.0),
  );
}

Widget activityred() {
  return const CircleAvatar(
    backgroundColor: Colors.red,
    radius: (8.0),
  );
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
    child: const Center(child: Text("Poke")),
    width: Get.width * 0.2,
    height: Get.height * 0.04,
  );
}
