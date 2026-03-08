import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.support_agent_outlined, color: Colors.green),
              SizedBox(width: 8),
              Text("Support"),
            ],
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline, color: Colors.green),
            title: Text("Chat with us"),
            subtitle: Text("Get help and support"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: Icon(Icons.email_outlined, color: Colors.green),
            title: Text("Email us"),
            subtitle: Text("Send us an email for support"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
