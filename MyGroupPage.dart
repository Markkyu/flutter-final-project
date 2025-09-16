import 'package:flutter/material.dart';

class MyGroupPage extends StatelessWidget {
  const MyGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 186),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow[300],
        foregroundColor: Colors.grey[900],
        elevation: 5.0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'My Presyo App => Members',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyGroceryFont',
                  fontSize: 30,
                ),
              ),
            ),
            const Icon(Icons.group),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 40),
          CenteredMemberCard("Marc Joel Baldoz", "MarcJoelBaldoz_pfp.png"),
          CenteredMemberCard("Emmanuel Junior Ona", "EmmanuelOna_pfp.png"),
        ],
      ),
    );
  }
}

Widget CenteredMemberCard(memberName, imageLink) {
  return Center(
    child: Card(
      elevation: 8,
      color: Colors.white,
      margin: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/$imageLink', width: 150, height: 150),
            Text(
              "$memberName",
              style: TextStyle(
                fontSize: 28,
                // fontWeight: FontWeight.bold,
                fontFamily: 'GochiHand',
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
