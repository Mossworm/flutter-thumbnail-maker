import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_thumbnail_maker/providers/selected_image.dart';
import 'package:flutter_thumbnail_maker/widgets/upcoming_feature_text.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SelectedImage()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Thumbnail Maker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SelectedImage(),
        child: const SafeArea(
          child: SelectionArea(
            child: SingleChildScrollView(
              child: Center(
                heightFactor: 1,
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          TitleWidget(),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: GenerateThumbnailWidget(),
                          ),
                        ],
                      ),
                    ),
                    UpcomingFeaturesTextWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Flutter Thumbnail Maker',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        FlutterLogo(size: 50)
      ],
    );
  }
}

class GenerateThumbnailWidget extends StatefulWidget {
  const GenerateThumbnailWidget({super.key});

  @override
  State<GenerateThumbnailWidget> createState() =>
      _GenerateThumbnailWidgetState();
}

class _GenerateThumbnailWidgetState extends State<GenerateThumbnailWidget> {
  Widget? stackWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (context.watch<SelectedImage>().bytesFromPicker == null)
            const EmptyPage()
          else
            const SelectedIconPage(),
          const Align(
            alignment: AlignmentDirectional(-0.9, 0.9),
            child: AddIconButton(),
          ),
          if (context.watch<SelectedImage>().bytesFromPicker != null)
            const Align(
              alignment: AlignmentDirectional(0.9, 0.9),
              child: GenerateButton(),
            ),
          if (context.watch<SelectedImage>().pageType == PageType.pickImage)
            const AddIconPage(), // 스택 위젯 추가
        ],
      ),
    );
  }
}

class AddIconButton extends StatelessWidget {
  const AddIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<SelectedImage>().setPageType(PageType.pickImage);
        },
        child: const Text(
          'Add Icon',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //TODO: context.watch<SelectedImage>().image 의 이미지를 화면중앙에 놓고 1280x720 크기의 흰색 배경화면을 만들어서 이미지를 합성한후 다운로드 하는 기능
        context.read<SelectedImage>().downloadImage(context);
      },
      child: const Text('Generate',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}

// 아무 아이콘도 설정안된 페이지
class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file_sharp,
              size: 120, color: Color.fromARGB(255, 228, 228, 228)),
          Text('Generate thumbnail',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 98, 98, 98))),
        ],
      ),
    );
  }
}

// 아이콘이 설정된 페이지
class SelectedIconPage extends StatelessWidget {
  const SelectedIconPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.memory(context.watch<SelectedImage>().bytesFromPicker!),
    );
  }
}

class AddIconPage extends StatelessWidget {
  const AddIconPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SelectedImage>().setPageType(PageType.none);
      },
      child: Container(
        color: const Color.fromARGB(255, 98, 98, 98).withOpacity(0.6),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 450,
                maxHeight: 300,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add Icon',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<SelectedImage>()
                                  .setPageType(PageType.none);
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    const Expanded(child: GetImageWidget()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetImageWidget extends StatefulWidget {
  const GetImageWidget({super.key});

  @override
  State<GetImageWidget> createState() => _GetImageWidgetState();
}

class _GetImageWidgetState extends State<GetImageWidget> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) async {
        debugPrint('onDragDone');
        if (details.files.isNotEmpty) {
          Uint8List fileBytes = await details.files.first.readAsBytes();
          // ignore: use_build_context_synchronously
          context.read<SelectedImage>().setBytesFromPicker(fileBytes);
          await details.files.first.readAsBytes();
        }
      },
      onDragEntered: (details) async {
        debugPrint('onDragEntered');
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (details) async {
        debugPrint('onDragExited');
        setState(() {
          _dragging = false;
        });
      },
      child: DottedBorder(
        dashPattern: const [6],
        color: Colors.black,
        strokeWidth: 1,
        child: Stack(
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload_file_sharp,
                    size: 50, color: Color.fromARGB(255, 228, 228, 228)),
                const Text('Drag and drop file upload',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 98, 98, 98))),
                const Text('or'),
                ElevatedButton(
                    onPressed: () {
                      context.read<SelectedImage>().pickImageFromBytes();
                    },
                    child: const Text('Select File')),
              ],
            )),
            if (_dragging)
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }
}
