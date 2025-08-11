import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/utils.dart';
import 'package:intl/intl.dart';

class UpdateTask extends StatefulWidget {
  final String docId;
  UpdateTask({super.key , required this.docId});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color _selectedColor = Colors.blue;
  File? file;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateToDb() async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(widget.docId).update({
        "title": titleController.text.trim(),
        "Description": descriptionController.text.trim(),
        "Date": selectedDate,
        "UpdatedAt": FieldValue.serverTimestamp(),
        "Color": rgbToHex(_selectedColor),
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An unexpected error occured")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 7,
        title: const Text('Add New Task' ,  style: TextStyle(color: Colors.white),),
        actions: [
          GestureDetector(
            onTap: () async {
              final selDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (selDate != null) {
                setState(() {
                  selectedDate = selDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat('MM-d-y').format(selectedDate) , style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // UNCOMMENT THIS in Firebase Storage section!

              // GestureDetector(
              //   onTap: () async {
              //     final image = await selectImage();
              //     setState(() {
              //       file = image;
              //     });
              //   },
              //   child: DottedBorder(
              //     borderType: BorderType.RRect,
              //     radius: const Radius.circular(10),
              //     dashPattern: const [10, 4],
              //     strokeCap: StrokeCap.round,
              //     child: Container(
              //       width: double.infinity,
              //       height: 150,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: file != null
              //           ? Image.file(file!)
              //           : const Center(
              //               child: Icon(
              //                 Icons.camera_alt_outlined,
              //                 size: 40,
              //               ),
              //             ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Title',
                  fillColor: Colors.white,
                  filled: true
                  ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Description',
                  fillColor: Colors.white,
                  filled: true
                  ),
                // maxLines: 3,
              ),
              const SizedBox(height: 10),
              ColorPicker(
                pickersEnabled: const {ColorPickerType.wheel: true},
                color: Colors.blue,
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                heading: const Text('Select color' , style: TextStyle(color: Colors.white),),
                subheading: const Text('Select a different shade' , style: TextStyle(color: Colors.white),),
                showMaterialName: true,
                materialNameTextStyle: const TextStyle(color: Colors.white),
                showColorName: true,
                colorNameTextStyle: const TextStyle(color: Colors.white), 
                borderColor: Colors.white
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await updateToDb(); 
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
