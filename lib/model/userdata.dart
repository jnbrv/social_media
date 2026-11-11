import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'friend.dart';
import 'usercomment.dart';
import 'userpost.dart';

class Userdata {
  Userdata({String? displayName, String? email})
    : myUserAccount = Account(
        name: displayName ?? 'BRAVO',
        email: email ?? 'student@example.com',
        img: 'assets/person5.jpg',
        numFollowers: '1 Million',
        numPosts: '350',
        numFollowing: '500',
        numFriends: '6',
      );

  final Account myUserAccount;
  final List<Userpost> userList = [
    Userpost(
      id: 'post_1',
      userimg: 'assets/person1.jpg',
      username: 'John Doe',
      time: '2 hrs ago',
      postcontent: 'Had a great day at the beach!',
      postimg: 'assets/post1.jpg',
      numshare: '5',
      isLiked: false,
      comments: [
        Usercomment(
          commenterImg: 'assets/person2.jpg',
          commenterName: 'Jane Smith',
          commentTime: '1 hr ago',
          commentContent: 'Looks fun!',
        ),
        Usercomment(
          commenterImg: 'assets/person3.jpg',
          commenterName: 'Mike Johnson',
          commentTime: '30 mins ago',
          commentContent: 'Wish I was there!',
        ),
      ],
    ),
    Userpost(
      id: 'post_2',
      userimg: 'assets/person4.jpg',
      username: 'Jane Smith',
      time: '3 hrs ago',
      postcontent: 'Loving the Beach!',
      postimg: 'assets/post2.jpg',
      numshare: '3',
      isLiked: false,
    ),
    Userpost(
      id: 'post_3',
      userimg: 'assets/person3.jpg',
      username: 'Mike Johnson',
      time: '5 hrs ago',
      postcontent: 'Happy Birthday to my sister!',
      postimg: 'assets/post3.jpg',
      numshare: '7',
      isLiked: false,
    ),
  ];

  final List<Friend> friendList = const [
    Friend(img: 'assets/person1.jpg', name: 'Ethan'),
    Friend(img: 'assets/person2.jpg', name: 'Bob'),
    Friend(img: 'assets/person3.jpg', name: 'Charlie'),
    Friend(img: 'assets/person4.jpg', name: 'Diana'),
    Friend(img: 'assets/person5.jpg', name: 'Alice'),
    Friend(img: 'assets/person6.jpg', name: 'Fiona'),
  ];

  static const String _commentsKey = 'social_media_comments_v1';

  // Restore comments saved on this device.
  Future<void> loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_commentsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final post in userList) {
        final savedList = decoded[post.id];
        if (savedList is List) {
          post.comments
            ..clear()
            ..addAll(
              savedList.map(
                (item) => Usercomment.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              ),
            );
        }
      }
    } catch (_) {
      // Ignore damaged saved data and keep the sample comments.
    }
  }

  // Add a comment to the selected post and save all comments locally.
  Future<void> addComment(Userpost post, Usercomment comment) async {
    post.comments.add(comment);
    final prefs = await SharedPreferences.getInstance();
    final data = <String, dynamic>{
      for (final item in userList)
        item.id: item.comments.map((c) => c.toJson()).toList(),
    };
    await prefs.setString(_commentsKey, jsonEncode(data));
  }
}
