import 'package:flutter/material.dart';

class UpcomingFeaturesTextWidget extends StatelessWidget {
  const UpcomingFeaturesTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UPCOMING FEATURES',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                'This is a new project, and I have a ton of features planned to release very soon. Here are just a few of the planned features:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outlined, size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Import icon from local file',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outlined, size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Icon-based color palettes',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outlined, size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Importing icons from image URL',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outline_blank,
                    size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Add Text',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outline_blank,
                    size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Can setting resolution & layout',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outline_blank,
                    size: 30, color: Colors.grey),
                SizedBox(width: 10),
                Text('Searching icons from no copyright',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
