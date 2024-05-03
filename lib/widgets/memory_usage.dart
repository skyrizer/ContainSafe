import 'dart:async';
import 'package:flutter/material.dart';

class MemoryUsageContainer extends StatelessWidget {
  final Stream<Map<String, dynamic>> stream;

  const MemoryUsageContainer({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memory Usage',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Usage: ${data['usage']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Size: ${data['size']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(); // Or any loading indicator you prefer
        }
      },
    );
  }
}

