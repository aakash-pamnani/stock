import 'package:flutter/material.dart';

class HistoryDialog extends StatelessWidget {
  const HistoryDialog({Key? key, required this.data}) : super(key: key);

  final List<String> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(data[index]),
                leading: Text("${index + 1}"),
              ),
            );
          }),
    );
  }
}
