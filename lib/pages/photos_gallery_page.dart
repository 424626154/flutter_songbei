
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/app_theme.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/photo_gallery_model.dart';
import 'package:flutter_songbei/utils/toast_util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotosGalleryPage extends StatefulWidget {
  List<PhotoGalleryModel> photos = List<PhotoGalleryModel>();
  int index;
  PhotosGalleryPage(this.photos,this.index);
  @override
  State<StatefulWidget> createState() {
    return _PageState(photos,index);
  }

}

class _PageState extends State<PhotosGalleryPage>{

  List<PhotoGalleryModel> photos = List<PhotoGalleryModel>();
  int index;
  _PageState(this.photos,this.index);

  PageController pageController ;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查看图片'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('保存',style: AppTheme.appBarRight,),
            onPressed: (){
              _onSaveImage();
            },
          )
        ],
      ),
      body:_buildBody()
    );
  }

  Widget _buildBody(){
    if(photos.length > 0){
      return Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(UIManager.getPhoto(photos[index].photo)),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: index),
              );
            },
            itemCount: photos.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            backgroundDecoration: BoxDecoration(

            ),
            pageController: pageController,
            onPageChanged: (cur_index){
              setState(() {
                index = cur_index;
              });
              print('cur_index:$cur_index');
            },
          )
      );
    }else{
      return Container();
    }
  }

  _onSaveImage() async {
    var photo_url = UIManager.getPhoto(photos[index].photo);
    var response = await Dio().get(photo_url,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        );
    print(result);
    if(result == true){
      ToastUtil.showToast(context, '保存成功!');
    }else{
      ToastUtil.showToast(context, '保存失败!');
    }
  }
}