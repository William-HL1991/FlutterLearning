import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

const String _name = 'William';

class Chat extends StatelessWidget {
  Chat({this.text, this.animationController});
  final String text; //聊天内容
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
     return new SizeTransition(             //用SizeTransition动效控件包裹整个控件，定义从小变大的动画效果
        sizeFactor: new CurvedAnimation(                              //CurvedAnimation定义动画播放的时间曲线
        parent: animationController, curve: Curves.easeOut),      //指定曲线类型
        axisAlignment: 0.0,
        child: new Container(     //聊天记录主体  Container控件被包裹到SizeTransition中
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(    //聊天记录是成行的
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),  //头像圆圈
            ),
            Expanded(
              child: new Column(     //单条消息
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),   //昵称
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
  }

}

class MessagePageWidget extends StatefulWidget {
  @override
  createState() => MessagePageWidgetState();
}

class MessagePageWidgetState extends State<MessagePageWidget> with TickerProviderStateMixin {
  final List<Chat> _messages = <Chat>[]; //存放聊天记录的数组，数组类型为无状态控件MessagePageWidget
  final TextEditingController _textController = TextEditingController(); //聊天窗口的文本输入控件
  bool _isComposing = false;  //通过标志位判断输入框里面是不有内容

  // 发送文本事件处理函数
  void _handleSubmitted(String text) {
    _textController.clear(); //清空输入框
    setState(() {
      _isComposing = false;  //清空输入框之后重置标志位
    });
    Chat message = Chat(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700 ),   //动画持续时间
        vsync: this,                              // TickerProviderStateMixin内默认的属性和参数
      ),);

    //变更状态，数据绑定，插入新的记录
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();        // 启动动画
  }

  @override //主动释放内存对象
  void dispose() {
    for (Chat message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  //文本输入框
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {  // 通过onChanged事件更新_isComposing 标志
                  setState(() {             // 调用 setState 重新绘制IconButton控件
                    _isComposing = text.length > 0;  // 文本长度超过0的时候， 标志位打开可以发送信息
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "请输入消息"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ? new CupertinoButton(      //  使用Cupertino控件库的CupertinoButton控件作为IOS端的发送按钮
                  // child: new Icon(Icons.send),
                  child: new Text('发送'),
                  onPressed: _isComposing ? () =>  _handleSubmitted(_textController.text) : null,) 
                :  new IconButton(                                            //modified
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing ?
                  () =>  _handleSubmitted(_textController.text) : null,
                )
            ),
          ],
        ),
      ),
    );
  }

  //聊天页面的布局
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私聊'),
        backgroundColor: Colors.blue[300],
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0, //适配IOS的扁平化无阴影效果
        ),
      body: Container(  //Container方便加入主题风格装饰
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0,),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(  //适配风格
          border: Border(
            top: BorderSide(color: Colors.blue[100]),
          ),
        ) : null,
      ),
    );
  }
}
