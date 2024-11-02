///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/5/11 11:37
///
import 'package:chat_app/core/helper/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../internal/singleton.dart';
import '../../widget/scale_text.dart';

class AssetEntityGridItemBuilder extends StatefulWidget {
  const AssetEntityGridItemBuilder({
    Key? key,
    required this.image,
    required this.failedItemBuilder,
  }) : super(key: key);

  final AssetEntityImageProvider image;
  final WidgetBuilder failedItemBuilder;

  @override
  AssetEntityGridItemWidgetState createState() =>
      AssetEntityGridItemWidgetState();
}

class AssetEntityGridItemWidgetState extends State<AssetEntityGridItemBuilder> {
  Widget? child;

  Widget get newChild {
    return widget.image.entity.mimeType == 'video/mp4'?
    FutureBuilder(future: widget.image.entity.thumbnailData, builder: (context, snapshot) {
     if(snapshot.connectionState == ConnectionState.waiting){ 
        return Shimmer.fromColors(baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    color: Colors.white,
                  ),
                ));
      }
     else if(snapshot.hasData){
        return RepaintBoundary(child: Image.memory(snapshot.data!, fit: BoxFit.cover));
      } else{
        return widget.failedItemBuilder(context);
      } 
    })
    : FutureBuilder(
        future: widget.image.entity.file,
    builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Shimmer.fromColors(baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.h, horizontal: 10.w),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    color: Colors.white,
                  ),
                ));
      }
     else if(snapshot.hasData){
        return RepaintBoundary(child: Image.file(snapshot.data!, fit: BoxFit.cover,));
      } else{
        return widget.failedItemBuilder(context);
      }
    });
    // return ExtendedImage(
    //   image: widget.image,
    //   fit: BoxFit.cover,
    //   loadStateChanged: (ExtendedImageState state) {
    //     Widget loader = const SizedBox.shrink();
    //     switch (state.extendedImageLoadState) {
    //       case LoadState.loading:
    //         loader = Shimmer.fromColors(baseColor: Colors.grey.shade300,
    //             highlightColor: Colors.grey.shade100,
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(
    //                   vertical: 8.h, horizontal: 10.w),
    //               child: ClipOval(
    //                 child: Container(
    //                   width: 48.w,
    //                   height: 48.w,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ));
    //         break;
    //       case LoadState.completed:
    //         loader = RepaintBoundary(child: state.completedWidget);
    //         break;
    //       case LoadState.failed:
    //         loader = widget.failedItemBuilder(context);
    //         break;
    //     }
    //     return loader;
    //   },
    // );
  }

  /// Item widgets when the thumbnail data load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: ScaleText(
        Singleton.textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
        semanticsLabel: Singleton.textDelegate.semanticsTextDelegate.loadFailed,
      ),
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    child ??= newChild;
    return child!;
  }
}
