import 'dart:async';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'dog_db.dart';
import 'dog_model.dart';

class DogDetail extends StatefulWidget {

  final String appBarTitle;
  final Dog dog;

  DogDetail(this. dog, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return DogDetailState(this.dog, this.appBarTitle);
  }
}

class DogDetailState extends State<DogDetail> {


  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Dog dog;

  TextEditingController IdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  DogDetailState(this.dog, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    nameController.text = dog.name;
    ageController.text = dog.age.toString()=='null'?'':dog.age.toString();

    return WillPopScope(

        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateName();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      //ageController.text =value;
                      updateAge();
                    },
                    decoration: InputDecoration(
                        labelText: 'Age',
                        labelStyle: textStyle,
                     //   hintText:'0',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the name of Dog object
  void updateName(){
    dog.name = nameController.text;
  }

  // Update the age of Dog object
  void updateAge() {
    dog.age = int.parse(ageController.text);
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();
    print(ageController.text);

    int result;
    if (dog.id != null) {  // Case 1: Update operation
      result = await helper.updateDog(dog);
    } else { // Case 2: Insert Operation
      result = await helper.insertDog(dog);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Dog Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Dog');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW Dog i.e. he has come to
    // the detail page by pressing the FAB of DogList page.
    if (dog.id == null) {
      _showAlertDialog('Status', 'No Dog was deleted');
      return;
    }

    // Case 2: User is trying to delete the old Dog that already has a valid ID.
    int result = await helper.deleteDog(dog.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Dog Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Dog');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}

