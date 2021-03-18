import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:mobile/screen/homepage.dart';

class AddProduct extends StatefulWidget {
  final String docID;
  const AddProduct({Key key, this.docID}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //variable bool validate form button controll textField
  bool isValidate = false;
  //variable from textfield input
  TextEditingController brandMobile = TextEditingController();
  TextEditingController modelMobile = TextEditingController();
  TextEditingController priceMobile = TextEditingController();
  //variable instance collection For upload, delete and update
  CollectionReference _colRef = FirebaseFirestore.instance.collection('mobile');
  _addDoc() {
    Map<String, dynamic> doc = {
      "brand": brandMobile.text.trim(),
      "model": modelMobile.text.trim(),
      "price": priceMobile.text.trim()
    };
    _colRef.add(doc).then((val) => print(val));
  }

  _updateDoc() {
    Map<String, dynamic> docUpdate = {
      "brand": brandMobile.text.trim(),
      "model": modelMobile.text.trim(),
      "price": priceMobile.text.trim()
    };
    _colRef.doc(widget.docID).update(docUpdate).then((value) {
      print('update success');
    });
  }

  //test bool textfield
  final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();
  // Create Animation Floating Button
  Widget image() {
    return FloatActionButtonText(
      onPressed: () => fabKey.currentState.animate(),
      icon: Icons.image_search_outlined,
      text: 'Upload Picture',
      textLeft: -140,
    );
  }

  Widget camera() {
    return FloatActionButtonText(
      onPressed: () => fabKey.currentState.animate(),
      icon: Icons.camera_enhance_outlined,
      textLeft: -130,
      text: 'Take Picture',
    );
  }
  @override
  void initState() {
    super.initState();
    if (widget.docID != null) {
      colRe.doc(widget.docID).get().then((doc) {
        if (doc.exists) {
          brandMobile.text = doc.data()['brand'];
          modelMobile.text = doc.data()['model'];
          priceMobile.text = doc.data()['price'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: AnimatedFloatingActionButton(
        key: fabKey,
        fabButtons: <Widget>[image(), camera()],
        colorEndAnimation: Colors.red,
        colorStartAnimation: Colors.black87,
        animatedIconData: AnimatedIcons.menu_close,
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        actions: [
          Icon(
            Icons.clear_sharp,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              var currentState = _formKey.currentState;
              if (currentState.validate()) {
                setState(() {
                  isValidate = true;
                }); 
              } else {
                setState(() {
                  isValidate = false;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.red[400],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //TextFeild Brand
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Brand...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    controller: brandMobile,
                    validator: (val) {
                      if (val.isNotEmpty && val.length > 0) {
                        return null;
                      } else {
                        return 'Brand is require';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //TextFeild Model
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Model...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    controller: modelMobile,
                    validator: (val) {
                      if (val.isNotEmpty && val.length > 0) {
                        return null;
                      } else {
                        return 'Model is require';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //TextFeild Price
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Price...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    controller: priceMobile,
                    validator: (val) {
                      if (val.isNotEmpty && val.length > 0) {
                        return null;
                      } else {
                        return "Price is require";
                      }
                    },
                  ),
                  //button add product
                  OutlineButton(
                    onPressed: !isValidate
                        ? null
                        : widget.docID != null ? _updateDoc() : _addDoc(),
                    color: Colors.red,
                    child:widget.docID!=null?Text('Save product'): Text('Add Product'),
                    highlightedBorderColor: Colors.cyanAccent,
                    splashColor: Colors.red,
                    borderSide: BorderSide(
                      color: Colors.purple,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
