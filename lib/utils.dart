String isValidEmail(String email) {
  RegExp emailExpression = RegExp(
      '^[a-zA-Z0-9.!#\$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$');
  if (email == null || email.length == 0) {
//     setState(() {
    return "Email can\'t be null";
//     });
//     return;
  }

  if (!emailExpression.hasMatch(email)) {
//     setState(() {
    return 'Invalid Email Address';
//     });
//     return;
  }

  //Will return yes if email is valid,
  //Otherwise the above error messages will be sent
  return 'YES';
}
