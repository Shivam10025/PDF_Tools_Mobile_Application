import 'package:flutter/cupertino.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {required this.sliderImageUrl,
        required this.sliderHeading,
        required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/images/slider_1.png',
      sliderHeading: "Scan",
      sliderSubHeading: "Turn any document into pdf"),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: "Share",
      sliderSubHeading: "Share your document anywhere"),
  Slider(
      sliderImageUrl: 'assets/images/slider_3.png',
      sliderHeading: "PDF Tools",
      sliderSubHeading: "Convert your pdf to word compress your pdf size and many more features"),
  Slider(
      sliderImageUrl: 'assets/images/slider_4.png',
      sliderHeading: "Secure PDF",
      sliderSubHeading: "Secure your pdf files by applying password on them"),

];