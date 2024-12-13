import 'dart:math';
import 'package:flutter/material.dart';

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    // List of quotes
    final List<String> quotes = [
      "Accept the things to which fate binds you, and love the people with whom fate brings you together,but do so with all your heart.                                     ",
      "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty.                                                               ",
      "If you are distressed by anything external, the pain is not due to the thing itself, but to your estimate of it; and this you have the power to revoke at any moment.",
      "You learn more from failure than from success. Don't let it stop you. Failure builds character.                                                                      ",
      "Everything we hear is an opinion, not a fact. Everything we see is a perspective, not the truth.                                                                     ",
      "If you are working on something that you really care about, you don't have to be pushed. The vision pulls you.                                                       ",
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
