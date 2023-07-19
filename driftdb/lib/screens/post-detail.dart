import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/drift_db.dart';
import '../data/shared_prefs.dart';
import 'post.dart';

class PostDetailScreen extends StatefulWidget {
  final BlogPost post;
  final isNew;

  const PostDetailScreen(this.post, this.isNew, {super.key});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();

  TextEditingController txtName = TextEditingController();
  TextEditingController txtContent = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    txtName.text = widget.post.name;
    txtContent.text = widget.post.content ?? '';
    formatter = DateFormat('dd/MM/yyyy');
    String postDate =
        (widget.post.date != null) ? formatter.format(widget.post.date!) : '';
    txtDate.text = postDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyDatabase blogDb = Provider.of<MyDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog View'),
        backgroundColor: Color(settingColor),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlogText('Name', txtName, fontSize, 1),
          BlogText('Content', txtContent, fontSize, 5),
          BlogText('Date', txtDate, fontSize, 1),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingColor),
          onPressed: () {
            if (widget.isNew) {
              BlogPostsCompanion newPost = BlogPostsCompanion(
                  name: drift.Value(txtName.text),
                  content: drift.Value(txtContent.text),
                  date: (txtDate.text != '')
                      ? drift.Value(formatter.parse(txtDate.text))
                      : const drift.Value(null));
              blogDb.insertPost(newPost);
            } else {
              BlogPost updated = BlogPost(
                  id: widget.post.id,
                  name: (txtName.text),
                  content: (txtContent.text),
                  date: formatter.parse(txtDate.text));
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PostsScreen()));
          },
          child: const Icon(Icons.save)),
    );
  }
}

class BlogText extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final double textSize;
  final int numLines;

  const BlogText(this.description, this.controller, this.textSize, this.numLines, {super.key});

  @override
  Widget build(BuildContext context) {
    TextInputType textInputType;

    if (numLines > 1) {
      textInputType = TextInputType.multiline;
    } else if (description == 'Date') {
      textInputType = TextInputType.datetime;
    } else {
      textInputType = TextInputType.text;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        maxLines: numLines,
        style: TextStyle(
          fontSize: textSize,
        ),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: description),
      ),
    );
  }
}
