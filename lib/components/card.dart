import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    @required this.image,
    @required this.page,
    @required this.tag,
  });
  final String image;
  final Widget page;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return page;
      },
      openShape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      tappable: false,
      closedColor: Colors.transparent,
      closedShape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      closedElevation: 0.0,
      openElevation: 0.0,
      transitionDuration: Duration(milliseconds: 400),
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
              )
            ],
          ),
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: GestureDetector(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                borderOnForeground: true,
                clipBehavior: Clip.hardEdge,
                child: Hero(
                  tag: tag,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            onTap: openContainer,
          ),
        );
      },
    );
  }
}
