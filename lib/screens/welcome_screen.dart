import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

late AnimationController controller;

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    // animation = ColorTween(
    //   begin: Colors.blueGrey, end: Colors.white,
    // ).animate(controller);
    // controller.forward();
    // controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose(); // and does it matter if i dispose the controller before this line or after this line.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'flash-icon',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  pause: Duration(seconds: 1),
                  repeatForever: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: Duration(milliseconds: 300),
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // kButton(),
            kButton(
              clr: Colors.lightBlueAccent,
              txt: 'Log In',
              context: context,
              page: '/login_screen',
            ),
            kButton(
              clr: Colors.blueAccent,
              txt: 'Register',
              context: context,
              page: '/registation_screen',
            ),
          ],
        ),
      ),
    );
  }
}

class kButton extends StatelessWidget {
  late var clr;
  late String txt;
  late var context;
  late var page;
  kButton({required this.clr, required this.txt, required this.context,required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: clr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: (){
            Navigator.pushNamed(context, page);
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            txt,
          ),
        ),
      ),
    );
  }
}

