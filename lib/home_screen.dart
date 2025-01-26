import 'package:flutter/material.dart';
import 'morning_result.dart';
import 'evening_result.dart';
import 'night_result.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nagaland Lottery Results'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          _buildResultCard(
            context: context,
            title: 'Morning Result',
            time: 'Result Time Every Day is 1.10 PM navendu m',
            bengaliTime: ' প্রতিদিন রেজাল্টের সময় 1.10PM',
            image: 'assets/image/morning_image.png', // Placeholder
          ),
          _buildResultCard(
            context: context,
            title: 'Evening Result',
            time: 'Result Time Every Day is 6.10 PM',
            bengaliTime: ' প্রতিদিন রেজাল্টের সময় 6.10PM',
            image: 'assets/image/morning_image.png', // Placeholder
          ),
          _buildResultCard(
            context: context,
            title: 'Night Result',
            time: 'Result Time Every Day is 8.10 PM',
            bengaliTime: ' প্রতিদিন রেজাল্টের সময় 8.10PM',
            image: 'assets/image/morning_image.png', // Placeholder
          ),
          _buildResultCard(
            context: context,
            title: 'Old Result',
            textOnly: true,
            bengaliTitle: 'পুরনো রেজাল্ট',
          ),
          SizedBox(height: 20),
          Center(child: Text('Component')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Old Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: 'Prediction',
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    String? time,
    String? bengaliTime,
    String? image,
    bool textOnly = false,
    String? bengaliTitle,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () async {
          if (title == 'Morning Result') {
            String dynamicUrl = generateDynamicUrl(DateTime.now(), "MD");

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MorningResultScreen(
                        pdfUrl: dynamicUrl,
                      )),
            );
          } else if (title == 'Evening Result') {
            String dynamicUrl = generateDynamicUrl(DateTime.now(), "MD");

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EveningResultScreen(
                        pdfUrl: dynamicUrl,
                      )),
            );
          } else if (title == 'Night Result') {
            String dynamicUrl = generateDynamicUrl(DateTime.now(), "MD");

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NightResultScreen(
                        pdfUrl: dynamicUrl,
                      )),
            );
          } else if (title == 'Old Result') {
            // TODO: Add navigation for Old Result
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (!textOnly)
                Row(
                  children: [
                    // if (image != null)
                    //   Image.asset(
                    //     image,
                    //     height: 50,
                    //     width: 50,
                    //   ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          if (time != null)
                            Text(
                              time,
                              style: TextStyle(fontSize: 14),
                            ),
                          if (bengaliTime != null)
                            Text(
                              bengaliTime,
                              style: TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              else if (bengaliTitle != null)
                Center(
                  child: Text(
                    bengaliTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LotteryCard extends StatelessWidget {
  final String name;
  final String date;
  final String numbers;
  final VoidCallback onTap;

  LotteryCard(
      {required this.name,
      required this.date,
      required this.numbers,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Draw Date: $date\nWinning Numbers: $numbers'),
        onTap: onTap,
      ),
    );
  }
}

String generateDynamicUrl(DateTime dateTime, String type) {
  String day = dateTime.day.toString().padLeft(2, '0'); // Ensure two digits
  String month = dateTime.month.toString().padLeft(2, '0'); // Ensure two digits
  String year =
      dateTime.year.toString().substring(2); // Get last two digits of the year

  return "https://nagalandstatelotterysambad.com/wp-content/uploads/20$year/$type$day$month$year.pdf";
}
