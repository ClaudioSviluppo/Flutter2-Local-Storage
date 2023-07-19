import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import '../data/dao/password_dao.dart';
import '../data/sembast_db.dart';
import '../models/password.dart';
import 'password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordDetailDialog extends StatefulWidget {
  final Password password;
  final bool isNew;

  const PasswordDetailDialog(this.password, this.isNew, {super.key});

  @override
  _PasswordDetailDialogState createState() => _PasswordDetailDialogState();
}

class _PasswordDetailDialogState extends State<PasswordDetailDialog> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool hidePassword = true;
  PasswordDao dao = PasswordDao();

  @override
  Widget build(BuildContext context) {
    String title = (widget.isNew)
        ? AppLocalizations.of(context)!.insert_password
        : AppLocalizations.of(context)!.edit_password;
    txtName.text = widget.password.name;
    txtPassword.text = widget.password.password;
    return AlertDialog(
      title: Text(title),
      content: Column(
        children: [
          TextField(
            controller: txtName,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.description,
            ),
          ),
          TextField(
            controller: txtPassword,
            obscureText: hidePassword,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.password,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: hidePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.save),
          onPressed: () async {
            widget.password.name = txtName.text;
            widget.password.password = txtPassword.text;
            Database? db = await SembastDatabase.instance.database;
            (widget.isNew)
                ? dao.addPassword(widget.password)
                : dao.updatePassword(widget.password);

            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordsScreen()));
          },
        ),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel)),
      ],
    );
    setState(() {});
  }
}
