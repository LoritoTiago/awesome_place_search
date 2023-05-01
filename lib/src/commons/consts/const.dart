import 'package:flutter/material.dart';

class GlobalConst {
  static final List<String> _shoppingList = [
    "supermarket",
    "grocery_or_supermarket",
    "shopping_mall",
    "book_store",
    "store",
    "food",
    "clothing_store",
    "convenience_store",
  ];

  static final List<String> _bankList = [
    "atm",
    "bank",
    "casino",
  ];

  static final List<String> _stationList = [
    "bus_station",
    "fire_station",
  ];
  static final List<String> _healthList = [
    "dentist",
    "doctor",
    "hospital",
    "veterinary_care",
    "physiotherapist",
    "pharmacy",
    "health",
  ];

  static final List<String> _foodList = [
    "cafe",
    "restaurant",
  ];

  static final List<String> _airportList = ["airport"];

  static final List<String> _artGalleryList = [
    'art_gallery',
    'amusement_park',
  ];

  static final List<String> _bikeList = [
    "bicycle_store",
    "bicycle_store",
  ];

  static List<Map<List<String>, IconData>> get typeList {
    return [
      {_shoppingList: Icons.shopping_bag_outlined},
      {_bankList: Icons.attach_money},
      {_healthList: Icons.health_and_safety_outlined},
      {_foodList: Icons.food_bank_outlined},
      {_airportList: Icons.connecting_airports_outlined},
      {_artGalleryList: Icons.photo_camera_back_outlined},
      {_bikeList: Icons.pedal_bike},
      {_stationList: Icons.directions_bus_filled_sharp},
    ];
  }
}
