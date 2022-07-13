import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CommentPanel extends StatelessWidget {
  const CommentPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(
        panel: const Center(
          child: Text("This is the sliding Widget"),
        ),
        body: const Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }
}
