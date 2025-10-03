import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class LogoHeader extends StatelessWidget {
  final String title;
  final double logoSize;

  const LogoHeader({super.key, this.title = 'Pèlerinage Saint-Michel', this.logoSize = 96});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo_msm.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.leagueSpartan(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kMarine,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
