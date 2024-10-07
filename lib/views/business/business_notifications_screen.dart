import 'package:flutter/material.dart';

class BusinessNotificationScreen extends StatelessWidget {
  const BusinessNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // 10 ListTiles
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text('Notification Title ${index + 1}'),
            subtitle: Text('This is the subtitle for notification ${index + 1}.'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Handle notification tap
              print('Tapped on Notification ${index + 1}');
            },
          );
        },
      ),
    );
  }
}