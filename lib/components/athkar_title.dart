import 'package:flutter/material.dart';
import 'package:noor/exports/constants.dart' show Images;

class ThekrTitleCard extends StatelessWidget {
  const ThekrTitleCard({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10.0,
                  bottom: 10.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 95,
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    right: 70,
                    left: 70,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                ),
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(Images.titleBg),
                    )),
              ),
            ),
            Positioned(
              child: Image.asset(
                Images.athkarTitleLeaf,
                height: 110.0,
              ),
              bottom: 10.0,
              right: 10.0,
            ),
          ],
        ),
        //content list
      ],
    );
  }
}
