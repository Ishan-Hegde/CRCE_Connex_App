// ignore_for_file: avoid_print, use_build_context_synchronously, duplicate_ignore, unused_import, unused_local_variable

import 'dart:io'; // Add import for File
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart'; // Add import for getTemporaryDirectory
import '../../widgets/header.dart';

class AssignmentPg extends StatefulWidget {
  // ignore: use_super_parameters
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

  bool showOnlyChecked = false;

  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        File file = File(filePath);
        int fileSizeInBytes = await file.length();

        if (fileSizeInBytes <= 10 * 1024 * 1024) {
          // PDF size is under 10 MB
          String fileName = filePath.split('/').last;

          // Mark the corresponding assignment as checked
          setState(() {
            for (var item in items) {
              if (item.title == 'Assignment $fileName') {
                item.isDone = true;
                item.description = 'Checked';
              } else {
                item.isDone = false; // Uncheck other assignments
                item.description = 'Pending';
              }
            }
          });

          // Update uploaded file name above the upload button
          setState(() {
            uploadedFileName = fileName;
          });

          // Show snackbar for successful upload
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File uploaded successfully: $fileName'),
            ),
          );
        } else {
          // PDF size exceeds 10 MB, show error message
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

  @override
  Widget build(BuildContext context) {
    Text(
      uploadedFileName ?? 'No file uploaded',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
                    backgroundColor: const Color.fromARGB(255, 227, 70, 70),
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
                  crossAxisSpacing: 10.0,
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
            color: const Color.fromARGB(255, 227, 70, 70),
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
                  backgroundColor: const Color.fromARGB(255, 227, 70, 70),
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
