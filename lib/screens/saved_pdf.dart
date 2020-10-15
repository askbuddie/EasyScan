import 'package:EasyScan/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:EasyScan/Utils/constants.dart';
import 'package:EasyScan/controllers/saved_pdf.dart';
import 'package:EasyScan/widgets/simple_option.dart';

class SavedPdfScreen extends StatelessWidget {
  final _savedPdfController = Get.find<SavedPdfController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: getBody,
    );
  }

  Widget get getBody {
    final _fileSystemEntitys = _savedPdfController.fileSystemEntitys;
    if (!_savedPdfController.isFilesChecked) {
      return const Center(child: CircularProgressIndicator());
    } else if (_fileSystemEntitys.isEmpty) {
      return const Center(
        child: Text(
          'No history found',
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => OpenFile.open(_fileSystemEntitys[i].path),
            onLongPress: () {
              showDialog(
                  context: _,
                  child: SimpleDialog(
                    title: const Text("Do you want to"),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          _savedPdfController.share(i);
                        },
                        child: const SimpleDlgOption(
                            title: "Share",
                            iconData: Icons.share_outlined,
                            color: primaryColor),
                      ),
                      SimpleDialogOption(
                          onPressed: () {
                            _savedPdfController.deleteFile(i);
                            _savedPdfController.refreshFiles();
                            Get.to(HomeScreen());
                          },
                          child: const SimpleDlgOption(
                            color: Colors.red,
                            title: "Delete",
                            iconData: Icons.delete_outline_sharp,
                          ))
                    ],
                  ));
            },
            child: Container(
                color: primaryColor.withOpacity(0.2),
                margin: const EdgeInsets.all(10),
                height: 200,
                width: 200,
                child: Center(child: Text("Pdf #${i + 1}"))),
          );
        },
        itemCount: _fileSystemEntitys.length,
      );
    }
  }
}
