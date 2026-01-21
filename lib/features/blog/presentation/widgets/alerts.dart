// Source - https://stackoverflow.com/a/53844053
// Posted by Suragch, modified by community. See post 'Timeline' for change history
// Retrieved 2026-01-21, License - CC BY-SA 4.0

import 'package:caco_flutter_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog();
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop(alert);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.of(context, rootNavigator: true).pop(alert);
      context.read<AuthBloc>().add(AuthSignOut());
    },
  );

  // set up the AlertDialog
  alert = AlertDialog(
    title: Text("Log Out"),
    content: Text("Are you sure you want to sign out?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

