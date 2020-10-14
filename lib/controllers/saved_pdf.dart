import 'dart:io' as dd;
import 'package:get/get.dart';
import 'package:EasyScan/Utils/constants.dart';
import 'package:EasyScan/Utils/permission_checker.dart';
import 'package:share/share.dart';

class SavedPdfController extends GetxController {
  final _isFilesChecked = false.obs;
  final fileSystemEntitys = <dd.FileSystemEntity>[].obs;
  dd.Directory _savedDir;

  bool get isFilesChecked => _isFilesChecked.value;

  @override
  void onInit() {
    _getPaths();
  }

  void refreshFiles() {
    _getPaths();
  }

  Future<void> _getFileList() async {
    if (_savedDir != null) {
      fileSystemEntitys.value = _savedDir.listSync();
      _isFilesChecked.value = true;
    }
  }

  Future<void> _getPaths() async {
    final _per = await permision.checkPermission();
    if (_per) {
      _savedDir = dd.Directory(pdfPathAndroid);
      final _exist = await _savedDir.exists();
      if (_exist) await _getFileList();
    }
  }

  Future<void> deleteFile(int index) async {
    final String filename = fileSystemEntitys[index]
        .toString()
        .split('/')[4]
        .toString()
        .split("'")[0];
    try {
      final file = dd.File('storage/emulated/0/Easy Scan/$filename');
      if (await file.exists()) {
        await file.delete(recursive: true);
      }
    } catch (e) {
      // error in getting access to the file
    }
  }

  void share(int index) {
    final String filename = fileSystemEntitys[index]
        .toString()
        .split('/')[4]
        .toString()
        .split("'")[0];
    Share.shareFiles(['storage/emulated/0/Easy Scan/$filename'], text: 'mypdf');
  }
}
