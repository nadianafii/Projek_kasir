import 'package:flutter/material.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> products = [
    {
      "images": "assets/images/Blush.png",
      "name": "Blush",
      "category": "Makeup",
      "price": 500000,
      "stock": 15,
    },
    {
      "images": "assets/images/Complexion.png",
      "name": "Complexion",
      "category": "Makeup",
      "price": 1000000,
      "stock": 17,
    },
    {
      "images": "assets/images/Eyebrow.png",
      "name": "Eyebrow",
      "category": "Makeup",
      "price": 70000,
      "stock": 5,
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  int _totalItem = 0;
  int _totalHarga = 0;

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(products);
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterProducts);
    searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(query) ||
              product['category'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peringatan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateItemBeli(int index, int delta) async {
    setState(() {
      final currentStock = _filteredProducts[index]['stock'] as int;
      final currentQuantity = _filteredProducts[index]['quantity'] ?? 0;

      if (delta > 0 && currentStock > 0) {
        // Penambahan item (tidak melebihi stok)
        _filteredProducts[index]['stock'] = currentStock - 1;
        _filteredProducts[index]['quantity'] = currentQuantity + 1;
        _totalItem++;
        _totalHarga += _filteredProducts[index]['price'] as int;
      } else if (delta < 0 && currentQuantity > 0) {
        // Pengurangan item (tidak boleh negatif)
        _filteredProducts[index]['stock'] = currentStock + 1;
        _filteredProducts[index]['quantity'] = currentQuantity - 1;
        _totalItem--;
        _totalHarga -= _filteredProducts[index]['price'] as int;
      } else {
        // Menampilkan alert jika stok habis atau jumlah item 0
        String errorMessage = delta > 0
            ? "Stok kosong! Tidak bisa membeli lebih dari stok yang tersedia."
            : "Tidak ada item untuk dikurangi!";
        _showAlert(errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cashier App",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "Semoga Harimu menyenangkan :D",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari Produk....',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "${_filteredProducts[index]['images']}",
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_filteredProducts[index]['name']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "Stock = ${_filteredProducts[index]['stock']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Rp. ${_filteredProducts[index]['price']}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible:
                                          (_filteredProducts[index]['quantity'] ?? 0) >
                                              0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _updateItemBeli(index, -1);
                                        },
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Icon(
                                            Icons.remove_circle_outline_rounded,
                                            color: Colors.red[400],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: Text(
                                          "${_filteredProducts[index]['quantity'] ?? 0}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _filteredProducts[index]['stock'] > 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _updateItemBeli(index, 1);
                                        },
                                        child: const SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Icon(
                                            Icons.add_circle_outline_outlined,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 55,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total ($_totalItem item) = Rp. $_totalHarga",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.shopping_cart_checkout_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
