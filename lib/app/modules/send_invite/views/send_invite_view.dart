import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../../repositories/giveaway_repository.dart';
import '../../../../widgets/loading.dart';
import '../controllers/send_invite_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class SendInviteView extends GetView<SendInviteController> {
  final profile = Get.find<AuthService>().profileModel;
  final _giveawayRepo = Get.put(GiveawayRepository());
  final _controller = Get.put(SendInviteController());
  final FlutterShareMe flutterShareMe = FlutterShareMe();

  SendInviteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return Scaffold(
        backgroundColor: const Color(0xffFFEAB4),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Send Invite',
              style: style.titleMedium,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Frame2.png',
                height: Get.height * 0.4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Invite your friends to ReelRo!",
                  style: style.titleSmall?.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Referring your friends will increase your \nchance to win a contest",
                  style: style.titleMedium?.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: Get.width * 0.9,
                height: Get.height * 0.3,
                decoration: BoxDecoration(
                    color: const Color(0xffFFF3D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Referral Code",
                        style: style.titleSmall?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${profile!.username}@${profile!.id}",
                        style: style.titleMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: Get.height * 0.05,
                        width: Get.width * 0.4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary)),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: "${profile!.username}@${profile!.id}"));
                              showSnackBar(
                                  "Your referral code has been copied to your clipboard!");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.copy),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Copy Link")
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Referral Entries",
                            style: style.headlineSmall?.copyWith(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FutureBuilder<String>(
                            future:
                                _giveawayRepo.getReferralsEntryCountByUserId(
                                    _controller.profileId!, _controller.token!),
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
                                  style: style.titleLarge
                                      ?.copyWith(color: AppColors.red),
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
                        height: Get.height * 0.05,
                        width: Get.width * 0.6,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff3B9B45))),
                            onPressed: () async {
                              await flutterShareMe.shareToWhatsApp(
                                  msg:
                                      "Referral Code : ${profile!.username}@${profile!.id}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.whatsapp,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Invite via Whatsapp",
                                  style: style.titleMedium?.copyWith(
                                      fontSize: 14, color: AppColors.white),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
