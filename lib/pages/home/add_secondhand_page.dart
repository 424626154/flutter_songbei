import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_songbei/custom/common_bottom_sheet.dart';
import 'package:flutter_songbei/custom/griditem/add_post_images_grid_item.dart';
import 'package:flutter_songbei/custom/network_loading.dart';
import 'package:flutter_songbei/models/image_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/network/chttp.dart';
import 'package:flutter_songbei/network/params.dart';
import 'package:flutter_songbei/provider/app.dart';
import 'package:flutter_songbei/qiniu/qiniu_file.dart';
import 'package:flutter_songbei/qiniu/qiniu_scuess.dart';
import 'package:flutter_songbei/utils/qiniu.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

class AddSecondhandPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageState();
  }
}

class _PageState extends State<AddSecondhandPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController _priceController = TextEditingController();


  String specification = "";
  int per_add = 0;
  int image_max = 9;

  String token = '';
  Map<String, QinuFile> qiniuFlies = Map<String, QinuFile>();

  List<ImageModel> images = List<ImageModel>();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    var image = ImageModel();
    image.type = 1;
    images.add(image);
    _reqQiniuToken();

    rootBundle.loadString('assets/data/specification.txt').then((value) => {
          this.specification = value,
          print('-----specification:${specification}')
        });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reqPrivileges();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '发布',
          ),
          centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                _submit();
              },
              icon: Icon(
                Icons.near_me,
                size: 14,
                color: Colors.white,
              ),
              label: Text(
                '发布',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              // TextField(
              //   controller: _titleController,
              //   minLines: 1,
              //   maxLines: 20,
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.all(5.0),
              //     hintText: '编辑想法标题',
              //     filled: true,
              //     fillColor: Colors.white,
              //     border: InputBorder.none,
              //   ),
              // ),
              // Divider(
              //   height: 1,
              // ),
              TextField(
                controller: _controller,
                minLines: 5,
                maxLines: 20,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  hintText: '品牌型号,新旧成都，入手渠道，转手原因...',
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: [
                    Text('价格',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                    Flexible(
                        child: TextField(
                            controller:_priceController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")), //只允许输入小数
                            ],
                            decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: '0.00',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    )))
                  ],
                ),
              ),
              Flexible(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //横轴三个子widget
                        childAspectRatio: 1.0 //宽高比为1时，子widget
                        ),
                    itemCount: images.length,
                    itemBuilder: (content, index) {
                      return AddPostGridItem(
                        images[index],
                        onAdd: (item) {
                          showPhotos();
                        },
                        onDel: (item) {
                          print('-----item:$item');
                          images.removeAt(index);
                          for (var i = images.length - 1; i >= 0; i--) {
                            if (images[i].id == item.id) {
                              images.removeAt(i);
                            }
                          }
                          if (images.length < image_max) {
                            if (images[images.length - 1].type != 1) {
                              var image = ImageModel();
                              image.type = 1;
                              images.add(image);
                            }
                          }
                          setState(() {});
                        },
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  showPhotos() {
    var cur_images = 0;
    for (var i = 0; i < images.length; i++) {
      if (images[i].type == 0) {
        cur_images++;
      }
    }
    if (cur_images < image_max) {
    } else {
      ToastUtil.showToast(context, '最多可上传$image_max张图片');
    }
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
                PickedFile file = await _picker.getImage(source: source);
                if (file == null) {
                  ToastUtil.showToast(context, '选择文件失败');
                  return;
                }
                var insert_index = 0;
                images.forEach((element) {
                  if (element.type == 0) {
                    insert_index += 1;
                  }
                });
                var image = ImageModel();
                image.path = image.url = file.path;
                image.type = 0;
                image.state = 0;
                images.insert(insert_index, image);
                if (images.length > image_max) {
                  for (var i = images.length - 1; i >= 0; i--) {
                    if (images[i].type == 1) {
                      images.removeAt(i);
                    }
                  }
                }
                setState(() {});
//                  _onUpload(file);
                Future future = this._onUpload(file);
                future.then((qiniuScuess) {
                  for (var i = 0; i < images.length; i++) {
                    if (images[i].type == 0 &&
                        images[i].path == qiniuScuess.file_path) {
                      images[i].state = 1;
                      images[i].url = Qiniu.getUpUrl(qiniuScuess.qiniu_key);
                      print('------上传成功');
                    }
                  }
                  setState(() {});
                });
              }
              Navigator.pop(context);
            },
          );
        });
  }

  _submit() {
    print("==============================");
    // if (_titleController.text.isEmpty) {
    //   ToastUtil.showToast(context, '编辑想法标题');
    //   return;
    // }
    if (_controller.text.isEmpty) {
      ToastUtil.showToast(context, '发布内容不能为空！');
      return;
    }
    if (_priceController.text.isEmpty) {
      ToastUtil.showToast(context, '轻填写价格！');
      return;
    }

    List<ImageModel> upImages = List<ImageModel>();
    for (var i = 0; i < images.length; i++) {
      if (images[i].type == 0 && images[i].state == 1) {
        upImages.add(images[i]);
      }
    }
//    if (upImages.length == 0) {
//      ToastUtil.showToast(context, '请选择图片');
//      return;
//    }

    var to_json = {};
    if (upImages.length > 0) {
      List<Object> photos = List<Object>();
      for (var i = 0; i < upImages.length; i++) {
        photos.add(upImages[i].toServerJson(i));
      }
//    print(photos);
      to_json = {'photos': photos};
    }
    var d_price = double.tryParse(_priceController.text);
    _reqAddDiscuss(
        _titleController.text, _controller.text, d_price,json.encode(to_json));
  }

  /**
   * 用户规范
   */
  showSpecification() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('用户发布内容规范'),
              content: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      specification,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text("同意"),
                    onPressed: () =>
                        {_reqSetPri(), Navigator.of(context).pop()}),
                FlatButton(
                    child: Text("拒绝"),
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          Navigator.of(context).pop()
                        }),
              ]);
        });
  }

  void _reqAddDiscuss(String title, String content,double price, String extend) {
    print('-----userid:${Provider.of<App>(context, listen: false).userid}');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NetworkLoading();
        });
    CHttp.post(
        CHttp.SECONDHAND_ADD,
        (data) {
          Navigator.pop(context);
          ToastUtil.showToast(context, '发布成功');
          Navigator.pop(context, PostModel(data));
        },
        params: PAddSecondhand(Provider.of<App>(context, listen: false).userid, title,
                content, price, extend)
            .toJson(),
        errorCallback: (err) {
          Navigator.pop(context);
          ToastUtil.showToast(context, err);
        },
        completeCallback: () {
//          Navigator.pop(context);
        });
  }

  Future<QiniuScuess> _onUpload(PickedFile file) async {
    if (token == null || (token != null && token.length == 0)) {
      ToastUtil.showToast(context, 'token 无效!');
      return null;
    }
    print('---_onUpload:${token}');
    QiniuScuess qiniuScuess = null;
    if (token == null || (token != null && token.length == 0)) {
      ToastUtil.showToast(context, 'token 无效!');
      return qiniuScuess;
    }
    if (file == null) {
      return qiniuScuess;
    }
    qiniuFlies[file.path] = QinuFile(file.path);
    final syStorage = SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double p = percent;
//      setState(() {
      if (qiniuFlies[file.path] != null) qiniuFlies[file.path].process = p;
//      });
//      print(percent);
      LogUtil.e('---percent:${percent}');
//      if (qiniuFlies[file.path] != null&&p >= 1.0) {
////        LogUtil.e('---qiuniu_link:${qiniu_link}');
//        Qiniu.httpGetImageInfo(Qiniu.getUpUrl(qiniuFlies[file.path].qiniu_key), (data) {
//          Map info_map = jsonDecode(jsonEncode(data));
////            this.myFileStorage.onUpScuess(file.path,qiniuFlies[file.path].qiniu_key,info_map);
//          qiniuScuess  = QiniuScuess(file.path,qiniuFlies[file.path].qiniu_key,info_map);
//          this.myFileStorage.onUpScuess(qiniuScuess);
//          print('-----tag qiniuScuess:${qiniuScuess}');
//          setState(() {
//            _controller.text = _controller.text;
//          });
//        }, errorCallback: (err) {
//
//        });
//      }
    });

    String key = Qiniu.getUpPath(file.path);
//    LogUtil.e('---key:${key}');
//    setState(() {
//      qiniu_key = key;
//    });
    qiniuFlies[file.path].qiniu_key = key;
    //上传文件
    UploadResult result = await syStorage.upload(file.path, token, key);
    if (result.success) {
      qiniuScuess = QiniuScuess(file.path, qiniuFlies[file.path].qiniu_key);
    }
    print('-----result:${result} qiniuScuess:${qiniuScuess}');
    return qiniuScuess;
  }

  void _reqQiniuToken() {
    CHttp.post(CHttp.QINIU_UPTOKEN, (data) {
      LogUtil.e('-----data:${data}');
      setState(() {
        token = data;
      });
    }, errorCallback: (err) {
      LogUtil.e('-----err:${err}');
    });
  }

  void _reqPrivileges() {
    CHttp.post(
        CHttp.USER_PRIVILEGES,
        (data) {
          LogUtil.e('-----data:${data}');
          var temp_per_add = data['per_add'];
          setState(() {
            per_add = temp_per_add;
          });
          if (temp_per_add == 0) {
            this.showSpecification();
          }
        },
        params:
            PUserid(Provider.of<App>(context, listen: false).userid).toJson(),
        errorCallback: (err) {
          LogUtil.e('-----err:${err}');
        });
  }

  void _reqSetPri() {
    CHttp.post(
        CHttp.USER_SETPRI,
        (data) {
          LogUtil.e('-----data:${data}');
          var temp_per_add = data['per_add'];
          setState(() {
            per_add = temp_per_add;
          });
          if (temp_per_add == 0) {
            showSpecification();
          }
        },
        params: PSetPri(Provider.of<App>(context, listen: false).userid,
                'per_add', true)
            .toJson(),
        errorCallback: (err) {
          LogUtil.e('-----err:${err}');
        });
  }
}
