import 'package:flutter/material.dart';
import 'package:animated_float_action_button/animated_floating_action_button.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //
  
  final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();
  // Create Animation Floating Button
  Widget image() {
    return FloatActionButtonText(
      onPressed: ()=>fabKey.currentState.animate(),
      icon: Icons.image_search_outlined,
      text: 'Upload Picture',
      textLeft: -140,
    );
  }
  Widget camera (){
    return FloatActionButtonText(
      onPressed: ()=>fabKey.currentState.animate(),
      icon: Icons.camera_enhance_outlined,
      textLeft: -130,
      text: 'Take Picture',
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: AnimatedFloatingActionButton(
        key: fabKey,
        fabButtons: <Widget>[
          image(),
          camera()
        ],
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
      body: Column(
        children: [
          Center(
            child: Container(
              width: 150,
              height: 150,
              color: Colors.red[400],
            ),
          )
        ],
      ),
    );
  }
}
