# Location Details Feature - Google Maps Style

## Overview
এই feature টি Google Maps এর মতো সম্পূর্ণ location details প্রদান করে। যখন কোনো location-এ click করা হয়, তখন সেই location সম্পর্কিত বিস্তারিত তথ্য এবং কাছাকাছি জায়গাগুলো দেখায়।

## Features Implemented

### 1. **Location Click Details**
- যেকোনো location-এ click করলে details দেখায়
- Location name, address, rating, phone number ইত্যাদি
- Bottom sheet-এ quick preview

### 2. **Photo Gallery**
- Google Places Photos API ব্যবহার করে location এর photos দেখায়
- Multiple photos এর জন্য swipeable gallery
- Default placeholder যদি photo না থাকে

### 3. **View Details Screen**
Complete details screen যাতে আছে:
- **Location Photos**: Expandable image gallery
- **Basic Information**: Name, Rating, Address, Phone
- **Opening Hours**: Open/Closed status
- **Website Link**: যদি থাকে
- **Action Buttons**:
  - Directions (Google Maps-এ open করে)
  - Save Place (favorites-এ save করে)

### 4. **Nearby Places**
Location এর কাছাকাছি বিভিন্ন ধরনের জায়গা দেখায়:
- **Hotel** 🏨 (lodging)
- **Restaurant** 🍽️ (restaurant)
- **ATM** 💰 (atm)
- **Shopping Mall** 🛍️ (shopping_mall)
- **Hospital** 🏥 (hospital)

প্রতিটি nearby place এর জন্য দেখায়:
- Name
- Photo (যদি থাকে)
- Rating
- Address
- Distance (km তে)

### 5. **Category Selection**
- Tap করে category select করা যায়
- Selected category highlight হয়
- Nearby places সেই অনুযায়ী filter হয়

## Files Structure

```
lib/features/map/
├── controller/
│   └── map_controller.dart          # Main controller with all logic
├── screen/
│   ├── map.dart                      # Map screen with bottom sheet
│   └── location_details_screen.dart # Full details screen
```

## Implementation Details

### MapController Methods

#### `onMapTap(LatLng position)`
- Map-এ tap করলে call হয়
- Reverse geocoding করে address পায়
- Place details fetch করে
- Nearby places load করে

#### `searchNearbyPlaces(double lat, double lng, String type)`
- Google Places API থেকে nearby places fetch করে
- Distance calculate করে
- Results sort করে distance অনুযায়ী

#### `getPhotoUrl(String photoReference)`
- Photo reference থেকে actual photo URL তৈরি করে
- Google Places Photos API ব্যবহার করে

#### `calculateDistance(lat1, lon1, lat2, lon2)`
- Haversine formula ব্যবহার করে distance calculate করে
- Result km তে return করে

## UI Components

### Bottom Sheet (Quick Preview)
```dart
- Location Name
- Rating ⭐
- Address 📍
- Phone ☎️
- Action Buttons:
  - View Details (blue)
  - Directions (green)
  - Save Place (outlined)
```

### Location Details Screen
```dart
SliverAppBar:
  - Photo Gallery (swipeable)
  - Back button
  - Share button

Details Section:
  - Name (24sp, bold)
  - Rating & Type
  - Address with icon
  - Phone (if available)
  - Opening hours (Open/Closed)
  - Website (if available)
  - Action Buttons (Directions, Save)

Nearby Places Section:
  - Category tabs (horizontal scroll)
  - Places list with:
    - Photo thumbnail
    - Name
    - Rating
    - Address
    - Distance
```

## API Usage

### Google Places API Endpoints Used:

1. **Place Details**
   ```
   GET /maps/api/place/details/json
   Parameters: place_id, fields, key
   ```

2. **Nearby Search**
   ```
   GET /maps/api/place/nearbysearch/json
   Parameters: location, radius, type, key
   ```

3. **Place Photos**
   ```
   GET /maps/api/place/photo
   Parameters: photo_reference, maxwidth, key
   ```

## Usage Example

```dart
// Map screen-এ যান
Get.to(() => MapScreen());

// Map-এ যেকোনো জায়গায় tap করুন
// Bottom sheet খুলবে details সহ

// "View Details" বাটনে click করুন
// Full details screen খুলবে

// Nearby category select করুন (Hotel, Restaurant, etc.)
// সেই category এর কাছাকাছি জায়গা দেখাবে

// কোনো nearby place-এ click করুন
// সেই place এর details দেখাবে
```

## Features Similar to Google Maps

✅ Location tap করলে details দেখায়
✅ Multiple photos gallery
✅ Rating display
✅ Address, phone, website information
✅ Opening hours status
✅ Nearby places categories (Hotel, Restaurant, ATM, Shopping, Hospital)
✅ Distance calculation
✅ Directions button
✅ Save to favorites
✅ Photo loading with placeholder
✅ Smooth animations
✅ Professional UI/UX

## Future Enhancements

🔮 **Planned Features:**
- Reviews and ratings display
- Street View integration
- Route planning
- Public transport directions
- Live traffic information
- Place booking/reservation
- User-generated content
- Indoor maps
- AR navigation
- Voice-guided directions

## Dependencies Required

```yaml
dependencies:
  google_maps_flutter: ^2.13.1
  geocoding: ^3.0.0
  geolocator: ^13.0.2
  http: ^1.5.0
  get: ^4.7.2
  flutter_screenutil: ^5.9.3
```

## API Configuration

Make sure you have:
1. Google Maps API key configured
2. Places API enabled
3. Geocoding API enabled
4. Maps SDK for Android/iOS enabled

## Testing

Test করার জন্য:
1. App চালু করুন
2. Map screen-এ যান
3. Map-এ যেকোনো জায়গায় tap করুন
4. Bottom sheet দেখুন
5. "View Details" click করুন
6. Different categories explore করুন
7. Nearby places দেখুন

## Notes

- API key সব API calls-এ ব্যবহৃত হয়
- Photos API এর জন্য billing enabled থাকতে হবে
- Distance calculate করা হয় Haversine formula দিয়ে
- Maximum 10 nearby places দেখায় প্রতি category তে
- Photos maximum 5টা দেখায়
- Error handling সব API calls-এ আছে

---

**Created:** November 11, 2025
**Version:** 1.0.0
**Status:** ✅ Completed
