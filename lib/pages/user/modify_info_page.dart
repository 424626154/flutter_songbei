import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/custom/common_bottom_sheet.dart';
import 'package:flutter_songbei/custom/network_loading.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/provider/user.dart';
import 'package:flutter_songbei/utils/qiniu.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

import '../../app_theme.dart';

class ModifyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ModifyInfoState();
  }
}

class _ModifyInfoState extends State<ModifyInfoPage> {
  User user = User();

  TextEditingController nameController = TextEditingController();

  TextEditingController profileController = TextEditingController();

  String token = '';
  double _process = 0.0;
  String qiniu_key = '';
  bool b_head_file = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = Provider.of<User>(context, listen: false);
      nameController.text = user.nickname;
      profileController.text = user.profile;
      _reqQiniuToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '完善资料',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '保存',
                style: TextStyle(color: AppTheme.loginFillColor),
              ),
              onPressed: () {
                _onUpPerson();
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    // padding: EdgeInsets.all(2),
                    width: 82,
                    height: 82,
                    // color: Colors.white,
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black26, width: 1),
                      // 边色与边宽度
                      color: Colors.white,
                      // 底色
                      //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                      // borderRadius: BorderRadius.circular(50), // 也可控件一边圆角大小
                    ),
                    child: GestureDetector(
                      child: _buildHead(),
                      onTap: (){
                        showPhotos();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text('点击更换头像'),
                  )
                ],
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  hintColor: Colors.grey[800], //定义下划线颜色
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: '请输入昵称',
                    hintStyle: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (str) {
//                    setState(() {
//                      user.nickname = str;
//                    });
                  },
                  autofocus: false,
                  style: AppTheme.f_s14_grey,
                ),
              ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //       '性别',
              //       style: AppTheme.f_s14_grey,
              //     ),
              //     Center(
              //       child: new Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           Theme(
              //             data: Theme.of(context).copyWith(
              //               unselectedWidgetColor: Colors.grey[800],
              //             ),
              //             child: Radio(
              //               value: 1,
              //               groupValue: user.gender,
              //               onChanged: (int rval) {
              //                 setState(() {
              //                   user.gender = rval;
              //                 });
              //               },
              //               activeColor: AppTheme.mainColor,
              //             ),
              //           ),
              //           Text(
              //             '男',
              //             style: TextStyle(color: Colors.grey[800]),
              //           ),
              //           Theme(
              //               data: Theme.of(context).copyWith(
              //                 unselectedWidgetColor: Colors.grey[800],
              //               ),
              //               child: Radio(
              //                 value: 0,
              //                 groupValue: user.gender,
              //                 onChanged: (int rval) {
              //                   setState(() {
              //                     user.gender = rval;
              //                   });
              //                 },
              //                 activeColor: AppTheme.mainColor,
              //               )),
              //           Text(
              //             '女',
              //             style: TextStyle(color: Colors.grey[800]),
              //           ),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //       '出生日期',
              //       style: AppTheme.f_s14_grey,
              //     ),
              //     FlatButton(
              //       child: Text(
              //         user.birth_date != null && user.birth_date.length > 0
              //             ? user.birth_date
              //             : '请选择出生日期',
              //         style: AppTheme.f_s14_blue,
              //       ),
              //       onPressed: () {
              //         _showDatePicker(context);
              //       },
              //     )
              //   ],
              // ),
              Theme(
                data: Theme.of(context).copyWith(
                  hintColor: Colors.grey[800], //定义下划线颜色
                ),
                child: TextField(
                  style: AppTheme.f_s14_grey,
                  controller: profileController,
                  decoration: InputDecoration(
                    hintText: '请输入简介',
                    hintStyle: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  onChanged: (str) {
                    setState(() {
                      user.profile = str;
                    });
                  },
                  autofocus: false,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHead() {
    print('----_buildHead:${user.head}');
    if (user.head != null && user.head.length > 0) {
      return Container(
        height: 80,
        child: b_head_file
            ? Image.file(File(user.head))
            : CachedNetworkImage(imageUrl: UIManager.getHeadurl(user.head)),
      );
    } else {
      return Icon(Icons.add_a_photo);
    }
  }

  _showDatePicker(BuildContext content) async {
    var _dateTime = DateTime(1990);
    final DateTime _picked = await showDatePicker(
      context: content,
      initialDate: _dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      LogUtil.v(_picked);
      LogUtil.v(_picked.year);
      LogUtil.v(_picked.month);
      LogUtil.v(_picked.day);
      setState(() {
        user.birth_date = _picked.year.toString() +
            '-' +
            _picked.month.toString() +
            '-' +
            _picked.day.toString();
      });
    }
  }

  void showPhotos() {
    showDialog(
        barrierDismissible: true, //是否点击空白区域关闭对话框,默认为true，可以关闭
        context: context,
        builder: (BuildContext context) {
          var list = List();
          list.add('相册');
          list.add('相机');
          return CommonBottomSheet(
            list: list,
            onItemClickListener: (index) async {
              print('-----index:$index');
              if (index == 0 || index == 2) {
                var source = ImageSource.gallery;
                if (index == 2) source = ImageSource.camera;
                _onUpload(source);
              }
              Navigator.pop(context);
            },
          );
        });
  }

  _onUpload(ImageSource source) async {
    print('---_onUpload:${token}');
    PickedFile imageFile = await _picker.getImage(source: source);
    File file = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
//          CropAspectRatioPreset.ratio3x2,
//          CropAspectRatioPreset.original,
//          CropAspectRatioPreset.ratio4x3,
//          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '裁剪',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      user.head = file.path;
      b_head_file = true;
    });
    if (file == null) {
      ToastUtil.showToast(context, '选择图片失败');
      return;
    }
    if (token == null || (token != null && token.length == 0)) {
      ToastUtil.showToast(context, 'token 无效!');
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NetworkLoading();
        });
    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double p = percent;
      setState(() {
        _process = p;
      });
//      print(percent);
      LogUtil.e('---percent:${percent}');
      if (p >= 1.0) {
//        LogUtil.e('---qiuniu_link:${qiniu_link}');
        setState(() {
          user.head = Qiniu.getUpUrl(qiniu_key);
          b_head_file = false;
        });
        Navigator.pop(context);
      }
    });

    String key = Qiniu.getUpPath(file.path);
//    LogUtil.e('---key:${key}');
    setState(() {
      qiniu_key = key;
    });
    //上传文件
    UploadResult result = await syStorage.upload(file.path, token, key);
  }

  _onUpPerson() {
    if(nameController.text.length == 0){
      ToastUtil.showToast(context, '请输入昵称');
      return;
    }
    if(b_head_file == true){
      ToastUtil.showToast(context, '头像上传中...');
      return;
    }
    user.nickname = nameController.text;
    user.profile = profileController.text;
    // if (user.gender != 0 && user.gender != 1) {
    //   ToastUtil.showToast(context, '请选择性别');
    //   return;
    // }
    _reqUpUserInfo();
  }

  _reqUpUserInfo() {
    user.userid = Provider.of<App>(context, listen: false).userid;
    CHttp.post(
        CHttp.USER_UPINFO,
        (data) {
          LogUtil.v(data);
          Provider.of<User>(context, listen: false).upInfo(data);
          ToastUtil.showToast(context, '修改成功');
          Navigator.of(context).pop();
        },
        params: PUpUser(
                Provider.of<App>(context, listen: false).userid,
                user.head,
                nameController.text,
                profileController.text,
                user.gender,
                user.birth_date)
            .toJson(),
        errorCallback: (err) {
          ToastUtil.showToast(context, err);
        });
  }

  _reqQiniuToken() {
    CHttp.post(CHttp.QINIU_UPTOKEN, (data) {
      LogUtil.e('-----data:${data}');
      setState(() {
        token = data;
      });
    }, errorCallback: (err) {
      LogUtil.e('-----err:${err}');
    });
  }
}
