import 'package:flutter/material.dart';
import 'firebase_controls.dart';
import 'inputpage.dart';
import 'resultpage.dart';
final ResultsController _rc = ResultsController();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
            TextButton(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
            ),
              child: const Text("input question",
                style: buttonTextStyle,
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyInputPage(title: "Input Question")),
                ).then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MyHomePage(title: "Home Page")
                      )
                  );
                });
              },
            ),
            Text("or check out...", style: TextStyle(fontSize: 20, color: Colors.blue)),

            Padding(padding: const EdgeInsets.all(10),
              child: Text("Most Viewed Questions",
                  style: labelStyle),
            ),

            Expanded(
                  child: FutureBuilder(
                    future: _rc.getMostViewed(3),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return  ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text( snapshot.data[index].originalQuestion),
                              subtitle: Text('Views: ${ snapshot.data[index].views}'),
                              trailing: Icon(Icons.more_vert),
                              onTap: () {
                                _rc.updateViews( snapshot.data[index].ref,  snapshot.data[index].views+1);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyResultPage.fromInput(snapshot.data[index].ref)),
                                ).then((_) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyHomePage(title: "Home Page")
                                      )
                                  );
                                });
                              },
                            );
                          },);
                      }
                    },
                  ) ,),



            Padding(padding: const EdgeInsets.all(10),
              child: Text("Most Liked Questions",
                  style: labelStyle),
            ),

           Expanded(
                  child:  FutureBuilder(
                    future: _rc.getMostLiked(3),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        print("HIIII");
                        print(snapshot.data.length);
                        return  ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            print("HI I'M ITEM BUILDER AT INDEX $index");
                            return ListTile(
                              title: Text( snapshot.data[index].originalQuestion),
                              subtitle: Text('Likes: ${ snapshot.data[index].likes}'),
                              trailing: Icon(Icons.more_vert),
                              onTap: () {
                                _rc.updateViews( snapshot.data[index].ref,  snapshot.data[index].views+1);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyResultPage.fromInput( snapshot.data[index].ref)),
                                ).then((_) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyHomePage(title: "Home Page")
                                      )
                                  );
                                });
                              },
                            );
                          },);
                      }
                    },
                  ),
                ),

            Padding(padding: const EdgeInsets.all(10),
              child: Text("Most Recent Questions",
                  style: labelStyle),
            ),

            Expanded(
              child:  FutureBuilder(
                future: _rc.getMostRecent(3),
                builder: (context, AsyncSnapshot snapshot) {
                  if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print("HIIII");
                    print(snapshot.data.length);
                    return  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print("HI I'M ITEM BUILDER AT INDEX $index");
                        return ListTile(
                          title: Text( snapshot.data[index].originalQuestion),
                          subtitle: Text('${DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].timestamp * 1000) }'),
                          trailing: Icon(Icons.more_vert),
                          onTap: () {
                            _rc.updateViews( snapshot.data[index].ref,  snapshot.data[index].views+1);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyResultPage.fromInput( snapshot.data[index].ref)),
                            ).then((_) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage(title: "Home Page")
                                  )
                              );
                            });
                          },
                        );
                      },);
                  }
                },
              ),
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}