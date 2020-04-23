import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'homePage.dart';
import 'messagePage.dart';
import 'minePage.dart';


// iOS Cupertino主题风格
final ThemeData KIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.blue[400],
  // primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
);

// android Material主题风格
final ThemeData KAndroidTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);


class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationWidgetState();
  }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;

  List<Widget> pages = new List();
  @override
  // initState是初始化函数
  void initState() {
    pages
      ..add(HomePageWidget())
      ..add(MessagePageWidget())
      ..add(MyPageWidget());
  }

  @override
  Widget build(BuildContext context) {
    /*
    返回一个脚手架，里面包含两个属性，一个是底部导航栏，另一个是主体内容
    */
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            title: new Text("首页")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: new Text("消息")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            title: new Text('我的')
          )
        ],
        //底部导航栏自带的位标属性，表示底部导航栏当前处于哪个导航标签。给他一个初始值0，也就是默认第一个标签页面。
        currentIndex: _currentIndex,
        //点击的时候对应去调用其页面
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}

void main() => runApp(new MyApp());
// void main() {
//   debugPaintSizeEnabled = true;
//   runApp(new MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  //构建一个容器
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '名称生成器App',
      //添加主题属性
      // theme: new ThemeData(
      //   primaryColor: Colors.blue,
      //   brightness: Brightness.dark
      //   ),
      theme: defaultTargetPlatform == TargetPlatform.iOS ? KIOSTheme : KAndroidTheme, 
      debugShowCheckedModeBanner: false,
      home: new BottomNavigationWidget(),
    );
  }
}
