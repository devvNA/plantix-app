import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/modules/artikel/artikel_all/widgets/artikel_item_widget.dart';

import 'artikel_all_controller.dart';

class ArtikelAllPage extends GetView<ArtikelAllController> {
  const ArtikelAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtikelAllPage'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.7,
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
        ),
        itemCount: 10,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ArticleItem(
            onTap: () {},
            authorImage: "https://i.pravatar.cc/300",
            imageUrl:
                "https://mitrabertani.com/img/img_artikel/WEB_DESAIN_ARTIKEL_DWI.jpg",
            title: "Hari Tani Nasional",
            author: "admin01",
            date: DateTime.now().toFormattedDateWithDay(),
          );
        },
      ),
    );
  }
}
