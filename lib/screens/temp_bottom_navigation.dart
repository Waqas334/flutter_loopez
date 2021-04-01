import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/screens/my_account.dart';
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';
import 'package:flutter_loopez/screens/user_setting_screen.dart';

class LandingPage extends StatefulWidget {
  static String name = '/landingPage';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class PlaceHolderWidget extends StatelessWidget {
  String title;

  PlaceHolderWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceHolderWidget(title: 'Home'),
    PlaceHolderWidget(title: 'Chats'),
    PlaceHolderWidget(title: 'Sell'),
    PlaceHolderWidget(title: 'Ads'),
    MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
