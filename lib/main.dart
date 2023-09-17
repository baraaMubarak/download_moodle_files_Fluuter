import 'package:download_moodle_file/static_data/strings.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import 'download_and_compress.dart';
import 'errors/exceptions.dart';
import 'scraping.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:html/parser.dart' as parser;
// import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = '';

  late VideoPlayerController _controller;
  bool buttonVisibility = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/background.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {});
        // Loop the video
        _controller.setLooping(true);
        _controller.setPlaybackSpeed(0.5);
        _controller.setVolume(0.0);

        // Start playing
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Download File From Moodle',
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width ?? 0,
                    height: _controller.value.size.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    const Text(
                      'تحميل ملفات المودل',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.withOpacity(0.3),
                        ),
                        onPressed: !buttonVisibility
                            ? null
                            : () async {
                                try {
                                  setState(() {
                                    buttonVisibility = false;
                                  });
                                  List data = await scraping(
                                    (state) {
                                      setState(() {
                                        status = state;
                                        buttonVisibility = state == pleaseLogin;
                                      });
                                    },
                                  );
                                  await downloadAndCompressFiles(
                                    data,
                                    (state) {
                                      setState(() {
                                        status = state;
                                        buttonVisibility = state == done;
                                      });
                                    },
                                  );
                                } on AuthException {
                                  setState(() {
                                    status = pleaseLogin;
                                  });
                                }
                                // await scraping();
                              },
                        child: const Text(
                          'تحميل ملفاتي',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (status.isNotEmpty)
                      const Text(
                        'حالة العملية',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Visibility(
                      visible: status == pleaseLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              html.window.open('https://moodle.iugaza.edu.ps/my/', '_blank');
                            },
                            child: Text('يمكنك الذهاب الى المودل بالنقر هنا'),
                          ),
                          const Text(
                            'أو يمكنك الذهاب اليه من خلال تبويب اخر',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'قطعاً لايتم مشاركة اي بيانات مع أي جهات خارجية، ولا يتم حفظها الا في جهازك هذا',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'This webPage was built by Baraa M Mubarak\nCopyrights are not reserved. Haha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
