import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import './appbar_gradient.dart';

class HomePageWidget extends StatefulWidget {
  @override
  createState() => new HomePageWidgetState();
}

class HomePageWidgetState extends State<HomePageWidget> {
  @override
  final _suggestions = <WordPair>[];  //用于保存随机字符串词组，注意这是一个数组变量
  final _saveSuggestion = new Set<WordPair>(); //用于保存list中cell的收藏状态
  final _biggerFont = const TextStyle(fontSize: 18.0);   //用于标识字符串的样式

  //构建一个脚手架，里面塞入前面定义好的_buildSuggestions类
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: GradientAppBar(
        gradientStart: Color(0xFF2171F5),
        gradientEnd: Color(0xFF90d7ec),
        title: Text('名称生成器App'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,  // 适配IOS的扁平化无阴影效果
        leading: Icon(Icons.ac_unit),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,),
          IconButton(icon: Icon(Icons.cloud), onPressed: _pushWeather,),
        ],
      ),
      body: _buildSuggestions(), 
    );
  }

  //定义一个子控件，这个控件就是放置随机字符串词组的列表
  Widget _buildSuggestions() {
    return new ListView.builder(  //ListView(列表视图)是material.dart中的基础控件
      padding: const EdgeInsets.all(16.0),  //padding(内边距)是ListView的属性，配置其属性值
      //通过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
      //此函数会自动循环并计数
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();//奇数行塞入分割线对象
        final index = i ~/ 2;  //当前行号除以2取整，得到的值就是_suggestions数组项索引号
        // 如果计算得到的数组项索引号超出了_suggestions数组的长度，那_suggestions就再生10个随机组合的字符串词组
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);//把这个数据项塞入ListView中
      }
    );
  }

  //定义的_suggestions数组项属性
  Widget _buildRow(WordPair pair) {
    //ListTile和Text都是material.dart中的基础控件
    //定义bool变量用于实现收藏标记，收藏为true，反之为false
    final alreadSaved = _saveSuggestion.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // 安放收藏图表
      trailing: new Icon(
        alreadSaved ? Icons.favorite : Icons.favorite_border,
        color: alreadSaved ? Colors.red : null,
      ),
      // 增加点击事件，切换收藏状态的样式
      onTap: (){
        setState(() {
          if (alreadSaved) {  // 已经收藏的话取消收藏
            _saveSuggestion.remove(pair);
          } else { // 没收藏的话，添加收藏
            _saveSuggestion.add(pair);
          }
        });
      },
    );
  }



  // 右上角push到收藏夹
  void _pushSaved() {
    // 创建收藏夹的Navigator，然后向里面增加MaterialPageRoute空间
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          // 遍历保存了标签的set-_saveSuggestion
          final titles = _saveSuggestion.map( 
            (pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
              }
          );
          // 链式调用，获取分割线
          final divided = ListTile.divideTiles( //divideTiles()函数，向每个tile间隔插入一个1像素宽的边框
            context: context,
            tiles: titles,
          ).toList();   //漏掉这个函数，进入收藏夹直接崩溃
          return new Scaffold(
            appBar: new AppBar(
              title: new Text("收藏列表"),
              elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,  // 适配IOS的扁平化无阴影效果
              ),
            body: new ListView(children: divided,),);
        }
      ),
    );
  }


  //获取天气页面
  void _pushWeather() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return WeatherScene();
        }
      ),
    );

  }
}

class WeatherScene extends StatefulWidget {
  @override
  createState() => new WeatherSceneState(); //创建实例
}

class WeatherSceneState extends State<WeatherScene> {
  var _ipAddress = "Unknown";

  @override
  Widget build(BuildContext context) {
        return new Scaffold(
          appBar: AppBar(
            title: new Text('获取天气信息'),
            elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,  // 适配IOS的扁平化无阴影效果
            centerTitle: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
            body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: _netwoek,
                  child: new Text('获取天气预报'),
                ),
                new Text('$_ipAddress.'),
              ],
            ),
            ),
          );
  }
  
  //io和网络相关
  // var _ipAddress = 'Unknown';
  void _netwoek() async {
    //异步请求
    var url = "http://t.weather.sojson.com/api/weather/city/101010100";
    // 给一个获取天气的备用地址： https://www.tianqiapi.com/api/?version=v1
    var httpClient = new HttpClient();
    httpClient.connectionTimeout = Duration(seconds: 30);

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonrest = await response.transform(Utf8Decoder()).join();
        var data = jsonDecode(jsonrest);
        // 处理天气数据返回的结果
        if (data['status'].toString() != '200') {
          result = "没有获取到天气数据，请稍候重试";
        } else {
          result = data['cityInfo']['city'].toString() + "昨天天气" + ":" + data['data']['yesterday']['high'].toString() + " " + data['data']['yesterday']['low'].toString() + " " + data['data']['yesterday']['type'].toString();
          debugPrint(result);
        }
      }else {
        result ='Error get:\nHttp status ${response.statusCode}';    //连接错误提示
        debugPrint(result);
      } 
    } catch (exception) {
      result = '执行代码出现异常: ' + exception.toString();
      debugPrint(result);
    }

     //如果当前控件已经被注销掉，则当前控件内置状态为mounted。
      /*由于是前面的HTTP异步请求，如果网络卡住，而当前控件因为其他原因注销掉了，
      此时不必调让代码走到后面的setState()方法，否则会报错，所以这里直接return，避免报错。*/
    if (!mounted) return;

    setState(() {
      _ipAddress = result;    //显示请求结果
    });
  }
}