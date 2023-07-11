import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const tBlue = Color(0xFF3464D4);
const tBlueG = Color(0XFF5186FF);
const tWhite = Color(0xFFFEFEFF);
const tBlack = Color(0xFF3A3A3A);
const tWG = Color.fromARGB(255, 246, 246, 246);
const tGray = Color.fromARGB(255, 219, 219, 219);
const tGreen = Color(0XFF3F8B35);
const alertC = Color(0XFFE9EAFB);

// WITH OPACITY
const tBlackO = Color.fromRGBO(58, 58, 58, 0.401);

// Text
const waterStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: tWhite,
);

const navText = TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.bold,
);

const conText1 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: tBlue,
);

const conText2 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: tBlue,
);

const conNum = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: tBlack,
);

const gradCon = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: tWhite,
);

const paid = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
  color: tGreen,
);

const conTextBlack = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: tBlack,
);

const latest = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: tBlack,
);

const waterInTextBold = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.bold,
  color: tBlue,
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
