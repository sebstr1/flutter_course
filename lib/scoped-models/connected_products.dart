import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http; // we give this package a name.
import 'dart:convert';
import 'dart:async';

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;


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

  String get selectedProductId {
    return _selProductId;
  }

  int get selectedProductIndex {
    return _products
        .indexWhere((Product product) => product.id == _selProductId);
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    }
    return _products
        .firstWhere((Product product) => product.id == _selProductId);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

    Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productdata = {
      'title': title,
      'description': description,
      'image':
          'https://petterssonorg.files.wordpress.com/2013/08/obama-boll.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response res = await http.post(
          'https://fluttercourse-5f5ba.firebaseio.com/products.json',
          body: jsonEncode(productdata));

      if (res.statusCode != 200 && res.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
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
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://petterssonorg.files.wordpress.com/2013/08/obama-boll.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .put(
            'https://fluttercourse-5f5ba.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://fluttercourse-5f5ba.firebaseio.com/products/$deletedProductId.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://fluttercourse-5f5ba.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      final Map<String, dynamic> productListData = json.decode(response.body);
      final List<Product> fetchedProductList = [];
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productdata) {
        final Product product = Product(
            id: productId,
            title: productdata['title'],
            description: productdata['description'],
            image: productdata['image'],
            price: productdata['price'],
            userEmail: productdata['userEmail'],
            userId: productdata['userId']);
        fetchedProductList.add(product);
      });
      _isLoading = false;
      _products = fetchedProductList;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners(); // To rebuild the part wrapped by ScopedModelDescendant
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);

    _products[selectedProductIndex] = updatedProduct;
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

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
