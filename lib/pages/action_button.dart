import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {Key? key, this.onTap, required this.title, this.error = false})
      : super(key: key);

  final VoidCallback? onTap;
  final String title;
  final bool error;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(error ? Colors.red : Colors.blue)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
