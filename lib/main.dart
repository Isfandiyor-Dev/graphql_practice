import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_practice/config/graphql_config.dart';
import 'package:graphql_practice/views/screens/home_screen.dart';

void main() {
  final client = GraphqlConfig.initializeClient();

  runApp(MainApp(client: client));
}

class MainApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MainApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
