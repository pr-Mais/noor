import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/constants.dart';
import 'package:noor/pages/tabs/3_counter/counter_view_model.dart';
import 'package:noor/pages/tabs/3_counter/counter_list_view.dart';

import 'package:noor/exports/utils.dart' show ToArabicNumbers;
import 'package:noor/exports/controllers.dart' show SettingsModel;

LinearGradient lightModeBG = LinearGradient(
  colors: <Color>[
    Color(0xff5554B0),
    Color(0xff6F86D6),
  ],
  stops: <double>[0.1, 0.9],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

LinearGradient darkModeBG = LinearGradient(
  colors: <Color>[
    Color(0xff161A3A),
    Color(0xff161A3A),
  ],
  stops: <double>[0.7, 0.3],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late CounterModel counterModel;
  @override
  void didChangeDependencies() {
    counterModel = context.watch<CounterModel>();
    super.didChangeDependencies();
  }

  void incrementCounter() {
    final SettingsModel settings = context.read<SettingsModel>();

    counterModel.selectedItem.setCounter = ++counterModel.selectedItem.counter;
    counterModel.setSelectedItem = counterModel.selectedItem;

    if (settings.vibrateCounter) {
      if (counterModel.selectedItem.counter % 100 == 0) {
        switch (settings.vibrationHunderds) {
          case 'strong':
            HapticFeedback.lightImpact();
            break;
          case 'light':
            HapticFeedback.heavyImpact();
            break;
          case 'none':
            break;
          default:
            HapticFeedback.lightImpact();
        }
      } else {
        switch (settings.vibrationClickCounter) {
          case 'strong':
            HapticFeedback.lightImpact();
            break;
          case 'light':
            HapticFeedback.heavyImpact();
            break;
          case 'none':
            break;
          default:
            HapticFeedback.lightImpact();
        }
      }
    }
  }

  void resetCounter() {
    counterModel.selectedItem.setCounter = 0;
    counterModel.setSelectedItem = counterModel.selectedItem;
  }

  void navigateToCounterList() {
    Navigator.of(context).push(
      MaterialPageRoute<CounterListView>(
        builder: (_) => CounterListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: incrementCounter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark
                ? darkModeBG
                : lightModeBG,
          ),
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      NoorIconButton(
                        icon: NoorIcons.subhaList,
                        onPressed: navigateToCounterList,
                      ),
                      NoorIconButton(
                        icon: NoorIcons.subhaReset,
                        onPressed: resetCounter,
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        counterModel.selectedItem.key,
                        key: ValueKey<int>(counterModel.selectedItem.counter),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Text(
                        '${counterModel.selectedItem.counter}'.arabicDigit(),
                        key: ValueKey<int>(counterModel.selectedItem.counter),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoorIconButton extends StatelessWidget {
  const NoorIconButton({
    Key? key,
    this.onPressed,
    this.color = Colors.white,
    required this.icon,
  }) : super(key: key);
  final Function()? onPressed;
  final dynamic icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon is String
                ? icon.contains('png')
                    ? Image.asset(
                        icon,
                        width: 30,
                        height: 30,
                      )
                    : SvgPicture.asset(
                        icon,
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      )
                : Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }
}
