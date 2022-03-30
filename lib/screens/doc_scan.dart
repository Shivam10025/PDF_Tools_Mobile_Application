import 'dart:io';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Doc_Scanner extends StatefulWidget {
  @override
  _Doc_Scanner createState() => _Doc_Scanner();
}

class _Doc_Scanner extends State<Doc_Scanner> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  late var sp="Doc Scanner";
  late var prev=0;
  List<File> _image = [];
  late TextEditingController _controller=TextEditingController();
  late String fileName;
  List<Filter> filters = presetFiltersList;
  late File imageFile;
  @override
  Widget build(BuildContext context) {
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
          child: Text("Doc Scanner" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 22),),
        ) , backgroundColor: const Color(0xfff8f5f0) ,iconTheme: const IconThemeData(color: Colors.black) ,elevation: 0.0,
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.square_arrow_down_on_square , size: 25, color: Colors.black,),
              onPressed: () {
                createPDF();
                savePDF();
              }),
          IconButton(
              icon: const Icon(CupertinoIcons.question_diamond , size: 25, color: Colors.black),
              onPressed: () {
                createPDF();
                savePDF();
              }),
          IconButton(
              icon: const Icon(CupertinoIcons.pencil_circle , size: 25 , color: Colors.black),
              onPressed: () async {
                final sp = await opendialogue();
                if(sp!=Null){
                  setState(() {
                    this.sp=sp as String ;
                    createPDF();
                    savePDF();
                  });
                }
              }),
        ],
      ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left:31, bottom: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: getImageFromCamera,
                  backgroundColor: Colors.pink,
                  autofocus: true,
                  elevation: 0.0,
                  child: const Icon(CupertinoIcons.camera_viewfinder,  size: 40,color: Colors.white,),),
              ),),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: getImageFromGallery,
                backgroundColor: Colors.red,
                autofocus: true,
                elevation: 0.0,
                child: const Icon(Icons.add_photo_alternate , size: 30,color: Colors.white,),),
            ),
          ],
        ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImageFromGallery,
      ),*/
      body: _image != null
          ? ListView.builder(
        itemCount: _image.length,
        itemBuilder: (context, index) => Container(
            height: 400,
            width: double.infinity,
            margin: const EdgeInsets.all(25),
            child: Image.file(
              _image[index],
              fit: BoxFit.cover,
            )),
      )
          : Container(),
    );
  }
  Future<String?> opendialogue() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("File Name"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter File Name'
          ),
          controller: _controller,
        ),
        actions: [
          TextButton(
              onPressed: onPressed,
              child: const Text("Submit"))
        ],

      ),
  );
  void onPressed(){
    Navigator.of(context).pop(_controller.text);
  }
 /* Future<void> getimageditor() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorPro(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
        );
      })).then((geteditimage) {
        if (geteditimage != null) {
          setState(() {
            _image = geteditimage;
          });
        }
      }).catchError((er) {
        print(er);
      });*/
  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      imageFile = File(pickedFile.path);
      fileName = Path.basename(imageFile.path);
      var image = imageLib.decodeImage(await imageFile.readAsBytes());
      image = imageLib.copyResize(image!, width: 600);
      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: const Text("Photo Filter"),
            image: image!,
            filters: presetFiltersList,
            filename: fileName,
            loader: const Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        setState(() {
          _image.add(imagefile['image_filtered']);
        });
        print(imageFile.path);
      }
    }
    /*setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });*/
  }
  getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile!=null){
      imageFile = File(pickedFile.path);
      fileName = Path.basename(imageFile.path);
      var image = imageLib.decodeImage(await imageFile.readAsBytes());
      image = imageLib.copyResize(image!, width: 600);
      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: const Text("Photo Filter"),
            image: image!,
            filters: presetFiltersList,
            filename: fileName,
            loader: const Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        setState(() {
          _image.add(imagefile['image_filtered']);
        });
        print(imageFile.path);
      }
    }
    /*setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });*/
  }

  createPDF() async {
    if(prev!=_image.length) {
      for (var img in _image) {
        if (img != Null) {
          final image = pw.MemoryImage(img.readAsBytesSync());
          pdf.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context contex) {
                return pw.Center(child: pw.Image(image));
              }));
        }
      }
      prev= _image.length;
    }
  }
  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/'+sp+'.pdf');
      OpenFile.open('${dir?.path}/'+sp+'.pdf');
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('success', 'saved to documents',);
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.info,
        color: Colors.blue,
      ),
    ).show(context);
  }
}