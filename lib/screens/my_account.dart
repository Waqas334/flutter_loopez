import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/components/ad_item.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/model/ad.dart';
import 'package:flutter_loopez/model/ads.dart';
import 'package:flutter_loopez/model/new_user_model.dart';

import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';
import 'package:flutter_loopez/screens/user_setting_screen.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    NewUserModel userModel = Provider.of<NewUserModel>(context);
    Ads adsProvider = Provider.of<Ads>(context);
    print('User model in my account ${userModel}');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: currentUser.isAnonymous
                        ? AssetImage('assets/user/man.png')
                        : currentUser.photoURL != null
                            ? NetworkImage(currentUser.photoURL)
                            : AssetImage('assets/user/man.png'),
                  ),
                ),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (currentUser.isAnonymous)
                              ? 'LOG IN'
                              : (currentUser.displayName == null ||
                                      currentUser.displayName.length == 0)
                                  ? 'DISPLAY NAME HERE'
                                  : currentUser.displayName,
                          style: kTextStyleHeadline,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (currentUser.isAnonymous)
                              return _logInClicked(context);
                            return _viewAndEditProfileClicked(context);
                          },
                          child: Text(
                            (currentUser.isAnonymous)
                                ? 'Log in to your account'
                                : 'View and edit profile',
                            style: kTextStyleClickable,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            //Add some shimmer/dummy cards here
            SizedBox(
              height: 30,
            ),
            // if (!currentUser.isAnonymous)
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Your Ads',
                    style: kTextStyleSubheading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(kUsers)
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (context, documentSnapshot) {
                          if (documentSnapshot.hasError ||
                              documentSnapshot.data == null) {
                            return Container(
                              child: Center(
                                child: Text(
                                    'Something went wrong with fetching: ${documentSnapshot.error.toString()}'),
                              ),
                            );
                          } else {
                            var myAds;
                            try {
                              myAds = documentSnapshot.data?.data();
                              return ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, count) {
                                  return FutureBuilder(
                                    builder: (context, ad) =>
                                        AdItem(ad: ad.data),
                                    future: adsProvider
                                        .findAdByIdFromFirestore(myAds[count]),
                                  );
                                },
                                itemCount: myAds.length,
                              );
                            } catch (e) {
                              print(
                                  'Something went wrong with fetching my ads: $e');
                              return Container();
                            }
                          }
                        },
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _viewAndEditProfileClicked(BuildContext context) {
    // Navigator.pushNamed(context, UserSetting.name);
    // print('View and edit profile clicked');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserSetting();
    }));
  }

  void _logInClicked(context) {
    Navigator.pushNamed(context, SignUpScreen.name);
  }
}
