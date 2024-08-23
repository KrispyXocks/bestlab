// import 'package:flutter/material.dart';
// import 'package:bestlab/components/row.dart';
// import 'package:bestlab/components/my_search_bar.dart';
// import 'login_page.dart'; // Ensure this imports the AuthService
//
// class UserList extends StatefulWidget {
//   @override
//   _UserListState createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//   late List<Map<String, dynamic>> users;
//   late List<Map<String, dynamic>> filteredUsers;
//   late TextEditingController searchController;
//   final AuthService authService = AuthService();
//   bool isLoading = true;
//   String? errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     fetchUsers();
//
//     // Listen to changes in the search query
//     searchController.addListener(() {
//       _filterUsers(searchController.text);
//     });
//   }
//
//   Future<void> fetchUsers() async {
//     try {
//       List<Map<String, dynamic>> allUsers = await authService.getAllUsers();
//       users = allUsers.where((user) => user['systemRole'] == 'user').toList();
//
//       setState(() {
//         filteredUsers = users;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load users';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _removeItem(int index) async {
//     final username = filteredUsers[index]['username'];
//     final userId = filteredUsers[index]['userID']; // Use 'userID' if that's your UUID field
//
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Deletion'),
//           content: Text('Are you sure you want to delete $username?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//             TextButton(
//               child: Text('Delete'),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     );
//
//     if (shouldDelete == true) {
//       try {
//         await authService.deleteUser(userId);
//
//         setState(() {
//           filteredUsers.removeAt(index);
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("$username deleted")),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to delete $username")),
//         );
//       }
//     }
//   }
//
//   void _filterUsers(String query) {
//     setState(() {
//       filteredUsers = users
//           .where((user) => user['username'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Users',
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               // Add your settings logic here
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : errorMessage != null
//           ? Center(child: Text(errorMessage!))
//           : Column(
//         children: [
//           const SizedBox(height: 15),
//           MySearchBar(
//             controller: searchController,
//             hintText: 'Search users...',
//             onChanged: _filterUsers,
//           ),
//           const SizedBox(height: 15),
//           Expanded(
//             child: filteredUsers.isEmpty
//                 ? Center(child: Text('No users found'))
//                 : ListView.builder(
//               itemCount: filteredUsers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: CircleAvatar(
//                     child: Icon(Icons.person),
//                   ),
//                   title: Text(filteredUsers[index]['username']),
//                   subtitle: Text('User ID: ${filteredUsers[index]['userID']}'), // Use 'userID' if that's your UUID field
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       _removeItem(index);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:bestlab/components/row.dart';
import 'package:bestlab/components/my_search_bar.dart';
import '../login_page.dart'; // Ensure this imports the AuthService

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late List<Map<String, dynamic>> users;
  late List<Map<String, dynamic>> filteredUsers;
  late TextEditingController searchController;
  final AuthService authService = AuthService();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchUsers();

    // Listen to changes in the search query
    searchController.addListener(() {
      _filterUsers(searchController.text);
    });
  }

  Future<void> fetchUsers() async {
    try {
      List<Map<String, dynamic>> allUsers = await authService.getAllUsers();
      users = allUsers.where((user) => user['systemRole'] == 'user').toList();

      setState(() {
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load users';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _removeItem(int index) async {
    final username = filteredUsers[index]['username'];
    final userId = filteredUsers[index]['userID']; // Use 'userID' if that's your UUID field

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete $username?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await authService.deleteUser(userId);

        setState(() {
          filteredUsers.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$username deleted")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete $username")),
        );
      }
    }
  }

  Future<void> _upgradeRole(int index) async {
    final username = filteredUsers[index]['username'];
    final userId = filteredUsers[index]['userID']; // Use 'userID' if that's your UUID field
    final currentRole = filteredUsers[index]['systemRole'];

    final newRole = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upgrade Role'),
          content: Container(
            width: double.maxFinite, // Ensures the container takes full width
            height: 200.0, // Adjust height as needed
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true, // Prevents the ListView from expanding infinitely
                children: ['admin', 'owner', 'user']
                    .where((role) => role != currentRole)
                    .map((role) {
                  return ListTile(
                    title: Text(role),
                    onTap: () {
                      Navigator.of(context).pop(role);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    if (newRole != null) {
      try {
        await authService.updateUserRole(userId, newRole);

        setState(() {
          filteredUsers[index]['systemRole'] = newRole;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$username upgraded to $newRole")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upgrade $username")),
        );
      }
    }
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) => user['username'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings logic here
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Column(
        children: [
          const SizedBox(height: 15),
          MySearchBar(
            controller: searchController,
            hintText: 'Search users...',
            onChanged: _filterUsers,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(child: Text('No users found'))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(filteredUsers[index]['username']),
                  subtitle: Text('User ID: ${filteredUsers[index]['userID']}'), // Use 'userID' if that's your UUID field
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.upgrade, color: Colors.blue),
                        onPressed: () {
                          _upgradeRole(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removeItem(index);
                        },
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