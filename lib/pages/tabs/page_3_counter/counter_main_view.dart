import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noor/exports/constants.dart';
import 'package:noor/exports/controllers.dart' show AppSettings, ThemeModel;
import 'package:noor/exports/models.dart';
import 'package:noor/utils/to_color_filter.dart';
import 'package:provider/provider.dart';

import 'counter_list_view.dart';

class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  void incrementCounter() {
    final settings = context.read<AppSettings>();
    final counterModel = context.read<CounterViewModel>();

    counterModel.incrementSelectedItem();

    if (settings.vibrateCounter) {
      if (counterModel.selectedItem!.counter % 100 == 0) {
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

  /// Push the [CounterListView] view.
  void navigateToCounterList() {
    Navigator.of(context).push(
      MaterialPageRoute<CounterListView>(
        builder: (_) => const CounterListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterModel = context.watch<CounterViewModel>();
    final settings = context.watch<AppSettings>();

    return Scaffold(
      body: GestureDetector(
        onTap: incrementCounter,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                context.read<ThemeModel>().images.subhaBg,
              ),
            ),
          ),
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(viewPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      NoorIconButton(
                        icon: NoorIcons.subhaList,
                        onPressed: navigateToCounterList,
                      ),
                      NoorIconButton(
                        icon: NoorIcons.subhaReset,
                        onPressed: counterModel.resetSelectedItemCounter,
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned.fill(
                      top: MediaQuery.of(context).size.height * .18,
                      bottom: MediaQuery.of(context).size.height * .5,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: viewPadding * 2),
                        child: Text(
                          counterModel.selectedItem?.key ?? '',
                          key: ValueKey<int>(
                            counterModel.selectedItem?.counter ?? 0,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(settings.fontSize),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: settings.fontType,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        '${counterModel.selectedItem!.counter}',
                        key: ValueKey<int>(counterModel.selectedItem!.counter),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                        textScaler: TextScaler.linear(settings.fontSize),
                      ),
                    ),
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
                        colorFilter: Colors.white.toColorFilter(),
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
