import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

Future<List<UserModel>> fetchUsers() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    List jsonResponse = json.decode(response.body);
    // Map each item to a User object
    return jsonResponse.map((user) => UserModel.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<UserModel>> futureUsers;
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(); // Fetch data when the screen is loaded

    futureUsers.then((users) {
      setState(() {
        _users = users;
        _filteredUsers = users; // Initially show all users
      });
    });
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        List<String> searchableFields = [
          user.name.toLowerCase(),
          user.username.toLowerCase(),
          user.email.toLowerCase(),
          user.company.name.toLowerCase(),
        ];
        return searchableFields.any((field) => field.contains(query));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: appBar(context),
      drawer: isMobile ? drawer(context) : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search by name or company",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return _filteredUsers.isNotEmpty
                    ? Center(
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width),
                          child: dataTable(),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("No results found!"),
                      );
              },
            ), // This trailing comma makes auto-formatting nicer for build methods.
          )
        ],
      ),
    );
  }

  PaginatedDataTable dataTable() {
    return PaginatedDataTable(
      header: const Text('Users'),
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Company')),
      ],
      source: UserDataSource(_filteredUsers),
      rowsPerPage: 5, columnSpacing: 120, // Space between columns
    );
  }

  AppBar appBar(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      actions: !isMobile
          ? [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/about'); // Navigate to the About page
                },
                child: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]
          : null,
    );
  }

  Theme drawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor:
            Colors.white, // Change this if you want a custom background color
      ),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Removes the rounded corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 78.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<UserModel> users;

  UserDataSource(this.users);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;

    final user = users[index];
    return DataRow(cells: [
      DataCell(Text(user.id.toString())),
      DataCell(Text(user.name)),
      DataCell(Text(user.username)),
      DataCell(Text(user.email)),
      DataCell(Text(user.company.name)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => users.length;
  @override
  int get selectedRowCount => 0;
}
