import 'package:flutter/material.dart';
import '../data/dao/password_dao.dart';
import '../data/shared_prefs.dart';
import './password_detail.dart';
import '../models/password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({super.key});

  @override
  _PasswordsScreenState createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  PasswordDao dao = PasswordDao();

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.password_list),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getPasswords(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Password> passwords = snapshot.data ?? [];
          return ListView.builder(
              itemCount: passwords == null ? 0 : passwords.length,
              itemBuilder: (_, index) {
                return Dismissible(
                  key: Key(passwords[index].id.toString()),
                  onDismissed: (_) {
                    dao.deletePassword(passwords[index]);
                  },
                  child: ListTile(
                    title: Text(
                      passwords[index].name,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PasswordDetailDialog(
                                passwords[index], false);
                          });
                    },
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingColor),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return PasswordDetailDialog(Password('', ''), true);
                });
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<List<Password>> getPasswords() async {
    List<Password> passwords = await dao.getPasswords();
    return passwords;
  }
}
