import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShoeProduct {
  final String name;
  final String image;
  final List<String> sizes;
  final double price;
  final String description;
  bool isFavorite;
  String? selectedSize;

  ShoeProduct({
    required this.name,
    required this.image,
    required this.sizes,
    required this.price,
    required this.description,
    this.isFavorite = false,
    this.selectedSize,
  });
}

class ShoeNotification {
  final String title;
  final String message;
  final DateTime timestamp;
  final ShoeProduct? product;
  bool isRead;

  ShoeNotification({
    required this.title,
    required this.message,
    required this.timestamp,
    this.product,
    this.isRead = false,
  });
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0;
  List<ShoeProduct> orderedProducts = [];
  List<ShoeProduct> favoriteProducts = [];
  List<ShoeProduct> checkedOutOrders = [];
  List<ShoeNotification> notifications = [];
  double totalAmount = 0;

  void addNotification(String title, String message, {ShoeProduct? product}) {
    setState(() {
      notifications.insert(
        0,
        ShoeNotification(
          title: title,
          message: message,
          timestamp: DateTime.now(),
          product: product,
        ),
      );
    });
  }

  void markNotificationsAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  void addToOrders(ShoeProduct product) {
    setState(() {
      orderedProducts.add(product);
      calculateTotal();
      addNotification(
        'Product Added to Cart',
        '${product.name} (Size: ${product.selectedSize}) has been added to your cart.',
        product: product,
      );
    });
  }

  void removeFromOrders(ShoeProduct product) {
    setState(() {
      orderedProducts.remove(product);
      calculateTotal();
    });
  }

  void toggleFavorite(ShoeProduct product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
      if (product.isFavorite) {
        favoriteProducts.add(product);
      } else {
        favoriteProducts.remove(product);
      }
    });
  }

  void checkoutOrders() {
    setState(() {
      checkedOutOrders.addAll(orderedProducts);
      addNotification(
        'Order Placed Successfully',
        'Your order of ${orderedProducts.length} items has been placed successfully. Total: \$${totalAmount.toStringAsFixed(2)}',
      );
      orderedProducts.clear();
      calculateTotal();
    });
  }

  void calculateTotal() {
    totalAmount =
        orderedProducts.fold(0, (sum, product) => sum + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat-Bold',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: const Text(
            'Kickback Shoes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(
                          notifications: notifications,
                          onMarkAsRead: markNotificationsAsRead,
                        ),
                      ),
                    );
                  },
                ),
                if (unreadNotificationsCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadNotificationsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.black,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/default_profile.png'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Mrinal Lama',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Home'),
                      onTap: () {
                        setState(() => _selectedIndex = 0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text('My Orders'),
                      trailing: orderedProducts.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${orderedProducts.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedIndex = 1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text('Favorites'),
                      trailing: favoriteProducts.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${favoriteProducts.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedIndex = 2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      onTap: () {
                        setState(() => _selectedIndex = 3);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
        body: _selectedIndex == 0
            ? HomePage(
                onAddToOrders: addToOrders,
                onToggleFavorite: toggleFavorite,
              )
            : _selectedIndex == 1
                ? OrderPage(
                    orderedProducts: orderedProducts,
                    totalAmount: totalAmount,
                    onRemoveFromOrders: removeFromOrders,
                    onCheckout: checkoutOrders,
                  )
                : _selectedIndex == 2
                    ? MyListPage(
                        favoriteProducts: favoriteProducts,
                        onToggleFavorite: toggleFavorite,
                      )
                    : ProfilePage(checkedOutOrders: checkedOutOrders),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "ORDER"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "MY LIST"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(ShoeProduct) onAddToOrders;
  final Function(ShoeProduct) onToggleFavorite;

  const HomePage({
    super.key,
    required this.onAddToOrders,
    required this.onToggleFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  List<ShoeProduct> get _products => [
        ShoeProduct(
          name: 'Nike Air Max',
          image: 'assets/nike.png',
          sizes: ['7', '8', '9', '10', '11'],
          price: 129.99,
          description:
              'Classic Nike Air Max sneakers with superior comfort and style.',
        ),
        ShoeProduct(
          name: 'New Balance 574',
          image: 'assets/new.png',
          sizes: ['7', '8', '9', '10'],
          price: 89.99,
          description: 'Iconic New Balance design with premium cushioning.',
        ),
        ShoeProduct(
          name: 'Air Jordan 1',
          image: 'assets/jordan.png',
          sizes: ['8', '9', '10', '11'],
          price: 179.99,
          description:
              'Legendary Air Jordan 1 with premium leather construction.',
        ),
        ShoeProduct(
          name: 'NB Fresh Foam',
          image: 'assets/balance.png',
          sizes: ['7', '8', '9', '10'],
          price: 109.99,
          description:
              'New Balance Fresh Foam technology for ultimate comfort.',
        ),
        ShoeProduct(
          name: 'Nike Zoom',
          image: 'assets/nike.png',
          sizes: ['7', '8', '9', '10', '11'],
          price: 149.99,
          description:
              'High-performance Nike Zoom for superior responsiveness.',
        ),
        ShoeProduct(
          name: 'Air Jordan Retro',
          image: 'assets/jordan.png',
          sizes: ['8', '9', '10', '11'],
          price: 199.99,
          description: 'Classic Air Jordan Retro design with modern comfort.',
        ),
        ShoeProduct(
          name: 'New Balance X-90',
          image: 'assets/new.png',
          sizes: ['7', '8', '9', '10'],
          price: 119.99,
          description: 'Modern New Balance design with retro inspiration.',
        ),
        ShoeProduct(
          name: 'Nike React',
          image: 'assets/nike.png',
          sizes: ['7', '8', '9', '10', '11'],
          price: 159.99,
          description: 'Nike React technology for responsive cushioning.',
        ),
      ];

  List<ShoeProduct> get _filteredProducts => _products
      .where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WELCOME !",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 5.0),
            const Text(
              "Find comfort and flair in every step",
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                hintText: "Search by name or description",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Featured Shoes",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    '${_filteredProducts.length} results',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No products available'
                                : 'No results found for "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  product: product,
                                  onAddToOrders: widget.onAddToOrders,
                                  onToggleFavorite: widget.onToggleFavorite,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                        child: Image.asset(
                                          product.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Sizes: ${product.sizes.join(", ")}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      product.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: product.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () =>
                                        widget.onToggleFavorite(product),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final ShoeProduct product;
  final Function(ShoeProduct) onAddToOrders;
  final Function(ShoeProduct) onToggleFavorite;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToOrders,
    required this.onToggleFavorite,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.product.isFavorite ? Colors.red : null,
            ),
            onPressed: () => widget.onToggleFavorite(widget.product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.asset(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.product.sizes.length,
                      itemBuilder: (context, index) {
                        final size = widget.product.sizes[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(size),
                            selected: widget.product.selectedSize == size,
                            onSelected: (selected) {
                              setState(() {
                                widget.product.selectedSize =
                                    selected ? size : null;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: widget.product.selectedSize == null
                          ? null
                          : () {
                              widget.onAddToOrders(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Added to orders - Size: ${widget.product.selectedSize}'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add to Orders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

class OrderPage extends StatelessWidget {
  final List<ShoeProduct> orderedProducts;
  final double totalAmount;
  final Function(ShoeProduct) onRemoveFromOrders;
  final VoidCallback onCheckout;

  const OrderPage({
    super.key,
    required this.orderedProducts,
    required this.totalAmount,
    required this.onRemoveFromOrders,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: orderedProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: orderedProducts.length,
                    itemBuilder: (context, index) {
                      final product = orderedProducts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Image.asset(
                            product.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                              'Size: ${product.selectedSize} - \$${product.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => onRemoveFromOrders(product),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (orderedProducts.isNotEmpty) ...[
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amou:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Show checkout success dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success!'),
                      content: const Text('Your order has been placed.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onCheckout();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MyListPage extends StatelessWidget {
  final List<ShoeProduct> favoriteProducts;
  final Function(ShoeProduct) onToggleFavorite;

  const MyListPage({
    super.key,
    required this.favoriteProducts,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Favorites',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: favoriteProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No favorites yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: Image.asset(
                                      product.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () => onToggleFavorite(product),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final List<ShoeProduct> checkedOutOrders;

  const ProfilePage({
    super.key,
    required this.checkedOutOrders,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Mrinal Lama');
  final TextEditingController _addressController =
      TextEditingController(text: 'Gokarna, Kathmandu');
  final TextEditingController _phoneController =
      TextEditingController(text: '+977 9812131415');
  File? _profileImage;
  bool _isEditing = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                      ),
                      if (_isEditing)
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          _nameController.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 8),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ] else ...[
                    Text(
                      _addressController.text,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phoneController.text,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  widget.checkedOutOrders.isEmpty
                      ? const Center(
                          child: Text(
                            'No orders in history',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.checkedOutOrders.length,
                          itemBuilder: (context, index) {
                            final order = widget.checkedOutOrders[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: Image.asset(
                                  order.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(order.name),
                                subtitle: Text(
                                  'Size: ${order.selectedSize} - \$${order.price.toStringAsFixed(2)}',
                                ),
                                trailing: const Icon(Icons.check_circle,
                                    color: Colors.green),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Orders:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.checkedOutOrders.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

class NotificationsPage extends StatelessWidget {
  final List<ShoeNotification> notifications;
  final VoidCallback onMarkAsRead;

  const NotificationsPage({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            onMarkAsRead();
            Navigator.pop(context);
          },
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          notification.isRead ? Colors.grey : Colors.black,
                      child: Icon(
                        notification.product != null
                            ? Icons.shopping_bag
                            : Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.message),
                        const SizedBox(height: 4),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
