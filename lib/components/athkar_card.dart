import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noor/exports/models.dart' show AthkarCounter, Thekr;
import 'package:noor/exports/constants.dart' show Ribbon;
import 'package:noor/exports/components.dart'
    show CardTemplate, CardText, CopyAction, FavAction;
import 'package:noor/exports/controllers.dart' show AppSettings;

class AthkarCard extends StatelessWidget {
  const AthkarCard({
    Key? key,
    required this.thekr,
    this.onTap,
  }) : super(key: key);
  final Thekr thekr;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final AthkarCounter counter = context.watch<AthkarCounter>();
    final AppSettings settings = context.watch<AppSettings>();

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: onTap as void Function()?,
          child: CardTemplate(
            actions: <Widget>[
              FavAction(thekr),
              CopyAction(thekr.text),
            ],
            ribbon: Ribbon.ribbon1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: CardText(text: thekr.text),
            ),
          ),
        ),
        ((settings.showCounter) || thekr.counter > 1)
            ? Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: counter.position < 1
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.bounceInOut,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.done,
                            color: Color(0xff58d1ed),
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : const Color(0xff202b54),
                              border: Border.all(
                                  color: const Color(0xff6f86d6), width: 2),
                              borderRadius: BorderRadius.circular(50.0)),
                          width: 45.0,
                          height: 45.0,
                        )
                      : Container(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              '${counter.position}',
                              key: ValueKey<int?>(counter.position),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                height: 1.25,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : const Color(0xff202b54),
                            border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[400]!
                                    : const Color(0xff33477f),
                                width: 2),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          width: 45.0,
                          height: 45.0,
                        ),
                ),
              )
            : Container()
      ],
    );
  }
}
