import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  ContactsState createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Contacts'),
      ),
      body: Center(
        child: Text('contacts'),
      ),
    );
  }
}
