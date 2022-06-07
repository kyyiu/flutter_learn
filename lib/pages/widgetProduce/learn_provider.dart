import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';

class InheritProvider<T> extends InheritedWidget {
  InheritProvider({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final T data;

  @override
  bool updateShouldNotify(InheritProvider<T> old) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

// ----------------------------------------------------------------------------------------------
// 数据发生变化怎么通知
class ChangeNotifier extends Listenable {
  List listeners = [];

  @override
  void addListener(VoidCallback listener) {
    //添加监听器
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    //移除监听器
    listeners.remove(listener);
  }

  void notifyListeners() {
    //通知所有监听器，触发监听器回调
    listeners.forEach((item) => item());
  }
}

// ----------------------------------------------------------------------------------------------
// _ChangeNotifierProviderState类的主要作用就是监听到共享状态（model）改变时重新构建Widget树。
// 注意，在_ChangeNotifierProviderState类中调用setState()方法，widget.child始终是同一个，所以执行build时，InheritedProvider的child引用的始终是同一个子widget，
// 所以widget.child并不会重新build，这也就相当于对child进行了缓存！当然如果ChangeNotifierProvider父级Widget重新build时，则其传入的child便有可能会发生变化。
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
  });

  final Widget child;
  final T data;

  static Type _typeof<T>() => T;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static T of<T>(BuildContext context, {bool listen = true}) {
    final type = _typeof<InheritProvider<T>>();
    final provider = listen ?
        context.dependOnInheritedWidgetOfExactType<InheritProvider<T>>()
        : context.getElementForInheritedWidgetOfExactType<InheritProvider<T>>()?.widget as InheritProvider<T>;
    return provider!.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

// ----------------------------------------------------------------------------------------------
// 购物车例子
class Item {
  Item(this.price, this.count);
  double price;
  int count;
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView get items => UnmodifiableListView(_items);

  double get totalPrice => _items.fold(
      0,
      (previousValue, element) =>
          previousValue + element.count * element.price);

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context),
    );
  }
}

class Learn_Provider extends StatefulWidget {
  const Learn_Provider({Key? key}) : super(key: key);

  @override
  State<Learn_Provider> createState() => _Learn_ProviderState();
}

class _Learn_ProviderState extends State<Learn_Provider> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider<CartModel>(
        data: CartModel(),
        child: Builder(builder: (BuildContext context) {
          return Column(
            children: [
              // Builder(builder: (BuildContext context) {
              //   var cart = ChangeNotifierProvider.of<CartModel>(context);
              //   return Text('总价---${cart.totalPrice}');
              // }),
              Consumer<CartModel>(builder: (BuildContext context, cart) => Text('总价---${cart!.totalPrice}'),),
              Builder(builder: (BuildContext context) {
                print('EEE buid');
                return ElevatedButton(
                    onPressed: () {
                      // listen 设为false，不建立依赖关系
                      ChangeNotifierProvider.of<CartModel>(context, listen: false)
                          .add(Item(20.0, 1));
                    },
                    child: Text('添加商品'));
              })
            ],
          );
        }),
      ),
    );
  }
}
