import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdftoolapplicario/screens/doc_scan.dart';
import 'package:pdftoolapplicario/screens/imagetopdf.dart';
import 'package:pdftoolapplicario/screens/pdf_merge.dart';
import 'package:pdftoolapplicario/ui_view/slider_layout_view.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_merger/pdf_merger.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import 'package:share/share.dart';
class InnerScreen extends StatefulWidget{
  InnerScreen({required this.filespath});
  final String filespath;
  @override
  State<StatefulWidget> createState() => _InnerScreen();
}
class _InnerScreen extends State<InnerScreen>{
  late SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  var files;
  String _search="";
  void getFiles() async {

    final Directory? _appDocDir = await getExternalStorageDirectory();
    //App Document Directory + folder name
    String sp=widget.filespath;
    final Directory dir =
    Directory('${_appDocDir?.path}/$sp/');//asyn function
    var fm = FileManager(root: dir); //
    files = await fm.filesTree(
      excludedPaths: ["/storage/emulated/0/Android"],
      extensions: ["pdf"],
    );
    setState(() {}); //update the UI
  }
  @override
  void initState() {
    getFiles();
    super.initState();
  }
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 3.0 , bottom: 3),
          child: Text("Tools" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 20),),
        ) , backgroundColor: const Color(0xfff8f5f0) ,iconTheme: const IconThemeData(color: Colors.black) ,elevation: 0.0,
        actions: [
          searchBar.getSearchAction(context) ,
          ]);
  }
  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text('You wrote $value!'))));
  }

  _InnerScreen() {
    searchBar =SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
        onCleared: () {
          setState(() {
            _search = "";
          });
        },
        onClosed: () {
          setState(() {
            _search = "";
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body:  Column(
        children: [
          DataTable(
            dataRowHeight: 60,
            sortAscending: true,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Files',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: List.generate(files.length, (index) =>
                DataRow(
                    cells: <DataCell>[
                      DataCell(files[index].path.contains(_search) ? SizedBox(
                        height: 300,
                        child: Card(
                            child: ListTile(
                              title: Text(files[index].path.split('/').last),
                              leading: const Icon(Icons.picture_as_pdf, color: Colors.red,),
                              trailing: IconButton(
                                icon: const Icon(Icons.share , color: Colors.red,),
                                tooltip: 'Share Button',
                                onPressed: () {
                                  Share.shareFiles([files[index].path], text: 'PDF Master');
                                },
                              ),
                              onTap: () {
                                OpenFile.open(files[index].path);
                              },
                            )),
                      ) : const SizedBox(
                        height: 0,)
                      ),]
                ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left:31, bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Doc_Scanner(filespath: widget.filespath,))),
                autofocus: true,
                elevation: 0.0,
                hoverColor: Colors.green,
                hoverElevation: 0.0,
                label: const Text('Scan Document'),
                icon: const Icon(CupertinoIcons.camera_viewfinder),
                backgroundColor: Colors.pink,
              ),),
          ),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        backgroundColor:const Color(0xfffafafa) ,
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
                      child: Icon(CupertinoIcons.doc_fill, size: 30, color: Colors.pink,) ,
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Doc_Scanner(filespath: widget.filespath,)));
              },
            ),
            /* ListTile(
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
            ),*/
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => PDF_MERGE()));
              },
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Image_Pdf()));
              },
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