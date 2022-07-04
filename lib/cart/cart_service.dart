import 'dart:convert';
import 'package:flutter/material.dart';
import '../helpers/shared_preferences_helper.dart';
import '../theme/dialog.dart';


class CartService {
  static Future<void> addToCart(String productId, String variantId) async {
    var cart =
        await SharedPreferencesHelper.getValue(SharedPreferencesHelper.cart);
    var productVariantKey = getProductVariantKey(productId, variantId);
    if (cart.isEmpty) {
      var cartDto = {productVariantKey: 1};
      await SharedPreferencesHelper.setValue(
          SharedPreferencesHelper.cart, json.encode(cartDto));
    } else {
      var cartItems = json.decode(cart) as Map<String, dynamic>;
      if (cartItems.containsKey(productVariantKey)) {
        cartItems.update(productVariantKey, (prevQuantity) => prevQuantity + 1);
      } else {
        cartItems[productVariantKey] = 1;
      }
      await SharedPreferencesHelper.setValue(
          SharedPreferencesHelper.cart, json.encode(cartItems));
    }
  }

  static Future<void> removeFromCart(
      String productId, String variantId, int quantityToRemove) async {
    var cart =
        await SharedPreferencesHelper.getValue(SharedPreferencesHelper.cart);
    var productVariantKey = getProductVariantKey(productId, variantId);
    var cartItems = json.decode(cart) as Map<String, dynamic>;
    int prevQuantity = cartItems[productVariantKey];
    if (prevQuantity == 1) {
      cartItems.remove(productVariantKey);
      displayToastMessage('Item removed from your cart', color: Colors.orange);
    } else {
      if (prevQuantity <= quantityToRemove) {
        cartItems.remove(productVariantKey);
        displayToastMessage('Item removed from your cart', color: Colors.orange);
      } else {
        cartItems.update(productVariantKey,
            (prevQuantity) => prevQuantity - quantityToRemove);
      }
    }
    await SharedPreferencesHelper.setValue(
        SharedPreferencesHelper.cart, json.encode(cartItems));
  }

  static void removeVariantFromCart(String productVariantKey) async {
    var cart =
        await SharedPreferencesHelper.getValue(SharedPreferencesHelper.cart);
    var cartItems = json.decode(cart) as Map<String, dynamic>;
    cartItems.remove(productVariantKey);
    await SharedPreferencesHelper.setValue(
        SharedPreferencesHelper.cart, json.encode(cartItems));
    //displayToastMessage('Item removed from your cart', color: Colors.orange);
  }

  static Future<Map<String, dynamic>> getCartDetails() async {
    var cart =
        await SharedPreferencesHelper.getValue(SharedPreferencesHelper.cart);
    if (cart.isEmpty) {
      return {};
    }
    return json.decode(cart) as Map<String, dynamic>;
  }

  static String getProductVariantKey(String productId, String variantId) {
    return productId + '_' + variantId;
  }

  static String getProductIdFromKey(String key) {
    return key.split('_')[0];
  }

  static String getVariantIdFromKey(String key) {
    return key.split('_')[1];
  }
}
