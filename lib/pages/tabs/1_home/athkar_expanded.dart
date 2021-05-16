import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:noor/exports/models.dart' show DataModel, Thekr;
import 'package:noor/exports/controllers.dart' show SettingsModel;
import 'package:noor/exports/components.dart'
    show NoorCloseButton, ThekrTitleCard, AthkarCard;

class AthkarList extends StatefulWidget {
  const AthkarList({Key? key, this.index}) : super(key: key);
  final int? index;
  _AthkarListState createState() => _AthkarListState();
}

class _AthkarListState extends State<AthkarList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ItemScrollController? controller;
  ItemPositionsListener listener = ItemPositionsListener.create();
  Animation<double>? animation;
  late AnimationController animationController;
  int pagePosition = 0;

  @override
  get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticIn));
    controller = new ItemScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      listener.itemPositions.addListener(changeAppBar);
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  changeAppBar() {
    if (pagePosition != listener.itemPositions.value.first.index) {
      setState(() {
        pagePosition = listener.itemPositions.value.first.index - 1;
      });
    }
  }

  onCardTap(int index, Counter counter) {
    final SettingsModel settings = context.read<SettingsModel>();

    counter.decrement();
    if (settings.vibrate) {
      switch (settings.vibrationClick) {
        case 'light':
          HapticFeedback.heavyImpact();
          break;
        case 'strong':
          HapticFeedback.lightImpact();
          break;
        default:
          return;
      }
    }

    if (index < 422 && settings.autoJump && counter._counter == 0) {
      Future<void>.delayed(Duration(milliseconds: 500)).then(
        (_) {
          controller!.scrollTo(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              index: index + 1);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 45),
                  Consumer<DataModel>(
                    builder: (BuildContext context, DataModel model, _) {
                      return AnimatedSwitcher(
                        child: Text(
                          model.athkar[pagePosition + 2].sectionName,
                          textAlign: TextAlign.center,
                          key: ValueKey<String?>(
                              model.athkar[pagePosition + 2].sectionName),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                  ),
                  NoorCloseButton(color: Theme.of(context).accentColor),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<DataModel>(
              builder: (_, DataModel model, __) {
                //get only the atkar from the whole list!
                List<Thekr> athkar = model.athkar;

                final List<Counter> counterList = athkar
                    .map((Thekr thekr) => Counter(thekr.counter))
                    .toList();

                return Provider<List<Counter>>(
                  create: (_) => counterList,
                  child: Consumer<List<Counter>>(
                    builder: (_, List<Counter> countersList, __) {
                      return Scrollbar(
                        child: ScrollablePositionedList.builder(
                          key: ValueKey<String>('list'),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemScrollController: controller,
                          itemPositionsListener: listener,
                          itemCount: athkar.length,
                          addAutomaticKeepAlives: true,
                          initialScrollIndex: widget.index!,
                          minCacheExtent: 900,
                          padding: EdgeInsets.only(bottom: 20),
                          itemBuilder: (_, int index) {
                            final Thekr thekr = athkar[index];
                            if (thekr.isTitle) {
                              return ThekrTitleCard(title: thekr.text);
                            } else {
                              return ChangeNotifierProvider<Counter>.value(
                                value: countersList[index],
                                child: Consumer<Counter>(
                                  builder: (_, Counter counter, __) =>
                                      AthkarCard(
                                    key: ValueKey<int>(index),
                                    thekr: thekr,
                                    onTap: () => onCardTap(index, counter),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class PersistedCard extends StatefulWidget {
  const PersistedCard({
    Key? key,
    required this.thekr,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  final Thekr thekr;
  final Function onTap;
  final int index;

  @override
  _PersistedCardState createState() => _PersistedCardState();
}

class _PersistedCardState extends State<PersistedCard>
    with AutomaticKeepAliveClientMixin {
  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AthkarCard(
      key: PageStorageKey<int?>(widget.index),
      thekr: widget.thekr,
      onTap: widget.onTap,
    );
  }
}

class Counter with ChangeNotifier {
  int _counter;
  Counter(this._counter);

  int get getCounter => _counter;

  void decrement() {
    _counter--;

    notifyListeners();
  }
}
