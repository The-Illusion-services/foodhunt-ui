import 'package:flutter/material.dart';

Future<String?> showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<Map<String, String>> options,
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final key = option.keys.first;
                  final value = option.values.first;
                  return ListTile(
                    title: Text(value),
                    onTap: () => Navigator.pop(context, key),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
