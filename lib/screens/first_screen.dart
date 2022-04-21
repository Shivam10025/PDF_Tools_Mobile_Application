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
import 'package:smart_select/smart_select.dart';
import 'package:share/share.dart';

import 'inner_screen.dart';
class FirstScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _FirstScreen();
}
class _FirstScreen extends State<FirstScreen>{
  late SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  var files;
  String _search="";
  void getFiles() async { //asyn function to get list of files
    final dir = await getExternalStorageDirectory();
    var fm = FileManager(root: dir); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"], //optional, to filter files, list only pdf files
    );
    setState(() {}); //update the UI
  }
  Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory? _appDocDir = await getExternalStorageDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
    Directory('${_appDocDir?.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  callFolderCreationMethod(String folderInAppDocDir) async {
    // ignore: unused_local_variable
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    print(actualFileName);
    setState(() {});
  }

  final folderController = TextEditingController();
  String nameOfFolder="";
  Future<void> _showMyDialog() async => showDialog<void>(
      context: context,// user must tap button!
      builder: (BuildContext context) => AlertDialog(
          title: Column(
            children: const [
              Text(
                'ADD FOLDER',
                textAlign: TextAlign.left,
              ),
              Text(
                'Type a folder name to add',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: folderController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter folder name'),
                onChanged: (val) {
                  setState(() {
                    nameOfFolder = folderController.text;
                    nameOfFolder+="-dc";
                    print(nameOfFolder);
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (nameOfFolder != "") {
                  await callFolderCreationMethod(nameOfFolder);
                  getDir();
                  setState(() {
                    folderController.clear();
                    nameOfFolder = "";
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            FlatButton(
              color: Colors.redAccent,
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
    );
  List<FileSystemEntity> _folders=[];
  Future<void> getDir() async {
    final directory = await getExternalStorageDirectory();
    final dir = directory?.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    _folders.removeWhere((path) => path.toString().contains("-dc")==false);
    _folders.removeWhere((path) => path.toString().split('/').last.contains(".pdf")==true);
    print(_folders);
  }
  @override
  void initState() {
    _folders=[];
    getDir();
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
          IconButton(
            onPressed:(){
              _showMyDialog();
            },
            icon: const Icon(Icons.add_card)),
          IconButton(
              onPressed: (){
              },
              icon: const Icon(CupertinoIcons.folder_circle)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => FirstScreen())),
              icon: const Icon(CupertinoIcons.settings))]);
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
        body:  SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                dataRowHeight: 60,
                sortAscending: true,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Folders',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: List.generate(_folders.length, (index) =>
                    DataRow(
                        cells: <DataCell>[
                          DataCell(_folders[index].path.contains("-dc") && !_folders[index].path.contains("2022") ? SizedBox(
                            height: 300,
                            child: Card(
                                child: ListTile(
                                  title: Text(_folders[index].path.split('/').last),
                                  leading: const Icon(Icons.folder, color: Colors.red,),
                                  onTap: () {//OpenFile.open(files[index].path);
                                    Navigator.push(context, MaterialPageRoute(builder: (builder){
                                      return InnerScreen(filespath:_folders[index].path.split('/').last);
                                    }));
                                  },
                                )),
                          ) : const Text("")
                ),]
                    ),
                ),
              ),
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
        ),
        /*body:files == null? Text("Searching Files"):
        ListView.builder(  //if file/folder list is grabbed, then show here
          itemCount: files?.length ?? 0,
          itemBuilder: (context, index) {
            if(files[index].path.contains(_search)) {
              return Card(
                  child: ListTile(
                    title: Text(files[index].path
                        .split('/')
                        .last),
                    leading: Icon(Icons.picture_as_pdf),
                    trailing: Icon(
                      Icons.arrow_forward, color: Colors.redAccent,),
                    onTap: () {
                      /* Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ViewPDF(pathPDF:files[index].path.toString());
                      //open viewPDF page on click
                    }));*/
                    },
                  )
              );
            }else{
              return Text("");
            }
            },
        ),*/
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left:31, bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Doc_Scanner(filespath: "",))),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Doc_Scanner(filespath: "",)));
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