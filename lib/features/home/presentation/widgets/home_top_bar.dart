import 'package:flutter/material.dart';

import '../theme/home_theme.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
      child: Row(
        children: [
          Image.asset(
            'assets/app_icon.png',
            width: 32,
            height: 32,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ).createShader(bounds),
            child: const Text(
              'ATS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
          const Text(
            'ify',
            style: TextStyle(
              color: HomeTheme.headline,
              fontSize: 22,
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: HomeTheme.headline,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
