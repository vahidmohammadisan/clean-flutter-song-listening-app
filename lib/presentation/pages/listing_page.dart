import 'package:azeri/presentation/pages/play_music.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/music_bloc.dart';
import '../bloc/music_event.dart';
import '../bloc/music_state.dart';

class ListingPage extends StatelessWidget {
  ListingPage({this.onPressed});

  final onPressed;
  var page = 1;

  @override
  Widget build(BuildContext context) {
    context.read<MusicBloc>().add(GetMusic(page.toString()));
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        /*Container(
          color: Colors.amber,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white.withOpacity(0.1)),
                    child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        onChanged: (value) {
                          //search
                          // context.read<MusicBloc>().add(GetMusic("2"));
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Song ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: MaterialButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )),
              )
            ],
          ),
        )*/
        AppBar(
          backgroundColor: Colors.amber,
          title: const Text(
            "Azeri",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Search"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Show Downloaded"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("About"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
              } else if (value == 1) {
              } else if (value == 2) {}
            }),
          ],
        ),
        BlocBuilder<MusicBloc, MusicState>(builder: (context, state) {
          if (state is MusicLoading) {
            return Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                    color: Colors.amber, size: 70));
          } else if (state is MusicData) {
            return Expanded(
              child: ListView.builder(
                  itemCount: state.music.musicList.length,
                  itemBuilder: (context, position) {
                    return state.music.musicList.isEmpty
                        ? const Center(
                            child: Text('Oops!, No '
                                'Result Found.'))
                        : Column(
                            children: [
                              ListTile(
                                isThreeLine: true,
                                onTap: () => Get.to(PlayMusic(
                                    music: state.music.musicList[position])),
                                dense: false,
/*                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(state
                                          .events
                                          .events[position]
                                          .performers[0]
                                          .image ??
                                      'https://montessoriinthewoods.org/wp-content/uploads/2018/02/image-placeholder-500x500.jpg'),
                                ),*/
                                title: Text(
                                  state.music.musicList[position].Name
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.music.musicList[position].Link),
                                    Text(state.music.musicList[position].Signer
                                        .toString()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.5,
                                child: Container(color: Colors.black12),
                              )
                            ],
                          );
                  }),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80.0),
                    child: const Text(
                      'Azeris Musics',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child: const Text(
                      'Find musics',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            );
          }
        })
      ],
    )));
  }
}
