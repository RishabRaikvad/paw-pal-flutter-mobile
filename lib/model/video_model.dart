class VideoModel {
  final String id;
  final String thumbnail;
  final String videoTitle;
  final String videoTime;
  final String ownerImage;
  final String ownerName;
  final String videoUrl;
 final bool isVisible;

  VideoModel({
    required this.id,
    required this.thumbnail,
    required this.videoTitle,
    required this.videoTime,
    required this.ownerImage,
    required this.ownerName,
    required this.videoUrl,
    required this.isVisible,
  });

  // From JSON
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoTitle: json['videoTitle'] ?? '',
      videoTime: json['videoTime'] ?? '',
      ownerImage: json['ownerImage'] ?? '',
      ownerName: json['ownerName'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      isVisible: json['isVisible'] ?? false
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'videoTitle': videoTitle,
      'videoTime': videoTime,
      'ownerImage': ownerImage,
      'ownerName': ownerName,
      'videoUrl': videoUrl,
      'isVisible':isVisible
    };
  }
}