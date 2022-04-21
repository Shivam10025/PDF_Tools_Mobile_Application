import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edge_detection/edge_detection.dart';

import 'first_screen.dart';
class Image_Pdf extends StatefulWidget {
  @override
  _Image_Pdf createState() => _Image_Pdf();
}

class _Image_Pdf extends State<Image_Pdf> {
  final picker = ImagePicker();
  final pdf = PdfDocument();
  late var sp="Doc_Scanner_";
  late var ps="";
  late var prev=0;
  late var p=0;
  List<File> _image = [];
  late TextEditingController _controller=TextEditingController();
  late TextEditingController _controller2=TextEditingController();
  late String fileName;
  List<Filter> filters = presetFiltersList;
  late File imageFile;
  bool isChecked = false;
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
          child: Text("Image To Pdf" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 22),),
        ) , backgroundColor: const Color(0xfff8f5f0) ,iconTheme: const IconThemeData(color: Colors.black) ,elevation: 0.0,
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.square_arrow_down_on_square , size: 25, color: Colors.black,),
              onPressed: () async {
                createPDF();
                savePDF();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FirstScreen()));
                p++;
              }),
          IconButton(
              icon: const Icon(CupertinoIcons.pencil_circle , size: 25 , color: Colors.black),
              onPressed: () async {
                final sp = await opendialogue();
                if(sp!=Null){
                  setState(() {
                    this.sp=sp as String ;
                    p++;
                  });
                }
              }),
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(left:31, bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: (){
                  getImageFromCamera;
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => FirstScreen()));
                },
                backgroundColor: Colors.pink,
                autofocus: true,
                elevation: 0.0,
                child: const Icon(CupertinoIcons.camera_viewfinder,  size: 40,color: Colors.white,),),
            ),),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed:() async {
                final ps = await opendialogue2();
                if(ps!=Null){
                  setState(() {
                    this.ps=ps as String ;
                    createPDF();
                    p++;
                  });
                }
              },
              backgroundColor: Colors.red,
              autofocus: true,
              elevation: 0.0,
              child: const Icon(Icons.security , size: 30,color: Colors.white,),),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImageFromGallery,
      ),*/
      body: _image != null
          ? ReorderableListView.builder(
        itemCount: _image.length,
        itemBuilder: (context, index) =>
            Container(
                height: 400,
                width: double.infinity,
                key: ValueKey(index),
                margin: const EdgeInsets.all(25),
                child: Image.file(
                  _image[index],
                  fit: BoxFit.cover,
                )), onReorder: reorderData,
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
  Future<String?> opendialogue2() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Password"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
            hintText: 'Enter Password'
        ),
        controller: _controller2,
      ),
      actions: [
        TextButton(
            onPressed: onPressed2,
            child: const Text("Submit"))
      ],
    ),
  );
  void onPressed2(){
    Navigator.of(context).pop(_controller2.text);
  }
  getImageFromCamera() async {
    String? imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      imagePath = (await EdgeDetection.detectEdge);
      print("$imagePath");
    } on PlatformException catch (e) {
      imagePath = e.toString();
    }
    if (!mounted) return;
    if(imagePath!=null){
      imageFile = File(imagePath);
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

  }

  createPDF() async {
    if(prev!=_image.length) {
      for (var img in _image) {
        if (img != Null) {
          final image = pw.MemoryImage(img.readAsBytesSync());
          PdfPage page = pdf.pages.add();
          PdfGraphicsState state = page.graphics.save();
          page.graphics.setTransparency(2.5);
          page.graphics.drawImage(
              PdfBitmap(img.readAsBytesSync()),
              Rect.fromLTWH(
                  0, 0, page.getClientSize().width, page.getClientSize().height));
        }
      }
      PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, pdf.pages[0].getClientSize().width, 50));
      PdfPageNumberField pageNumber = PdfPageNumberField(
          font: PdfStandardFont(PdfFontFamily.courier, 15),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      pageNumber.numberStyle = PdfNumberStyle.numeric;
      PdfPageCountField count = PdfPageCountField(
          font: PdfStandardFont(PdfFontFamily.courier, 15),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      count.numberStyle = PdfNumberStyle.numeric;
      PdfCompositeField compositeField = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.courier, 15),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: isChecked ? 'Page {0} of {1} ' : 'Page {0} of {1} (Scanned By Doc Scanner)' ,
          fields: <PdfAutomaticField>[pageNumber, count]);
      compositeField.bounds = footer.bounds;
      compositeField.draw(footer.graphics,
          Offset(200, 40 - PdfStandardFont(PdfFontFamily.courier, 15).height));
      pdf.template.bottom = footer;
      if(ps.length!=0){
        PdfSecurity security = pdf.security;

//Specifies encryption algorithm and key size
        security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;

//Set user password
        security.userPassword = ps;
      }
      prev= _image.length;
    }
  }
  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/'+DateTime.now().toString()+'.pdf');
      OpenFile.open(file.path);
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('success', 'saved to'+file.path,);
    } catch(e){
      showPrintedMessage('error', e.toString());
    }
    pdf.dispose();
  }
  void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items =_image.removeAt(oldindex);
      _image.insert(newindex, items);
    });
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