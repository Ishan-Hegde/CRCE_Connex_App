import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AssignmentPg extends StatefulWidget {
  const AssignmentPg({Key? key}) : super(key: key);

  @override
  AssignmentUI createState() => AssignmentUI();
}

class Item {
  IconData icon;
  String title;
  bool isDone = false;
  String buttonText = "Upload";

  Item({
    required this.icon,
    required this.title,
  });
}

class AssignmentUI extends State<AssignmentPg> {
  final List<Item> items = List.generate(
    10,
    (index) => Item(
      icon: Icons.assignment,
      title: 'Assignment ${index + 1}',
    ),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showOnlyChecked = false;

  Future<void> _openFileExplorer(Item item) async {
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
          setState(() {
            item.isDone = true;
            item.buttonText = fileName; // Update button text to fileName
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

  Future<void> _showUnsubmitDialog(Item item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsubmit Assignment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to unsubmit and delete the uploaded PDF?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  item.isDone = false;
                  item.buttonText = "Upload";
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Unsubmit',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  childAspectRatio: 0.78,
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
    return GestureDetector(
      onTap: () {
        if (item.isDone) {
          _showUnsubmitDialog(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
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
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 18), // Adjust space for visual alignment
            Row(
              children: [
                if (!item.isDone)
                  ElevatedButton(
                    onPressed: () => _openFileExplorer(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB6002B),
                      padding: EdgeInsets.symmetric(
                          vertical: 13), // Adjust button height
                    ),
                    child: Text(
                      item.buttonText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                if (item.isDone)
                  Expanded(
                    child: Text(
                      item.buttonText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFB6002B),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Checkbox(
                  value: item.isDone,
                  onChanged: (bool? newValue) {},
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
