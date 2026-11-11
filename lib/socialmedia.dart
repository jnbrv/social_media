import 'package:flutter/material.dart';

import 'model/userdata.dart';
import 'views/friendlist.dart';
import 'views/infoheader.dart';
import 'views/mainheader.dart';
import 'views/postlist.dart';

class Socialmedia extends StatelessWidget {
  const Socialmedia({super.key, required this.userdata});

  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PisBook'), centerTitle: true),
      // One parent scrollable owns the vertical scrolling for the whole page.
      // Friendlist's GridView is shrink-wrapped and Postlist uses a Column.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Mainheader(userdata: userdata),
          const SizedBox(height: 24),
          Infoheader(userdata: userdata),
          const Divider(height: 32),
          Friendlist(userdata: userdata),
          const Divider(height: 28),
          Postlist(userdata: userdata),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
