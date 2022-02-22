import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  static const String id = '/textFormFieldWidget';

//Very important
   final Function(String? value ) callback;
  final   String?  Function(String? value ) callback2;

  const TextFormFieldWidget({Key? key , required this.callback ,required this.callback2 }) : super(key: key);


  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(

      // onSaved:widget.callback,
      onChanged:widget.callback,




      validator:widget.callback2,
      decoration: InputDecoration(hintText: 'marca',
        label: Text('marca', style: TextStyle(fontSize: 20, color: Colors.blue),),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),);
  }
}
