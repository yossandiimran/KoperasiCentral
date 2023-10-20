// ignore_for_file: file_names, prefer_const_constructors,, prefer_interpolation_to_compose_strings

part of '../header.dart';

class ShimmerWidget {
  Widget defaultShimmer({required double width, required double height}) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.blueGrey.shade100,
        highlightColor: defWhite,
        child: Container(
          width: width,
          height: height,
          decoration: widget.decCont(defWhite, 20, 20, 20, 20),
        ),
      ),
    );
  }

  Widget listTileShimmer({required BuildContext context}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: widget.decCont2(defWhite, 20, 20, 20, 20),
        height: 100,
        child: Row(
          children: [
            Spacer(),
            shimmerWidget.defaultShimmer(width: global.getWidth(context) / 4, height: 60),
            Spacer(),
            Column(
              children: [
                Spacer(),
                shimmerWidget.defaultShimmer(width: global.getWidth(context) / 2, height: 10),
                Spacer(),
                shimmerWidget.defaultShimmer(width: global.getWidth(context) / 2, height: 10),
                Spacer(),
                shimmerWidget.defaultShimmer(width: global.getWidth(context) / 2, height: 10),
                Spacer(),
                shimmerWidget.defaultShimmer(width: global.getWidth(context) / 2, height: 10),
                Spacer(),
              ],
            ),
            Spacer(),
          ],
        ));
  }
}
