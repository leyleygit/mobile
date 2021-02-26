import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screen/addproduct.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

bool _isEdit = false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        
          child: Icon(Icons.add_ic_call_sharp,size: 40,),
          backgroundColor: Colors.green[400],
          tooltip: 'បន្ថែមទូរស័ព្ទ?',
          onPressed: (){
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
            });
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text("TestFirebase"),
          leading: _isEdit
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isEdit = !_isEdit;
                    });
                  },
                )
              : null,
          actions: [
            _isEdit
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  )
                : Container(),
            _isEdit
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                : Container(),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('mobile').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'no data',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              );
            } else {
              var _doc = snapshot.data.docs;
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: _isEdit
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : _isEdit
                                ? Icon(Icons.circle, color: Colors.white)
                                : null,
                        onLongPress: () {
                          setState(() {
                            _isEdit = !_isEdit;
                          });
                          var id = snapshot.data.docs[index].id;
                          print('key: $id');
                        },
                        title: Text(_doc[index]['model']),
                        trailing: Text(
                          _doc[index]['price'],
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1.0,
                        color: Colors.grey[800],
                      )
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
