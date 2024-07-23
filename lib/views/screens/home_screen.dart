import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_practice/core/constants/graphql_mutations.dart';
import 'package:graphql_practice/core/constants/graphql_queries.dart';
import 'package:graphql_practice/models/product_model.dart';
import 'package:graphql_practice/views/widgets/add_product_dialog.dart';
import 'package:graphql_practice/views/widgets/edit_product_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _createProduct(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    var data = await showDialog(
      context: context,
      builder: (context) {
        return const AddProductDialog();
      },
    );

    if (data != null) {
      var response = await client.mutate(
        MutationOptions(
          document: gql(createProduct),
          variables: {
            'title': data['title'],
            'price': data['price'],
            'description': data['description'],
            'categoryId': data['categoryId'],
            'images': data['images'],
          },
          onCompleted: (data) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mahsulot qo'shildi!"),
              ),
            );
            setState(() {});
          },
        ),
      );
      print(response.data);
    }
  }

  void showEditProductDialog(BuildContext context, Product product) async {
    final client = GraphQLProvider.of(context).value;
    var data = await showDialog(
      context: context,
      builder: (context) {
        return EditProductDialog(
          product: product,
        );
      },
    );

    if (data != null) {
      var response = await client.mutate(
        MutationOptions(
          document: gql(updateProduct),
          variables: {
            'id': product.id,
            'title': data['title'],
            'price': data['price'],
            'description': data['description'],
            'categoryId': data['categoryId'],
            'images': data['images'],
          },
          onCompleted: (data) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mahsulot yangilandi!"),
              ),
            );
            setState(() {});
          },
        ),
      );
      print(response.data);
    } else {
      print('Edit dialog returned null');
    }
  }

  void _deleteProduct(BuildContext context, String id) async {
    final client = GraphQLProvider.of(context).value;

    var response = await client.mutate(
      MutationOptions(
        document: gql(deleteProduct),
        variables: {
          'id': id,
        },
        onCompleted: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Mahsulot o'chirildi!"),
            ),
          );
          setState(() {});
        },
      ),
    );
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Query(
        options: QueryOptions(document: gql(fetchProducts)),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List products = result.data!['products'];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = Product.fromJson(products[index]);
              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.blueAccent,
                child: ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showEditProductDialog(context, product);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteProduct(context, product.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
