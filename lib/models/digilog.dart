import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'digilog.g.dart';

@HiveType(typeId: 1)
class Digilog extends HiveObject {
  Digilog({
    required this.useruid,
    required this.location,
    required this.postedTime,
    required this.title,
  }) {
    Uuid uuid = const Uuid();
    digilogid = uuid.v4();
  }

  Digilog.fromJson(Map<String, dynamic> json) {
    useruid = json['useruid'];
    digilogid = json['digilogid'];
    location = (json['location'] != null
        ? Location.fromJson(json['location'])
        : null)!;
    postedTime = json['postedTime'];
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences.add(Experiences.fromJson(v));
      });
    }
    title = json['title'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      List<dynamic> _list = json['comments'];
      json['comments'].forEach((v) {
        comments.add(Comments.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['likes'] != null) {
      likes = <String>[];
      // json['likes'].forEach((v) {
      //   likes.add(v);
      // });
      likes = List<String>.from(json['likes'] ?? <String>[]);
    }
  }
  @HiveField(0)
  String useruid = "";
  @HiveField(1)
  String digilogid = "";
  @HiveField(2)
  late Location location;
  @HiveField(3)
  String postedTime = "";
  @HiveField(4)
  List<Experiences> experiences = <Experiences>[];
  @HiveField(5)
  String title = "";
  @HiveField(6)
  List<Comments> comments = <Comments>[];
  @HiveField(7)
  List<String> likes = <String>[];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['useruid'] = useruid;
    data['digilogid'] = digilogid;
    data['location'] = location.toJson();
    data['postedTime'] = postedTime;

    data['experiences'] =
        experiences.map((Experiences v) => v.toJson()).toList();
    data['title'] = title;
    data['comments'] = comments.map((Comments v) => v.toJson()).toList();
    data['likes'] = likes;
    return data;
  }
}

@HiveType(typeId: 2)
class Location {
  Location({required this.lat, required this.long, required this.maintext});
  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    maintext = json['maintext'];
  }
  @HiveField(0)
  double lat = 0.00;
  @HiveField(1)
  double long = 0.00;
  @HiveField(2)
  String maintext = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    data['maintext'] = maintext;
    return data;
  }
}

@HiveType(typeId: 3)
class Experiences {
  Experiences(
      {required this.mediaUrl,
      required this.mediatype,
      required this.description});
  Experiences.fromJson(Map<String, dynamic> json) {
    mediaUrl = json['mediaUrl'];
    mediatype = json['mediatype'];
    description = json['description'];
  }
  @HiveField(0)
  String mediaUrl = "";
  @HiveField(1)
  String mediatype = "";
  @HiveField(2)
  String description = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaUrl'] = mediaUrl;
    data['mediatype'] = mediatype;
    data['description'] = description;
    return data;
  }
}

@HiveType(typeId: 4)
class Comments {
  Comments({required this.uid, required this.message, required this.likes});
  Comments.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    message = json['message'];
    likes = List<String>.from(json['likes'] ?? <String>[]);
  }
  @HiveField(0)
  String uid = "";
  @HiveField(1)
  String message = "";
  @HiveField(2)
  List<String> likes = <String>[];
  @HiveField(3)
  String timestamp = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['message'] = message;
    data['likes'] = likes;
    return data;
  }
}
