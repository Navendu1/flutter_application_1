import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showContentDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _shareLottery() {
    Share.share(
        'Check out Nagaland Lottery Results app!\nhttps://play.google.com/store/apps/details?id=com.yourid');
  }

  void _rateLottery() async {
    final url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.yourid');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Center(
              child: Text(
                'Nagaland Lottery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            title: 'Lottery Prize System',
            icon: Icons.attach_money,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Lottery Prize System',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1st Prize: ₹1,00,00,000',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('2nd Prize: ₹9,000'),
                    SizedBox(height: 8),
                    Text('3rd Prize: ₹500'),
                    SizedBox(height: 8),
                    Text('4th Prize: ₹250'),
                    // Add more prize details
                  ],
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Lottery Timetable',
            icon: Icons.access_time,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Lottery Timetable',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Morning Draw: 1:10 PM',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Evening Draw: 6:10 PM'),
                    SizedBox(height: 8),
                    Text('Night Draw: 8:10 PM'),
                    // Add more timing details
                  ],
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Important Information',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Important Information',
                Text(
                  'Here you will find important information about lottery rules, regulations, and guidelines...',
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'FAQ',
            icon: Icons.question_answer,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Frequently Asked Questions',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q: How do I claim my prize?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('A: Visit the nearest lottery office with your winning ticket and valid ID.'),
                    SizedBox(height: 16),
                    Text(
                      'Q: When are results announced?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('A: Results are announced three times daily at 1:10 PM, 6:10 PM, and 8:10 PM.'),
                    // Add more FAQs
                  ],
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Contact Us',
            icon: Icons.contact_mail,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Contact Us',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('support@nagalandlottery.com'),
                    SizedBox(height: 16),
                    Text(
                      'Phone:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('+91 1234567890'),
                    // Add more contact details
                  ],
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Share',
            icon: Icons.share,
            onTap: () {
              Navigator.pop(context);
              _shareLottery();
            },
          ),
          _buildDrawerItem(
            title: 'Rate Us',
            icon: Icons.star,
            onTap: () {
              Navigator.pop(context);
              _rateLottery();
            },
          ),
          _buildDrawerItem(
            title: 'Disclaimer',
            icon: Icons.gavel,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Disclaimer',
                Text(
                  'This app is not affiliated with any official lottery organization. Results are provided for information purposes only...',
                ),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            onTap: () {
              Navigator.pop(context);
              _showContentDialog(
                context,
                'Privacy Policy',
                Text(
                  'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information...',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
