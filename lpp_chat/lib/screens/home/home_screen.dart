import 'package:flutter/material.dart';
import 'package:lpp_chat/screens/consultancy/consultancy_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultancyScreen())),
          child: Text("Consultancy List"),
        ),
      ),
    );
  }
}
