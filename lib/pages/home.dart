import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

Future<List<UserModel>> fetchUsers() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/pedrosantos992/web_dash_fl/main/assets/users.json'));

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
          user.country.toLowerCase(),
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
                  hintText: "Search by name",
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
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Country')),
        DataColumn(label: Text('Shirt Size')),
        DataColumn(label: Text('')),
      ],
      source: UserDataSource(_filteredUsers, context),
      rowsPerPage: 10, columnSpacing: 40, // Space between columns
    );
  }

  AppBar appBar(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      actions: !isMobile
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/analytics');
                  },
                  child: const Text(
                    'Analytics',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact-us');
                  },
                  child: const Text(
                    'Contact us',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
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
              leading: const Icon(Icons.bar_chart),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pushNamed(context, '/analytics');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact us'),
              onTap: () {
                Navigator.pushNamed(context, '/contact-us');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            )
          ],
        ),
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<UserModel> users;
  final BuildContext context;

  UserDataSource(this.users, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;

    final user = users[index];
    return DataRow(cells: [
      DataCell(Text(user.name)),
      DataCell(Text(user.username)),
      DataCell(Text(user.email)),
      DataCell(Text(user.country)),
      DataCell(Text(user.shirtSize)),
      DataCell(
        TextButton(
          onPressed: () {
            showUserDialog(user);
          },
          child: const Icon(Icons.visibility),
        ),
      ),
    ]);
  }

  Future<dynamic> showUserDialog(UserModel user) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildUserInfo([
                'Name: ${user.name}',
                'Username: ${user.username}',
                'Email: ${user.email}',
                'Country: ${user.country}',
                'Shirt Size: ${user.shirtSize}',
              ]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => users.length;
  @override
  int get selectedRowCount => 0;
}

List<Widget> _buildUserInfo(List<String> userInfo) {
  return userInfo.map((info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(info),
    );
  }).toList();
}
