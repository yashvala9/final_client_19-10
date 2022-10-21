import 'package:flutter/material.dart';

class ActionsToolbar extends StatelessWidget {
  // Full dimensions of an action
  static const double actionWidgetSize = 60.0;

// The size of the icon showen for Social Actions
  static const double actionIconSize = 35.0;

// The size of the share social icon
  static const double shareActionIconSize = 25.0;

// The size of the profile image in the follow Action
  static const double profileImageSize = 50.0;

// The size of the plus icon under the profile image in follow action
  static const double plusIconSize = 20.0;

  final String numLikes;
  final String numComments;
  final String numEntry;

  const ActionsToolbar(
      {Key? key,
      required this.numLikes,
      required this.numComments,
      required this.numEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _getSocialAction(icon: Icons.card_giftcard, title: numEntry),
        _getSocialAction(icon: Icons.favorite, title: numLikes),
        _getSocialAction(icon: Icons.comment, title: numComments),
        _getSocialAction(icon: Icons.reply, title: 'Share', isShare: true),
        IconButton(
            icon: const Icon(
              Icons.more_horiz,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () {}),
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/cucumia-369c1.appspot.com/o/images%2FMagazines%2F2022-06-17%2015%3A03%3A33.892_2022-06-17%2015%3A03%3A33.893.jpg?alt=media&token=75624798-52a6-4735-a422-092955a6aa3a"),
          ),
        ),
      ]),
    );
  }

  Widget _getSocialAction(
      {required String title, required IconData icon, bool isShare = false}) {
    return Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: Column(children: [
          Icon(icon, size: 35.0, color: Colors.grey[300]),
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0)),
          )
        ]));
  }

  LinearGradient get musicGradient => LinearGradient(colors: [
        Colors.grey[800]!,
        Colors.grey[900]!,
        Colors.grey[900]!,
        Colors.grey[800]!
      ], stops: const [
        0.0,
        0.4,
        0.6,
        1.0
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);
}
