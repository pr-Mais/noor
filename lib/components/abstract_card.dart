import 'package:flutter/material.dart';
import 'package:noor/constants/ribbons.dart';

class CardTemplate extends StatelessWidget {
  const CardTemplate({
    Key key,
    @required this.ribbon,
    this.actions = const <Widget>[],
    @required this.child,
    this.additionalContent,
    this.actionButton,
  }) : super(key: key);
  final String ribbon;
  final List<Widget> actions;
  final Widget child;
  final Widget additionalContent;
  final Widget actionButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 335,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).brightness == Brightness.light
              ? <Color>[
                  Color(0xfff3f3f3),
                  Color(0xfff1f1f1),
                ]
              : <Color>[
                  Color(0xff1B2349),
                  Color(0xff161A3A),
                ],
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12.0,
          ),
        ],
      ),
      margin: EdgeInsets.only(
        top: 20,
        right: 30,
        left: 30,
        bottom: 20.0,
      ),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: AssetImage(ribbon),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions,
            ),
            height: 35,
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.all(5.0),
              child: Scrollbar(
                controller: ScrollController(),
                radius: Radius.circular(4),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
          if (additionalContent != null)
            Expanded(
              flex: ribbon == Ribbon.ribbon5 ? 3 : 1,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Scrollbar(
                  radius: Radius.circular(4),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: additionalContent,
                    ),
                  ),
                ),
              ),
            ),
          if (actionButton != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: actionButton,
            )
        ],
      ),
    );
  }
}
