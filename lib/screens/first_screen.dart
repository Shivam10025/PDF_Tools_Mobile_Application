import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdftoolapplicario/ui_view/slider_layout_view.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
class FirstScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _FirstScreen();
}
class _FirstScreen extends State<FirstScreen>{
  late SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return AppBar(

        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 3.0 , bottom: 3),
          child: Text("Tools" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 20),),
        ) , backgroundColor: Color(0xfff8f5f0) ,iconTheme: IconThemeData(color: Colors.black) ,elevation: 0.0,
        actions: [searchBar.getSearchAction(context) , IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => FirstScreen())),
            icon: Icon(Icons.add_card)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => FirstScreen())),
              icon: Icon(CupertinoIcons.question_circle)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => FirstScreen())),
              icon: Icon(CupertinoIcons.settings))]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text('You wrote $value!'))));
  }

  _FirstScreen() {
    searchBar =SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: const Center(
        child: Text('My Page!'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        autofocus: true,
        elevation: 0.0,
        hoverColor: Colors.green,
        hoverElevation: 0.0,
        label: const Text('Scan Document'),
        icon: const Icon(CupertinoIcons.camera_viewfinder),
        backgroundColor: Colors.pink,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        backgroundColor:Color(0xfffafafa) ,
        child: ListView(
          // Important: Remove any padding from the ListView.

          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Color(0xfff8f5f0),
                shape: BoxShape.circle,
                image:DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/LOGO.png"))
              ),
              child: Text('' ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 20 )),
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 42.0 , bottom: 3),
                      child: Icon(CupertinoIcons.doc_fill, size: 30, color: Colors.grey,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0 , bottom: 3),
          child: Text("PDF Master" ,style: TextStyle(fontFamily: "Poppins",color: Colors.green , fontWeight: FontWeight.w500 , fontSize: 25),),
          ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 , top: 0),
                      child: Icon(CupertinoIcons.camera_viewfinder, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 , top: 0),
                      child: Text("Doc Scanner" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.square_split_2x1, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Split PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.square_split_1x2_fill, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Merge PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.camera_on_rectangle, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Image to PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.doc_on_clipboard, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("PDF to Word" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.doc_on_doc, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Word to PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.speaker_zzz, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("PDF Reader" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.padlock_solid, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Secure PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.rectangle_compress_vertical, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Compress PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.signature, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Sign PDF" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.list_number, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Add Page Number " ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.bookmark, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("Add WaterMark" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.cloud_upload, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("BackUp Documents" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0 , bottom: 0 ,),
                      child: Icon(CupertinoIcons.exclamationmark_bubble, size: 25, color: Colors.purple,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0 , bottom: 0 ,),
                      child: Text("About Us" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 20),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
            ListTile(
              title: Container(
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 50.0 ,  top:20 , bottom: 10 ),
                      child: Text("V1.0 powered by NITUK" ,style: TextStyle(fontFamily: "OpenSans",color: Colors.black54 , fontSize: 13),),
                    ),
                  ],
                ),
              ) ,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}