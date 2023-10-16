// // ignore_for_file: file_names, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../constant.dart';

// class DropdownContainer extends StatefulWidget {
//   const DropdownContainer(
//       {super.key,
//       required Null Function(dynamic selectedPeriod) onPeriodSelected});

//   @override
//   _DropdownContainerState createState() => _DropdownContainerState();
// }

// class _DropdownContainerState extends State<DropdownContainer> {
//   String selectedValue = 'Option 1';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       decoration: BoxDecoration(
//         color: tWhite,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5), // Shadow color
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//       ),
//       child: Center(
//         child: DropdownButton<String>(
//           value: selectedValue,
//           onChanged: (newValue) {
//             setState(() {
//               selectedValue = newValue!;
//             });
//           },
//           underline: Container(), // or SizedBox.shrink()
//           items: [
//             DropdownMenuItem<String>(
//               value: 'Option 1',
//               child: Text(
//                 'Option 1',
//                 style: GoogleFonts.quicksand(
//                     textStyle: navText,
//                     color: selectedValue == 'Option 1' ? tBlue : tBlack),
//               ),
//             ),
//             DropdownMenuItem<String>(
//               value: 'Option 2',
//               child: Text(
//                 'Option 2',
//                 style: GoogleFonts.quicksand(
//                     textStyle: navText,
//                     color: selectedValue == 'Option 2' ? tBlue : tBlack),
//               ),
//             ),
//             DropdownMenuItem<String>(
//               value: 'Option 3',
//               child: Text(
//                 'Option 3',
//                 style: GoogleFonts.quicksand(
//                     textStyle: navText,
//                     color: selectedValue == 'Option 3' ? tBlue : tBlack),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
