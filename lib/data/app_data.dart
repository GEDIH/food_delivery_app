// lib/data/app_data.dart
import 'dart:convert'; // Import the dart:convert library for JSON operations

// 1. Enumeration for Food Categories
enum FoodCategory {
  traditionalEthiopian,
  westernFastFood,
  breakfast,
  stewAndCurry,
  unknown,
}

// Extension to safely convert String (from JSON) to FoodCategory enum
extension FoodCategoryExtension on String {
  FoodCategory toFoodCategory() {
    for (var category in FoodCategory.values) {
      if (category.toString().split('.').last == this) {
        return category;
      }
    }
    return FoodCategory.unknown; // Handle case where category string is missing/invalid
  }
}

// 2. FoodItem Data Transfer Object (DTO)
class FoodItem {
  final String name;
  final double price;
  final FoodCategory category;

  const FoodItem({
    required this.name,
    required this.price,
    required this.category,
  });

  // Factory constructor to create a FoodItem from a JSON Map
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(), // Handles both int and double from JSON
      category: (json['category'] as String).toFoodCategory(),
    );
  }

  // Method to convert the FoodItem object back to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category.toString().split('.').last, // Store enum name as string
    };
  }
}

// 3. Restaurant Data Transfer Object (DTO)
class Restaurant {
  final String id;
  final String name;
  final List<FoodItem> menu;
  final Map<String, dynamic> location; // Advanced: Add map for Geolocation data (lat/lng)

  const Restaurant({
    required this.id,
    required this.name,
    required this.menu,
    required this.location,
  });

  // Factory constructor to create a Restaurant from a JSON Map
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // Deserialize the list of menu items
    List<FoodItem> menuList = (json['menu'] as List<dynamic>)
        .map((itemJson) => FoodItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();

    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      menu: menuList,
      location: json['location'] as Map<String, dynamic>,
    );
  }

  // Method to convert the Restaurant object back to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // Serialize the list of menu items back to a list of JSON Maps
      'menu': menu.map((item) => item.toJson()).toList(),
      'location': location,
    };
  }
}

// --- CONSTANT JSON-LIKE MAP DATA (Simulating Firebase Structure) ---

// Define the data as a list of raw maps, mimicking what would come from a database query.
final List<Map<String, dynamic>> rawRestaurantData = [
  {
    'id': 'R001',
    'name': 'BRIGHT CAFE & RESTAURANT',
    'location': {'lat': 8.9806, 'lng': 38.7578},
    'menu': [
      {'name': 'PIZZA', 'price': 10.00, 'category': 'westernFastFood'},
      {'name': 'SPECIAL BURGER', 'price': 9.50, 'category': 'westernFastFood'},
      {'name': 'TIBS', 'price': 12.00, 'category': 'traditionalEthiopian'},
    ]
  },
  {
    'id': 'R002',
    'name': 'EAGLE CAFE',
    'location': {'lat': 9.0305, 'lng': 38.7634},
    'menu': [
      {'name': 'CHACHABSA', 'price': 5.50, 'category': 'breakfast'},
      {'name': 'CORORSA', 'price': 6.00, 'category': 'traditionalEthiopian'},
      {'name': 'ENKULAL FIRFIR', 'price': 7.00, 'category': 'breakfast'},
    ]
  },
  // ... continue with KIYA, HARME, KAKU in the same structure
];

// Final List of Restaurant Objects, populated by deserialization
final List<Restaurant> advancedRestaurantData = 
    rawRestaurantData.map((data) => Restaurant.fromJson(data)).toList();


// --- EXAMPLE USAGE (In another file, e.g., main.dart) ---

void main() {
  // 1. DESERIALIZATION: Converting the raw map data into Dart objects
  print('Total Restaurants Loaded: ${advancedRestaurantData.length}');
  
  final brightCafe = advancedRestaurantData.firstWhere((r) => r.id == 'R001');
  print('Loaded Restaurant: ${brightCafe.name}');
  print('Menu Item 1 Name: ${brightCafe.menu.first.name}');
  print('Menu Item 1 Category: ${brightCafe.menu.first.category.name}'); // Accessing the enum value

  // 2. SERIALIZATION: Converting a Dart object back into a JSON string (e.g., to send to Firebase)
  String jsonString = jsonEncode(brightCafe.toJson());
  print('\nSerialized JSON for BRIGHT CAFE:');
  print(jsonString); 
}
