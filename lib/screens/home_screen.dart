import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../widgets/drawer_menu_widget.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  late String title = "Default Title";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        appBar: SliderAppBar(
          appBarHeight: 80,
          appBarColor: Colors.white,
          title: const Text(""),
          trailing: Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
              IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.bell))
            ],
          ),
        ),
        key: _sliderDrawerKey,
        sliderOpenSize: 250,
        slider: MenuWidget(
          onItemClick: (String title) {
            _sliderDrawerKey.currentState!.closeSlider();
            setState(() {
              title = title;
            });
          },
        ),
        child: const MainScreen(),
      ),
    );
  }
}
























/*import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../widgets/drawer_menu_widget.dart';
import 'dashboard_screen.dart';


class HomeScreen extends StatefulWidget {

  static const String id = "home-screen"; 
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // DrawerServices _services == DrawerServices();

  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  late String title;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SliderDrawer(
            appBar: SliderAppBar(
                appBarColor: Colors.white,
                title: Text(title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700))),
            key: _sliderDrawerKey,
            sliderOpenSize: 179,
            slider: MenuWidget(onItemClick: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                this.title = title;
              });
            }),
            child: const MainScreen()),
    );
  }
}*/