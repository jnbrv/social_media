import 'package:flutter/material.dart';

import '../model/userdata.dart';

class Mainheader extends StatelessWidget {
  const Mainheader({super.key, required this.userdata});

  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    final account = userdata.myUserAccount;
    return Column(
      children: [
        _ProfileAvatar(imagePath: account.img, name: account.name, radius: 48),
        const SizedBox(height: 12),
        Text(
          account.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(account.email, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        const Text(
          'BRAVO ACTIVITY',
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.imagePath,
    required this.name,
    required this.radius,
  });

  final String imagePath;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.indigo.shade100,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              name.isEmpty ? '?' : name.trim()[0].toUpperCase(),
              style: TextStyle(
                fontSize: radius,
                color: Colors.indigo.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
