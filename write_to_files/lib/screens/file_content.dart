import 'package:flutter/material.dart';
import '../data/file_helper.dart';

import 'dart:io' as io;
import 'package:path/path.dart';
import 'files.dart';
import 'package:share/share.dart';

class FileScreen extends StatefulWidget {
  final io.File? file;
  FileScreen(this.file);

  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late FileHelper helper;

  @override
  void initState() {
    helper = FileHelper();
    if (widget.file == null) {
      titleController.text = 'New File';
      contentController.text = '';
    } else {
      titleController.text = basename(widget.file!.path);
      helper
          .readFromFile(widget.file!)
          .then((value) => contentController.text = value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
        backgroundColor: Color(settingColor),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              saveFile();
              Share.shareFiles([widget.file!.path],
                  text: basename(widget.file!.path));
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              controller: contentController,
              style: TextStyle(fontSize: fontSize),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Color(settingColor),
        onPressed: () {
          saveFile();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => FilesScreen()));
        },
      ),
    );
  }

  Future saveFile() async {
    helper.writeToFile(titleController.text, contentController.text);
  }
}
