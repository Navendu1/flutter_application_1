import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String lotteryName;
  final String drawDate;
  final String winningNumbers;

  const DetailsScreen({super.key, 
    required this.lotteryName,
    required this.drawDate,
    required this.winningNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lottery Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lotteryName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Draw Date: $drawDate',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Winning Numbers:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              winningNumbers,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueAccent,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Placeholder for sharing functionality
                },
                child: Text('Share Results'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
