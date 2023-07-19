import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/password.dart';
import '../screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MyMenuDrawerState();
}

class _MyMenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero, children: buildMenuItems(context)));
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> menuTitles = [
      'Home',
      'Settings',
      'Storage',
      'Sembast',
    ];

    List<Widget> menuItems = [];
    menuItems.add(_createDriverHeader());

    for (var element in menuTitles) {
      Widget screen = Container();
      if (element == 'Sembast') {
        menuItems.add(_addSembastExspansionTile());
      } else if (element == 'SQLite') {
        //Tolto
        menuItems.add(_addSQLiteExspansionTile());
      } else {
        menuItems.add(ListTile(
          title: Text(element, style: const TextStyle(fontSize: 18)),
          leading: _addIcon(element),
          onTap: () {
            switch (element) {
              case 'Home':
                screen = const HomeScreen();
                break;
              case 'Settings':
                screen = const SettingsScreen();
                break;
              case 'Storage':
                screen = const HomeScreen();
                break;
            }
            Navigator.of(context)
                .pop(); //Remove the drawer from the stack (chiude il drawer)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => screen));
          },
        ));
      }
    }

    return menuItems;
  }

  ExpansionTile _addSembastExspansionTile() {
    return ExpansionTile(
      title: Text(AppLocalizations.of(context)!.sembast),
      subtitle: Text(AppLocalizations.of(context)!.sembastFeatures),
      leading: Image.asset(
        'assets/sembast.png',
        width: 48,
        height: 48,
      ),
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.sembast),
          subtitle: Text(AppLocalizations.of(context)!.pwdManagement),
          onTap: () {
            Navigator.of(context)
                .pop(); //Remove the drawer from the stack (chiude il drawer)

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PasswordsScreen()));
          },
        )
      ],
    );
  }

  ExpansionTile _addSQLiteExspansionTile() {
    return ExpansionTile(
      title: Text(AppLocalizations.of(context)!.sqlite),
      subtitle: Text(AppLocalizations.of(context)!.sqlitedesc),
      leading: Image.asset(
        'assets/sqlite.png',
        width: 48,
        height: 48,
      ),
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.sqlitewithdbhelper),
          subtitle: Text(AppLocalizations.of(context)!.subtitlesqlitewithsql),
          onTap: () {
            Navigator.of(context)
                .pop(); //Remove the drawer from the stack (chiude il drawer)

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PasswordsScreen()));
          },
        )
      ],
    );
  }

  DrawerHeader _createDriverHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: Text(AppLocalizations.of(context)!.appName,
          style: const TextStyle(color: Colors.white, fontSize: 28)),
    );
  }

  Icon _addIcon(String element) {
    Icon icon = const Icon(null);
    switch (element) {
      case 'Home':
        icon = const Icon(Icons.home);
        break;
      case 'Settings':
        icon = const Icon(Icons.settings);
        break;
      case 'Storage':
        icon = const Icon(Icons.folder);
        break;
    }
    return icon;
  }
}
