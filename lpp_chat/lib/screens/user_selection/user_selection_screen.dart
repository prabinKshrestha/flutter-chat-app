import 'package:flutter/material.dart';
import 'package:lpp_chat/models/consultancy_model.dart';
import 'package:lpp_chat/screens/chats/chat_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  final ConsultancyModel consultancy;

  const UserTypeSelectionScreen({@required this.consultancy});

  @override
  _UserTypeSelectionScreenState createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  int _userTypeValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text("Selected Consultancy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 14),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(0, 4)),
                    BoxShadow(blurRadius: 0.5, color: Colors.grey, offset: Offset(0, 0)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getDataRow("ID: ", widget.consultancy.id),
                    _getDataRow("Client: ", widget.consultancy.clientName),
                    _getDataRow("Consultancy: ", widget.consultancy.consultantName),
                    _getDataRow("Text: ", widget.consultancy.text),
                    _getDataRow("Rating: ", widget.consultancy.rating),
                    _getDataRow("Creation Date: ", widget.consultancy.creationDate),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Text("Select User type to start chat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Client'),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _userTypeValue,
                      onChanged: (int value) {
                        setState(() {
                          _userTypeValue = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Consultancy'),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: _userTypeValue,
                      onChanged: (int value) {
                        setState(() {
                          _userTypeValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_userTypeValue != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(consultancy: widget.consultancy, isClient: _userTypeValue == 1),
                        ),
                      );
                    }
                  },
                  child: Text("Start Chat"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_userTypeValue != null ? Colors.blue : Colors.blue.withOpacity(0.5))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _getDataRow(String text, dynamic value) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text('$value'),
      ],
    );
  }
}
