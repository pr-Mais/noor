import 'package:flutter/material.dart';

class SettingsSubtitle extends StatelessWidget {
  const SettingsSubtitle({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              height: 1,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
        textScaleFactor: 1,
      ),
    );
  }
}
