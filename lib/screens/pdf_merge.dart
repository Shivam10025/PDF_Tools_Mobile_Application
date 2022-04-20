import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

//import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_merger/pdf_merger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
class PDF_MERGE extends StatefulWidget {
  @override
  _pdf_merge createState() => _pdf_merge();
}

class _pdf_merge extends State<PDF_MERGE> {

  late List<PlatformFile> files;
  late List<String> filesPath;
  late String singleFile;

  void initState() {
    super.initState();
    clear();
  }
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.black;
      }
      return Colors.black;
    }
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0.0,
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0 , bottom: 0),
          child: Text("Merge PDF" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 22),),
        ) , backgroundColor: const Color(0xfff8f5f0) ,iconTheme: const IconThemeData(color: Colors.black) ,elevation: 0.0,
      ),
        body:filesPath.isEmpty? Text(""):
        ListView.builder(  //if file/folder list is grabbed, then show here
          itemCount: filesPath.length,
          itemBuilder: (context, index) {
            return Card(
                child:ListTile(
                  title: Text(filesPath[index].split('/').last),
                  leading: const Icon(Icons.picture_as_pdf , color: Colors.red,),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.redAccent,),
                  onTap: (){
                   /* Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ViewPDF(pathPDF:files[index].path.toString());
                      //open viewPDF page on click
                    }));*/
                  },
                )
            );
          },
        ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left:31, bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed:  () async {
                  /*String dirPath = await getFilePath("TestPDFMerger");
                  mergeMultiplePDF(dirPath);*/
                  multipleFilePicker();
                },
                backgroundColor: Colors.pink,
                autofocus: true,
                elevation: 0.0,
                child: const Icon(CupertinoIcons.square_split_1x2_fill,  size: 40,color: Colors.white,),),
            ),),
        ],
      ),
    );
  }
  clear() {
    files = [];
    filesPath = [];
    singleFile = "";
  }

  multipleFilePicker() async {
      try {
        FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null) {
          files.addAll(result.files);

          for (int i = 0; i < result.files.length; i++) {
            filesPath.add(result.files[i].path.toString());
          }
          setState(() {

          });
          String dirPath = await getFilePath();
          print(dirPath);
          mergeMultiplePDF(dirPath);
        } else {
        }
      } on Exception catch (e) {
        print('never reached' + e.toString());
      }
  }
  Future<String> getFilePath() async {
    final dir = await getExternalStorageDirectory();
    print('${dir?.path}/'+DateTime.now().toString()+'.pdf');
    return '${dir?.path}/'+DateTime.now().toString()+'.pdf';
  }
  Future<void> mergeMultiplePDF(outputDirPath) async {
    try {
      MergeMultiplePDFResponse response = await PdfMerger.mergeMultiplePDF(
          paths: filesPath, outputDirPath: outputDirPath);
        Get.snackbar("Info",response.message.toString());
      if (response.status == "success") {
        OpenFile.open(response.response);
      }
      print(response.status);
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }
}