import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  // Search query state
  String _searchQuery = '';

  // Mock Data: Added image assets and active status indicators
  final List<Map<String, dynamic>> _chatsData = [
    {
      'group': 'Hunza Trip Squad 🏔️',
      'lastMsg': 'Zain: Kal subah 6 baje nikalna h sab ne!',
      'time': '10:42 AM',
      'unread': '3',
      'isLiveNow': true, // Active status badge k liye
      'imageUrl': 'https://images.unsplash.com/photo-1624555130581-1d9cca783bc0?w=150'
    },
    {
      'group': 'Amalfi Coast Planning 🗺️',
      'lastMsg': 'Ayesha: Hotel bookings are confirmed.',
      'time': 'Yesterday',
      'unread': '0',
      'isLiveNow': false,
      'imageUrl': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Locally filter group chats based on search query
    final filteredChats = _chatsData.where((chat) {
      return chat['group'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Group Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔎 1. Quick Group Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488)),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Chats Active List Container
          Expanded(
            child: filteredChats.isEmpty
                ? Center(
              child: Text(
                'No groups found',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final item = filteredChats[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                    // 🖼️ 2. Premium Group Avatar with Live/On-trip active status indicator
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
                          backgroundImage: NetworkImage(item['imageUrl']),
                        ),
                        if (item['isLiveNow'] == true)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E), // Live Neon Green Dot
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.cardColor, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Group Title
                    title: Text(
                      item['group']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    // Last Message
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item['lastMsg']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13),
                      ),
                    ),

                    // Trailing Action Info Blocks (No Squeezed Row Issues)
                    trailing: SizedBox(
                      width: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['time']!,
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                          ),
                          if (item['unread'] != '0') ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D9488),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                item['unread']!,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupChatRoomScreen(groupName: item['group']!),
                        ),
                      );
                    },
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

// --- Individual Group Chat Room Screen Placeholder ---
class GroupChatRoomScreen extends StatelessWidget {
  final String groupName;
  const GroupChatRoomScreen({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: theme.cardColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Messages will appear here live from database.\n(Only authorized trip members can see this)',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D9488),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}