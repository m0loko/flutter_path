import 'package:flutter/material.dart';
import 'package:mst_app/home_page.dart';
import 'package:mst_app/intro_screens/intro_page_1.dart';
import 'package:mst_app/intro_screens/intro_page_2.dart';
import 'package:mst_app/intro_screens/intro_page_3.dart';
import 'package:mst_app/paywall_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();

  //end or no
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [IntroPage1(), IntroPage2(), IntroPage3()],
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                GestureDetector(
                  //skip
                  child: Text('skip'),
                  onTap: () => _controller.jumpToPage(2),
                  //...
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: JumpingDotEffect(),
                ),

                ///next or done
                onLastPage
                    ? GestureDetector(
                        child: Text('done'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaywallScreen(),
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        child: Text('next'),
                        onTap: () => _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
