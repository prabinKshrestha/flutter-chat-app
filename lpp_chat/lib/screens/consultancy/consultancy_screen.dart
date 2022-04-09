import 'package:flutter/material.dart';
import 'package:lpp_chat/business/consultancy/consultancy_bloc.dart';
import 'package:lpp_chat/models/consultancy_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lpp_chat/screens/user_selection/user_selection_screen.dart';

class ConsultancyScreen extends StatefulWidget {
  @override
  _ConsultancyScreenState createState() => _ConsultancyScreenState();
}

class _ConsultancyScreenState extends State<ConsultancyScreen> {
  final List<ConsultancyModel> consultancies = [];

  @override
  void initState() {
    super.initState();
    context.read<ConsultancyBloc>().add(ConsultancyEventRequest());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<ConsultancyBloc, ConsultancyState>(
          listener: (_, state) async {},
          builder: (_, state) {
            return Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (state is ConsultancyStateFetchLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is ConsultancyStateFetchError) {
                        return Center(child: Text("Error while fetching record", style: TextStyle(color: Colors.red)));
                      }
                      if (state is ConsultancyStateFetchSuccess) {
                        consultancies.clear();
                        consultancies.addAll(state.consultancies);
                      }
                      if (consultancies.length > 0) {
                        return ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 5),
                          itemCount: consultancies.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) => _consultancyItem(consultancies[index]),
                        );
                      } else {
                        return Center(child: Text("No Record Found", style: TextStyle(color: Colors.red)));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _consultancyItem(ConsultancyModel consultancy) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserTypeSelectionScreen(consultancy: consultancy))),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
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
            _getDataRow("ID: ", consultancy.id),
            _getDataRow("Client: ", consultancy.clientName),
            _getDataRow("Consultancy: ", consultancy.consultantName),
            _getDataRow("Text: ", consultancy.text),
            _getDataRow("Rating: ", consultancy.rating),
            _getDataRow("Creation Date: ", consultancy.creationDate),
          ],
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
