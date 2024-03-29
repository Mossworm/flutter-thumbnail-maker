import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
                          SettingWidget(),
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
        maxWidth: 1280,
        maxHeight: 720,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
            context.watch<SelectedImage>().backgroundColor.r.toInt(),
            context.watch<SelectedImage>().backgroundColor.g.toInt(),
            context.watch<SelectedImage>().backgroundColor.b.toInt(),
            1),
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
          const Align(
            alignment: AlignmentDirectional(-0.6, 0.9),
            child: AddTextButton(),
          ),
          if (context.watch<SelectedImage>().bytesFromPicker != null)
            const Align(
              alignment: AlignmentDirectional(0.9, 0.9),
              child: GenerateButton(),
            ),
          if (context.watch<SelectedImage>().pageType == PageType.pickImage)
            AddIconPage(), // 스택 위젯 추가
          if (context.watch<SelectedImage>().pageType == PageType.addText)
            AddTextPage(), // 스택 위젯 추가
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
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        onPressed: () {
          context.read<SelectedImage>().setPageType(PageType.pickImage);
        },
        child: const Text(
          'Add Icon',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}

class AddTextButton extends StatelessWidget {
  const AddTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 59),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        onPressed: () {
          context.read<SelectedImage>().setPageType(PageType.addText);
        },
        child: const Text(
          'Add Text',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
      onPressed: () {
        context.read<SelectedImage>().downloadImage();
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
class SelectedIconPage extends StatefulWidget {
  const SelectedIconPage({super.key});

  @override
  State<SelectedIconPage> createState() => _SelectedIconPageState();
}

class _SelectedIconPageState extends State<SelectedIconPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.memory(context.watch<SelectedImage>().modifiedBytes!),
    );
  }
}

class AddIconPage extends StatelessWidget {
  AddIconPage({super.key});

  final myController = TextEditingController();

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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                                height: 53,
                                color: const Color.fromARGB(255, 235, 235, 235),
                                child: TextField(
                                  controller: myController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Icon URL',
                                  ),
                                )),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: () {
                                context
                                    .read<SelectedImage>()
                                    .pickImageFromUrl(myController.text);
                              },
                              child: const Text('Select',
                                  style: TextStyle(fontSize: 20))),
                        ],
                      ),
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

class AddTextPage extends StatelessWidget {
  AddTextPage({super.key});

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (context.watch<SelectedImage>().addTextString != null) {
      myController.text = context.watch<SelectedImage>().addTextString!;
    }

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
                maxWidth: 500,
                maxHeight: 200,
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
                        const Text('Add Text',
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  height: 100,
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    minLines: 3,
                                    maxLines: 3,
                                    controller: myController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Text',
                                    ),
                                  )),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 58),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                onPressed: () {
                                  context
                                      .read<SelectedImage>()
                                      .setAddText(myController.text);
                                  context
                                      .read<SelectedImage>()
                                      .setPageType(PageType.none);
                                },
                                child: const Text('Add',
                                    style: TextStyle(fontSize: 20))),
                          ],
                        ),
                      ),
                    ),
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
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      context.read<SelectedImage>().pickImageFromBytes();
                    },
                    child: const Text('Select File',
                        style: TextStyle(fontSize: 15))),
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

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  double currentValue = 300.0;

  Color pickerColor = const Color.fromARGB(255, 255, 255, 255);
  Color currentColor = const Color.fromARGB(255, 255, 255, 255);

  Color pickerTextColor = const Color.fromARGB(255, 0, 0, 0);
  Color currentTextColor = const Color.fromARGB(255, 0, 0, 0);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeTextColor(Color color) {
    setState(() => pickerTextColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 1280,
        maxHeight: 200,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 600,
            child: Slider(
                value: currentValue,
                max: 600,
                onChanged: (value) => setState(() {
                      currentValue = value;
                    })),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('색상 선택'),
                          content: SingleChildScrollView(
                              child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                          )),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                setState(() {
                                  currentColor = pickerColor;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Background Color',
                      style: TextStyle(fontSize: 30))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('색상 선택'),
                          content: SingleChildScrollView(
                              child: ColorPicker(
                            pickerColor: pickerTextColor,
                            onColorChanged: changeTextColor,
                          )),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                setState(() {
                                  currentTextColor = pickerTextColor;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child:
                      const Text('Text Color', style: TextStyle(fontSize: 30))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    setState(() {
                      currentValue = 300;
                    });
                  },
                  child: const Text('Default', style: TextStyle(fontSize: 30))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    context
                        .read<SelectedImage>()
                        .setBackgroundColor(currentColor);
                    context
                        .read<SelectedImage>()
                        .setTextColor(currentTextColor);
                    context
                        .read<SelectedImage>()
                        .imageResize(currentValue.toInt());
                  },
                  child: const Text('Apply', style: TextStyle(fontSize: 30))),
            ],
          ),
        ],
      ),
    );
  }
}
