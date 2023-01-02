
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LodingPage extends StatefulWidget {
  const LodingPage({Key? key}) : super(key: key);

  @override
  State<LodingPage> createState() => _LodingPageState();
}

class _LodingPageState extends State<LodingPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: height/2.5,
                child: Image.asset("assets/logo.png"),
              ),
              SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blueAccent : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),

        ),

      ),
    );
  }
}
