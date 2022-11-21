import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/blocs/tanaman/tanaman_bloc.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/models/tanaman_model.dart';
import 'package:pupuk_frontend/utils/camera/Camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TanamanBloc _tanamanBloc = TanamanBloc();
  final LocalStorage _localStorage = LocalStorage(AppConfig.localStorageName);

  @override
  void initState() {
    _tanamanBloc.add(GetTanamanList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Pupuk'),
        backgroundColor: AppStyle.appBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await _localStorage.setItem('is_login', false);
              await _localStorage.setItem('X-Auth-Token', null);

              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: _gridPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CameraPage()),
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _gridPage() {
    return BlocProvider(
      create: (_) => _tanamanBloc,
      child: BlocListener<TanamanBloc, TanamanState>(
        listener: (context, state) {
          if (state is TanamanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
        },
        child: BlocBuilder<TanamanBloc, TanamanState>(
          builder: (context, state) {
            if (state is TanamanInitial) {
              return _buildLoading();
            } else if (state is TanamanLoading) {
              return _buildLoading();
            } else if (state is TanamanLoaded) {
              return _listTanaman(context, state.tanamanModel);
            } else if (state is TanamanError) {
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _listTanaman(BuildContext context, List<TanamanModel> tanamanList) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.2,
      ),
      itemCount: tanamanList.length,
      itemBuilder: (BuildContext context, index) {
        TanamanModel tanaman = tanamanList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/home/detail', arguments: tanaman);
          },
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Hero(
                  tag: 'imgHero-${tanaman.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.asset('assets/images/sawit.jpeg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Update :',
                        style: TextStyle(
                          color: Color.fromARGB(137, 27, 27, 27),
                        ),
                      ),
                      Text(tanaman.updatedAt.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
