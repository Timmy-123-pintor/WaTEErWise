import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wateerwise/services/firebase_auth_methods.dart';

import '../../constant.dart';

class AccounntInfo extends StatelessWidget {
  const AccounntInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Information",
            style: GoogleFonts.quicksand(
              textStyle: information,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/mailb.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'waterwise@gmail.com',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/contact.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '09454283224',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/homeb.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '1199 Clavano St, Cebu City, Cebu',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: tBlue,
                thickness: 1.0,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/contactsBl.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Edit Contact Details',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/settings.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Account Settings',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/help.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Help and Support',
                    style: GoogleFonts.quicksand(
                      textStyle: profileText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/logoutb.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<FirebaseAuthMethods>().signOut(context);
                    },
                    child: Text(
                      'Logout',
                      style: GoogleFonts.quicksand(
                        textStyle: profileText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
