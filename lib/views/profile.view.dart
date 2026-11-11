import 'package:flutter/material.dart';

import '../model/usercomment.dart';
import '../model/userdata.dart';
import '../model/userpost.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.userdata,
    required this.userPost,
  });

  final Userdata userdata;
  final Userpost userPost;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController commentController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitComment() async {
    final message = commentController.text.trim();
    if (message.isEmpty || isSaving) return;

    setState(() => isSaving = true);
    final comment = Usercomment(
      commenterImg: widget.userdata.myUserAccount.img,
      commenterName: widget.userdata.myUserAccount.name,
      commentTime: 'Just now',
      commentContent: message,
    );

    try {
      await widget.userdata.addComment(widget.userPost, comment);
      commentController.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save comment. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.userPost;
    return Scaffold(
      appBar: AppBar(title: const Text('Post and Comments')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(post.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(post.time, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),
                Text(post.postcontent),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    post.postimg,
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: Colors.indigo.shade50,
                      child: const Icon(Icons.image_outlined, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Comments (${post.comments.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (post.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No comments yet. Be the first to comment!'),
                  )
                else
                  ...post.comments.map(
                    (comment) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: ClipOval(
                          child: Image.asset(
                            comment.commenterImg,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Text(comment.commenterName[0].toUpperCase()),
                          ),
                        ),
                      ),
                      title: Text(comment.commenterName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.commentContent),
                          const SizedBox(height: 3),
                          Text(comment.commentTime, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => submitComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: isSaving ? null : submitComment,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
