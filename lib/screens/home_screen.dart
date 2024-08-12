import 'package:flutter/material.dart';
import 'package:seek_commerce/provider/auth_provider.dart';
import 'package:seek_commerce/screens/product_detail_screen.dart';
import 'package:seek_commerce/screens/profile_screen.dart';
import 'package:seek_commerce/services/category_service.dart';

import '../components/top_products.dart';
import '../models/users.dart';
import '../services/product_search_delegate.dart';
import '../theme/app_theme.dart';
import '../models/products.dart';
import '../models/categories.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import 'explore_screen.dart';
import 'notifications_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List screens = [
    HomeScreenWidget(),
    ExploreScreen(),
    OrdersScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: iconColor,
          selectedLabelStyle: bodyText10(),
          unselectedLabelStyle: bodyText10(),
          onTap: (value) {
            setState(() => currentIndex = value);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_add_check), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
      body: screens[currentIndex],
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  User user = AuthProvider().getProfile() as User;
  late Future<List<Category>> categories;
  late Future<List<Product>> topProducts;
  late Future<List<Product>> suggestedProducts;

  @override
  void initState() {
    super.initState();
    categories = CategoryService().fetchCategories();
    topProducts = ProductService().fetchTopProducts();
    suggestedProducts = ProductService().fetchSuggestedProducts();
  }

  void _navigateToExplore({String? query, String? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreScreen(
          query: query,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: primaryColor,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome to Seek Commerce',
              style: headerText24().copyWith(color: textLightColor)),
          const SizedBox(height: 2),
          Text(user.name, style: bodyText14().copyWith(color: textLight1Color)),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Categories
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories', style: headerText18()),
                ],
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<List<Category>>(
                  future: categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No category found'));
                    } else {
                      return Container(
                        //height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _navigateToExplore(
                                    category: snapshot.data![index].categoryName);
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          snapshot.data![index].categoryImage),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(snapshot.data![index].categoryName, style: bodyText14(),),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  })
            ]),
            const SizedBox(height: 14.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Products', style: headerText18()),
                  ],
                ),
                const SizedBox(height: 10.0),
                FutureBuilder<List<Product>>(
                  future: topProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found'));
                    } else {
                      return Container(
                        height: 200.0, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Product product = snapshot.data![index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                  product: product)));
                                },
                                child: TopProducts(product: product));
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Suggested Products', style: headerText18()),
                  ],
                ),
                const SizedBox(height: 10.0),
                FutureBuilder<List<Product>>(
                    future: suggestedProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found'));
                      } else {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                  product:
                                                  snapshot.data![index])));
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                          snapshot.data![index].imagePaths[0],
                                          width: double.infinity,
                                          height: 150,
                                          fit: BoxFit.cover),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(snapshot.data![index].name),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                            '\$ ${snapshot.data![index].price.toString()}'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ],
            )
          ]),
        ),
      )
    );

  }
}
