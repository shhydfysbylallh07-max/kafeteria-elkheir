import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: KafeteriaAlKheirApp(),
    ),
  );
}

class KafeteriaAlKheirApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كافتيريا الخير',
      theme: ThemeData(
        primaryColor: Color(0xFF0A7B0A),
        primarySwatch: Colors.green,
        fontFamily: 'Almarai', // الخط الرئيسي
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A7B0A),
          ),
          displayMedium: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A7B0A),
          ),
          titleLarge: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A7B0A),
          elevation: 10,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          titleTextStyle: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0A7B0A),
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainNavigationScreen(),
    );
  }
}

// ============================================
// MODELS - نماذج البيانات
// ============================================

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final bool isFeatured;
  final double rating;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    this.isFeatured = false,
    this.rating = 0.0,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'rating': rating,
      'isAvailable': isAvailable,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      imageUrl: json['imageUrl'],
      isFeatured: json['isFeatured'] ?? false,
      rating: json['rating']?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.imageUrl,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

// ============================================
// PROVIDERS - مقدمي البيانات
// ============================================

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  ProductProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.delayed(Duration(milliseconds: 800));
    
    // إعداد الأقسام بصور احترافية
    _categories = [
      Category(
        id: '1',
        name: 'عصائر طازجة',
        icon: Icons.local_drink,
        color: Color(0xFF4CAF50),
        imageUrl: 'https://cdn.pixabay.com/photo/2017/01/20/14/59/orange-1995044_1280.jpg',
      ),
      Category(
        id: '2',
        name: 'سندوتشات',
        icon: Icons.fastfood,
        color: Color(0xFFFF9800),
        imageUrl: 'https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_1280.jpg',
      ),
      Category(
        id: '3',
        name: 'وجبات خفيفة',
        icon: Icons.restaurant,
        color: Color(0xFFF44336),
        imageUrl: 'https://cdn.pixabay.com/photo/2017/12/10/14/47/pizza-3010062_1280.jpg',
      ),
      Category(
        id: '4',
        name: 'مشروبات ساخنة',
        icon: Icons.coffee,
        color: Color(0xFF795548),
        imageUrl: 'https://cdn.pixabay.com/photo/2017/03/04/12/41/coffee-2116099_1280.jpg',
      ),
      Category(
        id: '5',
        name: 'حلويات',
        icon: Icons.cake,
        color: Color(0xFFE91E63),
        imageUrl: 'https://cdn.pixabay.com/photo/2018/05/01/13/04/desert-3364350_1280.jpg',
      ),
    ];

    // المنتجات مع أسعار مناسبة
    _products = [
      // عصائر طازجة
      Product(
        id: '1',
        name: 'عصير برتقال طازج',
        description: 'عصير برتقال طبيعي 100% مع قطع البرتقال الطازجة، غني بفيتامين سي',
        price: 1500,
        categoryId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/01/20/14/59/orange-1995044_1280.jpg',
        isFeatured: true,
        rating: 4.8,
      ),
      Product(
        id: '2',
        name: 'عصير فراولة مثلج',
        description: 'عصير فراولة طازج مع قطع الفواكه والثلج، منعش وصحي',
        price: 1700,
        categoryId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/01/11/11/33/cake-1971552_1280.jpg',
        isFeatured: true,
        rating: 4.7,
      ),
      Product(
        id: '3',
        name: 'سموذي المانجو',
        description: 'مزيج رائع من المانجو الطازج مع الحليب والثلج',
        price: 1900,
        categoryId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/09/16/19/21/salad-2756467_1280.jpg',
        isFeatured: false,
        rating: 4.6,
      ),
      Product(
        id: '4',
        name: 'عصير جزر وبرتقال',
        description: 'مزيج صحي من الجزر والبرتقال، غني بالفيتامينات',
        price: 1600,
        categoryId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/06/02/18/24/carrot-2366042_1280.jpg',
        isFeatured: false,
        rating: 4.5,
      ),
      Product(
        id: '5',
        name: 'عصير أناناس مثلج',
        description: 'عصير أناناس طازج مع النعناع، منعش وحيوي',
        price: 1800,
        categoryId: '1',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/10/09/17/06/pineapple-1726425_1280.jpg',
        isFeatured: true,
        rating: 4.9,
      ),

      // سندوتشات
      Product(
        id: '6',
        name: 'سندوتش شاورما دجاج',
        description: 'شاورما دجاج مع الخضار الطازجة والصلصة الخاصة',
        price: 2500,
        categoryId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg',
        isFeatured: true,
        rating: 4.8,
      ),
      Product(
        id: '7',
        name: 'سندوتش جبنة مشوية',
        description: 'جبنة شيدر مع الخضار المشوية، ساخن ولذيذ',
        price: 1800,
        categoryId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/03/23/19/57/asparagus-2169305_1280.jpg',
        isFeatured: false,
        rating: 4.4,
      ),
      Product(
        id: '8',
        name: 'برجر دجاج خاص',
        description: 'برجر دجاج مع الخس والطماطم والمايونيز',
        price: 2800,
        categoryId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_1280.jpg',
        isFeatured: true,
        rating: 4.9,
      ),
      Product(
        id: '9',
        name: 'سندوتش تونة',
        description: 'تونة طازجة مع الذرة والمايونيز، صحي ولذيذ',
        price: 2200,
        categoryId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/10/25/13/29/sandwich-1768450_1280.jpg',
        isFeatured: false,
        rating: 4.3,
      ),
      Product(
        id: '10',
        name: 'سندوتش لحم بقري',
        description: 'لحم بقري مشوي مع الخضار، وجبة متكاملة',
        price: 3000,
        categoryId: '2',
        imageUrl: 'https://cdn.pixabay.com/photo/2018/10/22/22/17/steak-3766548_1280.jpg',
        isFeatured: true,
        rating: 4.7,
      ),

      // وجبات خفيفة
      Product(
        id: '11',
        name: 'بيتزا صغيرة',
        description: 'بيتزا بالجبنة والزيتون والفطر، مقرمشة ولذيذة',
        price: 3000,
        categoryId: '3',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/12/10/14/47/pizza-3010062_1280.jpg',
        isFeatured: true,
        rating: 4.8,
      ),
      Product(
        id: '12',
        name: 'بطاطس فرينش فرايز',
        description: 'بطاطس مقلية مقرمشة، مع الصلصة الخاصة',
        price: 1200,
        categoryId: '3',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/11/20/09/06/bowl-1842294_1280.jpg',
        isFeatured: false,
        rating: 4.5,
      ),
      Product(
        id: '13',
        name: 'تشيز برجر صغير',
        description: 'برجر صغير بالجبنة، وجبة خفيفة وسريعة',
        price: 2000,
        categoryId: '3',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/03/05/22/18/american-1239091_1280.jpg',
        isFeatured: false,
        rating: 4.4,
      ),
      Product(
        id: '14',
        name: 'نقانق مشوية',
        description: 'نقانق مشوية مع الخردل، طعم لا يقاوم',
        price: 1800,
        categoryId: '3',
        imageUrl: 'https://cdn.pixabay.com/photo/2016/03/05/20/00/hot-dog-1238576_1280.jpg',
        isFeatured: true,
        rating: 4.6,
      ),

      // مشروبات ساخنة
      Product(
        id: '15',
        name: 'قهوة تركية',
        description: 'قهوة تركية أصيلة مع الهيل، طعم تقليدي رائع',
        price: 1000,
        categoryId: '4',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/03/04/12/41/coffee-2116099_1280.jpg',
        isFeatured: true,
        rating: 4.7,
      ),
      Product(
        id: '16',
        name: 'كابتشينو إيطالي',
        description: 'كابتشينو مع رغوة الحليب، إيطالي أصيل',
        price: 1500,
        categoryId: '4',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/04/22/10/44/coffee-2251644_1280.jpg',
        isFeatured: true,
        rating: 4.8,
      ),
      Product(
        id: '17',
        name: 'شاي بالنعناع',
        description: 'شاي أخضر مع النعناع الطازج، منعش ومفيد',
        price: 800,
        categoryId: '4',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/03/01/05/12/tea-cup-2107599_1280.jpg',
        isFeatured: false,
        rating: 4.3,
      ),
      Product(
        id: '18',
        name: 'شوكولاتة ساخنة',
        description: 'شوكولاتة ساخنة مع الكريم، دافئة ولذيذة',
        price: 1700,
        categoryId: '4',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/01/12/17/30/friends-1974841_1280.jpg',
        isFeatured: true,
        rating: 4.9,
      ),

      // حلويات
      Product(
        id: '19',
        name: 'كيك الشوكولاتة',
        description: 'كيك شوكولاتة طري مع طبقة الكريمة، قطعة من الجنة',
        price: 1200,
        categoryId: '5',
        imageUrl: 'https://cdn.pixabay.com/photo/2018/05/01/13/04/desert-3364350_1280.jpg',
        isFeatured: true,
        rating: 4.8,
      ),
      Product(
        id: '20',
        name: 'كنافة بالنوتيلا',
        description: 'كنافة مقرمشة مع شوكولاتة النوتيلا، طعم شرقي مميز',
        price: 2200,
        categoryId: '5',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/01/11/11/33/cake-1971556_1280.jpg',
        isFeatured: true,
        rating: 4.9,
      ),
      Product(
        id: '21',
        name: 'تشيز كيك',
        description: 'تشيز كيك كلاسيكي مع طبقة التوت، ناعم وكريمي',
        price: 1800,
        categoryId: '5',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/03/19/18/22/cheesecake-2157232_1280.jpg',
        isFeatured: false,
        rating: 4.6,
      ),
      Product(
        id: '22',
        name: 'دونات بالتوفي',
        description: 'دونات طري مع طبقة التوفي، حلو ولذيذ',
        price: 900,
        categoryId: '5',
        imageUrl: 'https://cdn.pixabay.com/photo/2017/09/30/15/10/plate-2802332_1280.jpg',
        isFeatured: true,
        rating: 4.7,
      ),
    ];

    _isLoading = false;
    notifyListeners();
    _saveToLocal();
  }

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  List<Product> get featuredProducts {
    return _products.where((p) => p.isFeatured).toList();
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = _products.map((p) => p.toJson()).toList();
    await prefs.setString('products', json.encode(productsJson));
  }

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString('products');
    if (productsJson != null) {
      final List<dynamic> data = json.decode(productsJson);
      _products = data.map((json) => Product.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }
  
  void addToCart(Product product, [int quantity = 1]) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
    _saveToLocal();
  }
  
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _saveToLocal();
  }
  
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _saveToLocal();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveToLocal();
  }
  
  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = _items.map((item) => item.toJson()).toList();
    await prefs.setString('cart', json.encode(itemsJson));
  }
  
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString('cart');
    if (itemsJson != null) {
      final List<dynamic> data = json.decode(itemsJson);
      _items = data.map((json) => CartItem.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// ============================================
// SCREENS - الشاشات
// ============================================

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFF0A7B0A),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'الأقسام',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        if (cart.items.isEmpty) return SizedBox();
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                activeIcon: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        if (cart.items.isEmpty) return SizedBox();
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                label: 'السلة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          );
        },
        child: Icon(Icons.admin_panel_settings),
        backgroundColor: Color(0xFF0A7B0A),
        tooltip: 'دخول المدير',
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'كافتيريا الخير',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            background: Image.network(
              'https://cdn.pixabay.com/photo/2017/08/03/21/48/drinks-2578446_1280.jpg',
              fit: BoxFit.cover,
              color: Color(0xFF0A7B0A).withOpacity(0.7),
              colorBlendMode: BlendMode.multiply,
            ),
          ),
        ),
        
        SliverToBoxAdapter(
          child: _buildHeaderInfo(),
        ),
        
        SliverToBoxAdapter(
          child: _buildCategoriesSection(),
        ),
        
        SliverToBoxAdapter(
          child: _buildFeaturedSection(),
        ),
        
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(color: Color(0xFF0A7B0A)),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = provider.featuredProducts[index];
                          return _buildProductCard(product, context);
                        },
                        childCount: provider.featuredProducts.length,
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.access_time_filled, '24 ساعة', 'مفتوح دائماً'),
                _buildInfoItem(Icons.phone_android, 'واتساب', '730 528 609'),
                _buildInfoItem(Icons.location_on, 'العنوان', 'تعز - دمنة خدير'),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A7B0A), Color(0xFF4CAF50)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: Colors.white, size: 30),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خصم 15% على أول طلب',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'استخدم كود: WELCOME15',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF0A7B0A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Color(0xFF0A7B0A), size: 30),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: Color(0xFF0A7B0A)),
              SizedBox(width: 10),
              Text(
                'تصفح أقسامنا',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A7B0A),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    return _buildCategoryCard(category, context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(category: category),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(category.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.transparent, category.color.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(category.icon, color: Colors.white, size: 24),
              SizedBox(height: 5),
              Text(
                category.name,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 10),
              Text(
                'المنتجات المميزة',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A7B0A),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'أفضل ما لدينا من عصائر ووجبات خفيفة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(Icons.fastfood, size: 40, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    if (product.isFeatured)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'مميز',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final isInCart = cart.items.any((item) => item.product.id == product.id);
                          return IconButton(
                            icon: Icon(
                              isInCart ? Icons.check_circle : Icons.add_shopping_cart,
                              color: isInCart ? Colors.green : Color(0xFF0A7B0A),
                              size: 20,
                            ),
                            onPressed: () {
                              if (!isInCart) {
                                cart.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم إضافة ${product.name} إلى السلة',
                                      style: TextStyle(fontFamily: 'Almarai'),
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price} ريال',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A7B0A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
  final Category category;
  
  CategoryProductsScreen({required this.category});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name, style: TextStyle(fontFamily: 'Almarai')),
        backgroundColor: category.color,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = provider.getProductsByCategory(category.id);
          
          return products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 20),
                      Text(
                        'لا توجد منتجات في هذا القسم',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], context);
                  },
                );
        },
      ),
    );
  }
  
  Widget _buildProductCard(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  Text(
                    '${product.price} ريال',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: category.color,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartProvider>().addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم إضافة ${product.name} إلى السلة',
                            style: TextStyle(fontFamily: 'Almarai'),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text(
                      'أضف للسلة',
                      style: TextStyle(fontFamily: 'Almarai', fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: category.color,
                      minimumSize: Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  
  ProductDetailScreen({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0A7B0A),
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${product.price} ريال',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0A7B0A),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  Text(
                    'وصف المنتج',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  Text(
                    product.description,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  _buildAddToCartSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddToCartSection(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final cartItem = cartProvider.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'الكمية:',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: cartItem.quantity > 0
                          ? () => cartProvider.updateQuantity(product.id, cartItem.quantity - 1)
                          : null,
                      color: Colors.red,
                    ),
                    Container(
                      width: 40,
                      child: Center(
                        child: Text(
                          '${cartItem.quantity}',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => cartProvider.updateQuantity(product.id, cartItem.quantity + 1),
                      color: Color(0xFF0A7B0A),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () {
              if (cartItem.quantity == 0) {
                cartProvider.addToCart(product);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    cartItem.quantity == 0 
                        ? 'تم إضافة ${product.name} إلى السلة'
                        : 'تم تحديث الكمية',
                    style: TextStyle(fontFamily: 'Almarai'),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Text(
                cartItem.quantity == 0 ? 'إضافة إلى السلة' : 'تحديث السلة',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0A7B0A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سلة المشتريات', style: TextStyle(fontFamily: 'Almarai')),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return cart.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
                      SizedBox(height: 20),
                      Text(
                        'سلة المشتريات فارغة',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'أضف منتجات من المتجر',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(cart.items[index], context);
                        },
                      ),
                    ),
                    
                    _buildOrderSummary(context),
                  ],
                );
        },
      ),
    );
  }
  
  Widget _buildCartItem(CartItem item, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(item.product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          item.product.name,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${item.product.price} ريال × ${item.quantity}',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xFF0A7B0A),
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${item.totalPrice} ريال',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
                color: Color(0xFF0A7B0A),
              ),
            ),
            SizedBox(height: 5),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () {
                context.read<CartProvider>().removeFromCart(item.product.id);
              },
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context) {
    final cart = context.read<CartProvider>();
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع:',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${cart.totalPrice} ريال',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0A7B0A),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () {
              _showCheckoutDialog(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'إتمام الطلب',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0A7B0A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCheckoutDialog(BuildContext context) {
    final cart = context.read<CartProvider>();
    
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'إتمام الطلب',
              style: TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.w800),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر طريقة الدفع:',
                    style: TextStyle(fontFamily: 'Almarai', fontSize: 16),
                  ),
                  
                  SizedBox(height: 20),
                  
                  _buildPaymentOption(
                    Icons.money,
                    'الدفع نقداً عند الاستلام',
                    'استلم طلبك وادفع نقداً',
                    () => _sendOrder(context, 'نقداً عند الاستلام'),
                  ),
                  
                  SizedBox(height: 15),
                  
                  _buildPaymentOption(
                    Icons.account_balance_wallet,
                    'كريمي حاسب',
                    'حساب رقم: 1299834',
                    () => _sendOrder(context, 'كريمي حاسب (1299834)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(fontFamily: 'Almarai')),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildPaymentOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green[100]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF0A7B0A), size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Future<void> _sendOrder(BuildContext context, String paymentMethod) async {
    final cart = context.read<CartProvider>();
    
    String message = '🛒 *طلب جديد - كافتيريا الخير*\n\n';
    message += '*تفاصيل الطلب:*\n\n';
    
    for (var item in cart.items) {
      message += '✅ ${item.quantity}x ${item.product.name} - ${item.totalPrice} ريال\n';
    }
    
    message += '\n*المجموع:* ${cart.totalPrice} ريال\n';
    message += '*طريقة الدفع:* $paymentMethod\n';
    message += '----------------\n';
    message += '*📍 العنوان:* تعز - دمنة خدير - امام الملك فون\n';
    message += '*📞 رقم التواصل:* +967730528609\n';
    message += '*⏰ نعمل 24 ساعة*\n';
    message += 'شكراً لثقتكم بكافتيريا الخير 🌹';
    
    String url = 'https://wa.me/967730528609?text=${Uri.encodeComponent(message)}';
    
    if (await canLaunch(url)) {
      await launch(url);
      cart.clearCart();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح واتساب', style: TextStyle(fontFamily: 'Almarai')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حسابي', style: TextStyle(fontFamily: 'Almarai')),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person, color: Color(0xFF0A7B0A)),
              title: Text('معلومات الحساب', style: TextStyle(fontFamily: 'Almarai')),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          
          Card(
            child: ListTile(
              leading: Icon(Icons.shopping_bag, color: Color(0xFF0A7B0A)),
              title: Text('طلباتي السابقة', style: TextStyle(fontFamily: 'Almarai')),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite, color: Color(0xFF0A7B0A)),
              title: Text('المفضلة', style: TextStyle(fontFamily: 'Almarai')),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          
          Card(
            child: ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF0A7B0A)),
              title: Text('الإعدادات', style: TextStyle(fontFamily: 'Almarai')),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
          
          Card(
            child: ListTile(
              leading: Icon(Icons.help, color: Color(0xFF0A7B0A)),
              title: Text('المساعدة والدعم', style: TextStyle(fontFamily: 'Almarai')),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchWhatsApp(),
            ),
          ),
          
          SizedBox(height: 30),
          
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات الاتصال',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                SizedBox(height: 15),
                
                _buildContactInfo(Icons.phone, '+967 730 528 609'),
                _buildContactInfo(Icons.location_on, 'تعز - دمنة خدير - امام الملك فون'),
                _buildContactInfo(Icons.access_time, 'مفتوح 24 ساعة'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF0A7B0A), size: 20),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchWhatsApp() async {
    String url = 'https://wa.me/967730528609';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class AdminLoginScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دخول المدير', style: TextStyle(fontFamily: 'Almarai')),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Color(0xFF0A7B0A),
            ),
            
            SizedBox(height: 30),
            
            Text(
              'لوحة تحكم المدير',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0A7B0A),
              ),
            ),
            
            SizedBox(height: 10),
            
            Text(
              'أدخل كلمة المرور للدخول',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 30),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: TextStyle(fontFamily: 'Almarai'),
            ),
            
            SizedBox(height: 20),
            
            Text(
              'كلمة المرور الافتراضية: admin123',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            
            SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == 'admin123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPanel()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'كلمة المرور غير صحيحة',
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Text(
                    'دخول',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A7B0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم المدير', style: TextStyle(fontFamily: 'Almarai')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.engineering, size: 80, color: Color(0xFF0A7B0A)),
            SizedBox(height: 20),
            Text(
              'لوحة التحكم قيد التطوير',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'سيتم إضافتها في الإصدار القادم',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
