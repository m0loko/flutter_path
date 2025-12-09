import 'package:flutter/material.dart';

class RunTestWidget extends StatelessWidget {
  const RunTestWidget({super.key, required this.onTap});
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            borderRadius: .circular(100),
            border: .all(color: Colors.cyanAccent, width: 3.0),
          ),
          child: Center(
            child: Text(
              'GO',
              style: TextStyle(fontSize: 32, fontWeight: .bold),
            ),
          ),
        ),
      ),
    );
  }
}
