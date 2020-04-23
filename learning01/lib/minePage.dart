import 'package:flutter/material.dart';
import './webview/web_view_container.dart';
import 'appbar_gradient.dart';

class MyPageWidget extends StatefulWidget {
  @override
  createState() => MyPageWidgetState();
}

class MyPageWidgetState extends State<MyPageWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('我的'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          // new IconButton(icon: new Icon(Icons.list), onPressed: _changeDark,),
          new IconButton(icon: new Icon(Icons.data_usage),onPressed: _pushWebview,),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          Icon(Icons.image, size: 50, color: Colors.cyan,),
          Icon(Icons.nature_people, size: 50, color: Colors.cyan,),
          Icon(Icons.offline_pin, size: 50, color: Colors.cyan,),
          Icon(Icons.pages, size: 50, color: Colors.cyan,),
          Icon(Icons.query_builder, size: 50, color: Colors.cyan,),
          Icon(Icons.youtube_searched_for, size: 50, color: Colors.cyan,),
          Icon(Icons.zoom_in, size: 50, color: Colors.cyan,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        tooltip: '按钮',
        child: Icon(Icons.add),
        onPressed: () => _changeDark(),
      ),
    );
  }

  _changeDark() {
  Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return DarkState();
        }
      ),
    );
}

  _pushWebview() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return WebViewState();
        }
      ),
    );
  }

}

class DarkState extends StatefulWidget {
  @override
  createState() => DarkStateWidgetState();
}


class DarkStateWidgetState extends State<DarkState> {
  bool _value = true;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('夜间模式'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,  // 适配IOS的扁平化无阴影效果
        backgroundColor: Colors.deepPurple,
      ),
      body: new Column(
        children: <Widget>[
          Switch(
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
              });
            },
            activeColor: Colors.red,
            activeTrackColor:Colors.black,
            inactiveThumbColor:Colors.green,
            inactiveTrackColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}


class WebViewState extends StatefulWidget {
  @override
  createState() => WebViewStateWidgetState();
}

class WebViewStateWidgetState extends State<WebViewState> {
  final _links = ['https://www.baidu.com','https://demo.glyptodon.com/#/'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        gradientStart: Color(0xFF90d7ec),
        gradientEnd: Color(0xFF228fbd),
        title: Text('WebView示例'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _links.map((link) => _urlButton(context, link)).toList(),
        ),),),
    );
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Text(url),
        onPressed: () => _handleURLButtonPress(context, url),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

}