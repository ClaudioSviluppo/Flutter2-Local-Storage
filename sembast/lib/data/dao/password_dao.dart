import 'package:sembast/sembast.dart';

import '../../../models/password.dart';
import '../sembast_db.dart';

class PasswordDao {
  var store = intMapStoreFactory.store('password');
  Future<void> insertDummy() async {
    Database? db = await SembastDatabase.instance.database;
    // Our shop store sample data
    var store = intMapStoreFactory.store('shop');

    late int lampKey;
    late int chairKey;
    await db?.transaction((txn) async {
      // Add 2 records
      lampKey = await store.add(txn, {'name': 'Lamp', 'price': 10});
      chairKey = await store.add(txn, {'name': 'Chair', 'price': 15});
    });

// update the price of the lamp record
    await store.record(lampKey).update(db!, {'price': 12});
  }

  Future<int> addPassword(Password password) async {
    Database? db = await SembastDatabase.instance.database;
    int id = await store.add(db!, password.toMap());
    return id;
  }

  Future getPasswords() async {
    Database? db = await SembastDatabase.instance.database;
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final snapshot = await store.find(db!, finder: finder);
    return snapshot.map((item) {
      final pwd = Password.fromMap(item.value);
      pwd.id = item.key;
      return pwd;
    }).toList();
  }

  Future updatePassword(Password pwd) async {
    Database? db = await SembastDatabase.instance.database;
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.update(db!, pwd.toMap(), finder: finder);
  }

  Future deletePassword(Password pwd) async {
    Database? db = await SembastDatabase.instance.database;
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.delete(db!, finder: finder);
  }

  Future deleteAll() async {
    Database? db = await SembastDatabase.instance.database;
    await store.delete(db!);
  }
}
