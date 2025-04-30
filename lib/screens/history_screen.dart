// screens/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<Map<String, dynamic>> historyItems = [
      {
        'id': '1',
        'date': '2023-05-15',
        'image': 'assets/placeholder1.jpg',
        'status': 'Амжилттай'
      },
      {
        'id': '2',
        'date': '2023-05-14',
        'image': 'assets/placeholder2.jpg',
        'status': 'Амжилтгүй'
      },
      {
        'id': '3',
        'date': '2023-05-13',
        'image': 'assets/placeholder3.jpg',
        'status': 'Амжилттай'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Түүх'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                      image: const DecorationImage(
                        image: AssetImage('assets/placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Огноо: ${item['date']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text(item['status']),
                        backgroundColor: item['status'] == 'Амжилттай'
                            ? Colors.green[100]
                            : Colors.red[100],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Дэлгэрэнгүй мэдээлэл...'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}