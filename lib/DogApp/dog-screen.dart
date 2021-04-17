import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'dog_db.dart';
import 'dog_details_screen.dart';
import 'dog_model.dart';


class DogList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DogListState();
  }
}

class DogListState extends State<DogList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Dog> DogList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (DogList == null) {
      DogList = List<Dog>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dogs'),
      ),

      body: getDogListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Dog(''), 'Add Dog');
        },
        tooltip: 'Add Dog',
        child: Icon(Icons.add),

      ),
    );
  }

  ListView getDogListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellowAccent,
              child: Text("Id: "+ this.DogList[position].id.toString(), style: titleStyle,),
            ),


            title: Text("Name: "+ this.DogList[position].name, style: titleStyle,),
            subtitle: Text("Age: " + this.DogList[position].age.toString(), style: titleStyle,),
            trailing: Column(
              children : [
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red,),
                  onTap: () {
                    _delete(context, DogList[position]);
                  },
                ),
                GestureDetector(
                  child: Icon(Icons.edit, color: Colors.green,),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToDetail(this.DogList[position],'Edit Dog');
                  },
                ),
              ]
            ),
          ),
        );
      },
    );
  }


  void _delete(BuildContext context, Dog Dog) async {

    int result = await databaseHelper.deleteDog(Dog.id);
    if (result != 0) {
      _showSnackBar(context, 'Dog Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Dog Dog, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DogDetail (Dog, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Dog>> DogListFuture = databaseHelper.getDogList();
      DogListFuture.then((DogList) {
        setState(() {
          this.DogList = DogList;
          this.count = DogList.length;
        });
      });
    });
  }
}


