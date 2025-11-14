import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? customIcon;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    this.icon,
    this.customIcon,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.indigo.withOpacity(0.2), // splash color
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: textColor, size: 22),
            if (customIcon != null) customIcon!,
            if (icon != null || customIcon != null) const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
