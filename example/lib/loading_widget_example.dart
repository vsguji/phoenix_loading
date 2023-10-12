import 'package:flutter/material.dart';
import 'package:phoenix_loading/phoenix_loading.dart';

class LoadingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading案例'),
      ),
      body: const Center(
          child: Column(children: [
        Text("正常 Loading 展示"),
        PageLoading(),
        Text("短文案 Loading 展示"),
        PageLoading(
          content: "我是较短的 Loading",
        ),
        Text("长文案 Loading 展示"),
        PageLoading(
          content: "我是较长的我是较长的我是较长的Loading",
        )
      ])),
    );
  }
}
