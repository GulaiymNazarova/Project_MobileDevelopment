import 'package:firstflutterproject/bloc/product_bloc.dart';
import 'package:firstflutterproject/bloc/product_event.dart';
import 'package:firstflutterproject/bloc/product_state.dart';
import 'package:firstflutterproject/product_api.dart';
import 'package:firstflutterproject/widgets/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Исправлен синтаксис (убрана точка перед fromSeed)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Оборачиваем приложение в BlocProvider, чтобы Bloc был доступен везде
      home: BlocProvider(
        // Создаем Bloc и сразу отправляем событие на загрузку продуктов
        create: (context) => ProductBloc(ProductApiImpl())..add(FetchProducts()),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // Используем BlocBuilder для отслеживания состояний
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          // 1. Состояние загрузки
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          // 2. Состояние успешной загрузки
          else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Center(
                  child: ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } 
          // 3. Состояние ошибки
          else if (state is ProductError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          
          // Начальное состояние
          return const Center(child: Text('Нажмите кнопку, чтобы загрузить'));
        },
      ),
      // Кнопка теперь обновляет список продуктов через Bloc
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProductBloc>().add(FetchProducts());
        },
        tooltip: 'Обновить',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}