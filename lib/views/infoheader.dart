import 'package:flutter/material.dart';

import '../model/userdata.dart';

class Infoheader extends StatelessWidget {
  const Infoheader({super.key, required this.userdata});

  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    final account = userdata.myUserAccount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CountItem(label: 'Followers', value: account.numFollowers),
        _CountItem(label: 'Following', value: account.numFollowing),
        _CountItem(label: 'Posts', value: account.numPosts),
      ],
    );
  }
}

class _CountItem extends StatelessWidget {
  const _CountItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
