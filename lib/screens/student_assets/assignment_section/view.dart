import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AssignmentPg extends StatefulWidget {
  const AssignmentPg({Key? key}) : super(key: key);

  @override
  AssignmentUI createState() => AssignmentUI();
}

class Item {
  IconData icon;
  String title;
  String description;
  bool isDone = false;

  Item({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class AssignmentUI extends State<AssignmentPg> {
  String? uploadedFileName;
  final List<Item> items = List.generate(
    10,
    (index) => Item(
      icon: Icons.assignment,
      title: 'Assignment ${index + 1}',
      description: 'Pending',
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showOnlyChecked = false;

  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        File file = File(filePath); // Create the File object
        String fileName = filePath.split('/').last; // Define fileName here

        int fileSizeInBytes = await file.length();

        if (fileSizeInBytes <= 10 * 1024 * 1024) {
          Item? uploadedItem = items.firstWhereOrNull(
            (item) => item.title == 'Assignment ${fileName.split(".")[0]}',
          );

          if (uploadedItem != null) {
            setState(() {
              uploadedItem.isDone = true;
              uploadedItem.description = 'Checked';
            });
          }

          setState(() {
            uploadedFileName = fileName;
          });

          await _updateAssignmentStatus(
              fileName, true, file); // Pass the file argument

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File uploaded successfully: $fileName'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10 MB limit.'),
            ),
          );
        }
      } else {
        print('User canceled the picker');
      }
    } on PlatformException catch (e) {
      print('Error picking file: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: ${e.message}'),
        ),
      );
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
        ),
      );
    }
  }

  Future<void> _updateAssignmentStatus(
      String assignmentTitle, bool isDone, File uploadedFile) async {
    try {
      // Upload the file to Firestore storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('uploads/$assignmentTitle.pdf');
      UploadTask uploadTask = storageReference.putFile(uploadedFile);
      await uploadTask.whenComplete(() async {
        // Get the download URL for the file
        String fileURL = await storageReference.getDownloadURL();

        // Update assignment status and store file URL in Firestore
        await _firestore.collection('assignments').doc(assignmentTitle).update({
          'isDone': isDone,
          'fileURL': fileURL, // Store the file URL in Firestore
        });

        print('Assignment status updated in Firestore');
      });
    } catch (e) {
      print('Error updating assignment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Text(
      uploadedFileName ?? 'No file uploaded',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // ignore: unused_local_variable
    String title = args?['title'] ?? 'Assignments';

    List<Item> filteredItems =
        showOnlyChecked ? items.where((item) => item.isDone).toList() : items;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOnlyChecked = !showOnlyChecked;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFB6002B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showOnlyChecked ? 'Show All' : 'Show Checked',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        showOnlyChecked
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.77,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return buildItem(context, filteredItems[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Item item) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: 60,
            color: const Color(0xFFB6002B),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _openFileExplorer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB6002B),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    item.isDone = !item.isDone;
                    print('Item ${item.title} isDone: ${item.isDone}');
                  });
                },
                child: Stack(
                  children: [
                    const Icon(
                      Icons.check_box_outline_blank,
                      size: 40,
                      color: Colors.grey,
                    ),
                    if (item.isDone)
                      const Positioned(
                        top: 3,
                        left: 3,
                        child: Icon(
                          Icons.check,
                          size: 34,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
