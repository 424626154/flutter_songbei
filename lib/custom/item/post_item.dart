import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/photo_gallery_model.dart';
import 'package:flutter_songbei/models/post_model.dart';
import 'package:flutter_songbei/pages/photos_gallery_page.dart';
import 'package:flutter_songbei/pages/post/post_page.dart';

class PostItem extends StatelessWidget {
  PostModel item;

  PostItem(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              item.content,
              style: TextStyle(fontSize: 16),
              maxLines: 10,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildPhotos(context, item),
        ],
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (BuildContext context) => PostPage(item.id)))
            .then((value) => {});
      },
    );
  }

  Widget _buildPhotos(BuildContext context, PostModel item) {
    if (item.postExtend != null && item.postExtend.photos.length > 0) {
      var num = item.postExtend.photos.length;
      var photo0 = item.postExtend.photos[0];
      var photo_w = (MediaQuery.of(context).size.width-60)/ 3;
      var add_num = num-3;
      if (num >= 3) {
        var photo1 = item.postExtend.photos[1];
        var photo2 = item.postExtend.photos[2];
        return Container(
          child: Row(
            children: [
              InkWell(
                child: Container(
                  width: photo_w,
                  height: photo_w,
                  child: CachedNetworkImage(
                    imageUrl: photo0.photo,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  onPhotoItem(context, item, 0);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: InkWell(
                  child: Container(
                    width: photo_w,
                    height:photo_w,
                    child: CachedNetworkImage(
                      imageUrl: photo1.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    onPhotoItem(context, item, 1);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: InkWell(
                  child: Stack(
                    children: [
                      Container(
                        width: photo_w,
                        height: photo_w,
                        child: CachedNetworkImage(
                          imageUrl: photo2.photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      add_num > 0 ?Positioned(
                        top: 5,
                        right: 5,
                        child: Row(
                          children: <Widget>[
                            Text(
                              '+${add_num}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ):Container()
                    ],
                  ),
                  onTap: () {
                    onPhotoItem(context, item, 2);
                  },
                ),
              )
            ],
          ),
        );
      } else if (num == 2) {
        var photo1 = item.postExtend.photos[1];
        return Container(
          child: Row(
            children: [
              InkWell(
                child: Container(
                  width: photo_w,
                  height: photo_w,
                  child: CachedNetworkImage(
                    imageUrl: photo0.photo,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  onPhotoItem(context, item, 0);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: InkWell(
                  child: Container(
                    width: photo_w,
                    height: photo_w,
                    child: CachedNetworkImage(
                      imageUrl: photo1.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    onPhotoItem(context, item, 1);
                  },
                ),
              )
            ],
          ),
        );
      } else {
        return InkWell(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width),
            child: CachedNetworkImage(
              imageUrl: photo0.photo,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            onPhotoItem(context, item, 0);
          },
        );
      }
    } else {
      return Container();
    }
  }

  void onPhotoItem(BuildContext context, PostModel item, int index) {
    List<PhotoGalleryModel> gallery_photos = List<PhotoGalleryModel>();
    item.postExtend.photos.forEach((element) {
      gallery_photos.add(PhotoGalleryModel(element.photo));
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotosGalleryPage(gallery_photos, index)));
  }
}
