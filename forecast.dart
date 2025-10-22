import 'package:flutter/material.dart';

class forecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const forecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        color: Color.fromRGBO(214, 185, 252, 1),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 6),
            Text(

              temp,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
