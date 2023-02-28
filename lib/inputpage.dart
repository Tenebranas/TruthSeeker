import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'resultpage.dart';
import 'dataclasses.dart';
import 'firebase_options.dart';
import 'firebase_controls.dart';
final TextEditingController _controllerQuestion = TextEditingController();
final TextEditingController _controllerSource = TextEditingController();

final JobsController _jc = JobsController();
final ResultsController _rc = ResultsController();

class MyInputPage extends StatefulWidget {
  const MyInputPage({super.key, required this.title});

  final String title;

  @override
  State<MyInputPage> createState() => _MyInputPageState();
}

class _MyInputPageState extends State<MyInputPage> {
  Future<String> postJob() async {
    Job newJob = Job(question: _controllerQuestion.text, source: _controllerSource.text);
        DocumentReference dr = await _jc.addJob(newJob);
    return dr.id;
  }
  Future<void> processQuestion() async{
    String ID = await postJob();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyResultPage.fromInput(ID)),
    );
  }
  @override
  Widget build(BuildContext context) {
    const TextStyle buttonTextStyle = const TextStyle(fontSize: 20);
    const TextStyle labelStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

        Padding(padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controllerQuestion,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Question',
              ),
            ),
          ),

        Padding(padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controllerSource,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Source',
              ),
            ),
          ),

        Padding(padding: const EdgeInsets.all(10),
            child: TextButton(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
            ),
              child: const Text("input question",
                style: buttonTextStyle,
              ),
              onPressed: () => processQuestion(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}