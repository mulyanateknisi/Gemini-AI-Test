part of 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GEMINI AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your request here',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: image == null ? Colors.grey.shade200 : null,
                    image: image != null
                        ? DecorationImage(image: FileImage(File(image!.path)))
                        : null),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                        (value) => setState(
                          () {
                            image = value;
                          },
                        ),
                      );
                },
                child: const Text("Select Image"),
              ),
              ElevatedButton(
                onPressed: () {
                  GenerativeModel generativeModel = GenerativeModel(
                      model: 'gemini-1.5-flash-latest', apiKey: apiKey);
                  // generativeModel.generateContent(
                  //   [Content.text(textEditingController.text)],
                  // ).then(
                  //   (value) => setState(
                  //     () {
                  //       answer = value.text.toString();
                  //     },
                  //   ),
                  // );
                  generativeModel.generateContent(
                    [
                      Content.multi(
                        [
                          TextPart(textEditingController.text),
                          if (image != null)
                            DataPart(
                              'image/jpeg',
                              File(image!.path).readAsBytesSync(),
                            )
                        ],
                      )
                    ],
                  ).then(
                    (value) => setState(() {
                      answer = value.text.toString();
                    }),
                  );
                },
                child: const Text("Send "),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(answer),
            ],
          ),
        ),
      ),
    );
  }
}
