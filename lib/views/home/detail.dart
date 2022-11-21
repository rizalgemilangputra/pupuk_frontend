import 'package:flutter/material.dart';
import 'package:pupuk_frontend/constants.dart';

class DetailPage extends StatefulWidget {
  final dynamic tanaman;
  const DetailPage({Key? key, this.tanaman}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.appBar,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // MapUtils.openMap(-6.886863, 107.615311);
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.pin_drop,
          color: Colors.red,
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 50),
            child: Hero(
              tag: 'imgHero-${widget.tanaman.id}',
              child: Image.asset('assets/images/sawit.jpeg'),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Umur'),
                    Text(
                      widget.tanaman.umur.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Jenis Pupuk'),
                    Text(
                      widget.tanaman.namaPupuk,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      'Keterangan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.tanaman.keterangan,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
