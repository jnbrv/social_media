import 'package:flutter/material.dart';

import '../model/userdata.dart';
import 'profile.view.dart';

class Postlist extends StatefulWidget {
  const Postlist({super.key, required this.userdata});

  final Userdata userdata;

  @override
  State<Postlist> createState() => _PostlistState();
}

class _PostlistState extends State<Postlist> {
  Userdata get userdata => widget.userdata;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // Use a Column here rather than another scrolling ListView.
        ...userdata.userList.map((post) {
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileView(userdata: userdata, userPost: post),
                  ),
                );
                if (mounted) setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _SmallAvatar(path: post.userimg, name: post.username),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(post.time, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_horiz),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(post.postcontent),
                    const SizedBox(height: 10),
                    _PostPhoto(path: post.postimg),
                    const SizedBox(height: 8),
                    Text(
                      '${post.comments.length} comments     ${post.numshare} shares',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const Divider(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => setState(() => post.isLiked = !post.isLiked),
                            icon: Icon(
                              post.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : null,
                            ),
                            label: const Text('Like'),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfileView(userdata: userdata, userPost: post),
                                ),
                              );
                              if (mounted) setState(() {});
                            },
                            icon: const Icon(Icons.comment_outlined),
                            label: const Text('Comment'),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share_outlined),
                            label: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _SmallAvatar extends StatelessWidget {
  const _SmallAvatar({required this.path, required this.name});
  final String path;
  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.indigo.shade100,
      child: ClipOval(
        child: Image.asset(
          path,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Text(name[0].toUpperCase()),
        ),
      ),
    );
  }
}

class _PostPhoto extends StatelessWidget {
  const _PostPhoto({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        path,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 150,
          width: double.infinity,
          color: Colors.indigo.shade50,
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, size: 54, color: Colors.indigo),
        ),
      ),
    );
  }
}
