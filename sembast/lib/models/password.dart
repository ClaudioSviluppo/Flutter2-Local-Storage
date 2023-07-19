class Password {
  int? id;
  late String name;
  late String password;

  //Unnamed constructot
  Password(this.name, this.password);

  //Transform password Object in a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

  //Transform map in Password Object
  Password.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    password = map['password'];
  }
}
