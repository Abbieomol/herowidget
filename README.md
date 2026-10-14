# Flutter Hero Widget Demo
### Widget: Hero, a widget that animates a shared element smoothly from one screen to another during navigation.

## Final UI Screenshot
[View the final UI screenshot](screenshots/final_ui.png)

## Case Scenario
In an app like Carrefour Kenya, a shopper scrolls a grid of products with photos and prices. When they tap a product, a detail page opens with a larger photo and an "Add to cart" button. With Hero, the product photo grows from its position in the grid into the detail page and reverts when they go back, so the two screens feel connected. This demo uses the same pattern with a photo gallery: a grid of thumbnails opens into a full-screen photo, with extras like filters and a favorites heart. 

### How to run
Requirements: Flutter SDK and Android Studio with an Android emulator.

git clone https://github.com/Abbieomol/herowidget.git
cd herowidget
flutter pub get

Start an emulator from Android Studio's Device Manager and wait for the home screen.
Open the herowidget folder in Android Studio, pick the emulator in the device dropdown, and press Run.
Or from a terminal: flutter run
The first Android build takes a few minutes. The demo loads photos from picsum.photos, so the emulator needs internet access.
Where the widget is used

All code is in lib/main.dart:
GalleryTile: the Hero wrapping each thumbnail in the grid (lines 205 to 208)
DetailScreen: the matching Hero wrapping the full-screen photo (lines 262 to 264)
HomeScreen: each photo gets a unique tag, 'hero-$index' (line 157)

# The three attributes

## 1. tag
Default: none, it is required.
The tag is what links the two Hero widgets together. Both screens use the same tag, and Flutter finds the matching pair during navigation and animates between them. To test it, I changed the tag on the detail screen (line 263) to 'wrong-tag', and the animation disappeared: tapping a photo just cut to the new screen, because Flutter could no longer pair the two. Developers adjust the tag to make sure each item gets its own unique one. In this app it is built from the photo's position, 'hero-$index', and two Heroes sharing a tag on one screen causes an error. 

## 2. createRectTween
Default: null, which uses the curved, arc-shaped flight common in Material apps.
createRectTween controls the path the element takes while it moves between its start and end positions. I added createRectTween: (begin, end) => RectTween(begin: begin, end: end) to both Heroes, and the photo moved in a straight line instead of curving. A developer would change this to match the motion style of the app, for example a more formal, linear feel or a custom path.

## 3. placeholderBuilder
Default: null, so a space the same size as the original widget stays in the grid while the photo is in flight.
placeholderBuilder decides what shows in the original spot while the Hero is travelling. I returned Container(color: Colors.grey.shade300) on the thumbnail Hero, and a grey box held the photo's spot in the grid during the animation instead of a gap. Developers use this so the layout doesn't look hollow during the transition, and it is a good place for a loading style or a dimmed version of the item.

## Sources and credits
Flutter Hero docs: https://api.flutter.dev/flutter/widgets/Hero-class.html
Placeholder photos: https://picsum.photos

## Author
Leila Abbie Omol, presented in class on 14/10/2026.

