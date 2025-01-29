import 'package:flutter/material.dart';
import 'dart:async';
import 'morning_result.dart';
import 'evening_result.dart';
import 'night_result.dart';
import 'widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _timeString;
  Timer? _timer;
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTime();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!mounted) return;
    setState(() {
      final now = DateTime.now();
      final hour = now.hour > 12 ? now.hour - 12 : now.hour;
      final amPm = now.hour >= 12 ? 'PM' : 'AM';
      _timeString = "${now.day} ${_getMonth(now.month)} ${now.year} | "
          "${hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')} "
          "$amPm";
    });
  }

  String _getMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  LinearGradient _getGradientForTime(String timeSlot) {
    switch (timeSlot) {
      case 'Morning':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange[300]!,
            Colors.orange[100]!,
          ],
        );
      case 'Evening':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[400]!,
            Colors.purple[100]!,
          ],
        );
      case 'Night':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo[700]!,
            Colors.indigo[400]!,
          ],
        );
      default:
        return LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!],
        );
    }
  }

  Widget _buildResultBadge(bool isOut) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isOut ? Colors.green[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOut ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        isOut ? 'Results Out' : 'Next Update in 2h 05m',
        style: TextStyle(
          color: isOut ? Colors.green[700] : Colors.grey[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLotteryResultCard({
    required String timeSlot,
    required String displayTime,
    required bool isResultOut,
    required VoidCallback onTap,
  }) {
    bool isExpanded = _expandedStates[timeSlot] ?? false;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: _getGradientForTime(timeSlot),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedStates[timeSlot] = !isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$timeSlot • $displayTime',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _buildResultBadge(isResultOut),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'a[123]b[456]',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isExpanded) ...[
                  SizedBox(height: 16),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('SQ',
                              style: TextStyle(color: Colors.white70)),
                          Text('789',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('QSQ',
                              style: TextStyle(color: Colors.white70)),
                          Text('012',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo,
                      ),
                      child: Text('View Full Results'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 4,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            Text(
              'Results',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                _timeString,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, 
                size: 26,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildLotteryResultCard(
            timeSlot: 'Morning',
            displayTime: '1:10 PM',
            isResultOut: true,
            onTap: () async {
              String dynamicUrl = generateDynamicUrl(DateTime.now(), "MD");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MorningResultScreen(pdfUrl: dynamicUrl),
                ),
              );
            },
          ),
          _buildLotteryResultCard(
            timeSlot: 'Evening',
            displayTime: '6:10 PM',
            isResultOut: false,
            onTap: () async {
              String dynamicUrl = generateDynamicUrl(DateTime.now(), "DD");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EveningResultScreen(pdfUrl: dynamicUrl),
                ),
              );
            },
          ),
          _buildLotteryResultCard(
            timeSlot: 'Night',
            displayTime: '8:10 PM',
            isResultOut: false,
            onTap: () async {
              String dynamicUrl = generateDynamicUrl(DateTime.now(), "ED");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NightResultScreen(pdfUrl: dynamicUrl),
                ),
              );
            },
          ),
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
}

String generateDynamicUrl(DateTime dateTime, String type) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString().substring(2);
  return "https://nagalandstatelotterysambad.com/wp-content/uploads/20$year/$month/$type$day$month$year.pdf";
}
