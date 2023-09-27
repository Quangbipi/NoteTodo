import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:note_todo/bloc/todo_bloc.dart';
import 'package:note_todo/bloc/todo_event.dart';
import 'package:note_todo/bloc/todo_state.dart';
import 'package:note_todo/component/todo_item.dart';
import 'package:note_todo/model/todo.dart';
import 'package:note_todo/service/local_todo_service.dart';

enum sortOption { all, finish, unfinished }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo>? todos;
  DateTime scheduleTime = DateTime.now();
  TextEditingController _todoController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  LocalTodoService _localTodoService = LocalTodoService();

  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localTodoService.init();
    context.read<TodoBloc>().add(GetTodoEvent());
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    void handleMenuOptionSelected(sortOption option) {
      context.read<TodoBloc>().add(SortTodoEvent(option.index));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton(
                onSelected: handleMenuOptionSelected,
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<sortOption>>[
                    PopupMenuItem<sortOption>(
                      value: sortOption.all,
                      child: Text('Tất cả'),
                    ),
                    PopupMenuItem<sortOption>(
                      value: sortOption.finish,
                      child: Text('Hoàn thành'),
                    ),
                    PopupMenuItem<sortOption>(
                      value: sortOption.unfinished,
                      child: Text('Chưa hoàn thành'),
                    ),
                  ];
                })
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: TextField(
                              controller: _todoController,
                              decoration: InputDecoration(
                                  hintText: 'Công việc của bạn',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  contentPadding: EdgeInsets.only(left: 15)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            child: TextField(
                              controller: _timeController,
                              onTap: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  showTitleActions: true,
                                  onChanged: (date) => scheduleTime = date,
                                  onConfirm: (date) {
                                    _timeController.text =
                                        dateFormat.format(date);
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                  hintText: 'Thời gian',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  contentPadding: EdgeInsets.only(left: 15)),
                              showCursor: false,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50))),
                        onPressed: () {
                          if (_todoController.text.isNotEmpty &&
                              scheduleTime.isAfter(DateTime.now())) {
                            Todo todo = Todo(
                                id: '${Random().nextInt(500)}',
                                content: _todoController.text,
                                time: scheduleTime);
                            context.read<TodoBloc>().add(AddTodoEvent(todo));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Thông báo',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: scheduleTime
                                            .isBefore(DateTime.now())
                                        ? Text(
                                            'Thời gian bạn chọn không phù hợp')
                                        : Text('Bạn chưa nhập công việc'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Đóng'))
                                    ],
                                  );
                                });
                          }
                        },
                        child: Text(
                          'Thêm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is GetTodoSuccess) {
                      return ListView.builder(
                          itemCount: state.todos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TodoItem(
                                todo: state.todos[index],
                                index: index,
                              ),
                            );
                          });
                    }
                    return Center(
                      child: Text('Không có dữ liệu'),
                    );
                  },
                ))
              ],
            ),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ),
            
             if (_bannerAd == null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: 300,
                    height: 50,
                    child: Text('kho có qc'),
                  ),
              )
          ],
        ));
  }
}
