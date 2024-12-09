import 'package:flutter/material.dart';

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quote Of the Day',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {},
            child:
                const Text('Feature 1', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
