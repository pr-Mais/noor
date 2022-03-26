import 'package:flutter/material.dart';
import 'package:noor/exports/constants.dart' show Images, viewPadding;

class NameTitleCard extends StatelessWidget {
  const NameTitleCard({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              child: Text(
                title!,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: viewPadding, vertical: 10.0),
              padding: const EdgeInsets.only(
                right: 90,
                left: 90,
                top: 10.0,
                bottom: 10.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: 95,
              alignment: Alignment.center,
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
                ),
              ),
            ),
            Positioned(
              child: Image.asset(
                Images.allahNameTitleLeaf,
                height: 100.0,
              ),
              bottom: 10.0,
              left: 20.0,
            ),
          ],
        ),
        //content list
      ],
    );
  }
}
