import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            "Notification",
            style: style.titleMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today",
                  style:
                      style.titleLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                NotificationTile(
                  title: "Sabrina Wah",
                  subTile: "Started following you.",
                  traiing: MaterialButton(
                    onPressed: () {},
                    color: colorSchema.primary,
                    shape: const StadiumBorder(),
                    child: const Text("Folow"),
                  ),
                ),
                NotificationTile(
                    title: "Nenek Gahol",
                    subTile:
                        "Commented, nenek masakin lepeut buat cucu tersayang uhuyy",
                    traiing: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
                      ),
                    )),
                NotificationTile(
                  title: "Suami Orangs",
                  subTile: "Skuy atuh rada nonton ayena ka moviplek wkwk :)",
                  traiing: MaterialButton(
                    onPressed: () {},
                    color: colorSchema.primary,
                    shape: const StadiumBorder(),
                    child: const Text("Folow"),
                  ),
                ),
                NotificationTile(
                  title: "Komandan Asep",
                  subTile: "Kumaha cenah eh di read hungkul hm ah slek we",
                  traiing: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Folowing",
                      style: style.titleSmall,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Yesterday",
                    style:
                        style.titleLarge!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                NotificationTile(
                  title: "Sabrina Wah",
                  subTile: "Started following you.",
                  traiing: MaterialButton(
                    onPressed: () {},
                    color: colorSchema.primary,
                    shape: const StadiumBorder(),
                    child: const Text("Folow"),
                  ),
                ),
                NotificationTile(
                    title: "Nenek Gahol",
                    subTile:
                        "Commented, nenek masakin lepeut buat cucu tersayang uhuyy",
                    traiing: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
                      ),
                    )),
                NotificationTile(
                  title: "Suami Orangs",
                  subTile: "Skuy atuh rada nonton ayena ka moviplek wkwk :)",
                  traiing: MaterialButton(
                    onPressed: () {},
                    color: colorSchema.primary,
                    shape: const StadiumBorder(),
                    child: const Text("Folow"),
                  ),
                ),
                NotificationTile(
                  title: "Komandan Asep",
                  subTile: "Kumaha cenah eh di read hungkul hm ah slek we",
                  traiing: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Folowing",
                      style: style.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Widget traiing;
  final String title;
  final String subTile;
  const NotificationTile(
      {Key? key,
      required this.traiing,
      required this.title,
      required this.subTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final colorSchema = theme.colorScheme;
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: colorSchema.primary,
          backgroundImage: const NetworkImage(
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80",
          ),
        ),
        title: Text(
          title,
          style: style.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subTile,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: traiing);
  }
}
