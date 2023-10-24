import 'package:flutter/material.dart';

import '../../constant.dart';

class Latest extends StatefulWidget {
  const Latest({super.key});

  @override
  State<Latest> createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 85,
          color: tWhite,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mail.png',
                  width: 25,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                const DescriptionWidget(
                  title: 'Payment Confirmation',
                  description:
                      'Your payment of 360 pesos, made on June 12, 2023',
                  subDescription: '3 hours ago',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
