import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart'
    show
        LineSettings,
        SettingsCounter,
        Vibration,
        NoorNotifications,
        Appearance,
        Sources,
        About;

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin {
  @override
  get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LineSettings(),
                  SettingsCounter(),
                  Vibration(),
                  NoorNotifications(),
                  Appearance(),
                  Sources(),
                  About(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
