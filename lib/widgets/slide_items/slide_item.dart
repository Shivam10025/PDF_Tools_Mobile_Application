import 'package:flutter/cupertino.dart';
import 'package:pdftoolapplicario/model/slider.dart';


class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(sliderArrayList[index].sliderImageUrl))),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: const TextStyle(
            fontFamily: "OpenSans",
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: const TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}