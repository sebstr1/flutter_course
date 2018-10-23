import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http; // we give this package a name.
import 'dart:convert';

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;

  void addProduct(
      String title, String description, String image, double price) {
    final Map<String, dynamic> productdata = {
      'title': title,
      'description': description,
      'image':
          'https://petterssonorg.files.wordpress.com/2013/08/obama-boll.jpg',
      'price': price
    };
    http.post('https://fluttercourse-5f5ba.firebaseio.com/products.json',
        body: jsonEncode(productdata)).then((http.Response res) {

          final Map<String, dynamic> responseData = json.decode(res.body);

          final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email);
    _products.add(newProduct);
    notifyListeners();
        });
    
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email);
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners(); // To rebuild the part wrapped by ScopedModelDescendant
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);

    _products[_selProductIndex] = updatedProduct;
    notifyListeners(); // To rebuild the part wrapped by ScopedModelDescendant (Since we changed data (favorite status))
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners(); // To rebuild the part wrapped by ScopedModelDescendant
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(id: 'afsafafsfas', email: email, password: password);
  }
}
