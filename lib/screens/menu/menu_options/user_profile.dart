import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  PickedFile _image;

  Future<PickedFile> chooseFile() async {
    return ImagePicker().getImage(source: ImageSource.gallery);
  }

  Future uploadImage(BookingUser user) async {
    Reference storageReference = FirebaseStorage.instance.ref()
        .child('user_data/${user.firstName + user.lastName + user.uid}');
    await storageReference.putFile(File(_image.path)); // Convert to regular File type from PickedFile
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) async {
      // Technically don't need to update the user every time as the link won't change for
      // each user. However, might change this later so we store previous user images too.
      // Also forces refresh of data on page
      user.imageUrl = fileURL;
      await UserService().updateUserData(user);

      print('Uploaded to $fileURL}');
    });
  }

  String _getUserRole(int isAdminVal) {
    switch (isAdminVal) {
      case 0:
        {
          return 'Patient';
        }
      case 1:
        {
          return 'Doctor';
        }
      case 2:
        {
          return 'Super Admin';
        }
      default:
        {
          return 'Undefined Role';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<BookingUser>();

    return StreamBuilder<BookingUser>(
      stream: UserService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          BookingUser user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text("${user.firstName}'s Profile"),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 130.0,
                      width: 130.0,
                      child: Stack(
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundImage: user.imageUrl != null ? NetworkImage(user.imageUrl) : AssetImage('assets/default_user_pic.png'),
                              radius: 60.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                _image = await chooseFile();
                                uploadImage(user);
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.edit),
                                radius: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 90.0,
                    color: Colors.grey[800],
                  ),
                  Text(
                    'NAME',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Account Type',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _getUserRole(user.isAdmin),
                    style: TextStyle(
                        color: Colors.deepPurple,
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${user.email}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
