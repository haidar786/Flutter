import 'package:contacts_service/contacts_service.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:emrals/state_container.dart';

class Contacts extends StatefulWidget {
  @override
  ContactsState createState() {
    return ContactsState();
  }
}

class ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(_appLocalization.inviteContacts),
        ),
        body: FutureBuilder(
          future: ContactsService.getContacts(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Contact> contacts = List.from(snapshot.data)
                // ..sort(
                //   (c1, c2) {
                //     if (c1.displayName != null && c2.displayName != null) {
                //       return c1.displayName.compareTo(c2.displayName);
                //     }
                //   },
                // )
                ..sort((c1, c2) {
                  if (c1.emails.length < c2.emails.length) {
                    return 1;
                  } else if (c1.emails.length > c2.emails.length) {
                    return -1;
                  } else {
                    return 0;
                  }
                });
              return ContactList(contacts: contacts);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class ContactList extends StatelessWidget {
  final List<Contact> contacts;

  ContactList({this.contacts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        Contact contact = contacts[index];
        return ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(contact.displayName),
          leading: CircleAvatar(
            foregroundColor: Colors.white,
            backgroundImage:
                contact.avatar != null ? MemoryImage(contact.avatar) : null,
            child: Text(contact.displayName != null &&
                    contact.displayName.isNotEmpty &&
                    contact.avatar == null
                ? contact.displayName.substring(0, 1)
                : ""),
          ),
          subtitle: contact.emails.isNotEmpty
              ? Text(contact.emails.first.value)
              : null,
          trailing: contact.emails.isNotEmpty
              ? InviteButton(
                  email: contact.emails.first.value,
                  token: StateContainer.of(context).loggedInUser.token,
                )
              : null,
        );
      },
      separatorBuilder: (ctx, index) => Divider(
        height: 0,
        color: Colors.black26,
      ),
      itemCount: contacts.length,
    );
  }
}

class InviteButton extends StatefulWidget {
  final String email;
  final String token;

  InviteButton({this.email, this.token});

  @override
  _InviteButtonState createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton>
    with AutomaticKeepAliveClientMixin<InviteButton> {
  InviteButtonStates state = InviteButtonStates.IDLE;
  Widget icon;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (state == InviteButtonStates.IDLE) {
      icon = Icon(
        Icons.add,
        color: Colors.white,
      );
    } else if (state == InviteButtonStates.FAILED) {
      icon = Icon(
        Icons.error_outline,
        color: Colors.white,
      );
    } else if (state == InviteButtonStates.LOADING) {
      icon = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    } else {
      icon = Icon(
        Icons.done,
        color: Colors.white,
      );
    }
    return FlatButton.icon(
      padding: EdgeInsets.zero,
      color: emralsColor(),
      onPressed: () {
        if (state != InviteButtonStates.INVITED) {
          setState(() {
            state = InviteButtonStates.LOADING;
          });
          RestDatasource().inviteUser(widget.email, widget.token).then((b) {
            setState(() {
              if (b) {
                state = InviteButtonStates.INVITED;
              } else {
                state = InviteButtonStates.FAILED;
              }
            });
          });
        }
      },
      label: Text(
        AppLocalizations.of(context).invite,
        style: TextStyle(color: Colors.white),
      ),
      icon: icon,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum InviteButtonStates { IDLE, LOADING, FAILED, INVITED }
