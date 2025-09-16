import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
                'My Presyo App => About App',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyGroceryFont',
                  fontSize: 30,
                ),
              ),
            ),
            const Icon(Icons.shopping_cart_outlined),
          ],
        ),
      ),

      body: Center(
        child: Card(
          elevation: 8,
          color: Colors.white,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "📝 About My Presyo App",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GochiHand',
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Nalilimutan mo rin ba ang presyo ng mga groceries mo?, "
                  "Ako kasi Oo, "
                  "Dito pwede mong ilista ang presyo ng bawat aytem sa kanya-kanyang kategorya. "
                  "Kasi pa-mahal nang pa-mahal ang mga bilihin ngayon.",
                  style: const TextStyle(fontSize: 20, fontFamily: 'GochiHand'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[300],
                    foregroundColor: Colors.grey[900],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Back to Main",
                    style: TextStyle(fontSize: 20, fontFamily: 'GochiHand'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
