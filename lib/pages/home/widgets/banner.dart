import 'package:flutter/material.dart';
import 'package:sistem_informasi/utils/colors.dart';
import 'package:sistem_informasi/utils/text.dart';

class BannerWidget extends StatelessWidget {
  final double sizeHeight, sizeWidth;
  const BannerWidget({
    super.key,
    required this.sizeHeight,
    required this.sizeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: sizeWidth * 0.03,
        vertical: sizeHeight * 0.01,
      ),
      padding: EdgeInsets.only(
        left: sizeWidth * 0.05,
        right: sizeWidth * 0.02,
        top: sizeHeight * 0.008,
        bottom: sizeHeight * 0.008,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(sizeHeight * 0.02),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGlobalWidget(
                text: "Selamat datang",
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              TextGlobalWidget(
                text: "di Sistem Informasi",
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              TextGlobalWidget(
                text: "Manajemen Acara",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const Spacer(),
          Image.asset("assets/img/target.png"),
        ],
      ),
    );
  }
}
