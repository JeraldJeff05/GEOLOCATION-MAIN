import 'dart:math';
import 'package:flutter/material.dart';

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    // List of quotes
    final List<String> quotes = [
      "The best way to get started is to quit talking and begin doing.  ",
      "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty.",
      "Don't let yesterday take up too much of today.",
      "You learn more from failure than from success. Don't let it stop you. Failure builds character.",
      "It's not whether you get knocked down, it's whether you get up.",
      "If you are working on something that you really care about, you don't have to be pushed. The vision pulls you.",
      "Time is Gold, When watching bold",
    ];

    // Randomly select a quote
    final randomQuote = quotes[Random().nextInt(quotes.length)];

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
        mainAxisSize:
            MainAxisSize.min, // Ensures the container fits its content
        children: [
          const Text(
            'Quote of the Day',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            randomQuote,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
