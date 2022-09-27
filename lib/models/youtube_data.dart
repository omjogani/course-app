import 'dart:convert';

VideoInfo videoInfoFromJson(String str) => VideoInfo.fromJson(json.decode(str));

String videoInfoToJson(VideoInfo data) => json.encode(data.toJson());

class VideoInfo {
  VideoInfo({
    required this.version,
    required this.thumbnailHeight,
    required this.url,
    required this.html,
    required this.type,
    required this.providerUrl,
    required this.height,
    required this.title,
    required this.thumbnailUrl,
    required this.authorUrl,
    required this.authorName,
    required this.providerName,
    required this.width,
    required this.thumbnailWidth,
  });

  String version;
  int thumbnailHeight;
  String url;
  String html;
  String type;
  String providerUrl;
  int height;
  String title;
  String thumbnailUrl;
  String authorUrl;
  String authorName;
  String providerName;
  int width;
  int thumbnailWidth;

  Map<String, dynamic> toJson() => {
        "version": version,
        "thumbnail_height": thumbnailHeight,
        "url": url,
        "html": html,
        "type": type,
        "provider_url": providerUrl,
        "height": height,
        "title": title,
        "thumbnail_url": thumbnailUrl,
        "author_url": authorUrl,
        "author_name": authorName,
        "provider_name": providerName,
        "width": width,
        "thumbnail_width": thumbnailWidth,
      };

  factory VideoInfo.fromJson(dynamic json) {
    return VideoInfo(
      version: json["version"],
      thumbnailHeight: json["thumbnail_height"],
      url: json["url"],
      html: json["html"],
      type: json["type"],
      providerUrl: json["provider_url"],
      height: json["height"],
      title: json["title"],
      thumbnailUrl: json["thumbnail_url"],
      authorUrl: json["author_url"],
      authorName: json["author_name"],
      providerName: json["provider_name"],
      width: json["width"],
      thumbnailWidth: json["thumbnail_width"],
    );
  }

  static List<VideoInfo> videoInfoFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return VideoInfo.fromJson(data);
    }).toList();
  }
}