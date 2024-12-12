import 'package:flutter/material.dart';

class KanbanImageDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          // Close the hero transition by popping the current page
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'kanban_image', // Same tag as in the first page
            child: Image.asset(
              'assets/kanbanpic.jpg', // Make sure this image exists in your assets folder
              fit: BoxFit.contain, // Adjust the fit for the larger view
            ),
          ),
        ),
      ),
    );
  }
}