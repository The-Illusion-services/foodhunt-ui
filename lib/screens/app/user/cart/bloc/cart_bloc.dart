import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/models/core/cart.new.dart';
import 'package:food_hunt/services/models/core/store.new.dart';
import 'package:food_hunt/services/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearStoreCart>(_onClearStoreCart);
    on<ClearEntireCart>(_onClearEntireCart);
    on<LoadCartFromStorage>(_onLoadCartFromStorage);
  }

  void _onLoadCartFromStorage(
      LoadCartFromStorage event, Emitter<CartState> emit) async {
    try {
      final stores = await CartStorageService.loadCart();
      emit(CartLoaded(stores: stores));
    } catch (e) {
      emit(CartError(errorMessage: 'Failed to load cart: ${e.toString()}'));
    }
  }

  void _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) {
    try {
      final currentState = state;
      if (currentState is CartLoaded) {
        // Check if store exists
        final existingStoreIndex = currentState.stores
            .indexWhere((store) => store.id == event.store.id);

        List<Store> updatedStores;
        if (existingStoreIndex != -1) {
          // Store exists, update or add item
          updatedStores = List.from(currentState.stores);
          final existingStore = updatedStores[existingStoreIndex];

          // Check if item exists in store
          final existingItemIndex = existingStore.items
              .indexWhere((item) => item.id == event.item.id);

          if (existingItemIndex != -1) {
            // Update quantity if item exists
            final updatedItems = List.from(existingStore.items);
            updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
                .copyWith(
                    quantity: updatedItems[existingItemIndex].quantity + 1);

            updatedStores[existingStoreIndex] =
                existingStore.copyWith(items: updatedItems.cast<CartItem>());
          } else {
            // Add new item to store
            updatedStores[existingStoreIndex] = existingStore
                .copyWith(items: [...existingStore.items, event.item]);
          }
        } else {
          // New store, add store with item
          updatedStores = [...currentState.stores, event.store];
        }

        emit(CartLoaded(stores: updatedStores));
      } else {
        // Initial state, create new cart
        emit(CartLoaded(stores: [event.store]));
      }
    } catch (e) {
      emit(CartError(errorMessage: 'Failed to add item: ${e.toString()}'));
    }
  }

  void _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) {
    try {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedStores = List<Store>.from(currentState.stores);

        final storeIndex =
            updatedStores.indexWhere((store) => store.id == event.store.id);

        if (storeIndex != -1) {
          final updatedItems = List.from(updatedStores[storeIndex].items);
          final itemIndex =
              updatedItems.indexWhere((item) => item.id == event.item.id);

          if (itemIndex != -1) {
            if (updatedItems[itemIndex].quantity > 1) {
              // Decrease quantity
              updatedItems[itemIndex] = updatedItems[itemIndex]
                  .copyWith(quantity: updatedItems[itemIndex].quantity - 1);
            } else {
              // Remove item completely
              updatedItems.removeAt(itemIndex);
            }

            // Update store with modified items
            updatedStores[storeIndex] = updatedStores[storeIndex]
                .copyWith(items: updatedItems.cast<CartItem>());

            // Remove store if no items left
            if (updatedStores[storeIndex].items.isEmpty) {
              updatedStores.removeAt(storeIndex);
            }
          }

          emit(CartLoaded(stores: updatedStores));
        }
      }
    } catch (e) {
      emit(CartError(errorMessage: 'Failed to remove item: ${e.toString()}'));
    }
  }

  void _onClearStoreCart(ClearStoreCart event, Emitter<CartState> emit) {
    try {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedStores = List<Store>.from(currentState.stores)
          ..removeWhere((store) => store.id == event.store.id);

        emit(CartLoaded(stores: updatedStores));
      }
    } catch (e) {
      emit(CartError(
          errorMessage: 'Failed to clear store cart: ${e.toString()}'));
    }
  }

  void _onClearEntireCart(ClearEntireCart event, Emitter<CartState> emit) {
    try {
      emit(CartInitial());
    } catch (e) {
      emit(CartError(
          errorMessage: 'Failed to clear entire cart: ${e.toString()}'));
    }
  }

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    if (change.nextState is CartLoaded) {
      CartStorageService.saveCart((change.nextState as CartLoaded).stores);
    }
  }
}
