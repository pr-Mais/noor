import 'package:flutter/material.dart';
import 'package:noor/exports/components.dart' show NoorIcons;

class BottomNav extends StatefulWidget {
  BottomNav({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final ValueChanged<int>? onTap;

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(highlightColor: Colors.transparent),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (int index) {
          currentIndex.value = index;
          widget.onTap!(index);
        },
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomItem(
              icon: NoorIcons.leaf,
              text: 'نُور',
              currentIndex: currentIndex,
              index: 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomItem(
              icon: NoorIcons.fav,
              text: 'المفضلة',
              currentIndex: currentIndex,
              index: 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomItem(
              icon: NoorIcons.counter,
              text: 'السبحة',
              currentIndex: currentIndex,
              index: 2,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomItem(
              icon: NoorIcons.settings,
              text: 'الإعدادات',
              currentIndex: currentIndex,
              index: 3,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class BottomItem extends StatefulWidget {
  const BottomItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final int index;
  final ValueNotifier<int> currentIndex;

  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> textOffset1;
  late Animation<Offset> iconOffset1;

  double iconOffset = -0.1;
  double textOffset = 0.0;
  int duration = 1200;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
      reverseDuration: Duration(milliseconds: duration),
    );

    textOffset1 =
        Tween<Offset>(begin: Offset(0.0, textOffset), end: Offset(0.0, 1.0))
            .animate(
      CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
          reverseCurve: Curves.elasticIn),
    );
    iconOffset1 =
        Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, iconOffset))
            .animate(
      CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
          reverseCurve: Curves.elasticIn),
    );

    if (widget.currentIndex.value != widget.index) {
      controller.forward();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.currentIndex.addListener(() {
      if (mounted) {
        if (widget.currentIndex.value == widget.index) {
          controller.reverse();
        } else {
          controller.forward();
        }
      }
    });
    return Tooltip(
      message: widget.text,
      child: SizedBox(
        height: 40,
        child: ClipPath(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: iconOffset1,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      widget.icon,
                      color: Theme.of(context).iconTheme.color,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: textOffset1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.text,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 3.5,
                        height: 3.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
