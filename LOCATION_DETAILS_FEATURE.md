# Location Details Feature - Google Maps Style

## Overview
This feature provides complete location details similar to Google Maps. When a location is clicked, it shows detailed information about that location and nearby places.

## Features Implemented

### 1. **Location Click Details**
- Shows details when any location is clicked
- Location name, address, rating, phone number, etc.
- Quick preview in bottom sheet

### 2. **Photo Gallery**
- Shows location photos using Google Places Photos API
- Swipeable gallery for multiple photos
- Default placeholder if no photos available

### 3. **View Details Screen**
Complete details screen that includes:
- **Location Photos**: Expandable image gallery
- **Basic Information**: Name, Rating, Address, Phone
- **Opening Hours**: Open/Closed status
- **Website Link**: If available
- **Action Buttons**:
  - Directions (opens in Google Maps)
  - Save Place (saves to favorites)

### 4. **Nearby Places**
Shows different types of places near the location:
- **Hotel** 🏨 (lodging)
- **Restaurant** 🍽️ (restaurant)
- **ATM** 💰 (atm)
- **Shopping Mall** 🛍️ (shopping_mall)
- **Hospital** 🏥 (hospital)

Shows for each nearby place:
- Name
- Photo (if available)
- Rating
- Address
- Distance (in km)

### 5. **Category Selection**
- Category can be selected by tapping
- Selected category is highlighted
- Nearby places are filtered accordingly

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
- Called when the map is tapped
- Gets address through reverse geocoding
- Fetches place details
- Loads nearby places

#### `searchNearbyPlaces(double lat, double lng, String type)`
- Fetches nearby places from Google Places API
- Calculates distance
- Sorts results by distance

#### `getPhotoUrl(String photoReference)`
- Creates actual photo URL from photo reference
- Uses Google Places Photos API

#### `calculateDistance(lat1, lon1, lat2, lon2)`
- Calculates distance using Haversine formula
- Returns result in km

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
// Go to map screen
Get.to(() => MapScreen());

// Tap anywhere on the map
// Bottom sheet will open with details

// Click "View Details" button
// Full details screen will open

// Select a nearby category (Hotel, Restaurant, etc.)
// Nearby places of that category will be shown

// Click on any nearby place
// Details of that place will be shown
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

To test:
1. Launch the app
2. Go to map screen
3. Tap anywhere on the map
4. View the bottom sheet
5. Click "View Details"
6. Explore different categories
7. View nearby places

## Notes

- API key is used in all API calls
- Billing must be enabled for Photos API
- Distance is calculated using Haversine formula
- Maximum 10 nearby places shown per category
- Maximum 5 photos shown
- Error handling is present in all API calls

---

**Created:** November 11, 2025
**Version:** 1.0.0
**Status:** ✅ Completed
