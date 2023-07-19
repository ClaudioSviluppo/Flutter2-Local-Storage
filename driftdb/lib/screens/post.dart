import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/drift_db.dart';
import '../data/shared_prefs.dart';

import 'package:intl/intl.dart';

import 'post-detail.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  late List<BlogPost> posts;

  @override
  void initState() {
    settings = SPSettings();
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyDatabase blogDb = Provider.of<MyDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        backgroundColor: Color(settingColor),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingColor),
          onPressed: () {
            BlogPost post = BlogPost(id: 0, name: '', content: '', date: null);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post, true)));
          },
          child: const Icon(Icons.add)),
      body: FutureBuilder(
          future: blogDb.getPosts(),
          builder: (context, snapshot) {
            List<BlogPost> posts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                DateFormat formatter = DateFormat('dd/MM/yyyy');
                String postDate = (posts[index].date != null)
                    ? formatter.format(posts[index].date as DateTime)
                    : '';
                return Dismissible(
                    key: Key(posts[index].id.toString()),
                    onDismissed: (direction) {
                      blogDb.deletePost(posts[index]);
                    },
                    child: ListTile(
                      title: Text(posts[index].name),
                      subtitle: Text(postDate),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(posts[index], false)));
                      },
                    ));
              },
            );
          } //End builder,

          ),
    );
  }
}
