import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key key,
    this.onTap,
    @required this.image,
    this.height,
    this.width,
  }) : super(key: key);
  final Function() onTap;
  final String image;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      width: width,
      height: height,
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
        child: SizedBox(
          child: InkWell(
            highlightColor: Colors.black.withOpacity(0.1),
            splashColor: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
