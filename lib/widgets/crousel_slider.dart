import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// we can create a separate collection called advertisements from where we can fetch these documents having link to advertisement with url and title and may be other details

// Network Links to Images
final List<String> imageList = [
  'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/quiz_carousel_pics%2Fdepositphotos_198256448-stock-illustration-jury-judges-group-show-scorecards.jpg?alt=media&token=b5167c78-f892-46b3-bdbb-71063fdb687e',
  'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/quiz_carousel_pics%2Fhappy-participants-playing-quiz-game-tv-show-host-with-microphone-asking-questions_74855-10770.jpg?alt=media&token=7907d0e0-f523-4bc7-b882-f85453f0de92',
  'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/quiz_carousel_pics%2Fquiz-game-tv-show-flat-illustration_97231-943.jpg?alt=media&token=06a5ff5a-41ce-458a-81b7-120f2736fd05',
  'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/quiz_carousel_pics%2Ftv-quiz-show-host-and-two-participants-happy-girl-winning-competition-flat-vector-illustration-2CC58AG.jpg?alt=media&token=1645d323-f72e-4f35-a9dc-c712e0a8dd2e'
];

// Title for Images
final List<String> imageTitle = [
  'Get Scores',
  'Start your first Game Now',
  'Its Quiz Time',
  'Win Or Lose'
];


final List<Widget> imageSliders = imageList.map((item) => Container(
  child: Container(
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.fitHeight),
            // Positioned(
            //   bottom: 0.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           Color(0xffCACAFF),
            //           Color(0xffA4A4FF),
            //         ],
            //         stops: [
            //           0.2, 1
            //         ],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //     ),
            //     padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            //     child: Text(
            //       '${imageTitle[imageList.indexOf(item)]}',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 14.0,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
    ),
  ),
)).toList();


class WelcomePageSlider extends StatefulWidget {
  @override
  _WelcomePageSliderState createState() => _WelcomePageSliderState();
}

class _WelcomePageSliderState extends State<WelcomePageSlider> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
        child: Column(children: <Widget>[
          Material(
            elevation: 0.0,
            child: CarouselSlider(
              carouselController: CarouselControllerImpl(),
              options: CarouselOptions(
                height: size.height*0.30,
                autoPlay: true,
                aspectRatio:1.7,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: Duration(seconds: 1),
              ),
              items: imageSliders,
            ),
          ),
        ],)
    );
  }
}