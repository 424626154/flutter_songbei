

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/models/image_model.dart';
typedef OnAddCallback = void Function(ImageModel item);
typedef OnDelCallback = void Function(ImageModel item);
class AddPostGridItem extends StatelessWidget{
  ImageModel item;
  OnAddCallback onAdd;
  OnDelCallback onDel;
  AddPostGridItem(ImageModel item,{OnAddCallback onAdd , OnDelCallback onDel}){
    this.item = item;
    this.onAdd = onAdd;
    this.onDel = onDel;
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }
  _buildImage(){
    print('-----item:${item}');
    if(item.type == 1){
      return GestureDetector(
        child: Container(
          color: Colors.grey.shade100,
          child: Icon(Icons.add,color: Colors.grey.shade500,size: 40.0,),
        ),
        onTap: (){
          if(this.onAdd != null)this.onAdd(item);
        },
      );
    }else{
      if(item.state == 0){
        return Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: Stack(
            fit:StackFit.expand,
            children: <Widget>[
              Container(
                child: Image.file( File(item.path),fit: BoxFit.fill,),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.delete,color: Colors.grey.shade500,),
                  onPressed: (){
                    if(this.onDel != null)this.onDel(item);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Text('上传中...',style: TextStyle(color: Colors.grey.shade500),),
              )
            ],
          ),
        );
      }else{
        return Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item.url,
                fit: BoxFit.fill,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    if (this.onDel != null) this.onDel(item);
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}