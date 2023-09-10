import 'package:flutter/material.dart';

alertSheet(context,
    {bool addChannel = false,
    String title = "",
    required List<dynamic> items,
    // ignore: use_function_type_syntax_for_parameters
    required onTap(value)}) {
  List<Widget> actions = [];

  for (var value in items) {
    {
      actions.add(
        Align(
          alignment: Alignment.center,
          child: TextButton(
            child: Text(
              addChannel ? value.titleEN : value,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            onPressed: () {
              onTap(value);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  actions.add(Align(
    alignment: Alignment.center,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        // minimumSize: MediaQuery.of(context).size.width,
        elevation: 20,
        shape: const StadiumBorder(),
        primary: Theme.of(context).canvasColor,
      ),

      // minWidth: MediaQuery.of(context).size.width,
      child: Text(
        'Cancel',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  ));

  showDialog(
    context: context,
    builder: (_) => SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).canvasColor,
        actions: actions,
      ),
    ),
  );
}
