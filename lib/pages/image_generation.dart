import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bee_creative/models/creation.dart';
import 'package:bee_creative/widget/divider_with_text.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageGenerationPage extends StatefulWidget {
  final Function addCreationToCollection;

  const ImageGenerationPage({super.key, required this.addCreationToCollection});

  @override
  State<ImageGenerationPage> createState() => _ImageGenerationPageState();
}

class _ImageGenerationPageState extends State<ImageGenerationPage> {
  final TextEditingController promptController = TextEditingController();
  final TextEditingController seedController = TextEditingController();

  final dateFolder = DateTime.now();

  int imageSizeSelect = 0;
  int _maxLines = 2;
  int seed = 0;
  bool _isExpanded = false;
  bool isSeedRandom = true;
  bool isSizeEditable = false;
  bool isLoading = false;

  List<String> models = [
    "flux",
    "flux-realism",
    "flux-cablyai",
    "flux-anime",
    "flux-3d",
    "any-dark",
    "flux-pro",
    "turbo"
  ];

  String modelSelected = "flux";
  String imageUrl = "";

  int randomSeed = Random().nextInt(1000000000); //random seed

  Map<String, int> imageSize = {'width': 720, 'height': 1080};

  String generateImageUrl() {
    return "https://image.pollinations.ai/prompt/${promptController.text}?model=${modelSelected}&seed=${isSeedRandom ? "${randomSeed}" : seed}&width=${imageSize["width"]}&height=${imageSize["height"]}&nologo=true&private=true&enhance=false";
  }

  void generateImage() async {
    setState(() {
      isLoading = true;
      if (isSeedRandom) {
        randomSeed = Random().nextInt(1000000000);
      }
    });

    String tmpImageUrl = generateImageUrl();

    try {
      final response = await http.get(Uri.parse(tmpImageUrl));
      if (response.statusCode == 200) {
        setState(() {
          imageUrl = tmpImageUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate image: $e')),
      );
    } finally {
      // Set loading state to false
      setState(() {
        isLoading = false;
        tmpImageUrl = "";
      });
    }
  }

  void saveImageLocal() async {
    if (promptController.text == "") {
      return; // Prevent saving without a generated image
    }

    final folderNameUniq =
        "${dateFolder.day}_${dateFolder.month}_${dateFolder.year}-${dateFolder.hour}-${dateFolder.minute}-${dateFolder.second}";

    try {
      var response = await http.get(Uri.parse(imageUrl));

      Directory documentDirectory = Directory("");

      if (Platform.isAndroid) {
        documentDirectory = Directory(
            '/storage/emulated/0/Download/GeneratedImages/$folderNameUniq');
      } else if (Platform.isLinux) {
        documentDirectory = Directory(
            '${Platform.environment['HOME']}/Download/GeneratedImages/$folderNameUniq');
      }

      // Create the directory if it doesn't exist
      if (!await documentDirectory.exists()) {
        await documentDirectory.create(recursive: true);
      }

      File file = File(
          "${documentDirectory.path}/${promptController.text.substring(0, 3).trim()}${seed}_${Random().nextInt(1000000)}.jpg");
      await file.writeAsBytes(response.bodyBytes);

      widget.addCreationToCollection(Creation(
          promptController.text.substring(0, 5),
          promptController.text,
          modelSelected,
          file.path,
          imageSize["height"]!,
          imageSize['width']!,
          randomSeed,
          DateTime.now()));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            !isLoading
                ? Image.network(
                    imageUrl != ""
                        ? imageUrl
                        : "https://placehold.co/720x720.png",
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height / 2,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ))),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton.icon(
                  onPressed: () {
                    generateImage();
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.amber)),
                  label: const Text(
                    "Generate",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  icon: const Icon(Icons.emoji_nature)),
              IconButton(
                  onPressed: (imageUrl != "" &&
                          !isLoading &&
                          promptController.text != "")
                      ? saveImageLocal
                      : null,
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.amber)),
                  icon: const Icon(Icons.save)),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: _maxLines,
                controller: promptController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter prompt',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isExpanded) {
                          _maxLines = 2;
                        } else {
                          _maxLines = 5;
                        }
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
                  ),
                ),
              ),
            ),
            ExpansionTile(
              title: const Text("Settings"),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Text("Random Seed"),
                        Checkbox(
                          value: isSeedRandom,
                          onChanged: (bool? value) {
                            setState(() {
                              isSeedRandom = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: seedController,
                              keyboardType: TextInputType.number,
                              //This is for the input to always bee a number of 19 char (limits before the value is 0 in the onchanged)
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, //only number
                                LengthLimitingTextInputFormatter(
                                    19) //Limits size
                              ],
                              enabled: !isSeedRandom,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Seed',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  seed = int.tryParse(value) ??
                                      0; // Default if parsing fails
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    DividerWithText(label: "Image Size"),
                    Row(
                      children: [
                        const Icon(Icons.photo_size_select_large),
                        Checkbox(
                          value: isSizeEditable,
                          onChanged: (bool? value) {
                            if (isSizeEditable == true || value == true) {
                              setState(() {
                                imageSizeSelect = 0;
                                imageSize["width"] = 720;
                                imageSize["height"] = 1080;
                              });
                            }
                            setState(() {
                              isSizeEditable = value ?? false;
                            });
                          },
                        ),
                        ...isSizeEditable
                            ? [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, //only number
                                      LengthLimitingTextInputFormatter(4)
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'width',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        imageSize["width"] =
                                            int.tryParse(value) ?? 720;
                                      });
                                    },
                                  ),
                                ),
                                const Text(" X "),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, //only number
                                      LengthLimitingTextInputFormatter(4)
                                    ],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Height',
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        imageSize["height"] =
                                            int.tryParse(value) ?? 1080;
                                      });
                                    },
                                  ),
                                ),
                              ]
                            //if not resizable
                            : [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    value: imageSizeSelect,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Row(
                                          children: [
                                            Text("Portrait"),
                                            Icon(Icons.crop_portrait)
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Text("Box"),
                                            Icon(Icons.crop_square),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Text('Horizontal'),
                                            Icon(Icons.crop_landscape)
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        imageSizeSelect = value as int;
                                        if (!isSizeEditable) {
                                          switch (value) {
                                            case 0:
                                              setState(() {
                                                imageSize["width"] = 720;
                                                imageSize["height"] = 1080;
                                              });
                                              break;
                                            case 1:
                                              setState(() {
                                                imageSize["width"] = 1080;
                                                imageSize["height"] = 1080;
                                              });
                                              break;
                                            case 2:
                                              setState(() {
                                                imageSize["width"] = 1080;
                                                imageSize["height"] = 720;
                                              });
                                              break;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                    "${imageSize["width"]} X ${imageSize['height']}"),
                              ],
                      ],
                    ),
                    DividerWithText(label: "Ai Model"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Models :"),
                        DropdownButton(
                          value: modelSelected,
                          items: models.map((model) {
                            return DropdownMenuItem(
                              child: Text(model),
                              value: model,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              modelSelected = value as String;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
