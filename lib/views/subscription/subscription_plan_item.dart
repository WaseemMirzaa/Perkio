import 'package:flutter/material.dart';

class SubscriptionPlanItem extends StatelessWidget {
  const SubscriptionPlanItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
    required this.isSubscribed,
    required this.description,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String buttonText;
  final String description;
  final String amount;
  final bool isSubscribed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isSubscribed)
                  SizedBox(
                    height: 30,
                    child: Chip(
                      label: const Text(
                        'Active',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Price: ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text(
                  '$amount/',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Free Trial',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubscribed ? Colors.red : Colors.blue,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
