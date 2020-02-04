import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/localizations.dart';
import 'package:emrals/models/user_profile.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:emrals/screens/settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/state_container.dart';

class ProfileDialog extends StatelessWidget {
  final int id;
  ProfileDialog({this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestDatasource().getUser(id),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }
        UserProfile userProfile = snapshot.data;
        return Dialog(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfilePage(
                userProfile: userProfile,
              )),
        );
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  final UserProfile userProfile;
  ProfilePage({this.userProfile});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formatter = new NumberFormat("#,###");
  static const String urlEndpoint = apiUrl + "/avatarupload/";
  Future<File> future;
  File tmpFile;
  String base64Image;
  String errMessage = 'Error Uploading Image'; // no usage found in any function or widget
  String imageUrl;
  bool isUploading;
  bool isUploaded;
  @override
  void initState() {
    super.initState();
    isUploading = false;
    isUploaded = false;
    imageUrl = widget.userProfile.picture;
  }

  void pickImage(AppLocalizations appLocalization) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(30, 15, 15, 15),
                child: Text(
                  appLocalization.profilePhoto,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            chooseImage(ImageSource.gallery);
                          },
                          elevation: 0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            appLocalization.gallery,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            chooseImage(ImageSource.camera);
                          },
                          elevation: 0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            appLocalization.camera,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void chooseImage(ImageSource imgSource) async {
    tmpFile = await ImagePicker.pickImage(
        source: imgSource, maxWidth: 1000, maxHeight: 1000);
    if (tmpFile == null) {
      setState(() {
        isUploading = false;
        isUploaded = false;
      });
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    base64Image = base64Encode(tmpFile.readAsBytesSync());
    uploadFile(fileName);
  }

  void uploadFile(String fileName) async {
    setState(() {
      isUploading = true;
      isUploaded = false;
    });
    Map<String, String> headers = {
      "Authorization": "token " + StateContainer.of(context).loggedInUser.token,
    };

    http.post(urlEndpoint, headers: headers, body: {
      'image': base64Image,
      'name': fileName,
    }).then((result) {
      var resultJson = json.decode(result.body);
      if (resultJson['code'] == 200) {
        setState(() {
          isUploading = false;
          isUploaded = true;
        });
      }
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    final _appLocalization = AppLocalizations.of(context);
    TextStyle titleStyle = TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54);
    TextStyle valueStyle = TextStyle(fontSize: 24, color: emralsColor());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 25),
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    image: DecorationImage(
                        image: isUploaded
                            ? FileImage(tmpFile)
                            : CachedNetworkImageProvider(
                                imageUrl,
                              ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                  ),
                  child: isUploading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : null),
              widget.userProfile.username ==
                      StateContainer.of(context).loggedInUser.username
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          pickImage(_appLocalization);
                        },
                        mini: true,
                        elevation: 0,
                      ),
                    )
                  : SizedBox(height: 0),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          widget.userProfile.username,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: emralsColor(),
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  _appLocalization.emralsEarned,
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${widget.userProfile.earnedCount.isNotEmpty ? widget.userProfile.earnedCount : 0}")),
                  style: valueStyle,
                ),
                SizedBox(height: 10),
                Text(
                  _appLocalization.reportsPosted,
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${widget.userProfile.alertCount > 0 ? widget.userProfile.alertCount : widget.userProfile.alertCount}")),
                  style: valueStyle,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  _appLocalization.emralsDonated,
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${widget.userProfile.addedCount.isNotEmpty ? widget.userProfile.addedCount : 0}")),
                  style: valueStyle,
                ),
                SizedBox(height: 10),
                Text(
                  _appLocalization.reportsCleaned,
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${widget.userProfile.cleanedCount > 0 ? widget.userProfile.cleanedCount : widget.userProfile.cleanedCount}")),
                  style: valueStyle,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        widget.userProfile.username !=
                StateContainer.of(context).loggedInUser.username
            ? RaisedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: emralsColor(),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              Settings(sendto: widget.userProfile.username)));
                },
                label: Text(
                  _appLocalization.sendEmrals,
                  style: TextStyle(color: emralsColor()),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                      color: Theme.of(context).accentColor, width: 2),
                ),
                color: Colors.white,
              )
            : SizedBox(height: 0),
      ],
    );
  }
}
