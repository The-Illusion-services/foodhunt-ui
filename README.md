# pubspec.yaml configuration
name: food_delivery_app
description: A food delivery application built with Flutter.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  # State Management
  flutter_riverpod: ^2.4.10
  riverpod_annotation: ^2.3.4
  
  # Routing
  go_router: ^13.2.0
  
  # Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  
  # UI Components
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  flutter_svg: ^2.0.10+1
  lottie: ^3.1.0
  
  # Forms and Validation
  form_builder_validators: ^9.1.0
  flutter_form_builder: ^9.2.1
  
  # Utilities
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  intl: ^0.19.0
  logger: ^2.0.2+1
  
  # Maps and Location
  google_maps_flutter: ^2.5.3
  geolocator: ^10.1.1
  
  # Payment
  flutter_stripe: ^10.1.0
  
  # Image
  image_picker: ^1.0.7
  image_cropper: ^5.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.8
  riverpod_generator: ^2.3.9
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  isar_generator: ^3.1.0
  
  # Testing
  mocktail: ^1.0.3
  
  # Linting
  flutter_lints: ^3.0.1
  custom_lint: ^0.6.2
  riverpod_lint: ^2.3.9

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/lottie/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700

# VS Code settings
.vscode/settings.json:
{
  "dart.lineLength": 80,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}