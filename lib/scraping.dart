import 'package:chaleno/chaleno.dart';
import 'package:download_moodle_file/errors/exceptions.dart';
import 'package:download_moodle_file/static_data/strings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<List<Map>> scraping(void Function(String status) status) async {
  List<Map> scrapingResult = [];
  DateTime start = DateTime.now();
  Logger().i('Start Scraping...');
  status('يجري الآن التأكد من أنك قمت بتسجيل الدخول الى المودل\nوفي حال كنت بالفعل مسجل الدخول سوف نقوم بقراءة الصفحة الرئيسية\nهذه العملية هي الأطول 🥲');
  var parser = await Chaleno().load('https://corsproxy.io?https://moodle.iugaza.edu.ps/my');
  late final title;
  try {
    title = parser?.getElementsByClassName('list-group').last;
  } catch (e) {
    status(pleaseLogin);
    throw AuthException();
  }
  status('تم التأكد من أنك قد سجلت الدخول\nيجري الآن قراءة المساقات الخاصة بك');
  final a = title!.querySelector('ul');
  if (a != null) {
    final b = title.querySelectorAll('a');
    for (int j = 4; j < b!.length; j++) {
      if (b[j] != 0) {
        var parser2 = await Chaleno().load('https://corsproxy.io?' + b[j].href!);
        status('يجري الان قراءة محتوى مساق ${parser2!.querySelector('title').text!.substring(8)}');
        scrapingResult.add({
          'courseName': parser2.querySelector('title').text!.substring(8),
        });
        final sections = parser2.querySelectorAll('.section');
        int sectionCounter = -1;
        for (int x = 0; x < sections.length; x++) {
          final sectionDetails = sections[x].querySelector('.sectionname');
          if (sectionDetails != null) {
            sectionCounter++;
            // print(sectionDetails.text); /// sections
            status('يجري الان قراءة محتوى مساق ${parser2.querySelector('title').text!.substring(8)}\n'
                'قسم: ${sectionDetails.text}');
            if (scrapingResult[j - 4]['sections'] == null) {
              scrapingResult[j - 4]['sections'] = <Map<String, dynamic>>[
                {
                  'sectionName': sectionDetails.text as dynamic,
                }
              ];
            } else {
              (scrapingResult[j - 4]['sections'] as List).add({
                'sectionName': sectionDetails.text as dynamic,
              });
            }
            final fileSections = parser2.querySelectorAll('#${sections[x].id} .aalink');
            for (int r = 0; r < fileSections.length; r++) {
              final fileType = fileSections[r].querySelector('img')!.src!.split("/").last.split("-")[0];
              final fileName = fileSections[r].querySelector('.instancename')!.text;
              final fileName2 = fileSections[r].querySelector('.instancename span')!.text;
              if (fileType == 'pdf' || fileType == 'document' || fileType == 'powerpoint') {
                if (scrapingResult[j - 4]['sections'][sectionCounter]['sectionContent'] == null) {
                  scrapingResult[j - 4]['sections'][sectionCounter]['sectionContent'] = [
                    {
                      'fileLink': 'https://corsproxy.io?${fileSections[r].href}',
                      'fileType': fileType,
                      'fileName': fileName!.replaceFirst(fileName2.toString(), '').toString(),
                    }
                  ];
                } else {
                  (scrapingResult[j - 4]['sections'][sectionCounter]['sectionContent'] as List).add({
                    'fileLink': 'https://corsproxy.io?${fileSections[r].href}',
                    'fileType': fileType,
                    'fileName': fileName!.replaceFirst(fileName2.toString(), ''),
                  });
                }
              }
            }
          }
        }

        /// end the course
      }
    }
    Logger().d(scrapingResult);
  }
  status(' تم قراءة صفحة المودل الخاصة بك بنجاح، الان سوف نقوم بضغط الملفات وتنزيلها\n شكرا على وقتك الثمين');
  Logger().i('End Scraping... at : ${DateTimeRange(start: start, end: DateTime.now()).duration.inSeconds} seconds');
  return scrapingResult;
}
