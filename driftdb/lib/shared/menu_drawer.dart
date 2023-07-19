import 'package:driftdb/screens/post.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
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
      'Drift',
    ];

    List<Widget> menuItems = [];
    menuItems.add(_createDriverHeader());
    for (var element in menuTitles) {
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(element, style: const TextStyle(fontSize: 18)),
        leading: _addIcon(element),
        onTap: () {
          switch (element) {
            case 'Home':
              screen = const PostsScreen();
              break;
            case 'Settings':
              screen = const PostsScreen();
              break;
            case 'Storage':
              screen = const PostsScreen();
              break;
          }
          Navigator.of(context)
              .pop(); //Remove the drawer from the stack (chiude il drawer)
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => screen));
        },
      ));
    }
    return menuItems;
  }
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
    case 'Drift':
      icon = const Icon(Icons.folder);
      break;
  }
  return icon;
}

DrawerHeader _createDriverHeader() {
  return const DrawerHeader(
    decoration: BoxDecoration(color: Colors.blueGrey),
    child:
        Text('Drift App', style: TextStyle(color: Colors.white, fontSize: 28)),
  );
}
  /*
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Page 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}  */
