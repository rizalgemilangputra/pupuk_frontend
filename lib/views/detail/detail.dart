import 'package:flutter/material.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/utils/MapUtils.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCollors.appBar,
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
              tag: 'homeHero-0',
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
                    const Text(
                      '12 Bulan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Jenis Pupuk'),
                    const Text(
                      'Organik Bokashi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Keterangan'),
                    const Text(
                      'Tempat Lokasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
