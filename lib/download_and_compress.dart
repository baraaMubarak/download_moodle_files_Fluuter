import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:download_moodle_file/static_data/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:universal_html/html.dart' as html;

Future<void> downloadAndCompressFiles(
  List data,
  void Function(String status) status,
) async {
  final dio = Dio();
  final archive = Archive();
  String courseName = '';
  String sectionName = '';
  String statusCourseName = '';
  String statusSectionName = '';
  String statusFile = '';

  for (int courseIndex = 0; courseIndex < data.length; courseIndex++) {
    courseName = _reWriteFileName(data[courseIndex]['courseName']);
    archive.addFile(ArchiveFile.noCompress('$courseName/', 0, Uint8List(0)));
    statusCourseName = 'جارٍ تحضير مساق $courseName';
    status(statusCourseName);
    // Logger().d(archive);
    for (int sectionIndex = 0; sectionIndex < data[courseIndex]['sections'].length; sectionIndex++) {
      sectionName = _reWriteFileName(data[courseIndex]['sections'][sectionIndex]['sectionName']);
      archive.addFile(ArchiveFile.noCompress('$courseName/$sectionName/', 0, Uint8List(0)));
      statusSectionName = 'قسم: $sectionName';
      status('$statusCourseName\n$statusSectionName');
      int sectionContentLength = 0;
      try {
        sectionContentLength = data[courseIndex]['sections'][sectionIndex]['sectionContent'].length;
        // ignore: empty_catches
      } catch (e) {}
      for (int contentIndex = 0; contentIndex < sectionContentLength; contentIndex++) {
        Map<String, String?> fileInfo = data[courseIndex]['sections'][sectionIndex]['sectionContent'][contentIndex];
        statusFile = 'جار تحميل ${fileInfo['fileName']}';
        status('$statusCourseName\n$statusSectionName\n$statusFile');
        final response = await dio.get(fileInfo['fileLink'] ?? '', options: Options(responseType: ResponseType.bytes));
        String ext = '.doc';
        /*
          || fileType == 'document'
           */
        if (fileInfo['fileType'] == 'pdf') {
          ext = '.pdf';
        } else if (fileInfo['fileType'] == 'powerpoint') {
          ext = '.pptx';
        }
        final archiveFile = ArchiveFile(
          '$courseName/$sectionName/${_reWriteFileName(fileInfo['fileName'] ?? '')}$ext',
          response.data.length,
          response.data,
        );
        archive.addFile(archiveFile);
      }
    }
  }
  status('تم تجميع جميع ملفاتك بنجاح، نقوم الآن بضغط الملفات لتصبح جاهزه');
  final zipData = ZipEncoder().encode(archive);
  status('تم ضغط الملفات بنجاح، نقوم الان بتنزيل الملفات على جهازك');

  // You can save the zipData to a file or perform other actions here
  // Create a Blob from the zipData
  final blob = html.Blob([Uint8List.fromList(zipData!)]);

  // Create a URL for the Blob
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create a download link
  final anchor = html.AnchorElement(href: url)
    ..target = 'blob'
    ..download = 'Moodle.zip' // Specify the download file name
    ..text = 'Download Zip'
    ..click();

  // Append the anchor to the body (or any other element)
  html.document.body?.children.add(anchor);
  status(done);
  // Clean up after download
  html.Url.revokeObjectUrl(url);
  Logger().i('Files downloaded and compressed successfully');
}

String _reWriteFileName(String fileName) {
  fileName = fileName.replaceAll('\\', '-');
  fileName = fileName.replaceAll('/', '-');
  fileName = fileName.replaceAll(':', '-');
  fileName = fileName.replaceAll('*', '-');
  fileName = fileName.replaceAll('?', '-');
  fileName = fileName.replaceAll('"', '-');
  fileName = fileName.replaceAll('<', '-');
  fileName = fileName.replaceAll('>', '-');
  fileName = fileName.replaceAll('|', '-');
  return fileName;
}
