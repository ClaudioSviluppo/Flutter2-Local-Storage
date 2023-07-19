import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
part 'drift_db.g.dart';

class BlogPosts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get content => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [BlogPosts])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<BlogPost>> getPosts() => (select(blogPosts)
        ..orderBy([
          (post) => OrderingTerm(expression: post.date, mode: OrderingMode.desc)
        ]))
      .get();

  Future<int> insertPost(BlogPostsCompanion post) =>
      into(blogPosts).insert(post);

  Future<bool> updatePost(BlogPost post) => update(blogPosts).replace(post);

  Future<int> deletePost(BlogPost post) => delete(blogPosts).delete(post);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'posts.db'));
    return NativeDatabase(file);
  });
}
