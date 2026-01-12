import 'package:ai_powered_tourists_app/features/home/widget/place.dart';

class NearbyPlace {
  final String placeId;
  final String placeName;
  final String placeImage;
  final String placeDescription;
  final String placeRating;
  final double latitude;
  final double longitude;
  final String distanceKm;

  NearbyPlace({
    required this.placeId,
    required this.placeName,
    required this.placeImage,
    required this.placeDescription,
    required this.placeRating,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  // Factory constructor to create NearbyPlace from JSON
  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      placeId: json['place_id'] ?? '',
      placeName: json['place_name'] ?? '',
      placeImage: json['place_image'] ?? '',
      placeDescription: json['place_description'] ?? '',
      placeRating: json['place_rating']?.toString() ?? '0.0',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      distanceKm: json['distance_km']?.toString() ?? '0.0',
    );
  }

  // Convert NearbyPlace to JSON
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'place_image': placeImage,
      'place_description': placeDescription,
      'place_rating': placeRating,
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
    };
  }

  // Convert to Place object for compatibility with existing PlaceCard widget
  Place toPlace() {
    return Place(
      id: placeId,
      title: placeName,
      description: placeDescription,
      imageUrl: placeImage,
      rating: double.tryParse(placeRating) ?? 0.0,
      distanceKm: double.tryParse(distanceKm) ?? 0.0,
      category: 'nearby',
    );
  }
}

// Response model for the API
class NearbyPlacesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<NearbyPlace> data;
  final String timestamp;

  NearbyPlacesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory NearbyPlacesResponse.fromJson(Map<String, dynamic> json) {
    return NearbyPlacesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => NearbyPlace.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
    );
  }
}
