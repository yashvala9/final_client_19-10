import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/widgets/my_elevated_button.dart';

import '../controllers/referrals_controller.dart';

class ReferralsView extends GetView<ReferralsController> {
  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            child: Image.asset(
                              'assets/Ellipse_3.png',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Buddy Pair",
                              style: style.titleMedium?.copyWith(fontSize: 14),
                            ),
                            Text(
                              "Catherine Treesa",
                              style: style.titleSmall?.copyWith(fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
                                    horizontal: 30, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Referral Entries",
                                      style: style.headlineSmall
                                          ?.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                      "210",
                                      style: style.titleLarge
                                          ?.copyWith(color: AppColors.red),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: Get.width * 0.29,
                                  height: Get.height * 0.04,
                                  child: MyElevatedButton(
                                    buttonText: "Send Invite",
                                    onPressed: () {},
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
                            columnSpacing: 22,
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
                            rows: [
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_1.png',
                                          ),
                                        ),
                                        const Text("Mike Torello"),
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
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_2.png',
                                          ),
                                        ),
                                        const Text("Dori Doreau"),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "4323",
                                        style: style.headlineSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: activityred(),
                                    ),
                                  ),
                                  DataCell(
                                    pokebtn(),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_1.png',
                                          ),
                                        ),
                                        const Text("Mike Torello"),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "2345",
                                        style: style.headlineSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
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
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_2.png',
                                          ),
                                        ),
                                        const Text("Dori Doreau"),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "4323",
                                        style: style.headlineSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: activityred(),
                                    ),
                                  ),
                                  DataCell(
                                    pokebtn(),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_1.png',
                                          ),
                                        ),
                                        const Text("Mike Torello"),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "2345",
                                        style: style.headlineSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
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
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_2.png',
                                          ),
                                        ),
                                        const Text("Dori Doreau"),
                                      ],
                                    ),
                                  ),
                                   DataCell(
                                    Center(
                                      child: Text("4323",style: style.headlineSmall?.copyWith(fontSize: 14),),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: activityred(),
                                    ),
                                  ),
                                  DataCell(
                                    pokebtn(),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          child: Image.asset(
                                            'assets/Ellipse_1.png',
                                          ),
                                        ),
                                        const Text("Mike Torello"),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        "2345",
                                        style: style.headlineSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
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
                              ),
                            ],
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
