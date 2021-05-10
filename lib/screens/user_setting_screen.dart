import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_loopez/components/buttons/responsive_button.dart';
import 'package:flutter_loopez/components/buttons/progress_indicating_button.dart';
import 'package:flutter_loopez/model/new_user_model.dart';
import 'package:flutter_loopez/models/user.dart' as local;
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class UserSetting extends StatelessWidget {
  static var name = '/editProfile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserBody(),
    );
  }
}

class UserBody extends StatefulWidget {
  @override
  _UserBodyState createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  File _image;

  final picker = ImagePicker();

  final userDocReference = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid);

  var saveButtonState = GlobalKey<ResponsiveButtonState>();

  String name;
  String existingName = '';

  String somethingAboutYou = '';
  String existingSomethingAboutYou = '';

  String country = '+92';

  //We need to check if the user signed up via phone-number
  //then get the phone number from Firebase Auth
  //Otherwise get and set it from FireStore
  String phoneNumber = '';
  String existingPhoneNumber = '';
  bool isPhoneNumberVerified = true;
  String _phoneNumberErrorText;

  String emailAddress;

  String profileImageURL;

  User currentUser;
  local.User _user;

  Future _getImage(BuildContext context) async {
    //First we need to check if permission are granted or not

    try {
      //Image picker automatically asks for permission
      //we just need to handle when the user doesn't allow the permission
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _updateSaveButtonState();
        } else {
          print('No image selected.');
        }
      });
    } on PlatformException {
      print('User denied the permission to Access Photos');
      String snackBarTitle;
      if (Platform.isAndroid)
        snackBarTitle =
            'Please enable Storage permission from settings to change profile picture';
      else
        snackBarTitle =
            'Please enable Photos permission from settings to change profile picture';
      final snackBar = SnackBar(
//        backgroundColor: Colors.blueAccent,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(snackBarTitle)),
            TextButton(
              onPressed: () {
                AppSettings.openAppSettings();
              },
              child: Text('Okay!'),
            )
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print('Something went wrong with accessing pictures from gallery');
    }
  }

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    _user = local.User();
    print('InitState Current User: $currentUser');

    _getUserData();
  }

  void _getUserData() async {
    try {
      var documentSnapshot = await userDocReference.get();
      if (documentSnapshot.exists) {
        print('User Document Snapshot: ${documentSnapshot.data()}');
        setState(() {
          existingSomethingAboutYou =
              documentSnapshot?.get(kSomethingAboutYou) ?? '';
          existingPhoneNumber =
              documentSnapshot?.get(kPhoneNumber)?.substring(3) ?? '';
          isPhoneNumberVerified =
              documentSnapshot?.get(kIsPhoneNumberVerified) ?? true;
        });
        print('Document Snapshot exists');
      } else {
        print('Document Snapshot does not exists');
      }
      print('Existing Something About You: $existingSomethingAboutYou');
    } catch (e) {
      print('Something went wrong with fetching the initial data');
    }

//    existingPhoneNumber = currentUser.phoneNumber ?? '';
    phoneNumber = existingPhoneNumber;

    existingName = currentUser.displayName ?? '';
    name = existingName;

    somethingAboutYou = existingSomethingAboutYou;
  }

  @override
  Widget build(BuildContext context) {
    NewUserModel model = Provider.of<NewUserModel>(context);
    print('User model data: ${model.toString()}');

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          print('Somewhere else clicked');
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Basic Information',
                  style: kTextStyleHeadline,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _getImage(context),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
//                          alignment: Alignment.bottomCenter,
                              backgroundImage: (_image != null)
                                  ? FileImage(_image)
                                  : (currentUser.photoURL != null &&
                                          currentUser.photoURL.length != 0)
                                      ? NetworkImage(currentUser.photoURL)
                                      : AssetImage('assets/user/man.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              textInputAction: TextInputAction.next,
//                              onSubmitted: (value) {
//                                TODO Handle Name onSubmitted here
//                                _saveButton.disabledButton(true);
//                              },
                              controller: TextEditingController()
                                ..text = currentUser.displayName,
                              decoration: InputDecoration(labelText: 'Name'),
                              onChanged: (value) {
                                name = value;
                                _updateSaveButtonState();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SomethingAboutYouTextField(
                      text: existingSomethingAboutYou,
                      onChanged: (value) {
                        somethingAboutYou = value;
                        _updateSaveButtonState();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                child: TextField(
//                  decoration: InputDecoration(hintText: 'Something about you'),
//                ),
                ),
                Text(
                  'Contact Information',
                  style: kTextStyleHeadline,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        maxLength: 3,
                        enabled: false,
                        controller: TextEditingController()..text = country,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    Container(
//                          width: MediaQuery.of(context).size.width * 0.70,
                      width: (isPhoneNumberVerified)
                          ? MediaQuery.of(context).size.width * 0.70
                          : (MediaQuery.of(context).size.width * 0.55) - 32,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: TextEditingController()
                          ..text = existingPhoneNumber,
                        maxLength: 10,
//                        enabled: (existingPhoneNumber != null &&
//                                existingPhoneNumber.length > 0)
//                            ? !isPhoneNumberVerified
//                            : true,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          errorText: _phoneNumberErrorText,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                        onChanged: (value) {
                          phoneNumber = value;
                          _updateSaveButtonState();
                        },
                      ),
                    ),
                    !isPhoneNumberVerified
                        ? InkWell(
                            onTap: () => _verifyPhoneNumberClicked(context),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              alignment: Alignment.center,
                              child: Text(
                                'Verify\nNow',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(),
//                    Row(
//                      children: [
//
//                      ],
//                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (!currentUser.emailVerified)
                          ? MediaQuery.of(context).size.width * 0.75
                          : MediaQuery.of(context).size.width - 32,
                      child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: TextEditingController()
                          ..text = currentUser.email,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                    (!currentUser.emailVerified)
                        ? InkWell(
                            onTap: () => _verifyEmailAddress(context),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              alignment: Alignment.center,
                              child: Text(
                                'Verify\nNow',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ResponsiveButton(
                  enabled: false,
                  key: saveButtonState,
                  label: 'Save',
                  onTap: () => _saveClicked(context),
                ),
                SizedBox(
                  height: 10,
                ),
                ResponsiveButton(
                  enabled: true,
                  label: 'Log Out',
                  onTap: () => _logoutClicked(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _checkDuplicatePhoneNumber() async {
    String errorMessage;
    QuerySnapshot snapShot = await userDocReference.parent.get();
    List<QueryDocumentSnapshot> docsList = snapShot.docs;
    print('Doc List: ${docsList.asMap()}');
    for (QueryDocumentSnapshot snapshot in docsList) {
      if (snapshot.id == currentUser.uid) continue;
      var number = snapshot.data()[kPhoneNumber];
      print(
          'Comparing. FireStore Phone Number: ${snapshot.data()[kPhoneNumber]} With Current number: ${'+92' + phoneNumber}');
      if ('+92' + phoneNumber?.trim() == number) {
        print('Number already exists');
        errorMessage = 'Phone number already exists!';
        bool isVerified = snapshot.data()[kIsPhoneNumberVerified];
        if (isVerified) {
          print('Number already verified');
          errorMessage = 'Phone number already verified by someone else.';
        }
//          setState(() {
//            _phoneNumberErrorText = errorMessage;
//          });
        return errorMessage;
        break;
      } else {
        print('Number does not already exists');
      }
    }
    print('After Phone Duplicate check stream');
    return errorMessage;
  }

  _verifyPhoneNumberClicked(BuildContext context) async {
//  We need to check if this phone number is current assigned to someone else or not
    String duplicateCheck = await _checkDuplicatePhoneNumber();
    if (duplicateCheck != null) {
      setState(() {
        _phoneNumberErrorText = duplicateCheck;
      });
      return;
    }
    if (phoneNumber.length > 0) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          var verifyButtonState = GlobalKey<ProgressIndicatingButtonState>();
          return VerifyPhoneNumberBottomSheet(
            verifyButtonState: verifyButtonState,
            phoneNumber: '+11111111111',
            // phoneNumber: '+92'+phoneNumber,
            currentUser: currentUser,
          );
        },
      );
    } else {
      print('Show error message, phone number can\'t be null');
    }
  }

  _updateSaveButtonState() async {
    if (true) {
      print('Existing Name: $existingName\t Current Name: $name');
      print(
          'Existing Something about you: $existingSomethingAboutYou\t Current Something About You: $somethingAboutYou');

      print(
          'Existing Phone Number: $existingPhoneNumber\tNew Phone Number: $phoneNumber');

      if (existingPhoneNumber == '+92' + phoneNumber) {
        print('Both phone numbers are equal');
      } else {
        print('Both phone numbers are not equal');
      }
    }

    if (name != existingName ||
        existingSomethingAboutYou != somethingAboutYou ||
        existingPhoneNumber != phoneNumber ||
        await _image?.exists()) {
      saveButtonState.currentState.enableButton();
    } else {
      saveButtonState.currentState.disableButton();
    }
    return;
  }

  _logoutClicked(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, SignUpScreen.name, (_) => false);
  }

  _verifyEmailAddress(BuildContext context) async {
    //TODO Add open link in App via: https://firebase.flutter.dev/docs/auth/usage/#open-link-in-app

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Sending email'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Please wait'),
            ],
          ),
        );
      },
    );

    await currentUser.sendEmailVerification();

    Navigator.pop(context);
  }

  _saveClicked(BuildContext context) async {
    if (!saveButtonState.currentState.isEnabled) {
      print('You are clicking a disabled button');
      return;
    }

    String dialogStatus = "Please wait";
    showDialog(
        //TODO Update progress status in dialog on runtime
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Updating Profile'),
            content: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text(dialogStatus),
                  ],
                );
              },
            ),
          );
        },
        context: context);

    //Updating Phone Number

    String duplicateCheck = await _checkDuplicatePhoneNumber();
    print('DuplicateCheck: $duplicateCheck');
    if (duplicateCheck != null) {
      //Number already exists
      setState(() {
        _phoneNumberErrorText = duplicateCheck;
        existingPhoneNumber = phoneNumber;
      });

      Navigator.pop(context);
      return;
    } else {
      _phoneNumberErrorText = null;
    }

    _user.phoneNumber = (existingPhoneNumber != phoneNumber)
        ? phoneNumber
        : existingPhoneNumber;

    //If there is something new in something about you, set it first
    _user.someThingAboutYou = (somethingAboutYou != existingSomethingAboutYou &&
            somethingAboutYou.length != 0)
        ? somethingAboutYou
        : existingSomethingAboutYou;
    var photoURL;
    //uploading profile photo
    if (_image != null && await _image.exists()) {
      //TODO QUICK FIX: shorten the following reference
      var userStorageReference = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(currentUser.uid)
          .child('profile_pic_of_${currentUser.uid}');
      try {
        var uploadTask = await userStorageReference.putFile(_image);
        photoURL = await uploadTask.ref.getDownloadURL();
        print('Image uploaded at: ${photoURL}');
      } catch (e) {
        print('Something went wrong with uploading image: $e');
      }
    }
    try {
      await currentUser.updateProfile(displayName: name, photoURL: photoURL);
      await userDocReference.set(_user.userAsMap());
      print('User updated successfully');
      existingPhoneNumber = _user.phoneNumber;
      existingSomethingAboutYou = _user.someThingAboutYou;
      _updateSaveButtonState();
    } catch (e) {
      print('Something went wrong with Profile: $e');
    }
    Navigator.pop(context);
    saveButtonState.currentState.disableButton();
  }
}

class SomethingAboutYouTextField extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function onChanged;
  final String labelText;
  SomethingAboutYouTextField(
      {this.text,
      this.enabled: true,
      this.onChanged,
      this.labelText: 'Something about you'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = text,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText),
      maxLength: 140,
    );
  }
}

class VerifyPhoneNumberBottomSheet extends StatefulWidget {
  @override
  _VerifyPhoneNumberBottomSheetState createState() =>
      _VerifyPhoneNumberBottomSheetState();
  final verifyButtonState;
  final phoneNumber;
  final User currentUser;

  VerifyPhoneNumberBottomSheet(
      {this.verifyButtonState, this.phoneNumber, this.currentUser});
}

class _VerifyPhoneNumberBottomSheetState
    extends State<VerifyPhoneNumberBottomSheet> {
  bool isCodeSent = false;
  String smsCode;
  String _verificationId;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    print("Verifying following phone Number: ${widget.phoneNumber}");
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Verify Phone Number',
                style: kTextStyleHeadline,
              ),
              SizedBox(height: 30),
              isCodeSent
                  ? TextField(
                      onChanged: (value) {
                        smsCode = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      'We need to verify the phone number you provided by sending a verification code.\n\nWould you like to verify now?'),
              (errorMessage != null && errorMessage.length != 0)
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          errorMessage,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 30),
              ProgressIndicatingButton(
                key: widget.verifyButtonState,
                title: 'Verify Now',
                onTap: () async {
                  widget.verifyButtonState.currentState.setProgressState();
                  if (!isCodeSent) {
                    //Code is not sent yet, we have to send the code first

                    FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: widget.phoneNumber,
                        verificationCompleted:
                            (PhoneAuthCredential phoneAuthCredential) {
                          print(
                              'Verification Completed: ${phoneAuthCredential.asMap()}');
                        },
                        verificationFailed: (FirebaseAuthException error) {
                          print('Verification Failed: ${error.message}');
                          widget.verifyButtonState.currentState.setErrorState();
                          setState(() {
                            errorMessage = error.message;
                          });
                        },
                        codeSent:
                            (String verificationId, int forceResendingToken) {
                          _verificationId = verificationId;
                          widget.verifyButtonState.currentState.setDoneState();
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {
                              isCodeSent = true;
                              widget.verifyButtonState.currentState
                                  .setNormalState();
                            });
                          });
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
//                          widget.verifyButtonState.currentState.setDoneState();
                          print('codeAutoRetrievalTimeout');
                        });
                  } else {
                    print('Verification ID: $_verificationId');
                    var auth = PhoneAuthProvider.credential(
                        verificationId: _verificationId, smsCode: '123456');

                    print('Auth: $auth');

                    try {
                      await widget.currentUser.updatePhoneNumber(auth);
                      widget.verifyButtonState.currentState.setDoneState();
                    } on FirebaseAuthException catch (e) {
                      print('FirebaseAuthException was caught: ${e.message}');
                      print('Verification Failed: ${e.message}');
                      widget.verifyButtonState.currentState.setErrorState();
                      setState(() {
                        errorMessage = e.message;
                      });
                    } catch (e) {
                      widget.verifyButtonState.currentState.setErrorState();
                      print(
                          'Something went wrong with the update phone number: ${e}');
                    }
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
