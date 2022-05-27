import 'package:azeri/presentation/pages/play_muzic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/muzic_bloc.dart';
import '../bloc/muzic_event.dart';
import '../bloc/muzic_state.dart';

class ListingPage extends StatelessWidget {
  ListingPage({this.onPressed});

  final onPressed;
  var page = 1;

  @override
  Widget build(BuildContext context) {
    context.read<MuzicBloc>().add(GetMuzic(page.toString()));
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Container(
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
                          // context.read<MuzicBloc>().add(GetMuzic("2"));
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
        ),
        BlocBuilder<MuzicBloc, MuzicState>(builder: (context, state) {
          if (state is MuzicLoading) {
            return Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                    color: Colors.amber, size: 70));
          } else if (state is MuzicData) {
            return Expanded(
              child: ListView.builder(
                  itemCount: state.muzic.muzicList.length,
                  itemBuilder: (context, position) {
                    return state.muzic.muzicList.isEmpty
                        ? const Center(
                            child: Text('Oops!, No '
                                'Result Found.'))
                        : Column(
                            children: [
                              ListTile(
                                isThreeLine: true,
                                onTap: () => Get.to(PlayMuzic(
                                    muzic: state.muzic.muzicList[position])),
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
                                  state.muzic.muzicList[position].Name
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.muzic.muzicList[position].Link),
                                    Text(state.muzic.muzicList[position].Signer
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
                      'Seat Geek',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child: const Text(
                      'Find and Discover events',
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
