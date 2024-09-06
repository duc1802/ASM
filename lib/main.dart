import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Tự động gọi hàm để lấy danh sách sản phẩm khi khởi tạo.
  }

  // Hàm GET để lấy danh sách sản phẩm
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://t2210m-flutter.onrender.com/products'));

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      print('Failed to load products');
    }
  }

  // Hàm POST để tạo sản phẩm mới
  Future<void> createProduct() async {
    final response = await http.post(
      Uri.parse('https://t2210m-flutter.onrender.com/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'price': 2000,
        'name': 'iphone 16',
        'description': 'the new product 16'
      }),
    );

    if (response.statusCode == 201) {
      print('Product created successfully');
      fetchProducts(); // Cập nhật danh sách sản phẩm sau khi tạo mới
    } else {
      print('Failed to create product');
    }
  }

  // Hàm PUT để cập nhật thông tin sản phẩm
  Future<void> updateProduct(String id) async {
    final response = await http.put(
      Uri.parse('https://t2210m-flutter.onrender.com/products/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'price': 2500,
        'name': 'iphone 17',
        'description': 'the new product 17'
      }),
    );

    if (response.statusCode == 200) {
      print('Product updated successfully');
      fetchProducts(); // Cập nhật danh sách sản phẩm sau khi chỉnh sửa
    } else {
      print('Failed to update product');
    }
  }

  // Hàm DELETE để xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('https://t2210m-flutter.onrender.com/products/$id'));

    if (response.statusCode == 200) {
      print('Product deleted successfully');
      fetchProducts(); // Cập nhật danh sách sản phẩm sau khi xóa
    } else {
      print('Failed to delete product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter CRUD App'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: createProduct,
            child: Text('Create Product'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(product['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => updateProduct(product['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteProduct(product['id']),
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
