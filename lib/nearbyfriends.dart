import 'package:flutter/material.dart';
import 'mock_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation Social App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NearbyFriendsScreen(),
    );
  }
}

class NearbyFriendsScreen extends StatefulWidget {
  @override
  _NearbyFriendsScreenState createState() => _NearbyFriendsScreenState();
}

class _NearbyFriendsScreenState extends State<NearbyFriendsScreen> {
  List<Map<String, dynamic>> nearbyFriends = mockFriends;
  double containerWidth = 300;
  double containerHeight = 500;

  String? selectedFriendId;
  TextEditingController messageController = TextEditingController();
  Map<String, List<String>> messages = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Friends'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              containerWidth += details.localPosition.dx;
              containerHeight += details.localPosition.dy;
            });
          },
          child: Container(
            width: containerWidth,
            height: containerHeight,
            margin: EdgeInsets.all(16),
            color: Color(0xFFB1E5E3),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 16),
            Text(
              "You are sharing your location",
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nearbyFriends.length,
                itemBuilder: (context, index) {
                  final friend = nearbyFriends[index];
                  return ListTile(
                    title: Text(friend['id']),
                    subtitle: Text(
                      'Distance: ${friend['distance'].toStringAsFixed(1)} km',
                    ),
                    trailing: Icon(Icons.person),
                    onTap: () {
                      setState(() {
                        selectedFriendId = friend['id'];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  nearbyFriends = List.from(mockFriends)..shuffle();
                });
              },
              child: Text("Refresh Nearby Friends"),
            ),
          ),
        ),
        if (selectedFriendId != null)
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          selectedFriendId = null;
                          messageController.clear();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      '${_getFriendName(selectedFriendId)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      reverse: true, // Display messages in reverse order
                      itemCount: messages[selectedFriendId]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final message = messages[selectedFriendId]![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.blue.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: 'Type your message',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedFriendId != null) {
                        setState(() {
                          String message = messageController.text;
                          if (message.isNotEmpty) {
                            messages[selectedFriendId!] ??= [];
                            messages[selectedFriendId!]!.add(message);
                            messageController.clear();
                          }
                        });
                      }
                    },
                    child: Text("Send"),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _getFriendName(String? friendId) {
    final friend = nearbyFriends.firstWhere((friend) => friend['id'] == friendId);
    return friend['id'] ?? 'Unknown';
  }
}
