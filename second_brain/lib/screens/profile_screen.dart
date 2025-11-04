import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Function(String) onNameSaved;
  final String? savedName;

  const ProfileScreen({
    Key? key,
    required this.onNameSaved,
    this.savedName,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.savedName != null) {
      _nameController.text = widget.savedName!;
    }
  }

  void _saveName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onNameSaved(name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome, $name!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your name:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Your Name",
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
