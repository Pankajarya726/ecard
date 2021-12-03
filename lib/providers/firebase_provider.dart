import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseProvider with ChangeNotifier {
  List<Banner> bannerList = [];
  Banner banner2;
  Banner banner3;

  CollectionReference banners =
      FirebaseFirestore.instance.collection('banners');
  CollectionReference banners2 =
      FirebaseFirestore.instance.collection('banner2');
  CollectionReference banners3 =
      FirebaseFirestore.instance.collection('banner3');

  Future<void> getBanner() async {
    try {
      bannerList = [];
      banners.snapshots().listen((event) {
        print(event.docs[0]["banner"]);

        for (int i = 0; i < event.docs[0]["banner"].length; i++) {
          bannerList.add(Banner(
            event.docs[0]["banner"][i]["image"],
            event.docs[0]["banner"][i]["id"],
            event.docs[0]["banner"][i]["category"],
          ));
        }
      });
      banners2.snapshots().listen((event) {
        banner2 = Banner(
          event.docs[0]["banner"]["image"],
          event.docs[0]["banner"]["id"],
          event.docs[0]["banner"]["category"],
        );
      });
      banners3.snapshots().listen((event) {
        banner3 = Banner(
          event.docs[0]["banner"]["image"],
          event.docs[0]["banner"]["id"],
          event.docs[0]["banner"]["category"],
        );
        print(banner3.image);
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}

///BANNER MODEL
class Banner {
  final String image;
  final int id;
  final bool category;

  Banner(this.image, this.id, this.category);
}
