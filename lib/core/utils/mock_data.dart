import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/services/models/core/store.dart';

final List<Store> stores = [
  Store(
    name: 'Chicken Republic',
    type: 'Restaurant',
    distance: '1.2 km',
    status: 'Open',
    rating: 4.5,
    image: AppAssets.storeImage1,
    logo: AppAssets.storeLogoCR,
  ),
  Store(
    name: 'Burger King',
    type: 'Restaurant',
    distance: '2.5 km',
    status: 'Closed',
    rating: 4.2,
    image: AppAssets.storeImage2,
    logo: AppAssets.storeLogoBK,
  ),
  Store(
    name: 'Tasty Bite',
    type: 'Restaurant',
    distance: '7 km',
    status: 'Open',
    rating: 3.8,
    image: AppAssets.storeImage3,
    logo: AppAssets.storeLogoTB,
  ),
  Store(
    name: 'KFC King',
    type: 'Restaurant',
    distance: '2.5 km',
    status: 'Closed',
    rating: 4.6,
    image: AppAssets.storeImage4,
    logo: AppAssets.storeLogoKFC,
  ),
  Store(
    name: 'Star Bucks',
    type: 'Restaurant',
    distance: '12 km',
    status: 'Closed',
    rating: 4.1,
    image: AppAssets.storeImage5,
    logo: AppAssets.storeLogoSB,
  ),
];
