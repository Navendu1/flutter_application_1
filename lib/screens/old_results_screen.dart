import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../morning_result.dart';
import '../evening_result.dart';
import '../night_result.dart';

class OldResultsScreen extends StatefulWidget {
  const OldResultsScreen({super.key});

  @override
  State<OldResultsScreen> createState() => _OldResultsScreenState();
}

class _OldResultsScreenState extends State<OldResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DateTime> dates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateDates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateDates() {
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      dates.add(now.subtract(Duration(days: i)));
    }
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

  Widget _buildResultCard(ResultModel result) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: _getGradientForTime(result.timeSlot),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            '${result.timeSlot} • ${result.date.day}/${result.date.month}/${result.date.year}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              result.resultNumbers,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    switch (result.timeSlot) {
                      case 'Morning':
                        return MorningResultScreen(pdfUrl: result.pdfUrl);
                      case 'Evening':
                        return EveningResultScreen(pdfUrl: result.pdfUrl);
                      case 'Night':
                        return NightResultScreen(pdfUrl: result.pdfUrl);
                      default:
                        return MorningResultScreen(pdfUrl: result.pdfUrl);
                    }
                  },
                ),
              );
            },
            child: const Text('View PDF'),
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(String timeSlot) {
    final results = dates.map((date) => ResultModel.forDate(date, timeSlot)).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) => _buildResultCard(results[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Results'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Morning'),
            Tab(text: 'Evening'),
            Tab(text: 'Night'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResultList('Morning'),
          _buildResultList('Evening'),
          _buildResultList('Night'),
        ],
      ),
    );
  }
}
