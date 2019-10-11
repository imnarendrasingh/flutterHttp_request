import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Requests',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Http Requests'),
        ),
        body: HomePage()
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = 'https://randomuser.me/api/?results=20&gender=female';
  List usersList;
  Future<String> getUsers() async {
    var response = 
      await http.get(url, headers: {'Accept': 'application/json'});
    
    setState(() {
     var bulkData = json.decode(response.body);
     usersList = bulkData['results'];
    });
  }

  @override 
  void initState() {
    super.initState();
    this.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: usersList == null ? 0 : usersList.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(usersList[index]['name']['last']+' '+usersList[index]['name']['first']),
              subtitle: Text(usersList[index]['phone']),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(usersList[index]['picture']['thumbnail'])
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailPage(usersList[index])
                ));
              },
            ),
            Divider()
          ],
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final data;

  DetailPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                maxRadius: 80.0,
                backgroundImage: NetworkImage(
                  data['picture']['large'],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: Text(
                data['name']['last']+' '+data['name']['first'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}