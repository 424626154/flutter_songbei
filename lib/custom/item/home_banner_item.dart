
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_songbei/manager/ui_manager.dart';
import 'package:flutter_songbei/models/banner_model.dart';

import '../../app_config.dart';

class HomeBannerItem extends StatelessWidget{
  BannerModel item;
  HomeBannerItem(this.item);

  @override
  Widget build(BuildContext context) {
    var banner_w = MediaQuery.of(context).size.width;
    var banner_h = banner_w*AppConfig.BANNER_SCALE;
    return GestureDetector(
          child:  Container(
            color: Colors.red,
            child: CachedNetworkImage(
              width: banner_w,
              height: banner_h,
              imageUrl:item.cover,
              fit: BoxFit.fitWidth,
            ),
          ),
          onTap: () {
            UIManager.goBannerItem(context,item);
          }
        );
  }

}