import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.light));

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, primary: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            iconTheme: IconThemeData(color: Color(0xff5e6e7e)),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
            ))),
    home: const MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<bool> enableAppbarPinnedBehavior = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        enableAppbarPinnedBehavior.value = false;
        scrollController.animateTo(336, duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
      } else {
        scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut).whenComplete(() {
          enableAppbarPinnedBehavior.value = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
          ),
          preferredSize: ui.Size.zero),
      body: GestureDetector(onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      }, child: CustomScrollView(
        controller: scrollController,
        slivers: [
          ValueListenableBuilder(
              valueListenable: enableAppbarPinnedBehavior,
              builder: (ctx, value, child) {
                return SliverAppBar(
                  expandedHeight: 96,
                  toolbarHeight: 56,
                  pinned: value,
                  automaticallyImplyLeading: false,
                  flexibleSpace: SafeArea(
                      child: Container(
                        color: Colors.green,
                        width: double.infinity,
                        height: 96,
                      )),
                );
              }),
          SliverToBoxAdapter(
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.lightBlueAccent,
              alignment: Alignment.center,
              child: Text("Flutter Slivers", style: TextStyle(fontSize: 32),),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: enableAppbarPinnedBehavior,
              builder: (ctx, value, child) {
                return SliverAppBar(
                  expandedHeight: 200,
                  toolbarHeight: 200,
                  pinned: value,
                  flexibleSpace: Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xffe3e3e3),
                  ),
                );
              }),
          SliverAppBar(
            expandedHeight: 64,
            pinned: true,
            flexibleSpace: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Color(0xffe6e6e6),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    hintText: "Enter text",
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 16),
                focusNode: focusNode,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((ctx, index) {
                return Container(
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Item $index",
                      style: const TextStyle(fontSize: 16),
                    ));
              }, childCount: 20)),
        ],
      )),
    );
  }
}
