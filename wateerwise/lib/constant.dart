import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const tBlue = Color(0xFF3464D4);
const tBlueG = Color(0XFF5186FF);
const tWhite = Color(0xFFFEFEFF);
const tBlack = Color(0xFF3A3A3A);
const tWG = Color.fromARGB(255, 246, 246, 246);
const alertC = Color(0XFFE9EAFB);
const tGray = Color.fromARGB(255, 219, 219, 219);
const tGreen = Color(0XFF3F8B35);
const tBlackG = Color.fromARGB(255, 66, 66, 66);
const tOrange = Color(0XFFFFA500);

// WITH OPACITY
const tBlackO = Color.fromRGBO(58, 58, 58, 0.401);
const tBlueO = Color.fromARGB(48, 52, 100, 212);
const tOrangeO = Color.fromARGB(46, 255, 166, 0);

// Text
//font size 0-10 -------------------

const navText = TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.bold,
);

const desc = TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.w100,
  color: tBlack,
);

const subDesc = TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.w500,
  color: tBlackO,
);

const waterInText = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: tBlue,
);

const waterInTextBold = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.bold,
  color: tBlue,
);

const paid = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
  color: tGreen,
);

const profileRow = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
  color: tBlack,
);

const conText2 = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: tBlue,
);
//font size 11-20 -------------------

const conTextBlack = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: tBlack,
);

const profileText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: tBlack,
);

const accId = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: tBlackG,
);

const information = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: tBlack,
);

const name = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: tBlack,
);

const status = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: tOrange,
);

const latest = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: tBlack,
);

const gradCon = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: tWhite,
);

//font size 30+ -------------------

const waterInCub = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
  color: tBlack,
);

const conNum = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: tBlack,
);

const waterStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: tWhite,
);

const conText1 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: tBlue,
);

const waterWhite = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: tWhite,
);

//custom widget
class DescriptionWidget extends StatelessWidget {
  final String title;
  final String description;
  final String subDescription;

  const DescriptionWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.subDescription});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.quicksand(
            textStyle: waterInTextBold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: GoogleFonts.quicksand(
            textStyle: desc,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subDescription,
          style: GoogleFonts.quicksand(
            textStyle: subDesc,
          ),
        ),
      ],
    );
  }
}
