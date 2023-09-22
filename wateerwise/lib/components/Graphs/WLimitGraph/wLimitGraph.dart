// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../../constant.dart';

class WLimitGraph extends StatelessWidget {
  const WLimitGraph(
      {super.key, required num endValue, required double currentValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        color: tWhite,
        image: DecorationImage(
          image: AssetImage('assets/images/circularprogressbar.png'),
          fit: BoxFit.cover,
        ),
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(10),
        //   bottomRight: Radius.circular(10),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5), // Shadow color
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
    );
  }
}
