# Project Structure
📦 food_delivery_app/
├── 📂 lib/
│   ├── 📂 core/
│   │   ├── 📂 config/
│   │   │   ├── 📄 app_config.dart      # App-wide configuration
│   │   │   └── 📄 env_config.dart      # Environment variables
│   │   ├── 📂 constants/
│   │   │   ├── 📄 api_paths.dart       # API endpoints
│   │   │   ├── 📄 app_constants.dart   # App-wide constants
│   │   │   └── 📄 asset_paths.dart     # Asset paths
│   │   ├── 📂 extensions/
│   │   │   ├── 📄 context_extensions.dart
│   │   │   └── 📄 string_extensions.dart
│   │   ├── 📂 theme/
│   │   │   ├── 📄 app_theme.dart       # Theme configuration
│   │   │   └── 📄 app_colors.dart      # Color constants
│   │   ├── 📂 utils/
│   │   │   ├── 📄 validators.dart      # Form validators
│   │   │   └── 📄 formatter.dart       # Data formatters
│   │   └── 📂 widgets/
│   │       ├── 📄 custom_button.dart
│   │       └── 📄 custom_text_field.dart
│   │
│   ├── 📂 features/
│   │   ├── 📂 auth/
│   │   │   ├── 📂 data/
│   │   │   │   ├── 📄 auth_repository.dart
│   │   │   │   └── 📄 auth_repository.g.dart
│   │   │   ├── 📂 domain/
│   │   │   │   └── 📄 user.dart
│   │   │   └── 📂 presentation/
│   │   │       ├── 📂 providers/
│   │   │       │   └── 📄 auth_provider.dart
│   │   │       └── 📂 screens/
│   │   │           ├── 📄 login_screen.dart
│   │   │           └── 📄 signup_screen.dart
│   │   │
│   │   ├── 📂 restaurants/
│   │   │   ├── 📂 data/
│   │   │   │   ├── 📄 restaurant_repository.dart
│   │   │   │   └── 📄 restaurant_repository.g.dart
│   │   │   ├── 📂 domain/
│   │   │   │   ├── 📄 restaurant.dart
│   │   │   │   └── 📄 menu_item.dart
│   │   │   └── 📂 presentation/
│   │   │       ├── 📂 providers/
│   │   │       │   └── 📄 restaurants_provider.dart
│   │   │       ├── 📂 screens/
│   │   │       │   ├── 📄 restaurants_screen.dart
│   │   │       │   └── 📄 restaurant_details_screen.dart
│   │   │       └── 📂 widgets/
│   │   │           ├── 📄 restaurant_card.dart
│   │   │           └── 📄 menu_item_card.dart
│   │   │
│   │   ├── 📂 cart/
│   │   │   ├── 📂 domain/
│   │   │   │   └── 📄 cart_item.dart
│   │   │   └── 📂 presentation/
│   │   │       ├── 📂 providers/
│   │   │       │   └── 📄 cart_provider.dart
│   │   │       ├── 📂 screens/
│   │   │       │   └── 📄 cart_screen.dart
│   │   │       └── 📂 widgets/
│   │   │           └── 📄 cart_item_card.dart
│   │   │
│   │   └── 📂 orders/
│   │       ├── 📂 data/
│   │       │   └── 📄 orders_repository.dart
│   │       ├── 📂 domain/
│   │       │   └── 📄 order.dart
│   │       └── 📂 presentation/
│   │           ├── 📂 providers/
│   │           │   └── 📄 orders_provider.dart
│   │           └── 📂 screens/
│   │               └── 📄 orders_screen.dart
│   │
│   ├── 📂 routing/
│   │   └── 📄 app_router.dart
│   │
│   ├── 📄 main.dart
│   └── 📄 app.dart
│
├── 📂 assets/
│   ├── 📂 images/
│   ├── 📂 icons/
│   └── 📂 fonts/
│
├── 📂 test/
│   ├── 📂 features/
│   │   └── 📂 auth/
│   │       └── 📄 auth_provider_test.dart
│   └── 📂 widgets/
│       └── 📄 custom_button_test.dart
│
└── 📄 pubspec.yaml


📦 food_delivery_app/
├── 📂 lib/
│   ├── 📂 core/
│   │   ├── 📂 config/
│   │   │   ├── 📄 app_config.dart
│   │   │   └── 📄 env_config.dart
│   │   ├── 📂 constants/
│   │   │   ├── 📄 api_paths.dart
│   │   │   ├── 📄 app_constants.dart
│   │   │   └── 📄 asset_paths.dart
│   │   ├── 📂 extensions/
│   │   │   ├── 📄 context_extensions.dart
│   │   │   └── 📄 string_extensions.dart
│   │   ├── 📂 theme/
│   │   │   ├── 📄 app_theme.dart
│   │   │   └── 📄 app_colors.dart
│   │   └── 📂 utils/
│   │       ├── 📄 validators.dart
│   │       └── 📄 formatter.dart
│   │
│   ├── 📂 data/
│   │   ├── 📂 models/
│   │   │   ├── 📄 user.dart
│   │   │   ├── 📄 restaurant.dart
│   │   │   ├── 📄 menu_item.dart
│   │   │   ├── 📄 cart_item.dart
│   │   │   └── 📄 order.dart
│   │   └── 📂 repositories/
│   │       ├── 📄 auth_repository.dart
│   │       ├── 📄 restaurant_repository.dart
│   │       └── 📄 order_repository.dart
│   │
│   ├── 📂 providers/
│   │   ├── 📄 auth_provider.dart
│   │   ├── 📄 cart_provider.dart
│   │   ├── 📄 restaurant_provider.dart
│   │   └── 📄 order_provider.dart
│   │
│   ├── 📂 widgets/
│   │   ├── 📂 common/
│   │   │   ├── 📄 custom_button.dart
│   │   │   ├── 📄 custom_text_field.dart
│   │   │   └── 📄 loading_indicator.dart
│   │   └── 📂 cards/
│   │       ├── 📄 restaurant_card.dart
│   │       ├── 📄 menu_item_card.dart
│   │       ├── 📄 cart_item_card.dart
│   │       └── 📄 order_card.dart
│   │
│   ├── 📂 screens/
│   │   ├── 📂 auth/
│   │   │   ├── 📄 login_screen.dart
│   │   │   ├── 📄 signup_screen.dart
│   │   │   └── 📄 forgot_password_screen.dart
│   │   │
│   │   ├── 📂 home/
│   │   │   ├── 📄 home_screen.dart
│   │   │   └── 📂 widgets/
│   │   │       ├── 📄 category_list.dart
│   │   │       └── 📄 featured_restaurants.dart
│   │   │
│   │   ├── 📂 restaurants/
│   │   │   ├── 📄 restaurants_screen.dart
│   │   │   ├── 📄 restaurant_details_screen.dart
│   │   │   └── 📂 widgets/
│   │   │       ├── 📄 restaurant_info_header.dart
│   │   │       └── 📄 menu_section.dart
│   │   │
│   │   ├── 📂 cart/
│   │   │   ├── 📄 cart_screen.dart
│   │   │   └── 📂 widgets/
│   │   │       ├── 📄 cart_summary.dart
│   │   │       └── 📄 checkout_button.dart
│   │   │
│   │   ├── 📂 checkout/
│   │   │   ├── 📄 checkout_screen.dart
│   │   │   └── 📂 widgets/
│   │   │       ├── 📄 address_form.dart
│   │   │       └── 📄 payment_methods.dart
│   │   │
│   │   ├── 📂 orders/
│   │   │   ├── 📄 orders_screen.dart
│   │   │   ├── 📄 order_details_screen.dart
│   │   │   └── 📂 widgets/
│   │   │       ├── 📄 order_status_tracker.dart
│   │   │       └── 📄 order_items_list.dart
│   │   │
│   │   └── 📂 profile/
│   │       ├── 📄 profile_screen.dart
│   │       └── 📂 widgets/
│   │           ├── 📄 profile_header.dart
│   │           └── 📄 settings_list.dart
│   │
│   ├── 📂 routing/
│   │   └── 📄 app_router.dart
│   │
│   ├── 📄 main.dart
│   └── 📄 app.dart
│
├── 📂 assets/
│   ├── 📂 images/
│   ├── 📂 icons/
│   └── 📂 fonts/
│
├── 📂 test/
│   ├── 📂 screens/
│   │   ├── 📂 auth/
│   │   │   └── 📄 login_screen_test.dart
│   │   └── 📂 home/
│   │       └── 📄 home_screen_test.dart
│   ├── 📂 widgets/
│   │   └── 📄 custom_button_test.dart
│   └── 📂 providers/
│       └── 📄 auth_provider_test.dart
│
└── 📄 pubspec.yaml

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
  
  # Local Storage
  shared_preferences: ^2.2.2
  isar: ^3.1.0s
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