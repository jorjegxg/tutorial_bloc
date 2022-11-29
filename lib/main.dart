// TODO : invata prima oara despre stream - uri
// https://medium.com/flutter-community/flutter-stream-basics-for-beginners-eda23e44e32f

import 'dart:developer';
import 'dart:math' as math show Random;

// TODO : invata despre bloc
// https://bloclibrary.dev/#/coreconcepts?id=using-a-cubit
// https://www.youtube.com/watch?v=Mn254cnduOY

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

const names = ['unu', 'doi', 'trei', 'patru', 'cinci', 'sase', 'sapte', 'opt', 'noua', 'zece'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    log(state.toString());
    emit(names.getRandomElement());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invat bloc fha'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text('Pick random name'),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.done:
              return const SizedBox();
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ' '),
                  button,
                ],
              );
          }
        },
      ),
    );
  }
}
