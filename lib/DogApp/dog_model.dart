import 'dart:ffi';

class Dog {
   int _id;
  String _name;
  int _age;

  Dog(this._name , [this._age]);

 Dog.withId(this._id, this._name, [this._age]);

  int get id => _id;

  String get name => _name;

  int get age => _age;

  set name(String newName) {
    this._name = newName;
  }
  set age(int newAge) {
    this._age = newAge;
  }

  // Convert a Dog object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['age'] = _age;

    return map;
  }

  // Extract a Dog object from a Map object
  Dog.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._age = map['age'];
  }
}


