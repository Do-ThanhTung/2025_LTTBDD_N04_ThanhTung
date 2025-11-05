import 'package:flutter/material.dart';

class Truyen extends StatefulWidget {
  const Truyen({Key? key}) : super(key: key);

  @override
  @override
  State<Truyen> createState() => _TruyenState();
}

class _TruyenState extends State<Truyen> {
  bool isHidden1 =
      true; // Track the visibility of the first hidden box
  bool isHidden2 =
      true; // Track the visibility of the second hidden box
  bool isHidden3 = true;
  bool isHidden4 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Screen'),
      ),
      body: SingleChildScrollView(
        // Sử dụng SingleChildScrollView để bọc nội dung
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Lãng mạn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Image(
                  image: AssetImage(
                      'assets/images/story_image.jpg'),
                  width: 200,
                  height: 200),
              const SizedBox(height: 70),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle the visibility of the first hidden box
                    isHidden1 = !isHidden1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(
                      bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'An older couple was lying in bed one night. '
                    '\n The husband was falling asleep but the wife feelling '
                    'emotional and wanted to talk.',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isHidden1,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(
                      bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Một tối kia, một cặp vợ chồng có tuổi đang nằm trên giường.'
                        '\n Người chồng rơi vào giấc ngủ nhưng người vợ cảm thấy tình cảm'
                        ' đang dâng trong lòng và muốn nói chuyện',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the visibility of the first hidden box when its button is pressed
                            isHidden1 = !isHidden1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle the visibility of the second hidden box
                    isHidden2 = !isHidden2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'She said, "You used to hold my hand when we were dating."'
                    '\nWearily he reached across, help her hand for a second,'
                    ' then tired to get back to sleep.',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isHidden2,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Bà nói :"Anh thường cầm tay em khi chúng ta yêu nhau."'
                        '\n Một cách mệt mỏi, ông vươn ngang tay, cầm tay bà trong 1 giây,'
                        ' sau đó cố quay lại giấc ngủ ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the visibility of the second hidden box when its button is pressed
                            isHidden2 = !isHidden2;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle the visibility of the second hidden box
                    isHidden3 = !isHidden3;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'A few moments later she said,"Then you used to kiss me." '
                    'Mildly irritated, he reached across, gave her a peck on the'
                    'cheek and settled down to sleep',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isHidden3,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Một lát sau bà nói:"Sau đó anh thường hôn em."'
                        'Hơi bực dọc, ông vươn người qua, hôn vội một cái trên má '
                        'và nằm xuống ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the visibility of the second hidden box when its button is pressed
                            isHidden3 = !isHidden3;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle the visibility of the second hidden box
                    isHidden4 = !isHidden4;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Thirty seconds later she said,"Then you used to bite my ears."'
                    ' Anggrliy, he threw back the bed covers and got out of bed',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isHidden4,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Ba mươi giây sau, bà nói:"Sau đó anh thường cắn tai em." Điên'
                        ' tiết , ông quăng tấm trải xuống giường và'
                        ' nhảy ra khỏi giường.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the visibility of the second hidden box when its button is pressed
                            isHidden4 = !isHidden4;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
