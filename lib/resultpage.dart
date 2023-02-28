import 'package:flutter/material.dart';
import 'dataclasses.dart';
import 'firebase_controls.dart';
final ResultsController _rc = ResultsController();
class MyResultPage extends StatefulWidget {
  MyResultPage({super.key}): ref = 'error';
  Result? res;
  final String ref;
  MyResultPage.fromInput(this.ref);
  MyResultPage.fromResult(Result r): ref = r.ref {
    res=r;
  }

  @override
  State<MyResultPage> createState() => _MyResultPageState();
}

class _MyResultPageState extends State<MyResultPage> {
  int likes=0;
  Future<Result> retrieveResult() async{
    if (widget.res!=null) {
      return Future(() => widget.res!);
    }
    return _rc.waitForResult(widget.ref);
  }
  @override
  Widget build(BuildContext context) {
    const TextStyle buttonTextStyle = const TextStyle(fontSize: 20);
    const TextStyle labelStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle labelStyle2 = const TextStyle(fontSize: 20);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Result')
      ),
      body: Center(
        child: FutureBuilder(
          future: retrieveResult(),
          builder:  (context, AsyncSnapshot snapshot) {
      if(!snapshot.hasData) {

      return Center(child: CircularProgressIndicator());
      } else {
        widget.res = snapshot.data;
        likes = widget.res!.likes;
        _rc.updateViews(widget.ref, widget.res!.views+1);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey, width:5)),
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10),
                    child: Text('Question:',
                        style: labelStyle),),

                  Expanded(child:
                  Padding(padding: const EdgeInsets.all(5),
                    child:
                    Text(widget.res!.originalQuestion,
                        style: labelStyle2),
                  ),
                  ),
                ],
              ),
            ),

            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey, width:5)),
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: Text('Conclusion:',
                          style: labelStyle),),

                    Expanded(child:Padding(padding: const EdgeInsets.all(5),
                      child: Text(widget.res!.answer,
                          style: labelStyle2),
                    ),
                    ),
                  ],
                )
            ),

            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey, width:5)),
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: Text('Summary:',
                          style: labelStyle),),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
            ),
            Expanded(
                flex: 1,

                child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(widget.res!.summary,
                      style: labelStyle2),
                )

            ),
            Row(
              children: [
                TextButton(
                    child: const Text("Like"),
                    onPressed: () {
                      setState(() {
                        print(widget.res!.likes+1);
                        _rc.updateLikes(widget.res!.ref, widget.res!.likes+1);
                        likes=widget.res!.likes+1;
                      });
                    }
                ),
                Text(
                    "$likes"
                )
              ],
            )
          ],
        );
      }
      },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

