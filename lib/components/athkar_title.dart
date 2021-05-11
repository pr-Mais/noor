import 'package:flutter/material.dart';

class ThekrTitleCard extends StatelessWidget {
  ThekrTitleCard({this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                margin: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10.0,
                  bottom: 10.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 95,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    right: 70,
                    left: 70,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                ),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/titleBackground.png',
                      ),
                    )),
              ),
            ),
            Positioned(
              child: Image.asset(
                'assets/titleLeaf.png',
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
