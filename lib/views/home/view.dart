// ignore_for_file: use_build_context_synchronously

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/blocs/tanaman/tanaman_bloc.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/models/tanaman_model.dart';
import 'package:pupuk_frontend/repository/tanaman_repository.dart';
import 'package:pupuk_frontend/utils/asset_constants.dart';
import 'package:pupuk_frontend/utils/camera/Camera.dart';
import 'package:pupuk_frontend/widgets/listing_icon_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TanamanBloc _tanamanBloc = TanamanBloc();
  final LocalStorage _localStorage = LocalStorage(AppConfig.localStorageName);
  final bool _shouldPop = false;
  bool _showGrid = true;
  late Size _size;
  late List<TanamanModel> _dataTanaman;

  @override
  void initState() {
    _tanamanBloc.add(GetTanamanList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Pupuk'),
        backgroundColor: AppStyle.appBar,
        automaticallyImplyLeading: false,
        actions: [
          buildListingIcon(
            AssetsConsts.icGrid,
            () {
              if (_showGrid) {
                return;
              } else {
                _tanamanBloc.add(ShowInGridEvent());
              }
            },
          ),
          buildListingIcon(
            AssetsConsts.icList,
            () {
              if (!_showGrid) {
                return;
              } else {
                _tanamanBloc.add(ShowInListEvent());
              }
            },
          ),
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
        child: WillPopScope(
            child: _bodyPage(),
            onWillPop: () async {
              return _shouldPop;
            }),
      ),
      floatingActionButton: _floatingButtonAction(),
    );
  }

  Widget _floatingButtonAction() {
    return TweenAnimationBuilder<Offset>(
      tween:
          Tween<Offset>(begin: const Offset(0, -800), end: const Offset(0, 0)),
      duration: const Duration(seconds: 2),
      curve: Curves.bounceInOut,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: FloatingActionButton(
        onPressed: () async {
          final callBack = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CameraPage()),
          );
          if (callBack == true) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Berhasil",
                text: "Anda berhasil menambah data",
              ),
            );
            setState(() {
              _tanamanBloc.add(GetTanamanList());
            });
          }
        },
        backgroundColor: AppStyle.appBar,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _bodyPage() {
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
            } else if (state is ShowInViewState) {
              _showGrid = state.inGrid;
              return _listTanaman(context, _dataTanaman);
            } else if (state is TanamanLoaded) {
              _dataTanaman = state.tanamanModel;
              return _listTanaman(context, _dataTanaman);
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
    if (_showGrid) {
      return _buildGridView(context, tanamanList);
    } else {
      return _buildListView(context, tanamanList);
    }
  }

  Widget _buildListView(BuildContext context, List<TanamanModel> tanamanList) {
    return ListView.builder(
      itemCount: tanamanList.length,
      itemBuilder: (context, index) {
        TanamanModel tanaman = tanamanList[index];
        return GestureDetector(
          onLongPress: () async {
            HapticFeedback.vibrate();
            TanamanRepository tanamanRepository = TanamanRepository();

            ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                denyButtonText: "tidak",
                title: "Peringatan",
                text: "Anda akan menghapus data ini?",
                confirmButtonText: "Ya",
                type: ArtSweetAlertType.warning,
              ),
            );

            // ignore: unnecessary_null_comparison
            if (response == null) {
              return;
            }

            if (response.isTapConfirmButton) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 15),
                          Text('Loading')
                        ],
                      ),
                    ),
                  );
                },
              );
              await tanamanRepository.deleteTanaman(tanaman.id).then((value) {
                if (value['code'] == 201) {
                  Navigator.pop(context);
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: 'Berhasil menghapus data'),
                  );
                } else {
                  Navigator.pop(context);
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.danger,
                        title: 'Gagal menghapus data'),
                  );
                }
              });
              _tanamanBloc.add(GetTanamanList());
            }
          },
          onTap: () {
            Navigator.pushNamed(context, '/home/detail', arguments: tanaman);
          },
          child: GFListTile(
            padding: const EdgeInsets.all(0),
            color: Colors.white,
            description: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Umur '),
                    Text(
                      '${tanaman.umur}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pupuk '),
                    Text(
                      '${tanaman.namaPupuk}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dosis '),
                    Text(
                      '${tanaman.dosis}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Update '),
                    Text(
                      '${tanaman.updatedAt}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('Lihat Detail',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            avatar: GFAvatar(
              maxRadius: 50,
              minRadius: 50,
              child: Hero(
                tag: 'imgHero-${tanaman.id}',
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(tanaman.gambar.toString())),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<TanamanModel> tanamanList) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.4,
        mainAxisSpacing: _size.height * 0.01,
        crossAxisSpacing: _size.height * 0.01,
      ),
      itemCount: tanamanList.length,
      itemBuilder: (BuildContext context, index) {
        TanamanModel tanaman = tanamanList[index];
        return GestureDetector(
          onLongPress: () async {
            HapticFeedback.vibrate();
            TanamanRepository tanamanRepository = TanamanRepository();

            ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                denyButtonText: "tidak",
                title: "Peringatan",
                text: "Anda akan menghapus data ini?",
                confirmButtonText: "Ya",
                type: ArtSweetAlertType.warning,
              ),
            );

            // ignore: unnecessary_null_comparison
            if (response == null) {
              return;
            }

            if (response.isTapConfirmButton) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 15),
                          Text('Loading')
                        ],
                      ),
                    ),
                  );
                },
              );
              await tanamanRepository.deleteTanaman(tanaman.id).then((value) {
                if (value['code'] == 201) {
                  Navigator.pop(context);
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: 'Berhasil menghapus data'),
                  );
                } else {
                  Navigator.pop(context);
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.danger,
                        title: 'Gagal menghapus data'),
                  );
                }
              });
              _tanamanBloc.add(GetTanamanList());
            }
          },
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
                    child: Image.network(
                      tanaman.gambar.toString(),
                      fit: BoxFit.cover,
                    ),
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
