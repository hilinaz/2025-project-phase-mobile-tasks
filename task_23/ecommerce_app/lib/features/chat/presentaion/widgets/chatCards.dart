import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';

Widget chatCard(User user, {required VoidCallback onTap}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text(
        user.email, // since User has id, name, email only
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    ),
  );
}
