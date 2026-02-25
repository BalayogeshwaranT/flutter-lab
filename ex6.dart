import 'package:flutter/material.dart';

void main() =>
    runApp(const MaterialApp(home: Store(), debugShowCheckedModeBanner: false));

class Store extends StatefulWidget {
  const Store({super.key});
  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<Map> items = [
    {"n": "Shoes", "p": 2000, "i": Icons.directions_run},
    {"n": "T-Shirt", "p": 800, "i": Icons.checkroom},
    {"n": "Watch", "p": 15000, "i": Icons.watch},
    {"n": "Laptop", "p": 55000, "i": Icons.laptop},
    {"n": "Phone", "p": 15000, "i": Icons.smartphone},
  ];
  List<Map> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store"),
        actions: [
          Badge(
            label: Text("${cart.length}"),
            isVisible: cart.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => cartScreen()),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: items
            .map(
              (e) => ListTile(
                leading: Icon(e["i"]),
                title: Text(e["n"]),
                subtitle: Text("₹${e["p"]}"),
                trailing: FilledButton(
                  child: const Text("Add"),
                  onPressed: () {
                    setState(() => cart.add(e));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Added"),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget cartScreen() {
    int total = cart.fold(0, (s, item) => s + (item["p"] as int));
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Empty"))
          : ListView(
              children: cart
                  .map(
                    (e) => ListTile(
                      title: Text(e["n"]),
                      trailing: Text("₹${e["p"]}"),
                    ),
                  )
                  .toList(),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => checkout(total)),
                ),
                child: Text("Checkout ₹$total"),
              ),
            ),
    );
  }

  Widget checkout(int total) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            Text("Total: ₹$total", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                setState(() => cart.clear());
                Navigator.popUntil(context, (r) => r.isFirst);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Ordered!")));
              },
              child: const Text("PLACE ORDER & RESET"),
            ),
          ],
        ),
      ),
    );
  }
}
