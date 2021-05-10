import 'package:flutter/material.dart';

const double kButtonCornerRadius = 6;

//Below are the keys for firestore
const String kUsers = 'users';
const String kUid = 'uid';
const String kSomethingAboutYou = 'something_about_you';
const String kPhoneNumber = 'phone_number';
const String kEmailAddress = 'email';
const String kIsPhoneNumberVerified = 'is_phone_number_verified';
const String kFavoriteAds = 'favorite_ads';
const String kMyAds = 'my_ads';

//Following are to for the path in Firestore
const String kAds = 'ads';
const String kCategories = 'categories';
const String kLocations = 'locations';

const String kUnknownState = 'unknown_state';
const String kUnknownCity = 'unknown_city';

const kTextStyleClickable = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.underline,
);

const kTextStyleHeadline =
    TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold);

const kTextStyleButton =
    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);

const kTextStyleSubheading =
    TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);

const Map<String, List<String>> mapCategories = {
  'Laptops': [
    'Laptops',
    'Laptop Bags',
    'Laptop Charger',
    'Laptop Battery',
    'Laptop Stand'
  ],
  'Casings': [],
  'Storage': [
    'SSD',
    'HDD',
    'USB',
    'External Storage',
  ],
  'CPU': [],
  'GPU': [],
  'RAM': [],
  'Monitor': [],
  'Keyboard': [],
  'Mouse': [],
  'Headphones': [],
  'Speakers': [],
};
const List<String> kTopLaptopCompanies = [
  'Apple',
  'HP',
  'Lenovo',
  'Dell',
  'Acer',
  'Asus',
  'MSI',
  'Razer',
  'Samsung',
  'Other'
];
