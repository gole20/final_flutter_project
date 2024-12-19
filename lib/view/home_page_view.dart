import 'package:flutter/material.dart';

void main() {
  runApp(const HomePageView());
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OrderPage(),
    const MyListPage(),
    const ProfilePage(),
  ];

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
          backgroundColor: Colors.transparent,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                hintText: "Search any shoes",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Visual Design",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                children: [
                  Image.asset('assets/nike.png', fit: BoxFit.cover),
                  Image.asset('assets/new.png', fit: BoxFit.cover),
                  Image.asset('assets/jordan.png', fit: BoxFit.cover),
                  Image.asset('assets/balance.png', fit: BoxFit.cover),
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
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Order Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MyListPage extends StatelessWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My List Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
